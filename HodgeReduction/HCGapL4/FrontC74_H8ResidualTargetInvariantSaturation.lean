/-
# HC Gap L4 -- Front C74: target-invariant saturation (R638).

R637 shows that the R636 carrier side

* `Submodule.map j_q source_invariants = surjectivity_target`;
* `source_invariants = H8`;

does not force the remaining target containment

* `trivialModulePart <= surjectivity_target`.

This file uses the already-closed R554 target identification
`target_invariants = trivialModulePart` to expose the exact target-side
mathematics still missing: the Matsushima image of source invariants must
saturate all target invariants.  Equivalently, under the R636 exact-image
carrier, the live target is

* `target_invariants <= Submodule.map j_q source_invariants`,

and because the opposite inclusion is formal from Matsushima equivariance,
this is the equality

* `Submodule.map j_q source_invariants = target_invariants`.

No new axiom, instance, or stronger premise is introduced.
-/

import HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC74_H8ResidualTargetInvariantSaturation

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC46_TargetSurjectivityContainmentCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC73_H8ResidualExactImageContainmentObstruction

section TargetInvariantSaturation

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

/-- The target-side saturation form of the R636 reverse containment. -/
def targetInvariantSurjectivityTarget : Prop :=
  LE.le
    (MatsushimaData.target_invariants (A := A) (B := B))
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))

/-- The same saturation written directly against the Matsushima image of
source invariants.  Under the R636 exact-image carrier this is equivalent
to `targetInvariantSurjectivityTarget`. -/
def sourceInvariantImageSaturatesTargetInvariants : Prop :=
  LE.le
    (MatsushimaData.target_invariants (A := A) (B := B))
    (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
      (MatsushimaData.source_invariants (A := A) (B := B)))

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R638 substantive theorem (1/12)**: after the already-closed
R554 target identification, the R636 reverse containment is exactly
target-invariant saturation of `surjectivity_target`. -/
theorem targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target :
    targetInvariantSurjectivityTarget A B <->
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
  unfold targetInvariantSurjectivityTarget
  rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R638 substantive theorem (2/12)**: under the R636 exact-image
carrier, target-invariant saturation is the same whether stated against
`surjectivity_target` or directly against the source-invariant image. -/
theorem sourceInvariantImageSaturation_iff_targetInvariantSurjectivity
    (hexact : sourceInvariantExactImageTarget A B) :
    sourceInvariantImageSaturatesTargetInvariants A B <->
      targetInvariantSurjectivityTarget A B := by
  unfold sourceInvariantImageSaturatesTargetInvariants
  unfold targetInvariantSurjectivityTarget
  rw [hexact]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R638 substantive theorem (3/12)**: the R636 target containment is
equivalent to source-invariant image saturation. -/
theorem sourceInvariantImageSaturation_iff_trivialModulePart_le_surjectivity_target
    (hexact : sourceInvariantExactImageTarget A B) :
    sourceInvariantImageSaturatesTargetInvariants A B <->
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :=
  (sourceInvariantImageSaturation_iff_targetInvariantSurjectivity
      (A := A) (B := B) hexact).trans
    (targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target
      (A := A) (B := B))

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R638 substantive theorem (4/12)**: since Matsushima equivariance
already gives the opposite inclusion, saturation is equivalent to exact
equality of the source-invariant image with all target invariants. -/
theorem sourceInvariantImage_eq_targetInvariants_of_saturation
    (hsat : sourceInvariantImageSaturatesTargetInvariants A B) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  apply le_antisymm
  · exact MatsushimaData.j_q_image_invariants_subset_target_invariants
      (A := A) (B := B)
  · exact hsat

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R638 substantive theorem (5/12)**: exact source-invariant image
equality implies the saturation formulation. -/
theorem sourceInvariantImageSaturation_of_sourceInvariantImage_eq_targetInvariants
    (himage :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        MatsushimaData.target_invariants (A := A) (B := B)) :
    sourceInvariantImageSaturatesTargetInvariants A B := by
  unfold sourceInvariantImageSaturatesTargetInvariants
  rw [<- himage]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R638 substantive theorem (6/12)**: the target-side gap can now be
read exactly as the source-invariant image equality
`Submodule.map j_q source_invariants = target_invariants`. -/
theorem sourceInvariantImageSaturation_iff_image_eq_targetInvariants :
    sourceInvariantImageSaturatesTargetInvariants A B <->
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        MatsushimaData.target_invariants (A := A) (B := B) :=
  Iff.intro
    (sourceInvariantImage_eq_targetInvariants_of_saturation (A := A) (B := B))
    (sourceInvariantImageSaturation_of_sourceInvariantImage_eq_targetInvariants
      (A := A) (B := B))

/-- The R638 target-invariant saturation spelling of the R636 contract. -/
structure EVIIH8ResidualTargetInvariantSaturationContract
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
  target_invariant_saturation : targetInvariantSurjectivityTarget A B

/-- **R638 substantive theorem (7/12)**: the R636 containment contract
gives the target-invariant saturation contract by the R554 target
identification. -/
def targetInvariantSaturationContract_of_exactImageContainmentContract
    (O : EVIIH8ResidualExactImageContainmentContract A B) :
    EVIIH8ResidualTargetInvariantSaturationContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariant_saturation :=
    (targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target
      (A := A) (B := B)).2
      O.trivialModulePart_le_surjectivity_target

/-- **R638 substantive theorem (8/12)**: the target-invariant saturation
contract rebuilds the R636 containment contract. -/
def exactImageContainmentContract_of_targetInvariantSaturationContract
    (O : EVIIH8ResidualTargetInvariantSaturationContract A B) :
    EVIIH8ResidualExactImageContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_le_surjectivity_target :=
    (targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target
      (A := A) (B := B)).1
      O.target_invariant_saturation

/-- **R638 substantive theorem (9/12)**: the R636 containment contract
and the R638 target-invariant saturation contract are the same inhabited
residual target. -/
theorem residual_exactImageContainment_nonempty_iff_targetInvariantSaturation_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantSaturationContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantSaturationContract_of_exactImageContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageContainmentContract_of_targetInvariantSaturationContract
            (A := A) (B := B) O)))

/-- **R638 substantive theorem (10/12)**: constructor form for the next
attack.  Exact image plus source-H8 plus source-invariant image
saturation gives the R636 containment contract. -/
def exactImageContainmentContract_of_sourceInvariantImageSaturation
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hsat : sourceInvariantImageSaturatesTargetInvariants A B) :
    EVIIH8ResidualExactImageContainmentContract A B where
  source_invariants_exact_image := hexact
  source_invariants_eq_H8 := hsource_H8
  trivialModulePart_le_surjectivity_target :=
    (sourceInvariantImageSaturation_iff_trivialModulePart_le_surjectivity_target
      (A := A) (B := B) hexact).1 hsat

end TargetInvariantSaturation

section Obstruction

/-- **R638 obstruction theorem (11/12)**: in the existing countermodel,
the target-invariant saturation form fails. -/
theorem counterexample_not_targetInvariantSurjectivity :
    Not
      (targetInvariantSurjectivityTarget
        TargetBettiSource TargetBettiTarget) := by
  intro hsat
  exact counterexample_not_trivialModulePart_le_surjectivity_target
    ((targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target
      (A := TargetBettiSource) (B := TargetBettiTarget)).1 hsat)

/-- **R638 obstruction theorem (12/12)**: equivalently, the R636 exact
image carrier still does not make the source-invariant image saturate all
target invariants. -/
theorem counterexample_not_sourceInvariantImageSaturation :
    Not
      (sourceInvariantImageSaturatesTargetInvariants
        TargetBettiSource TargetBettiTarget) := by
  intro hsat
  exact counterexample_not_targetInvariantSurjectivity
    ((sourceInvariantImageSaturation_iff_targetInvariantSurjectivity
      (A := TargetBettiSource) (B := TargetBettiTarget)
      counterexample_sourceInvariantExactImageTarget).1 hsat)

/-- The current abstract interface with R636 carriers does not force the
target-invariant saturation theorem. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantSaturation :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (targetInvariantSurjectivityTarget
          TargetBettiSource TargetBettiTarget) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_targetInvariantSurjectivity⟩

/-- The same obstruction in the direct source-invariant image form. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageSaturation :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (sourceInvariantImageSaturatesTargetInvariants
          TargetBettiSource TargetBettiTarget) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_sourceInvariantImageSaturation⟩

end Obstruction

/-- R638 target names for route summaries. -/
def currentR638TargetInvariantSaturationTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove Submodule.map j_q source_invariants = target_invariants"
]

/-- Machine-readable status for the R638 target-invariant saturation
normalization. -/
structure R638TargetInvariantSaturationSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetSaturationObligationCount : Nat
  targetContainmentRewrittenAsTargetInvariantSaturation : Bool
  targetInvariantSaturationEquivalentToImageEquality : Bool
  carriersForceTargetInvariantSaturation : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R638 status: the remaining target theorem is now the exact
Matsushima image-saturation equality for target invariants, and the same
countermodel shows the carrier side alone still does not force it. -/
def currentR638TargetInvariantSaturationSnapshot :
    R638TargetInvariantSaturationSnapshot where
  proofWorkObligationCount := currentR638TargetInvariantSaturationTargetNames.length
  exactImageCarrierObligationCount := 2
  targetSaturationObligationCount := 1
  targetContainmentRewrittenAsTargetInvariantSaturation := true
  targetInvariantSaturationEquivalentToImageEquality := true
  carriersForceTargetInvariantSaturation := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R638 target-invariant
saturation ledger. -/
theorem currentR638TargetInvariantSaturationSnapshot_eq_texStatus :
    currentR638TargetInvariantSaturationSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetSaturationObligationCount := 1
         targetContainmentRewrittenAsTargetInvariantSaturation := true
         targetInvariantSaturationEquivalentToImageEquality := true
         carriersForceTargetInvariantSaturation := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R638TargetInvariantSaturationSnapshot) := by
  decide

/-- Kernel-checked target names for the R638 ledger. -/
theorem currentR638TargetInvariantSaturationTargetNames_eq_texStatus :
    currentR638TargetInvariantSaturationTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove Submodule.map j_q source_invariants = target_invariants"
    ] := by
  rfl

def R638_substantiveTheoremCount : Nat := 16

end FrontC74_H8ResidualTargetInvariantSaturation
end HCGapL4
end HodgeReduction
