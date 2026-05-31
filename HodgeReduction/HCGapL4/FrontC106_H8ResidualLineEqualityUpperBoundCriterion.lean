/-
# HC Gap L4 -- Front C106: target-line equality versus upper bound (R670).

R669 made the target-side theorem an exact line equality:

  `target_invariants = span {j_q(h^4)}`.

R644 had already exposed the same target as the one-sided rank upper bound

  `finrank target_invariants <= shimuraEVIIExpectedBetti 8`.

This file records the direct equivalence between those spellings, under the
same source-H8 carrier and finite-dimensional target-invariant hypothesis
used by R644.  It does not prove the upper bound.  The purpose is to prevent
future agents from counting the line equality and the expected-Betti upper
bound as separate residual targets.
-/

import HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound
import HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC106_H8ResidualLineEqualityUpperBoundCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC80_H8ResidualTargetInvariantUpperBound
open FrontC102_H8ResidualTargetInvariantQuotientEquivalence
open FrontC105_H8ResidualTargetInvariantLineEquality

section LineEqualityUpperBound

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

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R670 substantive theorem (1/5)**: with source-H8 fixed and target
invariants finite-dimensional, the R669 exact line equality is exactly the
R644 one-sided expected-Betti upper bound. -/
theorem target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) <->
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) <=
        shimuraEVIIExpectedBetti 8 :=
  (target_invariants_eq_h_pow_four_line_iff_target_invariants_le_h_pow_four_line
    (A := A) (B := B) hsource_H8).trans
    ((targetInvariantExcessQuotient_eq_bot_iff_target_invariants_le_h_pow_four_line
      (A := A) (B := B) hsource_H8).symm.trans
      (targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound
        (A := A) (B := B) hsource_H8))

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R670 substantive theorem (2/5)**: the R644 upper bound closes the
R669 exact target-line equality under the shared source-H8 carrier. -/
theorem target_invariants_eq_h_pow_four_line_of_sourceH8_targetExpectedBettiUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hupper :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) <=
        shimuraEVIIExpectedBetti 8) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} :=
  (target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
    (A := A) (B := B) hsource_H8).2 hupper

/-- **R670 substantive theorem (3/5)**: R644 upper-bound contracts feed the
R669 line-equality contracts; this is a consumer bridge only. -/
def targetInvariantLineEqualityContract_of_targetInvariantUpperBoundContract
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (O : EVIIH8ResidualTargetInvariantUpperBoundContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_eq_h_pow_four_line :=
    target_invariants_eq_h_pow_four_line_of_sourceH8_targetExpectedBettiUpperBound
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_expected_betti_upper_bound

/-- **R670 substantive theorem (4/5)**: R669 line-equality contracts recover
the R644 upper-bound contracts under the same finite-dimensional target
invariant hypothesis. -/
def targetInvariantUpperBoundContract_of_targetInvariantLineEqualityContract
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualTargetInvariantUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti_upper_bound :=
    (target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
      (A := A) (B := B) O.source_invariants_eq_H8).1
      O.target_invariants_eq_h_pow_four_line

/-- **R670 substantive theorem (5/5)**: under finite-dimensional target
invariants, the R644 upper-bound package and the R669 line-equality package
are equivalent residual ledgers. -/
theorem residual_targetInvariantUpperBound_nonempty_iff_targetInvariantLineEquality_nonempty
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Nonempty (EVIIH8ResidualTargetInvariantUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_targetInvariantUpperBoundContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantUpperBoundContract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))

end LineEqualityUpperBound

/-- R670 equivalent target names for route summaries. -/
def currentR670LineEqualityUpperBoundTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finite-dimensional target_invariants",
  "prove finrank target_invariants <= shimuraEVIIExpectedBetti 8, equivalently target_invariants = span {j_q(h^4)}"
]

/-- Machine-readable status for the R670 upper-bound/line-equality bridge. -/
structure R670LineEqualityUpperBoundSnapshot where
  proofWorkObligationCount : Nat
  lineEqualityEquivalentToUpperBoundWithFiniteTarget : Bool
  upperBoundContractEquivalentToLineEqualityContract : Bool
  provesTargetUpperBound : Bool
  provesTargetLineEquality : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R670 status: the target line equality and one-sided expected-Betti
upper bound are the same residual target once the finite-dimensional target
invariant hypothesis is supplied. -/
def currentR670LineEqualityUpperBoundSnapshot :
    R670LineEqualityUpperBoundSnapshot where
  proofWorkObligationCount := currentR670LineEqualityUpperBoundTargetNames.length
  lineEqualityEquivalentToUpperBoundWithFiniteTarget := true
  upperBoundContractEquivalentToLineEqualityContract := true
  provesTargetUpperBound := false
  provesTargetLineEquality := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R670 ledger. -/
theorem currentR670LineEqualityUpperBoundSnapshot_eq_texStatus :
    currentR670LineEqualityUpperBoundSnapshot =
      ({ proofWorkObligationCount := 4
         lineEqualityEquivalentToUpperBoundWithFiniteTarget := true
         upperBoundContractEquivalentToLineEqualityContract := true
         provesTargetUpperBound := false
         provesTargetLineEquality := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R670LineEqualityUpperBoundSnapshot) := by
  decide

/-- Kernel-checked target names for the R670 ledger. -/
theorem currentR670LineEqualityUpperBoundTargetNames_eq_texStatus :
    currentR670LineEqualityUpperBoundTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finite-dimensional target_invariants",
      "prove finrank target_invariants <= shimuraEVIIExpectedBetti 8, equivalently target_invariants = span {j_q(h^4)}"
    ] := by
  rfl

def R670_substantiveTheoremCount : Nat := 5

end FrontC106_H8ResidualLineEqualityUpperBoundCriterion
end HCGapL4
end HodgeReduction
