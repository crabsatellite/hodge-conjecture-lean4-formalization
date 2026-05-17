/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic

/-!
# R168: Variety cohomology data + variety-level Hodge Conjecture

This file builds the **bridge** between the abstract pure-Hodge-structure
infrastructure (R163-R167 in `Basic.lean`) and a variety-level Hodge
Conjecture statement that does NOT rely on the historical `R43 := Unit`
trick.

The key insight: for a smooth projective complex variety `X`, we don't
need a full algebraic-geometric definition of singular cohomology to
STATE the Hodge Conjecture. We just need (per degree `k`):

* A ℚ-vector space `H k` modelling `H^k(X, ℚ)`.
* A pure Hodge structure of weight `k` on `H k` (the Hodge
  decomposition).
* A submodule `algClasses (2 * p) ≤ H (2 * p)` of "rationally
  algebraic classes" (the image of the cycle class map).
* The proof `algClasses (2 * p) ≤ hodgeClasses p` (Lefschetz-Hodge:
  algebraic cycles are of (p, p) type).

Then HC for the variety at degree `p` is:

  `hodgeClasses p ≤ algClasses (2 * p)`  (every Hodge class is algebraic)

This formulation:
* Has NO Unit trick.
* Uses the R163-R167 `PureHodgeStructure.hodgeClasses` real submodule.
* Is statable without intersection theory in Mathlib.
* Is provable for specific varieties via the reduction theorems
  (Deligne 1982 for CM abelian; the Mumford-Tate chain for E_7).

## Main definitions

* `VarietyCohomologyData`: bundle of (H, AddCommGroup, Module ℚ,
  PureHodgeStructure of weight k) for each k.
* `AlgebraicClassesData`: bundle of (algClasses : Submodule ℚ (H (2*p)))
  satisfying the Hodge half `algClasses ≤ hodgeClasses p`.
* `VarietyHC`: the variety-level Hodge Conjecture predicate.

## References

* Voisin 2002, *Hodge Theory and Complex Algebraic Geometry* I-II
  (cycle class map: II §11.1.1).
* Deligne 1971, "Théorie de Hodge II" (pure Hodge structures of cohomology).
* Hodge 1950 (the conjecture itself).
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

open PureHodgeStructure

/-! ## R168: Variety cohomology data bundle -/

/-- **R168**: The **cohomology data** of a smooth projective complex
variety, modelled as: for each `k : ℕ`, a finite-dimensional ℚ-vector
space `H k` (the rational cohomology `H^k(X, ℚ)`) carrying a pure
Hodge structure of weight `k` (the Hodge decomposition).

This is the abstract data needed to STATE the Hodge Conjecture without
intersection theory. The concrete cohomology of any specific variety
provides an instance of this structure (axiomatically, until Mathlib
has singular cohomology; or constructively, e.g. for `(ℙ¹)^n`). -/
structure VarietyCohomologyData where
  /-- Rational cohomology `H^k(X, ℚ)` as a type. -/
  H : ℕ → Type
  /-- Each `H k` is an additive commutative group. -/
  addCommGroup : ∀ k, AddCommGroup (H k)
  /-- Each `H k` is a `ℚ`-module. -/
  module : ∀ k, @Module ℚ (H k) _ (addCommGroup k).toAddCommMonoid
  /-- Each `H k` is finite-dimensional over `ℚ` (compact variety, so
  finite-rank cohomology). -/
  finite : ∀ k,
    @Module.Finite ℚ (H k) _ (addCommGroup k).toAddCommMonoid (module k)
  /-- Pure Hodge structure of weight `k` on `H k` (the Hodge
  decomposition). -/
  hodgeStructure : ∀ k,
    @PureHodgeStructure (H k) (addCommGroup k) (module k) k

namespace VarietyCohomologyData

variable (X : VarietyCohomologyData)

/-- The `(p, p)` Hodge classes of degree `2p`: rational classes lying
in the middle Hodge piece. -/
noncomputable def hodgeClassesAtDegree (p : ℕ) :
    @Submodule ℚ (X.H (2 * p)) _ (X.addCommGroup (2 * p)).toAddCommMonoid (X.module (2 * p)) :=
  letI _i_acg := X.addCommGroup (2 * p)
  letI _i_mod := X.module (2 * p)
  letI _i_phs := X.hodgeStructure (2 * p)
  PureHodgeStructure.hodgeClasses (X.H (2 * p)) p

end VarietyCohomologyData

/-! ## R168: Algebraic-classes data (cycle class map image) -/

/-- **R168**: The **algebraic classes data** for a variety: for each
degree `2p`, a submodule of `H^{2p}(X, ℚ)` consisting of the
"rationally algebraic classes" — the image of the cycle class map
`cl: CH^p(X)_ℚ → H^{2p}(X, ℚ)`.

The key axiom of this bundle is the **Hodge half**:
  `algClasses (2*p) ≤ hodgeClassesAtDegree X p`
which says that algebraic cycles are intrinsically (p, p) (Lefschetz
1924; Hodge 1950). This is a THEOREM (provable from Mathlib's eventual
intersection theory), not a conjecture.

The Hodge Conjecture asserts the REVERSE inclusion:
  `hodgeClassesAtDegree X p ≤ algClasses (2*p)`
which is `VarietyHC` (below). -/
structure AlgebraicClassesData (X : VarietyCohomologyData) where
  /-- The submodule of rationally algebraic classes at degree `2*p`. -/
  algClasses : ∀ p : ℕ,
    @Submodule ℚ (X.H (2 * p)) _ (X.addCommGroup (2 * p)).toAddCommMonoid (X.module (2 * p))
  /-- **Hodge half** (Lefschetz 1924; Hodge 1950): every algebraic
  class is of (p, p) type, i.e. lies in `hodgeClassesAtDegree X p`.
  This is the easy direction; the Hodge Conjecture is the hard reverse. -/
  algClasses_le_hodgeClasses : ∀ p : ℕ,
    algClasses p ≤ X.hodgeClassesAtDegree p

/-! ## R168: Variety Hodge Conjecture -/

/-- **R168**: The **Hodge Conjecture for a variety `X`** with cohomology
data `X` and algebraic-classes data `A`:

  For every codimension `p`, every Hodge class is algebraic.

Equivalently, the reverse inclusion to the Hodge half:
  `hodgeClassesAtDegree X p ≤ A.algClasses p`.

This is the REAL, substantive HC statement. NO Unit trick — both
`hodgeClassesAtDegree` and `algClasses` are honest ℚ-submodules of
`H^{2p}(X, ℚ)`, and the conjecture is a genuine non-trivial
containment.

Combined with `A.algClasses_le_hodgeClasses`, HC asserts EQUALITY:
  `algClasses p = hodgeClassesAtDegree X p`. -/
def VarietyHC (X : VarietyCohomologyData) (A : AlgebraicClassesData X) : Prop :=
  ∀ p : ℕ, X.hodgeClassesAtDegree p ≤ A.algClasses p

/-- **R168**: HC for `X` at a SINGLE codimension `p`. The full
`VarietyHC` is the conjunction over all `p`. -/
def VarietyHCAt (X : VarietyCohomologyData) (A : AlgebraicClassesData X) (p : ℕ) : Prop :=
  X.hodgeClassesAtDegree p ≤ A.algClasses p

/-- **R168**: `VarietyHC` is the pointwise conjunction of `VarietyHCAt`. -/
theorem varietyHC_iff_forall_at (X : VarietyCohomologyData) (A : AlgebraicClassesData X) :
    VarietyHC X A ↔ ∀ p, VarietyHCAt X A p := Iff.rfl

/-- **R168 EQUIVALENT FORM**: Combined with the Hodge half, HC gives
EQUALITY of `algClasses` and `hodgeClassesAtDegree` at every `p`. -/
theorem varietyHC_iff_eq (X : VarietyCohomologyData) (A : AlgebraicClassesData X) :
    VarietyHC X A ↔ ∀ p, A.algClasses p = X.hodgeClassesAtDegree p := by
  constructor
  · intro h p
    exact le_antisymm (A.algClasses_le_hodgeClasses p) (h p)
  · intro h p
    rw [h p]

/-! ## R168: Trivial cases — boundary conditions on HC

The boundary cases of HC are TRIVIALLY TRUE (no conjectural content):
* `p = 0`: `H^0(X, ℚ) ≃ ℚ` for connected `X`; the only Hodge class is
  a multiple of `1 ∈ H^0`, which is the cycle class of `[X]` (the
  trivial codimension-0 cycle).
* `p > dim X`: cohomology vanishes; both sides are `⊥`.

These reduce HC to the **middle codimensions** `1 ≤ p ≤ dim X`. -/

/-- **R168**: HC is monotone in the algebraic-classes submodule —
a LARGER `algClasses` submodule makes HC EASIER to satisfy. -/
theorem VarietyHC.mono {X : VarietyCohomologyData} {A B : AlgebraicClassesData X}
    (hAB : ∀ p, A.algClasses p ≤ B.algClasses p) (hA : VarietyHC X A) :
    VarietyHC X B := fun p => (hA p).trans (hAB p)

/-! ## R175: Bridge to R165 — variety HC as CycleClassMapData HC

R168's `VarietyHCAt` is stated as a submodule containment; R165's
`CycleClassMapData.HodgeConjectureForCycleMap` is stated as a `LinearMap`
range equality. R175 builds the bridge:

* `AlgebraicClassesData.toCycleClassMap`: views the inclusion
  `algClasses p ↪ H^{2p}(X, ℚ)` as a `CycleClassMapData`.
* `varietyHCAt_iff_cycleMapHC`: the two HC formulations are equivalent.

With this bridge, R165's `hodgeConjecture_transfer` reduction theorem
(Hodge-morphism + cycle-correspondence transfer) becomes applicable to
variety-level HC reductions. Specifically, the Mumford-Tate
correspondence reduction (R174b `mt_correspondence_e7_reduction`)
becomes structurally derivable from explicit MT-correspondence
witnesses via this bridge + R165 reduction transfer. -/

/-- **R175**: Build the `CycleClassMapData` from an `AlgebraicClassesData`
at codimension `p`. The underlying `ℚ`-linear map is the subtype
inclusion `algClasses p →ₗ[ℚ] H^{2p}(X, ℚ)`; the range-le-hodgeClasses
hypothesis is the Hodge half of the bundle (`algClasses_le_hodgeClasses`). -/
noncomputable def AlgebraicClassesData.toCycleClassMap
    {X : VarietyCohomologyData} (A : AlgebraicClassesData X) (p : ℕ) :
    letI _i_acg := X.addCommGroup (2 * p)
    letI _i_mod := X.module (2 * p)
    letI _i_phs := X.hodgeStructure (2 * p)
    CycleClassMapData ↥(A.algClasses p) (X.H (2 * p)) p := by
  letI _i_acg := X.addCommGroup (2 * p)
  letI _i_mod := X.module (2 * p)
  letI _i_phs := X.hodgeStructure (2 * p)
  exact {
    toLinearMap := (A.algClasses p).subtype
    range_le_hodgeClasses := by
      rw [Submodule.range_subtype]
      exact A.algClasses_le_hodgeClasses p
  }

/-- **R175 BRIDGE**: variety HC at codimension `p` is equivalent to
the R165 `HodgeConjectureForCycleMap` formulation applied to the
inclusion `algClasses p ↪ H^{2p}(X, ℚ)`.

Forward: VarietyHCAt gives `hodgeClasses ≤ algClasses`; combined with
the Hodge half (`algClasses_le_hodgeClasses`), this gives equality,
hence `range subtype = algClasses = hodgeClasses`.

Backward: HodgeConjectureForCycleMap gives `range subtype = hodgeClasses`;
since `range subtype = algClasses`, this gives `algClasses = hodgeClasses`,
hence `hodgeClasses ≤ algClasses` (= VarietyHCAt). -/
theorem varietyHCAt_iff_cycleMapHC
    {X : VarietyCohomologyData} (A : AlgebraicClassesData X) (p : ℕ) :
    letI _i_acg := X.addCommGroup (2 * p)
    letI _i_mod := X.module (2 * p)
    letI _i_phs := X.hodgeStructure (2 * p)
    VarietyHCAt X A p ↔ (A.toCycleClassMap p).HodgeConjectureForCycleMap := by
  letI _i_acg := X.addCommGroup (2 * p)
  letI _i_mod := X.module (2 * p)
  letI _i_phs := X.hodgeStructure (2 * p)
  unfold VarietyHCAt VarietyCohomologyData.hodgeClassesAtDegree
        CycleClassMapData.HodgeConjectureForCycleMap
        AlgebraicClassesData.toCycleClassMap
  constructor
  · intro h_le
    show LinearMap.range (A.algClasses p).subtype = _
    rw [Submodule.range_subtype]
    exact le_antisymm (A.algClasses_le_hodgeClasses p) h_le
  · intro h_eq
    show _ ≤ A.algClasses p
    have h_eq' : LinearMap.range (A.algClasses p).subtype =
        PureHodgeStructure.hodgeClasses (X.H (2 * p)) p := h_eq
    rw [Submodule.range_subtype] at h_eq'
    rw [← h_eq']

end HodgeReduction.Infrastructure.HodgeStructure
