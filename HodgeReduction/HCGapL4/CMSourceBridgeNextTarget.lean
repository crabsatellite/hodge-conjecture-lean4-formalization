/-
# HC Gap L4 — CM-source bridge next-target audit (R264).

R260–R263 introduced four interface layers + EC regression instances:
* R260 AV interface skeleton + AV HC source interface skeleton
* R261 CM AV interface skeleton + CM marker fields
* R262 Deligne 1982 boundary interface
* R263 CM-source replacement bridge tying everything to R256/R259

Each layer carries Prop-level placeholders (interface markers) that
future real instances must replace with substantive content. R264
audits the remaining Prop placeholders and recommends the smallest
**real Mathlib-side** theorem/interface to attack next.

Per the user's R264 brief, this is target selection only: no real
construction, no proof of Deligne 1982, no closure of
`canonicalE7ShimuraTor`.

## What R264 (this file) provides (all kernel-pure)

* `CMSourceBridgeNextTargetSkeleton` — audit-marker structure
  bundling the R263 bridge plus six metadata fields about the chosen
  next target.
* `CMSourceBridgeNextTargetSkeleton_chosen` — recommended target
  registry instance.
* `Target_AbelianVarietyInterfaceFromEllipticCurveGroup` — chosen
  smallest formal target.
* `Target_CMEndomorphismAlgebraInterfaceForEllipticCurve` —
  alternative target marker.
* `CMSourceBridgeRecommendedNextTarget` — recommendation marker.

## What R264 (this file) does NOT do

* Does NOT implement a real abelian variety.
* Does NOT implement real complex multiplication.
* Does NOT prove Deligne 1982.
* Does NOT close `canonicalE7ShimuraTor`.
* Only selects the smallest next target.

All R264 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.AbelianVarietyInterface
import HodgeReduction.HCGapL4.ComplexMultiplicationInterface
import HodgeReduction.HCGapL4.Deligne1982BoundaryInterface
import HodgeReduction.HCGapL4.CMSourceReplacementBridge

namespace HodgeReduction
namespace HCGapL4
namespace CMSourceBridgeNextTarget

open HodgeReduction.HCGapL4.AbelianVarietyInterface
open HodgeReduction.HCGapL4.ComplexMultiplicationInterface
open HodgeReduction.HCGapL4.Deligne1982BoundaryInterface
open HodgeReduction.HCGapL4.CMSourceReplacementBridge

/-! ## Section 1: next-target audit structure -/

/-- **R264 next-target audit structure**. Bundles R263's bridge plus
metadata about the recommended next target: name, Mathlib-side vs
project-local, whether it blocks the real CM source, whether it can
use the EC seed, and whether it generalises to higher dim. -/
structure CMSourceBridgeNextTargetSkeleton where
  /-- The R263 CM-source replacement bridge. -/
  bridge : CMSourceReplacementBridgeSkeleton
  /-- Display name for the chosen next target. -/
  nextTargetName : String
  /-- Prop marker: target is Mathlib-side (lives in Mathlib's source
  tree, not just our HodgeReduction project). -/
  targetIsMathlibSide : Prop
  /-- Prop marker: target is project-local (lives in our project). -/
  targetIsProjectLocal : Prop
  /-- Prop marker: target blocks producing a real CM source. -/
  targetBlocksRealCMSource : Prop
  /-- Prop marker: target can use Mathlib's `EllipticCurve.Group`
  infrastructure as a seed. -/
  targetCanUseEllipticCurveSeed : Prop
  /-- Prop marker: target is expected to generalise to
  higher-dimensional abelian varieties. -/
  targetExpectedToGeneralizeToHigherDimension : Prop

/-! ## Section 2: chosen smallest next target

Recommended: turn the EC seed instance
(`EllipticCurveAsAbelianVarietyInterfaceSkeleton`) into a partial
real instance by REDUCING its Prop placeholders. Specifically,
replace `hasGroupLawToy := True` with a concrete witness derived
from `Mathlib.AlgebraicGeometry.EllipticCurve.Group`'s group law on
`E.toAffine.Point`. This is the smallest real-ish step closest to
existing Mathlib infrastructure. -/

/-- **R264 chosen smallest next target marker**: turn the EC seed
instance into a partial real instance by reducing Prop placeholders
using `Mathlib.AlgebraicGeometry.EllipticCurve.Group`. -/
def Target_AbelianVarietyInterfaceFromEllipticCurveGroup : Prop := True

/-- **R264 alternative target marker**: define a real CM-endomorphism-algebra
interface for the elliptic curve case (using imaginary quadratic CM
fields). Larger scope than the chosen target; requires more new
Mathlib code (CM-type theory, reflex field). -/
def Target_CMEndomorphismAlgebraInterfaceForEllipticCurve : Prop := True

/-! ## Section 3: recommendation marker -/

/-- **R264 recommended next target marker**: between the two targets
above, the chosen one (`Target_AbelianVarietyInterfaceFromEllipticCurveGroup`)
is recommended for R265, because:

1. It has the **closest path to existing Mathlib**:
   `Mathlib.AlgebraicGeometry.EllipticCurve.Group` is already
   imported (R254 audit) and provides `E.toAffine.Point` group law.
2. It has the **lowest risk**: the goal is to swap one Prop marker
   (`hasGroupLawToy := True`) for a concrete witness referencing the
   Mathlib group instance; no new Mathlib infrastructure required.
3. It is **incremental**: future R266+ can repeat the pattern for
   `hasProjectiveVarietyToy`, `hasSmoothProperToy`, etc.
4. It **does NOT need a full high-dim abelian variety**, so it is a
   single-round Cat 1 chunk (~200-400 lines) per the
   `feedback_mathlib_gap_never_stopping_decompose_to_single_rounds`
   guidance. -/
def CMSourceBridgeRecommendedNextTarget : Prop := True

/-! ## Section 4: next-target registry instance -/

/-- **R264 next-target registry instance** with chosen target =
"reduce Prop placeholders in EC AV interface using Mathlib EC group
infrastructure". -/
noncomputable def CMSourceBridgeNextTargetSkeleton_chosen :
    CMSourceBridgeNextTargetSkeleton where
  bridge := CMSourceReplacementBridgeSkeleton_ellipticCurveRegression
  nextTargetName :=
    "AbelianVarietyInterfaceFromEllipticCurveGroup (reduce Prop placeholders)"
  -- The target IS Mathlib-side in the sense that it consumes a
  -- Mathlib instance; the wrapper code lives in our project.
  targetIsMathlibSide := True
  targetIsProjectLocal := True
  -- Reducing the EC interface Prop fields unblocks the dim-1 case of
  -- the "real CM source" path; higher-dim AVs remain blocked at
  -- Mathlib level.
  targetBlocksRealCMSource := True
  targetCanUseEllipticCurveSeed := True
  -- The dim-1 pattern (`E.toAffine.Point` group law) is specific to
  -- dim 1; higher-dim AV group law requires a real `AbelianVariety`
  -- bundle (absent in Mathlib per R254 audit). So this target does
  -- NOT generalise to higher dim WITHOUT additional Mathlib work.
  targetExpectedToGeneralizeToHigherDimension := False

/-! ## Section 5: explicit non-closure -/

/-- **R264 non-closure (1/4)**: does NOT implement real abelian
varieties. -/
theorem R264_does_not_implement_real_abelian_variety : True := trivial

/-- **R264 non-closure (2/4)**: does NOT implement real complex
multiplication. -/
theorem R264_does_not_implement_real_CM : True := trivial

/-- **R264 non-closure (3/4)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R264_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R264 non-closure (4/4)**: only selects the next target; no
mathematical content beyond target metadata. -/
theorem R264_only_selects_next_target : True := trivial

end CMSourceBridgeNextTarget
end HCGapL4
end HodgeReduction
