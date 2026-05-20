/-
# HC Gap L4 — Invertibility of nonzero GaussianInt actions on PointEndHomQ (R329).

R327 proved `z * star z = (Nm(z) : GaussianInt)` and
`Nm(z) ≠ 0 in ℚ` for `z ≠ 0`. R328 lifted the identity to the
action level:
  `action(z) * action(star z) = (Nm(z) : ℚ) • pointEnd_id_Q`
in `PointEndHomQ`.

R329 uses these to construct the explicit inverse action for any
nonzero z:
  `inverseAction(z) := (1/Nm(z)) ⊗ formula(star z)`
(as a simple tensor, avoiding ℤ-vs-ℚ linearity mismatch).

What R329 does NOT do:
* Does NOT yet construct the full `FractionRing GaussianInt → PointEndHomQ`
  map (R330 target).
* Does NOT construct true algebraic `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

Strategic anchor: R329 is the algebraic unlock step. Once nonzero
GaussianInt elements act invertibly, the GaussianInt action extends
(via `IsLocalization.lift` or similar) to `ℚ(i) = FractionRing GaussianInt`,
which is the source-side `End⁰(E)`-action that
`canonicalE7ShimuraTor.mtCorrespondencePackage` consumes.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianIntActionNormConjugate

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
open scoped TensorProduct

/-! ## Section 1: candidate inverse action (as simple tensor) -/

/-- **R329** the candidate inverse action of a nonzero `z : GaussianInt`
on `PointEndHomQ`. Defined for ALL z (for total function), but
mathematically meaningful only for `z ≠ 0`. Form: `(1/Nm(z)) ⊗ formula(star z)`. -/
noncomputable def gaussianInt_inverseAction (z : GaussianInt) :
    PointEndHomQ :=
  (gaussianIntNormQ z)⁻¹ ⊗ₜ[ℤ]
    (GaussianInt_to_PointEndHom_formula (star z))

/-! ## Section 2: action(z) at the simple-tensor level -/

/-- **R329 helper**: the GaussianInt action as a simple tensor. -/
theorem GaussianInt_to_PointEndHomQ_eq_tmul (z : GaussianInt) :
    GaussianInt_to_PointEndHomQ z
      = (1 : ℚ) ⊗ₜ[ℤ] (GaussianInt_to_PointEndHom_formula z) :=
  rfl

/-! ## Section 3: right-inverse identity -/

/-- **R329** for nonzero `z : GaussianInt`, `action(z) * inverseAction(z)
= pointEnd_id_Q`. -/
theorem gaussianInt_action_mul_inverseAction
    (z : GaussianInt) (hz : z ≠ 0) :
    PointEndHomQ_mul
        (GaussianInt_to_PointEndHomQ z)
        (gaussianInt_inverseAction z)
      = pointEnd_id_Q := by
  -- Unfold both sides to tmul form.
  rw [GaussianInt_to_PointEndHomQ_eq_tmul]
  unfold gaussianInt_inverseAction
  -- Goal: (1 ⊗ formula z) * ((1/Nm(z)) ⊗ formula(star z)) = pointEnd_id_Q
  rw [PointEndHomQ_mul_tmul_tmul]
  -- Goal: (1 * (1/Nm(z))) ⊗ pointEnd_comp (formula z) (formula(star z)) = pointEnd_id_Q
  rw [one_mul]
  -- pointEnd_comp (formula z) (formula(star z)) = formula(z * star z)
  rw [← GaussianInt_to_PointEndHom_formula_mul]
  -- z * star z = Nm(z) (as GaussianInt)
  rw [gaussianInt_mul_star_eq_norm]
  -- formula(Nm(z) : GaussianInt) = Nm(z) • pointEnd_id
  rw [GaussianInt_to_PointEndHom_formula_intCast]
  -- Goal: (1/Nm(z)) ⊗ (Nm(z) • pointEnd_id) = pointEnd_id_Q
  -- Use ℤ-bilinearity: p ⊗ (n • f) = (n • p) ⊗ f for n : ℤ
  rw [TensorProduct.tmul_smul]
  -- Goal: (Nm(z) • (1/Nm(z))) ⊗ pointEnd_id = pointEnd_id_Q
  -- pointEnd_id_Q = 1 ⊗ pointEnd_id, so need (Nm(z) • (1/Nm(z))) = 1 in ℚ
  show ((gaussianIntNormInt z : ℤ) • ((gaussianIntNormQ z)⁻¹ : ℚ))
        ⊗ₜ[ℤ] pointEnd_id = pointEnd_id_Q
  rw [show ((gaussianIntNormInt z : ℤ) • ((gaussianIntNormQ z)⁻¹ : ℚ))
        = (1 : ℚ) from ?_]
  · rfl  -- pointEnd_id_Q = (1 : ℚ) ⊗ pointEnd_id by R322 definition
  · -- (Nm(z) : ℤ) • (Nm(z) : ℚ)⁻¹ = Nm(z) * (Nm(z))⁻¹ = 1
    unfold gaussianIntNormQ
    rw [zsmul_eq_mul]
    have hne : (gaussianIntNormInt z : ℚ) ≠ 0 :=
      gaussianIntNormQ_ne_zero_of_ne_zero z hz
    field_simp

/-! ## Section 4: left-inverse identity -/

/-- **R329 helper**: norm is invariant under star. -/
theorem gaussianIntNormInt_star (z : GaussianInt) :
    gaussianIntNormInt (star z) = gaussianIntNormInt z := by
  unfold gaussianIntNormInt
  have hre : (star z).re = z.re := rfl
  have him : (star z).im = -z.im := rfl
  rw [hre, him]
  ring

/-- **R329 helper**: ℚ-norm is invariant under star. -/
theorem gaussianIntNormQ_star (z : GaussianInt) :
    gaussianIntNormQ (star z) = gaussianIntNormQ z := by
  unfold gaussianIntNormQ
  rw [gaussianIntNormInt_star]

/-- **R329** for nonzero `z : GaussianInt`, `inverseAction(z) * action(z)
= pointEnd_id_Q`. -/
theorem gaussianInt_inverseAction_mul_action
    (z : GaussianInt) (hz : z ≠ 0) :
    PointEndHomQ_mul
        (gaussianInt_inverseAction z)
        (GaussianInt_to_PointEndHomQ z)
      = pointEnd_id_Q := by
  -- Use star_star: z = star (star z), so action(z) = action(star (star z))
  -- = ((1/Nm(z)) ⊗ formula(star z)) * (1 ⊗ formula z)
  rw [GaussianInt_to_PointEndHomQ_eq_tmul]
  unfold gaussianInt_inverseAction
  rw [PointEndHomQ_mul_tmul_tmul]
  -- Goal: ((1/Nm(z)) * 1) ⊗ (formula(star z) ∘ formula z) = pointEnd_id_Q
  rw [mul_one]
  -- formula(star z) ∘ formula z = formula(star z * z)
  rw [← GaussianInt_to_PointEndHom_formula_mul]
  -- star z * z = z * star z (commutative ring) = Nm(z)
  rw [show star z * z = z * star z from mul_comm _ _]
  rw [gaussianInt_mul_star_eq_norm]
  rw [GaussianInt_to_PointEndHom_formula_intCast]
  rw [TensorProduct.tmul_smul]
  show ((gaussianIntNormInt z : ℤ) • ((gaussianIntNormQ z)⁻¹ : ℚ))
        ⊗ₜ[ℤ] pointEnd_id = pointEnd_id_Q
  rw [show ((gaussianIntNormInt z : ℤ) • ((gaussianIntNormQ z)⁻¹ : ℚ))
        = (1 : ℚ) from ?_]
  · rfl
  · unfold gaussianIntNormQ
    rw [zsmul_eq_mul]
    have hne : (gaussianIntNormInt z : ℚ) ≠ 0 :=
      gaussianIntNormQ_ne_zero_of_ne_zero z hz
    field_simp

/-! ## Section 5: invertibility status -/

/-- **R329 status**: nonzero GaussianInt actions are invertible on
`PointEndHomQ` — closed via the explicit inverse `(1/Nm(z)) ⊗ formula(star z)`. -/
def R329_Status_Invertibility_Of_Nonzero_Closed : Prop := True

/-- **R329 status**: explicit inverse action defined. -/
def R329_Status_Inverse_Action_Defined : Prop := True

/-- **R329 status**: right-inverse identity closed. -/
def R329_Status_Right_Inverse_Closed : Prop := True

/-- **R329 status**: left-inverse identity closed. -/
def R329_Status_Left_Inverse_Closed : Prop := True

/-! ## Section 6: disclosure markers -/

/-- **L4-G** bridge to FractionRing localization (R330). -/
def L4_G_GaussianIntActionInvertibility_To_Localization : Prop := True

/-- **L4-G** bridge to active HC cone field. -/
def L4_G_GaussianIntActionInvertibility_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R329 non-closure (1/4)**: does NOT construct the FractionRing
localization map. -/
theorem R329_does_not_construct_localization : True := trivial

/-- **R329 non-closure (2/4)**: does NOT construct `End⁰(E)`. -/
theorem R329_does_not_construct_End0 : True := trivial

/-- **R329 non-closure (3/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R329_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R329 non-closure (4/4)**: this round is source-side
infrastructure, not the standalone construction. -/
theorem R329_is_source_side_infrastructure : True := trivial

end HCGapL4
end HodgeReduction
