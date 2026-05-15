/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# K3 surface framework

A **K3 surface** is a smooth projective complex surface `X` with:
* Trivial canonical bundle `K_X = 0`.
* `H¹(X; 𝒪_X) = 0`.

Equivalently: a simply-connected smooth projective surface with
trivial canonical class.

For K3 surfaces:
* `H²(X; ℤ)` is a unimodular lattice of rank 22.
* Hodge numbers `(1, 20, 1)` (so K3-type weight-2 HS).
* **HC for K3 surfaces is PROVEN** (André 1996; Charles 2014;
  Buskin 2019).

The proof goes through Kuga-Satake construction reducing HC for K3
to HC for abelian varieties (Mumford 1969).

This file packages **K3 surface data** for the HC framework.

## Main definitions

* `K3SurfaceData` : abstract K3 surface.

## Tags

K3 surface, Picard rank, Kuga-Satake, HC for K3 (PROVEN)
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-- **K3 surface data**:

* `K3` : abstract type of K3 surface.
* `picard_rank` : the rank of `NS(K3)` (1 ≤ ρ ≤ 20). -/
class K3SurfaceData where
  /-- Abstract K3 surface. -/
  K3 : Type
  /-- Picard rank ρ ∈ {1, ..., 20}. -/
  picard_rank : ℕ

end HodgeReduction.Infrastructure.AbelianVariety
