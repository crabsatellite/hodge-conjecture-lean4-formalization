/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.JordanJ3O
import HodgeReduction.Infrastructure.V56Freudenthal
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Abel
import Mathlib.LinearAlgebra.BilinearMap

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

set_option maxHeartbeats 1000000

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

/-! ### Distributivity and scalar compatibility -/

/-- **Right distributivity**: `(X + X') ∘ Y = X ∘ Y + X' ∘ Y`. -/
theorem add_jordanMul (X X' Y : J3O) :
    jordanMul (X + X') Y = jordanMul X Y + jordanMul X' Y := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · -- xi1 component: distributes via ℚ-addition + Re-additivity + octonion mult.
    show (X.xi1 + X'.xi1) * Y.xi1
       + OctonionQ.re ((X.x2 + X'.x2) * conj Y.x2)
       + OctonionQ.re ((X.x3 + X'.x3) * conj Y.x3)
       = X.xi1 * Y.xi1 + OctonionQ.re (X.x2 * conj Y.x2) + OctonionQ.re (X.x3 * conj Y.x3)
       + (X'.xi1 * Y.xi1 + OctonionQ.re (X'.x2 * conj Y.x2) + OctonionQ.re (X'.x3 * conj Y.x3))
    have h1 : OctonionQ.re ((X.x2 + X'.x2) * conj Y.x2)
            = OctonionQ.re (X.x2 * conj Y.x2) + OctonionQ.re (X'.x2 * conj Y.x2) := by
      show ((X.x2 + X'.x2) * conj Y.x2).e0
         = (X.x2 * conj Y.x2).e0 + (X'.x2 * conj Y.x2).e0
      simp; ring
    have h2 : OctonionQ.re ((X.x3 + X'.x3) * conj Y.x3)
            = OctonionQ.re (X.x3 * conj Y.x3) + OctonionQ.re (X'.x3 * conj Y.x3) := by
      show ((X.x3 + X'.x3) * conj Y.x3).e0
         = (X.x3 * conj Y.x3).e0 + (X'.x3 * conj Y.x3).e0
      simp; ring
    rw [h1, h2]; ring
  · show (X.xi2 + X'.xi2) * Y.xi2
       + OctonionQ.re ((X.x3 + X'.x3) * conj Y.x3)
       + OctonionQ.re ((X.x1 + X'.x1) * conj Y.x1)
       = X.xi2 * Y.xi2 + OctonionQ.re (X.x3 * conj Y.x3) + OctonionQ.re (X.x1 * conj Y.x1)
       + (X'.xi2 * Y.xi2 + OctonionQ.re (X'.x3 * conj Y.x3) + OctonionQ.re (X'.x1 * conj Y.x1))
    have h1 : OctonionQ.re ((X.x3 + X'.x3) * conj Y.x3)
            = OctonionQ.re (X.x3 * conj Y.x3) + OctonionQ.re (X'.x3 * conj Y.x3) := by
      show ((X.x3 + X'.x3) * conj Y.x3).e0
         = (X.x3 * conj Y.x3).e0 + (X'.x3 * conj Y.x3).e0
      simp; ring
    have h2 : OctonionQ.re ((X.x1 + X'.x1) * conj Y.x1)
            = OctonionQ.re (X.x1 * conj Y.x1) + OctonionQ.re (X'.x1 * conj Y.x1) := by
      show ((X.x1 + X'.x1) * conj Y.x1).e0
         = (X.x1 * conj Y.x1).e0 + (X'.x1 * conj Y.x1).e0
      simp; ring
    rw [h1, h2]; ring
  · show (X.xi3 + X'.xi3) * Y.xi3
       + OctonionQ.re ((X.x1 + X'.x1) * conj Y.x1)
       + OctonionQ.re ((X.x2 + X'.x2) * conj Y.x2)
       = X.xi3 * Y.xi3 + OctonionQ.re (X.x1 * conj Y.x1) + OctonionQ.re (X.x2 * conj Y.x2)
       + (X'.xi3 * Y.xi3 + OctonionQ.re (X'.x1 * conj Y.x1) + OctonionQ.re (X'.x2 * conj Y.x2))
    have h1 : OctonionQ.re ((X.x1 + X'.x1) * conj Y.x1)
            = OctonionQ.re (X.x1 * conj Y.x1) + OctonionQ.re (X'.x1 * conj Y.x1) := by
      show ((X.x1 + X'.x1) * conj Y.x1).e0
         = (X.x1 * conj Y.x1).e0 + (X'.x1 * conj Y.x1).e0
      simp; ring
    have h2 : OctonionQ.re ((X.x2 + X'.x2) * conj Y.x2)
            = OctonionQ.re (X.x2 * conj Y.x2) + OctonionQ.re (X'.x2 * conj Y.x2) := by
      show ((X.x2 + X'.x2) * conj Y.x2).e0
         = (X.x2 * conj Y.x2).e0 + (X'.x2 * conj Y.x2).e0
      simp; ring
    rw [h1, h2]; ring
  · -- x1 component
    show ((X.xi2 + X'.xi2 + (X.xi3 + X'.xi3)) / 2) • Y.x1
       + ((Y.xi2 + Y.xi3) / 2) • (X.x1 + X'.x1)
       + (1 / 2 : ℚ) • OctonionQ.conj ((X.x2 + X'.x2) * Y.x3 + Y.x2 * (X.x3 + X'.x3))
       = (((X.xi2 + X.xi3) / 2) • Y.x1 + ((Y.xi2 + Y.xi3) / 2) • X.x1
            + (1 / 2 : ℚ) • OctonionQ.conj (X.x2 * Y.x3 + Y.x2 * X.x3))
         + (((X'.xi2 + X'.xi3) / 2) • Y.x1 + ((Y.xi2 + Y.xi3) / 2) • X'.x1
            + (1 / 2 : ℚ) • OctonionQ.conj (X'.x2 * Y.x3 + Y.x2 * X'.x3))
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x2 component
    show ((X.xi3 + X'.xi3 + (X.xi1 + X'.xi1)) / 2) • Y.x2
       + ((Y.xi3 + Y.xi1) / 2) • (X.x2 + X'.x2)
       + (1 / 2 : ℚ) • OctonionQ.conj ((X.x3 + X'.x3) * Y.x1 + Y.x3 * (X.x1 + X'.x1))
       = (((X.xi3 + X.xi1) / 2) • Y.x2 + ((Y.xi3 + Y.xi1) / 2) • X.x2
            + (1 / 2 : ℚ) • OctonionQ.conj (X.x3 * Y.x1 + Y.x3 * X.x1))
         + (((X'.xi3 + X'.xi1) / 2) • Y.x2 + ((Y.xi3 + Y.xi1) / 2) • X'.x2
            + (1 / 2 : ℚ) • OctonionQ.conj (X'.x3 * Y.x1 + Y.x3 * X'.x1))
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x3 component
    show ((X.xi1 + X'.xi1 + (X.xi2 + X'.xi2)) / 2) • Y.x3
       + ((Y.xi1 + Y.xi2) / 2) • (X.x3 + X'.x3)
       + (1 / 2 : ℚ) • OctonionQ.conj ((X.x1 + X'.x1) * Y.x2 + Y.x1 * (X.x2 + X'.x2))
       = (((X.xi1 + X.xi2) / 2) • Y.x3 + ((Y.xi1 + Y.xi2) / 2) • X.x3
            + (1 / 2 : ℚ) • OctonionQ.conj (X.x1 * Y.x2 + Y.x1 * X.x2))
         + (((X'.xi1 + X'.xi2) / 2) • Y.x3 + ((Y.xi1 + Y.xi2) / 2) • X'.x3
            + (1 / 2 : ℚ) • OctonionQ.conj (X'.x1 * Y.x2 + Y.x1 * X'.x2))
    ext <;> simp [OctonionQ.conj] <;> ring

/-- **Left distributivity**: `X ∘ (Y + Y') = X ∘ Y + X ∘ Y'`. -/
theorem jordanMul_add (X Y Y' : J3O) :
    jordanMul X (Y + Y') = jordanMul X Y + jordanMul X Y' := by
  rw [jordanMul_comm, add_jordanMul]
  congr 1 <;> exact jordanMul_comm _ _

set_option maxHeartbeats 1000000 in
/-- **Right scalar compatibility**: `(r • X) ∘ Y = r • (X ∘ Y)`. -/
theorem smul_jordanMul (r : ℚ) (X Y : J3O) :
    jordanMul (r • X) Y = r • jordanMul X Y := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · show (r * X.xi1) * Y.xi1
       + OctonionQ.re ((r • X.x2) * conj Y.x2)
       + OctonionQ.re ((r • X.x3) * conj Y.x3)
       = r * (X.xi1 * Y.xi1 + OctonionQ.re (X.x2 * conj Y.x2) + OctonionQ.re (X.x3 * conj Y.x3))
    have h2 : OctonionQ.re ((r • X.x2) * conj Y.x2) = r * OctonionQ.re (X.x2 * conj Y.x2) := by
      show ((r • X.x2) * conj Y.x2).e0 = r * (X.x2 * conj Y.x2).e0
      simp; ring
    have h3 : OctonionQ.re ((r • X.x3) * conj Y.x3) = r * OctonionQ.re (X.x3 * conj Y.x3) := by
      show ((r • X.x3) * conj Y.x3).e0 = r * (X.x3 * conj Y.x3).e0
      simp; ring
    rw [h2, h3]; ring
  · show (r * X.xi2) * Y.xi2
       + OctonionQ.re ((r • X.x3) * conj Y.x3)
       + OctonionQ.re ((r • X.x1) * conj Y.x1)
       = r * (X.xi2 * Y.xi2 + OctonionQ.re (X.x3 * conj Y.x3) + OctonionQ.re (X.x1 * conj Y.x1))
    have h3 : OctonionQ.re ((r • X.x3) * conj Y.x3) = r * OctonionQ.re (X.x3 * conj Y.x3) := by
      show ((r • X.x3) * conj Y.x3).e0 = r * (X.x3 * conj Y.x3).e0
      simp; ring
    have h1 : OctonionQ.re ((r • X.x1) * conj Y.x1) = r * OctonionQ.re (X.x1 * conj Y.x1) := by
      show ((r • X.x1) * conj Y.x1).e0 = r * (X.x1 * conj Y.x1).e0
      simp; ring
    rw [h3, h1]; ring
  · show (r * X.xi3) * Y.xi3
       + OctonionQ.re ((r • X.x1) * conj Y.x1)
       + OctonionQ.re ((r • X.x2) * conj Y.x2)
       = r * (X.xi3 * Y.xi3 + OctonionQ.re (X.x1 * conj Y.x1) + OctonionQ.re (X.x2 * conj Y.x2))
    have h1 : OctonionQ.re ((r • X.x1) * conj Y.x1) = r * OctonionQ.re (X.x1 * conj Y.x1) := by
      show ((r • X.x1) * conj Y.x1).e0 = r * (X.x1 * conj Y.x1).e0
      simp; ring
    have h2 : OctonionQ.re ((r • X.x2) * conj Y.x2) = r * OctonionQ.re (X.x2 * conj Y.x2) := by
      show ((r • X.x2) * conj Y.x2).e0 = r * (X.x2 * conj Y.x2).e0
      simp; ring
    rw [h1, h2]; ring
  · -- x1 component: combine ℚ-linearity at OctonionQ level.
    show ((r * X.xi2 + r * X.xi3) / 2) • Y.x1 + ((Y.xi2 + Y.xi3) / 2) • (r • X.x1)
       + (1 / 2 : ℚ) • OctonionQ.conj ((r • X.x2) * Y.x3 + Y.x2 * (r • X.x3))
       = r • (((X.xi2 + X.xi3) / 2) • Y.x1 + ((Y.xi2 + Y.xi3) / 2) • X.x1
            + (1 / 2 : ℚ) • OctonionQ.conj (X.x2 * Y.x3 + Y.x2 * X.x3))
    have e1 : ((r * X.xi2 + r * X.xi3) / 2) • Y.x1
            = r • (((X.xi2 + X.xi3) / 2) • Y.x1) := by
      rw [OctonionQ.smul_smul]; congr 1; ring
    have e2 : ((Y.xi2 + Y.xi3) / 2) • (r • X.x1)
            = r • (((Y.xi2 + Y.xi3) / 2) • X.x1) := by
      rw [OctonionQ.smul_smul, OctonionQ.smul_smul]; congr 1; ring
    have e3 : (1 / 2 : ℚ) • OctonionQ.conj ((r • X.x2) * Y.x3 + Y.x2 * (r • X.x3))
            = r • ((1 / 2 : ℚ) • OctonionQ.conj (X.x2 * Y.x3 + Y.x2 * X.x3)) := by
      rw [OctonionQ.smul_mul, OctonionQ.mul_smul, ← OctonionQ.smul_add,
          OctonionQ.conj_smul, OctonionQ.smul_smul, OctonionQ.smul_smul]
      congr 1; ring
    rw [e1, e2, e3, ← OctonionQ.smul_add, ← OctonionQ.smul_add]
  · -- x2 component
    show ((r * X.xi3 + r * X.xi1) / 2) • Y.x2 + ((Y.xi3 + Y.xi1) / 2) • (r • X.x2)
       + (1 / 2 : ℚ) • OctonionQ.conj ((r • X.x3) * Y.x1 + Y.x3 * (r • X.x1))
       = r • (((X.xi3 + X.xi1) / 2) • Y.x2 + ((Y.xi3 + Y.xi1) / 2) • X.x2
            + (1 / 2 : ℚ) • OctonionQ.conj (X.x3 * Y.x1 + Y.x3 * X.x1))
    have e1 : ((r * X.xi3 + r * X.xi1) / 2) • Y.x2
            = r • (((X.xi3 + X.xi1) / 2) • Y.x2) := by
      rw [OctonionQ.smul_smul]; congr 1; ring
    have e2 : ((Y.xi3 + Y.xi1) / 2) • (r • X.x2)
            = r • (((Y.xi3 + Y.xi1) / 2) • X.x2) := by
      rw [OctonionQ.smul_smul, OctonionQ.smul_smul]; congr 1; ring
    have e3 : (1 / 2 : ℚ) • OctonionQ.conj ((r • X.x3) * Y.x1 + Y.x3 * (r • X.x1))
            = r • ((1 / 2 : ℚ) • OctonionQ.conj (X.x3 * Y.x1 + Y.x3 * X.x1)) := by
      rw [OctonionQ.smul_mul, OctonionQ.mul_smul, ← OctonionQ.smul_add,
          OctonionQ.conj_smul, OctonionQ.smul_smul, OctonionQ.smul_smul]
      congr 1; ring
    rw [e1, e2, e3, ← OctonionQ.smul_add, ← OctonionQ.smul_add]
  · -- x3 component
    show ((r * X.xi1 + r * X.xi2) / 2) • Y.x3 + ((Y.xi1 + Y.xi2) / 2) • (r • X.x3)
       + (1 / 2 : ℚ) • OctonionQ.conj ((r • X.x1) * Y.x2 + Y.x1 * (r • X.x2))
       = r • (((X.xi1 + X.xi2) / 2) • Y.x3 + ((Y.xi1 + Y.xi2) / 2) • X.x3
            + (1 / 2 : ℚ) • OctonionQ.conj (X.x1 * Y.x2 + Y.x1 * X.x2))
    have e1 : ((r * X.xi1 + r * X.xi2) / 2) • Y.x3
            = r • (((X.xi1 + X.xi2) / 2) • Y.x3) := by
      rw [OctonionQ.smul_smul]; congr 1; ring
    have e2 : ((Y.xi1 + Y.xi2) / 2) • (r • X.x3)
            = r • (((Y.xi1 + Y.xi2) / 2) • X.x3) := by
      rw [OctonionQ.smul_smul, OctonionQ.smul_smul]; congr 1; ring
    have e3 : (1 / 2 : ℚ) • OctonionQ.conj ((r • X.x1) * Y.x2 + Y.x1 * (r • X.x2))
            = r • ((1 / 2 : ℚ) • OctonionQ.conj (X.x1 * Y.x2 + Y.x1 * X.x2)) := by
      rw [OctonionQ.smul_mul, OctonionQ.mul_smul, ← OctonionQ.smul_add,
          OctonionQ.conj_smul, OctonionQ.smul_smul, OctonionQ.smul_smul]
      congr 1; ring
    rw [e1, e2, e3, ← OctonionQ.smul_add, ← OctonionQ.smul_add]

/-- **Left scalar compatibility**: `X ∘ (r • Y) = r • (X ∘ Y)`. -/
theorem jordanMul_smul (r : ℚ) (X Y : J3O) :
    jordanMul X (r • Y) = r • jordanMul X Y := by
  rw [jordanMul_comm, smul_jordanMul, jordanMul_comm Y X]

/-- **Negation right**: `X ∘ (-Y) = -(X ∘ Y)`. -/
theorem jordanMul_neg (X Y : J3O) :
    jordanMul X (-Y) = -jordanMul X Y := by
  rw [← neg_one_smul ℚ Y, jordanMul_smul, neg_one_smul]

/-- **Negation left**: `(-X) ∘ Y = -(X ∘ Y)`. -/
theorem neg_jordanMul (X Y : J3O) :
    jordanMul (-X) Y = -jordanMul X Y := by
  rw [jordanMul_comm, jordanMul_neg, jordanMul_comm]

/-- **Subtraction right**: `X ∘ (Y - Y') = X ∘ Y - X ∘ Y'`. -/
theorem jordanMul_sub (X Y Y' : J3O) :
    jordanMul X (Y - Y') = jordanMul X Y - jordanMul X Y' := by
  rw [sub_eq_add_neg, jordanMul_add, jordanMul_neg, sub_eq_add_neg]

/-- **Subtraction left**: `(X - X') ∘ Y = X ∘ Y - X' ∘ Y`. -/
theorem sub_jordanMul (X X' Y : J3O) :
    jordanMul (X - X') Y = jordanMul X Y - jordanMul X' Y := by
  rw [jordanMul_comm, jordanMul_sub, jordanMul_comm Y X, jordanMul_comm Y X']

end J3O

end HodgeReduction.Infrastructure

/-! ### Trace form: `tr(X ∘ Y) = ⟨X, Y⟩` -/

namespace HodgeReduction.Infrastructure
namespace J3O

open OctonionQ (conj re)

/-- The trace of the Jordan product equals the symmetric inner product:
`tr(X ∘ Y) = ⟨X, Y⟩`. -/
theorem trace_jordanMul (X Y : J3O) : trace (jordanMul X Y) = innerProd X Y := by
  unfold trace innerProd jordanMul
  dsimp
  show X.xi1 * Y.xi1 + OctonionQ.re (X.x2 * conj Y.x2) + OctonionQ.re (X.x3 * conj Y.x3)
     + (X.xi2 * Y.xi2 + OctonionQ.re (X.x3 * conj Y.x3) + OctonionQ.re (X.x1 * conj Y.x1))
     + (X.xi3 * Y.xi3 + OctonionQ.re (X.x1 * conj Y.x1) + OctonionQ.re (X.x2 * conj Y.x2))
     = X.xi1 * Y.xi1 + X.xi2 * Y.xi2 + X.xi3 * Y.xi3
       + 2 * OctonionQ.re (X.x1 * conj Y.x1)
       + 2 * OctonionQ.re (X.x2 * conj Y.x2)
       + 2 * OctonionQ.re (X.x3 * conj Y.x3)
  ring

/-! ### Cubic norm identity: `(X ∘ X^#).ξ_i = N(X)` for each `i`

This is the load-bearing Freudenthal identity for the exceptional Jordan
algebra. Together with the off-diagonal vanishing `(X ∘ X^#).x_i = 0`
(P123+), it gives `X ∘ X^# = N(X) · I`. -/

/-- Helper: `Re(x * conj x) = normSq x` (Hurwitz on the inner product). -/
private theorem re_mul_conj_self (x : OctonionQ) :
    OctonionQ.re (x * conj x) = OctonionQ.normSq x := by
  rw [OctonionQ.mul_conj_self]
  show (OctonionQ.normSq x • (1 : OctonionQ)).e0 = OctonionQ.normSq x
  show OctonionQ.normSq x * 1 = OctonionQ.normSq x
  ring

/-- The **cubic norm identity on the (1,1)-diagonal**:
`(X ∘ X^#).xi1 = N(X)`. Proved by reducing both sides to a polynomial
identity in the 24 ℚ-components of `(X.x1, X.x2, X.x3)`. -/
theorem jordanMul_sharp_xi1 (X : J3O) :
    (jordanMul X (sharp X)).xi1 = cubicNorm X := by
  unfold cubicNorm jordanMul sharp
  dsimp
  -- Goal: X.xi1 * (X.xi2 * X.xi3 - normSq X.x1)
  --       + Re(X.x2 * conj(conj(X.x3 * X.x1) - X.xi2 • X.x2))
  --       + Re(X.x3 * conj(conj(X.x1 * X.x2) - X.xi3 • X.x3))
  --     = X.xi1*X.xi2*X.xi3 - X.xi1*normSq X.x1
  --       - X.xi2*normSq X.x2 - X.xi3*normSq X.x3
  --       + 2 * Re(X.x1 * X.x2 * X.x3)
  --
  -- Convert each Re to its .e0 form, expand `conj` and the multiplications
  -- explicitly, then `ring`.
  show X.xi1 * (X.xi2 * X.xi3 - OctonionQ.normSq X.x1)
     + (X.x2 * conj (conj (X.x3 * X.x1) - X.xi2 • X.x2)).e0
     + (X.x3 * conj (conj (X.x1 * X.x2) - X.xi3 • X.x3)).e0
     = X.xi1 * X.xi2 * X.xi3
       - X.xi1 * OctonionQ.normSq X.x1
       - X.xi2 * OctonionQ.normSq X.x2
       - X.xi3 * OctonionQ.normSq X.x3
       + 2 * (X.x1 * X.x2 * X.x3).e0
  unfold OctonionQ.normSq
  simp [OctonionQ.conj]
  ring

/-- The **cubic norm identity on the (2,2)-diagonal**:
`(X ∘ X^#).xi2 = N(X)`. -/
theorem jordanMul_sharp_xi2 (X : J3O) :
    (jordanMul X (sharp X)).xi2 = cubicNorm X := by
  unfold cubicNorm jordanMul sharp
  dsimp
  show X.xi2 * (X.xi3 * X.xi1 - OctonionQ.normSq X.x2)
     + (X.x3 * conj (conj (X.x1 * X.x2) - X.xi3 • X.x3)).e0
     + (X.x1 * conj (conj (X.x2 * X.x3) - X.xi1 • X.x1)).e0
     = X.xi1 * X.xi2 * X.xi3
       - X.xi1 * OctonionQ.normSq X.x1
       - X.xi2 * OctonionQ.normSq X.x2
       - X.xi3 * OctonionQ.normSq X.x3
       + 2 * (X.x1 * X.x2 * X.x3).e0
  unfold OctonionQ.normSq
  simp [OctonionQ.conj]
  ring

/-- The **cubic norm identity on the (3,3)-diagonal**:
`(X ∘ X^#).xi3 = N(X)`. -/
theorem jordanMul_sharp_xi3 (X : J3O) :
    (jordanMul X (sharp X)).xi3 = cubicNorm X := by
  unfold cubicNorm jordanMul sharp
  dsimp
  show X.xi3 * (X.xi1 * X.xi2 - OctonionQ.normSq X.x3)
     + (X.x1 * conj (conj (X.x2 * X.x3) - X.xi1 • X.x1)).e0
     + (X.x2 * conj (conj (X.x3 * X.x1) - X.xi2 • X.x2)).e0
     = X.xi1 * X.xi2 * X.xi3
       - X.xi1 * OctonionQ.normSq X.x1
       - X.xi2 * OctonionQ.normSq X.x2
       - X.xi3 * OctonionQ.normSq X.x3
       + 2 * (X.x1 * X.x2 * X.x3).e0
  unfold OctonionQ.normSq
  simp [OctonionQ.conj]
  ring

/-! ### Off-diagonal vanishing: `(X ∘ X^#).x_i = 0` -/

set_option maxHeartbeats 1000000 in
/-- The **cubic norm identity off-diagonal (2,3) entry**:
`(X ∘ X^#).x1 = 0`. Proved component-wise on each of the 8 octonion
components by `simp + ring` over the explicit Fano-plane multiplication. -/
theorem jordanMul_sharp_x1 (X : J3O) :
    (jordanMul X (sharp X)).x1 = 0 := by
  unfold jordanMul sharp
  dsimp
  ext <;> simp [OctonionQ.conj, OctonionQ.normSq] <;> ring

set_option maxHeartbeats 1000000 in
/-- The **cubic norm identity off-diagonal (1,3) entry**:
`(X ∘ X^#).x2 = 0`. -/
theorem jordanMul_sharp_x2 (X : J3O) :
    (jordanMul X (sharp X)).x2 = 0 := by
  unfold jordanMul sharp
  dsimp
  ext <;> simp [OctonionQ.conj, OctonionQ.normSq] <;> ring

set_option maxHeartbeats 1000000 in
/-- The **cubic norm identity off-diagonal (1,2) entry**:
`(X ∘ X^#).x3 = 0`. -/
theorem jordanMul_sharp_x3 (X : J3O) :
    (jordanMul X (sharp X)).x3 = 0 := by
  unfold jordanMul sharp
  dsimp
  ext <;> simp [OctonionQ.conj, OctonionQ.normSq] <;> ring

/-! ### Bundled cubic norm identity: `X ∘ X^# = N(X) • 1` -/

/-- The **Freudenthal cubic norm identity**: `X ∘ X^# = N(X) • I`.
This is the load-bearing structural identity defining the cubic norm
of the exceptional Jordan algebra `J_3(O)`. Together with
`tr(X ∘ Y) = ⟨X, Y⟩` (P121), this gives `J_3(O)` the structure of a
cubic Jordan algebra in the Springer-Veldkamp / Jacobson sense. -/
theorem jordanMul_sharp_eq_cubicNorm_smul_one (X : J3O) :
    jordanMul X (sharp X) = cubicNorm X • (1 : J3O) := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · rw [jordanMul_sharp_xi1]
    show cubicNorm X = cubicNorm X * (1 : J3O).xi1
    show cubicNorm X = cubicNorm X * 1
    ring
  · rw [jordanMul_sharp_xi2]
    show cubicNorm X = cubicNorm X * 1
    ring
  · rw [jordanMul_sharp_xi3]
    show cubicNorm X = cubicNorm X * 1
    ring
  · rw [jordanMul_sharp_x1]
    show (0 : OctonionQ) = cubicNorm X • (1 : J3O).x1
    show (0 : OctonionQ) = cubicNorm X • (0 : OctonionQ)
    rw [smul_zero]
  · rw [jordanMul_sharp_x2]
    show (0 : OctonionQ) = cubicNorm X • (0 : OctonionQ)
    rw [smul_zero]
  · rw [jordanMul_sharp_x3]
    show (0 : OctonionQ) = cubicNorm X • (0 : OctonionQ)
    rw [smul_zero]

/-! ### Cayley-Hamilton in `J_3(O)`: `X^# = X² − tr(X) X + s_2(X) · 1`

Together with the previously-proved cubic norm identity
`X ∘ X^# = N(X) · 1`, this yields the Cayley-Hamilton-in-`J_3(O)`
characteristic polynomial:
`X^3 = tr(X) X² − s_2(X) X + N(X) · 1`
where `X^3 := X ∘ X²`, `X² := X ∘ X`, and
`s_2(X) := ((tr X)^2 − tr X²) / 2`.

This is the bridge between the directly-defined sharp `X^#` and the
Jordan-product-derived square `X²`. -/

/-- The **Cayley-Hamilton identity** for `J_3(O)`:
`X^# = X² − tr(X) • X + s_2(X) • 1`. -/
theorem sharp_eq_cayley_hamilton (X : J3O) :
    sharp X = jordanMul X X - trace X • X
              + (((trace X)^2 - trace (jordanMul X X)) / 2) • (1 : J3O) := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · -- xi1 component
    show (sharp X).xi1 = _
    simp only [sub_xi1, add_xi1, smul_xi1, one_xi1]
    unfold sharp jordanMul trace
    dsimp
    rw [re_mul_conj_self, re_mul_conj_self, re_mul_conj_self]
    ring
  · -- xi2 component
    show (sharp X).xi2 = _
    simp only [sub_xi2, add_xi2, smul_xi2, one_xi2]
    unfold sharp jordanMul trace
    dsimp
    rw [re_mul_conj_self, re_mul_conj_self, re_mul_conj_self]
    ring
  · -- xi3 component
    show (sharp X).xi3 = _
    simp only [sub_xi3, add_xi3, smul_xi3, one_xi3]
    unfold sharp jordanMul trace
    dsimp
    rw [re_mul_conj_self, re_mul_conj_self, re_mul_conj_self]
    ring
  · -- x1 component
    show (sharp X).x1 = _
    simp only [sub_x1, add_x1, smul_x1, one_x1, smul_zero, add_zero]
    unfold sharp jordanMul trace
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x2 component
    show (sharp X).x2 = _
    simp only [sub_x2, add_x2, smul_x2, one_x2, smul_zero, add_zero]
    unfold sharp jordanMul trace
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x3 component
    show (sharp X).x3 = _
    simp only [sub_x3, add_x3, smul_x3, one_x3, smul_zero, add_zero]
    unfold sharp jordanMul trace
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring

/-- The **Cayley-Hamilton characteristic polynomial** for `J_3(O)`:
`X^3 = tr(X) • X² − s_2(X) • X + N(X) • 1`
where `X^3 := X ∘ X²`, `X² := X ∘ X`, `s_2(X) := ((tr X)^2 − tr X²) / 2`.

This follows by substituting `sharp_eq_cayley_hamilton` into the cubic
norm identity `X ∘ X^# = N(X) • 1` and using Jordan-product bilinearity. -/
theorem cubed_eq_cayley_hamilton (X : J3O) :
    jordanMul X (jordanMul X X)
    = trace X • jordanMul X X
      - (((trace X)^2 - trace (jordanMul X X)) / 2) • X
      + cubicNorm X • (1 : J3O) := by
  -- start with X ∘ X^# = N(X) • 1
  have hcubic := jordanMul_sharp_eq_cubicNorm_smul_one X
  -- rewrite X^# via Cayley-Hamilton
  rw [sharp_eq_cayley_hamilton] at hcubic
  -- expand jordanMul X (X² - tr X • X + s_2 • 1)
  rw [jordanMul_add, jordanMul_sub, jordanMul_smul, jordanMul_smul,
      jordanMul_one] at hcubic
  -- hcubic : jordanMul X X² - tr X • jordanMul X X + s_2 • X = N(X) • 1
  -- target: jordanMul X X² = tr X • jordanMul X X - s_2 • X + N(X) • 1
  -- Algebra in AddCommGroup: A - B + C = D ⟹ A = B - C + D
  have h2 : jordanMul X (jordanMul X X) - trace X • jordanMul X X
          = cubicNorm X • (1 : J3O)
            - (((trace X)^2 - trace (jordanMul X X)) / 2) • X := by
    rw [eq_sub_iff_add_eq]; exact hcubic
  rw [eq_add_of_sub_eq h2]
  abel

/-! ### `jordanMul` bundled as a Mathlib bilinear map

This packages the four bilinearity laws (`add_jordanMul`, `smul_jordanMul`,
`jordanMul_add`, `jordanMul_smul`) into a Mathlib `LinearMap` so the
Jordan product can be used with `LinearMap.BilinForm`, `LinearMap.flip`,
and the rest of the standard linear-algebra machinery. -/

/-- The Jordan product on `J_3(O)` as a `ℚ`-bilinear map. -/
def jordanMulBilin : J3O →ₗ[ℚ] J3O →ₗ[ℚ] J3O :=
  LinearMap.mk₂ ℚ jordanMul
    add_jordanMul
    smul_jordanMul
    jordanMul_add
    jordanMul_smul

@[simp] theorem jordanMulBilin_apply (X Y : J3O) :
    jordanMulBilin X Y = jordanMul X Y := rfl

/-- Right Jordan multiplication `Y ↦ X ∘ Y` as a `ℚ`-linear map. -/
def jordanMulLeft (X : J3O) : J3O →ₗ[ℚ] J3O := jordanMulBilin X

@[simp] theorem jordanMulLeft_apply (X Y : J3O) :
    jordanMulLeft X Y = jordanMul X Y := rfl

/-- Left Jordan multiplication `X ↦ X ∘ Y` as a `ℚ`-linear map. -/
def jordanMulRight (Y : J3O) : J3O →ₗ[ℚ] J3O := jordanMulBilin.flip Y

@[simp] theorem jordanMulRight_apply (X Y : J3O) :
    jordanMulRight Y X = jordanMul X Y := rfl

/-- Commutativity in `LinearMap` form: `jordanMulLeft X = jordanMulRight X`. -/
theorem jordanMulLeft_eq_jordanMulRight (X : J3O) :
    jordanMulLeft X = jordanMulRight X := by
  refine LinearMap.ext fun Y => ?_
  show jordanMul X Y = jordanMul Y X
  exact jordanMul_comm X Y

/-! ### Trace of sharp: `tr(X^#) = s_2(X)`

This is the trace counterpart of `sharp_eq_cayley_hamilton`. Taking the
trace of both sides of `X^# = X² − tr(X) X + s_2(X) • 1` gives
`tr(X^#) = tr(X²) − tr(X) · tr(X) + s_2(X) · 3`, which when rearranged
recovers `tr(X^#) = ((tr X)² − tr X²) / 2 = s_2(X)`.

We prove it directly by component expansion. -/

/-- The **trace of sharp** equals the elementary symmetric polynomial
of degree 2 in the eigenvalues of `X`:
`tr(X^#) = ((tr X)² − tr X²) / 2`. -/
theorem trace_sharp (X : J3O) :
    trace (sharp X) = ((trace X)^2 - trace (jordanMul X X)) / 2 := by
  rw [trace_jordanMul]
  unfold trace sharp innerProd
  dsimp
  rw [re_mul_conj_self, re_mul_conj_self, re_mul_conj_self]
  ring

/-! ### Sharp-inner-product identity: `⟨X^#, X⟩ = 3 N(X)`

This is the Euler-degree-3 identity for the cubic norm:
since `N` is homogeneous of degree 3, by Euler:
`3 N(X) = ⟨grad N(X), X⟩`, and `grad N = 3 X^#` (Freudenthal/Springer).
So `⟨X^#, X⟩ = N(X)` — but in the symmetric-inner-product form
`⟨A, B⟩ = tr(A ∘ B)`, this becomes `⟨X^#, X⟩ = 3 N(X)`.

Proof by direct component expansion. -/

/-! ### Freudenthal cross product `X × Y`

The **polarization** of the (degree-2) sharp map: the symmetric bilinear
operation `X × Y := X^#(X + Y) − X^# − Y^#` that gives back `2 X^#` on
the diagonal `Y = X`. This is the J_3(O) analogue of the cross product
in the Springer triple `(J, N, X × Y)` axiomatics. -/

/-- The **Freudenthal cross product** on `J_3(O)`. -/
def freudenthalCross (X Y : J3O) : J3O := sharp (X + Y) - sharp X - sharp Y

/-- Diagonal value: `X × X = 2 • X^#`. -/
@[simp] theorem freudenthalCross_self (X : J3O) :
    freudenthalCross X X = (2 : ℚ) • sharp X := by
  unfold freudenthalCross
  rw [show X + X = (2 : ℚ) • X from (two_smul ℚ X).symm, sharp_smul]
  show ((2 : ℚ)^2) • sharp X - sharp X - sharp X = (2 : ℚ) • sharp X
  rw [show ((2 : ℚ)^2 : ℚ) = 2 + 1 + 1 from by norm_num,
      add_smul, add_smul, one_smul]
  abel

/-- The cross product is **symmetric**: `X × Y = Y × X`. -/
theorem freudenthalCross_comm (X Y : J3O) :
    freudenthalCross X Y = freudenthalCross Y X := by
  unfold freudenthalCross
  rw [add_comm X Y]
  abel

set_option maxHeartbeats 4000000 in
/-- The cross product is **left-additive**:
`(X + X') × Y = X × Y + X' × Y`. Proved by component expansion using
`normSq_add₃` for the diagonal entries and direct `e_i`-level
polynomial expansion for the off-diagonal entries. -/
theorem freudenthalCross_add_left (X X' Y : J3O) :
    freudenthalCross (X + X') Y
    = freudenthalCross X Y + freudenthalCross X' Y := by
  unfold freudenthalCross
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · -- xi1
    simp only [sub_xi1, add_xi1]
    unfold sharp
    dsimp
    rw [OctonionQ.normSq_add₃, OctonionQ.normSq_add,
        OctonionQ.normSq_add, OctonionQ.normSq_add]
    ring
  · -- xi2
    simp only [sub_xi2, add_xi2]
    unfold sharp
    dsimp
    rw [OctonionQ.normSq_add₃, OctonionQ.normSq_add,
        OctonionQ.normSq_add, OctonionQ.normSq_add]
    ring
  · -- xi3
    simp only [sub_xi3, add_xi3]
    unfold sharp
    dsimp
    rw [OctonionQ.normSq_add₃, OctonionQ.normSq_add,
        OctonionQ.normSq_add, OctonionQ.normSq_add]
    ring
  · -- x1
    simp only [sub_x1, add_x1]
    unfold sharp
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x2
    simp only [sub_x2, add_x2]
    unfold sharp
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x3
    simp only [sub_x3, add_x3]
    unfold sharp
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring

/-- The cross product is **right-additive** (via symmetry). -/
theorem freudenthalCross_add_right (X Y Y' : J3O) :
    freudenthalCross X (Y + Y')
    = freudenthalCross X Y + freudenthalCross X Y' := by
  rw [freudenthalCross_comm, freudenthalCross_add_left]
  congr 1 <;> exact freudenthalCross_comm _ _

set_option maxHeartbeats 4000000 in
/-- The cross product is **left-scalar-compatible**: `(r • X) × Y = r • (X × Y)`. -/
theorem freudenthalCross_smul_left (r : ℚ) (X Y : J3O) :
    freudenthalCross (r • X) Y = r • freudenthalCross X Y := by
  unfold freudenthalCross
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · -- xi1
    simp only [sub_xi1, add_xi1, smul_xi1]
    unfold sharp
    dsimp
    rw [OctonionQ.normSq_add, OctonionQ.normSq_add, OctonionQ.normSq_smul,
        OctonionQ.smul_mul, OctonionQ.re_smul]
    ring
  · -- xi2
    simp only [sub_xi2, add_xi2, smul_xi2]
    unfold sharp
    dsimp
    rw [OctonionQ.normSq_add, OctonionQ.normSq_add, OctonionQ.normSq_smul,
        OctonionQ.smul_mul, OctonionQ.re_smul]
    ring
  · -- xi3
    simp only [sub_xi3, add_xi3, smul_xi3]
    unfold sharp
    dsimp
    rw [OctonionQ.normSq_add, OctonionQ.normSq_add, OctonionQ.normSq_smul,
        OctonionQ.smul_mul, OctonionQ.re_smul]
    ring
  · -- x1
    simp only [sub_x1, add_x1, smul_x1]
    unfold sharp
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x2
    simp only [sub_x2, add_x2, smul_x2]
    unfold sharp
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring
  · -- x3
    simp only [sub_x3, add_x3, smul_x3]
    unfold sharp
    dsimp
    ext <;> simp [OctonionQ.conj] <;> ring

/-- The cross product is **right-scalar-compatible** (via symmetry). -/
theorem freudenthalCross_smul_right (r : ℚ) (X Y : J3O) :
    freudenthalCross X (r • Y) = r • freudenthalCross X Y := by
  rw [freudenthalCross_comm, freudenthalCross_smul_left, freudenthalCross_comm]

/-- The **degree-3 Euler identity**: `⟨X^#, X⟩ = 3 N(X)`. -/
theorem innerProd_sharp_self (X : J3O) :
    innerProd (sharp X) X = 3 * cubicNorm X := by
  unfold innerProd sharp cubicNorm
  dsimp
  -- Both sides as e0-level polynomial identity in the 24 components.
  show (X.xi2 * X.xi3 - OctonionQ.normSq X.x1) * X.xi1
     + (X.xi3 * X.xi1 - OctonionQ.normSq X.x2) * X.xi2
     + (X.xi1 * X.xi2 - OctonionQ.normSq X.x3) * X.xi3
     + 2 * ((OctonionQ.conj (X.x2 * X.x3) - X.xi1 • X.x1) * OctonionQ.conj X.x1).e0
     + 2 * ((OctonionQ.conj (X.x3 * X.x1) - X.xi2 • X.x2) * OctonionQ.conj X.x2).e0
     + 2 * ((OctonionQ.conj (X.x1 * X.x2) - X.xi3 • X.x3) * OctonionQ.conj X.x3).e0
     = 3 * (X.xi1 * X.xi2 * X.xi3
            - X.xi1 * OctonionQ.normSq X.x1
            - X.xi2 * OctonionQ.normSq X.x2
            - X.xi3 * OctonionQ.normSq X.x3
            + 2 * (X.x1 * X.x2 * X.x3).e0)
  unfold OctonionQ.normSq
  simp [OctonionQ.conj]
  ring


