/-
# HC Gap L4 -- Front C178: current finite multiplicity as scalar preimage (R743).

R742 makes the current preferred route:

* `MatsushimaV56BoundaryData`;
* `H8 <= compactDual`;
* finite-dimensional `trivialModulePart`;
* `finrank trivialModulePart <= 1`.

Older kernel-checked bridges already identify the target line
`trivialModulePart <= span {j_q(h^4)}` with the element-level Cartan
scalar-preimage theorem, and R734/R742 identify that line with finite
rank-one trivial multiplicity under the same `H8 <= compactDual` hypothesis.

This file joins those bridges at the current frontier.  The preferred
non-boundary work target can now be read as:

* prove `H8 <= compactDual`;
* prove every class in `trivialModulePart` is `j_q (r * h^4)` for some
  `r : Rat`.

This is a target normalization only.  It proves no boundary theorem, no H8
containment theorem, no scalar-preimage theorem, and no full HC closure.
-/

import HodgeReduction.HCGapL4.FrontC177_H8ResidualTargetInvariantFiniteMultiplicityCurrentRoute
import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC178_H8ResidualFiniteMultiplicityScalarPreimageCurrentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
open FrontC177_H8ResidualTargetInvariantFiniteMultiplicityCurrentRoute

section FiniteMultiplicityScalarPreimageCurrentRoute

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

/-- **R743 substantive theorem (1/6)**: under the current H8-containment
target, the element-level Cartan scalar-preimage theorem is exactly explicit
finite rank-one trivial multiplicity for `trivialModulePart`.
-/
theorem cartan_scalar_preimage_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
    (hH8 :
      CompactDualData.H8 (A := A) <=
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    (forall beta : B,
        beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
          exists r : Rat,
            MatsushimaData.j_q (A := A) (B := B)
              (r • ((KaehlerClass.h : A) ^ 4)) = beta) <->
      And
        (FiniteDimensional Rat
          (CuspidalCohomologyData.trivialModulePart (A := B)))
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) :=
  (cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line
    (A := A) (B := B)).trans
    (trivialModulePart_le_h_pow_four_line_iff_finiteMultiplicity_under_H8_le_compactDual
      (A := A) (B := B) hH8)

/-- Boundary data, the current H8-containment target, and the concrete
Cartan scalar-preimage theorem.  R743 proves this package is equivalent to the
R742 finite-trivial-multiplicity current route.
-/
structure EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract
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
  cartan_scalar_preimage :
    forall beta : B,
      beta ∈ CuspidalCohomologyData.trivialModulePart (A := B) ->
        exists r : Rat,
          MatsushimaData.j_q (A := A) (B := B)
            (r • ((KaehlerClass.h : A) ^ 4)) = beta

/-- **R743 substantive theorem (2/6)**: the scalar-preimage current route
supplies the equivalent finite-trivial-multiplicity route.
-/
def H8ContainmentFiniteTrivialMultiplicityContract_of_H8ContainmentScalarPreimageContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  trivialModulePart_finite := by
    exact
      ((cartan_scalar_preimage_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
        (A := A) (B := B) O.H8_le_compactDual).1 O.cartan_scalar_preimage).1
  trivialModulePart_finrank_le_one := by
    exact
      ((cartan_scalar_preimage_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
        (A := A) (B := B) O.H8_le_compactDual).1 O.cartan_scalar_preimage).2

/-- **R743 substantive theorem (3/6)**: finite trivial multiplicity recovers
the scalar-preimage current route.
-/
def H8ContainmentScalarPreimageContract_of_H8ContainmentFiniteTrivialMultiplicityContract
    (O : EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) :
    EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B where
  boundary := O.boundary
  H8_le_compactDual := O.H8_le_compactDual
  cartan_scalar_preimage :=
    (cartan_scalar_preimage_iff_finiteTrivialMultiplicity_under_H8_le_compactDual
      (A := A) (B := B)
      O.H8_le_compactDual).2
      (And.intro O.trivialModulePart_finite O.trivialModulePart_finrank_le_one)

/-- **R743 substantive theorem (4/6)**: the R742 finite-multiplicity contract
and the scalar-preimage contract are the same inhabited current route.
-/
theorem residual_H8ContainmentFiniteTrivialMultiplicity_nonempty_iff_H8ContainmentScalarPreimage_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentFiniteTrivialMultiplicityContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentScalarPreimageContract_of_H8ContainmentFiniteTrivialMultiplicityContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentFiniteTrivialMultiplicityContract_of_H8ContainmentScalarPreimageContract
            (A := A) (B := B) O)))

/-- **R743 substantive theorem (5/6)**: the R738 source-H8 quotient route can
now be read as boundary data, H8 containment, and the Cartan scalar-preimage
target.
-/
theorem residual_sourceH8Quotient_nonempty_iff_H8ContainmentScalarPreimage_nonempty :
    Nonempty
        (FrontC172_H8ResidualSourceH8QuotientMinimalRoute.EVIIH8ResidualBoundaryDataSourceH8QuotientContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B) :=
  (FrontC177_H8ResidualTargetInvariantFiniteMultiplicityCurrentRoute.residual_sourceH8Quotient_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentFiniteTrivialMultiplicity_nonempty_iff_H8ContainmentScalarPreimage_nonempty
      (A := A) (B := B))

/-- **R743 substantive theorem (6/6)**: the current generator-geometry route
is equivalently boundary data, H8 containment, and the scalar-preimage target.
-/
theorem residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentScalarPreimage_nonempty :
    Nonempty
        (FrontC162_H8ResidualCompactDualGeneratorGeometryRoute.EVIIH8ResidualBoundaryDataCartanGeneratorGeometryContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataH8ContainmentScalarPreimageContract A B) :=
  (FrontC177_H8ResidualTargetInvariantFiniteMultiplicityCurrentRoute.residual_currentGeneratorGeometry_nonempty_iff_H8ContainmentFiniteTrivialMultiplicity_nonempty
    (A := A) (B := B)).trans
    (residual_H8ContainmentFiniteTrivialMultiplicity_nonempty_iff_H8ContainmentScalarPreimage_nonempty
      (A := A) (B := B))

end FiniteMultiplicityScalarPreimageCurrentRoute

/-- R743 target names for route summaries. -/
def currentR743FiniteMultiplicityScalarPreimageTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= compactDual",
  "prove forall beta in trivialModulePart, exists r, j_q (r smul h^4) = beta; under H8 containment this is exactly finite rank-one trivial multiplicity"
]

/-- Machine-readable status for the R743 scalar-preimage current route. -/
structure R743FiniteMultiplicityScalarPreimageSnapshot where
  proofWorkObligationCount : Nat
  scalarPreimageEquivalentToTargetLine : Bool
  targetLineEquivalentToFiniteMultiplicityUnderH8Containment : Bool
  scalarPreimageEquivalentToFiniteMultiplicityUnderH8Containment : Bool
  currentRouteEquivalentToScalarPreimageRoute : Bool
  finiteDimensionalWitnessRecoverableFromScalarPreimage : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesH8Containment : Bool
  provesScalarPreimage : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesTargetInvariantLine : Bool
  provesSourceH8 : Bool
  provesUnconditionalQuotientVanishing : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R743 status: the finite rank-one target is equivalent to the
Cartan scalar-preimage theorem under the current H8-containment target.  All
proof-work targets remain open.
-/
def currentR743FiniteMultiplicityScalarPreimageSnapshot :
    R743FiniteMultiplicityScalarPreimageSnapshot where
  proofWorkObligationCount :=
    currentR743FiniteMultiplicityScalarPreimageTargetNames.length
  scalarPreimageEquivalentToTargetLine := true
  targetLineEquivalentToFiniteMultiplicityUnderH8Containment := true
  scalarPreimageEquivalentToFiniteMultiplicityUnderH8Containment := true
  currentRouteEquivalentToScalarPreimageRoute := true
  finiteDimensionalWitnessRecoverableFromScalarPreimage := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesH8Containment := false
  provesScalarPreimage := false
  provesFiniteTrivialMultiplicity := false
  provesTargetInvariantLine := false
  provesSourceH8 := false
  provesUnconditionalQuotientVanishing := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R743 route. -/
theorem currentR743FiniteMultiplicityScalarPreimageSnapshot_eq_texStatus :
    currentR743FiniteMultiplicityScalarPreimageSnapshot =
      ({ proofWorkObligationCount := 3
         scalarPreimageEquivalentToTargetLine := true
         targetLineEquivalentToFiniteMultiplicityUnderH8Containment := true
         scalarPreimageEquivalentToFiniteMultiplicityUnderH8Containment := true
         currentRouteEquivalentToScalarPreimageRoute := true
         finiteDimensionalWitnessRecoverableFromScalarPreimage := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesH8Containment := false
         provesScalarPreimage := false
         provesFiniteTrivialMultiplicity := false
         provesTargetInvariantLine := false
         provesSourceH8 := false
         provesUnconditionalQuotientVanishing := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R743FiniteMultiplicityScalarPreimageSnapshot) := by
  decide

/-- Kernel-checked target names for the R743 route. -/
theorem currentR743FiniteMultiplicityScalarPreimageTargetNames_eq_texStatus :
    currentR743FiniteMultiplicityScalarPreimageTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= compactDual",
      "prove forall beta in trivialModulePart, exists r, j_q (r smul h^4) = beta; under H8 containment this is exactly finite rank-one trivial multiplicity"
    ] := by
  rfl

def R743_substantiveTheoremCount : Nat := 6

end FrontC178_H8ResidualFiniteMultiplicityScalarPreimageCurrentRoute
end HCGapL4
end HodgeReduction
