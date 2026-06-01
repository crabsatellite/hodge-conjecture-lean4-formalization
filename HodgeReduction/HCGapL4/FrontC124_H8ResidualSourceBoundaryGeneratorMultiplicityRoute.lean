/-
# HC Gap L4 -- Front C124: source boundary plus generator/multiplicity route (R688).

R687 reduced the active H8 residual route to:

* prove `MatsushimaV56BoundaryData`;
* prove `h^4` lies in `source_invariants`;
* prove finite-dimensional `finrank trivialModulePart <= 1`.

The first item still bundles two Matsushima boundary equalities.  This file
proves that the target boundary equality is not independent after the R687
generator/multiplicity inputs are available.  If the source boundary equality
`surjectivity_source = compactDual` holds, then `h^4` source membership puts
`j_q(h^4)` in the surjectivity target, while the multiplicity upper bound
identifies the target invariants with the same generator line.  Therefore the
target boundary equality follows.

The new sufficient route is smaller:

* prove `surjectivity_source = compactDual`;
* prove `h^4` lies in `source_invariants`;
* prove finite-dimensional `finrank trivialModulePart <= 1`.

This is not a closure claim and does not prove any of those three geometric
inputs.
-/

import HodgeReduction.HCGapL4.FrontC123_H8ResidualGeneratorMultiplicityRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC123_H8ResidualGeneratorMultiplicityRoute

section SourceBoundaryGeneratorMultiplicity

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

/-- **R688 substantive theorem (1/4)**: once source boundary equality and
the R687 generator/multiplicity inputs are available, the target boundary
equality follows.  Thus `MatsushimaV56BoundaryData` does not need to be
attacked as two independent boundary equations along this route. -/
theorem target_eq_invariants_of_source_eq_compactDual_h_pow_four_mem_source_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_boundary :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  let gen : B :=
    MatsushimaData.j_q (A := A) (B := B)
      ((KaehlerClass.h : A) ^ 4)
  have htarget_line :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    target_invariants_eq_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
      (A := A) (B := B) hh_pow hupper
  have hsurj_eq_map :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) :=
    (MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)).symm
  have hsurj_le_target :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) ≤
        MatsushimaData.target_invariants (A := A) (B := B) := by
    rw [hsurj_eq_map, hsource_boundary]
    exact MatsushimaCompactDualData.map_compactDual_le_target_invariants
      (A := A) (B := B)
  have hgen_surj :
      gen ∈ MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) := by
    have hh_compact :
        ((KaehlerClass.h : A) ^ 4) ∈
          MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
      MatsushimaCompactDualData.source_invariants_le_compactDual
        (A := A) (B := B) hh_pow
    have hh_source_boundary :
        ((KaehlerClass.h : A) ^ 4) ∈
          MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) := by
      rw [hsource_boundary]
      exact hh_compact
    rw [hsurj_eq_map]
    exact Submodule.mem_map_of_mem hh_source_boundary
  have htarget_le_surj :
      MatsushimaData.target_invariants (A := A) (B := B) ≤
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) := by
    rw [htarget_line]
    apply Submodule.span_le.mpr
    intro beta hbeta
    rw [Set.mem_singleton_iff] at hbeta
    rw [hbeta]
    exact hgen_surj
  apply le_antisymm
  · exact hsurj_le_target
  · exact htarget_le_surj

/-- The R688 source-boundary generator/multiplicity contract.  It replaces
full `MatsushimaV56BoundaryData` by only the source boundary equality; the
target boundary equality is derived by the theorem above. -/
structure EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract
    (A B : Type*)
    [CommRing A] [Algebra Rat A] [CohomologyRing A]
    [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B]
    [CuspidalCohomologyData B]
    [EisensteinVanishingDeg8 A B]
    [CuspidalGInvariantTrivialModuleDeg8 A B] where
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_upper_bound :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1

/-- **R688 substantive theorem (2/4)**: the smaller R688 contract reconstructs
honest `MatsushimaV56BoundaryData`; the target boundary field is derived, not
assumed. -/
def boundaryData_of_sourceBoundaryGeneratorMultiplicityContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual := O.source_eq_compactDual
  target_eq_invariants :=
    target_eq_invariants_of_source_eq_compactDual_h_pow_four_mem_source_trivialModulePartUpperBound
      (A := A) (B := B)
      O.source_eq_compactDual
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_upper_bound

/-- **R688 substantive theorem (3/4)**: the smaller R688 contract feeds the
R687 boundary-data generator/multiplicity route. -/
def boundaryDataGeneratorMultiplicityContract_of_sourceBoundaryGeneratorMultiplicityContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract A B where
  boundary :=
    boundaryData_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B) O
  h_pow_four_mem_source_invariants := O.h_pow_four_mem_source_invariants
  trivialModulePart_upper_bound := O.trivialModulePart_upper_bound

/-- **R688 substantive theorem (4/4)**: inhabited smaller contracts feed
inhabited R687 contracts. -/
theorem residual_sourceBoundaryGeneratorMultiplicity_nonempty_to_boundaryDataGeneratorMultiplicity_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) →
      Nonempty (EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (boundaryDataGeneratorMultiplicityContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B) O)

end SourceBoundaryGeneratorMultiplicity

/-- R688 target names for route summaries. -/
def currentR688SourceBoundaryGeneratorMultiplicityTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove h^4 in source_invariants",
  "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R688 smaller boundary route. -/
structure R688SourceBoundaryGeneratorMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  sourceBoundaryPlusGeneratorMultiplicityDerivesTargetBoundary : Bool
  sourceBoundaryRouteFeedsR687 : Bool
  provesSourceBoundary : Bool
  provesGeneratorMembership : Bool
  provesTrivialMultiplicityUpperBound : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R688 status: the target boundary equality is derived from the
source boundary equality plus generator/multiplicity inputs.  None of those
three inputs is proved here. -/
def currentR688SourceBoundaryGeneratorMultiplicitySnapshot :
    R688SourceBoundaryGeneratorMultiplicitySnapshot where
  proofWorkObligationCount :=
    currentR688SourceBoundaryGeneratorMultiplicityTargetNames.length
  sourceBoundaryPlusGeneratorMultiplicityDerivesTargetBoundary := true
  sourceBoundaryRouteFeedsR687 := true
  provesSourceBoundary := false
  provesGeneratorMembership := false
  provesTrivialMultiplicityUpperBound := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R688 route ledger. -/
theorem currentR688SourceBoundaryGeneratorMultiplicitySnapshot_eq_texStatus :
    currentR688SourceBoundaryGeneratorMultiplicitySnapshot =
      ({ proofWorkObligationCount := 3
         sourceBoundaryPlusGeneratorMultiplicityDerivesTargetBoundary := true
         sourceBoundaryRouteFeedsR687 := true
         provesSourceBoundary := false
         provesGeneratorMembership := false
         provesTrivialMultiplicityUpperBound := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R688SourceBoundaryGeneratorMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R688 route. -/
theorem currentR688SourceBoundaryGeneratorMultiplicityTargetNames_eq_texStatus :
    currentR688SourceBoundaryGeneratorMultiplicityTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove h^4 in source_invariants",
      "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
    ] := by
  rfl

def R688_substantiveTheoremCount : Nat := 4

end FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute
end HCGapL4
end HodgeReduction
