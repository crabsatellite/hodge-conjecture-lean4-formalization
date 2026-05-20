/-
# HC Gap L4 — CM-source replacement bridge into MT-correspondence
# package plan + R259 top-level transfer (R263).

R260 introduced `AbelianVarietyInterfaceSkeleton` +
`AbelianVarietyHCSourceInterfaceSkeleton` and an EC seed.
R261 added `CMAbelianVarietyInterfaceSkeleton` with CM-shape Prop
fields. R262 added the Deligne 1982 library-boundary interface.

R263 ties these three layers together and bridges them back into:
* R247's `mtCorrespondencePackage` replacement plan;
* R259's top-level `AbstractHCDataWithMTTransfer`.

The R263 bridge instance for the dim-1 EC regression case reuses
R259's fresh SHSM2 package (which targets the cycle-class-map-derived
ACD), so the R259 top-level package can carry the bridged CM source
through to the cycle-class-map target. This avoids forcing ACD
equality across the two parallel toy ACDs.

## What R263 (this file) provides (all kernel-pure)

* `CMSourceReplacementBridgeSkeleton` — bundle combining the
  R260 AV interface + R261 CM interface + R262 Deligne boundary +
  R256 abstract CM source.
* `CMSourceReplacementBridgeSkeleton_ellipticCurveRegression` —
  dim-1 EC regression instance.
* `L4_G_CMSourceReplacementBridge_To_MTCorrespondenceReplacementPlan`
  — marker connecting R263 to R247.
* `AbstractHCDataWithMTTransfer_E7ShimuraToy_from_CMSourceBridge` —
  R259 top-level package instance using the bridged CM source +
  R259's fresh cycle-class-map SHSM2.
* `VarietyHCAt_E7ShimuraToy_codim1_via_CMSourceReplacementBridge` —
  HC at codim 1 for the E_7-Shimura toy through the bridged route,
  with the cycle-class-map ACD as target (mismatch with original
  ACD recorded honestly in the doc comment).

## What R263 (this file) does NOT do

* Does NOT implement a real CM abelian variety.
* Does NOT implement real complex multiplication.
* Does NOT prove Deligne 1982.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

## ACD mismatch handling

For the regression instance, the target ACD is the
cycle-class-map-derived `AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap`
(R249), because R259's top-level package
`AbstractHCDataPackage_E7ShimuraToy` bundles that ACD. The original
ACD `AlgebraicClassesData_E7ShimuraToy` would NOT type-check with
that package. R263 honestly targets the cycle-class-map ACD and uses
R259's pre-built fresh SHSM2 (`SHSM2_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap_codim1_to_codim1`).

The original-ACD regression theorem
`VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianVarietyInterface_ellipticCurveLike`
(R261) and the Deligne-boundary original-ACD regression
`VarietyHCAt_E7ShimuraToy_codim1_via_Deligne1982BoundaryInterface_regression`
(R262) remain available for the original ACD route.

All R263 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL4.AbstractHodgeSource
import HodgeReduction.HCGapL4.AbstractHCDataPackage
import HodgeReduction.HCGapL4.AbstractHCDataWithMTTransfer
import HodgeReduction.HCGapL4.AbelianVarietyInterface
import HodgeReduction.HCGapL4.ComplexMultiplicationInterface
import HodgeReduction.HCGapL4.Deligne1982BoundaryInterface

namespace HodgeReduction
namespace HCGapL4
namespace CMSourceReplacementBridge

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.AbelianVarietyInterface
open HodgeReduction.HCGapL4.ComplexMultiplicationInterface
open HodgeReduction.HCGapL4.Deligne1982BoundaryInterface

/-! ## Section 1: bridge skeleton -/

/-- **R263 CM-source replacement bridge skeleton**. Bundles the four
layers introduced in R260–R262 plus R256's abstract CM source:
* `avInterface` — R260 AV HC source interface;
* `cmInterface` — R261 CM AV interface;
* `deligneBoundary` — R262 Deligne 1982 boundary interface;
* `abstractCMSource` — R256 abstract CM source filled from above.

Real instances will fill all four layers with genuine content; this
file's only instance is the dim-1 EC regression. -/
structure CMSourceReplacementBridgeSkeleton where
  /-- The R260 AV HC source interface. -/
  avInterface : AbelianVarietyHCSourceInterfaceSkeleton
  /-- The R261 CM AV interface. -/
  cmInterface : CMAbelianVarietyInterfaceSkeleton
  /-- The R262 Deligne 1982 boundary interface. -/
  deligneBoundary : Deligne1982HCInterfaceSkeleton
  /-- The R256 abstract CM source. -/
  abstractCMSource : AbstractCMAbelianHCSource

/-! ## Section 2: dim-1 EC regression instance -/

/-- **R263 dim-1 EC regression bridge instance**. Combines all four
layers from the EC seed: R260 EC AV interface, R261 EC CM-like
interface, R262 Deligne boundary regression, R256 abstract CM source
adapted from the Deligne boundary. -/
noncomputable def CMSourceReplacementBridgeSkeleton_ellipticCurveRegression :
    CMSourceReplacementBridgeSkeleton where
  avInterface := EllipticCurveAsAbelianVarietyHCSourceInterfaceSkeleton
  cmInterface := CMAbelianVarietyInterfaceSkeleton_ellipticCurveLike
  deligneBoundary := Deligne1982HCInterfaceSkeleton_ellipticCurveRegression
  abstractCMSource :=
    AbstractCMAbelianHCSource_from_Deligne1982BoundaryInterface_ellipticCurveRegression

/-! ## Section 3: connection to R247 MT-correspondence replacement plan -/

/-- **L4-G_CMSourceReplacementBridge_To_MTCorrespondenceReplacementPlan**:
the bridge from R263's CM-source replacement bridge to R247's
`MTCorrespondencePackageReplacementToyPlan`. -/
def L4_G_CMSourceReplacementBridge_To_MTCorrespondenceReplacementPlan :
    Prop := True

/-! ## Section 4: connection to R259 top-level abstract transfer

Builds an `AbstractHCDataWithMTTransfer` instance using the bridged
CM source from this file plus R259's fresh
`SHSM2_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap_codim1_to_codim1`
package. Target ACD is the cycle-class-map-derived ACD (R249), per
the R259 mismatch-resolution strategy. -/

/-- **R263 R259-targeting instance**: `AbstractHCDataWithMTTransfer`
built from the bridge's abstract CM source + R259's fresh SHSM2
targeting the cycle-class-map ACD. -/
noncomputable def AbstractHCDataWithMTTransfer_E7ShimuraToy_from_CMSourceBridge :
    AbstractHCDataWithMTTransfer where
  targetPackage := AbstractHCDataPackage_E7ShimuraToy
  sourceCM :=
    CMSourceReplacementBridgeSkeleton_ellipticCurveRegression.abstractCMSource
  p_src := 1
  p_tgt := 1
  correspondence :=
    { correspondence :=
        SHSM2_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap_codim1_to_codim1 }

/-! ## Section 5: regression HC theorem -/

/-- **R263 regression HC theorem**: HC at codim 1 for the E_7-Shimura
toy through the CM-source replacement bridge, with the
cycle-class-map ACD as target (per R259's mismatch-resolution
strategy). -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_CMSourceReplacementBridge :
    VarietyHCAt
      AbstractHCDataWithMTTransfer_E7ShimuraToy_from_CMSourceBridge.targetPackage.hodgeSource.vcd
      AbstractHCDataWithMTTransfer_E7ShimuraToy_from_CMSourceBridge.targetPackage.acd
      1 :=
  AbstractHCDataWithMTTransfer_E7ShimuraToy_from_CMSourceBridge.targetHCAt

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_CMSourceReplacementBridge_To_RealCMAbelianVariety**:
upgrading R263's CM-source replacement bridge to one whose
`avInterface` and `cmInterface` are inhabited by a real CM abelian
variety (currently absent in Mathlib per R254 audit). -/
def L4_G_CMSourceReplacementBridge_To_RealCMAbelianVariety : Prop := True

/-- **L4-G_CMSourceReplacementBridge_To_Deligne1982**: upgrading the
`deligneBoundary` field to a real Deligne 1982 HC theorem on real CM
abelian varieties. -/
def L4_G_CMSourceReplacementBridge_To_Deligne1982 : Prop := True

/-- **L4-G_CMSourceReplacementBridge_To_canonicalE7ShimuraTor_mtCorrespondencePackage**:
the bridge from R263 to the
`canonicalE7ShimuraTor.mtCorrespondencePackage` field via the
composed R256/R260–R263 adapter route. -/
def L4_G_CMSourceReplacementBridge_To_canonicalE7ShimuraTor_mtCorrespondencePackage :
    Prop := True

/-- **L4-G_CMSourceReplacementBridge_MissingActualAbelianVariety**:
the EC regression instance points at Mathlib `WeierstrassCurve ℚ`
through the type slots, but no real abelian-variety structure is
asserted (Prop markers only). -/
def L4_G_CMSourceReplacementBridge_MissingActualAbelianVariety :
    Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R263 non-closure (1/5)**: does NOT implement real abelian
varieties. -/
theorem R263_does_not_implement_real_abelian_varieties : True := trivial

/-- **R263 non-closure (2/5)**: does NOT implement real complex
multiplication. -/
theorem R263_does_not_implement_real_CM : True := trivial

/-- **R263 non-closure (3/5)**: does NOT prove Deligne 1982. -/
theorem R263_does_not_prove_deligne_1982 : True := trivial

/-- **R263 non-closure (4/5)**: does NOT replace
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R263_does_not_replace_mtCorrespondencePackage : True := trivial

/-- **R263 non-closure (5/5)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R263_does_not_close_canonicalE7ShimuraTor : True := trivial

end CMSourceReplacementBridge
end HCGapL4
end HodgeReduction
