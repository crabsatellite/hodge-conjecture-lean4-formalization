/-
# HC Gap L4 -- Front C24: Cartan image gives trivial-module rank (R565).

R564 reduced the Matsushima rank bridge to two geometric facts:

* identify the Matsushima compact-dual source with the actual compact-dual
  H8 line;
* prove the cuspidal trivial-module part is rank one.

This file closes the second rank calculation once the trivial-module part
is identified with the `j_q` image of Cartan's compact-dual H8 line.  The
rank computation is kernel-pure linear algebra: Cartan's H8 line equals
`CompactDualData.H8`, `H8` is rank one, and `j_q` is injective.

No concrete EVII instance, axiom, or bundled stronger premise is added.
The remaining geometric target is the exact Cartan image equality

  `Submodule.map j_q (CartanCompactDualIso.trivialModuleGK_H8)
     = CuspidalCohomologyData.trivialModulePart`.
-/

import HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC24_CartanImageTrivialRank

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC23_MatsushimaCompactDualRankOne

section CartanImageRank

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]

/-- **R565 substantive theorem (1/6)**: Cartan's trivial-module H8 line is
one-dimensional, because Cartan identifies it with the compact-dual H8
line and R564 proves that line has rank one. -/
theorem cartan_trivialModuleGK_H8_finrank_eq_one :
    Module.finrank (R := Rat)
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) = 1 := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  exact compactDual_H8_finrank_eq_one (A := A)

/-- **R565 substantive theorem (2/6)**: the `j_q` image of Cartan's H8
line is one-dimensional.  This is pure linear algebra from the injectivity
field of `MatsushimaData`. -/
theorem map_cartan_trivialModuleGK_H8_finrank_eq_one :
    Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) = 1 := by
  calc
    Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
        =
      Module.finrank (R := Rat)
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
        simpa using
          (Submodule.equivMapOfInjective
            (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaData.j_q_injective (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A))).symm.finrank_eq
    _ = 1 := cartan_trivialModuleGK_H8_finrank_eq_one (A := A)

end CartanImageRank

section TrivialModuleRank

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]

/-- **R565 substantive theorem (3/6)**: the cuspidal trivial-module part
has rank one once it is exactly the `j_q` image of Cartan's H8 line. -/
theorem trivialModulePart_finrank_eq_one_of_cartan_image
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  rw [<- hcartan_image]
  exact map_cartan_trivialModuleGK_H8_finrank_eq_one (A := A) (B := B)

end TrivialModuleRank

section BoundaryFromCartanImage

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
/-- **R565 substantive theorem (4/6)**: R564's compact-dual/trivial-module
rank bridge follows from compact-dual H8 identification plus exact Cartan
image equality. -/
theorem compactDual_finrank_eq_trivialModulePart_of_H8_cartan_image
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
  compactDual_finrank_eq_trivialModulePart_of_H8_rank_one
    (A := A) (B := B)
    hcompact_H8
    (trivialModulePart_finrank_eq_one_of_cartan_image
      (A := A) (B := B) hcartan_image)

/-- **R565 substantive theorem (5/6)**: source equality, compact-dual H8
identification, and exact Cartan image equality build the full Matsushima
boundary data. -/
def matsushimaV56BoundaryData_of_source_eq_H8_cartan_image
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_eq_H8_rank_one
    (A := A) (B := B)
    hsource
    hcompact_H8
    (trivialModulePart_finrank_eq_one_of_cartan_image
      (A := A) (B := B) hcartan_image)

/-- **R565 substantive theorem (6/6)**: the R554 compact-dual image
conclusion follows from the same three geometric facts. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_H8_cartan_image
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcartan_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_H8_rank_one
    (A := A) (B := B)
    hsource
    hcompact_H8
    (trivialModulePart_finrank_eq_one_of_cartan_image
      (A := A) (B := B) hcartan_image)

def R565_substantiveTheoremCount : Nat := 6

end BoundaryFromCartanImage

end FrontC24_CartanImageTrivialRank
end HCGapL4
end HodgeReduction
