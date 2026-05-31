/-
# HC Gap L4 -- Front C86: target-invariant preimage criterion (R650).

R641--R649 rewrote the surviving target side as vanishing of the
target-invariant excess quotient.  This file removes one more layer of
notation: that quotient vanishes exactly when every target invariant has
a source-invariant preimage under the Matsushima map `j_q`.

This is the element-level target an agent should try to prove next from
actual Matsushima / automorphic input.  It is not a new axiom, not a
rank trick, and not a full-HC closure claim.
-/

import HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC86_H8ResidualTargetInvariantPreimageCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC74_H8ResidualTargetInvariantSaturation
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC84_H8ResidualScalarPreimageQuotientEquivalence
open FrontC85_H8ResidualQuotientUpperBoundNoFinite

section TargetInvariantPreimage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- The element-level target form of quotient vanishing: every target
invariant is the image of a source invariant under `j_q`. -/
def targetInvariantSourcePreimageTarget : Prop :=
  forall beta : B,
    beta ∈ MatsushimaData.target_invariants (A := A) (B := B) ->
      exists alpha : A,
        alpha ∈ MatsushimaData.source_invariants (A := A) (B := B) ∧
          MatsushimaData.j_q (A := A) (B := B) alpha = beta

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R650 substantive theorem (1/7)**: target-invariant image
saturation is exactly the element-level source-preimage property. -/
theorem sourceInvariantImageSaturation_iff_targetInvariantSourcePreimage :
    sourceInvariantImageSaturatesTargetInvariants A B <->
      targetInvariantSourcePreimageTarget A B := by
  constructor
  · intro hsat beta hbeta
    rcases hsat hbeta with ⟨alpha, halpha, hmap⟩
    exact ⟨alpha, halpha, hmap⟩
  · intro hpre beta hbeta
    rcases hpre beta hbeta with ⟨alpha, halpha, hmap⟩
    exact ⟨alpha, halpha, hmap⟩

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R650 substantive theorem (2/7)**: the quotient target vanishes
exactly when every target invariant has a source-invariant preimage. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage :
    targetInvariantExcessQuotient A B = ⊥ <->
      targetInvariantSourcePreimageTarget A B :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
    (A := A) (B := B)).trans
    (sourceInvariantImageSaturation_iff_targetInvariantSourcePreimage
      (A := A) (B := B))

/-- The R650 source-preimage spelling of the same H8 residual package. -/
structure EVIIH8ResidualTargetInvariantPreimageContract
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
  target_invariant_source_preimage :
    targetInvariantSourcePreimageTarget A B

/-- **R650 substantive theorem (3/7)**: quotient-vanishing contract gives
the target-invariant source-preimage contract. -/
def targetInvariantPreimageContract_of_targetInvariantExcessQuotientContract
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualTargetInvariantPreimageContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariant_source_preimage :=
    (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage
      (A := A) (B := B)).1
      O.target_excess_quotient_eq_bot

/-- **R650 substantive theorem (4/7)**: target-invariant source
preimages rebuild the quotient-vanishing contract. -/
def targetInvariantExcessQuotientContract_of_targetInvariantPreimageContract
    (O : EVIIH8ResidualTargetInvariantPreimageContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage
      (A := A) (B := B)).2
      O.target_invariant_source_preimage

/-- **R650 substantive theorem (5/7)**: quotient vanishing and the
element-level target-invariant preimage contract are the same residual
target. -/
theorem residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantPreimage_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantPreimageContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantPreimageContract_of_targetInvariantExcessQuotientContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_targetInvariantPreimageContract
            (A := A) (B := B) O)))

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R650 substantive theorem (6/7)**: under source-H8, the element-level
target-invariant preimage target is the same as the Cartan scalar-preimage
target from R647/R648. -/
theorem targetInvariantSourcePreimage_iff_cartan_scalar_preimage
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantSourcePreimageTarget A B <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage
    (A := A) (B := B)).symm.trans
    (targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := A) (B := B) hsource_H8)

end TargetInvariantPreimage

section Obstruction

/-- **R650 substantive theorem (7/7)**: in the current abstract
interface, exact image and source-H8 still do not force the
target-invariant source-preimage target. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantPreimage :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (targetInvariantSourcePreimageTarget
          TargetBettiSource TargetBettiTarget) := by
  refine ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8, ?_⟩
  intro hpre
  exact counterexample_not_targetInvariantExcessQuotient_eq_bot
    ((targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage
      (A := TargetBettiSource) (B := TargetBettiTarget)).2 hpre)

end Obstruction

/-- R650 target names for route summaries. -/
def currentR650TargetInvariantPreimageTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove every target invariant has a source-invariant j_q-preimage"
]

/-- Machine-readable status for the R650 element-level preimage target. -/
structure R650TargetInvariantPreimageSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetPreimageObligationCount : Nat
  quotientVanishingEquivalentToTargetInvariantPreimage : Bool
  sourceH8SpecializesTargetPreimageToCartanScalarPreimage : Bool
  carriersForceTargetPreimage : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R650 status: the target side is now an element-level preimage
problem for actual Matsushima input; it remains open in the abstract
interface. -/
def currentR650TargetInvariantPreimageSnapshot :
    R650TargetInvariantPreimageSnapshot where
  proofWorkObligationCount := currentR650TargetInvariantPreimageTargetNames.length
  exactImageCarrierObligationCount := 2
  targetPreimageObligationCount := 1
  quotientVanishingEquivalentToTargetInvariantPreimage := true
  sourceH8SpecializesTargetPreimageToCartanScalarPreimage := true
  carriersForceTargetPreimage := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R650 ledger. -/
theorem currentR650TargetInvariantPreimageSnapshot_eq_texStatus :
    currentR650TargetInvariantPreimageSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetPreimageObligationCount := 1
         quotientVanishingEquivalentToTargetInvariantPreimage := true
         sourceH8SpecializesTargetPreimageToCartanScalarPreimage := true
         carriersForceTargetPreimage := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R650TargetInvariantPreimageSnapshot) := by
  decide

/-- Kernel-checked target names for the R650 ledger. -/
theorem currentR650TargetInvariantPreimageTargetNames_eq_texStatus :
    currentR650TargetInvariantPreimageTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove every target invariant has a source-invariant j_q-preimage"
    ] := by
  rfl

def R650_substantiveTheoremCount : Nat := 7

end FrontC86_H8ResidualTargetInvariantPreimageCriterion
end HCGapL4
end HodgeReduction
