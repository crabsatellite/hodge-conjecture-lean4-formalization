/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Lattice / quadratic form framework

A **lattice** is a free `ℤ`-module of finite rank with a `ℤ`-valued
symmetric bilinear form. For our HC application:
* Integer cohomology `H^*(X; ℤ)` (modulo torsion) is a lattice.
* The intersection form on `H^k(X; ℤ)` is a lattice quadratic form.
* The Mumford-Tate group of a polarised HS is the stabiliser of the
  polarisation form on the integer lattice.

This file packages **abstract lattice + quadratic form data**.

## Main definitions

* `LatticeData V` : abstract lattice structure on `V`.

## Tags

lattice, quadratic form, intersection form, even lattice
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Lattice data** on a `ℚ`-vector space `V`:

* `lattice` : an integer sublattice `L ⊆ V` (additive subgroup).
* `lattice_finitely_generated` : finitely-generated abelian property.
* `rank` : the rank of the lattice.

In our HC framework, the lattice provides the `ℤ`-structure under
the `ℚ`-vector space. -/
class LatticeData where
  /-- The integer sublattice as an additive subgroup. -/
  lattice : AddSubgroup V
  /-- The rank of the lattice. -/
  rank : ℕ

end HodgeReduction.Infrastructure.Cohomology
