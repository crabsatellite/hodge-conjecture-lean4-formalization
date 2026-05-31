/-
# HC Gap L4 -- Front C84: scalar preimages versus quotient vanishing (R648).

R647 exposed the remaining target-side statement as Cartan scalar
preimages:

* every `beta` in `trivialModulePart` is `j_q (r • h^4)`.

Earlier R641/R642 exposed the same target side as vanishing of the
target-invariant excess quotient.  This file proves those are the same
target once the source carrier is fixed by `source_invariants = H8`.

This is a normalization/identification theorem, not a new EVII
multiplicity theorem and not a full-HC closure claim.
-/

import HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC84_H8ResidualScalarPreimageQuotientEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC74_H8ResidualTargetInvariantSaturation
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC83_H8ResidualCartanImageScalarPreimage

section ScalarQuotientEquivalence

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
/-- **R648 substantive theorem (1/6)**: once `source_invariants = H8`,
source-invariant saturation is exactly the Cartan scalar-preimage
statement from R647. -/
theorem sourceInvariantImageSaturation_iff_cartan_scalar_preimage
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    sourceInvariantImageSaturatesTargetInvariants A B <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) := by
  constructor
  · intro hsat
    have hle :
        CuspidalCohomologyData.trivialModulePart (A := B) <=
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
      simpa [sourceInvariantImageSaturatesTargetInvariants,
        target_invariants_eq_trivialModulePart (A := A) (B := B),
        hsource_H8,
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
        using hsat
    exact
      (trivialModulePart_le_cartanImage_iff_scalar_preimage
        (A := A) (B := B)).1 hle
  · intro hscalar
    have hle :
        CuspidalCohomologyData.trivialModulePart (A := B) <=
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :=
      (trivialModulePart_le_cartanImage_iff_scalar_preimage
        (A := A) (B := B)).2 hscalar
    simpa [sourceInvariantImageSaturatesTargetInvariants,
      target_invariants_eq_trivialModulePart (A := A) (B := B),
      hsource_H8,
      CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
      using hle

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R648 substantive theorem (2/6)**: under `source_invariants = H8`,
the R641 quotient-vanishing target and the R647 Cartan scalar-preimage
target are equivalent. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
    (A := A) (B := B)).trans
    (sourceInvariantImageSaturation_iff_cartan_scalar_preimage
      (A := A) (B := B) hsource_H8)

/-- **R648 substantive theorem (3/6)**: the R647 scalar-preimage contract
gives the R641 quotient-vanishing contract. -/
def targetInvariantExcessQuotientContract_of_cartanScalarUpperBoundContract
    (O : EVIIH8ResidualCartanScalarUpperBoundContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := A) (B := B) O.source_invariants_eq_H8).2
      O.cartan_scalar_preimage

/-- **R648 substantive theorem (4/6)**: the R641 quotient-vanishing
contract gives the R647 scalar-preimage contract. -/
def cartanScalarUpperBoundContract_of_targetInvariantExcessQuotientContract
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualCartanScalarUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  cartan_scalar_preimage :=
    (targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := A) (B := B) O.source_invariants_eq_H8).1
      O.target_excess_quotient_eq_bot

/-- **R648 substantive theorem (5/6)**: the R647 scalar-preimage contract
and the R641 quotient-vanishing contract are the same residual target. -/
theorem residual_cartanScalar_nonempty_iff_targetInvariantExcessQuotient_nonempty :
    Nonempty (EVIIH8ResidualCartanScalarUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_cartanScalarUpperBoundContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanScalarUpperBoundContract_of_targetInvariantExcessQuotientContract
            (A := A) (B := B) O)))

end ScalarQuotientEquivalence

section Obstruction

/-- **R648 substantive theorem (6/6)**: in the current abstract
interface, exact image and source-H8 still do not force either quotient
vanishing or Cartan scalar preimages. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_quotient_or_cartan_scalar :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (targetInvariantExcessQuotient
          TargetBettiSource TargetBettiTarget = ⊥) /\
      Not
        (forall beta : TargetBettiTarget,
          beta ∈ CuspidalCohomologyData.trivialModulePart
              (A := TargetBettiTarget) ->
            exists r : Rat,
              MatsushimaData.j_q
                  (A := TargetBettiSource) (B := TargetBettiTarget)
                (r • ((KaehlerClass.h : TargetBettiSource) ^ 4)) = beta) := by
  refine ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_targetInvariantExcessQuotient_eq_bot, ?_⟩
  intro hscalar
  exact counterexample_not_targetInvariantExcessQuotient_eq_bot
    ((targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := TargetBettiSource) (B := TargetBettiTarget)
      counterexample_source_invariants_eq_H8).2 hscalar)

end Obstruction

/-- R648 target names for route summaries. -/
def currentR648ScalarQuotientTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove targetInvariantExcessQuotient = bot, equivalently Cartan scalar preimages"
]

/-- Machine-readable status for the R648 quotient/scalar equivalence. -/
structure R648ScalarQuotientSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  quotientOrScalarObligationCount : Nat
  quotientVanishingEquivalentToScalarPreimage : Bool
  finiteDimensionalHypothesisNeededForEquivalence : Bool
  carriersForceQuotientOrScalar : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R648 status: quotient vanishing and Cartan scalar preimages
are one live target, not two independent gaps. -/
def currentR648ScalarQuotientSnapshot :
    R648ScalarQuotientSnapshot where
  proofWorkObligationCount := currentR648ScalarQuotientTargetNames.length
  exactImageCarrierObligationCount := 2
  quotientOrScalarObligationCount := 1
  quotientVanishingEquivalentToScalarPreimage := true
  finiteDimensionalHypothesisNeededForEquivalence := false
  carriersForceQuotientOrScalar := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R648 ledger. -/
theorem currentR648ScalarQuotientSnapshot_eq_texStatus :
    currentR648ScalarQuotientSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         quotientOrScalarObligationCount := 1
         quotientVanishingEquivalentToScalarPreimage := true
         finiteDimensionalHypothesisNeededForEquivalence := false
         carriersForceQuotientOrScalar := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R648ScalarQuotientSnapshot) := by
  decide

/-- Kernel-checked target names for the R648 ledger. -/
theorem currentR648ScalarQuotientTargetNames_eq_texStatus :
    currentR648ScalarQuotientTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove targetInvariantExcessQuotient = bot, equivalently Cartan scalar preimages"
    ] := by
  rfl

def R648_substantiveTheoremCount : Nat := 6

end FrontC84_H8ResidualScalarPreimageQuotientEquivalence
end HCGapL4
end HodgeReduction
