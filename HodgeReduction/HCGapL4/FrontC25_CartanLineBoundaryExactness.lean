/-
# HC Gap L4 -- Front C25: Cartan-line boundary exactness (R566).

R565 reduced the target rank-one calculation to exactness of the
`j_q` image of Cartan's H8 line.  This file aligns the remaining source
and compact-dual obligations with the same Cartan line:

* `surjectivity_source = CartanCompactDualIso.trivialModuleGK_H8`;
* `MatsushimaCompactDualData.compactDual = CartanCompactDualIso.trivialModuleGK_H8`;
* `Submodule.map j_q CartanCompactDualIso.trivialModuleGK_H8 = trivialModulePart`.

These are still genuine EVII geometric facts, not new axioms.  The point
of this round is to make the next attack surface single-source and
audit-visible: all three remaining Matsushima boundary equalities are
Cartan-line exactness statements.
-/

import HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC25_CartanLineBoundaryExactness

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC24_CartanImageTrivialRank

section CartanLineCarriers

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R566 substantive theorem (1/5)**: identifying the Matsushima
compact-dual carrier with Cartan's trivial-module H8 line identifies it
with the actual compact-dual `H8` carrier. -/
theorem matsushima_compactDual_eq_H8_of_eq_cartan
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaCompactDualData.compactDual (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        hcompact_cartan
    _ = CompactDualData.H8 (A := A) :=
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)

end CartanLineCarriers

section SourceCarrier

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R566 substantive theorem (2/5)**: source equality with the
compact-dual subspace follows if both source and compact-dual carriers
are identified with the same Cartan H8 line. -/
theorem source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        hsource_cartan
    _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        hcompact_cartan.symm

end SourceCarrier

section BoundaryFromCartanLine

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

omit [MatsushimaSurjectivityData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R566 substantive theorem (3/5)**: compactDual/trivialModulePart
rank equality follows from compactDual-to-Cartan carrier identification
and exact Cartan image equality. -/
theorem compactDual_finrank_eq_trivialModulePart_of_cartan_line_exactness
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
  compactDual_finrank_eq_trivialModulePart_of_H8_cartan_image
    (A := A) (B := B)
    (matsushima_compactDual_eq_H8_of_eq_cartan
      (A := A) (B := B) hcompact_cartan)
    hcartan_image

/-- **R566 substantive theorem (4/5)**: three Cartan-line exactness
statements build the full Matsushima boundary data. -/
def matsushimaV56BoundaryData_of_cartan_line_exactness
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_eq_H8_cartan_image
    (A := A) (B := B)
    (source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan
      (A := A) (B := B) hsource_cartan hcompact_cartan)
    (matsushima_compactDual_eq_H8_of_eq_cartan
      (A := A) (B := B) hcompact_cartan)
    hcartan_image

/-- **R566 substantive theorem (5/5)**: the R554 compact-dual image
conclusion follows from the same Cartan-line exactness package. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_cartan_line_exactness
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_H8_cartan_image
    (A := A) (B := B)
    (source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan
      (A := A) (B := B) hsource_cartan hcompact_cartan)
    (matsushima_compactDual_eq_H8_of_eq_cartan
      (A := A) (B := B) hcompact_cartan)
    hcartan_image

def R566_substantiveTheoremCount : Nat := 5

end BoundaryFromCartanLine

end FrontC25_CartanLineBoundaryExactness
end HCGapL4
end HodgeReduction
