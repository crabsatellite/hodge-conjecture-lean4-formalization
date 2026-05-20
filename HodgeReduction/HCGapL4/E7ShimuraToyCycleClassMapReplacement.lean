/-
# HC Gap L4 — E7ShimuraToy cycle-class-map replacement instance (R249).

R248 introduced the linear cycle-class-map replacement interface
`CycleClassMapReplacementData`. R249 instantiates it for the E7ShimuraToy
internal model, reconstructing `AlgebraicClassesData_E7ShimuraToy`
through this linear interface.

The cycle-class-map for E7ShimuraToy:
* codim 0: `CycleGroup 0 := ℚ`, map `id : ℚ → ℚ = H^0`.
* codim 1: `CycleGroup 1 := ℚ`, map `id : ℚ → ℚ = H^2`.
* codim `p ≥ 2`: `CycleGroup p := ℚ`, map `0 : ℚ → PUnit = H^{2p}`.

This matches the existing case-split `AlgebraicClassesData_E7ShimuraToy`
(codim 0/1 = `⊤`, codim ≥ 2 = `⊥`) via `LinearMap.range_id` /
`LinearMap.range_zero` style identities.

## What R249 (this file) provides (all kernel-pure)

* `CycleClassMapReplacementData_E7ShimuraToy` — concrete instance.
* `AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap` — ACD
  reconstructed through R248's `ofCycleClassMapReplacement`.
* Per-codim agreement with existing ACD (codim 0, codim 1, and
  general `p + 2`).
* `VarietyHCAt_E7ShimuraToy_codim1_via_cycleClassMapReplacement` —
  HC at codim 1 through the new ACD.
* `VarietyHCAt_E7ShimuraToy_codim1_via_cycleClassMapReplacement_existingACD` —
  HC at codim 1 for the EXISTING ACD via transport through codim-1
  agreement.

## What R249 (this file) does NOT do

* Does NOT implement a real Chow group.
* Does NOT implement a real cycle class map.
* Does NOT replace `canonicalE7ShimuraTor.algClassesOfUnderlying`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Only reconstructs the toy ACD through the linear interface — a
  refactoring, not a real-replacement.

All R249 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.CycleClassMapReplacement
import Mathlib.Algebra.PUnitInstances.Module

namespace HodgeReduction
namespace HCGapL4
namespace E7ShimuraToyCycleClassMapReplacement

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.CycleClassMapReplacement

/-! ## Section 1: per-codim cycle class maps -/

/-- Cycle class map at codim 0: identity `ℚ →ₗ[ℚ] ℚ = H^0(E_7 toy)`. -/
noncomputable def E7ShimuraToyCycleClass_codim0 :
    ℚ →ₗ[ℚ] VarietyCohomologyData_E7ShimuraToy.H 0 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Cycle class map at codim 1: identity `ℚ →ₗ[ℚ] ℚ = H^2(E_7 toy)`. -/
noncomputable def E7ShimuraToyCycleClass_codim1 :
    ℚ →ₗ[ℚ] VarietyCohomologyData_E7ShimuraToy.H 2 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Cycle class map at codim `k + 2`: zero map `ℚ →ₗ[ℚ] PUnit`. -/
noncomputable def E7ShimuraToyCycleClass_high (k : ℕ) :
    ℚ →ₗ[ℚ] VarietyCohomologyData_E7ShimuraToy.H (2 * (k + 2)) := 0

/-- The full per-codim cycle class map family. -/
noncomputable def E7ShimuraToyCycleClass :
    ∀ p, ℚ →ₗ[ℚ] VarietyCohomologyData_E7ShimuraToy.H (2 * p)
  | 0     => E7ShimuraToyCycleClass_codim0
  | 1     => E7ShimuraToyCycleClass_codim1
  | k + 2 => E7ShimuraToyCycleClass_high k

/-! ## Section 2: cycle-class-map data instance -/

/-- **R249 cycle-class-map data instance** for `E7ShimuraToy`: uniform
`CycleGroup := ℚ` with per-codim maps from Section 1. -/
noncomputable def CycleClassMapReplacementData_E7ShimuraToy :
    CycleClassMapReplacementData VarietyCohomologyData_E7ShimuraToy where
  CycleGroup := fun _ => ℚ
  instAddCommGroup := fun _ => inferInstance
  instModule := fun _ => inferInstance
  cycleClass := E7ShimuraToyCycleClass
  cycleClass_isHodge := fun p z => by
    match p with
    | 0 =>
      show E7ShimuraToyCycleClass_codim0 z ∈
        VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree 0
      show E7ShimuraToyCycleClass_codim0 z ∈
        TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      rw [TrivialWeight.piece_ℚ_w0_zero]
      exact Submodule.mem_top
    | 1 =>
      show E7ShimuraToyCycleClass_codim1 z ∈
        VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree 1
      show E7ShimuraToyCycleClass_codim1 z ∈
        ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
      rw [ProjectiveLine.piece_ℚ_Tate2_one]
      exact Submodule.mem_top
    | k + 2 =>
      -- cycleClass at codim k+2 is the zero map; image lands in PUnit, which is
      -- subsingleton — the element equals 0 ∈ any submodule.
      show E7ShimuraToyCycleClass_high k z ∈
        VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree (k + 2)
      letI _ := VarietyCohomologyData_E7ShimuraToy.addCommGroup (2 * (k + 2))
      letI _ := VarietyCohomologyData_E7ShimuraToy.module (2 * (k + 2))
      letI _ := VarietyCohomologyData_E7ShimuraToy.hodgeStructure (2 * (k + 2))
      have hzero : E7ShimuraToyCycleClass_high k z = 0 := by
        show (0 : ℚ →ₗ[ℚ] VarietyCohomologyData_E7ShimuraToy.H (2 * (k + 2))) z = 0
        rfl
      rw [hzero]
      exact Submodule.zero_mem _

/-! ## Section 3: ACD via cycle-class-map -/

/-- **R249 reconstructed ACD** for E7ShimuraToy via R248's
`ofCycleClassMapReplacement`. -/
noncomputable def AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap :
    AlgebraicClassesData VarietyCohomologyData_E7ShimuraToy :=
  AlgebraicClassesData.ofCycleClassMapReplacement
    CycleClassMapReplacementData_E7ShimuraToy

/-! ## Section 4: codim-level agreement with existing ACD -/

/-- **R249 codim-0 agreement**: existing `algClasses 0 = ⊤` equals
new `algClasses 0 = LinearMap.range (id : ℚ →ₗ ℚ) = ⊤`. -/
theorem E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim0 :
    AlgebraicClassesData_E7ShimuraToy.algClasses 0 =
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap.algClasses 0 := by
  show (⊤ : Submodule ℚ (VarietyCohomologyData_E7ShimuraToy.H 0)) =
    LinearMap.range E7ShimuraToyCycleClass_codim0
  symm
  ext x
  simp only [Submodule.mem_top, iff_true, LinearMap.mem_range]
  exact ⟨x, rfl⟩

/-- **R249 codim-1 agreement**: same shape at codim 1. -/
theorem E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim1 :
    AlgebraicClassesData_E7ShimuraToy.algClasses 1 =
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap.algClasses 1 := by
  show (⊤ : Submodule ℚ (VarietyCohomologyData_E7ShimuraToy.H 2)) =
    LinearMap.range E7ShimuraToyCycleClass_codim1
  symm
  ext x
  simp only [Submodule.mem_top, iff_true, LinearMap.mem_range]
  exact ⟨x, rfl⟩

/-- **R249 codim ≥ 2 agreement**: existing `algClasses (k+2) = ⊥` equals
new `algClasses (k+2) = LinearMap.range 0 = ⊥`. -/
theorem E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim_high (k : ℕ) :
    AlgebraicClassesData_E7ShimuraToy.algClasses (k + 2) =
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap.algClasses (k + 2) := by
  show (⊥ : @Submodule ℚ (VarietyCohomologyData_E7ShimuraToy.H (2 * (k + 2))) _ _ _) =
    LinearMap.range (E7ShimuraToyCycleClass_high k)
  symm
  exact LinearMap.range_zero

/-- **R249 all-codims agreement**: combines the three case-split
agreements. -/
theorem E7ShimuraToy_algClasses_agree_fromCycleClassMap_all_codims :
    ∀ p,
      AlgebraicClassesData_E7ShimuraToy.algClasses p =
        AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap.algClasses p := by
  intro p
  match p with
  | 0     => exact E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim0
  | 1     => exact E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim1
  | k + 2 => exact E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim_high k

/-! ## Section 5: HC at codim 1 through new ACD -/

/-- **R249 HC via new ACD**: HC at codim 1 for E7ShimuraToy using the
reconstructed ACD. Directly via the R248 HC bridge with the cover
witness from `piece_ℚ_Tate2_one`. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_cycleClassMapReplacement :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap
      1 := by
  apply VarietyHCAt_of_cycleClassMapReplacement_surjective_on_hodgeClasses
  -- Show: hodgeClassesAtDegree 1 ≤ LinearMap.range E7ShimuraToyCycleClass_codim1
  intro x _
  -- E7ShimuraToyCycleClass_codim1 is identity, so range is ⊤
  exact ⟨x, rfl⟩

/-- **R249 HC for existing ACD via new route**: transport HC through
codim-1 agreement back to the existing ACD. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_cycleClassMapReplacement_existingACD :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 := by
  intro x hx
  -- Use new ACD HC, then transport via codim-1 agreement.
  have h_new := VarietyHCAt_E7ShimuraToy_codim1_via_cycleClassMapReplacement hx
  rw [E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim1]
  exact h_new

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_E7ShimuraToyCycleClassMapReplacement_To_RealChowMap**:
upgrading R249's toy `ℚ`-uniform cycle group to a real Chow group
`CH^p(real E_7 Shimura)_ℚ` with rational equivalence and push-pull. -/
abbrev L4_G_E7ShimuraToyCycleClassMapReplacement_To_RealChowMap :
    Prop := True

/-- **L4-G_E7ShimuraToyCycleClassMapReplacement_To_algClassesOfUnderlying**:
bridge from the linear-interface ACD to a real replacement of
`canonicalE7ShimuraTor.algClassesOfUnderlying`. -/
abbrev L4_G_E7ShimuraToyCycleClassMapReplacement_To_algClassesOfUnderlying :
    Prop := True

/-- **L4-G_E7ShimuraToyCycleClassMapReplacement_MissingRealCycles**:
the toy `ℚ`-uniform cycle group has no actual algebraic-cycle content
(no codim-`p` subvarieties, no formal sum of irreducible components). -/
abbrev L4_G_E7ShimuraToyCycleClassMapReplacement_MissingRealCycles :
    Prop := True

/-- **L4-G_E7ShimuraToyCycleClassMapReplacement_MissingChowEquivalence**:
the toy has no rational / algebraic / numerical equivalence relations. -/
abbrev L4_G_E7ShimuraToyCycleClassMapReplacement_MissingChowEquivalence :
    Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R249 non-closure (1/4)**: does NOT implement a real Chow group. -/
theorem R249_does_not_implement_real_chow_group : True := trivial

/-- **R249 non-closure (2/4)**: does NOT implement a real cycle class
map. -/
theorem R249_does_not_implement_real_cycle_class_map : True := trivial

/-- **R249 non-closure (3/4)**: does NOT replace
`canonicalE7ShimuraTor.algClassesOfUnderlying`. -/
theorem R249_does_not_replace_canonicalE7ShimuraTor_algClassesOfUnderlying :
    True := trivial

/-- **R249 non-closure (4/4)**: only reconstructs the toy ACD through
a linear cycle-class-map interface — a refactoring, not a
real-replacement. -/
theorem R249_only_reconstructs_toy_ACD_through_linear_interface :
    True := trivial

end E7ShimuraToyCycleClassMapReplacement
end HCGapL4
end HodgeReduction
