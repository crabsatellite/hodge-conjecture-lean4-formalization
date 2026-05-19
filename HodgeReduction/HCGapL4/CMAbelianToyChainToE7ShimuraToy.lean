/-
# HC Gap L4 — multi-step CM-source chain to E_7 toy via factory composition (R238).

R235 built a point-source MT package, R236 built a CM-source direct route,
R237 upgraded the CM-source route with product-cycle provenance. R238
composes two existing product-cycle factories into the first **multi-step
CM-source chain**:

```
pt --[R223]--> EllipticCurve --[R237]--> E7ShimuraToy
codim 0  -->  codim 1     -->  codim 1
```

Both factories carry product-cycle provenance. R226's
`ProductCycleFactory_compose_to_SHSM2` chains them into a single v2 SHSM2
package `pt → E7ShimuraToy` at codim `(0, 1)`. The resulting HC closure
runs entirely from the point HC, through the CM-source toy, into the
E_7 toy.

R235 (point-source direct) and R237 (CM-source direct) are PRESERVED; R238
adds the chained route in parallel.

## What R238 (this file) provides (all kernel-pure)

* `SHSM2_point_to_E7ShimuraToy_via_CMAbelianToy_productCycle_chain` —
  v2 SHSM2 from composing R223 and R237 factories via R226.
* `VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_productCycle_chain` —
  HC at codim 1 for E_7 toy via the composed chain.
* `E7ShimuraToyMTCorrespondencePackageViaCMAbelianToyChainSkeleton` —
  chain-shaped package toy skeleton (specialised to the two existing
  factory instances).
* `E7ShimuraToy_MTCorrespondencePackageViaCMAbelianToyChainSkeleton` —
  concrete instance.
* `VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_chainSkeleton` —
  HC via the chain skeleton.

## What R238 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT implement real motivic factorisation.
* Does NOT implement true Chow composition (Manin–Voevodsky).
* Does NOT prove product cycles semantically induce actions.
* Does NOT prove Deligne 1982.
* Does NOT implement actual CM endomorphisms or real CM abelian
  variety theory.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT identify `E7ShimuraToy` with the real canonical E_7
  Shimura variety.

All R238 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
import HodgeReduction.HCGapL4.ProductCycleFactoryLifter
import HodgeReduction.HCGapL4.ProductCycleFactoryComposition
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.CMAbelianToyProductCycleToE7ShimuraToy

namespace HodgeReduction
namespace HCGapL4
namespace CMAbelianToyChainToE7ShimuraToy

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.GenericCycleAction
open HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
open HodgeReduction.HCGapL4.ProductCycleFactoryLifter
open HodgeReduction.HCGapL4.ProductCycleFactoryComposition
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.CMAbelianToyProductCycleToE7ShimuraToy

/-! ## Section 1: SHSM2 chain via R226 `ProductCycleFactory_compose_to_SHSM2` -/

/-- **R238 multi-step CM-source chain SHSM2**: compose R223's
`pt → EC` codim `(0, 1)` factory with R237's `EC → E7ShimuraToy`
codim `(1, 1)` factory via R226. Middle codim matches (`p₁ = 1`),
output at `pt → E7ShimuraToy` codim `(0, 1)`. -/
theorem SHSM2_point_to_E7ShimuraToy_via_CMAbelianToy_productCycle_chain :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      VarietyCohomologyData_E7ShimuraToy
      TrivialPoint.algClasses_point
      AlgebraicClassesData_E7ShimuraToy
      0 1 :=
  ProductCycleFactory_compose_to_SHSM2
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve
    internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy

/-! ## Section 2: HC closure via the composed chain -/

/-- **R238 HC at codim 1 for E_7 toy via CM-source chain**: runs
through the point HC, the R223 factory (pt → EC codim 0→1), and the
R237 factory (EC → E7ShimuraToy codim 1→1), composed via R226. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_productCycle_chain :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_productCycleFactory_compose
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve
    internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 3: chain-shaped package skeleton (specialised) -/

/-- **R238 chain-shaped CM-source MT correspondence package toy**:
specialised to the existing R223 + R237 factory pair. Bundles the
R234 datum, the R236 EC-based CM toy source, both factories, and the
composed SHSM2 correspondence. -/
structure E7ShimuraToyMTCorrespondencePackageViaCMAbelianToyChainSkeleton where
  /-- The R234 assembled Shimura datum toy. -/
  datumToy : E7ShimuraDatumToySkeleton
  /-- The CM-abelian-shaped toy source (EC-based, R236). -/
  sourceCMToy : CMAbelianVarietyToySkeleton
  /-- The R223 factory `pt → EC` codim `(0, 1)`. -/
  pointToCMToyFactory :
    InternalCycleActionData_SHSM_WithProductCycle
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      ProductCohomology.VarietyCohomologyData_pointTimesEllipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      ProductCohomology.AlgebraicClassesData_pointTimesEllipticCurve
      0 1 1
  /-- The R237 factory `EC → E7ShimuraToy` codim `(1, 1)`. -/
  cmToyToE7ToyFactory :
    InternalCycleActionData_SHSM_WithProductCycle
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy
      AlgebraicClassesData_ellipticCurveTimesE7ShimuraToy
      1 1 1
  /-- The composed SHSM2 correspondence. -/
  composedCorrespondenceToy :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      VarietyCohomologyData_E7ShimuraToy
      TrivialPoint.algClasses_point
      AlgebraicClassesData_E7ShimuraToy
      0 1

/-- **R238 concrete chain-shaped package instance**. -/
noncomputable def E7ShimuraToy_MTCorrespondencePackageViaCMAbelianToyChainSkeleton :
    E7ShimuraToyMTCorrespondencePackageViaCMAbelianToyChainSkeleton where
  datumToy := E7ShimuraDatumToySkeleton_V56Weight3
  sourceCMToy := CMAbelianVarietyToySkeleton_ellipticCurveLike
  pointToCMToyFactory :=
    internalCycleActionData_SHSM_WithProductCycle_point_to_ellipticCurve
  cmToyToE7ToyFactory :=
    internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy
  composedCorrespondenceToy :=
    SHSM2_point_to_E7ShimuraToy_via_CMAbelianToy_productCycle_chain

/-! ## Section 4: HC via the chain skeleton -/

/-- **R238 HC at codim 1 for E_7 toy via chain skeleton**: uses the
package's composed correspondence + `SHSM2_toRaw` + R212 shifted
transfer from the point HC. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_chainSkeleton :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      E7ShimuraToy_MTCorrespondencePackageViaCMAbelianToyChainSkeleton.composedCorrespondenceToy)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_CMAbelianToyChain_To_RealMotivicFactorization**: upgrading
the toy two-step factory composition to a genuine motivic /
Manin–Voevodsky factorisation `pt → A_CM → S(EVII)` of the headline
correspondence. -/
abbrev L4_G_CMAbelianToyChain_To_RealMotivicFactorization : Prop := True

/-- **L4-G_CMAbelianToyChain_To_canonicalE7ShimuraTor_mtCorrespondencePackage**:
the bridge from the chain-shaped toy package to the genuine
`canonicalE7ShimuraTor.mtCorrespondencePackage` field. -/
abbrev L4_G_CMAbelianToyChain_To_canonicalE7ShimuraTor_mtCorrespondencePackage :
    Prop := True

/-- **L4-G_CMAbelianToyChain_MissingTrueChowComposition**: the chain
composition drops both factories' cycleClass fields (carried from
R226). Real composition would compose Chow cycles via Manin–Voevodsky
push-pull-cup. -/
abbrev L4_G_CMAbelianToyChain_MissingTrueChowComposition : Prop := True

/-- **L4-G_CMAbelianToyChain_MissingDeligne1982**: the chain's CM-source
HC witness is the EC internal HC, not Deligne 1982 (carried from R236). -/
abbrev L4_G_CMAbelianToyChain_MissingDeligne1982 : Prop := True

/-- **L4-G_CMAbelianToyChain_MissingActualCMEndomorphisms**: the
chain's CM-source toy has no actual CM endomorphism algebra (carried
from R236). -/
abbrev L4_G_CMAbelianToyChain_MissingActualCMEndomorphisms : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R238 non-closure (1/6)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R238_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R238 non-closure (2/6)**: does NOT implement real motivic
factorisation. -/
theorem R238_does_not_implement_real_motivic_factorization : True := trivial

/-- **R238 non-closure (3/6)**: does NOT implement true Chow
composition (Manin–Voevodsky cycle composition). -/
theorem R238_does_not_implement_true_chow_composition : True := trivial

/-- **R238 non-closure (4/6)**: does NOT prove product cycles
semantically induce the actions. -/
theorem R238_does_not_prove_cycles_induce_actions : True := trivial

/-- **R238 non-closure (5/6)**: does NOT prove Deligne 1982. -/
theorem R238_does_not_prove_deligne_1982 : True := trivial

/-- **R238 non-closure (6/6)**: does NOT identify `E7ShimuraToy` with
the real canonical E_7 Shimura variety. -/
theorem R238_does_not_identify_toy_with_real_E7Shimura : True := trivial

end CMAbelianToyChainToE7ShimuraToy
end HCGapL4
end HodgeReduction
