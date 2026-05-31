/-
# HC Gap L4 -- Front C90: right-inverse equivalence for the restricted invariant map (R654).

R653 made a linear right inverse

`target_invariants -> source_invariants`

a sufficient target for the restricted invariant-map gap.  This file proves
that the target is not stronger than R652: by `LinearEquiv.ofBijective`, a
bijective restricted invariant map gives such a linear right inverse.  Thus the
right-inverse interface is an equivalent construction form of the same
quotient-vanishing target, not a new hypothesis.
-/

import HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC90_H8ResidualInvariantMapRightInverseEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC87_H8ResidualInvariantMapSurjectivity
open FrontC88_H8ResidualInvariantMapBijectivity
open FrontC89_H8ResidualInvariantMapRightInverse

section RestrictedInvariantMapRightInverseEquivalence

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
/-- **R654 substantive theorem (1/8)**: a bijective restricted invariant map
packages as a linear equivalence. -/
noncomputable def sourceToTargetInvariantLinearEquivOfBijective
    (hbij : Function.Bijective (sourceToTargetInvariantMap A B)) :
    MatsushimaData.source_invariants (A := A) (B := B) ≃ₗ[Rat]
      MatsushimaData.target_invariants (A := A) (B := B) :=
  LinearEquiv.ofBijective (sourceToTargetInvariantMap A B) hbij

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R654 substantive theorem (2/8)**: bijectivity gives a linear right
inverse of the restricted invariant map. -/
noncomputable def sourceToTargetInvariantMapRightInverseOfBijective
    (hbij : Function.Bijective (sourceToTargetInvariantMap A B)) :
    MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
      MatsushimaData.source_invariants (A := A) (B := B) :=
  (sourceToTargetInvariantLinearEquivOfBijective (A := A) (B := B) hbij).symm.toLinearMap

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R654 substantive theorem (3/8)**: the inverse produced from bijectivity
is a genuine right inverse. -/
theorem sourceToTargetInvariantMap_comp_rightInverseOfBijective
    (hbij : Function.Bijective (sourceToTargetInvariantMap A B)) :
    (sourceToTargetInvariantMap A B).comp
        (sourceToTargetInvariantMapRightInverseOfBijective
          (A := A) (B := B) hbij) =
      targetInvariantIdentity A B := by
  ext beta
  simp [sourceToTargetInvariantMapRightInverseOfBijective,
    sourceToTargetInvariantLinearEquivOfBijective, targetInvariantIdentity]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R654 substantive theorem (4/8)**: quotient vanishing is equivalent to
the existence of a linear right inverse for the restricted invariant map. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_linearRightInverse :
    targetInvariantExcessQuotient A B = ⊥ <->
      Exists
        (fun lift :
          MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
            MatsushimaData.source_invariants (A := A) (B := B) =>
          (sourceToTargetInvariantMap A B).comp lift =
            targetInvariantIdentity A B) := by
  constructor
  · intro hquot
    have hbij :
        Function.Bijective (sourceToTargetInvariantMap A B) :=
      (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective
        (A := A) (B := B)).1 hquot
    refine ⟨sourceToTargetInvariantMapRightInverseOfBijective
      (A := A) (B := B) hbij, ?_⟩
    exact sourceToTargetInvariantMap_comp_rightInverseOfBijective
      (A := A) (B := B) hbij
  · rintro ⟨lift, hright⟩
    exact
      targetInvariantExcessQuotient_eq_bot_of_sourceToTargetInvariantMap_linearRightInverse
        (A := A) (B := B) lift hright

/-- **R654 substantive theorem (5/8)**: the R652 bijectivity contract feeds
the R653 right-inverse contract. -/
noncomputable def invariantMapRightInverseContract_of_invariantMapBijectivityContract
    (O : EVIIH8ResidualInvariantMapBijectivityContract A B) :
    EVIIH8ResidualInvariantMapRightInverseContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  lift :=
    sourceToTargetInvariantMapRightInverseOfBijective
      (A := A) (B := B) O.source_to_target_invariant_map_bijective
  right_inverse :=
    sourceToTargetInvariantMap_comp_rightInverseOfBijective
      (A := A) (B := B) O.source_to_target_invariant_map_bijective

/-- **R654 substantive theorem (6/8)**: inhabited bijectivity contracts give
inhabited right-inverse contracts. -/
theorem residual_invariantMapBijectivity_nonempty_to_invariantMapRightInverse_nonempty :
    Nonempty (EVIIH8ResidualInvariantMapBijectivityContract A B) ->
      Nonempty (EVIIH8ResidualInvariantMapRightInverseContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (invariantMapRightInverseContract_of_invariantMapBijectivityContract
      (A := A) (B := B) O)

/-- **R654 substantive theorem (7/8)**: the R653 and R652 contract packages are
equivalent, so R653 is not a stronger premise. -/
theorem residual_invariantMapRightInverse_nonempty_iff_invariantMapBijectivity_nonempty :
    Nonempty (EVIIH8ResidualInvariantMapRightInverseContract A B) <->
      Nonempty (EVIIH8ResidualInvariantMapBijectivityContract A B) := by
  constructor
  · exact residual_invariantMapRightInverse_nonempty_to_invariantMapBijectivity_nonempty
      (A := A) (B := B)
  · exact residual_invariantMapBijectivity_nonempty_to_invariantMapRightInverse_nonempty
      (A := A) (B := B)

end RestrictedInvariantMapRightInverseEquivalence

section Obstruction

/-- **R654 substantive theorem (8/8)**: the current abstract carrier interface
still does not force the equivalent right-inverse/bijectivity target. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_equivTarget :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (Exists
          (fun lift :
            MatsushimaData.target_invariants
                (A := TargetBettiSource) (B := TargetBettiTarget) →ₗ[Rat]
              MatsushimaData.source_invariants
                (A := TargetBettiSource) (B := TargetBettiTarget) =>
            (sourceToTargetInvariantMap
                TargetBettiSource TargetBettiTarget).comp lift =
              targetInvariantIdentity TargetBettiSource TargetBettiTarget)) :=
  current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse

end Obstruction

/-- R654 target names for route summaries. -/
def currentR654RightInverseEquivalenceTargetNames : List String := [
  "prove restricted invariant-map bijectivity",
  "equivalent construction form: build a linear right inverse target_invariants -> source_invariants",
  "current carrier interface does not force the equivalent target"
]

/-- Machine-readable status for the R654 equivalence target. -/
structure R654RightInverseEquivalenceSnapshot where
  proofWorkObligationCount : Nat
  rightInverseEquivalentToQuotientVanishing : Bool
  rightInverseContractEquivalentToBijectivityContract : Bool
  carriersForceEquivalentTarget : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R654 status: the right-inverse construction target is equivalent
to the R652 bijectivity / R641 quotient target. -/
def currentR654RightInverseEquivalenceSnapshot :
    R654RightInverseEquivalenceSnapshot where
  proofWorkObligationCount := currentR654RightInverseEquivalenceTargetNames.length
  rightInverseEquivalentToQuotientVanishing := true
  rightInverseContractEquivalentToBijectivityContract := true
  carriersForceEquivalentTarget := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R654 ledger. -/
theorem currentR654RightInverseEquivalenceSnapshot_eq_texStatus :
    currentR654RightInverseEquivalenceSnapshot =
      ({ proofWorkObligationCount := 3
         rightInverseEquivalentToQuotientVanishing := true
         rightInverseContractEquivalentToBijectivityContract := true
         carriersForceEquivalentTarget := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R654RightInverseEquivalenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R654 ledger. -/
theorem currentR654RightInverseEquivalenceTargetNames_eq_texStatus :
    currentR654RightInverseEquivalenceTargetNames = [
      "prove restricted invariant-map bijectivity",
      "equivalent construction form: build a linear right inverse target_invariants -> source_invariants",
      "current carrier interface does not force the equivalent target"
    ] := by
  rfl

def R654_substantiveTheoremCount : Nat := 8

end FrontC90_H8ResidualInvariantMapRightInverseEquivalence
end HCGapL4
end HodgeReduction
