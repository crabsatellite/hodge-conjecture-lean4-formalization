/-
# HC Gap L4 -- Front C101: target line as target-invariant line containment (R665).

R661's current target-side theorem is written as

  `trivialModulePart <= span {j_q(h^4)}`.

R554 already identifies `target_invariants = trivialModulePart` from the
Eisenstein/cuspidal trivial-module reduction.  This file removes that
remaining naming layer: the target-side live theorem can equivalently be
attacked as

  `target_invariants <= span {j_q(h^4)}`.

No theorem is closed here.  The point is to route the remaining target-side
work to the Matsushima target-invariant subspace itself, while preserving the
same exact-image and Cartan-to-compactDual source targets.
-/

import HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC101_H8ResidualTargetInvariantLineBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC97_H8ResidualCartanToCompactDualLine

section TargetInvariantLine

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

omit [CompactDualData A] [CartanCompactDualIso A]
  [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- **R665 substantive theorem (1/6)**: R554 rewrites the target generator
line theorem from the cuspidal trivial-module part to the Matsushima target
invariants. -/
theorem target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line :
    (MatsushimaData.target_invariants (A := A) (B := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) ↔
    (CuspidalCohomologyData.trivialModulePart (A := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) := by
  rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]

/-- The R665 equivalent residual package: same exact image and source carrier
as R661, but the target line is stated directly on target invariants. -/
structure EVIIH8ResidualTargetInvariantLineContract
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
  cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  target_invariants_le_h_pow_four_line :
    MatsushimaData.target_invariants (A := A) (B := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R665 substantive theorem (2/6)**: the R661 contract feeds the target
invariant-line spelling. -/
def targetInvariantLineContract_of_cartanToCompactDualLineContract
    (O : EVIIH8ResidualCartanToCompactDualLineContract A B) :
    EVIIH8ResidualTargetInvariantLineContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  target_invariants_le_h_pow_four_line :=
    (target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)).2 O.trivialModulePart_le_h_pow_four_line

/-- **R665 substantive theorem (3/6)**: the target-invariant-line spelling
recovers the R661 contract. -/
def cartanToCompactDualLineContract_of_targetInvariantLineContract
    (O : EVIIH8ResidualTargetInvariantLineContract A B) :
    EVIIH8ResidualCartanToCompactDualLineContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    (target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)).1 O.target_invariants_le_h_pow_four_line

/-- **R665 substantive theorem (4/6)**: at the inhabited-contract level,
R661's target line and the target-invariant line are the same residual
target. -/
theorem residual_cartanToCompactDualLine_nonempty_iff_targetInvariantLine_nonempty :
    Nonempty (EVIIH8ResidualCartanToCompactDualLineContract A B) ↔
      Nonempty (EVIIH8ResidualTargetInvariantLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineContract_of_cartanToCompactDualLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanToCompactDualLineContract_of_targetInvariantLineContract
            (A := A) (B := B) O)))

/-- **R665 substantive theorem (5/6)**: the target-invariant-line contract
still feeds the quotient-vanishing contract through the existing R661/R658
bridge. -/
def targetInvariantExcessQuotientContract_of_targetInvariantLineContract
    (O : EVIIH8ResidualTargetInvariantLineContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B :=
  targetInvariantExcessQuotientContract_of_cartanToCompactDualLineContract
    (A := A) (B := B)
    (cartanToCompactDualLineContract_of_targetInvariantLineContract
      (A := A) (B := B) O)

omit [MatsushimaSurjectivityData A B] in
/-- **R665 substantive theorem (6/6)**: the target-invariant-line spelling
also gives the source-H8 equality once the Cartan-to-compactDual carrier
direction is supplied. -/
theorem source_invariants_eq_H8_of_cartanH8_le_compactDual_and_targetInvariantLine
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (htarget_line :
      MatsushimaData.target_invariants (A := A) (B := B) ≤
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_cartanH8_le_compactDual_and_line
    (A := A) (B := B)
    hcartan
    ((target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)).1 htarget_line)

end TargetInvariantLine

/-- R665 target names for route summaries. -/
def currentR665TargetInvariantLineTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove CartanH8 <= compactDual",
  "prove target_invariants <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R665 target-invariant-line bridge. -/
structure R665TargetInvariantLineSnapshot where
  proofWorkObligationCount : Nat
  targetInvariantLineEquivalentToTrivialModuleLine : Bool
  targetInvariantLineContractEquivalentToR661Contract : Bool
  targetInvariantLineContractFeedsQuotientContract : Bool
  cartanContainmentPlusTargetInvariantLineGivesSourceH8 : Bool
  provesTargetInvariantLine : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R665 status: the target-side theorem is now exposed directly as
target-invariant line containment; it is not proved here. -/
def currentR665TargetInvariantLineSnapshot :
    R665TargetInvariantLineSnapshot where
  proofWorkObligationCount := currentR665TargetInvariantLineTargetNames.length
  targetInvariantLineEquivalentToTrivialModuleLine := true
  targetInvariantLineContractEquivalentToR661Contract := true
  targetInvariantLineContractFeedsQuotientContract := true
  cartanContainmentPlusTargetInvariantLineGivesSourceH8 := true
  provesTargetInvariantLine := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R665 ledger. -/
theorem currentR665TargetInvariantLineSnapshot_eq_texStatus :
    currentR665TargetInvariantLineSnapshot =
      ({ proofWorkObligationCount := 3
         targetInvariantLineEquivalentToTrivialModuleLine := true
         targetInvariantLineContractEquivalentToR661Contract := true
         targetInvariantLineContractFeedsQuotientContract := true
         cartanContainmentPlusTargetInvariantLineGivesSourceH8 := true
         provesTargetInvariantLine := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R665TargetInvariantLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R665 ledger. -/
theorem currentR665TargetInvariantLineTargetNames_eq_texStatus :
    currentR665TargetInvariantLineTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove CartanH8 <= compactDual",
      "prove target_invariants <= span {j_q(h^4)}"
    ] := by
  rfl

def R665_substantiveTheoremCount : Nat := 6

end FrontC101_H8ResidualTargetInvariantLineBridge
end HCGapL4
end HodgeReduction
