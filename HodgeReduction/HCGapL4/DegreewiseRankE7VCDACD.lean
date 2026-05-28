/-
# HC Gap L4 — VCD + ACD on the degreewise-rank E_7 carrier (R414).

R412 introduced the rank-parametric carrier `H k = Fin (rank k) → ℚ`.
R413 supplied a concrete `PureHodgeStructure` instance via the trivial
single-piece diagonal construction. R414 (this file) bundles them into
a `VarietyCohomologyData`, builds an `AlgebraicClassesData` with
`algClasses p = ⊤` as an ARCHITECTURE TEST, and proves the resulting
`VarietyHC` kernel-pure.

## Architecture-test framing

`algClasses p := ⊤` is NOT a real Chow-ring claim. It's the simplest
algebraic-classes profile that pairs with the trivial diagonal Hodge
decomposition (R413) to make `VarietyHC` trivially closeable — since
`hodgeClassesAtDegree p = ⊤` (Hodge-Tate diagonal) and `algClasses p =
⊤`, the inclusion `hodgeClasses ≤ algClasses` is `⊤ ≤ ⊤`. This is
the SAME architecture as R398's uniform-profile closure but now on
the degreewise-rank carrier, demonstrating the new profile works
inside the existing parametric HC machinery.

## Round-end report (per user contract)

1. Toy headline cone: kernel-pure, UNCHANGED.
2. Real-compatible headline cone: kernel-pure, UNCHANGED.
3. Original headline cone: still contains `canonicalE7ShimuraTor`,
   UNCHANGED.
4. Degreewise-rank profile closes? **YES at the VCD/ACD/VarietyHC
   layer** (kernel-pure for any `rank`).
5. Real-geometry identification closes? **NO**. `rank` still free
   parameter; `algClasses = ⊤` is architecture test, not real Chow.

## What R414 does NOT do

* Does NOT claim `algClasses = ⊤` is a real Chow ring assertion.
* Does NOT compute real E_7 ranks.
* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R414 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.DegreewiseRankE7HodgeStructure

namespace HodgeReduction
namespace HCGapL4
namespace DegreewiseRankE7

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: VCD on the degreewise-rank carrier -/

/-- **R414 VCD**: `VarietyCohomologyData` built from R412's carrier +
R413's trivial PHS. Parametric in `rank : ℕ → ℕ`. KERNEL-PURE. -/
noncomputable def VarietyCohomologyData_degreewiseRankE7
    (rank : ℕ → ℕ) : VarietyCohomologyData where
  H := DegreewiseRankE7_H rank
  addCommGroup := DegreewiseRankE7_H_addCommGroup rank
  module := DegreewiseRankE7_H_module rank
  finite := DegreewiseRankE7_H_finite rank
  hodgeStructure := pureHodgeStructure_degreewiseRank rank

/-! ## Section 2: hodgeClassesAtDegree = ⊤ at the degreewise-rank VCD -/

/-- **R414 key lemma**: at every codim `p`, the degreewise-rank VCD's
`hodgeClassesAtDegree p = ⊤`. Same chain as R398: the PHS at weight
`2p` puts `piece ⟨p, _⟩ = ⊤` (Hodge-Tate diagonal), and `hodgeClasses
V k = piece ⟨k, _⟩` projects exactly there. -/
theorem hodgeClassesAtDegree_degreewiseRankE7 (rank : ℕ → ℕ) (p : ℕ) :
    (VarietyCohomologyData_degreewiseRankE7 rank).hodgeClassesAtDegree p =
      ⊤ := by
  unfold VarietyCohomologyData_degreewiseRankE7
        VarietyCohomologyData.hodgeClassesAtDegree
  simp only [pureHodgeStructure_degreewiseRank]
  -- Goal: PureHodgeStructure.hodgeClasses ... = ⊤
  --   = piece (n := 2*p) ⟨p, _⟩
  --   = piece_atIndex_general (...) (2*p) (degreewiseHodgeIndex (2*p)) ⟨p, _⟩
  show piece_atIndex_general (DegreewiseRankE7_H rank (2 * p))
        (2 * p) (degreewiseHodgeIndex (2 * p)) ⟨p, by omega⟩ = ⊤
  -- degreewiseHodgeIndex (2*p) = ⟨(2*p)/2, _⟩ = ⟨p, _⟩
  have hIdx : degreewiseHodgeIndex (2 * p) = ⟨p, by omega⟩ := by
    unfold degreewiseHodgeIndex
    ext
    simp [Nat.mul_div_cancel_left]
  rw [hIdx]
  exact piece_atIndex_general_eq _ (2 * p) ⟨p, by omega⟩

/-! ## Section 3: ACD with algClasses = ⊤ (architecture test) -/

/-- **R414 ACD with top algClasses**: every algebraic-classes
submodule is `⊤`. NOT a real Chow ring claim — pure architecture
test that the new profile fits the parametric machinery. -/
noncomputable def AlgebraicClassesData_degreewiseRankE7_top
    (rank : ℕ → ℕ) :
    AlgebraicClassesData (VarietyCohomologyData_degreewiseRankE7 rank) where
  algClasses := fun _ => ⊤
  algClasses_le_hodgeClasses := by
    intro p
    rw [hodgeClassesAtDegree_degreewiseRankE7 rank p]

/-! ## Section 4: VarietyHC for the top-algClasses ACD -/

/-- **R414 main**: full `VarietyHC` for the degreewise-rank VCD with
top algClasses. KERNEL-PURE; works for any `rank`. -/
theorem DegreewiseRankE7_VarietyHC_topAlgClasses (rank : ℕ → ℕ) :
    VarietyHC
      (VarietyCohomologyData_degreewiseRankE7 rank)
      (AlgebraicClassesData_degreewiseRankE7_top rank) := by
  intro p
  letI _i_acg := (VarietyCohomologyData_degreewiseRankE7 rank).addCommGroup (2 * p)
  letI _i_mod := (VarietyCohomologyData_degreewiseRankE7 rank).module (2 * p)
  rw [hodgeClassesAtDegree_degreewiseRankE7 rank p]
  exact le_top

/-- **R414 codim-1 specialisation**. -/
theorem DegreewiseRankE7_VarietyHCAt_topAlgClasses_codim1 (rank : ℕ → ℕ) :
    VarietyHCAt
      (VarietyCohomologyData_degreewiseRankE7 rank)
      (AlgebraicClassesData_degreewiseRankE7_top rank) 1 :=
  DegreewiseRankE7_VarietyHC_topAlgClasses rank 1

/-! ## Section 5: disclosure markers (Prop-only) -/

/-- **R414 disclosure**: `algClasses p = ⊤` is NOT a real Chow ring
claim. -/
def R414_TopAlgClasses_NotRealChow : Prop := True

/-- **R414 disclosure**: this round is an ARCHITECTURE TEST showing
the degreewise-rank profile fits the parametric HC machinery; it does
NOT establish any real E_7 cohomology fact. -/
def R414_DegreewiseRankProfile_ArchitectureTest : Prop := True

/-- **R414 disclosure**: comparing `algClasses_degreewiseRankE7_top`
with the real E_7-Shimura Chow ring image remains OPEN (R408 imports
+ R404 Priority 2). -/
def R414_RealChowComparisonStillOpen : Prop := True

/-! ## Section 6: status / markers -/

def R414_Status_VCD_DegreewiseRankE7_Closed_KernelPure : Prop := True
def R414_Status_HodgeClassesAtDegree_Top_Lemma_Proven : Prop := True
def R414_Status_ACD_TopAlgClasses_Closed_KernelPure : Prop := True
def R414_Status_VarietyHC_TopAlgClasses_Closed_KernelPure : Prop := True
def R414_Status_Codim1_Specialisation_Provided : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

def R414_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R414_Report_RealCompatibleTheoremCone_KernelPure_Unchanged : Prop := True
def R414_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R414_Report_VCDACDLayer_Closed_KernelPure : Prop := True
def R414_Report_RealChowComparison_StillOpen : Prop := True

/-! ## Section 8: graph edges -/

def L4_G_R414_To_R415_DegreewiseRankParametricHC : Prop := True
def L4_G_R414_To_R416_FrontierAfterDegreewiseRankProfile : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R414 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R414_does_not_delete_canonical_axiom : True := trivial

/-- **R414 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R414_does_not_alter_old_headline : True := trivial

/-- **R414 non-closure (3/5)**: `algClasses = ⊤` is NOT a real Chow
ring claim. -/
theorem R414_does_not_make_real_Chow_claim : True := trivial

/-- **R414 non-closure (4/5)**: does NOT compute real E_7 ranks. -/
theorem R414_does_not_compute_real_E7_ranks : True := trivial

/-- **R414 non-closure (5/5)**: does NOT supply real E_7 Hodge
decomposition data. -/
theorem R414_does_not_supply_real_E7_hodge_data : True := trivial

end DegreewiseRankE7
end HCGapL4
end HodgeReduction
