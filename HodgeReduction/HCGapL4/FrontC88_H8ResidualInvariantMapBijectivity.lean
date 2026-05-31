/-
# HC Gap L4 -- Front C88: restricted invariant map bijectivity (R652).

R651 turned the target quotient gap into surjectivity of the restricted
Matsushima map `source_invariants -> target_invariants`.  This file uses
the existing injectivity field of `j_q` to prove that the restricted map
is injective.  Therefore the remaining target-side theorem is exactly
bijectivity of that restricted invariant map.

This does not close the target gap; it says what a close must now
produce: an onto theorem, equivalently an inverse/bijection for the
restricted Matsushima map.
-/

import HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC88_H8ResidualInvariantMapBijectivity

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC77_H8ResidualTargetInvariantExcessQuotient
open FrontC87_H8ResidualInvariantMapSurjectivity

section RestrictedInvariantMapBijectivity

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
/-- **R652 substantive theorem (1/8)**: the restricted invariant map is
injective because the original Matsushima map `j_q` is injective. -/
theorem sourceToTargetInvariantMap_injective :
    Function.Injective (sourceToTargetInvariantMap A B) := by
  intro alpha gamma h
  apply Subtype.ext
  apply MatsushimaData.j_q_injective (A := A) (B := B)
  exact congrArg Subtype.val h

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R652 substantive theorem (2/8)**: range-top and ordinary function
surjectivity are the same target for the restricted invariant map. -/
theorem sourceToTargetInvariantMap_surjective_iff_range_eq_top :
    Function.Surjective (sourceToTargetInvariantMap A B) <->
      LinearMap.range (sourceToTargetInvariantMap A B) = ⊤ := by
  constructor
  · intro hsurj
    apply le_antisymm
    · exact le_top
    · intro beta _
      rcases hsurj beta with ⟨alpha, hmap⟩
      exact ⟨alpha, hmap⟩
  · intro hrange beta
    have hmem : beta ∈ LinearMap.range (sourceToTargetInvariantMap A B) := by
      rw [hrange]
      trivial
    rcases hmem with ⟨alpha, hmap⟩
    exact ⟨alpha, hmap⟩

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R652 substantive theorem (3/8)**: quotient vanishing is exactly
surjectivity of the restricted invariant map. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_surjective :
    targetInvariantExcessQuotient A B = ⊥ <->
      Function.Surjective (sourceToTargetInvariantMap A B) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_range_eq_top
    (A := A) (B := B)).trans
    (sourceToTargetInvariantMap_surjective_iff_range_eq_top
      (A := A) (B := B)).symm

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R652 substantive theorem (4/8)**: since the restricted map is
already injective, quotient vanishing is exactly bijectivity. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective :
    targetInvariantExcessQuotient A B = ⊥ <->
      Function.Bijective (sourceToTargetInvariantMap A B) := by
  constructor
  · intro hquot
    exact ⟨sourceToTargetInvariantMap_injective (A := A) (B := B),
      (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_surjective
        (A := A) (B := B)).1 hquot⟩
  · intro hbij
    exact
      (targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_surjective
        (A := A) (B := B)).2 hbij.2

/-- The R652 bijectivity spelling of the H8 residual target. -/
structure EVIIH8ResidualInvariantMapBijectivityContract
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
  source_to_target_invariant_map_bijective :
    Function.Bijective (sourceToTargetInvariantMap A B)

/-- **R652 substantive theorem (5/8)**: restricted-map surjectivity gives
the bijectivity contract because injectivity is formal from `j_q`. -/
def invariantMapBijectivityContract_of_invariantMapSurjectivityContract
    (O : EVIIH8ResidualInvariantMapSurjectivityContract A B) :
    EVIIH8ResidualInvariantMapBijectivityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  source_to_target_invariant_map_bijective :=
    ⟨sourceToTargetInvariantMap_injective (A := A) (B := B),
      (sourceToTargetInvariantMap_surjective_iff_range_eq_top
        (A := A) (B := B)).2
        O.source_to_target_invariant_map_range_eq_top⟩

/-- **R652 substantive theorem (6/8)**: the bijectivity contract rebuilds
the restricted-map-surjectivity contract. -/
def invariantMapSurjectivityContract_of_invariantMapBijectivityContract
    (O : EVIIH8ResidualInvariantMapBijectivityContract A B) :
    EVIIH8ResidualInvariantMapSurjectivityContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  source_to_target_invariant_map_range_eq_top :=
    (sourceToTargetInvariantMap_surjective_iff_range_eq_top
      (A := A) (B := B)).1
      O.source_to_target_invariant_map_bijective.2

/-- **R652 substantive theorem (7/8)**: R651 surjectivity and R652
bijectivity are the same residual package. -/
theorem residual_invariantMapSurjectivity_nonempty_iff_invariantMapBijectivity_nonempty :
    Nonempty (EVIIH8ResidualInvariantMapSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualInvariantMapBijectivityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (invariantMapBijectivityContract_of_invariantMapSurjectivityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (invariantMapSurjectivityContract_of_invariantMapBijectivityContract
            (A := A) (B := B) O)))

end RestrictedInvariantMapBijectivity

section Obstruction

/-- **R652 substantive theorem (8/8)**: exact image and source-H8 still do
not force bijectivity of the restricted invariant map in the current
abstract interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_invariantMapBijectivity :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget ∧
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) ∧
      Not
        (Function.Bijective
          (sourceToTargetInvariantMap TargetBettiSource TargetBettiTarget)) := by
  rcases
    current_interface_with_exactImage_sourceH8_does_not_force_invariantMapSurjectivity with
    ⟨hexact, hsource, hnot⟩
  refine ⟨hexact, hsource, ?_⟩
  intro hbij
  exact hnot
    ((sourceToTargetInvariantMap_surjective_iff_range_eq_top
      (A := TargetBettiSource) (B := TargetBettiTarget)).1 hbij.2)

end Obstruction

/-- R652 target names for route summaries. -/
def currentR652InvariantMapBijectivityTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove Function.Bijective sourceToTargetInvariantMap"
]

/-- Machine-readable status for the R652 restricted-map bijectivity target. -/
structure R652InvariantMapBijectivitySnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  restrictedMapBijectivityObligationCount : Nat
  restrictedMapInjectiveFromJq : Bool
  quotientVanishingEquivalentToRestrictedMapBijectivity : Bool
  carriersForceRestrictedMapBijectivity : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R652 status: the remaining target side is bijectivity of the
restricted invariant Matsushima map, with injectivity already closed. -/
def currentR652InvariantMapBijectivitySnapshot :
    R652InvariantMapBijectivitySnapshot where
  proofWorkObligationCount := currentR652InvariantMapBijectivityTargetNames.length
  exactImageCarrierObligationCount := 2
  restrictedMapBijectivityObligationCount := 1
  restrictedMapInjectiveFromJq := true
  quotientVanishingEquivalentToRestrictedMapBijectivity := true
  carriersForceRestrictedMapBijectivity := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R652 ledger. -/
theorem currentR652InvariantMapBijectivitySnapshot_eq_texStatus :
    currentR652InvariantMapBijectivitySnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         restrictedMapBijectivityObligationCount := 1
         restrictedMapInjectiveFromJq := true
         quotientVanishingEquivalentToRestrictedMapBijectivity := true
         carriersForceRestrictedMapBijectivity := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R652InvariantMapBijectivitySnapshot) := by
  decide

/-- Kernel-checked target names for the R652 ledger. -/
theorem currentR652InvariantMapBijectivityTargetNames_eq_texStatus :
    currentR652InvariantMapBijectivityTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove Function.Bijective sourceToTargetInvariantMap"
    ] := by
  rfl

def R652_substantiveTheoremCount : Nat := 8

end FrontC88_H8ResidualInvariantMapBijectivity
end HCGapL4
end HodgeReduction
