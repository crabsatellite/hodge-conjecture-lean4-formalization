/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56Freudenthal
import HodgeReduction.Infrastructure.V56Basis
import Mathlib.LinearAlgebra.BilinearMap

/-!
# Linear / bilinear interfaces for `J₃(𝕆)` and `V₅₆`

This file packages the existing trace / inner-product / symplectic-form
operations as Mathlib `LinearMap` / `LinearMap.BilinForm` so they can be
used with the standard linear-algebra machinery (e.g. matrix
representations, dual spaces, kernel/range, etc.).

## Main definitions

* `J3O.traceLinear : J3O →ₗ[ℚ] ℚ` — trace as a `ℚ`-linear functional.
* `J3O.innerProdBilin : J3O →ₗ[ℚ] J3O →ₗ[ℚ] ℚ` — `⟨·,·⟩` as bilinear form.
* `V56.omegaBilin : V56 →ₗ[ℚ] V56 →ₗ[ℚ] ℚ` — symplectic form `ω` as
  antisymmetric bilinear form.

## Tags

LinearMap, BilinForm, trace, inner product, symplectic form, V_56, J_3(O)
-/

namespace HodgeReduction.Infrastructure

namespace J3O

/-- The trace `tr : J₃(𝕆) → ℚ` as a Mathlib `ℚ`-linear functional. -/
def traceLinear : J3O →ₗ[ℚ] ℚ where
  toFun := trace
  map_add' := trace_add
  map_smul' r X := trace_smul r X

@[simp] theorem traceLinear_apply (X : J3O) : traceLinear X = trace X := rfl

/-- The inner product `⟨·, ·⟩ : J₃(𝕆) × J₃(𝕆) → ℚ` as a Mathlib bilinear map. -/
def innerProdBilin : J3O →ₗ[ℚ] J3O →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ innerProd
    (fun X Y Z => innerProd_add_left X Y Z)
    (fun r X Y => innerProd_smul_left r X Y)
    (fun X Y Z => innerProd_add_right X Y Z)
    (fun r X Y => innerProd_smul_right r X Y)

@[simp] theorem innerProdBilin_apply (X Y : J3O) :
    innerProdBilin X Y = innerProd X Y := rfl

end J3O

namespace V56

/-- The symplectic form `ω : V₅₆ × V₅₆ → ℚ` as a Mathlib bilinear map.
This is the second `E₇`-invariant (after the quartic `q`). -/
def omegaBilin : V56 →ₗ[ℚ] V56 →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ omega
    (fun v v' w => omega_add_left v v' w)
    (fun r v w => omega_smul_left r v w)
    (fun v w w' => omega_add_right v w w')
    (fun r v w => omega_smul_right r v w)

@[simp] theorem omegaBilin_apply (v w : V56) :
    omegaBilin v w = omega v w := rfl

/-- The symplectic form `ω` is antisymmetric:
`omegaBilin v w = -omegaBilin w v`. -/
theorem omegaBilin_antisymm (v w : V56) :
    omegaBilin v w = -omegaBilin w v := by
  show omega v w = -omega w v
  exact omega_antisymm v w

end V56

end HodgeReduction.Infrastructure
