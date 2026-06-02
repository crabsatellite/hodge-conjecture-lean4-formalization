/-
# HC Gap L4 -- Front C197: exact source rank as no-extra containment (R762).

R760 made the current source-H8 target the pair

  * `h^4 in source_invariants`;
  * `finrank source_invariants = 1`.

R761 shows the rank field cannot replace generator placement.  This file
records the positive companion: once generator placement is fixed, the exact
rank-one field is equivalent to the geometric no-extra containment

  `source_invariants <= H8`.

Thus the next source-native attack can focus on two geometric containments,
`H8 <= source_invariants` and `source_invariants <= H8`, rather than treating
an abstract rank calculation as a separate route.
-/

import HodgeReduction.HCGapL4.FrontC196_H8ResidualExactSourceRankGeneratorIndependence
import HodgeReduction.HCGapL4.FrontC150_H8ResidualSourceTwoSidedContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC197_H8ResidualSourceRankNoExtraEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC148_H8ResidualSourceGeneratorContainmentRoute
open FrontC150_H8ResidualSourceTwoSidedContainmentRoute
open FrontC194_H8ResidualCompactDualSourceInvariantBridge
open FrontC195_H8ResidualSourceInvariantExactRankGenerator

section SourceRankNoExtraEquivalence

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

/-- **R762 substantive theorem (1/5)**: under source generator membership,
exact source rank one implies the no-extra source containment. -/
theorem source_invariants_le_H8_of_h_pow_four_mem_and_finrank_eq_one
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hrank :
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) = 1) :
    LE.le (MatsushimaData.source_invariants (A := A) (B := B))
      (CompactDualData.H8 (A := A)) := by
  rw [source_invariants_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
    (A := A) (B := B) hh_source hrank]

/-- **R762 substantive theorem (2/5)**: under source generator membership,
the no-extra source containment implies exact source rank one. -/
theorem source_invariants_finrank_eq_one_of_h_pow_four_mem_and_source_invariants_le_H8
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    Module.finrank (R := Rat)
      (MatsushimaData.source_invariants (A := A) (B := B)) = 1 := by
  exact
    source_invariants_finrank_eq_one_of_source_invariants_eq_H8
      (A := A) (B := B)
      (le_antisymm hsource_le_H8
        (H8_le_source_invariants_of_h_pow_four_mem_source_invariants
          (A := A) (B := B) hh_source))

/-- **R762 substantive theorem (3/5)**: once generator placement is fixed,
exact source rank one and no-extra source containment are the same target. -/
theorem source_invariants_finrank_eq_one_iff_source_invariants_le_H8_of_h_pow_four_mem
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    (Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) = 1) <->
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)) := by
  constructor
  · intro hrank
    exact source_invariants_le_H8_of_h_pow_four_mem_and_finrank_eq_one
      (A := A) (B := B) hh_source hrank
  · intro hsource_le_H8
    exact
      source_invariants_finrank_eq_one_of_h_pow_four_mem_and_source_invariants_le_H8
        (A := A) (B := B) hh_source hsource_le_H8

/-- **R762 substantive theorem (4/5)**: the source-H8 equality is equivalently
the two geometric source containments: generator placement plus no-extra. -/
theorem source_invariants_eq_H8_iff_h_pow_four_mem_and_source_invariants_le_H8 :
    (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      ((MatsushimaData.source_invariants (A := A) (B := B)).carrier
          ((KaehlerClass.h : A) ^ 4) /\
        LE.le (MatsushimaData.source_invariants (A := A) (B := B))
          (CompactDualData.H8 (A := A))) := by
  constructor
  · intro hsource
    exact
      ⟨h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
          (A := A) (B := B) hsource,
        by
          rw [hsource]⟩
  · intro h
    exact
      le_antisymm h.2
        (H8_le_source_invariants_of_h_pow_four_mem_source_invariants
          (A := A) (B := B) h.1)

/-- **R762 substantive theorem (5/5)**: the geometric generator/no-extra
source pair feeds the visible compact-dual/H8 target. -/
theorem compactDual_eq_H8_of_source_h_pow_four_mem_and_source_invariants_le_H8
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_source_invariants_eq_H8
    (A := A) (B := B)
    ((source_invariants_eq_H8_iff_h_pow_four_mem_and_source_invariants_le_H8
      (A := A) (B := B)).2
      ⟨hh_source, hsource_le_H8⟩)

end SourceRankNoExtraEquivalence

/-- R762 target names for route summaries. -/
def currentR762SourceRankNoExtraEquivalenceTargetNames : List String := [
  "prove H8 <= source_invariants",
  "prove source_invariants <= H8"
]

/-- Machine-readable status for the R762 source-rank/no-extra equivalence. -/
structure R762SourceRankNoExtraEquivalenceSnapshot where
  sourceRankEquivalentToNoExtraUnderGenerator : Bool
  sourceH8EquivalentToTwoContainments : Bool
  twoContainmentsFeedCompactDualH8 : Bool
  exactRankRemainsUsefulAfterGenerator : Bool
  exactRankAloneIsClosureRoute : Bool
  provesH8LeSourceInvariants : Bool
  provesSourceInvariantsLeH8 : Bool
  provesSourceInvariantExactRank : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R762 status: after generator placement, exact source rank one is
just the no-extra source containment target. -/
def currentR762SourceRankNoExtraEquivalenceSnapshot :
    R762SourceRankNoExtraEquivalenceSnapshot where
  sourceRankEquivalentToNoExtraUnderGenerator := true
  sourceH8EquivalentToTwoContainments := true
  twoContainmentsFeedCompactDualH8 := true
  exactRankRemainsUsefulAfterGenerator := true
  exactRankAloneIsClosureRoute := false
  provesH8LeSourceInvariants := false
  provesSourceInvariantsLeH8 := false
  provesSourceInvariantExactRank := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R762 source-rank/no-extra equivalence. -/
theorem currentR762SourceRankNoExtraEquivalenceSnapshot_eq_texStatus :
    currentR762SourceRankNoExtraEquivalenceSnapshot =
      ({ sourceRankEquivalentToNoExtraUnderGenerator := true
         sourceH8EquivalentToTwoContainments := true
         twoContainmentsFeedCompactDualH8 := true
         exactRankRemainsUsefulAfterGenerator := true
         exactRankAloneIsClosureRoute := false
         provesH8LeSourceInvariants := false
         provesSourceInvariantsLeH8 := false
         provesSourceInvariantExactRank := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R762SourceRankNoExtraEquivalenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R762 route. -/
theorem currentR762SourceRankNoExtraEquivalenceTargetNames_eq_texStatus :
    currentR762SourceRankNoExtraEquivalenceTargetNames = [
      "prove H8 <= source_invariants",
      "prove source_invariants <= H8"
    ] := by
  rfl

def R762_substantiveTheoremCount : Nat := 5

end FrontC197_H8ResidualSourceRankNoExtraEquivalence
end HCGapL4
end HodgeReduction
