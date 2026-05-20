import HodgeReduction.HCGapL4.PointEndHomRationalization
import HodgeReduction.HCGapL4.PointEndHomQMultiplication
import HodgeReduction.HCGapL4.GaussianFieldActionOnPointEndQ
import HodgeReduction.HCGapL4.MTCorrespondenceSourceSideBridge
import HodgeReduction.HCGapL4.PointEndActionToCohomologyTarget
import HodgeReduction.HCGapL4.HCFrontierAfterEnd0PointAction
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R321: tensor carrier
#print axioms PointEndHomQ
#print axioms PointEndHomQ_has_AddCommGroup
#print axioms PointEndHomQ_has_QModule
#print axioms pointEndHom_to_PointEndHomQ_linear
#print axioms pointEndHom_to_PointEndHomQ
#print axioms gaussianCM_phi_Q

-- R322: multiplication + φ²=-1
#print axioms PointEndHomQ_mul
#print axioms PointEndHomQ_mul_tmul_tmul
#print axioms pointEnd_id_Q
#print axioms gaussianCM_phi_Q_sq_eq_neg_one
#print axioms PointEndHomQAlgebraSkeleton_current
#print axioms pointEnd_comp_add_left
#print axioms pointEnd_comp_add_right
#print axioms pointEnd_comp_zsmul_left
#print axioms pointEnd_comp_zsmul_right

-- R323: GaussianField action target
#print axioms GaussianInt_to_PointEndHomQ
#print axioms GaussianInt_to_PointEndHomQ_eq_inclusion_of_formula

-- R324: source-side bridge
#print axioms MTCorrespondenceSourceSideBridgeSkeleton_current
#print axioms VarietyHCAt_E7ShimuraToy_codim1_via_MTCorrespondenceSourceSideBridge

-- R325: cohomology action target
#print axioms PointEndActionToCohomologyTargetSkeleton_E7ShimuraToy

-- R326: frontier integration
#print axioms HCFrontierAfterEnd0PointActionSkeleton_current
#print axioms VarietyHCAt_E7ShimuraToy_codim1_via_HCFrontierAfterEnd0PointAction

-- HC final-goal markers (axiom-free)
#print axioms R326_HC_FinalGoal_KernelOnly
#print axioms R326_CurrentProjectAxiom_canonicalE7ShimuraTor
#print axioms R326_ActiveField_mtCorrespondencePackage_UnderAttack
#print axioms R326_NextTarget_RationalizedEndAction

-- Headline guard (must remain unchanged)
#print axioms hodgeConjectureReal_canonical
