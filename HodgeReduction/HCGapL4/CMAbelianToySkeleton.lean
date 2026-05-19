/-
# HC Gap L4 — CM-abelian-shaped TOY source for the R235 package (R236).

R235 built `E7ShimuraToyMTCorrespondencePackageSkeleton` specialised
to the **point** source. The real headline gap involves a **CM
abelian variety** source whose HC is known (Deligne 1982). R236
introduces a **CM-abelian-shaped TOY source skeleton** and a parallel
package skeleton with this CM-abelian-shaped source, in addition to
(NOT replacing) R235's point-source package.

The CM toy is instantiated using the existing kernel-pure elliptic-curve
internal model (R203) — the elliptic curve here serves as a structural
stand-in for a CM abelian variety, with the kernel-pure HC route as
the stand-in for Deligne's theorem. No actual CM endomorphisms, no
real abelian variety theory.

For the correspondence shape, we use `codim 1 → 1` (preserving the
codim-1 algebraic class), built via R221's `InternalCycleActionData_SHSM`
factory (without product-cycle provenance — that requires an
`E × E7ShimuraToy` product carrier, which we mark as deferred).

## What R236 (this file) provides (all kernel-pure)

* `CMAbelianVarietyToySkeleton` — toy structure bundling a VCD/ACD
  pair with a `hasCMToy : Prop` field and a `varietyHCToy : VarietyHC`
  witness.
* `CMAbelianVarietyToySkeleton_ellipticCurveLike` — instance using
  the R203 elliptic-curve internal model + `VarietyHC_ellipticCurve`.
* `cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy` — toy action
  `H²(EC) →ₗ[ℚ] H²(E7ShimuraToy)` (identity ℚ → ℚ).
* `internalCycleActionData_SHSM_ellipticCurve_to_E7ShimuraToy` —
  R221 SHSM factory at codim `(1, 1)`.
* `SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1` — v2 SHSM2
  via `.to_SHSM2`.
* `E7ShimuraToyMTCorrespondencePackageFromCMAbelianToySkeleton` —
  new package shape with CM-abelian-toy source.
* `E7ShimuraToy_MTCorrespondencePackageFromCMAbelianToySkeleton` —
  concrete instance using the EC-based CM toy.
* `VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_MTCorrespondencePackageSkeleton` —
  HC at codim 1 for E7ShimuraToy via the CM-source route.

## What R236 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT replace the R235 point-source package skeleton.
* Does NOT implement a real CM abelian variety, real CM endomorphism
  algebra, real abelian variety theory, or polarisations.
* Does NOT prove Deligne 1982 (the real CM-abelian HC theorem).
* Does NOT implement real Mumford–Tate group, Shimura datum,
  Hermitian symmetric domain, reflex field, E_7, V_56, Freudenthal,
  or octonions.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT include product-cycle provenance (would require an
  `E × E7ShimuraToy` product carrier; deferred).

All R236 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
import HodgeReduction.HCGapL4.E7ShimuraToyMTCorrespondencePackage

namespace HodgeReduction
namespace HCGapL4
namespace CMAbelianToySkeleton

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.GenericCycleAction
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
open HodgeReduction.HCGapL4.E7ShimuraToyMTCorrespondencePackage

/-! ## Section 1: CM-abelian-shaped toy skeleton structure -/

/-- **R236 CM abelian variety toy skeleton**: bundles a VCD/ACD pair
with a Prop-level `hasCMToy` marker and a `varietyHCToy` witness
(full kernel-pure HC). The `hasCMToy` field is paper-trail only — no
actual CM endomorphism content. -/
structure CMAbelianVarietyToySkeleton where
  /-- The toy `VarietyCohomologyData`. -/
  VCD : VarietyCohomologyData
  /-- The toy algebraic-classes bundle. -/
  ACD : AlgebraicClassesData VCD
  /-- Paper-trail `hasCM` marker (Prop only; no actual CM content). -/
  hasCMToy : Prop
  /-- Kernel-pure full HC witness on this carrier. -/
  varietyHCToy : VarietyHC VCD ACD

/-! ## Section 2: elliptic-curve-based CM toy instance -/

/-- **R236 elliptic-curve-based CM toy instance**: uses R203's kernel-pure
elliptic curve internal model. Plays the structural role of a "CM
abelian variety with known HC", but is NOT a real CM elliptic curve. -/
noncomputable def CMAbelianVarietyToySkeleton_ellipticCurveLike :
    CMAbelianVarietyToySkeleton where
  VCD := EllipticCurve.VarietyCohomologyData_ellipticCurve
  ACD := EllipticCurve.AlgebraicClassesData_ellipticCurve
  hasCMToy := True
  varietyHCToy := EllipticCurve.VarietyHC_ellipticCurve

/-! ## Section 3: toy action `H²(EC) → H²(E7ShimuraToy)` -/

/-- **R236 toy action**: identity ℚ → ℚ at the carrier level for the
codim-1-preserving correspondence `EC → E7ShimuraToy`. -/
noncomputable def cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy :
    EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2 →ₗ[ℚ]
    VarietyCohomologyData_E7ShimuraToy.H 2 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

@[simp] theorem cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy_apply (x : ℚ) :
    cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy x = x := rfl

/-! ## Section 4: R221 SHSM factory at codim `(1, 1)` -/

/-- **R236 R221-style factory data** for `EC → E7ShimuraToy` codim
`1 → 1` (codim-preserving). `shift = 0`, `h_shift = rfl`. -/
noncomputable def internalCycleActionData_SHSM_ellipticCurve_to_E7ShimuraToy :
    InternalCycleActionData_SHSM
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy
      1 1 where
  action := cycleAction_H2_ellipticCurve_to_H2_E7ShimuraToy
  preservesAlgClasses := by
    intro x _
    -- algClasses_E7ShimuraToy 1 = ⊤
    exact Submodule.mem_top
  hodgeSurj := by
    intro x _
    -- Target hodgeClasses 1 = piece_ℚ_Tate2 ⟨1⟩ = ⊤
    -- Source hodgeClasses 1 = piece_ℚ_Tate2 ⟨1⟩ = ⊤
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
    · -- pi = ⟨0⟩ : both source and target piece = piece_ℚ_Tate2 ⟨0⟩ = ⊥
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 0, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨0, by omega⟩
      conv_rhs => rw [ProjectiveLine.piece_ℚ_Tate2_zero]
      conv_lhs => rw [show
          (PureHodgeStructure.piece (V := EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2)
            (⟨0, by omega⟩ : Fin (2 * 1 + 1))) = (⊥ : Submodule ℚ _) from
            ProjectiveLine.piece_ℚ_Tate2_zero]
      rw [Submodule.map_bot]
    · -- pi = ⟨1⟩ : both source and target piece = piece_ℚ_Tate2 ⟨1⟩ = ⊤
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1 + 0, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
      conv_rhs => rw [ProjectiveLine.piece_ℚ_Tate2_one]
      exact le_top
    · -- pi = ⟨2⟩ : both source and target piece = piece_ℚ_Tate2 ⟨2⟩ = ⊥
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨2 + 0, by omega⟩
      show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨2, by omega⟩
      conv_rhs => rw [ProjectiveLine.piece_ℚ_Tate2_two]
      conv_lhs => rw [show
          (PureHodgeStructure.piece (V := EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2)
            (⟨2, by omega⟩ : Fin (2 * 1 + 1))) = (⊥ : Submodule ℚ _) from
            ProjectiveLine.piece_ℚ_Tate2_two]
      rw [Submodule.map_bot]

/-- **R236 v2 SHSM2 package** for `EC → E7ShimuraToy` codim `1 → 1`
via R221 factory `.to_SHSM2`. -/
noncomputable def SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy
      1 1 :=
  internalCycleActionData_SHSM_ellipticCurve_to_E7ShimuraToy.to_SHSM2

/-! ## Section 5: CM-source MT correspondence package toy structure -/

/-- **R236 CM-source MT correspondence package toy skeleton**: shape
parallels R235's package but with a CM-abelian-shaped source and a
codim `1 → 1` correspondence. -/
structure E7ShimuraToyMTCorrespondencePackageFromCMAbelianToySkeleton where
  /-- The R234 assembled Shimura datum toy. -/
  datumToy : E7ShimuraDatumToySkeleton
  /-- The CM-abelian-shaped toy source. -/
  sourceCMToy : CMAbelianVarietyToySkeleton
  /-- The toy v2 SHSM2 correspondence from sourceCMToy to E_7 toy at
  codim `1 → 1`. -/
  correspondenceToy :
    ShiftedMTCorrespondencePackageAt_SHSM2
      sourceCMToy.VCD
      VarietyCohomologyData_E7ShimuraToy
      sourceCMToy.ACD
      AlgebraicClassesData_E7ShimuraToy
      1 1

/-! ## Section 6: concrete CM-source package instance -/

/-- **R236 concrete CM-source package instance**: uses R234 V_56
weight-3 datum, the EC-based CM toy, and R236's SHSM2 correspondence. -/
noncomputable def E7ShimuraToy_MTCorrespondencePackageFromCMAbelianToySkeleton :
    E7ShimuraToyMTCorrespondencePackageFromCMAbelianToySkeleton where
  datumToy := E7ShimuraDatumToySkeleton_V56Weight3
  sourceCMToy := CMAbelianVarietyToySkeleton_ellipticCurveLike
  correspondenceToy := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1

/-! ## Section 7: HC transfer through the CM-source package -/

/-- **R236 HC at codim 1 for E_7 toy via CM-source route**: uses
`sourceCMToy.varietyHCToy` at codim 1, then the package's
correspondence + `SHSM2_toRaw` + R212 shifted transfer. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_MTCorrespondencePackageSkeleton :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      E7ShimuraToy_MTCorrespondencePackageFromCMAbelianToySkeleton.correspondenceToy)
    (CMAbelianVarietyToySkeleton_ellipticCurveLike.varietyHCToy 1)

/-! ## Section 8: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_CMAbelianToySkeleton_To_RealCMAbelianVariety**: upgrading
the toy CM-abelian skeleton to a genuine CM abelian variety with
endomorphism ring `End(A) ⊗_ℤ ℚ ⊃ CM field`, polarisation, CM type,
and reflex CM type. -/
abbrev L4_G_CMAbelianToySkeleton_To_RealCMAbelianVariety : Prop := True

/-- **L4-G_CMAbelianToyHC_To_Deligne1982**: upgrading the toy
`varietyHCToy` field (kernel-pure HC for the EC internal model) to
Deligne's 1982 theorem (HC for absolute Hodge classes on CM abelian
varieties, the real input to the headline reduction). -/
abbrev L4_G_CMAbelianToyHC_To_Deligne1982 : Prop := True

/-- **L4-G_CMAbelianToyMTCorrespondence_To_canonicalE7ShimuraTor_mtCorrespondencePackage**:
the bridge from the CM-source toy MT correspondence package to the
genuine `canonicalE7ShimuraTor.mtCorrespondencePackage` field — the
active headline gap. -/
abbrev L4_G_CMAbelianToyMTCorrespondence_To_canonicalE7ShimuraTor_mtCorrespondencePackage :
    Prop := True

/-- **L4-G_CMAbelianToy_MissingActualCMEndomorphisms**: the toy
`hasCMToy := True` is paper-trail only. A real CM abelian variety
carries an action of a CM field via `End(A) ⊗_ℤ ℚ`. R236 has no
endomorphism algebra. -/
abbrev L4_G_CMAbelianToy_MissingActualCMEndomorphisms : Prop := True

/-- **L4-G_CMAbelianToy_MissingAbelianVarietyStructure**: the EC
internal model has no group law, no polarisation, no Tate module, no
isogeny class. R236 uses only its cohomology + HC witness. -/
abbrev L4_G_CMAbelianToy_MissingAbelianVarietyStructure : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R236 non-closure (1/7)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R236_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R236 non-closure (2/7)**: does NOT implement a real CM abelian
variety. -/
theorem R236_does_not_implement_real_cm_abelian_variety : True := trivial

/-- **R236 non-closure (3/7)**: does NOT prove Deligne's 1982 theorem
(HC for absolute Hodge classes on CM abelian varieties). -/
theorem R236_does_not_prove_deligne_1982 : True := trivial

/-- **R236 non-closure (4/7)**: does NOT implement actual CM
endomorphism algebra `End(A) ⊗_ℤ ℚ`. -/
theorem R236_does_not_implement_cm_endomorphisms : True := trivial

/-- **R236 non-closure (5/7)**: does NOT implement abelian variety
structure (group law, polarisation, Tate module, isogeny class). -/
theorem R236_does_not_implement_abelian_variety_structure : True := trivial

/-- **R236 non-closure (6/7)**: does NOT identify `E7ShimuraToy` with
the real canonical E_7 Shimura variety. -/
theorem R236_does_not_identify_toy_with_real_E7Shimura : True := trivial

/-- **R236 non-closure (7/7)**: does NOT replace the R235 point-source
package. Both R235 (point-source) and R236 (CM-source) coexist. -/
theorem R236_does_not_replace_R235_point_source_package : True := trivial

end CMAbelianToySkeleton
end HCGapL4
end HodgeReduction
