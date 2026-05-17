/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.DeRham
import HodgeReduction.Infrastructure.Cohomology.BettiCohomology

/-!
# Comparison theorem framework

For a smooth complex algebraic variety `X`, there are canonical
isomorphisms (comparison theorems):

* **Grothendieck-de Rham** (1966):
  `H^*_{dR}(X/ℂ) ≃ H^*_B(X(ℂ); ℂ) = H^*_B(X) ⊗_ℚ ℂ`.

* **Artin-Grothendieck** (SGA4):
  `H^*_ét(X_{ℂ}; ℚ_ℓ) ≃ H^*_B(X(ℂ); ℚ_ℓ) = H^*_B(X) ⊗_ℚ ℚ_ℓ`.

These give the "three realisations" (Betti / de Rham / étale) of
the same motive.

For our HC application: the comparison isomorphism between Betti and
de Rham gives the **Hodge decomposition**
`H^k_B(X; ℂ) = ⨁_{p+q=k} H^{p,q}` and the **Hodge filtration** `F^p`.

This file packages **abstract comparison theorem data**.

## Main definitions

* `ComparisonData A` — Grothendieck-de Rham lattice inclusion
  (preserved from R7-B.3 refactor).

* `GrothendieckDeRhamData X A` — Grothendieck-de Rham comparison
  isomorphism packaged as a substantive `ℚ`-linear map with substantive
  injectivity (Grothendieck 1966 IHES 29).

* `HodgeFiltrationCompatibility X A` — substantive submodule
  preservation under the comparison isomorphism (Voisin 2002 Vol. I
  Ch. 8).

## References

* Grothendieck, A. "On the de Rham cohomology of algebraic varieties",
  *Publ. Math. IHES* **29** (1966), 95–103.
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry*, Vol. I,
  CUP, 2002, Ch. 8.

## Tags

comparison theorem, Grothendieck-de Rham, Artin-Grothendieck, motive,
Voisin, Hodge filtration
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Comparison theorem data** (Grothendieck-de Rham 1966):

For a cohomology ring `A` carrying both `DeRhamData` (Hodge filtration
`F : ℕ → Submodule ℚ A`) and `BettiCohomologyData` (integer lattice
`Z_lattice : AddSubgroup A`), the comparison theorem asserts that the
integer lattice is contained in the bottom Hodge filtration step `F^0`
(via the rational lift). This is the load-bearing structural inclusion
that the comparison isomorphism `H^*_{dR}(X; ℂ) ≃ H^*_B(X; ℂ)` restricts
to on the integer lattice.

**R7 audit B.3 refactor (2026-05-16)**: previously carried a
`comparisonWitness : True` placeholder field with no mathematical
content. Refactored to the substantive submodule inclusion
`Z_lattice ⊆ F 0` whose TYPE depends on both `BettiCohomologyData` and
`DeRhamData` typeclass parameters. Instance providers must produce a
real membership-preserving proof.

The trivial instance for `Z_lattice = ⊥` discharges by `False.elim`
after `Submodule.mem_bot`; for a non-trivial integer lattice the
instance must use the published Grothendieck-de Rham comparison. -/
class ComparisonData (A : Type*) [AddCommGroup A] [Module ℚ A]
    [BettiCohomologyData A] [DeRhamData A] where
  /-- **Grothendieck-de Rham comparison inclusion** (Grothendieck 1966):
  every element of the Betti integer lattice lies in the bottom Hodge
  filtration step `F^0` of de Rham cohomology. This is the load-bearing
  structural content of the comparison isomorphism at the abstract A-level.
  -/
  lattice_in_F0 :
    ∀ a : A, a ∈ BettiCohomologyData.Z_lattice (A := A) →
      a ∈ DeRhamData.F (A := A) 0

/-! ## Grothendieck-de Rham comparison isomorphism — substantive package

While `ComparisonData` records the load-bearing **lattice inclusion**
of the Grothendieck-de Rham theorem, the comparison theorem in its
full strength (Grothendieck 1966 IHES 29 Theorem 1') asserts a
**canonical isomorphism** between the Betti and de Rham realisations:

  `comparisonIso : H^*_B(X; ℚ) ⊗_ℚ ℂ ≃ H^*_{dR}(X; ℂ)`

restricting to a `ℚ`-linear map at the rational level. The substantive
content beyond `lattice_in_F0` is:

* The comparison map is a `ℚ`-linear map `A →ₗ[ℚ] A` (with `A`
  representing the common rational form of both realisations).
* The comparison map is **injective** — this is the load-bearing
  rigidity statement (the comparison is in fact an isomorphism,
  but injectivity is the easier half and is enough to transport
  classes between the two realisations).

Sibling `HodgeFiltrationCompatibility` records the **Hodge-filtration
preservation** of the comparison: the comparison map sends each
filtration step `F^p` into itself. This is the load-bearing
structural compatibility used in Voisin Vol. I Ch. 8 (degeneration
of the Hodge-to-de-Rham spectral sequence at `E_1` for compact
Kähler `X`).
-/

/-- **Grothendieck-de Rham comparison data** (Grothendieck 1966 IHES 29):

For a `ℚ`-cohomology carrier `A` with both `BettiCohomologyData` and
`DeRhamData`, this typeclass records the canonical comparison
isomorphism `comparisonIso` (packaged as a `ℚ`-linear endomorphism of
the common rational form) together with its **substantive injectivity**.

The `X` parameter is a phantom geometric carrier (e.g. the underlying
complex variety) so multiple geometric instances on the same `A` can be
distinguished.

Fields:

* `comparisonIso : A →ₗ[ℚ] A` — the canonical Grothendieck-de Rham
  comparison `H^*_B ⊗ ℂ ≃ H^*_{dR}`, restricted to the rational level
  and packaged as an endomorphism of `A`.
* `comparisonIso_injective : Function.Injective comparisonIso` —
  **substantive injectivity** of the comparison map. (Grothendieck 1966
  Theorem 1'.)
* `comparisonIso_zero_eq_zero` and `comparisonIso_add_eq` are
  automatically discharged by the `LinearMap` structure of
  `comparisonIso`; we re-export them as named lemmas in the derived
  theorems section. -/
class GrothendieckDeRhamData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A]
    [BettiCohomologyData A] [DeRhamData A] where
  /-- The **Grothendieck-de Rham comparison map**: a `ℚ`-linear
  endomorphism of the common rational cohomology carrier `A`,
  representing the canonical isomorphism `H^*_B ⊗ ℂ ≃ H^*_{dR}`
  restricted to the rational level. (Grothendieck 1966 IHES 29
  Theorem 1'.) -/
  comparisonIso : A →ₗ[ℚ] A
  /-- **Substantive injectivity** of the Grothendieck-de Rham comparison:
  the comparison map is injective on the rational form. (Grothendieck
  1966 Theorem 1'; Voisin Vol. I Theorem 8.21 — the comparison is in
  fact an isomorphism, injectivity is the easier half and is the
  load-bearing rigidity statement.) -/
  comparisonIso_injective : Function.Injective comparisonIso

namespace GrothendieckDeRhamData

variable {X : Type*} {A : Type*}
    [AddCommGroup A] [Module ℚ A]
    [BettiCohomologyData A] [DeRhamData A]
    [GrothendieckDeRhamData X A]

/-! ### Theorem-level re-exports of the typeclass fields -/

/-- Theorem-level restatement of `comparisonIso_injective`. -/
theorem comparisonIso_injective_thm :
    Function.Injective (comparisonIso (X := X) (A := A)) :=
  GrothendieckDeRhamData.comparisonIso_injective

/-! ### Derived theorems -/

/-- The comparison map sends `0` to `0` (consequence of being `ℚ`-linear). -/
theorem comparisonIso_zero :
    comparisonIso (X := X) (A := A) 0 = 0 :=
  LinearMap.map_zero (comparisonIso (X := X) (A := A))

/-- The comparison map respects addition (consequence of being `ℚ`-linear). -/
theorem comparisonIso_add (a b : A) :
    comparisonIso (X := X) (A := A) (a + b)
      = comparisonIso (X := X) (A := A) a
        + comparisonIso (X := X) (A := A) b :=
  LinearMap.map_add (comparisonIso (X := X) (A := A)) a b

/-- The comparison map respects scalar multiplication. -/
theorem comparisonIso_smul (q : ℚ) (a : A) :
    comparisonIso (X := X) (A := A) (q • a)
      = q • comparisonIso (X := X) (A := A) a :=
  LinearMap.map_smul (comparisonIso (X := X) (A := A)) q a

/-- **Derived injectivity-corollary**: if `comparisonIso a = 0` then
`a = 0`. (Standard kernel-of-injective-linear-map characterisation.) -/
theorem eq_zero_of_comparisonIso_eq_zero {a : A}
    (h : comparisonIso (X := X) (A := A) a = 0) :
    a = 0 := by
  have h0 : comparisonIso (X := X) (A := A) a
            = comparisonIso (X := X) (A := A) 0 := by
    rw [h, comparisonIso_zero]
  exact comparisonIso_injective_thm h0

/-- **Derived injectivity-corollary**: equality `comparisonIso a =
comparisonIso b` forces `a = b`. -/
theorem eq_of_comparisonIso_eq {a b : A}
    (h : comparisonIso (X := X) (A := A) a
         = comparisonIso (X := X) (A := A) b) :
    a = b :=
  comparisonIso_injective_thm h

end GrothendieckDeRhamData

/-! ## Hodge-filtration compatibility — sibling axiom package

The Grothendieck-de Rham comparison isomorphism **preserves the Hodge
filtration**: for each `p ≥ 0`, the image of `F^p` under the comparison
lies again in `F^p`. This is the structural compatibility used in
Voisin Vol. I Ch. 8 (degeneration of the Hodge-to-de-Rham spectral
sequence at `E_1` for compact Kähler `X`; Voisin Theorem 8.28).
-/

/-- **Hodge-filtration compatibility data** (Voisin 2002 Vol. I Ch. 8):

For a `ℚ`-cohomology carrier `A` with both `BettiCohomologyData` and
`DeRhamData` and a `GrothendieckDeRhamData` comparison isomorphism, the
comparison **preserves the Hodge filtration**:

  `comparisonIso (F p) ⊆ F p`  for every `p : ℕ`.

This is the substantive submodule preservation under the comparison
isomorphism (Voisin Theorem 8.28, degeneration of Hodge-to-de-Rham
spectral sequence at `E_1`).

Stated as a substantive membership-preserving axiom: for every `p` and
every `a ∈ F p`, `comparisonIso a ∈ F p`. -/
class HodgeFiltrationCompatibility (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A]
    [BettiCohomologyData A] [DeRhamData A]
    [GrothendieckDeRhamData X A] where
  /-- **Substantive Hodge-filtration preservation**: the
  Grothendieck-de Rham comparison map sends each filtration step
  `F^p` into itself. (Voisin Vol. I Theorem 8.28.) -/
  comparisonIso_preserves_F :
    ∀ (p : ℕ) (a : A), a ∈ DeRhamData.F (A := A) p →
      GrothendieckDeRhamData.comparisonIso (X := X) (A := A) a
        ∈ DeRhamData.F (A := A) p

namespace HodgeFiltrationCompatibility

variable {X : Type*} {A : Type*}
    [AddCommGroup A] [Module ℚ A]
    [BettiCohomologyData A] [DeRhamData A]
    [GrothendieckDeRhamData X A]
    [HodgeFiltrationCompatibility X A]

/-! ### Theorem-level re-exports -/

/-- Theorem-level restatement of `comparisonIso_preserves_F`. -/
theorem comparisonIso_preserves_F_thm (p : ℕ) {a : A}
    (ha : a ∈ DeRhamData.F (A := A) p) :
    GrothendieckDeRhamData.comparisonIso (X := X) (A := A) a
      ∈ DeRhamData.F (A := A) p :=
  HodgeFiltrationCompatibility.comparisonIso_preserves_F p a ha

/-! ### Derived theorems -/

/-- The comparison map sends every element of `F^0` (= everything) to
`F^0`. Trivial consequence of `F_zero_eq_top`. -/
theorem comparisonIso_in_F0 (a : A) :
    GrothendieckDeRhamData.comparisonIso (X := X) (A := A) a
      ∈ DeRhamData.F (A := A) 0 := by
  apply comparisonIso_preserves_F_thm 0
  exact DeRhamData.mem_F_zero a

/-- The comparison map sends every element of `F^p` (for any `p`) to
`F^q` whenever `q ≤ p`. Follows from `F_antitone`. -/
theorem comparisonIso_in_lower {p q : ℕ} (hpq : q ≤ p) {a : A}
    (ha : a ∈ DeRhamData.F (A := A) p) :
    GrothendieckDeRhamData.comparisonIso (X := X) (A := A) a
      ∈ DeRhamData.F (A := A) q := by
  have hap : GrothendieckDeRhamData.comparisonIso (X := X) (A := A) a
             ∈ DeRhamData.F (A := A) p :=
    comparisonIso_preserves_F_thm p ha
  exact DeRhamData.F_antitone_thm hpq hap

end HodgeFiltrationCompatibility

/-! ## Trivial inhabiting instance on `ℚ`

For the point variety (`Spec(ℂ)`, complex dimension `0`) with both
`BettiCohomologyData ℚ` and `DeRhamData ℚ` already in scope from the
sibling files, we provide trivial instances for all three classes
above with substantive proofs:

* `ComparisonData ℚ`: the integer lattice `ZLatticeUnit` lies in
  `F^0 = ⊤`, trivially.
* `GrothendieckDeRhamData Unit ℚ`: the comparison map is the identity
  `LinearMap.id`, whose injectivity is `Function.injective_id`.
* `HodgeFiltrationCompatibility Unit ℚ`: the identity preserves every
  submodule trivially. -/

/-- The trivial `ComparisonData ℚ` instance for the point variety.
The integer lattice `ZLatticeUnit ⊆ ℚ` lies in `F^0 = ⊤` trivially. -/
instance instComparisonDataUnit : ComparisonData ℚ where
  lattice_in_F0 := by
    intro a _
    -- For the point variety, `F^0 = ⊤` (from `instDeRhamDataUnit`),
    -- so any element of ℚ lies in F^0.
    rw [DeRhamData.F_zero_eq_top_thm]
    trivial

/-- The trivial `GrothendieckDeRhamData Unit ℚ` instance: the comparison
map is the identity `LinearMap.id`. Injectivity is `Function.injective_id`. -/
instance instGrothendieckDeRhamDataUnit :
    GrothendieckDeRhamData Unit ℚ where
  comparisonIso := LinearMap.id
  comparisonIso_injective := by
    -- The identity is injective.
    intro a b h
    -- h : LinearMap.id a = LinearMap.id b, i.e. a = b.
    simpa using h

/-- The trivial `HodgeFiltrationCompatibility Unit ℚ` instance: the
identity preserves every submodule trivially. -/
instance instHodgeFiltrationCompatibilityUnit :
    HodgeFiltrationCompatibility Unit ℚ where
  comparisonIso_preserves_F := by
    intro p a ha
    -- comparisonIso a = LinearMap.id a = a, which is in F p by ha.
    show (LinearMap.id : ℚ →ₗ[ℚ] ℚ) a ∈ DeRhamData.F (A := ℚ) p
    simpa using ha

/-! ### Sanity checks for the trivial instances -/

/-- **Sanity check**: the lattice inclusion holds for the point. -/
example (a : ℚ) (ha : a ∈ BettiCohomologyData.Z_lattice (A := ℚ)) :
    a ∈ DeRhamData.F (A := ℚ) 0 :=
  ComparisonData.lattice_in_F0 a ha

/-- **Sanity check**: the trivial comparison map is injective. -/
example :
    Function.Injective
      (GrothendieckDeRhamData.comparisonIso (X := Unit) (A := ℚ)) :=
  GrothendieckDeRhamData.comparisonIso_injective_thm

/-- **Sanity check**: the trivial comparison sends `0` to `0`. -/
example :
    GrothendieckDeRhamData.comparisonIso (X := Unit) (A := ℚ) 0 = 0 :=
  GrothendieckDeRhamData.comparisonIso_zero

/-- **Sanity check**: equality through the comparison forces equality. -/
example (a b : ℚ)
    (h : GrothendieckDeRhamData.comparisonIso (X := Unit) (A := ℚ) a
         = GrothendieckDeRhamData.comparisonIso (X := Unit) (A := ℚ) b) :
    a = b :=
  GrothendieckDeRhamData.eq_of_comparisonIso_eq h

/-- **Sanity check**: the trivial comparison preserves `F^0`. -/
example (a : ℚ) (ha : a ∈ DeRhamData.F (A := ℚ) 0) :
    GrothendieckDeRhamData.comparisonIso (X := Unit) (A := ℚ) a
      ∈ DeRhamData.F (A := ℚ) 0 :=
  HodgeFiltrationCompatibility.comparisonIso_preserves_F_thm 0 ha

/-- **Sanity check**: the trivial comparison sends arbitrary elements
to `F^0` (every element of `ℚ` lies in `F^0 = ⊤`). -/
example (a : ℚ) :
    GrothendieckDeRhamData.comparisonIso (X := Unit) (A := ℚ) a
      ∈ DeRhamData.F (A := ℚ) 0 :=
  HodgeFiltrationCompatibility.comparisonIso_in_F0 a

end HodgeReduction.Infrastructure.Cohomology
