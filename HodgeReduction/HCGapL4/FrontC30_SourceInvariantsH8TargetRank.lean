/-
# HC Gap L4 -- Front C30: source-invariants H8 and target rank route (R571).

R570 showed that exact Cartan image follows from two carrier facts:

* `compactDual = CartanCompactDualIso.trivialModuleGK_H8`;
* `finrank trivialModulePart = 1`.

This file removes one layer of notation from those targets.  The
existing infrastructure already contains:

* `MatsushimaCompactDualData.compactDual = MatsushimaData.source_invariants`;
* `CartanCompactDualIso.trivialModuleGK_H8 = CompactDualData.H8`;
* `MatsushimaData.target_invariants = trivialModulePart`.

Therefore the next genuine EVII tasks can be stated as:

* `surjectivity_source = MatsushimaData.source_invariants`;
* `MatsushimaData.source_invariants = CompactDualData.H8`;
* `finrank MatsushimaData.target_invariants = 1`.

No concrete EVII instance, axiom, or stronger bundled premise is added.
-/

import HodgeReduction.HCGapL4.FrontC29_CartanImageFromRankOne

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC30_SourceInvariantsH8TargetRank

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC29_CartanImageFromRankOne

section SourceInvariantH8

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

omit [MatsushimaSurjectivityData A B] in
/-- **R571 substantive theorem (1/5)**: the compact-dual/Cartan carrier
target is exactly the source-invariants/H8 carrier target, after using
the existing Matsushima compact-dual and Cartan comparison fields. -/
theorem compactDual_eq_cartan_of_source_invariants_eq_H8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
  calc
    MatsushimaCompactDualData.compactDual (A := A) (B := B)
        = MatsushimaData.source_invariants (A := A) (B := B) :=
      MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B)
    _ = CompactDualData.H8 (A := A) := hsource_H8
    _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
      (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
        (A := A)).symm

omit [MatsushimaCompactDualData A B] in
/-- **R571 substantive theorem (2/5)**: the source-to-Cartan carrier
target follows from the primitive Matsushima source equality and the
source-invariants/H8 carrier target. -/
theorem surjectivity_source_eq_cartan_of_source_invariants_eq_H8
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = MatsushimaData.source_invariants (A := A) (B := B) := hsurj_source
    _ = CompactDualData.H8 (A := A) := hsource_H8
    _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
      (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
        (A := A)).symm

end SourceInvariantH8

section TargetRank

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R571 substantive theorem (3/5)**: target-invariant rank one is
the same rank-one target needed by R570, because R554 identifies
target invariants with the cuspidal trivial-module part. -/
theorem trivialModulePart_finrank_eq_one_of_target_invariants_rank_one
    (htarget_rank_one :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) = 1) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  rw [<- target_invariants_eq_trivialModulePart (A := A) (B := B)]
  exact htarget_rank_one

end TargetRank

section BoundaryFromSourceInvariantH8

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

/-- **R571 substantive theorem (4/5)**: the R570 boundary package can be
fed by primitive Matsushima source-invariants/H8 equality plus target
invariant rank one.  This is the sharper next FrontC target. -/
def matsushimaV56BoundaryData_of_source_invariants_H8_target_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_rank_one :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) = 1) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_cartan_rank_one
    (A := A) (B := B)
    (surjectivity_source_eq_cartan_of_source_invariants_eq_H8
      (A := A) (B := B) hsurj_source hsource_H8)
    (compactDual_eq_cartan_of_source_invariants_eq_H8
      (A := A) (B := B) hsource_H8)
    (trivialModulePart_finrank_eq_one_of_target_invariants_rank_one
      (A := A) (B := B) htarget_rank_one)

/-- **R571 substantive theorem (5/5)**: the compact-dual image equality
of R554 follows from the same sharper primitive targets. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_invariants_H8_target_rank_one
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_rank_one :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) = 1) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_cartan_rank_one
    (A := A) (B := B)
    (surjectivity_source_eq_cartan_of_source_invariants_eq_H8
      (A := A) (B := B) hsurj_source hsource_H8)
    (compactDual_eq_cartan_of_source_invariants_eq_H8
      (A := A) (B := B) hsource_H8)
    (trivialModulePart_finrank_eq_one_of_target_invariants_rank_one
      (A := A) (B := B) htarget_rank_one)

def R571_substantiveTheoremCount : Nat := 5

end BoundaryFromSourceInvariantH8

end FrontC30_SourceInvariantsH8TargetRank
end HCGapL4
end HodgeReduction
