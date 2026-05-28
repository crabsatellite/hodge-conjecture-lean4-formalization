import HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor_AxiomFree
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
open HodgeReduction

-- R386 identity MT package per codim (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms MTCorrespondencePackageAt_identity_E7ShimuraToy

-- R386 internal CM-abelian SPV toy + IsCMAbelianVariety witness
#print axioms internalCMAbelianVariety_toy
#print axioms isCMAbelianVariety_internalCMAbelianVariety_toy

-- R386 main ∃-witness bundle (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms parametricFullCodimMTPackage_witness_internalToy
#print axioms internalFullCodimMTPackageWitness

-- R387 axiom-free parametric tor instance (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms ParametricCanonicalE7ShimuraTor_axiomFree

-- R387 kernel-pure headline (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical_kernelPure
#print axioms VarietyHCAt_canonical_codim1_kernelPure

-- R387 status markers
#print axioms R387_AxiomFreeInstance_KernelPure
#print axioms R387_KernelPureHeadline_NoCanonicalAxiomInCone
#print axioms R387_AuthorizedRefactor_Closure_Achieved

-- Headline guard (must remain unchanged; cone still includes canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
