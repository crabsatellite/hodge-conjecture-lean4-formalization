/-
# HC Gap L4 -- Front C183: latest route as rank-one generator attack (R748).

R747 reconnects the latest route to four concrete targets:

* `MatsushimaV56BoundaryData`;
* `h^4 in compactDual`;
* finite-dimensional `compactDual`;
* `finrank compactDual <= 1`.

This file removes one bookkeeping target.  Once `h^4 in compactDual` is fixed,
the nonzero generator makes `compactDual` nontrivial, so finite-dimensionality
plus `finrank <= 1` is equivalent to the exact rank statement
`finrank compactDual = 1`.  Conversely, exact rank one supplies the
finite-dimensional witness and the upper bound.

No boundary data, generator membership, rank-one theorem, or closure theorem is
proved here.
-/

import HodgeReduction.HCGapL4.FrontC182_H8ResidualLatestRouteFiniteRankAttack

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC182_H8ResidualLatestRouteFiniteRankAttack

section RankOneGeneratorAttack

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

/-- Boundary data plus generator placement and exact rank one for
`compactDual`.  This is the R748 three-target spelling of the R747 finite-rank
surface.
-/
structure EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract
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
  compactDual_finrank_eq_one :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1

/-- **R748 substantive theorem (1/7)**: the R747 finite-rank carrier
contract gives exact rank one because `h^4` is a nonzero element of
`compactDual`.
-/
theorem compactDual_finrank_eq_one_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1 := by
  haveI :
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    O.compactDual_finite
  let h4c :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
    ⟨(KaehlerClass.h : A) ^ 4, O.h_pow_four_mem_compactDual⟩
  have h4c_ne : Not (h4c = 0) := by
    intro hzero
    exact KaehlerClass.h_pow_4_ne_zero (A := A)
      (congrArg Subtype.val hzero)
  haveI :
      Nontrivial
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    ⟨h4c, 0, h4c_ne⟩
  have hpos :
      0 < Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    Module.finrank_pos
      (R := Rat)
      (M := MatsushimaCompactDualData.compactDual (A := A) (B := B))
  have hle :
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1 :=
    O.compactDual_finrank_le_one
  omega

/-- **R748 substantive theorem (2/7)**: the finite-rank carrier contract
feeds the exact rank-one generator contract.
-/
def rankOneGeneratorContract_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B where
  boundary := O.boundary
  h_pow_four_mem_compactDual := O.h_pow_four_mem_compactDual
  compactDual_finrank_eq_one :=
    compactDual_finrank_eq_one_of_finiteRankCarrierContract
      (A := A) (B := B) O

/-- **R748 substantive theorem (3/7)**: exact rank one supplies the
finite-dimensional witness and rank upper bound required by R747.
-/
def finiteRankCarrierContract_of_rankOneGeneratorContract
    (O : EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B where
  boundary := O.boundary
  compactDual_finite :=
    Module.finite_of_finrank_eq_succ
      (R := Rat)
      (M := MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (n := 0)
      O.compactDual_finrank_eq_one
  compactDual_finrank_le_one := by
    rw [O.compactDual_finrank_eq_one]
  h_pow_four_mem_compactDual := O.h_pow_four_mem_compactDual

/-- **R748 substantive theorem (4/7)**: the R747 finite-rank surface and the
rank-one generator surface are the same inhabited residual contract.
-/
theorem residual_compactDualFiniteRank_latest_nonempty_iff_rankOneGenerator_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (rankOneGeneratorContract_of_finiteRankCarrierContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteRankCarrierContract_of_rankOneGeneratorContract
            (A := A) (B := B) O)))

/-- **R748 substantive theorem (5/7)**: reverse orientation of the same
equivalence.
-/
theorem residual_rankOneGenerator_nonempty_iff_compactDualFiniteRank_latest_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  (residual_compactDualFiniteRank_latest_nonempty_iff_rankOneGenerator_nonempty
    (A := A) (B := B)).symm

/-- **R748 substantive theorem (6/7)**: the R746 boundary-plus-Cartan route
is exactly the rank-one generator attack surface.
-/
theorem residual_boundaryDataCartan_nonempty_iff_rankOneGenerator_latest_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) :=
  (residual_boundaryDataCartan_nonempty_iff_compactDualFiniteRank_latest_nonempty
    (A := A) (B := B)).trans
    (residual_compactDualFiniteRank_latest_nonempty_iff_rankOneGenerator_nonempty
      (A := A) (B := B))

/-- **R748 substantive theorem (7/7)**: the latest R745/R746 route has the
same three-target rank-one generator attack surface.
-/
theorem residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_rankOneGenerator_latest_nonempty :
    Nonempty
        (FrontC180_H8ResidualCartanImageSurjectivityCurrentRoute.EVIIH8ResidualBoundaryDataH8ContainmentCartanImageSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) :=
  (residual_H8ContainmentCartanImageSurjectivity_nonempty_iff_compactDualFiniteRank_latest_nonempty
    (A := A) (B := B)).trans
    (residual_compactDualFiniteRank_latest_nonempty_iff_rankOneGenerator_nonempty
      (A := A) (B := B))

end RankOneGeneratorAttack

/-- R748 target names for route summaries. -/
def currentR748RankOneGeneratorTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in compactDual",
  "prove finrank compactDual = 1"
]

/-- Machine-readable status for the R748 rank-one generator attack surface. -/
structure R748RankOneGeneratorSnapshot where
  proofWorkObligationCount : Nat
  finiteRankSurfaceEquivalentToRankOneGenerator : Bool
  boundaryCartanEquivalentToRankOneGenerator : Bool
  latestH8ReverseCartanRouteEquivalentToRankOneGenerator : Bool
  exactRankOneSuppliesFiniteDimensionality : Bool
  generatorPlusFiniteRankUpperBoundSuppliesExactRankOne : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualGeneratorMembership : Bool
  provesCompactDualRankOne : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R748 status: the finite-dimensionality and rank-bound fields of
R747 have been merged into the exact rank-one target.
-/
def currentR748RankOneGeneratorSnapshot :
    R748RankOneGeneratorSnapshot where
  proofWorkObligationCount := currentR748RankOneGeneratorTargetNames.length
  finiteRankSurfaceEquivalentToRankOneGenerator := true
  boundaryCartanEquivalentToRankOneGenerator := true
  latestH8ReverseCartanRouteEquivalentToRankOneGenerator := true
  exactRankOneSuppliesFiniteDimensionality := true
  generatorPlusFiniteRankUpperBoundSuppliesExactRankOne := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualGeneratorMembership := false
  provesCompactDualRankOne := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R748 route refinement. -/
theorem currentR748RankOneGeneratorSnapshot_eq_texStatus :
    currentR748RankOneGeneratorSnapshot =
      ({ proofWorkObligationCount := 3
         finiteRankSurfaceEquivalentToRankOneGenerator := true
         boundaryCartanEquivalentToRankOneGenerator := true
         latestH8ReverseCartanRouteEquivalentToRankOneGenerator := true
         exactRankOneSuppliesFiniteDimensionality := true
         generatorPlusFiniteRankUpperBoundSuppliesExactRankOne := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualGeneratorMembership := false
         provesCompactDualRankOne := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R748RankOneGeneratorSnapshot) := by
  decide

/-- Kernel-checked target names for the R748 route refinement. -/
theorem currentR748RankOneGeneratorTargetNames_eq_texStatus :
    currentR748RankOneGeneratorTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in compactDual",
      "prove finrank compactDual = 1"
    ] := by
  rfl

def R748_substantiveTheoremCount : Nat := 7

end FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack
end HCGapL4
end HodgeReduction
