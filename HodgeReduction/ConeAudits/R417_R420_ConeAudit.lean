import HodgeReduction.HCGapL4.Deligne1971LowDegreeFragment
import HodgeReduction.HCGapL4.E7LowDegreeRankPopulation
import HodgeReduction.HCGapL4.E7HighDegreeRankTargetSchema
import HodgeReduction.HCGapL4.HCFrontierAfterFirstRankPopulation
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.Deligne1971LowDegree
open HodgeReduction.HCGapL4.DegreewiseRankE7
open HodgeReduction.HCGapL4.E7HighDegreeRankTargetSchema
open HodgeReduction

-- R417 SUBSTANTIVE LinearEquiv theorem (KEY: must be kernel-pure, NO canonicalE7ShimuraTor)
#print axioms DegreewiseRank_rank0_one_profile_closes
#print axioms DegreewiseRank_rank0_one_profile_closes_current

-- R417 spec + current instance (no axioms)
#print axioms E7RankLowDegreeSpec_current
#print axioms Target_Deligne1971_E7_rank0_eq_one
#print axioms Target_Deligne1971_E7_rational_H0_identification

-- R417 markers (no axioms)
#print axioms R417_DeligneFragment_InterfaceOnly
#print axioms R417_Rank0_ProfileLinearAlgebra_Closed
#print axioms R417_RealE7Rank0_PaperTarget_Open

-- R418 concrete rank function + rank0 fact + kernel-pure HC headline
#print axioms E7Rank_lowDegree_current
#print axioms E7Rank_lowDegree_current_zero
#print axioms hodgeConjectureReal_lowDegreeRankProfile_kernelPure
#print axioms VarietyHCAt_lowDegreeRankProfile_codim1_kernelPure

-- R418 disclosure markers (no axioms)
#print axioms R418_LowDegreeRankProfile_UsesPlaceholderBeyondZero
#print axioms R418_Rank0OnlyPaperTargeted

-- R419 schema instances (no axioms — pure Prop assignment)
#print axioms E7FullRankTheoremInterface_current
#print axioms E7HodgeNumberTheoremInterface_current
#print axioms E7RankHodgeDataFeedsProfileAdapter_current

-- R419 markers (no axioms)
#print axioms R419_FullRankData_TargetSchema_Available
#print axioms R419_HodgeNumberData_TargetSchema_Available
#print axioms R419_PaperBackedRankStillOpen

-- R420 frontier instance + re-export
#print axioms HCFrontierAfterFirstRankPopulation_current
#print axioms hodgeConjectureReal_canonical_kernelPure_R420_lowDegree

-- R420 markers (no axioms)
#print axioms R420_HC_FinalGoal_KernelOnly
#print axioms R420_FirstRankPopulation_Done
#print axioms R420_OriginalHeadline_NotYetReplaceable
#print axioms R420_NextTarget_H0RankOneTheoremInterface

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
