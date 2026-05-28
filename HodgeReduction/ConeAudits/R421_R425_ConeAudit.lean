import HodgeReduction.HCGapL4.ConnectedSmoothProjectiveH0RankOneInterface
import HodgeReduction.HCGapL4.E7H0RankOneSpecializationTarget
import HodgeReduction.HCGapL4.LowDegreeRankSchemaIntegration
import HodgeReduction.HCGapL4.MathlibRealGeometryRevisit_R425_Optional
import HodgeReduction.HCGapL4.HCFrontierAfterH0RankOneInterface
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.ConnectedSmoothProjectiveH0RankOne
open HodgeReduction.HCGapL4.E7H0RankOneSpecializationTarget
open HodgeReduction.HCGapL4.LowDegreeRankSchemaIntegration
open HodgeReduction

-- R421 substantive current bridge instance (KEY: kernel-pure, must NOT include canonicalE7ShimuraTor)
#print axioms H0RankOneFeedsDegreewiseRank_current

-- R421 paper target + markers (no axioms)
#print axioms Target_H0RankOne_closes_Deligne1971_E7_rank0
#print axioms R421_H0RankOne_InterfaceAvailable
#print axioms R421_ProfileSide_H0RankOne_Closed
#print axioms R421_RealGeometry_H0RankOne_StillTarget

-- R422 specialised target + closure path (no axioms)
#print axioms E7ShimuraGeometryH0Target_current
#print axioms E7H0RankOneClosurePath_current
#print axioms R422_E7H0RankOne_TargetSpecialized
#print axioms R422_H0RankOneFeeds_R417_Target

-- R423 substantive integration (kernel-pure)
#print axioms H0RankOneTheoremInterface_trivialQ
#print axioms E7LowDegreeRankDataPackage_current
#print axioms LowDegreeDataFeedsFullRankSchema_current

-- R425 skip-gate decision (no axioms)
#print axioms MathlibRevisitR425Decision_current
#print axioms R425_FullAudit_Skipped
#print axioms R425_NextFullAudit_StillScheduledForR500

-- R424 frontier (no axioms)
#print axioms HCFrontierAfterH0RankOneInterface_current

-- R424 markers (no axioms)
#print axioms R424_HC_FinalGoal_KernelOnly
#print axioms R424_H0RankOneInterface_Available
#print axioms R424_OriginalHeadline_NotReplaceable
#print axioms R424_NextTarget_Rank1Rank2_Or_GeometryConnectedness

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
