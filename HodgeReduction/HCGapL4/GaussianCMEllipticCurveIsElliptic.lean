/-
# HC Gap L4 — Gaussian CM elliptic curve `IsElliptic` proof (R299).

R295 defined `GaussianCMEllipticCurveTarget : WeierstrassCurve ℚ`
with `a₁=a₂=a₃=a₆=0, a₄=1`. R298 ranked
`GaussianCMEllipticCurveTarget.IsElliptic` as the smallest
constructible next step. R299 discharges it.

## Mathematics

For `y² = x³ + x` over ℚ:
* `b₂ = a₁² + 4·a₂ = 0`
* `b₄ = 2·a₄ + a₁·a₃ = 2`
* `b₆ = a₃² + 4·a₆ = 0`
* `b₈ = a₁²·a₆ + 4·a₂·a₆ - a₁·a₃·a₄ + a₂·a₃² - a₄² = -1`
* `Δ = -b₂²·b₈ - 8·b₄³ - 27·b₆² + 9·b₂·b₄·b₆`
     `= 0 - 8·8 - 0 + 0 = -64`

So `Δ = -64 ≠ 0` in ℚ. Since ℚ is a field, `-64` is a unit, so
`IsUnit Δ`, i.e. `IsElliptic`.

## What R299 provides (all kernel-pure)

* `GaussianCMEllipticCurveTarget_Δ_eq_neg_64`.
* `GaussianCMEllipticCurveTarget_Δ_ne_zero`.
* `GaussianCMEllipticCurveTarget_IsElliptic` instance.
* Closure of R295 `Target_GaussianCMEllipticCurveTarget_IsElliptic`.

All R299 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMEllipticCurveTarget

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: discriminant computation -/

/-- **R299** `b₂ = 0` for the Gaussian curve. -/
theorem GaussianCMEllipticCurveTarget_b₂_eq_zero :
    GaussianCMEllipticCurveTarget.b₂ = 0 := by
  simp [GaussianCMEllipticCurveTarget, WeierstrassCurve.b₂]

/-- **R299** `b₄ = 2` for the Gaussian curve. -/
theorem GaussianCMEllipticCurveTarget_b₄_eq_two :
    GaussianCMEllipticCurveTarget.b₄ = 2 := by
  simp [GaussianCMEllipticCurveTarget, WeierstrassCurve.b₄]

/-- **R299** `b₆ = 0` for the Gaussian curve. -/
theorem GaussianCMEllipticCurveTarget_b₆_eq_zero :
    GaussianCMEllipticCurveTarget.b₆ = 0 := by
  simp [GaussianCMEllipticCurveTarget, WeierstrassCurve.b₆]

/-- **R299** `b₈ = -1` for the Gaussian curve. -/
theorem GaussianCMEllipticCurveTarget_b₈_eq_neg_one :
    GaussianCMEllipticCurveTarget.b₈ = -1 := by
  simp [GaussianCMEllipticCurveTarget, WeierstrassCurve.b₈]

/-- **R299** `Δ = -64` for the Gaussian curve. -/
theorem GaussianCMEllipticCurveTarget_Δ_eq_neg_64 :
    GaussianCMEllipticCurveTarget.Δ = -64 := by
  simp [WeierstrassCurve.Δ, GaussianCMEllipticCurveTarget_b₂_eq_zero,
        GaussianCMEllipticCurveTarget_b₄_eq_two,
        GaussianCMEllipticCurveTarget_b₆_eq_zero,
        GaussianCMEllipticCurveTarget_b₈_eq_neg_one]
  norm_num

/-- **R299** `Δ ≠ 0` for the Gaussian curve. -/
theorem GaussianCMEllipticCurveTarget_Δ_ne_zero :
    GaussianCMEllipticCurveTarget.Δ ≠ 0 := by
  rw [GaussianCMEllipticCurveTarget_Δ_eq_neg_64]
  norm_num

/-! ## Section 2: IsElliptic instance -/

/-- **R299 main**: the Gaussian curve `y² = x³ + x` is an
elliptic curve over ℚ, via `Δ = -64 ≠ 0`. -/
instance GaussianCMEllipticCurveTarget_IsElliptic :
    GaussianCMEllipticCurveTarget.IsElliptic :=
  ⟨isUnit_iff_ne_zero.mpr GaussianCMEllipticCurveTarget_Δ_ne_zero⟩

/-! ## Section 3: closure of R295 target -/

/-- **R299** closure of R295's `Target_GaussianCMEllipticCurveTarget_IsElliptic`:
the IsElliptic target is now discharged. -/
theorem Target_GaussianCMEllipticCurveTarget_IsElliptic_closed :
    Target_GaussianCMEllipticCurveTarget_IsElliptic :=
  GaussianCMEllipticCurveTarget_IsElliptic

/-! ## Section 4: status -/

/-- **R299 status**: discriminant computed. -/
def R299_Status_Discriminant_Computed : Prop := True

/-- **R299 status**: IsElliptic class instance available. -/
def R299_Status_IsElliptic_Closed : Prop := True

/-- **R299 next**: base change of the curve to
`GaussianRationalFieldCandidate`. -/
def R299_Next_BaseChange_To_GaussianField : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R299 non-closure (1/3)**: does NOT base-change the curve. -/
theorem R299_does_not_base_change : True := trivial

/-- **R299 non-closure (2/3)**: does NOT construct CM action. -/
theorem R299_does_not_construct_CM_action : True := trivial

/-- **R299 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R299_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
