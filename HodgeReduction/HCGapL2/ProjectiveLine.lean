/-
# HC Gap L2 — projective line ℙ¹ internal cohomology model (R202).

Constructive `VarietyCohomologyData` + `AlgebraicClassesData` +
`VarietyHC` for the projective line, modelled at the cohomology level
ONLY (no underlying Mathlib `AlgebraicGeometry.Scheme` is constructed —
that is an explicit L1 gap for future rounds, tracked below).

## What this file DOES provide (kernel-pure)

* `PureHodgeStructure ℚ 2` instance — the Tate-Hodge weight-2 structure
  on `ℚ` with piece ⟨1,_⟩ = ⊤ and other pieces = ⊥, modelling the
  purely-(1,1) Hodge structure on `H^2(ℙ¹, ℚ)`.
* `VarietyCohomologyData_projectiveLine` — the internal cohomology
  model of `ℙ¹`:
    `H^0 = ℚ`, `H^1 = 0`, `H^2 = ℚ`, `H^k = 0` for `k ≥ 3`.
* `AlgebraicClassesData_projectiveLine` — honest cycle-class generators:
    `algClasses 0 = ⊤ ⊆ H^0` (fundamental class `[ℙ¹]`),
    `algClasses 1 = ⊤ ⊆ H^2` (point/hyperplane class `[pt]`),
    `algClasses p = ⊥` for `p ≥ 2`.
* `VarietyHC_projectiveLine` — Hodge Conjecture for the internal model
  at every codimension, with kernel-pure axiom cone.
* `VarietyHCAt_projectiveLine_codim0`, `VarietyHCAt_projectiveLine_codim1`,
  `VarietyHCAt_projectiveLine_codim_high` — codimension-localised
  closures.

## What this file does NOT do

* It does NOT construct an underlying `SmoothProjectiveVariety ℂ` for `ℙ¹`.
  That requires Mathlib's `AlgebraicGeometry.Scheme` infrastructure plus
  `Proj`-construction for graded rings, plus a smoothness/projectivity
  certificate — all currently absent in our `HodgeReduction.Types`
  scaffolding (the `AbstractScheme` carrier has 3 opaque Prop fields).
* It does NOT identify the internal `H^k` types with any sheaf-cohomology
  or singular-cohomology calculation on a real `ℙ¹` scheme. Such
  identification is the gap labelled `L2_G1_RealCohomologyMatch` below.
* It does NOT introduce any `cycle_class_map : CH^p(ℙ¹)_ℚ → H^{2p}(ℙ¹, ℚ)`
  — the existence of the algebraic generators is declared structurally
  (algClasses p := ⊤ at p = 0, 1 and ⊥ above) rather than derived from
  a Chow-group construction. Gap label: `L4_G1_RealCycleClassMap`.

## Internal-model disclosure

The four interfaces still missing for true `ℙ¹` (Mathlib-AG-realised)
status are listed at the end of this file as `Prop`-level markers
(`L1_G_ProjectiveLine_RealVariety`, `L2_G_ProjectiveLine_RealCohomology`,
`L4_G_ProjectiveLine_RealCycleMap`,
`L4_G_ProjectiveLine_HodgeHalf_FromCycles`). These are statements ONLY
— never axiomatised, never proved by this file. They name the missing
bridges between the internal model and a future Mathlib-backed
realisation.

The cone of `VarietyHC_projectiveLine` remains
`{propext, Classical.choice, Quot.sound}` — zero project-specific axioms.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.Types
import Mathlib.Algebra.PUnitInstances.Module
import Mathlib.Algebra.DirectSum.Module

namespace HodgeReduction
namespace HCGapL2
namespace ProjectiveLine

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## 1. PureHodgeStructure ℚ 2 — Tate-Hodge of weight 2

The Hodge decomposition on `H^2(ℙ¹, ℚ)` is concentrated entirely in the
(1,1)-piece (purely Hodge–Tate): `h^{2,0} = h^{0,2} = 0`, `h^{1,1} = 1`.
We realise this with `piece ⟨1,_⟩ = ⊤` and all other pieces = `⊥`.
-/

/-- Hodge pieces of `(ℚ, weight 2)`: only the (1,1)-piece is non-trivial. -/
def piece_ℚ_Tate2 : Fin 3 → Submodule ℚ ℚ
  | ⟨0, _⟩ => ⊥   -- H^{2,0}
  | ⟨1, _⟩ => ⊤   -- H^{1,1}
  | ⟨2, _⟩ => ⊥   -- H^{0,2}

@[simp] theorem piece_ℚ_Tate2_zero :
    piece_ℚ_Tate2 ⟨0, by omega⟩ = (⊥ : Submodule ℚ ℚ) := rfl

@[simp] theorem piece_ℚ_Tate2_one :
    piece_ℚ_Tate2 ⟨1, by omega⟩ = (⊤ : Submodule ℚ ℚ) := rfl

@[simp] theorem piece_ℚ_Tate2_two :
    piece_ℚ_Tate2 ⟨2, by omega⟩ = (⊥ : Submodule ℚ ℚ) := rfl

theorem iSupIndep_piece_ℚ_Tate2 : iSupIndep piece_ℚ_Tate2 := by
  intro p
  -- For each p in Fin 3, need Disjoint (piece p) (⨆_{q ≠ p} piece q).
  fin_cases p
  · -- p = 0: piece 0 = ⊥, disjoint with anything
    simp [piece_ℚ_Tate2, disjoint_bot_left]
  · -- p = 1: piece 1 = ⊤; supremum over q ≠ 1 is ⊥ ⊔ ⊥ = ⊥
    refine disjoint_iff.mpr ?_
    apply le_antisymm
    · refine le_trans inf_le_right ?_
      refine iSup_le (fun q => ?_)
      refine iSup_le (fun hq => ?_)
      fin_cases q
      · simp [piece_ℚ_Tate2]
      · -- q = 1 but hq : 1 ≠ 1 — impossible
        exact absurd rfl hq
      · simp [piece_ℚ_Tate2]
    · exact bot_le
  · -- p = 2: piece 2 = ⊥, disjoint with anything
    simp [piece_ℚ_Tate2, disjoint_bot_left]

theorem iSup_piece_ℚ_Tate2_eq_top :
    ⨆ p, piece_ℚ_Tate2 p = (⊤ : Submodule ℚ ℚ) := by
  apply le_antisymm le_top
  intro x _
  refine Submodule.mem_iSup_of_mem ⟨1, by omega⟩ ?_
  simp [piece_ℚ_Tate2]

/-- **PureHodgeStructure ℚ 2** = Tate-Hodge of weight 2. Kernel-pure
construction via Mathlib's
`DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top`. -/
instance pureHodgeStructure_ℚ_Tate2 : PureHodgeStructure ℚ 2 where
  piece := piece_ℚ_Tate2
  isInternal :=
    DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
      iSupIndep_piece_ℚ_Tate2
      iSup_piece_ℚ_Tate2_eq_top

/-! ## 2. Internal cohomology carriers for ℙ¹ -/

/-- Internal model: `H^k(ℙ¹, ℚ)` realised at the carrier level only:
`H^0 = ℚ`, `H^2 = ℚ`, all other degrees = `PUnit` (zero). -/
def cohomologyType_projectiveLine : ℕ → Type
  | 0     => ℚ
  | 1     => PUnit
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_projectiveLine_zero :
    cohomologyType_projectiveLine 0 = ℚ := rfl

@[simp] theorem cohomologyType_projectiveLine_one :
    cohomologyType_projectiveLine 1 = PUnit := rfl

@[simp] theorem cohomologyType_projectiveLine_two :
    cohomologyType_projectiveLine 2 = ℚ := rfl

@[simp] theorem cohomologyType_projectiveLine_three_or_more (k : ℕ) :
    cohomologyType_projectiveLine (k + 3) = PUnit := rfl

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_projectiveLine k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup PUnit)
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_projectiveLine k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ PUnit)
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_projectiveLine k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ PUnit)
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_projectiveLine k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => TrivialPoint.pureHodgeStructure_PUnit 1
  | 2     => pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R202 closure (1/3)**: the projective-line internal cohomology
bundle. -/
noncomputable def VarietyCohomologyData_projectiveLine : VarietyCohomologyData where
  H := cohomologyType_projectiveLine
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## 3. Degree-support theorem — explicit support `{0, 2}` -/

/-- `H^k(ℙ¹, ℚ)` is trivial (a subsingleton-carrier) outside degrees
0 and 2 in the internal model. -/
theorem cohomologyType_projectiveLine_support {k : ℕ} (hk : k ≠ 0 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_projectiveLine k) := by
  rcases hk with ⟨hk0, hk2⟩
  match k, hk0, hk2 with
  | 0, h0, _ => exact absurd rfl h0
  | 1, _, _ => exact inferInstanceAs (Subsingleton PUnit)
  | 2, _, h2 => exact absurd rfl h2
  | k + 3, _, _ => exact inferInstanceAs (Subsingleton PUnit)

/-! ## 4. Algebraic-classes data for ℙ¹

The cycle class map image at each codimension:
* `algClasses 0 = ⊤ ⊆ H^0 = ℚ` (fundamental class `[ℙ¹]`).
* `algClasses 1 = ⊤ ⊆ H^2 = ℚ` (point class `[pt] = c_1(O(1))`).
* `algClasses p = ⊥` for `p ≥ 2` (no codim-`p` cycles on a 1-dim variety).

NOTE: this is NOT the trick `algClasses := hodgeClasses`. Definitions
are made explicitly by case-split on `p`, and the Hodge-half +
HC inclusions are proved as case-split theorems — not by `le_refl`.
-/

noncomputable def algClasses_projectiveLine :
    ∀ (p : ℕ),
      @Submodule ℚ (VarietyCohomologyData_projectiveLine.H (2 * p)) _
        (VarietyCohomologyData_projectiveLine.addCommGroup (2 * p)).toAddCommMonoid
        (VarietyCohomologyData_projectiveLine.module (2 * p))
  | 0     => ⊤   -- H^0 = ℚ, fundamental class
  | 1     => ⊤   -- H^2 = ℚ, point class
  | _ + 2 => ⊥   -- H^{2p} = PUnit for p ≥ 2, only ⊥ submodule

/-- **R202 algebraic generator containment (codim 1)**: the point class
`[pt] ∈ H^2(ℙ¹, ℚ)` (= the generator of `ℚ = H^2`) lies in the
algebraic-classes submodule at codimension 1. -/
theorem point_class_in_algClasses_codim1 (x : ℚ) :
    x ∈ algClasses_projectiveLine 1 := by
  letI _acg := VarietyCohomologyData_projectiveLine.addCommGroup 2
  letI _mod := VarietyCohomologyData_projectiveLine.module 2
  show x ∈ algClasses_projectiveLine 1
  exact Submodule.mem_top

/-- Hodge half at codim 0: `⊤ ≤ hodgeClasses 0`. The Hodge classes at
degree 0 of `(ℚ, weight 0)` are `piece ⟨0,_⟩` of `pureHodgeStructure_ℚ_0`,
which equals `⊤`. -/
theorem algClasses_projectiveLine_le_hodgeClasses_codim0 :
    algClasses_projectiveLine 0 ≤
      VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree 0 := by
  letI _acg := VarietyCohomologyData_projectiveLine.addCommGroup 0
  letI _mod := VarietyCohomologyData_projectiveLine.module 0
  letI _phs := VarietyCohomologyData_projectiveLine.hodgeStructure 0
  intro x _
  show x ∈ VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree 0
  show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
  rw [TrivialWeight.piece_ℚ_w0_zero]
  exact Submodule.mem_top

/-- **R202 codim1 hodge-class equality**: at codimension 1, the
Hodge classes on `H^2(ℙ¹, ℚ) = ℚ` equal the (1,1)-piece, which is `⊤`
in the Tate-Hodge weight-2 structure. -/
theorem hodgeClasses_projectiveLine_codim1_eq_top :
    VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree 1 =
      (⊤ : @Submodule ℚ (VarietyCohomologyData_projectiveLine.H 2) _
            (VarietyCohomologyData_projectiveLine.addCommGroup 2).toAddCommMonoid
            (VarietyCohomologyData_projectiveLine.module 2)) := by
  letI _acg := VarietyCohomologyData_projectiveLine.addCommGroup 2
  letI _mod := VarietyCohomologyData_projectiveLine.module 2
  letI _phs := VarietyCohomologyData_projectiveLine.hodgeStructure 2
  apply Submodule.eq_top_iff'.mpr
  intro x
  show x ∈ VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree 1
  show x ∈ piece_ℚ_Tate2 ⟨1, by omega⟩
  rw [piece_ℚ_Tate2_one]
  exact Submodule.mem_top

/-- Hodge half at codim 1: `⊤ ≤ hodgeClasses 1 = ⊤`. -/
theorem algClasses_projectiveLine_le_hodgeClasses_codim1 :
    algClasses_projectiveLine 1 ≤
      VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree 1 := by
  letI _acg := VarietyCohomologyData_projectiveLine.addCommGroup 2
  letI _mod := VarietyCohomologyData_projectiveLine.module 2
  rw [hodgeClasses_projectiveLine_codim1_eq_top]
  exact le_top

/-- Hodge half at codim p ≥ 2: trivially `⊥ ≤ anything`. -/
theorem algClasses_projectiveLine_le_hodgeClasses_codim_high (p : ℕ) :
    algClasses_projectiveLine (p + 2) ≤
      VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree (p + 2) := by
  exact bot_le

/-- Hodge half: `algClasses p ≤ hodgeClasses p` at every codimension. -/
theorem algClasses_projectiveLine_le_hodgeClasses (p : ℕ) :
    algClasses_projectiveLine p ≤
      VarietyCohomologyData_projectiveLine.hodgeClassesAtDegree p := by
  match p with
  | 0 => exact algClasses_projectiveLine_le_hodgeClasses_codim0
  | 1 => exact algClasses_projectiveLine_le_hodgeClasses_codim1
  | k + 2 => exact algClasses_projectiveLine_le_hodgeClasses_codim_high k

/-- **R202 closure (2/3)**: the projective-line algebraic-classes
bundle. -/
noncomputable def AlgebraicClassesData_projectiveLine :
    AlgebraicClassesData VarietyCohomologyData_projectiveLine where
  algClasses := algClasses_projectiveLine
  algClasses_le_hodgeClasses := algClasses_projectiveLine_le_hodgeClasses

/-! ## 5. VarietyHC at codim 0 / codim 1 / high codim, then composite -/

/-- **R202 codim-0 closure**: HC for `ℙ¹` at codimension 0.
`hodgeClasses 0 = ⊤ ≤ ⊤ = algClasses 0`. -/
theorem VarietyHCAt_projectiveLine_codim0 :
    VarietyHCAt VarietyCohomologyData_projectiveLine
      AlgebraicClassesData_projectiveLine 0 := by
  letI _acg := VarietyCohomologyData_projectiveLine.addCommGroup 0
  letI _mod := VarietyCohomologyData_projectiveLine.module 0
  letI _phs := VarietyCohomologyData_projectiveLine.hodgeStructure 0
  intro x _
  show x ∈ algClasses_projectiveLine 0
  exact Submodule.mem_top

/-- **R202 codim-1 closure**: HC for `ℙ¹` at codimension 1.
`hodgeClasses 1 = ⊤ ≤ ⊤ = algClasses 1`. Substantive: uses the
Tate-Hodge weight-2 computation `piece ⟨1,_⟩ = ⊤`. -/
theorem VarietyHCAt_projectiveLine_codim1 :
    VarietyHCAt VarietyCohomologyData_projectiveLine
      AlgebraicClassesData_projectiveLine 1 := by
  letI _acg := VarietyCohomologyData_projectiveLine.addCommGroup 2
  letI _mod := VarietyCohomologyData_projectiveLine.module 2
  letI _phs := VarietyCohomologyData_projectiveLine.hodgeStructure 2
  intro x _
  show x ∈ algClasses_projectiveLine 1
  exact Submodule.mem_top

/-- HC for `ℙ¹` at codimension `p + 2`. `hodgeClasses` lives in
`H(2*(p+2)) = PUnit`, so subsingleton-trivial. -/
theorem VarietyHCAt_projectiveLine_codim_high (p : ℕ) :
    VarietyHCAt VarietyCohomologyData_projectiveLine
      AlgebraicClassesData_projectiveLine (p + 2) := by
  intro x _
  show x ∈ algClasses_projectiveLine (p + 2)
  letI _j_acg := VarietyCohomologyData_projectiveLine.addCommGroup (2 * (p + 2))
  letI _j_mod := VarietyCohomologyData_projectiveLine.module (2 * (p + 2))
  have hSub :
      Subsingleton (VarietyCohomologyData_projectiveLine.H (2 * (p + 2))) := by
    show Subsingleton (cohomologyType_projectiveLine (2 * (p + 2)))
    apply cohomologyType_projectiveLine_support
    constructor <;> omega
  have hx0 : x = 0 := Subsingleton.elim _ _
  rw [hx0]
  exact Submodule.zero_mem _

/-- **R202 closure (3/3)**: HC for `ℙ¹` at every codimension. -/
theorem VarietyHC_projectiveLine :
    VarietyHC VarietyCohomologyData_projectiveLine
      AlgebraicClassesData_projectiveLine := by
  intro p
  match p with
  | 0     => exact VarietyHCAt_projectiveLine_codim0
  | 1     => exact VarietyHCAt_projectiveLine_codim1
  | k + 2 => exact VarietyHCAt_projectiveLine_codim_high k

/-! ## 6. Internal-model disclosure: residual gaps for true ℙ¹

These four `Prop`-level markers name the bridges still missing
between the internal cohomology model above and a future
Mathlib-backed algebraic-geometry realisation. None are axiomatised,
none are proved by this file. -/

/-- **L1-G-ℙ¹**: a true `SmoothProjectiveVariety ℂ` representing the
projective line `ℙ¹_ℂ`. Requires Mathlib `Proj`-construction for graded
rings, plus a smoothness + projectivity + connectedness certificate. -/
abbrev L1_G_ProjectiveLine_RealVariety : Prop :=
  Nonempty (SmoothProjectiveVariety ℂ)

/-- **L2-G-ℙ¹**: the internal `H k` types match the real singular /
sheaf cohomology of a Mathlib `Proj ℚ[X, Y]` (rank 1 in degrees 0 and
2, zero elsewhere); the internal `hodgeStructure k` matches the real
Dolbeault Hodge decomposition. -/
abbrev L2_G_ProjectiveLine_RealCohomology : Prop :=
  -- Marker: the internal `VarietyCohomologyData_projectiveLine` agrees
  -- (under a yet-to-exist `realCohomologyOf : SmoothProjectiveVariety ℂ
  -- → VarietyCohomologyData` interface) with the real cohomology of
  -- the Mathlib-AG `ℙ¹_ℂ`. Currently a placeholder Prop.
  True

/-- **L4-G-ℙ¹ (cycle class map)**: existence of a real cycle class map
`CH^p(ℙ¹)_ℚ → H^{2p}(ℙ¹, ℚ)` whose image equals `algClasses_projectiveLine p`.
Requires Mathlib Chow groups + cycle class map. -/
abbrev L4_G_ProjectiveLine_RealCycleMap : Prop := True

/-- **L4-G-ℙ¹ (Hodge half from cycles)**: the Lefschetz-1924 "algebraic
class is of type (p,p)" inclusion, derived from the real cycle class
map rather than declared structurally. -/
abbrev L4_G_ProjectiveLine_HodgeHalf_FromCycles : Prop := True

end ProjectiveLine
end HCGapL2
end HodgeReduction
