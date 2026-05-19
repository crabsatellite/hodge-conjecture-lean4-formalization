/-
# HC Gap L4 — second product-cycle factory instance: pt → ℙ¹ codim 0→1 (R224).

R223 introduced `InternalCycleActionData_SHSM_WithProductCycle` and
instantiated it for the pt → E codim 0 → 1 example. R224 demonstrates
the factory is not specialised to elliptic curves by constructing a
SECOND concrete instance: pt → ℙ¹ codim 0 → 1 with `pt × ℙ¹`
product-cycle provenance.

Structure mirrors R223's pt → E exactly, but the target carrier is
the projective line ℙ¹ (R202) and the product carrier is the minimal
internal `pt × ℙ¹` model from the sibling file
`ProductCohomologyPointProjectiveLine.lean`.

## What R224 (this file) provides (all kernel-pure)

* `cycleAction_H0_to_H2_pointToProjectiveLine` — ℚ-LinearMap
  `H^0(pt) →ₗ[ℚ] H^2(ℙ¹)` (identity ℚ → ℚ at the carrier level).
* `cycleAction_H0_to_H2_preserves_algClasses_point_to_projectiveLine` —
  preservation witness.
* `internalCycleActionData_SHSM_point_to_projectiveLine` — R221 SHSM
  factory instance for pt → ℙ¹.
* `internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine` —
  R223 product-cycle factory instance with provenance.
* `SHSM2_point_to_projectiveLine_from_productCycleFactory` —
  v2 SHSM2 package via the factory.
* `VarietyHCAt_projectiveLine_codim1_via_productCycleFactory` —
  HC at codim 1 for ℙ¹ via the factory route.
* `VarietyHCAt_projectiveLine_codim1_via_productCycleFactory_compose3` —
  composed factory route via R222 helper.

## What R224 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT implement true Chow groups or scheme product.
* Does NOT prove the product cycle induces the action.
* Does NOT implement general product across arbitrary VCDs.
* Does NOT implement push-forward, pull-back, or cup product.

All R224 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.SHSM2MultiStep
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.GenericCycleActionMultiStep
import HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
import HodgeReduction.HCGapL4.ProductCohomologyPointProjectiveLine

namespace HodgeReduction
namespace HCGapL4
namespace PtToProjectiveLineProductCycleFactory

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.SHSM2MultiStep
open HodgeReduction.HCGapL4.GenericCycleAction
open HodgeReduction.HCGapL4.GenericCycleActionMultiStep
open HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
open HodgeReduction.HCGapL4.ProductCohomologyPointProjectiveLine

/-! ## Section 0: scoped `PureHodgeStructure` instances

Need PHS at the carriers used: pt at weight 0, ℙ¹ at weight 2,
and via the R221 generic VCD instance for any X.H k. The latter is
already available from R221's imports. -/

noncomputable instance phs_point_H0_R224 :
    PureHodgeStructure
      (TrivialPoint.varietyCohomology_point.H (2 * 0)) (2 * 0) :=
  TrivialPoint.varietyCohomology_point.hodgeStructure (2 * 0)

noncomputable instance phs_projectiveLine_H2_R224 :
    PureHodgeStructure
      (ProjectiveLine.VarietyCohomologyData_projectiveLine.H (2 * 1)) (2 * 1) :=
  ProjectiveLine.VarietyCohomologyData_projectiveLine.hodgeStructure (2 * 1)

/-! ## Section 1: cycle action `H^0(pt) →ₗ[ℚ] H^2(ℙ¹)` -/

/-- **R224 cycle action**: identity ℚ → ℚ at the internal carrier level.
Models `pt × pt_of_ℙ¹` cycle's cohomological action via Künneth +
identity. -/
noncomputable def cycleAction_H0_to_H2_pointToProjectiveLine :
    TrivialPoint.varietyCohomology_point.H 0 →ₗ[ℚ]
    ProjectiveLine.VarietyCohomologyData_projectiveLine.H 2 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

@[simp] theorem cycleAction_H0_to_H2_pointToProjectiveLine_apply (x : ℚ) :
    cycleAction_H0_to_H2_pointToProjectiveLine x = x := rfl

/-! ## Section 2: preservation witness -/

/-- **R224 preservation witness**: the cycle action sends elements of
`algClasses_point 0` into `algClasses_projectiveLine 1`. For the
internal model, `algClasses_projectiveLine 1 = ⊤`, so this is trivial
via `Submodule.mem_top`. -/
theorem cycleAction_H0_to_H2_preserves_algClasses_point_to_projectiveLine :
    ∀ x ∈ TrivialPoint.algClasses_point.algClasses 0,
      cycleAction_H0_to_H2_pointToProjectiveLine x ∈
        ProjectiveLine.AlgebraicClassesData_projectiveLine.algClasses 1 := by
  intro x _
  exact Submodule.mem_top

/-! ## Section 3: R221 SHSM factory instance for pt → ℙ¹ -/

/-- **R224 R221-style factory data for pt → ℙ¹**: SHSM-bundled
internal cycle action at `(0, 1)` with `shift = 1`. -/
noncomputable def internalCycleActionData_SHSM_point_to_projectiveLine :
    InternalCycleActionData_SHSM
      TrivialPoint.varietyCohomology_point
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      TrivialPoint.algClasses_point
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      0 1 where
  action := cycleAction_H0_to_H2_pointToProjectiveLine
  preservesAlgClasses :=
    cycleAction_H0_to_H2_preserves_algClasses_point_to_projectiveLine
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
    intro p
    fin_cases p
    show Submodule.map _ _ ≤
      ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 1, by omega⟩
    show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact le_top

/-! ## Section 4: R223 product-cycle factory instance with provenance -/

/-- **R224 product-cycle factory instance for pt → ℙ¹**: extends the
R221 factory data with `pt × ℙ¹` product-cycle provenance using the
R224 product cycle class `pointTimesProjectiveLineCycleClass 1 () =
(1 : ℚ)` at `cycleCodim = 1`. -/
noncomputable def internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine :
    InternalCycleActionData_SHSM_WithProductCycle
      TrivialPoint.varietyCohomology_point
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      VarietyCohomologyData_pointTimesProjectiveLine
      TrivialPoint.algClasses_point
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      AlgebraicClassesData_pointTimesProjectiveLine
      0 1 1 where
  toInternalCycleActionData_SHSM :=
    internalCycleActionData_SHSM_point_to_projectiveLine
  cycleClass := pointTimesProjectiveLineCycleClass 1 ()
  cycleClass_mem_algClasses := by
    show pointTimesProjectiveLineCycleClass 1 () ∈
      AlgebraicClassesData_pointTimesProjectiveLine.algClasses 1
    apply Submodule.subset_span
    exact Set.mem_range_self ()

/-! ## Section 5: SHSM2 + HC closure routes -/

/-- **R224 pt → ℙ¹ SHSM2 via product-cycle factory**: forget the
product-cycle data and apply R221's `.to_SHSM2`. -/
theorem SHSM2_point_to_projectiveLine_from_productCycleFactory :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      TrivialPoint.algClasses_point
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      0 1 :=
  internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine.to_SHSM2

/-- **R224 HC route for ℙ¹ at codim 1 via product-cycle factory**: pure
factory-route closure. Reproves `VarietyHCAt_projectiveLine_codim1`
through the product-cycle factory pipeline (factory → SHSM2 → toRaw →
shifted transfer from R202 source HC). -/
theorem VarietyHCAt_projectiveLine_codim1_via_productCycleFactory :
    VarietyHCAt ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      SHSM2_point_to_projectiveLine_from_productCycleFactory)
    (TrivialPoint.VarietyHCAt_point 0)

/-- **R224 HC route for ℙ¹ at codim 1 via product-cycle factory inside
3-step v2 chain**: factory plugged as middle morphism in R220-style
three-step chain via R222 helper. -/
theorem VarietyHCAt_projectiveLine_codim1_via_productCycleFactory_compose3 :
    VarietyHCAt ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine 1 :=
  VarietyHCAt_of_internalCycleAction_SHSM2_composed3
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine.to_SHSM
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine 1)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_PointTimesProjectiveLine_To_TrueProduct**: upgrading the
internal `VarietyCohomologyData_pointTimesProjectiveLine` to a genuine
`SmoothProjectiveVariety ℂ` product `Spec ℂ ×_{Spec ℂ} ℙ¹_ℂ`. -/
abbrev L4_G_PointTimesProjectiveLine_To_TrueProduct : Prop := True

/-- **L4-G_ProjectiveLineProductCycle_To_TrueChowCorrespondence**:
upgrading the paper-trail `cycleClass = (1 : ℚ)` to a genuine element
of `CH^1(pt × ℙ¹)_ℚ` representing an actual algebraic cycle. -/
abbrev L4_G_ProjectiveLineProductCycle_To_TrueChowCorrespondence : Prop := True

/-- **L4-G_SecondProductCycleFactoryInstance_To_GenericFactory**: deriving
a single general `productCycleFactory_from_arbitraryProductCarrier`
constructor that, given any product carrier and cycle, produces the
factory instance. R224 hand-builds the pt → ℙ¹ instance; the generic
lifter is deferred. -/
abbrev L4_G_SecondProductCycleFactoryInstance_To_GenericFactory : Prop := True

/-- **L4-G_ProductCycleFactory_NotYetE7**: scaling the factory to the
E_7 / EVII Shimura context. R224 provides only the second toy-model
instance (pt → ℙ¹). The Shimura-level factory is deferred. -/
abbrev L4_G_ProductCycleFactory_NotYetE7 : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R224 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R224_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R224 non-closure (2/4)**: does NOT implement general product or
true Künneth across arbitrary VCDs. -/
theorem R224_does_not_implement_general_product : True := trivial

/-- **R224 non-closure (3/4)**: does NOT implement true Chow
functoriality. -/
theorem R224_does_not_implement_true_chow_functoriality : True := trivial

/-- **R224 non-closure (4/4)**: only provides a second internal
product-cycle factory instance (pt → ℙ¹). -/
theorem R224_only_second_product_cycle_factory_instance : True := trivial

end PtToProjectiveLineProductCycleFactory
end HCGapL4
end HodgeReduction
