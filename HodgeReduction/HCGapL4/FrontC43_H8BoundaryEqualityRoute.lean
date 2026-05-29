/-
# HC Gap L4 -- Front C43: H8 carriers to Matsushima boundary equality (R584).

R583 leaves the carrier side as two exact equalities:

* `surjectivity_source = H8`;
* `compactDual = H8`.

This file converts those equalities into the older Matsushima boundary
language without adding a new premise.  In particular, once
`surjectivity_source = H8`, the Matsushima surjectivity target has
finrank one.  Therefore the remaining target-side theorem is equivalent
to the exact boundary equality

`surjectivity_target = trivialModulePart`.

This is useful for the next research pass: the live FrontC work is now
two H8 carrier equalities plus one target boundary equality, not a loose
bundle of four containments and a rank statement.
-/

import HodgeReduction.HCGapL4.FrontC42_H8CarrierEqualityRoute

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC43_H8BoundaryEqualityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge

section SourceBoundaryFromH8

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R584 substantive theorem (1/8)**: source and compactDual H8
equalities close the source boundary equality
`surjectivity_source = source_invariants`. -/
theorem source_eq_source_invariants_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = CompactDualData.H8 (A := A) := hsource_eq_H8
    _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        hcompact_eq_H8.symm
    _ = MatsushimaData.source_invariants (A := A) (B := B) :=
        MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)

/-- **R584 substantive theorem (2/8)**: source and compactDual H8
equalities also close `surjectivity_source = compactDual`. -/
theorem source_eq_compactDual_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  hsource_eq_H8.trans hcompact_eq_H8.symm

omit [MatsushimaCompactDualData A B] in
/-- **R584 substantive theorem (3/8)**: `source = H8` fixes the
surjectivity target finrank at one via injectivity of `j_q`. -/
theorem surjectivity_target_finrank_eq_one_of_source_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) =
      1 := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) :=
        HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.surjectivity_target_finrank_eq_source
          (A := A) (B := B)
    _ = Module.finrank (R := Rat) (CompactDualData.H8 (A := A)) := by
        rw [hsource_eq_H8]
    _ = 1 :=
        HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_H8_finrank_eq_one
          (A := A)

end SourceBoundaryFromH8

section TargetBoundaryEquivalence

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

omit [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R584 substantive theorem (4/8)**: target boundary equality implies
the degree-8 target Hodge-sum rank once `source = H8`. -/
theorem target_hodgeSum8_of_surjectivity_target_eq_trivialModulePart_source_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_trivial :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
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
    _ =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
        rw [htarget_trivial]
    _ = 1 :=
        surjectivity_target_finrank_eq_one_of_source_eq_H8
          (A := A) (B := B) hsource_eq_H8
    _ = hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 := rfl

omit [CartanCompactDualIso A] in
/-- **R584 substantive theorem (5/8)**: the target Hodge-sum rank implies
the target boundary equality once the source/compactDual H8 equalities
are fixed. -/
theorem surjectivity_target_eq_trivialModulePart_of_target_hodgeSum8_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_hodge :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have hsource_le :
      LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
    rw [source_eq_source_invariants_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8]
  have htarget_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) := by
    calc
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
          = 1 :=
          surjectivity_target_finrank_eq_one_of_source_eq_H8
            (A := A) (B := B) hsource_eq_H8
      _ =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) :=
          (HodgeReduction.HCGapL4.FrontC40_TargetRankScalarPreimageEquivalence.trivialModulePart_finrank_eq_one_of_target_hodgeSum8
            (A := A) (B := B) htarget_hodge).symm
  exact
    HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.target_eq_trivialModulePart_of_le_finrank
        (A := A) (B := B)
        (HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.surjectivity_target_le_trivialModulePart_of_source_le
            (A := A) (B := B) hsource_le)
        htarget_dim

omit [CartanCompactDualIso A] in
/-- **R584 substantive theorem (6/8)**: under the two H8 carrier
equalities, the target Hodge-sum theorem is exactly the target boundary
equality. -/
theorem target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) =
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) ↔
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  constructor
  · exact
      surjectivity_target_eq_trivialModulePart_of_target_hodgeSum8_source_compactDual_eq_H8
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8
  · exact
      target_hodgeSum8_of_surjectivity_target_eq_trivialModulePart_source_eq_H8
        (A := A) (B := B) hsource_eq_H8

/-- **R584 substantive theorem (7/8)**: the scalar-preimage target is
equivalent to target boundary equality under the two H8 carrier
equalities. -/
theorem scalar_preimage_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (∀ beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
        ∃ r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta) ↔
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  (HodgeReduction.HCGapL4.FrontC42_H8CarrierEqualityRoute.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).symm.trans
    (target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8)

/-- **R584 substantive theorem (8/8)**: the two H8 carrier equalities
plus target boundary equality produce the exact R554 Matsushima boundary
data. -/
def matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_trivial :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual :=
    source_eq_compactDual_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8
  target_eq_invariants := by
    calc
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
          = CuspidalCohomologyData.trivialModulePart (A := B) := htarget_trivial
      _ = MatsushimaData.target_invariants (A := A) (B := B) :=
          (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm

def R584_substantiveTheoremCount : Nat := 8

end TargetBoundaryEquivalence

end FrontC43_H8BoundaryEqualityRoute
end HCGapL4
end HodgeReduction
