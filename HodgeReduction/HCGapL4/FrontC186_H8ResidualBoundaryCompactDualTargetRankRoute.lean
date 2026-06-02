/-
# HC Gap L4 -- Front C186: boundary plus compactDual-H8 as source plus target rank (R751).

R749/R750 leave the live local frontier as two honest geometric targets:

* `MatsushimaV56BoundaryData`;
* `compactDual = H8`.

The boundary package still has a source field and a target field.  This file
uses the older R564 rank-one bridge to separate those fields in the current
frontier: after `compactDual = H8`, the target boundary field is equivalent
to the rank-one automorphic multiplicity target

  `finrank trivialModulePart = 1`.

Thus the current local route can be attacked as three primitive targets:

* prove `compactDual = H8`;
* prove `surjectivity_source = compactDual`;
* prove `finrank trivialModulePart = 1`.

No target is proved here, and no stronger premise is introduced.
-/

import HodgeReduction.HCGapL4.FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse
import HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC186_H8ResidualBoundaryCompactDualTargetRankRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC23_MatsushimaCompactDualRankOne
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack
open FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse

section BoundaryCompactDualTargetRank

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

/-- **R751 substantive theorem (1/6)**: once the compact-dual carrier is
`H8`, the primitive source-boundary equality can be read as
`surjectivity_source = H8`. -/
theorem surjectivity_source_eq_H8_of_source_eq_compactDual_compactDual_eq_H8
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  hsource.trans hcompact

/-- **R751 substantive theorem (2/6)**: boundary data plus `compactDual = H8`
forces the target multiplicity statement `finrank trivialModulePart = 1`.
This is a consequence of the exact compact-dual image theorem and injectivity
of the Matsushima map; it does not assume finite-dimensionality separately. -/
theorem trivialModulePart_finrank_eq_one_of_boundaryData_compactDual_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  have himage :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        CuspidalCohomologyData.trivialModulePart (A := B) :=
    matsushima_compactDual_image_eq_trivialModulePart
      (A := A) (B := B) D
  calc
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) =
      Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))) := by
        rw [himage]
    _ =
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
        exact
          ((Submodule.equivMapOfInjective
            (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaData.j_q_injective (A := A) (B := B))
            (MatsushimaCompactDualData.compactDual (A := A) (B := B))).finrank_eq).symm
    _ = Module.finrank (R := Rat) (CompactDualData.H8 (A := A)) := by
        rw [hcompact]
    _ = 1 := compactDual_H8_finrank_eq_one (A := A)

/-- R751 primitive spelling of the current R749/R750 frontier.  It replaces
the full boundary package by its source equality plus the exact target
rank-one multiplicity. -/
structure EVIIH8ResidualCompactDualH8SourceTargetRankContract
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
  trivialModulePart_finrank_eq_one :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) = 1

/-- **R751 substantive theorem (3/6)**: the old boundary-data/compact-dual-H8
contract supplies the three primitive R751 targets. -/
def sourceTargetRankContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetRankContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.boundary.source_eq_compactDual
  trivialModulePart_finrank_eq_one :=
    trivialModulePart_finrank_eq_one_of_boundaryData_compactDual_eq_H8
      (A := A) (B := B) O.boundary O.compactDual_eq_H8

/-- **R751 substantive theorem (4/6)**: the three primitive R751 targets
rebuild the old boundary-data/compact-dual-H8 contract.  Rank one supplies
the finite-dimensional target instance needed by R564. -/
def boundaryDataCompactDualH8Contract_of_sourceTargetRankContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetRankContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := by
    haveI :
        FiniteDimensional Rat
          (CuspidalCohomologyData.trivialModulePart (A := B)) :=
      Module.finite_of_finrank_eq_succ
        (R := Rat)
        (M := CuspidalCohomologyData.trivialModulePart (A := B))
        (n := 0)
        O.trivialModulePart_finrank_eq_one
    exact
      matsushimaV56BoundaryData_of_source_eq_H8_rank_one
        (A := A) (B := B)
        O.source_eq_compactDual
        O.compactDual_eq_H8
        O.trivialModulePart_finrank_eq_one
  compactDual_eq_H8 := O.compactDual_eq_H8

/-- **R751 substantive theorem (5/6)**: the two-target R749 frontier and the
three-target source/target-rank frontier are the same inhabited residual
contract. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_sourceTargetRank_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceTargetRankContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_sourceTargetRankContract
            (A := A) (B := B) O)))

/-- **R751 substantive theorem (6/6)**: the R748 rank-one generator route also
has the same R751 source/target-rank frontier through R749. -/
theorem residual_rankOneGenerator_nonempty_iff_sourceTargetRank_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankContract A B) :=
  (residual_rankOneGenerator_nonempty_iff_boundaryDataCompactDualH8_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_sourceTargetRank_nonempty
      (A := A) (B := B))

end BoundaryCompactDualTargetRank

/-- R751 target names for route summaries. -/
def currentR751BoundaryCompactDualTargetRankTargetNames : List String := [
  "prove compactDual = H8",
  "prove surjectivity_source = compactDual",
  "prove finrank trivialModulePart = 1"
]

/-- Machine-readable status for the R751 current-frontier refinement. -/
structure R751BoundaryCompactDualTargetRankSnapshot where
  proofWorkObligationCount : Nat
  boundaryCompactDualH8EquivalentToSourceTargetRank : Bool
  rankOneGeneratorEquivalentToSourceTargetRank : Bool
  targetBoundaryReducedToTrivialRankOne : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceBoundary : Bool
  provesTrivialModulePartRankOne : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R751 status: the live local frontier is now `compactDual = H8`,
the source-boundary equality, and the target rank-one multiplicity. -/
def currentR751BoundaryCompactDualTargetRankSnapshot :
    R751BoundaryCompactDualTargetRankSnapshot where
  proofWorkObligationCount :=
    currentR751BoundaryCompactDualTargetRankTargetNames.length
  boundaryCompactDualH8EquivalentToSourceTargetRank := true
  rankOneGeneratorEquivalentToSourceTargetRank := true
  targetBoundaryReducedToTrivialRankOne := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceBoundary := false
  provesTrivialModulePartRankOne := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R751 route refinement. -/
theorem currentR751BoundaryCompactDualTargetRankSnapshot_eq_texStatus :
    currentR751BoundaryCompactDualTargetRankSnapshot =
      ({ proofWorkObligationCount := 3
         boundaryCompactDualH8EquivalentToSourceTargetRank := true
         rankOneGeneratorEquivalentToSourceTargetRank := true
         targetBoundaryReducedToTrivialRankOne := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceBoundary := false
         provesTrivialModulePartRankOne := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R751BoundaryCompactDualTargetRankSnapshot) := by
  decide

/-- Kernel-checked target names for the R751 route refinement. -/
theorem currentR751BoundaryCompactDualTargetRankTargetNames_eq_texStatus :
    currentR751BoundaryCompactDualTargetRankTargetNames = [
      "prove compactDual = H8",
      "prove surjectivity_source = compactDual",
      "prove finrank trivialModulePart = 1"
    ] := by
  rfl

def R751_substantiveTheoremCount : Nat := 6

end FrontC186_H8ResidualBoundaryCompactDualTargetRankRoute
end HCGapL4
end HodgeReduction
