/-
# HC Gap L4 -- Front C137: Cartan image gives finite multiplicity (R702).

R646 already showed that containing `trivialModulePart` in the one-dimensional
Cartan H8 image gives the upper bound `finrank trivialModulePart <= 1`.
R700 made clear that the current multiplicity target also needs the finite
dimensional witness, not only the numerical upper bound.

This file closes that bookkeeping/math gap.  The same containment

  `trivialModulePart <= Submodule.map j_q trivialModuleGK_H8`

puts `trivialModulePart` inside a one-dimensional submodule, hence supplies
both finite-dimensionality and the upper bound.  Therefore the R646 Cartan
image criterion now feeds the R700/R701 finite multiplicity route directly.
-/

import HodgeReduction.HCGapL4.FrontC136_H8ResidualFiniteTrivialMultiplicityExplicitRoute
import HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC137_H8ResidualCartanImageFiniteMultiplicity

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC24_CartanImageTrivialRank
open FrontC82_H8ResidualAtlasMultiplicityCriterion
open FrontC126_H8ResidualExplicitFiniteMultiplicityRoute
open FrontC135_H8ResidualFiniteRankOneTrivialMultiplicity
open FrontC136_H8ResidualFiniteTrivialMultiplicityExplicitRoute

section CartanImageFiniteMultiplicity

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

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R702 substantive theorem (1/5)**: containment in the one-dimensional
Cartan H8 image supplies the missing finite-dimensional witness. -/
theorem trivialModulePart_finiteDimensional_of_le_cartanImage
    (hle :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  let cartanImage : Submodule Rat B :=
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  have hline : Module.finrank (R := Rat) cartanImage = 1 := by
    dsimp [cartanImage]
    exact map_cartan_trivialModuleGK_H8_finrank_eq_one (A := A) (B := B)
  haveI : FiniteDimensional Rat cartanImage :=
    Module.finite_of_finrank_eq_succ
      (R := Rat) (M := cartanImage) (n := 0) hline
  exact
    Submodule.finiteDimensional_of_le
      (show CuspidalCohomologyData.trivialModulePart (A := B) <=
          cartanImage from by
        simpa [cartanImage] using hle)

/-- **R702 substantive theorem (2/5)**: the R646 Cartan-image criterion
gives the complete R700 finite trivial-multiplicity contract. -/
def finiteTrivialMultiplicityContract_of_cartanImageUpperBoundContract
    (O : EVIIH8ResidualCartanImageUpperBoundContract A B) :
    EVIIH8ResidualFiniteTrivialMultiplicityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_finite :=
    trivialModulePart_finiteDimensional_of_le_cartanImage
      (A := A) (B := B) O.trivialModulePart_le_cartanImage
  trivialModulePart_finrank_le_one :=
    trivialModulePart_upper_bound_of_le_cartanImage
      (A := A) (B := B) O.trivialModulePart_le_cartanImage

/-- **R702 substantive theorem (3/5)**: the R646 Cartan-image criterion
feeds the R690 explicit finite route via R700/R701. -/
def explicitFiniteMultiplicityContract_of_cartanImageUpperBoundContract
    (O : EVIIH8ResidualCartanImageUpperBoundContract A B) :
    EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B :=
  explicitFiniteMultiplicityContract_of_finiteTrivialMultiplicityContract
    (A := A) (B := B)
    (finiteTrivialMultiplicityContract_of_cartanImageUpperBoundContract
      (A := A) (B := B) O)

/-- **R702 substantive theorem (4/5)**: inhabited R646 Cartan-image criteria
feed inhabited R700 finite multiplicity contracts. -/
theorem residual_cartanImageUpperBound_nonempty_to_finiteTrivialMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualCartanImageUpperBoundContract A B) ->
      Nonempty (EVIIH8ResidualFiniteTrivialMultiplicityContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (finiteTrivialMultiplicityContract_of_cartanImageUpperBoundContract
      (A := A) (B := B) O)

/-- **R702 substantive theorem (5/5)**: inhabited R646 Cartan-image criteria
also feed the R690 explicit finite route. -/
theorem residual_cartanImageUpperBound_nonempty_to_explicitFiniteMultiplicity_nonempty :
    Nonempty (EVIIH8ResidualCartanImageUpperBoundContract A B) ->
      Nonempty (EVIIH8ResidualSourceBoundaryExplicitFiniteMultiplicityContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (explicitFiniteMultiplicityContract_of_cartanImageUpperBoundContract
      (A := A) (B := B) O)

end CartanImageFiniteMultiplicity

/-- R702 target names for route summaries. -/
def currentR702CartanImageFiniteMultiplicityTargetNames : List String := [
  "prove sourceInvariantExactImageTarget",
  "prove source_invariants = H8",
  "prove trivialModulePart <= Submodule.map j_q trivialModuleGK_H8"
]

/-- Machine-readable status for the R702 Cartan-image finite multiplicity route. -/
structure R702CartanImageFiniteMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  cartanImageContainmentSuppliesFiniteDimensionalWitness : Bool
  cartanImageContainmentSuppliesUpperBound : Bool
  cartanImageContractFeedsR700 : Bool
  cartanImageContractFeedsR690 : Bool
  provesCartanImageContainment : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesBoundaryData : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R702 status: the finite-dimensional witness is no longer a
separate silent requirement once the Cartan-image containment is chosen as
the multiplicity route. -/
def currentR702CartanImageFiniteMultiplicitySnapshot :
    R702CartanImageFiniteMultiplicitySnapshot where
  proofWorkObligationCount :=
    currentR702CartanImageFiniteMultiplicityTargetNames.length
  cartanImageContainmentSuppliesFiniteDimensionalWitness := true
  cartanImageContainmentSuppliesUpperBound := true
  cartanImageContractFeedsR700 := true
  cartanImageContractFeedsR690 := true
  provesCartanImageContainment := false
  provesFiniteTrivialMultiplicity := false
  provesBoundaryData := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R702 route. -/
theorem currentR702CartanImageFiniteMultiplicitySnapshot_eq_texStatus :
    currentR702CartanImageFiniteMultiplicitySnapshot =
      ({ proofWorkObligationCount := 3
         cartanImageContainmentSuppliesFiniteDimensionalWitness := true
         cartanImageContainmentSuppliesUpperBound := true
         cartanImageContractFeedsR700 := true
         cartanImageContractFeedsR690 := true
         provesCartanImageContainment := false
         provesFiniteTrivialMultiplicity := false
         provesBoundaryData := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R702CartanImageFiniteMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R702 route. -/
theorem currentR702CartanImageFiniteMultiplicityTargetNames_eq_texStatus :
    currentR702CartanImageFiniteMultiplicityTargetNames = [
      "prove sourceInvariantExactImageTarget",
      "prove source_invariants = H8",
      "prove trivialModulePart <= Submodule.map j_q trivialModuleGK_H8"
    ] := by
  rfl

def R702_substantiveTheoremCount : Nat := 5

end FrontC137_H8ResidualCartanImageFiniteMultiplicity
end HCGapL4
end HodgeReduction
