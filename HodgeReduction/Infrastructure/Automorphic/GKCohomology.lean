/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# `(g, K)`-cohomology framework

For a real Lie group `G` with maximal compact subgroup `K`, a
`(g, K)`-module is a `g`-module with a compatible `K`-action.
The **`(g, K)`-cohomology** `H^*(g, K; V)` is the derived functor of
`Hom_{(g, K)}(triv, -)` and computes Lie-algebra cohomology with
`K`-action.

For our HC application:
* `(g, K)`-cohomology of automorphic representations gives the
  G-invariant cuspidal cohomology of Shimura varieties.
* Cartan-1929 identifies trivial-module `(g, K)`-cohomology with
  the de Rham cohomology of the compact dual.

This file packages **abstract `(g, K)`-cohomology data**.

## Main definitions

* `GKCohomologyData` : abstract (g, K)-cohomology framework.

## Tags

(g, K)-cohomology, Lie algebra cohomology, Borel-Wallach, Cartan 1929
-/

namespace HodgeReduction.Infrastructure.Automorphic

/-- **(g, K)-cohomology data**:

* `Module` : abstract type of (g, K)-modules.
* `cohomology` : function giving H^k(g, K; V) as a Q-vector space.

For Cartan 1929: `cohomology k triv = H^k(compact dual)`. -/
class GKCohomologyData where
  /-- Abstract (g, K)-module type. -/
  Module : Type
  /-- The (g, K)-cohomology functor at each degree. -/
  cohomology : ℕ → Module → Type

end HodgeReduction.Infrastructure.Automorphic
