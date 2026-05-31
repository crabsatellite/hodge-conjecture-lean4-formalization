/-
# HC Gap L4 -- Front C52: H8 residual target-boundary package (R593).

R592 packages the residual target as two H8 carrier equalities plus the
element-level scalar-preimage theorem.  R588 had already shown that the same
target is exactly the Matsushima target-boundary equality

  `surjectivity_target = trivialModulePart`

under those H8 carrier equalities.

This file records that equivalence as a package-level interface.  It does not
prove the target-boundary equality or either H8 carrier equality; the final
obstruction theorem keeps that status machine-visible.
-/

import HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC52_H8ResidualBoundaryPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC50_H8ResidualObligationPackage
open FrontC51_H8ResidualScalarPreimagePackage

section BoundaryPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The target-boundary spelling of the exact post-R592 residual package. -/
structure EVIIH8ResidualBoundaryObligations where
  source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  target_boundary :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B)

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R593 substantive theorem (1/7)**: with the two H8 carrier equalities
fixed, the target-boundary equality is exactly the R592 scalar-preimage
target. -/
theorem target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8
    (hsource_eq_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hcompact_eq_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) <->
      H8ResidualScalarPreimageTarget A B :=
  HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.target_boundary_iff_scalar_preimage_of_source_compactDual_eq_H8
    (A := A) (B := B) hsource_eq_H8 hcompact_eq_H8

/-- **R593 substantive theorem (2/7)**: scalar-preimage residual data
implies the target-boundary residual package. -/
def boundaryResidual_of_scalarPreimageResidual
    (O : EVIIH8ResidualScalarPreimageObligations A B) :
    EVIIH8ResidualBoundaryObligations A B where
  source_eq_H8 := O.source_eq_H8
  compactDual_eq_H8 := O.compactDual_eq_H8
  target_boundary :=
    (target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8
      (A := A) (B := B) O.source_eq_H8 O.compactDual_eq_H8).2
      O.scalar_preimage

/-- **R593 substantive theorem (3/7)**: the target-boundary residual package
implies the scalar-preimage residual data. -/
def scalarPreimageResidual_of_boundaryResidual
    (O : EVIIH8ResidualBoundaryObligations A B) :
    EVIIH8ResidualScalarPreimageObligations A B where
  source_eq_H8 := O.source_eq_H8
  compactDual_eq_H8 := O.compactDual_eq_H8
  scalar_preimage :=
    (target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8
      (A := A) (B := B) O.source_eq_H8 O.compactDual_eq_H8).1
      O.target_boundary

/-- **R593 substantive theorem (4/7)**: the scalar-preimage and
target-boundary residual packages are equivalent at the inhabited-package
level. -/
theorem residual_scalarPreimage_nonempty_iff_boundary_nonempty :
    Nonempty (EVIIH8ResidualScalarPreimageObligations A B) <->
      Nonempty (EVIIH8ResidualBoundaryObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryResidual_of_scalarPreimageResidual (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (scalarPreimageResidual_of_boundaryResidual (A := A) (B := B) O)))

/-- **R593 substantive theorem (5/7)**: the R591 rank-one residual package
is equivalent to the target-boundary residual package. -/
theorem residual_rankOne_nonempty_iff_boundary_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualBoundaryObligations A B) :=
  (residual_rankOne_nonempty_iff_scalarPreimage_nonempty
    (A := A) (B := B)).trans
    (residual_scalarPreimage_nonempty_iff_boundary_nonempty
      (A := A) (B := B))

/-- **R593 substantive theorem (6/7)**: target-boundary residual data feeds
the existing Matsushima boundary bridge directly. -/
def matsushimaV56BoundaryData_of_boundaryResidual
    (O : EVIIH8ResidualBoundaryObligations A B) :
    MatsushimaV56BoundaryData A B :=
  HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.matsushimaV56BoundaryData_of_H8_and_scalar_preimage
    (A := A) (B := B)
    O.source_eq_H8 O.compactDual_eq_H8
    ((target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8
      (A := A) (B := B) O.source_eq_H8 O.compactDual_eq_H8).1
      O.target_boundary)

end BoundaryPackage

section Countermodel

/-- **R593 obstruction theorem (7/7)**: the current abstract H8 carrier
interface still does not force the target-boundary equality. -/
theorem current_interface_with_H8_equalities_does_not_force_target_boundary :
    (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (MatsushimaSurjectivityData.surjectivity_target
            (A := TargetBettiSource) (B := TargetBettiTarget) =
          CuspidalCohomologyData.trivialModulePart (A := TargetBettiTarget)) :=
  HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.current_interface_with_H8_equalities_does_not_force_target_boundary

def R593_substantiveTheoremCount : Nat := 7

end Countermodel

end FrontC52_H8ResidualBoundaryPackage
end HCGapL4
end HodgeReduction
