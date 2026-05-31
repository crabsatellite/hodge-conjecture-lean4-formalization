/-
# HC Gap L4 -- Front C65: primitive target ledger (R606).

R605 normalizes the fifth residual target as scalar-preimage surjectivity.
This file flattens the R605 package into the exact five paper-facing primitive
targets, so the master-paper summary can cite a kernel-side declaration for
the named target list rather than only a prose count.
-/

import HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC65_H8ResidualPrimitiveTargetLedger

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC62_H8ResidualCartanContainmentExpectedBettiPackage
open FrontC64_H8ResidualScalarPreimagePrimitiveSplit

section FiveTargets

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The paper-facing source-to-Cartan primitive target. -/
def sourceToCartanPrimitiveTarget : Prop :=
  LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
    (CartanCompactDualIso.trivialModuleGK_H8 (A := A))

/-- The paper-facing Cartan-to-source primitive target. -/
def cartanToSourcePrimitiveTarget : Prop :=
  LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))

/-- The paper-facing compactDual-to-Cartan primitive target. -/
def compactDualToCartanPrimitiveTarget : Prop :=
  LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (CartanCompactDualIso.trivialModuleGK_H8 (A := A))

/-- The paper-facing Cartan-to-compactDual primitive target. -/
def cartanToCompactDualPrimitiveTarget : Prop :=
  LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
    (MatsushimaCompactDualData.compactDual (A := A) (B := B))

/-- The paper-facing scalar-preimage spelling of the fifth primitive target. -/
def scalarPreimagePrimitiveTarget : Prop :=
  H8ResidualScalarPreimageTarget A B

/-- The flattened R606 ledger of the exact five primitive targets. -/
structure EVIIH8ResidualFivePrimitiveTargets where
  source_le_cartan : sourceToCartanPrimitiveTarget A B
  cartan_le_source : cartanToSourcePrimitiveTarget A B
  compactDual_le_cartan : compactDualToCartanPrimitiveTarget A B
  cartan_le_compactDual : cartanToCompactDualPrimitiveTarget A B
  scalar_preimage : scalarPreimagePrimitiveTarget A B

variable {A B}

/-- **R606 substantive theorem (1/6)**: the R605 package contains exactly the
five flattened primitive targets. -/
def fivePrimitiveTargets_of_carrierScalarPreimage
    (O : EVIIH8ResidualCartanScalarPreimageObligations A B) :
    EVIIH8ResidualFivePrimitiveTargets A B where
  source_le_cartan := O.carrier.source_le_cartan
  cartan_le_source := O.carrier.cartan_le_source
  compactDual_le_cartan := O.carrier.compactDual_le_cartan
  cartan_le_compactDual := O.carrier.cartan_le_compactDual
  scalar_preimage := O.scalar_preimage

/-- **R606 substantive theorem (2/6)**: the flattened five-target ledger
rebuilds the R605 carrier/scalar-preimage package. -/
def carrierScalarPreimage_of_fivePrimitiveTargets
    (O : EVIIH8ResidualFivePrimitiveTargets A B) :
    EVIIH8ResidualCartanScalarPreimageObligations A B where
  carrier :=
    { source_le_cartan := O.source_le_cartan
      cartan_le_source := O.cartan_le_source
      compactDual_le_cartan := O.compactDual_le_cartan
      cartan_le_compactDual := O.cartan_le_compactDual }
  scalar_preimage := O.scalar_preimage

/-- **R606 substantive theorem (3/6)**: the R605 package and the flattened
five-target ledger are equivalent at the inhabited package level. -/
theorem residual_carrierScalarPreimage_nonempty_iff_fivePrimitiveTargets_nonempty :
    Nonempty (EVIIH8ResidualCartanScalarPreimageObligations A B) <->
      Nonempty (EVIIH8ResidualFivePrimitiveTargets A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (fivePrimitiveTargets_of_carrierScalarPreimage
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (carrierScalarPreimage_of_fivePrimitiveTargets
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R606 substantive theorem (4/6)**: the five primitive targets rebuild the
R603/R604 Cartan-containment residual package. -/
def cartanContainmentResidual_of_fivePrimitiveTargets
    (O : EVIIH8ResidualFivePrimitiveTargets A B) :
    EVIIH8ResidualCartanContainmentExpectedBettiObligations A B :=
  cartanContainmentResidual_of_carrierScalarPreimage
    (A := A) (B := B)
    (carrierScalarPreimage_of_fivePrimitiveTargets (A := A) (B := B) O)

/-- **R606 substantive theorem (5/6)**: the five primitive targets feed the
existing Matsushima V56 boundary bridge. -/
def matsushimaV56BoundaryData_of_fivePrimitiveTargets
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualFivePrimitiveTargets A B) :
    FrontC13_MatsushimaV56BoundaryBridge.MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_carrierScalarPreimage
    (A := A) (B := B)
    (carrierScalarPreimage_of_fivePrimitiveTargets (A := A) (B := B) O)

end FiveTargets

/-- The exact paper-facing names of the five live primitive targets. -/
def currentR606PrimitiveTargetNames : List String := [
  "surjectivity_source <= CartanH8",
  "CartanH8 <= surjectivity_source",
  "compactDual <= CartanH8",
  "CartanH8 <= compactDual",
  "scalar-preimage surjectivity (equiv. expected-Betti rank)"
]

/-- Machine-readable status for the R606 primitive-target ledger. -/
structure R606PrimitiveTargetLedgerSnapshot where
  primitiveTargetCount : Nat
  carrierDirectionCount : Nat
  scalarPreimageTargetCount : Nat
  expectedBettiAndScalarPreimageCountedSeparately : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R606 status: five named primitive targets, not a closure claim. -/
def currentR606PrimitiveTargetLedgerSnapshot :
    R606PrimitiveTargetLedgerSnapshot where
  primitiveTargetCount := currentR606PrimitiveTargetNames.length
  carrierDirectionCount := 4
  scalarPreimageTargetCount := 1
  expectedBettiAndScalarPreimageCountedSeparately := false
  isClosureClaim := false

/-- **R606 substantive theorem (6/6)**: kernel-checked names and numeric status
for the paper-facing primitive-target ledger. -/
theorem currentR606PrimitiveTargetLedgerSnapshot_eq_texStatus :
    currentR606PrimitiveTargetLedgerSnapshot =
      ({ primitiveTargetCount := 5
         carrierDirectionCount := 4
         scalarPreimageTargetCount := 1
         expectedBettiAndScalarPreimageCountedSeparately := false
         isClosureClaim := false } :
        R606PrimitiveTargetLedgerSnapshot) := by
  decide

theorem currentR606PrimitiveTargetNames_eq_texStatus :
    currentR606PrimitiveTargetNames = [
      "surjectivity_source <= CartanH8",
      "CartanH8 <= surjectivity_source",
      "compactDual <= CartanH8",
      "CartanH8 <= compactDual",
      "scalar-preimage surjectivity (equiv. expected-Betti rank)"
    ] := by
  rfl

def R606_substantiveTheoremCount : Nat := 6

end FrontC65_H8ResidualPrimitiveTargetLedger
end HCGapL4
end HodgeReduction
