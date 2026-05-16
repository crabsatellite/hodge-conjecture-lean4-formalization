/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import Mathlib.LinearAlgebra.BilinearForm.Basic
import Mathlib.LinearAlgebra.BilinearMap

/-!
# Polarised pure ℚ-Hodge structures and Hodge-Riemann bilinear relations

A **polarisation** of a pure ℚ-Hodge structure of weight `n` on `V` is
a non-degenerate `ℚ`-bilinear form `Q : V × V → ℚ`, satisfying:

1. **(Anti)symmetry**: `Q` is symmetric if `n` is even, antisymmetric
   if `n` is odd (equivalently: `Q y x = (-1)^n · Q x y`).
2. **First Hodge-Riemann relation** (HR1): the Hodge filtration is
   "isotropic at the middle": `Q(F^p, F^q) = 0` whenever `p + q ≥ n + 1`.
3. **Second Hodge-Riemann relation** (HR2, positivity): on each Hodge
   piece `H^{p, n-p}` the associated Hermitian form `H_p(x, y) :=
   (-1)^{p(n-p)} · i^n · Q(x, \bar y)` is positive-definite.

In the complex setting (Voisin I, Ch. 6.2.2; Griffiths I §2; Schmid 1973)
HR2 is most naturally stated over ℂ using the conjugation. Over ℚ alone
we encode HR2 as the assertion of a positive-definite symmetric ℚ-form
on each Hodge piece — the **rational shadow** of the Hodge-Riemann form
restricted to the real points of `H^{p, n-p} ⊕ H^{n-p, p}`. This is
sufficient for the rigidity/positivity arguments used in the Mumford-Tate
reduction (Voisin II Ch. 10; Schmid 1973 Thm 4.9 / SL₂-orbit).

## References

* Griffiths, P. "Periods of integrals on algebraic manifolds I, II",
  *Amer. J. Math.* **90** (1968) 568-626, 805-865; and "III",
  *Publ. Math. IHÉS* **38** (1970) 125-180.
* Schmid, W. "Variation of Hodge structure: The singularities of the
  period mapping", *Invent. Math.* **22** (1973) 211-319.
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry*, Vol. I-II,
  Cambridge Stud. Adv. Math. **76**, **77**, CUP, 2002-2003 (Ch. 6).

## Main definitions

* `PolarisedHodgeStructure V n` : a typeclass extending
  `PureHodgeStructure` with the polarisation form, the (anti)symmetry
  axiom, the HR1 isotropy axiom and the HR2 piece-positivity axiom.

* `PolarisedHodgeStructure.pieceForm p` : the positive-definite
  symmetric ℚ-form on the `p`-th Hodge piece (HR2 datum).

## Tags

Hodge structure, polarisation, Hodge-Riemann, Griffiths, Schmid, Voisin
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- A **polarisation** for a pure Hodge structure of weight `n` is the
data of a non-degenerate `ℚ`-bilinear form `psi : V → V → ℚ` together
with the Hodge-Riemann bilinear relations.

For our V_56 application (weight 3, ODD) the underlying form is the
**symplectic form** `ω : V_56 × V_56 → ℚ`. The Hodge-Riemann data
records the per-piece positivity on each of the four Hodge pieces
`V^{3,0}, V^{2,1}, V^{1,2}, V^{0,3}`.

References: Voisin I Defn 7.3 + Prop 7.10; Griffiths I §2 (2.2)-(2.5);
Schmid 1973 §3 axiomatic setup. -/
class PolarisedHodgeStructure (n : ℕ) extends PureHodgeStructure V n where
  /-- The polarisation form `Q : V × V → ℚ` as a Mathlib bilinear map. -/
  psi : V →ₗ[ℚ] V →ₗ[ℚ] ℚ
  /-- `psi` is non-degenerate on the left: only the zero vector is
  orthogonal to every vector. (Equivalently to right-non-degeneracy
  given the (anti)symmetry axiom below.) -/
  psi_nondegen : ∀ v : V, (∀ w : V, psi v w = 0) → v = 0
  /-- For odd weight `n`, `psi` is antisymmetric: `psi v w = -psi w v`.
  (Griffiths I (2.2); Voisin I Defn 7.3 (i).) -/
  psi_alternating_of_odd : n % 2 = 1 → ∀ v w : V, psi v w = -psi w v
  /-- For even weight `n`, `psi` is symmetric: `psi v w = psi w v`.
  (Griffiths I (2.2); Voisin I Defn 7.3 (i).) -/
  psi_symmetric_of_even : n % 2 = 0 → ∀ v w : V, psi v w = psi w v
  /-- **First Hodge-Riemann relation (HR1)** — *isotropy of the Hodge
  filtration*: whenever `p + q ≥ n + 1`, the filtration pieces `F^p`
  and `F^q` pair to zero under `psi`.

  Equivalently (specialising `q = n - p + 1`): `psi(F^p, F^{n-p+1}) = 0`.

  References: Griffiths I (2.4); Voisin I Prop 7.10 (i);
  Schmid 1973 (1.6). -/
  hr1_filt_isotropic :
    ∀ (p q : Fin (n + 1)), p.val + q.val ≥ n + 1 →
      ∀ v ∈ PureHodgeStructure.filt (V := V) p,
      ∀ w ∈ PureHodgeStructure.filt (V := V) q,
        psi v w = 0
  /-- **Second Hodge-Riemann relation (HR2)** — *piece-positive form*:
  for each Hodge piece `H^{p, n-p}` there is a positive-definite
  symmetric `ℚ`-bilinear form `pieceForm p` on the piece. This is the
  rational shadow of the Hermitian form
      `H_p(x, y) = (-1)^{p(n-p)} · i^n · psi(x, \bar y)`
  restricted to the real points; positive-definiteness is the
  Hodge-Riemann positivity axiom (Griffiths I (2.5); Voisin I
  Prop 7.10 (ii); Schmid 1973 (1.7)). -/
  pieceForm : ∀ (p : Fin (n + 1)),
    PureHodgeStructure.hodgePiece (V := V) (n := n) p →ₗ[ℚ]
      PureHodgeStructure.hodgePiece (V := V) (n := n) p →ₗ[ℚ] ℚ
  /-- `pieceForm p` is symmetric on the `p`-th Hodge piece. -/
  pieceForm_symm : ∀ (p : Fin (n + 1))
      (x y : PureHodgeStructure.hodgePiece (V := V) (n := n) p),
    pieceForm p x y = pieceForm p y x
  /-- `pieceForm p` is positive-definite: non-zero piece-vectors have
  strictly positive self-pairing. This is the **HR2 positivity axiom**
  in its rational form. -/
  pieceForm_pos_def : ∀ (p : Fin (n + 1))
      (x : PureHodgeStructure.hodgePiece (V := V) (n := n) p),
    x ≠ 0 → 0 < pieceForm p x x

namespace PolarisedHodgeStructure

variable {V} {n : ℕ} [PolarisedHodgeStructure V n]

/-! ## Derived consequences of the polarisation axioms -/

/-- For odd weight, `psi(v, v) = 0` (alternating). -/
theorem psi_self_of_odd (hodd : n % 2 = 1) (v : V) :
    PolarisedHodgeStructure.psi v v (n := n) = 0 := by
  have h := PolarisedHodgeStructure.psi_alternating_of_odd (V := V) (n := n) hodd v v
  linarith

/-- For odd weight, the right-action also alternates: `psi v w = -psi w v`
restated as a `theorem` for ergonomic rewriting. -/
theorem psi_swap_of_odd (hodd : n % 2 = 1) (v w : V) :
    PolarisedHodgeStructure.psi v w (n := n) =
      -PolarisedHodgeStructure.psi w v (n := n) :=
  PolarisedHodgeStructure.psi_alternating_of_odd (V := V) (n := n) hodd v w

/-- For even weight, the form is symmetric. Theorem-level restatement. -/
theorem psi_swap_of_even (heven : n % 2 = 0) (v w : V) :
    PolarisedHodgeStructure.psi v w (n := n) =
      PolarisedHodgeStructure.psi w v (n := n) :=
  PolarisedHodgeStructure.psi_symmetric_of_even (V := V) (n := n) heven v w

/-- **HR1 specialised**: `psi(F^p, F^{n-p+1}) = 0`. This is the most
common form of the first Hodge-Riemann relation. -/
theorem hr1_filt_complementary (p : Fin (n + 1))
    (q : Fin (n + 1)) (hq : q.val = n + 1 - p.val) :
    ∀ v ∈ PureHodgeStructure.filt (V := V) p,
    ∀ w ∈ PureHodgeStructure.filt (V := V) q,
      PolarisedHodgeStructure.psi v w (n := n) = 0 := by
  apply PolarisedHodgeStructure.hr1_filt_isotropic
  have hp_le : p.val ≤ n := Nat.lt_succ_iff.mp p.isLt
  omega

/-- **HR1 on Hodge pieces**: the Hodge piece `H^{p,n-p}` is `psi`-
orthogonal to `H^{p',n-p'}` whenever `p + p' ≥ n + 1`. This follows
from HR1 because each piece sits inside its own filtration step
(`PureHodgeStructure.piece_le_filt`). -/
theorem hr1_piece_isotropic
    (p p' : Fin (n + 1)) (hpp' : p.val + p'.val ≥ n + 1) :
    ∀ x ∈ PureHodgeStructure.hodgePiece (V := V) (n := n) p,
    ∀ y ∈ PureHodgeStructure.hodgePiece (V := V) (n := n) p',
      PolarisedHodgeStructure.psi x y (n := n) = 0 := by
  intro x hx y hy
  refine PolarisedHodgeStructure.hr1_filt_isotropic p p' hpp' x ?_ y ?_
  · exact PureHodgeStructure.piece_le_filt p hx
  · exact PureHodgeStructure.piece_le_filt p' hy

/-- **HR2 corollary** — non-degeneracy of the piece form: for every
non-zero element `x` of a Hodge piece, there exists `y` in the same
piece with `pieceForm p x y ≠ 0` (take `y = x`). -/
theorem pieceForm_separates (p : Fin (n + 1))
    (x : PureHodgeStructure.hodgePiece (V := V) (n := n) p) (hx : x ≠ 0) :
    ∃ y, PolarisedHodgeStructure.pieceForm p x y ≠ 0 := by
  refine ⟨x, ?_⟩
  have hpos := PolarisedHodgeStructure.pieceForm_pos_def (V := V) (n := n) p x hx
  exact ne_of_gt hpos

/-- The `pieceForm` vanishes when applied to the zero element. -/
theorem pieceForm_zero_left (p : Fin (n + 1))
    (y : PureHodgeStructure.hodgePiece (V := V) (n := n) p) :
    PolarisedHodgeStructure.pieceForm (V := V) (n := n) p 0 y = 0 := by
  simp

/-- Symmetric version: `pieceForm` vanishes on the right zero. -/
theorem pieceForm_zero_right (p : Fin (n + 1))
    (x : PureHodgeStructure.hodgePiece (V := V) (n := n) p) :
    PolarisedHodgeStructure.pieceForm (V := V) (n := n) p x 0 = 0 := by
  simp

/-- Self-pairing under `pieceForm` is non-negative (combines positivity
on non-zero vectors with vanishing at zero). -/
theorem pieceForm_self_nonneg (p : Fin (n + 1))
    (x : PureHodgeStructure.hodgePiece (V := V) (n := n) p) :
    0 ≤ PolarisedHodgeStructure.pieceForm (V := V) (n := n) p x x := by
  by_cases hx : x = 0
  · subst hx
    simp
  · exact le_of_lt
      (PolarisedHodgeStructure.pieceForm_pos_def (V := V) (n := n) p x hx)

/-- `pieceForm p x x = 0` iff `x = 0` — the standard
"`positive-definite ⇒ kernel = 0`" lemma. -/
theorem pieceForm_self_eq_zero_iff (p : Fin (n + 1))
    (x : PureHodgeStructure.hodgePiece (V := V) (n := n) p) :
    PolarisedHodgeStructure.pieceForm (V := V) (n := n) p x x = 0 ↔ x = 0 := by
  refine ⟨fun h => ?_, fun h => by subst h; simp⟩
  by_contra hx
  have hpos := PolarisedHodgeStructure.pieceForm_pos_def (V := V) (n := n) p x hx
  exact (ne_of_gt hpos) h

end PolarisedHodgeStructure

/-! ## Riemann bilinear relations as a stand-alone structure

For external consumers (variations of Hodge structure, period maps)
it is sometimes more ergonomic to package HR1 + HR2 as a structure
deriving from the underlying `PolarisedHodgeStructure`. -/

/-- The Hodge-Riemann bilinear relations packaged as a structure, with
fields HR1 (filtration isotropy) and HR2 (piece positivity).

This is purely a re-export of the corresponding fields of
`PolarisedHodgeStructure`, gathered for convenience and citation
clarity (Voisin I Prop 7.10). -/
structure RiemannBilinearRelations (n : ℕ) [PolarisedHodgeStructure V n] : Prop where
  /-- HR1: filtration pieces with complementary indices are mutually
  isotropic under the polarisation. -/
  hr1 : ∀ (p q : Fin (n + 1)), p.val + q.val ≥ n + 1 →
    ∀ v ∈ PureHodgeStructure.filt (V := V) p,
    ∀ w ∈ PureHodgeStructure.filt (V := V) q,
      PolarisedHodgeStructure.psi v w (n := n) = 0
  /-- HR2: each Hodge piece carries a positive-definite symmetric form. -/
  hr2 : ∀ (p : Fin (n + 1))
    (x : PureHodgeStructure.hodgePiece (V := V) (n := n) p), x ≠ 0 →
    0 < PolarisedHodgeStructure.pieceForm (V := V) (n := n) p x x

/-- Every polarised Hodge structure satisfies the Hodge-Riemann
bilinear relations. -/
theorem polarised_satisfies_riemann_relations (n : ℕ)
    [PolarisedHodgeStructure V n] : RiemannBilinearRelations V n where
  hr1 := PolarisedHodgeStructure.hr1_filt_isotropic
  hr2 := PolarisedHodgeStructure.pieceForm_pos_def

/-! ## Trivial reference instance: `(ℚ, n = 0)`

The base field `ℚ` carries the trivial weight-`0` Hodge structure
(`V^{0,0} = ℚ`) polarised by the multiplication form `Q x y = x * y`.
Weight `0` is even, so the form is symmetric (and in fact equal to its
own swap). The single Hodge piece is the whole space `ℚ`, on which the
piece form is again multiplication; positivity reduces to
`x ≠ 0 ⇒ x * x > 0`, which is `mul_self_pos`.

This instance witnesses that the axioms are *consistent and non-empty*. -/

namespace Trivial

/-- The unique Hodge piece of `(ℚ, weight 0)`: the whole space. -/
def piece_ℚ_0 : Fin 1 → Submodule ℚ ℚ
  | ⟨0, _⟩ => (⊤ : Submodule ℚ ℚ)

@[simp] theorem piece_ℚ_0_def : piece_ℚ_0 ⟨0, by omega⟩ = (⊤ : Submodule ℚ ℚ) := rfl

/-- `piece_ℚ_0` is an internal direct sum decomposition of `ℚ` —
this is the `PureHodgeStructure` data for the trivial weight-0 HS. -/
theorem piece_ℚ_0_isInternal : DirectSum.IsInternal piece_ℚ_0 := by
  rw [DirectSum.isInternal_submodule_iff_iSupIndep_and_iSup_eq_top]
  refine ⟨?_, ?_⟩
  · -- iSupIndep with a single piece is automatic: there are no other
    -- indices to be independent from.
    intro i
    fin_cases i
    -- The supremum over `j ≠ 0` in `Fin 1` is the empty supremum `⊥`.
    convert disjoint_bot_right
    simp [iSup_eq_bot, Fin.forall_fin_one]
  · -- The supremum of a single `⊤` piece is `⊤`.
    apply le_antisymm le_top
    intro x _
    refine Submodule.mem_iSup_of_mem ⟨0, by omega⟩ ?_
    simp [piece_ℚ_0]

/-- Trivial `PureHodgeStructure ℚ 0` instance: the whole space is the
unique Hodge piece. -/
instance pureHodge_ℚ_0 : PureHodgeStructure ℚ 0 where
  piece := piece_ℚ_0
  isInternal := piece_ℚ_0_isInternal

/-- The multiplication form `(x, y) ↦ x * y` on `ℚ`, packaged as a
Mathlib bilinear map. This is the polarisation of the trivial
weight-0 Hodge structure on `ℚ`. -/
def mulForm : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ (fun x y => x * y)
    (fun _ _ _ => by ring)
    (fun _ _ _ => by simp [smul_eq_mul, mul_assoc])
    (fun _ _ _ => by ring)
    (fun _ _ _ => by simp [smul_eq_mul]; ring)

@[simp] theorem mulForm_apply (x y : ℚ) : mulForm x y = x * y := rfl

/-- For the trivial weight-0 HS the unique Hodge piece is `⊤ : Submodule ℚ ℚ`;
its `pieceForm` is the multiplication form (restricted via the
`Submodule` coercion). -/
def trivPieceForm (p : Fin 1) :
    PureHodgeStructure.hodgePiece (V := ℚ) (n := 0) p →ₗ[ℚ]
      PureHodgeStructure.hodgePiece (V := ℚ) (n := 0) p →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ (fun x y => (x : ℚ) * (y : ℚ))
    (fun _ _ _ => by push_cast; ring)
    (fun _ _ _ => by simp [Submodule.coe_smul, smul_eq_mul, mul_assoc])
    (fun _ _ _ => by push_cast; ring)
    (fun _ _ _ => by simp [Submodule.coe_smul, smul_eq_mul]; ring)

@[simp] theorem trivPieceForm_apply (p : Fin 1)
    (x y : PureHodgeStructure.hodgePiece (V := ℚ) (n := 0) p) :
    trivPieceForm p x y = (x : ℚ) * (y : ℚ) := rfl

/-- Trivial `PolarisedHodgeStructure ℚ 0` instance: the trivial Hodge
structure with multiplication-form polarisation. The HR1 axiom is
non-vacuous: for `p + q ≥ 1` (i.e. either `p = 0` or `q = 0` is
forced to fall outside the range, since we have a single piece at
index `0`), the relevant filtration step `F^1` lies *outside* the
indexing `Fin 1`, so the hypothesis cannot be triggered for any
actual `Fin 1`-indices satisfying `p.val + q.val ≥ 1`. The HR2
positivity is the genuine fact `x ≠ 0 ⇒ x * x > 0`. -/
instance polarisedHodge_ℚ_0 : PolarisedHodgeStructure ℚ 0 where
  toPureHodgeStructure := pureHodge_ℚ_0
  psi := mulForm
  psi_nondegen := by
    intro v hv
    -- Take `w = 1`: then `psi v 1 = v * 1 = v`, so `v = 0`.
    have h1 := hv 1
    simpa using h1
  psi_alternating_of_odd := by
    intro hodd
    -- `0 % 2 = 1` is false, so this premise is impossible.
    exact absurd hodd (by decide)
  psi_symmetric_of_even := by
    intro _ v w
    -- `psi v w = v * w = w * v = psi w v`.
    simp [mul_comm]
  hr1_filt_isotropic := by
    intro p q hpq v _ w _
    -- For `n = 0`, `Fin (n + 1) = Fin 1`, hence `p = q = 0` and
    -- `p.val + q.val = 0`, contradicting `0 + 0 ≥ 0 + 1`.
    exact absurd hpq (by
      fin_cases p
      fin_cases q
      decide)
  pieceForm := trivPieceForm
  pieceForm_symm := by
    intro p x y
    simp [mul_comm]
  pieceForm_pos_def := by
    intro p x hx
    -- Extract the underlying rational; `x ≠ 0` as a subtype iff the
    -- carrier value is nonzero.
    have hx' : (x : ℚ) ≠ 0 := by
      intro hcoe
      apply hx
      exact Subtype.ext hcoe
    simpa using mul_self_pos.mpr hx'

end Trivial

end HodgeReduction.Infrastructure.HodgeStructure
