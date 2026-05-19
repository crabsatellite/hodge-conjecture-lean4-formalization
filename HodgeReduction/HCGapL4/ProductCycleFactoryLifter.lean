/-
# HC Gap L4 — generic product-cycle factory lifter (R225).

R223 introduced `InternalCycleActionData_SHSM_WithProductCycle` and
instantiated it for `pt → E`. R224 added a second instance for
`pt → ℙ¹`. The factory assembly pattern is now confirmed independent
of the elliptic-curve example. R225 abstracts the repeated pattern
into a single generic lifter layer:

* `ofFields` — named constructor packaging all factory fields in one
  call (useful when the caller has the action + preservation +
  hodgeSurj + shift/h_shift + pieceShift + cycleClass data lying loose).
* `to_SHSM2_lifter` — named alias of R223's `.to_SHSM2` for downstream
  use.
* `VarietyHCAt_of_productCycleFactory` — one-shot HC transfer from
  source HC + factory data.
* `VarietyHCAt_of_productCycleFactory_composed3` — factory plugged as
  middle morphism in a three-step v2 chain (via R222 helper).
* Regression tests showing the R223 and R224 factory instances close
  HC through the new lifter.

R225 only abstracts assembly and routes; it does NOT add any new
semantic content (no Chow correspondence, no push-pull-cup, no claim
the cycle class induces the action).

## What R225 provides (all kernel-pure)

* `InternalCycleActionData_SHSM_WithProductCycle.ofFields` — named
  constructor.
* `ProductCycleFactory_to_SHSM2` — named SHSM2 lifter.
* `VarietyHCAt_of_productCycleFactory` — one-shot HC transfer.
* `VarietyHCAt_of_productCycleFactory_composed3` — composed chain
  transfer via R222 helper.
* `VarietyHCAt_ellipticCurve_codim1_via_productCycleFactory_lifter` —
  R223 instance regression.
* `VarietyHCAt_projectiveLine_codim1_via_productCycleFactory_lifter` —
  R224 instance regression.

## What R225 does NOT do

* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT implement true Chow groups, true scheme product,
  push-forward, pull-back, or cup product.
* Does NOT prove the product cycle semantically induces the action.
* Does NOT add a new factory instance.

All R225 declarations are kernel-pure: `{propext, Classical.choice,
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

namespace HodgeReduction
namespace HCGapL4
namespace ProductCycleFactoryLifter

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

/-! ## Section 1: Priority A — `ofFields` named constructor

Packages all factory fields (action / preservation / hodgeSurj /
shift / h_shift / pieceShift / cycleClass / membership) into a single
`InternalCycleActionData_SHSM_WithProductCycle` instance. Useful when
the caller has the data lying loose and wants a one-call assembly. -/

/-- **R225 `ofFields` constructor**: named packaging of all factory
fields. Equivalent to the structure's anonymous constructor but with
a clean named arity for downstream use. -/
noncomputable def InternalCycleActionData_SHSM_WithProductCycle.ofFields
    {X_src X_tgt X_prod : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {A_prod : AlgebraicClassesData X_prod}
    {p_src p_tgt cycleCodim : ℕ}
    (action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * p_tgt))
    (preservesAlgClasses :
      ∀ x ∈ A_src.algClasses p_src,
        action x ∈ A_tgt.algClasses p_tgt)
    (hodgeSurj :
      PureHodgeStructure.hodgeClasses (X_tgt.H (2 * p_tgt)) p_tgt ≤
        Submodule.map action
          (PureHodgeStructure.hodgeClasses (X_src.H (2 * p_src)) p_src))
    (shift : ℕ)
    (h_shift : p_tgt = p_src + shift)
    (pieceShift :
      ∀ (p_idx : Fin (2 * p_src + 1)),
        Submodule.map action
            (PureHodgeStructure.piece (V := X_src.H (2 * p_src)) p_idx) ≤
          PureHodgeStructure.piece (V := X_tgt.H (2 * p_tgt))
            (⟨p_idx.val + shift, by
              have := p_idx.is_lt
              have := h_shift
              omega⟩ : Fin (2 * p_tgt + 1)))
    (cycleClass : X_prod.H (2 * cycleCodim))
    (cycleClass_mem_algClasses :
      cycleClass ∈ A_prod.algClasses cycleCodim) :
    InternalCycleActionData_SHSM_WithProductCycle
      X_src X_tgt X_prod A_src A_tgt A_prod p_src p_tgt cycleCodim where
  toInternalCycleActionData_SHSM := {
    action := action
    preservesAlgClasses := preservesAlgClasses
    hodgeSurj := hodgeSurj
    shift := shift
    h_shift := h_shift
    pieceShift := pieceShift
  }
  cycleClass := cycleClass
  cycleClass_mem_algClasses := cycleClass_mem_algClasses

/-! ## Section 2: Priority B — named SHSM2 lifter -/

/-- **R225 named SHSM2 lifter**: clean alias of R223's `.to_SHSM2`
for downstream use. -/
theorem ProductCycleFactory_to_SHSM2
    {X_src X_tgt X_prod : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {A_prod : AlgebraicClassesData X_prod}
    {p_src p_tgt cycleCodim : ℕ}
    (D : InternalCycleActionData_SHSM_WithProductCycle
          X_src X_tgt X_prod A_src A_tgt A_prod p_src p_tgt cycleCodim) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X_src X_tgt A_src A_tgt p_src p_tgt :=
  D.to_SHSM2

/-! ## Section 3: Priority C — one-shot HC transfer -/

/-- **R225 one-shot HC transfer**: given product-cycle factory data
and HC at the source codim, derive HC at the target codim. Composition
of `.to_SHSM2`, `SHSM2_toRaw`, and R212's shifted transfer. -/
theorem VarietyHCAt_of_productCycleFactory
    {X_src X_tgt X_prod : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {A_prod : AlgebraicClassesData X_prod}
    {p_src p_tgt cycleCodim : ℕ}
    (D : InternalCycleActionData_SHSM_WithProductCycle
          X_src X_tgt X_prod A_src A_tgt A_prod p_src p_tgt cycleCodim)
    (h_HC_src : VarietyHCAt X_src A_src p_src) :
    VarietyHCAt X_tgt A_tgt p_tgt :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw D.to_SHSM2)
    h_HC_src

/-! ## Section 4: Priority D — composed chain transfer via R222 helper -/

/-- **R225 composed chain transfer**: product-cycle factory data
plugged as middle morphism in a three-step v2 chain (left v2 SHSM2 +
factory + right v2 SHSM2), HC transferred from leftmost source. Uses
R222's `VarietyHCAt_of_internalCycleAction_SHSM2_composed3` via the
factory's `.to_SHSM` forgetful. -/
theorem VarietyHCAt_of_productCycleFactory_composed3
    {X0 X_src X_tgt X3 X_prod : VarietyCohomologyData}
    {A0 : AlgebraicClassesData X0}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {A3 : AlgebraicClassesData X3}
    {A_prod : AlgebraicClassesData X_prod}
    {p0 p_src p_tgt p3 cycleCodim : ℕ}
    (P_left : ShiftedMTCorrespondencePackageAt_SHSM2 X0 X_src A0 A_src p0 p_src)
    (D : InternalCycleActionData_SHSM_WithProductCycle
          X_src X_tgt X_prod A_src A_tgt A_prod p_src p_tgt cycleCodim)
    (P_right : ShiftedMTCorrespondencePackageAt_SHSM2 X_tgt X3 A_tgt A3 p_tgt p3)
    (h_HC_src : VarietyHCAt X0 A0 p0) :
    VarietyHCAt X3 A3 p3 :=
  VarietyHCAt_of_internalCycleAction_SHSM2_composed3
    P_left D.to_SHSM P_right h_HC_src

/-! ## Section 5: Priority E — regression tests

Re-close the HC routes for E and ℙ¹ via the new generic lifter to
confirm equivalence with R223/R224's hand-written versions. -/

/-- **R225 regression — pt → E**: re-close `VarietyHCAt_E_codim1` via
the generic lifter applied to R223's pt → E factory instance. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_productCycleFactory_lifter :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_productCycleFactory
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve
    (TrivialPoint.VarietyHCAt_point 0)

/-- **R225 regression — pt → ℙ¹**: re-close `VarietyHCAt_ℙ¹_codim1` via
the generic lifter applied to R224's pt → ℙ¹ factory instance. -/
theorem VarietyHCAt_projectiveLine_codim1_via_productCycleFactory_lifter :
    VarietyHCAt ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine 1 :=
  VarietyHCAt_of_productCycleFactory
    internalCycleActionData_SHSM_WithProductCycle_point_to_projectiveLine
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ProductCycleFactoryLifter_To_TrueChowCorrespondence**:
upgrading the lifter to take a genuine Chow-cycle on a real product
scheme and produce the factory via real push-pull-cup. R225 only
abstracts the linear-algebraic skeleton; cycle / scheme / Chow remain
internal toy models. -/
abbrev L4_G_ProductCycleFactoryLifter_To_TrueChowCorrespondence : Prop := True

/-- **L4-G_ProductCycleFactoryLifter_ActionStillInput**: the lifter
takes `action` as an EXPLICIT INPUT — it does NOT derive `action`
from `cycleClass` via any push-pull-cup machinery. The cycle class
remains paper-trail only. -/
abbrev L4_G_ProductCycleFactoryLifter_ActionStillInput : Prop := True

/-- **L4-G_ProductCycleFactoryLifter_To_E7ShimuraTor**: applying the
lifter to the E_7 / EVII Shimura context to produce
`canonicalE7ShimuraTor.mtCorrespondencePackage`. Requires the
deferred Shimura-side factory instance. -/
abbrev L4_G_ProductCycleFactoryLifter_To_E7ShimuraTor : Prop := True

/-- **L4-G_ProductCycleFactoryLifter_RealPushPullCupMissing**: the
push-forward `p_*`, pull-back `q^*`, and cup product `∪` operations
that would actually relate `cycleClass` to `action` are NOT
implemented. R225 records this gap as a marker only. -/
abbrev L4_G_ProductCycleFactoryLifter_RealPushPullCupMissing : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R225 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R225_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R225 non-closure (2/4)**: does NOT implement true Chow group
functoriality. -/
theorem R225_does_not_implement_true_chow_functoriality : True := trivial

/-- **R225 non-closure (3/4)**: does NOT prove the product cycle
class induces the action. Action remains an explicit input. -/
theorem R225_does_not_prove_cycle_induces_action : True := trivial

/-- **R225 non-closure (4/4)**: only abstracts the internal
product-cycle factory assembly pattern into a generic lifter
(constructor + SHSM2 + HC transfer + composed chain helpers). No
new factory instance, no new semantic content. -/
theorem R225_only_abstracts_product_cycle_factory_lifter : True := trivial

end ProductCycleFactoryLifter
end HCGapL4
end HodgeReduction
