/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Algebra.Algebra.Hom
import Mathlib.RingTheory.Polynomial.Basic

/-!
# Abstract rational cohomology ring of a smooth projective variety

For Hodge-theoretic applications, the **rational cohomology ring**
`H^{2*}(X; ℚ) = ⨁_p H^{2p}(X; ℚ)` of a compact Kähler manifold (or
smooth projective variety) `X` is a commutative `ℚ`-algebra under cup
product, equipped with a distinguished **algebraic subring** consisting
of classes of algebraic cycles modulo rational equivalence.

This file abstracts the data we need for the Hodge-conjecture
formalisation:

* A commutative `ℚ`-algebra `A` (representing `H^{2*}(X; ℚ)`).
* A `ℚ`-subalgebra `algebraic : Subalgebra ℚ A` (representing the
  image of the cycle class map `CH^*(X)_ℚ → H^{2*}(X; ℚ)`).

The Hodge conjecture asserts that `algebraic = ⊤ ∩ {Hodge classes}`,
i.e., every Hodge class is in the algebraic subring. We don't formalise
the full Hodge conjecture here; we only need:

* The Freudenthal class `[q] ∈ H^8(EVII; ℚ)`.
* Chern classes of an algebraic vector bundle are in `algebraic`.
* Therefore polynomials in Chern classes are in `algebraic` (subalgebra
  is closed under sum, scalar, and product).
* The specific polynomial identity `[q] = -48·c_2² + 96·c_1·c_3 − 96·c_4`
  forces `[q] ∈ algebraic`.

## Main definitions

* `CohomologyRing` : typeclass packaging a commutative `ℚ`-algebra `A`
  with a designated `ℚ`-subalgebra `algebraic`.
* `CohomologyRing.IsAlgebraic` : predicate version `α ∈ algebraic`.

## Mathlib-compatibility

We keep the API minimal and Mathlib-compatible: `CohomologyRing` is a
plain typeclass on a `CommRing` + `Algebra ℚ`. The `algebraic`
subalgebra is a `Subalgebra ℚ A` (standard Mathlib type). All
inheritance / membership lemmas come for free from Mathlib.

## Tags

cohomology ring, algebraic cycle, Hodge conjecture, Subalgebra
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- An abstract **rational cohomology ring** of a smooth projective
variety, modelled as a commutative `ℚ`-algebra `A` together with a
distinguished `ℚ`-subalgebra `algebraic` of algebraic-cycle classes. -/
class CohomologyRing (A : Type*) [CommRing A] [Algebra ℚ A] where
  /-- The subalgebra of cohomology classes coming from algebraic cycles
  (i.e., the image of the cycle class map `CH^*(X)_ℚ → H^*(X; ℚ)`). -/
  algebraic : Subalgebra ℚ A

/-- An element `α` is **algebraic** if it lies in the designated
subalgebra of algebraic-cycle classes. -/
def CohomologyRing.IsAlgebraic {A : Type*} [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] (α : A) : Prop :=
  α ∈ CohomologyRing.algebraic (A := A)

namespace CohomologyRing

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-! ### Closure properties of the algebraic subring -/

/-- The zero class is algebraic. -/
theorem isAlgebraic_zero : IsAlgebraic (0 : A) :=
  Subalgebra.zero_mem _

/-- The unit class is algebraic. -/
theorem isAlgebraic_one : IsAlgebraic (1 : A) :=
  Subalgebra.one_mem _

/-- Sum of algebraic classes is algebraic. -/
theorem isAlgebraic_add {α β : A} (hα : IsAlgebraic α) (hβ : IsAlgebraic β) :
    IsAlgebraic (α + β) :=
  Subalgebra.add_mem _ hα hβ

/-- Negative of an algebraic class is algebraic. -/
theorem isAlgebraic_neg {α : A} (hα : IsAlgebraic α) :
    IsAlgebraic (-α) :=
  Subalgebra.neg_mem _ hα

/-- Difference of algebraic classes is algebraic. -/
theorem isAlgebraic_sub {α β : A} (hα : IsAlgebraic α) (hβ : IsAlgebraic β) :
    IsAlgebraic (α - β) :=
  Subalgebra.sub_mem _ hα hβ

/-- Product of algebraic classes is algebraic. -/
theorem isAlgebraic_mul {α β : A} (hα : IsAlgebraic α) (hβ : IsAlgebraic β) :
    IsAlgebraic (α * β) :=
  Subalgebra.mul_mem _ hα hβ

/-- Scalar multiple of an algebraic class is algebraic. -/
theorem isAlgebraic_smul (r : ℚ) {α : A} (hα : IsAlgebraic α) :
    IsAlgebraic (r • α) := by
  -- `r • α = (algebraMap ℚ A r) * α` via the algebra structure.
  rw [Algebra.smul_def]
  exact isAlgebraic_mul (Subalgebra.algebraMap_mem _ r) hα

/-- A natural-number power of an algebraic class is algebraic. -/
theorem isAlgebraic_pow {α : A} (hα : IsAlgebraic α) (n : ℕ) :
    IsAlgebraic (α ^ n) :=
  Subalgebra.pow_mem _ hα n

/-- The algebra map image `algebraMap ℚ A r` is algebraic for any `r : ℚ`.

This is the key technical lemma: rational scalars cast into the
cohomology ring land in the algebraic subring. Used to prove that
polynomials with rational coefficients in algebraic classes are
algebraic. -/
theorem isAlgebraic_algebraMap (r : ℚ) :
    IsAlgebraic ((algebraMap ℚ A) r) :=
  Subalgebra.algebraMap_mem _ _

end CohomologyRing

end HodgeReduction.Infrastructure.Cohomology
