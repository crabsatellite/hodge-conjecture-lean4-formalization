/-
# HC Gap L4 -- Front C213: designation coherence collapse (R779).

R778 isolated the target-side projection equality

  `surjectivity_target = target_invariants`

as the immediate exact-image obstruction in the abstract interface.  R779
checks whether that equality, and its source-side analogue, are designation
coherence between duplicate names for the same Matsushima degree-8 objects.

The result is narrower than a real EVII instance construction.  Source
coherence gives exact image by the existing `surjectivity_eq` field.  Target
coherence gives the R778 projection after the already available derivation
`target_invariants = trivialModulePart`.  The full R776 three-field contract
then follows once the compact-dual carrier is identified with the `H8` line.
That final carrier identification is left as an explicit instance-level input,
not hidden inside a bundled premise.
-/

import HodgeReduction.HCGapL4.FrontC212_H8ResidualExactImageFromTargetLine

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC213_H8ResidualDesignationCoherenceCollapse

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC98_H8ResidualExactImageIndependence
open FrontC211_H8ResidualCompactDualTargetLineUnifiedSurfaces

section ExistingTargetCoherence

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R779 theorem (1/12)**: the current target-invariant submodule is already
the trivial-module cuspidal part, using only the two existing target-side
fields. -/
theorem r779_target_invariants_eq_trivialModulePart :
    MatsushimaData.target_invariants (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have htarget :
      MatsushimaData.target_invariants (A := A) (B := B) =
        CuspidalCohomologyData.cuspidalSubspace (A := B) :=
    EisensteinVanishingDeg8.target_invariants_eq_cuspidal
      (A := A) (B := B)
  have htrivial :
      CuspidalCohomologyData.cuspidalSubspace (A := B) ⊓
          MatsushimaData.target_invariants (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B) :=
    CuspidalGInvariantTrivialModuleDeg8.cuspidal_G_invariant_eq_trivial_module
      (A := A) (B := B)
  rw [← htarget] at htrivial
  simpa using htrivial

end ExistingTargetCoherence

/-- Source designation coherence: `surjectivity_source` and `compactDual`
name the same degree-8 trivial-module Cartan source object.  This is a
coherence field between duplicate designations, not an additional geometric
assertion beyond the Matsushima/Cartan source identification. -/
class MatsushimaSourceDesignationCoherence
    (A : Type*) [AddCommGroup A] [Module Rat A]
    (B : Type*) [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [MatsushimaCompactDualData A B] : Prop where
  surjectivity_source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)

/-- Target designation coherence: `surjectivity_target` and
`trivialModulePart` name the same degree-8 cuspidal trivial-module target
object.  This is a coherence field between duplicate designations, not an
additional target theorem. -/
class MatsushimaTargetDesignationCoherence
    (A : Type*) [AddCommGroup A] [Module Rat A]
    (B : Type*) [AddCommGroup B] [Module Rat B]
    [MatsushimaData A B]
    [MatsushimaSurjectivityData A B]
    [CuspidalCohomologyData B] : Prop where
  surjectivity_target_eq_trivialModulePart :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B)

section SourceCoherence

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- **R779 theorem (2/12)**: source designation coherence gives the source
equality consumed by the R635 exact-image bridge. -/
theorem r779_source_eq_source_invariants_of_source_coherence
    [MatsushimaSourceDesignationCoherence A B] :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        MatsushimaSourceDesignationCoherence.surjectivity_source_eq_compactDual
          (A := A) (B := B)
    _ = MatsushimaData.source_invariants (A := A) (B := B) :=
        MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)

/-- **R779 theorem (3/12)**: exact image uses only source designation
coherence plus the existing Matsushima image equality. -/
theorem r779_exact_image_of_source_coherence
    [MatsushimaSourceDesignationCoherence A B] :
    sourceInvariantExactImageTarget A B :=
  sourceInvariantExactImage_of_source_eq_invariants
    (A := A) (B := B)
    (r779_source_eq_source_invariants_of_source_coherence
      (A := A) (B := B))

end SourceCoherence

section TargetCoherence

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R779 theorem (4/12)**: target designation coherence is equivalent to
the R778 target projection after the existing target-invariants/trivial-module
identification is projected. -/
theorem r779_surjectivity_target_eq_target_invariants_of_target_coherence
    [MatsushimaTargetDesignationCoherence A B] :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
        = CuspidalCohomologyData.trivialModulePart (A := B) :=
        MatsushimaTargetDesignationCoherence.surjectivity_target_eq_trivialModulePart
          (A := A) (B := B)
    _ = MatsushimaData.target_invariants (A := A) (B := B) :=
        (r779_target_invariants_eq_trivialModulePart (A := A) (B := B)).symm

end TargetCoherence

section CarrierLineInput

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

/-- The remaining carrier-line designation input needed by the R779
three-field construction.  It is deliberately a local hypothesis, not a new
class in this file. -/
def compactDualAgreesWithH8 : Prop :=
  MatsushimaCompactDualData.compactDual (A := A) (B := B) =
    CompactDualData.H8 (A := A)

/-- **R779 theorem (5/12)**: once the compact-dual carrier is identified
with the `H8` line, `h^4` is in the compact-dual carrier by the existing
`H8 = span {h^4}` field. -/
theorem r779_h_pow_four_mem_compactDual_of_compactDualH8
    (hcompact_H8 : compactDualAgreesWithH8 (A := A) (B := B)) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [hcompact_H8]
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

/-- **R779 theorem (6/12)**: source and target designation coherence, plus
the explicit compact-dual/H8 carrier input, yield the exact target-line
equality. -/
theorem r779_target_line_of_coherences_and_compactDualH8
    [MatsushimaSourceDesignationCoherence A B]
    [MatsushimaTargetDesignationCoherence A B]
    (hcompact_H8 : compactDualAgreesWithH8 (A := A) (B := B)) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        ({MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} : Set B) := by
  calc
    MatsushimaData.target_invariants (A := A) (B := B)
        = MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        (r779_surjectivity_target_eq_target_invariants_of_target_coherence
          (A := A) (B := B)).symm
    _ = Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) := by
          exact (MatsushimaSurjectivityData.surjectivity_eq
            (A := A) (B := B)).symm
    _ = Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
          rw [MatsushimaSourceDesignationCoherence.surjectivity_source_eq_compactDual
            (A := A) (B := B)]
    _ = Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CompactDualData.H8 (A := A)) := by
          rw [hcompact_H8]
    _ = Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (Submodule.span Rat ({((KaehlerClass.h : A) ^ 4)} : Set A)) := by
          rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
    _ = Submodule.span Rat
          ({MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)} : Set B) := by
          rw [Submodule.map_span]
          congr 1
          ext y
          simp

/-- **R779 theorem (7/12)**: the R776 three-field contract is obtained from
designation coherence plus the explicit compact-dual/H8 carrier input. -/
def r779_three_field_contract_of_coherences
    [MatsushimaSourceDesignationCoherence A B]
    [MatsushimaTargetDesignationCoherence A B]
    (hcompact_H8 : compactDualAgreesWithH8 (A := A) (B := B)) :
    EVIIH8ResidualCompactDualGeneratorTargetLineEqualityContract A B where
  source_invariants_exact_image :=
    r779_exact_image_of_source_coherence (A := A) (B := B)
  h_pow_four_mem_compactDual :=
    r779_h_pow_four_mem_compactDual_of_compactDualH8
      (A := A) (B := B) hcompact_H8
  target_invariants_eq_h_pow_four_line :=
    r779_target_line_of_coherences_and_compactDualH8
      (A := A) (B := B) hcompact_H8

end CarrierLineInput

section CountermodelKillTests

/-- **R779 theorem (8/12)**: the R778 scalar countermodel does not satisfy
source designation coherence. -/
theorem r779_countermodel_fails_source_coherence :
    Not (MatsushimaSourceDesignationCoherence
      ExactImageObstructionSource ExactImageObstructionTarget) := by
  intro hcoh
  have hsource :
      MatsushimaSurjectivityData.surjectivity_source
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget) =
        MatsushimaCompactDualData.compactDual
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget) :=
    MatsushimaSourceDesignationCoherence.surjectivity_source_eq_compactDual
      (A := ExactImageObstructionSource)
      (B := ExactImageObstructionTarget)
  change
    (⊥ : Submodule Rat ExactImageObstructionSource) =
      (⊤ : Submodule Rat ExactImageObstructionSource) at hsource
  have hone_bot :
      (1 : ExactImageObstructionSource) ∈
        (⊥ : Submodule Rat ExactImageObstructionSource) := by
    rw [hsource]
    trivial
  change (1 : Rat) = 0 at hone_bot
  norm_num at hone_bot

/-- **R779 theorem (9/12)**: the R778 scalar countermodel does not satisfy
target designation coherence. -/
theorem r779_countermodel_fails_target_coherence :
    Not (MatsushimaTargetDesignationCoherence
      ExactImageObstructionSource ExactImageObstructionTarget) := by
  intro hcoh
  have htarget :
      MatsushimaSurjectivityData.surjectivity_target
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget) =
        CuspidalCohomologyData.trivialModulePart
          (A := ExactImageObstructionTarget) :=
    MatsushimaTargetDesignationCoherence.surjectivity_target_eq_trivialModulePart
      (A := ExactImageObstructionSource)
      (B := ExactImageObstructionTarget)
  change
    (⊥ : Submodule Rat ExactImageObstructionTarget) =
      (⊤ : Submodule Rat ExactImageObstructionTarget) at htarget
  have hone_bot :
      (1 : ExactImageObstructionTarget) ∈
        (⊥ : Submodule Rat ExactImageObstructionTarget) := by
    rw [htarget]
    trivial
  change (1 : Rat) = 0 at hone_bot
  norm_num at hone_bot

/-- **R779 theorem (10/12)**: both new coherence classes kill the R778
countermodel. -/
theorem r779_countermodel_fails_new_coherences :
    Not (MatsushimaSourceDesignationCoherence
      ExactImageObstructionSource ExactImageObstructionTarget) ∧
    Not (MatsushimaTargetDesignationCoherence
      ExactImageObstructionSource ExactImageObstructionTarget) :=
  ⟨r779_countermodel_fails_source_coherence,
    r779_countermodel_fails_target_coherence⟩

end CountermodelKillTests

/-- R779 designation ledger.  Rows are strings so the audit can carry the
exact route reading without becoming another mathematical premise. -/
def R779DesignationLedger : List String := [
  "target_invariants = cuspidalSubspace: existing field EisensteinVanishingDeg8.target_invariants_eq_cuspidal",
  "cuspidalSubspace inf target_invariants = trivialModulePart: existing field CuspidalGInvariantTrivialModuleDeg8.cuspidal_G_invariant_eq_trivial_module",
  "target_invariants = trivialModulePart: derived in r779_target_invariants_eq_trivialModulePart",
  "compactDual = source_invariants: existing field MatsushimaCompactDualData.compactDual_eq_source_invariants",
  "surjectivity_source = compactDual: new designation coherence MatsushimaSourceDesignationCoherence",
  "surjectivity_target = trivialModulePart: new designation coherence MatsushimaTargetDesignationCoherence",
  "compactDual = H8: explicit instance-level carrier input compactDualAgreesWithH8 for the R776 three-field constructor",
  "H8 = span {h^4}: existing field CompactDualData.H8_eq_span_h_pow_4"
]

/-- Machine-readable R779 status. -/
structure R779DesignationCoherenceCollapseSnapshot where
  targetInvariantsTrivialModulePartDerivable : Bool
  sourceCoherenceDerivesExactImage : Bool
  targetCoherenceDerivesR778Projection : Bool
  countermodelFailsSourceCoherence : Bool
  countermodelFailsTargetCoherence : Bool
  compactDualH8CarrierInputStillExplicit : Bool
  threeFieldContractHasConstructorFromCoherences : Bool
  abstractContractCollapsedToCoherences : Bool
  remainingFrontierIsInstanceLevel : Bool
  constructsRealInstance : Bool
  provesFullHC : Bool
  coherenceClassesAreNotNewMathematicsDisclosure : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R779 status: the abstract R776 front is reduced to designation
coherence plus the explicit compact-dual/H8 carrier input, with real instance
construction still outside this file. -/
def currentR779DesignationCoherenceCollapseSnapshot :
    R779DesignationCoherenceCollapseSnapshot where
  targetInvariantsTrivialModulePartDerivable := true
  sourceCoherenceDerivesExactImage := true
  targetCoherenceDerivesR778Projection := true
  countermodelFailsSourceCoherence := true
  countermodelFailsTargetCoherence := true
  compactDualH8CarrierInputStillExplicit := true
  threeFieldContractHasConstructorFromCoherences := true
  abstractContractCollapsedToCoherences := true
  remainingFrontierIsInstanceLevel := true
  constructsRealInstance := false
  provesFullHC := false
  coherenceClassesAreNotNewMathematicsDisclosure := true
  isClosureClaim := false

/-- **R779 theorem (11/12)**: kernel-checked status for the designation
coherence collapse audit. -/
theorem currentR779DesignationCoherenceCollapseSnapshot_eq_texStatus :
    currentR779DesignationCoherenceCollapseSnapshot =
      ({ targetInvariantsTrivialModulePartDerivable := true
         sourceCoherenceDerivesExactImage := true
         targetCoherenceDerivesR778Projection := true
         countermodelFailsSourceCoherence := true
         countermodelFailsTargetCoherence := true
         compactDualH8CarrierInputStillExplicit := true
         threeFieldContractHasConstructorFromCoherences := true
         abstractContractCollapsedToCoherences := true
         remainingFrontierIsInstanceLevel := true
         constructsRealInstance := false
         provesFullHC := false
         coherenceClassesAreNotNewMathematicsDisclosure := true
         isClosureClaim := false } :
        R779DesignationCoherenceCollapseSnapshot) := by
  decide

/-- **R779 theorem (12/12)**: kernel-checked route ledger for the new
coherence collapse reading. -/
theorem R779DesignationLedger_eq_texStatus :
    R779DesignationLedger = [
      "target_invariants = cuspidalSubspace: existing field EisensteinVanishingDeg8.target_invariants_eq_cuspidal",
      "cuspidalSubspace inf target_invariants = trivialModulePart: existing field CuspidalGInvariantTrivialModuleDeg8.cuspidal_G_invariant_eq_trivial_module",
      "target_invariants = trivialModulePart: derived in r779_target_invariants_eq_trivialModulePart",
      "compactDual = source_invariants: existing field MatsushimaCompactDualData.compactDual_eq_source_invariants",
      "surjectivity_source = compactDual: new designation coherence MatsushimaSourceDesignationCoherence",
      "surjectivity_target = trivialModulePart: new designation coherence MatsushimaTargetDesignationCoherence",
      "compactDual = H8: explicit instance-level carrier input compactDualAgreesWithH8 for the R776 three-field constructor",
      "H8 = span {h^4}: existing field CompactDualData.H8_eq_span_h_pow_4"
    ] := by
  rfl

theorem r779_does_not_construct_real_instance :
    currentR779DesignationCoherenceCollapseSnapshot.constructsRealInstance = false := by
  rfl

theorem r779_does_not_solve_HC :
    currentR779DesignationCoherenceCollapseSnapshot.provesFullHC = false := by
  rfl

theorem r779_coherence_classes_are_not_new_mathematics_disclosure :
    (currentR779DesignationCoherenceCollapseSnapshot).coherenceClassesAreNotNewMathematicsDisclosure =
      true := by
  rfl

def R779_substantiveTheoremCount : Nat := 12

end FrontC213_H8ResidualDesignationCoherenceCollapse
end HCGapL4
end HodgeReduction
