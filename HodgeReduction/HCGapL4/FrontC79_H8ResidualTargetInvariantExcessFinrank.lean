/-
# HC Gap L4 -- Front C79: target-excess finrank criterion (R643).

R642 turns the R641 quotient-vanishing target into a target-internal
codimension-zero statement.  This file makes that codimension target
numerical:

* the R641 excess quotient has zero finrank exactly when it vanishes;
* `finrank excess + finrank source_invariants = finrank target_invariants`;
* under `source_invariants = H8`, this becomes
  `finrank excess + shimuraEVIIExpectedBetti 8 = finrank target_invariants`;
* zero excess finrank is equivalent to the R600/R640 expected-Betti
  target.

Thus the next target can be attacked as the concrete dimension-zero
theorem for the excess quotient.  No new carrier, axiom, or stronger
premise is added.
-/

import HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC79_H8ResidualTargetInvariantExcessFinrank

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC31_TargetRankFromExpectedBetti
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC76_H8ResidualRankCriterionReconciliation
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC78_H8ResidualTargetInvariantInternalQuotient

section ExcessFinrank

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

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R643 substantive theorem (1/5)**: the R642 rank-nullity formula
rewritten with the original source-invariant rank. -/
theorem targetInvariantExcessQuotient_finrank_add_sourceInvariants_finrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
      Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) := by
        rw [sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants]
    _ = Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) :=
      targetInvariantExcessQuotient_finrank_add_sourceInvariantImageInsideTarget_finrank
        (A := A) (B := B)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R643 substantive theorem (2/5)**: finite-dimensional quotient
vanishing is the same as zero finrank of the R641 target-excess quotient. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    targetInvariantExcessQuotient A B = ⊥ ↔
      Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0 := by
  rw [← targetInvariantQuotientMap_range (A := A) (B := B)]
  exact (Submodule.finrank_eq_zero).symm

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R643 substantive theorem (3/5)**: zero excess finrank is exactly
the R639 source/target invariant-rank match. -/
theorem targetInvariantExcessFinrank_zero_iff_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0 ↔
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
  (targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero
    (A := A) (B := B)).symm.trans
    ((targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top
      (A := A) (B := B)).trans
      (sourceInvariantImageInsideTarget_eq_top_iff_targetInvariantFinrank
        (A := A) (B := B)))

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R643 substantive theorem (4/5)**: under `source_invariants = H8`,
the rank-nullity formula becomes an expected-Betti excess formula. -/
theorem targetInvariantExcessQuotient_finrank_add_expected_betti8_of_sourceH8
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        shimuraEVIIExpectedBetti 8 =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        shimuraEVIIExpectedBetti 8 =
      Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) := by
        rw [sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8
          (A := A) (B := B) hsource_H8, shimura_expected_betti8_eq_one]
    _ = Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) :=
      targetInvariantExcessQuotient_finrank_add_sourceInvariants_finrank
        (A := A) (B := B)

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R643 substantive theorem (5/5)**: under `source_invariants = H8`,
zero excess finrank is exactly the R600/R640 expected-Betti target. -/
theorem targetInvariantExcessFinrank_zero_iff_target_expected_betti8
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0 ↔
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8 := by
  constructor
  · intro hexcess
    exact
      target_expected_betti8_of_sourceH8_targetInvariantFinrank
        (A := A) (B := B) hsource_H8
        ((targetInvariantExcessFinrank_zero_iff_targetInvariantFinrank
          (A := A) (B := B)).1 hexcess)
  · intro htarget
    exact
      (targetInvariantExcessFinrank_zero_iff_targetInvariantFinrank
        (A := A) (B := B)).2
        (targetInvariantFinrank_of_sourceH8_target_expected_betti8
          (A := A) (B := B) hsource_H8 htarget)

end ExcessFinrank

section Obstruction

/-- Exact image plus source-H8 and finite-dimensional target invariants
still do not force zero excess finrank in the current abstract interface. -/
theorem current_interface_with_exactImage_sourceH8_finiteTarget_does_not_force_excessFinrankZero
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants
        (A := TargetBettiSource) (B := TargetBettiTarget))] :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (Module.finrank (R := Rat)
          (targetInvariantExcessQuotient
            TargetBettiSource TargetBettiTarget) = 0) := by
  refine ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8, ?_⟩
  intro hexcess
  exact counterexample_not_targetInvariantExcessQuotient_eq_bot
    ((targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero
      (A := TargetBettiSource) (B := TargetBettiTarget)).2 hexcess)

end Obstruction

/-- R643 target names for route summaries. -/
def currentR643TargetInvariantExcessFinrankTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finrank targetInvariantExcessQuotient = 0"
]

/-- Machine-readable status for the R643 excess-finrank normalization. -/
structure R643TargetInvariantExcessFinrankSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  zeroExcessFinrankObligationCount : Nat
  zeroExcessFinrankEquivalentToQuotientVanishing : Bool
  excessRankFormulaAvailable : Bool
  withSourceH8EquivalentToExpectedBetti : Bool
  carriersForceZeroExcessFinrank : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R643 status: the target-side theorem is now the numerical
statement that the target-excess quotient has finrank zero. -/
def currentR643TargetInvariantExcessFinrankSnapshot :
    R643TargetInvariantExcessFinrankSnapshot where
  proofWorkObligationCount := currentR643TargetInvariantExcessFinrankTargetNames.length
  exactImageCarrierObligationCount := 2
  zeroExcessFinrankObligationCount := 1
  zeroExcessFinrankEquivalentToQuotientVanishing := true
  excessRankFormulaAvailable := true
  withSourceH8EquivalentToExpectedBetti := true
  carriersForceZeroExcessFinrank := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R643 excess-finrank
ledger. -/
theorem currentR643TargetInvariantExcessFinrankSnapshot_eq_texStatus :
    currentR643TargetInvariantExcessFinrankSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         zeroExcessFinrankObligationCount := 1
         zeroExcessFinrankEquivalentToQuotientVanishing := true
         excessRankFormulaAvailable := true
         withSourceH8EquivalentToExpectedBetti := true
         carriersForceZeroExcessFinrank := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R643TargetInvariantExcessFinrankSnapshot) := by
  decide

/-- Kernel-checked target names for the R643 excess-finrank ledger. -/
theorem currentR643TargetInvariantExcessFinrankTargetNames_eq_texStatus :
    currentR643TargetInvariantExcessFinrankTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finrank targetInvariantExcessQuotient = 0"
    ] := by
  rfl

def R643_substantiveTheoremCount : Nat := 5

end FrontC79_H8ResidualTargetInvariantExcessFinrank
end HCGapL4
end HodgeReduction
