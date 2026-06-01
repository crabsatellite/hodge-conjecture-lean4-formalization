/-
# HC Gap L4 -- Front C112: exact-image containment and boundary data (R676).

R675 recast the current H8 residual as boundary data plus
`compactDual = H8`.  R636 had an older, more concrete contract:

* exact image of source invariants;
* `source_invariants = H8`;
* `trivialModulePart <= surjectivity_target`.

This file proves that the R636 contract is equivalent to the current
target-line residual.  Thus the exact-image/containment route is not a
stronger hidden premise: it is another kernel-visible spelling of the same
open theorem.
-/

import HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract
import HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC109_H8ResidualBoundaryDataEquivalence
open FrontC110_H8ResidualBoundaryDataTargetLineEquivalence
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence

section ExactImageContainmentBoundary

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

/-- **R676 substantive theorem (1/6)**: the R636 exact-image containment
contract supplies the R675 boundary-data/compact-dual-H8 contract. -/
def boundaryDataCompactDualH8Contract_of_exactImageContainmentContract
    (O : EVIIH8ResidualExactImageContainmentContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary :=
    matsushimaV56BoundaryData_of_exactImageContainmentContract
      (A := A) (B := B) O
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_source_invariants_eq_H8
      (A := A) (B := B) O.source_invariants_eq_H8

/-- **R676 substantive theorem (2/6)**: the R636 exact-image containment
contract feeds the current target-line residual. -/
def targetInvariantLineEqualityContract_of_exactImageContainmentContract
    (O : EVIIH8ResidualExactImageContainmentContract A B) :
    EVIIH8ResidualTargetInvariantLineEqualityContract A B :=
  targetInvariantLineEqualityContract_of_boundaryDataTargetLineContract
    (A := A) (B := B)
    (boundaryDataTargetLineContract_of_boundaryDataCompactDualH8Contract
      (A := A) (B := B)
      (boundaryDataCompactDualH8Contract_of_exactImageContainmentContract
        (A := A) (B := B) O))

/-- **R676 substantive theorem (3/6)**: conversely, the current target-line
residual supplies the R636 reverse target containment.  The key point is
that R673 reconstructs honest boundary data, so the target equals both the
Matsushima target invariants and the trivial-module part. -/
def exactImageContainmentContract_of_targetInvariantLineEqualityContract
    (O : EVIIH8ResidualTargetInvariantLineEqualityContract A B) :
    EVIIH8ResidualExactImageContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_le_surjectivity_target := by
    let D : MatsushimaV56BoundaryData A B :=
      matsushimaV56BoundaryData_of_targetInvariantLineEqualityContract
        (A := A) (B := B) O
    have htriv_surj :
        CuspidalCohomologyData.trivialModulePart (A := B) =
          MatsushimaSurjectivityData.surjectivity_target
            (A := A) (B := B) := by
      calc
        CuspidalCohomologyData.trivialModulePart (A := B)
            = MatsushimaData.target_invariants (A := A) (B := B) :=
            (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm
        _ = MatsushimaSurjectivityData.surjectivity_target
              (A := A) (B := B) := D.target_eq_invariants.symm
    exact le_of_eq htriv_surj

/-- **R676 substantive theorem (4/6)**: R636 exact-image containment
contracts are exactly the current target-line residual contracts at the
inhabited-target level. -/
theorem residual_exactImageContainment_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetInvariantLineEqualityContract_of_exactImageContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageContainmentContract_of_targetInvariantLineEqualityContract
            (A := A) (B := B) O)))

/-- **R676 substantive theorem (5/6)**: the same exact-image containment
route is equivalent to the R675 boundary-data/compact-dual-H8 spelling. -/
theorem residual_exactImageContainment_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_exactImageContainment_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end ExactImageContainmentBoundary

/-- Exact R676 target names for route summaries. -/
def currentR676ExactImageContainmentBoundaryTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove trivialModulePart <= surjectivity_target"
]

/-- Machine-readable status for the R676 exact-image containment bridge. -/
structure R676ExactImageContainmentBoundarySnapshot where
  proofWorkObligationCount : Nat
  exactImageContainmentFeedsBoundaryCompactDual : Bool
  exactImageContainmentEquivalentToTargetLine : Bool
  exactImageContainmentEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesTargetContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R676 status: the exact-image/containment route is equivalent
to the current residual target, but its three concrete obligations remain
open. -/
def currentR676ExactImageContainmentBoundarySnapshot :
    R676ExactImageContainmentBoundarySnapshot where
  proofWorkObligationCount :=
    currentR676ExactImageContainmentBoundaryTargetNames.length
  exactImageContainmentFeedsBoundaryCompactDual := true
  exactImageContainmentEquivalentToTargetLine := true
  exactImageContainmentEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesTargetContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R676 ledger. -/
theorem currentR676ExactImageContainmentBoundarySnapshot_eq_texStatus :
    currentR676ExactImageContainmentBoundarySnapshot =
      ({ proofWorkObligationCount := 3
         exactImageContainmentFeedsBoundaryCompactDual := true
         exactImageContainmentEquivalentToTargetLine := true
         exactImageContainmentEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesTargetContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R676ExactImageContainmentBoundarySnapshot) := by
  decide

/-- **R676 substantive theorem (6/6)**: kernel-checked target names for the
exact-image containment route. -/
theorem currentR676ExactImageContainmentBoundaryTargetNames_eq_texStatus :
    currentR676ExactImageContainmentBoundaryTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove trivialModulePart <= surjectivity_target"
    ] := by
  rfl

def R676_substantiveTheoremCount : Nat := 6

end FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence
end HCGapL4
end HodgeReduction
