/-
# HC Gap L4 -- Front C203: boundary data from scalar certificate (R768).

R766/R767 leave three live fields in the preferred local route:

* exact image of source invariants;
* source-H8;
* the scalar-preimage certificate plus a nonzero target/trivial-module class.

This file proves that those fields rebuild the older R554
`MatsushimaV56BoundaryData`.  The source boundary equality comes from the
existing exact-image/source-H8 route; the target boundary equality comes from
the R766 scalar certificate and R767 nonzero bridge through the R669 line
equality contract.

No boundary data is asserted unconditionally.
-/

import HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence
import HodgeReduction.HCGapL4.FrontC202_H8ResidualTargetNonzeroCertificate

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC203_H8ResidualBoundaryDataFromScalarCertificate

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC109_H8ResidualBoundaryDataEquivalence
open FrontC201_H8ResidualTargetLineScalarCertificate
open FrontC202_H8ResidualTargetNonzeroCertificate

section BoundaryDataFromScalarCertificate

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

/-- **R768 substantive theorem (1/8)**: exact image, source-H8, a scalar
certificate, and a concrete nonzero target witness give the R669 line-equality
contract. -/
def targetInvariantLineEqualityContract_of_exactImage_sourceH8_scalarCertificate_nonzero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image := hexact
  source_invariants_eq_H8 := hsource_H8
  target_invariants_eq_h_pow_four_line :=
    target_invariants_eq_h_pow_four_line_of_scalarCertificate_and_nonzero
      (A := A) (B := B) C N

/-- **R768 substantive theorem (2/8)**: the same four fields rebuild honest
`MatsushimaV56BoundaryData` through the existing R673 boundary equivalence. -/
def matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate_nonzero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_targetInvariantLineEqualityContract
    (A := A) (B := B)
    (targetInvariantLineEqualityContract_of_exactImage_sourceH8_scalarCertificate_nonzero
      (A := A) (B := B) hexact hsource_H8 C N)

/-- **R768 substantive theorem (3/8)**: the R768 package exposes the source
boundary equality field directly. -/
theorem source_eq_compactDual_of_exactImage_sourceH8_scalarCertificate_nonzero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate_nonzero
    (A := A) (B := B) hexact hsource_H8 C N).source_eq_compactDual

/-- **R768 substantive theorem (4/8)**: the R768 package exposes the target
boundary equality field directly. -/
theorem target_eq_invariants_of_exactImage_sourceH8_scalarCertificate_nonzero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate_nonzero
    (A := A) (B := B) hexact hsource_H8 C N).target_eq_invariants

/-- **R768 substantive theorem (5/8)**: using the R767 trivial-module
nonzero witness surface, the R768 fields inhabit boundary data without
extracting a witness from `Prop` into data. -/
theorem boundaryData_nonempty_of_exactImage_sourceH8_scalarCertificate_trivialModulePartNonzero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (hnonzero :
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0)) :
    Nonempty (MatsushimaV56BoundaryData A B) := by
  cases
      targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
        (A := A) (B := B) hnonzero with
  | intro N =>
      exact
        Nonempty.intro
          (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate_nonzero
            (A := A) (B := B) hexact hsource_H8 C N)

/-- **R768 substantive theorem (6/8)**: finite-dimensional nonzero finrank of
`trivialModulePart` feeds the same boundary-data route. -/
theorem boundaryData_nonempty_of_exactImage_sourceH8_scalarCertificate_trivialModulePart_finrank_ne_zero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hnonzero :
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :
    Nonempty (MatsushimaV56BoundaryData A B) := by
  cases
      targetInvariantNonzeroCertificate_nonempty_of_trivialModulePart_finrank_ne_zero
        (A := A) (B := B) hfinite hnonzero with
  | intro N =>
      exact
        Nonempty.intro
          (matsushimaV56BoundaryData_of_exactImage_sourceH8_scalarCertificate_nonzero
            (A := A) (B := B) hexact hsource_H8 C N)

/-- **R768 substantive theorem (7/8)**: the trivial-module nonzero witness
version gives the target boundary equality as a `Prop` theorem. -/
theorem target_eq_invariants_of_exactImage_sourceH8_scalarCertificate_trivialModulePartNonzero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (hnonzero :
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0)) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  cases
      boundaryData_nonempty_of_exactImage_sourceH8_scalarCertificate_trivialModulePartNonzero
        (A := A) (B := B) hexact hsource_H8 C hnonzero with
  | intro D =>
      exact D.target_eq_invariants

/-- **R768 substantive theorem (8/8)**: the finite-rank nonzero version gives
the target boundary equality as a `Prop` theorem. -/
theorem target_eq_invariants_of_exactImage_sourceH8_scalarCertificate_trivialModulePart_finrank_ne_zero
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (C : TargetInvariantLineScalarCertificate A B)
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hnonzero :
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  cases
      boundaryData_nonempty_of_exactImage_sourceH8_scalarCertificate_trivialModulePart_finrank_ne_zero
        (A := A) (B := B) hexact hsource_H8 C hfinite hnonzero with
  | intro D =>
      exact D.target_eq_invariants

end BoundaryDataFromScalarCertificate

/-- R768 target names for route summaries. -/
def currentR768BoundaryDataFromScalarCertificateTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "construct target-line scalar certificate",
  "prove nonzero trivialModulePart witness or nonzero finrank"
]

/-- Machine-readable status for the R768 boundary-data bridge. -/
structure R768BoundaryDataFromScalarCertificateSnapshot where
  proofWorkObligationCount : Nat
  scalarCertificateNonzeroFeedsLineEqualityContract : Bool
  fieldsRebuildBoundaryData : Bool
  trivialModuleNonzeroFeedsBoundaryDataNonempty : Bool
  finrankNonzeroFeedsBoundaryDataNonempty : Bool
  exposesSourceBoundaryEquality : Bool
  exposesTargetBoundaryEquality : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesSourceH8 : Bool
  provesScalarCertificate : Bool
  provesNonzeroTrivialModulePart : Bool
  provesBoundaryDataUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R768 status: the target boundary equality is now fed by the same
scalar-certificate/nonzero surface as the target-line route, once exact image
and source-H8 are available. -/
def currentR768BoundaryDataFromScalarCertificateSnapshot :
    R768BoundaryDataFromScalarCertificateSnapshot where
  proofWorkObligationCount :=
    currentR768BoundaryDataFromScalarCertificateTargetNames.length
  scalarCertificateNonzeroFeedsLineEqualityContract := true
  fieldsRebuildBoundaryData := true
  trivialModuleNonzeroFeedsBoundaryDataNonempty := true
  finrankNonzeroFeedsBoundaryDataNonempty := true
  exposesSourceBoundaryEquality := true
  exposesTargetBoundaryEquality := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesSourceH8 := false
  provesScalarCertificate := false
  provesNonzeroTrivialModulePart := false
  provesBoundaryDataUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R768 bridge. -/
theorem currentR768BoundaryDataFromScalarCertificateSnapshot_eq_texStatus :
    currentR768BoundaryDataFromScalarCertificateSnapshot =
      ({ proofWorkObligationCount := 4
         scalarCertificateNonzeroFeedsLineEqualityContract := true
         fieldsRebuildBoundaryData := true
         trivialModuleNonzeroFeedsBoundaryDataNonempty := true
         finrankNonzeroFeedsBoundaryDataNonempty := true
         exposesSourceBoundaryEquality := true
         exposesTargetBoundaryEquality := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesSourceH8 := false
         provesScalarCertificate := false
         provesNonzeroTrivialModulePart := false
         provesBoundaryDataUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R768BoundaryDataFromScalarCertificateSnapshot) := by
  decide

/-- Kernel-checked target names for the R768 bridge. -/
theorem currentR768BoundaryDataFromScalarCertificateTargetNames_eq_texStatus :
    currentR768BoundaryDataFromScalarCertificateTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "construct target-line scalar certificate",
      "prove nonzero trivialModulePart witness or nonzero finrank"
    ] := by
  rfl

def R768_substantiveTheoremCount : Nat := 8

end FrontC203_H8ResidualBoundaryDataFromScalarCertificate
end HCGapL4
end HodgeReduction
