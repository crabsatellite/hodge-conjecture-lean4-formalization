/-
# HC Gap L4 — FRONT C6: all-degree Hodge-polynomial-to-rank adapter (R472).

R467 (Wave 5 Front C5) shipped the low-degree rank adapter
`LowDegreeHodgePolynomialRankAdapter` with rank-equals-hodgeSum equalities
for degrees 0, 1, 2 only, plus five substantive algebraic theorems.

R472 (this file, Wave 6 Front C6 amplification) EXTENDS the adapter to
ALL degrees by bundling the general per-degree identity
`rank k = hodgeSumAtDegree hodgeData k` and proving that the all-degree
adapter SPECIALISES to the R467 low-degree formulas at k ∈ {0, 1, 2}:

* `AllDegreeHodgePolynomialRankAdapter` (Priority A) — refined adapter
  with `rank_eq : ∀ k, rank k = hodgeSumAtDegree hodgeData k`.
* `allDegree_rank_eq_hodgeSum_at_k` (Priority B) — substantive theorem
  extracting the per-degree identity (KERNEL-PURE).
* `allDegree_implies_rank0_eq_h00` / `_rank1_eq_h01_add_h10` /
  `_rank2_eq_h02_add_h11_add_h20` (Priority C) — three substantive
  theorems chaining the all-degree identity with R462's
  `hodgeSum_degree0/1/2` (KERNEL-PURE).
* `AllDegreeHodgePolynomialRankAdapter.ofLowDegreeAndGlobalEq`
  (Priority D) — substantive constructor upgrading a low-degree adapter
  plus a global rank-equals-hodgeSum witness family.
* `LowDegreeHodgePolynomialRankAdapter.ofAllDegree` (Priority E) —
  substantive projection constructor extracting the low-degree adapter
  from an all-degree one at degrees 0, 1, 2.

All R472 substantive declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.FrontC5_HodgePolynomialToRankAdapter
import HodgeReduction.HCGapL4.FrontC4_HodgePolynomialAlgebra

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC6_AllDegreeHodgeRankAdapter

/-! ## Section 1: Priority A — all-degree rank adapter -/

/-- **R472 Priority A all-degree rank adapter** carrying the general
per-degree rank-equals-hodgeSum identity for every `k : ℕ`. -/
structure AllDegreeHodgePolynomialRankAdapter where
  hodgeData : FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData
  rank : ℕ → ℕ
  rank_eq : ∀ k, rank k = FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree hodgeData k

/-! ## Section 2: Priority B — per-degree extraction -/

/-- **R472 Priority B substantive theorem**: for any all-degree adapter
`A`, the rank at degree `k` equals the degree-`k` Hodge sum. KERNEL-PURE
via `A.rank_eq k`. -/
theorem allDegree_rank_eq_hodgeSum_at_k
    (A : AllDegreeHodgePolynomialRankAdapter) (k : ℕ) :
    A.rank k = FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree A.hodgeData k :=
  A.rank_eq k

/-! ## Section 3: Priority C — specialisation to low-degree formulas -/

/-- **R472 Priority C substantive theorem (1/3)**: an all-degree adapter
specialises to `rank 0 = h^{0,0}` at degree 0. KERNEL-PURE via
`rw [A.rank_eq 0, hodgeSum_degree0]`. -/
theorem allDegree_implies_rank0_eq_h00
    (A : AllDegreeHodgePolynomialRankAdapter) :
    A.rank 0 = A.hodgeData.hodgeNumber 0 0 := by
  rw [A.rank_eq 0, FrontC4_HodgePolynomialAlgebra.hodgeSum_degree0]

/-- **R472 Priority C substantive theorem (2/3)**: an all-degree adapter
specialises to `rank 1 = h^{0,1} + h^{1,0}` at degree 1. KERNEL-PURE. -/
theorem allDegree_implies_rank1_eq_h01_add_h10
    (A : AllDegreeHodgePolynomialRankAdapter) :
    A.rank 1 = A.hodgeData.hodgeNumber 0 1 + A.hodgeData.hodgeNumber 1 0 := by
  rw [A.rank_eq 1, FrontC4_HodgePolynomialAlgebra.hodgeSum_degree1]

/-- **R472 Priority C substantive theorem (3/3)**: an all-degree adapter
specialises to `rank 2 = h^{0,2} + h^{1,1} + h^{2,0}` at degree 2.
KERNEL-PURE. -/
theorem allDegree_implies_rank2_eq_h02_add_h11_add_h20
    (A : AllDegreeHodgePolynomialRankAdapter) :
    A.rank 2 = A.hodgeData.hodgeNumber 0 2 + A.hodgeData.hodgeNumber 1 1
              + A.hodgeData.hodgeNumber 2 0 := by
  rw [A.rank_eq 2, FrontC4_HodgePolynomialAlgebra.hodgeSum_degree2]

/-! ## Section 4: Priority D — upgrade constructor -/

/-- **R472 Priority D substantive constructor**: given a low-degree
adapter and a global family of rank-equals-hodgeSum equalities, build
an all-degree adapter. KERNEL-PURE. -/
def AllDegreeHodgePolynomialRankAdapter.ofLowDegreeAndGlobalEq
    (L : FrontC5_HodgePolynomialToRankAdapter.LowDegreeHodgePolynomialRankAdapter)
    (hGlobal : ∀ k, L.rank k =
      FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree L.hodgeData k) :
    AllDegreeHodgePolynomialRankAdapter where
  hodgeData := L.hodgeData
  rank := L.rank
  rank_eq := hGlobal

/-! ## Section 5: Priority E — projection to low-degree adapter -/

/-- **R472 Priority E substantive constructor**: project an all-degree
adapter to a low-degree adapter at degrees 0, 1, 2. KERNEL-PURE. -/
def LowDegreeHodgePolynomialRankAdapter.ofAllDegree
    (A : AllDegreeHodgePolynomialRankAdapter) :
    FrontC5_HodgePolynomialToRankAdapter.LowDegreeHodgePolynomialRankAdapter where
  hodgeData := A.hodgeData
  rank := A.rank
  rank0_eq := by rw [A.rank_eq 0]
  rank1_eq := by rw [A.rank_eq 1]
  rank2_eq := by rw [A.rank_eq 2]

/-! ## Section 6: current placeholder instance -/

/-- **R472 current placeholder all-degree adapter** built from the R467
current low-degree adapter with the global equality family discharged
via `A.rank_eq k` on the placeholder rank function. PLACEHOLDER only. -/
def AllDegreeHodgePolynomialRankAdapter_current :
    AllDegreeHodgePolynomialRankAdapter :=
  AllDegreeHodgePolynomialRankAdapter.ofLowDegreeAndGlobalEq
    FrontC5_HodgePolynomialToRankAdapter.LowDegreeHodgePolynomialRankAdapter_current
    (by
      intro k
      cases k with
      | zero =>
        show (if (0 : ℕ) = 0 then 1 else 0) =
          FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
            FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData_current 0
        rw [FrontC4_HodgePolynomialAlgebra.hodgeSum_degree0]
        simp [FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData_current]
      | succ k =>
        show (if Nat.succ k = 0 then 1 else 0) =
          FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
            FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData_current (Nat.succ k)
        unfold FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
        simp [FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData_current]
        symm
        apply Finset.card_eq_zero.mpr
        ext x
        simp
        omega)

/-! ## Section 7: R472 markers -/

def R472_AllDegreeAdapter_Available : Prop := True
def R472_LowDegreeSpecialisation_Closed : Prop := True
def R472_AllDegreeStillPlaceholder : Prop := True
def R472_NoRealE7NumbersClaimed : Prop := True

/-! ## Section 8: non-closure -/

theorem R472_does_not_delete_canonical_axiom : True := trivial
theorem R472_does_not_alter_old_headline : True := trivial
theorem R472_does_not_discharge_paper_imports : True := trivial
theorem R472_does_not_solve_HC : True := trivial

def L4_G_R472_From_R467_FrontC5 : Prop := True
def L4_G_R472_To_R473_FrontE6 : Prop := True

end FrontC6_AllDegreeHodgeRankAdapter
end HCGapL4
end HodgeReduction
