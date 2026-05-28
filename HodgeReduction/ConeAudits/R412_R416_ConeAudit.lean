import HodgeReduction.HCGapL4.DegreewiseRankE7CohomologyProfile
import HodgeReduction.HCGapL4.DegreewiseRankE7HodgeStructure
import HodgeReduction.HCGapL4.DegreewiseRankE7VCDACD
import HodgeReduction.HCGapL4.DegreewiseRankParametricHC
import HodgeReduction.HCGapL4.HCFrontierAfterDegreewiseRankProfile
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.DegreewiseRankE7
open HodgeReduction

-- R412 carrier + profile + instances (KEY: all kernel-pure, no canonicalE7ShimuraTor)
#print axioms DegreewiseRankE7_H_addCommGroup
#print axioms DegreewiseRankE7_H_module
#print axioms DegreewiseRankE7_H_finite
#print axioms defaultProfile
#print axioms rank1Profile

-- R413 Hodge structure infrastructure (kernel-pure)
#print axioms piece_atIndex_general
#print axioms pureHodgeStructure_atIndex_general
#print axioms pureHodgeStructure_degreewiseRank
#print axioms trivialDecompositionData

-- R414 VCD/ACD/VarietyHC (KEY: kernel-pure)
#print axioms VarietyCohomologyData_degreewiseRankE7
#print axioms hodgeClassesAtDegree_degreewiseRankE7
#print axioms AlgebraicClassesData_degreewiseRankE7_top
#print axioms DegreewiseRankE7_VarietyHC_topAlgClasses

-- R415 parametric tor + kernel-pure HC headline (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms MTCorrespondencePackageAt_identity_degreewiseRankE7
#print axioms degreewiseRank_FullCodimMTPackageWitness
#print axioms ParametricCanonicalE7ShimuraTor_degreewiseRank
#print axioms hodgeConjectureReal_degreewiseRank_kernelPure
#print axioms VarietyHCAt_degreewiseRank_codim1_kernelPure
#print axioms hodgeConjectureReal_degreewiseRank_rank1_kernelPure

-- R416 frontier + re-exports (no axioms / kernel-pure)
#print axioms HCFrontierAfterDegreewiseRankProfile_current
#print axioms hodgeConjectureReal_canonical_kernelPure_R416_toy
#print axioms hodgeConjectureReal_canonical_kernelPure_R416_realCompatible
#print axioms hodgeConjectureReal_canonical_kernelPure_R416_degreewiseRank

-- R416 markers (no axioms)
#print axioms R416_HC_FinalGoal_KernelOnly
#print axioms R416_ThreeKernelPureHeadlines_OnThreeProfiles
#print axioms R416_OriginalHeadline_NotYetReplaced
#print axioms R416_NextTarget_R417_R411_OptionA_SmallPaperTheorem

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
