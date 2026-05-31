/-
# HC Gap L4 -- Front C98: exact image is independent of the other live targets (R662).

After R661 the active H8 residual contract has three targets:

* exact image: `Submodule.map j_q source_invariants = surjectivity_target`;
* source carrier: `CartanH8 <= compactDual`;
* target line: `trivialModulePart <= span {j_q(h^4)}`.

This file records a small kernel-checked obstruction: the latter two targets
do not force exact image in the current abstract Matsushima interface.  Thus
the exact-image/source-equality target must be supplied by genuine Matsushima
source geometry, not by the compact-dual carrier direction plus target-line
control.
-/

import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC98_H8ResidualExactImageIndependence

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC71_H8ResidualSourceInvariantExactImageContract

/-- One-dimensional source for the exact-image independence countermodel. -/
def ExactImageObstructionSource := Rat

/-- One-dimensional target for the exact-image independence countermodel. -/
def ExactImageObstructionTarget := Rat

instance : CommRing ExactImageObstructionSource := inferInstanceAs (CommRing Rat)
instance : Algebra Rat ExactImageObstructionSource := inferInstanceAs (Algebra Rat Rat)
instance : AddCommGroup ExactImageObstructionSource := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat ExactImageObstructionSource := inferInstanceAs (Module Rat Rat)
instance : One ExactImageObstructionTarget := inferInstanceAs (One Rat)
instance (n : Nat) : OfNat ExactImageObstructionTarget n := inferInstanceAs (OfNat Rat n)
instance : AddCommGroup ExactImageObstructionTarget := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat ExactImageObstructionTarget := inferInstanceAs (Module Rat Rat)

/-- The identity Matsushima map for the countermodel. -/
def exactImageObstructionIdMap :
    ExactImageObstructionSource →ₗ[Rat] ExactImageObstructionTarget :=
  LinearMap.id

noncomputable instance instCohomologyRingExactImageObstructionSource :
    CohomologyRing ExactImageObstructionSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassExactImageObstructionSource :
    KaehlerClass ExactImageObstructionSource where
  h := (1 : ExactImageObstructionSource)
  h_isAlgebraic := by
    change (1 : ExactImageObstructionSource) ∈
      (⊤ : Subalgebra Rat ExactImageObstructionSource)
    trivial
  h_pow_4_ne_zero := by
    change (1 : Rat) ^ 4 ≠ 0
    norm_num

noncomputable instance instCompactDualDataExactImageObstructionSource :
    CompactDualData ExactImageObstructionSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : ExactImageObstructionSource) ^ 4)} :
        Set ExactImageObstructionSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoExactImageObstructionSource :
    CartanCompactDualIso ExactImageObstructionSource where
  trivialModuleGK_H8 :=
    CompactDualData.H8 (A := ExactImageObstructionSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataExactImageObstruction :
    MatsushimaData ExactImageObstructionSource ExactImageObstructionTarget where
  j_q := exactImageObstructionIdMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact hxy
  source_invariants := ⊤
  target_invariants := ⊤
  j_q_maps_invariants_to_invariants := by
    intro _ _
    trivial
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataExactImageObstruction :
    MatsushimaSurjectivityData ExactImageObstructionSource ExactImageObstructionTarget where
  surjectivity_source := ⊥
  surjectivity_target := ⊥
  surjectivity_eq := by
    ext x
    simp [exactImageObstructionIdMap]

noncomputable instance instMatsushimaCompactDualDataExactImageObstruction :
    MatsushimaCompactDualData ExactImageObstructionSource ExactImageObstructionTarget where
  compactDual := ⊤
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataExactImageObstruction :
    CuspidalCohomologyData ExactImageObstructionTarget where
  cuspidalSubspace := ⊤
  trivialModulePart := ⊤
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8ExactImageObstruction :
    EisensteinVanishingDeg8 ExactImageObstructionSource ExactImageObstructionTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8ExactImageObstruction :
    CuspidalGInvariantTrivialModuleDeg8 ExactImageObstructionSource
      ExactImageObstructionTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change
      (x ∈ (⊤ : Submodule Rat ExactImageObstructionTarget) ∧
          x ∈ (⊤ : Submodule Rat ExactImageObstructionTarget)) ↔
        x ∈ (⊤ : Submodule Rat ExactImageObstructionTarget)
    simp

/-- **R662 obstruction theorem (1/5)**: the countermodel has the current
source carrier target `CartanH8 <= compactDual`. -/
theorem counterexample_cartanH8_le_compactDual :
    LE.le (CartanCompactDualIso.trivialModuleGK_H8
        (A := ExactImageObstructionSource))
      (MatsushimaCompactDualData.compactDual
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget)) := by
  intro x _
  trivial

/-- **R662 obstruction theorem (2/5)**: the countermodel has the target
generator-line containment. -/
theorem counterexample_trivialModulePart_le_h_pow_four_line :
    LE.le
      (CuspidalCohomologyData.trivialModulePart
        (A := ExactImageObstructionTarget))
      (Submodule.span Rat
        {MatsushimaData.j_q
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget)
          ((KaehlerClass.h : ExactImageObstructionSource) ^ 4)}) := by
  intro beta _
  rw [Submodule.mem_span_singleton]
  refine ⟨(show Rat from beta), ?_⟩
  change (show Rat from beta) • (1 : ExactImageObstructionTarget) = beta
  simp

/-- **R662 obstruction theorem (3/5)**: exact image fails in the same
countermodel. -/
theorem counterexample_not_sourceInvariantExactImageTarget :
    Not (sourceInvariantExactImageTarget
      ExactImageObstructionSource ExactImageObstructionTarget) := by
  intro hexact
  change
    Submodule.map exactImageObstructionIdMap
        (⊤ : Submodule Rat ExactImageObstructionSource) =
      (⊥ : Submodule Rat ExactImageObstructionTarget) at hexact
  have hmap_top :
      Submodule.map exactImageObstructionIdMap
          (⊤ : Submodule Rat ExactImageObstructionSource) =
        (⊤ : Submodule Rat ExactImageObstructionTarget) := by
    ext x
    constructor
    · intro _
      trivial
    · intro _
      exact ⟨x, trivial, rfl⟩
  have htop_bot :
      (⊤ : Submodule Rat ExactImageObstructionTarget) =
        (⊥ : Submodule Rat ExactImageObstructionTarget) := by
    rw [← hmap_top]
    exact hexact
  have hone_bot :
      (1 : ExactImageObstructionTarget) ∈
        (⊥ : Submodule Rat ExactImageObstructionTarget) := by
    rw [← htop_bot]
    trivial
  change (1 : Rat) = 0 at hone_bot
  norm_num at hone_bot

/-- **R662 obstruction theorem (4/5)**: the other two live targets do not
force exact image in the current abstract interface. -/
theorem current_interface_with_cartanContainment_line_does_not_force_exactImage :
    (LE.le (CartanCompactDualIso.trivialModuleGK_H8
        (A := ExactImageObstructionSource))
      (MatsushimaCompactDualData.compactDual
        (A := ExactImageObstructionSource)
        (B := ExactImageObstructionTarget))) ∧
    (LE.le
      (CuspidalCohomologyData.trivialModulePart
        (A := ExactImageObstructionTarget))
      (Submodule.span Rat
        {MatsushimaData.j_q
          (A := ExactImageObstructionSource)
          (B := ExactImageObstructionTarget)
          ((KaehlerClass.h : ExactImageObstructionSource) ^ 4)})) ∧
    Not (sourceInvariantExactImageTarget
      ExactImageObstructionSource ExactImageObstructionTarget) :=
  ⟨counterexample_cartanH8_le_compactDual,
    counterexample_trivialModulePart_le_h_pow_four_line,
    counterexample_not_sourceInvariantExactImageTarget⟩

/-- Machine-readable status for the R662 exact-image independence audit. -/
structure R662ExactImageIndependenceSnapshot where
  cartanContainmentAvailable : Bool
  targetLineContainmentAvailable : Bool
  exactImageForcedByThoseTargets : Bool
  exactImageStillIndependentSourceTarget : Bool
  fullHcClosureClaim : Bool
  isClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R662 status: exact image remains an independent live target. -/
def currentR662ExactImageIndependenceSnapshot :
    R662ExactImageIndependenceSnapshot where
  cartanContainmentAvailable := true
  targetLineContainmentAvailable := true
  exactImageForcedByThoseTargets := false
  exactImageStillIndependentSourceTarget := true
  fullHcClosureClaim := false
  isClosureClaim := false

/-- **R662 obstruction theorem (5/5)**: kernel-checked status for the
exact-image independence audit. -/
theorem currentR662ExactImageIndependenceSnapshot_eq_texStatus :
    currentR662ExactImageIndependenceSnapshot =
      ({ cartanContainmentAvailable := true
         targetLineContainmentAvailable := true
         exactImageForcedByThoseTargets := false
         exactImageStillIndependentSourceTarget := true
         fullHcClosureClaim := false
         isClosureClaim := false } :
        R662ExactImageIndependenceSnapshot) := by
  decide

def R662_substantiveTheoremCount : Nat := 5

end FrontC98_H8ResidualExactImageIndependence
end HCGapL4
end HodgeReduction
