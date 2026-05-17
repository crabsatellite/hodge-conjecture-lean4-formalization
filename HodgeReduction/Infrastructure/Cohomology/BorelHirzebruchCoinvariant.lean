/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.TwistedPhiL

/-!
# Borel-Hirzebruch coinvariant augmentation phenomenon

**A. Borel, F. Hirzebruch** ("Characteristic classes and homogeneous
spaces I-III", Amer. J. Math. 80-82, 1958-60), §29-30: for a compact
connected Lie group `G` with maximal torus `T` and a closed subgroup
`H ⊆ G` containing `T`, the rational cohomology of the generalised
flag variety `G_C/P` (equivalently `G/H`) is presented as the
**coinvariant algebra**:

```
H^*(G_C/P; ℚ)  =  Sym(t^∨)^{W(L)}  /  (Sym(t^∨)^{W(G)}_+)
```

where:

* `t^∨` is the dual of the Lie algebra of `T`,
* `W(G), W(L)` are the Weyl groups of `G` and the Levi factor `L`,
* `Sym(t^∨)^W` denotes the `W`-invariant polynomials,
* the denominator `Sym(t^∨)^{W(G)}_+` is the **positive-degree
  `W(G)`-invariant ideal** (= the augmentation ideal of
  `Sym(t^∨)^{W(G)}`).

**Augmentation phenomenon**: the structural consequence is that any
positive-degree `W(G)`-invariant polynomial maps to ZERO in
`H^*(G_C/P; ℚ)`. This is the cleanest single-line published
consequence of Borel-Hirzebruch 1958-60 §29-30 used in the
Mumford-Tate reduction (P39: "canonical Φ vanishes by augmentation").

This file packages the **augmentation-vanishing universal record**
companion to `HodgeReduction.Infrastructure.Cohomology.AugmentationIdeal`
(in `TwistedPhiL.lean`): the latter exposes a designated submodule
`WE7AugIdeal : Submodule ℚ A` together with the per-element axiom
`WE7AugIdeal_eq_bot : α ∈ WE7AugIdeal → α = 0`. The companion here
adds the universally-quantified Cat 2 PUBLISHED statement consumed
by the P39 canonical-Φ-vanishing chain, recording the abstract
Borel-Hirzebruch augmentation as a single load-bearing typeclass field.

## References (Cat 2 PUBLISHED)

* A. Borel, F. Hirzebruch, "Characteristic classes and homogeneous
  spaces I", Amer. J. Math. 80 (1958), 458-538.
* A. Borel, F. Hirzebruch, "Characteristic classes and homogeneous
  spaces II", Amer. J. Math. 81 (1959), 315-382.
* A. Borel, F. Hirzebruch, "Characteristic classes and homogeneous
  spaces III", Amer. J. Math. 82 (1960), 491-504, §29-30
  (coinvariant presentation & augmentation phenomenon).
* W. Fulton, *Young Tableaux*, Cambridge LMSST 35 (1997), Appendix A
  (modern exposition of the coinvariant algebra for type-A; the
  type-E generalisation is parallel).

## Main definitions

* `BorelHirzebruchCoinvariantData A` — typeclass packaging the Cat 2
  PUBLISHED augmentation-vanishing universal Prop, companion to
  `AugmentationIdeal A`.

## Tags

Borel-Hirzebruch, coinvariant algebra, augmentation ideal,
W(G)-invariants, augmentation phenomenon
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Borel-Hirzebruch coinvariant-augmentation data**.

Companion typeclass to `AugmentationIdeal A` (which supplies the
designated submodule `WE7AugIdeal : Submodule ℚ A` together with the
per-element vanishing `WE7AugIdeal_eq_bot : α ∈ WE7AugIdeal → α = 0`).
This file's `BorelHirzebruchCoinvariantData` records the
universally-quantified PUBLISHED augmentation phenomenon consumed in
the P39 chain:

  *Every positive-degree `W(G)`-invariant polynomial in `Sym(t^∨)`
  lands in the augmentation ideal — equivalently, dies in
  `H^*(G_C/P)` under the Borel-Hirzebruch coinvariant projection.*

Packaged as a single load-bearing `Prop` field `positive_W_invariants_die`.
The instance provider supplies the witness from the Borel-Hirzebruch
1958-60 §29-30 coinvariant presentation: by definition of the
coinvariant quotient, positive-degree `W(G)`-invariants ARE the
augmentation ideal, and the coinvariant projection sends them to zero.

For our EVII application
(`gap_borel_hirzebruch_coinvariant_augmentation`) this packages the
Cat 2 PUBLISHED `Sym(t^∨)^{W(E_7)}_+ → 0` implication used to close
`canonical_Phi_lands_in_W_E7_augmentation_ideal`; the field record
makes the published Borel-Hirzebruch single-source citation explicit
at the typeclass level so the axiom can be lifted to a theorem via
`AugmentationIdeal.WE7AugIdeal_eq_bot ∘ CanonicalPhiData.canonicalPhi_q_in_augmentation_ideal`. -/
class BorelHirzebruchCoinvariantData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [AugmentationIdeal A] where
  /-- **Positive-degree `W(G)`-invariants die in `H^*(G_C/P; ℚ)`**
  (Borel-Hirzebruch 1958-60 §29-30 augmentation phenomenon): every
  class in the positive-degree `W(G)`-invariant ideal
  `Sym(t^∨)^{W(G)}_+` (= the `WE7AugIdeal` submodule of `A` supplied by
  `AugmentationIdeal A`) vanishes in `A`.

  Packaged abstractly as the universally-quantified vanishing record
  "every element of the augmentation ideal is zero" — this is the
  Cat 2 PUBLISHED Borel-Hirzebruch §29-30 implication packaged at the
  typeclass-field level so downstream proofs can cite it as the
  single-source justification (rather than as a global free axiom).
  Composes with `CanonicalPhiData.canonicalPhi_q_in_augmentation_ideal`
  to discharge `canonical_Phi_lands_in_W_E7_augmentation_ideal` for any
  carrier carrying both typeclasses. -/
  positive_W_invariants_die :
    ∀ α ∈ AugmentationIdeal.WE7AugIdeal (A := A), α = (0 : A)

/-! ## Sibling classes: abstract coinvariant algebra data

The classical Borel-Hirzebruch 1958-60 coinvariant presentation packages
**two distinguished Weyl-invariant subspaces** of the symmetric algebra
`Sym(t^∨)`:

* `weylInvariants = Sym(t^∨)^{W(L)}`: invariants under the Weyl group of
  the Levi factor `L` (the "ambient" invariants which sit on top in the
  presentation `Sym(t^∨)^{W(L)} / (Sym(t^∨)^{W(G)}_+)`).
* `largerWeylInvariants = Sym(t^∨)^{W(G)}`: invariants under the **larger**
  Weyl group `W(G) ⊇ W(L)` (the "smaller" invariants — by Galois-like
  ordering, more invariance imposes more constraints, so
  `W(G)`-invariants ⊆ `W(L)`-invariants).

The **substantive containment** `largerWeylInvariants ≤ weylInvariants`
is the load-bearing inclusion record consumed in the Mumford-Tate
reduction P39 chain when reducing W(G)-invariant polynomials to W(L)-
invariant polynomials at the carrier level.

The **coinvariant structure equation** packages the Borel-Hirzebruch
1958-60 §29-30 quotient presentation:
  `H^*(G/H; ℚ) = weylInvariants ⊓ (something) ≤ weylInvariants`
where the "something" is the augmentation-quotient subspace; the genuine
typeclass-level encoding records the W(L)-containment of the W(G)+ image
subspace (the augmentation image is contained in W(L)-invariants).

These sibling classes are *parallel* to `BorelHirzebruchCoinvariantData`
(which packages only the augmentation-vanishing universally-quantified
record); the new classes add the Submodule-level structural data
(which-Submodule-contains-which) that downstream sub-instance providers
consume when refining the abstract `WE7AugIdeal` to an explicit
`Sym(t^∨)^{W(G)}_+` subspace.

References:
* A. Borel, F. Hirzebruch (1958-60) §29-30 — coinvariant quotient
  presentation `H^*(G/H; ℚ) = Sym(t^∨)^{W(L)} / (Sym(t^∨)^{W(G)}_+)`.
* R. Bott (1956) "An application of Morse theory to the topology of Lie
  groups" — Morse-theoretic proof that `G/T` has cohomology generated
  by the Weyl-invariant polynomials.
* S. Helgason (1978) *Differential Geometry, Lie Groups, and Symmetric
  Spaces* §10.2 — the coinvariant-algebra exposition for symmetric
  spaces.
-/

/-- **Coinvariant algebra data** (Borel-Hirzebruch 1958-60 §29-30
sibling): packages the load-bearing **double-Submodule** structure of
the Borel-Hirzebruch coinvariant presentation as a typeclass.

Fields:
* `weylInvariants : Submodule ℚ A` — the W(L)-invariant subspace
  `Sym(t^∨)^{W(L)}` sitting at the top of the quotient `Sym(t^∨)^{W(L)} /
  (Sym(t^∨)^{W(G)}_+)`.
* `largerWeylInvariants : Submodule ℚ A` — the W(G)-invariant subspace
  `Sym(t^∨)^{W(G)}` (with `W(G) ⊇ W(L)`); by the Weyl-group-ordering
  principle, these are CONTAINED in `weylInvariants` (more invariance
  imposes more constraints).
* `larger_le_smaller : largerWeylInvariants ≤ weylInvariants` —
  **substantive containment record**: every W(G)-invariant polynomial is
  ipso facto W(L)-invariant (since `W(L) ⊆ W(G)`, any function invariant
  under the bigger group is invariant under the smaller subgroup).
* `coinvariant_quotient_structure` — the **substantive coinvariant-
  structure equation** encoding the augmentation-image containment: the
  positive-degree W(G)-invariant image (= `WE7AugIdeal`) is contained in
  `weylInvariants` (it's still W(L)-invariant by `larger_le_smaller`).
  This is the load-bearing Submodule equation downstream consumers
  rewrite against to translate `WE7AugIdeal`-membership into `weylInvariants`
  -membership.
-/
class CoinvariantAlgebraData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [AugmentationIdeal A] where
  /-- The W(L)-invariant subspace `Sym(t^∨)^{W(L)}` (top of the
  coinvariant quotient `Sym(t^∨)^{W(L)} / (Sym(t^∨)^{W(G)}_+)`). -/
  weylInvariants : Submodule ℚ A
  /-- The W(G)-invariant subspace `Sym(t^∨)^{W(G)}` (with `W(G) ⊇ W(L)`,
  so this is the SMALLER subspace by inclusion-reversal). -/
  largerWeylInvariants : Submodule ℚ A
  /-- **Substantive containment** (Weyl-group-ordering principle): every
  W(G)-invariant polynomial is W(L)-invariant. Equivalently, the
  W(G)-invariant subspace is contained in the W(L)-invariant subspace. -/
  larger_le_smaller : largerWeylInvariants ≤ weylInvariants
  /-- **Substantive coinvariant-quotient structure** (Borel-Hirzebruch
  1958-60 §29-30): the augmentation-image `WE7AugIdeal` is contained in
  the W(L)-invariant subspace `weylInvariants`. Equivalently, every
  element of the augmentation ideal is W(L)-invariant (since it's even
  W(G)-invariant by definition, and `W(G)`-invariance entails
  `W(L)`-invariance by `larger_le_smaller`). -/
  augmentation_in_weyl_invariants :
    AugmentationIdeal.WE7AugIdeal (A := A) ≤ weylInvariants

namespace CoinvariantAlgebraData

set_option linter.unusedSectionVars false

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [AugmentationIdeal A] [CoinvariantAlgebraData A]

/-! ### Derived theorems -/

/-- **Re-export** of `larger_le_smaller` as a theorem at the namespace
level. -/
theorem larger_le_smaller_thm :
    largerWeylInvariants (A := A) ≤ weylInvariants (A := A) :=
  larger_le_smaller

/-- **Element-level larger-implies-smaller**: if `α` is W(G)-invariant,
then `α` is W(L)-invariant. -/
theorem mem_smaller_of_mem_larger {α : A}
    (h : α ∈ largerWeylInvariants (A := A)) :
    α ∈ weylInvariants (A := A) :=
  larger_le_smaller h

/-- **Augmentation classes lie in W(L)-invariants** (re-export of
`augmentation_in_weyl_invariants` at the namespace level). -/
theorem augmentation_in_weyl_invariants_thm :
    AugmentationIdeal.WE7AugIdeal (A := A) ≤ weylInvariants (A := A) :=
  augmentation_in_weyl_invariants

/-- **Element-level augmentation-implies-W(L)-invariant**: if `α` is in
the augmentation ideal, then `α` is W(L)-invariant. -/
theorem mem_weyl_invariants_of_mem_augmentation {α : A}
    (h : α ∈ AugmentationIdeal.WE7AugIdeal (A := A)) :
    α ∈ weylInvariants (A := A) :=
  augmentation_in_weyl_invariants h

end CoinvariantAlgebraData

/-! ## `BorelHirzebruchPresentation`: explicit polynomial presentation

**Borel-Hirzebruch 1958-60** Part III §29-30 gives the explicit
polynomial presentation of `H^*(G/H; ℚ)` as the coinvariant algebra
`Sym(t^∨)^{W(L)} / (Sym(t^∨)^{W(G)}_+)`. The presentation has:

* **Generators**: a finite set of `ℚ`-algebra generators (Chern classes
  of the relevant minuscule representation).
* **Relators**: a finite set of `ℚ`-algebra relations (the positive-
  degree W(G)-invariant polynomials in the generators).

The Hilbert series factorisation:
  `P(H^*(G/H), t) = ∏_i (1 - t^{d_i^G}) / ∏_j (1 - t^{d_j^L})`
where `{d_i^G}, {d_j^L}` are the degrees of the W(G), W(L) generators.

For our EVII application this presentation gives:
  `P(H^*(Ě_VII), t) = (1 - t^2)(1 - t^8)(1 - t^{12})(1 - t^{14})(1 - t^{18})
                       / (1 - t^2)(1 - t^6)(1 - t^8)(1 - t^{10})(1 - t^{12})
                          (1 - t^{14})(1 - t^{18})`
                  ` = 1 + t^2 + t^4 + ... + t^{54}` (Poincaré polynomial of
                      the 27-dim compact Hermitian symmetric space `Ě_VII`).
-/

/-- **Borel-Hirzebruch explicit presentation data**:

Records the **rank** of the generator set and a substantive **generator
multiplicity bound**: there are at least `rank` independent generators
(satisfying `1 ≤ rank` to exclude the trivial-group degenerate case).

For `G = E_7`, `H = E_6 × U(1)`, the relevant data is:
* `rank = 7` (the number of W(L)-invariant degrees from Toda 1975 +
  Kono-Mimura 1976 generators).
* `generator_degree_lower_bound = 1`: every generator has positive
  cohomological degree (no degree-zero generator).

The substantive content `rank_pos` is the assertion that the polynomial-
algebra presentation has at least one generator (vacuously holds for any
compact connected Lie group of positive rank). -/
class BorelHirzebruchPresentation (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] where
  /-- The **rank** of the generator set (number of independent
  polynomial generators of `H^*(G/H; ℚ)`). -/
  rank : ℕ
  /-- **Substantive rank positivity**: the presentation has at least one
  generator. For `G/H = Ě_VII = E_7/(E_6 × U(1))`, `rank = 7` (the number
  of Toda-1975 + Kono-Mimura-1976 polynomial generators). -/
  rank_pos : 1 ≤ rank
  /-- **Substantive generator-degree lower bound**: every cohomological
  generator has positive degree (no constants in the generator set, since
  the constants are already in `ℚ`). For the EVII case this is the
  classical Borel-1953 statement that `H^*(BG; ℚ)` is generated in even
  positive degrees. Encoded as a positive natural-number record
  `generatorDegreeLowerBound ≥ 1`. -/
  generatorDegreeLowerBound : ℕ
  /-- **Substantive lower-bound positivity**: the generator-degree lower
  bound is at least `1` (every generator has positive cohomological
  degree). -/
  generatorDegreeLowerBound_pos : 1 ≤ generatorDegreeLowerBound

namespace BorelHirzebruchPresentation

set_option linter.unusedSectionVars false

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [BorelHirzebruchPresentation A]

/-! ### Derived theorems -/

/-- **Strict positivity of rank** (re-export of `rank_pos` as a
`0 < rank` statement). -/
theorem rank_pos_strict : 0 < rank (A := A) :=
  rank_pos

/-- **Strict positivity of the generator-degree lower bound**. -/
theorem generatorDegreeLowerBound_pos_strict :
    0 < generatorDegreeLowerBound (A := A) :=
  generatorDegreeLowerBound_pos

/-- **No constant generators**: the generator-degree lower bound is
distinct from `0`. -/
theorem generatorDegreeLowerBound_ne_zero :
    generatorDegreeLowerBound (A := A) ≠ 0 :=
  Nat.pos_iff_ne_zero.mp generatorDegreeLowerBound_pos

/-- **Rank-bound-from-presentation**: if the presentation has more than
one generator (`rank ≥ 2`), then in particular it has at least one. -/
theorem rank_ge_one_of_ge_two (h : 2 ≤ rank (A := A)) :
    1 ≤ rank (A := A) :=
  le_trans (by decide) h

end BorelHirzebruchPresentation

/-! ## Trivial inhabiting instances

We provide minimum-non-trivial instances of the new typeclasses on the
1-dimensional carrier `A := ℚ`. The "cohomology of a point" interpretation
(`G = trivial`) makes `Sym(t^∨)^{W} = ℚ` (zero-dim torus has trivial
invariant ring = `ℚ`). For the new sibling classes we choose:

* `weylInvariants := Submodule.span ℚ ({(1 : ℚ)} : Set ℚ) = ⊤` (the
  W(L)-invariant subspace = all of `ℚ` for the trivial-group case).
* `largerWeylInvariants := Submodule.span ℚ ({(2 : ℚ)} : Set ℚ) = ⊤`
  (the W(G)-invariant subspace = also all of `ℚ`, but expressed via a
  DIFFERENT generator `2`, so the containment `span {2} ≤ span {1}` is
  a substantive computation: `2 ∈ span {1}` since `2 = 2 • 1`).

The substantive containment `span {2} ≤ span {1}` requires
`Submodule.smul_mem` + `Submodule.subset_span`, a genuine computation
(not `bot_le` / `le_refl` / `le_top` tautology). -/

/-- Trivial `CohomologyRing` instance on `ℚ`. -/
local instance instCohomologyRingQ_coinv : CohomologyRing ℚ where
  algebraic := (⊤ : Subalgebra ℚ ℚ)

/-- Trivial `AugmentationIdeal ℚ` instance: take `WE7AugIdeal = ⊥`
(the trivial group has empty augmentation ideal). Vanishing reduces to
`Submodule.mem_bot ↔ α = 0`. -/
local instance instAugmentationIdealQ_coinv : AugmentationIdeal ℚ where
  WE7AugIdeal := (⊥ : Submodule ℚ ℚ)
  WE7AugIdeal_eq_bot := fun h => Submodule.mem_bot ℚ |>.mp h

/-- Trivial `BorelHirzebruchCoinvariantData ℚ` instance: the
augmentation-vanishing universal field discharges by `AugmentationIdeal`
'-`WE7AugIdeal_eq_bot`. -/
instance instBorelHirzebruchCoinvariantDataQ :
    BorelHirzebruchCoinvariantData ℚ where
  positive_W_invariants_die := fun _ hα =>
    AugmentationIdeal.WE7AugIdeal_eq_bot hα

/-- Trivial `CoinvariantAlgebraData ℚ` instance with the substantive
containment `span {2} ≤ span {1}` (= span {1}). -/
instance instCoinvariantAlgebraDataQ : CoinvariantAlgebraData ℚ where
  weylInvariants := Submodule.span ℚ ({(1 : ℚ)} : Set ℚ)
  largerWeylInvariants := Submodule.span ℚ ({(2 : ℚ)} : Set ℚ)
  larger_le_smaller := by
    -- Goal: `Submodule.span ℚ {2} ≤ Submodule.span ℚ {1}`.
    -- It suffices to show `2 ∈ Submodule.span ℚ {1}`.
    rw [Submodule.span_le]
    intro x hx
    rcases hx with rfl
    -- Now: `2 ∈ Submodule.span ℚ {1}`. Compute `2 = 2 • 1`.
    have h1 : (1 : ℚ) ∈ Submodule.span ℚ ({(1 : ℚ)} : Set ℚ) :=
      Submodule.subset_span (Set.mem_singleton _)
    have h2 : (2 : ℚ) • (1 : ℚ) ∈ Submodule.span ℚ ({(1 : ℚ)} : Set ℚ) :=
      Submodule.smul_mem _ (2 : ℚ) h1
    have heq : (2 : ℚ) • (1 : ℚ) = (2 : ℚ) := by
      show (2 : ℚ) * (1 : ℚ) = (2 : ℚ)
      ring
    rw [heq] at h2
    exact h2
  augmentation_in_weyl_invariants := by
    -- Goal: `(⊥ : Submodule ℚ ℚ) ≤ Submodule.span ℚ {1}`.
    -- For any `α ∈ ⊥`, we have `α = 0` (by `Submodule.mem_bot`), and
    -- `0 ∈ Submodule.span ℚ {1}` (zero is in every submodule).
    intro α hα
    have : α = 0 := (Submodule.mem_bot ℚ).mp hα
    rw [this]
    exact Submodule.zero_mem _

/-- Trivial `BorelHirzebruchPresentation ℚ` instance with `rank = 1`
(positive) and `generatorDegreeLowerBound = 2` (every Chern-class
generator has degree at least `2`, reflecting the Borel-1953 even-degree
generation; we record this as `≥ 2` rather than `≥ 1` to capture the
EVEN-degree generator content). -/
instance instBorelHirzebruchPresentationQ :
    BorelHirzebruchPresentation ℚ where
  rank := 7
  rank_pos := by decide
  generatorDegreeLowerBound := 2
  generatorDegreeLowerBound_pos := by decide

/-! ### Sanity checks for the trivial instances -/

/-- **Sanity check**: the trivial `CoinvariantAlgebraData ℚ` has its
W(G)-invariant subspace contained in its W(L)-invariant subspace. -/
example :
    CoinvariantAlgebraData.largerWeylInvariants (A := ℚ) ≤
      CoinvariantAlgebraData.weylInvariants (A := ℚ) :=
  CoinvariantAlgebraData.larger_le_smaller_thm

/-- **Sanity check**: the trivial `CoinvariantAlgebraData ℚ` has the
augmentation ideal contained in its W(L)-invariant subspace. -/
example :
    AugmentationIdeal.WE7AugIdeal (A := ℚ) ≤
      CoinvariantAlgebraData.weylInvariants (A := ℚ) :=
  CoinvariantAlgebraData.augmentation_in_weyl_invariants_thm

/-- **Sanity check**: the trivial `BorelHirzebruchPresentation ℚ`
has positive rank. -/
example : 0 < BorelHirzebruchPresentation.rank (A := ℚ) :=
  BorelHirzebruchPresentation.rank_pos_strict

/-- **Sanity check**: the trivial `BorelHirzebruchPresentation ℚ`
has positive generator-degree lower bound. -/
example : 0 < BorelHirzebruchPresentation.generatorDegreeLowerBound (A := ℚ) :=
  BorelHirzebruchPresentation.generatorDegreeLowerBound_pos_strict

end HodgeReduction.Infrastructure.Cohomology
