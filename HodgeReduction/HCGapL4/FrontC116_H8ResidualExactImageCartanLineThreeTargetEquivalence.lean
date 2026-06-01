/-
# HC Gap L4 -- Front C116: three-target Cartan line route (R680).

R679 leaves four explicit targets:

* exact image;
* `compactDual <= CartanH8`;
* `CartanH8 <= compactDual`;
* `trivialModulePart <= span {j_q(h^4)}`.

The older R661 bridge already proves that the last two source/target facts
recover `source_invariants = H8`.  Via the compact-dual/source-invariants
comparison, this also recovers `compactDual = H8`, hence the missing
direction `compactDual <= CartanH8`.

So the current route can be stated with three targets, not four:
exact image, Cartan-to-compactDual, and target generator-line containment.
-/

import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine
import HodgeReduction.HCGapL4.FrontC115_H8ResidualExactImageCartanLineContainmentEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC97_H8ResidualCartanToCompactDualLine
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence
open FrontC114_H8ResidualExactImageCartanContainmentEquivalence
open FrontC115_H8ResidualExactImageCartanLineContainmentEquivalence

section CompactDualToCartanFromLine

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

omit [MatsushimaSurjectivityData A B] in
/-- **R680 substantive theorem (1/6)**: Cartan-to-compactDual containment
plus the target generator-line theorem already forces the reverse
compactDual-to-Cartan containment. -/
theorem compactDual_le_cartanH8_of_cartanH8_le_compactDual_and_targetLine
    (hcartan_le_compact :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hline :
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
  have hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    source_invariants_eq_H8_of_cartanH8_le_compactDual_and_line
      (A := A) (B := B) hcartan_le_compact hline
  have hcompact_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A) :=
    (source_invariants_eq_H8_iff_compactDual_eq_H8
      (A := A) (B := B)).1 hsource_H8
  exact
    (compactDual_eq_H8_iff_cartan_containments
      (A := A) (B := B)).1 hcompact_H8 |>.1

end CompactDualToCartanFromLine

section ExactImageCartanLineThreeTarget

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

/-- The R680 three-target spelling of the R679 exact-image Cartan line route. -/
structure EVIIH8ResidualExactImageCartanLineThreeTargetContract where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
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

/-- **R680 substantive theorem (2/6)**: R679 contracts drop the now-redundant
compactDual-to-Cartan direction. -/
def exactImageCartanLineThreeTargetContract_of_exactImageCartanLineContainmentContract
    (O : EVIIH8ResidualExactImageCartanLineContainmentContract A B) :
    EVIIH8ResidualExactImageCartanLineThreeTargetContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R680 substantive theorem (3/6)**: the three-target route rebuilds the
R679 four-target route by deriving `compactDual <= CartanH8`. -/
def exactImageCartanLineContainmentContract_of_exactImageCartanLineThreeTargetContract
    (O : EVIIH8ResidualExactImageCartanLineThreeTargetContract A B) :
    EVIIH8ResidualExactImageCartanLineContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  compactDual_le_cartanH8 :=
    compactDual_le_cartanH8_of_cartanH8_le_compactDual_and_targetLine
      (A := A) (B := B)
      O.cartanH8_le_compactDual
      O.trivialModulePart_le_h_pow_four_line
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R680 substantive theorem (4/6)**: the R679 four-target line route and
the R680 three-target line route are equivalent at the inhabited-contract
level. -/
theorem residual_exactImageCartanLineContainment_nonempty_iff_exactImageCartanLineThreeTarget_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanLineContainmentContract A B) <->
      Nonempty (EVIIH8ResidualExactImageCartanLineThreeTargetContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCartanLineThreeTargetContract_of_exactImageCartanLineContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCartanLineContainmentContract_of_exactImageCartanLineThreeTargetContract
            (A := A) (B := B) O)))

/-- **R680 substantive theorem (5/6)**: the three-target line route is still
the current target-line residual. -/
theorem residual_exactImageCartanLineThreeTarget_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanLineThreeTargetContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_exactImageCartanLineContainment_nonempty_iff_exactImageCartanLineThreeTarget_nonempty
    (A := A) (B := B)).symm.trans
    (residual_exactImageCartanLineContainment_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R680 substantive theorem (6/6)**: the three-target line route is also
equivalent to the R675 boundary-data/compact-dual spelling. -/
theorem residual_exactImageCartanLineThreeTarget_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanLineThreeTargetContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_exactImageCartanLineThreeTarget_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end ExactImageCartanLineThreeTarget

/-- Exact R680 target names for route summaries. -/
def currentR680ExactImageCartanLineThreeTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove CartanH8 <= compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R680 three-target route. -/
structure R680ExactImageCartanLineThreeTargetSnapshot where
  proofWorkObligationCount : Nat
  compactDualToCartanDerivedFromLineRoute : Bool
  threeTargetContractEquivalentToFourTargetLineContract : Bool
  threeTargetContractEquivalentToTargetLine : Bool
  threeTargetContractEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCartanToCompactDual : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R680 status: the exact-image Cartan line route has three live
targets; the compactDual-to-Cartan direction is derived, not assumed. -/
def currentR680ExactImageCartanLineThreeTargetSnapshot :
    R680ExactImageCartanLineThreeTargetSnapshot where
  proofWorkObligationCount :=
    currentR680ExactImageCartanLineThreeTargetNames.length
  compactDualToCartanDerivedFromLineRoute := true
  threeTargetContractEquivalentToFourTargetLineContract := true
  threeTargetContractEquivalentToTargetLine := true
  threeTargetContractEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCartanToCompactDual := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R680 ledger. -/
theorem currentR680ExactImageCartanLineThreeTargetSnapshot_eq_texStatus :
    currentR680ExactImageCartanLineThreeTargetSnapshot =
      ({ proofWorkObligationCount := 3
         compactDualToCartanDerivedFromLineRoute := true
         threeTargetContractEquivalentToFourTargetLineContract := true
         threeTargetContractEquivalentToTargetLine := true
         threeTargetContractEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCartanToCompactDual := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R680ExactImageCartanLineThreeTargetSnapshot) := by
  decide

/-- Kernel-checked target names for the R680 three-target route. -/
theorem currentR680ExactImageCartanLineThreeTargetNames_eq_texStatus :
    currentR680ExactImageCartanLineThreeTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove CartanH8 <= compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R680_substantiveTheoremCount : Nat := 6

end FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence
end HCGapL4
end HodgeReduction
