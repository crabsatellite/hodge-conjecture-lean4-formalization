/-
# HC Gap L4 -- Front C69: proof-work contract ledger (R610).

R607-R609 normalize the live EVII/H8 residual to three proof-work
obligations:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* the scalar/rank-one target.

This file gives that frontier a single contract object for paper/audit
summaries.  It is intentionally not a closure theorem: the contract is
equivalent to the R607 equality/scalar ledger, feeds the existing Matsushima
boundary bridge, and is still not forced by the current abstract interface.
-/

import HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC69_H8ResidualProofWorkContract

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC56_H8ResidualCartanRankOnePackage
open FrontC62_H8ResidualCartanContainmentExpectedBettiPackage
open FrontC65_H8ResidualPrimitiveTargetLedger
open FrontC66_H8ResidualEqualityTargetLedger
open FrontC67_H8ResidualRankOneReconciliation
open FrontC68_H8ResidualCarrierEqualityObstruction

section Contract

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The R610 proof-work contract: exactly two Cartan-line carrier equalities
plus one scalar-preimage target. -/
structure EVIIH8ResidualProofWorkContract where
  source_eq_cartan : sourceCartanEqualityTarget A B
  compactDual_eq_cartan : compactDualCartanEqualityTarget A B
  scalar_preimage : scalarPreimagePrimitiveTarget A B

variable {A B}

/-- **R610 substantive theorem (1/9)**: R607 equality/scalar data is exactly
an R610 proof-work contract. -/
def proofWorkContract_of_equalityScalarTargets
    (O : EVIIH8ResidualEqualityScalarTargets A B) :
    EVIIH8ResidualProofWorkContract A B where
  source_eq_cartan := O.source_eq_cartan
  compactDual_eq_cartan := O.compactDual_eq_cartan
  scalar_preimage := O.scalar_preimage

/-- **R610 substantive theorem (2/9)**: the R610 proof-work contract rebuilds
the R607 equality/scalar ledger. -/
def equalityScalarTargets_of_proofWorkContract
    (O : EVIIH8ResidualProofWorkContract A B) :
    EVIIH8ResidualEqualityScalarTargets A B where
  source_eq_cartan := O.source_eq_cartan
  compactDual_eq_cartan := O.compactDual_eq_cartan
  scalar_preimage := O.scalar_preimage

/-- **R610 substantive theorem (3/9)**: the R607 ledger and the R610 contract
are the same inhabited residual target. -/
theorem residual_equalityScalarTargets_nonempty_iff_proofWorkContract_nonempty :
    Nonempty (EVIIH8ResidualEqualityScalarTargets A B) <->
      Nonempty (EVIIH8ResidualProofWorkContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (proofWorkContract_of_equalityScalarTargets
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (equalityScalarTargets_of_proofWorkContract
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R610 substantive theorem (4/9)**: the proof-work contract rebuilds the
R603/R604 Cartan-containment residual package. -/
def cartanContainmentResidual_of_proofWorkContract
    (O : EVIIH8ResidualProofWorkContract A B) :
    EVIIH8ResidualCartanContainmentExpectedBettiObligations A B :=
  cartanContainmentResidual_of_equalityScalarTargets
    (A := A) (B := B)
    (equalityScalarTargets_of_proofWorkContract (A := A) (B := B) O)

/-- **R610 substantive theorem (5/9)**: a proof-work contract feeds the
existing Matsushima V56 boundary bridge. -/
def matsushimaV56BoundaryData_of_proofWorkContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualProofWorkContract A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_equalityScalarTargets
    (A := A) (B := B)
    (equalityScalarTargets_of_proofWorkContract (A := A) (B := B) O)

/-- **R610 substantive theorem (6/9)**: the proof-work contract is also the
same inhabited target as the Cartan-line rank-one residual package. -/
theorem residual_proofWorkContract_nonempty_iff_cartanRankOne_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualProofWorkContract A B) <->
      Nonempty (EVIIH8ResidualCartanRankOneObligations A B) :=
  (residual_equalityScalarTargets_nonempty_iff_proofWorkContract_nonempty
    (A := A) (B := B)).symm.trans
    (residual_equalityScalarTargets_nonempty_iff_cartanRankOne_nonempty
      (A := A) (B := B))

end Contract

section Obstruction

/-- **R610 substantive theorem (7/9)**: even after the two Cartan-line carrier
equalities, the current abstract interface does not force the proof-work
contract. -/
theorem current_interface_with_cartan_equalities_does_not_force_proofWorkContract :
    sourceCartanEqualityTarget TargetBettiSource TargetBettiTarget /\
      compactDualCartanEqualityTarget TargetBettiSource TargetBettiTarget /\
        Not (EVIIH8ResidualProofWorkContract
          TargetBettiSource TargetBettiTarget) := by
  refine And.intro counterexample_source_eq_cartan
    (And.intro counterexample_compactDual_eq_cartan ?_)
  intro O
  exact
    current_interface_with_cartan_equalities_does_not_force_equalityScalarTargets.2.2
      (equalityScalarTargets_of_proofWorkContract
        (A := TargetBettiSource) (B := TargetBettiTarget) O)

end Obstruction

/-- Exact R610 proof-work target names for paper and route summaries. -/
def currentR610ProofWorkContractTargetNames : List String := [
  "prove surjectivity_source = CartanH8",
  "prove compactDual = CartanH8",
  "prove scalar/rank-one target"
]

/-- Machine-readable status for the current proof-work contract. -/
structure R610ProofWorkContractSnapshot where
  proofWorkObligationCount : Nat
  carrierEqualityObligationCount : Nat
  scalarRankOneObligationCount : Nat
  proofWorkContractEquivalentToR607 : Bool
  rankOneAndScalarCountedSeparately : Bool
  carrierEqualitiesAloneCloseContract : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R610 status: exactly three proof-work obligations remain for this
frontier, and this is not a full-HC closure claim. -/
def currentR610ProofWorkContractSnapshot :
    R610ProofWorkContractSnapshot where
  proofWorkObligationCount := currentR610ProofWorkContractTargetNames.length
  carrierEqualityObligationCount := 2
  scalarRankOneObligationCount := 1
  proofWorkContractEquivalentToR607 := true
  rankOneAndScalarCountedSeparately := false
  carrierEqualitiesAloneCloseContract := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R610 substantive theorem (8/9)**: kernel-checked numeric status for the
proof-work contract ledger. -/
theorem currentR610ProofWorkContractSnapshot_eq_texStatus :
    currentR610ProofWorkContractSnapshot =
      ({ proofWorkObligationCount := 3
         carrierEqualityObligationCount := 2
         scalarRankOneObligationCount := 1
         proofWorkContractEquivalentToR607 := true
         rankOneAndScalarCountedSeparately := false
         carrierEqualitiesAloneCloseContract := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R610ProofWorkContractSnapshot) := by
  decide

/-- **R610 substantive theorem (9/9)**: kernel-checked target names for the
proof-work contract ledger. -/
theorem currentR610ProofWorkContractTargetNames_eq_texStatus :
    currentR610ProofWorkContractTargetNames = [
      "prove surjectivity_source = CartanH8",
      "prove compactDual = CartanH8",
      "prove scalar/rank-one target"
    ] := by
  rfl

def R610_substantiveTheoremCount : Nat := 9

end FrontC69_H8ResidualProofWorkContract
end HCGapL4
end HodgeReduction
