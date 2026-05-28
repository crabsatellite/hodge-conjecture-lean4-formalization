import HodgeReduction.HCGapL4.CohomologyProfileComparisonSkeleton
import HodgeReduction.HCGapL4.DeligneSchmidCohomologyImportInterface
import HodgeReduction.HCGapL4.E7CohomologyProfileAdapter
import HodgeReduction.HCGapL4.CohomologyProfileComparisonConditional
import HodgeReduction.HCGapL4.HCFrontierAfterCohomologyProfileDecomposition
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.E7CohomologyProfileAdapterNS
open HodgeReduction

-- R407 pin instance (NOTE: cone WILL include canonicalE7ShimuraTor — instance pin)
#print axioms CohomologyProfileComparisonSkeleton_pin

-- R407 sub-targets (no axioms)
#print axioms Target_DegreewiseEquiv
#print axioms Target_BettiNumberComparison
#print axioms Target_HodgeNumberComparison
#print axioms Target_RationalStructureCompat
#print axioms Target_AllDegreeCompatibility

-- R408 paper interface instance (no axioms)
#print axioms DeligneSchmidCohomologyTheoremInterface_current
#print axioms R408_Target_Deligne1971_RationalCohomology_OPEN
#print axioms R408_Target_Schmid1973_HodgeDecomposition_OPEN
#print axioms R408_Target_BorelWallach2000_AutomorphicCohomology_OPEN
#print axioms R408_Target_Pink1990_ShimuraCohomology_OPEN

-- R409 trivial adapter + match (no axioms)
#print axioms trivialAdapter
#print axioms trivialMatch
#print axioms Target_R410_R411_RefinedProfile_Per_Hodge_Number

-- R410 Prop-level conditional marker (no axioms)
#print axioms cohomologyProfileComparison_from_DeligneSchmid_interface

-- R410 substantive conditional (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms cohomologyProfileComparison_targets_from_explicit_hypotheses
#print axioms cohomologyProfileComparison_pin_targets_trivial

-- R410 missing-witness markers (no axioms)
#print axioms MissingWitness_R410_Substantive_DeligneSchmid_Interface
#print axioms MissingWitness_R410_Refined_Profile_Per_HodgeNumber

-- R411 frontier instance (no axioms)
#print axioms HCFrontierAfterCohomologyProfileDecomposition_current

-- R411 next-target option markers (no axioms)
#print axioms R411_NextTargetOption_A_Formalize_Small_DeligneSchmid_Lemma
#print axioms R411_NextTargetOption_B_Refine_E7_Profile_Per_Hodge_Number
#print axioms R411_NextTargetOption_C_Switch_To_Another_R404_Priority
#print axioms R411_Recommendation_Option_B_First_Then_A

-- R411 final-goal + status markers (no axioms)
#print axioms R411_HC_FinalGoal_KernelOnly
#print axioms R411_Priority1_Architecture_Complete
#print axioms R411_Priority1_SubstantiveContent_NotDischarged

-- Toy kernel-pure headline (unchanged from R387)
#print axioms hodgeConjectureReal_canonical_kernelPure

-- Real-compatible kernel-pure headline (unchanged from R399)
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
