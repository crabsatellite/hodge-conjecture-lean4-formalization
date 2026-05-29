/-
# HC Gap L4 -- Front C19: current interface obstruction (R560).

R559 isolated three compact-dual source obligations.  This file records a
small Lean countermodel showing that those obligations are not forced by
the current abstract `MatsushimaData` / `MatsushimaSurjectivityData` /
`MatsushimaCompactDualData` interfaces.

This is not a failure of the R554--R559 route; it identifies the next
required mathematical input.  A later EVII round must provide genuine
geometry tying the Matsushima surjectivity source to the compact-dual
Cartan source subspace.  More linear algebra over the current interface
cannot prove it.
-/

import HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC19_MatsushimaSourceCompactDualObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic

/-! ## A one-dimensional countermodel to automatic source closure -/

/-- Source carrier for the obstruction model.  It is a fresh type alias
so these deliberately bad instances do not overlap the global
`MatsushimaData Rat Rat` sanity instance. -/
def SourceCounter := Rat

/-- Target carrier for the obstruction model. -/
def TargetCounter := Rat

instance : AddCommGroup SourceCounter := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat SourceCounter := inferInstanceAs (Module Rat Rat)

instance : AddCommGroup TargetCounter := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat TargetCounter := inferInstanceAs (Module Rat Rat)

def sourceCounterNonzero : SourceCounter := (1 : Rat)

theorem sourceCounterNonzero_ne_zero : sourceCounterNonzero ≠ 0 := by
  change (1 : Rat) ≠ 0
  exact one_ne_zero

/-- A model satisfying the current Matsushima base fields where source
invariants are zero but the target invariants are all of the target. -/
noncomputable instance instMatsushimaDataCounter :
    MatsushimaData SourceCounter TargetCounter where
  j_q := LinearMap.id
  injective_range := 8
  j_q_injective := by
    intro x y h
    simpa using h
  source_invariants := ⊥
  target_invariants := ⊤
  j_q_maps_invariants_to_invariants := by
    intro _ _
    exact Submodule.mem_top
  c_E7_eq_8_holds := rfl

/-- The current surjectivity interface permits the surjectivity source
to be all of the source carrier. -/
noncomputable instance instMatsushimaSurjectivityDataCounter :
    MatsushimaSurjectivityData SourceCounter TargetCounter where
  surjectivity_source := ⊤
  surjectivity_target := ⊤
  surjectivity_eq := by
    show
      Submodule.map (MatsushimaData.j_q
          (A := SourceCounter) (B := TargetCounter))
        (⊤ : Submodule Rat SourceCounter) =
      (⊤ : Submodule Rat TargetCounter)
    have hj :
        MatsushimaData.j_q (A := SourceCounter) (B := TargetCounter) =
          LinearMap.id := rfl
    rw [hj, Submodule.map_id]

/-- The current compact-dual interface only ties compact dual to source
invariants, so this model may take both to be zero. -/
noncomputable instance instMatsushimaCompactDualDataCounter :
    MatsushimaCompactDualData SourceCounter TargetCounter where
  compactDual := ⊥
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataCounter :
    CuspidalCohomologyData TargetCounter where
  cuspidalSubspace := ⊤
  trivialModulePart := ⊤
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8Counter :
    EisensteinVanishingDeg8 SourceCounter TargetCounter where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8Counter :
    CuspidalGInvariantTrivialModuleDeg8 SourceCounter TargetCounter where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change x ∈ (⊤ : Submodule Rat TargetCounter) ∧
        x ∈ (⊤ : Submodule Rat TargetCounter) ↔
      x ∈ (⊤ : Submodule Rat TargetCounter)
    simp

/-- **R560 obstruction theorem (1/4)**: the current abstract interface
does not force `surjectivity_source <= compactDual`. -/
theorem counterexample_source_not_le_compactDual :
    ¬ LE.le
      (MatsushimaSurjectivityData.surjectivity_source
        (A := SourceCounter) (B := TargetCounter))
      (MatsushimaCompactDualData.compactDual
        (A := SourceCounter) (B := TargetCounter)) := by
  change ¬ LE.le
    (⊤ : Submodule Rat SourceCounter)
    (⊥ : Submodule Rat SourceCounter)
  intro h
  have hmem : sourceCounterNonzero ∈ (⊥ : Submodule Rat SourceCounter) :=
    h Submodule.mem_top
  have hzero : sourceCounterNonzero = 0 := by
    simpa using hmem
  exact sourceCounterNonzero_ne_zero hzero

/-- **R560 obstruction theorem (2/4)**: the current abstract interface
does not force the source-vs-compact-dual finrank equation. -/
theorem counterexample_source_finrank_ne_compactDual :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := SourceCounter) (B := TargetCounter)) ≠
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual
          (A := SourceCounter) (B := TargetCounter)) := by
  change
    Module.finrank (R := Rat) (⊤ : Submodule Rat SourceCounter) ≠
      Module.finrank (R := Rat) (⊥ : Submodule Rat SourceCounter)
  simp [SourceCounter]

/-- **R560 obstruction theorem (3/4)**: even after adding the existing
cuspidal/Eisenstein fields, the compact-dual-vs-trivial rank bridge is
not forced by the interface. -/
theorem counterexample_compactDual_finrank_ne_trivialModulePart :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual
          (A := SourceCounter) (B := TargetCounter)) ≠
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := TargetCounter)) := by
  change
    Module.finrank (R := Rat) (⊥ : Submodule Rat SourceCounter) ≠
      Module.finrank (R := Rat) (⊤ : Submodule Rat TargetCounter)
  simp [SourceCounter, TargetCounter]

/-- **R560 obstruction theorem (4/4)**: the three R559 compact-dual
targets are genuinely new EVII-specific obligations, not consequences of
the current abstract interface. -/
theorem current_interface_does_not_force_R559_targets :
    (¬ LE.le
      (MatsushimaSurjectivityData.surjectivity_source
        (A := SourceCounter) (B := TargetCounter))
      (MatsushimaCompactDualData.compactDual
        (A := SourceCounter) (B := TargetCounter))) ∧
    (Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := SourceCounter) (B := TargetCounter)) ≠
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual
          (A := SourceCounter) (B := TargetCounter))) ∧
    (Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual
          (A := SourceCounter) (B := TargetCounter)) ≠
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := TargetCounter))) := by
  exact ⟨counterexample_source_not_le_compactDual,
    counterexample_source_finrank_ne_compactDual,
    counterexample_compactDual_finrank_ne_trivialModulePart⟩

def R560_substantiveTheoremCount : Nat := 4

end FrontC19_MatsushimaSourceCompactDualObstruction
end HCGapL4
end HodgeReduction
