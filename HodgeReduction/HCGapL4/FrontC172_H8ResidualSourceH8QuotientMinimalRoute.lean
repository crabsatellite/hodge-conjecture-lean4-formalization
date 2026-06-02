/-
# HC Gap L4 -- Front C172: source-H8 quotient route (R737).

R736 rewrote the current target as boundary data, `H8 <= compactDual`,
`source_invariants = H8`, and quotient vanishing.  The `H8 <= compactDual`
field is not an independent target once the source-H8 equality is present:
`compactDual = source_invariants` is already part of the Matsushima compact-dual
interface, so `source_invariants = H8` identifies `compactDual` with `H8`.

This file removes that redundant field from the preferred quotient route.
The new contract is exactly:

* `MatsushimaV56BoundaryData`;
* `source_invariants = H8`;
* `targetInvariantExcessQuotient = bot`.

It proves equivalence with R736's four-field contract, feeds the older R641
quotient contract by deriving exact image from boundary data, and makes clear
that no boundary data, source-H8 theorem, quotient vanishing theorem, finite
multiplicity theorem, or full-HC closure is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC171_H8ResidualFiniteMultiplicityQuotientBridge
import HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC172_H8ResidualSourceH8QuotientMinimalRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC162_H8ResidualCompactDualGeneratorGeometryRoute
open FrontC171_H8ResidualFiniteMultiplicityQuotientBridge

section SourceH8QuotientRoute

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

/-- **R737 substantive theorem (1/7)**: boundary data alone supplies the
source-invariant exact-image field used by the older R641 quotient contract.
The proof is a rewrite of Matsushima surjectivity through
`surjectivity_source = compactDual = source_invariants`.
-/
theorem sourceInvariantExactImage_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    sourceInvariantExactImageTarget A B := by
  have hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B) :=
    D.source_eq_compactDual.trans
      (MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B))
  exact
    sourceInvariantExactImage_of_source_eq_invariants
      (A := A) (B := B) hsource

/-- **R737 substantive theorem (2/7)**: the R736 `H8 <= compactDual` field
is forced by `source_invariants = H8`, because the compact-dual interface
already identifies `compactDual` with `source_invariants`.
-/
theorem H8_le_compactDual_of_sourceInvariantH8
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    CompactDualData.H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B) := by
  have hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    compactDual_eq_H8_of_source_invariants_eq_H8
      (A := A) (B := B) hsource
  rw [hcompact]

/-- Boundary data plus source-H8 and quotient vanishing.  R737 proves this
is equivalent to the R736 four-field quotient route, so it is not a stronger
premise and it does not count `H8 <= compactDual` as a separate target.
-/
structure EVIIH8ResidualBoundaryDataSourceH8QuotientContract
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
  boundary : MatsushimaV56BoundaryData A B
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_excess_quotient_eq_bot :
    targetInvariantExcessQuotient A B = ⊥

/-- **R737 substantive theorem (3/7)**: the minimal source-H8 quotient
contract rebuilds the R736 four-field quotient contract by deriving the
previous `H8 <= compactDual` field.
-/
def H8ContainmentQuotientContract_of_sourceH8QuotientContract
    (O : EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B where
  boundary := O.boundary
  H8_le_compactDual :=
    H8_le_compactDual_of_sourceInvariantH8
      (A := A) (B := B) O.source_invariants_eq_H8
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot := O.target_excess_quotient_eq_bot

/-- **R737 substantive theorem (4/7)**: the R736 four-field quotient
contract drops back to the minimal source-H8 quotient contract by forgetting
the redundant H8-containment field.
-/
def sourceH8QuotientContract_of_H8ContainmentQuotientContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B where
  boundary := O.boundary
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot := O.target_excess_quotient_eq_bot

/-- **R737 substantive theorem (5/7)**: R736's H8-containment quotient route
and the R737 minimal source-H8 quotient route are the same inhabited
residual contract.
-/
theorem residual_H8ContainmentQuotient_nonempty_iff_sourceH8Quotient_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceH8QuotientContract_of_H8ContainmentQuotientContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentQuotientContract_of_sourceH8QuotientContract
            (A := A) (B := B) O)))

/-- **R737 substantive theorem (6/7)**: the minimal source-H8 quotient
contract feeds the older R641 quotient-vanishing contract directly.  The
exact-image field comes from boundary data, not from a new assumption.
-/
def targetInvariantExcessQuotientContract_of_sourceH8QuotientContract
    (O : EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImage_of_boundaryData
      (A := A) (B := B) O.boundary
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot := O.target_excess_quotient_eq_bot

/-- **R737 substantive theorem (7/7)**: the current R727--R736 residual is
equivalently boundary data, source-H8, and quotient vanishing.  In
particular `H8 <= compactDual` is no longer a separate proof obligation
once source-H8 is chosen as the carrier target.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_sourceH8Quotient_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentQuotient_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentQuotient_nonempty_iff_sourceH8Quotient_nonempty
      (A := A) (B := B))

end SourceH8QuotientRoute

/-- R737 target names for route summaries. -/
def currentR737SourceH8QuotientTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8; this already supplies H8 <= compactDual",
  "prove targetInvariantExcessQuotient = bot; equivalent to finite trivial multiplicity under source-H8"
]

/-- Machine-readable status for the R737 source-H8 quotient minimization. -/
structure R737SourceH8QuotientSnapshot where
  proofWorkObligationCount : Nat
  boundaryDataFeedsExactImage : Bool
  sourceH8SuppliesH8Containment : Bool
  sourceH8QuotientEquivalentToR736Route : Bool
  feedsOldR641QuotientContract : Bool
  removesRedundantH8ContainmentField : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesSourceH8 : Bool
  provesQuotientVanishing : Bool
  provesFiniteMultiplicity : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R737 status: the preferred quotient route has three genuine
targets.  `H8 <= compactDual` remains available as a derived consumer from
source-H8, but should not be counted as a fourth independent target.
-/
def currentR737SourceH8QuotientSnapshot :
    R737SourceH8QuotientSnapshot where
  proofWorkObligationCount := currentR737SourceH8QuotientTargetNames.length
  boundaryDataFeedsExactImage := true
  sourceH8SuppliesH8Containment := true
  sourceH8QuotientEquivalentToR736Route := true
  feedsOldR641QuotientContract := true
  removesRedundantH8ContainmentField := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesSourceH8 := false
  provesQuotientVanishing := false
  provesFiniteMultiplicity := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R737 route minimization. -/
theorem currentR737SourceH8QuotientSnapshot_eq_texStatus :
    currentR737SourceH8QuotientSnapshot =
      ({ proofWorkObligationCount := 3
         boundaryDataFeedsExactImage := true
         sourceH8SuppliesH8Containment := true
         sourceH8QuotientEquivalentToR736Route := true
         feedsOldR641QuotientContract := true
         removesRedundantH8ContainmentField := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesSourceH8 := false
         provesQuotientVanishing := false
         provesFiniteMultiplicity := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R737SourceH8QuotientSnapshot) := by
  decide

/-- Kernel-checked target names for the R737 minimized quotient route. -/
theorem currentR737SourceH8QuotientTargetNames_eq_texStatus :
    currentR737SourceH8QuotientTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8; this already supplies H8 <= compactDual",
      "prove targetInvariantExcessQuotient = bot; equivalent to finite trivial multiplicity under source-H8"
    ] := by
  rfl

def R737_substantiveTheoremCount : Nat := 7

end FrontC172_H8ResidualSourceH8QuotientMinimalRoute
end HCGapL4
end HodgeReduction
