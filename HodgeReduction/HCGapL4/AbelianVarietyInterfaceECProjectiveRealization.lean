/-
# HC Gap L4 — EC projective realization of AV interface (R265-B).

R265-A reduced two R260 Prop placeholders (`hasBaseFieldToy` and
`hasGroupLawToy`) using Mathlib-backed evidence for `Field ℚ` and
`WeierstrassCurve.Affine.Point.instAddCommGroup`.

R265-B continues the same additive-wrapper pattern and targets
`hasProjectiveVarietyToy`, using
`Mathlib.AlgebraicGeometry.EllipticCurve.Projective` + the projective
`AddCommGroup` instance from
`Mathlib.AlgebraicGeometry.EllipticCurve.Group` line 579
(`WeierstrassCurve.Projective.Point.instAddCommGroup`) +
`WeierstrassCurve.Projective.Point.toAffineAddEquiv`.

Per the user's R265-B brief, this round attaches projective evidence
WITHOUT claiming the projective Weierstrass model is a real
`ProjectiveScheme` (Mathlib has `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.*`
for `Proj` of a graded ring, but no direct theorem expressing the
projective Weierstrass curve as such a scheme). Where Mathlib does
not supply a stronger projectivity theorem, we record an
`AuditMissing_*` marker rather than faking the evidence.

R265-B does NOT destructively modify R260's seed instance or R265-A's
wrapper; it adds a second additive wrapper on top of R265-A.

## What R265-B (this file) provides (all kernel-pure)

* `ellipticCurve_projectivePoint_type_available` — projective point
  type exists (witnessed by `E.toProjective.Point`).
* `ellipticCurve_projectivePoint_has_addCommGroup` — Mathlib-backed
  projective-point group-law evidence via
  `WeierstrassCurve.Projective.Point.instAddCommGroup`.
* `ellipticCurve_projective_affine_addEquiv` — Mathlib-backed
  affine/projective `AddEquiv` evidence via
  `WeierstrassCurve.Projective.Point.toAffineAddEquiv`.
* `EllipticCurveProjectiveModelEvidenceSkeleton` — refined evidence
  bundle.
* `EllipticCurveProjectiveModelEvidenceSkeleton_Q` — ℚ-instance.
* `AuditMissing_EllipticCurve_ProjectiveModelAsProjectiveScheme` —
  honest record of what Mathlib does NOT supply: a direct theorem
  expressing the projective Weierstrass model as a
  `ProjectiveScheme` / closed immersion into ℙ².
* `EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_Projective` —
  additive wrapper bundling R265-A wrapper + R265-B projective
  evidence.
* `EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_Projective_instance`
  — concrete instance.
* `AbstractCMAbelianHCSource_from_EllipticCurveRealizedGroupLawProjectiveInterface`
  — adapter to R256.
* `VarietyHCAt_E7ShimuraToy_codim1_via_ECRealizedGroupLawProjectiveInterface`
  — regression HC theorem.

## What R265-B (this file) does NOT do

* Does NOT implement high-dimensional abelian varieties.
* Does NOT implement `GroupScheme`.
* Does NOT prove the projective Weierstrass model is a real
  `ProjectiveScheme` (Mathlib gap recorded).
* Does NOT prove a closed embedding into ℙ² as schemes.
* Does NOT prove smooth-proper structure.
* Does NOT implement real complex multiplication.
* Does NOT prove Deligne 1982.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT modify R260 / R265-A destructively.

All R265-B declarations are kernel-pure: `{propext, Classical.choice,
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
import HodgeReduction.HCGapL4.AbelianVarietyInterfaceECRealization
-- Mathlib seed imports: build-clean per R254 audit.
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass
import Mathlib.AlgebraicGeometry.EllipticCurve.Projective
import Mathlib.AlgebraicGeometry.EllipticCurve.Group

namespace HodgeReduction
namespace HCGapL4
namespace AbelianVarietyInterfaceECProjectiveRealization

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.AbelianVarietyInterface
open HodgeReduction.HCGapL4.AbelianVarietyInterfaceECRealization

/-! ## Section 1: projective-point type availability evidence

Witnesses that the projective point type is defined in Mathlib for
any Weierstrass curve over ℚ. Weak baseline evidence; the stronger
group-law and equivalence theorems below supersede it. -/

/-- **R265-B** projective-point type evidence: `E.toProjective.Point`
exists as a Mathlib type for every Weierstrass curve over ℚ. The
witness is the type itself. -/
theorem ellipticCurve_projectivePoint_type_available
    (E : WeierstrassCurve ℚ) :
    Nonempty Type := by
  exact ⟨E.toProjective.Point⟩

/-! ## Section 2: projective-point group-law evidence

Mathlib's `WeierstrassCurve.Projective.Point.instAddCommGroup`
(`Group.lean:579`) supplies the AddCommGroup on `E.toProjective.Point`
for any `E : WeierstrassCurve F` over a field `F`. The instance does
not require `[E.IsElliptic]`, but we include it to match the user's
spec and the mathematically intended precondition. -/

/-- **R265-B** projective-point group-law evidence: every elliptic
Weierstrass curve over ℚ has an `AddCommGroup` on its projective
nonsingular points, via Mathlib's
`WeierstrassCurve.Projective.Point.instAddCommGroup`. -/
theorem ellipticCurve_projectivePoint_has_addCommGroup
    (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    Nonempty (AddCommGroup E.toProjective.Point) :=
  ⟨inferInstance⟩

/-! ## Section 3: affine/projective `AddEquiv` evidence

Mathlib's `WeierstrassCurve.Projective.Point.toAffineAddEquiv`
(`Projective.lean:1677`) supplies an `AddEquiv` between the
projective and affine point groups, so the two group-law witnesses
(R265-A affine + R265-B projective) describe ISOMORPHIC groups, not
two separate group structures. -/

/-- **R265-B** affine/projective equivalence evidence: the
projective-point group is isomorphic (as an additive group) to the
affine-point group, via Mathlib's
`WeierstrassCurve.Projective.Point.toAffineAddEquiv`. -/
theorem ellipticCurve_projective_affine_addEquiv
    (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    Nonempty (E.toProjective.Point ≃+ E.toAffine.Point) :=
  ⟨WeierstrassCurve.Projective.Point.toAffineAddEquiv E.toProjective⟩

/-! ## Section 4: projective-model evidence skeleton -/

/-- **R265-B** refined projective-model evidence bundle. Bundles
three witnesses:
* projective point type availability;
* projective-point group law;
* affine/projective `AddEquiv`. -/
structure EllipticCurveProjectiveModelEvidenceSkeleton where
  /-- Mathlib-backed projective point type availability. -/
  projectivePointTypeEvidence :
    ∀ (_E : WeierstrassCurve ℚ), Nonempty Type
  /-- Mathlib-backed projective point group law. -/
  projectiveGroupLawEvidence :
    ∀ (E : WeierstrassCurve ℚ), [E.IsElliptic] →
      Nonempty (AddCommGroup E.toProjective.Point)
  /-- Mathlib-backed affine/projective equivalence. -/
  projectiveAffineAddEquivEvidence :
    ∀ (E : WeierstrassCurve ℚ), [E.IsElliptic] →
      Nonempty (E.toProjective.Point ≃+ E.toAffine.Point)

/-! ## Section 5: instantiate projective evidence over ℚ -/

/-- **R265-B** concrete ℚ-instance of the projective-model evidence
skeleton. All three fields are closed via the three theorems above. -/
def EllipticCurveProjectiveModelEvidenceSkeleton_Q :
    EllipticCurveProjectiveModelEvidenceSkeleton where
  projectivePointTypeEvidence := ellipticCurve_projectivePoint_type_available
  projectiveGroupLawEvidence := ellipticCurve_projectivePoint_has_addCommGroup
  projectiveAffineAddEquivEvidence := ellipticCurve_projective_affine_addEquiv

/-! ## Section 6: audit missing — projective-scheme proof

Mathlib does NOT supply a direct theorem expressing the projective
Weierstrass curve as a `ProjectiveScheme` (closed subscheme of ℙ²
via the homogeneous Weierstrass polynomial). The
`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.*` modules exist (R254
audit) for `Proj` of a graded ring, but no theorem connects
`E.toProjective` to such a `Proj`. R265-B records this gap honestly. -/

/-- **R265-B audit-missing marker**: no direct Mathlib theorem
expresses the projective Weierstrass model as a real `ProjectiveScheme`
(closed subscheme of ℙ² via the homogeneous Weierstrass polynomial). -/
def AuditMissing_EllipticCurve_ProjectiveModelAsProjectiveScheme :
    Prop := True

/-! ## Section 7: additive wrapper on top of R265-A -/

/-- **R265-B** additive wrapper bundling R265-A's RealizedGroupLaw
wrapper with R265-B's projective evidence. NOT destructive on R260 or
R265-A. -/
structure EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_Projective where
  /-- The R265-A wrapper (which itself wraps R260). -/
  groupLawWrapper : EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw
  /-- The R265-B projective evidence. -/
  projectiveEvidence : EllipticCurveProjectiveModelEvidenceSkeleton

/-- **R265-B** concrete wrapper instance: combines R265-A's
RealizedGroupLaw instance with R265-B's ℚ projective evidence. -/
noncomputable def EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_Projective_instance :
    EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_Projective where
  groupLawWrapper := EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_instance
  projectiveEvidence := EllipticCurveProjectiveModelEvidenceSkeleton_Q

/-! ## Section 8: adapter to R256 `AbstractCMAbelianHCSource` -/

/-- **R265-B** adapter: from the R265-B wrapper, produce R256's
`AbstractCMAbelianHCSource` via R260's adapter applied to the
wrapper's base interface (extracted through the R265-A layer). -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveRealizedGroupLawProjectiveInterface :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_of_AbelianVarietyHCSourceInterface
    EllipticCurveAsAbelianVarietyInterfaceSkeleton_RealizedGroupLaw_Projective_instance.groupLawWrapper.baseInterface
    True

/-! ## Section 9: regression HC at codim 1 for E_7-Shimura toy -/

/-- **R265-B** regression: HC at codim 1 for the E_7-Shimura toy
via the R265-B projective interface. Uses R236's SHSM2 against the
original ACD (no mismatch), same route as R265-A. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_ECRealizedGroupLawProjectiveInterface :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    (source :=
      AbstractCMAbelianHCSource_from_EllipticCurveRealizedGroupLawProjectiveInterface)
    { correspondence := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1 }

/-! ## Section 10: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ECProjectiveEvidence_To_AbelianVarietyInterface**: the
bridge from R265-B's wrapper back to R260's
`AbelianVarietyInterfaceSkeleton`. -/
def L4_G_ECProjectiveEvidence_To_AbelianVarietyInterface : Prop := True

/-- **L4-G_ECProjectiveEvidence_MissingProjectiveSchemeProof**: R265-B
provides Mathlib-backed projective point + group-law evidence, but
DOES NOT prove the projective Weierstrass model is a real
`ProjectiveScheme`. -/
def L4_G_ECProjectiveEvidence_MissingProjectiveSchemeProof : Prop := True

/-- **L4-G_ECProjectiveEvidence_MissingClosedEmbeddingIntoProjectivePlane**:
R265-B does NOT provide a closed embedding of the Weierstrass curve
into ℙ² as schemes. -/
def L4_G_ECProjectiveEvidence_MissingClosedEmbeddingIntoProjectivePlane :
    Prop := True

/-- **L4-G_ECProjectiveEvidence_MissingSmoothProperProof**: R265-B
does NOT reduce `hasSmoothProperToy`. -/
def L4_G_ECProjectiveEvidence_MissingSmoothProperProof : Prop := True

/-- **L4-G_ECProjectiveEvidence_To_CMSourceBridge**: the bridge from
R265-B's wrapper into R263's `CMSourceReplacementBridgeSkeleton`. -/
def L4_G_ECProjectiveEvidence_To_CMSourceBridge : Prop := True

/-! ## Section 11: explicit non-closure -/

/-- **R265-B non-closure (1/7)**: does NOT implement high-dimensional
abelian varieties. -/
theorem R265B_does_not_implement_high_dimensional_AV : True := trivial

/-- **R265-B non-closure (2/7)**: does NOT implement `GroupScheme`. -/
theorem R265B_does_not_implement_GroupScheme : True := trivial

/-- **R265-B non-closure (3/7)**: does NOT prove the projective
Weierstrass model is a real `ProjectiveScheme` (Mathlib gap). -/
theorem R265B_does_not_prove_projective_scheme_structure : True := trivial

/-- **R265-B non-closure (4/7)**: does NOT prove smooth-proper
structure. -/
theorem R265B_does_not_prove_smooth_proper_structure : True := trivial

/-- **R265-B non-closure (5/7)**: does NOT implement real CM. -/
theorem R265B_does_not_implement_real_CM : True := trivial

/-- **R265-B non-closure (6/7)**: does NOT prove Deligne 1982. -/
theorem R265B_does_not_prove_deligne_1982 : True := trivial

/-- **R265-B non-closure (7/7)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R265B_does_not_close_canonicalE7ShimuraTor : True := trivial

end AbelianVarietyInterfaceECProjectiveRealization
end HCGapL4
end HodgeReduction
