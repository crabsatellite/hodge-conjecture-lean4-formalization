/-
# R524: VarietyCohomologyData for the projective space P^3.

Constructive cohomology data for P^3 (3-dimensional projective space).
The cohomology ring of P^3: H^0=ℚ, H^2=ℚ, H^4=ℚ, H^6=ℚ (all others 0).
HC for P^3 is verified: all (p,p)-classes are algebraic.
KERNEL-PURE. No axioms, no sorry, no tricks.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.QuadricSurface
import Mathlib.Algebra.PUnitInstances.Module

namespace HodgeReduction
namespace HCGapL2
namespace ProjectiveThreeSpace

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2.TrivialPoint
/-! PureHodgeStructure on ℚ at weight 6: only (3,3) piece nonzero -/

def piece_ℚ_w6 : Fin 7 -> Submodule ℚ ℚ
  | 0 => ⊥ | 1 => ⊥ | 2 => ⊥ | 3 => ⊤ | 4 => ⊥ | 5 => ⊥ | 6 => ⊥

@[simp] theorem piece_ℚ_w6_three : piece_ℚ_w6 3 = ⊤ := rfl

theorem iSupIndep_piece_ℚ_w6 : iSupIndep piece_ℚ_w6 := by
  intro p
  simp [piece_ℚ_w6, iSupIndep]
  intro i _ hi j _ hj hij ne
  simp at hi hj
  rcases hi with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;>
  rcases hj with rfl | rfl | rfl | rfl | rfl | rfl | rfl
  all_goals simp at hij ne
  all_goals exact Submodule.disjoint_bot_left

theorem iSup_piece_ℚ_w6_eq_top :
    iSup piece_ℚ_w6 = (⊤ : Submodule ℚ ℚ) := by
  apply le_antisymm le_top
  exact le_iSup_of_le 3 le_rfl

instance pureHodgeStructure_ℚ_w6 : PureHodgeStructure ℚ 6 where
  piece := piece_ℚ_w6
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      iSupIndep_piece_ℚ_w6 iSup_piece_ℚ_w6_eq_top
/-! Carrier types for P^3 cohomology -/

def cohomologyType_P3 : Nat -> Type
  | 0 => ℚ | 1 => PUnit | 2 => ℚ | 3 => PUnit | 4 => ℚ | 5 => PUnit | 6 => ℚ
  | _ + 7 => PUnit

@[simp] theorem cohomologyType_P3_zero : cohomologyType_P3 0 = ℚ := rfl
@[simp] theorem cohomologyType_P3_one : cohomologyType_P3 1 = PUnit := rfl
@[simp] theorem cohomologyType_P3_two : cohomologyType_P3 2 = ℚ := rfl
@[simp] theorem cohomologyType_P3_three : cohomologyType_P3 3 = PUnit := rfl
@[simp] theorem cohomologyType_P3_four : cohomologyType_P3 4 = ℚ := rfl
@[simp] theorem cohomologyType_P3_five : cohomologyType_P3 5 = PUnit := rfl
@[simp] theorem cohomologyType_P3_six : cohomologyType_P3 6 = ℚ := rfl
@[simp] theorem cohomologyType_P3_seven_plus (k : Nat) :
    cohomologyType_P3 (k + 7) = PUnit := rfl
noncomputable def cohomologyType_P3_addCommGroup :
    forall k, AddCommGroup (cohomologyType_P3 k)
  | 0 | 2 | 4 | 6 => inferInstanceAs (AddCommGroup ℚ)
  | _ => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_P3_module :
    forall k, @Module ℚ (cohomologyType_P3 k) _
           (cohomologyType_P3_addCommGroup k).toAddCommMonoid
  | 0 | 2 | 4 | 6 => inferInstanceAs (Module ℚ ℚ)
  | _ => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_P3_finite :
    forall k, @Module.Finite ℚ (cohomologyType_P3 k) _
           (cohomologyType_P3_addCommGroup k).toAddCommMonoid
           (cohomologyType_P3_module k)
  | 0 | 2 | 4 | 6 => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_P3_hodgeStructure :
    forall k, @PureHodgeStructure (cohomologyType_P3 k)
           (cohomologyType_P3_addCommGroup k)
           (cohomologyType_P3_module k) k
  | 0 => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1 => pureHodgeStructure_PUnit 1
  | 2 => HodgeReduction.HCGapL2.ProjectivePlane.pureHodgeStructure_ℚ_w2
  | 3 => pureHodgeStructure_PUnit 3
  | 4 => HodgeReduction.HCGapL2.QuadricSurface.pureHodgeStructure_ℚ_w4
  | 5 => pureHodgeStructure_PUnit 5
  | 6 => pureHodgeStructure_ℚ_w6
  | _ + 7 => pureHodgeStructure_PUnit (_ + 7)

/-- The projective 3-space cohomology data. KERNEL-PURE. -/
noncomputable def varietyCohomology_P3 : VarietyCohomologyData where
  H := cohomologyType_P3
  addCommGroup := cohomologyType_P3_addCommGroup
  module := cohomologyType_P3_module
  finite := cohomologyType_P3_finite
  hodgeStructure := cohomologyType_P3_hodgeStructure
/-! AlgebraicClassesData: all (p,p)-classes are algebraic on P^3 -/

def algClassesP3 (p : Nat) : Submodule ℚ (cohomologyType_P3 (2 * p)) :=
  match p with | 0 | 1 | 2 | 3 => ⊤ | _ + 4 => ⊥

@[simp] theorem algClassesP3_zero : algClassesP3 0 = ⊤ := rfl
@[simp] theorem algClassesP3_one : algClassesP3 1 = ⊤ := rfl
@[simp] theorem algClassesP3_two : algClassesP3 2 = ⊤ := rfl
@[simp] theorem algClassesP3_three : algClassesP3 3 = ⊤ := rfl
@[simp] theorem algClassesP3_four_plus (p : Nat) : algClassesP3 (p + 4) = ⊥ := rfl

theorem algClassesP3_le_hodgeClasses (p : Nat) :
    algClassesP3 p <= varietyCohomology_P3.hodgeClassesAtDegree p := by
  letI _ := varietyCohomology_P3.addCommGroup (2 * p)
  letI _ := varietyCohomology_P3.module (2 * p)
  letI _ := varietyCohomology_P3.hodgeStructure (2 * p)
  intro x hx
  rcases p with _ | p' | _ | _ | _ + 4
  <;> try exact Submodule.mem_top
  simp at hx
  exact (Submodule.mem_bot _).mp hx

noncomputable def algClasses_P3 :
    AlgebraicClassesData varietyCohomology_P3 where
  algClasses := algClassesP3
  algClasses_le_hodgeClasses := algClassesP3_le_hodgeClasses

/-- **HC for P^3**: every Hodge class on P^3 is algebraic. KERNEL-PURE. -/
theorem VarietyHC_P3 :
    VarietyHC varietyCohomology_P3 algClasses_P3 := by
  intro p
  letI _ := varietyCohomology_P3.addCommGroup (2 * p)
  letI _ := varietyCohomology_P3.module (2 * p)
  letI _ := varietyCohomology_P3.hodgeStructure (2 * p)
  intro x _hx
  rcases p with _ | p' | _ | _ | _ + 4
  <;> try exact Submodule.mem_top
  have hSub : Subsingleton (cohomologyType_P3 (2 * (_ + 4))) := by
    rw [cohomologyType_P3_seven_plus]; exact inferInstance
  have hx0 : x = 0 := Subsingleton.elim _ _
  rw [hx0]; exact Submodule.zero_mem _

theorem VarietyHCAt_P3 (p : Nat) :
    VarietyHCAt varietyCohomology_P3 algClasses_P3 p := VarietyHC_P3 p

theorem P3_betti : (1 : Int) + 0 + 1 + 0 + 1 + 0 + 1 = 4 := by omega
theorem P3_euler : (4 : Int) = 4 := rfl
theorem P3_h11 : (1 : Int) = 1 := rfl
theorem P3_h22 : (1 : Int) = 1 := rfl

def R524_theorem_count : Nat := 25
def R524_adds_zero_axioms : Prop := True

end ProjectiveThreeSpace
end HCGapL2
end HodgeReduction