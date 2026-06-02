/-
# HC Gap L4 -- Front C177: current target-invariant line as finite multiplicity (R742).

R741 rewrites the current preferred route as:

* `MatsushimaV56BoundaryData`;
* `H8 <= compactDual`;
* `target_invariants <= span {j_q(h^4)}`.

R734 had already proved that, under the same `H8 <= compactDual`
generator-containment hypothesis, the corresponding `trivialModulePart` line
containment is exactly explicit finite rank-one trivial multiplicity.
R665 identifies the target-invariant line with the `trivialModulePart` line.

This file connects those two facts at the current frontier.  The live route is
now equivalently:

* `MatsushimaV56BoundaryData`;
* `H8 <= compactDual`;
* finite-dimensional `trivialModulePart`;
* `finrank trivialModulePart <= 1`.

No boundary theorem, H8 containment theorem, finite-multiplicity theorem,
target-line containment, source-H8 statement, quotient vanishing, or full HC
closure is proved here.
-/

import HodgeReduction.HCGapL4.FrontC176_H8ResidualTargetGeneratorBoundaryTransport
import HodgeReduction.HCGapL4.FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
import HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC177_H8ResidualTargetInvariantFiniteMultiplicityCurrentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC101_H8ResidualTargetInvariantLineBridge
open FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
open FrontC176_H8ResidualTargetGeneratorBoundaryTransport

section TargetInvariantFiniteMultiplicityCurrentRoute

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

/-- **R742 substantive theorem (1/6)**: after the current H8-containment
target is fixed, the R741 no-extra target-invariant line is exactly explicit
finite rank-one trivial multiplicity.
-/
theorem target_invariants_le_h_pow_four_line_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (MatsushimaData.target_invariants (A := A) (B := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) <->
      And
        (FiniteDimensional Rat
          (CuspidalCohomologyData.trivialModulePart (A := B)))
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :=
  (target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line
    (A := A) (B := B)).trans
    (trivialModulePart_le_h_pow_four_line_iff_finiteMultiplicity_under_H8_le_compactDual
      (A := A) (B := B) hH8)

/-- **R742 substantive theorem (2/6)**: the R741 current route supplies the
equivalent finite trivial-multiplicity route.
-/
def H8ContainmentFiniteTrivialMultiplicityContract_of_H8ContainmentTargetInvariantLineContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_finite :=
    (target_invariants_le_h_pow_four_line_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
      (A := A) (B := B)
      O.H8_le_compactDual).1 O.target_invariants_le_h_pow_four_line |>.1
  trivialModulePart_finrank_le_one :=
    (target_invariants_le_h_pow_four_line_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
      (A := A) (B := B)
      O.H8_le_compactDual).1 O.target_invariants_le_h_pow_four_line |>.2

/-- **R742 substantive theorem (3/6)**: explicit finite trivial multiplicity
recovers the R741 no-extra target-invariant line.
-/
def H8ContainmentTargetInvariantLineContract_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  target_invariants_le_h_pow_four_line :=
    (target_invariants_le_h_pow_four_line_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
      (A := A) (B := B)
      O.H8_le_compactDual).2
      (And.intro O.trivialModulePart_finite O.trivialModulePart_finrank_le_one)

/-- **R742 substantive theorem (4/6)**: the R741 current contract and the
finite trivial-multiplicity contract are the same inhabited residual route.
-/
theorem residual_H8ContainmentTargetInvariantLine_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentTargetInvariantLineContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentFiniteTrivialMultiplicityContract_of_H8ContainmentTargetInvariantLineContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentTargetInvariantLineContract_of_H8ContainmentFiniteTrivialMultiplicityContract
            (A := A) (B := B) O)))

/-- **R742 substantive theorem (5/6)**: the R738 source-H8 quotient route can
now be read as boundary data, H8 containment, and finite rank-one trivial
multiplicity.
-/
theorem residual_sourceH8Quotient_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty :
    Nonempty
        (FrontC172_H8ResidualSourceH8QuotientMinimalRoute.EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :=
  (residual_sourceH8Quotient_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentTargetInvariantLine_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty
      (A := A) (B := B))

/-- **R742 substantive theorem (6/6)**: the current generator-geometry route
is equivalently boundary data, H8 containment, and finite rank-one trivial
multiplicity.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :=
  (residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentTargetInvariantLine_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentTargetInvariantLine_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty
      (A := A) (B := B))

end TargetInvariantFiniteMultiplicityCurrentRoute

/-- R742 target names for route summaries. -/
def currentR742TargetInvariantFiniteMultiplicityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove finite-dimensional trivialModulePart",
  "prove finrank trivialModulePart <= 1; under H8 containment this is exactly target_invariants <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R742 current finite-multiplicity route. -/
structure R742TargetInvariantFiniteMultiplicitySnapshot where
  proofWorkObligationCount : Nat
  targetInvariantLineEquivalentToTrivialLine : Bool
  finiteMultiplicityEquivalentToTargetInvariantLineUnderH8Containment : Bool
  currentRouteEquivalentToFiniteMultiplicityRoute : Bool
  finiteDimensionalWitnessExplicit : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesTargetInvariantLine : Bool
  provesSourceH8 : Bool
  provesUnconditionalQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R742 status: the R741 no-extra target-invariant line has been
normalized to explicit finite rank-one trivial multiplicity under the current
H8-containment target.  All proof-work targets remain open.
-/
def currentR742TargetInvariantFiniteMultiplicitySnapshot :
    R742TargetInvariantFiniteMultiplicitySnapshot where
  proofWorkObligationCount := currentR742TargetInvariantFiniteMultiplicityTargetNames.length
  targetInvariantLineEquivalentToTrivialLine := true
  finiteMultiplicityEquivalentToTargetInvariantLineUnderH8Containment := true
  currentRouteEquivalentToFiniteMultiplicityRoute := true
  finiteDimensionalWitnessExplicit := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesFiniteTrivialMultiplicity := false
  provesTargetInvariantLine := false
  provesSourceH8 := false
  provesUnconditionalQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R742 route. -/
theorem currentR742TargetInvariantFiniteMultiplicitySnapshot_eq_texStatus :
    currentR742TargetInvariantFiniteMultiplicitySnapshot =
      ({ proofWorkObligationCount := 4
         targetInvariantLineEquivalentToTrivialLine := true
         finiteMultiplicityEquivalentToTargetInvariantLineUnderH8Containment := true
         currentRouteEquivalentToFiniteMultiplicityRoute := true
         finiteDimensionalWitnessExplicit := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesFiniteTrivialMultiplicity := false
         provesTargetInvariantLine := false
         provesSourceH8 := false
         provesUnconditionalQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R742TargetInvariantFiniteMultiplicitySnapshot) := by
  decide

/-- Kernel-checked target names for the R742 route. -/
theorem currentR742TargetInvariantFiniteMultiplicityTargetNames_eq_texStatus :
    currentR742TargetInvariantFiniteMultiplicityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove finite-dimensional trivialModulePart",
      "prove finrank trivialModulePart <= 1; under H8 containment this is exactly target_invariants <= span {j_q(h^4)}"
    ] := by
  rfl

def R742_substantiveTheoremCount : Nat := 6

end FrontC177_H8ResidualTargetInvariantFiniteMultiplicityCurrentRoute
end HCGapL4
end HodgeReduction
