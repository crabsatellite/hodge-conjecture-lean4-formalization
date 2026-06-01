/-
# HC Gap L4 -- Front C150: two-sided source-H8 containment route (R715).

R714 shows that the H8-containment finite-rank source contract feeds the
existing boundary/source-H8 and compact-dual carrier-split consumers.

This file removes bookkeeping from that source route.  Instead of proving
finite-dimensionality and a rank-one upper bound separately, it is enough to
prove the no-extra source containment

  source_invariants <= H8.

That containment implies both finite-dimensionality and `finrank <= 1` because
`H8` is the rank-one compact-dual line.  Together with the R713 containment
`H8 <= source_invariants`, it is exactly `source_invariants = H8`.
-/

import HodgeReduction.HCGapL4.FrontC149_H8ResidualSourceContainmentFiniteRankConsumer

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC150_H8ResidualSourceTwoSidedContainmentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute
open FrontC148_H8ResidualSourceGeneratorContainmentRoute
open FrontC149_H8ResidualSourceContainmentFiniteRankConsumer

section SourceTwoSidedContainment

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

/-- **R715 substantive theorem (1/10)**: no-extra containment for the
compact-dual carrier and no-extra containment for the source-invariant carrier
are the same statement, because `compactDual = source_invariants`. -/
theorem compactDual_le_H8_iff_source_invariants_le_H8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)) <->
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

/-- **R715 substantive theorem (2/10)**: the no-extra source containment
implies finite-dimensionality of the source-invariant carrier. -/
theorem source_invariants_finiteDimensional_of_source_invariants_le_H8
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B)) := by
  have hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)) :=
    (compactDual_le_H8_iff_source_invariants_le_H8
      (A := A) (B := B)).2 hsource_le_H8
  exact
    (compactDual_finiteDimensional_iff_source_invariants_finiteDimensional
      (A := A) (B := B)).1
      (compactDual_finiteDimensional_of_compactDual_le_H8
        (A := A) (B := B) hcompact_le_H8)

/-- **R715 substantive theorem (3/10)**: the no-extra source containment
implies the source rank-one upper bound. -/
theorem source_invariants_finrank_le_one_of_source_invariants_le_H8
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) <= 1 := by
  have hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)) :=
    (compactDual_le_H8_iff_source_invariants_le_H8
      (A := A) (B := B)).2 hsource_le_H8
  exact
    (compactDual_finrank_le_one_iff_source_invariants_finrank_le_one
      (A := A) (B := B)).1
      (compactDual_finrank_le_one_of_compactDual_le_H8
        (A := A) (B := B) hcompact_le_H8)

/-- Boundary data plus two-sided source-H8 containment.  R715 proves that this
is equivalent to the R714 finite-rank source contract. -/
structure EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract
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
  h8_le_source_invariants :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaData.source_invariants (A := A) (B := B))
  source_invariants_le_H8 :
    LE.le (MatsushimaData.source_invariants (A := A) (B := B))
      (CompactDualData.H8 (A := A))

/-- **R715 substantive theorem (4/10)**: two-sided containment proves the
source-H8 equality directly. -/
theorem source_invariants_eq_H8_of_twoSidedH8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  le_antisymm O.source_invariants_le_H8 O.h8_le_source_invariants

/-- **R715 substantive theorem (5/10)**: the two-sided containment contract
feeds the R714 H8-containment finite-rank contract. -/
def H8ContainmentContract_of_twoSidedH8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B where
  boundary := O.boundary
  source_invariants_finite :=
    source_invariants_finiteDimensional_of_source_invariants_le_H8
      (A := A) (B := B) O.source_invariants_le_H8
  source_invariants_finrank_le_one :=
    source_invariants_finrank_le_one_of_source_invariants_le_H8
      (A := A) (B := B) O.source_invariants_le_H8
  h8_le_source_invariants := O.h8_le_source_invariants

/-- **R715 substantive theorem (6/10)**: the R714 finite-rank contract
recovers the no-extra source containment, so the finite/rank spelling and
two-sided containment spelling are equivalent. -/
def twoSidedH8ContainmentContract_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B where
  boundary := O.boundary
  h8_le_source_invariants := O.h8_le_source_invariants
  source_invariants_le_H8 := by
    rw [source_invariants_eq_H8_of_H8ContainmentContract
      (A := A) (B := B) O]

/-- **R715 substantive theorem (7/10)**: the two-sided source containment
contract feeds the concrete boundary/source-H8 route. -/
def boundaryDataSourceSurjectivityContract_of_twoSidedH8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B :=
  boundaryDataSourceSurjectivityContract_of_H8ContainmentContract
    (A := A) (B := B)
    (H8ContainmentContract_of_twoSidedH8ContainmentContract
      (A := A) (B := B) O)

/-- **R715 substantive theorem (8/10)**: the two-sided source containment
contract feeds the R705 compact-dual carrier split. -/
def boundaryDataCompactDualCarrierSplitContract_of_twoSidedH8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B :=
  boundaryDataCompactDualCarrierSplitContract_of_H8ContainmentContract
    (A := A) (B := B)
    (H8ContainmentContract_of_twoSidedH8ContainmentContract
      (A := A) (B := B) O)

/-- **R715 substantive theorem (9/10)**: the R714 H8-containment finite-rank
contract and the two-sided source-H8 containment contract are the same
inhabited residual contract. -/
theorem residual_sourceInvariantFiniteRankH8Containment_nonempty_iff_twoSidedH8Containment_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (twoSidedH8ContainmentContract_of_H8ContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentContract_of_twoSidedH8ContainmentContract
            (A := A) (B := B) O)))

/-- **R715 substantive theorem (10/10)**: the concrete boundary/source-H8
route is equivalent to the two-sided source-containment route. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_twoSidedH8Containment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_sourceInvariantFiniteRankH8Containment_nonempty
    (A := A) (B := B)).trans
    (residual_sourceInvariantFiniteRankH8Containment_nonempty_iff_twoSidedH8Containment_nonempty
      (A := A) (B := B))

end SourceTwoSidedContainment

/-- R715 target names for route summaries. -/
def currentR715SourceTwoSidedContainmentTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= source_invariants",
  "prove source_invariants <= H8"
]

/-- Machine-readable status for the R715 source two-sided containment route. -/
structure R715SourceTwoSidedContainmentSnapshot where
  proofWorkObligationCount : Nat
  sourceNoExtraImpliesFiniteDimensionality : Bool
  sourceNoExtraImpliesRankBound : Bool
  twoSidedContainmentProvesSourceH8 : Bool
  twoSidedContainmentEquivalentToR714FiniteRankRoute : Bool
  twoSidedContainmentFeedsBoundarySourceH8Route : Bool
  provesBoundaryData : Bool
  provesH8LeSourceInvariants : Bool
  provesSourceInvariantsLeH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R715 status: finite-dimensionality and rank are now consequences
of the no-extra source containment, not separate targets on the preferred
source route. -/
def currentR715SourceTwoSidedContainmentSnapshot :
    R715SourceTwoSidedContainmentSnapshot where
  proofWorkObligationCount :=
    currentR715SourceTwoSidedContainmentTargetNames.length
  sourceNoExtraImpliesFiniteDimensionality := true
  sourceNoExtraImpliesRankBound := true
  twoSidedContainmentProvesSourceH8 := true
  twoSidedContainmentEquivalentToR714FiniteRankRoute := true
  twoSidedContainmentFeedsBoundarySourceH8Route := true
  provesBoundaryData := false
  provesH8LeSourceInvariants := false
  provesSourceInvariantsLeH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R715 route. -/
theorem currentR715SourceTwoSidedContainmentSnapshot_eq_texStatus :
    currentR715SourceTwoSidedContainmentSnapshot =
      ({ proofWorkObligationCount := 3
         sourceNoExtraImpliesFiniteDimensionality := true
         sourceNoExtraImpliesRankBound := true
         twoSidedContainmentProvesSourceH8 := true
         twoSidedContainmentEquivalentToR714FiniteRankRoute := true
         twoSidedContainmentFeedsBoundarySourceH8Route := true
         provesBoundaryData := false
         provesH8LeSourceInvariants := false
         provesSourceInvariantsLeH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R715SourceTwoSidedContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R715 route. -/
theorem currentR715SourceTwoSidedContainmentTargetNames_eq_texStatus :
    currentR715SourceTwoSidedContainmentTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= source_invariants",
      "prove source_invariants <= H8"
    ] := by
  rfl

def R715_substantiveTheoremCount : Nat := 10

end FrontC150_H8ResidualSourceTwoSidedContainmentRoute
end HCGapL4
end HodgeReduction
