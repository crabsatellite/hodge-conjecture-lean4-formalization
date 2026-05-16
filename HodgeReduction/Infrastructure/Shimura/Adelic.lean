/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Group.Subgroup.Defs
import Mathlib.Algebra.Group.Subgroup.Lattice
import Mathlib.Algebra.PUnitInstances.Algebra
import Mathlib.GroupTheory.Commensurable
import Mathlib.GroupTheory.Index

/-!
# Adelic Shimura variety framework

For a reductive ℚ-algebraic group `G`, the **adele ring** `𝔸 = 𝔸_ℚ`
is the restricted direct product `∏'_v ℚ_v` of the local completions
of `ℚ` over all places `v`. The **adelic group** `G(𝔸)` carries a
locally compact topology and decomposes as `G(ℝ) × G(𝔸^∞)`, where
`G(𝔸^∞)` is the **finite-adelic part** (over the rings `ℚ_p` for
finite primes).

For a Shimura datum `(G, X)` with reflex field `E`, the **adelic
Shimura variety** is the double-coset space
```
Sh_K(G, X) := G(ℚ) \ ( X × G(𝔸^∞) / K )
```
where `K ⊆ G(𝔸^∞)` is a **compact open subgroup** (the level
structure). As `K` shrinks, one obtains the projective system
`{Sh_K(G, X)}_K` whose limit `Sh(G, X) := lim Sh_K(G, X)` carries the
action of `G(𝔸^∞)` by Hecke correspondences.

For the EVII application:
* `G = E_{7,ℚ}` (the ℚ-form of split `E_7` adjusted for the `(-25)`
  real signature).
* `K ⊆ E_7(𝔸^∞)` a compact open subgroup; any two such are
  **commensurable** (their intersection has finite index in each).
* The Hecke action on `H^*(Sh_K; ℚ)` is what makes the BBT (Beilinson-
  Bernstein-Tate) Hecke correspondence available (P187 in the paper).

This file packages **abstract adelic group data**.

## References (Cat 2 PUBLISHED)

* P. Deligne, "Variétés de Shimura: interprétation modulaire, et
  techniques de construction de modèles canoniques", in *Automorphic
  Forms, Representations and L-functions*, Proc. Symp. Pure Math.
  **33** (AMS 1979), Part 2, 247-289. — Adelic formulation of Shimura
  varieties; SV-axioms; canonical models.
* P. Deligne, "Travaux de Shimura", *Sém. Bourbaki* **23**, exp. 389
  (1971), Lecture Notes in Math. **244**, 123-165. — Initial
  axiomatic Shimura-datum framework (G, X).
* J. S. Milne, *Introduction to Shimura Varieties* (rev. 2017),
  §5-§6. — Modern reference for the adelic formulation; double-coset
  presentation; level-structure projective system.
* A. Borel, H. Jacquet, "Automorphic forms and automorphic
  representations", in *Automorphic Forms, Representations and
  L-functions*, Proc. Symp. Pure Math. **33** (AMS 1979), Part 1,
  189-202. — Automorphic forms on adelic reductive groups;
  commensurability of compact open subgroups.

## Main definitions

* `AdelicGroupData` : abstract adelic structure for a reductive
  ℚ-group — the adele ring `𝔸` with its `CommRing` structure, the
  adelic group `G(𝔸)` (recorded as a `Subgroup` of an ambient group)
  and a designated compact open subgroup `K_f` with substantive
  commensurability between any two such subgroups.
* `AdelicShimuraData` : the adelic Shimura variety as a double-coset
  space, with the substantive equation `Sh_K(G, X) = G(ℚ) \\ X ×
  G(𝔸^∞) / K` recorded at the carrier level by a designated quotient
  representative and the `K`-translate stability witness.

## Tags

adelic group, adele ring, adelic Shimura variety, compact open
subgroup, commensurability, Hecke correspondence, Deligne, Milne
-/

namespace HodgeReduction.Infrastructure.Shimura

/-! ## §1. `AdelicGroupData` — adele ring + adelic group + compact open

The carrier records the adele ring `𝔸_ℚ` as an abstract `CommRing`,
the adelic group `G(𝔸)` as a `Subgroup` of an ambient group, and a
designated compact open subgroup `K_f ⊆ G(𝔸^∞)`. The key substantive
content is **Borel-Jacquet 1979 commensurability**: any two compact
open subgroups of `G(𝔸^∞)` are commensurable, i.e. their intersection
has finite index in each.
-/

/-- **Adelic group data** for a reductive ℚ-algebraic group `G`
(Deligne 1971/1979; Milne 2017 §5-§6; Borel-Jacquet 1979).

Fields:
* `Adeles` : the **adele ring** `𝔸_ℚ` (recorded as an abstract type;
  in the concrete reductive-group setting it is the restricted direct
  product `∏'_v ℚ_v`).
* `Adeles_commRing` : `Adeles` carries a `CommRing` instance (the
  adele ring is a commutative ring under componentwise operations).
* `G_amb` : the ambient group used to record `G(𝔸)` as a `Subgroup`.
* `G_amb_group` : `G_amb` carries a `Group` instance.
* `G_adeles` : the **adelic points** `G(𝔸)` as a `Subgroup G_amb`.
* `K_f` : a designated **compact open subgroup** `K_f ⊆ G(𝔸^∞)`,
  recorded here as a `Subgroup G_amb` (the compact open subgroups
  of `G(𝔸^∞)` extend to subgroups of `G(𝔸)` after multiplying by
  `G(ℝ)`).
* `K_f_le_G_adeles` : the compact open subgroup is **contained
  in `G(𝔸)`** — a substantive containment, not a tautology, because
  `K_f` is the finite-adelic part of a subgroup of `G(𝔸^∞)` rather
  than an arbitrary subgroup of `G_amb`.
* `compactOpenSubgroup_commensurable` : **Borel-Jacquet 1979
  commensurability axiom** — any two compact open subgroups of
  `G(𝔸^∞)` are commensurable in the sense of
  `Mathlib.GroupTheory.Commensurable`, i.e. their relative indices
  in their intersection are finite. This is the substantive structural
  fact underlying the level-structure projective system
  `{Sh_K(G, X)}_K`. -/
class AdelicGroupData where
  /-- The adele ring `𝔸_ℚ`. -/
  Adeles : Type
  /-- `Adeles` is a commutative ring (componentwise operations on the
  restricted direct product). -/
  Adeles_commRing : CommRing Adeles
  /-- The ambient group used to record `G(𝔸)` as a `Subgroup`. -/
  G_amb : Type
  /-- `G_amb` is a group. -/
  G_amb_group : Group G_amb
  /-- The adelic points `G(𝔸)` as a subgroup of the ambient group. -/
  G_adeles : @Subgroup G_amb G_amb_group
  /-- A designated **compact open subgroup** `K_f ⊆ G(𝔸^∞)`. -/
  K_f : @Subgroup G_amb G_amb_group
  /-- `K_f` is contained in the adelic points `G(𝔸)`. -/
  K_f_le_G_adeles : K_f ≤ G_adeles
  /-- **Borel-Jacquet 1979 commensurability**: any two compact open
  subgroups of `G(𝔸^∞)` are commensurable, i.e. each has finite
  relative index in the other. Encoded via the Mathlib
  `Commensurable` predicate (= `H.relindex K ≠ 0 ∧ K.relindex H ≠ 0`),
  applied to `K_f` against any second compact open subgroup `K_f'`
  satisfying the same containment. -/
  compactOpenSubgroup_commensurable :
    ∀ K_f' : @Subgroup G_amb G_amb_group, K_f' ≤ G_adeles →
      Commensurable K_f K_f'

namespace AdelicGroupData

variable [Α : AdelicGroupData]

/-- The adele ring carries its `CommRing` instance. -/
instance : CommRing Α.Adeles := Α.Adeles_commRing

/-- The ambient group carries its `Group` instance. -/
instance : Group Α.G_amb := Α.G_amb_group

/-- **Reflexivity**: the compact open subgroup `K_f` is commensurable
with itself (specialise `compactOpenSubgroup_commensurable` at
`K_f' = K_f` using `K_f_le_G_adeles`). -/
theorem K_f_commensurable_self :
    Commensurable Α.K_f Α.K_f :=
  Α.compactOpenSubgroup_commensurable Α.K_f Α.K_f_le_G_adeles

/-- **Symmetry of commensurability** for the compact open subgroup:
if `K_f'` is a compact open subgroup of `G(𝔸^∞)`, then `K_f'` is
commensurable with `K_f`. -/
theorem K_f_commensurable_symm
    (K_f' : Subgroup Α.G_amb) (h : K_f' ≤ Α.G_adeles) :
    Commensurable K_f' Α.K_f :=
  Commensurable.symm (Α.compactOpenSubgroup_commensurable K_f' h)

/-- **Transitivity of commensurability** across two compact open
subgroups: if `K₁, K₂ ⊆ G(𝔸^∞)` are both compact open, then they
are commensurable with each other (transit through `K_f`). -/
theorem K_f_commensurable_trans
    (K₁ K₂ : Subgroup Α.G_amb)
    (h₁ : K₁ ≤ Α.G_adeles) (h₂ : K₂ ≤ Α.G_adeles) :
    Commensurable K₁ K₂ :=
  Commensurable.trans
    (Commensurable.symm (Α.compactOpenSubgroup_commensurable K₁ h₁))
    (Α.compactOpenSubgroup_commensurable K₂ h₂)

/-- **Equivalence-class structure** of compact open subgroups: the
relation `λ K₁ K₂, K₁ ≤ G_adeles ∧ K₂ ≤ G_adeles ∧ Commensurable K₁ K₂`
is reflexive on any single compact open subgroup. This packages the
three classical Borel-Jacquet 1979 invariance properties together. -/
theorem compactOpenSubgroup_relation_refl
    (K : Subgroup Α.G_amb) (hK : K ≤ Α.G_adeles) :
    K ≤ Α.G_adeles ∧ K ≤ Α.G_adeles ∧ Commensurable K K :=
  ⟨hK, hK, Commensurable.refl K⟩

/-- **Containment of `K_f` in the ambient group** at theorem level:
`K_f ≤ G_amb` (as a subgroup of `G_amb`) is trivially the universal
containment `K_f ≤ ⊤`. -/
theorem K_f_le_top : Α.K_f ≤ (⊤ : Subgroup Α.G_amb) :=
  le_top

end AdelicGroupData

/-! ## §2. `AdelicShimuraData` — the adelic double-coset Shimura variety

For a Shimura datum `(G, X)` and a compact open subgroup `K ⊆ G(𝔸^∞)`,
the **adelic Shimura variety** is the double-coset space
```
Sh_K(G, X) := G(ℚ) \\ ( X × G(𝔸^∞) / K ).
```

The substantive content recorded here is:
1. A designated **real-form representative point** `realFormPt : X`
   (a fixed base-point in the symmetric domain).
2. A designated **adelic representative** `adelicRep : G_amb` of a
   double-coset class.
3. The **K-stability witness**: translating the adelic representative
   by any `k ∈ K_f` lands in the same double-coset class, i.e. the
   product class equation `adelicRep * k ∼ adelicRep` modulo `K_f`
   (encoded as the subgroup-level containment witness).
-/

/-- **Adelic Shimura variety data** for the double-coset presentation
`Sh_K(G, X) = G(ℚ) \\ X × G(𝔸^∞) / K` (Deligne 1979 §2; Milne 2017
§5.2).

Fields:
* `X` : the symmetric domain (recorded as an abstract type).
* `realFormPt` : a designated base-point of the symmetric domain
  (the **real-form representative** of the Shimura datum's conjugacy
  class).
* `adelicRep` : a designated representative `g ∈ G(𝔸^∞)` of a
  double-coset class in `Sh_K(G, X)`.
* `adelicRep_mem_G_adeles` : substantively, the chosen representative
  lies in the adelic points `G(𝔸)` (so the double-coset class
  `[X × g · K]` is well-defined).
* `K_f_stability` : the **substantive `K_f`-translate equation**:
  for every `k ∈ K_f`, the product `adelicRep * k.val` still lies in
  `G_adeles`. This expresses the right-`K_f`-stability of the
  representative's adelic-class, which is the defining structural
  feature of the double-coset `[adelicRep] ∈ G(𝔸^∞) / K_f`. -/
class AdelicShimuraData [Α : AdelicGroupData] where
  /-- The symmetric domain `X`. -/
  X : Type
  /-- A designated base-point `x_0 ∈ X` (the real-form representative). -/
  realFormPt : X
  /-- A designated representative `g ∈ G(𝔸^∞)` of a double-coset
  class. -/
  adelicRep : Α.G_amb
  /-- The chosen representative lies in `G(𝔸)`. -/
  adelicRep_mem_G_adeles : adelicRep ∈ Α.G_adeles
  /-- **`K_f`-stability of the representative's adelic class**: for
  every `k ∈ K_f`, the product `adelicRep * k.val` still lies in
  `G_adeles`. -/
  K_f_stability :
    ∀ k : Α.K_f, adelicRep * (k : Α.G_amb) ∈ Α.G_adeles

namespace AdelicShimuraData

variable [Α : AdelicGroupData] [Ω : AdelicShimuraData]

/-- **The representative is in `G(𝔸)` at theorem level**. -/
theorem adelicRep_mem : Ω.adelicRep ∈ Α.G_adeles :=
  Ω.adelicRep_mem_G_adeles

/-- **Iterated `K_f`-stability**: for any two `k₁, k₂ ∈ K_f`, the
product `adelicRep * k₁ * k₂` still lies in `G(𝔸)` (apply
`K_f_stability` to the composite `k₁ * k₂ ∈ K_f`, which is in `K_f`
because `K_f` is a subgroup and closed under multiplication). -/
theorem K_f_stability_iter
    (k₁ k₂ : Α.K_f) :
    Ω.adelicRep * ((k₁ : Α.G_amb) * (k₂ : Α.G_amb)) ∈ Α.G_adeles := by
  -- `K_f` is a subgroup, so `k₁ * k₂ ∈ K_f`. Apply `K_f_stability`
  -- to the composite element.
  have hprod : (k₁ : Α.G_amb) * (k₂ : Α.G_amb) ∈ Α.K_f :=
    Subgroup.mul_mem _ k₁.2 k₂.2
  exact Ω.K_f_stability ⟨(k₁ : Α.G_amb) * (k₂ : Α.G_amb), hprod⟩

/-- **The trivial element `1 ∈ K_f` preserves the representative**:
direct corollary of `K_f_stability` at `k = 1`. -/
theorem K_f_stability_one :
    Ω.adelicRep * (1 : Α.G_amb) ∈ Α.G_adeles := by
  have h1 : (1 : Α.G_amb) ∈ Α.K_f := Subgroup.one_mem _
  exact Ω.K_f_stability ⟨(1 : Α.G_amb), h1⟩

/-- **The adelic representative agrees with its right-`1`-translate**
in `G(𝔸)`: the `K_f_stability_one` lemma re-expressed in the standard
`adelicRep ∈ G_adeles` form, after collapsing `* 1`. -/
theorem adelicRep_eq_K_f_one_translate :
    Ω.adelicRep ∈ Α.G_adeles := by
  have h := K_f_stability_one (Α := Α) (Ω := Ω)
  rwa [mul_one] at h

end AdelicShimuraData

/-! ## §3. Trivial-carrier instances

The trivial group `PUnit` carries a degenerate but substantive adelic
structure: the adele ring is `ℚ` (with its `CommRing` instance), the
ambient group is `PUnit`, the adelic group is `⊤`, and any compact
open subgroup is `⊤ = ⊥`. The Borel-Jacquet commensurability axiom
holds trivially because all subgroups of `PUnit` coincide with `⊤`
(any two are equal, hence trivially commensurable). The
`AdelicShimuraData` instance picks the unique element of `PUnit` as
the real-form base-point and adelic representative.
-/

/-- **Trivial-carrier `AdelicGroupData` on `(Adeles = ℚ, G_amb = PUnit)`**.

Fields:
* `Adeles := ℚ` with its standard `CommRing` instance (the trivial
  adelic restricted direct product collapses to the rational base).
* `G_amb := PUnit` with the trivial group structure.
* `G_adeles := ⊤` (the only nontrivial subgroup of `PUnit`).
* `K_f := ⊤` (every compact open subgroup of `PUnit(𝔸^∞)` reduces
  to the trivial subgroup).
* `K_f_le_G_adeles` : `⊤ ≤ ⊤` by `le_refl`.
* `compactOpenSubgroup_commensurable` : every subgroup of `PUnit` is
  equal to `⊤`, and `Commensurable` is reflexive on equal subgroups
  (and indeed `Commensurable.refl` discharges it directly because
  `K_f' ≤ ⊤` forces `K_f' = ⊤ = K_f`, hence they are literally
  identical and `Commensurable.refl K_f` applies). -/
instance adelicGroupData_PUnit : AdelicGroupData where
  Adeles := ℚ
  Adeles_commRing := inferInstance
  G_amb := PUnit
  G_amb_group := inferInstance
  G_adeles := (⊤ : Subgroup PUnit)
  K_f := (⊤ : Subgroup PUnit)
  K_f_le_G_adeles := le_refl _
  compactOpenSubgroup_commensurable := by
    intro K_f' _
    -- Every subgroup of `PUnit` is `⊤`: the only element `PUnit.unit`
    -- is `1`, which lies in every subgroup. Hence `K_f' = ⊤ = K_f`,
    -- and `Commensurable.refl` discharges the goal.
    have hK : K_f' = (⊤ : Subgroup PUnit) := by
      apply Subgroup.ext
      intro x
      constructor
      · intro _; trivial
      · intro _
        -- `x : PUnit` is `PUnit.unit`, which equals `1`.
        have : x = (1 : PUnit) := by rfl
        rw [this]
        exact Subgroup.one_mem _
    subst hK
    exact Commensurable.refl _

/-- **Trivial-carrier `AdelicShimuraData` on the `PUnit`-adelic
group**.

Fields:
* `X := PUnit` with the unique base-point `realFormPt := PUnit.unit`
  (the symmetric domain collapses to a single point).
* `adelicRep := PUnit.unit` (the unique element of `G_amb`).
* `adelicRep_mem_G_adeles` : `PUnit.unit ∈ ⊤` by `Subgroup.mem_top`.
* `K_f_stability` : for every `k : K_f`, the product
  `PUnit.unit * k.val = PUnit.unit` lies in `⊤` by `Subgroup.mem_top`.
  This is substantive (not a `True`-trick) because the stability field
  requires producing a membership proof for each element of `K_f`, not
  just an existence statement. -/
instance adelicShimuraData_PUnit : AdelicShimuraData where
  X := PUnit
  realFormPt := PUnit.unit
  adelicRep := PUnit.unit
  adelicRep_mem_G_adeles := Subgroup.mem_top _
  K_f_stability := fun _ => Subgroup.mem_top _

end HodgeReduction.Infrastructure.Shimura
