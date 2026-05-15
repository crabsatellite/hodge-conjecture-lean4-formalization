/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Tate module framework

For an abelian variety `A` over a field `k` and a prime `ℓ ≠ char(k)`,
the **`ℓ`-adic Tate module** is
```
T_ℓ(A) := lim_n A[ℓ^n] (limit of `ℓ`-power torsion).
```
It is a free `ℤ_ℓ`-module of rank `2g` (where `g = dim A`). Over an
algebraic closure `k̄`, it carries a Galois action `Gal(k̄/k) → GL(T_ℓ A)`.

The rational Tate module `V_ℓ(A) := T_ℓ(A) ⊗_{ℤ_ℓ} ℚ_ℓ` is the étale
cohomology `H¹_ét(A_{k̄}; ℚ_ℓ)^∨`.

For our HC application:
* The Tate conjecture (≈ étale analog of HC) is about the Galois
  action on `V_ℓ(A)`.
* For CM abelian varieties: the Tate module has CM-action structure.

This file packages **abstract Tate module data**.

## Main definitions

* `TateModuleData` : abstract `ℓ`-adic Tate module.

## Tags

Tate module, ℓ-adic cohomology, Galois representation, Tate conjecture
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-- **Tate module data**:

* `T_ell` : abstract `ℓ`-adic Tate module type.
* `rank` : the rank (= 2g where g = dim A). -/
class TateModuleData where
  /-- Abstract Tate module. -/
  T_ell : Type
  /-- Rank of the Tate module = 2g. -/
  rank : ℕ

end HodgeReduction.Infrastructure.AbelianVariety
