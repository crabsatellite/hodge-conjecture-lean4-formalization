/-
# HC Gap L4 -- Front C127: line containment to explicit finite route (R691).

R690 made the finite-dimensional witness for `trivialModulePart` explicit, so
the current source-boundary/generator route has four visible inputs:

* `surjectivity_source = compactDual`;
* `h^4` lies in `source_invariants`;
* `trivialModulePart` is finite-dimensional;
* `finrank trivialModulePart <= 1`.

This file proves that, once the same generator membership is available, the
last two inputs are equivalent to the more geometric target

  `trivialModulePart <= span {j_q(h^4)}`.

Indeed, generator membership puts `j_q(h^4)` inside `trivialModulePart`; the
line containment then gives equality with the generated line.  That equality
supplies both the finite-dimensional witness and the finrank upper bound.  No
closure claim is introduced here: source boundary, generator membership, and
the line-containment theorem remain open EVII geometry targets.
-/

import HodgeReduction.HCGapL4.FrontC126_H8ResidualExplicitFiniteMultiplicityRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC127_H8ResidualLineContainmentExplicitFiniteRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence
open FrontC123_H8ResidualGeneratorMultiplicityRoute
open FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute
open FrontC126_H8ResidualExplicitFiniteMultiplicityRoute

section LineContainmentToExplicitFinite

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- The R691 source-boundary route with the multiplicity side written as the
explicit generator-line containment.  Under the `h^4` membership field, this
is enough to rebuild the explicit finite-multiplicity contract from R690. -/
structure EVIIH8ResidualSourceBoundaryLineContainmentContract where
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

variable {A B}

/-- **R691 substantive theorem (1/8)**: source generator membership plus
line containment identifies the trivial-module part with the generated line. -/
theorem trivialModulePart_eq_h_pow_four_line_of_h_pow_four_mem_source_lineContainment
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    CuspidalCohomologyData.trivialModulePart (A := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  apply le_antisymm
  · exact hline
  · apply Submodule.span_le.mpr
    intro beta hbeta
    rw [Set.mem_singleton_iff] at hbeta
    rw [hbeta]
    exact
      matsushima_h_pow_four_mem_trivialModulePart_of_h_pow_four_mem_source
        (A := A) (B := B) hh_pow

/-- **R691 substantive theorem (2/8)**: the line-containment route supplies
the explicit finite-dimensional witness required by R690. -/
theorem trivialModulePart_finiteDimensional_of_h_pow_four_mem_source_lineContainment
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    FiniteDimensional Rat (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  rw [
    trivialModulePart_eq_h_pow_four_line_of_h_pow_four_mem_source_lineContainment
      (A := A) (B := B) hh_pow hline]
  exact FiniteDimensional.span_of_finite Rat (Set.finite_singleton _)

/-- **R691 substantive theorem (3/8)**: the same line equality gives the
one-dimensional multiplicity upper bound required by R690. -/
theorem trivialModulePart_upper_bound_of_h_pow_four_mem_source_lineContainment
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  rw [
    trivialModulePart_eq_h_pow_four_line_of_h_pow_four_mem_source_lineContainment
      (A := A) (B := B) hh_pow hline]
  rw [finrank_span_singleton
    (matsushima_h_pow_four_image_ne_zero (A := A) (B := B))]

/-- **R691 substantive theorem (4/8)**: the line-containment route rebuilds
the explicit finite-multiplicity contract from R690. -/
def explicitFiniteMultiplicityContract_of_sourceBoundaryLineContainmentContract
    (O : EVIIH8ResidualSourceBoundaryLineContainmentContract A B) :
    EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B where
  source_eq_compactDual := O.source_eq_compactDual
  h_pow_four_mem_source_invariants := O.h_pow_four_mem_source_invariants
  trivialModulePart_finite :=
    trivialModulePart_finiteDimensional_of_h_pow_four_mem_source_lineContainment
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_le_h_pow_four_line
  trivialModulePart_upper_bound :=
    trivialModulePart_upper_bound_of_h_pow_four_mem_source_lineContainment
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_le_h_pow_four_line

/-- **R691 substantive theorem (5/8)**: after rebuilding R690, the route also
forgets to the R688 source-boundary/generator/multiplicity contract. -/
def sourceBoundaryGeneratorMultiplicityContract_of_sourceBoundaryLineContainmentContract
    (O : EVIIH8ResidualSourceBoundaryLineContainmentContract A B) :
    EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B :=
  sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
    (A := A) (B := B)
    (explicitFiniteMultiplicityContract_of_sourceBoundaryLineContainmentContract
      (A := A) (B := B) O)

/-- **R691 substantive theorem (6/8)**: the line-containment route feeds the
existing boundary-data consumer through R690. -/
def boundaryData_of_sourceBoundaryLineContainmentContract
    (O : EVIIH8ResidualSourceBoundaryLineContainmentContract A B) :
    MatsushimaV56BoundaryData A B :=
  boundaryData_of_explicitFiniteMultiplicityContract
    (A := A) (B := B)
    (explicitFiniteMultiplicityContract_of_sourceBoundaryLineContainmentContract
      (A := A) (B := B) O)

/-- **R691 substantive theorem (7/8)**: the line-containment route feeds the
R681 source/Cartan three-target contract through R690. -/
def sourceCompactDualCartanLineThreeTargetContract_of_sourceBoundaryLineContainmentContract
    (O : EVIIH8ResidualSourceBoundaryLineContainmentContract A B) :
    EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B :=
  sourceCompactDualCartanLineThreeTargetContract_of_explicitFiniteMultiplicityContract
    (A := A) (B := B)
    (explicitFiniteMultiplicityContract_of_sourceBoundaryLineContainmentContract
      (A := A) (B := B) O)

/-- **R691 substantive theorem (8/8)**: inhabited line-containment contracts
feed inhabited R690 explicit finite contracts. -/
theorem residual_sourceBoundaryLineContainment_nonempty_to_explicitFiniteMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualSourceBoundaryLineContainmentContract A B) ->
      Nonempty (EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (explicitFiniteMultiplicityContract_of_sourceBoundaryLineContainmentContract
      (A := A) (B := B) O)

end LineContainmentToExplicitFinite

/-- R691 target names for route summaries. -/
def currentR691LineContainmentExplicitFiniteTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove h^4 in source_invariants",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the line-containment-to-explicit-finite route. -/
structure R691LineContainmentExplicitFiniteSnapshot where
  proofWorkObligationCount : Nat
  generatorMembershipPlusLineContainmentGivesLineEquality : Bool
  lineContainmentSuppliesFiniteDimensionalWitness : Bool
  lineContainmentSuppliesMultiplicityUpperBound : Bool
  sourceBoundaryLineContainmentFeedsR690 : Bool
  sourceBoundaryLineContainmentFeedsR688 : Bool
  sourceBoundaryLineContainmentFeedsBoundaryData : Bool
  sourceBoundaryLineContainmentFeedsR681 : Bool
  introducesStrongerPremiseThanR690UnderGeneratorMembership : Bool
  provesSourceBoundary : Bool
  provesGeneratorMembership : Bool
  provesLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R691 status: finite-dimensionality and the one-dimensional upper
bound are no longer separate live inputs once the generator-line containment
is the target.  The source boundary, generator membership, and line
containment themselves remain open. -/
def currentR691LineContainmentExplicitFiniteSnapshot :
    R691LineContainmentExplicitFiniteSnapshot where
  proofWorkObligationCount := currentR691LineContainmentExplicitFiniteTargetNames.length
  generatorMembershipPlusLineContainmentGivesLineEquality := true
  lineContainmentSuppliesFiniteDimensionalWitness := true
  lineContainmentSuppliesMultiplicityUpperBound := true
  sourceBoundaryLineContainmentFeedsR690 := true
  sourceBoundaryLineContainmentFeedsR688 := true
  sourceBoundaryLineContainmentFeedsBoundaryData := true
  sourceBoundaryLineContainmentFeedsR681 := true
  introducesStrongerPremiseThanR690UnderGeneratorMembership := false
  provesSourceBoundary := false
  provesGeneratorMembership := false
  provesLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R691 route ledger. -/
theorem currentR691LineContainmentExplicitFiniteSnapshot_eq_texStatus :
    currentR691LineContainmentExplicitFiniteSnapshot =
      ({ proofWorkObligationCount := 3
         generatorMembershipPlusLineContainmentGivesLineEquality := true
         lineContainmentSuppliesFiniteDimensionalWitness := true
         lineContainmentSuppliesMultiplicityUpperBound := true
         sourceBoundaryLineContainmentFeedsR690 := true
         sourceBoundaryLineContainmentFeedsR688 := true
         sourceBoundaryLineContainmentFeedsBoundaryData := true
         sourceBoundaryLineContainmentFeedsR681 := true
         introducesStrongerPremiseThanR690UnderGeneratorMembership := false
         provesSourceBoundary := false
         provesGeneratorMembership := false
         provesLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R691LineContainmentExplicitFiniteSnapshot) := by
  decide

/-- Kernel-checked target names for the R691 route. -/
theorem currentR691LineContainmentExplicitFiniteTargetNames_eq_texStatus :
    currentR691LineContainmentExplicitFiniteTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove h^4 in source_invariants",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R691_substantiveTheoremCount : Nat := 8

end FrontC127_H8ResidualLineContainmentExplicitFiniteRoute
end HCGapL4
end HodgeReduction
