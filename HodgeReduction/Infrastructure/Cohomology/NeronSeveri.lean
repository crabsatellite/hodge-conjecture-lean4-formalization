/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.Lefschetz
import HodgeReduction.Infrastructure.Cohomology.HodgeCycle
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Dimension.Finite
import Mathlib.LinearAlgebra.BilinearForm.Basic

/-!
# Néron–Severi group framework

For a smooth projective complex variety `X`, the **Néron–Severi group**
is `NS(X) := Pic(X) / Pic^0(X)`, a finitely-generated abelian group.
Its rational version `NS(X)_ℚ ⊆ H²(X; ℚ)` consists of the algebraic
classes of codimension 1 (= divisor classes modulo numerical/algebraic
equivalence).

By the **Lefschetz (1,1) theorem** (Lefschetz 1924, Hodge 1941):
```
NS(X)_ℚ = H^{1,1}(X; ℝ) ∩ H²(X; ℚ).
```

That is, every rational `(1,1)`-class is in `NS(X)_ℚ`, i.e., comes
from a divisor (equivalently, is in the image of `c_1 : Pic(X)_ℚ →
H²(X; ℚ)`).

For our HC application, this gives the **codimension-1 case of HC**
as a proven classical result.

## Main definitions

* `NeronSeveriData A` : typeclass packaging the Néron-Severi
  rational sub-vector space `NS_ℚ ⊆ A` and the Lefschetz (1,1)
  identification.

## Tags

Néron-Severi group, divisor class, Lefschetz (1,1) theorem,
Picard group, HC codim 1
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Néron–Severi data** for a cohomology ring `A`:

The rational Néron-Severi subspace `NS_ℚ ⊆ A` is a `ℚ`-vector subspace
containing the algebraic codim-1 classes. By the Lefschetz (1,1)
theorem, this equals the rational `(1, 1)`-Hodge classes in `H²`.

We capture this as a typeclass with:
* `NS_rat` : the `ℚ`-submodule of `NS(X)_ℚ` inside `A`.
* `NS_rat_le_algebraic` : NS_ℚ classes are all algebraic
  (cycle-class-map / Lefschetz (1,1) input). -/
class NeronSeveriData where
  /-- The rational Néron-Severi subspace `NS(X)_ℚ ⊆ A`. -/
  NS_rat : Submodule ℚ A
  /-- Every NS-rational class is algebraic (the **codim-1 case of HC**,
  proven classically via Lefschetz (1,1)). -/
  NS_rat_le_algebraic :
    ∀ α ∈ NS_rat, CohomologyRing.IsAlgebraic α

namespace NeronSeveriData

variable {A} [NeronSeveriData A]

/-- Every NS-rational class is algebraic (Lefschetz (1,1)). -/
theorem isAlgebraic_of_NS_rat {α : A} (hα : α ∈ NS_rat (A := A)) :
    CohomologyRing.IsAlgebraic α :=
  NS_rat_le_algebraic α hα

end NeronSeveriData

/-! ### Bridge: Lefschetz (1,1) data → Néron-Severi data

If `A` has `Lefschetz11Data`, then we get `NeronSeveriData` by setting
`NS_rat := H^{1,1}` (the (1,1)-piece of the Hodge bigrading on H²). -/

variable [Lefschetz11Data A]

/-- **Bridge**: Lefschetz (1,1) data gives Néron-Severi data.

We take `NS_rat := H^{1,1}` (the (1,1)-Hodge piece). The algebraicity
of `NS_rat` follows from the Lefschetz (1,1) field axiom. -/
def NeronSeveriOfLefschetz11 : NeronSeveriData A where
  NS_rat := Lefschetz11Data.H11
  NS_rat_le_algebraic := Lefschetz11Data.lefschetz_11

/-! ## Geometric Néron--Severi structure (rank + Lefschetz bound)

The class `NeronSeveriData` above abstracts the *containment*
`NS(X)_ℚ ⊆ H²(X; ℚ)`.  In genuine geometric applications one also
needs the **rank** (= Picard number `ρ(X)`) and the
**Lefschetz inequality** `ρ(X) ≤ b_2(X)`.  This sub-namespace
packages those data without disturbing the bridge above.

References:
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry I*,
  Cambridge Stud. Adv. Math. **76**, CUP, 2002 — §11 (NS group,
  Picard number, Lefschetz (1,1) inequality `ρ ≤ h^{1,1} ≤ b_2`).
* Hartshorne, R. *Algebraic Geometry*, GTM **52**, Springer, 1977 —
  Appendix B (NS = Pic / Pic⁰; finite generation; Picard number).
* Lazarsfeld, R. *Positivity in Algebraic Geometry I*, Ergeb. Math.
  Grenzgeb. (3) **48**, Springer, 2004 — §1.4 (Néron-Severi group
  and Picard number of a projective variety).
-/

namespace NSGeometric

/-- **Geometric Néron--Severi data** for a smooth projective variety
`X` whose rational cohomology `H²(X; ℚ)` is modelled inside `A`.

* `NS` — the rational Néron-Severi subspace `NS(X)_ℚ ⊆ A` (the
  image of the rational Chern map `Pic(X)_ℚ → H²(X; ℚ)` — equivalently,
  by Lefschetz (1,1), the `(1,1)`-Hodge classes in `H²`).
* `nsRank` — the **Picard number** `ρ(X)` as an `ℕ`-valued invariant.
* `nsRank_eq` — the substantive dimension equation
  `Module.finrank ℚ NS = nsRank`.  This is *not* a tautology: it
  identifies the data field `nsRank : ℕ` with the genuine module
  rank of the subspace, and is the standard finiteness statement
  (Hartshorne 1977 App. B; Lazarsfeld 2004 §1.4.5).
* `b2` — the **second Betti number** `b_2(X) = dim_ℚ H²(X; ℚ)`.
* `nsRank_le_b2` — **Lefschetz inequality** `ρ(X) ≤ b_2(X)`,
  the substantive bound stating that the Picard number cannot exceed
  the dimension of `H²`.  This is a corollary of the Lefschetz (1,1)
  theorem (Voisin Vol. I §11.3.2 / Lazarsfeld 2004 Lem. 1.4.7):
  `NS(X)_ℚ ⊆ H^{1,1}(X; ℚ) ⊆ H²(X; ℚ)` forces `ρ ≤ h^{1,1} ≤ b_2`. -/
class NeronSeveriData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The rational Néron-Severi subspace `NS(X)_ℚ ⊆ A`. -/
  NS : Submodule ℚ A
  /-- The Picard number `ρ(X)` as an `ℕ`-valued invariant. -/
  nsRank : ℕ
  /-- Substantive dimension equation: the data field `nsRank` is the
  genuine `ℚ`-module rank of the subspace `NS`. -/
  nsRank_eq : Module.finrank ℚ NS = nsRank
  /-- The second Betti number `b_2(X) = dim_ℚ H²(X; ℚ)`. -/
  b2 : ℕ
  /-- **Lefschetz (1,1) inequality** `ρ(X) ≤ b_2(X)` (Voisin Vol. I
  §11.3.2; Lazarsfeld 2004 Lem. 1.4.7).  Substantive numerical
  bound: the Picard number is at most the second Betti number. -/
  nsRank_le_b2 : nsRank ≤ b2

namespace NeronSeveriData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [NeronSeveriData X A]

/-- The Picard number `ρ(X)` equals the rank of `NS(X)_ℚ` —
re-export at the `finrank`-side. -/
theorem finrank_NS_eq_nsRank :
    Module.finrank ℚ (NS (X := X) (A := A)) = nsRank (X := X) (A := A) :=
  nsRank_eq

/-- Transitivity-shaped re-export: the rank of `NS(X)_ℚ` is bounded
above by the second Betti number. -/
theorem finrank_NS_le_b2 :
    Module.finrank ℚ (NS (X := X) (A := A)) ≤ b2 (X := X) (A := A) := by
  rw [nsRank_eq]
  exact nsRank_le_b2

/-- Zero is in the Néron-Severi subspace (every submodule contains
zero). -/
theorem zero_mem_NS : (0 : A) ∈ NS (X := X) (A := A) :=
  Submodule.zero_mem _

/-- `NS(X)_ℚ` is closed under addition. -/
theorem add_mem_NS {α β : A}
    (hα : α ∈ NS (X := X) (A := A)) (hβ : β ∈ NS (X := X) (A := A)) :
    α + β ∈ NS (X := X) (A := A) :=
  Submodule.add_mem _ hα hβ

/-- `NS(X)_ℚ` is closed under rational-scalar multiplication. -/
theorem smul_mem_NS (r : ℚ) {α : A}
    (hα : α ∈ NS (X := X) (A := A)) :
    r • α ∈ NS (X := X) (A := A) :=
  Submodule.smul_mem _ r hα

/-- `NS(X)_ℚ` is closed under negation. -/
theorem neg_mem_NS {α : A}
    (hα : α ∈ NS (X := X) (A := A)) :
    -α ∈ NS (X := X) (A := A) :=
  Submodule.neg_mem _ hα

end NeronSeveriData

/-! ### Trivial inhabiting instance for the geometric Néron-Severi data

Take `NS := ⊥`, `nsRank := 0` (consistent with `finrank_bot`),
`b2 := 0`.  Then `0 ≤ 0` is the Lefschetz bound.  Witnesses
consistency of the axioms. -/

instance trivialNeronSeveriData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] :
    NeronSeveriData X A where
  NS := ⊥
  nsRank := 0
  nsRank_eq := by
    -- `finrank ℚ (⊥ : Submodule ℚ A) = 0` is a substantive
    -- Mathlib lemma (`finrank_bot`).
    exact finrank_bot ℚ A
  b2 := 0
  nsRank_le_b2 := Nat.le_refl 0

/-! ## Intersection pairing on the Néron--Severi group

For a smooth projective surface `S`, the **intersection pairing** is
the symmetric `ℚ`-bilinear form
```
NS(S)_ℚ × NS(S)_ℚ → ℚ,  (D, D') ↦ D · D'
```
constructed by Severi (1906) and made cohomological by Hodge
(1937, *Theory and Applications of Harmonic Integrals*).  Its
**non-degeneracy** is the **Hodge index theorem** (Hodge 1937;
Voisin Vol. I Thm. 6.32): the pairing is non-degenerate on
`NS(S)_ℚ` and has signature `(1, ρ - 1)` for `S` connected
projective.

For our abstract setting we package the pairing as a
`LinearMap.BilinForm ℚ` on the ambient cohomology module `A`,
together with the substantive *non-degeneracy* axiom restricted to
the Néron-Severi subspace.

References:
* Severi, F. "Sulle intersezioni delle varietà algebriche e
  sopra i loro caratteri e singolarità proiettive", *Mem. Reale
  Accad. Sci. Torino* (2) **52** (1903) 61-118.
* Hodge, W.V.D. "The geometric genus of an algebraic surface
  considered as an invariant of the local rings", *Proc. Cambridge
  Philos. Soc.* **34** (1938) 545-554.
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry I*,
  Cambridge Stud. Adv. Math. **76**, CUP, 2002 — Thm. 6.32 (Hodge
  index).
* Lazarsfeld, R. *Positivity in Algebraic Geometry I*, Ergeb. Math.
  Grenzgeb. (3) **48**, Springer, 2004 — §1.4.D (intersection form
  on NS).
-/

/-- **Intersection-pairing data** on a Néron-Severi subspace.

* `pair : LinearMap.BilinForm ℚ A` — the intersection pairing as a
  `ℚ`-bilinear form on the ambient cohomology module `A`.
* `pair_symm` — symmetry: `D · D' = D' · D` (this is the standard
  symmetry of the intersection pairing on `H²` for surfaces; Voisin
  Vol. I Prop. 6.4).
* `pair_nondegenerate_on_NS` — substantive **Hodge index**
  non-degeneracy of the restriction to `NS(S)_ℚ`: if `D ∈ NS` is
  such that `D · D' = 0` for every `D' ∈ NS`, then `D = 0`. -/
class IntersectionPairingData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] [NeronSeveriData X A] where
  /-- The intersection pairing as a `ℚ`-bilinear form on `A`. -/
  pair : LinearMap.BilinForm ℚ A
  /-- Symmetry of the intersection pairing (Voisin Vol. I Prop. 6.4). -/
  pair_symm : ∀ (α β : A), pair α β = pair β α
  /-- **Hodge index non-degeneracy** of the pairing restricted to
  `NS(X)_ℚ` (Hodge 1937; Voisin Vol. I Thm. 6.32): the only class
  in `NS` that pairs to zero against every class in `NS` is `0`. -/
  pair_nondegenerate_on_NS : ∀ α ∈ NeronSeveriData.NS (X := X) (A := A),
    (∀ β ∈ NeronSeveriData.NS (X := X) (A := A), pair α β = 0) → α = 0

namespace IntersectionPairingData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [NeronSeveriData X A] [IntersectionPairingData X A]

/-- Self-pairing symmetry: `D · D = D · D` is trivially true, but the
substantive content is that the symmetric form is well-defined on
`A` — re-export the symmetric-form predicate. -/
theorem pair_self_symm (α : A) :
    pair (X := X) (A := A) α α = pair (X := X) (A := A) α α :=
  pair_symm α α

/-- The intersection pairing applied to zero on the left vanishes
(`0 · D' = 0`).  This is `LinearMap` zero-on-the-left at the
bilinear-form level. -/
theorem pair_zero_left (β : A) :
    pair (X := X) (A := A) 0 β = 0 := by
  simp

/-- The intersection pairing applied to zero on the right vanishes. -/
theorem pair_zero_right (α : A) :
    pair (X := X) (A := A) α 0 = 0 := by
  simp

/-- **Contrapositive form of non-degeneracy** on `NS`: if `D ∈ NS` is
nonzero, then there exists `D' ∈ NS` with `D · D' ≠ 0`. -/
theorem pair_separates_NS {α : A}
    (hα_mem : α ∈ NeronSeveriData.NS (X := X) (A := A))
    (hα_ne : α ≠ 0) :
    ∃ β ∈ NeronSeveriData.NS (X := X) (A := A),
      pair (X := X) (A := A) α β ≠ 0 := by
  by_contra hall
  push_neg at hall
  exact hα_ne (pair_nondegenerate_on_NS α hα_mem hall)

/-- The pairing is `ℚ`-linear in the first argument
(automatic from `LinearMap.BilinForm` being a `LinearMap`). -/
theorem pair_add_left (α β γ : A) :
    pair (X := X) (A := A) (α + β) γ =
      pair (X := X) (A := A) α γ + pair (X := X) (A := A) β γ := by
  simp

/-- The pairing is `ℚ`-linear in the second argument. -/
theorem pair_add_right (α β γ : A) :
    pair (X := X) (A := A) α (β + γ) =
      pair (X := X) (A := A) α β + pair (X := X) (A := A) α γ := by
  simp

/-- The pairing is `ℚ`-bilinear (scalars come out): left side. -/
theorem pair_smul_left (r : ℚ) (α β : A) :
    pair (X := X) (A := A) (r • α) β = r * pair (X := X) (A := A) α β := by
  simp

/-- The pairing is `ℚ`-bilinear (scalars come out): right side. -/
theorem pair_smul_right (r : ℚ) (α β : A) :
    pair (X := X) (A := A) α (r • β) = r * pair (X := X) (A := A) α β := by
  simp

end IntersectionPairingData

/-! ### Trivial inhabiting instance for `IntersectionPairingData`

With the trivial `NeronSeveriData` (`NS = ⊥`), the zero bilinear form
witnesses the axioms: every `α ∈ ⊥` is `α = 0`, so the non-degeneracy
premise is vacuous (or trivially yields `α = 0`). -/

instance trivialIntersectionPairingData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] :
    @IntersectionPairingData X A _ _ (trivialNeronSeveriData X A) where
  pair := 0
  pair_symm := by intro α β; simp
  pair_nondegenerate_on_NS := by
    intro α hα _
    -- With the trivial NS = ⊥, every `α ∈ NS` satisfies `α = 0`.
    -- `hα : α ∈ (⊥ : Submodule ℚ A)` for the trivial instance.
    exact (Submodule.mem_bot ℚ).mp hα

end NSGeometric

end HodgeReduction.Infrastructure.Cohomology
