/-
# HC Gap L4 -- Front C55: H8 residual exact-image rank-one package (R596).

R595 rewrites the live residual bridge as:

* `compactDual = H8`;
* compact-dual exact image;
* target-invariant exactness.

R562 and R564 show that, once compact-dual exact image is available, the
target-invariant exactness can be replaced by the one-dimensionality of the
cuspidal trivial-module target.  This file records that package-level
equivalence for the current H8 residual target.

No exact-image theorem or target rank theorem is proved here.  The final
obstruction theorem keeps the missing EVII/Matsushima geometry visible.
-/

import HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage
import HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC55_H8ResidualExactImageRankOnePackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC20_MatsushimaCompactDualExactImageCriterion
open FrontC21_MatsushimaExactImageRankBoundary
open FrontC23_MatsushimaCompactDualRankOne
open FrontC36_TargetBettiObstruction
open FrontC50_H8ResidualObligationPackage
open FrontC53_H8ResidualBoundaryDataPackage
open FrontC54_H8ResidualExactImagePackage

section ExactImageRankOnePackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The rank-one spelling of the post-R595 exact-image residual package. -/
structure EVIIH8ResidualExactImageRankOneObligations where
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  compactDual_exact_image :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
  trivialModulePart_rank_one :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) = 1

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R596 substantive theorem (1/7)**: the exact-image rank-one package
implies the R595 exact-image residual package. -/
def exactImageResidual_of_exactImageRankOneResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualExactImageRankOneObligations A B) :
    EVIIH8ResidualExactImageObligations A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  compactDual_exact_image := O.compactDual_exact_image
  target_eq_invariants :=
    target_eq_invariants_of_compactDual_exact_image_trivial_rank
      (A := A) (B := B)
      O.compactDual_exact_image
      (compactDual_finrank_eq_trivialModulePart_of_H8_rank_one
        (A := A) (B := B)
        O.compactDual_eq_H8
        O.trivialModulePart_rank_one)

/-- **R596 substantive theorem (2/7)**: the R595 exact-image residual package
implies the exact-image rank-one package. -/
def exactImageRankOneResidual_of_exactImageResidual
    (O : EVIIH8ResidualExactImageObligations A B) :
    EVIIH8ResidualExactImageRankOneObligations A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  compactDual_exact_image := O.compactDual_exact_image
  trivialModulePart_rank_one := by
    have hcompact_trivial :
        Module.finrank (R := Rat)
            (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
          Module.finrank (R := Rat)
            (CuspidalCohomologyData.trivialModulePart (A := B)) :=
      compactDual_finrank_eq_trivialModulePart_of_exact_image_target_eq
        (A := A) (B := B)
        O.compactDual_exact_image
        O.target_eq_invariants
    calc
      Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) =
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
          hcompact_trivial.symm
      _ = 1 :=
          matsushima_compactDual_finrank_eq_one_of_eq_H8
            (A := A) (B := B) O.compactDual_eq_H8

/-- **R596 substantive theorem (3/7)**: the R595 exact-image package and the
rank-one exact-image package are equivalent at the inhabited-package level. -/
theorem residual_exactImage_nonempty_iff_exactImageRankOne_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualExactImageObligations A B) <->
      Nonempty (EVIIH8ResidualExactImageRankOneObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageRankOneResidual_of_exactImageResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageResidual_of_exactImageRankOneResidual
            (A := A) (B := B) O)))

/-- **R596 substantive theorem (4/7)**: the R594 boundary-data residual
package is equivalent to the exact-image rank-one package. -/
theorem residual_boundaryData_nonempty_iff_exactImageRankOne_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualBoundaryDataObligations A B) <->
      Nonempty (EVIIH8ResidualExactImageRankOneObligations A B) :=
  (residual_boundaryData_nonempty_iff_exactImage_nonempty
    (A := A) (B := B)).trans
    (residual_exactImage_nonempty_iff_exactImageRankOne_nonempty
      (A := A) (B := B))

/-- **R596 substantive theorem (5/7)**: the R591 rank-one residual package is
equivalent to the exact-image rank-one package. -/
theorem residual_rankOne_nonempty_iff_exactImageRankOne_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (EVIIH8ResidualRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualExactImageRankOneObligations A B) :=
  (residual_rankOne_nonempty_iff_exactImage_nonempty
    (A := A) (B := B)).trans
    (residual_exactImage_nonempty_iff_exactImageRankOne_nonempty
      (A := A) (B := B))

/-- **R596 substantive theorem (6/7)**: exact-image rank-one residual data
feeds the existing Matsushima boundary bridge immediately. -/
def matsushimaV56BoundaryData_of_exactImageRankOneResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualExactImageRankOneObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_exactImageResidual
    (A := A) (B := B)
    (exactImageResidual_of_exactImageRankOneResidual
      (A := A) (B := B) O)

end ExactImageRankOnePackage

section Countermodel

/-- **R596 obstruction theorem (7/7)**: the current abstract interface, even
with `compactDual = H8`, still does not force the exact-image rank-one
residual package. -/
theorem current_interface_with_compactDual_eq_H8_does_not_force_exactImageRankOneResidual :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not (EVIIH8ResidualExactImageRankOneObligations
        TargetBettiSource TargetBettiTarget) := by
  refine And.intro
    current_interface_with_compactDual_eq_H8_does_not_force_exactImageResidual.1
    ?_
  intro O
  have htarget_rank_one :
      Module.finrank (R := Rat)
          (MatsushimaData.target_invariants
            (A := TargetBettiSource) (B := TargetBettiTarget)) = 1 := by
    rw [target_invariants_eq_trivialModulePart
      (A := TargetBettiSource) (B := TargetBettiTarget)]
    exact O.trivialModulePart_rank_one
  exact
    counterexample_target_expected_betti8_not_forced
      ((target_expected_betti8_iff_target_invariants_finrank_eq_one
        (A := TargetBettiSource) (B := TargetBettiTarget)).2
        htarget_rank_one)

def R596_substantiveTheoremCount : Nat := 7

end Countermodel

end FrontC55_H8ResidualExactImageRankOnePackage
end HCGapL4
end HodgeReduction
