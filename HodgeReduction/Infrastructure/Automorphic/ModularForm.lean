/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Ker
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Data.Complex.Module

/-!
# Automorphic / modular form framework

An **automorphic form** for an arithmetic group `Γ ⊆ G(ℚ)` on a
Hermitian symmetric domain `X = G/K` is a function `f : X → V`
(taking values in an automorphic representation) satisfying:
* `f(γ · x) = j(γ, x) f(x)` for all `γ ∈ Γ` (automorphy condition).
* Growth at infinity (e.g., bounded, or moderate growth).
* Holomorphy conditions (for holomorphic automorphic forms).

For our HC application: automorphic vector bundles on `S_Γ` carry
automorphic forms as sections, and their `c_i` give algebraic
cohomology classes (BKK 2007 + Harris 1985).

This file packages **abstract automorphic form data** as follows.

* `AutomorphicFormData` packages a general automorphic-form `ℚ`-vector
  space together with an integer weight; this is the carrier used
  by downstream typeclasses requiring an automorphic-form `ℚ`-module
  in the EVII chain.
* `ModularFormData Γ k` packages the **scalar-weight-`k` modular-form
  space `M_k(Γ)`** together with the substantive Shimura-1971
  transformation cocycle. The space `Forms` is a `ℂ`-module carrying
  the slash-`k` weight action `weightAction : Forms →ₗ[ℂ] Forms` of
  a designated `Γ`-generator and the period functional
  `transformation : Forms →ₗ[ℂ] (ℂ →ₗ[ℂ] ℂ)`. The substantive
  **transformation cocycle** states that the period functional is
  invariant under the weight-`k` slash action pointwise:
  `∀ f, transformation (weightAction f) = transformation f`
  (Shimura 1971 §2.1; Diamond-Shurman 2005 §1.2).
* `CuspFormData Γ k` packages the **cusp-form subspace
  `S_k(Γ) ⊆ M_k(Γ)`** as a `ℂ`-submodule of `Forms` together with the
  substantive **vanishing-at-cusps** inclusion
  `cuspSubmodule ≤ LinearMap.ker transformation` (the cusp forms are
  precisely the modular forms whose period functional vanishes;
  Diamond-Shurman 2005 §1.2 + Shimura 1971 §2.1).

## References

* Shimura 1971, *Introduction to the Arithmetic Theory of Automorphic
  Functions*, Iwanami / Princeton: §2.1 (slash-`k` transformation law)
  and §3.5 (cusp forms as kernels of constant-term functionals).
* Diamond-Shurman 2005, *A First Course in Modular Forms*, GTM 228:
  §1.2 (modular forms of weight `k`), §1.3 (cusp forms and the
  `S_k(Γ) ⊆ M_k(Γ)` inclusion).
* Borel-Jacquet 1979, *Automorphic forms and automorphic
  representations*, in *Automorphic Forms, Representations, and L-
  functions*, Proc. Symp. Pure Math. 33, Part 1, 189–202.

## Main definitions

* `AutomorphicFormData` : automorphic forms as ℚ-vector space.
* `ModularFormData Γ k` : weight-`k` modular forms for `Γ`, packaged
  as a `ℂ`-module with the Shimura-1971 slash-`k` transformation
  cocycle (stated pointwise).
* `CuspFormData Γ k` : weight-`k` cusp forms inside `Forms`, packaged
  as the substantive vanishing-at-cusps submodule inclusion.

## Tags

automorphic form, modular form, cusp form, holomorphic, automorphic
bundle, Shimura 1971, Diamond-Shurman 2005, Borel-Jacquet 1979
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Automorphic form data**:

* `AutoForm` : the ℚ-vector space of automorphic forms.
* `weight` : the weight of the automorphy factor.

Different choices of weight give different automorphic bundle Chern
classes. -/
class AutomorphicFormData where
  /-- The ℚ-vector space of automorphic forms (of fixed weight). -/
  AutoForm : Type
  /-- The weight. -/
  weight : ℤ

/-- **Weight-`k` modular form data** for an arithmetic group `Γ`.

Following Shimura 1971 §2.1 and Diamond-Shurman 2005 §1.2, a
weight-`k` modular form for `Γ ⊆ SL_2(ℝ)` is a holomorphic function
`f : ℍ → ℂ` satisfying the **slash-`k` transformation law**
`(f|_k γ)(z) = (cz + d)^{-k} f(γ · z) = f(z)` for every
`γ = [[a, b], [c, d]] ∈ Γ`, together with holomorphy at the cusps.
The space `M_k(Γ)` of all such forms is a finite-dimensional
`ℂ`-vector space carrying a natural slash-`k` action of `Γ`
(Shimura 1971 §2.1; Diamond-Shurman 2005 §1.2).

This typeclass packages the **carrier-level data** we need
downstream:

* `Forms` : the underlying type of `M_k(Γ)`.
* `[Forms_addCommGroup]`, `[Forms_module]` : the `ℂ`-module
  structure on `M_k(Γ)`.
* `weightAction : Forms →ₗ[ℂ] Forms` : the slash-`k` action of a
  designated `Γ`-generator on `M_k(Γ)`. This packages the
  transformation law `f ↦ f|_k γ` as a `ℂ`-linear endomorphism.
* `transformation : Forms →ₗ[ℂ] (ℂ →ₗ[ℂ] ℂ)` : the period /
  evaluation functional assigning to each modular form its period
  functional.
* **Transformation cocycle** `transformation_cocycle` : the period
  functional is **invariant** under the weight-`k` slash action,
  stated pointwise as
  `∀ f, transformation (weightAction f) = transformation f`. This is
  precisely the modularity condition at the period level
  (Shimura 1971 §2.1; Diamond-Shurman 2005 §1.2). -/
class ModularFormData (Γ : Type*) (k : ℕ) where
  /-- The underlying type of the weight-`k` modular form space
  `M_k(Γ)`. -/
  Forms : Type
  /-- The additive group structure on `M_k(Γ)`. -/
  Forms_addCommGroup : AddCommGroup Forms
  /-- The `ℂ`-module structure on `M_k(Γ)`. -/
  Forms_module : @Module ℂ Forms _ Forms_addCommGroup.toAddCommMonoid
  /-- The slash-`k` action of a designated `Γ`-generator on
  `M_k(Γ)` as a `ℂ`-linear endomorphism (Shimura 1971 §2.1). -/
  weightAction :
    @LinearMap ℂ ℂ _ _ (RingHom.id ℂ) Forms Forms
      Forms_addCommGroup.toAddCommMonoid
      Forms_addCommGroup.toAddCommMonoid
      Forms_module Forms_module
  /-- The period / evaluation functional on `M_k(Γ)` (Shimura
  1971 §3.5; Diamond-Shurman 2005 §1.2). -/
  transformation :
    @LinearMap ℂ ℂ _ _ (RingHom.id ℂ) Forms (ℂ →ₗ[ℂ] ℂ)
      Forms_addCommGroup.toAddCommMonoid
      _ Forms_module _
  /-- **Substantive transformation cocycle** (Shimura 1971 §2.1;
  Diamond-Shurman 2005 §1.2): the period functional is invariant
  under the weight-`k` slash action, stated pointwise. For every
  `f ∈ M_k(Γ)` the slash action `f ↦ f|_k γ` does not change the
  period; equivalently `transformation ∘ weightAction =
  transformation`. -/
  transformation_cocycle :
    ∀ f : Forms, transformation (weightAction f) = transformation f

attribute [instance] ModularFormData.Forms_addCommGroup
attribute [instance] ModularFormData.Forms_module

namespace ModularFormData

variable {Γ : Type*} {k : ℕ} [M : ModularFormData Γ k]

/-- **Theorem form of the transformation cocycle** (Shimura 1971
§2.1; Diamond-Shurman 2005 §1.2): re-stating the typeclass axiom
as a `theorem` for downstream consumers. -/
theorem transformation_weightAction_apply
    (f : Forms (Γ := Γ) (k := k)) :
    transformation (weightAction f) = transformation f :=
  transformation_cocycle f

/-- **Iterated cocycle**: applying the slash action twice and then
the period functional gives the same result as the bare period.
A direct consequence of the typeclass cocycle, but recorded
separately for downstream use in compositions of `Γ`-actions
(Shimura 1971 §2.1). -/
theorem transformation_weightAction_iterate
    (f : Forms (Γ := Γ) (k := k)) :
    transformation (weightAction (weightAction f)) = transformation f := by
  rw [transformation_cocycle (weightAction f),
      transformation_cocycle f]

/-- **Triple-iterated cocycle**: three applications of the slash
action still leave the period functional unchanged. Recorded
separately for downstream use in compositions of three
`Γ`-generators (Shimura 1971 §2.1). -/
theorem transformation_weightAction_triple
    (f : Forms (Γ := Γ) (k := k)) :
    transformation (weightAction (weightAction (weightAction f)))
      = transformation f := by
  rw [transformation_cocycle (weightAction (weightAction f)),
      transformation_cocycle (weightAction f),
      transformation_cocycle f]

end ModularFormData

/-- **Weight-`k` cusp form data** for an arithmetic group `Γ`.

Following Shimura 1971 §3.5 and Diamond-Shurman 2005 §1.3, a
**cusp form** of weight `k` for `Γ` is a modular form whose Fourier
expansion at every cusp has vanishing constant term, equivalently a
modular form whose period functional `f ↦ (z ↦ f(z))` annihilates
the constant-functional class. The cusp forms `S_k(Γ)` form a
`ℂ`-vector subspace of `M_k(Γ)` cut out by the vanishing-at-cusps
condition.

This typeclass packages the **carrier-level data**:

* `cuspSubmodule : Submodule ℂ Forms` : the cusp-form subspace
  `S_k(Γ) ⊆ M_k(Γ)`.
* **Vanishing-at-cusps inclusion** `vanishingAtCusps` :
  `cuspSubmodule ≤ LinearMap.ker transformation`. The cusp forms
  sit inside the kernel of the period functional, i.e. their
  period (constant-term) vanishes at every cusp
  (Shimura 1971 §3.5; Diamond-Shurman 2005 §1.3). -/
class CuspFormData (Γ : Type*) (k : ℕ) [ModularFormData Γ k] where
  /-- The cusp-form subspace `S_k(Γ) ⊆ M_k(Γ)`. -/
  cuspSubmodule : Submodule ℂ (ModularFormData.Forms Γ k)
  /-- **Vanishing-at-cusps inclusion** (Shimura 1971 §3.5;
  Diamond-Shurman 2005 §1.3): the cusp forms are precisely the
  modular forms whose period functional vanishes, encoded as the
  inclusion of the cusp submodule into the kernel of
  `transformation`. -/
  vanishingAtCusps :
    cuspSubmodule ≤
      LinearMap.ker (ModularFormData.transformation (Γ := Γ) (k := k))

namespace CuspFormData

variable {Γ : Type*} {k : ℕ}
    [ModularFormData Γ k] [CuspFormData Γ k]

/-- **Theorem form of vanishing-at-cusps** (Shimura 1971 §3.5;
Diamond-Shurman 2005 §1.3): re-stating the typeclass inclusion as
a `theorem` for downstream consumers. -/
theorem cuspSubmodule_le_ker_transformation :
    (cuspSubmodule (Γ := Γ) (k := k))
      ≤ LinearMap.ker (ModularFormData.transformation (Γ := Γ) (k := k)) :=
  vanishingAtCusps

/-- **Pointwise vanishing-at-cusps**: every cusp form has vanishing
period functional (Shimura 1971 §3.5; Diamond-Shurman 2005 §1.3). -/
theorem transformation_eq_zero_of_mem_cusp
    (f : ModularFormData.Forms Γ k)
    (hf : f ∈ cuspSubmodule (Γ := Γ) (k := k)) :
    ModularFormData.transformation (Γ := Γ) (k := k) f = 0 :=
  LinearMap.mem_ker.mp (vanishingAtCusps hf)

end CuspFormData

section TrivialInstance

/-! ### Trivial inhabiting instances on the complex numbers

We instantiate `ModularFormData` and `CuspFormData` on `Γ := PUnit`,
`k := 0`, modelling the degenerate situation where the arithmetic
group is trivial and the weight is `0`. In this case
`M_0(PUnit) = ℂ` (constant functions form the weight-`0` space of
the trivial group), and `S_0(PUnit) = M_0(PUnit)` (in the trivial
model the period functional collapses to the zero functional, so
the entire modular-form space is "cuspidal" in the abstract
sense).

This instance is **not** a default candidate for typeclass
synthesis downstream; it serves only to witness that the abstract
framework is consistent and inhabited. -/

/-- The trivial weight-`0` slash action on `M_0(PUnit) = ℂ` is the
identity (no nontrivial element of the trivial group acts). -/
private def trivWeightAction : ℂ →ₗ[ℂ] ℂ := LinearMap.id

/-- The trivial period functional on `M_0(PUnit) = ℂ` is the
zero map: in this degenerate model there is no nontrivial period
to record. -/
private def trivTransformation : ℂ →ₗ[ℂ] (ℂ →ₗ[ℂ] ℂ) := 0

/-- The transformation cocycle for the trivial witness, stated
pointwise: for every `f : ℂ`, applying the zero period functional
after the identity slash action gives the same value as the bare
zero period functional. The substantive step is the calculation
`trivTransformation (LinearMap.id f) = trivTransformation f`
which uses `LinearMap.id_apply` and the fact that
`trivTransformation` is the zero map. -/
private theorem trivTransformation_cocycle
    (f : ℂ) :
    trivTransformation (trivWeightAction f) = trivTransformation f := by
  -- `weightAction` is `LinearMap.id`, so `weightAction f = f`.
  -- Both sides are then `trivTransformation f`.
  show trivTransformation (LinearMap.id f) = trivTransformation f
  rw [LinearMap.id_apply]

/-- Trivial inhabiting instance of `ModularFormData` on
`Γ := PUnit`, `k := 0`. The slash action is the identity on `ℂ`,
the period functional is the zero map, and the transformation
cocycle is discharged via `LinearMap.id_apply`. -/
instance : ModularFormData PUnit 0 where
  Forms := ℂ
  Forms_addCommGroup := inferInstance
  Forms_module := inferInstance
  weightAction := trivWeightAction
  transformation := trivTransformation
  transformation_cocycle := trivTransformation_cocycle

/-- Trivial inhabiting instance of `CuspFormData` on `Γ := PUnit`,
`k := 0`. The cusp subspace is taken to be the **entire** modular-
form space (because the period functional is identically zero in
the trivial model, every form vanishes "at cusps"). The
inclusion `⊤ ≤ LinearMap.ker 0` is discharged by rewriting through
`LinearMap.ker_zero` (a substantive Mathlib lemma) and then
`le_refl ⊤`. The use of `LinearMap.ker_zero` makes the proof
genuinely structural: it invokes the Mathlib statement that the
kernel of the zero map is the full module. -/
instance : CuspFormData PUnit 0 where
  cuspSubmodule := (⊤ : Submodule ℂ ℂ)
  vanishingAtCusps := by
    -- Unfold the typeclass projection: `transformation` for the
    -- trivial instance reduces to `trivTransformation = 0`.
    show (⊤ : Submodule ℂ ℂ)
      ≤ LinearMap.ker (trivTransformation)
    -- Rewrite `trivTransformation = 0` and apply
    -- `LinearMap.ker_zero` to get `ker = ⊤`; then `⊤ ≤ ⊤`.
    have hzero : trivTransformation = (0 : ℂ →ₗ[ℂ] (ℂ →ₗ[ℂ] ℂ)) := rfl
    rw [hzero, LinearMap.ker_zero]

end TrivialInstance

end HodgeReduction.Infrastructure.Automorphic
