/-
# HC Gap L4 — first two-nontrivial-factory product-cycle chain (R227).

R226 proved that two `InternalCycleActionData_SHSM_WithProductCycle`
instances chain via SHSM2 composition, but the only regression
available was `identity ∘ R223` because R223 (pt → E) and R224
(pt → ℙ¹) share a source but not a target. R227 closes the gap by
constructing the first composable nontrivial factory pair:

* **D₁**: `pt → ℙ¹` codim `0 → 0` with cycle provenance on
  `pt × ℙ¹` (R224 carrier).
* **D₂**: `ℙ¹ → ℙ¹` codim `0 → 1` with cycle provenance on
  `ℙ¹ × ℙ¹` (R227 toy carrier).

Applying R226's `ProductCycleFactory_compose_to_SHSM2` chains
`D₁ ∘ D₂ : pt → ℙ¹` codim `0 → 1`, giving a new HC route through
two nontrivial factory packages.

## What R227 (this file) provides (all kernel-pure)

* `cycleAction_H0_to_H0_pointToProjectiveLine` — codim-preserving
  action `H^0(pt) →ₗ[ℚ] H^0(ℙ¹)` (identity ℚ → ℚ).
* `cycleAction_H0_to_H2_projectiveLineSelf` — codim-shifting action
  `H^0(ℙ¹) →ₗ[ℚ] H^2(ℙ¹)` (identity ℚ → ℚ).
* `internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine_codim0_to_codim0` —
  D₁ factory.
* `internalCycleActionData_SHSM_WithProductCycle_projectiveLine_self_codim0_to_codim1` —
  D₂ factory.
* `SHSM2_point_to_projectiveLine_via_two_nontrivial_productCycleFactories` —
  chained SHSM2 from D₁ ∘ D₂.
* `VarietyHCAt_projectiveLine_codim1_via_two_nontrivial_productCycleFactories` —
  3rd kernel-pure HC route for ℙ¹ codim 1 via the two-factory chain
  (first one exercising two genuinely nontrivial product-cycle
  factories).

## What R227 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT define a composed cycle class on `pt × ℙ¹ × ℙ¹`
  (chain composition drops both cycleClass fields).
* Does NOT implement true Chow composition of cycles.
* Does NOT prove the diagonal/identity correspondence on ℙ¹ × ℙ¹
  semantically equals the toy `(1 : ℚ)` cycle.
* Does NOT implement true Künneth for `ℙ¹ × ℙ¹`.

All R227 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.SHSM2MultiStep
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.GenericCycleActionMultiStep
import HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
import HodgeReduction.HCGapL4.PtToProjectiveLineProductCycleFactory
import HodgeReduction.HCGapL4.ProductCohomologyPointProjectiveLine
import HodgeReduction.HCGapL4.ProductCycleFactoryLifter
import HodgeReduction.HCGapL4.ProductCycleFactoryComposition
import HodgeReduction.HCGapL4.ProductCohomologyProjectiveLineSelf

namespace HodgeReduction
namespace HCGapL4
namespace ProductCycleFactoryProjectiveLineSelf

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.SHSM2MultiStep
open HodgeReduction.HCGapL4.GenericCycleAction
open HodgeReduction.HCGapL4.GenericCycleActionMultiStep
open HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
open HodgeReduction.HCGapL4.PtToProjectiveLineProductCycleFactory
open HodgeReduction.HCGapL4.ProductCohomologyPointProjectiveLine
open HodgeReduction.HCGapL4.ProductCycleFactoryLifter
open HodgeReduction.HCGapL4.ProductCycleFactoryComposition
open HodgeReduction.HCGapL4.ProductCohomologyProjectiveLineSelf

/-! ## Section 1: D₁ — codim-preserving action `H^0(pt) → H^0(ℙ¹)` -/

/-- **R227 action D₁**: identity ℚ → ℚ at the carrier level.
Represents the constant map `pt → ℙ¹` cohomologically (pulled back
on fundamental classes). -/
noncomputable def cycleAction_H0_to_H0_pointToProjectiveLine :
    TrivialPoint.varietyCohomology_point.H 0 →ₗ[ℚ]
    ProjectiveLine.VarietyCohomologyData_projectiveLine.H 0 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

@[simp] theorem cycleAction_H0_to_H0_pointToProjectiveLine_apply (x : ℚ) :
    cycleAction_H0_to_H0_pointToProjectiveLine x = x := rfl

/-- **R227 D₁ factory** (pt → ℙ¹ codim 0 → 0): product-cycle factory at
codim-preserving shift, using R224's `pt × ℙ¹` product carrier with
cycleClass `(1 : ℚ) = pointTimesProjectiveLineCycleClass 0 ()` at
`cycleCodim = 0`. Substantively nontrivial: the action carries pt's
fundamental class to ℙ¹'s fundamental class via the carrier-level
identity ℚ → ℚ, and the cycle provenance records the codim-0
generator of `pt × ℙ¹`. -/
noncomputable def internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine_codim0_to_codim0 :
    InternalCycleActionData_SHSM_WithProductCycle
      TrivialPoint.varietyCohomology_point
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      VarietyCohomologyData_pointTimesProjectiveLine
      TrivialPoint.algClasses_point
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      AlgebraicClassesData_pointTimesProjectiveLine
      0 0 0 where
  toInternalCycleActionData_SHSM := {
    action := cycleAction_H0_to_H0_pointToProjectiveLine
    preservesAlgClasses := by
      intro x _
      exact Submodule.mem_top
    hodgeSurj := by
      intro x _
      refine ⟨x, ?_, ?_⟩
      · show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
        rw [TrivialWeight.piece_ℚ_w0_zero]
        exact Submodule.mem_top
      · rfl
    shift := 0
    h_shift := rfl
    pieceShift := by
      intro p_idx
      fin_cases p_idx
      show Submodule.map _ _ ≤ TrivialWeight.piece_ℚ_w0 ⟨0 + 0, by omega⟩
      show Submodule.map _ _ ≤ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      conv_rhs => rw [TrivialWeight.piece_ℚ_w0_zero]
      exact le_top
  }
  cycleClass := pointTimesProjectiveLineCycleClass 0 ()
  cycleClass_mem_algClasses := by
    show pointTimesProjectiveLineCycleClass 0 () ∈
      AlgebraicClassesData_pointTimesProjectiveLine.algClasses 0
    apply Submodule.subset_span
    exact Set.mem_range_self ()

/-! ## Section 2: D₂ — codim-shifting action `H^0(ℙ¹) → H^2(ℙ¹)` -/

/-- **R227 action D₂**: identity ℚ → ℚ at the carrier level for the
`ℙ¹ → ℙ¹` self-correspondence at codim shift 1. Models a degree-1
divisor's cohomological action. -/
noncomputable def cycleAction_H0_to_H2_projectiveLineSelf :
    ProjectiveLine.VarietyCohomologyData_projectiveLine.H 0 →ₗ[ℚ]
    ProjectiveLine.VarietyCohomologyData_projectiveLine.H 2 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

@[simp] theorem cycleAction_H0_to_H2_projectiveLineSelf_apply (x : ℚ) :
    cycleAction_H0_to_H2_projectiveLineSelf x = x := rfl

/-- **R227 D₂ factory** (ℙ¹ → ℙ¹ codim 0 → 1): product-cycle factory at
codim-shift 1, using R227's toy `ℙ¹ × ℙ¹` carrier with cycleClass
`(1 : ℚ) = projectiveLineSelfCycleClass 1 ()` at `cycleCodim = 1`.
Substantively nontrivial: the action models a degree-1 divisor's
cohomological action, the cycle provenance records the codim-1
generator of the toy `ℙ¹ × ℙ¹`. -/
noncomputable def internalCycleActionData_SHSM_WithProductCycle_projectiveLine_self_codim0_to_codim1 :
    InternalCycleActionData_SHSM_WithProductCycle
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      VarietyCohomologyData_projectiveLineSelf
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      AlgebraicClassesData_projectiveLineSelf
      0 1 1 where
  toInternalCycleActionData_SHSM := {
    action := cycleAction_H0_to_H2_projectiveLineSelf
    preservesAlgClasses := by
      intro x _
      exact Submodule.mem_top
    hodgeSurj := by
      intro x _
      refine ⟨x, ?_, ?_⟩
      · show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
        rw [TrivialWeight.piece_ℚ_w0_zero]
        exact Submodule.mem_top
      · rfl
    shift := 1
    h_shift := rfl
    pieceShift := by
      intro p_idx
      fin_cases p_idx
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 1, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
      rw [ProjectiveLine.piece_ℚ_Tate2_one]
      exact le_top
  }
  cycleClass := projectiveLineSelfCycleClass 1 ()
  cycleClass_mem_algClasses := by
    show projectiveLineSelfCycleClass 1 () ∈
      AlgebraicClassesData_projectiveLineSelf.algClasses 1
    apply Submodule.subset_span
    exact Set.mem_range_self ()

/-! ## Section 3: chain D₁ ∘ D₂ via R226 two-factory composition -/

/-- **R227 first two-nontrivial-factory SHSM2 chain**: chain D₁ (pt → ℙ¹
codim 0 → 0) and D₂ (ℙ¹ → ℙ¹ codim 0 → 1) via R226's
`ProductCycleFactory_compose_to_SHSM2`. Output SHSM2 at (0, 1). -/
theorem SHSM2_point_to_projectiveLine_via_two_nontrivial_productCycleFactories :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      TrivialPoint.algClasses_point
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      0 1 :=
  ProductCycleFactory_compose_to_SHSM2
    internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine_codim0_to_codim0
    internalCycleActionData_SHSM_WithProductCycle_projectiveLine_self_codim0_to_codim1

/-- **R227 3rd kernel-pure HC route for ℙ¹ codim 1**: via the
two-nontrivial-factory chain D₁ ∘ D₂. First HC route in this codebase
that exercises two genuinely nontrivial product-cycle factories. -/
theorem VarietyHCAt_projectiveLine_codim1_via_two_nontrivial_productCycleFactories :
    VarietyHCAt ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine 1 :=
  VarietyHCAt_of_productCycleFactory_compose
    internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine_codim0_to_codim0
    internalCycleActionData_SHSM_WithProductCycle_projectiveLine_self_codim0_to_codim1
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_TwoNontrivialFactoryChain_To_TrueChowComposition**: real
composition of two algebraic correspondences via Chow-cycle push-pull-cup.
R227 chains SHSM2 packages linearly without composing cycle classes. -/
abbrev L4_G_TwoNontrivialFactoryChain_To_TrueChowComposition : Prop := True

/-- **L4-G_ProjectiveLineSelfFactory_NotTrueDiagonalCorrespondence**: D₂'s
action is a carrier-level identity `(x : ℚ) ↦ (x : ℚ)`; it is NOT the
true diagonal correspondence `[Δ_{ℙ¹}] ⊂ ℙ¹ × ℙ¹`. The toy `ℙ¹ × ℙ¹`
carrier has only one H^2 generator instead of the real two
`[ℙ¹×pt]` / `[pt×ℙ¹]`, and the diagonal class would require both. -/
abbrev L4_G_ProjectiveLineSelfFactory_NotTrueDiagonalCorrespondence :
    Prop := True

/-- **L4-G_ProductCycleFactoryChain_NoCycleLevelComposition**: explicit
non-claim: chaining D₁ and D₂ does NOT produce a composed cycleClass on
`pt × ℙ¹ × ℙ¹`. Provenance is dropped at composition time. -/
abbrev L4_G_ProductCycleFactoryChain_NoCycleLevelComposition : Prop := True

/-- **L4-G_TwoFactoryChain_To_E7MultiStepMT**: scaling the
two-nontrivial-factory chain pattern to the E_7 / EVII Shimura
multi-step MT correspondence chain. Requires factory instances for
the actual Shimura-side varieties. Deferred. -/
abbrev L4_G_TwoFactoryChain_To_E7MultiStepMT : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R227 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R227_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R227 non-closure (2/4)**: does NOT implement true Chow
composition of cycles. -/
theorem R227_does_not_implement_true_chow_composition : True := trivial

/-- **R227 non-closure (3/4)**: does NOT prove the product cycles
semantically induce the actions. Actions remain explicit inputs;
cycle classes remain paper-trail. -/
theorem R227_does_not_prove_cycles_induce_actions : True := trivial

/-- **R227 non-closure (4/4)**: only demonstrates that two nontrivial
product-cycle factory packages can be chained at the SHSM2 level.
No cycle-level composition, no Künneth, no real ℙ¹ × ℙ¹. -/
theorem R227_only_two_nontrivial_factory_SHSM2_chain : True := trivial

end ProductCycleFactoryProjectiveLineSelf
end HCGapL4
end HodgeReduction
