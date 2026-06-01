/-
# HC Gap L4 -- Front C121: R684 carrier as source invariants (R685).

R684 compressed the current residual to two targets:

* prove `MatsushimaV56BoundaryData`;
* prove `compactDual = CartanH8`.

The second target is still a carrier equality.  The actual Matsushima
infrastructure already identifies `compactDual` with `source_invariants`,
and Cartan identifies `CartanH8` with `CompactDualData.H8`.  This file
therefore rewrites the R684 carrier target to the more primitive

  `source_invariants = H8`.

No new geometric input is asserted here.  The point is to make the next
agent attack the real source-invariant carrier theorem rather than another
equivalent compact-dual spelling.
-/

import HodgeReduction.HCGapL4.FrontC120_H8ResidualBoundaryDataCartanContract

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC121_H8ResidualBoundaryDataSourceInvariantRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
open FrontC120_H8ResidualBoundaryDataCartanContract

section BoundaryDataSourceInvariantRoute

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R685 substantive theorem (1/6)**: the R684 carrier equality
`compactDual = CartanH8` is exactly the source-invariants/H8 carrier
theorem. -/
theorem compactDual_eq_cartanH8_iff_source_invariants_eq_H8 :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)) <->
      (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) := by
  constructor
  · intro hcompact_cartan
    calc
      MatsushimaData.source_invariants (A := A) (B := B)
          = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          (MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)).symm
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
          hcompact_cartan
      _ = CompactDualData.H8 (A := A) :=
          CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
            (A := A)
  · intro hsource_H8
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
          MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)
      _ = CompactDualData.H8 (A := A) := hsource_H8
      _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
          (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
            (A := A)).symm

/-- **R685 substantive theorem (2/6)**: the R684 boundary-data/Cartan
contract gives the older boundary-data/source-H8 contract. -/
def boundaryDataSourceH8Contract_of_boundaryDataCartanContract
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B where
  boundary := O.boundary
  source_invariants_eq_H8 :=
    (compactDual_eq_cartanH8_iff_source_invariants_eq_H8
      (A := A) (B := B)).1 O.compactDual_eq_cartanH8

/-- **R685 substantive theorem (3/6)**: the boundary-data/source-H8
contract rebuilds the R684 boundary-data/Cartan contract. -/
def boundaryDataCartanContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary := O.boundary
  compactDual_eq_cartanH8 :=
    (compactDual_eq_cartanH8_iff_source_invariants_eq_H8
      (A := A) (B := B)).2 O.source_invariants_eq_H8

/-- **R685 substantive theorem (4/6)**: R684 and the boundary-data/source-H8
route are the same inhabited contract, not two separate gaps. -/
theorem residual_boundaryDataCartan_nonempty_iff_boundaryDataSourceH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceH8Contract_of_boundaryDataCartanContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCartanContract_of_boundaryDataSourceH8Contract
            (A := A) (B := B) O)))

omit [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R685 substantive theorem (5/6)**: under boundary data, the R684
carrier target is also equivalent to the target-line equality. -/
theorem compactDual_cartanH8_iff_targetLine_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)) <->
      (MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) := by
  exact
    (compactDual_eq_cartanH8_iff_source_invariants_eq_H8
      (A := A) (B := B)).trans
      (source_H8_iff_targetLine_of_boundaryData
        (A := A) (B := B) D)

/-- **R685 substantive theorem (6/6)**: the R684 route is also equivalent
to the boundary-data/target-line spelling. -/
theorem residual_boundaryDataCartan_nonempty_iff_boundaryDataTargetLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) :=
  residual_boundaryDataCartan_nonempty_iff_boundaryDataSourceH8_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataTargetLine_nonempty_iff_boundaryDataSourceH8_nonempty
      (A := A) (B := B)).symm

end BoundaryDataSourceInvariantRoute

/-- Exact R685 target names for route summaries. -/
def currentR685BoundaryDataSourceInvariantTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8"
]

/-- Machine-readable status for the R685 source-invariant route. -/
structure R685BoundaryDataSourceInvariantSnapshot where
  proofWorkObligationCount : Nat
  compactDualCartanEquivalentToSourceInvariantH8 : Bool
  boundaryDataCartanEquivalentToBoundaryDataSourceH8 : Bool
  compactDualCartanEquivalentToTargetLineUnderBoundaryData : Bool
  boundaryDataCartanEquivalentToBoundaryDataTargetLine : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesSourceInvariantH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R685 status: the carrier target is now the primitive
source-invariants/H8 theorem.  Both proof-work targets remain open. -/
def currentR685BoundaryDataSourceInvariantSnapshot :
    R685BoundaryDataSourceInvariantSnapshot where
  proofWorkObligationCount :=
    currentR685BoundaryDataSourceInvariantTargetNames.length
  compactDualCartanEquivalentToSourceInvariantH8 := true
  boundaryDataCartanEquivalentToBoundaryDataSourceH8 := true
  compactDualCartanEquivalentToTargetLineUnderBoundaryData := true
  boundaryDataCartanEquivalentToBoundaryDataTargetLine := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesSourceInvariantH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R685 ledger. -/
theorem currentR685BoundaryDataSourceInvariantSnapshot_eq_texStatus :
    currentR685BoundaryDataSourceInvariantSnapshot =
      ({ proofWorkObligationCount := 2
         compactDualCartanEquivalentToSourceInvariantH8 := true
         boundaryDataCartanEquivalentToBoundaryDataSourceH8 := true
         compactDualCartanEquivalentToTargetLineUnderBoundaryData := true
         boundaryDataCartanEquivalentToBoundaryDataTargetLine := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesSourceInvariantH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R685BoundaryDataSourceInvariantSnapshot) := by
  decide

/-- Kernel-checked target names for the R685 source-invariant route. -/
theorem currentR685BoundaryDataSourceInvariantTargetNames_eq_texStatus :
    currentR685BoundaryDataSourceInvariantTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8"
    ] := by
  rfl

def R685_substantiveTheoremCount : Nat := 6

end FrontC121_H8ResidualBoundaryDataSourceInvariantRoute
end HCGapL4
end HodgeReduction
