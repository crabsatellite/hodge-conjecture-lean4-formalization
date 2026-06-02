/-
# HC Gap L4 -- Front C189: finite upper target as target line (R754).

R753 leaves the current equivalent frontier with four proof-work targets:

* `compactDual = H8`;
* `surjectivity_source = compactDual`;
* finite-dimensional `trivialModulePart`;
* `finrank trivialModulePart <= 1`.

The last two fields are exactly the target-line containment once the first
field supplies `H8 <= compactDual`.  This file uses the older R734 bridge to
collapse those two target-side fields into one concrete line target:

  `trivialModulePart <= span {j_q(h^4)}`.

So the current equivalent frontier can be attacked as three targets:

* prove `compactDual = H8`;
* prove `surjectivity_source = compactDual`;
* prove `trivialModulePart <= span {j_q(h^4)}`.

No field is proved outright, and no finite-dimensional witness is hidden: the
line target rebuilds it through the kernel-checked R734 equivalence.
-/

import HodgeReduction.HCGapL4.FrontC188_H8ResidualTargetNonzeroFromCompactDual
import HodgeReduction.HCGapL4.FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC189_H8ResidualFiniteUpperToTargetLineRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC169_H8ResidualTargetLineFiniteMultiplicityEquivalence
open FrontC187_H8ResidualTargetRankNonzeroSplit
open FrontC188_H8ResidualTargetNonzeroFromCompactDual

section FiniteUpperToTargetLine

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

/-- **R754 substantive theorem (1/7)**: `compactDual = H8` supplies the
`H8 <= compactDual` hypothesis required by the R734 target-line bridge. -/
theorem H8_le_compactDual_of_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    CompactDualData.H8 (A := A) <=
      MatsushimaCompactDualData.compactDual (A := A) (B := B) := by
  intro alpha halpha
  rw [hcompact]
  exact halpha

/-- **R754 substantive theorem (2/7)**: once `compactDual = H8` is one of
the route fields, finite-dimensionality plus the rank-one upper bound for
`trivialModulePart` is exactly the target-line containment. -/
theorem finiteUpper_iff_targetLine_under_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) /\
      Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) <= 1) <->
      (CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :=
  (trivialModulePart_le_h_pow_four_line_iff_finiteMultiplicity_under_H8_le_compactDual
    (A := A) (B := B)
    (H8_le_compactDual_of_compactDual_eq_H8
      (A := A) (B := B) hcompact)).symm

/-- R754 primitive spelling of the frontier: the finite/upper target-side
pair from R753 is replaced by the target-line containment. -/
structure EVIIH8ResidualCompactDualH8SourceTargetLineContract
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
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

/-- **R754 substantive theorem (3/7)**: the four-field R753 finite/upper
contract supplies the three-field target-line contract. -/
def targetLineContract_of_finiteUpperContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetLineContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_le_h_pow_four_line :=
    (finiteUpper_iff_targetLine_under_compactDual_eq_H8
      (A := A) (B := B) O.compactDual_eq_H8).1
      (And.intro
        O.trivialModulePart_finite
        O.trivialModulePart_finrank_le_one)

/-- **R754 substantive theorem (4/7)**: the target-line contract rebuilds
the explicit finite/upper contract through R734. -/
def finiteUpperContract_of_targetLineContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetLineContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_finite :=
    ((finiteUpper_iff_targetLine_under_compactDual_eq_H8
      (A := A) (B := B) O.compactDual_eq_H8).2
      O.trivialModulePart_le_h_pow_four_line).1
  trivialModulePart_finrank_le_one :=
    ((finiteUpper_iff_targetLine_under_compactDual_eq_H8
      (A := A) (B := B) O.compactDual_eq_H8).2
      O.trivialModulePart_le_h_pow_four_line).2

/-- **R754 substantive theorem (5/7)**: R753 and R754 are the same inhabited
frontier; only the target-side spelling changed. -/
theorem residual_finiteUpper_nonempty_iff_targetLine_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetLineContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (targetLineContract_of_finiteUpperContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteUpperContract_of_targetLineContract
            (A := A) (B := B) O)))

/-- **R754 substantive theorem (6/7)**: the R752 rank split frontier is
equivalently the R754 target-line frontier. -/
theorem residual_rankSplit_nonempty_iff_targetLine_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetLineContract A B) :=
  (residual_rankSplit_nonempty_iff_finiteUpper_nonempty
    (A := A) (B := B)).trans
    (residual_finiteUpper_nonempty_iff_targetLine_nonempty
      (A := A) (B := B))

/-- **R754 substantive theorem (7/7)**: the current boundary/compact-dual-H8
frontier is equivalently the R754 three-target line frontier. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_targetLine_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetLineContract A B) :=
  (residual_boundaryDataCompactDualH8_nonempty_iff_finiteUpper_nonempty
    (A := A) (B := B)).trans
    (residual_finiteUpper_nonempty_iff_targetLine_nonempty
      (A := A) (B := B))

end FiniteUpperToTargetLine

/-- R754 target names for route summaries. -/
def currentR754FiniteUpperToTargetLineTargetNames : List String := [
  "prove compactDual = H8",
  "prove surjectivity_source = compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R754 finite/upper-to-line route. -/
structure R754FiniteUpperToTargetLineSnapshot where
  proofWorkObligationCount : Nat
  compactDualH8SuppliesH8Containment : Bool
  finiteUpperEquivalentToTargetLineUnderCompactDualH8 : Bool
  finiteUpperFrontierEquivalentToTargetLineFrontier : Bool
  rankSplitEquivalentToTargetLineFrontier : Bool
  boundaryCompactDualH8EquivalentToTargetLineFrontier : Bool
  finiteDimensionalWitnessRebuildableFromTargetLine : Bool
  upperBoundRebuildableFromTargetLine : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceBoundary : Bool
  provesTargetLineContainment : Bool
  provesFiniteTrivialMultiplicity : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R754 status: the target-side finite/upper pair is rewritten as
one target-line containment under the existing compact-dual-H8 field. -/
def currentR754FiniteUpperToTargetLineSnapshot :
    R754FiniteUpperToTargetLineSnapshot where
  proofWorkObligationCount := currentR754FiniteUpperToTargetLineTargetNames.length
  compactDualH8SuppliesH8Containment := true
  finiteUpperEquivalentToTargetLineUnderCompactDualH8 := true
  finiteUpperFrontierEquivalentToTargetLineFrontier := true
  rankSplitEquivalentToTargetLineFrontier := true
  boundaryCompactDualH8EquivalentToTargetLineFrontier := true
  finiteDimensionalWitnessRebuildableFromTargetLine := true
  upperBoundRebuildableFromTargetLine := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceBoundary := false
  provesTargetLineContainment := false
  provesFiniteTrivialMultiplicity := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R754 target-line route. -/
theorem currentR754FiniteUpperToTargetLineSnapshot_eq_texStatus :
    currentR754FiniteUpperToTargetLineSnapshot =
      ({ proofWorkObligationCount := 3
         compactDualH8SuppliesH8Containment := true
         finiteUpperEquivalentToTargetLineUnderCompactDualH8 := true
         finiteUpperFrontierEquivalentToTargetLineFrontier := true
         rankSplitEquivalentToTargetLineFrontier := true
         boundaryCompactDualH8EquivalentToTargetLineFrontier := true
         finiteDimensionalWitnessRebuildableFromTargetLine := true
         upperBoundRebuildableFromTargetLine := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceBoundary := false
         provesTargetLineContainment := false
         provesFiniteTrivialMultiplicity := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R754FiniteUpperToTargetLineSnapshot) := by
  decide

/-- Kernel-checked target names for the R754 route refinement. -/
theorem currentR754FiniteUpperToTargetLineTargetNames_eq_texStatus :
    currentR754FiniteUpperToTargetLineTargetNames = [
      "prove compactDual = H8",
      "prove surjectivity_source = compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R754_substantiveTheoremCount : Nat := 7

end FrontC189_H8ResidualFiniteUpperToTargetLineRoute
end HCGapL4
end HodgeReduction
