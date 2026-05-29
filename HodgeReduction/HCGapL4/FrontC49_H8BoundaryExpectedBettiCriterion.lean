/-
# HC Gap L4 -- Front C49: H8 boundary as expected Betti rank (R590).

R589 rewrites the remaining H8 target boundary as
`finrank trivialModulePart = 1`.  Earlier FrontC work used the degree-8
expected Shimura Betti slot as the target-side rank obligation.

This file proves that these are the same target under the existing
Eisenstein/cuspidal trivial-module identification:

* `finrank target_invariants = shimuraEVIIExpectedBetti 8`
  iff `finrank trivialModulePart = 1`;
* under the two H8 carrier equalities, `MatsushimaV56BoundaryData` is
  therefore equivalent to the expected-Betti target rank;
* the same target is still not forced by the abstract H8 carrier
  interface.

No new geometry is assumed here.  The result is a route alignment:
future attacks can focus on the two H8 carrier equalities plus one
concrete target-rank theorem.
-/

import HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion
import HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC49_H8BoundaryExpectedBettiCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC48_H8BoundaryRankOneCriterion

section TargetRankEquivalence

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R590 substantive theorem (1/5)**: the expected degree-8 target
rank is exactly the `trivialModulePart` rank-one target.  This is the
reverse direction missing from the older R572 one-way criterion. -/
theorem target_expected_betti8_iff_trivialModulePart_finrank_eq_one :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      shimuraEVIIExpectedBetti 8) <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  constructor
  · intro htarget
    exact
      HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti.trivialModulePart_finrank_eq_one_of_target_expected_betti8
        (A := A) (B := B) htarget
  · intro htrivial
    calc
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B))
          =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) := by
          rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
      _ = 1 := htrivial
      _ = shimuraEVIIExpectedBetti 8 := rfl

end TargetRankEquivalence

section BoundaryExpectedBetti

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

omit [CartanCompactDualIso A] in
/-- **R590 substantive theorem (2/5)**: after the two H8 carrier
equalities, the boundary package is equivalent to the expected-Betti
target-rank theorem. -/
theorem matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaV56BoundaryData A B <->
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8 :=
  (FrontC48_H8BoundaryRankOneCriterion.matsushimaV56BoundaryData_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (target_expected_betti8_iff_trivialModulePart_finrank_eq_one
      (A := A) (B := B)).symm

omit [CartanCompactDualIso A] in
/-- **R590 substantive theorem (3/5)**: constructor form for the next
attack.  Once the two H8 carriers are proved, it is enough to prove the
expected degree-8 target-invariant rank. -/
def matsushimaV56BoundaryData_of_H8_and_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    MatsushimaV56BoundaryData A B :=
  (matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_compactDual_eq_H8
    (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).2 htarget_betti8

omit [CartanCompactDualIso A] in
/-- **R590 substantive theorem (4/5)**: same criterion in the more
primitive carrier form: prove `surjectivity_source = compactDual`,
prove `compactDual = H8`, then prove the expected target rank. -/
theorem matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_eq_compactDual_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_compact :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaV56BoundaryData A B <->
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8 :=
  matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_compactDual_eq_H8
    (A := A) (B := B)
    (hsource_eq_compact.trans hcompact_eq_H8)
    hcompact_eq_H8

end BoundaryExpectedBetti

section Countermodel

/-- **R590 obstruction theorem (5/5)**: even the two H8 carrier
equalities do not force the expected-Betti target rank in the current
abstract interface. -/
theorem current_interface_with_H8_equalities_does_not_force_target_expected_betti8 :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (Module.finrank (R := Rat)
          (MatsushimaData.target_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) =
          shimuraEVIIExpectedBetti 8) := by
  exact
    ⟨HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8,
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8,
      HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction.counterexample_target_expected_betti8_not_forced⟩

def R590_substantiveTheoremCount : Nat := 5

end Countermodel

end FrontC49_H8BoundaryExpectedBettiCriterion
end HCGapL4
end HodgeReduction
