/-
# HC Gap L4 -- Front C33: compact-dual H8 carrier criteria (R574).

R573 split the source-invariants/H8 equality into two smaller source
carrier facts:

* `source_invariants <= H8`;
* `h^4` lies in `source_invariants`.

This file pushes those two facts through the existing
`MatsushimaCompactDualData.compactDual_eq_source_invariants` comparison,
so the active carrier target is stated directly on the compact-dual
subspace:

* `compactDual <= H8`;
* `h^4` lies in `compactDual`.

This is a semantic move back to the Borel-Wallach/Cartan compact-dual
object.  It does not assume `compactDual = H8`, and it keeps the two
directions visible for the next attack.
-/

import HodgeReduction.HCGapL4.FrontC32_SourceInvariantsH8CarrierCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC33_CompactDualH8CarrierCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC31_TargetRankFromExpectedBetti
open FrontC32_SourceInvariantsH8CarrierCriterion

section CompactDualCarrierToSource

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R574 substantive theorem (1/5)**: the R573 no-extra-source
condition follows from the same no-extra condition stated on the
compact-dual subspace. -/
theorem source_invariants_le_H8_of_compactDual_le_H8
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    LE.le (MatsushimaData.source_invariants (A := A) (B := B))
      (CompactDualData.H8 (A := A)) :=
  (MatsushimaCompactDualData.source_invariants_le_compactDual
    (A := A) (B := B)).trans hcompact_le_H8

omit [CompactDualData A] in
/-- **R574 substantive theorem (2/5)**: generator membership in the
compact-dual subspace gives generator membership in source invariants,
using the existing compact-dual/source comparison field. -/
theorem h_pow_4_mem_source_invariants_of_mem_compactDual
    (hh_compact : (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  MatsushimaCompactDualData.compactDual_le_source_invariants
    (A := A) (B := B) hh_compact

/-- **R574 substantive theorem (3/5)**: the source-invariants/H8
equality follows from the compact-dual carrier split. -/
theorem source_invariants_eq_H8_of_compactDual_le_H8_h_pow_4_mem
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_compact : (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_source_le_H8_h_pow_4_mem
    (A := A) (B := B)
    (source_invariants_le_H8_of_compactDual_le_H8
      (A := A) (B := B) hcompact_le_H8)
    (h_pow_4_mem_source_invariants_of_mem_compactDual
      (A := A) (B := B) hh_compact)

end CompactDualCarrierToSource

section BoundaryFromCompactDualCarrier

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

/-- **R574 substantive theorem (4/5)**: the R573/R572 boundary package
can be fed by compact-dual carrier obligations directly. -/
def matsushimaV56BoundaryData_of_compactDual_le_H8_h_pow_4_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_compact : (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_le_H8_h_pow_4_target_expected_betti8
    (A := A) (B := B)
    hsurj_source
    (source_invariants_le_H8_of_compactDual_le_H8
      (A := A) (B := B) hcompact_le_H8)
    (h_pow_4_mem_source_invariants_of_mem_compactDual
      (A := A) (B := B) hh_compact)
    htarget_betti8

/-- **R574 substantive theorem (5/5)**: the compact-dual image equality
of R554 follows from compact-dual carrier obligations plus the R572
target expected-Betti bridge. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_compactDual_le_H8_h_pow_4_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_compact : (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4))
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_le_H8_h_pow_4_target_expected_betti8
    (A := A) (B := B)
    hsurj_source
    (source_invariants_le_H8_of_compactDual_le_H8
      (A := A) (B := B) hcompact_le_H8)
    (h_pow_4_mem_source_invariants_of_mem_compactDual
      (A := A) (B := B) hh_compact)
    htarget_betti8

def R574_substantiveTheoremCount : Nat := 5

end BoundaryFromCompactDualCarrier

end FrontC33_CompactDualH8CarrierCriterion
end HCGapL4
end HodgeReduction
