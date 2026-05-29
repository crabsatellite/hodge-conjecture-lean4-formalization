/-
# HC Gap L4 -- Front C37: target rank through the degree-8 Hodge sum (R578).

R577 shows that the target expected-Betti bridge is not forced by the
source/compactDual carrier containments.  This file makes the remaining
positive target-rank input more geometric:

* instead of proving
  `finrank target_invariants = shimuraEVIIExpectedBetti 8` directly,
* prove
  `finrank target_invariants =
    hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8`.

FrontC11 already certifies
`shimuraEVIIExpectedBetti 8 =
 hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8`, so this is a real
cohomology-profile bridge, not another carrier-containment consequence.
-/

import HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC37_TargetRankHodgeSumBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC35_SourceCartanContainments

section TargetRankHodgeSum

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]

/-- **R578 substantive theorem (1/4)**: the target expected-Betti
bridge follows from identifying the target-invariant rank with the
degree-8 EVII compact-dual Hodge sum already certified in FrontC11. -/
theorem target_expected_betti8_of_target_finrank_eq_compactDual_hodgeSum_deg8
    (htarget_hodgeSum8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      shimuraEVIIExpectedBetti 8 := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B))
        = hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 :=
      htarget_hodgeSum8
    _ = shimuraEVIIExpectedBetti 8 :=
      rfl

/-- **R578 substantive theorem (2/4)**: the degree-8 compact-dual Hodge
sum is the expected Shimura Betti slot.  This exposes the exact
certified FrontC11 rewrite used by the target-rank bridge. -/
theorem compactDual_hodgeSum_deg8_eq_shimura_expected_betti8 :
    hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 =
      shimuraEVIIExpectedBetti 8 :=
  rfl

end TargetRankHodgeSum

section BoundaryFromTargetHodgeSum

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

/-- **R578 substantive theorem (3/4)**: R576's boundary package can be
fed by four Cartan containment directions plus the degree-8 Hodge-sum
target-rank bridge. -/
def matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_hodgeSum8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (htarget_hodgeSum8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_expected_betti8
    (A := A) (B := B)
    hsource_le_cartan
    hcartan_le_source
    hcompact_le_cartan
    hcartan_le_compact
    (target_expected_betti8_of_target_finrank_eq_compactDual_hodgeSum_deg8
      (A := A) (B := B) htarget_hodgeSum8)

/-- **R578 substantive theorem (4/4)**: the R554 compact-dual image
equality follows from the same four containment directions plus the
degree-8 Hodge-sum target-rank bridge. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_target_hodgeSum8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (htarget_hodgeSum8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_target_expected_betti8
    (A := A) (B := B)
    hsource_le_cartan
    hcartan_le_source
    hcompact_le_cartan
    hcartan_le_compact
    (target_expected_betti8_of_target_finrank_eq_compactDual_hodgeSum_deg8
      (A := A) (B := B) htarget_hodgeSum8)

def R578_substantiveTheoremCount : Nat := 4

end BoundaryFromTargetHodgeSum

end FrontC37_TargetRankHodgeSumBridge
end HCGapL4
end HodgeReduction
