/-
# HC Gap L4 -- Front C123: generator membership plus multiplicity route (R687).

R686 shows that `MatsushimaV56BoundaryData` alone does not force the
source-H8 carrier theorem.  This file weakens the source-side input used by
the older multiplicity route: R657 used the full equality

  `source_invariants = H8`

only to place the generator `j_q(h^4)` in the trivial-module part.  The
actual input needed for that placement is just generator membership

  `h^4` lies in `source_invariants`.

Therefore, under finite-dimensional trivial-module cohomology, the pair

* `h^4` lies in `source_invariants`;
* `finrank trivialModulePart <= 1`;

already proves both the target line theorem and the source-H8 carrier theorem.
This is a smaller concrete attack surface for the R685 route, not a closure
claim and not a new hidden premise.
-/

import HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment
import HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
import HodgeReduction.HCGapL4.FrontC121_H8ResidualBoundaryDataSourceInvariantRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC123_H8ResidualGeneratorMultiplicityRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC81_H8ResidualTrivialModuleUpperBound
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC93_H8ResidualLineContainmentFromMultiplicity
open FrontC95_H8ResidualSourceNoExtraFromLineContainment
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence

section GeneratorMultiplicity

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

/-- **R687 substantive theorem (1/7)**: source generator membership is the
minimal input needed to put `j_q(h^4)` in target invariants. -/
theorem matsushima_h_pow_four_mem_target_invariants_of_h_pow_four_mem_source
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4) ∈
      MatsushimaData.target_invariants (A := A) (B := B) :=
  MatsushimaData.j_q_maps_invariants_to_invariants hh_pow

/-- **R687 substantive theorem (2/7)**: after the existing R554
target-invariants/trivial-module identification, source generator membership
puts `j_q(h^4)` in the trivial-module part. -/
theorem matsushima_h_pow_four_mem_trivialModulePart_of_h_pow_four_mem_source
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4) ∈
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have htarget :
      MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4) ∈
        MatsushimaData.target_invariants (A := A) (B := B) :=
    matsushima_h_pow_four_mem_target_invariants_of_h_pow_four_mem_source
      (A := A) (B := B) hh_pow
  rw [target_invariants_eq_trivialModulePart (A := A) (B := B)] at htarget
  exact htarget

/-- **R687 substantive theorem (3/7)**: finite-dimensional multiplicity upper
bound plus source generator membership proves the concrete target line
containment.  This weakens R657, which used full source-H8 for the same
generator-membership step. -/
theorem trivialModulePart_le_matsushima_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  let gen : B :=
    MatsushimaData.j_q (A := A) (B := B)
      ((KaehlerClass.h : A) ^ 4)
  have hgen_mem :
      gen ∈ CuspidalCohomologyData.trivialModulePart (A := B) :=
    matsushima_h_pow_four_mem_trivialModulePart_of_h_pow_four_mem_source
      (A := A) (B := B) hh_pow
  have hgen_ne : gen ≠ 0 :=
    matsushima_h_pow_four_image_ne_zero (A := A) (B := B)
  let genSub :
      CuspidalCohomologyData.trivialModulePart (A := B) :=
    ⟨gen, hgen_mem⟩
  have hgenSub_ne : genSub ≠ 0 := by
    intro hzero
    exact hgen_ne (congrArg Subtype.val hzero)
  have hpos :
      0 <
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) := by
    exact Module.finrank_pos_iff_exists_ne_zero.mpr ⟨genSub, hgenSub_ne⟩
  have hfin_eq :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
    omega
  intro beta hbeta
  have hmultiple :
      ∃ r : Rat, r • genSub = (⟨beta, hbeta⟩ :
        CuspidalCohomologyData.trivialModulePart (A := B)) :=
    (finrank_eq_one_iff_of_nonzero' genSub hgenSub_ne).mp
      hfin_eq
      (⟨beta, hbeta⟩ :
        CuspidalCohomologyData.trivialModulePart (A := B))
  obtain ⟨r, hr⟩ := hmultiple
  have hr_val : r • gen = beta := by
    exact congrArg Subtype.val hr
  rw [← hr_val]
  exact
    Submodule.smul_mem _
      r
      (Submodule.subset_span (by simp [gen]))

/-- **R687 substantive theorem (4/7)**: the same generator-membership plus
finite multiplicity bound proves the exact target-invariant line equality. -/
theorem target_invariants_eq_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  apply le_antisymm
  · rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]
    exact
      trivialModulePart_le_matsushima_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
        (A := A) (B := B) hh_pow hupper
  · apply Submodule.span_le.mpr
    intro beta hbeta
    rw [Set.mem_singleton_iff] at hbeta
    rw [hbeta]
    exact
      matsushima_h_pow_four_mem_target_invariants_of_h_pow_four_mem_source
        (A := A) (B := B) hh_pow

/-- **R687 substantive theorem (5/7)**: with finite-dimensional
trivial-module part, source generator membership plus the multiplicity upper
bound proves the source-H8 carrier theorem. -/
theorem source_invariants_eq_H8_of_h_pow_four_mem_source_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
    (A := A) (B := B)
    hh_pow
    (trivialModulePart_le_matsushima_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
      (A := A) (B := B) hh_pow hupper)

/-- The R687 sufficient boundary route: boundary data, source generator
membership, and finite-dimensional trivial-module multiplicity upper bound. -/
structure EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract
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
  boundary : MatsushimaV56BoundaryData A B
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_upper_bound :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1

/-- **R687 substantive theorem (6/7)**: the generator/multiplicity route
rebuilds the R672 boundary-data/source-H8 contract. -/
def boundaryDataSourceH8Contract_of_boundaryDataGeneratorMultiplicityContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B where
  boundary := O.boundary
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_h_pow_four_mem_source_trivialModulePartUpperBound
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_upper_bound

/-- **R687 substantive theorem (7/7)**: the same route rebuilds the R674
boundary-data/target-line contract, deriving the line equality from generator
membership plus multiplicity instead of assuming source-H8. -/
def boundaryDataTargetLineContract_of_boundaryDataGeneratorMultiplicityContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualBoundaryDataGeneratorMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataTargetLineContract A B where
  boundary := O.boundary
  target_invariants_eq_h_pow_four_line :=
    target_invariants_eq_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
      (A := A) (B := B)
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_upper_bound

end GeneratorMultiplicity

/-- R687 target names for route summaries. -/
def currentR687GeneratorMultiplicityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in source_invariants",
  "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R687 generator/multiplicity route. -/
structure R687GeneratorMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  generatorMembershipPlacesTargetGenerator : Bool
  generatorMultiplicityProvesTargetLine : Bool
  generatorMultiplicityProvesSourceH8 : Bool
  feedsBoundaryDataSourceH8 : Bool
  feedsBoundaryDataTargetLine : Bool
  provesBoundaryData : Bool
  provesGeneratorMembership : Bool
  provesTrivialMultiplicityUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R687 status: this is a sufficient smaller attack surface for the
R685 two-target route; it does not prove the boundary data, generator
membership, or multiplicity theorem. -/
def currentR687GeneratorMultiplicitySnapshot :
    R687GeneratorMultiplicitySnapshot where
  proofWorkObligationCount := currentR687GeneratorMultiplicityTargetNames.length
  generatorMembershipPlacesTargetGenerator := true
  generatorMultiplicityProvesTargetLine := true
  generatorMultiplicityProvesSourceH8 := true
  feedsBoundaryDataSourceH8 := true
  feedsBoundaryDataTargetLine := true
  provesBoundaryData := false
  provesGeneratorMembership := false
  provesTrivialMultiplicityUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R687 route ledger. -/
theorem currentR687GeneratorMultiplicitySnapshot_eq_texStatus :
    currentR687GeneratorMultiplicitySnapshot =
      ({ proofWorkObligationCount := 3
         generatorMembershipPlacesTargetGenerator := true
         generatorMultiplicityProvesTargetLine := true
         generatorMultiplicityProvesSourceH8 := true
         feedsBoundaryDataSourceH8 := true
         feedsBoundaryDataTargetLine := true
         provesBoundaryData := false
         provesGeneratorMembership := false
         provesTrivialMultiplicityUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R687GeneratorMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R687 route. -/
theorem currentR687GeneratorMultiplicityTargetNames_eq_texStatus :
    currentR687GeneratorMultiplicityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in source_invariants",
      "prove finite-dimensional trivialModulePart and finrank trivialModulePart <= 1"
    ] := by
  rfl

def R687_substantiveTheoremCount : Nat := 7

end FrontC123_H8ResidualGeneratorMultiplicityRoute
end HCGapL4
end HodgeReduction
