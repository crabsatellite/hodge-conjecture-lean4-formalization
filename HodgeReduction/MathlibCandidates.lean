/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Polynomial.Basis
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Degree.Domain
import Mathlib.LinearAlgebra.LinearIndependent
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.LinearAlgebra.Basis.Basic
import Mathlib.Order.Disjoint
import Mathlib.Algebra.Order.Field.Rat

/-!
# Mathlib-candidate structural lemmas for the Hodge Conjecture project

This file collects structural lemmas that:
- are used by the HC Concrete EVII instance chain;
- depend ONLY on Mathlib (no project-local definitions);
- are general-purpose enough to be candidates for upstream Mathlib PRs.

Each lemma is documented with:
1. The Mathlib namespace it would live in (proposed).
2. The Mathlib structural lemma it composes (e.g.,
   `LinearIndependent.disjoint_span_image`).
3. The HC application that motivates it.

## Why a separate file?

Per the project ROADMAP (`Research/MATHLIB_KERNEL_ONLY_ROADMAP.md`),
the path to true Mathlib-kernel-only HC requires multi-year Mathlib
infrastructure. This file is the first concrete step: ISOLATE the
project-local structural lemmas that COULD live in Mathlib, so they
can be reviewed for upstream submission as the project matures.

## Current contents

* `Polynomial.disjoint_span_X_pow_of_ne` : for distinct `i, j : ℕ`,
  the ℚ-spans `span ℚ {X^i}` and `span ℚ {X^j}` in `Polynomial ℚ` are
  disjoint. Used by `Concrete.EVII` for the `MumfordExtensionData
  L_block_disjoint` field. Mathlib target namespace:
  `Mathlib.Algebra.Polynomial.Basis`.

## Style

All proofs follow Mathlib conventions:
- Single-purpose lemma with one substantive `:=` term proof or short
  `by` block.
- No `sorry`, no `native_decide`, no opaque definitions.
- Structural (apply Mathlib general lemmas), NOT case-by-case.

## Tags

Mathlib PR, kernel-only, Hodge Conjecture, structural lemma,
polynomial basis, linear independence
-/

namespace HodgeReduction.MathlibCandidates

/-! ## `Polynomial.linearIndependent_X_pow`

The family `(n : ℕ) ↦ X^n` of monomial powers is linearly independent
in `Polynomial ℚ`. This is the **base structural fact** underlying
`disjoint_span_X_pow_of_ne` below; we extract it as a standalone
upstream-PR candidate.

**Structural proof** (one-liner via Mathlib primitives):
* `Polynomial.basisMonomials ℚ : Basis ℕ ℚ ℚ[X]` provides a basis of
  the polynomial ring indexed by `ℕ` (Mathlib
  `Algebra/Polynomial/Basis.lean` L23).
* `Basis.linearIndependent` extracts the underlying linear
  independence.
* `Polynomial.monomial_one_right_eq_X_pow` (Mathlib
  `Algebra/Polynomial/Basic.lean` L493) bridges `monomial s 1 = X^s`,
  letting us reindex the basis as `n ↦ X^n`.

**Why a Mathlib PR candidate**: this is a fundamental fact about
polynomial rings, used in any structural linear-algebra argument
involving distinct monomial degrees. The composed proof is 4 lines.
It would naturally live in `Mathlib.Algebra.Polynomial.Basis`
alongside `basisMonomials`. -/
theorem Polynomial.linearIndependent_X_pow :
    LinearIndependent ℚ (fun n : ℕ => (Polynomial.X : Polynomial ℚ) ^ n) := by
  have h := (Polynomial.basisMonomials ℚ).linearIndependent
  convert h using 1
  funext s
  exact (Polynomial.monomial_one_right_eq_X_pow s).symm

/-! ## `Polynomial.disjoint_span_X_pow_of_ne`

For distinct natural-number exponents `i, j`, the one-dimensional
`ℚ`-spans of `X^i` and `X^j` in `Polynomial ℚ` are disjoint as
`Submodule`s.

**Structural proof** (Mathlib-PR quality, no case-by-case):

1. `Polynomial.basisMonomials ℚ : Basis ℕ ℚ ℚ[X]` (Mathlib
   `Algebra/Polynomial/Basis.lean` L23): the monomials
   `monomial s 1 = X^s` form a basis of the polynomial ring.
2. `Basis.linearIndependent`: any basis is linearly independent.
3. `Polynomial.monomial_one_right_eq_X_pow` (Mathlib
   `Algebra/Polynomial/Basic.lean` L493): `monomial n 1 = X^n`.
4. `LinearIndependent.disjoint_span_image` (Mathlib
   `LinearAlgebra/LinearIndependent.lean` L531): for a linearly
   independent family `v : ι → M` and disjoint subsets `s, t ⊆ ι`,
   the spans `span R (v '' s)` and `span R (v '' t)` are disjoint.
5. `Set.disjoint_singleton`: `Disjoint {i} {j} ↔ i ≠ j`.

The composition yields the result in ONE one-line chain — no
coefficient comparison, no case analysis on `i, j` pairs.

**Why this is a Mathlib PR candidate**: the lemma is general (any
distinct-degree monomials), short (4 lines proof), uses only Mathlib
structural facts, and would naturally live in
`Mathlib.Algebra.Polynomial.Basis` alongside `basisMonomials` itself. -/
theorem Polynomial.disjoint_span_X_pow_of_ne {i j : ℕ} (hij : i ≠ j) :
    Disjoint
      (Submodule.span ℚ ({(Polynomial.X : Polynomial ℚ) ^ i} : Set (Polynomial ℚ)))
      (Submodule.span ℚ ({(Polynomial.X : Polynomial ℚ) ^ j} : Set (Polynomial ℚ))) := by
  -- Use the extracted base lemma `Polynomial.linearIndependent_X_pow`
  -- (one-line composition via Mathlib `LinearIndependent.disjoint_span_image`).
  have hd : Disjoint ({i} : Set ℕ) ({j} : Set ℕ) :=
    Set.disjoint_singleton.mpr hij
  have hresult := Polynomial.linearIndependent_X_pow.disjoint_span_image hd
  rwa [Set.image_singleton, Set.image_singleton] at hresult

/-! ## `Polynomial.span_X_pow_eq_top`

The `ℚ`-span of all monomial powers `{X^n | n : ℕ}` in `Polynomial ℚ`
equals the whole module `⊤`. This is the structural fact that
**polynomial monomials are a generating set** for the polynomial ring
as a ℚ-vector space.

**Structural proof** (one-line composition):
* `Polynomial.basisMonomials ℚ : Basis ℕ ℚ (Polynomial ℚ)` provides a
  basis indexed by ℕ (Mathlib `Algebra/Polynomial/Basis.lean`).
* `Basis.span_eq`: every basis spans the whole module.
* Reindex via `Polynomial.monomial_one_right_eq_X_pow` (Mathlib
  `Algebra/Polynomial/Basic.lean`).

**Why this is a Mathlib PR candidate**: this is a fundamental fact
about polynomial rings — used in any structural argument involving
ℚ-linear combinations of monomial powers (e.g. cohomology-ring
spanning arguments, polynomial-degree-graded decompositions). It
would naturally live in `Mathlib.Algebra.Polynomial.Basis` alongside
`basisMonomials`. -/
theorem Polynomial.span_X_pow_eq_top :
    Submodule.span ℚ (Set.range
      (fun n : ℕ => (Polynomial.X : Polynomial ℚ) ^ n))
      = (⊤ : Submodule ℚ (Polynomial ℚ)) := by
  -- The basisMonomials gives `span (range basisMonomials) = ⊤`.
  -- We then reindex: `basisMonomials n = monomial n 1 = X^n`.
  have hspan : Submodule.span ℚ (Set.range (Polynomial.basisMonomials ℚ))
      = ⊤ := (Polynomial.basisMonomials ℚ).span_eq
  -- Show that `Set.range (basisMonomials ℚ) = Set.range (fun n => X^n)`.
  have hrange : Set.range (Polynomial.basisMonomials ℚ)
      = Set.range (fun n : ℕ => (Polynomial.X : Polynomial ℚ) ^ n) := by
    ext p
    constructor
    · rintro ⟨n, rfl⟩
      exact ⟨n, (Polynomial.monomial_one_right_eq_X_pow n).symm⟩
    · rintro ⟨n, rfl⟩
      exact ⟨n, Polynomial.monomial_one_right_eq_X_pow n⟩
  rw [hrange] at hspan
  exact hspan

/-! ## Pairwise disjointness via `Fin n`-indexed monomials

Convenience corollary: a `Fin n`-indexed family of monomials `X^i.val`
(for `i : Fin n`) gives pairwise-disjoint singleton spans whenever the
distinct `Fin n` elements have distinct underlying `ℕ` values.

Used by `Concrete.EVII.evii_mumfordExtensionData` for the
`L_block_disjoint : ∀ i j : Fin 4, i ≠ j → Disjoint (L_block i)
(L_block j)` field. -/
theorem Polynomial.disjoint_span_X_pow_fin_of_ne {n : ℕ} {i j : Fin n}
    (hij : i ≠ j) :
    Disjoint
      (Submodule.span ℚ
        ({(Polynomial.X : Polynomial ℚ) ^ i.val} : Set (Polynomial ℚ)))
      (Submodule.span ℚ
        ({(Polynomial.X : Polynomial ℚ) ^ j.val} : Set (Polynomial ℚ))) :=
  Polynomial.disjoint_span_X_pow_of_ne (fun h => hij (Fin.ext h))

/-! ## `Polynomial.X_pow_ne_zero`

The monomial `X^n` is non-zero in `Polynomial R` when `R` is an
**integral domain** (`CommRing R + IsDomain R`).

**Structural proof** (one-line composition):
* `Polynomial.X_ne_zero : (X : Polynomial R) ≠ 0` (Mathlib direct,
  requires `[Nontrivial R]`).
* `pow_ne_zero : a ≠ 0 → a^n ≠ 0` (Mathlib; requires
  `[NoZeroDivisors]` on the ambient type, satisfied by
  `Polynomial R` when `R` is a domain via
  `Polynomial.instNoZeroDivisors`).

**Why this is a Mathlib PR candidate**: composition shortcut that's
not directly available in Mathlib (verified by `grep` 2026-05-17).
Used in any structural argument requiring monomial-power non-vanishing
(e.g. Hard Lefschetz on polynomial-graded models, non-vanishing of
the Kähler-class polarisation powers `h^k` on compact Kähler manifolds). -/
theorem Polynomial.X_pow_ne_zero {R : Type*} [CommSemiring R] [Nontrivial R]
    [NoZeroDivisors R] (n : ℕ) :
    ((Polynomial.X : Polynomial R)) ^ n ≠ 0 :=
  pow_ne_zero n Polynomial.X_ne_zero

/-! ## Kernel-purity verification

Each MathlibCandidates lemma should depend only on Mathlib + kernel
axioms `[propext, Classical.choice, Quot.sound]`, with no project-local
axioms or `sorry`. The `#print axioms` lines below verify this. -/

-- All five Polynomial lemmas: kernel-pure.
#print axioms Polynomial.linearIndependent_X_pow
#print axioms Polynomial.disjoint_span_X_pow_of_ne
#print axioms Polynomial.disjoint_span_X_pow_fin_of_ne
#print axioms Polynomial.span_X_pow_eq_top
#print axioms Polynomial.X_pow_ne_zero

end HodgeReduction.MathlibCandidates
