/-
# HC Gap L4 -- Front C160: latest route as Cartan comparison (R725).

R722 compressed the live primitive route to two geometric targets:

* `MatsushimaV56BoundaryData`;
* `compactDual = H8`.

R724 then showed that the paper-facing GK/Borel-Wallach/BBW/Freudenthal
carrier stack still does not force the second target.  This file reconnects
the latest R722 route to the more geometric Cartan/GK spelling already used
earlier in the project:

  `compactDual = CartanCompactDualIso.trivialModuleGK_H8`.

This is not a stronger premise: Cartan's compact-dual iso identifies
`trivialModuleGK_H8` with `H8`, and the two contract spellings are proved
equivalent below.  The file also transports the R724 countermodel to the
Cartan spelling, so future work cannot close the gap by citing the
paper-facing carriers alone.
-/

import HodgeReduction.HCGapL4.FrontC159_H8ResidualPaperCarrierStackIndependence
import HodgeReduction.HCGapL4.FrontC120_H8ResidualBoundaryDataCartanContract

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC160_H8ResidualCurrentCartanComparisonRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC156_H8ResidualCompactDualTwoContainmentRoute
open FrontC157_H8ResidualBoundaryCompactDualPrimitiveCollapse
open FrontC159_H8ResidualPaperCarrierStackIndependence

section CurrentCartanComparisonRoute

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

/-- **R725 substantive theorem (1/7)**: the latest compact-dual-H8 target
is exactly the compact-dual-to-Cartan/GK line target. -/
theorem compactDual_eq_cartanH8_iff_current_compactDual_eq_H8 :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)) <->
      (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :=
  compactDual_eq_cartanH8_iff_compactDual_eq_H8 (A := A) (B := B)

/-- **R725 substantive theorem (2/7)**: boundary data plus the Cartan/GK
comparison supplies the latest boundary-data/compact-dual-H8 contract. -/
def boundaryDataCompactDualH8Contract_of_currentBoundaryDataCartanContract
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    (compactDual_eq_cartanH8_iff_current_compactDual_eq_H8
      (A := A) (B := B)).1 O.compactDual_eq_cartanH8

/-- **R725 substantive theorem (3/7)**: the latest
boundary-data/compact-dual-H8 contract rebuilds the Cartan/GK comparison
contract, so the Cartan spelling adds no hidden stronger premise. -/
def currentBoundaryDataCartanContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary := O.boundary
  compactDual_eq_cartanH8 :=
    (compactDual_eq_cartanH8_iff_current_compactDual_eq_H8
      (A := A) (B := B)).2 O.compactDual_eq_H8

/-- **R725 substantive theorem (4/7)**: the Cartan/GK comparison contract
expands to the current R721 primitive two-containment route through R722. -/
def primitiveTwoContainmentContract_of_currentBoundaryDataCartanContract
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B :=
  primitiveTwoContainmentContract_of_boundaryDataCompactDualH8Contract
    (A := A) (B := B)
    (boundaryDataCompactDualH8Contract_of_currentBoundaryDataCartanContract
      (A := A) (B := B) O)

/-- **R725 substantive theorem (5/7)**: the current R721 primitive
two-containment route rebuilds the Cartan/GK comparison contract. -/
def currentBoundaryDataCartanContract_of_primitiveTwoContainmentContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B :=
  currentBoundaryDataCartanContract_of_boundaryDataCompactDualH8Contract
    (A := A) (B := B)
    (boundaryDataCompactDualH8Contract_of_primitiveTwoContainmentContract
      (A := A) (B := B) O)

/-- **R725 substantive theorem (6/7)**: the latest primitive route and the
boundary-data plus Cartan/GK comparison route are the same inhabited
residual contract. -/
theorem residual_primitiveTwoContainment_nonempty_iff_currentBoundaryDataCartan_nonempty :
    Nonempty (EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (currentBoundaryDataCartanContract_of_primitiveTwoContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (primitiveTwoContainmentContract_of_currentBoundaryDataCartanContract
            (A := A) (B := B) O)))

end CurrentCartanComparisonRoute

/-! ## R724 countermodel transported to the Cartan/GK spelling. -/

/-- **R725 substantive theorem (7/7)**: even with the paper-facing carrier
stack and honest boundary data, the current interface still does not force
the Cartan/GK comparison `compactDual = trivialModuleGK_H8`. -/
theorem paperCarrierStack_boundaryData_does_not_force_compactDual_eq_cartanH8 :
    Nonempty (GKCohomologyData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource) /\
      Nonempty (CompactDualH44Bigrading BoundaryNoExtraObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget) /\
      Nonempty (FreudenthalRealization BoundaryNoExtraObstructionTarget) /\
      MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      Not
        (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget) =
          CartanCompactDualIso.trivialModuleGK_H8
            (A := BoundaryNoExtraObstructionSource)) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotH8⟩ :=
      paperCarrierStack_boundaryData_does_not_force_compactDual_eq_H8
  refine ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro hcartan
  exact hnotH8
    ((compactDual_eq_cartanH8_iff_current_compactDual_eq_H8
      (A := BoundaryNoExtraObstructionSource)
      (B := BoundaryNoExtraObstructionTarget)).1 hcartan)

/-- R725 target names for route summaries. -/
def currentR725CurrentCartanComparisonTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove MatsushimaCompactDualData.compactDual = CartanCompactDualIso.trivialModuleGK_H8"
]

/-- Machine-readable status for the current Cartan/GK comparison route. -/
structure R725CurrentCartanComparisonSnapshot where
  proofWorkObligationCount : Nat
  compactDualCartanEquivalentToCompactDualH8 : Bool
  currentPrimitiveRouteEquivalentToBoundaryDataCartan : Bool
  paperCarrierStackForcesCompactDualCartan : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualCartan : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R725 status: the latest route can be attacked as boundary data
plus the Cartan/GK comparison, but the carrier stack still does not prove
that comparison. -/
def currentR725CurrentCartanComparisonSnapshot :
    R725CurrentCartanComparisonSnapshot where
  proofWorkObligationCount := currentR725CurrentCartanComparisonTargetNames.length
  compactDualCartanEquivalentToCompactDualH8 := true
  currentPrimitiveRouteEquivalentToBoundaryDataCartan := true
  paperCarrierStackForcesCompactDualCartan := false
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualCartan := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R725 Cartan/GK comparison route. -/
theorem currentR725CurrentCartanComparisonSnapshot_eq_texStatus :
    currentR725CurrentCartanComparisonSnapshot =
      ({ proofWorkObligationCount := 2
         compactDualCartanEquivalentToCompactDualH8 := true
         currentPrimitiveRouteEquivalentToBoundaryDataCartan := true
         paperCarrierStackForcesCompactDualCartan := false
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualCartan := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R725CurrentCartanComparisonSnapshot) := by
  decide

/-- Kernel-checked target names for the R725 route. -/
theorem currentR725CurrentCartanComparisonTargetNames_eq_texStatus :
    currentR725CurrentCartanComparisonTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove MatsushimaCompactDualData.compactDual = CartanCompactDualIso.trivialModuleGK_H8"
    ] := by
  rfl

def R725_substantiveTheoremCount : Nat := 7

end FrontC160_H8ResidualCurrentCartanComparisonRoute
end HCGapL4
end HodgeReduction
