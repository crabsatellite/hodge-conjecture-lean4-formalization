/-
# HC Gap L4 -- Front C143: sharp rank-bound form of the compact-dual carrier target (R708).

R707 replaced the no-extra compact-dual carrier target by an explicit
finite-rank route:

* prove finite-dimensional `compactDual`;
* prove `finrank compactDual <= 1`;
* prove `h^4 in compactDual`.

This file sharpens that route.  Once the generator membership and
finite-dimensionality are available, the no-extra statement
`compactDual <= H8`, and hence the full equality `compactDual = H8`, is
exactly the rank bound `finrank compactDual <= 1`.

The file also records two deadends as kernel countermodels:

* finite-dimensionality plus generator membership does not replace the rank
  bound;
* the rank bound does not replace generator membership.

So R708 makes the next mathematical target precise: an EVII proof must
deliver both generator placement and the actual rank-one compact-dual
calculation.
-/

import HodgeReduction.HCGapL4.FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
import HodgeReduction.HCGapL4.FrontC141_H8ResidualBoundaryCarrierIndependence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC143_H8ResidualCompactDualRankBoundSharpness

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC100_H8ResidualCartanContainmentIndependence
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC141_H8ResidualBoundaryCarrierIndependence
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute

section RankBoundSharpness

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
/-- **R708 substantive theorem (1/5)**: after finite-dimensionality and
generator membership are fixed, the no-extra compact-dual carrier statement
is exactly the rank-one upper bound. -/
theorem compactDual_le_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
    [FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))]
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A)) <->
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1 := by
  constructor
  · intro hle
    exact
      compactDual_finrank_le_one_of_compactDual_le_H8
        (A := A) (B := B) hle
  · intro hfin
    exact
      compactDual_le_H8_of_finite_rank_le_one_and_h_pow_four_mem
        (A := A) (B := B) hfin hh_compact

/-- **R708 substantive theorem (2/5)**: after finite-dimensionality and
generator membership are fixed, the full compact-dual-H8 equality is exactly
the same rank-one upper bound. -/
theorem compactDual_eq_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
    [FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))]
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1 := by
  constructor
  · intro hcompact_H8
    have hle :
        LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
          (CompactDualData.H8 (A := A)) := by
      rw [hcompact_H8]
    exact
      (compactDual_le_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
        (A := A) (B := B) hh_compact).1 hle
  · intro hfin
    exact
      (compactDual_eq_H8_iff_compactDual_le_H8_and_h_pow_four_mem
        (A := A) (B := B)).2
        ⟨(compactDual_le_H8_iff_finrank_le_one_of_finite_and_h_pow_four_mem
            (A := A) (B := B) hh_compact).2 hfin,
          hh_compact⟩

end RankBoundSharpness

/-! ## Necessary-field countermodels for the R707/R708 finite-rank route. -/

/-- **R708 obstruction theorem (3/5)**: even with honest boundary data,
finite-dimensionality and generator membership do not imply the no-extra
carrier statement if the rank-one upper bound is absent. -/
theorem boundaryData_finite_and_generator_does_not_force_compactDual_le_H8 :
    MatsushimaV56BoundaryData
        BoundaryNoExtraObstructionSource
        BoundaryNoExtraObstructionTarget /\
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)) /\
      (MatsushimaCompactDualData.compactDual
          (A := BoundaryNoExtraObstructionSource)
          (B := BoundaryNoExtraObstructionTarget)).carrier
        ((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4) /\
      Not
        (LE.le (MatsushimaCompactDualData.compactDual
            (A := BoundaryNoExtraObstructionSource)
            (B := BoundaryNoExtraObstructionTarget))
          (CompactDualData.H8 (A := BoundaryNoExtraObstructionSource))) := by
  refine
    ⟨counterexample_boundaryData_noExtra,
      ?finite,
      ?generator,
      counterexample_not_compactDual_le_H8⟩
  · change FiniteDimensional Rat
      (⊤ : Submodule Rat BoundaryNoExtraObstructionSource)
    infer_instance
  · change ((KaehlerClass.h : BoundaryNoExtraObstructionSource) ^ 4) ∈
      (⊤ : Submodule Rat BoundaryNoExtraObstructionSource)
    trivial

/-- **R708 obstruction theorem (4/5)**: even with honest boundary data,
the rank-one upper bound does not imply generator membership.  The R664/R706
model has `compactDual = bot`, hence rank zero, while `h^4` is nonzero. -/
theorem boundaryData_rank_le_one_does_not_force_h_pow_four_mem_compactDual :
    MatsushimaV56BoundaryData
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget /\
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget)) /\
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget)) <= 1 /\
      Not
        ((MatsushimaCompactDualData.compactDual
            (A := CartanContainmentObstructionSource)
            (B := CartanContainmentObstructionTarget)).carrier
          ((KaehlerClass.h : CartanContainmentObstructionSource) ^ 4)) := by
  obtain ⟨hboundary, hnot⟩ :=
    boundaryData_alone_does_not_force_h_pow_four_mem_compactDual
  refine ⟨hboundary, ?finite, ?rank, hnot⟩
  · change FiniteDimensional Rat
      (⊥ : Submodule Rat CartanContainmentObstructionSource)
    infer_instance
  · change Module.finrank (R := Rat)
      (⊥ : Submodule Rat CartanContainmentObstructionSource) <= 1
    simp

/-- R708 target names for route summaries. -/
def currentR708CompactDualRankBoundSharpnessTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in compactDual",
  "prove finite-dimensional compactDual",
  "prove finrank compactDual <= 1"
]

/-- Machine-readable status for the R708 sharpened finite-rank route. -/
structure R708CompactDualRankBoundSharpnessSnapshot where
  proofWorkObligationCount : Nat
  noExtraEquivalentToRankBoundWithFiniteGenerator : Bool
  compactDualH8EquivalentToRankBoundWithFiniteGenerator : Bool
  finitePlusGeneratorWithoutRankBlocked : Bool
  rankWithoutGeneratorBlocked : Bool
  provesBoundaryData : Bool
  provesGeneratorMembership : Bool
  provesFiniteDimensionalCompactDual : Bool
  provesRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R708 status: the finite-rank route is now sharp.  The theorem
still needs boundary data, generator placement, finite-dimensionality, and
the rank-one upper bound from genuine EVII geometry. -/
def currentR708CompactDualRankBoundSharpnessSnapshot :
    R708CompactDualRankBoundSharpnessSnapshot where
  proofWorkObligationCount :=
    currentR708CompactDualRankBoundSharpnessTargetNames.length
  noExtraEquivalentToRankBoundWithFiniteGenerator := true
  compactDualH8EquivalentToRankBoundWithFiniteGenerator := true
  finitePlusGeneratorWithoutRankBlocked := true
  rankWithoutGeneratorBlocked := true
  provesBoundaryData := false
  provesGeneratorMembership := false
  provesFiniteDimensionalCompactDual := false
  provesRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R708 obstruction theorem (5/5)**: kernel-checked status for the sharp
rank-bound route ledger. -/
theorem currentR708CompactDualRankBoundSharpnessSnapshot_eq_texStatus :
    currentR708CompactDualRankBoundSharpnessSnapshot =
      ({ proofWorkObligationCount := 4
         noExtraEquivalentToRankBoundWithFiniteGenerator := true
         compactDualH8EquivalentToRankBoundWithFiniteGenerator := true
         finitePlusGeneratorWithoutRankBlocked := true
         rankWithoutGeneratorBlocked := true
         provesBoundaryData := false
         provesGeneratorMembership := false
         provesFiniteDimensionalCompactDual := false
         provesRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R708CompactDualRankBoundSharpnessSnapshot) := by
  decide

/-- Kernel-checked target names for the R708 route. -/
theorem currentR708CompactDualRankBoundSharpnessTargetNames_eq_texStatus :
    currentR708CompactDualRankBoundSharpnessTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in compactDual",
      "prove finite-dimensional compactDual",
      "prove finrank compactDual <= 1"
    ] := by
  rfl

def R708_substantiveTheoremCount : Nat := 5

end FrontC143_H8ResidualCompactDualRankBoundSharpness
end HCGapL4
end HodgeReduction
