/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Schubert cells / Schubert calculus framework

For a generalised flag variety `G/P` (e.g., the compact dual `Ě_VII =
E_{7,ℂ}/P_7`), the **Schubert cells** `X_w := B · wP/P` for `w ∈ W^P`
(minimal-length coset representatives) give a CW-decomposition:
```
G/P = ⨆_{w ∈ W^P} X_w
```

The **Schubert classes** `[X_w] ∈ H^{2 length(w)}(G/P; ℤ)` form a
basis of the rational cohomology, and the **Schubert calculus** is the
multiplication structure (Littlewood-Richardson / Pieri rules in
type A, and analogous formulas in other types).

For our HC application:
* On the compact dual `Ě_VII`, `H^8 = ℚ · h^4` (1-dim, Schubert class
  of the codim-4 cell).
* Borel-Hirzebruch / Bott-Borel-Weil give the bigrading.

This file packages **abstract Schubert calculus data**.

## Main definitions

* `SchubertCellData` : abstract Schubert data for a flag variety.

## Tags

Schubert cells, flag variety, Schubert calculus, Borel-Hirzebruch
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Schubert calculus data** for a flag variety with cohomology ring `A`:

* `length` : a length function on a Weyl group / index set.
* `schubertClass` : the Schubert classes as elements of `A`.

The Schubert classes form a basis of `H^*(G/P; ℚ)` as a `ℚ`-vector space.
For specific flag varieties, this captures the explicit CW-structure. -/
class SchubertCellData (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- Index set for Schubert cells (e.g., `W^P` for `G/P`). -/
  CellIndex : Type
  /-- Length function on cells (gives the cohomological degree
  `2 · length`). -/
  length : CellIndex → ℕ
  /-- The Schubert class associated to each cell. -/
  schubertClass : CellIndex → A

end HodgeReduction.Infrastructure.Shimura
