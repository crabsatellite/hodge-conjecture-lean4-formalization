/-
# HC Gap L4 -- Front C26: Cartan-line exactness obstruction (R567).

R566 rewrote the remaining FrontC Matsushima boundary target as three
Cartan-line exactness statements.  This file records the matching
negative result: those three statements are not consequences of the
current abstract interfaces alone.

The countermodel keeps all relevant typeclasses inhabited, including
`CompactDualData`, `CartanCompactDualIso`, `MatsushimaData`,
`MatsushimaSurjectivityData`, `MatsushimaCompactDualData`, and the
cuspidal/Eisenstein target fields.  It deliberately chooses the
Matsushima source, compact-dual carrier, and trivial-module target to be
zero while Cartan's H8 line is the nonzero span of `1`.

This is not a route reset.  It prevents a fake closure: the next positive
step must supply genuine EVII geometry identifying these abstract
subspaces with the Cartan H8 line and its image.
-/

import HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC26_CartanLineExactnessObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic

/-- A fresh one-dimensional carrier for the obstruction model.  It is a
type alias so the deliberately bad instances do not overlap ordinary
`Rat` sanity instances. -/
def CartanLineCounter := Rat

instance : CommRing CartanLineCounter := inferInstanceAs (CommRing Rat)
instance : Algebra Rat CartanLineCounter := inferInstanceAs (Algebra Rat Rat)
instance : AddCommGroup CartanLineCounter := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat CartanLineCounter := inferInstanceAs (Module Rat Rat)

noncomputable instance instCohomologyRingCounter :
    CohomologyRing CartanLineCounter where
  algebraic := ⊤

noncomputable instance instKaehlerClassCounter :
    KaehlerClass CartanLineCounter where
  h := (1 : CartanLineCounter)
  h_isAlgebraic := by
    change (1 : CartanLineCounter) ∈
      (⊤ : Subalgebra Rat CartanLineCounter)
    trivial
  h_pow_4_ne_zero := by
    change (1 : Rat) ^ 4 ≠ 0
    norm_num

noncomputable instance instCompactDualDataCounter :
    CompactDualData CartanLineCounter where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : CartanLineCounter) ^ 4)} : Set CartanLineCounter)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoCounter :
    CartanCompactDualIso CartanLineCounter where
  trivialModuleGK_H8 := CompactDualData.H8 (A := CartanLineCounter)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataCounter :
    MatsushimaData CartanLineCounter CartanLineCounter where
  j_q := LinearMap.id
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    simpa using hxy
  source_invariants := ⊥
  target_invariants := ⊥
  j_q_maps_invariants_to_invariants := by
    intro _ h
    simpa using h
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataCounter :
    MatsushimaSurjectivityData CartanLineCounter CartanLineCounter where
  surjectivity_source := ⊥
  surjectivity_target := ⊥
  surjectivity_eq := by
    show
      Submodule.map (MatsushimaData.j_q
          (A := CartanLineCounter) (B := CartanLineCounter))
        (⊥ : Submodule Rat CartanLineCounter) =
      (⊥ : Submodule Rat CartanLineCounter)
    have hj :
        MatsushimaData.j_q
          (A := CartanLineCounter) (B := CartanLineCounter) =
        LinearMap.id := rfl
    rw [hj, Submodule.map_id]

noncomputable instance instMatsushimaCompactDualDataCounter :
    MatsushimaCompactDualData CartanLineCounter CartanLineCounter where
  compactDual := ⊥
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataCounter :
    CuspidalCohomologyData CartanLineCounter where
  cuspidalSubspace := ⊥
  trivialModulePart := ⊥
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8Counter :
    EisensteinVanishingDeg8 CartanLineCounter CartanLineCounter where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8Counter :
    CuspidalGInvariantTrivialModuleDeg8 CartanLineCounter CartanLineCounter where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change
      (x ∈ (⊥ : Submodule Rat CartanLineCounter) ∧
          x ∈ (⊥ : Submodule Rat CartanLineCounter)) ↔
        x ∈ (⊥ : Submodule Rat CartanLineCounter)
    simp

theorem counter_one_ne_zero : (1 : CartanLineCounter) ≠ 0 := by
  change (1 : Rat) ≠ 0
  norm_num

theorem one_mem_cartan_H8 :
    (1 : CartanLineCounter) ∈
      CartanCompactDualIso.trivialModuleGK_H8 (A := CartanLineCounter) := by
  change
    (1 : CartanLineCounter) ∈
      Submodule.span Rat
        ({((1 : CartanLineCounter) ^ 4)} : Set CartanLineCounter)
  norm_num

/-- **R567 obstruction theorem (1/4)**: the current interfaces do not
force the Matsushima surjectivity source to be Cartan's H8 line. -/
theorem counterexample_source_ne_cartan_H8 :
    MatsushimaSurjectivityData.surjectivity_source
        (A := CartanLineCounter) (B := CartanLineCounter)
      ≠ CartanCompactDualIso.trivialModuleGK_H8
        (A := CartanLineCounter) := by
  intro h
  have hmem :
      (1 : CartanLineCounter) ∈
        MatsushimaSurjectivityData.surjectivity_source
          (A := CartanLineCounter) (B := CartanLineCounter) := by
    rw [h]
    exact one_mem_cartan_H8
  have hzero : (1 : CartanLineCounter) = 0 := by
    simpa using hmem
  exact counter_one_ne_zero hzero

/-- **R567 obstruction theorem (2/4)**: the current interfaces do not
force the Matsushima compact-dual carrier to be Cartan's H8 line. -/
theorem counterexample_compactDual_ne_cartan_H8 :
    MatsushimaCompactDualData.compactDual
        (A := CartanLineCounter) (B := CartanLineCounter)
      ≠ CartanCompactDualIso.trivialModuleGK_H8
        (A := CartanLineCounter) := by
  intro h
  have hmem :
      (1 : CartanLineCounter) ∈
        MatsushimaCompactDualData.compactDual
          (A := CartanLineCounter) (B := CartanLineCounter) := by
    rw [h]
    exact one_mem_cartan_H8
  have hzero : (1 : CartanLineCounter) = 0 := by
    simpa using hmem
  exact counter_one_ne_zero hzero

/-- **R567 obstruction theorem (3/4)**: even with `j_q` injective and
Cartan's H8 line nonzero, the current interfaces do not force the
Cartan image to be the cuspidal trivial-module part. -/
theorem counterexample_cartan_image_ne_trivialModulePart :
    Submodule.map
        (MatsushimaData.j_q
          (A := CartanLineCounter) (B := CartanLineCounter))
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := CartanLineCounter))
      ≠ CuspidalCohomologyData.trivialModulePart
        (A := CartanLineCounter) := by
  intro h
  have hmem :
      (1 : CartanLineCounter) ∈
        Submodule.map
          (MatsushimaData.j_q
            (A := CartanLineCounter) (B := CartanLineCounter))
          (CartanCompactDualIso.trivialModuleGK_H8
            (A := CartanLineCounter)) := by
    refine ⟨1, one_mem_cartan_H8, ?_⟩
    rfl
  rw [h] at hmem
  have hzero : (1 : CartanLineCounter) = 0 := by
    simpa using hmem
  exact counter_one_ne_zero hzero

/-- **R567 obstruction theorem (4/4)**: R566's three Cartan-line
exactness statements are genuine EVII obligations, not consequences of
the current abstract interface. -/
theorem current_interface_does_not_force_cartan_line_exactness :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := CartanLineCounter) (B := CartanLineCounter)
        ≠ CartanCompactDualIso.trivialModuleGK_H8
          (A := CartanLineCounter)) ∧
    (MatsushimaCompactDualData.compactDual
          (A := CartanLineCounter) (B := CartanLineCounter)
        ≠ CartanCompactDualIso.trivialModuleGK_H8
          (A := CartanLineCounter)) ∧
    (Submodule.map
          (MatsushimaData.j_q
            (A := CartanLineCounter) (B := CartanLineCounter))
          (CartanCompactDualIso.trivialModuleGK_H8
            (A := CartanLineCounter))
        ≠ CuspidalCohomologyData.trivialModulePart
          (A := CartanLineCounter)) := by
  exact ⟨counterexample_source_ne_cartan_H8,
    counterexample_compactDual_ne_cartan_H8,
    counterexample_cartan_image_ne_trivialModulePart⟩

def R567_substantiveTheoremCount : Nat := 4

end FrontC26_CartanLineExactnessObstruction
end HCGapL4
end HodgeReduction
