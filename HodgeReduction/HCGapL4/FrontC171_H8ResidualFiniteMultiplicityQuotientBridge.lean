/-
# HC Gap L4 -- Front C171: finite multiplicity as quotient vanishing (R736).

R734 rewrites the latest target-line theorem as explicit finite
rank-one `trivialModulePart` multiplicity under `H8 <= compactDual`.  R735
then records that the current paper-facing carrier stack does not force that
finite multiplicity.

This file connects that finite-multiplicity spelling back to the older
R641/R648/R658 target-side surface:

  `targetInvariantExcessQuotient A B = ⊥`.

The bridge is exact, not a new assumption.  From the R734 contract, boundary
data plus `H8 <= compactDual` and finite multiplicity gives the target line,
then the compact-dual H8 equality, hence `source_invariants = H8`, exact
image, and quotient vanishing.  Conversely, boundary data, `H8 <= compactDual`,
`source_invariants = H8`, and quotient vanishing recover the target line and
therefore the finite-multiplicity fields.

So the next target-side attack may work on finite trivial multiplicity,
generator-line containment, scalar preimages, or quotient vanishing as one
kernel-checked gap.
-/

import HodgeReduction.HCGapL4.FrontC170_H8ResidualFiniteMultiplicityIndependence
import HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC171_H8ResidualFiniteMultiplicityQuotientBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC94_H8ResidualQuotientLineContainmentEquivalence
open FrontC168_H8ResidualNoExtraTargetLineEquivalence
open FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
open FrontC170_H8ResidualFiniteMultiplicityIndependence

section FiniteMultiplicityQuotientBridge

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

/-- The R736 quotient replacement for the R734 finite-multiplicity fields.
The `source_invariants = H8` field is included because the existing
R641/R658 quotient bridge is intentionally stated after the source carrier
has been fixed.  R736 proves this whole contract is equivalent to the R734
finite-multiplicity contract, so it is not a stronger route.
-/
structure EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract
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
  H8_le_compactDual :
    CompactDualData.H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_excess_quotient_eq_bot :
    targetInvariantExcessQuotient A B = ⊥

/-- **R736 substantive theorem (1/8)**: the R734 finite-multiplicity
contract already proves the source-H8 equality used by the older
quotient/scalar-preimage surface.
-/
theorem source_invariants_eq_H8_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  letI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  have hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    trivialModulePart_le_h_pow_four_line_of_H8_le_compactDual_finiteMultiplicity
      (A := A) (B := B)
      O.H8_le_compactDual
      O.trivialModulePart_finrank_le_one
  have hcompact_le :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
        CompactDualData.H8 (A := A) :=
    compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
      (A := A) (B := B)
      O.boundary O.H8_le_compactDual hline
  have hcompact_eq :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    le_antisymm hcompact_le O.H8_le_compactDual
  calc
    MatsushimaData.source_invariants (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        (MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)).symm
    _ = CompactDualData.H8 (A := A) := hcompact_eq

/-- **R736 substantive theorem (2/8)**: the same R734 contract supplies the
exact-image carrier required by the R641 quotient contract.  This uses the
boundary source equality plus the existing `compactDual = source_invariants`
comparison.
-/
theorem sourceInvariantExactImage_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    sourceInvariantExactImageTarget A B := by
  have hsource_eq_invariants :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B) :=
    O.boundary.source_eq_compactDual.trans
      (MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B))
  exact
    sourceInvariantExactImage_of_source_eq_invariants
      (A := A) (B := B) hsource_eq_invariants

/-- **R736 substantive theorem (3/8)**: finite trivial multiplicity under
the current H8 containment gives quotient vanishing.  This identifies the
R734 finite-multiplicity target with the older R641/R658 quotient target.
-/
theorem targetInvariantExcessQuotient_eq_bot_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    targetInvariantExcessQuotient A B = ⊥ := by
  letI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    O.trivialModulePart_finite
  have hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    source_invariants_eq_H8_of_H8ContainmentFiniteTrivialMultiplicityContract
      (A := A) (B := B) O
  have hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
    trivialModulePart_le_h_pow_four_line_of_H8_le_compactDual_finiteMultiplicity
      (A := A) (B := B)
      O.H8_le_compactDual
      O.trivialModulePart_finrank_le_one
  exact
    (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B) hsource_H8).2 hline

/-- **R736 substantive theorem (4/8)**: the R734 finite-multiplicity
contract can be rewritten as boundary data, H8 containment, source-H8, and
quotient vanishing.
-/
def quotientContract_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_H8ContainmentFiniteTrivialMultiplicityContract
      (A := A) (B := B) O
  target_excess_quotient_eq_bot :=
    targetInvariantExcessQuotient_eq_bot_of_H8ContainmentFiniteTrivialMultiplicityContract
      (A := A) (B := B) O

/-- **R736 substantive theorem (5/8)**: conversely, the quotient spelling
recovers the explicit finite-dimensional witness and rank-one bound from
R734.  The quotient field gives the target line via R658, and R734 converts
that line to finite multiplicity under `H8 <= compactDual`.
-/
def H8ContainmentFiniteTrivialMultiplicityContract_of_quotientContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_finite :=
    (finiteMultiplicity_of_H8_le_compactDual_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)
      O.H8_le_compactDual
      ((targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
        (A := A) (B := B) O.source_invariants_eq_H8).1
        O.target_excess_quotient_eq_bot)).1
  trivialModulePart_finrank_le_one :=
    (finiteMultiplicity_of_H8_le_compactDual_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)
      O.H8_le_compactDual
      ((targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
        (A := A) (B := B) O.source_invariants_eq_H8).1
        O.target_excess_quotient_eq_bot)).2

/-- **R736 substantive theorem (6/8)**: the R734 finite-multiplicity route
and the R736 quotient route are the same inhabited residual contract.
-/
theorem residual_H8ContainmentFiniteTrivialMultiplicity_nonempty_iff_H8ContainmentQuotient_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (quotientContract_of_H8ContainmentFiniteTrivialMultiplicityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentFiniteTrivialMultiplicityContract_of_quotientContract
            (A := A) (B := B) O)))

/-- **R736 substantive theorem (7/8)**: the R734 contract also feeds the
older R641 quotient-vanishing contract directly, including its exact-image
carrier.
-/
def targetInvariantExcessQuotientContract_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImage_of_H8ContainmentFiniteTrivialMultiplicityContract
      (A := A) (B := B) O
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_H8ContainmentFiniteTrivialMultiplicityContract
      (A := A) (B := B) O
  target_excess_quotient_eq_bot :=
    targetInvariantExcessQuotient_eq_bot_of_H8ContainmentFiniteTrivialMultiplicityContract
      (A := A) (B := B) O

/-- **R736 substantive theorem (8/8)**: the current R727--R734 residual is
equivalently boundary data, `H8 <= compactDual`, source-H8, and quotient
vanishing.  This keeps finite multiplicity and quotient vanishing from being
counted as separate gaps.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentQuotient_nonempty :
    Nonempty (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentQuotientContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentFiniteTrivialMultiplicity_nonempty_iff_H8ContainmentQuotient_nonempty
      (A := A) (B := B))

end FiniteMultiplicityQuotientBridge

/-- R736 target names for route summaries. -/
def currentR736FiniteMultiplicityQuotientTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove source_invariants = H8",
  "prove targetInvariantExcessQuotient = bot; equivalent to finite trivial multiplicity under H8 containment"
]

/-- Machine-readable status for the R736 finite-multiplicity/quotient bridge. -/
structure R736FiniteMultiplicityQuotientSnapshot where
  proofWorkObligationCount : Nat
  finiteMultiplicityFeedsSourceH8 : Bool
  finiteMultiplicityFeedsExactImage : Bool
  finiteMultiplicityFeedsQuotientVanishing : Bool
  quotientRouteEquivalentToFiniteMultiplicityRoute : Bool
  quotientContractFeedsOldR641Contract : Bool
  consumesR735Guardrail : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesQuotientVanishing : Bool
  provesFiniteMultiplicity : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R736 status: finite trivial multiplicity, line containment,
scalar preimages, and quotient vanishing have been reconnected as one
target-side gap under the current H8-containment route.
-/
def currentR736FiniteMultiplicityQuotientSnapshot :
    R736FiniteMultiplicityQuotientSnapshot where
  proofWorkObligationCount := currentR736FiniteMultiplicityQuotientTargetNames.length
  finiteMultiplicityFeedsSourceH8 := true
  finiteMultiplicityFeedsExactImage := true
  finiteMultiplicityFeedsQuotientVanishing := true
  quotientRouteEquivalentToFiniteMultiplicityRoute := true
  quotientContractFeedsOldR641Contract := true
  consumesR735Guardrail :=
    currentR735FiniteMultiplicityIndependenceSnapshot.finiteMultiplicityStillAutomorphicTarget
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesQuotientVanishing := false
  provesFiniteMultiplicity := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R736 quotient bridge. -/
theorem currentR736FiniteMultiplicityQuotientSnapshot_eq_texStatus :
    currentR736FiniteMultiplicityQuotientSnapshot =
      ({ proofWorkObligationCount := 4
         finiteMultiplicityFeedsSourceH8 := true
         finiteMultiplicityFeedsExactImage := true
         finiteMultiplicityFeedsQuotientVanishing := true
         quotientRouteEquivalentToFiniteMultiplicityRoute := true
         quotientContractFeedsOldR641Contract := true
         consumesR735Guardrail := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesQuotientVanishing := false
         provesFiniteMultiplicity := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R736FiniteMultiplicityQuotientSnapshot) := by
  decide

/-- Kernel-checked target names for the R736 route. -/
theorem currentR736FiniteMultiplicityQuotientTargetNames_eq_texStatus :
    currentR736FiniteMultiplicityQuotientTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove source_invariants = H8",
      "prove targetInvariantExcessQuotient = bot; equivalent to finite trivial multiplicity under H8 containment"
    ] := by
  rfl

def R736_substantiveTheoremCount : Nat := 8

end FrontC171_H8ResidualFiniteMultiplicityQuotientBridge
end HCGapL4
end HodgeReduction
