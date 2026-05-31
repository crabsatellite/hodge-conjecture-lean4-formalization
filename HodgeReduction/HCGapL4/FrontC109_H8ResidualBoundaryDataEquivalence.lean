/-
# HC Gap L4 -- Front C109: boundary-data equivalence (R673).

R672 showed that `MatsushimaV56BoundaryData` plus `source_invariants = H8`
is sufficient for the current exact-image and target-line residual.

This file proves the converse: the current R669 line-equality residual
already reconstructs that boundary-data/source-H8 package.  Therefore the
R672 boundary-data route is not a stronger hidden premise; it is an
equivalent spelling of the same residual target, phrased in the older R554
Matsushima boundary language.
-/

import HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC109_H8ResidualBoundaryDataEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC107_H8ResidualLineEqualityFiniteUpperBound
open FrontC108_H8ResidualBoundaryDataLineEquality

section BoundaryDataEquivalence

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

omit [CartanCompactDualIso A] in
/-- **R673 substantive theorem (1/5)**: the R669 current residual line
contract reconstructs the older R554 `MatsushimaV56BoundaryData` package. -/
def matsushimaV56BoundaryData_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    MatsushimaV56BoundaryData A B where
  source_eq_compactDual := by
    have hsource_eq_invariants :
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
          MatsushimaData.source_invariants (A := A) (B := B) :=
      source_eq_invariants_of_sourceInvariantExactImage
        (A := A) (B := B) O.source_invariants_exact_image
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
          hsource_eq_invariants
      _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          (MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)).symm
  target_eq_invariants := by
    have hexact := O.source_invariants_exact_image
    dsimp [sourceInvariantExactImageTarget] at hexact
    calc
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
          =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (MatsushimaData.source_invariants (A := A) (B := B)) := hexact.symm
      _ =
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
          (CompactDualData.H8 (A := A)) := by
          rw [O.source_invariants_eq_H8]
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
      _ = MatsushimaData.target_invariants (A := A) (B := B) :=
          O.target_invariants_eq_h_pow_four_line.symm

/-- **R673 substantive theorem (2/5)**: R669 line-equality contracts produce
the R672 boundary-data/source-H8 contracts. -/
def boundaryDataSourceH8Contract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualBoundaryDataSourceH8Contract A B where
  boundary :=
    matsushimaV56BoundaryData_of_targetInvariantLineEqualityContract
      (A := A) (B := B) O
  source_invariants_eq_H8 := O.source_invariants_eq_H8

/-- **R673 substantive theorem (3/5)**: the two contract spellings are
equivalent at the inhabited-target level. -/
theorem residual_boundaryDataSourceH8_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_boundaryDataSourceH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataSourceH8Contract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))

/-- **R673 substantive theorem (4/5)**: the boundary-data/source-H8 spelling
also stays equivalent to the R671 bundled finite-upper-bound spelling. -/
theorem residual_boundaryDataSourceH8_nonempty_iff_finiteUpperBound_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) <->
      Nonempty (EVIIH8ResidualFiniteUpperBoundContract A B) :=
  residual_boundaryDataSourceH8_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_targetInvariantLineEquality_nonempty_iff_finiteUpperBound_nonempty
      (A := A) (B := B))

/-- **R673 substantive theorem (5/5)**: the current line-equality contract
feeds the bundled finite-upper-bound contract through the boundary-data route,
not by adding any new assumption. -/
def finiteUpperBoundContract_of_targetInvariantLineEqualityContract_viaBoundaryData
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualFiniteUpperBoundContract A B :=
  finiteUpperBoundContract_of_boundaryDataSourceH8Contract
    (A := A) (B := B)
    (boundaryDataSourceH8Contract_of_targetInvariantLineEqualityContract
      (A := A) (B := B) O)

end BoundaryDataEquivalence

/-- R673 target names for route summaries. -/
def currentR673BoundaryDataEquivalenceTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove source_invariants = H8; equivalently use the current exact-image + source-H8 + target-line residual contract"
]

/-- Machine-readable status for the R673 boundary-data equivalence. -/
structure R673BoundaryDataEquivalenceSnapshot where
  proofWorkObligationCount : Nat
  lineEqualityContractReconstructsBoundaryData : Bool
  boundaryDataSourceH8EquivalentToLineEqualityContract : Bool
  boundaryDataSourceH8EquivalentToFiniteUpperBound : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R673 status: the R672 boundary-data route is proved equivalent
to the existing line-equality residual contract, so it is not a stronger
hidden premise. -/
def currentR673BoundaryDataEquivalenceSnapshot :
    R673BoundaryDataEquivalenceSnapshot where
  proofWorkObligationCount := currentR673BoundaryDataEquivalenceTargetNames.length
  lineEqualityContractReconstructsBoundaryData := true
  boundaryDataSourceH8EquivalentToLineEqualityContract := true
  boundaryDataSourceH8EquivalentToFiniteUpperBound := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R673 ledger. -/
theorem currentR673BoundaryDataEquivalenceSnapshot_eq_texStatus :
    currentR673BoundaryDataEquivalenceSnapshot =
      ({ proofWorkObligationCount := 2
         lineEqualityContractReconstructsBoundaryData := true
         boundaryDataSourceH8EquivalentToLineEqualityContract := true
         boundaryDataSourceH8EquivalentToFiniteUpperBound := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R673BoundaryDataEquivalenceSnapshot) := by
  decide

/-- Kernel-checked target names for the R673 ledger. -/
theorem currentR673BoundaryDataEquivalenceTargetNames_eq_texStatus :
    currentR673BoundaryDataEquivalenceTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove source_invariants = H8; equivalently use the current exact-image + source-H8 + target-line residual contract"
    ] := by
  rfl

def R673_substantiveTheoremCount : Nat := 5

end FrontC109_H8ResidualBoundaryDataEquivalence
end HCGapL4
end HodgeReduction
