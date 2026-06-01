/-
# HC Gap L4 -- Front C130: boundary data plus source-H8 route (R694).

R693 shows that `surjectivity_source = H8` cannot by itself consume the
generator-membership target.  This file records the positive companion:
once honest `MatsushimaV56BoundaryData` is also available, source-H8 is enough
to recover both remaining R692 generator-line fields:

* `h^4 in source_invariants`;
* `trivialModulePart <= span {j_q(h^4)}`.

The reason is structural, not a new assumption.  Boundary data identifies the
surjectivity source with `compactDual`; the compact-dual interface identifies
that carrier with `source_invariants`; and the boundary target equality plus
the existing target-invariants/trivial-module bridge turns source-H8 into the
target generator-line containment.
-/

import HodgeReduction.HCGapL4.FrontC129_H8ResidualSourceH8GeneratorIndependence
import HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality
import HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC60_H8ResidualSourceCarrierSplitPackage
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC128_H8ResidualSourceH8LineContainmentRoute

section BoundaryDataSourceSurjectivity

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

/-- **R694 substantive theorem (1/6)**: under boundary data, concrete
source-H8 surjectivity identifies the actual source invariants with H8. -/
theorem source_invariants_eq_H8_of_boundaryData_surjectivity_source_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaData.source_invariants (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        (MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)).symm
    _ = MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) :=
        D.source_eq_compactDual.symm
    _ = CompactDualData.H8 (A := A) := hsource_H8

/-- **R694 substantive theorem (2/6)**: with boundary data fixed, source-H8
surjectivity and source-invariants/H8 are equivalent spellings of the same
carrier target. -/
theorem surjectivity_source_eq_H8_iff_source_invariants_eq_H8_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A)) <->
      (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :=
  Iff.intro
    (fun hsource_H8 =>
      source_invariants_eq_H8_of_boundaryData_surjectivity_source_eq_H8
        (A := A) (B := B) D hsource_H8)
    (fun hsource_invariants_H8 =>
      calc
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
            = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
            D.source_eq_compactDual
        _ = MatsushimaData.source_invariants (A := A) (B := B) :=
            MatsushimaCompactDualData.compactDual_eq_source_invariants
              (A := A) (B := B)
        _ = CompactDualData.H8 (A := A) := hsource_invariants_H8)

/-- **R694 substantive theorem (3/6)**: boundary data plus source-H8 supplies
the R692 generator membership field. -/
theorem h_pow_four_mem_source_invariants_of_boundaryData_surjectivity_source_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
    (A := A) (B := B)
    (source_invariants_eq_H8_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) D hsource_H8)

/-- **R694 substantive theorem (4/6)**: boundary data plus source-H8 also
supplies the R692 target generator-line containment field. -/
theorem trivialModulePart_le_h_pow_four_line_of_boundaryData_surjectivity_source_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  have hsource_invariants_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    source_invariants_eq_H8_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) D hsource_H8
  have htarget_line :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
      (A := A) (B := B) D hsource_invariants_H8
  have htrivial_line :
      CuspidalCohomologyData.trivialModulePart (A := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} := by
    calc
      CuspidalCohomologyData.trivialModulePart (A := B)
          = MatsushimaData.target_invariants (A := A) (B := B) :=
          (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm
      _ =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} := htarget_line
  rw [htrivial_line]

/-- Boundary data plus concrete source-H8 surjectivity.  R694 proves that this
two-field route feeds the R692 source-H8 line-containment contract; neither
field is proved here. -/
structure EVIIH8ResidualBoundaryDataSourceSurjectivityContract
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
  surjectivity_source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A)

/-- **R694 substantive theorem (5/6)**: boundary data plus source-H8 rebuilds
the full R692 source-H8 line-containment contract, deriving the generator
membership and line-containment fields rather than assuming them. -/
def sourceH8LineContainmentContract_of_boundaryDataSourceSurjectivityContract
    (O : EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) :
    EVIIH8ResidualSourceH8LineContainmentContract A B where
  surjectivity_source_eq_H8 := O.surjectivity_source_eq_H8
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) O.boundary O.surjectivity_source_eq_H8
  trivialModulePart_le_h_pow_four_line :=
    trivialModulePart_le_h_pow_four_line_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) O.boundary O.surjectivity_source_eq_H8

/-- **R694 substantive theorem (6/6)**: inhabited boundary-data/source-H8
contracts feed inhabited R692 source-H8 line-containment contracts. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_to_sourceH8LineContainment_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) ->
      Nonempty (EVIIH8ResidualSourceH8LineContainmentContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (sourceH8LineContainmentContract_of_boundaryDataSourceSurjectivityContract
      (A := A) (B := B) O)

end BoundaryDataSourceSurjectivity

/-- R694 target names for route summaries. -/
def currentR694BoundaryDataSourceSurjectivityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove surjectivity_source = H8"
]

/-- Machine-readable status for the R694 boundary-data/source-H8 route. -/
structure R694BoundaryDataSourceSurjectivitySnapshot where
  proofWorkObligationCount : Nat
  sourceH8EquivalentToSourceInvariantH8UnderBoundaryData : Bool
  boundarySourceH8DerivesGeneratorMembership : Bool
  boundarySourceH8DerivesLineContainment : Bool
  boundarySourceH8FeedsR692 : Bool
  provesBoundaryData : Bool
  provesSourceSurjectivityH8 : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R694 status: boundary data plus source-H8 consumes the two R692
generator-line fields, reducing that route to two geometric targets. -/
def currentR694BoundaryDataSourceSurjectivitySnapshot :
    R694BoundaryDataSourceSurjectivitySnapshot where
  proofWorkObligationCount :=
    currentR694BoundaryDataSourceSurjectivityTargetNames.length
  sourceH8EquivalentToSourceInvariantH8UnderBoundaryData := true
  boundarySourceH8DerivesGeneratorMembership := true
  boundarySourceH8DerivesLineContainment := true
  boundarySourceH8FeedsR692 := true
  provesBoundaryData := false
  provesSourceSurjectivityH8 := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R694 route ledger. -/
theorem currentR694BoundaryDataSourceSurjectivitySnapshot_eq_texStatus :
    currentR694BoundaryDataSourceSurjectivitySnapshot =
      ({ proofWorkObligationCount := 2
         sourceH8EquivalentToSourceInvariantH8UnderBoundaryData := true
         boundarySourceH8DerivesGeneratorMembership := true
         boundarySourceH8DerivesLineContainment := true
         boundarySourceH8FeedsR692 := true
         provesBoundaryData := false
         provesSourceSurjectivityH8 := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R694BoundaryDataSourceSurjectivitySnapshot) := by
  decide

/-- Kernel-checked target names for the R694 route. -/
theorem currentR694BoundaryDataSourceSurjectivityTargetNames_eq_texStatus :
    currentR694BoundaryDataSourceSurjectivityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove surjectivity_source = H8"
    ] := by
  rfl

def R694_substantiveTheoremCount : Nat := 6

end FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
end HCGapL4
end HodgeReduction
