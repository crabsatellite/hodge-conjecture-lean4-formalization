/-
# HC Gap L4 -- Front C105: target-invariant line equality (R669).

R666 states the target-side gap as quotient vanishing, equivalently

  `target_invariants <= span {j_q(h^4)}`

once the source-H8 carrier is fixed.  R657 already proves that under the same
source-H8 carrier, the generator `j_q(h^4)` lies in the target invariants.
Therefore the containment target is equivalently the exact line equality

  `target_invariants = span {j_q(h^4)}`.

This is a positive normalization of the target-side theorem: future work can
prove a one-line equality for target invariants, or quotient vanishing; the
two are the same residual target under source-H8.
-/

import HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity
import HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence
import HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC105_H8ResidualTargetInvariantLineEquality

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC93_H8ResidualLineContainmentFromMultiplicity
open FrontC101_H8ResidualTargetInvariantLineBridge
open FrontC102_H8ResidualTargetInvariantQuotientEquivalence

section TargetInvariantLineEquality

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

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- **R669 substantive theorem (1/6)**: under source-H8, the R665 target
line containment is equivalent to the exact one-dimensional equality for
target invariants. -/
theorem target_invariants_eq_h_pow_four_line_iff_target_invariants_le_h_pow_four_line
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) ↔
    (MatsushimaData.target_invariants (A := A) (B := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) := by
  constructor
  · intro heq
    rw [heq]
  · intro hle
    apply le_antisymm hle
    apply Submodule.span_le.mpr
    intro beta hbeta
    rw [Set.mem_singleton_iff] at hbeta
    rw [hbeta]
    rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
    exact matsushima_h_pow_four_mem_trivialModulePart_of_sourceH8
      (A := A) (B := B) hsource_H8

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R669 substantive theorem (2/6)**: quotient vanishing gives the exact
target-invariant line equality under source-H8. -/
theorem target_invariants_eq_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hquot : targetInvariantExcessQuotient A B = ⊥) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} :=
  (target_invariants_eq_h_pow_four_line_iff_target_invariants_le_h_pow_four_line
    (A := A) (B := B) hsource_H8).2
    (target_invariants_le_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B) hsource_H8 hquot)

/-- The R669 exact-line equality contract: same exact-image/source-H8 carrier
as R666, with quotient vanishing replaced by exact target-line equality. -/
structure EVIIH8ResidualTargetInvariantLineEqualityContract
    (A B : Type*)
    [CommRing A] [Algebra Rat A] [CohomologyRing A]
    [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
    [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B]
    [CuspidalCohomologyData B]
    [EisensteinVanishingDeg8 A B]
    [CuspidalGInvariantTrivialModuleDeg8 A B] where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_invariants_eq_h_pow_four_line :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R669 substantive theorem (3/6)**: R666 quotient contracts give exact
target-invariant line equality contracts. -/
def targetInvariantLineEqualityContract_of_targetInvariantExcessQuotientContract
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_eq_h_pow_four_line :=
    target_invariants_eq_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_excess_quotient_eq_bot

/-- **R669 substantive theorem (4/6)**: exact target-line equality contracts
rebuild the R666 quotient contracts. -/
def targetInvariantExcessQuotientContract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_target_invariants_le_h_pow_four_line
      (A := A) (B := B) O.source_invariants_eq_H8).2
      ((target_invariants_eq_h_pow_four_line_iff_target_invariants_le_h_pow_four_line
        (A := A) (B := B) O.source_invariants_eq_H8).1
        O.target_invariants_eq_h_pow_four_line)

/-- **R669 substantive theorem (5/6)**: quotient-vanishing contracts and
target-invariant line-equality contracts are the same inhabited residual
target. -/
theorem residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) ↔
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_targetInvariantExcessQuotientContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))

/-- **R669 substantive theorem (6/6)**: exact target-line equality contracts
also give R665 target-line contracts. -/
def targetInvariantLineContract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualTargetInvariantLineContract A B :=
  targetInvariantLineContract_of_targetInvariantExcessQuotientContract
    (A := A) (B := B)
    (targetInvariantExcessQuotientContract_of_targetInvariantLineEqualityContract
      (A := A) (B := B) O)

end TargetInvariantLineEquality

/-- R669 equivalent target names for route summaries. -/
def currentR669TargetInvariantLineEqualityTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove target_invariants = span {j_q(h^4)}"
]

/-- Machine-readable status for the R669 target-invariant line equality bridge. -/
structure R669TargetInvariantLineEqualitySnapshot where
  proofWorkObligationCount : Nat
  lineContainmentEquivalentToLineEquality : Bool
  quotientContractEquivalentToLineEqualityContract : Bool
  lineEqualityFeedsR665Contract : Bool
  provesTargetInvariantLineEquality : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R669 status: quotient vanishing can be attacked as exact equality
of target invariants with the explicit `j_q(h^4)` line, but the equality is
not proved here. -/
def currentR669TargetInvariantLineEqualitySnapshot :
    R669TargetInvariantLineEqualitySnapshot where
  proofWorkObligationCount := currentR669TargetInvariantLineEqualityTargetNames.length
  lineContainmentEquivalentToLineEquality := true
  quotientContractEquivalentToLineEqualityContract := true
  lineEqualityFeedsR665Contract := true
  provesTargetInvariantLineEquality := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R669 ledger. -/
theorem currentR669TargetInvariantLineEqualitySnapshot_eq_texStatus :
    currentR669TargetInvariantLineEqualitySnapshot =
      ({ proofWorkObligationCount := 3
         lineContainmentEquivalentToLineEquality := true
         quotientContractEquivalentToLineEqualityContract := true
         lineEqualityFeedsR665Contract := true
         provesTargetInvariantLineEquality := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R669TargetInvariantLineEqualitySnapshot) := by
  decide

/-- Kernel-checked target names for the R669 ledger. -/
theorem currentR669TargetInvariantLineEqualityTargetNames_eq_texStatus :
    currentR669TargetInvariantLineEqualityTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove target_invariants = span {j_q(h^4)}"
    ] := by
  rfl

def R669_substantiveTheoremCount : Nat := 6

end FrontC105_H8ResidualTargetInvariantLineEquality
end HCGapL4
end HodgeReduction
