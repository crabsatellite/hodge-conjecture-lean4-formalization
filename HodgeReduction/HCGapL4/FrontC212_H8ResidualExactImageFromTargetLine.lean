/-
# HC Gap L4 -- Front C212: exact image from the target line (R778).

R778 checks the current R776 three-field frontier:

* exact image of source invariants;
* `h^4 in compactDual`;
* exact target-line equality.

The review gate asked whether the latter two fields, plus the Cartan/H8 line
input, force exact image.  The answer in the current interface is no.  The
existing one-dimensional exact-image obstruction already satisfies the
compact-dual generator, the target-line equality, and the `H8 = span {h^4}`
line.  Exact image still fails because `MatsushimaSurjectivityData` does not
pin `surjectivity_target` to `target_invariants`.

The final theorem in this file records the positive sanity check: if that
missing projection equality is supplied locally, the R776 target-line data
does imply exact image.  This is diagnostic only; it is not added to the
main frontier as a new premise.
-/

import HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence
import HodgeReduction.HCGapL4.FrontC211_H8ResidualCompactDualTargetLineUnifiedSurfaces

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC212_H8ResidualExactImageFromTargetLine

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC98_H8ResidualExactImageIndependence
open FrontC103_H8ResidualExactImageQuotientIndependence
open FrontC211_H8ResidualCompactDualTargetLineUnifiedSurfaces

/-- The R780-style Cartan/H8 line input, stated locally for the R778 audit.
In the current infrastructure this is already the `CompactDualData` field,
so it is not a new frontier premise. -/
def cartanH8IsHpowFourLine (A : Type*) [CommRing A] [Algebra Rat A]
    [CohomologyRing A] [KaehlerClass A] [CompactDualData A] : Prop :=
  CompactDualData.H8 (A := A) =
    Submodule.span Rat ({((KaehlerClass.h : A) ^ 4)} : Set A)

/-- **R778 obstruction theorem (1/8)**: the explicit one-dimensional
countermodel has the current compact-dual generator field. -/
theorem r778_countermodel_h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual
      (A := ExactImageObstructionSource)
      (B := ExactImageObstructionTarget)).carrier
      ((KaehlerClass.h : ExactImageObstructionSource) ^ 4) := by
  change ((1 : Rat) ^ 4) ∈ (⊤ : Submodule Rat Rat)
  trivial

/-- **R778 obstruction theorem (2/8)**: the same countermodel satisfies the
current exact target-line equality. -/
theorem r778_countermodel_target_invariants_eq_h_pow_four_line :
    MatsushimaData.target_invariants
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) =
      Submodule.span Rat
        ({MatsushimaData.j_q
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget)
          ((KaehlerClass.h : ExactImageObstructionSource) ^ 4)} :
          Set ExactImageObstructionTarget) := by
  apply le_antisymm
  · change
      (⊤ : Submodule Rat ExactImageObstructionTarget) ≤
        Submodule.span Rat
          ({MatsushimaData.j_q
            (A := ExactImageObstructionSource)
            (B := ExactImageObstructionTarget)
            ((KaehlerClass.h : ExactImageObstructionSource) ^ 4)} :
            Set ExactImageObstructionTarget)
    exact counterexample_trivialModulePart_le_h_pow_four_line
  · intro x _
    trivial

/-- **R778 obstruction theorem (3/8)**: the countermodel satisfies the local
Cartan/H8 line input.  Hence that input does not kill the obstruction. -/
theorem r778_countermodel_survives_cartan_h8_line :
    cartanH8IsHpowFourLine ExactImageObstructionSource := by
  exact CompactDualData.H8_eq_span_h_pow_4 (A := ExactImageObstructionSource)

/-- **R778 obstruction theorem (4/8)**: the exact failure point in the
countermodel is the unbound `surjectivity_target`; it is not forced to be
`target_invariants`. -/
theorem r778_countermodel_surjectivity_target_ne_target_invariants :
    MatsushimaSurjectivityData.surjectivity_target
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) ≠
      MatsushimaData.target_invariants
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) := by
  intro htarget
  change
    (⊥ : Submodule Rat ExactImageObstructionTarget) =
      (⊤ : Submodule Rat ExactImageObstructionTarget) at htarget
  have hone_bot :
      (1 : ExactImageObstructionTarget) ∈
        (⊥ : Submodule Rat ExactImageObstructionTarget) := by
    rw [htarget]
    trivial
  change (1 : Rat) = 0 at hone_bot
  norm_num at hone_bot

/-- **R778 obstruction theorem (5/8)**: compact-dual generator membership,
exact target-line equality, and the Cartan/H8 line still do not force exact
image in the current abstract Matsushima interface. -/
theorem r778_compactDual_targetLine_cartanLine_do_not_force_exactImage :
    (MatsushimaCompactDualData.compactDual
      (A := ExactImageObstructionSource)
      (B := ExactImageObstructionTarget)).carrier
      ((KaehlerClass.h : ExactImageObstructionSource) ^ 4) ∧
    MatsushimaData.target_invariants
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) =
      Submodule.span Rat
        ({MatsushimaData.j_q
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget)
          ((KaehlerClass.h : ExactImageObstructionSource) ^ 4)} :
          Set ExactImageObstructionTarget) ∧
    cartanH8IsHpowFourLine ExactImageObstructionSource ∧
    Not (sourceInvariantExactImageTarget
      ExactImageObstructionSource ExactImageObstructionTarget) :=
  ⟨r778_countermodel_h_pow_four_mem_compactDual,
    r778_countermodel_target_invariants_eq_h_pow_four_line,
    r778_countermodel_survives_cartan_h8_line,
    counterexample_not_sourceInvariantExactImageTarget⟩

section ProjectionPositiveTest

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

/-- **R778 obstruction theorem (6/8)**: the valid positive replacement for
the release-gate trial theorem.  The Cartan/H8 line plus R776 target-line
data imply exact image once the missing projection equality
`surjectivity_target = target_invariants` is supplied locally. -/
theorem r778_exact_image_of_compactDual_targetLine_cartanLine_and_surjectivityTargetProjection
    (hC : cartanH8IsHpowFourLine A)
    (hprojection :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        MatsushimaData.target_invariants (A := A) (B := B))
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          ({MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} : Set B)) :
    sourceInvariantExactImageTarget A B := by
  dsimp [sourceInvariantExactImageTarget]
  have hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    source_invariants_eq_H8_of_h_pow_four_mem_compactDual_targetLineEquality
      (A := A) (B := B) hh_compact hline
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B))
        = Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CompactDualData.H8 (A := A)) := by
          rw [hsource_H8]
    _ = Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (Submodule.span Rat ({((KaehlerClass.h : A) ^ 4)} : Set A)) := by
          rw [hC]
    _ = Submodule.span Rat
          ({MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} : Set B) := by
          rw [Submodule.map_span]
          congr 1
          ext y
          simp
    _ = MatsushimaData.target_invariants (A := A) (B := B) := by
          exact hline.symm
    _ = MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B) := by
          exact hprojection.symm

end ProjectionPositiveTest

/-- R778 diagnostic target names for route summaries. -/
def currentR778ExactImageReductionTargetNames : List String := [
  "compact-dual generator plus target-line equality plus the H8 line do not force exact image",
  "missing projection input: surjectivity_target = target_invariants"
]

/-- Machine-readable status for the R778 exact-image reduction audit. -/
structure R778ExactImageReductionSnapshot where
  exactImageDerivable : Bool
  countermodelExists : Bool
  countermodelKilledByCartanLine : Bool
  cartanLinePlusProjectionDerivesExactImage : Bool
  surjectivityTargetProjectionMissing : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R778 status: the countermodel survives the Cartan/H8 line; the
newly isolated missing field is the target-side projection equality. -/
def currentR778ExactImageReductionSnapshot :
    R778ExactImageReductionSnapshot where
  exactImageDerivable := false
  countermodelExists := true
  countermodelKilledByCartanLine := false
  cartanLinePlusProjectionDerivesExactImage := true
  surjectivityTargetProjectionMissing := true
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R778 obstruction theorem (7/8)**: kernel-checked status for the exact
image reduction audit. -/
theorem currentR778ExactImageReductionSnapshot_eq_texStatus :
    currentR778ExactImageReductionSnapshot =
      ({ exactImageDerivable := false
         countermodelExists := true
         countermodelKilledByCartanLine := false
         cartanLinePlusProjectionDerivesExactImage := true
         surjectivityTargetProjectionMissing := true
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R778ExactImageReductionSnapshot) := by
  decide

/-- **R778 obstruction theorem (8/8)**: kernel-checked route-summary labels
for the exact-image reduction audit. -/
theorem currentR778ExactImageReductionTargetNames_eq_texStatus :
    currentR778ExactImageReductionTargetNames = [
      "compact-dual generator plus target-line equality plus the H8 line do not force exact image",
      "missing projection input: surjectivity_target = target_invariants"
    ] := by
  rfl

def R778_substantiveTheoremCount : Nat := 8

end FrontC212_H8ResidualExactImageFromTargetLine
end HCGapL4
end HodgeReduction
