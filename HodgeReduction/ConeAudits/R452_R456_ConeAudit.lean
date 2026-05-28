import HodgeReduction.HCGapL4.FrontC2_LowDegreeHodgeRankAlgebra
import HodgeReduction.HCGapL4.FrontB2_ConnectednessNstepPipeline
import HodgeReduction.HCGapL4.FrontE2_ProfileMatchingObligationSplit
import HodgeReduction.HCGapL4.FrontA_PauseUntilR500
import HodgeReduction.HCGapL4.R456_MultiFrontWave2Audit
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.FrontC2_LowDegreeHodgeRankAlgebra
open HodgeReduction.HCGapL4.FrontB2_ConnectednessNstepPipeline
open HodgeReduction.HCGapL4.FrontE2_ProfileMatchingObligationSplit
open HodgeReduction

-- R452 SUBSTANTIVE 4 algebraic theorems (KEY: kernel-pure)
#print axioms rank1_eq_two_mul_h10_of_symmetry
#print axioms rank2_eq_two_mul_h20_add_h11_of_symmetry
#print axioms rank1_even_of_hodgeSymmetry1
#print axioms rank2_sub_h11_even_of_hodgeSymmetry2

-- R453 SUBSTANTIVE 2 main + 2 alt composition theorems (KEY: kernel-pure)
#print axioms preconnectedSpace_chain_of_two_surjective_continuous
#print axioms isPreconnected_univ_chain_of_two_surjective_continuous
#print axioms preconnectedSpace_chain_of_three_surjective_continuous_clean
#print axioms isPreconnected_univ_chain_of_three_surjective_continuous_clean

-- R454 split + feed (kernel-pure)
#print axioms obligations_feed_trivialUnit
#print axioms LowDegreeProfileRealCarrierObligations_trivialUnit
#print axioms LowDegreeProfileRealCarrierObligations_trivialUnit_all_True

-- R455 pause gate instance + markers (no axioms — pure orchestration)
#print axioms FrontAPauseUntilR500_current
#print axioms R455_FrontA_PausedUntilR500
#print axioms R455_NoRepeatedSheafAudit

-- R456 Wave 2 audit (no axioms)
#print axioms MultiFrontWave2Audit_current
#print axioms R456_Aggregate_SixSubstantive_TwoAltForms
#print axioms R456_AggregateAcrossWaves_TwelveSubstantive

-- R456 Wave 3 priority markers (no axioms)
#print axioms R457_Priority1_FrontC3_AdditionalHodgeSymmetry
#print axioms R458_Priority2_FrontB3_ArithmeticQuotientRefine
#print axioms R459_Priority3_FrontE3_R452_To_R454_Feed

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
