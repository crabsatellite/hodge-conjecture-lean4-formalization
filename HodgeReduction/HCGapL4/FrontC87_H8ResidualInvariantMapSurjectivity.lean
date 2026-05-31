/-
# HC Gap L4 -- Front C87: restricted invariant map surjectivity (R651).

R650 exposed quotient vanishing as an element-level preimage target:
every class in `target_invariants` must lift from `source_invariants`.
This file turns that statement into the surjectivity of the actual
restricted Matsushima map

`source_invariants -> target_invariants`.

The point of this round is to make the next attack a standard linear-map
surjectivity problem.  This is not a new premise and not a closure claim:
the restricted map is built from the existing `j_q` and its existing
invariant-preservation field.
-/

import HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC87_H8ResidualInvariantMapSurjectivity

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC78_H8ResidualTargetInvariantInternalQuotient
open FrontC86_H8ResidualTargetInvariantPreimageCriterion

section RestrictedInvariantMap

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

/-- The actual Matsushima map restricted from source invariants to target
invariants.  The codomain proof is exactly the existing equivariance
field `j_q_maps_invariants_to_invariants`; no new assumption is added. -/
def sourceToTargetInvariantMap :
    MatsushimaData.source_invariants (A := A) (B := B) →ₗ[Rat]
      MatsushimaData.target_invariants (A := A) (B := B) where
  toFun alpha :=
    ⟨MatsushimaData.j_q (A := A) (B := B) alpha,
      MatsushimaData.j_q_maps_invariants_to_invariants
        (A := A) (B := B) alpha.2⟩
  map_add' alpha gamma := by
    ext
    simp [MatsushimaData.j_q]
  map_smul' r alpha := by
    ext
    simp [MatsushimaData.j_q]

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R651 substantive theorem (1/8)**: the range of the restricted map
is exactly the internal source-image subspace from R642. -/
theorem sourceToTargetInvariantMap_range_eq_sourceInvariantImageInsideTarget :
    LinearMap.range (sourceToTargetInvariantMap A B) =
      sourceInvariantImageInsideTarget A B := by
  ext beta
  constructor
  · intro hbeta
    rcases hbeta with ⟨alpha, hmap⟩
    change (beta : B) ∈ sourceInvariantImage A B
    exact ⟨alpha, alpha.2, by
      simpa [sourceToTargetInvariantMap] using congrArg Subtype.val hmap⟩
  · intro hbeta
    change (beta : B) ∈ sourceInvariantImage A B at hbeta
    rcases hbeta with ⟨alpha, halpha, hmap⟩
    exact ⟨⟨alpha, halpha⟩, by
      ext
      simpa [sourceToTargetInvariantMap] using hmap⟩

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R651 substantive theorem (2/8)**: restricted-map surjectivity,
stated as range-top, is exactly the R650 element-level preimage target. -/
theorem sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage :
    LinearMap.range (sourceToTargetInvariantMap A B) = ⊤ <->
      targetInvariantSourcePreimageTarget A B := by
  rw [sourceToTargetInvariantMap_range_eq_sourceInvariantImageInsideTarget]
  exact
    (sourceInvariantImageInsideTarget_eq_top_iff_sourceInvariantImageSaturation
      (A := A) (B := B)).trans
      (sourceInvariantImageSaturation_iff_targetInvariantSourcePreimage
        (A := A) (B := B))

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R651 substantive theorem (3/8)**: quotient vanishing is exactly
surjectivity of the restricted invariant map, stated as range-top. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_range_eq_top :
    targetInvariantExcessQuotient A B = ⊥ <->
      LinearMap.range (sourceToTargetInvariantMap A B) = ⊤ :=
  (targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage
    (A := A) (B := B)).trans
    (sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage
      (A := A) (B := B)).symm

/-- The R651 restricted-map-surjectivity spelling of the H8 residual
target. -/
structure EVIIH8ResidualInvariantMapSurjectivityContract
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
  source_to_target_invariant_map_range_eq_top :
    LinearMap.range (sourceToTargetInvariantMap A B) = ⊤

/-- **R651 substantive theorem (4/8)**: the R650 preimage contract gives
the restricted-map-surjectivity contract. -/
def invariantMapSurjectivityContract_of_targetInvariantPreimageContract
    (O : EVIIH8ResidualTargetInvariantPreimageContract A B) :
    EVIIH8ResidualInvariantMapSurjectivityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  source_to_target_invariant_map_range_eq_top :=
    (sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage
      (A := A) (B := B)).2
      O.target_invariant_source_preimage

/-- **R651 substantive theorem (5/8)**: restricted-map surjectivity
rebuilds the R650 element-level preimage contract. -/
def targetInvariantPreimageContract_of_invariantMapSurjectivityContract
    (O : EVIIH8ResidualInvariantMapSurjectivityContract A B) :
    EVIIH8ResidualTargetInvariantPreimageContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariant_source_preimage :=
    (sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage
      (A := A) (B := B)).1
      O.source_to_target_invariant_map_range_eq_top

/-- **R651 substantive theorem (6/8)**: restricted-map surjectivity and
R650 preimages are the same residual package. -/
theorem residual_targetInvariantPreimage_nonempty_iff_invariantMapSurjectivity_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantPreimageContract A B) <->
      Nonempty (EVIIH8ResidualInvariantMapSurjectivityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (invariantMapSurjectivityContract_of_targetInvariantPreimageContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantPreimageContract_of_invariantMapSurjectivityContract
            (A := A) (B := B) O)))

/-- **R651 substantive theorem (7/8)**: the R641 quotient package and the
restricted-map-surjectivity package are equivalent. -/
theorem residual_targetInvariantExcessQuotient_nonempty_iff_invariantMapSurjectivity_nonempty :
    Nonempty (EVIIH8ResidualTargetInvariantExcessQuotientContract A B) <->
      Nonempty (EVIIH8ResidualInvariantMapSurjectivityContract A B) :=
  (residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantPreimage_nonempty
    (A := A) (B := B)).trans
    (residual_targetInvariantPreimage_nonempty_iff_invariantMapSurjectivity_nonempty
      (A := A) (B := B))

end RestrictedInvariantMap

section Obstruction

/-- **R651 substantive theorem (8/8)**: exact image and source-H8 still do
not force surjectivity of the restricted invariant map in the current
abstract interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_invariantMapSurjectivity :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (LinearMap.range
          (sourceToTargetInvariantMap TargetBettiSource TargetBettiTarget) = ⊤) := by
  rcases
    current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantPreimage with
    ⟨hexact, hsource, hnot⟩
  refine ⟨hexact, hsource, ?_⟩
  intro hsurj
  exact hnot
    ((sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage
      (A := TargetBettiSource) (B := TargetBettiTarget)).1 hsurj)

end Obstruction

/-- R651 target names for route summaries. -/
def currentR651InvariantMapSurjectivityTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove LinearMap.range (sourceToTargetInvariantMap) = top"
]

/-- Machine-readable status for the R651 restricted-map target. -/
structure R651InvariantMapSurjectivitySnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  restrictedMapSurjectivityObligationCount : Nat
  quotientVanishingEquivalentToRestrictedMapSurjectivity : Bool
  restrictedMapRangeEqualsInternalSourceImage : Bool
  carriersForceRestrictedMapSurjectivity : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R651 status: the target side is now the range-top theorem for
the restricted invariant Matsushima map. -/
def currentR651InvariantMapSurjectivitySnapshot :
    R651InvariantMapSurjectivitySnapshot where
  proofWorkObligationCount := currentR651InvariantMapSurjectivityTargetNames.length
  exactImageCarrierObligationCount := 2
  restrictedMapSurjectivityObligationCount := 1
  quotientVanishingEquivalentToRestrictedMapSurjectivity := true
  restrictedMapRangeEqualsInternalSourceImage := true
  carriersForceRestrictedMapSurjectivity := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R651 ledger. -/
theorem currentR651InvariantMapSurjectivitySnapshot_eq_texStatus :
    currentR651InvariantMapSurjectivitySnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         restrictedMapSurjectivityObligationCount := 1
         quotientVanishingEquivalentToRestrictedMapSurjectivity := true
         restrictedMapRangeEqualsInternalSourceImage := true
         carriersForceRestrictedMapSurjectivity := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R651InvariantMapSurjectivitySnapshot) := by
  decide

/-- Kernel-checked target names for the R651 ledger. -/
theorem currentR651InvariantMapSurjectivityTargetNames_eq_texStatus :
    currentR651InvariantMapSurjectivityTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove LinearMap.range (sourceToTargetInvariantMap) = top"
    ] := by
  rfl

def R651_substantiveTheoremCount : Nat := 8

end FrontC87_H8ResidualInvariantMapSurjectivity
end HCGapL4
end HodgeReduction
