/-
# HC Gap L4 — product-cycle upgrade of the R236 CM-source route (R237).

R236 built a direct SHSM2 correspondence `EC → E7ShimuraToy` at
codim `1 → 1` (CM-source toy → E_7 toy) and explicitly DEFERRED
product-cycle provenance because `E × E7ShimuraToy` carrier was
missing. R237 supplies that carrier and lifts the R236 correspondence
through R225's product-cycle factory lifter, without altering or
replacing the R236 direct route.

## What R237 (this file) provides (all kernel-pure)

* `VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy` — minimal
  toy product VCD mirroring R224 / R227 / R228 shape (H^0 = ℚ,
  H^1 = PUnit, H^2 = ℚ, H^k = PUnit for k ≥ 3).
* `ellipticCurveTimesE7ShimuraToyCycleClassFamily` — cycle family
  with codim 0 (fundamental) and codim 1 (representative).
* `AlgebraicClassesData_ellipticCurveTimesE7ShimuraToy` — via
  `ofCycleClassFamily`.
* `internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy`
  — product-cycle factory at `(1, 1)` with `cycleCodim = 1`, reusing
  R236's action / preservation / hodgeSurj / pieceShift fields.
* `SHSM2_ellipticCurve_to_E7ShimuraToy_from_CMProductCycleFactory` —
  v2 SHSM2 via factory `.to_SHSM2`.
* `E7ShimuraToyMTCorrespondencePackageFromCMAbelianToyWithProductCycleSkeleton` —
  product-cycle CM-source package shape (specialised to the EC-based
  CM toy and the minimal product carrier).
* `E7ShimuraToy_MTCorrespondencePackageFromCMAbelianToyWithProductCycleSkeleton`
  — concrete instance.
* `VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_ProductCycle_MTCorrespondencePackageSkeleton`
  — HC at codim 1 via the product-cycle CM-source route.

## What R237 (this file) does NOT do

* Does NOT alter or replace R236's direct SHSM2 route.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT implement real `E × E7ShimuraToy` (truncates H^1, H^2,
  H^3, H^4 to single Tate-style generators).
* Does NOT implement true Chow correspondence or push-pull-cup.
* Does NOT prove the product cycle semantically induces the action.
* Does NOT prove Deligne 1982.
* Does NOT implement real CM abelian variety, CM endomorphism algebra,
  abelian variety structure, polarisation, or Tate module.
* Does NOT identify `E7ShimuraToy` with the real canonical E_7
  Shimura variety.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R237 declarations are kernel-pure: `{propext, Classical.choice,
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
import HodgeReduction.HCGapL4.CycleClassPresentation
import HodgeReduction.HCGapL4.GenericCycleAction
import HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
import HodgeReduction.HCGapL4.ProductCycleFactoryLifter
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import Mathlib.Algebra.PUnitInstances.Module

namespace HodgeReduction
namespace HCGapL4
namespace CMAbelianToyProductCycleToE7ShimuraToy

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.CycleClassPresentation
open HodgeReduction.HCGapL4.GenericCycleAction
open HodgeReduction.HCGapL4.InternalCycleActionWithProductCycle
open HodgeReduction.HCGapL4.ProductCycleFactoryLifter
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraDatumToySkeleton
open HodgeReduction.HCGapL4.CMAbelianToySkeleton

/-! ## Section 1: minimal toy product carrier `E × E7ShimuraToy`

Mirrors R224 / R227 / R228 minimal-product-carrier shape. NOT the
true cohomology of `E × E7ShimuraToy` (real H^1 has dimension 2
from E's H^1, real H^2 has dimension 2 from two divisor classes,
real H^3 has dimension 2, real H^4 has dimension 1). -/

def cohomologyType_ellipticCurveTimesE7ShimuraToy : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_ellipticCurveTimesE7ShimuraToy_zero :
    cohomologyType_ellipticCurveTimesE7ShimuraToy 0 = ℚ := rfl

@[simp] theorem cohomologyType_ellipticCurveTimesE7ShimuraToy_two :
    cohomologyType_ellipticCurveTimesE7ShimuraToy 2 = ℚ := rfl

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_ellipticCurveTimesE7ShimuraToy k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_ellipticCurveTimesE7ShimuraToy k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ
           (cohomologyType_ellipticCurveTimesE7ShimuraToy k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure
           (cohomologyType_ellipticCurveTimesE7ShimuraToy k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R237 toy product VCD** for `E × E7ShimuraToy`. -/
noncomputable def VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy :
    VarietyCohomologyData where
  H := cohomologyType_ellipticCurveTimesE7ShimuraToy
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

noncomputable instance acg_ellipticCurveTimesE7ShimuraToy_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.H k) :=
  VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.addCommGroup k

noncomputable instance mod_ellipticCurveTimesE7ShimuraToy_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.H k) :=
  VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.module k

/-! ## Section 2: cycle family for the toy product

Generators:
* codim 0: fundamental class `1 ∈ H^0 = ℚ`.
* codim 1: representative divisor class `1 ∈ H^2 = ℚ` (toy generator;
  used as the cycleClass for the R236 codim 1 → 1 correspondence).
* codim ≥ 2: PEmpty. -/

def ellipticCurveTimesE7ShimuraToyGenIndex : ℕ → Type
  | 0     => Unit
  | 1     => Unit
  | _ + 2 => PEmpty

noncomputable def ellipticCurveTimesE7ShimuraToyCycleClass :
    ∀ p, ellipticCurveTimesE7ShimuraToyGenIndex p →
      VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.H (2 * p)
  | 0     => fun _ => (1 : ℚ)
  | 1     => fun _ => (1 : ℚ)
  | _ + 2 => fun g => PEmpty.elim g

theorem ellipticCurveTimesE7ShimuraToyCycleClass_isHodge :
    ∀ p (g : ellipticCurveTimesE7ShimuraToyGenIndex p),
      ellipticCurveTimesE7ShimuraToyCycleClass p g ∈
        VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.hodgeClassesAtDegree p
  | 0     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.hodgeClassesAtDegree 0
    show (1 : ℚ) ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  | 1     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy.hodgeClassesAtDegree 1
    show (1 : ℚ) ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact Submodule.mem_top
  | _ + 2 => fun g => PEmpty.elim g

/-- **R237 product cycle family** for `E × E7ShimuraToy` (toy). -/
noncomputable def ellipticCurveTimesE7ShimuraToyCycleClassFamily :
    CycleClassFamily VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy where
  GenIndex := ellipticCurveTimesE7ShimuraToyGenIndex
  cycleClass := ellipticCurveTimesE7ShimuraToyCycleClass
  cycleClass_isHodge := ellipticCurveTimesE7ShimuraToyCycleClass_isHodge

/-- **R237 product ACD** via `ofCycleClassFamily`. -/
noncomputable def AlgebraicClassesData_ellipticCurveTimesE7ShimuraToy :
    AlgebraicClassesData VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy :=
  AlgebraicClassesData.ofCycleClassFamily
    ellipticCurveTimesE7ShimuraToyCycleClassFamily

/-! ## Section 3: product-cycle factory at codim `(1, 1)` with cycleCodim 1

Wraps R236's R221-style factory data (action + preservation +
hodgeSurj + shift + h_shift + pieceShift) with R223's product-cycle
provenance using the R237 toy product carrier. -/

/-- **R237 product-cycle factory data** `EC → E7ShimuraToy` codim
`(1, 1)` with cycleCodim 1. Reuses R236's R221 factory bits via
`toInternalCycleActionData_SHSM`. -/
noncomputable def internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy :
    InternalCycleActionData_SHSM_WithProductCycle
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy
      AlgebraicClassesData_ellipticCurveTimesE7ShimuraToy
      1 1 1 where
  toInternalCycleActionData_SHSM :=
    internalCycleActionData_SHSM_ellipticCurve_to_E7ShimuraToy
  cycleClass := ellipticCurveTimesE7ShimuraToyCycleClass 1 ()
  cycleClass_mem_algClasses := by
    show ellipticCurveTimesE7ShimuraToyCycleClass 1 () ∈
      AlgebraicClassesData_ellipticCurveTimesE7ShimuraToy.algClasses 1
    apply Submodule.subset_span
    exact Set.mem_range_self ()

/-! ## Section 4: SHSM2 lift -/

/-- **R237 v2 SHSM2 package** `EC → E7ShimuraToy` codim `(1, 1)`
via R225 `ProductCycleFactory_to_SHSM2`. -/
theorem SHSM2_ellipticCurve_to_E7ShimuraToy_from_CMProductCycleFactory :
    ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy
      1 1 :=
  ProductCycleFactory_to_SHSM2
    internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy

/-! ## Section 5: product-cycle CM-source package structure

Specialised to the EC-based CM toy + R237 product carrier. Does NOT
replace R236's direct package; the two structures coexist. -/

/-- **R237 product-cycle CM-source MT correspondence package toy
skeleton**: specialised to EC-based CM toy + R237 product carrier
+ codim `(1, 1)`. -/
structure E7ShimuraToyMTCorrespondencePackageFromCMAbelianToyWithProductCycleSkeleton where
  /-- The R234 assembled Shimura datum toy. -/
  datumToy : E7ShimuraDatumToySkeleton
  /-- The CM-abelian-shaped toy source (EC-based, R236). -/
  sourceCMToy : CMAbelianVarietyToySkeleton
  /-- The R223-style product-cycle factory data with R237 product carrier. -/
  productCycleFactoryToy :
    InternalCycleActionData_SHSM_WithProductCycle
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_E7ShimuraToy
      VarietyCohomologyData_ellipticCurveTimesE7ShimuraToy
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_E7ShimuraToy
      AlgebraicClassesData_ellipticCurveTimesE7ShimuraToy
      1 1 1

/-- **R237 concrete product-cycle CM-source package instance**. -/
noncomputable def E7ShimuraToy_MTCorrespondencePackageFromCMAbelianToyWithProductCycleSkeleton :
    E7ShimuraToyMTCorrespondencePackageFromCMAbelianToyWithProductCycleSkeleton where
  datumToy := E7ShimuraDatumToySkeleton_V56Weight3
  sourceCMToy := CMAbelianVarietyToySkeleton_ellipticCurveLike
  productCycleFactoryToy :=
    internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy

/-! ## Section 6: HC transfer through the product-cycle CM-source package -/

/-- **R237 HC at codim 1 for E_7 toy via product-cycle CM-source
route**: uses `sourceCMToy.varietyHCToy 1` + R225 generic
`VarietyHCAt_of_productCycleFactory`. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_CMAbelianToy_ProductCycle_MTCorrespondencePackageSkeleton :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_productCycleFactory
    internalCycleActionData_SHSM_WithProductCycle_ellipticCurve_to_E7ShimuraToy
    (CMAbelianVarietyToySkeleton_ellipticCurveLike.varietyHCToy 1)

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_CMAbelianToyProductCycle_To_RealChowCorrespondence**:
upgrading the toy product-cycle factory's action + cycleClass to a
genuine Chow-cycle correspondence on the real `E × E7Shimura`
product, with push-pull-cup semantics. -/
abbrev L4_G_CMAbelianToyProductCycle_To_RealChowCorrespondence :
    Prop := True

/-- **L4-G_EllipticCurveTimesE7ShimuraToy_To_TrueProduct**: upgrading
the minimal toy `E × E7ShimuraToy` carrier (which truncates H^1, H^2,
H^3, H^4) to the true cohomology of the real product. -/
abbrev L4_G_EllipticCurveTimesE7ShimuraToy_To_TrueProduct : Prop := True

/-- **L4-G_CMAbelianToyProductCycle_To_canonicalE7ShimuraTor_mtCorrespondencePackage**:
the bridge from the product-cycle CM-source toy package to the
genuine `canonicalE7ShimuraTor.mtCorrespondencePackage` field. -/
abbrev L4_G_CMAbelianToyProductCycle_To_canonicalE7ShimuraTor_mtCorrespondencePackage :
    Prop := True

/-- **L4-G_CMAbelianToyProductCycle_MissingActualCMEndomorphisms**:
the `sourceCMToy.hasCMToy := True` is paper-trail only (carried from
R236). A real CM abelian variety carries `End(A) ⊗_ℤ ℚ ⊃ CM field`. -/
abbrev L4_G_CMAbelianToyProductCycle_MissingActualCMEndomorphisms :
    Prop := True

/-- **L4-G_CMAbelianToyProductCycle_MissingDeligne1982**: the
`sourceCMToy.varietyHCToy` is the kernel-pure EC internal HC, not
Deligne's 1982 theorem on absolute Hodge classes for CM abelian
varieties. -/
abbrev L4_G_CMAbelianToyProductCycle_MissingDeligne1982 : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R237 non-closure (1/7)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R237_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R237 non-closure (2/7)**: does NOT implement a real CM abelian
variety. -/
theorem R237_does_not_implement_real_cm_abelian_variety : True := trivial

/-- **R237 non-closure (3/7)**: does NOT prove Deligne's 1982 theorem. -/
theorem R237_does_not_prove_deligne_1982 : True := trivial

/-- **R237 non-closure (4/7)**: does NOT implement true Chow
correspondence or push-pull-cup. -/
theorem R237_does_not_implement_true_chow_correspondence : True := trivial

/-- **R237 non-closure (5/7)**: does NOT prove the product cycle
semantically induces the action. -/
theorem R237_does_not_prove_cycle_induces_action : True := trivial

/-- **R237 non-closure (6/7)**: does NOT implement true `E × E7Shimura`
(toy carrier truncates cohomology). -/
theorem R237_does_not_implement_true_ellipticCurve_times_E7Shimura :
    True := trivial

/-- **R237 non-closure (7/7)**: does NOT identify `E7ShimuraToy` with
the real canonical E_7 Shimura variety. -/
theorem R237_does_not_identify_toy_with_real_E7Shimura : True := trivial

end CMAbelianToyProductCycleToE7ShimuraToy
end HCGapL4
end HodgeReduction
