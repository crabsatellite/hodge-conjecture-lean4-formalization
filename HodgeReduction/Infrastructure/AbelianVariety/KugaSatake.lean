/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.AbelianVariety.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Kuga–Satake construction framework

The **Kuga–Satake construction** (Kuga-Satake 1967, Deligne 1971):

Given a polarised K3-type Hodge structure `(V, ψ)` of weight 2 with
Hodge numbers `(1, k, 1)`, the Clifford algebra `C(V, ψ)` has a
weight-1 sub-Hodge structure giving an abelian variety `A_KS` of
dimension `2^{k+1}` such that:
* `H¹(A_KS; ℚ) ⊇ V` as Hodge structures (Kuga-Satake embedding).
* Hodge conjecture for `V` ⟺ Hodge conjecture for the K3 surface
  associated to `V` (in the K3 case).

For our HC application: Kuga-Satake is the standard tool for
reducing HC for K3 surfaces to HC for abelian varieties.

This file packages **abstract Kuga-Satake data**.

## Main definitions

* `KugaSatakeData V` : the Kuga-Satake abelian variety data.

## Tags

Kuga-Satake construction, K3 surface, Clifford algebra,
weight-2 Hodge structure
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Kuga-Satake data**:

* `KS_AV` : abstract type of the Kuga-Satake abelian variety.
* `KS_dim` : its complex dimension.

For weight-2 K3-type HS on `V` with `dim V = k + 2` (Hodge numbers
`(1, k, 1)`), `KS_dim = 2^{k+1}`. -/
class KugaSatakeData where
  /-- The Kuga-Satake abelian variety. -/
  KS_AV : Type
  /-- The complex dimension `2^{k+1}`. -/
  KS_dim : ℕ

end HodgeReduction.Infrastructure.AbelianVariety
