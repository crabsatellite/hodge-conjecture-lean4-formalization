/-
# HC Gap L4 -- Front C72: exact-image plus target containment contract (R636).

R635 rewrites the first R634 source equality as the exact-image equation

* `Submodule.map j_q source_invariants = surjectivity_target`.

The remaining scalar/rank-one target is still an element-level statement over
`trivialModulePart`.  This file uses the existing R588 equivalence to replace
that scalar target by the sharper target-side reverse containment

* `trivialModulePart <= surjectivity_target`.

Thus the live proof-work contract is now:

* exact image of source invariants;
* `source_invariants = H8`;
* reverse target containment.

This is a target normalization only.  It does not prove the reverse
containment and does not close full HC.
-/

import HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion
import HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC72_H8ResidualExactImageContainmentContract

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC46_TargetSurjectivityContainmentCriterion
open FrontC47_TargetContainmentScalarPreimageCriterion
open FrontC71_H8ResidualSourceInvariantExactImageContract

section ExactImageContainment

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The R636 containment spelling of the R635 exact-image scalar contract. -/
structure EVIIH8ResidualExactImageContainmentContract where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  trivialModulePart_le_surjectivity_target :
    LE.le
      (CuspidalCohomologyData.trivialModulePart (A := B))
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B))

variable {A B}

omit [CartanCompactDualIso A] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] in
/-- **R636 substantive theorem (1/8)**: R635 exact image plus
`source_invariants = H8` recovers the source-H8 equality needed by R588. -/
theorem source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8
    (hexact : sourceInvariantExactImageTarget A B)
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = MatsushimaData.source_invariants (A := A) (B := B) :=
      source_eq_invariants_of_sourceInvariantExactImage
        (A := A) (B := B) hexact
    _ = CompactDualData.H8 (A := A) := hsource_H8

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B] in
/-- **R636 substantive theorem (2/8)**: `source_invariants = H8` also
identifies the Matsushima compact-dual carrier with `H8`, through the
existing compact-dual/source-invariants comparison. -/
theorem compactDual_eq_H8_of_source_invariants_eq_H8
    (hsource_H8 :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaCompactDualData.compactDual (A := A) (B := B)
        = MatsushimaData.source_invariants (A := A) (B := B) :=
      MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B)
    _ = CompactDualData.H8 (A := A) := hsource_H8

/-- **R636 substantive theorem (3/8)**: the R635 exact-image scalar
contract implies the containment spelling by R588. -/
def exactImageContainmentContract_of_exactImageScalarContract
    (O : EVIIH8ResidualSourceInvariantExactImageScalarContract A B) :
    EVIIH8ResidualExactImageContainmentContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  trivialModulePart_le_surjectivity_target := by
    have hsource_eq_H8 :
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
          CompactDualData.H8 (A := A) :=
      source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8
        (A := A) (B := B)
        O.source_invariants_exact_image
        O.source_invariants_eq_H8
    exact
      (trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
        (A := A) (B := B) hsource_eq_H8).2
        O.scalar_preimage

/-- **R636 substantive theorem (4/8)**: the containment spelling rebuilds
the R635 exact-image scalar contract, again by R588. -/
def exactImageScalarContract_of_exactImageContainmentContract
    (O : EVIIH8ResidualExactImageContainmentContract A B) :
    EVIIH8ResidualSourceInvariantExactImageScalarContract A B where
  source_invariants_exact_image := O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  scalar_preimage := by
    have hsource_eq_H8 :
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
          CompactDualData.H8 (A := A) :=
      source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8
        (A := A) (B := B)
        O.source_invariants_exact_image
        O.source_invariants_eq_H8
    exact
      (trivialModulePart_le_surjectivity_target_iff_scalar_preimage_of_source_eq_H8
        (A := A) (B := B) hsource_eq_H8).1
        O.trivialModulePart_le_surjectivity_target

omit [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R636 substantive theorem (5/8)**: the R635 scalar contract and the
R636 containment contract are the same inhabited residual target. -/
theorem residual_exactImageScalar_nonempty_iff_exactImageContainment_nonempty :
    Nonempty (EVIIH8ResidualSourceInvariantExactImageScalarContract A B) <->
      Nonempty (EVIIH8ResidualExactImageContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageContainmentContract_of_exactImageScalarContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageScalarContract_of_exactImageContainmentContract
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R636 substantive theorem (6/8)**: the containment contract feeds the
same Matsushima boundary bridge, with the target side supplied by the reverse
containment rather than by scalar preimages. -/
def matsushimaV56BoundaryData_of_exactImageContainmentContract
    (O : EVIIH8ResidualExactImageContainmentContract A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_H8_and_trivialModulePart_le_surjectivity_target
    (A := A) (B := B)
    (source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8
      (A := A) (B := B)
      O.source_invariants_exact_image
      O.source_invariants_eq_H8)
    (compactDual_eq_H8_of_source_invariants_eq_H8
      (A := A) (B := B) O.source_invariants_eq_H8)
    O.trivialModulePart_le_surjectivity_target

end ExactImageContainment

/-- Exact R636 target names for route summaries. -/
def currentR636ExactImageContainmentTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove trivialModulePart <= surjectivity_target"
]

/-- Machine-readable status for the R636 containment contract. -/
structure R636ExactImageContainmentSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  targetContainmentObligationCount : Nat
  equivalentToR635 : Bool
  scalarPreimageReplacedByTargetContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R636 status: scalar-preimage/rank-one is equivalently available
as the reverse target containment, but the containment itself remains open. -/
def currentR636ExactImageContainmentSnapshot :
    R636ExactImageContainmentSnapshot where
  proofWorkObligationCount := currentR636ExactImageContainmentTargetNames.length
  exactImageCarrierObligationCount := 2
  targetContainmentObligationCount := 1
  equivalentToR635 := true
  scalarPreimageReplacedByTargetContainment := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R636 substantive theorem (7/8)**: kernel-checked numeric status for
the exact-image containment ledger. -/
theorem currentR636ExactImageContainmentSnapshot_eq_texStatus :
    currentR636ExactImageContainmentSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         targetContainmentObligationCount := 1
         equivalentToR635 := true
         scalarPreimageReplacedByTargetContainment := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R636ExactImageContainmentSnapshot) := by
  decide

/-- **R636 substantive theorem (8/8)**: kernel-checked target names for the
exact-image containment ledger. -/
theorem currentR636ExactImageContainmentTargetNames_eq_texStatus :
    currentR636ExactImageContainmentTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove trivialModulePart <= surjectivity_target"
    ] := by
  rfl

def R636_substantiveTheoremCount : Nat := 8

end FrontC72_H8ResidualExactImageContainmentContract
end HCGapL4
end HodgeReduction
