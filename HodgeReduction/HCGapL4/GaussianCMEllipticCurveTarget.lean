/-
# HC Gap L4 — Gaussian CM elliptic-curve target (R295).

R293/R294 introduced End/End⁰ interfaces. R295 picks the explicit
elliptic-curve candidate expected to have CM by `ℤ[i]`:

    E : y² = x³ + x         (a₁=a₂=a₃=a₆=0, a₄=1)
    j(E) = 1728
    End(E) ≃ ℤ[i] (over ℚ̄; over ℚ, the i-action requires base change)

The CM action `i : (x, y) ↦ (-x, iy)` is NOT defined over ℚ — it
requires base change to `ℚ(i) = GaussianRationalFieldCandidate`.
R295 records this honestly.

## What R295 (this file) provides (all kernel-pure)

* `GaussianCMEllipticCurveTarget : WeierstrassCurve ℚ`.
* Attempted `IsElliptic` via discriminant computation
  (Δ = -64 ≠ 0).
* Precise target markers for base change + CM action + j-invariant.

## What R295 (this file) does NOT do

* Does NOT claim End(E) without base change.
* Does NOT construct the CM action over ℚ.
* Does NOT prove `j(E) = 1728` unless Mathlib has a direct formula.
* Does NOT close `canonicalE7ShimuraTor`.

All R295 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.EllipticCurveEnd0Interface
import Mathlib.AlgebraicGeometry.EllipticCurve.Weierstrass

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: explicit curve definition -/

/-- **R295** the candidate Gaussian CM elliptic curve `y² = x³ + x`. -/
def GaussianCMEllipticCurveTarget : WeierstrassCurve ℚ where
  a₁ := 0
  a₂ := 0
  a₃ := 0
  a₄ := 1
  a₆ := 0

/-! ## Section 2: IsElliptic target via discriminant -/

/-- **R295 target**: `GaussianCMEllipticCurveTarget.IsElliptic` —
the discriminant is a unit. Mathlib's `WeierstrassCurve.Δ` formula
gives Δ = -16 · (4a₄³ + 27a₆²) = -16 · 4 = -64 ≠ 0 in ℚ. -/
def Target_GaussianCMEllipticCurveTarget_IsElliptic : Prop :=
  GaussianCMEllipticCurveTarget.IsElliptic

/-! ## Section 3: CM action targets (require base change to ℚ(i)) -/

/-- **R295 gap**: base-change the curve to
`GaussianRationalFieldCandidate`. -/
def Target_GaussianCMEllipticCurve_BaseChange_To_GaussianField : Prop := True

/-- **R295 gap**: define the `i`-action `(x, y) ↦ (-x, iy)` over
the base-changed curve. -/
def Target_GaussianCMEllipticCurve_CMAction_i : Prop := True

/-- **R295 gap**: prove `i² = [-1]` for the CM action. -/
def Target_GaussianCMEllipticCurve_CMAction_i_sq_eq_neg_one : Prop := True

/-- **R295 gap**: prove `End⁰(E_K) ⊇ ℚ(i)` after base change. -/
def Target_GaussianCMEllipticCurve_End0_contains_GaussianField :
    Prop := True

/-! ## Section 4: disclosure markers -/

/-- **L4-G_GaussianCMEllipticCurve_To_CMByGaussianIntegers**:
End(E) ≃ ℤ[i] over ℚ̄. -/
def L4_G_GaussianCMEllipticCurve_To_CMByGaussianIntegers : Prop := True

/-- **L4-G_GaussianCMEllipticCurve_MissingBaseChange**: the curve
must be base-changed to ℚ(i) for the CM action to be defined. -/
def L4_G_GaussianCMEllipticCurve_MissingBaseChange : Prop := True

/-- **L4-G_GaussianCMEllipticCurve_MissingCMAction**: the CM action
(x, y) ↦ (-x, iy) is not constructed. -/
def L4_G_GaussianCMEllipticCurve_MissingCMAction : Prop := True

/-- **L4-G_GaussianCMEllipticCurve_MissingJInvariant1728**: j=1728
not proved (requires Mathlib `WeierstrassCurve.j` and computation). -/
def L4_G_GaussianCMEllipticCurve_MissingJInvariant1728 : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R295 non-closure (1/5)**: does NOT prove CM. -/
theorem R295_does_not_prove_CM : True := trivial

/-- **R295 non-closure (2/5)**: does NOT construct End(E). -/
theorem R295_does_not_construct_End : True := trivial

/-- **R295 non-closure (3/5)**: does NOT construct End⁰(E). -/
theorem R295_does_not_construct_End0 : True := trivial

/-- **R295 non-closure (4/5)**: does NOT prove j = 1728 in this round. -/
theorem R295_does_not_prove_j_eq_1728 : True := trivial

/-- **R295 non-closure (5/5)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R295_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
