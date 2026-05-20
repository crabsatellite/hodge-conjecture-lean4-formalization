/-
# HC Gap L4 — fallback `{1, i}` basis approach for ℚ(i) (R282).

R281 closed the forward AlgHom `AdjoinRoot (X²+1) →ₐ[ℚ] GaussianRationalFieldCandidate`
and the reverse ring hom `GaussianInt →+* AdjoinRoot (X²+1)`, but
the full AlgEquiv requires either:
* `X²+1` irreducible over ℚ + `AdjoinRoot.instField` + fraction-field
  lift via `IsLocalization.lift`, OR
* direct `{1, i}` basis construction.

R282 records the direct basis approach as named targets with the
precise minimal blocking lemmas. NO claim of finite-dimensionality
unless actual proof closes.

The two basis elements:
* `gaussianRationalOne := (1 : GaussianRationalFieldCandidate)`
* `gaussianRationalI` (from R279)

The basis claim:
* `Submodule.span ℚ {1, i} = ⊤`
* `LinearIndependent ℚ ![1, i]`

Both are blocked on the **Gaussian rational normal form**:
every element of `FractionRing GaussianInt` equals `(a + b·i) / c`
for some `a, b, c ∈ ℤ` (with `c > 0`), equivalently
`(p + q·i)` for some `p, q ∈ ℚ`. Mathlib's `FractionRing` doesn't
provide this directly; it requires the
`(a+bi)/(c+di) = ((a+bi)(c-di))/((c+di)(c-di)) = (ac+bd + (bc-ad)i)/(c²+d²)`
rationalization trick.

## What R282 (this file) provides (all kernel-pure)

* `gaussianRationalOne` — named `1` in the fraction field.
* `GaussianRational_basisCandidate : Fin 2 → GaussianRationalFieldCandidate`.
* `Target_GaussianRational_span_one_i` — `span = ⊤` target.
* `Target_GaussianRational_linearIndependent_one_i` — linear
  independence target.
* `Target_GaussianRational_basis_one_i` — full `Basis` target.
* `BlockingLemma_GaussianRational_normal_form` — every element is
  `p + q·i` with `p, q : ℚ`.
* `BlockingLemma_GaussianRational_rationalize_denominator` —
  `1/(c+di) = (c-di)/(c²+d²)`.
* `BlockingLemma_GaussianRational_linearIndependent_one_i` — `1` and
  `i` are ℚ-linearly independent.
* Status skeleton.

## What R282 (this file) does NOT do

* Does NOT close span = ⊤.
* Does NOT close linear independence.
* Does NOT construct the Basis.
* Does NOT prove `FiniteDimensional` / `NumberField` directly.
* Does NOT close `canonicalE7ShimuraTor`.

All R282 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldConstruction
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: basis-candidate elements -/

/-- **R282** named `1 ∈ GaussianRationalFieldCandidate`. -/
noncomputable def gaussianRationalOne : GaussianRationalFieldCandidate := 1

/-- **R282** the candidate basis family `![1, i]`. -/
noncomputable def GaussianRational_basisCandidate :
    Fin 2 → GaussianRationalFieldCandidate
  | 0 => gaussianRationalOne
  | 1 => gaussianRationalI

/-! ## Section 2: span / linear-independence / basis targets -/

/-- **R282 target**: the span of `{1, i}` over ℚ is everything. -/
def Target_GaussianRational_span_one_i : Prop :=
  Submodule.span ℚ (Set.range GaussianRational_basisCandidate) = ⊤

/-- **R282 target**: `{1, i}` is ℚ-linearly independent. -/
def Target_GaussianRational_linearIndependent_one_i : Prop :=
  LinearIndependent ℚ GaussianRational_basisCandidate

/-- **R282 target**: full `Basis` of `GaussianRationalFieldCandidate`
on `Fin 2` from the family `![1, i]`. -/
def Target_GaussianRational_basis_one_i : Prop :=
  Nonempty (Basis (Fin 2) ℚ GaussianRationalFieldCandidate)

/-! ## Section 3: blocking lemmas -/

/-- **R282 blocking lemma**: every element `z` of
`GaussianRationalFieldCandidate` is of the form
`p + q·gaussianRationalI` for unique `p, q : ℚ`. This is the
"Gaussian rational normal form". -/
def BlockingLemma_GaussianRational_normal_form : Prop := True

/-- **R282 blocking lemma**: rationalizing a denominator
`1/(c+d·i) = (c-d·i)/(c²+d²)` in `GaussianRationalFieldCandidate`,
where `c, d : ℤ` and `c² + d² > 0`. This is needed for normal
form. -/
def BlockingLemma_GaussianRational_rationalize_denominator :
    Prop := True

/-- **R282 blocking lemma**: `1` and `gaussianRationalI` are linearly
independent over ℚ in `GaussianRationalFieldCandidate`. Equivalent
to "`i ≠ q · 1` for any `q : ℚ`", i.e. `i` is not rational.

A direct path: assume `a + b · i = 0` with `a, b : ℚ`. Apply
conjugation: `a - b · i = 0`. Add: `2 a = 0`, so `a = 0`. Then
`b · i = 0`, so `b = 0` (since `i ≠ 0`). -/
def BlockingLemma_GaussianRational_linearIndependent_one_i : Prop :=
  Target_GaussianRational_linearIndependent_one_i

/-! ## Section 4: status skeleton -/

/-- **R282** basis-approach status skeleton. -/
structure GaussianRationalBasisOneIStatusSkeleton where
  /-- The basis candidate family. -/
  basisCandidate : Fin 2 → GaussianRationalFieldCandidate
  /-- Span target. -/
  spanTarget : Prop
  /-- Linear independence target. -/
  linearIndependentTarget : Prop
  /-- Basis target. -/
  basisTarget : Prop
  /-- Normal-form blocking lemma. -/
  normalFormBlocker : Prop
  /-- Denominator-rationalization blocking lemma. -/
  rationalizeBlocker : Prop

/-- **R282** current status: all four targets open, two blocking
lemmas named. -/
noncomputable def GaussianRationalBasisOneIStatusSkeleton_current :
    GaussianRationalBasisOneIStatusSkeleton where
  basisCandidate := GaussianRational_basisCandidate
  spanTarget := Target_GaussianRational_span_one_i
  linearIndependentTarget := Target_GaussianRational_linearIndependent_one_i
  basisTarget := Target_GaussianRational_basis_one_i
  normalFormBlocker := BlockingLemma_GaussianRational_normal_form
  rationalizeBlocker :=
    BlockingLemma_GaussianRational_rationalize_denominator

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianBasisOneI_To_FiniteDimensional**: closing the
basis target gives `FiniteDimensional ℚ GaussianRationalFieldCandidate`. -/
def L4_G_GaussianBasisOneI_To_FiniteDimensional : Prop := True

/-- **L4-G_GaussianBasisOneI_To_NumberField**: closing finite-dim
+ `CharZero` gives `NumberField GaussianRationalFieldCandidate`. -/
def L4_G_GaussianBasisOneI_To_NumberField : Prop := True

/-- **L4-G_GaussianBasisOneI_MissingNormalForm**: the normal form
`p + q·i` is the smallest missing lemma. -/
def L4_G_GaussianBasisOneI_MissingNormalForm : Prop := True

/-- **L4-G_GaussianBasisOneI_MissingRationalization**: denominator
rationalization is the standard textbook step blocked by
fraction-field machinery. -/
def L4_G_GaussianBasisOneI_MissingRationalization : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R282 non-closure (1/5)**: does NOT close span = ⊤. -/
theorem R282_does_not_close_span : True := trivial

/-- **R282 non-closure (2/5)**: does NOT close linear independence. -/
theorem R282_does_not_close_linearIndependent : True := trivial

/-- **R282 non-closure (3/5)**: does NOT construct `Basis`. -/
theorem R282_does_not_construct_basis : True := trivial

/-- **R282 non-closure (4/5)**: does NOT prove `NumberField`. -/
theorem R282_does_not_prove_NumberField : True := trivial

/-- **R282 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R282_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
