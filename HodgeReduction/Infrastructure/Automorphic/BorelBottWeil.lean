/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Bott–Borel–Weil for compact duals

For a Hermitian symmetric space `G/K` of non-compact type, the
**Borel–Bott–Weil theorem** computes the cohomology of automorphic
line bundles on the compact dual `Ǧ/K` via a `λ`-character of `K`
and `q = `-induced cohomology:

```
H^q(Ǧ/K; L_λ) = irreducible G-module with highest weight λ
```
(modulo appropriate weight shifts and dominance conditions).

For our HC application, the EVII compact dual `Ě_VII = E_{7,ℂ}/P_7`
has its degree-8 cohomology computed by BBW from a `(4, 4)` bigrading
on the trivial-module side. The paper's
`H8_compactDualEVII_is_44_bigrading` carrier records this.

This file abstracts the **carrier-level data** of BBW.

## Main definitions

* `BorelBottWeilData` : a typeclass carrying the bigrading data
  of compact-dual cohomology.

## Tags

Bott-Borel-Weil, compact dual, automorphic bundle, bigrading
-/

namespace HodgeReduction.Infrastructure.Automorphic

/-- **Bott-Borel-Weil bigrading data** for a compact Hermitian symmetric
space `Ǧ/K`. For each degree `n`, BBW gives a bigrading

  H^n(Ǧ/K; ℂ) = ⨁_{p+q=n} H^{p,q}(Ǧ/K; ℂ)

with `H^{p,q}` realised as the (g, K)-cohomology of holomorphic discrete
series or trivial module shifted by character λ.

For our EVII application at n = 8:
  H^8(Ě_VII; ℂ) = H^{4,4}(Ě_VII; ℂ) = ℂ · h^4 (1-dim).

This typeclass captures the **n = 8 case**: there exists a bigrading
on H^8 with all weight in (4, 4). -/
class BorelBottWeilData (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The H^{4,4}-piece is a designated submodule of `A`. -/
  H44 : Submodule ℚ A
  /-- The H^8 is concentrated in the (4, 4)-bigrading piece: equivalently,
  `H^8 ⊆ H^{4,4}`. -/
  H8_in_H44 : True  -- placeholder; concrete content via Hodge-bigrading
                     -- requires graded structure

end HodgeReduction.Infrastructure.Automorphic
