/-
# HC Gap L4 -- Front C53: H8 residual boundary-data package (R594).

R593 packages the remaining FrontC target as three concrete statements:

* `surjectivity_source = H8`;
* `compactDual = H8`;
* `surjectivity_target = trivialModulePart`.

R585 already proves that, after `compactDual = H8`, the existing
`MatsushimaV56BoundaryData` structure is equivalent to the first and third
items.  This file records the package-level consequence: the same residual
target is equivalent to one carrier equality plus the existing boundary-data
bridge.

No carrier equality or boundary-data theorem is proved here; the obstruction
at the end keeps the missing geometry visible.
-/

import HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC53_H8ResidualBoundaryDataPackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC36_TargetBettiObstruction
open FrontC50_H8ResidualObligationPackage
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC52_H8ResidualBoundaryPackage

section BoundaryDataPackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The boundary-data spelling of the exact post-R593 residual package:
one H8 carrier equality plus the existing Matsushima boundary-data bridge. -/
structure EVIIH8ResidualBoundaryDataObligations where
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  boundaryData :
    MatsushimaV56BoundaryData A B

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R594 substantive theorem (1/7)**: boundary-data residual data implies
the R593 target-boundary residual package. -/
def boundaryResidual_of_boundaryDataResidual
    (O : EVIIH8ResidualBoundaryDataObligations A B) :
    EVIIH8ResidualBoundaryObligations A B where
  source_eq_H8 :=
    HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence.source_eq_H8_of_boundaryData_compactDual_eq_H8
      (A := A) (B := B) O.boundaryData O.compactDual_eq_H8
  compactDual_eq_H8 := O.compactDual_eq_H8
  target_boundary :=
    HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence.surjectivity_target_eq_trivialModulePart_of_boundaryData
      (A := A) (B := B) O.boundaryData

/-- **R594 substantive theorem (2/7)**: the R593 target-boundary residual
package implies the boundary-data residual package. -/
def boundaryDataResidual_of_boundaryResidual
    (O : EVIIH8ResidualBoundaryObligations A B) :
    EVIIH8ResidualBoundaryDataObligations A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  boundaryData :=
    matsushimaV56BoundaryData_of_boundaryResidual
      (A := A) (B := B) O

/-- **R594 substantive theorem (3/7)**: the target-boundary residual package
and the boundary-data residual package are equivalent at the inhabited-package
level. -/
theorem residual_boundary_nonempty_iff_boundaryData_nonempty :
    Nonempty (EVIIH8ResidualBoundaryObligations A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataResidual_of_boundaryResidual (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryResidual_of_boundaryDataResidual (A := A) (B := B) O)))

/-- **R594 substantive theorem (4/7)**: the R592 scalar-preimage residual
package is equivalent to the boundary-data residual package. -/
theorem residual_scalarPreimage_nonempty_iff_boundaryData_nonempty :
    Nonempty (EVIIH8ResidualScalarPreimageObligations A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataObligations A B) :=
  (residual_scalarPreimage_nonempty_iff_boundary_nonempty
    (A := A) (B := B)).trans
    (residual_boundary_nonempty_iff_boundaryData_nonempty
      (A := A) (B := B))

/-- **R594 substantive theorem (5/7)**: the R591 rank-one residual package is
equivalent to the boundary-data residual package. -/
theorem residual_rankOne_nonempty_iff_boundaryData_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataObligations A B) :=
  (residual_rankOne_nonempty_iff_boundary_nonempty
    (A := A) (B := B)).trans
    (residual_boundary_nonempty_iff_boundaryData_nonempty
      (A := A) (B := B))

/-- **R594 substantive theorem (6/7)**: boundary-data residual data feeds the
existing Matsushima boundary bridge immediately. -/
def matsushimaV56BoundaryData_of_boundaryDataResidual
    (O : EVIIH8ResidualBoundaryDataObligations A B) :
    MatsushimaV56BoundaryData A B :=
  O.boundaryData

end BoundaryDataPackage

section Countermodel

/-- **R594 obstruction theorem (7/7)**: the current abstract interface, even
with `compactDual = H8`, still does not force the existing boundary-data
bridge. -/
theorem current_interface_with_compactDual_eq_H8_does_not_force_boundaryData :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not (MatsushimaV56BoundaryData TargetBettiSource TargetBettiTarget) :=
  ⟨HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8,
    HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_not_matsushimaV56BoundaryData⟩

def R594_substantiveTheoremCount : Nat := 7

end Countermodel

end FrontC53_H8ResidualBoundaryDataPackage
end HCGapL4
end HodgeReduction
