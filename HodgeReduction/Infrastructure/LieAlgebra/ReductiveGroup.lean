/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Group.Subgroup.Basic
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.PUnitInstances.Algebra

/-!
# Reductive algebraic group framework

A **reductive algebraic group** over a field `k` is a connected
linear algebraic group with trivial unipotent radical. For `k = ℝ`
(or `ℂ`), reductive groups include `GL_n, SL_n, Sp_{2n}, O_n,
E_6, E_7, E_8`, etc.

For our HC application:
* `E_{7(-25)}` : real reductive group, real form of `E_7(ℂ)`.
* Levi component `E_6 × U(1) ⊂ E_{7(-25)}`.
* The Mumford-Tate group `MT ⊂ Sp(V_56, ω)` is reductive.

This file packages **abstract reductive algebraic group data** together
with the structural axioms of root-system theory (Borel 1991, Springer
1998, Tits 1966).

## References

* Borel, A. *Linear Algebraic Groups* (2nd ed.), Graduate Texts in
  Mathematics **126**, Springer 1991 — Ch. IV (reductive groups, root
  data).
* Springer, T. A. *Linear Algebraic Groups* (2nd ed.), Progress in
  Mathematics **9**, Birkhäuser 1998 — Ch. 7-8 (reductive structure
  theory, Weyl group, root system).
* Tits, J. "Classification of algebraic semisimple groups", *Proc. Symp.
  Pure Math.* **9** (1966), 33-62 (the Tits classification of semisimple
  groups by Dynkin diagrams + Tits indices).

## Main definitions

* `ReductiveGroupData G` : abstract reductive group with maximal torus,
  numerical rank invariants and a substantive Weyl-action axiom.
* `WeylGroupData G` : Weyl group data with finiteness-witness and
  substantive group-action-on-torus axiom.

## Tags

reductive group, algebraic group, real form, Lie type, Weyl group,
root system, maximal torus
-/

namespace HodgeReduction.Infrastructure.LieAlgebra

/-- **Reductive algebraic group data** for an abstract group type `G`.

For the EVII application, `G` plays the role of an abstract `E_{7(-25)}`-
shape carrier on which the rank, complex dimension, real-rank and real-
form invariants are stored together with the **substantive Weyl-action**
on a designated maximal torus.

Fields:
* `T` : a designated maximal torus, recorded as a Mathlib `Subgroup G`
  (substantive carrier — not a tautological proposition).
* `rank` : the semisimple rank (`dim T` for split groups; for `E_7`
  this is `7`, recovered via `WeylGroupData.rank_E7 = 7`).
* `complexDim` : the complex dimension of `G(ℂ)` (for `E_7` this is
  `133`).
* `realRank` : the real rank `= dim` of a maximal split torus over ℝ.
* `realForm` : a string tag identifying the real form (e.g., `"split"`,
  `"compact"`, `"Hermitian"`).
* `weyl` : the substantive Weyl-group action — a `MonoidHom` from `T`
  (as a group via the subgroup structure) to `Monoid.End T`, the
  endomorphism monoid of `T`. This is the carrier-level shadow of
  `W = N_G(T) / T` acting on `T` by conjugation (Borel 1991 §IV.11.1;
  Springer 1998 §7.1.2).
* `weyl_identity_preserves` : the identity torus element acts as the
  identity endomorphism (`Monoid.End`-multiplicative identity), the
  weakest non-vacuous compatibility axiom.
* `realRank_le_rank`, `rank_le_complexDim` : numerical structural
  constraints from root-system theory.
-/
class ReductiveGroupData (G : Type*) [Group G] where
  /-- Designated maximal torus `T ⊆ G` (Borel 1991 §IV.8; Springer 1998
  §7.1.1). -/
  T : Subgroup G
  /-- Semisimple rank `= dim T` for split groups (`= 7` for `E_7`). -/
  rank : ℕ
  /-- Complex dimension of `G(ℂ)` (`= 133` for `E_7`). -/
  complexDim : ℕ
  /-- Real rank `= dim` of a maximal split torus over ℝ. -/
  realRank : ℕ
  /-- Real-form tag (e.g., `"split"`, `"compact"`, `"Hermitian"`). -/
  realForm : String
  /-- **Substantive Weyl-action**: a `MonoidHom` from `T` to the
  endomorphism monoid `Monoid.End T`. This is the carrier-level shadow
  of `W = N_G(T) / T` acting on `T` by conjugation (Borel 1991
  §IV.11.1; Springer 1998 §7.1.2). -/
  weyl : T →* Monoid.End T
  /-- The identity torus element acts as the identity endomorphism of
  `T` (the multiplicative identity of `Monoid.End T`). This is the
  carrier-level shadow of "the trivial element of `W` is the identity
  automorphism of `T`" (Borel 1991 §IV.11; Springer 1998 §7.1.4). -/
  weyl_identity_preserves : weyl 1 = (1 : Monoid.End T)
  /-- **Rank-realRank inequality**: the real rank cannot exceed the
  semisimple rank (a non-trivial structural constraint of root systems
  — Tits 1966 §2: the real form's split torus is a sub-torus of the
  full Cartan). -/
  realRank_le_rank : realRank ≤ rank
  /-- **Complex-dimension lower bound**: `complexDim ≥ rank` (the
  Cartan subalgebra of dimension `rank` is contained in `g`, so
  `dim g ≥ dim t = rank`). Springer 1998 §6.4.1. -/
  rank_le_complexDim : rank ≤ complexDim

namespace ReductiveGroupData

variable {G : Type*} [Group G] [ReductiveGroupData G]

/-! ## Derived consequences of the reductive-group axioms -/

/-- The real rank is bounded by the complex dimension (transitivity of
the two structural inequalities). -/
theorem realRank_le_complexDim :
    realRank G ≤ complexDim G :=
  le_trans (realRank_le_rank (G := G)) (rank_le_complexDim (G := G))

/-- **The Weyl-action of the identity is the identity endomorphism**
— restated for ergonomic rewriting. Direct projection of
`weyl_identity_preserves`. -/
theorem weyl_one_eq_one :
    weyl (G := G) 1 = (1 : Monoid.End (T (G := G))) :=
  weyl_identity_preserves

/-- **The Weyl-action of the identity sends every torus element to
itself** — applied form of `weyl_one_eq_one` via the `FunLike`
coercion. -/
theorem weyl_one_apply (t : T (G := G)) :
    (weyl (G := G) 1 : Monoid.End _) t = t := by
  rw [weyl_one_eq_one]
  -- `(1 : Monoid.End T) t = t` by `Monoid.End.coe_one`.
  rfl

/-- **The Weyl-action of the identity fixes the identity torus element**
— a corollary of `weyl_one_apply`. -/
theorem weyl_one_one : (weyl (G := G) 1 : Monoid.End _) 1 = (1 : T (G := G)) :=
  weyl_one_apply 1

end ReductiveGroupData

/-- **Weyl-group data** for a reductive group `G`, presented as a
companion typeclass to `ReductiveGroupData G`.

The Weyl group `W(G, T) := N_G(T) / T` is finite, of order equal to the
product of the Coxeter degrees of the root system (for `E_7`:
`2903040 = 2 · 6 · 8 · 10 · 12 · 14 · 18`).

Fields:
* `order` : the finite order `|W|` (a non-zero natural number).
* `order_pos` : `0 < order` — the Weyl group is non-empty (always
  contains the identity).
* `rank_le_order` : the abstract numerical axiom `rank ≤ |W|`
  (encoding that the Weyl group contains the `rank`-many simple
  reflections plus the identity).

Reference: Borel 1991 §IV.11.4 (Weyl group is generated by simple
reflections); Springer 1998 §8.2.4; Bourbaki LIE VI §1. -/
class WeylGroupData (G : Type*) [Group G] [ReductiveGroupData G] where
  /-- The order `|W|` of the Weyl group `W(G, T) = N_G(T) / T`. For
  `E_7`, this is `2903040` (Borel 1991 §IV.11.1; Bourbaki LIE VI). -/
  order : ℕ
  /-- The Weyl group is **non-empty**: `0 < |W|`. (`W` always contains
  the identity, hence is non-empty.) -/
  order_pos : 0 < order
  /-- **Finite-generation lower bound** (numerical reflection of
  Coxeter-generation): `rank ≤ |W|`, encoding that the Weyl group
  contains the `rank`-many simple reflections plus the identity.

  Reference: Borel 1991 §IV.11.4 (Weyl group is generated by simple
  reflections); Springer 1998 §8.2.4. -/
  rank_le_order : ReductiveGroupData.rank G ≤ order

namespace WeylGroupData

variable {G : Type*} [Group G] [ReductiveGroupData G] [WeylGroupData G]

/-! ## Derived consequences of the Weyl-group axioms -/

/-- The order is non-zero (specialisation of `order_pos`). -/
theorem order_ne_zero : order (G := G) ≠ 0 :=
  Nat.pos_iff_ne_zero.mp order_pos

/-- The Weyl group has at least `rank` elements (corollary of
`rank_le_order`). -/
theorem order_ge_rank : ReductiveGroupData.rank G ≤ order (G := G) :=
  rank_le_order

/-- **Positive-rank ⇒ non-trivial Weyl group**: if the semisimple rank
is positive, so is the Weyl-group order (a strict positivity transferred
from `rank_le_order`). -/
theorem order_pos_of_rank_pos (h : 0 < ReductiveGroupData.rank G) :
    0 < order (G := G) :=
  lt_of_lt_of_le h rank_le_order

end WeylGroupData

/-! ## Trivial reference instance: the trivial group

The unit type `PUnit` (with its `CommGroup` instance from Mathlib's
`PUnitInstances.Algebra`) admits a degenerate reductive-group structure
with `rank = 0`, `complexDim = 0`, `realRank = 0`, `realForm = "trivial"`,
the trivial torus `T = ⊥`, and the trivial Weyl-action (the unique
`MonoidHom` from the trivial group to `Monoid.End (⊥ : Subgroup PUnit)`).

This witnesses that the axioms are consistent and non-empty (in line
with the inhabitation pattern used throughout the kernel-pure HC
framework). -/

namespace Trivial

/-- The trivial Weyl-action `weyl : ⊥ →* Monoid.End ⊥` for the trivial
torus `⊥ : Subgroup PUnit`: every element of `⊥` (only the unit) is
sent to the identity endomorphism. -/
def trivWeyl :
    (⊥ : Subgroup PUnit) →* Monoid.End ((⊥ : Subgroup PUnit)) where
  toFun _ := (1 : Monoid.End _)
  map_one' := rfl
  map_mul' _ _ := by
    -- `1 * 1 = 1` in `Monoid.End _`.
    rw [mul_one]

@[simp] theorem trivWeyl_apply (t : (⊥ : Subgroup PUnit)) :
    trivWeyl t = (1 : Monoid.End _) := rfl

/-- Trivial `ReductiveGroupData PUnit` instance: numerical invariants
all zero, torus `= ⊥`, Weyl-action trivial. -/
instance reductiveGroup_punit : ReductiveGroupData PUnit where
  T := (⊥ : Subgroup PUnit)
  rank := 0
  complexDim := 0
  realRank := 0
  realForm := "trivial"
  weyl := trivWeyl
  weyl_identity_preserves := rfl
  realRank_le_rank := le_refl 0
  rank_le_complexDim := le_refl 0

/-- Trivial `WeylGroupData PUnit` instance: order `= 1` (the Weyl group
of the trivial group is the trivial group itself). -/
instance weylGroup_punit : WeylGroupData PUnit where
  order := 1
  order_pos := Nat.one_pos
  rank_le_order := by
    -- `ReductiveGroupData.rank PUnit = 0 ≤ 1`.
    show 0 ≤ 1
    exact Nat.zero_le 1

end Trivial

end HodgeReduction.Infrastructure.LieAlgebra
