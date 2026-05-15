/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Adelic group framework

For a reductive algebraic group `G` over `ℚ`, the **adelic points**
`G(𝔸)` is the restricted direct product of `G(ℚ_v)` over all places `v`
(including the real place `v = ∞`).

For a Shimura datum `(G, X)` with reflex field `E`, the **adelic
Shimura variety** is
```
Sh_K(G, X) := G(ℚ) \ X × G(𝔸^∞) / K
```
where `K ⊆ G(𝔸^∞)` is an open compact subgroup.

For our HC application: the adelic perspective is needed for:
* Hecke action on cohomology (P187).
* Strong approximation (`G(ℚ)` dense in `G(𝔸^∞)`).

This file packages **abstract adelic group data**.

## Main definitions

* `AdelicGroupData` : abstract adelic structure on a Shimura datum.

## Tags

adelic group, adelic Shimura variety, strong approximation
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Adelic group data**:

* `G_ad` : abstract type of `G(𝔸)`.
* `compact_open_subgroup_K` : a designated compact open subgroup `K`. -/
class AdelicGroupData where
  /-- The adelic group `G(𝔸)`. -/
  G_ad : Type
  /-- `G_ad` is a group. -/
  G_ad_group : Group G_ad
  /-- The compact open subgroup `K`. -/
  compact_open_subgroup_K : Type

end HodgeReduction.Infrastructure.Shimura
