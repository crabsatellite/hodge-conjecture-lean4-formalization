/-
# HC Gap L4 — factory + multi-step composition integration test (R222).

R221 built the `InternalCycleActionData_SHSM` factory and proved
`to_SHSM2` produces a v2 SHSM2 package. R220 proved operational
three-step v2 composition `SHSM2_compose3` and the multi-step HC
transfer. R222 verifies that factory-generated SHSM2 packages plug
cleanly into R220's multi-step calculus.

This round is purely an integration sanity check. No new factory
instance is constructed; no E_7-Shimura toy; no categorical
associativity; no product-cycle provenance extension.

## What R222 provides (all kernel-pure)

* `SHSM2_point_to_E_from_internalCycleAction_via_compose3` —
  factory's pt → E SHSM2 used as the middle morphism in
  `SHSM2_compose3 (identity@pt, factory, identity@E)`.
* `VarietyHCAt_ellipticCurve_codim1_via_internalCycleAction_compose3` —
  14th kernel-pure HC route via the composed factory chain.
* `VarietyHCAt_of_internalCycleAction_SHSM2_composed3` — narrow
  generic helper showing factory-generated SHSM2 packages can be
  used as middle morphisms in any three-step chain.

## What R222 does NOT do

* Does NOT construct a second factory instance.
* Does NOT do E_7-Shimura toy chain.
* Does NOT prove categorical associativity.
* Does NOT extend factory to product-cycle provenance.
* Does NOT generalise to n-step composition.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT implement real Chow correspondence.

All R222 declarations are kernel-pure: `{propext, Classical.choice,
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

namespace HodgeReduction
namespace HCGapL4
namespace GenericCycleActionMultiStep

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

/-! ## Section 1: Priority A — factory in middle of three-step chain

Chain:
1. `identity_SHSM2` at point, `(0, 0)`
2. `SHSM2_point_to_E_from_internalCycleAction` (factory `.to_SHSM2`), `(0, 1)`
3. `identity_SHSM2` at elliptic curve, `(1, 1)`

Composed via R220 `SHSM2_compose3` to `(0, 1)`. -/

/-- **R222 factory + compose3**: the factory-generated pt → E SHSM2
package serves as the middle morphism in a three-step v2 composition. -/
theorem SHSM2_point_to_E_from_internalCycleAction_via_compose3 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  ShiftedMTCorrespondencePackageAt_SHSM2_compose3
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    SHSM2_point_to_E_from_internalCycleAction
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1)

/-! ## Section 2: Priority B — 14th HC route via composed factory chain -/

/-- **R222 14th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
chain identity@pt → factory pt → E → identity@E via R220's
`VarietyHCAt_of_SHSM2_composed3`. Distinct from R220's 12th route
(which used R218-native pt → E) and R221's 13th route (which used
factory `to_SHSM2` directly without composition). -/
theorem VarietyHCAt_ellipticCurve_codim1_via_internalCycleAction_compose3 :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_SHSM2_composed3
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    SHSM2_point_to_E_from_internalCycleAction
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 3: Priority C — narrow generic helper

Narrow helper showing that ANY `InternalCycleActionData_SHSM` factory
data can be used as the MIDDLE morphism of a three-step v2 SHSM2 chain.
Useful boilerplate-removal for future factory-based compositions. -/

/-- **R222 narrow integration helper**: factory-generated v2 SHSM2
packages plug as middle morphisms into `SHSM2_compose3`-style three-step
chains. Given factory data at middle `(p₁, p₂)`, left v2 package at
`(p₀, p₁)`, right v2 package at `(p₂, p₃)`, and HC at the leftmost
source, derive HC at the rightmost target. -/
theorem VarietyHCAt_of_internalCycleAction_SHSM2_composed3
    {X Y Z W : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {AW : AlgebraicClassesData W}
    {p₀ p₁ p₂ p₃ : ℕ}
    (P_left : ShiftedMTCorrespondencePackageAt_SHSM2 X Y AX AY p₀ p₁)
    (factory : InternalCycleActionData_SHSM Y Z AY AZ p₁ p₂)
    (P_right : ShiftedMTCorrespondencePackageAt_SHSM2 Z W AZ AW p₂ p₃)
    (h_HC_src : VarietyHCAt X AX p₀) :
    VarietyHCAt W AW p₃ :=
  VarietyHCAt_of_SHSM2_composed3 P_left factory.to_SHSM2 P_right h_HC_src

/-! ## Section 4: Priority D — disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_FactoryGeneratedPackage_CompositionWithTrueCorrespondences**:
verifying factory-generated v2 SHSM2 packages compose with packages
derived from real Chow-cycle correspondences (rather than linear-algebraic
stand-ins). R222 verifies composition only at the linear-algebraic
skeleton level. -/
abbrev L4_G_FactoryGeneratedPackage_CompositionWithTrueCorrespondences :
    Prop := True

/-- **L4-G_InternalCycleAction_To_MultiStepMTCalculus**: deriving the
multi-step MT correspondence calculus directly from the factory
(without going through SHSM2 intermediate). R222 only demonstrates
compositional integration via `to_SHSM2` + `SHSM2_compose3`. -/
abbrev L4_G_InternalCycleAction_To_MultiStepMTCalculus : Prop := True

/-- **L4-G_FactoryGeneratedPackage_E7ChainIntegration**: scaling the
factory + multi-step pattern to the E_7 / EVII Shimura context.
Requires the deferred E_7-side factory instance (would build the
real `canonicalE7ShimuraTor.mtCorrespondencePackage` data). -/
abbrev L4_G_FactoryGeneratedPackage_E7ChainIntegration : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R222 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R222_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R222 non-closure (2/4)**: does NOT implement real Chow
correspondence functoriality. -/
theorem R222_does_not_implement_real_chow_functoriality : True := trivial

/-- **R222 non-closure (3/4)**: does NOT implement real product-cycle
provenance for factory data. -/
theorem R222_does_not_implement_real_product_cycle_provenance : True := trivial

/-- **R222 non-closure (4/4)**: only verifies that factory-generated
packages integrate with R220's multi-step SHSM2 calculus. No new
factory instance, no E_7 toy, no n-step generalisation. -/
theorem R222_only_verifies_factory_multistep_integration : True := trivial

end GenericCycleActionMultiStep
end HCGapL4
end HodgeReduction
