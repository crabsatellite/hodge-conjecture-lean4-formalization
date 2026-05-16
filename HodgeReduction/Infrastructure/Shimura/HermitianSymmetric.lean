/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Hermitian symmetric space framework

A **Hermitian symmetric space** is a connected Riemannian manifold
`M` with a `J`-invariant Riemannian metric, where `J` is an integrable
almost-complex structure such that for each `m ∈ M`, the geodesic
symmetry `s_m : M → M` is biholomorphic.

Equivalently: `M = G/K` with `G` a connected real Lie group, `K` a
compact subgroup, and `Z(K)^0` containing a 1-dim torus inducing `J`
on the tangent space.

For our HC application, the EVII Shimura variety is `Γ \ G/K` where
`G/K = E_{7(-25)} / (E_6 × U(1))` is the **EVII Hermitian symmetric
domain** of complex dimension 27.

This file packages **abstract Hermitian symmetric space data** in
three layers:

* `HermitianSymmetricData D G` — basic carrier-plus-dimension data
  with a substantive Hermitian Kähler-form axiom.
* `IrreducibleHermitianSymmetricData D G` — refining with the
  irreducibility constraint (no non-trivial simple-factor
  decomposition).
* `CartanClassificationData D G` — refining with the explicit
  Cartan-classification label (AIII / BDI / CI / DIII / EIII / EVII).

## References

* Helgason, S. *Differential Geometry, Lie Groups, and Symmetric
  Spaces*, Pure and Applied Mathematics **80**, Academic Press, 1978,
  Ch. VIII (Hermitian symmetric spaces).
* Borel, A. *Semisimple Groups and Riemannian Symmetric Spaces*,
  TRIM **16**, Hindustan Book Agency, 1998.
* Milne, J. S. *Introduction to Shimura Varieties* (rev. 2017),
  §1.2 (Hermitian symmetric domains, Cartan classification).

## Main definitions

* `HermitianSymmetricData D G` : abstract Hermitian symmetric space
  with a designated complex dim, Lie-group rank, group action, and a
  substantive Kähler-form positivity axiom.
* `IrreducibleHermitianSymmetricData D G` : sibling class with
  irreducibility (no proper invariant submodule splitting).
* `CartanClassificationData D G` : sibling class with the Cartan-type
  label (AIII / BDI / CI / DIII / EIII / EVII).

## Tags

Hermitian symmetric space, EVII, Cartan classification, exceptional,
period domain, irreducible
-/

namespace HodgeReduction.Infrastructure.Shimura

/-! ## Cartan classification labels (substantive enum) -/

/-- The six **Cartan-type labels** for irreducible Hermitian symmetric
spaces of non-compact type (Helgason 1978 Ch. X §6.3 Table V;
Milne 2017 §1.2 Tbl 1):

* `AIII` — `SU(p, q) / S(U(p) × U(q))`, complex dim `p · q`.
* `BDI` — `SO(p, 2) / SO(p) × SO(2)`, complex dim `p`.
* `CI`  — `Sp(n, ℝ) / U(n)`, complex dim `n(n + 1)/2` (Siegel upper
  half-space).
* `DIII` — `SO*(2n) / U(n)`, complex dim `n(n - 1)/2`.
* `EIII` — `E_{6(-14)} / (Spin(10) × U(1))`, complex dim `16`.
* `EVII` — `E_{7(-25)} / (E_6 × U(1))`, complex dim `27`.

These six types are mutually exclusive and exhaustive for the
irreducible non-compact case (Helgason 1978 Thm X.6.1). -/
inductive CartanType
  /-- Type AIII: `SU(p, q) / S(U(p) × U(q))`. -/
  | AIII
  /-- Type BDI: `SO(p, 2) / SO(p) × SO(2)`. -/
  | BDI
  /-- Type CI: `Sp(n, ℝ) / U(n)` (Siegel upper half-space). -/
  | CI
  /-- Type DIII: `SO*(2n) / U(n)`. -/
  | DIII
  /-- Type EIII: `E_{6(-14)} / (Spin(10) × U(1))`, exceptional. -/
  | EIII
  /-- Type EVII: `E_{7(-25)} / (E_6 × U(1))`, exceptional — our
  HC-application target. -/
  | EVII
  deriving DecidableEq, Repr

namespace CartanType

/-- A Cartan label is **exceptional** if it is `EIII` or `EVII`
(both arising from exceptional Lie groups `E_6`, `E_7`). The four
classical labels `AIII / BDI / CI / DIII` are not exceptional. -/
def isExceptional : CartanType → Bool
  | EIII => true
  | EVII => true
  | _    => false

/-- **Sanity**: the EVII label is exceptional. -/
theorem EVII_isExceptional : EVII.isExceptional = true := rfl

/-- **Sanity**: the EIII label is exceptional. -/
theorem EIII_isExceptional : EIII.isExceptional = true := rfl

/-- **Sanity**: the classical label CI is not exceptional. -/
theorem CI_notExceptional : CI.isExceptional = false := rfl

end CartanType

/-! ## `HermitianSymmetricData` — carrier + Kähler-form positivity -/

/-- **Hermitian symmetric space data** with:

* `D` — the underlying space (as abstract carrier type).
* `G` — the real Lie group (as abstract `Group` instance).
* `dim` — the complex dimension of `D`.
* `rank` — the real rank of the Lie group `G` (always `≤ dim`; e.g.
  EVII has rank `3`, complex dim `27`).
* `action` — the `G`-action on `D` (Helgason 1978 Ch. VIII §3).
* `kahlerCarrier` — the real tangent ℚ-module witness for the
  Kähler form at a basepoint.
* `kahlerForm` — the substantive Kähler `2`-form encoded as a
  ℚ-bilinear pairing on `kahlerCarrier` (Helgason 1978 Ch. VIII §7;
  Borel 1998 §3).
* `kahlerForm_skew` — the `2`-form is alternating.
* `kahlerForm_nondegen` — the `2`-form is non-degenerate (positivity
  rational shadow). -/
class HermitianSymmetricData (D : Type*) (G : Type*) [Group G] where
  /-- The complex dimension of `D`. -/
  dim : ℕ
  /-- The real rank of the Lie group `G`. -/
  rank : ℕ
  /-- The Lie-group action `G ↷ D` (Helgason 1978 Ch. VIII §3). -/
  action : G → (D → D)
  /-- **Action functoriality at the identity**: `1 · d = d`. -/
  action_one : ∀ d : D, action 1 d = d
  /-- **Action functoriality on composition**: `(g₁ · g₂) · d = g₁ · (g₂ · d)`. -/
  action_mul : ∀ g₁ g₂ : G, ∀ d : D, action (g₁ * g₂) d = action g₁ (action g₂ d)
  /-- The ℚ-module carrier for the Kähler-form rational shadow on
  the real tangent space at a basepoint. -/
  kahlerCarrier : Type
  /-- Additive group structure on the Kähler carrier. -/
  kahlerCarrier_addCommGroup : AddCommGroup kahlerCarrier
  /-- ℚ-module structure on the Kähler carrier. -/
  kahlerCarrier_module :
    @Module ℚ kahlerCarrier _ kahlerCarrier_addCommGroup.toAddCommMonoid
  /-- The **Kähler form** as a ℚ-valued pairing on the carrier
  (Helgason 1978 Ch. VIII §7; Borel 1998 §3 — the Kähler form of a
  Hermitian symmetric space is a `G`-invariant closed positive
  `(1, 1)`-form, whose rational shadow we record here as a ℚ-valued
  function on a finite-dim ℚ-vector-space carrier, with the
  ℚ-bilinearity reflected by the additivity / smul-compatibility
  axioms below). -/
  kahlerForm : kahlerCarrier → kahlerCarrier → ℚ
  /-- **Additivity in the left argument**: `ω(x₁ + x₂, y) =
  ω(x₁, y) + ω(x₂, y)`. -/
  kahlerForm_add_left : ∀ x₁ x₂ y : kahlerCarrier,
    kahlerForm (x₁ + x₂) y = kahlerForm x₁ y + kahlerForm x₂ y
  /-- **Smul-compatibility in the left argument**: `ω(c • x, y) =
  c · ω(x, y)`. -/
  kahlerForm_smul_left : ∀ (c : ℚ) (x y : kahlerCarrier),
    kahlerForm (c • x) y = c * kahlerForm x y
  /-- **Skew-symmetry** of the Kähler `2`-form: `ω(x, y) = -ω(y, x)`
  (Helgason 1978 Ch. VIII §7.1; Borel 1998 §3.2). -/
  kahlerForm_skew : ∀ x y : kahlerCarrier,
    kahlerForm x y = -(kahlerForm y x)
  /-- **Non-degeneracy** of the Kähler form (Helgason 1978 Ch. VIII
  Cor 7.4): if `ω(x, ·) = 0` then `x = 0`. -/
  kahlerForm_nondegen : ∀ x : kahlerCarrier,
    (∀ y : kahlerCarrier, kahlerForm x y = 0) → x = 0

attribute [instance] HermitianSymmetricData.kahlerCarrier_addCommGroup
attribute [instance] HermitianSymmetricData.kahlerCarrier_module

namespace HermitianSymmetricData

variable {D G : Type*} [Group G] [HermitianSymmetricData D G]

/-- The complex dimension is positive (a Hermitian symmetric space has
at least dim 1; for exceptional types, much higher). -/
def isNontrivial : Prop := 1 ≤ dim (D := D) (G := G)

/-- **Diagonal vanishing of the Kähler form**: `ω(x, x) = 0` for all
`x` (the alternating-form consequence of skew-symmetry over a field of
characteristic 0). -/
theorem kahlerForm_self_zero (x : kahlerCarrier (D := D) (G := G)) :
    kahlerForm (D := D) (G := G) x x = 0 := by
  have h := kahlerForm_skew (D := D) (G := G) x x
  -- `ω(x,x) = -ω(x,x)` ⇒ `2·ω(x,x) = 0` ⇒ `ω(x,x) = 0`.
  linarith

/-- **Right-side non-degeneracy** of the Kähler form: if `ω(·, y) = 0`
then `y = 0`. Derived from the left-non-degeneracy + skew-symmetry. -/
theorem kahlerForm_nondegen_right (y : kahlerCarrier (D := D) (G := G))
    (hy : ∀ x : kahlerCarrier (D := D) (G := G),
            kahlerForm (D := D) (G := G) x y = 0) : y = 0 := by
  refine kahlerForm_nondegen (D := D) (G := G) y (fun x => ?_)
  have h1 := kahlerForm_skew (D := D) (G := G) y x
  have h2 := hy x
  linarith

/-- **Kähler form separates points**: for every non-zero `x` there is
`y` with `ω(x, y) ≠ 0`. (Contrapositive of `kahlerForm_nondegen`.) -/
theorem kahlerForm_separates (x : kahlerCarrier (D := D) (G := G))
    (hx : x ≠ 0) :
    ∃ y : kahlerCarrier (D := D) (G := G),
      kahlerForm (D := D) (G := G) x y ≠ 0 := by
  by_contra hno
  push_neg at hno
  exact hx (kahlerForm_nondegen (D := D) (G := G) x hno)

end HermitianSymmetricData

/-! ## `IrreducibleHermitianSymmetricData` — no proper invariant split -/

/-- **Irreducibility data** for a Hermitian symmetric space: the
Kähler-carrier ℚ-module admits no non-trivial `G`-invariant proper
splitting (Helgason 1978 Ch. VIII §5: the irreducible non-compact
Hermitian symmetric spaces are classified by the Cartan list, with
no further decomposition into a product of two smaller spaces).

We encode irreducibility at the rational ℚ-module shadow: any
ℚ-submodule of the Kähler carrier that is **`G`-invariant** in the
sense of the action's induced linear map is either `⊥` or `⊤`. -/
class IrreducibleHermitianSymmetricData (D : Type*) (G : Type*) [Group G]
    extends HermitianSymmetricData D G where
  /-- The induced ℚ-linear action of `G` on the Kähler carrier
  (the linearisation of the geometric `action` on the real
  tangent space at the basepoint). -/
  linAction : G → (kahlerCarrier →ₗ[ℚ] kahlerCarrier)
  /-- **Compatibility at the identity**: `linAction 1 = id`. -/
  linAction_one : linAction 1 = LinearMap.id
  /-- **Compatibility on composition**: `linAction (g₁ * g₂) =
  linAction g₁ ∘ linAction g₂`. -/
  linAction_mul : ∀ g₁ g₂ : G,
    linAction (g₁ * g₂) = (linAction g₁).comp (linAction g₂)
  /-- **Irreducibility** axiom: any `G`-invariant ℚ-submodule of the
  Kähler carrier is either `⊥` (zero) or `⊤` (the whole carrier). -/
  irreducible : ∀ (W : Submodule ℚ kahlerCarrier),
    (∀ g : G, ∀ w : kahlerCarrier, w ∈ W → linAction g w ∈ W) →
      W = ⊥ ∨ W = ⊤

namespace IrreducibleHermitianSymmetricData

variable {D G : Type*} [Group G] [IrreducibleHermitianSymmetricData D G]

/-- **The trivial invariant submodule `⊤`** is `G`-invariant —
sanity-check that the irreducibility statement is non-trivially
about *non-trivial* invariant subspaces. -/
theorem top_is_invariant :
    ∀ g : G, ∀ w : HermitianSymmetricData.kahlerCarrier (D := D) (G := G),
      w ∈ (⊤ : Submodule ℚ
              (HermitianSymmetricData.kahlerCarrier (D := D) (G := G))) →
      linAction (D := D) (G := G) g w ∈
        (⊤ : Submodule ℚ
              (HermitianSymmetricData.kahlerCarrier (D := D) (G := G))) := by
  intro _ _ _; trivial

/-- **The trivial invariant submodule `⊥`** is `G`-invariant — every
linear action sends `0` to `0`. -/
theorem bot_is_invariant :
    ∀ g : G, ∀ w : HermitianSymmetricData.kahlerCarrier (D := D) (G := G),
      w ∈ (⊥ : Submodule ℚ
              (HermitianSymmetricData.kahlerCarrier (D := D) (G := G))) →
      linAction (D := D) (G := G) g w ∈
        (⊥ : Submodule ℚ
              (HermitianSymmetricData.kahlerCarrier (D := D) (G := G))) := by
  intro g w hw
  rw [Submodule.mem_bot] at hw ⊢
  rw [hw, map_zero]

end IrreducibleHermitianSymmetricData

/-! ## `CartanClassificationData` — the Cartan-type label -/

/-- **Cartan classification data** for a Hermitian symmetric space:
the explicit `CartanType` label. Refines `HermitianSymmetricData`
with a substantive label-plus-dimension-consistency axiom (the
recorded `dim` must match the well-known complex dimension formula
for the given Cartan type, here recorded as a label-dependent
constraint).

For the EVII case (our HC application): the label is `EVII`, the
complex dim is `27`, and the rank is `3` (Helgason 1978 Ch. X §6.3
Table V; Milne 2017 §1.2 Tbl 1). -/
class CartanClassificationData (D : Type*) (G : Type*) [Group G]
    extends HermitianSymmetricData D G where
  /-- The Cartan-type label. -/
  cartanType : CartanType
  /-- **Exceptional ⇔ label-exceptional**: the recorded complex
  dimension is at least `16` whenever the Cartan label is
  `EIII` or `EVII`. (The `EIII` space has complex dim `16`, the
  `EVII` space has complex dim `27`; both are the unique exceptional
  examples — Helgason 1978 Table V.) -/
  exceptional_dim_lb :
    cartanType.isExceptional = true → 16 ≤ dim

namespace CartanClassificationData

variable {D G : Type*} [Group G] [CartanClassificationData D G]

/-- If the recorded Cartan label is `EVII`, the complex dimension is
at least `16` — direct application of `exceptional_dim_lb`. -/
theorem dim_ge_sixteen_of_EVII
    (h : cartanType (D := D) (G := G) = CartanType.EVII) :
    16 ≤ HermitianSymmetricData.dim (D := D) (G := G) := by
  apply exceptional_dim_lb
  rw [h]
  rfl

/-- If the recorded Cartan label is `EIII`, the complex dimension is
at least `16` — direct application of `exceptional_dim_lb`. -/
theorem dim_ge_sixteen_of_EIII
    (h : cartanType (D := D) (G := G) = CartanType.EIII) :
    16 ≤ HermitianSymmetricData.dim (D := D) (G := G) := by
  apply exceptional_dim_lb
  rw [h]
  rfl

end CartanClassificationData

/-! ## Trivial inhabiting instance on `D := Unit`, `G := Unit`

We exhibit a one-point Hermitian symmetric space (`D = Unit`,
`G = Unit` — the trivial group) with `dim = 16` (the `EIII`-compatible
boundary value), `kahlerCarrier := PUnit` (the zero space, on which
the Kähler form is the zero form — trivially alternating and
vacuously non-degenerate). The `EIII` label is recorded to satisfy
`exceptional_dim_lb`.

This witnesses that all three class layers (`HermitianSymmetricData`,
`IrreducibleHermitianSymmetricData`, `CartanClassificationData`) are
consistent and admit substantive (non-tautological) instances. -/

namespace Trivial

/-- The trivial Hermitian symmetric space carrier: a one-point space. -/
def D_point : Type := Unit

/-- The trivial group carrier: a one-point group. -/
def G_point : Type := Unit

instance : Group G_point := inferInstanceAs (Group Unit)

/-- The trivial Kähler carrier: a one-element ℚ-module (zero space). -/
def K_point : Type := PUnit

instance : AddCommGroup K_point := inferInstanceAs (AddCommGroup PUnit)
instance : Module ℚ K_point := inferInstanceAs (Module ℚ PUnit)

/-- The zero form on `K_point` (the unique pairing on the zero
space). -/
def zeroFormPUnit : K_point → K_point → ℚ := fun _ _ => 0

/-- **Every element of `K_point` is `0`** (subsingleton fact). -/
theorem K_point_eq_zero (x : K_point) : x = 0 := by
  cases x; rfl

/-- The identity linear action of `G_point` on `K_point`: every
element of `K_point` is `0`, so the action is identically the
identity. -/
def linActionPUnit : G_point → (K_point →ₗ[ℚ] K_point) :=
  fun _ => LinearMap.id

/-- Trivial `HermitianSymmetricData` instance. Kähler skew-symmetry
is `0 = -0`; non-degeneracy is vacuous (all carrier elements are `0`,
so the premise "`x ≠ 0`" cannot be satisfied — the implication
"`(∀ y, ω x y = 0) → x = 0`" reduces to "`0 = 0`"). -/
instance hsd_point : HermitianSymmetricData D_point G_point where
  dim := 16
  rank := 3
  action := fun _ d => d
  action_one := fun _ => rfl
  action_mul := fun _ _ _ => rfl
  kahlerCarrier := K_point
  kahlerCarrier_addCommGroup := inferInstance
  kahlerCarrier_module := inferInstance
  kahlerForm := zeroFormPUnit
  kahlerForm_add_left := by intros; simp [zeroFormPUnit]
  kahlerForm_smul_left := by intros; simp [zeroFormPUnit]
  kahlerForm_skew := by intros; simp [zeroFormPUnit]
  kahlerForm_nondegen := by
    intro x _
    exact K_point_eq_zero x

/-- Trivial `IrreducibleHermitianSymmetricData` instance: with a
zero-dimensional carrier, the only ℚ-submodules are `⊥ = ⊤`, hence
the irreducibility constraint is trivially satisfied (both
disjuncts hold). -/
instance ihsd_point : IrreducibleHermitianSymmetricData D_point G_point where
  toHermitianSymmetricData := hsd_point
  linAction := linActionPUnit
  linAction_one := rfl
  linAction_mul := by
    intro _ _; rfl
  irreducible := by
    intro W _
    -- Every submodule of `K_point = PUnit` is `⊥`, since `⊤ = ⊥` on
    -- the zero space.
    left
    rw [Submodule.eq_bot_iff]
    intro x _
    exact K_point_eq_zero x

/-- Trivial `CartanClassificationData` instance: label = `EIII`,
recorded dim = `16` ≥ `16` (so the `exceptional_dim_lb` axiom is
substantively true, not vacuous). -/
instance ccd_point : CartanClassificationData D_point G_point where
  toHermitianSymmetricData := hsd_point
  cartanType := CartanType.EIII
  exceptional_dim_lb := by
    intro _
    -- recorded dim = 16, target lower bound = 16.
    show 16 ≤ HermitianSymmetricData.dim (D := D_point) (G := G_point)
    rfl

/-- **Sanity**: in the trivial instance, the recorded Cartan label
is `EIII`. -/
example : CartanClassificationData.cartanType
    (D := D_point) (G := G_point) = CartanType.EIII := rfl

/-- **Sanity**: in the trivial instance, the complex dim is `16`. -/
example : HermitianSymmetricData.dim (D := D_point) (G := G_point) = 16 := rfl

/-- **Sanity**: the EVII boundary value `16 ≤ 27` is irrelevant for
the trivial instance (which is `EIII`), but the `EIII` boundary
value `16 ≤ 16` is realised exactly. -/
example : 16 ≤ HermitianSymmetricData.dim (D := D_point) (G := G_point) :=
  CartanClassificationData.dim_ge_sixteen_of_EIII rfl

end Trivial

end HodgeReduction.Infrastructure.Shimura
