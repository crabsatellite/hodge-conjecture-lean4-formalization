/-
# HC Gap L4 — Gaussian CM action `slope` compatibility (R305 / Agent C).

R301-R304 established that the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` preserves the Weierstrass equation and the
nonsingularity condition for the base-changed curve
`E_K = GaussianCMEllipticCurveTargetBaseChange` over
`K = GaussianRationalFieldCandidate`. R305 / Agent B closed `negY`
compatibility. This file closes the next required compatibility for
the chord-tangent additivity attack: the `slope` map of Mathlib
intertwines with the Gaussian CM action up to multiplication by `-i`.

## Mathematics

Mathlib defines (`Mathlib/AlgebraicGeometry/EllipticCurve/Affine.lean:428`):

    noncomputable def slope (x₁ x₂ y₁ y₂ : F) : F :=
      if x₁ = x₂ then
        if y₁ = W.negY x₂ y₂ then 0
        else (3·x₁² + 2·a₂·x₁ + a₄ - a₁·y₁) / (y₁ - W.negY x₁ y₁)
      else (y₁ - y₂) / (x₁ - x₂)

For `E_K` with `a₁ = a₂ = a₃ = 0` and `a₄ = 1` (R300), `negY x y = -y`,
and the slope simplifies to:

* `x₁ ≠ x₂` (secant)          : `(y₁ - y₂) / (x₁ - x₂)`
* `x₁ = x₂` and `y₁ = -y₂`    : `0` (inverse / vertical chord)
* `x₁ = x₂` and `y₁ ≠ -y₂`    : `(3·x₁² + 1) / (2·y₁)` (tangent)

We show

    slope (-x₁) (-x₂) (i·y₁) (i·y₂) = -i · slope x₁ x₂ y₁ y₂.

* Secant: `(i·y₁ - i·y₂) / ((-x₁) - (-x₂))
    = i·(y₁-y₂) / -(x₁-x₂) = -i·(y₁-y₂)/(x₁-x₂)`.
* Inverse: `0 = -i · 0` trivially. The case-conditions align since
  `i·y₁ = -(i·y₂)` iff `y₁ = -y₂` (use `i ≠ 0`).
* Tangent: `(3·x₁² + 1) / (2·i·y₁) = -i · (3·x₁² + 1) / (2·y₁)` using
  `1/i = -i` (from `i² = -1`). Handles `y₁ = 0` sub-case (both 0/0 = 0
  in Lean's field division) separately.

The conclusion is **unconditional**: for all `x₁, x₂, y₁, y₂ : K`,
the identity holds.

## What this file provides (all kernel-pure)

* `gaussianRationalI_mul_neg_self_eq_one` — helper `i · (-i) = 1`.
* `gaussianRationalI_inv_eq_neg` — helper `1/i = -i`.
* `gaussianCMAction_slope_compat` — unconditional slope compatibility.
* Status / non-closure markers.

All declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMEllipticCurveBaseChange
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianImaginaryQuadraticEvidence
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: helpers about `i⁻¹` -/

/-- **R305 helper**: in the Gaussian rational field, `i · (-i) = 1`. -/
theorem gaussianRationalI_mul_neg_self_eq_one :
    (gaussianRationalI : GaussianRationalFieldCandidate) *
      (-gaussianRationalI) = 1 := by
  have h_sq : (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 :=
    gaussianRationalI_sq_eq_neg_one
  have h_ii : (gaussianRationalI : GaussianRationalFieldCandidate) *
                gaussianRationalI = -1 := by
    rw [← pow_two]; exact h_sq
  linear_combination -h_ii

/-- **R305 helper**: in the Gaussian rational field, `i⁻¹ = -i`. -/
theorem gaussianRationalI_inv_eq_neg :
    (gaussianRationalI : GaussianRationalFieldCandidate)⁻¹ =
      -gaussianRationalI :=
  inv_eq_of_mul_eq_one_right gaussianRationalI_mul_neg_self_eq_one

/-! ## Section 2: slope compatibility — unconditional -/

/-- **R305 / Agent C** the Gaussian CM coordinate map `(x, y) ↦ (-x, i·y)`
intertwines with Mathlib's `slope` on the affine model of
`E_K = GaussianCMEllipticCurveTargetBaseChange` up to multiplication
by `-i`:

    slope (-x₁) (-x₂) (i·y₁) (i·y₂) = -i · slope x₁ x₂ y₁ y₂.

Proof: case split on `x₁ = x₂` and (if equal) on `y₁ = negY x₂ y₂`. -/
theorem gaussianCMAction_slope_compat
    (x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
        (-x₁) (-x₂) (gaussianRationalI * y₁) (gaussianRationalI * y₂)
      = -gaussianRationalI *
          GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
            x₁ x₂ y₁ y₂ := by
  -- Coefficient lemmas:
  have ha₁ : GaussianCMEllipticCurveTargetBaseChange.a₁ = 0 :=
    GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero
  have ha₂ : GaussianCMEllipticCurveTargetBaseChange.a₂ = 0 :=
    GaussianCMEllipticCurveTargetBaseChange_a₂_eq_zero
  have ha₃ : GaussianCMEllipticCurveTargetBaseChange.a₃ = 0 :=
    GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero
  have ha₄ : GaussianCMEllipticCurveTargetBaseChange.a₄ = 1 :=
    GaussianCMEllipticCurveTargetBaseChange_a₄_eq_one
  have hi_ne : (gaussianRationalI : GaussianRationalFieldCandidate) ≠ 0 :=
    gaussianRationalI_ne_zero
  have hi_sq : (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 :=
    gaussianRationalI_sq_eq_neg_one
  have hi_mul_i : (gaussianRationalI : GaussianRationalFieldCandidate) *
                    gaussianRationalI = -1 := by
    rw [← pow_two]; exact hi_sq
  -- negY for our curve: negY x y = -y.
  have hnegY₁ : ∀ x y : GaussianRationalFieldCandidate,
      GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x y = -y := by
    intro x y
    show -y - GaussianCMEllipticCurveTargetBaseChange.a₁ * x
            - GaussianCMEllipticCurveTargetBaseChange.a₃ = -y
    rw [ha₁, ha₃]; ring
  -- Case split on x₁ = x₂.
  by_cases hx : x₁ = x₂
  · -- Equal-x case: subst and then case on inverse vs tangent.
    subst hx
    by_cases hy : y₁ = GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x₁ y₂
    · -- Inverse case.
      have hy' : y₁ = -y₂ := by rw [hnegY₁] at hy; exact hy
      have horig : GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
                      x₁ x₁ y₁ y₂ = 0 :=
        WeierstrassCurve.Affine.slope_of_Y_eq rfl hy
      have hcm_neg : (gaussianRationalI : GaussianRationalFieldCandidate) * y₁ =
          GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
            (-x₁) (gaussianRationalI * y₂) := by
        rw [hnegY₁, hy']; ring
      have hcm : GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
                    (-x₁) (-x₁) (gaussianRationalI * y₁) (gaussianRationalI * y₂)
                 = 0 :=
        WeierstrassCurve.Affine.slope_of_Y_eq rfl hcm_neg
      rw [horig, hcm]; ring
    · -- Tangent case: y₁ ≠ -y₂.
      have hy' : y₁ ≠ -y₂ := by rw [hnegY₁] at hy; exact hy
      have horig : GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
                      x₁ x₁ y₁ y₂ =
          (3 * x₁^2 + 2 * GaussianCMEllipticCurveTargetBaseChange.a₂ * x₁
            + GaussianCMEllipticCurveTargetBaseChange.a₄
            - GaussianCMEllipticCurveTargetBaseChange.a₁ * y₁) /
          (y₁ - GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x₁ y₁) :=
        WeierstrassCurve.Affine.slope_of_Y_ne rfl hy
      have hcm_ne : (gaussianRationalI : GaussianRationalFieldCandidate) * y₁ ≠
          GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
            (-x₁) (gaussianRationalI * y₂) := by
        rw [hnegY₁]
        intro habs
        apply hy'
        -- habs : i*y₁ = -(i*y₂); derive y₁ = -y₂.
        have hsum : (gaussianRationalI : GaussianRationalFieldCandidate) *
                      (y₁ + y₂) = 0 := by
          linear_combination habs
        rcases mul_eq_zero.mp hsum with hi0 | hsub
        · exact absurd hi0 hi_ne
        · linear_combination hsub
      have hcm : GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
                    (-x₁) (-x₁) (gaussianRationalI * y₁) (gaussianRationalI * y₂)
                  =
          (3 * (-x₁)^2 + 2 * GaussianCMEllipticCurveTargetBaseChange.a₂ * (-x₁)
            + GaussianCMEllipticCurveTargetBaseChange.a₄
            - GaussianCMEllipticCurveTargetBaseChange.a₁ * (gaussianRationalI * y₁)) /
          ((gaussianRationalI * y₁) -
            GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
              (-x₁) (gaussianRationalI * y₁)) :=
        WeierstrassCurve.Affine.slope_of_Y_ne rfl hcm_ne
      rw [horig, hcm]
      rw [ha₁, ha₂, ha₄]
      rw [hnegY₁ x₁ y₁, hnegY₁ (-x₁) (gaussianRationalI * y₁)]
      -- Sub-case split on y₁ = 0.
      by_cases hy0 : y₁ = 0
      · -- y₁ = 0: both denominators are 0, so both quotients = 0.
        subst hy0
        -- Goal: (3*(-x₁)^2 + 0 + 1 - 0) / (i*0 - -(i*0))
        --     = -i * ((3*x₁^2 + 0 + 1 - 0) / (0 - -0))
        -- Both denominators 0; quotients 0; -i * 0 = 0.
        simp only [mul_zero, neg_zero, sub_self, div_zero, mul_zero]
      · -- y₁ ≠ 0.
        -- Goal:
        --   (3*(-x₁)^2 + 0 + 1 - 0) / (i*y₁ - -(i*y₁))
        -- = -i * ((3*x₁^2 + 0 + 1 - 0) / (y₁ - -y₁))
        -- First simplify denominators:
        --   y₁ - -y₁ = 2*y₁;  i*y₁ - -(i*y₁) = 2*(i*y₁).
        -- Then move the -i factor into the numerator on RHS:
        --   -i * ((3*x₁² + 1) / (2*y₁)) = (-i * (3*x₁² + 1)) / (2*y₁)
        -- Then use div_eq_div_iff and linear_combination.
        have hiy_ne : (gaussianRationalI : GaussianRationalFieldCandidate) * y₁ ≠ 0 :=
          mul_ne_zero hi_ne hy0
        have h2iy_ne : (2 : GaussianRationalFieldCandidate) *
                          (gaussianRationalI * y₁) ≠ 0 :=
          mul_ne_zero two_ne_zero hiy_ne
        have h2y_ne : (2 : GaussianRationalFieldCandidate) * y₁ ≠ 0 :=
          mul_ne_zero two_ne_zero hy0
        rw [show y₁ - -y₁ = 2 * y₁ from by ring,
            show (gaussianRationalI * y₁) - -(gaussianRationalI * y₁) =
                  2 * (gaussianRationalI * y₁) from by ring]
        rw [mul_div_assoc']
        rw [div_eq_div_iff h2iy_ne h2y_ne]
        linear_combination 2 * y₁ * (3 * x₁^2 + 1) * hi_mul_i
  · -- Secant case: x₁ ≠ x₂.
    have hx' : (-x₁ : GaussianRationalFieldCandidate) ≠ -x₂ := by
      intro h
      apply hx
      exact neg_inj.mp h
    have horig : GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
                    x₁ x₂ y₁ y₂ = (y₁ - y₂) / (x₁ - x₂) :=
      WeierstrassCurve.Affine.slope_of_X_ne hx
    have hcm : GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
                  (-x₁) (-x₂) (gaussianRationalI * y₁) (gaussianRationalI * y₂)
                =
        ((gaussianRationalI * y₁) - (gaussianRationalI * y₂)) /
        ((-x₁) - (-x₂)) :=
      WeierstrassCurve.Affine.slope_of_X_ne hx'
    rw [horig, hcm]
    have hx_sub : x₁ - x₂ ≠ 0 := sub_ne_zero.mpr hx
    have hx_sub' : (-x₁ : GaussianRationalFieldCandidate) - -x₂ ≠ 0 :=
      sub_ne_zero.mpr hx'
    -- Goal: (i*y₁ - i*y₂)/(-x₁ - -x₂) = -i * ((y₁ - y₂) / (x₁ - x₂))
    -- Move RHS division out of multiplication.
    rw [mul_div_assoc']
    -- Goal: (i*y₁ - i*y₂)/(-x₁ - -x₂) = (-i * (y₁ - y₂)) / (x₁ - x₂)
    rw [div_eq_div_iff hx_sub' hx_sub]
    ring

/-! ## Section 3: status / closure -/

/-- **R305 status**: `slope` compatibility closed (unconditional). -/
def R305_Status_Slope_Compat_Closed : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R305 non-closure (1/3)**: does NOT prove additivity of the
Gaussian CM action on the affine group law (this is the next target
of the R305 attack chain; only `slope` compatibility lives here). -/
theorem R305_AgentC_does_not_prove_addition_compat : True := trivial

/-- **R305 non-closure (2/3)**: does NOT construct a Mathlib
`EllipticCurve` endomorphism `i` (no `Point`-level structure is
built here). -/
theorem R305_AgentC_does_not_construct_endomorphism : True := trivial

/-- **R305 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R305_AgentC_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
