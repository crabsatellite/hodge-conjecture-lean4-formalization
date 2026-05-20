/-
# HC Gap L4 — Gaussian CM action `negY` compatibility (R305 / Agent B).

R301-R304 established that the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` preserves the Weierstrass equation and the
nonsingularity condition for the base-changed curve
`E_K = GaussianCMEllipticCurveTargetBaseChange` over
`K = GaussianRationalFieldCandidate`. This file adds the
compatibility lemma between the CM action and Mathlib's `negY`
construction on the affine model.

## Mathematics

Mathlib defines (`Mathlib/AlgebraicGeometry/EllipticCurve/Affine.lean:299`):

    def WeierstrassCurve.Affine.negY (x y : R) : R := -y - W.a₁ * x - W.a₃

For `E_K` we have `a₁ = 0` and `a₃ = 0` (R300), so on this curve

    negY x y = -y.

Therefore:
* LHS: `negY (-x) (i·y) = -(i·y) = -i·y`.
* RHS: `i · negY x y = i · (-y) = -i·y`.

Both sides are equal; the proof is `ring` after unfolding `negY` and
rewriting the two zero coefficients.

## What this file provides (all kernel-pure)

* `gaussianCMAction_negY_compat` — `negY` compatibility with the
  Gaussian CM coordinate map.
* Status / non-closure markers.

All declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMEllipticCurveBaseChange
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: `negY` compatibility -/

/-- **R305** the Gaussian CM coordinate map `(x, y) ↦ (-x, i·y)` is
compatible with the Mathlib `negY` map on the affine model of
`E_K = GaussianCMEllipticCurveTargetBaseChange`:

    negY (-x) (i·y) = i · negY x y.

Proof: by definition `negY x y = -y - a₁·x - a₃`; with `a₁ = a₃ = 0`
(R300) this reduces to `negY x y = -y`. Then both sides equal
`-i·y`, and the equality follows by `ring`. -/
theorem gaussianCMAction_negY_compat
    (x y : GaussianRationalFieldCandidate) :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.negY (-x) (gaussianRationalI * y)
      = gaussianRationalI *
        GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x y := by
  show -(gaussianRationalI * y)
        - GaussianCMEllipticCurveTargetBaseChange.a₁ * (-x)
        - GaussianCMEllipticCurveTargetBaseChange.a₃ =
       gaussianRationalI *
         (-y - GaussianCMEllipticCurveTargetBaseChange.a₁ * x
              - GaussianCMEllipticCurveTargetBaseChange.a₃)
  rw [GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero,
      GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero]
  ring

/-! ## Section 2: status / closure -/

/-- **R305 status**: `negY` compatibility closed. -/
def R305_Status_NegY_Compat_Closed : Prop := True

/-! ## Section 3: explicit non-closure -/

/-- **R305 non-closure (1/3)**: does NOT prove additivity of the
Gaussian CM action on the affine group law (this is the next target
of the R305 attack chain; only `negY` compatibility lives here). -/
theorem R305_does_not_prove_addition_compat : True := trivial

/-- **R305 non-closure (2/3)**: does NOT construct a Mathlib
`EllipticCurve` endomorphism `i` (no `Point`-level structure is
built here). -/
theorem R305_does_not_construct_endomorphism : True := trivial

/-- **R305 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R305_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
