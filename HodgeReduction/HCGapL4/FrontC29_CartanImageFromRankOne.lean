/-
# HC Gap L4 -- Front C29: Cartan image exactness from rank one (R570).

R568 rewrote exact Cartan image as scalar surjectivity, and R569 showed
that scalar surjectivity is not forced by the current abstract interface.
This file records the strongest remaining abstract linear-algebra route:
if the compact-dual carrier is Cartan's H8 line and the cuspidal
trivial-module part is one-dimensional, then the Cartan image is exactly
the trivial-module part.

The proof is not a new assumption.  The containment
`map j_q CartanH8 <= trivialModulePart` is R568; the image side has
finrank one by R565; a one-dimensional target leaves no room for a proper
contained image.
-/

import HodgeReduction.HCGapL4.FrontC28_ScalarPreimageObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC29_CartanImageFromRankOne

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC24_CartanImageTrivialRank
open FrontC25_CartanLineBoundaryExactness
open FrontC27_CartanImageScalarPreimage

section RankOneExactImage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R570 substantive theorem (1/4)**: once the compact-dual carrier is
Cartan's H8 line, rank-one of the trivial-module part forces exact Cartan
image equality. -/
theorem cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  apply Submodule.eq_of_le_of_finrank_eq
    (cartan_image_le_trivialModulePart_of_compactDual_eq_cartan
      (A := A) (B := B) hcompact_cartan)
  rw [map_cartan_trivialModuleGK_H8_finrank_eq_one (A := A) (B := B),
    htrivial_rank_one]

/-- **R570 substantive theorem (2/4)**: the same rank-one condition gives
the scalar-preimage form of R568. -/
theorem scalar_preimage_of_compactDual_eq_cartan_trivial_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    ∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta :=
  (cartan_image_eq_trivialModulePart_iff_scalar_preimage
    (A := A) (B := B) hcompact_cartan).1
    (cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one
      (A := A) (B := B) hcompact_cartan htrivial_rank_one)

end RankOneExactImage

section BoundaryFromRankOne

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

/-- **R570 substantive theorem (3/4)**: two carrier equalities plus
rank-one of the trivial-module part build the full Matsushima boundary
data.  This is the new compact FrontC target. -/
def matsushimaV56BoundaryData_of_cartan_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_cartan_line_exactness
    (A := A) (B := B)
    hsource_cartan
    hcompact_cartan
    (cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one
      (A := A) (B := B) hcompact_cartan htrivial_rank_one)

/-- **R570 substantive theorem (4/4)**: the compact-dual image conclusion
of R554 follows from the same two carrier equalities plus rank-one target. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_cartan_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (htrivial_rank_one :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_cartan_line_exactness
    (A := A) (B := B)
    hsource_cartan
    hcompact_cartan
    (cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one
      (A := A) (B := B) hcompact_cartan htrivial_rank_one)

def R570_substantiveTheoremCount : Nat := 4

end BoundaryFromRankOne

end FrontC29_CartanImageFromRankOne
end HCGapL4
end HodgeReduction
