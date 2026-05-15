/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Reductive algebraic group framework

A **reductive algebraic group** over a field `k` is a connected
linear algebraic group with trivial unipotent radical. For `k = ℝ`
(or `ℂ`), reductive groups include `GL_n, SL_n, Sp_{2n}, O_n,
E_6, E_7, E_8`, etc.

For our HC application:
* `E_{7(-25)}` : real reductive group, real form of `E_7(ℂ)`.
* Levi component `E_6 × U(1) ⊂ E_{7(-25)}`.
* The Mumford-Tate group `MT ⊂ Sp(V_56, ω)` is reductive.

This file packages **abstract reductive algebraic group data**.

## Main definitions

* `ReductiveGroupData` : abstract reductive group.

## Tags

reductive group, algebraic group, real form, Lie type
-/

namespace HodgeReduction.Infrastructure.LieAlgebra

/-- **Reductive algebraic group data**:

* `G` : abstract group type.
* `complexDim` : the complex dimension of `G(ℂ)`.
* `realRank` : the real rank (`= dim` of maximal split torus over ℝ).
* `realForm` : a `String` tag identifying the real form (e.g., "split",
  "compact", "Hermitian"). -/
class ReductiveGroupData where
  /-- Abstract group type. -/
  G : Type
  /-- `G` is a group. -/
  G_group : Group G
  /-- Complex dimension of `G(ℂ)`. -/
  complexDim : ℕ
  /-- Real rank. -/
  realRank : ℕ
  /-- Type tag for the real form. -/
  realForm : String

end HodgeReduction.Infrastructure.LieAlgebra
