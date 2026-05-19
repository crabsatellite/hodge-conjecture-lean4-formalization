/-
# HC Gap L4 — minimal TOY product carrier `pt × E7ShimuraToy` (R229).

Sibling to R229's `E7ShimuraToyCarrier.lean`. Builds the minimal
toy product carrier needed for a codim-1 cycle provenance on a
factory whose target is `E7ShimuraToy`.

## Hard naming rule

Every public name contains `Toy`. The product is a kernel-pure
internal model only.

## What this file provides (all kernel-pure)

* `VarietyCohomologyData_pointTimesE7ShimuraToy` — minimal toy
  product VCD mirroring pt × ℙ¹ / pt × E shape.
* `pointTimesE7ShimuraToyCycleClassFamily` — cycle family with
  generators at codim 0 (fundamental) and codim 1 (representative).
* `AlgebraicClassesData_pointTimesE7ShimuraToy` — via
  `ofCycleClassFamily`.

## What this file does NOT do

* Does NOT model a real scheme product `Spec ℂ × canonicalE7ShimuraTor`.
* Does NOT claim the toy `(1 : ℚ)` cycle equals any specific real
  algebraic cycle on the E_7 Shimura side.

All declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL4.CycleClassPresentation
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import Mathlib.Algebra.PUnitInstances.Module

namespace HodgeReduction
namespace HCGapL4
namespace ProductCohomologyPointTimesE7ShimuraToy

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.CycleClassPresentation
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier

/-! ## Section 1: cohomology carrier (toy internal model) -/

def cohomologyType_pointTimesE7ShimuraToy : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_pointTimesE7ShimuraToy_zero :
    cohomologyType_pointTimesE7ShimuraToy 0 = ℚ := rfl

@[simp] theorem cohomologyType_pointTimesE7ShimuraToy_two :
    cohomologyType_pointTimesE7ShimuraToy 2 = ℚ := rfl

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_pointTimesE7ShimuraToy k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_pointTimesE7ShimuraToy k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_pointTimesE7ShimuraToy k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_pointTimesE7ShimuraToy k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R229 toy product VCD** for `pt × E7ShimuraToy`. -/
noncomputable def VarietyCohomologyData_pointTimesE7ShimuraToy :
    VarietyCohomologyData where
  H := cohomologyType_pointTimesE7ShimuraToy
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## Section 2: scoped typeclass instances -/

noncomputable instance acg_pointTimesE7ShimuraToy_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_pointTimesE7ShimuraToy.H k) :=
  VarietyCohomologyData_pointTimesE7ShimuraToy.addCommGroup k

noncomputable instance mod_pointTimesE7ShimuraToy_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_pointTimesE7ShimuraToy.H k) :=
  VarietyCohomologyData_pointTimesE7ShimuraToy.module k

/-! ## Section 3: cycle family for the toy product (codim 0 and codim 1) -/

def pointTimesE7ShimuraToyGenIndex : ℕ → Type
  | 0     => Unit
  | 1     => Unit
  | _ + 2 => PEmpty

noncomputable def pointTimesE7ShimuraToyCycleClass :
    ∀ p, pointTimesE7ShimuraToyGenIndex p →
      VarietyCohomologyData_pointTimesE7ShimuraToy.H (2 * p)
  | 0     => fun _ => (1 : ℚ)
  | 1     => fun _ => (1 : ℚ)
  | _ + 2 => fun g => PEmpty.elim g

theorem pointTimesE7ShimuraToyCycleClass_isHodge :
    ∀ p (g : pointTimesE7ShimuraToyGenIndex p),
      pointTimesE7ShimuraToyCycleClass p g ∈
        VarietyCohomologyData_pointTimesE7ShimuraToy.hodgeClassesAtDegree p
  | 0     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_pointTimesE7ShimuraToy.hodgeClassesAtDegree 0
    show (1 : ℚ) ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  | 1     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_pointTimesE7ShimuraToy.hodgeClassesAtDegree 1
    show (1 : ℚ) ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact Submodule.mem_top
  | _ + 2 => fun g => PEmpty.elim g

/-- **R229 toy product cycle family for `pt × E7ShimuraToy`**. -/
noncomputable def pointTimesE7ShimuraToyCycleClassFamily :
    CycleClassFamily VarietyCohomologyData_pointTimesE7ShimuraToy where
  GenIndex := pointTimesE7ShimuraToyGenIndex
  cycleClass := pointTimesE7ShimuraToyCycleClass
  cycleClass_isHodge := pointTimesE7ShimuraToyCycleClass_isHodge

/-! ## Section 4: ACD via `ofCycleClassFamily` -/

/-- **R229 toy product ACD** via `ofCycleClassFamily`. -/
noncomputable def AlgebraicClassesData_pointTimesE7ShimuraToy :
    AlgebraicClassesData VarietyCohomologyData_pointTimesE7ShimuraToy :=
  AlgebraicClassesData.ofCycleClassFamily
    pointTimesE7ShimuraToyCycleClassFamily

end ProductCohomologyPointTimesE7ShimuraToy
end HCGapL4
end HodgeReduction
