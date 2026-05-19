/-
# HC Gap L4 — v1 → v2 SHSM bridge (R219).

R213-R217 defined `ShiftedMTCorrespondencePackageAt_SHSM` (v1)
parameterised by `(p_src, q)` with target codim `p_src + q`. R218
introduced `ShiftedMTCorrespondencePackageAt_SHSM2` (v2) parameterised
by `(p_src, p_tgt)` with internal `shift`/`h_shift`.

R219 closes the **forward** bridge `v1 → v2`: every v1 SHSM package at
`(p_src, q)` yields a v2 SHSM2 package at `(p_src, p_src + q)` with
`shift := q` and `h_shift := rfl`.

This is essentially trivial: the bodies of v1's existential and v2's
existential (at `p_tgt := p_src + q`, `shift := q`) coincide
definitionally. The bridge is unpack-and-repack with `q` and `rfl`
inserted as the new internal witnesses.

The **backward** direction `v2 → v1` is NOT proved (and deliberately
deferred): reconstructing v1's `(p_src + q)`-shaped piece-shift from
v2's `p_tgt`-shaped piece-shift requires the same cast-coherence
that v2 was designed to avoid.

## What R219 provides (all kernel-pure)

* `ShiftedMTCorrespondencePackageAt_SHSM_to_SHSM2` — forward bridge.
* `bridged_SHSM2_point_to_ellipticCurve_codim0_to_codim1` — apply
  the bridge to R213's v1 pt→E instance, recover a v2 instance at
  `(0, 1)`.
* `bridged_SHSM2_point_to_E_via_composition_v2` — sanity composition
  using the bridged v2 instance (via R218's v2 compose).
* `VarietyHCAt_ellipticCurve_codim1_via_bridged_SHSM2_route` — 11th
  kernel-pure HC route, this time going v1 → bridge → v2 → compose.

## What R219 does NOT do

* Does NOT prove the backward `v2 → v1` bridge.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT make v1 obsolete — both packages remain available; the
  bridge just lets v1 results feed into v2 machinery.

All R219 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

namespace HodgeReduction
namespace HCGapL4
namespace ShiftedCorrespondenceSHSM2Bridge

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

/-! ## Section 1: Priority A — forward bridge `v1 → v2`

v1 SHSM at `(p, q)` has target codim `p + q`. v2 SHSM2 at
`(p, p + q)` with `shift := q` and `h_shift := rfl` has the same body
definitionally. Unpack v1, repack as v2 with the new witnesses
inserted. -/

/-- **R219 forward bridge**: v1 SHSM at `(p, q)` yields v2 SHSM2 at
`(p, p + q)` with `shift := q`. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_to_SHSM2
    {X Y : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {p q : ℕ}
    (P : ShiftedMTCorrespondencePackageAt_SHSM X Y AX AY p q) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X Y AX AY p (p + q) := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  letI _ := Y.addCommGroup (2 * (p + q))
  letI _ := Y.module (2 * (p + q))
  letI _ := Y.hodgeStructure (2 * (p + q))
  unfold ShiftedMTCorrespondencePackageAt_SHSM at P
  obtain ⟨action, ψ, h_piece, h_sq, h_surj⟩ := P
  refine ⟨q, rfl, action, ψ, h_piece, h_sq, h_surj⟩

/-! ## Section 2: sanity — bridge R213's pt → E v1 instance to v2 -/

/-- **R219 sanity 1**: apply the bridge to R213's v1 pt → E SHSM
package at `(0, 1)`, recovering a v2 SHSM2 instance at `(0, 0 + 1)`. -/
theorem bridged_SHSM2_point_to_ellipticCurve_codim0_to_codim1 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 (0 + 1) :=
  ShiftedMTCorrespondencePackageAt_SHSM_to_SHSM2
    ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1

/-! ## Section 3: sanity — HC route via bridged v1 + v2 composition -/

/-- **R219 sanity 2**: compose R218's v2 identity@pt with the bridged
v2 pt → E instance, using R218's v2 GENERAL `SHSM2_compose`. -/
theorem bridged_SHSM2_point_to_E_via_composition_v2 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 (0 + 1) :=
  ShiftedMTCorrespondencePackageAt_SHSM2_compose
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    bridged_SHSM2_point_to_ellipticCurve_codim0_to_codim1

/-- **R219 11th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via v1 → bridge → v2 → compose → toRaw → VarietyHCAt_of_shifted.
Distinct from R218's 10th route (which used R218's native v2 pt → E
instance) — this route exercises the v1 → v2 bridge. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_bridged_SHSM2_route :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      bridged_SHSM2_point_to_E_via_composition_v2)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_SHSM_v2_to_v1_BackwardBridge**: the backward direction
`v2 → v1`. Requires reconstructing v1's `(p_src + q)`-shaped
piece-shift from v2's `p_tgt`-shaped piece-shift, which triggers the
same dependent-type cast-coherence that v2 was designed to avoid.
Deferred. -/
abbrev L4_G_SHSM_v2_to_v1_BackwardBridge : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R219 non-closure (1/3)**: does NOT prove the backward `v2 → v1`
bridge. -/
theorem R219_does_not_prove_backward_bridge : True := trivial

/-- **R219 non-closure (2/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R219_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R219 non-closure (3/3)**: does NOT make v1 obsolete. Both
v1 and v2 packages remain available; R219 only adds the v1 → v2
adapter. -/
theorem R219_does_not_make_v1_obsolete : True := trivial

end ShiftedCorrespondenceSHSM2Bridge
end HCGapL4
end HodgeReduction
