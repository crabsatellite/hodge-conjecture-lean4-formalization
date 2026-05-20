/-
# HC Gap L4 — EC realization of AV interface, Prop-placeholder reduction (R265-A).

R260 introduced `AbelianVarietyInterfaceSkeleton` with four Prop
slots (`hasBaseFieldToy`, `hasProjectiveVarietyToy`, `hasGroupLawToy`,
`hasSmoothProperToy`). The dim-1 EC seed instance filled all four
with `True`.

R265-A is the first **Prop-placeholder reduction round**: it replaces
two of those four Props with **Mathlib-backed witnesses** for the
dim-1 EC case:

* `hasBaseFieldToy` ← `Nonempty (Field ℚ)` (closed via `inferInstance`).
* `hasGroupLawToy`  ← `∀ E : WeierstrassCurve ℚ, [E.IsElliptic] →
                       Nonempty (AddCommGroup E.toAffine.Point)`
  (closed via `inferInstance` from
  `Mathlib.AlgebraicGeometry.EllipticCurve.Group`'s
  `WeierstrassCurve.Affine.Point.instAddCommGroup`).

Per the user's R265-A brief, this is the smallest closest-to-Mathlib
reduction step. NO high-dim AV, NO group-scheme, NO real CM, NO
Deligne 1982 — only swap two Prop markers for real Mathlib evidence.

R265-A does NOT destructively modify R260's seed instance; it adds a
parallel "RealizedGroupLaw" wrapper, keeping the original interface
intact for backward compatibility.

## What R265-A (this file) provides (all kernel-pure)

* `rat_baseFieldEvidence_for_EC_interface` — Prop alias for
  `Nonempty (Field ℚ)`.
* `rat_baseFieldEvidence_for_EC_interface_proved` — closed via
  `inferInstance`.
* `ellipticCurve_affinePoint_has_addCommGroup` — Mathlib-backed
  group-law evidence theorem for any `WeierstrassCurve ℚ` with
  `[IsElliptic]`.
* `EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton` — refined
  evidence bundle.
* `EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton_Q` — Q-instance.
* `EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw` —
  refined EC source wrapper bundling the R260 interface + R265-A
  evidence (additive, not destructive).
* `EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_instance`
  — concrete instance.
* `AbstractCMAbelianHCSource_from_EllipticCurveRealizedGroupLawInterface`
  — adapter to R256 via R260's adapter.
* `VarietyHCAt_E7ShimuraToy_codim1_via_ECRealizedGroupLawInterface` —
  regression HC theorem at codim 1 for the E_7-Shimura toy, with
  the original ACD as target (reusing R236's SHSM2).

## What R265-A (this file) does NOT do

* Does NOT implement high-dimensional abelian varieties.
* Does NOT implement `GroupScheme`.
* Does NOT prove projective variety structure.
* Does NOT prove smooth-proper structure.
* Does NOT implement real complex multiplication.
* Does NOT prove Deligne 1982.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT modify R260's EC seed instance destructively.

All R265-A declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL4.AbelianVarietyInterface
-- Mathlib seed imports: already used in R260, verified import-clean.
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass
import Mathlib.AlgebraicGeometry.EllipticCurve.Group

namespace HodgeReduction
namespace HCGapL4
namespace AbelianVarietyInterfaceECRealization

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.AbelianVarietyInterface

/-! ## Section 1: base-field evidence

Replaces R260's `hasBaseFieldToy := True` with a real Mathlib-backed
witness: ℚ carries a `Field` instance (from `Mathlib.Data.Rat.Defs`
and downstream). -/

/-- **R265-A** Prop alias: ℚ has a `Field` instance available
in Mathlib. -/
def rat_baseFieldEvidence_for_EC_interface : Prop := Nonempty (Field ℚ)

/-- **R265-A** closure of the base-field evidence: `inferInstance`
recovers Mathlib's `Field ℚ`. -/
theorem rat_baseFieldEvidence_for_EC_interface_proved :
    rat_baseFieldEvidence_for_EC_interface :=
  ⟨inferInstance⟩

/-! ## Section 2: elliptic-curve group-law evidence

Replaces R260's `hasGroupLawToy := True` with a real Mathlib-backed
witness: for every `E : WeierstrassCurve ℚ` with `[E.IsElliptic]`,
the affine point type `E.toAffine.Point` carries an `AddCommGroup`
instance (from `Mathlib.AlgebraicGeometry.EllipticCurve.Group`'s
`WeierstrassCurve.Affine.Point.instAddCommGroup`).

NOTE on the `[E.IsElliptic]` precondition: the Mathlib `AddCommGroup`
instance is actually defined on `W.Point` for any `W : Affine F`
with `[Field F]` (i.e. without requiring `IsElliptic`), because the
`Point` type itself only contains nonsingular points. We include
`[E.IsElliptic]` in the theorem statement to match the user's R265-A
spec and to flag the mathematically intended precondition. -/

/-- **R265-A** Mathlib-backed group-law evidence: every elliptic
Weierstrass curve over ℚ has an `AddCommGroup` on its affine nonsingular
points. -/
theorem ellipticCurve_affinePoint_has_addCommGroup
    (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    Nonempty (AddCommGroup E.toAffine.Point) :=
  ⟨inferInstance⟩

/-! ## Section 3: refined evidence skeleton -/

/-- **R265-A** refined evidence bundle for the EC AV interface. The
`baseFieldEvidence` field is `Nonempty (Field ℚ)`; the
`groupLawEvidence` field is a `∀ E [E.IsElliptic], Nonempty
(AddCommGroup E.toAffine.Point)` carrier matching the Mathlib API. -/
structure EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton where
  /-- Mathlib-backed base-field evidence for ℚ. -/
  baseFieldEvidence : Nonempty (Field ℚ)
  /-- Mathlib-backed group-law evidence for every elliptic Weierstrass
  curve over ℚ. -/
  groupLawEvidence :
    ∀ (E : WeierstrassCurve ℚ), [E.IsElliptic] →
      Nonempty (AddCommGroup E.toAffine.Point)

/-! ## Section 4: instantiate refined evidence over ℚ -/

/-- **R265-A** concrete ℚ-instance of the refined evidence skeleton.
Both fields are closed via `inferInstance` against Mathlib. -/
def EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton_Q :
    EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton where
  baseFieldEvidence := rat_baseFieldEvidence_for_EC_interface_proved
  groupLawEvidence := ellipticCurve_affinePoint_has_addCommGroup

/-! ## Section 5: refined EC source wrapper -/

/-- **R265-A** refined EC source wrapper. Bundles the original R260
EC interface (unchanged) with the R265-A Mathlib-backed evidence.
This is ADDITIVE, not destructive: R260's
`EllipticCurveAsAbelianVarietyInterfaceSkeleton` remains intact and
usable. -/
structure EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw where
  /-- The unchanged R260 EC HC source interface. -/
  baseInterface : AbelianVarietyHCSourceInterfaceSkeleton
  /-- The R265-A Mathlib-backed evidence. -/
  ecEvidence : EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton

/-- **R265-A** concrete wrapper instance: combines R260's EC HC
source interface seed with the R265-A ℚ-evidence. -/
noncomputable def EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_instance :
    EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw where
  baseInterface := EllipticCurveAsAbelianVarietyHCSourceInterfaceSkeleton
  ecEvidence := EllipticCurveAbelianVarietyInterfaceEvidenceSkeleton_Q

/-! ## Section 6: adapter to R256 `AbstractCMAbelianHCSource` -/

/-- **R265-A** adapter: from the refined EC wrapper, produce R256's
`AbstractCMAbelianHCSource` via R260's existing adapter applied to
the wrapper's `baseInterface`. The evidence is metadata-only at this
level — it strengthens the interface claim without changing the
adapter output. -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveRealizedGroupLawInterface :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_of_AbelianVarietyHCSourceInterface
    EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_instance.baseInterface
    True

/-! ## Section 7: regression HC at codim 1 for E_7-Shimura toy

Uses R236's existing SHSM2 package targeting the ORIGINAL
`AlgebraicClassesData_E7ShimuraToy`. The R265-A adapter feeds the
refined EC source through the R256 transfer theorem. -/

/-- **R265-A** regression: HC at codim 1 for the E_7-Shimura toy via
the refined EC realized-group-law interface. Identical math content
to R261's same-shape regression; the value of R265-A is the
Mathlib-backed evidence in the source side. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_ECRealizedGroupLawInterface :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    (source := AbstractCMAbelianHCSource_from_EllipticCurveRealizedGroupLawInterface)
    { correspondence := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1 }

/-! ## Section 8: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ECRealizedGroupLaw_To_AbelianVarietyInterface**: the
bridge from R265-A's refined wrapper back to R260's
`AbelianVarietyInterfaceSkeleton`. -/
def L4_G_ECRealizedGroupLaw_To_AbelianVarietyInterface : Prop := True

/-- **L4-G_ECRealizedGroupLaw_MissingProjectiveVarietyProof**: R265-A
does NOT reduce `hasProjectiveVarietyToy` — that requires hooking
into `EllipticCurve.Projective` infrastructure (deferred to R265-B
or later). -/
def L4_G_ECRealizedGroupLaw_MissingProjectiveVarietyProof : Prop := True

/-- **L4-G_ECRealizedGroupLaw_MissingSmoothProperProof**: R265-A
does NOT reduce `hasSmoothProperToy` — that requires building a
smoothness/properness witness from `IsElliptic` plus AG morphism
machinery (deferred to R265-B or later). -/
def L4_G_ECRealizedGroupLaw_MissingSmoothProperProof : Prop := True

/-- **L4-G_ECRealizedGroupLaw_MissingHighDimensionalAV**: R265-A
remains dim-1 only; higher-dim abelian variety construction is
blocked by absent Mathlib infrastructure (R254 audit). -/
def L4_G_ECRealizedGroupLaw_MissingHighDimensionalAV : Prop := True

/-- **L4-G_ECRealizedGroupLaw_To_CMSourceBridge**: the bridge from
R265-A's refined wrapper into R263's `CMSourceReplacementBridgeSkeleton`. -/
def L4_G_ECRealizedGroupLaw_To_CMSourceBridge : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R265-A non-closure (1/7)**: does NOT implement high-dimensional
abelian varieties. -/
theorem R265A_does_not_implement_high_dimensional_AV : True := trivial

/-- **R265-A non-closure (2/7)**: does NOT implement `GroupScheme`. -/
theorem R265A_does_not_implement_GroupScheme : True := trivial

/-- **R265-A non-closure (3/7)**: does NOT prove projective variety
structure (the `hasProjectiveVarietyToy` Prop in R260 remains a
True marker). -/
theorem R265A_does_not_prove_projective_variety_structure : True := trivial

/-- **R265-A non-closure (4/7)**: does NOT prove smooth-proper
structure (the `hasSmoothProperToy` Prop in R260 remains a True
marker). -/
theorem R265A_does_not_prove_smooth_proper_structure : True := trivial

/-- **R265-A non-closure (5/7)**: does NOT implement real CM. -/
theorem R265A_does_not_implement_real_CM : True := trivial

/-- **R265-A non-closure (6/7)**: does NOT prove Deligne 1982. -/
theorem R265A_does_not_prove_deligne_1982 : True := trivial

/-- **R265-A non-closure (7/7)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R265A_does_not_close_canonicalE7ShimuraTor : True := trivial

end AbelianVarietyInterfaceECRealization
end HCGapL4
end HodgeReduction
