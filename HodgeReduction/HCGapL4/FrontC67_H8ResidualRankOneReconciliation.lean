/-
# HC Gap L4 -- Front C67: rank-one reconciliation ledger (R608).

R607 leaves three proof-work obligations:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* scalar-preimage surjectivity.

Earlier fronts often used the equivalent rank-one target
`finrank trivialModulePart = 1`.  This file reconnects those two target
spellings at the R607 frontier, so the paper and route ledger cannot count
scalar preimages and the rank-one target as separate residual gaps.

This is still a target reconciliation, not a proof of the carrier equalities
or of the target rank/scalar theorem.
-/

import HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion
import HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage
import HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC67_H8ResidualRankOneReconciliation

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC48_H8BoundaryRankOneCriterion
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC56_H8ResidualCartanRankOnePackage
open FrontC66_H8ResidualEqualityTargetLedger

section Reconciliation

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

variable {A B}

omit [MatsushimaCompactDualData A B] [CuspidalCohomologyData B] in
private theorem source_eq_H8_of_source_eq_cartan
    (hsource : sourceCartanEqualityTarget A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) := hsource
    _ = CompactDualData.H8 (A := A) :=
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B] in
private theorem compactDual_eq_H8_of_compactDual_eq_cartan
    (hcompact : compactDualCartanEqualityTarget A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaCompactDualData.compactDual (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) := hcompact
    _ = CompactDualData.H8 (A := A) :=
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)

/-- **R608 substantive theorem (1/7)**: the R607 equality/scalar target
package implies the older H8/scalar-preimage residual package. -/
def scalarPreimageResidual_of_equalityScalarTargets
    (O : EVIIH8ResidualEqualityScalarTargets A B) :
    EVIIH8ResidualScalarPreimageObligations A B where
  source_eq_H8 :=
    source_eq_H8_of_source_eq_cartan (A := A) (B := B) O.source_eq_cartan
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_compactDual_eq_cartan
      (A := A) (B := B) O.compactDual_eq_cartan
  scalar_preimage := O.scalar_preimage

/-- **R608 substantive theorem (2/7)**: the older H8/scalar-preimage
residual package rebuilds the R607 equality/scalar target package. -/
def equalityScalarTargets_of_scalarPreimageResidual
    (O : EVIIH8ResidualScalarPreimageObligations A B) :
    EVIIH8ResidualEqualityScalarTargets A B where
  source_eq_cartan := by
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = CompactDualData.H8 (A := A) := O.source_eq_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
          (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
            (A := A)).symm
  compactDual_eq_cartan := by
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = CompactDualData.H8 (A := A) := O.compactDual_eq_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
          (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
            (A := A)).symm
  scalar_preimage := O.scalar_preimage

/-- **R608 substantive theorem (3/7)**: R607's equality/scalar target and
the older H8/scalar-preimage residual package are the same inhabited target. -/
theorem residual_scalarPreimage_nonempty_iff_equalityScalarTargets_nonempty :
    Nonempty (EVIIH8ResidualScalarPreimageObligations A B) <->
      Nonempty (EVIIH8ResidualEqualityScalarTargets A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (equalityScalarTargets_of_scalarPreimageResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (scalarPreimageResidual_of_equalityScalarTargets
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R608 substantive theorem (4/7)**: the R607 equality/scalar target
implies the Cartan-line rank-one residual package. -/
def cartanRankOneResidual_of_equalityScalarTargets
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualEqualityScalarTargets A B) :
    EVIIH8ResidualCartanRankOneObligations A B where
  source_eq_cartan := O.source_eq_cartan
  compactDual_eq_cartan := O.compactDual_eq_cartan
  trivialModulePart_rank_one :=
    (scalar_preimage_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
      (A := A) (B := B)
      (source_eq_H8_of_source_eq_cartan (A := A) (B := B) O.source_eq_cartan)
      (compactDual_eq_H8_of_compactDual_eq_cartan
        (A := A) (B := B) O.compactDual_eq_cartan)).1
      O.scalar_preimage

/-- **R608 substantive theorem (5/7)**: the Cartan-line rank-one residual
package rebuilds the R607 equality/scalar target. -/
def equalityScalarTargets_of_cartanRankOneResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualCartanRankOneObligations A B) :
    EVIIH8ResidualEqualityScalarTargets A B where
  source_eq_cartan := O.source_eq_cartan
  compactDual_eq_cartan := O.compactDual_eq_cartan
  scalar_preimage :=
    (scalar_preimage_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8
      (A := A) (B := B)
      (source_eq_H8_of_source_eq_cartan (A := A) (B := B) O.source_eq_cartan)
      (compactDual_eq_H8_of_compactDual_eq_cartan
        (A := A) (B := B) O.compactDual_eq_cartan)).2
      O.trivialModulePart_rank_one

/-- **R608 substantive theorem (6/7)**: R607's equality/scalar target and
the Cartan-line rank-one residual package are the same inhabited target. -/
theorem residual_equalityScalarTargets_nonempty_iff_cartanRankOne_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualEqualityScalarTargets A B) <->
      Nonempty (EVIIH8ResidualCartanRankOneObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanRankOneResidual_of_equalityScalarTargets
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (equalityScalarTargets_of_cartanRankOneResidual
            (A := A) (B := B) O)))

end Reconciliation

/-- R608's exact proof-work target names after reconciling scalar preimages
with the rank-one spelling. -/
def currentR608RankOneReconciliationTargetNames : List String := [
  "surjectivity_source = CartanH8",
  "compactDual = CartanH8",
  "finrank trivialModulePart = 1 (equiv. scalar-preimage surjectivity)"
]

/-- Machine-readable status for the R608 reconciliation ledger. -/
structure R608RankOneReconciliationSnapshot where
  proofWorkTargetCount : Nat
  carrierEqualityTargetCount : Nat
  scalarPreimageTargetCount : Nat
  rankOneAlternateTargetCount : Nat
  scalarPreimageAndRankOneCountedSeparately : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R608 status: the third proof-work target has equivalent
scalar-preimage and rank-one spellings, but it is not proved. -/
def currentR608RankOneReconciliationSnapshot :
    R608RankOneReconciliationSnapshot where
  proofWorkTargetCount := currentR608RankOneReconciliationTargetNames.length
  carrierEqualityTargetCount := 2
  scalarPreimageTargetCount := 1
  rankOneAlternateTargetCount := 1
  scalarPreimageAndRankOneCountedSeparately := false
  isClosureClaim := false

/-- **R608 substantive theorem (7/7)**: kernel-checked numeric status for the
rank-one reconciliation ledger. -/
theorem currentR608RankOneReconciliationSnapshot_eq_texStatus :
    currentR608RankOneReconciliationSnapshot =
      ({ proofWorkTargetCount := 3
         carrierEqualityTargetCount := 2
         scalarPreimageTargetCount := 1
         rankOneAlternateTargetCount := 1
         scalarPreimageAndRankOneCountedSeparately := false
         isClosureClaim := false } :
        R608RankOneReconciliationSnapshot) := by
  decide

theorem currentR608RankOneReconciliationTargetNames_eq_texStatus :
    currentR608RankOneReconciliationTargetNames = [
      "surjectivity_source = CartanH8",
      "compactDual = CartanH8",
      "finrank trivialModulePart = 1 (equiv. scalar-preimage surjectivity)"
    ] := by
  rfl

def R608_substantiveTheoremCount : Nat := 7

end FrontC67_H8ResidualRankOneReconciliation
end HCGapL4
end HodgeReduction
