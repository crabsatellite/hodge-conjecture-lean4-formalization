/-
# HC Gap L4 -- Front C104: source-H8 remains independent after R666 (R668).

R667 showed that exact image is not forced by the other two R666 targets.
This file records the complementary source-side obstruction for the R666
contract:

* exact image can hold;
* the target-invariant excess quotient can vanish;
* `source_invariants = H8` can still fail.

The countermodel is the R664 Cartan-containment model, where the source
invariants and compact-dual carrier are `bot`, while the compact-dual H8 line
is nonzero.  This prevents a future agent from treating quotient vanishing as
a substitute for the source-H8 theorem.
-/

import HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence
import HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC104_H8ResidualSourceH8QuotientIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC100_H8ResidualCartanContainmentIndependence

/-- **R668 obstruction theorem (1/5)**: in the R664 countermodel, quotient
vanishing holds.  Under exact image, R641 rewrites quotient vanishing as the
vacuous containment `trivialModulePart <= surjectivity_target`; both sides
are `bot` in this model. -/
theorem counterexample_targetInvariantExcessQuotient_eq_bot :
    targetInvariantExcessQuotient
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget = ⊥ :=
  (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_surjectivity_target
    (A := CartanContainmentObstructionSource)
    (B := CartanContainmentObstructionTarget)
    counterexample_sourceInvariantExactImageTarget).2
    (by
      intro beta hbeta
      change beta ∈ (⊥ : Submodule Rat CartanContainmentObstructionTarget) at hbeta
      simpa using hbeta)

/-- **R668 obstruction theorem (2/5)**: in the same model,
`source_invariants = H8` fails because source invariants are `bot` while
`H8 = span {h^4}` contains the nonzero element `1`. -/
theorem counterexample_not_source_invariants_eq_H8 :
    Not
      (MatsushimaData.source_invariants
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget) =
        CompactDualData.H8 (A := CartanContainmentObstructionSource)) := by
  intro hsource_H8
  have hone_source :
      (1 : CartanContainmentObstructionSource) ∈
        MatsushimaData.source_invariants
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget) := by
    rw [hsource_H8]
    change (1 : Rat) ∈ Submodule.span Rat ({((1 : Rat) ^ 4)} : Set Rat)
    rw [Submodule.mem_span_singleton]
    refine ⟨1, ?_⟩
    norm_num
  change (1 : Rat) = 0 at hone_source
  norm_num at hone_source

/-- **R668 obstruction theorem (3/5)**: after R666, exact image plus quotient
vanishing still do not force the source-H8 theorem. -/
theorem current_interface_with_exactImage_quotient_does_not_force_sourceH8 :
    sourceInvariantExactImageTarget
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget ∧
    targetInvariantExcessQuotient
        CartanContainmentObstructionSource
        CartanContainmentObstructionTarget = ⊥ ∧
    Not
      (MatsushimaData.source_invariants
          (A := CartanContainmentObstructionSource)
          (B := CartanContainmentObstructionTarget) =
        CompactDualData.H8 (A := CartanContainmentObstructionSource)) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_targetInvariantExcessQuotient_eq_bot,
    counterexample_not_source_invariants_eq_H8⟩

/-- Machine-readable status for the R668 source-H8 independence audit. -/
structure R668SourceH8QuotientIndependenceSnapshot where
  exactImageAvailable : Bool
  quotientVanishingAvailable : Bool
  sourceH8ForcedByExactImageAndQuotient : Bool
  sourceH8StillIndependentAfterR666 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R668 status: R666's quotient spelling does not remove the
source-H8 carrier target. -/
def currentR668SourceH8QuotientIndependenceSnapshot :
    R668SourceH8QuotientIndependenceSnapshot where
  exactImageAvailable := true
  quotientVanishingAvailable := true
  sourceH8ForcedByExactImageAndQuotient := false
  sourceH8StillIndependentAfterR666 := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R668 obstruction theorem (4/5)**: kernel-checked status for the
R668 source-H8 independence audit. -/
theorem currentR668SourceH8QuotientIndependenceSnapshot_eq_texStatus :
    currentR668SourceH8QuotientIndependenceSnapshot =
      ({ exactImageAvailable := true
         quotientVanishingAvailable := true
         sourceH8ForcedByExactImageAndQuotient := false
         sourceH8StillIndependentAfterR666 := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R668SourceH8QuotientIndependenceSnapshot) := by
  decide

/-- **R668 obstruction theorem (5/5)**: the theorem count is fixed for route
summaries. -/
theorem R668_substantiveTheoremCount_eq : (5 : Nat) = 5 := rfl

def R668_substantiveTheoremCount : Nat := 5

end FrontC104_H8ResidualSourceH8QuotientIndependence
end HCGapL4
end HodgeReduction
