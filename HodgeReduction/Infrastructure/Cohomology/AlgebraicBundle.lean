/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# Abstract algebraic vector bundles and their Chern classes

This file abstracts the notion of an **algebraic vector bundle on a
smooth projective variety** by capturing what we need for the
Hodge-conjecture application:

* The bundle has a **rank** `r ≥ 0`.
* The bundle has **Chern classes** `c_1, c_2, ..., c_r` in the
  cohomology ring `A`, with `c_i ∈ H^{2i}(X; ℚ)` (we suppress the
  graded structure here, working in the total `A = ⨁ H^{2*}`).
* **All Chern classes are algebraic** (the key cycle-class-map fact).

In Mathlib's eventual algebraic-vector-bundle theory, this would be
derived from:
* `V : QCoh(X)` (a quasi-coherent sheaf on the scheme `X`)
* `V` is locally free of rank `r` (i.e., algebraic vector bundle)
* `c_i : K(V) ∈ CH^i(X)` (Chern classes in the Chow ring)
* `cl_i : CH^i(X) → H^{2i}(X)` (cycle class map)
* Composition `c_i^H := cl_i ∘ c_i^{CH}` lands in `algebraic`.

Until Mathlib has this stack, we work with an abstract typeclass
that packages the "Chern classes are algebraic" property directly.

## Main definitions

* `AlgebraicVectorBundle A` : an algebraic vector bundle's Chern-class
  data in the abstract cohomology ring `A`.

## Tags

algebraic vector bundle, Chern class, cycle class map, Hodge conjecture
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- An **abstract algebraic vector bundle** on a smooth projective
variety with cohomology ring `A`, packaged as:

* A natural-number `rank` (the rank of the bundle).
* A function `chern : ℕ → A` giving Chern classes (with `chern 0 = 1`
  by convention, and `chern i = 0` for `i > rank`).
* A proof that all Chern classes are algebraic.

This is the typeclass-form of `AlgebraicChernData` packaged together
with the bundle's rank for tracking dimension constraints. -/
structure AlgebraicVectorBundle where
  /-- The rank of the bundle (as a vector bundle, equivalent to the
  rank of the underlying sheaf as a coherent sheaf). -/
  rank : ℕ
  /-- The Chern classes `c_i = chern i`. -/
  chern : ℕ → A
  /-- `c_0 = 1` (the unit class). -/
  chern_zero : chern 0 = 1
  /-- `c_i = 0` for `i > rank`. -/
  chern_above_rank : ∀ i, rank < i → chern i = 0
  /-- All Chern classes are algebraic. -/
  chern_isAlgebraic : ∀ i, CohomologyRing.IsAlgebraic (chern i)

namespace AlgebraicVectorBundle

variable {A} (E : AlgebraicVectorBundle A)

/-- Convert an `AlgebraicVectorBundle` to an `AlgebraicChernData`. -/
def toAlgebraicChernData : AlgebraicChernData A :=
  { c := E.chern, isAlgebraic := E.chern_isAlgebraic }

/-- The Chern class `c_i` is algebraic. -/
theorem chern_algebraic (i : ℕ) : CohomologyRing.IsAlgebraic (E.chern i) :=
  E.chern_isAlgebraic i

/-- A polynomial in Chern classes is algebraic.
We state the specific case `-48·c_2² + 96·c_1·c_3 − 96·c_4`, which
is the Freudenthal-quartic-Chern-class expression. -/
theorem freudenthalChernPolynomial_isAlgebraic :
    CohomologyRing.IsAlgebraic
      ((-48 : ℚ) • (E.chern 2 * E.chern 2)
        + (96 : ℚ) • (E.chern 1 * E.chern 3)
        - (96 : ℚ) • E.chern 4) :=
  E.toAlgebraicChernData.freudenthalPolynomial_isAlgebraic

end AlgebraicVectorBundle

end HodgeReduction.Infrastructure.Cohomology
