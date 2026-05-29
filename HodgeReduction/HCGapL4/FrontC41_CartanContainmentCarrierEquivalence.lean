/-
# HC Gap L4 -- Front C41: Cartan containments as H8 carrier splits (R582).

R576/R581 leave four Cartan carrier directions:

* `surjectivity_source <= CartanH8`,
* `CartanH8 <= surjectivity_source`,
* `compactDual <= CartanH8`,
* `CartanH8 <= compactDual`.

Because `CartanH8 = CompactDualData.H8` and `H8 = span {h^4}`,
each two-sided Cartan containment is equivalently a concrete carrier
split:

* no extra classes beyond `H8`;
* the generator `h^4` is present.

This file records those equivalences for both the Matsushima
surjectivity source and the Matsushima compact-dual carrier.  The next
geometric attack can therefore target element membership and no-extra
carrier statements directly.
-/

import HodgeReduction.HCGapL4.FrontC40_TargetRankScalarPreimageEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC41_CartanContainmentCarrierEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge

section GenericCartanCarrier

variable {A V : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]

/-- **R582 linear carrier lemma (1/8)**: containment in Cartan H8 is the
same as containment in the compact-dual `H8` carrier. -/
theorem carrier_le_H8_of_le_cartan
    (P : Submodule Rat A)
    (hP_le_cartan : LE.le P (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    LE.le P (CompactDualData.H8 (A := A)) := by
  rw [← CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  exact hP_le_cartan

/-- **R582 linear carrier lemma (2/8)**: containment in compact-dual `H8`
is the same as containment in Cartan H8. -/
theorem carrier_le_cartan_of_le_H8
    (P : Submodule Rat A)
    (hP_le_H8 : LE.le P (CompactDualData.H8 (A := A))) :
    LE.le P (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  exact hP_le_H8

/-- **R582 linear carrier lemma (3/8)**: if Cartan H8 lies in a carrier,
then the generator `h^4` lies in that carrier. -/
theorem h_pow_4_mem_of_cartan_le_carrier
    (P : Submodule Rat A)
    (hcartan_le_P : LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) P) :
    P.carrier ((KaehlerClass.h : A) ^ 4) :=
  hcartan_le_P
    (FrontC34_CartanContainmentsForCompactDual.h_pow_4_mem_cartan_trivialModuleGK_H8
      (A := A))

/-- **R582 linear carrier lemma (4/8)**: for a carrier, containing
`h^4` is enough to contain the whole Cartan H8 line. -/
theorem cartan_le_carrier_of_h_pow_4_mem
    (P : Submodule Rat A)
    (hh_P : P.carrier ((KaehlerClass.h : A) ^ 4)) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) P := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.span_le.mpr (by
    intro x hx
    rw [Set.mem_singleton_iff] at hx
    rw [hx]
    exact hh_P)

end GenericCartanCarrier

section SourceCarrierEquivalence

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]

/-- **R582 substantive theorem (5/8)**: source/Cartan two-sided
containment is exactly source no-extra-H8 plus source generator
membership. -/
theorem source_cartan_containments_iff_source_H8_split :
    ((LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) ∧
      (LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)))) ↔
    ((LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CompactDualData.H8 (A := A))) ∧
      ((MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))) := by
  constructor
  · intro h
    exact ⟨carrier_le_H8_of_le_cartan
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        h.1,
      h_pow_4_mem_of_cartan_le_carrier
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        h.2⟩
  · intro h
    exact ⟨carrier_le_cartan_of_le_H8
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        h.1,
      cartan_le_carrier_of_h_pow_4_mem
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        h.2⟩

end SourceCarrierEquivalence

section CompactDualCarrierEquivalence

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R582 substantive theorem (6/8)**: compactDual/Cartan two-sided
containment is exactly compactDual no-extra-H8 plus compactDual
generator membership. -/
theorem compactDual_cartan_containments_iff_compactDual_H8_split :
    ((LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) ∧
      (LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))) ↔
    ((LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A))) ∧
      ((MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))) := by
  constructor
  · intro h
    exact ⟨carrier_le_H8_of_le_cartan
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        h.1,
      h_pow_4_mem_of_cartan_le_carrier
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        h.2⟩
  · intro h
    exact ⟨carrier_le_cartan_of_le_H8
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        h.1,
      cartan_le_carrier_of_h_pow_4_mem
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        h.2⟩

end CompactDualCarrierEquivalence

section BoundaryRouteFromCarrierSplits

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

/-- **R582 substantive theorem (7/8)**: the R580 boundary package can
consume the carrier-split form directly: source no-extra-H8,
source generator membership, compactDual no-extra-H8, compactDual
generator membership, and scalar preimages. -/
def matsushimaV56BoundaryData_of_source_compactDual_H8_splits_scalar_preimage
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le_H8 :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_source :
      (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    MatsushimaV56BoundaryData A B :=
  FrontC39_TargetHodgeSumFromScalarPreimage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_scalar_preimage
      (A := A) (B := B)
      (carrier_le_cartan_of_le_H8
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        hsource_le_H8)
      (cartan_le_carrier_of_h_pow_4_mem
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        hh_source)
      (carrier_le_cartan_of_le_H8
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        hcompact_le_H8)
      (cartan_le_carrier_of_h_pow_4_mem
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        hh_compact)
      hscalar

/-- **R582 substantive theorem (8/8)**: with carrier splits fixed, the
same target-side equivalence from R581 can be stated without Cartan
containment hypotheses. -/
theorem target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_H8_splits
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le_H8 :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_source :
      (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)))
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      FrontC4_HodgePolynomialAlgebra.hodgeSumAtDegree
        FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond 8) ↔
    (∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  FrontC40_TargetRankScalarPreimageEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_cartan_containments
      (A := A) (B := B)
      (carrier_le_cartan_of_le_H8
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        hsource_le_H8)
      (cartan_le_carrier_of_h_pow_4_mem
        (A := A)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        hh_source)
      (carrier_le_cartan_of_le_H8
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        hcompact_le_H8)
      (cartan_le_carrier_of_h_pow_4_mem
        (A := A)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        hh_compact)

def R582_substantiveTheoremCount : Nat := 8

end BoundaryRouteFromCarrierSplits

end FrontC41_CartanContainmentCarrierEquivalence
end HCGapL4
end HodgeReduction
