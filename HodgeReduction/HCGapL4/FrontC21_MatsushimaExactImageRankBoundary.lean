/-
# HC Gap L4 -- Front C21: exact image plus rank closes target boundary (R562).

R561 reduced the Matsushima boundary problem to two EVII-specific facts:

* the compact-dual source maps exactly to the designated surjectivity target;
* that target is the Matsushima target-invariant subspace.

This file removes the second fact as an independent subspace-equality
obligation.  Once the compact-dual exact image is known, Matsushima
equivariance gives the target containment automatically.  The remaining
target equality follows from one finite-dimensional rank bridge against
the cuspidal trivial-module part.

So the next concrete EVII target is narrower:

* prove `Submodule.map j_q compactDual = surjectivity_target`;
* prove `finrank compactDual = finrank trivialModulePart`.

No concrete EVII instance, axiom, or bundled stronger premise is added.
-/

import HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC21_MatsushimaExactImageRankBoundary

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC15_MatsushimaBoundaryRankCriterion
open FrontC20_MatsushimaCompactDualExactImageCriterion

section ExactImageRankBoundary

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R562 substantive theorem (1/5)**: compact-dual exact image turns
Matsushima equivariance into the target containment needed by the R556
rank criterion. -/
theorem surjectivity_target_le_trivialModulePart_of_compactDual_exact_image
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :
    LE.le
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
      (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  have htarget_invariants :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
    have hmap :
        LE.le
          (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
      MatsushimaCompactDualData.map_compactDual_le_target_invariants
        (A := A) (B := B)
    simpa [hcompact_image] using hmap
  have htarget_trivial :
      LE.le
        (MatsushimaData.target_invariants (A := A) (B := B))
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
    rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
  exact htarget_invariants.trans htarget_trivial

omit [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R562 substantive theorem (2/5)**: compact-dual exact image
transports the compact-dual/trivial-module rank bridge to the
surjectivity target. -/
theorem surjectivity_target_finrank_eq_trivialModulePart_of_exact_image_rank
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
        exact
          (compactDual_finrank_eq_surjectivity_target_of_exact_image
            (A := A) (B := B) hcompact_image).symm
    _ =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
        hcompact_trivial_dim

/-- **R562 substantive theorem (3/5)**: the R561 target exactness follows
from compact-dual exact image plus a compact-dual-to-trivial rank bridge.
Thus the target subspace equality is no longer an independent EVII
obligation. -/
theorem target_eq_invariants_of_compactDual_exact_image_trivial_rank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  exact
    target_eq_invariants_of_target_eq_trivialModulePart
      (A := A) (B := B)
      (target_eq_trivialModulePart_of_le_finrank
        (A := A) (B := B)
        (surjectivity_target_le_trivialModulePart_of_compactDual_exact_image
          (A := A) (B := B) hcompact_image)
        (surjectivity_target_finrank_eq_trivialModulePart_of_exact_image_rank
          (A := A) (B := B) hcompact_image hcompact_trivial_dim))

/-- **R562 substantive theorem (4/5)**: compact-dual exact image plus the
compact-dual-to-trivial rank bridge now builds the full R554/R559
boundary data. -/
def matsushimaV56BoundaryData_of_compactDual_exact_image_trivial_rank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq
    (A := A) (B := B)
    hcompact_image
    (target_eq_invariants_of_compactDual_exact_image_trivial_rank
      (A := A) (B := B) hcompact_image hcompact_trivial_dim)

/-- **R562 substantive theorem (5/5)**: the R554 compact-dual image
conclusion follows from the same narrowed pair of obligations. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_exact_image_rank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  exact
    matsushima_compactDual_image_eq_trivialModulePart
      (A := A) (B := B)
      (matsushimaV56BoundaryData_of_compactDual_exact_image_trivial_rank
        (A := A) (B := B) hcompact_image hcompact_trivial_dim)

def R562_substantiveTheoremCount : Nat := 5

end ExactImageRankBoundary

end FrontC21_MatsushimaExactImageRankBoundary
end HCGapL4
end HodgeReduction
