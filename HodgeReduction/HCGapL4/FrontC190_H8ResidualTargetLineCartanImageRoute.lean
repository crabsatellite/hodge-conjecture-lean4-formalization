/-
# HC Gap L4 -- Front C190: target line as reverse Cartan image (R755).

R754 leaves the current equivalent frontier as three targets:

* `compactDual = H8`;
* `surjectivity_source = compactDual`;
* `trivialModulePart <= span {j_q(h^4)}`.

R656 already proved that the Cartan H8 image is exactly the line
`span {j_q(h^4)}`.  This file rewrites the third target as the structural
reverse image containment:

  `trivialModulePart <= Submodule.map j_q CartanH8`.

No proof-work target is discharged; the target-side gap is only moved from a
bare generator line to the Cartan-image surface that can consume genuine
Matsushima/automorphic image theorems.
-/

import HodgeReduction.HCGapL4.FrontC189_H8ResidualFiniteUpperToTargetLineRoute
import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC190_H8ResidualTargetLineCartanImageRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC187_H8ResidualTargetRankNonzeroSplit
open FrontC189_H8ResidualFiniteUpperToTargetLineRoute

section TargetLineCartanImage

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

/-- **R755 substantive theorem (1/6)**: the R754 target-line containment is
exactly reverse containment in the Cartan H8 image. -/
theorem targetLine_iff_trivialModulePart_le_cartanImage :
    (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) <->
      (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) := by
  rw [cartan_image_eq_span_matsushima_h_pow_four (A := A) (B := B)]

/-- R755 primitive spelling of the current frontier: the R754 line target is
written as reverse Cartan-image containment. -/
structure EVIIH8ResidualCompactDualH8SourceCartanImageContract
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
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  trivialModulePart_le_cartanImage :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))

/-- **R755 substantive theorem (2/6)**: the R754 line contract supplies the
reverse Cartan-image contract. -/
def cartanImageContract_of_targetLineContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetLineContract A B) :
    EVIIH8ResidualCompactDualH8SourceCartanImageContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_le_cartanImage :=
    (targetLine_iff_trivialModulePart_le_cartanImage
      (A := A) (B := B)).1
      O.trivialModulePart_le_h_pow_four_line

/-- **R755 substantive theorem (3/6)**: reverse Cartan-image containment
recovers the R754 target-line contract. -/
def targetLineContract_of_cartanImageContract
    (O : EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetLineContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_le_h_pow_four_line :=
    (targetLine_iff_trivialModulePart_le_cartanImage
      (A := A) (B := B)).2
      O.trivialModulePart_le_cartanImage

/-- **R755 substantive theorem (4/6)**: the R754 target-line frontier and the
R755 reverse-Cartan-image frontier are the same inhabited residual ledger. -/
theorem residual_targetLine_nonempty_iff_cartanImage_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceTargetLineContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanImageContract_of_targetLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetLineContract_of_cartanImageContract
            (A := A) (B := B) O)))

/-- **R755 substantive theorem (5/6)**: the R752 rank split frontier is
equivalently the R755 reverse-Cartan-image frontier. -/
theorem residual_rankSplit_nonempty_iff_cartanImage_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :=
  (residual_rankSplit_nonempty_iff_targetLine_nonempty
    (A := A) (B := B)).trans
    (residual_targetLine_nonempty_iff_cartanImage_nonempty
      (A := A) (B := B))

/-- **R755 substantive theorem (6/6)**: the current boundary/compact-dual-H8
frontier is equivalently the R755 reverse-Cartan-image frontier. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_cartanImage_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :=
  (residual_boundaryDataCompactDualH8_nonempty_iff_targetLine_nonempty
    (A := A) (B := B)).trans
    (residual_targetLine_nonempty_iff_cartanImage_nonempty
      (A := A) (B := B))

end TargetLineCartanImage

/-- R755 target names for route summaries. -/
def currentR755TargetLineCartanImageTargetNames : List String := [
  "prove compactDual = H8",
  "prove surjectivity_source = compactDual",
  "prove trivialModulePart <= Submodule.map j_q CartanH8"
]

/-- Machine-readable status for the R755 Cartan-image route. -/
structure R755TargetLineCartanImageSnapshot where
  proofWorkObligationCount : Nat
  targetLineEquivalentToReverseCartanImage : Bool
  targetLineFrontierEquivalentToCartanImageFrontier : Bool
  rankSplitEquivalentToCartanImageFrontier : Bool
  boundaryCompactDualH8EquivalentToCartanImageFrontier : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceBoundary : Bool
  provesReverseCartanImageContainment : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R755 status: the target-line gap is now a reverse Cartan-image
containment gap. -/
def currentR755TargetLineCartanImageSnapshot :
    R755TargetLineCartanImageSnapshot where
  proofWorkObligationCount := currentR755TargetLineCartanImageTargetNames.length
  targetLineEquivalentToReverseCartanImage := true
  targetLineFrontierEquivalentToCartanImageFrontier := true
  rankSplitEquivalentToCartanImageFrontier := true
  boundaryCompactDualH8EquivalentToCartanImageFrontier := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceBoundary := false
  provesReverseCartanImageContainment := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R755 Cartan-image route. -/
theorem currentR755TargetLineCartanImageSnapshot_eq_texStatus :
    currentR755TargetLineCartanImageSnapshot =
      ({ proofWorkObligationCount := 3
         targetLineEquivalentToReverseCartanImage := true
         targetLineFrontierEquivalentToCartanImageFrontier := true
         rankSplitEquivalentToCartanImageFrontier := true
         boundaryCompactDualH8EquivalentToCartanImageFrontier := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceBoundary := false
         provesReverseCartanImageContainment := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R755TargetLineCartanImageSnapshot) := by
  decide

/-- Kernel-checked target names for the R755 route refinement. -/
theorem currentR755TargetLineCartanImageTargetNames_eq_texStatus :
    currentR755TargetLineCartanImageTargetNames = [
      "prove compactDual = H8",
      "prove surjectivity_source = compactDual",
      "prove trivialModulePart <= Submodule.map j_q CartanH8"
    ] := by
  rfl

def R755_substantiveTheoremCount : Nat := 6

end FrontC190_H8ResidualTargetLineCartanImageRoute
end HCGapL4
end HodgeReduction
