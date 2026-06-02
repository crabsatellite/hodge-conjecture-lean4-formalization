/-
# HC Gap L4 -- Front C193: pointwise boundary-to-Cartan consumer (R758).

R755/R756 identify the current frontier with the older R722 route at the
inhabited-contract level.  This file names the pointwise forward consumer:
an actual witness of `MatsushimaV56BoundaryData` plus `compactDual = H8`
directly supplies the current three-field Cartan-image contract.

This does not prove boundary data or `compactDual = H8` unconditionally.  It
removes a proof-script detour so later attacks can consume a boundary/H8
witness without passing through anonymous `Nonempty` conversions.
-/

import HodgeReduction.HCGapL4.FrontC192_H8ResidualCurrentCartanImageGuardrail

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC193_H8ResidualBoundaryCompactDualCartanImagePointwise

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC186_H8ResidualBoundaryCompactDualTargetRankRoute
open FrontC187_H8ResidualTargetRankNonzeroSplit
open FrontC188_H8ResidualTargetNonzeroFromCompactDual
open FrontC189_H8ResidualFiniteUpperToTargetLineRoute
open FrontC190_H8ResidualTargetLineCartanImageRoute
open FrontC191_H8ResidualCartanImageBoundaryConsumer

section BoundaryCompactDualCartanImagePointwise

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

/-- **R758 substantive theorem (1/5)**: a concrete R722
boundary-data/compact-dual-H8 witness supplies the current R755/R756
Cartan-image contract pointwise. -/
def currentCartanImageContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualCompactDualH8SourceCartanImageContract A B :=
  cartanImageContract_of_targetLineContract
    (A := A) (B := B)
    (targetLineContract_of_finiteUpperContract
      (A := A) (B := B)
      (finiteUpperContract_of_rankSplitContract
        (A := A) (B := B)
        (rankSplitContract_of_sourceTargetRankContract
          (A := A) (B := B)
          (sourceTargetRankContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O))))

/-- **R758 substantive theorem (2/5)**: the current Cartan-image contract
already has the pointwise R756 consumer back to the older R722 route. -/
def boundaryDataCompactDualH8Contract_of_currentCartanImageContract
    (O : EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B :=
  boundaryDataCompactDualH8Contract_of_cartanImageContract
    (A := A) (B := B) O

/-- **R758 substantive theorem (3/5)**: the old R722 witness gives the
source-boundary field in the current contract. -/
theorem source_eq_compactDual_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (currentCartanImageContract_of_boundaryDataCompactDualH8Contract
    (A := A) (B := B) O).source_eq_compactDual

/-- **R758 substantive theorem (4/5)**: the old R722 witness gives the
reverse Cartan-image containment field in the current contract. -/
theorem trivialModulePart_le_cartanImage_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :=
  (currentCartanImageContract_of_boundaryDataCompactDualH8Contract
    (A := A) (B := B) O).trivialModulePart_le_cartanImage

/-- **R758 substantive theorem (5/5)**: the R722 route and the current
Cartan-image contract are pointwise interchangeable at the inhabited level,
using the explicit consumers named in this file. -/
theorem boundaryDataCompactDualH8_nonempty_iff_currentCartanImage_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceCartanImageContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (currentCartanImageContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_currentCartanImageContract
            (A := A) (B := B) O)))

end BoundaryCompactDualCartanImagePointwise

/-- R758 target names for route summaries. -/
def currentR758BoundaryCompactDualCartanImagePointwiseTargetNames :
    List String := [
  "prove MatsushimaV56BoundaryData and compactDual = H8",
  "then consume that witness pointwise as the current Cartan-image contract"
]

/-- Machine-readable status for the R758 pointwise consumer. -/
structure R758BoundaryCompactDualCartanImagePointwiseSnapshot where
  boundaryCompactDualH8FeedsCurrentCartanImageContractPointwise : Bool
  currentCartanImageFeedsBoundaryCompactDualH8Pointwise : Bool
  sourceFieldExtractedFromBoundaryCompactDualH8 : Bool
  reverseCartanImageFieldExtractedFromBoundaryCompactDualH8 : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  provesCurrentCartanImageContractUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R758 status: the old R722 route has an explicit pointwise
consumer into the current R755/R756 Cartan-image frontier. -/
def currentR758BoundaryCompactDualCartanImagePointwiseSnapshot :
    R758BoundaryCompactDualCartanImagePointwiseSnapshot where
  boundaryCompactDualH8FeedsCurrentCartanImageContractPointwise := true
  currentCartanImageFeedsBoundaryCompactDualH8Pointwise := true
  sourceFieldExtractedFromBoundaryCompactDualH8 := true
  reverseCartanImageFieldExtractedFromBoundaryCompactDualH8 := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualH8 := false
  provesCurrentCartanImageContractUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R758 pointwise consumer. -/
theorem currentR758BoundaryCompactDualCartanImagePointwiseSnapshot_eq_texStatus :
    currentR758BoundaryCompactDualCartanImagePointwiseSnapshot =
      ({ boundaryCompactDualH8FeedsCurrentCartanImageContractPointwise := true
         currentCartanImageFeedsBoundaryCompactDualH8Pointwise := true
         sourceFieldExtractedFromBoundaryCompactDualH8 := true
         reverseCartanImageFieldExtractedFromBoundaryCompactDualH8 := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualH8 := false
         provesCurrentCartanImageContractUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R758BoundaryCompactDualCartanImagePointwiseSnapshot) := by
  decide

/-- Kernel-checked target names for the R758 pointwise consumer. -/
theorem currentR758BoundaryCompactDualCartanImagePointwiseTargetNames_eq_texStatus :
    currentR758BoundaryCompactDualCartanImagePointwiseTargetNames = [
      "prove MatsushimaV56BoundaryData and compactDual = H8",
      "then consume that witness pointwise as the current Cartan-image contract"
    ] := by
  rfl

def R758_substantiveTheoremCount : Nat := 5

end FrontC193_H8ResidualBoundaryCompactDualCartanImagePointwise
end HCGapL4
end HodgeReduction
