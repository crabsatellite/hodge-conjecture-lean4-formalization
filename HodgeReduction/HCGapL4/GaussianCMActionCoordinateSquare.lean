/-
# HC Gap L4 — Gaussian CM action coordinate-level square law (R301-R304).

Building on R300 (the Gaussian CM elliptic curve `E_K : y² = x³ + x`
base-changed to `K = GaussianRationalFieldCandidate = ℚ(i)`), this file
proves the *coordinate-level* "square equals negation" law for the
candidate CM action

    (x, y)  ↦  (-x, i · y)

on `E_K`. Mathematically:

  Applying the map twice gives
    (x, y)  ↦  (-x, i·y)  ↦  (-(-x), i·(i·y))
            =  (x, i² · y)
            =  (x, -y)

and `(x, -y)` is precisely the y-coordinate of `-P` on `E_K`,
because Mathlib's `WeierstrassCurve.Affine.negY` is
`negY x y = -y - a₁·x - a₃`, and for our base-changed curve
`a₁ = 0` and `a₃ = 0`, so `negY x y = -y`.

## What this file provides (all kernel-pure)

* `gaussianCMAction_coord_square_x`  — `-(-x) = x` in `K`.
* `gaussianCMAction_coord_square_y`  — `i · (i · y) = -y` in `K`.
* `gaussianCMAction_coord_square`    — combined conjunction.
* `gaussianCMAction_coord_square_equals_negY` —
  `E_K.toAffine.negY x y = -y` (coordinate match with Mathlib negation).
* `gaussianCMAction_coord_square_equals_negY_pair` —
  the pair `(x, i·(i·y))` matches `(x, E_K.toAffine.negY x y)`.

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

/-! ## Section 1: coordinate-level square law (x component) -/

/-- **R301** the `x`-component of the CM action squares to identity:
applying `x ↦ -x` twice gives `x`. -/
theorem gaussianCMAction_coord_square_x
    (x : GaussianRationalFieldCandidate) :
    -(-x) = x :=
  neg_neg x

/-! ## Section 2: coordinate-level square law (y component) -/

/-- **R302** the `y`-component of the CM action squares to negation:
`i · (i · y) = -y`, via `i² = -1`. -/
theorem gaussianCMAction_coord_square_y
    (y : GaussianRationalFieldCandidate) :
    gaussianRationalI * (gaussianRationalI * y) = -y := by
  have h_assoc :
      gaussianRationalI * (gaussianRationalI * y) =
        (gaussianRationalI * gaussianRationalI) * y :=
    (mul_assoc gaussianRationalI gaussianRationalI y).symm
  have h_sq :
      gaussianRationalI * gaussianRationalI =
        (gaussianRationalI : GaussianRationalFieldCandidate) ^ 2 := by
    rw [pow_two]
  rw [h_assoc, h_sq, gaussianRationalI_sq_eq_neg_one]
  ring

/-! ## Section 3: combined coordinate-level square -/

/-- **R303** combined statement: applying the CM action coordinate map
twice gives `(x, -y)`. -/
theorem gaussianCMAction_coord_square
    (x y : GaussianRationalFieldCandidate) :
    (-(-x) = x) ∧
    (gaussianRationalI * (gaussianRationalI * y) = -y) :=
  ⟨gaussianCMAction_coord_square_x x,
   gaussianCMAction_coord_square_y y⟩

/-! ## Section 4: match with Mathlib `negY` on the base-changed curve

For our curve, Mathlib's `WeierstrassCurve.Affine.negY x y = -y - a₁·x - a₃`
reduces to `-y` because `a₁ = 0` and `a₃ = 0` (R300). -/

/-- **R304** match: on the base-changed curve, Mathlib's affine negation
of the y-coordinate is just `-y`. -/
theorem gaussianCMAction_coord_square_equals_negY
    (x y : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x y = -y := by
  show -y - GaussianCMEllipticCurveTargetBaseChange.a₁ * x
        - GaussianCMEllipticCurveTargetBaseChange.a₃ = -y
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero]
  ring

/-- **R304** pair-level statement: the second coordinate produced by the
CM action squared at `(x, y)` matches Mathlib's affine negation
y-coordinate `negY x y` on the base-changed curve. -/
theorem gaussianCMAction_coord_square_equals_negY_pair
    (x y : GaussianRationalFieldCandidate) :
    gaussianRationalI * (gaussianRationalI * y) =
      GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x y := by
  rw [gaussianCMAction_coord_square_y,
      gaussianCMAction_coord_square_equals_negY]

/-- **R304** Prod-level statement: applying the coordinate CM action map
twice at `(x, y)` produces exactly `(x, negY x y)` on the base-changed
curve. -/
theorem gaussianCMAction_coord_square_prod
    (x y : GaussianRationalFieldCandidate) :
    (-(-x), gaussianRationalI * (gaussianRationalI * y)) =
      (x, GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x y) := by
  rw [gaussianCMAction_coord_square_x,
      gaussianCMAction_coord_square_equals_negY_pair]

/-! ## Section 5: status / closure markers -/

/-- **R301 status**: x-coordinate square law closed. -/
def R301_Status_CoordSquare_X_Closed : Prop := True

/-- **R302 status**: y-coordinate square law closed (via `i² = -1`). -/
def R302_Status_CoordSquare_Y_Closed : Prop := True

/-- **R303 status**: combined coordinate-level square law closed. -/
def R303_Status_CoordSquare_Combined_Closed : Prop := True

/-- **R304 status**: coordinate-level match with Mathlib's `negY`
closed for the base-changed curve. -/
def R304_Status_CoordSquare_Matches_NegY_Closed : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R301-R304 non-closure (1/3)**: does NOT lift the coordinate-level
square law to a `WeierstrassCurve.Affine.Point.neg` equation; that
requires (a) showing `(x, y)` satisfies `E_K.Equation` ⇒ `(-x, i·y)`
also satisfies `E_K.Equation`, and (b) using `Point.ext` /
`Point.neg_some` to package the result as a `Point` equation.
Both are next-target work. -/
def BlockingLemma_gaussianCMAction_square_eq_neg_point_ext : Prop := True

/-- **R301-R304 non-closure (2/3)**: does NOT exhibit a Mathlib
`WeierstrassCurve.Affine.Point.neg`-level square-equals-negation
identity. The coordinate match `(x, i·(i·y)) = (x, negY x y)` is
*necessary* for the point-level statement, but not yet *sufficient*
without the `Equation`/`Nonsingular` hypotheses needed to inhabit
`Point.some`. -/
def BlockingLemma_EllipticCurve_neg_formula_for_GaussianCurve :
    Prop := True

/-- **R301-R304 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R304_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
