/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Group.TypeTags.Basic
import Mathlib.Algebra.Group.Subgroup.Basic
import Mathlib.Algebra.Group.Subgroup.Ker
import Mathlib.Algebra.PUnitInstances.Algebra

/-!
# Exponential exact sequence on a complex analytic space (R7-B Tier 2)

For a complex analytic space `X` (or a smooth projective complex
variety viewed analytically), the **exponential exact sequence** of
sheaves of abelian groups is

```
0  ⟶  2πi·ℤ_X  ⟶  𝒪_X  ⟶  𝒪_X^*  ⟶  0
```

where

* `2πi·ℤ_X` is the constant sheaf with stalk `2πi·ℤ ≃ ℤ`,
* `𝒪_X` is the structure sheaf of holomorphic functions (additively),
* `𝒪_X^*` is the sheaf of *nowhere-zero* holomorphic functions
  (multiplicatively), and
* the surjection `𝒪_X ↠ 𝒪_X^*` is `f ↦ exp(2πi·f)`, whose kernel is
  precisely the constant sheaf `2πi·ℤ_X`.

Passing to sheaf cohomology gives the long exact sequence

```
⋯ ⟶ H^k(X; 2πi·ℤ) ⟶ H^k(X; 𝒪_X) ⟶ H^k(X; 𝒪_X^*)
        ⟶^{δ_k} H^{k+1}(X; 2πi·ℤ) ⟶ ⋯
```

whose connecting homomorphism in degree `k = 1`,

```
δ_1 : H^1(X; 𝒪_X^*) ⟶ H^2(X; 2πi·ℤ) ≃ H^2(X; ℤ),
```

is the **first Chern class** under the canonical identification
`Pic(X) ≃ H^1(X; 𝒪_X^*)`.

## Lean design

Mathlib (as of `v4.16.0`) carries no `ComplexAnalyticSpace` type and
no general theory of `𝒪_X^*`, so the cleanest path for downstream
Hodge-conjecture infrastructure is an **abstract typeclass** that
packages the data and the exactness identities at each degree.

* `ExponentialSequenceData X` — a typeclass on a type `X` representing
  a "complex space", carrying three families of cohomology groups
  (integer / holomorphic / holomorphic-unit) plus the inclusion,
  exponential, and connecting homomorphisms, together with the three
  exactness axioms (`range = ker`) for the long exact sequence at each
  triple `(H^k(2πiℤ), H^k(𝒪), H^k(𝒪^*))`.

* `ExponentialSequenceData.chernOneFromDelta` — the abbreviation
  exposing `δ_1 : H^1(𝒪^*) → H^2(2πiℤ)` as the abstract first Chern
  class out of the sequence.

* `Unit` is given a trivial `ExponentialSequenceData` instance (all
  cohomologies are `Unit`-typed, all maps are the zero map). This
  serves both as a non-vacuous typecheck of the class and as the
  degenerate "point" case `X = pt`.

The class is deliberately *minimal*: it captures only the homological
shape of the sequence, with no real complex-analytic content. When a
genuine `ComplexAnalyticSpace` becomes available upstream, this file's
typeclass can be supplied by a single concrete instance, with the
downstream API (in particular the `chernOneFromDelta` Chern-one map)
unchanged.

## Multiplicative vs additive carriers

`𝒪_X^*` is a multiplicative sheaf; its cohomology
`H^k(X; 𝒪_X^*)` is therefore a **multiplicative** abelian group. To
state the exponential map `exp : H^k(𝒪) → H^k(𝒪^*)` and the
connecting map `δ : H^k(𝒪^*) → H^{k+1}(2πiℤ)` as `AddMonoidHom`s we
wrap `H^k(𝒪^*)` in Mathlib's `Additive` type tag. The combination
`Additive (HolomorphicUnitCohomology k)` then carries the
`AddCommGroup` instance automatically derived from
`Additive.addCommGroup` on a `CommGroup`, and the `→+` arrows
typecheck. The user-facing reading is unchanged: multiplication in
`𝒪_X^*` corresponds to addition in `Additive (H^k(𝒪_X^*))`, exactly
as expected from `exp(a + b) = exp(a) · exp(b)`.

## Cat 1 kernel-purity

This file is **Category 1** (kernel-pure): the data is a typeclass,
the three exactness identities are `AddMonoidHom`-range/kernel
equations, and the only concrete instance (`Unit`) is closed by
`rfl` / `Subsingleton.elim` after each side is trivial. No `sorry`,
no `native_decide`, no broken-link axioms.

## Tags

exponential exact sequence, complex analytic space, sheaf cohomology,
first Chern class, holomorphic units, Picard group, Hodge theory
-/

namespace HodgeReduction.Infrastructure.AlgebraicGeometry

/-! ## R7-B: `ExponentialSequenceData` -/

/-- **Exponential exact sequence data** on a "complex space" `X`.

Abstract typeclass packaging the three cohomology families and the
exact-sequence connecting homomorphisms for the long exact sequence
induced by

```
0  ⟶  2πi·ℤ_X  ⟶  𝒪_X  ⟶  𝒪_X^*  ⟶  0
```

in sheaf cohomology.

The shape is `range = ker` at each of the three exactness points of
the rolling triple `(H^k(2πiℤ), H^k(𝒪), H^k(𝒪^*))`:

* `exact_at_holo k`      : `(intToHolo k).range = (expMap k).ker`
  — exactness at `H^k(𝒪)`.
* `exact_at_holo_unit k`  : `(expMap k).range = (delta k).ker`
  — exactness at `H^k(𝒪^*)`.
* `exact_at_int k`        : `(delta k).range = (intToHolo (k+1)).ker`
  — exactness at `H^{k+1}(2πiℤ)`.

Because `H^k(𝒪^*)` is naturally **multiplicative**, the `expMap` and
`delta` arrows are stated on `Additive (HolomorphicUnitCohomology k)`,
which inherits an `AddCommGroup` instance from
`Additive.addCommGroup`. -/
class ExponentialSequenceData (X : Type*) where
  /-- The cohomology of the constant integer sheaf:
  `H^k(X; 2πi·ℤ) ≃ H^k(X; ℤ)`. -/
  IntegerCohomology : ℕ → Type*
  /-- The cohomology of the structure sheaf:
  `H^k(X; 𝒪_X)`. -/
  HolomorphicCohomology : ℕ → Type*
  /-- The cohomology of the holomorphic-units sheaf:
  `H^k(X; 𝒪_X^*)` (multiplicative). -/
  HolomorphicUnitCohomology : ℕ → Type*
  /-- Each integer cohomology group is an additive abelian group. -/
  intCoh_addCommGroup : ∀ k, AddCommGroup (IntegerCohomology k)
  /-- Each holomorphic-function cohomology group is an additive
  abelian group. -/
  holoCoh_addCommGroup : ∀ k, AddCommGroup (HolomorphicCohomology k)
  /-- Each holomorphic-unit cohomology group is a (multiplicative)
  commutative group, since `𝒪_X^*` is a sheaf of multiplicative
  abelian groups. -/
  holoUnitCoh_commGroup : ∀ k, CommGroup (HolomorphicUnitCohomology k)
  /-- The exponential map at degree `k`, i.e. the cohomology map
  induced by `f ↦ exp(2πi·f) : 𝒪_X ⟶ 𝒪_X^*`, expressed as an
  `AddMonoidHom` into the `Additive` repackaging of the
  multiplicative cohomology group. -/
  expMap : ∀ k, HolomorphicCohomology k →+ Additive (HolomorphicUnitCohomology k)
  /-- The integer-to-holomorphic inclusion at degree `k`, i.e. the
  cohomology map induced by `2πi·ℤ_X ↪ 𝒪_X`. -/
  intToHolo : ∀ k, IntegerCohomology k →+ HolomorphicCohomology k
  /-- The connecting homomorphism
  `δ_k : H^k(X; 𝒪_X^*) ⟶ H^{k+1}(X; 2πi·ℤ)`. Through the canonical
  identification `Pic(X) ≃ H^1(X; 𝒪_X^*)` the `k = 1` instance
  recovers the **first Chern class** `c_1 : Pic(X) → H^2(X; ℤ)` —
  see `chernOneFromDelta` below. -/
  delta : ∀ k, Additive (HolomorphicUnitCohomology k) →+ IntegerCohomology (k + 1)
  /-- **Exactness at `H^k(𝒪)`**: the image of the integer inclusion
  equals the kernel of the exponential map. -/
  exact_at_holo : ∀ k, (intToHolo k).range = (expMap k).ker
  /-- **Exactness at `H^k(𝒪^*)`**: the image of the exponential map
  equals the kernel of the connecting homomorphism. -/
  exact_at_holo_unit : ∀ k, (expMap k).range = (delta k).ker
  /-- **Exactness at `H^{k+1}(2πiℤ)`**: the image of the connecting
  homomorphism equals the kernel of the next integer inclusion. -/
  exact_at_int : ∀ k, (delta k).range = (intToHolo (k + 1)).ker

attribute [instance] ExponentialSequenceData.intCoh_addCommGroup
attribute [instance] ExponentialSequenceData.holoCoh_addCommGroup
attribute [instance] ExponentialSequenceData.holoUnitCoh_commGroup

namespace ExponentialSequenceData

/-! ### First Chern class from the connecting homomorphism

The `k = 1` connecting homomorphism

```
δ_1 : H^1(X; 𝒪_X^*) ⟶ H^2(X; 2πi·ℤ) ≃ H^2(X; ℤ)
```

is, under the canonical identification `Pic(X) ≃ H^1(X; 𝒪_X^*)`, the
first Chern class `c_1 : Pic(X) → H^2(X; ℤ)`. The abbreviation below
exposes this map without committing to a particular
`Pic ↔ H^1(𝒪^*)` isomorphism (which lives in a downstream layer). -/

/-- **First Chern class via δ**: the `k = 1` connecting hom

```
δ : Additive (H^1(X; 𝒪_X^*))  ⟶  H^2(X; 2πi·ℤ).
```

Composing with any chosen iso `Pic(X) ≃ H^1(X; 𝒪_X^*)` (and pre- and
post-composing with the `Additive` / `Multiplicative` repackaging
isomorphisms) recovers `c_1 : Pic(X) → H^2(X; ℤ)` of
`FirstChernClass.lean`. -/
abbrev chernOneFromDelta {X : Type*} [ExponentialSequenceData X] :
    Additive (HolomorphicUnitCohomology (X := X) 1) →+ IntegerCohomology (X := X) 2 :=
  delta 1

/-! ### Re-exports of the exactness identities as named theorems

The three exactness fields are restated as theorems so downstream
proofs can `rw [exact_at_holo_eq]` or `exact exact_at_holo_unit_eq _`
without spelling out the typeclass projection. -/

variable {X : Type*} [ExponentialSequenceData X]

/-- Theorem-level restatement of `exact_at_holo`. -/
theorem exact_at_holo_eq (k : ℕ) :
    (intToHolo (X := X) k).range = (expMap (X := X) k).ker :=
  ExponentialSequenceData.exact_at_holo k

/-- Theorem-level restatement of `exact_at_holo_unit`. -/
theorem exact_at_holo_unit_eq (k : ℕ) :
    (expMap (X := X) k).range = (delta (X := X) k).ker :=
  ExponentialSequenceData.exact_at_holo_unit k

/-- Theorem-level restatement of `exact_at_int`. -/
theorem exact_at_int_eq (k : ℕ) :
    (delta (X := X) k).range = (intToHolo (X := X) (k + 1)).ker :=
  ExponentialSequenceData.exact_at_int k

/-! ### Composition-zero corollaries

`range f = ker g` immediately implies `g ∘ f = 0` (the "complex" half
of exactness, prior to the harder kernel-in-image direction). The
three composition-zero corollaries below are useful as `simp`-targets
when reducing combinations of the three maps in cohomology
computations. -/

/-- The composition `expMap k ∘ intToHolo k` is zero. -/
theorem expMap_comp_intToHolo (k : ℕ) (x : IntegerCohomology (X := X) k) :
    expMap k (intToHolo k x) = 0 := by
  have hmem : intToHolo k x ∈ (intToHolo (X := X) k).range :=
    AddMonoidHom.mem_range.mpr ⟨x, rfl⟩
  have hker : intToHolo k x ∈ (expMap (X := X) k).ker := by
    rw [← exact_at_holo_eq]; exact hmem
  exact AddMonoidHom.mem_ker.mp hker

/-- The composition `delta k ∘ expMap k` is zero. -/
theorem delta_comp_expMap (k : ℕ) (x : HolomorphicCohomology (X := X) k) :
    delta k (expMap k x) = 0 := by
  have hmem : expMap k x ∈ (expMap (X := X) k).range :=
    AddMonoidHom.mem_range.mpr ⟨x, rfl⟩
  have hker : expMap k x ∈ (delta (X := X) k).ker := by
    rw [← exact_at_holo_unit_eq]; exact hmem
  exact AddMonoidHom.mem_ker.mp hker

/-- The composition `intToHolo (k+1) ∘ delta k` is zero. -/
theorem intToHolo_comp_delta (k : ℕ) (x : Additive (HolomorphicUnitCohomology (X := X) k)) :
    intToHolo (k + 1) (delta k x) = 0 := by
  have hmem : delta k x ∈ (delta (X := X) k).range :=
    AddMonoidHom.mem_range.mpr ⟨x, rfl⟩
  have hker : delta k x ∈ (intToHolo (X := X) (k + 1)).ker := by
    rw [← exact_at_int_eq]; exact hmem
  exact AddMonoidHom.mem_ker.mp hker

/-! ### Kernel-of-`δ` characterisation of "topologically trivial" classes

A holomorphic-unit cohomology class `α ∈ H^k(𝒪^*)` has trivial Chern
class (`δ α = 0`) iff it lies in the image of the exponential map.
For `k = 1`, this is the classical fact that line bundles with
`c_1 = 0` are exactly those induced (analytically) by classes in
`H^1(𝒪)`, i.e. those in `Pic⁰` modulo the integer lattice. -/

/-- `δ α = 0` iff `α = exp β` for some `β ∈ H^k(𝒪)`. -/
theorem delta_eq_zero_iff_mem_expMap_range (k : ℕ)
    (α : Additive (HolomorphicUnitCohomology (X := X) k)) :
    delta k α = 0 ↔ ∃ β, expMap k β = α := by
  constructor
  · intro hα
    have hker : α ∈ (delta (X := X) k).ker := AddMonoidHom.mem_ker.mpr hα
    have hrange : α ∈ (expMap (X := X) k).range := by
      rw [exact_at_holo_unit_eq]; exact hker
    exact AddMonoidHom.mem_range.mp hrange
  · rintro ⟨β, rfl⟩
    exact delta_comp_expMap k β

/-! ### Specialisation to `k = 1`: the "first Chern class vanishes"
characterisation. -/

/-- A class `α ∈ H^1(𝒪^*)` has vanishing first Chern class iff
`α = exp(β)` for some `β ∈ H^1(𝒪)`. -/
theorem chernOneFromDelta_eq_zero_iff
    (α : Additive (HolomorphicUnitCohomology (X := X) 1)) :
    chernOneFromDelta α = 0 ↔ ∃ β, expMap 1 β = α :=
  delta_eq_zero_iff_mem_expMap_range 1 α

end ExponentialSequenceData

/-! ## Trivial example: `Unit` as a degenerate complex space

The single-point analytic space `X = pt` has trivial sheaf cohomology
in all positive degrees and the trivial group in degree `0`. We
realise this as `X := Unit` with all three cohomology families
identically `Unit`, all maps the zero map, and exactness identities
discharged by `Subsingleton`. This serves as a non-vacuous typecheck
of the `ExponentialSequenceData` class. -/

namespace TrivialUnit

/-- `Unit` as a "complex space" carrying the trivial exponential
exact sequence data: all cohomology groups are `Unit` (trivial) and
all maps are the zero map.

Implementation note: we write `IntegerCohomology := fun _ => Unit`
etc. explicitly so the `AddCommGroup`/`CommGroup` fields can be
filled by `inferInstance` after a `show` rewrite — without the
`show`, typeclass synthesis sees an unreduced `(fun _ => Unit) k`
application and fails to find the instance. The zero `AddMonoidHom`
between `Unit`-valued groups, combined with the `Subsingleton` on
`AddSubgroup Unit`, makes each `range = ker` equation trivially
true. -/
instance : ExponentialSequenceData Unit where
  IntegerCohomology := fun _ => Unit
  HolomorphicCohomology := fun _ => Unit
  HolomorphicUnitCohomology := fun _ => Unit
  intCoh_addCommGroup := fun _ => (show AddCommGroup Unit from inferInstance)
  holoCoh_addCommGroup := fun _ => (show AddCommGroup Unit from inferInstance)
  holoUnitCoh_commGroup := fun _ => (show CommGroup Unit from inferInstance)
  expMap := fun _ =>
    (show Unit →+ Additive Unit from 0)
  intToHolo := fun _ =>
    (show Unit →+ Unit from 0)
  delta := fun _ =>
    (show Additive Unit →+ Unit from 0)
  exact_at_holo := fun _ => Subsingleton.elim _ _
  exact_at_holo_unit := fun _ => Subsingleton.elim _ _
  exact_at_int := fun _ => Subsingleton.elim _ _

/-- **Sanity check**: the trivial-instance `chernOneFromDelta` is the
zero map (both sides are `Unit`-valued). -/
example (α : Additive (ExponentialSequenceData.HolomorphicUnitCohomology
    (X := Unit) 1)) :
    ExponentialSequenceData.chernOneFromDelta α = 0 :=
  rfl

/-- **Sanity check**: in the trivial instance, every class has
vanishing first Chern class. -/
example (α : Additive (ExponentialSequenceData.HolomorphicUnitCohomology
    (X := Unit) 1)) :
    ∃ β, ExponentialSequenceData.expMap 1 β = α :=
  (ExponentialSequenceData.chernOneFromDelta_eq_zero_iff α).mp rfl

/-- **Sanity check**: `expMap ∘ intToHolo = 0` in the trivial
instance (a special case of the general `expMap_comp_intToHolo`). -/
example (k : ℕ) (x : ExponentialSequenceData.IntegerCohomology (X := Unit) k) :
    ExponentialSequenceData.expMap k
        (ExponentialSequenceData.intToHolo k x) = 0 :=
  ExponentialSequenceData.expMap_comp_intToHolo k x

end TrivialUnit

/-! ## Phase 4 audit: kernel-purity diagnostic

Uncomment any of the lines below to inspect axiom dependencies of the
derived theorems. Verified output (R7-B audit, 2026-05-16): all
9 entries depend only on `[propext, Quot.sound]`, a strict subset of
the kernel-pure axiom set (no `Classical.choice` used). No `sorry`,
no `native_decide`, no broken-link axioms.

```
-- #print axioms ExponentialSequenceData.exact_at_holo_eq
-- #print axioms ExponentialSequenceData.exact_at_holo_unit_eq
-- #print axioms ExponentialSequenceData.exact_at_int_eq
-- #print axioms ExponentialSequenceData.expMap_comp_intToHolo
-- #print axioms ExponentialSequenceData.delta_comp_expMap
-- #print axioms ExponentialSequenceData.intToHolo_comp_delta
-- #print axioms ExponentialSequenceData.delta_eq_zero_iff_mem_expMap_range
-- #print axioms ExponentialSequenceData.chernOneFromDelta_eq_zero_iff
-- #print axioms TrivialUnit.instExponentialSequenceDataUnit
```
-/

end HodgeReduction.Infrastructure.AlgebraicGeometry
