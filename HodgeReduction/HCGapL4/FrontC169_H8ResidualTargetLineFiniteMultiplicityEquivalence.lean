/-
# HC Gap L4 -- Front C169: target line as finite trivial multiplicity (R734).

R733 rewrites the current no-extra compact-dual target as

  `trivialModulePart <= span {j_q(h^4)}`

after boundary data and the generator containment `H8 <= compactDual`.
This file pushes that target to the multiplicity frontier.  Under the same
`H8 <= compactDual` hypothesis, the generator `j_q(h^4)` already lies in
`trivialModulePart`, so line containment is equivalent to the finite
rank-one statement

  finite-dimensional `trivialModulePart`
  and `finrank trivialModulePart <= 1`.

No finite-multiplicity theorem is proved here.  The point is to make the next
automorphic target explicit without adding a stronger premise or hiding the
finite-dimensional witness.
-/

import HodgeReduction.HCGapL4.FrontC168_H8ResidualNoExtraTargetLineEquivalence
import HodgeReduction.HCGapL4.FrontC127_H8ResidualLineContainmentExplicitFiniteRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC123_H8ResidualGeneratorMultiplicityRoute
open FrontC127_H8ResidualLineContainmentExplicitFiniteRoute
open FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute
open FrontC155_H8ResidualCompactDualGeneratorContainmentRoute
open FrontC168_H8ResidualNoExtraTargetLineEquivalence

section TargetLineFiniteMultiplicity

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

/-- **R734 substantive theorem (1/7)**: the current generator containment
`H8 <= compactDual` is enough to place `h^4` in the source-invariant carrier.
-/
theorem h_pow_four_mem_source_invariants_of_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  have hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    (H8_le_compactDual_iff_h_pow_four_mem_compactDual
      (A := A) (B := B)).1 hH8
  exact
    (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
      (A := A) (B := B)).1 hh_compact

/-- **R734 substantive theorem (2/7)**: with `H8 <= compactDual`, finite
rank-one trivial multiplicity proves the R733 target-line containment.
-/
theorem trivialModulePart_le_h_pow_four_line_of_H8_le_compactDual_finiteMultiplicity
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hupper :
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} :=
  trivialModulePart_le_matsushima_h_pow_four_line_of_h_pow_four_mem_source_trivialModulePartUpperBound
    (A := A) (B := B)
    (h_pow_four_mem_source_invariants_of_H8_le_compactDual
      (A := A) (B := B) hH8)
    hupper

/-- **R734 substantive theorem (3/7)**: with `H8 <= compactDual`, target-line
containment supplies the explicit finite-dimensional witness and rank-one
upper bound for `trivialModulePart`.
-/
theorem finiteMultiplicity_of_H8_le_compactDual_trivialModulePart_le_h_pow_four_line
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) ∧
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  have hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) :=
    h_pow_four_mem_source_invariants_of_H8_le_compactDual
      (A := A) (B := B) hH8
  exact
    ⟨trivialModulePart_finiteDimensional_of_h_pow_four_mem_source_lineContainment
        (A := A) (B := B) hh_source hline,
      trivialModulePart_upper_bound_of_h_pow_four_mem_source_lineContainment
        (A := A) (B := B) hh_source hline⟩

/-- **R734 substantive theorem (4/7)**: after `H8 <= compactDual`, the R733
target line is exactly finite-dimensional rank-one trivial multiplicity.
-/
theorem trivialModulePart_le_h_pow_four_line_iff_finiteMultiplicity_under_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) <->
      (FiniteDimensional Rat
          (CuspidalCohomologyData.trivialModulePart (A := B)) ∧
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :=
  Iff.intro
    (finiteMultiplicity_of_H8_le_compactDual_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B) hH8)
    (fun hmult => by
      letI :
          FiniteDimensional Rat
            (CuspidalCohomologyData.trivialModulePart (A := B)) :=
        hmult.1
      exact
        trivialModulePart_le_h_pow_four_line_of_H8_le_compactDual_finiteMultiplicity
          (A := A) (B := B) hH8 hmult.2)

/-- Boundary data, the current generator containment, and explicit finite
trivial multiplicity.  R734 proves this is equivalent to the R733 target-line
route. -/
structure EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract
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
  trivialModulePart_finite :
    FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))
  trivialModulePart_finrank_le_one :
    Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1

/-- **R734 substantive theorem (5/7)**: finite trivial multiplicity feeds the
R733 H8-containment plus target-line contract.
-/
def H8ContainmentTargetLineContract_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_le_h_pow_four_line := by
    letI :
        FiniteDimensional Rat
          (CuspidalCohomologyData.trivialModulePart (A := B)) :=
      O.trivialModulePart_finite
    exact
      trivialModulePart_le_h_pow_four_line_of_H8_le_compactDual_finiteMultiplicity
        (A := A) (B := B)
        O.H8_le_compactDual
        O.trivialModulePart_finrank_le_one

/-- **R734 substantive theorem (6/7)**: the R733 target-line contract recovers
the equivalent finite trivial-multiplicity contract.
-/
def H8ContainmentFiniteTrivialMultiplicityContract_of_H8ContainmentTargetLineContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_finite :=
    (finiteMultiplicity_of_H8_le_compactDual_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)
      O.H8_le_compactDual
      O.trivialModulePart_le_h_pow_four_line).1
  trivialModulePart_finrank_le_one :=
    (finiteMultiplicity_of_H8_le_compactDual_trivialModulePart_le_h_pow_four_line
      (A := A) (B := B)
      O.H8_le_compactDual
      O.trivialModulePart_le_h_pow_four_line).2

/-- **R734 substantive theorem (7/7)**: the current R733 route is equivalently
boundary data, `H8 <= compactDual`, and finite rank-one trivial multiplicity.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty :
    Nonempty (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentTargetLine_nonempty
    (A := A) (B := B)).trans
    (Iff.intro
      (fun h =>
        h.elim (fun O =>
          Nonempty.intro
            (H8ContainmentFiniteTrivialMultiplicityContract_of_H8ContainmentTargetLineContract
              (A := A) (B := B) O)))
      (fun h =>
        h.elim (fun O =>
          Nonempty.intro
            (H8ContainmentTargetLineContract_of_H8ContainmentFiniteTrivialMultiplicityContract
              (A := A) (B := B) O))))

end TargetLineFiniteMultiplicity

/-- R734 target names for route summaries. -/
def currentR734TargetLineFiniteMultiplicityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove finite-dimensional trivialModulePart",
  "prove finrank trivialModulePart <= 1; equivalent to target line under H8 containment"
]

/-- Machine-readable status for the R734 finite-multiplicity normalization. -/
structure R734TargetLineFiniteMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  H8ContainmentPlacesGeneratorInTrivialModulePart : Bool
  finiteMultiplicityEquivalentToTargetLineUnderH8Containment : Bool
  currentRouteEquivalentToH8ContainmentFiniteMultiplicity : Bool
  finiteDimensionalWitnessExplicit : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R734 status: the target-line theorem has been moved exactly to
the explicit finite rank-one `trivialModulePart` multiplicity target under
the current generator containment.
-/
def currentR734TargetLineFiniteMultiplicitySnapshot :
    R734TargetLineFiniteMultiplicitySnapshot where
  proofWorkObligationCount :=
    currentR734TargetLineFiniteMultiplicityTargetNames.length
  H8ContainmentPlacesGeneratorInTrivialModulePart := true
  finiteMultiplicityEquivalentToTargetLineUnderH8Containment := true
  currentRouteEquivalentToH8ContainmentFiniteMultiplicity := true
  finiteDimensionalWitnessExplicit := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesFiniteTrivialMultiplicity := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R734 finite-multiplicity route. -/
theorem currentR734TargetLineFiniteMultiplicitySnapshot_eq_texStatus :
    currentR734TargetLineFiniteMultiplicitySnapshot =
      ({ proofWorkObligationCount := 4
         H8ContainmentPlacesGeneratorInTrivialModulePart := true
         finiteMultiplicityEquivalentToTargetLineUnderH8Containment := true
         currentRouteEquivalentToH8ContainmentFiniteMultiplicity := true
         finiteDimensionalWitnessExplicit := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesFiniteTrivialMultiplicity := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R734TargetLineFiniteMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R734 route. -/
theorem currentR734TargetLineFiniteMultiplicityTargetNames_eq_texStatus :
    currentR734TargetLineFiniteMultiplicityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove finite-dimensional trivialModulePart",
      "prove finrank trivialModulePart <= 1; equivalent to target line under H8 containment"
    ] := by
  rfl

def R734_substantiveTheoremCount : Nat := 7

end FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
end HCGapL4
end HodgeReduction
