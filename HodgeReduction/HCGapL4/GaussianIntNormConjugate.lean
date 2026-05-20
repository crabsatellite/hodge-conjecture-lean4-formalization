/-
# HC Gap L4 — GaussianInt norm-conjugate identity (R327).

R327 audits Mathlib's `Zsqrtd` norm / star API and lands the exact
identity `z * star z = (norm z : GaussianInt)` for
`GaussianInt = Zsqrtd (-1)` in a downstream-usable form.

## What R327 (this file) provides (all kernel-pure)

* `gaussianIntNormInt : GaussianInt → ℤ` — the integer-valued norm,
  defined as `z.re * z.re + z.im * z.im` (i.e. `a² + b²` for `z = a + bi`).
* `gaussianIntNormInt_eq_zsqrtdNorm` — bridge: this coincides with
  Mathlib's `Zsqrtd.norm` for `d = -1`.
* `gaussianIntNormInt_nonneg` — non-negativity proved by `positivity`.
* `gaussianIntNormInt_eq_zero_iff` — vanishing iff `z = 0`, delegated to
  `Zsqrtd.norm_eq_zero_iff` (which requires `d < 0`).
* `gaussianInt_mul_star_eq_norm` — THE norm-conjugate identity:
  `z * star z = (gaussianIntNormInt z : GaussianInt)`.
  Built via Mathlib's `Zsqrtd.norm_eq_mul_conj`.
* `gaussianIntNormInt_pos_of_ne_zero` — strict positivity for nonzero `z`.
* `gaussianIntNormQ : GaussianInt → ℚ` — rational-valued norm.
* `gaussianIntNormQ_ne_zero_of_ne_zero` — ℚ-cast of nonzero norm is
  nonzero in ℚ, the form required by downstream invertibility arguments.
* `L4-G` markers and `R327` status / non-closure flags.

## What R327 does NOT do

* Does NOT construct invertibility of nonzero GaussianInt actions on
  `PointEndHomQ` (next round R328-R329; this file provides the
  algebraic identity feeding the inverse formula
  `α⁻¹ = (1/Nm(α)) · ᾱ`).
* Does NOT construct the algebraic `End⁰(E)` ring.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

## Strategic anchor

R327's norm-conjugate identity at the GaussianInt level is the FIRST
algebraic step toward proving nonzero GaussianInt actions are invertible
on `PointEndHomQ`. Concretely: a nonzero `α ∈ ℤ[i]` satisfies
`α · ᾱ = Nm(α) ∈ ℤ`, with `Nm(α) > 0`, so over the rationalized carrier
`PointEndHomQ` the action of `α` admits the inverse
`(1/Nm(α)) · ᾱ`-action. That invertibility is the algebraic obstruction
that R328-R329 must discharge to extend the GaussianInt action to a
`ℚ(i) = FractionRing GaussianInt` action on `PointEndHomQ`, which in
turn is the source-side `End⁰(E)`-action structure that
`canonicalE7ShimuraTor.mtCorrespondencePackage` (HC cone active field 3)
ultimately consumes. R327 is the algebraic kernel of that chain: a
single explicit equation in the commutative ring `GaussianInt`,
`z * star z = (Nm(z) : GaussianInt)`, plus the strict-positivity bound
`z ≠ 0 → Nm(z) > 0` (Mathlib `norm_eq_zero_iff` at `d = -1 < 0`), plus
the ℚ-cast non-vanishing required to take `1/Nm(α) ∈ ℚ` as a scalar in
the rationalized End-action. Every subsequent round in the R327-R332
chain reads back to this identity.

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure (markers/status only).
-/

import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.Tactic.Positivity

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: Mathlib API audit (used names listed in module docstring)

The Mathlib API consumed verbatim from `Mathlib.NumberTheory.Zsqrtd.Basic`:

* `Zsqrtd.re`, `Zsqrtd.im : Zsqrtd d → ℤ`            — components
* `Zsqrtd.ext_iff`, `Zsqrtd.ext`                      — extensionality
* `Zsqrtd.mul_re`, `Zsqrtd.mul_im`                    — multiplication
* `Zsqrtd.star_re`, `Zsqrtd.star_im`                  — conjugate
* `Zsqrtd.norm : Zsqrtd d → ℤ`                        — `z.re² - d·z.im²`
* `Zsqrtd.norm_def`                                   — defining equation
* `Zsqrtd.norm_eq_mul_conj`                           — `(norm z : ℤ√d) = z * star z`
* `Zsqrtd.norm_eq_zero_iff` (requires `d < 0`)        — `norm z = 0 ↔ z = 0`
* `Zsqrtd.norm_nonneg` (requires `d ≤ 0`)             — `0 ≤ norm z`
* `Zsqrtd.intCast_re`, `Zsqrtd.intCast_im`            — integer cast components

`GaussianInt = Zsqrtd (-1)` (abbrev), from
`Mathlib.NumberTheory.Zsqrtd.GaussianInt`. -/

/-! ## Section 2: integer-valued GaussianInt norm -/

/-- **R327** the GaussianInt norm as a non-negative integer.
For `z = a + b·i` (i.e. `⟨a, b⟩ : Zsqrtd (-1)`), this is `a² + b²`.

This is definitionally equal to Mathlib's `Zsqrtd.norm` specialised at
`d = -1`, since `Zsqrtd.norm z = z.re² - (-1)·z.im² = z.re² + z.im²`. -/
def gaussianIntNormInt (z : GaussianInt) : ℤ :=
  z.re * z.re + z.im * z.im

/-- **R327** bridge: `gaussianIntNormInt` coincides with Mathlib's
`Zsqrtd.norm` at `d = -1`. -/
theorem gaussianIntNormInt_eq_zsqrtdNorm (z : GaussianInt) :
    gaussianIntNormInt z = Zsqrtd.norm z := by
  unfold gaussianIntNormInt
  rw [Zsqrtd.norm_def]
  ring

/-- **R327** the norm is non-negative. -/
theorem gaussianIntNormInt_nonneg (z : GaussianInt) :
    0 ≤ gaussianIntNormInt z := by
  unfold gaussianIntNormInt
  exact add_nonneg (mul_self_nonneg z.re) (mul_self_nonneg z.im)

/-! ## Section 3: norm-vanishing characterization -/

/-- **R327** the GaussianInt norm vanishes iff the element is zero.

Delegated to Mathlib's `Zsqrtd.norm_eq_zero_iff` at `d = -1 < 0`. -/
theorem gaussianIntNormInt_eq_zero_iff (z : GaussianInt) :
    gaussianIntNormInt z = 0 ↔ z = 0 := by
  rw [gaussianIntNormInt_eq_zsqrtdNorm]
  exact Zsqrtd.norm_eq_zero_iff (by decide : (-1 : ℤ) < 0) z

/-! ## Section 4: norm-conjugate identity -/

/-- **R327** the norm-conjugate identity at the GaussianInt level:
`z * star z = (gaussianIntNormInt z : GaussianInt)`.

This is the algebraic kernel feeding the inverse formula
`α⁻¹ = (1/Nm(α)) · ᾱ` for nonzero `α ∈ ℤ[i]` acting on a rationalized
carrier (next round R328-R329).

Proof: delegate to Mathlib's `Zsqrtd.norm_eq_mul_conj`, rewriting via
the bridge to `gaussianIntNormInt`. -/
theorem gaussianInt_mul_star_eq_norm (z : GaussianInt) :
    z * star z = (gaussianIntNormInt z : GaussianInt) := by
  rw [gaussianIntNormInt_eq_zsqrtdNorm, ← Zsqrtd.norm_eq_mul_conj]

/-! ## Section 5: strict positivity for nonzero elements -/

/-- **R327** if `z ≠ 0`, then `gaussianIntNormInt z > 0`. -/
theorem gaussianIntNormInt_pos_of_ne_zero (z : GaussianInt)
    (hz : z ≠ 0) : 0 < gaussianIntNormInt z := by
  rcases lt_or_eq_of_le (gaussianIntNormInt_nonneg z) with h | h
  · exact h
  · exfalso
    apply hz
    exact (gaussianIntNormInt_eq_zero_iff z).mp h.symm

/-! ## Section 6: ℚ-cast non-vanishing -/

/-- **R327** the GaussianInt norm as a rational, the form needed when
the inverse `1/Nm(α)` lives in ℚ (i.e. as a scalar in `PointEndHomQ`). -/
def gaussianIntNormQ (z : GaussianInt) : ℚ :=
  (gaussianIntNormInt z : ℚ)

/-- **R327** the ℚ-cast of the norm is nonzero whenever `z ≠ 0`.

This is the form consumed by R328-R329 when constructing the
`(1/Nm(α)) · ᾱ` inverse action on `PointEndHomQ`: one needs
`(Nm α : ℚ) ≠ 0` to take its reciprocal in ℚ. -/
theorem gaussianIntNormQ_ne_zero_of_ne_zero (z : GaussianInt)
    (hz : z ≠ 0) : gaussianIntNormQ z ≠ 0 := by
  unfold gaussianIntNormQ
  have hpos : 0 < gaussianIntNormInt z :=
    gaussianIntNormInt_pos_of_ne_zero z hz
  exact_mod_cast hpos.ne'

/-! ## Section 7: status / markers / non-closure flags -/

/-- **R327** marker: forward edge to PointEndHomQ invertibility (R328-R329). -/
def L4_G_GaussianIntNormConjugate_To_PointEndHomQ_Invertibility : Prop := True

/-- **R327** marker: forward edge to GaussianField action extension. -/
def L4_G_GaussianIntNormConjugate_To_GaussianFieldAction : Prop := True

/-- **R327** marker: forward edge to `mtCorrespondencePackage` (HC cone active field 3). -/
def L4_G_GaussianIntNormConjugate_To_mtCorrespondencePackage : Prop := True

/-- **R327** status: integer-valued norm defined. -/
def R327_Status_Norm_Defined : Prop := True

/-- **R327** status: `z * star z = (norm z : GaussianInt)` closed. -/
def R327_Status_Mul_Star_Eq_Norm_Closed : Prop := True

/-- **R327** status: strict positivity of norm for nonzero element closed. -/
def R327_Status_Nonzero_Norm_Closed : Prop := True

/-- **R327** status: ℚ-cast of nonzero norm is nonzero closed. -/
def R327_Status_QCast_Nonzero_Closed : Prop := True

/-- **R327** does NOT construct GaussianInt action invertibility on `PointEndHomQ`. -/
theorem R327_does_not_construct_action_invertibility : True := trivial

/-- **R327** does NOT construct the algebraic `End⁰(E)` ring. -/
theorem R327_does_not_construct_End0 : True := trivial

/-- **R327** does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R327_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
