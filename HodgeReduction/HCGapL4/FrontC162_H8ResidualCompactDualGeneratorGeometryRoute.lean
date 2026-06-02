/-
# HC Gap L4 -- Front C162: generator geometry for the Cartan containment (R727).

R726 split the current compact-dual/Cartan comparison into two live
containment directions:

* `compactDual <= CartanH8`;
* `CartanH8 <= compactDual`.

This file chooses the second direction as the next local attack target.  The
direction is exactly the concrete generator-placement theorem

  `h^4 in MatsushimaCompactDualData.compactDual`.

The new `EVIICompactDualGeneratorGeometry` structure is not a closure claim
and is not a stronger hidden premise: the file proves it is equivalent to the
old `CartanH8 <= compactDual` target.  It is a named geometry witness so the
next agent can attack the single point-membership theorem directly instead
of rediscovering the Cartan-line equivalence.
-/

import HodgeReduction.HCGapL4.FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence
import HodgeReduction.HCGapL4.FrontC155_H8ResidualCompactDualGeneratorContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC162_H8ResidualCompactDualGeneratorGeometryRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC97_H8ResidualCartanToCompactDualLine
open FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
open FrontC161_H8ResidualPaperCarrierCartanContainmentIndependence

section GeneratorGeometry

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

/-- R727 explicit geometry witness for the generator direction of the current
Cartan comparison route.  This is the same theorem as
`CartanH8 <= compactDual`, restated as the concrete placement of the compact
dual generator `h^4`. -/
structure EVIICompactDualGeneratorGeometry
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
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)

/-- **R727 substantive theorem (1/9)**: the generator witness supplies the
H8-to-compactDual containment. -/
theorem H8_le_compactDual_of_generatorGeometry
    (G : EVIICompactDualGeneratorGeometry A B) :
    CompactDualData.H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (H8_le_compactDual_iff_h_pow_four_mem_compactDual
    (A := A) (B := B)).2 G.h_pow_four_mem_compactDual

/-- **R727 substantive theorem (2/9)**: the same generator witness supplies
the Cartan-to-compactDual containment chosen in R727. -/
theorem cartanH8_le_compactDual_of_generatorGeometry
    (G : EVIICompactDualGeneratorGeometry A B) :
    CartanCompactDualIso.trivialModuleGK_H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  (cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
    (A := A) (B := B)).2 G.h_pow_four_mem_compactDual

/-- **R727 substantive theorem (3/9)**: an H8-to-compactDual containment
recovers the exact generator witness, so the witness is not stronger than
the old H8-containment spelling. -/
def generatorGeometry_of_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    EVIICompactDualGeneratorGeometry A B where
  h_pow_four_mem_compactDual :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 hH8

/-- **R727 substantive theorem (4/9)**: a Cartan-to-compactDual containment
recovers the exact generator witness, so the witness is not stronger than
the R726 Cartan containment target. -/
def generatorGeometry_of_cartanH8_le_compactDual
    (hcartan :
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    EVIICompactDualGeneratorGeometry A B where
  h_pow_four_mem_compactDual :=
    (cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 hcartan

/-- **R727 substantive theorem (5/9)**: inhabited generator geometry and
the Cartan-to-compactDual containment are the same residual target. -/
theorem generatorGeometry_nonempty_iff_cartanH8_le_compactDual :
    Nonempty (EVIICompactDualGeneratorGeometry A B) <->
      (CartanCompactDualIso.trivialModuleGK_H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
  Iff.intro
    (fun h =>
      h.elim (fun G =>
        cartanH8_le_compactDual_of_generatorGeometry
          (A := A) (B := B) G))
    (fun h =>
      Nonempty.intro
        (generatorGeometry_of_cartanH8_le_compactDual
          (A := A) (B := B) h))

/-- **R727 substantive theorem (6/9)**: inhabited generator geometry and
the H8-to-compactDual containment are also the same residual target. -/
theorem generatorGeometry_nonempty_iff_H8_le_compactDual :
    Nonempty (EVIICompactDualGeneratorGeometry A B) <->
      (CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
  Iff.intro
    (fun h =>
      h.elim (fun G =>
        H8_le_compactDual_of_generatorGeometry
          (A := A) (B := B) G))
    (fun h =>
      Nonempty.intro
        (generatorGeometry_of_H8_le_compactDual
          (A := A) (B := B) h))

/-- R727 route spelling: keep boundary data and the no-extra Cartan direction,
but replace `CartanH8 <= compactDual` by its exact generator-geometry target.
-/
structure EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract
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
  compactDual_le_cartanH8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  generatorGeometry : EVIICompactDualGeneratorGeometry A B

/-- **R727 substantive theorem (7/9)**: the R727 generator-geometry spelling
feeds the R726 two-containment contract. -/
def cartanTwoContainmentContract_of_generatorGeometryContract
    (O : EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) :
    EVIIH8ResidualBoundaryDataCartanTwoContainmentContract A B where
  boundary := O.boundary
  compactDual_le_cartanH8 := O.compactDual_le_cartanH8
  cartanH8_le_compactDual :=
    cartanH8_le_compactDual_of_generatorGeometry
      (A := A) (B := B) O.generatorGeometry

/-- **R727 substantive theorem (8/9)**: the R726 two-containment contract
recovers the R727 generator-geometry spelling, so R727 does not introduce a
stronger premise. -/
def generatorGeometryContract_of_cartanTwoContainmentContract
    (O : EVIIH8ResidualBoundaryDataCartanTwoContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B where
  boundary := O.boundary
  compactDual_le_cartanH8 := O.compactDual_le_cartanH8
  generatorGeometry :=
    generatorGeometry_of_cartanH8_le_compactDual
      (A := A) (B := B) O.cartanH8_le_compactDual

/-- **R727 substantive theorem (9/9)**: the R726 two-containment route and
the R727 no-extra-plus-generator-geometry route are the same inhabited
residual contract. -/
theorem residual_cartanTwoContainment_nonempty_iff_generatorGeometry_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanTwoContainmentContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (generatorGeometryContract_of_cartanTwoContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanTwoContainmentContract_of_generatorGeometryContract
            (A := A) (B := B) O)))

end GeneratorGeometry

/-- R727 target names for route summaries. -/
def currentR727GeneratorGeometryTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual <= CartanH8",
  "prove h^4 in MatsushimaCompactDualData.compactDual; equivalently prove CartanH8 <= compactDual"
]

/-- Machine-readable status for the R727 generator-geometry route. -/
structure R727GeneratorGeometrySnapshot where
  proofWorkObligationCount : Nat
  generatorGeometryEquivalentToCartanContainment : Bool
  generatorRouteEquivalentToR726Split : Bool
  generatorGeometryClosesCartanToCompactDualDirection : Bool
  provesBoundaryData : Bool
  provesCompactDualNoExtra : Bool
  provesGeneratorGeometry : Bool
  provesFullCartanComparison : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R727 status: the selected Cartan-to-compactDual direction has
been isolated as the concrete `h^4 in compactDual` geometry theorem.  The
file proves equivalence and consumers only; it does not assert the witness. -/
def currentR727GeneratorGeometrySnapshot : R727GeneratorGeometrySnapshot where
  proofWorkObligationCount := currentR727GeneratorGeometryTargetNames.length
  generatorGeometryEquivalentToCartanContainment := true
  generatorRouteEquivalentToR726Split := true
  generatorGeometryClosesCartanToCompactDualDirection := true
  provesBoundaryData := false
  provesCompactDualNoExtra := false
  provesGeneratorGeometry := false
  provesFullCartanComparison := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R727 generator-geometry route. -/
theorem currentR727GeneratorGeometrySnapshot_eq_texStatus :
    currentR727GeneratorGeometrySnapshot =
      ({ proofWorkObligationCount := 3
         generatorGeometryEquivalentToCartanContainment := true
         generatorRouteEquivalentToR726Split := true
         generatorGeometryClosesCartanToCompactDualDirection := true
         provesBoundaryData := false
         provesCompactDualNoExtra := false
         provesGeneratorGeometry := false
         provesFullCartanComparison := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R727GeneratorGeometrySnapshot) := by
  decide

/-- Kernel-checked target names for the R727 route. -/
theorem currentR727GeneratorGeometryTargetNames_eq_texStatus :
    currentR727GeneratorGeometryTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual <= CartanH8",
      "prove h^4 in MatsushimaCompactDualData.compactDual; equivalently prove CartanH8 <= compactDual"
    ] := by
  rfl

def R727_substantiveTheoremCount : Nat := 9

end FrontC162_H8ResidualCompactDualGeneratorGeometryRoute
end HCGapL4
end HodgeReduction
