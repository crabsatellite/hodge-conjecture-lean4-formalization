/-
# HC Gap L4 -- Front C136: finite trivial multiplicity rejoins explicit route (R701).

R700 rewrites the active non-boundary target as finite-dimensional
`trivialModulePart` with `finrank <= 1`, packaged together with exact image
and source-H8.  R690 is the older consumer-facing route: source boundary,
generator membership, and the same explicit finite multiplicity fields.

This file proves those two contracts are equivalent.  The conversion is not a
new geometric theorem:

* exact image is equivalent to `surjectivity_source = compactDual` by R681;
* source-H8 supplies `h^4 in source_invariants` by R601;
* generator membership plus multiplicity recovers source-H8 by R687.

Therefore R700 has no dangling route edge: it feeds the R690/R687 consumer
chain, and R690 feeds back to R700, without adding assumptions.
-/

import HodgeReduction.HCGapL4.FrontC135_H8ResidualFiniteRankOneTrivialMultiplicity
import HodgeReduction.HCGapL4.FrontC126_H8ResidualExplicitFiniteMultiplicityRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC136_H8ResidualFiniteTrivialMultiplicityExplicitRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC60_H8ResidualSourceCarrierSplitPackage
open FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence
open FrontC123_H8ResidualGeneratorMultiplicityRoute
open FrontC126_H8ResidualExplicitFiniteMultiplicityRoute
open FrontC135_H8ResidualFiniteRankOneTrivialMultiplicity

section FiniteTrivialMultiplicityExplicitRoute

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

/-- **R701 substantive theorem (1/5)**: the R700 finite trivial-multiplicity
contract gives the R690 explicit finite route. -/
def explicitFiniteMultiplicityContract_of_finiteTrivialMultiplicityContract
    (O : EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B where
  source_eq_compactDual :=
    (source_eq_compactDual_iff_sourceInvariantExactImageTarget
      (A := A) (B := B)).2 O.source_invariants_exact_image
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_source_invariants_eq_H8
      (A := A) (B := B) O.source_invariants_eq_H8
  trivialModulePart_finite := O.trivialModulePart_finite
  trivialModulePart_upper_bound := O.trivialModulePart_finrank_le_one

/-- **R701 substantive theorem (2/5)**: the R690 explicit finite route gives
back the R700 finite trivial-multiplicity contract. -/
def finiteTrivialMultiplicityContract_of_explicitFiniteMultiplicityContract
    (O : EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :
    EVIIH8ResidualFiniteTrivialMultiplicityContract A B := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  exact
    { source_invariants_exact_image :=
        (source_eq_compactDual_iff_sourceInvariantExactImageTarget
          (A := A) (B := B)).1 O.source_eq_compactDual
      source_invariants_eq_H8 :=
        source_invariants_eq_H8_of_h_pow_four_mem_source_trivialModulePartUpperBound
          (A := A) (B := B)
          O.h_pow_four_mem_source_invariants
          O.trivialModulePart_upper_bound
      trivialModulePart_finite := O.trivialModulePart_finite
      trivialModulePart_finrank_le_one := O.trivialModulePart_upper_bound }

/-- **R701 substantive theorem (3/5)**: R700 and R690 are the same inhabited
finite multiplicity route, not two independent gap branches. -/
theorem residual_finiteTrivialMultiplicity_nonempty_iff_explicitFiniteMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualFiniteTrivialMultiplicityContract A B) <->
      Nonempty (EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (explicitFiniteMultiplicityContract_of_finiteTrivialMultiplicityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteTrivialMultiplicityContract_of_explicitFiniteMultiplicityContract
            (A := A) (B := B) O)))

/-- **R701 substantive theorem (4/5)**: R700 directly feeds the R687
boundary-data/generator/multiplicity consumer. -/
def boundaryDataGeneratorMultiplicityContract_of_finiteTrivialMultiplicityContract
    (O : EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract A B :=
  boundaryDataGeneratorMultiplicityContract_of_explicitFiniteMultiplicityContract
    (A := A) (B := B)
    (explicitFiniteMultiplicityContract_of_finiteTrivialMultiplicityContract
      (A := A) (B := B) O)

/-- **R701 substantive theorem (5/5)**: R700 also directly reconstructs
honest `MatsushimaV56BoundaryData` through the R690 consumer. -/
def boundaryData_of_finiteTrivialMultiplicityContract
    (O : EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :
    MatsushimaV56BoundaryData A B :=
  boundaryData_of_explicitFiniteMultiplicityContract
    (A := A) (B := B)
    (explicitFiniteMultiplicityContract_of_finiteTrivialMultiplicityContract
      (A := A) (B := B) O)

end FiniteTrivialMultiplicityExplicitRoute

/-- R701 target names for route summaries. -/
def currentR701FiniteTrivialMultiplicityExplicitRouteTargetNames : List String := [
  "prove either the R700 finite trivial-multiplicity contract or the R690 explicit finite route"
]

/-- Machine-readable status for the R701 route reconciliation. -/
structure R701FiniteTrivialMultiplicityExplicitRouteSnapshot where
  proofWorkObligationCount : Nat
  finiteTrivialMultiplicityFeedsExplicitFiniteRoute : Bool
  explicitFiniteRouteFeedsFiniteTrivialMultiplicity : Bool
  finiteTrivialMultiplicityEquivalentToExplicitFiniteRoute : Bool
  finiteTrivialMultiplicityFeedsR687Consumer : Bool
  finiteTrivialMultiplicityReconstructsBoundaryData : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesBoundaryData : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R701 status: R700 is connected to the older R690/R687 consumer
chain.  The multiplicity theorem itself remains open. -/
def currentR701FiniteTrivialMultiplicityExplicitRouteSnapshot :
    R701FiniteTrivialMultiplicityExplicitRouteSnapshot where
  proofWorkObligationCount :=
    currentR701FiniteTrivialMultiplicityExplicitRouteTargetNames.length
  finiteTrivialMultiplicityFeedsExplicitFiniteRoute := true
  explicitFiniteRouteFeedsFiniteTrivialMultiplicity := true
  finiteTrivialMultiplicityEquivalentToExplicitFiniteRoute := true
  finiteTrivialMultiplicityFeedsR687Consumer := true
  finiteTrivialMultiplicityReconstructsBoundaryData := true
  provesFiniteTrivialMultiplicity := false
  provesBoundaryData := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R701 route reconciliation. -/
theorem currentR701FiniteTrivialMultiplicityExplicitRouteSnapshot_eq_texStatus :
    currentR701FiniteTrivialMultiplicityExplicitRouteSnapshot =
      ({ proofWorkObligationCount := 1
         finiteTrivialMultiplicityFeedsExplicitFiniteRoute := true
         explicitFiniteRouteFeedsFiniteTrivialMultiplicity := true
         finiteTrivialMultiplicityEquivalentToExplicitFiniteRoute := true
         finiteTrivialMultiplicityFeedsR687Consumer := true
         finiteTrivialMultiplicityReconstructsBoundaryData := true
         provesFiniteTrivialMultiplicity := false
         provesBoundaryData := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R701FiniteTrivialMultiplicityExplicitRouteSnapshot) := by
  decide

/-- Kernel-checked target names for the R701 route reconciliation. -/
theorem currentR701FiniteTrivialMultiplicityExplicitRouteTargetNames_eq_texStatus :
    currentR701FiniteTrivialMultiplicityExplicitRouteTargetNames = [
      "prove either the R700 finite trivial-multiplicity contract or the R690 explicit finite route"
    ] := by
  rfl

def R701_substantiveTheoremCount : Nat := 5

end FrontC136_H8ResidualFiniteTrivialMultiplicityExplicitRoute
end HCGapL4
end HodgeReduction
