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

/-- **Cartan-1929 compact-dual cohomology identification** for a
Hermitian symmetric Lie pair `(g, K)` of compact type, with compact
dual `Ě = G_ℂ / P`.

É. Cartan (Rend. Circ. Mat. Palermo 53, 1929) proved
`H^*(g, K; ℂ) ≅ H^*(Ě; ℂ)` for the trivial `g`-module (modern
reference: Borel-Wallach, *Continuous Cohomology, Discrete Subgroups,
and Representations of Reductive Groups*, Ch. II §3.3 Cor. 3.4).

For `(g, K) = (e_{7(-25)}, E_6 × U(1))` with compact dual
`Ě_VII = E_{7,ℂ}/P_7`, the iso specialised at degree 8 identifies
the trivial-module `(g, K)`-cohomology image inside `H^8(S_Γ; ℂ)_G`
with `H^8(Ě_VII; ℂ) = ⟨h^4⟩`.

In the abstract `A`-model where `A` represents both sides of the
comparison, the identification manifests as the equality of two
distinguished `ℚ`-submodules:

* `H8` (from `CompactDualData`) — the compact-dual `H^8(Ě_VII; ℚ)`.
* `trivialModuleGK_H8` (this typeclass) — the trivial-module
  `(g, K)`-cohomology image at degree 8.

The Cartan iso then says these two submodules coincide. -/
class CartanCompactDualIso [CompactDualData A] where
  /-- The image of trivial-module `(g, K)`-cohomology at degree 8 inside
  `A`. In the EVII application this is the `K_∞`-finite trivial-module
  Cartan image landing in `H^8(S_Γ; ℂ)_G` via the Matsushima
  homomorphism. -/
  trivialModuleGK_H8 : Submodule ℚ A
  /-- **Cartan 1929** (Borel-Wallach Ch. II §3.3 Cor. 3.4) — the
  trivial-module `(g, K)`-cohomology at degree 8 equals the compact-dual
  cohomology `H^8(Ě_VII; ℚ)`. -/
  trivialModuleGK_H8_eq_compactDual_H8 :
    trivialModuleGK_H8 = CompactDualData.H8 (A := A)

/-- **Hodge-(4,4) bigrading of `H^8` of the compact dual** — typeclass-field
abstraction of the paper-stated `H8_compactDualEVII_is_44_bigrading`
carrier.

Bott 1957 + Borel-Hirzebruch 1958 §29-30 + Griffiths-Harris 1978 Ch. 1 §3:
for the compact dual `Ě_VII = E_{7,ℂ}/P_7` (a flag variety), the
cohomology `H^*(Ě_VII; ℚ)` is concentrated in `(p, p)` Hodge bigradings,
with `H^8 ⊆ H^{4,4}`. In the abstract `A`-model, this manifests as a
designated `(4,4)`-Hodge submodule `H44 : Submodule ℚ A` together with
the inclusion witness `H8_le_H44 : CompactDualData.H8 ≤ H44`.

The single-source citation (Bott 1957 Ann. Math. 66 / Borel-Hirzebruch
1958 AJM 80 §29-30 / Griffiths-Harris 1978 Ch. 1 §3) is retained as the
algebraic-geometric justification that such a `CompactDualH44Bigrading`
instance exists for `Ě_VII`. -/
class CompactDualH44Bigrading [CompactDualData A] where
  /-- The designated `(4,4)`-Hodge submodule inside `A`. -/
  H44 : Submodule ℚ A
  /-- `H^8(Ě_VII; ℚ)` lies in the `(4,4)`-Hodge piece (Bott /
  Borel-Hirzebruch flag-variety diagonal bigrading). -/
  H8_le_H44 : CompactDualData.H8 (A := A) ≤ H44

/-- **Hodge-(4,4) auto-G-invariance of the Freudenthal class on `S_Γ`** —
typeclass-field abstraction of the paper-stated
`freudenthal_H8_auto_G_invariant` carrier (Cat 3 workingAssumption per
`paper_hodge44_step_OPEN`).

Paper-stated reduction step (P61): given (i) the Borel-1974 stable-range
cohomology iso at deg 8 (= the j^8 injection is well-defined), (ii) the
Bott / Borel-Hirzebruch (4,4)-Hodge bigrading of `H^8(Ě_VII; ℚ)`, and
(iii) the Matsushima 1962 / Borel 1974 §3-§8 j^q-G-equivariance, the
descended Freudenthal class `j^8(h^4)` on `S_Γ` is automatically
G-invariant (it lies in the `target_invariants` submodule of the
Matsushima homomorphism).

In the abstract `A`-model (where `A` represents `H^*(S_Γ; ℚ)`), this
manifests as a designated `freudenthal_S_Gamma : A` (the descended
Freudenthal class) together with a designated G-invariants submodule
`G_invariants : Submodule ℚ A` (corresponding to
`MatsushimaData.target_invariants`), and the witness
`freudenthal_S_Gamma_is_G_invariant : freudenthal_S_Gamma ∈ G_invariants`.

The paper-stated reduction (`paper_hodge44_step_OPEN`) consumes three
abstract Cat 2 inputs (`cohomologyIso_at_deg8`,
`H8_compactDualEVII_is_44_bigrading`, `j_q_G_equivariance_principle`)
that, taken together, justify the existence of such an instance in the
concrete EVII application; the Lean-level claim records the abstract
typeclass-field witness `freudenthal_S_Gamma_is_G_invariant` that the
downstream `paper_iia_realization_OPEN` step actually consumes. -/
class FreudenthalH8GInvariance (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The descended Freudenthal class `j^8(h^4)` on `S_Γ`. -/
  freudenthal_S_Gamma : A
  /-- The designated G-invariants submodule of `H^*(S_Γ; ℚ)`. -/
  G_invariants : Submodule ℚ A
  /-- **Hodge-(4,4) auto-G-invariance** (paper-stated reduction step;
  paper master tex `paper_hodge44_step`): the descended Freudenthal
  class lies in the G-invariants submodule. This is the load-bearing
  fact consumed downstream by the (ii.a) realization argument. -/
  freudenthal_S_Gamma_is_G_invariant :
    freudenthal_S_Gamma ∈ G_invariants

/-- **(ii.a) Realization conclusion** — typeclass-field abstraction of the
paper-stated `freudenthal_realized_by_G_invariant` carrier (Cat 3
workingAssumption per `paper_iia_realization_OPEN`, Step C of the P71
3-sub-step decomposition).

Paper-stated reduction (Step C assembly): given Step A
(`H8_G_invariant_equals_cuspidal`: G-invariant `H^8` reduces to cuspidal
via Eisenstein vanishing + Franke 1998), Step B
(`H8_cuspidal_G_invariant_equals_trivial_module`: cuspidal G-invariant
`H^8` reduces to trivial-module Cartan image `⟨h^4⟩` via V-Z + KV +
Salamanca-Riba + V-Z holo-discrete + Cartan 1929), and the auto-G-invariance
(`freudenthal_H8_auto_G_invariant`), the descended Freudenthal class
`[q]` is realized as a scalar multiple of `j^8(h^4)` (= the G-invariant
cohomology image).

In the abstract `A`-model, this manifests as a designated descended
class `freudenthal_descended : A`, a designated G-invariant cohomology
submodule `G_invariant_cohomology : Submodule ℚ A`, and the witness
`freudenthal_realized : freudenthal_descended ∈ G_invariant_cohomology`. -/
class FreudenthalRealization (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The descended Freudenthal class on `S_Γ`. -/
  freudenthal_descended : A
  /-- The designated G-invariant cohomology submodule of `H^*(S_Γ; ℚ)`. -/
  G_invariant_cohomology : Submodule ℚ A
  /-- **(ii.a) Realization** (paper-stated Step C of the P71 3-sub-step
  decomposition): the descended Freudenthal class is realized as a
  G-invariant cohomology class on `S_Γ`. -/
  freudenthal_realized : freudenthal_descended ∈ G_invariant_cohomology

end HodgeReduction.Infrastructure.Shimura
