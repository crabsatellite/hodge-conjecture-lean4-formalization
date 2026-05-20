/-
# HC Gap L4 — Gaussian CM elliptic curve base change to ℚ(i) (R300).

R299 closed `GaussianCMEllipticCurveTarget.IsElliptic` by direct
discriminant computation Δ = -64 ≠ 0. R298 next-target #2 was
"base change of the curve to `GaussianRationalFieldCandidate`".
R300 discharges it.

## Mathematics

Given E : `y² = x³ + x` over ℚ with `IsElliptic` (R299), Mathlib's
`WeierstrassCurve.baseChange` produces
`E_K : WeierstrassCurve GaussianRationalFieldCandidate` via the
canonical ring hom `algebraMap ℚ ℚ(i)`. The `IsElliptic` property
is auto-preserved by Mathlib's
`instance : (W.map φ).IsElliptic` (Weierstrass.lean:444).

## What R300 provides (all kernel-pure)

* `GaussianCMEllipticCurveTargetBaseChange` — the base-changed
  curve over ℚ(i).
* `GaussianCMEllipticCurveTargetBaseChange_IsElliptic` —
  IsElliptic preserved (Mathlib auto).
* `GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero` etc. —
  coefficient computations (a₁=a₂=a₃=a₆=0, a₄=1).
* Closure of R298 next-target #2.

All R300 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMEllipticCurveIsElliptic
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: base-changed curve -/

/-- **R300** the Gaussian CM elliptic curve `y² = x³ + x` base-changed
to `GaussianRationalFieldCandidate = ℚ(i)`. -/
noncomputable def GaussianCMEllipticCurveTargetBaseChange :
    WeierstrassCurve GaussianRationalFieldCandidate :=
  GaussianCMEllipticCurveTarget.baseChange GaussianRationalFieldCandidate

/-! ## Section 2: IsElliptic preserved -/

/-- **R300** the base-changed curve is elliptic (Mathlib auto via
`instance : (W.map φ).IsElliptic`). -/
instance GaussianCMEllipticCurveTargetBaseChange_IsElliptic :
    GaussianCMEllipticCurveTargetBaseChange.IsElliptic := by
  unfold GaussianCMEllipticCurveTargetBaseChange
  infer_instance

/-! ## Section 3: coefficient computations -/

/-- **R300** `a₁ = 0` after base change. -/
theorem GaussianCMEllipticCurveTargetBaseChange_a₁_eq_zero :
    GaussianCMEllipticCurveTargetBaseChange.a₁ = 0 := by
  simp [GaussianCMEllipticCurveTargetBaseChange,
        WeierstrassCurve.baseChange, WeierstrassCurve.map,
        GaussianCMEllipticCurveTarget]

/-- **R300** `a₂ = 0` after base change. -/
theorem GaussianCMEllipticCurveTargetBaseChange_a₂_eq_zero :
    GaussianCMEllipticCurveTargetBaseChange.a₂ = 0 := by
  simp [GaussianCMEllipticCurveTargetBaseChange,
        WeierstrassCurve.baseChange, WeierstrassCurve.map,
        GaussianCMEllipticCurveTarget]

/-- **R300** `a₃ = 0` after base change. -/
theorem GaussianCMEllipticCurveTargetBaseChange_a₃_eq_zero :
    GaussianCMEllipticCurveTargetBaseChange.a₃ = 0 := by
  simp [GaussianCMEllipticCurveTargetBaseChange,
        WeierstrassCurve.baseChange, WeierstrassCurve.map,
        GaussianCMEllipticCurveTarget]

/-- **R300** `a₄ = 1` after base change. -/
theorem GaussianCMEllipticCurveTargetBaseChange_a₄_eq_one :
    GaussianCMEllipticCurveTargetBaseChange.a₄ = 1 := by
  simp [GaussianCMEllipticCurveTargetBaseChange,
        WeierstrassCurve.baseChange, WeierstrassCurve.map,
        GaussianCMEllipticCurveTarget]

/-- **R300** `a₆ = 0` after base change. -/
theorem GaussianCMEllipticCurveTargetBaseChange_a₆_eq_zero :
    GaussianCMEllipticCurveTargetBaseChange.a₆ = 0 := by
  simp [GaussianCMEllipticCurveTargetBaseChange,
        WeierstrassCurve.baseChange, WeierstrassCurve.map,
        GaussianCMEllipticCurveTarget]

/-! ## Section 4: status / closure -/

/-- **R300 status**: base change closed. -/
def R300_Status_BaseChange_Closed : Prop := True

/-- **R300 status**: IsElliptic preserved after base change (Mathlib auto). -/
def R300_Status_BaseChange_IsElliptic_Preserved : Prop := True

/-- **R300 next**: construct the CM action
`(x, y) ↦ (-x, i*y)` on the base-changed curve. -/
def R300_Next_Construct_CMAction_i : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R300 non-closure (1/3)**: does NOT construct CM action. -/
theorem R300_does_not_construct_CM_action : True := trivial

/-- **R300 non-closure (2/3)**: does NOT prove CM action squares
to `[-1]`. -/
theorem R300_does_not_prove_CM_square : True := trivial

/-- **R300 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R300_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
