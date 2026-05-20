/-
# HC Gap L4 — Gaussian CM action square equals point negation (R304).

Building on R303 (`gaussianCMAction_affinePoint` defined) and R302
(coordinate square `i·(i·y) = negY x y`), this file closes the
**Point-level** square law:

    gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P

This is the dependent-type / proof-irrelevance lift of R302's
coordinate identity. The technical step is reconciling the implicit
`{x y}` arguments of `Point.some` after rewriting both coordinates.

All declarations kernel-pure: `{propext, Classical.choice, Quot.sound}`
or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMActionPointMap

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: helper — `Point.some` congruence under coord equality -/

/-- **R304 helper**: two `Point.some` values are equal whenever their
implicit coordinates are equal. Proof: after `subst`, Prop irrelevance
makes the two nonsingular witnesses definitionally equal. -/
private theorem affinePoint_some_eq_some
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

/-! ## Section 2: Point-level square equals negation -/

/-- **R304** the Gaussian CM action squares to point negation on the
base-changed curve:

    gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P

Proof: case-split on `P`. The `zero` case is `rfl`. For `some h` with
`h : Nonsingular x y`:
* The LHS reduces to `some (preserve (preserve h))` with implicit
  coords `(-(-x), i·(i·y))`.
* The RHS `-some h` reduces (Mathlib `Point.neg_some`) to
  `some (nonsingular_neg h)` with implicit coords `(x, negY x y)`.
* By R301 `coord_square_x` and `coord_square_equals_negY_pair`,
  the coordinate pairs agree.
* The helper `affinePoint_some_eq_some` closes the goal by Prop
  irrelevance on the two `Nonsingular` witnesses. -/
theorem gaussianCMAction_affinePoint_square_eq_neg
    (P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P := by
  cases P with
  | zero =>
    -- LHS = φ(φ(0)) = φ(0) = 0; RHS = -0 = 0.
    rfl
  | @some x y h =>
    -- Goal: φ(φ(some h)) = -(some h)
    -- LHS reduces (def) to some (preserve (preserve h))
    -- RHS reduces (Mathlib neg_some) to some (nonsingular_neg h)
    rw [WeierstrassCurve.Affine.Point.neg_some]
    refine affinePoint_some_eq_some ?_ ?_ _ _
    · exact gaussianCMAction_coord_square_x x
    · exact gaussianCMAction_coord_square_equals_negY_pair x y

/-! ## Section 3: status -/

/-- **R304 status**: square law closed at Point level. -/
def R304_Status_Square_Eq_Neg_Closed : Prop := True

/-- **R304 status**: `affinePoint_some_eq_some` available as the
proof-irrelevance-via-subst helper for future point-extensionality
needs. -/
def R304_Status_Helper_Available : Prop := True

/-! ## Section 4: next-target markers (R305+) -/

/-- **R305 target**: prove `gaussianCMAction_affinePoint` is an
`AddMonoidHom` (additivity / chord-tangent step). -/
def R305_NextTarget_AddMonoidHom : Prop := True

/-- **R305 target**: package CM action as element of `End(E_K)`
(depends on R293 Mathlib gap). -/
def R305_NextTarget_End_Element : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R304 non-closure (1/3)**: does NOT prove additivity. -/
theorem R304_does_not_prove_addMonoidHom : True := trivial

/-- **R304 non-closure (2/3)**: does NOT construct `End(E_K)`. -/
theorem R304_does_not_construct_End : True := trivial

/-- **R304 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R304_PointSquare_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
