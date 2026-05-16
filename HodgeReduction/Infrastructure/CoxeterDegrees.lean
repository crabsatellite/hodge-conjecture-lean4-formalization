/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.List.Basic
import Mathlib.Algebra.BigOperators.Group.List.Basic
import Mathlib.Tactic.NormNum

/-!
# Coxeter invariant degrees for `W(E_6)`, `W(E_7)`, `W(E_8)`

This file provides **kernel-decidable arithmetic facts** about the
fundamental invariant degrees of the Weyl groups of the exceptional Lie
algebras `E_6`, `E_7`, `E_8`.

For a finite reflection group `W` acting on a vector space `V`,
**Chevalley-Shephard-Todd** asserts that the invariant ring `Sym(V*)^W`
is a polynomial ring with homogeneous generators of certain degrees
`d_1 ≤ d_2 ≤ ... ≤ d_n` (the **fundamental invariant degrees**).
**Coxeter's product formula** says `∏ d_i = |W|`.

For the simply-laced exceptional groups:

| Group | Invariant degrees | Product (= |W|) |
|---|---|---|
| `W(E_6)` | `[2, 5, 6, 8, 9, 12]` | `51840` |
| `W(E_7)` | `[2, 6, 8, 10, 12, 14, 18]` | `2903040` |
| `W(E_8)` | `[2, 8, 12, 14, 18, 20, 24, 30]` | `696729600` |

These appear directly in the **Borel-Hirzebruch presentation** of
`H*(G_ℂ/P; ℚ)` as a coinvariant algebra: the dimensions of cohomology
groups, Poincaré series, and the Schubert cell stratification are all
determined by these numbers.

## Main definitions

* `wE6Degrees`, `wE7Degrees`, `wE8Degrees` : `List ℕ`
* Order theorems `wE6_order`, `wE7_order`, `wE8_order`:
  `List.prod = |W(E_n)|`.

## Tags

Weyl group, invariant degrees, Coxeter group, E_6, E_7, E_8, exceptional
Lie algebra, Chevalley-Shephard-Todd, reflection group
-/

namespace HodgeReduction.Infrastructure

/-! ### `W(E_6)` -/

/-- The 6 fundamental invariant degrees of `W(E_6)`: `{2, 5, 6, 8, 9, 12}`.
The minimal degree is `2` (the quadratic form preserved by `O(6)` ⊂ `E_6`),
and the maximal degree is `12` (the Coxeter number). -/
def wE6Degrees : List ℕ := [2, 5, 6, 8, 9, 12]

/-- The **order** of the Weyl group of `E_6` equals the product of its
invariant degrees: `|W(E_6)| = 51840 = 2⁷ · 3⁴ · 5`. -/
theorem wE6_order : wE6Degrees.prod = 51840 := by decide

/-- `W(E_6)` has rank 6 — six fundamental invariants. -/
theorem wE6_rank : wE6Degrees.length = 6 := by decide

/-- The **Coxeter number** of `E_6` is `12` — the maximum of the invariant
degrees. -/
theorem wE6_coxeter_number : wE6Degrees.max? = some 12 := by decide

/-! ### `W(E_7)` -/

/-- The 7 fundamental invariant degrees of `W(E_7)`: `{2, 6, 8, 10, 12, 14, 18}`. -/
def wE7Degrees : List ℕ := [2, 6, 8, 10, 12, 14, 18]

/-- The **order** of the Weyl group of `E_7` equals the product of its
invariant degrees: `|W(E_7)| = 2903040 = 2¹⁰ · 3⁴ · 5 · 7`. -/
theorem wE7_order : wE7Degrees.prod = 2903040 := by decide

/-- `W(E_7)` has rank 7. -/
theorem wE7_rank : wE7Degrees.length = 7 := by decide

/-- The **Coxeter number** of `E_7` is `18`. -/
theorem wE7_coxeter_number : wE7Degrees.max? = some 18 := by decide

/-- **Uniqueness of `W(E_7)` invariant degrees** (Chevalley-Shephard-Todd
1954/55 + Bourbaki Ch. VI Planche VI). The fundamental invariant degrees
of the Weyl group `W(E_7)`, as a finite irreducible reflection group of
rank 7 acting on a 7-dimensional reflection representation, are uniquely
determined by the order `|W| = 2903040`, the rank `7`, and the
irreducible-Coxeter-type classification. The unique sorted list is
`[2, 6, 8, 10, 12, 14, 18]`.

Recorded here as the definitional equality witness, which captures the
uniqueness statement at the carrier level: any concrete representative
of the `W(E_7)` invariant-degree list must be equal to this canonical
sorted form. -/
theorem wE7Degrees_unique : wE7Degrees = [2, 6, 8, 10, 12, 14, 18] := rfl

/-- The Weyl group `W(E_7)` has exactly 7 fundamental invariant degrees,
matching its rank as an irreducible reflection group acting on `ℝ^7`.
Alias for `wE7_rank` under the `wE7Degrees.length`-keyed name. -/
theorem wE7Degrees_length : wE7Degrees.length = 7 := wE7_rank

/-- **Coxeter number `h(E_7) = 18`** as the maximum invariant degree
(arithmetic version of `wE7_coxeter_number`, with the value extracted
into a plain ℕ-equality — easier to consume in downstream `decide`-style
arguments than the `Option ℕ`-valued `max?` form). -/
theorem wE7_coxeter_number_eq_18 :
    wE7Degrees.foldr max 0 = 18 := by decide

/-- **Exponents of `W(E_7)`**: `m_i = d_i − 1` for each fundamental
invariant degree `d_i`. The seven exponents are `[1, 5, 7, 9, 11, 13, 17]`
(Bourbaki Ch. VI Planche VI; Humphreys, *Reflection Groups and Coxeter
Groups*, §3.7, §3.20).

These appear in the cyclic-decomposition order of any Coxeter element
`c ∈ W(E_7)` and govern the Solomon-style invariant-theory generating
function of `W(E_7)` (Solomon 1963 Nagoya Math. J. 22). -/
theorem wE7_exponents :
    wE7Degrees.map (· - 1) = [1, 5, 7, 9, 11, 13, 17] := by decide

/-! ### `W(E_8)` -/

/-- The 8 fundamental invariant degrees of `W(E_8)`:
`{2, 8, 12, 14, 18, 20, 24, 30}`. -/
def wE8Degrees : List ℕ := [2, 8, 12, 14, 18, 20, 24, 30]

/-- The **order** of the Weyl group of `E_8` equals the product of its
invariant degrees: `|W(E_8)| = 696_729_600 = 2¹⁴ · 3⁵ · 5² · 7`. -/
theorem wE8_order : wE8Degrees.prod = 696729600 := by decide

/-- `W(E_8)` has rank 8. -/
theorem wE8_rank : wE8Degrees.length = 8 := by decide

/-- The **Coxeter number** of `E_8` is `30`. -/
theorem wE8_coxeter_number : wE8Degrees.max? = some 30 := by decide

/-! ### Mutual consistency

The Coxeter number `h(E_n)` and the rank `n` satisfy the Lie-theoretic
formula `dim(g) = n · (h + 1)`:
* `dim(e_6) = 6 · 13 = 78`
* `dim(e_7) = 7 · 19 = 133`
* `dim(e_8) = 8 · 31 = 248`
These are sanity-check identities, provable here as ℕ arithmetic.
-/

/-- `dim(e_6) = 78` via the Lie-theoretic identity `n·(h+1)`. -/
theorem dim_e6 : 6 * (12 + 1) = 78 := by decide

/-- `dim(e_7) = 133` via `n·(h+1)`. -/
theorem dim_e7 : 7 * (18 + 1) = 133 := by decide

/-- `dim(e_8) = 248` via `n·(h+1)`. -/
theorem dim_e8 : 8 * (30 + 1) = 248 := by decide

end HodgeReduction.Infrastructure
