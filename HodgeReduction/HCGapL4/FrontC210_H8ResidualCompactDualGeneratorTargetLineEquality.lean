/-
# HC Gap L4 -- Front C210: compact-dual generator target-line equality (R775).

R774 exposes the non-exact carrier input as the concrete theorem
`h^4 in compactDual`.  That same generator membership already supplies the
target-nonzero certificate used by R766.  Consequently, once the R774
generator field is present, the scalar certificate is equivalent to the exact
target-line equality

  `target_invariants = span {j_q(h^4)}`.

This file records that equivalence and gives the current consumers in this
target-line-equality spelling.  It does not prove exact image, compact-dual
generator membership, target-line equality, scalar certificate, boundary data
unconditionally, or full Hodge closure.
-/

import HodgeReduction.HCGapL4.FrontC202_H8ResidualTargetNonzeroCertificate
import HodgeReduction.HCGapL4.FrontC204_H8ResidualThreeFieldScalarRoute
import HodgeReduction.HCGapL4.FrontC209_H8ResidualCompactDualGeneratorScalarCarrierClosure

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC210_H8ResidualCompactDualGeneratorTargetLineEquality

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC202_H8ResidualTargetNonzeroCertificate
open FrontC204_H8ResidualThreeFieldScalarRoute
open FrontC209_H8ResidualCompactDualGeneratorScalarCarrierClosure

section CompactDualGeneratorTargetLineEquality

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

/-- **R775 substantive theorem (1/7)**: the R774 compact-dual generator
membership supplies the R766 nonzero target certificate. -/
theorem targetInvariantNonzeroCertificate_nonempty_of_current_h_pow_four_mem_compactDual
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Nonempty (TargetInvariantNonzeroCertificate A B) :=
  targetInvariantNonzeroCertificate_nonempty_of_h_pow_four_mem_compactDual
    (A := A) (B := B) hh_compact

/-- **R775 substantive theorem (2/7)**: under compact-dual generator
membership, the scalar certificate upgrades target-line containment to exact
target-line equality. -/
theorem target_invariants_eq_h_pow_four_line_of_h_pow_four_mem_compactDual_scalarCertificate
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  exact
    (targetInvariantNonzeroCertificate_nonempty_of_current_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact).elim
      (fun N =>
        target_invariants_eq_h_pow_four_line_of_scalarCertificate_and_nonzero
          (A := A) (B := B) C N)

/-- **R775 substantive theorem (3/7)**: with compact-dual generator
membership in hand, scalar certificates and exact target-line equality are the
same target. -/
theorem targetInvariantLineScalarCertificate_nonempty_iff_target_invariants_eq_h_pow_four_line_of_h_pow_four_mem_compactDual
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Nonempty (TargetInvariantLineScalarCertificate A B) <->
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} :=
  Iff.intro
    (fun hcert =>
      hcert.elim (fun C =>
        target_invariants_eq_h_pow_four_line_of_h_pow_four_mem_compactDual_scalarCertificate
          (A := A) (B := B) hh_compact C))
    (fun heq =>
      Nonempty.intro
        (targetInvariantLineScalarCertificate_of_target_invariants_eq_h_pow_four_line
          (A := A) (B := B) heq))

/-- **R775 substantive theorem (4/7)**: the R774 generator field plus scalar
certificate gives the target generator itself. -/
theorem targetGenerator_mem_of_h_pow_four_mem_compactDual_scalarCertificate
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    (MatsushimaData.target_invariants (A := A) (B := B)).carrier
      (MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4)) := by
  exact
    (targetInvariantNonzeroCertificate_nonempty_of_current_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact).elim
      (fun N =>
        targetGenerator_mem_of_scalarCertificate_and_nonzero
          (A := A) (B := B) C N)

/-- **R775 substantive theorem (5/7)**: exact image, compact-dual generator
membership, and scalar certificate feed the exact target-line equality
contract. -/
def targetInvariantLineEqualityContract_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B :=
  targetInvariantLineEqualityContract_of_exactImage_sourceH8_scalarCertificate
    (A := A) (B := B)
    hexact
    (source_invariants_eq_H8_of_h_pow_four_mem_compactDual_scalarCertificate
      (A := A) (B := B) hh_compact C)
    C

/-- **R775 substantive theorem (6/7)**: the same three fields rebuild honest
boundary data through the target-line-equality route. -/
def matsushimaV56BoundaryData_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate
    (A := A) (B := B)
    hexact
    (source_invariants_eq_H8_of_h_pow_four_mem_compactDual_scalarCertificate
      (A := A) (B := B) hh_compact C)
    C

/-- **R775 substantive theorem (7/7)**: the R775 fields expose the target
boundary equality directly. -/
theorem target_eq_invariants_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (hexact : sourceInvariantExactImageTarget A B)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (C : TargetInvariantLineScalarCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_h_pow_four_mem_compactDual_scalarCertificate
    (A := A) (B := B) hexact hh_compact C).target_eq_invariants

end CompactDualGeneratorTargetLineEquality

/-- R775 target names for route summaries. -/
def currentR775CompactDualGeneratorTargetLineEqualityTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove h^4 in compactDual",
  "prove target_invariants = span {j_q(h^4)}"
]

/-- Machine-readable status for the R775 target-line equality bridge. -/
structure R775CompactDualGeneratorTargetLineEqualitySnapshot where
  proofWorkObligationCount : Nat
  compactDualGeneratorSuppliesTargetNonzero : Bool
  scalarCertificateEquivalentToTargetLineEqualityUnderGenerator : Bool
  generatorAndScalarGiveTargetGenerator : Bool
  threeFieldsFeedTargetLineEqualityContract : Bool
  threeFieldsRebuildBoundaryData : Bool
  exposesTargetBoundaryEquality : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCompactDualGeneratorMembership : Bool
  provesTargetLineEquality : Bool
  provesScalarCertificate : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R775 status: with the R774 compact-dual generator target present,
the scalar certificate can be attacked equivalently as exact target-line
equality. -/
def currentR775CompactDualGeneratorTargetLineEqualitySnapshot :
    R775CompactDualGeneratorTargetLineEqualitySnapshot where
  proofWorkObligationCount :=
    currentR775CompactDualGeneratorTargetLineEqualityTargetNames.length
  compactDualGeneratorSuppliesTargetNonzero := true
  scalarCertificateEquivalentToTargetLineEqualityUnderGenerator := true
  generatorAndScalarGiveTargetGenerator := true
  threeFieldsFeedTargetLineEqualityContract := true
  threeFieldsRebuildBoundaryData := true
  exposesTargetBoundaryEquality := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCompactDualGeneratorMembership := false
  provesTargetLineEquality := false
  provesScalarCertificate := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R775 bridge. -/
theorem currentR775CompactDualGeneratorTargetLineEqualitySnapshot_eq_texStatus :
    currentR775CompactDualGeneratorTargetLineEqualitySnapshot =
      ({ proofWorkObligationCount := 3
         compactDualGeneratorSuppliesTargetNonzero := true
         scalarCertificateEquivalentToTargetLineEqualityUnderGenerator := true
         generatorAndScalarGiveTargetGenerator := true
         threeFieldsFeedTargetLineEqualityContract := true
         threeFieldsRebuildBoundaryData := true
         exposesTargetBoundaryEquality := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCompactDualGeneratorMembership := false
         provesTargetLineEquality := false
         provesScalarCertificate := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R775CompactDualGeneratorTargetLineEqualitySnapshot) := by
  decide

/-- Kernel-checked target names for the R775 bridge. -/
theorem currentR775CompactDualGeneratorTargetLineEqualityTargetNames_eq_texStatus :
    currentR775CompactDualGeneratorTargetLineEqualityTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove h^4 in compactDual",
      "prove target_invariants = span {j_q(h^4)}"
    ] := by
  rfl

def R775_substantiveTheoremCount : Nat := 7

end FrontC210_H8ResidualCompactDualGeneratorTargetLineEquality
end HCGapL4
end HodgeReduction
