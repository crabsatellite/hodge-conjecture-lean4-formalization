/-
# HC Gap L4 -- Front C202: target nonzero certificate (R767).

R766 uses a concrete `TargetInvariantNonzeroCertificate`.  This file connects
that certificate back to the existing R753 nonvanishing routes:

* a nonzero class in `trivialModulePart`;
* nonzero `finrank trivialModulePart` with an explicit finite-dimensional
  witness;
* source or compact-dual generator placement for `h^4`.

Thus the R766 target-nonzero field is not a new abstract assumption surface.
It is the existing R753 target-nonvanishing problem, restated in the exact
certificate form consumed by the scalar-certificate route.
-/

import HodgeReduction.HCGapL4.FrontC188_H8ResidualTargetNonzeroFromCompactDual
import HodgeReduction.HCGapL4.FrontC201_H8ResidualTargetLineScalarCertificate

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC202_H8ResidualTargetNonzeroCertificate

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC188_H8ResidualTargetNonzeroFromCompactDual
open FrontC201_H8ResidualTargetLineScalarCertificate

section TargetNonzeroCertificate

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

/-- **R767 substantive theorem (1/9)**: a nonzero trivial-module class is
exactly an inhabited concrete nonzero target-invariant certificate needed by
R766.  The result is `Nonempty`, so no witness is extracted from `Prop` into
computational data. -/
theorem targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
    (hnonzero :
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0)) :
    Nonempty (TargetInvariantNonzeroCertificate A B) := by
  obtain ⟨beta, hbeta_trivial, hbeta_ne⟩ := hnonzero
  exact
    Nonempty.intro
      { witness := beta
        witness_mem := by
          simpa [target_invariants_eq_trivialModulePart (A := A) (B := B)]
            using hbeta_trivial
        witness_ne_zero := hbeta_ne }

/-- **R767 substantive theorem (2/9)**: the R766 nonzero certificate recovers
the older nonzero trivial-module witness. -/
theorem exists_nonzero_trivialModulePart_class_of_targetInvariantNonzeroCertificate
    (N : TargetInvariantNonzeroCertificate A B) :
    Exists fun beta : B =>
      (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
        Not (beta = 0) :=
  Exists.intro N.witness
    (And.intro
      (by
        simpa [target_invariants_eq_trivialModulePart (A := A) (B := B)]
          using N.witness_mem)
      N.witness_ne_zero)

/-- **R767 substantive theorem (3/9)**: target-invariant nonzero
certificates and nonzero trivial-module witnesses are the same inhabited
target. -/
theorem targetInvariantNonzeroCertificate_nonempty_iff_exists_nonzero_trivialModulePart_class :
    Nonempty (TargetInvariantNonzeroCertificate A B) <->
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0) :=
  Iff.intro
    (fun hcert =>
      hcert.elim (fun N =>
        exists_nonzero_trivialModulePart_class_of_targetInvariantNonzeroCertificate
          (A := A) (B := B) N))
    (fun hnonzero =>
      targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
        (A := A) (B := B) hnonzero)

/-- **R767 substantive theorem (4/9)**: finite-dimensional nonzero finrank
for `trivialModulePart` supplies an inhabited R766 target-nonzero
certificate. -/
theorem targetInvariantNonzeroCertificate_nonempty_of_trivialModulePart_finrank_ne_zero
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hnonzero :
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :
    Nonempty (TargetInvariantNonzeroCertificate A B) :=
  targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
    (A := A) (B := B)
    (exists_nonzero_trivialModulePart_class_of_finrank_ne_zero
      (B := B) hfinite hnonzero)

/-- **R767 substantive theorem (5/9)**: source generator membership gives an
inhabited R766 target-nonzero certificate. -/
theorem targetInvariantNonzeroCertificate_nonempty_of_h_pow_four_mem_source
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Nonempty (TargetInvariantNonzeroCertificate A B) :=
  targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
    (A := A) (B := B)
    (exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_source
      (A := A) (B := B) hh_source)

/-- **R767 substantive theorem (6/9)**: compact-dual generator membership gives
an inhabited R766 target-nonzero certificate through the existing
compact/source bridge. -/
theorem targetInvariantNonzeroCertificate_nonempty_of_h_pow_four_mem_compactDual
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Nonempty (TargetInvariantNonzeroCertificate A B) :=
  targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
    (A := A) (B := B)
    (exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)

/-- **R767 substantive theorem (7/9)**: `compactDual = H8` supplies an inhabited
R766 target-nonzero certificate.  This is a consumer form, not a suggested
non-circular proof of `compactDual = H8`. -/
theorem targetInvariantNonzeroCertificate_nonempty_of_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Nonempty (TargetInvariantNonzeroCertificate A B) :=
  targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
    (A := A) (B := B)
    (exists_nonzero_trivialModulePart_class_of_compactDual_eq_H8
      (A := A) (B := B) hcompact)

/-- **R767 substantive theorem (8/9)**: R766 can consume the older
trivial-module nonzero witness directly. -/
theorem compactDual_eq_H8_of_boundaryData_scalarCertificate_and_trivialModulePartNonzero
    (D : MatsushimaV56BoundaryData A B)
    (C : TargetInvariantLineScalarCertificate A B)
    (hnonzero :
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  obtain ⟨N⟩ :=
    targetInvariantNonzeroCertificate_nonempty_of_exists_nonzero_trivialModulePart_class
      (A := A) (B := B) hnonzero
  exact
    compactDual_eq_H8_of_boundaryData_scalarCertificate_and_nonzero
      (A := A) (B := B) D C N

/-- **R767 substantive theorem (9/9)**: R766 can consume finite-dimensional
nonzero `trivialModulePart` finrank directly. -/
theorem compactDual_eq_H8_of_boundaryData_scalarCertificate_and_trivialModulePart_finrank_ne_zero
    (D : MatsushimaV56BoundaryData A B)
    (C : TargetInvariantLineScalarCertificate A B)
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hnonzero :
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  obtain ⟨N⟩ :=
    targetInvariantNonzeroCertificate_nonempty_of_trivialModulePart_finrank_ne_zero
      (A := A) (B := B) hfinite hnonzero
  exact
    compactDual_eq_H8_of_boundaryData_scalarCertificate_and_nonzero
      (A := A) (B := B) D C N

end TargetNonzeroCertificate

/-- R767 target names for route summaries. -/
def currentR767TargetNonzeroCertificateTargetNames : List String := [
  "construct a scalar preimage for each target-invariant class",
  "prove nonzero trivialModulePart witness or nonzero finrank",
  "prove MatsushimaV56BoundaryData"
]

/-- Machine-readable status for the R767 target-nonzero certificate bridge. -/
structure R767TargetNonzeroCertificateSnapshot where
  proofWorkObligationCount : Nat
  targetNonzeroEquivalentToTrivialModuleNonzero : Bool
  finiteNonzeroFinrankFeedsTargetNonzero : Bool
  sourceGeneratorFeedsTargetNonzero : Bool
  compactGeneratorFeedsTargetNonzero : Bool
  compactDualH8FeedsTargetNonzero : Bool
  trivialModuleNonzeroFeedsR766Consumer : Bool
  finrankNonzeroFeedsR766Consumer : Bool
  provesScalarCertificate : Bool
  provesTargetNonzero : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R767 status: the R766 target-nonzero field has been identified
with existing R753 nonvanishing surfaces. -/
def currentR767TargetNonzeroCertificateSnapshot :
    R767TargetNonzeroCertificateSnapshot where
  proofWorkObligationCount := currentR767TargetNonzeroCertificateTargetNames.length
  targetNonzeroEquivalentToTrivialModuleNonzero := true
  finiteNonzeroFinrankFeedsTargetNonzero := true
  sourceGeneratorFeedsTargetNonzero := true
  compactGeneratorFeedsTargetNonzero := true
  compactDualH8FeedsTargetNonzero := true
  trivialModuleNonzeroFeedsR766Consumer := true
  finrankNonzeroFeedsR766Consumer := true
  provesScalarCertificate := false
  provesTargetNonzero := false
  provesBoundaryData := false
  provesCompactDualH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R767 target-nonzero bridge. -/
theorem currentR767TargetNonzeroCertificateSnapshot_eq_texStatus :
    currentR767TargetNonzeroCertificateSnapshot =
      ({ proofWorkObligationCount := 3
         targetNonzeroEquivalentToTrivialModuleNonzero := true
         finiteNonzeroFinrankFeedsTargetNonzero := true
         sourceGeneratorFeedsTargetNonzero := true
         compactGeneratorFeedsTargetNonzero := true
         compactDualH8FeedsTargetNonzero := true
         trivialModuleNonzeroFeedsR766Consumer := true
         finrankNonzeroFeedsR766Consumer := true
         provesScalarCertificate := false
         provesTargetNonzero := false
         provesBoundaryData := false
         provesCompactDualH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R767TargetNonzeroCertificateSnapshot) := by
  decide

/-- Kernel-checked target names for the R767 bridge. -/
theorem currentR767TargetNonzeroCertificateTargetNames_eq_texStatus :
    currentR767TargetNonzeroCertificateTargetNames = [
      "construct a scalar preimage for each target-invariant class",
      "prove nonzero trivialModulePart witness or nonzero finrank",
      "prove MatsushimaV56BoundaryData"
    ] := by
  rfl

def R767_substantiveTheoremCount : Nat := 9

end FrontC202_H8ResidualTargetNonzeroCertificate
end HCGapL4
end HodgeReduction
