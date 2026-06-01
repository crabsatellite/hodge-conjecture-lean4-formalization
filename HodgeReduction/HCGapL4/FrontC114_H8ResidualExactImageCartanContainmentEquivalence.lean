/-
# HC Gap L4 -- Front C114: exact-image route with Cartan containments (R678).

R677 names the live source-side carrier target as `compactDual = H8`.
R575/R582 already expose the same geometric content through Cartan's H8
line.  This file makes that connection exact for the current preferred
route:

* exact image;
* `compactDual <= CartanH8`;
* `CartanH8 <= compactDual`;
* `trivialModulePart <= surjectivity_target`.

The new package is equivalent to R677.  It is not a closure claim and does
not prove any of the four obligations.
-/

import HodgeReduction.HCGapL4.FrontC34_CartanContainmentsForCompactDual
import HodgeReduction.HCGapL4.FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC114_H8ResidualExactImageCartanContainmentEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence

section CompactDualCartanCarrier

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R678 substantive theorem (1/6)**: `compactDual = H8` is exactly the
two Cartan/compactDual containment directions. -/
theorem compactDual_eq_H8_iff_cartan_containments :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      (LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) /\
        LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))) := by
  constructor
  · intro hcompact
    constructor
    · rw [hcompact]
      rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
    · rw [hcompact]
      rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  · intro hcartan
    exact le_antisymm
      (by
        rw [<- CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
        exact hcartan.1)
      (by
        rw [<- CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
        exact hcartan.2)

end CompactDualCartanCarrier

section ExactImageCartanContainment

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

/-- The R678 Cartan-containment spelling of the R677 exact-image route. -/
structure EVIIH8ResidualExactImageCartanContainmentContract where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  compactDual_le_cartanH8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  trivialModulePart_le_surjectivity_target :
    LE.le
      (CuspidalCohomologyData.trivialModulePart (A := B))
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))

variable {A B}

/-- **R678 substantive theorem (2/6)**: R677 compact-dual contracts produce
the two-direction Cartan-containment spelling. -/
def exactImageCartanContainmentContract_of_exactImageCompactDualContainmentContract
    (O : EVIIH8ResidualExactImageContainmentCompactDualContract A B) :
    EVIIH8ResidualExactImageCartanContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  compactDual_le_cartanH8 :=
    (compactDual_eq_H8_iff_cartan_containments
      (A := A) (B := B)).1 O.compactDual_eq_H8 |>.1
  cartanH8_le_compactDual :=
    (compactDual_eq_H8_iff_cartan_containments
      (A := A) (B := B)).1 O.compactDual_eq_H8 |>.2
  trivialModulePart_le_surjectivity_target :=
    O.trivialModulePart_le_surjectivity_target

/-- **R678 substantive theorem (3/6)**: the Cartan-containment spelling
rebuilds the R677 compact-dual contract. -/
def exactImageCompactDualContainmentContract_of_exactImageCartanContainmentContract
    (O : EVIIH8ResidualExactImageCartanContainmentContract A B) :
    EVIIH8ResidualExactImageContainmentCompactDualContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  compactDual_eq_H8 :=
    (compactDual_eq_H8_iff_cartan_containments
      (A := A) (B := B)).2
      ⟨O.compactDual_le_cartanH8, O.cartanH8_le_compactDual⟩
  trivialModulePart_le_surjectivity_target :=
    O.trivialModulePart_le_surjectivity_target

omit [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R678 substantive theorem (4/6)**: the R677 compact-dual route and the
R678 two-direction Cartan route are equivalent at the inhabited-contract
level. -/
theorem residual_exactImageCompactDualContainment_nonempty_iff_exactImageCartanContainment_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentCompactDualContract A B) <->
      Nonempty (EVIIH8ResidualExactImageCartanContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCartanContainmentContract_of_exactImageCompactDualContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCompactDualContainmentContract_of_exactImageCartanContainmentContract
            (A := A) (B := B) O)))

/-- **R678 substantive theorem (5/6)**: the Cartan-containment exact-image
route is still the current target-line residual. -/
theorem residual_exactImageCartanContainment_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanContainmentContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_exactImageCompactDualContainment_nonempty_iff_exactImageCartanContainment_nonempty
    (A := A) (B := B)).symm.trans
    (residual_exactImageContainmentCompactDual_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R678 substantive theorem (6/6)**: the Cartan-containment exact-image
route is also equivalent to the R675 boundary-data/compact-dual spelling. -/
theorem residual_exactImageCartanContainment_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanContainmentContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_exactImageCartanContainment_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end ExactImageCartanContainment

/-- Exact R678 target names for route summaries. -/
def currentR678ExactImageCartanContainmentTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove compactDual <= CartanH8",
  "prove CartanH8 <= compactDual",
  "prove trivialModulePart <= surjectivity_target"
]

/-- Machine-readable status for the R678 Cartan-containment route. -/
structure R678ExactImageCartanContainmentSnapshot where
  proofWorkObligationCount : Nat
  cartanContainmentsEquivalentToCompactDualH8 : Bool
  cartanContractEquivalentToCompactDualContract : Bool
  cartanContractEquivalentToTargetLine : Bool
  cartanContractEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCompactDualToCartan : Bool
  provesCartanToCompactDual : Bool
  provesTargetContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R678 status: the source carrier is split into two explicit
Cartan containment directions, with no theorem-closing claim. -/
def currentR678ExactImageCartanContainmentSnapshot :
    R678ExactImageCartanContainmentSnapshot where
  proofWorkObligationCount :=
    currentR678ExactImageCartanContainmentTargetNames.length
  cartanContainmentsEquivalentToCompactDualH8 := true
  cartanContractEquivalentToCompactDualContract := true
  cartanContractEquivalentToTargetLine := true
  cartanContractEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCompactDualToCartan := false
  provesCartanToCompactDual := false
  provesTargetContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R678 ledger. -/
theorem currentR678ExactImageCartanContainmentSnapshot_eq_texStatus :
    currentR678ExactImageCartanContainmentSnapshot =
      ({ proofWorkObligationCount := 4
         cartanContainmentsEquivalentToCompactDualH8 := true
         cartanContractEquivalentToCompactDualContract := true
         cartanContractEquivalentToTargetLine := true
         cartanContractEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCompactDualToCartan := false
         provesCartanToCompactDual := false
         provesTargetContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R678ExactImageCartanContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R678 Cartan-containment route. -/
theorem currentR678ExactImageCartanContainmentTargetNames_eq_texStatus :
    currentR678ExactImageCartanContainmentTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove compactDual <= CartanH8",
      "prove CartanH8 <= compactDual",
      "prove trivialModulePart <= surjectivity_target"
    ] := by
  rfl

def R678_substantiveTheoremCount : Nat := 6

end FrontC114_H8ResidualExactImageCartanContainmentEquivalence
end HCGapL4
end HodgeReduction
