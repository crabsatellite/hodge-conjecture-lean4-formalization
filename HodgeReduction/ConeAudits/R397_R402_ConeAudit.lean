import HodgeReduction.HCGapL4.RealCompatibleE7CarrierProfile
import HodgeReduction.HCGapL4.RealCompatibleE7AlgClassesProfile
import HodgeReduction.HCGapL4.RealCompatibleParametricCanonicalTor
import HodgeReduction.HCGapL4.MathlibRealGeometryRevisit_R400
import HodgeReduction.HCGapL4.RealCompatibleVsToyProfileComparison
import HodgeReduction.HCGapL4.HCFrontierAfterRealCompatibleProfile
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.RealCompatibleE7Carrier
open HodgeReduction

-- R397 generic PHS construction (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms pureHodgeStructure_ℚ_atIndex
#print axioms iSupIndep_piece_ℚ_atIndex
#print axioms iSup_piece_ℚ_atIndex_eq_top

-- R397 internal profile + VCD conversion (KEY: kernel-pure)
#print axioms internalProfile
#print axioms VarietyCohomologyData_realCompatibleE7

-- R398 hodgeClasses = ⊤ lemma + ACD + VarietyHC (KEY: kernel-pure)
#print axioms hodgeClassesAtDegree_realCompatibleE7
#print axioms internalAlgProfile
#print axioms AlgebraicClassesData_realCompatibleE7
#print axioms RealCompatibleE7Profile_VarietyHC

-- R399 parametric tor + kernel-pure HC headline (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms MTCorrespondencePackageAt_identity_realCompatibleE7
#print axioms realCompatible_FullCodimMTPackageWitness
#print axioms ParametricCanonicalE7ShimuraTor_realCompatible
#print axioms hodgeConjectureReal_realCompatible_kernelPure
#print axioms VarietyHCAt_realCompatible_codim1_kernelPure

-- R400 Mathlib revisit result + markers (no axioms)
#print axioms MathlibRealGeometryRevisitR400Result_current
#print axioms R400_MathlibRevisit_Executed
#print axioms R400_NextRevisitRecommended_R500

-- R401 toy vs real-compatible comparison (KEY: substantive proofs kernel-pure)
#print axioms toyHighCodim_isPUnit_Subsingleton
#print axioms realCompatibleHighCodim_NotSubsingleton
#print axioms noLinearEquiv_Subsingleton_to_NonSubsingleton
#print axioms noLinearEquiv_toy_to_realCompatible_highCodim
#print axioms RealCompatibleVsToyProfileComparison_current

-- R402 frontier (no axioms — pure Prop assignment)
#print axioms HCFrontierAfterRealCompatibleProfile_current
#print axioms hodgeConjectureReal_canonical_kernelPure_R402_toy
#print axioms hodgeConjectureReal_canonical_kernelPure_R402_realCompatible

-- R402 markers (no axioms)
#print axioms R402_HC_FinalGoal_KernelOnly
#print axioms R402_RealCompatibleProfileRoute_Available
#print axioms R402_OriginalHeadline_NotYetReplaced

-- Toy kernel-pure headline (unchanged from R387)
#print axioms hodgeConjectureReal_canonical_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
