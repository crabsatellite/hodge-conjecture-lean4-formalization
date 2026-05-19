/-
# HC Gap L4 — chained product-cycle factories via SHSM2 composition (R226).

R223 introduced `InternalCycleActionData_SHSM_WithProductCycle`. R224
added a second instance (pt → ℙ¹). R225 abstracted the lifter pattern.
R226 proves the factory chains operationally via R218's general
`SHSM2_compose`: two factory instances `(X₀ → X₁)` and `(X₁ → X₂)`
yield an SHSM2 package for `X₀ → X₂`. HC transfers through the chain.

This round only proves **SHSM2-level composition** of factory-generated
packages. It deliberately does NOT define a composed `cycleClass` field
on the product carrier, since that would require real Chow correspondence
composition (`X_prod_12 := X_prod_01 ×_{X₁} X_prod_12` push-pull-cup).
The output SHSM2 package carries no product-cycle provenance from
either factor — the provenance fields are forgotten at composition time.

## What R226 provides (all kernel-pure)

* `ProductCycleFactory_compose_to_SHSM2` — chain two factories' SHSM2
  lifts via R218 `SHSM2_compose`.
* `VarietyHCAt_of_productCycleFactory_compose` — one-shot HC transfer
  through the chained factories.
* `identity_InternalCycleActionData_SHSM_WithProductCycle` — identity
  factory wrapper (composition unit, with cycleClass = 0 as placeholder
  paper-trail). Lets us exhibit a regression chain `identity ∘ R223 pt→E`
  via the two-factory composer.
* `SHSM2_point_to_E_via_identity_factory_then_R223 — sanity SHSM2 chain.
* `VarietyHCAt_ellipticCurve_codim1_via_factory_chain_identity_pt_R223` —
  17th kernel-pure HC route via the two-factory chain.

## What R226 does NOT do

* Does NOT define composed `cycleClass` on the chained product carrier.
* Does NOT implement cycle-level composition or real Chow push-pull-cup.
* Does NOT prove categorical associativity for multi-factory chains.
* Does NOT do compose4 / n-step composition of factories.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

All R226 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
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
import HodgeReduction.HCGapL4.ProductCycleFactoryLifter

namespace HodgeReduction
namespace HCGapL4
namespace ProductCycleFactoryComposition

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
open HodgeReduction.HCGapL4.ProductCycleFactoryLifter

/-! ## Section 1: Priority A — two-factory SHSM2 composition

Chain `D₁ : factory X₀ → X₁` with `D₂ : factory X₁ → X₂` via
`ProductCycleFactory_to_SHSM2` (R225) and R218 `SHSM2_compose`. The
output SHSM2 package is at `(p₀, p₂)`; the product-cycle provenance
fields are forgotten (composition does NOT produce a composed
cycleClass — that requires real Chow correspondence composition). -/

/-- **R226 two-factory SHSM2 composition**: chain two product-cycle
factories via lift + R218 SHSM2 composition. The output is a v2 SHSM2
package; cycle-class provenance is dropped (no Chow composition). -/
theorem ProductCycleFactory_compose_to_SHSM2
    {X₀ X₁ X₂ X_prod_01 X_prod_12 : VarietyCohomologyData}
    {A₀ : AlgebraicClassesData X₀}
    {A₁ : AlgebraicClassesData X₁}
    {A₂ : AlgebraicClassesData X₂}
    {A_prod_01 : AlgebraicClassesData X_prod_01}
    {A_prod_12 : AlgebraicClassesData X_prod_12}
    {p₀ p₁ p₂ c01 c12 : ℕ}
    (D₁ : InternalCycleActionData_SHSM_WithProductCycle
            X₀ X₁ X_prod_01 A₀ A₁ A_prod_01 p₀ p₁ c01)
    (D₂ : InternalCycleActionData_SHSM_WithProductCycle
            X₁ X₂ X_prod_12 A₁ A₂ A_prod_12 p₁ p₂ c12) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X₀ X₂ A₀ A₂ p₀ p₂ :=
  ShiftedMTCorrespondencePackageAt_SHSM2_compose
    (ProductCycleFactory_to_SHSM2 D₁)
    (ProductCycleFactory_to_SHSM2 D₂)

/-! ## Section 2: Priority B — two-factory HC transfer -/

/-- **R226 two-factory HC transfer**: given two chained factories and
HC at the leftmost source, derive HC at the rightmost target. -/
theorem VarietyHCAt_of_productCycleFactory_compose
    {X₀ X₁ X₂ X_prod_01 X_prod_12 : VarietyCohomologyData}
    {A₀ : AlgebraicClassesData X₀}
    {A₁ : AlgebraicClassesData X₁}
    {A₂ : AlgebraicClassesData X₂}
    {A_prod_01 : AlgebraicClassesData X_prod_01}
    {A_prod_12 : AlgebraicClassesData X_prod_12}
    {p₀ p₁ p₂ c01 c12 : ℕ}
    (D₁ : InternalCycleActionData_SHSM_WithProductCycle
            X₀ X₁ X_prod_01 A₀ A₁ A_prod_01 p₀ p₁ c01)
    (D₂ : InternalCycleActionData_SHSM_WithProductCycle
            X₁ X₂ X_prod_12 A₁ A₂ A_prod_12 p₁ p₂ c12)
    (h_HC_src : VarietyHCAt X₀ A₀ p₀) :
    VarietyHCAt X₂ A₂ p₂ :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      (ProductCycleFactory_compose_to_SHSM2 D₁ D₂))
    h_HC_src

/-! ## Section 3: Priority D — identity factory wrapper

To exhibit a concrete two-factory chain, we need two compatible factory
instances. R223 (pt → E) and R224 (pt → ℙ¹) share a source but not a
target, so they don't chain. We provide an IDENTITY FACTORY wrapper
(identity action + zero cycleClass placeholder) that can be composed
with R223/R224. This is NOT a two-NONTRIVIAL-factory regression; the
identity factory carries no geometric content beyond the composition
unit role. The cycleClass placeholder is `0 : X.H (2 * p)`, which lies
in any submodule via `Submodule.zero_mem`. -/

/-- **R226 identity factory wrapper**: identity action with placeholder
cycleClass = 0. Useful as composition unit when no second nontrivial
factory is available. -/
noncomputable def identity_InternalCycleActionData_SHSM_WithProductCycle
    (X : VarietyCohomologyData)
    (AX : AlgebraicClassesData X)
    (p : ℕ) :
    InternalCycleActionData_SHSM_WithProductCycle
      X X X AX AX AX p p p where
  toInternalCycleActionData_SHSM := {
    action := LinearMap.id
    preservesAlgClasses := fun _ hx => hx
    hodgeSurj := by intro x hx; refine ⟨x, hx, rfl⟩
    shift := 0
    h_shift := rfl
    pieceShift := by
      intro p_idx
      rw [Submodule.map_id]
      rfl
  }
  cycleClass := 0
  cycleClass_mem_algClasses := Submodule.zero_mem _

/-! ## Section 4: regression — identity ∘ R223 pt → E -/

/-- **R226 regression chain**: two-factory chain
`identity@pt ∘ R223 pt → E` yielding SHSM2 at `(0, 1)`. -/
theorem SHSM2_point_to_E_via_identity_factory_then_R223 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  ProductCycleFactory_compose_to_SHSM2
    (identity_InternalCycleActionData_SHSM_WithProductCycle
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve

/-- **R226 17th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via the two-factory chain `identity ∘ R223`. Exercises the
`VarietyHCAt_of_productCycleFactory_compose` helper end-to-end. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_factory_chain_identity_pt_R223 :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_productCycleFactory_compose
    (identity_InternalCycleActionData_SHSM_WithProductCycle
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: Priority E — disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ProductCycleFactoryChain_To_TrueChowComposition**: real
composition of two algebraic correspondences at the Chow level
(Manin–Voevodsky composition: cycle on `X₀ × X₂` derived from cycles on
`X₀ × X₁` and `X₁ × X₂` via push-pull-cup on `X₀ × X₁ × X₂`). R226
composes SHSM2 packages linearly; cycle-level composition is deferred. -/
abbrev L4_G_ProductCycleFactoryChain_To_TrueChowComposition : Prop := True

/-- **L4-G_ProductCycleFactoryChain_DoesNotComposeCycles**: explicit
non-claim: the two-factory composition drops both cycleClass fields,
producing a v2 SHSM2 package with NO product-cycle provenance.
Reconstructing provenance on the composed product carrier would
require real Chow composition. -/
abbrev L4_G_ProductCycleFactoryChain_DoesNotComposeCycles : Prop := True

/-- **L4-G_ProductCycleFactoryChain_To_E7MultiStepCorrespondence**:
scaling factory chaining to multi-step E_7 / EVII Shimura
correspondences. Requires factory instances for the relevant E_7-side
varieties. Deferred. -/
abbrev L4_G_ProductCycleFactoryChain_To_E7MultiStepCorrespondence : Prop := True

/-- **L4-G_ProductCycleFactoryChain_RealPushPullCupMissing**: the
push-forward / pull-back / cup product apparatus that would underlie a
genuine Chow-level chain composition is NOT implemented. R226
records this gap as a marker only. -/
abbrev L4_G_ProductCycleFactoryChain_RealPushPullCupMissing : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R226 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R226_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R226 non-closure (2/4)**: does NOT implement cycle-level
composition. The composed SHSM2 package has NO derived cycleClass. -/
theorem R226_does_not_implement_cycle_level_composition : True := trivial

/-- **R226 non-closure (3/4)**: does NOT prove the product cycles
semantically induce the actions. Actions remain explicit inputs. -/
theorem R226_does_not_prove_cycles_induce_actions : True := trivial

/-- **R226 non-closure (4/4)**: only proves SHSM2-level composition of
factory-generated packages. No new factory instance, no Chow composition,
no n-step generalisation. -/
theorem R226_only_SHSM2_composition_of_factory_packages : True := trivial

end ProductCycleFactoryComposition
end HCGapL4
end HodgeReduction
