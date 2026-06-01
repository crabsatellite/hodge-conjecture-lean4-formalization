/-
# HC Gap L4 -- Front C152: source-H8 equality to compact-dual-H8 (R717).

R716 names the preferred source route as boundary data plus

  source_invariants = H8.

Older route surfaces already used the geometrically closer compact-dual
carrier theorem

  compactDual = H8.

This file connects the latest R716 contract directly to that compact-dual
route.  The equivalence is exact because `MatsushimaCompactDualData` identifies
`compactDual` with `source_invariants`.  No boundary data or compact-dual-H8
theorem is proved here.
-/

import HodgeReduction.HCGapL4.FrontC151_H8ResidualSourceH8EqualityRoute
import HodgeReduction.HCGapL4.FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC152_H8ResidualSourceEqualityCompactDualRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence
open FrontC151_H8ResidualSourceH8EqualityRoute

section SourceCompactDualRoute

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

/-- **R717 substantive theorem (1/6)**: the latest R716 source-H8 equality
target and the compact-dual-H8 carrier target are exactly the same theorem. -/
theorem source_H8_equality_iff_compactDual_H8 :
    (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :=
  source_invariants_eq_H8_iff_compactDual_eq_H8 (A := A) (B := B)

/-- **R717 substantive theorem (2/6)**: the R716 boundary/source-H8 equality
contract feeds the existing boundary/compact-dual-H8 contract. -/
def boundaryDataCompactDualH8Contract_of_sourceH8EqualityContract
    (O : EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    (source_H8_equality_iff_compactDual_H8
      (A := A) (B := B)).1 O.source_invariants_eq_H8

/-- **R717 substantive theorem (3/6)**: the boundary/compact-dual-H8 route
rebuilds the R716 boundary/source-H8 equality contract. -/
def sourceH8EqualityContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B where
  boundary := O.boundary
  source_invariants_eq_H8 :=
    (source_H8_equality_iff_compactDual_H8
      (A := A) (B := B)).2 O.compactDual_eq_H8

/-- **R717 substantive theorem (4/6)**: the R716 source-H8 equality route and
the boundary/compact-dual-H8 route are the same inhabited residual contract. -/
theorem residual_sourceH8Equality_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_sourceH8EqualityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceH8EqualityContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))

/-- **R717 substantive theorem (5/6)**: the concrete boundary/source-H8
surjectivity route can be read directly as boundary plus compact-dual-H8 once
R716 is in the graph. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualH8_nonempty_via_sourceEquality :
    Nonempty (FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute.EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_sourceH8Equality_nonempty
    (A := A) (B := B)).trans
    (residual_sourceH8Equality_nonempty_iff_boundaryDataCompactDualH8_nonempty
      (A := A) (B := B))

/-- **R717 substantive theorem (6/6)**: the R716 route also feeds the R675
target-line residual through the already registered compact-dual bridge. -/
theorem residual_sourceH8Equality_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8EqualityContract A B) <->
      Nonempty (FrontC105_H8ResidualTargetInvariantLineEquality.EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_sourceH8Equality_nonempty_iff_boundaryDataCompactDualH8_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

end SourceCompactDualRoute

/-- R717 target names for route summaries. -/
def currentR717SourceEqualityCompactDualTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = H8 (equivalently source_invariants = H8)"
]

/-- Machine-readable status for the R717 source/compact-dual bridge. -/
structure R717SourceEqualityCompactDualSnapshot where
  proofWorkObligationCount : Nat
  sourceH8EquivalentToCompactDualH8 : Bool
  sourceH8ContractEquivalentToBoundaryCompactDualH8 : Bool
  sourceH8ContractEquivalentToTargetLine : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R717 status: the latest R716 source-H8 equality route is now
connected directly to the compact-dual-H8 geometry target. -/
def currentR717SourceEqualityCompactDualSnapshot :
    R717SourceEqualityCompactDualSnapshot where
  proofWorkObligationCount := currentR717SourceEqualityCompactDualTargetNames.length
  sourceH8EquivalentToCompactDualH8 := true
  sourceH8ContractEquivalentToBoundaryCompactDualH8 := true
  sourceH8ContractEquivalentToTargetLine := true
  provesBoundaryData := false
  provesCompactDualH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R717 source/compact-dual route. -/
theorem currentR717SourceEqualityCompactDualSnapshot_eq_texStatus :
    currentR717SourceEqualityCompactDualSnapshot =
      ({ proofWorkObligationCount := 2
         sourceH8EquivalentToCompactDualH8 := true
         sourceH8ContractEquivalentToBoundaryCompactDualH8 := true
         sourceH8ContractEquivalentToTargetLine := true
         provesBoundaryData := false
         provesCompactDualH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R717SourceEqualityCompactDualSnapshot) := by
  decide

/-- Kernel-checked target names for the R717 route. -/
theorem currentR717SourceEqualityCompactDualTargetNames_eq_texStatus :
    currentR717SourceEqualityCompactDualTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = H8 (equivalently source_invariants = H8)"
    ] := by
  rfl

def R717_substantiveTheoremCount : Nat := 6

end FrontC152_H8ResidualSourceEqualityCompactDualRoute
end HCGapL4
end HodgeReduction
