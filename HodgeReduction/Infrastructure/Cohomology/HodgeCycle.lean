/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.CycleClassMap

/-!
# Hodge cycle / Hodge class framework

For a smooth projective complex variety `X`, a **Hodge class** on `X`
is a rational cohomology class `α ∈ H^{2p}(X; ℚ)` that lies in the
`(p, p)`-Hodge piece `H^{p,p}(X; ℚ) ⊆ H^{2p}(X; ℂ)`.

The **Hodge conjecture** states: every Hodge class is the cohomology
class of an algebraic cycle (= in the image of the cycle class map
`CH^p(X)_ℚ → H^{2p}(X; ℚ)`).

The **easy direction** (always true, classical): every algebraic class
is a Hodge class. This is because the cycle class map factors through
the (p, p)-piece of the Hodge decomposition.

The **hard direction** (HC, open): every Hodge class is algebraic.

This file packages the Hodge cycle framework. Together with
`Cohomology.AlgebraicBundle`, `Cohomology.Lefschetz`, and `HodgeStructure`,
this gives the foundational data for stating HC abstractly.

## Main definitions

* `HodgeCycleData A` : typeclass packaging the Hodge class subspace
  and the easy-direction "algebraic ⊆ Hodge" inclusion.

## Tags

Hodge class, Hodge conjecture, cycle class map, (p, p)-piece
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Hodge cycle data** for a cohomology ring `A`:

* `hodge` : the Hodge subspace (the union of all `(p, p)`-pieces).
* `algebraic_le_hodge` : the EASY direction of HC — every algebraic
  class is a Hodge class. This is a classical kernel-derivable fact:
  the cycle class map factors through the Hodge decomposition.

The HARD direction of HC (Hodge ⟹ algebraic) is the actual conjecture
and not part of this typeclass. -/
class HodgeCycleData where
  /-- The Hodge subspace `⊔_p H^{p,p}(X; ℚ) ⊆ A`. -/
  hodge : Subalgebra ℚ A
  /-- **Easy direction of HC** (classical): every algebraic class
  is a Hodge class. -/
  algebraic_le_hodge : (CohomologyRing.algebraic : Subalgebra ℚ A) ≤ hodge

namespace HodgeCycleData

variable {A} [HodgeCycleData A]

/-- A class is a **Hodge class** if it lies in the Hodge subspace. -/
def IsHodgeClass (α : A) : Prop := α ∈ hodge (A := A)

/-- Every algebraic class is a Hodge class (easy direction of HC). -/
theorem isHodgeClass_of_isAlgebraic {α : A}
    (hα : CohomologyRing.IsAlgebraic α) : IsHodgeClass α :=
  algebraic_le_hodge hα

/-- The set of Hodge classes is closed under addition. -/
theorem isHodgeClass_add {α β : A}
    (hα : IsHodgeClass α) (hβ : IsHodgeClass β) :
    IsHodgeClass (α + β) :=
  Subalgebra.add_mem _ hα hβ

/-- The set of Hodge classes is closed under negation. -/
theorem isHodgeClass_neg {α : A} (hα : IsHodgeClass α) :
    IsHodgeClass (-α) :=
  Subalgebra.neg_mem _ hα

/-- The set of Hodge classes is closed under multiplication. -/
theorem isHodgeClass_mul {α β : A}
    (hα : IsHodgeClass α) (hβ : IsHodgeClass β) :
    IsHodgeClass (α * β) :=
  Subalgebra.mul_mem _ hα hβ

/-- The set of Hodge classes is closed under scalar multiplication. -/
theorem isHodgeClass_smul (r : ℚ) {α : A} (hα : IsHodgeClass α) :
    IsHodgeClass (r • α) := by
  rw [Algebra.smul_def]
  exact isHodgeClass_mul (Subalgebra.algebraMap_mem _ r) hα

/-- The zero class is a Hodge class. -/
theorem isHodgeClass_zero : IsHodgeClass (0 : A) :=
  Subalgebra.zero_mem _

/-- The unit class is a Hodge class. -/
theorem isHodgeClass_one : IsHodgeClass (1 : A) :=
  Subalgebra.one_mem _

end HodgeCycleData

/-! ### The Hodge Conjecture statement (the HARD direction)

We state HC abstractly: for the framework data, every Hodge class is
algebraic. -/

variable {A} [HodgeCycleData A]

/-- **The Hodge Conjecture** for a cohomology ring `A` with Hodge cycle
data: every Hodge class is algebraic.

This is the **hard direction** (HC; open for general X). The easy
direction `algebraic_le_hodge` is provided by the typeclass field.

For specific `A`, this is known classically:
* Codim 1 (Lefschetz (1,1) theorem): YES — every (1,1)-class is algebraic.
* Codim n (top-dim): YES (trivial via degree).
* Codim 2 on abelian fourfolds: open in general.
* Mumford-Tate reduction (Alex 2026): reduces to specific sub-classes.

For the Freudenthal-quartic case on EVII, we have a SPECIFIC proof
chain via `FreudenthalClassData` (the framework instance providing
the polynomial-Chern + Kähler-class identities). -/
def HodgeConjecture (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [HodgeCycleData A] : Prop :=
  ∀ α : A, HodgeCycleData.IsHodgeClass α → CohomologyRing.IsAlgebraic α

end HodgeReduction.Infrastructure.Cohomology
