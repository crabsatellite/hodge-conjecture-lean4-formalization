/-
# HC Gap L4 -- Front C59: H8 residual expected-Betti package (R600).

R599 normalized the R598 source-invariant residual package against the older
R591 H8/rank-one package.  The paper and earlier FrontC route often state the
target rank as the expected Shimura Betti-8 equality instead of the numeral
`1`.

This file records the exact kernel-side equivalence between those two target
rank spellings inside the current source-invariant residual package:

* `surjectivity_source = source_invariants`;
* `source_invariants = H8`;
* `finrank target_invariants = shimuraEVIIExpectedBetti 8`.

No EVII/Matsushima geometric fact is proved here; R600 only removes another
paper/Lean naming ambiguity around the same open residual.
-/

import HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC59_H8ResidualExpectedBettiPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC50_H8ResidualObligationPackage
open FrontC57_H8ResidualSourceInvariantTargetRankPackage
open FrontC58_H8ResidualSourceInvariantNormalization

section ExpectedBettiPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- The expected-Betti spelling of the R598 source-invariant residual package. -/
structure EVIIH8ResidualSourceInvariantExpectedBettiObligations where
  source_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B)
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_expected_betti8 :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8

variable {A B}

/-- **R600 substantive theorem (1/6)**: the R598 rank-one package implies the
expected-Betti spelling. -/
def sourceInvariantExpectedBettiResidual_of_sourceInvariantTargetRankResidual
    (O : EVIIH8ResidualSourceInvariantTargetRankObligations A B) :
    EVIIH8ResidualSourceInvariantExpectedBettiObligations A B where
  source_eq_invariants := O.source_eq_invariants
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_expected_betti8 :=
    target_expected_betti8_of_sourceInvariantTargetRankResidual
      (A := A) (B := B) O

/-- **R600 substantive theorem (2/6)**: the expected-Betti package implies the
R598 rank-one spelling. -/
def sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual
    (O : EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :
    EVIIH8ResidualSourceInvariantTargetRankObligations A B where
  source_eq_invariants := O.source_eq_invariants
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_rank_one :=
    (target_expected_betti8_iff_target_invariants_finrank_eq_one
      (A := A) (B := B)).1 O.target_expected_betti8

/-- **R600 substantive theorem (3/6)**: the R598 rank-one package and the
expected-Betti package are equivalent at the inhabited-package level. -/
theorem residual_sourceInvariantTargetRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty :
    Nonempty (EVIIH8ResidualSourceInvariantTargetRankObligations A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantExpectedBettiResidual_of_sourceInvariantTargetRankResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual
            (A := A) (B := B) O)))

omit [MatsushimaCompactDualData A B] in
/-- **R600 substantive theorem (4/6)**: the expected-Betti spelling recovers
the rank-one target used by R598. -/
theorem target_rank_one_of_sourceInvariantExpectedBettiResidual
    (O : EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) = 1 :=
  (target_expected_betti8_iff_target_invariants_finrank_eq_one
    (A := A) (B := B)).1 O.target_expected_betti8

variable [CartanCompactDualIso A]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R600 substantive theorem (5/6)**: the expected-Betti package feeds the
existing Matsushima boundary bridge by conversion to R598. -/
def matsushimaV56BoundaryData_of_sourceInvariantExpectedBettiResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_sourceInvariantTargetRankResidual
    (A := A) (B := B)
    (sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual
      (A := A) (B := B) O)

end ExpectedBettiPackage

section Countermodel

/-- **R600 obstruction theorem (6/6)**: even with the source-invariants/H8
carrier identification, the current abstract interface does not force the
expected-Betti spelling of the full residual package. -/
theorem current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual :
    (MatsushimaData.source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget) =
        CompactDualData.H8
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)) /\
      Not (EVIIH8ResidualSourceInvariantExpectedBettiObligations
        FrontC36_TargetBettiObstruction.TargetBettiSource
        FrontC36_TargetBettiObstruction.TargetBettiTarget) := by
  refine And.intro
    current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantTargetRankResidual.1
    ?_
  intro O
  exact
    current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantTargetRankResidual.2
      (sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual
        (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
        (B := FrontC36_TargetBettiObstruction.TargetBettiTarget) O)

def R600_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC59_H8ResidualExpectedBettiPackage
end HCGapL4
end HodgeReduction
