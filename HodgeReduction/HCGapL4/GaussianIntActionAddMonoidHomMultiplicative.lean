/-
# HC Gap L4 — Multiplicativity of the GaussianInt → PointEndHom
formula (R318).

R316 produced the `AddMonoidHom`-level layer:
`PointK`, `PointEndHom`, `pointEnd_id`, `pointEnd_comp`,
`pointEnd_zsmul`, `gaussianCM_phi`,
`gaussianCM_phi_comp_phi_apply` (the pointwise `φ² P = -P`), and
`gaussianCM_phi_comp_phi_eq_neg_id`.

R317 produced the affine-linear formula
`GaussianInt_to_PointEndHom_formula z := z.re • id + z.im • φ`
together with action on the basis (`1`, `i`), additivity, negation,
and zero of the formula.

R318 (this file) closes the multiplicative compatibility step:

    _formula (z * w) = _formula z ∘ _formula w

i.e. the formula respects multiplication of GaussianIntegers. This
is the final algebraic compatibility step needed before R319/R320
package the formula as a ring homomorphism `GaussianInt →+* ...`.

## Mathematical identity used

For `z = a + b i`, `w = c + d i` with `i² = -1`:

  z * w = (ac - bd) + (ad + bc) i     (Zsqrtd (-1) multiplication)
  action(z) ∘ action(w)
    = (a id + b φ) ∘ (c id + d φ)
    = ac (id ∘ id) + ad (id ∘ φ) + bc (φ ∘ id) + bd (φ ∘ φ)
    = ac id + ad φ + bc φ + bd (-id)             [φ² = -id]
    = (ac - bd) id + (ad + bc) φ
    = action(z * w)

## What this file provides (kernel-pure)

* `phi_zsmul` — `φ` is ℤ-linear: `φ (n • P) = n • φ P`.
* `phi_add` — `φ` is additive: `φ (P + Q) = φ P + φ Q`.
* `phi_eval` — `φ (a • P + b • φ P) = a • φ P + b • (-P)`.
* `GaussianInt_to_PointEndHom_formula_mul` — the main multiplicativity
  theorem: `_formula (z * w) = pointEnd_comp (_formula z) (_formula w)`.
* Status / bridge / non-closure markers.

All declarations are kernel-pure. No `axiom`, no `sorry`.
`:= True` is used ONLY for status / bridge / non-closure markers.
-/

import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomOps
import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomFormula
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.NumberTheory.Zsqrtd.Basic

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: helper lemmas — `φ` is `ℤ`-linear and additive -/

/-- **R318 helper** — `φ` is additive: `φ (P + Q) = φ P + φ Q`.
This is just the bundled `AddMonoidHom.map_add` for the underlying
`AddMonoidHom`. -/
theorem phi_add (P Q : PointK) :
    gaussianCM_phi (P + Q) = gaussianCM_phi P + gaussianCM_phi Q :=
  gaussianCM_phi.map_add P Q

/-- **R318 helper** — `φ` commutes with `ℤ`-scalar action:
`φ (n • P) = n • φ P`. This is the bundled `map_zsmul` fact for
`AddMonoidHom` between abelian groups. -/
theorem phi_zsmul (n : ℤ) (P : PointK) :
    gaussianCM_phi (n • P) = n • gaussianCM_phi P :=
  map_zsmul gaussianCM_phi n P

/-- **R318 helper** — `φ` evaluated at the linear combination
`a • P + b • (φ P)`:

    φ (a • P + b • (φ P)) = a • (φ P) + b • (-P)

using additivity + ℤ-linearity + the square law `φ² P = -P`. -/
theorem phi_eval (a b : ℤ) (P : PointK) :
    gaussianCM_phi (a • P + b • gaussianCM_phi P)
      = a • gaussianCM_phi P + b • (-P) := by
  rw [phi_add, phi_zsmul, phi_zsmul]
  -- goal: a • φ P + b • φ (φ P) = a • φ P + b • (-P)
  congr 1
  -- goal: b • φ (φ P) = b • (-P)
  congr 1
  -- goal: φ (φ P) = -P
  -- This is the pointwise `φ² P = -P` from R316.
  have h := gaussianCM_phi_comp_phi_apply P
  -- h : pointEnd_comp gaussianCM_phi gaussianCM_phi P = -P
  -- and `pointEnd_comp f g P = f (g P)` by `pointEnd_comp_apply`.
  rw [pointEnd_comp_apply] at h
  exact h

/-! ## Section 2: main theorem — multiplicativity of the formula -/

/-- **R318 main theorem** — the formula respects multiplication:

    _formula (z * w) = pointEnd_comp (_formula z) (_formula w)

Proof strategy: pointwise extensionality, expand both sides using
the `_apply` unfolding lemmas from R316/R317, apply the helper
`phi_eval` to simplify the `φ` of a linear combination on the RHS,
unfold `(z * w).re` and `(z * w).im` using `Zsqrtd.mul_re` and
`Zsqrtd.mul_im`, then close with `ring`-style arithmetic on the
integer-scaled basis `{P, φP, -P}`. -/
theorem GaussianInt_to_PointEndHom_formula_mul (z w : GaussianInt) :
    GaussianInt_to_PointEndHom_formula (z * w)
      = pointEnd_comp
          (GaussianInt_to_PointEndHom_formula z)
          (GaussianInt_to_PointEndHom_formula w) := by
  ext P
  -- Unfold both sides via `_apply` lemmas from R316/R317.
  rw [GaussianInt_to_PointEndHom_formula_apply,
      pointEnd_comp_apply,
      GaussianInt_to_PointEndHom_formula_apply,
      GaussianInt_to_PointEndHom_formula_apply]
  -- After these rewrites the LHS reads
  --   (z * w).re • pointEnd_id P + (z * w).im • gaussianCM_phi P
  -- and the RHS reads
  --   z.re • pointEnd_id (Qw) + z.im • gaussianCM_phi (Qw)
  -- where `Qw := w.re • pointEnd_id P + w.im • gaussianCM_phi P`.
  -- Unfold the `pointEnd_id` applications (they are `rfl`).
  simp only [pointEnd_id_apply]
  -- Now the goal is purely in terms of `P` and `gaussianCM_phi`:
  --   (z * w).re • P + (z * w).im • gaussianCM_phi P
  -- = z.re • (w.re • P + w.im • gaussianCM_phi P)
  --   + z.im • gaussianCM_phi (w.re • P + w.im • gaussianCM_phi P)
  -- Simplify the `φ` of the linear combination using `phi_eval`.
  rw [phi_eval]
  -- Now goal:
  --   (z * w).re • P + (z * w).im • φ P
  -- = z.re • (w.re • P + w.im • φ P)
  --   + z.im • (w.re • φ P + w.im • (-P))
  -- Unfold `(z * w).re` and `(z * w).im` for Zsqrtd (-1).
  -- `Zsqrtd.mul_re : (z * w).re = z.re * w.re + d * z.im * w.im`
  -- For `d = -1` this is `z.re * w.re + (-1) * z.im * w.im`.
  -- `Zsqrtd.mul_im : (z * w).im = z.re * w.im + z.im * w.re`.
  rw [Zsqrtd.mul_re, Zsqrtd.mul_im]
  -- After mul_re/mul_im we have integer combinations on the LHS.
  -- Use `module` (the integer-module normaliser) to close the
  -- ℤ-linear identity over the abelian group `PointK`. `module`
  -- distributes `smul` over `+`, combines `a • (b • X) = (a * b) • X`,
  -- and normalises `-1 •` and `+ 0` clutter automatically.
  module

/-! ## Section 3: status / bridge / non-closure markers -/

/-- **R318 status** — helper `phi_add` closed. -/
def R318_Status_Phi_Add_Closed : Prop := True

/-- **R318 status** — helper `phi_zsmul` closed. -/
def R318_Status_Phi_Zsmul_Closed : Prop := True

/-- **R318 status** — helper `phi_eval` closed. -/
def R318_Status_Phi_Eval_Closed : Prop := True

/-- **R318 status** — main theorem
`GaussianInt_to_PointEndHom_formula_mul` closed. -/
def R318_Status_Multiplicativity_Closed : Prop := True

/-- **R318 bridge** — from `_formula_add` (R317) + `_formula_mul`
(R318) + `_formula_one` (R317) + `_formula_zero` (R317), the formula
is a ring-homomorphism candidate; the explicit packaging as
`GaussianInt →+* ...` is the R319 target. -/
def L4_G_GaussianIntActionMultiplicative_To_RingHom : Prop := True

/-- **R318 bridge** — from the `GaussianInt →+* AddMonoid.End ...`
ring hom (when packaged in R319), bridge onward to algebraic
`End(E_K)` and `End⁰(E_K)` remains the R293/R294 Mathlib gap. -/
def L4_G_GaussianIntActionMultiplicative_To_End0 : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R318 non-closure (1/4)** — does NOT construct the
`GaussianInt →+* AddMonoid.End ...` ring homomorphism (that is R319). -/
theorem R318_does_not_construct_ringHom : True := trivial

/-- **R318 non-closure (2/4)** — does NOT construct algebraic
`End(E_K)`. -/
theorem R318_does_not_construct_algebraic_End : True := trivial

/-- **R318 non-closure (3/4)** — does NOT construct `End⁰(E_K)`. -/
theorem R318_does_not_construct_End0 : True := trivial

/-- **R318 non-closure (4/4)** — does NOT close
`canonicalE7ShimuraTor`. -/
theorem R318_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
