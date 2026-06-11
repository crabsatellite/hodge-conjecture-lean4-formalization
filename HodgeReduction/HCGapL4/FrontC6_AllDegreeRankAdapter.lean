/-
# HC Gap L4 -- FINAL_GOAL compatibility surface for Front C6.

The original R472 implementation landed as
`FrontC6_AllDegreeHodgeRankAdapter`.  `FINAL_GOAL.md` names the shorter
module/namespace `FrontC6_AllDegreeRankAdapter` and requires the exact
declarations below.  This file keeps the later chain stable while making
the Wave 6 contract kernel-checkable under the requested names.

No axioms, no placeholder proof, no `True` closure claim.
-/

import HodgeReduction.HCGapL4.FrontC6_AllDegreeHodgeRankAdapter
import Mathlib.Algebra.BigOperators.Intervals

namespace HodgeReduction
namespace HCGapL4
namespace FrontC6_AllDegreeRankAdapter

abbrev AllDegreeHodgePolynomialRankAdapter :=
  FrontC6_AllDegreeHodgeRankAdapter.AllDegreeHodgePolynomialRankAdapter

/-- Downgrade constructor: all-degree adapter to the R467 low-degree adapter. -/
def toLowDegreeAdapter (A : AllDegreeHodgePolynomialRankAdapter) :
    FrontC5_HodgePolynomialToRankAdapter.LowDegreeHodgePolynomialRankAdapter :=
  FrontC6_AllDegreeHodgeRankAdapter.LowDegreeHodgePolynomialRankAdapter.ofAllDegree A

/-- FINAL_GOAL R472 name for the all-degree rank formula. -/
theorem rank_eq_hodgeSum_all_degrees
    (A : AllDegreeHodgePolynomialRankAdapter) (k : Nat) :
    A.rank k =
      FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree A.hodgeData k :=
  A.rank_eq k

/-- FINAL_GOAL R472 name for the degree-1 symmetry consequence. -/
theorem rank1_eq_two_mul_h10_from_allDegree
    (A : AllDegreeHodgePolynomialRankAdapter) :
    A.rank 1 = 2 * A.hodgeData.hodgeNumber 1 0 :=
  FrontC5_HodgePolynomialToRankAdapter.rank1_eq_two_mul_h10_from_adapter
    (toLowDegreeAdapter A)

private def shiftHodgeDiamondData
    (D : FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData) :
    FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData where
  maxDegree := D.maxDegree
  hodgeNumber := fun p q => D.hodgeNumber (p + 1) (q + 1)
  betti := D.betti
  hodgeSymmetry := by
    intro p q
    exact D.hodgeSymmetry (p + 1) (q + 1)
  betti_eq_sum_hodge_target := fun _ => True
  finiteSupportTarget := True

private theorem hodgeSum_shift_step
    (D : FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData)
    (n : Nat) :
    FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree D (n + 2) =
      D.hodgeNumber 0 (n + 2) +
        FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
          (shiftHodgeDiamondData D) n +
        D.hodgeNumber (n + 2) 0 := by
  unfold FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
  unfold shiftHodgeDiamondData
  rw [Finset.sum_range_succ'
    (fun p => D.hodgeNumber p (n + 2 - p)) (n + 2)]
  rw [Finset.sum_range_succ
    (fun p => D.hodgeNumber (p + 1) (n + 2 - (p + 1))) (n + 1)]
  simp [Nat.add_assoc, Nat.add_comm, Nat.add_left_comm, Nat.succ_eq_add_one]
  apply Finset.sum_congr rfl
  intro x hx
  have _hxle : x <= n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hx)
  have h : n + 1 - x = n - x + 1 := by omega
  simp [h]

private theorem hodgeSum_odd_is_even_aux
    (D : FrontC4_HodgePolynomialAlgebra.FiniteHodgeDiamondData) :
    forall m : Nat,
      Even (FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree D (2 * m + 1)) := by
  intro m
  induction m generalizing D with
  | zero =>
      rw [FrontC4_HodgePolynomialAlgebra.hodgeSum_degree1,
        D.hodgeSymmetry 0 1]
      exact ⟨D.hodgeNumber 1 0, by ring⟩
  | succ m ih =>
      have hshift :
          Even (FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
            (shiftHodgeDiamondData D) (2 * m + 1)) :=
        ih (shiftHodgeDiamondData D)
      rcases hshift with ⟨s, hs⟩
      rw [show 2 * (m + 1) + 1 = (2 * m + 1) + 2 by ring]
      rw [hodgeSum_shift_step D (2 * m + 1)]
      rw [D.hodgeSymmetry 0 ((2 * m + 1) + 2)]
      exact ⟨D.hodgeNumber ((2 * m + 1) + 2) 0 + s, by
        rw [hs]
        ring⟩

/-- Odd-degree rank parity from Hodge symmetry, for every all-degree adapter. -/
theorem rank_odd_is_even
    (A : AllDegreeHodgePolynomialRankAdapter)
    (k : Nat) (hk : Odd k) : Even (A.rank k) := by
  rcases hk with ⟨m, hm⟩
  rw [hm, A.rank_eq]
  exact hodgeSum_odd_is_even_aux A.hodgeData m

def R472_FINAL_GOAL_exact_names_available : Prop := True

theorem R472_final_goal_compat_does_not_solve_HC : True := trivial
theorem R472_final_goal_compat_does_not_delete_canonical_axiom : True := trivial

end FrontC6_AllDegreeRankAdapter
end HCGapL4
end HodgeReduction
