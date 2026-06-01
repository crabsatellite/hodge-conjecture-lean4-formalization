/-
# HC Gap L4 -- Front C146: source finite-rank route feeds the carrier split (R711).

R709 introduced the source-invariant finite-rank contract, and R710 proved
that under source finite-dimensionality and source generator membership the
source no-extra/equality target is exactly the source rank-one bound.

This file reconnects that source-native route to the older main-chain route:

* the source finite-rank contract proves `source_invariants = H8`;
* under boundary data, it feeds the R704 boundary/source-H8 route;
* it is equivalent, at the inhabited residual-contract level, to the R705
  boundary compact-dual carrier split.

No new geometry is asserted.  The result prevents the finite-rank spelling from
drifting as an apparently separate branch.
-/

import HodgeReduction.HCGapL4.FrontC145_H8ResidualSourceInvariantRankBoundSharpness

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC146_H8ResidualSourceFiniteRankToCarrierSplit

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC139_H8ResidualBoundarySourceCompactDualEquivalence
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute
open FrontC145_H8ResidualSourceInvariantRankBoundSharpness

section SourceFiniteRankToCarrierSplit

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

/-- **R711 substantive theorem (1/7)**: the source finite-rank contract proves
the source-H8 equality. -/
theorem source_invariants_eq_H8_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  haveI : FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B)) :=
    O.source_invariants_finite
  exact
    (source_invariants_eq_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
      (A := A) (B := B) O.h_pow_four_mem_source_invariants).2
      O.source_invariants_finrank_le_one

/-- **R711 substantive theorem (2/7)**: the same source finite-rank contract
proves the compact-dual-H8 equality, by `compactDual = source_invariants`. -/
theorem compactDual_eq_H8_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  simpa [MatsushimaCompactDualData.compactDual_eq_source_invariants
      (A := A) (B := B)] using
    source_invariants_eq_H8_of_sourceInvariantFiniteRankCarrierContract
      (A := A) (B := B) O

/-- **R711 substantive theorem (3/7)**: source finite-rank data feeds the
R704 boundary/compactDual-H8 contract directly. -/
def boundaryDataCompactDualH8Contract_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_sourceInvariantFiniteRankCarrierContract
      (A := A) (B := B) O

/-- **R711 substantive theorem (4/7)**: source finite-rank data feeds the
R704 boundary/source-H8 route directly. -/
def boundaryDataSourceSurjectivityContract_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B :=
  boundaryDataSourceSurjectivityContract_of_boundaryDataCompactDualH8Contract
    (A := A) (B := B)
    (boundaryDataCompactDualH8Contract_of_sourceInvariantFiniteRankCarrierContract
      (A := A) (B := B) O)

/-- **R711 substantive theorem (5/7)**: the source finite-rank contract feeds
the R705 boundary compact-dual carrier split contract. -/
def boundaryDataCompactDualCarrierSplitContract_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B :=
  boundaryDataCompactDualCarrierSplitContract_of_finiteRankCarrierContract
    (A := A) (B := B)
    (finiteRankCarrierContract_of_sourceInvariantFiniteRankCarrierContract
      (A := A) (B := B) O)

/-- **R711 substantive theorem (6/7)**: the R705 boundary compact-dual carrier
split contract recovers the source finite-rank contract. -/
def sourceInvariantFiniteRankCarrierContract_of_boundaryDataCompactDualCarrierSplitContract
    (O : EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B :=
  sourceInvariantFiniteRankCarrierContract_of_finiteRankCarrierContract
    (A := A) (B := B)
    (finiteRankCarrierContract_of_boundaryDataCompactDualCarrierSplitContract
      (A := A) (B := B) O)

/-- **R711 substantive theorem (7/7)**: the R705 carrier split route and the
R709/R710 source finite-rank route are the same inhabited residual contract. -/
theorem residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_sourceInvariantFiniteRankCarrier_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :=
  (residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_finiteRankCarrier_nonempty
    (A := A) (B := B)).trans
    (residual_finiteRankCarrier_nonempty_iff_sourceInvariantFiniteRankCarrier_nonempty
      (A := A) (B := B))

end SourceFiniteRankToCarrierSplit

/-- R711 target names for route summaries. -/
def currentR711SourceFiniteRankToCarrierSplitTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in source_invariants",
  "prove finite-dimensional source_invariants",
  "prove finrank source_invariants <= 1"
]

/-- Machine-readable status for the R711 source finite-rank route bridge. -/
structure R711SourceFiniteRankToCarrierSplitSnapshot where
  proofWorkObligationCount : Nat
  sourceFiniteRankProvesSourceH8 : Bool
  sourceFiniteRankFeedsBoundarySourceH8Route : Bool
  sourceFiniteRankEquivalentToR705CarrierSplit : Bool
  provesBoundaryData : Bool
  provesSourceGeneratorMembership : Bool
  provesSourceInvariantFiniteDimensionality : Bool
  provesSourceInvariantRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R711 status: the source finite-rank route is connected back to the
older carrier-split route, but the four source-side proof obligations remain
open. -/
def currentR711SourceFiniteRankToCarrierSplitSnapshot :
    R711SourceFiniteRankToCarrierSplitSnapshot where
  proofWorkObligationCount :=
    currentR711SourceFiniteRankToCarrierSplitTargetNames.length
  sourceFiniteRankProvesSourceH8 := true
  sourceFiniteRankFeedsBoundarySourceH8Route := true
  sourceFiniteRankEquivalentToR705CarrierSplit := true
  provesBoundaryData := false
  provesSourceGeneratorMembership := false
  provesSourceInvariantFiniteDimensionality := false
  provesSourceInvariantRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R711 source finite-rank route bridge. -/
theorem currentR711SourceFiniteRankToCarrierSplitSnapshot_eq_texStatus :
    currentR711SourceFiniteRankToCarrierSplitSnapshot =
      ({ proofWorkObligationCount := 4
         sourceFiniteRankProvesSourceH8 := true
         sourceFiniteRankFeedsBoundarySourceH8Route := true
         sourceFiniteRankEquivalentToR705CarrierSplit := true
         provesBoundaryData := false
         provesSourceGeneratorMembership := false
         provesSourceInvariantFiniteDimensionality := false
         provesSourceInvariantRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R711SourceFiniteRankToCarrierSplitSnapshot) := by
  decide

/-- Kernel-checked target names for the R711 route. -/
theorem currentR711SourceFiniteRankToCarrierSplitTargetNames_eq_texStatus :
    currentR711SourceFiniteRankToCarrierSplitTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in source_invariants",
      "prove finite-dimensional source_invariants",
      "prove finrank source_invariants <= 1"
    ] := by
  rfl

def R711_substantiveTheoremCount : Nat := 7

end FrontC146_H8ResidualSourceFiniteRankToCarrierSplit
end HCGapL4
end HodgeReduction
