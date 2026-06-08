/-
# HC Gap L4 -- Front C201: target-line scalar certificate (R766).

R765 reduces the target-generator side to two target-side facts:

* `target_invariants <= span {j_q(h^4)}`;
* `target_invariants` has a nonzero class.

This file gives the line-containment fact a constructive form.  A target-line
certificate is a pointwise scalar-preimage theorem: every target-invariant
class is a rational multiple of the explicit class `j_q(h^4)`.  The certificate
is kernel-equivalent to the submodule containment, and together with a nonzero
target class it feeds the R765 compact-dual/H8 consumer.

No target-line theorem, nonvanishing theorem, boundary theorem, or Hodge
conjecture closure is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality
import HodgeReduction.HCGapL4.FrontC200_H8ResidualTargetLineNonzeroGenerator

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC201_H8ResidualTargetLineScalarCertificate

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC101_H8ResidualTargetInvariantLineBridge
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC200_H8ResidualTargetLineNonzeroGenerator

section TargetLineScalarCertificate

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

/-- The constructive R766 certificate for the R765 target-line containment:
each target-invariant class is a rational scalar multiple of `j_q(h^4)`. -/
structure TargetInvariantLineScalarCertificate
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
  scalar_preimage :
    forall beta : B,
      (MatsushimaData.target_invariants (A := A) (B := B)).carrier beta ->
        Exists fun r : Rat =>
          r •
              MatsushimaData.j_q (A := A) (B := B)
                ((KaehlerClass.h : A) ^ 4) =
            beta

/-- A concrete nonzero witness for the target-invariant subspace. -/
structure TargetInvariantNonzeroCertificate
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
  witness : B
  witness_mem :
    (MatsushimaData.target_invariants (A := A) (B := B)).carrier witness
  witness_ne_zero : Not (witness = 0)

/-- **R766 substantive theorem (1/8)**: target-line containment gives the
pointwise scalar-preimage certificate. -/
def targetInvariantLineScalarCertificate_of_target_invariants_le_h_pow_four_line
    (hline :
      LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    TargetInvariantLineScalarCertificate A B where
  scalar_preimage := by
    intro beta hbeta
    have hmem :
        beta ∈
          Submodule.span Rat
            {MatsushimaData.j_q (A := A) (B := B)
              ((KaehlerClass.h : A) ^ 4)} :=
      hline hbeta
    simpa using (Submodule.mem_span_singleton.mp hmem)

/-- **R766 substantive theorem (2/8)**: the pointwise scalar-preimage
certificate gives target-line containment. -/
theorem target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
    (C : TargetInvariantLineScalarCertificate A B) :
    LE.le (MatsushimaData.target_invariants (A := A) (B := B))
      (Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}) := by
  intro beta hbeta
  rw [Submodule.mem_span_singleton]
  exact C.scalar_preimage beta hbeta

/-- **R766 substantive theorem (3/8)**: target-line containment is exactly
the pointwise scalar-preimage certificate. -/
theorem target_invariants_le_h_pow_four_line_iff_targetInvariantLineScalarCertificate :
    (LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) <->
      Nonempty (TargetInvariantLineScalarCertificate A B) :=
  Iff.intro
    (fun hline =>
      Nonempty.intro
        (targetInvariantLineScalarCertificate_of_target_invariants_le_h_pow_four_line
          (A := A) (B := B) hline))
    (fun hcert =>
      hcert.elim (fun C =>
        target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
          (A := A) (B := B) C))

/-- **R766 substantive theorem (4/8)**: package a target nonzero witness as
the existential form consumed by R765. -/
theorem exists_nonzero_target_invariants_of_targetInvariantNonzeroCertificate
    (N : TargetInvariantNonzeroCertificate A B) :
    Exists fun beta : B =>
      (MatsushimaData.target_invariants (A := A) (B := B)).carrier beta /\
        Not (beta = 0) :=
  Exists.intro N.witness (And.intro N.witness_mem N.witness_ne_zero)

/-- **R766 substantive theorem (5/8)**: scalar certificate plus target
nonzero gives exact equality with the explicit target line. -/
theorem target_invariants_eq_h_pow_four_line_of_scalarCertificate_and_nonzero
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  have hline :
      LE.le (MatsushimaData.target_invariants (A := A) (B := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :=
    target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
      (A := A) (B := B) C
  apply le_antisymm hline
  apply Submodule.span_le.mpr
  intro beta hbeta
  rw [Set.mem_singleton_iff] at hbeta
  rw [hbeta]
  exact
    targetGenerator_mem_of_target_invariants_le_line_and_exists_nonzero
      (A := A) (B := B)
      hline
      (exists_nonzero_target_invariants_of_targetInvariantNonzeroCertificate
        (A := A) (B := B) N)

/-- **R766 substantive theorem (6/8)**: scalar certificate plus target
nonzero gives the target generator, matching the R765 consumer surface. -/
theorem targetGenerator_mem_of_scalarCertificate_and_nonzero
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    (MatsushimaData.target_invariants (A := A) (B := B)).carrier
      (MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4)) :=
  targetGenerator_mem_of_target_invariants_le_line_and_exists_nonzero
    (A := A) (B := B)
    (target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
      (A := A) (B := B) C)
    (exists_nonzero_target_invariants_of_targetInvariantNonzeroCertificate
      (A := A) (B := B) N)

/-- **R766 substantive theorem (7/8)**: boundary data, scalar certificate,
and target nonzero close the visible compact-dual/H8 target. -/
theorem compactDual_eq_H8_of_boundaryData_scalarCertificate_and_nonzero
    (D : MatsushimaV56BoundaryData A B)
    (C : TargetInvariantLineScalarCertificate A B)
    (N : TargetInvariantNonzeroCertificate A B) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  compactDual_eq_H8_of_boundaryData_targetLine_and_targetNonzero
    (A := A) (B := B) D
    (target_invariants_le_h_pow_four_line_of_targetInvariantLineScalarCertificate
      (A := A) (B := B) C)
    (exists_nonzero_target_invariants_of_targetInvariantNonzeroCertificate
      (A := A) (B := B) N)

/-- **R766 substantive theorem (8/8)**: exact target-line equality supplies
the scalar certificate, so R669 can feed the R766 constructive target. -/
def targetInvariantLineScalarCertificate_of_target_invariants_eq_h_pow_four_line
    (heq :
      MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    TargetInvariantLineScalarCertificate A B :=
  targetInvariantLineScalarCertificate_of_target_invariants_le_h_pow_four_line
    (A := A) (B := B)
    (by
      intro beta hbeta
      rw [heq] at hbeta
      exact hbeta)

end TargetLineScalarCertificate

/-- R766 target names for route summaries. -/
def currentR766TargetLineScalarCertificateTargetNames : List String := [
  "construct a scalar preimage for each target-invariant class",
  "construct a nonzero target-invariant class",
  "prove MatsushimaV56BoundaryData"
]

/-- Machine-readable status for the R766 scalar-certificate bridge. -/
structure R766TargetLineScalarCertificateSnapshot where
  proofWorkObligationCount : Nat
  scalarCertificateEquivalentToTargetLineContainment : Bool
  scalarCertificateAndNonzeroGiveTargetLineEquality : Bool
  scalarCertificateAndNonzeroGiveTargetGenerator : Bool
  scalarCertificateAndNonzeroFeedCompactDualH8 : Bool
  acceptsExactTargetLineEquality : Bool
  provesScalarCertificate : Bool
  provesTargetNonzero : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R766 status: the target-line containment is now a constructive
scalar-preimage certificate, ready for a representation-theoretic proof. -/
def currentR766TargetLineScalarCertificateSnapshot :
    R766TargetLineScalarCertificateSnapshot where
  proofWorkObligationCount := currentR766TargetLineScalarCertificateTargetNames.length
  scalarCertificateEquivalentToTargetLineContainment := true
  scalarCertificateAndNonzeroGiveTargetLineEquality := true
  scalarCertificateAndNonzeroGiveTargetGenerator := true
  scalarCertificateAndNonzeroFeedCompactDualH8 := true
  acceptsExactTargetLineEquality := true
  provesScalarCertificate := false
  provesTargetNonzero := false
  provesBoundaryData := false
  provesCompactDualH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R766 scalar-certificate bridge. -/
theorem currentR766TargetLineScalarCertificateSnapshot_eq_texStatus :
    currentR766TargetLineScalarCertificateSnapshot =
      ({ proofWorkObligationCount := 3
         scalarCertificateEquivalentToTargetLineContainment := true
         scalarCertificateAndNonzeroGiveTargetLineEquality := true
         scalarCertificateAndNonzeroGiveTargetGenerator := true
         scalarCertificateAndNonzeroFeedCompactDualH8 := true
         acceptsExactTargetLineEquality := true
         provesScalarCertificate := false
         provesTargetNonzero := false
         provesBoundaryData := false
         provesCompactDualH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R766TargetLineScalarCertificateSnapshot) := by
  decide

/-- Kernel-checked target names for the R766 bridge. -/
theorem currentR766TargetLineScalarCertificateTargetNames_eq_texStatus :
    currentR766TargetLineScalarCertificateTargetNames = [
      "construct a scalar preimage for each target-invariant class",
      "construct a nonzero target-invariant class",
      "prove MatsushimaV56BoundaryData"
    ] := by
  rfl

def R766_substantiveTheoremCount : Nat := 8

end FrontC201_H8ResidualTargetLineScalarCertificate
end HCGapL4
end HodgeReduction
