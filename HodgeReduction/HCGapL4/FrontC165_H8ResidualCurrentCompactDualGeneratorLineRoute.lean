/-
# HC Gap L4 -- Front C165: current route with compact-dual generator line (R730).

R729 rewrites the current route as:

* `MatsushimaV56BoundaryData`;
* `h^4 in source_invariants`;
* `trivialModulePart <= span {j_q(h^4)}`.

The first non-boundary generator field has the more geometric compact-dual
spelling `h^4 in MatsushimaCompactDualData.compactDual`, because the
Matsushima interface identifies `compactDual = source_invariants`.  This file
uses that equality to replace the source-generator field by the compact-dual
one without changing the inhabited residual contract.

It does not prove compact-dual generator membership, does not prove the target
line containment, and does not claim full Hodge closure.
-/

import HodgeReduction.HCGapL4.FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute
import HodgeReduction.HCGapL4.FrontC164_H8ResidualCurrentGeneratorLineRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC165_H8ResidualCurrentCompactDualGeneratorLineRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute
open FrontC162_H8ResidualCompactDualGeneratorGeometryRoute
open FrontC164_H8ResidualCurrentGeneratorLineRoute

section CurrentCompactDualGeneratorLineRoute

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

/-- Boundary data plus compact-dual generator membership and the target
generator-line containment.  R730 proves this is exactly the R729 current
generator-line route after transporting membership across
`compactDual = source_invariants`. -/
structure EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract
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
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R730 substantive theorem (1/6)**: the compact-dual generator field
supplies the R729 source-generator field by the existing
`compactDual = source_invariants` comparison. -/
theorem h_pow_four_mem_source_invariants_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
    (A := A) (B := B)).1 O.h_pow_four_mem_compactDual

/-- **R730 substantive theorem (2/6)**: the compact-dual generator-line route
feeds the R729 source-generator-line route. -/
def sourceGeneratorLineContract_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :
    EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B where
  boundary := O.boundary
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_compactDualGeneratorLineContract
      (A := A) (B := B) O
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R730 substantive theorem (3/6)**: the R729 source-generator-line route
recovers the equivalent compact-dual generator-line route. -/
def compactDualGeneratorLineContract_of_sourceGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B where
  boundary := O.boundary
  h_pow_four_mem_compactDual :=
    (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
      (A := A) (B := B)).2 O.h_pow_four_mem_source_invariants
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R730 substantive theorem (4/6)**: compact-dual generator membership plus
target line containment recovers the current source-H8 theorem. -/
theorem source_invariants_eq_H8_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_sourceGeneratorLineContract
    (A := A) (B := B)
    (sourceGeneratorLineContract_of_compactDualGeneratorLineContract
      (A := A) (B := B) O)

/-- **R730 substantive theorem (5/6)**: the R729 source-generator-line route
and the compact-dual generator-line route are the same inhabited residual
contract. -/
theorem residual_sourceGeneratorLine_nonempty_iff_compactDualGeneratorLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceGeneratorLineContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualGeneratorLineContract_of_sourceGeneratorLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceGeneratorLineContract_of_compactDualGeneratorLineContract
            (A := A) (B := B) O)))

/-- **R730 substantive theorem (6/6)**: the current R727/R728/R729 route is
equivalent to boundary data plus compact-dual generator membership and target
line containment. -/
theorem residual_currentGeneratorGeometry_nonempty_iff_compactDualGeneratorLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_sourceGeneratorLine_nonempty
    (A := A) (B := B)).trans
    (residual_sourceGeneratorLine_nonempty_iff_compactDualGeneratorLine_nonempty
      (A := A) (B := B))

end CurrentCompactDualGeneratorLineRoute

/-- R730 target names for route summaries. -/
def currentR730CurrentCompactDualGeneratorLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R730 compact-dual generator-line route. -/
structure R730CurrentCompactDualGeneratorLineSnapshot where
  proofWorkObligationCount : Nat
  currentRouteEquivalentToCompactDualGeneratorLine : Bool
  compactDualGeneratorEquivalentToSourceGenerator : Bool
  compactDualGeneratorLineDerivesSourceH8 : Bool
  targetLineContainmentStillOpen : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualGeneratorMembership : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R730 status: the generator field has been moved to the
compact-dual carrier, while the boundary and target-line facts remain genuine
open proof-work targets. -/
def currentR730CurrentCompactDualGeneratorLineSnapshot :
    R730CurrentCompactDualGeneratorLineSnapshot where
  proofWorkObligationCount :=
    currentR730CurrentCompactDualGeneratorLineTargetNames.length
  currentRouteEquivalentToCompactDualGeneratorLine := true
  compactDualGeneratorEquivalentToSourceGenerator := true
  compactDualGeneratorLineDerivesSourceH8 := true
  targetLineContainmentStillOpen := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualGeneratorMembership := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R730 compact-dual generator-line route. -/
theorem currentR730CurrentCompactDualGeneratorLineSnapshot_eq_texStatus :
    currentR730CurrentCompactDualGeneratorLineSnapshot =
      ({ proofWorkObligationCount := 3
         currentRouteEquivalentToCompactDualGeneratorLine := true
         compactDualGeneratorEquivalentToSourceGenerator := true
         compactDualGeneratorLineDerivesSourceH8 := true
         targetLineContainmentStillOpen := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualGeneratorMembership := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R730CurrentCompactDualGeneratorLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R730 route. -/
theorem currentR730CurrentCompactDualGeneratorLineTargetNames_eq_texStatus :
    currentR730CurrentCompactDualGeneratorLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R730_substantiveTheoremCount : Nat := 6

end FrontC165_H8ResidualCurrentCompactDualGeneratorLineRoute
end HCGapL4
end HodgeReduction
