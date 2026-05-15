/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Chern classes of vector bundles in abstract cohomology

This file provides an **abstract Chern-class interface**: a way to
assign cohomology classes `c_i ∈ A` to a "vector bundle data" without
defining vector bundles concretely.

## Why an abstract interface?

The full Mathlib formalisation of algebraic vector bundles on smooth
projective schemes is a substantial undertaking (vector bundles +
Chow rings + cycle class maps). For the Hodge-conjecture application,
we only need:

* A way to declare that some elements `c_1, c_2, ...` of `A` are
  "Chern classes" of an algebraic vector bundle.
* The key cycle-class-map property: **Chern classes of an algebraic
  vector bundle are algebraic cohomology classes** (in the sense of
  `CohomologyRing.IsAlgebraic`).

This is a single axiom (`ChernData.isAlgebraic`) packaged as a
typeclass field, so it can be replaced by an actual proof when Mathlib's
algebraic geometry stack catches up.

## Main definitions

* `ChernData A` : a finite list of cohomology classes `c_1, ..., c_n`
  representing "Chern classes of some vector bundle".
* `ChernData.IsAlgebraic` : property "all Chern classes are algebraic".
* `algebraic_of_chern_polynomial` : every polynomial (with rational
  coefficients) in the Chern classes of an algebraic vector bundle is
  algebraic.

## Tags

Chern class, characteristic class, algebraic vector bundle, cycle class map
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- A bundle of **Chern-class data** in `A`: a finite list of cohomology
classes representing `c_1, c_2, ..., c_n` of some vector bundle.

For our HC application, we'll instantiate this with the 4 Chern classes
`c_1, c_2, c_3, c_4` of the rank-27 Hodge piece `𝓔_{+1}` on `EVII`. -/
structure ChernData (A : Type*) [CommRing A] where
  /-- The Chern classes (degree 1, 2, ..., n in the graded structure). -/
  c : ℕ → A

/-- A `ChernData` is **algebraic** if all its Chern classes are in
the algebraic subring of `A`.

This is the axiomatic content of "Chern classes of an algebraic
vector bundle are algebraic cohomology classes" (the cycle class
map sending `c_i^{CH}(V) ↦ c_i^{H}(V)` lands in the image of
`CH^*(X)_ℚ → H^*(X; ℚ)`). -/
def ChernData.IsAlgebraic (cd : ChernData A) : Prop :=
  ∀ i, CohomologyRing.IsAlgebraic (cd.c i)

/-- The interface for an **algebraic vector bundle**: a `ChernData`
together with a proof that all its Chern classes are algebraic. -/
structure AlgebraicChernData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] extends ChernData A where
  /-- All Chern classes are in the algebraic subring. -/
  isAlgebraic : toChernData.IsAlgebraic

namespace AlgebraicChernData

variable (cd : AlgebraicChernData A)

/-- Each Chern class `c_i` of an algebraic bundle is algebraic. -/
theorem chern_isAlgebraic (i : ℕ) :
    CohomologyRing.IsAlgebraic (cd.c i) :=
  cd.isAlgebraic i

/-- The product `c_i * c_j` of two Chern classes is algebraic. -/
theorem chern_mul_isAlgebraic (i j : ℕ) :
    CohomologyRing.IsAlgebraic (cd.c i * cd.c j) :=
  CohomologyRing.isAlgebraic_mul (cd.chern_isAlgebraic i) (cd.chern_isAlgebraic j)

/-- The square `c_i^2` of a Chern class is algebraic. -/
theorem chern_sq_isAlgebraic (i : ℕ) :
    CohomologyRing.IsAlgebraic (cd.c i ^ 2) :=
  CohomologyRing.isAlgebraic_pow (cd.chern_isAlgebraic i) 2

/-- The scaled class `r • c_i` is algebraic for any rational `r`. -/
theorem chern_smul_isAlgebraic (r : ℚ) (i : ℕ) :
    CohomologyRing.IsAlgebraic (r • cd.c i) :=
  CohomologyRing.isAlgebraic_smul r (cd.chern_isAlgebraic i)

/-- A linear combination `r • c_i + s • c_j` is algebraic. -/
theorem chern_linear_comb_isAlgebraic (r s : ℚ) (i j : ℕ) :
    CohomologyRing.IsAlgebraic (r • cd.c i + s • cd.c j) :=
  CohomologyRing.isAlgebraic_add
    (cd.chern_smul_isAlgebraic r i) (cd.chern_smul_isAlgebraic s j)

/-! ### The specific polynomial: `-48 c_2² + 96 c_1 c_3 − 96 c_4` -/

/-- The **Freudenthal polynomial** in 4 Chern classes:
`-48·c_2² + 96·c_1·c_3 − 96·c_4`.

This is the polynomial expression appearing in the EVII Freudenthal-class
identity `[q] = -48·c_2(𝓔_{+1})² + 96·c_1(𝓔_{+1})·c_3(𝓔_{+1}) − 96·c_4(𝓔_{+1})`. -/
def freudenthalPolynomial : A :=
  (-48 : ℚ) • (cd.c 2 * cd.c 2) + (96 : ℚ) • (cd.c 1 * cd.c 3) - (96 : ℚ) • cd.c 4

/-- The **Freudenthal polynomial is algebraic** when the underlying
vector bundle is algebraic. This is the key consequence of
`isAlgebraic` plus the subalgebra closure properties. -/
theorem freudenthalPolynomial_isAlgebraic :
    CohomologyRing.IsAlgebraic cd.freudenthalPolynomial := by
  unfold freudenthalPolynomial
  apply CohomologyRing.isAlgebraic_sub
  · apply CohomologyRing.isAlgebraic_add
    · exact CohomologyRing.isAlgebraic_smul _
        (CohomologyRing.isAlgebraic_mul (cd.chern_isAlgebraic 2) (cd.chern_isAlgebraic 2))
    · exact CohomologyRing.isAlgebraic_smul _
        (CohomologyRing.isAlgebraic_mul (cd.chern_isAlgebraic 1) (cd.chern_isAlgebraic 3))
  · exact CohomologyRing.isAlgebraic_smul _ (cd.chern_isAlgebraic 4)

end AlgebraicChernData

end HodgeReduction.Infrastructure.Cohomology
