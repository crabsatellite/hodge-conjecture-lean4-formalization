/-
# HC Gap L4 -- Front C174: current route as boundary plus target line (R739).

R738 collapses the quotient field and restores the current L4 residual to two
targets:

* `MatsushimaV56BoundaryData`;
* `source_invariants = H8`.

R674 already proves that, once boundary data is fixed, `source_invariants = H8`
is equivalent to the target-invariant line equality

  `target_invariants = span {j_q(h^4)}`.

This file reconnects that older equivalence to the latest R738 route.  The
preferred non-boundary target can now be attacked as a target-invariant line
calculation, while source-H8 and quotient vanishing remain derived consumers.
No boundary data, target-line theorem, source-H8 theorem, quotient theorem, or
full-HC closure is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC173_H8ResidualSourceH8QuotientCollapse
import HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC174_H8ResidualBoundaryTargetLineCurrentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
open FrontC172_H8ResidualSourceH8QuotientMinimalRoute
open FrontC173_H8ResidualSourceH8QuotientCollapse

section BoundaryTargetLineCurrentRoute

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

/-- **R739 substantive theorem (1/6)**: the latest R738
boundary/source-H8 route can be restated as boundary data plus the
target-invariant line theorem. -/
def boundaryDataTargetLineContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualBoundaryDataTargetLineContract A B where
  boundary := O.boundary
  target_invariants_eq_h_pow_four_line :=
    (source_H8_iff_targetLine_of_boundaryData
      (A := A) (B := B) O.boundary).1 O.source_invariants_eq_H8

/-- **R739 substantive theorem (2/6)**: conversely, boundary data plus the
target-line theorem recovers the R738 boundary/source-H8 route, so the
target-line spelling is not a stronger premise.
-/
def boundaryDataSourceH8Contract_of_boundaryDataTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B where
  boundary := O.boundary
  source_invariants_eq_H8 :=
    (source_H8_iff_targetLine_of_boundaryData
      (A := A) (B := B) O.boundary).2 O.target_invariants_eq_h_pow_four_line

/-- **R739 substantive theorem (3/6)**: the R738 source-H8 quotient contract
and the boundary/target-line contract are equivalent inhabited residuals.
Source-H8 and quotient vanishing are consumers of the target-line route, not
separate current proof obligations.
-/
theorem residual_sourceH8Quotient_nonempty_iff_boundaryDataTargetLine_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) :=
  (residual_sourceH8Quotient_nonempty_iff_boundaryDataSourceH8_nonempty
    (A := A) (B := B)).trans
    (Iff.intro
      (fun h =>
        h.elim (fun O =>
          Nonempty.intro
            (boundaryDataTargetLineContract_of_boundaryDataSourceH8Contract
              (A := A) (B := B) O)))
      (fun h =>
        h.elim (fun O =>
          Nonempty.intro
            (boundaryDataSourceH8Contract_of_boundaryDataTargetLineContract
              (A := A) (B := B) O))))

/-- **R739 substantive theorem (4/6)**: the current generator-geometry
residual is equivalently boundary data plus the target-invariant line theorem.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_boundaryDataTargetLine_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataSourceH8_viaQuotient
    (A := A) (B := B)).trans
    (Iff.intro
      (fun h =>
        h.elim (fun O =>
          Nonempty.intro
            (boundaryDataTargetLineContract_of_boundaryDataSourceH8Contract
              (A := A) (B := B) O)))
      (fun h =>
        h.elim (fun O =>
          Nonempty.intro
            (boundaryDataSourceH8Contract_of_boundaryDataTargetLineContract
              (A := A) (B := B) O))))

/-- **R739 substantive theorem (5/6)**: the boundary/target-line route feeds
the R737 quotient contract directly by deriving source-H8 first and then using
R738 to derive quotient vanishing.
-/
def sourceH8QuotientContract_of_boundaryDataTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B :=
  sourceH8QuotientContract_of_boundaryDataSourceH8Contract
    (A := A) (B := B)
    (boundaryDataSourceH8Contract_of_boundaryDataTargetLineContract
      (A := A) (B := B) O)

/-- **R739 substantive theorem (6/6)**: the same boundary/target-line route
feeds the older R669 line-equality contract, with exact image and source-H8
derived from boundary data plus the line theorem.
-/
def targetInvariantLineEqualityContract_of_currentBoundaryTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B :=
  targetInvariantLineEqualityContract_of_boundaryDataTargetLineContract
    (A := A) (B := B) O

end BoundaryTargetLineCurrentRoute

/-- R739 target names for route summaries. -/
def currentR739BoundaryTargetLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove target_invariants = span {j_q(h^4)}; source-H8 and quotient vanishing are derived consumers"
]

/-- Machine-readable status for the R739 boundary/target-line route. -/
structure R739BoundaryTargetLineSnapshot where
  proofWorkObligationCount : Nat
  boundarySourceH8EquivalentToBoundaryTargetLine : Bool
  currentRouteEquivalentToBoundaryTargetLine : Bool
  sourceH8QuotientEquivalentToBoundaryTargetLine : Bool
  boundaryTargetLineFeedsQuotientContract : Bool
  boundaryTargetLineFeedsLineEqualityContract : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesTargetLine : Bool
  provesSourceH8 : Bool
  provesUnconditionalQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R739 status: the non-boundary target is now a target-invariant
line calculation under boundary data.  This is equivalent to the R738
source-H8 route and does not prove either remaining target.
-/
def currentR739BoundaryTargetLineSnapshot :
    R739BoundaryTargetLineSnapshot where
  proofWorkObligationCount := currentR739BoundaryTargetLineTargetNames.length
  boundarySourceH8EquivalentToBoundaryTargetLine := true
  currentRouteEquivalentToBoundaryTargetLine := true
  sourceH8QuotientEquivalentToBoundaryTargetLine := true
  boundaryTargetLineFeedsQuotientContract := true
  boundaryTargetLineFeedsLineEqualityContract := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesTargetLine := false
  provesSourceH8 := false
  provesUnconditionalQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R739 target-line route. -/
theorem currentR739BoundaryTargetLineSnapshot_eq_texStatus :
    currentR739BoundaryTargetLineSnapshot =
      ({ proofWorkObligationCount := 2
         boundarySourceH8EquivalentToBoundaryTargetLine := true
         currentRouteEquivalentToBoundaryTargetLine := true
         sourceH8QuotientEquivalentToBoundaryTargetLine := true
         boundaryTargetLineFeedsQuotientContract := true
         boundaryTargetLineFeedsLineEqualityContract := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesTargetLine := false
         provesSourceH8 := false
         provesUnconditionalQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R739BoundaryTargetLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R739 route. -/
theorem currentR739BoundaryTargetLineTargetNames_eq_texStatus :
    currentR739BoundaryTargetLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove target_invariants = span {j_q(h^4)}; source-H8 and quotient vanishing are derived consumers"
    ] := by
  rfl

def R739_substantiveTheoremCount : Nat := 6

end FrontC174_H8ResidualBoundaryTargetLineCurrentRoute
end HCGapL4
end HodgeReduction
