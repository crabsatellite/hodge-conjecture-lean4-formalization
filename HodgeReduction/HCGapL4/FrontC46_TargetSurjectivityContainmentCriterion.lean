/-
# HC Gap L4 -- Front C46: target boundary as one containment (R587).

R586 shows that the two H8 carrier equalities

* `surjectivity_source = H8`;
* `compactDual = H8`;

do not force the target boundary equality.  This file isolates the
exact remaining target-side direction without adding a bundled premise:
after the two H8 carrier equalities, the reverse containment

`trivialModulePart <= surjectivity_target`

is equivalent to the target boundary equality, to the target Hodge-sum
rank, and to the R554 `MatsushimaV56BoundaryData` package.  The forward
containment `surjectivity_target <= trivialModulePart` is already forced
by source containment via Matsushima equivariance.

So the live FrontC target is now concrete: prove this target-surjectivity
containment from genuine EVII / Matsushima geometry, or close one of the
two H8 carrier equalities.  The R586 countermodel is restated at the end
to prevent later agents from trying to derive the containment from the
abstract H8 carrier interface alone.
-/

import HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC46_TargetSurjectivityContainmentCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction

section TargetContainmentCriterion

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
/-- **R587 substantive theorem (1/6)**: after the two H8 carrier
equalities, the already-known source containment forces the target
containment `surjectivity_target <= trivialModulePart`.  Thus the only
missing target-boundary direction is the reverse containment. -/
theorem surjectivity_target_le_trivialModulePart_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    LE.le
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
      (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  have hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
    rw [HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.source_eq_source_invariants_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8]
  exact
    HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.surjectivity_target_le_trivialModulePart_of_source_le
      (A := A) (B := B) hsource_le

omit [CartanCompactDualIso A] in
/-- **R587 substantive theorem (2/6)**: under the two H8 carrier
equalities, the target boundary equality is exactly the reverse
containment `trivialModulePart <= surjectivity_target`. -/
theorem target_boundary_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) <->
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
  constructor
  · intro htarget_eq_trivial
    exact le_of_eq htarget_eq_trivial.symm
  · intro htrivial_le_target
    exact
      le_antisymm
        (surjectivity_target_le_trivialModulePart_of_source_compactDual_eq_H8
          (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)
        htrivial_le_target

omit [CartanCompactDualIso A] in
/-- **R587 substantive theorem (3/6)**: under the two H8 carrier
equalities, the target Hodge-sum rank is equivalent to the single
target-surjectivity containment. -/
theorem target_hodgeSum8_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
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
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :=
  (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (target_boundary_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R587 substantive theorem (4/6)**: under the two H8 carrier
equalities, the R554 boundary-data package is also equivalent to the
single target-surjectivity containment. -/
theorem matsushimaV56BoundaryData_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaV56BoundaryData A B <->
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
  constructor
  · intro D
    exact
      (target_boundary_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).1
        (HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence.surjectivity_target_eq_trivialModulePart_of_boundaryData
          (A := A) (B := B) D)
  · intro htrivial_le_target
    exact
      HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8
        ((target_boundary_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
          (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).2 htrivial_le_target)

omit [CartanCompactDualIso A] in
/-- **R587 substantive theorem (5/6)**: positive constructor form for
the live target.  Once the two H8 carrier equalities and the reverse
target containment are proved from genuine geometry, the old boundary
data package follows. -/
def matsushimaV56BoundaryData_of_H8_and_trivialModulePart_le_surjectivity_target
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htrivial_le_target :
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))) :
    MatsushimaV56BoundaryData A B :=
  (matsushimaV56BoundaryData_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
    (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).2
    htrivial_le_target

end TargetContainmentCriterion

section Countermodel

/-- **R587 substantive theorem (6/6)**: the R586 countermodel also
fails the isolated reverse containment.  Therefore this containment is
a genuine target-side geometry theorem, not a consequence of the current
abstract H8 carrier interface. -/
theorem counterexample_not_trivialModulePart_le_surjectivity_target :
    Not
      (LE.le
        (CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget))
        (MatsushimaSurjectivityData.surjectivity_target
          (A := TargetBettiSource) (B := TargetBettiTarget))) := by
  intro htrivial_le_target
  have htarget_trivial :
      MatsushimaSurjectivityData.surjectivity_target
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget) :=
    (target_boundary_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
      (A := TargetBettiSource) (B := TargetBettiTarget)
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8
      HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8).2
      htrivial_le_target
  exact
    HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_not_matsushimaV56BoundaryData
      (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
        (A := TargetBettiSource) (B := TargetBettiTarget)
        HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8
        HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8
        htarget_trivial)

def R587_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC46_TargetSurjectivityContainmentCriterion
end HCGapL4
end HodgeReduction
