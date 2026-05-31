/-
# HC Gap L4 -- Front C54: H8 residual exact-image package (R595).

R594 packages the live residual target as:

* `compactDual = H8`;
* the existing `MatsushimaV56BoundaryData` bridge.

The boundary-data bridge itself is a pair of Matsushima equalities.  This
file records the exact-image spelling of the same residual package:
prove the compact-dual carrier is `H8`, prove that the compact-dual source
has exactly the designated Matsushima image, and prove that the designated
target is the target-invariant subspace.

No exact-image theorem is proved here.  The final obstruction theorem keeps
the missing EVII/Matsushima geometry visible.
-/

import HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage
import HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC54_H8ResidualExactImagePackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC20_MatsushimaCompactDualExactImageCriterion
open FrontC36_TargetBettiObstruction
open FrontC51_H8ResidualScalarPreimagePackage
open FrontC53_H8ResidualBoundaryDataPackage

section ExactImagePackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The exact-image spelling of the post-R594 residual package. -/
structure EVIIH8ResidualExactImageObligations where
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  compactDual_exact_image :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
  target_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B)

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R595 substantive theorem (1/7)**: boundary-data residual data implies
the exact-image residual package. -/
def exactImageResidual_of_boundaryDataResidual
    (O : EVIIH8ResidualBoundaryDataObligations A B) :
    EVIIH8ResidualExactImageObligations A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  compactDual_exact_image := by
    calc
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))
          =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
          rw [<- O.boundaryData.source_eq_compactDual]
      _ = MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)
  target_eq_invariants := O.boundaryData.target_eq_invariants

/-- **R595 substantive theorem (2/7)**: the exact-image residual package
implies the boundary-data residual package. -/
def boundaryDataResidual_of_exactImageResidual
    (O : EVIIH8ResidualExactImageObligations A B) :
    EVIIH8ResidualBoundaryDataObligations A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  boundaryData :=
    matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq
      (A := A) (B := B)
      O.compactDual_exact_image
      O.target_eq_invariants

omit [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R595 substantive theorem (3/7)**: the R594 boundary-data residual
package and the exact-image residual package are equivalent at the
inhabited-package level. -/
theorem residual_boundaryData_nonempty_iff_exactImage_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataObligations A B) <->
      Nonempty (EVIIH8ResidualExactImageObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageResidual_of_boundaryDataResidual (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataResidual_of_exactImageResidual (A := A) (B := B) O)))

/-- **R595 substantive theorem (4/7)**: the R592 scalar-preimage residual
package is equivalent to the exact-image residual package. -/
theorem residual_scalarPreimage_nonempty_iff_exactImage_nonempty :
    Nonempty (EVIIH8ResidualScalarPreimageObligations A B) <->
      Nonempty (EVIIH8ResidualExactImageObligations A B) :=
  (residual_scalarPreimage_nonempty_iff_boundaryData_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryData_nonempty_iff_exactImage_nonempty
      (A := A) (B := B))

/-- **R595 substantive theorem (5/7)**: the R591 rank-one residual package
is equivalent to the exact-image residual package. -/
theorem residual_rankOne_nonempty_iff_exactImage_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (FrontC50_H8ResidualObligationPackage.EVIIH8ResidualRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualExactImageObligations A B) :=
  (residual_rankOne_nonempty_iff_boundaryData_nonempty
    (A := A) (B := B)).trans
    (residual_boundaryData_nonempty_iff_exactImage_nonempty
      (A := A) (B := B))

/-- **R595 substantive theorem (6/7)**: exact-image residual data feeds the
existing Matsushima boundary bridge immediately. -/
def matsushimaV56BoundaryData_of_exactImageResidual
    (O : EVIIH8ResidualExactImageObligations A B) :
    MatsushimaV56BoundaryData A B :=
  (boundaryDataResidual_of_exactImageResidual (A := A) (B := B) O).boundaryData

end ExactImagePackage

section Countermodel

/-- **R595 obstruction theorem (7/7)**: the current abstract interface, even
with `compactDual = H8`, still does not force the exact-image residual
package. -/
theorem current_interface_with_compactDual_eq_H8_does_not_force_exactImageResidual :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not (EVIIH8ResidualExactImageObligations
        TargetBettiSource TargetBettiTarget) := by
  refine ⟨
    HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_compactDual_eq_H8,
    ?_⟩
  intro O
  exact
    HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.counterexample_not_matsushimaV56BoundaryData
      ((boundaryDataResidual_of_exactImageResidual
        (A := TargetBettiSource) (B := TargetBettiTarget) O).boundaryData)

def R595_substantiveTheoremCount : Nat := 7

end Countermodel

end FrontC54_H8ResidualExactImagePackage
end HCGapL4
end HodgeReduction
