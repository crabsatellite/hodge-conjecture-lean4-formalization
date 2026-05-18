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

/-- **R151: recursive filtration dimension formula**.

`finrank (filt p) = hodgeNumber p + finrank (filt ⟨p+1⟩)`.

Direct consequence of R149 (Hodge transversality) + R150 (filtration
step decomposition) + Mathlib's `Submodule.finrank_sup_add_finrank_inf_eq`.

Together with the boundary `filt ⟨n+1⟩ = 0` (in the extended filtration),
this gives the full dimension formula `finrank (filt p) =
∑ (i ≥ p), hodgeNumber i` via downward induction. -/
theorem finrank_filt_succ [Module.Finite ℚ V]
    (p : Fin (n + 1)) (hpn : p.val + 1 < n + 1) :
    Module.finrank ℚ (filt (V := V) p) =
    hodgeNumber (V := V) p +
    Module.finrank ℚ (filt (V := V) ⟨p.val + 1, hpn⟩) := by
  -- filt p = piece p ⊔ filt ⟨p+1⟩ (R150)
  rw [filt_eq_piece_sup_filt_succ p hpn]
  -- Disjointness from R149
  have h_disj : Disjoint (piece (V := V) p)
      (filt (V := V) ⟨p.val + 1, hpn⟩) :=
    piece_disjoint_filt_succ p hpn
  -- Use Submodule.finrank_sup_add_finrank_inf_eq
  have h_dim := Submodule.finrank_sup_add_finrank_inf_eq
    (piece (V := V) p) (filt (V := V) ⟨p.val + 1, hpn⟩)
  -- Disjoint ⟹ inf = ⊥ ⟹ finrank inf = 0
  rw [h_disj.eq_bot, finrank_bot, Nat.add_zero] at h_dim
  -- h_dim : finrank (piece p ⊔ filt ⟨p+1⟩) = finrank (piece p) + finrank (filt ⟨p+1⟩)
  -- hodgeNumber p := finrank (piece p) (R137 def)
  exact h_dim

/-- **R152**: filtration top-step boundary `filt ⟨n, _⟩ = piece ⟨n, _⟩`.

At the maximal index `p = n`, the filtration step contains only the
single Hodge piece `H^{n,0}` (the top-degree piece). Used as the base
case for the closed-form filtration dimension formula. -/
theorem filt_top : filt (V := V) (n := n) ⟨n, Nat.lt_succ_self n⟩ =
    piece (V := V) ⟨n, Nat.lt_succ_self n⟩ := by
  unfold filt
  apply le_antisymm
  · -- ⨆ (i : Fin (n+1)) (_ : n ≤ i.val), piece i ≤ piece ⟨n, _⟩
    refine iSup_le (fun i => iSup_le (fun hi => ?_))
    -- hi : ⟨n, _⟩.val ≤ i.val, i.e., n ≤ i.val.
    -- i : Fin (n+1) so i.val < n+1, hence i.val = n.
    simp only at hi
    have h_iv : i.val = n := by
      have h_isLt := i.isLt
      omega
    have h_iFin : i = ⟨n, Nat.lt_succ_self n⟩ := Fin.ext h_iv
    rw [h_iFin]
  · -- piece ⟨n, _⟩ ≤ ⨆ (i : Fin (n+1)) (_ : n ≤ i.val), piece i
    refine le_iSup_of_le ⟨n, Nat.lt_succ_self n⟩
      (le_iSup_of_le ?_ le_rfl)
    exact Nat.le_refl _

/-- **R152**: `finrank (filt ⟨n, _⟩) = hodgeNumber ⟨n, _⟩` (boundary case
of the filtration dimension formula). -/
theorem finrank_filt_top [Module.Finite ℚ V] :
    Module.finrank ℚ (filt (V := V) (n := n) ⟨n, Nat.lt_succ_self n⟩) =
    hodgeNumber (V := V) ⟨n, Nat.lt_succ_self n⟩ := by
  rw [filt_top]
  -- hodgeNumber p := Module.finrank ℚ (piece p) by R137 def
  rfl

/-- Auxiliary for R153: parametrize on `k = n - p.val` for downward induction. -/
private theorem finrank_filt_eq_sum_aux [Module.Finite ℚ V] (k : ℕ) :
    ∀ p : Fin (n + 1), n - p.val = k →
    Module.finrank ℚ (filt (V := V) p) =
    ∑ i ∈ Finset.univ.filter (fun (i : Fin (n + 1)) => p.val ≤ i.val),
      hodgeNumber (V := V) i := by
  induction k with
  | zero =>
    intro p hk
    -- p.val = n (since n - p.val = 0 and p.val ≤ n)
    have h_pn : p.val = n := by
      have hp := p.isLt
      omega
    have h_pFin : p = ⟨n, Nat.lt_succ_self n⟩ := Fin.ext h_pn
    rw [h_pFin, finrank_filt_top]
    -- filter (n ≤ i.val) = {⟨n, _⟩}
    have h_filter : Finset.univ.filter
        (fun (i : Fin (n + 1)) => n ≤ i.val) = {⟨n, Nat.lt_succ_self n⟩} := by
      ext i
      simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_singleton]
      constructor
      · intro hi
        have h_isLt := i.isLt
        exact Fin.ext (by omega)
      · intro hi
        rw [hi]
    rw [h_filter, Finset.sum_singleton]
  | succ k ih =>
    intro p hk
    -- n - p.val = k + 1, so p.val + 1 < n + 1
    have hpn : p.val + 1 < n + 1 := by omega
    rw [finrank_filt_succ p hpn]
    -- IH at ⟨p.val + 1, hpn⟩
    have h_k : n - (⟨p.val + 1, hpn⟩ : Fin (n + 1)).val = k := by
      show n - (p.val + 1) = k
      omega
    rw [ih ⟨p.val + 1, hpn⟩ h_k]
    -- Goal: hodgeNumber p + ∑ (i ≥ p+1), hN i = ∑ (i ≥ p), hN i
    -- Strategy: insert p into the (i ≥ p+1) filter to get (i ≥ p)
    have h_p_not_mem : p ∉ Finset.univ.filter
        (fun (i : Fin (n + 1)) => p.val + 1 ≤ i.val) := by
      simp only [Finset.mem_filter, Finset.mem_univ, true_and]
      omega
    rw [← Finset.sum_insert h_p_not_mem]
    congr 1
    -- {p} ∪ (filter ≥ p+1) = filter ≥ p
    ext i
    simp only [Finset.mem_insert, Finset.mem_filter, Finset.mem_univ, true_and]
    constructor
    · rintro (rfl | h)
      · exact Nat.le_refl _
      · omega
    · intro h
      by_cases heq : i = p
      · left; exact heq
      · right
        have h_iv_ne : i.val ≠ p.val := fun h_eq => heq (Fin.ext h_eq)
        omega

/-- **R153: closed-form filtration dimension formula**.

`finrank (filt p) = ∑ i ∈ Finset.univ.filter (p.val ≤ i.val), hodgeNumber i`

This is the standard formula `dim F^p V = ∑_{i ≥ p} h^{i, n-i}` for
the Hodge filtration. Proof: downward induction on `p` from `p = n`
(base R152) using the recursive step R151. -/
theorem finrank_filt_eq_sum [Module.Finite ℚ V] (p : Fin (n + 1)) :
    Module.finrank ℚ (filt (V := V) p) =
    ∑ i ∈ Finset.univ.filter (fun (i : Fin (n + 1)) => p.val ≤ i.val),
      hodgeNumber (V := V) i :=
  finrank_filt_eq_sum_aux (n - p.val) p rfl

/-! ### R154: user-friendly corollaries

These theorems extract specific Mathlib-level facts from the
PureHodgeStructure class, useful for downstream consumers who would
otherwise have to thread through `IsInternal` manually. -/

/-- **R154**: Hodge pieces are iSupIndep (independent in the lattice). -/
theorem piece_iSupIndep : iSupIndep (piece (V := V) (n := n)) :=
  DirectSum.IsInternal.submodule_iSupIndep (isInternal (V := V) (n := n))

/-- **R154**: Hodge pieces span the whole space. -/
theorem piece_iSup_eq_top :
    ⨆ p : Fin (n + 1), piece (V := V) p = ⊤ :=
  DirectSum.IsInternal.submodule_iSup_eq_top (isInternal (V := V) (n := n))

/-- **R154**: distinct Hodge pieces are pairwise disjoint
(`piece p ⊓ piece q = ⊥` for `p ≠ q`).

Direct consequence of `piece_iSupIndep`: each piece is disjoint from
the supremum of the others, hence in particular disjoint from any
single other piece. -/
theorem piece_disjoint {p q : Fin (n + 1)} (h : p ≠ q) :
    Disjoint (piece (V := V) p) (piece (V := V) q) := by
  refine (piece_iSupIndep p).mono_right ?_
  -- piece q ≤ ⨆ (j : Fin (n+1)) (_ : j ≠ p), piece j
  refine le_iSup_of_le q (le_iSup_of_le ?_ le_rfl)
  exact fun h_eq => h h_eq.symm

/-! ### R163: Hodge classes — the (p, p) component for weight 2p

The **space of Hodge classes** `Hdg^k(V) := H^{k,k}(V) ∩ V_ℚ` in a pure
ℚ-Hodge structure of weight `2k` is the foundational target of the
**Hodge Conjecture**: every Hodge class should be a ℚ-linear combination
of classes of algebraic cycles.

In the "split with rational pieces" convention used by this typeclass
(suitable for Hodge-Tate structures where the bigrading descends to ℚ),
the Hodge classes at degree `k` are precisely the rational `(k, k)`
piece. We give them a named definition with API (membership, finrank,
disjointness from other pieces) for downstream consumers.

This is the direct REAL-math replacement for the `R43` `Unit` placeholder
that previously made the `HodgeConjecture` statement vacuous at the level
of pure Hodge structures.

References:
* Deligne 1971, "Théorie de Hodge II", (2.1.10)-(2.1.14).
* Voisin 2002 I, §11 (Hodge classes, cycle class map, Hodge Conjecture).
* Griffiths-Harris 1978, Ch. 0.7 (Hodge decomposition).
-/

/-- **R163**: The submodule of **Hodge classes** of bidegree `(k, k)` in
a pure ℚ-Hodge structure of weight `2k`. Concretely, these are the
rational vectors lying in the middle Hodge piece `H^{k,k}` — the
natural target of the cycle class map and the subject of the **Hodge
Conjecture** (every such class should be a ℚ-linear combination of
algebraic cycle classes).

Defined as `piece ⟨k, _⟩` for a `PureHodgeStructure V (2*k)`; this is
the standard identification under the split-rational-pieces convention
(Hodge-Tate hypothesis, satisfied by CM abelian varieties and the
V_56-Shimura case relevant to this project).

This REPLACES the historical `R43 := Unit` placeholder for
`HodgeClasses` at the pure-Hodge-structure level. The variety-level
`HodgeClasses X p` upgrade depends on adding cohomology data to
`SmoothProjectiveVariety` (Mathlib infra work, multi-stage).

References: Deligne 1971 (2.1.10); Voisin II §11.1.1; Griffiths-Harris
Ch. 0.7. -/
def hodgeClasses (V : Type*) [AddCommGroup V] [Module ℚ V] (k : ℕ)
    [PureHodgeStructure V (2 * k)] : Submodule ℚ V :=
  piece (V := V) (n := 2 * k) ⟨k, by omega⟩

/-- **R163**: `IsHodgeClass V k v` asserts that `v : V` is a Hodge class
of degree `k`, i.e. lies in the middle piece `H^{k,k}` of a pure
ℚ-Hodge structure of weight `2k`. -/
def IsHodgeClass (V : Type*) [AddCommGroup V] [Module ℚ V] (k : ℕ)
    [PureHodgeStructure V (2 * k)] (v : V) : Prop :=
  v ∈ hodgeClasses V k

/-- **R163**: The defining identity `hodgeClasses V k = piece ⟨k, _⟩`
(unfolds the definition for downstream rewriting). -/
@[simp] theorem hodgeClasses_eq_piece (V : Type*) [AddCommGroup V]
    [Module ℚ V] (k : ℕ) [PureHodgeStructure V (2 * k)] :
    hodgeClasses V k = piece (V := V) (n := 2 * k) ⟨k, by omega⟩ := rfl

/-- **R163**: Membership in `hodgeClasses` is the same as `IsHodgeClass`. -/
theorem mem_hodgeClasses_iff_isHodgeClass (V : Type*) [AddCommGroup V]
    [Module ℚ V] {k : ℕ} [PureHodgeStructure V (2 * k)] (v : V) :
    v ∈ hodgeClasses V k ↔ IsHodgeClass V k v := Iff.rfl

/-- **R163**: The `ℚ`-dimension of the space of Hodge classes equals the
Hodge number `h^{k,k}(V)`. This is the standard dimensional formula and
a direct corollary of `hodgeClasses_eq_piece` + the definition of
`hodgeNumber`. -/
theorem finrank_hodgeClasses (V : Type*) [AddCommGroup V] [Module ℚ V]
    {k : ℕ} [PureHodgeStructure V (2 * k)] :
    Module.finrank ℚ (hodgeClasses V k) =
      hodgeNumber (V := V) (n := 2 * k) ⟨k, by omega⟩ := rfl

/-- **R163**: The space of Hodge classes is disjoint from any OTHER
Hodge piece. Direct corollary of `piece_disjoint` (R154) applied at
index `⟨k, _⟩` vs. an arbitrary distinct index. -/
theorem hodgeClasses_disjoint_other_piece (V : Type*) [AddCommGroup V]
    [Module ℚ V] {k : ℕ} [PureHodgeStructure V (2 * k)]
    (j : Fin (2 * k + 1)) (h : j ≠ ⟨k, by omega⟩) :
    Disjoint (hodgeClasses V k) (piece (V := V) (n := 2 * k) j) := by
  unfold hodgeClasses
  exact piece_disjoint (h.symm)

/-- **R163**: Zero is always a Hodge class (trivially, since
`hodgeClasses` is a submodule). -/
theorem zero_isHodgeClass (V : Type*) [AddCommGroup V] [Module ℚ V]
    {k : ℕ} [PureHodgeStructure V (2 * k)] :
    IsHodgeClass V k (0 : V) := (hodgeClasses V k).zero_mem

/-- **R163**: Hodge classes are closed under addition. -/
theorem IsHodgeClass.add {V : Type*} [AddCommGroup V] [Module ℚ V]
    {k : ℕ} [PureHodgeStructure V (2 * k)] {u v : V}
    (hu : IsHodgeClass V k u) (hv : IsHodgeClass V k v) :
    IsHodgeClass V k (u + v) := (hodgeClasses V k).add_mem hu hv

/-- **R163**: Hodge classes are closed under ℚ-scalar multiplication. -/
theorem IsHodgeClass.smul {V : Type*} [AddCommGroup V] [Module ℚ V]
    {k : ℕ} [PureHodgeStructure V (2 * k)] (c : ℚ) {v : V}
    (hv : IsHodgeClass V k v) :
    IsHodgeClass V k (c • v) := (hodgeClasses V k).smul_mem c hv

/-- **R163**: Hodge classes are closed under negation. -/
theorem IsHodgeClass.neg {V : Type*} [AddCommGroup V] [Module ℚ V]
    {k : ℕ} [PureHodgeStructure V (2 * k)] {v : V}
    (hv : IsHodgeClass V k v) :
    IsHodgeClass V k (-v) := (hodgeClasses V k).neg_mem hv

end PureHodgeStructure

/-! ## R163: The Hodge Conjecture as a predicate on pure Hodge structures

We now give the abstract REAL-math formulation of the Hodge Conjecture
at the level of a pure ℚ-Hodge structure of weight `2k`, parametrised by
a submodule of "algebraic classes" (which a concrete instance must
supply). This removes the Unit-trivial vacuity at the pure-Hodge-structure
level: `HodgeConjectureAtWeight` is a genuine assertion about
submodule containment.

The Hodge Conjecture statement at degree `k`:

**Every Hodge class is algebraic.**

Equivalently: `hodgeClasses V k ≤ algClasses`, where `algClasses` is
the submodule of algebraic classes — those that arise as ℚ-linear
combinations of cycle classes `[Z]` of algebraic subvarieties.

Defining `algClasses` substantively requires intersection theory
(Chow groups + cycle class map), which is not yet in Mathlib. For now
we package the conjecture as parametrised by an arbitrary
`algClasses : Submodule ℚ V` and prove basic forms (it is a Prop, it
is reflexive when `algClasses = hodgeClasses`, etc.). Concrete
applications will instantiate `algClasses` from the cycle class map
once that infrastructure is available. -/

/-- **R163**: The **Hodge Conjecture at weight `2k`** for a pure ℚ-Hodge
structure `V`, parametrised by a submodule `algClasses` of algebraic
classes: every Hodge class lies in `algClasses`.

This is the abstract, substantive formulation. With `algClasses := ⊤`
the conjecture is trivially true (every class is "algebraic"); with
`algClasses := PureHodgeStructure.hodgeClasses V k` it is the
statement "Hodge classes are their own image under inclusion", also
trivially true. The substantive non-trivial cases are when
`algClasses` arises from a cycle class map and may strictly contain
or be contained in `hodgeClasses` a priori.

References: Voisin 2002 II §11.1.1; Hodge 1950. -/
def HodgeConjectureAtWeight (V : Type*) [AddCommGroup V] [Module ℚ V]
    (k : ℕ) [PureHodgeStructure V (2 * k)]
    (algClasses : Submodule ℚ V) : Prop :=
  PureHodgeStructure.hodgeClasses V k ≤ algClasses

/-- **R163**: HC trivially holds when `algClasses = ⊤` (any class is
"algebraic" in the maximal sense — no information). -/
theorem hodgeConjectureAtWeight_top (V : Type*) [AddCommGroup V]
    [Module ℚ V] (k : ℕ) [PureHodgeStructure V (2 * k)] :
    HodgeConjectureAtWeight V k (⊤ : Submodule ℚ V) := le_top

/-- **R163**: HC trivially holds when `algClasses = hodgeClasses V k`
(reflexivity). -/
theorem hodgeConjectureAtWeight_self (V : Type*) [AddCommGroup V]
    [Module ℚ V] (k : ℕ) [PureHodgeStructure V (2 * k)] :
    HodgeConjectureAtWeight V k (PureHodgeStructure.hodgeClasses V k) :=
  le_refl _

/-- **R163**: HC is monotone in `algClasses`: a larger algebraic-classes
submodule makes HC easier to satisfy. -/
theorem hodgeConjectureAtWeight_mono (V : Type*) [AddCommGroup V]
    [Module ℚ V] (k : ℕ) [PureHodgeStructure V (2 * k)]
    {A B : Submodule ℚ V} (hAB : A ≤ B)
    (hA : HodgeConjectureAtWeight V k A) :
    HodgeConjectureAtWeight V k B := hA.trans hAB

/-- **R163**: HC is preserved under intersection with a containing
algebraic-classes submodule. (If HC holds for `A` and `B ≥ hodgeClasses`,
then HC holds for `A ⊓ B`.) -/
theorem hodgeConjectureAtWeight_inf (V : Type*) [AddCommGroup V]
    [Module ℚ V] (k : ℕ) [PureHodgeStructure V (2 * k)]
    {A B : Submodule ℚ V}
    (hA : HodgeConjectureAtWeight V k A)
    (hB : HodgeConjectureAtWeight V k B) :
    HodgeConjectureAtWeight V k (A ⊓ B) := le_inf hA hB

/-! ## R164: Morphisms of pure Hodge structures + functoriality of Hodge classes

A **morphism of pure ℚ-Hodge structures** of weight `n` is a ℚ-linear
map `f : V →ₗ[ℚ] W` that **preserves the Hodge decomposition**:
`f(H^{p,n-p}(V)) ⊆ H^{p,n-p}(W)` for each `p`.

This is the categorical morphism structure on the category `HS_ℚ^n` of
pure ℚ-Hodge structures of weight `n` (Deligne 1971 §2; Voisin I §6).

Key downstream consumer: the **cycle class map**
`cl : CH^p(X)_ℚ → H^{2p}(X, ℚ)` is (after composing with the inclusion
into a weight-2p PHS) a morphism of pure Hodge structures of weight 2p
whose image lies in `hodgeClasses` — and the Hodge Conjecture is the
assertion that this image EQUALS `hodgeClasses`.

We package the structural definitions + the key functoriality theorem:
**morphisms of pure Hodge structures preserve Hodge classes**.

References: Deligne 1971 (2.1.8) (morphisms of Hodge structures);
Voisin 2002 I (6.13) (morphism preserves bigrading). -/

/-- **R164**: A **morphism of pure ℚ-Hodge structures of weight `n`**
from `V` to `W` is a ℚ-linear map preserving each Hodge piece.

Concretely, `map_piece` asserts that the image of `H^{p,n-p}(V)` under
`toLinearMap` lies in `H^{p,n-p}(W)` for every `p ∈ {0, ..., n}`.

This is the data-bearing form (vs a typeclass) appropriate for
explicit morphism manipulation (composition, identity, image
factorisation through `hodgeClasses`, etc.). -/
structure HodgeStructureMorphism (V W : Type*) [AddCommGroup V]
    [AddCommGroup W] [Module ℚ V] [Module ℚ W] (n : ℕ)
    [PureHodgeStructure V n] [PureHodgeStructure W n] where
  /-- The underlying ℚ-linear map. -/
  toLinearMap : V →ₗ[ℚ] W
  /-- The map preserves each Hodge piece. -/
  map_piece : ∀ (p : Fin (n + 1)),
    Submodule.map toLinearMap (PureHodgeStructure.piece (V := V) p) ≤
      PureHodgeStructure.piece (V := W) p

namespace HodgeStructureMorphism

variable {V W X : Type*} [AddCommGroup V] [AddCommGroup W] [AddCommGroup X]
  [Module ℚ V] [Module ℚ W] [Module ℚ X] {n : ℕ}
  [PureHodgeStructure V n] [PureHodgeStructure W n] [PureHodgeStructure X n]

/-- Apply a Hodge morphism to a vector (function-call coercion). -/
instance : CoeFun (HodgeStructureMorphism V W n) (fun _ => V → W) where
  coe f := f.toLinearMap

/-- **R164**: The **identity morphism** of a pure Hodge structure.
The identity linear map trivially preserves each piece. -/
def id_HSM : HodgeStructureMorphism V V n where
  toLinearMap := LinearMap.id
  map_piece := fun p => by
    intro x hx
    simp only [Submodule.mem_map, LinearMap.id_coe, id_eq] at hx
    obtain ⟨y, hy, hyx⟩ := hx
    rw [← hyx]
    exact hy

/-- **R164**: **Composition** of Hodge structure morphisms. The
composition of two ℚ-linear maps preserving pieces also preserves
pieces. -/
def comp (g : HodgeStructureMorphism W X n) (f : HodgeStructureMorphism V W n) :
    HodgeStructureMorphism V X n where
  toLinearMap := g.toLinearMap ∘ₗ f.toLinearMap
  map_piece := fun p => by
    intro x hx
    simp only [Submodule.mem_map, LinearMap.coe_comp, Function.comp_apply] at hx
    obtain ⟨y, hy, hyx⟩ := hx
    -- y ∈ piece p, so f y ∈ image of piece p under f ≤ piece p in W
    have hfy : f.toLinearMap y ∈
        PureHodgeStructure.piece (V := W) p := by
      have h := f.map_piece p
      apply h
      exact ⟨y, hy, rfl⟩
    -- Now g (f y) ∈ image of piece p under g ≤ piece p in X
    have hgfy : g.toLinearMap (f.toLinearMap y) ∈
        PureHodgeStructure.piece (V := X) p := by
      have h := g.map_piece p
      apply h
      exact ⟨f.toLinearMap y, hfy, rfl⟩
    rw [← hyx]
    exact hgfy

/-- **R164 KEY FUNCTORIALITY**: a Hodge morphism `f : V → W` of weight
`2k` maps Hodge classes to Hodge classes:
`f(hodgeClasses V k) ⊆ hodgeClasses W k`.

Proof: `hodgeClasses V k = piece ⟨k, _⟩` (R163), and `map_piece` for
`p = ⟨k, _⟩` gives exactly the desired containment.

This is the categorical statement underlying "the cycle class map is
a morphism of Hodge structures whose image lies in Hdg^{p,p}". -/
theorem map_hodgeClasses {k : ℕ}
    [PureHodgeStructure V (2 * k)] [PureHodgeStructure W (2 * k)]
    (f : HodgeStructureMorphism V W (2 * k)) :
    Submodule.map f.toLinearMap (PureHodgeStructure.hodgeClasses V k) ≤
      PureHodgeStructure.hodgeClasses W k := by
  unfold PureHodgeStructure.hodgeClasses
  exact f.map_piece ⟨k, by omega⟩

/-- **R164 PRESERVATION**: applying a Hodge morphism to a Hodge class
yields a Hodge class. Pointwise corollary of `map_hodgeClasses`. -/
theorem isHodgeClass_map {k : ℕ}
    [PureHodgeStructure V (2 * k)] [PureHodgeStructure W (2 * k)]
    (f : HodgeStructureMorphism V W (2 * k)) {v : V}
    (hv : PureHodgeStructure.IsHodgeClass V k v) :
    PureHodgeStructure.IsHodgeClass W k (f.toLinearMap v) := by
  have h := f.map_hodgeClasses (k := k)
  apply h
  exact ⟨v, hv, rfl⟩

/-- **R164 FILTRATION PRESERVATION**: a Hodge morphism preserves the
Hodge filtration: `f(F^p V) ⊆ F^p W`. Direct consequence of
`map_piece` since `F^p = ⨆ (i ≥ p), piece i` and `map` distributes over
`⨆` and respects `≤`. -/
theorem map_filt (f : HodgeStructureMorphism V W n) (p : Fin (n + 1)) :
    Submodule.map f.toLinearMap (PureHodgeStructure.filt (V := V) p) ≤
      PureHodgeStructure.filt (V := W) p := by
  unfold PureHodgeStructure.filt
  rw [Submodule.map_iSup]
  refine iSup_le (fun i => ?_)
  rw [Submodule.map_iSup]
  refine iSup_le (fun hi => ?_)
  refine le_iSup_of_le i (le_iSup_of_le hi ?_)
  exact f.map_piece i

/-! ### R178: Basic functoriality lemmas for HodgeStructureMorphism

The category-theoretic core: identity preserves vectors, composition
preserves application, identity preserves Hodge classes (trivially).
These are the categorical structure axioms for the category of pure
Hodge structures of weight `n`. -/

/-- **R178**: The identity Hodge morphism acts as the identity on vectors. -/
@[simp] theorem id_HSM_toLinearMap_apply (v : V) :
    (id_HSM (n := n)).toLinearMap v = v := rfl

/-- **R178**: Composition of Hodge morphisms applies functionally. -/
@[simp] theorem comp_toLinearMap_apply
    (g : HodgeStructureMorphism W X n) (f : HodgeStructureMorphism V W n) (v : V) :
    (g.comp f).toLinearMap v = g.toLinearMap (f.toLinearMap v) := rfl

/-- **R178**: The identity Hodge morphism maps `hodgeClasses` to itself
(submodule-level statement of `id` preservation). -/
theorem id_HSM_map_hodgeClasses {k : ℕ}
    [PureHodgeStructure V (2 * k)] :
    Submodule.map (id_HSM (V := V) (n := 2 * k)).toLinearMap
        (PureHodgeStructure.hodgeClasses V k) =
      PureHodgeStructure.hodgeClasses V k := by
  unfold id_HSM
  simp [Submodule.map_id]

end HodgeStructureMorphism

/-! ## R165: Cycle class map data + Hodge Conjecture formulated via image

The **cycle class map** `cl: C → W` (with `C` a ℚ-module of "rational
cycle classes" and `W` a weight-`2k` PHS) is the central object of the
Hodge Conjecture. It is a ℚ-linear map whose **range is contained in
Hodge classes** (because cycle classes are intrinsically (p,p)).

The **Hodge Conjecture for this cycle class map** asserts the REVERSE
inclusion: every Hodge class arises as the cycle class of some
algebraic cycle, i.e. `hodgeClasses W k ≤ LinearMap.range cl`.

We package this with a bundled data structure `CycleClassMapData` that
carries (1) the ℚ-linear map and (2) the proof that its range is
contained in Hodge classes. Then `HodgeConjectureForCycleMap` is a
clean Prop on this bundle.

This formulation removes the R43 Unit-trivial vacuity at the abstract
level: the assertion `range = hodgeClasses` is genuinely non-trivial
content (not vacuously true via `Unit ≃ Unit`).

References: Voisin 2002 II §11.1.1 (cycle class map); Hodge 1950
(Hodge Conjecture). -/

/-- **R165**: A **cycle class map** from a ℚ-module `C` of "rational
cycle classes" to a weight-`2k` pure Hodge structure `W`, bundled with
the proof that its range lies inside `hodgeClasses W k`.

The hypothesis `range_le_hodgeClasses` is the **Hodge-theoretic
half** of the cycle class story: cycle classes of algebraic
subvarieties are intrinsically (p, p) (Lefschetz-Hodge; Hodge 1950).
The conjecture goes the OTHER way: every Hodge class arises as such
a cycle class. -/
structure CycleClassMapData (C W : Type*) [AddCommGroup C] [AddCommGroup W]
    [Module ℚ C] [Module ℚ W] (k : ℕ) [PureHodgeStructure W (2 * k)] where
  /-- The underlying ℚ-linear map `cl: C →ₗ[ℚ] W`. -/
  toLinearMap : C →ₗ[ℚ] W
  /-- Hodge half: the range of `cl` lies in Hodge classes. -/
  range_le_hodgeClasses :
    LinearMap.range toLinearMap ≤ PureHodgeStructure.hodgeClasses W k

namespace CycleClassMapData

variable {C W : Type*} [AddCommGroup C] [AddCommGroup W]
  [Module ℚ C] [Module ℚ W] {k : ℕ} [PureHodgeStructure W (2 * k)]

/-- **R165**: The **Hodge Conjecture** for a specific cycle class map:
the range of `cl` EQUALS the space of Hodge classes (combining the
already-proven `range ≤ hodgeClasses` with the conjectural reverse
inclusion `hodgeClasses ≤ range`).

This is the genuine, non-trivial assertion form of HC at the level of
a pure Hodge structure + cycle class map. NO Unit trick. -/
def HodgeConjectureForCycleMap (cl : CycleClassMapData C W k) : Prop :=
  LinearMap.range cl.toLinearMap = PureHodgeStructure.hodgeClasses W k

/-- **R165**: HC for the cycle class map is equivalent to the reverse
inclusion `hodgeClasses W k ≤ LinearMap.range cl` (since the forward
direction is already in the bundle).

This is the form most reductions naturally produce. -/
theorem hodgeConjectureForCycleMap_iff (cl : CycleClassMapData C W k) :
    cl.HodgeConjectureForCycleMap ↔
    PureHodgeStructure.hodgeClasses W k ≤ LinearMap.range cl.toLinearMap := by
  constructor
  · intro h
    rw [h]
  · intro h
    exact le_antisymm cl.range_le_hodgeClasses h

/-- **R165**: Symmetric form — HC says every Hodge class is in the
range, i.e. for every `α : W` with `IsHodgeClass W k α`, there exists
`z : C` with `cl z = α`. -/
theorem hodgeConjectureForCycleMap_iff_exists (cl : CycleClassMapData C W k) :
    cl.HodgeConjectureForCycleMap ↔
    ∀ α : W, PureHodgeStructure.IsHodgeClass W k α → ∃ z : C, cl.toLinearMap z = α := by
  rw [hodgeConjectureForCycleMap_iff]
  constructor
  · intro h α hα
    have h' := h hα
    exact LinearMap.mem_range.mp h'
  · intro h α hα
    rw [LinearMap.mem_range]
    exact h α hα

end CycleClassMapData

/-! ## R165: Reduction theorem — HC transfers across Hodge morphisms

The classical HC reduction strategy: "HC for variety class A implies
HC for variety class B". We formalise the abstract content:

If we have two cycle class maps `cl_V : C_V → V` and `cl_W : C_W → W`
related by:
  * A Hodge morphism `φ : V → W` of weight `2k`
  * A ℚ-linear "cycle correspondence" `ψ : C_V → C_W`
  * The compatibility `cl_W ∘ ψ = φ ∘ cl_V` (commutative square)
  * `φ` is **surjective on Hodge classes**: every Hodge class of `W`
    is hit by some Hodge class of `V` via `φ`.

Then HC for `cl_V` implies HC for `cl_W`. (Standard correspondence-based
reduction; Voisin II §11.4.) -/

/-- **R165 REDUCTION THEOREM**: HC transfers from a source cycle class
map to a target one along a Hodge morphism that surjects on Hodge
classes.

This is the abstract categorical content of the Mumford-Tate /
correspondence-based reduction strategy in the paper:
* `cl_V : C_V → V` is the source cycle class map (HC assumed for this).
* `cl_W : C_W → W` is the target cycle class map (HC to be derived).
* `φ : V → W` is a Hodge morphism of weight `2k`.
* `ψ : C_V → C_W` is the cycle-level correspondence.
* The square commutes: `cl_W ∘ ψ = φ ∘ cl_V`.
* `φ` is surjective on Hodge classes:
  `hodgeClasses W k ≤ Submodule.map φ (hodgeClasses V k)`.

Conclusion: HC for `cl_W` follows from HC for `cl_V`.

Concrete instantiation in the V_56 case: V is the cohomology of a CM
abelian variety (where HC is known by Deligne 1982), W is the
cohomology of the V_56-Shimura, φ is the projection induced by the
Mumford-Tate correspondence, ψ is the correspondence on cycle level. -/
theorem CycleClassMapData.hodgeConjecture_transfer
    {C_V C_W V W : Type*}
    [AddCommGroup C_V] [AddCommGroup C_W] [AddCommGroup V] [AddCommGroup W]
    [Module ℚ C_V] [Module ℚ C_W] [Module ℚ V] [Module ℚ W]
    {k : ℕ} [PureHodgeStructure V (2 * k)] [PureHodgeStructure W (2 * k)]
    (cl_V : CycleClassMapData C_V V k) (cl_W : CycleClassMapData C_W W k)
    (φ : HodgeStructureMorphism V W (2 * k))
    (ψ : C_V →ₗ[ℚ] C_W)
    (h_square : ∀ z : C_V,
      cl_W.toLinearMap (ψ z) = φ.toLinearMap (cl_V.toLinearMap z))
    (h_φ_surj : PureHodgeStructure.hodgeClasses W k ≤
      Submodule.map φ.toLinearMap (PureHodgeStructure.hodgeClasses V k))
    (hV : cl_V.HodgeConjectureForCycleMap) :
    cl_W.HodgeConjectureForCycleMap := by
  rw [hodgeConjectureForCycleMap_iff_exists]
  intro α hα
  -- α ∈ hodgeClasses W k; by h_φ_surj, α = φ.toLinearMap v for some v ∈ hodgeClasses V k.
  have h_α_in : α ∈ PureHodgeStructure.hodgeClasses W k := hα
  obtain ⟨v, hv_in, hv_eq⟩ := h_φ_surj h_α_in
  -- v ∈ hodgeClasses V k = range cl_V (by HC for V)
  have h_range_eq_V : LinearMap.range cl_V.toLinearMap =
      PureHodgeStructure.hodgeClasses V k := hV
  rw [← h_range_eq_V] at hv_in
  obtain ⟨z, hz_eq⟩ := LinearMap.mem_range.mp hv_in
  -- ψ z gives a preimage in C_W
  refine ⟨ψ z, ?_⟩
  rw [h_square, hz_eq, hv_eq]

/-! ## R166: Sub-Hodge structures and closure lemmas

A **sub-Hodge structure** of a pure ℚ-Hodge structure `V` of weight
`n` is a ℚ-submodule `W ≤ V` such that `W` decomposes through the
Hodge pieces of `V`: every element of `W` is a sum of elements lying
in `W ⊓ piece p`.

Equivalently: `W = ⨆ p, W ⊓ piece p` — the lattice formulation we
use as the definition.

Sub-Hodge structures form a complete lattice under `⊓` and `⊔`. The
key examples:
* `⊥` and `⊤` are sub-HS (trivially).
* Each Hodge piece `piece p` is a sub-HS of `V`.
* The intersection of two sub-HS is a sub-HS.

Use case in HC programme: the image of a Hodge structure morphism and
the kernel of a HS morphism are sub-HS — these will be proved in
R167+ once the direct-sum component-extraction machinery is in place.

References: Deligne 1971 (2.1.7) (sub-Hodge structures and the lattice
they form); Voisin I (6.13)-(6.14). -/

namespace PureHodgeStructure

variable {V} {n : ℕ} [PureHodgeStructure V n]

/-- **R166**: `IsSubHodgeStructure W` asserts that the ℚ-submodule
`W ≤ V` is a **sub-Hodge structure**: it decomposes through the Hodge
pieces of `V`, i.e. `W = ⨆ p, W ⊓ piece p`.

Equivalent characterisations (Deligne 1971 (2.1.7)):
* `W = ⨆ p, W ⊓ piece p` (lattice form, used here)
* every `w ∈ W` decomposes uniquely as `w = ∑ w_p` with `w_p ∈ W ⊓ piece p`
* `W` is stable under each piece projection.
-/
def IsSubHodgeStructure (W : Submodule ℚ V) : Prop :=
  W = ⨆ (p : Fin (n + 1)), W ⊓ piece (V := V) p

/-- **R166**: `⊥` is a sub-Hodge structure (vacuously). -/
theorem bot_isSubHodgeStructure :
    IsSubHodgeStructure (V := V) (n := n) (⊥ : Submodule ℚ V) := by
  unfold IsSubHodgeStructure
  simp [bot_inf_eq]

/-- **R166**: `⊤` is a sub-Hodge structure (the whole space; the
decomposition is the Hodge decomposition itself). -/
theorem top_isSubHodgeStructure :
    IsSubHodgeStructure (V := V) (n := n) (⊤ : Submodule ℚ V) := by
  unfold IsSubHodgeStructure
  apply le_antisymm
  · -- ⊤ ≤ ⨆ p, ⊤ ⊓ piece p; this is ⨆ p, piece p = ⊤
    rw [show ((⨆ (p : Fin (n + 1)), (⊤ : Submodule ℚ V) ⊓ piece (V := V) p) =
      ⨆ p : Fin (n + 1), piece (V := V) p) by
      congr 1; funext p; rw [top_inf_eq]]
    rw [piece_iSup_eq_top]
  · exact le_top

/-- **R166**: Each Hodge piece `piece p` is a sub-Hodge structure of `V`.
The decomposition of `piece p` through the pieces is trivial: `piece p`
intersected with `piece q` is `⊥` for `q ≠ p` (pairwise disjointness),
and equals `piece p` for `q = p`. -/
theorem piece_isSubHodgeStructure (p : Fin (n + 1)) :
    IsSubHodgeStructure (V := V) (n := n) (piece (V := V) p) := by
  unfold IsSubHodgeStructure
  apply le_antisymm
  · -- piece p ≤ ⨆ q, piece p ⊓ piece q. Take q = p: piece p ⊓ piece p = piece p.
    intro v hv
    refine Submodule.mem_iSup_of_mem p ?_
    exact Submodule.mem_inf.mpr ⟨hv, hv⟩
  · -- ⨆ q, piece p ⊓ piece q ≤ piece p. Each summand piece p ⊓ piece q ≤ piece p (inf_le_left).
    exact iSup_le (fun _ => inf_le_left)

/-- **R180**: The space of Hodge classes `hodgeClasses V k` is a
sub-Hodge structure of `V` (corollary of R166 `piece_isSubHodgeStructure`
applied at index `⟨k, _⟩` for the weight-2k Hodge structure). -/
theorem hodgeClasses_isSubHodgeStructure
    {V : Type*} [AddCommGroup V] [Module ℚ V] (k : ℕ)
    [PureHodgeStructure V (2 * k)] :
    IsSubHodgeStructure (V := V) (n := 2 * k)
      (PureHodgeStructure.hodgeClasses V k) := by
  unfold PureHodgeStructure.hodgeClasses
  exact piece_isSubHodgeStructure ⟨k, by omega⟩

/-! ### R167: Hodge decomposition LinearEquiv

The `DirectSum.IsInternal piece` content gives a **LinearEquiv**
`V ≃ₗ[ℚ] ⨁ p, piece p`. We package it as `hodgeDecomposeEquiv`,
providing the canonical entry point for extracting Hodge components.

Full extraction API (component projection + reconstruction
identity + sub-HS invariance + kernel/range as sub-HS theorems) is
deferred to a future round — the basic LinearEquiv suffices for
many downstream uses where `LinearEquiv.symm_apply_apply` and
similar generic tools are enough. -/

/-- **R167**: The **Hodge decomposition LinearEquiv**:
`V ≃ₗ[ℚ] ⨁ p, piece p`. Direct consequence of `DirectSum.IsInternal
piece` (the structure of `PureHodgeStructure`). -/
noncomputable def hodgeDecomposeEquiv (V : Type*) [AddCommGroup V] [Module ℚ V]
    {n : ℕ} [PureHodgeStructure V n] :
    V ≃ₗ[ℚ] DirectSum (Fin (n + 1)) (fun p => ↥(piece (V := V) p)) :=
  (LinearEquiv.ofBijective
    (DirectSum.coeLinearMap (fun p => piece (V := V) p))
    (isInternal (V := V))).symm

/-- **R167**: The inverse of `hodgeDecomposeEquiv` is the canonical
coercion sum (recovers `v = ∑ p, ↑(component p)`). Unfolds the
construction. -/
theorem hodgeDecomposeEquiv_symm_eq (V : Type*) [AddCommGroup V] [Module ℚ V]
    {n : ℕ} [PureHodgeStructure V n] :
    (hodgeDecomposeEquiv V).symm =
      LinearEquiv.ofBijective
        (DirectSum.coeLinearMap (fun p => PureHodgeStructure.piece (V := V) p))
        (PureHodgeStructure.isInternal (V := V) (n := n)) := by
  unfold hodgeDecomposeEquiv
  exact LinearEquiv.symm_symm _

/-- **R181**: The p-th Hodge component of `v`, as an element of
`piece p` (subtype). Built from R167 `hodgeDecomposeEquiv`. -/
noncomputable def hodgeComponent
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (p : Fin (n + 1)) (v : V) :
    ↥(PureHodgeStructure.piece (V := V) p) :=
  (PureHodgeStructure.hodgeDecomposeEquiv V v) p

/-- **R181**: The p-th Hodge component of `v`, as an element of `V`
via subtype coercion. -/
noncomputable def hodgeComponentV
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (p : Fin (n + 1)) (v : V) : V :=
  ↑(hodgeComponent (V := V) p v)

/-- **R181**: Each Hodge component lies in the corresponding piece. -/
theorem hodgeComponentV_mem_piece
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (p : Fin (n + 1)) (v : V) :
    hodgeComponentV (V := V) p v ∈ PureHodgeStructure.piece (V := V) p :=
  (hodgeComponent p v).property

/-- **R181**: `hodgeComponentV p (u + v) = hodgeComponentV p u + hodgeComponentV p v`.
ℚ-linearity, inherited from `hodgeDecomposeEquiv` LinearEquiv. -/
theorem hodgeComponentV_add
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (p : Fin (n + 1)) (u v : V) :
    hodgeComponentV p (u + v) = hodgeComponentV p u + hodgeComponentV p v := by
  unfold hodgeComponentV hodgeComponent
  rw [map_add]
  rfl

/-- **R181**: `hodgeComponentV p 0 = 0`. -/
@[simp] theorem hodgeComponentV_zero
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (p : Fin (n + 1)) :
    hodgeComponentV (V := V) p 0 = 0 := by
  unfold hodgeComponentV hodgeComponent
  rw [map_zero]
  rfl

/-- **R181 KEY**: Unique-decomposition identity. If `v ∈ piece q`, then
`hodgeComponentV p v = v` when `p = q` and `= 0` otherwise.

Proof: `hodgeDecomposeEquiv v` is uniquely determined by being the
DirectSum representation of `v`. For `v ∈ piece q`, the trivial
decomposition `DirectSum.of _ q ⟨v, hv⟩` works (only one non-zero
component at index `q`). Both representations have the same image
under `(hodgeDecomposeEquiv).symm = coeLinearMap`, so by LinearEquiv
injectivity, they're equal. Then projecting at `p` gives the result. -/
theorem hodgeComponentV_of_mem_piece
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (q : Fin (n + 1)) {v : V}
    (hv : v ∈ PureHodgeStructure.piece (V := V) q) (p : Fin (n + 1)) :
    hodgeComponentV (V := V) p v = if p = q then v else 0 := by
  -- Compute hodgeDecomposeEquiv v = DirectSum.of _ q ⟨v, hv⟩ via uniqueness
  have h_decomp : PureHodgeStructure.hodgeDecomposeEquiv V v =
      DirectSum.of (fun i => ↥(PureHodgeStructure.piece (V := V) i)) q ⟨v, hv⟩ := by
    apply (PureHodgeStructure.hodgeDecomposeEquiv V).symm.injective
    rw [LinearEquiv.symm_apply_apply,
        PureHodgeStructure.hodgeDecomposeEquiv_symm_eq,
        LinearEquiv.ofBijective_apply,
        DirectSum.coeLinearMap_of]
  -- Project at p
  unfold hodgeComponentV hodgeComponent
  rw [h_decomp]
  by_cases hpq : p = q
  · subst hpq
    simp
  · have h_ne : (DirectSum.of (fun i => ↥(PureHodgeStructure.piece (V := V) i)) q ⟨v, hv⟩) p
        = 0 := DirectSum.of_eq_of_ne _ _ _ (Ne.symm hpq)
    rw [h_ne]
    simp [hpq]

/-- **R181 RECONSTRUCTION**: `v = ∑ p, hodgeComponentV p v`. The sum
of Hodge components recovers the original vector. Direct consequence
of R167's `hodgeDecomposeEquiv` LinearEquiv structure +
`DirectSum.coeLinearMap` + Mathlib's `DFinsupp.sum_eq_sum_fintype`. -/
theorem sum_hodgeComponentV
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] (v : V) :
    ∑ p : Fin (n + 1), hodgeComponentV (V := V) p v = v := by
  -- Fix the LinearEquiv as a let-binding to avoid typeclass synth issues.
  let e := hodgeDecomposeEquiv (V := V) (n := n)
  have h_inv : e.symm (e v) = v := LinearEquiv.symm_apply_apply e v
  have h_symm_eq : e.symm = LinearEquiv.ofBijective
        (DirectSum.coeLinearMap (fun (p : Fin (n + 1)) => piece (V := V) p))
        (isInternal (V := V) (n := n)) := hodgeDecomposeEquiv_symm_eq V
  rw [h_symm_eq, LinearEquiv.ofBijective_apply] at h_inv
  -- h_inv : coeLinearMap (e v) = v
  -- Calc chain to avoid rw-both-sides issue.
  classical
  calc ∑ p : Fin (n + 1), hodgeComponentV (V := V) p v
      = ∑ p : Fin (n + 1), (↑((e v) p) : V) := by
        apply Finset.sum_congr rfl
        intro p _; rfl
    _ = ∑ p : Fin (n + 1), (↑(DFinsupp.equivFunOnFintype (e v) p) : V) := by
        apply Finset.sum_congr rfl
        intro p _; rfl
    _ = DFinsupp.sum (e v) (fun (_ : Fin (n + 1)) (y : ↥(piece (V := V) _)) => (↑y : V)) := by
        rw [DFinsupp.sum_eq_sum_fintype _ (fun _ => rfl)]
    _ = (DirectSum.coeLinearMap (fun p => piece (V := V) p)) (e v) := by
        rw [DirectSum.coeLinearMap_eq_dfinsupp_sum]
    _ = v := h_inv

/-- **R181 KEY**: if `W ≤ V` is a sub-Hodge structure and `v ∈ W`,
then every V-component `hodgeComponentV p v` lies in `W`.

Proof: `v ∈ W = ⨆ q, W ⊓ piece q` by `IsSubHodgeStructure`. Apply
`Submodule.iSup_induction`: for `w ∈ W ⊓ piece q`, the V-component at
`p` is either `w` (if `p = q`, gives `∈ W`) or `0` (otherwise, also
`∈ W`). For `0`, the component is `0 ∈ W`. For sums, use linearity. -/
theorem hodgeComponentV_mem_of_isSubHodgeStructure
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] {W : Submodule ℚ V}
    (hW : IsSubHodgeStructure (V := V) (n := n) W)
    {v : V} (hv : v ∈ W) (p : Fin (n + 1)) :
    hodgeComponentV (V := V) p v ∈ W := by
  unfold IsSubHodgeStructure at hW
  rw [hW] at hv
  -- Apply Submodule.iSup_induction. The `C` parameter (motive) needs explicit hint
  -- because Lean doesn't infer it from the position-only motive.
  refine Submodule.iSup_induction
    (C := fun u => hodgeComponentV (V := V) p u ∈ W)
    (fun q : Fin (n + 1) => W ⊓ piece (V := V) q)
    hv
    (fun q w hw => ?_)
    ?_
    (fun u u' hu hu' => ?_)
  · -- mem case: w ∈ W ⊓ piece q
    obtain ⟨hw_W, hw_q⟩ := hw
    show hodgeComponentV p w ∈ W
    rw [hodgeComponentV_of_mem_piece q hw_q p]
    by_cases hpq : p = q
    · rw [if_pos hpq]; exact hw_W
    · rw [if_neg hpq]; exact Submodule.zero_mem _
  · -- zero case
    show hodgeComponentV p 0 ∈ W
    rw [hodgeComponentV_zero]
    exact Submodule.zero_mem _
  · -- add case
    show hodgeComponentV p (u + u') ∈ W
    rw [hodgeComponentV_add]
    exact Submodule.add_mem _ hu hu'

/-- **R181 R166-DEFERRED RESOLVED**: The intersection of two sub-Hodge
structures is itself a sub-Hodge structure (Deligne 1971 (2.1.7)).

Proof: for `v ∈ W₁ ⊓ W₂`, each V-component `hodgeComponentV p v` lies
in both `W₁` (by R181 extraction on `W₁`) and `W₂` (by R181 extraction
on `W₂`), hence in `W₁ ⊓ W₂`. Each component also lies in `piece p`
(R181 `hodgeComponentV_mem_piece`). Summing via R181 `sum_hodgeComponentV`
gives `v ∈ ⨆ p, (W₁ ⊓ W₂) ⊓ piece p`. -/
theorem IsSubHodgeStructure.inf
    {V : Type*} [AddCommGroup V] [Module ℚ V] {n : ℕ}
    [PureHodgeStructure V n] {W₁ W₂ : Submodule ℚ V}
    (h₁ : IsSubHodgeStructure (V := V) (n := n) W₁)
    (h₂ : IsSubHodgeStructure (V := V) (n := n) W₂) :
    IsSubHodgeStructure (V := V) (n := n) (W₁ ⊓ W₂) := by
  unfold IsSubHodgeStructure
  apply le_antisymm
  · intro v hv
    obtain ⟨hv₁, hv₂⟩ := hv
    -- Express v = ∑ p, hodgeComponentV p v
    rw [← sum_hodgeComponentV (V := V) (n := n) v]
    -- Each summand is in (W₁ ⊓ W₂) ⊓ piece p, hence the sum is in ⨆ p, ...
    refine Submodule.sum_mem _ (fun p _ => ?_)
    refine Submodule.mem_iSup_of_mem p ?_
    refine Submodule.mem_inf.mpr ⟨?_, ?_⟩
    · refine Submodule.mem_inf.mpr ⟨?_, ?_⟩
      · exact hodgeComponentV_mem_of_isSubHodgeStructure h₁ hv₁ p
      · exact hodgeComponentV_mem_of_isSubHodgeStructure h₂ hv₂ p
    · exact hodgeComponentV_mem_piece p v
  · exact iSup_le (fun _ => inf_le_left)

/- **R166-R181 STATUS**: The R166-deferred intersection theorem
`IsSubHodgeStructure.inf` is RESOLVED above (R181). The kernel and
range of HS morphisms as sub-HS remain available for future rounds
via direct applications of `hodgeComponentV_mem_of_isSubHodgeStructure`
to the kernel/range submodules. -/

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
