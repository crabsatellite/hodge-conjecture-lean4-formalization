/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.JordanJ3O

/-!
# Jordan multiplication on `J₃(𝕆)`

This file equips `J₃(𝕆)` with its canonical Jordan product
```
   X ∘ Y := (X · Y + Y · X) / 2
```
where `X · Y` denotes Hermitian-3×3-over-octonions matrix multiplication
(intrinsically non-Hermitian for general Hermitian inputs; the
symmetrization recovers a Hermitian matrix, hence a `J₃(𝕆)` element).

## Component formulas

For `X = (ξ₁, ξ₂, ξ₃, x₁, x₂, x₃)` and `Y = (η₁, η₂, η₃, y₁, y₂, y₃)`:

Diagonals:
* `(X ∘ Y).ξ₁ = ξ₁·η₁ + Re(x₂ · ȳ₂) + Re(x₃ · ȳ₃)`
* `(X ∘ Y).ξ₂ = ξ₂·η₂ + Re(x₃ · ȳ₃) + Re(x₁ · ȳ₁)`
* `(X ∘ Y).ξ₃ = ξ₃·η₃ + Re(x₁ · ȳ₁) + Re(x₂ · ȳ₂)`

(So `tr(X ∘ Y) = Σξ_i·η_i + 2·Σ Re(x_i · ȳ_i) = ⟨X, Y⟩` — the trace
of the Jordan product equals the standard inner product `⟨·,·⟩`.)

Off-diagonals: more involved (octonion products + scalar terms).

## Main definitions

* `J3O.jordanMul X Y` — the Jordan product `X ∘ Y`.

## Main theorems

* `J3O.jordanMul_comm` — `X ∘ Y = Y ∘ X`.
* `J3O.jordanMul_zero` — `X ∘ 0 = 0`.
* `J3O.zero_jordanMul` — `0 ∘ X = 0`.
* `J3O.jordanMul_one` — `X ∘ 1 = X` (the identity matrix is a Jordan unit).
* `J3O.one_jordanMul` — `1 ∘ X = X`.

## Tags

exceptional Jordan algebra, Jordan product, J_3(O)
-/

namespace HodgeReduction.Infrastructure

namespace J3O

open OctonionQ (conj re)

/-- **Jordan product** `X ∘ Y := (X · Y + Y · X) / 2` on `J₃(𝕆)`. -/
def jordanMul (X Y : J3O) : J3O where
  xi1 := X.xi1 * Y.xi1
    + OctonionQ.re (X.x2 * conj Y.x2)
    + OctonionQ.re (X.x3 * conj Y.x3)
  xi2 := X.xi2 * Y.xi2
    + OctonionQ.re (X.x3 * conj Y.x3)
    + OctonionQ.re (X.x1 * conj Y.x1)
  xi3 := X.xi3 * Y.xi3
    + OctonionQ.re (X.x1 * conj Y.x1)
    + OctonionQ.re (X.x2 * conj Y.x2)
  x1 := ((X.xi2 + X.xi3) / 2) • Y.x1 + ((Y.xi2 + Y.xi3) / 2) • X.x1
    + (1 / 2 : ℚ) • conj (X.x2 * Y.x3 + Y.x2 * X.x3)
  x2 := ((X.xi3 + X.xi1) / 2) • Y.x2 + ((Y.xi3 + Y.xi1) / 2) • X.x2
    + (1 / 2 : ℚ) • conj (X.x3 * Y.x1 + Y.x3 * X.x1)
  x3 := ((X.xi1 + X.xi2) / 2) • Y.x3 + ((Y.xi1 + Y.xi2) / 2) • X.x3
    + (1 / 2 : ℚ) • conj (X.x1 * Y.x2 + Y.x1 * X.x2)

/-! ### Commutativity -/

/-- Helper: `Re(x · conj y) = Re(y · conj x)` (symmetry of octonion inner product). -/
private theorem re_mul_conj_symm (x y : OctonionQ) :
    OctonionQ.re (x * conj y) = OctonionQ.re (y * conj x) := by
  show (x * conj y).e0 = (y * conj x).e0
  simp [OctonionQ.conj]; ring

theorem jordanMul_comm (X Y : J3O) : jordanMul X Y = jordanMul Y X := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · -- xi1
    show X.xi1 * Y.xi1 + OctonionQ.re (X.x2 * conj Y.x2) + OctonionQ.re (X.x3 * conj Y.x3)
       = Y.xi1 * X.xi1 + OctonionQ.re (Y.x2 * conj X.x2) + OctonionQ.re (Y.x3 * conj X.x3)
    rw [re_mul_conj_symm X.x2 Y.x2, re_mul_conj_symm X.x3 Y.x3]; ring
  · show X.xi2 * Y.xi2 + OctonionQ.re (X.x3 * conj Y.x3) + OctonionQ.re (X.x1 * conj Y.x1)
       = Y.xi2 * X.xi2 + OctonionQ.re (Y.x3 * conj X.x3) + OctonionQ.re (Y.x1 * conj X.x1)
    rw [re_mul_conj_symm X.x3 Y.x3, re_mul_conj_symm X.x1 Y.x1]; ring
  · show X.xi3 * Y.xi3 + OctonionQ.re (X.x1 * conj Y.x1) + OctonionQ.re (X.x2 * conj Y.x2)
       = Y.xi3 * X.xi3 + OctonionQ.re (Y.x1 * conj X.x1) + OctonionQ.re (Y.x2 * conj X.x2)
    rw [re_mul_conj_symm X.x1 Y.x1, re_mul_conj_symm X.x2 Y.x2]; ring
  · -- x1: A + B + C = B + A + C (octonion AddCommGroup)
    show ((X.xi2 + X.xi3) / 2) • Y.x1 + ((Y.xi2 + Y.xi3) / 2) • X.x1
       + (1 / 2 : ℚ) • conj (X.x2 * Y.x3 + Y.x2 * X.x3)
       = ((Y.xi2 + Y.xi3) / 2) • X.x1 + ((X.xi2 + X.xi3) / 2) • Y.x1
       + (1 / 2 : ℚ) • conj (Y.x2 * X.x3 + X.x2 * Y.x3)
    rw [show X.x2 * Y.x3 + Y.x2 * X.x3 = Y.x2 * X.x3 + X.x2 * Y.x3 from add_comm _ _,
        add_comm (((X.xi2 + X.xi3) / 2) • Y.x1) (((Y.xi2 + Y.xi3) / 2) • X.x1)]
  · show ((X.xi3 + X.xi1) / 2) • Y.x2 + ((Y.xi3 + Y.xi1) / 2) • X.x2
       + (1 / 2 : ℚ) • conj (X.x3 * Y.x1 + Y.x3 * X.x1)
       = ((Y.xi3 + Y.xi1) / 2) • X.x2 + ((X.xi3 + X.xi1) / 2) • Y.x2
       + (1 / 2 : ℚ) • conj (Y.x3 * X.x1 + X.x3 * Y.x1)
    rw [show X.x3 * Y.x1 + Y.x3 * X.x1 = Y.x3 * X.x1 + X.x3 * Y.x1 from add_comm _ _,
        add_comm (((X.xi3 + X.xi1) / 2) • Y.x2) (((Y.xi3 + Y.xi1) / 2) • X.x2)]
  · show ((X.xi1 + X.xi2) / 2) • Y.x3 + ((Y.xi1 + Y.xi2) / 2) • X.x3
       + (1 / 2 : ℚ) • conj (X.x1 * Y.x2 + Y.x1 * X.x2)
       = ((Y.xi1 + Y.xi2) / 2) • X.x3 + ((X.xi1 + X.xi2) / 2) • Y.x3
       + (1 / 2 : ℚ) • conj (Y.x1 * X.x2 + X.x1 * Y.x2)
    rw [show X.x1 * Y.x2 + Y.x1 * X.x2 = Y.x1 * X.x2 + X.x1 * Y.x2 from add_comm _ _,
        add_comm (((X.xi1 + X.xi2) / 2) • Y.x3) (((Y.xi1 + Y.xi2) / 2) • X.x3)]

/-! ### Zero and identity -/

@[simp] theorem jordanMul_zero (X : J3O) : jordanMul X 0 = 0 := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · show X.xi1 * 0 + OctonionQ.re (X.x2 * conj 0) + OctonionQ.re (X.x3 * conj 0) = 0
    simp [OctonionQ.re]
  · show X.xi2 * 0 + OctonionQ.re (X.x3 * conj 0) + OctonionQ.re (X.x1 * conj 0) = 0
    simp [OctonionQ.re]
  · show X.xi3 * 0 + OctonionQ.re (X.x1 * conj 0) + OctonionQ.re (X.x2 * conj 0) = 0
    simp [OctonionQ.re]
  · show ((X.xi2 + X.xi3) / 2) • (0 : OctonionQ)
       + (((0 : J3O).xi2 + (0 : J3O).xi3) / 2) • X.x1
       + (1 / 2 : ℚ) • conj (X.x2 * (0 : OctonionQ) + (0 : OctonionQ) * X.x3) = 0
    ext <;> simp [OctonionQ.conj]
  · show ((X.xi3 + X.xi1) / 2) • (0 : OctonionQ)
       + (((0 : J3O).xi3 + (0 : J3O).xi1) / 2) • X.x2
       + (1 / 2 : ℚ) • conj (X.x3 * (0 : OctonionQ) + (0 : OctonionQ) * X.x1) = 0
    ext <;> simp [OctonionQ.conj]
  · show ((X.xi1 + X.xi2) / 2) • (0 : OctonionQ)
       + (((0 : J3O).xi1 + (0 : J3O).xi2) / 2) • X.x3
       + (1 / 2 : ℚ) • conj (X.x1 * (0 : OctonionQ) + (0 : OctonionQ) * X.x2) = 0
    ext <;> simp [OctonionQ.conj]

@[simp] theorem zero_jordanMul (X : J3O) : jordanMul 0 X = 0 := by
  rw [jordanMul_comm]; exact jordanMul_zero X

/-! ### Jordan unit: `1 ∘ X = X` -/

@[simp] theorem one_jordanMul (X : J3O) : jordanMul 1 X = X := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · -- (1:J3O).xi1 = 1, (1:J3O).x_i = 0. Re(0*conj _) = 0. So xi1 = 1*X.xi1 = X.xi1.
    show (1 : ℚ) * X.xi1 + OctonionQ.re ((0 : OctonionQ) * conj X.x2)
         + OctonionQ.re ((0 : OctonionQ) * conj X.x3) = X.xi1
    simp [OctonionQ.re]
  · show (1 : ℚ) * X.xi2 + OctonionQ.re ((0 : OctonionQ) * conj X.x3)
         + OctonionQ.re ((0 : OctonionQ) * conj X.x1) = X.xi2
    simp [OctonionQ.re]
  · show (1 : ℚ) * X.xi3 + OctonionQ.re ((0 : OctonionQ) * conj X.x1)
         + OctonionQ.re ((0 : OctonionQ) * conj X.x2) = X.xi3
    simp [OctonionQ.re]
  · -- (1 ∘ X).x1 = ((1+1)/2) • X.x1 + ((X.xi2+X.xi3)/2) • 0 + (1/2) • conj(0*X.x3 + X.x2*0)
    --             = 1 • X.x1 + 0 + 0 = X.x1
    show (((1 : ℚ) + 1) / 2) • X.x1
       + ((X.xi2 + X.xi3) / 2) • (0 : OctonionQ)
       + (1 / 2 : ℚ) • conj ((0 : OctonionQ) * X.x3 + X.x2 * (0 : OctonionQ)) = X.x1
    ext <;> simp [OctonionQ.conj] <;> ring
  · show (((1 : ℚ) + 1) / 2) • X.x2
       + ((X.xi3 + X.xi1) / 2) • (0 : OctonionQ)
       + (1 / 2 : ℚ) • conj ((0 : OctonionQ) * X.x1 + X.x3 * (0 : OctonionQ)) = X.x2
    ext <;> simp [OctonionQ.conj] <;> ring
  · show (((1 : ℚ) + 1) / 2) • X.x3
       + ((X.xi1 + X.xi2) / 2) • (0 : OctonionQ)
       + (1 / 2 : ℚ) • conj ((0 : OctonionQ) * X.x2 + X.x1 * (0 : OctonionQ)) = X.x3
    ext <;> simp [OctonionQ.conj] <;> ring

@[simp] theorem jordanMul_one (X : J3O) : jordanMul X 1 = X := by
  rw [jordanMul_comm]; exact one_jordanMul X

end J3O

end HodgeReduction.Infrastructure
