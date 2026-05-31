/-
# HC Gap L4 -- Front C95: source no-extra from generator-line containment (R659).

R658 makes the target-side theorem concrete as

  `trivialModulePart <= span {j_q(h^4)}`.

This file observes that the same target-line theorem also controls the
source side.  Since `j_q` sends source invariants into target invariants, and
target invariants are already identified with `trivialModulePart`, any source
invariant maps into the `j_q(h^4)` line.  Injectivity of `j_q` then forces the
source invariant itself to lie in `span {h^4}`, i.e. in `H8`.

Thus the source-H8 equality can be attacked as:

* prove `h^4` is in `source_invariants`;
* prove the target generator-line containment.

The line containment then supplies the no-extra-source half automatically.
-/

import HodgeReduction.HCGapL4.FrontC32_SourceInvariantsH8CarrierCriterion
import HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC95_H8ResidualSourceNoExtraFromLineContainment

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC32_SourceInvariantsH8CarrierCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC94_H8ResidualQuotientLineContainmentEquivalence

section SourceNoExtraFromLine

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

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- **R659 substantive theorem (1/6)**: target generator-line containment
forces the no-extra-source half `source_invariants <= H8`. -/
theorem source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) ≤
      CompactDualData.H8 (A := A) := by
  intro alpha halpha
  have hj_target :
      MatsushimaData.j_q (A := A) (B := B) alpha ∈
        MatsushimaData.target_invariants (A := A) (B := B) :=
    MatsushimaData.j_q_maps_invariants_to_invariants
      (A := A) (B := B) halpha
  have hj_trivial :
      MatsushimaData.j_q (A := A) (B := B) alpha ∈
        CuspidalCohomologyData.trivialModulePart (A := B) := by
    simpa [target_invariants_eq_trivialModulePart (A := A) (B := B)]
      using hj_target
  have hj_line :
      MatsushimaData.j_q (A := A) (B := B) alpha ∈
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    hline hj_trivial
  rw [Submodule.mem_span_singleton] at hj_line
  obtain ⟨r, hr⟩ := hj_line
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  rw [Submodule.mem_span_singleton]
  refine ⟨r, ?_⟩
  apply MatsushimaData.j_q_injective (A := A) (B := B)
  rw [map_smul]
  exact hr

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- **R659 substantive theorem (2/6)**: target generator-line containment
plus source membership of the generator proves the full source-H8 equality. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_source_le_H8_h_pow_4_mem
    (A := A) (B := B)
    (source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B) hline)
    hh_pow

/-- The R659 compressed residual package: exact image, source generator
membership, and target generator-line containment.  This is not a closure
claim; it is a smaller source/target split for the H8 residual. -/
structure EVIIH8ResidualGeneratorMembershipLineContract
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
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R659 substantive theorem (3/6)**: the compressed R659 package gives
the existing R656 line-containment contract by deriving `source_invariants =
H8` from the generator membership plus line containment. -/
def cartanLineContainmentContract_of_generatorMembershipLineContract
    (O : EVIIH8ResidualGeneratorMembershipLineContract A B) :
    EVIIH8ResidualCartanLineContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_le_h_pow_four_line
  trivialModulePart_le_h_pow_four_line := O.trivialModulePart_le_h_pow_four_line

/-- **R659 substantive theorem (4/6)**: the compressed R659 package gives
the R641 quotient-vanishing contract, again without separately assuming
`source_invariants = H8`. -/
def targetInvariantExcessQuotientContract_of_generatorMembershipLineContract
    (O : EVIIH8ResidualGeneratorMembershipLineContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_le_h_pow_four_line
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B)
      (source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
        (A := A) (B := B)
        O.h_pow_four_mem_source_invariants
        O.trivialModulePart_le_h_pow_four_line)).2
      O.trivialModulePart_le_h_pow_four_line

/-- **R659 substantive theorem (5/6)**: inhabited compressed contracts feed
inhabited generator-line contracts. -/
theorem residual_generatorMembershipLine_nonempty_to_cartanLine_nonempty :
    Nonempty (EVIIH8ResidualGeneratorMembershipLineContract A B) ->
      Nonempty (EVIIH8ResidualCartanLineContainmentContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (cartanLineContainmentContract_of_generatorMembershipLineContract
      (A := A) (B := B) O)

/-- **R659 substantive theorem (6/6)**: inhabited compressed contracts feed
inhabited quotient-vanishing contracts. -/
theorem residual_generatorMembershipLine_nonempty_to_targetInvariantExcessQuotient_nonempty :
    Nonempty (EVIIH8ResidualGeneratorMembershipLineContract A B) ->
      Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (targetInvariantExcessQuotientContract_of_generatorMembershipLineContract
      (A := A) (B := B) O)

end SourceNoExtraFromLine

/-- R659 target names for route summaries. -/
def currentR659SourceNoExtraFromLineTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove h^4 ∈ source_invariants",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R659 source-no-extra bridge. -/
structure R659SourceNoExtraFromLineSnapshot where
  proofWorkObligationCount : Nat
  lineContainmentForcesSourceNoExtraH8 : Bool
  generatorMembershipPlusLineGivesSourceH8 : Bool
  compressedPackageFeedsLineContract : Bool
  compressedPackageFeedsQuotientContract : Bool
  provesLineContainment : Bool
  provesGeneratorMembership : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R659 status: line containment now also supplies the no-extra
source-H8 half.  The remaining source carrier item is just generator
membership `h^4 ∈ source_invariants`; the target-side item remains the
generator-line/quotient theorem itself. -/
def currentR659SourceNoExtraFromLineSnapshot :
    R659SourceNoExtraFromLineSnapshot where
  proofWorkObligationCount := currentR659SourceNoExtraFromLineTargetNames.length
  lineContainmentForcesSourceNoExtraH8 := true
  generatorMembershipPlusLineGivesSourceH8 := true
  compressedPackageFeedsLineContract := true
  compressedPackageFeedsQuotientContract := true
  provesLineContainment := false
  provesGeneratorMembership := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R659 ledger. -/
theorem currentR659SourceNoExtraFromLineSnapshot_eq_texStatus :
    currentR659SourceNoExtraFromLineSnapshot =
      ({ proofWorkObligationCount := 3
         lineContainmentForcesSourceNoExtraH8 := true
         generatorMembershipPlusLineGivesSourceH8 := true
         compressedPackageFeedsLineContract := true
         compressedPackageFeedsQuotientContract := true
         provesLineContainment := false
         provesGeneratorMembership := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R659SourceNoExtraFromLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R659 ledger. -/
theorem currentR659SourceNoExtraFromLineTargetNames_eq_texStatus :
    currentR659SourceNoExtraFromLineTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove h^4 ∈ source_invariants",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R659_substantiveTheoremCount : Nat := 6

end FrontC95_H8ResidualSourceNoExtraFromLineContainment
end HCGapL4
end HodgeReduction
