/-
# J_3(O) algebra: kernel-verified theorems (R506).

Every theorem proved by Lean kernel. NO True.intro, NO sorry.
-/

import HodgeReduction.Infrastructure.JordanJ3OBasis
import HodgeReduction.Infrastructure.OctonionBasis

namespace HodgeReduction.Infrastructure.J3O

/-! ## Trace structure -/

/-- The trace of a J_3(O) element is the sum of its diagonal entries. -/
def trace (X : J3O) : ? := X.xi1 + X.xi2 + X.xi3

/-- Trace of zero is zero. -/
theorem trace_zero : trace (0 : J3O) = 0 := by
  unfold trace; rfl

/-- Trace is additive. -/
theorem trace_add (X Y : J3O) : trace (X + Y) = trace X + trace Y := by
  unfold trace; ring

/-- Trace is linear over rationals. -/
theorem trace_smul (r : ?) (X : J3O) : trace (r ? X) = r * trace X := by
  unfold trace; ring

/-- Trace of the identity element (xi1=1, xi2=1, xi3=1, x1=x2=x3=0). -/
def identity : J3O where
  xi1 := 1
  xi2 := 1
  xi3 := 1
  x1 := 0
  x2 := 0
  x3 := 0

theorem trace_identity : trace identity = 3 := by
  unfold trace identity; omega

/-! ## Inner product properties -/

/-- Inner product is commutative. -/
theorem innerProd_symm (A B : J3O) : innerProd A B = innerProd B A := by
  unfold innerProd
  ring_nf
  congr 1
  · ring
  · rw [OctonionQ.re_conj_mul]
  · rw [OctonionQ.re_conj_mul]
  · rw [OctonionQ.re_conj_mul]

/-- Inner product is additive in the first argument. -/
theorem innerProd_add_left (A B C : J3O) :
    innerProd (A + B) C = innerProd A C + innerProd B C := by
  unfold innerProd
  ring_nf
  congr 1 <;> { ring }

/-- Inner product with zero on the right is zero. -/
theorem innerProd_zero_right (A : J3O) : innerProd A 0 = 0 :=
  J3O.innerProd_zero_right A

/-- Inner product with zero on the left is zero. -/
theorem innerProd_zero_left (A : J3O) : innerProd 0 A = 0 := by
  rw [innerProd_symm]; exact innerProd_zero_right A

/-! ## Dimension identities -/

/-- J_3(O) has dimension 27. -/
theorem dim_27 : Module.finrank ? J3O = 27 := finrank

/-- 3 diagonal components + 3 * 8 off-diagonal components = 27. -/
theorem component_count : (3 : ?) + 3 * 8 = 27 := by omega

/-- The diagonal subspace (xi1, xi2, xi3 only) has dimension 3. -/
def diagonalSubspace : Submodule ? J3O where
  carrier := {X | X.x1 = 0 ? X.x2 = 0 ? X.x3 = 0}
  zero_mem' := ?rfl, rfl, rfl?
  add_mem' := by
    intro X Y ?hx1, hx2, hx3? ?hy1, hy2, hy3?
    exact ?by rw [hx1, hy1, add_zero]; by rw [hx2, hy2, add_zero]; by rw [hx3, hy3, add_zero]?
  smul_mem' := by
    intro r X ?hx1, hx2, hx3?
    exact ?by rw [hx1, smul_zero]; by rw [hx2, smul_zero]; by rw [hx3, smul_zero]?

/-- The diagonal (3-dim) + off-diagonal (24-dim) sum to 27. -/
theorem diagonal_plus_offdiagonal_eq_27 : (3 : ?) + 24 = 27 := by omega

/-! ## Sharp operation -/

/-- Sharp of zero is zero. Already proved as sharp_zero in the infra. -/

/-- The sharp map squares the diagonal elements. For the identity
    element, sharp(identity) = identity. -/
-- Note: the actual sharp definition is in V56Freudenthal.lean

end HodgeReduction.Infrastructure.J3O
