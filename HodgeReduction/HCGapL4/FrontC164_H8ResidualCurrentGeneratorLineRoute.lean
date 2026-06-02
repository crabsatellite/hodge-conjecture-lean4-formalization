/-
# HC Gap L4 -- Front C164: current route as generator plus target line (R729).

R728 identifies the current residual route with:

* `MatsushimaV56BoundaryData`;
* `source_invariants = H8`.

This file opens the second target into a sharper source/target line route:

* `h^4 in source_invariants`;
* `trivialModulePart <= span {j_q(h^4)}`.

The target line containment forces the no-extra source half by injectivity of
`j_q`; generator membership supplies the opposite H8 containment.  Conversely,
boundary data plus `source_invariants = H8` recovers the same target line
containment.  Thus this is an equivalent attack surface for the current route,
not a new closure claim and not a bundled stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC163_H8ResidualCurrentSourceInvariantRoute
import HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment
import HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC164_H8ResidualCurrentGeneratorLineRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC60_H8ResidualSourceCarrierSplitPackage
open FrontC95_H8ResidualSourceNoExtraFromLineContainment
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC121_H8ResidualBoundaryDataSourceInvariantRoute
open FrontC162_H8ResidualCompactDualGeneratorGeometryRoute
open FrontC163_H8ResidualCurrentSourceInvariantRoute

section CurrentGeneratorLineRoute

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

/-- Boundary data plus the source generator membership and target generator-line
containment.  R729 proves this is equivalent to the current R728
boundary-data/source-H8 route. -/
structure EVIIH8ResidualBoundaryDataSourceGeneratorLineContract
    (A B : Type*)
    [CommRing A] [Algebra Rat A] [CohomologyRing A]
    [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B]
    [CuspidalCohomologyData B]
    [EisensteinVanishingDeg8 A B]
    [CuspidalGInvariantTrivialModuleDeg8 A B] where
  boundary : MatsushimaV56BoundaryData A B
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R729 substantive theorem (1/7)**: the target generator-line containment
inside the R729 route forces the no-extra source containment. -/
theorem source_invariants_le_H8_of_sourceGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) <=
      CompactDualData.H8 (A := A) :=
  source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B) O.trivialModulePart_le_h_pow_four_line

/-- **R729 substantive theorem (2/7)**: source generator membership plus the
target generator-line containment recovers the source-H8 equality. -/
theorem source_invariants_eq_H8_of_sourceGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
    (A := A) (B := B)
    O.h_pow_four_mem_source_invariants
    O.trivialModulePart_le_h_pow_four_line

/-- **R729 substantive theorem (3/7)**: the generator-line route feeds the
current boundary-data/source-H8 contract. -/
def boundaryDataSourceH8Contract_of_sourceGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B where
  boundary := O.boundary
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_sourceGeneratorLineContract
      (A := A) (B := B) O

/-- **R729 substantive theorem (4/7)**: boundary data plus source-H8 gives the
target generator-line containment used by the R729 route. -/
theorem trivialModulePart_le_h_pow_four_line_of_boundaryData_source_invariants_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  have htarget_line :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
      (A := A) (B := B) D hsource_H8
  have htrivial_line :
      CuspidalCohomologyData.trivialModulePart (A := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} := by
    calc
      CuspidalCohomologyData.trivialModulePart (A := B)
          = MatsushimaData.target_invariants (A := A) (B := B) :=
          (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm
      _ =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} := htarget_line
  rw [htrivial_line]

/-- **R729 substantive theorem (5/7)**: the current boundary-data/source-H8
contract rebuilds the generator-line route. -/
def sourceGeneratorLineContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B where
  boundary := O.boundary
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
      (A := A) (B := B) O.source_invariants_eq_H8
  trivialModulePart_le_h_pow_four_line :=
    trivialModulePart_le_h_pow_four_line_of_boundaryData_source_invariants_eq_H8
      (A := A) (B := B) O.boundary O.source_invariants_eq_H8

/-- **R729 substantive theorem (6/7)**: the current boundary-data/source-H8
route and the generator-line route are the same inhabited residual contract. -/
theorem residual_boundaryDataSourceH8_nonempty_iff_sourceGeneratorLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceGeneratorLineContract_of_boundaryDataSourceH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceH8Contract_of_sourceGeneratorLineContract
            (A := A) (B := B) O)))

/-- **R729 substantive theorem (7/7)**: the current R727/R728 route is
equivalent to the boundary-data plus generator-line attack surface. -/
theorem residual_currentGeneratorGeometry_nonempty_iff_sourceGeneratorLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataSourceH8_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataSourceH8_nonempty_iff_sourceGeneratorLine_nonempty
      (A := A) (B := B))

end CurrentGeneratorLineRoute

/-- R729 target names for route summaries. -/
def currentR729CurrentGeneratorLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in source_invariants",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R729 current generator-line route. -/
structure R729CurrentGeneratorLineSnapshot where
  proofWorkObligationCount : Nat
  currentRouteEquivalentToGeneratorLine : Bool
  generatorLineDerivesSourceH8 : Bool
  sourceH8DerivesGeneratorLineUnderBoundary : Bool
  lineContainmentControlsNoExtraSource : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesGeneratorMembership : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R729 status: the non-boundary source-H8 target can be attacked as
source generator membership plus the target generator-line containment. -/
def currentR729CurrentGeneratorLineSnapshot :
    R729CurrentGeneratorLineSnapshot where
  proofWorkObligationCount := currentR729CurrentGeneratorLineTargetNames.length
  currentRouteEquivalentToGeneratorLine := true
  generatorLineDerivesSourceH8 := true
  sourceH8DerivesGeneratorLineUnderBoundary := true
  lineContainmentControlsNoExtraSource := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesGeneratorMembership := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R729 generator-line route. -/
theorem currentR729CurrentGeneratorLineSnapshot_eq_texStatus :
    currentR729CurrentGeneratorLineSnapshot =
      ({ proofWorkObligationCount := 3
         currentRouteEquivalentToGeneratorLine := true
         generatorLineDerivesSourceH8 := true
         sourceH8DerivesGeneratorLineUnderBoundary := true
         lineContainmentControlsNoExtraSource := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesGeneratorMembership := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R729CurrentGeneratorLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R729 route. -/
theorem currentR729CurrentGeneratorLineTargetNames_eq_texStatus :
    currentR729CurrentGeneratorLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in source_invariants",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R729_substantiveTheoremCount : Nat := 7

end FrontC164_H8ResidualCurrentGeneratorLineRoute
end HCGapL4
end HodgeReduction
