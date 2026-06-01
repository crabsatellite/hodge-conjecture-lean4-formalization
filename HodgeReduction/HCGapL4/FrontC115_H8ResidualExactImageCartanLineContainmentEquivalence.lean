/-
# HC Gap L4 -- Front C115: exact-image Cartan route with target line (R679).

R678 splits the compact-dual carrier target into two Cartan containment
directions, but its target-side item is still written against the abstract
Matsushima surjectivity target:

  `trivialModulePart <= surjectivity_target`.

Under the same exact-image and Cartan containment hypotheses, this file
rewrites that item exactly as the concrete line containment

  `trivialModulePart <= span {j_q(h^4)}`.

The result is an equivalent route with four explicit targets: exact image,
the two Cartan carrier directions, and the target generator-line theorem.
-/

import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion
import HodgeReduction.HCGapL4.FrontC114_H8ResidualExactImageCartanContainmentEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC115_H8ResidualExactImageCartanLineContainmentEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC34_CartanContainmentsForCompactDual
open FrontC47_TargetContainmentScalarPreimageCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC114_H8ResidualExactImageCartanContainmentEquivalence

section TargetLineFromCartanRoute

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

omit [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R679 substantive theorem (1/6)**: once exact image and the two
Cartan carrier directions are fixed, the abstract reverse containment is
exactly the concrete `j_q(h^4)` line containment. -/
theorem targetContainment_iff_h_pow_four_line_of_exactImage_cartan_containments
    (hexact : sourceInvariantExactImageTarget A B)
    (hcompact_le_cartan :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)))
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))) :
    (LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))) <->
      (LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) := by
  have hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    source_invariants_eq_H8_of_compactDual_cartan_containments
      (A := A) (B := B) hcompact_le_cartan hcartan_le_compact
  have hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8
      (A := A) (B := B) hexact hsource_H8
  exact
    (trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
      (A := A) (B := B) hsource_eq_H8).trans
      (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
        (A := A) (B := B))

end TargetLineFromCartanRoute

section ExactImageCartanLineContainment

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

/-- The R679 line-containment spelling of the R678 exact-image Cartan route. -/
structure EVIIH8ResidualExactImageCartanLineContainmentContract where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  compactDual_le_cartanH8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  trivialModulePart_le_h_pow_four_line :
    LE.le
      (CuspidalCohomologyData.trivialModulePart (A := B))
      (Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)})

variable {A B}

/-- **R679 substantive theorem (2/6)**: R678 contracts produce the concrete
target-line spelling. -/
def exactImageCartanLineContainmentContract_of_exactImageCartanContainmentContract
    (O : EVIIH8ResidualExactImageCartanContainmentContract A B) :
    EVIIH8ResidualExactImageCartanLineContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  compactDual_le_cartanH8 := O.compactDual_le_cartanH8
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    (targetContainment_iff_h_pow_four_line_of_exactImage_cartan_containments
      (A := A) (B := B)
      O.source_invariants_exact_image
      O.compactDual_le_cartanH8
      O.cartanH8_le_compactDual).1
      O.trivialModulePart_le_surjectivity_target

/-- **R679 substantive theorem (3/6)**: the concrete target-line spelling
rebuilds the R678 reverse-containment contract. -/
def exactImageCartanContainmentContract_of_exactImageCartanLineContainmentContract
    (O : EVIIH8ResidualExactImageCartanLineContainmentContract A B) :
    EVIIH8ResidualExactImageCartanContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  compactDual_le_cartanH8 := O.compactDual_le_cartanH8
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_surjectivity_target :=
    (targetContainment_iff_h_pow_four_line_of_exactImage_cartan_containments
      (A := A) (B := B)
      O.source_invariants_exact_image
      O.compactDual_le_cartanH8
      O.cartanH8_le_compactDual).2
      O.trivialModulePart_le_h_pow_four_line

omit [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R679 substantive theorem (4/6)**: the R678 abstract target-containment
route and the R679 concrete target-line route are equivalent at the inhabited
contract level. -/
theorem residual_exactImageCartanContainment_nonempty_iff_exactImageCartanLineContainment_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanContainmentContract A B) <->
      Nonempty (EVIIH8ResidualExactImageCartanLineContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCartanLineContainmentContract_of_exactImageCartanContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCartanContainmentContract_of_exactImageCartanLineContainmentContract
            (A := A) (B := B) O)))

/-- **R679 substantive theorem (5/6)**: the concrete target-line Cartan route
is still the current target-line residual. -/
theorem residual_exactImageCartanLineContainment_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanLineContainmentContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_exactImageCartanContainment_nonempty_iff_exactImageCartanLineContainment_nonempty
    (A := A) (B := B)).symm.trans
    (residual_exactImageCartanContainment_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R679 substantive theorem (6/6)**: the concrete target-line Cartan route
is also equivalent to the R675 boundary-data/compact-dual spelling. -/
theorem residual_exactImageCartanLineContainment_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanLineContainmentContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_exactImageCartanLineContainment_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end ExactImageCartanLineContainment

/-- Exact R679 target names for route summaries. -/
def currentR679ExactImageCartanLineContainmentTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove compactDual <= CartanH8",
  "prove CartanH8 <= compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R679 concrete target-line route. -/
structure R679ExactImageCartanLineContainmentSnapshot where
  proofWorkObligationCount : Nat
  targetContainmentEquivalentToGeneratorLine : Bool
  lineContractEquivalentToCartanContainmentContract : Bool
  lineContractEquivalentToTargetLine : Bool
  lineContractEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCompactDualToCartan : Bool
  provesCartanToCompactDual : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R679 status: the target-side item is the explicit
`j_q(h^4)` line containment, with no theorem-closing claim. -/
def currentR679ExactImageCartanLineContainmentSnapshot :
    R679ExactImageCartanLineContainmentSnapshot where
  proofWorkObligationCount :=
    currentR679ExactImageCartanLineContainmentTargetNames.length
  targetContainmentEquivalentToGeneratorLine := true
  lineContractEquivalentToCartanContainmentContract := true
  lineContractEquivalentToTargetLine := true
  lineContractEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCompactDualToCartan := false
  provesCartanToCompactDual := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R679 ledger. -/
theorem currentR679ExactImageCartanLineContainmentSnapshot_eq_texStatus :
    currentR679ExactImageCartanLineContainmentSnapshot =
      ({ proofWorkObligationCount := 4
         targetContainmentEquivalentToGeneratorLine := true
         lineContractEquivalentToCartanContainmentContract := true
         lineContractEquivalentToTargetLine := true
         lineContractEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCompactDualToCartan := false
         provesCartanToCompactDual := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R679ExactImageCartanLineContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R679 concrete target-line route. -/
theorem currentR679ExactImageCartanLineContainmentTargetNames_eq_texStatus :
    currentR679ExactImageCartanLineContainmentTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove compactDual <= CartanH8",
      "prove CartanH8 <= compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R679_substantiveTheoremCount : Nat := 6

end FrontC115_H8ResidualExactImageCartanLineContainmentEquivalence
end HCGapL4
end HodgeReduction
