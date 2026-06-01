/-
# HC Gap L4 -- Front C144: source-invariant finite-rank carrier route (R709).

R708 made the compact-dual finite-rank route sharp: with
`h^4 in compactDual` and finite-dimensionality fixed, the remaining
no-extra/equality target is exactly `finrank compactDual <= 1`.

The actual Matsushima interface already identifies

  `compactDual = source_invariants`.

This file moves the finite-rank carrier route across that equality.  The
next source-side geometry target can be attacked as:

* prove `h^4 in source_invariants`;
* prove `source_invariants` is finite-dimensional;
* prove `finrank source_invariants <= 1`;
* prove the same honest `MatsushimaV56BoundaryData`.

The resulting source-invariant contract is proved equivalent to the R707
compact-dual finite-rank contract, so it is not a stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC143_H8ResidualCompactDualRankBoundSharpness

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC142_H8ResidualCompactDualFiniteRankCarrierRoute

section SourceInvariantFiniteRankCarrier

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

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R709 substantive theorem (1/7)**: finite-dimensionality of the
Matsushima compact-dual carrier is exactly finite-dimensionality of the
source-invariant carrier, because the interface identifies the two submodules. -/
theorem compactDual_finiteDimensional_iff_source_invariants_finiteDimensional :
    (FiniteDimensional Rat
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))) <->
      (FiniteDimensional Rat
        (MatsushimaData.source_invariants (A := A) (B := B))) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R709 substantive theorem (2/7)**: the compact-dual and source-invariant
carriers have the same finrank. -/
theorem compactDual_finrank_eq_source_invariants_finrank :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R709 substantive theorem (3/7)**: the compact-dual rank-one upper
bound is exactly the source-invariant rank-one upper bound. -/
theorem compactDual_finrank_le_one_iff_source_invariants_finrank_le_one :
    (Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) <= 1) <->
      (Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) <= 1) := by
  rw [compactDual_finrank_eq_source_invariants_finrank (A := A) (B := B)]

omit [CompactDualData A] [CartanCompactDualIso A]
  [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R709 substantive theorem (4/7)**: generator membership in compactDual
is exactly generator membership in source invariants. -/
theorem h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants :
    ((MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)) <->
      ((MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

/-- Boundary data plus the source-invariant finite-rank form of the compact
dual carrier route. -/
structure EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract
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
  source_invariants_finite :
    FiniteDimensional Rat
      (MatsushimaData.source_invariants (A := A) (B := B))
  source_invariants_finrank_le_one :
    Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) <= 1
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)

/-- **R709 substantive theorem (5/7)**: the source-invariant finite-rank
contract feeds the R707 compact-dual finite-rank contract. -/
def finiteRankCarrierContract_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B where
  boundary := O.boundary
  compactDual_finite := by
    exact
      (compactDual_finiteDimensional_iff_source_invariants_finiteDimensional
        (A := A) (B := B)).2 O.source_invariants_finite
  compactDual_finrank_le_one := by
    exact
      (compactDual_finrank_le_one_iff_source_invariants_finrank_le_one
        (A := A) (B := B)).2 O.source_invariants_finrank_le_one
  h_pow_four_mem_compactDual := by
    exact
      (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
        (A := A) (B := B)).2 O.h_pow_four_mem_source_invariants

/-- **R709 substantive theorem (6/7)**: the R707 compact-dual finite-rank
contract recovers the source-invariant finite-rank contract. -/
def sourceInvariantFiniteRankCarrierContract_of_finiteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B where
  boundary := O.boundary
  source_invariants_finite := by
    exact
      (compactDual_finiteDimensional_iff_source_invariants_finiteDimensional
        (A := A) (B := B)).1 O.compactDual_finite
  source_invariants_finrank_le_one := by
    exact
      (compactDual_finrank_le_one_iff_source_invariants_finrank_le_one
        (A := A) (B := B)).1 O.compactDual_finrank_le_one
  h_pow_four_mem_source_invariants := by
    exact
      (h_pow_four_mem_compactDual_iff_h_pow_four_mem_source_invariants
        (A := A) (B := B)).1 O.h_pow_four_mem_compactDual

/-- **R709 substantive theorem (7/7)**: the R707 compact-dual finite-rank
route and the source-invariant finite-rank route are the same inhabited
residual contract. -/
theorem residual_finiteRankCarrier_nonempty_iff_sourceInvariantFiniteRankCarrier_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualFiniteRankCarrierContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantFiniteRankCarrierContract_of_finiteRankCarrierContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (finiteRankCarrierContract_of_sourceInvariantFiniteRankCarrierContract
            (A := A) (B := B) O)))

end SourceInvariantFiniteRankCarrier

/-- R709 target names for route summaries. -/
def currentR709SourceInvariantFiniteRankCarrierTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove h^4 in source_invariants",
  "prove finite-dimensional source_invariants",
  "prove finrank source_invariants <= 1"
]

/-- Machine-readable status for the R709 source-invariant finite-rank route. -/
structure R709SourceInvariantFiniteRankCarrierSnapshot where
  proofWorkObligationCount : Nat
  finiteDimensionalTransfersBetweenCompactDualAndSourceInvariants : Bool
  finrankTransfersBetweenCompactDualAndSourceInvariants : Bool
  generatorMembershipTransfersBetweenCompactDualAndSourceInvariants : Bool
  sourceInvariantRouteEquivalentToCompactDualFiniteRankRoute : Bool
  provesBoundaryData : Bool
  provesSourceGeneratorMembership : Bool
  provesSourceInvariantFiniteDimensionality : Bool
  provesSourceInvariantRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R709 status: the finite-rank compact-dual carrier target has been
transferred to the primitive Matsushima source-invariant carrier. -/
def currentR709SourceInvariantFiniteRankCarrierSnapshot :
    R709SourceInvariantFiniteRankCarrierSnapshot where
  proofWorkObligationCount :=
    currentR709SourceInvariantFiniteRankCarrierTargetNames.length
  finiteDimensionalTransfersBetweenCompactDualAndSourceInvariants := true
  finrankTransfersBetweenCompactDualAndSourceInvariants := true
  generatorMembershipTransfersBetweenCompactDualAndSourceInvariants := true
  sourceInvariantRouteEquivalentToCompactDualFiniteRankRoute := true
  provesBoundaryData := false
  provesSourceGeneratorMembership := false
  provesSourceInvariantFiniteDimensionality := false
  provesSourceInvariantRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R709 source-invariant route. -/
theorem currentR709SourceInvariantFiniteRankCarrierSnapshot_eq_texStatus :
    currentR709SourceInvariantFiniteRankCarrierSnapshot =
      ({ proofWorkObligationCount := 4
         finiteDimensionalTransfersBetweenCompactDualAndSourceInvariants := true
         finrankTransfersBetweenCompactDualAndSourceInvariants := true
         generatorMembershipTransfersBetweenCompactDualAndSourceInvariants := true
         sourceInvariantRouteEquivalentToCompactDualFiniteRankRoute := true
         provesBoundaryData := false
         provesSourceGeneratorMembership := false
         provesSourceInvariantFiniteDimensionality := false
         provesSourceInvariantRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R709SourceInvariantFiniteRankCarrierSnapshot) := by
  decide

/-- Kernel-checked target names for the R709 route. -/
theorem currentR709SourceInvariantFiniteRankCarrierTargetNames_eq_texStatus :
    currentR709SourceInvariantFiniteRankCarrierTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove h^4 in source_invariants",
      "prove finite-dimensional source_invariants",
      "prove finrank source_invariants <= 1"
    ] := by
  rfl

def R709_substantiveTheoremCount : Nat := 7

end FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute
end HCGapL4
end HodgeReduction
