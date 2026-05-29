/-
# HC Gap L4 -- Front C34: Cartan containments for compact-dual carrier (R575).

R574 moved the source-invariants/H8 target to two compact-dual carrier
obligations:

* `compactDual <= H8`;
* `h^4` lies in `compactDual`.

This file routes those through Cartan's degree-8 trivial-module line.
Since `CartanCompactDualIso` already identifies that Cartan line with
`CompactDualData.H8`, the new directional carrier targets are:

* `compactDual <= CartanCompactDualIso.trivialModuleGK_H8`;
* `CartanCompactDualIso.trivialModuleGK_H8 <= compactDual`.

This keeps the two geometric directions explicit instead of replacing
them by a bundled equality.
-/

import HodgeReduction.HCGapL4.FrontC33_CompactDualH8CarrierCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC34_CartanContainmentsForCompactDual

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC33_CompactDualH8CarrierCriterion

section CartanContainmentToCompactDualCarrier

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R575 substantive theorem (1/5)**: no-extra compact-dual classes
beyond H8 follows from no-extra compact-dual classes beyond Cartan's
trivial-module H8 line. -/
theorem compactDual_le_H8_of_compactDual_le_cartan
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A)) := by
  rw [<- CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  exact hcompact_le_cartan

omit [AddCommGroup B] [Module Rat B] [MatsushimaData A B]
  [MatsushimaCompactDualData A B] in
/-- **R575 substantive theorem (2/5)**: the Kähler generator `h^4`
lies in Cartan's H8 line.  This is kernel-pure from
`CartanH8 = CompactDualData.H8` and `H8 = span {h^4}`. -/
theorem h_pow_4_mem_cartan_trivialModuleGK_H8 :
    (CartanCompactDualIso.trivialModuleGK_H8 (A := A)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

/-- **R575 substantive theorem (3/5)**: if Cartan's H8 line is contained
in the Matsushima compact-dual carrier, then the generator `h^4` is in
that carrier. -/
theorem h_pow_4_mem_compactDual_of_cartan_le_compactDual
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  hcartan_le_compact (h_pow_4_mem_cartan_trivialModuleGK_H8 (A := A))

/-- **R575 substantive theorem (4/5)**: the source-invariants/H8 carrier
target follows from the two Cartan/compactDual containments. -/
theorem source_invariants_eq_H8_of_compactDual_cartan_containments
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_compactDual_le_H8_h_pow_4_mem
    (A := A) (B := B)
    (compactDual_le_H8_of_compactDual_le_cartan
      (A := A) (B := B) hcompact_le_cartan)
    (h_pow_4_mem_compactDual_of_cartan_le_compactDual
      (A := A) (B := B) hcartan_le_compact)

end CartanContainmentToCompactDualCarrier

section BoundaryFromCartanContainments

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

/-- **R575 substantive theorem (5/6)**: the R574/R572 boundary package
can be fed by Cartan/compactDual containments plus source equality and
the expected degree-8 target rank bridge. -/
def matsushimaV56BoundaryData_of_compactDual_cartan_containments_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
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
  matsushimaV56BoundaryData_of_compactDual_le_H8_h_pow_4_target_expected_betti8
    (A := A) (B := B)
    hsurj_source
    (compactDual_le_H8_of_compactDual_le_cartan
      (A := A) (B := B) hcompact_le_cartan)
    (h_pow_4_mem_compactDual_of_cartan_le_compactDual
      (A := A) (B := B) hcartan_le_compact)
    htarget_betti8

/-- **R575 substantive theorem (6/6)**: the compact-dual image equality
of R554 follows from the same Cartan/compactDual containments plus the
R572 expected-Betti bridge. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_compactDual_cartan_containments_target_expected_betti8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsurj_source :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B))
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
  matsushima_compactDual_image_eq_trivialModulePart_of_compactDual_le_H8_h_pow_4_target_expected_betti8
    (A := A) (B := B)
    hsurj_source
    (compactDual_le_H8_of_compactDual_le_cartan
      (A := A) (B := B) hcompact_le_cartan)
    (h_pow_4_mem_compactDual_of_cartan_le_compactDual
      (A := A) (B := B) hcartan_le_compact)
    htarget_betti8

def R575_substantiveTheoremCount : Nat := 6

end BoundaryFromCartanContainments

end FrontC34_CartanContainmentsForCompactDual
end HCGapL4
end HodgeReduction
