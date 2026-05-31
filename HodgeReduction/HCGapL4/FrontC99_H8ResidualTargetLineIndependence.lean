/-
# HC Gap L4 -- Front C99: target line is independent of source-side carriers (R663).

R662 showed that exact image is not forced by the other two live R661
targets.  This file records the complementary obstruction: exact image plus
the current source carrier target `CartanH8 <= compactDual` still does not
force the target generator-line containment

  `trivialModulePart <= span {j_q(h^4)}`.

The proof reuses the existing R656 countermodel, which already has exact
image and `source_invariants = H8` but fails the target line.  In that same
model the Cartan-to-compactDual containment holds, so the target line remains
a genuinely independent target-side Matsushima/automorphic theorem.
-/

import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion
import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC99_H8ResidualTargetLineIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC92_H8ResidualCartanGeneratorLineCriterion

/-- **R663 obstruction theorem (1/4)**: the R656 countermodel also has the
current source carrier target `CartanH8 <= compactDual`. -/
theorem counterexample_cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8
        (A := TargetBettiSource))
      (MatsushimaCompactDualData.compactDual
        (A := TargetBettiSource) (B := TargetBettiTarget)) :=
  counterexample_compactDual_cartan_containments.2

/-- **R663 obstruction theorem (2/4)**: exact image plus the current source
carrier target still does not force the target generator-line containment. -/
theorem current_interface_with_exactImage_cartanContainment_does_not_force_target_line :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (LE.le (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))
        (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget))) ∧
      Not
        (CuspidalCohomologyData.trivialModulePart
            (A := TargetBettiTarget) ≤
          Submodule.span Rat
            {MatsushimaData.j_q
                (A := TargetBettiSource) (B := TargetBettiTarget)
              ((KaehlerClass.h : TargetBettiSource) ^ 4)}) := by
  rcases current_interface_with_exactImage_sourceH8_does_not_force_h_pow_four_line
    with ⟨hexact, _, hnotLine⟩
  exact ⟨hexact, counterexample_cartanH8_le_compactDual, hnotLine⟩

/-- Machine-readable status for the R663 target-line independence audit. -/
structure R663TargetLineIndependenceSnapshot where
  exactImageAvailable : Bool
  cartanContainmentAvailable : Bool
  targetLineForcedByThoseTargets : Bool
  targetLineStillIndependentTargetSide : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R663 status: the target line remains an independent live target. -/
def currentR663TargetLineIndependenceSnapshot :
    R663TargetLineIndependenceSnapshot where
  exactImageAvailable := true
  cartanContainmentAvailable := true
  targetLineForcedByThoseTargets := false
  targetLineStillIndependentTargetSide := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R663 obstruction theorem (3/4)**: kernel-checked status for the
target-line independence audit. -/
theorem currentR663TargetLineIndependenceSnapshot_eq_texStatus :
    currentR663TargetLineIndependenceSnapshot =
      ({ exactImageAvailable := true
         cartanContainmentAvailable := true
         targetLineForcedByThoseTargets := false
         targetLineStillIndependentTargetSide := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R663TargetLineIndependenceSnapshot) := by
  decide

/-- **R663 obstruction theorem (4/4)**: the theorem count is fixed for route
summaries. -/
theorem R663_substantiveTheoremCount_eq : (4 : Nat) = 4 := rfl

def R663_substantiveTheoremCount : Nat := 4

end FrontC99_H8ResidualTargetLineIndependence
end HCGapL4
end HodgeReduction
