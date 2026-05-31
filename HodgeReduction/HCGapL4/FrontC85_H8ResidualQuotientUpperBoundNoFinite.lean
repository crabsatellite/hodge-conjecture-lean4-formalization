/-
# HC Gap L4 -- Front C85: quotient vanishing gives upper bounds without finite-dimensional target invariants (R649).

R644 related quotient vanishing and the target expected-Betti upper bound
through a finite-dimensional rank formula for `target_invariants`.  R648
gives a sharper one-way consumer: under `source_invariants = H8`,
quotient vanishing is the Cartan scalar-preimage target, and R647 already
turns that into the one-dimensional trivial-module upper bound.

Therefore the forward direction

* `targetInvariantExcessQuotient = bot` implies the R645/R644 upper-bound
  contracts

does not need a separate `FiniteDimensional target_invariants` hypothesis.
This removes an unnecessary dependency from the consumer side.  It does
not prove quotient vanishing and does not close full HC.
-/

import HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC85_H8ResidualQuotientUpperBoundNoFinite

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC80_H8ResidualTargetInvariantUpperBound
open FrontC81_H8ResidualTrivialModuleUpperBound
open FrontC83_H8ResidualCartanImageScalarPreimage
open FrontC84_H8ResidualScalarPreimageQuotientEquivalence

section QuotientUpperBoundNoFinite

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
/-- **R649 substantive theorem (1/5)**: under source-H8, quotient
vanishing implies the trivial-module upper bound without assuming
finite-dimensional target invariants. -/
theorem trivialModulePart_upper_bound_of_sourceH8_targetInvariantExcessQuotient
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hquot : targetInvariantExcessQuotient A B = ⊥) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 :=
  trivialModulePart_upper_bound_of_cartan_scalar_preimage
      (A := A) (B := B)
    ((targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := A) (B := B) hsource_H8).1 hquot)

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R649 substantive theorem (2/5)**: the same quotient target gives
the R644 expected-Betti upper bound without the finite-dimensional rank
formula. -/
theorem targetExpectedBettiUpperBound_of_sourceH8_targetInvariantExcessQuotient
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hquot : targetInvariantExcessQuotient A B = ⊥) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <=
      shimuraEVIIExpectedBetti 8 :=
  (targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound
    (A := A) (B := B)).2
    (trivialModulePart_upper_bound_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B) hsource_H8 hquot)

/-- **R649 substantive theorem (3/5)**: quotient-vanishing contract
feeds the R645 trivial-module upper-bound contract without a finite
target-invariant hypothesis. -/
def trivialModuleUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualTrivialModuleUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_upper_bound :=
    trivialModulePart_upper_bound_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_excess_quotient_eq_bot

/-- **R649 substantive theorem (4/5)**: quotient-vanishing contract
feeds the R644 target expected-Betti upper-bound contract without a
finite target-invariant hypothesis. -/
def targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualTargetInvariantUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti_upper_bound :=
    targetExpectedBettiUpperBound_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_excess_quotient_eq_bot

/-- **R649 substantive theorem (5/5)**: the quotient-vanishing residual
is a one-way consumer for the upper-bound residual without any finite
target-invariant assumption.  The reverse direction still belongs to the
R644 finite-dimensional rank formula. -/
theorem targetInvariantExcessQuotient_nonempty_to_targetInvariantUpperBound_nonempty_noFinite :
    Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) ->
      Nonempty (EVIIH8ResidualTargetInvariantUpperBoundContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite
      (A := A) (B := B) O)

end QuotientUpperBoundNoFinite

/-- R649 target names for route summaries. -/
def currentR649NoFiniteQuotientUpperBoundTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove targetInvariantExcessQuotient = bot; quotient-to-upper-bound needs no finite target-invariants"
]

/-- Machine-readable status for the R649 no-finite consumer. -/
structure R649NoFiniteQuotientUpperBoundSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  quotientVanishingObligationCount : Nat
  quotientImpliesTrivialUpperBoundWithoutFiniteTarget : Bool
  quotientImpliesExpectedBettiUpperBoundWithoutFiniteTarget : Bool
  reverseDirectionStillUsesFiniteRankFormula : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R649 status: quotient vanishing is enough to consume the
target upper-bound side without a finite-dimensional target-invariant
hypothesis, but quotient vanishing itself is still open. -/
def currentR649NoFiniteQuotientUpperBoundSnapshot :
    R649NoFiniteQuotientUpperBoundSnapshot where
  proofWorkObligationCount := currentR649NoFiniteQuotientUpperBoundTargetNames.length
  exactImageCarrierObligationCount := 2
  quotientVanishingObligationCount := 1
  quotientImpliesTrivialUpperBoundWithoutFiniteTarget := true
  quotientImpliesExpectedBettiUpperBoundWithoutFiniteTarget := true
  reverseDirectionStillUsesFiniteRankFormula := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R649 ledger. -/
theorem currentR649NoFiniteQuotientUpperBoundSnapshot_eq_texStatus :
    currentR649NoFiniteQuotientUpperBoundSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         quotientVanishingObligationCount := 1
         quotientImpliesTrivialUpperBoundWithoutFiniteTarget := true
         quotientImpliesExpectedBettiUpperBoundWithoutFiniteTarget := true
         reverseDirectionStillUsesFiniteRankFormula := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R649NoFiniteQuotientUpperBoundSnapshot) := by
  decide

/-- Kernel-checked target names for the R649 ledger. -/
theorem currentR649NoFiniteQuotientUpperBoundTargetNames_eq_texStatus :
    currentR649NoFiniteQuotientUpperBoundTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove targetInvariantExcessQuotient = bot; quotient-to-upper-bound needs no finite target-invariants"
    ] := by
  rfl

def R649_substantiveTheoremCount : Nat := 5

end FrontC85_H8ResidualQuotientUpperBoundNoFinite
end HCGapL4
end HodgeReduction
