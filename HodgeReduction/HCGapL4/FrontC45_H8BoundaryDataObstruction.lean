/-
# HC Gap L4 -- Front C45: H8 carrier equalities do not force boundary data (R586).

R585 gave a clean positive equivalence: with source and compactDual fixed
to `H8`, target rank / scalar preimages / target boundary equality are
all equivalent to the existing `MatsushimaV56BoundaryData` package.

This file records the corresponding negative audit.  The R577
countermodel already has both carrier equalities:

* `surjectivity_source = H8`;
* `compactDual = H8`;

but its target side is too large.  Therefore no later agent should try
to close the remaining boundary data from the abstract H8 carrier
equalities alone; the missing input must be real Matsushima/EVII target
geometry.
-/

import HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence
import HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC45_H8BoundaryDataObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction

/-- **R586 obstruction theorem (1/4)**: the R577 countermodel already
has `surjectivity_source = H8`. -/
theorem counterexample_source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source
        (A := TargetBettiSource) (B := TargetBettiTarget) =
      CompactDualData.H8 (A := TargetBettiSource) := rfl

/-- **R586 obstruction theorem (2/4)**: the R577 countermodel already
has `compactDual = H8`. -/
theorem counterexample_compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual
        (A := TargetBettiSource) (B := TargetBettiTarget) =
      CompactDualData.H8 (A := TargetBettiSource) := rfl

/-- **R586 obstruction theorem (3/4)**: despite both H8 carrier
equalities, the countermodel cannot satisfy `MatsushimaV56BoundaryData`.
-/
theorem counterexample_not_matsushimaV56BoundaryData :
    ¬ MatsushimaV56BoundaryData TargetBettiSource TargetBettiTarget := by
  intro D
  have htop :
      ((0, 1) : TargetBettiTarget) ∈
        MatsushimaData.target_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) := by
    trivial
  have hsurj :
      ((0, 1) : TargetBettiTarget) ∈
        MatsushimaSurjectivityData.surjectivity_target
          (A := TargetBettiSource) (B := TargetBettiTarget) := by
    rw [D.target_eq_invariants]
    exact htop
  change ((0, 1) : TargetBettiTarget) ∈
      Submodule.map targetBettiFirstCoordinateMap
        (CompactDualData.H8 (A := TargetBettiSource)) at hsurj
  rcases hsurj with ⟨x, _hx, hxmap⟩
  have hsnd := congrArg Prod.snd hxmap
  simp [targetBettiFirstCoordinateMap] at hsnd

/-- **R586 obstruction theorem (4/4)**: equivalently, the abstract H8
carrier equalities do not force the target boundary equality
`surjectivity_target = trivialModulePart`. -/
theorem current_interface_with_H8_equalities_does_not_force_target_boundary :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      ¬ (MatsushimaSurjectivityData.surjectivity_target
            (A := TargetBettiSource) (B := TargetBettiTarget) =
          CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget)) := by
  refine ⟨counterexample_source_eq_H8, counterexample_compactDual_eq_H8, ?_⟩
  intro htarget_trivial
  exact counterexample_not_matsushimaV56BoundaryData
    (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
      (A := TargetBettiSource) (B := TargetBettiTarget)
      counterexample_source_eq_H8
      counterexample_compactDual_eq_H8
      htarget_trivial)

def R586_substantiveTheoremCount : Nat := 4

end FrontC45_H8BoundaryDataObstruction
end HCGapL4
end HodgeReduction
