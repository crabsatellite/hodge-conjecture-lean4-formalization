/-
# HC Gap L4 -- Front C158: independence of the two R722 targets (R723).

R722 collapses the live primitive route to two geometric targets:

* `MatsushimaV56BoundaryData`;
* `compactDual = H8`.

This file records the matching deadend: in the current abstract interface
neither target implies the other.  Boundary data alone does not force
`compactDual = H8`, and `compactDual = H8` alone does not force boundary data.

No target is proved here.  The result is a guardrail for the next attack:
future work must supply genuine EVII compact-dual/source-invariant geometry
and genuine Matsushima boundary geometry separately, or add a theorem that
connects them from outside the current abstract interface.
-/

import HodgeReduction.HCGapL4.FrontC157_H8ResidualBoundaryCompactDualPrimitiveCollapse
import HodgeReduction.HCGapL4.FrontC141_H8ResidualBoundaryCarrierIndependence
import HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC158_H8ResidualBoundaryCompactDualIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC53_H8ResidualBoundaryDataPackage
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC141_H8ResidualBoundaryCarrierIndependence

/-! ## Boundary data does not force compact-dual H8. -/

/-- **R723 obstruction theorem (1/4)**: the R706 boundary-data model with an
extra compact-dual direction also refutes deriving `compactDual = H8` from
boundary data alone. -/
theorem boundaryData_alone_does_not_force_compactDual_eq_H8 :
    MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      Not
        (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget) =
          CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)) := by
  refine ⟨counterexample_boundaryData_noExtra, ?_⟩
  intro hcompact
  have hle :
      LE.le (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget))
        (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)) := by
    rw [hcompact]
  exact counterexample_not_compactDual_le_H8 hle

/-- **R723 obstruction theorem (2/4)**: in the same boundary-data model,
boundary data alone does not produce the two-target R722 contract. -/
theorem boundaryData_alone_does_not_force_boundaryDataCompactDualH8Contract :
    MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      Not
        (EVIIH8ResidualBoundaryDataCompactDualH8Contract
          BoundaryNoExtraObstructionSource
          BoundaryNoExtraObstructionTarget) := by
  refine ⟨counterexample_boundaryData_noExtra, ?_⟩
  intro O
  exact boundaryData_alone_does_not_force_compactDual_eq_H8.2 O.compactDual_eq_H8

/-! ## Compact-dual H8 does not force boundary data. -/

/-- **R723 obstruction theorem (3/4)**: the older R594 countermodel says
`compactDual = H8` alone still does not force honest boundary data. -/
theorem compactDual_eq_H8_alone_does_not_force_boundaryData :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not (MatsushimaV56BoundaryData TargetBettiSource TargetBettiTarget) :=
  current_interface_with_compactDual_eq_H8_does_not_force_boundaryData

/-- **R723 obstruction theorem (4/4)**: in that same model,
`compactDual = H8` alone does not produce the two-target R722 contract. -/
theorem compactDual_eq_H8_alone_does_not_force_boundaryDataCompactDualH8Contract :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (EVIIH8ResidualBoundaryDataCompactDualH8Contract
          TargetBettiSource
          TargetBettiTarget) := by
  refine ⟨compactDual_eq_H8_alone_does_not_force_boundaryData.1, ?_⟩
  intro O
  exact compactDual_eq_H8_alone_does_not_force_boundaryData.2 O.boundary

/-- Machine-readable status for the R723 independence guardrail. -/
structure R723BoundaryCompactDualIndependenceSnapshot where
  boundaryDataDoesNotForceCompactDualH8 : Bool
  compactDualH8DoesNotForceBoundaryData : Bool
  boundaryDataAloneDoesNotForceR722Contract : Bool
  compactDualH8AloneDoesNotForceR722Contract : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R723 status: the two R722 targets are independent in the current
abstract interface. -/
def currentR723BoundaryCompactDualIndependenceSnapshot :
    R723BoundaryCompactDualIndependenceSnapshot where
  boundaryDataDoesNotForceCompactDualH8 := true
  compactDualH8DoesNotForceBoundaryData := true
  boundaryDataAloneDoesNotForceR722Contract := true
  compactDualH8AloneDoesNotForceR722Contract := true
  provesBoundaryData := false
  provesCompactDualH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R723 independence guardrail. -/
theorem currentR723BoundaryCompactDualIndependenceSnapshot_eq_texStatus :
    currentR723BoundaryCompactDualIndependenceSnapshot =
      ({ boundaryDataDoesNotForceCompactDualH8 := true
         compactDualH8DoesNotForceBoundaryData := true
         boundaryDataAloneDoesNotForceR722Contract := true
         compactDualH8AloneDoesNotForceR722Contract := true
         provesBoundaryData := false
         provesCompactDualH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R723BoundaryCompactDualIndependenceSnapshot) := by
  decide

def R723_substantiveTheoremCount : Nat := 4

end FrontC158_H8ResidualBoundaryCompactDualIndependence
end HCGapL4
end HodgeReduction
