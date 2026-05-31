/-
# HC Gap L4 -- Front C83: Cartan-image containment as scalar preimages (R647).

R646 exposed a sufficient target for the multiplicity upper bound:

* `trivialModulePart <= Submodule.map j_q trivialModuleGK_H8`.

This file removes the last submodule wrapper around that target.  Since
Cartan's H8 line is `span {h^4}`, the containment is exactly the
element-level scalar-preimage theorem:

* every `beta` in `trivialModulePart` is `j_q (r • h^4)` for some
  `r : Rat`.

This is a target normalization only.  It does not prove the scalar
preimage theorem for EVII and does not close full HC.
-/

import HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC83_H8ResidualCartanImageScalarPreimage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC81_H8ResidualTrivialModuleUpperBound
open FrontC82_H8ResidualAtlasMultiplicityCriterion

section CartanImageScalar

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

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R647 substantive theorem (1/6)**: the R646 Cartan-image containment
target is exactly the element-level scalar-preimage theorem from the H8
generator. -/
theorem trivialModulePart_le_cartanImage_iff_scalar_preimage :
    (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) <->
      (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) := by
  constructor
  · intro hle beta hbeta
    have hbeta_image :
        beta ∈
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :=
      hle hbeta
    obtain ⟨alpha, halpha_cartan, halpha_beta⟩ := hbeta_image
    have halpha_H8 : alpha ∈ CompactDualData.H8 (A := A) := by
      rw [<- CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
      exact halpha_cartan
    rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)] at halpha_H8
    rw [Submodule.mem_span_singleton] at halpha_H8
    obtain ⟨r, hr⟩ := halpha_H8
    refine ⟨r, ?_⟩
    rw [hr]
    exact halpha_beta
  · intro hscalar beta hbeta
    obtain ⟨r, hr⟩ := hscalar beta hbeta
    refine ⟨r • ((KaehlerClass.h : A) ^ 4), ?_, hr⟩
    have hh4_H8 :
        ((KaehlerClass.h : A) ^ 4) ∈ CompactDualData.H8 (A := A) := by
      rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
      exact Submodule.subset_span (by simp)
    have hh4_cartan :
        ((KaehlerClass.h : A) ^ 4) ∈
          CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
      rw [CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
      exact hh4_H8
    exact Submodule.smul_mem _ r hh4_cartan

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R647 substantive theorem (2/6)**: the scalar-preimage theorem
therefore implies the R645 multiplicity upper bound through R646. -/
theorem trivialModulePart_upper_bound_of_cartan_scalar_preimage
    (hscalar :
      forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 :=
  trivialModulePart_upper_bound_of_le_cartanImage
    (A := A) (B := B)
    ((trivialModulePart_le_cartanImage_iff_scalar_preimage
      (A := A) (B := B)).2 hscalar)

/-- The R647 scalar-preimage spelling of the sufficient R646 route. -/
structure EVIIH8ResidualCartanScalarUpperBoundContract
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
  cartan_scalar_preimage :
    forall beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
        exists r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta

/-- **R647 substantive theorem (3/6)**: scalar-preimage contract gives the
R646 Cartan-image containment contract. -/
def cartanImageUpperBoundContract_of_cartanScalarUpperBoundContract
    (O : EVIIH8ResidualCartanScalarUpperBoundContract A B) :
    EVIIH8ResidualCartanImageUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_le_cartanImage :=
    (trivialModulePart_le_cartanImage_iff_scalar_preimage
      (A := A) (B := B)).2 O.cartan_scalar_preimage

/-- **R647 substantive theorem (4/6)**: the Cartan-image containment
contract gives the scalar-preimage contract. -/
def cartanScalarUpperBoundContract_of_cartanImageUpperBoundContract
    (O : EVIIH8ResidualCartanImageUpperBoundContract A B) :
    EVIIH8ResidualCartanScalarUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  cartan_scalar_preimage :=
    (trivialModulePart_le_cartanImage_iff_scalar_preimage
      (A := A) (B := B)).1 O.trivialModulePart_le_cartanImage

/-- **R647 substantive theorem (5/6)**: the R646 containment contract and
R647 scalar-preimage contract are equivalent sufficient attack routes. -/
theorem residual_cartanScalar_nonempty_iff_cartanImage_nonempty :
    Nonempty (EVIIH8ResidualCartanScalarUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualCartanImageUpperBoundContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanImageUpperBoundContract_of_cartanScalarUpperBoundContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanScalarUpperBoundContract_of_cartanImageUpperBoundContract
            (A := A) (B := B) O)))

end CartanImageScalar

section Obstruction

/-- **R647 substantive theorem (6/6)**: exact image, source-H8, and the
Atlas degree-8 label classification still do not force the scalar-preimage
target in the current abstract interface.  The missing theorem is a real
Matsushima/EVII multiplicity statement. -/
theorem current_interface_with_atlas_does_not_force_cartan_scalar_preimage :
    (forall q : AtlasParabolicLabel,
        aqLambdaBottomDegree q <= 8 -> aqLambdaIsTrivial q = true) /\
      sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (forall beta : TargetBettiTarget,
          beta ∈ CuspidalCohomologyData.trivialModulePart
              (A := TargetBettiTarget) ->
            exists r : Rat,
              MatsushimaData.j_q
                  (A := TargetBettiSource) (B := TargetBettiTarget)
                (r • ((KaehlerClass.h : TargetBettiSource) ^ 4)) = beta) := by
  refine And.intro atlasDeg8Classification_at_degree8 ?_
  refine And.intro
    current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound.1 ?_
  refine And.intro
    current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound.2.1 ?_
  intro hscalar
  exact
    current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound.2.2
      (trivialModulePart_upper_bound_of_cartan_scalar_preimage
        (A := TargetBettiSource) (B := TargetBettiTarget) hscalar)

end Obstruction

/-- R647 target names for route summaries. -/
def currentR647CartanScalarTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta"
]

/-- Machine-readable status for the R647 Cartan scalar-preimage ledger. -/
structure R647CartanScalarSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  cartanScalarPreimageObligationCount : Nat
  cartanImageContainmentEquivalentToScalarPreimage : Bool
  scalarPreimageImpliesMultiplicityUpperBound : Bool
  carrierAndAtlasFactsForceScalarPreimage : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R647 status: the R646 containment target is now an element-level
scalar-preimage theorem. -/
def currentR647CartanScalarSnapshot :
    R647CartanScalarSnapshot where
  proofWorkObligationCount := currentR647CartanScalarTargetNames.length
  exactImageCarrierObligationCount := 2
  cartanScalarPreimageObligationCount := 1
  cartanImageContainmentEquivalentToScalarPreimage := true
  scalarPreimageImpliesMultiplicityUpperBound := true
  carrierAndAtlasFactsForceScalarPreimage := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R647 ledger. -/
theorem currentR647CartanScalarSnapshot_eq_texStatus :
    currentR647CartanScalarSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         cartanScalarPreimageObligationCount := 1
         cartanImageContainmentEquivalentToScalarPreimage := true
         scalarPreimageImpliesMultiplicityUpperBound := true
         carrierAndAtlasFactsForceScalarPreimage := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R647CartanScalarSnapshot) := by
  decide

/-- Kernel-checked target names for the R647 ledger. -/
theorem currentR647CartanScalarTargetNames_eq_texStatus :
    currentR647CartanScalarTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta"
    ] := by
  rfl

def R647_substantiveTheoremCount : Nat := 6

end FrontC83_H8ResidualCartanImageScalarPreimage
end HCGapL4
end HodgeReduction
