/-
# HC Gap L4 — minimal internal product carrier `ℙ¹ × ℙ¹` (R227).

R209 / R224 built minimal product carriers for `pt × E` and `pt × ℙ¹`.
R227 builds the corresponding minimum carrier for `ℙ¹ × ℙ¹`, the
product needed for a `ℙ¹ → ℙ¹` self-correspondence factory instance
with cycle provenance.

This is a **toy internal model** — we do NOT model the full
H^*(ℙ¹ × ℙ¹) (which has `H^2 = ℚ²` for two divisor generators and
`H^4 = ℚ` for the top class). The internal carrier mirrors the
pt × ℙ¹ structure (`H^0 = ℚ`, `H^1 = PUnit`, `H^2 = ℚ`, `H^k = PUnit`
for `k ≥ 3`), which is sufficient for a single codim-1 cycle-class
generator.

## What R227 (this file) provides (all kernel-pure)

* `VarietyCohomologyData_projectiveLineSelf` — minimal internal product
  VCD for `ℙ¹ × ℙ¹`.
* `projectiveLineSelfCycleClassFamily` — cycle family with generators
  at codim 0 (fundamental class) and codim 1 (representative divisor).
* `AlgebraicClassesData_projectiveLineSelf` — via `ofCycleClassFamily`.

## What R227 (this file) does NOT do

* It does NOT implement a true `ℙ¹ × ℙ¹` Künneth decomposition
  (`H^2 = ℚ²`). The internal model truncates to a single H^2 generator.
* It does NOT implement a real scheme product.
* It does NOT define the action or factory instance (those live in
  the sibling file `ProductCycleFactoryProjectiveLineSelf.lean`).

All R227 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL4.CycleClassPresentation
import Mathlib.Algebra.PUnitInstances.Module
import Mathlib.Algebra.DirectSum.Module

namespace HodgeReduction
namespace HCGapL4
namespace ProductCohomologyProjectiveLineSelf

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.CycleClassPresentation

/-! ## Section 1: cohomology carrier for `ℙ¹ × ℙ¹` (toy internal model)

Mirrors `pt × ℙ¹` structure for kernel-pure provenance purposes
(NOT the true Künneth decomposition). -/

def cohomologyType_projectiveLineSelf : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_projectiveLineSelf_zero :
    cohomologyType_projectiveLineSelf 0 = ℚ := rfl

@[simp] theorem cohomologyType_projectiveLineSelf_one :
    cohomologyType_projectiveLineSelf 1 = PUnit := rfl

@[simp] theorem cohomologyType_projectiveLineSelf_two :
    cohomologyType_projectiveLineSelf 2 = ℚ := rfl

@[simp] theorem cohomologyType_projectiveLineSelf_three_or_more (k : ℕ) :
    cohomologyType_projectiveLineSelf (k + 3) = PUnit := rfl

theorem cohomologyType_projectiveLineSelf_support {k : ℕ}
    (hk : k ≠ 0 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_projectiveLineSelf k) := by
  rcases hk with ⟨hk0, hk2⟩
  match k, hk0, hk2 with
  | 0, h0, _ => exact absurd rfl h0
  | 1, _, _ => exact inferInstanceAs (Subsingleton PUnit)
  | 2, _, h2 => exact absurd rfl h2
  | k + 3, _, _ => exact inferInstanceAs (Subsingleton PUnit)

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_projectiveLineSelf k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_projectiveLineSelf k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_projectiveLineSelf k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

/-- **R227 Hodge structure REUSE**: same Hodge instances as R202 ℙ¹
(and R224 pt × ℙ¹). -/
noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_projectiveLineSelf k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R227 product VCD**: minimal internal cohomology bundle for `ℙ¹ × ℙ¹`. -/
noncomputable def VarietyCohomologyData_projectiveLineSelf :
    VarietyCohomologyData where
  H := cohomologyType_projectiveLineSelf
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## Section 2: scoped typeclass instances -/

noncomputable instance acg_projectiveLineSelf_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_projectiveLineSelf.H k) :=
  VarietyCohomologyData_projectiveLineSelf.addCommGroup k

noncomputable instance mod_projectiveLineSelf_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_projectiveLineSelf.H k) :=
  VarietyCohomologyData_projectiveLineSelf.module k

/-! ## Section 3: cycle family for `ℙ¹ × ℙ¹` (toy internal model)

Generators:
* codim 0: `[ℙ¹ × ℙ¹] = 1 ∈ H^0 = ℚ` (fundamental class of the product).
* codim 1: `1 ∈ H^2 = ℚ` (representative divisor class — the toy model
  carries one generator instead of the true two `[ℙ¹×pt]` and `[pt×ℙ¹]`).
* codim `p ≥ 2`: no generators (PEmpty). -/

def projectiveLineSelfGenIndex : ℕ → Type
  | 0     => Unit
  | 1     => Unit
  | _ + 2 => PEmpty

noncomputable def projectiveLineSelfCycleClass :
    ∀ p, projectiveLineSelfGenIndex p →
      VarietyCohomologyData_projectiveLineSelf.H (2 * p)
  | 0     => fun _ => (1 : ℚ)
  | 1     => fun _ => (1 : ℚ)
  | _ + 2 => fun g => PEmpty.elim g

theorem projectiveLineSelfCycleClass_isHodge :
    ∀ p (g : projectiveLineSelfGenIndex p),
      projectiveLineSelfCycleClass p g ∈
        VarietyCohomologyData_projectiveLineSelf.hodgeClassesAtDegree p
  | 0     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_projectiveLineSelf.hodgeClassesAtDegree 0
    show (1 : ℚ) ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  | 1     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_projectiveLineSelf.hodgeClassesAtDegree 1
    show (1 : ℚ) ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact Submodule.mem_top
  | _ + 2 => fun g => PEmpty.elim g

/-- **R227 product cycle family for `ℙ¹ × ℙ¹`** (toy internal model). -/
noncomputable def projectiveLineSelfCycleClassFamily :
    CycleClassFamily VarietyCohomologyData_projectiveLineSelf where
  GenIndex := projectiveLineSelfGenIndex
  cycleClass := projectiveLineSelfCycleClass
  cycleClass_isHodge := projectiveLineSelfCycleClass_isHodge

/-! ## Section 4: product `AlgebraicClassesData` via `ofCycleClassFamily` -/

/-- **R227 product ACD** for `ℙ¹ × ℙ¹` derived from the cycle family. -/
noncomputable def AlgebraicClassesData_projectiveLineSelf :
    AlgebraicClassesData VarietyCohomologyData_projectiveLineSelf :=
  AlgebraicClassesData.ofCycleClassFamily
    projectiveLineSelfCycleClassFamily

end ProductCohomologyProjectiveLineSelf
end HCGapL4
end HodgeReduction
