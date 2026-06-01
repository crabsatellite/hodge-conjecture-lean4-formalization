/-
# HC Gap L4 -- Front C125: source-boundary route feeds Cartan-line exactness (R689).

R688 reduced the active H8 residual route to three inputs:

* `surjectivity_source = compactDual`;
* `h^4` lies in `source_invariants`;
* finite-dimensional `finrank trivialModulePart <= 1`.

R681/R682 describe the same residual through Cartan-line exactness:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* `Submodule.map j_q CartanH8 = trivialModulePart`.

This file connects the two presentations.  Source membership of `h^4` implies
`CartanH8 <= compactDual`, and source membership plus the multiplicity upper
bound gives the target generator-line containment already used by R681.  Hence
the R688 route feeds the existing Cartan-line route without adding a new
premise or claiming closure.
-/

import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine
import HodgeReduction.HCGapL4.FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual
import HodgeReduction.HCGapL4.FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC125_H8ResidualSourceBoundaryCartanLineRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC97_H8ResidualCartanToCompactDualLine
open FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence
open FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual
open FrontC123_H8ResidualGeneratorMultiplicityRoute
open FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute

section SourceBoundaryToCartanLine

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R689 substantive theorem (1/5)**: source generator membership implies
the Cartan-to-compactDual containment target.  This is the R661 equivalence
after applying the compact-dual/source-invariants comparison. -/
theorem cartanH8_le_compactDual_of_h_pow_four_mem_source
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
  have hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    MatsushimaCompactDualData.source_invariants_le_compactDual
      (A := A) (B := B) hh_pow
  exact
    (cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).2 hh_compact

/-- **R689 substantive theorem (2/5)**: the R688 source-boundary plus
generator/multiplicity contract feeds the R681 three-target source/Cartan
contract.  The only finite-dimensional instance is the explicit multiplicity
ingredient already present in R688. -/
def sourceCompactDualCartanLineThreeTargetContract_of_sourceBoundaryGeneratorMultiplicityContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) :
    EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B where
  source_eq_compactDual := O.source_eq_compactDual
  cartanH8_le_compactDual :=
    cartanH8_le_compactDual_of_h_pow_four_mem_source
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
  trivialModulePart_le_h_pow_four_line :=
    trivialModulePart_le_matsushima_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_upper_bound

/-- **R689 substantive theorem (3/5)**: the same R688 contract gives the R682
Cartan-line exactness contract by first passing through the R681 contract. -/
def cartanLineExactnessContract_of_sourceBoundaryGeneratorMultiplicityContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) :
    EVIIH8ResidualCartanLineExactnessContract A B :=
  cartanLineExactnessContract_of_sourceCompactDualCartanLineThreeTargetContract
    (A := A) (B := B)
    (sourceCompactDualCartanLineThreeTargetContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B) O)

/-- **R689 substantive theorem (4/5)**: inhabited R688 contracts feed
inhabited R681 source/Cartan contracts. -/
theorem residual_sourceBoundaryGeneratorMultiplicity_nonempty_to_sourceCompactDualCartanLineThreeTarget_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) ->
      Nonempty (EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (sourceCompactDualCartanLineThreeTargetContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B) O)

/-- **R689 substantive theorem (5/5)**: inhabited R688 contracts also feed
inhabited R682 Cartan-line exactness contracts. -/
theorem residual_sourceBoundaryGeneratorMultiplicity_nonempty_to_cartanLineExactness_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) ->
      Nonempty (EVIIH8ResidualCartanLineExactnessContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (cartanLineExactnessContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B) O)

end SourceBoundaryToCartanLine

/-- R689 target names for route summaries. -/
def currentR689SourceBoundaryCartanLineTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove h^4 in source_invariants",
  "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R689 source-boundary to Cartan-line
route. -/
structure R689SourceBoundaryCartanLineSnapshot where
  proofWorkObligationCount : Nat
  sourceMembershipGivesCartanContainment : Bool
  generatorMultiplicityGivesCartanLineContainment : Bool
  sourceBoundaryRouteFeedsR681 : Bool
  sourceBoundaryRouteFeedsR682 : Bool
  introducesStrongerPremise : Bool
  provesSourceBoundary : Bool
  provesGeneratorMembership : Bool
  provesTrivialMultiplicityUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R689 status: the R688 route is now connected to the older R681/R682
Cartan-line route, but the same three geometric inputs remain open. -/
def currentR689SourceBoundaryCartanLineSnapshot :
    R689SourceBoundaryCartanLineSnapshot where
  proofWorkObligationCount := currentR689SourceBoundaryCartanLineTargetNames.length
  sourceMembershipGivesCartanContainment := true
  generatorMultiplicityGivesCartanLineContainment := true
  sourceBoundaryRouteFeedsR681 := true
  sourceBoundaryRouteFeedsR682 := true
  introducesStrongerPremise := false
  provesSourceBoundary := false
  provesGeneratorMembership := false
  provesTrivialMultiplicityUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R689 route ledger. -/
theorem currentR689SourceBoundaryCartanLineSnapshot_eq_texStatus :
    currentR689SourceBoundaryCartanLineSnapshot =
      ({ proofWorkObligationCount := 3
         sourceMembershipGivesCartanContainment := true
         generatorMultiplicityGivesCartanLineContainment := true
         sourceBoundaryRouteFeedsR681 := true
         sourceBoundaryRouteFeedsR682 := true
         introducesStrongerPremise := false
         provesSourceBoundary := false
         provesGeneratorMembership := false
         provesTrivialMultiplicityUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R689SourceBoundaryCartanLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R689 route. -/
theorem currentR689SourceBoundaryCartanLineTargetNames_eq_texStatus :
    currentR689SourceBoundaryCartanLineTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove h^4 in source_invariants",
      "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
    ] := by
  rfl

def R689_substantiveTheoremCount : Nat := 5

end FrontC125_H8ResidualSourceBoundaryCartanLineRoute
end HCGapL4
end HodgeReduction
