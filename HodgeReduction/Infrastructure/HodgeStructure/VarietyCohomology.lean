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

/-! ## R176: Variety-level reduction transfer (R165 lifted)

R165's `CycleClassMapData.hodgeConjecture_transfer` is stated abstractly
at the cycle-class-map level. R176 lifts it to the variety level via the
R175 bridge: given two variety cohomology data + algebraic classes data,
and per-p compatible HSM + cycle correspondence with the standard R165
hypotheses, HC-real for the source transfers to HC-real for the target.

This is the abstract variety-level reduction theorem that the Mumford-
Tate correspondence axiom (R174b `mt_correspondence_e7_reduction`)
encodes. Future rounds can derive that axiom from a finer-grained
"correspondence exists" axiom by direct application of R176. -/

/-- **R176**: Variety-level HC transfer at codimension `p`. If we have
* `X_src, X_tgt : VarietyCohomologyData` and corresponding algebraic
  classes data `A_src, A_tgt`,
* A Hodge structure morphism `φ` from `X_src.H (2*p)` to `X_tgt.H (2*p)`
  of weight `2*p`,
* A `ℚ`-linear cycle-correspondence `ψ : A_src.algClasses p →ₗ[ℚ]
  A_tgt.algClasses p`,
* The commutative square `φ ∘ subtype_src = subtype_tgt ∘ ψ`,
* `φ` is surjective on Hodge classes:
  `hodgeClassesAtDegree X_tgt p ≤ Submodule.map φ (hodgeClassesAtDegree X_src p)`,

then HC-real for `X_src` at `p` implies HC-real for `X_tgt` at `p`.

Proof: convert both sides via R175 bridge, apply R165's
`hodgeConjecture_transfer`, convert back. -/
theorem varietyHCAt_transfer
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    (p : ℕ)
    (φ :
      letI _ := X_src.addCommGroup (2 * p)
      letI _ := X_src.module (2 * p)
      letI _ := X_src.hodgeStructure (2 * p)
      letI _ := X_tgt.addCommGroup (2 * p)
      letI _ := X_tgt.module (2 * p)
      letI _ := X_tgt.hodgeStructure (2 * p)
      HodgeStructureMorphism (X_src.H (2 * p)) (X_tgt.H (2 * p)) (2 * p))
    (ψ :
      letI _ := X_src.addCommGroup (2 * p)
      letI _ := X_src.module (2 * p)
      letI _ := X_tgt.addCommGroup (2 * p)
      letI _ := X_tgt.module (2 * p)
      ↥(A_src.algClasses p) →ₗ[ℚ] ↥(A_tgt.algClasses p))
    (h_square :
      letI _ := X_src.addCommGroup (2 * p)
      letI _ := X_src.module (2 * p)
      letI _ := X_src.hodgeStructure (2 * p)
      letI _ := X_tgt.addCommGroup (2 * p)
      letI _ := X_tgt.module (2 * p)
      letI _ := X_tgt.hodgeStructure (2 * p)
      ∀ z : ↥(A_src.algClasses p),
        ((A_tgt.algClasses p).subtype) (ψ z) =
          φ.toLinearMap (((A_src.algClasses p).subtype) z))
    (h_φ_surj :
      letI _ := X_src.addCommGroup (2 * p)
      letI _ := X_src.module (2 * p)
      letI _ := X_src.hodgeStructure (2 * p)
      letI _ := X_tgt.addCommGroup (2 * p)
      letI _ := X_tgt.module (2 * p)
      letI _ := X_tgt.hodgeStructure (2 * p)
      PureHodgeStructure.hodgeClasses (X_tgt.H (2 * p)) p ≤
        Submodule.map φ.toLinearMap
          (PureHodgeStructure.hodgeClasses (X_src.H (2 * p)) p))
    (h_HC_src : VarietyHCAt X_src A_src p) :
    VarietyHCAt X_tgt A_tgt p := by
  letI _ := X_src.addCommGroup (2 * p)
  letI _ := X_src.module (2 * p)
  letI _ := X_src.hodgeStructure (2 * p)
  letI _ := X_tgt.addCommGroup (2 * p)
  letI _ := X_tgt.module (2 * p)
  letI _ := X_tgt.hodgeStructure (2 * p)
  -- Convert both to CycleClassMapData HC form via R175 bridge
  rw [varietyHCAt_iff_cycleMapHC] at h_HC_src
  rw [varietyHCAt_iff_cycleMapHC]
  -- Apply R165 reduction transfer
  exact (A_src.toCycleClassMap p).hodgeConjecture_transfer
    (A_tgt.toCycleClassMap p) φ ψ h_square h_φ_surj h_HC_src

/-! ## R177: Bundle the R176 hypotheses as a single `Prop` (correspondence package)

The R176 transfer takes 4 separate hypotheses (φ, ψ, square, surj).
R177 packages them as a single `Prop` `MTCorrespondencePackageAt`,
suitable as the conclusion of a Mumford-Tate-correspondence existence
axiom. Then `varietyHCAt_of_correspondence` unpacks the package and
applies R176. This is the structural plumbing that lets the R174b
`mt_correspondence_e7_reduction` axiom be derived from a finer-grained
"correspondence exists" axiom + R176. -/

/-- **R177**: A **per-codimension Mumford-Tate correspondence package** —
the Prop asserting existence of `(φ, ψ, square, surj)` witnesses for the
R165/R176 reduction transfer from variety `X_src` to variety `X_tgt` at
codimension `p`.

Packages the substantive data of a Mumford-Tate correspondence:
* Hodge structure morphism on cohomology.
* `ℚ`-linear cycle-correspondence on algebraic classes.
* Commutative square (compatibility).
* Surjectivity on Hodge classes. -/
def MTCorrespondencePackageAt
    (X_src X_tgt : VarietyCohomologyData)
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    (p : ℕ) : Prop :=
  letI _ := X_src.addCommGroup (2 * p)
  letI _ := X_src.module (2 * p)
  letI _ := X_src.hodgeStructure (2 * p)
  letI _ := X_tgt.addCommGroup (2 * p)
  letI _ := X_tgt.module (2 * p)
  letI _ := X_tgt.hodgeStructure (2 * p)
  ∃ (φ : HodgeStructureMorphism (X_src.H (2 * p)) (X_tgt.H (2 * p)) (2 * p))
    (ψ : ↥(A_src.algClasses p) →ₗ[ℚ] ↥(A_tgt.algClasses p)),
    (∀ z : ↥(A_src.algClasses p),
      ((A_tgt.algClasses p).subtype) (ψ z) =
        φ.toLinearMap (((A_src.algClasses p).subtype) z)) ∧
    PureHodgeStructure.hodgeClasses (X_tgt.H (2 * p)) p ≤
      Submodule.map φ.toLinearMap
        (PureHodgeStructure.hodgeClasses (X_src.H (2 * p)) p)

/-- **R177**: Given an `MTCorrespondencePackageAt` package + HC-real
for `X_src` at `p`, derive HC-real for `X_tgt` at `p` via R176's
variety-level reduction transfer.

This unpacks the existential and applies R176. The downstream MT
reduction theorem (per-p quantification) follows by quantifying. -/
theorem varietyHCAt_of_correspondence
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p : ℕ}
    (h_pkg : MTCorrespondencePackageAt X_src X_tgt A_src A_tgt p)
    (h_HC_src : VarietyHCAt X_src A_src p) :
    VarietyHCAt X_tgt A_tgt p := by
  letI _ := X_src.addCommGroup (2 * p)
  letI _ := X_src.module (2 * p)
  letI _ := X_src.hodgeStructure (2 * p)
  letI _ := X_tgt.addCommGroup (2 * p)
  letI _ := X_tgt.module (2 * p)
  letI _ := X_tgt.hodgeStructure (2 * p)
  unfold MTCorrespondencePackageAt at h_pkg
  obtain ⟨φ, ψ, h_square, h_surj⟩ := h_pkg
  exact varietyHCAt_transfer p φ ψ h_square h_surj h_HC_src

/-- **R185**: The submodule of **algebraic classes** is automatically a
sub-Hodge structure of `H^{2p}(X, ℚ)`, since it is contained in a single
Hodge piece (the `(p, p)` piece = `hodgeClassesAtDegree X p`).

This is a structural corollary: `algClasses p ≤ hodgeClassesAtDegree X p =
piece ⟨p, _⟩`. Any submodule contained in a single piece is automatically
a sub-Hodge structure (since `⨆ q, M ⊓ piece q ≥ M ⊓ piece p = M`).

Significance: under the Hodge Conjecture (`VarietyHCAt`), `algClasses p =
hodgeClassesAtDegree X p`. Without HC, `algClasses p` is generally a
strict sub-HS of `hodgeClassesAtDegree X p`. This theorem confirms the
sub-HS structure unconditionally. -/
theorem AlgebraicClassesData.algClasses_isSubHodgeStructure
    {X : VarietyCohomologyData} (A : AlgebraicClassesData X) (p : ℕ) :
    letI _ := X.addCommGroup (2 * p)
    letI _ := X.module (2 * p)
    letI _ := X.hodgeStructure (2 * p)
    PureHodgeStructure.IsSubHodgeStructure (V := X.H (2 * p)) (n := 2 * p)
      (A.algClasses p) := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  unfold PureHodgeStructure.IsSubHodgeStructure
  apply le_antisymm
  · -- algClasses p ≤ ⨆ q, algClasses p ⊓ piece q.
    -- Use that algClasses p ≤ hodgeClassesAtDegree p = piece ⟨p, _⟩.
    intro α hα
    refine Submodule.mem_iSup_of_mem ⟨p, by omega⟩ ?_
    refine Submodule.mem_inf.mpr ⟨hα, ?_⟩
    -- α ∈ algClasses p ≤ hodgeClassesAtDegree p = piece ⟨p, _⟩
    have h_in_hodge : α ∈ X.hodgeClassesAtDegree p :=
      A.algClasses_le_hodgeClasses p hα
    -- Unfold hodgeClassesAtDegree
    unfold VarietyCohomologyData.hodgeClassesAtDegree at h_in_hodge
    -- hodgeClasses = piece ⟨p, _⟩
    rw [PureHodgeStructure.hodgeClasses_eq_piece] at h_in_hodge
    exact h_in_hodge
  · exact iSup_le (fun _ => inf_le_left)

/-- **R178**: The **identity Mumford-Tate correspondence** package: any
variety has an MT correspondence package to itself at every codimension.
This is the sanity-check inhabitant showing `MTCorrespondencePackageAt`
is non-vacuously definable.

Witnesses:
* `φ := id_HSM` (identity Hodge morphism on `X.H (2*p)`).
* `ψ := LinearMap.id` (identity on `A.algClasses p`).
* Commutative square: trivial.
* Surjectivity: identity surjects everywhere. -/
theorem MTCorrespondencePackageAt.id
    {X : VarietyCohomologyData} {A : AlgebraicClassesData X} (p : ℕ) :
    MTCorrespondencePackageAt X X A A p := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  unfold MTCorrespondencePackageAt
  refine ⟨HodgeStructureMorphism.id_HSM, LinearMap.id, ?_, ?_⟩
  · -- commutative square: ψ = id and φ = id, so subtype ∘ id = id ∘ subtype.
    intro z; rfl
  · -- surjectivity: id-image of hodgeClasses = hodgeClasses
    rw [HodgeStructureMorphism.id_HSM_map_hodgeClasses]

/-- **R179**: **Composition of Mumford-Tate correspondence packages**.
Given correspondences `X → Y` and `Y → Z`, compose to get `X → Z`.

Witnesses (compose component-wise):
* `φ_XZ := φ_YZ ∘ φ_XY` (HSM composition).
* `ψ_XZ := ψ_YZ ∘ₗ ψ_XY` (linear-map composition).
* Commutative square: combine the two squares.
* Surjectivity: composition of surjections via diagram chase
  (hodgeClasses Z ⊆ image φ_YZ ⊆ image (φ_YZ ∘ φ_XY) on hodgeClasses X).

This gives `MTCorrespondencePackageAt` the structure of a (per-p)
category — together with R178's identity inhabitant, the category
axioms (id-composition + associativity) hold up to definitional
equality of the underlying linear maps. -/
theorem MTCorrespondencePackageAt.comp
    {X Y Z : VarietyCohomologyData}
    {A : AlgebraicClassesData X}
    {B : AlgebraicClassesData Y}
    {C : AlgebraicClassesData Z}
    {p : ℕ}
    (h_XY : MTCorrespondencePackageAt X Y A B p)
    (h_YZ : MTCorrespondencePackageAt Y Z B C p) :
    MTCorrespondencePackageAt X Z A C p := by
  letI _ := X.addCommGroup (2 * p); letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  letI _ := Y.addCommGroup (2 * p); letI _ := Y.module (2 * p)
  letI _ := Y.hodgeStructure (2 * p)
  letI _ := Z.addCommGroup (2 * p); letI _ := Z.module (2 * p)
  letI _ := Z.hodgeStructure (2 * p)
  unfold MTCorrespondencePackageAt at h_XY h_YZ
  obtain ⟨φ_XY, ψ_XY, h_sq_XY, h_surj_XY⟩ := h_XY
  obtain ⟨φ_YZ, ψ_YZ, h_sq_YZ, h_surj_YZ⟩ := h_YZ
  unfold MTCorrespondencePackageAt
  refine ⟨φ_YZ.comp φ_XY, ψ_YZ ∘ₗ ψ_XY, ?_, ?_⟩
  · -- commutative square: subtype (ψ_YZ (ψ_XY z)) = φ_YZ (φ_XY (subtype z))
    intro z
    rw [LinearMap.comp_apply, h_sq_YZ (ψ_XY z), h_sq_XY z]
    rfl
  · -- surjectivity: hodgeClasses Z ≤ map (φ_YZ ∘ φ_XY) (hodgeClasses X)
    intro w hw_HZ
    -- From h_surj_YZ: w = φ_YZ v_B for some v_B ∈ hodgeClasses Y
    obtain ⟨v_B, hv_B_HY, hv_B_eq⟩ := h_surj_YZ hw_HZ
    -- From h_surj_XY: v_B = φ_XY v_A for some v_A ∈ hodgeClasses X
    obtain ⟨v_A, hv_A_HX, hv_A_eq⟩ := h_surj_XY hv_B_HY
    -- Conclude w ∈ image of (φ_YZ ∘ φ_XY)
    refine ⟨v_A, hv_A_HX, ?_⟩
    rw [HodgeStructureMorphism.comp_toLinearMap_apply, hv_A_eq, hv_B_eq]

end HodgeReduction.Infrastructure.HodgeStructure
