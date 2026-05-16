/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.NeronSeveri

/-!
# Picard group framework

For a smooth projective variety `X` over a field `k`, the **Picard group**
`Pic(X) = H¹(X, 𝒪_X^*)` classifies isomorphism classes of holomorphic
(or algebraic, over `k`) line bundles on `X`.

For `X` smooth projective over `ℂ`:
* `Pic^0(X)` — connected component of identity (= line bundles
  algebraically equivalent to `𝒪_X`).
* `NS(X) = Pic(X) / Pic^0(X)` — **Néron-Severi group** (already
  abstracted in `NeronSeveri.lean`).

The **exponential exact sequence** `0 → ℤ → 𝒪_X → 𝒪_X^* → 1` gives:
```
… → H¹(X; ℤ) → H¹(X; 𝒪_X) → Pic(X) → H²(X; ℤ) → H²(X; 𝒪_X) → …
```
inducing `c_1 : Pic(X) → H²(X; ℤ)`, whose image is `NS(X)`.

## Main definitions

* `PicardGroupData A` : typeclass packaging the rational Picard data
  (the `Pic(X)_ℚ` vector space + `c_1` linear map into `A`).

## Tags

Picard group, Pic, line bundle, Chern class, divisor
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Picard group data** for a cohomology ring `A`:

* `PicRat` : the rational Picard subspace `Pic(X)_ℚ ⊆ ?` (we
  abstract as a `ℚ`-vector space, separate from `A`).
* `c1` : the `c_1` linear map `PicRat →ₗ[ℚ] A`.
* `c1_image_isAlgebraic` : the image is algebraic (since Pic comes
  from divisors which are algebraic codim-1 cycles).

This refines the abstraction of `NeronSeveri.NS_rat` (which is the
image of `c_1`). -/
class PicardGroupData where
  /-- The rational Picard group `Pic(X)_ℚ`. -/
  PicRat : Type
  /-- `PicRat` is an additive commutative group. -/
  PicRat_addCommGroup : AddCommGroup PicRat
  /-- `PicRat` is a `ℚ`-module. -/
  PicRat_module : @Module ℚ PicRat _ PicRat_addCommGroup.toAddCommMonoid
  /-- The first Chern class map `c_1 : Pic(X)_ℚ → H²(X; ℚ) ⊆ A`. -/
  c1 : @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) PicRat A
        PicRat_addCommGroup.toAddCommMonoid _ PicRat_module _
  /-- The image of `c_1` is algebraic (divisors are codim-1 cycles). -/
  c1_image_isAlgebraic : ∀ L : PicRat, CohomologyRing.IsAlgebraic (c1 L)

namespace PicardGroupData

variable {A} [PicardGroupData A]

/-- The first Chern class of any line bundle is algebraic. -/
theorem c1_isAlgebraic (L : PicardGroupData.PicRat (A := A)) :
    CohomologyRing.IsAlgebraic (PicardGroupData.c1 L) :=
  PicardGroupData.c1_image_isAlgebraic L

end PicardGroupData

/-! ### Cohomology-side Picard data (Voisin Vol. I Ch. 11; Beauville §I)

The previous `PicardGroupData` packages the **source-side** abstraction
of `Pic(X)_ℚ` together with the Chern map `c_1`. The class below is a
**target-side** companion: it slices the rational cohomology vector
space `A` directly into:

* `picTotal` — the rational Picard subspace `Pic(X)_ℚ ⊆ A` (identified
  with its image under `c_1`, which is injective on `Pic(X) ⊗ ℚ` because
  `Pic^0 ⊗ ℚ` and `NS ⊗ ℚ` both inject into `H²(X; ℚ)` — Voisin Vol. I
  Prop. 11.10).
* `picZero` — the connected-component piece `Pic^0(X)_ℚ` (Voisin
  Vol. I §12.1; image of the analytic Albanese map).

The submodule containment `picZero ≤ picTotal` is the standard fact
that `Pic^0(X)` is a connected closed subgroup of the algebraic group
scheme `Pic(X)`; rationally, the inclusion is a sub-vector-space
inclusion (Beauville 1996 *Complex Algebraic Surfaces*, §I.3).

The natural number `nsDim` records the **Néron-Severi rank** (= the
Picard number `ρ(X) := dim_ℚ NS(X)_ℚ`). This is a finite invariant
(Mumford 1966 *Lectures on Curves*, Lec. 24). -/
class CohomologyPicardData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The full rational Picard subspace `Pic(X)_ℚ ⊆ A` (i.e., the
  image of the rational Chern map). -/
  picTotal : Submodule ℚ A
  /-- The rational `Pic^0`-piece (connected component of identity). -/
  picZero : Submodule ℚ A
  /-- `Pic^0(X)_ℚ` is a sub-vector-space of the rational Picard space
  (standard: `Pic^0` is a closed subgroup scheme of `Pic`; rationally
  the inclusion is sub-vector-space). -/
  picZero_le_picTotal : picZero ≤ picTotal
  /-- The Néron-Severi rank (= Picard number `ρ(X)`), a finite invariant
  by the theorem of the base (Mumford 1966 Lec. 24). -/
  nsDim : ℕ

namespace CohomologyPicardData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [CohomologyPicardData X A]

/-- The Néron-Severi rank (Picard number) as an `ℕ`-valued invariant.
The Picard number `ρ(X)` of a smooth projective variety `X` is the
free rank of the Néron-Severi group `NS(X)`. -/
def picardNumber : ℕ := CohomologyPicardData.nsDim (X := X) (A := A)

/-- The connected-component piece `Pic^0(X)_ℚ ⊆ Pic(X)_ℚ` is contained
in the total Picard space, as a real submodule inclusion. -/
theorem picZero_le : (picZero (X := X) (A := A)) ≤
    (picTotal (X := X) (A := A)) :=
  picZero_le_picTotal

/-- Membership form of the `picZero ≤ picTotal` inclusion: any class
in `Pic^0(X)_ℚ` lies in the full rational Picard subspace. -/
theorem mem_picTotal_of_mem_picZero {α : A}
    (hα : α ∈ (picZero (X := X) (A := A))) :
    α ∈ (picTotal (X := X) (A := A)) :=
  picZero_le_picTotal hα

/-- Zero lies in `picZero` (every submodule contains zero). -/
theorem zero_mem_picZero : (0 : A) ∈ (picZero (X := X) (A := A)) :=
  Submodule.zero_mem _

/-- Zero lies in `picTotal`. -/
theorem zero_mem_picTotal : (0 : A) ∈ (picTotal (X := X) (A := A)) :=
  Submodule.zero_mem _

/-- `picZero` is closed under addition (it is a `ℚ`-submodule). -/
theorem picZero_add_mem {α β : A}
    (hα : α ∈ (picZero (X := X) (A := A)))
    (hβ : β ∈ (picZero (X := X) (A := A))) :
    α + β ∈ (picZero (X := X) (A := A)) :=
  Submodule.add_mem _ hα hβ

/-- `picTotal` is closed under addition. -/
theorem picTotal_add_mem {α β : A}
    (hα : α ∈ (picTotal (X := X) (A := A)))
    (hβ : β ∈ (picTotal (X := X) (A := A))) :
    α + β ∈ (picTotal (X := X) (A := A)) :=
  Submodule.add_mem _ hα hβ

/-- `picZero` is closed under rational-scalar multiplication. -/
theorem picZero_smul_mem (r : ℚ) {α : A}
    (hα : α ∈ (picZero (X := X) (A := A))) :
    r • α ∈ (picZero (X := X) (A := A)) :=
  Submodule.smul_mem _ r hα

/-- `picTotal` is closed under rational-scalar multiplication. -/
theorem picTotal_smul_mem (r : ℚ) {α : A}
    (hα : α ∈ (picTotal (X := X) (A := A))) :
    r • α ∈ (picTotal (X := X) (A := A)) :=
  Submodule.smul_mem _ r hα

/-- Transitivity of the picZero-via-picTotal inclusion under addition
of classes both lying in `picZero`. -/
theorem add_in_picTotal_of_both_picZero {α β : A}
    (hα : α ∈ (picZero (X := X) (A := A)))
    (hβ : β ∈ (picZero (X := X) (A := A))) :
    α + β ∈ (picTotal (X := X) (A := A)) :=
  picZero_le_picTotal (Submodule.add_mem _ hα hβ)

end CohomologyPicardData

/-! ### Trivial inhabiting instance for `CohomologyPicardData`

Any rational vector space `A` carries a trivial Picard datum where
both `picTotal` and `picZero` are the bottom submodule `⊥` and the
Néron-Severi rank is `0`. This is the cohomology-Picard datum of a
variety with trivial Picard group (e.g. a point). -/
instance trivialCohomologyPicardData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] : CohomologyPicardData X A where
  picTotal := ⊥
  picZero := ⊥
  picZero_le_picTotal := le_refl _
  nsDim := 0

/-! ### Picard variety data (Voisin Vol. I §12 — Albanese / Picard
variety; Beauville §V on the Picard variety as an abelian variety)

For a smooth projective variety `X`, the connected component
`Pic^0(X)` is an **abelian variety** of dimension equal to the
irregularity `q(X) = h^{0,1}(X) = h^1(X, 𝒪_X)`. Its first homology
(equivalently, its `ℤ`-rank as a real torus) is `2·q(X)`. -/
class PicardVarietyData (X : Type*) where
  /-- The underlying type of the Picard variety `Pic^0(X)`. -/
  Pic0 : Type
  /-- `Pic0` is an additive abelian group (abelian variety; here just
  the underlying additive group structure). -/
  pic0_addCommGroup : AddCommGroup Pic0
  /-- The complex dimension of the Picard variety `Pic^0(X)`. Equals
  the irregularity `q(X) = h^{0,1}(X)` (Voisin Vol. I Thm. 12.10). -/
  pic0_dim : ℕ
  /-- The `ℤ`-rank of the Picard variety as a real torus
  (= rank of `H_1(Pic^0(X); ℤ)`). For an abelian variety of complex
  dimension `g`, this rank is `2g`. -/
  Pic0_rank : ℕ
  /-- The standard rank identity for an abelian variety of complex
  dimension `g`: the underlying real torus has dimension `2g`, hence
  its first homology has rank `2g`. -/
  Pic0_rank_eq : Pic0_rank = 2 * pic0_dim

namespace PicardVarietyData

variable {X : Type*} [PicardVarietyData X]

/-- Convenience accessor: the additive group structure on `Pic0 X`. -/
instance : AddCommGroup (PicardVarietyData.Pic0 X) :=
  PicardVarietyData.pic0_addCommGroup

/-- The complex dimension of `Pic^0(X)`, i.e., the irregularity. -/
def irregularity : ℕ := PicardVarietyData.pic0_dim (X := X)

/-- The real torus rank of `Pic^0(X)` equals twice its complex
dimension — this is the abelian-variety rank identity. -/
theorem rank_eq_two_dim :
    PicardVarietyData.Pic0_rank (X := X) =
      2 * PicardVarietyData.pic0_dim (X := X) :=
  PicardVarietyData.Pic0_rank_eq

/-- The rank is always even (consequence of `rank = 2 · dim`). -/
theorem rank_even : Even (PicardVarietyData.Pic0_rank (X := X)) := by
  refine ⟨PicardVarietyData.pic0_dim (X := X), ?_⟩
  rw [PicardVarietyData.Pic0_rank_eq]; ring

/-- Zero is an element of `Pic0 X` (it is an additive group). -/
theorem zero_mem : (0 : PicardVarietyData.Pic0 X) =
    (0 : PicardVarietyData.Pic0 X) :=
  rfl

end PicardVarietyData

/-! ### Trivial inhabiting instance for `PicardVarietyData`

A variety with trivial Picard variety (e.g. a rational variety) has
`Pic^0` reduced to a point, with `pic0_dim = 0` and `Pic0_rank = 0`.
We model this with `Pic0 := PUnit` and `pic0_dim = Pic0_rank = 0`. -/
instance trivialPicardVarietyData (X : Type*) : PicardVarietyData X where
  Pic0 := PUnit
  pic0_addCommGroup := inferInstance
  pic0_dim := 0
  Pic0_rank := 0
  Pic0_rank_eq := by norm_num

end HodgeReduction.Infrastructure.Cohomology
