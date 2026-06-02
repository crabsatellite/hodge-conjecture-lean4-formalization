/-
# HC Gap L4 -- Front C166: current route as two compact-dual containments (R731).

R730 rewrites the current residual route as:

* `MatsushimaV56BoundaryData`;
* `h^4 in compactDual`;
* `trivialModulePart <= span {j_q(h^4)}`.

The generator field is exactly `H8 <= compactDual`.  The target line
containment is equivalent, in the presence of boundary data and the generator
field, to the no-extra compact-dual containment `compactDual <= H8`.

This file therefore gives the current route the direct geometric attack
surface:

* `MatsushimaV56BoundaryData`;
* `compactDual <= H8`;
* `H8 <= compactDual`.

It proves equivalence only.  Neither containment, boundary data, nor full Hodge
closure is asserted.
-/

import HodgeReduction.HCGapL4.FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
import HodgeReduction.HCGapL4.FrontC156_H8ResidualCompactDualTwoContainmentRoute
import HodgeReduction.HCGapL4.FrontC165_H8ResidualCurrentCompactDualGeneratorLineRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC166_H8ResidualCurrentCompactDualTwoContainmentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
open FrontC156_H8ResidualCompactDualTwoContainmentRoute
open FrontC164_H8ResidualCurrentGeneratorLineRoute
open FrontC165_H8ResidualCurrentCompactDualGeneratorLineRoute

section CurrentCompactDualTwoContainmentRoute

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

/-- Boundary data plus the two compact-dual H8 containment directions.  R731
proves this is equivalent to the R730 compact-dual generator-line route. -/
structure EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract
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
  compactDual_le_H8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A))
  H8_le_compactDual :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))

/-- **R731 substantive theorem (1/8)**: the target generator-line containment
in R730 supplies the no-extra compact-dual containment. -/
theorem compactDual_le_H8_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A)) := by
  have hsource_le :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)) :=
    source_invariants_le_H8_of_sourceGeneratorLineContract
      (A := A) (B := B)
      (sourceGeneratorLineContract_of_compactDualGeneratorLineContract
        (A := A) (B := B) O)
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]
  exact hsource_le

/-- **R731 substantive theorem (2/8)**: the R730 compact-dual generator field
is exactly the containment `H8 <= compactDual`. -/
theorem H8_le_compactDual_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
  (H8_le_compactDual_iff_h_pow_four_mem_compactDual
    (A := A) (B := B)).2 O.h_pow_four_mem_compactDual

/-- **R731 substantive theorem (3/8)**: the R730 route feeds the direct
boundary-data/two-containment route. -/
def boundaryDataCompactDualTwoContainmentContract_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B where
  boundary := O.boundary
  compactDual_le_H8 :=
    compactDual_le_H8_of_compactDualGeneratorLineContract
      (A := A) (B := B) O
  H8_le_compactDual :=
    H8_le_compactDual_of_compactDualGeneratorLineContract
      (A := A) (B := B) O

/-- **R731 substantive theorem (4/8)**: two compact-dual containments recover
the compact-dual-H8 equality. -/
theorem compactDual_eq_H8_of_boundaryDataCompactDualTwoContainmentContract
    (O : EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_twoContainments
    (A := A) (B := B) O.compactDual_le_H8 O.H8_le_compactDual

/-- **R731 substantive theorem (5/8)**: two compact-dual containments recover
the source-H8 equality needed to rebuild the target generator-line theorem
under boundary data. -/
theorem source_invariants_eq_H8_of_boundaryDataCompactDualTwoContainmentContract
    (O : EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaData.source_invariants (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          (MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)).symm
    _ = CompactDualData.H8 (A := A) :=
          compactDual_eq_H8_of_boundaryDataCompactDualTwoContainmentContract
            (A := A) (B := B) O

/-- **R731 substantive theorem (6/8)**: the direct two-containment route
rebuilds the R730 compact-dual generator-line route. -/
def compactDualGeneratorLineContract_of_boundaryDataCompactDualTwoContainmentContract
    (O : EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B where
  boundary := O.boundary
  h_pow_four_mem_compactDual :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 O.H8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    trivialModulePart_le_h_pow_four_line_of_boundaryData_source_invariants_eq_H8
      (A := A) (B := B) O.boundary
      (source_invariants_eq_H8_of_boundaryDataCompactDualTwoContainmentContract
        (A := A) (B := B) O)

/-- **R731 substantive theorem (7/8)**: the R730 compact-dual generator-line
route and the boundary-data/two-containment route are the same inhabited
residual contract. -/
theorem residual_compactDualGeneratorLine_nonempty_iff_boundaryDataCompactDualTwoContainment_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualTwoContainmentContract_of_compactDualGeneratorLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualGeneratorLineContract_of_boundaryDataCompactDualTwoContainmentContract
            (A := A) (B := B) O)))

/-- **R731 substantive theorem (8/8)**: the current R727--R730 route is
equivalent to boundary data plus the two compact-dual containment targets. -/
theorem residual_currentGeneratorGeometry_nonempty_iff_boundaryDataCompactDualTwoContainment_nonempty :
    Nonempty (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_compactDualGeneratorLine_nonempty
    (A := A) (B := B)).trans
    (residual_compactDualGeneratorLine_nonempty_iff_boundaryDataCompactDualTwoContainment_nonempty
      (A := A) (B := B))

end CurrentCompactDualTwoContainmentRoute

/-- R731 target names for route summaries. -/
def currentR731CurrentCompactDualTwoContainmentTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual <= H8",
  "prove H8 <= compactDual"
]

/-- Machine-readable status for the R731 direct two-containment route. -/
structure R731CurrentCompactDualTwoContainmentSnapshot where
  proofWorkObligationCount : Nat
  currentRouteEquivalentToTwoContainments : Bool
  generatorMembershipEquivalentToH8Containment : Bool
  targetLineEquivalentToCompactDualNoExtraUnderBoundaryAndGenerator : Bool
  twoContainmentsDeriveCompactDualH8 : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualNoExtra : Bool
  provesH8Containment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R731 status: the R730 source/target-line surface has been replaced
by the direct compact-dual two-containment target list. -/
def currentR731CurrentCompactDualTwoContainmentSnapshot :
    R731CurrentCompactDualTwoContainmentSnapshot where
  proofWorkObligationCount :=
    currentR731CurrentCompactDualTwoContainmentTargetNames.length
  currentRouteEquivalentToTwoContainments := true
  generatorMembershipEquivalentToH8Containment := true
  targetLineEquivalentToCompactDualNoExtraUnderBoundaryAndGenerator := true
  twoContainmentsDeriveCompactDualH8 := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualNoExtra := false
  provesH8Containment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R731 direct two-containment route. -/
theorem currentR731CurrentCompactDualTwoContainmentSnapshot_eq_texStatus :
    currentR731CurrentCompactDualTwoContainmentSnapshot =
      ({ proofWorkObligationCount := 3
         currentRouteEquivalentToTwoContainments := true
         generatorMembershipEquivalentToH8Containment := true
         targetLineEquivalentToCompactDualNoExtraUnderBoundaryAndGenerator := true
         twoContainmentsDeriveCompactDualH8 := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualNoExtra := false
         provesH8Containment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R731CurrentCompactDualTwoContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R731 route. -/
theorem currentR731CurrentCompactDualTwoContainmentTargetNames_eq_texStatus :
    currentR731CurrentCompactDualTwoContainmentTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual <= H8",
      "prove H8 <= compactDual"
    ] := by
  rfl

def R731_substantiveTheoremCount : Nat := 8

end FrontC166_H8ResidualCurrentCompactDualTwoContainmentRoute
end HCGapL4
end HodgeReduction
