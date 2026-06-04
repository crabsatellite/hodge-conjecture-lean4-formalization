/-
# HC Gap L4 -- Front C198: one-sided source containments are independent (R763).

R762 rewrites the current source-H8 carrier target as the two source-native
containments

  * `H8 <= source_invariants`;
  * `source_invariants <= H8`.

This file records the direct current-surface guardrail.  Even with honest
`MatsushimaV56BoundaryData`, either one-sided containment can hold without the
other.  Therefore the next EVII geometry step must prove both source
containments, not infer one from boundary data plus the other.
-/

import HodgeReduction.HCGapL4.FrontC197_H8ResidualSourceRankNoExtraEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC198_H8ResidualSourceContainmentIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC148_H8ResidualSourceGeneratorContainmentRoute

/-! ## A boundary model with generator containment but no no-extra containment. -/

abbrev SourceGeneratorNoNoExtraSource := Fin 2 → Rat
abbrev SourceGeneratorNoNoExtraTarget := Fin 2 → Rat

instance : CommRing SourceGeneratorNoNoExtraSource :=
  inferInstanceAs (CommRing (Fin 2 → Rat))
instance : Algebra Rat SourceGeneratorNoNoExtraSource :=
  inferInstanceAs (Algebra Rat (Fin 2 → Rat))
instance : AddCommGroup SourceGeneratorNoNoExtraSource :=
  inferInstanceAs (AddCommGroup (Fin 2 → Rat))
instance : Module Rat SourceGeneratorNoNoExtraSource :=
  inferInstanceAs (Module Rat (Fin 2 → Rat))
instance : AddCommGroup SourceGeneratorNoNoExtraTarget :=
  inferInstanceAs (AddCommGroup (Fin 2 → Rat))
instance : Module Rat SourceGeneratorNoNoExtraTarget :=
  inferInstanceAs (Module Rat (Fin 2 → Rat))

def sourceGeneratorNoNoExtraE0 : SourceGeneratorNoNoExtraSource :=
  Pi.single (0 : Fin 2) (1 : Rat)

def sourceGeneratorNoNoExtraE1 : SourceGeneratorNoNoExtraSource :=
  Pi.single (1 : Fin 2) (1 : Rat)

def sourceGeneratorNoNoExtraIdMap :
    SourceGeneratorNoNoExtraSource →ₗ[Rat] SourceGeneratorNoNoExtraTarget :=
  LinearMap.id

noncomputable instance instCohomologyRingSourceGeneratorNoNoExtra :
    CohomologyRing SourceGeneratorNoNoExtraSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassSourceGeneratorNoNoExtra :
    KaehlerClass SourceGeneratorNoNoExtraSource where
  h := sourceGeneratorNoNoExtraE0
  h_isAlgebraic := by
    change sourceGeneratorNoNoExtraE0 ∈
      (⊤ : Subalgebra Rat SourceGeneratorNoNoExtraSource)
    trivial
  h_pow_4_ne_zero := by
    intro hzero
    have hcoord := congrFun hzero (0 : Fin 2)
    norm_num [sourceGeneratorNoNoExtraE0] at hcoord

noncomputable instance instCompactDualDataSourceGeneratorNoNoExtra :
    CompactDualData SourceGeneratorNoNoExtraSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : SourceGeneratorNoNoExtraSource) ^ 4)} :
        Set SourceGeneratorNoNoExtraSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoSourceGeneratorNoNoExtra :
    CartanCompactDualIso SourceGeneratorNoNoExtraSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataSourceGeneratorNoNoExtra :
    MatsushimaData SourceGeneratorNoNoExtraSource
      SourceGeneratorNoNoExtraTarget where
  j_q := sourceGeneratorNoNoExtraIdMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact hxy
  source_invariants := ⊤
  target_invariants := ⊤
  j_q_maps_invariants_to_invariants := by
    intro _ _
    trivial
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataSourceGeneratorNoNoExtra :
    MatsushimaSurjectivityData SourceGeneratorNoNoExtraSource
      SourceGeneratorNoNoExtraTarget where
  surjectivity_source := ⊤
  surjectivity_target := ⊤
  surjectivity_eq := by
    change
      Submodule.map sourceGeneratorNoNoExtraIdMap
          (⊤ : Submodule Rat SourceGeneratorNoNoExtraSource) =
        (⊤ : Submodule Rat SourceGeneratorNoNoExtraTarget)
    ext x
    constructor
    · intro _
      trivial
    · intro _
      exact ⟨x, trivial, rfl⟩

noncomputable instance instMatsushimaCompactDualDataSourceGeneratorNoNoExtra :
    MatsushimaCompactDualData SourceGeneratorNoNoExtraSource
      SourceGeneratorNoNoExtraTarget where
  compactDual := ⊤
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataSourceGeneratorNoNoExtra :
    CuspidalCohomologyData SourceGeneratorNoNoExtraTarget where
  cuspidalSubspace := ⊤
  trivialModulePart := ⊤
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8SourceGeneratorNoNoExtra :
    EisensteinVanishingDeg8 SourceGeneratorNoNoExtraSource
      SourceGeneratorNoNoExtraTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8SourceGeneratorNoNoExtra :
    CuspidalGInvariantTrivialModuleDeg8 SourceGeneratorNoNoExtraSource
      SourceGeneratorNoNoExtraTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    change
      (⊤ : Submodule Rat SourceGeneratorNoNoExtraTarget) ⊓
          (⊤ : Submodule Rat SourceGeneratorNoNoExtraTarget) =
        (⊤ : Submodule Rat SourceGeneratorNoNoExtraTarget)
    rw [inf_eq_left.mpr le_rfl]

def counterexample_boundaryData_sourceGeneratorNoNoExtra :
    MatsushimaV56BoundaryData
      SourceGeneratorNoNoExtraSource
      SourceGeneratorNoNoExtraTarget where
  source_eq_compactDual := rfl
  target_eq_invariants := rfl

theorem counterexample_H8_le_source_invariants_generatorNoNoExtra :
    LE.le (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))
      (MatsushimaData.source_invariants
        (A := SourceGeneratorNoNoExtraSource)
        (B := SourceGeneratorNoNoExtraTarget)) := by
  change LE.le (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))
    (⊤ : Submodule Rat SourceGeneratorNoNoExtraSource)
  exact le_top

theorem counterexample_not_source_invariants_le_H8_generatorNoNoExtra :
    Not
      (LE.le (MatsushimaData.source_invariants
          (A := SourceGeneratorNoNoExtraSource)
          (B := SourceGeneratorNoNoExtraTarget))
        (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))) := by
  intro hsource_le_H8
  have hmem_h8 :
      sourceGeneratorNoNoExtraE1 ∈
        CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource) := by
    apply hsource_le_H8
    change sourceGeneratorNoNoExtraE1 ∈
      (⊤ : Submodule Rat SourceGeneratorNoNoExtraSource)
    trivial
  change sourceGeneratorNoNoExtraE1 ∈
    Submodule.span Rat
      ({(sourceGeneratorNoNoExtraE0 ^ 4)} :
        Set SourceGeneratorNoNoExtraSource) at hmem_h8
  rw [Submodule.mem_span_singleton] at hmem_h8
  obtain ⟨r, hr⟩ := hmem_h8
  have hcoord := congrFun hr (1 : Fin 2)
  norm_num [sourceGeneratorNoNoExtraE0, sourceGeneratorNoNoExtraE1] at hcoord

/-! ## A boundary model with no-extra containment but no generator containment. -/

abbrev SourceNoExtraNoGeneratorSource := Unit → Rat
abbrev SourceNoExtraNoGeneratorTarget := Unit → Rat

instance : CommRing SourceNoExtraNoGeneratorSource :=
  inferInstanceAs (CommRing (Unit → Rat))
instance : Algebra Rat SourceNoExtraNoGeneratorSource :=
  inferInstanceAs (Algebra Rat (Unit → Rat))
instance : AddCommGroup SourceNoExtraNoGeneratorSource :=
  inferInstanceAs (AddCommGroup (Unit → Rat))
instance : Module Rat SourceNoExtraNoGeneratorSource :=
  inferInstanceAs (Module Rat (Unit → Rat))
instance : AddCommGroup SourceNoExtraNoGeneratorTarget :=
  inferInstanceAs (AddCommGroup (Unit → Rat))
instance : Module Rat SourceNoExtraNoGeneratorTarget :=
  inferInstanceAs (Module Rat (Unit → Rat))

def sourceNoExtraNoGeneratorH : SourceNoExtraNoGeneratorSource :=
  fun _ => (1 : Rat)

def sourceNoExtraNoGeneratorIdMap :
    SourceNoExtraNoGeneratorSource →ₗ[Rat] SourceNoExtraNoGeneratorTarget :=
  LinearMap.id

noncomputable instance instCohomologyRingSourceNoExtraNoGenerator :
    CohomologyRing SourceNoExtraNoGeneratorSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassSourceNoExtraNoGenerator :
    KaehlerClass SourceNoExtraNoGeneratorSource where
  h := sourceNoExtraNoGeneratorH
  h_isAlgebraic := by
    change sourceNoExtraNoGeneratorH ∈
      (⊤ : Subalgebra Rat SourceNoExtraNoGeneratorSource)
    trivial
  h_pow_4_ne_zero := by
    intro hzero
    have hcoord := congrFun hzero ()
    norm_num [sourceNoExtraNoGeneratorH] at hcoord

noncomputable instance instCompactDualDataSourceNoExtraNoGenerator :
    CompactDualData SourceNoExtraNoGeneratorSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : SourceNoExtraNoGeneratorSource) ^ 4)} :
        Set SourceNoExtraNoGeneratorSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoSourceNoExtraNoGenerator :
    CartanCompactDualIso SourceNoExtraNoGeneratorSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataSourceNoExtraNoGenerator :
    MatsushimaData SourceNoExtraNoGeneratorSource
      SourceNoExtraNoGeneratorTarget where
  j_q := sourceNoExtraNoGeneratorIdMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact hxy
  source_invariants := ⊥
  target_invariants := ⊥
  j_q_maps_invariants_to_invariants := by
    intro alpha h
    have hzero : alpha = 0 := by
      simpa using h
    rw [hzero]
    exact Submodule.zero_mem _
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataSourceNoExtraNoGenerator :
    MatsushimaSurjectivityData SourceNoExtraNoGeneratorSource
      SourceNoExtraNoGeneratorTarget where
  surjectivity_source := ⊥
  surjectivity_target := ⊥
  surjectivity_eq := by
    change
      Submodule.map sourceNoExtraNoGeneratorIdMap
          (⊥ : Submodule Rat SourceNoExtraNoGeneratorSource) =
        (⊥ : Submodule Rat SourceNoExtraNoGeneratorTarget)
    ext x
    simp [sourceNoExtraNoGeneratorIdMap]

noncomputable instance instMatsushimaCompactDualDataSourceNoExtraNoGenerator :
    MatsushimaCompactDualData SourceNoExtraNoGeneratorSource
      SourceNoExtraNoGeneratorTarget where
  compactDual := ⊥
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataSourceNoExtraNoGenerator :
    CuspidalCohomologyData SourceNoExtraNoGeneratorTarget where
  cuspidalSubspace := ⊥
  trivialModulePart := ⊥
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8SourceNoExtraNoGenerator :
    EisensteinVanishingDeg8 SourceNoExtraNoGeneratorSource
      SourceNoExtraNoGeneratorTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8SourceNoExtraNoGenerator :
    CuspidalGInvariantTrivialModuleDeg8 SourceNoExtraNoGeneratorSource
      SourceNoExtraNoGeneratorTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    change
      (⊥ : Submodule Rat SourceNoExtraNoGeneratorTarget) ⊓
          (⊥ : Submodule Rat SourceNoExtraNoGeneratorTarget) =
        (⊥ : Submodule Rat SourceNoExtraNoGeneratorTarget)
    rw [inf_eq_left.mpr le_rfl]

def counterexample_boundaryData_sourceNoExtraNoGenerator :
    MatsushimaV56BoundaryData
      SourceNoExtraNoGeneratorSource
      SourceNoExtraNoGeneratorTarget where
  source_eq_compactDual := rfl
  target_eq_invariants := rfl

theorem counterexample_source_invariants_le_H8_noExtraNoGenerator :
    LE.le (MatsushimaData.source_invariants
        (A := SourceNoExtraNoGeneratorSource)
        (B := SourceNoExtraNoGeneratorTarget))
      (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource)) := by
  change LE.le (⊥ : Submodule Rat SourceNoExtraNoGeneratorSource)
    (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource))
  exact bot_le

theorem counterexample_not_H8_le_source_invariants_noExtraNoGenerator :
    Not
      (LE.le (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource))
        (MatsushimaData.source_invariants
          (A := SourceNoExtraNoGeneratorSource)
          (B := SourceNoExtraNoGeneratorTarget))) := by
  intro hH8_le_source
  have hmem_source :
      ((KaehlerClass.h : SourceNoExtraNoGeneratorSource) ^ 4) ∈
        MatsushimaData.source_invariants
          (A := SourceNoExtraNoGeneratorSource)
          (B := SourceNoExtraNoGeneratorTarget) := by
    apply hH8_le_source
    rw [CompactDualData.H8_eq_span_h_pow_4]
    exact Submodule.subset_span (by simp)
  change ((KaehlerClass.h : SourceNoExtraNoGeneratorSource) ^ 4) ∈
    (⊥ : Submodule Rat SourceNoExtraNoGeneratorSource) at hmem_source
  rw [Submodule.mem_bot] at hmem_source
  exact KaehlerClass.h_pow_4_ne_zero hmem_source

/-- **R763 obstruction theorem (1/5)**: boundary data plus the generator/H8
source containment does not force the no-extra source containment. -/
theorem boundaryData_and_H8_le_source_invariants_does_not_force_source_invariants_le_H8 :
    MatsushimaV56BoundaryData
        SourceGeneratorNoNoExtraSource
        SourceGeneratorNoNoExtraTarget /\
      LE.le (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))
        (MatsushimaData.source_invariants
          (A := SourceGeneratorNoNoExtraSource)
          (B := SourceGeneratorNoNoExtraTarget)) /\
      Not
        (LE.le (MatsushimaData.source_invariants
            (A := SourceGeneratorNoNoExtraSource)
            (B := SourceGeneratorNoNoExtraTarget))
          (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))) :=
  ⟨counterexample_boundaryData_sourceGeneratorNoNoExtra,
    counterexample_H8_le_source_invariants_generatorNoNoExtra,
    counterexample_not_source_invariants_le_H8_generatorNoNoExtra⟩

/-- **R763 obstruction theorem (2/5)**: boundary data plus the no-extra
source containment does not force the generator/H8 source containment. -/
theorem boundaryData_and_source_invariants_le_H8_does_not_force_H8_le_source_invariants :
    MatsushimaV56BoundaryData
        SourceNoExtraNoGeneratorSource
        SourceNoExtraNoGeneratorTarget /\
      LE.le (MatsushimaData.source_invariants
          (A := SourceNoExtraNoGeneratorSource)
          (B := SourceNoExtraNoGeneratorTarget))
        (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource)) /\
      Not
        (LE.le (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource))
          (MatsushimaData.source_invariants
            (A := SourceNoExtraNoGeneratorSource)
            (B := SourceNoExtraNoGeneratorTarget))) :=
  ⟨counterexample_boundaryData_sourceNoExtraNoGenerator,
    counterexample_source_invariants_le_H8_noExtraNoGenerator,
    counterexample_not_H8_le_source_invariants_noExtraNoGenerator⟩

/-- **R763 obstruction theorem (3/5)**: the generator/H8 containment side
alone does not force the two-containment source-H8 package. -/
theorem boundaryData_and_H8_le_source_invariants_does_not_force_two_source_containments :
    MatsushimaV56BoundaryData
        SourceGeneratorNoNoExtraSource
        SourceGeneratorNoNoExtraTarget /\
      LE.le (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))
        (MatsushimaData.source_invariants
          (A := SourceGeneratorNoNoExtraSource)
          (B := SourceGeneratorNoNoExtraTarget)) /\
      Not
        (LE.le (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))
            (MatsushimaData.source_invariants
              (A := SourceGeneratorNoNoExtraSource)
              (B := SourceGeneratorNoNoExtraTarget)) /\
          LE.le (MatsushimaData.source_invariants
              (A := SourceGeneratorNoNoExtraSource)
              (B := SourceGeneratorNoNoExtraTarget))
            (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))) := by
  exact
    ⟨counterexample_boundaryData_sourceGeneratorNoNoExtra,
      counterexample_H8_le_source_invariants_generatorNoNoExtra,
      fun htwo =>
        counterexample_not_source_invariants_le_H8_generatorNoNoExtra htwo.2⟩

/-- **R763 obstruction theorem (4/5)**: the no-extra containment side alone
does not force the two-containment source-H8 package. -/
theorem boundaryData_and_source_invariants_le_H8_does_not_force_two_source_containments :
    MatsushimaV56BoundaryData
        SourceNoExtraNoGeneratorSource
        SourceNoExtraNoGeneratorTarget /\
      LE.le (MatsushimaData.source_invariants
          (A := SourceNoExtraNoGeneratorSource)
          (B := SourceNoExtraNoGeneratorTarget))
        (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource)) /\
      Not
        (LE.le (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource))
            (MatsushimaData.source_invariants
              (A := SourceNoExtraNoGeneratorSource)
              (B := SourceNoExtraNoGeneratorTarget)) /\
          LE.le (MatsushimaData.source_invariants
              (A := SourceNoExtraNoGeneratorSource)
              (B := SourceNoExtraNoGeneratorTarget))
            (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource))) := by
  exact
    ⟨counterexample_boundaryData_sourceNoExtraNoGenerator,
      counterexample_source_invariants_le_H8_noExtraNoGenerator,
      fun htwo =>
        counterexample_not_H8_le_source_invariants_noExtraNoGenerator htwo.1⟩

/-- **R763 obstruction theorem (5/5)**: both one-sided source containments are
genuine independent targets in the current boundary-data interface. -/
theorem one_sided_source_containments_are_independent_under_boundaryData :
    (MatsushimaV56BoundaryData
        SourceGeneratorNoNoExtraSource
        SourceGeneratorNoNoExtraTarget /\
      LE.le (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource))
        (MatsushimaData.source_invariants
          (A := SourceGeneratorNoNoExtraSource)
          (B := SourceGeneratorNoNoExtraTarget)) /\
      Not
        (LE.le (MatsushimaData.source_invariants
            (A := SourceGeneratorNoNoExtraSource)
            (B := SourceGeneratorNoNoExtraTarget))
          (CompactDualData.H8 (A := SourceGeneratorNoNoExtraSource)))) /\
    (MatsushimaV56BoundaryData
        SourceNoExtraNoGeneratorSource
        SourceNoExtraNoGeneratorTarget /\
      LE.le (MatsushimaData.source_invariants
          (A := SourceNoExtraNoGeneratorSource)
          (B := SourceNoExtraNoGeneratorTarget))
        (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource)) /\
      Not
        (LE.le (CompactDualData.H8 (A := SourceNoExtraNoGeneratorSource))
          (MatsushimaData.source_invariants
            (A := SourceNoExtraNoGeneratorSource)
            (B := SourceNoExtraNoGeneratorTarget)))) :=
  ⟨boundaryData_and_H8_le_source_invariants_does_not_force_source_invariants_le_H8,
    boundaryData_and_source_invariants_le_H8_does_not_force_H8_le_source_invariants⟩

/-- R763 target names for route summaries. -/
def currentR763SourceContainmentIndependenceTargetNames : List String := [
  "prove H8 <= source_invariants",
  "prove source_invariants <= H8"
]

/-- Machine-readable status for the R763 one-sided source-containment
independence result. -/
structure R763SourceContainmentIndependenceSnapshot where
  boundaryDataPlusGeneratorContainmentForcesNoExtraContainment : Bool
  boundaryDataPlusNoExtraContainmentForcesGeneratorContainment : Bool
  generatorContainmentIndependentUnderBoundaryData : Bool
  noExtraContainmentIndependentUnderBoundaryData : Bool
  sourceH8RequiresBothContainments : Bool
  provesH8LeSourceInvariants : Bool
  provesSourceInvariantsLeH8 : Bool
  provesBoundaryDataForEVII : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R763 status: the two source containment targets remain separate
EVII geometry obligations. -/
def currentR763SourceContainmentIndependenceSnapshot :
    R763SourceContainmentIndependenceSnapshot where
  boundaryDataPlusGeneratorContainmentForcesNoExtraContainment := false
  boundaryDataPlusNoExtraContainmentForcesGeneratorContainment := false
  generatorContainmentIndependentUnderBoundaryData := true
  noExtraContainmentIndependentUnderBoundaryData := true
  sourceH8RequiresBothContainments := true
  provesH8LeSourceInvariants := false
  provesSourceInvariantsLeH8 := false
  provesBoundaryDataForEVII := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R763 source-containment independence
guardrail. -/
theorem currentR763SourceContainmentIndependenceSnapshot_eq_texStatus :
    currentR763SourceContainmentIndependenceSnapshot =
      ({ boundaryDataPlusGeneratorContainmentForcesNoExtraContainment := false
         boundaryDataPlusNoExtraContainmentForcesGeneratorContainment := false
         generatorContainmentIndependentUnderBoundaryData := true
         noExtraContainmentIndependentUnderBoundaryData := true
         sourceH8RequiresBothContainments := true
         provesH8LeSourceInvariants := false
         provesSourceInvariantsLeH8 := false
         provesBoundaryDataForEVII := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R763SourceContainmentIndependenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R763 route. -/
theorem currentR763SourceContainmentIndependenceTargetNames_eq_texStatus :
    currentR763SourceContainmentIndependenceTargetNames = [
      "prove H8 <= source_invariants",
      "prove source_invariants <= H8"
    ] := by
  rfl

def R763_substantiveTheoremCount : Nat := 5

end FrontC198_H8ResidualSourceContainmentIndependence
end HCGapL4
end HodgeReduction
