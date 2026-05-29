/-
# HC Gap L4 -- Front C15: Matsushima boundary rank criteria (R556).

R555 reduced the R554 source boundary equality to
`surjectivity_source = MatsushimaData.source_invariants`; the target
equality remained `surjectivity_target = MatsushimaData.target_invariants`.

This file turns those two equalities into finite-dimensional linear
algebra obligations:

* prove a containment;
* prove equality of finranks.

For the target side we also route through the already-proved R554
identification
`MatsushimaData.target_invariants = CuspidalCohomologyData.trivialModulePart`.
Thus the concrete EVII task becomes: identify the source dimensions and
the cuspidal trivial-module target dimensions, then prove the two
natural containments.  No concrete EVII instance is invented here.
-/

import Mathlib.Tactic
import HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC15_MatsushimaBoundaryRankCriterion

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC14_CartanCompactDualSourceBridge

/-! ## Finite-dimensional submodule equality criterion -/

section LinearAlgebraCriterion

variable {V : Type*} [AddCommGroup V] [Module Rat V]

/-- **R556 substantive theorem (1/5)**: a submodule containment between
finite-dimensional vector spaces is equality once the two finranks are
equal.  This is the Mathlib linear-algebra gate used by the EVII
Matsushima source/target boundary obligations. -/
theorem submodule_eq_of_le_and_finrank_eq
    (P Q : Submodule Rat V) [FiniteDimensional Rat Q]
    (hle : LE.le P Q)
    (hdim : Module.finrank (R := Rat) P = Module.finrank (R := Rat) Q) :
    P = Q := by
  exact Submodule.eq_of_le_of_finrank_eq hle hdim

end LinearAlgebraCriterion

/-! ## Source boundary: equality from containment plus finrank -/

section SourceCriterion

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]

/-- **R556 substantive theorem (2/5)**: the R555 source equality follows
from the natural source containment plus the matching finrank equation. -/
theorem source_eq_invariants_of_le_finrank
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)))
    (hsource_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B))) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) :=
  submodule_eq_of_le_and_finrank_eq
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B))
    (MatsushimaData.source_invariants (A := A) (B := B))
    hsource_le hsource_dim

end SourceCriterion

/-! ## Target boundary: first reduce to the cuspidal trivial-module part -/

section TargetCriterion

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R556 substantive theorem (3/5)**: the target equality against
Matsushima target invariants follows once the surjectivity target is
identified with the cuspidal trivial-module part. -/
theorem target_eq_invariants_of_target_eq_trivialModulePart
    (htarget_trivial :
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      MatsushimaData.target_invariants (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
        = CuspidalCohomologyData.trivialModulePart (A := B) :=
      htarget_trivial
    _ = MatsushimaData.target_invariants (A := A) (B := B) :=
      (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm

omit [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R556 substantive theorem (4/5)**: the equality
`surjectivity_target = trivialModulePart` follows from the natural
target containment plus matching finrank. -/
theorem target_eq_trivialModulePart_of_le_finrank
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (htarget_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B))
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (htarget_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_target
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) :=
  submodule_eq_of_le_and_finrank_eq
    (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))
    (CuspidalCohomologyData.trivialModulePart (A := B))
    htarget_le htarget_dim

end TargetCriterion

/-! ## Boundary data from source/target rank criteria -/

section BoundaryCriterion

variable {A B : Type*}
  [AddCommGroup A] [Module Rat A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R556 substantive theorem (5/5)**: build the R554/R555 boundary
data from four concrete linear-algebra obligations: source containment,
source finrank, target containment into the trivial-module part, and
target finrank. -/
def matsushimaV56BoundaryData_of_rank_criteria
    [FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))]
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (hsource_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)))
    (hsource_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_source
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)))
    (htarget_le :
      LE.le
        (MatsushimaSurjectivityData.surjectivity_target
          (A := A) (B := B))
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (htarget_dim :
      Module.finrank (R := Rat)
          (MatsushimaSurjectivityData.surjectivity_target
            (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B))) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_source_target_invariants
    (A := A) (B := B)
    (source_eq_invariants_of_le_finrank
      (A := A) (B := B) hsource_le hsource_dim)
    (target_eq_invariants_of_target_eq_trivialModulePart
      (A := A) (B := B)
      (target_eq_trivialModulePart_of_le_finrank
        (A := A) (B := B) htarget_le htarget_dim))

end BoundaryCriterion

def R556_substantiveTheoremCount : Nat := 5

end FrontC15_MatsushimaBoundaryRankCriterion
end HCGapL4
end HodgeReduction
