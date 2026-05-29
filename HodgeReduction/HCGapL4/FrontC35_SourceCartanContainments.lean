/-
# HC Gap L4 -- Front C35: source-Cartan containment criterion (R576).

R575 left one unsplit source-side equality:

* `surjectivity_source = MatsushimaData.source_invariants`.

This file rewrites that equality through the same Cartan H8 line used
for the compact-dual carrier.  The new source-side targets are the two
directional containments:

* `surjectivity_source <= CartanCompactDualIso.trivialModuleGK_H8`;
* `CartanCompactDualIso.trivialModuleGK_H8 <= surjectivity_source`.

Together with the two R575 compactDual/Cartan containments, these imply
the R575 source equality and hence feed the same boundary package.  This
keeps all four geometric directions explicit and avoids a bundled
``source = compactDual = Cartan`` hypothesis.
-/

import HodgeReduction.HCGapL4.FrontC34_CartanContainmentsForCompactDual

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC35_SourceCartanContainments

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC34_CartanContainmentsForCompactDual

section SourceCartanContainments

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

omit [MatsushimaCompactDualData A B] in
/-- **R576 substantive theorem (1/5)**: the source-Cartan equality is
exactly the two source/Cartan containment directions. -/
theorem surjectivity_source_eq_cartan_of_source_cartan_containments
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
  le_antisymm hsource_le_cartan hcartan_le_source

omit [MatsushimaSurjectivityData A B] in
/-- **R576 substantive theorem (2/5)**: the compactDual-Cartan equality
is exactly the two R575 compactDual/Cartan containment directions. -/
theorem compactDual_eq_cartan_of_compactDual_cartan_containments
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
  le_antisymm hcompact_le_cartan hcartan_le_compact

/-- **R576 substantive theorem (3/5)**: source equality with the
Matsushima source-invariant carrier follows from the two source/Cartan
and two compactDual/Cartan containments. -/
theorem surjectivity_source_eq_source_invariants_of_cartan_containments
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
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
      surjectivity_source_eq_cartan_of_source_cartan_containments
        (A := A) (B := B) hsource_le_cartan hcartan_le_source
    _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
      (compactDual_eq_cartan_of_compactDual_cartan_containments
        (A := A) (B := B) hcompact_le_cartan hcartan_le_compact).symm
    _ = MatsushimaData.source_invariants (A := A) (B := B) :=
      MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B)

end SourceCartanContainments

section BoundaryFromSourceAndCompactDualContainments

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

/-- **R576 substantive theorem (4/5)**: the R575/R572 boundary package
can be fed by four explicit Cartan containment directions plus the
expected degree-8 target rank bridge. -/
def matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_expected_betti8
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
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_compactDual_cartan_containments_target_expected_betti8
    (A := A) (B := B)
    (surjectivity_source_eq_source_invariants_of_cartan_containments
      (A := A) (B := B)
      hsource_le_cartan hcartan_le_source hcompact_le_cartan hcartan_le_compact)
    hcompact_le_cartan
    hcartan_le_compact
    htarget_betti8

/-- **R576 substantive theorem (5/5)**: the compact-dual image equality
of R554 follows from the same four containment directions plus the
R572 expected-Betti bridge. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_compactDual_cartan_containments_target_expected_betti8
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
    (htarget_betti8 :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_compactDual_cartan_containments_target_expected_betti8
    (A := A) (B := B)
    (surjectivity_source_eq_source_invariants_of_cartan_containments
      (A := A) (B := B)
      hsource_le_cartan hcartan_le_source hcompact_le_cartan hcartan_le_compact)
    hcompact_le_cartan
    hcartan_le_compact
    htarget_betti8

def R576_substantiveTheoremCount : Nat := 5

end BoundaryFromSourceAndCompactDualContainments

end FrontC35_SourceCartanContainments
end HCGapL4
end HodgeReduction
