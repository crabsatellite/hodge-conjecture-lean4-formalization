/-
# HC Gap L4 -- Front C182: latest route to finite-rank compactDual attack (R747).

R746 collapsed the newest three-field route to the honest two-target route:

* `MatsushimaV56BoundaryData`;
* `compactDual = CartanH8`.

This file reconnects that latest route directly to the sharp R707/R708
finite-rank compact-dual attack surface:

* `MatsushimaV56BoundaryData`;
* `h^4 in compactDual`;
* finite-dimensional `compactDual`;
* `finrank compactDual <= 1`.

The finite-rank package is equivalent to the R746 boundary-plus-Cartan
contract.  It is not a stronger premise and it does not prove any of the four
targets; it makes the next EVII geometry work explicit.
-/

import HodgeReduction.HCGapL4.FrontC181_H8ResidualLatestRouteBoundaryCartanCollapse
import HodgeReduction.HCGapL4.FrontC153_H8ResidualCompactDualFiniteRankAttackRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC182_H8ResidualLatestRouteFiniteRankAttack

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC153_H8ResidualCompactDualFiniteRankAttackRoute
open FrontC181_H8ResidualLatestRouteBoundaryCartanCollapse

section LatestRouteFiniteRankAttack

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

/-- **R747 substantive theorem (1/6)**: the R746 boundary-plus-Cartan
contract supplies the sharp finite-rank compact-dual attack contract.

The proof only rewrites `compactDual = CartanH8` to `compactDual = H8`,
splits the H8 equality into carrier containment plus generator membership,
and then uses R707 to extract finite-dimensionality and the rank-one bound.
-/
def finiteRankCarrierContract_of_boundaryDataCartanContract_latest
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B :=
  finiteRankCarrierContract_of_boundaryDataCompactDualCarrierSplitContract
    (A := A) (B := B)
    (boundaryDataCompactDualCarrierSplitContract_of_boundaryDataCompactDualH8Contract
      (A := A) (B := B)
      ({ boundary := O.boundary
         compactDual_eq_H8 :=
          (compactDual_eq_cartanH8_iff_compactDual_eq_H8
            (A := A) (B := B)).1 O.compactDual_eq_cartanH8 } :
        EVIIH8ResidualBoundaryDataCompactDualH8Contract A B))

/-- **R747 substantive theorem (2/6)**: the finite-rank compact-dual attack
contract rebuilds the R746 boundary-plus-Cartan route.  The finite-rank fields
recover `compactDual = H8` by R708/R718, and Cartan's H8 line then rewrites
that equality to `compactDual = CartanH8`.
-/
def boundaryDataCartanContract_of_finiteRankCarrierContract_latest
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary := O.boundary
  compactDual_eq_cartanH8 :=
    (compactDual_eq_cartanH8_iff_compactDual_eq_H8
      (A := A) (B := B)).2
      (compactDual_eq_H8_of_finiteRankCarrierContract
        (A := A) (B := B) O)

/-- **R747 substantive theorem (3/6)**: the R746 two-target route and the
finite-rank compact-dual attack route are the same inhabited residual
contract.
-/
theorem residual_boundaryDataCartan_nonempty_iff_compactDualFiniteRank_latest_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteRankCarrierContract_of_boundaryDataCartanContract_latest
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCartanContract_of_finiteRankCarrierContract_latest
            (A := A) (B := B) O)))

/-- **R747 substantive theorem (4/6)**: reverse orientation of the same
equivalence, useful for route ledgers that list the finite-rank surface first.
-/
theorem residual_compactDualFiniteRank_latest_nonempty_iff_boundaryDataCartan_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) :=
  (residual_boundaryDataCartan_nonempty_iff_compactDualFiniteRank_latest_nonempty
    (A := A) (B := B)).symm

/-- **R747 substantive theorem (5/6)**: the latest R745/R746
H8-containment-plus-reverse-Cartan-image route is exactly the finite-rank
compact-dual attack route.
-/
theorem residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_compactDualFiniteRank_latest_nonempty :
    Nonempty
        (FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute.EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  (residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_boundaryDataCartan_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCartan_nonempty_iff_compactDualFiniteRank_latest_nonempty
      (A := A) (B := B))

/-- **R747 substantive theorem (6/6)**: the current generator-geometry route
has the same finite-rank attack surface.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_compactDualFiniteRank_latest_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataCartan_latest_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCartan_nonempty_iff_compactDualFiniteRank_latest_nonempty
      (A := A) (B := B))

end LatestRouteFiniteRankAttack

/-- R747 target names for route summaries. -/
def currentR747FiniteRankAttackTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in compactDual",
  "prove finite-dimensional compactDual",
  "prove finrank compactDual <= 1"
]

/-- Machine-readable status for the R747 finite-rank attack surface. -/
structure R747FiniteRankAttackSnapshot where
  proofWorkObligationCount : Nat
  boundaryCartanEquivalentToFiniteRankAttack : Bool
  latestH8ReverseCartanRouteEquivalentToFiniteRankAttack : Bool
  currentGeneratorGeometryEquivalentToFiniteRankAttack : Bool
  finiteRankAttackProvesCompactDualCartan : Bool
  cartanCarrierRecoversFiniteRankWitnesses : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualGeneratorMembership : Bool
  provesCompactDualFiniteDimensionality : Bool
  provesCompactDualRankBound : Bool
  provesCompactDualCartan : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R747 status: the live R746 frontier can be attacked through the
sharp finite-rank compact-dual surface.  The file proves equivalence only.
-/
def currentR747FiniteRankAttackSnapshot :
    R747FiniteRankAttackSnapshot where
  proofWorkObligationCount := currentR747FiniteRankAttackTargetNames.length
  boundaryCartanEquivalentToFiniteRankAttack := true
  latestH8ReverseCartanRouteEquivalentToFiniteRankAttack := true
  currentGeneratorGeometryEquivalentToFiniteRankAttack := true
  finiteRankAttackProvesCompactDualCartan := true
  cartanCarrierRecoversFiniteRankWitnesses := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualGeneratorMembership := false
  provesCompactDualFiniteDimensionality := false
  provesCompactDualRankBound := false
  provesCompactDualCartan := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R747 route refinement. -/
theorem currentR747FiniteRankAttackSnapshot_eq_texStatus :
    currentR747FiniteRankAttackSnapshot =
      ({ proofWorkObligationCount := 4
         boundaryCartanEquivalentToFiniteRankAttack := true
         latestH8ReverseCartanRouteEquivalentToFiniteRankAttack := true
         currentGeneratorGeometryEquivalentToFiniteRankAttack := true
         finiteRankAttackProvesCompactDualCartan := true
         cartanCarrierRecoversFiniteRankWitnesses := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualGeneratorMembership := false
         provesCompactDualFiniteDimensionality := false
         provesCompactDualRankBound := false
         provesCompactDualCartan := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R747FiniteRankAttackSnapshot) := by
  decide

/-- Kernel-checked target names for the R747 route refinement. -/
theorem currentR747FiniteRankAttackTargetNames_eq_texStatus :
    currentR747FiniteRankAttackTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in compactDual",
      "prove finite-dimensional compactDual",
      "prove finrank compactDual <= 1"
    ] := by
  rfl

def R747_substantiveTheoremCount : Nat := 6

end FrontC182_H8ResidualLatestRouteFiniteRankAttack
end HCGapL4
end HodgeReduction
