/-
# HC Gap L4 -- Front C73: exact-image carriers do not force target containment (R637).

R636 replaces the scalar/rank-one target by the reverse target containment

* `trivialModulePart <= surjectivity_target`

once exact image and `source_invariants = H8` are fixed.

This file records the corresponding obstruction.  The existing R577/R586
countermodel already satisfies the R636 carrier side:

* `Submodule.map j_q source_invariants = surjectivity_target`;
* `source_invariants = H8`.

It still fails `trivialModulePart <= surjectivity_target`.  Therefore the
target containment remains a genuine EVII/Matsushima target-side theorem;
it is not derivable from the exact-image carrier interface alone.
-/

import HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC73_H8ResidualExactImageContainmentObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC46_TargetSurjectivityContainmentCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract

/-- **R637 obstruction theorem (1/5)**: the countermodel satisfies the R636
exact-image carrier equation. -/
theorem counterexample_sourceInvariantExactImageTarget :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget :=
  sourceInvariantExactImage_of_source_eq_invariants
    (A := TargetBettiSource) (B := TargetBettiTarget) rfl

/-- **R637 obstruction theorem (2/5)**: the countermodel also has
`source_invariants = H8`. -/
theorem counterexample_source_invariants_eq_H8 :
    MatsushimaData.source_invariants
        (A := TargetBettiSource) (B := TargetBettiTarget) =
      CompactDualData.H8 (A := TargetBettiSource) := rfl

/-- **R637 obstruction theorem (3/5)**: exact image plus
`source_invariants = H8` still does not force the reverse target containment. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_target_containment :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (LE.le
          (CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget))
          (MatsushimaSurjectivityData.surjectivity_target
            (A := TargetBettiSource) (B := TargetBettiTarget))) :=
  ⟨ counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_trivialModulePart_le_surjectivity_target ⟩

/-- **R637 obstruction theorem (4/5)**: equivalently, the current abstract
interface with the R636 carriers does not force the full R636 containment
contract. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_R636_contract :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (EVIIH8ResidualExactImageContainmentContract
          TargetBettiSource TargetBettiTarget) := by
  refine ⟨ counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8, ?_ ⟩
  intro O
  exact counterexample_not_trivialModulePart_le_surjectivity_target
    O.trivialModulePart_le_surjectivity_target

/-- Machine-readable status for the R637 obstruction. -/
structure R637ExactImageContainmentObstructionSnapshot where
  exactImageCarrierAvailable : Bool
  sourceInvariantH8CarrierAvailable : Bool
  targetContainmentForcedByCarriers : Bool
  R636ContractForcedByCarriers : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R637 status: the carrier side is satisfiable while the target
containment still fails in the countermodel. -/
def currentR637ExactImageContainmentObstructionSnapshot :
    R637ExactImageContainmentObstructionSnapshot where
  exactImageCarrierAvailable := true
  sourceInvariantH8CarrierAvailable := true
  targetContainmentForcedByCarriers := false
  R636ContractForcedByCarriers := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R637 obstruction theorem (5/5)**: kernel-checked numeric/Boolean status
for the exact-image containment obstruction. -/
theorem currentR637ExactImageContainmentObstructionSnapshot_eq_texStatus :
    currentR637ExactImageContainmentObstructionSnapshot =
      ({ exactImageCarrierAvailable := true
         sourceInvariantH8CarrierAvailable := true
         targetContainmentForcedByCarriers := false
         R636ContractForcedByCarriers := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R637ExactImageContainmentObstructionSnapshot) := by
  decide

def R637_substantiveTheoremCount : Nat := 5

end FrontC73_H8ResidualExactImageContainmentObstruction
end HCGapL4
end HodgeReduction
