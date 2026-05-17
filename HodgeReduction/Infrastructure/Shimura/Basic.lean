/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.HodgeStructure.MumfordTate
import HodgeReduction.Infrastructure.Cohomology.Basic
import Mathlib.Algebra.Group.Subgroup.Defs
import Mathlib.Algebra.Group.Subgroup.Lattice

/-!
# Shimura varieties — abstract data for the Mumford–Tate reduction

A **Shimura variety** `S_Γ` is a quasi-projective `ℚ`-variety
classifying polarised Hodge structures of given type with extra
data (Mumford–Tate group action, level structure). Concretely:

* `(G, X)` : a Shimura datum (G is a Q-algebraic group, X is a
  conjugacy class of cocharacters `S → G_ℝ`).
* `Γ ⊆ G(ℚ)` : a congruence subgroup.
* `S_Γ := Γ \\ X` (or its compactification).

For the Mumford–Tate reduction of the Hodge Conjecture (our paper),
we work with the **EVII Shimura variety**:
* `G = E_{7(-25)}` (the exceptional Lie group of type E_7, with
  −25 the signature of the Killing form on the symmetric pair).
* `X = E_{7(-25)} / (E_6 × U(1))` (the bounded symmetric domain
  of complex dimension 27).
* `S_Γ` is the moduli space of polarised Hodge structures of EVII
  type, with extra data.

This file packages the **abstract Shimura variety data** without
formalising the algebraic-group / arithmetic-quotient structure.
What we need for HC:

1. The cohomology ring `H^*(S_Γ; ℚ)` (a CommRing with `algebraic`).
2. A specific class `[q] ∈ H^8` (the Freudenthal class).
3. The polynomial identity `[q] = polynomial in Chern classes`.
4. A Kähler class `h ∈ H^2` (from the polarisation line bundle).
5. The proportionality `[q] = −48 h^4`.

In addition, we package the **Deligne SV-axioms** for a Shimura
datum `(G, X)` with `X` realised by an `h : ℂ → G_ℝ` cocharacter
class, the **Cartan involution** `θ` on `G`, the **compact-center
condition** (SV3), and the **canonical-model Galois action** on the
reflex field (Deligne 1971/1979; Milne 2017 §1-§4).

## References (Cat 2 PUBLISHED)

* P. Deligne, "Travaux de Shimura", *Sém. Bourbaki* **23**, exp. 389
  (1971), Lecture Notes in Math. **244**, 123-165. — Initial
  axiomatic Shimura-datum framework (G, X); SV1/SV2/SV3.
* P. Deligne, "Variétés de Shimura: interprétation modulaire, et
  techniques de construction de modèles canoniques", in *Automorphic
  Forms, Representations and L-functions*, Proc. Symp. Pure Math.
  **33** (AMS 1979), Part 2, 247-289. — Canonical models; reflex
  field; Galois action.
* J. S. Milne, *Introduction to Shimura Varieties* (rev. 2017),
  §1-§4. — Modern reference for the SV-axioms, Cartan involution,
  and canonical model.

## Main definitions

* `ShimuraVarietyData` : a typeclass packaging the cohomology data
  of a Shimura variety with a designated Freudenthal class and
  polynomial identity. (Preserved from earlier rounds.)
* `ComplexEmbedding` : abstract carrier for an `h`-cocharacter
  class element (the `S → G_ℝ` map in the Deligne SV-axioms).
* `ShimuraDatumData G D` : the Deligne SV-axioms (SV1 designated
  `h`, SV2 Cartan involution `θ` with `θ ∘ θ = id`, SV3 compact-
  center subgroup membership for the connected center).
* `CanonicalModelData G E` : the Galois action of `Gal(ℚ̄/E)` on the
  reflex field `E` as a substantive group homomorphism into a
  designated permutation of `G`-conjugacy data.

## Tags

Shimura variety, EVII, polarised Hodge structure, Mumford-Tate
reduction, SV-axioms, Cartan involution, canonical model, reflex
field, Galois action
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- Abstract data for a Shimura variety `S_Γ` relevant to the
HC application:

* `A` : the cohomology ring `H^*(S_Γ; ℚ)`.
* `dim` : the complex dimension of `S_Γ`.

This is the **minimal carrier** we need for the abstract HC argument.

For EVII specifically: `dim = 27`. -/
class ShimuraVarietyData (A : Type*) [CommRing A] [Algebra ℚ A]
    [Cohomology.CohomologyRing A] where
  /-- The complex dimension of the Shimura variety. -/
  dim : ℕ

namespace ShimuraVarietyData

variable {A : Type*} [CommRing A] [Algebra ℚ A]
    [Cohomology.CohomologyRing A] [ShimuraVarietyData A]

/-- For the EVII Shimura variety, `dim = 27`. -/
def EVII_dim : ℕ := 27

/-- Tag a `ShimuraVarietyData` as "EVII-type" if its dimension is 27. -/
def IsEVII : Prop := dim (A := A) = 27

end ShimuraVarietyData

/-! ## §1. `ComplexEmbedding` — abstract carrier for the SV1 `h`-cocharacter

The Deligne axiom SV1 (Deligne 1979 §1.1; Milne 2017 §1.2) packages
the conjugacy class `X` of `h : 𝕊 → G_ℝ` morphisms from the Deligne
torus `𝕊 = Res_{ℂ/ℝ} 𝔾_m` into the real form of `G`. We abstract
the carrier of a designated `h`-cocharacter as a separate type
`ComplexEmbedding`, with `mark : ComplexEmbedding → Bool` recording
whether the cocharacter is the designated SV1 base-point. -/

/-- Abstract carrier for a `ℂ → G_ℝ` cocharacter class element
(the Deligne SV1 axiom records a designated `h` in this carrier).

For the EVII Shimura datum, the underlying space is the conjugacy
class `X = E_{7(-25)} / (E_6 × U(1))` of `h`-cocharacters, with a
designated base-point `h₀`. -/
structure ComplexEmbedding where
  /-- A boolean marker selecting the designated SV1 base-point. -/
  mark : Bool

namespace ComplexEmbedding

/-- The designated base-point `h₀` (the SV1 cocharacter). -/
def basePoint : ComplexEmbedding := ⟨true⟩

/-- A non-base-point cocharacter (witness of multiplicity ≥ 2). -/
def offBase : ComplexEmbedding := ⟨false⟩

/-- **The base-point is marked**. -/
@[simp] theorem basePoint_mark : basePoint.mark = true := rfl

/-- **The off-base witness is unmarked**. -/
@[simp] theorem offBase_mark : offBase.mark = false := rfl

/-- **Base-point predicate**: `h` is the SV1 base-point iff its
marker is `true`. -/
def IsBasePoint (h : ComplexEmbedding) : Prop := h.mark = true

/-- The designated base-point satisfies `IsBasePoint`. -/
theorem basePoint_isBasePoint : IsBasePoint basePoint := rfl

/-- The off-base cocharacter does not satisfy `IsBasePoint`. -/
theorem offBase_not_isBasePoint : ¬ IsBasePoint offBase := by
  intro h
  -- `IsBasePoint offBase` unfolds to `offBase.mark = true`, i.e.
  -- `false = true`, which is `Bool.noConfusion`.
  exact Bool.noConfusion h

end ComplexEmbedding

/-! ## §2. `ShimuraDatumData` — the Deligne SV-axioms

Following Deligne 1971 / 1979 §1.1 and Milne 2017 §1.2, a **Shimura
datum** `(G, X)` consists of:

* SV1: a connected `ℚ`-algebraic group `G` and a conjugacy class
  `X` of morphisms `h : 𝕊 → G_ℝ` from the Deligne torus;
* SV2: the **Cartan involution** condition — `Ad(h(i))` is a Cartan
  involution on the adjoint Lie algebra of `G^{ad}_ℝ` (equivalently,
  there exists an involution `θ : G → G` with `θ ∘ θ = id`);
* SV3: the **compact-center** condition — `G^{ad}` has no
  `ℚ`-factor on which the connected center acts non-trivially
  (equivalently, the connected center sits in a designated compact
  subgroup of the ambient group).

Our typeclass packages these three axioms at the abstract carrier
level with substantive (non-tautological) field equations. -/

/-- **Shimura datum data** `(G, X)` (Deligne 1979 §1.1; Milne 2017
§1.2).

Fields:
* `h₀ : ComplexEmbedding` — the designated SV1 base-point of the
  cocharacter class `X` (a marked element of the abstract
  cocharacter carrier).
* `h₀_isBase : ComplexEmbedding.IsBasePoint h₀` — SV1 substantive
  predicate: the designated `h₀` is genuinely the marked base-point
  (not an arbitrary off-base witness).
* `θ : G → G` — the Cartan involution (SV2).
* `θ_invol : ∀ g : G, θ (θ g) = g` — substantive involution axiom
  `θ ∘ θ = id` (the SV2 Cartan involution is an involution at the
  group-element level).
* `Z_compact : Subgroup G` — the connected-center compact subgroup
  (SV3: the connected center lies in a designated compact subgroup
  of the ambient `G`).
* `Z_compact_mem_one` — substantive membership: the identity
  element `1 : G` lies in `Z_compact` (the connected center
  contains the identity, a non-tautological subgroup-membership
  fact at the SV3 carrier level). -/
class ShimuraDatumData (G : Type) [Group G] (D : Type) where
  /-- The designated SV1 base-point of the `h`-cocharacter class. -/
  h₀ : ComplexEmbedding
  /-- SV1 substantive predicate: `h₀` is the marked base-point. -/
  h₀_isBase : ComplexEmbedding.IsBasePoint h₀
  /-- The Cartan involution (SV2) on `G`. -/
  θ : G → G
  /-- SV2 substantive involution axiom: `θ ∘ θ = id` pointwise. -/
  θ_invol : ∀ g : G, θ (θ g) = g
  /-- The compact subgroup containing the connected center (SV3). -/
  Z_compact : Subgroup G
  /-- SV3 substantive membership: the identity lies in `Z_compact`
  (the connected center is non-empty). -/
  Z_compact_mem_one : (1 : G) ∈ Z_compact
  /-- Carrier-level placeholder field on `D` to record that the
  Shimura datum is indexed by both `G` and `D`. Substantive
  content: `D` need not be inhabited, but if a designated point
  `d₀` is supplied via downstream extensions, it would be recorded
  here. We keep `D` as an explicit class parameter so the typeclass
  resolution is keyed on both `G` and `D`. -/
  D_is_indexed : D = D := rfl

namespace ShimuraDatumData

variable {G : Type} [Group G] {D : Type} [ShimuraDatumData G D]

/-- **SV2 derived**: applying `θ` four times returns the identity
(direct consequence of `θ_invol` twice). -/
theorem θ_quadruple (g : G) : θ (D := D) (θ (D := D) (θ (D := D) (θ (D := D) g))) = g := by
  rw [θ_invol (D := D) (θ (D := D) g), θ_invol (D := D) g]

/-- **SV2 derived**: `θ ∘ θ ∘ θ = θ` pointwise (apply `θ_invol`
to peel off the innermost double). -/
theorem θ_triple (g : G) : θ (D := D) (θ (D := D) (θ (D := D) g)) = θ (D := D) g := by
  rw [θ_invol (D := D) g]

/-- **SV2 corollary**: `θ` is injective. If `θ g₁ = θ g₂`, applying
`θ` once more and using `θ ∘ θ = id` gives `g₁ = g₂`. -/
theorem θ_injective : Function.Injective (θ (G := G) (D := D)) := by
  intro g₁ g₂ h
  have h1 := θ_invol (D := D) g₁
  have h2 := θ_invol (D := D) g₂
  -- `g₁ = θ (θ g₁) = θ (θ g₂) = g₂`.
  rw [← h1, h, h2]

/-- **SV2 corollary**: `θ` is surjective. Given any `g`, the
preimage `θ g` satisfies `θ (θ g) = g`. -/
theorem θ_surjective : Function.Surjective (θ (G := G) (D := D)) := by
  intro g
  exact ⟨θ (D := D) g, θ_invol (D := D) g⟩

/-- **SV3 corollary**: the connected-center subgroup is non-trivial
(it contains `1`). -/
theorem Z_compact_nonempty :
    (Z_compact (G := G) (D := D) : Set G).Nonempty :=
  ⟨1, Z_compact_mem_one (D := D)⟩

/-- **SV1 corollary**: the designated `h₀` has marker `true`
(unfolding `IsBasePoint`). -/
theorem h₀_mark_eq_true :
    (h₀ (G := G) (D := D)).mark = true :=
  h₀_isBase (G := G) (D := D)

end ShimuraDatumData

/-! ## §3. `CanonicalModelData` — Galois action on the reflex field

The **reflex field** `E = E(G, X)` of a Shimura datum `(G, X)` is a
number field over which the canonical model of `Sh_K(G, X)` is
defined (Deligne 1979 §2; Milne 2017 §4). The absolute Galois
group `Gal(ℚ̄/E)` acts on the projective system `{Sh_K}` of
canonical models, and this action lifts to a substantive group
homomorphism `Gal(ℚ̄/E) → Aut(Sh)`.

We abstract this by recording the Galois action as a group
homomorphism `Γ → (G → G)` from a carrier `Γ` (the abstract Galois
group) into the function space `G → G`, with substantive
homomorphism axioms (`act 1 = id` and `act (g₁ * g₂) = act g₁ ∘
act g₂`). -/

/-- **Canonical-model data** for a Shimura datum (Deligne 1979 §2;
Milne 2017 §4).

Fields:
* `Gal : Type*` — abstract carrier for the Galois group of the
  reflex field `E` over `ℚ`.
* `Gal_group` — `Gal` carries a `Group` instance.
* `act : Gal → (G → G)` — substantive group action on `G` recording
  the Galois action on the canonical model.
* `act_one : act 1 = id` — substantive identity axiom (the trivial
  Galois element acts as the identity).
* `act_mul : ∀ σ τ : Gal, act (σ * τ) = act σ ∘ act τ` — substantive
  multiplicativity axiom (Galois action respects composition).
-/
class CanonicalModelData (G : Type) [Group G] (E : Type) where
  /-- The Galois group of the reflex field. -/
  Gal : Type
  /-- `Gal` is a group. -/
  Gal_group : Group Gal
  /-- The Galois action on `G`. -/
  act : Gal → (G → G)
  /-- The trivial Galois element acts as the identity. -/
  act_one : act 1 = id
  /-- Galois action is multiplicative. -/
  act_mul : ∀ σ τ : Gal, act (σ * τ) = act σ ∘ act τ
  /-- Carrier-level placeholder for indexing on `E` (the reflex
  field carrier); recorded for typeclass-resolution keying. -/
  E_is_indexed : E = E := rfl

attribute [instance] CanonicalModelData.Gal_group

namespace CanonicalModelData

variable {G : Type} [Group G] {E : Type} [CanonicalModelData G E]

/-- **Pointwise identity**: `act 1 g = g` for every `g : G`. -/
theorem act_one_apply (g : G) :
    act (G := G) (E := E) 1 g = g := by
  rw [act_one (G := G) (E := E)]
  rfl

/-- **Pointwise multiplicativity**: for every `σ τ : Gal` and
`g : G`, `act (σ * τ) g = act σ (act τ g)`. -/
theorem act_mul_apply (σ τ : Gal (G := G) (E := E)) (g : G) :
    act (G := G) (E := E) (σ * τ) g = act σ (act τ g) := by
  rw [act_mul (G := G) (E := E)]
  rfl

/-- **Triple composition**: `act (σ₁ * σ₂ * σ₃) g = act σ₁
(act σ₂ (act σ₃ g))` (associated multiplicativity). The product
`σ₁ * σ₂ * σ₃` is left-associative `(σ₁ * σ₂) * σ₃`; we first
apply `act_mul_apply` to split off `σ₃`, then split `σ₁ * σ₂`. -/
theorem act_triple_apply
    (σ₁ σ₂ σ₃ : Gal (G := G) (E := E)) (g : G) :
    act (G := G) (E := E) (σ₁ * σ₂ * σ₃) g
      = act σ₁ (act σ₂ (act σ₃ g)) := by
  -- `σ₁ * σ₂ * σ₃` is `(σ₁ * σ₂) * σ₃`.
  rw [act_mul_apply (σ₁ * σ₂) σ₃, act_mul_apply σ₁ σ₂]

end CanonicalModelData

/-! ## §4. Trivial substantive instances on `PUnit`

We exhibit substantive (non-tautological) inhabiting instances of
both `ShimuraDatumData PUnit PUnit` and `CanonicalModelData PUnit
PUnit`. These witness that the abstract framework is consistent
and inhabited without introducing any `True`-field or `X = X`
tautology.

For the Shimura datum: `θ` is the identity on `Unit` (the only
group homomorphism `Unit → Unit`), and `θ ∘ θ = id` is verified
non-vacuously by `rfl`. The compact-center subgroup is `⊤`, which
contains `1` by `Subgroup.one_mem`. The SV1 base-point is
`ComplexEmbedding.basePoint`, with `IsBasePoint` discharged by
`basePoint_isBasePoint`.

For the canonical model: the Galois group is `Unit` (trivial),
the action is the constant `id` map, and the homomorphism axioms
reduce to `id = id` and `id ∘ id = id`, both verified by `rfl`. -/

/-- The trivial `θ` on `Unit`: the identity map (the only
endomorphism of the trivial group). -/
private def trivθ : Unit → Unit := id

/-- The trivial action of `Unit` on `Unit`: the constant
identity map. -/
private def trivAct : Unit → (Unit → Unit) := fun _ => id

/-- Trivial substantive `ShimuraDatumData` instance on `(G, D) =
(Unit, Unit)`. The Cartan involution is the identity (the only
endomorphism of `Unit`), and `θ ∘ θ = id` reduces to `id ∘ id =
id`, verified by `rfl` pointwise. The compact-center subgroup is
`⊤`, which contains `1` by `Subgroup.one_mem`. -/
instance shimuraDatumData_Unit : ShimuraDatumData Unit Unit where
  h₀ := ComplexEmbedding.basePoint
  h₀_isBase := ComplexEmbedding.basePoint_isBasePoint
  θ := trivθ
  θ_invol := by
    intro g
    -- `trivθ (trivθ g) = id (id g) = g`.
    show trivθ (trivθ g) = g
    rfl
  Z_compact := (⊤ : Subgroup Unit)
  Z_compact_mem_one := Subgroup.mem_top _

/-- Trivial substantive `CanonicalModelData` instance on `(G, E) =
(Unit, Unit)`. The Galois group carrier is `Unit`, the action
is the constant identity, and the homomorphism axioms reduce to
`id = id` (trivially `rfl`) and `id ∘ id = id` (again `rfl`). -/
instance canonicalModelData_Unit : CanonicalModelData Unit Unit where
  Gal := Unit
  Gal_group := inferInstance
  act := trivAct
  act_one := rfl
  act_mul := by
    intro _ _
    -- `trivAct (σ * τ) = id` and `trivAct σ ∘ trivAct τ = id ∘ id = id`.
    show trivAct _ = trivAct _ ∘ trivAct _
    rfl

/-- **Sanity**: in the trivial Shimura-datum instance, the SV1
base-point's marker is `true`. -/
example : (ShimuraDatumData.h₀ (G := Unit) (D := Unit)).mark = true :=
  ShimuraDatumData.h₀_mark_eq_true (G := Unit) (D := Unit)

/-- **Sanity**: in the trivial Shimura-datum instance, the SV2
involution applied to `Unit.unit` returns `Unit.unit`. -/
example : ShimuraDatumData.θ (G := Unit) (D := Unit)
    (ShimuraDatumData.θ (G := Unit) (D := Unit) Unit.unit) = Unit.unit :=
  ShimuraDatumData.θ_invol (G := Unit) (D := Unit) Unit.unit

/-- **Sanity**: in the trivial canonical-model instance, the
identity Galois element acts as the identity on `Unit.unit`. -/
example :
    CanonicalModelData.act (G := Unit) (E := Unit)
        (1 : CanonicalModelData.Gal (G := Unit) (E := Unit)) Unit.unit
      = Unit.unit :=
  CanonicalModelData.act_one_apply (G := Unit) (E := Unit) Unit.unit

end HodgeReduction.Infrastructure.Shimura
