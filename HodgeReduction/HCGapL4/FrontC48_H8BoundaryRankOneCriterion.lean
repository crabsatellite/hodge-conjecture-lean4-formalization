/-
# HC Gap L4 -- Front C48: H8 boundary as trivial rank one (R589).

R588 turns the target-surjectivity containment into scalar preimages from
`h^4`.  This file records the equivalent rank-one form that is often the
more practical EVII target.

After the two H8 carrier equalities,

* `surjectivity_source = H8`;
* `compactDual = H8`;

the Matsushima image target has rank one.  The already-proved containment
`surjectivity_target <= trivialModulePart` then makes the remaining
target boundary equivalent to

`finrank trivialModulePart = 1`.

No new geometry is assumed here.  The countermodel at the end shows that
this rank-one target is not forced by the abstract H8 carrier interface.
-/

import HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC48_H8BoundaryRankOneCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction

section RankOneCriterion

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
/-- **R589 substantive theorem (1/7)**: under the two H8 carrier
equalities, the target boundary equality is equivalent to rank one of
the cuspidal trivial-module part. -/
theorem target_boundary_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  constructor
  · intro htarget_eq_trivial
    rw [← htarget_eq_trivial]
    exact
      HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.surjectivity_target_finrank_eq_one_of_source_eq_H8
        (A := A) (B := B) hsource_eq_H8
  · intro htrivial_rank_one
    have htarget_dim :
        Module.finrank (R := Rat)
            (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) =
          Module.finrank (R := Rat)
            (CuspidalCohomologyData.trivialModulePart (A := B)) := by
      rw [
        HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.surjectivity_target_finrank_eq_one_of_source_eq_H8
          (A := A) (B := B) hsource_eq_H8,
        htrivial_rank_one]
    exact
      HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.target_eq_trivialModulePart_of_le_finrank
        (A := A) (B := B)
        (HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.surjectivity_target_le_trivialModulePart_of_source_compactDual_eq_H8
          (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)
        htarget_dim

omit [CartanCompactDualIso A] in
/-- **R589 substantive theorem (2/7)**: the scalar-preimage target from
R588 is equivalent to the rank-one target under the two H8 carrier
equalities. -/
theorem scalar_preimage_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta) <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 :=
  (HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.target_boundary_iff_scalar_preimage_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).symm.trans
    (target_boundary_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R589 substantive theorem (3/7)**: the R554 boundary-data package is
equivalent to rank one of the trivial-module part after the two H8
carrier equalities are fixed. -/
theorem matsushimaV56BoundaryData_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
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
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 :=
  (HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.matsushimaV56BoundaryData_iff_scalar_preimage_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (scalar_preimage_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R589 substantive theorem (4/7)**: target Hodge-sum rank is also
equivalent to the rank-one target under the two H8 carrier equalities. -/
theorem target_hodgeSum8_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
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
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 :=
  (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (target_boundary_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R589 substantive theorem (5/7)**: constructor form for the next
attack.  After proving the two H8 carriers, it is enough to prove
`finrank trivialModulePart = 1`. -/
def matsushimaV56BoundaryData_of_H8_and_trivialModulePart_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    MatsushimaV56BoundaryData A B :=
  (matsushimaV56BoundaryData_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
    (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).2 htrivial_rank_one

end RankOneCriterion

section Countermodel

/-- **R589 obstruction theorem (6/7)**: in the R577/R586 countermodel,
the trivial-module part is not one-dimensional. -/
theorem counterexample_trivialModulePart_finrank_ne_one :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget)) ≠ 1 := by
  change Module.finrank (R := Rat) (⊤ : Submodule Rat TargetBettiTarget) ≠ 1
  simp [TargetBettiTarget]

/-- **R589 obstruction theorem (7/7)**: the abstract H8 carrier
interface still does not force the rank-one target. -/
theorem current_interface_with_H8_equalities_does_not_force_trivialModulePart_rank_one :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget)) = 1) := by
  exact
    ⟨HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8,
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8,
      counterexample_trivialModulePart_finrank_ne_one⟩

def R589_substantiveTheoremCount : Nat := 7

end Countermodel

end FrontC48_H8BoundaryRankOneCriterion
end HCGapL4
end HodgeReduction
