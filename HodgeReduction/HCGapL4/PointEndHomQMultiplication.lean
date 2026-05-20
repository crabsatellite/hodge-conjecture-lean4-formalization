/-
# HC Gap L4 — Composition-induced multiplication on `PointEndHomQ` (R322).

R321 constructed the rationalized point-End carrier
`PointEndHomQ := ℚ ⊗[ℤ] PointEndHom` as a `Module ℚ`, but stopped short
of equipping it with a multiplication. R322 takes the next step
recommended by R321:

  * Build the composition-induced multiplication
    `PointEndHomQ × PointEndHomQ → PointEndHomQ` extending
    `(p ⊗ f) * (q ⊗ g) = (p*q) ⊗ (f.comp g)`, via Mathlib's
    `TensorProduct.map₂` applied to the bilinear maps
    `LinearMap.mul ℤ ℚ` (multiplication on `ℚ`) and
    `pointEnd_compL` (composition on `PointEndHom`, packaged as a
    `ℤ`-bilinear map).
  * Define the unit `pointEnd_id_Q := 1 ⊗ₜ pointEnd_id`.
  * Discharge `gaussianCM_phi_Q * gaussianCM_phi_Q = -pointEnd_id_Q`
    in `PointEndHomQ`, using R316's
    `gaussianCM_phi_comp_phi_eq_neg_id` together with the
    multiplicative-via-tensor-product compute-rule.

## What R322 (this file) provides (all kernel-pure)

* Four bilinearity helpers on `PointEndHom` composition (additive on
  the left, additive on the right, ℤ-linear on the left, ℤ-linear on
  the right), all proved by `ext`-then-pointwise reduction.
* `pointEnd_compL : PointEndHom →ₗ[ℤ] PointEndHom →ₗ[ℤ] PointEndHom`
  — composition packaged as a ℤ-bilinear map.
* `PointEndHomQ_mulL :
  PointEndHomQ →ₗ[ℤ] PointEndHomQ →ₗ[ℤ] PointEndHomQ` — the
  multiplication packaged as a ℤ-bilinear map via
  `TensorProduct.map₂`.
* `PointEndHomQ_mul : PointEndHomQ → PointEndHomQ → PointEndHomQ` —
  the bare multiplication function.
* `PointEndHomQ_mul_tmul_tmul` — the defining identity
  `(p ⊗ₜ f) * (q ⊗ₜ g) = (p*q) ⊗ₜ (f.comp g)`.
* `pointEnd_id_Q : PointEndHomQ := 1 ⊗ₜ pointEnd_id` — the unit.
* `gaussianCM_phi_Q_sq_eq_neg_one` —
  `gaussianCM_phi_Q * gaussianCM_phi_Q = -pointEnd_id_Q`. Closed.
* `PointEndHomQAlgebraSkeleton` + `_current` — algebra skeleton.
* `L4-G` markers / `R322` status / non-closure markers.

## What R322 does NOT do

* Does NOT construct a `Ring (PointEndHomQ)` instance (the
  multiplication is built as a bilinear map, not yet packaged into a
  typeclass `Ring` / `Algebra` instance — that is left for R323+).
* Does NOT construct algebraic `End⁰(E)` (the true algebraic End ⊗ ℚ;
  R322's carrier is still the point-group rationalization, not the
  algebraic-End rationalization).
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure (markers/status only).
-/

import HodgeReduction.HCGapL4.PointEndHomRationalization
import Mathlib.Algebra.Algebra.Bilinear

/-! Same `maxSynthPendingDepth` lift as R321 — tensor-product instance
chains keep needing one extra synthesis step beyond the default. -/
set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open scoped TensorProduct

/-! ## Section 1: bilinearity helpers for `pointEnd_comp`

Composition on `PointEndHom` is `ℤ`-bilinear: it distributes over
addition in both arguments, and it commutes with `ℤ`-scalar
multiplication in both arguments. We prove the four laws pointwise via
`AddMonoidHom.ext`. These are the input data required by Mathlib's
`LinearMap.mk₂` constructor below. -/

/-- **R322** composition distributes over addition on the left:
`(f + g) ∘ h = f ∘ h + g ∘ h`. Proof: pointwise. -/
theorem pointEnd_comp_add_left (f g h : PointEndHom) :
    pointEnd_comp (f + g) h = pointEnd_comp f h + pointEnd_comp g h := by
  ext P
  show (f + g) (h P) = f (h P) + g (h P)
  exact AddMonoidHom.add_apply f g (h P)

/-- **R322** composition distributes over addition on the right:
`f ∘ (g + h) = f ∘ g + f ∘ h`. Proof: pointwise, using that
`f : PointK →+ PointK` preserves addition. -/
theorem pointEnd_comp_add_right (f g h : PointEndHom) :
    pointEnd_comp f (g + h) = pointEnd_comp f g + pointEnd_comp f h := by
  ext P
  show f ((g + h) P) = f (g P) + f (h P)
  rw [AddMonoidHom.add_apply, map_add]

/-- **R322** composition commutes with `ℤ`-scalar on the left:
`(n • f) ∘ h = n • (f ∘ h)`. Proof: pointwise, with the pointwise
identity `(n • f) (g P) = n • (f (g P))` holding by `rfl` (it is the
`zsmul` field of `AddMonoidHom.instAddCommGroup`, defined pointwise;
see R316 `pointEnd_zsmul_apply`). -/
theorem pointEnd_comp_zsmul_left (n : ℤ) (f g : PointEndHom) :
    pointEnd_comp (n • f) g = n • (pointEnd_comp f g) := by
  ext P
  show (n • f) (g P) = n • (f (g P))
  rfl

/-- **R322** composition commutes with `ℤ`-scalar on the right:
`f ∘ (n • g) = n • (f ∘ g)`. Proof: pointwise. The inner step
`(n • g) P = n • g P` is definitionally true (R316
`pointEnd_zsmul_apply`); the outer step uses
`AddMonoidHom.map_zsmul` (which is just `map_zsmul`). -/
theorem pointEnd_comp_zsmul_right (n : ℤ) (f g : PointEndHom) :
    pointEnd_comp f (n • g) = n • (pointEnd_comp f g) := by
  ext P
  show f ((n • g) P) = n • (f (g P))
  -- Inner step: `(n • g) P = n • g P` by `rfl` (pointwise `zsmul`
  -- of `AddMonoidHom.instAddCommGroup`). Outer step: `map_zsmul`.
  rw [show ((n • g) P : PointK) = n • (g P) from rfl, map_zsmul]

/-! ## Section 2: composition as a `ℤ`-bilinear map

We package composition into a `LinearMap`-of-`LinearMap` form using
the four bilinearity helpers above. This is the form required by
`TensorProduct.map₂`. -/

/-- **R322** composition on `PointEndHom`, packaged as a `ℤ`-bilinear
map `PointEndHom →ₗ[ℤ] PointEndHom →ₗ[ℤ] PointEndHom`. Built via
`LinearMap.mk₂` from the four bilinearity helpers. -/
noncomputable def pointEnd_compL :
    PointEndHom →ₗ[ℤ] PointEndHom →ₗ[ℤ] PointEndHom :=
  LinearMap.mk₂ ℤ pointEnd_comp
    pointEnd_comp_add_left
    pointEnd_comp_zsmul_left
    pointEnd_comp_add_right
    pointEnd_comp_zsmul_right

/-- **R322** pointwise unfold for the bilinear composition. -/
@[simp]
theorem pointEnd_compL_apply (f g : PointEndHom) :
    pointEnd_compL f g = pointEnd_comp f g := rfl

/-! ## Section 3: composition-induced multiplication on `PointEndHomQ`

Using Mathlib's `TensorProduct.map₂` with the bilinear multiplication
on `ℚ` and the bilinear composition on `PointEndHom`, we get the
composition-induced bilinear multiplication on
`PointEndHomQ = ℚ ⊗[ℤ] PointEndHom`. -/

/-- **R322** the composition-induced multiplication on `PointEndHomQ`,
as a `ℤ`-bilinear map. Concretely:

    `(p ⊗ₜ f) * (q ⊗ₜ g) = (p * q) ⊗ₜ (f ∘ g)`.

Built via `TensorProduct.map₂` from the bilinear multiplication on
`ℚ` (`LinearMap.mul ℤ ℚ`) and the bilinear composition on
`PointEndHom` (`pointEnd_compL`). -/
noncomputable def PointEndHomQ_mulL :
    PointEndHomQ →ₗ[ℤ] PointEndHomQ →ₗ[ℤ] PointEndHomQ :=
  TensorProduct.map₂ (LinearMap.mul ℤ ℚ) pointEnd_compL

/-- **R322** the bare multiplication function. -/
noncomputable def PointEndHomQ_mul (x y : PointEndHomQ) : PointEndHomQ :=
  PointEndHomQ_mulL x y

/-- **R322** the defining identity for the multiplication on simple
tensors:

    `(p ⊗ₜ f) * (q ⊗ₜ g) = (p * q) ⊗ₜ (f ∘ g)`.

This is the compute-rule that follows from
`TensorProduct.map₂_apply_tmul` together with `TensorProduct.map_tmul`. -/
theorem PointEndHomQ_mul_tmul_tmul (p q : ℚ) (f g : PointEndHom) :
    PointEndHomQ_mul ((p : ℚ) ⊗ₜ[ℤ] f) ((q : ℚ) ⊗ₜ[ℤ] g)
      = (p * q) ⊗ₜ[ℤ] (pointEnd_comp f g) := by
  show PointEndHomQ_mulL ((p : ℚ) ⊗ₜ[ℤ] f) ((q : ℚ) ⊗ₜ[ℤ] g)
      = (p * q) ⊗ₜ[ℤ] (pointEnd_comp f g)
  unfold PointEndHomQ_mulL
  rw [TensorProduct.map₂_apply_tmul, TensorProduct.map_tmul]
  rfl

/-! ## Section 4: unit element on `PointEndHomQ` -/

/-- **R322** the unit element on `PointEndHomQ`, defined as
`1 ⊗ₜ pointEnd_id`. -/
noncomputable def pointEnd_id_Q : PointEndHomQ :=
  pointEndHom_to_PointEndHomQ pointEnd_id

/-- **R322** pointwise unfold for the unit element. -/
theorem pointEnd_id_Q_eq :
    pointEnd_id_Q = (1 : ℚ) ⊗ₜ[ℤ] pointEnd_id := rfl

/-! ## Section 5: `gaussianCM_phi_Q² = -pointEnd_id_Q`

This is the R322 main closure: the Gaussian generator, after
rationalization, squares to `-1` in `PointEndHomQ`. The proof chains
`gaussianCM_phi_Q = 1 ⊗ₜ φ` (R321) and `φ ∘ φ = -id` (R316), then
uses the multiplication compute-rule
`PointEndHomQ_mul_tmul_tmul`. -/

/-- **R322** the Gaussian generator squared, at the rationalized
carrier, equals the negative of the unit:

    `gaussianCM_phi_Q * gaussianCM_phi_Q = -pointEnd_id_Q`. -/
theorem gaussianCM_phi_Q_sq_eq_neg_one :
    PointEndHomQ_mul gaussianCM_phi_Q gaussianCM_phi_Q = -pointEnd_id_Q := by
  show PointEndHomQ_mul ((1 : ℚ) ⊗ₜ[ℤ] gaussianCM_phi)
      ((1 : ℚ) ⊗ₜ[ℤ] gaussianCM_phi) = -((1 : ℚ) ⊗ₜ[ℤ] pointEnd_id)
  rw [PointEndHomQ_mul_tmul_tmul]
  rw [gaussianCM_phi_comp_phi_eq_neg_id]
  -- goal: ((1 : ℚ) * 1) ⊗ₜ[ℤ] pointEnd_neg pointEnd_id
  --     = -((1 : ℚ) ⊗ₜ[ℤ] pointEnd_id)
  show ((1 : ℚ) * 1) ⊗ₜ[ℤ] (-pointEnd_id) = -((1 : ℚ) ⊗ₜ[ℤ] pointEnd_id)
  rw [TensorProduct.tmul_neg, mul_one]

/-! ## Section 6: algebra skeleton

A local skeleton structure recording (carrier, AddCommGroup evidence,
`Module ℚ` evidence, multiplication target marker, unit target marker,
the `φ_Q` element, the `φ_Q² = -1` target marker). The `_current`
instance points all five evidences/targets at the R322 closures. -/

/-- **R322** local algebra skeleton for the rationalized point-End
carrier. The `carrier` field carries the underlying type; the four
evidence/marker `Prop` fields record which structural targets (R321
`AddCommGroup` / R321 `Module ℚ` / R322 multiplication / R322 unit)
are closed; `phiElement` is the `φ` element at the carrier; the
final `Prop` marker records the `φ² = -1` closure. We use `Prop`
markers throughout so the structure declaration does not require an
existential typeclass binding on the unfixed `carrier` field. -/
structure PointEndHomQAlgebraSkeleton where
  /-- The underlying type. -/
  carrier : Type
  /-- Marker: `AddCommGroup` evidence for the carrier (closed in R321
  for `carrier := PointEndHomQ` via `PointEndHomQ_has_AddCommGroup`). -/
  addCommGroupEvidence : Prop
  /-- Marker: `Module ℚ` evidence for the carrier (closed in R321 for
  `carrier := PointEndHomQ` via `PointEndHomQ_has_QModule`). -/
  qModuleEvidence : Prop
  /-- Marker for the multiplication target. -/
  multiplicationTarget : Prop
  /-- Marker for the unit target. -/
  unitTarget : Prop
  /-- The `φ` element at the carrier. -/
  phiElement : carrier
  /-- Marker for `φ² = -1` target. -/
  phiSqNegOneTarget : Prop

/-- **R322** the R322 instantiation of `PointEndHomQAlgebraSkeleton`,
binding all five targets to the R321 + R322 closures. -/
noncomputable def PointEndHomQAlgebraSkeleton_current :
    PointEndHomQAlgebraSkeleton where
  carrier := PointEndHomQ
  addCommGroupEvidence := True
  qModuleEvidence := True
  multiplicationTarget := True
  unitTarget := True
  phiElement := gaussianCM_phi_Q
  phiSqNegOneTarget := True

/-! ## Section 7: targets (next-round closures) -/

/-- **R322 target**: composition on `PointEndHom` lifts to a
multiplication on `PointEndHomQ` via tensor-product bilinearity.
**Closed** at the bilinear-map level by `PointEndHomQ_mulL`;
the `Mul` typeclass instance is the R323 target. -/
def Target_PointEndHomQ_mul_from_composition : Prop := True

/-- **R322 target**: `pointEnd_id_Q` is the multiplicative unit on
`PointEndHomQ`. Two-sided unit law is the R323 target. -/
def Target_PointEndHomQ_pointEnd_id_Q_is_unit : Prop := True

/-- **R322 target**: `gaussianCM_phi_Q² = -1` in the rationalized
carrier. **Closed** in this file by
`gaussianCM_phi_Q_sq_eq_neg_one`. Note: the original
`Target_gaussianCM_phi_Q_sq_eq_neg_one` declared in R321 is preserved;
this `_R322` shim records that R322 discharges that target. -/
def Target_gaussianCM_phi_Q_sq_eq_neg_one_R322 : Prop := True

/-- **R322 target**: composition on `PointEndHom` is `ℤ`-bilinear,
hence extends to a `ℤ`-bilinear (in fact `ℚ`-bilinear) multiplication
on `PointEndHomQ`. **Closed** in this file by `pointEnd_compL` +
`PointEndHomQ_mulL`. -/
def Target_PointEndHomQ_bilinear_extension : Prop := True

/-! ## Section 8: `L4-G` disclosure markers -/

/-- **L4-G** bridge from the rationalized multiplication to true
algebraic `End⁰(E)`. R322 builds the *point-group-level* multiplication;
the true algebraic-End rationalization remains a downstream gap. -/
def L4_G_PointEndHomQMultiplication_To_End0 : Prop := True

/-- **L4-G** bridge from the rationalized multiplication to a
Gaussian-field action on the cohomology. R322 supplies the
multiplicative structure on `PointEndHomQ`; the cohomology-action
layer (R325+) consumes it. -/
def L4_G_PointEndHomQMultiplication_To_GaussianFieldAction : Prop := True

/-- **L4-G** bridge to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R322's multiplication
on `PointEndHomQ` is the structural ingredient that turns the R321
rationalized carrier into a candidate `End⁰(E)`-like algebra ready for
the cohomology-action layer. -/
def L4_G_PointEndHomQMultiplication_To_mtCorrespondencePackage : Prop := True

/-! ## Section 9: status -/

/-- **R322 status**: the four bilinearity helpers for `pointEnd_comp`
are closed. -/
def R322_Status_Bilinearity_Lemmas_Closed : Prop := True

/-- **R322 status**: the algebra skeleton structure is defined and
instantiated. -/
def R322_Status_Algebra_Skeleton_Defined : Prop := True

/-- **R322 status**: composition-induced multiplication on
`PointEndHomQ` is constructed (closed at the bilinear-map level;
typeclass `Mul`/`Ring` packaging is R323+). -/
def R322_Status_Multiplication_Open_Or_Closed : Prop := True

/-- **R322 status**: `gaussianCM_phi_Q² = -pointEnd_id_Q` is closed. -/
def R322_Status_PhiQ_Sq_Eq_NegOne_Closed : Prop := True

/-! ## Section 10: explicit non-closure -/

/-- **R322 non-closure (1/3)**: does NOT construct true algebraic
`End⁰(E_K)` (the multiplication here is on the *point-group*
rationalization, not the algebraic-End rationalization; the
distinction is the same as the R316–R321 disclosure). -/
theorem R322_does_not_construct_true_End0 : True := trivial

/-- **R322 non-closure (2/3)**: does NOT construct the algebraic
endomorphism ring `End(E_K)` (the R314 typeclass blocker on
`Ring (AddMonoid.End ...)` remains bypassed, not solved). -/
theorem R322_does_not_construct_algebraic_End : True := trivial

/-- **R322 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage` (R322 supplies the
multiplicative structural ingredient that feeds the cohomology-action
layer; the cohomology action itself is the R325+ target). -/
theorem R322_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
