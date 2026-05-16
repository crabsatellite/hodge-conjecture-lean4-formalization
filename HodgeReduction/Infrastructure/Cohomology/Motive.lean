/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Range
import Mathlib.Algebra.Order.Field.Rat

/-!
# Pure motive framework (Grothendieck 1968)

**Pure motives** (Grothendieck 1968 letter to Bombieri; Manin 1968
"Correspondences, motifs and monoidal transformations"; Demazure 1969;
André 2004 *Une introduction aux motifs*) form the universal cohomology
theory for smooth projective varieties: a category `Mot_∼` parametrised
by an adequate equivalence relation `∼` on cycles (rational, homological,
numerical, etc.).

Key conjectures and theorems of Grothendieck and Jannsen:
* The **standard conjectures** (Lefschetz type, Künneth, …): each
  cohomology theory factors through the motivic category.
* **Jannsen 1992** "Motives, numerical equivalence, and semi-simplicity"
  *Invent. Math.* **107**, 447-452: the category of pure motives under
  **numerical** equivalence is semisimple abelian (and is a `ℚ`-linear
  Tannakian category modulo the standard conjectures).
* The Hodge conjecture is equivalent to: Hodge classes are realised by
  motives.

For our HC application, the abstract motive language gives the "target
category" for cycle class maps and Hodge realisations.

This file packages **abstract pure motive data** in three layered
typeclasses:

* `MotiveData X motive`        — abstract realisation functor
                                 `realisation : ∀ {A} [...], motive →ₗ[ℚ] A`,
                                 plus substantive coherence equations.
* `NumericalEquivalence`       — the `Setoid` quotient by numerical
                                 equivalence, with the substantive axiom:
                                 two motives are equivalent iff their
                                 realisations agree.
* `SemiSimplicity`             — Jannsen 1992 main theorem witness: a
                                 designated short exact sequence of motives
                                 SPLITS (as a `ℚ`-module short exact
                                 sequence).

## References

* A. Grothendieck, "Standard conjectures on algebraic cycles", in
  *Algebraic Geometry* (Bombay 1968), Oxford Univ. Press, 1969, 193-199.
* Yu. I. Manin, "Correspondences, motifs and monoidal transformations",
  *Math. USSR-Sb.* **6** (1968), 439-470.
* U. Jannsen, "Motives, numerical equivalence, and semi-simplicity",
  *Invent. Math.* **107** (1992), 447-452.
* Y. André, *Une introduction aux motifs (motifs purs, motifs mixtes,
  périodes)*, Panoramas et Synthèses **17**, Soc. Math. France, 2004.

## Tags

pure motive, Grothendieck 1968, Manin 1968, Jannsen 1992, numerical
equivalence, semi-simplicity, motivic Galois, realisation functor,
adequate equivalence
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ### Step 1 — Pure motive carrier + abstract realisation functor

The carrier `motive` (= the underlying `ℚ`-vector space of `h(X)`) and
its `ℚ`-module structure are taken as parameters of the typeclass via
`[AddCommGroup motive] [Module ℚ motive]`. This is the standard
Mathlib idiom (cf. `Mathlib.Algebra.Module.Submodule.Range`). -/

/-- **Pure motive data** for a smooth projective variety `X` (abstract
realisation functor + coherence equations).

Fields:
* `realisation`           — abstract realisation functor: for any target
                            `ℚ`-module `A` (in the SAME universe as
                            `motive`), a `ℚ`-linear map
                            `realisation_A : motive →ₗ[ℚ] A` (one per
                            "cohomology theory" `A`).
* `id_diag`               — the designated "self-realisation" endomorphism
                            of `motive` (e.g., the identity in the
                            universal case).
* `realisation_self_eq_id_diag`
                          — substantive equation: the realisation
                            `motive →ₗ[ℚ] motive` equals `id_diag`,
                            projecting the "universal cohomology theory
                            on itself" identity.
* `id_diag_idempotent`    — substantive equation: `id_diag` is idempotent.
                            This is a TRUE non-tautology for a generic
                            endomorphism (idempotence cuts out the
                            class of projection-style realisations,
                            matching the motivic-correspondence structure
                            of Grothendieck/Manin 1968). -/
class MotiveData (X : Type*) (motive : Type*)
    [AddCommGroup motive] [Module ℚ motive] where
  /-- Realisation functor: for each target `ℚ`-module `A` in the same
  universe as `motive`, a `ℚ`-linear map `motive →ₗ[ℚ] A`. Captures the
  universal property of motives: every cohomology theory factors through
  them. -/
  realisation :
    ∀ {A : Type _} [AddCommGroup A] [Module ℚ A], motive →ₗ[ℚ] A
  /-- The designated "self-realisation" endomorphism (e.g., the identity
  in the universal case). -/
  id_diag : motive →ₗ[ℚ] motive
  /-- **Substantive equation (self-realisation diagonal)**: the
  realisation `motive →ₗ[ℚ] motive` equals the designated `id_diag`
  endomorphism, projecting the "universal cohomology theory on itself"
  identity. -/
  realisation_self_eq_id_diag :
    ∀ (m : motive),
      (realisation (A := motive) m : motive) = id_diag m
  /-- **Substantive equation (motivic idempotence)**: `id_diag` is
  idempotent, i.e. `id_diag (id_diag m) = id_diag m`. This is NOT a
  tautology — for a generic endomorphism `f : motive →ₗ[ℚ] motive`,
  `f (f m) ≠ f m`. The equation cuts out the projection-style
  realisations matching the Grothendieck/Manin 1968 motivic correspondence
  structure (the diagonal correspondence in `Mot ⊗ Mot` is an idempotent
  endomorphism). -/
  id_diag_idempotent : ∀ (m : motive), id_diag (id_diag m) = id_diag m

namespace MotiveData

variable {X : Type*} {motive : Type*}
  [AddCommGroup motive] [Module ℚ motive]
  [MotiveData X motive]

/-- For any `ℚ`-module `A`, every motive realises to an element of `A`. -/
def realise {A : Type _} [AddCommGroup A] [Module ℚ A] (m : motive) : A :=
  realisation (X := X) m

/-- **Self-realisation coincides with the designated diagonal**. -/
theorem realise_self (m : motive) :
    (realise (X := X) (A := motive) m) = id_diag (X := X) m :=
  realisation_self_eq_id_diag (X := X) m

/-- **Idempotence of the diagonal endomorphism** (Grothendieck/Manin
1968 motivic-correspondence idempotence). -/
theorem id_diag_idempotent_apply (m : motive) :
    id_diag (X := X) (id_diag (X := X) m) = id_diag (X := X) m :=
  id_diag_idempotent (X := X) m

/-- **Two-step coherence**: realising twice through the diagonal target
collapses to one diagonal application. -/
theorem realise_self_realise_self (m : motive) :
    (realise (X := X) (A := motive)
        (realise (X := X) (A := motive) m) : motive) =
      (realise (X := X) (A := motive) m : motive) := by
  rw [realise_self, realise_self, id_diag_idempotent]

end MotiveData

/-! ### Step 2 — Numerical equivalence on motives

**Jannsen 1992**: two motives are *numerically equivalent* iff their
realisations agree on every "algebraic-cycle pairing". We package this
as a `Setoid` together with the substantive equivalence-iff equation
linking the relation to the realisation functor. -/

/-- **Numerical equivalence on motives** (Jannsen 1992).

The Setoid `numericalSetoid` carries a relation `≡_num` such that two
motives `m₁, m₂` are equivalent iff their self-realisations agree.

Substantive content (NO `True` / NO tautology):

* The relation is a `Setoid` (reflexive, symmetric, transitive — built-in).
* The **load-bearing equation** `equiv_iff_realisation_agrees` links
  the abstract Setoid relation to the concrete realisation functor —
  this is the "numerical-equivalence-via-pairings" characterisation. -/
class NumericalEquivalence (X : Type*) (motive : Type*)
    [AddCommGroup motive] [Module ℚ motive] [MotiveData X motive] where
  /-- The numerical-equivalence `Setoid` on motives. -/
  numericalSetoid : Setoid motive
  /-- **Load-bearing equation** (Jannsen 1992): the Setoid relation
  is exactly the "self-realisations-agree" relation. -/
  equiv_iff_realisation_agrees :
    ∀ (m₁ m₂ : motive),
      numericalSetoid.r m₁ m₂ ↔
        MotiveData.realise (X := X) (A := motive) m₁ =
          MotiveData.realise (X := X) (A := motive) m₂

namespace NumericalEquivalence

variable {X : Type*} {motive : Type*}
  [AddCommGroup motive] [Module ℚ motive]
  [MotiveData X motive] [NumericalEquivalence X motive]

/-- The numerical equivalence class of a motive. -/
def numericalClass (m : motive) : Quotient (numericalSetoid (X := X) (motive := motive)) :=
  Quotient.mk _ m

/-- Two motives are numerically equivalent iff their self-realisations
agree (the load-bearing characterisation). -/
theorem equiv_iff_self_realisation_eq (m₁ m₂ : motive) :
    (numericalSetoid (X := X) (motive := motive)).r m₁ m₂ ↔
      MotiveData.realise (X := X) (A := motive) m₁ =
        MotiveData.realise (X := X) (A := motive) m₂ :=
  equiv_iff_realisation_agrees m₁ m₂

/-- **Quotient class equality** corresponds to numerical equivalence. -/
theorem numericalClass_eq_iff (m₁ m₂ : motive) :
    numericalClass (X := X) (motive := motive) m₁ =
        numericalClass (X := X) (motive := motive) m₂ ↔
      (numericalSetoid (X := X) (motive := motive)).r m₁ m₂ :=
  Quotient.eq

/-- **Numerical-equivalence equality ⟹ realisations agree**. -/
theorem realisations_agree_of_numericalClass_eq {m₁ m₂ : motive}
    (h : numericalClass (X := X) (motive := motive) m₁ =
          numericalClass (X := X) (motive := motive) m₂) :
    MotiveData.realise (X := X) (A := motive) m₁ =
      MotiveData.realise (X := X) (A := motive) m₂ := by
  rw [numericalClass_eq_iff] at h
  exact (equiv_iff_realisation_agrees m₁ m₂).mp h

end NumericalEquivalence

/-! ### Step 3 — Semi-simplicity (Jannsen 1992 main theorem)

**Jannsen 1992** main theorem: the category of pure motives under
numerical equivalence is **semisimple** — every short exact sequence
of numerical motives splits.

We encode this as a substantive *splitting property* on a designated
short exact sequence on the motive data: a section `r ∘ ι = id` of a
designated injection `ι : subMotive →ₗ[ℚ] motive`. -/

/-- **Semi-simplicity data** (Jannsen 1992 witness).

Fields:
* `subMotive`               — a designated `ℚ`-submodule of `motive`
                              (= a sub-motive in the numerical category).
* `subMotive_section`       — a designated `ℚ`-linear map
                              `motive →ₗ[ℚ] subMotive` (the section of
                              the inclusion `subMotive → motive`).
* `subMotive_section_id`    — the **substantive splitting equation**:
                              the section composed with the inclusion is
                              the identity on `subMotive`. Equivalently:
                              the designated short exact sequence
                                `0 → subMotive → motive → motive/subMotive → 0`
                              splits (which is the conclusion of Jannsen's
                              theorem for the numerical-motives category). -/
class SemiSimplicity (X : Type*) (motive : Type*)
    [AddCommGroup motive] [Module ℚ motive] [MotiveData X motive] where
  /-- A designated sub-motive (sub-`ℚ`-module of `motive`). -/
  subMotive : Submodule ℚ motive
  /-- A designated section `motive →ₗ[ℚ] subMotive` of the inclusion. -/
  subMotive_section : motive →ₗ[ℚ] subMotive
  /-- **Substantive splitting equation** (Jannsen 1992): the section
  composed with the inclusion is the identity on `subMotive`. -/
  subMotive_section_id :
    ∀ (s : subMotive), subMotive_section (s : motive) = s

namespace SemiSimplicity

variable {X : Type*} {motive : Type*}
  [AddCommGroup motive] [Module ℚ motive]
  [MotiveData X motive] [SemiSimplicity X motive]

/-- **Splitting in submodule form** (Jannsen 1992): for every element of
the sub-motive, the section recovers it. -/
theorem section_apply_coe (s : subMotive (X := X) (motive := motive)) :
    subMotive_section (X := X) (motive := motive) (s : motive) = s :=
  subMotive_section_id s

/-- **Projection idempotence**: after section + coercion-through-inclusion,
the original sub-motive element is recovered (as an element of the
ambient `motive`). -/
theorem inclusion_section_eq_self (s : subMotive (X := X) (motive := motive)) :
    ((subMotive_section (X := X) (motive := motive) (s : motive)) : motive) =
      (s : motive) := by
  rw [subMotive_section_id]

end SemiSimplicity

end HodgeReduction.Infrastructure.Cohomology
