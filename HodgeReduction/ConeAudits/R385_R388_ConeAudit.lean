import HodgeReduction.HCGapL4.InternalToyFullCodimHC
import HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor_AxiomFree
import HodgeReduction.HCGapL4.HCFrontierAfterAxiomFreeHeadline
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.InternalToyFullCodimHC
open HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
open HodgeReduction

-- R385 trivial-carrier full-codim VarietyHC (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms InternalToy_VarietyHC

-- R386 identity MT package + CM-abelian toy SPV + full ∃-witness
#print axioms MTCorrespondencePackageAt_identity_E7ShimuraToy
#print axioms internalCMAbelianVariety_toy
#print axioms isCMAbelianVariety_internalCMAbelianVariety_toy
#print axioms parametricFullCodimMTPackage_witness_internalToy
#print axioms internalFullCodimMTPackageWitness

-- R387 axiom-free parametric tor instance + kernel-pure headline
#print axioms ParametricCanonicalE7ShimuraTor_axiomFree
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms VarietyHCAt_canonical_codim1_kernelPure

-- R388 integrated frontier + re-exported kernel-pure headline
#print axioms HCFrontierAfterAxiomFreeHeadline_current
#print axioms hodgeConjectureReal_canonical_kernelPure_R388

-- R388 status markers (must NOT depend on any axioms)
#print axioms R388_AuthorizedRefactor_Chain_Closed
#print axioms R388_KernelPureHeadline_Landed
#print axioms R388_KernelPureHeadline_OnToyCarrierOnly
#print axioms R388_HonestPosition_AxiomFreeChain_Complete_ToyRealBridgeLeft

-- Headline guard (must remain unchanged; cone still includes canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
