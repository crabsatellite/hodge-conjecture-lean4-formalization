/-
# HC Gap L4 -- Front C22: exact image is source equality (R563).

R562 narrowed the FrontC Matsushima boundary to:

* compact-dual exact image;
* compactDual/trivialModulePart rank equality.

This file proves that the first target can be attacked as the source
subspace equality

  `surjectivity_source = compactDual`.

Indeed, the forward direction is the R561 injectivity argument; the
reverse direction is just the Matsushima surjectivity image equation.
Thus future EVII work can prove a Cartan/compact-dual source
identification plus a rank bridge, without treating image equality as a
separate opaque target.

No concrete EVII instance, axiom, or stronger premise is introduced.
-/

import HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC22_MatsushimaExactImageSourceEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC20_MatsushimaCompactDualExactImageCriterion
open FrontC21_MatsushimaExactImageRankBoundary

section ExactImageSourceEquivalence

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R563 substantive theorem (1/5)**: source equality with the
compact-dual subspace implies compact-dual exact image, by rewriting the
Matsushima surjectivity image equation. -/
theorem compactDual_exact_image_of_source_eq_compactDual
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) := by
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
        rw [<- hsource]
    _ =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)

/-- **R563 substantive theorem (2/5)**: compact-dual exact image is
equivalent to the source equality `surjectivity_source = compactDual`.
The nontrivial direction is R561's injectivity argument. -/
theorem source_eq_compactDual_iff_compactDual_exact_image :
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) <->
      (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
  constructor
  · intro hsource
    exact compactDual_exact_image_of_source_eq_compactDual
      (A := A) (B := B) hsource
  · intro hcompact_image
    exact source_eq_compactDual_of_compactDual_image_eq_surjectivity_target
      (A := A) (B := B) hcompact_image

end ExactImageSourceEquivalence

section BoundaryFromSourceEquality

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R563 substantive theorem (3/5)**: with R563's source equality,
the R562 target exactness criterion consumes only the
compactDual/trivialModulePart rank bridge. -/
theorem target_eq_invariants_of_source_eq_compactDual_trivial_rank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) :=
  target_eq_invariants_of_compactDual_exact_image_trivial_rank
    (A := A) (B := B)
    (compactDual_exact_image_of_source_eq_compactDual
      (A := A) (B := B) hsource)
    hcompact_trivial_dim

/-- **R563 substantive theorem (4/5)**: source equality plus the
compactDual/trivialModulePart rank bridge builds the full Matsushima
boundary data. -/
def matsushimaV56BoundaryData_of_source_eq_compactDual_trivial_rank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_compactDual_exact_image_trivial_rank
    (A := A) (B := B)
    (compactDual_exact_image_of_source_eq_compactDual
      (A := A) (B := B) hsource)
    hcompact_trivial_dim

/-- **R563 substantive theorem (5/5)**: source equality plus the same
rank bridge gives the R554 compact-dual image conclusion directly. -/
theorem matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_rank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hcompact_trivial_dim :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  matsushima_compactDual_image_eq_trivialModulePart_of_exact_image_rank
    (A := A) (B := B)
    (compactDual_exact_image_of_source_eq_compactDual
      (A := A) (B := B) hsource)
    hcompact_trivial_dim

def R563_substantiveTheoremCount : Nat := 5

end BoundaryFromSourceEquality

end FrontC22_MatsushimaExactImageSourceEquivalence
end HCGapL4
end HodgeReduction
