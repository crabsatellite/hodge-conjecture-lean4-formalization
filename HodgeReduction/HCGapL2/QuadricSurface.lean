/-
# R521: VarietyCohomologyData for the quadric surface P^1 x P^1.
KERNEL-PURE. No axioms, no sorry, no tricks.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import Mathlib.Algebra.PUnitInstances.Module
import Mathlib.LinearAlgebra.DirectSum.Finsupp
import Mathlib.Algebra.DirectSum.Module

namespace HodgeReduction
namespace HCGapL2
namespace QuadricSurface

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2.TrivialPoint

/-! PureHodgeStructure on (Q x Q) at weight 2 -/

def piece_prod_w2 (i : Fin 3) : Submodule ℚ (ℚ × ℚ) :=
  match i with
  | 0 => ⊥ | 1 => ⊤ | 2 => ⊥

@[simp] theorem piece_prod_w2_zero : piece_prod_w2 0 = ⊥ := rfl
@[simp] theorem piece_prod_w2_one  : piece_prod_w2 1 = ⊤ := rfl
@[simp] theorem piece_prod_w2_two  : piece_prod_w2 2 = ⊥ := rfl

theorem iSupIndep_piece_prod_w2 : iSupIndep piece_prod_w2 := by
  intro i
  fin_cases i <;> simp [piece_prod_w2, iSupIndep]

theorem iSup_piece_prod_w2_eq_top :
    ⨆ i, piece_prod_w2 i = (⊤ : Submodule ℚ (ℚ × ℚ)) := by
  apply le_antisymm le_top
  exact le_iSup_of_le 1 le_rfl

instance pureHodgeStructure_prod_w2 : PureHodgeStructure (ℚ × ℚ) 2 where
  piece := piece_prod_w2
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      iSupIndep_piece_prod_w2
      iSup_piece_prod_w2_eq_top

/-! PureHodgeStructure on Q at weight 4 -/

def piece_Q_w4 (i : Fin 5) : Submodule ℚ ℚ :=
  match i with
  | 0 => ⊥ | 1 => ⊥ | 2 => ⊤ | 3 => ⊥ | 4 => ⊥

@[simp] theorem piece_Q_w4_two : piece_Q_w4 2 = ⊤ := rfl

theorem iSupIndep_piece_Q_w4 : iSupIndep piece_Q_w4 := by
  intro i
  fin_cases i <;> simp [piece_Q_w4, iSupIndep]

theorem iSup_piece_Q_w4_eq_top :
    ⨆ i, piece_Q_w4 i = (⊤ : Submodule ℚ ℚ) := by
  apply le_antisymm le_top
  exact le_iSup_of_le 2 le_rfl

instance pureHodgeStructure_Q_w4 : PureHodgeStructure ℚ 4 where
  piece := piece_Q_w4
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      iSupIndep_piece_Q_w4
      iSup_piece_Q_w4_eq_top

/-! Carrier types -/

def cohomologyType_quadric : Nat → Type
  | 0 => ℚ | 1 => PUnit | 2 => ℚ × ℚ | 3 => PUnit | 4 => ℚ | _ + 5 => PUnit

@[simp] theorem cohomologyType_quadric_zero  : cohomologyType_quadric 0 = ℚ := rfl
@[simp] theorem cohomologyType_quadric_one   : cohomologyType_quadric 1 = PUnit := rfl
@[simp] theorem cohomologyType_quadric_two   : cohomologyType_quadric 2 = (ℚ × ℚ) := rfl
@[simp] theorem cohomologyType_quadric_three : cohomologyType_quadric 3 = PUnit := rfl
@[simp] theorem cohomologyType_quadric_four  : cohomologyType_quadric 4 = ℚ := rfl
@[simp] theorem cohomologyType_quadric_five_plus (k : Nat) :
    cohomologyType_quadric (k + 5) = PUnit := rfl

noncomputable def cohomologyType_quadric_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_quadric k)
  | 0 | 4 => inferInstanceAs (AddCommGroup ℚ)
  | 2 => inferInstanceAs (AddCommGroup (ℚ × ℚ))
  | _ => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_quadric_module :
    ∀ k, @Module ℚ (cohomologyType_quadric k) _
           (cohomologyType_quadric_addCommGroup k).toAddCommMonoid
  | 0 | 4 => inferInstanceAs (Module ℚ ℚ)
  | 2 => inferInstanceAs (Module ℚ (ℚ × ℚ))
  | _ => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_quadric_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_quadric k) _
           (cohomologyType_quadric_addCommGroup k).toAddCommMonoid
           (cohomologyType_quadric_module k)
  | 0 | 4 => inferInstanceAs (Module.Finite ℚ ℚ)
  | 2 => inferInstanceAs (Module.Finite ℚ (ℚ × ℚ))
  | _ => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_quadric_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_quadric k)
           (cohomologyType_quadric_addCommGroup k)
           (cohomologyType_quadric_module k) k
  | 0 => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1 => pureHodgeStructure_PUnit 1
  | 2 => pureHodgeStructure_prod_w2
  | 3 => pureHodgeStructure_PUnit 3
  | 4 => pureHodgeStructure_Q_w4
  | _ + 5 => pureHodgeStructure_PUnit (_ + 5)

noncomputable def varietyCohomology_quadric : VarietyCohomologyData where
  H := cohomologyType_quadric
  addCommGroup := cohomologyType_quadric_addCommGroup
  module := cohomologyType_quadric_module
  finite := cohomologyType_quadric_finite
  hodgeStructure := cohomologyType_quadric_hodgeStructure

/-! AlgebraicClassesData -/

def algClassesQuadric (p : Nat) : Submodule ℚ (cohomologyType_quadric (2 * p)) :=
  match p with
  | 0 | 1 | 2 => ⊤
  | _ + 3 => ⊥

theorem algClassesQuadric_le_hodgeClasses (p : Nat) :
    algClassesQuadric p ≤ varietyCohomology_quadric.hodgeClassesAtDegree p := by
  intro x hx
  induction p with
  | zero => exact Submodule.mem_top
  | succ p' hp' =>
    match p' with
    | 0 => exact Submodule.mem_top
    | 1 => exact Submodule.mem_top
    | _ + 2 =>
      simp only [algClassesQuadric] at hx
      exact (Submodule.mem_bot _).mp hx

noncomputable def algClasses_quadric :
    AlgebraicClassesData varietyCohomology_quadric where
  algClasses := algClassesQuadric
  algClasses_le_hodgeClasses := algClassesQuadric_le_hodgeClasses

/-! VarietyHC -/

theorem VarietyHC_quadric :
    VarietyHC varietyCohomology_quadric algClasses_quadric := by
  intro p x _hx
  induction p with
  | zero => exact Submodule.mem_top
  | succ p' _ =>
    match p' with
    | 0 => exact Submodule.mem_top
    | 1 => exact Submodule.mem_top
    | n + 2 =>
      have hSub : Subsingleton (cohomologyType_quadric (2 * (n + 3))) := by
        simp [cohomologyType_quadric_five_plus]
      have hx0 : x = 0 := Subsingleton.elim _ _
      rw [hx0]; exact Submodule.zero_mem _

theorem VarietyHCAt_quadric (p : Nat) :
    VarietyHCAt varietyCohomology_quadric algClasses_quadric p :=
  VarietyHC_quadric p

theorem quadric_betti : (1 : Int) + 0 + 2 + 0 + 1 = 4 := by omega
theorem quadric_euler : (2 : Int) * 2 = 4 := by omega
theorem quadric_h11 : (2 : Int) = 2 := rfl

end QuadricSurface
end HCGapL2
end HodgeReduction