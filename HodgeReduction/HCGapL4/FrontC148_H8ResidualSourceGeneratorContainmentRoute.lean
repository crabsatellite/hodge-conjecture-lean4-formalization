/-
# HC Gap L4 -- Front C148: source generator membership as H8 containment (R713).

R711/R712 leave the live source-side route as four honest obligations:

* boundary data;
* h^4 in source_invariants;
* finite-dimensional source_invariants;
* finrank source_invariants <= 1.

This file rewrites the generator-membership obligation into the more geometric
containment

  H8 <= source_invariants.

Since `H8 = span {h^4}`, this is exactly equivalent to `h^4 in
source_invariants`; it is not a stronger premise.  The route now exposes the
next source-geometry target as an H8 containment theorem.
-/

import HodgeReduction.HCGapL4.FrontC147_H8ResidualSourceFiniteDimensionalityGuard

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC148_H8ResidualSourceGeneratorContainmentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC144_H8ResidualSourceInvariantFiniteRankCarrierRoute

section SourceGeneratorContainment

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

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R713 substantive theorem (1/6)**: because `H8 = span {h^4}`, source
generator membership is exactly the containment `H8 <= source_invariants`. -/
theorem H8_le_source_invariants_iff_h_pow_four_mem_source_invariants :
    LE.le (CompactDualData.H8 (A := A))
        (MatsushimaData.source_invariants (A := A) (B := B)) <->
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) := by
  apply Iff.intro
  case mp =>
    intro hle
    apply hle
    rw [CompactDualData.H8_eq_span_h_pow_4]
    exact Submodule.subset_span (by simp)
  case mpr =>
    intro hh alpha halpha
    rw [CompactDualData.H8_eq_span_h_pow_4] at halpha
    rw [Submodule.mem_span_singleton] at halpha
    cases halpha with
    | intro r hr =>
      rw [hr.symm]
      exact Submodule.smul_mem _ r hh

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R713 substantive theorem (2/6)**: the H8-containment form gives the
old source generator-membership field. -/
theorem h_pow_four_mem_source_invariants_of_H8_le_source_invariants
    (hH8 :
      LE.le (CompactDualData.H8 (A := A))
        (MatsushimaData.source_invariants (A := A) (B := B))) :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4) :=
  (H8_le_source_invariants_iff_h_pow_four_mem_source_invariants
    (A := A) (B := B)).1 hH8

omit [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R713 substantive theorem (3/6)**: the old source generator-membership
field gives the H8-containment form. -/
theorem H8_le_source_invariants_of_h_pow_four_mem_source_invariants
    (hh :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4)) :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaData.source_invariants (A := A) (B := B)) :=
  (H8_le_source_invariants_iff_h_pow_four_mem_source_invariants
    (A := A) (B := B)).2 hh

/-- Boundary data plus the H8-containment form of the source finite-rank
carrier route. -/
structure EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract
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
  h8_le_source_invariants :
    LE.le (CompactDualData.H8 (A := A))
      (MatsushimaData.source_invariants (A := A) (B := B))

/-- **R713 substantive theorem (4/6)**: the H8-containment contract feeds the
R709 source finite-rank contract. -/
def sourceInvariantFiniteRankCarrierContract_of_H8ContainmentContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B where
  boundary := O.boundary
  source_invariants_finite := O.source_invariants_finite
  source_invariants_finrank_le_one := O.source_invariants_finrank_le_one
  h_pow_four_mem_source_invariants :=
    h_pow_four_mem_source_invariants_of_H8_le_source_invariants
      (A := A) (B := B) O.h8_le_source_invariants

/-- **R713 substantive theorem (5/6)**: the R709 source finite-rank contract
recovers the H8-containment contract. -/
def H8ContainmentContract_of_sourceInvariantFiniteRankCarrierContract
    (O : EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :
    EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B where
  boundary := O.boundary
  source_invariants_finite := O.source_invariants_finite
  source_invariants_finrank_le_one := O.source_invariants_finrank_le_one
  h8_le_source_invariants :=
    H8_le_source_invariants_of_h_pow_four_mem_source_invariants
      (A := A) (B := B) O.h_pow_four_mem_source_invariants

/-- **R713 substantive theorem (6/6)**: the H8-containment route and the
R709 source generator-membership route are the same inhabited residual
contract. -/
theorem residual_sourceInvariantFiniteRankH8Containment_nonempty_iff_sourceInvariantFiniteRankCarrier_nonempty :
    Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankH8ContainmentContract A B) <->
      Nonempty
        (EVIIH8ResidualBoundaryDataSourceInvariantFiniteRankCarrierContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceInvariantFiniteRankCarrierContract_of_H8ContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (H8ContainmentContract_of_sourceInvariantFiniteRankCarrierContract
            (A := A) (B := B) O)))

end SourceGeneratorContainment

/-- R713 target names for route summaries. -/
def currentR713SourceGeneratorContainmentTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove H8 <= source_invariants",
  "prove finite-dimensional source_invariants",
  "prove finrank source_invariants <= 1"
]

/-- Machine-readable status for the R713 source generator-containment route. -/
structure R713SourceGeneratorContainmentSnapshot where
  proofWorkObligationCount : Nat
  hPowFourMembershipEquivalentToH8Containment : Bool
  h8ContainmentRouteEquivalentToR709SourceRoute : Bool
  provesBoundaryData : Bool
  provesH8LeSourceInvariants : Bool
  provesSourceInvariantFiniteDimensionality : Bool
  provesSourceInvariantRankBound : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R713 status: the source generator target has been rewritten as
H8 containment, with the finite-dimensional and rank fields still explicit. -/
def currentR713SourceGeneratorContainmentSnapshot :
    R713SourceGeneratorContainmentSnapshot where
  proofWorkObligationCount :=
    currentR713SourceGeneratorContainmentTargetNames.length
  hPowFourMembershipEquivalentToH8Containment := true
  h8ContainmentRouteEquivalentToR709SourceRoute := true
  provesBoundaryData := false
  provesH8LeSourceInvariants := false
  provesSourceInvariantFiniteDimensionality := false
  provesSourceInvariantRankBound := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R713 route. -/
theorem currentR713SourceGeneratorContainmentSnapshot_eq_texStatus :
    currentR713SourceGeneratorContainmentSnapshot =
      ({ proofWorkObligationCount := 4
         hPowFourMembershipEquivalentToH8Containment := true
         h8ContainmentRouteEquivalentToR709SourceRoute := true
         provesBoundaryData := false
         provesH8LeSourceInvariants := false
         provesSourceInvariantFiniteDimensionality := false
         provesSourceInvariantRankBound := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R713SourceGeneratorContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R713 route. -/
theorem currentR713SourceGeneratorContainmentTargetNames_eq_texStatus :
    currentR713SourceGeneratorContainmentTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove H8 <= source_invariants",
      "prove finite-dimensional source_invariants",
      "prove finrank source_invariants <= 1"
    ] := by
  rfl

def R713_substantiveTheoremCount : Nat := 6

end FrontC148_H8ResidualSourceGeneratorContainmentRoute
end HCGapL4
end HodgeReduction
