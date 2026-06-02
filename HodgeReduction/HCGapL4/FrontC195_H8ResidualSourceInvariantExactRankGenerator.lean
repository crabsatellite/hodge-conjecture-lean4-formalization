/-
# HC Gap L4 -- Front C195: source-H8 as generator plus exact rank (R760).

R759 moves the current compact-dual/H8 carrier target to the source-native
statement

  `source_invariants = H8`.

Earlier R710 used a finite-dimensionality witness plus a rank upper bound.
This file records the exact-rank version needed by the current route:

  `source_invariants = H8`
  iff `h^4 in source_invariants` and `finrank source_invariants = 1`.

The reverse direction consumes R710; exact rank one supplies the finite
dimensionality witness and the rank upper bound.  This is a route compression,
not a proof of the generator membership or source rank theorem.
-/

import HodgeReduction.HCGapL4.FrontC194_H8ResidualCompactDualSourceInvariantBridge
import HodgeReduction.HCGapL4.FrontC145_H8ResidualSourceInvariantRankBoundSharpness

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC195_H8ResidualSourceInvariantExactRankGenerator

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC23_MatsushimaCompactDualRankOne
open FrontC145_H8ResidualSourceInvariantRankBoundSharpness
open FrontC194_H8ResidualCompactDualSourceInvariantBridge

section SourceInvariantExactRankGenerator

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

/-- **R760 substantive theorem (1/5)**: source-H8 equality gives source
generator membership. -/
theorem h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [hsource, CompactDualData.H8_eq_span_h_pow_4]
  exact Submodule.subset_span (by simp)

/-- **R760 substantive theorem (2/5)**: source-H8 equality gives exact
source-invariant rank one. -/
theorem source_invariants_finrank_eq_one_of_source_invariants_eq_H8
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat)
      (MatsushimaData.source_invariants (A := A) (B := B)) = 1 := by
  rw [hsource]
  exact compactDual_H8_finrank_eq_one (A := A)

/-- **R760 substantive theorem (3/5)**: source generator membership plus
exact source rank one proves source-H8 equality.  The exact rank theorem
supplies finite-dimensionality and the rank upper bound consumed by R710. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hrank :
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) = 1) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  haveI :
      FiniteDimensional Rat
        (MatsushimaData.source_invariants (A := A) (B := B)) :=
    Module.finite_of_finrank_eq_succ
      (R := Rat)
      (M := MatsushimaData.source_invariants (A := A) (B := B))
      (n := 0)
      hrank
  exact
    (source_invariants_eq_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
      (A := A) (B := B) hh_source).2
      (by
        rw [hrank])

/-- **R760 substantive theorem (4/5)**: the current source-H8 carrier target
is exactly generator membership plus exact source rank one. -/
theorem source_invariants_eq_H8_iff_h_pow_four_mem_and_finrank_eq_one :
    (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      ((MatsushimaData.source_invariants (A := A) (B := B)).carrier
          ((KaehlerClass.h : A) ^ 4) /\
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) = 1) := by
  constructor
  · intro hsource
    exact And.intro
      (h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
        (A := A) (B := B) hsource)
      (source_invariants_finrank_eq_one_of_source_invariants_eq_H8
        (A := A) (B := B) hsource)
  · intro h
    exact source_invariants_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
      (A := A) (B := B) h.1 h.2

/-- **R760 substantive theorem (5/5)**: the exact source-rank/generator
package also gives the latest visible compact-dual/H8 carrier theorem. -/
theorem compactDual_eq_H8_of_source_h_pow_four_mem_and_finrank_eq_one
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hrank :
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) = 1) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_source_invariants_eq_H8
    (A := A) (B := B)
    (source_invariants_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
      (A := A) (B := B) hh_source hrank)

end SourceInvariantExactRankGenerator

/-- R760 target names for route summaries. -/
def currentR760SourceInvariantExactRankGeneratorTargetNames : List String := [
  "prove h^4 in source_invariants",
  "prove finrank source_invariants = 1"
]

/-- Machine-readable status for the R760 exact source-rank route. -/
structure R760SourceInvariantExactRankGeneratorSnapshot where
  sourceH8EquivalentToGeneratorAndExactRank : Bool
  exactRankSuppliesFiniteDimensionality : Bool
  exactRankSuppliesRankBound : Bool
  packageFeedsCompactDualH8 : Bool
  introducesStrongerPremise : Bool
  provesSourceGeneratorMembership : Bool
  provesSourceInvariantExactRank : Bool
  provesSourceH8 : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R760 status: the non-boundary source carrier target is now the
two-field exact source-rank/generator package. -/
def currentR760SourceInvariantExactRankGeneratorSnapshot :
    R760SourceInvariantExactRankGeneratorSnapshot where
  sourceH8EquivalentToGeneratorAndExactRank := true
  exactRankSuppliesFiniteDimensionality := true
  exactRankSuppliesRankBound := true
  packageFeedsCompactDualH8 := true
  introducesStrongerPremise := false
  provesSourceGeneratorMembership := false
  provesSourceInvariantExactRank := false
  provesSourceH8 := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R760 exact source-rank route. -/
theorem currentR760SourceInvariantExactRankGeneratorSnapshot_eq_texStatus :
    currentR760SourceInvariantExactRankGeneratorSnapshot =
      ({ sourceH8EquivalentToGeneratorAndExactRank := true
         exactRankSuppliesFiniteDimensionality := true
         exactRankSuppliesRankBound := true
         packageFeedsCompactDualH8 := true
         introducesStrongerPremise := false
         provesSourceGeneratorMembership := false
         provesSourceInvariantExactRank := false
         provesSourceH8 := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R760SourceInvariantExactRankGeneratorSnapshot) := by
  decide

/-- Kernel-checked target names for the R760 exact source-rank route. -/
theorem currentR760SourceInvariantExactRankGeneratorTargetNames_eq_texStatus :
    currentR760SourceInvariantExactRankGeneratorTargetNames = [
      "prove h^4 in source_invariants",
      "prove finrank source_invariants = 1"
    ] := by
  rfl

def R760_substantiveTheoremCount : Nat := 5

end FrontC195_H8ResidualSourceInvariantExactRankGenerator
end HCGapL4
end HodgeReduction
