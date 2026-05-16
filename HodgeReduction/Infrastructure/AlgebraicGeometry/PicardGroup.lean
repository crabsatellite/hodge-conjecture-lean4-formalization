/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.GroupTheory.QuotientGroup.Defs
import Mathlib.Algebra.Group.Subgroup.Lattice
import HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundle

/-!
# Picard group framework — algebraic-geometric layer (R6-B)

This file sits in the algebraic-geometry infrastructure stack on top
of `LineBundle.lean` (R6-A). For a smooth projective variety `X`, the
**Picard group** `Pic(X)` is the group of isomorphism classes of line
bundles on `X` under tensor product. R6-A provides the carrier-level
data (the `LineBundleData` typeclass + the iso-class quotient
`LineBundleData.IsoClass X` with its `CommGroup` structure). This
file builds on top of that to provide:

* a top-level `Pic X` abbreviation;
* the `Pic⁰(X)` subgroup typeclass `PicZeroData`;
* the **Néron–Severi quotient** `NeronSeveri X := Pic X ⧸ Pic⁰(X)`,
  with its `CommGroup` instance derived from
  `QuotientGroup.Quotient.commGroup`;
* the **first Chern class** as a `MonoidHom Pic(X) →* H` plus the
  `QuotientGroup.lift` descent through `NS(X)` whenever `c_1`
  annihilates `Pic⁰`;
* a non-vacuous witness `picZero_trivial : PicZeroData X` (taking
  `Pic⁰ = ⊥`) so the quotient construction is exercised on a concrete
  instance.

Cohomologically, `Pic(X) ≃ H¹(X, 𝒪_X^*)`. For curves, `Pic(X)` is the
extension `0 → Pic⁰(X) → Pic(X) → ℤ → 0` where `Pic⁰(X)` is the
Jacobian. The quotient `Pic(X) / Pic⁰(X)` is the **Néron–Severi**
group `NS(X)`. The first Chern class `c_1 : Pic(X) → H²(X; ℤ)` is a
group homomorphism whose image is (the torsion-free part of) `NS(X)`.

## Sibling vs. this file

* `Cohomology/PicardGroup.lean` packages the **rational image**
  `Pic(X)_ℚ` together with the `c_1` linear map into a cohomology
  ring `A` (i.e., the "post-cycle-class-map" data).
* This file packages the **carrier-level** Picard group: the iso
  classes of actual line bundles under tensor product, plus the
  abstract `Pic⁰`-subgroup and the Néron–Severi quotient. The bridge
  between the two is the algebraic content `c_1`.

## Main definitions

* `Pic X` : the Picard group as `LineBundleData.IsoClass X` (an
  abbreviation, so all of R6-A's `IsoClass` API applies verbatim).
* `PicZeroData X` : typeclass providing the `Pic⁰`-subgroup of `Pic X`.
* `NeronSeveri X` : the quotient `Pic X ⧸ Pic⁰(X)`, with `CommGroup`
  instance from `QuotientGroup.Quotient.commGroup`.
* `ChernOneData X H` : typeclass providing the first Chern class map
  `c_1 : Pic(X) → H` as a `MonoidHom`, plus a derived hom on `NS(X)`
  when `c_1` kills `Pic⁰`.

## Tags

Picard group, Pic, line bundle, Néron–Severi, Chern class, divisor
-/

namespace HodgeReduction.Infrastructure.AlgebraicGeometry

/-! ## Picard group -/

/-- The **Picard group** of `X`: iso classes of line bundles under
tensor product.

By definition this is `LineBundleData.IsoClass X` (R6-A); the
`CommGroup` instance is inherited automatically via
`LineBundleData.commGroup`. We expose this as a top-level alias to
keep downstream theorem signatures readable. -/
abbrev Pic (X : Type*) [LineBundleData X] : Type _ :=
  LineBundleData.IsoClass X

namespace Pic

variable {X : Type*} [LineBundleData X]

/-- The Picard-group identity is the iso class of the trivial bundle
`𝒪_X`. This re-exports `LineBundleData.one_eq` through the top-level
`Pic` alias for use in downstream-facing statements. -/
@[simp]
theorem one_eq_trivialClass :
    (1 : Pic X) = LineBundleData.classOf (LineBundleData.trivial (X := X)) :=
  LineBundleData.one_eq

/-- The Picard-group multiplication of two iso classes is the iso
class of the tensor product. -/
@[simp]
theorem mul_classOf_classOf (L M : LineBundleData.Carrier (X := X)) :
    (LineBundleData.classOf L : Pic X) * LineBundleData.classOf M
      = LineBundleData.classOf (LineBundleData.tensor L M) :=
  LineBundleData.mul_classOf L M

/-- The Picard-group inverse of an iso class is the iso class of the
dual bundle. -/
@[simp]
theorem inv_classOf (L : LineBundleData.Carrier (X := X)) :
    ((LineBundleData.classOf L : Pic X))⁻¹ = LineBundleData.classOf (LineBundleData.dual L) :=
  LineBundleData.inv_classOf L

end Pic

/-! ## Pic⁰ subgroup -/

/-- **Pic⁰ data** for a variety `X`: a designated `Subgroup` of `Pic X`
representing the connected component of the identity (the Jacobian /
algebraic-equivalence kernel).

In the analytic / algebraic-geometry literature, `Pic⁰(X)` is the
subgroup of line bundles algebraically equivalent to `𝒪_X`. For curves
it is the Jacobian; for surfaces it is `H¹(X; 𝒪_X) / H¹(X; ℤ)`. Its
quotient `Pic(X) / Pic⁰(X)` is the **Néron–Severi** group `NS(X)`. -/
class PicZeroData (X : Type*) [LineBundleData X] where
  /-- The Pic⁰ subgroup of `Pic X`. -/
  picZero : Subgroup (Pic X)

/-- Accessor: the Pic⁰ subgroup of `Pic X`. -/
def picZero (X : Type*) [LineBundleData X] [PicZeroData X] : Subgroup (Pic X) :=
  PicZeroData.picZero

/-! ## Néron–Severi group -/

/-- The **Néron–Severi group** of `X`: `NS(X) := Pic(X) / Pic⁰(X)`.

This is the quotient of the Picard group by its identity component.
By the standard finite-generation theorem (Néron–Severi 1952), `NS(X)`
is a finitely generated abelian group; we do not formalise that
result here — only the quotient construction. -/
def NeronSeveri (X : Type*) [LineBundleData X] [PicZeroData X] : Type _ :=
  Pic X ⧸ picZero X

namespace NeronSeveri

variable (X : Type*) [LineBundleData X] [PicZeroData X]

/-- `NS(X)` is a commutative group as a quotient of the abelian group
`Pic X` by the subgroup `Pic⁰(X)`. -/
instance commGroup : CommGroup (NeronSeveri X) :=
  QuotientGroup.Quotient.commGroup (picZero X)

/-- The quotient map `Pic(X) →* NS(X)`. -/
def mk : Pic X →* NeronSeveri X :=
  QuotientGroup.mk' (picZero X)

variable {X}

/-- The quotient map sends a Picard class to its Néron–Severi class. -/
@[simp]
theorem mk_apply (L : Pic X) : mk X L = QuotientGroup.mk L :=
  rfl

/-- Two Picard classes have the same Néron–Severi image iff they
differ by an element of `Pic⁰(X)`. -/
theorem mk_eq_mk_iff {L M : Pic X} :
    mk X L = mk X M ↔ ∃ z ∈ picZero X, L * z = M := by
  -- `QuotientGroup.mk'_eq_mk'` packages the equivalence at the
  -- `mk'` level; restating here for our `mk` alias.
  simpa using (QuotientGroup.mk'_eq_mk' (N := picZero X) (x := L) (y := M))

/-- The quotient map is surjective: every NS class is the image of
some Pic class. -/
theorem mk_surjective : Function.Surjective (mk X) :=
  QuotientGroup.mk'_surjective (picZero X)

/-- The quotient map preserves multiplication (tensor product on
`Pic X`, induced product on `NS X`). -/
@[simp]
theorem mk_mul (L M : Pic X) : mk X (L * M) = mk X L * mk X M :=
  map_mul (mk X) L M

/-- The quotient map sends the trivial bundle's class to the identity
of `NS(X)`. -/
@[simp]
theorem mk_one : mk X (1 : Pic X) = 1 :=
  map_one (mk X)

/-- The quotient map sends an inverse to an inverse. -/
@[simp]
theorem mk_inv (L : Pic X) : mk X L⁻¹ = (mk X L)⁻¹ :=
  map_inv (mk X) L

variable (X)

/-- The kernel of the quotient map `mk : Pic(X) →* NS(X)` is exactly
the `Pic⁰(X)` subgroup. -/
theorem ker_mk_eq_picZero : MonoidHom.ker (mk X) = picZero X :=
  QuotientGroup.ker_mk' (picZero X)

variable {X}

/-- A `Pic` class lives in `Pic⁰` iff its `NS`-image is the identity. -/
theorem mem_picZero_iff (L : Pic X) :
    L ∈ picZero X ↔ mk X L = 1 := by
  -- `mk' N L = 1` iff `L ∈ N`; this is `QuotientGroup.eq_one_iff`.
  show L ∈ picZero X ↔ QuotientGroup.mk' (picZero X) L = 1
  rw [← MonoidHom.mem_ker, QuotientGroup.ker_mk']

end NeronSeveri

/-! ## First Chern class as a group homomorphism -/

/-- **First Chern class data** for `X` valued in an abelian target `H`:
a group homomorphism `c_1 : Pic(X) → H`.

Concretely `H` will be (a torsion-free quotient of) `H²(X; ℤ)`, and
the kernel of `c_1` contains `Pic⁰(X)` (when `H` is torsion-free, the
kernel equals `Pic⁰(X)` and `c_1` factors through an injection
`NS(X) ↪ H`).

Cf. `Cohomology/PicardGroup.lean` for the rational, post-cycle-class-
map version of this map (which lands in a `ℚ`-vector space). -/
class ChernOneData (X : Type*) [LineBundleData X]
    (H : Type*) [CommGroup H] where
  /-- The first Chern class as a group hom. -/
  c₁ : Pic X →* H
  /-- `c_1` annihilates Pic⁰ (so it factors through NS(X)). -/
  c₁_picZero_le_ker : ∀ [PicZeroData X], picZero X ≤ MonoidHom.ker c₁

namespace ChernOneData

variable {X : Type*} [LineBundleData X] {H : Type*} [CommGroup H]
variable [ChernOneData X H]

/-- The first Chern class of any line bundle. -/
def chernClass (L : Pic X) : H :=
  c₁ (X := X) (H := H) L

/-- `c₁` is multiplicative (= sends tensor product to sum in `H`,
written multiplicatively here). -/
@[simp]
theorem c₁_mul (L M : Pic X) : c₁ (X := X) (H := H) (L * M) = c₁ L * c₁ M :=
  map_mul _ _ _

/-- `c₁` sends the trivial bundle to the identity. -/
@[simp]
theorem c₁_one : c₁ (X := X) (H := H) 1 = 1 :=
  map_one _

/-- `c₁` sends an inverse to an inverse (= sends the dual to the
negation, in additive notation on `H`). -/
@[simp]
theorem c₁_inv (L : Pic X) : c₁ (X := X) (H := H) L⁻¹ = (c₁ L)⁻¹ :=
  map_inv _ _

/-- `c₁` sends a quotient to a quotient (`Pic` division → `H`
division). Useful when comparing two line bundles via their Chern
classes. -/
@[simp]
theorem c₁_div (L M : Pic X) :
    c₁ (X := X) (H := H) (L / M) = c₁ L / c₁ M :=
  map_div _ _ _

/-- Given `PicZeroData X`, the first Chern class descends to a
group hom `NS(X) →* H`. -/
def descendToNS [PicZeroData X] : NeronSeveri X →* H :=
  QuotientGroup.lift (picZero X) (c₁ (X := X) (H := H))
    (c₁_picZero_le_ker (X := X) (H := H))

/-- The descended hom commutes with the quotient map. -/
@[simp]
theorem descendToNS_mk [PicZeroData X] (L : Pic X) :
    (descendToNS (X := X) (H := H)) (NeronSeveri.mk X L) = c₁ L :=
  rfl

end ChernOneData

/-! ## Concrete examples / non-vacuity witnesses -/

/-- The **trivial Pic⁰** data: `Pic⁰(X) = {1}`. This makes any
`LineBundleData` carry `PicZeroData` non-vacuously, so downstream
constructions (`NeronSeveri`, the quotient map, `ChernOneData`
factorisation) are exercised on a concrete instance. -/
instance picZero_trivial (X : Type*) [LineBundleData X] : PicZeroData X where
  picZero := ⊥

/-- With the trivial Pic⁰, the quotient map `Pic(X) →* NS(X)` has
trivial kernel: `NS(X)` is `Pic(X)` itself up to canonical iso. -/
theorem picZero_trivial_ker_mk_eq_bot (X : Type*) [LineBundleData X] :
    MonoidHom.ker (NeronSeveri.mk X) = ⊥ := by
  -- `NeronSeveri.mk X = QuotientGroup.mk' (picZero X)`; on the trivial
  -- instance `picZero X = ⊥`, and `ker_mk' (⊥) = ⊥`.
  show MonoidHom.ker (QuotientGroup.mk' (picZero X)) = ⊥
  rw [QuotientGroup.ker_mk']
  rfl

/-- **Constant Chern class** (placeholder): every line bundle has
trivial first Chern class. This is a degenerate but non-vacuous
witness that `ChernOneData` is inhabited; it satisfies the
`c₁_picZero_le_ker` condition vacuously since the image of `c₁` is
`{1}`. Real geometric instances will replace this. -/
instance chernOne_trivial (X : Type*) [LineBundleData X]
    (H : Type*) [CommGroup H] : ChernOneData X H where
  c₁ := 1
  c₁_picZero_le_ker := by
    intro _ L _
    simp

/-! ## Worked example: `Pic⁰ = ⊤` ⇒ `NS = 1`

When the entire Picard group is `Pic⁰`, every line bundle is
algebraically equivalent to the trivial bundle, so the Néron–Severi
quotient is the trivial group. This is the geometric opposite of
`picZero_trivial`: instead of `Pic⁰` being trivial (so `NS = Pic`),
here `Pic⁰` exhausts everything (so `NS = 1`).

Note: this is **not** a global `instance` — it would collide with
`picZero_trivial`. We provide it as a `def` so the lead can pick the
right instance per concrete variety. -/

/-- The `PicZeroData` instance taking `Pic⁰(X) = ⊤`. -/
def picZero_full (X : Type*) [LineBundleData X] : PicZeroData X where
  picZero := ⊤

/-- With `Pic⁰(X) = ⊤`, every NS class equals the identity. -/
theorem picZero_full_NS_subsingleton (X : Type*) [LineBundleData X] :
    letI : PicZeroData X := picZero_full X
    ∀ a b : NeronSeveri X, a = b := by
  letI : PicZeroData X := picZero_full X
  intro a b
  -- Strip both NS classes to representatives `L, M : Pic X`, then
  -- show `L * M⁻¹ ∈ Pic⁰ = ⊤` (trivially).
  refine QuotientGroup.induction_on a (fun L => ?_)
  refine QuotientGroup.induction_on b (fun M => ?_)
  rw [show (QuotientGroup.mk L : NeronSeveri X) = NeronSeveri.mk X L from rfl,
      show (QuotientGroup.mk M : NeronSeveri X) = NeronSeveri.mk X M from rfl]
  rw [NeronSeveri.mk_eq_mk_iff]
  refine ⟨L⁻¹ * M, ?_, ?_⟩
  · -- Membership in `⊤` is trivial.
    exact Subgroup.mem_top _
  · -- `L * (L⁻¹ * M) = M` by `mul_inv_cancel_left`.
    rw [mul_inv_cancel_left]

end HodgeReduction.Infrastructure.AlgebraicGeometry
