/-
# HC Gap L4 — Gaussian field action on internal H² via norm (R346).

R345 built the internal H¹ action `ℚ(i) → End_ℚ(ℚ × ℚ)` via the
2×2-matrix model `(a + bi) • (v₁, v₂) = (a*v₁ - b*v₂, b*v₁ + a*v₂)`.
R346 builds the corresponding H² action.

## Mathematics

For an elliptic curve E with CM by ℚ(i), the action of `α ∈ ℚ(i)` on
`H²(E, ℚ) ≅ ℚ` is by *multiplication by the norm* `Nm(α) = α · ᾱ ∈ ℚ`.
This is the determinant of the H¹ action (2×2 matrix has determinant
`a² + b² = Nm(α)`).

Key structural facts:
* `Nm` is multiplicative: `Nm(αβ) = Nm(α) · Nm(β)`.
* `Nm` is NOT additive in general — so the H² action is a *multiplicative*
  action, not a `ℚ(i)`-algebra action.
* `Nm(1) = 1`, `Nm(0) = 0`.
* `Nm(α) > 0` for nonzero α (the positivity used in R327).

## What R346 provides (kernel-pure)

* `GaussianFieldPair_norm` — the norm `(a, b) ↦ a² + b²` (lifted from R327).
* `GaussianFieldPair_to_H2_scalar` — the H² action as ℚ-multiplication
  by the norm.
* `GaussianFieldPair_norm_mul` — multiplicativity.
* `GaussianField_to_H2_scalar` — the field-level version.
* Internal-model-bridge disclosure markers.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianFieldActionOnInternalH1

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: pair-level norm -/

/-- **R346** the norm on `GaussianFieldPairCarrier`:
`Nm⟨a, b⟩ = a² + b²`. -/
def GaussianFieldPair_norm (z : GaussianFieldPairCarrier) : ℚ :=
  z.re * z.re + z.im * z.im

/-- **R346** norm preserves 1. -/
@[simp] theorem GaussianFieldPair_norm_one :
    GaussianFieldPair_norm 1 = 1 := by
  unfold GaussianFieldPair_norm
  show (1 : ℚ) * 1 + 0 * 0 = 1
  ring

/-- **R346** norm preserves 0. -/
@[simp] theorem GaussianFieldPair_norm_zero :
    GaussianFieldPair_norm 0 = 0 := by
  unfold GaussianFieldPair_norm
  show (0 : ℚ) * 0 + 0 * 0 = 0
  ring

/-- **R346** norm at pair_i: `Nm(i) = 1`. -/
@[simp] theorem GaussianFieldPair_norm_pair_i :
    GaussianFieldPair_norm GaussianFieldPair_i = 1 := by
  unfold GaussianFieldPair_norm
  show (0 : ℚ) * 0 + 1 * 1 = 1
  ring

/-- **R346** multiplicativity of the norm. Key calculation:
`Nm(zw) = (z.re*w.re - z.im*w.im)² + (z.re*w.im + z.im*w.re)²`
       `= z.re²*w.re² + z.im²*w.im² + z.re²*w.im² + z.im²*w.re²`
       `= (z.re² + z.im²)(w.re² + w.im²) = Nm(z) * Nm(w)`. -/
theorem GaussianFieldPair_norm_mul (z w : GaussianFieldPairCarrier) :
    GaussianFieldPair_norm (z * w)
      = GaussianFieldPair_norm z * GaussianFieldPair_norm w := by
  unfold GaussianFieldPair_norm
  show (z * w).re * (z * w).re + (z * w).im * (z * w).im
       = (z.re * z.re + z.im * z.im) * (w.re * w.re + w.im * w.im)
  rw [GaussianFieldPairCarrier.mul_re, GaussianFieldPairCarrier.mul_im]
  ring

/-! ## Section 2: pair-level H² action -/

/-- **R346** the pair-level H² action: `z • h = Nm(z) * h`. -/
noncomputable def GaussianFieldPair_to_H2_scalar
    (z : GaussianFieldPairCarrier) : ℚ →ₗ[ℚ] ℚ :=
  (GaussianFieldPair_norm z) • (LinearMap.id (R := ℚ) (M := ℚ))

@[simp] theorem GaussianFieldPair_to_H2_scalar_apply
    (z : GaussianFieldPairCarrier) (h : ℚ) :
    GaussianFieldPair_to_H2_scalar z h
      = GaussianFieldPair_norm z * h := by
  show (GaussianFieldPair_norm z) • (LinearMap.id (R := ℚ) (M := ℚ)) h
       = GaussianFieldPair_norm z * h
  simp

/-! ## Section 3: pair-level H² action preserves multiplication -/

/-- **R346** H² action: 1 acts as identity. -/
theorem GaussianFieldPair_to_H2_scalar_one :
    GaussianFieldPair_to_H2_scalar 1 = LinearMap.id := by
  unfold GaussianFieldPair_to_H2_scalar
  rw [GaussianFieldPair_norm_one]
  ext
  simp

/-- **R346** H² action: `(zw) • h = z • (w • h)`. This is the
multiplicative compatibility — the key structural fact. -/
theorem GaussianFieldPair_to_H2_scalar_mul (z w : GaussianFieldPairCarrier) :
    GaussianFieldPair_to_H2_scalar (z * w)
      = (GaussianFieldPair_to_H2_scalar z).comp
          (GaussianFieldPair_to_H2_scalar w) := by
  apply LinearMap.ext
  intro q
  show GaussianFieldPair_norm (z * w) * q
       = GaussianFieldPair_norm z * (GaussianFieldPair_norm w * q)
  rw [GaussianFieldPair_norm_mul]
  ring

/-! ## Section 4: field-level H² action via composition -/

/-- **R346** the field-level H² action `ℚ(i) → End_ℚ(ℚ)` via norm. -/
noncomputable def GaussianField_to_H2_scalar
    (z : GaussianRationalFieldCandidate) : ℚ →ₗ[ℚ] ℚ :=
  GaussianFieldPair_to_H2_scalar
    (GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair z)

/-- **R346** field-level: 1 acts as id. -/
theorem GaussianField_to_H2_scalar_one :
    GaussianField_to_H2_scalar 1 = LinearMap.id := by
  unfold GaussianField_to_H2_scalar
  rw [map_one]
  exact GaussianFieldPair_to_H2_scalar_one

/-- **R346** field-level multiplicativity. -/
theorem GaussianField_to_H2_scalar_mul (x y : GaussianRationalFieldCandidate) :
    GaussianField_to_H2_scalar (x * y)
      = (GaussianField_to_H2_scalar x).comp (GaussianField_to_H2_scalar y) := by
  unfold GaussianField_to_H2_scalar
  rw [map_mul]
  exact GaussianFieldPair_to_H2_scalar_mul _ _

/-! ## Section 5: status / markers / non-closure -/

/-- **R346 disclosure**: Mathlib has no usable H² functor for elliptic
curves at this level. R346 acts on the project's internal H² model
`ℚ` (1-dim ℚ-vector space, representing the fundamental class). -/
def L4_G_GaussianFieldActionOnInternalH2_InternalModel_NotRealH2 :
    Prop := True

/-- **R346 disclosure**: the H² action is *multiplicative* via the norm,
not *additive in z* (norm is not additive). It's a `MulAction`-like
structure, not a ℚ(i)-algebra action. -/
def L4_G_GaussianFieldActionOnInternalH2_Multiplicative_Not_Additive :
    Prop := True

/-- **L4-G** bridge to cohomology functor + Hodge structure. -/
def L4_G_GaussianFieldActionOnInternalH2_To_HodgeDecomp : Prop := True

/-- **L4-G** bridge to mtCorrespondencePackage. -/
def L4_G_GaussianFieldActionOnInternalH2_To_mtCorrespondencePackage :
    Prop := True

def R346_Status_Norm_Multiplicative_Closed : Prop := True
def R346_Status_PairLevel_H2_Action_Closed : Prop := True
def R346_Status_FieldLevel_H2_Action_Closed : Prop := True

theorem R346_does_not_prove_det_eq_norm_at_real_H1 : True := trivial
theorem R346_does_not_construct_real_H2_functor : True := trivial
theorem R346_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
