/-
# HC Gap L4 -- Front C139: boundary/source-H8 equals boundary/compactDual-H8 (R704).

R703 left the preferred route as the two-target contract:

* prove honest `MatsushimaV56BoundaryData`;
* prove `surjectivity_source = H8`.

But once boundary data is present, its source field already says
`surjectivity_source = compactDual`.  Therefore the second target is exactly
the compact-dual carrier theorem

  `compactDual = H8`.

This file records that equivalence directly, without passing through the
target-line route.  It does not prove boundary data or compact-dual-H8; it
only fixes the preferred next attack surface for the source side.
-/

import HodgeReduction.HCGapL4.FrontC138_H8ResidualCartanImageBoundarySourceH8Equivalence
import HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC139_H8ResidualBoundarySourceCompactDualEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC82_H8ResidualAtlasMultiplicityCriterion
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC138_H8ResidualCartanImageBoundarySourceH8Equivalence

section BoundarySourceCompactDual

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

/-- **R704 substantive theorem (1/5)**: boundary data plus source-H8
surjectivity gives the compact-dual-H8 carrier theorem. -/
theorem compactDual_eq_H8_of_boundaryData_surjectivity_source_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  D.source_eq_compactDual.symm.trans hsource_H8

/-- **R704 substantive theorem (2/5)**: conversely, boundary data plus
compact-dual-H8 gives source-H8 surjectivity. -/
theorem surjectivity_source_eq_H8_of_boundaryData_compactDual_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  D.source_eq_compactDual.trans hcompact_H8

/-- **R704 substantive theorem (3/5)**: the R703 boundary/source-H8 route
feeds the older boundary/compactDual-H8 route directly. -/
def boundaryDataCompactDualH8Contract_of_boundaryDataSourceSurjectivityContract
    (O : EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_boundaryData_surjectivity_source_eq_H8
      (A := A) (B := B) O.boundary O.surjectivity_source_eq_H8

/-- **R704 substantive theorem (4/5)**: the boundary/compactDual-H8 route
feeds the R703 boundary/source-H8 route directly. -/
def boundaryDataSourceSurjectivityContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B where
  boundary := O.boundary
  surjectivity_source_eq_H8 :=
    surjectivity_source_eq_H8_of_boundaryData_compactDual_eq_H8
      (A := A) (B := B) O.boundary O.compactDual_eq_H8

/-- **R704 substantive theorem (5/5)**: the R703 boundary/source-H8 route and
the boundary/compactDual-H8 route are the same inhabited residual contract. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_boundaryDataSourceSurjectivityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceSurjectivityContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))

/-- The Cartan-image route is also equivalent to the compact-dual-H8
two-target route, by R703 followed by R704. -/
theorem residual_cartanImageUpperBound_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualCartanImageUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_cartanImageUpperBound_nonempty_iff_boundaryDataSourceSurjectivity_nonempty
    (A := A) (B := B) |>.trans
    residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualH8_nonempty

end BoundarySourceCompactDual

/-- R704 target names for route summaries. -/
def currentR704BoundarySourceCompactDualTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = H8"
]

/-- Machine-readable status for the R704 route equivalence. -/
structure R704BoundarySourceCompactDualSnapshot where
  proofWorkObligationCount : Nat
  sourceH8SurjectivityEquivalentToCompactDualH8UnderBoundaryData : Bool
  boundarySourceH8RouteEquivalentToBoundaryCompactDualH8Route : Bool
  cartanImageRouteEquivalentToBoundaryCompactDualH8Route : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R704 status: the preferred route should be read as boundary data
plus the compact-dual-H8 carrier theorem. -/
def currentR704BoundarySourceCompactDualSnapshot :
    R704BoundarySourceCompactDualSnapshot where
  proofWorkObligationCount :=
    currentR704BoundarySourceCompactDualTargetNames.length
  sourceH8SurjectivityEquivalentToCompactDualH8UnderBoundaryData := true
  boundarySourceH8RouteEquivalentToBoundaryCompactDualH8Route := true
  cartanImageRouteEquivalentToBoundaryCompactDualH8Route := true
  provesBoundaryData := false
  provesCompactDualH8 := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R704 route ledger. -/
theorem currentR704BoundarySourceCompactDualSnapshot_eq_texStatus :
    currentR704BoundarySourceCompactDualSnapshot =
      ({ proofWorkObligationCount := 2
         sourceH8SurjectivityEquivalentToCompactDualH8UnderBoundaryData := true
         boundarySourceH8RouteEquivalentToBoundaryCompactDualH8Route := true
         cartanImageRouteEquivalentToBoundaryCompactDualH8Route := true
         provesBoundaryData := false
         provesCompactDualH8 := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R704BoundarySourceCompactDualSnapshot) := by
  decide

/-- Kernel-checked target names for the R704 route. -/
theorem currentR704BoundarySourceCompactDualTargetNames_eq_texStatus :
    currentR704BoundarySourceCompactDualTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = H8"
    ] := by
  rfl

def R704_substantiveTheoremCount : Nat := 5

end FrontC139_H8ResidualBoundarySourceCompactDualEquivalence
end HCGapL4
end HodgeReduction
