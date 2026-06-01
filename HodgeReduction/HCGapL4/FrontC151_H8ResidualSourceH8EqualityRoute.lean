/-
# HC Gap L4 -- Front C151: source-H8 equality route (R716).

R715 reduces the preferred source route to boundary data plus the two
source-H8 containments

  H8 <= source_invariants
  source_invariants <= H8.

This file names the same source-side work as the single geometric equality

  source_invariants = H8.

It is not a closure claim and it does not prove the equality from the current
abstract interface.  It only prevents future rounds from treating the two
containments as independent gaps when they are exactly one source-carrier
theorem.
-/

import HodgeReduction.HCGapL4.FrontC150_H8ResidualSourceTwoSidedContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC151_H8ResidualSourceH8EqualityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC150_H8ResidualSourceTwoSidedContainmentRoute

section SourceH8Equality

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

/-- **R716 substantive theorem (1/7)**: the source-H8 equality is exactly the
two R715 source-H8 containments. -/
theorem source_invariants_eq_H8_iff_twoSided_containments :
    MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A) <->
      LE.le (CompactDualData.H8 (A := A))
          (MatsushimaData.source_invariants (A := A) (B := B)) ∧
        LE.le (MatsushimaData.source_invariants (A := A) (B := B))
          (CompactDualData.H8 (A := A)) := by
  apply Iff.intro
  · intro hsource
    constructor
    · rw [hsource]
    · rw [hsource]
  · intro hcontain
    exact le_antisymm hcontain.2 hcontain.1

/-- Boundary data plus the exact source-H8 equality.  R716 proves this is the
same residual route as R715's boundary plus two-sided source containment. -/
structure EVIIH8ResidualBoundaryDataSourceH8EqualityContract
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
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)

/-- **R716 substantive theorem (2/7)**: R715 two-sided containment recovers
the source-H8 equality contract. -/
def sourceH8EqualityContract_of_twoSidedH8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B where
  boundary := O.boundary
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_twoSidedH8ContainmentContract
      (A := A) (B := B) O

/-- **R716 substantive theorem (3/7)**: the source-H8 equality contract feeds
R715's two-sided containment contract. -/
def twoSidedH8ContainmentContract_of_sourceH8EqualityContract
    (O : EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B where
  boundary := O.boundary
  h8_le_source_invariants :=
    (source_invariants_eq_H8_iff_twoSided_containments
      (A := A) (B := B)).1 O.source_invariants_eq_H8 |>.1
  source_invariants_le_H8 :=
    (source_invariants_eq_H8_iff_twoSided_containments
      (A := A) (B := B)).1 O.source_invariants_eq_H8 |>.2

/-- **R716 substantive theorem (4/7)**: the source-H8 equality contract feeds
the concrete boundary/source-H8 consumer through R715. -/
def boundaryDataSourceSurjectivityContract_of_sourceH8EqualityContract
    (O : EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :
    EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B :=
  boundaryDataSourceSurjectivityContract_of_twoSidedH8ContainmentContract
    (A := A) (B := B)
    (twoSidedH8ContainmentContract_of_sourceH8EqualityContract
      (A := A) (B := B) O)

/-- **R716 substantive theorem (5/7)**: the source-H8 equality contract feeds
the compact-dual carrier split through R715. -/
def boundaryDataCompactDualCarrierSplitContract_of_sourceH8EqualityContract
    (O : EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B :=
  boundaryDataCompactDualCarrierSplitContract_of_twoSidedH8ContainmentContract
    (A := A) (B := B)
    (twoSidedH8ContainmentContract_of_sourceH8EqualityContract
      (A := A) (B := B) O)

/-- **R716 substantive theorem (6/7)**: R715's two-sided containment contract
and the source-H8 equality contract are the same inhabited residual contract. -/
theorem residual_twoSidedH8Containment_nonempty_iff_sourceH8Equality_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantTwoSidedH8ContainmentContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceH8EqualityContract_of_twoSidedH8ContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (twoSidedH8ContainmentContract_of_sourceH8EqualityContract
            (A := A) (B := B) O)))

/-- **R716 substantive theorem (7/7)**: the concrete boundary/source-H8 route
is equivalent to boundary data plus the single source-H8 equality target. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_sourceH8Equality_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_twoSidedH8Containment_nonempty
    (A := A) (B := B)).trans
    (residual_twoSidedH8Containment_nonempty_iff_sourceH8Equality_nonempty
      (A := A) (B := B))

end SourceH8Equality

/-- R716 target names for route summaries. -/
def currentR716SourceH8EqualityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8"
]

/-- Machine-readable status for the R716 exact source-H8 route. -/
structure R716SourceH8EqualitySnapshot where
  proofWorkObligationCount : Nat
  sourceEqualityEquivalentToTwoSidedContainment : Bool
  sourceEqualityFeedsBoundarySourceH8Route : Bool
  sourceEqualityFeedsCompactDualCarrierSplit : Bool
  provesBoundaryData : Bool
  provesSourceH8Equality : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R716 status: the source side is one equality target, not two
independent containment gaps. -/
def currentR716SourceH8EqualitySnapshot :
    R716SourceH8EqualitySnapshot where
  proofWorkObligationCount := currentR716SourceH8EqualityTargetNames.length
  sourceEqualityEquivalentToTwoSidedContainment := true
  sourceEqualityFeedsBoundarySourceH8Route := true
  sourceEqualityFeedsCompactDualCarrierSplit := true
  provesBoundaryData := false
  provesSourceH8Equality := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R716 source-H8 equality route. -/
theorem currentR716SourceH8EqualitySnapshot_eq_texStatus :
    currentR716SourceH8EqualitySnapshot =
      ({ proofWorkObligationCount := 2
         sourceEqualityEquivalentToTwoSidedContainment := true
         sourceEqualityFeedsBoundarySourceH8Route := true
         sourceEqualityFeedsCompactDualCarrierSplit := true
         provesBoundaryData := false
         provesSourceH8Equality := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R716SourceH8EqualitySnapshot) := by
  decide

/-- Kernel-checked target names for the R716 route. -/
theorem currentR716SourceH8EqualityTargetNames_eq_texStatus :
    currentR716SourceH8EqualityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8"
    ] := by
  rfl

def R716_substantiveTheoremCount : Nat := 7

end FrontC151_H8ResidualSourceH8EqualityRoute
end HCGapL4
end HodgeReduction
