/-
# HC Gap L4 -- Front C75: target-invariant rank criterion (R639).

R638 exposes the live target-side theorem as exact Matsushima
target-invariant saturation:

* `Submodule.map j_q source_invariants = target_invariants`.

The forward containment is already formal from Matsushima equivariance.
This file records the next genuinely geometric target without adding any
instance, axiom, or stronger premise: prove the finite-dimensional rank
match

* `finrank source_invariants = finrank target_invariants`.

Under finite-dimensional target invariants, injectivity of `j_q` turns
that rank match into the R638 saturation equality.  Conversely, any
saturation equality gives the same rank match.  The existing countermodel
still blocks deriving this rank match from the R636 carrier side alone.
-/

import HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation
import HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion
import HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC75_H8ResidualTargetInvariantRankCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC15_MatsushimaBoundaryRankCriterion
open FrontC23_MatsushimaCompactDualRankOne
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC74_H8ResidualTargetInvariantSaturation

section TargetInvariantRankCriterion

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R639 substantive theorem (1/10)**: the Matsushima image of source
invariants has the same finrank as the source invariants, because `j_q`
is injective. -/
theorem sourceInvariantImage_finrank_eq_sourceInvariants :
    Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B))) =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
  simpa using
    (Submodule.equivMapOfInjective
      (MatsushimaData.j_q (A := A) (B := B))
      (MatsushimaData.j_q_injective (A := A) (B := B))
      (MatsushimaData.source_invariants (A := A) (B := B))).symm.finrank_eq

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R639 substantive theorem (2/10)**: the target-invariant saturation
equality follows from the target-invariant finrank match.  The only
substantive input is the rank match; the containment is Matsushima
equivariance. -/
theorem sourceInvariantImage_eq_targetInvariants_of_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hrank :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B))) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  apply Submodule.eq_of_le_of_finrank_eq
  · exact MatsushimaData.j_q_image_invariants_subset_target_invariants
      (A := A) (B := B)
  · calc
      Module.finrank (R := Rat)
          (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaData.source_invariants (A := A) (B := B)))
          =
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) :=
          sourceInvariantImage_finrank_eq_sourceInvariants
            (A := A) (B := B)
      _ =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
          hrank

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R639 substantive theorem (3/10)**: constructor form for the R638
saturation target from the finite-dimensional rank match. -/
theorem sourceInvariantImageSaturation_of_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hrank :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B))) :
    sourceInvariantImageSaturatesTargetInvariants A B :=
  sourceInvariantImageSaturation_of_sourceInvariantImage_eq_targetInvariants
    (A := A) (B := B)
    (sourceInvariantImage_eq_targetInvariants_of_targetInvariantFinrank
      (A := A) (B := B) hrank)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R639 substantive theorem (4/10)**: exact target-invariant image
equality gives the target-invariant rank match. -/
theorem targetInvariantFinrank_of_sourceInvariantImage_eq_targetInvariants
    (himage :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        MatsushimaData.target_invariants (A := A) (B := B)) :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B))) :=
        (sourceInvariantImage_finrank_eq_sourceInvariants
          (A := A) (B := B)).symm
    _ =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
        rw [himage]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R639 substantive theorem (5/10)**: R638 saturation gives the same
rank match. -/
theorem targetInvariantFinrank_of_sourceInvariantImageSaturation
    (hsat : sourceInvariantImageSaturatesTargetInvariants A B) :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) :=
  targetInvariantFinrank_of_sourceInvariantImage_eq_targetInvariants
    (A := A) (B := B)
    ((sourceInvariantImageSaturation_iff_image_eq_targetInvariants
      (A := A) (B := B)).1 hsat)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R639 substantive theorem (6/10)**: under finite-dimensional
target invariants, the R638 saturation target is exactly the invariant
rank match. -/
theorem sourceInvariantImageSaturation_iff_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    sourceInvariantImageSaturatesTargetInvariants A B <->
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
  Iff.intro
    (targetInvariantFinrank_of_sourceInvariantImageSaturation
      (A := A) (B := B))
    (sourceInvariantImageSaturation_of_targetInvariantFinrank
      (A := A) (B := B))

/-- The R639 rank-match spelling of the R638 residual contract. -/
structure EVIIH8ResidualTargetInvariantRankContract
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
  target_invariant_finrank :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B))

/-- **R639 substantive theorem (7/10)**: a rank-contract plus finite
target invariants gives the R638 saturation contract. -/
def targetInvariantSaturationContract_of_targetInvariantRankContract
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (O : EVIIH8ResidualTargetInvariantRankContract A B) :
    EVIIH8ResidualTargetInvariantSaturationContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariant_saturation :=
    (sourceInvariantImageSaturation_iff_targetInvariantSurjectivity
      (A := A) (B := B) O.source_invariants_exact_image).1
      (sourceInvariantImageSaturation_of_targetInvariantFinrank
        (A := A) (B := B) O.target_invariant_finrank)

/-- **R639 substantive theorem (8/10)**: any R638 saturation contract
also carries the target-invariant rank match. -/
def targetInvariantRankContract_of_targetInvariantSaturationContract
    (O : EVIIH8ResidualTargetInvariantSaturationContract A B) :
    EVIIH8ResidualTargetInvariantRankContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariant_finrank :=
    targetInvariantFinrank_of_sourceInvariantImageSaturation
      (A := A) (B := B)
      ((sourceInvariantImageSaturation_iff_targetInvariantSurjectivity
        (A := A) (B := B) O.source_invariants_exact_image).2
        O.target_invariant_saturation)

/-- **R639 substantive theorem (9/10)**: the R638 saturation contract
and the R639 rank contract are equivalent residual packages when the
target-invariant subspace is finite-dimensional. -/
theorem residual_targetInvariantSaturation_nonempty_iff_targetInvariantRank_nonempty
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Nonempty (EVIIH8ResidualTargetInvariantSaturationContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantRankContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantRankContract_of_targetInvariantSaturationContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantSaturationContract_of_targetInvariantRankContract
            (A := A) (B := B) O)))

/-- **R639 substantive theorem (10/10)**: constructor form for the
existing R636 containment contract from the rank criterion. -/
def exactImageContainmentContract_of_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hrank :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B))) :
    EVIIH8ResidualExactImageContainmentContract A B :=
  exactImageContainmentContract_of_sourceInvariantImageSaturation
    (A := A) (B := B)
    hexact hsource_H8
    (sourceInvariantImageSaturation_of_targetInvariantFinrank
      (A := A) (B := B) hrank)

end TargetInvariantRankCriterion

section Obstruction

/-- **R639 obstruction theorem (1/2)**: in the existing countermodel,
the source/target invariant rank match fails. -/
theorem counterexample_not_targetInvariantFinrank :
    Not
      (Module.finrank (R := Rat)
          (MatsushimaData.source_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget))) := by
  intro hrank
  have hsource_rank :
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) = 1 := by
    change Module.finrank (R := Rat)
        (CompactDualData.H8 (A := TargetBettiSource)) = 1
    exact compactDual_H8_finrank_eq_one (A := TargetBettiSource)
  have htarget_rank :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) = 2 := by
    change Module.finrank (R := Rat)
        (⊤ : Submodule Rat TargetBettiTarget) = 2
    simp [TargetBettiTarget]
  have hbad : (1 : Nat) = 2 := by
    rw [hsource_rank, htarget_rank] at hrank
    exact hrank
  norm_num at hbad

/-- **R639 obstruction theorem (2/2)**: exact image plus source-H8 still
does not force the target-invariant rank match in the current abstract
interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantFinrank :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (Module.finrank (R := Rat)
            (MatsushimaData.source_invariants
              (A := TargetBettiSource) (B := TargetBettiTarget)) =
          Module.finrank (R := Rat)
            (MatsushimaData.target_invariants
              (A := TargetBettiSource) (B := TargetBettiTarget))) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_targetInvariantFinrank⟩

end Obstruction

/-- R639 target names for route summaries. -/
def currentR639TargetInvariantRankTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove finrank source_invariants = finrank target_invariants"
]

/-- Machine-readable status for the R639 rank criterion. -/
structure R639TargetInvariantRankSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetRankObligationCount : Nat
  saturationReducedToFiniteRankCriterion : Bool
  targetRankCriterionEquivalentToSaturation : Bool
  carriersForceTargetRankCriterion : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R639 status: the target saturation theorem has been reduced
to a finite-dimensional invariant-rank equality, and the countermodel
shows this equality is not forced by the carrier interface alone. -/
def currentR639TargetInvariantRankSnapshot :
    R639TargetInvariantRankSnapshot where
  proofWorkObligationCount := currentR639TargetInvariantRankTargetNames.length
  exactImageCarrierObligationCount := 2
  targetRankObligationCount := 1
  saturationReducedToFiniteRankCriterion := true
  targetRankCriterionEquivalentToSaturation := true
  carriersForceTargetRankCriterion := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R639 rank ledger. -/
theorem currentR639TargetInvariantRankSnapshot_eq_texStatus :
    currentR639TargetInvariantRankSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetRankObligationCount := 1
         saturationReducedToFiniteRankCriterion := true
         targetRankCriterionEquivalentToSaturation := true
         carriersForceTargetRankCriterion := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R639TargetInvariantRankSnapshot) := by
  decide

/-- Kernel-checked target names for the R639 ledger. -/
theorem currentR639TargetInvariantRankTargetNames_eq_texStatus :
    currentR639TargetInvariantRankTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove finrank source_invariants = finrank target_invariants"
    ] := by
  rfl

def R639_substantiveTheoremCount : Nat := 12

end FrontC75_H8ResidualTargetInvariantRankCriterion
end HCGapL4
end HodgeReduction
