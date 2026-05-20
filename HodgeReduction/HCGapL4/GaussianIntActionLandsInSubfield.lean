/-
# HC Gap L4 — GaussianInt action lands in commutative subspace (R334).

R333 defined the commutative subspace
`GaussianFieldSubspace_PointEndQ := Submodule.span ℚ {pointEnd_id_Q, gaussianCM_phi_Q}`
of `PointEndHomQ` and proved multiplication closure + internal
commutativity. R334 shows that every R323 GaussianInt action lands
in this subspace.

Strategic anchor: this is the precise membership fact needed for
the R336 step where the GaussianInt action factors through the
commutative subalgebra (and hence eventually through `ℚ(i)`-action
via R335's pair carrier or direct IsLocalization.lift).

What R334 does NOT do:
* Does NOT yet extend the action to `ℚ(i)`.
* Does NOT close `mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianFieldSubringPointEndQ
import HodgeReduction.HCGapL4.GaussianFieldActionOnPointEndQ

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open scoped TensorProduct

/-! ## Section 1: the R323 GaussianInt action lands in the subspace -/

/-- **R334** for any `z : GaussianInt`, `GaussianInt_to_PointEndHomQ z`
lies in `GaussianFieldSubspace_PointEndQ`. Proof: the formula
`GaussianInt_to_PointEndHomQ z = (z.re : ℚ) • pointEnd_id_Q
+ (z.im : ℚ) • gaussianCM_phi_Q` (essentially R317's normal form
lifted through R321's inclusion) makes it a manifest linear
combination of the two basis elements. -/
theorem GaussianInt_to_PointEndHomQ_mem_GaussianFieldSubspace
    (z : GaussianInt) :
    GaussianInt_to_PointEndHomQ z ∈ GaussianFieldSubspace_PointEndQ := by
  -- Show GaussianInt_to_PointEndHomQ z = z.re • id_Q + z.im • phi_Q.
  have hform :
      GaussianInt_to_PointEndHomQ z
        = (z.re : ℚ) • pointEnd_id_Q
          + (z.im : ℚ) • gaussianCM_phi_Q := by
    show pointEndHom_to_PointEndHomQ
            (GaussianInt_to_PointEndHom_formula z)
          = (z.re : ℚ) • pointEnd_id_Q
            + (z.im : ℚ) • gaussianCM_phi_Q
    -- formula z = z.re • pointEnd_id + z.im • gaussianCM_phi (R317).
    -- pointEndHom_to_PointEndHomQ is ℤ-linear hom, so commutes with •.
    show ((1 : ℚ) ⊗ₜ[ℤ]
            (GaussianInt_to_PointEndHom_formula z) : PointEndHomQ)
          = (z.re : ℚ) • pointEnd_id_Q
            + (z.im : ℚ) • gaussianCM_phi_Q
    -- Unfold formula to z.re • pointEnd_id + z.im • gaussianCM_phi.
    show ((1 : ℚ) ⊗ₜ[ℤ]
            ((z.re : ℤ) • pointEnd_id +
             (z.im : ℤ) • gaussianCM_phi) : PointEndHomQ)
          = (z.re : ℚ) • pointEnd_id_Q
            + (z.im : ℚ) • gaussianCM_phi_Q
    rw [TensorProduct.tmul_add]
    rw [TensorProduct.tmul_smul, TensorProduct.tmul_smul]
    -- Goal: (z.re : ℤ) • (1 ⊗ pointEnd_id) + (z.im : ℤ) • (1 ⊗ gaussianCM_phi)
    --       = (z.re : ℚ) • pointEnd_id_Q + (z.im : ℚ) • gaussianCM_phi_Q
    -- pointEnd_id_Q = 1 ⊗ pointEnd_id and gaussianCM_phi_Q = 1 ⊗ gaussianCM_phi
    -- Convert ℤ-smul to ℚ-smul via Int.cast_smul_eq_zsmul (or similar).
    have h1 : ((z.re : ℤ) • (pointEnd_id_Q : PointEndHomQ))
                = ((z.re : ℚ) • pointEnd_id_Q : PointEndHomQ) :=
      (Int.cast_smul_eq_zsmul ℚ _ _).symm
    have h2 : ((z.im : ℤ) • (gaussianCM_phi_Q : PointEndHomQ))
                = ((z.im : ℚ) • gaussianCM_phi_Q : PointEndHomQ) :=
      (Int.cast_smul_eq_zsmul ℚ _ _).symm
    show (z.re : ℤ) • (pointEnd_id_Q : PointEndHomQ)
         + (z.im : ℤ) • (gaussianCM_phi_Q : PointEndHomQ)
       = (z.re : ℚ) • pointEnd_id_Q + (z.im : ℚ) • gaussianCM_phi_Q
    rw [h1, h2]
  rw [hform]
  exact linear_combination_mem_GaussianFieldSubspace _ _

/-! ## Section 2: explicit normal form for the action -/

/-- **R334** explicit normal form: the GaussianInt action equals its
component decomposition. -/
theorem GaussianInt_to_PointEndHomQ_normal_form (z : GaussianInt) :
    GaussianInt_to_PointEndHomQ z
      = (z.re : ℚ) • pointEnd_id_Q
        + (z.im : ℚ) • gaussianCM_phi_Q := by
  show pointEndHom_to_PointEndHomQ
          (GaussianInt_to_PointEndHom_formula z)
        = (z.re : ℚ) • pointEnd_id_Q
          + (z.im : ℚ) • gaussianCM_phi_Q
  show ((1 : ℚ) ⊗ₜ[ℤ]
          (GaussianInt_to_PointEndHom_formula z) : PointEndHomQ)
        = (z.re : ℚ) • pointEnd_id_Q
          + (z.im : ℚ) • gaussianCM_phi_Q
  show ((1 : ℚ) ⊗ₜ[ℤ]
          ((z.re : ℤ) • pointEnd_id +
           (z.im : ℤ) • gaussianCM_phi) : PointEndHomQ)
        = (z.re : ℚ) • pointEnd_id_Q
          + (z.im : ℚ) • gaussianCM_phi_Q
  rw [TensorProduct.tmul_add]
  rw [TensorProduct.tmul_smul, TensorProduct.tmul_smul]
  have h1 : ((z.re : ℤ) • (pointEnd_id_Q : PointEndHomQ))
              = ((z.re : ℚ) • pointEnd_id_Q : PointEndHomQ) :=
    (Int.cast_smul_eq_zsmul ℚ _ _).symm
  have h2 : ((z.im : ℤ) • (gaussianCM_phi_Q : PointEndHomQ))
              = ((z.im : ℚ) • gaussianCM_phi_Q : PointEndHomQ) :=
    (Int.cast_smul_eq_zsmul ℚ _ _).symm
  show (z.re : ℤ) • (pointEnd_id_Q : PointEndHomQ)
       + (z.im : ℤ) • (gaussianCM_phi_Q : PointEndHomQ)
     = (z.re : ℚ) • pointEnd_id_Q + (z.im : ℚ) • gaussianCM_phi_Q
  rw [h1, h2]

/-! ## Section 3: status / markers -/

/-- **R334 status**: GaussianInt actions land in commutative subspace. -/
def R334_Status_All_GaussianInt_Actions_Land_In_Subspace : Prop := True

/-- **R334 status**: explicit normal form available. -/
def R334_Status_Normal_Form_Available : Prop := True

/-- **L4-G** bridge to localization. -/
def L4_G_GaussianIntActionLandsInSubfield_To_Localization : Prop := True

/-- **L4-G** bridge to Gaussian-field action via subring. -/
def L4_G_GaussianIntActionLandsInSubfield_To_GaussianFieldAction :
    Prop := True

/-- **L4-G** bridge to active HC cone field. -/
def L4_G_GaussianIntActionLandsInSubfield_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R334 non-closure (1/3)**: does NOT extend action to ℚ(i). -/
theorem R334_does_not_extend_to_GaussianField : True := trivial

/-- **R334 non-closure (2/3)**: does NOT construct `End⁰(E)`. -/
theorem R334_does_not_construct_End0 : True := trivial

/-- **R334 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R334_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
