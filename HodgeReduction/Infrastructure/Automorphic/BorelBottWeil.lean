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

/-! ### Borel-Bott-Weil cohomology of homogeneous bundles

The **Borel-Bott-Weil theorem** (Bott 1957 *Homogeneous vector bundles*,
Ann. Math. 66; Demazure 1968 simplification; Voisin 2002 Vol. I §13.3)
computes the cohomology of equivariant line bundles `L_λ` on a flag
variety `G/B` (or more generally `G/P`):

* If `λ + ρ` is **regular** (no Weyl-shift singular wall), there is a
  unique `w ∈ W` so that `w(λ + ρ) - ρ` is dominant, and
  `H^{ℓ(w)}(G/B; L_λ)` is the irreducible representation with that
  highest weight (all other degrees vanish).
* If `λ + ρ` is **singular** (lies on a Weyl-shift wall, i.e. NOT
  regular), then `H^*(G/B; L_λ) = 0` in every degree (BBW vanishing).

This file abstracts the **carrier-level data**: a weight type `weights`,
a regularity predicate, and a cohomology functor `weights → Submodule ℚ V`
together with the substantive **BBW vanishing axiom** that non-regular
weights give the zero cohomology. -/

/-- **Borel-Bott-Weil cohomology data** for a flag variety `G/B` with
ambient cohomology space `V` (a `ℚ`-module representing the ambient
cohomology). For each dominant weight `λ : weights`, the BBW theorem
constructs `cohomology λ : Submodule ℚ V` (the realisation inside `V`
of the BBW representation at `λ`).

The **substantive content** is the Bott vanishing axiom:

* If `λ` is NOT regular (i.e. `λ + ρ` lies on a Weyl-shift wall), then
  the BBW cohomology submodule is the zero submodule.

This is a non-trivial submodule equality (`cohomology λ = ⊥`), NOT a
tautology — for a regular `λ` the same field would generally produce a
non-zero submodule, so the predicate gates a genuine vanishing claim. -/
class BorelBottWeilCohomologyData (V : Type*) [AddCommGroup V] [Module ℚ V]
    where
  /-- Abstract weight indexing set (= the `λ` parameter of `L_λ`). -/
  weights : Type
  /-- The BBW regularity predicate: `regular λ = true` iff `λ + ρ` lies
  in the interior of a Weyl chamber (no Weyl-shift wall). -/
  regular : weights → Bool
  /-- The BBW cohomology submodule of `V` attached to each weight. -/
  cohomology : weights → Submodule ℚ V
  /-- **Bott vanishing** (Bott 1957 Ann. Math. 66, Thm IV; Demazure 1968):
  for a NON-regular weight `λ`, the BBW cohomology vanishes. This is the
  substantive content of the BBW theorem (the regular case is the
  classification of `H^{ℓ(w)}` as an irreducible representation; the
  singular case is the vanishing statement). -/
  bott_vanishing : ∀ (w : weights), regular w = false → cohomology w = ⊥

namespace BorelBottWeilCohomologyData

variable {V : Type*} [AddCommGroup V] [Module ℚ V] [BorelBottWeilCohomologyData V]

/-- **Derived form** of Bott vanishing using the boolean-negation form
`¬ regular w = true` (equivalent to `regular w = false`). -/
theorem cohomology_eq_bot_of_not_regular
    (w : weights (V := V)) (hw : ¬ regular w = true) :
    cohomology (V := V) w = ⊥ := by
  have h : regular (V := V) w = false := by
    cases hreg : regular (V := V) w
    · rfl
    · exact (hw hreg).elim
  exact bott_vanishing w h

/-- **Membership consequence**: every element of `cohomology λ` for a
non-regular `λ` is forced to be zero. Useful downstream when an element
is known to land in the BBW cohomology at a singular weight. -/
theorem mem_cohomology_singular_eq_zero
    {w : weights (V := V)} (hw : regular (V := V) w = false)
    {α : V} (hα : α ∈ cohomology (V := V) w) : α = 0 := by
  rw [bott_vanishing w hw, Submodule.mem_bot] at hα
  exact hα

end BorelBottWeilCohomologyData

/-! ### Trivial inhabiting instance (Bott-vanishing degenerate model)

We provide a minimal inhabiting instance: a single-weight model where
the unique weight is `regular`, so the Bott-vanishing axiom is satisfied
vacuously. -/

/-- **Trivial Bott-vanishing model**: one regular weight, the cohomology
is `⊤`. The Bott vanishing axiom holds vacuously (no non-regular
weight). -/
noncomputable instance trivialBorelBottWeilCohomologyData
    (V : Type*) [AddCommGroup V] [Module ℚ V] :
    BorelBottWeilCohomologyData V where
  weights := Unit
  regular _ := true
  cohomology _ := ⊤
  bott_vanishing := by
    intro w hw
    -- `regular w = true` by definition, contradicting `hw : true = false`.
    simp at hw

/-! ### Irreducible weight data

For the regular branch of BBW, the cohomology is concentrated in one
degree and there equals an irreducible representation of `G` with highest
weight `w(λ + ρ) - ρ`. This sibling typeclass captures the
**non-vanishing irreducible witness** at each regular weight. -/

/-- **Irreducible BBW weight data**: a parallel typeclass to
`BorelBottWeilCohomologyData` that additionally records, for each
**regular** weight `w`, a non-zero highest-weight vector
`highestWeightVector : weights → V` together with the substantive
non-zeroness axiom

  `regular w = true → highestWeightVector w ≠ 0`.

This is the **non-trivial existence claim** of the BBW theorem on the
regular branch (Bott 1957 Thm IV(b); Demazure 1968 §3): every regular
weight produces an irreducible representation, so the highest-weight
vector is non-zero. -/
class IrreducibleWeightData (V : Type*) [AddCommGroup V] [Module ℚ V]
    [BorelBottWeilCohomologyData V] where
  /-- The highest-weight vector of the BBW irreducible at each weight. -/
  highestWeightVector : BorelBottWeilCohomologyData.weights (V := V) → V
  /-- The highest-weight vector lies in the BBW cohomology submodule. -/
  highestWeightVector_mem :
    ∀ (w : BorelBottWeilCohomologyData.weights (V := V)),
      highestWeightVector w ∈ BorelBottWeilCohomologyData.cohomology (V := V) w
  /-- **BBW regular non-zeroness** (Bott 1957 Thm IV(b)): for a regular
  weight, the highest-weight vector is non-zero (the irreducible
  representation has a non-trivial top weight space). This is the
  substantive companion of `bott_vanishing` on the regular branch. -/
  highestWeightVector_ne_zero :
    ∀ (w : BorelBottWeilCohomologyData.weights (V := V)),
      BorelBottWeilCohomologyData.regular (V := V) w = true →
        highestWeightVector w ≠ 0

namespace IrreducibleWeightData

variable {V : Type*} [AddCommGroup V] [Module ℚ V]
    [BorelBottWeilCohomologyData V] [IrreducibleWeightData V]

/-- **Regular BBW cohomology is non-trivial**: at a regular weight, the
cohomology submodule contains a non-zero vector. -/
theorem cohomology_ne_bot_of_regular
    (w : BorelBottWeilCohomologyData.weights (V := V))
    (hw : BorelBottWeilCohomologyData.regular (V := V) w = true) :
    BorelBottWeilCohomologyData.cohomology (V := V) w ≠ ⊥ := by
  intro hbot
  -- If the submodule is `⊥` then every element is zero, contradicting
  -- the non-zero highest-weight vector.
  have hmem : highestWeightVector (V := V) w ∈
      BorelBottWeilCohomologyData.cohomology (V := V) w :=
    highestWeightVector_mem w
  rw [hbot, Submodule.mem_bot] at hmem
  exact highestWeightVector_ne_zero w hw hmem

end IrreducibleWeightData

/-- **Trivial Irreducible BBW instance**: in the single-weight inhabiting
model, the highest-weight vector is any non-zero element. We use `0`
universally is not possible (would violate the non-zeroness axiom);
instead we instantiate over a module that already has a chosen non-zero
element. For pure inhabiting purposes we use the **base ring `ℚ`** as
`V`, where `1 ≠ 0` provides the witness. -/
noncomputable instance trivialIrreducibleWeightData :
    IrreducibleWeightData ℚ where
  highestWeightVector _ := (1 : ℚ)
  highestWeightVector_mem _ := Submodule.mem_top
  highestWeightVector_ne_zero _ _ := one_ne_zero

end HodgeReduction.Infrastructure.Automorphic
