/-
# HC Gap L4 -- Front C110: boundary data plus target line (R674).

R673 proved that the older boundary-data/source-H8 route is equivalent to
the current target-line residual contract.  This file tightens that statement:
once honest `MatsushimaV56BoundaryData` is available, the target-line equality
itself forces `source_invariants = H8`.

So the boundary route no longer needs to keep source-H8 and target-line as two
independent live assumptions.  Under boundary data, either one implies the
other.  The remaining geometric work is boundary data plus the target-side
line theorem; this file does not prove either theorem.
-/

import HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC110_H8ResidualBoundaryDataTargetLineEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC20_MatsushimaCompactDualExactImageCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC109_H8ResidualBoundaryDataEquivalence

section BoundaryDataTargetLine

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
/-- **R674 substantive theorem (1/6)**: under honest boundary data, the
target-invariant line equality recovers `source_invariants = H8`. -/
theorem source_invariants_eq_H8_of_boundaryData_targetLine
    (D : MatsushimaV56BoundaryData A B)
    (hline :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  have hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A) := by
    apply submodule_eq_of_map_eq_of_injective
      (MatsushimaData.j_q (A := A) (B := B))
      (MatsushimaData.j_q_injective (A := A) (B := B))
    calc
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))
          =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
          rw [<- D.source_eq_compactDual]
      _ =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
          MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)
      _ = MatsushimaData.target_invariants (A := A) (B := B) :=
          D.target_eq_invariants
      _ =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} := hline
      _ =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (Submodule.span Rat {((KaehlerClass.h : A) ^ 4)}) := by
          rw [Submodule.map_span]
          simp
      _ =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CompactDualData.H8 (A := A)) := by
          rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  calc
    MatsushimaData.source_invariants (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        (MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)).symm
    _ = CompactDualData.H8 (A := A) := hcompact

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R674 substantive theorem (2/6)**: with boundary data fixed, source-H8
and target-line equality are the same residual target. -/
theorem source_H8_iff_targetLine_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    (MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)) <->
      (MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :=
  Iff.intro
    (fun hsource =>
      target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
        (A := A) (B := B) D hsource)
    (fun hline =>
      source_invariants_eq_H8_of_boundaryData_targetLine
        (A := A) (B := B) D hline)

/-- Boundary data plus target-line equality.  R674 proves this is equivalent
to the current R669/R673 residual contract, without separately assuming
source-H8. -/
structure EVIIH8ResidualBoundaryDataTargetLineContract
    (A B : Type*)
    [CommRing A] [Algebra Rat A] [CohomologyRing A]
    [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B]
    [CuspidalCohomologyData B]
    [EisensteinVanishingDeg8 A B]
    [CuspidalGInvariantTrivialModuleDeg8 A B] where
  boundary : MatsushimaV56BoundaryData A B
  target_invariants_eq_h_pow_four_line :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R674 substantive theorem (3/6)**: boundary data plus target-line
equality rebuilds the current line-equality contract, deriving source-H8
rather than assuming it. -/
def targetInvariantLineEqualityContract_of_boundaryDataTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImageTarget_of_matsushimaV56BoundaryData
      (A := A) (B := B) O.boundary
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_boundaryData_targetLine
      (A := A) (B := B) O.boundary O.target_invariants_eq_h_pow_four_line
  target_invariants_eq_h_pow_four_line :=
    O.target_invariants_eq_h_pow_four_line

/-- **R674 substantive theorem (4/6)**: the current line-equality contract
produces the boundary-data plus target-line spelling. -/
def boundaryDataTargetLineContract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualBoundaryDataTargetLineContract A B where
  boundary :=
    matsushimaV56BoundaryData_of_targetInvariantLineEqualityContract
      (A := A) (B := B) O
  target_invariants_eq_h_pow_four_line :=
    O.target_invariants_eq_h_pow_four_line

/-- **R674 substantive theorem (5/6)**: at the inhabited-contract level,
boundary data plus target-line equality is the same current residual target. -/
theorem residual_boundaryDataTargetLine_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_boundaryDataTargetLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataTargetLineContract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))

/-- **R674 substantive theorem (6/6)**: boundary data plus target-line
equality is also equivalent to the older boundary-data/source-H8 spelling. -/
theorem residual_boundaryDataTargetLine_nonempty_iff_boundaryDataSourceH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  residual_boundaryDataTargetLine_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataSourceH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end BoundaryDataTargetLine

/-- R674 target names for route summaries. -/
def currentR674BoundaryDataTargetLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove target_invariants = span {j_q(h^4)}"
]

/-- Machine-readable status for the R674 boundary-data/target-line route. -/
structure R674BoundaryDataTargetLineSnapshot where
  proofWorkObligationCount : Nat
  boundaryDataTargetLineDerivesSourceH8 : Bool
  sourceH8EquivalentToTargetLineUnderBoundaryData : Bool
  boundaryDataTargetLineEquivalentToLineEqualityContract : Bool
  boundaryDataTargetLineEquivalentToBoundaryDataSourceH8 : Bool
  provesBoundaryData : Bool
  provesTargetLine : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R674 status: source-H8 is no longer an independent assumption
inside the boundary-data route; it follows from boundary data plus target-line
equality. -/
def currentR674BoundaryDataTargetLineSnapshot :
    R674BoundaryDataTargetLineSnapshot where
  proofWorkObligationCount := currentR674BoundaryDataTargetLineTargetNames.length
  boundaryDataTargetLineDerivesSourceH8 := true
  sourceH8EquivalentToTargetLineUnderBoundaryData := true
  boundaryDataTargetLineEquivalentToLineEqualityContract := true
  boundaryDataTargetLineEquivalentToBoundaryDataSourceH8 := true
  provesBoundaryData := false
  provesTargetLine := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R674 ledger. -/
theorem currentR674BoundaryDataTargetLineSnapshot_eq_texStatus :
    currentR674BoundaryDataTargetLineSnapshot =
      ({ proofWorkObligationCount := 2
         boundaryDataTargetLineDerivesSourceH8 := true
         sourceH8EquivalentToTargetLineUnderBoundaryData := true
         boundaryDataTargetLineEquivalentToLineEqualityContract := true
         boundaryDataTargetLineEquivalentToBoundaryDataSourceH8 := true
         provesBoundaryData := false
         provesTargetLine := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R674BoundaryDataTargetLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R674 ledger. -/
theorem currentR674BoundaryDataTargetLineTargetNames_eq_texStatus :
    currentR674BoundaryDataTargetLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove target_invariants = span {j_q(h^4)}"
    ] := by
  rfl

def R674_substantiveTheoremCount : Nat := 6

end FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
end HCGapL4
end HodgeReduction
