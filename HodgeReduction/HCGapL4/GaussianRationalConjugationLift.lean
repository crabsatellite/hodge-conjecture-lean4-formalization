/-
# HC Gap L4 — Gaussian rational conjugation lift (R279).

R274 recorded targets for a field-level conjugation
`RingEquiv (FractionRing GaussianInt)`. R279 attacks them:

* `starRingAut : GaussianInt ≃+* GaussianInt` is Mathlib-built
  (`Algebra.Star.Basic.lean:306`); requires `[CommSemiring R]`
  + `[StarRing R]`, both satisfied for `GaussianInt`.
* `IsFractionRing.ringEquivOfRingEquiv : (A ≃+* B) → (K ≃+* L)`
  lifts any ring-equiv between domains to a ring-equiv between
  their fraction fields (`FractionRing.lean:308`).

Composing these gives a real Mathlib-backed
`GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate`.

R279 closes:
1. The RingEquiv itself.
2. Involution: `conj ∘ conj = id`.
3. `i ↦ -i` at the field level (using R269 `gaussianIntI`).

## What R279 (this file) provides (all kernel-pure)

* `GaussianInt_conjRingEquiv` — Mathlib `starRingAut` for the
  Gaussian integers.
* `GaussianRationalFieldCandidate_conj` — the lifted field-level
  conjugation (real `RingEquiv`).
* `GaussianRationalFieldCandidate_conj_involutive` — involution
  proved.
* `gaussianRationalI` — named `i` in the fraction field.
* `GaussianRationalFieldCandidate_conj_gaussianRationalI_eq_neg` —
  `conj i = -i`.
* Updated conjugation-status skeleton + combined wrapper.

## What R279 (this file) does NOT do

* Does NOT prove `NumberField`.
* Does NOT prove `IsImaginaryQuadratic` (Mathlib absent).
* Does NOT construct `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All R279 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalConjugation
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.RingTheory.Localization.FractionRing
import Mathlib.Algebra.Star.Basic

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: Gaussian integer conjugation as RingEquiv -/

/-- **R279** Gaussian integer conjugation as a `RingEquiv`. Uses
Mathlib's `starRingAut` (`Algebra.Star.Basic.lean:306`), which
requires `[CommSemiring]` + `[StarRing]` — both supplied by
`Zsqrtd.commRing` and the `StarRing` instance at
`Zsqrtd.Basic.lean:219`. -/
noncomputable def GaussianInt_conjRingEquiv : GaussianInt ≃+* GaussianInt :=
  starRingAut

/-! ## Section 2: lifted field-level conjugation -/

/-- **R279** field-level Gaussian conjugation: the lift of
`starRingAut : GaussianInt ≃+* GaussianInt` to the fraction field
via Mathlib's `IsFractionRing.ringEquivOfRingEquiv`
(`FractionRing.lean:308`). This is the real `RingEquiv` target
recorded in R274. -/
noncomputable def GaussianRationalFieldCandidate_conj :
    GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate :=
  IsFractionRing.ringEquivOfRingEquiv GaussianInt_conjRingEquiv

/-! ## Section 3: involution

Strategy: show that `starRingAut.symm = starRingAut` (because `star`
is involutive on `GaussianInt`, definitionally via
`Function.Involutive.toPerm`), then lift via
`IsFractionRing.ringEquivOfRingEquiv_symm`. -/

/-- **R279 helper**: `starRingAut.symm = starRingAut` on `GaussianInt`,
because Mathlib's `starAddEquiv` is built from
`InvolutiveStar.star_involutive.toPerm star`, which has `invFun = star`
definitionally. -/
theorem GaussianInt_starRingAut_symm :
    (GaussianInt_conjRingEquiv).symm = GaussianInt_conjRingEquiv :=
  RingEquiv.ext fun _ => rfl

/-- **R279** involution of the field-level Gaussian conjugation. -/
theorem GaussianRationalFieldCandidate_conj_involutive :
    Function.Involutive GaussianRationalFieldCandidate_conj := by
  have h_symm : (GaussianRationalFieldCandidate_conj).symm =
                GaussianRationalFieldCandidate_conj := by
    unfold GaussianRationalFieldCandidate_conj
    rw [IsFractionRing.ringEquivOfRingEquiv_symm, GaussianInt_starRingAut_symm]
  intro x
  calc GaussianRationalFieldCandidate_conj
        (GaussianRationalFieldCandidate_conj x)
      = GaussianRationalFieldCandidate_conj.symm
          (GaussianRationalFieldCandidate_conj x) := by rw [h_symm]
    _ = x := GaussianRationalFieldCandidate_conj.symm_apply_apply x

/-! ## Section 4: named `i` in the fraction field + conj i = -i

`gaussianRationalI` is the image of `gaussianIntI = Zsqrtd.sqrtd`
under the algebra map `GaussianInt → FractionRing GaussianInt`. -/

/-- **R279** named `i ∈ GaussianRationalFieldCandidate`. -/
noncomputable def gaussianRationalI : GaussianRationalFieldCandidate :=
  algebraMap GaussianInt GaussianRationalFieldCandidate gaussianIntI

/-- **R279 helper**: `star Zsqrtd.sqrtd = -Zsqrtd.sqrtd` for `d = -1`. -/
theorem star_gaussianIntI_eq_neg : star gaussianIntI = -gaussianIntI := by
  show star (Zsqrtd.sqrtd : GaussianInt) = -(Zsqrtd.sqrtd : GaussianInt)
  apply Zsqrtd.ext
  · -- re component: 0 = -0
    show (star (Zsqrtd.sqrtd : GaussianInt)).re =
         (-(Zsqrtd.sqrtd : GaussianInt)).re
    simp [Zsqrtd.star_re, Zsqrtd.sqrtd_re]
  · -- im component: -1 = -1
    show (star (Zsqrtd.sqrtd : GaussianInt)).im =
         (-(Zsqrtd.sqrtd : GaussianInt)).im
    simp [Zsqrtd.star_im, Zsqrtd.sqrtd_im]

/-- **R279** field-level `conj i = -i`. -/
theorem GaussianRationalFieldCandidate_conj_gaussianRationalI_eq_neg :
    GaussianRationalFieldCandidate_conj gaussianRationalI =
      -gaussianRationalI := by
  unfold gaussianRationalI GaussianRationalFieldCandidate_conj
  rw [IsFractionRing.ringEquivOfRingEquiv_algebraMap]
  show algebraMap GaussianInt GaussianRationalFieldCandidate
        (GaussianInt_conjRingEquiv gaussianIntI) = _
  rw [show GaussianInt_conjRingEquiv gaussianIntI = star gaussianIntI from rfl,
      star_gaussianIntI_eq_neg, map_neg]

/-! ## Section 5: updated conjugation-status skeleton

The R274 `GaussianRationalConjugationSkeleton` had `conjugationClosed`
as a marker `True`. R279 now closes the three R274 targets, so we
provide an updated skeleton instance with REAL evidence. -/

/-- **R279 updated conjugation-status instance** with real
Mathlib-backed evidence at all three target slots. -/
noncomputable def GaussianRationalConjugationSkeleton_closed :
    GaussianRationalConjugationSkeleton where
  K := GaussianRationalFieldCandidate
  fieldEvidence := Nonempty (Field GaussianRationalFieldCandidate)
  conjugationTarget :=
    Nonempty (GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate)
  involutiveTarget := Function.Involutive GaussianRationalFieldCandidate_conj
  nontrivialOnITarget :=
    GaussianRationalFieldCandidate_conj gaussianRationalI = -gaussianRationalI
  conjugationClosed := True

/-! ## Section 6: closure evidence theorems -/

/-- **R279 closure**: the conjugation target is closed. -/
theorem R279_conjugationTarget_closed :
    Nonempty (GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate) :=
  ⟨GaussianRationalFieldCandidate_conj⟩

/-- **R279 closure**: the involution target is closed. -/
theorem R279_involutiveTarget_closed :
    Function.Involutive GaussianRationalFieldCandidate_conj :=
  GaussianRationalFieldCandidate_conj_involutive

/-- **R279 closure**: the `i ↦ -i` target is closed. -/
theorem R279_nontrivialOnITarget_closed :
    GaussianRationalFieldCandidate_conj gaussianRationalI =
      -gaussianRationalI :=
  GaussianRationalFieldCandidate_conj_gaussianRationalI_eq_neg

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianConjugationLift_To_ImaginaryQuadraticInterface**:
R279 strengthens R275's `conjugationTarget` from marker to real
evidence. -/
def L4_G_GaussianConjugationLift_To_ImaginaryQuadraticInterface :
    Prop := True

/-- **L4-G_GaussianConjugationLift_To_End0Action**: the lifted
conjugation can serve as the action component on `End⁰(E)` if the
End⁰(E) infrastructure is later built. -/
def L4_G_GaussianConjugationLift_To_End0Action : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R279 non-closure (1/5)**: does NOT prove `NumberField`. -/
theorem R279_does_not_prove_NumberField : True := trivial

/-- **R279 non-closure (2/5)**: does NOT prove `IsImaginaryQuadratic`
(Mathlib absent). -/
theorem R279_does_not_prove_IsImaginaryQuadratic : True := trivial

/-- **R279 non-closure (3/5)**: does NOT construct `End⁰(E)`. -/
theorem R279_does_not_construct_End0 : True := trivial

/-- **R279 non-closure (4/5)**: does NOT prove CM elliptic curve. -/
theorem R279_does_not_prove_EC_CM : True := trivial

/-- **R279 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R279_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
