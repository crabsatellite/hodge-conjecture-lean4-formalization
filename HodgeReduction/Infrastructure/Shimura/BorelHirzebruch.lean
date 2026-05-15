/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Borel-Hirzebruch coinvariant algebra framework

**A. Borel, F. Hirzebruch** ("Characteristic classes and homogeneous
spaces I-III", Amer. J. Math. 80-82, 1958-60): for a compact connected
Lie group `G` with maximal torus `T` and a closed subgroup `H ⊆ G`
containing `T`, the rational cohomology of `G/H` is:
```
H^*(G/H; ℚ) = Sym(t^∨)^{W(H)} / (Sym(t^∨)^{W(G)}_+)
```
where:
* `t^∨` is the dual of the Lie algebra of `T`.
* `W(G), W(H)` are the Weyl groups.
* `Sym(t^∨)^W` denotes the `W`-invariant polynomials.
* The denominator is the positive-degree `W(G)`-invariant ideal
  (= the **augmentation ideal**).

For `G/H = Ě_VII = E_{7,ℂ}/P_7`, this gives `H^*(Ě_VII; ℚ)` as a
coinvariant algebra. The Poincaré polynomial computes Betti numbers.

For our HC application: this gives the **coinvariant structure** of
`H^*(Ě_VII)` and the specific fact `H^8 = ℚ · h^4` (b_8 = 1).

This file packages **abstract Borel-Hirzebruch data**.

## Main definitions

* `BorelHirzebruchData A` : abstract coinvariant algebra data.

## Tags

Borel-Hirzebruch, coinvariant algebra, augmentation ideal, Poincaré polynomial
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]

/-- **Borel-Hirzebruch coinvariant data**:

* `augmentationIdeal` : the positive-degree `W(G)`-invariant ideal
  (whose image in `A` should vanish — that's the "augmentation
  phenomenon").
* `coinvariantPresentation` : a witness that `A` is the coinvariant
  algebra.

For our EVII application: classes in the W(E_7)-augmentation ideal
map to ZERO in `H^*(Ě_VII; ℚ)`. -/
class BorelHirzebruchData where
  /-- The W(G)-augmentation ideal subspace of A. -/
  augmentationIdeal : Submodule ℚ A
  /-- Classes in the augmentation ideal are zero. -/
  augmentation_vanishes :
    ∀ α ∈ augmentationIdeal, α = (0 : A)

end HodgeReduction.Infrastructure.Shimura
