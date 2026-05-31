/-
# HC Gap L4 -- Front C60: H8 residual source-carrier split package (R601).

R600 normalized the live residual package to the paper-facing expected-Betti
target rank:

* `surjectivity_source = source_invariants`;
* `source_invariants = H8`;
* `finrank target_invariants = shimuraEVIIExpectedBetti 8`.

This file opens the middle equality back into the two smaller carrier targets
already isolated in R573:

* no extra source invariants beyond `H8`;
* the generator `h^4` lies in the source invariants.

The result is an equivalent residual package whose source-carrier part is
better suited to direct EVII/Matsushima geometry.  No concrete geometric
closure is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage
import HodgeReduction.HCGapL4.FrontC32_SourceInvariantsH8CarrierCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC60_H8ResidualSourceCarrierSplitPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC32_SourceInvariantsH8CarrierCriterion
open FrontC59_H8ResidualExpectedBettiPackage

section SourceCarrierSplitPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]

/-- The source-carrier split spelling of the R600 residual package. -/
structure EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations where
  source_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B)
  source_invariants_le_H8 :
    LE.le (MatsushimaData.source_invariants (A := A) (B := B))
      (CompactDualData.H8 (A := A))
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  target_expected_betti8 :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8

variable {A B}

/-- **R601 substantive theorem (1/6)**: the split source-carrier package
recovers the bundled source-invariants/H8 equality. -/
theorem source_invariants_eq_H8_of_sourceCarrierSplitResidual
    (O : EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_source_le_H8_h_pow_4_mem
    (A := A) (B := B)
    O.source_invariants_le_H8
    O.h_pow_four_mem_source_invariants

omit [MatsushimaSurjectivityData A B] in
/-- **R601 substantive theorem (2/6)**: a bundled source-invariants/H8
equality gives the generator-membership half of the split package. -/
theorem h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [hsource_H8, CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

/-- **R601 substantive theorem (3/6)**: the split source-carrier package
implies the R600 expected-Betti residual package. -/
def sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual
    (O : EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B) :
    EVIIH8ResidualSourceInvariantExpectedBettiObligations A B where
  source_eq_invariants := O.source_eq_invariants
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_sourceCarrierSplitResidual
      (A := A) (B := B) O
  target_expected_betti8 := O.target_expected_betti8

/-- **R601 substantive theorem (4/6)**: the R600 expected-Betti residual
package implies the split source-carrier spelling. -/
def sourceCarrierSplitResidual_of_sourceInvariantExpectedBettiResidual
    (O : EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) :
    EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B where
  source_eq_invariants := O.source_eq_invariants
  source_invariants_le_H8 := by
    rw [O.source_invariants_eq_H8]
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
      (A := A) (B := B) O.source_invariants_eq_H8
  target_expected_betti8 := O.target_expected_betti8

/-- **R601 substantive theorem (5/6)**: the R600 package and the split
source-carrier package are equivalent at the inhabited-package level. -/
theorem residual_sourceInvariantExpectedBetti_nonempty_iff_sourceCarrierSplit_nonempty :
    Nonempty (EVIIH8ResidualSourceInvariantExpectedBettiObligations A B) <->
      Nonempty (EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceCarrierSplitResidual_of_sourceInvariantExpectedBettiResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual
            (A := A) (B := B) O)))

end SourceCarrierSplitPackage

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

/-- **R601 boundary bridge**: the split source-carrier package feeds the
existing Matsushima boundary bridge by conversion to R600. -/
def matsushimaV56BoundaryData_of_sourceCarrierSplitResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_sourceInvariantExpectedBettiResidual
    (A := A) (B := B)
    (sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual
      (A := A) (B := B) O)

end Boundary

section Countermodel

/-- **R601 obstruction theorem (6/6)**: even after splitting the
source-invariants/H8 equality into `source_invariants <= H8` plus `h^4`
membership, the current abstract interface does not force the full residual
package. -/
theorem current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual :
    ((LE.le
        (MatsushimaData.source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget))
        (CompactDualData.H8
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource))) /\
      (MatsushimaData.source_invariants
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)).carrier
        ((KaehlerClass.h :
          FrontC36_TargetBettiObstruction.TargetBettiSource) ^ 4)) /\
      Not (EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations
        FrontC36_TargetBettiObstruction.TargetBettiSource
        FrontC36_TargetBettiObstruction.TargetBettiTarget) := by
  refine And.intro ?split ?notResidual
  · refine And.intro ?source_le ?hpow_mem
    · rw [current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual.1]
    · exact
        h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget)
          current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual.1
  · intro O
    exact
      current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual.2
        (sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual
          (A := FrontC36_TargetBettiObstruction.TargetBettiSource)
          (B := FrontC36_TargetBettiObstruction.TargetBettiTarget) O)

def R601_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC60_H8ResidualSourceCarrierSplitPackage
end HCGapL4
end HodgeReduction
