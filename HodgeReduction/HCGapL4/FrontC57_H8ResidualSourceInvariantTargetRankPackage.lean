/-
# HC Gap L4 -- Front C57: H8 residual source-invariant target-rank package (R598).

R597 rewrites the live residual as Cartan-line source/compact-dual equality
plus rank-one of the cuspidal trivial-module part.  This file removes the
Cartan notation from that package:

* `surjectivity_source = source_invariants`;
* `source_invariants = H8`;
* `finrank target_invariants = 1`.

The rewrite uses only the already formalized Matsushima compact-dual/source
comparison, Cartan's H8 comparison, and the target-invariants/trivial-module
identification.  It does not prove any of the three residual geometric facts.
-/

import HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage
import HodgeReduction.HCGapL4.FrontC30_SourceInvariantsH8TargetRank

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC57_H8ResidualSourceInvariantTargetRankPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC30_SourceInvariantsH8TargetRank
open FrontC36_TargetBettiObstruction
open FrontC56_H8ResidualCartanRankOnePackage

section SourceInvariantTargetRankPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The source-invariant/target-rank spelling of the post-R597 H8 residual
package. -/
structure EVIIH8ResidualSourceInvariantTargetRankObligations where
  source_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B)
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_invariants_rank_one :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) = 1

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R598 substantive theorem (1/6)**: source-invariant/target-rank residual
data implies the R597 Cartan-line rank-one residual package. -/
def cartanRankOneResidual_of_sourceInvariantTargetRankResidual
    (O : EVIIH8ResidualSourceInvariantTargetRankObligations A B) :
    EVIIH8ResidualCartanRankOneObligations A B where
  source_eq_cartan := by
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
        O.source_eq_invariants
      _ = CompactDualData.H8 (A := A) := O.source_invariants_eq_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := A)).symm
  compactDual_eq_cartan := by
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
        MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)
      _ = CompactDualData.H8 (A := A) := O.source_invariants_eq_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := A)).symm
  trivialModulePart_rank_one :=
    trivialModulePart_finrank_eq_one_of_target_invariants_rank_one
      (A := A) (B := B) O.target_invariants_rank_one

/-- **R598 substantive theorem (2/6)**: the R597 Cartan-line rank-one package
implies the source-invariant/target-rank residual package. -/
def sourceInvariantTargetRankResidual_of_cartanRankOneResidual
    (O : EVIIH8ResidualCartanRankOneObligations A B) :
    EVIIH8ResidualSourceInvariantTargetRankObligations A B where
  source_eq_invariants := by
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        O.source_eq_cartan
      _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        O.compactDual_eq_cartan.symm
      _ = MatsushimaData.source_invariants (A := A) (B := B) :=
        MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)
  source_invariants_eq_H8 := by
    calc
      MatsushimaData.source_invariants (A := A) (B := B)
          = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        (MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)).symm
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        O.compactDual_eq_cartan
      _ = CompactDualData.H8 (A := A) :=
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := A)
  target_invariants_rank_one := by
    rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
    exact O.trivialModulePart_rank_one

/-- **R598 substantive theorem (3/6)**: the R597 Cartan-line rank-one package
and the source-invariant/target-rank package are equivalent at the inhabited
package level. -/
theorem residual_cartanRankOne_nonempty_iff_sourceInvariantTargetRank_nonempty :
    Nonempty (EVIIH8ResidualCartanRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantTargetRankObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantTargetRankResidual_of_cartanRankOneResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanRankOneResidual_of_sourceInvariantTargetRankResidual
            (A := A) (B := B) O)))

/-- **R598 substantive theorem (4/6)**: the R594 boundary-data package is
equivalent to the source-invariant/target-rank residual package. -/
theorem residual_boundaryData_nonempty_iff_sourceInvariantTargetRank_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (FrontC53_H8ResidualBoundaryDataPackage.EVIIH8ResidualBoundaryDataObligations A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantTargetRankObligations A B) :=
  (residual_boundaryData_nonempty_iff_cartanRankOne_nonempty
    (A := A) (B := B)).trans
    (residual_cartanRankOne_nonempty_iff_sourceInvariantTargetRank_nonempty
      (A := A) (B := B))

/-- **R598 substantive theorem (5/6)**: source-invariant/target-rank residual
data feeds the existing Matsushima boundary bridge immediately. -/
def matsushimaV56BoundaryData_of_sourceInvariantTargetRankResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceInvariantTargetRankObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_cartanRankOneResidual
    (A := A) (B := B)
    (cartanRankOneResidual_of_sourceInvariantTargetRankResidual
      (A := A) (B := B) O)

end SourceInvariantTargetRankPackage

section Countermodel

/-- **R598 obstruction theorem (6/6)**: the current abstract interface, even
with `compactDual = H8`, still does not force the source-invariant/target-rank
residual package. -/
theorem current_interface_with_compactDual_eq_H8_does_not_force_sourceInvariantTargetRankResidual :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not (EVIIH8ResidualSourceInvariantTargetRankObligations
        TargetBettiSource TargetBettiTarget) := by
  refine And.intro
    current_interface_with_compactDual_eq_H8_does_not_force_cartanRankOneResidual.1
    ?_
  intro O
  exact
    current_interface_with_compactDual_eq_H8_does_not_force_cartanRankOneResidual.2
      (cartanRankOneResidual_of_sourceInvariantTargetRankResidual
        (A := TargetBettiSource) (B := TargetBettiTarget) O)

def R598_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC57_H8ResidualSourceInvariantTargetRankPackage
end HCGapL4
end HodgeReduction
