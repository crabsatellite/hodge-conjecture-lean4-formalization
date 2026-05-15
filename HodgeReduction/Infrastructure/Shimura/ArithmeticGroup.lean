/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Group.Subgroup.Defs

/-!
# Arithmetic group framework

For a Shimura datum `(G, X)`, the **arithmetic groups** are subgroups
of `G(ℚ)` commensurable with `G(ℤ)` — typically **congruence subgroups**
`Γ_K := ker(G(ℤ) → G(ℤ/N))` for some level `N`.

The Shimura variety `S_Γ = Γ \ X` depends on the level structure
encoded by `Γ`. For our HC application, the EVII Shimura variety is
`Γ \ E_{7(-25)}/(E_6 × U(1))` for some appropriate `Γ ⊂ E_7(ℤ)`.

This file packages **abstract arithmetic group data**.

## Main definitions

* `ArithmeticGroupData` : abstract arithmetic group / congruence
  subgroup data.

## Tags

arithmetic group, congruence subgroup, level structure, Shimura variety
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Arithmetic group data** for a Shimura variety:

* `G` : the ambient algebraic group `G(ℚ)`.
* `Gamma` : the congruence subgroup `Γ ⊆ G`.
* `level` : the level (`N` in `Γ_N`).

We abstract `G` as a `Group` and `Γ` as a `Subgroup`. -/
class ArithmeticGroupData where
  /-- The ambient group `G(ℚ)`. -/
  G : Type
  /-- `G` is a group. -/
  G_group : Group G
  /-- The congruence subgroup `Γ`. -/
  Gamma : @Subgroup G G_group
  /-- The level `N` (for `Γ = Γ_N`). -/
  level : ℕ

end HodgeReduction.Infrastructure.Shimura
