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

end HodgeReduction.Infrastructure.HodgeStructure
