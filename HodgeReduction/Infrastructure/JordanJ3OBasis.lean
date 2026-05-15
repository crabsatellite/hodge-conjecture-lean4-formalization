/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.JordanJ3O
import HodgeReduction.Infrastructure.OctonionBasis
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.Tactic.IntervalCases

/-!
# Basis and finite-dimensionality of the exceptional Jordan algebra `J₃(𝕆)`

`J₃(𝕆)` is the 27-dimensional Hermitian-3×3-over-octonions Jordan algebra.
Decomposing each `OctonionQ`-component into its 8 `ℚ`-components yields
`3 + 3·8 = 27` total `ℚ`-coordinates.

This file provides the `ℚ`-linear-algebra interfaces:
* `J3O.equivFin27 : J3O ≃ₗ[ℚ] (Fin 27 → ℚ)` — the canonical iso with `ℚ²⁷`.
* `J3O.basisFin27 : Basis (Fin 27) ℚ J3O`.
* `J3O.finrank : Module.finrank ℚ J3O = 27`.
* `J3O.instFiniteDimensional : FiniteDimensional ℚ J3O`.

## Tags

exceptional Jordan algebra, J_3(O), basis, finrank, 27-dimensional
-/

namespace HodgeReduction.Infrastructure

namespace J3O

open OctonionQ (toFin8 ofFin8)

/-! ### Linear equivalence to `Fin 27 → ℚ`

The 27 coordinates are organised as `(ξ₁, ξ₂, ξ₃, x1[0..7], x2[0..7], x3[0..7])`:
* indices `0..2` are the three diagonal entries.
* indices `3..10` are the 8 components of off-diagonal `x1`.
* indices `11..18` are the 8 components of `x2`.
* indices `19..26` are the 8 components of `x3`.
-/

/-- Shift index `i : Fin 8` to position `i.val + k` inside `Fin 27`. -/
private def shift (k : ℕ) (hk : k + 8 ≤ 27) (i : Fin 8) : Fin 27 :=
  ⟨i.val + k, by omega⟩

/-- Project `J3O` to its 27-tuple representation. -/
def toFin27 (X : J3O) : Fin 27 → ℚ := fun i =>
  if h0 : i.val < 3 then
    match i.val, h0 with
    | 0, _ => X.xi1
    | 1, _ => X.xi2
    | 2, _ => X.xi3
  else if h1 : i.val < 11 then
    toFin8 X.x1 ⟨i.val - 3, by omega⟩
  else if h2 : i.val < 19 then
    toFin8 X.x2 ⟨i.val - 11, by omega⟩
  else
    toFin8 X.x3 ⟨i.val - 19, by omega⟩

/-- Build a `J3O` from its 27-tuple. -/
def ofFin27 (f : Fin 27 → ℚ) : J3O where
  xi1 := f ⟨0, by omega⟩
  xi2 := f ⟨1, by omega⟩
  xi3 := f ⟨2, by omega⟩
  x1 := ofFin8 (fun i => f (shift 3 (by omega) i))
  x2 := ofFin8 (fun i => f (shift 11 (by omega) i))
  x3 := ofFin8 (fun i => f (shift 19 (by omega) i))

theorem ofFin27_toFin27 (X : J3O) : ofFin27 (toFin27 X) = X := by
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · rfl
  · rfl
  · rfl
  · show ofFin8 (fun i => toFin27 X (shift 3 _ i)) = X.x1
    have h : (fun (i : Fin 8) => toFin27 X (shift 3 (by omega) i)) = toFin8 X.x1 := by
      funext i
      show toFin27 X ⟨i.val + 3, by omega⟩ = toFin8 X.x1 i
      unfold toFin27
      have hi : i.val < 8 := i.isLt
      simp only [show ¬ i.val + 3 < 3 from by omega, show i.val + 3 < 11 from by omega,
                 dif_neg, dif_pos]
      congr 1
    rw [h, OctonionQ.ofFin8_toFin8]
  · show ofFin8 (fun i => toFin27 X (shift 11 _ i)) = X.x2
    have h : (fun (i : Fin 8) => toFin27 X (shift 11 (by omega) i)) = toFin8 X.x2 := by
      funext i
      show toFin27 X ⟨i.val + 11, by omega⟩ = toFin8 X.x2 i
      unfold toFin27
      have hi : i.val < 8 := i.isLt
      simp only [show ¬ i.val + 11 < 3 from by omega,
                 show ¬ i.val + 11 < 11 from by omega,
                 show i.val + 11 < 19 from by omega,
                 dif_neg, dif_pos]
      congr 1
    rw [h, OctonionQ.ofFin8_toFin8]
  · show ofFin8 (fun i => toFin27 X (shift 19 _ i)) = X.x3
    have h : (fun (i : Fin 8) => toFin27 X (shift 19 (by omega) i)) = toFin8 X.x3 := by
      funext i
      show toFin27 X ⟨i.val + 19, by omega⟩ = toFin8 X.x3 i
      unfold toFin27
      have hi : i.val < 8 := i.isLt
      simp only [show ¬ i.val + 19 < 3 from by omega,
                 show ¬ i.val + 19 < 11 from by omega,
                 show ¬ i.val + 19 < 19 from by omega,
                 dif_neg]
      congr 1
    rw [h, OctonionQ.ofFin8_toFin8]

theorem toFin27_ofFin27 (f : Fin 27 → ℚ) : toFin27 (ofFin27 f) = f := by
  funext i
  rcases i with ⟨n, hn⟩
  interval_cases n <;> rfl

/-- The canonical `ℚ`-linear equivalence `J3O ≃ₗ[ℚ] (Fin 27 → ℚ)`. -/
def equivFin27 : J3O ≃ₗ[ℚ] (Fin 27 → ℚ) where
  toFun := toFin27
  invFun := ofFin27
  left_inv := ofFin27_toFin27
  right_inv := toFin27_ofFin27
  map_add' X Y := by
    funext i
    rcases i with ⟨n, hn⟩
    interval_cases n <;> rfl
  map_smul' r X := by
    funext i
    rcases i with ⟨n, hn⟩
    interval_cases n <;> rfl

/-! ### Basis -/

/-- The standard basis of `J₃(𝕆)` over `ℚ` with 27 elements. -/
noncomputable def basisFin27 : Basis (Fin 27) ℚ J3O :=
  Basis.ofEquivFun equivFin27

/-! ### Finite-dimensionality and rank -/

instance instFiniteDimensional : FiniteDimensional ℚ J3O :=
  Module.Finite.of_basis basisFin27

/-- The `ℚ`-dimension of the exceptional Jordan algebra is `27`. -/
theorem finrank : Module.finrank ℚ J3O = 27 := by
  rw [Module.finrank_eq_card_basis basisFin27]
  exact Fintype.card_fin 27

end J3O

end HodgeReduction.Infrastructure
