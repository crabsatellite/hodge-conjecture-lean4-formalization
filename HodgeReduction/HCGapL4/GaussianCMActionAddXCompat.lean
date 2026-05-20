/-
# HC Gap L4 — Gaussian CM action `addX` compatibility (R305 / Agent D).

R301-R304 established that the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` preserves the Weierstrass equation and the
nonsingularity condition for the base-changed curve
`E_K = GaussianCMEllipticCurveTargetBaseChange` over
`K = GaussianRationalFieldCandidate`. R305 / Agent B closed `negY`
compatibility and R305 / Agent C closed `slope` compatibility. This
file closes the next required compatibility for the chord-tangent
additivity attack: the `addX` map of Mathlib intertwines with the
Gaussian CM coordinate transformation up to multiplication by `-1`.

## Mathematics

Mathlib defines (`Mathlib/AlgebraicGeometry/EllipticCurve/Affine.lean:347-349`):

    @[simp]
    def WeierstrassCurve.Affine.addX (x₁ x₂ L : R) : R :=
      L ^ 2 + W.a₁ * L - W.a₂ - x₁ - x₂

For `E_K` with `a₁ = a₂ = 0` (R300), this reduces on the base-changed
curve to

    addX x₁ x₂ L = L² - x₁ - x₂.

The Gaussian CM coordinate map sends `x ↦ -x`, `y ↦ i·y`, and (by
R305 / Agent C) `slope ↦ -i · slope`. So applying `addX` with the
transformed arguments yields

    addX (-x₁) (-x₂) (-i · L)
       = (-i·L)² - (-x₁) - (-x₂)
       = (-i)² · L² + x₁ + x₂
       = -L² + x₁ + x₂
       = -(L² - x₁ - x₂)
       = -(addX x₁ x₂ L).

The conclusion is **unconditional**: for all `x₁, x₂, L : K`, the
identity holds. It does NOT depend on the slope compatibility — it is
purely an algebraic identity about `addX` with `a₁ = a₂ = 0` and
`(-i)² = -1`. The slope-substituted corollary
`gaussianCMAction_addX_compat_at_slope` is the instantiation at
`L = slope x₁ x₂ y₁ y₂`, which uses Agent C's `slope_compat`.

## What this file provides (all kernel-pure)

* `gaussianCMAction_addX_compat` — unconditional `addX` compatibility
  with the Gaussian CM coordinate map.
* `gaussianCMAction_addX_compat_at_slope` — slope-substituted
  corollary (uses R305 / Agent C `gaussianCMAction_slope_compat`).
* Status / non-closure markers.

All declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMActionSlopeCompat
import HodgeReduction.HCGapL4.GaussianCMEllipticCurveBaseChange
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: `addX` compatibility — unconditional -/

/-- **R305 / Agent D** the Gaussian CM coordinate map `(x, y) ↦ (-x, i·y)`
intertwines with Mathlib's `addX` on the affine model of
`E_K = GaussianCMEllipticCurveTargetBaseChange` up to multiplication
by `-1`:

    addX (-x₁) (-x₂) (-i · L) = -(addX x₁ x₂ L).

Proof: by definition `addX x₁ x₂ L = L² + a₁·L - a₂ - x₁ - x₂`; with
`a₁ = a₂ = 0` (R300) this reduces to `addX x₁ x₂ L = L² - x₁ - x₂`.
Then

    LHS = (-i·L)² - (-x₁) - (-x₂) = i²·L² + x₁ + x₂ = -L² + x₁ + x₂,
    RHS = -(L² - x₁ - x₂)        = -L² + x₁ + x₂,

and the equality follows from `i² = -1` via `linear_combination`. -/
theorem gaussianCMAction_addX_compat
    (x₁ x₂ L : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
        (-x₁) (-x₂) (-gaussianRationalI * L)
      = -(GaussianCMEllipticCurveTargetBaseChange.toAffine.addX x₁ x₂ L) := by
  -- Unfold `addX` on both sides.
  show (-gaussianRationalI * L)^2
        + GaussianCMEllipticCurveTargetBaseChange.a₁ * (-gaussianRationalI * L)
        - GaussianCMEllipticCurveTargetBaseChange.a₂ - (-x₁) - (-x₂) =
       -(L^2 + GaussianCMEllipticCurveTargetBaseChange.a₁ * L
         - GaussianCMEllipticCurveTargetBaseChange.a₂ - x₁ - x₂)
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₂_eq_zero]
  -- Goal: (-i*L)² + 0·(-i*L) - 0 - (-x₁) - (-x₂) = -(L² + 0·L - 0 - x₁ - x₂)
  -- Reduces (after `ring_nf` implicitly) to `(-i)²·L² + x₁ + x₂ = -L² + x₁ + x₂`.
  have hi : (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 :=
    gaussianRationalI_sq_eq_neg_one
  linear_combination L^2 * hi

/-! ## Section 2: `addX` compatibility — at the chord-tangent slope -/

/-- **R305 / Agent D corollary**: instantiation of
`gaussianCMAction_addX_compat` at `L = slope x₁ x₂ y₁ y₂`, using
R305 / Agent C's `gaussianCMAction_slope_compat` to rewrite the
left-hand side slope into `-i · slope`. -/
theorem gaussianCMAction_addX_compat_at_slope
    (x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
        (-x₁) (-x₂)
        (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
          (-x₁) (-x₂) (gaussianRationalI * y₁) (gaussianRationalI * y₂))
      = -(GaussianCMEllipticCurveTargetBaseChange.toAffine.addX x₁ x₂
            (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
              x₁ x₂ y₁ y₂)) := by
  rw [gaussianCMAction_slope_compat]
  exact gaussianCMAction_addX_compat _ _ _

/-! ## Section 3: status / closure -/

/-- **R305 status**: `addX` compatibility closed (unconditional). -/
def R305_Status_AddX_Compat_Closed : Prop := True

/-- **R305 status**: `addX` compatibility at the chord-tangent slope
closed. -/
def R305_Status_AddX_Compat_At_Slope_Closed : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R305 / Agent D non-closure (1/3)**: does NOT prove additivity of
the Gaussian CM action on the affine group law (this is the next
target of the R305 attack chain; only `addX` compatibility lives
here). -/
theorem R305_AddX_does_not_prove_addition_compat : True := trivial

/-- **R305 / Agent D non-closure (2/3)**: does NOT construct a Mathlib
`EllipticCurve` endomorphism `i` (no `Point`-level structure is
built here). -/
theorem R305_AddX_does_not_construct_endomorphism : True := trivial

/-- **R305 / Agent D non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R305_AddX_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
