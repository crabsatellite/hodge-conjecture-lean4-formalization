/-
# HC Gap L4 -- Front C176: target generator via boundary transport (R741).

R740 split the target-line equality into:

* `j_q(h^4) in target_invariants`;
* `target_invariants <= span {j_q(h^4)}`.

The first half is not intrinsically target-side once honest
`MatsushimaV56BoundaryData` is available.  Boundary data identifies the
Matsushima surjectivity image with `target_invariants`, and injectivity of
`j_q` transports the generator membership back to the compact-dual/source
side.  Thus the first half is exactly:

* `h^4 in compactDual`, equivalently `H8 <= compactDual`.

The no-extra target containment remains open.  This file only rewrites the
route; it does not prove boundary data, H8 containment, no-extra containment,
target-line equality, source-H8, quotient vanishing, or full HC closure.
-/

import HodgeReduction.HCGapL4.FrontC175_H8ResidualTargetLinePrimitiveSplit
import HodgeReduction.HCGapL4.FrontC155_H8ResidualCompactDualGeneratorContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC176_H8ResidualTargetGeneratorBoundaryTransport

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
open FrontC175_H8ResidualTargetLinePrimitiveSplit

section TargetGeneratorBoundaryTransport

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
/-- **R741 substantive theorem (1/7)**: under honest boundary data, the R740
target generator-membership half is exactly compact-dual generator membership.
The reverse direction uses `surjectivity_eq` and `j_q_injective`; no new
premise is added.
-/
theorem h_pow_four_mem_compactDual_iff_targetGenerator_mem_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    Iff
      ((MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
      ((MatsushimaData.target_invariants (A := A) (B := B)).carrier
        (MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4))) :=
  Iff.intro
    (fun hcompact => by
      have hsource_surj :
          (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)).carrier
            ((KaehlerClass.h : A) ^ 4) := by
        rw [D.source_eq_compactDual]
        exact hcompact
      have hmap :
          (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))).carrier
            (MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)) := by
        exact Submodule.mem_map_of_mem hsource_surj
      have htarget_surj :
          (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)).carrier
            (MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)) := by
        rw [<- MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)]
        exact hmap
      rw [<- D.target_eq_invariants]
      exact htarget_surj)
    (fun htarget => by
      have htarget_surj :
          (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)).carrier
            (MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)) := by
        rw [D.target_eq_invariants]
        exact htarget
      have hmap :
          (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))).carrier
            (MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)) := by
        rw [MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)]
        exact htarget_surj
      cases Submodule.mem_map.mp hmap with
      | intro alpha hrest =>
        cases hrest with
        | intro halpha_source halpha_image =>
          have halpha_eq : alpha = ((KaehlerClass.h : A) ^ 4) :=
            MatsushimaData.j_q_injective (A := A) (B := B) halpha_image
          have halpha_compact :
              (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier alpha := by
            rw [<- D.source_eq_compactDual]
            exact halpha_source
          simpa [halpha_eq] using halpha_compact)

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R741 substantive theorem (2/7)**: the same boundary-data transport can
be stated against the source-invariant carrier because compactDual and
source_invariants are already identified in the Matsushima infrastructure.
-/
theorem h_pow_four_mem_source_invariants_iff_targetGenerator_mem_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    Iff
      ((MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
      ((MatsushimaData.target_invariants (A := A) (B := B)).carrier
        (MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4))) :=
  Iff.intro
    (fun hsource => by
      apply (h_pow_four_mem_compactDual_iff_targetGenerator_mem_of_boundaryData
        (A := A) (B := B) D).1
      rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B)]
      exact hsource)
    (fun htarget => by
      have hcompact :
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
            ((KaehlerClass.h : A) ^ 4) :=
        (h_pow_four_mem_compactDual_iff_targetGenerator_mem_of_boundaryData
          (A := A) (B := B) D).2 htarget
      rw [<- MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B)]
      exact hcompact)

/-- Boundary data, compact-dual H8 containment, and the no-extra target
containment.  R741 proves this is exactly the R740 primitive split route.
-/
structure EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract
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
  H8_le_compactDual :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  target_invariants_le_h_pow_four_line :
    MatsushimaData.target_invariants (A := A) (B := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R741 substantive theorem (3/7)**: the R740 primitive split yields the
boundary/H8-containment/no-extra target route.
-/
def H8ContainmentTargetInvariantLineContract_of_boundaryDataTargetLineSplitContract
    (O : EVIIH8ResidualBoundaryDataTargetLineSplitContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B where
  boundary := O.boundary
  H8_le_compactDual :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).2
      ((h_pow_four_mem_compactDual_iff_targetGenerator_mem_of_boundaryData
        (A := A) (B := B) O.boundary).2
        O.h_pow_four_image_mem_target_invariants)
  target_invariants_le_h_pow_four_line :=
    O.target_invariants_le_h_pow_four_line

/-- **R741 substantive theorem (4/7)**: conversely, H8 containment under
boundary data recovers the R740 target generator-membership half.
-/
def boundaryDataTargetLineSplitContract_of_H8ContainmentTargetInvariantLineContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B) :
    EVIIH8ResidualBoundaryDataTargetLineSplitContract A B where
  boundary := O.boundary
  h_pow_four_image_mem_target_invariants :=
    (h_pow_four_mem_compactDual_iff_targetGenerator_mem_of_boundaryData
      (A := A) (B := B) O.boundary).1
      ((H8_le_compactDual_iff_h_pow_four_mem_compactDual
        (A := A) (B := B)).1 O.H8_le_compactDual)
  target_invariants_le_h_pow_four_line :=
    O.target_invariants_le_h_pow_four_line

/-- **R741 substantive theorem (5/7)**: R740 primitive split contracts are
equivalent to boundary data plus H8 containment plus no-extra target
containment.
-/
theorem residual_boundaryDataTargetLineSplit_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataTargetLineSplitContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentTargetInvariantLineContract_of_boundaryDataTargetLineSplitContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataTargetLineSplitContract_of_H8ContainmentTargetInvariantLineContract
            (A := A) (B := B) O)))

/-- **R741 substantive theorem (6/7)**: the R738 source-H8 quotient route is
equivalently boundary data, compact-dual H8 containment, and no-extra target
containment.
-/
theorem residual_sourceH8Quotient_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty :
    Nonempty
        (FrontC172_H8ResidualSourceH8QuotientMinimalRoute.EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B) :=
  (residual_sourceH8Quotient_nonempty_iff_boundaryDataTargetLineSplit_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataTargetLineSplit_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty
      (A := A) (B := B))

/-- **R741 substantive theorem (7/7)**: the current generator-geometry route
is equivalently boundary data, compact-dual H8 containment, and no-extra
target containment.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataTargetLineSplit_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataTargetLineSplit_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty
      (A := A) (B := B))

end TargetGeneratorBoundaryTransport

/-- R741 target names for route summaries. -/
def currentR741H8ContainmentTargetInvariantLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual; under boundary data this is exactly j_q(h^4) in target_invariants",
  "prove target_invariants <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R741 target-generator transport. -/
structure R741H8ContainmentTargetInvariantLineSnapshot where
  proofWorkObligationCount : Nat
  boundaryTransportsTargetGeneratorToCompactDualGenerator : Bool
  boundaryTransportsTargetGeneratorToSourceGenerator : Bool
  H8ContainmentEquivalentToTargetGeneratorUnderBoundary : Bool
  primitiveSplitEquivalentToH8ContainmentRoute : Bool
  currentRouteEquivalentToH8ContainmentRoute : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesNoExtraTargetContainment : Bool
  provesTargetLine : Bool
  provesSourceH8 : Bool
  provesUnconditionalQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R741 status: the target generator-membership half has been
transported to compact-dual H8 containment under boundary data; all proof-work
targets remain open.
-/
def currentR741H8ContainmentTargetInvariantLineSnapshot :
    R741H8ContainmentTargetInvariantLineSnapshot where
  proofWorkObligationCount := currentR741H8ContainmentTargetInvariantLineTargetNames.length
  boundaryTransportsTargetGeneratorToCompactDualGenerator := true
  boundaryTransportsTargetGeneratorToSourceGenerator := true
  H8ContainmentEquivalentToTargetGeneratorUnderBoundary := true
  primitiveSplitEquivalentToH8ContainmentRoute := true
  currentRouteEquivalentToH8ContainmentRoute := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesNoExtraTargetContainment := false
  provesTargetLine := false
  provesSourceH8 := false
  provesUnconditionalQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R741 route. -/
theorem currentR741H8ContainmentTargetInvariantLineSnapshot_eq_texStatus :
    currentR741H8ContainmentTargetInvariantLineSnapshot =
      ({ proofWorkObligationCount := 3
         boundaryTransportsTargetGeneratorToCompactDualGenerator := true
         boundaryTransportsTargetGeneratorToSourceGenerator := true
         H8ContainmentEquivalentToTargetGeneratorUnderBoundary := true
         primitiveSplitEquivalentToH8ContainmentRoute := true
         currentRouteEquivalentToH8ContainmentRoute := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesNoExtraTargetContainment := false
         provesTargetLine := false
         provesSourceH8 := false
         provesUnconditionalQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R741H8ContainmentTargetInvariantLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R741 route. -/
theorem currentR741H8ContainmentTargetInvariantLineTargetNames_eq_texStatus :
    currentR741H8ContainmentTargetInvariantLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual; under boundary data this is exactly j_q(h^4) in target_invariants",
      "prove target_invariants <= span {j_q(h^4)}"
    ] := by
  rfl

def R741_substantiveTheoremCount : Nat := 7

end FrontC176_H8ResidualTargetGeneratorBoundaryTransport
end HCGapL4
end HodgeReduction
