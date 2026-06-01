/-
# HC Gap L4 -- Front C156: compact-dual two-containment route (R721).

R720 rewrites the generator target `h^4 in compactDual` as the geometric
containment `H8 <= compactDual`.  The remaining finite-dimensionality and
rank-one obligations are exactly supplied by the opposite containment
`compactDual <= H8`.

This file repackages the live route as four primitive targets:

* `surjectivity_source = compactDual`;
* `surjectivity_target = trivialModulePart`;
* `compactDual <= H8`;
* `H8 <= compactDual`.

It proves only equivalences and consumers.  Neither containment is asserted.
-/

import HodgeReduction.HCGapL4.FrontC155_H8ResidualCompactDualGeneratorContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC156_H8ResidualCompactDualTwoContainmentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC154_H8ResidualPrimitiveBoundaryFiniteRankRoute
open FrontC155_H8ResidualCompactDualGeneratorContainmentRoute

section TwoContainmentCarrier

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

/-- **R721 substantive theorem (1/6)**: two-sided compact-dual containment is
exactly the compact-dual-H8 equality. -/
theorem compactDual_twoContainments_iff_eq_H8 :
    (LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)) /\
      LE.le (CompactDualData.H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) <->
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A) := by
  exact Iff.intro
    (fun h => le_antisymm h.1 h.2)
    (fun h => by
      constructor
      · rw [h]
      · rw [h])

/-- **R721 substantive theorem (2/6)**: the two-containment route directly
recovers the compact-dual-H8 equality target. -/
theorem compactDual_eq_H8_of_twoContainments
    (hcompact_le :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hH8_le :
      LE.le (CompactDualData.H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (compactDual_twoContainments_iff_eq_H8 (A := A) (B := B)).1
    ⟨hcompact_le, hH8_le⟩

end TwoContainmentCarrier

section TwoContainmentRoute

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

/-- R721 two-containment spelling of the live primitive route. -/
structure EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract
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
  compactDual_le_H8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A))
  H8_le_compactDual :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))

/-- **R721 substantive theorem (3/6)**: two compact-dual containments supply
the R720 containment finite-rank contract. -/
def containmentFiniteRankContract_of_twoContainmentContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  compactDual_finite :=
    compactDual_finiteDimensional_of_compactDual_le_H8
      (A := A) (B := B) O.compactDual_le_H8
  compactDual_finrank_le_one :=
    compactDual_finrank_le_one_of_compactDual_le_H8
      (A := A) (B := B) O.compactDual_le_H8

/-- **R721 substantive theorem (4/6)**: the R720 finite-rank containment
contract recovers the equivalent two-containment route. -/
def twoContainmentContract_of_containmentFiniteRankContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B := by
  haveI :
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    O.compactDual_finite
  have hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 O.H8_le_compactDual
  exact
    { boundary := O.boundary
      compactDual_le_H8 :=
        compactDual_le_H8_of_finite_rank_le_one_and_h_pow_four_mem
          (A := A) (B := B)
          O.compactDual_finrank_le_one
          hh_compact
      H8_le_compactDual := O.H8_le_compactDual }

/-- **R721 substantive theorem (5/6)**: the R720 finite-rank containment route
and the two-containment route are the same inhabited residual contract. -/
theorem residual_containmentFiniteRank_nonempty_iff_twoContainment_nonempty :
    Nonempty
        (EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B) <->
      Nonempty
        (EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (twoContainmentContract_of_containmentFiniteRankContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (containmentFiniteRankContract_of_twoContainmentContract
            (A := A) (B := B) O)))

/-- **R721 substantive theorem (6/6)**: the concrete boundary/source-H8 route
is equivalent to primitive boundary plus two compact-dual containments. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_twoContainment_nonempty :
    Nonempty (FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute.EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty
        (EVIIH8ResidualPrimitiveBoundaryCompactDualTwoContainmentContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_containmentFiniteRank_nonempty
    (A := A) (B := B)).trans
    (residual_containmentFiniteRank_nonempty_iff_twoContainment_nonempty
      (A := A) (B := B))

end TwoContainmentRoute

/-- R721 target names for route summaries. -/
def currentR721TwoContainmentTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove surjectivity_target = trivialModulePart",
  "prove compactDual <= H8",
  "prove H8 <= compactDual"
]

/-- Machine-readable status for the R721 two-containment route. -/
structure R721TwoContainmentSnapshot where
  proofWorkObligationCount : Nat
  twoContainmentsEquivalentToCompactDualH8 : Bool
  twoContainmentsSupplyFiniteRankRoute : Bool
  finiteRankRouteEquivalentToTwoContainments : Bool
  provesSourceBoundary : Bool
  provesTargetBoundary : Bool
  provesCompactDualNoExtra : Bool
  provesH8Containment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R721 status: the finite-rank obligations have been collapsed back
to the geometric no-extra containment `compactDual <= H8`; both containment
directions remain open. -/
def currentR721TwoContainmentSnapshot :
    R721TwoContainmentSnapshot where
  proofWorkObligationCount := currentR721TwoContainmentTargetNames.length
  twoContainmentsEquivalentToCompactDualH8 := true
  twoContainmentsSupplyFiniteRankRoute := true
  finiteRankRouteEquivalentToTwoContainments := true
  provesSourceBoundary := false
  provesTargetBoundary := false
  provesCompactDualNoExtra := false
  provesH8Containment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R721 route. -/
theorem currentR721TwoContainmentSnapshot_eq_texStatus :
    currentR721TwoContainmentSnapshot =
      ({ proofWorkObligationCount := 4
         twoContainmentsEquivalentToCompactDualH8 := true
         twoContainmentsSupplyFiniteRankRoute := true
         finiteRankRouteEquivalentToTwoContainments := true
         provesSourceBoundary := false
         provesTargetBoundary := false
         provesCompactDualNoExtra := false
         provesH8Containment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R721TwoContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R721 route. -/
theorem currentR721TwoContainmentTargetNames_eq_texStatus :
    currentR721TwoContainmentTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove surjectivity_target = trivialModulePart",
      "prove compactDual <= H8",
      "prove H8 <= compactDual"
    ] := by
  rfl

def R721_substantiveTheoremCount : Nat := 6

end FrontC156_H8ResidualCompactDualTwoContainmentRoute
end HCGapL4
end HodgeReduction
