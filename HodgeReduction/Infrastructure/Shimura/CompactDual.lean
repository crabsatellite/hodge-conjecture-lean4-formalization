/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Compact dual cohomology and the Borel–Hirzebruch presentation

For a Hermitian symmetric space `G/K` of non-compact type, its
**compact dual** `Ǧ/K` is the corresponding compact Hermitian
symmetric space. By a classical theorem (Borel-Hirzebruch 1958-1960):
```
H^*(Ǧ/K; ℚ) = Sym(t^∨)^{W(L)} / (Sym(t^∨)^{W(G)}_+)
```
(the **coinvariant algebra**), where:

* `W(L)` is the Weyl group of the Levi `K`.
* `W(G)` is the Weyl group of the full group `G`.
* `Sym(t^∨)^{W(G)}_+` is the positive-degree `W(G)`-invariant ideal.

For our application (EVII):

* `G = E_{7(-25)}`, `K = E_6 × U(1)`.
* Compact dual `Ě_VII = E_{7,ℂ}/P_7`.
* The Borel-Hirzebruch presentation gives `H^*(Ě_VII; ℚ)` as a
  `ℚ[h]/(h^{28})`-like polynomial ring (modulo invariant ideal).

This file abstracts the **carrier-level data** of the compact dual
cohomology in a way useful for the HC argument.

## Main definitions

* `CompactDualData A` : a typeclass providing the Kähler class `h`
  and the data that `H^8` is one-dimensional spanned by `h^4`.

## Tags

compact dual, Borel-Hirzebruch, coinvariant algebra, Hermitian symmetric
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]
    [HodgeReduction.Infrastructure.Cohomology.KaehlerClass A]

/-- **Compact-dual cohomology data** for a Hermitian symmetric space.

For `EVII = Ě_VII` specifically:

* The Kähler class `h ∈ A` (inherited from `KaehlerClass A`).
* The structure of `H^8` as `ℚ · h^4` (one-dim, spanned by `h^4`).

The 1-dim property is the **Poincaré polynomial** fact:
the Hilbert series of `H^*(Ě_VII; ℚ)` is
`(1-t^{20})(1-t^{28})(1-t^{36}) / [(1-t^2)(1-t^{10})(1-t^{18})]`,
giving Betti number `b_8 = 1` (so `H^8 = ℚ · h^4`).

For the abstract framework, this manifests as a designated submodule
`H8 : Submodule ℚ A` with the property `H8 = Submodule.span ℚ {h^4}`. -/
class CompactDualData where
  /-- The 8-th cohomology subspace `H^8 ⊆ A` (in our flat A-model, this
  is just a designated submodule). -/
  H8 : Submodule ℚ A
  /-- `H^8` is spanned by `h^4` as a ℚ-vector space (1-dim claim). -/
  H8_eq_span_h_pow_4 :
    H8 = Submodule.span ℚ {(HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h : A) ^ 4}

namespace CompactDualData

variable {A} [CompactDualData A]

/-- The Kähler class power `h^4` is algebraic, by `KaehlerClass.h_pow_4_isAlgebraic`. -/
theorem h_pow_4_isAlgebraic :
    HodgeReduction.Infrastructure.Cohomology.CohomologyRing.IsAlgebraic
      ((HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h : A) ^ 4) :=
  HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h_pow_4_isAlgebraic

/-- Every class in `H^8` is algebraic — because `H^8 = span{h^4}` and
`h^4` is algebraic, by `isAlgebraic_smul` closure. -/
theorem H8_classes_are_algebraic (α : A) (hα : α ∈ H8 (A := A)) :
    HodgeReduction.Infrastructure.Cohomology.CohomologyRing.IsAlgebraic α := by
  rw [H8_eq_span_h_pow_4] at hα
  rw [Submodule.mem_span_singleton] at hα
  obtain ⟨r, hr⟩ := hα
  rw [← hr]
  exact HodgeReduction.Infrastructure.Cohomology.CohomologyRing.isAlgebraic_smul
    r h_pow_4_isAlgebraic

end CompactDualData

end HodgeReduction.Infrastructure.Shimura
