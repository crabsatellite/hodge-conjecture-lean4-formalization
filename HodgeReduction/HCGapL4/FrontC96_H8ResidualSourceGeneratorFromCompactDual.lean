/-
# HC Gap L4 -- Front C96: source generator from compact-dual generator (R660).

R659 compressed the source side of the H8 residual: once the target
generator-line containment is known, the only remaining source-carrier input
is generator membership `h^4 ∈ source_invariants`.

R574/R602 already expose the genuine geometric spelling of that membership:
`h^4 ∈ compactDual`.  This file wires that compact-dual generator fact into
the R659 contract, so the active residual target is now:

* exact image of source invariants;
* `h^4` lies in the compact-dual carrier;
* target generator-line containment.

This is only a transfer through the existing Matsushima compact-dual/source
comparison.  It does not prove compact-dual generator membership and does not
claim full Hodge closure.
-/

import HodgeReduction.HCGapL4.FrontC33_CompactDualH8CarrierCriterion
import HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC96_H8ResidualSourceGeneratorFromCompactDual

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC33_CompactDualH8CarrierCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC95_H8ResidualSourceNoExtraFromLineContainment

section CompactDualGeneratorLine

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

omit [CompactDualData A] [CartanCompactDualIso A]
  [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R660 substantive theorem (1/6)**: compact-dual generator membership
gives the source-invariant generator membership required by R659. -/
theorem h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  h_pow_4_mem_source_invariants_of_mem_compactDual
    (A := A) (B := B) hh_compact

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B] in
/-- **R660 substantive theorem (2/6)**: compact-dual generator membership
plus target generator-line containment proves `source_invariants = H8`. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_compactDual_and_line
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
    (A := A) (B := B)
    (h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)
    hline

/-- The R660 compact-dual generator-line residual package.  It replaces the
R659 source-membership field by the compact-dual membership that should be
proved from Cartan/Borel-Wallach geometry. -/
structure EVIIH8ResidualCompactDualGeneratorLineContract
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
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R660 substantive theorem (3/6)**: the compact-dual package feeds the
R659 generator-membership package by transferring `h^4` through
`compactDual = source_invariants`. -/
def generatorMembershipLineContract_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualCompactDualGeneratorLineContract A B) :
    EVIIH8ResidualGeneratorMembershipLineContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual
      (A := A) (B := B) O.h_pow_four_mem_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R660 substantive theorem (4/6)**: the compact-dual package feeds the
R656 line-containment contract. -/
def cartanLineContainmentContract_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualCompactDualGeneratorLineContract A B) :
    EVIIH8ResidualCartanLineContainmentContract A B :=
  cartanLineContainmentContract_of_generatorMembershipLineContract
    (A := A) (B := B)
    (generatorMembershipLineContract_of_compactDualGeneratorLineContract
      (A := A) (B := B) O)

/-- **R660 substantive theorem (5/6)**: the compact-dual package feeds the
R641 quotient-vanishing contract. -/
def targetInvariantExcessQuotientContract_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualCompactDualGeneratorLineContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B :=
  targetInvariantExcessQuotientContract_of_generatorMembershipLineContract
    (A := A) (B := B)
    (generatorMembershipLineContract_of_compactDualGeneratorLineContract
      (A := A) (B := B) O)

/-- **R660 substantive theorem (6/6)**: inhabited compact-dual contracts feed
inhabited quotient-vanishing contracts. -/
theorem residual_compactDualGeneratorLine_nonempty_to_targetInvariantExcessQuotient_nonempty :
    Nonempty (EVIIH8ResidualCompactDualGeneratorLineContract A B) ->
      Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (targetInvariantExcessQuotientContract_of_compactDualGeneratorLineContract
      (A := A) (B := B) O)

end CompactDualGeneratorLine

/-- R660 target names for route summaries. -/
def currentR660CompactDualGeneratorLineTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove h^4 ∈ compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R660 compact-dual generator bridge. -/
structure R660CompactDualGeneratorLineSnapshot where
  proofWorkObligationCount : Nat
  compactDualGeneratorFeedsSourceGenerator : Bool
  compactDualGeneratorPlusLineGivesSourceH8 : Bool
  compactDualGeneratorLineFeedsR659Contract : Bool
  compactDualGeneratorLineFeedsLineContract : Bool
  compactDualGeneratorLineFeedsQuotientContract : Bool
  provesCompactDualGeneratorMembership : Bool
  provesLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R660 status: the live source generator obligation has been moved
to compact-dual membership.  This bridge does not prove that compact-dual
membership or the target generator-line theorem. -/
def currentR660CompactDualGeneratorLineSnapshot :
    R660CompactDualGeneratorLineSnapshot where
  proofWorkObligationCount := currentR660CompactDualGeneratorLineTargetNames.length
  compactDualGeneratorFeedsSourceGenerator := true
  compactDualGeneratorPlusLineGivesSourceH8 := true
  compactDualGeneratorLineFeedsR659Contract := true
  compactDualGeneratorLineFeedsLineContract := true
  compactDualGeneratorLineFeedsQuotientContract := true
  provesCompactDualGeneratorMembership := false
  provesLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R660 ledger. -/
theorem currentR660CompactDualGeneratorLineSnapshot_eq_texStatus :
    currentR660CompactDualGeneratorLineSnapshot =
      ({ proofWorkObligationCount := 3
         compactDualGeneratorFeedsSourceGenerator := true
         compactDualGeneratorPlusLineGivesSourceH8 := true
         compactDualGeneratorLineFeedsR659Contract := true
         compactDualGeneratorLineFeedsLineContract := true
         compactDualGeneratorLineFeedsQuotientContract := true
         provesCompactDualGeneratorMembership := false
         provesLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R660CompactDualGeneratorLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R660 ledger. -/
theorem currentR660CompactDualGeneratorLineTargetNames_eq_texStatus :
    currentR660CompactDualGeneratorLineTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove h^4 ∈ compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R660_substantiveTheoremCount : Nat := 6

end FrontC96_H8ResidualSourceGeneratorFromCompactDual
end HCGapL4
end HodgeReduction
