/-
# HC Gap L4 -- Front C82: Atlas multiplicity criterion (R646).

R645 rewrote the target side to the automorphic upper bound

* `finrank trivialModulePart <= 1`.

The finite Atlas table already proves a different statement: in degree 8,
every contributing `A_q(lambda)` label has to be the trivial label.  That
classification controls labels, not the multiplicity of the trivial label
inside cuspidal cohomology.  This file records that distinction and gives
a kernel-pure sufficient target for the multiplicity bound:

* prove `trivialModulePart` is contained in the `j_q` image of Cartan's
  H8 line.

Since R565 proves that Cartan image is one-dimensional, this containment
implies the R645 upper bound.  No new axiom, EVII instance, or bundled
stronger closure premise is introduced here.
-/

import HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound
import HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank
import HodgeReduction.Infrastructure.Automorphic.AtlasE7minus25

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC82_H8ResidualAtlasMultiplicityCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC24_CartanImageTrivialRank
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC81_H8ResidualTrivialModuleUpperBound

section AtlasAudit

/-- **R646 substantive theorem (1/6)**: the Atlas table does prove the
degree-8 label classification: a label with bottom degree at most 8 is
the trivial label. -/
theorem atlasDeg8Classification_at_degree8 :
    forall q : AtlasParabolicLabel,
      aqLambdaBottomDegree q <= 8 -> aqLambdaIsTrivial q = true :=
  atlas_deg8_vanishing

/-- **R646 substantive theorem (2/6)**: the Atlas degree-8 classification
does not, by itself, bound the multiplicity of the trivial-module part in
the current abstract interface.  The existing countermodel still has exact
image and source-H8, satisfies the finite Atlas label theorem externally,
and has a two-dimensional `trivialModulePart`. -/
theorem atlasDeg8Classification_and_currentInterface_do_not_force_trivialModulePartUpperBound :
    (forall q : AtlasParabolicLabel,
        aqLambdaBottomDegree q <= 8 -> aqLambdaIsTrivial q = true) /\
      sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (Module.finrank (R := Rat)
            (CuspidalCohomologyData.trivialModulePart
              (A := TargetBettiTarget)) <= 1) := by
  exact And.intro
    atlasDeg8Classification_at_degree8
    current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound

end AtlasAudit

section CartanImageCriterion

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
/-- **R646 substantive theorem (3/6)**: containing the cuspidal
trivial-module part in the `j_q` image of Cartan's H8 line is enough for
the one-sided multiplicity bound. -/
theorem trivialModulePart_upper_bound_of_le_cartanImage
    (hle :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CartanCompactDualIso.trivialModuleGK_H8 (A := A))) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  let cartanImage : Submodule Rat B :=
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
  have hline : Module.finrank (R := Rat) cartanImage = 1 := by
    dsimp [cartanImage]
    exact map_cartan_trivialModuleGK_H8_finrank_eq_one (A := A) (B := B)
  haveI : Module.Finite Rat cartanImage :=
    Module.finite_of_finrank_eq_succ
      (R := Rat) (M := cartanImage) (n := 0) hline
  have hmono :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <=
        Module.finrank (R := Rat) cartanImage := by
    exact Submodule.finrank_mono
      (s := CuspidalCohomologyData.trivialModulePart (A := B))
      (t := cartanImage)
      (by simpa [cartanImage] using hle)
  omega

omit [MatsushimaSurjectivityData A B] [MatsushimaCompactDualData A B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R646 substantive theorem (4/6)**: after `source_invariants = H8`,
containment in the source-invariant image is the same sufficient
one-dimensional upper-bound criterion. -/
theorem trivialModulePart_upper_bound_of_le_sourceInvariantImage
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hle :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B))) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 :=
  trivialModulePart_upper_bound_of_le_cartanImage
    (A := A) (B := B)
    (by
      simpa [hsource_H8,
        CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)]
        using hle)

omit [MatsushimaCompactDualData A B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R646 substantive theorem (5/6)**: under the R635 exact-image
carrier and source-H8, the older target containment
`trivialModulePart <= surjectivity_target` is a sufficient route to the
R645 upper bound. -/
theorem trivialModulePart_upper_bound_of_exactImage_sourceH8_targetContainment
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hle :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  apply trivialModulePart_upper_bound_of_le_sourceInvariantImage
    (A := A) (B := B) hsource_H8
  change
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
    at hexact
  rw [hexact]
  exact hle

/-- The R646 sufficient Cartan-image containment package.  It is a
one-way attack route for R645, not an equivalent residual ledger and not
a closure claim. -/
structure EVIIH8ResidualCartanImageUpperBoundContract
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
  trivialModulePart_le_cartanImage :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A))

/-- **R646 substantive theorem (6/6)**: the Cartan-image containment
package feeds the R645 upper-bound contract. -/
def trivialModuleUpperBoundContract_of_cartanImageUpperBoundContract
    (O : EVIIH8ResidualCartanImageUpperBoundContract A B) :
    EVIIH8ResidualTrivialModuleUpperBoundContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_upper_bound :=
    trivialModulePart_upper_bound_of_le_cartanImage
      (A := A) (B := B) O.trivialModulePart_le_cartanImage

end CartanImageCriterion

/-- R646 target names for route summaries. -/
def currentR646AtlasMultiplicityCriterionTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove trivialModulePart <= Submodule.map j_q trivialModuleGK_H8"
]

/-- Machine-readable status for the R646 Atlas/multiplicity audit. -/
structure R646AtlasMultiplicityCriterionSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  cartanImageContainmentObligationCount : Nat
  atlasDeg8ClassificationControlsLabels : Bool
  atlasDeg8ClassificationControlsMultiplicity : Bool
  cartanImageContainmentImpliesUpperBound : Bool
  carrierAndAtlasFactsForceMultiplicity : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R646 status: Atlas controls the low-degree label set, while
the live multiplicity target is a Cartan-image containment theorem. -/
def currentR646AtlasMultiplicityCriterionSnapshot :
    R646AtlasMultiplicityCriterionSnapshot where
  proofWorkObligationCount := currentR646AtlasMultiplicityCriterionTargetNames.length
  exactImageCarrierObligationCount := 2
  cartanImageContainmentObligationCount := 1
  atlasDeg8ClassificationControlsLabels := true
  atlasDeg8ClassificationControlsMultiplicity := false
  cartanImageContainmentImpliesUpperBound := true
  carrierAndAtlasFactsForceMultiplicity := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R646 ledger. -/
theorem currentR646AtlasMultiplicityCriterionSnapshot_eq_texStatus :
    currentR646AtlasMultiplicityCriterionSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         cartanImageContainmentObligationCount := 1
         atlasDeg8ClassificationControlsLabels := true
         atlasDeg8ClassificationControlsMultiplicity := false
         cartanImageContainmentImpliesUpperBound := true
         carrierAndAtlasFactsForceMultiplicity := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R646AtlasMultiplicityCriterionSnapshot) := by
  decide

/-- Kernel-checked target names for the R646 ledger. -/
theorem currentR646AtlasMultiplicityCriterionTargetNames_eq_texStatus :
    currentR646AtlasMultiplicityCriterionTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove trivialModulePart <= Submodule.map j_q trivialModuleGK_H8"
    ] := by
  rfl

def R646_substantiveTheoremCount : Nat := 6

end FrontC82_H8ResidualAtlasMultiplicityCriterion
end HCGapL4
end HodgeReduction
