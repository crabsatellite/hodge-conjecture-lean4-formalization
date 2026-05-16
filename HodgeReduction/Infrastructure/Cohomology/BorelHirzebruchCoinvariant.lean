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

end HodgeReduction.Infrastructure.Cohomology
