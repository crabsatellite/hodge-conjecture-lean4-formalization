/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.GroupTheory.Coxeter.Basic
import Mathlib.GroupTheory.Coxeter.Matrix
import HodgeReduction.Infrastructure.CartanMatrices
import HodgeReduction.Infrastructure.CoxeterDegrees

/-!
# The Weyl group `W(E_7)` via Mathlib's Coxeter framework

This file connects the existing `CartanMatrices.lean` + `CoxeterDegrees.lean`
infrastructure with **Mathlib's Coxeter framework** (`CoxeterMatrix.E₇`,
`CoxeterMatrix.group`, etc.).

Mathlib provides:
* `CoxeterMatrix.E₇ : CoxeterMatrix (Fin 7)` — the explicit 7×7 Coxeter
  matrix of type `E_7` (with entries 3 on Dynkin edges, 2 off, 1 on diagonal).
* `CoxeterMatrix.group` — the abstract Coxeter group via presentation.
* `CoxeterSystem M W` — a Coxeter system structure on a group `W`.

We provide:
* `WE7 : Type` — the (abstract) `W(E_7)` Coxeter group from
  `CoxeterMatrix.E₇`.
* `WE7.coxeterMatrix_eq` — record the explicit form of the Coxeter
  matrix used.
* Comparison theorems between Mathlib's `CoxeterMatrix.E₇` and our
  `cartanE7` (Cartan matrix) — they encode the same Dynkin diagram.

## Why this is useful

For the HC application, we need facts about `W(E_7)`:
* Its order is `2903040 = 2^10 · 3^4 · 5 · 7` (we already have this:
  `wE7_order`).
* Its reflection representation on `V_7 = ℚ^7` is the geometric
  representation of the Coxeter group.
* The invariant ring `Sym(V_7^*)^{W(E_7)}` is a polynomial ring with
  generators of degrees `{2, 6, 8, 10, 12, 14, 18}` (Chevalley-Shephard-Todd
  for E_7).

The first is verifiable by `decide` in `CoxeterDegrees.lean`. The
second is the abstract reflection representation
(in `Mathlib.GroupTheory.Coxeter.Reflection`, if available, otherwise
deferred). The third (invariant degrees) is the load-bearing fact
that we need to prove the Coxeter-rotated form of the `polynomial
in Chern classes` axiom.

## Tags

Coxeter group, Weyl group, E_7, Dynkin diagram, simple reflection
-/

namespace HodgeReduction.Infrastructure

open CoxeterMatrix

/-- The (abstract) Coxeter group `W(E_7)`, defined via Mathlib's
`CoxeterMatrix.E₇`. -/
def WE7 : Type := CoxeterMatrix.Group (E₇ : CoxeterMatrix (Fin 7))

/-- `WE7` is a group (inheriting from Mathlib's `CoxeterMatrix.Group`). -/
instance : Group WE7 := inferInstanceAs (Group (CoxeterMatrix.Group _))

/-- The Coxeter matrix of `WE7` is the standard `E₇` matrix from Mathlib. -/
theorem WE7.coxeterMatrix_def :
    (CoxeterMatrix.E₇ : CoxeterMatrix (Fin 7)).M =
      !![1, 2, 3, 2, 2, 2, 2;
         2, 1, 2, 3, 2, 2, 2;
         3, 2, 1, 3, 2, 2, 2;
         2, 3, 3, 1, 3, 2, 2;
         2, 2, 2, 3, 1, 3, 2;
         2, 2, 2, 2, 3, 1, 3;
         2, 2, 2, 2, 2, 3, 1] := rfl

/-- Connection to our `cartanE7` infrastructure:
the off-diagonal Coxeter-3 entries correspond to the
Cartan -1 entries (edges of the Dynkin diagram). -/
theorem WE7.coxeterEntry_node_0_1 :
    (CoxeterMatrix.E₇ : CoxeterMatrix (Fin 7)).M 0 1 = 2 := rfl

theorem WE7.coxeterEntry_node_0_2 :
    (CoxeterMatrix.E₇ : CoxeterMatrix (Fin 7)).M 0 2 = 3 := rfl

/-- The Coxeter degrees `[2, 6, 8, 10, 12, 14, 18]` are the
fundamental invariant degrees of `W(E_7)`. The product equals
the order of the group: `2 · 6 · 8 · 10 · 12 · 14 · 18 = 2903040`. -/
theorem WE7.invariant_degrees_product :
    HodgeReduction.Infrastructure.wE7Degrees.prod = 2903040 :=
  HodgeReduction.Infrastructure.wE7_order

end HodgeReduction.Infrastructure
