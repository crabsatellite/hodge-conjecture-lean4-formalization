/-
# HC Gap L4 -- Front C40: target rank and scalar-preimage equivalence (R581).

R580 replaced the target Hodge-sum rank input by scalar-preimage
surjectivity onto the cuspidal trivial-module part.  This file checks
the reverse direction under the same carrier data:

* source/Cartan two-sided containment,
* compactDual/Cartan two-sided containment.

Under these carrier identifications, the target Hodge-sum rank and the
scalar-preimage statement are equivalent.  The proof uses the existing
Matsushima surjectivity equation to get a preimage in the source, then
uses `source <= CartanH8` and `H8 = span {h^4}` to turn that preimage
into a scalar multiple of `h^4`.

This is not a closure claim.  It records that, once the four carrier
directions are known, the remaining target-side problem may be attacked
either as a degree-8 rank theorem or as scalar preimage surjectivity;
they are the same gap in the current interface.
-/

import HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource
import HodgeReduction.HCGapL4.FrontC39_TargetHodgeSumFromScalarPreimage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC40_TargetRankScalarPreimageEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC15_MatsushimaBoundaryRankCriterion
open FrontC16_MatsushimaTargetContainmentFromSource
open FrontC17_MatsushimaTargetRankFromSource
open FrontC24_CartanImageTrivialRank
open FrontC35_SourceCartanContainments
open FrontC39_TargetHodgeSumFromScalarPreimage

section TargetRankToScalarPreimage

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

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- **R581 substantive theorem (1/7)**: the target Hodge-sum rank
specializes to rank one of the cuspidal trivial-module part. -/
theorem trivialModulePart_finrank_eq_one_of_target_hodgeSum8
    (htarget_hodge :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  calc
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
        rw [← target_invariants_eq_trivialModulePart (A := A) (B := B)]
    _ = hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 := htarget_hodge
    _ = 1 := rfl

omit [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R581 substantive theorem (2/7)**: source/Cartan two-sided
containment makes the Matsushima surjectivity source one-dimensional. -/
theorem surjectivity_source_finrank_eq_one_of_source_cartan_containments
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) =
      1 := by
  rw [surjectivity_source_eq_cartan_of_source_cartan_containments
    (A := A) (B := B) hsource_le_cartan hcartan_le_source]
  exact cartan_trivialModuleGK_H8_finrank_eq_one (A := A)

omit [MatsushimaCompactDualData A B] in
/-- **R581 substantive theorem (3/7)**: source/Cartan containment plus
target Hodge-sum rank gives the target/trivial-module finrank equation
needed by the R556/R557 target-boundary criterion. -/
theorem surjectivity_target_finrank_eq_trivialModulePart_of_source_cartan_containments_target_hodgeSum8
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))
    (htarget_hodge :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) :=
        surjectivity_target_finrank_eq_source (A := A) (B := B)
    _ = 1 :=
      surjectivity_source_finrank_eq_one_of_source_cartan_containments
        (A := A) (B := B) hsource_le_cartan hcartan_le_source
    _ =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
        rw [trivialModulePart_finrank_eq_one_of_target_hodgeSum8
          (A := A) (B := B) htarget_hodge]

/-- **R581 substantive theorem (4/7)**: the target equality
`surjectivity_target = trivialModulePart` follows from source/Cartan
containment, the Cartan-to-compactDual direction, and target Hodge-sum
rank. -/
theorem surjectivity_target_eq_trivialModulePart_of_source_cartan_target_hodgeSum8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (htarget_hodge :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have hsource_le_source :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)) :=
    (hsource_le_cartan.trans hcartan_le_compact).trans
      (MatsushimaCompactDualData.compactDual_le_source_invariants
        (A := A) (B := B))
  exact
    target_eq_trivialModulePart_of_le_finrank
      (A := A) (B := B)
      (surjectivity_target_le_trivialModulePart_of_source_le
        (A := A) (B := B) hsource_le_source)
      (surjectivity_target_finrank_eq_trivialModulePart_of_source_cartan_containments_target_hodgeSum8
        (A := A) (B := B)
        hsource_le_cartan
        hcartan_le_source
        htarget_hodge)

omit [MatsushimaCompactDualData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R581 substantive theorem (5/7)**: if the Matsushima
surjectivity target is the trivial-module part and the source lies in
Cartan H8, then every trivial-module class has a scalar `h^4`
preimage. -/
theorem scalar_preimage_of_source_le_cartan_target_eq_trivialModulePart
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (htarget_trivial :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    ∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta := by
  intro beta hbeta
  have hbeta_target :
      beta ∈ MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) := by
    rw [htarget_trivial]
    exact hbeta
  obtain ⟨alpha, halpha_source, halpha_beta⟩ :=
    MatsushimaSurjectivityData.exists_preimage (A := A) (B := B) hbeta_target
  have halpha_cartan :
      alpha ∈ CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
    hsource_le_cartan halpha_source
  have halpha_H8 : alpha ∈ CompactDualData.H8 (A := A) := by
    rw [← CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
    exact halpha_cartan
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)] at halpha_H8
  rw [Submodule.mem_span_singleton] at halpha_H8
  obtain ⟨r, hr⟩ := halpha_H8
  refine ⟨r, ?_⟩
  rw [hr]
  exact halpha_beta

/-- **R581 substantive theorem (6/7)**: the target Hodge-sum rank implies
scalar-preimage surjectivity under the current source/Cartan carrier
directions. -/
theorem scalar_preimage_of_source_cartan_containments_target_hodgeSum8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le_cartan :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_source :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (htarget_hodge :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    ∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta :=
  scalar_preimage_of_source_le_cartan_target_eq_trivialModulePart
    (A := A) (B := B)
    hsource_le_cartan
    (surjectivity_target_eq_trivialModulePart_of_source_cartan_target_hodgeSum8
      (A := A) (B := B)
      hsource_le_cartan
      hcartan_le_source
      hcartan_le_compact
      htarget_hodge)

/-- **R581 substantive theorem (7/7)**: with the four current Cartan
carrier directions fixed, target Hodge-sum rank and scalar-preimage
surjectivity are equivalent formulations of the remaining target-side
gap. -/
theorem target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_cartan_containments
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
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) ↔
    (∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta) := by
  constructor
  · intro htarget_hodge
    exact
      scalar_preimage_of_source_cartan_containments_target_hodgeSum8
        (A := A) (B := B)
        hsource_le_cartan
        hcartan_le_source
        hcartan_le_compact
        htarget_hodge
  · intro hscalar
    exact
      target_finrank_eq_compactDual_hodgeSum_deg8_of_compactDual_cartan_containments_scalar_preimage
        (A := A) (B := B)
        hcompact_le_cartan
        hcartan_le_compact
        hscalar

def R581_substantiveTheoremCount : Nat := 7

end TargetRankToScalarPreimage

end FrontC40_TargetRankScalarPreimageEquivalence
end HCGapL4
end HodgeReduction
