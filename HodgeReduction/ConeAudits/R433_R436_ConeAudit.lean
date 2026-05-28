import HodgeReduction.HCGapL4.ConnectednessToH0ConstantsAbstract
import HodgeReduction.HCGapL4.BailyBorelConnectednessTargetDecomposition
import HodgeReduction.HCGapL4.Deligne1971H0TargetDecomposition
import HodgeReduction.HCGapL4.HCFrontierAfterConnectednessH0Decomposition
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.ConnectednessToH0ConstantsAbstract
open HodgeReduction.HCGapL4.BailyBorelConnectednessTargetDecomposition
open HodgeReduction.HCGapL4.Deligne1971H0TargetDecomposition
open HodgeReduction

-- R433 SUBSTANTIVE defs (KEY: kernel-pure, NO canonicalE7ShimuraTor)
#print axioms AbstractConnectedConstantFunctionSource_H0_equiv
#print axioms AbstractConnectedConstantFunctionSource_to_AbstractConnectedRationalH0Source
#print axioms AbstractConnectedConstantFunctionSource_to_Deligne1971H0RealizationInterface

-- R433 markers (no axioms)
#print axioms R433_ConnectednessToH0Constants_AbstractClosed
#print axioms R433_DoesNotProve_BailyBorel
#print axioms R433_DoesNotProve_Deligne1971

-- R434 decomposition structures + instances (no axioms — pure Prop)
#print axioms BailyBorelConnectednessTarget_current
#print axioms BailyBorelFeedsE7Connectedness_current
#print axioms Target_E7HermitianDomain_Connected
#print axioms Target_E7ShimuraConnectedness

-- R434 markers (no axioms)
#print axioms R434_BailyBorel_TargetDecomposed
#print axioms R434_NoBailyBorelTheoremProved
#print axioms R434_NextSmallLemma_ConnectedQuotient

-- R435 decomposition structures + instances (no axioms — pure Prop)
#print axioms Deligne1971H0TargetDecomposition_current
#print axioms DeligneH0FeedsConnectedConstantSource_current
#print axioms LocallyConstantFunctionsOnConnectedSpaceRankOne_current

-- R435 markers (no axioms)
#print axioms R435_DeligneH0_TargetDecomposed
#print axioms R435_NoDeligne1971TheoremProved
#print axioms R435_NextSmallLemma_LocallyConstantOnConnected

-- R436 frontier (no axioms)
#print axioms HCFrontierAfterConnectednessH0Decomposition_current

-- R436 markers (no axioms)
#print axioms R436_HC_FinalGoal_KernelOnly
#print axioms R436_ConnectednessToH0Constants_Closed
#print axioms R436_BailyBorel_And_Deligne_Decomposed
#print axioms R436_NextTarget_LocallyConstantOnConnected

-- Existing kernel-pure headlines (unchanged)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
