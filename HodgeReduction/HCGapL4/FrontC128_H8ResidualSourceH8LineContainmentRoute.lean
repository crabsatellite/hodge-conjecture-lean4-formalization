/-
# HC Gap L4 -- Front C128: source-H8 line-containment route (R692).

R691 leaves three live inputs:

* `surjectivity_source = compactDual`;
* `h^4` lies in `source_invariants`;
* `trivialModulePart <= span {j_q(h^4)}`.

The last two inputs already recover `source_invariants = H8` by the earlier
line-containment route.  Since `MatsushimaCompactDualData` identifies
`compactDual` with `source_invariants`, the first R691 input is equivalent,
under the other two fields, to the more concrete source-H8 statement

  `surjectivity_source = H8`.

This file records that equivalence as the preferred next source-side attack
surface.  It does not prove source-H8 surjectivity, generator membership, or
line containment; it only removes one layer of abstract compact-dual notation
from the R691 route.
-/

import HodgeReduction.HCGapL4.FrontC127_H8ResidualLineContainmentExplicitFiniteRoute

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC128_H8ResidualSourceH8LineContainmentRoute

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC95_H8ResidualSourceNoExtraFromLineContainment
open FrontC127_H8ResidualLineContainmentExplicitFiniteRoute

section SourceH8LineContainment

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

/-- The R692 source-H8 spelling of the R691 route.  The first field is the
concrete H8 source-surjectivity target that is equivalent to
`surjectivity_source = compactDual` once the generator membership and line
containment fields are available. -/
structure EVIIH8ResidualSourceH8LineContainmentContract where
  surjectivity_source_eq_H8 :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A)
  h_pow_four_mem_source_invariants :
    (MatsushimaData.source_invariants (A := A) (B := B)).carrier
      ((KaehlerClass.h : A) ^ 4)
  trivialModulePart_le_h_pow_four_line :
    CuspidalCohomologyData.trivialModulePart (A := B) <=
      Submodule.span Rat
        {MatsushimaData.j_q (A := A) (B := B)
          ((KaehlerClass.h : A) ^ 4)}

variable {A B}

/-- **R692 substantive theorem (1/6)**: source generator membership plus line
containment identifies the compact-dual source carrier with H8. -/
theorem compactDual_eq_H8_of_h_pow_four_mem_source_lineContainment
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]
  exact
    source_invariants_eq_H8_of_h_pow_four_mem_source_and_line
      (A := A) (B := B) hh_pow hline

/-- **R692 substantive theorem (2/6)**: in the R691 context, source-boundary
equality implies the concrete source-H8 surjectivity statement. -/
theorem surjectivity_source_eq_H8_of_source_eq_compactDual_h_pow_four_mem_source_lineContainment
    (hsource :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        MatsushimaCompactDualData.compactDual (A := A) (B := B))
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  hsource.trans
    (compactDual_eq_H8_of_h_pow_four_mem_source_lineContainment
      (A := A) (B := B) hh_pow hline)

/-- **R692 substantive theorem (3/6)**: conversely, in the same generator-line
context, concrete source-H8 surjectivity recovers the R691 source-boundary
field. -/
theorem source_eq_compactDual_of_surjectivity_source_eq_H8_h_pow_four_mem_source_lineContainment
    (hsource_H8 :
      MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
        CompactDualData.H8 (A := A))
    (hh_pow :
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4))
    (hline :
      CuspidalCohomologyData.trivialModulePart (A := B) <=
        Submodule.span Rat
          {MatsushimaData.j_q (A := A) (B := B)
            ((KaehlerClass.h : A) ^ 4)}) :
    MatsushimaSurjectivityData.surjectivity_source (A := A) (B := B) =
      MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
  hsource_H8.trans
    (compactDual_eq_H8_of_h_pow_four_mem_source_lineContainment
      (A := A) (B := B) hh_pow hline).symm

/-- **R692 substantive theorem (4/6)**: the source-H8 route feeds the R691
source-boundary line-containment contract. -/
def sourceBoundaryLineContainmentContract_of_sourceH8LineContainmentContract
    (O : EVIIH8ResidualSourceH8LineContainmentContract A B) :
    EVIIH8ResidualSourceBoundaryLineContainmentContract A B where
  source_eq_compactDual :=
    source_eq_compactDual_of_surjectivity_source_eq_H8_h_pow_four_mem_source_lineContainment
      (A := A) (B := B)
      O.surjectivity_source_eq_H8
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_le_h_pow_four_line
  h_pow_four_mem_source_invariants := O.h_pow_four_mem_source_invariants
  trivialModulePart_le_h_pow_four_line := O.trivialModulePart_le_h_pow_four_line

/-- **R692 substantive theorem (5/6)**: R691 also feeds the concrete
source-H8 route, so the replacement of the first field is not a stronger
premise once the other two fields are fixed. -/
def sourceH8LineContainmentContract_of_sourceBoundaryLineContainmentContract
    (O : EVIIH8ResidualSourceBoundaryLineContainmentContract A B) :
    EVIIH8ResidualSourceH8LineContainmentContract A B where
  surjectivity_source_eq_H8 :=
    surjectivity_source_eq_H8_of_source_eq_compactDual_h_pow_four_mem_source_lineContainment
      (A := A) (B := B)
      O.source_eq_compactDual
      O.h_pow_four_mem_source_invariants
      O.trivialModulePart_le_h_pow_four_line
  h_pow_four_mem_source_invariants := O.h_pow_four_mem_source_invariants
  trivialModulePart_le_h_pow_four_line := O.trivialModulePart_le_h_pow_four_line

/-- **R692 substantive theorem (6/6)**: the source-H8 spelling and the R691
source-boundary spelling are equivalent residual route packages. -/
theorem residual_sourceH8LineContainment_nonempty_iff_sourceBoundaryLineContainment_nonempty :
    Nonempty (EVIIH8ResidualSourceH8LineContainmentContract A B) ↔
      Nonempty (EVIIH8ResidualSourceBoundaryLineContainmentContract A B) :=
  Iff.intro
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceBoundaryLineContainmentContract_of_sourceH8LineContainmentContract
            (A := A) (B := B) O)))
    (fun h =>
      h.elim (fun O =>
        Nonempty.intro
          (sourceH8LineContainmentContract_of_sourceBoundaryLineContainmentContract
            (A := A) (B := B) O)))

end SourceH8LineContainment

/-- R692 target names for route summaries. -/
def currentR692SourceH8LineContainmentTargetNames : List String := [
  "prove surjectivity_source = H8",
  "prove h^4 in source_invariants",
  "prove trivialModulePart <= span {j_q(h^4)}"
]

/-- Machine-readable status for the source-H8 line-containment route. -/
structure R692SourceH8LineContainmentSnapshot where
  proofWorkObligationCount : Nat
  generatorLineFieldsIdentifyCompactDualWithH8 : Bool
  sourceBoundaryEquivalentToSourceH8UnderGeneratorLineFields : Bool
  sourceH8RouteFeedsR691 : Bool
  r691FeedsSourceH8Route : Bool
  introducesStrongerPremiseThanR691UnderGeneratorLineFields : Bool
  provesSourceH8Surjectivity : Bool
  provesGeneratorMembership : Bool
  provesLineContainment : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R692 status: the first R691 field can now be attacked concretely
as `surjectivity_source = H8` once the generator membership and line
containment fields are part of the same route. -/
def currentR692SourceH8LineContainmentSnapshot :
    R692SourceH8LineContainmentSnapshot where
  proofWorkObligationCount := currentR692SourceH8LineContainmentTargetNames.length
  generatorLineFieldsIdentifyCompactDualWithH8 := true
  sourceBoundaryEquivalentToSourceH8UnderGeneratorLineFields := true
  sourceH8RouteFeedsR691 := true
  r691FeedsSourceH8Route := true
  introducesStrongerPremiseThanR691UnderGeneratorLineFields := false
  provesSourceH8Surjectivity := false
  provesGeneratorMembership := false
  provesLineContainment := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked Boolean status for the R692 route ledger. -/
theorem currentR692SourceH8LineContainmentSnapshot_eq_texStatus :
    currentR692SourceH8LineContainmentSnapshot =
      ({ proofWorkObligationCount := 3
         generatorLineFieldsIdentifyCompactDualWithH8 := true
         sourceBoundaryEquivalentToSourceH8UnderGeneratorLineFields := true
         sourceH8RouteFeedsR691 := true
         r691FeedsSourceH8Route := true
         introducesStrongerPremiseThanR691UnderGeneratorLineFields := false
         provesSourceH8Surjectivity := false
         provesGeneratorMembership := false
         provesLineContainment := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R692SourceH8LineContainmentSnapshot) := by
  decide

/-- Kernel-checked target names for the R692 route. -/
theorem currentR692SourceH8LineContainmentTargetNames_eq_texStatus :
    currentR692SourceH8LineContainmentTargetNames = [
      "prove surjectivity_source = H8",
      "prove h^4 in source_invariants",
      "prove trivialModulePart <= span {j_q(h^4)}"
    ] := by
  rfl

def R692_substantiveTheoremCount : Nat := 6

end FrontC128_H8ResidualSourceH8LineContainmentRoute
end HCGapL4
end HodgeReduction
