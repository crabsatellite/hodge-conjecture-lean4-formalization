/-
# HC Gap L4 — imaginary quadratic field realization interface (R275).

R273 + R274 recorded the precise NumberField + conjugation targets.
R275 introduces the **next interface layer**: a local imaginary
quadratic field realization interface that consumes the R273 +
R274 targets plus R267-B real evidence and produces a clean bundle.

Naming convention: `*RealizationInterface*` (this file) is the
fully-organized realization sister of the older `*InterfaceSkeleton`
(R270). It consolidates evidence + targets into one structure.

## What R275 (this file) provides (all kernel-pure)

* `ImaginaryQuadraticFieldRealizationInterfaceSkeleton` — interface.
* `ImaginaryQuadraticFieldRealizationEvidenceSkeleton` — proven-evidence
  wrapper.
* `ImaginaryQuadraticFieldInterfaceRealizationSkeleton_Gaussian` — Gaussian instance.
* `CMFieldInterfaceWithImaginaryQuadraticRealizationSkeleton` —
  combined wrapper.

## What R275 (this file) does NOT do

* Does NOT prove `IsImaginaryQuadratic` (Mathlib absent).
* Does NOT prove `CMField` (Mathlib absent).
* Does NOT construct End⁰(E).
* Does NOT close `canonicalE7ShimuraTor`.

All R275 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.GaussianRationalConjugation
import HodgeReduction.HCGapL4.CMFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: imaginary-quadratic realization interface -/

/-- **R275 imaginary quadratic field realization interface**. Eight
fields covering the Mathlib-shaped evidence + targets. -/
structure ImaginaryQuadraticFieldRealizationInterfaceSkeleton where
  /-- Candidate field. -/
  K : Type
  /-- Field evidence Prop slot. -/
  fieldEvidence : Prop
  /-- Q-Algebra evidence Prop slot. -/
  qAlgebraEvidence : Prop
  /-- NumberField target Prop. -/
  numberFieldTarget : Prop
  /-- Degree-two target Prop. -/
  degreeTwoTarget : Prop
  /-- Conjugation target Prop. -/
  conjugationTarget : Prop
  /-- Non-real complex embedding target Prop. -/
  nonRealEmbeddingTarget : Prop
  /-- Totally imaginary target Prop. -/
  totallyImaginaryTarget : Prop

/-! ## Section 2: proven-evidence wrapper -/

/-- **R275** proven-evidence wrapper. Pairs the interface with
closures of the available Mathlib-backed evidence and a Prop slot
for the numeric degree shape. -/
structure ImaginaryQuadraticFieldRealizationEvidenceSkeleton where
  /-- The underlying realization interface. -/
  base : ImaginaryQuadraticFieldRealizationInterfaceSkeleton
  /-- Closure of the Field evidence. -/
  fieldClosed : base.fieldEvidence
  /-- Closure of the Q-Algebra evidence. -/
  qAlgebraClosed : base.qAlgebraEvidence
  /-- Numeric degree-shape Prop (e.g. `expectedDegree = 2`). -/
  degreeShapeClosed : Prop

/-! ## Section 3: Gaussian instance -/

/-- **R275** Gaussian realization interface instance. -/
noncomputable def ImaginaryQuadraticFieldInterfaceRealizationSkeleton_Gaussian :
    ImaginaryQuadraticFieldRealizationInterfaceSkeleton where
  K := GaussianRationalFieldCandidate
  fieldEvidence := Nonempty (Field GaussianRationalFieldCandidate)
  qAlgebraEvidence := Nonempty (Algebra ℚ GaussianRationalFieldCandidate)
  numberFieldTarget := Target_R273_NumberField
  degreeTwoTarget := Target_R273_finrank_eq_two
  conjugationTarget := Target_R274_GaussianRationalFieldCandidate_conj
  nonRealEmbeddingTarget := True
  totallyImaginaryTarget := True

/-- **R275** Gaussian proven-evidence instance. -/
noncomputable def ImaginaryQuadraticFieldRealizationEvidenceSkeleton_Gaussian :
    ImaginaryQuadraticFieldRealizationEvidenceSkeleton where
  base := ImaginaryQuadraticFieldInterfaceRealizationSkeleton_Gaussian
  fieldClosed := GaussianRationalFieldCandidate_has_Field
  qAlgebraClosed := GaussianRationalFieldCandidate_has_QAlgebra
  degreeShapeClosed := True

/-! ## Section 4: combined wrapper with R268 CMField interface -/

/-- **R275** combined wrapper bundling R268's CMField proven-evidence
with R275's imaginary quadratic realization. -/
structure CMFieldInterfaceWithImaginaryQuadraticRealizationSkeleton where
  /-- The R268 CMField proven-evidence wrapper. -/
  cmFieldInterface : CMFieldInterfaceEvidenceData
  /-- The R275 imaginary quadratic realization evidence. -/
  imaginaryQuadraticInterface :
    ImaginaryQuadraticFieldRealizationEvidenceSkeleton

/-- **R275** Gaussian instance. -/
noncomputable def CMFieldInterfaceWithImaginaryQuadraticRealizationSkeleton_Gaussian :
    CMFieldInterfaceWithImaginaryQuadraticRealizationSkeleton where
  cmFieldInterface := CMFieldInterfaceEvidenceData_GaussianCandidate
  imaginaryQuadraticInterface :=
    ImaginaryQuadraticFieldRealizationEvidenceSkeleton_Gaussian

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ImaginaryQuadraticInterface_To_CMField**: bridge to a
future real CMField typeclass (Mathlib absent). -/
def L4_G_ImaginaryQuadraticInterface_To_CMField : Prop := True

/-- **L4-G_ImaginaryQuadraticInterface_MissingNumberField**: target
field's NumberField instance not proved. -/
def L4_G_ImaginaryQuadraticInterface_MissingNumberField : Prop := True

/-- **L4-G_ImaginaryQuadraticInterface_MissingComplexEmbedding**:
non-real complex embedding not constructed. -/
def L4_G_ImaginaryQuadraticInterface_MissingComplexEmbedding : Prop := True

/-- **L4-G_ImaginaryQuadraticInterface_MissingTotallyImaginaryProof**:
totally imaginary property not proved. -/
def L4_G_ImaginaryQuadraticInterface_MissingTotallyImaginaryProof :
    Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R275 non-closure (1/4)**: does NOT prove imaginary quadratic
field structure on the candidate. -/
theorem R275_does_not_prove_actual_imaginary_quadratic : True := trivial

/-- **R275 non-closure (2/4)**: does NOT define Mathlib CMField. -/
theorem R275_does_not_define_Mathlib_CMField : True := trivial

/-- **R275 non-closure (3/4)**: does NOT construct End⁰(E). -/
theorem R275_does_not_construct_End0 : True := trivial

/-- **R275 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R275_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
