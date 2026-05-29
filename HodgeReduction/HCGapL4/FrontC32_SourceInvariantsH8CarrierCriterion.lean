/-
# HC Gap L4 -- Front C32: source-invariants H8 carrier criteria (R573).

R572 left the FrontC boundary package with three concrete inputs:

* `surjectivity_source = MatsushimaData.source_invariants`;
* `MatsushimaData.source_invariants = CompactDualData.H8`;
* `finrank target_invariants = shimuraEVIIExpectedBetti 8`.

This file splits the middle source-carrier equality into smaller
geometric targets.  The preferred source route is:

* no extra degree-8 source invariants:
  `MatsushimaData.source_invariants <= CompactDualData.H8`;
* the compact-dual generator is present:
  `h^4` lies in `MatsushimaData.source_invariants`.

Because `CompactDualData.H8` is already `span {h^4}`, those two facts
recover the equality without adding a new axiom or bundled premise.  A
rank-one alternative is also recorded: if `H8 <= source_invariants` and
the source-invariants space is one-dimensional, equality follows.
-/

import HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti
import HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC32_SourceInvariantsH8CarrierCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC23_MatsushimaCompactDualRankOne
open FrontC31_TargetRankFromExpectedBetti

section SourceCarrierCriterion

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]

/-- **R573 substantive theorem (1/5)**: membership of the generator
`h^4` in the Matsushima source-invariants submodule gives the whole
compact-dual `H8` line inside that source submodule. -/
theorem H8_le_source_invariants_of_h_pow_4_mem
    (hh_pow : (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)) :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaData.source_invariants (A := A) (B := B)) := by
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.span_le.mpr (by
    intro x hx
    rw [Set.mem_singleton_iff] at hx
    rw [hx]
    exact hh_pow)

/-- **R573 substantive theorem (2/5)**: the source-invariants/H8 carrier
equality follows from the two concrete source-carrier facts: no extra
source invariants beyond H8, and presence of the generator `h^4`. -/
theorem source_invariants_eq_H8_of_source_le_H8_h_pow_4_mem
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_pow : (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  exact le_antisymm hsource_le_H8
    (H8_le_source_invariants_of_h_pow_4_mem
      (A := A) (B := B) hh_pow)

/-- **R573 substantive theorem (3/5)**: an alternate rank route for the
same source-carrier equality.  If the already-known H8 line is contained
in source invariants and source invariants have rank one, there is no
room for a larger source subspace. -/
theorem source_invariants_eq_H8_of_H8_le_source_rank_one
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    (hH8_le_source :
      LE.le (CompactDualData.H8 (A := A))
        (MatsushimaData.source_invariants (A := A) (B := B)))
    (hsource_rank_one :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) = 1) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  have hdim :
      Module.finrank (R := Rat) (CompactDualData.H8 (A := A)) =
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) := by
    rw [compactDual_H8_finrank_eq_one (A := A), hsource_rank_one]
  exact (Submodule.eq_of_le_of_finrank_eq hH8_le_source hdim).symm

end SourceCarrierCriterion

section BoundaryFromSourceCarrierCriterion

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

/-- **R573 substantive theorem (4/5)**: the R572 boundary package now
consumes the source-carrier split (`source <= H8` plus `h^4` membership)
instead of the bundled equality `source_invariants = H8`. -/
def matsushimaV56BoundaryData_of_source_le_H8_h_pow_4_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_pow : (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_invariants_H8_target_expected_betti8
    (A := A) (B := B)
    hsurj_source
    (source_invariants_eq_H8_of_source_le_H8_h_pow_4_mem
      (A := A) (B := B) hsource_le_H8 hh_pow)
    htarget_betti8

/-- **R573 substantive theorem (5/5)**: the R554 compact-dual image
conclusion follows from the same source-carrier split plus the R572
target expected-Betti bridge. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_le_H8_h_pow_4_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_le_H8 :
      LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_pow : (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_invariants_H8_target_expected_betti8
    (A := A) (B := B)
    hsurj_source
    (source_invariants_eq_H8_of_source_le_H8_h_pow_4_mem
      (A := A) (B := B) hsource_le_H8 hh_pow)
    htarget_betti8

def R573_substantiveTheoremCount : Nat := 5

end BoundaryFromSourceCarrierCriterion

end FrontC32_SourceInvariantsH8CarrierCriterion
end HCGapL4
end HodgeReduction
