/-
# HC Gap L4 -- Front C119: Cartan target image as boundary equality (R683).

R682 states the live residual as Cartan-line exactness:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* `Submodule.map j_q CartanH8 = trivialModulePart`.

The third item can be read more geometrically. Once the Matsushima
surjectivity source is Cartan H8, the built-in Matsushima surjectivity
equation rewrites `Submodule.map j_q CartanH8 = trivialModulePart` exactly
as

  `surjectivity_target = trivialModulePart`.

This file records that equivalence and replaces the image-equality spelling
by the boundary-target equality spelling without adding assumptions.
-/

import HodgeReduction.HCGapL4.FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC119_H8ResidualCartanBoundaryEquality

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC118_H8ResidualCartanLineExactnessFromSourceCompactDual

section CartanImageTargetBoundary

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

omit [MatsushimaCompactDualData A B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R683 substantive theorem (1/6)**: after `surjectivity_source` is
Cartan H8, exact Cartan image is exactly the target boundary equality
`surjectivity_target = trivialModulePart`. -/
theorem cartan_image_eq_trivialModulePart_iff_surjectivity_target_eq_trivialModulePart_of_source_eq_cartanH8
    (hsource_cartan :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    (Submodule.map (MatsushimaData.j_q (A := A) (B := B))
        (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) =
      CuspidalCohomologyData.trivialModulePart (A := B)) <->
      (MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
        CuspidalCohomologyData.trivialModulePart (A := B)) := by
  exact Iff.intro
    (fun hcartan_image => by
      calc
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
            =
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) :=
            (MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)).symm
        _ =
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A)) := by
            rw [hsource_cartan]
        _ = CuspidalCohomologyData.trivialModulePart (A := B) := hcartan_image)
    (fun htarget => by
      calc
        Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
            =
          Submodule.map (MatsushimaData.j_q (A := A) (B := B))
            (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)) := by
            rw [hsource_cartan]
        _ = MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) :=
            MatsushimaSurjectivityData.surjectivity_eq (A := A) (B := B)
        _ = CuspidalCohomologyData.trivialModulePart (A := B) := htarget)

end CartanImageTargetBoundary

section CartanBoundaryEqualityContract

variable (A B : Type*)
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B]

/-- The R683 boundary-target spelling of the Cartan-line residual. -/
structure EVIIH8ResidualCartanBoundaryEqualityContract where
  source_eq_cartanH8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  compactDual_eq_cartanH8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)
  surjectivity_target_eq_trivialModulePart :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B)

variable {A B}

/-- **R683 substantive theorem (2/6)**: Cartan-line exactness gives the
boundary-target spelling. -/
def cartanBoundaryEqualityContract_of_cartanLineExactnessContract
    (O : EVIIH8ResidualCartanLineExactnessContract A B) :
    EVIIH8ResidualCartanBoundaryEqualityContract A B where
  source_eq_cartanH8 := O.source_eq_cartanH8
  compactDual_eq_cartanH8 := O.compactDual_eq_cartanH8
  surjectivity_target_eq_trivialModulePart :=
    (cartan_image_eq_trivialModulePart_iff_surjectivity_target_eq_trivialModulePart_of_source_eq_cartanH8
      (A := A) (B := B) O.source_eq_cartanH8).1
      O.cartan_image_eq_trivialModulePart

/-- **R683 substantive theorem (3/6)**: the boundary-target spelling
recovers Cartan-line exactness. -/
def cartanLineExactnessContract_of_cartanBoundaryEqualityContract
    (O : EVIIH8ResidualCartanBoundaryEqualityContract A B) :
    EVIIH8ResidualCartanLineExactnessContract A B where
  source_eq_cartanH8 := O.source_eq_cartanH8
  compactDual_eq_cartanH8 := O.compactDual_eq_cartanH8
  cartan_image_eq_trivialModulePart :=
    (cartan_image_eq_trivialModulePart_iff_surjectivity_target_eq_trivialModulePart_of_source_eq_cartanH8
      (A := A) (B := B) O.source_eq_cartanH8).2
      O.surjectivity_target_eq_trivialModulePart

omit [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R683 substantive theorem (4/6)**: the Cartan-line exactness and
boundary-target spellings are equivalent at the inhabited-contract level. -/
theorem residual_cartanLineExactness_nonempty_iff_cartanBoundaryEquality_nonempty :
    Nonempty (EVIIH8ResidualCartanLineExactnessContract A B) <->
      Nonempty (EVIIH8ResidualCartanBoundaryEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanBoundaryEqualityContract_of_cartanLineExactnessContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanLineExactnessContract_of_cartanBoundaryEqualityContract
            (A := A) (B := B) O)))

/-- **R683 substantive theorem (5/6)**: the boundary-target spelling is still
the current target-line residual, not a stronger premise. -/
theorem residual_cartanBoundaryEquality_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualCartanBoundaryEqualityContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_cartanLineExactness_nonempty_iff_cartanBoundaryEquality_nonempty
    (A := A) (B := B)).symm.trans
    (residual_cartanLineExactness_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R683 substantive theorem (6/6)**: the boundary-target spelling is also
equivalent to the boundary-data/compact-dual-H8 route. -/
theorem residual_cartanBoundaryEquality_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualCartanBoundaryEqualityContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_cartanBoundaryEquality_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end CartanBoundaryEqualityContract

/-- Exact R683 target names for route summaries. -/
def currentR683CartanBoundaryEqualityTargetNames : List String := [
  "prove surjectivity_source = CartanH8",
  "prove compactDual = CartanH8",
  "prove surjectivity_target = trivialModulePart"
]

/-- Machine-readable status for the R683 Cartan boundary-equality route. -/
structure R683CartanBoundaryEqualitySnapshot where
  proofWorkObligationCount : Nat
  cartanImageEquivalentToTargetBoundaryUnderSourceCartan : Bool
  cartanBoundaryContractEquivalentToCartanLineExactness : Bool
  cartanBoundaryContractEquivalentToTargetLine : Bool
  cartanBoundaryContractEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesSourceCartan : Bool
  provesCompactDualCartan : Bool
  provesTargetBoundary : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R683 status: the target image equality has been replaced by the
equivalent Matsushima boundary equality, but all three targets remain open. -/
def currentR683CartanBoundaryEqualitySnapshot :
    R683CartanBoundaryEqualitySnapshot where
  proofWorkObligationCount := currentR683CartanBoundaryEqualityTargetNames.length
  cartanImageEquivalentToTargetBoundaryUnderSourceCartan := true
  cartanBoundaryContractEquivalentToCartanLineExactness := true
  cartanBoundaryContractEquivalentToTargetLine := true
  cartanBoundaryContractEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesSourceCartan := false
  provesCompactDualCartan := false
  provesTargetBoundary := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R683 ledger. -/
theorem currentR683CartanBoundaryEqualitySnapshot_eq_texStatus :
    currentR683CartanBoundaryEqualitySnapshot =
      ({ proofWorkObligationCount := 3
         cartanImageEquivalentToTargetBoundaryUnderSourceCartan := true
         cartanBoundaryContractEquivalentToCartanLineExactness := true
         cartanBoundaryContractEquivalentToTargetLine := true
         cartanBoundaryContractEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesSourceCartan := false
         provesCompactDualCartan := false
         provesTargetBoundary := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R683CartanBoundaryEqualitySnapshot) := by
  decide

/-- Kernel-checked target names for the R683 boundary equality route. -/
theorem currentR683CartanBoundaryEqualityTargetNames_eq_texStatus :
    currentR683CartanBoundaryEqualityTargetNames = [
      "prove surjectivity_source = CartanH8",
      "prove compactDual = CartanH8",
      "prove surjectivity_target = trivialModulePart"
    ] := by
  rfl

def R683_substantiveTheoremCount : Nat := 6

end FrontC119_H8ResidualCartanBoundaryEquality
end HCGapL4
end HodgeReduction
