import HodgeReduction.HCGapL4.DeligneSchmidLowDegreeRankFragment
import HodgeReduction.HCGapL4.E7ConnectednessPaperPath
import HodgeReduction.HCGapL4.HCFrontierAfterSecondRankPopulation
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.DeligneSchmidLowDegreeRankFragment
open HodgeReduction.HCGapL4.E7ConnectednessPaperPath
open HodgeReduction

-- R426 SUBSTANTIVE H¹/H² LinearEquiv theorems (KEY: must be kernel-pure)
#print axioms DegreewiseRank_H1_profile_identification
#print axioms DegreewiseRank_H2_profile_identification

-- R426 spec + current instance (no axioms)
#print axioms E7LowDegreeRank012Spec_current
#print axioms Target_DeligneSchmid_E7_rank1
#print axioms Target_DeligneSchmid_E7_rank2
#print axioms Target_BorelWallach_E7_lowDegreeBetti
#print axioms Target_Pink_E7_rationalCohomology_lowDegree

-- R426 disclosure markers (no axioms)
#print axioms R426_ProfileSide_H1H2_Closed
#print axioms R426_RealE7_Rank1Rank2_StillPaperTarget
#print axioms R426_NoRealE7RankClaim

-- R427 specialised target instances (no axioms)
#print axioms ConnectedProjectiveComplexH0RankOneTheorem_current
#print axioms E7ConnectednessH0PaperPath_current
#print axioms Target_E7Connectedness_closes_R421_geometryTarget
#print axioms Target_E7H0RankOne_closes_R417_rank0PaperTarget

-- R427 markers (no axioms)
#print axioms R427_BailyBorelConnectedness_Target
#print axioms R427_H0RankOne_FromConnectedSmoothProjective_Target
#print axioms R427_StillNoRealE7GeometryConstruction

-- R428 package + frontier (no axioms — pure Prop assignments)
#print axioms E7SecondRankPopulationPackage_current
#print axioms HCFrontierAfterSecondRankPopulation_current

-- R428 markers (no axioms)
#print axioms R428_HC_FinalGoal_KernelOnly
#print axioms R428_SecondRankPopulation_Integrated
#print axioms R428_Rank1Rank2StillPaperTargets
#print axioms R428_NextTarget_AbstractConnectedH0RankOne

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
