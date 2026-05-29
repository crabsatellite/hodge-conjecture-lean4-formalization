/-
# HC Gap L4 -- Front C36: target expected-Betti obstruction (R577).

R576 reduced the source side to four explicit Cartan containment
directions plus one target-rank bridge:

* `surjectivity_source <= CartanH8`;
* `CartanH8 <= surjectivity_source`;
* `compactDual <= CartanH8`;
* `CartanH8 <= compactDual`;
* `finrank target_invariants = shimuraEVIIExpectedBetti 8`.

This file records the negative interface audit for the last item.  The
four carrier containments can all hold in the current abstract
Matsushima interface while `target_invariants` has rank two, not the
expected EVII degree-8 rank one.  Therefore the remaining target rank
must come from concrete EVII cohomology/Matsushima data, not from the
carrier containment algebra alone.
-/

import HodgeReduction.HCGapL4.FrontC35_SourceCartanContainments

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC36_TargetBettiObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic
open FrontC11_ShimuraBettiComputation

/-- One-dimensional source for the target-rank obstruction. -/
def TargetBettiSource := Rat

/-- Two-dimensional target, allowing `target_invariants` to have rank 2. -/
def TargetBettiTarget := Prod Rat Rat

instance : CommRing TargetBettiSource := inferInstanceAs (CommRing Rat)
instance : Algebra Rat TargetBettiSource := inferInstanceAs (Algebra Rat Rat)
instance : AddCommGroup TargetBettiSource := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat TargetBettiSource := inferInstanceAs (Module Rat Rat)
instance : AddCommGroup TargetBettiTarget := inferInstanceAs (AddCommGroup (Prod Rat Rat))
instance : Module Rat TargetBettiTarget := inferInstanceAs (Module Rat (Prod Rat Rat))

/-- Inject the source line into the first coordinate of the target. -/
def targetBettiFirstCoordinateMap :
    TargetBettiSource →ₗ[Rat] TargetBettiTarget where
  toFun x := (x, 0)
  map_add' := by
    intro x y
    change
      (((x + y), 0) : Prod Rat Rat) =
        ((x, 0) : Prod Rat Rat) + ((y, 0) : Prod Rat Rat)
    ext <;> simp
  map_smul' := by
    intro r x
    change
      (((r • x), 0) : Prod Rat Rat) =
        r • ((x, 0) : Prod Rat Rat)
    ext <;> simp

noncomputable instance instCohomologyRingTargetBettiSource :
    CohomologyRing TargetBettiSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassTargetBettiSource :
    KaehlerClass TargetBettiSource where
  h := (1 : TargetBettiSource)
  h_isAlgebraic := by
    change (1 : TargetBettiSource) ∈
      (⊤ : Subalgebra Rat TargetBettiSource)
    trivial
  h_pow_4_ne_zero := by
    change (1 : Rat) ^ 4 ≠ 0
    norm_num

noncomputable instance instCompactDualDataTargetBettiSource :
    CompactDualData TargetBettiSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : TargetBettiSource) ^ 4)} : Set TargetBettiSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoTargetBettiSource :
    CartanCompactDualIso TargetBettiSource where
  trivialModuleGK_H8 := CompactDualData.H8 (A := TargetBettiSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataTargetBettiObstruction :
    MatsushimaData TargetBettiSource TargetBettiTarget where
  j_q := targetBettiFirstCoordinateMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact congrArg Prod.fst hxy
  source_invariants := CompactDualData.H8 (A := TargetBettiSource)
  target_invariants := ⊤
  j_q_maps_invariants_to_invariants := by
    intro _ _
    trivial
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaSurjectivityDataTargetBettiObstruction :
    MatsushimaSurjectivityData TargetBettiSource TargetBettiTarget where
  surjectivity_source := CompactDualData.H8 (A := TargetBettiSource)
  surjectivity_target :=
    Submodule.map
      (targetBettiFirstCoordinateMap)
      (CompactDualData.H8 (A := TargetBettiSource))
  surjectivity_eq := rfl

noncomputable instance instMatsushimaCompactDualDataTargetBettiObstruction :
    MatsushimaCompactDualData TargetBettiSource TargetBettiTarget where
  compactDual := CompactDualData.H8 (A := TargetBettiSource)
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataTargetBettiObstruction :
    CuspidalCohomologyData TargetBettiTarget where
  cuspidalSubspace := ⊤
  trivialModulePart := ⊤
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8TargetBettiObstruction :
    EisensteinVanishingDeg8 TargetBettiSource TargetBettiTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8TargetBettiObstruction :
    CuspidalGInvariantTrivialModuleDeg8 TargetBettiSource TargetBettiTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change
      (x ∈ (⊤ : Submodule Rat TargetBettiTarget) ∧
          x ∈ (⊤ : Submodule Rat TargetBettiTarget)) ↔
        x ∈ (⊤ : Submodule Rat TargetBettiTarget)
    simp

/-- **R577 obstruction theorem (1/4)**: in the countermodel the
source-side Cartan containments both hold. -/
theorem counterexample_source_cartan_containments :
    (LE.le
      (MatsushimaSurjectivityData.surjectivity_source
        (A := TargetBettiSource) (B := TargetBettiTarget))
      (CartanCompactDualIso.trivialModuleGK_H8
        (A := TargetBettiSource))) ∧
    (LE.le
      (CartanCompactDualIso.trivialModuleGK_H8
        (A := TargetBettiSource))
      (MatsushimaSurjectivityData.surjectivity_source
        (A := TargetBettiSource) (B := TargetBettiTarget))) := by
  exact ⟨le_rfl, le_rfl⟩

/-- **R577 obstruction theorem (2/4)**: in the countermodel the
compactDual-side Cartan containments both hold. -/
theorem counterexample_compactDual_cartan_containments :
    (LE.le
      (MatsushimaCompactDualData.compactDual
        (A := TargetBettiSource) (B := TargetBettiTarget))
      (CartanCompactDualIso.trivialModuleGK_H8
        (A := TargetBettiSource))) ∧
    (LE.le
      (CartanCompactDualIso.trivialModuleGK_H8
        (A := TargetBettiSource))
      (MatsushimaCompactDualData.compactDual
        (A := TargetBettiSource) (B := TargetBettiTarget))) := by
  exact ⟨le_rfl, le_rfl⟩

/-- **R577 obstruction theorem (3/4)**: nevertheless the target
invariant rank is not the expected EVII degree-8 Betti slot. -/
theorem counterexample_target_expected_betti8_not_forced :
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget)) ≠
      shimuraEVIIExpectedBetti 8 := by
  change Module.finrank (R := Rat) (⊤ : Submodule Rat TargetBettiTarget) ≠ 1
  simp [TargetBettiTarget]

/-- **R577 obstruction theorem (4/4)**: the current abstract interface
plus all four R576 carrier containments does not force the remaining
target expected-Betti bridge. -/
theorem current_interface_with_four_cartan_containments_does_not_force_target_expected_betti8 :
    ((LE.le
        (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget))
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))) ∧
      (LE.le
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))
        (MatsushimaSurjectivityData.surjectivity_source
          (A := TargetBettiSource) (B := TargetBettiTarget))) ∧
      (LE.le
        (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget))
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))) ∧
      (LE.le
        (CartanCompactDualIso.trivialModuleGK_H8
          (A := TargetBettiSource))
        (MatsushimaCompactDualData.compactDual
          (A := TargetBettiSource) (B := TargetBettiTarget)))) ∧
    Module.finrank (R := Rat)
        (MatsushimaData.target_invariants
          (A := TargetBettiSource) (B := TargetBettiTarget)) ≠
      shimuraEVIIExpectedBetti 8 := by
  exact
    ⟨⟨counterexample_source_cartan_containments.1,
        counterexample_source_cartan_containments.2,
        counterexample_compactDual_cartan_containments.1,
        counterexample_compactDual_cartan_containments.2⟩,
      counterexample_target_expected_betti8_not_forced⟩

def R577_substantiveTheoremCount : Nat := 4

end FrontC36_TargetBettiObstruction
end HCGapL4
end HodgeReduction
