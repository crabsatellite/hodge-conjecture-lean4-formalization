/-
# HC Gap L4 -- Front C20: compact-dual exact image criterion (R561).

R560 showed that the current abstract Matsushima interfaces do not force
the R559 compact-dual source obligations.  This file does not add a new
axiom or a fake EVII instance.  Instead it identifies the next geometric
statement that would be enough:

* the Matsushima image of the compact-dual source is exactly the
  designated surjectivity target;
* that designated target is the Matsushima target-invariants subspace.

Under these two concrete EVII facts, injectivity of `j_q` identifies the
surjectivity source with the compact-dual source, and the existing
Franke/Salamanca-Riba target reduction gives the compact-dual-to-trivial
rank bridge.  Thus the R559 route can be consumed without re-bundling a
stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC19_MatsushimaSourceCompactDualObstruction

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC20_MatsushimaCompactDualExactImageCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC18_MatsushimaSourceCompactDualRankBridge

section LinearAlgebra

variable {V W : Type*}
  [AddCommGroup V] [Module Rat V]
  [AddCommGroup W] [Module Rat W]

/-- **R561 linear-algebra lemma (1/5)**: an injective linear map reflects
submodule equality from equality of images. -/
theorem submodule_eq_of_map_eq_of_injective
    (f : V →ₗ[Rat] W) (hf : Function.Injective f)
    {P Q : Submodule Rat V}
    (hmap : Submodule.map f P = Submodule.map f Q) :
    P = Q := by
  apply le_antisymm
  · intro x hx
    have hxmap : f x ∈ Submodule.map f Q := by
      rw [← hmap]
      exact ⟨x, hx, rfl⟩
    rcases hxmap with ⟨y, hy, hyx⟩
    have hy_eq_x : y = x := hf hyx
    simpa [← hy_eq_x] using hy
  · intro x hx
    have hxmap : f x ∈ Submodule.map f P := by
      rw [hmap]
      exact ⟨x, hx, rfl⟩
    rcases hxmap with ⟨y, hy, hyx⟩
    have hy_eq_x : y = x := hf hyx
    simpa [← hy_eq_x] using hy

end LinearAlgebra

section CompactDualExactImage

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]

/-- **R561 substantive theorem (2/5)**: if the compact-dual source has
exactly the designated Matsushima surjectivity image, then the
surjectivity source equals the compact-dual source. -/
theorem source_eq_compactDual_of_compactDual_image_eq_surjectivity_target
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) := by
  apply submodule_eq_of_map_eq_of_injective
    (MatsushimaData.j_q (A := A) (B := B))
    (MatsushimaData.j_q_injective (A := A) (B := B))
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
        =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
        hcompact_image.symm

/-- **R561 substantive theorem (3/5)**: the same exact-image statement
gives the compact-dual-to-surjectivity-target rank identity, using only
injectivity of `j_q`. -/
theorem compactDual_finrank_eq_surjectivity_target_of_exact_image
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B))) := by
        simpa using
          (Submodule.equivMapOfInjective
            (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaData.j_q_injective (A := A) (B := B))
            (MatsushimaCompactDualData.compactDual (A := A) (B := B))).finrank_eq
    _ =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) := by
        rw [hcompact_image]

end CompactDualExactImage

section BoundaryAssembly

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R561 substantive theorem (4/5)**: compact-dual exact image plus
target-invariant exactness gives the compact-dual-to-trivial rank bridge
used by R559. -/
theorem compactDual_finrank_eq_trivialModulePart_of_exact_image_target_eq
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (htarget :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        MatsushimaData.target_invariants (A := A) (B := B)) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
  calc
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        =
      Module.finrank (R := Rat)
        (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)) :=
        compactDual_finrank_eq_surjectivity_target_of_exact_image
          (A := A) (B := B) hcompact_image
    _ =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
        rw [htarget]
    _ =
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) := by
        rw [target_invariants_eq_trivialModulePart (A := A) (B := B)]

/-- **R561 substantive theorem (5/5)**: the R554/R559 boundary data can
be built from the compact-dual exact-image statement and target-invariant
exactness.  This is the concrete next EVII target; it is not introduced
as an instance or axiom here. -/
def matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq
    (hcompact_image :
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (htarget :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        MatsushimaData.target_invariants (A := A) (B := B)) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual :=
    source_eq_compactDual_of_compactDual_image_eq_surjectivity_target
      (A := A) (B := B) hcompact_image
  target_eq_invariants := htarget

def R561_substantiveTheoremCount : Nat := 5

end BoundaryAssembly

end FrontC20_MatsushimaCompactDualExactImageCriterion
end HCGapL4
end HodgeReduction
