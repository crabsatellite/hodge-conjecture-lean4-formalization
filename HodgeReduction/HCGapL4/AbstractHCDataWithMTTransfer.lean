/-
# HC Gap L4 — top-level unified package with MT-correspondence transfer (R259).

R257 unified the cohomology source side (`AbstractHodgeSource`).
R258 unified the algebraic-classes side with the linear cycle-class-map
interface (`AbstractHCDataPackage`).

R259 is the top-level consolidation: an `AbstractHCDataWithMTTransfer`
bundles
* the target HC data package (R258);
* a source CM-shaped HC source (R256);
* the source/target codimensions `(p_src, p_tgt)`;
* an MT-correspondence adapter (R256) at those codimensions.

The generic transfer theorem reads `VarietyHCAt` on the target VCD/ACD
off the source's HC witness plus the correspondence, via R256's
`VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence`.

Per the user's R259 brief, this is interface consolidation only — no
new mathematical content, no real abelian variety, no real Chow
correspondence, no Deligne 1982.

## ACD-mismatch handling for the E_7 Shimura toy regression

R256's existing SHSM2 package
`SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1` targets the
ORIGINAL ACD `AlgebraicClassesData_E7ShimuraToy`. R258's package builds
the target ACD via R249's
`AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap`. The two ACDs
agree at codim 1 (R249 `E7ShimuraToy_algClasses_agree_fromCycleClassMap_codim1`),
but the underlying types `↥(A.algClasses 1)` differ definitionally.

To avoid forcing structure equality (the user's directive), R259
constructs a FRESH SHSM2 package directly targeting the
cycle-class-map-derived ACD via R221's
`InternalCycleActionData_SHSM.to_SHSM2` factory. The construction is
parallel to R236's; only `preservesAlgClasses` changes (uses
`LinearMap.range` membership for the new ACD).

## What R259 (this file) provides (all kernel-pure)

* `AbstractHCDataWithMTTransfer` — top-level structure bundling
  target HC data package + source CM HC + codims + correspondence.
* `AbstractHCDataWithMTTransfer.targetHCAt` — generic transfer
  theorem deriving target `VarietyHCAt` from the bundled data.
* `SHSM2_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap_codim1_to_codim1` —
  fresh SHSM2 package targeting the cycle-class-map-derived ACD.
* `AbstractHCDataWithMTTransfer_E7ShimuraToy` — concrete instance.
* `AbstractHCDataWithMTTransfer_E7ShimuraToy_HC_codim1` — HC at codim 1
  for the E_7-Shimura toy through the top-level unified package.
* `L4_G_AbstractHCDataWithMTTransfer_*` marker family.

## What R259 (this file) does NOT do

* Does NOT replace `canonicalE7ShimuraTor`.
* Does NOT implement real cohomology.
* Does NOT implement a real Chow group / cycle class map.
* Does NOT implement a real CM abelian variety.
* Does NOT prove Deligne 1982.
* Does NOT close `hodgeConjectureReal_canonical`.

All R259 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL4.AbstractHodgeSource
import HodgeReduction.HCGapL4.AbstractHCDataPackage

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.GenericCycleAction
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraToyCycleClassMapReplacement
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget

/-! ## Section 1: top-level structure -/

/-- **R259 top-level unified package**. Bundles an
`AbstractHCDataPackage` (target VCD + ACD + cycle class map), an
`AbstractCMAbelianHCSource` (source with VarietyHC witness), source
and target codimensions, and an `AbstractMTCorrespondenceToTarget`
adapter (R256) at those codimensions. -/
structure AbstractHCDataWithMTTransfer where
  /-- The target HC data package. -/
  targetPackage : AbstractHCDataPackage
  /-- The source CM-shaped HC source. -/
  sourceCM : AbstractCMAbelianHCSource
  /-- Source codimension. -/
  p_src : ℕ
  /-- Target codimension. -/
  p_tgt : ℕ
  /-- The MT-correspondence adapter from source to target. -/
  correspondence :
    AbstractMTCorrespondenceToTarget
      sourceCM
      targetPackage.hodgeSource.vcd
      targetPackage.acd
      p_src
      p_tgt

/-! ## Section 2: generic transfer theorem -/

namespace AbstractHCDataWithMTTransfer

/-- **R259 generic transfer theorem**: derive `VarietyHCAt` on the
target VCD/ACD at codim `p_tgt` from the bundled correspondence + the
source's full HC witness. Reduces to R256's
`VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence`. -/
theorem targetHCAt (P : AbstractHCDataWithMTTransfer) :
    VarietyHCAt P.targetPackage.hodgeSource.vcd P.targetPackage.acd P.p_tgt :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    P.correspondence

end AbstractHCDataWithMTTransfer

/-! ## Section 3: fresh SHSM2 targeting the cycle-class-map ACD

R236's existing SHSM2 targets the ORIGINAL `AlgebraicClassesData_E7ShimuraToy`.
We build a fresh SHSM2 targeting `AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap`
(R249), so that the R259 E_7-Shimura toy regression goes through the
cycle-class-map-derived ACD bundled in `AbstractHCDataPackage_E7ShimuraToy`. -/

/-- **R259 factory data**: `InternalCycleActionData_SHSM` for
EC → E_7-Shimura toy at codim `(1, 1)`, targeting the cycle-class-map
ACD. Construction mirrors R236; only `preservesAlgClasses` differs
(uses `LinearMap.range` membership via the identity cycle class map). -/
noncomputable def internalCycleActionData_SHSM_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap :
    InternalCycleActionData_SHSM
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap
      1 1 where
  action := cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy
  preservesAlgClasses := by
    intro x _
    -- Target ACD at codim 1 is LinearMap.range E7ShimuraToyCycleClass_codim1.
    -- action x = x (identity on ℚ); E7ShimuraToyCycleClass_codim1 x = x.
    -- Provide witness ⟨x, rfl⟩.
    show cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy x ∈
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap.algClasses 1
    -- Unfold the ofCycleClassMap algClasses to LinearMap.range.
    show cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy x ∈
      LinearMap.range E7ShimuraToyCycleClass_codim1
    exact ⟨x, rfl⟩
  hodgeSurj := by
    intro x _
    refine ⟨x, ?_, ?_⟩
    · show x ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
      rw [ProjectiveLine.piece_ℚ_Tate2_one]
      exact Submodule.mem_top
    · rfl
  shift := 0
  h_shift := rfl
  pieceShift := by
    intro pi
    fin_cases pi
    · show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 0, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨0, by omega⟩
      conv_rhs => rw [ProjectiveLine.piece_ℚ_Tate2_zero]
      conv_lhs => rw [show
          (PureHodgeStructure.piece (V := EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2)
            (⟨0, by omega⟩ : Fin (2 * 1 + 1))) = (⊥ : Submodule ℚ _) from
            ProjectiveLine.piece_ℚ_Tate2_zero]
      rw [Submodule.map_bot]
    · show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1 + 0, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
      conv_rhs => rw [ProjectiveLine.piece_ℚ_Tate2_one]
      exact le_top
    · show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨2 + 0, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨2, by omega⟩
      conv_rhs => rw [ProjectiveLine.piece_ℚ_Tate2_two]
      conv_lhs => rw [show
          (PureHodgeStructure.piece (V := EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2)
            (⟨2, by omega⟩ : Fin (2 * 1 + 1))) = (⊥ : Submodule ℚ _) from
            ProjectiveLine.piece_ℚ_Tate2_two]
      rw [Submodule.map_bot]

/-- **R259 fresh SHSM2 package** for EC → E_7-Shimura toy at codim
`(1, 1)`, targeting the cycle-class-map ACD. -/
noncomputable def SHSM2_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap_codim1_to_codim1 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy_fromCycleClassMap
      1 1 :=
  internalCycleActionData_SHSM_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap.to_SHSM2

/-! ## Section 4: concrete E_7 Shimura toy instance -/

/-- **R259 concrete instance**: the unified top-level package for the
E_7-Shimura toy. Target = `AbstractHCDataPackage_E7ShimuraToy` (R258);
source CM = R256's EC-based CM source; correspondence =
the fresh SHSM2 from this file, wrapped via the R256 adapter. -/
noncomputable def AbstractHCDataWithMTTransfer_E7ShimuraToy :
    AbstractHCDataWithMTTransfer where
  targetPackage := AbstractHCDataPackage_E7ShimuraToy
  sourceCM := AbstractCMAbelianHCSource_fromR236_ECbased
  p_src := 1
  p_tgt := 1
  correspondence :=
    { correspondence :=
        SHSM2_ellipticCurve_to_E7ShimuraToy_fromCycleClassMap_codim1_to_codim1 }

/-! ## Section 5: HC at codim 1 through the top-level unified package -/

/-- **R259 HC at codim 1**: HC for the E_7-Shimura toy at codim 1
through the top-level unified package. Direct application of the
generic transfer theorem. -/
theorem AbstractHCDataWithMTTransfer_E7ShimuraToy_HC_codim1 :
    VarietyHCAt
      AbstractHCDataWithMTTransfer_E7ShimuraToy.targetPackage.hodgeSource.vcd
      AbstractHCDataWithMTTransfer_E7ShimuraToy.targetPackage.acd
      1 :=
  AbstractHCDataWithMTTransfer_E7ShimuraToy.targetHCAt

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_AbstractHCDataWithMTTransfer_To_cohomologyOfUnderlying**:
bridge from R259's top-level unified package to a real replacement of
`canonicalE7ShimuraTor.cohomologyOfUnderlying` via the R257
`AbstractHodgeSource` slot. -/
def L4_G_AbstractHCDataWithMTTransfer_To_cohomologyOfUnderlying :
    Prop := True

/-- **L4-G_AbstractHCDataWithMTTransfer_To_algClassesOfUnderlying**:
bridge from R259's top-level unified package to a real replacement of
`canonicalE7ShimuraTor.algClassesOfUnderlying` via the R258
`CycleClassMapReplacementData` slot. -/
def L4_G_AbstractHCDataWithMTTransfer_To_algClassesOfUnderlying :
    Prop := True

/-- **L4-G_AbstractHCDataWithMTTransfer_To_mtCorrespondencePackage**:
bridge from R259's top-level unified package to a real replacement of
`canonicalE7ShimuraTor.mtCorrespondencePackage` via the R256
`AbstractMTCorrespondenceToTarget` slot. -/
def L4_G_AbstractHCDataWithMTTransfer_To_mtCorrespondencePackage :
    Prop := True

/-- **L4-G_AbstractHCDataWithMTTransfer_To_canonicalE7ShimuraTor**:
bridge from R259's top-level unified package to a full replacement of
`canonicalE7ShimuraTor`. -/
def L4_G_AbstractHCDataWithMTTransfer_To_canonicalE7ShimuraTor :
    Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R259 non-closure (1/6)**: does NOT replace `canonicalE7ShimuraTor`. -/
theorem R259_does_not_replace_canonicalE7ShimuraTor : True := trivial

/-- **R259 non-closure (2/6)**: does NOT implement real cohomology. -/
theorem R259_does_not_implement_real_cohomology : True := trivial

/-- **R259 non-closure (3/6)**: does NOT implement a real Chow group
or real cycle class map. -/
theorem R259_does_not_implement_real_chow_or_cycle_class_map :
    True := trivial

/-- **R259 non-closure (4/6)**: does NOT implement a real CM abelian
variety. -/
theorem R259_does_not_implement_real_CM_abelian_variety : True := trivial

/-- **R259 non-closure (5/6)**: does NOT prove Deligne 1982 (HC for
absolute Hodge classes on CM abelian varieties). -/
theorem R259_does_not_prove_deligne_1982 : True := trivial

/-- **R259 non-closure (6/6)**: does NOT close
`hodgeConjectureReal_canonical`. -/
theorem R259_does_not_close_hodgeConjectureReal_canonical : True := trivial

end HCGapL4
end HodgeReduction
