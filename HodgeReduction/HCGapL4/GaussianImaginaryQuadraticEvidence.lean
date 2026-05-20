/-
# HC Gap L4 — Gaussian imaginary-quadratic evidence (R289).

R279 closed field-level conjugation + `conj i = -i`. R287 closed
`NumberField ℚ(i)` + `finrank = 2`. R289 closes the nontriviality
facts:
1. `gaussianRationalI ≠ 0`
2. `-gaussianRationalI ≠ gaussianRationalI`
3. conjugation is nontrivial on i and globally

Then bundles everything into a local imaginary-quadratic evidence
skeleton with Prop-slot evidence pattern (as in R268).

## What R289 (this file) provides (all kernel-pure)

* `gaussianRationalI_ne_zero` — `i ≠ 0`.
* `neg_gaussianRationalI_ne_gaussianRationalI` — `-i ≠ i`.
* `GaussianRationalFieldCandidate_conj_nontrivial_on_i` — `conj i ≠ i`.
* `GaussianRationalFieldCandidate_conj_ne_id` — `conj ≠ RingEquiv.refl`.
* `GaussianImaginaryQuadraticEvidenceSkeleton` — Prop-slot bundle.
* Gaussian instance.
* Connection to R288 wrapper.
* Regression HC theorem.

## What R289 (this file) does NOT do

* Does NOT define Mathlib built-in `IsImaginaryQuadratic`.
* Does NOT prove a complex embedding statement.
* Does NOT define Mathlib built-in `CMField`.
* Does NOT construct End⁰(E).
* Does NOT close `canonicalE7ShimuraTor`.

All R289 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldClosed
import HodgeReduction.HCGapL4.GaussianNumberFieldClosureIntegration
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: `gaussianRationalI ≠ 0` -/

/-- **R289** `gaussianRationalI ≠ 0` in `GaussianRationalFieldCandidate`.
Proof: if `i = 0` then `i² = 0`, but R281 gave `i² = -1`, so
`(0 : K) = -1`, then `1 = 0` via `neg_eq_zero`, contradicting
`one_ne_zero`. -/
theorem gaussianRationalI_ne_zero :
    (gaussianRationalI : GaussianRationalFieldCandidate) ≠ 0 := by
  intro h
  have h_sq : (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 :=
    gaussianRationalI_sq_eq_neg_one
  rw [h, pow_two, mul_zero] at h_sq
  -- h_sq : (0 : K) = -1, so -1 = 0 by symm, so 1 = 0 via neg_eq_zero
  exact one_ne_zero (neg_eq_zero.mp h_sq.symm)

/-! ## Section 2: `-gaussianRationalI ≠ gaussianRationalI` -/

/-- **R289** `-i ≠ i` in `GaussianRationalFieldCandidate`.
Proof: `-i = i` plus `neg_add_cancel : -i + i = 0` give `i + i = 0`,
hence `2i = 0`, then domain + `2 ≠ 0` (char 0) + `i ≠ 0` give
contradiction. -/
theorem neg_gaussianRationalI_ne_gaussianRationalI :
    -(gaussianRationalI : GaussianRationalFieldCandidate) ≠
      gaussianRationalI := by
  intro h
  -- Start from neg_add_cancel: -i + i = 0; substitute -i with i.
  have h_neg_add :
      -(gaussianRationalI : GaussianRationalFieldCandidate) + gaussianRationalI = 0 :=
    neg_add_cancel _
  -- Replace -i with i (using h) in h_neg_add.
  rw [h] at h_neg_add
  -- h_neg_add : i + i = 0
  -- 2 * i = i + i = 0
  have h2i : (2 : GaussianRationalFieldCandidate) * gaussianRationalI = 0 := by
    have h_rewrite : (2 : GaussianRationalFieldCandidate) * gaussianRationalI =
                     gaussianRationalI + gaussianRationalI := by ring
    rw [h_rewrite, h_neg_add]
  -- 2 ≠ 0 in char-zero field
  have h2_ne : (2 : GaussianRationalFieldCandidate) ≠ 0 := two_ne_zero
  -- domain ⟹ 2 = 0 ∨ i = 0
  rcases mul_eq_zero.mp h2i with h2' | hi'
  · exact h2_ne h2'
  · exact gaussianRationalI_ne_zero hi'

/-! ## Section 3: conjugation nontriviality -/

/-- **R289** `conj i ≠ i` (conjugation is nontrivial on i). -/
theorem GaussianRationalFieldCandidate_conj_nontrivial_on_i :
    GaussianRationalFieldCandidate_conj gaussianRationalI ≠
      gaussianRationalI := by
  rw [GaussianRationalFieldCandidate_conj_gaussianRationalI_eq_neg]
  exact neg_gaussianRationalI_ne_gaussianRationalI

/-- **R289** conjugation differs from `RingEquiv.refl`. -/
theorem GaussianRationalFieldCandidate_conj_ne_id :
    GaussianRationalFieldCandidate_conj ≠
      RingEquiv.refl GaussianRationalFieldCandidate := by
  intro h
  apply GaussianRationalFieldCandidate_conj_nontrivial_on_i
  -- LHS: conj i; under h, this becomes RingEquiv.refl i = i.
  rw [h]
  rfl

/-! ## Section 4: local imaginary-quadratic evidence skeleton

All evidence fields are `Prop`-valued (filled at instantiation with
specific Props referencing the concrete `K`), as in R268, to avoid
typeclass-synthesis issues in the structure definition. -/

/-- **R289** local imaginary quadratic evidence bundle.

All evidence slots are `Prop`-valued so the structure body does not
require typeclass instances on the type slot `K`. The concrete
Gaussian instance fills each Prop with a specific Mathlib-backed
proposition. -/
structure GaussianImaginaryQuadraticEvidenceSkeleton where
  /-- The candidate field type slot. -/
  K : Type
  /-- Field evidence Prop slot. -/
  fieldEvidence : Prop
  /-- Closure of field evidence. -/
  fieldEvidence_proved : fieldEvidence
  /-- Q-Algebra evidence Prop slot. -/
  qAlgebraEvidence : Prop
  /-- Closure. -/
  qAlgebraEvidence_proved : qAlgebraEvidence
  /-- NumberField evidence Prop slot. -/
  numberFieldEvidence : Prop
  /-- Closure. -/
  numberFieldEvidence_proved : numberFieldEvidence
  /-- `finrank = 2` evidence Prop slot. -/
  finrankTwoEvidence : Prop
  /-- Closure. -/
  finrankTwoEvidence_proved : finrankTwoEvidence
  /-- Conjugation evidence Prop slot. -/
  conjugationEvidence : Prop
  /-- Closure. -/
  conjugationEvidence_proved : conjugationEvidence
  /-- Conjugation involutive Prop slot. -/
  conjugationInvolutiveEvidence : Prop
  /-- Closure. -/
  conjugationInvolutiveEvidence_proved : conjugationInvolutiveEvidence
  /-- Nontrivial conjugation Prop slot. -/
  nontrivialConjugationEvidence : Prop
  /-- Closure. -/
  nontrivialConjugationEvidence_proved : nontrivialConjugationEvidence

/-- **R289** concrete Gaussian instance of the imaginary-quadratic
evidence bundle. -/
noncomputable def GaussianImaginaryQuadraticEvidenceSkeleton_current :
    GaussianImaginaryQuadraticEvidenceSkeleton where
  K := GaussianRationalFieldCandidate
  fieldEvidence := Nonempty (Field GaussianRationalFieldCandidate)
  fieldEvidence_proved := GaussianRationalFieldCandidate_has_Field
  qAlgebraEvidence := Nonempty (Algebra ℚ GaussianRationalFieldCandidate)
  qAlgebraEvidence_proved := GaussianRationalFieldCandidate_has_QAlgebra
  numberFieldEvidence := NumberField GaussianRationalFieldCandidate
  numberFieldEvidence_proved := inferInstance
  finrankTwoEvidence :=
    Module.finrank ℚ GaussianRationalFieldCandidate = 2
  finrankTwoEvidence_proved := GaussianRationalFieldCandidate_finrank_eq_two
  conjugationEvidence := Nonempty
    (GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate)
  conjugationEvidence_proved := ⟨GaussianRationalFieldCandidate_conj⟩
  conjugationInvolutiveEvidence :=
    Function.Involutive GaussianRationalFieldCandidate_conj
  conjugationInvolutiveEvidence_proved :=
    GaussianRationalFieldCandidate_conj_involutive
  nontrivialConjugationEvidence :=
    GaussianRationalFieldCandidate_conj gaussianRationalI ≠ gaussianRationalI
  nontrivialConjugationEvidence_proved :=
    GaussianRationalFieldCandidate_conj_nontrivial_on_i

/-! ## Section 5: connection to R288 wrapper -/

/-- **R289** combined wrapper bundling R288's NumberField-evidence
wrapper with R289's imaginary-quadratic evidence. -/
structure ImaginaryQuadraticFieldInterfaceWithRealEvidenceSkeleton where
  /-- The R288 NumberField evidence wrapper. -/
  base : ImaginaryQuadraticFieldInterfaceWithNumberFieldEvidenceSkeleton
  /-- The R289 Gaussian imaginary-quadratic evidence. -/
  gaussianEvidence : GaussianImaginaryQuadraticEvidenceSkeleton

/-- **R289** Gaussian instance. -/
noncomputable def ImaginaryQuadraticFieldInterfaceWithRealEvidenceSkeleton_Gaussian :
    ImaginaryQuadraticFieldInterfaceWithRealEvidenceSkeleton where
  base := ImaginaryQuadraticFieldInterfaceWithNumberFieldEvidenceSkeleton_Gaussian
  gaussianEvidence := GaussianImaginaryQuadraticEvidenceSkeleton_current

/-! ## Section 6: regression HC theorem -/

/-- **R289** regression: HC at codim 1 for E_7-Shimura toy via the
imaginary-quadratic-evidence-augmented chain. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_GaussianImaginaryQuadraticEvidence :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_CMFieldChainWithNumberFieldEvidence

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianImaginaryQuadraticEvidence_To_CMField**: R289 closure
unlocks the local CMField evidence layer (R290 target). -/
def L4_G_GaussianImaginaryQuadraticEvidence_To_CMField : Prop := True

/-- **L4-G_GaussianImaginaryQuadraticEvidence_MissingComplexEmbedding**:
a concrete `K ↪ ℂ` non-real complex embedding is not constructed. -/
def L4_G_GaussianImaginaryQuadraticEvidence_MissingComplexEmbedding :
    Prop := True

/-- **L4-G_GaussianImaginaryQuadraticEvidence_MissingTotallyImaginaryFormalization**:
the formal statement "totally imaginary" via `NumberField.InfinitePlace`
is not formalized. -/
def L4_G_GaussianImaginaryQuadraticEvidence_MissingTotallyImaginaryFormalization :
    Prop := True

/-- **L4-G_GaussianImaginaryQuadraticEvidence_MissingEnd0Action**:
no End⁰(E) action (R291+ target). -/
def L4_G_GaussianImaginaryQuadraticEvidence_MissingEnd0Action : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R289 non-closure (1/5)**: does NOT define Mathlib built-in
`IsImaginaryQuadratic`. -/
theorem R289_does_not_define_mathlib_IsImaginaryQuadratic : True := trivial

/-- **R289 non-closure (2/5)**: does NOT prove a complex embedding
statement. -/
theorem R289_does_not_prove_complex_embedding : True := trivial

/-- **R289 non-closure (3/5)**: does NOT define Mathlib built-in
`CMField`. -/
theorem R289_does_not_define_mathlib_CMField : True := trivial

/-- **R289 non-closure (4/5)**: does NOT construct `End⁰(E)`. -/
theorem R289_does_not_construct_End0 : True := trivial

/-- **R289 non-closure (5/5)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R289_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
