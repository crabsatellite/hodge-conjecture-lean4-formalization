/-
# HC Gap L4 -- Front C23: compact-dual rank-one bridge (R564).

R563 reduces the FrontC Matsushima boundary to a source equality plus
the rank bridge

  `finrank compactDual = finrank trivialModulePart`.

This file closes the compact-dual side of that rank bridge once the
Matsushima compact-dual submodule is identified with the actual
compact-dual `H8` line.  The `H8` rank-one proof is kernel-pure:
`CompactDualData.H8 = span {h^4}` and `h^4 != 0`.

The remaining rank work is now separated into genuine EVII geometry:

* identify `MatsushimaCompactDualData.compactDual` with `CompactDualData.H8`;
* prove the cuspidal trivial-module part has rank one.

No concrete EVII instance, axiom, or stronger bundled premise is added.
-/

import HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC23_MatsushimaCompactDualRankOne

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC22_MatsushimaExactImageSourceEquivalence

section CompactDualH8Rank

variable {A : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]

/-- **R564 substantive theorem (1/5)**: the abstract compact-dual `H8`
carrier is one-dimensional.  This uses the existing `H8 = span {h^4}`
field and the existing non-vanishing witness `h^4 != 0`. -/
theorem compactDual_H8_finrank_eq_one :
    Module.finrank (R := Rat) (CompactDualData.H8 (A := A)) = 1 := by
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  rw [finrank_span_singleton
    (HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h_pow_4_ne_zero
      (A := A))]

end CompactDualH8Rank

section MatsushimaCompactDualRank

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R564 substantive theorem (2/5)**: if the Matsushima compact-dual
submodule is the actual compact-dual `H8`, then its finrank is one. -/
theorem matsushima_compactDual_finrank_eq_one_of_eq_H8
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1 := by
  rw [hcompact_H8]
  exact compactDual_H8_finrank_eq_one (A := A)

omit [MatsushimaSurjectivityData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R564 substantive theorem (3/5)**: the compactDual/trivialModulePart
rank bridge follows from compact-dual H8 identification plus rank-one of
the cuspidal trivial-module part. -/
theorem compactDual_finrank_eq_trivialModulePart_of_H8_rank_one
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  rw [matsushima_compactDual_finrank_eq_one_of_eq_H8
    (A := A) (B := B) hcompact_H8, htrivial_rank_one]

/-- **R564 substantive theorem (4/5)**: source equality plus the two
rank-one geometric facts build the full Matsushima boundary data. -/
def matsushimaV56BoundaryData_of_source_eq_H8_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_eq_compactDual_trivial_rank
    (A := A) (B := B)
    hsource
    (compactDual_finrank_eq_trivialModulePart_of_H8_rank_one
      (A := A) (B := B) hcompact_H8 htrivial_rank_one)

/-- **R564 substantive theorem (5/5)**: the R554 compact-dual image
conclusion follows from source equality, compact-dual H8 identification,
and rank-one of the trivial-module target. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_H8_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_rank
    (A := A) (B := B)
    hsource
    (compactDual_finrank_eq_trivialModulePart_of_H8_rank_one
      (A := A) (B := B) hcompact_H8 htrivial_rank_one)

def R564_substantiveTheoremCount : Nat := 5

end MatsushimaCompactDualRank

end FrontC23_MatsushimaCompactDualRankOne
end HCGapL4
end HodgeReduction
