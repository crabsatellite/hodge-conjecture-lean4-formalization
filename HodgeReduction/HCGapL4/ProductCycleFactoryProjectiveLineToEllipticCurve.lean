/-
# HC Gap L4 — first cross-variety product-cycle factory chain pt → ℙ¹ → E (R228).

R227 built the first two-nontrivial-factory chain `pt → ℙ¹ → ℙ¹` where
both factories share `ℙ¹` as the middle target. R228 extends this to
the first **cross-variety** chain pt → ℙ¹ → E, where the middle
variety ℙ¹ differs from the final target E.

The new factory **D₂'**: `ℙ¹ → E` codim `0 → 1` uses a minimal toy
`ℙ¹ × E` carrier (R228's sibling file) and chains with R227's D₁
(pt → ℙ¹ codim 0 → 0) via R226's `ProductCycleFactory_compose_to_SHSM2`.

## What R228 (this file) provides (all kernel-pure)

* `cycleAction_H0_projectiveLine_to_H2_ellipticCurve` — action
  `H^0(ℙ¹) →ₗ[ℚ] H^2(E)` (identity ℚ → ℚ).
* `internalCycleActionData_SHSM_WithProductCycle_projectiveLine_to_ellipticCurve` —
  D₂' factory.
* `SHSM2_point_to_ellipticCurve_via_two_nontrivial_cross_variety_factories` —
  chained SHSM2 pt → E from R227 D₁ ∘ R228 D₂'.
* `VarietyHCAt_ellipticCurve_codim1_via_two_nontrivial_cross_variety_factories` —
  18th kernel-pure HC route for E codim 1 via the first cross-variety
  product-cycle factory chain.

## What R228 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT define a composed cycle class on `pt × ℙ¹ × E`
  (chain drops both cycleClass fields).
* Does NOT implement true Chow composition of cycles.
* Does NOT implement true `ℙ¹ × E` Künneth.
* Does NOT claim the toy `(1 : ℚ)` cycle class equals any specific
  real algebraic cycle on `ℙ¹ × E`.

All R228 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL2.EllipticCurve
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
import HodgeReduction.HCGapL4.ProductCycleFactoryProjectiveLineSelf
import HodgeReduction.HCGapL4.ProductCohomologyProjectiveLineEllipticCurve

namespace HodgeReduction
namespace HCGapL4
namespace ProductCycleFactoryProjectiveLineToEllipticCurve

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
open HodgeReduction.HCGapL4.ProductCycleFactoryProjectiveLineSelf
open HodgeReduction.HCGapL4.ProductCohomologyProjectiveLineEllipticCurve

/-! ## Section 1: action `H^0(ℙ¹) → H^2(E)` -/

/-- **R228 action**: identity ℚ → ℚ at the carrier level for the
ℙ¹ → E codim-1 correspondence. Models a degree-1 divisor class
correspondence cohomologically. -/
noncomputable def cycleAction_H0_projectiveLine_to_H2_ellipticCurve :
    ProjectiveLine.VarietyCohomologyData_projectiveLine.H 0 →ₗ[ℚ]
    EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

@[simp] theorem cycleAction_H0_projectiveLine_to_H2_ellipticCurve_apply (x : ℚ) :
    cycleAction_H0_projectiveLine_to_H2_ellipticCurve x = x := rfl

/-! ## Section 2: D₂' factory `ℙ¹ → E` codim 0 → 1 -/

/-- **R228 D₂' factory**: product-cycle factory ℙ¹ → E at codim shift 1,
using R228's toy `ℙ¹ × E` carrier with cycleClass `(1 : ℚ) =
projectiveLineTimesEllipticCurveCycleClass 1 ()` at `cycleCodim = 1`.
First cross-variety nontrivial product-cycle factory in the library. -/
noncomputable def internalCycleActionData_SHSM_WithProductCycle_projectiveLine_to_ellipticCurve :
    InternalCycleActionData_SHSM_WithProductCycle
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_projectiveLineTimesEllipticCurve
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_projectiveLineTimesEllipticCurve
      0 1 1 where
  toInternalCycleActionData_SHSM := {
    action := cycleAction_H0_projectiveLine_to_H2_ellipticCurve
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
  cycleClass := projectiveLineTimesEllipticCurveCycleClass 1 ()
  cycleClass_mem_algClasses := by
    show projectiveLineTimesEllipticCurveCycleClass 1 () ∈
      AlgebraicClassesData_projectiveLineTimesEllipticCurve.algClasses 1
    apply Submodule.subset_span
    exact Set.mem_range_self ()

/-! ## Section 3: cross-variety chain D₁ ∘ D₂' -/

/-- **R228 first cross-variety chain SHSM2**: chain R227's D₁
(pt → ℙ¹ codim 0 → 0) with R228's D₂' (ℙ¹ → E codim 0 → 1) via
R226's two-factory composer. The middle variety ℙ¹ differs from the
final target E (cross-variety, not self-correspondence). -/
theorem SHSM2_point_to_ellipticCurve_via_two_nontrivial_cross_variety_factories :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  ProductCycleFactory_compose_to_SHSM2
    ProductCycleFactoryProjectiveLineSelf.internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine_codim0_to_codim0
    internalCycleActionData_SHSM_WithProductCycle_projectiveLine_to_ellipticCurve

/-- **R228 18th kernel-pure HC route for E codim 1**: via the FIRST
cross-variety nontrivial product-cycle factory chain
(`pt → ℙ¹ → E`). Distinct from all prior 17 routes: pt and E are
connected via the middle variety ℙ¹, not via a single direct
correspondence. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_two_nontrivial_cross_variety_factories :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_productCycleFactory_compose
    ProductCycleFactoryProjectiveLineSelf.internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine_codim0_to_codim0
    internalCycleActionData_SHSM_WithProductCycle_projectiveLine_to_ellipticCurve
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ProjectiveLineTimesEllipticCurve_To_TrueProduct**: upgrading
the internal `VarietyCohomologyData_projectiveLineTimesEllipticCurve`
to a genuine `SmoothProjectiveVariety ℂ` product. The toy carrier
truncates `H^1 = ℚ²`, `H^2 = ℚ²`, etc. -/
abbrev L4_G_ProjectiveLineTimesEllipticCurve_To_TrueProduct : Prop := True

/-- **L4-G_ProjectiveLineToEllipticCurveFactory_NotTrueChowCorrespondence**:
D₂'s action is a carrier-level identity `(x : ℚ) ↦ (x : ℚ)`; it is NOT
the true cohomological action of any specific algebraic
correspondence `Z ⊂ ℙ¹ × E`. -/
abbrev L4_G_ProjectiveLineToEllipticCurveFactory_NotTrueChowCorrespondence :
    Prop := True

/-- **L4-G_CrossVarietyFactoryChain_To_E7MultiStepMT**: scaling the
cross-variety factory chain pattern to the E_7 / EVII Shimura
multi-step MT correspondence chain. Requires factory instances for
the actual Shimura-side varieties. Deferred. -/
abbrev L4_G_CrossVarietyFactoryChain_To_E7MultiStepMT : Prop := True

/-- **L4-G_ProductCycleFactoryChain_NoCycleLevelComposition**: chain
composition drops both cycleClass fields. Real cycle composition on
`pt × ℙ¹ × E` would require Manin–Voevodsky push-pull-cup. -/
abbrev L4_G_ProductCycleFactoryChain_NoCycleLevelComposition_R228 :
    Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R228 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R228_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R228 non-closure (2/5)**: does NOT implement true Chow
composition of cycles. -/
theorem R228_does_not_implement_true_chow_composition : True := trivial

/-- **R228 non-closure (3/5)**: does NOT prove the product cycles
semantically induce the actions. -/
theorem R228_does_not_prove_cycles_induce_actions : True := trivial

/-- **R228 non-closure (4/5)**: does NOT implement true `ℙ¹ × E`
(toy carrier truncates H^1 / H^2 / H^3 / H^4). -/
theorem R228_does_not_implement_true_projectiveLine_times_ellipticCurve :
    True := trivial

/-- **R228 non-closure (5/5)**: only demonstrates cross-variety
product-cycle factory chaining at the SHSM2 level. No cycle-level
composition, no real Künneth, no E_7 toy. -/
theorem R228_only_cross_variety_factory_SHSM2_chain : True := trivial

end ProductCycleFactoryProjectiveLineToEllipticCurve
end HCGapL4
end HodgeReduction
