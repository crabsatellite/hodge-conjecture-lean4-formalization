import HodgeReduction.HCGapL4.FrontC4_HodgePolynomialAlgebra
import HodgeReduction.HCGapL4.FrontB4_DiscreteGroupQuotientRefinement
import HodgeReduction.HCGapL4.FrontE4_AllCodimProfileMatchingDispatcher
import HodgeReduction.HCGapL4.R465_MultiFrontWave4Audit
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.FrontC4_HodgePolynomialAlgebra
open HodgeReduction.HCGapL4.FrontB4_DiscreteGroupQuotientRefinement
open HodgeReduction.HCGapL4.FrontE4_AllCodimProfileMatchingDispatcher
open HodgeReduction

-- R462 SUBSTANTIVE 6 Hodge polynomial theorems (KEY: kernel-pure)
#print axioms hodgeSum_degree0
#print axioms hodgeSum_degree1
#print axioms hodgeSum_degree2
#print axioms rank1_from_hodgeSum_degree1
#print axioms rank2_from_hodgeSum_degree2
#print axioms poincareEulerTrunc2_formula

-- R463 SUBSTANTIVE 4 quotient theorems (KEY: kernel-pure)
#print axioms DiscreteGroupQuotientConnectednessTarget.preconnected
#print axioms quotient_connectedness_independent_of_Hausdorff
#print axioms quotient_connectedness_independent_of_discreteness
#print axioms quotient_connectedness_independent_of_properDiscontinuity

-- R464 SUBSTANTIVE 5 dispatcher theorems
#print axioms AllCodimHodgeRankMatchingData.toLowDegree_from_targets
#print axioms AllCodimHodgeRankMatchingData_trivialUnit_toLowDegree

-- R465 Wave 4 audit (no axioms — Prop-only)
#print axioms MultiFrontWave4Audit_current
#print axioms R465_Aggregate_FifteenSubstantive_ThisWave
#print axioms R465_Cumulative_ThirtySixSubstantive_AcrossWaves
#print axioms R465_MethodologyValidation_36Substantive_0Axioms_4Waves

-- R465 Wave 5 priority markers (no axioms)
#print axioms R467_Priority1_FrontC5_PolynomialRankAdapter
#print axioms R468_Priority2_FrontB5_Compactification
#print axioms R469_Priority3_FrontE5_R462_To_R464_Integration

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
