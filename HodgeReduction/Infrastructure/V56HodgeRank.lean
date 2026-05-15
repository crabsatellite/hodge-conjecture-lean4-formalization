/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56HodgeDecomp
import HodgeReduction.Infrastructure.V56Basis
import HodgeReduction.Infrastructure.JordanJ3OBasis
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# Dimensions of the Hodge pieces of `V_56`

Each Hodge piece is linearly isomorphic to a familiar `ℚ`-vector space:
* `V^{3,0} ≃ ℚ`               (dim 1)
* `V^{2,1} ≃ J₃(𝕆)`            (dim 27)
* `V^{1,2} ≃ J₃(𝕆)`            (dim 27)
* `V^{0,3} ≃ ℚ`               (dim 1)

Total: `1 + 27 + 27 + 1 = 56 = dim V_56`. ✓

## Tags

V_56, Hodge decomposition, dimensions, rank
-/

namespace HodgeReduction.Infrastructure

namespace V56

/-! ### `Hodge_3_0 ≃ ℚ` (the 1-dim highest-weight line) -/

/-- The Hodge `(3, 0)`-piece is linearly isomorphic to `ℚ` via the
`a`-coordinate. -/
def Hodge_3_0_equiv : Hodge_3_0 ≃ₗ[ℚ] ℚ where
  toFun v := v.1.a
  invFun a := ⟨⟨a, 0, 0, 0⟩, rfl, rfl, rfl⟩
  left_inv := by
    rintro ⟨v, hA, hB, hb⟩
    apply Subtype.ext
    refine V56.ext rfl ?_ ?_ ?_
    · exact hA.symm
    · exact hB.symm
    · exact hb.symm
  right_inv := fun _ => rfl
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Dimension of `V^{3,0}`: 1. -/
theorem finrank_Hodge_3_0 : Module.finrank ℚ Hodge_3_0 = 1 := by
  rw [LinearEquiv.finrank_eq Hodge_3_0_equiv, Module.finrank_self]

instance : FiniteDimensional ℚ Hodge_3_0 :=
  Module.Finite.of_surjective Hodge_3_0_equiv.symm.toLinearMap
    Hodge_3_0_equiv.symm.surjective

/-! ### `Hodge_0_3 ≃ ℚ` (the 1-dim lowest-weight line) -/

/-- The Hodge `(0, 3)`-piece is linearly isomorphic to `ℚ` via the
`b`-coordinate. -/
def Hodge_0_3_equiv : Hodge_0_3 ≃ₗ[ℚ] ℚ where
  toFun v := v.1.b
  invFun b := ⟨⟨0, 0, 0, b⟩, rfl, rfl, rfl⟩
  left_inv := by
    rintro ⟨v, ha, hA, hB⟩
    apply Subtype.ext
    refine V56.ext ?_ ?_ ?_ rfl
    · exact ha.symm
    · exact hA.symm
    · exact hB.symm
  right_inv := fun _ => rfl
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Dimension of `V^{0,3}`: 1. -/
theorem finrank_Hodge_0_3 : Module.finrank ℚ Hodge_0_3 = 1 := by
  rw [LinearEquiv.finrank_eq Hodge_0_3_equiv, Module.finrank_self]

instance : FiniteDimensional ℚ Hodge_0_3 :=
  Module.Finite.of_surjective Hodge_0_3_equiv.symm.toLinearMap
    Hodge_0_3_equiv.symm.surjective

/-! ### `Hodge_2_1 ≃ J₃(𝕆)` (the 27-dim `+1`-piece) -/

/-- The Hodge `(2, 1)`-piece is linearly isomorphic to `J₃(𝕆)` via the
`A`-component. -/
def Hodge_2_1_equiv : Hodge_2_1 ≃ₗ[ℚ] J3O where
  toFun v := v.1.A
  invFun A := ⟨⟨0, A, 0, 0⟩, rfl, rfl, rfl⟩
  left_inv := by
    rintro ⟨v, ha, hB, hb⟩
    apply Subtype.ext
    refine V56.ext ?_ rfl ?_ ?_
    · exact ha.symm
    · exact hB.symm
    · exact hb.symm
  right_inv := fun _ => rfl
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Dimension of `V^{2,1}`: 27. -/
theorem finrank_Hodge_2_1 : Module.finrank ℚ Hodge_2_1 = 27 := by
  rw [LinearEquiv.finrank_eq Hodge_2_1_equiv, J3O.finrank]

instance : FiniteDimensional ℚ Hodge_2_1 :=
  Module.Finite.of_surjective Hodge_2_1_equiv.symm.toLinearMap
    Hodge_2_1_equiv.symm.surjective

/-! ### `Hodge_1_2 ≃ J₃(𝕆)` (the 27-dim `-1`-piece) -/

/-- The Hodge `(1, 2)`-piece is linearly isomorphic to `J₃(𝕆)` via the
`B`-component. -/
def Hodge_1_2_equiv : Hodge_1_2 ≃ₗ[ℚ] J3O where
  toFun v := v.1.B
  invFun B := ⟨⟨0, 0, B, 0⟩, rfl, rfl, rfl⟩
  left_inv := by
    rintro ⟨v, ha, hA, hb⟩
    apply Subtype.ext
    refine V56.ext ?_ ?_ rfl ?_
    · exact ha.symm
    · exact hA.symm
    · exact hb.symm
  right_inv := fun _ => rfl
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Dimension of `V^{1,2}`: 27. -/
theorem finrank_Hodge_1_2 : Module.finrank ℚ Hodge_1_2 = 27 := by
  rw [LinearEquiv.finrank_eq Hodge_1_2_equiv, J3O.finrank]

instance : FiniteDimensional ℚ Hodge_1_2 :=
  Module.Finite.of_surjective Hodge_1_2_equiv.symm.toLinearMap
    Hodge_1_2_equiv.symm.surjective

/-! ### Dimension consistency: `1 + 27 + 27 + 1 = 56` -/

/-- The Hodge dimensions sum to the V_56 dimension. -/
theorem finrank_Hodge_pieces_sum_eq_V56 :
    Module.finrank ℚ Hodge_3_0 + Module.finrank ℚ Hodge_2_1
      + Module.finrank ℚ Hodge_1_2 + Module.finrank ℚ Hodge_0_3
    = Module.finrank ℚ V56 := by
  rw [finrank_Hodge_3_0, finrank_Hodge_2_1, finrank_Hodge_1_2,
      finrank_Hodge_0_3, V56.finrank]

end V56

end HodgeReduction.Infrastructure
