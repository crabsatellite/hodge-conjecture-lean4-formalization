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
import Mathlib.LinearAlgebra.TensorProduct.Basic
import Mathlib.LinearAlgebra.TensorProduct.Tower
import Mathlib.LinearAlgebra.Basis.VectorSpace
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.Dimension.Free
import Mathlib.LinearAlgebra.Dimension.FreeAndStrongRankCondition
import Mathlib.Order.Disjoint
import Mathlib.Algebra.Order.Field.Rat
import HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundle

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

## Current contents (R26 through R102)

### Polynomial lemmas (R26, R35, R61, R71)
* `Polynomial.linearIndependent_X_pow` : the family `n ↦ X^n` is
  linearly independent in `Polynomial ℚ`. (R35)
* `Polynomial.disjoint_span_X_pow_of_ne` : for distinct `i, j : ℕ`,
  the ℚ-spans `span ℚ {X^i}` and `span ℚ {X^j}` are disjoint. (R26)
* `Polynomial.disjoint_span_X_pow_fin_of_ne` : Fin-indexed variant. (R26)
* `Polynomial.span_X_pow_eq_top` : `Submodule.span ℚ (range X^n) = ⊤`. (R61)
* `Polynomial.X_pow_ne_zero` : `X^n ≠ 0` for n in integral domains. (R71)

### `Module.IsInvertible` Mathlib infrastructure (R97-R102)
The substantial Mathlib-PR-quality skeleton for line-bundle / Picard
group infrastructure (currently absent from Mathlib):

* `class Module.IsInvertible R M` : M is invertible iff some N has
  `M ⊗_R N ≃ R`. (R97)
* `instance Module.IsInvertible.self` : R itself is invertible
  (trivial line bundle `𝒪_X`). (R97)
* `instance Module.IsInvertible.tensor` : tensor product preserves
  invertibility (multiplicative closure of Pic). (R98)
* `def Module.IsInvertible.symm_equiv` + `of_inverse` : invertibility
  is symmetric (commutativity of Pic). (R99)
* `theorem Module.IsInvertible.of_linearEquiv` : invertibility transfers
  across linear iso (foundation for Pic quotient). (R100)
* `instance Module.IsInvertible.tensor_R_left/right` : R-tensor unit
  laws (identity element of Pic = R = `𝒪_X`). (R101)
* `theorem Module.IsInvertible.tensor_assoc_iff` : associativity of
  Pic tensor structure. (R102)

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

/-! # SUBSTANTIAL MATHLIB INFRASTRUCTURE (R97+)

The following section represents a **substantial Mathlib-PR-quality
infrastructure contribution** rather than individual lemmas. It builds
the foundation for the **Picard group** / **line bundle** theory on
affine schemes, which is currently absent from Mathlib (verified by
`grep` 2026-05-17). This is a multi-week / multi-month buildup; we
begin here with the foundational typeclass and its trivial witness.

**HC relevance**: line bundles are the codim-1 building blocks of the
algebraic cycle classes that the Hodge Conjecture relates to Hodge
classes. A genuine `Mathlib.AlgebraicGeometry.PicardGroup` (which this
infrastructure would feed into) is on the critical path for true
Mathlib-kernel-only HC. -/

/-! ## `Module.IsInvertible R M`: invertible R-modules

**Mathematical definition** (Hartshorne, *Algebraic Geometry*, II §6;
Bourbaki, *Algèbre Commutative*, Ch. II §5):

An `R`-module `M` is **invertible** iff there exists an `R`-module `N`
such that `M ⊗_R N ≃ R` as `R`-modules. For commutative `R`, this is
equivalent to `M` being finitely generated, projective, and locally
free of rank 1; geometrically, `M` corresponds to a line bundle on
`Spec R`. The set of isomorphism classes of invertible `R`-modules
forms the **Picard group** `Pic R` under tensor product.

**Mathlib status (2026-05-17)**: This typeclass does not exist in
Mathlib. Verified via `grep "class.*Invertible\|class.*Picard"` over
`Mathlib/RingTheory/` and `Mathlib/LinearAlgebra/`. Mathlib only has
the element-level `Invertible a` (multiplicative inverse in a monoid),
not the module-level invertibility needed for line bundles.

**HC application**: line bundles on the EVII compact dual `Ě_VII` are
the codim-1 algebraic cycle classes; their first Chern classes
generate `H^2(Ě_VII; ℚ)`. The `evii_lineBundleData` instance in
`Concrete/EVII` is currently built on an ad-hoc `LineBundleData` class;
once `Module.IsInvertible` lands and a `Pic` group is constructed from
it, the EVII concrete instance gets a Mathlib-native foundation. -/
class Module.IsInvertible.{u} (R M : Type u) [CommRing R] [AddCommGroup M]
    [Module R M] : Prop where
  /-- The substantive content: there exists an inverse module `N` such
  that `M ⊗_R N` is `R`-linearly equivalent to `R`.
  Single-universe form: `N : Type u` matches `R, M : Type u`. -/
  exists_inverse :
    ∃ (N : Type u) (_ : AddCommGroup N) (_ : Module R N),
      Nonempty (TensorProduct R M N ≃ₗ[R] R)

/-! ### Trivial witness: `R` itself is invertible

For any commutative ring `R`, the module `R` (acting on itself) is
invertible: take `N := R` and use `TensorProduct.lid R R : R ⊗_R R ≃ R`
(actually we want `R ⊗_R R ≃ R`, which is `lid R R`).

This is the **trivial line bundle** `𝒪_{Spec R}` (the structure sheaf
itself). Geometrically: `𝒪 ⊗ 𝒪 ≃ 𝒪` since the structure sheaf is the
identity of `Pic`. -/
instance Module.IsInvertible.self (R : Type*) [CommRing R] :
    Module.IsInvertible R R where
  exists_inverse :=
    ⟨R, inferInstance, inferInstance, ⟨TensorProduct.lid R R⟩⟩

/-! ### `Module.IsInvertible.tensor` (R98): invertibility preserved by tensor product

**Mathematical content** (Hartshorne II §6, Bourbaki II §5): the tensor
product of two invertible modules is invertible. This is the
**multiplicative structure** of the Picard group: `Pic R` is closed
under `⊗_R`.

**Proof structure** (purely composing Mathlib primitives, no
case-by-case):

Given `e₁ : M ⊗ N₁ ≃ R` and `e₂ : M' ⊗ N₂ ≃ R`, construct
`e : (M ⊗ M') ⊗ (N₁ ⊗ N₂) ≃ R` via:

1. `TensorProduct.tensorTensorTensorComm R M M' N₁ N₂` :
   `(M ⊗ M') ⊗ (N₁ ⊗ N₂) ≃ (M ⊗ N₁) ⊗ (M' ⊗ N₂)`.
2. `TensorProduct.congr e₁ e₂` :
   `(M ⊗ N₁) ⊗ (M' ⊗ N₂) ≃ R ⊗ R`.
3. `TensorProduct.lid R R` :
   `R ⊗ R ≃ R`.

Composition gives the desired equivalence. -/
instance Module.IsInvertible.tensor.{u} {R : Type u} [CommRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [hM : Module.IsInvertible R M]
    {M' : Type u} [AddCommGroup M'] [Module R M'] [hM' : Module.IsInvertible R M'] :
    Module.IsInvertible R (TensorProduct R M M') where
  exists_inverse := by
    obtain ⟨N₁, instAcg₁, instMod₁, ⟨e₁⟩⟩ := hM.exists_inverse
    obtain ⟨N₂, instAcg₂, instMod₂, ⟨e₂⟩⟩ := hM'.exists_inverse
    -- The inverse module is N₁ ⊗ N₂.
    refine ⟨TensorProduct R N₁ N₂, inferInstance, inferInstance, ⟨?_⟩⟩
    -- Compose the three equivs.
    exact (TensorProduct.tensorTensorTensorComm R M M' N₁ N₂).trans
      ((TensorProduct.congr e₁ e₂).trans (TensorProduct.lid R R))

/-! ### `Module.IsInvertible.symm_equiv` (R99): swap of the invertibility equiv

If `M ⊗ N ≃ R` then `N ⊗ M ≃ R` (composing with `TensorProduct.comm`).
This is the foundation for showing that the inverse relation is
**symmetric**: if `N` is an inverse to `M`, then `M` is also an inverse
to `N`. -/
noncomputable def Module.IsInvertible.symm_equiv.{u} {R : Type u} [CommRing R]
    {M N : Type u} [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]
    (e : TensorProduct R M N ≃ₗ[R] R) :
    TensorProduct R N M ≃ₗ[R] R :=
  (TensorProduct.comm R N M).trans e

/-! ### `Module.IsInvertible.of_inverse` (R99): derived IsInvertible from explicit inverse

Companion constructor: given an explicit linear equivalence
`M ⊗ N ≃ R`, both `M` and `N` are invertible. Concretely useful when
the inverse is known by name (rather than just by Prop-level
existence). -/
theorem Module.IsInvertible.of_inverse.{u} {R : Type u} [CommRing R]
    {M N : Type u} [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]
    (e : TensorProduct R M N ≃ₗ[R] R) :
    Module.IsInvertible R M ∧ Module.IsInvertible R N :=
  ⟨⟨⟨N, inferInstance, inferInstance, ⟨e⟩⟩⟩,
   ⟨⟨M, inferInstance, inferInstance, ⟨Module.IsInvertible.symm_equiv e⟩⟩⟩⟩

/-! ### `Module.IsInvertible.of_linearEquiv` (R100): invertibility transfers across iso

**Mathematical content**: invertibility is a property of the *iso class*
of an R-module, not of the underlying type. If `M ≃ₗ[R] M'` and `M` is
invertible, then `M'` is also invertible (with the same inverse,
post-composed with the equiv).

**Significance for Pic group construction**: this is the substantive
content of "Pic = iso classes of invertible modules" — two
linearly-equivalent invertible modules represent the **same** class in
`Pic R`. The lemma is the foundation step before defining the Pic
quotient.

**Proof structure** (one-line composition):
* The inverse `N` of `M` is also the inverse of `M'` via the chain:
  `M' ⊗ N ≃ M ⊗ N` (using `e.symm.rTensor N`) `≃ R` (by `IsInvertible R M`). -/
theorem Module.IsInvertible.of_linearEquiv.{u} {R : Type u} [CommRing R]
    {M M' : Type u} [AddCommGroup M] [Module R M]
    [AddCommGroup M'] [Module R M']
    [hM : Module.IsInvertible R M] (e : M ≃ₗ[R] M') :
    Module.IsInvertible R M' := by
  obtain ⟨N, instAcg, instMod, ⟨eqN⟩⟩ := hM.exists_inverse
  refine ⟨⟨N, instAcg, instMod, ⟨?_⟩⟩⟩
  -- M' ⊗ N ≃ M ⊗ N via the equiv e.symm; then ≃ R via eqN.
  exact (TensorProduct.congr e.symm (LinearEquiv.refl R N)).trans eqN

/-! ### `Module.IsInvertible` unit laws (R101): invertibility of R ⊗ M and M ⊗ R

For any R-module M, M is invertible iff `R ⊗_R M` is invertible
(both directions via `TensorProduct.lid`); similarly for `M ⊗_R R`
via `TensorProduct.rid`. These are the **left/right unit laws**
of the Pic group's monoidal structure.

Single-line corollaries of R100 `of_linearEquiv` + Mathlib's
`TensorProduct.lid`/`rid`. Useful when simplifying Pic-side
calculations (the identity element of `Pic R` acts trivially). -/

instance Module.IsInvertible.tensor_R_left.{u} {R : Type u} [CommRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [Module.IsInvertible R M] :
    Module.IsInvertible R (TensorProduct R R M) :=
  Module.IsInvertible.of_linearEquiv (TensorProduct.lid R M).symm

instance Module.IsInvertible.tensor_R_right.{u} {R : Type u} [CommRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [Module.IsInvertible R M] :
    Module.IsInvertible R (TensorProduct R M R) :=
  Module.IsInvertible.of_linearEquiv (TensorProduct.rid R M).symm

/-! ### `Module.IsInvertible.tensor_assoc` (R102): associativity of Pic tensor

The tensor product of invertible R-modules is associative up to
linear equivalence (`TensorProduct.assoc`). Combined with R98
`tensor` (closure under tensor), this gives the FINAL piece of the
monoidal-structure preservation: `Pic R` is associative under `⊗`.

This is the conceptual completion of the monoidal-structure step:
together with R97-R101, `Module.IsInvertible` has all the structural
properties needed to define `Pic R` as a `CommGroup`. -/
theorem Module.IsInvertible.tensor_assoc_iff.{u} {R : Type u} [CommRing R]
    {M N P : Type u} [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N] [AddCommGroup P] [Module R P] :
    Module.IsInvertible R (TensorProduct R (TensorProduct R M N) P) ↔
      Module.IsInvertible R (TensorProduct R M (TensorProduct R N P)) :=
  ⟨fun _ => Module.IsInvertible.of_linearEquiv (TensorProduct.assoc R M N P),
   fun _ => Module.IsInvertible.of_linearEquiv (TensorProduct.assoc R M N P).symm⟩

/-! ### `Module.IsInvertible.iff_linearEquiv` (R104): full bidirectional iso transfer

Strengthens R100 `of_linearEquiv` to a BIDIRECTIONAL iff. Together with
R97 `self`, this gives a clean characterisation: for any `R`-module
`M ≃ₗ[R] R`, `M` is invertible.

**Corollary** (sanity check on R97 + R104): any `R`-module isomorphic
to `R` is invertible. This recovers the geometric intuition that "the
trivial line bundle on `Spec R` is invertible" in arbitrary equivalent
form. -/
theorem Module.IsInvertible.iff_linearEquiv.{u} {R : Type u} [CommRing R]
    {M M' : Type u} [AddCommGroup M] [Module R M]
    [AddCommGroup M'] [Module R M']
    (e : M ≃ₗ[R] M') :
    Module.IsInvertible R M ↔ Module.IsInvertible R M' :=
  ⟨fun hM => Module.IsInvertible.of_linearEquiv (hM := hM) e,
   fun hM' => Module.IsInvertible.of_linearEquiv (hM := hM') e.symm⟩

/-- **Corollary** (R104): any R-module linearly-equivalent to R is invertible
(the trivial line bundle in disguised form). -/
theorem Module.IsInvertible.of_equiv_R.{u} {R : Type u} [CommRing R]
    {M : Type u} [AddCommGroup M] [Module R M] (e : M ≃ₗ[R] R) :
    Module.IsInvertible R M :=
  (Module.IsInvertible.iff_linearEquiv e).mpr (Module.IsInvertible.self R)

/-! ### `Module.IsInvertible.tensor_prod_of_iso_R` (R105): combinator for chained iso

**Mathematical content**: if `M ⊗ M' ≃ R` (via some explicit iso), then
both `M` and `M'` are invertible (via R99 `of_inverse`), AND their
tensor product is invertible (the trivial invertibility of `R`, via
R104 `of_equiv_R`).

This is the **cleanest combinator** for proving invertibility of
concrete tensor products: if you can exhibit `M ⊗ M' ≃ R`, the
whole chain (M invertible + M' invertible + M ⊗ M' invertible) follows
automatically. Particularly useful for proving invertibility of
specific line bundles via explicit dualities.

**Proof structure**: just package the three derived `IsInvertible`s. -/
theorem Module.IsInvertible.chain_of_iso_R.{u} {R : Type u} [CommRing R]
    {M M' : Type u} [AddCommGroup M] [Module R M]
    [AddCommGroup M'] [Module R M']
    (e : TensorProduct R M M' ≃ₗ[R] R) :
    Module.IsInvertible R M ∧ Module.IsInvertible R M' ∧
      Module.IsInvertible R (TensorProduct R M M') := by
  obtain ⟨hM, hM'⟩ := Module.IsInvertible.of_inverse e
  exact ⟨hM, hM', Module.IsInvertible.of_equiv_R e⟩

/-! ### `Module.IsInvertible.tensor_three` (R106): triple-tensor invertibility

Composition of R98 `tensor` with itself: if `M`, `M'`, `M''` are all
invertible, so is `M ⊗ M' ⊗ M''`. This is a useful explicit form;
auto-derived from R98 but stating it as a named lemma helps
downstream proofs avoid manual instance-resolution traces. -/
instance Module.IsInvertible.tensor_three.{u} {R : Type u} [CommRing R]
    {M M' M'' : Type u}
    [AddCommGroup M] [Module R M] [Module.IsInvertible R M]
    [AddCommGroup M'] [Module R M'] [Module.IsInvertible R M']
    [AddCommGroup M''] [Module R M''] [Module.IsInvertible R M''] :
    Module.IsInvertible R (TensorProduct R M (TensorProduct R M' M'')) :=
  Module.IsInvertible.tensor

/-! ### `Module.IsInvertible.tensor_self_n` (R106): n-fold self-tensor

If `M` is invertible, so are `M ⊗ M`, `M ⊗ (M ⊗ M)`, etc. The
specific case `M ⊗ M` is geometrically the "self-tensor of a line
bundle", which under the standard identification `M ⊗ M ≃ M^{⊗2}`
gives the **square** of `[M]` in `Pic R`. -/
instance Module.IsInvertible.tensor_self.{u} {R : Type u} [CommRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [Module.IsInvertible R M] :
    Module.IsInvertible R (TensorProduct R M M) :=
  Module.IsInvertible.tensor

/-! ### `Module.IsInvertible.Sigma` (R107): the type of invertible R-modules

The **carrier type for the eventual Pic R group**: a Sigma type
recording an invertible R-module up to type-level data.

`Module.IsInvertible.Sigma R := Σ (M : Type u) (_ : AddCommGroup M)
  (_ : Module R M) (_ : Module.IsInvertible R M), Unit`

(The trailing `Unit` is a convention to give the dependent product a
clean Σ-elimination pattern; could equivalently be omitted.)

**Significance**: this is the SOURCE for the eventual `Pic R` quotient
construction. Equipped with the iso-relation `M ~ M' ↔ Nonempty (M ≃ₗ M')`,
the quotient gives `Pic R` as a `CommGroup`.

**Skeleton at R107**: provide the type + a constructor + a way to
extract the module witness. Subsequent rounds add the iso relation and
the quotient. -/
def Module.IsInvertible.Sigma.{u} (R : Type u) [CommRing R] : Type (u + 1) :=
  Σ (M : Type u),
    Σ (_ : AddCommGroup M), Σ (_ : Module R M), PLift (Module.IsInvertible R M)

namespace Module.IsInvertible.Sigma

/-- Constructor: package an invertible R-module as a Sigma element. -/
def mk.{u} {R : Type u} [CommRing R] (M : Type u) [hAcg : AddCommGroup M]
    [hMod : Module R M] [hInv : Module.IsInvertible R M] :
    Module.IsInvertible.Sigma R :=
  ⟨M, hAcg, hMod, PLift.up hInv⟩

/-- Extract the underlying module from a Sigma element. -/
def carrier.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R) : Type u :=
  s.1

/-- The `AddCommGroup` instance carried by a Sigma element. -/
instance carrierAddCommGroup.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R) : AddCommGroup s.carrier :=
  s.2.1

/-- The `Module` instance carried by a Sigma element. -/
instance carrierModule.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R) : Module R s.carrier :=
  s.2.2.1

/-- The carrier of a Sigma element is itself an invertible module. -/
instance carrierIsInvertible.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R) : Module.IsInvertible R s.carrier :=
  s.2.2.2.down

/-- The carrier of `mk M` is `M`. -/
theorem carrier_mk.{u} (R : Type u) [CommRing R] (M : Type u)
    [AddCommGroup M] [Module R M] [Module.IsInvertible R M] :
    carrier (Module.IsInvertible.Sigma.mk (R := R) M) = M :=
  rfl

end Module.IsInvertible.Sigma

/-! ### `Module.IsInvertible.Sigma.IsoRel` (R108): iso-equivalence relation

The **equivalence relation underlying the Pic R quotient**: two invertible
R-modules are equivalent iff they are R-linearly isomorphic.

`s ~ t : Module.IsInvertible.Sigma.IsoRel s t :=
  Nonempty (s.carrier ≃ₗ[R] t.carrier)`

**Significance**: `Pic R := Quotient (Module.IsInvertible.Sigma.IsoSetoid R)`
will give the Picard group. The relation is reflexive (refl iso),
symmetric (LinearEquiv.symm), transitive (LinearEquiv.trans), hence a
`Setoid`.

Phase 2 of the Pic R construction: equivalence relation + Setoid. -/

/-- Iso-equivalence relation on `Module.IsInvertible.Sigma R`. -/
def Module.IsInvertible.Sigma.IsoRel.{u} {R : Type u} [CommRing R]
    (s t : Module.IsInvertible.Sigma R) : Prop :=
  Nonempty (Module.IsInvertible.Sigma.carrier s ≃ₗ[R]
            Module.IsInvertible.Sigma.carrier t)

namespace Module.IsInvertible.Sigma

theorem IsoRel.refl.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R) : IsoRel s s :=
  ⟨LinearEquiv.refl R _⟩

theorem IsoRel.symm.{u} {R : Type u} [CommRing R]
    {s t : Module.IsInvertible.Sigma R} (h : IsoRel s t) : IsoRel t s := by
  obtain ⟨e⟩ := h
  exact ⟨e.symm⟩

theorem IsoRel.trans.{u} {R : Type u} [CommRing R]
    {s t u : Module.IsInvertible.Sigma R}
    (h₁ : IsoRel s t) (h₂ : IsoRel t u) : IsoRel s u := by
  obtain ⟨e₁⟩ := h₁
  obtain ⟨e₂⟩ := h₂
  exact ⟨e₁.trans e₂⟩

/-- The Setoid structure on `Module.IsInvertible.Sigma R` whose quotient
will be `Pic R`. -/
def IsoSetoid.{u} (R : Type u) [CommRing R] :
    Setoid (Module.IsInvertible.Sigma R) where
  r := IsoRel
  iseqv := ⟨IsoRel.refl, IsoRel.symm, IsoRel.trans⟩

end Module.IsInvertible.Sigma

/-! ### `Picard` group (R109): the quotient `Pic R`

**The Picard group of a commutative ring**, defined as the quotient of
the type of invertible R-modules by isomorphism.

`Picard R := Quotient (Module.IsInvertible.Sigma.IsoSetoid R)`

**Note on naming**: in Mathlib, `Picard` is the algebraic Picard group
(invertible modules / iso), distinct from the geometric Picard group
of an algebraic variety (line bundles / iso). They agree for `Spec R`.

This round introduces:
- `Picard R` quotient type
- `Picard.mk M` constructor (lifts an invertible R-module)
- `Picard.mk_R` distinguished element (the class of R itself, group identity)
- `Picard.mk_eq_mk_iff` characterization of equality

Subsequent rounds (R110+) add multiplication via tensor product, inverse
via dual module, and the full `CommGroup` structure. -/

/-- The **Picard group** of a commutative ring R: isomorphism classes of
invertible R-modules under tensor product. -/
def Picard.{u} (R : Type u) [CommRing R] : Type (u + 1) :=
  Quotient (Module.IsInvertible.Sigma.IsoSetoid R)

namespace Picard

/-- Lift an invertible R-module to its class in `Picard R`. -/
def mk.{u} {R : Type u} [CommRing R] (M : Type u) [AddCommGroup M]
    [Module R M] [Module.IsInvertible R M] : Picard R :=
  Quotient.mk (Module.IsInvertible.Sigma.IsoSetoid R)
    (Module.IsInvertible.Sigma.mk (R := R) M)

/-- The distinguished class `[R]` — the identity of the Picard group. -/
def one.{u} (R : Type u) [CommRing R] : Picard R :=
  mk (R := R) R

/-- Two invertible R-modules have the same Picard class iff they are
R-linearly isomorphic. -/
theorem mk_eq_mk_iff.{u} {R : Type u} [CommRing R]
    (M M' : Type u) [AddCommGroup M] [Module R M] [Module.IsInvertible R M]
    [AddCommGroup M'] [Module R M'] [Module.IsInvertible R M'] :
    mk (R := R) M = mk (R := R) M' ↔ Nonempty (M ≃ₗ[R] M') := by
  unfold mk
  rw [Quotient.eq]
  rfl

end Picard

/-! ### `Picard` multiplication (R110): tensor product as group operation

The Picard group operation: `[M] · [N] = [M ⊗_R N]`. This requires:
1. Tensor of two invertible modules is invertible (R98 `Module.IsInvertible.tensor`).
2. Tensor respects iso-equivalence (functoriality).
3. The lifted operation is well-defined on quotient classes.

This round introduces the binary operation on Sigma + the lift to Picard. -/

namespace Module.IsInvertible.Sigma

/-- The tensor product of two Sigma elements, packaged as a Sigma element. -/
noncomputable def tensor.{u} {R : Type u} [CommRing R]
    (s t : Module.IsInvertible.Sigma R) :
    Module.IsInvertible.Sigma R :=
  Module.IsInvertible.Sigma.mk (R := R) (TensorProduct R s.carrier t.carrier)

/-- The carrier of `tensor s t` is `TensorProduct R s.carrier t.carrier`. -/
theorem tensor_carrier.{u} {R : Type u} [CommRing R]
    (s t : Module.IsInvertible.Sigma R) :
    (tensor s t).carrier = TensorProduct R s.carrier t.carrier :=
  rfl

/-- Tensor respects iso-equivalence on the left. -/
theorem IsoRel.tensor_left.{u} {R : Type u} [CommRing R]
    {s₁ s₂ : Module.IsInvertible.Sigma R}
    (t : Module.IsInvertible.Sigma R) (h : IsoRel s₁ s₂) :
    IsoRel (tensor s₁ t) (tensor s₂ t) := by
  obtain ⟨e⟩ := h
  exact ⟨TensorProduct.congr e (LinearEquiv.refl R _)⟩

/-- Tensor respects iso-equivalence on the right. -/
theorem IsoRel.tensor_right.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R)
    {t₁ t₂ : Module.IsInvertible.Sigma R} (h : IsoRel t₁ t₂) :
    IsoRel (tensor s t₁) (tensor s t₂) := by
  obtain ⟨e⟩ := h
  exact ⟨TensorProduct.congr (LinearEquiv.refl R _) e⟩

/-- Tensor respects iso-equivalence (combined left and right). -/
theorem IsoRel.tensor.{u} {R : Type u} [CommRing R]
    {s₁ s₂ t₁ t₂ : Module.IsInvertible.Sigma R}
    (hs : IsoRel s₁ s₂) (ht : IsoRel t₁ t₂) :
    IsoRel (tensor s₁ t₁) (tensor s₂ t₂) :=
  IsoRel.trans (tensor_left t₁ hs) (tensor_right s₂ ht)

end Module.IsInvertible.Sigma

namespace Picard

/-- Multiplication on `Picard R` via tensor product of representative modules. -/
noncomputable def mul.{u} {R : Type u} [CommRing R] (x y : Picard R) : Picard R :=
  Quotient.liftOn₂ (s₁ := Module.IsInvertible.Sigma.IsoSetoid R)
    (s₂ := Module.IsInvertible.Sigma.IsoSetoid R)
    x y
    (fun s t => Quotient.mk _ (Module.IsInvertible.Sigma.tensor s t))
    (fun _ _ _ _ hs ht =>
      Quotient.sound (Module.IsInvertible.Sigma.IsoRel.tensor hs ht))

/-- The multiplication on `Picard R` agrees with tensor on representatives. -/
theorem mul_mk.{u} {R : Type u} [CommRing R]
    (M N : Type u) [AddCommGroup M] [Module R M] [Module.IsInvertible R M]
    [AddCommGroup N] [Module R N] [Module.IsInvertible R N] :
    mul (mk (R := R) M) (mk (R := R) N) = mk (R := R) (TensorProduct R M N) :=
  rfl

/-- **R111**: commutativity of the Picard product. Lifted from
`TensorProduct.comm`. -/
theorem mul_comm.{u} {R : Type u} [CommRing R] (x y : Picard R) :
    mul x y = mul y x := by
  refine Quotient.inductionOn₂ (motive := fun a b => mul a b = mul b a) x y ?_
  intro s t
  exact Quotient.sound ⟨TensorProduct.comm R s.carrier t.carrier⟩

/-- **R111**: associativity of the Picard product. Lifted from
`TensorProduct.assoc`. -/
theorem mul_assoc.{u} {R : Type u} [CommRing R] (x y z : Picard R) :
    mul (mul x y) z = mul x (mul y z) := by
  refine Quotient.inductionOn₃
    (motive := fun a b c => mul (mul a b) c = mul a (mul b c)) x y z ?_
  intro s t u
  exact Quotient.sound ⟨TensorProduct.assoc R s.carrier t.carrier u.carrier⟩

/-- **R111**: left identity for the Picard product (`[R] · x = x`).
Lifted from `TensorProduct.lid`. -/
theorem one_mul.{u} {R : Type u} [CommRing R] (x : Picard R) :
    mul (one R) x = x := by
  refine Quotient.inductionOn (motive := fun a => mul (one R) a = a) x ?_
  intro s
  exact Quotient.sound ⟨TensorProduct.lid R s.carrier⟩

/-- **R111**: right identity for the Picard product (`x · [R] = x`).
Lifted from `TensorProduct.rid`. -/
theorem mul_one.{u} {R : Type u} [CommRing R] (x : Picard R) :
    mul x (one R) = x := by
  refine Quotient.inductionOn (motive := fun a => mul a (one R) = a) x ?_
  intro s
  exact Quotient.sound ⟨TensorProduct.rid R s.carrier⟩

/-- **R112**: `Picard R` is a commutative monoid via tensor product.

Mul is tensor of representative invertible modules, one is the class
[R], associativity / commutativity / unit laws all come from the
standard Mathlib LinearEquivs (TensorProduct.assoc / .comm / .lid / .rid).

This is the first half of the standard Picard-group structure. R113+
will add the inverse via dual modules to upgrade to `CommGroup`. -/
noncomputable instance commMonoid.{u} (R : Type u) [CommRing R] :
    CommMonoid (Picard R) where
  mul := mul
  one := one R
  mul_assoc := mul_assoc
  mul_comm := mul_comm
  one_mul := one_mul
  mul_one := mul_one

end Picard

/-! ### `Module.IsInvertible` inverse extraction (R113)

Given an invertible R-module M, extract a chosen inverse N as type-level
data via `Classical.choose` on the existential `exists_inverse`.

The chosen inverse depends on choice but is canonical *up to R-linear
isomorphism* — a fact (R115) needed to define `Picard.inv` as a
well-defined operation on quotient classes.

This round provides the type-level extraction; subsequent rounds R114-R115
prove the chosen inverse is itself invertible (so packageable as a Sigma
element) and that the choice is unique up to iso. -/

namespace Module.IsInvertible

/-- The type-level inverse module chosen from the `exists_inverse` witness. -/
noncomputable def inverseCarrier.{u} (R : Type u) [CommRing R]
    (M : Type u) [AddCommGroup M] [Module R M]
    [hM : Module.IsInvertible R M] : Type u :=
  hM.exists_inverse.choose

/-- The `AddCommGroup` structure carried by the chosen inverse. -/
noncomputable instance inverseAddCommGroup.{u} (R : Type u) [CommRing R]
    (M : Type u) [AddCommGroup M] [Module R M]
    [hM : Module.IsInvertible R M] :
    AddCommGroup (Module.IsInvertible.inverseCarrier R M) :=
  hM.exists_inverse.choose_spec.choose

/-- The `Module R` structure carried by the chosen inverse. -/
noncomputable instance inverseModule.{u} (R : Type u) [CommRing R]
    (M : Type u) [AddCommGroup M] [Module R M]
    [hM : Module.IsInvertible R M] :
    Module R (Module.IsInvertible.inverseCarrier R M) :=
  hM.exists_inverse.choose_spec.choose_spec.choose

/-- The witness iso `M ⊗ inverseCarrier R M ≃ₗ[R] R`. -/
noncomputable def inverseIso.{u} (R : Type u) [CommRing R]
    (M : Type u) [AddCommGroup M] [Module R M]
    [hM : Module.IsInvertible R M] :
    TensorProduct R M (Module.IsInvertible.inverseCarrier R M) ≃ₗ[R] R :=
  hM.exists_inverse.choose_spec.choose_spec.choose_spec.some

/-- The chosen inverse is itself invertible (with M as witness, via tensor comm). -/
noncomputable instance inverseIsInvertible.{u} (R : Type u) [CommRing R]
    (M : Type u) [AddCommGroup M] [Module R M]
    [Module.IsInvertible R M] :
    Module.IsInvertible R (Module.IsInvertible.inverseCarrier R M) where
  exists_inverse :=
    ⟨M, inferInstance, inferInstance,
      ⟨(TensorProduct.comm R _ M).trans (inverseIso R M)⟩⟩

/-- **R114: inverse-up-to-iso uniqueness lemma**.

If two invertible R-modules M, M' are R-linearly isomorphic, then their
chosen inverses are also R-linearly isomorphic.

This is the **key step** for the well-definedness of `Picard.inv`:
since the inverse module is canonical only up to iso, we need to show
the iso class of the inverse is determined by the iso class of the
original module.

**Proof sketch** (Hartshorne II.6.12 / Bourbaki AC II §5):
```
inverseCarrier M
≃ R ⊗ inverseCarrier M            -- lid.symm
≃ (M' ⊗ inverseCarrier M') ⊗ inverseCarrier M  -- (inverseIso M').symm
≃ M' ⊗ (inverseCarrier M' ⊗ inverseCarrier M)  -- assoc
≃ M ⊗ (inverseCarrier M' ⊗ inverseCarrier M)   -- e.symm
≃ M ⊗ (inverseCarrier M ⊗ inverseCarrier M')   -- comm on second factor
≃ (M ⊗ inverseCarrier M) ⊗ inverseCarrier M'   -- assoc.symm
≃ R ⊗ inverseCarrier M'           -- inverseIso M
≃ inverseCarrier M'               -- lid
```
-/
noncomputable def inverseCarrier_iso_of_iso.{u} (R : Type u) [CommRing R]
    {M M' : Type u} [AddCommGroup M] [Module R M] [Module.IsInvertible R M]
    [AddCommGroup M'] [Module R M'] [Module.IsInvertible R M']
    (e : M ≃ₗ[R] M') :
    Module.IsInvertible.inverseCarrier R M ≃ₗ[R]
      Module.IsInvertible.inverseCarrier R M' :=
  let N := Module.IsInvertible.inverseCarrier R M
  let N' := Module.IsInvertible.inverseCarrier R M'
  let eM : TensorProduct R M N ≃ₗ[R] R := Module.IsInvertible.inverseIso R M
  let eM' : TensorProduct R M' N' ≃ₗ[R] R := Module.IsInvertible.inverseIso R M'
  -- N ≃ R ⊗ N
  let step1 : N ≃ₗ[R] TensorProduct R R N := (TensorProduct.lid R N).symm
  -- R ⊗ N ≃ (M' ⊗ N') ⊗ N
  let step2 : TensorProduct R R N ≃ₗ[R] TensorProduct R (TensorProduct R M' N') N :=
    TensorProduct.congr eM'.symm (LinearEquiv.refl R N)
  -- (M' ⊗ N') ⊗ N ≃ M' ⊗ (N' ⊗ N)
  let step3 : TensorProduct R (TensorProduct R M' N') N ≃ₗ[R]
      TensorProduct R M' (TensorProduct R N' N) := TensorProduct.assoc R M' N' N
  -- M' ⊗ (N' ⊗ N) ≃ M ⊗ (N' ⊗ N)
  let step4 : TensorProduct R M' (TensorProduct R N' N) ≃ₗ[R]
      TensorProduct R M (TensorProduct R N' N) :=
    TensorProduct.congr e.symm (LinearEquiv.refl R _)
  -- M ⊗ (N' ⊗ N) ≃ M ⊗ (N ⊗ N')
  let step5 : TensorProduct R M (TensorProduct R N' N) ≃ₗ[R]
      TensorProduct R M (TensorProduct R N N') :=
    TensorProduct.congr (LinearEquiv.refl R M) (TensorProduct.comm R N' N)
  -- M ⊗ (N ⊗ N') ≃ (M ⊗ N) ⊗ N'
  let step6 : TensorProduct R M (TensorProduct R N N') ≃ₗ[R]
      TensorProduct R (TensorProduct R M N) N' :=
    (TensorProduct.assoc R M N N').symm
  -- (M ⊗ N) ⊗ N' ≃ R ⊗ N'
  let step7 : TensorProduct R (TensorProduct R M N) N' ≃ₗ[R]
      TensorProduct R R N' :=
    TensorProduct.congr eM (LinearEquiv.refl R N')
  -- R ⊗ N' ≃ N'
  let step8 : TensorProduct R R N' ≃ₗ[R] N' := TensorProduct.lid R N'
  step1.trans (step2.trans (step3.trans (step4.trans
    (step5.trans (step6.trans (step7.trans step8))))))

end Module.IsInvertible

/-! ### `Picard.inv` (R115): the Picard inverse via chosen-inverse extraction

The Picard inverse operation: `[M]⁻¹ = [inverseCarrier R M]`. Lifted
from the Sigma-level inverse using R114 inverse-up-to-iso uniqueness
for well-definedness. -/

namespace Module.IsInvertible.Sigma

/-- The Sigma-level inverse: package `inverseCarrier R s.carrier` as a Sigma element. -/
noncomputable def inverse.{u} {R : Type u} [CommRing R]
    (s : Module.IsInvertible.Sigma R) : Module.IsInvertible.Sigma R :=
  Module.IsInvertible.Sigma.mk (R := R)
    (Module.IsInvertible.inverseCarrier R s.carrier)

/-- Inverse respects iso-equivalence (uses R114 uniqueness lemma). -/
theorem IsoRel.inverse.{u} {R : Type u} [CommRing R]
    {s t : Module.IsInvertible.Sigma R} (h : IsoRel s t) :
    IsoRel (inverse s) (inverse t) := by
  obtain ⟨e⟩ := h
  exact ⟨Module.IsInvertible.inverseCarrier_iso_of_iso R e⟩

end Module.IsInvertible.Sigma

namespace Picard

/-- The Picard inverse: `[M]⁻¹ = [inverseCarrier R M]`. -/
noncomputable def inv.{u} {R : Type u} [CommRing R] (x : Picard R) : Picard R :=
  Quotient.liftOn (s := Module.IsInvertible.Sigma.IsoSetoid R) x
    (fun s => Quotient.mk _ (Module.IsInvertible.Sigma.inverse s))
    (fun _ _ h => Quotient.sound (Module.IsInvertible.Sigma.IsoRel.inverse h))

/-- `inv` agrees with `inverseCarrier` on representatives. -/
theorem inv_mk.{u} {R : Type u} [CommRing R]
    (M : Type u) [AddCommGroup M] [Module R M] [Module.IsInvertible R M] :
    inv (mk (R := R) M) = mk (R := R) (Module.IsInvertible.inverseCarrier R M) :=
  rfl

/-- **R116**: left multiplicative inverse law (`x⁻¹ * x = 1` in Picard).
The witness iso is `inverseCarrier R M ⊗ M ≃ M ⊗ inverseCarrier R M ≃ R`. -/
theorem inv_mul_cancel.{u} {R : Type u} [CommRing R] (x : Picard R) :
    mul (inv x) x = one R := by
  refine Quotient.inductionOn
    (motive := fun a => mul (inv a) a = one R) x ?_
  intro s
  refine Quotient.sound ⟨?_⟩
  -- Need: TensorProduct R (inverseCarrier R s.carrier) s.carrier ≃ₗ[R] R
  exact (TensorProduct.comm R _ s.carrier).trans
    (Module.IsInvertible.inverseIso R s.carrier)

/-- **R116**: right multiplicative inverse law (`x * x⁻¹ = 1` in Picard). -/
theorem mul_inv_cancel.{u} {R : Type u} [CommRing R] (x : Picard R) :
    mul x (inv x) = one R := by
  rw [mul_comm]
  exact inv_mul_cancel x

/-- **R117**: `Picard R` is a commutative group.

Bundling commMonoid (R112) + inv (R115) + inv_mul_cancel / mul_inv_cancel
(R116) into the full Mathlib `CommGroup` type-class. This completes the
20-round (R97-R117) standalone construction of the algebraic Picard
group, kernel-pure modulo Mathlib. -/
noncomputable instance commGroup.{u} (R : Type u) [CommRing R] :
    CommGroup (Picard R) where
  __ := commMonoid R
  inv := inv
  inv_mul_cancel := inv_mul_cancel
  mul_comm := mul_comm

/-- **R126**: `Picard R` is a `CommGroupWithZero`-free structure. The class
`[R]` of the trivial bundle is the multiplicative identity.

This lemma is the explicit form of the CommGroup's `one_eq_one` for the
Picard quotient. Convenient as a Mathlib-side simp lemma. -/
@[simp]
theorem mk_R_eq_one.{u} {R : Type u} [CommRing R] :
    mk (R := R) R = one R :=
  rfl

/-- **R126**: the identity class inverts to itself. Standard CommGroup
consequence, proved directly from the structural definition. -/
theorem inv_one.{u} {R : Type u} [CommRing R] :
    inv (one R) = one R := by
  -- inv (one R) = inv (mk R) = mk (inverseCarrier R R)
  -- inverseCarrier R R has iso M ⊗ R ≃ R giving M ≃ R via inverseIso transport.
  refine Quotient.sound ?_
  -- Need: IsoRel (Sigma.inverse (Sigma.mk R)) (Sigma.mk R), i.e.,
  -- Nonempty (inverseCarrier R R ≃ₗ[R] R).
  -- inverseIso R R gives R ⊗ inverseCarrier R R ≃ R; combine with lid to get
  -- inverseCarrier R R ≃ R.
  refine ⟨?_⟩
  -- inverseCarrier R R ≃ R ⊗ inverseCarrier R R ≃ R
  exact (TensorProduct.lid R _).symm.trans (Module.IsInvertible.inverseIso R R)

end Picard

/-! ### Project bridge (R123): `LineBundleData` instance for any CommRing

The project's `LineBundleData X` typeclass (HodgeReduction/Infrastructure/
AlgebraicGeometry/LineBundle.lean) packages the carrier-level data of
line bundles on `X` as a quotient-ready abstract framework.

For an affine scheme `X = Spec R`, line bundles ARE invertible R-modules
(Hartshorne II.6.12 / Bourbaki AC II §5), and the algebraic Picard group
agrees with the geometric Picard group `Pic(Spec R) = H^1(Spec R, 𝒪*)`.

Given the R97-R117 Picard construction is complete, we can now provide a
`LineBundleData R` instance for ANY commutative ring R, using:
- `Carrier := Module.IsInvertible.Sigma R`
- `trivial := mk R` (the algebraic structure sheaf is R itself)
- `tensor := Sigma.tensor` (R110)
- `dual := Sigma.inverse` (R115)
- `iso := IsoSetoid R` (R108)
- congruences/laws from R110+R114+R111+R116 (already proven)

This bridges 20 layers of Mathlib infrastructure into a load-bearing
project-side typeclass instance, removing the project's dependence on
its own opaque framework when the underlying ring is commutative. -/

namespace ProjectBridge

open Module.IsInvertible.Sigma in
/-- R123 bridge: `LineBundleData R` for any commutative ring R, using
the R97-R117 Picard construction. `X := R` (the ring itself stands in
for the affine scheme `Spec R`). -/
noncomputable instance LineBundleData_for_CommRing.{u}
    (R : Type u) [CommRing R] :
    HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundleData R where
  Carrier := Module.IsInvertible.Sigma R
  trivial := Module.IsInvertible.Sigma.mk (R := R) R
  tensor := Module.IsInvertible.Sigma.tensor
  dual := Module.IsInvertible.Sigma.inverse
  iso := Module.IsInvertible.Sigma.IsoSetoid R
  tensor_respects_iso := IsoRel.tensor
  dual_respects_iso := IsoRel.inverse
  tensor_trivial_left := fun s => by
    -- need: IsoRel (tensor (mk R) s) s
    -- i.e., Nonempty (TensorProduct R R s.carrier ≃ₗ[R] s.carrier)
    exact ⟨TensorProduct.lid R s.carrier⟩
  tensor_dual_right := fun s => by
    -- need: IsoRel (tensor s (inverse s)) (mk R)
    -- i.e., Nonempty (TensorProduct R s.carrier (inverseCarrier R s.carrier) ≃ₗ[R] R)
    exact ⟨Module.IsInvertible.inverseIso R s.carrier⟩
  tensor_comm := fun s t => by
    exact ⟨TensorProduct.comm R s.carrier t.carrier⟩
  tensor_assoc := fun s t u => by
    exact ⟨TensorProduct.assoc R s.carrier t.carrier u.carrier⟩

end ProjectBridge

/-! ### `Module.IsInvertible.baseChange` (R127): Picard functoriality first step

For any ring hom `R → A` (encoded as `[Algebra R A]`), the base change
`M ↦ A ⊗[R] M` sends invertible R-modules to invertible A-modules. This
is the first piece of the functoriality of `Picard : CommRing → CommGroup`.

**Mathematical content** (Bourbaki AC II §5, EGA II §1):
If `M ⊗_R N ≃ R`, then taking `A ⊗_R (·)` of both sides and using base-change
distributivity gives `(A ⊗_R M) ⊗_A (A ⊗_R N) ≃ A ⊗_R R ≃ A`. Hence
`A ⊗_R M` is A-invertible with witness `A ⊗_R N`.

**Mathlib infra used**:
- `TensorProduct.AlgebraTensorModule.cancelBaseChange`: standard base-change
  cancellation `M ⊗[A] (A ⊗[R] N) ≃ₗ[B] M ⊗[R] N`
- `TensorProduct.AlgebraTensorModule.assoc`: associativity in the tower
- `TensorProduct.congr` + `TensorProduct.rid`: standard tensor manipulation

**Significance**: with `baseChange`, the Picard construction R97-R117 becomes
**functorial**, opening the door to Picard.{u} as a `Functor : CommRingCat ⥤ CommGroupCat`. -/

theorem Module.IsInvertible.baseChange.{u}
    (R : Type u) [CommRing R]
    (A : Type u) [CommRing A] [Algebra R A]
    (M : Type u) [AddCommGroup M] [Module R M]
    [hM : Module.IsInvertible R M] :
    Module.IsInvertible A (TensorProduct R A M) where
  exists_inverse := by
    obtain ⟨N, instAcgN, instModN, ⟨eM⟩⟩ := hM.exists_inverse
    refine ⟨TensorProduct R A N, inferInstance, inferInstance, ⟨?_⟩⟩
    -- Goal: TensorProduct A (TensorProduct R A M) (TensorProduct R A N) ≃ₗ[A] A
    -- Chain (right-to-left): A ≃ A ⊗[R] R ≃ A ⊗[R] (M ⊗[R] N) ≃
    --   (A ⊗[R] M) ⊗[A] (A ⊗[R] N)
    -- Build the inverse-direction chain and take symm.
    -- Step a: A ≃ₗ[A] A ⊗[R] R   via TensorProduct.AlgebraTensorModule.rid.symm
    let stepA : A ≃ₗ[A] TensorProduct R A R :=
      (TensorProduct.AlgebraTensorModule.rid R A A).symm
    -- Step b: A ⊗[R] R ≃ₗ[A] A ⊗[R] (M ⊗[R] N)  via congr refl eM.symm
    let stepB : TensorProduct R A R ≃ₗ[A] TensorProduct R A (TensorProduct R M N) :=
      TensorProduct.AlgebraTensorModule.congr (LinearEquiv.refl A A) eM.symm
    -- Step c: A ⊗[R] (M ⊗[R] N) ≃ₗ[A] (A ⊗[R] M) ⊗[A] (A ⊗[R] N)
    --   via TensorProduct.AlgebraTensorModule.distribBaseChange
    let stepC : TensorProduct R A (TensorProduct R M N) ≃ₗ[A]
        TensorProduct A (TensorProduct R A M) (TensorProduct R A N) :=
      TensorProduct.AlgebraTensorModule.distribBaseChange R A M N
    -- Compose and take symm to get the required iso.
    exact (stepA.trans (stepB.trans stepC)).symm

/-! ### `Picard.baseChange` (R128): the induced group hom `Picard R → Picard A`

Lift `Module.IsInvertible.baseChange` (R127) to the quotient: for any
R-algebra A, base change descends to a `MonoidHom Picard R →* Picard A`.

This is the full Picard-functoriality statement at the group level. -/

namespace Module.IsInvertible.Sigma

/-- Base change at the Sigma level: package `A ⊗_R s.carrier` as a Sigma element. -/
noncomputable def baseChange.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A]
    (s : Module.IsInvertible.Sigma R) : Module.IsInvertible.Sigma A :=
  haveI := Module.IsInvertible.baseChange R A s.carrier
  Module.IsInvertible.Sigma.mk (R := A) (TensorProduct R A s.carrier)

/-- Base change respects iso-equivalence: if `s ≃ t` over R, then
`A ⊗_R s ≃ A ⊗_R t` over A. -/
theorem IsoRel.baseChange.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A]
    {s t : Module.IsInvertible.Sigma R} (h : IsoRel s t) :
    IsoRel (baseChange A s) (baseChange A t) := by
  obtain ⟨e⟩ := h
  exact ⟨TensorProduct.AlgebraTensorModule.congr (LinearEquiv.refl A A) e⟩

end Module.IsInvertible.Sigma

namespace Picard

/-- `Picard.baseChange A : Picard R → Picard A` — the function lifted from
`Sigma.baseChange` via the iso-equivalence-respecting Quotient.liftOn. -/
noncomputable def baseChange.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A]
    (x : Picard R) : Picard A :=
  Quotient.liftOn (s := Module.IsInvertible.Sigma.IsoSetoid R) x
    (fun s => Quotient.mk _ (Module.IsInvertible.Sigma.baseChange A s))
    (fun _ _ h => Quotient.sound
      (Module.IsInvertible.Sigma.IsoRel.baseChange A h))

/-- `baseChange` agrees with `TensorProduct R A M` on representatives. -/
theorem baseChange_mk.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A]
    (M : Type u) [AddCommGroup M] [Module R M] [Module.IsInvertible R M] :
    baseChange A (mk (R := R) M) =
      haveI := Module.IsInvertible.baseChange R A M
      mk (R := A) (TensorProduct R A M) :=
  rfl

/-- **R129**: `baseChange` preserves the multiplicative identity. The
identity is `[R]` over R and `[A]` over A; the iso `A ⊗[R] R ≃ A` is
`AlgebraTensorModule.rid`. -/
theorem baseChange_one.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A] :
    baseChange (R := R) A (one R) = one A :=
  Quotient.sound ⟨TensorProduct.AlgebraTensorModule.rid R A A⟩

/-- **R129**: `baseChange` preserves multiplication. On representatives:
`baseChange A (mk M ⊗ mk N) = mk (A ⊗_R (M ⊗_R N)) ≃ mk ((A ⊗_R M) ⊗_A (A ⊗_R N))
= baseChange A (mk M) ⊗ baseChange A (mk N)`.
The middle iso is `TensorProduct.AlgebraTensorModule.distribBaseChange`. -/
theorem baseChange_mul.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A]
    (x y : Picard R) :
    baseChange A (mul x y) = mul (baseChange A x) (baseChange A y) := by
  refine Quotient.inductionOn₂
    (motive := fun a b =>
      baseChange A (mul a b) = mul (baseChange A a) (baseChange A b)) x y ?_
  intro s t
  exact Quotient.sound
    ⟨TensorProduct.AlgebraTensorModule.distribBaseChange R A s.carrier t.carrier⟩

/-- **R129**: `Picard.baseChange A` as a `MonoidHom Picard R →* Picard A`.
This is the FULL functoriality statement: the base-change action on
algebraic Picard groups is a multiplicative monoid hom. -/
noncomputable def baseChangeHom.{u}
    (R : Type u) [CommRing R] (A : Type u) [CommRing A] [Algebra R A] :
    Picard R →* Picard A where
  toFun := baseChange A
  map_one' := baseChange_one A
  map_mul' := baseChange_mul A

/-- **R130: functor identity law** `baseChange R = id` on `Picard R`.
For each [M] ∈ Picard R, `R ⊗_R M ≃ M` via `TensorProduct.lid`. -/
theorem baseChange_self.{u} {R : Type u} [CommRing R] (x : Picard R) :
    baseChange (R := R) R x = x := by
  refine Quotient.inductionOn
    (motive := fun a => baseChange (R := R) R a = a) x ?_
  intro s
  exact Quotient.sound ⟨TensorProduct.lid R s.carrier⟩

/-- **R130: functor composition law** `baseChange B ∘ baseChange A = baseChange B`
over a tower of rings `R → A → B`. The proof uses Mathlib's
`AlgebraTensorModule.cancelBaseChange : B ⊗[A] (A ⊗[R] N) ≃ₗ[B] B ⊗[R] N`. -/
theorem baseChange_comp.{u}
    {R : Type u} [CommRing R]
    {A : Type u} [CommRing A] [Algebra R A]
    {B : Type u} [CommRing B] [Algebra R B] [Algebra A B] [IsScalarTower R A B]
    (x : Picard R) :
    baseChange B (baseChange A x) = baseChange B x := by
  refine Quotient.inductionOn
    (motive := fun a => baseChange B (baseChange A a) = baseChange B a) x ?_
  intro s
  exact Quotient.sound
    ⟨TensorProduct.AlgebraTensorModule.cancelBaseChange R A B B s.carrier⟩

/-- **R131: Picard of a field is trivial** (Bourbaki AC II §5; Hartshorne II.6).

For any field K, every invertible K-module is K-linearly isomorphic to K
itself (since K-vector spaces have well-defined dimension; the tensor
product equation `M ⊗ N ≃ K` forces `dim M = dim N = 1`, hence
`M ≃ K`). Therefore `Picard K` has a unique element, namely `[K] = one K`.

This is a major concrete corollary of the R97-R117 Picard construction,
showing that the abstract Picard group recovers the classical fact
`Pic(field) = trivial`. -/
theorem eq_one_of_field.{u} {K : Type u} [Field K] (x : Picard K) :
    x = one K := by
  refine Quotient.inductionOn (motive := fun a => a = one K) x ?_
  intro s
  -- Extract the invertibility witness e : TensorProduct K s.carrier N ≃ₗ K
  obtain ⟨N, instAcgN, instModN, ⟨e⟩⟩ :=
    (Module.IsInvertible.Sigma.carrierIsInvertible s).exists_inverse
  -- Step 1: rank K K = 1
  have hRankK : Module.rank K K = 1 := Module.rank_self K
  -- Step 2: rank K (M ⊗ N) = 1 (via the iso e)
  have hRankTensor : Module.rank K (TensorProduct K s.carrier N) = 1 := by
    rw [e.rank_eq]; exact hRankK
  -- Step 3: rank M * rank N = 1 (Mathlib rank_tensorProduct')
  have hRankProd : Module.rank K s.carrier * Module.rank K N = 1 := by
    rw [← rank_tensorProduct']; exact hRankTensor
  -- Step 4: rank M ≠ 0 and rank N ≠ 0 (otherwise product = 0, not 1)
  have hRankM_ne : Module.rank K s.carrier ≠ 0 := fun h => by
    simp [h] at hRankProd
  have hRankN_ne : Module.rank K N ≠ 0 := fun h => by
    simp [h] at hRankProd
  -- Step 5: 1 ≤ rank M and 1 ≤ rank N
  have hOneLe_M : (1 : Cardinal) ≤ Module.rank K s.carrier :=
    Cardinal.one_le_iff_ne_zero.mpr hRankM_ne
  have hOneLe_N : (1 : Cardinal) ≤ Module.rank K N :=
    Cardinal.one_le_iff_ne_zero.mpr hRankN_ne
  -- Step 6: rank M = 1 from mul_eq_one_iff_of_one_le
  have hRankM : Module.rank K s.carrier = 1 :=
    ((mul_eq_one_iff_of_one_le hOneLe_M hOneLe_N).mp hRankProd).1
  -- Step 7: finrank K s.carrier = 1
  have hFinrankM : Module.finrank K s.carrier = 1 :=
    Module.rank_eq_one_iff_finrank_eq_one.mp hRankM
  -- Step 8: get Basis Unit, lift to iso M ≃ₗ K via funUnique
  let b : Basis Unit K s.carrier := Module.basisUnique Unit hFinrankM
  refine Quotient.sound ⟨b.equivFun.trans (LinearEquiv.funUnique Unit K K)⟩

/-- **R131**: `Picard K` is the trivial group for any field K (Subsingleton). -/
instance subsingleton_of_field.{u} {K : Type u} [Field K] : Subsingleton (Picard K) :=
  ⟨fun a b => by rw [eq_one_of_field a, eq_one_of_field b]⟩

/-- **R133**: `baseChange` preserves inverses. Follows from `MonoidHom.map_inv`
applied to `baseChangeHom`, but stated explicitly as a useful corollary. -/
theorem baseChange_inv.{u}
    {R : Type u} [CommRing R] (A : Type u) [CommRing A] [Algebra R A]
    (x : Picard R) :
    baseChange A (inv x) = inv (baseChange A x) := by
  show baseChangeHom R A x⁻¹ = (baseChangeHom R A x)⁻¹
  exact (baseChangeHom R A).map_inv x

/-- **R133**: ring isomorphism gives Picard isomorphism (functoriality on isos).

For any commutative-ring isomorphism `R ≃+* A` (which provides mutually inverse
`Algebra` structures + scalar-tower compatibility), the induced base-change
MonoidHom `Picard R →* Picard A` is a `MulEquiv`. The inverse is `baseChange R`
(via the inverse algebra). Functoriality (R130 `baseChange_self`+`baseChange_comp`)
ensures the composites are identity.

This is the strongest categorical statement: `Picard` carries ring isomorphisms
to group isomorphisms (i.e., `Picard` factors through the core groupoid). -/
noncomputable def baseChangeMulEquiv.{u}
    (R A : Type u) [CommRing R] [CommRing A]
    [Algebra R A] [Algebra A R] [IsScalarTower R A R] [IsScalarTower A R A] :
    Picard R ≃* Picard A where
  toFun := baseChange A
  invFun := baseChange R
  left_inv := fun x => by
    have h := baseChange_comp (R := R) (A := A) (B := R) x
    rw [h, baseChange_self]
  right_inv := fun x => by
    have h := baseChange_comp (R := A) (A := R) (B := A) x
    rw [h, baseChange_self]
  map_mul' := baseChange_mul A

end Picard

/-! ### R132: Picard ≃ LineBundleData.IsoClass for any CommRing

For any commutative ring `R`, the R123 bridge `LineBundleData_for_CommRing R`
makes `LineBundleData.IsoClass R = Picard R` as types (both are the quotient
of the same `Module.IsInvertible.Sigma.IsoSetoid R`). The two `CommGroup`
instances also agree on representatives, giving a group equality. -/

namespace ProjectBridge

/-- The carrier-level equality: for any CommRing R, the project's
`LineBundleData.IsoClass R` and the Mathlib-side `Picard R` are
definitionally the same quotient. -/
theorem LineBundleData_IsoClass_eq_Picard.{u} (R : Type u) [CommRing R] :
    HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundleData.IsoClass R =
      Picard R :=
  rfl

/-- **R139**: the project's `trivialClass` (identity of `IsoClass`) agrees
with the Mathlib-side `Picard.one` on representatives.

Since `LineBundleData_for_CommRing.trivial = Module.IsInvertible.Sigma.mk R`
and `Picard.one R = Quotient.mk _ (Sigma.mk R)`, the two are definitionally
equal as elements of the shared quotient type. -/
theorem trivialClass_eq_one.{u} (R : Type u) [CommRing R] :
    @HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundleData.trivialClass R _ =
      Picard.one R :=
  rfl

/-- **R139**: the project's `tensorClass` (binary op on `IsoClass`) agrees
with the Mathlib-side `Picard.mul` on representatives.

Both lift `Sigma.tensor` through the `IsoSetoid` quotient. The Quotient
machinery makes them def eq. -/
theorem tensorClass_eq_mul.{u} (R : Type u) [CommRing R]
    (x y : Picard R) :
    @HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundleData.tensorClass R _ x y =
      Picard.mul x y :=
  rfl

/-- **R139**: the project's `dualClass` (unary op on `IsoClass`) agrees
with the Mathlib-side `Picard.inv` on representatives. -/
theorem dualClass_eq_inv.{u} (R : Type u) [CommRing R]
    (x : Picard R) :
    @HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundleData.dualClass R _ x =
      Picard.inv x :=
  rfl

end ProjectBridge

/-! ### Mathlib-PR readiness checklist

* Definition is single-purpose, mathematically standard.
* No `sorry`, no `:= True`, no opaque axioms.
* Trivial witness `Module.IsInvertible.self` proves the class is
  inhabited and uses only Mathlib's `TensorProduct.lid`.
* Documentation cites Hartshorne, Bourbaki, and explains the geometric
  meaning (line bundle = invertible module on Spec R).
* HC application explained: ties to `Concrete.EVII.evii_lineBundleData`
  which currently uses ad-hoc framework; Mathlib-native foundation
  removes the framework's project-local dependency.

**Multi-week roadmap to full Picard group**:
1. ✓ `Module.IsInvertible` class (R97).
2. Show invertibility is preserved under tensor product
   (`IsInvertible M ∧ IsInvertible N → IsInvertible (M ⊗ N)`).
3. Show invertibility is preserved under dual
   (`IsInvertible M → IsInvertible (Module.Dual R M)`).
4. Define `Pic R` as the quotient of isomorphism classes of
   invertible modules by tensor equivalence.
5. Show `Pic R` is a commutative group under tensor product.
6. Provide `instance : Module.IsInvertible R (Module.Dual R M)`
   (under `IsInvertible R M`).

Steps 2-6 are each multi-week. The user mandate explicitly accepts
multi-month/year Mathlib infrastructure as the correct path; this is
a real-math, real-infra step in that direction. -/

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
-- R97 Module.IsInvertible class + trivial witness: kernel-pure.
#print axioms Module.IsInvertible.self
-- R98 Module.IsInvertible.tensor: tensor product preserves invertibility.
#print axioms Module.IsInvertible.tensor
-- R99 Module.IsInvertible.symm_equiv + of_inverse: invertibility is symmetric.
#print axioms Module.IsInvertible.symm_equiv
#print axioms Module.IsInvertible.of_inverse
-- R100 Module.IsInvertible.of_linearEquiv: invertibility transfers across iso.
#print axioms Module.IsInvertible.of_linearEquiv
-- R101 Module.IsInvertible.tensor_R_left/right: R ⊗ M and M ⊗ R invertible iff M is.
#print axioms Module.IsInvertible.tensor_R_left
#print axioms Module.IsInvertible.tensor_R_right
-- R102 Module.IsInvertible.tensor_assoc_iff: associativity of Pic tensor.
#print axioms Module.IsInvertible.tensor_assoc_iff
-- R104 Module.IsInvertible.iff_linearEquiv + of_equiv_R: full bidirectional + R-equiv corollary.
#print axioms Module.IsInvertible.iff_linearEquiv
#print axioms Module.IsInvertible.of_equiv_R
-- R105 Module.IsInvertible.chain_of_iso_R: derive 3 invertibility facts from one tensor iso.
#print axioms Module.IsInvertible.chain_of_iso_R
-- R106 Module.IsInvertible.tensor_three + tensor_self: n-fold tensor instances.
#print axioms Module.IsInvertible.tensor_three
#print axioms Module.IsInvertible.tensor_self
-- R107 Module.IsInvertible.Sigma carrier_mk: Sigma type for Pic R quotient construction.
#print axioms Module.IsInvertible.Sigma.carrier_mk
-- R108 Module.IsInvertible.Sigma.IsoRel + IsoSetoid: iso-equivalence Setoid for Pic R quotient.
#print axioms Module.IsInvertible.Sigma.IsoRel.refl
#print axioms Module.IsInvertible.Sigma.IsoRel.symm
#print axioms Module.IsInvertible.Sigma.IsoRel.trans
#print axioms Module.IsInvertible.Sigma.IsoSetoid
-- R109 Picard quotient type + mk + one + mk_eq_mk_iff: Pic R quotient construction.
#print axioms Picard.mk
#print axioms Picard.one
#print axioms Picard.mk_eq_mk_iff
-- R110 Picard.mul (tensor lift) + Sigma.tensor + IsoRel functoriality: Picard binary operation.
#print axioms Module.IsInvertible.Sigma.tensor
#print axioms Module.IsInvertible.Sigma.tensor_carrier
#print axioms Module.IsInvertible.Sigma.IsoRel.tensor
#print axioms Picard.mul
#print axioms Picard.mul_mk
-- R111 Picard CommMonoid laws: mul_comm + mul_assoc + one_mul + mul_one.
#print axioms Picard.mul_comm
#print axioms Picard.mul_assoc
#print axioms Picard.one_mul
#print axioms Picard.mul_one
-- R112 Picard CommMonoid instance.
#print axioms Picard.commMonoid
-- R113 Module.IsInvertible inverse extraction: type-level inverse + invertibility.
#print axioms Module.IsInvertible.inverseCarrier
#print axioms Module.IsInvertible.inverseAddCommGroup
#print axioms Module.IsInvertible.inverseModule
#print axioms Module.IsInvertible.inverseIso
#print axioms Module.IsInvertible.inverseIsInvertible
-- R114 inverseCarrier_iso_of_iso: inverse is unique up to iso (key uniqueness lemma).
#print axioms Module.IsInvertible.inverseCarrier_iso_of_iso
-- R115 Sigma.inverse + Picard.inv: Picard inverse via Quotient lift.
#print axioms Module.IsInvertible.Sigma.inverse
#print axioms Module.IsInvertible.Sigma.IsoRel.inverse
#print axioms Picard.inv
#print axioms Picard.inv_mk
-- R116-R117 Picard CommGroup: inv_mul_cancel + mul_inv_cancel + CommGroup instance.
#print axioms Picard.inv_mul_cancel
#print axioms Picard.mul_inv_cancel
#print axioms Picard.commGroup

end HodgeReduction.MathlibCandidates
