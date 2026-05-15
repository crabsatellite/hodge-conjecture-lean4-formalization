/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56Freudenthal
import HodgeReduction.Infrastructure.JordanJ3OBasis
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.Tactic.IntervalCases

/-!
# Basis and finite-dimensionality of `V₅₆`

`V₅₆ = ℚ ⊕ J₃(𝕆) ⊕ J₃(𝕆) ⊕ ℚ` has total `ℚ`-dimension `1 + 27 + 27 + 1 = 56`,
matching the `56`-dim minuscule representation of `E_7`.

* `V56.equivFin56 : V56 ≃ₗ[ℚ] (Fin 56 → ℚ)`.
* `V56.basisFin56 : Basis (Fin 56) ℚ V56`.
* `V56.finrank : Module.finrank ℚ V56 = 56`.
* `V56.instFiniteDimensional : FiniteDimensional ℚ V56`.
-/

namespace HodgeReduction.Infrastructure

namespace V56

open J3O (toFin27 ofFin27)

/-- Shift index `i : Fin 27` to position `i.val + k` in `Fin 56`. -/
private def shift27 (k : ℕ) (hk : k + 27 ≤ 56) (i : Fin 27) : Fin 56 :=
  ⟨i.val + k, by omega⟩

/-! ### Layout of the 56 coordinates
* index `0`        : `a` (U(1)-charge +3 piece)
* indices `1..27`  : `A : J3O` (27 components via `toFin27`)
* indices `28..54` : `B : J3O` (27 components)
* index `55`       : `b` (U(1)-charge -3 piece)
-/

/-- Project `V56` to its 56-tuple representation. -/
def toFin56 (v : V56) : Fin 56 → ℚ := fun i =>
  if h0 : i.val = 0 then v.a
  else if h1 : i.val < 28 then
    toFin27 v.A ⟨i.val - 1, by omega⟩
  else if h2 : i.val < 55 then
    toFin27 v.B ⟨i.val - 28, by omega⟩
  else v.b

/-- Build a `V56` from its 56-tuple. -/
def ofFin56 (f : Fin 56 → ℚ) : V56 where
  a := f ⟨0, by omega⟩
  A := ofFin27 (fun i => f (shift27 1 (by omega) i))
  B := ofFin27 (fun i => f (shift27 28 (by omega) i))
  b := f ⟨55, by omega⟩

theorem ofFin56_toFin56 (v : V56) : ofFin56 (toFin56 v) = v := by
  refine V56.ext ?_ ?_ ?_ ?_
  · rfl
  · show ofFin27 (fun i => toFin56 v (shift27 1 _ i)) = v.A
    have h : (fun (i : Fin 27) => toFin56 v (shift27 1 (by omega) i)) = toFin27 v.A := by
      funext i
      have hi : i.val < 27 := i.isLt
      have h1 : (i.val + 1) ≠ 0 := by omega
      have h2 : (i.val + 1) < 28 := by omega
      have heq : (⟨i.val + 1 - 1, by omega⟩ : Fin 27) = i := by
        apply Fin.ext
        show i.val + 1 - 1 = i.val
        omega
      show toFin56 v ⟨i.val + 1, by omega⟩ = toFin27 v.A i
      unfold toFin56
      rw [dif_neg (show ¬ (Fin.mk (i.val + 1) _).val = 0 from h1),
          dif_pos (show (Fin.mk (i.val + 1) _).val < 28 from h2)]
      rw [heq]
    rw [h, J3O.ofFin27_toFin27]
  · show ofFin27 (fun i => toFin56 v (shift27 28 _ i)) = v.B
    have h : (fun (i : Fin 27) => toFin56 v (shift27 28 (by omega) i)) = toFin27 v.B := by
      funext i
      have hi : i.val < 27 := i.isLt
      have h1 : (i.val + 28) ≠ 0 := by omega
      have h2a : ¬ (i.val + 28) < 28 := by omega
      have h2b : (i.val + 28) < 55 := by omega
      have heq : (⟨i.val + 28 - 28, by omega⟩ : Fin 27) = i := by
        apply Fin.ext
        show i.val + 28 - 28 = i.val
        omega
      show toFin56 v ⟨i.val + 28, by omega⟩ = toFin27 v.B i
      unfold toFin56
      rw [dif_neg (show ¬ (Fin.mk (i.val + 28) _).val = 0 from h1),
          dif_neg (show ¬ (Fin.mk (i.val + 28) _).val < 28 from h2a),
          dif_pos (show (Fin.mk (i.val + 28) _).val < 55 from h2b)]
      rw [heq]
    rw [h, J3O.ofFin27_toFin27]
  · rfl

theorem toFin56_ofFin56 (f : Fin 56 → ℚ) : toFin56 (ofFin56 f) = f := by
  funext i
  rcases i with ⟨n, hn⟩
  interval_cases n <;> rfl

/-- The canonical `ℚ`-linear equivalence `V56 ≃ₗ[ℚ] (Fin 56 → ℚ)`. -/
def equivFin56 : V56 ≃ₗ[ℚ] (Fin 56 → ℚ) where
  toFun := toFin56
  invFun := ofFin56
  left_inv := ofFin56_toFin56
  right_inv := toFin56_ofFin56
  map_add' v w := by
    funext i
    rcases i with ⟨n, hn⟩
    interval_cases n <;> rfl
  map_smul' r v := by
    funext i
    rcases i with ⟨n, hn⟩
    interval_cases n <;> rfl

/-! ### Basis -/

/-- The standard basis of `V_56` over `ℚ` with 56 elements (= `1 + 27 + 27 + 1`). -/
noncomputable def basisFin56 : Basis (Fin 56) ℚ V56 :=
  Basis.ofEquivFun equivFin56

/-! ### Finite-dimensionality and rank -/

instance instFiniteDimensional : FiniteDimensional ℚ V56 :=
  Module.Finite.of_basis basisFin56

/-- The `ℚ`-dimension of `V_56` is `56 = 1 + 27 + 27 + 1`, matching the
minuscule representation of `E_7`. -/
theorem finrank : Module.finrank ℚ V56 = 56 := by
  rw [Module.finrank_eq_card_basis basisFin56]
  exact Fintype.card_fin 56

end V56

end HodgeReduction.Infrastructure
