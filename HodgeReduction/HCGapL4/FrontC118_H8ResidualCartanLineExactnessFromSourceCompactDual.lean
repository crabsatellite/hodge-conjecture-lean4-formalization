/-
# HC Gap L4 -- Front C118: Cartan-line exactness from the source route (R682).

R681 leaves three geometric targets:

* `surjectivity_source = compactDual`;
* `CartanH8 <= compactDual`;
* `trivialModulePart <= span {j_q(h^4)}`.

This file proves that those three targets are exactly equivalent to the older
Cartan-line exactness package:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* `Submodule.map j_q CartanH8 = trivialModulePart`.

The point is not to close the theorem.  It removes ambiguity about the next
mathematical attack surface: proving the R681 route is the same as proving
that the Matsushima source, compact-dual carrier, and target image are all
the explicit Cartan H8 line.
-/

import HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage
import HodgeReduction.HCGapL4.FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC25_CartanLineBoundaryExactness
open FrontC27_CartanImageScalarPreimage
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence
open FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence

section CartanLineExactnessFromR681

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

omit [MatsushimaSurjectivityData A B] in
/-- **R682 substantive theorem (1/8)**: the R681 Cartan containment plus the
target line theorem identify the compact-dual carrier with Cartan H8. -/
theorem compactDual_eq_cartanH8_of_cartanH8_le_compactDual_and_targetLine
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hline :
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
  exact
    le_antisymm
      (compactDual_le_cartanH8_of_cartanH8_le_compactDual_and_targetLine
        (A := A) (B := B) hcartan hline)
      hcartan

/-- **R682 substantive theorem (2/8)**: the R681 route identifies the
Matsushima surjectivity source with the same Cartan H8 line. -/
theorem source_eq_cartanH8_of_source_eq_compactDual_cartanH8_le_compactDual_and_targetLine
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hline :
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) := hsource
    _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        compactDual_eq_cartanH8_of_cartanH8_le_compactDual_and_targetLine
          (A := A) (B := B) hcartan hline

omit [MatsushimaSurjectivityData A B] in
/-- **R682 substantive theorem (3/8)**: the R681 target-line theorem is
exact Cartan-image equality once the Cartan/compact-dual carrier is fixed. -/
theorem cartan_image_eq_trivialModulePart_of_cartanH8_le_compactDual_and_targetLine
    (hcartan :
      LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)))
    (hline :
      LE.le
        (CuspidalCohomologyData.trivialModulePart (A := B))
        (Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)})) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  have hcompact_cartan :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
    compactDual_eq_cartanH8_of_cartanH8_le_compactDual_and_targetLine
      (A := A) (B := B) hcartan hline
  have hscalar :
      forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta :=
    (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B)).2 hline
  exact
    (cartan_image_eq_trivialModulePart_iff_scalar_preimage
      (A := A) (B := B) hcompact_cartan).2 hscalar

end CartanLineExactnessFromR681

section CartanLineExactnessContract

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

/-- The R682 Cartan-line exactness spelling of the R681 route. -/
structure EVIIH8ResidualCartanLineExactnessContract where
  source_eq_cartanH8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  compactDual_eq_cartanH8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  cartan_image_eq_trivialModulePart :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B)

variable {A B}

/-- **R682 substantive theorem (4/8)**: the R681 route gives the concrete
Cartan-line exactness package. -/
def cartanLineExactnessContract_of_sourceCompactDualCartanLineThreeTargetContract
    (O : EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) :
    EVIIH8ResidualCartanLineExactnessContract A B where
  source_eq_cartanH8 :=
    source_eq_cartanH8_of_source_eq_compactDual_cartanH8_le_compactDual_and_targetLine
      (A := A) (B := B)
      O.source_eq_compactDual
      O.cartanH8_le_compactDual
      O.trivialModulePart_le_h_pow_four_line
  compactDual_eq_cartanH8 :=
    compactDual_eq_cartanH8_of_cartanH8_le_compactDual_and_targetLine
      (A := A) (B := B)
      O.cartanH8_le_compactDual
      O.trivialModulePart_le_h_pow_four_line
  cartan_image_eq_trivialModulePart :=
    cartan_image_eq_trivialModulePart_of_cartanH8_le_compactDual_and_targetLine
      (A := A) (B := B)
      O.cartanH8_le_compactDual
      O.trivialModulePart_le_h_pow_four_line

/-- **R682 substantive theorem (5/8)**: Cartan-line exactness recovers the
R681 source-compactDual route. -/
def sourceCompactDualCartanLineThreeTargetContract_of_cartanLineExactnessContract
    (O : EVIIH8ResidualCartanLineExactnessContract A B) :
    EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B where
  source_eq_compactDual :=
    source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan
      (A := A) (B := B)
      O.source_eq_cartanH8
      O.compactDual_eq_cartanH8
  cartanH8_le_compactDual := by
    rw [O.compactDual_eq_cartanH8]
  trivialModulePart_le_h_pow_four_line :=
    (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
      (A := A) (B := B)).1
      ((cartan_image_eq_trivialModulePart_iff_scalar_preimage
        (A := A) (B := B) O.compactDual_eq_cartanH8).1
        O.cartan_image_eq_trivialModulePart)

/-- **R682 substantive theorem (6/8)**: the R681 source-compactDual route and
the Cartan-line exactness route are equivalent at the inhabited-contract
level. -/
theorem residual_sourceCompactDualCartanLineThreeTarget_nonempty_iff_cartanLineExactness_nonempty :
    Nonempty (EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) <->
      Nonempty (EVIIH8ResidualCartanLineExactnessContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanLineExactnessContract_of_sourceCompactDualCartanLineThreeTargetContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceCompactDualCartanLineThreeTargetContract_of_cartanLineExactnessContract
            (A := A) (B := B) O)))

/-- **R682 substantive theorem (7/8)**: Cartan-line exactness is still the
current target-line residual, not a stronger premise. -/
theorem residual_cartanLineExactness_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualCartanLineExactnessContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_sourceCompactDualCartanLineThreeTarget_nonempty_iff_cartanLineExactness_nonempty
    (A := A) (B := B)).symm.trans
    (residual_sourceCompactDualCartanLineThreeTarget_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R682 substantive theorem (8/8)**: Cartan-line exactness is also
equivalent to the boundary-data/compact-dual-H8 route. -/
theorem residual_cartanLineExactness_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualCartanLineExactnessContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_cartanLineExactness_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end CartanLineExactnessContract

/-- Exact R682 target names for route summaries. -/
def currentR682CartanLineExactnessTargetNames : List String := [
  "prove surjectivity_source = CartanH8",
  "prove compactDual = CartanH8",
  "prove Submodule.map j_q CartanH8 = trivialModulePart"
]

/-- Machine-readable status for the R682 Cartan-line exactness route. -/
structure R682CartanLineExactnessSnapshot where
  proofWorkObligationCount : Nat
  sourceCompactDualRouteEquivalentToCartanLineExactness : Bool
  cartanLineExactnessEquivalentToTargetLine : Bool
  cartanLineExactnessEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesSourceCartan : Bool
  provesCompactDualCartan : Bool
  provesCartanImageExactness : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R682 status: all three R681 targets have been recast as Cartan
line exactness statements, but none is proved here. -/
def currentR682CartanLineExactnessSnapshot :
    R682CartanLineExactnessSnapshot where
  proofWorkObligationCount := currentR682CartanLineExactnessTargetNames.length
  sourceCompactDualRouteEquivalentToCartanLineExactness := true
  cartanLineExactnessEquivalentToTargetLine := true
  cartanLineExactnessEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesSourceCartan := false
  provesCompactDualCartan := false
  provesCartanImageExactness := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R682 ledger. -/
theorem currentR682CartanLineExactnessSnapshot_eq_texStatus :
    currentR682CartanLineExactnessSnapshot =
      ({ proofWorkObligationCount := 3
         sourceCompactDualRouteEquivalentToCartanLineExactness := true
         cartanLineExactnessEquivalentToTargetLine := true
         cartanLineExactnessEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesSourceCartan := false
         provesCompactDualCartan := false
         provesCartanImageExactness := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R682CartanLineExactnessSnapshot) := by
  decide

/-- Kernel-checked target names for the R682 Cartan-line exactness route. -/
theorem currentR682CartanLineExactnessTargetNames_eq_texStatus :
    currentR682CartanLineExactnessTargetNames = [
      "prove surjectivity_source = CartanH8",
      "prove compactDual = CartanH8",
      "prove Submodule.map j_q CartanH8 = trivialModulePart"
    ] := by
  rfl

def R682_substantiveTheoremCount : Nat := 8

end FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual
end HCGapL4
end HodgeReduction
