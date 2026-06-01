/-
# HC Gap L4 -- Front C153: compact-dual-H8 finite-rank attack route (R718).

R717 makes the latest source-H8 route equivalent to the compact-dual carrier
theorem

  compactDual = H8.

R707/R708 already identified the sharp finite-rank attack surface for this
carrier theorem: prove compact-dual finite-dimensionality, prove
`finrank compactDual <= 1`, and prove `h^4 in compactDual`.  This file connects
that finite-rank route directly to the latest R717 contract, so future agents
can attack the current route through explicit EVII geometry inputs rather than
through another renamed equality.

No finite-rank, generator-membership, boundary-data, or closure theorem is
proved here.
-/

import HodgeReduction.HCGapL4.FrontC152_H8ResidualSourceEqualityCompactDualRoute
import HodgeReduction.HCGapL4.FrontC143_H8ResidualCompactDualRankBoundSharpness

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC153_H8ResidualCompactDualFiniteRankAttackRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC143_H8ResidualCompactDualRankBoundSharpness
open FrontC151_H8ResidualSourceH8EqualityRoute
open FrontC152_H8ResidualSourceEqualityCompactDualRoute

section CompactDualFiniteRankAttack

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

/-- **R718 substantive theorem (1/6)**: a compact-dual finite-rank carrier
contract proves the compact-dual-H8 equality by the sharp R708 criterion. -/
theorem compactDual_eq_H8_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  haveI :
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    O.compactDual_finite
  exact
    (compactDual_eq_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
      (A := A) (B := B) O.h_pow_four_mem_compactDual).2
      O.compactDual_finrank_le_one

/-- **R718 substantive theorem (2/6)**: the finite-rank carrier contract
feeds the R717 boundary/compact-dual-H8 contract. -/
def boundaryDataCompactDualH8Contract_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_finiteRankCarrierContract (A := A) (B := B) O

/-- **R718 substantive theorem (3/6)**: the finite-rank carrier contract
also rebuilds the latest R716/R717 boundary/source-H8 equality contract. -/
def sourceH8EqualityContract_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B :=
  sourceH8EqualityContract_of_boundaryDataCompactDualH8Contract
    (A := A) (B := B)
    (boundaryDataCompactDualH8Contract_of_finiteRankCarrierContract
      (A := A) (B := B) O)

/-- **R718 substantive theorem (4/6)**: conversely, the latest source-H8
equality contract recovers the finite-rank attack contract, because R717 gives
`compactDual = H8`, R705 splits that equality, and R707 extracts finite rank
from the no-extra containment. -/
def finiteRankCarrierContract_of_sourceH8EqualityContract
    (O : EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B :=
  finiteRankCarrierContract_of_boundaryDataCompactDualCarrierSplitContract
    (A := A) (B := B)
    (boundaryDataCompactDualCarrierSplitContract_of_boundaryDataCompactDualH8Contract
      (A := A) (B := B)
      (boundaryDataCompactDualH8Contract_of_sourceH8EqualityContract
        (A := A) (B := B) O))

/-- **R718 substantive theorem (5/6)**: the current R717 source-H8 equality
route and the compact-dual finite-rank attack route are the same inhabited
residual contract. -/
theorem residual_sourceH8Equality_nonempty_iff_compactDualFiniteRank_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteRankCarrierContract_of_sourceH8EqualityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceH8EqualityContract_of_finiteRankCarrierContract
            (A := A) (B := B) O)))

/-- **R718 substantive theorem (6/6)**: the concrete boundary/source-H8
surjectivity route can be attacked through compact-dual finite rank plus the
same generator-membership target. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_compactDualFiniteRank_nonempty :
    Nonempty (FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute.EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_sourceH8Equality_nonempty
    (A := A) (B := B)).trans
    (residual_sourceH8Equality_nonempty_iff_compactDualFiniteRank_nonempty
      (A := A) (B := B))

end CompactDualFiniteRankAttack

/-- R718 target names for route summaries. -/
def currentR718CompactDualFiniteRankAttackTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in compactDual",
  "prove finite-dimensional compactDual",
  "prove finrank compactDual <= 1"
]

/-- Machine-readable status for the R718 finite-rank attack route. -/
structure R718CompactDualFiniteRankAttackSnapshot where
  proofWorkObligationCount : Nat
  finiteRankContractProvesCompactDualH8 : Bool
  finiteRankContractFeedsSourceH8Route : Bool
  sourceH8RouteEquivalentToFiniteRankContract : Bool
  provesBoundaryData : Bool
  provesCompactDualGeneratorMembership : Bool
  provesCompactDualFiniteDimensionality : Bool
  provesCompactDualRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R718 status: the latest R717 route is connected to the sharp
compact-dual finite-rank attack surface. -/
def currentR718CompactDualFiniteRankAttackSnapshot :
    R718CompactDualFiniteRankAttackSnapshot where
  proofWorkObligationCount :=
    currentR718CompactDualFiniteRankAttackTargetNames.length
  finiteRankContractProvesCompactDualH8 := true
  finiteRankContractFeedsSourceH8Route := true
  sourceH8RouteEquivalentToFiniteRankContract := true
  provesBoundaryData := false
  provesCompactDualGeneratorMembership := false
  provesCompactDualFiniteDimensionality := false
  provesCompactDualRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R718 route. -/
theorem currentR718CompactDualFiniteRankAttackSnapshot_eq_texStatus :
    currentR718CompactDualFiniteRankAttackSnapshot =
      ({ proofWorkObligationCount := 4
         finiteRankContractProvesCompactDualH8 := true
         finiteRankContractFeedsSourceH8Route := true
         sourceH8RouteEquivalentToFiniteRankContract := true
         provesBoundaryData := false
         provesCompactDualGeneratorMembership := false
         provesCompactDualFiniteDimensionality := false
         provesCompactDualRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R718CompactDualFiniteRankAttackSnapshot) := by
  decide

/-- Kernel-checked target names for the R718 route. -/
theorem currentR718CompactDualFiniteRankAttackTargetNames_eq_texStatus :
    currentR718CompactDualFiniteRankAttackTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in compactDual",
      "prove finite-dimensional compactDual",
      "prove finrank compactDual <= 1"
    ] := by
  rfl

def R718_substantiveTheoremCount : Nat := 6

end FrontC153_H8ResidualCompactDualFiniteRankAttackRoute
end HCGapL4
end HodgeReduction
