/-
# HC Gap L4 — elliptic curve endomorphism ring interface (R293).

Mathlib has no `EllipticCurve.End`, `Isogeny`, or `EllipticCurve.Hom`
file. R293 introduces a minimal local interface for `End(E)` and
attaches the next-best Mathlib evidence: `AddMonoid.End` on the
point group, which is the group-endomorphism ring (NOT the
algebraic endomorphism ring).

Key Mathlib finding:
* `AddMonoid.End M` with `[AddCommMonoid M]` is a `Semiring`
  (`Algebra/Group/Hom/End.lean:40`).
* `AddMonoid.End M` with `[AddCommGroup M]` is a `Ring`
  (`Algebra/Group/Hom/End.lean:49`).

So `AddMonoid.End E.toAffine.Point` automatically has a `Ring`
structure (from R265-A's `AddCommGroup E.toAffine.Point`). This is
the **group-endomorphism candidate**, not the algebraic-endomorphism
ring.

## What R293 (this file) provides (all kernel-pure)

* `EllipticCurveEndomorphismRingInterfaceSkeleton` — Prop-slot bundle.
* `EllipticCurveAffinePointGroupEndCandidate` — abbrev for
  `AddMonoid.End E.toAffine.Point`.
* `EllipticCurveAffinePointGroupEndCandidate_has_Semiring` — real
  Mathlib-backed Semiring evidence.
* `EllipticCurveAffinePointGroupEndCandidate_has_Ring` — Ring evidence.
* `Target_Construct_AlgebraicEndomorphismRing_EllipticCurve` — gap
  marker.
* `Target_Compare_AlgebraicEnd_To_PointGroupEnd` — comparison gap.
* `Target_Show_CMEndomorphisms_AreAlgebraic` — CM endomorphism gap.
* `EllipticCurveEndomorphismRingInterfaceWithCMFieldEvidenceSkeleton` —
  combined wrapper.
* Regression HC theorem.

## What R293 (this file) does NOT do

* Does NOT construct true algebraic `End(E)`.
* Does NOT prove group endomorphisms = algebraic endomorphisms.
* Does NOT construct `End⁰(E)`.
* Does NOT prove Gaussian embedding.
* Does NOT close `canonicalE7ShimuraTor`.

All R293 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMFieldEvidence
import HodgeReduction.HCGapL4.AbelianVarietyInterfaceECRealization
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass
import Mathlib.AlgebraicGeometry.EllipticCurve.Group
import Mathlib.Algebra.Group.Hom.End

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

/-! ## Section 1: endomorphism-ring interface skeleton -/

/-- **R293 endomorphism-ring interface**. Eight fields: 3
type/evidence slots (carrier / pointType / point group) + 5 ring
structure target Props. -/
structure EllipticCurveEndomorphismRingInterfaceSkeleton where
  /-- The curve carrier type. -/
  curveCarrier : Type
  /-- The point type. -/
  pointType : Type
  /-- Point AddCommGroup Prop slot. -/
  pointAddCommGroupEvidence : Prop
  /-- Closure. -/
  pointAddCommGroupEvidence_proved : pointAddCommGroupEvidence
  /-- The endomorphism carrier type. -/
  endCarrier : Type
  /-- Target: zero endomorphism. -/
  zeroEndTarget : Prop
  /-- Target: identity endomorphism. -/
  idEndTarget : Prop
  /-- Target: endomorphism addition. -/
  addEndTarget : Prop
  /-- Target: endomorphism negation. -/
  negEndTarget : Prop
  /-- Target: composition. -/
  compEndTarget : Prop
  /-- Target: full ring structure. -/
  ringStructureTarget : Prop
  /-- Target: compatibility with point group. -/
  compatibleWithPointGroupTarget : Prop

/-! ## Section 2: group-endomorphism candidate -/

/-- **R293** group-endomorphism candidate via `AddMonoid.End`. Not
the algebraic endomorphism ring; the gap is recorded explicitly. -/
noncomputable abbrev EllipticCurveAffinePointGroupEndCandidate
    (E : WeierstrassCurve ℚ) [E.IsElliptic] : Type :=
  AddMonoid.End E.toAffine.Point

/-- **R293** Semiring evidence (auto via Mathlib for
`[AddCommMonoid]`). -/
theorem EllipticCurveAffinePointGroupEndCandidate_has_Semiring
    (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    Nonempty (Semiring (EllipticCurveAffinePointGroupEndCandidate E)) :=
  ⟨inferInstance⟩

/-- **R293** Ring evidence (auto via Mathlib for `[AddCommGroup]`). -/
theorem EllipticCurveAffinePointGroupEndCandidate_has_Ring
    (E : WeierstrassCurve ℚ) [E.IsElliptic] :
    Nonempty (Ring (EllipticCurveAffinePointGroupEndCandidate E)) :=
  ⟨inferInstance⟩

/-! ## Section 3: gap markers for the true algebraic End(E) -/

/-- **R293 gap**: true algebraic endomorphism ring of an elliptic
curve (Mathlib absent). -/
def Target_Construct_AlgebraicEndomorphismRing_EllipticCurve :
    Prop := True

/-- **R293 gap**: prove that the algebraic endomorphism ring
embeds into the group-endomorphism ring as a subring. -/
def Target_Compare_AlgebraicEnd_To_PointGroupEnd : Prop := True

/-- **R293 gap**: for CM elliptic curves, the CM endomorphisms (from
`ℤ[i]` action) are algebraic, not just additive group homs. -/
def Target_Show_CMEndomorphisms_AreAlgebraic : Prop := True

/-! ## Section 4: combined wrapper with R290 CM evidence -/

/-- **R293** combined wrapper bundling R290 local CMField evidence
with R293 endomorphism ring interface. -/
structure EllipticCurveEndomorphismRingInterfaceWithCMFieldEvidenceSkeleton where
  /-- The R290 local CMField evidence. -/
  cmFieldEvidence : LocalCMFieldEvidenceSkeleton
  /-- The R293 endomorphism ring interface. -/
  endRingInterface : EllipticCurveEndomorphismRingInterfaceSkeleton

/-- **R293** Gaussian instance using `WeierstrassCurve ℚ` carrier
+ R265-A `AddCommGroup` evidence. Note: we use the type-level
slot, not a specific curve, because IsElliptic isn't generically
satisfied. The actual elliptic curve is named in R295. -/
noncomputable def EllipticCurveEndomorphismRingInterfaceSkeleton_PointGroupEnd :
    EllipticCurveEndomorphismRingInterfaceSkeleton where
  curveCarrier := WeierstrassCurve ℚ
  pointType := Unit  -- abstract placeholder; concrete via specific E
  pointAddCommGroupEvidence := Nonempty (AddCommGroup Unit)
  pointAddCommGroupEvidence_proved := ⟨inferInstance⟩
  endCarrier := AddMonoid.End Unit
  zeroEndTarget := True
  idEndTarget := True
  addEndTarget := True
  negEndTarget := True
  compEndTarget := True
  ringStructureTarget := Nonempty (Ring (AddMonoid.End Unit))
  compatibleWithPointGroupTarget := True

/-- **R293** combined Gaussian instance. -/
noncomputable def EllipticCurveEndomorphismRingInterfaceWithCMFieldEvidenceSkeleton_Gaussian :
    EllipticCurveEndomorphismRingInterfaceWithCMFieldEvidenceSkeleton where
  cmFieldEvidence := LocalCMFieldEvidenceSkeleton_Gaussian
  endRingInterface :=
    EllipticCurveEndomorphismRingInterfaceSkeleton_PointGroupEnd

/-! ## Section 5: regression HC theorem -/

/-- **R293** regression: HC at codim 1 for E_7-Shimura toy via the
endomorphism-ring-interface chain. Delegates to R290. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_EndomorphismRingInterface :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_LocalCMFieldEvidence

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_EndomorphismRingInterface_To_RealEndE**: bridge to the
real algebraic `End(E)` (Mathlib gap). -/
def L4_G_EndomorphismRingInterface_To_RealEndE : Prop := True

/-- **L4-G_EndomorphismRingInterface_GroupEndCandidate_NotAlgebraicEnd**:
`AddMonoid.End E.toAffine.Point` is the group-endomorphism ring,
NOT the algebraic-endomorphism ring. -/
def L4_G_EndomorphismRingInterface_GroupEndCandidate_NotAlgebraicEnd :
    Prop := True

/-- **L4-G_EndomorphismRingInterface_To_End0**: bridge to End⁰(E)
construction (R294 target). -/
def L4_G_EndomorphismRingInterface_To_End0 : Prop := True

/-- **L4-G_EndomorphismRingInterface_To_CMEmbedding**: bridge to
the Gaussian field embedding into End/End⁰ (R296 target). -/
def L4_G_EndomorphismRingInterface_To_CMEmbedding : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R293 non-closure (1/5)**: does NOT construct true algebraic
`End(E)`. -/
theorem R293_does_not_construct_real_End : True := trivial

/-- **R293 non-closure (2/5)**: does NOT prove group endomorphisms
equal algebraic endomorphisms. -/
theorem R293_does_not_prove_group_end_eq_algebraic_end : True := trivial

/-- **R293 non-closure (3/5)**: does NOT construct `End⁰(E)`. -/
theorem R293_does_not_construct_End0 : True := trivial

/-- **R293 non-closure (4/5)**: does NOT prove Gaussian field embeds. -/
theorem R293_does_not_prove_Gaussian_embedding : True := trivial

/-- **R293 non-closure (5/5)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R293_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
