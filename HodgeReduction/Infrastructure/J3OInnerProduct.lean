/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.V56Freudenthal
import Mathlib.Tactic.Positivity

/-!
# Positive-definiteness of the inner product on `J₃(𝕆)`

For `X ∈ J₃(𝕆)`:
```
   ⟨X, X⟩ = ξ₁² + ξ₂² + ξ₃² + 2·(n(x₁) + n(x₂) + n(x₃))
```
where `n(·)` is the octonion norm-squared. Each term is `≥ 0`, and the
total is `0` iff `X = 0`. So `⟨·, ·⟩` is positive-definite over `ℚ`,
realising `J₃(𝕆)` (compact real form) as a Euclidean Jordan algebra
with positive-definite trace form.

## Main results

* `J3O.innerProd_self : ⟨X, X⟩ = ξ₁² + ξ₂² + ξ₃² + 2·(n(x₁) + n(x₂) + n(x₃))`.
* `J3O.innerProd_self_nonneg : 0 ≤ ⟨X, X⟩`.
* `J3O.innerProd_self_eq_zero_iff : ⟨X, X⟩ = 0 ↔ X = 0`.

## Tags

J_3(O), inner product, positive-definite, Euclidean Jordan algebra
-/

namespace HodgeReduction.Infrastructure

namespace J3O

/-- Diagonal evaluation of the inner product: `⟨X, X⟩` is a sum of squares. -/
theorem innerProd_self (X : J3O) :
    innerProd X X = X.xi1^2 + X.xi2^2 + X.xi3^2
      + 2 * OctonionQ.normSq X.x1
      + 2 * OctonionQ.normSq X.x2
      + 2 * OctonionQ.normSq X.x3 := by
  unfold innerProd
  -- `2 * Re(x · conj x) = 2 * normSq x` via `mul_conj_self`.
  have h1 : OctonionQ.re (X.x1 * OctonionQ.conj X.x1) = OctonionQ.normSq X.x1 := by
    rw [OctonionQ.mul_conj_self]
    show OctonionQ.normSq X.x1 * 1 = OctonionQ.normSq X.x1
    ring
  have h2 : OctonionQ.re (X.x2 * OctonionQ.conj X.x2) = OctonionQ.normSq X.x2 := by
    rw [OctonionQ.mul_conj_self]
    show OctonionQ.normSq X.x2 * 1 = OctonionQ.normSq X.x2
    ring
  have h3 : OctonionQ.re (X.x3 * OctonionQ.conj X.x3) = OctonionQ.normSq X.x3 := by
    rw [OctonionQ.mul_conj_self]
    show OctonionQ.normSq X.x3 * 1 = OctonionQ.normSq X.x3
    ring
  rw [h1, h2, h3]
  ring

/-- The inner product is **positive semi-definite**: `⟨X, X⟩ ≥ 0`. -/
theorem innerProd_self_nonneg (X : J3O) : 0 ≤ innerProd X X := by
  rw [innerProd_self]
  have hxi : (0 : ℚ) ≤ X.xi1^2 + X.xi2^2 + X.xi3^2 := by positivity
  have hx1 : (0 : ℚ) ≤ 2 * OctonionQ.normSq X.x1 := by
    have := OctonionQ.normSq_nonneg X.x1; linarith
  have hx2 : (0 : ℚ) ≤ 2 * OctonionQ.normSq X.x2 := by
    have := OctonionQ.normSq_nonneg X.x2; linarith
  have hx3 : (0 : ℚ) ≤ 2 * OctonionQ.normSq X.x3 := by
    have := OctonionQ.normSq_nonneg X.x3; linarith
  linarith

/-- The inner product is **positive-definite**: `⟨X, X⟩ = 0 ↔ X = 0`. -/
theorem innerProd_self_eq_zero_iff (X : J3O) : innerProd X X = 0 ↔ X = 0 := by
  rw [innerProd_self]
  constructor
  · intro h
    -- Sum of non-negative terms is 0 ⇒ each term is 0.
    have hxi1_sq : X.xi1^2 = 0 := by
      nlinarith [sq_nonneg X.xi1, sq_nonneg X.xi2, sq_nonneg X.xi3,
                 OctonionQ.normSq_nonneg X.x1,
                 OctonionQ.normSq_nonneg X.x2,
                 OctonionQ.normSq_nonneg X.x3]
    have hxi2_sq : X.xi2^2 = 0 := by
      nlinarith [sq_nonneg X.xi1, sq_nonneg X.xi2, sq_nonneg X.xi3,
                 OctonionQ.normSq_nonneg X.x1,
                 OctonionQ.normSq_nonneg X.x2,
                 OctonionQ.normSq_nonneg X.x3]
    have hxi3_sq : X.xi3^2 = 0 := by
      nlinarith [sq_nonneg X.xi1, sq_nonneg X.xi2, sq_nonneg X.xi3,
                 OctonionQ.normSq_nonneg X.x1,
                 OctonionQ.normSq_nonneg X.x2,
                 OctonionQ.normSq_nonneg X.x3]
    have hx1_n : OctonionQ.normSq X.x1 = 0 := by
      nlinarith [sq_nonneg X.xi1, sq_nonneg X.xi2, sq_nonneg X.xi3,
                 OctonionQ.normSq_nonneg X.x1,
                 OctonionQ.normSq_nonneg X.x2,
                 OctonionQ.normSq_nonneg X.x3]
    have hx2_n : OctonionQ.normSq X.x2 = 0 := by
      nlinarith [sq_nonneg X.xi1, sq_nonneg X.xi2, sq_nonneg X.xi3,
                 OctonionQ.normSq_nonneg X.x1,
                 OctonionQ.normSq_nonneg X.x2,
                 OctonionQ.normSq_nonneg X.x3]
    have hx3_n : OctonionQ.normSq X.x3 = 0 := by
      nlinarith [sq_nonneg X.xi1, sq_nonneg X.xi2, sq_nonneg X.xi3,
                 OctonionQ.normSq_nonneg X.x1,
                 OctonionQ.normSq_nonneg X.x2,
                 OctonionQ.normSq_nonneg X.x3]
    refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
    · exact pow_eq_zero_iff (n := 2) (by norm_num) |>.mp hxi1_sq
    · exact pow_eq_zero_iff (n := 2) (by norm_num) |>.mp hxi2_sq
    · exact pow_eq_zero_iff (n := 2) (by norm_num) |>.mp hxi3_sq
    · exact (OctonionQ.normSq_eq_zero_iff X.x1).mp hx1_n
    · exact (OctonionQ.normSq_eq_zero_iff X.x2).mp hx2_n
    · exact (OctonionQ.normSq_eq_zero_iff X.x3).mp hx3_n
  · intro h; subst h; simp [OctonionQ.normSq]

end J3O

end HodgeReduction.Infrastructure
