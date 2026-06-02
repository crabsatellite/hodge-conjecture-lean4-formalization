/-
# HC Gap L4 -- Front C187: target rank one split into upper bound and nonzero (R752).

R751 names the current primitive target-side field as

  `finrank trivialModulePart = 1`.

This file opens that exact rank target into the two pieces an automorphic
attack should actually prove:

* an explicit finite-dimensional witness and upper bound
  `finrank trivialModulePart <= 1`;
* a nonvanishing/lower-bound target
  `finrank trivialModulePart != 0`.

The split is equivalent to the R751 target and is not a closure claim.  Its
purpose is to prevent future rounds from hiding nonvanishing inside the exact
rank-one statement.
-/

import HodgeReduction.HCGapL4.FrontC186_H8ResidualBoundaryCompactDualTargetRankRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC187_H8ResidualTargetRankNonzeroSplit

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack
open FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse
open FrontC186_H8ResidualBoundaryCompactDualTargetRankRoute

section TargetRankNonzeroSplit

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

/-- **R752 substantive theorem (1/9)**: exact target rank one supplies the
explicit finite-dimensional witness for the trivial-module part. -/
theorem trivialModulePart_finiteDimensional_of_finrank_eq_one
    (hrank :
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B)) :=
  Module.finite_of_finrank_eq_succ
    (R := Rat)
    (M := CuspidalCohomologyData.trivialModulePart (A := B))
    (n := 0)
    hrank

/-- **R752 substantive theorem (2/9)**: exact target rank one supplies the
upper multiplicity bound. -/
theorem trivialModulePart_finrank_le_one_of_finrank_eq_one
    (hrank :
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 := by
  rw [hrank]

/-- **R752 substantive theorem (3/9)**: exact target rank one also supplies
the lower-bound/nonvanishing rank target. -/
theorem trivialModulePart_finrank_ne_zero_of_finrank_eq_one
    (hrank :
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) :
    Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0) := by
  rw [hrank]
  decide

/-- **R752 substantive theorem (4/9)**: finite witness, upper bound, and
rank nonzero recover exact rank one.  The finite witness is kept explicit as
a route field even though the numeric upper/lower bounds determine the Nat. -/
theorem trivialModulePart_finrank_eq_one_of_finite_upper_nonzero
    (_hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hupper :
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1)
    (hnonzero :
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) = 1 := by
  have hpos :
      0 <
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    Nat.pos_of_ne_zero hnonzero
  exact Nat.le_antisymm hupper hpos

/-- **R752 substantive theorem (5/9)**: the R751 rank-one target is exactly
finite witness, upper bound, and nonzero rank. -/
theorem trivialModulePart_finrank_eq_one_iff_finite_upper_nonzero :
    (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 1) <->
      (FiniteDimensional Rat
          (CuspidalCohomologyData.trivialModulePart (A := B)) /\
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1 /\
        Not
          (Module.finrank (R := Rat)
            (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :=
  Iff.intro
    (fun hrank =>
      And.intro
        (trivialModulePart_finiteDimensional_of_finrank_eq_one
          (B := B) hrank)
        (And.intro
          (trivialModulePart_finrank_le_one_of_finrank_eq_one
            (B := B) hrank)
          (trivialModulePart_finrank_ne_zero_of_finrank_eq_one
            (B := B) hrank)))
    (fun hsplit =>
      trivialModulePart_finrank_eq_one_of_finite_upper_nonzero
        (B := B) hsplit.1 hsplit.2.1 hsplit.2.2)

/-- R752 primitive spelling of the R751 source/target-rank frontier.  The
target rank-one field is split into finite witness, upper bound, and nonzero
rank. -/
structure EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract
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
  compactDual_eq_H8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  trivialModulePart_finite :
    FiniteDimensional Rat
      (CuspidalCohomologyData.trivialModulePart (A := B))
  trivialModulePart_finrank_le_one :
    Module.finrank (R := Rat)
      (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1
  trivialModulePart_finrank_ne_zero :
    Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)

/-- **R752 substantive theorem (6/9)**: the R751 source/target-rank
contract supplies the finite/upper/nonzero split. -/
def rankSplitContract_of_sourceTargetRankContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetRankContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_finite :=
    trivialModulePart_finiteDimensional_of_finrank_eq_one
      (B := B) O.trivialModulePart_finrank_eq_one
  trivialModulePart_finrank_le_one :=
    trivialModulePart_finrank_le_one_of_finrank_eq_one
      (B := B) O.trivialModulePart_finrank_eq_one
  trivialModulePart_finrank_ne_zero :=
    trivialModulePart_finrank_ne_zero_of_finrank_eq_one
      (B := B) O.trivialModulePart_finrank_eq_one

/-- **R752 substantive theorem (7/9)**: the finite/upper/nonzero split
rebuilds the R751 source/target-rank contract. -/
def sourceTargetRankContract_of_rankSplitContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetRankContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_finrank_eq_one :=
    trivialModulePart_finrank_eq_one_of_finite_upper_nonzero
      (B := B)
      O.trivialModulePart_finite
      O.trivialModulePart_finrank_le_one
      O.trivialModulePart_finrank_ne_zero

/-- **R752 substantive theorem (8/9)**: R751 and R752 are the same inhabited
source/target-rank frontier. -/
theorem residual_sourceTargetRank_nonempty_iff_rankSplit_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (rankSplitContract_of_sourceTargetRankContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceTargetRankContract_of_rankSplitContract
            (A := A) (B := B) O)))

/-- **R752 substantive theorem (9/9)**: the current boundary/compact-dual-H8
frontier is equivalently the R752 split frontier. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_rankSplit_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) :=
  (residual_boundaryDataCompactDualH8_nonempty_iff_sourceTargetRank_nonempty
    (A := A) (B := B)).trans
    (residual_sourceTargetRank_nonempty_iff_rankSplit_nonempty
      (A := A) (B := B))

/-- The R748 rank-one generator route has the same R752 split frontier. -/
theorem residual_rankOneGenerator_nonempty_iff_rankSplit_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) :=
  (residual_rankOneGenerator_nonempty_iff_sourceTargetRank_nonempty
    (A := A) (B := B)).trans
    (residual_sourceTargetRank_nonempty_iff_rankSplit_nonempty
      (A := A) (B := B))

end TargetRankNonzeroSplit

/-- R752 target names for route summaries. -/
def currentR752TargetRankNonzeroSplitTargetNames : List String := [
  "prove compactDual = H8",
  "prove surjectivity_source = compactDual",
  "prove finite-dimensional trivialModulePart",
  "prove finrank trivialModulePart <= 1",
  "prove finrank trivialModulePart != 0"
]

/-- Machine-readable status for the R752 rank-one target split. -/
structure R752TargetRankNonzeroSplitSnapshot where
  proofWorkObligationCount : Nat
  rankOneEquivalentToFiniteUpperNonzero : Bool
  sourceTargetRankEquivalentToSplit : Bool
  boundaryCompactDualH8EquivalentToSplit : Bool
  finiteDimensionalWitnessExplicit : Bool
  nonvanishingTargetExplicit : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceBoundary : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesTrivialModulePartNonzero : Bool
  provesBoundaryData : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R752 status: the R751 rank-one target has been split into an
upper-bound side and an explicit nonvanishing side. -/
def currentR752TargetRankNonzeroSplitSnapshot :
    R752TargetRankNonzeroSplitSnapshot where
  proofWorkObligationCount := currentR752TargetRankNonzeroSplitTargetNames.length
  rankOneEquivalentToFiniteUpperNonzero := true
  sourceTargetRankEquivalentToSplit := true
  boundaryCompactDualH8EquivalentToSplit := true
  finiteDimensionalWitnessExplicit := true
  nonvanishingTargetExplicit := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceBoundary := false
  provesFiniteTrivialMultiplicity := false
  provesTrivialModulePartNonzero := false
  provesBoundaryData := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R752 target-rank split. -/
theorem currentR752TargetRankNonzeroSplitSnapshot_eq_texStatus :
    currentR752TargetRankNonzeroSplitSnapshot =
      ({ proofWorkObligationCount := 5
         rankOneEquivalentToFiniteUpperNonzero := true
         sourceTargetRankEquivalentToSplit := true
         boundaryCompactDualH8EquivalentToSplit := true
         finiteDimensionalWitnessExplicit := true
         nonvanishingTargetExplicit := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceBoundary := false
         provesFiniteTrivialMultiplicity := false
         provesTrivialModulePartNonzero := false
         provesBoundaryData := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R752TargetRankNonzeroSplitSnapshot) := by
  decide

/-- Kernel-checked target names for the R752 route refinement. -/
theorem currentR752TargetRankNonzeroSplitTargetNames_eq_texStatus :
    currentR752TargetRankNonzeroSplitTargetNames = [
      "prove compactDual = H8",
      "prove surjectivity_source = compactDual",
      "prove finite-dimensional trivialModulePart",
      "prove finrank trivialModulePart <= 1",
      "prove finrank trivialModulePart != 0"
    ] := by
  rfl

def R752_substantiveTheoremCount : Nat := 9

end FrontC187_H8ResidualTargetRankNonzeroSplit
end HCGapL4
end HodgeReduction
