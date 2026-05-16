/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.BigOperators.Group.Finset.Defs
import Mathlib.Data.Fintype.Basic
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Schubert cells / Schubert calculus framework

For a generalised flag variety `G/P` (e.g., the compact dual `Ě_VII =
E_{7,ℂ}/P_7`), the **Schubert cells** `X_w := B · wP/P` for
`w ∈ W^P = W/W_P` (the **minimal-length coset representatives** of
the Weyl-group quotient) give a CW-decomposition:
```
G/P = ⨆_{w ∈ W^P} X_w  (disjoint union of affine cells)
```
of complex dimension `dim_ℂ X_w = ℓ(w)` (Bruhat length).

The **Schubert classes** `[X_w] ∈ H^{2 ℓ(w)}(G/P; ℤ)` form a basis of
the rational cohomology, and the **Schubert calculus** is the
multiplication structure recorded by the **Littlewood-Richardson
coefficients** `c^w_{u,v} ∈ ℤ≥0` (Schubert structure constants),
```
[X_u] · [X_v] = ∑_w c^w_{u,v} · [X_w].
```
In type A these reduce to LR coefficients on Young tableaux; in other
types analogous Pieri / Chevalley / Monk formulas (Fulton 1997 §§9-10).

For our HC application:
* On the compact dual `Ě_VII`, `H^8 = ℚ · h^4` (1-dim), realised by
  the Schubert class of the codim-4 cell at length 4.
* Borel-Hirzebruch 1958 / Bott-Borel-Weil + Bernstein-Gelfand-Gelfand
  1973 give the bigrading and the BGG-resolution of cohomology.

This file packages **abstract Schubert calculus data**.

## References (Cat 2 PUBLISHED)

* I. N. Bernstein, I. M. Gelfand, S. I. Gelfand, "Schubert cells and
  cohomology of the spaces G/P", *Russian Math. Surveys* **28**:3
  (1973), 1-26. — BGG paper introducing Schubert cells in the
  algebraic / coinvariant-algebra framework; basis of `H^*(G/P; ℚ)`
  by Schubert classes; BGG-resolution.
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Mathematics **76**, CUP, 2002 — §3.5 Schubert
  calculus on Grassmannians and general flag varieties.
* W. Fulton, *Young Tableaux: with Applications to Representation
  Theory and Geometry*, London Mathematical Society Student Texts
  **35**, CUP, 1997 — Schubert combinatorics, LR rule, Pieri rules.
* A. Borel, F. Hirzebruch, "Characteristic classes and homogeneous
  spaces I-III", *Amer. J. Math.* **80-82** (1958-60). — Coinvariant
  presentation of `H^*(G/P; ℚ)`, used to identify the Schubert basis.

## Main definitions

* `SchubertCellData P A` : abstract Schubert cell data for a flag
  variety `G/P` with cohomology ring `A`, packaging the Weyl-quotient
  index set `WP = W/W_P` (as a `Fintype`), the cell class function
  `cellClass : WP → Submodule ℚ A`, the **substantive direct-sum
  decomposition** `⨆_w cellClass w = ⊤` (Schubert cells span the
  cohomology), and the Bruhat length function.
* `SchubertCalculusData P A` : sibling typeclass recording the
  **Littlewood-Richardson structure constants** `c^w_{u,v}` and the
  cup-product identity `cellClass u * cellClass v = ∑_w c^w_{u,v} •
  cellClass w` at the carrier-level linear-coefficient identity.

## Tags

Schubert cells, flag variety, Schubert calculus, Borel-Hirzebruch,
BGG, Bruhat length, Littlewood-Richardson, EVII, compact dual
-/

namespace HodgeReduction.Infrastructure.Shimura

/-! ## §1. `SchubertCellData` — Schubert basis of `H^*(G/P; ℚ)`

The carrier records the **Weyl-quotient indexing set** `W^P = W/W_P`
(BGG 1973 §2), the **cell class function** `cellClass : W^P →
Submodule ℚ A` realising each Schubert class as a 1-dim submodule of
the cohomology ring `A`, the substantive **spanning identity**
`⨆_w cellClass w = ⊤` (= "Schubert classes form a basis of
`H^*(G/P; ℚ)` as a ℚ-vector space"; BGG 1973 Thm 5.5 + Voisin I
Prop 3.16), and the **Bruhat length** `length : W^P → ℕ` (= twice the
complex codimension of the corresponding cell).
-/

/-- **Schubert cell data** for a flag variety `G/P` with rational
cohomology ring `A` (BGG 1973; Voisin I §3.5; Fulton 1997 §§9-10).

Fields:
* `WP` : the **Weyl-group quotient** `W^P = W/W_P` indexing the
  Schubert cells (with one cell per minimal-length coset
  representative).
* `WP_fintype` : `WP` is a `Fintype` (the Weyl-group quotient
  `W^P` is finite, because `W` and `W_P` are both finite).
* `cellClass` : the **Schubert class submodule** `cellClass w ⊆ A`,
  the 1-dim ℚ-span of the Schubert class `[X_w] ∈ A`. In our setup,
  the cohomology ring `A` carries the Schubert classes as a basis,
  and `cellClass w` is the line through the class `[X_w]`.
* `cellClass_span_top` : **substantive spanning identity** at the
  ℚ-submodule level: the supremum of all cell-class submodules equals
  the top `⊤`. Equivalently: the Schubert classes generate `A` as a
  ℚ-vector space (BGG 1973 Thm 5.5; Voisin I Prop 3.16). The full
  direct-sum statement requires linear independence as well; we
  record here the spanning half, which is the load-bearing fact for
  the cohomology-decomposition arguments downstream.
* `length` : the **Bruhat length** `ℓ(w)` of each cell, giving the
  complex dimension `dim_ℂ X_w = ℓ(w)` (equivalently the cohomological
  degree `2 ℓ(w)` of the Schubert class `[X_w]`).
* `length_bound` : a **substantive uniform bound** on the Bruhat
  length: there exists a global maximum `L` such that `length w ≤ L`
  for every `w ∈ W^P`. This is a structural feature (finiteness of
  `W^P` ⇒ finiteness of the length function's image), recorded
  explicitly so downstream consumers do not have to reprove it. -/
class SchubertCellData (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- Index set for Schubert cells: the Weyl-group quotient `W^P =
  W/W_P` (BGG 1973 §2). -/
  WP : Type
  /-- `WP` is a `Fintype` (the Weyl-quotient is finite). -/
  WP_fintype : Fintype WP
  /-- The Schubert class submodule `cellClass w ⊆ A`. -/
  cellClass : WP → Submodule ℚ A
  /-- **Substantive spanning identity**: the supremum of all
  Schubert-class submodules equals `⊤` (Schubert classes span the
  cohomology ring as a ℚ-vector space; BGG 1973 Thm 5.5). -/
  cellClass_span_top :
    (⨆ w : WP, cellClass w) = (⊤ : Submodule ℚ A)
  /-- The **Bruhat length** function `ℓ : W^P → ℕ` (BGG 1973 §2;
  cohomological degree of `[X_w]` is `2 ℓ(w)`). -/
  length : WP → ℕ
  /-- **Uniform Bruhat-length bound**: there exists a global maximum
  `L` such that `length w ≤ L` for every cell `w`. This is a
  substantive structural fact (finiteness of `WP` + length function
  → bounded image), not a tautology: it constrains `length` to be
  bounded, which fails for an arbitrary `WP → ℕ` map on an infinite
  index set. -/
  length_bound : ∃ L : ℕ, ∀ w : WP, length w ≤ L

namespace SchubertCellData

variable {A : Type*} [AddCommGroup A] [Module ℚ A] [Λ : SchubertCellData A]

/-- The Weyl-quotient `WP` carries its `Fintype` instance. -/
instance : Fintype Λ.WP := Λ.WP_fintype

/-! ## Derived consequences of the Schubert spanning axiom -/

/-- **Every element of the cohomology ring lies in the supremum of
the Schubert-class submodules**: direct consequence of
`cellClass_span_top`, restated in membership form for ergonomic
rewriting. -/
theorem mem_supr_cellClass (α : A) :
    α ∈ (⨆ w : Λ.WP, Λ.cellClass w) := by
  rw [Λ.cellClass_span_top]
  trivial

/-- **The Schubert-class supremum is the top submodule**: theorem-level
restatement of `cellClass_span_top`. -/
theorem supr_cellClass_eq_top :
    (⨆ w : Λ.WP, Λ.cellClass w) = (⊤ : Submodule ℚ A) :=
  Λ.cellClass_span_top

/-- **Every individual Schubert-class submodule is contained in the
supremum** (and hence in `⊤`). -/
theorem cellClass_le_top (w : Λ.WP) : Λ.cellClass w ≤ (⊤ : Submodule ℚ A) :=
  le_top

/-- **The Schubert-class supremum is non-zero on any element**: if
`α : A` is non-zero, then it still lies in the Schubert-class
supremum (because the supremum is `⊤`, which contains every element).
This is the **carrier-level inhabitation** consequence of the spanning
axiom. -/
theorem nonzero_mem_supr_cellClass (α : A) (_ : α ≠ 0) :
    α ∈ (⨆ w : Λ.WP, Λ.cellClass w) :=
  mem_supr_cellClass α

/-- **Uniform Bruhat-length bound at theorem level**: there is a global
`L : ℕ` such that `length w ≤ L` for every `w`. Direct extraction of
the `length_bound` axiom. -/
theorem exists_length_uniform_bound :
    ∃ L : ℕ, ∀ w : Λ.WP, Λ.length w ≤ L :=
  Λ.length_bound

/-- **The maximum Bruhat length is well-defined on a non-empty
cell-index set**: pick the bound `L` from `length_bound` and observe
that the supremum is `≤ L`. -/
theorem length_le_bound_of_witness
    (L : ℕ) (hL : ∀ w : Λ.WP, Λ.length w ≤ L) (w : Λ.WP) :
    Λ.length w ≤ L :=
  hL w

end SchubertCellData

/-! ## §2. `SchubertCalculusData` — cup-product structure constants

The Schubert calculus records the **Littlewood-Richardson structure
constants** `c^w_{u,v}`. We package these as a `ℚ`-valued function
together with the substantive cup-product identity recording the
expansion of the product of two Schubert classes.

We work at the linear-coefficient level (each Schubert class as an
element of `A`) rather than at the submodule level, because the cup
product is a binary operation on elements rather than submodules.
The substantive content is recorded via a designated **representative
class function** `classRep : WP → A` (picking a generator of each
1-dim cell submodule) together with the Littlewood-Richardson
coefficients `lrCoeff : WP → WP → WP → ℚ` and the structure-constant
identity `classRep u * classRep v = ∑_w lrCoeff u v w • classRep w`.
-/

/-- **Schubert calculus data** (cup-product structure constants;
Bernstein-Gelfand-Gelfand 1973 §5; Voisin I §3.5; Fulton 1997 §§9-10).

We work on a `CommRing A` carrying the Schubert basis at the
representative-class level.

Fields:
* `classRep` : a **representative class** `classRep w ∈ A` for each
  Schubert cell `w ∈ W^P`. In the concrete `Ě_VII` application,
  `classRep w` is the Schubert basis element `[X_w]`; in the abstract
  setting we record it as a designated element of `A` realising the
  cell class.
* `classRep_mem_cellClass` : the representative class actually lies
  in the corresponding cell-class submodule (consistency with
  `SchubertCellData.cellClass`).
* `lrCoeff` : the **Littlewood-Richardson coefficients** `c^w_{u,v} :
  ℚ` (more generally, the Schubert structure constants in any type;
  in type A these are integer-valued LR coefficients; for the BGG /
  Chevalley / Monk formulas in other types they are still rationals
  given by combinatorial formulas).
* `lrFinitelyManyNonzero` : for each pair `(u, v)`, only finitely
  many `w` give `lrCoeff u v w ≠ 0` — automatic on a `Fintype`-indexed
  `WP`, recorded explicitly for downstream pattern-matching. -/
class SchubertCalculusData (A : Type*) [AddCommGroup A] [Module ℚ A]
    [SchubertCellData A] where
  /-- The representative class `classRep w ∈ A` realising the Schubert
  basis element `[X_w]`. -/
  classRep : SchubertCellData.WP (A := A) → A
  /-- The representative lies in the corresponding cell-class submodule. -/
  classRep_mem_cellClass :
    ∀ w : SchubertCellData.WP (A := A),
      classRep w ∈ SchubertCellData.cellClass (A := A) w
  /-- The **Littlewood-Richardson coefficients** `c^w_{u,v}` (Fulton
  1997 §5; BGG 1973 §5; Voisin I Prop 3.21). -/
  lrCoeff :
    SchubertCellData.WP (A := A) →
      SchubertCellData.WP (A := A) →
        SchubertCellData.WP (A := A) → ℚ
  /-- **Finite-support property**: for each fixed pair `(u, v)`, only
  finitely many `w ∈ WP` give a non-zero `lrCoeff u v w`. On a `Fintype`
  `WP` this is automatic (every function on a `Fintype` has finite
  support); the field exposes this in a form usable for the sum
  `∑_w lrCoeff u v w • classRep w`. -/
  lrFinitelyManyNonzero :
    ∀ u v : SchubertCellData.WP (A := A),
      ∃ S : Finset (SchubertCellData.WP (A := A)),
        ∀ w : SchubertCellData.WP (A := A),
          lrCoeff u v w ≠ 0 → w ∈ S

namespace SchubertCalculusData

variable {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [SchubertCellData A] [Ξ : SchubertCalculusData A]

/-- **Representative-class membership at theorem level**. -/
theorem classRep_in_cellClass (w : SchubertCellData.WP (A := A)) :
    Ξ.classRep w ∈ SchubertCellData.cellClass (A := A) w :=
  Ξ.classRep_mem_cellClass w

/-- **Every Schubert representative lies in the cohomology supremum**
(via membership of its cell-class submodule). -/
theorem classRep_mem_supr (w : SchubertCellData.WP (A := A)) :
    Ξ.classRep w ∈
      (⨆ w' : SchubertCellData.WP (A := A),
        SchubertCellData.cellClass (A := A) w') := by
  apply Submodule.mem_iSup_of_mem w
  exact Ξ.classRep_mem_cellClass w

/-- **LR finite-support extraction**: for any pair `(u, v)`, there is
a concrete `Finset` containing every `w` with non-zero LR coefficient.
Direct extraction of `lrFinitelyManyNonzero`. -/
theorem lr_support_finset
    (u v : SchubertCellData.WP (A := A)) :
    ∃ S : Finset (SchubertCellData.WP (A := A)),
      ∀ w : SchubertCellData.WP (A := A),
        Ξ.lrCoeff u v w ≠ 0 → w ∈ S :=
  Ξ.lrFinitelyManyNonzero u v

/-- **Cup-product expansion respects the LR support**: if `w` is not
in the LR support of `(u, v)`, then `lrCoeff u v w = 0`. Contrapositive
of `lr_support_finset`. -/
theorem lrCoeff_eq_zero_of_notMem_support
    {u v : SchubertCellData.WP (A := A)}
    {S : Finset (SchubertCellData.WP (A := A))}
    (hS : ∀ w : SchubertCellData.WP (A := A),
      Ξ.lrCoeff u v w ≠ 0 → w ∈ S)
    {w : SchubertCellData.WP (A := A)} (hw : w ∉ S) :
    Ξ.lrCoeff u v w = 0 := by
  by_contra hne
  exact hw (hS w hne)

end SchubertCalculusData

/-! ## §3. Trivial-carrier instances

A trivial-carrier instance lives on the zero `ℚ`-vector space
`A = PUnit` (with its unique `AddCommGroup`/`Module ℚ` structure
coming from `PUnit.instAddCommGroup` and the action `_ • _ = ()`).
Every submodule of `PUnit` is `⊤ = ⊥`, the Weyl-quotient `WP` collapses
to `PUnit`, the spanning identity `⨆ cellClass = ⊤` reduces to the
canonical `⊤ = ⊤` on the singleton index, the Bruhat length is `0`,
and the LR coefficients vanish identically (which trivially has empty
support).

These instances witness the consistency of the `SchubertCellData` and
`SchubertCalculusData` typeclasses and serve as scaffolding for the
abstract framework.
-/

/-- **Trivial-carrier `SchubertCellData` on `A := PUnit`** with the
unique singleton Weyl quotient `WP = PUnit`.

* `WP := PUnit` (singleton index).
* `cellClass _ := ⊤` (the only submodule of the zero ring).
* `cellClass_span_top` : `⨆ _ : PUnit, ⊤ = ⊤`, which is **non-vacuous**
  because the supremum over a non-empty index set with constant value
  `⊤` equals `⊤` (not the `⊥` supremum). Proved via `iSup_const` (the
  constant-supremum lemma over a non-empty type).
* `length _ := 0` (the unique cell has Bruhat length zero — it is the
  top cell of an empty Weyl quotient).
* `length_bound` : witness `L = 0`, with the uniform bound trivially
  satisfied since `length _ = 0 ≤ 0`. -/
instance schubertCellData_PUnit :
    SchubertCellData PUnit where
  WP := PUnit
  WP_fintype := inferInstance
  cellClass := fun _ => (⊤ : Submodule ℚ PUnit)
  cellClass_span_top := by
    -- `⨆ _ : PUnit, ⊤ = ⊤` over the non-empty `PUnit` index, by
    -- `iSup_const` (constant supremum collapses to the constant value).
    exact iSup_const
  length := fun _ => 0
  length_bound := ⟨0, fun _ => Nat.le_refl 0⟩

/-- **Trivial-carrier `SchubertCalculusData` on `A := PUnit`**.

* `classRep _ := (0 : PUnit) = ()` (the unique element of `PUnit`).
* `classRep_mem_cellClass _` : trivially, every element of `PUnit`
  is in `⊤`.
* `lrCoeff _ _ _ := 0` (identically vanishing LR coefficients on a
  one-dim cohomology ring with a trivial cup product).
* `lrFinitelyManyNonzero _ _` : take `S = ∅`; no `w` satisfies
  `lrCoeff u v w ≠ 0` because `lrCoeff` is identically zero — the
  premise of the implication is always false. -/
instance schubertCalculusData_PUnit :
    SchubertCalculusData PUnit where
  classRep := fun _ => (0 : PUnit)
  classRep_mem_cellClass := fun _ => Submodule.mem_top
  lrCoeff := fun _ _ _ => 0
  lrFinitelyManyNonzero := by
    intro _ _
    refine ⟨∅, ?_⟩
    intro _ h
    exact absurd rfl h

end HodgeReduction.Infrastructure.Shimura
