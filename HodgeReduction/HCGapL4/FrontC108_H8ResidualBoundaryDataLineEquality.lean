/-
# HC Gap L4 -- Front C108: boundary data to line equality (R672).

R671 keeps the target-side theorem in the bundled finite upper-bound /
target-line equality form.  This file connects that current residual to the
older R554 `MatsushimaV56BoundaryData` package.

The point is not to assert the boundary data.  It remains an honest geometric
target.  Instead we prove two consumers:

* `MatsushimaV56BoundaryData` alone supplies the current exact-image target;
* `MatsushimaV56BoundaryData` plus `source_invariants = H8` supplies the
  target line equality, hence the bundled finite upper-bound contract.

Thus an agent can attack the real Matsushima boundary package without losing
the current three-target H8 residual ledger.
-/

import HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence
import HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC108_H8ResidualBoundaryDataLineEquality

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC107_H8ResidualLineEqualityFiniteUpperBound

section BoundaryDataLineEquality

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

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R672 substantive theorem (1/5)**: the R554 boundary source equality
directly gives the current R635 exact-image target, after rewriting
`compactDual = source_invariants`. -/
theorem sourceInvariantExactImageTarget_of_matsushimaV56BoundaryData
    (D : MatsushimaV56BoundaryData A B) :
    sourceInvariantExactImageTarget A B := by
  dsimp [sourceInvariantExactImageTarget]
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B))
        =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
        rw [← MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)]
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
        rw [← D.source_eq_compactDual]
    _ =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R672 substantive theorem (2/5)**: if the R554 boundary data is known
and the source invariants are the compact-dual H8 line, the current target
side is the exact line equality `target_invariants = span {j_q(h^4)}`. -/
theorem target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
    (D : MatsushimaV56BoundaryData A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaData.target_invariants (A := A) (B := B) =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
  calc
    MatsushimaData.target_invariants (A := A) (B := B)
        = MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        D.target_eq_invariants.symm
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
        rw [MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)]
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
        rw [D.source_eq_compactDual]
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
        rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
          (A := A) (B := B)]
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CompactDualData.H8 (A := A)) := by
        rw [hsource_H8]
    _ =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (Submodule.span Rat {((KaehlerClass.h : A) ^ 4)}) := by
        rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
    _ =
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)} := by
        rw [Submodule.map_span]
        simp

/-- The R672 boundary-data/source-H8 route.  This is a sufficient route
toward the current residual, not a claim that the boundary data is closed. -/
structure EVIIH8ResidualBoundaryDataSourceH8Contract
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
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)

/-- **R672 substantive theorem (3/5)**: boundary-data/source-H8 contracts
produce the R669 target-line equality contract. -/
def targetInvariantLineEqualityContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImageTarget_of_matsushimaV56BoundaryData
      (A := A) (B := B) O.boundary
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  target_invariants_eq_h_pow_four_line :=
    target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
      (A := A) (B := B) O.boundary O.source_invariants_eq_H8

/-- **R672 substantive theorem (4/5)**: the same route also feeds the R671
bundled finite-upper-bound contract. -/
def finiteUpperBoundContract_of_boundaryDataSourceH8Contract
    (O : EVIIH8ResidualBoundaryDataSourceH8Contract A B) :
    EVIIH8ResidualFiniteUpperBoundContract A B :=
  finiteUpperBoundContract_of_targetInvariantLineEqualityContract
    (A := A) (B := B)
    (targetInvariantLineEqualityContract_of_boundaryDataSourceH8Contract
      (A := A) (B := B) O)

/-- **R672 substantive theorem (5/5)**: inhabited boundary-data/source-H8
contracts feed inhabited bundled finite-upper-bound contracts. -/
theorem residual_boundaryDataSourceH8_nonempty_to_finiteUpperBound_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) ->
      Nonempty (EVIIH8ResidualFiniteUpperBoundContract A B) := by
  intro h
  refine h.elim ?_
  intro O
  exact Nonempty.intro
    (finiteUpperBoundContract_of_boundaryDataSourceH8Contract
      (A := A) (B := B) O)

end BoundaryDataLineEquality

/-- R672 target names for route summaries. -/
def currentR672BoundaryDataLineEqualityTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8"
]

/-- Machine-readable status for the R672 boundary-data route. -/
structure R672BoundaryDataLineEqualitySnapshot where
  proofWorkObligationCount : Nat
  boundaryDataFeedsExactImage : Bool
  boundaryDataSourceH8FeedsLineEquality : Bool
  boundaryDataSourceH8FeedsFiniteUpperBound : Bool
  provesBoundaryData : Bool
  provesSourceH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R672 status: this is a consumer bridge from R554 boundary data
to the current exact-image plus target-line residual, not a proof of the
boundary data itself. -/
def currentR672BoundaryDataLineEqualitySnapshot :
    R672BoundaryDataLineEqualitySnapshot where
  proofWorkObligationCount := currentR672BoundaryDataLineEqualityTargetNames.length
  boundaryDataFeedsExactImage := true
  boundaryDataSourceH8FeedsLineEquality := true
  boundaryDataSourceH8FeedsFiniteUpperBound := true
  provesBoundaryData := false
  provesSourceH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R672 ledger. -/
theorem currentR672BoundaryDataLineEqualitySnapshot_eq_texStatus :
    currentR672BoundaryDataLineEqualitySnapshot =
      ({ proofWorkObligationCount := 2
         boundaryDataFeedsExactImage := true
         boundaryDataSourceH8FeedsLineEquality := true
         boundaryDataSourceH8FeedsFiniteUpperBound := true
         provesBoundaryData := false
         provesSourceH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R672BoundaryDataLineEqualitySnapshot) := by
  decide

/-- Kernel-checked target names for the R672 ledger. -/
theorem currentR672BoundaryDataLineEqualityTargetNames_eq_texStatus :
    currentR672BoundaryDataLineEqualityTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8"
    ] := by
  rfl

def R672_substantiveTheoremCount : Nat := 5

end FrontC108_H8ResidualBoundaryDataLineEquality
end HCGapL4
end HodgeReduction
