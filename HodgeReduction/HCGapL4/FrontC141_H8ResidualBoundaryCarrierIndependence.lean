/-
# HC Gap L4 -- Front C141: boundary data does not force the R705 carrier facts (R706).

R705 exposed the preferred compact-dual target as two carrier facts:

* `compactDual <= H8`;
* `h^4 in compactDual`.

This file records the next concrete deadend.  Honest
`MatsushimaV56BoundaryData` by itself does not force either carrier fact in
the current abstract interface.  Therefore the follow-up proof must add real
EVII compact-dual/source-invariant geometry; it cannot close R705 by
reusing the boundary equalities alone.
-/

import HodgeReduction.HCGapL4.FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
import HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC141_H8ResidualBoundaryCarrierIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC97_H8ResidualCartanToCompactDualLine
open FrontC100_H8ResidualCartanContainmentIndependence

/-! ## Boundary data does not force compactDual <= H8. -/

/-- Two-dimensional source used to show boundary data need not force
`compactDual <= H8`. -/
abbrev BoundaryNoExtraObstructionSource := Rat × Rat

/-- Two-dimensional target for the same no-extra countermodel. -/
abbrev BoundaryNoExtraObstructionTarget := Rat × Rat

instance : CommRing BoundaryNoExtraObstructionSource :=
  inferInstanceAs (CommRing (Rat × Rat))
instance : Algebra Rat BoundaryNoExtraObstructionSource :=
  inferInstanceAs (Algebra Rat (Rat × Rat))
instance : AddCommGroup BoundaryNoExtraObstructionSource :=
  inferInstanceAs (AddCommGroup (Rat × Rat))
instance : Module Rat BoundaryNoExtraObstructionSource :=
  inferInstanceAs (Module Rat (Rat × Rat))
instance : AddCommGroup BoundaryNoExtraObstructionTarget :=
  inferInstanceAs (AddCommGroup (Rat × Rat))
instance : Module Rat BoundaryNoExtraObstructionTarget :=
  inferInstanceAs (Module Rat (Rat × Rat))

/-- Identity Matsushima map for the no-extra countermodel. -/
def boundaryNoExtraObstructionIdMap :
    BoundaryNoExtraObstructionSource →ₗ[Rat]
      BoundaryNoExtraObstructionTarget :=
  LinearMap.id

noncomputable instance instCohomologyRingBoundaryNoExtraObstructionSource :
    CohomologyRing BoundaryNoExtraObstructionSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassBoundaryNoExtraObstructionSource :
    KaehlerClass BoundaryNoExtraObstructionSource where
  h := ((1 : Rat), (0 : Rat))
  h_isAlgebraic := by
    change ((1 : Rat), (0 : Rat)) ∈
      (⊤ : Subalgebra Rat BoundaryNoExtraObstructionSource)
    trivial
  h_pow_4_ne_zero := by
    change (((1 : Rat), (0 : Rat)) ^ 4) ≠
      (0 : BoundaryNoExtraObstructionSource)
    norm_num

noncomputable instance instCompactDualDataBoundaryNoExtraObstructionSource :
    CompactDualData BoundaryNoExtraObstructionSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4)} :
        Set BoundaryNoExtraObstructionSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoBoundaryNoExtraObstructionSource :
    CartanCompactDualIso BoundaryNoExtraObstructionSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataBoundaryNoExtraObstruction :
    MatsushimaData BoundaryNoExtraObstructionSource
      BoundaryNoExtraObstructionTarget where
  j_q := boundaryNoExtraObstructionIdMap
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

noncomputable instance instMatsushimaSurjectivityDataBoundaryNoExtraObstruction :
    MatsushimaSurjectivityData BoundaryNoExtraObstructionSource
      BoundaryNoExtraObstructionTarget where
  surjectivity_source := ⊤
  surjectivity_target := ⊤
  surjectivity_eq := by
    change
      Submodule.map boundaryNoExtraObstructionIdMap
          (⊤ : Submodule Rat BoundaryNoExtraObstructionSource) =
        (⊤ : Submodule Rat BoundaryNoExtraObstructionTarget)
    ext x
    constructor
    · intro _
      trivial
    · intro _
      exact ⟨x, trivial, rfl⟩

noncomputable instance instMatsushimaCompactDualDataBoundaryNoExtraObstruction :
    MatsushimaCompactDualData BoundaryNoExtraObstructionSource
      BoundaryNoExtraObstructionTarget where
  compactDual := ⊤
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataBoundaryNoExtraObstruction :
    CuspidalCohomologyData BoundaryNoExtraObstructionTarget where
  cuspidalSubspace := ⊤
  trivialModulePart := ⊤
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8BoundaryNoExtraObstruction :
    EisensteinVanishingDeg8 BoundaryNoExtraObstructionSource
      BoundaryNoExtraObstructionTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8BoundaryNoExtraObstruction :
    CuspidalGInvariantTrivialModuleDeg8 BoundaryNoExtraObstructionSource
      BoundaryNoExtraObstructionTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    change
      (⊤ : Submodule Rat BoundaryNoExtraObstructionTarget) ⊓
          (⊤ : Submodule Rat BoundaryNoExtraObstructionTarget) =
        (⊤ : Submodule Rat BoundaryNoExtraObstructionTarget)
    ext x
    constructor
    · intro _
      trivial
    · intro _
      exact ⟨trivial, trivial⟩

/-- **R706 obstruction theorem (1/5)**: the no-extra countermodel has honest
boundary data. -/
def counterexample_boundaryData_noExtra :
    MatsushimaV56BoundaryData
      BoundaryNoExtraObstructionSource
      BoundaryNoExtraObstructionTarget where
  source_eq_compactDual := rfl
  target_eq_invariants := rfl

/-- **R706 obstruction theorem (2/5)**: in the same boundary-data model,
`compactDual <= H8` fails. -/
theorem counterexample_not_compactDual_le_H8 :
    Not
      (LE.le (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget))
        (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))) := by
  intro hle
  have hmem_top :
      ((0 : Rat), (1 : Rat)) ∈
        MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget) := by
    trivial
  have hmem_h8 := hle hmem_top
  change ((0 : Rat), (1 : Rat)) ∈
      Submodule.span Rat
        ({((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4)} :
          Set BoundaryNoExtraObstructionSource) at hmem_h8
  rw [Submodule.mem_span_singleton] at hmem_h8
  obtain ⟨r, hr⟩ := hmem_h8
  have hsecond := congrArg Prod.snd hr
  change r * (0 : Rat) ^ 4 = 1 at hsecond
  norm_num at hsecond

/-- **R706 obstruction theorem (3/5)**: boundary data alone does not force
the no-extra compact-dual carrier direction. -/
theorem boundaryData_alone_does_not_force_compactDual_le_H8 :
    MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      Not
        (LE.le (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget))
          (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))) :=
  ⟨counterexample_boundaryData_noExtra, counterexample_not_compactDual_le_H8⟩

/-! ## Boundary data does not force h^4 in compactDual. -/

/-- **R706 obstruction theorem (4/5)**: the R664 model also has honest
boundary data, but `h^4` is not in compactDual. -/
theorem boundaryData_alone_does_not_force_h_pow_four_mem_compactDual :
    MatsushimaV56BoundaryData
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget /\
      Not
        ((MatsushimaCompactDualData.compactDual
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget)).carrier
          ((KaehlerClass.h : CartanContainmentObstructionSource) ^ 4)) := by
  refine ⟨?boundary, ?notMem⟩
  · exact
      { source_eq_compactDual := rfl
        target_eq_invariants := rfl }
  · intro hmem
    exact counterexample_not_cartanH8_le_compactDual
      ((cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
        (A := CartanContainmentObstructionSource)
        (B := CartanContainmentObstructionTarget)).2 hmem)

/-- Machine-readable status for the R706 boundary/carrier independence
deadend. -/
structure R706BoundaryCarrierIndependenceSnapshot where
  boundaryDataAvailableInNoExtraCountermodel : Bool
  boundaryDataForcesCompactDualNoExtra : Bool
  boundaryDataAvailableInGeneratorCountermodel : Bool
  boundaryDataForcesCompactDualGeneratorMembership : Bool
  r705CarrierFactsRemainIndependentOfBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R706 status: boundary data alone cannot close either R705
carrier fact. -/
def currentR706BoundaryCarrierIndependenceSnapshot :
    R706BoundaryCarrierIndependenceSnapshot where
  boundaryDataAvailableInNoExtraCountermodel := true
  boundaryDataForcesCompactDualNoExtra := false
  boundaryDataAvailableInGeneratorCountermodel := true
  boundaryDataForcesCompactDualGeneratorMembership := false
  r705CarrierFactsRemainIndependentOfBoundaryData := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R706 obstruction theorem (5/5)**: kernel-checked status for the
boundary/carrier independence deadend. -/
theorem currentR706BoundaryCarrierIndependenceSnapshot_eq_texStatus :
    currentR706BoundaryCarrierIndependenceSnapshot =
      ({ boundaryDataAvailableInNoExtraCountermodel := true
         boundaryDataForcesCompactDualNoExtra := false
         boundaryDataAvailableInGeneratorCountermodel := true
         boundaryDataForcesCompactDualGeneratorMembership := false
         r705CarrierFactsRemainIndependentOfBoundaryData := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R706BoundaryCarrierIndependenceSnapshot) := by
  decide

def R706_substantiveTheoremCount : Nat := 5

end FrontC141_H8ResidualBoundaryCarrierIndependence
end HCGapL4
end HodgeReduction
