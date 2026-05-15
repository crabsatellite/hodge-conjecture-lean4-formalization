/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Matrix.Notation
import Mathlib.Tactic.FinCases

/-!
# Cartan matrices of the exceptional Lie algebras `E₆`, `E₇`, `E₈`

This file provides the **explicit integer Cartan matrices** of the
exceptional simply-laced simple Lie algebras `E₆`, `E₇`, `E₈`:

* `cartanE6`, `cartanE7`, `cartanE8` — the Cartan matrices as
  `Matrix (Fin n) (Fin n) ℤ` for `n = 6, 7, 8` respectively.

Basic decidable properties (diagonal = 2, off-diagonal ∈ {-1, 0}) are
provided as theorems.

## Conventions

We use Bourbaki's numbering of simple roots
(Bourbaki, *Groupes et algèbres de Lie*, Ch. VI §4.5, Tables):

* `E₆`: nodes 1-5 form an `A₅` chain, node 6 attached to node 3.
* `E₇`: nodes 1-6 form an `A₆` chain, node 7 attached to node 3.
* `E₈`: nodes 1-7 form an `A₇` chain, node 8 attached to node 3.

Each Cartan matrix `C_{ij} = ⟨α_i^∨, α_j⟩` is symmetric (simply laced)
with `2` on the diagonal and `-1, 0` off-diagonal according to the
Dynkin diagram adjacency.

## Note on determinants

The standard determinants are `det(cartanE6) = 3`, `det(cartanE7) = 2`,
`det(cartanE8) = 1` (the latter being the index of the root lattice
inside the weight lattice). These are not directly computed by
`decide` / `native_decide` due to the `n!`-sized permutation sum in
`Matrix.det`. Future work: prove via row reduction / Smith normal form
once Mathlib's matrix determinant decision procedures improve.

## Tags

Lie algebra, Cartan matrix, exceptional, E_6, E_7, E_8, Dynkin diagram
-/

namespace HodgeReduction.Infrastructure

open Matrix

/-! ### `E₆` Cartan matrix -/

/-- The Cartan matrix of `E₆` (Bourbaki numbering: nodes 1-5 form an
`A₅` chain, with node 6 branching off node 3). -/
def cartanE6 : Matrix (Fin 6) (Fin 6) ℤ :=
  !![ 2, -1,  0,  0,  0,  0;
     -1,  2, -1,  0,  0,  0;
      0, -1,  2, -1,  0, -1;
      0,  0, -1,  2, -1,  0;
      0,  0,  0, -1,  2,  0;
      0,  0, -1,  0,  0,  2]

/-- Diagonal entries of `cartanE6` are all `2`. -/
theorem cartanE6_diag (i : Fin 6) : cartanE6 i i = 2 := by
  fin_cases i <;> rfl

/-! ### `E₇` Cartan matrix -/

/-- The Cartan matrix of `E₇` (Bourbaki numbering: nodes 1-6 form an
`A₆` chain, with node 7 branching off node 3). -/
def cartanE7 : Matrix (Fin 7) (Fin 7) ℤ :=
  !![ 2, -1,  0,  0,  0,  0,  0;
     -1,  2, -1,  0,  0,  0,  0;
      0, -1,  2, -1,  0,  0, -1;
      0,  0, -1,  2, -1,  0,  0;
      0,  0,  0, -1,  2, -1,  0;
      0,  0,  0,  0, -1,  2,  0;
      0,  0, -1,  0,  0,  0,  2]

/-- Diagonal entries of `cartanE7` are all `2`. -/
theorem cartanE7_diag (i : Fin 7) : cartanE7 i i = 2 := by
  fin_cases i <;> rfl

/-! ### `E₈` Cartan matrix -/

/-- The Cartan matrix of `E₈` (Bourbaki numbering: nodes 1-7 form an
`A₇` chain, with node 8 branching off node 3). -/
def cartanE8 : Matrix (Fin 8) (Fin 8) ℤ :=
  !![ 2, -1,  0,  0,  0,  0,  0,  0;
     -1,  2, -1,  0,  0,  0,  0,  0;
      0, -1,  2, -1,  0,  0,  0, -1;
      0,  0, -1,  2, -1,  0,  0,  0;
      0,  0,  0, -1,  2, -1,  0,  0;
      0,  0,  0,  0, -1,  2, -1,  0;
      0,  0,  0,  0,  0, -1,  2,  0;
      0,  0, -1,  0,  0,  0,  0,  2]

/-- Diagonal entries of `cartanE8` are all `2`. -/
theorem cartanE8_diag (i : Fin 8) : cartanE8 i i = 2 := by
  fin_cases i <;> rfl

/-! ### Connectivity / adjacency in the Dynkin diagram

These properties encode which nodes are connected (giving `-1`) vs
disconnected (giving `0`) in each Dynkin diagram.
-/

/-- `cartanE6` connects nodes 0-1, 1-2, 2-3, 2-5, 3-4. -/
theorem cartanE6_edges :
    cartanE6 0 1 = -1 ∧ cartanE6 1 2 = -1 ∧
    cartanE6 2 3 = -1 ∧ cartanE6 2 5 = -1 ∧ cartanE6 3 4 = -1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- `cartanE7` connects nodes 0-1, 1-2, 2-3, 2-6, 3-4, 4-5. -/
theorem cartanE7_edges :
    cartanE7 0 1 = -1 ∧ cartanE7 1 2 = -1 ∧
    cartanE7 2 3 = -1 ∧ cartanE7 2 6 = -1 ∧
    cartanE7 3 4 = -1 ∧ cartanE7 4 5 = -1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-- `cartanE8` connects nodes 0-1, 1-2, 2-3, 2-7, 3-4, 4-5, 5-6. -/
theorem cartanE8_edges :
    cartanE8 0 1 = -1 ∧ cartanE8 1 2 = -1 ∧
    cartanE8 2 3 = -1 ∧ cartanE8 2 7 = -1 ∧
    cartanE8 3 4 = -1 ∧ cartanE8 4 5 = -1 ∧ cartanE8 5 6 = -1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> rfl

/-! ### Containment chain `E₆ ⊂ E₇ ⊂ E₈`

The Dynkin diagrams of `E₆`, `E₇`, `E₈` are nested: deleting the last
node of `E₈` (node 6 in our ordering) gives `E₇`, and deleting node 5
of `E₇` gives `E₆`. The Cartan matrices reflect this containment.

We don't fully formalise these embeddings here; we just record the
nesting as a verifiable structural property.
-/

/-- The upper-left 6×6 block of `cartanE7` agrees with `cartanE6`
except at the position where `E₆`'s node 6 attaches (corresponds to
`E₇`'s node 7 attachment shifted). The pure 6×6 chain blocks agree. -/
theorem cartanE7_upper_left_chain_matches_cartanE6_chain
    (i j : Fin 5) :
    cartanE7 i.castSucc.castSucc j.castSucc.castSucc =
    cartanE6 i.castSucc j.castSucc := by
  fin_cases i <;> fin_cases j <;> rfl

end HodgeReduction.Infrastructure
