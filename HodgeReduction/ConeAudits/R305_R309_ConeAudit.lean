import HodgeReduction.HCGapL4.GaussianCMActionNegYCompat
import HodgeReduction.HCGapL4.GaussianCMActionSlopeCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddXCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddYCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddCasesBasic
import HodgeReduction.HCGapL4.GaussianCMActionAddCasesGeneric
import HodgeReduction.HCGapL4.GaussianCMActionAddMonoidHom
import HodgeReduction.HCGapL4.GaussianCMActionEndChainIntegration
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R305 (formula compatibility lemmas)
#print axioms gaussianCMAction_negY_compat
#print axioms gaussianCMAction_slope_compat
#print axioms gaussianCMAction_addX_compat
#print axioms gaussianCMAction_addX_compat_at_slope
#print axioms gaussianCMAction_addY_compat
#print axioms gaussianCMAction_addY_compat_at_slope
#print axioms gaussianCMAction_negAddY_compat

-- R306 (zero / inverse branches)
#print axioms gaussianCMAction_affinePoint_zero_add
#print axioms gaussianCMAction_affinePoint_add_zero
#print axioms gaussianCMAction_inverse_branch_condition_preserved
#print axioms gaussianCMAction_add_inverse_branch

-- R307 (generic branches)
#print axioms gaussianCMAction_add_X_ne_branch
#print axioms gaussianCMAction_add_Y_ne_branch

-- R308 (full additivity + AddMonoidHom + AddMonoid.End + square)
#print axioms gaussianCMAction_affinePoint_map_add
#print axioms gaussianCMAction_AddMonoidHom
#print axioms gaussianCMAction_GroupEndCandidate
#print axioms gaussianCMAction_GroupEndCandidate_sq_apply

-- R309 (chain integration)
#print axioms GaussianCMActionGroupEndEvidenceSkeleton_current
#print axioms gaussianCMAction_GroupEnd_square_neg_one_evidence
#print axioms VarietyHCAt_E7ShimuraToy_codim1_via_GaussianCMActionEndChain

-- Status / next-target markers (should be axiom-free)
#print axioms R305_Status_NegY_Compat_Closed
#print axioms R306_Status_Zero_Cases_Closed
#print axioms R306_Status_Inverse_Branch_Closed
#print axioms R308_Status_FullAdditivity_Closed
#print axioms R308_Status_AddMonoidHom_Defined
#print axioms R309_Status_AddMonoidHom_Integrated
#print axioms R309_NextTarget_GroupEnd_IsAlgebraicEnd
#print axioms R309_NextTarget_Construct_AlgebraicEndRing
#print axioms R309_NextTarget_Construct_End0
#print axioms R309_NextTarget_GaussianField_To_End0

-- Non-closure (should be axiom-free)
#print axioms R309_does_not_construct_algebraic_End
#print axioms R309_does_not_construct_End0
#print axioms R309_does_not_close_canonicalE7ShimuraTor

-- Headline guard (must remain unchanged)
#print axioms hodgeConjectureReal_canonical
