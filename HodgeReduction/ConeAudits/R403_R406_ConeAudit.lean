import HodgeReduction.HCGapL4.RealGeometryIdentificationSchema
import HodgeReduction.HCGapL4.RealGeometryPaperObligationLedger
import HodgeReduction.HCGapL4.ConditionalRealHeadlineTransfer
import HodgeReduction.HCGapL4.HCFrontierAfterRealGeometrySchema
import HodgeReduction.MainTheorem

open HodgeReduction.HCGapL4
open HodgeReduction

-- R403 weak schema pin (NOTE: cone WILL include canonicalE7ShimuraTor — instance pin)
#print axioms RealGeometryIdentificationSchemaWeak_pin

-- R403 targets / open obligations (no axioms)
#print axioms Target_RealGeometryIdentificationSchema_canonical_existence
#print axioms Open_RealGeometryIdentificationSchema_CohomologyEquiv_Forall_k
#print axioms Open_RealGeometryIdentificationSchema_HodgeCompatibility
#print axioms Open_RealGeometryIdentificationSchema_AlgClassesCompatibility
#print axioms Open_RealGeometryIdentificationSchema_MTPackageCompatibility

-- R404 ledger instance (no axioms)
#print axioms RealGeometryPaperObligationLedger_current
#print axioms R404_Obligation1_E7ShimuraVarietyConstruction_OPEN
#print axioms R404_Obligation6_Deligne1982_CM_HC_OPEN
#print axioms R404_Priority1_CohomologyProfileComparison

-- R405 Prop-level conditional marker (no axioms)
#print axioms hodgeConjectureReal_realCompatible_to_realCanonical_conditional

-- R405 SUBSTANTIVE transfer (KEY: must NOT include canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_realCompatible_to_realCanonical_via_packages
#print axioms VarietyHCAt_realCompatible_to_realCanonical_codim1_conditional

-- R405 missing-witness markers (no axioms)
#print axioms MissingWitness_R405_RealCompatibleToCanonical_MTPackage_PerCodim
#print axioms MissingWitness_R405_Schema_ProfileSide_Pinned
#print axioms MissingWitness_R405_Schema_RealSide_Pinned_To_Canonical

-- R406 frontier instance (no axioms — pure Prop assignment)
#print axioms HCFrontierAfterRealGeometrySchema_current

-- R406 headline re-exports (kernel-pure, NO canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical_kernelPure_R406_toy
#print axioms hodgeConjectureReal_canonical_kernelPure_R406_realCompatible

-- R406 final-goal + next-target markers (no axioms)
#print axioms R406_HC_FinalGoal_KernelOnly
#print axioms R406_RealGeometryInterface_Available
#print axioms R406_OriginalHeadline_NotYetReplaced
#print axioms R406_NextTarget_R407_CohomologyProfileComparison

-- Toy kernel-pure headline (unchanged from R387)
#print axioms hodgeConjectureReal_canonical_kernelPure

-- Real-compatible kernel-pure headline (unchanged from R399)
#print axioms hodgeConjectureReal_realCompatible_kernelPure

-- Headline guard (must remain unchanged; cone still contains canonicalE7ShimuraTor)
#print axioms hodgeConjectureReal_canonical
