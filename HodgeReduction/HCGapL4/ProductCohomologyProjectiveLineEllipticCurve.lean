/-
# HC Gap L4 — minimal internal product carrier `ℙ¹ × E` (R228).

R209 / R224 / R227 built minimum product carriers for `pt × E`,
`pt × ℙ¹`, and (toy) `ℙ¹ × ℙ¹`. R228 builds the corresponding minimum
carrier for `ℙ¹ × E`, needed for the cross-variety `ℙ¹ → E` factory
instance with cycle provenance.

This is a **toy internal model** — we do NOT model the full
H^*(ℙ¹ × E) (which has `H^1 = ℚ²` from E's H^1 lifted, `H^2 = ℚ²`
from two divisor classes, `H^3 = ℚ²`, `H^4 = ℚ`). The internal carrier
mirrors the `pt × ℙ¹` / `pt × E` shape (`H^0 = ℚ`, `H^1 = PUnit`,
`H^2 = ℚ`, `H^k = PUnit` for `k ≥ 3`), which is sufficient for a single
codim-1 cycle-class generator.

## What R228 (this file) provides (all kernel-pure)

* `VarietyCohomologyData_projectiveLineTimesEllipticCurve` — minimal
  internal product VCD.
* `projectiveLineTimesEllipticCurveCycleClassFamily` — cycle family
  with generators at codim 0 and codim 1.
* `AlgebraicClassesData_projectiveLineTimesEllipticCurve` — via
  `ofCycleClassFamily`.

## What R228 (this file) does NOT do

* It does NOT implement a true `ℙ¹ × E` Künneth decomposition
  (real H^1 from E, real H^2 = ℚ², etc.).
* It does NOT implement a real scheme product.
* It does NOT define the action or factory instance (those live in
  the sibling file `ProductCycleFactoryProjectiveLineToEllipticCurve.lean`).

All R228 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.CycleClassPresentation
import Mathlib.Algebra.PUnitInstances.Module
import Mathlib.Algebra.DirectSum.Module

namespace HodgeReduction
namespace HCGapL4
namespace ProductCohomologyProjectiveLineEllipticCurve

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.CycleClassPresentation

/-! ## Section 1: cohomology carrier for `ℙ¹ × E` (toy internal model)

Mirrors the `pt × ℙ¹` / `pt × E` minimal shape. Does NOT capture the
true `H^1 = ℚ²` (from E) or `H^2 = ℚ²` (two divisors). -/

def cohomologyType_projectiveLineTimesEllipticCurve : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_projectiveLineTimesEllipticCurve_zero :
    cohomologyType_projectiveLineTimesEllipticCurve 0 = ℚ := rfl

@[simp] theorem cohomologyType_projectiveLineTimesEllipticCurve_one :
    cohomologyType_projectiveLineTimesEllipticCurve 1 = PUnit := rfl

@[simp] theorem cohomologyType_projectiveLineTimesEllipticCurve_two :
    cohomologyType_projectiveLineTimesEllipticCurve 2 = ℚ := rfl

@[simp] theorem cohomologyType_projectiveLineTimesEllipticCurve_three_or_more (k : ℕ) :
    cohomologyType_projectiveLineTimesEllipticCurve (k + 3) = PUnit := rfl

theorem cohomologyType_projectiveLineTimesEllipticCurve_support {k : ℕ}
    (hk : k ≠ 0 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_projectiveLineTimesEllipticCurve k) := by
  rcases hk with ⟨hk0, hk2⟩
  match k, hk0, hk2 with
  | 0, h0, _ => exact absurd rfl h0
  | 1, _, _ => exact inferInstanceAs (Subsingleton PUnit)
  | 2, _, h2 => exact absurd rfl h2
  | k + 3, _, _ => exact inferInstanceAs (Subsingleton PUnit)

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_projectiveLineTimesEllipticCurve k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_projectiveLineTimesEllipticCurve k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ
           (cohomologyType_projectiveLineTimesEllipticCurve k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

/-- **R228 Hodge structure REUSE**: same instance pattern as R227. -/
noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure
           (cohomologyType_projectiveLineTimesEllipticCurve k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R228 product VCD**: minimal internal cohomology bundle for `ℙ¹ × E`. -/
noncomputable def VarietyCohomologyData_projectiveLineTimesEllipticCurve :
    VarietyCohomologyData where
  H := cohomologyType_projectiveLineTimesEllipticCurve
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## Section 2: scoped typeclass instances -/

noncomputable instance acg_projectiveLineTimesEllipticCurve_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_projectiveLineTimesEllipticCurve.H k) :=
  VarietyCohomologyData_projectiveLineTimesEllipticCurve.addCommGroup k

noncomputable instance mod_projectiveLineTimesEllipticCurve_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_projectiveLineTimesEllipticCurve.H k) :=
  VarietyCohomologyData_projectiveLineTimesEllipticCurve.module k

/-! ## Section 3: cycle family for `ℙ¹ × E` (toy internal model)

Generators:
* codim 0: fundamental class `1 ∈ H^0 = ℚ`.
* codim 1: representative divisor class `1 ∈ H^2 = ℚ` (toy generator;
  real `ℙ¹ × E` has two H^2 generators `[ℙ¹×pt_E]` and `[pt×E]`).
* codim `p ≥ 2`: PEmpty. -/

def projectiveLineTimesEllipticCurveGenIndex : ℕ → Type
  | 0     => Unit
  | 1     => Unit
  | _ + 2 => PEmpty

noncomputable def projectiveLineTimesEllipticCurveCycleClass :
    ∀ p, projectiveLineTimesEllipticCurveGenIndex p →
      VarietyCohomologyData_projectiveLineTimesEllipticCurve.H (2 * p)
  | 0     => fun _ => (1 : ℚ)
  | 1     => fun _ => (1 : ℚ)
  | _ + 2 => fun g => PEmpty.elim g

theorem projectiveLineTimesEllipticCurveCycleClass_isHodge :
    ∀ p (g : projectiveLineTimesEllipticCurveGenIndex p),
      projectiveLineTimesEllipticCurveCycleClass p g ∈
        VarietyCohomologyData_projectiveLineTimesEllipticCurve.hodgeClassesAtDegree p
  | 0     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_projectiveLineTimesEllipticCurve.hodgeClassesAtDegree 0
    show (1 : ℚ) ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  | 1     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_projectiveLineTimesEllipticCurve.hodgeClassesAtDegree 1
    show (1 : ℚ) ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact Submodule.mem_top
  | _ + 2 => fun g => PEmpty.elim g

/-- **R228 product cycle family for `ℙ¹ × E`** (toy internal model). -/
noncomputable def projectiveLineTimesEllipticCurveCycleClassFamily :
    CycleClassFamily VarietyCohomologyData_projectiveLineTimesEllipticCurve where
  GenIndex := projectiveLineTimesEllipticCurveGenIndex
  cycleClass := projectiveLineTimesEllipticCurveCycleClass
  cycleClass_isHodge := projectiveLineTimesEllipticCurveCycleClass_isHodge

/-! ## Section 4: product `AlgebraicClassesData` via `ofCycleClassFamily` -/

/-- **R228 product ACD** for `ℙ¹ × E` from the cycle family. -/
noncomputable def AlgebraicClassesData_projectiveLineTimesEllipticCurve :
    AlgebraicClassesData VarietyCohomologyData_projectiveLineTimesEllipticCurve :=
  AlgebraicClassesData.ofCycleClassFamily
    projectiveLineTimesEllipticCurveCycleClassFamily

end ProductCohomologyProjectiveLineEllipticCurve
end HCGapL4
end HodgeReduction
