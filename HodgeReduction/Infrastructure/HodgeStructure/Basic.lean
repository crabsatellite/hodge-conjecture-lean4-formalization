/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.LinearAlgebra.Dual
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.DirectSum.Module

/-!
# Pure rational Hodge structures of weight `n`

A **pure ℚ-Hodge structure of weight `n`** on a finite-dimensional
ℚ-vector space `V` is a direct-sum decomposition of the
complexification `V_ℂ := V ⊗_ℚ ℂ` into bigraded pieces:
```
V_ℂ = ⨁_{p+q=n} V^{p,q},   with V^{q,p} = complex-conjugate of V^{p,q}.
```

For us, the ℂ-conjugation aspect is non-trivial. To keep things
purely-algebraic over ℚ for now, we model the **decomposition** as a
direct-sum splitting at the ℚ-level into pieces indexed by the integers
`{0, 1, ..., n}` (with piece `p` representing the (p, n-p) Hodge piece).

This is sufficient for **Hodge-Tate** structures (where the bigrading
descends to ℚ — as it does for the V_56 representation of E_7 with
trivial Hodge involution in the centre).

## Main definitions

* `PureHodgeStructure V n` : a typeclass providing the decomposition
  `V = ⨁_{p=0..n} H^{p, n-p}`.

* `PureHodgeStructure.piece p` : the (p, n-p)-Hodge piece.

* `PureHodgeStructure.filt p` : the Hodge filtration `F^p V = ⨁_{i≥p} H^{i, n-i}`.

## Mathematical context

For our HC application, `V = V_56` with Hodge structure of weight `3`
(weight of the abelian variety associated to a Shimura point on `EVII`):
```
V_56,ℂ = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}    (4 pieces)
       =   ℂ    ⊕  J_3(O)_ℂ ⊕ J_3(O)_ℂ ⊕  ℂ
       =   1    +     27    +    27    +   1     = 56 dims
```

For our purposes (which are over ℚ), the decomposition descends to ℚ
because the Cartan involution gives the conjugation pairing
`V^{p,q} ↔ V^{q,p}` and the U(1)-symmetry of `EVII`.

## Tags

Hodge structure, bigrading, Hodge filtration, polarisation, VHS
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- A **pure ℚ-Hodge structure of weight `n`** on `V` is a
direct-sum decomposition `V = ⨁_{p=0..n} H^{p, n-p}` into `n+1` pieces
(indexed by `p ∈ {0, 1, ..., n}`).

This abstracts away the complexification/conjugation and works at the
ℚ-level where the Hodge involution is rational (the case relevant for
our V_56 application). -/
class PureHodgeStructure (n : ℕ) where
  /-- The (p, n-p)-Hodge piece for each `p ∈ {0, ..., n}`. -/
  piece : Fin (n + 1) → Submodule ℚ V
  /-- The pieces are independent: any `v ∈ ∑ piece p` decomposes
  uniquely into a sum of piece-elements. -/
  isInternal : DirectSum.IsInternal piece

namespace PureHodgeStructure

variable {V} {n : ℕ} [PureHodgeStructure V n]

/-- The (p, n-p)-Hodge piece, addressed by the integer `p`. -/
abbrev hodgePiece (p : Fin (n + 1)) : Submodule ℚ V := piece p

/-- The **Hodge filtration**: `F^p V = ⨁_{i ≥ p} H^{i, n-i}`.

Concretely, `F^p` contains all elements whose Hodge-piece-decomposition
has zero contribution from pieces `H^{i, n-i}` with `i < p`. -/
def filt (p : Fin (n + 1)) : Submodule ℚ V :=
  ⨆ (i : Fin (n + 1)) (_ : p.val ≤ i.val), piece i

/-- The Hodge piece `H^{p, n-p}` sits inside the filtration step `F^p`. -/
theorem piece_le_filt (p : Fin (n + 1)) :
    piece p ≤ filt (V := V) p := by
  refine le_iSup_of_le p ?_
  refine le_iSup_of_le ?_ le_rfl
  exact Nat.le_refl _

end PureHodgeStructure

end HodgeReduction.Infrastructure.HodgeStructure
