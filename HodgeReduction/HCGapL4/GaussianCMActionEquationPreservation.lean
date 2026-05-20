/-
# HC Gap L4 — Gaussian CM action preserves the Weierstrass equation (R301-R304).

R300 closed the base change of `y² = x³ + x` to `K = GaussianRationalFieldCandidate`
and computed all coefficients: `a₁ = a₂ = a₃ = a₆ = 0`, `a₄ = 1`. The next step
toward the CM action `i : (x, y) ↦ (-x, i*y)` is to verify that this map
preserves both the Weierstrass equation and the nonsingularity condition.

## Mathematics

For the curve `E_K : y² = x³ + x` over `K` (Mathlib's
`WeierstrassCurve.Equation` with our coefficients), assuming the original
equation `y² = x³ + x`, we compute for `(-x, i*y)`:

    (i*y)² = i²·y² = (-1)·y² = -y²
    (-x)³ + (-x) = -x³ - x = -(x³ + x)

Hence `(i*y)² = -y² = -(x³ + x) = (-x)³ + (-x)`. The map preserves
`Equation`.

For nonsingularity with our coefficients (`a₁ = a₂ = a₃ = 0, a₄ = 1`),
`nonsingular_iff'` reduces to:
    `Nonsingular x y ↔ Equation x y ∧ (-(3·x² + 1) ≠ 0 ∨ 2·y ≠ 0)`.
For the image point `(-x, i·y)`:
    `-(3·(-x)² + 1) = -(3·x² + 1)` — first disjunct identical.
    `2·(i·y)` — when `y ≠ 0`, `i ≠ 0` and `2 ≠ 0` in our field, so this is `≠ 0`.
So when one of the disjuncts holds for `(x, y)`, the corresponding (or its
equivalent) holds for `(-x, i·y)`.

## What this file provides (all kernel-pure)

* `gaussianCMAction_preserves_equation` — Equation preserved.
* `gaussianCMAction_preserves_nonsingular` — Nonsingular preserved.
* Status / non-closure markers.

All declarations are kernel-pure: `{propext, Classical.choice, Quot.sound}`
or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMEllipticCurveBaseChange
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianImaginaryQuadraticEvidence
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: equation preservation -/

/-- **R301** the Gaussian CM coordinate map `(x, y) ↦ (-x, i·y)`
preserves the Weierstrass equation `y² = x³ + x` over
`K = GaussianRationalFieldCandidate`.

Proof: with `a₁ = a₂ = a₃ = a₆ = 0` and `a₄ = 1` (from R300), the
equation reduces to `y² = x³ + x`. We compute
    `(i*y)² = i²·y² = -y² = -(x³ + x) = (-x)³ + (-x)`
using `gaussianRationalI_sq_eq_neg_one` and the hypothesis. -/
theorem gaussianCMAction_preserves_equation
    (x y : GaussianRationalFieldCandidate)
    (h : GaussianCMEllipticCurveTargetBaseChange.toAffine.Equation x y) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.Equation
      (-x) (gaussianRationalI * y) := by
  -- Use equation_iff' to reduce both sides to polynomial equations.
  rw [WeierstrassCurve.Affine.equation_iff'] at h ⊢
  -- Coefficient rewrites:
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₂_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₄_eq_one,
      GaussianCMEllipticCurveTargetBaseChange_a₆_eq_zero] at h ⊢
  -- Now h : y^2 + 0*x*y + 0*y - (x^3 + 0*x^2 + 1*x + 0) = 0
  -- Goal: (i*y)^2 + 0*(-x)*(i*y) + 0*(i*y) - ((-x)^3 + 0*(-x)^2 + 1*(-x) + 0) = 0
  have hi : (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 :=
    gaussianRationalI_sq_eq_neg_one
  -- The proof: (i*y)^2 + ... = (i^2)*y^2 + ... - (-x^3 - x) = -y^2 + x^3 + x = -(y^2 - x^3 - x) = 0.
  linear_combination -h + y^2 * hi

/-! ## Section 2: nonsingular preservation -/

/-- **R302** the Gaussian CM coordinate map `(x, y) ↦ (-x, i·y)`
preserves nonsingularity over `K`.

Proof strategy: by `nonsingular_iff'`, `Nonsingular x y` decomposes as
`Equation x y ∧ (a₁·y - (3x² + 2a₂·x + a₄) ≠ 0 ∨ 2y + a₁·x + a₃ ≠ 0)`.
With our coefficients (`a₁ = a₂ = a₃ = 0, a₄ = 1`), the disjunction
becomes `(-(3x² + 1) ≠ 0 ∨ 2y ≠ 0)`.

For the image `(-x, i·y)`:
* First disjunct: `-(3·(-x)² + 1) = -(3·x² + 1)` — invariant.
* Second disjunct: `2·(i·y) ≠ 0` whenever `i·y ≠ 0`, which when `y ≠ 0`
  follows from `gaussianRationalI ≠ 0` (R289).

We split on whether `2y = 0` (equivalently `y = 0` in our char-0 field). -/
theorem gaussianCMAction_preserves_nonsingular
    (x y : GaussianRationalFieldCandidate)
    (h : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x y) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular
      (-x) (gaussianRationalI * y) := by
  -- Decompose hypothesis via nonsingular_iff'.
  rw [WeierstrassCurve.Affine.nonsingular_iff'] at h
  -- Coefficient rewrites in disjunction part of hypothesis:
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₂_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₄_eq_one] at h
  obtain ⟨hEq, hDisj⟩ := h
  -- Apply nonsingular_iff' to the goal.
  rw [WeierstrassCurve.Affine.nonsingular_iff']
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₂_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₄_eq_one]
  refine ⟨?_, ?_⟩
  · -- Equation part: use the preservation lemma directly.
    exact gaussianCMAction_preserves_equation x y hEq
  · -- Nonsingular disjunction part.
    rcases hDisj with h1 | h2
    · -- First disjunct: invariant under x ↦ -x (since x appears only squared).
      left
      intro habs
      apply h1
      linear_combination habs
    · -- Second disjunct: 2*y ≠ 0 in hypothesis. Need 2*(i*y) ≠ 0.
      right
      have h2' : (2 : GaussianRationalFieldCandidate) * y ≠ 0 := by
        intro habs
        apply h2
        linear_combination habs
      have h2ne : (2 : GaussianRationalFieldCandidate) ≠ 0 := two_ne_zero
      have hy_ne : y ≠ 0 := by
        intro hy_zero
        apply h2'
        rw [hy_zero]; ring
      have hi_ne : gaussianRationalI ≠ 0 := gaussianRationalI_ne_zero
      have hiy_ne : gaussianRationalI * y ≠ 0 := mul_ne_zero hi_ne hy_ne
      have h2iy_ne : (2 : GaussianRationalFieldCandidate) * (gaussianRationalI * y) ≠ 0 :=
        mul_ne_zero h2ne hiy_ne
      intro habs
      apply h2iy_ne
      linear_combination habs

/-! ## Section 3: status / closure -/

/-- **R301 status**: equation preservation closed. -/
def R301_Status_Equation_Preserved : Prop := True

/-- **R302 status**: nonsingular preservation closed. -/
def R302_Status_Nonsingular_Preserved : Prop := True

/-- **R303 next target**: define the actual CM action as a function on
points (post point-type construction). -/
def R303_Next_CMAction_PointMap : Prop := True

/-- **R304 next target**: prove `i² = [-1]` for the CM action at the
point-map level. -/
def R304_Next_CMAction_Square : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R301 non-closure (1/3)**: does NOT construct an `EllipticCurve`
endomorphism (no point-type structure on `(x, y)` pairs satisfying
`Equation` is built here). -/
theorem R301_does_not_construct_endomorphism : True := trivial

/-- **R301 non-closure (2/3)**: does NOT prove `i² = [-1]` at the
point-action level. -/
theorem R301_does_not_prove_CM_square : True := trivial

/-- **R301 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R301_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
