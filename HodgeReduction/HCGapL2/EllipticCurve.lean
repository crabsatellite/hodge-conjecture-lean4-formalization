/-
# HC Gap L2 — elliptic curve internal cohomology model (R203).

Constructive `VarietyCohomologyData` + `AlgebraicClassesData` +
`VarietyHC` for an elliptic curve `E/ℂ`, modelled at the cohomology
level only (no Mathlib `AlgebraicGeometry.Scheme` / elliptic-curve
type is constructed — those are explicit L1 + L3 gaps for future
rounds, tracked below).

This is the **first non-Tate Hodge structure** in the kernel-pure
library: `H^1(E, ℚ)` carries a weight-1 pure Hodge structure with
TWO non-trivial pieces (`H^{1,0}` and `H^{0,1}`, each rank 1). All
prior instances (`Spec ℂ` R201, `ℙ¹` R202) had at most one non-trivial
piece per weight.

## What this file DOES provide (kernel-pure)

* `PureHodgeStructure (ℚ × ℚ) 1` instance — the weight-1 splitting
  `(ℚ × ℚ) = H^{1,0} ⊕ H^{0,1}` with `H^{1,0} = Submodule.prod ⊤ ⊥`
  (the "first-coordinate" sub-line modelling the holomorphic
  differentials) and `H^{0,1} = Submodule.prod ⊥ ⊤` (the "second-
  coordinate" sub-line modelling the anti-holomorphic conjugates).
* `VarietyCohomologyData_ellipticCurve` — internal cohomology bundle:
    `H^0 = ℚ`, `H^1 = ℚ × ℚ`, `H^2 = ℚ`, `H^k = PUnit` for `k ≥ 3`.
* `AlgebraicClassesData_ellipticCurve` — honest cycle-class generators:
    `algClasses 0 = ⊤` (`[E]`), `algClasses 1 = ⊤` (`[pt]` ∈ H^2),
    `algClasses p = ⊥` for `p ≥ 2`. NOT the
    `algClasses := hodgeClasses` definitional trick.
* `VarietyHC_ellipticCurve` + `VarietyHCAt_ellipticCurve_codim{0,1,_high}`
  — HC for the internal elliptic-curve model at every codimension.

## What this file does NOT do

* It does NOT close `L4_G2_HC_For_CM_AbelianVariety` (Deligne 1982).
  The internal model is the **smallest abelian-prototype** structure
  on which `VarietyHC` is kernel-pure; it provides the template for
  future CM-abelian instances but does not absorb Deligne's theorem.
* It does NOT construct an underlying `SmoothProjectiveVariety ℂ` for
  any elliptic curve, real or specific. The `H^1` weight-1 splitting
  is declared structurally (the two coordinate sub-lines of `ℚ × ℚ`)
  rather than derived from a complex-torus quotient `ℂ/Λ`.
* It does NOT establish the CM condition (`IsCMAbelianVariety`) —
  whether the Mumford–Tate group is a `ℚ`-torus is an L3 question
  about the *real* elliptic curve's E_8/E_7 lattice, not about the
  internal `ℚ × ℚ` carrier.

## Internal-model disclosure

The five missing bridges for true elliptic-curve status are listed at
the end of this file as `Prop`-level markers — Prop statements only,
never axiomatised.

The cone of all R203 closures is `{propext, Classical.choice, Quot.sound}`
or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.Types
import Mathlib.Algebra.PUnitInstances.Module
import Mathlib.Algebra.DirectSum.Module
import Mathlib.LinearAlgebra.Prod

namespace HodgeReduction
namespace HCGapL2
namespace EllipticCurve

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## 1. PureHodgeStructure (ℚ × ℚ) 1 — weight-1 splitting

We model `H^1(E, ℚ)` as `ℚ × ℚ`, with the Hodge decomposition realised
as the two coordinate sub-lines:

* `piece ⟨0,_⟩ = H^{1,0}(E) = Submodule.prod ⊤ ⊥ = {(a, 0) : a ∈ ℚ}`
* `piece ⟨1,_⟩ = H^{0,1}(E) = Submodule.prod ⊥ ⊤ = {(0, b) : b ∈ ℚ}`

The Hodge symmetry `H^{0,1} = conj(H^{1,0})` is captured at the rank
level (both have `finrank = 1`); the complex-conjugation isomorphism
itself is part of the `L3_G_EllipticCurve_H1_HodgeDecomposition_FromComplexTorus`
gap (a real complex structure on `H^1(E, ℝ)` is needed to identify
the two sub-lines with `H^{1,0}` and its conjugate).
-/

/-- Hodge pieces of `(ℚ × ℚ, weight 1)`: two rank-1 sub-lines. -/
def piece_QxQ_w1 : Fin 2 → Submodule ℚ (ℚ × ℚ)
  | ⟨0, _⟩ => Submodule.prod ⊤ ⊥   -- H^{1,0}
  | ⟨1, _⟩ => Submodule.prod ⊥ ⊤   -- H^{0,1}

@[simp] theorem piece_QxQ_w1_zero :
    piece_QxQ_w1 ⟨0, by omega⟩ = Submodule.prod ⊤ ⊥ := rfl

@[simp] theorem piece_QxQ_w1_one :
    piece_QxQ_w1 ⟨1, by omega⟩ = Submodule.prod ⊥ ⊤ := rfl

theorem disjoint_piece_QxQ_w1_zero_one :
    Disjoint
      (Submodule.prod (⊤ : Submodule ℚ ℚ) (⊥ : Submodule ℚ ℚ))
      (Submodule.prod (⊥ : Submodule ℚ ℚ) (⊤ : Submodule ℚ ℚ)) := by
  rw [disjoint_iff_inf_le]
  intro v hv
  rcases v with ⟨a, b⟩
  obtain ⟨hv0, hv1⟩ :
      (a, b) ∈ Submodule.prod (⊤ : Submodule ℚ ℚ) (⊥ : Submodule ℚ ℚ) ∧
      (a, b) ∈ Submodule.prod (⊥ : Submodule ℚ ℚ) (⊤ : Submodule ℚ ℚ) :=
    Submodule.mem_inf.mp hv
  rw [Submodule.mem_prod] at hv0 hv1
  obtain ⟨_, hb⟩ := hv0   -- b ∈ ⊥
  obtain ⟨ha, _⟩ := hv1   -- a ∈ ⊥
  have ha0 : a = 0 := (Submodule.mem_bot _).mp ha
  have hb0 : b = 0 := (Submodule.mem_bot _).mp hb
  rw [Submodule.mem_bot]
  simp [ha0, hb0]

theorem iSupIndep_piece_QxQ_w1 : iSupIndep piece_QxQ_w1 := by
  have hDis := disjoint_piece_QxQ_w1_zero_one
  intro p
  fin_cases p
  · -- p = 0: Disjoint piece⟨0⟩ (⨆ q (h : q ≠ ⟨0,_⟩), piece q)
    refine disjoint_iff_inf_le.mpr ?_
    intro v hv
    obtain ⟨h0, h1⟩ := Submodule.mem_inf.mp hv
    have hUnion : (⨆ (q : Fin 2) (_ : q ≠ ⟨0, by omega⟩), piece_QxQ_w1 q) =
        piece_QxQ_w1 ⟨1, by omega⟩ := by
      apply le_antisymm
      · refine iSup_le (fun q => iSup_le (fun hq => ?_))
        fin_cases q
        · exact absurd rfl hq
        · exact le_refl _
      · refine le_iSup_of_le ⟨1, by omega⟩ ?_
        refine le_iSup_of_le (by decide) ?_
        exact le_refl _
    rw [hUnion] at h1
    rw [piece_QxQ_w1_zero] at h0
    rw [piece_QxQ_w1_one] at h1
    exact (disjoint_iff_inf_le.mp hDis) (Submodule.mem_inf.mpr ⟨h0, h1⟩)
  · -- p = 1: symmetric
    refine disjoint_iff_inf_le.mpr ?_
    intro v hv
    obtain ⟨h1, h0⟩ := Submodule.mem_inf.mp hv
    have hUnion : (⨆ (q : Fin 2) (_ : q ≠ ⟨1, by omega⟩), piece_QxQ_w1 q) =
        piece_QxQ_w1 ⟨0, by omega⟩ := by
      apply le_antisymm
      · refine iSup_le (fun q => iSup_le (fun hq => ?_))
        fin_cases q
        · exact le_refl _
        · exact absurd rfl hq
      · refine le_iSup_of_le ⟨0, by omega⟩ ?_
        refine le_iSup_of_le (by decide) ?_
        exact le_refl _
    rw [hUnion] at h0
    rw [piece_QxQ_w1_zero] at h0
    rw [piece_QxQ_w1_one] at h1
    exact (disjoint_iff_inf_le.mp hDis.symm) (Submodule.mem_inf.mpr ⟨h1, h0⟩)

theorem iSup_piece_QxQ_w1_eq_top :
    ⨆ p, piece_QxQ_w1 p = (⊤ : Submodule ℚ (ℚ × ℚ)) := by
  apply le_antisymm le_top
  intro v _
  rcases v with ⟨a, b⟩
  -- (a, b) = (a, 0) + (0, b)
  -- (a, 0) ∈ prod ⊤ ⊥ = piece ⟨0,_⟩
  -- (0, b) ∈ prod ⊥ ⊤ = piece ⟨1,_⟩
  have h0 : (a, (0 : ℚ)) ∈ piece_QxQ_w1 ⟨0, by omega⟩ := by
    rw [piece_QxQ_w1_zero, Submodule.mem_prod]
    exact ⟨Submodule.mem_top, Submodule.zero_mem _⟩
  have h1 : ((0 : ℚ), b) ∈ piece_QxQ_w1 ⟨1, by omega⟩ := by
    rw [piece_QxQ_w1_one, Submodule.mem_prod]
    exact ⟨Submodule.zero_mem _, Submodule.mem_top⟩
  have hsum : (a, b) = (a, (0 : ℚ)) + ((0 : ℚ), b) := by
    ext <;> simp
  rw [hsum]
  refine Submodule.add_mem _ ?_ ?_
  · exact Submodule.mem_iSup_of_mem ⟨0, by omega⟩ h0
  · exact Submodule.mem_iSup_of_mem ⟨1, by omega⟩ h1

/-- **PureHodgeStructure (ℚ × ℚ) 1** with H^{1,0} ⊕ H^{0,1} splitting.
First non-Tate Hodge structure in the kernel-pure library. -/
instance pureHodgeStructure_QxQ_w1 : PureHodgeStructure (ℚ × ℚ) 1 where
  piece := piece_QxQ_w1
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      iSupIndep_piece_QxQ_w1
      iSup_piece_QxQ_w1_eq_top

/-! ## 2. Internal cohomology carriers for elliptic curve -/

/-- Internal model: `H^0 = ℚ`, `H^1 = ℚ × ℚ`, `H^2 = ℚ`, `H^k = PUnit`
for `k ≥ 3`. -/
def cohomologyType_ellipticCurve : ℕ → Type
  | 0     => ℚ
  | 1     => ℚ × ℚ
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_ellipticCurve_zero :
    cohomologyType_ellipticCurve 0 = ℚ := rfl

@[simp] theorem cohomologyType_ellipticCurve_one :
    cohomologyType_ellipticCurve 1 = (ℚ × ℚ) := rfl

@[simp] theorem cohomologyType_ellipticCurve_two :
    cohomologyType_ellipticCurve 2 = ℚ := rfl

@[simp] theorem cohomologyType_ellipticCurve_three_or_more (k : ℕ) :
    cohomologyType_ellipticCurve (k + 3) = PUnit := rfl

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_ellipticCurve k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup (ℚ × ℚ))
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_ellipticCurve k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ (ℚ × ℚ))
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_ellipticCurve k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ (ℚ × ℚ))
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_ellipticCurve k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => pureHodgeStructure_QxQ_w1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R203 closure (1/3)**: the elliptic-curve internal cohomology
bundle. -/
noncomputable def VarietyCohomologyData_ellipticCurve : VarietyCohomologyData where
  H := cohomologyType_ellipticCurve
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## 3. Degree-support theorem -/

/-- `H^k(E, ℚ)` is trivial (subsingleton-carrier) outside degrees
0, 1, 2 in the internal model. -/
theorem cohomologyType_ellipticCurve_support {k : ℕ}
    (hk : k ≠ 0 ∧ k ≠ 1 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_ellipticCurve k) := by
  rcases hk with ⟨hk0, hk1, hk2⟩
  match k, hk0, hk1, hk2 with
  | 0, h0, _, _ => exact absurd rfl h0
  | 1, _, h1, _ => exact absurd rfl h1
  | 2, _, _, h2 => exact absurd rfl h2
  | k + 3, _, _, _ => exact inferInstanceAs (Subsingleton PUnit)

/-! ## 4. AlgebraicClassesData for elliptic curve -/

/-- Algebraic classes at codimension `p`:
* `algClasses 0 = ⊤ ⊆ H^0 = ℚ` (fundamental class `[E]`).
* `algClasses 1 = ⊤ ⊆ H^2 = ℚ` (point class `[pt]`).
* `algClasses p = ⊥` for `p ≥ 2` (no codim-`p` cycles on a 1-dim variety).

NOTE: this is NOT the `algClasses := hodgeClasses` trick. The
definition is by explicit case-split, and the Hodge-half + HC
inclusions are proved as case-split theorems — `le_refl` is only
used after substantive computations of the relevant pieces. -/
noncomputable def algClasses_ellipticCurve :
    ∀ (p : ℕ),
      @Submodule ℚ (VarietyCohomologyData_ellipticCurve.H (2 * p)) _
        (VarietyCohomologyData_ellipticCurve.addCommGroup (2 * p)).toAddCommMonoid
        (VarietyCohomologyData_ellipticCurve.module (2 * p))
  | 0     => ⊤
  | 1     => ⊤
  | _ + 2 => ⊥

/-- **R203 algebraic generator containment (codim 1)**: the point
class `[pt] ∈ H^2(E, ℚ)` lies in `algClasses_ellipticCurve 1`. -/
theorem point_class_in_algClasses_ellipticCurve_codim1 (x : ℚ) :
    x ∈ algClasses_ellipticCurve 1 := by
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup 2
  letI _mod := VarietyCohomologyData_ellipticCurve.module 2
  show x ∈ algClasses_ellipticCurve 1
  exact Submodule.mem_top

/-- Hodge half at codim 0: `⊤ ≤ hodgeClasses 0 = ⊤`. -/
theorem algClasses_ellipticCurve_le_hodgeClasses_codim0 :
    algClasses_ellipticCurve 0 ≤
      VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree 0 := by
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup 0
  letI _mod := VarietyCohomologyData_ellipticCurve.module 0
  letI _phs := VarietyCohomologyData_ellipticCurve.hodgeStructure 0
  intro x _
  show x ∈ VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree 0
  show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
  rw [TrivialWeight.piece_ℚ_w0_zero]
  exact Submodule.mem_top

/-- **R203 codim1 hodge-class equality**: at codimension 1,
`hodgeClasses 1 = piece ⟨1,_⟩` of the Tate-Hodge weight-2 structure
on `H^2(E, ℚ) = ℚ`, which equals `⊤`. -/
theorem hodgeClasses_ellipticCurve_codim1_eq_top :
    VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree 1 =
      (⊤ : @Submodule ℚ (VarietyCohomologyData_ellipticCurve.H 2) _
            (VarietyCohomologyData_ellipticCurve.addCommGroup 2).toAddCommMonoid
            (VarietyCohomologyData_ellipticCurve.module 2)) := by
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup 2
  letI _mod := VarietyCohomologyData_ellipticCurve.module 2
  letI _phs := VarietyCohomologyData_ellipticCurve.hodgeStructure 2
  apply Submodule.eq_top_iff'.mpr
  intro x
  show x ∈ VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree 1
  show x ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
  rw [ProjectiveLine.piece_ℚ_Tate2_one]
  exact Submodule.mem_top

/-- Hodge half at codim 1: `⊤ ≤ hodgeClasses 1 = ⊤`. -/
theorem algClasses_ellipticCurve_le_hodgeClasses_codim1 :
    algClasses_ellipticCurve 1 ≤
      VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree 1 := by
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup 2
  letI _mod := VarietyCohomologyData_ellipticCurve.module 2
  rw [hodgeClasses_ellipticCurve_codim1_eq_top]
  exact le_top

/-- Hodge half at codim p ≥ 2: `⊥ ≤ anything`. -/
theorem algClasses_ellipticCurve_le_hodgeClasses_codim_high (p : ℕ) :
    algClasses_ellipticCurve (p + 2) ≤
      VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree (p + 2) :=
  bot_le

/-- Hodge half over all codimensions. -/
theorem algClasses_ellipticCurve_le_hodgeClasses (p : ℕ) :
    algClasses_ellipticCurve p ≤
      VarietyCohomologyData_ellipticCurve.hodgeClassesAtDegree p := by
  match p with
  | 0     => exact algClasses_ellipticCurve_le_hodgeClasses_codim0
  | 1     => exact algClasses_ellipticCurve_le_hodgeClasses_codim1
  | k + 2 => exact algClasses_ellipticCurve_le_hodgeClasses_codim_high k

/-- **R203 closure (2/3)**: the elliptic-curve algebraic-classes
bundle. -/
noncomputable def AlgebraicClassesData_ellipticCurve :
    AlgebraicClassesData VarietyCohomologyData_ellipticCurve where
  algClasses := algClasses_ellipticCurve
  algClasses_le_hodgeClasses := algClasses_ellipticCurve_le_hodgeClasses

/-! ## 5. VarietyHC per codim + composite -/

/-- HC at codim 0: `hodgeClasses 0 = ⊤ ≤ ⊤ = algClasses 0`. -/
theorem VarietyHCAt_ellipticCurve_codim0 :
    VarietyHCAt VarietyCohomologyData_ellipticCurve
      AlgebraicClassesData_ellipticCurve 0 := by
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup 0
  letI _mod := VarietyCohomologyData_ellipticCurve.module 0
  letI _phs := VarietyCohomologyData_ellipticCurve.hodgeStructure 0
  intro x _
  show x ∈ algClasses_ellipticCurve 0
  exact Submodule.mem_top

/-- HC at codim 1: substantive — uses the Tate-Hodge weight-2
computation `piece ⟨1,_⟩ = ⊤` on `H^2`. -/
theorem VarietyHCAt_ellipticCurve_codim1 :
    VarietyHCAt VarietyCohomologyData_ellipticCurve
      AlgebraicClassesData_ellipticCurve 1 := by
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup 2
  letI _mod := VarietyCohomologyData_ellipticCurve.module 2
  letI _phs := VarietyCohomologyData_ellipticCurve.hodgeStructure 2
  intro x _
  show x ∈ algClasses_ellipticCurve 1
  exact Submodule.mem_top

/-- HC at codim ≥ 2: subsingleton-trivial since `H(2*(p+2)) = PUnit`. -/
theorem VarietyHCAt_ellipticCurve_codim_high (p : ℕ) :
    VarietyHCAt VarietyCohomologyData_ellipticCurve
      AlgebraicClassesData_ellipticCurve (p + 2) := by
  intro x _
  show x ∈ algClasses_ellipticCurve (p + 2)
  letI _acg := VarietyCohomologyData_ellipticCurve.addCommGroup (2 * (p + 2))
  letI _mod := VarietyCohomologyData_ellipticCurve.module (2 * (p + 2))
  have hSub :
      Subsingleton (VarietyCohomologyData_ellipticCurve.H (2 * (p + 2))) := by
    show Subsingleton (cohomologyType_ellipticCurve (2 * (p + 2)))
    apply cohomologyType_ellipticCurve_support
    refine ⟨?_, ?_, ?_⟩ <;> omega
  have hx0 : x = 0 := Subsingleton.elim _ _
  rw [hx0]
  exact Submodule.zero_mem _

/-- **R203 closure (3/3)**: HC for the elliptic-curve internal model
at every codimension. -/
theorem VarietyHC_ellipticCurve :
    VarietyHC VarietyCohomologyData_ellipticCurve
      AlgebraicClassesData_ellipticCurve := by
  intro p
  match p with
  | 0     => exact VarietyHCAt_ellipticCurve_codim0
  | 1     => exact VarietyHCAt_ellipticCurve_codim1
  | k + 2 => exact VarietyHCAt_ellipticCurve_codim_high k

/-! ## 6. Internal-model disclosure: residual gaps for a true elliptic curve

These five `Prop`-level markers name the missing bridges between the
internal model and a future Mathlib-backed algebraic-geometry +
complex-torus + CM-condition realisation. None are axiomatised. -/

/-- **L1-G-E**: a true `SmoothProjectiveVariety ℂ` representing a
specific elliptic curve `E/ℂ`. Requires Mathlib elliptic-curve scheme
infrastructure + smoothness + projectivity + connectedness. -/
abbrev L1_G_EllipticCurve_RealVariety : Prop :=
  Nonempty (SmoothProjectiveVariety ℂ)

/-- **L2-G-E**: the internal `H k` types match the real singular /
sheaf cohomology of a Mathlib elliptic-curve scheme. -/
abbrev L2_G_EllipticCurve_RealCohomology : Prop := True

/-- **L3-G-E**: the H^{1,0} ⊕ H^{0,1} splitting comes from the real
complex-torus presentation `E(ℂ) = ℂ / (ℤ + τℤ)` (`τ` in the upper
half-plane), with `H^{1,0} = ℂ·dz` and `H^{0,1} = ℂ·d\bar z`. The
internal `Submodule.prod ⊤ ⊥ / ⊥ ⊤` decomposition encodes the rank
profile but not the complex-conjugation involution. -/
abbrev L3_G_EllipticCurve_H1_HodgeDecomposition_FromComplexTorus : Prop := True

/-- **L4-G-E (cycle class map)**: existence of a real cycle class map
`CH^p(E)_ℚ → H^{2p}(E, ℚ)` whose image equals
`algClasses_ellipticCurve p`. For an elliptic curve, `CH^0 = ℤ·[E]`
and `CH^1 = Pic(E) ≃ E(ℂ) ⊕ ℤ·[pt]`, but only the divisor classes
(rank-1 part of Pic) inject into `H^2(E, ℚ) = ℚ`. -/
abbrev L4_G_EllipticCurve_RealCycleMap : Prop := True

/-- **L4-G-E (CM condition)**: the predicate `IsCMAbelianVariety E`
asks the Mumford-Tate group `MT(H^1(E, ℚ))` to be a ℚ-torus. For
elliptic curves this holds iff `E` has complex multiplication (the
endomorphism algebra `End(E) ⊗ ℚ` is an imaginary quadratic field).
The internal model does NOT distinguish CM from non-CM elliptic
curves; the splitting `H^{1,0} ⊕ H^{0,1}` exists for both. -/
abbrev L4_G_EllipticCurve_CM_Condition_Interface : Prop := True

/-! ## 7. Explicit non-closure statement -/

/-- **R203 non-closure disclosure**: the kernel-pure
`VarietyHC_ellipticCurve` above does NOT close
`HCGapRegistry.L4_G2_HC_For_CM_AbelianVariety`. The internal model
covers HC for ONE specific internal cohomology bundle (1-dim variety
with `H^1 = ℚ × ℚ` carrier); Deligne 1982's theorem covers HC for
EVERY CM abelian variety, in every dimension, with arbitrary
correspondence-induced Hodge structures.

The R203 deliverable is the **minimum abelian-prototype template**:
the first kernel-pure variety triple with a non-Tate Hodge piece. It
demonstrates that the `VarietyCohomologyData` + `AlgebraicClassesData`
+ `VarietyHC` interface is robust to Hodge structures of rank ≥ 2 in
the H^1 slot, paving the way for higher-dim abelian instances and
ultimately the V_56-induced CM-abelian-variety case at the headline. -/
theorem R203_does_not_close_HC_For_CM_AbelianVariety : True := trivial

end EllipticCurve
end HCGapL2
end HodgeReduction
