/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Finset.Card
import Mathlib.Data.Finset.Prod
import Mathlib.Data.Finset.Range
import Mathlib.Data.Int.Defs
import Mathlib.Tactic.NormNum

/-!
# Borel-Hirzebruch Poincaré polynomial of `Ě_VII`

For the compact Hermitian symmetric space `Ě_VII = E_{7,ℂ}/P_7`
(complex dim 27), the Borel-Hirzebruch coinvariant-algebra
presentation gives the Hilbert series
```
P(t) = (1 - t^20)(1 - t^28)(1 - t^36) / [(1 - t^2)(1 - t^10)(1 - t^18)].
```

The denominator `1 / [(1-t^2)(1-t^10)(1-t^18)]` is the generating
function of the partition counter
```
p(k) = #{ (a, b, c) ∈ ℕ³ : 2a + 10b + 18c = k }.
```

The full numerator expansion is
```
(1 - t^20)(1 - t^28)(1 - t^36) =
  1 - t^20 - t^28 - t^36 + t^48 + t^56 + t^64 - t^84.
```

So the `k`-th Betti number is the inclusion-exclusion combination
```
b_k = p(k) − p(k−20) − p(k−28) − p(k−36)
            + p(k−48) + p(k−56) + p(k−64)
            − p(k−84).
```

This file provides the **kernel-decidable** ℕ-valued partition counter
`eviiPartitionCount`, the ℤ-valued Betti polynomial `eviiBetti`, and
the table of values for even `k ∈ {0, 2, 4, 6, 8, 10, 12, 14, 16, 18,
20, 22, 24, 26, 28}`.

## Tags

EVII, Borel-Hirzebruch, Poincaré polynomial, Betti numbers,
Chevalley-Shephard-Todd, Hermitian symmetric space, E_7
-/

namespace HodgeReduction.Infrastructure

/-- **Partition counter** for the denominator
`1 / [(1-t^2)(1-t^10)(1-t^18)]`.

`eviiPartitionCount k` = the number of `(a, b, c) ∈ ℕ³` such that
`2a + 10b + 18c = k`.

Equivalently, the coefficient of `t^k` in the formal power series
`1 / [(1-t^2)(1-t^10)(1-t^18)] ∈ ℤ⟦t⟧`.

The bounds `a ≤ k/2`, `b ≤ k/10`, `c ≤ k/18` are tight: any solution
to `2a + 10b + 18c = k` automatically satisfies these inequalities.
This keeps the search space small enough for `decide` at the modest
degrees `k ≤ 30` we need. -/
def eviiPartitionCount (k : ℕ) : ℕ :=
  ((Finset.range (k / 2 + 1)) ×ˢ
   (Finset.range (k / 10 + 1)) ×ˢ
   (Finset.range (k / 18 + 1))).filter
    (fun p : ℕ × ℕ × ℕ => 2 * p.1 + 10 * p.2.1 + 18 * p.2.2 = k) |>.card

/-- Helper: `eviiPartitionCount (k − d)` if `k ≥ d`, else `0`.
Lets us write `eviiBetti` as a single expression without conditional
guards on every term. ℕ-truncating subtraction makes
`eviiPartitionCount (k - d)` for `k < d` automatically `0` here as
well (since `k - d = 0` and `eviiPartitionCount 0 = 1` would NOT be
what we want), so we explicitly guard with the inequality. -/
def eviiPartitionShift (k d : ℕ) : ℕ :=
  if d ≤ k then eviiPartitionCount (k - d) else 0

/-- **EVII Borel-Hirzebruch Betti number** at degree `k`.

Defined as the inclusion-exclusion combination
```
b_k = p(k) − p(k−20) − p(k−28) − p(k−36)
            + p(k−48) + p(k−56) + p(k−64)
            − p(k−84),
```
where `p(·) = eviiPartitionCount`.

Encoded over `ℤ` to allow the inclusion-exclusion subtractions
without proving non-negativity at the definitional layer (the
non-negativity holds because each `b_k` is a true Betti number, but
that's a downstream theorem, not a definitional invariant). -/
def eviiBetti (k : ℕ) : ℤ :=
  (eviiPartitionCount k : ℤ)
    - (eviiPartitionShift k 20 : ℤ)
    - (eviiPartitionShift k 28 : ℤ)
    - (eviiPartitionShift k 36 : ℤ)
    + (eviiPartitionShift k 48 : ℤ)
    + (eviiPartitionShift k 56 : ℤ)
    + (eviiPartitionShift k 64 : ℤ)
    - (eviiPartitionShift k 84 : ℤ)

/-! ### Partition counter base table

The first few values of `eviiPartitionCount k` for even `k ∈ [0, 28]`,
verified by `decide` against the bounded-Finset enumeration. -/

theorem eviiPartitionCount_0 : eviiPartitionCount 0 = 1 := by decide
theorem eviiPartitionCount_2 : eviiPartitionCount 2 = 1 := by decide
theorem eviiPartitionCount_4 : eviiPartitionCount 4 = 1 := by decide
theorem eviiPartitionCount_6 : eviiPartitionCount 6 = 1 := by decide
theorem eviiPartitionCount_8 : eviiPartitionCount 8 = 1 := by decide
theorem eviiPartitionCount_10 : eviiPartitionCount 10 = 2 := by decide
theorem eviiPartitionCount_12 : eviiPartitionCount 12 = 2 := by decide
theorem eviiPartitionCount_14 : eviiPartitionCount 14 = 2 := by decide
theorem eviiPartitionCount_16 : eviiPartitionCount 16 = 2 := by decide
theorem eviiPartitionCount_18 : eviiPartitionCount 18 = 3 := by decide
theorem eviiPartitionCount_20 : eviiPartitionCount 20 = 4 := by decide
theorem eviiPartitionCount_22 : eviiPartitionCount 22 = 4 := by decide
theorem eviiPartitionCount_24 : eviiPartitionCount 24 = 4 := by decide
theorem eviiPartitionCount_26 : eviiPartitionCount 26 = 4 := by decide
theorem eviiPartitionCount_28 : eviiPartitionCount 28 = 5 := by decide

/-! ### `eviiBetti` table

Below degree `20` the inclusion-exclusion correction is identically
`0`, so `eviiBetti k = eviiPartitionCount k` for `k ∈ [0, 18]`. From
degree `20` onward the correction `−p(k−20)` activates; from degree
`28` the second correction `−p(k−28)` activates; etc.

These are the Betti numbers of the compact Hermitian symmetric space
`Ě_VII = E_{7,ℂ}/P_7` (complex dim 27), provable here as kernel-pure
ℤ-arithmetic. -/

theorem eviiBetti_0 : eviiBetti 0 = 1 := by decide
theorem eviiBetti_2 : eviiBetti 2 = 1 := by decide
theorem eviiBetti_4 : eviiBetti 4 = 1 := by decide
theorem eviiBetti_6 : eviiBetti 6 = 1 := by decide
theorem eviiBetti_8 : eviiBetti 8 = 1 := by decide
theorem eviiBetti_10 : eviiBetti 10 = 2 := by decide
theorem eviiBetti_12 : eviiBetti 12 = 2 := by decide
theorem eviiBetti_14 : eviiBetti 14 = 2 := by decide
theorem eviiBetti_16 : eviiBetti 16 = 2 := by decide
theorem eviiBetti_18 : eviiBetti 18 = 3 := by decide
theorem eviiBetti_20 : eviiBetti 20 = 3 := by decide
theorem eviiBetti_22 : eviiBetti 22 = 3 := by decide
theorem eviiBetti_24 : eviiBetti 24 = 3 := by decide
theorem eviiBetti_26 : eviiBetti 26 = 3 := by decide
theorem eviiBetti_28 : eviiBetti 28 = 3 := by decide

/-- **EVII Betti table** (compact Hermitian symmetric space
`Ě_VII = E_{7,ℂ}/P_7` in even degrees from `0` to `28`):
the list of pairs `(k, b_k)` for `k ∈ {0, 2, 4, …, 28}`, each
inclusion-exclusion-evaluated and `decide`-verified above. -/
theorem eviiBetti_table :
    eviiBetti 0 = 1 ∧
    eviiBetti 2 = 1 ∧
    eviiBetti 4 = 1 ∧
    eviiBetti 6 = 1 ∧
    eviiBetti 8 = 1 ∧
    eviiBetti 10 = 2 ∧
    eviiBetti 12 = 2 ∧
    eviiBetti 14 = 2 ∧
    eviiBetti 16 = 2 ∧
    eviiBetti 18 = 3 ∧
    eviiBetti 20 = 3 ∧
    eviiBetti 22 = 3 ∧
    eviiBetti 24 = 3 ∧
    eviiBetti 26 = 3 ∧
    eviiBetti 28 = 3 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals decide

/-- **Compact-dual `H^8` is one-dimensional.** Specialisation of
`eviiBetti_table` at `k = 8`: the eighth Betti number of `Ě_VII` is
`1`, matching the `CompactDualData.H8 = ℚ · h^4` claim downstream. -/
theorem eviiBetti_at_H8_eq_one : eviiBetti 8 = 1 := eviiBetti_8

/-- **Odd-degree vanishing snapshots** (sanity sample):
the Borel-Hirzebruch presentation forces every odd-degree Betti to
vanish (the variety is paved by even-codim Schubert cells), and the
partition counter at any odd `k` is `0` because `2a + 10b + 18c` is
always even. We verify three odd-degree snapshots by `decide`. -/
theorem eviiBetti_odd_1 : eviiBetti 1 = 0 := by decide
theorem eviiBetti_odd_3 : eviiBetti 3 = 0 := by decide
theorem eviiBetti_odd_5 : eviiBetti 5 = 0 := by decide

end HodgeReduction.Infrastructure
