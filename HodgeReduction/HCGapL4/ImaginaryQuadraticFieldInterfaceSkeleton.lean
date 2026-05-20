/-
# HC Gap L4 — imaginary quadratic field interface layer (R270).

R268 added a local CMField-style interface skeleton with Prop slots.
R269 documented the NumberField gap and named `gaussianIntI`.

R270 introduces an **imaginary-quadratic interface layer** with
slots for conjugation, non-real embedding, quadratic degree, and
"totally imaginary" — all Mathlib-shaped placeholders. Where Mathlib
supplies real evidence (e.g. `StarRing (ℤ√d)` at `Zsqrtd/Basic.lean:219`
gives the conjugation `star : ℤ[i] → ℤ[i]`), R270 attaches it; where
Mathlib has no API, R270 records an `AuditMissing_*` marker.

## Mathlib conjugation evidence (audit)

* `instance : Star (ℤ√d) where star z := ⟨z.1, -z.2⟩`
  (`Zsqrtd/Basic.lean:204`) — pointwise conjugation on `ℤ√d`.
* `instance : StarRing (ℤ√d)` (`Zsqrtd/Basic.lean:219`) —
  star-ring instance carrying `star_involutive`, `star_mul`,
  `star_add`.

R270 closes a non-trivial `Nonempty (StarRing GaussianInt)` evidence
theorem using these instances. No conjugation ring-equiv is
constructed on `FractionRing GaussianInt` itself (Mathlib has no
automatic lift); `AuditMissing_GaussianRationalFieldCandidate_StarRing`
records that gap honestly.

## What R270 (this file) provides (all kernel-pure)

* `gaussianInt_has_StarRing` — Mathlib-backed conjugation evidence
  on `GaussianInt` (the RING, not the candidate FIELD).
* `AuditMissing_GaussianRationalFieldCandidate_StarRing` — gap
  marker for conjugation on the FIELD candidate.
* `ImaginaryQuadraticFieldInterfaceSkeleton` — interface bundle
  with four Prop markers + sub-skeletons for CMField + NumberField
  target.
* Gaussian instance + combined wrapper on top of R268/R269.
* Adapter to R256 + regression HC theorem.

## What R270 (this file) does NOT do

* Does NOT construct a conjugation ring-equiv on the FIELD
  `FractionRing GaussianInt` (only on the underlying RING).
* Does NOT construct a non-real complex embedding.
* Does NOT prove `CMField`.
* Does NOT construct `End⁰(E)`.
* Does NOT prove EC CM.
* Does NOT close `canonicalE7ShimuraTor`.

All R270 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.CMFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL2.EllipticCurve
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL2

/-! ## Section 1: conjugation evidence on GaussianInt -/

/-- **R270** Mathlib-backed conjugation evidence on the Gaussian
integer RING. `Zsqrtd/Basic.lean:219` provides `StarRing (ℤ√d)`. -/
theorem gaussianInt_has_StarRing :
    Nonempty (StarRing GaussianInt) :=
  ⟨inferInstance⟩

/-- **R270** audit-missing marker: a `StarRing` /
conjugation-ring-equiv lift on the FIELD `FractionRing GaussianInt`
is NOT provided by Mathlib automatically. -/
def AuditMissing_GaussianRationalFieldCandidate_StarRing : Prop := True

/-! ## Section 2: imaginary quadratic interface bundle -/

/-- **R270 imaginary quadratic field interface bundle**. Combines
R268's CMField proven-evidence + R269's NumberField target + four
Prop markers for the imaginary-quadratic-specific structure
(conjugation, non-real embedding, quadratic degree, totally
imaginary). -/
structure ImaginaryQuadraticFieldInterfaceSkeleton where
  /-- The R268 CMField proven-evidence. -/
  cmFieldInterface : CMFieldInterfaceEvidenceData
  /-- The R269 NumberField target. -/
  numberFieldTarget : GaussianRationalNumberFieldTargetSkeleton
  /-- Prop marker for conjugation evidence on the field. -/
  hasConjugationToy : Prop
  /-- Prop marker for non-real complex embedding. -/
  hasNonRealEmbeddingToy : Prop
  /-- Prop marker for quadratic degree property. -/
  hasQuadraticDegreeToy : Prop
  /-- Prop marker for totally-imaginary property. -/
  hasTotallyImaginaryToy : Prop

/-- **R270** Gaussian instance. The conjugation marker is bound to
the R270 RING-level conjugation evidence (real), other markers
remain placeholders. -/
noncomputable def ImaginaryQuadraticFieldInterfaceSkeleton_Gaussian :
    ImaginaryQuadraticFieldInterfaceSkeleton where
  cmFieldInterface := CMFieldInterfaceEvidenceData_GaussianCandidate
  numberFieldTarget := GaussianRationalNumberFieldTargetSkeleton_current
  -- Real evidence at the ring level; field-level conjugation gap
  -- recorded as `AuditMissing_GaussianRationalFieldCandidate_StarRing`.
  hasConjugationToy := Nonempty (StarRing GaussianInt)
  hasNonRealEmbeddingToy := True
  hasQuadraticDegreeToy := True
  hasTotallyImaginaryToy := True

/-! ## Section 3: combined wrapper on top of R268 -/

/-- **R270** combined wrapper on top of R268's CMField wrapper. -/
structure EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton where
  /-- The R268 CMField candidate wrapper. -/
  baseCMFieldCandidate :
    EllipticCurveCMInterfaceWithCMFieldCandidateBundle
  /-- The R270 imaginary-quadratic interface. -/
  imaginaryQuadraticInterface :
    ImaginaryQuadraticFieldInterfaceSkeleton

/-- **R270** concrete combined-wrapper instance. -/
noncomputable def EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton_instance :
    EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton where
  baseCMFieldCandidate :=
    EllipticCurveCMInterfaceWithCMFieldCandidateBundle_instance
  imaginaryQuadraticInterface :=
    ImaginaryQuadraticFieldInterfaceSkeleton_Gaussian

/-! ## Section 4: adapter to R256

R270 delegates the adapter to R268's existing
`AbstractCMAbelianHCSource_from_EllipticCurveCMFieldCandidateInterface`.
The R270 imaginary-quadratic interface layer adds only metadata on
top of R268; the abstract CM source extracted from the EC seed is
unchanged. -/

/-- **R270** adapter (delegates to R268's R256 adapter). -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveImaginaryQuadraticCandidate :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_from_EllipticCurveCMFieldCandidateInterface

/-! ## Section 5: regression HC at codim 1

R270 delegates the regression to R268's existing regression theorem;
the math content is identical and R270's contribution is the
imaginary-quadratic interface metadata layer. -/

/-- **R270** regression: HC at codim 1 for the E_7-Shimura toy
(delegates to R268's regression theorem). -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveImaginaryQuadraticCandidate :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveCMFieldCandidateInterface

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ImaginaryQuadraticFieldInterface_To_CMField**: bridge to
a real Mathlib `CMField` typeclass. -/
def L4_G_ImaginaryQuadraticFieldInterface_To_CMField : Prop := True

/-- **L4-G_ImaginaryQuadraticFieldInterface_MissingNumberFieldProof**:
the underlying NumberField target is still unproved. -/
def L4_G_ImaginaryQuadraticFieldInterface_MissingNumberFieldProof :
    Prop := True

/-- **L4-G_ImaginaryQuadraticFieldInterface_MissingConjugation**:
a conjugation ring-equiv on the FIELD candidate (not the ring) is
absent in Mathlib. -/
def L4_G_ImaginaryQuadraticFieldInterface_MissingConjugation : Prop := True

/-- **L4-G_ImaginaryQuadraticFieldInterface_MissingEmbeddingIntoC**:
a non-real complex embedding `K ↪ ℂ` for the FIELD candidate is
absent. -/
def L4_G_ImaginaryQuadraticFieldInterface_MissingEmbeddingIntoC :
    Prop := True

/-- **L4-G_ImaginaryQuadraticFieldInterface_MissingEnd0Action**: no
action on any specific elliptic curve via `End⁰(E)`. -/
def L4_G_ImaginaryQuadraticFieldInterface_MissingEnd0Action : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R270 non-closure (1/5)**: does NOT prove actual imaginary
quadratic field structure on the candidate. -/
theorem R270_does_not_prove_actual_imaginary_quadratic : True := trivial

/-- **R270 non-closure (2/5)**: does NOT prove `CMField`. -/
theorem R270_does_not_prove_CMField : True := trivial

/-- **R270 non-closure (3/5)**: does NOT construct `End⁰(E)`. -/
theorem R270_does_not_construct_End0 : True := trivial

/-- **R270 non-closure (4/5)**: does NOT prove elliptic curve CM. -/
theorem R270_does_not_prove_EC_CM : True := trivial

/-- **R270 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R270_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
