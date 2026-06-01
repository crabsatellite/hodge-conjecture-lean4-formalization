/-
# HC Gap L4 -- Front C155: compact-dual generator as H8 containment (R720).

R719 exposes the live finite-rank route as five primitive targets:

* `surjectivity_source = compactDual`;
* `surjectivity_target = trivialModulePart`;
* `h^4 in compactDual`;
* finite-dimensional `compactDual`;
* `finrank compactDual <= 1`.

The generator target is exactly the carrier containment

  `H8 <= compactDual`,

because `H8 = span {h^4}`.  This file rewrites the R719 route to use that
containment, and records the direct consumer: finite-dimensionality plus
`finrank compactDual <= 1` plus `H8 <= compactDual` proves
`compactDual = H8`.

It does not prove the containment, finite-dimensionality, or the rank bound.
-/

import HodgeReduction.HCGapL4.FrontC154_H8ResidualPrimitiveBoundaryFiniteRankRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC155_H8ResidualCompactDualGeneratorContainmentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC154_H8ResidualPrimitiveBoundaryFiniteRankRoute

section GeneratorContainment

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

/-- **R720 substantive theorem (1/7)**: the generator `h^4` lies in the
designated compact-dual H8 line. -/
theorem h_pow_four_mem_H8 :
    (CompactDualData.H8 (A := A)).carrier ((KaehlerClass.h : A) ^ 4) := by
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

/-- **R720 substantive theorem (2/7)**: the R719 generator-membership target
is exactly the H8 containment `H8 <= compactDual`. -/
theorem H8_le_compactDual_iff_h_pow_four_mem_compactDual :
    LE.le (CompactDualData.H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <->
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) := by
  exact Iff.intro
    (fun hH8_le => hH8_le (h_pow_four_mem_H8 (A := A)))
    (fun hh_compact => by
      rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
      exact Submodule.span_le.mpr (fun x hx => by
        rw [Set.mem_singleton_iff] at hx
        rw [hx]
        exact hh_compact))

/-- **R720 substantive theorem (3/7)**: finite rank plus the H8 containment
recovers the compact-dual-H8 equality target. -/
theorem compactDual_eq_H8_of_finite_rank_le_one_and_H8_le_compactDual
    [FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))]
    (hfin :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1)
    (hH8_le :
      LE.le (CompactDualData.H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  have hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 hH8_le
  have hcompact_le :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)) :=
    compactDual_le_H8_of_finite_rank_le_one_and_h_pow_four_mem
      (A := A) (B := B) hfin hh_compact
  exact le_antisymm hcompact_le hH8_le

end GeneratorContainment

section ContainmentFiniteRankRoute

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

/-- R720 containment spelling of the R719 primitive finite-rank route. -/
structure EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract
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
  H8_le_compactDual :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  compactDual_finite :
    FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  compactDual_finrank_le_one :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1

/-- **R720 substantive theorem (4/7)**: the H8-containment route feeds the
R719 primitive finite-rank route. -/
def primitiveBoundaryFiniteRankContract_of_containmentFiniteRankContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B where
  boundary := O.boundary
  compactDual_finite := O.compactDual_finite
  compactDual_finrank_le_one := O.compactDual_finrank_le_one
  h_pow_four_mem_compactDual :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 O.H8_le_compactDual

/-- **R720 substantive theorem (5/7)**: the R719 primitive finite-rank route
recovers the equivalent H8-containment route. -/
def containmentFiniteRankContract_of_primitiveBoundaryFiniteRankContract
    (O : EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B) :
    EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B where
  boundary := O.boundary
  H8_le_compactDual :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).2 O.h_pow_four_mem_compactDual
  compactDual_finite := O.compactDual_finite
  compactDual_finrank_le_one := O.compactDual_finrank_le_one

/-- **R720 substantive theorem (6/7)**: the R719 primitive finite-rank route
and the H8-containment finite-rank route are the same inhabited residual
contract. -/
theorem residual_primitiveBoundaryFiniteRank_nonempty_iff_containmentFiniteRank_nonempty :
    Nonempty (EVIIH8ResidualPrimitiveBoundaryCompactDualFiniteRankContract A B) <->
      Nonempty
        (EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (containmentFiniteRankContract_of_primitiveBoundaryFiniteRankContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (primitiveBoundaryFiniteRankContract_of_containmentFiniteRankContract
            (A := A) (B := B) O)))

/-- **R720 substantive theorem (7/7)**: the concrete boundary/source-H8
surjectivity route is equivalent to the primitive boundary plus H8-containment
finite-rank attack surface. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_containmentFiniteRank_nonempty :
    Nonempty (FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute.EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty
        (EVIIH8ResidualPrimitiveBoundaryCompactDualContainmentFiniteRankContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_primitiveBoundaryFiniteRank_nonempty
    (A := A) (B := B)).trans
    (residual_primitiveBoundaryFiniteRank_nonempty_iff_containmentFiniteRank_nonempty
      (A := A) (B := B))

end ContainmentFiniteRankRoute

/-- R720 target names for route summaries. -/
def currentR720ContainmentFiniteRankTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove surjectivity_target = trivialModulePart",
  "prove H8 <= compactDual",
  "prove finite-dimensional compactDual",
  "prove finrank compactDual <= 1"
]

/-- Machine-readable status for the R720 containment finite-rank route. -/
structure R720ContainmentFiniteRankSnapshot where
  proofWorkObligationCount : Nat
  generatorMembershipEquivalentToH8Containment : Bool
  finiteRankContainmentGivesCompactDualH8 : Bool
  finiteRankRouteEquivalentToContainmentRoute : Bool
  provesSourceBoundary : Bool
  provesTargetBoundary : Bool
  provesH8Containment : Bool
  provesCompactDualFiniteDimensionality : Bool
  provesCompactDualRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R720 status: the generator placement target is now the geometric
carrier containment `H8 <= compactDual`; it remains open. -/
def currentR720ContainmentFiniteRankSnapshot :
    R720ContainmentFiniteRankSnapshot where
  proofWorkObligationCount := currentR720ContainmentFiniteRankTargetNames.length
  generatorMembershipEquivalentToH8Containment := true
  finiteRankContainmentGivesCompactDualH8 := true
  finiteRankRouteEquivalentToContainmentRoute := true
  provesSourceBoundary := false
  provesTargetBoundary := false
  provesH8Containment := false
  provesCompactDualFiniteDimensionality := false
  provesCompactDualRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R720 route. -/
theorem currentR720ContainmentFiniteRankSnapshot_eq_texStatus :
    currentR720ContainmentFiniteRankSnapshot =
      ({ proofWorkObligationCount := 5
         generatorMembershipEquivalentToH8Containment := true
         finiteRankContainmentGivesCompactDualH8 := true
         finiteRankRouteEquivalentToContainmentRoute := true
         provesSourceBoundary := false
         provesTargetBoundary := false
         provesH8Containment := false
         provesCompactDualFiniteDimensionality := false
         provesCompactDualRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R720ContainmentFiniteRankSnapshot) := by
  decide

/-- Kernel-checked target names for the R720 route. -/
theorem currentR720ContainmentFiniteRankTargetNames_eq_texStatus :
    currentR720ContainmentFiniteRankTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove surjectivity_target = trivialModulePart",
      "prove H8 <= compactDual",
      "prove finite-dimensional compactDual",
      "prove finrank compactDual <= 1"
    ] := by
  rfl

def R720_substantiveTheoremCount : Nat := 7

end FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
end HCGapL4
end HodgeReduction
