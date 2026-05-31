/-
# HC Gap L4 -- Front C58: H8 residual source-invariant normalization (R599).

R598 states the live residual as the primitive Matsushima targets

* `surjectivity_source = source_invariants`;
* `source_invariants = H8`;
* `finrank target_invariants = 1`.

R591 had already named the same target in the H8-carrier form

* `surjectivity_source = H8`;
* `compactDual = H8`;
* `finrank target_invariants = 1`.

The existing Matsushima compact-dual/source comparison makes these packages
directly equivalent.  This file records that normalization so the paper ledger
can point to one residual target without routing through the later Cartan-line
spelling.  No EVII/Matsushima geometric fact is proved here.
-/

import HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC58_H8ResidualSourceInvariantNormalization

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open FrontC50_H8ResidualObligationPackage
open FrontC57_H8ResidualSourceInvariantTargetRankPackage

section Normalization

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R599 substantive theorem (1/5)**: the R598 source-invariant package
implies the R591 H8/rank-one residual package. -/
def residualRankOne_of_sourceInvariantTargetRankResidual
    (O : EVIIH8ResidualSourceInvariantTargetRankObligations A B) :
    EVIIH8ResidualRankOneObligations A B where
  source_eq_H8 := O.source_eq_invariants.trans O.source_invariants_eq_H8
  compactDual_eq_H8 := by
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
        MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)
      _ = CompactDualData.H8 (A := A) := O.source_invariants_eq_H8
  target_rank_one := O.target_invariants_rank_one

/-- **R599 substantive theorem (2/5)**: the R591 H8/rank-one residual package
implies the R598 source-invariant package. -/
def sourceInvariantTargetRankResidual_of_residualRankOne
    (O : EVIIH8ResidualRankOneObligations A B) :
    EVIIH8ResidualSourceInvariantTargetRankObligations A B where
  source_eq_invariants := by
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = CompactDualData.H8 (A := A) := O.source_eq_H8
      _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        O.compactDual_eq_H8.symm
      _ = MatsushimaData.source_invariants (A := A) (B := B) :=
        MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)
  source_invariants_eq_H8 := by
    calc
      MatsushimaData.source_invariants (A := A) (B := B)
          = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        (MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)).symm
      _ = CompactDualData.H8 (A := A) := O.compactDual_eq_H8
  target_invariants_rank_one := O.target_rank_one

/-- **R599 substantive theorem (3/5)**: R591 and R598 are the same residual
target at the inhabited-package level. -/
theorem residual_rankOne_nonempty_iff_sourceInvariantTargetRank_nonempty :
    Nonempty (EVIIH8ResidualRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantTargetRankObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantTargetRankResidual_of_residualRankOne
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (residualRankOne_of_sourceInvariantTargetRankResidual
            (A := A) (B := B) O)))

/-- **R599 substantive theorem (4/5)**: a source-invariant residual package
recovers the degree-8 expected-Betti target rank used by the earlier FrontC
route. -/
theorem target_expected_betti8_of_sourceInvariantTargetRankResidual
    (O : EVIIH8ResidualSourceInvariantTargetRankObligations A B) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBetti 8 :=
  target_expected_betti8_of_residual_obligations
    (A := A) (B := B)
    (residualRankOne_of_sourceInvariantTargetRankResidual
      (A := A) (B := B) O)

end Normalization

section Countermodel

/-- **R599 obstruction theorem (5/5)**: even if the current abstract interface
identifies `source_invariants` with `H8`, it still does not force the full
source-invariant/target-rank residual package. -/
theorem current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantTargetRankResidual :
    (MatsushimaData.source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget) =
        CompactDualData.H8
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)) /\
      Not (EVIIH8ResidualSourceInvariantTargetRankObligations
        FrontC36_TargetBettiObstruction.TargetBettiSource
        FrontC36_TargetBettiObstruction.TargetBettiTarget) := by
  refine And.intro ?_
    current_interface_with_compactDual_eq_H8_does_not_force_sourceInvariantTargetRankResidual.2
  calc
    MatsushimaData.source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)
        =
      MatsushimaCompactDualData.compactDual
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget) :=
        (MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)).symm
    _ = CompactDualData.H8
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource) :=
        current_interface_with_compactDual_eq_H8_does_not_force_sourceInvariantTargetRankResidual.1

def R599_substantiveTheoremCount : Nat := 5

end Countermodel

end FrontC58_H8ResidualSourceInvariantNormalization
end HCGapL4
end HodgeReduction
