/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.HodgeStructure.MixedHodge

/-!
# Schmid's nilpotent orbit theorem framework

W. Schmid, "Variation of Hodge structure: the singularities of the
period mapping", Invent. Math. 22 (1973), 211-319, proves:

For a polarised VHS over a punctured disc `Δ^*` degenerating to a
limit at `0`, the **nilpotent orbit theorem** says:

1. There exists a "limiting period map" whose monodromy `T` around
   the puncture is unipotent (after passing to a finite cover).
2. The logarithm `N := log(T)` is nilpotent.
3. The **limiting mixed Hodge structure** at `0` is the MHS
   `(W_•(N), F^•_∞)` where `W_•(N)` is the monodromy weight
   filtration and `F^•_∞` is the limit of `F^•(t)` as `t → 0`.
4. The **nilpotent orbit approximation** `(W_•(N), exp(z·N) F^•_∞)`
   approximates the actual VHS near `0` to all orders.

For our HC application: Schmid 1973 + Cattani-Kaplan-Schmid 1986
(quantitative refinement) provides the "log-log boundary behaviour"
needed for L-block-diagonality of the Mumford extension.

This file packages **abstract nilpotent orbit data**.

## Main definitions

* `NilpotentOrbitData V n` : data for the limiting MHS + nilpotent
  operator.

## Tags

Schmid 1973, nilpotent orbit, limiting MHS, monodromy weight filtration
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Nilpotent orbit data** for a degenerating VHS:

* `N : V →ₗ[ℚ] V` : the nilpotent operator (`log T` for monodromy `T`).
* `N_nilpotent` : `N^k = 0` for some `k`.
* The associated MHS is the limiting mixed Hodge structure.

This abstracts Schmid's nilpotent orbit theorem at the carrier level. -/
class NilpotentOrbitData (n : ℕ) where
  /-- The nilpotent operator (= log of monodromy). -/
  N : V →ₗ[ℚ] V
  /-- The operator is nilpotent. -/
  N_nilpotent : ∃ k : ℕ, ∀ v : V, (N^k) v = 0

end HodgeReduction.Infrastructure.HodgeStructure
