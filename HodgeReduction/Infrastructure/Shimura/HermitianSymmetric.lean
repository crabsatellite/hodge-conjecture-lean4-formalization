/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Hermitian symmetric space framework

A **Hermitian symmetric space** is a connected Riemannian manifold
`M` with a `J`-invariant Riemannian metric, where `J` is an integrable
almost-complex structure such that for each `m ∈ M`, the geodesic
symmetry `s_m : M → M` is biholomorphic.

Equivalently: `M = G/K` with `G` a connected real Lie group, `K` a
compact subgroup, and `Z(K)^0` containing a 1-dim torus inducing `J`
on the tangent space.

For our HC application, the EVII Shimura variety is `Γ \ G/K` where
`G/K = E_{7(-25)} / (E_6 × U(1))` is the **EVII Hermitian symmetric
domain** of complex dimension 27.

This file packages **abstract Hermitian symmetric space data**.

## Main definitions

* `HermitianSymmetricData` : abstract Hermitian symmetric space.

## Tags

Hermitian symmetric space, EVII, exceptional, period domain
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Hermitian symmetric space data**:

* `D` : the underlying space (as abstract type).
* `complexDim` : the complex dimension.
* `isExceptional` : whether the space is exceptional (E_6 / E_7 / E_8 type).

For our EVII application: `complexDim = 27`, `isExceptional = true`. -/
class HermitianSymmetricData where
  /-- The Hermitian symmetric space. -/
  D : Type
  /-- The complex dimension. -/
  complexDim : ℕ
  /-- Whether the space is of exceptional type. -/
  isExceptional : Bool

namespace HermitianSymmetricData

variable [HermitianSymmetricData]

/-- The complex dimension is positive (a Hermitian symmetric space has
at least dim 1; for exceptional types, much higher). -/
def isNontrivial : Prop := 1 ≤ complexDim

end HermitianSymmetricData

end HodgeReduction.Infrastructure.Shimura
