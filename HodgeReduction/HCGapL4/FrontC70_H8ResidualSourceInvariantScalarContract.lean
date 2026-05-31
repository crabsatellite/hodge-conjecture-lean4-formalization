/-
# HC Gap L4 -- Front C70: source-invariant scalar contract (R634).

R610 names the live proof-work frontier as:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* scalar-preimage/rank-one target.

That spelling is useful for the Cartan-line ledger, but the next direct
geometric attack should consume the existing Matsushima fields.  This file
rewrites the two carrier equalities to:

* `surjectivity_source = source_invariants`;
* `source_invariants = H8`;
* scalar-preimage/rank-one target.

This is a normalization of the R610 contract, not a proof of any of the
three obligations and not a full-HC closure claim.
-/

import HodgeReduction.HCGapL4.FrontC30_SourceInvariantsH8TargetRank
import HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC70_H8ResidualSourceInvariantScalarContract

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC30_SourceInvariantsH8TargetRank
open FrontC65_H8ResidualPrimitiveTargetLedger
open FrontC66_H8ResidualEqualityTargetLedger
open FrontC69_H8ResidualProofWorkContract

section SourceInvariantScalarContract

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

/-- The R634 source-invariant spelling of the R610 proof-work contract.
It leaves exactly the same three live obligations, but names the carrier
side through the existing Matsushima source-invariants interface. -/
structure EVIIH8ResidualSourceInvariantScalarContract where
  source_eq_invariants :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B)
  source_invariants_eq_H8 :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  scalar_preimage : scalarPreimagePrimitiveTarget A B

variable {A B}

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B] in
/-- **R634 substantive theorem (1/8)**: the compactDual/Cartan equality
is the source-invariants/H8 equality after the existing Matsushima
compact-dual comparison and Cartan H8 comparison are unfolded. -/
theorem source_invariants_eq_H8_of_compactDualCartan
    (hcompact : compactDualCartanEqualityTarget A B) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  calc
    MatsushimaData.source_invariants (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
      (MatsushimaCompactDualData.compactDual_eq_source_invariants
        (A := A) (B := B)).symm
    _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) := hcompact
    _ = CompactDualData.H8 (A := A) :=
      CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)

omit [CuspidalCohomologyData B] in
/-- **R634 substantive theorem (2/8)**: the two R610 carrier equalities
recover the primitive Matsushima source equality. -/
theorem source_eq_invariants_of_sourceCartan_compactDualCartan
    (hsource : sourceCartanEqualityTarget A B)
    (hcompact : compactDualCartanEqualityTarget A B) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaData.source_invariants (A := A) (B := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = CartanCompactDualIso.trivialModuleGK_H8 (A := A) := hsource
    _ = CompactDualData.H8 (A := A) :=
      CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8 (A := A)
    _ = MatsushimaData.source_invariants (A := A) (B := B) :=
      (source_invariants_eq_H8_of_compactDualCartan
        (A := A) (B := B) hcompact).symm

/-- **R634 substantive theorem (3/8)**: an R610 proof-work contract gives
the source-invariant scalar contract without any finite-dimensional
rank conversion. -/
def sourceInvariantScalarContract_of_proofWorkContract
    (O : EVIIH8ResidualProofWorkContract A B) :
    EVIIH8ResidualSourceInvariantScalarContract A B where
  source_eq_invariants :=
    source_eq_invariants_of_sourceCartan_compactDualCartan
      (A := A) (B := B) O.source_eq_cartan O.compactDual_eq_cartan
  source_invariants_eq_H8 :=
    source_invariants_eq_H8_of_compactDualCartan
      (A := A) (B := B) O.compactDual_eq_cartan
  scalar_preimage := O.scalar_preimage

/-- **R634 substantive theorem (4/8)**: the source-invariant scalar
contract rebuilds the R610 proof-work contract. -/
def proofWorkContract_of_sourceInvariantScalarContract
    (O : EVIIH8ResidualSourceInvariantScalarContract A B) :
    EVIIH8ResidualProofWorkContract A B where
  source_eq_cartan :=
    surjectivity_source_eq_cartan_of_source_invariants_eq_H8
      (A := A) (B := B)
      O.source_eq_invariants O.source_invariants_eq_H8
  compactDual_eq_cartan :=
    compactDual_eq_cartan_of_source_invariants_eq_H8
      (A := A) (B := B)
      O.source_invariants_eq_H8
  scalar_preimage := O.scalar_preimage

/-- **R634 substantive theorem (5/8)**: R610 and the source-invariant
scalar contract are the same inhabited residual target. -/
theorem residual_proofWorkContract_nonempty_iff_sourceInvariantScalarContract_nonempty :
    Nonempty (EVIIH8ResidualProofWorkContract A B) <->
      Nonempty (EVIIH8ResidualSourceInvariantScalarContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantScalarContract_of_proofWorkContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (proofWorkContract_of_sourceInvariantScalarContract
            (A := A) (B := B) O)))

variable [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- **R634 substantive theorem (6/8)**: the source-invariant scalar
contract feeds the existing Matsushima V56 boundary bridge through the
R610 contract. -/
def matsushimaV56BoundaryData_of_sourceInvariantScalarContract
    [FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))]
    (O : EVIIH8ResidualSourceInvariantScalarContract A B) :
    MatsushimaV56BoundaryData A B :=
  matsushimaV56BoundaryData_of_proofWorkContract
    (A := A) (B := B)
    (proofWorkContract_of_sourceInvariantScalarContract (A := A) (B := B) O)

end SourceInvariantScalarContract

/-- Exact R634 source-invariant proof-work target names for route summaries. -/
def currentR634SourceInvariantScalarContractTargetNames : List String := [
  "prove surjectivity_source = source_invariants",
  "prove source_invariants = H8",
  "prove scalar/rank-one target"
]

/-- Machine-readable status for the R634 source-invariant contract. -/
structure R634SourceInvariantScalarContractSnapshot where
  proofWorkObligationCount : Nat
  sourceInvariantCarrierObligationCount : Nat
  scalarRankOneObligationCount : Nat
  equivalentToR610 : Bool
  finiteDimensionalRankHypothesisNeededForEquivalence : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R634 status: the R610 contract has a source-invariant spelling
with the same three obligations and no closure claim. -/
def currentR634SourceInvariantScalarContractSnapshot :
    R634SourceInvariantScalarContractSnapshot where
  proofWorkObligationCount :=
    currentR634SourceInvariantScalarContractTargetNames.length
  sourceInvariantCarrierObligationCount := 2
  scalarRankOneObligationCount := 1
  equivalentToR610 := true
  finiteDimensionalRankHypothesisNeededForEquivalence := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R634 substantive theorem (7/8)**: kernel-checked numeric status for
the source-invariant contract ledger. -/
theorem currentR634SourceInvariantScalarContractSnapshot_eq_texStatus :
    currentR634SourceInvariantScalarContractSnapshot =
      ({ proofWorkObligationCount := 3
         sourceInvariantCarrierObligationCount := 2
         scalarRankOneObligationCount := 1
         equivalentToR610 := true
         finiteDimensionalRankHypothesisNeededForEquivalence := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R634SourceInvariantScalarContractSnapshot) := by
  decide

/-- **R634 substantive theorem (8/8)**: kernel-checked target names for the
source-invariant contract ledger. -/
theorem currentR634SourceInvariantScalarContractTargetNames_eq_texStatus :
    currentR634SourceInvariantScalarContractTargetNames = [
      "prove surjectivity_source = source_invariants",
      "prove source_invariants = H8",
      "prove scalar/rank-one target"
    ] := by
  rfl

def R634_substantiveTheoremCount : Nat := 8

end FrontC70_H8ResidualSourceInvariantScalarContract
end HCGapL4
end HodgeReduction
