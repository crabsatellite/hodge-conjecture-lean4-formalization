/-
# HC Gap L4 -- Front C76: R639 rank criterion reconciliation (R640).

R639 reduced target-invariant saturation to the finite-dimensional rank
match

* `finrank source_invariants = finrank target_invariants`.

This file prevents that rank criterion from becoming a duplicate route
gap.  Once the existing source carrier equality
`source_invariants = H8` is present, the source side has rank one, so the
R639 rank match is exactly the older R600 expected-Betti target

* `finrank target_invariants = shimuraEVIIExpectedBetti 8`.

The exact-image source equality is the R635 spelling of
`surjectivity_source = source_invariants`.  Thus the R639 rank contract
and the R600 source-invariant expected-Betti residual package are the same
kernel-visible residual target.  No new geometric fact is asserted.
-/

import HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion
import HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC76_H8ResidualRankCriterionReconciliation

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC23_MatsushimaCompactDualRankOne
open FrontC31_TargetRankFromExpectedBetti
open FrontC36_TargetBettiObstruction
open FrontC59_H8ResidualExpectedBettiPackage
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC75_H8ResidualTargetInvariantRankCriterion

section RankExpectedBettiReconciliation

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
/-- **R640 substantive theorem (1/8)**: the source-invariant carrier
equality gives rank one on the source side. -/
theorem sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) = 1 := by
  rw [hsource_H8]
  exact compactDual_H8_finrank_eq_one (A := A)

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R640 substantive theorem (2/8)**: with `source_invariants = H8`,
the expected-Betti target gives the R639 source/target invariant rank
match. -/
theorem targetInvariantFinrank_of_sourceH8_target_expected_betti8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B))
        = 1 :=
        sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8
          (A := A) (B := B) hsource_H8
    _ = shimuraEVIIExpectedBetti 8 := shimura_expected_betti8_eq_one.symm
    _ =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) :=
        htarget_betti8.symm

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R640 substantive theorem (3/8)**: conversely, with
`source_invariants = H8`, the R639 rank match gives the R600
expected-Betti target. -/
theorem target_expected_betti8_of_sourceH8_targetInvariantFinrank
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hrank :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B))) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      shimuraEVIIExpectedBetti 8 := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) :=
        hrank.symm
    _ = 1 :=
        sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8
          (A := A) (B := B) hsource_H8
    _ = shimuraEVIIExpectedBetti 8 := shimura_expected_betti8_eq_one.symm

/-- **R640 substantive theorem (4/8)**: the R639 rank contract gives the
older R600 source-invariant expected-Betti residual package. -/
def sourceInvariantExpectedBettiResidual_of_targetInvariantRankContract
    (O : EVIIH8ResidualTargetInvariantRankContract A B) :
    EVIIH8ResidualSourceInvariantExpectedBettiObligations A B where
  source_eq_invariants :=
    source_eq_invariants_of_sourceInvariantExactImage
      (A := A) (B := B) O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti8 :=
    target_expected_betti8_of_sourceH8_targetInvariantFinrank
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_invariant_finrank

/-- **R640 substantive theorem (5/8)**: the R600 expected-Betti residual
package gives the R639 rank contract. -/
def targetInvariantRankContract_of_sourceInvariantExpectedBettiResidual
    (O : EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :
    EVIIH8ResidualTargetInvariantRankContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImage_of_source_eq_invariants
      (A := A) (B := B) O.source_eq_invariants
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariant_finrank :=
    targetInvariantFinrank_of_sourceH8_target_expected_betti8
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_expected_betti8

/-- **R640 substantive theorem (6/8)**: R639 and R600 describe the same
inhabited residual package. -/
theorem residual_targetInvariantRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantRankContract A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantExpectedBettiResidual_of_targetInvariantRankContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantRankContract_of_sourceInvariantExpectedBettiResidual
            (A := A) (B := B) O)))

/-- **R640 substantive theorem (7/8)**: positive constructor form for
the R636 containment contract from the R600 expected-Betti package,
through the R639 rank criterion. -/
def exactImageContainmentContract_of_sourceInvariantExpectedBettiResidual
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (O : EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :
    EVIIH8ResidualExactImageContainmentContract A B :=
  exactImageContainmentContract_of_targetInvariantFinrank
    (A := A) (B := B)
    (sourceInvariantExactImage_of_source_eq_invariants
      (A := A) (B := B) O.source_eq_invariants)
    O.source_invariants_eq_H8
    (targetInvariantFinrank_of_sourceH8_target_expected_betti8
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_expected_betti8)

end RankExpectedBettiReconciliation

section Obstruction

/-- **R640 obstruction theorem (8/8)**: exact image plus source-H8 still
does not force the R600 expected-Betti residual package.  Otherwise R640
would produce the R639 rank match, contradicting the existing
countermodel. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantExpectedBettiResidual :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (EVIIH8ResidualSourceInvariantExpectedBettiObligations
          TargetBettiSource TargetBettiTarget) := by
  refine ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8, ?_⟩
  intro O
  exact counterexample_not_targetInvariantFinrank
    (targetInvariantRankContract_of_sourceInvariantExpectedBettiResidual
      (A := TargetBettiSource) (B := TargetBettiTarget) O).target_invariant_finrank

end Obstruction

/-- R640 target names for route summaries. -/
def currentR640RankReconciliationTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finrank target_invariants = shimuraEVIIExpectedBetti 8"
]

/-- Machine-readable status for the R640 reconciliation. -/
structure R640RankReconciliationSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetExpectedBettiObligationCount : Nat
  rankCriterionReconciledWithR600 : Bool
  createsNewIndependentGap : Bool
  carriersForceExpectedBettiResidual : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R640 status: R639 is reconciled with the existing R600
expected-Betti target; no new independent target gap is created. -/
def currentR640RankReconciliationSnapshot :
    R640RankReconciliationSnapshot where
  proofWorkObligationCount := currentR640RankReconciliationTargetNames.length
  exactImageCarrierObligationCount := 2
  targetExpectedBettiObligationCount := 1
  rankCriterionReconciledWithR600 := true
  createsNewIndependentGap := false
  carriersForceExpectedBettiResidual := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R640 ledger. -/
theorem currentR640RankReconciliationSnapshot_eq_texStatus :
    currentR640RankReconciliationSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetExpectedBettiObligationCount := 1
         rankCriterionReconciledWithR600 := true
         createsNewIndependentGap := false
         carriersForceExpectedBettiResidual := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R640RankReconciliationSnapshot) := by
  decide

/-- Kernel-checked target names for the R640 ledger. -/
theorem currentR640RankReconciliationTargetNames_eq_texStatus :
    currentR640RankReconciliationTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finrank target_invariants = shimuraEVIIExpectedBetti 8"
    ] := by
  rfl

def R640_substantiveTheoremCount : Nat := 8

end FrontC76_H8ResidualRankCriterionReconciliation
end HCGapL4
end HodgeReduction
