/-
# HC Gap L4 -- Front C117: source-compactDual spelling of the three-target route (R681).

R680 leaves three live targets:

* exact image: `Submodule.map j_q source_invariants = surjectivity_target`;
* `CartanH8 <= compactDual`;
* `trivialModulePart <= span {j_q(h^4)}`.

The first item is still an image equation.  This file rewrites it into the
geometric Matsushima source statement

  `surjectivity_source = compactDual`.

The rewrite uses only the existing Matsushima surjectivity equation,
injectivity of `j_q`, and the compact-dual/source-invariants comparison.
It introduces no new instance, axiom, or stronger premise.
-/

import HodgeReduction.HCGapL4.FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC105_H8ResidualTargetInvariantLineEquality
open FrontC111_H8ResidualBoundaryDataCompactDualEquivalence
open FrontC116_H8ResidualExactImageCartanLineThreeTargetEquivalence

section SourceCompactDualExactImage

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A] [CartanCompactDualIso A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B]
  [CuspidalCohomologyData B]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [CuspidalCohomologyData B] in
/-- **R681 substantive theorem (1/6)**: the R680 exact-image target is
equivalent to the Matsushima source/compact-dual equality. -/
theorem source_eq_compactDual_iff_sourceInvariantExactImageTarget :
    (MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B)) <->
      sourceInvariantExactImageTarget A B := by
  constructor
  · intro hsource_compact
    apply sourceInvariantExactImage_of_source_eq_invariants
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          hsource_compact
      _ = MatsushimaData.source_invariants (A := A) (B := B) :=
          MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)
  · intro hexact
    have hsource_invariants :
        MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
          MatsushimaData.source_invariants (A := A) (B := B) :=
      source_eq_invariants_of_sourceInvariantExactImage
        (A := A) (B := B) hexact
    calc
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
          hsource_invariants
      _ = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          (MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)).symm

end SourceCompactDualExactImage

section SourceCompactDualCartanLineThreeTarget

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

/-- The R681 source-compactDual spelling of the R680 three-target route. -/
structure EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract where
  source_eq_compactDual :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
  cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8 (A := A))
      (MatsushimaCompactDualData.compactDual (A := A) (B := B))
  trivialModulePart_le_h_pow_four_line :
    LE.le
      (CuspidalCohomologyData.trivialModulePart (A := B))
      (Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)})

variable {A B}

/-- **R681 substantive theorem (2/6)**: the source-compactDual route feeds
the R680 exact-image route. -/
def exactImageCartanLineThreeTargetContract_of_sourceCompactDualCartanLineThreeTargetContract
    (O : EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) :
    EVIIH8ResidualExactImageCartanLineThreeTargetContract A B where
  source_invariants_exact_image :=
    (source_eq_compactDual_iff_sourceInvariantExactImageTarget
      (A := A) (B := B)).1 O.source_eq_compactDual
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

/-- **R681 substantive theorem (3/6)**: the R680 exact-image route recovers
the source-compactDual route. -/
def sourceCompactDualCartanLineThreeTargetContract_of_exactImageCartanLineThreeTargetContract
    (O : EVIIH8ResidualExactImageCartanLineThreeTargetContract A B) :
    EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B where
  source_eq_compactDual :=
    (source_eq_compactDual_iff_sourceInvariantExactImageTarget
      (A := A) (B := B)).2 O.source_invariants_exact_image
  cartanH8_le_compactDual := O.cartanH8_le_compactDual
  trivialModulePart_le_h_pow_four_line :=
    O.trivialModulePart_le_h_pow_four_line

omit [EisensteinVanishingDeg8 A B] [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R681 substantive theorem (4/6)**: the R680 image-equation route and
the R681 source-compactDual route are equivalent at the inhabited-contract
level. -/
theorem residual_exactImageCartanLineThreeTarget_nonempty_iff_sourceCompactDualCartanLineThreeTarget_nonempty :
    Nonempty (EVIIH8ResidualExactImageCartanLineThreeTargetContract A B) <->
      Nonempty (EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceCompactDualCartanLineThreeTargetContract_of_exactImageCartanLineThreeTargetContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (exactImageCartanLineThreeTargetContract_of_sourceCompactDualCartanLineThreeTargetContract
            (A := A) (B := B) O)))

/-- **R681 substantive theorem (5/6)**: the source-compactDual route is
still the current target-line residual. -/
theorem residual_sourceCompactDualCartanLineThreeTarget_nonempty_iff_targetInvariantLineEquality_nonempty :
    Nonempty (EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) <->
      Nonempty (EVIIH8ResidualTargetInvariantLineEqualityContract A B) :=
  (residual_exactImageCartanLineThreeTarget_nonempty_iff_sourceCompactDualCartanLineThreeTarget_nonempty
    (A := A) (B := B)).symm.trans
    (residual_exactImageCartanLineThreeTarget_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B))

/-- **R681 substantive theorem (6/6)**: the source-compactDual route is also
equivalent to the R675 boundary-data/compact-dual-H8 spelling. -/
theorem residual_sourceCompactDualCartanLineThreeTarget_nonempty_iff_boundaryDataCompactDualH8_nonempty :
    Nonempty (EVIIH8ResidualSourceCompactDualCartanLineThreeTargetContract A B) <->
      Nonempty (EVIIH8ResidualBoundaryDataCompactDualH8Contract A B) :=
  residual_sourceCompactDualCartanLineThreeTarget_nonempty_iff_targetInvariantLineEquality_nonempty
    (A := A) (B := B) |>.trans
    (residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty
      (A := A) (B := B)).symm

end SourceCompactDualCartanLineThreeTarget

/-- Exact R681 target names for route summaries. -/
def currentR681SourceCompactDualCartanLineThreeTargetNames : List String := [
  "prove surjectivity_source = compactDual",
  "prove CartanH8 <= compactDual",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the R681 source-compactDual route. -/
structure R681SourceCompactDualCartanLineThreeTargetSnapshot where
  proofWorkObligationCount : Nat
  sourceCompactDualEquivalentToExactImage : Bool
  sourceCompactDualContractEquivalentToR680 : Bool
  sourceCompactDualContractEquivalentToTargetLine : Bool
  sourceCompactDualContractEquivalentToBoundaryCompactDual : Bool
  introducesStrongerPremise : Bool
  provesSourceCompactDual : Bool
  provesCartanToCompactDual : Bool
  provesTargetLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R681 status: exact image has been replaced by the equivalent
source-compactDual equality, but all three live targets remain open. -/
def currentR681SourceCompactDualCartanLineThreeTargetSnapshot :
    R681SourceCompactDualCartanLineThreeTargetSnapshot where
  proofWorkObligationCount :=
    currentR681SourceCompactDualCartanLineThreeTargetNames.length
  sourceCompactDualEquivalentToExactImage := true
  sourceCompactDualContractEquivalentToR680 := true
  sourceCompactDualContractEquivalentToTargetLine := true
  sourceCompactDualContractEquivalentToBoundaryCompactDual := true
  introducesStrongerPremise := false
  provesSourceCompactDual := false
  provesCartanToCompactDual := false
  provesTargetLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R681 ledger. -/
theorem currentR681SourceCompactDualCartanLineThreeTargetSnapshot_eq_texStatus :
    currentR681SourceCompactDualCartanLineThreeTargetSnapshot =
      ({ proofWorkObligationCount := 3
         sourceCompactDualEquivalentToExactImage := true
         sourceCompactDualContractEquivalentToR680 := true
         sourceCompactDualContractEquivalentToTargetLine := true
         sourceCompactDualContractEquivalentToBoundaryCompactDual := true
         introducesStrongerPremise := false
         provesSourceCompactDual := false
         provesCartanToCompactDual := false
         provesTargetLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R681SourceCompactDualCartanLineThreeTargetSnapshot) := by
  decide

/-- Kernel-checked target names for the R681 source-compactDual route. -/
theorem currentR681SourceCompactDualCartanLineThreeTargetNames_eq_texStatus :
    currentR681SourceCompactDualCartanLineThreeTargetNames = [
      "prove surjectivity_source = compactDual",
      "prove CartanH8 <= compactDual",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R681_substantiveTheoremCount : Nat := 6

end FrontC117_H8ResidualSourceCompactDualCartanLineThreeTargetEquivalence
end HCGapL4
end HodgeReduction
