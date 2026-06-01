/-
# HC Gap L4 -- Front C157: primitive two-containment collapse (R722).

R721 exposed the live route as four primitive targets:

* `surjectivity_source = compactDual`;
* `surjectivity_target = trivialModulePart`;
* `compactDual <= H8`;
* `H8 <= compactDual`.

This file proves that those four primitive targets are exactly the older,
two-item geometry route:

* honest `MatsushimaV56BoundaryData`;
* `compactDual = H8`.

It does not prove either item.  The purpose is to keep the graph honest:
future attacks may work on the two geometric targets, while the audit can still
expand them back to the four primitive R721 obligations.
-/

import HodgeReduction.HCGapL4.FrontC156_H8ResidualCompactDualTwoContainmentRoute
import HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC157_H8ResidualBoundaryCompactDualPrimitiveCollapse

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC154_H8ResidualPrimitiveBoundaryFiniteRankRoute
open FrontC156_H8ResidualCompactDualTwoContainmentRoute

section BoundaryCompactDualPrimitiveCollapse

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

/-- **R722 substantive theorem (1/4)**: boundary data plus the compact-dual-H8
equality expands to the R721 four primitive obligations. -/
def primitiveTwoContainmentContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B where
  boundary :=
    primitiveBoundaryDataContract_of_matsushimaV56BoundaryData
      (A := A) (B := B) O.boundary
  compactDual_le_H8 :=
    ((compactDual_twoContainments_iff_eq_H8
      (A := A) (B := B)).2 O.compactDual_eq_H8).1
  H8_le_compactDual :=
    ((compactDual_twoContainments_iff_eq_H8
      (A := A) (B := B)).2 O.compactDual_eq_H8).2

/-- **R722 substantive theorem (2/4)**: the R721 four primitive obligations
rebuild the two-item boundary-data/compact-dual-H8 route. -/
def boundaryDataCompactDualH8Contract_of_primitiveTwoContainmentContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary :=
    matsushimaV56BoundaryData_of_primitiveBoundaryDataContract
      (A := A) (B := B) O.boundary
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_twoContainments
      (A := A) (B := B) O.compactDual_le_H8 O.H8_le_compactDual

/-- **R722 substantive theorem (3/4)**: the two-item geometry route and the
R721 primitive route are the same inhabited residual contract. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_primitiveTwoContainment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty
        (EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (primitiveTwoContainmentContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_primitiveTwoContainmentContract
            (A := A) (B := B) O)))

/-- **R722 substantive theorem (4/4)**: the current concrete boundary/source-H8
route can be read as boundary data plus compact-dual-H8 equality through the
R721 primitive route. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualH8_nonempty_via_twoContainments :
    Nonempty (FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute.EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_twoContainment_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_primitiveTwoContainment_nonempty
      (A := A) (B := B)).symm

end BoundaryCompactDualPrimitiveCollapse

/-- R722 target names for route summaries. -/
def currentR722BoundaryCompactDualPrimitiveCollapseTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = H8"
]

/-- Machine-readable status for the R722 primitive-collapse route. -/
structure R722BoundaryCompactDualPrimitiveCollapseSnapshot where
  proofWorkObligationCount : Nat
  primitiveBoundaryEquivalentToBoundaryData : Bool
  twoContainmentsEquivalentToCompactDualH8 : Bool
  boundaryCompactDualRouteEquivalentToPrimitiveTwoContainment : Bool
  boundarySourceH8RouteEquivalentViaTwoContainments : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  provesAnyPrimitiveTarget : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R722 status: the four primitive R721 targets collapse exactly to
the two geometric targets `MatsushimaV56BoundaryData` and `compactDual = H8`.
Both targets remain open. -/
def currentR722BoundaryCompactDualPrimitiveCollapseSnapshot :
    R722BoundaryCompactDualPrimitiveCollapseSnapshot where
  proofWorkObligationCount :=
    currentR722BoundaryCompactDualPrimitiveCollapseTargetNames.length
  primitiveBoundaryEquivalentToBoundaryData := true
  twoContainmentsEquivalentToCompactDualH8 := true
  boundaryCompactDualRouteEquivalentToPrimitiveTwoContainment := true
  boundarySourceH8RouteEquivalentViaTwoContainments := true
  provesBoundaryData := false
  provesCompactDualH8 := false
  provesAnyPrimitiveTarget := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R722 route. -/
theorem currentR722BoundaryCompactDualPrimitiveCollapseSnapshot_eq_texStatus :
    currentR722BoundaryCompactDualPrimitiveCollapseSnapshot =
      ({ proofWorkObligationCount := 2
         primitiveBoundaryEquivalentToBoundaryData := true
         twoContainmentsEquivalentToCompactDualH8 := true
         boundaryCompactDualRouteEquivalentToPrimitiveTwoContainment := true
         boundarySourceH8RouteEquivalentViaTwoContainments := true
         provesBoundaryData := false
         provesCompactDualH8 := false
         provesAnyPrimitiveTarget := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R722BoundaryCompactDualPrimitiveCollapseSnapshot) := by
  decide

/-- Kernel-checked target names for the R722 route. -/
theorem currentR722BoundaryCompactDualPrimitiveCollapseTargetNames_eq_texStatus :
    currentR722BoundaryCompactDualPrimitiveCollapseTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = H8"
    ] := by
  rfl

def R722_substantiveTheoremCount : Nat := 4

end FrontC157_H8ResidualBoundaryCompactDualPrimitiveCollapse
end HCGapL4
end HodgeReduction
