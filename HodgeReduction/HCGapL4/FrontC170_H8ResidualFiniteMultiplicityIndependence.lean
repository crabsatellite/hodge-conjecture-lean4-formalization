/-
# HC Gap L4 -- Front C170: finite multiplicity is still independent (R735).

R734 rewrites the current target side as finite-dimensional
`trivialModulePart` plus `finrank trivialModulePart <= 1`, after the
generator containment `H8 <= compactDual`.

This file records the matching guardrail.  The existing R706/R732 no-extra
countermodel has boundary data and can be equipped with the paper-facing
GK/Borel--Wallach/BBW/Freudenthal carrier stack.  It also satisfies
`H8 <= compactDual` because its compact-dual carrier is top.  Nevertheless
R734 finite multiplicity cannot hold there: if it did, R734 would give the
target-line theorem and R733 would force the refuted containment
`compactDual <= H8`.

Thus the new finite-multiplicity spelling is a genuine automorphic target,
not a consequence of the current carrier stack plus boundary and generator
containment.
-/

import HodgeReduction.HCGapL4.FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
import HodgeReduction.HCGapL4.FrontC167_H8ResidualCurrentTwoContainmentIndependence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC170_H8ResidualFiniteMultiplicityIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC167_H8ResidualCurrentTwoContainmentIndependence
open FrontC168_H8ResidualNoExtraTargetLineEquivalence
open FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence

/-! ## The no-extra countermodel has the R733/R734 generator containment. -/

/-- **R735 obstruction theorem (1/5)**: the R706 no-extra countermodel also
satisfies the current generator containment `H8 <= compactDual`, because its
Matsushima compact-dual carrier is top.
-/
theorem counterexample_H8_le_compactDual_noExtra :
    LE.le (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))
      (MatsushimaCompactDualData.compactDual
        (A := BoundaryNoExtraObstructionSource)
        (B := BoundaryNoExtraObstructionTarget)) := by
  intro _ _
  change _ ∈ (⊤ : Submodule Rat BoundaryNoExtraObstructionSource)
  trivial

/-! ## Carrier stack plus boundary plus generator does not force R734. -/

/-- **R735 obstruction theorem (2/5)**: paper-facing carriers, boundary data,
and `H8 <= compactDual` still do not force finite rank-one
`trivialModulePart` multiplicity.
-/
theorem paperCarrierStack_boundaryData_H8Containment_does_not_force_finiteTrivialMultiplicity :
    Nonempty (GKCohomologyData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource) /\
      Nonempty (CompactDualH44Bigrading BoundaryNoExtraObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget) /\
      Nonempty (FreudenthalRealization BoundaryNoExtraObstructionTarget) /\
      MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      LE.le (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))
        (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)) /\
      Not
        (FiniteDimensional Rat
            (CuspidalCohomologyData.trivialModulePart
              (A := BoundaryNoExtraObstructionTarget)) /\
          Module.finrank (R := Rat)
            (CuspidalCohomologyData.trivialModulePart
              (A := BoundaryNoExtraObstructionTarget)) <= 1) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hnotCompactLe⟩ :=
      paperCarrierStack_boundaryData_does_not_force_compactDual_le_H8
  let hH8 :
      LE.le (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))
        (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)) :=
    counterexample_H8_le_compactDual_noExtra
  refine
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hH8, ?_⟩
  intro hfiniteRank
  have hline :
      CuspidalCohomologyData.trivialModulePart
          (A := BoundaryNoExtraObstructionTarget) <=
        Submodule.span Rat
          {MatsushimaData.j_q
              (A := BoundaryNoExtraObstructionSource)
              (B := BoundaryNoExtraObstructionTarget)
            ((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4)} :=
    (trivialModulePart_le_h_pow_four_line_iff_finiteMultiplicity_under_H8_le_compactDual
      (A := BoundaryNoExtraObstructionSource)
      (B := BoundaryNoExtraObstructionTarget) hH8).2 hfiniteRank
  have hcompactLe :
      LE.le (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget))
        (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource)) :=
    compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
      (A := BoundaryNoExtraObstructionSource)
      (B := BoundaryNoExtraObstructionTarget)
      hboundary hH8 hline
  exact hnotCompactLe hcompactLe

/-- **R735 obstruction theorem (3/5)**: the same countermodel blocks the
entire R734 finite-multiplicity contract, not merely its numerical field.
-/
theorem paperCarrierStack_boundaryData_H8Containment_does_not_force_R734Contract :
    Nonempty (GKCohomologyData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelWallachLowDegreeVanishing BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilData BoundaryNoExtraObstructionSource) /\
      Nonempty (BorelBottWeilDiagonalEVII BoundaryNoExtraObstructionSource) /\
      Nonempty (CompactDualH44Bigrading BoundaryNoExtraObstructionSource) /\
      Nonempty (FreudenthalH8GInvariance BoundaryNoExtraObstructionTarget) /\
      Nonempty (FreudenthalRealization BoundaryNoExtraObstructionTarget) /\
      MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      LE.le (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))
        (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)) /\
      Not
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract
          BoundaryNoExtraObstructionSource
          BoundaryNoExtraObstructionTarget) := by
  obtain
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hH8, hnotFinite⟩ :=
      paperCarrierStack_boundaryData_H8Containment_does_not_force_finiteTrivialMultiplicity
  refine
    ⟨hgk, hbw, hbbw, hdiag, hh44, hginv, hreal, hboundary, hH8, ?_⟩
  intro O
  exact hnotFinite
    ⟨O.trivialModulePart_finite, O.trivialModulePart_finrank_le_one⟩

/-- **R735 obstruction theorem (4/5)**: in the R734 spelling, the current
paper-carrier stack plus boundary and generator containment still does not
close the active residual route.
-/
theorem paperCarrierStack_boundaryData_H8Containment_does_not_close_R734_route :
    Not
      (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget) :=
  paperCarrierStack_boundaryData_H8Containment_does_not_force_R734Contract.2.2.2.2.2.2.2.2.2

/-- R735 target names for route summaries. -/
def currentR735FiniteMultiplicityIndependenceTargetNames : List String := [
  "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1 by genuine automorphic multiplicity geometry",
  "do not derive R734 finite multiplicity from GK/Borel-Wallach/BBW/Freudenthal carriers plus boundary and H8 containment alone"
]

/-- Machine-readable status for the R735 finite-multiplicity guardrail. -/
structure R735FiniteMultiplicityIndependenceSnapshot where
  paperCarrierStackAvailable : Bool
  boundaryDataAvailable : Bool
  H8ContainmentAvailable : Bool
  paperCarrierStackForcesFiniteMultiplicity : Bool
  paperCarrierStackClosesR734Contract : Bool
  finiteMultiplicityStillAutomorphicTarget : Bool
  provesFiniteMultiplicity : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R735 status: R734's finite-multiplicity target remains genuine
automorphic proof work; it is not forced by the current paper-carrier stack
even after boundary data and `H8 <= compactDual` are supplied.
-/
def currentR735FiniteMultiplicityIndependenceSnapshot :
    R735FiniteMultiplicityIndependenceSnapshot where
  paperCarrierStackAvailable := true
  boundaryDataAvailable := true
  H8ContainmentAvailable := true
  paperCarrierStackForcesFiniteMultiplicity := false
  paperCarrierStackClosesR734Contract := false
  finiteMultiplicityStillAutomorphicTarget := true
  provesFiniteMultiplicity := false
  provesBoundaryData := false
  provesH8Containment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R735 obstruction theorem (5/5)**: kernel-checked status for the
finite-multiplicity guardrail.
-/
theorem currentR735FiniteMultiplicityIndependenceSnapshot_eq_texStatus :
    currentR735FiniteMultiplicityIndependenceSnapshot =
      ({ paperCarrierStackAvailable := true
         boundaryDataAvailable := true
         H8ContainmentAvailable := true
         paperCarrierStackForcesFiniteMultiplicity := false
         paperCarrierStackClosesR734Contract := false
         finiteMultiplicityStillAutomorphicTarget := true
         provesFiniteMultiplicity := false
         provesBoundaryData := false
         provesH8Containment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R735FiniteMultiplicityIndependenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R735 guardrail. -/
theorem currentR735FiniteMultiplicityIndependenceTargetNames_eq_texStatus :
    currentR735FiniteMultiplicityIndependenceTargetNames = [
      "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1 by genuine automorphic multiplicity geometry",
      "do not derive R734 finite multiplicity from GK/Borel-Wallach/BBW/Freudenthal carriers plus boundary and H8 containment alone"
    ] := by
  rfl

def R735_substantiveTheoremCount : Nat := 5

end FrontC170_H8ResidualFiniteMultiplicityIndependence
end HCGapL4
end HodgeReduction
