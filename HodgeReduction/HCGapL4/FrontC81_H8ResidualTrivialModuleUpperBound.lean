/-
# HC Gap L4 -- Front C81: trivial-module upper-bound target (R645).

R644 replaced the target rank equality by the one-sided upper bound

* `finrank target_invariants <= shimuraEVIIExpectedBetti 8`.

The existing R554 Matsushima/Franke/Vogan-Zuckerman bridge identifies
`target_invariants` with `trivialModulePart`.  Since the degree-8 EVII
expected Betti slot is one, this file rewrites the remaining target as
the automorphic multiplicity-style upper bound

* `finrank trivialModulePart <= 1`.

This is still not a closure claim.  It identifies the next concrete
mathematical target: prove that the cuspidal trivial-module contribution
has multiplicity at most one in degree 8.
-/

import HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC81_H8ResidualTrivialModuleUpperBound

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC31_TargetRankFromExpectedBetti
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC80_H8ResidualTargetInvariantUpperBound

section TrivialModuleUpperBound

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
  [MatsushimaCompactDualData A B] in
/-- **R645 substantive theorem (1/7)**: the R644 target-invariant upper
bound is exactly the cuspidal trivial-module upper bound. -/
theorem targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <=
      shimuraEVIIExpectedBetti 8) <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  rw [target_invariants_eq_trivialModulePart (A := A) (B := B),
    shimura_expected_betti8_eq_one]

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- **R645 substantive theorem (2/7)**: with source-H8 fixed, the R643
zero-excess target is equivalent to `finrank trivialModulePart <= 1`. -/
theorem targetInvariantExcessFinrank_zero_iff_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) = 0 <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 :=
  (targetInvariantExcessFinrank_zero_iff_targetExpectedBettiUpperBound
    (A := A) (B := B) hsource_H8).trans
    (targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound
      (A := A) (B := B))

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- **R645 substantive theorem (3/7)**: the R641 quotient vanishes
exactly when the trivial-module upper bound holds, once source-H8 is
fixed. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 :=
  (targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound
    (A := A) (B := B) hsource_H8).trans
    (targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound
      (A := A) (B := B))

/-- The R645 automorphic upper-bound spelling of the residual package. -/
structure EVIIH8ResidualTrivialModuleUpperBoundContract
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
  trivialModulePart_upper_bound :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1

/-- **R645 substantive theorem (4/7)**: the trivial-module upper-bound
contract gives the R644 target-invariant upper-bound contract. -/
def targetInvariantUpperBoundContract_of_trivialModuleUpperBoundContract
    (O : EVIIH8ResidualTrivialModuleUpperBoundContract A B) :
    EVIIH8ResidualTargetInvariantUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti_upper_bound :=
    (targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound
      (A := A) (B := B)).2 O.trivialModulePart_upper_bound

/-- **R645 substantive theorem (5/7)**: the R644 upper-bound contract
gives the trivial-module upper-bound contract. -/
def trivialModuleUpperBoundContract_of_targetInvariantUpperBoundContract
    (O : EVIIH8ResidualTargetInvariantUpperBoundContract A B) :
    EVIIH8ResidualTrivialModuleUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_upper_bound :=
    (targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound
      (A := A) (B := B)).1 O.target_expected_betti_upper_bound

/-- **R645 substantive theorem (6/7)**: the R645 trivial-module
upper-bound package and the R644 target-invariant upper-bound package
are equivalent residual ledgers. -/
theorem residual_trivialModuleUpperBound_nonempty_iff_targetInvariantUpperBound_nonempty :
    Nonempty (EVIIH8ResidualTrivialModuleUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantUpperBoundContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantUpperBoundContract_of_trivialModuleUpperBoundContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (trivialModuleUpperBoundContract_of_targetInvariantUpperBoundContract
            (A := A) (B := B) O)))

end TrivialModuleUpperBound

section Obstruction

/-- **R645 substantive theorem (7/7)**: exact image plus source-H8 still
does not force the trivial-module upper bound in the current abstract
interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (Module.finrank (R := Rat)
            (CuspidalCohomologyData.trivialModulePart
              (A := TargetBettiTarget)) <= 1) := by
  refine ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8, ?_⟩
  intro hle
  have htrivial_rank :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart
            (A := TargetBettiTarget)) = 2 := by
    change Module.finrank (R := Rat)
        (⊤ : Submodule Rat TargetBettiTarget) = 2
    simp [TargetBettiTarget]
  omega

end Obstruction

/-- R645 target names for route summaries. -/
def currentR645TrivialModuleUpperBoundTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R645 trivial-module upper-bound
normalization. -/
structure R645TrivialModuleUpperBoundSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  trivialModuleUpperBoundObligationCount : Nat
  targetUpperBoundRewrittenToTrivialModule : Bool
  zeroExcessEquivalentToTrivialModuleUpperBoundWithSourceH8 : Bool
  carriersForceTrivialModuleUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R645 status: the target-side upper bound is now the
automorphic trivial-module multiplicity upper bound. -/
def currentR645TrivialModuleUpperBoundSnapshot :
    R645TrivialModuleUpperBoundSnapshot where
  proofWorkObligationCount := currentR645TrivialModuleUpperBoundTargetNames.length
  exactImageCarrierObligationCount := 2
  trivialModuleUpperBoundObligationCount := 1
  targetUpperBoundRewrittenToTrivialModule := true
  zeroExcessEquivalentToTrivialModuleUpperBoundWithSourceH8 := true
  carriersForceTrivialModuleUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R645 upper-bound
ledger. -/
theorem currentR645TrivialModuleUpperBoundSnapshot_eq_texStatus :
    currentR645TrivialModuleUpperBoundSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         trivialModuleUpperBoundObligationCount := 1
         targetUpperBoundRewrittenToTrivialModule := true
         zeroExcessEquivalentToTrivialModuleUpperBoundWithSourceH8 := true
         carriersForceTrivialModuleUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R645TrivialModuleUpperBoundSnapshot) := by
  decide

/-- Kernel-checked target names for the R645 upper-bound ledger. -/
theorem currentR645TrivialModuleUpperBoundTargetNames_eq_texStatus :
    currentR645TrivialModuleUpperBoundTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finrank trivialModulePart <= 1"
    ] := by
  rfl

def R645_substantiveTheoremCount : Nat := 7

end FrontC81_H8ResidualTrivialModuleUpperBound
end HCGapL4
end HodgeReduction
