/-
# HC Gap L2 — trivial-point case (R201 minimum attack).

Constructive `VarietyCohomologyData` + `AlgebraicClassesData` + `VarietyHC`
for the geometric trivial case: a single point `Spec ℂ` modelled at the
cohomology level. No project axioms, no toy `Polynomial ℚ` carrier, no
definitional trick that sets `algClasses := hodgeClasses`.

The geometric content (cohomology of `Spec ℂ`):
* `H^0(pt, ℚ) = ℚ` with pure Hodge structure of weight 0
  (single piece `H^{0,0} = ℚ`).
* `H^k(pt, ℚ) = 0` for `k > 0` (trivial Hodge structure, encoded as `PUnit`).
* `algClassesPoint 0 := ⊤` (the fundamental class `[pt]` spans `H^0`).
* `algClassesPoint p := ⊥` for `p > 0` (no codim-`p` cycles on a 0-dim
  variety).

This file closes **L2-G1 (trivial-case template)** kernel-purely. The
headline cone of `hodgeConjectureReal_canonical` is **unchanged**: this
file does not import into the canonical case. It supplies a template
for the eventual non-toy E₇ Shimura construction.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import Mathlib.Algebra.PUnitInstances.Module
import Mathlib.LinearAlgebra.DirectSum.Finsupp
import Mathlib.Algebra.DirectSum.Module

namespace HodgeReduction
namespace HCGapL2
namespace TrivialPoint

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## 1. PureHodgeStructure on `PUnit` (every weight) -/

def pieceTrivial (n : ℕ) : Fin (n + 1) → Submodule ℚ PUnit :=
  fun _ => ⊥

theorem iSupIndep_pieceTrivial (n : ℕ) :
    iSupIndep (pieceTrivial n) := by
  intro p
  simp [pieceTrivial, iSupIndep, disjoint_bot_left]

theorem iSup_pieceTrivial_eq_top (n : ℕ) :
    ⨆ i, pieceTrivial n i = (⊤ : Submodule ℚ PUnit) := by
  apply le_antisymm le_top
  intro x _
  obtain rfl : x = 0 := Subsingleton.elim _ _
  exact Submodule.zero_mem _

/-- `PureHodgeStructure PUnit n` for every weight `n`, kernel-pure. -/
instance pureHodgeStructure_PUnit (n : ℕ) : PureHodgeStructure PUnit n where
  piece := pieceTrivial n
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      (iSupIndep_pieceTrivial n)
      (iSup_pieceTrivial_eq_top n)

/-! ## 2. Carriers for point cohomology -/

def cohomologyType : ℕ → Type
  | 0     => ℚ
  | _ + 1 => PUnit

@[simp] theorem cohomologyType_zero : cohomologyType 0 = ℚ := rfl
@[simp] theorem cohomologyType_succ (k : ℕ) : cohomologyType (k + 1) = PUnit := rfl

theorem cohomologyType_pos {k : ℕ} (hk : 0 < k) : cohomologyType k = PUnit := by
  cases k
  · omega
  · rfl

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 1 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | _ + 1 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 1 => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType k) (cohomologyType_addCommGroup k)
           (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | k + 1 => pureHodgeStructure_PUnit (k + 1)

/-- The point's cohomology bundle. -/
noncomputable def varietyCohomology_point : VarietyCohomologyData where
  H := cohomologyType
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## 3. AlgebraicClassesData for a point — honest definition -/

/-- Algebraic classes at codimension `p`: `⊤` at `p = 0` (the
fundamental class `[pt]` spans `H^0(pt, ℚ) = ℚ`); `⊥` at `p > 0` (no
codim-`p` cycles on a 0-dim variety). -/
noncomputable def algClassesPoint :
    ∀ (p : ℕ),
      @Submodule ℚ (varietyCohomology_point.H (2 * p)) _
        (varietyCohomology_point.addCommGroup (2 * p)).toAddCommMonoid
        (varietyCohomology_point.module (2 * p))
  | 0     => ⊤
  | _ + 1 => ⊥

/-- Hodge half: algClasses ≤ hodgeClasses at every codimension. -/
theorem algClassesPoint_le_hodgeClasses (p : ℕ) :
    algClassesPoint p ≤ varietyCohomology_point.hodgeClassesAtDegree p := by
  letI _i_acg := varietyCohomology_point.addCommGroup (2 * p)
  letI _i_mod := varietyCohomology_point.module (2 * p)
  letI _i_phs := varietyCohomology_point.hodgeStructure (2 * p)
  intro x hx
  rcases p with _ | p'
  · -- p = 0 case
    show x ∈ varietyCohomology_point.hodgeClassesAtDegree 0
    -- hodgeClassesAtDegree 0 = PureHodgeStructure.hodgeClasses (ℚ) 0 = piece_ℚ_w0 ⟨0,_⟩ = ⊤
    show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  · -- p > 0 case
    letI _j_acg := varietyCohomology_point.addCommGroup (2 * (p' + 1))
    letI _j_mod := varietyCohomology_point.module (2 * (p' + 1))
    have hx0 : x = 0 := (Submodule.mem_bot _).mp hx
    rw [hx0]
    exact Submodule.zero_mem _

noncomputable def algClasses_point :
    AlgebraicClassesData varietyCohomology_point where
  algClasses := algClassesPoint
  algClasses_le_hodgeClasses := algClassesPoint_le_hodgeClasses

/-! ## 4. VarietyHC for a point — substantive proof -/

/-- **R201 minimum attack closure**: HC for `Spec ℂ`. At p = 0 both
algClasses 0 and hodgeClasses 0 equal ⊤; at p > 0 the ambient
`H(2*(p+1)) = PUnit` forces every element to be 0 and lie in `⊥`. -/
theorem VarietyHC_point :
    VarietyHC varietyCohomology_point algClasses_point := by
  intro p
  letI _i_acg := varietyCohomology_point.addCommGroup (2 * p)
  letI _i_mod := varietyCohomology_point.module (2 * p)
  letI _i_phs := varietyCohomology_point.hodgeStructure (2 * p)
  intro x _hx
  rcases p with _ | p'
  · -- p = 0: hodgeClasses 0 ⊆ ⊤ trivially.
    show x ∈ algClassesPoint 0
    exact Submodule.mem_top
  · -- p > 0: x : H(2*(p'+1)) = PUnit; subsingleton ⇒ x = 0 ∈ ⊥
    letI _j_acg := varietyCohomology_point.addCommGroup (2 * (p' + 1))
    letI _j_mod := varietyCohomology_point.module (2 * (p' + 1))
    have hSub : Subsingleton (varietyCohomology_point.H (2 * (p' + 1))) := by
      show Subsingleton (cohomologyType (2 * (p' + 1)))
      rw [cohomologyType_pos (by omega : 0 < 2 * (p' + 1))]
      infer_instance
    have hx0 : x = 0 := Subsingleton.elim _ _
    show x ∈ algClassesPoint (p' + 1)
    rw [hx0]
    exact Submodule.zero_mem _

theorem VarietyHCAt_point (p : ℕ) :
    VarietyHCAt varietyCohomology_point algClasses_point p :=
  VarietyHC_point p

end TrivialPoint
end HCGapL2
end HodgeReduction
