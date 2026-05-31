/-
# HC Gap L4 -- Front C51: H8 residual scalar-preimage package (R592).

R591 names the post-R590 residual target as two H8 carrier equalities plus
target-invariant rank one.  Earlier FrontC steps also exposed an element-level
form of the same target: every trivial-module class must be a scalar multiple
of the `h^4` class after applying the Matsushima map.

This file proves that these are the same residual target after the two H8
carrier equalities are fixed.  It does not prove the scalar-preimage theorem;
it turns it into the next kernel-visible EVII geometry target.
-/

import HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC51_H8ResidualScalarPreimagePackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC48_H8BoundaryRankOneCriterion
open FrontC49_H8BoundaryExpectedBettiCriterion
open FrontC50_H8ResidualObligationPackage

section ScalarTarget

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]

/-- The element-level scalar-preimage version of the remaining FrontC target:
every class in the cuspidal trivial-module part is `j_q (r * h^4)` for some
scalar `r : Rat`. -/
def H8ResidualScalarPreimageTarget : Prop :=
  forall beta : B,
    beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
      exists r : Rat,
        MatsushimaData.j_q (A := A) (B := B)
          (r • ((KaehlerClass.h : A) ^ 4)) = beta

end ScalarTarget

section ScalarRankEquivalence

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R592 substantive theorem (1/7)**: after the two H8 carrier
equalities, target-invariant rank one is equivalent to the scalar-preimage
target. -/
theorem target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) = 1) <->
      H8ResidualScalarPreimageTarget A B :=
  (target_expected_betti8_iff_target_invariants_finrank_eq_one
      (A := A) (B := B)).symm.trans
    ((target_expected_betti8_iff_trivialModulePart_finrank_eq_one
        (A := A) (B := B)).trans
      (scalar_preimage_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).symm)

/-- **R592 substantive theorem (2/7)**: after the two H8 carrier equalities,
the expected Betti-8 target is also equivalent to the scalar-preimage target. -/
theorem target_expected_betti8_iff_scalar_preimage_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBetti 8) <->
      H8ResidualScalarPreimageTarget A B :=
  (target_expected_betti8_iff_target_invariants_finrank_eq_one
      (A := A) (B := B)).trans
    (target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)

end ScalarRankEquivalence

section ScalarResidualPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The scalar-preimage spelling of the exact post-R591 residual package. -/
structure EVIIH8ResidualScalarPreimageObligations where
  source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  scalar_preimage :
    H8ResidualScalarPreimageTarget A B

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R592 substantive theorem (3/7)**: scalar-preimage residual data implies
the R591 rank-one residual package. -/
def rankOneResidual_of_scalarPreimageResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualScalarPreimageObligations A B) :
    EVIIH8ResidualRankOneObligations A B where
  source_eq_H8 := O.source_eq_H8
  compactDual_eq_H8 := O.compactDual_eq_H8
  target_rank_one :=
    (target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8
      (A := A) (B := B) O.source_eq_H8 O.compactDual_eq_H8).2
      O.scalar_preimage

/-- **R592 substantive theorem (4/7)**: the R591 rank-one residual package
implies the scalar-preimage residual data. -/
def scalarPreimageResidual_of_rankOneResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualRankOneObligations A B) :
    EVIIH8ResidualScalarPreimageObligations A B where
  source_eq_H8 := O.source_eq_H8
  compactDual_eq_H8 := O.compactDual_eq_H8
  scalar_preimage :=
    (target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8
      (A := A) (B := B) O.source_eq_H8 O.compactDual_eq_H8).1
      O.target_rank_one

/-- **R592 substantive theorem (5/7)**: the two residual packages are
equivalent at the inhabited-package level. -/
theorem residual_rankOne_nonempty_iff_scalarPreimage_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualScalarPreimageObligations A B) := by
  constructor
  · intro h
    rcases h with ⟨O⟩
    exact ⟨scalarPreimageResidual_of_rankOneResidual (A := A) (B := B) O⟩
  · intro h
    rcases h with ⟨O⟩
    exact ⟨rankOneResidual_of_scalarPreimageResidual (A := A) (B := B) O⟩

/-- **R592 substantive theorem (6/7)**: scalar-preimage residual data feeds
the existing Matsushima boundary bridge directly. -/
def matsushimaV56BoundaryData_of_scalarPreimageResidual
    (O : EVIIH8ResidualScalarPreimageObligations A B) :
    MatsushimaV56BoundaryData A B :=
  HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.matsushimaV56BoundaryData_of_H8_and_scalar_preimage
    (A := A) (B := B)
    O.source_eq_H8 O.compactDual_eq_H8 O.scalar_preimage

end ScalarResidualPackage

section Countermodel

/-- **R592 obstruction theorem (7/7)**: even with the two H8 carrier
equalities, the current abstract interface still does not force the
scalar-preimage target. -/
theorem current_interface_with_H8_equalities_does_not_force_scalar_preimage :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (H8ResidualScalarPreimageTarget
          TargetBettiSource TargetBettiTarget) := by
  refine ⟨?_, ?_, ?_⟩
  · exact
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8
  · exact
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8
  · exact
      HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.counterexample_not_scalar_preimage

def R592_substantiveTheoremCount : Nat := 7

end Countermodel

end FrontC51_H8ResidualScalarPreimagePackage
end HCGapL4
end HodgeReduction
