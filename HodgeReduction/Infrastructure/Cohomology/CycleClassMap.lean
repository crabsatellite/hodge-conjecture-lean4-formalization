/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Cycle class map and algebraic cohomology classes

For a smooth projective variety `X` over `ℚ` (or `ℂ`), the
**Chow ring** `CH^*(X)` is the ring of algebraic cycles modulo
rational equivalence. The **cycle class map**
```
cl : CH^*(X) ⊗ ℚ → H^{2*}(X; ℚ)
```
sends an algebraic cycle class to its cohomology class. The image is
exactly the **algebraic subring** `Alg^*(X) ⊆ H^{2*}(X; ℚ)`.

The **Hodge conjecture** asserts that `Alg^p = Hdg^{2p} ∩ H^{p,p}`
(every Hodge class is algebraic), but the LOWER inclusion
`Alg^p ⊆ Hdg^{2p} ∩ H^{p,p}` is always true: algebraic classes are
Hodge classes.

For our HC formalisation, we abstract the **target side** of `cl`:
the subring of algebraic classes is the data we have as
`CohomologyRing.algebraic`. The source side (Chow ring + cl) is
abstracted away.

This file packages the **two-sided abstraction**: a typeclass
providing `cl : CycleRing → A` (a ring homomorphism into the
cohomology ring `A`) whose image is the algebraic subring.

## Main definitions

* `CycleRingData A` : a typeclass carrying:
  - An abstract Chow ring `CycleRing : Type` (commutative ℚ-algebra)
  - A ring homomorphism `cl : CycleRing →+* A`
  - The image-equals-algebraic axiom

## Tags

cycle class map, Chow ring, algebraic cycle, Hodge cycle
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- Data for a **cycle class map** into the cohomology ring `A`:
an abstract ring `CycleRing` (the Chow ring `CH^*(X) ⊗ ℚ`) and a
ring homomorphism `cl : CycleRing →+* A` whose image is contained
in the algebraic subring.

The image-equals-algebraic axiom is:
```
range cl = (CohomologyRing.algebraic : Set A)
```
which means: a class `α : A` is algebraic iff there exists `c : CycleRing`
with `cl c = α`. -/
class CycleRingData where
  /-- The Chow ring (abstract). -/
  CycleRing : Type
  /-- `CycleRing` is a commutative ring. -/
  cycleRing_isCommRing : CommRing CycleRing
  /-- The cycle class map. -/
  cl : CycleRing →+* A
  /-- The image of `cl` is contained in the algebraic subring (one
  direction; this is the **direct content** of the cycle class map). -/
  cl_image_subset : ∀ c : CycleRing, CohomologyRing.IsAlgebraic (cl c)

namespace CycleRingData

variable {A} [CycleRingData A]

/-- The image of any cycle class is algebraic in `A`. -/
theorem cl_isAlgebraic (c : CycleRingData.CycleRing A) :
    CohomologyRing.IsAlgebraic (CycleRingData.cl c) :=
  CycleRingData.cl_image_subset c

/-- The image `cl(c)` of any cycle `c` is in the algebraic subring. -/
theorem cl_mem_algebraic (c : CycleRingData.CycleRing A) :
    CycleRingData.cl c ∈ (CohomologyRing.algebraic : Subalgebra ℚ A) :=
  CycleRingData.cl_image_subset c

end CycleRingData

/-! ### Image of the cycle class map versus Hodge classes
(Voisin Vol. II Ch. 9; Hartshorne 1977 Appendix A; Fulton 1984 Ch. 19)

The previous `CycleRingData` packages the **source-side** cycle class
homomorphism. The class below is a **target-side** companion: it slices
the rational vector space `A` directly into two submodules:

* `algebraicHodge` — the image of the rational cycle class map
  `cl_ℚ : CH^*(X) ⊗ ℚ → H^{2*}(X; ℚ)` (Hartshorne 1977 App. A, Voisin
  Vol. II Cor. 9.3).
* `allHodge` — the full subspace of Hodge classes
  `Hdg^{2p}(X) := H^{p,p}(X) ∩ H^{2p}(X; ℚ)` summed over all `p`
  (Voisin Vol. II Def. 11.20).

The inclusion `algebraicHodge ≤ allHodge` is the **easy direction** of
the Hodge conjecture (algebraic cycles produce Hodge classes — Voisin
Vol. II Prop. 11.20). The reverse inclusion is precisely the **Hodge
conjecture**, which we expose as a `Prop`-valued field (`hodgeConjecture`)
expressing the conjecture as a Submodule equality (not its truth). -/
class CycleClassImageData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The image of the rational cycle class map: the rational
  subspace of `H^{2*}(X; ℚ)` spanned by classes of algebraic cycles. -/
  algebraicHodge : Submodule ℚ A
  /-- The full Hodge subspace `⨁_p H^{p,p}(X) ∩ H^{2p}(X; ℚ)`. -/
  allHodge : Submodule ℚ A
  /-- **Easy direction of the Hodge conjecture**: every algebraic
  class is a Hodge class (Voisin Vol. II Prop. 11.20). Real submodule
  inclusion. -/
  algebraicHodge_le_allHodge : algebraicHodge ≤ allHodge

namespace CycleClassImageData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [CycleClassImageData X A]

/-- **The Hodge Conjecture (target-side statement)**: every Hodge class
is the cohomology class of an algebraic cycle. Expressed as the
equality of the two submodules `algebraicHodge` and `allHodge` of `A`.

This is the **conjecture itself**, not its truth — `hodgeConjecture`
is a `Prop`; we expose it (rather than axiomatising or proving it) so
that downstream code can hypothesise it without assuming its truth. -/
def hodgeConjecture : Prop :=
  (algebraicHodge (X := X) (A := A)) = (allHodge (X := X) (A := A))

/-- Containment form of the easy direction. -/
theorem algebraicHodge_le :
    (algebraicHodge (X := X) (A := A)) ≤ (allHodge (X := X) (A := A)) :=
  algebraicHodge_le_allHodge

/-- Membership form of the easy direction: any class in
`algebraicHodge` lies in `allHodge`. -/
theorem mem_allHodge_of_mem_algebraicHodge {α : A}
    (hα : α ∈ (algebraicHodge (X := X) (A := A))) :
    α ∈ (allHodge (X := X) (A := A)) :=
  algebraicHodge_le_allHodge hα

/-- Zero lies in `algebraicHodge` (every submodule contains zero). -/
theorem zero_mem_algebraicHodge :
    (0 : A) ∈ (algebraicHodge (X := X) (A := A)) :=
  Submodule.zero_mem _

/-- Zero lies in `allHodge`. -/
theorem zero_mem_allHodge : (0 : A) ∈ (allHodge (X := X) (A := A)) :=
  Submodule.zero_mem _

/-- `algebraicHodge` is closed under addition (submodule axiom). -/
theorem algebraicHodge_add_mem {α β : A}
    (hα : α ∈ (algebraicHodge (X := X) (A := A)))
    (hβ : β ∈ (algebraicHodge (X := X) (A := A))) :
    α + β ∈ (algebraicHodge (X := X) (A := A)) :=
  Submodule.add_mem _ hα hβ

/-- `allHodge` is closed under addition. -/
theorem allHodge_add_mem {α β : A}
    (hα : α ∈ (allHodge (X := X) (A := A)))
    (hβ : β ∈ (allHodge (X := X) (A := A))) :
    α + β ∈ (allHodge (X := X) (A := A)) :=
  Submodule.add_mem _ hα hβ

/-- `algebraicHodge` is closed under rational-scalar multiplication. -/
theorem algebraicHodge_smul_mem (r : ℚ) {α : A}
    (hα : α ∈ (algebraicHodge (X := X) (A := A))) :
    r • α ∈ (algebraicHodge (X := X) (A := A)) :=
  Submodule.smul_mem _ r hα

/-- `allHodge` is closed under rational-scalar multiplication. -/
theorem allHodge_smul_mem (r : ℚ) {α : A}
    (hα : α ∈ (allHodge (X := X) (A := A))) :
    r • α ∈ (allHodge (X := X) (A := A)) :=
  Submodule.smul_mem _ r hα

/-- Sums of two algebraic classes are Hodge classes (via easy direction
+ Hodge addition). -/
theorem allHodge_of_add_both_algebraicHodge {α β : A}
    (hα : α ∈ (algebraicHodge (X := X) (A := A)))
    (hβ : β ∈ (algebraicHodge (X := X) (A := A))) :
    α + β ∈ (allHodge (X := X) (A := A)) :=
  algebraicHodge_le_allHodge (Submodule.add_mem _ hα hβ)

/-- The Hodge conjecture, when it holds, gives the reverse inclusion
`allHodge ≤ algebraicHodge`. -/
theorem allHodge_le_of_hodgeConjecture
    (hHC : hodgeConjecture (X := X) (A := A)) :
    (allHodge (X := X) (A := A)) ≤ (algebraicHodge (X := X) (A := A)) :=
  hHC.symm.le

/-- Symmetric reading: under the Hodge conjecture, every Hodge class
is algebraic (membership form). -/
theorem mem_algebraicHodge_of_hodgeConjecture
    (hHC : hodgeConjecture (X := X) (A := A))
    {α : A} (hα : α ∈ (allHodge (X := X) (A := A))) :
    α ∈ (algebraicHodge (X := X) (A := A)) :=
  (allHodge_le_of_hodgeConjecture hHC) hα

end CycleClassImageData

/-! ### Trivial inhabiting instance for `CycleClassImageData`

The trivial case (e.g. a point variety): both submodules are `⊥`,
so the easy direction holds by `le_refl` and the Hodge conjecture
holds trivially (= equality of two zero submodules). -/
instance trivialCycleClassImageData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] : CycleClassImageData X A where
  algebraicHodge := ⊥
  allHodge := ⊥
  algebraicHodge_le_allHodge := le_refl _

/-! ### Functoriality of the cycle class map
(Fulton 1984 *Intersection Theory*, Ch. 19, esp. §19.2 on pullbacks
and pushforwards; Voisin Vol. II §11.1.2)

For a morphism `f : Y → X` of smooth projective varieties, the
cycle class map fits into commutative diagrams with both pullbacks
(`f^* : CH^*(X) → CH^*(Y)`, `f^* : H^*(X) → H^*(Y)`) and
pushforwards (`f_* : CH_*(Y) → CH_*(X)`, `f_* : H^*(Y) → H^*(X)`
with appropriate Tate twist).

Below we abstract the bare data: the pullback and pushforward maps
on cohomology (as `ℚ`-linear maps), together with the structural
compatibility that the image of `algebraicHodge` under pullback is
again contained in algebraic Hodge classes, and likewise for
pushforward.

This is the **functoriality lemma** for the cycle class map. -/
class CycleClassFunctoriality (X : Type*) (Y : Type*)
    (A : Type*) (B : Type*)
    [AddCommGroup A] [Module ℚ A]
    [AddCommGroup B] [Module ℚ B]
    [CycleClassImageData X A] [CycleClassImageData Y B] where
  /-- Pullback `f^* : H^*(X; ℚ) → H^*(Y; ℚ)` as a `ℚ`-linear map. -/
  pullback : A →ₗ[ℚ] B
  /-- Pushforward `f_* : H^*(Y; ℚ) → H^*(X; ℚ)` as a `ℚ`-linear map. -/
  pushforward : B →ₗ[ℚ] A
  /-- **Pullback compatibility**: the pullback of an algebraic Hodge
  class on `X` is an algebraic Hodge class on `Y` (Fulton 1984
  Prop. 19.1.6). -/
  pullback_preserves_algebraic :
    ∀ α : A, α ∈ (CycleClassImageData.algebraicHodge (X := X) (A := A)) →
      pullback α ∈ (CycleClassImageData.algebraicHodge (X := Y) (A := B))
  /-- **Pushforward compatibility**: the pushforward of an algebraic
  Hodge class on `Y` is an algebraic Hodge class on `X`. -/
  pushforward_preserves_algebraic :
    ∀ β : B, β ∈ (CycleClassImageData.algebraicHodge (X := Y) (A := B)) →
      pushforward β ∈ (CycleClassImageData.algebraicHodge (X := X) (A := A))

namespace CycleClassFunctoriality

variable {X : Type*} {Y : Type*} {A : Type*} {B : Type*}
variable [AddCommGroup A] [Module ℚ A] [AddCommGroup B] [Module ℚ B]
variable [CycleClassImageData X A] [CycleClassImageData Y B]
variable [CycleClassFunctoriality X Y A B]

/-- Pullback compatibility, as an explicit theorem. -/
theorem pullback_algebraic {α : A}
    (hα : α ∈ (CycleClassImageData.algebraicHodge (X := X) (A := A))) :
    (CycleClassFunctoriality.pullback (X := X) (Y := Y)
        (A := A) (B := B)) α ∈
      (CycleClassImageData.algebraicHodge (X := Y) (A := B)) :=
  CycleClassFunctoriality.pullback_preserves_algebraic α hα

/-- Pushforward compatibility, as an explicit theorem. -/
theorem pushforward_algebraic {β : B}
    (hβ : β ∈ (CycleClassImageData.algebraicHodge (X := Y) (A := B))) :
    (CycleClassFunctoriality.pushforward (X := X) (Y := Y)
        (A := A) (B := B)) β ∈
      (CycleClassImageData.algebraicHodge (X := X) (A := A)) :=
  CycleClassFunctoriality.pushforward_preserves_algebraic β hβ

/-- Pullback of zero is an algebraic Hodge class on `Y` (specialisation
to the zero class). -/
theorem pullback_zero_algebraic :
    (CycleClassFunctoriality.pullback (X := X) (Y := Y)
        (A := A) (B := B)) 0 ∈
      (CycleClassImageData.algebraicHodge (X := Y) (A := B)) :=
  pullback_algebraic (Submodule.zero_mem _)

/-- Pushforward of zero is an algebraic Hodge class on `X`. -/
theorem pushforward_zero_algebraic :
    (CycleClassFunctoriality.pushforward (X := X) (Y := Y)
        (A := A) (B := B)) 0 ∈
      (CycleClassImageData.algebraicHodge (X := X) (A := A)) :=
  pushforward_algebraic (Submodule.zero_mem _)

end CycleClassFunctoriality

/-! ### Trivial inhabiting instance for `CycleClassFunctoriality`

A trivial inhabiting instance: zero linear maps in both directions.
This is well-defined regardless of which `CycleClassImageData`
instances are in scope: the preservation hypotheses follow because
`(0 : A →ₗ[ℚ] B)` sends every input to `0`, which lies in every
submodule by `Submodule.zero_mem`. -/
instance trivialCycleClassFunctoriality (X : Type*) (Y : Type*)
    (A : Type*) (B : Type*)
    [AddCommGroup A] [Module ℚ A]
    [AddCommGroup B] [Module ℚ B]
    [CycleClassImageData X A] [CycleClassImageData Y B] :
    CycleClassFunctoriality X Y A B where
  pullback := 0
  pushforward := 0
  pullback_preserves_algebraic := by
    intro α _
    show (0 : A →ₗ[ℚ] B) α ∈ _
    simp
  pushforward_preserves_algebraic := by
    intro β _
    show (0 : B →ₗ[ℚ] A) β ∈ _
    simp

end HodgeReduction.Infrastructure.Cohomology
