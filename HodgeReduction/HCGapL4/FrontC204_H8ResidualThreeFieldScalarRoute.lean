/-
# HC Gap L4 -- Front C204: three-field scalar route (R769).

R768 used four local fields to rebuild `MatsushimaV56BoundaryData`:

* exact image of source invariants;
* source-H8;
* the target-line scalar certificate;
* a nonzero target/trivial-module class.

The fourth field is not independent once source-H8 is present.  Source-H8
places `h^4` in `source_invariants`; Matsushima injectivity makes
`j_q(h^4)` nonzero; and equivariance puts that class in `target_invariants`.
This file builds the concrete R766 target-nonzero certificate directly, so the
preferred local route has three proof-work fields.

No exact-image theorem, source-H8 theorem, scalar-certificate theorem, boundary
data theorem, or Hodge-conjecture closure is asserted unconditionally.
-/

import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion
import HodgeReduction.HCGapL4.FrontC203_H8ResidualBoundaryDataFromScalarCertificate

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC204_H8ResidualThreeFieldScalarRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC202_H8ResidualTargetNonzeroCertificate
open FrontC203_H8ResidualBoundaryDataFromScalarCertificate

section ThreeFieldScalarRoute

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

/-- **R769 substantive theorem (1/8)**: source-H8 directly places `h^4` in
`source_invariants`. -/
theorem h_pow_four_mem_source_invariants_of_sourceH8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [hsource_H8]
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

/-- **R769 substantive theorem (2/8)**: source-H8 constructs the concrete
R766 target-nonzero certificate with witness `j_q(h^4)`. -/
def targetInvariantNonzeroCertificate_of_sourceH8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    TargetInvariantNonzeroCertificate A B where
  witness :=
    MatsushimaData.j_q (A := A) (B := B)
      ((KaehlerClass.h : A) ^ 4)
  witness_mem :=
    MatsushimaData.j_q_maps_invariants_to_invariants
      (h_pow_four_mem_source_invariants_of_sourceH8
        (A := A) (B := B) hsource_H8)
  witness_ne_zero :=
    matsushima_h_pow_four_image_ne_zero (A := A) (B := B)

/-- **R769 substantive theorem (3/8)**: the same source-H8 field supplies the
older nonzero trivial-module witness surface. -/
theorem exists_nonzero_trivialModulePart_class_of_sourceH8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Exists fun beta : B =>
      (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
        Not (beta = 0) :=
  exists_nonzero_trivialModulePart_class_of_targetInvariantNonzeroCertificate
    (A := A) (B := B)
    (targetInvariantNonzeroCertificate_of_sourceH8
      (A := A) (B := B) hsource_H8)

/-- **R769 substantive theorem (4/8)**: exact image, source-H8, and the
scalar certificate give the R669 line-equality contract. -/
def targetInvariantLineEqualityContract_of_exactImage_sourceH8_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B :=
  targetInvariantLineEqualityContract_of_exactImage_sourceH8_scalarCertificate_nonzero
    (A := A) (B := B) hexact hsource_H8 C
    (targetInvariantNonzeroCertificate_of_sourceH8
      (A := A) (B := B) hsource_H8)

/-- **R769 substantive theorem (5/8)**: the three R769 fields rebuild honest
`MatsushimaV56BoundaryData`, with no separate nonzero premise. -/
def matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate_nonzero
    (A := A) (B := B) hexact hsource_H8 C
    (targetInvariantNonzeroCertificate_of_sourceH8
      (A := A) (B := B) hsource_H8)

/-- **R769 substantive theorem (6/8)**: the three-field package exposes the
source boundary equality field directly. -/
theorem source_eq_compactDual_of_exactImage_sourceH8_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate
    (A := A) (B := B) hexact hsource_H8 C).source_eq_compactDual

/-- **R769 substantive theorem (7/8)**: the three-field package exposes the
target boundary equality field directly. -/
theorem target_eq_invariants_of_exactImage_sourceH8_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate
    (A := A) (B := B) hexact hsource_H8 C).target_eq_invariants

/-- **R769 substantive theorem (8/8)**: the three-field route also supplies
the nonempty boundary-data surface used by Prop-only consumers. -/
theorem boundaryData_nonempty_of_exactImage_sourceH8_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B) :
    Nonempty (MatsushimaV56BoundaryData A B) :=
  Nonempty.intro
    (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate
      (A := A) (B := B) hexact hsource_H8 C)

end ThreeFieldScalarRoute

/-- R769 target names for route summaries. -/
def currentR769ThreeFieldScalarRouteTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "construct target-line scalar certificate"
]

/-- Machine-readable status for the R769 three-field route. -/
structure R769ThreeFieldScalarRouteSnapshot where
  proofWorkObligationCount : Nat
  sourceH8PlacesHPowFourInSource : Bool
  sourceH8ConstructsTargetNonzeroCertificate : Bool
  sourceH8SuppliesTrivialModuleNonzero : Bool
  threeFieldsFeedLineEqualityContract : Bool
  threeFieldsRebuildBoundaryData : Bool
  exposesSourceBoundaryEquality : Bool
  exposesTargetBoundaryEquality : Bool
  removesNonzeroAsIndependentTarget : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesSourceH8 : Bool
  provesScalarCertificate : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R769 status: source-H8 itself supplies the target-nonzero
certificate, so the preferred local scalar route has three fields. -/
def currentR769ThreeFieldScalarRouteSnapshot :
    R769ThreeFieldScalarRouteSnapshot where
  proofWorkObligationCount := currentR769ThreeFieldScalarRouteTargetNames.length
  sourceH8PlacesHPowFourInSource := true
  sourceH8ConstructsTargetNonzeroCertificate := true
  sourceH8SuppliesTrivialModuleNonzero := true
  threeFieldsFeedLineEqualityContract := true
  threeFieldsRebuildBoundaryData := true
  exposesSourceBoundaryEquality := true
  exposesTargetBoundaryEquality := true
  removesNonzeroAsIndependentTarget := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesSourceH8 := false
  provesScalarCertificate := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R769 bridge. -/
theorem currentR769ThreeFieldScalarRouteSnapshot_eq_texStatus :
    currentR769ThreeFieldScalarRouteSnapshot =
      ({ proofWorkObligationCount := 3
         sourceH8PlacesHPowFourInSource := true
         sourceH8ConstructsTargetNonzeroCertificate := true
         sourceH8SuppliesTrivialModuleNonzero := true
         threeFieldsFeedLineEqualityContract := true
         threeFieldsRebuildBoundaryData := true
         exposesSourceBoundaryEquality := true
         exposesTargetBoundaryEquality := true
         removesNonzeroAsIndependentTarget := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesSourceH8 := false
         provesScalarCertificate := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R769ThreeFieldScalarRouteSnapshot) := by
  decide

/-- Kernel-checked target names for the R769 bridge. -/
theorem currentR769ThreeFieldScalarRouteTargetNames_eq_texStatus :
    currentR769ThreeFieldScalarRouteTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "construct target-line scalar certificate"
    ] := by
  rfl

def R769_substantiveTheoremCount : Nat := 8

end FrontC204_H8ResidualThreeFieldScalarRoute
end HCGapL4
end HodgeReduction
