/-
# HC Gap L4 -- Front C68: carrier-equality obstruction (R609).

R607-R608 leave three proof-work obligations:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* the scalar/rank-one target.

This file records a sharper non-closure fact: the first two Cartan-line
equalities alone do not force the third target in the current abstract
interface.  Thus the paper must continue to treat the scalar/rank-one theorem
as a genuine remaining proof-work obligation.
-/

import HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC68_H8ResidualCarrierEqualityObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC65_H8ResidualPrimitiveTargetLedger
open FrontC66_H8ResidualEqualityTargetLedger

/-- **R609 obstruction theorem (1/6)**: the R577/R605 countermodel satisfies
the source/Cartan equality. -/
theorem counterexample_source_eq_cartan :
    sourceCartanEqualityTarget TargetBettiSource TargetBettiTarget := by
  have hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource) :=
    current_interface_with_H8_equalities_does_not_force_scalar_preimage.1
  calc
    MatsushimaSurjectivityData.surjectivity_source
        (A := TargetBettiSource) (B := TargetBettiTarget)
        = CompactDualData.H8 (A := TargetBettiSource) := hsource_eq_H8
    _ = CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource) :=
        (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := TargetBettiSource)).symm

/-- **R609 obstruction theorem (2/6)**: the same countermodel satisfies the
compactDual/Cartan equality. -/
theorem counterexample_compactDual_eq_cartan :
    compactDualCartanEqualityTarget TargetBettiSource TargetBettiTarget := by
  have hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource) :=
    current_interface_with_H8_equalities_does_not_force_scalar_preimage.2.1
  calc
    MatsushimaCompactDualData.compactDual
        (A := TargetBettiSource) (B := TargetBettiTarget)
        = CompactDualData.H8 (A := TargetBettiSource) := hcompact_eq_H8
    _ = CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource) :=
        (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := TargetBettiSource)).symm

/-- **R609 obstruction theorem (3/6)**: the two Cartan-line equalities do not
force the scalar-preimage target in the current abstract interface. -/
theorem current_interface_with_cartan_equalities_does_not_force_scalar_preimage :
    sourceCartanEqualityTarget TargetBettiSource TargetBettiTarget /\
      compactDualCartanEqualityTarget TargetBettiSource TargetBettiTarget /\
        Not (scalarPreimagePrimitiveTarget
          TargetBettiSource TargetBettiTarget) := by
  exact
    And.intro counterexample_source_eq_cartan
      (And.intro counterexample_compactDual_eq_cartan
        current_interface_with_H8_equalities_does_not_force_scalar_preimage.2.2)

/-- **R609 obstruction theorem (4/6)**: equivalently, the two Cartan-line
equalities do not force the full R607 equality/scalar target package. -/
theorem current_interface_with_cartan_equalities_does_not_force_equalityScalarTargets :
    sourceCartanEqualityTarget TargetBettiSource TargetBettiTarget /\
      compactDualCartanEqualityTarget TargetBettiSource TargetBettiTarget /\
        Not (EVIIH8ResidualEqualityScalarTargets
          TargetBettiSource TargetBettiTarget) := by
  refine And.intro counterexample_source_eq_cartan
    (And.intro counterexample_compactDual_eq_cartan ?_)
  intro O
  exact
    current_interface_with_H8_equalities_does_not_force_scalar_preimage.2.2
      O.scalar_preimage

/-- Machine-readable status for the R609 obstruction ledger. -/
structure R609CarrierEqualityObstructionSnapshot where
  carrierEqualityTargetCount : Nat
  scalarOrRankOneTargetCount : Nat
  carrierEqualitiesAloneForceScalarOrRankOne : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R609 status: two Cartan-line equalities are still insufficient to
close the scalar/rank-one target. -/
def currentR609CarrierEqualityObstructionSnapshot :
    R609CarrierEqualityObstructionSnapshot where
  carrierEqualityTargetCount := 2
  scalarOrRankOneTargetCount := 1
  carrierEqualitiesAloneForceScalarOrRankOne := false
  isClosureClaim := false

/-- **R609 obstruction theorem (5/6)**: kernel-checked numeric status for the
carrier-equality obstruction ledger. -/
theorem currentR609CarrierEqualityObstructionSnapshot_eq_texStatus :
    currentR609CarrierEqualityObstructionSnapshot =
      ({ carrierEqualityTargetCount := 2
         scalarOrRankOneTargetCount := 1
         carrierEqualitiesAloneForceScalarOrRankOne := false
         isClosureClaim := false } :
        R609CarrierEqualityObstructionSnapshot) := by
  decide

def currentR609ObstructionTargetNames : List String := [
  "surjectivity_source = CartanH8",
  "compactDual = CartanH8",
  "scalar/rank-one target not forced by the two carrier equalities"
]

/-- **R609 obstruction theorem (6/6)**: kernel-checked names for the
carrier-equality obstruction ledger. -/
theorem currentR609ObstructionTargetNames_eq_texStatus :
    currentR609ObstructionTargetNames = [
      "surjectivity_source = CartanH8",
      "compactDual = CartanH8",
      "scalar/rank-one target not forced by the two carrier equalities"
    ] := by
  rfl

def R609_substantiveTheoremCount : Nat := 6

end FrontC68_H8ResidualCarrierEqualityObstruction
end HCGapL4
end HodgeReduction
