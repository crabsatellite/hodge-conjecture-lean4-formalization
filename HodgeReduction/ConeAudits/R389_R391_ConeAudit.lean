import HodgeReduction.HCGapL4.ToyToRealE7VCDIdentification
import HodgeReduction.HCGapL4.ToyToRealHCTransfer
import HodgeReduction.HCGapL4.OriginalHeadlineReplacementSafetyAudit
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R389 weak bridge pin (NOTE: cone WILL include canonicalE7ShimuraTor
-- because realVCD := canonicalE7ShimuraTor.cohomologyOfUnderlying)
#print axioms ToyToRealE7VCDIdentificationWeak_pin

-- R389 target Props (must NOT depend on any axioms)
#print axioms Target_ToyToRealE7_H0_Comparison
#print axioms Target_ToyToRealE7_H2_Comparison
#print axioms Target_ToyToRealE7_HighCodim_Comparison
#print axioms Target_ToyToRealE7_HodgeClasses_Comparison
#print axioms Open_ToyToRealE7VCDIdentification_StrongInstance_Existence

-- R390 transfer data pin (also references canonicalE7ShimuraTor via R389 pin)
#print axioms ToyToRealHCTransferData_pin

-- R390 Prop-level transfer marker
#print axioms VarietyHC_transfer_of_toyToReal_propLevel

-- R390 SUBSTANTIVE transfer theorem (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms VarietyHC_transfer_of_toyToReal_via_packages
#print axioms VarietyHCAt_codim1_transfer_of_toyToReal

-- R390 missing-witness markers (no axioms)
#print axioms MissingWitness_AlgClassImageCompatibility_PerCodim
#print axioms MissingWitness_HodgeClassImageCompatibility_PerCodim
#print axioms MissingWitness_AllCodim_PackageFamily_Transport

-- R391 safety audit instance (no axioms — pure Prop assignment)
#print axioms OriginalHeadlineReplacementSafetyAudit_current

-- R391 decision-logic lemma (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms R391_NotSafe_IfAnyConditionFalse

-- R391 target for realized replacement (intentionally undefined as theorem)
#print axioms Target_hodgeConjectureReal_canonical_axiomFree_realized

-- R391 verdict marker
#print axioms R391_Status_Verdict_NotSafeToReplace

-- Toy kernel-pure headline (unchanged from R387)
#print axioms hodgeConjectureReal_canonical_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
