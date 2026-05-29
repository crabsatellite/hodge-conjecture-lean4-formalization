/-
# HC Gap L4 -- Front C18: source obligations through compact dual (R559).

R558 transported the target finrank obligation back to the Matsushima
source.  This file rewrites the remaining source obligations through the
compact-dual subspace supplied by `MatsushimaCompactDualData`.

The point is semantic rather than cosmetic: the next concrete EVII work
should attack the Cartan/compact-dual source subspace, not an abstract
`source_invariants` name.  The remaining obligations become:

* `surjectivity_source <= compactDual`;
* `finrank surjectivity_source = finrank compactDual`;
* `finrank compactDual = finrank trivialModulePart`.

No new data fields or concrete EVII instances are introduced.
-/

import HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC18_MatsushimaSourceCompactDualRankBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC15_MatsushimaBoundaryRankCriterion
open FrontC17_MatsushimaTargetRankFromSource

section SourceViaCompactDual

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R559 substantive theorem (1/5)**: source containment in
`source_invariants` follows from the geometrically clearer containment
in the compact-dual subspace. -/
theorem source_le_source_invariants_of_source_le_compactDual
    (hsource_compact :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    LE.le
      (MatsushimaSurjectivityData.surjectivity_source
        (A := A) (B := B))
      (MatsushimaData.source_invariants (A := A) (B := B)) :=
  hsource_compact.trans
    (MatsushimaCompactDualData.compactDual_le_source_invariants
      (A := A) (B := B))

/-- **R559 substantive theorem (2/5)**: the R556 source finrank
obligation follows from the same rank equation stated against the
compact-dual source. -/
theorem source_finrank_eq_source_invariants_of_compactDual_rank
    (hsource_compact_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
        hsource_compact_dim
    _ =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
        rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)]

/-- **R559 substantive theorem (3/5)**: the source-to-trivial rank bridge
needed by R558 follows from source-vs-compact-dual rank plus
compact-dual-vs-trivial rank. -/
theorem source_finrank_eq_trivialModulePart_of_compactDual_rank
    [CuspidalCohomologyData B]
    (hsource_compact_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
  hsource_compact_dim.trans hcompact_trivial_dim

/-- **R559 substantive theorem (4/5)**: the exact source equality used by
R555/R556 follows from compact-dual containment and compact-dual rank. -/
theorem source_eq_invariants_of_source_le_compactDual_rank
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    (hsource_compact :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hsource_compact_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) :=
  source_eq_invariants_of_le_finrank
    (A := A) (B := B)
    (source_le_source_invariants_of_source_le_compactDual
      (A := A) (B := B) hsource_compact)
    (source_finrank_eq_source_invariants_of_compactDual_rank
      (A := A) (B := B) hsource_compact_dim)

end SourceViaCompactDual

section BoundaryViaCompactDualRank

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R559 substantive theorem (5/5)**: build the R554/R555 boundary data
from compact-dual source containment/rank plus a compact-dual-to-trivial
rank bridge. -/
def matsushimaV56BoundaryData_of_source_le_compactDual_rank_compactDual_to_trivial_rank
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_compact :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hsource_compact_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_le_source_rank_source_to_trivial_rank
    (A := A) (B := B)
    (source_le_source_invariants_of_source_le_compactDual
      (A := A) (B := B) hsource_compact)
    (source_finrank_eq_source_invariants_of_compactDual_rank
      (A := A) (B := B) hsource_compact_dim)
    (source_finrank_eq_trivialModulePart_of_compactDual_rank
      (A := A) (B := B) hsource_compact_dim hcompact_trivial_dim)

end BoundaryViaCompactDualRank

def R559_substantiveTheoremCount : Nat := 5

end FrontC18_MatsushimaSourceCompactDualRankBridge
end HCGapL4
end HodgeReduction
