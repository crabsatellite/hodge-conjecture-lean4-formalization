/-
# HC Gap L4 -- Front C77: target-invariant excess quotient (R641).

R640 reconciles the R639 invariant-rank criterion with the older
expected-Betti residual.  This file changes the shape of the remaining
target-side theorem into a quotient-vanishing problem:

* take the quotient of the target cohomology by the Matsushima image
  `Submodule.map j_q source_invariants`;
* map `target_invariants` into that quotient;
* prove that the resulting excess submodule is zero.

This is equivalent to the R638 saturation statement
`target_invariants <= Submodule.map j_q source_invariants`.  Under
finite-dimensional target invariants and `source_invariants = H8`, it is
therefore equivalent to the R600/R640 expected-Betti target.  No axiom,
instance, or stronger premise is introduced.
-/

import HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC77_H8ResidualTargetInvariantExcessQuotient

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC74_H8ResidualTargetInvariantSaturation
open FrontC75_H8ResidualTargetInvariantRankCriterion
open FrontC76_H8ResidualRankCriterionReconciliation

section QuotientLinearAlgebra

variable {R M : Type*} [Ring R] [AddCommGroup M] [Module R M]

/-- A submodule has zero image in the quotient by `p` exactly when it is
contained in `p`.  This is the generic linear-algebra lemma behind the
R641 target-excess quotient. -/
theorem map_mkQ_eq_bot_iff_le (p q : Submodule R M) :
    Submodule.map (Submodule.mkQ p) q = ⊥ <-> q ≤ p := by
  rw [eq_bot_iff, Submodule.map_le_iff_le_comap,
    Submodule.comap_bot, Submodule.ker_mkQ]

end QuotientLinearAlgebra

section TargetInvariantExcess

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

/-- The Matsushima image of the source-invariant subspace in the target. -/
def sourceInvariantImage : Submodule Rat B :=
  Submodule.map (MatsushimaData.j_q (A := A) (B := B))
    (MatsushimaData.source_invariants (A := A) (B := B))

/-- The residual target-invariant excess after quotienting by the
source-invariant image.  Vanishing of this submodule is the quotient form
of target-invariant saturation. -/
def targetInvariantExcessQuotient :
    Submodule Rat (B ⧸ sourceInvariantImage A B) :=
  Submodule.map (Submodule.mkQ (sourceInvariantImage A B))
    (MatsushimaData.target_invariants (A := A) (B := B))

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R641 substantive theorem (1/8)**: the target-excess quotient
vanishes exactly when the source-invariant image saturates all target
invariants. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation :
    targetInvariantExcessQuotient A B = ⊥ <->
      sourceInvariantImageSaturatesTargetInvariants A B := by
  unfold targetInvariantExcessQuotient
  unfold sourceInvariantImageSaturatesTargetInvariants
  unfold sourceInvariantImage
  exact
    map_mkQ_eq_bot_iff_le
      (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)))
      (MatsushimaData.target_invariants (A := A) (B := B))

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R641 substantive theorem (2/8)**: under the R636 exact-image carrier,
the same quotient vanishing is equivalent to target-invariant saturation
of `surjectivity_target`. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSurjectivity
    (hexact : sourceInvariantExactImageTarget A B) :
    targetInvariantExcessQuotient A B = ⊥ <->
      targetInvariantSurjectivityTarget A B :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
    (A := A) (B := B)).trans
    (sourceInvariantImageSaturation_iff_targetInvariantSurjectivity
      (A := A) (B := B) hexact)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R641 substantive theorem (3/8)**: under exact image, quotient
vanishing is also equivalent to the R636 reverse containment against the
cuspidal trivial-module part. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_surjectivity_target
    (hexact : sourceInvariantExactImageTarget A B) :
    targetInvariantExcessQuotient A B = ⊥ <->
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :=
  (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSurjectivity
    (A := A) (B := B) hexact).trans
    (targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target
      (A := A) (B := B))

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R641 substantive theorem (4/8)**: for finite-dimensional target
invariants, quotient vanishing is exactly the R639 source/target
invariant-rank match. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    targetInvariantExcessQuotient A B = ⊥ <->
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
    (A := A) (B := B)).trans
    (sourceInvariantImageSaturation_iff_targetInvariantFinrank
      (A := A) (B := B))

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R641 substantive theorem (5/8)**: once `source_invariants = H8`,
the quotient-vanishing target is equivalent to the existing R600/R640
expected-Betti target. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_target_expected_betti8
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))]
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    targetInvariantExcessQuotient A B = ⊥ <->
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) =
        shimuraEVIIExpectedBetti 8 := by
  constructor
  · intro hexcess
    exact
      target_expected_betti8_of_sourceH8_targetInvariantFinrank
        (A := A) (B := B)
        hsource_H8
        ((targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank
          (A := A) (B := B)).1 hexcess)
  · intro htarget
    exact
      (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank
        (A := A) (B := B)).2
        (targetInvariantFinrank_of_sourceH8_target_expected_betti8
          (A := A) (B := B)
          hsource_H8
          htarget)

/-- The R641 quotient-vanishing spelling of the R638/R640 residual. -/
structure EVIIH8ResidualTargetInvariantExcessQuotientContract
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
  target_excess_quotient_eq_bot :
    targetInvariantExcessQuotient A B = ⊥

/-- **R641 substantive theorem (6/8)**: quotient vanishing builds the
existing R636 containment contract. -/
def exactImageContainmentContract_of_targetInvariantExcessQuotientContract
    (O : EVIIH8ResidualTargetInvariantExcessQuotientContract A B) :
    EVIIH8ResidualExactImageContainmentContract A B :=
  exactImageContainmentContract_of_sourceInvariantImageSaturation
    (A := A) (B := B)
    O.source_invariants_exact_image
    O.source_invariants_eq_H8
    ((targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
      (A := A) (B := B)).1 O.target_excess_quotient_eq_bot)

/-- **R641 substantive theorem (7/8)**: the R638 saturation contract gives
the quotient-vanishing spelling. -/
def targetInvariantExcessQuotientContract_of_targetInvariantSaturationContract
    (O : EVIIH8ResidualTargetInvariantSaturationContract A B) :
    EVIIH8ResidualTargetInvariantExcessQuotientContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_excess_quotient_eq_bot :=
    (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSurjectivity
      (A := A) (B := B) O.source_invariants_exact_image).2
      O.target_invariant_saturation

/-- **R641 substantive theorem (8/8)**: under finite-dimensional target
invariants, the R641 quotient contract and R639 rank contract are
equivalent residual packages. -/
theorem residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantRank_nonempty
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantRankContract A B) := by
  constructor
  · intro h
    refine h.elim ?_
    intro O
    refine Nonempty.intro ?_
    exact
      { source_invariants_exact_image := O.source_invariants_exact_image
        source_invariants_eq_H8 := O.source_invariants_eq_H8
        target_invariant_finrank :=
          (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank
            (A := A) (B := B)).1 O.target_excess_quotient_eq_bot }
  · intro h
    refine h.elim ?_
    intro O
    refine Nonempty.intro ?_
    exact
      { source_invariants_exact_image := O.source_invariants_exact_image
        source_invariants_eq_H8 := O.source_invariants_eq_H8
        target_excess_quotient_eq_bot :=
          (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank
            (A := A) (B := B)).2 O.target_invariant_finrank }

end TargetInvariantExcess

section Obstruction

/-- In the existing countermodel, the target-invariant excess quotient is
not zero. -/
theorem counterexample_not_targetInvariantExcessQuotient_eq_bot :
    Not
      (targetInvariantExcessQuotient
          TargetBettiSource TargetBettiTarget = ⊥) := by
  intro hexcess
  exact counterexample_not_sourceInvariantImageSaturation
    ((targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
      (A := TargetBettiSource) (B := TargetBettiTarget)).1 hexcess)

/-- Exact image plus source-H8 still does not force quotient vanishing in
the current abstract interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantExcessQuotient :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (targetInvariantExcessQuotient
          TargetBettiSource TargetBettiTarget = ⊥) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_targetInvariantExcessQuotient_eq_bot⟩

end Obstruction

/-- R641 target names for route summaries. -/
def currentR641TargetInvariantExcessQuotientTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove targetInvariantExcessQuotient = bot"
]

/-- Machine-readable status for the R641 target-excess quotient
normalization. -/
structure R641TargetInvariantExcessQuotientSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetExcessQuotientObligationCount : Nat
  quotientVanishingEquivalentToSaturation : Bool
  withSourceH8EquivalentToExpectedBetti : Bool
  carriersForceQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R641 status: the live target-side theorem is now a quotient
vanishing problem.  The same carrier countermodel shows this is genuine
target geometry, not a formal consequence of the source carriers. -/
def currentR641TargetInvariantExcessQuotientSnapshot :
    R641TargetInvariantExcessQuotientSnapshot where
  proofWorkObligationCount := currentR641TargetInvariantExcessQuotientTargetNames.length
  exactImageCarrierObligationCount := 2
  targetExcessQuotientObligationCount := 1
  quotientVanishingEquivalentToSaturation := true
  withSourceH8EquivalentToExpectedBetti := true
  carriersForceQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R641 quotient ledger. -/
theorem currentR641TargetInvariantExcessQuotientSnapshot_eq_texStatus :
    currentR641TargetInvariantExcessQuotientSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetExcessQuotientObligationCount := 1
         quotientVanishingEquivalentToSaturation := true
         withSourceH8EquivalentToExpectedBetti := true
         carriersForceQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R641TargetInvariantExcessQuotientSnapshot) := by
  decide

/-- Kernel-checked target names for the R641 quotient ledger. -/
theorem currentR641TargetInvariantExcessQuotientTargetNames_eq_texStatus :
    currentR641TargetInvariantExcessQuotientTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove targetInvariantExcessQuotient = bot"
    ] := by
  rfl

def R641_substantiveTheoremCount : Nat := 8

end FrontC77_H8ResidualTargetInvariantExcessQuotient
end HCGapL4
end HodgeReduction
