/-
# HC Gap L4 -- Front C113: exact-image route with compact-dual H8 (R677).

R676 made the exact-image containment route equivalent to the current
target-line residual.  Its source-side carrier item was still written as

  `source_invariants = H8`.

This file rewrites that item to the geometrically closer compact-dual carrier
equality

  `compactDual = H8`.

The replacement is exact, using only the existing
`MatsushimaCompactDualData.compactDual_eq_source_invariants` comparison.
-/

import HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC72_H8ResidualExactImageContainmentContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence

section SourceCompactDualCarrier

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R677 substantive theorem (1/6)**: the source-invariants/H8 carrier
target is exactly the compact-dual/H8 carrier target. -/
theorem source_invariants_eq_H8_iff_compactDual_eq_H8 :
    (MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)) <->
      (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) := by
  constructor
  · intro hsource
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
          MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)
      _ = CompactDualData.H8 (A := A) := hsource
  · intro hcompact
    calc
      MatsushimaData.source_invariants (A := A) (B := B)
          = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          (MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)).symm
      _ = CompactDualData.H8 (A := A) := hcompact

end SourceCompactDualCarrier

section ExactImageCompactDualContainment

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- The R677 compact-dual spelling of the R676 exact-image containment
route.  It leaves the same route, but names the source-side H8 item on the
compact-dual carrier. -/
structure EVIIH8ResidualExactImageContainmentCompactDualContract where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  trivialModulePart_le_surjectivity_target :
    LE.le
      (CuspidalCohomologyData.trivialModulePart (A := B))
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))

variable {A B}

/-- **R677 substantive theorem (2/6)**: R676 exact-image containment
contracts produce the compact-dual carrier spelling. -/
def exactImageContainmentCompactDualContract_of_exactImageContainmentContract
    (O : EVIIH8ResidualExactImageContainmentContract A B) :
    EVIIH8ResidualExactImageContainmentCompactDualContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  compactDual_eq_H8 :=
    (source_invariants_eq_H8_iff_compactDual_eq_H8
      (A := A) (B := B)).1 O.source_invariants_eq_H8
  trivialModulePart_le_surjectivity_target :=
    O.trivialModulePart_le_surjectivity_target

/-- **R677 substantive theorem (3/6)**: the compact-dual carrier spelling
rebuilds the R676 exact-image containment contract. -/
def exactImageContainmentContract_of_exactImageContainmentCompactDualContract
    (O : EVIIH8ResidualExactImageContainmentCompactDualContract A B) :
    EVIIH8ResidualExactImageContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 :=
    (source_invariants_eq_H8_iff_compactDual_eq_H8
      (A := A) (B := B)).2 O.compactDual_eq_H8
  trivialModulePart_le_surjectivity_target :=
    O.trivialModulePart_le_surjectivity_target

omit [CartanCompactDualIso A] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R677 substantive theorem (4/6)**: the R676 source-H8 spelling and
the R677 compact-dual-H8 spelling are equivalent at the inhabited-contract
level. -/
theorem residual_exactImageContainment_nonempty_iff_exactImageContainmentCompactDual_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentContract A B) <->
      Nonempty (EVIIH8ResidualExactImageContainmentCompactDualContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageContainmentCompactDualContract_of_exactImageContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageContainmentContract_of_exactImageContainmentCompactDualContract
            (A := A) (B := B) O)))

/-- **R677 substantive theorem (5/6)**: the compact-dual exact-image
containment route is still the current target-line residual. -/
theorem residual_exactImageContainmentCompactDual_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentCompactDualContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_exactImageContainment_nonempty_iff_exactImageContainmentCompactDual_nonempty
    (A := A) (B := B)).symm.trans
    (residual_exactImageContainment_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R677 substantive theorem (6/6)**: the compact-dual exact-image
containment route is also equivalent to the R675 boundary-data/compact-dual
spelling. -/
theorem residual_exactImageContainmentCompactDual_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualExactImageContainmentCompactDualContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_exactImageContainmentCompactDual_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end ExactImageCompactDualContainment

/-- Exact R677 target names for route summaries. -/
def currentR677ExactImageCompactDualContainmentTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove compactDual = H8",
  "prove trivialModulePart <= surjectivity_target"
]

/-- Machine-readable status for the R677 compact-dual exact-image route. -/
structure R677ExactImageCompactDualContainmentSnapshot where
  proofWorkObligationCount : Nat
  compactDualCarrierEquivalentToSourceCarrier : Bool
  compactDualContractEquivalentToExactImageContainment : Bool
  compactDualContractEquivalentToTargetLine : Bool
  compactDualContractEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesExactImage : Bool
  provesCompactDualH8 : Bool
  provesTargetContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R677 status: exact-image/source-H8/target-containment is
equivalently exact-image/compactDual-H8/target-containment. -/
def currentR677ExactImageCompactDualContainmentSnapshot :
    R677ExactImageCompactDualContainmentSnapshot where
  proofWorkObligationCount :=
    currentR677ExactImageCompactDualContainmentTargetNames.length
  compactDualCarrierEquivalentToSourceCarrier := true
  compactDualContractEquivalentToExactImageContainment := true
  compactDualContractEquivalentToTargetLine := true
  compactDualContractEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesExactImage := false
  provesCompactDualH8 := false
  provesTargetContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R677 ledger. -/
theorem currentR677ExactImageCompactDualContainmentSnapshot_eq_texStatus :
    currentR677ExactImageCompactDualContainmentSnapshot =
      ({ proofWorkObligationCount := 3
         compactDualCarrierEquivalentToSourceCarrier := true
         compactDualContractEquivalentToExactImageContainment := true
         compactDualContractEquivalentToTargetLine := true
         compactDualContractEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesExactImage := false
         provesCompactDualH8 := false
         provesTargetContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R677ExactImageCompactDualContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R677 compact-dual exact-image route. -/
theorem currentR677ExactImageCompactDualContainmentTargetNames_eq_texStatus :
    currentR677ExactImageCompactDualContainmentTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove compactDual = H8",
      "prove trivialModulePart <= surjectivity_target"
    ] := by
  rfl

def R677_substantiveTheoremCount : Nat := 6

end FrontC113_H8ResidualExactImageCompactDualContainmentEquivalence
end HCGapL4
end HodgeReduction
