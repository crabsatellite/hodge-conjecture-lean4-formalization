/-
# HC Gap L4 -- Front C97: Cartan-to-compactDual line target (R661).

R660 moved the source generator obligation to `h^4 ∈ compactDual`.
R575/R582 already show that this is exactly the one-sided Cartan carrier
direction

  `CartanCompactDualIso.trivialModuleGK_H8 <= compactDual`.

This file connects that equivalence to the current R660 residual contract.
It keeps the source-side geometric target as a carrier containment rather
than an isolated element-membership statement, and prevents the route ledger
from counting the two spellings as different gaps.
-/

import HodgeReduction.HCGapL4.FrontC34_CartanContainmentsForCompactDual
import HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence
import HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC97_H8ResidualCartanToCompactDualLine

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC34_CartanContainmentsForCompactDual
open FrontC41_CartanContainmentCarrierEquivalence
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC96_H8ResidualSourceGeneratorFromCompactDual

section CartanToCompactDualLine

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
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R661 substantive theorem (1/6)**: the compact-dual generator target is
equivalent to the one-sided Cartan-to-compactDual carrier containment. -/
theorem cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual :
    (LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) ↔
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) := by
  constructor
  · intro hcartan
    exact h_pow_4_mem_compactDual_of_cartan_le_compactDual
      (A := A) (B := B) hcartan
  · intro hh
    exact cartan_le_carrier_of_h_pow_4_mem
      (A := A)
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      hh

/-- The R661 Cartan-to-compactDual residual package.  This is the same R660
contract with `h^4 ∈ compactDual` replaced by the equivalent line containment
`CartanH8 <= compactDual`. -/
structure EVIIH8ResidualCartanToCompactDualLineContract
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
  cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R661 substantive theorem (2/6)**: the Cartan-containment package feeds
the R660 compact-dual generator package. -/
def compactDualGeneratorLineContract_of_cartanToCompactDualLineContract
    (O : EVIIH8ResidualCartanToCompactDualLineContract A B) :
    EVIIH8ResidualCompactDualGeneratorLineContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  h_pow_four_mem_compactDual :=
    (cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R661 substantive theorem (3/6)**: the R660 compact-dual generator
package recovers the equivalent Cartan-containment package. -/
def cartanToCompactDualLineContract_of_compactDualGeneratorLineContract
    (O : EVIIH8ResidualCompactDualGeneratorLineContract A B) :
    EVIIH8ResidualCartanToCompactDualLineContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  cartanH8_le_compactDual :=
    (cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).2 O.h_pow_four_mem_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R661 substantive theorem (4/6)**: at the inhabited-contract level, the
R660 source-generator package and the Cartan-containment package are exactly
the same residual target. -/
theorem residual_compactDualGeneratorLine_nonempty_iff_cartanToCompactDualLine_nonempty :
    Nonempty (EVIIH8ResidualCompactDualGeneratorLineContract A B) ↔
      Nonempty (EVIIH8ResidualCartanToCompactDualLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanToCompactDualLineContract_of_compactDualGeneratorLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualGeneratorLineContract_of_cartanToCompactDualLineContract
            (A := A) (B := B) O)))

/-- **R661 substantive theorem (5/6)**: the Cartan-containment package feeds
the R641 quotient-vanishing contract through R660. -/
def targetInvariantExcessQuotientContract_of_cartanToCompactDualLineContract
    (O : EVIIH8ResidualCartanToCompactDualLineContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B :=
  targetInvariantExcessQuotientContract_of_compactDualGeneratorLineContract
    (A := A) (B := B)
    (compactDualGeneratorLineContract_of_cartanToCompactDualLineContract
      (A := A) (B := B) O)

omit [MatsushimaSurjectivityData A B] in
/-- **R661 substantive theorem (6/6)**: Cartan-to-compactDual containment
plus target generator-line containment proves the source-H8 equality. -/
theorem source_invariants_eq_H8_of_cartanH8_le_compactDual_and_line
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_compactDual_and_line
    (A := A) (B := B)
    ((cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 hcartan)
    hline

end CartanToCompactDualLine

/-- R661 target names for route summaries. -/
def currentR661CartanToCompactDualLineTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove CartanH8 <= compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R661 Cartan-to-compactDual bridge. -/
structure R661CartanToCompactDualLineSnapshot where
  proofWorkObligationCount : Nat
  cartanContainmentEquivalentToCompactDualGenerator : Bool
  cartanContractEquivalentToCompactDualGeneratorContract : Bool
  cartanContractFeedsQuotientContract : Bool
  cartanContainmentPlusLineGivesSourceH8 : Bool
  provesCartanContainment : Bool
  provesLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R661 status: source generator membership and Cartan-to-compactDual
containment are the same live target; neither is proved here. -/
def currentR661CartanToCompactDualLineSnapshot :
    R661CartanToCompactDualLineSnapshot where
  proofWorkObligationCount := currentR661CartanToCompactDualLineTargetNames.length
  cartanContainmentEquivalentToCompactDualGenerator := true
  cartanContractEquivalentToCompactDualGeneratorContract := true
  cartanContractFeedsQuotientContract := true
  cartanContainmentPlusLineGivesSourceH8 := true
  provesCartanContainment := false
  provesLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R661 ledger. -/
theorem currentR661CartanToCompactDualLineSnapshot_eq_texStatus :
    currentR661CartanToCompactDualLineSnapshot =
      ({ proofWorkObligationCount := 3
         cartanContainmentEquivalentToCompactDualGenerator := true
         cartanContractEquivalentToCompactDualGeneratorContract := true
         cartanContractFeedsQuotientContract := true
         cartanContainmentPlusLineGivesSourceH8 := true
         provesCartanContainment := false
         provesLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R661CartanToCompactDualLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R661 ledger. -/
theorem currentR661CartanToCompactDualLineTargetNames_eq_texStatus :
    currentR661CartanToCompactDualLineTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove CartanH8 <= compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R661_substantiveTheoremCount : Nat := 6

end FrontC97_H8ResidualCartanToCompactDualLine
end HCGapL4
end HodgeReduction
