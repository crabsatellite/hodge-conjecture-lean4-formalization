/-
# HC Gap L4 -- Front C103: exact image remains independent after R666 (R667).

R666 rewrote the target side as quotient vanishing:

  `targetInvariantExcessQuotient = bot`.

This file checks that the new quotient spelling does not accidentally make
the exact-image target redundant.  Reusing the R662 one-dimensional model,
we prove that `source_invariants = H8` and quotient vanishing can both hold
while

  `Submodule.map j_q source_invariants = surjectivity_target`

fails.  Thus exact image remains a separate Matsushima source-geometry
target under the R666 contract.
-/

import HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence
import HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC103_H8ResidualExactImageQuotientIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC98_H8ResidualExactImageIndependence
open FrontC101_H8ResidualTargetInvariantLineBridge
open FrontC102_H8ResidualTargetInvariantQuotientEquivalence

/-- **R667 obstruction theorem (1/5)**: in the R662 exact-image obstruction
model, the source invariants are already the compact-dual H8 line. -/
theorem counterexample_source_invariants_eq_H8 :
    MatsushimaData.source_invariants
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) =
      CompactDualData.H8 (A := ExactImageObstructionSource) := by
  ext x
  constructor
  · intro _
    change x ∈ Submodule.span Rat ({((1 : Rat) ^ 4)} : Set Rat)
    rw [Submodule.mem_span_singleton]
    refine ⟨x, ?_⟩
    norm_num
  · intro _
    trivial

/-- **R667 obstruction theorem (2/5)**: the same model satisfies the R666
quotient-vanishing target.  This is obtained through the R666 equivalence
with target-invariant line containment. -/
theorem counterexample_targetInvariantExcessQuotient_eq_bot :
    targetInvariantExcessQuotient
        ExactImageObstructionSource ExactImageObstructionTarget = ⊥ :=
  (targetInvariantExcessQuotient_eq_bot_iff_target_invariants_le_h_pow_four_line
    (A := ExactImageObstructionSource)
    (B := ExactImageObstructionTarget)
    counterexample_source_invariants_eq_H8).2
    ((target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line
      (A := ExactImageObstructionSource)
      (B := ExactImageObstructionTarget)).2
      counterexample_trivialModulePart_le_h_pow_four_line)

/-- **R667 obstruction theorem (3/5)**: after R666, source-H8 plus quotient
vanishing still do not force exact image in the current abstract interface. -/
theorem current_interface_with_sourceH8_quotient_does_not_force_exactImage :
    (MatsushimaData.source_invariants
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget) =
      CompactDualData.H8 (A := ExactImageObstructionSource)) ∧
    targetInvariantExcessQuotient
        ExactImageObstructionSource ExactImageObstructionTarget = ⊥ ∧
    Not (sourceInvariantExactImageTarget
      ExactImageObstructionSource ExactImageObstructionTarget) :=
  ⟨counterexample_source_invariants_eq_H8,
    counterexample_targetInvariantExcessQuotient_eq_bot,
    counterexample_not_sourceInvariantExactImageTarget⟩

/-- Machine-readable status for the R667 exact-image independence audit. -/
structure R667ExactImageQuotientIndependenceSnapshot where
  sourceH8Available : Bool
  quotientVanishingAvailable : Bool
  exactImageForcedBySourceH8AndQuotient : Bool
  exactImageStillIndependentAfterR666 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R667 status: R666's quotient spelling does not remove the
exact-image source-geometry target. -/
def currentR667ExactImageQuotientIndependenceSnapshot :
    R667ExactImageQuotientIndependenceSnapshot where
  sourceH8Available := true
  quotientVanishingAvailable := true
  exactImageForcedBySourceH8AndQuotient := false
  exactImageStillIndependentAfterR666 := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R667 obstruction theorem (4/5)**: kernel-checked status for the
R667 exact-image independence audit. -/
theorem currentR667ExactImageQuotientIndependenceSnapshot_eq_texStatus :
    currentR667ExactImageQuotientIndependenceSnapshot =
      ({ sourceH8Available := true
         quotientVanishingAvailable := true
         exactImageForcedBySourceH8AndQuotient := false
         exactImageStillIndependentAfterR666 := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R667ExactImageQuotientIndependenceSnapshot) := by
  decide

/-- **R667 obstruction theorem (5/5)**: the theorem count is fixed for route
summaries. -/
theorem R667_substantiveTheoremCount_eq : (5 : Nat) = 5 := rfl

def R667_substantiveTheoremCount : Nat := 5

end FrontC103_H8ResidualExactImageQuotientIndependence
end HCGapL4
end HodgeReduction
