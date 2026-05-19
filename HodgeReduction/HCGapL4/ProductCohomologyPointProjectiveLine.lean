/-
# HC Gap L4 — internal product cohomology model `pt × ℙ¹` (R224).

R209 built the minimum product carrier for `pt × E`. R224 builds the
analogous minimum product carrier for `pt × ℙ¹`, the second concrete
internal product needed to demonstrate the R223 product-cycle
provenance factory is not specialised to the elliptic-curve example.

Geometrically `pt × ℙ¹ ≃ ℙ¹`, so the cohomology agrees with `ℙ¹`'s
degree-by-degree; this allows REUSE of R202's kernel-pure ℙ¹ Hodge
structures while exhibiting a Lean-level SEPARATE
`VarietyCohomologyData` and `CycleClassFamily` specifically labelled
as "the pt × ℙ¹ product carrier".

## What R224 (this file) provides (all kernel-pure)

* `VarietyCohomologyData_pointTimesProjectiveLine` — internal product
  VCD mirroring ℙ¹: `H^0 = ℚ`, `H^1 = PUnit`, `H^2 = ℚ`,
  `H^k = PUnit` for `k ≥ 3`.
* Hodge structures REUSED from R202's ℙ¹ Hodge instances.
* A `CycleClassFamily` for `pt × ℙ¹` with `[pt × ℙ¹] ∈ H^0` and
  `[pt × pt_of_ℙ¹] ∈ H^2` generators.
* `AlgebraicClassesData_pointTimesProjectiveLine` via
  `ofCycleClassFamily`.

## What R224 (this file) does NOT do

* It does NOT implement a general Künneth theorem.
* It does NOT implement a real scheme-level product.
* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT define the cycle-induced action or factory instance
  (those are in the sibling file `PtToProjectiveLineProductCycleFactory.lean`).

All R224 declarations are kernel-pure: `{propext, Classical.choice,
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
namespace ProductCohomologyPointProjectiveLine

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.CycleClassPresentation

/-! ## Section 1: cohomology carrier for `pt × ℙ¹`

Geometrically `pt × ℙ¹ ≃ ℙ¹`. Mirror ℙ¹'s internal model. -/

/-- Internal cohomology carrier for `pt × ℙ¹`:
* `H^0 = ℚ`, `H^1 = PUnit`, `H^2 = ℚ`, `H^k = PUnit` for `k ≥ 3`. -/
def cohomologyType_pointTimesProjectiveLine : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_pointTimesProjectiveLine_zero :
    cohomologyType_pointTimesProjectiveLine 0 = ℚ := rfl

@[simp] theorem cohomologyType_pointTimesProjectiveLine_one :
    cohomologyType_pointTimesProjectiveLine 1 = PUnit := rfl

@[simp] theorem cohomologyType_pointTimesProjectiveLine_two :
    cohomologyType_pointTimesProjectiveLine 2 = ℚ := rfl

@[simp] theorem cohomologyType_pointTimesProjectiveLine_three_or_more (k : ℕ) :
    cohomologyType_pointTimesProjectiveLine (k + 3) = PUnit := rfl

theorem cohomologyType_pointTimesProjectiveLine_support {k : ℕ}
    (hk : k ≠ 0 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_pointTimesProjectiveLine k) := by
  rcases hk with ⟨hk0, hk2⟩
  match k, hk0, hk2 with
  | 0, h0, _ => exact absurd rfl h0
  | 1, _, _ => exact inferInstanceAs (Subsingleton PUnit)
  | 2, _, h2 => exact absurd rfl h2
  | k + 3, _, _ => exact inferInstanceAs (Subsingleton PUnit)

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_pointTimesProjectiveLine k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_pointTimesProjectiveLine k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_pointTimesProjectiveLine k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

/-- **R224 Hodge structure REUSE**: at each `k`, the Hodge structure
on `H^k(pt × ℙ¹)` is exactly the same instance as on `H^k(ℙ¹)`. -/
noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_pointTimesProjectiveLine k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R224 product VCD**: the internal cohomology bundle for `pt × ℙ¹`. -/
noncomputable def VarietyCohomologyData_pointTimesProjectiveLine :
    VarietyCohomologyData where
  H := cohomologyType_pointTimesProjectiveLine
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## Section 2: scoped typeclass instances -/

noncomputable instance acg_pointTimesProjectiveLine_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_pointTimesProjectiveLine.H k) :=
  VarietyCohomologyData_pointTimesProjectiveLine.addCommGroup k

noncomputable instance mod_pointTimesProjectiveLine_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_pointTimesProjectiveLine.H k) :=
  VarietyCohomologyData_pointTimesProjectiveLine.module k

/-! ## Section 3: cycle family for `pt × ℙ¹`

Generators:
* codim 0: `[pt × ℙ¹] = 1 ∈ H^0 = ℚ` (fundamental class of the product).
* codim 1: `[pt × pt_of_ℙ¹] = 1 ∈ H^2 = ℚ` (the "point on ℙ¹" class).
* codim `p ≥ 2`: no generators (PEmpty), since `pt × ℙ¹` is 1-dim. -/

def pointTimesProjectiveLineGenIndex : ℕ → Type
  | 0     => Unit
  | 1     => Unit
  | _ + 2 => PEmpty

noncomputable def pointTimesProjectiveLineCycleClass :
    ∀ p, pointTimesProjectiveLineGenIndex p →
      VarietyCohomologyData_pointTimesProjectiveLine.H (2 * p)
  | 0     => fun _ => (1 : ℚ)
  | 1     => fun _ => (1 : ℚ)
  | _ + 2 => fun g => PEmpty.elim g

theorem pointTimesProjectiveLineCycleClass_isHodge :
    ∀ p (g : pointTimesProjectiveLineGenIndex p),
      pointTimesProjectiveLineCycleClass p g ∈
        VarietyCohomologyData_pointTimesProjectiveLine.hodgeClassesAtDegree p
  | 0     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_pointTimesProjectiveLine.hodgeClassesAtDegree 0
    show (1 : ℚ) ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  | 1     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_pointTimesProjectiveLine.hodgeClassesAtDegree 1
    show (1 : ℚ) ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact Submodule.mem_top
  | _ + 2 => fun g => PEmpty.elim g

/-- **R224 product cycle family for `pt × ℙ¹`**. -/
noncomputable def pointTimesProjectiveLineCycleClassFamily :
    CycleClassFamily VarietyCohomologyData_pointTimesProjectiveLine where
  GenIndex := pointTimesProjectiveLineGenIndex
  cycleClass := pointTimesProjectiveLineCycleClass
  cycleClass_isHodge := pointTimesProjectiveLineCycleClass_isHodge

/-! ## Section 4: product `AlgebraicClassesData` via `ofCycleClassFamily` -/

/-- **R224 product ACD**: derived from the product cycle family via
the R207 `ofCycleClassFamily` constructor. -/
noncomputable def AlgebraicClassesData_pointTimesProjectiveLine :
    AlgebraicClassesData VarietyCohomologyData_pointTimesProjectiveLine :=
  AlgebraicClassesData.ofCycleClassFamily
    pointTimesProjectiveLineCycleClassFamily

end ProductCohomologyPointProjectiveLine
end HCGapL4
end HodgeReduction
