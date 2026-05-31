/-
# HC Gap L4 -- Front C91: right inverse versus Cartan scalar preimages (R655).

R654 proves that a linear right inverse for the restricted invariant map is
equivalent to the quotient-vanishing target.  R648 proves that, once
`source_invariants = H8`, the same quotient-vanishing target is equivalent to
the Cartan scalar-preimage theorem.

This file composes those two routes.  The purpose is to make the next attack
unambiguous: constructing a right inverse and proving Cartan scalar preimages
are the same target-side Matsushima surjectivity problem, not two independent
gaps.
-/

import HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC91_H8ResidualRightInverseScalarPreimageEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC83_H8ResidualCartanImageScalarPreimage
open FrontC84_H8ResidualScalarPreimageQuotientEquivalence
open FrontC87_H8ResidualInvariantMapSurjectivity
open FrontC88_H8ResidualInvariantMapBijectivity
open FrontC89_H8ResidualInvariantMapRightInverse
open FrontC90_H8ResidualInvariantMapRightInverseEquivalence

section RightInverseScalarEquivalence

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
/-- **R655 substantive theorem (1/6)**: after the source carrier is fixed to
`H8`, the linear right-inverse construction target is exactly the Cartan
scalar-preimage theorem. -/
theorem sourceToTargetInvariantMap_linearRightInverse_iff_cartan_scalar_preimage
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (Exists
        (fun lift :
          MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
            MatsushimaData.source_invariants (A := A) (B := B) =>
          (sourceToTargetInvariantMap A B).comp lift =
            targetInvariantIdentity A B)) <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_linearRightInverse
    (A := A) (B := B)).symm.trans
    (targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := A) (B := B) hsource_H8)

/-- **R655 substantive theorem (2/6)**: a right-inverse contract feeds the
older Cartan scalar-preimage contract. -/
def cartanScalarUpperBoundContract_of_invariantMapRightInverseContract
    (O : EVIIH8ResidualInvariantMapRightInverseContract A B) :
    EVIIH8ResidualCartanScalarUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  cartan_scalar_preimage :=
    (sourceToTargetInvariantMap_linearRightInverse_iff_cartan_scalar_preimage
      (A := A) (B := B) O.source_invariants_eq_H8).1
      ⟨O.lift, O.right_inverse⟩

/-- **R655 substantive theorem (3/6)**: a Cartan scalar-preimage contract
constructs an equivalent right-inverse contract. -/
noncomputable def invariantMapRightInverseContract_of_cartanScalarUpperBoundContract
    (O : EVIIH8ResidualCartanScalarUpperBoundContract A B) :
    EVIIH8ResidualInvariantMapRightInverseContract A B := by
  classical
  have hright :
      Exists
        (fun lift :
          MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
            MatsushimaData.source_invariants (A := A) (B := B) =>
          (sourceToTargetInvariantMap A B).comp lift =
            targetInvariantIdentity A B) :=
    (sourceToTargetInvariantMap_linearRightInverse_iff_cartan_scalar_preimage
      (A := A) (B := B) O.source_invariants_eq_H8).2
      O.cartan_scalar_preimage
  exact
    { source_invariants_exact_image := O.source_invariants_exact_image
      source_invariants_eq_H8 := O.source_invariants_eq_H8
      lift := Classical.choose hright
      right_inverse := Classical.choose_spec hright }

/-- **R655 substantive theorem (4/6)**: right-inverse contracts and Cartan
scalar-preimage contracts are equivalent residual packages. -/
theorem residual_invariantMapRightInverse_nonempty_iff_cartanScalar_nonempty :
    Nonempty (EVIIH8ResidualInvariantMapRightInverseContract A B) <->
      Nonempty (EVIIH8ResidualCartanScalarUpperBoundContract A B) := by
  constructor
  · intro h
    refine h.elim ?_
    intro O
    exact Nonempty.intro
      (cartanScalarUpperBoundContract_of_invariantMapRightInverseContract
        (A := A) (B := B) O)
  · intro h
    refine h.elim ?_
    intro O
    exact Nonempty.intro
      (invariantMapRightInverseContract_of_cartanScalarUpperBoundContract
        (A := A) (B := B) O)

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R655 substantive theorem (5/6)**: composing R654 and R648 gives a direct
quotient-free formulation for the current target. -/
theorem sourceToTargetInvariantMap_bijective_iff_cartan_scalar_preimage
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Function.Bijective (sourceToTargetInvariantMap A B) <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective
    (A := A) (B := B)).symm.trans
    (targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
      (A := A) (B := B) hsource_H8)

end RightInverseScalarEquivalence

section Obstruction

/-- **R655 substantive theorem (6/6)**: exact image and source-H8 still do not
force either side of the equivalent right-inverse / scalar-preimage target in
the current abstract interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_or_scalar :
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
              targetInvariantIdentity TargetBettiSource TargetBettiTarget)) ∧
      Not
        (forall beta : TargetBettiTarget,
          beta ∈ CuspidalCohomologyData.trivialModulePart
              (A := TargetBettiTarget) ->
            exists r : Rat,
              MatsushimaData.j_q
                  (A := TargetBettiSource) (B := TargetBettiTarget)
                (r • ((KaehlerClass.h : TargetBettiSource) ^ 4)) = beta) := by
  rcases current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse
    with ⟨hexact, hsource, hnotRight⟩
  rcases current_interface_with_exactImage_sourceH8_does_not_force_quotient_or_cartan_scalar
    with ⟨_, _, _, hnotScalar⟩
  exact ⟨hexact, hsource, hnotRight, hnotScalar⟩

end Obstruction

/-- R655 target names for route summaries. -/
def currentR655RightInverseScalarTargetNames : List String := [
  "prove source_invariants = H8",
  "equivalent target: build a linear right inverse target_invariants -> source_invariants",
  "equivalent target: prove Cartan scalar preimages for trivialModulePart"
]

/-- Machine-readable status for the R655 right-inverse/scalar equivalence. -/
structure R655RightInverseScalarSnapshot where
  proofWorkObligationCount : Nat
  rightInverseEquivalentToScalarPreimage : Bool
  bijectivityEquivalentToScalarPreimage : Bool
  carrierFactsForceEquivalentTarget : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R655 status: the right-inverse and Cartan scalar-preimage attack
interfaces are the same target once source-H8 is fixed. -/
def currentR655RightInverseScalarSnapshot :
    R655RightInverseScalarSnapshot where
  proofWorkObligationCount := currentR655RightInverseScalarTargetNames.length
  rightInverseEquivalentToScalarPreimage := true
  bijectivityEquivalentToScalarPreimage := true
  carrierFactsForceEquivalentTarget := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R655 ledger. -/
theorem currentR655RightInverseScalarSnapshot_eq_texStatus :
    currentR655RightInverseScalarSnapshot =
      ({ proofWorkObligationCount := 3
         rightInverseEquivalentToScalarPreimage := true
         bijectivityEquivalentToScalarPreimage := true
         carrierFactsForceEquivalentTarget := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R655RightInverseScalarSnapshot) := by
  decide

/-- Kernel-checked target names for the R655 ledger. -/
theorem currentR655RightInverseScalarTargetNames_eq_texStatus :
    currentR655RightInverseScalarTargetNames = [
      "prove source_invariants = H8",
      "equivalent target: build a linear right inverse target_invariants -> source_invariants",
      "equivalent target: prove Cartan scalar preimages for trivialModulePart"
    ] := by
  rfl

def R655_substantiveTheoremCount : Nat := 6

end FrontC91_H8ResidualRightInverseScalarPreimageEquivalence
end HCGapL4
end HodgeReduction
