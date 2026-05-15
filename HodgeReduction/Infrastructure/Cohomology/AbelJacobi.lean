/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Abel-Jacobi map framework

For a smooth projective complex variety `X` of complex dimension `n`,
the **Abel-Jacobi map** AJ : CH^p(X)_hom → J^p(X) maps homologically
trivial codim-`p` cycles to the `p`-th intermediate Jacobian:
```
J^p(X) := H^{2p-1}(X; ℂ) / (H^{2p-1}(X; ℤ) + F^p H^{2p-1}(X; ℂ)).
```

For `p = 1`, this is the classical Abel-Jacobi map to `J^1(X) = Pic^0(X)`,
giving `Pic(X) = NS(X) ⊕ Pic^0(X)`.

For higher `p`, `J^p(X)` is a complex torus (not algebraic in general).

For our HC application: the Abel-Jacobi map provides invariants for
distinguishing cycles modulo rational equivalence.

This file packages **abstract Abel-Jacobi map data**.

## Main definitions

* `AbelJacobiData` : abstract Abel-Jacobi map.

## Tags

Abel-Jacobi map, intermediate Jacobian, complex torus, Pic^0
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Abel-Jacobi data** at codim `p`:

* `IntermediateJacobian` : abstract complex torus `J^p(X)`.
* `dim_J_p` : real dimension of `J^p(X)`. -/
class AbelJacobiData (p : ℕ) where
  /-- Abstract intermediate Jacobian. -/
  IntermediateJacobian : Type
  /-- Real dimension. -/
  dim_J_p : ℕ

end HodgeReduction.Infrastructure.Cohomology
