/-
# HC Gap L4 -- Front C188: target nonvanishing from compact-dual generator (R753).

R752 made the target nonvanishing obligation explicit:

  `finrank trivialModulePart != 0`.

This file proves that this is not an independent fifth target once the current
frontier already includes `compactDual = H8` and an explicit finite-dimensional
witness for `trivialModulePart`.  The compact-dual equality places `h^4` in the
compact-dual carrier; the existing compact-dual/source comparison places it in
`source_invariants`; Matsushima equivariance then puts `j_q(h^4)` in
`trivialModulePart`, and injectivity plus `h^4 != 0` makes this class nonzero.

Thus the R752 split frontier is equivalent to four proof-work targets:

* prove `compactDual = H8`;
* prove `surjectivity_source = compactDual`;
* prove finite-dimensional `trivialModulePart`;
* prove `finrank trivialModulePart <= 1`.

No target is proved outright, and the finite-dimensional witness is not hidden.
-/

import HodgeReduction.HCGapL4.FrontC187_H8ResidualTargetRankNonzeroSplit
import HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual
import HodgeReduction.HCGapL4.FrontC123_H8ResidualGeneratorMultiplicityRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC188_H8ResidualTargetNonzeroFromCompactDual

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC92_H8ResidualCartanGeneratorLineCriterion
open FrontC96_H8ResidualSourceGeneratorFromCompactDual
open FrontC123_H8ResidualGeneratorMultiplicityRoute
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse
open FrontC187_H8ResidualTargetRankNonzeroSplit

section TargetNonzeroFromCompactDual

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

/-- **R753 substantive theorem (1/10)**: for a finite-dimensional
trivial-module part, nonzero finrank is the same as an actual nonzero
trivial-module class.  This direction extracts the witness. -/
theorem exists_nonzero_trivialModulePart_class_of_finrank_ne_zero
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hnonzero :
      Not
        (Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) :
    Exists fun beta : B =>
      (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
        Not (beta = 0) := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) := hfinite
  have hpos :
      0 <
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    Nat.pos_of_ne_zero hnonzero
  obtain ⟨betaSub, hbetaSub_ne⟩ :=
    (Module.finrank_pos_iff_exists_ne_zero).mp hpos
  exact ⟨betaSub.1, betaSub.2, fun hzero => hbetaSub_ne (Subtype.ext hzero)⟩

/-- **R753 substantive theorem (2/10)**: for a finite-dimensional
trivial-module part, a nonzero class gives nonzero finrank. -/
theorem trivialModulePart_finrank_ne_zero_of_exists_nonzero_class
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hwitness :
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0)) :
    Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0) := by
  haveI :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)) := hfinite
  obtain ⟨beta, hbeta_mem, hbeta_ne⟩ := hwitness
  let betaSub : CuspidalCohomologyData.trivialModulePart (A := B) :=
    ⟨beta, hbeta_mem⟩
  have hbetaSub_ne : Not (betaSub = 0) := by
    intro hzero
    exact hbeta_ne (congrArg Subtype.val hzero)
  have hpos :
      0 <
        Module.finrank (R := Rat)
          (CuspidalCohomologyData.trivialModulePart (A := B)) :=
    (Module.finrank_pos_iff_exists_ne_zero).mpr ⟨betaSub, hbetaSub_ne⟩
  intro hzero
  rw [hzero] at hpos
  exact Nat.lt_irrefl 0 hpos

/-- **R753 substantive theorem (3/10)**: finite-dimensional nonzero finrank
is exactly the existence of a nonzero trivial-module class. -/
theorem trivialModulePart_finrank_ne_zero_iff_exists_nonzero_class
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B))) :
    (Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0)) <->
      Exists fun beta : B =>
        (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
          Not (beta = 0) :=
  Iff.intro
    (exists_nonzero_trivialModulePart_class_of_finrank_ne_zero
      (B := B) hfinite)
    (trivialModulePart_finrank_ne_zero_of_exists_nonzero_class
      (B := B) hfinite)

/-- **R753 substantive theorem (4/10)**: source generator membership supplies
the concrete nonzero class `j_q(h^4)` in the trivial-module part. -/
theorem exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_source
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Exists fun beta : B =>
      (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
        Not (beta = 0) := by
  exact
    ⟨MatsushimaData.j_q (A := A) (B := B)
        ((KaehlerClass.h : A) ^ 4),
      matsushima_h_pow_four_mem_trivialModulePart_of_h_pow_four_mem_source
        (A := A) (B := B) hh_source,
      matsushima_h_pow_four_image_ne_zero (A := A) (B := B)⟩

/-- **R753 substantive theorem (5/10)**: finite-dimensionality plus source
generator membership proves the R752 nonzero finrank target. -/
theorem trivialModulePart_finrank_ne_zero_of_h_pow_four_mem_source
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hh_source :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0) :=
  trivialModulePart_finrank_ne_zero_of_exists_nonzero_class
    (B := B)
    hfinite
    (exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_source
      (A := A) (B := B) hh_source)

/-- **R753 substantive theorem (6/10)**: compact-dual generator membership
supplies the same nonzero trivial-module witness through the existing
compact-dual/source comparison. -/
theorem exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_compactDual
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Exists fun beta : B =>
      (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
        Not (beta = 0) :=
  exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_source
    (A := A) (B := B)
    (h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)

/-- **R753 substantive theorem (7/10)**: finite-dimensionality plus
compact-dual generator membership proves nonzero finrank. -/
theorem trivialModulePart_finrank_ne_zero_of_h_pow_four_mem_compactDual
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0) :=
  trivialModulePart_finrank_ne_zero_of_exists_nonzero_class
    (B := B)
    hfinite
    (exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_compactDual
      (A := A) (B := B) hh_compact)

/-- **R753 substantive theorem (8/10)**: the current `compactDual = H8`
target already supplies the concrete nonzero trivial-module witness. -/
theorem exists_nonzero_trivialModulePart_class_of_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Exists fun beta : B =>
      (CuspidalCohomologyData.trivialModulePart (A := B)).carrier beta /\
        Not (beta = 0) :=
  exists_nonzero_trivialModulePart_class_of_h_pow_four_mem_compactDual
    (A := A) (B := B)
    (h_pow_four_mem_compactDual_of_compactDual_eq_H8
      (A := A) (B := B) hcompact)

/-- **R753 substantive theorem (9/10)**: with the finite witness made
explicit, `compactDual = H8` proves the R752 target nonvanishing field. -/
theorem trivialModulePart_finrank_ne_zero_of_compactDual_eq_H8
    (hfinite :
      FiniteDimensional Rat
        (CuspidalCohomologyData.trivialModulePart (A := B)))
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Not
      (Module.finrank (R := Rat)
        (CuspidalCohomologyData.trivialModulePart (A := B)) = 0) :=
  trivialModulePart_finrank_ne_zero_of_exists_nonzero_class
    (B := B)
    hfinite
    (exists_nonzero_trivialModulePart_class_of_compactDual_eq_H8
      (A := A) (B := B) hcompact)

/-- R753 primitive spelling of the frontier after discharging the nonzero
rank field from `compactDual = H8` plus finite-dimensionality. -/
structure EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract
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

/-- **R753 substantive theorem (10/10)**: the four-field R753 contract
rebuilds the R752 finite/upper/nonzero split; the nonzero field is derived,
not assumed. -/
def rankSplitContract_of_finiteUpperContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_finite := O.trivialModulePart_finite
  trivialModulePart_finrank_le_one := O.trivialModulePart_finrank_le_one
  trivialModulePart_finrank_ne_zero :=
    trivialModulePart_finrank_ne_zero_of_compactDual_eq_H8
      (A := A) (B := B)
      O.trivialModulePart_finite
      O.compactDual_eq_H8

/-- The R752 split frontier forgets to the four-field R753 frontier. -/
def finiteUpperContract_of_rankSplitContract
    (O : EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) :
    EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B where
  compactDual_eq_H8 := O.compactDual_eq_H8
  source_eq_compactDual := O.source_eq_compactDual
  trivialModulePart_finite := O.trivialModulePart_finite
  trivialModulePart_finrank_le_one := O.trivialModulePart_finrank_le_one

/-- The R752 split frontier and the R753 four-target frontier are the same
inhabited residual ledger. -/
theorem residual_rankSplit_nonempty_iff_finiteUpper_nonempty :
    Nonempty (EVIIH8ResidualCompactDualH8SourceTargetRankSplitContract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteUpperContract_of_rankSplitContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (rankSplitContract_of_finiteUpperContract
            (A := A) (B := B) O)))

/-- The current boundary/compact-dual-H8 frontier is equivalently the R753
four-target frontier. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_finiteUpper_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualCompactDualH8SourceTargetFiniteUpperContract A B) :=
  (residual_boundaryDataCompactDualH8_nonempty_iff_rankSplit_nonempty
    (A := A) (B := B)).trans
    (residual_rankSplit_nonempty_iff_finiteUpper_nonempty
      (A := A) (B := B))

end TargetNonzeroFromCompactDual

/-- R753 target names for route summaries. -/
def currentR753TargetNonzeroFromCompactDualTargetNames : List String := [
  "prove compactDual = H8",
  "prove surjectivity_source = compactDual",
  "prove finite-dimensional trivialModulePart",
  "prove finrank trivialModulePart <= 1"
]

/-- Machine-readable status for the R753 target-nonzero discharge. -/
structure R753TargetNonzeroFromCompactDualSnapshot where
  proofWorkObligationCount : Nat
  nonzeroFinrankEquivalentToNonzeroClassUnderFinite : Bool
  sourceGeneratorSuppliesNonzeroClass : Bool
  compactDualGeneratorSuppliesNonzeroClass : Bool
  compactDualH8SuppliesNonzeroClass : Bool
  compactDualH8FiniteSuppliesNonzeroFinrank : Bool
  rankSplitEquivalentToFiniteUpper : Bool
  boundaryCompactDualH8EquivalentToFiniteUpper : Bool
  nonvanishingRemovedAsIndependentTarget : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceBoundary : Bool
  provesFiniteTrivialMultiplicity : Bool
  provesTrivialModulePartUpperBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R753 status: the nonzero target is derived from the existing
compact-dual-H8 target plus the explicit finite-dimensional witness. -/
def currentR753TargetNonzeroFromCompactDualSnapshot :
    R753TargetNonzeroFromCompactDualSnapshot where
  proofWorkObligationCount := currentR753TargetNonzeroFromCompactDualTargetNames.length
  nonzeroFinrankEquivalentToNonzeroClassUnderFinite := true
  sourceGeneratorSuppliesNonzeroClass := true
  compactDualGeneratorSuppliesNonzeroClass := true
  compactDualH8SuppliesNonzeroClass := true
  compactDualH8FiniteSuppliesNonzeroFinrank := true
  rankSplitEquivalentToFiniteUpper := true
  boundaryCompactDualH8EquivalentToFiniteUpper := true
  nonvanishingRemovedAsIndependentTarget := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceBoundary := false
  provesFiniteTrivialMultiplicity := false
  provesTrivialModulePartUpperBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R753 target-nonzero discharge. -/
theorem currentR753TargetNonzeroFromCompactDualSnapshot_eq_texStatus :
    currentR753TargetNonzeroFromCompactDualSnapshot =
      ({ proofWorkObligationCount := 4
         nonzeroFinrankEquivalentToNonzeroClassUnderFinite := true
         sourceGeneratorSuppliesNonzeroClass := true
         compactDualGeneratorSuppliesNonzeroClass := true
         compactDualH8SuppliesNonzeroClass := true
         compactDualH8FiniteSuppliesNonzeroFinrank := true
         rankSplitEquivalentToFiniteUpper := true
         boundaryCompactDualH8EquivalentToFiniteUpper := true
         nonvanishingRemovedAsIndependentTarget := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceBoundary := false
         provesFiniteTrivialMultiplicity := false
         provesTrivialModulePartUpperBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R753TargetNonzeroFromCompactDualSnapshot) := by
  decide

/-- Kernel-checked target names for the R753 route refinement. -/
theorem currentR753TargetNonzeroFromCompactDualTargetNames_eq_texStatus :
    currentR753TargetNonzeroFromCompactDualTargetNames = [
      "prove compactDual = H8",
      "prove surjectivity_source = compactDual",
      "prove finite-dimensional trivialModulePart",
      "prove finrank trivialModulePart <= 1"
    ] := by
  rfl

def R753_substantiveTheoremCount : Nat := 10

end FrontC188_H8ResidualTargetNonzeroFromCompactDual
end HCGapL4
end HodgeReduction
