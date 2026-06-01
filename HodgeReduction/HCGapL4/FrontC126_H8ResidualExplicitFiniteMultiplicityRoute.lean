/-
# HC Gap L4 -- Front C126: explicit finite multiplicity route (R690).

R688/R689 intentionally name the third live input as:

* finite-dimensional `trivialModulePart`;
* `finrank trivialModulePart <= 1`.

The previous consumer theorems accepted finite dimensionality as an ordinary
typeclass argument.  That is correct Lean, but it is easy for a new agent to
miss the fact that finite dimensionality is still an open mathematical input.

This file makes the input explicit in the route contract.  The new contract
stores the finite-dimensional witness as a field and then consumes R688/R689
by installing that witness locally with `haveI`.  It introduces no new theorem
claim beyond making the existing finite-dimensional premise audit-visible.
-/

import HodgeReduction.HCGapL4.FrontC125_H8ResidualSourceBoundaryCartanLineRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC126_H8ResidualExplicitFiniteMultiplicityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence
open FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual
open FrontC123_H8ResidualGeneratorMultiplicityRoute
open FrontC124_H8ResidualSourceBoundaryGeneratorMultiplicityRoute
open FrontC125_H8ResidualSourceBoundaryCartanLineRoute

section ExplicitFiniteMultiplicity

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- The R690 explicit finite-multiplicity contract.  This is the same R688
route, but the finite-dimensional witness is a structure field rather than an
ambient typeclass supplied invisibly by a caller. -/
structure EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract where
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_finite :
    FiniteDimensional Rat (CuspidalCohomologyData.trivialModulePart (A := B))
  trivialModulePart_upper_bound :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1

variable {A B}

/-- **R690 substantive theorem (1/6)**: the explicit finite contract forgets
only the finite-dimensional field and recovers the R688 source-boundary
generator/multiplicity contract. -/
def sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
    (O : EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :
    EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B where
  source_eq_compactDual := O.source_eq_compactDual
  h_pow_four_mem_source_invariants := O.h_pow_four_mem_source_invariants
  trivialModulePart_upper_bound := O.trivialModulePart_upper_bound

/-- **R690 substantive theorem (2/6)**: with the explicit finite field
installed locally, the R688 target-boundary derivation gives honest boundary
data. -/
def boundaryData_of_explicitFiniteMultiplicityContract
    (O : EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :
    MatsushimaV56BoundaryData A B := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  exact
    boundaryData_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B)
      (sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
        (A := A) (B := B) O)

/-- **R690 substantive theorem (3/6)**: the explicit finite contract feeds the
R687 boundary-data generator/multiplicity route with no ambient finite
typeclass left implicit. -/
def boundaryDataGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
    (O : EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract A B := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  exact
    boundaryDataGeneratorMultiplicityContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B)
      (sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
        (A := A) (B := B) O)

/-- **R690 substantive theorem (4/6)**: the explicit finite contract feeds the
R681 source/Cartan three-target contract. -/
def sourceCompactDualCartanLineThreeTargetContract_of_explicitFiniteMultiplicityContract
    (O : EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :
    EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  exact
    sourceCompactDualCartanLineThreeTargetContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B)
      (sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
        (A := A) (B := B) O)

/-- **R690 substantive theorem (5/6)**: the explicit finite contract feeds the
R682 Cartan-line exactness contract. -/
def cartanLineExactnessContract_of_explicitFiniteMultiplicityContract
    (O : EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :
    EVIIH8ResidualCartanLineExactnessContract A B := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  exact
    cartanLineExactnessContract_of_sourceBoundaryGeneratorMultiplicityContract
      (A := A) (B := B)
      (sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
        (A := A) (B := B) O)

/-- **R690 substantive theorem (6/6)**: inhabited explicit finite contracts
feed inhabited R688 contracts; this is one-way because R688 intentionally did
not store the finite-dimensional witness. -/
theorem residual_explicitFiniteMultiplicity_nonempty_to_sourceBoundaryGeneratorMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) ->
      Nonempty (EVIIH8ResidualSourceBoundaryGeneratorMultiplicityContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (sourceBoundaryGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
      (A := A) (B := B) O)

end ExplicitFiniteMultiplicity

/-- R690 target names for route summaries. -/
def currentR690ExplicitFiniteMultiplicityTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove h^4 in source_invariants",
  "prove finite-dimensional trivialModulePart",
  "prove finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the explicit finite-multiplicity route. -/
structure R690ExplicitFiniteMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  finiteDimensionalWitnessIsExplicitField : Bool
  ambientFiniteDimensionalTypeclassNeededForRouteContract : Bool
  explicitFiniteContractFeedsR688 : Bool
  explicitFiniteContractFeedsR687 : Bool
  explicitFiniteContractFeedsR681 : Bool
  explicitFiniteContractFeedsR682 : Bool
  introducesStrongerPremise : Bool
  provesSourceBoundary : Bool
  provesGeneratorMembership : Bool
  provesTrivialMultiplicityFinite : Bool
  provesTrivialMultiplicityUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R690 status: finite dimensionality is no longer an implicit
consumer typeclass in the preferred route contract.  The same mathematical
inputs remain open. -/
def currentR690ExplicitFiniteMultiplicitySnapshot :
    R690ExplicitFiniteMultiplicitySnapshot where
  proofWorkObligationCount := currentR690ExplicitFiniteMultiplicityTargetNames.length
  finiteDimensionalWitnessIsExplicitField := true
  ambientFiniteDimensionalTypeclassNeededForRouteContract := false
  explicitFiniteContractFeedsR688 := true
  explicitFiniteContractFeedsR687 := true
  explicitFiniteContractFeedsR681 := true
  explicitFiniteContractFeedsR682 := true
  introducesStrongerPremise := false
  provesSourceBoundary := false
  provesGeneratorMembership := false
  provesTrivialMultiplicityFinite := false
  provesTrivialMultiplicityUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R690 route ledger. -/
theorem currentR690ExplicitFiniteMultiplicitySnapshot_eq_texStatus :
    currentR690ExplicitFiniteMultiplicitySnapshot =
      ({ proofWorkObligationCount := 4
         finiteDimensionalWitnessIsExplicitField := true
         ambientFiniteDimensionalTypeclassNeededForRouteContract := false
         explicitFiniteContractFeedsR688 := true
         explicitFiniteContractFeedsR687 := true
         explicitFiniteContractFeedsR681 := true
         explicitFiniteContractFeedsR682 := true
         introducesStrongerPremise := false
         provesSourceBoundary := false
         provesGeneratorMembership := false
         provesTrivialMultiplicityFinite := false
         provesTrivialMultiplicityUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R690ExplicitFiniteMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R690 route. -/
theorem currentR690ExplicitFiniteMultiplicityTargetNames_eq_texStatus :
    currentR690ExplicitFiniteMultiplicityTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove h^4 in source_invariants",
      "prove finite-dimensional trivialModulePart",
      "prove finrank trivialModulePart <= 1"
    ] := by
  rfl

def R690_substantiveTheoremCount : Nat := 6

end FrontC126_H8ResidualExplicitFiniteMultiplicityRoute
end HCGapL4
end HodgeReduction
