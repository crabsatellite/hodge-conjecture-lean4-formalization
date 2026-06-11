/-
# HC Gap L4 -- Front C211: compact-dual target-line unified surfaces (R776).

R775 made the current target-side field exact:

  target_invariants = span {j_q(h^4)}

under the concrete compact-dual generator target `h^4 in compactDual`.
Older fronts already showed that, once source-H8 is present, this same target
can be attacked as quotient vanishing or as a finite expected-Betti upper
bound.

This file closes the bookkeeping gap between those routes.  The current
three-field contract

* exact image of source invariants;
* `h^4 in compactDual`;
* exact target-line equality

is kernel-equivalent to the older target-line, quotient-vanishing, and finite
upper-bound contracts.  It does not prove exact image, compact-dual generator
membership, target-line equality, quotient vanishing, the upper bound,
boundary data unconditionally, or full Hodge closure.
-/

import HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound
import HodgeReduction.HCGapL4.FrontC210_H8ResidualCompactDualGeneratorTargetLineEquality

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC211_H8ResidualCompactDualTargetLineUnifiedSurfaces

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC107_H8ResidualLineEqualityFiniteUpperBound
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC204_H8ResidualThreeFieldScalarRoute
open FrontC209_H8ResidualCompactDualGeneratorScalarCarrierClosure
open FrontC210_H8ResidualCompactDualGeneratorTargetLineEquality

section CompactDualTargetLineUnifiedSurfaces

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

/-- **R776 substantive theorem (1/11)**: source-H8 supplies the concrete
compact-dual generator membership through the built-in Matsushima compact-dual
comparison. -/
theorem h_pow_four_mem_compactDual_of_sourceH8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]
  exact h_pow_four_mem_source_invariants_of_sourceH8
    (A := A) (B := B) hsource_H8

/-- **R776 substantive theorem (2/11)**: in the R775 spelling, compact-dual
generator membership plus exact target-line equality recovers source-H8.  The
target-line equality is consumed through the R766 scalar-certificate form, so
this is not a new premise. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_compactDual_targetLineEquality
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_compactDual_scalarCertificate
    (A := A) (B := B)
    hh_compact
    (targetInvariantLineScalarCertificate_of_target_invariants_eq_h_pow_four_line
      (A := A) (B := B) hline)

/-- The R776 compact-dual target-line contract.  This is the R775 preferred
frontier as an explicit structure so it can be compared with older quotient
and finite upper-bound ledgers. -/
structure EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract
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
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  target_invariants_eq_h_pow_four_line :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R776 substantive theorem (3/11)**: the R776 compact-dual target-line
contract gives the older R669 source-H8 target-line contract. -/
def targetInvariantLineEqualityContract_of_compactDualGeneratorTargetLineEqualityContract
    (O : EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_h_pow_four_mem_compactDual_targetLineEquality
      (A := A) (B := B)
      O.h_pow_four_mem_compactDual
      O.target_invariants_eq_h_pow_four_line
  target_invariants_eq_h_pow_four_line :=
    O.target_invariants_eq_h_pow_four_line

/-- **R776 substantive theorem (4/11)**: the older R669 target-line contract
recovers the R776 compact-dual generator field from source-H8. -/
def compactDualGeneratorTargetLineEqualityContract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  h_pow_four_mem_compactDual :=
    h_pow_four_mem_compactDual_of_sourceH8
      (A := A) (B := B)
      O.source_invariants_eq_H8
  target_invariants_eq_h_pow_four_line :=
    O.target_invariants_eq_h_pow_four_line

/-- **R776 substantive theorem (5/11)**: the R776 compact-dual target-line
contract and the R669 target-line contract are the same inhabited residual
ledger. -/
theorem residual_compactDualGeneratorTargetLineEquality_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_compactDualGeneratorTargetLineEqualityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualGeneratorTargetLineEqualityContract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))

/-- **R776 substantive theorem (6/11)**: the R776 contract feeds the older
quotient-vanishing contract. -/
def targetInvariantExcessQuotientContract_of_compactDualGeneratorTargetLineEqualityContract
    (O : EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B :=
  targetInvariantExcessQuotientContract_of_targetInvariantLineEqualityContract
    (A := A) (B := B)
    (targetInvariantLineEqualityContract_of_compactDualGeneratorTargetLineEqualityContract
      (A := A) (B := B) O)

/-- **R776 substantive theorem (7/11)**: quotient vanishing recovers the
R776 compact-dual target-line contract through the older R669 bridge. -/
def compactDualGeneratorTargetLineEqualityContract_of_targetInvariantExcessQuotientContract
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B :=
  compactDualGeneratorTargetLineEqualityContract_of_targetInvariantLineEqualityContract
    (A := A) (B := B)
    (targetInvariantLineEqualityContract_of_targetInvariantExcessQuotientContract
      (A := A) (B := B) O)

/-- **R776 substantive theorem (8/11)**: the R776 compact-dual target-line
contract and the R641 quotient-vanishing contract are equivalent as inhabited
residual ledgers. -/
theorem residual_compactDualGeneratorTargetLineEquality_nonempty_iff_targetInvariantExcessQuotient_nonempty :
    Nonempty (EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantExcessQuotientContract_of_compactDualGeneratorTargetLineEqualityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualGeneratorTargetLineEqualityContract_of_targetInvariantExcessQuotientContract
            (A := A) (B := B) O)))

/-- **R776 substantive theorem (9/11)**: the R776 contract feeds the bundled
finite expected-Betti upper-bound contract. -/
def finiteUpperBoundContract_of_compactDualGeneratorTargetLineEqualityContract
    (O : EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B) :
    EVIIH8ResidualFiniteUpperBoundContract A B :=
  finiteUpperBoundContract_of_targetInvariantLineEqualityContract
    (A := A) (B := B)
    (targetInvariantLineEqualityContract_of_compactDualGeneratorTargetLineEqualityContract
      (A := A) (B := B) O)

/-- **R776 substantive theorem (10/11)**: the bundled finite upper-bound
contract recovers the R776 compact-dual target-line contract. -/
def compactDualGeneratorTargetLineEqualityContract_of_finiteUpperBoundContract
    (O : EVIIH8ResidualFiniteUpperBoundContract A B) :
    EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B :=
  compactDualGeneratorTargetLineEqualityContract_of_targetInvariantLineEqualityContract
    (A := A) (B := B)
    (targetInvariantLineEqualityContract_of_finiteUpperBoundContract
      (A := A) (B := B) O)

/-- **R776 substantive theorem (11/11)**: the R776 compact-dual target-line
contract and the R671 finite upper-bound contract are equivalent as inhabited
residual ledgers. -/
theorem residual_compactDualGeneratorTargetLineEquality_nonempty_iff_finiteUpperBound_nonempty :
    Nonempty (EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B) <->
      Nonempty (EVIIH8ResidualFiniteUpperBoundContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteUpperBoundContract_of_compactDualGeneratorTargetLineEqualityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (compactDualGeneratorTargetLineEqualityContract_of_finiteUpperBoundContract
            (A := A) (B := B) O)))

end CompactDualTargetLineUnifiedSurfaces

/-- R776 equivalent target names for route summaries. -/
def currentR776CompactDualTargetLineUnifiedTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove h^4 in compactDual",
  "prove the target side as target-line equality, quotient vanishing, or finite expected-Betti upper bound"
]

/-- Machine-readable status for the R776 unified target-side surfaces. -/
structure R776CompactDualTargetLineUnifiedSnapshot where
  proofWorkObligationCount : Nat
  sourceH8SuppliesCompactDualGenerator : Bool
  compactDualGeneratorAndTargetLineRecoverSourceH8 : Bool
  compactDualTargetLineEquivalentToOldLineContract : Bool
  compactDualTargetLineEquivalentToQuotientContract : Bool
  compactDualTargetLineEquivalentToFiniteUpperBoundContract : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCompactDualGeneratorMembership : Bool
  provesTargetLineEquality : Bool
  provesQuotientVanishing : Bool
  provesFiniteUpperBound : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R776 status: the R775 target-line frontier is now connected to
the quotient and finite upper-bound attack surfaces without adding a new
assumption or claiming closure. -/
def currentR776CompactDualTargetLineUnifiedSnapshot :
    R776CompactDualTargetLineUnifiedSnapshot where
  proofWorkObligationCount :=
    currentR776CompactDualTargetLineUnifiedTargetNames.length
  sourceH8SuppliesCompactDualGenerator := true
  compactDualGeneratorAndTargetLineRecoverSourceH8 := true
  compactDualTargetLineEquivalentToOldLineContract := true
  compactDualTargetLineEquivalentToQuotientContract := true
  compactDualTargetLineEquivalentToFiniteUpperBoundContract := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCompactDualGeneratorMembership := false
  provesTargetLineEquality := false
  provesQuotientVanishing := false
  provesFiniteUpperBound := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R776 bridge. -/
theorem currentR776CompactDualTargetLineUnifiedSnapshot_eq_texStatus :
    currentR776CompactDualTargetLineUnifiedSnapshot =
      ({ proofWorkObligationCount := 3
         sourceH8SuppliesCompactDualGenerator := true
         compactDualGeneratorAndTargetLineRecoverSourceH8 := true
         compactDualTargetLineEquivalentToOldLineContract := true
         compactDualTargetLineEquivalentToQuotientContract := true
         compactDualTargetLineEquivalentToFiniteUpperBoundContract := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCompactDualGeneratorMembership := false
         provesTargetLineEquality := false
         provesQuotientVanishing := false
         provesFiniteUpperBound := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R776CompactDualTargetLineUnifiedSnapshot) := by
  decide

/-- Kernel-checked target names for the R776 bridge. -/
theorem currentR776CompactDualTargetLineUnifiedTargetNames_eq_texStatus :
    currentR776CompactDualTargetLineUnifiedTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove h^4 in compactDual",
      "prove the target side as target-line equality, quotient vanishing, or finite expected-Betti upper bound"
    ] := by
  rfl

def R776_substantiveTheoremCount : Nat := 11

end FrontC211_H8ResidualCompactDualTargetLineUnifiedSurfaces
end HCGapL4
end HodgeReduction
