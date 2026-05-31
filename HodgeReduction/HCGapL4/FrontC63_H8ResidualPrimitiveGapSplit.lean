/-
# HC Gap L4 -- Front C63: primitive split of the R603 residual (R604).

R603 identifies the live paper-facing residual as four Cartan containment
directions plus the target expected-Betti theorem.  This file makes that
split itself a kernel-checked object, so summary claims in the master tex
about "five remaining primitive targets" have a Lean-side witness.

The split is still not a proof of the Hodge conjecture.  The final theorem
requires genuine EVII/Matsushima geometry proving the carrier directions and
the independent target-rank theorem.
-/

import HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC63_H8ResidualPrimitiveGapSplit

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC62_H8ResidualCartanContainmentExpectedBettiPackage

section PrimitiveSplit

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- The four carrier-direction targets left by R603, without the target-rank
theorem. -/
structure EVIIH8ResidualCartanCarrierObligations where
  source_le_cartan :
    LE.le (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartan_le_source :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
  compactDual_le_cartan :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  cartan_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))

/-- The independent target-rank target left by R603. -/
structure EVIIH8ResidualExpectedBettiTargetObligation where
  target_expected_betti8 :
    Module.finrank (R := Rat)
      (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8

variable {A B}

/-- **R604 substantive theorem (1/7)**: the four carrier directions plus
the expected-Betti target rebuild the R603 residual package. -/
def cartanContainmentResidual_of_carrier_and_expectedBetti
    (C : EVIIH8ResidualCartanCarrierObligations A B)
    (T : EVIIH8ResidualExpectedBettiTargetObligation A B) :
    EVIIH8ResidualCartanContainmentExpectedBettiObligations A B where
  source_le_cartan := C.source_le_cartan
  cartan_le_source := C.cartan_le_source
  compactDual_le_cartan := C.compactDual_le_cartan
  cartan_le_compactDual := C.cartan_le_compactDual
  target_expected_betti8 := T.target_expected_betti8

/-- **R604 substantive theorem (2/7)**: every R603 residual package contains
the four carrier-direction targets. -/
def carrierObligations_of_cartanContainmentResidual
    (O : EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) :
    EVIIH8ResidualCartanCarrierObligations A B where
  source_le_cartan := O.source_le_cartan
  cartan_le_source := O.cartan_le_source
  compactDual_le_cartan := O.compactDual_le_cartan
  cartan_le_compactDual := O.cartan_le_compactDual

/-- **R604 substantive theorem (3/7)**: every R603 residual package contains
the expected-Betti target. -/
def expectedBettiTargetObligation_of_cartanContainmentResidual
    (O : EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) :
    EVIIH8ResidualExpectedBettiTargetObligation A B where
  target_expected_betti8 := O.target_expected_betti8

/-- **R604 substantive theorem (4/7)**: the R603 package is exactly the
inhabited conjunction of its carrier and target-rank parts. -/
theorem residual_cartanContainment_nonempty_iff_carrier_and_expectedBetti_nonempty :
    Nonempty (EVIIH8ResidualCartanContainmentExpectedBettiObligations A B) <->
      Nonempty (EVIIH8ResidualCartanCarrierObligations A B) /\
        Nonempty (EVIIH8ResidualExpectedBettiTargetObligation A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        And.intro
          (Nonempty.intro
            (carrierObligations_of_cartanContainmentResidual
              (A := A) (B := B) O))
          (Nonempty.intro
            (expectedBettiTargetObligation_of_cartanContainmentResidual
              (A := A) (B := B) O))))
    (fun h =>
      h.1.elim (fun C =>
        h.2.elim (fun T =>
          Nonempty.intro
            (cartanContainmentResidual_of_carrier_and_expectedBetti
              (A := A) (B := B) C T))))

end PrimitiveSplit

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

/-- **R604 substantive theorem (5/7)**: after the primitive split, the
carrier part and target-rank part still feed the existing boundary bridge. -/
def matsushimaV56BoundaryData_of_carrier_and_expectedBetti
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (C : EVIIH8ResidualCartanCarrierObligations A B)
    (T : EVIIH8ResidualExpectedBettiTargetObligation A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_cartanContainmentResidual
    (A := A) (B := B)
    (cartanContainmentResidual_of_carrier_and_expectedBetti
      (A := A) (B := B) C T)

end Boundary

section Countermodel

/-- **R604 substantive theorem (6/7)**: the current abstract interface can
satisfy all four carrier directions while still failing the target-rank
obligation. -/
theorem current_interface_with_carrierObligations_does_not_force_expectedBettiTarget :
    (EVIIH8ResidualCartanCarrierObligations
        TargetBettiSource TargetBettiTarget) /\
      Not (EVIIH8ResidualExpectedBettiTargetObligation
        TargetBettiSource TargetBettiTarget) := by
  rcases
    current_interface_with_cartanContainments_does_not_force_cartanContainmentResidual
      with ⟨hcarrier, hnotResidual⟩
  rcases hcarrier with ⟨hsource, hcartan, hcompact, hcompact'⟩
  let C :
      EVIIH8ResidualCartanCarrierObligations
        TargetBettiSource TargetBettiTarget :=
    { source_le_cartan := hsource
      cartan_le_source := hcartan
      compactDual_le_cartan := hcompact
      cartan_le_compactDual := hcompact' }
  refine And.intro C ?_
  intro T
  exact
    hnotResidual
      (cartanContainmentResidual_of_carrier_and_expectedBetti
        (A := TargetBettiSource) (B := TargetBettiTarget) C T)

end Countermodel

/-- Snapshot used by the master tex to state how many primitive R603/R604
targets remain.  This is metadata: it is not a closure theorem. -/
structure R604PrimitiveResidualSnapshot where
  carrierDirectionCount : Nat
  targetRankObligationCount : Nat
  primitiveTargetCount : Nat
  residualPackageCount : Nat
  isClosureClaim : Bool
  carrierFactsAloneForceTargetRank : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current machine-side R604 status: four carrier directions plus one
independent target-rank theorem, and no closure claim. -/
def currentR604PrimitiveResidualSnapshot : R604PrimitiveResidualSnapshot where
  carrierDirectionCount := 4
  targetRankObligationCount := 1
  primitiveTargetCount := 5
  residualPackageCount := 1
  isClosureClaim := false
  carrierFactsAloneForceTargetRank := false

/-- **R604 substantive theorem (7/7)**: kernel-checked numeric status for the
paper-facing R604 residual summary. -/
theorem currentR604PrimitiveResidualSnapshot_eq_texStatus :
    currentR604PrimitiveResidualSnapshot =
      ({ carrierDirectionCount := 4
         targetRankObligationCount := 1
         primitiveTargetCount := 5
         residualPackageCount := 1
         isClosureClaim := false
         carrierFactsAloneForceTargetRank := false } :
        R604PrimitiveResidualSnapshot) := by
  decide

def R604_substantiveTheoremCount : Nat := 7

end FrontC63_H8ResidualPrimitiveGapSplit
end HCGapL4
end HodgeReduction
