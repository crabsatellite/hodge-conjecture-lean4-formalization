/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Sum
import Mathlib.Data.Fintype.Sigma
import Mathlib.Tactic.FinCases

/-!
# The 27 vertices of `V₂₇` of `E₆` and the Schläfli graph `srg(27,10,1,5)`

This file provides a **concrete combinatorial model** of the 27-vertex
strongly regular graph `srg(27, 10, 1, 5)` (the complement of the
classical Schläfli graph), via the *Schläfli double-six* structure of
the 27 lines on a smooth cubic surface, or equivalently the 27 weights
of the minuscule representation `V₂₇` of the exceptional Lie algebra
`E₆`.

## Main definitions

* `V27Vertex` — an inductive type with 27 vertices partitioned
  6 + 6 + 15 as `a i`, `b i` (`i : Fin 6`), and `c {i, j}` (unordered
  pair, `i ≠ j`).

* `isTriangleEdge` — the adjacency predicate of the triangle graph
  `srg(27, 10, 1, 5)` (edges correspond to pairs of weights with
  inner product `-2/3`, equivalently to intersecting lines in the
  27-line configuration).

* `schlafliComplementGraph` — the `SimpleGraph V27Vertex` carrying
  this adjacency.

## Adjacency rules (Schläfli-complement = triangle graph)

* `a i ~ b j  ↔  i ≠ j`           (5 edges per `a i`, 5 per `b j`)
* `a i ~ c {j,k}  ↔  i ∈ {j, k}`  (5 edges per `a i`, 2 per `c _`)
* `b i ~ c {j,k}  ↔  i ∈ {j, k}`  (5 edges per `b i`, 2 per `c _`)
* `c {i,j} ~ c {k,l}  ↔  {i,j} ∩ {k,l} = ∅`
                                  (6 edges per `c _`)
* No edges among the `a`s (`aᵢ` and `aⱼ` are mutually skew).
* No edges among the `b`s (similar).

Valences (Schläfli-complement = triangle graph):
* `a i`: meets 5 `b`'s (those with `j ≠ i`) + 5 `c`'s (those containing `i`) = 10.
* `b i`: symmetric, 5 + 5 = 10.
* `c {i,j}`: 2 `a`'s + 2 `b`'s + 6 `c`'s = 10.

## References

* L. Schläfli, *Quart. J. Pure Appl. Math.* **2** (1858).
* R. Carter, *Simple Groups of Lie Type*, Wiley 1972, §12.
* P. Cameron, J. van Lint, *Designs, Graphs, Codes and their Links*,
  LMS Student Texts **22** (1991), §10.2.

## Tags

Schläfli graph, strongly regular graph, 27 lines, cubic surface,
E_6, minuscule representation
-/

namespace HodgeReduction.Infrastructure

/-! ### Vertex type for the 27-line configuration -/

/-- An unordered pair of distinct elements of `Fin 6`. Represented as
an ordered pair `(fst, snd)` with `fst < snd` for canonicity. -/
structure UPair6 where
  fst : Fin 6
  snd : Fin 6
  lt : fst < snd
deriving DecidableEq

namespace UPair6

/-- Membership in an unordered pair. -/
def mem (i : Fin 6) (p : UPair6) : Bool :=
  decide (i = p.fst) || decide (i = p.snd)

/-- Two unordered pairs of distinct elements are disjoint iff none of
their endpoints coincide. -/
def disjoint (p q : UPair6) : Bool :=
  !(decide (p.fst = q.fst) || decide (p.fst = q.snd) ||
    decide (p.snd = q.fst) || decide (p.snd = q.snd))

/-- Disjointness of unordered pairs is symmetric. -/
theorem disjoint_symm (p q : UPair6) : disjoint p q = disjoint q p := by
  simp only [disjoint]
  by_cases h1 : p.fst = q.fst <;> by_cases h2 : p.fst = q.snd <;>
    by_cases h3 : p.snd = q.fst <;> by_cases h4 : p.snd = q.snd <;>
    simp_all <;> tauto

end UPair6

/-- The 27 vertices of the `V₂₇` configuration, partitioned `6 + 6 + 15`. -/
inductive V27Vertex
  /-- One of the six `a` vertices (mutually skew lines). -/
  | a : Fin 6 → V27Vertex
  /-- One of the six `b` vertices. -/
  | b : Fin 6 → V27Vertex
  /-- One of the fifteen `c {i,j}` vertices. -/
  | c : UPair6 → V27Vertex
deriving DecidableEq

namespace V27Vertex

/-- The **triangle-graph adjacency** for the 27-line configuration
(= Schläfli-complement, with parameters `srg(27, 10, 1, 5)`). -/
def isTriangleEdge : V27Vertex → V27Vertex → Bool
  | a _, a _ => false
  | a i, b j => decide (i ≠ j)
  | a i, c p => UPair6.mem i p
  | b i, a j => decide (i ≠ j)
  | b _, b _ => false
  | b i, c p => UPair6.mem i p
  | c p, a i => UPair6.mem i p
  | c p, b i => UPair6.mem i p
  | c p, c q => UPair6.disjoint p q

/-- The triangle-graph adjacency is symmetric. -/
theorem isTriangleEdge_symm (u v : V27Vertex) :
    isTriangleEdge u v = isTriangleEdge v u := by
  match u, v with
  | a _, a _ => rfl
  | a i, b j =>
    show decide (i ≠ j) = decide (j ≠ i)
    by_cases h : i = j
    · simp [h]
    · simp [h, Ne.symm h]
  | a _, c _ => rfl
  | b i, a j =>
    show decide (i ≠ j) = decide (j ≠ i)
    by_cases h : i = j
    · simp [h]
    · simp [h, Ne.symm h]
  | b _, b _ => rfl
  | b _, c _ => rfl
  | c _, a _ => rfl
  | c _, b _ => rfl
  | c p, c q => exact UPair6.disjoint_symm p q

/-- The triangle-graph adjacency is irreflexive. -/
theorem isTriangleEdge_irrefl (v : V27Vertex) :
    isTriangleEdge v v = false := by
  match v with
  | a _ => rfl
  | b _ => rfl
  | c p =>
    show UPair6.disjoint p p = false
    simp [UPair6.disjoint]

end V27Vertex

/-! ### The graph as a Mathlib `SimpleGraph` -/

/-- The Schläfli-complement graph (= triangle graph) `srg(27, 10, 1, 5)`
on `V27Vertex`. -/
def schlafliComplementGraph : SimpleGraph V27Vertex where
  Adj u v := V27Vertex.isTriangleEdge u v = true
  symm := fun {u v} (h : V27Vertex.isTriangleEdge u v = true) =>
    show V27Vertex.isTriangleEdge v u = true by
      rw [V27Vertex.isTriangleEdge_symm v u]
      exact h
  loopless := fun v (h : V27Vertex.isTriangleEdge v v = true) => by
    have hf : V27Vertex.isTriangleEdge v v = false := V27Vertex.isTriangleEdge_irrefl v
    rw [hf] at h
    exact Bool.false_ne_true h

/-- Adjacency in `schlafliComplementGraph` is decidable. -/
instance : DecidableRel schlafliComplementGraph.Adj := fun u v =>
  inferInstanceAs (Decidable (V27Vertex.isTriangleEdge u v = true))

/-! ### Cardinality: `|V₂₇| = 27`

The 27 vertices of `V₂₇` are partitioned as `6 + 6 + 15 = 27`. This is
provable by `decide` once we equip the inductive type with a `Fintype`
instance. The `Fintype` derivation is straightforward via the
`Fin 6 ⊕ Fin 6 ⊕ UPair6` decomposition.
-/

namespace UPair6

/-- The bijection between `UPair6` and the subtype `{p : Fin 6 × Fin 6 // p.1 < p.2}`. -/
def equivSubtype : UPair6 ≃ {p : Fin 6 × Fin 6 // p.1 < p.2} where
  toFun := fun u => ⟨(u.fst, u.snd), u.lt⟩
  invFun := fun ⟨p, hp⟩ => ⟨p.1, p.2, hp⟩
  left_inv := fun _ => rfl
  right_inv := fun _ => rfl

/-- `UPair6` is a finite type with 15 elements. -/
instance : Fintype UPair6 := Fintype.ofEquiv _ equivSubtype.symm

/-- Cardinality check: `|UPair6| = 15` (= "6 choose 2"). -/
theorem card_eq_15 : Fintype.card UPair6 = 15 := by decide

end UPair6

/-! ### `V27Vertex` cardinality -/

namespace V27Vertex

/-- The bijection `V27Vertex ≃ Fin 6 ⊕ Fin 6 ⊕ UPair6` (= 6 + 6 + 15 = 27). -/
def equivSum : V27Vertex ≃ Fin 6 ⊕ Fin 6 ⊕ UPair6 where
  toFun
    | .a i => .inl i
    | .b i => .inr (.inl i)
    | .c p => .inr (.inr p)
  invFun
    | .inl i => .a i
    | .inr (.inl i) => .b i
    | .inr (.inr p) => .c p
  left_inv := fun v => by cases v <;> rfl
  right_inv := fun v => by
    rcases v with _ | _ | _
    · rfl
    · rfl
    · rfl

/-- `V27Vertex` is a finite type. -/
instance : Fintype V27Vertex := Fintype.ofEquiv _ equivSum.symm

/-- The cardinality of `V27Vertex` is `27 = 6 + 6 + 15`. -/
theorem card_eq_27 : Fintype.card V27Vertex = 27 := by
  rw [Fintype.card_congr equivSum]
  simp [Fintype.card_sum, UPair6.card_eq_15]

end V27Vertex

end HodgeReduction.Infrastructure
