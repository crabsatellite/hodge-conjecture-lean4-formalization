/-
# HC Gap L4 -- Front C61: H8 residual compact-dual carrier package (R602).

R601 split the paper-facing residual package into the source-carrier facts

* `source_invariants <= H8`;
* `h^4` lies in `source_invariants`;
* the source equality `surjectivity_source = source_invariants`;
* the target expected-Betti-8 rank.

R574 had already shown that the source-carrier facts can be fed from the
compact-dual carrier facts

* `compactDual <= H8`;
* `h^4` lies in `compactDual`.

This file packages that compact-dual spelling as an equivalent residual target
using the existing `compactDual = source_invariants` interface.  It makes the
next paper-facing geometric obligations land on the compact-dual/Cartan side,
without asserting a new closure theorem.
-/

import HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage
import HodgeReduction.HCGapL4.FrontC33_CompactDualH8CarrierCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC61_H8ResidualCompactDualCarrierPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC33_CompactDualH8CarrierCriterion
open FrontC59_H8ResidualExpectedBettiPackage
open FrontC60_H8ResidualSourceCarrierSplitPackage

section CompactDualCarrierPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- The compact-dual carrier spelling of the R601 expected-Betti residual. -/
structure EVIIH8ResidualCompactDualCarrierExpectedBettiObligations where
  source_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B)
  compactDual_le_H8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A))
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  target_expected_betti8 :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8

variable {A B}

/-- **R602 substantive theorem (1/6)**: the compact-dual carrier package
implies the R601 source-carrier package. -/
def sourceCarrierSplitResidual_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B where
  source_eq_invariants := O.source_eq_invariants
  source_invariants_le_H8 :=
    source_invariants_le_H8_of_compactDual_le_H8
      (A := A) (B := B) O.compactDual_le_H8
  h_pow_four_mem_source_invariants :=
    h_pow_4_mem_source_invariants_of_mem_compactDual
      (A := A) (B := B) O.h_pow_four_mem_compactDual
  target_expected_betti8 := O.target_expected_betti8

/-- **R602 substantive theorem (2/6)**: the R601 source-carrier package
implies the compact-dual carrier package, using the existing
`compactDual = source_invariants` interface. -/
def compactDualCarrierResidual_of_sourceCarrierSplitResidual
    (O : EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B) :
    EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B where
  source_eq_invariants := O.source_eq_invariants
  compactDual_le_H8 :=
    (MatsushimaCompactDualData.compactDual_le_source_invariants
      (A := A) (B := B)).trans O.source_invariants_le_H8
  h_pow_four_mem_compactDual :=
    MatsushimaCompactDualData.source_invariants_le_compactDual
      (A := A) (B := B) O.h_pow_four_mem_source_invariants
  target_expected_betti8 := O.target_expected_betti8

/-- **R602 substantive theorem (3/6)**: the R601 source-carrier package and
the compact-dual carrier package are equivalent at the inhabited-package
level. -/
theorem residual_sourceCarrierSplit_nonempty_iff_compactDualCarrier_nonempty :
    Nonempty (EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B) <->
      Nonempty (EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualCarrierResidual_of_sourceCarrierSplitResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceCarrierSplitResidual_of_compactDualCarrierResidual
            (A := A) (B := B) O)))

/-- **R602 substantive theorem (4/6)**: the compact-dual carrier package
recovers the R600 expected-Betti residual package. -/
def sourceInvariantExpectedBettiResidual_of_compactDualCarrierResidual
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    EVIIH8ResidualSourceInvariantExpectedBettiObligations A B :=
  sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual
    (A := A) (B := B)
    (sourceCarrierSplitResidual_of_compactDualCarrierResidual
      (A := A) (B := B) O)

end CompactDualCarrierPackage

section Boundary

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

/-- **R602 boundary bridge (5/6)**: the compact-dual carrier package feeds the
existing Matsushima boundary bridge by conversion to R601. -/
def matsushimaV56BoundaryData_of_compactDualCarrierResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualCompactDualCarrierExpectedBettiObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_sourceCarrierSplitResidual
    (A := A) (B := B)
    (sourceCarrierSplitResidual_of_compactDualCarrierResidual
      (A := A) (B := B) O)

end Boundary

section Countermodel

/-- **R602 obstruction theorem (6/6)**: even after moving the source-carrier
split to compactDual, the current abstract interface still does not force the
full residual package. -/
theorem current_interface_with_compactDualCarrier_does_not_force_compactDualCarrierResidual :
    ((LE.le
        (MatsushimaCompactDualData.compactDual
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget))
        (CompactDualData.H8
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource))) /\
      (MatsushimaCompactDualData.compactDual
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)).carrier
        ((KaehlerClass.h :
          FrontC36_TargetBettiObstruction.TargetBettiSource) ^ 4)) /\
      Not (EVIIH8ResidualCompactDualCarrierExpectedBettiObligations
        FrontC36_TargetBettiObstruction.TargetBettiSource
        FrontC36_TargetBettiObstruction.TargetBettiTarget) := by
  refine And.intro ?split ?notResidual
  · refine And.intro ?compact_le ?hpow_mem
    · exact
        (MatsushimaCompactDualData.compactDual_le_source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)).trans
          current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual.1.1
    · exact
        MatsushimaCompactDualData.source_invariants_le_compactDual
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)
          current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual.1.2
  · intro O
    exact
      current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual.2
        (sourceCarrierSplitResidual_of_compactDualCarrierResidual
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget) O)

def R602_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC61_H8ResidualCompactDualCarrierPackage
end HCGapL4
end HodgeReduction
