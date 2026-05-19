/-
# HC Gap L4 — internal product cohomology model `pt × E` (R209).

Algebraic correspondences between varieties `X` and `Y` live as cycle
classes on the product `X × Y`. To make any cycle-induced
`HodgeStructureMorphism` prototype possible (the eventual closure of
`L4_G_CycleInducedCorrespondence_Action`), the L4 infrastructure
needs a `VarietyCohomologyData` for product varieties — not as a
general construction (Künneth across arbitrary smooth-projective
pairs), but for the specific carriers actually used downstream.

R209 builds the **minimum useful product carrier**: the cohomology
of `pt × E` (point times R203 elliptic curve). Geometrically `pt × E ≃ E`
(point is the identity for products), so the cohomology agrees
degree-by-degree with the elliptic curve's; this allows us to **REUSE**
R201/R202/R203/R207's kernel-pure Hodge structures while exhibiting a
LEAN-LEVEL SEPARATE `VarietyCohomologyData` and `CycleClassFamily`
specifically labelled as "the pt × E product carrier" (the distinction
matters once cross-variety correspondences enter).

## What R209 provides (all kernel-pure)

* `VarietyCohomologyData_pointTimesEllipticCurve` — internal product
  VCD: `H^0 = ℚ`, `H^1 = ℚ × ℚ`, `H^2 = ℚ`, `H^k = PUnit` for `k ≥ 3`.
* Hodge structures REUSED from R201/R202/R203/R207 instances.
* A `CycleClassFamily` for pt × E with `[pt × E] ∈ H^0` and
  `[pt × pt_of_E] ∈ H^2` generators.
* `AlgebraicClassesData_pointTimesEllipticCurve` via `ofCycleClassFamily`.
* `VarietyHCAt` at codim 0, 1, codim ≥ 2, and full `VarietyHC`.

## What R209 does NOT do

* It does NOT implement a general Künneth theorem
  `H^*(X × Y) = H^*(X) ⊗ H^*(Y)`.
* It does NOT implement a real scheme-level product `X × Y` in
  Mathlib `AlgebraicGeometry`.
* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT exhibit a cycle-induced `HodgeStructureMorphism`
  derived from a cycle class on the product (deferred to R210+).

All R209 declarations are kernel-pure: `{propext, Classical.choice,
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
namespace ProductCohomology

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.CycleClassPresentation

/-! ## Section 1: cohomology carrier for `pt × E`

Geometrically `pt × E ≃ E`, so the cohomology agrees with the elliptic
curve's degree-by-degree. We construct a FRESH Lean def to keep
`pt × E` and `E` as separate carriers (needed once cross-variety
correspondences enter). -/

/-- Internal cohomology carrier for `pt × E`:
* `H^0 = ℚ` (Künneth: `H^0(pt) ⊗ H^0(E)` ≃ ℚ ⊗ ℚ ≃ ℚ).
* `H^1 = ℚ × ℚ` (Künneth: `H^0(pt) ⊗ H^1(E)` ≃ ℚ ⊗ (ℚ × ℚ) ≃ ℚ × ℚ;
  `H^1(pt)` vanishes so no `H^1 ⊗ H^0` cross-term).
* `H^2 = ℚ` (Künneth: `H^0(pt) ⊗ H^2(E)` ≃ ℚ ⊗ ℚ ≃ ℚ; no cross-terms).
* `H^k = PUnit` for `k ≥ 3` (`pt` has no `H^{≥1}` and `E` has no
  `H^{≥3}`). -/
def cohomologyType_pointTimesEllipticCurve : ℕ → Type
  | 0     => ℚ
  | 1     => ℚ × ℚ
  | 2     => ℚ
  | _ + 3 => PUnit

@[simp] theorem cohomologyType_pointTimesEllipticCurve_zero :
    cohomologyType_pointTimesEllipticCurve 0 = ℚ := rfl

@[simp] theorem cohomologyType_pointTimesEllipticCurve_one :
    cohomologyType_pointTimesEllipticCurve 1 = (ℚ × ℚ) := rfl

@[simp] theorem cohomologyType_pointTimesEllipticCurve_two :
    cohomologyType_pointTimesEllipticCurve 2 = ℚ := rfl

@[simp] theorem cohomologyType_pointTimesEllipticCurve_three_or_more (k : ℕ) :
    cohomologyType_pointTimesEllipticCurve (k + 3) = PUnit := rfl

/-- `H^k(pt × E, ℚ)` is trivial (subsingleton-carrier) outside degrees
0, 1, 2. -/
theorem cohomologyType_pointTimesEllipticCurve_support {k : ℕ}
    (hk : k ≠ 0 ∧ k ≠ 1 ∧ k ≠ 2) :
    Subsingleton (cohomologyType_pointTimesEllipticCurve k) := by
  rcases hk with ⟨hk0, hk1, hk2⟩
  match k, hk0, hk1, hk2 with
  | 0, h0, _, _ => exact absurd rfl h0
  | 1, _, h1, _ => exact absurd rfl h1
  | 2, _, _, h2 => exact absurd rfl h2
  | k + 3, _, _, _ => exact inferInstanceAs (Subsingleton PUnit)

noncomputable def cohomologyType_addCommGroup :
    ∀ k, AddCommGroup (cohomologyType_pointTimesEllipticCurve k)
  | 0     => inferInstanceAs (AddCommGroup ℚ)
  | 1     => inferInstanceAs (AddCommGroup (ℚ × ℚ))
  | 2     => inferInstanceAs (AddCommGroup ℚ)
  | _ + 3 => inferInstanceAs (AddCommGroup PUnit)

noncomputable def cohomologyType_module :
    ∀ k, @Module ℚ (cohomologyType_pointTimesEllipticCurve k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
  | 0     => inferInstanceAs (Module ℚ ℚ)
  | 1     => inferInstanceAs (Module ℚ (ℚ × ℚ))
  | 2     => inferInstanceAs (Module ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module ℚ PUnit)

noncomputable def cohomologyType_finite :
    ∀ k, @Module.Finite ℚ (cohomologyType_pointTimesEllipticCurve k) _
           (cohomologyType_addCommGroup k).toAddCommMonoid
           (cohomologyType_module k)
  | 0     => inferInstanceAs (Module.Finite ℚ ℚ)
  | 1     => inferInstanceAs (Module.Finite ℚ (ℚ × ℚ))
  | 2     => inferInstanceAs (Module.Finite ℚ ℚ)
  | _ + 3 => inferInstanceAs (Module.Finite ℚ PUnit)

/-- **R209 Hodge structure REUSE**: at each `k`, the Hodge structure
on `H^k(pt × E)` is exactly the same instance as on `H^k(E)`:
* `k = 0`: `TrivialWeight.pureHodgeStructure_ℚ_0` (Tate weight 0).
* `k = 1`: `EllipticCurve.pureHodgeStructure_QxQ_w1` (weight-1 splitting
  `H^{1,0} ⊕ H^{0,1}`).
* `k = 2`: `ProjectiveLine.pureHodgeStructure_ℚ_Tate2` (Tate weight 2,
  `H^{1,1} = ⊤`).
* `k ≥ 3`: `TrivialPoint.pureHodgeStructure_PUnit (k + 3)` (trivial). -/
noncomputable def cohomologyType_hodgeStructure :
    ∀ k, @PureHodgeStructure (cohomologyType_pointTimesEllipticCurve k)
           (cohomologyType_addCommGroup k) (cohomologyType_module k) k
  | 0     => TrivialWeight.pureHodgeStructure_ℚ_0
  | 1     => EllipticCurve.pureHodgeStructure_QxQ_w1
  | 2     => ProjectiveLine.pureHodgeStructure_ℚ_Tate2
  | k + 3 => TrivialPoint.pureHodgeStructure_PUnit (k + 3)

/-- **R209 product VCD**: the internal cohomology bundle for `pt × E`. -/
noncomputable def VarietyCohomologyData_pointTimesEllipticCurve :
    VarietyCohomologyData where
  H := cohomologyType_pointTimesEllipticCurve
  addCommGroup := cohomologyType_addCommGroup
  module := cohomologyType_module
  finite := cohomologyType_finite
  hodgeStructure := cohomologyType_hodgeStructure

/-! ## Section 2: scoped typeclass instances (parameterised by `k`)

Pattern from R205/R208: declare `AddCommGroup / Module ℚ` on
`(VarietyCohomologyData_pointTimesEllipticCurve.H k)` at every `k`,
so subsequent defs/proofs at specific codims have the instances
available. -/

noncomputable instance acg_pointTimesEllipticCurve_Hk (k : ℕ) :
    AddCommGroup (VarietyCohomologyData_pointTimesEllipticCurve.H k) :=
  VarietyCohomologyData_pointTimesEllipticCurve.addCommGroup k

noncomputable instance mod_pointTimesEllipticCurve_Hk (k : ℕ) :
    Module ℚ (VarietyCohomologyData_pointTimesEllipticCurve.H k) :=
  VarietyCohomologyData_pointTimesEllipticCurve.module k

/-! ## Section 3: cycle family for `pt × E`

Generators:
* codim 0: `[pt × E] = 1 ∈ H^0 = ℚ` (fundamental class of the product).
* codim 1: `[pt × pt_of_E] = 1 ∈ H^2 = ℚ` (the "point on E" class,
  pushed forward as the codim-1 cycle on pt × E).
* codim `p ≥ 2`: no generators (PEmpty), since `pt × E` is 1-dim and
  has no codim-`p ≥ 2` cycles. -/

def pointTimesEllipticCurveGenIndex : ℕ → Type
  | 0     => Unit
  | 1     => Unit
  | _ + 2 => PEmpty

noncomputable def pointTimesEllipticCurveCycleClass :
    ∀ p, pointTimesEllipticCurveGenIndex p →
      VarietyCohomologyData_pointTimesEllipticCurve.H (2 * p)
  | 0     => fun _ => (1 : ℚ)
  | 1     => fun _ => (1 : ℚ)
  | _ + 2 => fun g => PEmpty.elim g

/-- Hodge-half witnesses for the product's cycle classes. -/
theorem pointTimesEllipticCurveCycleClass_isHodge :
    ∀ p (g : pointTimesEllipticCurveGenIndex p),
      pointTimesEllipticCurveCycleClass p g ∈
        VarietyCohomologyData_pointTimesEllipticCurve.hodgeClassesAtDegree p
  | 0     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_pointTimesEllipticCurve.hodgeClassesAtDegree 0
    show (1 : ℚ) ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact Submodule.mem_top
  | 1     => fun _ => by
    show (1 : ℚ) ∈
      VarietyCohomologyData_pointTimesEllipticCurve.hodgeClassesAtDegree 1
    show (1 : ℚ) ∈ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact Submodule.mem_top
  | _ + 2 => fun g => PEmpty.elim g

/-- **R209 product cycle family**. -/
noncomputable def pointTimesEllipticCurveCycleClassFamily :
    CycleClassFamily VarietyCohomologyData_pointTimesEllipticCurve where
  GenIndex := pointTimesEllipticCurveGenIndex
  cycleClass := pointTimesEllipticCurveCycleClass
  cycleClass_isHodge := pointTimesEllipticCurveCycleClass_isHodge

/-! ## Section 4: product `AlgebraicClassesData` via `ofCycleClassFamily` -/

/-- **R209 product ACD**: derived from the product cycle family via
the R207 `ofCycleClassFamily` constructor. The hand-written ACD
route from R201-R203 is NOT used; the family-derived path is the
only one exhibited for the product carrier. -/
noncomputable def AlgebraicClassesData_pointTimesEllipticCurve :
    AlgebraicClassesData VarietyCohomologyData_pointTimesEllipticCurve :=
  AlgebraicClassesData.ofCycleClassFamily pointTimesEllipticCurveCycleClassFamily

/-! ## Section 5: VHC per codim + full -/

/-- HC at codim 0 for `pt × E`. Via the R207 bridge:
hodgeClasses 0 (= ⊤) ≤ span(range cycleClass 0) (= ⊤). -/
theorem VarietyHCAt_pointTimesEllipticCurve_codim0 :
    VarietyHCAt VarietyCohomologyData_pointTimesEllipticCurve
      AlgebraicClassesData_pointTimesEllipticCurve 0 := by
  apply VarietyHCAt_ofCycleClassFamily_cover
    pointTimesEllipticCurveCycleClassFamily
  show VarietyCohomologyData_pointTimesEllipticCurve.hodgeClassesAtDegree 0 ≤
    @Submodule.span ℚ ℚ _ _ _ (Set.range (fun _ : Unit => (1 : ℚ)))
  rw [span_unit_const_one_eq_top]
  exact le_top

/-- HC at codim 1 for `pt × E`. Substantive: uses the Tate-Hodge
weight-2 piece-1 computation on `H^2 = ℚ`. -/
theorem VarietyHCAt_pointTimesEllipticCurve_codim1 :
    VarietyHCAt VarietyCohomologyData_pointTimesEllipticCurve
      AlgebraicClassesData_pointTimesEllipticCurve 1 := by
  apply VarietyHCAt_ofCycleClassFamily_cover
    pointTimesEllipticCurveCycleClassFamily
  show VarietyCohomologyData_pointTimesEllipticCurve.hodgeClassesAtDegree 1 ≤
    @Submodule.span ℚ ℚ _ _ _ (Set.range (fun _ : Unit => (1 : ℚ)))
  rw [span_unit_const_one_eq_top]
  exact le_top

/-- HC at codim ≥ 2 for `pt × E`. The ambient `H^{2*(p+2)} = PUnit`
is subsingleton, so every element is `0` and lies in `⊥`. -/
theorem VarietyHCAt_pointTimesEllipticCurve_codim_high (p : ℕ) :
    VarietyHCAt VarietyCohomologyData_pointTimesEllipticCurve
      AlgebraicClassesData_pointTimesEllipticCurve (p + 2) := by
  intro x _
  show x ∈ (AlgebraicClassesData.ofCycleClassFamily
              pointTimesEllipticCurveCycleClassFamily).algClasses (p + 2)
  rw [ofCycleClassFamily_algClasses_eq_span]
  have hSub :
      Subsingleton (VarietyCohomologyData_pointTimesEllipticCurve.H (2 * (p + 2))) := by
    show Subsingleton (cohomologyType_pointTimesEllipticCurve (2 * (p + 2)))
    apply cohomologyType_pointTimesEllipticCurve_support
    refine ⟨?_, ?_, ?_⟩ <;> omega
  have hx0 : x = 0 := Subsingleton.elim _ _
  rw [hx0]
  exact Submodule.zero_mem _

/-- **R209 milestone**: full HC for `pt × E` at every codimension. -/
theorem VarietyHC_pointTimesEllipticCurve :
    VarietyHC VarietyCohomologyData_pointTimesEllipticCurve
      AlgebraicClassesData_pointTimesEllipticCurve := by
  intro p
  match p with
  | 0     => exact VarietyHCAt_pointTimesEllipticCurve_codim0
  | 1     => exact VarietyHCAt_pointTimesEllipticCurve_codim1
  | k + 2 => exact VarietyHCAt_pointTimesEllipticCurve_codim_high k

/-! ## Section 6: degree-wise Hodge-piece agreement with elliptic curve

The product carrier is built to AGREE with the elliptic-curve carrier
degree-by-degree. We record the agreement as Lean theorems to make
explicit that the same Hodge structures are in use. -/

/-- The H^k carriers of `pt × E` and `E` agree as Lean types. -/
theorem cohomologyType_pointTimesEllipticCurve_eq_ellipticCurve (k : ℕ) :
    cohomologyType_pointTimesEllipticCurve k =
    EllipticCurve.cohomologyType_ellipticCurve k := by
  match k with
  | 0     => rfl
  | 1     => rfl
  | 2     => rfl
  | _ + 3 => rfl

/-- The H^1 Hodge structure on `pt × E` IS the elliptic curve's
weight-1 splitting `H^{1,0} ⊕ H^{0,1}` (literal instance reuse). -/
theorem hodgeStructure_pointTimesEllipticCurve_H1_is_elliptic_w1 :
    cohomologyType_hodgeStructure 1 = EllipticCurve.pureHodgeStructure_QxQ_w1 :=
  rfl

/-- The H^2 Hodge structure on `pt × E` is the Tate weight-2 structure
on ℚ (piece ⟨1,_⟩ = ⊤). -/
theorem hodgeStructure_pointTimesEllipticCurve_H2_is_Tate :
    cohomologyType_hodgeStructure 2 = ProjectiveLine.pureHodgeStructure_ℚ_Tate2 :=
  rfl

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ProductCohomology_GeneralKunneth**: a general Künneth
construction `H^*(X × Y) = H^*(X) ⊗ H^*(Y)` taking two
`VarietyCohomologyData` bundles and producing a third for the
product. R209 only constructs the specific `pt × E` carrier; a
general Künneth requires Mathlib tensor products on the cohomology
types plus a definition of how Hodge bigradings on a tensor product
decompose. -/
abbrev L4_G_ProductCohomology_GeneralKunneth : Prop := True

/-- **L4-G_ProductCohomology_TrueSchemeProduct**: a real Mathlib
`AlgebraicGeometry.Scheme`-level product `X × Y` plus a
`VarietyCohomologyData` for it derived from the actual scheme-level
cohomology. R209's `pt × E` is constructed at the cohomology TYPE
level, NOT at the scheme level. -/
abbrev L4_G_ProductCohomology_TrueSchemeProduct : Prop := True

/-- **L4-G_CycleOnProduct_To_CorrespondenceAction**: given a
`CycleClassFamily` on `VarietyCohomologyData_pointTimesEllipticCurve`
(R209's product VCD), produce a `HodgeStructureMorphism` from
`H^*(pt)` to `H^*(E)` via the standard pushforward-cup-pullback
formula `α ↦ (p_E)_*((p_pt)^* α ∪ [Z])`. This is the next-round
target (R210+) and the key step toward cycle-induced MT
correspondence packages. -/
abbrev L4_G_CycleOnProduct_To_CorrespondenceAction : Prop := True

/-- **L4-G_ProductCycleClassMap_From_Chow**: once a real
`CH^p(X × Y)_ℚ` (Chow group of the product) is available, the
product `AlgebraicClassesData` becomes the image of the cycle class
map `CH^p(X × Y)_ℚ → H^{2p}(X × Y, ℚ)`. R209's hand-built
generator-based path is the kernel-pure prototype. -/
abbrev L4_G_ProductCycleClassMap_From_Chow : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R209 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R209_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R209 non-closure (2/4)**: does NOT implement a general
Künneth theorem on arbitrary variety-cohomology pairs. Only the
specific `pt × E` carrier is built. -/
theorem R209_does_not_implement_general_Kunneth : True := trivial

/-- **R209 non-closure (3/4)**: does NOT implement a real Mathlib
scheme-level product `X × Y` of `SmoothProjectiveVariety ℂ`. The
construction is at the cohomology TYPE level only. -/
theorem R209_does_not_implement_real_scheme_product : True := trivial

/-- **R209 non-closure (4/4)**: does NOT exhibit a cycle-induced
`HodgeStructureMorphism` derived from a cycle on the product. R209
builds only the carrier; the cycle-to-morphism step is the next
round target (R210+). -/
theorem R209_does_not_close_cycle_induced_HSM : True := trivial

end ProductCohomology
end HCGapL4
end HodgeReduction
