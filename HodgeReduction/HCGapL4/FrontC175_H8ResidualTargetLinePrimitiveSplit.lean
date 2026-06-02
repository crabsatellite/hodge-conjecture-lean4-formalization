/-
# HC Gap L4 -- Front C175: target-line primitive split (R740).

R739 exposes the latest preferred L4 route as:

* prove `MatsushimaV56BoundaryData`;
* prove `target_invariants = span {j_q(h^4)}`.

This file splits the second target into its two primitive linear-algebra
halves:

* the generator image `j_q(h^4)` lies in `target_invariants`;
* `target_invariants` has no classes outside the `j_q(h^4)` line.

The split is exactly equivalent to the R739 target-line equality.  It does
not prove boundary data, generator membership, no-extra containment, target
line equality, source-H8, quotient vanishing, or full HC closure.
-/

import HodgeReduction.HCGapL4.FrontC174_H8ResidualBoundaryTargetLineCurrentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC175_H8ResidualTargetLinePrimitiveSplit

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
open FrontC174_H8ResidualBoundaryTargetLineCurrentRoute

section TargetLinePrimitiveSplit

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

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R740 substantive theorem (1/6)**: exact target-line equality is
equivalent to generator membership plus no-extra containment.  This is pure
submodule algebra; no source-H8 or boundary-data premise is used.
-/
theorem target_invariants_eq_h_pow_four_line_iff_generator_mem_and_le :
    Iff
      (MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})
      ((MatsushimaData.target_invariants (A := A) (B := B)).carrier
          (MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)) /\
        MatsushimaData.target_invariants (A := A) (B := B) <=
          Submodule.span Rat
            {MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)}) :=
  Iff.intro
    (fun heq => by
      constructor
      case left =>
        rw [heq]
        exact Submodule.subset_span (Set.mem_singleton _)
      case right =>
        rw [heq])
    (fun hpack => by
      cases hpack with
      | intro hmem hle =>
        apply le_antisymm hle
        exact Submodule.span_le.mpr (by
          intro beta hbeta
          have hbeta_eq : beta =
              MatsushimaData.j_q (A := A) (B := B)
                ((KaehlerClass.h : A) ^ 4) :=
            Set.mem_singleton_iff.mp hbeta
          rw [hbeta_eq]
          exact hmem))

/-- Boundary data plus the primitive split of the R739 target-line theorem. -/
structure EVIIH8ResidualBoundaryDataTargetLineSplitContract
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
  h_pow_four_image_mem_target_invariants :
    (MatsushimaData.target_invariants (A := A) (B := B)).carrier
      (MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4))
  target_invariants_le_h_pow_four_line :
    MatsushimaData.target_invariants (A := A) (B := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R740 substantive theorem (2/6)**: the R739 boundary/target-line
contract yields the primitive split. -/
def boundaryDataTargetLineSplitContract_of_boundaryDataTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataTargetLineSplitContract A B where
  boundary := O.boundary
  h_pow_four_image_mem_target_invariants :=
    (target_invariants_eq_h_pow_four_line_iff_generator_mem_and_le
      (A := A) (B := B)).1 O.target_invariants_eq_h_pow_four_line |>.1
  target_invariants_le_h_pow_four_line :=
    (target_invariants_eq_h_pow_four_line_iff_generator_mem_and_le
      (A := A) (B := B)).1 O.target_invariants_eq_h_pow_four_line |>.2

/-- **R740 substantive theorem (3/6)**: the primitive split recovers the R739
boundary/target-line contract, so this is not a stronger premise.
-/
def boundaryDataTargetLineContract_of_boundaryDataTargetLineSplitContract
    (O : EVIIH8ResidualBoundaryDataTargetLineSplitContract A B) :
    EVIIH8ResidualBoundaryDataTargetLineContract A B where
  boundary := O.boundary
  target_invariants_eq_h_pow_four_line :=
    (target_invariants_eq_h_pow_four_line_iff_generator_mem_and_le
      (A := A) (B := B)).2
      (And.intro
        O.h_pow_four_image_mem_target_invariants
        O.target_invariants_le_h_pow_four_line)

/-- **R740 substantive theorem (4/6)**: R739 boundary/target-line contracts
and the primitive split contracts are equivalent inhabited residuals.
-/
theorem residual_boundaryDataTargetLine_nonempty_iff_boundaryDataTargetLineSplit_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineSplitContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataTargetLineSplitContract_of_boundaryDataTargetLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataTargetLineContract_of_boundaryDataTargetLineSplitContract
            (A := A) (B := B) O)))

/-- **R740 substantive theorem (5/6)**: the R738 source-H8 quotient contract
is equivalently boundary data plus the primitive target-line split.
-/
theorem residual_sourceH8Quotient_nonempty_iff_boundaryDataTargetLineSplit_nonempty :
    Nonempty
        (FrontC172_H8ResidualSourceH8QuotientMinimalRoute.EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineSplitContract A B) :=
  (residual_sourceH8Quotient_nonempty_iff_boundaryDataTargetLine_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataTargetLine_nonempty_iff_boundaryDataTargetLineSplit_nonempty
      (A := A) (B := B))

/-- **R740 substantive theorem (6/6)**: the current generator-geometry route is
equivalently boundary data plus the primitive target-line split.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_boundaryDataTargetLineSplit_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineSplitContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataTargetLine_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataTargetLine_nonempty_iff_boundaryDataTargetLineSplit_nonempty
      (A := A) (B := B))

end TargetLinePrimitiveSplit

/-- R740 target names for route summaries. -/
def currentR740TargetLinePrimitiveSplitTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove j_q(h^4) in target_invariants",
  "prove target_invariants <= span {j_q(h^4)}; together these are exactly the target-line equality"
]

/-- Machine-readable status for the R740 target-line split. -/
structure R740TargetLinePrimitiveSplitSnapshot where
  proofWorkObligationCount : Nat
  targetLineEquivalentToGeneratorAndNoExtra : Bool
  boundaryTargetLineEquivalentToPrimitiveSplit : Bool
  sourceH8QuotientEquivalentToPrimitiveSplit : Bool
  currentRouteEquivalentToPrimitiveSplit : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesGeneratorMembership : Bool
  provesNoExtraContainment : Bool
  provesTargetLine : Bool
  provesSourceH8 : Bool
  provesUnconditionalQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R740 status: the target-line equality is split into exact
generator-membership and no-extra-containment targets.  Neither half is
proved here.
-/
def currentR740TargetLinePrimitiveSplitSnapshot :
    R740TargetLinePrimitiveSplitSnapshot where
  proofWorkObligationCount := currentR740TargetLinePrimitiveSplitTargetNames.length
  targetLineEquivalentToGeneratorAndNoExtra := true
  boundaryTargetLineEquivalentToPrimitiveSplit := true
  sourceH8QuotientEquivalentToPrimitiveSplit := true
  currentRouteEquivalentToPrimitiveSplit := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesGeneratorMembership := false
  provesNoExtraContainment := false
  provesTargetLine := false
  provesSourceH8 := false
  provesUnconditionalQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R740 primitive split route. -/
theorem currentR740TargetLinePrimitiveSplitSnapshot_eq_texStatus :
    currentR740TargetLinePrimitiveSplitSnapshot =
      ({ proofWorkObligationCount := 3
         targetLineEquivalentToGeneratorAndNoExtra := true
         boundaryTargetLineEquivalentToPrimitiveSplit := true
         sourceH8QuotientEquivalentToPrimitiveSplit := true
         currentRouteEquivalentToPrimitiveSplit := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesGeneratorMembership := false
         provesNoExtraContainment := false
         provesTargetLine := false
         provesSourceH8 := false
         provesUnconditionalQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R740TargetLinePrimitiveSplitSnapshot) := by
  decide

/-- Kernel-checked target names for the R740 route. -/
theorem currentR740TargetLinePrimitiveSplitTargetNames_eq_texStatus :
    currentR740TargetLinePrimitiveSplitTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove j_q(h^4) in target_invariants",
      "prove target_invariants <= span {j_q(h^4)}; together these are exactly the target-line equality"
    ] := by
  rfl

def R740_substantiveTheoremCount : Nat := 6

end FrontC175_H8ResidualTargetLinePrimitiveSplit
end HCGapL4
end HodgeReduction
