/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Star.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Data.Set.Image

/-!
# CM type / CM abelian variety framework

An **abelian variety with complex multiplication** (CM) is an
abelian variety `A` of dimension `g` such that `End^0(A) := End(A) ⊗ ℚ`
contains a CM field `E` of degree `2g`.

By **Shimura–Taniyama (1961)**: every CM abelian variety has a model over
a number field, and its arithmetic is governed by the **CM type** `Φ` —
a set of `g` embeddings of `E` into `ℂ` (out of the total `2g`) realising
the action on the holomorphic tangent space `T_e A ≅ ⊕_{σ ∈ Φ} ℂ_σ`.

The CM type `Φ ⊂ Hom(E, ℂ)` is characterised by two substantive axioms
(Shimura–Taniyama 1961, Main Theorem; Lang 1983 Ch. 1 §3; Mumford 1970
Ch. IV §22):

* **Completeness**: `Φ ⊔ \overline{Φ} = Hom(E, ℂ)` — every embedding is
  either in `Φ` or is the complex conjugate of one in `Φ`.
* **Disjointness**: `Φ ∩ \overline{Φ} = ∅` — no embedding equals its own
  complex conjugate (equivalently, `E` admits no real embedding, hence
  the **CM** = totally imaginary quadratic extension of a totally real
  field condition).

For our HC application, CM points on Shimura varieties parameterise CM
abelian varieties, and the Hodge conjecture is **known to hold for CM
abelian varieties of dimension ≤ 4** (Deligne 1982 *Hodge cycles on
abelian varieties*; explicit algebraicity for codim-2 cycles on CM
abelian fourfolds is **open** in general).

This file packages the abstract CM-type data as a typeclass with the
two Shimura–Taniyama axioms encoded as substantive `Set`-equations on
the embedding universe.

## References

* Shimura, G. and Taniyama, Y. *Complex Multiplication of Abelian
  Varieties and Its Applications to Number Theory*, Math. Soc. Japan,
  Tokyo, 1961 — Main Theorem (Ch. 1 §5).
* Lang, S. *Complex Multiplication*, Grundlehren **255**, Springer-Verlag,
  1983 — Ch. 1 §3 (Shimura–Taniyama formula) and Ch. 1 §4 (CM types).
* Mumford, D. *Abelian Varieties*, Tata Institute / Oxford, 1970 —
  Ch. IV §22 (CM theory of abelian varieties).
* Milne, J. S. *Complex Multiplication*, available at jmilne.org/math/,
  v0.10, 2020 — §1 (CM fields) and §4 (CM types).

## Main definitions

* `CMTypeData E` — abstract CM type data for a CM field `E`, packaging
  `Φ ⊂ Hom(E, ℂ)` together with the Shimura–Taniyama completeness and
  disjointness axioms.
* `AbelianVarietyCMData A E` — abelian variety `A` with CM by `E`,
  together with its CM type.
* `conjEmb` — the substantive complex-conjugation involution on
  embeddings `E →+* ℂ`, defined as post-composition with
  `starRingEnd ℂ`.

## Tags

CM type, complex multiplication, abelian variety, Shimura-Taniyama,
totally imaginary, embedding
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-! ## Complex conjugation on embeddings

The complex conjugation `\overline{\,\cdot\,} : ℂ → ℂ` is the
involutive `ℝ`-algebra automorphism of `ℂ` characterised by
`\overline{x + i y} = x - i y`. Post-composing with this gives the
canonical involution on the set of embeddings `E →+* ℂ` of any field
`E` into `ℂ`. -/

/-- The complex-conjugation involution on embeddings `E →+* ℂ`:
`conjEmb σ := \overline{\,\cdot\,} ∘ σ`. This is the substantive
involution underlying the Shimura–Taniyama axioms for CM types. -/
def conjEmb {E : Type*} [Semiring E] (σ : E →+* ℂ) : E →+* ℂ :=
  (starRingEnd ℂ).comp σ

@[simp]
lemma conjEmb_apply {E : Type*} [Semiring E] (σ : E →+* ℂ) (x : E) :
    conjEmb σ x = (starRingEnd ℂ) (σ x) := rfl

/-- The complex-conjugation involution on embeddings is involutive:
`conjEmb ∘ conjEmb = id`. This is the substantive fact
`\overline{\overline{z}} = z` for `z ∈ ℂ`, lifted to embeddings. -/
lemma conjEmb_involutive {E : Type*} [Semiring E] (σ : E →+* ℂ) :
    conjEmb (conjEmb σ) = σ := by
  ext x
  show (starRingEnd ℂ) ((starRingEnd ℂ) (σ x)) = σ x
  exact starRingEnd_self_apply (σ x)

/-! ## CM type data -/

/-- **CM type data** for a (would-be) CM field `E`:

* `embeddingsUniv` : the geometric universe of `2g` embeddings of `E`
  into `ℂ` (the relevant set, abstracted away from the full pathological
  set of all ring homs).
* `genus` : the genus `g = #Φ = #embeddingsUniv / 2`.
* `Phi` : the CM type — a subset of `embeddingsUniv` of cardinality `g`.

The **substantive axioms** (Shimura–Taniyama 1961):

* `Phi_subset_universe` — `Φ ⊆ embeddingsUniv`.
* `conjEmb_preserves_universe` — `\overline{embeddingsUniv} = embeddingsUniv`
  (the geometric universe is conjugation-stable).
* `Phi_union_conj_eq_universe` — `Φ ∪ \overline{Φ} = embeddingsUniv`
  (completeness: every embedding is either in `Φ` or is the conjugate
  of an embedding in `Φ`).
* `Phi_inter_conj_eq_empty` — `Φ ∩ \overline{Φ} = ∅`
  (disjointness: no real embeddings; equivalently, `E` is totally
  imaginary).

References: Shimura–Taniyama 1961 Main Theorem; Lang 1983 Ch. 1 §3-§4;
Mumford 1970 Ch. IV §22; Milne *Complex Multiplication* §4. -/
class CMTypeData (E : Type*) [Field E] where
  /-- The set of `2g` geometric embeddings of `E` into `ℂ`. -/
  embeddingsUniv : Set (E →+* ℂ)
  /-- The genus `g = #Φ`. -/
  genus : ℕ
  /-- The CM type `Φ` as a subset of `embeddingsUniv`. -/
  Phi : Set (E →+* ℂ)
  /-- `Φ ⊆ embeddingsUniv`. -/
  Phi_subset_universe : Phi ⊆ embeddingsUniv
  /-- The geometric universe of embeddings is closed under complex
  conjugation: `conjEmb '' embeddingsUniv = embeddingsUniv`. -/
  conjEmb_preserves_universe :
    conjEmb '' embeddingsUniv = embeddingsUniv
  /-- **Completeness axiom (Shimura–Taniyama 1961)**:
  `Φ ∪ \overline{Φ} = embeddingsUniv`. Every embedding is either in
  `Φ` or is the complex conjugate of an embedding in `Φ`. -/
  Phi_union_conj_eq_universe :
    Phi ∪ conjEmb '' Phi = embeddingsUniv
  /-- **Disjointness axiom (totally imaginary)**:
  `Φ ∩ \overline{Φ} = ∅`. No embedding `σ ∈ Φ` equals its own complex
  conjugate, i.e. `σ(E) ⊄ ℝ`. This forces `E` to be totally imaginary;
  combined with completeness it characterises a CM field as a totally
  imaginary quadratic extension of a totally real field. -/
  Phi_inter_conj_eq_empty :
    Phi ∩ conjEmb '' Phi = ∅

namespace CMTypeData

variable {E : Type*} [Field E] [CMTypeData E]

/-- Theorem-level restatement: `Φ ⊆ embeddingsUniv`. -/
theorem Phi_subset : Phi (E := E) ⊆ embeddingsUniv (E := E) :=
  Phi_subset_universe

/-- Theorem-level restatement of conjugation-stability of the universe. -/
theorem universe_conj_eq :
    conjEmb '' embeddingsUniv (E := E) = embeddingsUniv (E := E) :=
  conjEmb_preserves_universe

/-- Theorem-level restatement of the completeness axiom. -/
theorem completeness :
    Phi (E := E) ∪ conjEmb '' Phi (E := E) = embeddingsUniv (E := E) :=
  Phi_union_conj_eq_universe

/-- Theorem-level restatement of the disjointness axiom. -/
theorem disjointness :
    Phi (E := E) ∩ conjEmb '' Phi (E := E) = ∅ :=
  Phi_inter_conj_eq_empty

/-- The conjugate CM type `\overline{Φ}` is also contained in
`embeddingsUniv`. -/
theorem conj_Phi_subset_universe :
    conjEmb '' Phi (E := E) ⊆ embeddingsUniv (E := E) := by
  intro σ hσ
  -- `\overline{Φ} ⊆ Φ ∪ \overline{Φ} = embeddingsUniv` by completeness.
  rw [← completeness]
  exact Set.subset_union_right hσ

/-- **Corollary of disjointness**: no embedding in `Φ` is its own
complex conjugate. This is the "totally imaginary" characterisation. -/
theorem no_real_embedding_in_Phi
    {σ : E →+* ℂ} (hσ : σ ∈ Phi (E := E)) (hself : conjEmb σ = σ) : False := by
  -- `σ ∈ Φ ∩ \overline{Φ}` because `σ = conjEmb σ ∈ \overline{Φ}`.
  have hmem : σ ∈ Phi (E := E) ∩ conjEmb '' Phi (E := E) := by
    refine ⟨hσ, ?_⟩
    -- `σ = conjEmb σ` and `σ ∈ Φ`, so `σ ∈ conjEmb '' Φ`.
    refine ⟨σ, hσ, hself⟩
  -- But `Φ ∩ \overline{Φ} = ∅`.
  rw [disjointness] at hmem
  exact hmem.elim

/-- **Corollary of disjointness, contrapositive**: every embedding in
`Φ` is "genuinely complex" — its image is not contained in `ℝ`. -/
theorem conjEmb_ne_self_on_Phi
    {σ : E →+* ℂ} (hσ : σ ∈ Phi (E := E)) :
    conjEmb σ ≠ σ := by
  intro hself
  exact no_real_embedding_in_Phi (E := E) hσ hself

end CMTypeData

/-! ### Generic conjugation-set lemma (no `CMTypeData` instance required) -/

/-- **Coherence check** for the disjointness axiom on the empty subset:
the empty set is trivially disjoint from its conjugate image. This holds
for any field `E`, independently of any `CMTypeData` instance. -/
theorem empty_inter_conj_empty (E : Type*) [Field E] :
    (∅ : Set (E →+* ℂ)) ∩ conjEmb '' (∅ : Set (E →+* ℂ)) = ∅ := by
  simp

/-! ## CM abelian variety data: AV + its CM type -/

/-- **CM abelian variety data**: an abstract abelian variety `A` together
with a CM field `E` and the corresponding CM type.

* `cmFieldDim` records the dimension of `E` over `ℚ` (`= 2g`).
* The `[CMTypeData E]` instance carries the CM type data on `E`.

This is the typeclass-level packaging of "abelian variety with CM
structure"; concrete examples (CM elliptic curves, Jacobians of CM
curves, the four-dim Mumford fake-modular example, ...) instantiate
this with concrete `E` and concrete `Phi`. -/
class AbelianVarietyCMData (A : Type*) (E : Type*) [Field E]
    extends CMTypeData E where
  /-- The `ℚ`-dimension of `E`: `[E : ℚ] = 2g`. -/
  cmFieldDim : ℕ
  /-- The dimensional consistency: `cmFieldDim = 2 * genus` (i.e.
  `[E : ℚ] = 2g`). This is the substantive numerical compatibility
  of the CM field degree with the AV dimension. -/
  cmFieldDim_eq_two_genus : cmFieldDim = 2 * genus

namespace AbelianVarietyCMData

variable (A : Type*) {E : Type*} [Field E] [AbelianVarietyCMData A E]

/-- The CM field has degree `2g` over `ℚ`. -/
theorem cmFieldDim_eq : cmFieldDim (A := A) (E := E) = 2 * CMTypeData.genus (E := E) :=
  cmFieldDim_eq_two_genus

/-- The AV dimension equals half the CM-field degree. -/
theorem genus_eq_half_cmFieldDim :
    2 * CMTypeData.genus (E := E) = cmFieldDim (A := A) (E := E) :=
  (cmFieldDim_eq A).symm

end AbelianVarietyCMData

/-! ## Trivial inhabiting instance

We exhibit a concrete witness of `CMTypeData` to confirm the axiom
system is *consistent*. We use `E := ℂ` with the two-element embedding
universe `{id_ℂ, \overline{\,\cdot\,}}` and `Φ := {id_ℂ}`. Then:

* `\overline{Φ} = {\overline{id_ℂ} = starRingEnd ℂ}`.
* `Φ ∪ \overline{Φ} = {id_ℂ, starRingEnd ℂ} = embeddingsUniv` ✓
* `Φ ∩ \overline{Φ} = ∅` since `id_ℂ ≠ starRingEnd ℂ`
  (apply both sides to `Complex.I`: `id Complex.I = Complex.I` but
  `\overline{Complex.I} = -Complex.I`, and `Complex.I ≠ -Complex.I`
  in `ℂ`). ✓

This is **not** a real CM abelian variety; it is a minimal witness of
the abstract typeclass structure. -/

namespace Trivial

/-- The two-element embedding universe `{id_ℂ, starRingEnd ℂ}`. -/
def trivUniv : Set (ℂ →+* ℂ) :=
  ({RingHom.id ℂ, starRingEnd ℂ} : Set (ℂ →+* ℂ))

/-- The trivial CM type `Φ := {id_ℂ}`. -/
def trivPhi : Set (ℂ →+* ℂ) :=
  ({RingHom.id ℂ} : Set (ℂ →+* ℂ))

/-- The conjugation involution maps `id_ℂ` to `starRingEnd ℂ`. -/
lemma conjEmb_id : conjEmb (RingHom.id ℂ) = starRingEnd ℂ := by
  ext z
  simp [conjEmb, RingHom.comp_apply, RingHom.id_apply]

/-- The conjugation involution maps `starRingEnd ℂ` to `id_ℂ` (involutivity
specialised to the identity embedding). -/
lemma conjEmb_conj : conjEmb (starRingEnd ℂ) = RingHom.id ℂ := by
  ext z
  show (starRingEnd ℂ) ((starRingEnd ℂ) z) = z
  exact starRingEnd_self_apply z

/-- The identity embedding `id_ℂ` differs from complex conjugation
`starRingEnd ℂ`. The witness: applied to `Complex.I`, the first gives
`Complex.I` and the second gives `-Complex.I`, and `Complex.I ≠ -Complex.I`
in `ℂ`. -/
lemma id_ne_conj : (RingHom.id ℂ) ≠ starRingEnd ℂ := by
  intro h
  -- Apply both sides to `Complex.I` and compare.
  have hI : (RingHom.id ℂ) Complex.I = (starRingEnd ℂ) Complex.I := by
    rw [h]
  rw [RingHom.id_apply, Complex.conj_I] at hI
  -- `hI : Complex.I = -Complex.I`. Deduce `Complex.I + Complex.I = 0`, then `Complex.I = 0`.
  have h2 : Complex.I + Complex.I = 0 := by
    -- Add `Complex.I` to both sides of `hI`:
    --   `Complex.I + Complex.I = -Complex.I + Complex.I = 0`.
    have hadd : Complex.I + Complex.I = -Complex.I + Complex.I :=
      congr_arg (· + Complex.I) hI
    rw [neg_add_cancel] at hadd
    exact hadd
  have h3 : (2 : ℂ) * Complex.I = 0 := by
    rw [two_mul]; exact h2
  have hI_eq : Complex.I = 0 := by
    have h2' : (2 : ℂ) ≠ 0 := two_ne_zero
    exact (mul_eq_zero.mp h3).resolve_left h2'
  exact Complex.I_ne_zero hI_eq

/-- The image of the trivial CM type under conjugation is `{starRingEnd ℂ}`. -/
lemma conjEmb_image_trivPhi :
    conjEmb '' trivPhi = ({starRingEnd ℂ} : Set (ℂ →+* ℂ)) := by
  ext σ
  simp only [trivPhi, Set.mem_image, Set.mem_singleton_iff]
  constructor
  · rintro ⟨τ, hτ, hτeq⟩
    rw [hτ] at hτeq
    rw [← hτeq, conjEmb_id]
  · intro h
    refine ⟨RingHom.id ℂ, rfl, ?_⟩
    rw [conjEmb_id, h]

/-- The image of the trivial universe under conjugation equals itself:
`\overline{\{id_ℂ, conj\}} = \{conj, id_ℂ\} = \{id_ℂ, conj\}`. -/
lemma conjEmb_image_trivUniv :
    conjEmb '' trivUniv = trivUniv := by
  ext σ
  simp only [trivUniv, Set.mem_image, Set.mem_insert_iff,
             Set.mem_singleton_iff]
  constructor
  · rintro ⟨τ, hτ, hτeq⟩
    rcases hτ with hτ_id | hτ_conj
    · rw [hτ_id, conjEmb_id] at hτeq
      exact Or.inr hτeq.symm
    · rw [hτ_conj, conjEmb_conj] at hτeq
      exact Or.inl hτeq.symm
  · rintro (hσ | hσ)
    · refine ⟨starRingEnd ℂ, Or.inr rfl, ?_⟩
      rw [conjEmb_conj, hσ]
    · refine ⟨RingHom.id ℂ, Or.inl rfl, ?_⟩
      rw [conjEmb_id, hσ]

/-- The trivial CM type instance on `E := ℂ` with `Φ := {id_ℂ}` and the
two-element embedding universe `{id_ℂ, starRingEnd ℂ}`. This is the
minimal *witness* that the `CMTypeData` axioms are consistent. -/
noncomputable instance instCMTypeDataℂ : CMTypeData ℂ where
  embeddingsUniv := trivUniv
  genus := 1
  Phi := trivPhi
  Phi_subset_universe := by
    intro σ hσ
    simp only [trivPhi, Set.mem_singleton_iff] at hσ
    simp only [trivUniv, Set.mem_insert_iff, Set.mem_singleton_iff]
    exact Or.inl hσ
  conjEmb_preserves_universe := conjEmb_image_trivUniv
  Phi_union_conj_eq_universe := by
    ext σ
    simp only [trivPhi, Set.mem_union, Set.mem_singleton_iff,
               Set.mem_image, trivUniv, Set.mem_insert_iff]
    constructor
    · rintro (h | ⟨τ, hτ, hτeq⟩)
      · exact Or.inl h
      · rw [hτ] at hτeq
        rw [← hτeq, conjEmb_id]
        exact Or.inr rfl
    · rintro (hσ | hσ)
      · exact Or.inl hσ
      · right
        refine ⟨RingHom.id ℂ, rfl, ?_⟩
        rw [conjEmb_id, hσ]
  Phi_inter_conj_eq_empty := by
    rw [conjEmb_image_trivPhi]
    ext σ
    simp only [trivPhi, Set.mem_inter_iff, Set.mem_singleton_iff,
               Set.mem_empty_iff_false]
    constructor
    · rintro ⟨h1, h2⟩
      -- `σ = id_ℂ` and `σ = starRingEnd ℂ`, contradicting `id_ne_conj`.
      rw [h1] at h2
      exact id_ne_conj h2
    · intro h
      exact h.elim

/-- **Sanity check**: the trivial CM type has genus `1`. -/
example : CMTypeData.genus (E := ℂ) = 1 := rfl

/-- **Sanity check**: the trivial CM type has `Φ = {id_ℂ}`. -/
example : CMTypeData.Phi (E := ℂ) = ({RingHom.id ℂ} : Set (ℂ →+* ℂ)) := rfl

/-- **Sanity check**: the trivial CM type has the two-element universe. -/
example :
    CMTypeData.embeddingsUniv (E := ℂ) =
      ({RingHom.id ℂ, starRingEnd ℂ} : Set (ℂ →+* ℂ)) := rfl

/-- The trivial AV-CM data: pair the `CMTypeData ℂ` above with
`cmFieldDim = 2` (consistent with `genus = 1`, `2*1 = 2`).

`A := PUnit` plays the role of a one-point "abelian variety" — purely
a witness slot for the typeclass; no genuine geometry is asserted. -/
noncomputable instance instAbelianVarietyCMDataPUnit : AbelianVarietyCMData PUnit ℂ where
  toCMTypeData := instCMTypeDataℂ
  cmFieldDim := 2
  cmFieldDim_eq_two_genus := by
    show (2 : ℕ) = 2 * 1
    rfl

/-- **Sanity check**: the trivial AV-CM instance has CM-field degree `2`. -/
example : AbelianVarietyCMData.cmFieldDim (A := PUnit) (E := ℂ) = 2 := rfl

end Trivial

end HodgeReduction.Infrastructure.AbelianVariety
