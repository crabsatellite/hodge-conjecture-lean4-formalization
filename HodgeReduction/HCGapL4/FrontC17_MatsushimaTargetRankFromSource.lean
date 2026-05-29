/-
# HC Gap L4 -- Front C17: target rank transported from source rank (R558).

R557 removed target containment as an independent EVII obligation.  This
file removes the target finrank calculation as an independent target-side
calculation: the Matsushima image equation and injectivity of `j_q` imply
that the surjectivity target has the same finrank as the surjectivity
source.

The remaining concrete EVII work is therefore concentrated on the source:

* source containment in `MatsushimaData.source_invariants`;
* source finrank against `MatsushimaData.source_invariants`;
* source finrank against the cuspidal trivial-module target.

No concrete EVII instance is invented here; this is only the linear
algebra forced by the existing Matsushima interface.
-/

import HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC17_MatsushimaTargetRankFromSource

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC16_MatsushimaTargetContainmentFromSource

section TargetRankFromSource

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]

/-- **R558 substantive theorem (1/5)**: the image of the Matsushima
surjectivity source has the same finrank as the source, because `j_q` is
injective. -/
theorem finrank_map_surjectivity_source_eq_source :
    Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B))) =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)) := by
  simpa using
    (Submodule.equivMapOfInjective
      (MatsushimaData.j_q (A := A) (B := B))
      (MatsushimaData.j_q_injective (A := A) (B := B))
      (MatsushimaSurjectivityData.surjectivity_source
        (A := A) (B := B))).symm.finrank_eq

/-- **R558 substantive theorem (2/5)**: the surjectivity target has the
same finrank as the surjectivity source.  This is the target-rank
version of the Matsushima image equation. -/
theorem surjectivity_target_finrank_eq_source :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B))) := by
        rw [← MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)]
    _ =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)) :=
        finrank_map_surjectivity_source_eq_source
          (A := A) (B := B)

/-- **R558 substantive theorem (3/5)**: the R557 target-finrank
obligation follows from a source-to-cuspidal-trivial rank equation. -/
theorem target_finrank_eq_trivialModulePart_of_source_finrank_trivial
    [CuspidalCohomologyData B]
    (hsource_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)) :=
        surjectivity_target_finrank_eq_source
          (A := A) (B := B)
    _ =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
        hsource_trivial_dim

/-- **R558 substantive theorem (4/5)**: equivalently, target finrank is
forced by the source finrank plus a rank bridge from source invariants to
the cuspidal trivial-module part. -/
theorem target_finrank_eq_trivialModulePart_of_source_rank_and_invariant_rank
    [CuspidalCohomologyData B]
    (hsource_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)))
    (hinvariant_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
  target_finrank_eq_trivialModulePart_of_source_finrank_trivial
    (A := A) (B := B)
    (hsource_dim.trans hinvariant_trivial_dim)

end TargetRankFromSource

section BoundaryFromTransportedTargetRank

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R558 substantive theorem (5/5)**: build the R554/R555 boundary
data without a separate target-side finrank proof.  The target finrank is
transported from the source by injectivity of `j_q` and the Matsushima
surjectivity image equation. -/
def matsushimaV56BoundaryData_of_source_le_source_rank_source_to_trivial_rank
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
    (hsource_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_le_source_rank_target_rank
    (A := A) (B := B)
    hsource_le hsource_dim
    (target_finrank_eq_trivialModulePart_of_source_finrank_trivial
      (A := A) (B := B) hsource_trivial_dim)

end BoundaryFromTransportedTargetRank

def R558_substantiveTheoremCount : Nat := 5

end FrontC17_MatsushimaTargetRankFromSource
end HCGapL4
end HodgeReduction
