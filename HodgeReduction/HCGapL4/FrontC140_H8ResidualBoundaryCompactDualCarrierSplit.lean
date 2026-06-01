/-
# HC Gap L4 -- Front C140: boundary route with compact-dual carrier split (R705).

R704 rewrote the preferred live route as:

* prove honest `MatsushimaV56BoundaryData`;
* prove `compactDual = H8`.

R583 already proved that a carrier equality with `H8` is equivalent to the
two concrete carrier facts:

* no extra compact-dual classes beyond `H8`;
* the generator `h^4` lies in `compactDual`.

This file connects that older carrier criterion to the current R704 route.
It does not prove either carrier fact; it makes the next source-side attack
surface explicit and machine-checks that the split is not a stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC139_H8ResidualBoundarySourceCompactDualEquivalence
import HodgeReduction.HCGapL4.FrontC42_H8CarrierEqualityRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC140_H8ResidualBoundaryCompactDualCarrierSplit

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC42_H8CarrierEqualityRoute
open FrontC82_H8ResidualAtlasMultiplicityCriterion
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC130_H8ResidualBoundaryDataSourceSurjectivityRoute
open FrontC138_H8ResidualCartanImageBoundarySourceH8Equivalence
open FrontC139_H8ResidualBoundarySourceCompactDualEquivalence

section BoundaryCompactDualCarrierSplit

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

/-- **R705 substantive theorem (1/6)**: the compact-dual-H8 target is
exactly the compact-dual carrier split: no extra compact-dual classes beyond
`H8`, plus membership of the generator `h^4`. -/
theorem compactDual_eq_H8_iff_compactDual_le_H8_and_h_pow_four_mem :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      (LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
          (CompactDualData.H8 (A := A)) /\
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
          ((KaehlerClass.h : A) ^ 4)) :=
  (compactDual_H8_split_iff_compactDual_eq_H8 (A := A) (B := B)).symm

/-- Boundary data plus the split carrier form of the compact-dual-H8 target. -/
structure EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract
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
  compactDual_le_H8 :
    LE.le (MatsushimaCompactDualData.compactDual (A := A) (B := B))
      (CompactDualData.H8 (A := A))
  h_pow_four_mem_compactDual :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)

/-- **R705 substantive theorem (2/6)**: boundary/compact-dual-H8 contracts
feed the carrier-split contract. -/
def boundaryDataCompactDualCarrierSplitContract_of_boundaryDataCompactDualH8Contract
    (O : EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :
    EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B where
  boundary := O.boundary
  compactDual_le_H8 :=
    ((compactDual_eq_H8_iff_compactDual_le_H8_and_h_pow_four_mem
      (A := A) (B := B)).1 O.compactDual_eq_H8).1
  h_pow_four_mem_compactDual :=
    ((compactDual_eq_H8_iff_compactDual_le_H8_and_h_pow_four_mem
      (A := A) (B := B)).1 O.compactDual_eq_H8).2

/-- **R705 substantive theorem (3/6)**: the carrier-split contract recovers
the boundary/compact-dual-H8 contract. -/
def boundaryDataCompactDualH8Contract_of_boundaryDataCompactDualCarrierSplitContract
    (O : EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) :
    EVIIH8ResidualBoundaryDataCompactDualH8Contract A B where
  boundary := O.boundary
  compactDual_eq_H8 :=
    (compactDual_eq_H8_iff_compactDual_le_H8_and_h_pow_four_mem
      (A := A) (B := B)).2
      ⟨O.compactDual_le_H8, O.h_pow_four_mem_compactDual⟩

/-- **R705 substantive theorem (4/6)**: the R704 boundary/compact-dual-H8
contract and the carrier-split contract are equivalent. -/
theorem residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualCarrierSplitContract_of_boundaryDataCompactDualH8Contract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCompactDualH8Contract_of_boundaryDataCompactDualCarrierSplitContract
            (A := A) (B := B) O)))

/-- **R705 substantive theorem (5/6)**: the R704 boundary/source-H8 route is
equivalent to the boundary/compact-dual carrier split. -/
theorem residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataSourceSurjectivityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) :=
  residual_boundaryDataSourceSurjectivity_nonempty_iff_boundaryDataCompactDualH8_nonempty
    (A := A) (B := B) |>.trans
    residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty

/-- **R705 substantive theorem (6/6)**: the Cartan-image route is also
equivalent to the boundary/compact-dual carrier split. -/
theorem residual_cartanImageUpperBound_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty :
    Nonempty (EVIIH8ResidualCartanImageUpperBoundContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualCarrierSplitContract A B) :=
  residual_cartanImageUpperBound_nonempty_iff_boundaryDataCompactDualH8_nonempty
    (A := A) (B := B) |>.trans
    residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataCompactDualCarrierSplit_nonempty

end BoundaryCompactDualCarrierSplit

/-- R705 target names for route summaries. -/
def currentR705BoundaryCompactDualCarrierSplitTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual <= H8",
  "prove h^4 in compactDual"
]

/-- Machine-readable status for the R705 split of the compact-dual-H8 target. -/
structure R705BoundaryCompactDualCarrierSplitSnapshot where
  proofWorkObligationCount : Nat
  compactDualH8EquivalentToCarrierSplit : Bool
  boundaryCompactDualH8RouteEquivalentToCarrierSplit : Bool
  boundarySourceH8RouteEquivalentToCarrierSplit : Bool
  cartanImageRouteEquivalentToCarrierSplit : Bool
  provesBoundaryData : Bool
  provesCompactDualNoExtra : Bool
  provesCompactDualGeneratorMembership : Bool
  introducesStrongerPremise : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R705 status: the compact-dual-H8 target is now exposed as two
carrier facts.  Neither fact is proved here. -/
def currentR705BoundaryCompactDualCarrierSplitSnapshot :
    R705BoundaryCompactDualCarrierSplitSnapshot where
  proofWorkObligationCount :=
    currentR705BoundaryCompactDualCarrierSplitTargetNames.length
  compactDualH8EquivalentToCarrierSplit := true
  boundaryCompactDualH8RouteEquivalentToCarrierSplit := true
  boundarySourceH8RouteEquivalentToCarrierSplit := true
  cartanImageRouteEquivalentToCarrierSplit := true
  provesBoundaryData := false
  provesCompactDualNoExtra := false
  provesCompactDualGeneratorMembership := false
  introducesStrongerPremise := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R705 carrier-split ledger. -/
theorem currentR705BoundaryCompactDualCarrierSplitSnapshot_eq_texStatus :
    currentR705BoundaryCompactDualCarrierSplitSnapshot =
      ({ proofWorkObligationCount := 3
         compactDualH8EquivalentToCarrierSplit := true
         boundaryCompactDualH8RouteEquivalentToCarrierSplit := true
         boundarySourceH8RouteEquivalentToCarrierSplit := true
         cartanImageRouteEquivalentToCarrierSplit := true
         provesBoundaryData := false
         provesCompactDualNoExtra := false
         provesCompactDualGeneratorMembership := false
         introducesStrongerPremise := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R705BoundaryCompactDualCarrierSplitSnapshot) := by
  decide

/-- Kernel-checked target names for the R705 route. -/
theorem currentR705BoundaryCompactDualCarrierSplitTargetNames_eq_texStatus :
    currentR705BoundaryCompactDualCarrierSplitTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual <= H8",
      "prove h^4 in compactDual"
    ] := by
  rfl

def R705_substantiveTheoremCount : Nat := 6

end FrontC140_H8ResidualBoundaryCompactDualCarrierSplit
end HCGapL4
end HodgeReduction
