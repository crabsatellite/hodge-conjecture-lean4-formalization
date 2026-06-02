/-
# HC Gap L4 -- Front C168: no-extra containment as target line (R733).

R731 exposes the current residual route as:

* `MatsushimaV56BoundaryData`;
* `compactDual <= H8`;
* `H8 <= compactDual`.

R733 keeps the generator containment `H8 <= compactDual` explicit and
rewrites the other direction.  Under boundary data and `H8 <= compactDual`,
the no-extra containment `compactDual <= H8` is exactly the target-side line
containment

  `trivialModulePart <= span {j_q(h^4)}`.

This does not prove either target.  It gives the next no-extra attack a
concrete target-side form, tied to the existing multiplicity/scalar-preimage
frontier, without adding a stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC166_H8ResidualCurrentCompactDualTwoContainmentRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC168_H8ResidualNoExtraTargetLineEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
open FrontC164_H8ResidualCurrentGeneratorLineRoute
open FrontC165_H8ResidualCurrentCompactDualGeneratorLineRoute
open FrontC166_H8ResidualCurrentCompactDualTwoContainmentRoute

section NoExtraTargetLine

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

/-- Boundary data, the generator containment `H8 <= compactDual`, and the
target-line containment.  R733 proves this is equivalent to the direct R731
two-containment route. -/
structure EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract
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
  H8_le_compactDual :
    CompactDualData.H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R733 substantive theorem (1/7)**: boundary data, generator containment,
and target-line containment imply the no-extra compact-dual containment. -/
theorem compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
    (D : MatsushimaV56BoundaryData A B)
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
      CompactDualData.H8 (A := A) := by
  let O : EVIIH8ResidualBoundaryDataCompactDualGeneratorLineContract A B :=
    { boundary := D
      h_pow_four_mem_compactDual :=
        (H8_le_compactDual_iff_h_pow_four_mem_compactDual
          (A := A) (B := B)).1 hH8
      trivialModulePart_le_h_pow_four_line := hline }
  exact
    compactDual_le_H8_of_compactDualGeneratorLineContract
      (A := A) (B := B) O

/-- **R733 substantive theorem (2/7)**: conversely, boundary data plus the two
compact-dual containments recover the target-line containment. -/
theorem targetLine_of_boundary_H8_le_compactDual_compactDual_le_H8
    (D : MatsushimaV56BoundaryData A B)
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
        CompactDualData.H8 (A := A)) :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  let O : EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B :=
    { boundary := D
      compactDual_le_H8 := hcompact
      H8_le_compactDual := hH8 }
  exact
    (compactDualGeneratorLineContract_of_boundaryDataCompactDualTwoContainmentContract
      (A := A) (B := B) O).trivialModulePart_le_h_pow_four_line

/-- **R733 substantive theorem (3/7)**: after boundary data and the generator
containment `H8 <= compactDual` are fixed, no-extra compact-dual containment
is equivalent to the target-line containment. -/
theorem compactDual_le_H8_iff_targetLine_under_boundary_H8_le_compactDual
    (D : MatsushimaV56BoundaryData A B)
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
        CompactDualData.H8 (A := A)) <->
      (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :=
  Iff.intro
    (fun hcompact =>
      targetLine_of_boundary_H8_le_compactDual_compactDual_le_H8
        (A := A) (B := B) D hH8 hcompact)
    (fun hline =>
      compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
        (A := A) (B := B) D hH8 hline)

/-- **R733 substantive theorem (4/7)**: the H8-containment plus target-line
contract feeds the R731 direct two-containment route. -/
def boundaryDataCompactDualTwoContainmentContract_of_H8ContainmentTargetLineContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B where
  boundary := O.boundary
  compactDual_le_H8 :=
    compactDual_le_H8_of_boundary_H8_le_compactDual_targetLine
      (A := A) (B := B)
      O.boundary O.H8_le_compactDual O.trivialModulePart_le_h_pow_four_line
  H8_le_compactDual := O.H8_le_compactDual

/-- **R733 substantive theorem (5/7)**: the R731 direct two-containment route
recovers the equivalent H8-containment plus target-line route. -/
def H8ContainmentTargetLineContract_of_boundaryDataCompactDualTwoContainmentContract
    (O : EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    targetLine_of_boundary_H8_le_compactDual_compactDual_le_H8
      (A := A) (B := B)
      O.boundary O.H8_le_compactDual O.compactDual_le_H8

/-- **R733 substantive theorem (6/7)**: the R731 direct two-containment route
and the H8-containment plus target-line route are the same inhabited residual
contract. -/
theorem residual_boundaryDataCompactDualTwoContainment_nonempty_iff_H8ContainmentTargetLine_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataCompactDualTwoContainmentContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentTargetLineContract_of_boundaryDataCompactDualTwoContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualTwoContainmentContract_of_H8ContainmentTargetLineContract
            (A := A) (B := B) O)))

/-- **R733 substantive theorem (7/7)**: the current R727--R731 route can be
attacked as boundary data, `H8 <= compactDual`, and the target-line
containment. -/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentTargetLine_nonempty :
    Nonempty (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_boundaryDataCompactDualTwoContainment_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryDataCompactDualTwoContainment_nonempty_iff_H8ContainmentTargetLine_nonempty
      (A := A) (B := B))

end NoExtraTargetLine

/-- R733 target names for route summaries. -/
def currentR733NoExtraTargetLineTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}; equivalently prove compactDual <= H8 after boundary and H8 containment"
]

/-- Machine-readable status for the R733 no-extra/target-line equivalence. -/
structure R733NoExtraTargetLineSnapshot where
  proofWorkObligationCount : Nat
  noExtraEquivalentToTargetLineUnderBoundaryAndGenerator : Bool
  currentRouteEquivalentToH8ContainmentPlusTargetLine : Bool
  targetLineConnectsToMultiplicityFrontier : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesTargetLineContainment : Bool
  provesCompactDualNoExtra : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R733 status: once boundary data and the generator containment are
fixed, the no-extra containment is exactly the target-line theorem. -/
def currentR733NoExtraTargetLineSnapshot :
    R733NoExtraTargetLineSnapshot where
  proofWorkObligationCount := currentR733NoExtraTargetLineTargetNames.length
  noExtraEquivalentToTargetLineUnderBoundaryAndGenerator := true
  currentRouteEquivalentToH8ContainmentPlusTargetLine := true
  targetLineConnectsToMultiplicityFrontier := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesTargetLineContainment := false
  provesCompactDualNoExtra := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R733 no-extra/target-line equivalence. -/
theorem currentR733NoExtraTargetLineSnapshot_eq_texStatus :
    currentR733NoExtraTargetLineSnapshot =
      ({ proofWorkObligationCount := 3
         noExtraEquivalentToTargetLineUnderBoundaryAndGenerator := true
         currentRouteEquivalentToH8ContainmentPlusTargetLine := true
         targetLineConnectsToMultiplicityFrontier := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesTargetLineContainment := false
         provesCompactDualNoExtra := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R733NoExtraTargetLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R733 route. -/
theorem currentR733NoExtraTargetLineTargetNames_eq_texStatus :
    currentR733NoExtraTargetLineTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}; equivalently prove compactDual <= H8 after boundary and H8 containment"
    ] := by
  rfl

def R733_substantiveTheoremCount : Nat := 7

end FrontC168_H8ResidualNoExtraTargetLineEquivalence
end HCGapL4
end HodgeReduction
