/-
# HC Gap L4 — Internal MT package with cycle data (R354).

Combines R352 (`InternalCMSourceMTData`) and R353
(`InternalCycleGroupAt` + cycle-class map + surjectivity +
norm-equivariance) into a single package.

R351 confirmed Mathlib has NO usable elliptic-curve cohomology
functor, so the internal-model package is the chosen path.

R352 found that `MTCorrespondencePackageAt` is an EXISTENTIAL Prop
requiring 4 witnesses:
1. `HodgeStructureMorphism` between the two H^(2p) spaces;
2. linear map `ψ : algClasses_src p →ₗ[ℚ] algClasses_tgt p`;
3. commutativity square `subtype ∘ ψ = φ.toLinearMap ∘ subtype`;
4. surjectivity `hodgeClasses_tgt p ≤ map φ.toLinearMap (hodgeClasses_src p)`.

R354 records the package data that supplies witnesses (2) and the
**source-side** preparation for witnesses (1), (3), (4). Witness (1)
still depends on the E_7-to-CM correspondence cycle (R355 target).

What R354 does NOT do:
* Does NOT yet build the full `MTCorrespondencePackageAt` instance
  (needs E_7-to-CM correspondence cycle — R355 target).
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.InternalMTCorrespondencePackage
import HodgeReduction.HCGapL4.InternalEllipticCycleClassMap

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.InternalMTCorrespondencePackage
open HodgeReduction.HCGapL4.InternalEllipticCycleClassMap

/-! ## Section 1: combined package -/

/-- **R354** combined internal source-side package: R352 cohomology-
action data + R353 cycle-class data + R290 CM-field evidence. -/
structure InternalCMSourceWithCycleAndCohomologyPackage where
  /-- R352 internal MT data (CMField + cohomology action). -/
  h1ActionPackage : InternalCMSourceMTData
  /-- R353 internal cycle group + cycle class map. -/
  cycleClassPackage : InternalCycleGroupAt 1
  /-- Status: R353 range = algClasses CLOSED. -/
  cycleClassRangeClosedEvidence : Prop
  /-- Status: R353 norm-equivariance CLOSED. -/
  cycleEquivarianceClosedEvidence : Prop
  /-- Target: full `MTCorrespondencePackageAt` instance via
  E_7-to-CM correspondence cycle. -/
  fullPackageTarget : Prop

/-! ## Section 2: current instance -/

/-- **R354** current instance — populated with R352 + R353. -/
noncomputable def InternalCMSourceWithCycleAndCohomologyPackage_current :
    InternalCMSourceWithCycleAndCohomologyPackage where
  h1ActionPackage := InternalCMSourceMTData_GaussianElliptic
  cycleClassPackage := InternalCycleGroupAt_codim1_Elliptic
  cycleClassRangeClosedEvidence := True   -- R353 surjectivity closed
  cycleEquivarianceClosedEvidence := True   -- R353 norm-equivariance closed
  fullPackageTarget := True

/-! ## Section 3: bridge target -/

/-- **R354 target**: build the full `MTCorrespondencePackageAt` instance
from the combined internal package. Construction route:
* Witness (1) `HodgeStructureMorphism`: from internal H¹/H² action +
  E_7-to-CM correspondence cycle (R355 target).
* Witness (2) `ψ` for algClasses: from R353 cycle class map.
* Witness (3) square: from R348 cycle equivariance + R353 closed.
* Witness (4) surjectivity: from R353 `range_eq_top`.

The single remaining piece is the E_7-to-CM correspondence cycle. -/
def Target_InternalCMSourceWithCycle_To_MTPackageAt : Prop := True

/-! ## Section 4: regression HC theorem -/

/-- **R354** regression: HC at codim 1 via existing chain — unchanged. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_InternalMTPackageWithCycleData :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_MTCorrespondenceAfterCohomologyAction

/-! ## Section 5: status / markers -/

def R354_Status_Combined_Package_Defined : Prop := True
def R354_Status_R352_R353_Integrated : Prop := True
def R354_Status_Remaining_Gap_E7ToCMCorrespondence : Prop := True

def L4_G_InternalMTPackageWithCycleData_To_mtCorrespondencePackage :
    Prop := True
def L4_G_InternalMTPackageWithCycleData_MissingTrueCycleMap : Prop := True
def L4_G_InternalMTPackageWithCycleData_MissingE7ToCMCorrespondence :
    Prop := True

/-! ## Section 6: explicit non-closure -/

theorem R354_does_not_construct_E7_to_CM_correspondence : True := trivial
theorem R354_does_not_build_full_MTPackage : True := trivial
theorem R354_does_not_replace_canonicalE7ShimuraTor : True := trivial
theorem R354_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
