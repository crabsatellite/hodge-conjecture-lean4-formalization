/-
# HC Gap L4 — fraction-field lift `ℚ(i) → AdjoinRoot (X²+1)` (R285).

R281 built the reverse ring hom `GaussianInt →+* GaussianAdjoinRootCandidate`.
R284 made `GaussianAdjoinRootCandidate` a `Field`. R285 lifts the
ring hom to the fraction field via `IsFractionRing.lift`, requiring
`Function.Injective` of the integer-level map.

Injectivity follows from Mathlib's `Zsqrtd.lift_injective`
(`Zsqrtd/Basic.lean:917`), which needs:
* `CharZero GaussianAdjoinRootCandidate` (auto via R284 Field + Mathlib).
* `∀ n : ℤ, -1 ≠ n * n` (standard: `n² ≥ 0 > -1`).

## What R285 (this file) provides (all kernel-pure)

* `neg_one_not_int_square` — `∀ n : ℤ, -1 ≠ n * n`.
* `GaussianInt_to_GaussianAdjoinRoot_injective` — injectivity of
  R281's reverse ring hom via `Zsqrtd.lift_injective`.
* `GaussianRational_to_GaussianAdjoinRoot_RingHom` — the lifted
  ring hom.
* `GaussianRational_to_GaussianAdjoinRoot_AlgHom` — the AlgHom
  version via `IsFractionRing.liftAlgHom`.
* Closure of R281 target
  `Target_GaussianRational_to_GaussianAdjoinRoot`.

## What R285 (this file) does NOT do

* Does NOT prove full `AlgEquiv` (needs forward/reverse inverse
  compatibility — R286 target).
* Does NOT prove `NumberField GaussianRationalFieldCandidate` (still
  open).
* Does NOT prove `FiniteDimensional ℚ GaussianRationalFieldCandidate`
  (still open).
* Does NOT close `canonicalE7ShimuraTor`.

All R285 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianPolynomialIrreducible
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.RingTheory.Localization.FractionRing

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: `-1` is not a square in ℤ -/

/-- **R285** `-1` is not a square in ℤ: for any `n : ℤ`,
`-1 ≠ n * n`. -/
theorem neg_one_not_int_square : ∀ n : ℤ, (-1 : ℤ) ≠ n * n := by
  intro n h
  have hn2 : 0 ≤ n * n := mul_self_nonneg n
  linarith

/-! ## Section 2: injectivity of `GaussianInt → GaussianAdjoinRoot` -/

/-- **R285** the reverse ring hom from R281 is injective. Follows
from Mathlib's `Zsqrtd.lift_injective` with `[CharZero GaussianAdjoinRootCandidate]`
(auto via R284 Field) and `neg_one_not_int_square`. -/
theorem GaussianInt_to_GaussianAdjoinRoot_injective :
    Function.Injective GaussianInt_to_GaussianAdjoinRoot := by
  unfold GaussianInt_to_GaussianAdjoinRoot
  exact Zsqrtd.lift_injective
    ⟨AdjoinRoot.root GaussianPolynomialOverQ,
     gaussianAdjoinRootI_sq_eq_neg_one_int⟩
    neg_one_not_int_square

/-! ## Section 3: fraction-field lift as RingHom -/

/-- **R285** the lifted ring hom from `GaussianRationalFieldCandidate`
to `GaussianAdjoinRootCandidate`. -/
noncomputable def GaussianRational_to_GaussianAdjoinRoot_RingHom :
    GaussianRationalFieldCandidate →+* GaussianAdjoinRootCandidate :=
  IsFractionRing.lift (A := GaussianInt) (K := GaussianRationalFieldCandidate)
    (g := GaussianInt_to_GaussianAdjoinRoot)
    GaussianInt_to_GaussianAdjoinRoot_injective

/-! ## Section 4: fraction-field lift as AlgHom -/

/-- **R285** the lifted AlgHom version, viewing both source and
target as ℚ-algebras. This closes R281's target
`Target_GaussianRational_to_GaussianAdjoinRoot`. -/
noncomputable def GaussianRational_to_GaussianAdjoinRoot_AlgHom :
    GaussianRationalFieldCandidate →ₐ[ℚ] GaussianAdjoinRootCandidate :=
  { GaussianRational_to_GaussianAdjoinRoot_RingHom with
    commutes' := fun r => by
      -- Two ring homs ℚ → AdjoinRoot are uniquely equal (`RingHom.ext_rat`).
      have h_eq :
          GaussianRational_to_GaussianAdjoinRoot_RingHom.comp
            (algebraMap ℚ GaussianRationalFieldCandidate) =
          algebraMap ℚ GaussianAdjoinRootCandidate :=
        RingHom.ext_rat _ _
      exact DFunLike.congr_fun h_eq r }

/-! ## Section 5: closure of R281 target -/

/-- **R285** closure of R281's
`Target_GaussianRational_to_GaussianAdjoinRoot`. -/
theorem R285_Target_GaussianRational_to_GaussianAdjoinRoot_closed :
    Nonempty (GaussianRationalFieldCandidate →ₐ[ℚ] GaussianAdjoinRootCandidate) :=
  ⟨GaussianRational_to_GaussianAdjoinRoot_AlgHom⟩

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianRationalToAdjoinRoot_To_AlgEquiv**: bridge to the
full AlgEquiv (R286 target — needs forward/reverse mutual inverse
compatibility). -/
def L4_G_GaussianRationalToAdjoinRoot_To_AlgEquiv : Prop := True

/-- **L4-G_GaussianRationalToAdjoinRoot_To_NumberField**: AlgEquiv +
R280's finite-dim AdjoinRoot would give NumberField on the fraction
field. -/
def L4_G_GaussianRationalToAdjoinRoot_To_NumberField : Prop := True

/-- **L4-G_GaussianRationalToAdjoinRoot_Mathlib_IsFractionRing_lift**:
documentation marker for the Mathlib path used
(`IsFractionRing.lift`). -/
def L4_G_GaussianRationalToAdjoinRoot_Mathlib_IsFractionRing_lift :
    Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R285 non-closure (1/5)**: does NOT construct the full
`AlgEquiv` (R286 target). -/
theorem R285_does_not_construct_AlgEquiv : True := trivial

/-- **R285 non-closure (2/5)**: does NOT prove `NumberField
GaussianRationalFieldCandidate` directly. -/
theorem R285_does_not_prove_NumberField : True := trivial

/-- **R285 non-closure (3/5)**: does NOT prove `FiniteDimensional ℚ
GaussianRationalFieldCandidate` directly. -/
theorem R285_does_not_prove_finiteDimensional : True := trivial

/-- **R285 non-closure (4/5)**: does NOT verify forward/reverse
inverse compatibility (R286 target). -/
theorem R285_does_not_verify_inverse_compatibility : True := trivial

/-- **R285 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R285_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
