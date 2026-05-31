/-
# HC Gap L4 -- Front C71: source-invariant exact-image contract (R635).

R634 rewrites the R610 contract into the source-invariant form:

* `surjectivity_source = source_invariants`;
* `source_invariants = H8`;
* scalar-preimage/rank-one target.

The first item is still a submodule equality.  This file rewrites it into
the exact-image statement that is closest to the existing Matsushima
surjectivity field:

* `Submodule.map j_q source_invariants = surjectivity_target`.

The equivalence uses only `MatsushimaSurjectivityData.surjectivity_eq` and
injectivity of `j_q`.  It does not prove the exact-image fact for the EVII
case and does not close full HC.
-/

import HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion
import HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC71_H8ResidualSourceInvariantExactImageContract

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC20_MatsushimaCompactDualExactImageCriterion
open FrontC65_H8ResidualPrimitiveTargetLedger
open FrontC70_H8ResidualSourceInvariantScalarContract

section SourceInvariantExactImage

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The exact-image spelling of the R634 source equality target. -/
def sourceInvariantExactImageTarget : Prop :=
  Submodule.map (MatsushimaData.j_q (A := A) (B := B))
      (MatsushimaData.source_invariants (A := A) (B := B)) =
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)

/-- The R635 exact-image spelling of the source-invariant scalar contract. -/
structure EVIIH8ResidualSourceInvariantExactImageScalarContract where
  source_invariants_exact_image : sourceInvariantExactImageTarget A B
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  scalar_preimage : scalarPreimagePrimitiveTarget A B

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] in
/-- **R635 substantive theorem (1/8)**: the R634 source equality implies
the source-invariant exact-image statement by rewriting the existing
Matsushima surjectivity equation. -/
theorem sourceInvariantExactImage_of_source_eq_invariants
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B)) :
    sourceInvariantExactImageTarget A B := by
  calc
    Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaData.source_invariants (A := A) (B := B))
        =
      Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
        rw [<- hsource]
    _ =
      MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
        MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] in
/-- **R635 substantive theorem (2/8)**: conversely, source-invariant
exact image recovers the R634 source equality by injectivity of `j_q`. -/
theorem source_eq_invariants_of_sourceInvariantExactImage
    (hexact : sourceInvariantExactImageTarget A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) := by
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
        (MatsushimaData.source_invariants (A := A) (B := B)) :=
        hexact.symm

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B] in
/-- **R635 substantive theorem (3/8)**: source equality and source-invariant
exact image are equivalent targets. -/
theorem source_eq_invariants_iff_sourceInvariantExactImage :
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaData.source_invariants (A := A) (B := B)) <->
      sourceInvariantExactImageTarget A B :=
  Iff.intro
    (sourceInvariantExactImage_of_source_eq_invariants (A := A) (B := B))
    (source_eq_invariants_of_sourceInvariantExactImage (A := A) (B := B))

/-- **R635 substantive theorem (4/8)**: the R634 source-invariant scalar
contract gives the exact-image spelling. -/
def exactImageScalarContract_of_sourceInvariantScalarContract
    (O : EVIIH8ResidualSourceInvariantScalarContract A B) :
    EVIIH8ResidualSourceInvariantExactImageScalarContract A B where
  source_invariants_exact_image :=
    sourceInvariantExactImage_of_source_eq_invariants
      (A := A) (B := B) O.source_eq_invariants
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  scalar_preimage := O.scalar_preimage

/-- **R635 substantive theorem (5/8)**: the exact-image spelling rebuilds
the R634 source-invariant scalar contract. -/
def sourceInvariantScalarContract_of_exactImageScalarContract
    (O : EVIIH8ResidualSourceInvariantExactImageScalarContract A B) :
    EVIIH8ResidualSourceInvariantScalarContract A B where
  source_eq_invariants :=
    source_eq_invariants_of_sourceInvariantExactImage
      (A := A) (B := B) O.source_invariants_exact_image
  source_invariants_eq_H8 := O.source_invariants_eq_H8
  scalar_preimage := O.scalar_preimage

omit [CartanCompactDualIso A] [MatsushimaCompactDualData A B] in
/-- **R635 substantive theorem (6/8)**: the R634 contract and exact-image
contract are the same inhabited residual target. -/
theorem residual_sourceInvariantScalarContract_nonempty_iff_exactImageScalarContract_nonempty :
    Nonempty (EVIIH8ResidualSourceInvariantScalarContract A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantExactImageScalarContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageScalarContract_of_sourceInvariantScalarContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantScalarContract_of_exactImageScalarContract
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- The exact-image contract feeds the same Matsushima boundary bridge as
R634 by conversion through the source-invariant scalar contract. -/
def matsushimaV56BoundaryData_of_sourceInvariantExactImageScalarContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceInvariantExactImageScalarContract A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_sourceInvariantScalarContract
    (A := A) (B := B)
    (sourceInvariantScalarContract_of_exactImageScalarContract
      (A := A) (B := B) O)

end SourceInvariantExactImage

/-- Exact R635 target names for route summaries. -/
def currentR635ExactImageScalarContractTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove scalar/rank-one target"
]

/-- Machine-readable status for the R635 exact-image contract. -/
structure R635ExactImageScalarContractSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  scalarRankOneObligationCount : Nat
  equivalentToR634 : Bool
  sourceEqualityReplacedByImageEquation : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R635 status: the source equality is equivalent to an exact-image
equation, but no exact-image theorem is asserted. -/
def currentR635ExactImageScalarContractSnapshot :
    R635ExactImageScalarContractSnapshot where
  proofWorkObligationCount := currentR635ExactImageScalarContractTargetNames.length
  exactImageCarrierObligationCount := 2
  scalarRankOneObligationCount := 1
  equivalentToR634 := true
  sourceEqualityReplacedByImageEquation := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R635 substantive theorem (7/8)**: kernel-checked numeric status for
the exact-image contract ledger. -/
theorem currentR635ExactImageScalarContractSnapshot_eq_texStatus :
    currentR635ExactImageScalarContractSnapshot =
      ({ proofWorkObligationCount := 3
         exactImageCarrierObligationCount := 2
         scalarRankOneObligationCount := 1
         equivalentToR634 := true
         sourceEqualityReplacedByImageEquation := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R635ExactImageScalarContractSnapshot) := by
  decide

/-- **R635 substantive theorem (8/8)**: kernel-checked target names for the
exact-image contract ledger. -/
theorem currentR635ExactImageScalarContractTargetNames_eq_texStatus :
    currentR635ExactImageScalarContractTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove scalar/rank-one target"
    ] := by
  rfl

def R635_substantiveTheoremCount : Nat := 8

end FrontC71_H8ResidualSourceInvariantExactImageContract
end HCGapL4
end HodgeReduction
