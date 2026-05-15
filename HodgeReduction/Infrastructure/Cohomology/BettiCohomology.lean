/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Betti (singular) cohomology framework

For a complex algebraic variety `X(ℂ)`, the **Betti cohomology**
`H^*_B(X) := H^*_{sing}(X(ℂ); ℚ)` is the singular cohomology of the
underlying topological space.

For our HC application: `H^*_B(X)` is the **rational target** of the
cycle class map, and the place where Hodge classes live.

This file packages **abstract Betti cohomology data**.

## Main definitions

* `BettiCohomologyData A` : Betti cohomology structure (integer
  lattice + rational structure).

## Tags

Betti cohomology, singular cohomology, integer lattice, rational structure
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Betti cohomology data**:

* `Z_lattice` : the integer cohomology subspace (`H^*(X; ℤ) ⊆ A`).
* `Z_lattice_rank` : the rank of the integer lattice. -/
class BettiCohomologyData where
  /-- Image of integer cohomology in A. -/
  Z_lattice : AddSubgroup A
  /-- The rank of the integer lattice. -/
  Z_lattice_rank : ℕ

end HodgeReduction.Infrastructure.Cohomology
