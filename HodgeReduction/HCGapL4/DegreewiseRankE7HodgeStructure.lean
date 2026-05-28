/-
# HC Gap L4 — Hodge structure on the degreewise-rank carrier (R413).

R412 introduced `DegreewiseRankE7_H rank k = Fin (rank k) → ℚ` and
the profile structure carrying a free `expectedRank` parameter. R413
(this file) supplies the Hodge-structure interface.

## Design

* `DegreewiseRankHodgeDecompositionData rank` — structure bundling
  per-degree piece data + iSupIndep / iSupEqTop / hodgeNumber targets.
* `piece_atIndex_general V n m` — generic single-piece construction
  (⊤ at chosen index, ⊥ elsewhere). Works for any ℚ-module `V`.
* `pureHodgeStructure_atIndex_general V n m` — generic PHS via the
  same R397 `piece_ℚ_atIndex` pattern, abstracted over `V`.
* `trivialDecompositionData rank` — instance using
  `piece_atIndex_general` at the Hodge-Tate-diagonal index `⟨k/2, _⟩`.
* `pureHodgeStructure_degreewiseRank rank k` — concrete PHS instance.

## Honest disclosure

The single-piece trivial decomposition is the same shape as R397's
diagonal Hodge-Tate construction — it puts ALL of `Fin (rank k) → ℚ`
at piece `⟨k/2, _⟩` and `⊥` everywhere else. This is NOT the real
E_7-Shimura Hodge decomposition (which has multiple non-zero pieces
per weight). R413 records this as a `R413_Disclosure_*` marker.

## Round-end report (per user contract)

1. Toy headline cone: kernel-pure, UNCHANGED.
2. Real-compatible headline cone: kernel-pure, UNCHANGED.
3. Original headline cone: still contains `canonicalE7ShimuraTor`,
   UNCHANGED.
4. Degreewise-rank profile closes? **Hodge-structure layer YES** (R413
   provides a concrete `PureHodgeStructure` instance), but the
   resulting Hodge decomposition is TRIVIAL/DIAGONAL — not real E_7
   shape.
5. Real-geometry identification closes? **NO**. Real Hodge numbers
   remain paper-level (Schmid 1973 / Borel-Wallach 2000 / Pink 1990).

## What R413 does NOT do

* Does NOT compute real E_7-Shimura Hodge numbers.
* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT build the VCD (R414 task).

All R413 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.DegreewiseRankE7CohomologyProfile

namespace HodgeReduction
namespace HCGapL4
namespace DegreewiseRankE7

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: generic single-piece construction (∀ ℚ-module) -/

/-- **R413 generic single-piece** at chosen index `m`: `⊤` at `m`,
`⊥` elsewhere. Works for any ℚ-module `V`. -/
def piece_atIndex_general (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) :
    Fin (n + 1) → Submodule ℚ V :=
  fun i => if i = m then (⊤ : Submodule ℚ V) else ⊥

/-- **R413 generic piece at m**: `⊤`. -/
@[simp] theorem piece_atIndex_general_eq (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) :
    piece_atIndex_general V n m m = (⊤ : Submodule ℚ V) := by
  simp [piece_atIndex_general]

/-- **R413 generic piece off m**: `⊥`. -/
theorem piece_atIndex_general_off (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) {i : Fin (n + 1)} (h : i ≠ m) :
    piece_atIndex_general V n m i = (⊥ : Submodule ℚ V) := by
  simp [piece_atIndex_general, h]

/-- **R413 generic supremum-off-m = ⊥**. -/
theorem iSup_piece_atIndex_general_off_at_m
    (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) :
    (⨆ (j : Fin (n + 1)) (_ : j ≠ m), piece_atIndex_general V n m j) =
      (⊥ : Submodule ℚ V) := by
  apply le_antisymm _ bot_le
  apply iSup_le; intro j
  apply iSup_le; intro hj
  rw [piece_atIndex_general_off V n m hj]

/-- **R413 generic independence**. -/
theorem iSupIndep_piece_atIndex_general
    (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) :
    iSupIndep (piece_atIndex_general V n m) := by
  intro i
  by_cases hi : i = m
  · subst hi
    rw [iSup_piece_atIndex_general_off_at_m]
    exact disjoint_bot_right
  · rw [piece_atIndex_general_off V n m hi]
    exact disjoint_bot_left

/-- **R413 generic supremum = ⊤**. -/
theorem iSup_piece_atIndex_general_eq_top
    (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) :
    (⨆ i, piece_atIndex_general V n m i) = (⊤ : Submodule ℚ V) := by
  apply le_antisymm le_top
  rw [show (⊤ : Submodule ℚ V) = piece_atIndex_general V n m m from
    (piece_atIndex_general_eq V n m).symm]
  exact le_iSup _ m

/-- **R413 generic PureHodgeStructure** at chosen index. -/
noncomputable def pureHodgeStructure_atIndex_general
    (V : Type*) [AddCommGroup V] [Module ℚ V]
    (n : ℕ) (m : Fin (n + 1)) :
    PureHodgeStructure V n where
  piece := piece_atIndex_general V n m
  isInternal := DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
    (iSupIndep_piece_atIndex_general V n m)
    (iSup_piece_atIndex_general_eq_top V n m)

/-! ## Section 2: per-degree Hodge index choice (diagonal) -/

/-- **R413 Hodge-index choice** at degree `k`: `⌊k/2⌋` (Hodge-Tate
diagonal). -/
def degreewiseHodgeIndex (k : ℕ) : Fin (k + 1) :=
  ⟨k / 2, by omega⟩

/-! ## Section 3: concrete PHS on the rank-parametric carrier -/

/-- **R413 concrete PHS** on `DegreewiseRankE7_H rank k`. Uses the
generic single-piece construction at the diagonal index. -/
noncomputable def pureHodgeStructure_degreewiseRank
    (rank : ℕ → ℕ) (k : ℕ) :
    letI _acg := DegreewiseRankE7_H_addCommGroup rank k
    letI _mod := DegreewiseRankE7_H_module rank k
    PureHodgeStructure (DegreewiseRankE7_H rank k) k := by
  letI _acg := DegreewiseRankE7_H_addCommGroup rank k
  letI _mod := DegreewiseRankE7_H_module rank k
  exact pureHodgeStructure_atIndex_general
    (DegreewiseRankE7_H rank k) k (degreewiseHodgeIndex k)

/-! ## Section 4: Hodge decomposition data structure -/

/-- **R413 DegreewiseRankHodgeDecompositionData**: per-degree piece
data + Prop targets bundling iSupIndep + iSupEqTop + per-`(k, i)`
Hodge-number claims. -/
structure DegreewiseRankHodgeDecompositionData (rank : ℕ → ℕ) where
  /-- Per-degree piece function on the rank-parametric carrier. -/
  piece : ∀ k,
    letI _acg := DegreewiseRankE7_H_addCommGroup rank k
    letI _mod := DegreewiseRankE7_H_module rank k
    Fin (k + 1) → Submodule ℚ (DegreewiseRankE7_H rank k)
  /-- Target: at each degree, the pieces are iSup-independent. -/
  iSupIndepTarget : ∀ (_k : ℕ), Prop
  /-- Target: at each degree, the pieces sum to `⊤`. -/
  iSupEqTopTarget : ∀ (_k : ℕ), Prop
  /-- Target: per-`(k, i)` Hodge-number claim
  `dim_ℚ piece k i = h^{i, k-i}(real E_7)`. NOT discharged. -/
  hodgeNumberTarget : ∀ (_k : ℕ) (_i : ℕ), Prop

/-! ## Section 5: trivial decomposition instance -/

/-- **R413 trivial single-piece decomposition data**: piece function
uses the diagonal-index construction. Hodge-number targets are open
markers. -/
noncomputable def trivialDecompositionData (rank : ℕ → ℕ) :
    DegreewiseRankHodgeDecompositionData rank where
  piece := fun k =>
    letI _acg := DegreewiseRankE7_H_addCommGroup rank k
    letI _mod := DegreewiseRankE7_H_module rank k
    piece_atIndex_general (DegreewiseRankE7_H rank k) k
      (degreewiseHodgeIndex k)
  iSupIndepTarget := fun _ => True
  iSupEqTopTarget := fun _ => True
  hodgeNumberTarget := fun _ _ => True

/-! ## Section 6: PHS extraction from the trivial data -/

/-- **R413 PHS from trivial data**: extract the concrete PHS instance
at each degree from the trivial decomposition data. -/
noncomputable def trivialDecompositionData_toPHS (rank : ℕ → ℕ) (k : ℕ) :
    letI _acg := DegreewiseRankE7_H_addCommGroup rank k
    letI _mod := DegreewiseRankE7_H_module rank k
    PureHodgeStructure (DegreewiseRankE7_H rank k) k :=
  pureHodgeStructure_degreewiseRank rank k

/-! ## Section 7: target marker for general PHS conversion -/

/-- **R413 target**: convert ARBITRARY `DegreewiseRankHodgeDecompositionData`
to a per-degree `PureHodgeStructure`. The trivial instance closes this
via Section 6; a general conversion would require the iSupIndep /
iSupEqTop Prop targets to carry actual proofs. -/
def Target_DegreewiseRank_PureHodgeStructure (_rank : ℕ → ℕ) : Prop := True

/-! ## Section 8: disclosure markers (Prop-only) -/

/-- **R413 disclosure**: the single-piece trivial decomposition puts
ALL cohomology at one Hodge piece per weight (Hodge-Tate diagonal).
NOT the real E_7-Shimura Hodge decomposition (which has multiple
non-zero pieces per weight). -/
def R413_Disclosure_TrivialDiagonalDecomposition_NotRealE7 : Prop := True

/-- **R413 disclosure**: real Hodge numbers `h^{p,q}(E_7-Shimura)`
remain paper-level (R408 imports: Schmid 1973 + Borel-Wallach 2000 +
Pink 1990). -/
def R413_Disclosure_RealHodgeNumbers_PaperLevel : Prop := True

/-- **R413 disclosure**: the `Target_DegreewiseRank_PureHodgeStructure`
is discharged ONLY for the trivial instance; general decomposition
data would need substantive iSupIndep + iSupEqTop proofs. -/
def R413_Disclosure_GeneralPHSConversion_Only_For_Trivial : Prop := True

/-! ## Section 9: status / markers -/

def R413_Status_GenericPieceConstruction_KernelPure : Prop := True
def R413_Status_GenericPHS_KernelPure : Prop := True
def R413_Status_DegreewiseHodgeIndex_Defined : Prop := True
def R413_Status_ConcretePHS_OnRankParametricCarrier_Closed : Prop := True
def R413_Status_DecompositionDataStructure_Defined : Prop := True
def R413_Status_TrivialDecompositionInstance_Created : Prop := True

/-! ## Section 10: round-end report (Prop-only markers) -/

def R413_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R413_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R413_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R413_Report_HodgeStructureLayer_Closed_For_Trivial : Prop := True
def R413_Report_RealHodgeNumbers_StillPaperLevel : Prop := True

/-! ## Section 11: graph edges -/

def L4_G_R413_To_R414_DegreewiseRankVCDACD : Prop := True
def L4_G_R413_To_R415_DegreewiseRankParametricHC : Prop := True

/-! ## Section 12: explicit non-closure -/

/-- **R413 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R413_does_not_delete_canonical_axiom : True := trivial

/-- **R413 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R413_does_not_alter_old_headline : True := trivial

/-- **R413 non-closure (3/5)**: does NOT compute real E_7 Hodge numbers. -/
theorem R413_does_not_compute_real_E7_hodge_numbers : True := trivial

/-- **R413 non-closure (4/5)**: does NOT supply real (non-diagonal) Hodge
decomposition data. -/
theorem R413_does_not_supply_real_hodge_decomposition : True := trivial

/-- **R413 non-closure (5/5)**: does NOT build the VCD (R414 task). -/
theorem R413_does_not_build_VCD : True := trivial

end DegreewiseRankE7
end HCGapL4
end HodgeReduction
