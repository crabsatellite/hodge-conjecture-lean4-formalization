/-
# HC Gap L4 -- Front C78: target-internal quotient kernel (R642).

R641 exposes the remaining target-side theorem as vanishing of the image
of `target_invariants` in the quotient by the Matsushima source-invariant
image.  This file pulls that quotient map back to the source subspace
inside `target_invariants`.

The new object is not a stronger premise: it is the comap of
`Submodule.map j_q source_invariants` along the inclusion of
`target_invariants`.  R642 proves:

* this internal source-image subspace maps back to the original source
  image in `B`;
* it is `top` exactly when R638/R641 saturation holds;
* the R641 quotient map has this subspace as its kernel and the R641
  excess quotient as its range;
* finite-dimensional rank-nullity turns the remaining target into a
  concrete codimension computation inside `target_invariants`.

No axiom, trick definition, or stronger closure premise is introduced.
-/

import HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC78_H8ResidualTargetInvariantInternalQuotient

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation
open FrontC36_TargetBettiObstruction
open FrontC71_H8ResidualSourceInvariantExactImageContract
open FrontC73_H8ResidualExactImageContainmentObstruction
open FrontC74_H8ResidualTargetInvariantSaturation
open FrontC75_H8ResidualTargetInvariantRankCriterion
open FrontC77_H8ResidualTargetInvariantExcessQuotient

section TargetInternalQuotient

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

/-- The source-invariant image, regarded as a subspace inside
`target_invariants`.  This is a comap along the target inclusion, not a
new carrier or stronger assumption. -/
def sourceInvariantImageInsideTarget :
    Submodule Rat (MatsushimaData.target_invariants (A := A) (B := B)) :=
  Submodule.comap (MatsushimaData.target_invariants (A := A) (B := B)).subtype
    (sourceInvariantImage A B)

/-- The quotient map from target invariants to the R641 quotient by the
source-invariant image. -/
def targetInvariantQuotientMap :
    (MatsushimaData.target_invariants (A := A) (B := B)) →ₗ[Rat]
      (B ⧸ sourceInvariantImage A B) :=
  (Submodule.mkQ (sourceInvariantImage A B)).comp
    (MatsushimaData.target_invariants (A := A) (B := B)).subtype

variable {A B}

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (1/10)**: the target-internal source
image maps back to the original Matsushima source-invariant image. -/
theorem sourceInvariantImageInsideTarget_map_eq_sourceInvariantImage :
    Submodule.map (MatsushimaData.target_invariants (A := A) (B := B)).subtype
        (sourceInvariantImageInsideTarget A B) =
      sourceInvariantImage A B := by
  unfold sourceInvariantImageInsideTarget
  rw [Submodule.map_comap_subtype]
  exact inf_eq_right.mpr
    (MatsushimaData.j_q_image_invariants_subset_target_invariants
      (A := A) (B := B))

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (2/10)**: target-internal fullness is
exactly R638 target-invariant saturation. -/
theorem sourceInvariantImageInsideTarget_eq_top_iff_sourceInvariantImageSaturation :
    sourceInvariantImageInsideTarget A B = ⊤ ↔
      sourceInvariantImageSaturatesTargetInvariants A B := by
  unfold sourceInvariantImageInsideTarget
  unfold sourceInvariantImageSaturatesTargetInvariants
  exact Submodule.comap_subtype_eq_top

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (3/10)**: the R641 quotient vanishes
exactly when the internal source-image subspace is all of
`target_invariants`. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top :
    targetInvariantExcessQuotient A B = ⊥ ↔
      sourceInvariantImageInsideTarget A B = ⊤ :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation
    (A := A) (B := B)).trans
    (sourceInvariantImageInsideTarget_eq_top_iff_sourceInvariantImageSaturation
      (A := A) (B := B)).symm

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (4/10)**: the internal source-image
subspace has the same finrank as the original source invariants. -/
theorem sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants :
    Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
      Module.finrank (R := Rat)
        (MatsushimaData.source_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
        Module.finrank (R := Rat)
          (Submodule.map
            (MatsushimaData.target_invariants (A := A) (B := B)).subtype
            (sourceInvariantImageInsideTarget A B)) :=
      (Submodule.finrank_map_subtype_eq
        (MatsushimaData.target_invariants (A := A) (B := B))
        (sourceInvariantImageInsideTarget A B)).symm
    _ = Module.finrank (R := Rat) (sourceInvariantImage A B) := by
      rw [sourceInvariantImageInsideTarget_map_eq_sourceInvariantImage]
    _ = Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) := by
      unfold sourceInvariantImage
      exact sourceInvariantImage_finrank_eq_sourceInvariants
        (A := A) (B := B)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (5/10)**: in finite-dimensional target
invariants, internal fullness is exactly equality of internal and target
finranks. -/
theorem sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    sourceInvariantImageInsideTarget A B = ⊤ ↔
      Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) := by
  constructor
  · intro htop
    rw [htop]
    exact
      (Submodule.topEquiv
        (R := Rat)
        (M := MatsushimaData.target_invariants (A := A) (B := B))).finrank_eq
  · intro hfin
    exact Submodule.eq_top_of_finrank_eq hfin

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (6/10)**: target-internal fullness is the
same finite-dimensional invariant-rank target as R639. -/
theorem sourceInvariantImageInsideTarget_eq_top_iff_targetInvariantFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    sourceInvariantImageInsideTarget A B = ⊤ ↔
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) := by
  constructor
  · intro htop
    calc
      Module.finrank (R := Rat)
          (MatsushimaData.source_invariants (A := A) (B := B)) =
        Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) :=
          (sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants
            (A := A) (B := B)).symm
      _ = Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
          (sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank
            (A := A) (B := B)).1 htop
  · intro hrank
    exact
      (sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank
        (A := A) (B := B)).2
        (by
          calc
            Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
              Module.finrank (R := Rat)
                (MatsushimaData.source_invariants (A := A) (B := B)) :=
                sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants
                  (A := A) (B := B)
            _ = Module.finrank (R := Rat)
                (MatsushimaData.target_invariants (A := A) (B := B)) := hrank)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (7/10)**: the range of the target
quotient map is the R641 target-excess quotient. -/
theorem targetInvariantQuotientMap_range :
    LinearMap.range (targetInvariantQuotientMap A B) =
      targetInvariantExcessQuotient A B := by
  unfold targetInvariantQuotientMap
  unfold targetInvariantExcessQuotient
  rw [LinearMap.range_comp, Submodule.range_subtype]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (8/10)**: the kernel of the target quotient
map is exactly the source-invariant image inside `target_invariants`. -/
theorem targetInvariantQuotientMap_ker :
    LinearMap.ker (targetInvariantQuotientMap A B) =
      sourceInvariantImageInsideTarget A B := by
  unfold targetInvariantQuotientMap
  unfold sourceInvariantImageInsideTarget
  rw [LinearMap.ker_comp, Submodule.ker_mkQ]

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (9/10)**: rank-nullity for the R641 target
quotient map.  The quotient-excess rank plus the internal source-image
rank equals the full target-invariant rank. -/
theorem targetInvariantExcessQuotient_finrank_add_sourceInvariantImageInsideTarget_finrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
      Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) := by
  calc
    Module.finrank (R := Rat) (targetInvariantExcessQuotient A B) +
        Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
      Module.finrank (R := Rat) (LinearMap.range (targetInvariantQuotientMap A B)) +
        Module.finrank (R := Rat) (LinearMap.ker (targetInvariantQuotientMap A B)) := by
        rw [targetInvariantQuotientMap_range, targetInvariantQuotientMap_ker]
    _ = Module.finrank (R := Rat)
        (MatsushimaData.target_invariants (A := A) (B := B)) :=
      LinearMap.finrank_range_add_finrank_ker
        (targetInvariantQuotientMap A B)

omit [CohomologyRing A] [KaehlerClass A] [CompactDualData A]
  [CartanCompactDualIso A] [MatsushimaSurjectivityData A B]
  [MatsushimaCompactDualData A B] [CuspidalCohomologyData B]
  [EisensteinVanishingDeg8 A B]
  [CuspidalGInvariantTrivialModuleDeg8 A B] in
/-- **R642 substantive theorem (10/10)**: the R641 quotient-vanishing
target is equivalently the internal finite-dimensional codimension-zero
target. -/
theorem targetInvariantExcessQuotient_eq_bot_iff_internalFinrank
    [FiniteDimensional Rat
      (MatsushimaData.target_invariants (A := A) (B := B))] :
    targetInvariantExcessQuotient A B = ⊥ ↔
      Module.finrank (R := Rat) (sourceInvariantImageInsideTarget A B) =
        Module.finrank (R := Rat)
          (MatsushimaData.target_invariants (A := A) (B := B)) :=
  (targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top
    (A := A) (B := B)).trans
    (sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank
      (A := A) (B := B))

end TargetInternalQuotient

section Obstruction

/-- The existing countermodel also refutes target-internal fullness. -/
theorem counterexample_not_sourceInvariantImageInsideTarget_eq_top :
    Not
      (sourceInvariantImageInsideTarget
          TargetBettiSource TargetBettiTarget = ⊤) := by
  intro htop
  exact counterexample_not_targetInvariantExcessQuotient_eq_bot
    ((targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top
      (A := TargetBettiSource) (B := TargetBettiTarget)).2 htop)

/-- Exact image plus source-H8 still does not force the internal
source-image subspace to be all target invariants in the current abstract
interface. -/
theorem current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageInsideTarget :
    sourceInvariantExactImageTarget TargetBettiSource TargetBettiTarget /\
      (MatsushimaData.source_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget) =
        CompactDualData.H8 (A := TargetBettiSource)) /\
      Not
        (sourceInvariantImageInsideTarget
          TargetBettiSource TargetBettiTarget = ⊤) :=
  ⟨counterexample_sourceInvariantExactImageTarget,
    counterexample_source_invariants_eq_H8,
    counterexample_not_sourceInvariantImageInsideTarget_eq_top⟩

end Obstruction

/-- R642 target names for route summaries. -/
def currentR642TargetInvariantInternalQuotientTargetNames : List String := [
  "prove Submodule.map j_q source_invariants = surjectivity_target",
  "prove source_invariants = H8",
  "prove sourceInvariantImageInsideTarget = top",
  "compute codim(sourceInvariantImageInsideTarget, target_invariants) = 0"
]

/-- Machine-readable status for the R642 target-internal quotient kernel
normalization. -/
structure R642TargetInvariantInternalQuotientSnapshot where
  proofWorkObligationCount : Nat
  exactImageCarrierObligationCount : Nat
  internalTargetSubspaceObligationCount : Nat
  quotientVanishingEquivalentToInternalTop : Bool
  rankNullityAvailableForTargetQuotientMap : Bool
  internalTopEquivalentToTargetRank : Bool
  carriersForceInternalTop : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R642 status: the target quotient is now an ordinary quotient
map out of `target_invariants`; its kernel is the internal source-image
subspace, and the live target is codimension zero for that subspace. -/
def currentR642TargetInvariantInternalQuotientSnapshot :
    R642TargetInvariantInternalQuotientSnapshot where
  proofWorkObligationCount := currentR642TargetInvariantInternalQuotientTargetNames.length
  exactImageCarrierObligationCount := 2
  internalTargetSubspaceObligationCount := 1
  quotientVanishingEquivalentToInternalTop := true
  rankNullityAvailableForTargetQuotientMap := true
  internalTopEquivalentToTargetRank := true
  carriersForceInternalTop := false
  fullHcClosureClaim := false
  isClosureClaim := false

/-- Kernel-checked numeric/Boolean status for the R642 internal quotient
ledger. -/
theorem currentR642TargetInvariantInternalQuotientSnapshot_eq_texStatus :
    currentR642TargetInvariantInternalQuotientSnapshot =
      ({ proofWorkObligationCount := 4
         exactImageCarrierObligationCount := 2
         internalTargetSubspaceObligationCount := 1
         quotientVanishingEquivalentToInternalTop := true
         rankNullityAvailableForTargetQuotientMap := true
         internalTopEquivalentToTargetRank := true
         carriersForceInternalTop := false
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R642TargetInvariantInternalQuotientSnapshot) := by
  decide

/-- Kernel-checked target names for the R642 internal quotient ledger. -/
theorem currentR642TargetInvariantInternalQuotientTargetNames_eq_texStatus :
    currentR642TargetInvariantInternalQuotientTargetNames = [
      "prove Submodule.map j_q source_invariants = surjectivity_target",
      "prove source_invariants = H8",
      "prove sourceInvariantImageInsideTarget = top",
      "compute codim(sourceInvariantImageInsideTarget, target_invariants) = 0"
    ] := by
  rfl

def R642_substantiveTheoremCount : Nat := 10

end FrontC78_H8ResidualTargetInvariantInternalQuotient
end HCGapL4
end HodgeReduction
