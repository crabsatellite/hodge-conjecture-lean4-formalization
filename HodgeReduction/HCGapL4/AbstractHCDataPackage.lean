/-
# HC Gap L4 — unified HC data package (R258).

R257 unified the cohomology source side into `AbstractHodgeSource`
(R253's abstract cohomology source bundled with a target VCD and a
realization marker).

R258 unifies the algebraic-classes side with R248's linear
cycle-class-map interface: an `AbstractHCDataPackage` bundles an
`AbstractHodgeSource`, a `CycleClassMapReplacementData` on the source's
VCD, and the resulting `AlgebraicClassesData` (equal to the
cycle-class-map-derived ACD by construction). Downstream consumers
(R259 MT-correspondence transfer) work with one package instead of a
tuple.

Per the user's R258 brief, the new structure is interface
consolidation: no new mathematical content, no real Chow group, no
real cycle class map.

## What R258 (this file) provides (all kernel-pure)

* `AbstractHCDataPackage` — unified bundle of an `AbstractHodgeSource`,
  a `CycleClassMapReplacementData` on its VCD, an
  `AlgebraicClassesData` on its VCD, and an equality field tying the
  ACD to the cycle-class-map construction.
* `AbstractHCDataPackage.ofCycleClassMap` — constructor producing a
  package from an `AbstractHodgeSource` plus a
  `CycleClassMapReplacementData`, with ACD derived definitionally via
  R248's `ofCycleClassMapReplacement`.
* `AbstractHCDataPackage.VarietyHCAt_of_hodgeClasses_le_cycleClassRange` —
  generic HC bridge theorem: Hodge-class containment in the cycle
  class range gives `VarietyHCAt` at that codim through R248.
* `AbstractHCDataPackage_E7ShimuraToy` — concrete instance combining
  `AbstractHodgeSource_E7ShimuraToy` with
  `CycleClassMapReplacementData_E7ShimuraToy`.
* `AbstractHCDataPackage_E7ShimuraToy_HC_codim1` — HC at codim 1 for
  the E_7-Shimura toy through the unified package.
* `L4_G_AbstractHCDataPackage_*` marker family.

## What R258 (this file) does NOT do

* Does NOT implement a real Chow group.
* Does NOT implement rational equivalence.
* Does NOT implement a real cycle class map.
* Does NOT replace `canonicalE7ShimuraTor.algClassesOfUnderlying`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R258 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.CycleClassMapReplacement
import HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement
import HodgeReduction.HCGapL4.AbstractHodgeSource

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.CycleClassMapReplacement
open HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement

/-! ## Section 1: unified HC data package structure -/

/-- **R258 unified HC data package**. Bundles:
* an `AbstractHodgeSource` (cohomology + VCD + realization marker);
* a `CycleClassMapReplacementData` on the VCD (per-codim ℚ-modules
  of cycles + linear cycle class maps + Hodge-half witnesses);
* an `AlgebraicClassesData` on the VCD;
* an equality field tying the ACD to the cycle-class-map construction.

By construction (via `ofCycleClassMap`), the ACD is exactly the
`LinearMap.range` of the cycle class maps, matching R248's interface. -/
structure AbstractHCDataPackage where
  /-- The unified Hodge source. -/
  hodgeSource : AbstractHodgeSource
  /-- The cycle-class-map replacement data on the source's VCD. -/
  cycleClassMapData : CycleClassMapReplacementData hodgeSource.vcd
  /-- The algebraic-classes data on the source's VCD. -/
  acd : AlgebraicClassesData hodgeSource.vcd
  /-- The ACD is the one derived from the cycle-class-map data. -/
  acd_eq_fromCycleClassMap :
    acd = AlgebraicClassesData.ofCycleClassMapReplacement cycleClassMapData

/-! ## Section 2: constructor from cycle-class-map data -/

namespace AbstractHCDataPackage

/-- **R258 constructor**: from an `AbstractHodgeSource` plus a
`CycleClassMapReplacementData` on its VCD, build the unified package
with ACD derived definitionally via R248's `ofCycleClassMapReplacement`. -/
noncomputable def ofCycleClassMap
    (S : AbstractHodgeSource)
    (D : CycleClassMapReplacementData S.vcd) :
    AbstractHCDataPackage where
  hodgeSource := S
  cycleClassMapData := D
  acd := AlgebraicClassesData.ofCycleClassMapReplacement D
  acd_eq_fromCycleClassMap := rfl

/-! ## Section 3: generic HC bridge through the cycle class range -/

/-- **R258 generic HC bridge**: if at codim `p` the Hodge-class
submodule is contained in the linear range of the cycle class map,
then `VarietyHCAt` holds for the package's ACD. Reduces to R248's
`VarietyHCAt_of_cycleClassMapReplacement_surjective_on_hodgeClasses`
via `acd_eq_fromCycleClassMap`. -/
theorem VarietyHCAt_of_hodgeClasses_le_cycleClassRange
    (P : AbstractHCDataPackage) {p : ℕ}
    (h_cover :
      letI _ := P.cycleClassMapData.instAddCommGroup p
      letI _ := P.cycleClassMapData.instModule p
      P.hodgeSource.vcd.hodgeClassesAtDegree p ≤
        LinearMap.range (P.cycleClassMapData.cycleClass p)) :
    VarietyHCAt P.hodgeSource.vcd P.acd p := by
  rw [P.acd_eq_fromCycleClassMap]
  exact VarietyHCAt_of_cycleClassMapReplacement_surjective_on_hodgeClasses
    P.cycleClassMapData h_cover

end AbstractHCDataPackage

/-! ## Section 4: concrete E_7 Shimura toy instance -/

/-- **R258 concrete instance**: the unified HC data package for the
E_7-Shimura toy, combining R257's `AbstractHodgeSource_E7ShimuraToy`
with R249's `CycleClassMapReplacementData_E7ShimuraToy`. -/
noncomputable def AbstractHCDataPackage_E7ShimuraToy : AbstractHCDataPackage :=
  AbstractHCDataPackage.ofCycleClassMap
    AbstractHodgeSource_E7ShimuraToy
    CycleClassMapReplacementData_E7ShimuraToy

/-! ## Section 5: HC at codim 1 via the unified package -/

/-- **R258 HC at codim 1**: HC for the E_7-Shimura toy at codim 1
through the unified package. Uses the generic R258 HC bridge with the
codim-1 cover witness from `piece_ℚ_Tate2_one`. -/
theorem AbstractHCDataPackage_E7ShimuraToy_HC_codim1 :
    VarietyHCAt
      AbstractHCDataPackage_E7ShimuraToy.hodgeSource.vcd
      AbstractHCDataPackage_E7ShimuraToy.acd
      1 := by
  apply AbstractHCDataPackage.VarietyHCAt_of_hodgeClasses_le_cycleClassRange
  -- Show: hodgeClassesAtDegree 1 ≤ LinearMap.range (cycleClass 1).
  -- cycleClass 1 is E7ShimuraToyCycleClass_codim1 = identity on ℚ;
  -- hodgeClassesAtDegree 1 = piece_ℚ_Tate2 ⟨1⟩ = ⊤; lift to identity preimage.
  intro x _
  exact ⟨x, rfl⟩

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_AbstractHCDataPackage_To_algClassesOfUnderlying**: the
bridge from R258's unified HC data package to a real replacement of
`canonicalE7ShimuraTor.algClassesOfUnderlying`. -/
def L4_G_AbstractHCDataPackage_To_algClassesOfUnderlying : Prop := True

/-- **L4-G_AbstractHCDataPackage_MissingRealChowGroup**: the package's
`cycleClassMapData.CycleGroup` is an arbitrary ℚ-module, NOT a real
Chow group `CH^p(X)_ℚ`. -/
def L4_G_AbstractHCDataPackage_MissingRealChowGroup : Prop := True

/-- **L4-G_AbstractHCDataPackage_MissingRealCycleClassMap**: the
package's `cycleClassMapData.cycleClass` is an arbitrary ℚ-linear map,
NOT the real cycle class map `cl : CH^p(X)_ℚ → H^{2p}(X, ℚ)`. -/
def L4_G_AbstractHCDataPackage_MissingRealCycleClassMap : Prop := True

/-- **L4-G_AbstractHCDataPackage_To_canonicalE7ShimuraTor**: the
bridge from R258's unified HC data package to a real replacement of
`canonicalE7ShimuraTor`. -/
def L4_G_AbstractHCDataPackage_To_canonicalE7ShimuraTor : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R258 non-closure (1/4)**: does NOT implement a real Chow group. -/
theorem R258_does_not_implement_real_chow_group : True := trivial

/-- **R258 non-closure (2/4)**: does NOT implement a real cycle class
map. -/
theorem R258_does_not_implement_real_cycle_class_map : True := trivial

/-- **R258 non-closure (3/4)**: does NOT replace
`canonicalE7ShimuraTor.algClassesOfUnderlying`. -/
theorem R258_does_not_replace_algClassesOfUnderlying : True := trivial

/-- **R258 non-closure (4/4)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R258_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
