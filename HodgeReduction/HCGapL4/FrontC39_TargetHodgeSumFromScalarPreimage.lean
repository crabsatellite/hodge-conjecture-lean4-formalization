/-
# HC Gap L4 -- Front C39: target Hodge-sum rank from scalar preimages (R580).

R579 made the target rank concrete by routing it through exact Cartan image:

`Submodule.map j_q CartanH8 = trivialModulePart`.

R568 already identifies that exact image statement, once the compact-dual
carrier is Cartan's H8 line, with the element-level target:

every class in the cuspidal trivial-module part is `j_q (r * h^4)`.

This file connects the two routes without adding a stronger bundled
premise: the two compact-dual/Cartan containment directions first give
the carrier equality by antisymmetry, and R568 then converts scalar
preimages into exact Cartan image.  The remaining live inputs are the two
source/Cartan containment directions, the two compact-dual/Cartan
containment directions, and this scalar-preimage theorem.
-/

import HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage
import HodgeReduction.HCGapL4.FrontC38_TargetHodgeSumFromCartanImage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC39_TargetHodgeSumFromScalarPreimage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC27_CartanImageScalarPreimage
open FrontC38_TargetHodgeSumFromCartanImage

section CartanImageFromScalarPreimage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R580 substantive theorem (1/5)**: the two compact-dual/Cartan
containment directions plus scalar preimages give exact Cartan image. -/
theorem cartan_image_eq_trivialModulePart_of_compactDual_cartan_containments_scalar_preimage
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
    le_antisymm hcompact_le_cartan hcartan_le_compact
  exact
    (cartan_image_eq_trivialModulePart_iff_scalar_preimage
      (A := A) (B := B) hcompact_cartan).2 hscalar

end CartanImageFromScalarPreimage

section TargetRankFromScalarPreimage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R580 substantive theorem (2/5)**: scalar preimages, together with
the compact-dual/Cartan carrier equality supplied as containments, imply
the degree-8 Hodge-sum target-rank bridge. -/
theorem target_finrank_eq_compactDual_hodgeSum_deg8_of_compactDual_cartan_containments_scalar_preimage
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 :=
  target_finrank_eq_compactDual_hodgeSum_deg8_of_cartan_image
    (A := A) (B := B)
    (cartan_image_eq_trivialModulePart_of_compactDual_cartan_containments_scalar_preimage
      (A := A) (B := B)
      hcompact_le_cartan
      hcartan_le_compact
      hscalar)

/-- **R580 substantive theorem (3/5)**: the same scalar-preimage input
feeds the expected-Betti target-rank bridge. -/
theorem target_expected_betti8_of_compactDual_cartan_containments_scalar_preimage
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBetti 8 :=
  target_expected_betti8_of_cartan_image
    (A := A) (B := B)
    (cartan_image_eq_trivialModulePart_of_compactDual_cartan_containments_scalar_preimage
      (A := A) (B := B)
      hcompact_le_cartan
      hcartan_le_compact
      hscalar)

end TargetRankFromScalarPreimage

section BoundaryFromScalarPreimageTargetRank

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

/-- **R580 substantive theorem (4/5)**: the current boundary package can
consume four Cartan containment directions plus scalar preimages. -/
def matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_scalar_preimage
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
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_cartan_image
    (A := A) (B := B)
    hsource_le_cartan
    hcartan_le_source
    hcompact_le_cartan
    hcartan_le_compact
    (cartan_image_eq_trivialModulePart_of_compactDual_cartan_containments_scalar_preimage
      (A := A) (B := B)
      hcompact_le_cartan
      hcartan_le_compact
      hscalar)

/-- **R580 substantive theorem (5/5)**: the R554 compact-dual image
conclusion follows from the same four containment directions plus scalar
preimages. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_scalar_preimage
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
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_cartan_image
    (A := A) (B := B)
    hsource_le_cartan
    hcartan_le_source
    hcompact_le_cartan
    hcartan_le_compact
    (cartan_image_eq_trivialModulePart_of_compactDual_cartan_containments_scalar_preimage
      (A := A) (B := B)
      hcompact_le_cartan
      hcartan_le_compact
      hscalar)

def R580_substantiveTheoremCount : Nat := 5

end BoundaryFromScalarPreimageTargetRank

end FrontC39_TargetHodgeSumFromScalarPreimage
end HCGapL4
end HodgeReduction
