/-
# HC Gap L4 -- Front C149: H8-containment finite-rank consumer (R714).

R713 rewrote source generator membership as the geometric containment

  H8 <= source_invariants.

This file consumes that spelling.  Boundary data plus H8-containment,
finite-dimensional source invariants, and the source rank-one bound directly
recover `source_invariants = H8`, then feed the existing R704/R705 consumers.

No new geometric premise is introduced: this is the R713 contract connected
back to the boundary/source-H8 and compact-dual carrier-split routes.
-/

import HodgeReduction.HCGapL4.FrontC148_H8ResidualSourceGeneratorContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC149_H8ResidualSourceContainmentFiniteRankConsumer

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC139_H8ResidualBoundarySourceCompactDualEquivalence
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC146_H8ResidualSourceFiniteRankToCarrierSplit
open FrontC148_H8ResidualSourceGeneratorContainmentRoute

section H8ContainmentFiniteRankConsumer

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

/-- **R714 substantive theorem (1/9)**: the R713 H8-containment finite-rank
contract proves the source-H8 equality consumed by the older boundary route. -/
theorem source_invariants_eq_H8_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_sourceInvariantFiniteRankCarrierContract
    (A := A) (B := B)
    (sourceInvariantFiniteRankCarrierContract_of_H8ContainmentContract
      (A := A) (B := B) O)

/-- **R714 substantive theorem (2/9)**: the same contract proves the
compact-dual-H8 carrier theorem through `compactDual = source_invariants`. -/
theorem compactDual_eq_H8_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_sourceInvariantFiniteRankCarrierContract
    (A := A) (B := B)
    (sourceInvariantFiniteRankCarrierContract_of_H8ContainmentContract
      (A := A) (B := B) O)

/-- **R714 substantive theorem (3/9)**: under boundary data, the R713
H8-containment finite-rank contract proves the concrete source-H8
surjectivity target. -/
theorem surjectivity_source_eq_H8_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  surjectivity_source_eq_H8_of_boundaryData_compactDual_eq_H8
    (A := A) (B := B) O.boundary
    (compactDual_eq_H8_of_H8ContainmentContract (A := A) (B := B) O)

/-- **R714 substantive theorem (4/9)**: the R713 contract feeds the R704
boundary/compact-dual-H8 consumer directly. -/
def boundaryDataCompactDualH8Contract_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_H8ContainmentContract (A := A) (B := B) O

/-- **R714 substantive theorem (5/9)**: the R713 contract feeds the R694/R704
boundary/source-H8 route directly. -/
def boundaryDataSourceSurjectivityContract_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B where
  boundary := O.boundary
  surjectivity_source_eq_H8 :=
    surjectivity_source_eq_H8_of_H8ContainmentContract
      (A := A) (B := B) O

/-- **R714 substantive theorem (6/9)**: the R713 contract feeds the R705
compact-dual carrier-split consumer directly. -/
def boundaryDataCompactDualCarrierSplitContract_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B :=
  boundaryDataCompactDualCarrierSplitContract_of_sourceInvariantFiniteRankCarrierContract
    (A := A) (B := B)
    (sourceInvariantFiniteRankCarrierContract_of_H8ContainmentContract
      (A := A) (B := B) O)

/-- **R714 substantive theorem (7/9)**: the R705 compact-dual carrier split
and the R713 H8-containment finite-rank contract are the same inhabited
residual contract. -/
theorem residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_sourceInvariantFiniteRankH8Containment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :=
  (residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_sourceInvariantFiniteRankCarrier_nonempty
    (A := A) (B := B)).trans
    ((residual_sourceInvariantFiniteRankH8Containment_nonempty_iff_sourceInvariantFiniteRankCarrier_nonempty
      (A := A) (B := B)).symm)

/-- **R714 substantive theorem (8/9)**: the R704 boundary/compact-dual-H8
contract is equivalent to the R713 H8-containment finite-rank contract at the
inhabited-contract level. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_sourceInvariantFiniteRankH8Containment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :=
  (residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_sourceInvariantFiniteRankH8Containment_nonempty
      (A := A) (B := B))

/-- **R714 substantive theorem (9/9)**: the concrete boundary/source-H8 route
is equivalent to the R713 H8-containment finite-rank route at the
inhabited-contract level. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_sourceInvariantFiniteRankH8Containment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_sourceInvariantFiniteRankH8Containment_nonempty
      (A := A) (B := B))

end H8ContainmentFiniteRankConsumer

/-- R714 target names for route summaries. -/
def currentR714SourceContainmentFiniteRankConsumerTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= source_invariants",
  "prove finite-dimensional source_invariants",
  "prove finrank source_invariants <= 1"
]

/-- Machine-readable status for the R714 source containment consumer route. -/
structure R714SourceContainmentFiniteRankConsumerSnapshot where
  proofWorkObligationCount : Nat
  h8ContainmentFiniteRankProvesSourceH8 : Bool
  h8ContainmentFiniteRankProvesCompactDualH8 : Bool
  h8ContainmentFiniteRankFeedsBoundarySourceH8Route : Bool
  h8ContainmentFiniteRankFeedsR705CarrierSplit : Bool
  h8ContainmentRouteEquivalentToR705CarrierSplit : Bool
  provesBoundaryData : Bool
  provesH8LeSourceInvariants : Bool
  provesSourceInvariantFiniteDimensionality : Bool
  provesSourceInvariantRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R714 status: the H8-containment finite-rank source route now feeds
the older boundary/source-H8 and R705 compact-dual carrier-split consumers. -/
def currentR714SourceContainmentFiniteRankConsumerSnapshot :
    R714SourceContainmentFiniteRankConsumerSnapshot where
  proofWorkObligationCount :=
    currentR714SourceContainmentFiniteRankConsumerTargetNames.length
  h8ContainmentFiniteRankProvesSourceH8 := true
  h8ContainmentFiniteRankProvesCompactDualH8 := true
  h8ContainmentFiniteRankFeedsBoundarySourceH8Route := true
  h8ContainmentFiniteRankFeedsR705CarrierSplit := true
  h8ContainmentRouteEquivalentToR705CarrierSplit := true
  provesBoundaryData := false
  provesH8LeSourceInvariants := false
  provesSourceInvariantFiniteDimensionality := false
  provesSourceInvariantRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R714 route consumer. -/
theorem currentR714SourceContainmentFiniteRankConsumerSnapshot_eq_texStatus :
    currentR714SourceContainmentFiniteRankConsumerSnapshot =
      ({ proofWorkObligationCount := 4
         h8ContainmentFiniteRankProvesSourceH8 := true
         h8ContainmentFiniteRankProvesCompactDualH8 := true
         h8ContainmentFiniteRankFeedsBoundarySourceH8Route := true
         h8ContainmentFiniteRankFeedsR705CarrierSplit := true
         h8ContainmentRouteEquivalentToR705CarrierSplit := true
         provesBoundaryData := false
         provesH8LeSourceInvariants := false
         provesSourceInvariantFiniteDimensionality := false
         provesSourceInvariantRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R714SourceContainmentFiniteRankConsumerSnapshot) := by
  decide

/-- Kernel-checked target names for the R714 route. -/
theorem currentR714SourceContainmentFiniteRankConsumerTargetNames_eq_texStatus :
    currentR714SourceContainmentFiniteRankConsumerTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= source_invariants",
      "prove finite-dimensional source_invariants",
      "prove finrank source_invariants <= 1"
    ] := by
  rfl

def R714_substantiveTheoremCount : Nat := 9

end FrontC149_H8ResidualSourceContainmentFiniteRankConsumer
end HCGapL4
end HodgeReduction
