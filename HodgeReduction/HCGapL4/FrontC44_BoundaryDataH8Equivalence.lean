/-
# HC Gap L4 -- Front C44: boundary data equivalence on H8 carriers (R585).

R584 translated the target-side theorem into the exact boundary equality
`surjectivity_target = trivialModulePart`.  This file proves the converse
viewpoint: after the compact-dual carrier is identified with `H8`, the
existing `MatsushimaV56BoundaryData` structure is equivalent to the
current concrete boundary targets.

This is deliberately an equivalence theorem, not a new bundled premise.
It lets later agents read the route in either form:

* concrete: `source = H8`, `compactDual = H8`, target boundary equality;
* bundled: `compactDual = H8` plus `MatsushimaV56BoundaryData`.
-/

import HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC44_BoundaryDataH8Equivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge

section BoundaryDataH8Equivalence

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

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R585 substantive theorem (1/6)**: boundary data plus
`compactDual = H8` gives the source/H8 equality. -/
theorem source_eq_H8_of_boundaryData_compactDual_eq_H8
    (D : MatsushimaV56BoundaryData A B)
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  D.source_eq_compactDual.trans hcompact_eq_H8

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] in
/-- **R585 substantive theorem (2/6)**: boundary data gives the target
boundary equality used in R584. -/
theorem surjectivity_target_eq_trivialModulePart_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
        = MatsushimaData.target_invariants (A := A) (B := B) :=
        D.target_eq_invariants
    _ = CuspidalCohomologyData.trivialModulePart (A := B) :=
        target_invariants_eq_trivialModulePart (A := A) (B := B)

omit [CartanCompactDualIso A] in
/-- **R585 substantive theorem (3/6)**: after `compactDual = H8`,
boundary data is equivalent to the source/H8 equality plus target
boundary equality. -/
theorem matsushimaV56BoundaryData_iff_source_eq_H8_target_trivial_of_compactDual_eq_H8
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaV56BoundaryData A B ↔
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A) ∧
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) := by
  constructor
  · intro D
    exact ⟨
      source_eq_H8_of_boundaryData_compactDual_eq_H8
        (A := A) (B := B) D hcompact_eq_H8,
      surjectivity_target_eq_trivialModulePart_of_boundaryData
        (A := A) (B := B) D⟩
  · intro h
    exact
      HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
        (A := A) (B := B) h.1 hcompact_eq_H8 h.2

omit [CartanCompactDualIso A] in
/-- **R585 substantive theorem (4/6)**: once source and compactDual are
both `H8`, target Hodge-sum rank is equivalent to the existing boundary
data structure. -/
theorem target_hodgeSum8_iff_matsushimaV56BoundaryData_of_source_compactDual_eq_H8
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
    MatsushimaV56BoundaryData A B := by
  constructor
  · intro htarget
    exact
      HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
        (A := A) (B := B)
        hsource_eq_H8
        hcompact_eq_H8
        (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.surjectivity_target_eq_trivialModulePart_of_target_hodgeSum8_source_compactDual_eq_H8
          (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8 htarget)
  · intro D
    exact
      HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.target_hodgeSum8_of_surjectivity_target_eq_trivialModulePart_source_eq_H8
        (A := A) (B := B)
        hsource_eq_H8
        (surjectivity_target_eq_trivialModulePart_of_boundaryData
          (A := A) (B := B) D)

/-- **R585 substantive theorem (5/6)**: once source and compactDual are
both `H8`, scalar preimage surjectivity is also equivalent to the
existing boundary data structure. -/
theorem scalar_preimage_iff_matsushimaV56BoundaryData_of_source_compactDual_eq_H8
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
    MatsushimaV56BoundaryData A B := by
  constructor
  · intro hscalar
    have htarget_trivial :
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
          CuspidalCohomologyData.trivialModulePart (A := B) :=
      (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.scalar_preimage_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).1 hscalar
    exact
      HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.matsushimaV56BoundaryData_of_source_compactDual_eq_H8_target_trivial
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8 htarget_trivial
  · intro D
    have htarget_trivial :
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
          CuspidalCohomologyData.trivialModulePart (A := B) :=
      surjectivity_target_eq_trivialModulePart_of_boundaryData
        (A := A) (B := B) D
    exact
      (HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.scalar_preimage_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8
        (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).2 htarget_trivial

/-- **R585 substantive theorem (6/6)**: the three concrete boundary
targets close the R554 boundary data exactly, in the H8 language used by
the current route. -/
def matsushimaV56BoundaryData_of_H8_boundary_targets
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (htarget_trivial :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    MatsushimaV56BoundaryData A B :=
  (matsushimaV56BoundaryData_iff_source_eq_H8_target_trivial_of_compactDual_eq_H8
    (A := A) (B := B) hcompact_eq_H8).2
    ⟨hsource_eq_H8, htarget_trivial⟩

def R585_substantiveTheoremCount : Nat := 6

end BoundaryDataH8Equivalence

end FrontC44_BoundaryDataH8Equivalence
end HCGapL4
end HodgeReduction
