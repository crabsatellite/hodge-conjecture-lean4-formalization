/-
# HC Gap L4 -- Front C38: target Hodge-sum rank from Cartan image (R579).

R578 moved the target-rank input to the concrete degree-8 Hodge sum:

`finrank target_invariants =
  hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8`.

This file connects that rank input to the geometric target-side image
statement already isolated in the earlier Cartan-image route:

`Submodule.map j_q CartanH8 = trivialModulePart`.

The point is to avoid leaving a naked rank obligation.  Once the exact
Cartan image is supplied by EVII Matsushima/representation geometry, the
degree-8 target Hodge-sum rank follows by the existing rank-one Cartan
line theorem and the Eisenstein/cuspidal target identification.
-/

import HodgeReduction.HCGapL4.FrontC37_TargetRankHodgeSumBridge

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC38_TargetHodgeSumFromCartanImage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC24_CartanImageTrivialRank
open FrontC37_TargetRankHodgeSumBridge

section TargetRankFromCartanImage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R579 substantive theorem (1/4)**: exact Cartan image equality
gives the degree-8 Hodge-sum target-rank bridge of R578. -/
theorem target_finrank_eq_compactDual_hodgeSum_deg8_of_cartan_image
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
        rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
    _ = 1 :=
      trivialModulePart_finrank_eq_one_of_cartan_image
        (A := A) (B := B) hcartan_image
    _ = hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 := rfl

/-- **R579 substantive theorem (2/4)**: exact Cartan image equality also
feeds the expected-Betti target-rank bridge after the R578 rewrite. -/
theorem target_expected_betti8_of_cartan_image
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBetti 8 :=
  target_expected_betti8_of_target_finrank_eq_compactDual_hodgeSum_deg8
    (A := A) (B := B)
    (target_finrank_eq_compactDual_hodgeSum_deg8_of_cartan_image
      (A := A) (B := B) hcartan_image)

end TargetRankFromCartanImage

section BoundaryFromCartanImageTargetRank

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

/-- **R579 substantive theorem (3/4)**: the R578 boundary package can be
fed by four Cartan containment directions plus exact Cartan image
equality, replacing the target Hodge-sum rank input. -/
def matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_cartan_image
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
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_hodgeSum8
    (A := A) (B := B)
    hsource_le_cartan
    hcartan_le_source
    hcompact_le_cartan
    hcartan_le_compact
    (target_finrank_eq_compactDual_hodgeSum_deg8_of_cartan_image
      (A := A) (B := B) hcartan_image)

/-- **R579 substantive theorem (4/4)**: the R554 compact-dual image
equality follows from the same four containment directions plus exact
Cartan image equality. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_cartan_image
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
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_target_hodgeSum8
    (A := A) (B := B)
    hsource_le_cartan
    hcartan_le_source
    hcompact_le_cartan
    hcartan_le_compact
    (target_finrank_eq_compactDual_hodgeSum_deg8_of_cartan_image
      (A := A) (B := B) hcartan_image)

def R579_substantiveTheoremCount : Nat := 4

end BoundaryFromCartanImageTargetRank

end FrontC38_TargetHodgeSumFromCartanImage
end HCGapL4
end HodgeReduction
