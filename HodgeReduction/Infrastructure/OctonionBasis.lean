/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Octonion
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# Basis and finite-dimensionality of the octonion `ℚ`-algebra

This file provides the explicit `ℚ`-vector-space structure on `OctonionQ`:

* `OctonionQ.equivFin8 : OctonionQ ≃ₗ[ℚ] (Fin 8 → ℚ)` — the canonical
  linear isomorphism with the 8-tuple representation.
* `OctonionQ.basisFin8 : Basis (Fin 8) ℚ OctonionQ` — the standard
  basis `{e₀, e₁, ..., e₇}` exhibited as a Mathlib `Basis`.
* `OctonionQ.finrank : Module.finrank ℚ OctonionQ = 8` —
  the `ℚ`-dimension of the octonion algebra.
* `OctonionQ.instFiniteDimensional : FiniteDimensional ℚ OctonionQ`.

## Tags

octonion, basis, finrank, 8-dimensional, Mathlib bridge
-/

namespace HodgeReduction.Infrastructure

namespace OctonionQ

/-! ### Linear equivalence to `Fin 8 → ℚ` -/

/-- Project `OctonionQ` to its 8-tuple representation. -/
def toFin8 (x : OctonionQ) : Fin 8 → ℚ := fun i =>
  match i with
  | ⟨0, _⟩ => x.e0
  | ⟨1, _⟩ => x.e1
  | ⟨2, _⟩ => x.e2
  | ⟨3, _⟩ => x.e3
  | ⟨4, _⟩ => x.e4
  | ⟨5, _⟩ => x.e5
  | ⟨6, _⟩ => x.e6
  | ⟨7, _⟩ => x.e7

/-- Build an `OctonionQ` from its 8-tuple. -/
def ofFin8 (f : Fin 8 → ℚ) : OctonionQ :=
  ⟨f 0, f 1, f 2, f 3, f 4, f 5, f 6, f 7⟩

@[simp] theorem ofFin8_toFin8 (x : OctonionQ) : ofFin8 (toFin8 x) = x := by
  ext <;> rfl

@[simp] theorem toFin8_ofFin8 (f : Fin 8 → ℚ) : toFin8 (ofFin8 f) = f := by
  funext i
  match i with
  | ⟨0, _⟩ => rfl
  | ⟨1, _⟩ => rfl
  | ⟨2, _⟩ => rfl
  | ⟨3, _⟩ => rfl
  | ⟨4, _⟩ => rfl
  | ⟨5, _⟩ => rfl
  | ⟨6, _⟩ => rfl
  | ⟨7, _⟩ => rfl

/-- The canonical `ℚ`-linear equivalence `OctonionQ ≃ₗ[ℚ] (Fin 8 → ℚ)`. -/
def equivFin8 : OctonionQ ≃ₗ[ℚ] (Fin 8 → ℚ) where
  toFun := toFin8
  invFun := ofFin8
  left_inv := ofFin8_toFin8
  right_inv := toFin8_ofFin8
  map_add' x y := by
    funext i
    match i with
    | ⟨0, _⟩ => rfl
    | ⟨1, _⟩ => rfl
    | ⟨2, _⟩ => rfl
    | ⟨3, _⟩ => rfl
    | ⟨4, _⟩ => rfl
    | ⟨5, _⟩ => rfl
    | ⟨6, _⟩ => rfl
    | ⟨7, _⟩ => rfl
  map_smul' r x := by
    funext i
    match i with
    | ⟨0, _⟩ => rfl
    | ⟨1, _⟩ => rfl
    | ⟨2, _⟩ => rfl
    | ⟨3, _⟩ => rfl
    | ⟨4, _⟩ => rfl
    | ⟨5, _⟩ => rfl
    | ⟨6, _⟩ => rfl
    | ⟨7, _⟩ => rfl

/-! ### Basis -/

/-- The standard basis `{e₀, e₁, ..., e₇}` of `OctonionQ` over `ℚ`. -/
noncomputable def basisFin8 : Basis (Fin 8) ℚ OctonionQ :=
  Basis.ofEquivFun equivFin8

/-! ### Finite-dimensionality and rank -/

instance instFiniteDimensional : FiniteDimensional ℚ OctonionQ :=
  Module.Finite.of_basis basisFin8

/-- The `ℚ`-dimension of the octonion algebra is `8`. -/
theorem finrank : Module.finrank ℚ OctonionQ = 8 := by
  rw [Module.finrank_eq_card_basis basisFin8]
  exact Fintype.card_fin 8

end OctonionQ

end HodgeReduction.Infrastructure
