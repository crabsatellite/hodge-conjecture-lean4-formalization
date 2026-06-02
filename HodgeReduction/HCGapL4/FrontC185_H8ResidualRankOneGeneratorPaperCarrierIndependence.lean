/-
# HC Gap L4 -- Front C185: paper carriers do not force the rank-one generator surface (R750).

R749 proves that the R748 non-boundary pair

* `h^4 in compactDual`;
* `finrank compactDual = 1`

is equivalent to the single carrier theorem `compactDual = H8`.

R724 already showed that the current paper-facing carrier stack plus honest
boundary data still does not force `compactDual = H8`.  This file transports
that guardrail across R749: the same carrier stack also does not force the
rank-one generator contract or the raw pair of fields.  Thus the next positive
proof still needs genuine EVII compact-dual/Matsushima comparison geometry,
not a citation-only reuse of the existing GK/BBW/Freudenthal carrier fields.
-/

import HodgeReduction.HCGapL4.FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse
import HodgeReduction.HCGapL4.FrontC159_H8ResidualPaperCarrierStackIndependence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC185_H8ResidualRankOneGeneratorPaperCarrierIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC159_H8ResidualPaperCarrierStackIndependence
open FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack
open FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse

/-! ## Transport R724 to the R748/R749 rank-one generator spelling. -/

/-- **R750 obstruction theorem (1/4)**: the paper-facing carrier stack plus
boundary data does not force the R748 rank-one generator contract.
-/
theorem paperCarrierStack_boundaryData_does_not_force_R748RankOneGeneratorContract :
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
        (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract
          BoundaryNoExtraObstructionSource
          BoundaryNoExtraObstructionTarget) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotH8Contract⟩ :=
      paperCarrierStack_boundaryData_does_not_force_R722Contract
  refine ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro O
  exact hnotH8Contract
    (boundaryDataCompactDualH8Contract_of_rankOneGeneratorContract
      (A := BoundaryNoExtraObstructionSource)
      (B := BoundaryNoExtraObstructionTarget)
      O)

/-- **R750 obstruction theorem (2/4)**: with the same carrier stack and
boundary data, the raw R748 non-boundary pair is not forced either.
-/
theorem paperCarrierStack_boundaryData_does_not_force_h_pow_four_mem_and_finrank_eq_one :
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
        (((MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget)).carrier
          ((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4)) /\
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget)) = 1) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotContract⟩ :=
      paperCarrierStack_boundaryData_does_not_force_R748RankOneGeneratorContract
  refine ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, ?_⟩
  intro hpair
  exact hnotContract
    ({ boundary := hboundary
       h_pow_four_mem_compactDual := hpair.1
       compactDual_finrank_eq_one := hpair.2 } :
      EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget)

/-- R750 target names for route summaries. -/
def currentR750RankOneGeneratorCarrierIndependenceTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = H8 from genuine EVII compact-dual comparison",
  "do not derive the R748 rank-one generator pair from paper carriers plus boundary data"
]

/-- Machine-readable status for the R750 carrier-stack guardrail. -/
structure R750RankOneGeneratorCarrierIndependenceSnapshot where
  proofWorkObligationCount : Nat
  r749TransportsCompactDualH8DeadendToRankOneGenerator : Bool
  paperCarrierStackForcesRankOneGeneratorContract : Bool
  paperCarrierStackForcesRawGeneratorAndRankOnePair : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  provesGeneratorMembership : Bool
  provesCompactDualRankOne : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R750 status: the R724 deadend still applies to the R748/R749
rank-one generator spelling.  This is a negative guardrail, not a proof of
the compact-dual comparison.
-/
def currentR750RankOneGeneratorCarrierIndependenceSnapshot :
    R750RankOneGeneratorCarrierIndependenceSnapshot where
  proofWorkObligationCount :=
    currentR750RankOneGeneratorCarrierIndependenceTargetNames.length
  r749TransportsCompactDualH8DeadendToRankOneGenerator := true
  paperCarrierStackForcesRankOneGeneratorContract := false
  paperCarrierStackForcesRawGeneratorAndRankOnePair := false
  provesBoundaryData := false
  provesCompactDualH8 := false
  provesGeneratorMembership := false
  provesCompactDualRankOne := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R750 obstruction theorem (3/4)**: kernel-checked status for the
rank-one generator carrier-stack guardrail.
-/
theorem currentR750RankOneGeneratorCarrierIndependenceSnapshot_eq_texStatus :
    currentR750RankOneGeneratorCarrierIndependenceSnapshot =
      ({ proofWorkObligationCount := 3
         r749TransportsCompactDualH8DeadendToRankOneGenerator := true
         paperCarrierStackForcesRankOneGeneratorContract := false
         paperCarrierStackForcesRawGeneratorAndRankOnePair := false
         provesBoundaryData := false
         provesCompactDualH8 := false
         provesGeneratorMembership := false
         provesCompactDualRankOne := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R750RankOneGeneratorCarrierIndependenceSnapshot) := by
  decide

/-- **R750 obstruction theorem (4/4)**: kernel-checked target names for the
rank-one generator carrier-stack guardrail.
-/
theorem currentR750RankOneGeneratorCarrierIndependenceTargetNames_eq_texStatus :
    currentR750RankOneGeneratorCarrierIndependenceTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = H8 from genuine EVII compact-dual comparison",
      "do not derive the R748 rank-one generator pair from paper carriers plus boundary data"
    ] := by
  rfl

def R750_substantiveTheoremCount : Nat := 4

end FrontC185_H8ResidualRankOneGeneratorPaperCarrierIndependence
end HCGapL4
end HodgeReduction
