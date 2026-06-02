/-
# HC Gap L4 -- Front C181: latest route collapses to boundary + Cartan carrier (R746).

R745 leaves the current route as three proof-work targets:

* `MatsushimaV56BoundaryData`;
* `H8 <= compactDual`;
* `trivialModulePart <= Submodule.map j_q CartanH8`.

This file proves that those three targets are exactly the older R684
two-target route:

* `MatsushimaV56BoundaryData`;
* `compactDual = CartanH8`.

The forward direction is not a new assumption: the R745 reverse Cartan image
gives exact Cartan image under `H8 <= compactDual`, hence scalar preimages,
hence the target-line theorem, and R733 supplies `compactDual <= H8`.  The
reverse direction uses boundary data to identify the compact-dual image with
`trivialModulePart`, then rewrites `compactDual` as the Cartan H8 line.

No boundary theorem, Cartan carrier theorem, reverse image theorem, or full HC
closure is proved here.
-/

import HodgeReduction.HCGapL4.FrontC120_H8ResidualBoundaryDataCartanContract
import HodgeReduction.HCGapL4.FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC181_H8ResidualLatestRouteBoundaryCartanCollapse

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC168_H8ResidualNoExtraTargetLineEquivalence
open FrontC179_H8ResidualCartanImageExactCurrentRoute
open FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute

section LatestRouteBoundaryCartanCollapse

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

/-- **R746 substantive theorem (1/6)**: boundary data plus the Cartan carrier
equality supplies the latest R745 route.  The H8-containment field is just the
same carrier equality rewritten through Cartan's `H8`, and the reverse image
field follows from the boundary compact-dual image theorem.
-/
def H8ContainmentCartanImageSurjectivityContract_of_boundaryDataCartanContract
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B where
  boundary := O.boundary
  H8_le_compactDual := by
    rw [O.compactDual_eq_cartanH8,
      CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  trivialModulePart_le_cartanImage := by
    have hcompact_image :
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
          CuspidalCohomologyData.trivialModulePart (A := B) :=
      matsushima_compactDual_image_eq_trivialModulePart
        (A := A) (B := B) O.boundary
    have hcartan_image :
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
          CuspidalCohomologyData.trivialModulePart (A := B) := by
      calc
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
            rw [O.compactDual_eq_cartanH8]
        _ = CuspidalCohomologyData.trivialModulePart (A := B) := hcompact_image
    intro beta hbeta
    rw [hcartan_image]
    exact hbeta

/-- **R746 substantive theorem (2/6)**: the latest R745 route recovers the
R684 boundary-plus-Cartan-carrier route.  The key point is that reverse Cartan
image becomes scalar preimage under R744/R745, and R733 then supplies the
missing no-extra containment `compactDual <= H8`.
-/
def boundaryDataCartanContract_of_H8ContainmentCartanImageSurjectivityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary := O.boundary
  compactDual_eq_cartanH8 := by
    have hcartan_image :
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
          CuspidalCohomologyData.trivialModulePart (A := B) :=
      (cartan_image_eq_trivialModulePart_iff_trivialModulePart_le_cartanImage_under_H8_le_compactDual
        (A := A) (B := B) O.H8_le_compactDual).2
        O.trivialModulePart_le_cartanImage
    have hscalar :=
      (cartan_image_eq_trivialModulePart_iff_scalar_preimage_under_boundary_H8_le_compactDual
        (A := A) (B := B) O.boundary O.H8_le_compactDual).1
        hcartan_image
    have hline :=
      (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
        (A := A) (B := B)).1 hscalar
    have hcompact_le_H8 :
        MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
          CompactDualData.H8 (A := A) :=
      compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
        (A := A) (B := B) O.boundary O.H8_le_compactDual hline
    have hcompact_eq_H8 :
        MatsushimaCompactDualData.compactDual (A := A) (B := B) =
          CompactDualData.H8 (A := A) :=
      le_antisymm hcompact_le_H8 O.H8_le_compactDual
    exact hcompact_eq_H8.trans
      (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
        (A := A)).symm

/-- **R746 substantive theorem (3/6)**: the R745 latest route and the R684
boundary-plus-Cartan route are the same inhabited route.
-/
theorem residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_boundaryDataCartan_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataCartanContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCartanContract_of_H8ContainmentCartanImageSurjectivityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentCartanImageSurjectivityContract_of_boundaryDataCartanContract
            (A := A) (B := B) O)))

/-- **R746 substantive theorem (4/6)**: in the forward orientation, the
R684 two-target route and the latest R745 route are equivalent.
-/
theorem residual_boundaryDataCartan_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) :=
  (residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_boundaryDataCartan_nonempty
    (A := A) (B := B)).symm

/-- **R746 substantive theorem (5/6)**: the latest current generator-geometry
route is equivalently boundary data plus the single Cartan carrier equality.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_boundaryDataCartan_latest_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataCartanContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentCartanImageSurjectivity_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_boundaryDataCartan_nonempty
      (A := A) (B := B))

/-- **R746 substantive theorem (6/6)**: the latest route still matches the
R684 boundary/Cartan contract, not a stronger three-premise shell.
-/
theorem residual_boundaryDataCartan_latest_nonempty_iff_currentGeneratorGeometry_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataCartan_latest_nonempty
    (A := A) (B := B)).symm

end LatestRouteBoundaryCartanCollapse

/-- R746 target names for route summaries. -/
def currentR746BoundaryCartanCollapseTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = CartanH8 (equivalently compactDual = H8)"
]

/-- Machine-readable status for the R746 collapse of the latest route. -/
structure R746BoundaryCartanCollapseSnapshot where
  proofWorkObligationCount : Nat
  latestRouteEquivalentToBoundaryDataCartan : Bool
  H8AndReverseCartanImageEquivalentToCompactDualCartanUnderBoundary : Bool
  boundaryDataCartanSuppliesH8Containment : Bool
  boundaryDataCartanSuppliesReverseCartanImage : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualCartan : Bool
  provesH8Containment : Bool
  provesReverseCartanImageContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R746 status: the newest three-target route has collapsed back to
the two genuine targets boundary data plus Cartan carrier equality.
-/
def currentR746BoundaryCartanCollapseSnapshot :
    R746BoundaryCartanCollapseSnapshot where
  proofWorkObligationCount :=
    currentR746BoundaryCartanCollapseTargetNames.length
  latestRouteEquivalentToBoundaryDataCartan := true
  H8AndReverseCartanImageEquivalentToCompactDualCartanUnderBoundary := true
  boundaryDataCartanSuppliesH8Containment := true
  boundaryDataCartanSuppliesReverseCartanImage := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualCartan := false
  provesH8Containment := false
  provesReverseCartanImageContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R746 route collapse. -/
theorem currentR746BoundaryCartanCollapseSnapshot_eq_texStatus :
    currentR746BoundaryCartanCollapseSnapshot =
      ({ proofWorkObligationCount := 2
         latestRouteEquivalentToBoundaryDataCartan := true
         H8AndReverseCartanImageEquivalentToCompactDualCartanUnderBoundary := true
         boundaryDataCartanSuppliesH8Containment := true
         boundaryDataCartanSuppliesReverseCartanImage := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualCartan := false
         provesH8Containment := false
         provesReverseCartanImageContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R746BoundaryCartanCollapseSnapshot) := by
  decide

/-- Kernel-checked target names for the R746 route collapse. -/
theorem currentR746BoundaryCartanCollapseTargetNames_eq_texStatus :
    currentR746BoundaryCartanCollapseTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = CartanH8 (equivalently compactDual = H8)"
    ] := by
  rfl

def R746_substantiveTheoremCount : Nat := 6

end FrontC181_H8ResidualLatestRouteBoundaryCartanCollapse
end HCGapL4
end HodgeReduction
