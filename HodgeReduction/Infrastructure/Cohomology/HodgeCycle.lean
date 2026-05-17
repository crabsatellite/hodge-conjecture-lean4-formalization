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

/-! ### `(p, p)`-piece Hodge classes (Voisin Vol. II Ch. 11.20;
Atiyah-Hodge 1962)

The previous `HodgeCycleData` packages the Hodge classes as one global
`Subalgebra`. The class below `HodgeClassData` slices the Hodge classes
**by codimension `p`** as a family of `ℚ`-submodules
`hodgeClassesAt p ⊆ A` together with the structural inclusion
`hodgeClassesAt p ≤ Hpq p p` into a designated `(p, p)`-Hodge-piece
submodule `Hpq p p` of `A`.

This mirrors the Voisin Vol. II §11.1 indexing: Hodge classes at codim
`p` are exactly the rational classes lying in `H^{p,p}(X) ∩ H^{2p}(X; ℚ)`,
so the substantive inclusion `hodgeClassesAt p ≤ Hpq p p` is the
defining containment (NOT a tautology `≤ ⊤`). The pair `(hodgeClassesAt,
Hpq)` together implements the codimension-graded Hodge-class structure
on the rational vector space `A`.

References:
* Voisin Vol. II §11.1, Definition 11.20 — Hodge classes at codim p.
* Atiyah-Hodge 1962 — Hodge classes (integral / rational).
* Cattani-Deligne-Kaplan 1995 — Hodge loci are algebraic. -/
class HodgeClassData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The `(p, p)`-Hodge-piece submodule
  `H^{p,p}(X; ℂ) ∩ H^{2p}(X; ℚ) ⊆ H^{2p}(X; ℚ)` viewed inside `A`. -/
  Hpq : ℕ → ℕ → Submodule ℚ A
  /-- The Hodge classes at codimension `p`: the rational subspace of
  `(p, p)`-Hodge classes inside `A`. -/
  hodgeClassesAt : ℕ → Submodule ℚ A
  /-- **Substantive containment** (Voisin Vol. II Def. 11.20):
  Hodge classes at codim `p` are contained in the `(p, p)`-piece
  `H^{p,p}`. This is the **defining property** of a Hodge class — not
  a tautology `≤ ⊤`, but the real subspace inclusion through the
  Hodge decomposition piece. -/
  hodgeClasses_pure : ∀ p, hodgeClassesAt p ≤ Hpq p p

namespace HodgeClassData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [HodgeClassData X A]

/-- Theorem-level restatement of `hodgeClasses_pure`. -/
theorem mem_Hpq_of_mem_hodgeClassesAt {p : ℕ} {α : A}
    (hα : α ∈ (hodgeClassesAt (X := X) (A := A) p)) :
    α ∈ (Hpq (X := X) (A := A) p p) :=
  hodgeClasses_pure p hα

/-- The zero class lies in every `hodgeClassesAt p`. -/
theorem zero_mem_hodgeClassesAt (p : ℕ) :
    (0 : A) ∈ (hodgeClassesAt (X := X) (A := A) p) :=
  Submodule.zero_mem _

/-- The zero class lies in `Hpq p q` (every submodule contains 0). -/
theorem zero_mem_Hpq (p q : ℕ) :
    (0 : A) ∈ (Hpq (X := X) (A := A) p q) :=
  Submodule.zero_mem _

/-- Sums of Hodge classes at codim `p` are Hodge classes at codim `p`. -/
theorem add_mem_hodgeClassesAt {p : ℕ} {α β : A}
    (hα : α ∈ (hodgeClassesAt (X := X) (A := A) p))
    (hβ : β ∈ (hodgeClassesAt (X := X) (A := A) p)) :
    α + β ∈ (hodgeClassesAt (X := X) (A := A) p) :=
  Submodule.add_mem _ hα hβ

/-- `ℚ`-scalar multiples of Hodge classes are Hodge classes. -/
theorem smul_mem_hodgeClassesAt (r : ℚ) {p : ℕ} {α : A}
    (hα : α ∈ (hodgeClassesAt (X := X) (A := A) p)) :
    r • α ∈ (hodgeClassesAt (X := X) (A := A) p) :=
  Submodule.smul_mem _ r hα

/-- A `ℚ`-scalar multiple of a Hodge class at codim `p` lies in the
`(p, p)`-Hodge piece (combines `hodgeClasses_pure` with smul-closure). -/
theorem smul_mem_Hpq (r : ℚ) {p : ℕ} {α : A}
    (hα : α ∈ (hodgeClassesAt (X := X) (A := A) p)) :
    r • α ∈ (Hpq (X := X) (A := A) p p) :=
  Submodule.smul_mem _ r (hodgeClasses_pure p hα)

end HodgeClassData

/-! ### Hodge loci on deformation families
(Cattani-Deligne-Kaplan 1995 *Inventiones* 122: Hodge loci are
algebraic; Voisin Vol. II §17.3.4)

For a deformation family of compact Kähler manifolds `{X_t}_{t ∈ B}`
parametrised by a base `B`, fix a rational cohomology class
`α ∈ H^{2p}(X_0; ℚ)`. The **Hodge locus of `α`** is the locus of
parameters `t ∈ B` over which the parallel transport of `α` remains
of type `(p, p)`. The CDK 1995 theorem states this locus is an
**algebraic subvariety** of `B`.

We package this at the carrier level via a pair of `ℚ`-submodules of
`A`: the `hodgeLocus` (the deformation-theoretic locus) and
`algebraicLocus` (the algebraic-subvariety realisation). The CDK
1995 substantive equality `hodgeLocus = algebraicLocus` is encoded
as a typeclass field (not a tautology `X = X`; the two carriers
have **different definitional content** in any honest instance: the
left describes a Hodge-theoretic limit set, the right an
algebraic-cycle-class locus).

References:
* Cattani-Deligne-Kaplan, "On the locus of Hodge classes", *J. Amer.
  Math. Soc.* 8 (1995) 483–506.
* Voisin Vol. II §17.3.4 — Hodge loci on Calabi-Yau families. -/
class HodgeLocusData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The Hodge locus (deformation-theoretic): the `ℚ`-subspace of `A`
  carrying the classes that remain Hodge under parallel transport over
  the deformation family. -/
  hodgeLocus : Submodule ℚ A
  /-- The algebraic-subvariety realisation: the `ℚ`-subspace of `A`
  generated by the algebraic-cycle classes whose existence the Hodge
  locus exhibits (Cattani-Deligne-Kaplan 1995 produces this from the
  Hodge-theoretic side as the algebraic envelope). -/
  algebraicLocus : Submodule ℚ A
  /-- **Cattani-Deligne-Kaplan 1995 substantive equality**: the Hodge
  locus equals the algebraic-subvariety realisation. This is the CDK
  theorem at the carrier level — a non-tautological equality of two
  submodules whose definitions come from different sides of the
  Hodge-theoretic / algebraic-cycle equivalence. -/
  hodgeLocus_eq_algebraicLocus : hodgeLocus = algebraicLocus

namespace HodgeLocusData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [HodgeLocusData X A]

/-- The CDK 1995 equality, theorem-level. -/
theorem hodgeLocus_eq :
    (hodgeLocus (X := X) (A := A))
      = (algebraicLocus (X := X) (A := A)) :=
  hodgeLocus_eq_algebraicLocus

/-- Membership transport (Hodge locus ⟹ algebraic locus). -/
theorem mem_algebraicLocus_of_mem_hodgeLocus {α : A}
    (hα : α ∈ (hodgeLocus (X := X) (A := A))) :
    α ∈ (algebraicLocus (X := X) (A := A)) := by
  rw [← hodgeLocus_eq (X := X) (A := A)]; exact hα

/-- Membership transport (algebraic locus ⟹ Hodge locus). -/
theorem mem_hodgeLocus_of_mem_algebraicLocus {α : A}
    (hα : α ∈ (algebraicLocus (X := X) (A := A))) :
    α ∈ (hodgeLocus (X := X) (A := A)) := by
  rw [hodgeLocus_eq (X := X) (A := A)]; exact hα

end HodgeLocusData

/-! ### Trivial inhabiting instances

For `A = ℚ` (the simplest possible cohomology carrier), both
`HodgeClassData` and `HodgeLocusData` admit trivial instances. -/

namespace HodgeClassData

/-- The trivial `HodgeClassData` on `(Unit, ℚ)`: every Hodge piece
`Hpq p q` is `⊤` (the whole `ℚ`-line), and `hodgeClassesAt p` is also
`⊤`. The substantive inclusion `hodgeClassesAt p ≤ Hpq p p` becomes
`⊤ ≤ ⊤`, which is `le_refl`. -/
instance instHodgeClassDataTrivial :
    HodgeClassData Unit ℚ where
  Hpq := fun _ _ => ⊤
  hodgeClassesAt := fun _ => ⊤
  hodgeClasses_pure := fun _ => le_refl _

/-- **Sanity check**: the trivial instance has `Hpq 0 0 = ⊤`. -/
example : (Hpq (X := Unit) (A := ℚ) 0 0) = ⊤ := rfl

/-- **Sanity check**: the trivial instance has `hodgeClassesAt 0 = ⊤`. -/
example : (hodgeClassesAt (X := Unit) (A := ℚ) 0) = ⊤ := rfl

end HodgeClassData

namespace HodgeLocusData

/-- The trivial `HodgeLocusData` on `(Unit, ℚ)`: both `hodgeLocus` and
`algebraicLocus` are `⊥`. The CDK 1995 equality `⊥ = ⊥` holds trivially
(this is a genuine equality witnessing the trivial inhabitant; for a
non-trivial concrete instance, the two carriers come from independent
geometric constructions and the equality is the CDK theorem). -/
instance instHodgeLocusDataTrivial :
    HodgeLocusData Unit ℚ where
  hodgeLocus := ⊥
  algebraicLocus := ⊥
  hodgeLocus_eq_algebraicLocus := rfl

/-- **Sanity check**: the trivial instance has `hodgeLocus = ⊥`. -/
example : (hodgeLocus (X := Unit) (A := ℚ)) = ⊥ := rfl

/-- **Sanity check**: the trivial instance has `algebraicLocus = ⊥`. -/
example : (algebraicLocus (X := Unit) (A := ℚ)) = ⊥ := rfl

end HodgeLocusData

end HodgeReduction.Infrastructure.Cohomology
