/-
# HC Gap L4 -- Front C107: finite upper-bound target (R671).

R670 related exact target-line equality to the expected-Betti upper bound,
but the upper-bound direction needs finite-dimensional target invariants.
That finiteness should not be counted as an independent target when the line
equality route is used: if

  `target_invariants = span {j_q(h^4)}`

then the target-invariant subspace is finite-dimensional because it is a
singleton span.

This file records the bundled equivalence:

  line equality  <->  finite target invariants + expected-Betti upper bound.

The upper bound remains the genuine target-side theorem; this round only
prevents the finite-dimensional bookkeeping from becoming a separate gap.
-/

import HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC107_H8ResidualLineEqualityFiniteUpperBound

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC80_H8ResidualTargetInvariantUpperBound
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC106_H8ResidualLineEqualityUpperBoundCriterion

section FiniteUpperBound

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
  [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R671 substantive theorem (1/6)**: exact target-line equality supplies
the finite-dimensional target-invariant instance used by the R670 upper-bound
criterion. -/
theorem target_invariants_finiteDimensional_of_eq_h_pow_four_line
    (hline :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B)) := by
  rw [hline]
  exact FiniteDimensional.span_of_finite Rat (Set.finite_singleton _)

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R671 substantive theorem (2/6)**: with source-H8 fixed, exact
target-line equality is equivalent to the bundled target-side finite upper
bound.  The finite-dimensional fact is no longer an unpaired route target. -/
theorem target_invariants_eq_h_pow_four_line_iff_finite_targetExpectedBettiUpperBound
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) <->
      (FiniteDimensional Rat
          (MatsushimaData.target_invariants (A := A) (B := B)) ∧
        Module.finrank (R := Rat)
            (MatsushimaData.target_invariants (A := A) (B := B)) <=
          shimuraEVIIExpectedBetti 8) := by
  constructor
  · intro hline
    have hfinite :
        FiniteDimensional Rat
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
      target_invariants_finiteDimensional_of_eq_h_pow_four_line
        (A := A) (B := B) hline
    letI :
        FiniteDimensional Rat
          (MatsushimaData.target_invariants (A := A) (B := B)) := hfinite
    exact ⟨hfinite,
      (target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
        (A := A) (B := B) hsource_H8).1 hline⟩
  · intro hpack
    rcases hpack with ⟨hfinite, hupper⟩
    letI :
        FiniteDimensional Rat
          (MatsushimaData.target_invariants (A := A) (B := B)) := hfinite
    exact
      (target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
        (A := A) (B := B) hsource_H8).2 hupper

/-- The R671 bundled finite-upper-bound contract.  This is the R644 target
with the finite-dimensional input recorded as a field rather than as a silent
typeclass parameter. -/
structure EVIIH8ResidualFiniteUpperBoundContract
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
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_invariants_finite :
    FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))
  target_expected_betti_upper_bound :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <=
      shimuraEVIIExpectedBetti 8

/-- **R671 substantive theorem (3/6)**: line-equality contracts produce the
bundled finite-upper-bound contracts. -/
def finiteUpperBoundContract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualFiniteUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_finite :=
    target_invariants_finiteDimensional_of_eq_h_pow_four_line
      (A := A) (B := B) O.target_invariants_eq_h_pow_four_line
  target_expected_betti_upper_bound := by
    letI :
        FiniteDimensional Rat
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
      target_invariants_finiteDimensional_of_eq_h_pow_four_line
        (A := A) (B := B) O.target_invariants_eq_h_pow_four_line
    exact
      (target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
        (A := A) (B := B) O.source_invariants_eq_H8).1
        O.target_invariants_eq_h_pow_four_line

/-- **R671 substantive theorem (4/6)**: bundled finite-upper-bound contracts
recover the R669 line-equality contracts. -/
def targetInvariantLineEqualityContract_of_finiteUpperBoundContract
    (O : EVIIH8ResidualFiniteUpperBoundContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_eq_h_pow_four_line := by
    letI :
        FiniteDimensional Rat
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
      O.target_invariants_finite
    exact
      (target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound
        (A := A) (B := B) O.source_invariants_eq_H8).2
        O.target_expected_betti_upper_bound

/-- **R671 substantive theorem (5/6)**: at the inhabited-contract level,
R669 line equality and R671 bundled finite upper bound are equivalent. -/
theorem residual_targetInvariantLineEquality_nonempty_iff_finiteUpperBound_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) <->
      Nonempty (EVIIH8ResidualFiniteUpperBoundContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteUpperBoundContract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_finiteUpperBoundContract
            (A := A) (B := B) O)))

/-- **R671 substantive theorem (6/6)**: the bundled finite upper-bound
contract also gives the R644 upper-bound contract after installing its
finite-dimensional field as a local instance. -/
def targetInvariantUpperBoundContract_of_finiteUpperBoundContract
    (O : EVIIH8ResidualFiniteUpperBoundContract A B) :
    EVIIH8ResidualTargetInvariantUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti_upper_bound := O.target_expected_betti_upper_bound

end FiniteUpperBound

/-- R671 equivalent target names for route summaries. -/
def currentR671FiniteUpperBoundTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finite-dimensional target_invariants and finrank target_invariants <= shimuraEVIIExpectedBetti 8, equivalently target_invariants = span {j_q(h^4)}"
]

/-- Machine-readable status for the R671 finite-upper-bound bridge. -/
structure R671FiniteUpperBoundSnapshot where
  proofWorkObligationCount : Nat
  lineEqualityImpliesTargetFinite : Bool
  finiteUpperBoundEquivalentToLineEquality : Bool
  finiteUpperBoundFeedsR644UpperBound : Bool
  provesTargetUpperBound : Bool
  provesTargetLineEquality : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R671 status: target finite-dimensionality is bundled with the
upper bound and is not counted separately from the line-equality target. -/
def currentR671FiniteUpperBoundSnapshot :
    R671FiniteUpperBoundSnapshot where
  proofWorkObligationCount := currentR671FiniteUpperBoundTargetNames.length
  lineEqualityImpliesTargetFinite := true
  finiteUpperBoundEquivalentToLineEquality := true
  finiteUpperBoundFeedsR644UpperBound := true
  provesTargetUpperBound := false
  provesTargetLineEquality := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R671 ledger. -/
theorem currentR671FiniteUpperBoundSnapshot_eq_texStatus :
    currentR671FiniteUpperBoundSnapshot =
      ({ proofWorkObligationCount := 3
         lineEqualityImpliesTargetFinite := true
         finiteUpperBoundEquivalentToLineEquality := true
         finiteUpperBoundFeedsR644UpperBound := true
         provesTargetUpperBound := false
         provesTargetLineEquality := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R671FiniteUpperBoundSnapshot) := by
  decide

/-- Kernel-checked target names for the R671 ledger. -/
theorem currentR671FiniteUpperBoundTargetNames_eq_texStatus :
    currentR671FiniteUpperBoundTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finite-dimensional target_invariants and finrank target_invariants <= shimuraEVIIExpectedBetti 8, equivalently target_invariants = span {j_q(h^4)}"
    ] := by
  rfl

def R671_substantiveTheoremCount : Nat := 6

end FrontC107_H8ResidualLineEqualityFiniteUpperBound
end HCGapL4
end HodgeReduction
