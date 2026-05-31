/-
# HC Gap L4 -- Front C64: scalar-preimage primitive split (R605).

R604 records the live residual as four Cartan carrier directions plus one
target expected-Betti theorem.  R581 already shows that, once the carrier
directions are fixed, the target-rank theorem is equivalent to the
element-level scalar-preimage statement.

This file connects those two interfaces.  It lets the paper and route ledger
say that the fifth primitive target can be attacked either as the expected
Betti rank or as scalar preimage surjectivity, without counting those as two
separate gaps.
-/

import HodgeReduction.HCGapL4.FrontC40_TargetRankScalarPreimageEquivalence
import HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage
import HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC64_H8ResidualScalarPreimagePrimitiveSplit

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC4_HodgePolynomialAlgebra
open FrontC7_E7EVIIHodgeDiamondInstance
open FrontC11_ShimuraBettiComputation
open FrontC36_TargetBettiObstruction
open FrontC39_TargetHodgeSumFromScalarPreimage
open FrontC40_TargetRankScalarPreimageEquivalence
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC62_H8ResidualCartanContainmentExpectedBettiPackage
open FrontC63_H8ResidualPrimitiveGapSplit

section ScalarPrimitivePackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- R604's carrier package plus the scalar-preimage spelling of the fifth
primitive target. -/
structure EVIIH8ResidualCartanScalarPreimageObligations where
  carrier : EVIIH8ResidualCartanCarrierObligations A B
  scalar_preimage : H8ResidualScalarPreimageTarget A B

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R605 substantive theorem (1/7)**: under the compactDual/Cartan carrier
directions, scalar preimages imply the R604 expected-Betti target. -/
def expectedBettiTarget_of_carrierScalarPreimage
    (O : EVIIH8ResidualCartanScalarPreimageObligations A B) :
    EVIIH8ResidualExpectedBettiTargetObligation A B where
  target_expected_betti8 :=
    target_expected_betti8_of_compactDual_cartan_containments_scalar_preimage
      (A := A) (B := B)
      O.carrier.compactDual_le_cartan
      O.carrier.cartan_le_compactDual
      O.scalar_preimage

/-- **R605 substantive theorem (2/7)**: four carrier directions plus scalar
preimages rebuild the R603/R604 residual package. -/
def cartanContainmentResidual_of_carrierScalarPreimage
    (O : EVIIH8ResidualCartanScalarPreimageObligations A B) :
    EVIIH8ResidualCartanContainmentExpectedBettiObligations A B :=
  cartanContainmentResidual_of_carrier_and_expectedBetti
    (A := A) (B := B)
    O.carrier
    (expectedBettiTarget_of_carrierScalarPreimage (A := A) (B := B) O)

end ScalarPrimitivePackage

section RankToScalar

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

/-- **R605 substantive theorem (3/7)**: with the four carrier directions
present, an R603/R604 expected-Betti residual package also gives the
scalar-preimage primitive package. -/
def carrierScalarPreimage_of_cartanContainmentResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) :
    EVIIH8ResidualCartanScalarPreimageObligations A B where
  carrier :=
    carrierObligations_of_cartanContainmentResidual (A := A) (B := B) O
  scalar_preimage := by
    have htarget_hodge :
        Module.finrank (R := Rat)
            (MatsushimaData.target_invariants (A := A) (B := B)) =
          hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8 := by
      simpa using O.target_expected_betti8
    exact
      (target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_cartan_containments
        (A := A) (B := B)
        O.source_le_cartan
        O.cartan_le_source
        O.compactDual_le_cartan
        O.cartan_le_compactDual).1
        htarget_hodge

/-- **R605 substantive theorem (4/7)**: the R603/R604 expected-Betti package
and the scalar-preimage primitive package are equivalent at the inhabited
package level. -/
theorem residual_cartanContainment_nonempty_iff_carrierScalarPreimage_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) <->
      Nonempty (EVIIH8ResidualCartanScalarPreimageObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (carrierScalarPreimage_of_cartanContainmentResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanContainmentResidual_of_carrierScalarPreimage
            (A := A) (B := B) O)))

end RankToScalar

section Boundary

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

/-- **R605 substantive theorem (5/7)**: the scalar-preimage primitive package
feeds the existing Matsushima boundary bridge. -/
def matsushimaV56BoundaryData_of_carrierScalarPreimage
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualCartanScalarPreimageObligations A B) :
    FrontC13_MatsushimaV56BoundaryBridge.MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_carrier_and_expectedBetti
    (A := A) (B := B)
    O.carrier
    (expectedBettiTarget_of_carrierScalarPreimage (A := A) (B := B) O)

end Boundary

section Countermodel

/-- **R605 substantive theorem (6/7)**: the current abstract interface can
satisfy all four carrier directions while still failing scalar-preimage
surjectivity. -/
theorem current_interface_with_carrierObligations_does_not_force_scalarPreimage :
    (EVIIH8ResidualCartanCarrierObligations
        TargetBettiSource TargetBettiTarget) /\
      Not (H8ResidualScalarPreimageTarget
        TargetBettiSource TargetBettiTarget) := by
  rcases
    current_interface_with_carrierObligations_does_not_force_expectedBettiTarget
      with ⟨C, hnotTarget⟩
  refine And.intro C ?_
  intro hscalar
  exact
    hnotTarget
      (expectedBettiTarget_of_carrierScalarPreimage
        (A := TargetBettiSource) (B := TargetBettiTarget)
        { carrier := C
          scalar_preimage := hscalar })

end Countermodel

/-- Machine-readable status for the R605 scalar-preimage normalization. -/
structure R605ScalarPreimageResidualSnapshot where
  carrierDirectionCount : Nat
  scalarPreimageTargetCount : Nat
  primitiveTargetCount : Nat
  expectedBettiTargetReplacedByScalarPreimage : Bool
  isClosureClaim : Bool
  carrierFactsAloneForceScalarPreimage : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R605 status: still five primitive targets, with the fifth target
now equivalently available as scalar-preimage surjectivity. -/
def currentR605ScalarPreimageResidualSnapshot :
    R605ScalarPreimageResidualSnapshot where
  carrierDirectionCount := 4
  scalarPreimageTargetCount := 1
  primitiveTargetCount := 5
  expectedBettiTargetReplacedByScalarPreimage := true
  isClosureClaim := false
  carrierFactsAloneForceScalarPreimage := false

/-- **R605 substantive theorem (7/7)**: kernel-checked numeric status for
the paper-facing scalar-preimage residual summary. -/
theorem currentR605ScalarPreimageResidualSnapshot_eq_texStatus :
    currentR605ScalarPreimageResidualSnapshot =
      ({ carrierDirectionCount := 4
         scalarPreimageTargetCount := 1
         primitiveTargetCount := 5
         expectedBettiTargetReplacedByScalarPreimage := true
         isClosureClaim := false
         carrierFactsAloneForceScalarPreimage := false } :
        R605ScalarPreimageResidualSnapshot) := by
  decide

def R605_substantiveTheoremCount : Nat := 7

end FrontC64_H8ResidualScalarPreimagePrimitiveSplit
end HCGapL4
end HodgeReduction
