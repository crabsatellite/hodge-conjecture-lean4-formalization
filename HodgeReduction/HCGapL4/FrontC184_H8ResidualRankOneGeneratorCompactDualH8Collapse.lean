/-
# HC Gap L4 -- Front C184: rank-one generator surface collapses to compactDual = H8 (R749).

R748 rewrites the latest finite-rank attack as three targets:

* `MatsushimaV56BoundaryData`;
* `h^4 in compactDual`;
* `finrank compactDual = 1`.

This file checks that the last two fields are exactly the old
`compactDual = H8` carrier theorem.  The forward direction uses the nonzero
generator and exact rank one to place every compact-dual class on the H8 line.
The reverse direction uses the compact-dual/H8 equality, the span description
of H8, and the already-certified H8 rank-one lemma.

So exact rank one is a useful attack spelling, not a stronger hidden premise.
The live frontier remains the two genuine geometric targets: boundary data and
the compact-dual/H8 carrier theorem.  Neither target is proved here.
-/

import HodgeReduction.HCGapL4.FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC23_MatsushimaCompactDualRankOne
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC120_H8ResidualBoundaryDataCartanContract
open FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute
open FrontC183_H8ResidualLatestRouteRankOneGeneratorAttack

section RankOneGeneratorCompactDualH8Collapse

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

/-- **R749 substantive theorem (1/7)**: generator placement plus exact
rank one is enough to prove the compact-dual/H8 carrier equality.
-/
theorem compactDual_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
    (hh_compact :
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hrank :
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  haveI :
      FiniteDimensional Rat
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) :=
    Module.finite_of_finrank_eq_succ
      (R := Rat)
      (M := MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (n := 0)
      hrank
  have hle_rank :
      Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1 := by
    rw [hrank]
  have hcompact_le_H8 :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) <=
        CompactDualData.H8 (A := A) :=
    compactDual_le_H8_of_finite_rank_le_one_and_h_pow_four_mem
      (A := A) (B := B)
      hle_rank
      hh_compact
  exact
    (compactDual_eq_H8_iff_compactDual_le_H8_and_h_pow_four_mem
      (A := A) (B := B)).2
      (And.intro hcompact_le_H8 hh_compact)

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R749 substantive theorem (2/7)**: the compact-dual/H8 equality gives
the generator placement field.
-/
theorem h_pow_four_mem_compactDual_of_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) := by
  rw [hcompact]
  rw [CompactDualData.H8_eq_span_h_pow_4 (A := A)]
  exact Submodule.subset_span (by simp)

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R749 substantive theorem (3/7)**: the compact-dual/H8 equality gives
exact compact-dual rank one.
-/
theorem compactDual_finrank_eq_one_of_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    Module.finrank (R := Rat)
      (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1 := by
  rw [hcompact]
  exact compactDual_H8_finrank_eq_one (A := A)

/-- **R749 substantive theorem (4/7)**: exact rank-one generator data is
equivalent to the compact-dual/H8 carrier theorem.
-/
theorem compactDual_eq_H8_iff_h_pow_four_mem_and_finrank_eq_one :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      ((MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
          ((KaehlerClass.h : A) ^ 4) /\
        Module.finrank (R := Rat)
          (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1) := by
  constructor
  · intro hcompact
    exact And.intro
      (h_pow_four_mem_compactDual_of_compactDual_eq_H8
        (A := A) (B := B) hcompact)
      (compactDual_finrank_eq_one_of_compactDual_eq_H8
        (A := A) (B := B) hcompact)
  · intro h
    exact compactDual_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
      (A := A) (B := B) h.1 h.2

/-- **R749 substantive theorem (5/7)**: an R748 rank-one generator contract
feeds the old boundary-data/compact-dual-H8 contract directly.
-/
def boundaryDataCompactDualH8Contract_of_rankOneGeneratorContract
    (O : EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    compactDual_eq_H8_of_h_pow_four_mem_and_finrank_eq_one
      (A := A) (B := B)
      O.h_pow_four_mem_compactDual
      O.compactDual_finrank_eq_one

/-- **R749 substantive theorem (6/7)**: the old boundary-data/compact-dual-H8
contract recovers the R748 rank-one generator fields.
-/
def rankOneGeneratorContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B where
  boundary := O.boundary
  h_pow_four_mem_compactDual :=
    h_pow_four_mem_compactDual_of_compactDual_eq_H8
      (A := A) (B := B) O.compactDual_eq_H8
  compactDual_finrank_eq_one :=
    compactDual_finrank_eq_one_of_compactDual_eq_H8
      (A := A) (B := B) O.compactDual_eq_H8

/-- **R749 substantive theorem (7/7)**: the R748 rank-one generator route
and the old boundary-data/compact-dual-H8 route are the same inhabited
residual contract.
-/
theorem residual_rankOneGenerator_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualRankOneGeneratorContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_rankOneGeneratorContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (rankOneGeneratorContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))

end RankOneGeneratorCompactDualH8Collapse

/-- R749 target names for route summaries. -/
def currentR749CompactDualH8CollapseTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = H8 (equivalently compactDual = CartanH8)"
]

/-- Machine-readable status for the R749 collapse of the R748 exact rank-one
generator surface.
-/
structure R749CompactDualH8CollapseSnapshot where
  proofWorkObligationCount : Nat
  rankOneGeneratorEquivalentToCompactDualH8 : Bool
  exactRankOneGeneratorSuppliesCompactDualH8 : Bool
  compactDualH8SuppliesGeneratorMembership : Bool
  compactDualH8SuppliesExactRankOne : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualH8 : Bool
  provesGeneratorMembership : Bool
  provesCompactDualRankOne : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R749 status: the two non-boundary fields in R748 collapse exactly
to the old compact-dual/H8 theorem.  The file proves equivalence only.
-/
def currentR749CompactDualH8CollapseSnapshot :
    R749CompactDualH8CollapseSnapshot where
  proofWorkObligationCount := currentR749CompactDualH8CollapseTargetNames.length
  rankOneGeneratorEquivalentToCompactDualH8 := true
  exactRankOneGeneratorSuppliesCompactDualH8 := true
  compactDualH8SuppliesGeneratorMembership := true
  compactDualH8SuppliesExactRankOne := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualH8 := false
  provesGeneratorMembership := false
  provesCompactDualRankOne := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R749 route collapse. -/
theorem currentR749CompactDualH8CollapseSnapshot_eq_texStatus :
    currentR749CompactDualH8CollapseSnapshot =
      ({ proofWorkObligationCount := 2
         rankOneGeneratorEquivalentToCompactDualH8 := true
         exactRankOneGeneratorSuppliesCompactDualH8 := true
         compactDualH8SuppliesGeneratorMembership := true
         compactDualH8SuppliesExactRankOne := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualH8 := false
         provesGeneratorMembership := false
         provesCompactDualRankOne := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R749CompactDualH8CollapseSnapshot) := by
  decide

/-- Kernel-checked target names for the R749 route collapse. -/
theorem currentR749CompactDualH8CollapseTargetNames_eq_texStatus :
    currentR749CompactDualH8CollapseTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = H8 (equivalently compactDual = CartanH8)"
    ] := by
  rfl

def R749_substantiveTheoremCount : Nat := 7

end FrontC184_H8ResidualRankOneGeneratorCompactDualH8Collapse
end HCGapL4
end HodgeReduction
