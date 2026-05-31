/-
# HC Gap L4 -- Front C89: right-inverse target for the restricted invariant map (R653).

R652 identifies quotient vanishing with bijectivity of the restricted
invariant Matsushima map.  Since injectivity is already formal from
`j_q`, the live target is the onto half.  This file records a concrete
sufficient construction target: build a linear right inverse

`target_invariants -> source_invariants`.

Supplying that right inverse immediately closes the R652 bijectivity /
R641 quotient target.  The file does not assume such a map exists; it
only proves that this is now a valid theorem-closing attack interface.
-/

import HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC89_H8ResidualInvariantMapRightInverse

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC87_H8ResidualInvariantMapSurjectivity
open FrontC88_H8ResidualInvariantMapBijectivity

/-- Typed identity on target invariants.  Keeping this explicit prevents
`LinearMap.id` from leaving an ambiguous module metavariable in right-inverse
contracts. -/
abbrev targetInvariantIdentity
    (A B : Type*) [AddCommGroup A] [Module Rat A]
    [AddCommGroup B] [Module Rat B] [MatsushimaData A B] :
    MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
      MatsushimaData.target_invariants (A := A) (B := B) :=
  LinearMap.id

section RestrictedInvariantMapRightInverse

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

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R653 substantive theorem (1/7)**: a linear right inverse for the
restricted invariant map forces range-top, hence the onto half. -/
theorem sourceToTargetInvariantMap_range_eq_top_of_linearRightInverse
    (lift :
      MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
        MatsushimaData.source_invariants (A := A) (B := B))
    (hright :
      (sourceToTargetInvariantMap A B).comp lift = targetInvariantIdentity A B) :
    LinearMap.range (sourceToTargetInvariantMap A B) = ⊤ := by
  apply le_antisymm
  · exact le_top
  · intro beta _
    refine ⟨lift beta, ?_⟩
    have happly :
        ((sourceToTargetInvariantMap A B).comp lift) beta =
          targetInvariantIdentity A B beta := by
      rw [hright]
    simpa using happly

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R653 substantive theorem (2/7)**: a linear right inverse closes the
quotient-vanishing target. -/
theorem targetInvariantExcessQuotient_eq_bot_of_sourceToTargetInvariantMap_linearRightInverse
    (lift :
      MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
        MatsushimaData.source_invariants (A := A) (B := B))
    (hright :
      (sourceToTargetInvariantMap A B).comp lift = targetInvariantIdentity A B) :
    targetInvariantExcessQuotient A B = ⊥ :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_range_eq_top
    (A := A) (B := B)).2
    (sourceToTargetInvariantMap_range_eq_top_of_linearRightInverse
      (A := A) (B := B) lift hright)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R653 substantive theorem (3/7)**: a linear right inverse gives the
R652 bijectivity target. -/
theorem sourceToTargetInvariantMap_bijective_of_linearRightInverse
    (lift :
      MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
        MatsushimaData.source_invariants (A := A) (B := B))
    (hright :
      (sourceToTargetInvariantMap A B).comp lift = targetInvariantIdentity A B) :
    Function.Bijective (sourceToTargetInvariantMap A B) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective
    (A := A) (B := B)).1
    (targetInvariantExcessQuotient_eq_bot_of_sourceToTargetInvariantMap_linearRightInverse
      (A := A) (B := B) lift hright)

/-- The R653 right-inverse construction package.  It is a sufficient
condition for the R652 target, not an assumed theorem. -/
structure EVIIH8ResidualInvariantMapRightInverseContract
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
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  lift :
    MatsushimaData.target_invariants (A := A) (B := B) →ₗ[Rat]
      MatsushimaData.source_invariants (A := A) (B := B)
  right_inverse :
    (sourceToTargetInvariantMap A B).comp lift = targetInvariantIdentity A B

/-- **R653 substantive theorem (4/7)**: the right-inverse contract feeds
the R652 bijectivity contract. -/
def invariantMapBijectivityContract_of_invariantMapRightInverseContract
    (O : EVIIH8ResidualInvariantMapRightInverseContract A B) :
    EVIIH8ResidualInvariantMapBijectivityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  source_to_target_invariant_map_bijective :=
    sourceToTargetInvariantMap_bijective_of_linearRightInverse
      (A := A) (B := B) O.lift O.right_inverse

/-- **R653 substantive theorem (5/7)**: the right-inverse construction
package is a one-way consumer for the R652 residual. -/
theorem residual_invariantMapRightInverse_nonempty_to_invariantMapBijectivity_nonempty :
    Nonempty (EVIIH8ResidualInvariantMapRightInverseContract A B) ->
      Nonempty (EVIIH8ResidualInvariantMapBijectivityContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (invariantMapBijectivityContract_of_invariantMapRightInverseContract
      (A := A) (B := B) O)

end RestrictedInvariantMapRightInverse

section Obstruction

/-- **R653 substantive theorem (6/7)**: exact image and source-H8 still do
not force the existence of a linear right inverse in the current abstract
interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (exists lift :
          MatsushimaData.target_invariants
              (A := TargetBettiSource) (B := TargetBettiTarget) →ₗ[Rat]
            MatsushimaData.source_invariants
              (A := TargetBettiSource) (B := TargetBettiTarget),
          (sourceToTargetInvariantMap
              TargetBettiSource TargetBettiTarget).comp lift =
            targetInvariantIdentity TargetBettiSource TargetBettiTarget) := by
  rcases
    current_interface_with_exactImage_sourceH8_does_not_force_invariantMapSurjectivity with
    ⟨hexact, hsource, hnot⟩
  refine ⟨hexact, hsource, ?_⟩
  intro hright
  rcases hright with ⟨lift, hright⟩
  exact hnot
    (sourceToTargetInvariantMap_range_eq_top_of_linearRightInverse
      (A := TargetBettiSource) (B := TargetBettiTarget) lift hright)

/-- **R653 substantive theorem (7/7)**: the current interface also does
not force the right-inverse contract as a package. -/
theorem current_interface_does_not_force_rightInverseContract_nonempty :
    Not
      (Nonempty
        (EVIIH8ResidualInvariantMapRightInverseContract
          TargetBettiSource TargetBettiTarget)) := by
  intro h
  exact current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse.2.2
    (h.elim (fun O => ⟨O.lift, O.right_inverse⟩))

end Obstruction

/-- R653 target names for route summaries. -/
def currentR653InvariantMapRightInverseTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "sufficient target: construct a linear right inverse target_invariants -> source_invariants"
]

/-- Machine-readable status for the R653 right-inverse target. -/
structure R653InvariantMapRightInverseSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  rightInverseConstructionObligationCount : Nat
  rightInverseImpliesQuotientVanishing : Bool
  rightInverseImpliesBijectivity : Bool
  carriersForceRightInverse : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R653 status: constructing a linear right inverse is a
sufficient route to the target-side quotient/bijectivity gap. -/
def currentR653InvariantMapRightInverseSnapshot :
    R653InvariantMapRightInverseSnapshot where
  proofWorkObligationCount := currentR653InvariantMapRightInverseTargetNames.length
  exactImageCarrierObligationCount := 2
  rightInverseConstructionObligationCount := 1
  rightInverseImpliesQuotientVanishing := true
  rightInverseImpliesBijectivity := true
  carriersForceRightInverse := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R653 ledger. -/
theorem currentR653InvariantMapRightInverseSnapshot_eq_texStatus :
    currentR653InvariantMapRightInverseSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         rightInverseConstructionObligationCount := 1
         rightInverseImpliesQuotientVanishing := true
         rightInverseImpliesBijectivity := true
         carriersForceRightInverse := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R653InvariantMapRightInverseSnapshot) := by
  decide

/-- Kernel-checked target names for the R653 ledger. -/
theorem currentR653InvariantMapRightInverseTargetNames_eq_texStatus :
    currentR653InvariantMapRightInverseTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "sufficient target: construct a linear right inverse target_invariants -> source_invariants"
    ] := by
  rfl

def R653_substantiveTheoremCount : Nat := 7

end FrontC89_H8ResidualInvariantMapRightInverse
end HCGapL4
end HodgeReduction
