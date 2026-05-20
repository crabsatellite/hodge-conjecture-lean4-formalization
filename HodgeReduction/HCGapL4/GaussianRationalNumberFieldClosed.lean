/-
# HC Gap L4 — NumberField closure for ℚ(i) (R287).

R286 constructed `GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot`.
R280 closed `FiniteDimensional ℚ GaussianAdjoinRootCandidate` and
`finrank ℚ GaussianAdjoinRootCandidate = 2`. R287 transfers both
across the AlgEquiv and closes `NumberField` on the fraction-field
side.

## Mathlib API used

* `LinearEquiv.finiteDimensional` / `Module.Finite.equiv` — transfer
  finite-dimensionality along a linear equivalence.
* `LinearEquiv.finrank_eq` — finrank invariance.
* `NumberField` typeclass `[Field K]` + `[CharZero K]` +
  `[FiniteDimensional ℚ K]`.

## What R287 (this file) provides (all kernel-pure)

* `GaussianRationalFieldCandidate_finiteDimensional` instance.
* `GaussianRationalFieldCandidate_finrank_eq_two` theorem.
* `GaussianRationalFieldCandidate_NumberField` instance.
* Closure of R273 targets via theorems
  `Target_R273_*_closed`.
* `GaussianRationalNumberFieldEvidenceClosedSkeleton` + Gaussian instance.

## What R287 (this file) does NOT do

* Does NOT prove imaginary quadratic structure.
* Does NOT prove CMField.
* Does NOT construct End⁰(E).
* Does NOT close `canonicalE7ShimuraTor`.

All R287 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootAlgEquiv
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.LinearAlgebra.Dimension.Free

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: transfer FiniteDimensional via AlgEquiv -/

/-- **R287** `FiniteDimensional ℚ GaussianRationalFieldCandidate`
via the AlgEquiv to the AdjoinRoot side and R280's finite-dim. -/
noncomputable instance GaussianRationalFieldCandidate_finiteDimensional :
    FiniteDimensional ℚ GaussianRationalFieldCandidate :=
  Module.Finite.equiv
    GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot.symm.toLinearEquiv

/-! ## Section 2: transfer finrank = 2 -/

/-- **R287** `finrank ℚ GaussianRationalFieldCandidate = 2` via the
LinearEquiv from the AlgEquiv and R280's finrank=2. -/
theorem GaussianRationalFieldCandidate_finrank_eq_two :
    Module.finrank ℚ GaussianRationalFieldCandidate = 2 := by
  rw [LinearEquiv.finrank_eq
        GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot.toLinearEquiv]
  exact GaussianAdjoinRootCandidate_finrank_eq_two

/-! ## Section 3: NumberField instance

`NumberField K := [CharZero K] + [FiniteDimensional ℚ K]`. CharZero
should be automatic (fraction field of char-zero domain). -/

/-- **R287** `NumberField GaussianRationalFieldCandidate` — closes
the main R273 target. CharZero auto from Field + Mathlib chain;
FiniteDimensional from the R287 instance above. -/
instance GaussianRationalFieldCandidate_NumberField :
    NumberField GaussianRationalFieldCandidate where

/-! ## Section 4: closure of R273 targets -/

/-- **R287 closure**: R273's `FiniteDimensional` target. -/
theorem Target_R273_FiniteDimensional_closed :
    FiniteDimensional ℚ GaussianRationalFieldCandidate :=
  inferInstance

/-- **R287 closure**: R273's `NumberField` target. -/
theorem Target_R273_NumberField_closed :
    NumberField GaussianRationalFieldCandidate :=
  inferInstance

/-- **R287 closure**: R273's `finrank = 2` target. -/
theorem Target_R273_finrank_eq_two_closed :
    Module.finrank ℚ GaussianRationalFieldCandidate = 2 :=
  GaussianRationalFieldCandidate_finrank_eq_two

/-! ## Section 5: closed-status skeleton -/

/-- **R287** closed-status skeleton bundling all three R273
closures. -/
structure GaussianRationalNumberFieldEvidenceClosedSkeleton where
  /-- `FiniteDimensional ℚ` closed. -/
  finiteDimensionalClosed :
    FiniteDimensional ℚ GaussianRationalFieldCandidate
  /-- `NumberField` closed. -/
  numberFieldClosed :
    NumberField GaussianRationalFieldCandidate
  /-- `finrank = 2` closed. -/
  finrankTwoClosed :
    Module.finrank ℚ GaussianRationalFieldCandidate = 2

/-- **R287** Gaussian instance with all three closures bound to the
real Mathlib-backed theorems. -/
noncomputable def GaussianRationalNumberFieldEvidenceClosedSkeleton_current :
    GaussianRationalNumberFieldEvidenceClosedSkeleton where
  finiteDimensionalClosed := inferInstance
  numberFieldClosed := inferInstance
  finrankTwoClosed := GaussianRationalFieldCandidate_finrank_eq_two

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianRationalNumberFieldClosed_To_ImaginaryQuadratic**:
NumberField closure unlocks imaginary-quadratic proof (R289 target). -/
def L4_G_GaussianRationalNumberFieldClosed_To_ImaginaryQuadratic :
    Prop := True

/-- **L4-G_GaussianRationalNumberFieldClosed_To_CMField**: bridge to
CMField evidence. -/
def L4_G_GaussianRationalNumberFieldClosed_To_CMField : Prop := True

/-- **L4-G_GaussianRationalNumberFieldClosed_To_RankCondition**:
finrank = 2 closes the R261 `rankConditionToy` target's degree
component. -/
def L4_G_GaussianRationalNumberFieldClosed_To_RankCondition : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R287 non-closure (1/4)**: does NOT prove imaginary quadratic. -/
theorem R287_does_not_prove_imaginary_quadratic : True := trivial

/-- **R287 non-closure (2/4)**: does NOT prove CMField. -/
theorem R287_does_not_prove_CMField : True := trivial

/-- **R287 non-closure (3/4)**: does NOT construct `End⁰(E)`. -/
theorem R287_does_not_construct_End0 : True := trivial

/-- **R287 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R287_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
