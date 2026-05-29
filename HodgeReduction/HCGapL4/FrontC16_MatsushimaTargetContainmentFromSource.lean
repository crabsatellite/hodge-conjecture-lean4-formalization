/-
# HC Gap L4 -- Front C16: target containment from source containment (R557).

R556 reduced the EVII Matsushima boundary data to four linear-algebra
obligations: source containment, source finrank, target containment into
the cuspidal trivial-module part, and target finrank.

This file removes one independent obligation.  The target containment
follows formally from:

* source containment in `MatsushimaData.source_invariants`;
* Matsushima equivariance on source invariants;
* the Matsushima surjectivity image equation;
* the R554 target-invariants-to-trivial-module theorem.

So the concrete EVII boundary task is now narrower: prove source
containment, source finrank, and target finrank.
-/

import HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC16_MatsushimaTargetContainmentFromSource

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC15_MatsushimaBoundaryRankCriterion

section TargetFromSource

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

omit [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R557 substantive theorem (1/5)**: if the Matsushima surjectivity
source lies in the source-invariant subspace, then its image under
`j_q` lies in the target-invariant subspace. -/
theorem map_surjectivity_source_le_target_invariants_of_source_le
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B))) :
    LE.le
      (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)))
      (MatsushimaData.target_invariants (A := A) (B := B)) := by
  exact
    (Submodule.map_mono hsource_le).trans
      (MatsushimaData.j_q_image_invariants_subset_target_invariants
        (A := A) (B := B))

omit [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R557 substantive theorem (2/5)**: the surjectivity target itself
lies in the target-invariant subspace, once the source containment is
known. -/
theorem surjectivity_target_le_target_invariants_of_source_le
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B))) :
    LE.le
      (MatsushimaSurjectivityData.surjectivity_target
        (A := A) (B := B))
      (MatsushimaData.target_invariants (A := A) (B := B)) := by
  simpa [MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)]
    using
      map_surjectivity_source_le_target_invariants_of_source_le
        (A := A) (B := B) hsource_le

/-- **R557 substantive theorem (3/5)**: the R556 target-containment
obligation is not independent.  It follows from source containment and
the R554 identification of target invariants with the cuspidal
trivial-module part. -/
theorem surjectivity_target_le_trivialModulePart_of_source_le
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B))) :
    LE.le
      (MatsushimaSurjectivityData.surjectivity_target
        (A := A) (B := B))
      (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  simpa [target_invariants_eq_trivialModulePart (A := A) (B := B)]
    using
      surjectivity_target_le_target_invariants_of_source_le
        (A := A) (B := B) hsource_le

/-- **R557 substantive theorem (4/5)**: the target boundary equality now
follows from source containment plus the target finrank equation. -/
theorem target_eq_invariants_of_source_le_target_finrank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)))
    (htarget_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_target
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  target_eq_invariants_of_target_eq_trivialModulePart
    (A := A) (B := B)
    (target_eq_trivialModulePart_of_le_finrank
      (A := A) (B := B)
      (surjectivity_target_le_trivialModulePart_of_source_le
        (A := A) (B := B) hsource_le)
      htarget_dim)

end TargetFromSource

section BoundaryFromThreeObligations

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R557 substantive theorem (5/5)**: build the R554/R555 boundary
data from only three concrete obligations: source containment, source
finrank, and target finrank.  Target containment is supplied by the
theorems above. -/
def matsushimaV56BoundaryData_of_source_le_source_rank_target_rank
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)))
    (hsource_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)))
    (htarget_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_target
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_rank_criteria
    (A := A) (B := B)
    hsource_le hsource_dim
    (surjectivity_target_le_trivialModulePart_of_source_le
      (A := A) (B := B) hsource_le)
    htarget_dim

end BoundaryFromThreeObligations

def R557_substantiveTheoremCount : Nat := 5

end FrontC16_MatsushimaTargetContainmentFromSource
end HCGapL4
end HodgeReduction
