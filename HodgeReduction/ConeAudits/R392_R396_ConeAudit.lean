import HodgeReduction.HCGapL4.ToyToRealPackageFamilyWitness
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyLowCodim
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyHighCodim
import HodgeReduction.HCGapL4.ToyToRealPackageFamilyDispatcher
import HodgeReduction.HCGapL4.HeadlineReplacementSafetyAfterPackageFamily
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R392 adapter (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms VarietyHC_transfer_via_ToyToRealPackageFamilyWitness

-- R392 target markers (no axioms)
#print axioms Target_ToyToRealPackageFamilyWitness_canonical_existence
#print axioms Target_ToyToRealPackageFamilyWitness_internal_reflexive_existence

-- R392 blockers (no axioms)
#print axioms Blocker_Canonical_packageTransport_PerCodim_NoElementaryConstruction
#print axioms Blocker_Canonical_AxiomRemoval_RequiresIndependentGeometryOrIsomorphism

-- R393 reflexive low-codim packages (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms ToyToToy_MTPackage_codim0
#print axioms ToyToToy_MTPackage_codim1
#print axioms ToyToToy_AlgClassCompat_codim0
#print axioms ToyToToy_AlgClassCompat_codim1
#print axioms ToyToToy_HodgeClassCompat_codim0
#print axioms ToyToToy_HodgeClassCompat_codim1

-- R393 canonical low-codim targets (no axioms)
#print axioms Target_ToyToReal_MTPackage_codim0
#print axioms Target_ToyToReal_MTPackage_codim1

-- R394 toy high-codim structural facts (KEY: kernel-pure)
#print axioms ToyHighCodim_H_is_Subsingleton
#print axioms ToyHighCodim_AlgClasses_eq_bot
#print axioms ToyHighCodim_HodgeClasses_le_bot

-- R394 reflexive high-codim packages (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms ToyToToy_MTPackage_codim_ge_two
#print axioms ToyToToy_AlgClassCompat_codim_ge_two
#print axioms ToyToToy_HodgeClassCompat_codim_ge_two

-- R394 canonical high-codim blocker (no axioms)
#print axioms Blocker_HighCodim_ToyPUnit_vs_RealNonTrivial
#print axioms Target_HighCodim_MTPackageTransport

-- R395 reflexive full instance (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms ToyToRealPackageFamilyWitness_internal_reflexive

-- R395 reflexive VarietyHC transfer demo (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms VarietyHC_via_internal_reflexive_witness

-- R395 canonical target + missing fields (no axioms)
#print axioms Target_ToyToRealPackageFamilyWitness_canonical
#print axioms MissingField_Canonical_realVCD
#print axioms MissingField_Canonical_realACD
#print axioms MissingField_Canonical_packageTransport_lowCodim
#print axioms MissingField_Canonical_packageTransport_highCodim_StructurallyBlocked

-- R396 refined safety audit (no axioms — pure Prop assignment)
#print axioms HeadlineReplacementSafetyAfterPackageFamily_current

-- R396 decision-logic lemma (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms R396_NotSafe_IfCanonicalFalse

-- R396 verdict marker
#print axioms R396_Status_Verdict_StillNotSafeToReplace

-- Toy kernel-pure headline (unchanged from R387)
#print axioms hodgeConjectureReal_canonical_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
