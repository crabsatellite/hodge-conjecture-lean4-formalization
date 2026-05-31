/-
# HC Gap L4 -- Front C56: H8 residual Cartan rank-one package (R597).

R596 leaves the live residual target as:

* `compactDual = H8`;
* compact-dual exact image;
* `finrank trivialModulePart = 1`.

R563 identifies compact-dual exact image with the source equality
`surjectivity_source = compactDual`, and Cartan's comparison identifies the
Cartan H8 line with the same compact-dual H8 carrier.  This file records the
equivalent Cartan-line spelling:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* `finrank trivialModulePart = 1`.

No Cartan-line equality or target rank theorem is proved here.  The obstruction
theorem keeps those EVII/Matsushima inputs visible.
-/

import HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage
import HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence
import HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC56_H8ResidualCartanRankOnePackage

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC22_MatsushimaExactImageSourceEquivalence
open FrontC25_CartanLineBoundaryExactness
open FrontC36_TargetBettiObstruction
open FrontC55_H8ResidualExactImageRankOnePackage

section CartanRankOnePackage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The Cartan-line spelling of the post-R596 H8 residual package. -/
structure EVIIH8ResidualCartanRankOneObligations where
  source_eq_cartan :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  compactDual_eq_cartan :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  trivialModulePart_rank_one :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) = 1

variable {A B}
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R597 substantive theorem (1/6)**: Cartan-line rank-one residual data
implies the R596 exact-image rank-one residual package. -/
def exactImageRankOneResidual_of_cartanRankOneResidual
    (O : EVIIH8ResidualCartanRankOneObligations A B) :
    EVIIH8ResidualExactImageRankOneObligations A B where
  compactDual_eq_H8 :=
    matsushima_compactDual_eq_H8_of_eq_cartan
      (A := A) (B := B) O.compactDual_eq_cartan
  compactDual_exact_image :=
    compactDual_exact_image_of_source_eq_compactDual
      (A := A) (B := B)
      (source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan
        (A := A) (B := B) O.source_eq_cartan O.compactDual_eq_cartan)
  trivialModulePart_rank_one := O.trivialModulePart_rank_one

/-- **R597 substantive theorem (2/6)**: the R596 exact-image rank-one package
implies the Cartan-line rank-one residual package. -/
def cartanRankOneResidual_of_exactImageRankOneResidual
    (O : EVIIH8ResidualExactImageRankOneObligations A B) :
    EVIIH8ResidualCartanRankOneObligations A B where
  source_eq_cartan := by
    have hsource_compact :
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
          MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
      (source_eq_compactDual_iff_compactDual_exact_image
        (A := A) (B := B)).2 O.compactDual_exact_image
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          =
        MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        hsource_compact
      _ = CompactDualData.H8 (A := A) := O.compactDual_eq_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := A)).symm
  compactDual_eq_cartan := by
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = CompactDualData.H8 (A := A) := O.compactDual_eq_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
        (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
          (A := A)).symm
  trivialModulePart_rank_one := O.trivialModulePart_rank_one

omit [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R597 substantive theorem (3/6)**: the R596 exact-image rank-one
package and the Cartan-line rank-one package are equivalent at the inhabited
package level. -/
theorem residual_exactImageRankOne_nonempty_iff_cartanRankOne_nonempty :
    Nonempty (EVIIH8ResidualExactImageRankOneObligations A B) <->
      Nonempty (EVIIH8ResidualCartanRankOneObligations A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanRankOneResidual_of_exactImageRankOneResidual
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageRankOneResidual_of_cartanRankOneResidual
            (A := A) (B := B) O)))

/-- **R597 substantive theorem (4/6)**: the R594 boundary-data package is
equivalent to the Cartan-line rank-one residual package. -/
theorem residual_boundaryData_nonempty_iff_cartanRankOne_nonempty
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))] :
    Nonempty (FrontC53_H8ResidualBoundaryDataPackage.EVIIH8ResidualBoundaryDataObligations A B) <->
      Nonempty (EVIIH8ResidualCartanRankOneObligations A B) :=
  (residual_boundaryData_nonempty_iff_exactImageRankOne_nonempty
    (A := A) (B := B)).trans
    (residual_exactImageRankOne_nonempty_iff_cartanRankOne_nonempty
      (A := A) (B := B))

/-- **R597 substantive theorem (5/6)**: Cartan-line rank-one residual data
feeds the existing Matsushima boundary bridge immediately. -/
def matsushimaV56BoundaryData_of_cartanRankOneResidual
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualCartanRankOneObligations A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_exactImageRankOneResidual
    (A := A) (B := B)
    (exactImageRankOneResidual_of_cartanRankOneResidual
      (A := A) (B := B) O)

end CartanRankOnePackage

section Countermodel

/-- **R597 obstruction theorem (6/6)**: the current abstract interface, even
with `compactDual = H8`, still does not force the Cartan-line rank-one
residual package. -/
theorem current_interface_with_compactDual_eq_H8_does_not_force_cartanRankOneResidual :
    (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not (EVIIH8ResidualCartanRankOneObligations
        TargetBettiSource TargetBettiTarget) := by
  refine And.intro
    current_interface_with_compactDual_eq_H8_does_not_force_exactImageRankOneResidual.1
    ?_
  intro O
  exact
    current_interface_with_compactDual_eq_H8_does_not_force_exactImageRankOneResidual.2
      (exactImageRankOneResidual_of_cartanRankOneResidual
        (A := TargetBettiSource) (B := TargetBettiTarget) O)

def R597_substantiveTheoremCount : Nat := 6

end Countermodel

end FrontC56_H8ResidualCartanRankOnePackage
end HCGapL4
end HodgeReduction
