/-
# HC Gap L4 -- Front C167: current two-containment obstruction (R732).

R731 gives the active non-boundary target as the two direct containments

* `compactDual <= H8`;
* `H8 <= compactDual`.

R726 already showed, in Cartan notation, that the tempting paper-facing
carrier stack (GK/Borel-Wallach/BBW/Freudenthal fields plus boundary data)
does not force either Cartan containment direction.  Since Cartan's compact
dual line is definitionally identified with `H8`, this file transports those
countermodels to the current R731 spelling.

No target is proved here.  The purpose is to block a common false closure:
the next proof must supply genuine EVII compact-dual comparison geometry for
one of the two containment directions, not merely cite the carrier stack.
-/

import HodgeReduction.HCGapL4.FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence
import HodgeReduction.HCGapL4.FrontC166_H8ResidualCurrentCompactDualTwoContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC167_H8ResidualCurrentTwoContainmentIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC100_H8ResidualCartanContainmentIndependence
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence
open FrontC166_H8ResidualCurrentCompactDualTwoContainmentRoute

/-! ## Transport the R726 carrier-stack obstructions to the R731 spelling. -/

/-- **R732 obstruction theorem (1/7)**: on the R706 no-extra countermodel,
paper-facing carriers plus boundary data still do not force the direct current
containment `compactDual <= H8`. -/
theorem paperCarrierStack_boundaryData_does_not_force_compactDual_le_H8 :
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
        (LE.le (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget))
          (CompactDualData.H8
            (A := BoundaryNoExtraObstructionSource))) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotCartan⟩ :=
      paperCarrierStack_boundaryData_does_not_force_compactDual_le_cartanH8
  refine
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro hleH8
  have hleCartan :
      LE.le (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget))
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := BoundaryNoExtraObstructionSource)) := by
    rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
      (A := BoundaryNoExtraObstructionSource)]
    exact hleH8
  exact hnotCartan hleCartan

/-- **R732 obstruction theorem (2/7)**: on the R664 generator countermodel,
paper-facing carriers plus boundary data still do not force the direct current
containment `H8 <= compactDual`. -/
theorem paperCarrierStack_boundaryData_does_not_force_H8_le_compactDual :
    Nonempty (GKCohomologyData CartanContainmentObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing CartanContainmentObstructionSource) /\
      Nonempty (BorelBottWeilData CartanContainmentObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII CartanContainmentObstructionSource) /\
      Nonempty (CompactDualH44Bigrading CartanContainmentObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance CartanContainmentObstructionTarget) /\
      Nonempty (FreudenthalRealization CartanContainmentObstructionTarget) /\
      MatsushimaV56BoundaryData
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget /\
      Not
        (LE.le (CompactDualData.H8
            (A := CartanContainmentObstructionSource))
          (MatsushimaCompactDualData.compactDual
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget))) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotCartan⟩ :=
      paperCarrierStack_boundaryData_does_not_force_cartanH8_le_compactDual
  refine
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro hleH8
  have hleCartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8
          (A := CartanContainmentObstructionSource))
        (MatsushimaCompactDualData.compactDual
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget)) := by
    rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
      (A := CartanContainmentObstructionSource)]
    exact hleH8
  exact hnotCartan hleCartan

/-- **R732 obstruction theorem (3/7)**: the R706 no-extra countermodel
therefore blocks deriving the full R731 two-containment contract from
paper-facing carriers plus boundary data. -/
theorem paperCarrierStack_boundaryData_does_not_force_R731Contract_by_noExtra :
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
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract
          BoundaryNoExtraObstructionSource
          BoundaryNoExtraObstructionTarget) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotLe⟩ :=
      paperCarrierStack_boundaryData_does_not_force_compactDual_le_H8
  refine
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro O
  exact hnotLe O.compactDual_le_H8

/-- **R732 obstruction theorem (4/7)**: the R664 generator countermodel gives
a second direct block: the same carrier stack plus boundary data also cannot
derive the full R731 contract by forcing `H8 <= compactDual`. -/
theorem paperCarrierStack_boundaryData_does_not_force_R731Contract_by_generator :
    Nonempty (GKCohomologyData CartanContainmentObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing CartanContainmentObstructionSource) /\
      Nonempty (BorelBottWeilData CartanContainmentObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII CartanContainmentObstructionSource) /\
      Nonempty (CompactDualH44Bigrading CartanContainmentObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance CartanContainmentObstructionTarget) /\
      Nonempty (FreudenthalRealization CartanContainmentObstructionTarget) /\
      MatsushimaV56BoundaryData
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget /\
      Not
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract
          CartanContainmentObstructionSource
          CartanContainmentObstructionTarget) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotLe⟩ :=
      paperCarrierStack_boundaryData_does_not_force_H8_le_compactDual
  refine
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro O
  exact hnotLe O.H8_le_compactDual

/-- **R732 obstruction theorem (5/7)**: in the current R731 spelling, the
paper-facing carrier stack does not close either compact-dual containment
direction. -/
theorem paperCarrierStack_does_not_close_current_two_containment_route :
    (Not
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract
          BoundaryNoExtraObstructionSource
          BoundaryNoExtraObstructionTarget)) /\
      (Not
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract
          CartanContainmentObstructionSource
          CartanContainmentObstructionTarget)) :=
  ⟨paperCarrierStack_boundaryData_does_not_force_R731Contract_by_noExtra.2.2.2.2.2.2.2.2,
    paperCarrierStack_boundaryData_does_not_force_R731Contract_by_generator.2.2.2.2.2.2.2.2⟩

/-- R732 target names for route summaries. -/
def currentR732CurrentTwoContainmentIndependenceTargetNames : List String := [
  "prove compactDual <= H8 by genuine EVII compact-dual comparison geometry",
  "prove H8 <= compactDual by genuine EVII generator-placement geometry",
  "do not derive either containment from GK/Borel-Wallach/BBW/Freudenthal carriers alone"
]

/-- Machine-readable status for the R732 current-containment obstruction. -/
structure R732CurrentTwoContainmentIndependenceSnapshot where
  proofWorkObligationCount : Nat
  currentContainmentsAreCartanContainmentsViaCartanIso : Bool
  paperCarrierStackForcesCompactDualNoExtra : Bool
  paperCarrierStackForcesH8GeneratorContainment : Bool
  paperCarrierStackClosesR731Contract : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualNoExtra : Bool
  provesH8Containment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R732 status: the current R731 containments are still genuine
geometry targets; the paper-facing carrier stack proves neither one in the
abstract interface. -/
def currentR732CurrentTwoContainmentIndependenceSnapshot :
    R732CurrentTwoContainmentIndependenceSnapshot where
  proofWorkObligationCount :=
    currentR732CurrentTwoContainmentIndependenceTargetNames.length
  currentContainmentsAreCartanContainmentsViaCartanIso := true
  paperCarrierStackForcesCompactDualNoExtra := false
  paperCarrierStackForcesH8GeneratorContainment := false
  paperCarrierStackClosesR731Contract := false
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualNoExtra := false
  provesH8Containment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R732 obstruction theorem (6/7)**: kernel-checked status for the
current-containment guardrail. -/
theorem currentR732CurrentTwoContainmentIndependenceSnapshot_eq_texStatus :
    currentR732CurrentTwoContainmentIndependenceSnapshot =
      ({ proofWorkObligationCount := 3
         currentContainmentsAreCartanContainmentsViaCartanIso := true
         paperCarrierStackForcesCompactDualNoExtra := false
         paperCarrierStackForcesH8GeneratorContainment := false
         paperCarrierStackClosesR731Contract := false
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualNoExtra := false
         provesH8Containment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R732CurrentTwoContainmentIndependenceSnapshot) := by
  decide

/-- **R732 obstruction theorem (7/7)**: kernel-checked target names for the
current-containment guardrail. -/
theorem currentR732CurrentTwoContainmentIndependenceTargetNames_eq_texStatus :
    currentR732CurrentTwoContainmentIndependenceTargetNames = [
      "prove compactDual <= H8 by genuine EVII compact-dual comparison geometry",
      "prove H8 <= compactDual by genuine EVII generator-placement geometry",
      "do not derive either containment from GK/Borel-Wallach/BBW/Freudenthal carriers alone"
    ] := by
  rfl

def R732_substantiveTheoremCount : Nat := 7

end FrontC167_H8ResidualCurrentTwoContainmentIndependence
end HCGapL4
end HodgeReduction
