/-
# HC Gap L4 -- Front C102: target-invariant line versus quotient vanishing (R666).

R665 restated the target generator-line theorem directly on Matsushima target
invariants:

  `target_invariants <= span {j_q(h^4)}`.

R641/R658 already provide the quotient-vanishing route, but the last bridge
still named the cuspidal trivial-module part.  This file removes that naming
layer and proves that the R665 target-invariant-line contract is equivalent
to the R641 target-invariant excess quotient contract.

No live target is closed here.  The point is to make the next target-side
attack unambiguous: prove quotient vanishing, or prove target-invariant line
containment; they are the same residual target once the source-H8 side is in
place.
-/

import HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC102_H8ResidualTargetInvariantQuotientEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC94_H8ResidualQuotientLineContainmentEquivalence
open FrontC101_H8ResidualTargetInvariantLineBridge

section TargetInvariantQuotient

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R666 substantive theorem (1/6)**: once the source invariants are the
compact-dual H8 line, the one-sided Cartan-to-compactDual containment in the
R665 contract follows from the existing `compactDual = source_invariants`
comparison. -/
theorem cartanH8_le_compactDual_of_source_invariants_eq_H8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
  rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
  rw [<- hsource_H8]
  exact MatsushimaCompactDualData.source_invariants_le_compactDual
    (A := A) (B := B)

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R666 substantive theorem (2/6)**: under the source-H8 carrier equality,
the quotient-vanishing target is exactly the R665 target-invariant line
containment.  This is the R658 quotient-line equivalence with the R554/R665
`target_invariants = trivialModulePart` identification composed in. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_target_invariants_le_h_pow_four_line
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ ↔
      MatsushimaData.target_invariants (A := A) (B := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
  (targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B) hsource_H8).trans
    (target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)).symm

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R666 substantive theorem (3/6)**: quotient vanishing gives the R665
target-invariant line theorem directly. -/
theorem target_invariants_le_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hquot : targetInvariantExcessQuotient A B = ⊥) :
    MatsushimaData.target_invariants (A := A) (B := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} :=
  (targetInvariantExcessQuotient_eq_bot_iff_target_invariants_le_h_pow_four_line
    (A := A) (B := B) hsource_H8).1 hquot

/-- **R666 substantive theorem (4/6)**: the R641 quotient contract rebuilds
the current R665 target-invariant-line contract.  The Cartan containment is
not assumed separately; it is recovered from `source_invariants = H8`. -/
def targetInvariantLineContract_of_targetInvariantExcessQuotientContract
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualTargetInvariantLineContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  cartanH8_le_compactDual :=
    cartanH8_le_compactDual_of_source_invariants_eq_H8
      (A := A) (B := B) O.source_invariants_eq_H8
  target_invariants_le_h_pow_four_line :=
    target_invariants_le_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient
      (A := A) (B := B)
      O.source_invariants_eq_H8
      O.target_excess_quotient_eq_bot

/-- **R666 substantive theorem (5/6)**: the R665 line contract and the R641
quotient contract are the same inhabited residual package. -/
theorem residual_targetInvariantLine_nonempty_iff_targetInvariantExcessQuotient_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantLineContract A B) ↔
      Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_targetInvariantLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineContract_of_targetInvariantExcessQuotientContract
            (A := A) (B := B) O)))

/-- **R666 substantive theorem (6/6)**: the line-contract spelling also
recovers restricted invariant-map bijectivity through the quotient route.
This is a consumer bridge only; the quotient/line target itself remains open. -/
def invariantMapBijectivityContract_of_targetInvariantLineContract
    (O : EVIIH8ResidualTargetInvariantLineContract A B) :
    FrontC88_H8ResidualInvariantMapBijectivity.EVIIH8ResidualInvariantMapBijectivityContract A B :=
  invariantMapBijectivityContract_of_targetInvariantExcessQuotientContract_noFinite
    (A := A) (B := B)
    (targetInvariantExcessQuotientContract_of_targetInvariantLineContract
      (A := A) (B := B) O)

end TargetInvariantQuotient

/-- R666 equivalent target names for route summaries. -/
def currentR666TargetInvariantQuotientTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove targetInvariantExcessQuotient = bot, equivalently target_invariants <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R666 target-invariant quotient bridge. -/
structure R666TargetInvariantQuotientSnapshot where
  proofWorkObligationCount : Nat
  quotientEquivalentToTargetInvariantLine : Bool
  quotientContractEquivalentToR665LineContract : Bool
  sourceH8RecoversCartanContainment : Bool
  lineContractFeedsInvariantMapBijectivity : Bool
  provesQuotientVanishing : Bool
  provesTargetInvariantLine : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R666 status: quotient vanishing and target-invariant line
containment are equivalent contract spellings, but neither is proved here. -/
def currentR666TargetInvariantQuotientSnapshot :
    R666TargetInvariantQuotientSnapshot where
  proofWorkObligationCount := currentR666TargetInvariantQuotientTargetNames.length
  quotientEquivalentToTargetInvariantLine := true
  quotientContractEquivalentToR665LineContract := true
  sourceH8RecoversCartanContainment := true
  lineContractFeedsInvariantMapBijectivity := true
  provesQuotientVanishing := false
  provesTargetInvariantLine := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R666 ledger. -/
theorem currentR666TargetInvariantQuotientSnapshot_eq_texStatus :
    currentR666TargetInvariantQuotientSnapshot =
      ({ proofWorkObligationCount := 3
         quotientEquivalentToTargetInvariantLine := true
         quotientContractEquivalentToR665LineContract := true
         sourceH8RecoversCartanContainment := true
         lineContractFeedsInvariantMapBijectivity := true
         provesQuotientVanishing := false
         provesTargetInvariantLine := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R666TargetInvariantQuotientSnapshot) := by
  decide

/-- Kernel-checked target names for the R666 ledger. -/
theorem currentR666TargetInvariantQuotientTargetNames_eq_texStatus :
    currentR666TargetInvariantQuotientTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove targetInvariantExcessQuotient = bot, equivalently target_invariants <= span {j_q(h^4)}"
    ] := by
  rfl

def R666_substantiveTheoremCount : Nat := 6

end FrontC102_H8ResidualTargetInvariantQuotientEquivalence
end HCGapL4
end HodgeReduction
