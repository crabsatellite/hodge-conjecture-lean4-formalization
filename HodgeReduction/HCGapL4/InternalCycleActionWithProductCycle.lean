/-
# HC Gap L4 — internal cycle-action factory with product-cycle provenance (R223).

R221 introduced the basic `InternalCycleActionData_SHSM` factory.
R222 verified factory-generated SHSM2 packages compose inside R220's
multi-step calculus. The factory carries the cohomology action, the
algebraic-class preservation witness, the Hodge-class surjectivity, and
the SHSM piece-shift compatibility — all linear-algebraic data.

R223 extends the factory with **explicit product-cycle provenance**:
a cycle class `cycleClass : X_prod.H (2 * cycleCodim)` representing
a hypothetical algebraic cycle on the product carrier `X_prod`, with
witness `cycleClass_mem_algClasses`.

The provenance is RECORDED but does NOT claim:
* That `cycleClass` semantically induces the `action` (no
  push-pull-cup semantics).
* That `X_prod` is a real scheme-theoretic product `X_src × X_tgt`.
* Any Chow-cycle functoriality.

R223 only formalises the "this factory's action carries a paper-trail
back to a specific cycle class on a chosen product carrier" pattern,
preserving the option to later upgrade the provenance to genuine
Chow correspondence.

## What R223 provides (all kernel-pure)

* `InternalCycleActionData_SHSM_WithProductCycle` — factory extending
  R221's `InternalCycleActionData_SHSM` with cycle-class provenance.
* `.toInternalCycleActionData_SHSM` — forget product-cycle data,
  recover R221 factory.
* `.to_SHSM2` — forget product-cycle data and produce R218 v2 SHSM2.
* `internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve` —
  pt → E factory with product-cycle provenance on `pt × E`.
* `SHSM2_point_to_E_from_productCycleFactory` — pt → E SHSM2 via the
  product-cycle factory.
* `VarietyHCAt_ellipticCurve_codim1_via_productCycleFactory` — 15th
  kernel-pure HC route via product-cycle factory.
* `VarietyHCAt_ellipticCurve_codim1_via_productCycleFactory_compose3` —
  16th kernel-pure HC route, product-cycle factory inside R220's
  three-step v2 chain (via R222 helper).

## What R223 does NOT do

* Does NOT claim `cycleClass` induces the action.
* Does NOT implement true Chow groups or true scheme product.
* Does NOT implement push-forward, pull-back, or cup product.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT prove categorical associativity.
* Does NOT do compose4 / n-step composition.

All R223 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
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
import HodgeReduction.HCGapL4.ProductCohomology
import HodgeReduction.HCGapL4.CycleClassPresentation

namespace HodgeReduction
namespace HCGapL4
namespace InternalCycleActionWithProductCycle

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
open HodgeReduction.HCGapL4.ProductCohomology

/-! ## Section 1: Priority A — product-cycle provenance structure

Extends R221's `InternalCycleActionData_SHSM` with a cycle class on a
chosen product carrier `X_prod` and the membership witness in
`A_prod.algClasses cycleCodim`. The cycle class is purely
documentation — no semantic claim that it induces `action`. -/

/-- **R223 product-cycle factory**: R221's `InternalCycleActionData_SHSM`
extended with a cycle class on the product carrier `X_prod` at
codim `cycleCodim`, and the witness that this cycle class lies in
`A_prod.algClasses cycleCodim`. The cycle-class field is **paper-trail
only** — there is NO claim that it semantically induces `action`. -/
structure InternalCycleActionData_SHSM_WithProductCycle
    (X_src X_tgt X_prod : VarietyCohomologyData)
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    (A_prod : AlgebraicClassesData X_prod)
    (p_src p_tgt cycleCodim : ℕ) extends
    InternalCycleActionData_SHSM X_src X_tgt A_src A_tgt p_src p_tgt where
  /-- Paper-trail cycle class on the product carrier. -/
  cycleClass : X_prod.H (2 * cycleCodim)
  /-- The cycle class is algebraic on the product side. -/
  cycleClass_mem_algClasses :
    cycleClass ∈ A_prod.algClasses cycleCodim

/-! ## Section 2: Priority B — forgetful conversions -/

/-- **R223 forgetful to R221 factory**: drop the product-cycle data,
recover the base SHSM-bundled factory. -/
def InternalCycleActionData_SHSM_WithProductCycle.to_SHSM
    {X_src X_tgt X_prod : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {A_prod : AlgebraicClassesData X_prod}
    {p_src p_tgt cycleCodim : ℕ}
    (data : InternalCycleActionData_SHSM_WithProductCycle
              X_src X_tgt X_prod A_src A_tgt A_prod p_src p_tgt cycleCodim) :
    InternalCycleActionData_SHSM X_src X_tgt A_src A_tgt p_src p_tgt :=
  data.toInternalCycleActionData_SHSM

/-- **R223 forgetful to v2 SHSM2 package**: drop the product-cycle data
and apply R221's `.to_SHSM2`. -/
theorem InternalCycleActionData_SHSM_WithProductCycle.to_SHSM2
    {X_src X_tgt X_prod : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {A_prod : AlgebraicClassesData X_prod}
    {p_src p_tgt cycleCodim : ℕ}
    (data : InternalCycleActionData_SHSM_WithProductCycle
              X_src X_tgt X_prod A_src A_tgt A_prod p_src p_tgt cycleCodim) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X_src X_tgt A_src A_tgt p_src p_tgt :=
  data.toInternalCycleActionData_SHSM.to_SHSM2

/-! ## Section 3: Priority C — pt × E product-cycle factory instance

Uses:
* R209 `VarietyCohomologyData_pointTimesEllipticCurve` (product carrier)
* R209 `AlgebraicClassesData_pointTimesEllipticCurve` (product ACD via
  `ofCycleClassFamily`)
* R209 `pointTimesEllipticCurveCycleClass 1 ()` = `(1 : ℚ)` as the
  codim-1 cycle class
* R211 / R221 action and preservation data
* `cycleCodim := 1` -/

/-- **R223 pt × E product-cycle factory data**: extends R221's pt → E
factory with cycle-class provenance using the R209 product cycle class
`pointTimesEllipticCurveCycleClass 1 ()` at `cycleCodim = 1`. -/
noncomputable def internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve :
    InternalCycleActionData_SHSM_WithProductCycle
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_pointTimesEllipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_pointTimesEllipticCurve
      0 1 1 where
  toInternalCycleActionData_SHSM :=
    internalCycleActionData_SHSM_point_to_ellipticCurve
  cycleClass := pointTimesEllipticCurveCycleClass 1 ()
  cycleClass_mem_algClasses := by
    -- algClasses_pointTimesE 1 = span (range cycleClass 1) (from ofCycleClassFamily).
    -- cycleClass 1 () = (1 : ℚ), so cycleClass 1 () ∈ range, hence in span.
    show pointTimesEllipticCurveCycleClass 1 () ∈
      AlgebraicClassesData_pointTimesEllipticCurve.algClasses 1
    -- AlgebraicClassesData_pointTimesEllipticCurve = ofCycleClassFamily pointTimesEllipticCurveCycleClassFamily
    -- algClasses 1 = Submodule.span ℚ (range (pointTimesEllipticCurveCycleClassFamily.cycleClass 1))
    apply Submodule.subset_span
    exact Set.mem_range_self ()

/-! ## Section 4: Priority D — close pt → E SHSM2 via product-cycle factory -/

/-- **R223 pt → E SHSM2 via product-cycle factory**: forget the
product-cycle data and apply `.to_SHSM2`. -/
theorem SHSM2_point_to_E_from_productCycleFactory :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve.to_SHSM2

/-- **R223 15th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via the product-cycle factory `to_SHSM2` + R218 `toRaw` + R212 transfer. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_productCycleFactory :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      SHSM2_point_to_E_from_productCycleFactory)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: Priority E — composed route using R222 helper -/

/-- **R223 16th kernel-pure route**: the product-cycle factory's
SHSM2 plugged as middle morphism in R220's three-step v2 chain. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_productCycleFactory_compose3 :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_internalCycleAction_SHSM2_composed3
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve.to_SHSM
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ProductCycleProvenance_To_TrueChowCorrespondence**: upgrading
the paper-trail `cycleClass` to a genuine element of a real Chow group
`CH^{cycleCodim}(X_prod)_ℚ` representing an actual algebraic cycle on
the product. R223's cycle class is a linear-algebraic stand-in. -/
abbrev L4_G_ProductCycleProvenance_To_TrueChowCorrespondence : Prop := True

/-- **L4-G_ProductCycleClass_ActuallyInducesAction**: the semantic
claim that `cycleClass` induces the `action` via push-pull-cup
(`action := p_* ∘ (· ∪ cycleClass) ∘ q^*`). R223 records the
provenance only — there is NO claim of semantic induction. -/
abbrev L4_G_ProductCycleClass_ActuallyInducesAction : Prop := True

/-- **L4-G_ProductCycleFactory_To_E7MTCorrespondence**: scaling the
product-cycle factory pattern to the E_7 / EVII Shimura context.
Requires real cohomology of E_7-Shimura varieties and the Hodge cycle
described in the paper's main reduction. Deferred. -/
abbrev L4_G_ProductCycleFactory_To_E7MTCorrespondence : Prop := True

/-- **L4-G_TruePushPullCup_From_ProductCycle**: the genuine
`p_*`, `q^*`, and `∪` operations for a smooth-proper morphism
`p : X_prod → X_tgt` and `q : X_prod → X_src`. R223 provides no
implementation of these. Deferred. -/
abbrev L4_G_TruePushPullCup_From_ProductCycle : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R223 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R223_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R223 non-closure (2/5)**: does NOT implement true Chow group
functoriality. -/
theorem R223_does_not_implement_true_chow_functoriality : True := trivial

/-- **R223 non-closure (3/5)**: does NOT prove the product cycle
class induces the action. Provenance is paper-trail only. -/
theorem R223_does_not_prove_cycle_induces_action : True := trivial

/-- **R223 non-closure (4/5)**: does NOT implement push-forward,
pull-back, or cup product. -/
theorem R223_does_not_implement_pushforward_pullback_cup : True := trivial

/-- **R223 non-closure (5/5)**: only records product-cycle provenance
for the internal action factory. -/
theorem R223_only_records_product_cycle_provenance : True := trivial

end InternalCycleActionWithProductCycle
end HCGapL4
end HodgeReduction
