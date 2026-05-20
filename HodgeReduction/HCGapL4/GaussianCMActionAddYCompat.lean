/-
# HC Gap L4 — Gaussian CM action `addY` compatibility (R305 / Agent E).

R301-R304 established that the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` preserves the Weierstrass equation and the
nonsingularity condition for the base-changed curve
`E_K = GaussianCMEllipticCurveTargetBaseChange` over
`K = GaussianRationalFieldCandidate`. R305 / Agent B closed `negY`
compatibility, R305 / Agent C closed `slope` compatibility, and
R305 / Agent D closed `addX` compatibility. This file closes the
next required compatibility for the chord-tangent additivity attack:
the `addY` map of Mathlib intertwines with the Gaussian CM
coordinate transformation up to multiplication by `i`.

## Mathematics

Mathlib defines (`Mathlib/AlgebraicGeometry/EllipticCurve/Affine.lean:347-365`):

    @[simp] def addX (x₁ x₂ L : R) : R :=
      L ^ 2 + W.a₁ * L - W.a₂ - x₁ - x₂

    @[simp] def negAddY (x₁ x₂ y₁ L : R) : R :=
      L * (W.addX x₁ x₂ L - x₁) + y₁

    @[simp] def addY (x₁ x₂ y₁ L : R) : R :=
      W.negY (W.addX x₁ x₂ L) (W.negAddY x₁ x₂ y₁ L)

For `E_K` with `a₁ = a₂ = a₃ = 0` (R300), `negY x y = -y` and
`addX x₁ x₂ L = L² - x₁ - x₂`, so

    addY x₁ x₂ y₁ L = -(L · (addX x₁ x₂ L - x₁) + y₁).

The Gaussian CM coordinate map sends `x ↦ -x`, `y ↦ i·y`, and (by
R305 / Agent C) `slope ↦ -i · slope`. Applying `addY` with the
transformed arguments and writing `A = addX x₁ x₂ L`,
`A' = addX (-x₁) (-x₂) (-i·L) = -A` (R305 / Agent D), we obtain:

    negAddY (-x₁) (-x₂) (i·y₁) (-i·L)
        = (-i·L) · (A' - (-x₁)) + i·y₁
        = (-i·L) · (-A + x₁) + i·y₁
        = i·L · (A - x₁) + i·y₁
        = i · (L · (A - x₁) + y₁)
        = i · negAddY x₁ x₂ y₁ L,

    addY (-x₁) (-x₂) (i·y₁) (-i·L)
        = -(negAddY (-x₁) (-x₂) (i·y₁) (-i·L))
        = -(i · negAddY x₁ x₂ y₁ L)
        = i · (-(negAddY x₁ x₂ y₁ L))
        = i · addY x₁ x₂ y₁ L.

The conclusion is **unconditional**: for all `x₁, x₂, y₁, L : K`,
the identity holds. The slope-substituted corollary
`gaussianCMAction_addY_compat_at_slope` is the instantiation at
`L = slope x₁ x₂ y₁ y₂`, which uses R305 / Agent C's `slope_compat`.

## What this file provides (all kernel-pure)

* `gaussianCMAction_negAddY_compat` — `negAddY` compatibility helper
  (auxiliary, but exposed publicly for downstream R305 agents).
* `gaussianCMAction_addY_compat` — unconditional `addY` compatibility
  with the Gaussian CM coordinate map.
* `gaussianCMAction_addY_compat_at_slope` — slope-substituted
  corollary (uses R305 / Agent C `gaussianCMAction_slope_compat`).
* Status / non-closure markers.

All declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMActionAddXCompat
import HodgeReduction.HCGapL4.GaussianCMActionSlopeCompat
import HodgeReduction.HCGapL4.GaussianCMEllipticCurveBaseChange
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: `negAddY` compatibility — unconditional -/

/-- **R305 / Agent E helper** the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` intertwines with Mathlib's `negAddY` on the
affine model of `E_K = GaussianCMEllipticCurveTargetBaseChange` up
to multiplication by `i`:

    negAddY (-x₁) (-x₂) (i·y₁) (-i·L) = i · negAddY x₁ x₂ y₁ L.

Proof: unfold `negAddY x₁ x₂ y₁ L = L · (addX x₁ x₂ L - x₁) + y₁`,
rewrite `addX (-x₁) (-x₂) (-i·L) = -(addX x₁ x₂ L)` via R305 / Agent D
(`gaussianCMAction_addX_compat`), then close by `linear_combination`
on `i² = -1`. -/
theorem gaussianCMAction_negAddY_compat
    (x₁ x₂ y₁ L : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.negAddY
        (-x₁) (-x₂) (gaussianRationalI * y₁) (-gaussianRationalI * L)
      = gaussianRationalI *
        GaussianCMEllipticCurveTargetBaseChange.toAffine.negAddY
          x₁ x₂ y₁ L := by
  -- Unfold `negAddY` on both sides.
  show (-gaussianRationalI * L) *
        (GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
          (-x₁) (-x₂) (-gaussianRationalI * L) - (-x₁))
        + (gaussianRationalI * y₁) =
       gaussianRationalI *
        (L * (GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
                x₁ x₂ L - x₁) + y₁)
  -- Rewrite addX (CM args) = -(addX original) using R305 / Agent D.
  rw [gaussianCMAction_addX_compat]
  -- Goal: (-i*L) * (-(addX x₁ x₂ L) - (-x₁)) + i*y₁
  --     = i * (L * (addX x₁ x₂ L - x₁) + y₁)
  -- Abbreviate A := addX x₁ x₂ L; LHS = (-i*L)*(-A + x₁) + i*y₁ = i*L*A - i*L*x₁ + i*y₁
  -- RHS = i*L*A - i*L*x₁ + i*y₁.  Both sides equal — pure `ring`, no i² involved.
  ring

/-! ## Section 2: `addY` compatibility — unconditional -/

/-- **R305 / Agent E** the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` intertwines with Mathlib's `addY` on the affine
model of `E_K = GaussianCMEllipticCurveTargetBaseChange` up to
multiplication by `i`:

    addY (-x₁) (-x₂) (i·y₁) (-i·L) = i · addY x₁ x₂ y₁ L.

Proof: `addY x₁ x₂ y₁ L = negY (addX x₁ x₂ L) (negAddY x₁ x₂ y₁ L)`
and for our curve `negY x y = -y` (since `a₁ = a₃ = 0`). So
`addY = -negAddY`. Then `addY (CM args) = -negAddY (CM args)
  = -(i · negAddY x₁ x₂ y₁ L)` (by `negAddY_compat`)
  = `i · (-negAddY x₁ x₂ y₁ L) = i · addY x₁ x₂ y₁ L`. -/
theorem gaussianCMAction_addY_compat
    (x₁ x₂ y₁ L : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.addY
        (-x₁) (-x₂) (gaussianRationalI * y₁) (-gaussianRationalI * L)
      = gaussianRationalI *
        GaussianCMEllipticCurveTargetBaseChange.toAffine.addY
          x₁ x₂ y₁ L := by
  -- Unfold addY on both sides as negY ∘ (addX, negAddY).
  show GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
        (GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
          (-x₁) (-x₂) (-gaussianRationalI * L))
        (GaussianCMEllipticCurveTargetBaseChange.toAffine.negAddY
          (-x₁) (-x₂) (gaussianRationalI * y₁) (-gaussianRationalI * L))
      = gaussianRationalI *
        GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
          (GaussianCMEllipticCurveTargetBaseChange.toAffine.addX x₁ x₂ L)
          (GaussianCMEllipticCurveTargetBaseChange.toAffine.negAddY
            x₁ x₂ y₁ L)
  -- Reduce `negY x y = -y` on our curve (a₁ = a₃ = 0).
  show -(GaussianCMEllipticCurveTargetBaseChange.toAffine.negAddY
            (-x₁) (-x₂) (gaussianRationalI * y₁) (-gaussianRationalI * L))
        - GaussianCMEllipticCurveTargetBaseChange.a₁ *
            GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
              (-x₁) (-x₂) (-gaussianRationalI * L)
        - GaussianCMEllipticCurveTargetBaseChange.a₃ =
       gaussianRationalI *
        (-(GaussianCMEllipticCurveTargetBaseChange.toAffine.negAddY
              x₁ x₂ y₁ L)
          - GaussianCMEllipticCurveTargetBaseChange.a₁ *
              GaussianCMEllipticCurveTargetBaseChange.toAffine.addX x₁ x₂ L
          - GaussianCMEllipticCurveTargetBaseChange.a₃)
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero,
      gaussianCMAction_negAddY_compat]
  ring

/-! ## Section 3: `addY` compatibility — at the chord-tangent slope -/

/-- **R305 / Agent E corollary**: instantiation of
`gaussianCMAction_addY_compat` at `L = slope x₁ x₂ y₁ y₂`, using
R305 / Agent C's `gaussianCMAction_slope_compat` to rewrite the
left-hand side slope into `-i · slope`. -/
theorem gaussianCMAction_addY_compat_at_slope
    (x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.addY
        (-x₁) (-x₂) (gaussianRationalI * y₁)
        (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
          (-x₁) (-x₂) (gaussianRationalI * y₁) (gaussianRationalI * y₂))
      = gaussianRationalI *
        GaussianCMEllipticCurveTargetBaseChange.toAffine.addY
          x₁ x₂ y₁
          (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope
            x₁ x₂ y₁ y₂) := by
  rw [gaussianCMAction_slope_compat]
  exact gaussianCMAction_addY_compat _ _ _ _

/-! ## Section 4: status / closure -/

/-- **R305 status**: `negAddY` compatibility closed (unconditional). -/
def R305_Status_NegAddY_Compat_Closed : Prop := True

/-- **R305 status**: `addY` compatibility closed (unconditional). -/
def R305_AddY_Compat_Closed : Prop := True

/-- **R305 status**: `addY` compatibility at the chord-tangent slope
closed. -/
def R305_AddY_Compat_At_Slope_Closed : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R305 / Agent E non-closure (1/3)**: does NOT prove full
additivity of the Gaussian CM action on the affine group law (this
is the next target of the R305 attack chain; only `addY`
compatibility lives here). -/
theorem R305_AddY_does_not_prove_addition_compat : True := trivial

/-- **R305 / Agent E non-closure (2/3)**: does NOT construct a Mathlib
`EllipticCurve` endomorphism `i` (no `Point`-level structure is
built here). -/
theorem R305_AddY_does_not_construct_endomorphism : True := trivial

/-- **R305 / Agent E non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R305_AddY_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
