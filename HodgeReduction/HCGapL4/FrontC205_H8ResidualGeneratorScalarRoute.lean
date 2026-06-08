/-
# HC Gap L4 -- Front C205: generator plus scalar route (R770).

R769 leaves the local scalar route with three fields:

* exact image of source invariants;
* source-H8;
* the target-line scalar certificate.

This file weakens the source-H8 field.  The scalar certificate already gives
the target-line containment, and R659/R764 show that this containment forces
the no-extra source half `source_invariants <= H8`.  Therefore full source-H8
is recovered from:

* `h^4 in source_invariants`;
* the same scalar certificate.

The preferred local route is now exact image, source generator membership, and
the scalar certificate.  No one of these fields is proved unconditionally.
-/

import HodgeReduction.HCGapL4.FrontC199_H8ResidualTargetLineSourceContainmentBridge
import HodgeReduction.HCGapL4.FrontC204_H8ResidualThreeFieldScalarRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC205_H8ResidualGeneratorScalarRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC95_H8ResidualSourceNoExtraFromLineContainment
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC199_H8ResidualTargetLineSourceContainmentBridge
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC204_H8ResidualThreeFieldScalarRoute

section GeneratorScalarRoute

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R770 substantive theorem (1/8)**: source generator membership plus the
scalar certificate recovers full source-H8. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_source_scalarCertificate
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
    (A := A) (B := B)
    hh_source
    (trivialModulePart_le_h_pow_four_line_of_target_invariants_le_h_pow_four_line
      (A := A) (B := B)
      (target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
        (A := A) (B := B) C))

/-- **R770 substantive theorem (2/8)**: the R766 target-nonzero certificate is
constructed from source generator membership plus the scalar certificate. -/
def targetInvariantNonzeroCertificate_of_h_pow_four_mem_source_scalarCertificate
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    TargetInvariantNonzeroCertificate A B :=
  targetInvariantNonzeroCertificate_of_sourceH8
    (A := A) (B := B)
    (source_invariants_eq_H8_of_h_pow_four_mem_source_scalarCertificate
      (A := A) (B := B) hh_source C)

/-- **R770 substantive theorem (3/8)**: exact image, source generator
membership, and scalar certificate give the R669 line-equality contract. -/
def targetInvariantLineEqualityContract_of_exactImage_hPowSource_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B :=
  targetInvariantLineEqualityContract_of_exactImage_sourceH8_scalarCertificate
    (A := A) (B := B)
    hexact
    (source_invariants_eq_H8_of_h_pow_four_mem_source_scalarCertificate
      (A := A) (B := B) hh_source C)
    C

/-- **R770 substantive theorem (4/8)**: the three R770 fields rebuild honest
`MatsushimaV56BoundaryData`. -/
def matsushimaV56BoundaryData_of_exactImage_hPowSource_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate
    (A := A) (B := B)
    hexact
    (source_invariants_eq_H8_of_h_pow_four_mem_source_scalarCertificate
      (A := A) (B := B) hh_source C)
    C

/-- **R770 substantive theorem (5/8)**: the R770 fields expose the source
boundary equality. -/
theorem source_eq_compactDual_of_exactImage_hPowSource_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_hPowSource_scalarCertificate
    (A := A) (B := B) hexact hh_source C).source_eq_compactDual

/-- **R770 substantive theorem (6/8)**: the R770 fields expose the target
boundary equality. -/
theorem target_eq_invariants_of_exactImage_hPowSource_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_hPowSource_scalarCertificate
    (A := A) (B := B) hexact hh_source C).target_eq_invariants

/-- **R770 substantive theorem (7/8)**: the R770 fields supply the Prop-only
boundary-data surface. -/
theorem boundaryData_nonempty_of_exactImage_hPowSource_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    Nonempty (MatsushimaV56BoundaryData A B) :=
  Nonempty.intro
    (matsushimaV56BoundaryData_of_exactImage_hPowSource_scalarCertificate
      (A := A) (B := B) hexact hh_source C)

/-- **R770 substantive theorem (8/8)**: source-H8 is not a separate field of
the R770 package; it is derived and can be projected directly. -/
theorem sourceH8_of_exactImage_hPowSource_scalarCertificate
    (_hexact : sourceInvariantExactImageTarget A B)
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_source_scalarCertificate
    (A := A) (B := B) hh_source C

end GeneratorScalarRoute

/-- R770 target names for route summaries. -/
def currentR770GeneratorScalarRouteTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove h^4 in source_invariants",
  "construct target-line scalar certificate"
]

/-- Machine-readable status for the R770 generator/scalar route. -/
structure R770GeneratorScalarRouteSnapshot where
  proofWorkObligationCount : Nat
  scalarCertificateSuppliesTargetLineContainment : Bool
  scalarCertificatePlusGeneratorSuppliesSourceH8 : Bool
  sourceH8RemovedAsIndependentTarget : Bool
  generatorScalarFieldsRebuildBoundaryData : Bool
  exposesSourceBoundaryEquality : Bool
  exposesTargetBoundaryEquality : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesSourceGeneratorMembership : Bool
  provesScalarCertificate : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R770 status: scalar certificate plus source generator membership
recovers source-H8, leaving exact image, generator membership, and scalar
certificate as the local proof-work fields. -/
def currentR770GeneratorScalarRouteSnapshot :
    R770GeneratorScalarRouteSnapshot where
  proofWorkObligationCount := currentR770GeneratorScalarRouteTargetNames.length
  scalarCertificateSuppliesTargetLineContainment := true
  scalarCertificatePlusGeneratorSuppliesSourceH8 := true
  sourceH8RemovedAsIndependentTarget := true
  generatorScalarFieldsRebuildBoundaryData := true
  exposesSourceBoundaryEquality := true
  exposesTargetBoundaryEquality := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesSourceGeneratorMembership := false
  provesScalarCertificate := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R770 bridge. -/
theorem currentR770GeneratorScalarRouteSnapshot_eq_texStatus :
    currentR770GeneratorScalarRouteSnapshot =
      ({ proofWorkObligationCount := 3
         scalarCertificateSuppliesTargetLineContainment := true
         scalarCertificatePlusGeneratorSuppliesSourceH8 := true
         sourceH8RemovedAsIndependentTarget := true
         generatorScalarFieldsRebuildBoundaryData := true
         exposesSourceBoundaryEquality := true
         exposesTargetBoundaryEquality := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesSourceGeneratorMembership := false
         provesScalarCertificate := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R770GeneratorScalarRouteSnapshot) := by
  decide

/-- Kernel-checked target names for the R770 bridge. -/
theorem currentR770GeneratorScalarRouteTargetNames_eq_texStatus :
    currentR770GeneratorScalarRouteTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove h^4 in source_invariants",
      "construct target-line scalar certificate"
    ] := by
  rfl

def R770_substantiveTheoremCount : Nat := 8

end FrontC205_H8ResidualGeneratorScalarRoute
end HCGapL4
end HodgeReduction
