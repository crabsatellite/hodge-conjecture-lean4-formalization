/-
# HC Gap L4 — AdjoinRoot ↔ FractionRing GaussianInt forward maps (R281).

R280 closed `(root)^2 + 1 = 0`, `FiniteDimensional ℚ (AdjoinRoot (X²+1))`,
and `finrank = 2` for the AdjoinRoot side. R281 builds:

* Forward AlgHom: `GaussianAdjoinRootCandidate →ₐ[ℚ] GaussianRationalFieldCandidate`
  via `AdjoinRoot.liftHom` (send root → `gaussianRationalI`).
* Reverse ring hom: `GaussianInt →+* GaussianAdjoinRootCandidate` via
  `Zsqrtd.lift` (send sqrtd → root).

The full `AlgEquiv GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate`
target requires lifting the reverse ring hom from `GaussianInt` to
`FractionRing GaussianInt`, which needs `AdjoinRoot (X²+1)` to be a
field — i.e., `X²+1` irreducible over ℚ. R281 records this exact
gap honestly.

## Mathlib API used

* `AdjoinRoot.liftHom : (S : Type*) → (x : S) → (hfx : aeval x f = 0)
   → AdjoinRoot f →ₐ[R] S` (`AdjoinRoot.lean:264`).
* `Zsqrtd.lift : { r : R // r * r = ↑d } ≃ (ℤ√d →+* R)`
  (`Zsqrtd/Basic.lean:894`).
* `Zsqrtd.dmuld : sqrtd * sqrtd = d` (`Zsqrtd/Basic.lean:271`).

## What R281 (this file) provides (all kernel-pure)

* `gaussianRationalI_sq_eq_neg_one` — `(gaussianRationalI)² = -1`
  in the fraction field.
* `aeval_gaussianPolynomial_gaussianRationalI` — `aeval gaussianRationalI
  (X²+1) = 0`.
* `GaussianAdjoinRoot_to_GaussianRational` — the forward AlgHom.
* `gaussianAdjoinRootI_sq_eq_neg_one_int` — `root * root = ((-1 : ℤ) : AdjoinRoot _)`.
* `GaussianInt_to_GaussianAdjoinRoot` — the reverse ring hom on
  Gaussian integers.
* `Target_GaussianRational_to_GaussianAdjoinRoot` — TARGET for the
  fraction-field lift (requires AdjoinRoot field structure).
* Status skeleton + R273 closure wrapper.

## What R281 (this file) does NOT do

* Does NOT construct the full `AlgEquiv` (reverse fraction-field lift
  is blocked on `AdjoinRoot (X²+1)` being a field — irreducibility).
* Does NOT prove `NumberField GaussianRationalFieldCandidate` (transfer
  blocked on missing AlgEquiv).
* Does NOT prove `FiniteDimensional ℚ GaussianRationalFieldCandidate`
  (same blocker).
* Does NOT close `canonicalE7ShimuraTor`.

All R281 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt

namespace HodgeReduction
namespace HCGapL4

open Polynomial
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: `(gaussianRationalI)² = -1` -/

/-- **R281** key computation: `gaussianIntI² = -1` in `GaussianInt`. -/
theorem gaussianIntI_sq_eq_neg_one :
    (gaussianIntI : GaussianInt)^2 = -1 := by
  show (Zsqrtd.sqrtd : GaussianInt)^2 = -1
  rw [sq, Zsqrtd.dmuld]
  rfl

/-- **R281** key computation: `gaussianRationalI² = -1` in the
fraction field. -/
theorem gaussianRationalI_sq_eq_neg_one :
    (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 := by
  unfold gaussianRationalI
  rw [← map_pow, gaussianIntI_sq_eq_neg_one, map_neg, map_one]

/-- **R281** aeval evaluation: `aeval gaussianRationalI (X²+1) = 0`. -/
theorem aeval_gaussianPolynomial_gaussianRationalI :
    (Polynomial.aeval gaussianRationalI) GaussianPolynomialOverQ = 0 := by
  unfold GaussianPolynomialOverQ
  show (Polynomial.aeval (gaussianRationalI : GaussianRationalFieldCandidate))
        (X^2 + 1) = 0
  rw [map_add, map_pow, Polynomial.aeval_X, map_one,
      gaussianRationalI_sq_eq_neg_one]
  ring

/-! ## Section 2: forward AlgHom -/

/-- **R281** forward AlgHom from `AdjoinRoot (X²+1)` to the fraction
field, sending `root → gaussianRationalI`. -/
noncomputable def GaussianAdjoinRoot_to_GaussianRational :
    GaussianAdjoinRootCandidate →ₐ[ℚ] GaussianRationalFieldCandidate :=
  AdjoinRoot.liftHom GaussianPolynomialOverQ gaussianRationalI
    aeval_gaussianPolynomial_gaussianRationalI

/-! ## Section 3: reverse ring hom on Gaussian integers -/

/-- **R281** key computation: in `AdjoinRoot (X²+1)`,
`root * root = ((-1 : ℤ) : AdjoinRoot)`. -/
theorem gaussianAdjoinRootI_sq_eq_neg_one_int :
    (AdjoinRoot.root GaussianPolynomialOverQ) *
      (AdjoinRoot.root GaussianPolynomialOverQ) =
        ((-1 : ℤ) : GaussianAdjoinRootCandidate) := by
  have h := GaussianAdjoinRoot_root_sq_add_one
  -- h : (root)^2 + 1 = 0 → root^2 = -1, i.e. root * root = -1
  have hr : (AdjoinRoot.root GaussianPolynomialOverQ)^2 = -1 :=
    eq_neg_of_add_eq_zero_left h
  rw [← sq, hr]
  push_cast
  ring

/-- **R281** reverse ring hom from `GaussianInt` to
`AdjoinRoot (X²+1)`, sending `sqrtd → root`. -/
noncomputable def GaussianInt_to_GaussianAdjoinRoot :
    GaussianInt →+* GaussianAdjoinRootCandidate :=
  Zsqrtd.lift ⟨AdjoinRoot.root GaussianPolynomialOverQ,
                gaussianAdjoinRootI_sq_eq_neg_one_int⟩

/-! ## Section 4: target for the fraction-field reverse lift -/

/-- **R281 target**: lift the ring hom
`GaussianInt → AdjoinRoot (X²+1)` to a fraction-field map
`GaussianRationalFieldCandidate → AdjoinRoot (X²+1)`. This requires
`AdjoinRoot (X²+1)` to be a field, i.e., `X²+1` irreducible over ℚ
+ `AdjoinRoot.instField` instance. -/
def Target_GaussianRational_to_GaussianAdjoinRoot : Prop :=
  Nonempty (GaussianRationalFieldCandidate →ₐ[ℚ] GaussianAdjoinRootCandidate)

/-- **R281 target**: full `AlgEquiv` between the fraction-field
candidate and `AdjoinRoot (X²+1)`. -/
def Target_GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot : Prop :=
  Nonempty
    (GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate)

/-! ## Section 5: blocking lemma — `X²+1` irreducible over ℚ -/

/-- **R281 blocking lemma**: `X²+1 : ℚ[X]` is irreducible. This is
the missing piece for `AdjoinRoot.instField` and hence for lifting
the reverse ring hom through `IsLocalization.lift`. -/
def BlockingLemma_R281_X_sq_add_one_irreducible_over_Q :
    Prop := Irreducible GaussianPolynomialOverQ

/-- **R281 blocking lemma**: `AdjoinRoot (X²+1)` is a field. Follows
from `X²+1` irreducible via `AdjoinRoot.instField`. -/
def BlockingLemma_R281_AdjoinRoot_isField :
    Prop := Nonempty (Field GaussianAdjoinRootCandidate)

/-! ## Section 6: R273 closure wrapper

If R282 / a future round closes the AlgEquiv, the R273 targets will
flip to real proofs. Until then, R273 closures remain as targets
held by this wrapper. -/

/-- **R281** R273 closure wrapper showing current closed-or-target
status of finite-dim / NumberField / finrank = 2 on the FRACTION
FIELD side. -/
structure GaussianRationalNumberFieldClosedSkeleton where
  /-- Closed-or-target: `FiniteDimensional ℚ
  GaussianRationalFieldCandidate`. -/
  finiteDimensionalClosed : Prop
  /-- Closed-or-target: `NumberField GaussianRationalFieldCandidate`. -/
  numberFieldClosed : Prop
  /-- Closed-or-target: `Module.finrank ℚ GaussianRationalFieldCandidate = 2`. -/
  finrankTwoClosed : Prop

/-- **R281** current status: R273 targets remain open (AlgEquiv
target blocked by irreducibility). -/
noncomputable def GaussianRationalNumberFieldClosedSkeleton_current :
    GaussianRationalNumberFieldClosedSkeleton where
  finiteDimensionalClosed :=
    Target_R273_FiniteDimensional
  numberFieldClosed :=
    Target_R273_NumberField
  finrankTwoClosed :=
    Target_R273_finrank_eq_two

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianRationalAdjoinRootEquiv_To_NumberField**: future
AlgEquiv would close NumberField via finite-dim transfer. -/
def L4_G_GaussianRationalAdjoinRootEquiv_To_NumberField : Prop := True

/-- **L4-G_GaussianRationalAdjoinRootEquiv_MissingFractionFieldMap**:
the fraction-field map from `FractionRing GaussianInt` requires
`AdjoinRoot (X²+1)` to be a field. -/
def L4_G_GaussianRationalAdjoinRootEquiv_MissingFractionFieldMap :
    Prop := True

/-- **L4-G_GaussianRationalAdjoinRootEquiv_MissingGaussianIntNormalForm**:
the normal form `a + b·i` for elements of `GaussianInt` is needed
to prove the forward/reverse maps are mutually inverse. -/
def L4_G_GaussianRationalAdjoinRootEquiv_MissingGaussianIntNormalForm :
    Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R281 non-closure (1/5)**: does NOT construct the full
`AlgEquiv`. -/
theorem R281_does_not_construct_full_algEquiv : True := trivial

/-- **R281 non-closure (2/5)**: does NOT prove `NumberField
GaussianRationalFieldCandidate`. -/
theorem R281_does_not_prove_NumberField_on_FractionRing : True := trivial

/-- **R281 non-closure (3/5)**: does NOT prove `FiniteDimensional ℚ
GaussianRationalFieldCandidate`. -/
theorem R281_does_not_prove_finiteDimensional_on_FractionRing :
    True := trivial

/-- **R281 non-closure (4/5)**: does NOT prove irreducibility of
`X²+1` over ℚ (recorded as blocking lemma). -/
theorem R281_does_not_prove_irreducibility : True := trivial

/-- **R281 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R281_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
