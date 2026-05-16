/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Abelian varieties — abstract Hodge-theoretic data and group-law data

An **abelian variety** `A` over a field `k` is a smooth projective
group variety over `k`. Its rational cohomology `H^*(A; ℚ)` is
`⋀^* H^1(A; ℚ)` (the exterior algebra on `H^1`), and each `H^{2p}(A)`
carries a Hodge structure of weight `2p`.

For our Mumford–Tate-reduction application, the relevant data is:

* `dim` : the complex dimension `dim_ℂ A = g`.
* `H1` : the rank-`2g` lattice `H^1(A; ℚ)` (with weight-1 Hodge structure).

From this, all `H^p(A; ℚ) = ⋀^p H^1(A; ℚ)` are determined.

We abstract the **carrier-level data** as a typeclass, just enough
to talk about the Hodge structure on `H^1`.

## Main definitions

* `AbelianVarietyHodgeData V` : the legacy typeclass providing the
  H^1 Hodge structure of weight 1 on `V = H^1(A; ℚ)` (kept for
  downstream V_56 / Mumford–Tate consumers).

* `AbelianVarietyData A` : abstract carrier-plus-dimension data
  for an abelian variety, with a designated `H^1` ℚ-module of
  ℚ-dimension `2 · dim` (Mumford 1970 Cor. 2 of §13; Birkenhake–
  Lange Lemma 1.1.5).

* `GroupStructureData A` : abelian-variety group law (Mumford 1970
  Thm 2 of §1; Birkenhake–Lange Thm 1.1.7 — the rigidity theorem
  forces the group law on a complete variety to be commutative).

* `IsogenyData A B` : a surjective group homomorphism with finite
  kernel between abelian varieties (Mumford 1970 §7; Birkenhake–
  Lange Def 1.2.6).

## References

* Mumford, D. *Abelian Varieties*, Tata Inst./Oxford Univ. Press,
  1970, Ch. I-II.
* Birkenhake, C. and Lange, H. *Complex Abelian Varieties*, 2nd ed.,
  Grundlehren **302**, Springer, 2004, Ch. 1-2.
* Milne, J. S. *Abelian Varieties* (rev. 2008), §I.1-I.7.

## Tags

abelian variety, Hodge structure, exterior algebra, period domain,
group law, isogeny, rigidity theorem
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-! ## Legacy Hodge-only datum (used by V_56 / Mumford–Tate downstream) -/

/-- The **Hodge data of an abelian variety** at the H^1 level:
`V = H^1(A; ℚ)` carries a polarised Hodge structure of weight 1.

The decomposition `V_ℂ = V^{1,0} ⊕ V^{0,1}` is the standard
"tangent-cotangent" splitting; both pieces have complex dimension `g`
(where `g = dim_ℂ A`). -/
class AbelianVarietyHodgeData where
  /-- The complex dimension of the abelian variety. -/
  g : ℕ
  /-- The polarised Hodge structure of weight 1 on `H^1`. -/
  hodgeOnH1 : HodgeReduction.Infrastructure.HodgeStructure.PolarisedHodgeStructure V 1

namespace AbelianVarietyHodgeData

variable {V} [AbelianVarietyHodgeData V]

/-- The dimension of the abelian variety as a complex variety. -/
abbrev complexDim : ℕ := g (V := V)

end AbelianVarietyHodgeData

/-! ## `AbelianVarietyData` — carrier + H^1 + substantive dim equation -/

/-- **Abelian variety data**, parameterised by an abstract carrier
`A` modelling the variety itself. Fields:

* `dim` — the complex dimension `g = dim_ℂ A`.
* `H1` — the ℚ-module `H^1(A; ℚ)` (a `2g`-dim ℚ-vector space).
* `H1_addCommGroup`, `H1_module` — its ambient algebraic structure.
* `H1_rank_eq` — the substantive ℚ-dimension equation
  `dim_ℚ H^1(A; ℚ) = 2 · g` (Mumford 1970 Cor. 2 of §13;
  Birkenhake–Lange Lemma 1.1.5: `H^1(A; ℤ) ≅ ℤ^{2g}`, hence after
  `⊗ ℚ` we obtain `H^1(A; ℚ) ≅ ℚ^{2g}`).

The `H1` field is `Type` (not `Type*`) so that the typeclass lives in
the same universe-degenerate world as the other infrastructure
classes. -/
class AbelianVarietyData (A : Type*) where
  /-- The complex dimension `g = dim_ℂ A`. -/
  dim : ℕ
  /-- The ℚ-vector space `H^1(A; ℚ)`. -/
  H1 : Type
  /-- Additive group structure on `H1`. -/
  H1_addCommGroup : AddCommGroup H1
  /-- `ℚ`-module structure on `H1`. -/
  H1_module : @Module ℚ H1 _ H1_addCommGroup.toAddCommMonoid
  /-- **Substantive ℚ-dimension equation**: `dim_ℚ H^1(A; ℚ) = 2 · g`.
  (Mumford 1970 Cor. 2 of §13; Birkenhake–Lange Lemma 1.1.5.) -/
  H1_rank_eq :
    @Module.finrank ℚ H1 _ H1_addCommGroup.toAddCommMonoid H1_module = 2 * dim

attribute [instance] AbelianVarietyData.H1_addCommGroup
attribute [instance] AbelianVarietyData.H1_module

namespace AbelianVarietyData

variable {A : Type*} [AbelianVarietyData A]

/-- The H^1 ℚ-rank `2g` is **even**: a direct corollary of the
substantive `H1_rank_eq` axiom. -/
theorem H1_rank_even : 2 ∣ Module.finrank ℚ (H1 A) := by
  rw [H1_rank_eq]
  exact ⟨dim (A := A), rfl⟩

/-- The ℚ-rank of `H^1(A; ℚ)` equals twice the complex dimension —
restated as an equation in `ℕ` for ergonomic rewriting. -/
theorem H1_rank_eq_two_g :
    Module.finrank ℚ (H1 A) = 2 * dim (A := A) :=
  H1_rank_eq

/-- **Dimension monotonicity**: a positive-dimensional abelian variety
has a positive-rank `H^1`. The contrapositive of "rank-`0` ⇒ trivial
abelian variety". -/
theorem H1_rank_pos_of_dim_pos (hdim : 0 < dim (A := A)) :
    0 < Module.finrank ℚ (H1 A) := by
  rw [H1_rank_eq]
  omega

end AbelianVarietyData

/-! ## `GroupStructureData` — the abelian variety group law -/

/-- **Group-structure data** on the carrier `A` of an abelian variety:
a substantive binary operation `add : A → A → A` together with the
group axioms (associativity, commutativity, identity, inverses).

For a complete connected algebraic group the *rigidity theorem*
(Mumford 1970 Thm 2 of §1; Birkenhake–Lange Thm 1.1.7) forces the
group law to be commutative — hence the name *abelian* variety.

We package the data with named fields rather than reusing Mathlib's
`AddCommGroup` directly, because the carrier `A` is an *abstract*
geometric type and the algebraic group law is one specific layer of
structure on top of it. -/
class GroupStructureData (A : Type*) where
  /-- The abelian-variety group law `add : A → A → A`. -/
  add : A → A → A
  /-- The identity element. -/
  zero : A
  /-- The inversion map. -/
  neg : A → A
  /-- **Commutativity** of the group law (rigidity theorem; Mumford
  1970 Thm 2 of §1). -/
  add_comm : ∀ a b : A, add a b = add b a
  /-- **Associativity** of the group law. -/
  add_assoc : ∀ a b c : A, add (add a b) c = add a (add b c)
  /-- **Left identity** axiom: `0 + a = a`. -/
  zero_add : ∀ a : A, add zero a = a
  /-- **Right identity** axiom: `a + 0 = a` (derivable from `zero_add`
  + `add_comm`, but recorded for ergonomics). -/
  add_zero : ∀ a : A, add a zero = a
  /-- **Left inverse** axiom: `(-a) + a = 0`. -/
  neg_add : ∀ a : A, add (neg a) a = zero

namespace GroupStructureData

variable {A : Type*} [GroupStructureData A]

/-- **Right inverse** from the left inverse + commutativity. -/
theorem add_neg (a : A) : add a (neg a) = zero := by
  rw [add_comm]; exact neg_add a

/-- **Uniqueness of identity**: if `e + a = a` for some `a`, then
`e = 0`. (Cancel by the inverse of `a`.) -/
theorem zero_unique (e : A) (a : A) (he : add e a = a) :
    e = zero := by
  have h1 : add (add e a) (neg a) = add a (neg a) := by rw [he]
  rw [add_assoc, add_neg, add_zero] at h1
  exact h1

/-- **Uniqueness of inverse**: if `a + b = 0` then `b = -a`. -/
theorem neg_unique (a b : A) (h : add a b = zero) :
    b = neg a := by
  have h1 : add (neg a) (add a b) = add (neg a) zero := by rw [h]
  rw [← add_assoc, neg_add, zero_add, add_zero] at h1
  exact h1

/-- **Double negation**: `-(-a) = a`. -/
theorem neg_neg (a : A) : neg (neg a) = a := by
  symm
  exact neg_unique (neg a) a (neg_add a)

/-- **Negation of zero**: `-0 = 0`. -/
theorem neg_zero : neg (zero : A) = zero := by
  symm
  exact neg_unique zero zero (add_zero zero)

end GroupStructureData

/-! ## `IsogenyData` — surjective group hom with finite kernel -/

/-- **Isogeny data** from an abelian variety `A` to an abelian variety
`B`: a substantive map `φ : A → B` that is

* a group homomorphism (compatible with `add` and `zero` of
  `GroupStructureData`);
* **surjective** (`∀ b, ∃ a, φ a = b`);
* **finite-kernel** — encoded here at its substantive cohomological
  shadow: the induced ℚ-linear pullback `pullback : H^1(B; ℚ) →ₗ[ℚ]
  H^1(A; ℚ)` is **injective**.

For a finite-kernel surjective group hom of abelian varieties, the
induced `H^1`-pullback is well-known to be injective (Mumford 1970
Cor. 1 of §10: the kernel of `φ^* : H^1(B) → H^1(A)` is dual to the
identity component of `ker φ`, which is `0` precisely when `φ` is an
isogeny). This is the substantive ℚ-linear-algebra shadow we retain.

References: Mumford 1970 §7 (definition of isogeny) and §10 (induced
maps on cohomology); Birkenhake–Lange Def 1.2.6 (isogeny) and
Prop 1.2.6 (cohomological injectivity). -/
class IsogenyData (A B : Type*) [AbelianVarietyData A] [AbelianVarietyData B]
    [GroupStructureData A] [GroupStructureData B] where
  /-- The underlying map `φ : A → B`. -/
  phi : A → B
  /-- **Group-hom additivity**: `φ (a₁ + a₂) = φ a₁ + φ a₂`. -/
  phi_add : ∀ a₁ a₂ : A, phi (GroupStructureData.add a₁ a₂) =
    GroupStructureData.add (phi a₁) (phi a₂)
  /-- **Group-hom zero-preservation**: `φ 0 = 0`. -/
  phi_zero : phi (GroupStructureData.zero (A := A)) =
    GroupStructureData.zero (A := B)
  /-- **Surjectivity** of `φ`. -/
  phi_surj : ∀ b : B, ∃ a : A, phi a = b
  /-- The induced ℚ-linear pullback on `H^1`:
  `φ^* : H^1(B; ℚ) →ₗ[ℚ] H^1(A; ℚ)`. -/
  pullback : AbelianVarietyData.H1 B →ₗ[ℚ] AbelianVarietyData.H1 A
  /-- **Finite kernel ⇒ pullback injective**: the substantive ℚ-linear
  shadow of the finite-kernel condition (Mumford 1970 Cor. 1 of §10). -/
  pullback_inj :
    ∀ v : AbelianVarietyData.H1 B, pullback v = 0 → v = 0

namespace IsogenyData

variable {A B : Type*}
  [AbelianVarietyData A] [AbelianVarietyData B]
  [GroupStructureData A] [GroupStructureData B] [IsogenyData A B]

/-- **Negation-preservation** of an isogeny: `φ (-a) = -φ a`. Derived
from `phi_add` + `phi_zero` + `add_neg`. -/
theorem phi_neg (a : A) :
    phi (A := A) (B := B) (GroupStructureData.neg a) =
      GroupStructureData.neg (phi (A := A) (B := B) a) := by
  -- Apply `phi` to `a + (-a) = 0` (which uses `add_neg`).
  have h1 : phi (A := A) (B := B)
      (GroupStructureData.add a (GroupStructureData.neg a)) =
        phi (A := A) (B := B) (GroupStructureData.zero (A := A)) := by
    rw [GroupStructureData.add_neg]
  rw [phi_add, phi_zero] at h1
  exact GroupStructureData.neg_unique _ _ h1

/-- **Pullback separates points**: if the cohomological pullback maps
two classes to the same image, they were equal. (Direct corollary of
`pullback_inj`.) -/
theorem pullback_left_cancel
    (v w : AbelianVarietyData.H1 B)
    (h : pullback (A := A) (B := B) v =
         pullback (A := A) (B := B) w) : v = w := by
  have hsub : pullback (A := A) (B := B) (v - w) = 0 := by
    rw [map_sub, h, sub_self]
  have hzero : v - w = 0 := pullback_inj (v - w) hsub
  exact sub_eq_zero.mp hzero

end IsogenyData

/-! ## Trivial inhabiting instances on `A := Unit`

We exhibit a `g = 0` "abelian variety" (a point) as a trivial witness
that the axiom packages are consistent. `H^1` of a point is `0`-
dimensional, so we take `H1 := PUnit` with the unique
`AddCommGroup` / `Module ℚ` structures. -/

namespace Trivial

/-- The trivial AV carrier (the point variety, `g = 0`). -/
def AV_point : Type := Unit

/-- The trivial `H^1` carrier of a point. `PUnit` has the unique
`AddCommGroup` and `Module ℚ` structures, and its ℚ-rank is `0 = 2·0`. -/
def H1_point : Type := PUnit

instance : AddCommGroup H1_point := inferInstanceAs (AddCommGroup PUnit)
instance : Module ℚ H1_point := inferInstanceAs (Module ℚ PUnit)

/-- The ℚ-rank of `PUnit` is `0`. -/
theorem finrank_PUnit : Module.finrank ℚ H1_point = 0 := by
  show Module.finrank ℚ PUnit = 0
  exact Module.finrank_eq_zero_of_rank_eq_zero (rank_punit ℚ)

/-- Trivial `AbelianVarietyData` instance on the point. -/
instance abelianVariety_point : AbelianVarietyData AV_point where
  dim := 0
  H1 := H1_point
  H1_addCommGroup := inferInstance
  H1_module := inferInstance
  H1_rank_eq := by
    show Module.finrank ℚ H1_point = 2 * 0
    rw [finrank_PUnit]

/-- Trivial `GroupStructureData` instance on the point. -/
instance groupStructure_point : GroupStructureData AV_point where
  add := fun _ _ => ()
  zero := ()
  neg := fun _ => ()
  add_comm := by intros; rfl
  add_assoc := by intros; rfl
  zero_add := by intro a; cases a; rfl
  add_zero := by intro a; cases a; rfl
  neg_add := by intros; rfl

/-- The pullback map `H^1(point) → H^1(point)` for the identity
isogeny on the point: the unique ℚ-linear map on `PUnit`. -/
def pullbackPUnit : H1_point →ₗ[ℚ] H1_point where
  toFun _ := ()
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Trivial `IsogenyData` instance: the identity isogeny on the
point variety. `phi` is `id`; surjectivity, additivity, and
zero-preservation are all immediate; pullback injectivity is vacuous
(all elements of `PUnit` are `0`). -/
instance isogeny_id_point : IsogenyData AV_point AV_point where
  phi := id
  phi_add := by intros; rfl
  phi_zero := rfl
  phi_surj := fun b => ⟨b, rfl⟩
  pullback := pullbackPUnit
  pullback_inj := by
    intro v _
    cases v; rfl

/-- **Sanity-check**: in the trivial instance, `dim = 0`. -/
example : AbelianVarietyData.dim (A := AV_point) = 0 := rfl

/-- **Sanity-check**: in the trivial instance, the H^1 rank is `0 = 2·0`. -/
example : Module.finrank ℚ (AbelianVarietyData.H1 AV_point) = 2 * 0 :=
  AbelianVarietyData.H1_rank_eq

end Trivial

end HodgeReduction.Infrastructure.AbelianVariety
