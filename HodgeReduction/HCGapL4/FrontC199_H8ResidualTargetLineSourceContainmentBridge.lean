/-
# HC Gap L4 -- Front C199: target-line data feeds the source containments (R764).

R763 separates the current source-H8 task into two independent source-native
containments:

  * `H8 <= source_invariants`;
  * `source_invariants <= H8`.

This file consumes the existing R741 target-generator transport and the R659
target-line/no-extra bridge to move both containments to target-side geometry.
Under honest `MatsushimaV56BoundaryData`, the first source containment is
equivalent to `j_q(h^4) in target_invariants`; the second follows from the
target line containment `target_invariants <= span {j_q(h^4)}`.

Thus the next concrete attack is not an abstract rank or source-line shortcut:
prove the target generator and target no-extra line facts from the EVII
Matsushima/Borel--Wallach geometry.
-/

import HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment
import HodgeReduction.HCGapL4.FrontC176_H8ResidualTargetGeneratorBoundaryTransport
import HodgeReduction.HCGapL4.FrontC198_H8ResidualSourceContainmentIndependence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC199_H8ResidualTargetLineSourceContainmentBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC95_H8ResidualSourceNoExtraFromLineContainment
open FrontC148_H8ResidualSourceGeneratorContainmentRoute
open FrontC176_H8ResidualTargetGeneratorBoundaryTransport
open FrontC194_H8ResidualCompactDualSourceInvariantBridge
open FrontC197_H8ResidualSourceRankNoExtraEquivalence

section TargetLineSourceContainmentBridge

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R764 substantive theorem (1/7)**: with honest boundary data, the R763
generator/source containment target is exactly target generator membership. -/
theorem H8_le_source_invariants_iff_targetGenerator_mem_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    LE.le (CompactDualData.H8 (A := A))
        (MatsushimaData.source_invariants (A := A) (B := B)) <->
      (MatsushimaData.target_invariants (A := A) (B := B)).carrier
        (MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)) :=
  (H8_le_source_invariants_iff_h_pow_four_mem_source_invariants
    (A := A) (B := B)).trans
    (h_pow_four_mem_source_invariants_iff_targetGenerator_mem_of_boundaryData
      (A := A) (B := B) D)

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R764 substantive theorem (2/7)**: source H8 containment supplies the
target generator under boundary data. -/
theorem targetGenerator_mem_of_boundaryData_H8_le_source_invariants
    (D : MatsushimaV56BoundaryData A B)
    (hH8 :
      LE.le (CompactDualData.H8 (A := A))
        (MatsushimaData.source_invariants (A := A) (B := B))) :
    (MatsushimaData.target_invariants (A := A) (B := B)).carrier
      (MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4)) :=
  (H8_le_source_invariants_iff_targetGenerator_mem_of_boundaryData
    (A := A) (B := B) D).1 hH8

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R764 substantive theorem (3/7)**: target generator membership supplies
the source H8 containment under boundary data. -/
theorem H8_le_source_invariants_of_boundaryData_targetGenerator_mem
    (D : MatsushimaV56BoundaryData A B)
    (htarget :
      (MatsushimaData.target_invariants (A := A) (B := B)).carrier
        (MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4))) :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaData.source_invariants (A := A) (B := B)) :=
  (H8_le_source_invariants_iff_targetGenerator_mem_of_boundaryData
    (A := A) (B := B) D).2 htarget

/-- **R764 substantive theorem (4/7)**: the target-invariant line containment
is equivalent to the trivial-module line containment used by R659. -/
theorem trivialModulePart_le_h_pow_four_line_of_target_invariants_le_h_pow_four_line
    (hline :
      LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    LE.le (CuspidalCohomologyData.trivialModulePart (A := B))
      (Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) := by
  intro beta hbeta
  apply hline
  simpa [target_invariants_eq_trivialModulePart (A := A) (B := B)] using hbeta

/-- **R764 substantive theorem (5/7)**: target no-extra line containment
forces the R763 no-extra source containment. -/
theorem source_invariants_le_H8_of_target_invariants_le_h_pow_four_line
    (hline :
      LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    LE.le (MatsushimaData.source_invariants (A := A) (B := B))
      (CompactDualData.H8 (A := A)) :=
  source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B)
    (trivialModulePart_le_h_pow_four_line_of_target_invariants_le_h_pow_four_line
      (A := A) (B := B) hline)

/-- **R764 substantive theorem (6/7)**: boundary data plus the two target-line
facts closes the source-H8 equality. -/
theorem source_invariants_eq_H8_of_boundaryData_targetGenerator_mem_and_targetLine
    (D : MatsushimaV56BoundaryData A B)
    (htarget :
      (MatsushimaData.target_invariants (A := A) (B := B)).carrier
        (MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)))
    (hline :
      LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (source_invariants_eq_H8_iff_h_pow_four_mem_and_source_invariants_le_H8
    (A := A) (B := B)).2
    ⟨(h_pow_four_mem_source_invariants_iff_targetGenerator_mem_of_boundaryData
        (A := A) (B := B) D).2 htarget,
      source_invariants_le_H8_of_target_invariants_le_h_pow_four_line
        (A := A) (B := B) hline⟩

/-- **R764 substantive theorem (7/7)**: the same target-line facts feed the
visible compact-dual/H8 target consumed by the current residual route. -/
theorem compactDual_eq_H8_of_boundaryData_targetGenerator_mem_and_targetLine
    (D : MatsushimaV56BoundaryData A B)
    (htarget :
      (MatsushimaData.target_invariants (A := A) (B := B)).carrier
        (MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)))
    (hline :
      LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_source_invariants_eq_H8
    (A := A) (B := B)
    (source_invariants_eq_H8_of_boundaryData_targetGenerator_mem_and_targetLine
      (A := A) (B := B) D htarget hline)

end TargetLineSourceContainmentBridge

/-- R764 target names for route summaries. -/
def currentR764TargetLineSourceContainmentTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove j_q(h^4) in target_invariants",
  "prove target_invariants <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R764 target-line/source-containment bridge. -/
structure R764TargetLineSourceContainmentSnapshot where
  proofWorkObligationCount : Nat
  sourceGeneratorContainmentEquivalentToTargetGenerator : Bool
  targetLineForcesSourceNoExtraContainment : Bool
  targetGeneratorAndLineFeedSourceH8 : Bool
  targetGeneratorAndLineFeedCompactDualH8 : Bool
  provesBoundaryData : Bool
  provesTargetGeneratorMembership : Bool
  provesTargetLineContainment : Bool
  provesSourceH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R764 status: the R763 source-containment pair has been moved to
two concrete target-line geometry facts plus the still-open boundary theorem. -/
def currentR764TargetLineSourceContainmentSnapshot :
    R764TargetLineSourceContainmentSnapshot where
  proofWorkObligationCount := currentR764TargetLineSourceContainmentTargetNames.length
  sourceGeneratorContainmentEquivalentToTargetGenerator := true
  targetLineForcesSourceNoExtraContainment := true
  targetGeneratorAndLineFeedSourceH8 := true
  targetGeneratorAndLineFeedCompactDualH8 := true
  provesBoundaryData := false
  provesTargetGeneratorMembership := false
  provesTargetLineContainment := false
  provesSourceH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R764 bridge. -/
theorem currentR764TargetLineSourceContainmentSnapshot_eq_texStatus :
    currentR764TargetLineSourceContainmentSnapshot =
      ({ proofWorkObligationCount := 3
         sourceGeneratorContainmentEquivalentToTargetGenerator := true
         targetLineForcesSourceNoExtraContainment := true
         targetGeneratorAndLineFeedSourceH8 := true
         targetGeneratorAndLineFeedCompactDualH8 := true
         provesBoundaryData := false
         provesTargetGeneratorMembership := false
         provesTargetLineContainment := false
         provesSourceH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R764TargetLineSourceContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R764 bridge. -/
theorem currentR764TargetLineSourceContainmentTargetNames_eq_texStatus :
    currentR764TargetLineSourceContainmentTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove j_q(h^4) in target_invariants",
      "prove target_invariants <= span {j_q(h^4)}"
    ] := by
  rfl

def R764_substantiveTheoremCount : Nat := 7

end FrontC199_H8ResidualTargetLineSourceContainmentBridge
end HCGapL4
end HodgeReduction
