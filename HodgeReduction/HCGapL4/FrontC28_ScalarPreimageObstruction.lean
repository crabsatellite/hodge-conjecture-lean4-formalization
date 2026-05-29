/-
# HC Gap L4 -- Front C28: scalar-preimage obstruction (R569).

R568 sharpened the third Cartan-line exactness target to scalar
surjectivity:

  every `beta` in `trivialModulePart` is `j_q (r • h^4)`.

This file records the matching negative audit.  Even if the Matsushima
compact-dual carrier is already identified with Cartan's H8 line, the
current abstract interface does not force scalar surjectivity onto the
trivial-module part.  The countermodel maps a one-dimensional Cartan line
into the first coordinate of a two-dimensional target while declaring the
trivial-module part to be the full target.

This is not a reset.  It prevents a fake closure: the remaining surjectivity
must come from concrete EVII Matsushima/Cartan geometry, not from the current
typeclass fields.
-/

import HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage

set_option linter.dupNamespace false

namespace HodgeReduction
namespace HCGapL4
namespace FrontC28_ScalarPreimageObstruction

open HodgeReduction.Infrastructure.Cohomology
open HodgeReduction.Infrastructure.Shimura
open HodgeReduction.Infrastructure.Automorphic

/-- One-dimensional source for the scalar-preimage obstruction. -/
def ScalarPreimageSource := Rat

/-- Two-dimensional target; the Matsushima image lands only in the first
coordinate. -/
def ScalarPreimageTarget := Rat × Rat

instance : CommRing ScalarPreimageSource := inferInstanceAs (CommRing Rat)
instance : Algebra Rat ScalarPreimageSource := inferInstanceAs (Algebra Rat Rat)
instance : AddCommGroup ScalarPreimageSource := inferInstanceAs (AddCommGroup Rat)
instance : Module Rat ScalarPreimageSource := inferInstanceAs (Module Rat Rat)
instance : AddCommGroup ScalarPreimageTarget := inferInstanceAs (AddCommGroup (Rat × Rat))
instance : Module Rat ScalarPreimageTarget := inferInstanceAs (Module Rat (Rat × Rat))

/-- Inject the source line as the first coordinate of the target. -/
def firstCoordinateMap : ScalarPreimageSource →ₗ[Rat] ScalarPreimageTarget where
  toFun x := (x, 0)
  map_add' := by
    intro x y
    change (((x + y), 0) : Rat × Rat) = ((x, 0) : Rat × Rat) + ((y, 0) : Rat × Rat)
    ext <;> simp
  map_smul' := by
    intro r x
    change (((r • x), 0) : Rat × Rat) = r • ((x, 0) : Rat × Rat)
    ext <;> simp

noncomputable instance instCohomologyRingSource :
    CohomologyRing ScalarPreimageSource where
  algebraic := ⊤

noncomputable instance instKaehlerClassSource :
    KaehlerClass ScalarPreimageSource where
  h := (1 : ScalarPreimageSource)
  h_isAlgebraic := by
    change (1 : ScalarPreimageSource) ∈
      (⊤ : Subalgebra Rat ScalarPreimageSource)
    trivial
  h_pow_4_ne_zero := by
    change (1 : Rat) ^ 4 ≠ 0
    norm_num

noncomputable instance instCompactDualDataSource :
    CompactDualData ScalarPreimageSource where
  H8 :=
    Submodule.span Rat
      ({((KaehlerClass.h : ScalarPreimageSource) ^ 4)} :
        Set ScalarPreimageSource)
  H8_eq_span_h_pow_4 := rfl

noncomputable instance instCartanCompactDualIsoSource :
    CartanCompactDualIso ScalarPreimageSource where
  trivialModuleGK_H8 := CompactDualData.H8 (A := ScalarPreimageSource)
  trivialModuleGK_H8_eq_compactDual_H8 := rfl

noncomputable instance instMatsushimaDataScalarObstruction :
    MatsushimaData ScalarPreimageSource ScalarPreimageTarget where
  j_q := firstCoordinateMap
  injective_range := 8
  j_q_injective := by
    intro x y hxy
    exact congrArg Prod.fst hxy
  source_invariants := CompactDualData.H8 (A := ScalarPreimageSource)
  target_invariants := ⊤
  j_q_maps_invariants_to_invariants := by
    intro _ _
    trivial
  c_E7_eq_8_holds := rfl

noncomputable instance instMatsushimaCompactDualDataScalarObstruction :
    MatsushimaCompactDualData ScalarPreimageSource ScalarPreimageTarget where
  compactDual := CompactDualData.H8 (A := ScalarPreimageSource)
  compactDual_eq_source_invariants := rfl

noncomputable instance instCuspidalCohomologyDataScalarObstruction :
    CuspidalCohomologyData ScalarPreimageTarget where
  cuspidalSubspace := ⊤
  trivialModulePart := ⊤
  trivial_le_cuspidal := le_rfl

noncomputable instance instEisensteinVanishingDeg8ScalarObstruction :
    EisensteinVanishingDeg8 ScalarPreimageSource ScalarPreimageTarget where
  target_invariants_eq_cuspidal := rfl

noncomputable instance instCuspidalGInvariantTrivialModuleDeg8ScalarObstruction :
    CuspidalGInvariantTrivialModuleDeg8
      ScalarPreimageSource ScalarPreimageTarget where
  cuspidal_G_invariant_eq_trivial_module := by
    ext x
    change
      (x ∈ (⊤ : Submodule Rat ScalarPreimageTarget) ∧
          x ∈ (⊤ : Submodule Rat ScalarPreimageTarget)) ↔
        x ∈ (⊤ : Submodule Rat ScalarPreimageTarget)
    simp

theorem compactDual_eq_cartan_in_scalar_obstruction :
    MatsushimaCompactDualData.compactDual
        (A := ScalarPreimageSource) (B := ScalarPreimageTarget) =
      CartanCompactDualIso.trivialModuleGK_H8
        (A := ScalarPreimageSource) := rfl

theorem second_axis_mem_trivialModulePart :
    ((0, 1) : ScalarPreimageTarget) ∈
      CuspidalCohomologyData.trivialModulePart
        (A := ScalarPreimageTarget) := by
  trivial

/-- **R569 obstruction theorem (1/2)**: even with `compactDual = Cartan
H8`, the current interface does not force scalar preimage surjectivity. -/
theorem counterexample_no_scalar_preimage_surjectivity :
    ¬
      (∀ beta : ScalarPreimageTarget,
        beta ∈ CuspidalCohomologyData.trivialModulePart
          (A := ScalarPreimageTarget) →
          ∃ r : Rat,
            MatsushimaData.j_q
              (A := ScalarPreimageSource) (B := ScalarPreimageTarget)
              (r • ((KaehlerClass.h : ScalarPreimageSource) ^ 4)) =
              beta) := by
  intro hscalar
  obtain ⟨r, hr⟩ :=
    hscalar ((0, 1) : ScalarPreimageTarget)
      second_axis_mem_trivialModulePart
  have hsnd := congrArg Prod.snd hr
  simp [MatsushimaData.j_q, firstCoordinateMap] at hsnd

/-- **R569 obstruction theorem (2/2)**: the positive compactDual=Cartan
identification and the negative scalar-surjectivity fact can hold
together under the current abstract interfaces. -/
theorem current_interface_with_compactDual_cartan_does_not_force_scalar_preimage :
    (MatsushimaCompactDualData.compactDual
          (A := ScalarPreimageSource) (B := ScalarPreimageTarget) =
        CartanCompactDualIso.trivialModuleGK_H8
          (A := ScalarPreimageSource)) ∧
      ¬
        (∀ beta : ScalarPreimageTarget,
          beta ∈ CuspidalCohomologyData.trivialModulePart
            (A := ScalarPreimageTarget) →
            ∃ r : Rat,
              MatsushimaData.j_q
                (A := ScalarPreimageSource) (B := ScalarPreimageTarget)
                (r • ((KaehlerClass.h : ScalarPreimageSource) ^ 4)) =
                beta) := by
  exact ⟨compactDual_eq_cartan_in_scalar_obstruction,
    counterexample_no_scalar_preimage_surjectivity⟩

def R569_substantiveTheoremCount : Nat := 2

end FrontC28_ScalarPreimageObstruction
end HCGapL4
end HodgeReduction
