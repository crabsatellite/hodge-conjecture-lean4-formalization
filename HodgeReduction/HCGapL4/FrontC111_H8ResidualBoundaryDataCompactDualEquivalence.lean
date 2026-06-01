/-
# HC Gap L4 -- Front C111: boundary data and compact-dual H8 (R675).

R674 showed that, under honest `MatsushimaV56BoundaryData`, the target-line
equality already recovers `source_invariants = H8`.

This file records the carrier-level version: under the same boundary data,
the target-line theorem is equivalent to the compact-dual carrier equality

  `compactDual = H8`.

So the boundary-data route can be attacked either as boundary data plus the
target-line theorem, or as boundary data plus compact-dual/H8 carrier equality.
Neither theorem is asserted here.
-/

import HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC111_H8ResidualBoundaryDataCompactDualEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC108_H8ResidualBoundaryDataLineEquality
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence

section BoundaryDataCompactDual

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

omit [CartanCompactDualIso A] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R675 substantive theorem (1/6)**: under boundary data, compact-dual
H8 equality and target-line equality are the same theorem. -/
theorem compactDual_eq_H8_iff_targetLine_of_boundaryData
    (D : MatsushimaV56BoundaryData A B) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)) <->
      (MatsushimaData.target_invariants (A := A) (B := B) =
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) := by
  constructor
  · intro hcompact
    have hsource :
        MatsushimaData.source_invariants (A := A) (B := B) =
          CompactDualData.H8 (A := A) := by
      calc
        MatsushimaData.source_invariants (A := A) (B := B)
            = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
            (MatsushimaCompactDualData.compactDual_eq_source_invariants
              (A := A) (B := B)).symm
        _ = CompactDualData.H8 (A := A) := hcompact
    exact target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8
      (A := A) (B := B) D hsource
  · intro hline
    have hsource :
        MatsushimaData.source_invariants (A := A) (B := B) =
          CompactDualData.H8 (A := A) :=
      source_invariants_eq_H8_of_boundaryData_targetLine
        (A := A) (B := B) D hline
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
          MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)
      _ = CompactDualData.H8 (A := A) := hsource

/-- Boundary data plus compact-dual/H8 equality.  R675 proves this is an
equivalent carrier spelling of the R674 boundary-data/target-line route. -/
structure EVIIH8ResidualBoundaryDataCompactDualH8Contract
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
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)

/-- **R675 substantive theorem (2/6)**: compact-dual/H8 contracts feed the
R674 boundary-data/target-line contracts. -/
def boundaryDataTargetLineContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualBoundaryDataTargetLineContract A B where
  boundary := O.boundary
  target_invariants_eq_h_pow_four_line :=
    (compactDual_eq_H8_iff_targetLine_of_boundaryData
      (A := A) (B := B) O.boundary).1 O.compactDual_eq_H8

/-- **R675 substantive theorem (3/6)**: the R674 boundary-data/target-line
contract recovers compact-dual/H8 equality. -/
def boundaryDataCompactDualH8Contract_of_boundaryDataTargetLineContract
    (O : EVIIH8ResidualBoundaryDataTargetLineContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    (compactDual_eq_H8_iff_targetLine_of_boundaryData
      (A := A) (B := B) O.boundary).2 O.target_invariants_eq_h_pow_four_line

/-- **R675 substantive theorem (4/6)**: the two boundary-route carrier
spellings are equivalent at the inhabited-contract level. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataTargetLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataTargetLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataTargetLineContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_boundaryDataTargetLineContract
            (A := A) (B := B) O)))

/-- **R675 substantive theorem (5/6)**: compact-dual/H8 contracts are
equivalent to the current target-line residual contract. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataTargetLine_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataTargetLine_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R675 substantive theorem (6/6)**: compact-dual/H8 contracts are also
equivalent to the R672 boundary-data/source-H8 spelling. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataSourceH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceH8Contract A B) :=
  residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataTargetLine_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataTargetLine_nonempty_iff_boundaryDataSourceH8_nonempty
      (A := A) (B := B))

end BoundaryDataCompactDual

/-- R675 target names for route summaries. -/
def currentR675BoundaryDataCompactDualTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = H8; equivalently prove target_invariants = span {j_q(h^4)} under boundary data"
]

/-- Machine-readable status for the R675 compact-dual carrier rewrite. -/
structure R675BoundaryDataCompactDualSnapshot where
  proofWorkObligationCount : Nat
  compactDualH8EquivalentToTargetLineUnderBoundaryData : Bool
  compactDualContractEquivalentToBoundaryDataTargetLine : Bool
  compactDualContractEquivalentToLineEqualityContract : Bool
  compactDualContractEquivalentToBoundaryDataSourceH8 : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R675 status: the boundary-data route can be read as boundary
data plus compact-dual/H8 carrier equality, equivalently boundary data plus
target-line equality. -/
def currentR675BoundaryDataCompactDualSnapshot :
    R675BoundaryDataCompactDualSnapshot where
  proofWorkObligationCount := currentR675BoundaryDataCompactDualTargetNames.length
  compactDualH8EquivalentToTargetLineUnderBoundaryData := true
  compactDualContractEquivalentToBoundaryDataTargetLine := true
  compactDualContractEquivalentToLineEqualityContract := true
  compactDualContractEquivalentToBoundaryDataSourceH8 := true
  provesBoundaryData := false
  provesCompactDualH8 := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R675 ledger. -/
theorem currentR675BoundaryDataCompactDualSnapshot_eq_texStatus :
    currentR675BoundaryDataCompactDualSnapshot =
      ({ proofWorkObligationCount := 2
         compactDualH8EquivalentToTargetLineUnderBoundaryData := true
         compactDualContractEquivalentToBoundaryDataTargetLine := true
         compactDualContractEquivalentToLineEqualityContract := true
         compactDualContractEquivalentToBoundaryDataSourceH8 := true
         provesBoundaryData := false
         provesCompactDualH8 := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R675BoundaryDataCompactDualSnapshot) := by
  decide

/-- Kernel-checked target names for the R675 ledger. -/
theorem currentR675BoundaryDataCompactDualTargetNames_eq_texStatus :
    currentR675BoundaryDataCompactDualTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = H8; equivalently prove target_invariants = span {j_q(h^4)} under boundary data"
    ] := by
  rfl

def R675_substantiveTheoremCount : Nat := 6

end FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
end HCGapL4
end HodgeReduction
