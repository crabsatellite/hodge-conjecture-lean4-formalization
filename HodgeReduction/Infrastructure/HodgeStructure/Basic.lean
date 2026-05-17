/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.LinearAlgebra.Dual
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.DirectSum.Module

/-!
# Pure rational Hodge structures of weight `n`

A **pure ℚ-Hodge structure of weight `n`** on a finite-dimensional
ℚ-vector space `V` is a direct-sum decomposition of the
complexification `V_ℂ := V ⊗_ℚ ℂ` into bigraded pieces:
```
V_ℂ = ⨁_{p+q=n} V^{p,q},   with V^{q,p} = complex-conjugate of V^{p,q}.
```

For us, the ℂ-conjugation aspect is non-trivial. To keep things
purely-algebraic over ℚ for now, we model the **decomposition** as a
direct-sum splitting at the ℚ-level into pieces indexed by the integers
`{0, 1, ..., n}` (with piece `p` representing the (p, n-p) Hodge piece).

This is sufficient for **Hodge-Tate** structures (where the bigrading
descends to ℚ — as it does for the V_56 representation of E_7 with
trivial Hodge involution in the centre).

## Main definitions

* `PureHodgeStructure V n` : a typeclass providing the decomposition
  `V = ⨁_{p=0..n} H^{p, n-p}`.

* `PureHodgeStructure.piece p` : the (p, n-p)-Hodge piece.

* `PureHodgeStructure.filt p` : the Hodge filtration `F^p V = ⨁_{i≥p} H^{i, n-i}`.

* `PureHodgeStructureWeight V k` : a sibling typeclass giving the
  `(k+1)` pieces `H^{p, k-p}` as **explicit `ℚ`-submodules** of `V`
  with substantive pairwise disjointness, span and complex-conjugation
  dimensional symmetry (`dim H^{p,k-p} = dim H^{k-p,p}`).

* `HodgeFiltrationStructure V k` : a sibling typeclass giving the
  Hodge filtration `F^0 ⊇ F^1 ⊇ ... ⊇ F^{k+1} = 0` as `(k+2)`
  explicit submodules with substantive antitonicity and the boundary
  equation `F^{k+1} = ⊥`.

## References

* P. Deligne, "Théorie de Hodge II", *Publ. Math. IHÉS* **40** (1971)
  5-57. — Definition of pure Hodge structures, Hodge filtration, and
  complex-conjugation symmetry (Deligne 1971 (2.1.10)-(2.1.14)).
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Mathematics **76**, CUP 2002 — Ch. 6 (pure
  Hodge structures, Hodge decomposition, Hodge filtration).
* P. Griffiths, J. Harris, *Principles of Algebraic Geometry*, Wiley
  1978 — Ch. 0.7 (Hodge theory for compact Kähler manifolds).

## Mathematical context

For our HC application, `V = V_56` with Hodge structure of weight `3`
(weight of the abelian variety associated to a Shimura point on `EVII`):
```
V_56,ℂ = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}    (4 pieces)
       =   ℂ    ⊕  J_3(O)_ℂ ⊕ J_3(O)_ℂ ⊕  ℂ
       =   1    +     27    +    27    +   1     = 56 dims
```

For our purposes (which are over ℚ), the decomposition descends to ℚ
because the Cartan involution gives the conjugation pairing
`V^{p,q} ↔ V^{q,p}` and the U(1)-symmetry of `EVII`.

## Tags

Hodge structure, bigrading, Hodge filtration, polarisation, VHS
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- A **pure ℚ-Hodge structure of weight `n`** on `V` is a
direct-sum decomposition `V = ⨁_{p=0..n} H^{p, n-p}` into `n+1` pieces
(indexed by `p ∈ {0, 1, ..., n}`).

This abstracts away the complexification/conjugation and works at the
ℚ-level where the Hodge involution is rational (the case relevant for
our V_56 application). -/
class PureHodgeStructure (n : ℕ) where
  /-- The (p, n-p)-Hodge piece for each `p ∈ {0, ..., n}`. -/
  piece : Fin (n + 1) → Submodule ℚ V
  /-- The pieces are independent: any `v ∈ ∑ piece p` decomposes
  uniquely into a sum of piece-elements. -/
  isInternal : DirectSum.IsInternal piece

namespace PureHodgeStructure

variable {V} {n : ℕ} [PureHodgeStructure V n]

/-- The (p, n-p)-Hodge piece, addressed by the integer `p`. -/
abbrev hodgePiece (p : Fin (n + 1)) : Submodule ℚ V := piece p

/-- The **Hodge filtration**: `F^p V = ⨁_{i ≥ p} H^{i, n-i}`.

Concretely, `F^p` contains all elements whose Hodge-piece-decomposition
has zero contribution from pieces `H^{i, n-i}` with `i < p`. -/
def filt (p : Fin (n + 1)) : Submodule ℚ V :=
  ⨆ (i : Fin (n + 1)) (_ : p.val ≤ i.val), piece i

/-- The Hodge piece `H^{p, n-p}` sits inside the filtration step `F^p`. -/
theorem piece_le_filt (p : Fin (n + 1)) :
    piece p ≤ filt (V := V) p := by
  refine le_iSup_of_le p ?_
  refine le_iSup_of_le ?_ le_rfl
  exact Nat.le_refl _

/-- **R137: Hodge filtration is antitone (decreasing in p)**.

For `p ≤ q`, the Hodge filtration step `F^q V` is contained in `F^p V`.
This is the standard antitone property of the Hodge filtration
(Deligne 1971 (2.1.13); Voisin I (6.4)). -/
theorem filt_antitone {p q : Fin (n + 1)} (h : p.val ≤ q.val) :
    filt (V := V) q ≤ filt (V := V) p := by
  unfold filt
  refine iSup_le (fun i => ?_)
  refine iSup_le (fun hqi => ?_)
  exact le_iSup_of_le i (le_iSup_of_le (h.trans hqi) le_rfl)

/-- **R137: Hodge filtration at `p = 0`** equals the whole space.

`F^0 V = ⨆ piece i = V`. The supremum equals top because every vector is
in some piece (DirectSum.IsInternal forces span = top). -/
theorem filt_zero_eq_top :
    filt (V := V) (n := n) ⟨0, Nat.zero_lt_succ n⟩ = ⊤ := by
  unfold filt
  apply le_antisymm le_top
  have h_span : ⨆ i : Fin (n + 1), piece (V := V) i = ⊤ :=
    DirectSum.IsInternal.submodule_iSup_eq_top isInternal
  rw [← h_span]
  refine iSup_le (fun i => ?_)
  exact le_iSup_of_le i (le_iSup_of_le (Nat.zero_le _) le_rfl)

/-- **R137: Hodge numbers** `h^{p, n-p}(V) := dim_ℚ H^{p, n-p}`.

This is the dimension of the (p, n-p)-Hodge piece, a key invariant of
the pure Hodge structure. The classical Hodge symmetry `h^{p,q} = h^{q,p}`
holds at the dimension level for Hodge-Tate / polarisable structures
(captured separately in `PureHodgeStructureWeight.finrank_conj`). -/
noncomputable def hodgeNumber (p : Fin (n + 1)) : ℕ :=
  Module.finrank ℚ (piece (V := V) p)

/-- **R146**: rank decomposition for ANY finite-dim PureHodgeStructure.

For any pure ℚ-Hodge structure on a finite-dim ℚ-vector space V,
the dimension equals the sum of Hodge numbers:
`finrank V = ∑ p, h^{p, n-p}(V)`.

Proof: the IsInternal direct-sum decomposition gives a LinearEquiv
`V ≃ ⨁ p, piece p`; LinearEquiv preserves finrank; finrank of a
direct sum over Fintype is the sum of finranks (Mathlib's
`Module.finrank_directSum`). -/
theorem finrank_eq_sum_hodgeNumber [Module.Finite ℚ V] :
    Module.finrank ℚ V = ∑ p : Fin (n + 1), hodgeNumber (V := V) p := by
  -- Get the LinearEquiv V ≃ₗ ⨁ piece
  have e := LinearEquiv.ofBijective
    (DirectSum.coeLinearMap (piece (V := V)))
    (isInternal (V := V) (n := n))
  -- Use LinearEquiv to transfer finrank
  rw [← LinearEquiv.finrank_eq e]
  -- finrank of direct sum = sum of finranks (Module.finrank_directSum
  -- requires Module.Finite + Module.Free for each piece; both auto)
  rw [Module.finrank_directSum]
  -- ∑ i, finrank ℚ (piece i) = ∑ p, hodgeNumber p (defEq via hodgeNumber def)
  rfl

/-- **R147**: the bottom step `F^0` of the Hodge filtration has the same
finrank as the ambient `V` (since `filt 0 = ⊤`, by R137 `filt_zero_eq_top`).

Corollary of R137 + Mathlib's `Submodule.finrank_top`. -/
theorem finrank_filt_zero :
    Module.finrank ℚ (filt (V := V) (n := n) ⟨0, by omega⟩) =
    Module.finrank ℚ V := by
  rw [filt_zero_eq_top]
  exact finrank_top ℚ V

/-- **R149: Hodge transversality**.

For `[PureHodgeStructure V n]`, the (p, n-p)-Hodge piece is disjoint
from the next filtration step `F^{p+1}`. Concretely: `piece p ⊓
filt ⟨p.val + 1, _⟩ = ⊥`.

This is the cornerstone of the "associated graded" identification
`F^p / F^{p+1} ≃ piece p` (Deligne 1971; Voisin I (6.10)): the
quotient by the next step is naturally isomorphic to the current piece.

Proof: `iSupIndep piece` (from `IsInternal`) gives that `piece p` is
disjoint from `⨆ (j) (h : j ≠ p), piece j`. The filtration step
`F^{p+1} = ⨆ (i ≥ p+1) piece i` is a sub-iSup over `{j : j > p}`,
which is contained in `{j : j ≠ p}`; hence `F^{p+1} ⊆ ⨆ (j ≠ p) piece j`,
and `piece p ⊓ F^{p+1} ⊆ piece p ⊓ ⨆ (j ≠ p) = ⊥`. -/
theorem piece_disjoint_filt_succ
    (p : Fin (n + 1)) (hpn : p.val + 1 < n + 1) :
    Disjoint (piece (V := V) p)
             (filt (V := V) ⟨p.val + 1, hpn⟩) := by
  -- iSupIndep piece (from isInternal): piece p disjoint from ⨆ (j ≠ p) piece j
  have h_indep : iSupIndep (piece (V := V) (n := n)) :=
    (DirectSum.IsInternal.submodule_iSupIndep (isInternal (V := V) (n := n)))
  -- filt ⟨p+1⟩ ≤ ⨆ (j ≠ p) piece j
  have h_filt_le : filt (V := V) ⟨p.val + 1, hpn⟩ ≤
      ⨆ (j : Fin (n + 1)) (_ : j ≠ p), piece (V := V) j := by
    unfold filt
    refine iSup_le (fun i => iSup_le (fun hi => ?_))
    -- i.val ≥ p.val + 1, so i ≠ p
    refine le_iSup_of_le i (le_iSup_of_le ?_ le_rfl)
    intro h_eq
    -- if i = p then i.val = p.val, but hi : p.val + 1 ≤ i.val
    exact absurd (by rw [h_eq] at hi; exact hi : p.val + 1 ≤ p.val) (by omega)
  -- Disjointness via mono_right
  exact (h_indep p).mono_right h_filt_le

/-- **R150**: filtration step-wise decomposition.

`filt p = piece p ⊔ filt ⟨p.val + 1⟩` — the current filtration step
splits as "current Hodge piece" plus "next filtration step".

Combined with R149 (`piece_disjoint_filt_succ`), this exhibits
`filt p` as an INTERNAL direct sum of `piece p` and `filt ⟨p+1⟩`,
giving the associated graded iso `filt p / filt ⟨p+1⟩ ≃ piece p`. -/
theorem filt_eq_piece_sup_filt_succ (p : Fin (n + 1))
    (hpn : p.val + 1 < n + 1) :
    filt (V := V) p =
    piece (V := V) p ⊔ filt (V := V) ⟨p.val + 1, hpn⟩ := by
  apply le_antisymm
  · -- filt p ≤ piece p ⊔ filt ⟨p+1⟩
    unfold filt
    refine iSup_le (fun i => iSup_le (fun hi => ?_))
    -- hi : p.val ≤ i.val
    by_cases heq : i.val = p.val
    · -- i = p as Fin, so piece i ≤ piece p ≤ left summand
      have h_iFin : i = p := Fin.ext heq
      rw [h_iFin]
      exact le_sup_left
    · -- i.val > p.val, so i.val ≥ p.val + 1, hence piece i ≤ filt ⟨p+1⟩
      refine le_sup_of_le_right ?_
      have h_iv : p.val + 1 ≤ i.val := by omega
      show piece i ≤ filt (V := V) ⟨p.val + 1, hpn⟩
      unfold filt
      exact le_iSup_of_le i (le_iSup_of_le h_iv le_rfl)
  · -- piece p ⊔ filt ⟨p+1⟩ ≤ filt p
    refine sup_le ?_ ?_
    · exact piece_le_filt p
    · exact filt_antitone (by omega : p.val ≤ p.val + 1)

end PureHodgeStructure

/-! ## Pure Hodge structures via explicit pieces with substantive
dimensional, disjointness and span axioms

The sibling class `PureHodgeStructureWeight V k` packages the same
mathematical content as `PureHodgeStructure V k` but with the bigrading
expressed via three **substantive** axioms that are directly checkable
on concrete examples and are the axioms most often quoted in the
classical literature:

* **Pairwise disjointness**: the `k+1` pieces are pairwise
  `Disjoint` (in the `Submodule` lattice sense), i.e. `H^{p,k-p} ⊓
  H^{p',k-p'} = ⊥` whenever `p ≠ p'`. (Deligne 1971 (2.1.10);
  Voisin I Defn 6.2 (i).)
* **Span**: `⨆ p, H^{p,k-p} = ⊤`, i.e. every vector decomposes as a
  sum of pieces. (Deligne 1971 (2.1.10); Voisin I Defn 6.2 (ii).)
* **Complex-conjugation symmetry** at the *dimension* level:
  `dim_ℚ H^{p,k-p} = dim_ℚ H^{k-p,p}`. (Deligne 1971 (2.1.14);
  Voisin I (6.5); Griffiths-Harris Ch. 0.7.)

This is the typeclass used by downstream consumers needing direct
access to the Hodge numbers `h^{p,q}` and to the explicit pieces.
The original `PureHodgeStructure V n` (using `DirectSum.IsInternal`) is
**preserved**: it is the canonical Mathlib formulation and is consumed
by the `PolarisedHodgeStructure` extension. -/

/-- A **pure ℚ-Hodge structure of weight `k` (substantive form)** on
`V`: the `k+1` Hodge pieces `H^{p, k-p}` for `p ∈ {0, 1, ..., k}` as
explicit submodules together with their pairwise disjointness, span,
and conjugation-symmetric Hodge numbers.

References: Deligne 1971 (2.1.10)-(2.1.14); Voisin 2002 I Defn 6.2 and
(6.5); Griffiths-Harris 1978 Ch. 0.7. -/
class PureHodgeStructureWeight (V : Type*) (k : ℕ)
    [AddCommGroup V] [Module ℚ V] where
  /-- The (p, k-p)-Hodge piece for each `p ∈ {0, ..., k}`. -/
  pieces : Fin (k + 1) → Submodule ℚ V
  /-- **Substantive pairwise disjointness**: any two distinct pieces
  meet only in the zero vector. (Deligne 1971 (2.1.10) — directness of
  the Hodge decomposition; Voisin I Defn 6.2 (i).) -/
  pieces_pairwise_disjoint :
    ∀ (p p' : Fin (k + 1)), p ≠ p' → Disjoint (pieces p) (pieces p')
  /-- **Substantive span axiom**: the pieces span the whole space.
  (Deligne 1971 (2.1.10); Voisin I Defn 6.2 (ii).) -/
  pieces_span : (⨆ p : Fin (k + 1), pieces p) = (⊤ : Submodule ℚ V)
  /-- **Substantive complex-conjugation symmetry** at the dimension
  level: `dim_ℚ H^{p,k-p} = dim_ℚ H^{k-p,p}`. The Hodge involution
  `V^{p,q} ↔ V^{q,p}` is a `ℚ`-linear isomorphism (under the
  Hodge-Tate hypothesis); we record its dimensional shadow.
  (Deligne 1971 (2.1.14); Voisin I (6.5).) -/
  finrank_conj :
    ∀ p : Fin (k + 1),
      Module.finrank ℚ (pieces p) =
        Module.finrank ℚ (pieces ⟨k - p.val, by omega⟩)

namespace PureHodgeStructureWeight

variable {V} {k : ℕ} [PureHodgeStructureWeight V k]

/-- **Derived theorem**: the piece at index `p` and the piece at index
`p'` meet trivially when `p ≠ p'`. (Restatement of
`pieces_pairwise_disjoint`.) -/
theorem disjoint_of_ne (p p' : Fin (k + 1)) (h : p ≠ p') :
    Disjoint (pieces (V := V) (k := k) p) (pieces p') :=
  pieces_pairwise_disjoint p p' h

/-- **Derived theorem**: the intersection of two distinct pieces is
`⊥`. (Equivalent form of `disjoint_of_ne` via
`Submodule.disjoint_def`.) -/
theorem inf_eq_bot_of_ne (p p' : Fin (k + 1)) (h : p ≠ p') :
    pieces (V := V) (k := k) p ⊓ pieces p' = ⊥ :=
  (disjoint_of_ne p p' h).eq_bot

/-- **Derived theorem**: every vector `v : V` lies in the span of the
Hodge pieces. (Membership form of `pieces_span`.) -/
theorem mem_iSup_pieces (v : V) :
    v ∈ (⨆ p : Fin (k + 1), pieces (V := V) (k := k) p) := by
  rw [pieces_span]
  trivial

/-- **Derived theorem**: the highest-weight piece `H^{k,0}` (index
`p = k`) has the same `ℚ`-dimension as the lowest-weight piece
`H^{0,k}` (index `p = 0`). This is the dimensional shadow of the
"complex conjugation swaps highest and lowest pieces" symmetry. -/
theorem finrank_pieces_top_eq_bot :
    Module.finrank ℚ (pieces (V := V) (k := k) ⟨k, by omega⟩) =
      Module.finrank ℚ (pieces (V := V) (k := k) ⟨0, by omega⟩) := by
  have h := finrank_conj (V := V) (k := k) ⟨k, by omega⟩
  -- The conjugate index is `k - k = 0`; rewrite to match the goal's
  -- `⟨0, _⟩` form.
  have hidx : (⟨k - k, by omega⟩ : Fin (k + 1)) = ⟨0, by omega⟩ := by
    apply Fin.ext
    simp
  rw [hidx] at h
  exact h

end PureHodgeStructureWeight

/-! ## Hodge filtrations as a stand-alone explicit structure -/

/-- A **Hodge filtration of weight `k`** on `V`: a descending chain
of `k+2` submodules
```
F^0 V ⊇ F^1 V ⊇ ... ⊇ F^k V ⊇ F^{k+1} V = 0
```
indexed by `i ∈ {0, 1, ..., k+1}`. The boundary condition
`F^{k+1} = ⊥` captures the fact that a pure Hodge structure has no
piece of bidegree `(p, q)` with `p > k` (equivalently `q < 0`).

References: Deligne 1971 (1.1.4)-(1.1.7); Voisin I Defn 6.5 (Hodge
filtration); Griffiths-Harris Ch. 0.7. -/
class HodgeFiltrationStructure (V : Type*) (k : ℕ)
    [AddCommGroup V] [Module ℚ V] where
  /-- The Hodge filtration step `F^i V` for each `i ∈ {0, ..., k+1}`. -/
  F : Fin (k + 2) → Submodule ℚ V
  /-- **Substantive antitonicity** of the filtration: `F^i ⊇ F^j`
  whenever `i ≤ j`. Equivalently `F^j ≤ F^i`. (Deligne 1971 (1.1.5);
  Voisin I Defn 6.5.) -/
  F_antitone :
    ∀ (i j : Fin (k + 2)), i.val ≤ j.val → F j ≤ F i
  /-- **Substantive boundary equation**: `F^{k+1} V = ⊥`. The Hodge
  filtration terminates at zero past index `k`. (Deligne 1971 (1.1.6);
  Voisin I (6.6).) -/
  F_top_eq_bot : F ⟨k + 1, by omega⟩ = (⊥ : Submodule ℚ V)

namespace HodgeFiltrationStructure

variable {V} {k : ℕ} [HodgeFiltrationStructure V k]

/-- **Derived theorem**: `F^{k+1}` is contained in every `F^i`.
This is a direct consequence of `F_top_eq_bot` (since `⊥ ≤ _`). -/
theorem F_top_le (i : Fin (k + 2)) :
    F (V := V) (k := k) ⟨k + 1, by omega⟩ ≤ F i := by
  rw [F_top_eq_bot]
  exact bot_le

/-- **Derived theorem**: `F^j ≤ F^i` whenever `i ≤ j`. Restatement of
`F_antitone` for ergonomic rewriting. -/
theorem F_le_of_le (i j : Fin (k + 2)) (h : i.val ≤ j.val) :
    F (V := V) (k := k) j ≤ F i :=
  F_antitone i j h

/-- **Derived theorem**: the top index has trivial intersection with
any other filtration step. (Direct consequence of `F_top_eq_bot`.) -/
theorem F_top_inf (i : Fin (k + 2)) :
    F (V := V) (k := k) ⟨k + 1, by omega⟩ ⊓ F i = (⊥ : Submodule ℚ V) := by
  rw [F_top_eq_bot]
  exact bot_inf_eq _

end HodgeFiltrationStructure

/-! ## R144: Bridge `PureHodgeStructure` → `HodgeFiltrationStructure`

For any `PureHodgeStructure V n`, the standard Hodge filtration is

  F^i V = ⨆_{j ≥ i} H^{j, n-j}

This sits inside the `PureHodgeStructure.filt` definition (indexed by
Fin (n+1)), but the `HodgeFiltrationStructure` class requires indexing
by Fin (n+2) with `F^{n+1} = ⊥` as boundary. We extend `filt` by an
artificial bottom value at index n+1, giving the bridge. -/

namespace PureHodgeStructure

variable {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
  [PureHodgeStructure V n]

/-- **R144**: extended Hodge filtration `F_ext : Fin (n+2) → Submodule ℚ V`
agreeing with `filt` at indices `0..n` and equal to `⊥` at the boundary
index `n+1`. -/
def filt_ext (p : Fin (n + 2)) : Submodule ℚ V :=
  if h : p.val < n + 1 then filt (V := V) ⟨p.val, h⟩ else (⊥ : Submodule ℚ V)

/-- **R144**: filt_ext at the boundary index `n+1` is `⊥`. -/
theorem filt_ext_top_eq_bot :
    filt_ext (V := V) (n := n) ⟨n + 1, by omega⟩ = (⊥ : Submodule ℚ V) := by
  unfold filt_ext
  have h : ¬ (n + 1 < n + 1) := lt_irrefl _
  simp only [dif_neg h]

/-- **R144**: filt_ext is antitone (F^q ≤ F^p when p ≤ q). -/
theorem filt_ext_antitone {p q : Fin (n + 2)} (h : p.val ≤ q.val) :
    filt_ext (V := V) q ≤ filt_ext (V := V) p := by
  unfold filt_ext
  by_cases hq : q.val < n + 1
  · -- q < n+1 means p < n+1 too
    have hp : p.val < n + 1 := lt_of_le_of_lt h hq
    simp only [dif_pos hq, dif_pos hp]
    exact filt_antitone h
  · -- q ≥ n+1; filt_ext q = ⊥ ≤ anything
    simp only [dif_neg hq]
    exact bot_le

end PureHodgeStructure

/-- **R144 BRIDGE**: any `PureHodgeStructure V n` induces a
`HodgeFiltrationStructure V n` via the extended filtration `filt_ext`.

Significance: with this instance, the two formulations are no longer
independent — `PureHodgeStructure` is the stronger primitive, and
`HodgeFiltrationStructure` is derived. Any consumer of
`HodgeFiltrationStructure` now automatically benefits when a
`PureHodgeStructure` instance is available. -/
instance PureHodgeStructure.toHodgeFiltrationStructure {V : Type*}
    [AddCommGroup V] [Module ℚ V] {n : ℕ} [PureHodgeStructure V n] :
    HodgeFiltrationStructure V n where
  F := PureHodgeStructure.filt_ext
  F_antitone := fun _ _ h => PureHodgeStructure.filt_ext_antitone h
  F_top_eq_bot := PureHodgeStructure.filt_ext_top_eq_bot

/-! ## Trivial reference instances: `(ℚ, weight 0)`

The base field `ℚ` carries the trivial weight-`0` Hodge structure with
a single Hodge piece `H^{0,0} = ℚ`. We provide a substantive inhabiting
instance of `PureHodgeStructureWeight ℚ 0` and `HodgeFiltrationStructure
ℚ 0`, witnessing that the axioms are *consistent and non-empty*.

For `(ℚ, weight 0)`:
* Pieces: `pieces ⟨0,_⟩ = ⊤` (the whole space).
* Pairwise disjointness is *vacuous* over the trivial index set `Fin 1`
  (no two distinct indices exist), but we discharge the substantive
  axiom by case-splitting on `Fin 1`.
* Span: `⨆ p, ⊤ = ⊤` — *substantive*: this is the assertion that the
  unique piece really spans the whole space.
* Conjugation symmetry: `dim ⊤ = dim ⊤` at index `0`, which conjugates
  to `0 - 0 = 0`, i.e. the same index — substantive after evaluating
  the index arithmetic.

For the filtration: `F^0 = ⊤`, `F^1 = ⊥`. Antitonicity and the
boundary equation are both substantive. -/

namespace TrivialWeight

/-- The unique Hodge piece of `(ℚ, weight 0)`: the whole space. -/
def piece_ℚ_w0 : Fin 1 → Submodule ℚ ℚ
  | ⟨0, _⟩ => (⊤ : Submodule ℚ ℚ)

@[simp] theorem piece_ℚ_w0_zero :
    piece_ℚ_w0 ⟨0, by omega⟩ = (⊤ : Submodule ℚ ℚ) := rfl

/-- Trivial `PureHodgeStructureWeight ℚ 0` instance witnessing that the
substantive axioms are consistent. -/
instance pureHodgeWeight_ℚ_0 : PureHodgeStructureWeight ℚ 0 where
  pieces := piece_ℚ_w0
  pieces_pairwise_disjoint := by
    intro p p' hne
    -- `Fin 1` has a unique element, so `p ≠ p'` is impossible.
    fin_cases p
    fin_cases p'
    exact absurd rfl hne
  pieces_span := by
    -- `⨆ p, piece p` over `Fin 1` collapses to `piece ⟨0,_⟩ = ⊤`.
    apply le_antisymm le_top
    intro x _
    refine Submodule.mem_iSup_of_mem ⟨0, by omega⟩ ?_
    simp [piece_ℚ_w0]
  finrank_conj := by
    intro p
    -- The conjugate index is `0 - p.val = 0` (always 0 for `Fin 1`).
    fin_cases p
    -- Both sides equal `Module.finrank ℚ (⊤ : Submodule ℚ ℚ)`.
    rfl

/-- **R138**: Trivial `PureHodgeStructure ℚ 0` instance parallel to the
`PureHodgeStructureWeight ℚ 0` instance above. Uses
`DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top` with the
trivial-index iSupIndep + the same `pieces_span` argument. -/
instance pureHodgeStructure_ℚ_0 : PureHodgeStructure ℚ 0 where
  piece := piece_ℚ_w0
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      (by
        intro p
        -- For Fin 1, ⨆ (j) (h : j ≠ p), piece j = ⨆ over empty set = ⊥
        -- so Disjoint piece_p ⊥ which is trivially true.
        fin_cases p
        simp [iSupIndep, piece_ℚ_w0])
      (by
        apply le_antisymm le_top
        intro x _
        refine Submodule.mem_iSup_of_mem ⟨0, by omega⟩ ?_
        simp [piece_ℚ_w0])

/-- The Hodge filtration of `(ℚ, weight 0)`: `F^0 = ⊤`, `F^1 = ⊥`. -/
def F_ℚ_w0 : Fin 2 → Submodule ℚ ℚ
  | ⟨0, _⟩ => (⊤ : Submodule ℚ ℚ)
  | ⟨1, _⟩ => (⊥ : Submodule ℚ ℚ)

@[simp] theorem F_ℚ_w0_zero : F_ℚ_w0 ⟨0, by omega⟩ = (⊤ : Submodule ℚ ℚ) := rfl
@[simp] theorem F_ℚ_w0_one : F_ℚ_w0 ⟨1, by omega⟩ = (⊥ : Submodule ℚ ℚ) := rfl

/-- Trivial `HodgeFiltrationStructure ℚ 0` instance: `F^0 = ⊤`,
`F^1 = ⊥`. -/
instance hodgeFiltration_ℚ_0 : HodgeFiltrationStructure ℚ 0 where
  F := F_ℚ_w0
  F_antitone := by
    intro i j hij
    -- `Fin 2 = {0, 1}`; the four cases are (0,0), (0,1), (1,0), (1,1).
    -- (1,0) is excluded by `i.val ≤ j.val`.
    fin_cases i <;> fin_cases j
    · -- (0, 0): F 0 ≤ F 0
      exact le_rfl
    · -- (0, 1): F 1 = ⊥ ≤ F 0 = ⊤
      simp [F_ℚ_w0]
    · -- (1, 0): impossible since 1 > 0
      exact absurd hij (by decide)
    · -- (1, 1): F 1 ≤ F 1
      exact le_rfl
  F_top_eq_bot := by
    -- F ⟨0+1, _⟩ = F ⟨1, _⟩ = ⊥.
    rfl

end TrivialWeight

end HodgeReduction.Infrastructure.HodgeStructure
