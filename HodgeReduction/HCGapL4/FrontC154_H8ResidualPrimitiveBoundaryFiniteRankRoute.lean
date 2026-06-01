/-
# HC Gap L4 -- Front C154: primitive boundary finite-rank route (R719).

R718 exposes the preferred route as boundary data plus the sharp
compact-dual finite-rank attack surface.  The remaining boundary-data input is
still a package with two fields:

* `surjectivity_source = compactDual`;
* `surjectivity_target = target_invariants`.

R554 already proves `target_invariants = trivialModulePart`, so the second
field can be rewritten as the more geometric target-boundary equality

  `surjectivity_target = trivialModulePart`.

This file unfolds R718 into five primitive targets:

* `surjectivity_source = compactDual`;
* `surjectivity_target = trivialModulePart`;
* `h^4 in compactDual`;
* finite-dimensional `compactDual`;
* `finrank compactDual <= 1`.

It proves only equivalences and consumers.  None of these five primitive
targets is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC153_H8ResidualCompactDualFiniteRankAttackRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC154_H8ResidualPrimitiveBoundaryFiniteRankRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC153_H8ResidualCompactDualFiniteRankAttackRoute

section PrimitiveBoundaryData

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

/-- **R719 substantive theorem (1/8)**: the target field of
`MatsushimaV56BoundaryData` can be read as the target-boundary equality
`surjectivity_target = trivialModulePart`, because R554 already proves
`target_invariants = trivialModulePart`. -/
theorem targetBoundary_eq_trivialModulePart_iff_target_eq_invariants :
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) <->
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        MatsushimaData.target_invariants (A := A) (B := B)) := by
  constructor
  · intro htarget
    exact htarget.trans
      (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm
  · intro htarget
    exact htarget.trans
      (target_invariants_eq_trivialModulePart (A := A) (B := B))

/-- Primitive spelling of the two fields inside `MatsushimaV56BoundaryData`. -/
structure EVIIH8ResidualPrimitiveBoundaryDataContract
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
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  surjectivity_target_eq_trivialModulePart :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B)

/-- **R719 substantive theorem (2/8)**: primitive boundary equalities rebuild
the honest `MatsushimaV56BoundaryData` package. -/
def matsushimaV56BoundaryData_of_primitiveBoundaryDataContract
    (O : EVIIH8ResidualPrimitiveBoundaryDataContract A B) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual := O.source_eq_compactDual
  target_eq_invariants :=
    (targetBoundary_eq_trivialModulePart_iff_target_eq_invariants
      (A := A) (B := B)).1 O.surjectivity_target_eq_trivialModulePart

/-- **R719 substantive theorem (3/8)**: honest `MatsushimaV56BoundaryData`
recovers the primitive boundary equalities. -/
def primitiveBoundaryDataContract_of_matsushimaV56BoundaryData
    (D : MatsushimaV56BoundaryData A B) :
    EVIIH8ResidualPrimitiveBoundaryDataContract A B where
  source_eq_compactDual := D.source_eq_compactDual
  surjectivity_target_eq_trivialModulePart :=
    (targetBoundary_eq_trivialModulePart_iff_target_eq_invariants
      (A := A) (B := B)).2 D.target_eq_invariants

/-- **R719 substantive theorem (4/8)**: boundary data and primitive boundary
equalities are the same inhabited residual target. -/
theorem residual_matsushimaV56BoundaryData_nonempty_iff_primitiveBoundaryData_nonempty :
    Nonempty (MatsushimaV56BoundaryData A B) <->
      Nonempty (EVIIH8ResidualPrimitiveBoundaryDataContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun D =>
        Nonempty.intro
          (primitiveBoundaryDataContract_of_matsushimaV56BoundaryData
            (A := A) (B := B) D)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (matsushimaV56BoundaryData_of_primitiveBoundaryDataContract
            (A := A) (B := B) O)))

end PrimitiveBoundaryData

section PrimitiveBoundaryFiniteRank

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

/-- R719 primitive spelling of the R718 finite-rank route.  This replaces the
single `MatsushimaV56BoundaryData` field by its two primitive boundary
equalities. -/
structure EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract
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
  boundary : EVIIH8ResidualPrimitiveBoundaryDataContract A B
  compactDual_finite :
    FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  compactDual_finrank_le_one :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)

/-- **R719 substantive theorem (5/8)**: the primitive boundary finite-rank
contract feeds the R718 finite-rank carrier contract. -/
def finiteRankCarrierContract_of_primitiveBoundaryFiniteRankContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B where
  boundary :=
    matsushimaV56BoundaryData_of_primitiveBoundaryDataContract
      (A := A) (B := B) O.boundary
  compactDual_finite := O.compactDual_finite
  compactDual_finrank_le_one := O.compactDual_finrank_le_one
  h_pow_four_mem_compactDual := O.h_pow_four_mem_compactDual

/-- **R719 substantive theorem (6/8)**: the R718 finite-rank carrier contract
recovers the primitive boundary finite-rank contract. -/
def primitiveBoundaryFiniteRankContract_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B where
  boundary :=
    primitiveBoundaryDataContract_of_matsushimaV56BoundaryData
      (A := A) (B := B) O.boundary
  compactDual_finite := O.compactDual_finite
  compactDual_finrank_le_one := O.compactDual_finrank_le_one
  h_pow_four_mem_compactDual := O.h_pow_four_mem_compactDual

/-- **R719 substantive theorem (7/8)**: the R718 finite-rank route and the
primitive boundary finite-rank route are the same inhabited residual contract. -/
theorem residual_compactDualFiniteRank_nonempty_iff_primitiveBoundaryFiniteRank_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) <->
      Nonempty (EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (primitiveBoundaryFiniteRankContract_of_finiteRankCarrierContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteRankCarrierContract_of_primitiveBoundaryFiniteRankContract
            (A := A) (B := B) O)))

/-- **R719 substantive theorem (8/8)**: the concrete boundary/source-H8
surjectivity route is equivalent to the fully primitive boundary finite-rank
attack surface. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_primitiveBoundaryFiniteRank_nonempty :
    Nonempty (FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute.EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_compactDualFiniteRank_nonempty
    (A := A) (B := B)).trans
    (residual_compactDualFiniteRank_nonempty_iff_primitiveBoundaryFiniteRank_nonempty
      (A := A) (B := B))

end PrimitiveBoundaryFiniteRank

/-- R719 target names for route summaries. -/
def currentR719PrimitiveBoundaryFiniteRankTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove surjectivity_target = trivialModulePart",
  "prove h^4 in compactDual",
  "prove finite-dimensional compactDual",
  "prove finrank compactDual <= 1"
]

/-- Machine-readable status for the R719 primitive boundary finite-rank
route. -/
structure R719PrimitiveBoundaryFiniteRankSnapshot where
  proofWorkObligationCount : Nat
  targetBoundaryEquivalentToTargetInvariants : Bool
  boundaryDataEquivalentToPrimitiveBoundary : Bool
  finiteRankRouteEquivalentToPrimitiveBoundaryFiniteRank : Bool
  provesSourceBoundary : Bool
  provesTargetBoundary : Bool
  provesCompactDualGeneratorMembership : Bool
  provesCompactDualFiniteDimensionality : Bool
  provesCompactDualRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R719 status: the boundary-data input is no longer a black box;
the live route has five explicit primitive targets. -/
def currentR719PrimitiveBoundaryFiniteRankSnapshot :
    R719PrimitiveBoundaryFiniteRankSnapshot where
  proofWorkObligationCount :=
    currentR719PrimitiveBoundaryFiniteRankTargetNames.length
  targetBoundaryEquivalentToTargetInvariants := true
  boundaryDataEquivalentToPrimitiveBoundary := true
  finiteRankRouteEquivalentToPrimitiveBoundaryFiniteRank := true
  provesSourceBoundary := false
  provesTargetBoundary := false
  provesCompactDualGeneratorMembership := false
  provesCompactDualFiniteDimensionality := false
  provesCompactDualRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R719 route. -/
theorem currentR719PrimitiveBoundaryFiniteRankSnapshot_eq_texStatus :
    currentR719PrimitiveBoundaryFiniteRankSnapshot =
      ({ proofWorkObligationCount := 5
         targetBoundaryEquivalentToTargetInvariants := true
         boundaryDataEquivalentToPrimitiveBoundary := true
         finiteRankRouteEquivalentToPrimitiveBoundaryFiniteRank := true
         provesSourceBoundary := false
         provesTargetBoundary := false
         provesCompactDualGeneratorMembership := false
         provesCompactDualFiniteDimensionality := false
         provesCompactDualRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R719PrimitiveBoundaryFiniteRankSnapshot) := by
  decide

/-- Kernel-checked target names for the R719 route. -/
theorem currentR719PrimitiveBoundaryFiniteRankTargetNames_eq_texStatus :
    currentR719PrimitiveBoundaryFiniteRankTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove surjectivity_target = trivialModulePart",
      "prove h^4 in compactDual",
      "prove finite-dimensional compactDual",
      "prove finrank compactDual <= 1"
    ] := by
  rfl

def R719_substantiveTheoremCount : Nat := 8

end FrontC154_H8ResidualPrimitiveBoundaryFiniteRankRoute
end HCGapL4
end HodgeReduction
