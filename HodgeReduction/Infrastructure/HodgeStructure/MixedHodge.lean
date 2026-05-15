/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic

/-!
# Mixed Hodge structures (Deligne 1971, 1974)

A **mixed Hodge structure** (MHS) on a `ℚ`-vector space `V` consists
of:
* An increasing **weight filtration** `W_• : W_{-1} ⊆ W_0 ⊆ W_1 ⊆ … ⊆ V`.
* A **Hodge filtration** `F^•` on `V_ℂ = V ⊗_ℚ ℂ`.
* For each `n`, the graded piece `Gr_n^W := W_n / W_{n-1}` carries a
  pure Hodge structure of weight `n` (with `F^•` induced from `V_ℂ`).

Mixed Hodge structures arise on cohomology of:
* Open/non-compact varieties (Deligne 1971).
* Singular varieties (Deligne 1974, Saito 1988 mixed Hodge modules).
* Toroidal boundary of Shimura varieties.

For our HC application (Mumford-Tate reduction), MHS on boundary
cohomology of EVII toroidal compactification is the input for
Schmid's nilpotent orbit theorem + Cattani-Kaplan-Schmid degeneration.

This file packages **abstract MHS data**.

## Main definitions

* `MixedHodgeStructure V` : weight + Hodge filtration data on `V`.

## Tags

mixed Hodge structure, weight filtration, Deligne, Schmid, nilpotent orbit
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Mixed Hodge structure data** on `V`:

* `W : ℤ → Submodule ℚ V` : the weight filtration `W_n ⊆ V`.
* `Hodge_on_gr : ∀ n, PureHodgeStructure (W_n / W_{n-1}) n` : pure HS
  on each weight-`n` graded piece.

For our purposes, we abstract the **filtration data** and the
pure-HS-on-graded-pieces requirement. -/
class MixedHodgeStructureData where
  /-- The weight filtration. -/
  W : ℤ → Submodule ℚ V
  /-- The filtration is increasing. -/
  W_monotone : ∀ {m n : ℤ}, m ≤ n → W m ≤ W n
  /-- The filtration is exhaustive: `⋃_n W_n = V`. -/
  W_exhaustive : ⨆ n, W n = ⊤
  /-- The filtration is bounded below: `W_n = 0` for `n ≪ 0`. -/
  W_bounded_below : ∃ N : ℤ, ∀ n < N, W n = ⊥

end HodgeReduction.Infrastructure.HodgeStructure
