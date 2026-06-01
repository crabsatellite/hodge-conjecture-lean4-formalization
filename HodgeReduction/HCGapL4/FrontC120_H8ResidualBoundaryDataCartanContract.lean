/-
# HC Gap L4 -- Front C120: boundary data plus Cartan carrier (R684).

R683 made the live Cartan residual explicit as three equalities:

* `surjectivity_source = CartanH8`;
* `compactDual = CartanH8`;
* `surjectivity_target = trivialModulePart`.

This file proves the direct, kernel-checked compression of those three
equalities to the honest Matsushima boundary package plus one carrier
equality:

* prove `MatsushimaV56BoundaryData`;
* prove `compactDual = CartanH8`.

The target equality is not assumed away.  It is recovered from the
`target_eq_invariants` field of `MatsushimaV56BoundaryData` together with
the already proved `target_invariants = trivialModulePart` theorem.
-/

import HodgeReduction.HCGapL4.FrontC119_H8ResidualCartanBoundaryEquality

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC120_H8ResidualBoundaryDataCartanContract

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC13_MatsushimaV56BoundaryBridge
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC119_H8ResidualCartanBoundaryEquality

section BoundaryDataCartan

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
  [CartanCompactDualIso A] in
/-- **R684 substantive theorem (1/7)**: honest Matsushima boundary data
directly proves the R683 target boundary equality. -/
theorem surjectivity_target_eq_trivialModulePart_of_matsushimaV56BoundaryData
    (D : MatsushimaV56BoundaryData A B) :
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B) =
      CuspidalCohomologyData.trivialModulePart (A := B) := by
  calc
    MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
        = MatsushimaData.target_invariants (A := A) (B := B) :=
        D.target_eq_invariants
    _ = CuspidalCohomologyData.trivialModulePart (A := B) :=
        target_invariants_eq_trivialModulePart (A := A) (B := B)

omit [CuspidalCohomologyData B] [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R684 substantive theorem (2/7)**: boundary data plus the Cartan
carrier equality proves the R683 source Cartan equality. -/
theorem surjectivity_source_eq_cartanH8_of_matsushimaV56BoundaryData_compactDual_cartanH8
    (D : MatsushimaV56BoundaryData A B)
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CartanCompactDualIso.trivialModuleGK_H8 (A := A)) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A) := by
  calc
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
        = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
        D.source_eq_compactDual
    _ = CartanCompactDualIso.trivialModuleGK_H8 (A := A) := hcompact

omit [MatsushimaSurjectivityData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R684 substantive theorem (3/7)**: the Cartan and compact-dual-H8
carrier spellings are exactly the same equality. -/
theorem compactDual_eq_cartanH8_iff_compactDual_eq_H8 :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)) <->
      (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) := by
  constructor
  · intro hcartan
    exact hcartan.trans
      (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
        (A := A))
  · intro hH8
    exact hH8.trans
      (CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8
        (A := A)).symm

/-- Boundary data plus the Cartan carrier equality.  This is the direct
R684 two-target spelling of the R683 Cartan boundary-equality contract. -/
structure EVIIH8ResidualBoundaryDataCartanContract
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
  compactDual_eq_cartanH8 :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CartanCompactDualIso.trivialModuleGK_H8 (A := A)

/-- **R684 substantive theorem (4/7)**: boundary data plus the Cartan
carrier equality gives the full R683 Cartan boundary-equality contract. -/
def cartanBoundaryEqualityContract_of_boundaryDataCartanContract
    (O : EVIIH8ResidualBoundaryDataCartanContract A B) :
    EVIIH8ResidualCartanBoundaryEqualityContract A B where
  source_eq_cartanH8 :=
    surjectivity_source_eq_cartanH8_of_matsushimaV56BoundaryData_compactDual_cartanH8
      (A := A) (B := B) O.boundary O.compactDual_eq_cartanH8
  compactDual_eq_cartanH8 := O.compactDual_eq_cartanH8
  surjectivity_target_eq_trivialModulePart :=
    surjectivity_target_eq_trivialModulePart_of_matsushimaV56BoundaryData
      (A := A) (B := B) O.boundary

/-- **R684 substantive theorem (5/7)**: the R683 three-equality contract
reconstructs the boundary-data-plus-Cartan-carrier contract, so R684 adds
no stronger hidden premise. -/
def boundaryDataCartanContract_of_cartanBoundaryEqualityContract
    (O : EVIIH8ResidualCartanBoundaryEqualityContract A B) :
    EVIIH8ResidualBoundaryDataCartanContract A B where
  boundary := {
    source_eq_compactDual := by
      calc
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
            = CartanCompactDualIso.trivialModuleGK_H8 (A := A) :=
            O.source_eq_cartanH8
        _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
            O.compactDual_eq_cartanH8.symm
    target_eq_invariants := by
      calc
        MatsushimaSurjectivityData.surjectivity_target (A := A) (B := B)
            = CuspidalCohomologyData.trivialModulePart (A := B) :=
            O.surjectivity_target_eq_trivialModulePart
        _ = MatsushimaData.target_invariants (A := A) (B := B) :=
            (target_invariants_eq_trivialModulePart (A := A) (B := B)).symm }
  compactDual_eq_cartanH8 := O.compactDual_eq_cartanH8

/-- **R684 substantive theorem (6/7)**: the R684 two-target spelling is
equivalent to the R683 Cartan boundary-equality spelling. -/
theorem residual_boundaryDataCartan_nonempty_iff_cartanBoundaryEquality_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualCartanBoundaryEqualityContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (cartanBoundaryEqualityContract_of_boundaryDataCartanContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (boundaryDataCartanContract_of_cartanBoundaryEqualityContract
            (A := A) (B := B) O)))

/-- **R684 substantive theorem (7/7)**: the R684 Cartan carrier spelling
is equivalent to the existing R675 boundary-data/compact-dual-H8 route. -/
theorem residual_boundaryDataCartan_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualBoundaryDataCartanContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) := by
  constructor
  · intro h
    refine h.elim ?_
    intro O
    exact Nonempty.intro
      ({ boundary := O.boundary
         compactDual_eq_H8 :=
          (compactDual_eq_cartanH8_iff_compactDual_eq_H8
            (A := A) (B := B)).1 O.compactDual_eq_cartanH8 } :
        EVIIH8ResidualBoundaryDataCompactDualH8Contract A B)
  · intro h
    refine h.elim ?_
    intro O
    exact Nonempty.intro
      ({ boundary := O.boundary
         compactDual_eq_cartanH8 :=
          (compactDual_eq_cartanH8_iff_compactDual_eq_H8
            (A := A) (B := B)).2 O.compactDual_eq_H8 } :
        EVIIH8ResidualBoundaryDataCartanContract A B)

end BoundaryDataCartan

/-- Exact R684 target names for route summaries. -/
def currentR684BoundaryDataCartanTargetNames : List String := [
  "prove MatsushimaV56BoundaryData",
  "prove compactDual = CartanH8"
]

/-- Machine-readable status for the R684 boundary-data/Cartan route. -/
structure R684BoundaryDataCartanSnapshot where
  proofWorkObligationCount : Nat
  boundaryDataDirectlyProvesTargetBoundary : Bool
  boundaryDataCompactDualCartanProvesSourceCartan : Bool
  cartanCarrierEquivalentToCompactDualH8Carrier : Bool
  boundaryDataCartanEquivalentToCartanBoundaryEquality : Bool
  boundaryDataCartanEquivalentToBoundaryDataCompactDualH8 : Bool
  introducesStrongerPremise : Bool
  provesBoundaryData : Bool
  provesCompactDualCartan : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R684 status: the live route is a two-target boundary-data plus
Cartan-carrier contract.  Both targets remain open. -/
def currentR684BoundaryDataCartanSnapshot :
    R684BoundaryDataCartanSnapshot where
  proofWorkObligationCount := currentR684BoundaryDataCartanTargetNames.length
  boundaryDataDirectlyProvesTargetBoundary := true
  boundaryDataCompactDualCartanProvesSourceCartan := true
  cartanCarrierEquivalentToCompactDualH8Carrier := true
  boundaryDataCartanEquivalentToCartanBoundaryEquality := true
  boundaryDataCartanEquivalentToBoundaryDataCompactDualH8 := true
  introducesStrongerPremise := false
  provesBoundaryData := false
  provesCompactDualCartan := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R684 ledger. -/
theorem currentR684BoundaryDataCartanSnapshot_eq_texStatus :
    currentR684BoundaryDataCartanSnapshot =
      ({ proofWorkObligationCount := 2
         boundaryDataDirectlyProvesTargetBoundary := true
         boundaryDataCompactDualCartanProvesSourceCartan := true
         cartanCarrierEquivalentToCompactDualH8Carrier := true
         boundaryDataCartanEquivalentToCartanBoundaryEquality := true
         boundaryDataCartanEquivalentToBoundaryDataCompactDualH8 := true
         introducesStrongerPremise := false
         provesBoundaryData := false
         provesCompactDualCartan := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R684BoundaryDataCartanSnapshot) := by
  decide

/-- Kernel-checked target names for the R684 boundary-data/Cartan route. -/
theorem currentR684BoundaryDataCartanTargetNames_eq_texStatus :
    currentR684BoundaryDataCartanTargetNames = [
      "prove MatsushimaV56BoundaryData",
      "prove compactDual = CartanH8"
    ] := by
  rfl

def R684_substantiveTheoremCount : Nat := 7

end FrontC120_H8ResidualBoundaryDataCartanContract
end HCGapL4
end HodgeReduction
