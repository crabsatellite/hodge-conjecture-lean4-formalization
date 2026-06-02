/-
# HC Gap L4 -- Front C196: exact source rank does not place the generator (R761).

R760 compresses the current source-H8 carrier target to the two-field package

  * `h^4 in source_invariants`;
  * `finrank source_invariants = 1`.

This file records the matching deadend for the exact-rank half.  Even with
honest `MatsushimaV56BoundaryData`, exact rank one for the source-invariant
line does not force the Kaehler generator into that line.  Future work must
therefore prove generator placement from genuine EVII source geometry; it
cannot close R760 by rank alone.
-/

import HodgeReduction.HCGapL4.FrontC195_H8ResidualSourceInvariantExactRankGenerator

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC196_H8ResidualExactSourceRankGeneratorIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC195_H8ResidualSourceInvariantExactRankGenerator

/-! ## A rank-one source-invariant line missing `h^4`. -/

/-- Two-dimensional source for the exact-rank/no-generator countermodel. -/
abbrev ExactSourceRankNoGeneratorSource := Rat × Rat

/-- Two-dimensional target for the same countermodel. -/
abbrev ExactSourceRankNoGeneratorTarget := Rat × Rat

instance : CommRing ExactSourceRankNoGeneratorSource :=
  inferInstanceAs (CommRing (Rat × Rat))
instance : Algebra Rat ExactSourceRankNoGeneratorSource :=
  inferInstanceAs (Algebra Rat (Rat × Rat))
instance : AddCommGroup ExactSourceRankNoGeneratorSource :=
  inferInstanceAs (AddCommGroup (Rat × Rat))
instance : Module Rat ExactSourceRankNoGeneratorSource :=
  inferInstanceAs (Module Rat (Rat × Rat))
instance : AddCommGroup ExactSourceRankNoGeneratorTarget :=
  inferInstanceAs (AddCommGroup (Rat × Rat))
instance : Module Rat ExactSourceRankNoGeneratorTarget :=
  inferInstanceAs (Module Rat (Rat × Rat))

/-- Identity Matsushima map for the exact-rank/no-generator model. -/
def exactSourceRankNoGeneratorIdMap :
    ExactSourceRankNoGeneratorSource →ₗ[Rat]
      ExactSourceRankNoGeneratorTarget :=
  LinearMap.id

/-- The source-invariant line is the second coordinate axis. -/
def exactSourceRankNoGeneratorLine :
    Submodule Rat ExactSourceRankNoGeneratorSource :=
  Submodule.span Rat ({((0 : Rat), (1 : Rat))} :
    Set ExactSourceRankNoGeneratorSource)

/-- The target-invariant line is the corresponding second coordinate axis. -/
def exactSourceRankNoGeneratorTargetLine :
    Submodule Rat ExactSourceRankNoGeneratorTarget :=
  Submodule.span Rat ({((0 : Rat), (1 : Rat))} :
    Set ExactSourceRankNoGeneratorTarget)

noncomputable instance instCohomologyRingExactSourceRankNoGeneratorSource :
    CohomologyRing ExactSourceRankNoGeneratorSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassExactSourceRankNoGeneratorSource :
    KaehlerClass ExactSourceRankNoGeneratorSource where
  h := ((1 : Rat), (0 : Rat))
  h_isAlgebraic := by
    change ((1 : Rat), (0 : Rat)) ∈
      (⊤ : Subalgebra Rat ExactSourceRankNoGeneratorSource)
    trivial
  h_pow_4_ne_zero := by
    change (((1 : Rat), (0 : Rat)) ^ 4) ≠
      (0 : ExactSourceRankNoGeneratorSource)
    norm_num

noncomputable instance instCompactDualDataExactSourceRankNoGeneratorSource :
    CompactDualData ExactSourceRankNoGeneratorSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : ExactSourceRankNoGeneratorSource) ^ 4)} :
        Set ExactSourceRankNoGeneratorSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoExactSourceRankNoGeneratorSource :
    CartanCompactDualIso ExactSourceRankNoGeneratorSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := ExactSourceRankNoGeneratorSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataExactSourceRankNoGenerator :
    MatsushimaData ExactSourceRankNoGeneratorSource
      ExactSourceRankNoGeneratorTarget where
  j_q := exactSourceRankNoGeneratorIdMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact hxy
  source_invariants := exactSourceRankNoGeneratorLine
  target_invariants := exactSourceRankNoGeneratorTargetLine
  j_q_maps_invariants_to_invariants := by
    intro x hx
    simpa [exactSourceRankNoGeneratorIdMap,
      exactSourceRankNoGeneratorLine,
      exactSourceRankNoGeneratorTargetLine] using hx
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataExactSourceRankNoGenerator :
    MatsushimaSurjectivityData ExactSourceRankNoGeneratorSource
      ExactSourceRankNoGeneratorTarget where
  surjectivity_source := exactSourceRankNoGeneratorLine
  surjectivity_target := exactSourceRankNoGeneratorTargetLine
  surjectivity_eq := by
    ext x
    constructor
    · intro hx
      rcases hx with ⟨y, hy, rfl⟩
      simpa [exactSourceRankNoGeneratorIdMap,
        exactSourceRankNoGeneratorLine,
        exactSourceRankNoGeneratorTargetLine] using hy
    · intro hx
      exact ⟨x, by
        simpa [exactSourceRankNoGeneratorLine,
          exactSourceRankNoGeneratorTargetLine] using hx, rfl⟩

noncomputable instance instMatsushimaCompactDualDataExactSourceRankNoGenerator :
    MatsushimaCompactDualData ExactSourceRankNoGeneratorSource
      ExactSourceRankNoGeneratorTarget where
  compactDual := exactSourceRankNoGeneratorLine
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataExactSourceRankNoGenerator :
    CuspidalCohomologyData ExactSourceRankNoGeneratorTarget where
  cuspidalSubspace := exactSourceRankNoGeneratorTargetLine
  trivialModulePart := exactSourceRankNoGeneratorTargetLine
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8ExactSourceRankNoGenerator :
    EisensteinVanishingDeg8 ExactSourceRankNoGeneratorSource
      ExactSourceRankNoGeneratorTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8ExactSourceRankNoGenerator :
    CuspidalGInvariantTrivialModuleDeg8 ExactSourceRankNoGeneratorSource
      ExactSourceRankNoGeneratorTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    change
      exactSourceRankNoGeneratorTargetLine ⊓
          exactSourceRankNoGeneratorTargetLine =
        exactSourceRankNoGeneratorTargetLine
    rw [inf_eq_left.mpr le_rfl]

/-- **R761 obstruction theorem (1/5)**: the countermodel has honest boundary
data. -/
def counterexample_boundaryData_exactSourceRank :
    MatsushimaV56BoundaryData
      ExactSourceRankNoGeneratorSource
      ExactSourceRankNoGeneratorTarget where
  source_eq_compactDual := rfl
  target_eq_invariants := rfl

/-- **R761 obstruction theorem (2/5)**: the source-invariant line has exact
rank one. -/
theorem counterexample_source_invariants_finrank_eq_one :
    Module.finrank (R := Rat)
      (MatsushimaData.source_invariants
        (A := ExactSourceRankNoGeneratorSource)
        (B := ExactSourceRankNoGeneratorTarget)) = 1 := by
  change Module.finrank (R := Rat) exactSourceRankNoGeneratorLine = 1
  simpa [exactSourceRankNoGeneratorLine] using
    (finrank_span_singleton
      (K := Rat)
      (V := ExactSourceRankNoGeneratorSource)
      (v := ((0 : Rat), (1 : Rat)))
      (by norm_num))

/-- **R761 obstruction theorem (3/5)**: the Kaehler generator is not in the
rank-one source-invariant line. -/
theorem counterexample_not_h_pow_four_mem_source_invariants :
    Not
      ((MatsushimaData.source_invariants
          (A := ExactSourceRankNoGeneratorSource)
          (B := ExactSourceRankNoGeneratorTarget)).carrier
        ((KaehlerClass.h : ExactSourceRankNoGeneratorSource) ^ 4)) := by
  intro hmem
  change ((1 : Rat), (0 : Rat)) ∈
      Submodule.span Rat
        ({((0 : Rat), (1 : Rat))} : Set ExactSourceRankNoGeneratorSource) at hmem
  rw [Submodule.mem_span_singleton] at hmem
  obtain ⟨r, hr⟩ := hmem
  have hfirst := congrArg Prod.fst hr
  change r * (0 : Rat) = 1 at hfirst
  norm_num at hfirst

/-- **R761 obstruction theorem (4/5)**: boundary data plus exact source rank
one still does not force source generator membership. -/
theorem boundaryData_and_exactSourceRank_does_not_force_h_pow_four_mem_source_invariants :
    MatsushimaV56BoundaryData
        ExactSourceRankNoGeneratorSource
        ExactSourceRankNoGeneratorTarget /\
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants
          (A := ExactSourceRankNoGeneratorSource)
          (B := ExactSourceRankNoGeneratorTarget)) = 1 /\
      Not
        ((MatsushimaData.source_invariants
            (A := ExactSourceRankNoGeneratorSource)
            (B := ExactSourceRankNoGeneratorTarget)).carrier
          ((KaehlerClass.h : ExactSourceRankNoGeneratorSource) ^ 4)) :=
  ⟨counterexample_boundaryData_exactSourceRank,
    counterexample_source_invariants_finrank_eq_one,
    counterexample_not_h_pow_four_mem_source_invariants⟩

/-- **R761 obstruction theorem (5/5)**: boundary data plus exact source rank
one also does not force the R760 source-H8 equality. -/
theorem boundaryData_and_exactSourceRank_does_not_force_source_invariants_eq_H8 :
    MatsushimaV56BoundaryData
        ExactSourceRankNoGeneratorSource
        ExactSourceRankNoGeneratorTarget /\
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants
          (A := ExactSourceRankNoGeneratorSource)
          (B := ExactSourceRankNoGeneratorTarget)) = 1 /\
      Not
        (MatsushimaData.source_invariants
            (A := ExactSourceRankNoGeneratorSource)
            (B := ExactSourceRankNoGeneratorTarget) =
          CompactDualData.H8 (A := ExactSourceRankNoGeneratorSource)) := by
  refine ⟨counterexample_boundaryData_exactSourceRank,
    counterexample_source_invariants_finrank_eq_one, ?_⟩
  intro hsource
  exact counterexample_not_h_pow_four_mem_source_invariants
    (h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
      (A := ExactSourceRankNoGeneratorSource)
      (B := ExactSourceRankNoGeneratorTarget)
      hsource)

/-- R761 target names for route summaries. -/
def currentR761ExactSourceRankGeneratorIndependenceTargetNames : List String := [
  "prove h^4 in source_invariants",
  "exact source rank one cannot replace generator membership"
]

/-- Machine-readable status for the R761 exact-rank/generator independence
deadend. -/
structure R761ExactSourceRankGeneratorIndependenceSnapshot where
  boundaryDataAvailableInCountermodel : Bool
  exactSourceRankAvailableInCountermodel : Bool
  generatorMembershipForcedByBoundaryAndExactRank : Bool
  sourceH8ForcedByBoundaryAndExactRank : Bool
  exactRankAloneIsClosureRoute : Bool
  provesSourceGeneratorMembership : Bool
  provesSourceInvariantExactRank : Bool
  provesSourceH8 : Bool
  provesBoundaryDataForEVII : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R761 status: exact source rank is useful only after generator
placement has been proved separately. -/
def currentR761ExactSourceRankGeneratorIndependenceSnapshot :
    R761ExactSourceRankGeneratorIndependenceSnapshot where
  boundaryDataAvailableInCountermodel := true
  exactSourceRankAvailableInCountermodel := true
  generatorMembershipForcedByBoundaryAndExactRank := false
  sourceH8ForcedByBoundaryAndExactRank := false
  exactRankAloneIsClosureRoute := false
  provesSourceGeneratorMembership := false
  provesSourceInvariantExactRank := false
  provesSourceH8 := false
  provesBoundaryDataForEVII := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R761 exact source-rank deadend. -/
theorem currentR761ExactSourceRankGeneratorIndependenceSnapshot_eq_texStatus :
    currentR761ExactSourceRankGeneratorIndependenceSnapshot =
      ({ boundaryDataAvailableInCountermodel := true
         exactSourceRankAvailableInCountermodel := true
         generatorMembershipForcedByBoundaryAndExactRank := false
         sourceH8ForcedByBoundaryAndExactRank := false
         exactRankAloneIsClosureRoute := false
         provesSourceGeneratorMembership := false
         provesSourceInvariantExactRank := false
         provesSourceH8 := false
         provesBoundaryDataForEVII := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R761ExactSourceRankGeneratorIndependenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R761 guardrail. -/
theorem currentR761ExactSourceRankGeneratorIndependenceTargetNames_eq_texStatus :
    currentR761ExactSourceRankGeneratorIndependenceTargetNames = [
      "prove h^4 in source_invariants",
      "exact source rank one cannot replace generator membership"
    ] := by
  rfl

def R761_substantiveTheoremCount : Nat := 5

end FrontC196_H8ResidualExactSourceRankGeneratorIndependence
end HCGapL4
end HodgeReduction
