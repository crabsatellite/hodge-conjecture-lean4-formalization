/-
# HC Gap L4 -- Front C145: sharp rank-bound form of the source-invariant target (R710).

R709 transferred the finite-rank compact-dual route to the primitive
Matsushima source-invariant carrier:

* prove finite-dimensional `source_invariants`;
* prove `finrank source_invariants <= 1`;
* prove `h^4 in source_invariants`;
* prove the same boundary data.

This file sharpens that source-side spelling.  Once source finite-dimensionality
and source generator membership are fixed, the no-extra statement
`source_invariants <= H8`, and hence `source_invariants = H8`, is exactly the
rank-one upper bound.  The proof is a kernel-checked transfer across
`compactDual = source_invariants`, not a new premise.

The file also records the two matching source-side deadends:

* finite-dimensionality plus generator membership does not replace the rank
  bound;
* the rank bound does not replace generator membership.

So R710 makes the next mathematical target source-native: an EVII proof must
still deliver boundary data, source generator placement, source finite
dimensionality, and the actual source-invariant rank-one calculation.
-/

import HodgeReduction.HCGapL4.FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC145_H8ResidualSourceInvariantRankBoundSharpness

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC100_H8ResidualCartanContainmentIndependence
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC143_H8ResidualCompactDualRankBoundSharpness
open FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute

section SourceRankBoundSharpness

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R710 substantive theorem (1/5)**: after source finite-dimensionality
and source generator membership are fixed, the source no-extra carrier
statement is exactly the source rank-one upper bound. -/
theorem source_invariants_le_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    LE.le (MatsushimaData.source_invariants (A := A) (B := B))
        (CompactDualData.H8 (A := A)) <->
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) <= 1 := by
  haveI : FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    (compactDual_finiteDimensional_iff_source_invariants_finiteDimensional
      (A := A) (B := B)).2
      (inferInstance :
        FiniteDimensional Rat
          (MatsushimaData.source_invariants (A := A) (B := B)))
  have hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
      (A := A) (B := B)).2 hh_source
  have hcompact :=
    compactDual_le_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
      (A := A) (B := B) hh_compact
  rw [compactDual_finrank_eq_source_invariants_finrank (A := A) (B := B)]
    at hcompact
  simpa [MatsushimaCompactDualData.compactDual_eq_source_invariants
      (A := A) (B := B)] using hcompact

/-- **R710 substantive theorem (2/5)**: after source finite-dimensionality
and source generator membership are fixed, the full source-H8 equality is
exactly the same source rank-one upper bound. -/
theorem source_invariants_eq_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) <= 1 := by
  haveI : FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    (compactDual_finiteDimensional_iff_source_invariants_finiteDimensional
      (A := A) (B := B)).2
      (inferInstance :
        FiniteDimensional Rat
          (MatsushimaData.source_invariants (A := A) (B := B)))
  have hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
      (A := A) (B := B)).2 hh_source
  have hcompact :=
    compactDual_eq_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
      (A := A) (B := B) hh_compact
  rw [compactDual_finrank_eq_source_invariants_finrank (A := A) (B := B)]
    at hcompact
  simpa [MatsushimaCompactDualData.compactDual_eq_source_invariants
      (A := A) (B := B)] using hcompact

end SourceRankBoundSharpness

/-! ## Necessary-field countermodels for the source finite-rank route. -/

/-- **R710 obstruction theorem (3/5)**: even with honest boundary data,
source finite-dimensionality and source generator membership do not imply the
source no-extra carrier statement if the source rank-one upper bound is absent. -/
theorem boundaryData_source_finite_and_generator_does_not_force_source_invariants_le_H8 :
    MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      FiniteDimensional Rat
        (MatsushimaData.source_invariants
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)) /\
      (MatsushimaData.source_invariants
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)).carrier
        ((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4) /\
      Not
        (LE.le (MatsushimaData.source_invariants
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget))
          (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))) := by
  exact
    And.intro counterexample_boundaryData_noExtra
      (And.intro
        (by
          change FiniteDimensional Rat
            (⊤ : Submodule Rat BoundaryNoExtraObstructionSource)
          infer_instance)
        (And.intro
          (by
            change ((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4) ∈
              (⊤ : Submodule Rat BoundaryNoExtraObstructionSource)
            trivial)
          (by
            intro hle
            exact counterexample_not_compactDual_le_H8
              (by
                simpa [MatsushimaCompactDualData.compactDual_eq_source_invariants]
                  using hle))))

/-- **R710 obstruction theorem (4/5)**: even with honest boundary data, the
source rank-one upper bound does not imply source generator membership.  The
R664/R706 model has `source_invariants = bot`, hence rank zero, while `h^4`
is nonzero. -/
theorem boundaryData_source_rank_le_one_does_not_force_h_pow_four_mem_source_invariants :
    MatsushimaV56BoundaryData
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget /\
      FiniteDimensional Rat
        (MatsushimaData.source_invariants
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget)) /\
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget)) <= 1 /\
      Not
        ((MatsushimaData.source_invariants
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget)).carrier
          ((KaehlerClass.h : CartanContainmentObstructionSource) ^ 4)) := by
  obtain ⟨hboundary, hnot_compact⟩ :=
    boundaryData_alone_does_not_force_h_pow_four_mem_compactDual
  exact
    And.intro hboundary
      (And.intro
        (by
          change FiniteDimensional Rat
            (⊥ : Submodule Rat CartanContainmentObstructionSource)
          infer_instance)
        (And.intro
          (by
            change Module.finrank (R := Rat)
              (⊥ : Submodule Rat CartanContainmentObstructionSource) <= 1
            simp)
          (by
            intro hmem
            exact hnot_compact
              (by
                simpa [MatsushimaCompactDualData.compactDual_eq_source_invariants]
                  using hmem))))

/-- R710 target names for route summaries. -/
def currentR710SourceInvariantRankBoundSharpnessTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in source_invariants",
  "prove finite-dimensional source_invariants",
  "prove finrank source_invariants <= 1"
]

/-- Machine-readable status for the R710 sharpened source-invariant route. -/
structure R710SourceInvariantRankBoundSharpnessSnapshot where
  proofWorkObligationCount : Nat
  sourceNoExtraEquivalentToRankBoundWithFiniteGenerator : Bool
  sourceH8EquivalentToRankBoundWithFiniteGenerator : Bool
  sourceFinitePlusGeneratorWithoutRankBlocked : Bool
  sourceRankWithoutGeneratorBlocked : Bool
  provesBoundaryData : Bool
  provesSourceGeneratorMembership : Bool
  provesSourceInvariantFiniteDimensionality : Bool
  provesSourceInvariantRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R710 status: the source-invariant finite-rank route is now sharp.
The theorem still needs boundary data, source generator placement, source
finite-dimensionality, and the source rank-one upper bound from genuine EVII
geometry. -/
def currentR710SourceInvariantRankBoundSharpnessSnapshot :
    R710SourceInvariantRankBoundSharpnessSnapshot where
  proofWorkObligationCount :=
    currentR710SourceInvariantRankBoundSharpnessTargetNames.length
  sourceNoExtraEquivalentToRankBoundWithFiniteGenerator := true
  sourceH8EquivalentToRankBoundWithFiniteGenerator := true
  sourceFinitePlusGeneratorWithoutRankBlocked := true
  sourceRankWithoutGeneratorBlocked := true
  provesBoundaryData := false
  provesSourceGeneratorMembership := false
  provesSourceInvariantFiniteDimensionality := false
  provesSourceInvariantRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R710 obstruction theorem (5/5)**: kernel-checked status for the sharp
source-invariant rank-bound route ledger. -/
theorem currentR710SourceInvariantRankBoundSharpnessSnapshot_eq_texStatus :
    currentR710SourceInvariantRankBoundSharpnessSnapshot =
      ({ proofWorkObligationCount := 4
         sourceNoExtraEquivalentToRankBoundWithFiniteGenerator := true
         sourceH8EquivalentToRankBoundWithFiniteGenerator := true
         sourceFinitePlusGeneratorWithoutRankBlocked := true
         sourceRankWithoutGeneratorBlocked := true
         provesBoundaryData := false
         provesSourceGeneratorMembership := false
         provesSourceInvariantFiniteDimensionality := false
         provesSourceInvariantRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R710SourceInvariantRankBoundSharpnessSnapshot) := by
  decide

/-- Kernel-checked target names for the R710 route. -/
theorem currentR710SourceInvariantRankBoundSharpnessTargetNames_eq_texStatus :
    currentR710SourceInvariantRankBoundSharpnessTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in source_invariants",
      "prove finite-dimensional source_invariants",
      "prove finrank source_invariants <= 1"
    ] := by
  rfl

def R710_substantiveTheoremCount : Nat := 5

end FrontC145_H8ResidualSourceInvariantRankBoundSharpness
end HCGapL4
end HodgeReduction
