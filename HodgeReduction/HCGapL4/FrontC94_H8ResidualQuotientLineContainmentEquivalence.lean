/-
# HC Gap L4 -- Front C94: quotient vanishing versus generator-line containment (R658).

R657 showed that a finite-dimensional multiplicity upper bound feeds the
R656 line-containment target.  The older R648 quotient formulation is sharper:
once `source_invariants = H8`, quotient vanishing is already equivalent to
Cartan scalar preimages, and R656 identifies scalar preimages with containment
in the explicit non-zero line `span {j_q(h^4)}`.

This file records that direct route.  It removes the finite-dimensional
consumer dependency from the preferred attack path: the live target is now
the quotient-vanishing / generator-line containment theorem itself, not a
separate rank-conversion wrapper.
-/

import HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite
import HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC94_H8ResidualQuotientLineContainmentEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC84_H8ResidualScalarPreimageQuotientEquivalence
open FrontC87_H8ResidualInvariantMapSurjectivity
open FrontC88_H8ResidualInvariantMapBijectivity
open FrontC92_H8ResidualCartanGeneratorLineCriterion

section QuotientLineEquivalence

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

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R658 substantive theorem (1/7)**: after `source_invariants = H8`,
the R641 quotient target is exactly the R656 generator-line containment
target.  No finite-dimensional target-invariant or trivial-module
hypothesis is used. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ ↔
      CuspidalCohomologyData.trivialModulePart (A := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
  (targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage
    (A := A) (B := B) hsource_H8).trans
    (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B))

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R658 substantive theorem (2/7)**: quotient vanishing gives the concrete
generator-line containment directly, without going through the finite rank
consumer used in R657. -/
theorem trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hquot : targetInvariantExcessQuotient A B = ⊥) :
    CuspidalCohomologyData.trivialModulePart (A := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} :=
  (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B) hsource_H8).1 hquot

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R658 substantive theorem (3/7)**: quotient vanishing gives restricted
invariant-map bijectivity directly.  This is the R652 consumer form and does
not need source-H8. -/
theorem sourceToTargetInvariantMap_bijective_of_targetInvariantExcessQuotient
    (hquot : targetInvariantExcessQuotient A B = ⊥) :
    Function.Bijective (sourceToTargetInvariantMap A B) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective
    (A := A) (B := B)).1 hquot

/-- **R658 substantive theorem (4/7)**: the R641 quotient-vanishing contract
feeds the R656 generator-line containment contract with no finite-dimensional
rank hypothesis. -/
def cartanLineContainmentContract_of_targetInvariantExcessQuotientContract_noFinite
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualCartanLineContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_le_h_pow_four_line :=
    trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_excess_quotient_eq_bot

/-- **R658 substantive theorem (5/7)**: the R656 generator-line containment
contract rebuilds the R641 quotient-vanishing contract. -/
def targetInvariantExcessQuotientContract_of_cartanLineContainmentContract
    (O : EVIIH8ResidualCartanLineContainmentContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B) O.source_invariants_eq_H8).2
      O.trivialModulePart_le_h_pow_four_line

/-- **R658 substantive theorem (6/7)**: quotient vanishing and generator-line
containment are equivalent residual contracts. -/
theorem residual_targetInvariantExcessQuotient_nonempty_iff_cartanLine_nonempty_noFinite :
    Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) ↔
      Nonempty (EVIIH8ResidualCartanLineContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanLineContainmentContract_of_targetInvariantExcessQuotientContract_noFinite
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_cartanLineContainmentContract
            (A := A) (B := B) O)))

/-- **R658 substantive theorem (7/7)**: the quotient-vanishing contract also
feeds the R652 bijectivity contract directly. -/
def invariantMapBijectivityContract_of_targetInvariantExcessQuotientContract_noFinite
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualInvariantMapBijectivityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  source_to_target_invariant_map_bijective :=
    sourceToTargetInvariantMap_bijective_of_targetInvariantExcessQuotient
      (A := A) (B := B)
      O.target_excess_quotient_eq_bot

end QuotientLineEquivalence

/-- R658 target names for route summaries. -/
def currentR658QuotientLineTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove targetInvariantExcessQuotient = bot, equivalently trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R658 quotient/line bridge. -/
structure R658QuotientLineSnapshot where
  proofWorkObligationCount : Nat
  quotientEquivalentToGeneratorLineContainment : Bool
  quotientFeedsLineContainmentWithoutFiniteTarget : Bool
  quotientFeedsInvariantMapBijectivityWithoutFiniteTarget : Bool
  provesQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R658 status: the preferred target-side theorem is quotient
vanishing / generator-line containment itself.  R657's finite-dimensional
multiplicity consumer remains valid, but it is not required to consume a
quotient-vanishing proof. -/
def currentR658QuotientLineSnapshot :
    R658QuotientLineSnapshot where
  proofWorkObligationCount := currentR658QuotientLineTargetNames.length
  quotientEquivalentToGeneratorLineContainment := true
  quotientFeedsLineContainmentWithoutFiniteTarget := true
  quotientFeedsInvariantMapBijectivityWithoutFiniteTarget := true
  provesQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R658 ledger. -/
theorem currentR658QuotientLineSnapshot_eq_texStatus :
    currentR658QuotientLineSnapshot =
      ({ proofWorkObligationCount := 3
         quotientEquivalentToGeneratorLineContainment := true
         quotientFeedsLineContainmentWithoutFiniteTarget := true
         quotientFeedsInvariantMapBijectivityWithoutFiniteTarget := true
         provesQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R658QuotientLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R658 ledger. -/
theorem currentR658QuotientLineTargetNames_eq_texStatus :
    currentR658QuotientLineTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove targetInvariantExcessQuotient = bot, equivalently trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R658_substantiveTheoremCount : Nat := 7

end FrontC94_H8ResidualQuotientLineContainmentEquivalence
end HCGapL4
end HodgeReduction
