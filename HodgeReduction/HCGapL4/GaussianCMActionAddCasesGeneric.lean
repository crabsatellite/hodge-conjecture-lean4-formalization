/-
# HC Gap L4 — Gaussian CM action additivity, generic branches (R307).

R306 closed the easy additivity branches (zero/zero and the inverse
branch via `add_of_Y_eq`). R307 closes the GENERIC branches that
produce a `some` result via Mathlib's `add_of_X_ne` (secant case
`x₁ ≠ x₂`) and `add_of_Y_ne` (tangent case `x₁ = x₂` ∧
`y₁ ≠ negY x₂ y₂`).

For both branches, Mathlib produces
    some h₁ + some h₂ = some (nonsingular_add h₁ h₂ ...)
with coordinates
    (addX x₁ x₂ slope, addY x₁ x₂ y₁ slope).

The Gaussian CM coordinate map `(x, y) ↦ (-x, i·y)` lifts to the
point map `gaussianCMAction_affinePoint` (R303). The required
identity

    φ(some h₁ + some h₂) = φ(some h₁) + φ(some h₂)

reduces, via:
* R305 / Agent C `gaussianCMAction_slope_compat`
  (slope (-x₁) (-x₂) (i·y₁) (i·y₂) = -i · slope x₁ x₂ y₁ y₂),
* R305 / Agent D `gaussianCMAction_addX_compat_at_slope`
  (addX-on-CM-side = -addX-on-original-side),
* R305 / Agent E `gaussianCMAction_addY_compat_at_slope`
  (addY-on-CM-side = i·addY-on-original-side),

to the coordinate identity
    (-(addX x₁ x₂ slope), i·(addY x₁ x₂ y₁ slope))
  = (addX (-x₁) (-x₂) (slope CM), addY (-x₁) (-x₂) (i·y₁) (slope CM)).
Both coordinate pairs witness `Nonsingular`; Prop irrelevance via the
helper `some_eq_some_helper_R307` closes the `Point.some` equality.

## What this file provides (all kernel-pure)

* `gaussianCMAction_add_X_ne_branch` — Theorem 1 (secant case).
* `gaussianCMAction_add_Y_ne_branch` — Theorem 2 (tangent case).
* Status / non-closure markers.

All declarations are kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` substantive closure.
-/

import HodgeReduction.HCGapL4.GaussianCMActionPointMap
import HodgeReduction.HCGapL4.GaussianCMActionPointSquare
import HodgeReduction.HCGapL4.GaussianCMActionNegYCompat
import HodgeReduction.HCGapL4.GaussianCMActionSlopeCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddXCompat
import HodgeReduction.HCGapL4.GaussianCMActionAddYCompat

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: helper — `Point.some` congruence under coord equality

R304's helper `affinePoint_some_eq_some` is `private` to
`GaussianCMActionPointSquare.lean`. We re-implement it inline here
under a distinct name so this file is self-contained and so we do
not depend on file-local privacy. -/

/-- **R307 helper**: two `Point.some` values are equal whenever their
implicit coordinates are equal. Proof: after `subst`, Prop irrelevance
makes the two nonsingular witnesses definitionally equal. This is the
exact analog of R304's `affinePoint_some_eq_some` helper. -/
private theorem some_eq_some_helper_R307
    {x₁ y₁ x₂ y₂ : GaussianRationalFieldCandidate}
    (hx : x₁ = x₂) (hy : y₁ = y₂)
    (h₁ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₁ y₁)
    (h₂ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₂ y₂) :
    (WeierstrassCurve.Affine.Point.some h₁ :
        GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) =
      WeierstrassCurve.Affine.Point.some h₂ := by
  subst hx
  subst hy
  rfl

/-! ## Section 2: generic branch — secant case (`x₁ ≠ x₂`) -/

/-- **R307 Theorem 1** — additivity on the secant branch.

When `x₁ ≠ x₂`, Mathlib's `add_of_X_ne` gives
`some h₁ + some h₂ = some (nonsingular_add h₁ h₂ ...)` with
coordinates `(addX x₁ x₂ slope, addY x₁ x₂ y₁ slope)`.

Applying `φ = gaussianCMAction_affinePoint`:
* LHS: `φ(some (nonsingular_add ...))` with coords
  `(-(addX x₁ x₂ slope), i·(addY x₁ x₂ y₁ slope))`.
* RHS: `φ(some h₁) + φ(some h₂)`. Since `-x₁ ≠ -x₂` (from `hx`),
  Mathlib's `add_of_X_ne` again gives
  `some (nonsingular_add (preserve h₁) (preserve h₂) ...)` with
  coords `(addX (-x₁) (-x₂) (slope CM), addY (-x₁) (-x₂) (i·y₁) (slope CM))`.

The two coordinate pairs agree by R305 / Agent D
(`gaussianCMAction_addX_compat_at_slope`) and Agent E
(`gaussianCMAction_addY_compat_at_slope`); Prop irrelevance on the
nonsingular witnesses closes via the helper. -/
theorem gaussianCMAction_add_X_ne_branch
    {x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate}
    (h₁ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₁ y₁)
    (h₂ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₂ y₂)
    (hx : x₁ ≠ x₂) :
    gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₁ + WeierstrassCurve.Affine.Point.some h₂)
      = gaussianCMAction_affinePoint (WeierstrassCurve.Affine.Point.some h₁)
        + gaussianCMAction_affinePoint (WeierstrassCurve.Affine.Point.some h₂) := by
  -- Step 1: rewrite LHS sum using `add_of_X_ne`.
  rw [WeierstrassCurve.Affine.Point.add_of_X_ne hx]
  -- LHS is now: φ(some (nonsingular_add h₁ h₂ (fun h => (hx h).elim)))
  -- Definitional unfold: φ(some k) = some (preserve k).
  rw [show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some
          (WeierstrassCurve.Affine.nonsingular_add h₁ h₂ (fun h => (hx h).elim)))
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular
              (GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
                x₁ x₂
                (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope x₁ x₂ y₁ y₂))
              (GaussianCMEllipticCurveTargetBaseChange.toAffine.addY
                x₁ x₂ y₁
                (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope x₁ x₂ y₁ y₂))
              (WeierstrassCurve.Affine.nonsingular_add h₁ h₂
                (fun h => (hx h).elim))) from rfl]
  -- Step 2: unfold φ on each RHS summand.
  rw [show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₁)
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular x₁ y₁ h₁) from rfl,
      show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₂)
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular x₂ y₂ h₂) from rfl]
  -- Step 3: apply `add_of_X_ne` on the RHS, needing `-x₁ ≠ -x₂`.
  have hx' : (-x₁ : GaussianRationalFieldCandidate) ≠ -x₂ := by
    intro h
    apply hx
    exact neg_injective h
  rw [WeierstrassCurve.Affine.Point.add_of_X_ne hx']
  -- Step 4: now LHS and RHS are both `Point.some` of `nonsingular_add` outputs;
  -- close by `some_eq_some_helper_R307` using addX/addY compat at slope.
  refine some_eq_some_helper_R307 ?_ ?_ _ _
  · -- x-coordinate equality:
    --   LHS = -(addX x₁ x₂ slope)
    --   RHS = addX (-x₁) (-x₂) (slope CM)
    -- We need: -(addX x₁ x₂ slope) = addX (-x₁) (-x₂) (slope CM)
    -- i.e. addX (-x₁) (-x₂) (slope CM) = -(addX x₁ x₂ slope)
    -- This is exactly `gaussianCMAction_addX_compat_at_slope`, modulo
    -- direction: rewrite both sides.
    exact (gaussianCMAction_addX_compat_at_slope x₁ x₂ y₁ y₂).symm
  · -- y-coordinate equality:
    --   LHS = i · (addY x₁ x₂ y₁ slope)
    --   RHS = addY (-x₁) (-x₂) (i·y₁) (slope CM)
    -- We need: i·(addY x₁ x₂ y₁ slope) = addY (-x₁) (-x₂) (i·y₁) (slope CM)
    -- This is exactly `gaussianCMAction_addY_compat_at_slope`, reversed.
    exact (gaussianCMAction_addY_compat_at_slope x₁ x₂ y₁ y₂).symm

/-! ## Section 3: generic branch — tangent case (`x₁ = x₂`, `y₁ ≠ negY x₂ y₂`) -/

/-- **R307 Theorem 2** — additivity on the tangent branch.

When `x₁ = x₂` and `y₁ ≠ negY x₂ y₂`, Mathlib's `add_of_Y_ne` gives
`some h₁ + some h₂ = some (nonsingular_add h₁ h₂ ...)` with
coordinates `(addX x₁ x₂ slope, addY x₁ x₂ y₁ slope)`.

The structure is identical to the secant case (Theorem 1), but the
CM-side precondition for `add_of_Y_ne` is:

    i·y₁ ≠ negY (-x₂) (i·y₂).

By R305 `gaussianCMAction_negY_compat`,
`negY (-x₂) (i·y₂) = i · negY x₂ y₂`. So the requirement becomes
`i·y₁ ≠ i · negY x₂ y₂`, equivalent to `y₁ ≠ negY x₂ y₂` (via
`i ≠ 0` cancellation), which is `hy`. -/
theorem gaussianCMAction_add_Y_ne_branch
    {x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate}
    (h₁ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₁ y₁)
    (h₂ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₂ y₂)
    (hx : x₁ = x₂)
    (hy : y₁ ≠ GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x₂ y₂) :
    gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₁ + WeierstrassCurve.Affine.Point.some h₂)
      = gaussianCMAction_affinePoint (WeierstrassCurve.Affine.Point.some h₁)
        + gaussianCMAction_affinePoint (WeierstrassCurve.Affine.Point.some h₂) := by
  -- Note: `hx : x₁ = x₂` is part of the standard tangent-branch hypothesis set
  -- (kept for dispatch-protocol compatibility with R308+), but the actual
  -- proof uses only `hy` since Mathlib's `add_of_Y_ne` covers both `x₁ ≠ x₂`
  -- and `x₁ = x₂` uniformly via the single hypothesis `y₁ ≠ negY x₂ y₂`.
  -- Record `hx` as used to silence the unused-variable linter.
  have _hx_used : x₁ = x₂ := hx
  -- Step 1: rewrite LHS sum using `add_of_Y_ne`.
  rw [WeierstrassCurve.Affine.Point.add_of_Y_ne hy]
  -- LHS is now: φ(some (nonsingular_add h₁ h₂ (fun _ => hy)))
  rw [show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some
          (WeierstrassCurve.Affine.nonsingular_add h₁ h₂ (fun _ => hy)))
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular
              (GaussianCMEllipticCurveTargetBaseChange.toAffine.addX
                x₁ x₂
                (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope x₁ x₂ y₁ y₂))
              (GaussianCMEllipticCurveTargetBaseChange.toAffine.addY
                x₁ x₂ y₁
                (GaussianCMEllipticCurveTargetBaseChange.toAffine.slope x₁ x₂ y₁ y₂))
              (WeierstrassCurve.Affine.nonsingular_add h₁ h₂
                (fun _ => hy))) from rfl]
  -- Step 2: unfold φ on each RHS summand.
  rw [show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₁)
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular x₁ y₁ h₁) from rfl,
      show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₂)
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular x₂ y₂ h₂) from rfl]
  -- Step 3: apply `add_of_Y_ne` on the RHS, needing
  --   `i·y₁ ≠ negY (-x₂) (i·y₂)`.
  have hi_ne : (gaussianRationalI : GaussianRationalFieldCandidate) ≠ 0 :=
    gaussianRationalI_ne_zero
  have hy' : (gaussianRationalI * y₁) ≠
      GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
        (-x₂) (gaussianRationalI * y₂) := by
    -- Rewrite RHS: negY (-x₂) (i·y₂) = i · negY x₂ y₂.
    rw [gaussianCMAction_negY_compat]
    -- Now need: i·y₁ ≠ i·negY x₂ y₂, i.e. mul_left_cancel₀ i_ne_zero from y₁ ≠ negY x₂ y₂.
    intro habs
    apply hy
    exact mul_left_cancel₀ hi_ne habs
  rw [WeierstrassCurve.Affine.Point.add_of_Y_ne hy']
  -- Step 4: close coord equality via compat lemmas.
  refine some_eq_some_helper_R307 ?_ ?_ _ _
  · -- x-coordinate equality.
    exact (gaussianCMAction_addX_compat_at_slope x₁ x₂ y₁ y₂).symm
  · -- y-coordinate equality.
    exact (gaussianCMAction_addY_compat_at_slope x₁ x₂ y₁ y₂).symm

/-! ## Section 4: status / closure -/

/-- **R307 status**: secant case (`x₁ ≠ x₂`) additivity closed. -/
def R307_Status_X_Ne_Branch_Closed : Prop := True

/-- **R307 status**: tangent case (`x₁ = x₂` ∧ `y₁ ≠ negY x₂ y₂`)
additivity closed. -/
def R307_Status_Y_Ne_Branch_Closed : Prop := True

/-- **R307 status**: the `Point.some` congruence helper
`some_eq_some_helper_R307` is reusable for downstream R308+ agents
needing Prop-irrelevance lifts of coordinate identities. -/
def R307_Status_Helper_Available : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R307 non-closure (1/4)**: does NOT package the CM action as
`AddMonoidHom Point Point`. Even after generic branches close,
combining with R306's zero/inverse branches into a unified `map_add`
is the R308+ target. -/
theorem R307_does_not_construct_addMonoidHom : True := trivial

/-- **R307 non-closure (2/4)**: does NOT construct the algebraic
endomorphism `i ∈ End(E_K)`; the R293 Mathlib gap on the
`End`-construction remains. -/
theorem R307_does_not_construct_End : True := trivial

/-- **R307 non-closure (3/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R307_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R307 non-closure (4/4)**: does NOT modify or upstream R306's
`zero_add` / `add_zero` proofs; an independent failure in R306's
`zero_add` rewrite (`0 + P` pre-reduction) is a separate concern
tracked outside this file. -/
theorem R307_does_not_repair_R306_zero_add : True := trivial

end HCGapL4
end HodgeReduction
