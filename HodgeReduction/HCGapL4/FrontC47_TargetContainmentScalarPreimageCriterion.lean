/-
# HC Gap L4 -- Front C47: target containment as scalar preimages (R588).

R587 isolates the remaining target-boundary direction as

`trivialModulePart <= surjectivity_target`.

This file removes one more layer of bookkeeping.  Once the source carrier
is exactly `H8 = span {h^4}`, that containment is equivalent, directly
from the Matsushima image equation, to the element-level scalar-preimage
statement:

every class in `trivialModulePart` is `j_q (r • h^4)` for some scalar
`r : Rat`.

Unlike the older R584 route, this equivalence does not need a finite
dimensionality hypothesis; it is just the definition of `surjectivity_target`
plus the H8 generator equation.  The final countermodel keeps the same
discipline as R586/R587: this scalar-preimage statement is not forced by
the abstract H8 carrier interface.
-/

import HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC47_TargetContainmentScalarPreimageCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction

section ContainmentScalarPreimage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B]

/-- **R588 substantive theorem (1/6)**: once the Matsushima source is
exactly `H8`, the reverse target containment is equivalent to scalar
preimages from the single generator `h^4`.  No finite-dimensional rank
criterion is used. -/
theorem trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) <->
      (∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) := by
  constructor
  · intro htrivial_le_target beta hbeta
    have hbeta_target :
        beta ∈ MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
      htrivial_le_target hbeta
    obtain ⟨alpha, halpha_source, halpha_beta⟩ :=
      MatsushimaSurjectivityData.exists_preimage
        (A := A) (B := B) hbeta_target
    have halpha_H8 : alpha ∈ CompactDualData.H8 (A := A) := by
      rw [← hsource_eq_H8]
      exact halpha_source
    rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)] at halpha_H8
    rw [Submodule.mem_span_singleton] at halpha_H8
    obtain ⟨r, hr⟩ := halpha_H8
    refine ⟨r, ?_⟩
    rw [hr]
    exact halpha_beta
  · intro hscalar beta hbeta
    obtain ⟨r, hr⟩ := hscalar beta hbeta
    have hh4_source :
        ((KaehlerClass.h : A) ^ 4) ∈
          MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) := by
      rw [hsource_eq_H8]
      rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
      exact Submodule.subset_span (by simp)
    have hsource :
        (r • ((KaehlerClass.h : A) ^ 4)) ∈
          MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) :=
      Submodule.smul_mem _ r hh4_source
    have hmap :
        MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) ∈
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) :=
      ⟨r • ((KaehlerClass.h : A) ^ 4), hsource, rfl⟩
    rw [MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)] at hmap
    rw [hr] at hmap
    exact hmap

end ContainmentScalarPreimage

section BoundaryScalarPreimage

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

omit [CartanCompactDualIso A] in
/-- **R588 substantive theorem (2/6)**: under the two H8 carrier
equalities, target boundary equality is equivalent to the scalar-preimage
statement, without routing through target finrank. -/
theorem target_boundary_iff_scalar_preimage_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) <->
      (∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.target_boundary_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
      (A := A) (B := B) hsource_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R588 substantive theorem (3/6)**: the R554 boundary-data package is
equivalent to the same scalar-preimage statement once the two H8 carrier
equalities are fixed. -/
theorem matsushimaV56BoundaryData_iff_scalar_preimage_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaV56BoundaryData A B <->
      (∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.matsushimaV56BoundaryData_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
      (A := A) (B := B) hsource_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R588 substantive theorem (4/6)**: target Hodge-sum rank remains
equivalent to scalar preimages under the two H8 carrier equalities, but
now the containment-to-scalar part is independent of rank arguments. -/
theorem target_hodgeSum8_iff_scalar_preimage_via_target_containment_of_source_compactDual_eq_H8
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
      hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8) <->
      (∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :=
  (HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.target_hodgeSum8_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8
      (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).trans
    (trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
      (A := A) (B := B) hsource_eq_H8)

omit [CartanCompactDualIso A] in
/-- **R588 substantive theorem (5/6)**: constructor form for the next
attack.  The live target can now be supplied as an element-level scalar
preimage theorem rather than a submodule containment. -/
def matsushimaV56BoundaryData_of_H8_and_scalar_preimage
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hscalar :
      ∀ beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    MatsushimaV56BoundaryData A B :=
  (matsushimaV56BoundaryData_iff_scalar_preimage_of_source_compactDual_eq_H8
    (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8).2 hscalar

end BoundaryScalarPreimage

section Countermodel

/-- **R588 substantive theorem (6/6)**: the R586/R587 countermodel also
refutes the scalar-preimage formulation.  Thus scalar preimages remain a
genuine target-side Matsushima/EVII geometry theorem. -/
theorem counterexample_not_scalar_preimage :
    Not
      (∀ beta : TargetBettiTarget,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget) →
          ∃ r : Rat,
            MatsushimaData.j_q (A := TargetBettiSource) (B := TargetBettiTarget)
              (r • ((KaehlerClass.h : TargetBettiSource) ^ 4)) = beta) := by
  intro hscalar
  exact
    HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.counterexample_not_trivialModulePart_le_surjectivity_target
      ((trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
        (A := TargetBettiSource) (B := TargetBettiTarget)
        HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_source_eq_H8).2
        hscalar)

def R588_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC47_TargetContainmentScalarPreimageCriterion
end HCGapL4
end HodgeReduction
