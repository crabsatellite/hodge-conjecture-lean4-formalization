/-
# HC Gap L4 -- Front C80: target-invariant upper-bound criterion (R644).

R643 made the remaining target-side theorem numerical:

* prove `finrank targetInvariantExcessQuotient = 0`.

Under `source_invariants = H8`, R643 also proves the rank formula

* `finrank excess + shimuraEVIIExpectedBetti 8 = finrank target_invariants`.

This file turns the target rank equality into the one-sided geometric
input that is actually needed: it is enough to prove the upper bound

* `finrank target_invariants <= shimuraEVIIExpectedBetti 8`.

The source-H8 carrier already supplies the lower bound through the
Matsushima image, so an upper bound forces zero excess.  This avoids
reintroducing the equality as a stronger black-box premise and gives the
next agent a sharper target: rule out extra target-invariant classes.
-/

import HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC80_H8ResidualTargetInvariantUpperBound

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC31_TargetRankFromExpectedBetti
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC79_H8ResidualTargetInvariantExcessFinrank

section TargetUpperBound

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
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R644 substantive theorem (1/8)**: after `source_invariants = H8`,
an upper bound on the target-invariant rank forces the R643 excess
finrank to vanish. -/
theorem targetInvariantExcessFinrank_zero_of_sourceH8_targetExpectedBettiUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_le :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) <=
        shimuraEVIIExpectedBetti 8) :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0 := by
  have hsum :
      Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
          shimuraEVIIExpectedBetti 8 =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
    targetInvariantExcessQuotient_finrank_add_expected_betti8_of_sourceH8
      (A := A) (B := B) hsource_H8
  omega

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R644 substantive theorem (2/8)**: zero excess gives the same
target upper bound. -/
theorem targetExpectedBettiUpperBound_of_targetInvariantExcessFinrank_zero
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hexcess :
      Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <=
      shimuraEVIIExpectedBetti 8 := by
  exact le_of_eq
    ((targetInvariantExcessFinrank_zero_iff_target_expected_betti8
      (A := A) (B := B) hsource_H8).1 hexcess)

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R644 substantive theorem (3/8)**: with source-H8 fixed, zero
target excess is equivalent to the one-sided target expected-Betti upper
bound. -/
theorem targetInvariantExcessFinrank_zero_iff_targetExpectedBettiUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0 <->
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) <=
        shimuraEVIIExpectedBetti 8 := by
  constructor
  · exact
      targetExpectedBettiUpperBound_of_targetInvariantExcessFinrank_zero
        (A := A) (B := B) hsource_H8
  · exact
      targetInvariantExcessFinrank_zero_of_sourceH8_targetExpectedBettiUpperBound
        (A := A) (B := B) hsource_H8

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R644 substantive theorem (4/8)**: the R641 quotient vanishes
exactly when the target-invariant upper bound holds, once source-H8 is
fixed. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ <->
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) <=
        shimuraEVIIExpectedBetti 8 :=
  (targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero
    (A := A) (B := B)).trans
    (targetInvariantExcessFinrank_zero_iff_targetExpectedBettiUpperBound
      (A := A) (B := B) hsource_H8)

/-- The R644 one-sided target-rank spelling of the residual package. -/
structure EVIIH8ResidualTargetInvariantUpperBoundContract
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
  target_expected_betti_upper_bound :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <=
      shimuraEVIIExpectedBetti 8

/-- **R644 substantive theorem (5/8)**: the upper-bound residual
package gives the R641 quotient-vanishing contract. -/
def targetInvariantExcessQuotientContract_of_targetInvariantUpperBoundContract
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (O : EVIIH8ResidualTargetInvariantUpperBoundContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound
      (A := A) (B := B) O.source_invariants_eq_H8).2
      O.target_expected_betti_upper_bound

/-- **R644 substantive theorem (6/8)**: quotient vanishing gives the
upper-bound residual package. -/
def targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualTargetInvariantUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti_upper_bound :=
    (targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound
      (A := A) (B := B) O.source_invariants_eq_H8).1
      O.target_excess_quotient_eq_bot

/-- **R644 substantive theorem (7/8)**: under finite-dimensional target
invariants, the R644 upper-bound package and the R641 quotient package
are equivalent residual ledgers. -/
theorem residual_targetInvariantUpperBound_nonempty_iff_targetInvariantExcessQuotient_nonempty
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Nonempty (EVIIH8ResidualTargetInvariantUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_targetInvariantUpperBoundContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract
            (A := A) (B := B) O)))

end TargetUpperBound

section Obstruction

/-- **R644 substantive theorem (8/8)**: exact image plus source-H8 still
does not force the target expected-Betti upper bound in the current
abstract interface.  The new upper-bound target is therefore genuine
target geometry, not a formal consequence of the carrier side. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_targetExpectedBettiUpperBound :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (Module.finrank (R := Rat)
            (MatsushimaData.target_invariants
              (A := TargetBettiSource) (B := TargetBettiTarget)) <=
          shimuraEVIIExpectedBetti 8) := by
  refine ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8, ?_⟩
  intro hle
  have htarget_rank :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) = 2 := by
    change Module.finrank (R := Rat)
        (⊤ : Submodule Rat TargetBettiTarget) = 2
    simp [TargetBettiTarget]
  have hbetti8 : shimuraEVIIExpectedBetti 8 = 1 :=
    shimura_expected_betti8_eq_one
  omega

end Obstruction

/-- R644 target names for route summaries. -/
def currentR644TargetInvariantUpperBoundTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finrank target_invariants <= shimuraEVIIExpectedBetti 8"
]

/-- Machine-readable status for the R644 target-rank upper-bound
normalization. -/
structure R644TargetInvariantUpperBoundSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetUpperBoundObligationCount : Nat
  upperBoundEquivalentToZeroExcessWithSourceH8 : Bool
  quotientVanishingEquivalentToUpperBoundWithSourceH8 : Bool
  upperBoundReplacesTargetRankEquality : Bool
  carriersForceUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R644 status: the target-side theorem is now the one-sided
upper bound excluding extra target-invariant classes. -/
def currentR644TargetInvariantUpperBoundSnapshot :
    R644TargetInvariantUpperBoundSnapshot where
  proofWorkObligationCount := currentR644TargetInvariantUpperBoundTargetNames.length
  exactImageCarrierObligationCount := 2
  targetUpperBoundObligationCount := 1
  upperBoundEquivalentToZeroExcessWithSourceH8 := true
  quotientVanishingEquivalentToUpperBoundWithSourceH8 := true
  upperBoundReplacesTargetRankEquality := true
  carriersForceUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R644 upper-bound
ledger. -/
theorem currentR644TargetInvariantUpperBoundSnapshot_eq_texStatus :
    currentR644TargetInvariantUpperBoundSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetUpperBoundObligationCount := 1
         upperBoundEquivalentToZeroExcessWithSourceH8 := true
         quotientVanishingEquivalentToUpperBoundWithSourceH8 := true
         upperBoundReplacesTargetRankEquality := true
         carriersForceUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R644TargetInvariantUpperBoundSnapshot) := by
  decide

/-- Kernel-checked target names for the R644 upper-bound ledger. -/
theorem currentR644TargetInvariantUpperBoundTargetNames_eq_texStatus :
    currentR644TargetInvariantUpperBoundTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finrank target_invariants <= shimuraEVIIExpectedBetti 8"
    ] := by
  rfl

def R644_substantiveTheoremCount : Nat := 8

end FrontC80_H8ResidualTargetInvariantUpperBound
end HCGapL4
end HodgeReduction
