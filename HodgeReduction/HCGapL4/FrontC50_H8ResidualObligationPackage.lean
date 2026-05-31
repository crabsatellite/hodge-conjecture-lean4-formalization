/-
# HC Gap L4 -- Front C50: H8 residual obligation package (R591).

R590 identifies the remaining FrontC boundary target with three concrete
EVII/Matsushima facts:

* `surjectivity_source = H8`;
* `compactDual = H8`;
* the target degree-8 rank is one, equivalently the expected Betti-8 rank.

This file does not assert any of those geometric facts.  It records the exact
kernel-visible package that a future EVII geometry proof must supply, and proves
that the package feeds the existing `MatsushimaV56BoundaryData` bridge.
-/

import HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC50_H8ResidualObligationPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC31_TargetRankFromExpectedBetti
open FrontC36_TargetBettiObstruction
open FrontC49_H8BoundaryExpectedBettiCriterion

section TargetRankOne

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]

/-- **R591 substantive theorem (1/5)**: the expected degree-8 target
rank statement is exactly target-invariant rank one. -/
theorem target_expected_betti8_iff_target_invariants_finrank_eq_one :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      shimuraEVIIExpectedBetti 8) <->
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) = 1 := by
  constructor
  · intro htarget
    exact
      target_invariants_finrank_eq_one_of_expected_betti8
        (A := A) (B := B) htarget
  · intro htarget_one
    calc
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) = 1 :=
        htarget_one
      _ = shimuraEVIIExpectedBetti 8 := shimura_expected_betti8_eq_one.symm

end TargetRankOne

section ResidualPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- The exact post-R590 residual package for the FrontC EVII boundary route.
Supplying this structure is strictly stronger than the current abstract
interface, and is the concrete geometry target left by R590/R591. -/
structure EVIIH8ResidualRankOneObligations where
  source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_rank_one :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) = 1

variable {A B}

/-- **R591 substantive theorem (2/5)**: the residual rank-one package
recovers the expected-Betti formulation consumed by R590. -/
theorem target_expected_betti8_of_residual_obligations
    (O : EVIIH8ResidualRankOneObligations A B) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      shimuraEVIIExpectedBetti 8 :=
  (target_expected_betti8_iff_target_invariants_finrank_eq_one
    (A := A) (B := B)).2 O.target_rank_one

variable [CartanCompactDualIso A]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

omit [CartanCompactDualIso A] in
/-- **R591 substantive theorem (3/5)**: the residual package feeds the
existing Matsushima boundary data bridge. -/
def matsushimaV56BoundaryData_of_residual_obligations
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualRankOneObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_H8_and_target_expected_betti8
    (A := A) (B := B)
    O.source_eq_H8
    O.compactDual_eq_H8
    (target_expected_betti8_of_residual_obligations (A := A) (B := B) O)

omit [CartanCompactDualIso A] in
/-- **R591 substantive theorem (4/5)**: constructor form without bundling.
The target rank-one theorem can be supplied directly instead of routing
through the expected-Betti spelling. -/
def matsushimaV56BoundaryData_of_H8_and_target_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_rank_one :
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) = 1) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_residual_obligations
    (A := A) (B := B)
    { source_eq_H8 := hsource_eq_H8
      compactDual_eq_H8 := hcompact_eq_H8
      target_rank_one := htarget_rank_one }

end ResidualPackage

section Countermodel

/-- **R591 obstruction theorem (5/5)**: even after the two H8 carrier
equalities, the current abstract interface does not force target-invariant
rank one. -/
theorem current_interface_with_H8_equalities_does_not_force_target_rank_one :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (Module.finrank (R := Rat)
          (MatsushimaData.target_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) = 1) := by
  refine ⟨?_, ?_, ?_⟩
  · exact
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8
  · exact
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8
  · intro htarget_rank_one
    exact
      HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction.counterexample_target_expected_betti8_not_forced
        ((target_expected_betti8_iff_target_invariants_finrank_eq_one
          (A := TargetBettiSource) (B := TargetBettiTarget)).2 htarget_rank_one)

def R591_substantiveTheoremCount : Nat := 5

end Countermodel

end FrontC50_H8ResidualObligationPackage
end HCGapL4
end HodgeReduction
