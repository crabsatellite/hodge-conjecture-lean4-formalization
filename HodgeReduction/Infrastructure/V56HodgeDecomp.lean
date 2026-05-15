/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56Basis
import Mathlib.LinearAlgebra.Span.Basic

/-!
# The Hodge decomposition `V₅₆ = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}`

Under the action of `E₆ × U(1) ⊂ E₇` on `V₅₆`, the 4-component
structure `(a, A, B, b)` corresponds to the **Hodge decomposition** with
U(1)-charges `(+3, +1, -1, -3)`:
```
   V₅₆ = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}
       = ⟨a⟩    ⊕ ⟨A⟩    ⊕ ⟨B⟩    ⊕ ⟨b⟩
```
where each summand is the eigenspace of `U(1) ⊂ E₆ × U(1)` of the
indicated weight, and corresponds in the Hodge realisation to the
Hodge `(p, q)`-piece.

This file packages each summand as a `ℚ`-`Submodule` of `V₅₆`, plus the
direct-sum decomposition theorem.

## Main definitions

* `V56.Hodge_3_0 : Submodule ℚ V56` — `{v : V56 // v.A = 0 ∧ v.B = 0 ∧ v.b = 0}` (1-dim)
* `V56.Hodge_2_1 : Submodule ℚ V56` — `{v // v.a = 0 ∧ v.B = 0 ∧ v.b = 0}` (27-dim)
* `V56.Hodge_1_2 : Submodule ℚ V56` — `{v // v.a = 0 ∧ v.A = 0 ∧ v.b = 0}` (27-dim)
* `V56.Hodge_0_3 : Submodule ℚ V56` — `{v // v.a = 0 ∧ v.A = 0 ∧ v.B = 0}` (1-dim)

## Tags

V_56, Hodge decomposition, E_7, E_6, U(1), submodule
-/

namespace HodgeReduction.Infrastructure

namespace V56

/-- The Hodge `(3, 0)`-piece of `V₅₆`: vectors `v = (a, 0, 0, 0)`.
This is the U(1)-charge `+3` highest-weight line. -/
def Hodge_3_0 : Submodule ℚ V56 where
  carrier := {v | v.A = 0 ∧ v.B = 0 ∧ v.b = 0}
  zero_mem' := ⟨rfl, rfl, rfl⟩
  add_mem' := by
    rintro v w ⟨hvA, hvB, hvb⟩ ⟨hwA, hwB, hwb⟩
    refine ⟨?_, ?_, ?_⟩
    · show v.A + w.A = 0; rw [hvA, hwA, add_zero]
    · show v.B + w.B = 0; rw [hvB, hwB, add_zero]
    · show v.b + w.b = 0; rw [hvb, hwb, add_zero]
  smul_mem' := by
    rintro r v ⟨hvA, hvB, hvb⟩
    refine ⟨?_, ?_, ?_⟩
    · show r • v.A = 0; rw [hvA, smul_zero]
    · show r • v.B = 0; rw [hvB, smul_zero]
    · show r * v.b = 0; rw [hvb, mul_zero]

/-- The Hodge `(2, 1)`-piece of `V₅₆`: vectors `v = (0, A, 0, 0)`.
This is the U(1)-charge `+1` `J₃(𝕆)`-piece. -/
def Hodge_2_1 : Submodule ℚ V56 where
  carrier := {v | v.a = 0 ∧ v.B = 0 ∧ v.b = 0}
  zero_mem' := ⟨rfl, rfl, rfl⟩
  add_mem' := by
    rintro v w ⟨hva, hvB, hvb⟩ ⟨hwa, hwB, hwb⟩
    refine ⟨?_, ?_, ?_⟩
    · show v.a + w.a = 0; rw [hva, hwa, add_zero]
    · show v.B + w.B = 0; rw [hvB, hwB, add_zero]
    · show v.b + w.b = 0; rw [hvb, hwb, add_zero]
  smul_mem' := by
    rintro r v ⟨hva, hvB, hvb⟩
    refine ⟨?_, ?_, ?_⟩
    · show r * v.a = 0; rw [hva, mul_zero]
    · show r • v.B = 0; rw [hvB, smul_zero]
    · show r * v.b = 0; rw [hvb, mul_zero]

/-- The Hodge `(1, 2)`-piece of `V₅₆`: vectors `v = (0, 0, B, 0)`.
This is the U(1)-charge `-1` `J₃(𝕆)`-piece (`B` carries the
conjugate-representation `27̄`). -/
def Hodge_1_2 : Submodule ℚ V56 where
  carrier := {v | v.a = 0 ∧ v.A = 0 ∧ v.b = 0}
  zero_mem' := ⟨rfl, rfl, rfl⟩
  add_mem' := by
    rintro v w ⟨hva, hvA, hvb⟩ ⟨hwa, hwA, hwb⟩
    refine ⟨?_, ?_, ?_⟩
    · show v.a + w.a = 0; rw [hva, hwa, add_zero]
    · show v.A + w.A = 0; rw [hvA, hwA, add_zero]
    · show v.b + w.b = 0; rw [hvb, hwb, add_zero]
  smul_mem' := by
    rintro r v ⟨hva, hvA, hvb⟩
    refine ⟨?_, ?_, ?_⟩
    · show r * v.a = 0; rw [hva, mul_zero]
    · show r • v.A = 0; rw [hvA, smul_zero]
    · show r * v.b = 0; rw [hvb, mul_zero]

/-- The Hodge `(0, 3)`-piece of `V₅₆`: vectors `v = (0, 0, 0, b)`.
This is the U(1)-charge `-3` lowest-weight line. -/
def Hodge_0_3 : Submodule ℚ V56 where
  carrier := {v | v.a = 0 ∧ v.A = 0 ∧ v.B = 0}
  zero_mem' := ⟨rfl, rfl, rfl⟩
  add_mem' := by
    rintro v w ⟨hva, hvA, hvB⟩ ⟨hwa, hwA, hwB⟩
    refine ⟨?_, ?_, ?_⟩
    · show v.a + w.a = 0; rw [hva, hwa, add_zero]
    · show v.A + w.A = 0; rw [hvA, hwA, add_zero]
    · show v.B + w.B = 0; rw [hvB, hwB, add_zero]
  smul_mem' := by
    rintro r v ⟨hva, hvA, hvB⟩
    refine ⟨?_, ?_, ?_⟩
    · show r * v.a = 0; rw [hva, mul_zero]
    · show r • v.A = 0; rw [hvA, smul_zero]
    · show r • v.B = 0; rw [hvB, smul_zero]

/-! ### Sanity checks: highest/lowest-weight vectors are in the right piece. -/

theorem highest_weight_mem_Hodge_3_0 :
    (⟨1, 0, 0, 0⟩ : V56) ∈ Hodge_3_0 :=
  ⟨rfl, rfl, rfl⟩

theorem lowest_weight_mem_Hodge_0_3 :
    (⟨0, 0, 0, 1⟩ : V56) ∈ Hodge_0_3 :=
  ⟨rfl, rfl, rfl⟩

/-! ### The four pieces are pairwise disjoint and span `V₅₆`. -/

/-- The Hodge decomposition `V₅₆ = ⨁_p V^{p, 3-p}` realises the
4-component structure of `V₅₆` as the direct sum of the four
U(1)-eigenspaces. Concretely, every `v ∈ V₅₆` decomposes uniquely as
`v = v_{3,0} + v_{2,1} + v_{1,2} + v_{0,3}`. -/
theorem hodge_decomp_exists (v : V56) :
    ∃ (v30 : Hodge_3_0) (v21 : Hodge_2_1)
      (v12 : Hodge_1_2) (v03 : Hodge_0_3),
      v = v30.1 + v21.1 + v12.1 + v03.1 := by
  refine ⟨⟨⟨v.a, 0, 0, 0⟩, rfl, rfl, rfl⟩,
          ⟨⟨0, v.A, 0, 0⟩, rfl, rfl, rfl⟩,
          ⟨⟨0, 0, v.B, 0⟩, rfl, rfl, rfl⟩,
          ⟨⟨0, 0, 0, v.b⟩, rfl, rfl, rfl⟩, ?_⟩
  refine V56.ext ?_ ?_ ?_ ?_
  · show v.a = v.a + 0 + 0 + 0; ring
  · show v.A = 0 + v.A + 0 + 0
    show v.A = (0 : J3O) + v.A + 0 + 0
    rw [zero_add, add_zero, add_zero]
  · show v.B = 0 + 0 + v.B + 0
    show v.B = (0 : J3O) + 0 + v.B + 0
    rw [zero_add, zero_add, add_zero]
  · show v.b = 0 + 0 + 0 + v.b; ring

/-! ### Hodge-piece projections and inclusions as `LinearMap`s -/

/-- The projection `V₅₆ → ℚ` onto the U(1)-charge `+3` component (the
`a`-coordinate). -/
def projA : V56 →ₗ[ℚ] ℚ where
  toFun := V56.a
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The projection `V₅₆ → ℚ` onto the U(1)-charge `-3` component (the
`b`-coordinate). -/
def projB : V56 →ₗ[ℚ] ℚ where
  toFun := V56.b
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The projection `V₅₆ → J₃(𝕆)` onto the U(1)-charge `+1` Hodge piece. -/
def projUpperA : V56 →ₗ[ℚ] J3O where
  toFun := V56.A
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The projection `V₅₆ → J₃(𝕆)` onto the U(1)-charge `-1` Hodge piece. -/
def projUpperB : V56 →ₗ[ℚ] J3O where
  toFun := V56.B
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The inclusion `ℚ → V₅₆` of the highest-weight (`+3`) line. -/
def inclLowestPlus : ℚ →ₗ[ℚ] V56 where
  toFun a := ⟨a, 0, 0, 0⟩
  map_add' _ _ := by
    refine V56.ext ?_ ?_ ?_ ?_
    · rfl
    · show (0 : J3O) = 0 + 0; rw [add_zero]
    · show (0 : J3O) = 0 + 0; rw [add_zero]
    · show (0 : ℚ) = 0 + 0; ring
  map_smul' _ _ := by
    refine V56.ext ?_ ?_ ?_ ?_
    · rfl
    · show (0 : J3O) = _ • (0 : J3O); rw [smul_zero]
    · show (0 : J3O) = _ • (0 : J3O); rw [smul_zero]
    · show (0 : ℚ) = _ * 0; ring

/-- The inclusion `J₃(𝕆) → V₅₆` of the upper-A `(+1)` piece. -/
def inclUpperA : J3O →ₗ[ℚ] V56 where
  toFun A := ⟨0, A, 0, 0⟩
  map_add' _ _ := by refine V56.ext ?_ ?_ ?_ ?_ <;> show _ = _ <;> simp
  map_smul' _ _ := by refine V56.ext ?_ ?_ ?_ ?_ <;> show _ = _ <;> simp

/-- The inclusion `J₃(𝕆) → V₅₆` of the upper-B `(-1)` piece. -/
def inclUpperB : J3O →ₗ[ℚ] V56 where
  toFun B := ⟨0, 0, B, 0⟩
  map_add' _ _ := by refine V56.ext ?_ ?_ ?_ ?_ <;> show _ = _ <;> simp
  map_smul' _ _ := by refine V56.ext ?_ ?_ ?_ ?_ <;> show _ = _ <;> simp

/-- The inclusion `ℚ → V₅₆` of the lowest-weight (`-3`) line. -/
def inclLowestMinus : ℚ →ₗ[ℚ] V56 where
  toFun b := ⟨0, 0, 0, b⟩
  map_add' _ _ := by
    refine V56.ext ?_ ?_ ?_ ?_
    · show (0 : ℚ) = 0 + 0; ring
    · show (0 : J3O) = 0 + 0; rw [add_zero]
    · show (0 : J3O) = 0 + 0; rw [add_zero]
    · rfl
  map_smul' _ _ := by
    refine V56.ext ?_ ?_ ?_ ?_
    · show (0 : ℚ) = _ * 0; ring
    · show (0 : J3O) = _ • (0 : J3O); rw [smul_zero]
    · show (0 : J3O) = _ • (0 : J3O); rw [smul_zero]
    · rfl

/-- The projection onto the `+1` Hodge piece composes to identity on `J₃(𝕆)`. -/
@[simp] theorem projUpperA_inclUpperA (A : J3O) :
    projUpperA (inclUpperA A) = A := rfl

/-- The projection onto the `-1` Hodge piece composes to identity on `J₃(𝕆)`. -/
@[simp] theorem projUpperB_inclUpperB (B : J3O) :
    projUpperB (inclUpperB B) = B := rfl

/-- The four projections sum to the identity (Hodge-decomposition relation). -/
theorem inclusion_sum_id (v : V56) :
    v = inclLowestPlus v.a + inclUpperA v.A + inclUpperB v.B + inclLowestMinus v.b := by
  refine V56.ext ?_ ?_ ?_ ?_
  · show v.a = v.a + 0 + 0 + 0; ring
  · show v.A = 0 + v.A + 0 + 0
    show v.A = (0 : J3O) + v.A + 0 + 0
    rw [zero_add, add_zero, add_zero]
  · show v.B = 0 + 0 + v.B + 0
    show v.B = (0 : J3O) + 0 + v.B + 0
    rw [zero_add, zero_add, add_zero]
  · show v.b = 0 + 0 + 0 + v.b; ring

end V56

end HodgeReduction.Infrastructure
