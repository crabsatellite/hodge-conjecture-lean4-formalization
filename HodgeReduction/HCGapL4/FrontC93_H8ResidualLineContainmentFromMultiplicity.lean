/-
# HC Gap L4 -- Front C93: line containment from multiplicity (R657).

R656 turns the scalar-preimage target into the concrete containment

  `trivialModulePart <= span {j_q(h^4)}`.

This file connects that target back to the R645 multiplicity upper bound.
Once `source_invariants = H8`, equivariance sends `h^4` to target
invariants, and R554 identifies target invariants with `trivialModulePart`.
Since R656 proves `j_q(h^4)` is non-zero, a one-dimensional upper bound on
`trivialModulePart` forces every trivial-module class to lie on that line.

No EVII multiplicity theorem is proved here.  The file proves that the next
genuine target is exactly the R645 upper bound plus the existing source-H8
carrier, not a new independent line-containment assumption.
-/

import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC93_H8ResidualLineContainmentFromMultiplicity

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC81_H8ResidualTrivialModuleUpperBound
open FrontC83_H8ResidualCartanImageScalarPreimage
open FrontC87_H8ResidualInvariantMapSurjectivity
open FrontC91_H8ResidualRightInverseScalarPreimageEquivalence
open FrontC92_H8ResidualCartanGeneratorLineCriterion

section GeneratorMembership

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
/-- With the source carrier fixed to `H8`, the explicit generator
`j_q(h^4)` lies in the target trivial-module part. -/
theorem matsushima_h_pow_four_mem_trivialModulePart_of_sourceH8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4) ∈
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have hh4_H8 :
      ((KaehlerClass.h : A) ^ 4) ∈ CompactDualData.H8 (A := A) := by
    rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
    exact Submodule.subset_span (by simp)
  have hh4_source :
      ((KaehlerClass.h : A) ^ 4) ∈
        MatsushimaData.source_invariants (A := A) (B := B) := by
    rw [hsource_H8]
    exact hh4_H8
  have htarget :
      MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4) ∈
        MatsushimaData.target_invariants (A := A) (B := B) :=
    MatsushimaData.j_q_maps_invariants_to_invariants hh4_source
  rw [target_invariants_eq_trivialModulePart (A := A) (B := B)] at htarget
  exact htarget

end GeneratorMembership

section LineContainmentFromMultiplicity

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
/-- A one-dimensional upper bound plus generator membership forces the
explicit R656 line containment. -/
theorem trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    CuspidalCohomologyData.trivialModulePart (A := B) ≤
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  let gen : B :=
    MatsushimaData.j_q (A := A) (B := B)
      ((KaehlerClass.h : A) ^ 4)
  have hgen_mem :
      gen ∈ CuspidalCohomologyData.trivialModulePart (A := B) :=
    matsushima_h_pow_four_mem_trivialModulePart_of_sourceH8
      (A := A) (B := B) hsource_H8
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

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] in
/-- The R645 upper bound, after source-H8 and finite dimensionality, proves the
R656 scalar-preimage theorem. -/
theorem cartan_scalar_preimage_of_sourceH8_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    forall beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
        exists r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta :=
  (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B)).2
    (trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound
      (A := A) (B := B) hsource_H8 hupper)

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B] in
/-- The same R645 upper bound proves the R652/R655 restricted invariant-map
bijectivity target. -/
theorem sourceToTargetInvariantMap_bijective_of_sourceH8_trivialModulePartUpperBound
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    Function.Bijective (sourceToTargetInvariantMap A B) :=
  (sourceToTargetInvariantMap_bijective_iff_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B) hsource_H8).2
    (trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound
      (A := A) (B := B) hsource_H8 hupper)

end LineContainmentFromMultiplicity

section Contracts

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

/-- The R645 multiplicity contract feeds the R656 line-containment contract. -/
def cartanLineContainmentContract_of_trivialModuleUpperBoundContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualTrivialModuleUpperBoundContract A B) :
    EVIIH8ResidualCartanLineContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_le_h_pow_four_line :=
    trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound
      (A := A) (B := B) O.source_invariants_eq_H8
      O.trivialModulePart_upper_bound

/-- Nonempty R645 multiplicity contracts are enough to produce nonempty R656
line-containment contracts, under finite-dimensional trivial-module part. -/
theorem residual_trivialModuleUpperBound_nonempty_to_cartanLine_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualTrivialModuleUpperBoundContract A B) ->
      Nonempty (EVIIH8ResidualCartanLineContainmentContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (cartanLineContainmentContract_of_trivialModuleUpperBoundContract
      (A := A) (B := B) O)

end Contracts

/-- R657 target names for route summaries. -/
def currentR657LineContainmentFromMultiplicityTargetNames : List String := [
  "prove source_invariants = H8",
  "prove finite-dimensional trivialModulePart",
  "prove finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R657 multiplicity-to-line bridge. -/
structure R657LineContainmentFromMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  generatorMembershipFromSourceH8 : Bool
  multiplicityUpperBoundFeedsLineContainment : Bool
  multiplicityUpperBoundFeedsScalarPreimage : Bool
  multiplicityUpperBoundFeedsInvariantMapBijectivity : Bool
  provesMultiplicityUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R657 status: finite-dimensional multiplicity upper bound is a
sufficient route to the R656 line-containment target. -/
def currentR657LineContainmentFromMultiplicitySnapshot :
    R657LineContainmentFromMultiplicitySnapshot where
  proofWorkObligationCount :=
    currentR657LineContainmentFromMultiplicityTargetNames.length
  generatorMembershipFromSourceH8 := true
  multiplicityUpperBoundFeedsLineContainment := true
  multiplicityUpperBoundFeedsScalarPreimage := true
  multiplicityUpperBoundFeedsInvariantMapBijectivity := true
  provesMultiplicityUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R657 ledger. -/
theorem currentR657LineContainmentFromMultiplicitySnapshot_eq_texStatus :
    currentR657LineContainmentFromMultiplicitySnapshot =
      ({ proofWorkObligationCount := 3
         generatorMembershipFromSourceH8 := true
         multiplicityUpperBoundFeedsLineContainment := true
         multiplicityUpperBoundFeedsScalarPreimage := true
         multiplicityUpperBoundFeedsInvariantMapBijectivity := true
         provesMultiplicityUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R657LineContainmentFromMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R657 ledger. -/
theorem currentR657LineContainmentFromMultiplicityTargetNames_eq_texStatus :
    currentR657LineContainmentFromMultiplicityTargetNames = [
      "prove source_invariants = H8",
      "prove finite-dimensional trivialModulePart",
      "prove finrank trivialModulePart <= 1"
    ] := by
  rfl

def R657_substantiveTheoremCount : Nat := 6

end FrontC93_H8ResidualLineContainmentFromMultiplicity
end HCGapL4
end HodgeReduction
