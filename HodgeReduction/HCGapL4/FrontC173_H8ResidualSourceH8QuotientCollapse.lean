/-
# HC Gap L4 -- Front C173: quotient field collapses under boundary/source-H8 (R738).

R737 made the quotient route explicit as boundary data, `source_invariants = H8`,
and `targetInvariantExcessQuotient = bot`.  Reading that route against the
earlier R728/R729 normalization shows that the quotient field is not a third
independent target: R729 proves that boundary data plus source-H8 gives the
generator-line containment, and R658 proves that the same line containment is
equivalent to quotient vanishing once source-H8 is fixed.

This file records that collapse directly.  The preferred current L4 residual is
again the two-target R728 route:

* `MatsushimaV56BoundaryData`;
* `source_invariants = H8`.

No boundary theorem, source-H8 theorem, quotient-vanishing theorem, finite
multiplicity theorem, or full-HC closure is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC172_H8ResidualSourceH8QuotientMinimalRoute
import HodgeReduction.HCGapL4.FrontC164_H8ResidualCurrentGeneratorLineRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC173_H8ResidualSourceH8QuotientCollapse

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC94_H8ResidualQuotientLineContainmentEquivalence
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC164_H8ResidualCurrentGeneratorLineRoute
open FrontC172_H8ResidualSourceH8QuotientMinimalRoute

section SourceH8QuotientCollapse

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

/-- **R738 substantive theorem (1/6)**: boundary data plus source-H8 already
forces the R737 quotient-vanishing field.  The proof consumes the older R729
line-containment theorem and the R658 quotient/line equivalence.
-/
theorem targetInvariantExcessQuotient_eq_bot_of_boundaryData_sourceH8
    (D : MatsushimaV56BoundaryData A B)
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ := by
  have hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    trivialModulePart_le_h_pow_four_line_of_boundaryData_source_invariants_eq_H8
      (A := A) (B := B) D hsource
  exact
    (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B) hsource).2 hline

/-- **R738 substantive theorem (2/6)**: the R728 two-target
boundary/source-H8 route rebuilds the R737 quotient contract; the quotient
field is derived, not assumed.
-/
def sourceH8QuotientContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B where
  boundary := O.boundary
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    targetInvariantExcessQuotient_eq_bot_of_boundaryData_sourceH8
      (A := A) (B := B) O.boundary O.source_invariants_eq_H8

/-- **R738 substantive theorem (3/6)**: the R737 quotient contract forgets
back to the R728 two-target route.  This proves the collapse is not a
stronger replacement.
-/
def boundaryDataSourceH8Contract_of_sourceH8QuotientContract
    (O : EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B where
  boundary := O.boundary
  source_invariants_eq_H8 := O.source_invariants_eq_H8

/-- **R738 substantive theorem (4/6)**: the R737 source-H8 quotient route
and the R728 boundary/source-H8 route are the same inhabited residual
contract.  Hence quotient vanishing should not be counted as a separate
current proof obligation once boundary data and source-H8 are selected.
-/
theorem residual_sourceH8Quotient_nonempty_iff_boundaryDataSourceH8_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceH8Contract_of_sourceH8QuotientContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceH8QuotientContract_of_boundaryDataSourceH8Contract
            (A := A) (B := B) O)))

/-- **R738 substantive theorem (5/6)**: through the R737 quotient spelling,
the current generator-geometry residual is still exactly the R728 two-target
boundary/source-H8 route.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_boundaryDataSourceH8_viaQuotient :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_sourceH8Quotient_nonempty
    (A := A) (B := B)).trans
    (residual_sourceH8Quotient_nonempty_iff_boundaryDataSourceH8_nonempty
      (A := A) (B := B))

/-- **R738 substantive theorem (6/6)**: the two-target route feeds the older
R641 quotient contract directly, including exact image from boundary data and
quotient vanishing from the R729/R658 line bridge.
-/
def targetInvariantExcessQuotientContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImage_of_boundaryData
      (A := A) (B := B) O.boundary
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    targetInvariantExcessQuotient_eq_bot_of_boundaryData_sourceH8
      (A := A) (B := B) O.boundary O.source_invariants_eq_H8

end SourceH8QuotientCollapse

/-- R738 target names for route summaries. -/
def currentR738SourceH8QuotientCollapseTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8; quotient vanishing is derived from boundary data plus source-H8"
]

/-- Machine-readable status for the R738 collapse of the R737 quotient field. -/
structure R738SourceH8QuotientCollapseSnapshot where
  proofWorkObligationCount : Nat
  boundarySourceH8ForcesQuotientVanishing : Bool
  sourceH8QuotientEquivalentToBoundarySourceH8 : Bool
  currentRouteEquivalentToBoundarySourceH8ViaQuotient : Bool
  feedsOldR641QuotientContract : Bool
  removesRedundantQuotientField : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesSourceH8 : Bool
  provesUnconditionalQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R738 status: the R737 quotient field is a consequence of
boundary data plus source-H8, so the live residual reverts to the R728
two-target route.  Neither of those two targets is proved here.
-/
def currentR738SourceH8QuotientCollapseSnapshot :
    R738SourceH8QuotientCollapseSnapshot where
  proofWorkObligationCount := currentR738SourceH8QuotientCollapseTargetNames.length
  boundarySourceH8ForcesQuotientVanishing := true
  sourceH8QuotientEquivalentToBoundarySourceH8 := true
  currentRouteEquivalentToBoundarySourceH8ViaQuotient := true
  feedsOldR641QuotientContract := true
  removesRedundantQuotientField := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesSourceH8 := false
  provesUnconditionalQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R738 quotient-field collapse. -/
theorem currentR738SourceH8QuotientCollapseSnapshot_eq_texStatus :
    currentR738SourceH8QuotientCollapseSnapshot =
      ({ proofWorkObligationCount := 2
         boundarySourceH8ForcesQuotientVanishing := true
         sourceH8QuotientEquivalentToBoundarySourceH8 := true
         currentRouteEquivalentToBoundarySourceH8ViaQuotient := true
         feedsOldR641QuotientContract := true
         removesRedundantQuotientField := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesSourceH8 := false
         provesUnconditionalQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R738SourceH8QuotientCollapseSnapshot) := by
  decide

/-- Kernel-checked target names for the R738 route. -/
theorem currentR738SourceH8QuotientCollapseTargetNames_eq_texStatus :
    currentR738SourceH8QuotientCollapseTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8; quotient vanishing is derived from boundary data plus source-H8"
    ] := by
  rfl

def R738_substantiveTheoremCount : Nat := 6

end FrontC173_H8ResidualSourceH8QuotientCollapse
end HCGapL4
end HodgeReduction
