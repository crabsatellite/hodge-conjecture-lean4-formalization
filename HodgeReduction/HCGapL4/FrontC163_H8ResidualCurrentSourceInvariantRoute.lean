/-
# HC Gap L4 -- Front C163: current route as source-invariants H8 (R728).

R727 selected the generator side of the current Cartan comparison and proved
that the `CartanH8 <= compactDual` direction is exactly the concrete theorem
`h^4 in compactDual`.  The remaining R727 route is:

* `MatsushimaV56BoundaryData`;
* `compactDual <= CartanH8`;
* the generator witness `h^4 in compactDual`.

This file reconnects that current route to the older source-invariant carrier
spelling:

  `MatsushimaData.source_invariants = CompactDualData.H8`.

The result is not a closure claim and not a stronger premise: the R727
generator-geometry contract and the boundary-data/source-H8 contract are
proved equivalent at the inhabited-contract level.  The next positive attack
can therefore target the single source-invariant H8 theorem, or prove its two
containment directions.
-/

import HodgeReduction.HCGapL4.FrontC162_H8ResidualCompactDualGeneratorGeometryRoute
import HodgeReduction.HCGapL4.FrontC121_H8ResidualBoundaryDataSourceInvariantRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC163_H8ResidualCurrentSourceInvariantRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC121_H8ResidualBoundaryDataSourceInvariantRoute
open FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence
open FrontC162_H8ResidualCompactDualGeneratorGeometryRoute

section CurrentSourceInvariantRoute

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

/-- **R728 substantive theorem (1/5)**: the current R727
no-extra-plus-generator-geometry contract supplies the boundary-data/source-H8
contract. -/
def boundaryDataSourceH8Contract_of_currentGeneratorGeometryContract
    (O : EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B :=
  boundaryDataSourceH8Contract_of_boundaryDataCartanContract
    (A := A) (B := B)
    (currentBoundaryDataCartanContract_of_cartanTwoContainmentContract
      (A := A) (B := B)
      (cartanTwoContainmentContract_of_generatorGeometryContract
        (A := A) (B := B) O))

/-- **R728 substantive theorem (2/5)**: the boundary-data/source-H8 contract
rebuilds the current R727 no-extra-plus-generator-geometry contract, so the
source-invariant route is not a stronger premise. -/
def currentGeneratorGeometryContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B :=
  generatorGeometryContract_of_cartanTwoContainmentContract
    (A := A) (B := B)
    (cartanTwoContainmentContract_of_currentBoundaryDataCartanContract
      (A := A) (B := B)
      (boundaryDataCartanContract_of_boundaryDataSourceH8Contract
        (A := A) (B := B) O))

/-- **R728 substantive theorem (3/5)**: the R727 current generator-geometry
route and the boundary-data/source-H8 route are the same inhabited residual
contract. -/
theorem residual_currentGeneratorGeometry_nonempty_iff_boundaryDataSourceH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceH8Contract_of_currentGeneratorGeometryContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (currentGeneratorGeometryContract_of_boundaryDataSourceH8Contract
            (A := A) (B := B) O)))

/-- **R728 substantive theorem (4/5)**: source-H8 immediately supplies the
R727 generator geometry component of the current route. -/
def generatorGeometry_of_source_invariants_eq_H8
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    EVIICompactDualGeneratorGeometry A B :=
  generatorGeometry_of_cartanH8_le_compactDual
    (A := A) (B := B)
    (by
      rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
        (A := A)]
      rw [<- hsource]
      exact MatsushimaCompactDualData.source_invariants_le_compactDual
        (A := A) (B := B))

/-- **R728 substantive theorem (5/5)**: the source-H8 equality directly gives
the R727 Cartan-to-compactDual generator containment. -/
theorem cartanH8_le_compactDual_of_source_invariants_eq_H8
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    CartanCompactDualIso.trivialModuleGK_H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  cartanH8_le_compactDual_of_generatorGeometry
    (A := A) (B := B)
    (generatorGeometry_of_source_invariants_eq_H8
      (A := A) (B := B) hsource)

end CurrentSourceInvariantRoute

/-- R728 target names for route summaries. -/
def currentR728CurrentSourceInvariantTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8"
]

/-- Machine-readable status for the R728 current source-invariant route. -/
structure R728CurrentSourceInvariantSnapshot where
  proofWorkObligationCount : Nat
  generatorGeometryRouteEquivalentToSourceH8 : Bool
  sourceH8SuppliesGeneratorGeometry : Bool
  sourceH8SuppliesCartanToCompactDual : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesSourceInvariantH8 : Bool
  provesFullCartanComparison : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R728 status: the active R727 route can be attacked as boundary
data plus the single source-invariants/H8 carrier theorem. -/
def currentR728CurrentSourceInvariantSnapshot :
    R728CurrentSourceInvariantSnapshot where
  proofWorkObligationCount := currentR728CurrentSourceInvariantTargetNames.length
  generatorGeometryRouteEquivalentToSourceH8 := true
  sourceH8SuppliesGeneratorGeometry := true
  sourceH8SuppliesCartanToCompactDual := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesSourceInvariantH8 := false
  provesFullCartanComparison := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R728 source-invariant route. -/
theorem currentR728CurrentSourceInvariantSnapshot_eq_texStatus :
    currentR728CurrentSourceInvariantSnapshot =
      ({ proofWorkObligationCount := 2
         generatorGeometryRouteEquivalentToSourceH8 := true
         sourceH8SuppliesGeneratorGeometry := true
         sourceH8SuppliesCartanToCompactDual := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesSourceInvariantH8 := false
         provesFullCartanComparison := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R728CurrentSourceInvariantSnapshot) := by
  decide

/-- Kernel-checked target names for the R728 route. -/
theorem currentR728CurrentSourceInvariantTargetNames_eq_texStatus :
    currentR728CurrentSourceInvariantTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8"
    ] := by
  rfl

def R728_substantiveTheoremCount : Nat := 5

end FrontC163_H8ResidualCurrentSourceInvariantRoute
end HCGapL4
end HodgeReduction
