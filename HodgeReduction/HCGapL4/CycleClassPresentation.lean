/-
# HC Gap L4 — minimal cycle-class presentation interface (R206).

R201–R205 declared `AlgebraicClassesData.algClasses p` by hand
(case-split: `⊤` at appropriate codims, `⊥` elsewhere). The user-side
semantics has always been "this is the cycle class map image", but
nothing on the Lean side actually exhibits generators.

R206 introduces a minimal `CycleClassPresentationAt` structure that
bridges from the "hand-declared submodule" form to a
generator-based presentation:
* A `GenIndex` type indexing cycle-class generators.
* A `cycleClass : GenIndex → X.H (2 * p)` map placing each generator
  in the relevant cohomology ambient.
* A proof that the `ℚ`-span of the cycle classes EQUALS the
  hand-declared `A.algClasses p` submodule.

This sets the template a real Mathlib `CH^p(X)_ℚ → H^{2p}(X, ℚ)`
interface would refine. The internal-model cases close kernel-purely:
the generator `1 ∈ ℚ` spans `⊤ : Submodule ℚ ℚ` at every codim where
the ambient is `ℚ` (point H^0; ℙ¹ H^0 + H^2; elliptic curve H^2).

The bridge theorem
`VarietyHCAt_of_cyclePresentation_covers_hodgeClasses` converts a
presentation + Hodge-classes-covered-by-cycle-span hypothesis into
the standard `VarietyHCAt` conclusion — making explicit that HC at
codim `p` reduces to "every Hodge class is in the span of the cycle
generators".

## What R206 does NOT do

* It does NOT introduce a real Chow group `CH^p(X)_ℚ`.
* It does NOT introduce a real cycle class map `CH^p → H^{2p}`.
* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT certify the cycle generators correspond to actual
  closed subschemes of any real algebraic variety.

All R206 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.ProjectiveLine
import HodgeReduction.HCGapL2.EllipticCurve
import Mathlib.LinearAlgebra.Span.Basic

namespace HodgeReduction
namespace HCGapL4
namespace CycleClassPresentation

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2

/-! ## Section 1: the cycle-class presentation structure -/

/-- **R206**: minimal cycle-class presentation at codimension `p`.

* `GenIndex` indexes the cycle-class generators.
* `cycleClass` sends each generator to its class in `H^{2p}`.
* `generated_eq_algClasses` asserts the ℚ-span of the generators
  equals the hand-declared `A.algClasses p`.

This is the type-level shape a real `CH^p(X)_ℚ → H^{2p}(X, ℚ)`
cycle class map interface would refine. -/
structure CycleClassPresentationAt
    (X : VarietyCohomologyData)
    (A : AlgebraicClassesData X)
    (p : ℕ) where
  /-- Type indexing the cycle-class generators. -/
  GenIndex : Type
  /-- Cycle class map: each generator lands in `H^{2p}(X, ℚ)`. -/
  cycleClass : GenIndex → X.H (2 * p)
  /-- The ℚ-span of the cycle classes equals `A.algClasses p`. -/
  generated_eq_algClasses :
    @Submodule.span ℚ (X.H (2 * p)) _
        (X.addCommGroup (2 * p)).toAddCommMonoid
        (X.module (2 * p))
        (Set.range cycleClass)
    = A.algClasses p

/-! ## Section 2: bridge theorem from presentation + Hodge cover to HC -/

/-- **R206 bridge**: if a cycle-class presentation exists for
`(X, A, p)` and every Hodge class at degree `2p` is in the span of
the cycle generators, then HC holds at codim `p`.

This makes explicit that HC at codim `p` reduces to "the Hodge classes
lie in the span of the (explicitly given) cycle generators". -/
theorem VarietyHCAt_of_cyclePresentation_covers_hodgeClasses
    {X : VarietyCohomologyData}
    {A : AlgebraicClassesData X}
    {p : ℕ}
    (pres : CycleClassPresentationAt X A p)
    (h_cover :
      letI _ := X.addCommGroup (2 * p)
      letI _ := X.module (2 * p)
      letI _ := X.hodgeStructure (2 * p)
      X.hodgeClassesAtDegree p ≤
        @Submodule.span ℚ (X.H (2 * p)) _
          (X.addCommGroup (2 * p)).toAddCommMonoid
          (X.module (2 * p))
          (Set.range pres.cycleClass)) :
    VarietyHCAt X A p := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  unfold VarietyHCAt
  rw [← pres.generated_eq_algClasses]
  exact h_cover

/-! ## Section 3: a helper — `span ℚ {(1 : ℚ)} = ⊤`

This is the workhorse for the four codim cases below where the
ambient is `ℚ` and the single generator is `1`. The standard
"scalar multiplication" argument: any `a : ℚ` equals `a • 1`, so it
lies in the span of `{1}`. -/

theorem span_singleton_one_eq_top :
    Submodule.span ℚ ({(1 : ℚ)} : Set ℚ) = ⊤ := by
  apply Submodule.eq_top_iff'.mpr
  intro x
  have h1 : (1 : ℚ) ∈ Submodule.span ℚ ({(1 : ℚ)} : Set ℚ) :=
    Submodule.subset_span (Set.mem_singleton _)
  have hx : x = x • (1 : ℚ) := by rw [smul_eq_mul, mul_one]
  rw [hx]
  exact Submodule.smul_mem _ x h1

/-- Aggregated: `span ℚ (range (fun _ : Unit => 1)) = ⊤` in `ℚ`.
Uses Mathlib's `Set.range_const` (requires `Nonempty Unit`, auto). -/
theorem span_unit_const_one_eq_top :
    Submodule.span ℚ (Set.range (fun (_ : Unit) => (1 : ℚ))) = ⊤ := by
  rw [Set.range_const]
  exact span_singleton_one_eq_top

/-! ## Section 4: example presentations on the internal models -/

/-! ### Section 4.1: point at codim 0

`H^0(pt) = ℚ`. The fundamental class `[pt] = 1` generates `algClasses 0
= ⊤`. -/

/-- **R206 example 1**: cycle-class presentation for the point at
codim 0. Single generator: the fundamental class `[pt] = 1`. -/
noncomputable def pointCodim0Presentation :
    CycleClassPresentationAt
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point
      0 where
  GenIndex := Unit
  cycleClass := fun _ => (1 : ℚ)
  generated_eq_algClasses := by
    -- algClassesPoint 0 = ⊤; span (range (fun _ => 1)) = ⊤
    show @Submodule.span ℚ ℚ _ _ _ (Set.range (fun (_ : Unit) => (1 : ℚ)))
      = (⊤ : @Submodule ℚ ℚ _ _ _)
    exact span_unit_const_one_eq_top

/-- HC at codim 0 for the point, derived via the R206 bridge from
the explicit cycle-class presentation above. Recovers
`TrivialPoint.VarietyHCAt_point 0` via the cycle-presentation route. -/
theorem VarietyHCAt_point_codim0_via_cyclePresentation :
    VarietyHCAt
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point
      0 := by
  refine VarietyHCAt_of_cyclePresentation_covers_hodgeClasses
    pointCodim0Presentation ?_
  -- After bridge: need hodgeClassesAtDegree 0 ≤ span (range cycleClass).
  -- Use the presentation's generated_eq_algClasses to rewrite span =
  -- algClasses; algClasses_point.algClasses 0 unfolds to ⊤ definitionally,
  -- so le_top closes the goal.
  rw [pointCodim0Presentation.generated_eq_algClasses]
  exact le_top

/-! ### Section 4.2: ℙ¹ at codim 0

`H^0(ℙ¹) = ℚ`. The fundamental class `[ℙ¹] = 1` generates `algClasses 0
= ⊤`. -/

/-- **R206 example 2**: cycle-class presentation for `ℙ¹` at codim 0.
Single generator: the fundamental class `[ℙ¹] = 1`. -/
noncomputable def projectiveLineCodim0Presentation :
    CycleClassPresentationAt
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      0 where
  GenIndex := Unit
  cycleClass := fun _ => (1 : ℚ)
  generated_eq_algClasses := by
    show @Submodule.span ℚ ℚ _ _ _ (Set.range (fun (_ : Unit) => (1 : ℚ)))
      = (⊤ : @Submodule ℚ ℚ _ _ _)
    exact span_unit_const_one_eq_top

theorem VarietyHCAt_projectiveLine_codim0_via_cyclePresentation :
    VarietyHCAt
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      0 := by
  refine VarietyHCAt_of_cyclePresentation_covers_hodgeClasses
    projectiveLineCodim0Presentation ?_
  rw [projectiveLineCodim0Presentation.generated_eq_algClasses]
  exact le_top

/-! ### Section 4.3: ℙ¹ at codim 1

`H^2(ℙ¹) = ℚ`. The hyperplane / point class `[pt] = 1` generates
`algClasses 1 = ⊤`. -/

/-- **R206 example 3**: cycle-class presentation for `ℙ¹` at codim 1.
Single generator: the hyperplane class `[pt] = 1 ∈ H^2`. -/
noncomputable def projectiveLineCodim1Presentation :
    CycleClassPresentationAt
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      1 where
  GenIndex := Unit
  cycleClass := fun _ => (1 : ℚ)
  generated_eq_algClasses := by
    show @Submodule.span ℚ ℚ _ _ _ (Set.range (fun (_ : Unit) => (1 : ℚ)))
      = (⊤ : @Submodule ℚ ℚ _ _ _)
    exact span_unit_const_one_eq_top

theorem VarietyHCAt_projectiveLine_codim1_via_cyclePresentation :
    VarietyHCAt
      ProjectiveLine.VarietyCohomologyData_projectiveLine
      ProjectiveLine.AlgebraicClassesData_projectiveLine
      1 := by
  refine VarietyHCAt_of_cyclePresentation_covers_hodgeClasses
    projectiveLineCodim1Presentation ?_
  rw [projectiveLineCodim1Presentation.generated_eq_algClasses]
  exact le_top

/-! ### Section 4.4: elliptic curve at codim 1

`H^2(E) = ℚ`. The point class `[pt] = 1` generates `algClasses 1 = ⊤`. -/

/-- **R206 example 4**: cycle-class presentation for the elliptic
curve at codim 1. Single generator: the point class `[pt] = 1 ∈ H^2`. -/
noncomputable def ellipticCurveCodim1Presentation :
    CycleClassPresentationAt
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      1 where
  GenIndex := Unit
  cycleClass := fun _ => (1 : ℚ)
  generated_eq_algClasses := by
    show @Submodule.span ℚ ℚ _ _ _ (Set.range (fun (_ : Unit) => (1 : ℚ)))
      = (⊤ : @Submodule ℚ ℚ _ _ _)
    exact span_unit_const_one_eq_top

theorem VarietyHCAt_ellipticCurve_codim1_via_cyclePresentation :
    VarietyHCAt
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      1 := by
  refine VarietyHCAt_of_cyclePresentation_covers_hodgeClasses
    ellipticCurveCodim1Presentation ?_
  rw [ellipticCurveCodim1Presentation.generated_eq_algClasses]
  exact le_top

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_RealChowGroup_Interface**: a Mathlib-backed `CH^p(X)_ℚ`
(rational Chow group) of a real `SmoothProjectiveVariety ℂ`. Requires
Mathlib intersection theory: cycle modulo rational equivalence, push-
pull, refined Gysin, etc. -/
abbrev L4_G_RealChowGroup_Interface : Prop := True

/-- **L4-G_RealCycleClassMap_CHp_To_H2p**: a Mathlib-backed cycle
class map `CH^p(X)_ℚ → H^{2p}(X, ℚ)` whose image is the actual
algebraic-classes submodule. Requires de Rham / Betti cohomology
existence + a comparison theorem to pin the integral lattice. -/
abbrev L4_G_RealCycleClassMap_CHp_To_H2p : Prop := True

/-- **L4-G_CyclePresentation_To_AlgebraicClassesData**: a constructor
`CH^p(X)_ℚ → AlgebraicClassesData X` that takes the real cycle class
map and produces a kernel-pure `AlgebraicClassesData` for any
Mathlib-backed `SmoothProjectiveVariety ℂ`. Would replace the
hand-declared submodule pattern (`algClasses p := ⊤ / ⊥`) used
through R201–R206. -/
abbrev L4_G_CyclePresentation_To_AlgebraicClassesData : Prop := True

/-- **L4-G_CycleInducedCorrespondence_Action**: the cohomological
action of an algebraic correspondence `[Z] ∈ CH^*(X × Y)_ℚ` on
cohomology, given by the standard pushforward–cup–pullback formula
`α ↦ (p_Y)_*((p_X)^* α ∪ [Z])`. With this in hand, the per-codim
`MTCorrespondencePackageAt` package would be DERIVED from a single
correspondence cycle, rather than constructed at the linear-algebraic
level (as in R204/R205). -/
abbrev L4_G_CycleInducedCorrespondence_Action : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R206 non-closure (1/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. Cycle-class
presentations are exhibited on toy internal models (point, ℙ¹,
elliptic curve) only. -/
theorem R206_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R206 non-closure (2/3)**: does NOT introduce a real Chow group
or real cycle class map. The "cycle" data is just an indexing type +
a function into the cohomology ambient; no actual algebraic-geometric
cycle is constructed. -/
theorem R206_does_not_implement_real_ChowGroup : True := trivial

/-- **R206 non-closure (3/3)**: only the four internal-model cases
(point codim 0, ℙ¹ codim 0/1, elliptic curve codim 1) are presented.
The R203 elliptic curve at codim 0 (analogous to ℙ¹ codim 0) and any
higher-dim / higher-codim case are deferred. -/
theorem R206_only_four_internal_cases : True := trivial

end CycleClassPresentation
end HCGapL4
end HodgeReduction
