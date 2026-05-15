/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56Freudenthal
import HodgeReduction.Infrastructure.V56Basis
import HodgeReduction.Infrastructure.J3OInnerProduct
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

/-- The symplectic form `ω` is **non-degenerate**: if `ω(v, w) = 0` for all `w`,
then `v = 0`. This realises `V₅₆` as a 56-dim symplectic `ℚ`-vector space,
matching the inclusion `E₇ ⊂ Sp(56, ℚ)`.

The proof tests `v` against the four Hodge-piece projectors:
* `ω(v, (0, 0, 0, 1)) = v.a ⇒ v.a = 0`;
* `ω(v, (1, 0, 0, 0)) = -v.b ⇒ v.b = 0`;
* `ω(v, (0, A', 0, 0)) = -⟨v.B, A'⟩` for all `A'`, with positive-definite
  `⟨·, ·⟩` ⇒ `v.B = 0`;
* `ω(v, (0, 0, B', 0)) = ⟨v.A, B'⟩` ⇒ `v.A = 0`. -/
theorem omega_nondegenerate (v : V56) (hv : ∀ w : V56, omega v w = 0) :
    v = 0 := by
  -- Test against (0, 0, 0, 1): omega v (0,0,0,1) = v.a.
  have ha : v.a = 0 := by
    have h := hv ⟨0, 0, 0, 1⟩
    unfold omega at h
    show v.a = 0
    rw [show ((⟨0, 0, 0, 1⟩ : V56).a : ℚ) = 0 from rfl,
        show ((⟨0, 0, 0, 1⟩ : V56).b : ℚ) = 1 from rfl,
        show ((⟨0, 0, 0, 1⟩ : V56).A : J3O) = 0 from rfl,
        show ((⟨0, 0, 0, 1⟩ : V56).B : J3O) = 0 from rfl,
        J3O.innerProd_zero_right, J3O.innerProd_zero_right] at h
    linarith
  -- Test against (1, 0, 0, 0): omega v (1,0,0,0) = -v.b.
  have hb : v.b = 0 := by
    have h := hv ⟨1, 0, 0, 0⟩
    unfold omega at h
    show v.b = 0
    rw [show ((⟨1, 0, 0, 0⟩ : V56).a : ℚ) = 1 from rfl,
        show ((⟨1, 0, 0, 0⟩ : V56).b : ℚ) = 0 from rfl,
        show ((⟨1, 0, 0, 0⟩ : V56).A : J3O) = 0 from rfl,
        show ((⟨1, 0, 0, 0⟩ : V56).B : J3O) = 0 from rfl,
        J3O.innerProd_zero_right, J3O.innerProd_zero_right] at h
    linarith
  -- Test against (0, 0, v.A, 0): omega v (0, 0, v.A, 0) = innerProd v.A v.A.
  have hA : v.A = 0 := by
    have h := hv ⟨0, 0, v.A, 0⟩
    unfold omega at h
    -- h : v.a * 0 - v.b * 0 + <v.A, v.A> - <v.B, 0> = 0
    show v.A = 0
    rw [show ((⟨0, 0, v.A, 0⟩ : V56).a : ℚ) = 0 from rfl,
        show ((⟨0, 0, v.A, 0⟩ : V56).b : ℚ) = 0 from rfl,
        show ((⟨0, 0, v.A, 0⟩ : V56).A : J3O) = 0 from rfl,
        show ((⟨0, 0, v.A, 0⟩ : V56).B : J3O) = v.A from rfl,
        J3O.innerProd_zero_right] at h
    have key : J3O.innerProd v.A v.A = 0 := by linarith
    exact (J3O.innerProd_self_eq_zero_iff v.A).mp key
  -- Test against (0, v.B, 0, 0): omega v (0, v.B, 0, 0) = -innerProd v.B v.B.
  have hB : v.B = 0 := by
    have h := hv ⟨0, v.B, 0, 0⟩
    unfold omega at h
    show v.B = 0
    rw [show ((⟨0, v.B, 0, 0⟩ : V56).a : ℚ) = 0 from rfl,
        show ((⟨0, v.B, 0, 0⟩ : V56).b : ℚ) = 0 from rfl,
        show ((⟨0, v.B, 0, 0⟩ : V56).A : J3O) = v.B from rfl,
        show ((⟨0, v.B, 0, 0⟩ : V56).B : J3O) = 0 from rfl,
        J3O.innerProd_zero_right] at h
    have key : J3O.innerProd v.B v.B = 0 := by linarith
    exact (J3O.innerProd_self_eq_zero_iff v.B).mp key
  refine V56.ext ?_ ?_ ?_ ?_
  · exact ha
  · exact hA
  · exact hB
  · exact hb

end V56

end HodgeReduction.Infrastructure
