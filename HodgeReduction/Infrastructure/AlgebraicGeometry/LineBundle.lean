/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Group.Defs
import Mathlib.Data.Quot
import Mathlib.Data.Setoid.Basic

/-!
# Line bundles on a scheme — abstract carrier-level framework

A **line bundle** on a scheme (or smooth projective variety) `X` is an
invertible sheaf of `𝒪_X`-modules: a locally free sheaf of rank `1`.
Isomorphism classes of line bundles form an abelian group `Pic(X)`
under tensor product `⊗`, with identity the trivial bundle `𝒪_X` and
inverse the dual `L^∨`.

Classical reference: Hartshorne, *Algebraic Geometry*, II.6 (Cartier
divisors, line bundles, the Picard group).

## What this file provides

Mathlib `v4.16.0` does not yet contain a scheme-level `LineBundle` /
`PicardGroup` API (see `HodgeReduction/Research/Tier2_MathlibBridges_R5.md §2`
for the planned upstream sequence — this file is **PR 1** of that
sequence, designed to be Mathlib-compatible after the eventual port).

We give a **parametric** abstraction: an arbitrary carrier type `X`
(a stand-in for the underlying scheme/variety/space) is equipped, via
the typeclass `LineBundleData X`, with:

* a type `Carrier` of "line bundles on `X`",
* a distinguished element `trivial : Carrier` (the structure sheaf `𝒪_X`),
* binary `tensor : Carrier → Carrier → Carrier` (tensor product `⊗`),
* unary `dual : Carrier → Carrier` (dual `L^∨ = ℋom(L, 𝒪_X)`),
* an iso-class equivalence `iso : Setoid Carrier` together with the
  three congruences (`tensor` is well-defined on iso classes, `trivial`
  is left-identity, `dual` is two-sided inverse) and the two laws
  (`tensor` is commutative and associative).

From this we construct the **iso-class quotient**
`IsoClass X := Quotient LineBundleData.iso` and equip it with a
`CommGroup` structure. The proofs are all `Quotient.sound`-style
descent of the congruences — no axiom, no `sorry`, no classical
choice beyond what `Quotient` already uses.

This file is the **foundational layer** for the
`PicardGroup` typeclass at `Infrastructure/Cohomology/PicardGroup.lean`:
once Mathlib gains a concrete `Scheme`-indexed `LineBundle`, an
instance `LineBundleData (X : Scheme)` will recover the algebraic
`Pic X` here, and via the planned PR 2 of the Tier 2 bridge will hand
back a `PicardGroupData` instance with `PicRat := IsoClass X ⊗ ℚ`.

## Worked example

`LineBundleData Unit` is provided as a sanity check: the trivial
scheme `Spec(k)` (a point) has `Pic = 1`, modelled here by
`Carrier := Unit` and the discrete-equality setoid. The resulting
`CommGroup (IsoClass Unit)` is the trivial group.

## Main definitions and theorems

* `LineBundleData X` — typeclass packaging line-bundle carrier-level data.
* `LineBundleData.IsoClass X` — `Quotient LineBundleData.iso`.
* `CommGroup (LineBundleData.IsoClass X)` — the Picard-group structure.
* `LineBundleData.trivialBundleOnPoint` — non-vacuous example
  (`LineBundleData Unit`).

## Mathlib-compatibility

The class layout (`Carrier` + group ops + congruences) mirrors the
shape of the planned `Mathlib.AlgebraicGeometry.LineBundle` upstream
PR (cf. `Tier2_MathlibBridges_R5.md §2`, PR 1). When that PR lands,
this file will provide an instance `LineBundleData X` for any
`X : Scheme` by setting `Carrier := Mathlib.AlgebraicGeometry.LineBundle X`,
`tensor` to Mathlib's tensor product, `dual` to Mathlib's dual sheaf,
`iso` to the iso-class setoid. The `CommGroup (IsoClass X)` proof
below is parametric in the carrier and therefore portable verbatim.

## Tags

line bundle, invertible sheaf, Picard group, tensor product, dual sheaf,
algebraic geometry, Hartshorne II.6
-/

namespace HodgeReduction.Infrastructure.AlgebraicGeometry

/-! ### The `LineBundleData` typeclass -/

/-- **Carrier-level data of line bundles on `X`**.

For a Lean type `X` (a stand-in for a scheme or smooth projective
variety), `LineBundleData X` packages:

* `Carrier` — the type of line bundles on `X`;
* `trivial` — the structure sheaf `𝒪_X` (identity for `⊗`);
* `tensor` — the tensor product `L ⊗ M`;
* `dual` — the dual `L^∨`;
* `iso` — the equivalence relation "isomorphic as line bundles";
* the congruences and group laws needed to descend `tensor` to a
  commutative group operation on the iso-class quotient
  `Quotient iso`.

All congruences and laws are stated **at the level of the iso relation**
(`iso.r ... ...`), not as strict equalities — this matches the
geometric situation where `L ⊗ M ≅ M ⊗ L` is only an isomorphism, not
an equality, of line bundles. -/
class LineBundleData (X : Type*) where
  /-- The type of line bundles on `X`. -/
  Carrier : Type*
  /-- The trivial line bundle `𝒪_X`. -/
  trivial : Carrier
  /-- The tensor product `L ⊗ M` of two line bundles. -/
  tensor : Carrier → Carrier → Carrier
  /-- The dual line bundle `L^∨`. -/
  dual : Carrier → Carrier
  /-- The "isomorphic as line bundles" equivalence. -/
  iso : Setoid Carrier
  /-- `tensor` is well-defined on iso classes:
  if `L₁ ≅ L₂` and `M₁ ≅ M₂` then `L₁ ⊗ M₁ ≅ L₂ ⊗ M₂`. -/
  tensor_respects_iso :
    ∀ {L₁ L₂ M₁ M₂ : Carrier}, iso.r L₁ L₂ → iso.r M₁ M₂ →
      iso.r (tensor L₁ M₁) (tensor L₂ M₂)
  /-- `dual` is well-defined on iso classes: if `L ≅ M` then `L^∨ ≅ M^∨`. -/
  dual_respects_iso :
    ∀ {L M : Carrier}, iso.r L M → iso.r (dual L) (dual M)
  /-- `𝒪_X ⊗ L ≅ L` (left identity). -/
  tensor_trivial_left : ∀ L : Carrier, iso.r (tensor trivial L) L
  /-- `L ⊗ L^∨ ≅ 𝒪_X` (right inverse). -/
  tensor_dual_right : ∀ L : Carrier, iso.r (tensor L (dual L)) trivial
  /-- `L ⊗ M ≅ M ⊗ L` (commutativity). -/
  tensor_comm : ∀ L M : Carrier, iso.r (tensor L M) (tensor M L)
  /-- `(L ⊗ M) ⊗ N ≅ L ⊗ (M ⊗ N)` (associativity). -/
  tensor_assoc :
    ∀ L M N : Carrier, iso.r (tensor (tensor L M) N) (tensor L (tensor M N))

namespace LineBundleData

variable {X : Type*} [LineBundleData X]

/-! ### Derived iso lemmas -/

/-- Reflexivity of the iso relation. -/
theorem iso_refl (L : Carrier (X := X)) : (iso (X := X)).r L L :=
  (iso (X := X)).iseqv.refl L

/-- Symmetry of the iso relation. -/
theorem iso_symm {L M : Carrier (X := X)} (h : (iso (X := X)).r L M) :
    (iso (X := X)).r M L :=
  (iso (X := X)).iseqv.symm h

/-- Transitivity of the iso relation. -/
theorem iso_trans {L M N : Carrier (X := X)}
    (h₁ : (iso (X := X)).r L M) (h₂ : (iso (X := X)).r M N) :
    (iso (X := X)).r L N :=
  (iso (X := X)).iseqv.trans h₁ h₂

/-- `L ⊗ 𝒪_X ≅ L` (right identity), derived from left identity + commutativity. -/
theorem tensor_trivial_right (L : Carrier (X := X)) :
    (iso (X := X)).r (tensor L (trivial (X := X))) L :=
  iso_trans (tensor_comm L (trivial (X := X)))
    (tensor_trivial_left (X := X) L)

/-- `L^∨ ⊗ L ≅ 𝒪_X` (left inverse), derived from right inverse + commutativity. -/
theorem tensor_dual_left (L : Carrier (X := X)) :
    (iso (X := X)).r (tensor (dual L) L) (trivial (X := X)) :=
  iso_trans (tensor_comm (dual L) L)
    (tensor_dual_right (X := X) L)

/-! ### The iso-class quotient and its `CommGroup` structure -/

/-- **Iso classes** of line bundles on `X` — the underlying set of the
Picard group `Pic(X)`. -/
def IsoClass (X : Type*) [LineBundleData X] : Type _ :=
  Quotient (LineBundleData.iso (X := X))

/-- Embed a line bundle into its iso class. -/
def classOf (L : Carrier (X := X)) : IsoClass X :=
  Quotient.mk (iso (X := X)) L

@[simp]
theorem classOf_eq (L : Carrier (X := X)) :
    Quotient.mk (iso (X := X)) L = (classOf L : IsoClass X) :=
  rfl

/-- Two line bundles have the same iso class iff they are isomorphic. -/
theorem classOf_eq_classOf_iff {L M : Carrier (X := X)} :
    (classOf L : IsoClass X) = classOf M ↔ (iso (X := X)).r L M :=
  Quotient.eq

/-- Tensor product descends to iso classes. -/
def tensorClass (a b : IsoClass X) : IsoClass X :=
  Quotient.liftOn₂ a b (fun L M => classOf (tensor L M))
    (fun _ _ _ _ hL hM => Quotient.sound (tensor_respects_iso hL hM))

/-- Dual descends to iso classes. -/
def dualClass (a : IsoClass X) : IsoClass X :=
  Quotient.liftOn a (fun L => classOf (dual L))
    (fun _ _ h => Quotient.sound (dual_respects_iso h))

/-- The trivial bundle as an iso class — the identity of `Pic`. -/
def trivialClass : IsoClass X := classOf (trivial (X := X))

@[simp]
theorem tensorClass_classOf (L M : Carrier (X := X)) :
    tensorClass (classOf L : IsoClass X) (classOf M) = classOf (tensor L M) :=
  rfl

@[simp]
theorem dualClass_classOf (L : Carrier (X := X)) :
    dualClass (classOf L : IsoClass X) = classOf (dual L) :=
  rfl

/-- Multiplication on `IsoClass X` is `tensor`. -/
instance : Mul (IsoClass X) := ⟨tensorClass⟩

/-- Identity on `IsoClass X` is the trivial bundle's iso class. -/
instance : One (IsoClass X) := ⟨trivialClass⟩

/-- Inverse on `IsoClass X` is the dual. -/
instance : Inv (IsoClass X) := ⟨dualClass⟩

@[simp]
theorem mul_classOf (L M : Carrier (X := X)) :
    (classOf L : IsoClass X) * classOf M = classOf (tensor L M) :=
  rfl

@[simp]
theorem one_eq : (1 : IsoClass X) = classOf (trivial (X := X)) :=
  rfl

@[simp]
theorem inv_classOf (L : Carrier (X := X)) :
    ((classOf L : IsoClass X))⁻¹ = classOf (dual L) :=
  rfl

/-! #### Group laws -/

theorem mul_assoc' (a b c : IsoClass X) :
    a * b * c = a * (b * c) := by
  refine Quotient.inductionOn₃ a b c (fun L M N => ?_)
  -- Strip the iso-class layer and reduce to the underlying congruence.
  show (classOf L * classOf M) * classOf N = classOf L * (classOf M * classOf N)
  rw [mul_classOf, mul_classOf, mul_classOf, mul_classOf]
  exact Quotient.sound (tensor_assoc L M N)

theorem mul_comm' (a b : IsoClass X) :
    a * b = b * a := by
  refine Quotient.inductionOn₂ a b (fun L M => ?_)
  show (classOf L : IsoClass X) * classOf M = classOf M * classOf L
  rw [mul_classOf, mul_classOf]
  exact Quotient.sound (tensor_comm L M)

theorem one_mul' (a : IsoClass X) : (1 : IsoClass X) * a = a := by
  refine Quotient.inductionOn a (fun L => ?_)
  show (1 : IsoClass X) * classOf L = classOf L
  rw [one_eq, mul_classOf]
  exact Quotient.sound (tensor_trivial_left L)

theorem mul_one' (a : IsoClass X) : a * (1 : IsoClass X) = a := by
  refine Quotient.inductionOn a (fun L => ?_)
  show (classOf L : IsoClass X) * 1 = classOf L
  rw [one_eq, mul_classOf]
  exact Quotient.sound (tensor_trivial_right L)

theorem inv_mul_cancel' (a : IsoClass X) :
    a⁻¹ * a = (1 : IsoClass X) := by
  refine Quotient.inductionOn a (fun L => ?_)
  show ((classOf L : IsoClass X))⁻¹ * classOf L = 1
  rw [inv_classOf, mul_classOf, one_eq]
  exact Quotient.sound (tensor_dual_left L)

theorem mul_inv_cancel' (a : IsoClass X) :
    a * a⁻¹ = (1 : IsoClass X) := by
  refine Quotient.inductionOn a (fun L => ?_)
  show (classOf L : IsoClass X) * (classOf L)⁻¹ = 1
  rw [inv_classOf, mul_classOf, one_eq]
  exact Quotient.sound (tensor_dual_right L)

/-- **The Picard group** `Pic(X) := IsoClass X` is a commutative group
under tensor product. -/
instance commGroup : CommGroup (IsoClass X) where
  mul := tensorClass
  one := trivialClass
  inv := dualClass
  mul_assoc := mul_assoc'
  mul_comm := mul_comm'
  one_mul := one_mul'
  mul_one := mul_one'
  inv_mul_cancel := inv_mul_cancel'

/-- The multiplication of two iso classes is the iso class of the tensor. -/
theorem mul_def (a b : IsoClass X) : a * b = tensorClass a b := rfl

/-- The inverse of an iso class is the iso class of the dual. -/
theorem inv_def (a : IsoClass X) : a⁻¹ = dualClass a := rfl

end LineBundleData

/-! ### Worked example: the trivial scheme `Spec(k)` -/

/-- **Example.** On a one-point space (`X := Unit`), the only line
bundle up to iso is the trivial bundle, so `Pic(Unit) = 1`.

We model this by setting `Carrier := Unit` with discrete-equality
setoid; every group law becomes definitional. This gives a
non-vacuous witness that the `LineBundleData` interface is
inhabited. -/
instance LineBundleData.trivialBundleOnPoint : LineBundleData Unit where
  Carrier := Unit
  trivial := ()
  tensor := fun _ _ => ()
  dual := fun _ => ()
  iso :=
    { r := fun _ _ => True
      iseqv :=
        { refl := fun _ => True.intro
          symm := fun _ => True.intro
          trans := fun _ _ => True.intro } }
  tensor_respects_iso := fun _ _ => True.intro
  dual_respects_iso := fun _ => True.intro
  tensor_trivial_left := fun _ => True.intro
  tensor_dual_right := fun _ => True.intro
  tensor_comm := fun _ _ => True.intro
  tensor_assoc := fun _ _ _ => True.intro

/-- Sanity check: any two elements of `IsoClass Unit` are equal,
i.e., `Pic(point)` is the trivial group. -/
theorem LineBundleData.IsoClass_Unit_subsingleton :
    ∀ a b : LineBundleData.IsoClass Unit, a = b := by
  intro a b
  refine Quotient.inductionOn₂ a b (fun _ _ => ?_)
  exact Quotient.sound True.intro

end HodgeReduction.Infrastructure.AlgebraicGeometry
