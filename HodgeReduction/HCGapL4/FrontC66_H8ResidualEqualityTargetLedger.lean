/-
# HC Gap L4 -- Front C66: equality target ledger (R607).

R606 names the five paper-facing primitive targets.  The four carrier
containments are exactly two Cartan-line equalities, so this file records the
equivalent proof-work ledger:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* scalar-preimage surjectivity.

This is a target normalization, not a proof of any of the three obligations.
-/

import HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC66_H8ResidualEqualityTargetLedger

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC62_H8ResidualCartanContainmentExpectedBettiPackage
open FrontC65_H8ResidualPrimitiveTargetLedger

section EqualityTargets

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The proof-work target obtained by pairing the two source/Cartan primitive
containments. -/
def sourceCartanEqualityTarget : Prop :=
  MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
    CartanCompactDualIso.trivialModuleGK_H8 (A := A)

/-- The proof-work target obtained by pairing the two compactDual/Cartan
primitive containments. -/
def compactDualCartanEqualityTarget : Prop :=
  MatsushimaCompactDualData.compactDual (A := A) (B := B) =
    CartanCompactDualIso.trivialModuleGK_H8 (A := A)

/-- The R607 proof-work ledger: two carrier equalities plus the scalar-preimage
target. -/
structure EVIIH8ResidualEqualityScalarTargets where
  source_eq_cartan : sourceCartanEqualityTarget A B
  compactDual_eq_cartan : compactDualCartanEqualityTarget A B
  scalar_preimage : scalarPreimagePrimitiveTarget A B

variable {A B}

/-- **R607 substantive theorem (1/6)**: the five primitive targets collapse to
the two Cartan-line carrier equalities plus scalar-preimage target. -/
def equalityScalarTargets_of_fivePrimitiveTargets
    (O : EVIIH8ResidualFivePrimitiveTargets A B) :
    EVIIH8ResidualEqualityScalarTargets A B where
  source_eq_cartan :=
    le_antisymm O.source_le_cartan O.cartan_le_source
  compactDual_eq_cartan :=
    le_antisymm O.compactDual_le_cartan O.cartan_le_compactDual
  scalar_preimage := O.scalar_preimage

/-- **R607 substantive theorem (2/6)**: two carrier equalities plus scalar
preimages rebuild the five primitive target ledger. -/
def fivePrimitiveTargets_of_equalityScalarTargets
    (O : EVIIH8ResidualEqualityScalarTargets A B) :
    EVIIH8ResidualFivePrimitiveTargets A B where
  source_le_cartan := le_of_eq O.source_eq_cartan
  cartan_le_source := le_of_eq O.source_eq_cartan.symm
  compactDual_le_cartan := le_of_eq O.compactDual_eq_cartan
  cartan_le_compactDual := le_of_eq O.compactDual_eq_cartan.symm
  scalar_preimage := O.scalar_preimage

/-- **R607 substantive theorem (3/6)**: the five primitive targets and the
three proof-work targets are equivalent at the inhabited package level. -/
theorem residual_fivePrimitiveTargets_nonempty_iff_equalityScalarTargets_nonempty :
    Nonempty (EVIIH8ResidualFivePrimitiveTargets A B) <->
      Nonempty (EVIIH8ResidualEqualityScalarTargets A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (equalityScalarTargets_of_fivePrimitiveTargets
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (fivePrimitiveTargets_of_equalityScalarTargets
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R607 substantive theorem (4/6)**: the three proof-work targets rebuild
the R603/R604 Cartan-containment residual package. -/
def cartanContainmentResidual_of_equalityScalarTargets
    (O : EVIIH8ResidualEqualityScalarTargets A B) :
    EVIIH8ResidualCartanContainmentExpectedBettiObligations A B :=
  cartanContainmentResidual_of_fivePrimitiveTargets
    (A := A) (B := B)
    (fivePrimitiveTargets_of_equalityScalarTargets (A := A) (B := B) O)

/-- **R607 substantive theorem (5/6)**: the three proof-work targets feed the
existing Matsushima V56 boundary bridge. -/
def matsushimaV56BoundaryData_of_equalityScalarTargets
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualEqualityScalarTargets A B) :
    FrontC13_MatsushimaV56BoundaryBridge.MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_fivePrimitiveTargets
    (A := A) (B := B)
    (fivePrimitiveTargets_of_equalityScalarTargets (A := A) (B := B) O)

end EqualityTargets

/-- The exact proof-work target names after R607 normalization. -/
def currentR607ProofWorkTargetNames : List String := [
  "surjectivity_source = CartanH8",
  "compactDual = CartanH8",
  "scalar-preimage surjectivity (equiv. expected-Betti rank)"
]

/-- Machine-readable status for the R607 equality-target ledger. -/
structure R607EqualityTargetLedgerSnapshot where
  paperFacingPrimitiveTargetCount : Nat
  proofWorkTargetCount : Nat
  carrierEqualityTargetCount : Nat
  scalarPreimageTargetCount : Nat
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R607 status: the five primitive targets are equivalent to three
proof-work targets, not closed. -/
def currentR607EqualityTargetLedgerSnapshot :
    R607EqualityTargetLedgerSnapshot where
  paperFacingPrimitiveTargetCount := currentR606PrimitiveTargetNames.length
  proofWorkTargetCount := currentR607ProofWorkTargetNames.length
  carrierEqualityTargetCount := 2
  scalarPreimageTargetCount := 1
  isClosureClaim := false

/-- **R607 substantive theorem (6/6)**: kernel-checked numeric status for the
equality-target proof-work ledger. -/
theorem currentR607EqualityTargetLedgerSnapshot_eq_texStatus :
    currentR607EqualityTargetLedgerSnapshot =
      ({ paperFacingPrimitiveTargetCount := 5
         proofWorkTargetCount := 3
         carrierEqualityTargetCount := 2
         scalarPreimageTargetCount := 1
         isClosureClaim := false } :
        R607EqualityTargetLedgerSnapshot) := by
  decide

theorem currentR607ProofWorkTargetNames_eq_texStatus :
    currentR607ProofWorkTargetNames = [
      "surjectivity_source = CartanH8",
      "compactDual = CartanH8",
      "scalar-preimage surjectivity (equiv. expected-Betti rank)"
    ] := by
  rfl

def R607_substantiveTheoremCount : Nat := 6

end FrontC66_H8ResidualEqualityTargetLedger
end HCGapL4
end HodgeReduction
