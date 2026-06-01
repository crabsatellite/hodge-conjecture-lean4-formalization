/-
# HC Gap L4 -- Front C142: compact-dual no-extra as finite rank plus generator (R707).

R705 exposed the compact-dual-H8 target as two carrier facts:

* `compactDual <= H8`;
* `h^4 in compactDual`.

R706 then blocked deriving either fact from boundary data alone.  This file
keeps the attack on the compact-dual side, but changes the first carrier fact
to a more geometric finite-rank target.  If `compactDual` is finite-dimensional
of rank at most one and contains the nonzero generator `h^4`, then every
compact-dual class lies on the `H8 = span {h^4}` line.

The resulting finite-rank carrier contract is proved equivalent to the R705
carrier split, so it is not a stronger hidden premise.  It only restates the
next source-side geometry target as an explicit EVII compact-dual dimension
calculation plus generator placement.
-/

import HodgeReduction.HCGapL4.FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
import HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC23_MatsushimaCompactDualRankOne
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit

section RankOneCarrierLemma

variable {A : Type*} [AddCommGroup A] [Module Rat A]

/-- **R707 linear lemma (1/7)**: a finite-dimensional carrier of rank at
most one that contains a nonzero element is contained in the line generated
by that element. -/
theorem carrier_le_span_of_finrank_le_one_and_mem
    (P : Submodule Rat A) {x : A}
    [FiniteDimensional Rat P]
    (hfin : Module.finrank (R := Rat) P <= 1)
    (hxP : P.carrier x) (hxne : x ≠ 0) :
    LE.le P (Submodule.span Rat ({x} : Set A)) := by
  intro y hyP
  let xP : P := ⟨x, hxP⟩
  have hxP_ne : xP ≠ 0 := by
    intro hzero
    apply hxne
    exact congrArg Subtype.val hzero
  haveI : Nontrivial P := ⟨⟨xP, 0, hxP_ne⟩⟩
  have hP_pos : 0 < Module.finrank (R := Rat) P :=
    Module.finrank_pos (R := Rat) (M := P)
  have hP_one : Module.finrank (R := Rat) P = 1 := by
    omega
  let lineP : Submodule Rat P := Submodule.span Rat ({xP} : Set P)
  have hline_top : lineP = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    dsimp [lineP]
    rw [finrank_span_singleton hxP_ne, hP_one]
  have hy_lineP : (⟨y, hyP⟩ : P) ∈ lineP := by
    rw [hline_top]
    trivial
  dsimp [lineP] at hy_lineP
  rw [Submodule.mem_span_singleton] at hy_lineP
  obtain ⟨r, hr⟩ := hy_lineP
  rw [Submodule.mem_span_singleton]
  refine ⟨r, ?_⟩
  simpa [xP] using congrArg Subtype.val hr

end RankOneCarrierLemma

section CompactDualFiniteRankCarrier

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

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R707 substantive theorem (2/7)**: finite rank at most one plus
generator membership proves the R705 no-extra compact-dual carrier fact. -/
theorem compactDual_le_H8_of_finite_rank_le_one_and_h_pow_four_mem
    [FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))]
    (hfin :
      Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1)
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A)) := by
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact
    carrier_le_span_of_finrank_le_one_and_mem
      (A := A)
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      hfin
      hh_compact
      (KaehlerClass.h_pow_4_ne_zero (A := A))

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R707 substantive theorem (3/7)**: the R705 no-extra carrier fact
supplies the explicit finite-dimensional witness for `compactDual`. -/
theorem compactDual_finiteDimensional_of_compactDual_le_H8
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) := by
  have hH8_rank : Module.finrank (R := Rat) (CompactDualData.H8 (A := A)) = 1 :=
    compactDual_H8_finrank_eq_one (A := A)
  haveI : FiniteDimensional Rat (CompactDualData.H8 (A := A)) :=
    Module.finite_of_finrank_eq_succ
      (R := Rat) (M := CompactDualData.H8 (A := A)) (n := 0) hH8_rank
  exact Submodule.finiteDimensional_of_le hcompact_le_H8

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R707 substantive theorem (4/7)**: the R705 no-extra carrier fact
also supplies the finite rank-one upper bound for `compactDual`. -/
theorem compactDual_finrank_le_one_of_compactDual_le_H8
    (hcompact_le_H8 :
      LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
        (CompactDualData.H8 (A := A))) :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1 := by
  have hH8_rank : Module.finrank (R := Rat) (CompactDualData.H8 (A := A)) = 1 :=
    compactDual_H8_finrank_eq_one (A := A)
  haveI : FiniteDimensional Rat (CompactDualData.H8 (A := A)) :=
    Module.finite_of_finrank_eq_succ
      (R := Rat) (M := CompactDualData.H8 (A := A)) (n := 0) hH8_rank
  have hmono :=
    Submodule.finrank_mono
      (R := Rat)
      (s := MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (t := CompactDualData.H8 (A := A))
      hcompact_le_H8
  simpa [hH8_rank] using hmono

/-- Boundary data plus the finite-rank form of the compact-dual carrier
route.  This is the R705 carrier split with `compactDual <= H8` replaced
by the equivalent explicit finite-dimensional rank-one target. -/
structure EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract
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
  compactDual_finite :
    FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  compactDual_finrank_le_one :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)

/-- **R707 substantive theorem (5/7)**: the finite-rank carrier contract
feeds the R705 carrier-split contract. -/
def boundaryDataCompactDualCarrierSplitContract_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B := by
  haveI :
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    O.compactDual_finite
  exact
    { boundary := O.boundary
      compactDual_le_H8 :=
        compactDual_le_H8_of_finite_rank_le_one_and_h_pow_four_mem
          (A := A) (B := B)
          O.compactDual_finrank_le_one
          O.h_pow_four_mem_compactDual
      h_pow_four_mem_compactDual := O.h_pow_four_mem_compactDual }

/-- **R707 substantive theorem (6/7)**: the R705 carrier-split contract
recovers the equivalent finite-rank carrier contract. -/
def finiteRankCarrierContract_of_boundaryDataCompactDualCarrierSplitContract
    (O : EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B where
  boundary := O.boundary
  compactDual_finite :=
    compactDual_finiteDimensional_of_compactDual_le_H8
      (A := A) (B := B) O.compactDual_le_H8
  compactDual_finrank_le_one :=
    compactDual_finrank_le_one_of_compactDual_le_H8
      (A := A) (B := B) O.compactDual_le_H8
  h_pow_four_mem_compactDual := O.h_pow_four_mem_compactDual

/-- **R707 substantive theorem (7/7)**: the R705 carrier-split route and
the finite-rank carrier route are the same inhabited residual contract. -/
theorem residual_boundaryDataCompactDualCarrierSplit_nonempty_iff_finiteRankCarrier_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteRankCarrierContract_of_boundaryDataCompactDualCarrierSplitContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualCarrierSplitContract_of_finiteRankCarrierContract
            (A := A) (B := B) O)))

end CompactDualFiniteRankCarrier

/-- R707 target names for route summaries. -/
def currentR707CompactDualFiniteRankCarrierTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove finite-dimensional compactDual and finrank compactDual <= 1",
  "prove h^4 in compactDual"
]

/-- Machine-readable status for the R707 finite-rank carrier route. -/
structure R707CompactDualFiniteRankCarrierSnapshot where
  proofWorkObligationCount : Nat
  finiteRankPlusGeneratorGivesCompactDualNoExtra : Bool
  carrierSplitGivesCompactDualFiniteRank : Bool
  finiteRankRouteEquivalentToCarrierSplit : Bool
  provesBoundaryData : Bool
  provesCompactDualFiniteRank : Bool
  provesCompactDualGeneratorMembership : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R707 status: no-extra compact-dual classes can be attacked as an
explicit finite-rank theorem plus the same generator-membership target. -/
def currentR707CompactDualFiniteRankCarrierSnapshot :
    R707CompactDualFiniteRankCarrierSnapshot where
  proofWorkObligationCount :=
    currentR707CompactDualFiniteRankCarrierTargetNames.length
  finiteRankPlusGeneratorGivesCompactDualNoExtra := true
  carrierSplitGivesCompactDualFiniteRank := true
  finiteRankRouteEquivalentToCarrierSplit := true
  provesBoundaryData := false
  provesCompactDualFiniteRank := false
  provesCompactDualGeneratorMembership := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R707 route ledger. -/
theorem currentR707CompactDualFiniteRankCarrierSnapshot_eq_texStatus :
    currentR707CompactDualFiniteRankCarrierSnapshot =
      ({ proofWorkObligationCount := 3
         finiteRankPlusGeneratorGivesCompactDualNoExtra := true
         carrierSplitGivesCompactDualFiniteRank := true
         finiteRankRouteEquivalentToCarrierSplit := true
         provesBoundaryData := false
         provesCompactDualFiniteRank := false
         provesCompactDualGeneratorMembership := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R707CompactDualFiniteRankCarrierSnapshot) := by
  decide

/-- Kernel-checked target names for the R707 route. -/
theorem currentR707CompactDualFiniteRankCarrierTargetNames_eq_texStatus :
    currentR707CompactDualFiniteRankCarrierTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove finite-dimensional compactDual and finrank compactDual <= 1",
      "prove h^4 in compactDual"
    ] := by
  rfl

def R707_substantiveTheoremCount : Nat := 7

end FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
end HCGapL4
end HodgeReduction
