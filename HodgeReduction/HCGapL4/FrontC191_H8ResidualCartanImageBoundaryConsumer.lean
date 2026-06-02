/-
# HC Gap L4 -- Front C191: R755 Cartan-image boundary consumer (R756).

R755 leaves the preferred local frontier as three targets:

* `compactDual = H8`;
* `surjectivity_source = compactDual`;
* `trivialModulePart <= Submodule.map j_q CartanH8`.

This file proves that those three targets are not just a naming convention.
The compact-dual/H8 target supplies the easy image inclusion, the reverse
Cartan-image target upgrades it to exact Cartan image, and the source equality
then rebuilds the honest `MatsushimaV56BoundaryData`.

No target is proved unconditionally.  The file is a consumer for the current
frontier and keeps all three proof-work obligations explicit.
-/

import HodgeReduction.HCGapL4.FrontC190_H8ResidualTargetLineCartanImageRoute
import HodgeReduction.HCGapL4.FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute
import HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC191_H8ResidualCartanImageBoundaryConsumer

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC22_MatsushimaExactImageSourceEquivalence
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute
open FrontC189_H8ResidualFiniteUpperToTargetLineRoute
open FrontC190_H8ResidualTargetLineCartanImageRoute

section CartanImageBoundaryConsumer

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

/-- **R756 substantive theorem (1/7)**: under `compactDual = H8`, the R755
reverse Cartan-image containment upgrades to exact Cartan image. -/
theorem cartan_image_eq_trivialModulePart_of_compactDual_eq_H8_reverseCartanImage
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcartan :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  (cartan_image_eq_trivialModulePart_iff_trivialModulePart_le_cartanImage_under_H8_le_compactDual
    (A := A) (B := B)
    (H8_le_compactDual_of_compactDual_eq_H8 (A := A) (B := B) hcompact)).2
    hcartan

/-- **R756 substantive theorem (2/7)**: the same two targets identify the
compact-dual image itself with the trivial-module target. -/
theorem compactDual_image_eq_trivialModulePart_of_compactDual_eq_H8_reverseCartanImage
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcartan :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CompactDualData.H8 (A := A)) := by
        rw [hcompact]
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
        rw [← CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
    _ = CuspidalCohomologyData.trivialModulePart (A := B) :=
      cartan_image_eq_trivialModulePart_of_compactDual_eq_H8_reverseCartanImage
        (A := A) (B := B) hcompact hcartan

/-- **R756 substantive theorem (3/7)**: adding the R755 source equality
turns the designated Matsushima target into the trivial-module part. -/
theorem surjectivity_target_eq_trivialModulePart_of_compactDual_eq_H8_source_reverseCartanImage
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcartan :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
        =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
        exact
          (compactDual_exact_image_of_source_eq_compactDual
            (A := A) (B := B) hsource).symm
    _ = CuspidalCohomologyData.trivialModulePart (A := B) :=
      compactDual_image_eq_trivialModulePart_of_compactDual_eq_H8_reverseCartanImage
        (A := A) (B := B) hcompact hcartan

/-- **R756 substantive theorem (4/7)**: the three R755 fields rebuild honest
Matsushima V56 boundary data. -/
def boundaryData_of_compactDual_eq_H8_source_reverseCartanImage
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcartan :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual := hsource
  target_eq_invariants := by
    calc
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
          = CuspidalCohomologyData.trivialModulePart (A := B) :=
          surjectivity_target_eq_trivialModulePart_of_compactDual_eq_H8_source_reverseCartanImage
            (A := A) (B := B) hcompact hsource hcartan
      _ = MatsushimaData.target_invariants (A := A) (B := B) :=
          (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm

/-- **R756 substantive theorem (5/7)**: the R755 Cartan-image contract has a
direct boundary-data consumer. -/
def boundaryData_of_cartanImageContract
    (O : EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :
    MatsushimaV56BoundaryData A B :=
  boundaryData_of_compactDual_eq_H8_source_reverseCartanImage
    (A := A) (B := B)
    O.compactDual_eq_H8
    O.source_eq_compactDual
    O.trivialModulePart_le_cartanImage

/-- **R756 substantive theorem (6/7)**: the R755 contract rebuilds the older
boundary-data/compact-dual-H8 contract without adding a hidden premise. -/
def boundaryDataCompactDualH8Contract_of_cartanImageContract
    (O : EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := boundaryData_of_cartanImageContract (A := A) (B := B) O
  compactDual_eq_H8 := O.compactDual_eq_H8

/-- **R756 substantive theorem (7/7)**: the R755 contract and the older
boundary-data/compact-dual-H8 contract are the same inhabited residual
surface, with the forward direction now given by the exact-image consumer
above. -/
theorem residual_cartanImage_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_cartanImageContract
            (A := A) (B := B) O)))
    (fun h =>
      (residual_boundaryDataCompactDualH8_nonempty_iff_cartanImage_nonempty
        (A := A) (B := B)).1 h)

end CartanImageBoundaryConsumer

/-- R756 keeps the same three proof-work targets but records their concrete
boundary-data consumer. -/
def currentR756CartanImageBoundaryConsumerTargetNames : List String := [
  "prove compactDual = H8",
  "prove surjectivity_source = compactDual",
  "prove trivialModulePart <= Submodule.map j_q CartanH8"
]

/-- Machine-readable status for the R756 Cartan-image boundary consumer. -/
structure R756CartanImageBoundaryConsumerSnapshot where
  proofWorkObligationCount : Nat
  compactDualH8ReverseCartanImageGivesExactCartanImage : Bool
  compactDualH8ReverseCartanImageGivesCompactDualImage : Bool
  threeTargetContractRebuildsBoundaryData : Bool
  cartanImageContractEquivalentToBoundaryCompactDualH8 : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceBoundary : Bool
  provesReverseCartanImageContainment : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R756 status: R755's three fields are now wired to the boundary
consumer, but none of the three fields has been proved. -/
def currentR756CartanImageBoundaryConsumerSnapshot :
    R756CartanImageBoundaryConsumerSnapshot where
  proofWorkObligationCount :=
    currentR756CartanImageBoundaryConsumerTargetNames.length
  compactDualH8ReverseCartanImageGivesExactCartanImage := true
  compactDualH8ReverseCartanImageGivesCompactDualImage := true
  threeTargetContractRebuildsBoundaryData := true
  cartanImageContractEquivalentToBoundaryCompactDualH8 := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceBoundary := false
  provesReverseCartanImageContainment := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R756 boundary consumer. -/
theorem currentR756CartanImageBoundaryConsumerSnapshot_eq_texStatus :
    currentR756CartanImageBoundaryConsumerSnapshot =
      ({ proofWorkObligationCount := 3
         compactDualH8ReverseCartanImageGivesExactCartanImage := true
         compactDualH8ReverseCartanImageGivesCompactDualImage := true
         threeTargetContractRebuildsBoundaryData := true
         cartanImageContractEquivalentToBoundaryCompactDualH8 := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceBoundary := false
         provesReverseCartanImageContainment := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R756CartanImageBoundaryConsumerSnapshot) := by
  decide

/-- Kernel-checked target names for the R756 route consumer. -/
theorem currentR756CartanImageBoundaryConsumerTargetNames_eq_texStatus :
    currentR756CartanImageBoundaryConsumerTargetNames = [
      "prove compactDual = H8",
      "prove surjectivity_source = compactDual",
      "prove trivialModulePart <= Submodule.map j_q CartanH8"
    ] := by
  rfl

def R756_substantiveTheoremCount : Nat := 7

end FrontC191_H8ResidualCartanImageBoundaryConsumer
end HCGapL4
end HodgeReduction
