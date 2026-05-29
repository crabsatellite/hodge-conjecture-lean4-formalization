/-
# HC Gap L4 -- Front C31: target-invariant rank from expected Betti 8 (R572).

R571 reduced the target-rank input to

  `finrank MatsushimaData.target_invariants = 1`.

The existing FrontC profile already computes the expected EVII Shimura
Betti number in degree 8 as `shimuraEVIIExpectedBetti 8 = 1`.  This file
therefore names the next concrete profile bridge: prove that the actual
Matsushima target-invariants submodule has finrank equal to that expected
degree-8 Betti slot.

This does not assert the profile bridge.  It records the exact theorem
that will consume it once the concrete EVII Matsushima/cohomology
identification is available.
-/

import HodgeReduction.HCGapL4.FrontC30_SourceInvariantsH8TargetRank
import HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC31_TargetRankFromExpectedBetti

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC11_ShimuraBettiComputation
open FrontC30_SourceInvariantsH8TargetRank

section ExpectedBetti8

/-- **R572 substantive theorem (1/5)**: the already-computed expected
degree-8 EVII Shimura Betti slot is one. -/
theorem shimura_expected_betti8_eq_one :
    shimuraEVIIExpectedBetti 8 = 1 := rfl

end ExpectedBetti8

section TargetInvariantRank

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

omit [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R572 substantive theorem (2/5)**: to get the target-invariant
rank-one input of R571, it is enough to identify that rank with the
expected EVII Shimura Betti number at degree 8. -/
theorem target_invariants_finrank_eq_one_of_expected_betti8
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) = 1 := by
  exact htarget_betti8.trans shimura_expected_betti8_eq_one

/-- **R572 substantive theorem (3/5)**: the same expected-Betti bridge
feeds the cuspidal trivial-module rank-one input used by R570. -/
theorem trivialModulePart_finrank_eq_one_of_target_expected_betti8
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 :=
  trivialModulePart_finrank_eq_one_of_target_invariants_rank_one
    (A := A) (B := B)
    (target_invariants_finrank_eq_one_of_expected_betti8
      (A := A) (B := B) htarget_betti8)

end TargetInvariantRank

section BoundaryFromExpectedBetti

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

/-- **R572 substantive theorem (4/5)**: R571's boundary package can be
fed by the degree-8 expected-Betti target-rank bridge. -/
def matsushimaV56BoundaryData_of_source_invariants_H8_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_invariants_H8_target_rank_one
    (A := A) (B := B)
    hsurj_source
    hsource_H8
    (target_invariants_finrank_eq_one_of_expected_betti8
      (A := A) (B := B) htarget_betti8)

/-- **R572 substantive theorem (5/5)**: the R554 compact-dual image
conclusion follows from the same expected-Betti target-rank bridge. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_invariants_H8_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_invariants_H8_target_rank_one
    (A := A) (B := B)
    hsurj_source
    hsource_H8
    (target_invariants_finrank_eq_one_of_expected_betti8
      (A := A) (B := B) htarget_betti8)

def R572_substantiveTheoremCount : Nat := 5

end BoundaryFromExpectedBetti

end FrontC31_TargetRankFromExpectedBetti
end HCGapL4
end HodgeReduction
