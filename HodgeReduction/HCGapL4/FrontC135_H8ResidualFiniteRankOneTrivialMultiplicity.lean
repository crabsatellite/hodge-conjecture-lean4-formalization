/-
# HC Gap L4 -- Front C135: finite rank-one as trivial multiplicity (R700).

R698 rewrites the live non-boundary target as an explicit finite rank-one
statement for `target_invariants`.  R554 already identifies
`target_invariants` with the cuspidal `trivialModulePart`.

This file transports both the finite-dimensional witness and the rank-one
upper bound across that equality.  The remaining target can now be read as:

  finite-dimensional `trivialModulePart`
  and
  `finrank trivialModulePart <= 1`.

This is an equivalence of route spellings, not a proof of the multiplicity
theorem and not a new stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC134_H8ResidualFiniteUpperBoundRankOneTarget
import HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC135_H8ResidualFiniteRankOneTrivialMultiplicity

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC81_H8ResidualTrivialModuleUpperBound
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC134_H8ResidualFiniteUpperBoundRankOneTarget

section FiniteRankOneTrivialMultiplicity

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

/-- **R700 substantive theorem (1/7)**: finite-dimensionality of
`target_invariants` is exactly finite-dimensionality of `trivialModulePart`. -/
theorem targetInvariantsFinite_iff_trivialModulePartFinite :
    FiniteDimensional Rat
        (MatsushimaData.target_invariants (A := A) (B := B)) <->
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  constructor
  · intro hfinite
    rw [← target_invariants_eq_trivialModulePart (A := A) (B := B)]
    exact hfinite
  · intro hfinite
    rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
    exact hfinite

/-- **R700 substantive theorem (2/7)**: the target-invariant rank-one upper
bound is the trivial-module multiplicity upper bound. -/
theorem targetRankOneUpperBound_iff_trivialModulePartUpperBound :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <= 1) <->
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]

/-- The R700 explicit finite multiplicity spelling of the R698 non-boundary
target.  It keeps the same source exact-image and source-H8 carrier fields,
but moves the finite rank-one computation to `trivialModulePart`. -/
structure EVIIH8ResidualFiniteTrivialMultiplicityContract
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
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  trivialModulePart_finite :
    FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))
  trivialModulePart_finrank_le_one :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1

/-- **R700 substantive theorem (3/7)**: the R698 finite target-rank contract
gives the explicit trivial-module multiplicity contract. -/
def finiteTrivialMultiplicityContract_of_finiteTargetRankOneContract
    (O : EVIIH8ResidualFiniteTargetRankOneContract A B) :
    EVIIH8ResidualFiniteTrivialMultiplicityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_finite :=
    (targetInvariantsFinite_iff_trivialModulePartFinite
      (A := A) (B := B)).1 O.target_invariants_finite
  trivialModulePart_finrank_le_one :=
    (targetRankOneUpperBound_iff_trivialModulePartUpperBound
      (A := A) (B := B)).1 O.target_invariants_finrank_le_one

/-- **R700 substantive theorem (4/7)**: explicit finite trivial-module
multiplicity recovers the R698 finite target-rank contract. -/
def finiteTargetRankOneContract_of_finiteTrivialMultiplicityContract
    (O : EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualFiniteTargetRankOneContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_finite :=
    (targetInvariantsFinite_iff_trivialModulePartFinite
      (A := A) (B := B)).2 O.trivialModulePart_finite
  target_invariants_finrank_le_one :=
    (targetRankOneUpperBound_iff_trivialModulePartUpperBound
      (A := A) (B := B)).2 O.trivialModulePart_finrank_le_one

/-- **R700 substantive theorem (5/7)**: the explicit finite multiplicity
contract forgets to the earlier R645 upper-bound contract. -/
def trivialModuleUpperBoundContract_of_finiteTrivialMultiplicityContract
    (O : EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualTrivialModuleUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_upper_bound := O.trivialModulePart_finrank_le_one

/-- **R700 substantive theorem (6/7)**: R698 and the explicit finite
trivial-module multiplicity contract are the same inhabited residual ledger. -/
theorem residual_finiteTargetRankOne_nonempty_iff_finiteTrivialMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualFiniteTargetRankOneContract A B) <->
      Nonempty (EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteTrivialMultiplicityContract_of_finiteTargetRankOneContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteTargetRankOneContract_of_finiteTrivialMultiplicityContract
            (A := A) (B := B) O)))

/-- **R700 substantive theorem (7/7)**: the R696 boundary/source route is
equivalent to boundary data plus explicit finite trivial-module multiplicity. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_finiteTrivialMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualFiniteTrivialMultiplicityContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_finiteTargetRankOne_nonempty
    (A := A) (B := B)).trans
    (residual_finiteTargetRankOne_nonempty_iff_finiteTrivialMultiplicity_nonempty
      (A := A) (B := B))

end FiniteRankOneTrivialMultiplicity

/-- R700 target names for route summaries. -/
def currentR700FiniteTrivialMultiplicityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R700 multiplicity normalization. -/
structure R700FiniteTrivialMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  targetFiniteEquivalentToTrivialFinite : Bool
  targetRankOneEquivalentToTrivialMultiplicity : Bool
  finiteTargetRankOneEquivalentToFiniteTrivialMultiplicity : Bool
  boundarySourceRouteEquivalentToFiniteTrivialMultiplicity : Bool
  finiteTrivialMultiplicityFeedsR645 : Bool
  provesBoundaryData : Bool
  provesFiniteTrivialMultiplicity : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R700 status: the R698 finite rank-one target is now the explicit
finite trivial-module multiplicity target. -/
def currentR700FiniteTrivialMultiplicitySnapshot :
    R700FiniteTrivialMultiplicitySnapshot where
  proofWorkObligationCount :=
    currentR700FiniteTrivialMultiplicityTargetNames.length
  targetFiniteEquivalentToTrivialFinite := true
  targetRankOneEquivalentToTrivialMultiplicity := true
  finiteTargetRankOneEquivalentToFiniteTrivialMultiplicity := true
  boundarySourceRouteEquivalentToFiniteTrivialMultiplicity := true
  finiteTrivialMultiplicityFeedsR645 := true
  provesBoundaryData := false
  provesFiniteTrivialMultiplicity := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R700 route ledger. -/
theorem currentR700FiniteTrivialMultiplicitySnapshot_eq_texStatus :
    currentR700FiniteTrivialMultiplicitySnapshot =
      ({ proofWorkObligationCount := 2
         targetFiniteEquivalentToTrivialFinite := true
         targetRankOneEquivalentToTrivialMultiplicity := true
         finiteTargetRankOneEquivalentToFiniteTrivialMultiplicity := true
         boundarySourceRouteEquivalentToFiniteTrivialMultiplicity := true
         finiteTrivialMultiplicityFeedsR645 := true
         provesBoundaryData := false
         provesFiniteTrivialMultiplicity := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R700FiniteTrivialMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R700 route. -/
theorem currentR700FiniteTrivialMultiplicityTargetNames_eq_texStatus :
    currentR700FiniteTrivialMultiplicityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
    ] := by
  rfl

def R700_substantiveTheoremCount : Nat := 7

end FrontC135_H8ResidualFiniteRankOneTrivialMultiplicity
end HCGapL4
end HodgeReduction
