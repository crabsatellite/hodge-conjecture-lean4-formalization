/-
# HC Gap L4 -- Front C100: Cartan containment is independent of the other live targets (R664).

R662 and R663 showed that exact image and the target generator-line theorem
are not forced by the other two R661 live targets.  This file records the
remaining independence edge: exact image plus the target line still do not
force the source-side carrier containment

  `CartanH8 <= compactDual`.

The countermodel keeps `CartanH8 = span {h^4}` nonzero while setting
`compactDual = source_invariants = bot`.  Exact image holds because the
source-invariant image is bot, and the target line holds because the
trivial-module part is bot.  Therefore the Cartan-to-compactDual containment
must come from genuine compact-dual/Cartan geometry, not from exact image or
target-side line control.
-/

import HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC100_H8ResidualCartanContainmentIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract

/-- One-dimensional source for the Cartan-containment independence model. -/
def CartanContainmentObstructionSource := Rat

/-- One-dimensional target for the Cartan-containment independence model. -/
def CartanContainmentObstructionTarget := Rat

instance : CommRing CartanContainmentObstructionSource := inferInstanceAs (CommRing Rat)
instance : Algebra Rat CartanContainmentObstructionSource := inferInstanceAs (Algebra Rat Rat)
instance : AddCommGroup CartanContainmentObstructionSource :=
  inferInstanceAs (AddCommGroup Rat)
instance : Module Rat CartanContainmentObstructionSource := inferInstanceAs (Module Rat Rat)
instance : AddCommGroup CartanContainmentObstructionTarget :=
  inferInstanceAs (AddCommGroup Rat)
instance : Module Rat CartanContainmentObstructionTarget := inferInstanceAs (Module Rat Rat)

/-- The identity Matsushima map for the countermodel. -/
def cartanContainmentObstructionIdMap :
    CartanContainmentObstructionSource →ₗ[Rat]
      CartanContainmentObstructionTarget :=
  LinearMap.id

noncomputable instance instCohomologyRingCartanContainmentObstructionSource :
    CohomologyRing CartanContainmentObstructionSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassCartanContainmentObstructionSource :
    KaehlerClass CartanContainmentObstructionSource where
  h := (1 : CartanContainmentObstructionSource)
  h_isAlgebraic := by
    change (1 : CartanContainmentObstructionSource) ∈
      (⊤ : Subalgebra Rat CartanContainmentObstructionSource)
    trivial
  h_pow_4_ne_zero := by
    change (1 : Rat) ^ 4 ≠ 0
    norm_num

noncomputable instance instCompactDualDataCartanContainmentObstructionSource :
    CompactDualData CartanContainmentObstructionSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : CartanContainmentObstructionSource) ^ 4)} :
        Set CartanContainmentObstructionSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoCartanContainmentObstructionSource :
    CartanCompactDualIso CartanContainmentObstructionSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := CartanContainmentObstructionSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataCartanContainmentObstruction :
    MatsushimaData CartanContainmentObstructionSource
      CartanContainmentObstructionTarget where
  j_q := cartanContainmentObstructionIdMap
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

noncomputable instance instMatsushimaSurjectivityDataCartanContainmentObstruction :
    MatsushimaSurjectivityData CartanContainmentObstructionSource
      CartanContainmentObstructionTarget where
  surjectivity_source := ⊥
  surjectivity_target := ⊥
  surjectivity_eq := by
    change
      Submodule.map cartanContainmentObstructionIdMap
          (⊥ : Submodule Rat CartanContainmentObstructionSource) =
        (⊥ : Submodule Rat CartanContainmentObstructionTarget)
    ext x
    simp [cartanContainmentObstructionIdMap]

noncomputable instance instMatsushimaCompactDualDataCartanContainmentObstruction :
    MatsushimaCompactDualData CartanContainmentObstructionSource
      CartanContainmentObstructionTarget where
  compactDual := ⊥
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataCartanContainmentObstruction :
    CuspidalCohomologyData CartanContainmentObstructionTarget where
  cuspidalSubspace := ⊥
  trivialModulePart := ⊥
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8CartanContainmentObstruction :
    EisensteinVanishingDeg8 CartanContainmentObstructionSource
      CartanContainmentObstructionTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8CartanContainmentObstruction :
    CuspidalGInvariantTrivialModuleDeg8 CartanContainmentObstructionSource
      CartanContainmentObstructionTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change
      (x ∈ (⊥ : Submodule Rat CartanContainmentObstructionTarget) ∧
          x ∈ (⊥ : Submodule Rat CartanContainmentObstructionTarget)) ↔
        x ∈ (⊥ : Submodule Rat CartanContainmentObstructionTarget)
    simp

/-- **R664 obstruction theorem (1/5)**: the countermodel has exact image. -/
theorem counterexample_sourceInvariantExactImageTarget :
    sourceInvariantExactImageTarget CartanContainmentObstructionSource
      CartanContainmentObstructionTarget := by
  change
    Submodule.map cartanContainmentObstructionIdMap
        (⊥ : Submodule Rat CartanContainmentObstructionSource) =
      (⊥ : Submodule Rat CartanContainmentObstructionTarget)
  ext x
  simp [cartanContainmentObstructionIdMap]

/-- **R664 obstruction theorem (2/5)**: the target generator-line containment
also holds, vacuously because the trivial-module part is bot. -/
theorem counterexample_trivialModulePart_le_h_pow_four_line :
    LE.le
      (CuspidalCohomologyData.trivialModulePart
        (A := CartanContainmentObstructionTarget))
      (Submodule.span Rat
        {MatsushimaData.j_q
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget)
          ((KaehlerClass.h : CartanContainmentObstructionSource) ^ 4)}) := by
  intro beta hbeta
  change beta ∈ (⊥ : Submodule Rat CartanContainmentObstructionTarget) at hbeta
  rw [Submodule.mem_bot] at hbeta
  rw [hbeta]
  exact Submodule.zero_mem _

/-- **R664 obstruction theorem (3/5)**: the Cartan-to-compactDual containment
fails because `h^4 = 1` spans CartanH8 while compactDual is bot. -/
theorem counterexample_not_cartanH8_le_compactDual :
    Not
      (LE.le (CartanCompactDualIso.trivialModuleGK_H8
          (A := CartanContainmentObstructionSource))
        (MatsushimaCompactDualData.compactDual
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget))) := by
  intro hcartan
  have hone_cartan :
      (1 : CartanContainmentObstructionSource) ∈
        CartanCompactDualIso.trivialModuleGK_H8
          (A := CartanContainmentObstructionSource) := by
    rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
      (A := CartanContainmentObstructionSource)]
    change (1 : CartanContainmentObstructionSource) ∈
      Submodule.span Rat
        ({((1 : CartanContainmentObstructionSource) ^ 4)} :
          Set CartanContainmentObstructionSource)
    rw [Submodule.mem_span_singleton]
    refine ⟨(1 : Rat), ?_⟩
    norm_num
  have hone_compact := hcartan hone_cartan
  change (1 : Rat) = 0 at hone_compact
  norm_num at hone_compact

/-- **R664 obstruction theorem (4/5)**: exact image plus the target
generator-line theorem do not force the source-side Cartan containment. -/
theorem current_interface_with_exactImage_line_does_not_force_cartanContainment :
    sourceInvariantExactImageTarget CartanContainmentObstructionSource
        CartanContainmentObstructionTarget ∧
      (LE.le
        (CuspidalCohomologyData.trivialModulePart
          (A := CartanContainmentObstructionTarget))
        (Submodule.span Rat
          {MatsushimaData.j_q
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget)
            ((KaehlerClass.h : CartanContainmentObstructionSource) ^ 4)})) ∧
      Not
        (LE.le (CartanCompactDualIso.trivialModuleGK_H8
            (A := CartanContainmentObstructionSource))
          (MatsushimaCompactDualData.compactDual
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget))) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_trivialModulePart_le_h_pow_four_line,
    counterexample_not_cartanH8_le_compactDual⟩

/-- Machine-readable status for the R664 Cartan-containment independence audit. -/
structure R664CartanContainmentIndependenceSnapshot where
  exactImageAvailable : Bool
  targetLineContainmentAvailable : Bool
  cartanContainmentForcedByThoseTargets : Bool
  cartanContainmentStillIndependentSourceSide : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R664 status: Cartan-to-compactDual remains an independent live target. -/
def currentR664CartanContainmentIndependenceSnapshot :
    R664CartanContainmentIndependenceSnapshot where
  exactImageAvailable := true
  targetLineContainmentAvailable := true
  cartanContainmentForcedByThoseTargets := false
  cartanContainmentStillIndependentSourceSide := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R664 obstruction theorem (5/5)**: kernel-checked status for the
Cartan-containment independence audit. -/
theorem currentR664CartanContainmentIndependenceSnapshot_eq_texStatus :
    currentR664CartanContainmentIndependenceSnapshot =
      ({ exactImageAvailable := true
         targetLineContainmentAvailable := true
         cartanContainmentForcedByThoseTargets := false
         cartanContainmentStillIndependentSourceSide := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R664CartanContainmentIndependenceSnapshot) := by
  decide

def R664_substantiveTheoremCount : Nat := 5

end FrontC100_H8ResidualCartanContainmentIndependence
end HCGapL4
end HodgeReduction
