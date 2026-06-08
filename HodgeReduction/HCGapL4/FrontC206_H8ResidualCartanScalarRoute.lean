/-
# HC Gap L4 -- Front C206: Cartan-containment scalar route (R771).

R770 leaves a local scalar route with three fields:

* exact image of source invariants;
* `h^4 in source_invariants`;
* the target-line scalar certificate.

R661 identifies the source generator target with the geometric Cartan-to-
compactDual containment `CartanH8 <= compactDual`.  This file wires that
containment into the R770 scalar route.  The preferred local target is now:

* exact image of source invariants;
* `CartanH8 <= compactDual`;
* the target-line scalar certificate.

No exact-image theorem, Cartan-containment theorem, scalar-certificate theorem,
boundary-data theorem, or Hodge-conjecture closure is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine
import HodgeReduction.HCGapL4.FrontC205_H8ResidualGeneratorScalarRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC206_H8ResidualCartanScalarRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC96_H8ResidualSourceGeneratorFromCompactDual
open FrontC97_H8ResidualCartanToCompactDualLine
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC204_H8ResidualThreeFieldScalarRoute
open FrontC205_H8ResidualGeneratorScalarRoute

section CartanScalarRoute

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

/-- **R771 substantive theorem (1/8)**: the Cartan-to-compactDual containment
supplies the source generator membership required by R770. -/
theorem h_pow_four_mem_source_invariants_of_cartanH8_le_compactDual
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual
    (A := A) (B := B)
    ((cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 hcartan)

/-- **R771 substantive theorem (2/8)**: Cartan-to-compactDual containment
plus scalar certificate recovers full source-H8. -/
theorem source_invariants_eq_H8_of_cartanH8_le_compactDual_scalarCertificate
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_source_scalarCertificate
    (A := A) (B := B)
    (h_pow_four_mem_source_invariants_of_cartanH8_le_compactDual
      (A := A) (B := B) hcartan)
    C

/-- **R771 substantive theorem (3/8)**: Cartan-to-compactDual containment
plus scalar certificate constructs the concrete R766 target-nonzero
certificate. -/
def targetInvariantNonzeroCertificate_of_cartanH8_le_compactDual_scalarCertificate
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    TargetInvariantNonzeroCertificate A B :=
  targetInvariantNonzeroCertificate_of_h_pow_four_mem_source_scalarCertificate
    (A := A) (B := B)
    (h_pow_four_mem_source_invariants_of_cartanH8_le_compactDual
      (A := A) (B := B) hcartan)
    C

/-- **R771 substantive theorem (4/8)**: exact image, Cartan containment, and
scalar certificate give the R669 line-equality contract. -/
def targetInvariantLineEqualityContract_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B :=
  targetInvariantLineEqualityContract_of_exactImage_hPowSource_scalarCertificate
    (A := A) (B := B)
    hexact
    (h_pow_four_mem_source_invariants_of_cartanH8_le_compactDual
      (A := A) (B := B) hcartan)
    C

/-- **R771 substantive theorem (5/8)**: the R771 fields rebuild honest
`MatsushimaV56BoundaryData`. -/
def matsushimaV56BoundaryData_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_exactImage_hPowSource_scalarCertificate
    (A := A) (B := B)
    hexact
    (h_pow_four_mem_source_invariants_of_cartanH8_le_compactDual
      (A := A) (B := B) hcartan)
    C

/-- **R771 substantive theorem (6/8)**: the R771 fields expose the source
boundary equality. -/
theorem source_eq_compactDual_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B) hexact hcartan C).source_eq_compactDual

/-- **R771 substantive theorem (7/8)**: the R771 fields expose the target
boundary equality. -/
theorem target_eq_invariants_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (A := A) (B := B) hexact hcartan C).target_eq_invariants

/-- **R771 substantive theorem (8/8)**: the R771 fields supply the Prop-only
boundary-data surface. -/
theorem boundaryData_nonempty_of_exactImage_cartanH8_le_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (C : TargetInvariantLineScalarCertificate A B) :
    Nonempty (MatsushimaV56BoundaryData A B) :=
  Nonempty.intro
    (matsushimaV56BoundaryData_of_exactImage_cartanH8_le_compactDual_scalarCertificate
      (A := A) (B := B) hexact hcartan C)

end CartanScalarRoute

/-- R771 target names for route summaries. -/
def currentR771CartanScalarRouteTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove CartanH8 <= compactDual",
  "construct target-line scalar certificate"
]

/-- Machine-readable status for the R771 Cartan/scalar route. -/
structure R771CartanScalarRouteSnapshot where
  proofWorkObligationCount : Nat
  cartanContainmentSuppliesSourceGenerator : Bool
  scalarCertificatePlusCartanContainmentSuppliesSourceH8 : Bool
  sourceGeneratorRemovedAsIndependentTarget : Bool
  cartanScalarFieldsRebuildBoundaryData : Bool
  exposesSourceBoundaryEquality : Bool
  exposesTargetBoundaryEquality : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCartanContainment : Bool
  provesScalarCertificate : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R771 status: the source generator field is replaced by the
equivalent Cartan-to-compactDual containment, while exact image and the scalar
certificate remain open. -/
def currentR771CartanScalarRouteSnapshot :
    R771CartanScalarRouteSnapshot where
  proofWorkObligationCount := currentR771CartanScalarRouteTargetNames.length
  cartanContainmentSuppliesSourceGenerator := true
  scalarCertificatePlusCartanContainmentSuppliesSourceH8 := true
  sourceGeneratorRemovedAsIndependentTarget := true
  cartanScalarFieldsRebuildBoundaryData := true
  exposesSourceBoundaryEquality := true
  exposesTargetBoundaryEquality := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCartanContainment := false
  provesScalarCertificate := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R771 bridge. -/
theorem currentR771CartanScalarRouteSnapshot_eq_texStatus :
    currentR771CartanScalarRouteSnapshot =
      ({ proofWorkObligationCount := 3
         cartanContainmentSuppliesSourceGenerator := true
         scalarCertificatePlusCartanContainmentSuppliesSourceH8 := true
         sourceGeneratorRemovedAsIndependentTarget := true
         cartanScalarFieldsRebuildBoundaryData := true
         exposesSourceBoundaryEquality := true
         exposesTargetBoundaryEquality := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCartanContainment := false
         provesScalarCertificate := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R771CartanScalarRouteSnapshot) := by
  decide

/-- Kernel-checked target names for the R771 bridge. -/
theorem currentR771CartanScalarRouteTargetNames_eq_texStatus :
    currentR771CartanScalarRouteTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove CartanH8 <= compactDual",
      "construct target-line scalar certificate"
    ] := by
  rfl

def R771_substantiveTheoremCount : Nat := 8

end FrontC206_H8ResidualCartanScalarRoute
end HCGapL4
end HodgeReduction
