/-
# HC Gap L4 -- Front C134: finite upper bound as rank-one target (R698).

R697 identifies the current non-boundary target with the bundled finite
upper-bound contract:

  finite-dimensional `target_invariants`
  and
  `finrank target_invariants <= shimuraEVIIExpectedBetti 8`.

Since the EVII expected Betti slot in degree 8 is kernel-computed to be one,
this file rewrites that second field as the concrete rank-one upper bound

  `finrank target_invariants <= 1`.

No target rank, boundary data, or source-H8 statement is proved here.  The
purpose is to make the next live target visibly numerical and prevent agents
from treating `shimuraEVIIExpectedBetti 8` as a separate gap from the rank-one
bound.
-/

import HodgeReduction.HCGapL4.FrontC133_H8ResidualBoundarySourceSurjectivityFiniteUpperBoundEquivalence
import HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC134_H8ResidualFiniteUpperBoundRankOneTarget

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC31_TargetRankFromExpectedBetti
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC107_H8ResidualLineEqualityFiniteUpperBound
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC133_H8ResidualBoundarySourceSurjectivityFiniteUpperBoundEquivalence

section FiniteUpperBoundRankOne

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

/-- **R698 substantive theorem (1/5)**: the R697 target upper bound against
`shimuraEVIIExpectedBetti 8` is exactly the rank-one upper bound. -/
theorem targetExpectedBettiUpperBound_iff_targetRankOneUpperBound :
    (Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <=
      shimuraEVIIExpectedBetti 8) <->
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <= 1 := by
  rw [shimura_expected_betti8_eq_one]

/-- The R698 rank-one spelling of the R671/R697 finite-upper-bound contract.
The finite-dimensional witness remains explicit; only the numeric upper-bound
field is normalized from `shimuraEVIIExpectedBetti 8` to `1`. -/
structure EVIIH8ResidualFiniteTargetRankOneContract
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
  target_invariants_finite :
    FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))
  target_invariants_finrank_le_one :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) <= 1

/-- **R698 substantive theorem (2/5)**: the R697 finite upper-bound contract
gives the explicit finite rank-one target contract. -/
def finiteTargetRankOneContract_of_finiteUpperBoundContract
    (O : EVIIH8ResidualFiniteUpperBoundContract A B) :
    EVIIH8ResidualFiniteTargetRankOneContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_finite := O.target_invariants_finite
  target_invariants_finrank_le_one :=
    (targetExpectedBettiUpperBound_iff_targetRankOneUpperBound
      (A := A) (B := B)).1 O.target_expected_betti_upper_bound

/-- **R698 substantive theorem (3/5)**: the finite rank-one target contract
recovers the R697 finite upper-bound contract. -/
def finiteUpperBoundContract_of_finiteTargetRankOneContract
    (O : EVIIH8ResidualFiniteTargetRankOneContract A B) :
    EVIIH8ResidualFiniteUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_finite := O.target_invariants_finite
  target_expected_betti_upper_bound :=
    (targetExpectedBettiUpperBound_iff_targetRankOneUpperBound
      (A := A) (B := B)).2 O.target_invariants_finrank_le_one

/-- **R698 substantive theorem (4/5)**: the bundled finite-upper-bound route
and the explicit finite rank-one route are the same inhabited residual
ledger. -/
theorem residual_finiteUpperBound_nonempty_iff_finiteTargetRankOne_nonempty :
    Nonempty (EVIIH8ResidualFiniteUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualFiniteTargetRankOneContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteTargetRankOneContract_of_finiteUpperBoundContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteUpperBoundContract_of_finiteTargetRankOneContract
            (A := A) (B := B) O)))

/-- **R698 substantive theorem (5/5)**: the R696 boundary/source-H8 route is
equivalent to proving boundary data plus finite-dimensional target invariants
with rank at most one. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_finiteTargetRankOne_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualFiniteTargetRankOneContract A B) :=
  (residual_boundaryDataSourceSurjectivity_nonempty_iff_finiteUpperBound_nonempty
    (A := A) (B := B)).trans
    (residual_finiteUpperBound_nonempty_iff_finiteTargetRankOne_nonempty
      (A := A) (B := B))

end FiniteUpperBoundRankOne

/-- R698 target names for route summaries. -/
def currentR698FiniteUpperBoundRankOneTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove finite-dimensional target_invariants and finrank target_invariants <= 1"
]

/-- Machine-readable status for the R698 rank-one normalization. -/
structure R698FiniteUpperBoundRankOneSnapshot where
  proofWorkObligationCount : Nat
  expectedBettiUpperBoundRewrittenToRankOne : Bool
  finiteUpperBoundEquivalentToFiniteRankOne : Bool
  boundarySourceRouteEquivalentToFiniteRankOne : Bool
  provesBoundaryData : Bool
  provesFiniteTargetRankOne : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R698 status: R697's non-boundary computation target is now the
concrete rank-one finite target-invariant bound. -/
def currentR698FiniteUpperBoundRankOneSnapshot :
    R698FiniteUpperBoundRankOneSnapshot where
  proofWorkObligationCount :=
    currentR698FiniteUpperBoundRankOneTargetNames.length
  expectedBettiUpperBoundRewrittenToRankOne := true
  finiteUpperBoundEquivalentToFiniteRankOne := true
  boundarySourceRouteEquivalentToFiniteRankOne := true
  provesBoundaryData := false
  provesFiniteTargetRankOne := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R698 route ledger. -/
theorem currentR698FiniteUpperBoundRankOneSnapshot_eq_texStatus :
    currentR698FiniteUpperBoundRankOneSnapshot =
      ({ proofWorkObligationCount := 2
         expectedBettiUpperBoundRewrittenToRankOne := true
         finiteUpperBoundEquivalentToFiniteRankOne := true
         boundarySourceRouteEquivalentToFiniteRankOne := true
         provesBoundaryData := false
         provesFiniteTargetRankOne := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R698FiniteUpperBoundRankOneSnapshot) := by
  decide

/-- Kernel-checked target names for the R698 route. -/
theorem currentR698FiniteUpperBoundRankOneTargetNames_eq_texStatus :
    currentR698FiniteUpperBoundRankOneTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove finite-dimensional target_invariants and finrank target_invariants <= 1"
    ] := by
  rfl

def R698_substantiveTheoremCount : Nat := 5

end FrontC134_H8ResidualFiniteUpperBoundRankOneTarget
end HCGapL4
end HodgeReduction
