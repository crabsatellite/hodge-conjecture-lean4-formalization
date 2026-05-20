import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomOps
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomFormula
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomMultiplicative
import HodgeReduction.HCGapL4.GaussianIntActionRingHomLike
import HodgeReduction.HCGapL4.GaussianIntActionToGaussianFieldTarget
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R316: AddMonoidHom ops
#print axioms pointEnd_id
#print axioms pointEnd_zero
#print axioms pointEnd_add
#print axioms pointEnd_neg
#print axioms pointEnd_comp
#print axioms pointEnd_zsmul
#print axioms gaussianCM_phi
#print axioms pointEnd_id_apply
#print axioms pointEnd_comp_apply
#print axioms pointEnd_zsmul_apply
#print axioms gaussianCM_phi_apply
#print axioms gaussianCM_phi_comp_phi_apply
#print axioms gaussianCM_phi_comp_phi_eq_neg_id

-- R317: GaussianInt formula
#print axioms GaussianInt_to_PointEndHom_formula
#print axioms GaussianInt_to_PointEndHom_formula_one
#print axioms GaussianInt_to_PointEndHom_formula_i
#print axioms GaussianInt_to_PointEndHom_formula_add
#print axioms GaussianInt_to_PointEndHom_formula_neg
#print axioms GaussianInt_to_PointEndHom_formula_zero

-- R318: multiplicativity
#print axioms GaussianInt_to_PointEndHom_formula_mul

-- R319: ring-hom-like packaging
#print axioms GaussianIntActionOnPointEndHomSkeleton_current

-- R320: chain integration
#print axioms GaussianIntToGaussianFieldActionChainSkeleton_current
#print axioms VarietyHCAt_E7ShimuraToy_codim1_via_GaussianIntToGaussianFieldActionChain

-- Next-target markers (axiom-free)
#print axioms R320_NextTarget_Rationalize_GaussianIntAction
#print axioms R320_NextTarget_Construct_End0_QAlgebra
#print axioms R320_NextTarget_GaussianField_To_End0
#print axioms R320_Recommendation_End0_Target_Via_Localization

-- Non-closure (axiom-free)
#print axioms R316_does_not_construct_RingEnd
#print axioms R317_does_not_prove_mul
#print axioms R318_does_not_construct_ringHom
#print axioms R319_does_not_construct_RingEnd
#print axioms R320_does_not_construct_End0
#print axioms R320_does_not_close_canonicalE7ShimuraTor

-- Headline guard
#print axioms hodgeConjectureReal_canonical
