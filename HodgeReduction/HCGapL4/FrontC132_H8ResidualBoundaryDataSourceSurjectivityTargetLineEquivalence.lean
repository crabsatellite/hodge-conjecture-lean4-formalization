/-
# HC Gap L4 -- Front C132: source-surjectivity/target-line equivalence (R696).

R694 changed the preferred boundary route to two targets:

  `MatsushimaV56BoundaryData` + `surjectivity_source = H8`.

R674 had already shown that, once boundary data is fixed, the target-line
equality is equivalent to `source_invariants = H8`.  This file closes the
remaining notation gap: in the same boundary-data context, the concrete
source-surjectivity statement `surjectivity_source = H8` is equivalent to the
target-line equality

  `target_invariants = span {j_q(h^4)}`.

This is not a closure claim.  It records that future work may attack either
the source-H8 spelling or the target-line spelling, but they are not two
independent proof obligations once boundary data is present.
-/

import HodgeReduction.HCGapL4.FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
import HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC132_H8ResidualBoundaryDataSourceSurjectivityTargetLineEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute

section BoundaryDataSourceSurjectivityTargetLine

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

/-- **R696 substantive theorem (1/6)**: under boundary data, concrete
source-H8 surjectivity gives the target-line equality. -/
theorem targetLine_of_boundaryData_surjectivity_source_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} :=
  target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
    (A := A) (B := B) D
    (source_invariants_eq_H8_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) D hsource_H8)

/-- **R696 substantive theorem (2/6)**: under boundary data, target-line
equality recovers concrete source-H8 surjectivity. -/
theorem surjectivity_source_eq_H8_of_boundaryData_targetLine
    (D : MatsushimaV56BoundaryData A B)
    (hline :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (surjectivity_source_eq_H8_iff_source_invariants_eq_H8_of_boundaryData
    (A := A) (B := B) D).2
    (source_invariants_eq_H8_of_boundaryData_targetLine
      (A := A) (B := B) D hline)

/-- **R696 substantive theorem (3/6)**: source-surjectivity boundary contracts
produce boundary-data/target-line contracts. -/
def boundaryDataTargetLineContract_of_boundaryDataSourceSurjectivityContract
    (O : EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) :
    EVIIH8ResidualBoundaryDataTargetLineContract A B where
  boundary := O.boundary
  target_invariants_eq_h_pow_four_line :=
    targetLine_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) O.boundary O.surjectivity_source_eq_H8

/-- **R696 substantive theorem (4/6)**: boundary-data/target-line contracts
produce source-surjectivity boundary contracts. -/
def boundaryDataSourceSurjectivityContract_of_boundaryDataTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B where
  boundary := O.boundary
  surjectivity_source_eq_H8 :=
    surjectivity_source_eq_H8_of_boundaryData_targetLine
      (A := A) (B := B) O.boundary O.target_invariants_eq_h_pow_four_line

/-- **R696 substantive theorem (5/6)**: the R694 source-surjectivity route
and the R674 target-line route are equivalent inhabited contracts. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataTargetLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataTargetLineContract_of_boundaryDataSourceSurjectivityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceSurjectivityContract_of_boundaryDataTargetLineContract
            (A := A) (B := B) O)))

/-- **R696 substantive theorem (6/6)**: the source-surjectivity route is also
equivalent to the older boundary-data/source-invariants-H8 route. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataSourceH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataTargetLine_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataTargetLine_nonempty_iff_boundaryDataSourceH8_nonempty
      (A := A) (B := B))

end BoundaryDataSourceSurjectivityTargetLine

/-- R696 target names for route summaries. -/
def currentR696BoundaryDataSourceSurjectivityTargetLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove either surjectivity_source = H8 or target_invariants = span {j_q(h^4)}"
]

/-- Machine-readable status for the R696 route equivalence. -/
structure R696BoundaryDataSourceSurjectivityTargetLineSnapshot where
  proofWorkObligationCount : Nat
  sourceSurjectivityImpliesTargetLineUnderBoundaryData : Bool
  targetLineImpliesSourceSurjectivityUnderBoundaryData : Bool
  sourceSurjectivityRouteEquivalentToTargetLineRoute : Bool
  sourceSurjectivityRouteEquivalentToSourceInvariantRoute : Bool
  provesBoundaryData : Bool
  provesSourceSurjectivityH8 : Bool
  provesTargetLine : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R696 status: the non-boundary target can be attacked through
either source-H8 surjectivity or the target-line theorem, but not counted
twice. -/
def currentR696BoundaryDataSourceSurjectivityTargetLineSnapshot :
    R696BoundaryDataSourceSurjectivityTargetLineSnapshot where
  proofWorkObligationCount :=
    currentR696BoundaryDataSourceSurjectivityTargetLineTargetNames.length
  sourceSurjectivityImpliesTargetLineUnderBoundaryData := true
  targetLineImpliesSourceSurjectivityUnderBoundaryData := true
  sourceSurjectivityRouteEquivalentToTargetLineRoute := true
  sourceSurjectivityRouteEquivalentToSourceInvariantRoute := true
  provesBoundaryData := false
  provesSourceSurjectivityH8 := false
  provesTargetLine := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R696 route ledger. -/
theorem currentR696BoundaryDataSourceSurjectivityTargetLineSnapshot_eq_texStatus :
    currentR696BoundaryDataSourceSurjectivityTargetLineSnapshot =
      ({ proofWorkObligationCount := 2
         sourceSurjectivityImpliesTargetLineUnderBoundaryData := true
         targetLineImpliesSourceSurjectivityUnderBoundaryData := true
         sourceSurjectivityRouteEquivalentToTargetLineRoute := true
         sourceSurjectivityRouteEquivalentToSourceInvariantRoute := true
         provesBoundaryData := false
         provesSourceSurjectivityH8 := false
         provesTargetLine := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R696BoundaryDataSourceSurjectivityTargetLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R696 route. -/
theorem currentR696BoundaryDataSourceSurjectivityTargetLineTargetNames_eq_texStatus :
    currentR696BoundaryDataSourceSurjectivityTargetLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove either surjectivity_source = H8 or target_invariants = span {j_q(h^4)}"
    ] := by
  rfl

def R696_substantiveTheoremCount : Nat := 6

end FrontC132_H8ResidualBoundaryDataSourceSurjectivityTargetLineEquivalence
end HCGapL4
end HodgeReduction
