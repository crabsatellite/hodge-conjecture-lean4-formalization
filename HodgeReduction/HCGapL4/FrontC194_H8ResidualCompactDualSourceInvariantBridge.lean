/-
# HC Gap L4 -- Front C194: compactDual-H8 as source-invariants-H8 (R759).

R758 leaves one visible carrier theorem as `compactDual = H8`.  The
Matsushima compact-dual infrastructure already contains the genuine comparison
field

  `compactDual = source_invariants`.

This file names the exact consequences needed by the route: the compact-dual
H8 theorem is precisely the source-invariants H8 theorem, and the generator
membership / rank-one spellings transport across the same comparison.

No compact-dual theorem, source-H8 theorem, boundary theorem, or closure theorem
is proved here.  The point is to make the next attack surface unambiguous:
prove the genuine source-invariants H8 carrier, or prove an equivalent
generator/rank-one source-invariant package.
-/

import HodgeReduction.HCGapL4.FrontC193_H8ResidualBoundaryCompactDualCartanImagePointwise

set_option linter.dupNamespace false
set_option linter.unusedSectionVars false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC194_H8ResidualCompactDualSourceInvariantBridge

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic

section CompactDualSourceInvariantBridge

variable {A B : Type*}
  [CommRing A] [Algebra Rat A] [CohomologyRing A]
  [KaehlerClass A] [CompactDualData A]
  [AddCommGroup B] [Module Rat B]
  [MatsushimaData A B]
  [MatsushimaCompactDualData A B]

/-- **R759 substantive theorem (1/6)**: the visible compact-dual/H8 carrier
gap is exactly the source-invariants/H8 carrier gap, by the built-in
compact-dual comparison field. -/
theorem compactDual_eq_H8_iff_source_invariants_eq_H8 :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) <->
      (MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) := by
  constructor
  · intro hcompact
    calc
      MatsushimaData.source_invariants (A := A) (B := B)
          = MatsushimaCompactDualData.compactDual (A := A) (B := B) :=
          (MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)).symm
      _ = CompactDualData.H8 (A := A) := hcompact
  · intro hsource
    calc
      MatsushimaCompactDualData.compactDual (A := A) (B := B)
          = MatsushimaData.source_invariants (A := A) (B := B) :=
          MatsushimaCompactDualData.compactDual_eq_source_invariants
            (A := A) (B := B)
      _ = CompactDualData.H8 (A := A) := hsource

/-- **R759 substantive theorem (2/6)**: compact-dual/H8 supplies the
equivalent source-invariants/H8 carrier statement. -/
theorem source_invariants_eq_H8_of_compactDual_eq_H8
    (hcompact :
      MatsushimaCompactDualData.compactDual (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaData.source_invariants (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (compactDual_eq_H8_iff_source_invariants_eq_H8
    (A := A) (B := B)).1 hcompact

/-- **R759 substantive theorem (3/6)**: source-invariants/H8 supplies the
visible compact-dual/H8 carrier statement. -/
theorem compactDual_eq_H8_of_source_invariants_eq_H8
    (hsource :
      MatsushimaData.source_invariants (A := A) (B := B) =
        CompactDualData.H8 (A := A)) :
    MatsushimaCompactDualData.compactDual (A := A) (B := B) =
      CompactDualData.H8 (A := A) :=
  (compactDual_eq_H8_iff_source_invariants_eq_H8
    (A := A) (B := B)).2 hsource

/-- **R759 substantive theorem (4/6)**: generator membership in compact-dual
and generator membership in source-invariants are the same target. -/
theorem h_pow_four_mem_compactDual_iff_source_invariants :
    (MatsushimaCompactDualData.compactDual (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) <->
      (MatsushimaData.source_invariants (A := A) (B := B)).carrier
        ((KaehlerClass.h : A) ^ 4) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

/-- **R759 substantive theorem (5/6)**: exact rank-one for the compact-dual
carrier is the same rank-one target for source-invariants. -/
theorem compactDual_finrank_eq_one_iff_source_invariants_finrank_eq_one :
    (Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) = 1) <->
      (Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) = 1) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

/-- **R759 substantive theorem (6/6)**: the compact-dual rank is literally
the source-invariants rank under the comparison field. -/
theorem compactDual_finrank_eq_source_invariants_finrank :
    Module.finrank (R := Rat)
        (MatsushimaCompactDualData.compactDual (A := A) (B := B)) =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
  rw [MatsushimaCompactDualData.compactDual_eq_source_invariants
    (A := A) (B := B)]

end CompactDualSourceInvariantBridge

/-- R759 target names for route summaries. -/
def currentR759CompactDualSourceInvariantBridgeTargetNames : List String := [
  "prove source_invariants = H8",
  "equivalently prove h^4 in source_invariants and finrank source_invariants = 1"
]

/-- Machine-readable status for the R759 compact-dual/source-invariant bridge. -/
structure R759CompactDualSourceInvariantBridgeSnapshot where
  compactDualH8EquivalentToSourceInvariantH8 : Bool
  compactDualGeneratorEquivalentToSourceGenerator : Bool
  compactDualRankOneEquivalentToSourceRankOne : Bool
  introducesStrongerPremise : Bool
  provesCompactDualH8 : Bool
  provesSourceInvariantH8 : Bool
  provesBoundaryData : Bool
  provesCurrentCartanImageContractUnconditionally : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R759 status: the compact-dual/H8 carrier is not a separate
surface from source-invariants/H8; proving either proves the other. -/
def currentR759CompactDualSourceInvariantBridgeSnapshot :
    R759CompactDualSourceInvariantBridgeSnapshot where
  compactDualH8EquivalentToSourceInvariantH8 := true
  compactDualGeneratorEquivalentToSourceGenerator := true
  compactDualRankOneEquivalentToSourceRankOne := true
  introducesStrongerPremise := false
  provesCompactDualH8 := false
  provesSourceInvariantH8 := false
  provesBoundaryData := false
  provesCurrentCartanImageContractUnconditionally := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked status for the R759 compact-dual/source-invariant bridge. -/
theorem currentR759CompactDualSourceInvariantBridgeSnapshot_eq_texStatus :
    currentR759CompactDualSourceInvariantBridgeSnapshot =
      ({ compactDualH8EquivalentToSourceInvariantH8 := true
         compactDualGeneratorEquivalentToSourceGenerator := true
         compactDualRankOneEquivalentToSourceRankOne := true
         introducesStrongerPremise := false
         provesCompactDualH8 := false
         provesSourceInvariantH8 := false
         provesBoundaryData := false
         provesCurrentCartanImageContractUnconditionally := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R759CompactDualSourceInvariantBridgeSnapshot) := by
  decide

/-- Kernel-checked target names for the R759 bridge. -/
theorem currentR759CompactDualSourceInvariantBridgeTargetNames_eq_texStatus :
    currentR759CompactDualSourceInvariantBridgeTargetNames = [
      "prove source_invariants = H8",
      "equivalently prove h^4 in source_invariants and finrank source_invariants = 1"
    ] := by
  rfl

def R759_substantiveTheoremCount : Nat := 6

end FrontC194_H8ResidualCompactDualSourceInvariantBridge
end HCGapL4
end HodgeReduction
