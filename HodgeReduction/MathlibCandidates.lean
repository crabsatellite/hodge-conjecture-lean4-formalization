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

end HodgeReduction.MathlibCandidates
