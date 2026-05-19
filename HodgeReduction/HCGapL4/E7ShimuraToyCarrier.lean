/-
# HC Gap L4 — minimal TOY E_7-Shimura-shaped carrier (R229).

R229 builds a TOY internal carrier whose `VarietyCohomologyData`
shape mirrors the position that `canonicalE7ShimuraTor` occupies in
the headline reduction at codim 1, **without** claiming any genuine
relationship to a real E_7 Shimura variety.

The carrier is identical in shape to R202's projective-line internal
model: `H^0 = ℚ`, `H^1 = PUnit`, `H^2 = ℚ`, `H^k = PUnit` for `k ≥ 3`,
with Tate-style Hodge structures. The naming is deliberately marked
`Toy` everywhere.

## Hard naming rule

Every public name in this file contains `Toy` or `InternalToy`. This
carrier is **NOT** the real E_7 Shimura variety — it is a kernel-pure
internal toy whose only role is to exercise the R223–R228 factory
chain pattern at a position structurally analogous to the headline
axiom.

## What R229 (this file) provides (all kernel-pure)

* `VarietyCohomologyData_E7ShimuraToy` — minimal Tate-style toy VCD.
* `algClasses_E7ShimuraToy` — codim-by-codim algebraic classes
  (codim 0 / 1 = ⊤, codim ≥ 2 = ⊥).
* `AlgebraicClassesData_E7ShimuraToy` — the bundle.

## What R229 (this file) does NOT do

* It does NOT model the real E_7 Shimura variety's cohomology
  (`H^*(canonicalE7ShimuraTor.varietyData)` is 56-dim at the
  generic-fiber Hodge structure level, not toy-Tate).
* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT define the action or factory instance (those live in
  the sibling files).

All R229 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import Mathlib.Algebra.PUnitInstances.Module

namespace HodgeReduction
namespace HCGapL4
namespace E7ShimuraToyCarrier

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2

/-! ## Section 1: cohomology carrier (Tate-style toy)

`H^0 = ℚ`, `H^1 = PUnit`, `H^2 = ℚ`, `H^k = PUnit` for `k ≥ 3`. -/

def cohomologyType_E7ShimuraToy : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_E7ShimuraToy_zero :
    cohomologyType_E7ShimuraToy 0 = ℚ := rfl

@[simp] theorem cohomologyType_E7ShimuraToy_one :
    cohomologyType_E7ShimuraToy 1 = PUnit := rfl

@[simp] theorem cohomologyType_E7ShimuraToy_two :
    cohomologyType_E7ShimuraToy 2 = ℚ := rfl

@[simp] theorem cohomologyType_E7ShimuraToy_three_or_more (k : ℕ) :
    cohomologyType_E7ShimuraToy (k + 3) = PUnit := rfl

theorem cohomologyType_E7ShimuraToy_support {k : ℕ}
    (hk : k ≠ 0 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_E7ShimuraToy k) := by
  rcases hk with ⟨hk0, hk2⟩
  match k, hk0, hk2 with
  | 0, h0, _ => exact absurd rfl h0
  | 1, _, _ => exact inferInstanceAs (Subsingleton PUnit)
  | 2, _, h2 => exact absurd rfl h2
  | k + 3, _, _ => exact inferInstanceAs (Subsingleton PUnit)

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_E7ShimuraToy k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_E7ShimuraToy k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_E7ShimuraToy k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

/-- **R229 Hodge structure REUSE** (Tate-style at H^0 and H^2). -/
noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_E7ShimuraToy k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R229 toy VCD**: minimal Tate-style cohomology bundle for the toy
E_7-Shimura-shaped carrier. -/
noncomputable def VarietyCohomologyData_E7ShimuraToy :
    VarietyCohomologyData where
  H := cohomologyType_E7ShimuraToy
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## Section 2: scoped typeclass instances -/

noncomputable instance acg_E7ShimuraToy_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_E7ShimuraToy.H k) :=
  VarietyCohomologyData_E7ShimuraToy.addCommGroup k

noncomputable instance mod_E7ShimuraToy_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_E7ShimuraToy.H k) :=
  VarietyCohomologyData_E7ShimuraToy.module k

/-! ## Section 3: algebraic-classes data (codim 0/1 = ⊤, codim ≥ 2 = ⊥) -/

noncomputable def algClasses_E7ShimuraToy :
    ∀ (p : ℕ),
      @Submodule ℚ (VarietyCohomologyData_E7ShimuraToy.H (2 * p)) _
        (VarietyCohomologyData_E7ShimuraToy.addCommGroup (2 * p)).toAddCommMonoid
        (VarietyCohomologyData_E7ShimuraToy.module (2 * p))
  | 0     => ⊤
  | 1     => ⊤
  | _ + 2 => ⊥

theorem algClasses_E7ShimuraToy_le_hodgeClasses_codim0 :
    algClasses_E7ShimuraToy 0 ≤
      VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree 0 := by
  letI _acg := VarietyCohomologyData_E7ShimuraToy.addCommGroup 0
  letI _mod := VarietyCohomologyData_E7ShimuraToy.module 0
  letI _phs := VarietyCohomologyData_E7ShimuraToy.hodgeStructure 0
  intro x _
  show x ∈ VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree 0
  show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
  rw [TrivialWeight.piece_ℚ_w0_zero]
  exact Submodule.mem_top

theorem algClasses_E7ShimuraToy_le_hodgeClasses_codim1 :
    algClasses_E7ShimuraToy 1 ≤
      VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree 1 := by
  letI _acg := VarietyCohomologyData_E7ShimuraToy.addCommGroup 2
  letI _mod := VarietyCohomologyData_E7ShimuraToy.module 2
  letI _phs := VarietyCohomologyData_E7ShimuraToy.hodgeStructure 2
  intro x _
  show x ∈ VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree 1
  show x ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
  rw [ProjectiveLine.piece_ℚ_Tate2_one]
  exact Submodule.mem_top

theorem algClasses_E7ShimuraToy_le_hodgeClasses_codim_high (p : ℕ) :
    algClasses_E7ShimuraToy (p + 2) ≤
      VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree (p + 2) := by
  intro x hx
  -- algClasses (p+2) = ⊥, so hx : x ∈ ⊥ means x = 0.
  rw [show algClasses_E7ShimuraToy (p + 2) = ⊥ from rfl] at hx
  rw [Submodule.mem_bot] at hx
  rw [hx]
  exact Submodule.zero_mem _

theorem algClasses_E7ShimuraToy_le_hodgeClasses (p : ℕ) :
    algClasses_E7ShimuraToy p ≤
      VarietyCohomologyData_E7ShimuraToy.hodgeClassesAtDegree p := by
  match p with
  | 0 => exact algClasses_E7ShimuraToy_le_hodgeClasses_codim0
  | 1 => exact algClasses_E7ShimuraToy_le_hodgeClasses_codim1
  | k + 2 => exact algClasses_E7ShimuraToy_le_hodgeClasses_codim_high k

/-- **R229 toy ACD**: the algebraic-classes bundle for the toy carrier. -/
noncomputable def AlgebraicClassesData_E7ShimuraToy :
    AlgebraicClassesData VarietyCohomologyData_E7ShimuraToy where
  algClasses := algClasses_E7ShimuraToy
  algClasses_le_hodgeClasses := algClasses_E7ShimuraToy_le_hodgeClasses

end E7ShimuraToyCarrier
end HCGapL4
end HodgeReduction
