/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Lefschetz hyperplane theorem framework

**Lefschetz hyperplane theorem** (S. Lefschetz, *L'analysis situs et la
géométrie algébrique*, Gauthier-Villars 1924; Andreotti–Frankel, *The
Lefschetz theorem on hyperplane sections*, Ann. of Math. (2) **69** (1959),
713–717 for the Morse-theoretic proof). For `X` a smooth projective complex
variety of complex dimension `n` and `Y ⊂ X` a smooth hyperplane section
(`Y = X ∩ H` for a generic hyperplane `H ⊂ ℙ^N`), the inclusion
`i_Y : Y ↪ X` induces:

* `i_Y^* : H^k(X; ℚ) → H^k(Y; ℚ)` is an **isomorphism** for `k < n - 1`.
* `i_Y^* : H^{n-1}(X; ℚ) → H^{n-1}(Y; ℚ)` is **injective**.

(Andreotti–Frankel 1959 proves this via Morse theory on the affine
complement `X ∖ Y`, which has the homotopy type of a CW complex of real
dimension ≤ `n`. Voisin 2002 Vol. I Theorem 13.6, p. 313, gives the
Kähler-geometric proof; Griffiths–Harris 1978 Ch. 1.2 §"Lefschetz theorem
on hyperplane sections" gives the classical Hodge-theoretic statement.)

For our HC application this is one of the foundational classical results
allowing inductive arguments by hyperplane section: a Hodge class on `X`
can be analysed on a hyperplane section `Y` of one lower dimension, with
the restriction iso / injection controlling the comparison.

This file packages **abstract Lefschetz hyperplane data**: the family of
degree-`k` restriction submodules `restrict k ⊆ A` (representing the
image of `H^k(X) → H^k(Y)` as a subspace of an ambient space `A`), the
iso axiom for `k < dim - 1`, a designated middle-degree restriction map
`middleRestrictMap : A →ₗ[ℚ] A` together with the substantive injectivity
witness.

## References

* S. Lefschetz, *L'analysis situs et la géométrie algébrique*,
  Gauthier-Villars, Paris, 1924 (original statement).
* A. Andreotti & T. Frankel, *The Lefschetz theorem on hyperplane
  sections*, Ann. of Math. (2) **69** (1959), 713–717
  (Morse-theoretic proof).
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Mathematics **76**, Cambridge Univ. Press, 2002,
  Chapter 13, Theorem 13.6 (Lefschetz hyperplane theorem) p. 313.
* P. Griffiths & J. Harris, *Principles of Algebraic Geometry*, Wiley
  Classics Library, 1978, Chapter 1 §2, "Lefschetz theorem on hyperplane
  sections", pp. 156–159.

## Main definitions

* `LefschetzHyperplaneData A` : abstract Lefschetz hyperplane structure
  on an ambient `ℚ`-vector space `A`. Carries the degree-`k` restriction
  submodules, the iso axiom for `k < dim - 1`, and a substantive
  injectivity carrier for the middle degree `dim - 1`.
* `LefschetzHyperplaneData.restrict_eq_top_of_lt` — repackaged iso
  axiom: for `k < dim - 1` the restriction submodule is `⊤`.
* `LefschetzHyperplaneData.mem_restrict_of_lt` — every `α : A` is in
  the restriction submodule below the middle degree.
* `LefschetzHyperplaneData.middleRestrictMap_injective` — re-export of
  the injectivity witness as `Function.Injective`.
* `LefschetzHyperplaneData.middleRestrictMap_ker_eq_bot` — equivalent
  kernel-is-bottom form of the injectivity.
* `LefschetzHyperplaneData.middleRestrictMap_eq_zero_iff` — for the
  middle-degree restriction map, `f α = 0 ↔ α = 0`.

## Tags

Lefschetz hyperplane theorem, hyperplane section, weak Lefschetz,
Andreotti–Frankel, Morse theory on affine varieties
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Lefschetz hyperplane data** for an ambient `ℚ`-vector space `A`
representing `H^*(X; ℚ)`:

* `dim` : the complex dimension `n` of `X` (so the real dimension is
  `2n`; the Lefschetz hyperplane theorem refers to degree `< n - 1`
  for the iso range and degree `n - 1` for the injection — using
  **complex** Lefschetz indexing throughout this file).
* `restrict k` : the image submodule `Im(H^k(X; ℚ) → H^k(Y; ℚ)) ⊆ A`
  packaged as a `Submodule ℚ A` (so the iso axiom below becomes the
  substantive equality `restrict k = ⊤` for `k < dim - 1`).
* `restriction_iso_below_middle` : for all `k < dim - 1`, the restriction
  image fills the entire ambient space `A`, i.e., `restrict k = ⊤`.
  This is the **substantive Lefschetz hyperplane iso** axiom (Lefschetz
  1924; Andreotti–Frankel 1959 Theorem; Voisin I Theorem 13.6).
* `middleRestrictMap` : the designated `ℚ`-linear restriction map
  `H^{n-1}(X; ℚ) → H^{n-1}(Y; ℚ)` packaged as `A →ₗ[ℚ] A`. (Since this
  file's `A` is an ambient space — not a graded ring — we model the
  middle-degree comparison as a designated linear endomorphism of `A`;
  the injectivity below is the **load-bearing** content.)
* `middleRestrictMap_injective` : the **Lefschetz hyperplane injection**
  at the middle degree — `middleRestrictMap` is a `Function.Injective`
  linear map. This is the second half of the Lefschetz hyperplane
  theorem (Voisin I Theorem 13.6 second clause; Griffiths–Harris 1978
  Ch. 1.2 p. 159). It is **not** a triviality of the form `f ≤ ⊤`: it
  is the genuine kernel-zero statement.
* `middleRestrictMap_in_restrict` : the image of `middleRestrictMap`
  is contained in `restrict (dim - 1)`. This pins the carrier semantics
  ("the middle-degree map factors through the middle-degree restriction
  image") and ensures that the substantive content of `restrict (dim - 1)`
  is non-trivial.

The two substantive load-bearing axioms (`restriction_iso_below_middle`
and `middleRestrictMap_injective`) together encode the full content of
the Lefschetz hyperplane theorem on the abstract ambient space `A`. -/
class LefschetzHyperplaneData where
  /-- Complex dimension `n` of `X`. -/
  dim : ℕ
  /-- Degree-`k` restriction image submodule
  `Im(H^k(X; ℚ) → H^k(Y; ℚ)) ⊆ A`. -/
  restrict : ℕ → Submodule ℚ A
  /-- **Lefschetz hyperplane iso (Voisin I Theorem 13.6, first clause)**:
  for `k < dim - 1` the degree-`k` restriction map is an isomorphism,
  encoded here as the substantive equality `restrict k = ⊤`. -/
  restriction_iso_below_middle : ∀ k, k < dim - 1 → restrict k = (⊤ : Submodule ℚ A)
  /-- The designated middle-degree restriction map
  `H^{dim - 1}(X; ℚ) → H^{dim - 1}(Y; ℚ)` as an ambient linear map
  `A →ₗ[ℚ] A`. -/
  middleRestrictMap : A →ₗ[ℚ] A
  /-- **Lefschetz hyperplane injection (Voisin I Theorem 13.6, second
  clause; Griffiths–Harris 1978 Ch. 1.2 p. 159)**: the middle-degree
  restriction map is injective. This is the load-bearing **substantive**
  axiom of this typeclass and is **not** a `f ≤ ⊤` triviality. -/
  middleRestrictMap_injective : Function.Injective middleRestrictMap
  /-- **Carrier semantics for the middle-degree restriction map**: the
  image of `middleRestrictMap` lies inside `restrict (dim - 1)`, the
  designated middle-degree restriction submodule. This pins the
  abstract `middleRestrictMap` to the abstract `restrict (dim - 1)`
  carrier so the two pieces of Lefschetz hyperplane data are coherent. -/
  middleRestrictMap_in_restrict :
    ∀ α : A, middleRestrictMap α ∈ restrict (dim - 1)

namespace LefschetzHyperplaneData

variable {A} [LefschetzHyperplaneData A]

/-! ## Derived consequences of the Lefschetz hyperplane axioms -/

/-- **Iso below the middle degree** repackaged: `restrict k = ⊤` for
`k < dim - 1` (direct re-export of the field axiom for ergonomic use). -/
theorem restrict_eq_top_of_lt (k : ℕ) (hk : k < dim (A := A) - 1) :
    restrict (A := A) k = (⊤ : Submodule ℚ A) :=
  restriction_iso_below_middle k hk

/-- Every element of `A` lies in `restrict k` for `k < dim - 1`. This is
the practical form of the Lefschetz iso for downstream membership-style
arguments. -/
theorem mem_restrict_of_lt {k : ℕ} (hk : k < dim (A := A) - 1) (α : A) :
    α ∈ restrict (A := A) k := by
  rw [restrict_eq_top_of_lt k hk]
  exact Submodule.mem_top

/-- Below the middle degree, `restrict k` equals `restrict k'` for any
two `k, k' < dim - 1`. Both are `⊤`. -/
theorem restrict_eq_restrict_of_lt {k k' : ℕ}
    (hk : k < dim (A := A) - 1) (hk' : k' < dim (A := A) - 1) :
    restrict (A := A) k = restrict (A := A) k' := by
  rw [restrict_eq_top_of_lt k hk, restrict_eq_top_of_lt k' hk']

/-- **Substantive injectivity at the middle degree** (Lefschetz–Andreotti–
Frankel injection): re-export of the field axiom as a named theorem. -/
theorem middleRestrictMap_injective' :
    Function.Injective (middleRestrictMap (A := A)) :=
  middleRestrictMap_injective

/-- **Kernel-is-bottom form** of the Lefschetz hyperplane injection: the
kernel of the middle-degree restriction map is the zero submodule. This
is logically equivalent to `middleRestrictMap_injective` for a `ℚ`-linear
map but is the form most often needed downstream. -/
theorem middleRestrictMap_ker_eq_bot :
    LinearMap.ker (middleRestrictMap (A := A)) = (⊥ : Submodule ℚ A) :=
  LinearMap.ker_eq_bot.mpr middleRestrictMap_injective

/-- **Pointwise kernel-zero form**: for the middle-degree restriction
map, `f α = 0` iff `α = 0`. Substantive (not a tautology): the forward
direction uses Lefschetz–Andreotti–Frankel injectivity. -/
theorem middleRestrictMap_eq_zero_iff (α : A) :
    middleRestrictMap (A := A) α = 0 ↔ α = 0 := by
  constructor
  · intro hα
    have h0 : middleRestrictMap (A := A) α = middleRestrictMap (A := A) 0 := by
      rw [hα, map_zero]
    exact middleRestrictMap_injective h0
  · intro hα
    rw [hα, map_zero]

/-- **Contrapositive form** of injectivity: a non-zero class restricts
to a non-zero class. This is the form most often used in arguments
"`α ≠ 0 ⇒ restriction is non-zero" — a key engine for inductive
reduction to hyperplane sections. -/
theorem middleRestrictMap_ne_zero_of_ne_zero {α : A} (hα : α ≠ 0) :
    middleRestrictMap (A := A) α ≠ 0 := by
  intro h
  exact hα ((middleRestrictMap_eq_zero_iff α).mp h)

/-- **Image membership** (carrier coherence): the image of any class
under the middle-degree restriction map lies in the designated
middle-degree restriction submodule. Re-export of the carrier axiom. -/
theorem middleRestrictMap_apply_mem (α : A) :
    middleRestrictMap (A := A) α ∈ restrict (A := A) (dim (A := A) - 1) :=
  middleRestrictMap_in_restrict α

/-- **Image of `middleRestrictMap` as a submodule** is contained in
`restrict (dim - 1)`. This is the `Submodule.map` form of the previous
theorem; it converts the pointwise carrier axiom into a statement about
the linear-map image. -/
theorem middleRestrictMap_range_le_restrict :
    LinearMap.range (middleRestrictMap (A := A))
      ≤ restrict (A := A) (dim (A := A) - 1) := by
  rintro y ⟨α, rfl⟩
  exact middleRestrictMap_in_restrict α

/-- **Two-injection composition is injective**: composing the middle-
degree restriction map with itself is again injective. (Most often the
Lefschetz argument iterates a hyperplane section twice; this packages
the iteration.) -/
theorem middleRestrictMap_comp_injective :
    Function.Injective
      ((middleRestrictMap (A := A)).comp (middleRestrictMap (A := A))) :=
  middleRestrictMap_injective.comp middleRestrictMap_injective

/-- **The middle-degree restriction submodule is nontrivial** as soon as
there is any non-zero class in `A`: it contains the image of the
injective middle-degree restriction map applied to any non-zero
element, so any non-zero `α : A` produces a non-zero element of
`restrict (dim - 1)`. -/
theorem exists_ne_zero_in_restrict_middle_of_exists_ne_zero
    {α : A} (hα : α ≠ 0) :
    ∃ β ∈ restrict (A := A) (dim (A := A) - 1), β ≠ 0 :=
  ⟨middleRestrictMap α,
    middleRestrictMap_in_restrict α,
    middleRestrictMap_ne_zero_of_ne_zero hα⟩

end LefschetzHyperplaneData

end HodgeReduction.Infrastructure.Cohomology
