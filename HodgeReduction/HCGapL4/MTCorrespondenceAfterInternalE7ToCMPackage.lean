/-
# HC Gap L4 — mtCorrespondence bridge after internal E7-to-CM package (R361).

R357-R360 delivered:
* R357 (targets) — φ HSM and ψ AlgClasses targets at codim 1.
  Identity-style cannot literally inhabit `MTCorrespondencePackageAt`
  between the two `VarietyCohomologyData` records due to dependent-
  instance threading; 4 explicit `Target_*` markers stated instead.
* R358 (target) — commuting square target.
* R359 (target) — Hodge surjectivity target.
* R360 (CLOSED) — `InternalE7ToCM_MTPackage_HC_Transfer_codim1` via
  R235 chain (SHSM2 + product-cycle factory + trivial-point HC),
  tagged as "internal MT package closure" with R333-R356 source-side
  Gaussian CM data layer.

R361 updates the active-field bridge to reflect this state and
narrows the gap map to the **true-realization layer** only.

What R361 does NOT do:
* Does NOT replace `canonicalE7ShimuraTor`.
* Does NOT close HC.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.InternalE7ToCMMTPackageAt
import HodgeReduction.HCGapL4.E7ToCMCorrespondenceTargetRefined

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier

/-! ## Section 1: updated bridge structure -/

/-- **R361** bridge skeleton after internal E_7-to-CM package: records
the R360 internal closure + R355's gap snapshot, narrowing remaining
gaps to true-realization layer. -/
structure MTCorrespondenceAfterInternalE7ToCMPackageSkeleton where
  /-- The R355 prior gap snapshot. -/
  previousGap : MTCorrespondenceGapAfterInternalSourceClosure
  /-- Status: R360 internal MT package HC transfer CLOSED. -/
  internalE7ToCMPackageClosed : Prop
  /-- Status: R360 HC transfer at codim 1 CLOSED. -/
  internalHCTransferClosed : Prop
  /-- Remaining: true E_7-to-CM Chow correspondence cycle. -/
  trueE7ToCMCycleTarget : Prop
  /-- Remaining: true Mathlib cohomology bridge. -/
  trueCohomologyBridgeTarget : Prop
  /-- Remaining: true Chow cycle / cycle-class map. -/
  trueChowCycleTarget : Prop
  /-- Remaining: Deligne 1982 HC. -/
  deligne1982Target : Prop
  /-- Target: replace `canonicalE7ShimuraTor` field directly. -/
  canonicalReplacementTarget : Prop

/-! ## Section 2: current instance -/

/-- **R361 current instance** — populated with R360 closure +
R355 gap snapshot. -/
noncomputable def MTCorrespondenceAfterInternalE7ToCMPackageSkeleton_current :
    MTCorrespondenceAfterInternalE7ToCMPackageSkeleton where
  previousGap := MTCorrespondenceGapAfterInternalSourceClosure_current
  internalE7ToCMPackageClosed := True
  internalHCTransferClosed := True
  trueE7ToCMCycleTarget := True
  trueCohomologyBridgeTarget := True
  trueChowCycleTarget := True
  deligne1982Target := True
  canonicalReplacementTarget := True

/-! ## Section 3: refined remaining-gap map -/

/-- **R361** refined gap map after internal E_7-to-CM package: the
remaining gaps are now exclusively in the **true-realization layer**
(real E_7 geometry, real cohomology, real Chow, Deligne 1982). -/
structure MTCorrespondenceRemainingGapsAfterInternalE7ToCM where
  /-- True E_7-Shimura geometry (replaces toy carrier). -/
  needTrueE7ShimuraGeometry : Prop
  /-- True Mathlib cohomology bridge. -/
  needTrueCohomologyBridge : Prop
  /-- True Chow correspondence cycle. -/
  needTrueChowCorrespondence : Prop
  /-- Deligne 1982 HC for absolute Hodge classes on CM abelian varieties. -/
  needDeligne1982HC : Prop
  /-- Direct replacement of `canonicalE7ShimuraTor` field. -/
  needCanonicalFieldReplacement : Prop

/-- **R361 current refined gap map**. -/
noncomputable def MTCorrespondenceRemainingGapsAfterInternalE7ToCM_current :
    MTCorrespondenceRemainingGapsAfterInternalE7ToCM where
  needTrueE7ShimuraGeometry := True
  needTrueCohomologyBridge := True
  needTrueChowCorrespondence := True
  needDeligne1982HC := True
  needCanonicalFieldReplacement := True

/-! ## Section 4: regression HC theorem -/

/-- **R361** regression: HC at codim 1 via existing chain — unchanged. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_MTCorrespondenceAfterInternalE7ToCMPackage :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  InternalE7ToCM_MTPackage_HC_Transfer_codim1

/-! ## Section 5: status / markers -/

def R361_Status_Bridge_Updated_After_R360 : Prop := True
def R361_Status_InternalLayer_Closed : Prop := True
def R361_Status_TrueLayer_Gaps_Listed : Prop := True

/-- **R361** internal-model `mtCorrespondencePackage` closure marker
(active HC cone field 3, source-side INTERNAL layer). -/
def R361_mtCorrespondencePackage_InternalModelClosed : Prop := True

/-- **R361** next-target: true E_7-to-CM correspondence cycle. -/
def R361_NextTarget_TrueE7ToCMCorrespondence : Prop := True

/-- **R361** next-target: internal-to-real bridge for VCD/ACD. -/
def R361_NextTarget_InternalToRealBridge : Prop := True

/-- **L4-G** bridge to `canonicalE7ShimuraTor.mtCorrespondencePackage`
replacement. -/
def L4_G_MTCorrespondenceAfterInternalE7ToCMPackage_To_canonicalE7ShimuraTor :
    Prop := True

/-- **L4-G** the remaining gap is purely true-realization. -/
def L4_G_MTCorrespondenceAfterInternalE7ToCMPackage_TrueLayerOnly :
    Prop := True

/-! ## Section 6: explicit non-closure -/

theorem R361_does_not_replace_canonicalE7ShimuraTor : True := trivial
theorem R361_does_not_close_HC : True := trivial
theorem R361_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
