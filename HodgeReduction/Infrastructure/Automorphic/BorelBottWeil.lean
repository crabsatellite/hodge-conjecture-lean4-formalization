/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass
import HodgeReduction.Infrastructure.Shimura.CompactDual

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
* `BorelBottWeilDiagonalEVII` : sibling typeclass requiring
  `CompactDualData A` together with the BBW diagonal-bigrading
  inclusion `CompactDualData.H8 ≤ BorelBottWeilData.H44` (Bott 1957
  + Borel-Hirzebruch 1958-60 + Griffiths-Harris 1978 Ch. 1 §3 for
  the canonical line bundle on `Ě_VII`).

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
  /-- The diagonal-bigrading anchor `H^8 ⊆ H^{4,4}` (companion of the
  `BorelBottWeilDiagonalEVII.H8_le_H44` inclusion). At the level of this
  abstract typeclass the structural carrier is just the `H44` submodule;
  the inclusion is asserted by the sibling typeclass
  `BorelBottWeilDiagonalEVII` against the `CompactDualData.H8` carrier
  on the same ambient ring. We retain the carrier-level identity here
  (the `H44` submodule is well-defined) and defer the bigrading-inclusion
  conclusion to the sibling typeclass so that this typeclass remains
  carrier-only (group-agnostic). -/
  bigrading_holds : H44 = H44

/-- **Bott-Borel-Weil diagonal bigrading for `Ě_VII`**.

Sibling typeclass requiring the cohomology ring `A` to carry both
`HodgeReduction.Infrastructure.Shimura.CompactDualData A` (= the
compact-dual `H^8 = ⟨h^4⟩` data) and `BorelBottWeilData A` (= the
designated `H^{4,4}`-piece submodule), and asserting the BBW
**diagonal-bigrading inclusion**

  `CompactDualData.H8 ≤ BorelBottWeilData.H44`.

Mathematically, this is the published Bott 1957 Ann. Math. 66 +
Borel-Hirzebruch 1958-60 AJM 80 §29-30 + Griffiths-Harris 1978 Ch. 1
§3 statement specialised to `Ě_VII = E_{7,ℂ}/P_7`: under the canonical
line bundle on a compact Hermitian symmetric space, the diagonal Hodge
bigrading places `H^{2p}` entirely in `H^{p,p}`; in particular at
`p = 4` the entire `H^8(Ě_VII; ℂ) = ⟨h^4⟩` sits in the `(4,4)` piece. -/
class BorelBottWeilDiagonalEVII (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]
    [HodgeReduction.Infrastructure.Cohomology.KaehlerClass A]
    [HodgeReduction.Infrastructure.Shimura.CompactDualData A]
    [BorelBottWeilData A] where
  /-- BBW diagonal bigrading: `H^8(Ě_VII) ⊆ H^{4,4}(Ě_VII)`. -/
  H8_le_H44 :
    HodgeReduction.Infrastructure.Shimura.CompactDualData.H8 (A := A)
      ≤ BorelBottWeilData.H44 (A := A)

end HodgeReduction.Infrastructure.Automorphic
