/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# CM type / CM abelian variety framework

An **abelian variety with complex multiplication** (CM) is an
abelian variety `A` of dimension `g` such that `End^0(A) := End(A) ⊗ ℚ`
contains a CM field `F` of degree `2g`.

By Shimura-Taniyama: every CM abelian variety has a model over a number
field, and its arithmetic is governed by the **CM type** Φ — a set of
`g` embeddings of `F` into `ℂ` (out of `2g`) realising the action on
the holomorphic tangent space.

For our HC application, CM points on Shimura varieties parameterise
CM abelian varieties, and the Hodge conjecture is **known to hold for
CM abelian varieties** (Deligne 1982 — Hodge=AH, but explicitly NOT
algebraicity for general CM AVs above dim 4; specifically, the
codim-2 case on CM abelian fourfolds is open).

This file packages **abstract CM type data**.

## Main definitions

* `CMTypeData` : abstract CM type data for an abelian variety.

## Tags

CM type, complex multiplication, abelian variety, Shimura-Taniyama
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-- **CM type data** for an abelian variety:

* `CMField` : abstract CM field `F`.
* `genus` : the genus `g = dim_ℂ(A) = [F : ℚ] / 2`.

The full CM type Φ (a subset of `Hom(F, ℂ)`) is an additional structure
we abstract away for now. -/
class CMTypeData where
  /-- The CM field `F` (abstract; should be a number field of degree `2g`). -/
  CMField : Type
  /-- The genus of the abelian variety. -/
  genus : ℕ

end HodgeReduction.Infrastructure.AbelianVariety
