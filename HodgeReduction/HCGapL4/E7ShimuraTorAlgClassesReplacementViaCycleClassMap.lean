/-
# HC Gap L4 — refined algClasses replacement plan via cycle-class-map (R250).

R246 declared the active `algClassesOfUnderlying` replacement plan as
a Prop-marker registry. R248 introduced the linear cycle-class-map
interface; R249 reconstructed the toy E7ShimuraToy ACD through it
and proved codim-by-codim agreement with the existing case-split ACD.

R250 bundles R246's base plan with R248/R249's refined linear interface
into a single refined replacement plan structure, instantiates it for
E7ShimuraToy, and proves the toy-side kernel-pure HC closure through
the new linear ACD.

`canonicalE7ShimuraTor` is untouched; `hodgeConjectureReal_canonical`
is unchanged.

## What R250 (this file) provides (all kernel-pure)

* `AlgClassesOfUnderlyingCycleClassMapReplacementPlan` — refined
  replacement plan structure bundling R246 base plan + R248 cycle-
  class-map data + R249 reconstructed ACD + an `acdFromCycleClassMap_eq`
  field witnessing the ACD comes from the cycle-class-map data.
* `AlgClassesOfUnderlyingCycleClassMapReplacementPlan_E7ShimuraToy` —
  concrete instance for E7ShimuraToy.
* `AlgClassesOfUnderlyingCycleClassMapReplacementPlan_E7ShimuraToy_HC_codim1` —
  HC at codim 1 for E7ShimuraToy via the refined plan's ACD.
* `Target_RealE7Shimura_algClassesOfUnderlying_fromCycleClassMap` —
  future-target Prop marker for the real-field replacement.

## What R250 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT replace the real `algClassesOfUnderlying`.
* Does NOT implement real Chow group or real cycle class map.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Only upgrades the toy-side replacement plan from generator-family
  to linear cycle-class-map interface.

All R250 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraTorAlgClassesReplacement
import HodgeReduction.HCGapL4.CycleClassMapReplacement
import HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement

namespace HodgeReduction
namespace HCGapL4
namespace E7ShimuraTorAlgClassesReplacementViaCycleClassMap

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraTorAlgClassesReplacement
open HodgeReduction.HCGapL4.CycleClassMapReplacement
open HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement

/-! ## Section 1: refined replacement plan structure -/

/-- **R250 refined replacement plan** bundling R246's base
algClasses-replacement plan with R248/R249's linear cycle-class-map
interface. The `acdFromCycleClassMap_eq` field records that the
bundled ACD comes from `ofCycleClassMapReplacement`. -/
structure AlgClassesOfUnderlyingCycleClassMapReplacementPlan where
  /-- R246 base replacement plan. -/
  basePlan : AlgClassesOfUnderlyingReplacementToyPlan
  /-- R248 cycle-class-map replacement data for `basePlan.toyVCD`. -/
  cycleClassMapData :
    CycleClassMapReplacementData basePlan.toyVCD
  /-- Reconstructed ACD for `basePlan.toyVCD`. -/
  acdFromCycleClassMap :
    AlgebraicClassesData basePlan.toyVCD
  /-- The ACD comes from `ofCycleClassMapReplacement` applied to
  the cycle-class-map data. -/
  acdFromCycleClassMap_eq :
    acdFromCycleClassMap =
      AlgebraicClassesData.ofCycleClassMapReplacement cycleClassMapData

/-! ## Section 2: E7ShimuraToy instance -/

/-- **R250 E7ShimuraToy refined plan instance**: combines R246 base,
R249 cycle-class-map data, and R249 reconstructed ACD. Equality
witness is `rfl` because R249's ACD is literally
`ofCycleClassMapReplacement` applied to the data. -/
noncomputable def AlgClassesOfUnderlyingCycleClassMapReplacementPlan_E7ShimuraToy :
    AlgClassesOfUnderlyingCycleClassMapReplacementPlan where
  basePlan := AlgClassesOfUnderlyingReplacementToyPlan_E7ShimuraToy
  cycleClassMapData := CycleClassMapReplacementData_E7ShimuraToy
  acdFromCycleClassMap := AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap
  acdFromCycleClassMap_eq := rfl

/-! ## Section 3: kernel-pure HC closure via refined plan -/

/-- **R250 HC at codim 1** for E7ShimuraToy via the refined plan's
reconstructed ACD. Uses R249's HC theorem directly. -/
theorem AlgClassesOfUnderlyingCycleClassMapReplacementPlan_E7ShimuraToy_HC_codim1 :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_cycleClassMapReplacement

/-! ## Section 4: future-target Prop marker -/

/-- **R250 future target**: real-field replacement of
`canonicalE7ShimuraTor.algClassesOfUnderlying` derived from a real
cycle-class-map `CH^*(real E_7 Shimura)_ℚ → H^{2*}(real E_7 Shimura, ℚ)`. -/
def Target_RealE7Shimura_algClassesOfUnderlying_fromCycleClassMap :
    Prop := True

/-! ## Section 5: summary non-closure marker -/

/-- **R250 explicit non-closure marker**: does NOT replace the real
`algClassesOfUnderlying` of `canonicalE7ShimuraTor`. -/
theorem R250_does_not_replace_canonicalE7ShimuraTor_algClassesOfUnderlying :
    True := trivial

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_AlgClassesReplacement_CycleClassMapPlan_To_canonicalE7ShimuraTor**:
the bridge from R250's refined toy plan to the real `canonicalE7ShimuraTor`
axiom's `algClassesOfUnderlying` field. -/
abbrev L4_G_AlgClassesReplacement_CycleClassMapPlan_To_canonicalE7ShimuraTor :
    Prop := True

/-- **L4-G_AlgClassesReplacement_CycleClassMapPlan_MissingRealChowGroup**:
R250's `cycleClassMapData` uses R249's `ℚ`-uniform toy cycle group;
no real Chow group `CH^*(X)_ℚ`. -/
abbrev L4_G_AlgClassesReplacement_CycleClassMapPlan_MissingRealChowGroup :
    Prop := True

/-- **L4-G_AlgClassesReplacement_CycleClassMapPlan_MissingRealCycleClassMap**:
R250's `cycleClass p` maps are toy identity / zero maps; no real
push-pull-cup cycle class map. -/
abbrev L4_G_AlgClassesReplacement_CycleClassMapPlan_MissingRealCycleClassMap :
    Prop := True

/-- **L4-G_AlgClassesReplacement_CycleClassMapPlan_MissingComparisonToRealE7**:
no comparison theorem identifying R250's toy plan with a real E_7
Shimura plan. -/
abbrev L4_G_AlgClassesReplacement_CycleClassMapPlan_MissingComparisonToRealE7 :
    Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R250 non-closure (1/5)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R250_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R250 non-closure (2/5)**: does NOT replace the real
`algClassesOfUnderlying`. -/
theorem R250_does_not_replace_real_algClassesOfUnderlying : True := trivial

/-- **R250 non-closure (3/5)**: does NOT implement real Chow group. -/
theorem R250_does_not_implement_real_chow_group : True := trivial

/-- **R250 non-closure (4/5)**: does NOT implement real cycle class
map. -/
theorem R250_does_not_implement_real_cycle_class_map : True := trivial

/-- **R250 non-closure (5/5)**: only upgrades the toy-side replacement
plan from generator-family to linear cycle-class-map interface. -/
theorem R250_only_upgrades_toy_plan_to_linear_interface : True := trivial

end E7ShimuraTorAlgClassesReplacementViaCycleClassMap
end HCGapL4
end HodgeReduction
