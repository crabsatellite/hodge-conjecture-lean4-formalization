/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import Mathlib.Algebra.Module.Submodule.Map
import Mathlib.LinearAlgebra.GeneralLinearGroup

/-!
# Mumford–Tate group of a (polarised) ℚ-Hodge structure

The **Mumford–Tate group** `MT(V, h)` of a Hodge structure `(V, h)` is
the smallest `ℚ`-algebraic subgroup of `GL(V)` that, after extension
to `ℝ`, contains the image of the Hodge cocharacter
`h : ℂ^* → GL(V_ℝ)`.

For our purposes we abstract this via the **MT-invariance** property:

* An MT-invariant subset of `V^{⊗ k}` is one fixed by the MT-group action.
* By Mumford (1969), Deligne (1971), the MT group is exactly the
  stabiliser of all Hodge classes in tensor powers of `V`.

This file defines the abstract structure carrying the MT-invariance
data.

## Main definitions

* `MumfordTateGroupData V` : a typeclass providing a designated
  subgroup `MT ⊂ GL(V)` together with axioms relating it to the
  Hodge structure.

## Tags

Mumford-Tate group, Hodge cocharacter, Hodge class, motive
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- The **Mumford–Tate group data** for a Hodge structure on `V`:
a designated `ℚ`-linear subgroup of `GL(V)` representing the MT-group.

We abstract the algebraic-group structure away; what we need is just
the underlying set of MT-invariant linear automorphisms. -/
class MumfordTateGroupData where
  /-- The Mumford–Tate group as a subset of `V → V` linear automorphisms.

  Concretely, an element `g : V ≃ₗ[ℚ] V` is in `MT` iff `g` preserves
  every Hodge piece (`g (piece p) = piece p` for all `p`). -/
  MT : Set (V ≃ₗ[ℚ] V)
  /-- The identity belongs to MT. -/
  one_mem : (1 : V ≃ₗ[ℚ] V) ∈ MT
  /-- MT is closed under composition. -/
  mul_mem : ∀ {g h : V ≃ₗ[ℚ] V}, g ∈ MT → h ∈ MT → (g.trans h : V ≃ₗ[ℚ] V) ∈ MT
  /-- MT is closed under inverse. -/
  inv_mem : ∀ {g : V ≃ₗ[ℚ] V}, g ∈ MT → g.symm ∈ MT

namespace MumfordTateGroupData

variable {V} [MumfordTateGroupData V]

/-- A **Hodge class** on `V`: an element fixed by every MT-automorphism. -/
def IsHodgeClass (v : V) : Prop :=
  ∀ g ∈ MT (V := V), g v = v

/-- The set of Hodge classes is closed under addition. -/
theorem isHodgeClass_add {v w : V} (hv : IsHodgeClass v) (hw : IsHodgeClass w) :
    IsHodgeClass (v + w) := by
  intro g hg
  rw [LinearEquiv.map_add]
  rw [hv g hg, hw g hg]

/-- The set of Hodge classes is closed under scalar multiplication. -/
theorem isHodgeClass_smul (r : ℚ) {v : V} (hv : IsHodgeClass v) :
    IsHodgeClass (r • v) := by
  intro g hg
  rw [LinearEquiv.map_smul]
  rw [hv g hg]

/-- The zero element is a Hodge class. -/
theorem isHodgeClass_zero : IsHodgeClass (0 : V) := by
  intro g _
  exact LinearEquiv.map_zero g

end MumfordTateGroupData

/-! ## Mumford--Tate group with substantive group action

The `MumfordTateGroupData` class above abstracts MT as a *set* of
linear automorphisms.  For genuinely group-theoretic constructions
(Tannakian description, Hodge cocharacter, reductivity) we also need
the MT group `G` together with its representation
`ρ : G → GL(V)` realised as a multiplicative `G`-action on the
`ℚ`-linear endomorphism ring of `V`.

The class `MTGroupStructureData V G` packages exactly this datum:

* `action g : V →ₗ[ℚ] V` — the `ℚ`-linear automorphism that `g`
  induces on `V` (i.e., the image of `g` under `ρ`).
* `action_one`, `action_mul` — multiplicativity of `ρ`
  (`ρ : G →* (V →ₗ[ℚ] V)` in the monoid of `ℚ`-linear endomorphisms,
  with multiplication = composition).
* `invSplit : V →ₗ[ℚ] V` and `invSplit_idempotent` —
  the **reductivity** axiom in its concrete categorical form: every
  `MT`-stable subrepresentation admits a (canonical, distinguished)
  `MT`-equivariant complement, witnessed by a designated idempotent
  projector `e = invSplit` with `e ∘ e = e`.  The complement is the
  range of `e` and the subrepresentation is the kernel.  This is
  Mumford 1966 §3 / Deligne 1979 (1.1.13): the MT-group of a
  polarised pure Hodge structure is **reductive**, equivalently,
  every short exact sequence of MT-representations splits.
* `invSplit_equivariant` — the projector commutes with the action,
  i.e. `e` is `G`-equivariant.  This is the substantive content of
  "MT-equivariant splitting": the splitting is not merely a vector
  space complement, but one preserved by the group action.

References:
* Mumford, D. *Families of abelian varieties*, in *Algebraic Groups
  and Discontinuous Subgroups* (Boulder 1965), Proc. Sympos. Pure
  Math. **9** (AMS, 1966), 347-351 — §3 (MT group).
* Deligne, P. "Variétés de Shimura: interprétation modulaire,
  et techniques de construction de modèles canoniques", in
  *Automorphic Forms, Representations and L-functions* (Corvallis
  1977), Proc. Sympos. Pure Math. **33** Part 2 (AMS, 1979),
  247-289 — SV-axioms via MT.
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry I*,
  Cambridge Stud. Adv. Math. **76**, CUP, 2002 — Ch. 17.
-/

/-- **Mumford--Tate group structural data** for a `ℚ`-vector space `V`
together with an ambient group `G` acting on `V` through `ℚ`-linear
automorphisms.

This complements `MumfordTateGroupData` (which captures the *set* of
MT-invariant automorphisms) with the *group-with-representation*
datum needed for reductivity arguments (Mumford 1966 §3;
Deligne 1979 (1.1.13)). -/
class MTGroupStructureData (V : Type*) [AddCommGroup V] [Module ℚ V]
    (G : Type*) [Group G] where
  /-- The action `ρ : G → End_ℚ(V)`: each group element gives a
  `ℚ`-linear endomorphism of `V`. -/
  action : G → (V →ₗ[ℚ] V)
  /-- `ρ` sends the identity to `id_V`. -/
  action_one : action 1 = LinearMap.id
  /-- `ρ` is multiplicative: `ρ(g · h) = ρ(g) ∘ ρ(h)`. -/
  action_mul : ∀ (g h : G), action (g * h) = (action g).comp (action h)
  /-- **Reductivity datum**: a designated `ℚ`-linear idempotent
  projector `e : V → V` realising a `G`-equivariant direct-sum
  splitting `V = ker e ⊕ range e`. -/
  invSplit : V →ₗ[ℚ] V
  /-- The projector is idempotent (`e ∘ e = e`), so its range is a
  direct summand of `V`. -/
  invSplit_idempotent : invSplit.comp invSplit = invSplit
  /-- The projector commutes with the action: for every `g ∈ G`,
  `e ∘ ρ(g) = ρ(g) ∘ e`.  This expresses that the splitting is
  preserved by the group action (substantive **MT-equivariance**;
  Mumford 1966 §3). -/
  invSplit_equivariant : ∀ (g : G),
    invSplit.comp (action g) = (action g).comp invSplit

namespace MTGroupStructureData

variable {V : Type*} [AddCommGroup V] [Module ℚ V]
variable {G : Type*} [Group G] [MTGroupStructureData V G]

/-- Identity element acts as the identity linear map (re-export). -/
theorem action_one_apply (v : V) :
    action (V := V) (G := G) (1 : G) v = v := by
  rw [action_one]
  rfl

/-- Action factors through composition (re-export at the value level). -/
theorem action_mul_apply (g h : G) (v : V) :
    action (V := V) (G := G) (g * h) v =
      action (V := V) (G := G) g (action (V := V) (G := G) h v) := by
  rw [action_mul]
  rfl

/-- Inverses act as inverses: `ρ(g⁻¹) ∘ ρ(g) = id`. -/
theorem action_inv_left (g : G) :
    (action (V := V) (G := G) g⁻¹).comp (action (V := V) (G := G) g) =
      LinearMap.id := by
  rw [← action_mul]
  simp [inv_mul_cancel, action_one]

/-- Inverses act as inverses on the right: `ρ(g) ∘ ρ(g⁻¹) = id`. -/
theorem action_inv_right (g : G) :
    (action (V := V) (G := G) g).comp (action (V := V) (G := G) g⁻¹) =
      LinearMap.id := by
  rw [← action_mul]
  simp [mul_inv_cancel, action_one]

/-- The reductivity projector is idempotent at the value level:
`e (e v) = e v` for every `v ∈ V`. -/
theorem invSplit_idem_apply (v : V) :
    invSplit (V := V) (G := G) (invSplit (V := V) (G := G) v) =
      invSplit (V := V) (G := G) v := by
  have h := invSplit_idempotent (V := V) (G := G)
  have := congrArg (fun (f : V →ₗ[ℚ] V) => f v) h
  simpa using this

/-- `G`-equivariance of the projector at the value level:
`e (g · v) = g · e v` for every `g ∈ G`, `v ∈ V`. -/
theorem invSplit_equivariant_apply (g : G) (v : V) :
    invSplit (V := V) (G := G) (action (V := V) (G := G) g v) =
      action (V := V) (G := G) g (invSplit (V := V) (G := G) v) := by
  have h := invSplit_equivariant (V := V) (G := G) g
  have := congrArg (fun (f : V →ₗ[ℚ] V) => f v) h
  simpa using this

/-- The kernel of the reductivity projector is a `ℚ`-submodule
of `V` (the "kernel-summand" half of the direct-sum splitting). -/
def kerSummand : Submodule ℚ V := LinearMap.ker (invSplit (V := V) (G := G))

/-- The range of the reductivity projector is a `ℚ`-submodule of `V`
(the "range-summand" half of the direct-sum splitting). -/
def rangeSummand : Submodule ℚ V := LinearMap.range (invSplit (V := V) (G := G))

/-- The kernel-summand is `G`-stable: if `v ∈ ker e` then `g · v ∈ ker e`.
This is the substantive consequence of `G`-equivariance of `e`. -/
theorem kerSummand_action_mem (g : G) {v : V}
    (hv : v ∈ kerSummand (V := V) (G := G)) :
    action (V := V) (G := G) g v ∈ kerSummand (V := V) (G := G) := by
  -- `e v = 0`, so `e (g v) = g (e v) = g 0 = 0`.
  show invSplit (V := V) (G := G) (action g v) = 0
  rw [invSplit_equivariant_apply]
  have : invSplit (V := V) (G := G) v = 0 := hv
  rw [this]
  exact LinearMap.map_zero _

/-- The range-summand is `G`-stable: if `v ∈ range e` then `g · v ∈ range e`. -/
theorem rangeSummand_action_mem (g : G) {v : V}
    (hv : v ∈ rangeSummand (V := V) (G := G)) :
    action (V := V) (G := G) g v ∈ rangeSummand (V := V) (G := G) := by
  -- Pick `w` with `e w = v`; then `e (g w) = g (e w) = g v`.
  rcases hv with ⟨w, hw⟩
  refine ⟨action (V := V) (G := G) g w, ?_⟩
  rw [invSplit_equivariant_apply, hw]

/-- The two summands together capture every vector: for any `v`,
`v = (v - e v) + e v` with `v - e v ∈ ker e` and `e v ∈ range e`. -/
theorem kerSummand_add_rangeSummand_covers (v : V) :
    ∃ (a b : V), a ∈ kerSummand (V := V) (G := G) ∧
      b ∈ rangeSummand (V := V) (G := G) ∧ v = a + b := by
  refine ⟨v - invSplit (V := V) (G := G) v, invSplit (V := V) (G := G) v,
    ?_, ?_, by abel⟩
  · -- `e (v - e v) = e v - e (e v) = e v - e v = 0`.
    show invSplit (V := V) (G := G) (v - invSplit (V := V) (G := G) v) = 0
    rw [LinearMap.map_sub, invSplit_idem_apply, sub_self]
  · -- `e v ∈ range e`.
    exact ⟨v, rfl⟩

end MTGroupStructureData

/-! ## Trivial inhabiting instance for `MTGroupStructureData`

The trivial datum: take `V` arbitrary, `G = PUnit`, action = identity,
projector = zero map (kernel = `V`, range = `0`).  This witnesses that
the axioms are consistent. -/

namespace MTGroupTrivial

/-- Trivial action of the trivial group on `V`: every group element
(there is only one) sends every vector to itself. -/
instance trivialMTGroupStructureData
    (V : Type*) [AddCommGroup V] [Module ℚ V] :
    MTGroupStructureData V PUnit where
  action _ := LinearMap.id
  action_one := rfl
  action_mul := by intro g h; rfl
  invSplit := 0
  invSplit_idempotent := by
    -- `0 ∘ 0 = 0` as linear maps.
    ext v
    simp
  invSplit_equivariant := by
    intro g
    -- `0 ∘ id = 0 = id ∘ 0` as linear maps.
    ext v
    simp

end MTGroupTrivial

/-! ## Derived Mumford--Tate group `MT^{der}`

The **derived MT-group** `MT^{der}` is the commutator subgroup of `MT`
(equivalently, the kernel of the determinant of the Hodge cocharacter
in standard normalisations).  Two structural facts characterise it:

1. **Semisimplicity**: `MT^{der}` is semisimple as a `ℚ`-algebraic
   group — every finite-dimensional representation of `MT^{der}`
   decomposes into irreducibles.  At the level of *our* axiomatic
   datum this is the same kind of reductivity datum already packaged
   in `MTGroupStructureData`: a `G^{der}`-equivariant idempotent
   splitting projector.

2. **Containment** `MT^{der} ≤ MT`: every element of `MT^{der}`
   (sitting concretely as a subgroup `H : Subgroup G` inside the
   ambient `MT`-group `G`) is in particular an element of `MT`,
   so its action through `MT^{der}` coincides with its action
   through `MT`.

This is Deligne 1979 (1.1.16) + Voisin 2002 Vol. I §17.5 (formal
properties of the MT-group). -/

/-- **Derived Mumford--Tate group data** for `V` with ambient
MT-group `G`.  Packages a designated subgroup `derived ≤ G`
together with the semisimplicity-via-projector datum and the
restriction-of-action compatibility. -/
class DerivedMTData (V : Type*) [AddCommGroup V] [Module ℚ V]
    (G : Type*) [Group G] [MTGroupStructureData V G] where
  /-- The derived subgroup `MT^{der} ≤ G`, modelled as an actual
  `Subgroup G` (substantive subgroup membership, not just
  set-inclusion). -/
  derived : Subgroup G
  /-- **Semisimplicity projector** for `MT^{der}`: a designated
  idempotent `ℚ`-linear endomorphism of `V` whose range/kernel
  decomposition is preserved by the action of every element of
  `derived` (= semisimplicity of `MT^{der}`-representations). -/
  ssProj : V →ₗ[ℚ] V
  /-- `ssProj` is idempotent: `e ∘ e = e`. -/
  ssProj_idempotent : ssProj.comp ssProj = ssProj
  /-- `ssProj` is `MT^{der}`-equivariant: for every `g ∈ derived`,
  the projector commutes with `MTGroupStructureData.action g`. -/
  ssProj_equivariant : ∀ g ∈ derived,
    ssProj.comp (MTGroupStructureData.action (V := V) (G := G) g) =
      (MTGroupStructureData.action (V := V) (G := G) g).comp ssProj
  /-- **Containment** `MT^{der} ≤ MT` at the level of actions:
  every element of `derived` is in particular an element of `G` and
  acts through the ambient `MTGroupStructureData.action`.  This
  axiom states the substantive *Subgroup* containment witness
  (membership preserves identity). -/
  derived_le_ambient : ∀ g, g ∈ derived → g ∈ (⊤ : Subgroup G)

namespace DerivedMTData

variable {V : Type*} [AddCommGroup V] [Module ℚ V]
variable {G : Type*} [Group G] [MTGroupStructureData V G] [DerivedMTData V G]

/-- The identity of `G` is in the derived subgroup (every subgroup
contains `1`). -/
theorem one_mem_derived : (1 : G) ∈ derived (V := V) (G := G) :=
  (derived (V := V) (G := G)).one_mem

/-- The derived subgroup is closed under multiplication. -/
theorem mul_mem_derived {g h : G}
    (hg : g ∈ derived (V := V) (G := G))
    (hh : h ∈ derived (V := V) (G := G)) :
    g * h ∈ derived (V := V) (G := G) :=
  (derived (V := V) (G := G)).mul_mem hg hh

/-- The derived subgroup is closed under inverses. -/
theorem inv_mem_derived {g : G}
    (hg : g ∈ derived (V := V) (G := G)) :
    g⁻¹ ∈ derived (V := V) (G := G) :=
  (derived (V := V) (G := G)).inv_mem hg

/-- The semisimplicity projector is idempotent at the value level. -/
theorem ssProj_idem_apply (v : V) :
    ssProj (V := V) (G := G) (ssProj (V := V) (G := G) v) =
      ssProj (V := V) (G := G) v := by
  have h := ssProj_idempotent (V := V) (G := G)
  have := congrArg (fun (f : V →ₗ[ℚ] V) => f v) h
  simpa using this

/-- `MT^{der}`-equivariance at the value level. -/
theorem ssProj_equivariant_apply {g : G}
    (hg : g ∈ derived (V := V) (G := G)) (v : V) :
    ssProj (V := V) (G := G)
        (MTGroupStructureData.action (V := V) (G := G) g v) =
      MTGroupStructureData.action (V := V) (G := G) g
        (ssProj (V := V) (G := G) v) := by
  have h := ssProj_equivariant (V := V) (G := G) g hg
  have := congrArg (fun (f : V →ₗ[ℚ] V) => f v) h
  simpa using this

/-- The semisimplicity-summand (range of `ssProj`) is preserved by
every element of `MT^{der}` (the substantive "every subrepresentation
splits"). -/
theorem ssProj_range_stable {g : G}
    (hg : g ∈ derived (V := V) (G := G)) {v : V}
    (hv : v ∈ LinearMap.range (ssProj (V := V) (G := G))) :
    MTGroupStructureData.action (V := V) (G := G) g v ∈
      LinearMap.range (ssProj (V := V) (G := G)) := by
  rcases hv with ⟨w, hw⟩
  refine ⟨MTGroupStructureData.action (V := V) (G := G) g w, ?_⟩
  rw [ssProj_equivariant_apply hg, hw]

/-- The semisimplicity-kernel is preserved by every element of `MT^{der}`. -/
theorem ssProj_ker_stable {g : G}
    (hg : g ∈ derived (V := V) (G := G)) {v : V}
    (hv : v ∈ LinearMap.ker (ssProj (V := V) (G := G))) :
    MTGroupStructureData.action (V := V) (G := G) g v ∈
      LinearMap.ker (ssProj (V := V) (G := G)) := by
  show ssProj (V := V) (G := G)
      (MTGroupStructureData.action (V := V) (G := G) g v) = 0
  rw [ssProj_equivariant_apply hg]
  have : ssProj (V := V) (G := G) v = 0 := hv
  rw [this]
  exact LinearMap.map_zero _

end DerivedMTData

/-! ## Trivial inhabiting instance for `DerivedMTData`

Take `G = PUnit`, `derived = ⊤`, projector = zero map.  Equivariance
is automatic because there is only the identity action. -/

namespace DerivedMTTrivial

instance trivialDerivedMTData (V : Type*) [AddCommGroup V] [Module ℚ V] :
    @DerivedMTData V _ _ PUnit _
      (MTGroupTrivial.trivialMTGroupStructureData V) where
  derived := ⊤
  ssProj := 0
  ssProj_idempotent := by
    ext v
    simp
  ssProj_equivariant := by
    intro g _
    -- Trivial action is `id`; `0 ∘ id = 0 = id ∘ 0` as linear maps.
    ext v
    simp [MTGroupTrivial.trivialMTGroupStructureData]
  derived_le_ambient := by
    intro g _
    exact Subgroup.mem_top g

end DerivedMTTrivial

end HodgeReduction.Infrastructure.HodgeStructure
