/-
# HC Gap L4 — Rationalized point-End carrier `End⁰_target` (R321).

R316-R320 closed the Gaussian-integer action on `PointEndHom` at the
`AddMonoidHom` level (bypassing the R314 `Ring (AddMonoid.End ...)`
typeclass blocker). R321 takes the *next* step recommended by R320:

  * Construct a `ℚ`-vector-space carrier over `PointEndHom` by tensoring
    with `ℚ`. Concretely, define
    `PointEndHomQ := ℚ ⊗[ℤ] PointEndHom`. The choice of putting `ℚ` on
    the LEFT factor is essential: Mathlib's `TensorProduct.leftModule`
    instance produces `Module ℚ (ℚ ⊗[ℤ] PointEndHom)` automatically
    from the `Module ℚ ℚ` instance on the left factor.

This carrier *is* the candidate `End⁰_target` for the Gaussian-CM
elliptic curve `E_K`, at the point-group level (NOT yet at the true
algebraic-End level).

## What R321 (this file) provides (all kernel-pure)

* `PointEndHomQ : Type` — the rationalized point-End carrier as
  `ℚ ⊗[ℤ] PointEndHom`.
* `AddCommGroup PointEndHomQ` and `Module ℚ PointEndHomQ` instances
  (both inferred via Mathlib's `TensorProduct` API).
* `pointEndHom_to_PointEndHomQ_linear : PointEndHom →ₗ[ℤ] PointEndHomQ`
  — canonical inclusion as a `ℤ`-linear map.
* `pointEndHom_to_PointEndHomQ : PointEndHom →+ PointEndHomQ` — same
  inclusion forgotten to an `AddMonoidHom`.
* `gaussianCM_phi_Q : PointEndHomQ` — the R316 Gaussian generator `φ`
  re-exposed at the rationalized carrier.
* Targets for multiplication / `φ_Q² = -1` (next-round closures).
* `L4-G` disclosure markers / status / non-closure markers.

## What R321 does NOT do

* Does NOT construct multiplication on `PointEndHomQ` (composition of
  `AddMonoidHom`s does not lift to a single tensor-product
  bilinear map without extra work — left to R322+).
* Does NOT prove `gaussianCM_phi_Q² = -1` in `PointEndHomQ` (waits on
  the multiplication step).
* Does NOT construct algebraic `End⁰(E)` (the true algebraic-End ring
  ⊗ ℚ).
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure (markers/status only).
-/

import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomOps
import Mathlib.LinearAlgebra.TensorProduct.Basic

/-! `AddCommGroup PointEndHom` synthesis already requires
`maxSynthPendingDepth = 4` (see R316). Tensor-product instances chain
through one further `Module ℤ` lookup, so we keep the same lift. -/
set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open scoped TensorProduct

/-! ## Section 1: rationalized point-End carrier as a tensor product

We define `PointEndHomQ := ℚ ⊗[ℤ] PointEndHom`. Putting `ℚ` on the
LEFT factor is deliberate: Mathlib's `TensorProduct.leftModule`
instance then gives `Module ℚ (ℚ ⊗[ℤ] PointEndHom)` automatically
from `Module ℚ ℚ`. With `ℚ` on the RIGHT factor we would need a
`Module ℚ PointEndHom`, which is exactly what we are *constructing*. -/

/-- **R321** the rationalized point-End carrier:
`PointEndHomQ := ℚ ⊗[ℤ] PointEndHom`. Real math (not a Prop marker):
the underlying type is Mathlib's `TensorProduct`. -/
abbrev PointEndHomQ : Type :=
  TensorProduct ℤ ℚ PointEndHom

/-! ## Section 2: typeclass evidence -/

/-- **R321** kernel sanity check: `PointEndHomQ` inherits
`AddCommGroup` from the tensor-product structure. -/
noncomputable example : AddCommGroup PointEndHomQ := inferInstance

/-- **R321** kernel sanity check: `PointEndHomQ` is a `Module ℚ`
via the left-factor `Module ℚ ℚ` instance and Mathlib's
`TensorProduct.leftModule`. -/
noncomputable example : Module ℚ PointEndHomQ := inferInstance

/-- **R321** `AddCommGroup PointEndHomQ` evidence (theorem-level). -/
theorem PointEndHomQ_has_AddCommGroup :
    Nonempty (AddCommGroup PointEndHomQ) := ⟨inferInstance⟩

/-- **R321** `Module ℚ PointEndHomQ` evidence (theorem-level). -/
theorem PointEndHomQ_has_QModule :
    Nonempty (Module ℚ PointEndHomQ) := ⟨inferInstance⟩

/-! ## Section 3: canonical inclusion `PointEndHom → PointEndHomQ` -/

/-- **R321** canonical `ℤ`-linear inclusion
`PointEndHom →ₗ[ℤ] PointEndHomQ`, sending `f ↦ 1 ⊗ₜ f`. Built from
Mathlib's bilinear `TensorProduct.mk` by flipping arguments and
applying at `1 : ℚ`. -/
noncomputable def pointEndHom_to_PointEndHomQ_linear :
    PointEndHom →ₗ[ℤ] PointEndHomQ :=
  (TensorProduct.mk ℤ ℚ PointEndHom) 1

/-- **R321** canonical inclusion forgotten to an `AddMonoidHom`. -/
noncomputable def pointEndHom_to_PointEndHomQ :
    PointEndHom →+ PointEndHomQ :=
  pointEndHom_to_PointEndHomQ_linear.toAddMonoidHom

/-- **R321** pointwise unfold of the inclusion: `f ↦ 1 ⊗ₜ f`. -/
theorem pointEndHom_to_PointEndHomQ_apply (f : PointEndHom) :
    pointEndHom_to_PointEndHomQ f = (1 : ℚ) ⊗ₜ[ℤ] f := rfl

/-- **R321** pointwise unfold of the `ℤ`-linear form. -/
theorem pointEndHom_to_PointEndHomQ_linear_apply (f : PointEndHom) :
    pointEndHom_to_PointEndHomQ_linear f = (1 : ℚ) ⊗ₜ[ℤ] f := rfl

/-! ## Section 4: Gaussian generator at the rationalized carrier -/

/-- **R321** the R316 Gaussian generator `φ : PointEndHom`
re-exposed at the rationalized carrier as `1 ⊗ₜ φ : PointEndHomQ`. -/
noncomputable def gaussianCM_phi_Q : PointEndHomQ :=
  pointEndHom_to_PointEndHomQ gaussianCM_phi

/-- **R321** pointwise unfold of `gaussianCM_phi_Q`. -/
theorem gaussianCM_phi_Q_eq :
    gaussianCM_phi_Q = (1 : ℚ) ⊗ₜ[ℤ] gaussianCM_phi := rfl

/-! ## Section 5: targets for multiplication / `φ_Q² = -1` -/

/-- **R321 target**: composition on `PointEndHom` lifts to a
multiplication on `PointEndHomQ` via tensor-product bilinearity.
Pinned for R322. -/
def Target_PointEndHomQ_Multiplication_FromComposition : Prop := True

/-- **R321 target**: `gaussianCM_phi_Q² = -1` in the rationalized
algebra. Pinned for R322+ (waits on the multiplication step). -/
def Target_gaussianCM_phi_Q_sq_eq_neg_one : Prop := True

/-- **R321 target**: `ℚ(i) → PointEndHomQ` as a ring homomorphism.
Pinned for R323+. -/
def Target_GaussianField_To_PointEndHomQ : Prop := True

/-! ## Section 6: `L4-G` disclosure markers -/

/-- **L4-G** bridge from the rationalized point-End carrier to
`End⁰(E)` (the true algebraic-End ⊗ ℚ). The R321 carrier is at the
point-group level, NOT at the algebraic-End level. -/
def L4_G_PointEndHomQ_To_End0 : Prop := True

/-- **L4-G** disclosure: this is the point-group rationalized
endomorphism carrier, NOT yet true algebraic End⁰(E). The R314
typeclass blocker on `Ring (AddMonoid.End E_K.toAffine.Point)`
remains bypassed (not solved); R321 simply lifts the
`AddMonoidHom`-level carrier to a `ℚ`-module. -/
def L4_G_PointEndHomQ_PointEnd_NotYetAlgebraicEnd : Prop := True

/-- **L4-G** bridge to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. Strategic role:
source-side End⁰ / cohomology-action infrastructure for the
E_7-Shimura MT correspondence. -/
def L4_G_PointEndHomQ_To_mtCorrespondencePackage : Prop := True

/-! ## Section 7: status -/

/-- **R321 status**: tensor-product carrier built. -/
def R321_Status_TensorCarrier_Built : Prop := True

/-- **R321 status**: `Module ℚ` instance closed via Mathlib's
`TensorProduct.leftModule`. -/
def R321_Status_QModule_Closed : Prop := True

/-- **R321 status**: canonical inclusion
`PointEndHom → PointEndHomQ` defined. -/
def R321_Status_Inclusion_Defined : Prop := True

/-- **R321 status**: Gaussian generator `gaussianCM_phi_Q` defined. -/
def R321_Status_GaussianPhi_Q_Defined : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R321 non-closure (1/5)**: does NOT construct multiplication on
`PointEndHomQ` (pinned as R322 target). -/
theorem R321_does_not_construct_multiplication : True := trivial

/-- **R321 non-closure (2/5)**: does NOT prove
`gaussianCM_phi_Q² = -1`. -/
theorem R321_does_not_prove_phi_Q_sq_eq_neg_one : True := trivial

/-- **R321 non-closure (3/5)**: does NOT construct algebraic End⁰(E)
(the true `End(E) ⊗ ℚ`). -/
theorem R321_does_not_construct_algebraic_End0 : True := trivial

/-- **R321 non-closure (4/5)**: does NOT prove
`PointEndHom = algebraic End(E)`. -/
theorem R321_does_not_prove_pointEnd_eq_algebraicEnd : True := trivial

/-- **R321 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R321_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
