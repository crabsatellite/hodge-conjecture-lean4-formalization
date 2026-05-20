/-
# HC Gap L4 — GaussianInt → PointEndHom formula (R317).

R316 unbundled `gaussianCMAction_GroupEndCandidate : AddMonoid.End E_K.toAffine.Point`
into a working layer (`PointK`, `PointEndHom`, `pointEnd_id`,
`pointEnd_zero`, `pointEnd_add`, `pointEnd_neg`, `pointEnd_comp`,
`pointEnd_zsmul`, `gaussianCM_phi`) with all pointwise `_apply`
lemmas (`rfl`-true). R317 builds the affine-linear formula

    z = a + b·i  ↦  a • id + b • φ

on top of R316 and proves its action on the basis elements
`1, i` plus the additive-group laws (`+`, `0`, `-`).

This is the Z-linear half of the GaussianInt ring action. The
multiplicative compatibility (`φ² = -id` lifted to the formula
level) is intentionally NOT closed here — see R317 status markers
and the dependency-map disclosures.

## What this file provides (kernel-pure)

* `gaussianIntI_R317 : GaussianInt` — the imaginary-unit element
  `(0, 1) ∈ Zsqrtd (-1)` via `Zsqrtd.sqrtd`.
* `GaussianInt_to_PointEndHom_formula z := (z.re • id) + (z.im • φ)`.
* Action on basis: `_formula 1 = id`, `_formula i = φ`.
* Additivity / negation / zero of the formula.
* Status and bridge markers + non-closure disclosures for the
  multiplicative side and the End⁰ chain.

All declarations are kernel-pure. No `axiom`, no `sorry`.
`:= True` is used ONLY for status / bridge / non-closure markers.
-/

import HodgeReduction.HCGapL4.GaussianIntActionAddMonoidHomOps
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.NumberTheory.Zsqrtd.Basic

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: the imaginary-unit element of `GaussianInt` -/

/-- **R317** — the imaginary unit `i ∈ GaussianInt = Zsqrtd (-1)`,
defined as `Zsqrtd.sqrtd : Zsqrtd (-1)`, i.e. the pair `(0, 1)`. -/
noncomputable def gaussianIntI_R317 : GaussianInt := Zsqrtd.sqrtd

/-- **R317** — real part of `i` is `0`. -/
@[simp] theorem gaussianIntI_R317_re : gaussianIntI_R317.re = 0 := rfl

/-- **R317** — imaginary part of `i` is `1`. -/
@[simp] theorem gaussianIntI_R317_im : gaussianIntI_R317.im = 1 := rfl

/-! ## Section 2: the affine-linear formula -/

/-- **R317** — the GaussianInt → PointEndHom formula:

    z = a + b·i  ↦  a • id + b • φ

Built from `pointEnd_add`, `pointEnd_zsmul`, `pointEnd_id`, and
`gaussianCM_phi` (all from R316). -/
noncomputable def GaussianInt_to_PointEndHom_formula (z : GaussianInt) :
    PointEndHom :=
  pointEnd_add
    (pointEnd_zsmul z.re pointEnd_id)
    (pointEnd_zsmul z.im gaussianCM_phi)

/-- **R317** — pointwise application of the formula. -/
theorem GaussianInt_to_PointEndHom_formula_apply
    (z : GaussianInt) (P : PointK) :
    GaussianInt_to_PointEndHom_formula z P
      = z.re • pointEnd_id P + z.im • gaussianCM_phi P := by
  show pointEnd_add
        (pointEnd_zsmul z.re pointEnd_id)
        (pointEnd_zsmul z.im gaussianCM_phi) P
      = z.re • pointEnd_id P + z.im • gaussianCM_phi P
  rw [pointEnd_add_apply, pointEnd_zsmul_apply, pointEnd_zsmul_apply]

/-! ## Section 3: action on basis elements `1` and `i` -/

/-- **R317** — action on the multiplicative unit `1 ∈ GaussianInt`:
`_formula 1 = id`. -/
theorem GaussianInt_to_PointEndHom_formula_one :
    GaussianInt_to_PointEndHom_formula 1 = pointEnd_id := by
  ext P
  rw [GaussianInt_to_PointEndHom_formula_apply]
  show ((1 : GaussianInt).re : ℤ) • pointEnd_id P
       + ((1 : GaussianInt).im : ℤ) • gaussianCM_phi P
       = pointEnd_id P
  simp

/-- **R317** — action on `i ∈ GaussianInt`: `_formula i = φ`. -/
theorem GaussianInt_to_PointEndHom_formula_i :
    GaussianInt_to_PointEndHom_formula gaussianIntI_R317 = gaussianCM_phi := by
  ext P
  rw [GaussianInt_to_PointEndHom_formula_apply]
  show (gaussianIntI_R317.re : ℤ) • pointEnd_id P
       + (gaussianIntI_R317.im : ℤ) • gaussianCM_phi P
       = gaussianCM_phi P
  simp

/-! ## Section 4: additivity / negation / zero of the formula -/

/-- **R317** — additivity of the formula:
`_formula (z + w) = _formula z + _formula w`. -/
theorem GaussianInt_to_PointEndHom_formula_add (z w : GaussianInt) :
    GaussianInt_to_PointEndHom_formula (z + w)
      = pointEnd_add
          (GaussianInt_to_PointEndHom_formula z)
          (GaussianInt_to_PointEndHom_formula w) := by
  ext P
  rw [pointEnd_add_apply, GaussianInt_to_PointEndHom_formula_apply,
      GaussianInt_to_PointEndHom_formula_apply,
      GaussianInt_to_PointEndHom_formula_apply]
  show ((z + w).re : ℤ) • pointEnd_id P + ((z + w).im : ℤ) • gaussianCM_phi P
       = (z.re • pointEnd_id P + z.im • gaussianCM_phi P)
         + (w.re • pointEnd_id P + w.im • gaussianCM_phi P)
  rw [Zsqrtd.add_re, Zsqrtd.add_im, add_zsmul, add_zsmul]
  abel

/-- **R317** — negation of the formula:
`_formula (-z) = - _formula z`. -/
theorem GaussianInt_to_PointEndHom_formula_neg (z : GaussianInt) :
    GaussianInt_to_PointEndHom_formula (-z)
      = pointEnd_neg (GaussianInt_to_PointEndHom_formula z) := by
  ext P
  rw [pointEnd_neg_apply, GaussianInt_to_PointEndHom_formula_apply,
      GaussianInt_to_PointEndHom_formula_apply]
  show ((-z).re : ℤ) • pointEnd_id P + ((-z).im : ℤ) • gaussianCM_phi P
       = -(z.re • pointEnd_id P + z.im • gaussianCM_phi P)
  rw [Zsqrtd.neg_re, Zsqrtd.neg_im]
  simp [neg_smul]
  abel

/-- **R317** — zero of the formula:
`_formula 0 = 0` (the zero endomorphism). -/
theorem GaussianInt_to_PointEndHom_formula_zero :
    GaussianInt_to_PointEndHom_formula 0 = pointEnd_zero := by
  ext P
  rw [GaussianInt_to_PointEndHom_formula_apply, pointEnd_zero_apply]
  show ((0 : GaussianInt).re : ℤ) • pointEnd_id P
       + ((0 : GaussianInt).im : ℤ) • gaussianCM_phi P
       = 0
  simp

/-! ## Section 5: status / bridge / non-closure markers -/

/-- **R317 bridge** — formula `(a, b) ↦ a•id + b•φ` is well-defined
as a `PointEndHom` and respects the additive-group laws on
`GaussianInt`. (See `_one`, `_i`, `_add`, `_neg`, `_zero` above.) -/
def L4_G_GaussianIntActionFormula_To_AdditiveAction : Prop := True

/-- **R317 bridge / non-closure** — multiplicative compatibility
(`_formula (z * w) = _formula z ∘ _formula w`) is NOT closed in R317.
That step requires `φ ∘ φ = -id` lifted to `PointEndHom`
(pointwise version is R308 / R316). -/
def L4_G_GaussianIntActionFormula_To_MultiplicativeCompatibility : Prop := True

/-- **R317 status** — formula `GaussianInt_to_PointEndHom_formula`
defined. -/
def R317_Status_Formula_Defined : Prop := True

/-- **R317 status** — basis case `_formula 1 = id` closed. -/
def R317_Status_Basis_One_Closed : Prop := True

/-- **R317 status** — basis case `_formula i = φ` closed. -/
def R317_Status_Basis_I_Closed : Prop := True

/-- **R317 status** — additivity `_formula (z + w) = _formula z + _formula w`
closed. -/
def R317_Status_Add_Closed : Prop := True

/-- **R317 status** — negation `_formula (-z) = - _formula z` closed. -/
def R317_Status_Neg_Closed : Prop := True

/-- **R317 status** — zero `_formula 0 = 0` closed. -/
def R317_Status_Zero_Closed : Prop := True

/-! ## Section 6: explicit non-closure disclosures -/

/-- **R317** does NOT prove multiplicative compatibility of the
formula. -/
theorem R317_does_not_prove_mul : True := trivial

/-- **R317** does NOT construct the GaussianInt → PointEndHom
ring homomorphism. -/
theorem R317_does_not_construct_ringHom : True := trivial

/-- **R317** does NOT construct algebraic `End(E_K)` or `End⁰(E_K)`. -/
theorem R317_does_not_construct_End0 : True := trivial

/-- **R317** does NOT close the `canonicalE7ShimuraTor` target. -/
theorem R317_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
