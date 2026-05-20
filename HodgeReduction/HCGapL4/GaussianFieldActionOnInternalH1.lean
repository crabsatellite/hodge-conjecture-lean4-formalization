/-
# HC Gap L4 — Gaussian field action on the internal H¹ = ℚ × ℚ (R345).

R335 built `GaussianFieldPairCarrier`, R339 built `GaussianFieldPair_i`,
R342 built the master AlgEquiv
`GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`.

R345 constructs the **source-side Gaussian field action on the project's
internal H¹ model** — namely the `ℚ`-vector space `ℚ × ℚ` (R203), with
the convention that the first coordinate is `H^{1,0}` and the second is
`H^{0,1}`. For `z = ⟨a, b⟩ ∈ GaussianFieldPairCarrier` we define the
`ℚ`-linear map `z • (v₁, v₂) = (a*v₁ - b*v₂, b*v₁ + a*v₂)`. This is
exactly the standard ℚ-linear action of `a + bi ∈ ℚ(i)` on `ℚ² = ℝ²`
viewed as a real vector space (with `i` acting as the 90° rotation
matrix `[[0,-1],[1,0]]`).

## Strategic anchor

Mathlib has no usable singular / de Rham / étale cohomology functor for
elliptic curves at the level required by
`canonicalE7ShimuraTor.mtCorrespondencePackage`. The project's
work-around (R203) is to use the **internal H¹ model** `ℚ × ℚ` with the
Hodge decomposition baked into the coordinates. R345 builds the Gaussian
field action on that internal model — the precise cohomology-level
ring-action evidence consumed by `mtCorrespondencePackage`. The bridge
between this internal model and any real Mathlib cohomology functor for
elliptic curves is recorded as an explicit gap (Section 9), not closed
in this round.

## What R345 (this file) provides (all kernel-pure)

* `GaussianFieldPair_to_H1LinearMap z : (ℚ × ℚ) →ₗ[ℚ] (ℚ × ℚ)` — the
  pair-level `ℚ`-linear action of `z = ⟨a, b⟩`.
* `_one`, `_zero`, `_add`, `_mul` — ring-hom-like preservation of the
  pair-level action.
* `_i_sq` — the imaginary unit squares to `-LinearMap.id` (the
  `T² + 1 = 0` characteristic at the LinearMap level).
* `GaussianField_to_H1LinearMap z : (ℚ × ℚ) →ₗ[ℚ] (ℚ × ℚ)` — the
  field-level action via the R342 AlgEquiv.
* `_map_one`, `_map_add`, `_map_mul` — ring-hom-like preservation at the
  field level.
* `L4-G` disclosure markers for the Mathlib-cohomology-functor blocker
  + internal-vs-real H¹ disclosure.
* Status / non-closure markers.

## What R345 does NOT do

* Does NOT construct a real Mathlib cohomology functor for elliptic
  curves (no such functor available at this level — see Section 9).
* Does NOT prove the Hodge-decomposition compatibility of the action
  on the internal H¹ (R346+ target).
* Does NOT prove cycle-class equivariance (R347+ target).
* Does NOT construct full algebraic `End⁰(E_K)`.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`;
`:= True` reserved for markers / status / non-closure / blocker only.
-/

import HodgeReduction.HCGapL4.GaussianRationalPairAlgEquiv
import HodgeReduction.HCGapL4.GaussianPairAdjoinRootAlgHom
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Module.Prod
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.LinearAlgebra.BilinearMap

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: the pair-level `ℚ`-linear action

For `z = ⟨a, b⟩ ∈ GaussianFieldPairCarrier`, the standard action of
`a + bi ∈ ℚ(i)` on `ℚ² = ℝ²` (viewing the second coord as the
imaginary axis) is `(a + bi)(v₁ + v₂·i) = (a*v₁ - b*v₂) + (b*v₁ +
a*v₂)·i`. As a 2×2 real matrix this is `[[a, -b], [b, a]]`. We package
this as a `ℚ`-linear map on `ℚ × ℚ`. -/

/-- **R345** the pair-level `ℚ`-linear action of `z = ⟨a, b⟩` on
`ℚ × ℚ`: `z • (v₁, v₂) = (a*v₁ - b*v₂, b*v₁ + a*v₂)`. This is the
standard ℚ-linear action of `a + bi ∈ ℚ(i)` on `ℚ² = ℝ²` (with `i`
acting as the 90° rotation matrix `[[0,-1],[1,0]]`). -/
noncomputable def GaussianFieldPair_to_H1LinearMap
    (z : GaussianFieldPairCarrier) :
    (ℚ × ℚ) →ₗ[ℚ] (ℚ × ℚ) where
  toFun v := (z.re * v.1 - z.im * v.2, z.im * v.1 + z.re * v.2)
  map_add' u v := by
    apply Prod.ext
    · show z.re * (u.1 + v.1) - z.im * (u.2 + v.2)
          = (z.re * u.1 - z.im * u.2) + (z.re * v.1 - z.im * v.2)
      ring
    · show z.im * (u.1 + v.1) + z.re * (u.2 + v.2)
          = (z.im * u.1 + z.re * u.2) + (z.im * v.1 + z.re * v.2)
      ring
  map_smul' c v := by
    apply Prod.ext
    · show z.re * (c * v.1) - z.im * (c * v.2)
          = c * (z.re * v.1 - z.im * v.2)
      ring
    · show z.im * (c * v.1) + z.re * (c * v.2)
          = c * (z.im * v.1 + z.re * v.2)
      ring

/-! ## Section 2: pointwise apply lemma -/

/-- **R345** pointwise unfold of the pair-level action at `(v₁, v₂)`. -/
@[simp] theorem GaussianFieldPair_to_H1LinearMap_apply
    (z : GaussianFieldPairCarrier) (v : ℚ × ℚ) :
    GaussianFieldPair_to_H1LinearMap z v
      = (z.re * v.1 - z.im * v.2, z.im * v.1 + z.re * v.2) := rfl

/-! ## Section 3: identity preservation (one ↦ LinearMap.id) -/

/-- **R345** the pair-level action of `1 ∈ GaussianFieldPairCarrier`
is the identity `LinearMap.id`. Reason: `1 = ⟨1, 0⟩`, so the action
becomes `(1*v.1 - 0*v.2, 0*v.1 + 1*v.2) = (v.1, v.2) = v`. -/
theorem GaussianFieldPair_to_H1LinearMap_one :
    GaussianFieldPair_to_H1LinearMap 1 = LinearMap.id := by
  refine LinearMap.ext (fun v => ?_)
  apply Prod.ext
  · show (1 : GaussianFieldPairCarrier).re * v.1
          - (1 : GaussianFieldPairCarrier).im * v.2 = v.1
    rw [GaussianFieldPairCarrier.one_re, GaussianFieldPairCarrier.one_im]
    ring
  · show (1 : GaussianFieldPairCarrier).im * v.1
          + (1 : GaussianFieldPairCarrier).re * v.2 = v.2
    rw [GaussianFieldPairCarrier.one_re, GaussianFieldPairCarrier.one_im]
    ring

/-! ## Section 4: zero preservation -/

/-- **R345** the pair-level action of `0 ∈ GaussianFieldPairCarrier`
is the zero map. -/
theorem GaussianFieldPair_to_H1LinearMap_zero :
    GaussianFieldPair_to_H1LinearMap 0 = 0 := by
  refine LinearMap.ext (fun v => ?_)
  apply Prod.ext
  · show (0 : GaussianFieldPairCarrier).re * v.1
          - (0 : GaussianFieldPairCarrier).im * v.2 = 0
    rw [GaussianFieldPairCarrier.zero_re, GaussianFieldPairCarrier.zero_im]
    ring
  · show (0 : GaussianFieldPairCarrier).im * v.1
          + (0 : GaussianFieldPairCarrier).re * v.2 = 0
    rw [GaussianFieldPairCarrier.zero_re, GaussianFieldPairCarrier.zero_im]
    ring

/-! ## Section 5: additivity -/

/-- **R345** the pair-level action preserves addition:
`(z + w) • v = z • v + w • v`. -/
theorem GaussianFieldPair_to_H1LinearMap_add (z w : GaussianFieldPairCarrier) :
    GaussianFieldPair_to_H1LinearMap (z + w)
      = GaussianFieldPair_to_H1LinearMap z
        + GaussianFieldPair_to_H1LinearMap w := by
  refine LinearMap.ext (fun v => ?_)
  apply Prod.ext
  · show (z + w).re * v.1 - (z + w).im * v.2
       = (z.re * v.1 - z.im * v.2) + (w.re * v.1 - w.im * v.2)
    rw [GaussianFieldPairCarrier.add_re, GaussianFieldPairCarrier.add_im]
    ring
  · show (z + w).im * v.1 + (z + w).re * v.2
       = (z.im * v.1 + z.re * v.2) + (w.im * v.1 + w.re * v.2)
    rw [GaussianFieldPairCarrier.add_re, GaussianFieldPairCarrier.add_im]
    ring

/-! ## Section 6: multiplicativity (most important)

The key identity: `(a + bi)(c + di)(v) = (a + bi)(cv₁ - dv₂, dv₁ + cv₂)
= ((ac-bd)v₁ - (ad+bc)v₂, (ad+bc)v₁ + (ac-bd)v₂)`, which equals the
action of `((ac-bd) + (ad+bc)i) = (a+bi)*(c+di)` on `v`. -/

/-- **R345** the pair-level action preserves multiplication:
the action of `z * w` equals the composition of the actions. -/
theorem GaussianFieldPair_to_H1LinearMap_mul (z w : GaussianFieldPairCarrier) :
    GaussianFieldPair_to_H1LinearMap (z * w)
      = (GaussianFieldPair_to_H1LinearMap z).comp
          (GaussianFieldPair_to_H1LinearMap w) := by
  refine LinearMap.ext (fun v => ?_)
  apply Prod.ext
  · show (z * w).re * v.1 - (z * w).im * v.2
       = z.re * (w.re * v.1 - w.im * v.2)
          - z.im * (w.im * v.1 + w.re * v.2)
    rw [GaussianFieldPairCarrier.mul_re, GaussianFieldPairCarrier.mul_im]
    ring
  · show (z * w).im * v.1 + (z * w).re * v.2
       = z.im * (w.re * v.1 - w.im * v.2)
          + z.re * (w.im * v.1 + w.re * v.2)
    rw [GaussianFieldPairCarrier.mul_re, GaussianFieldPairCarrier.mul_im]
    ring

/-! ## Section 7: `i² = -id` (the `T² + 1 = 0` characteristic)

This is the LinearMap-level shadow of `GaussianFieldPair_i_sq_eq_neg_one`:
the pair imaginary unit `(0, 1)` acts as the 90° rotation, and its
square is `-id` (rotation by 180°). -/

/-- **R345** the pair-level action of `GaussianFieldPair_i` squares to
`-LinearMap.id`. This is the `T² + 1 = 0` characteristic at the
LinearMap level. -/
theorem GaussianFieldPair_to_H1LinearMap_i_sq :
    (GaussianFieldPair_to_H1LinearMap GaussianFieldPair_i).comp
        (GaussianFieldPair_to_H1LinearMap GaussianFieldPair_i)
      = -LinearMap.id := by
  rw [← GaussianFieldPair_to_H1LinearMap_mul,
      GaussianFieldPair_i_sq_eq_neg_one]
  refine LinearMap.ext (fun v => ?_)
  apply Prod.ext
  · show ((-1 : GaussianFieldPairCarrier)).re * v.1
          - ((-1 : GaussianFieldPairCarrier)).im * v.2
        = (-LinearMap.id (R := ℚ) (M := ℚ × ℚ) v).1
    rw [GaussianFieldPairCarrier.neg_re, GaussianFieldPairCarrier.neg_im,
        GaussianFieldPairCarrier.one_re, GaussianFieldPairCarrier.one_im]
    show (-(1 : ℚ)) * v.1 - (-(0 : ℚ)) * v.2 = -v.1
    ring
  · show ((-1 : GaussianFieldPairCarrier)).im * v.1
          + ((-1 : GaussianFieldPairCarrier)).re * v.2
        = (-LinearMap.id (R := ℚ) (M := ℚ × ℚ) v).2
    rw [GaussianFieldPairCarrier.neg_re, GaussianFieldPairCarrier.neg_im,
        GaussianFieldPairCarrier.one_re, GaussianFieldPairCarrier.one_im]
    show (-(0 : ℚ)) * v.1 + (-(1 : ℚ)) * v.2 = -v.2
    ring

/-! ## Section 8: field-level action via R342 AlgEquiv

Pre-composing the pair-level action with the R342 AlgEquiv
`GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier` gives
the field-level action of `ℚ(i) = GaussianRationalFieldCandidate` on
the internal H¹ model `ℚ × ℚ`. -/

/-- **R345** the Gaussian field action on the internal H¹ = `ℚ × ℚ`,
obtained from the pair-level action via the R342 AlgEquiv. -/
noncomputable def GaussianField_to_H1LinearMap
    (z : GaussianRationalFieldCandidate) :
    (ℚ × ℚ) →ₗ[ℚ] (ℚ × ℚ) :=
  GaussianFieldPair_to_H1LinearMap
    (GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair z)

/-- **R345** the field-level action sends `1` to the identity. -/
theorem GaussianField_to_H1LinearMap_map_one :
    GaussianField_to_H1LinearMap 1 = LinearMap.id := by
  unfold GaussianField_to_H1LinearMap
  rw [map_one]
  exact GaussianFieldPair_to_H1LinearMap_one

/-- **R345** the field-level action preserves addition. -/
theorem GaussianField_to_H1LinearMap_map_add
    (x y : GaussianRationalFieldCandidate) :
    GaussianField_to_H1LinearMap (x + y)
      = GaussianField_to_H1LinearMap x + GaussianField_to_H1LinearMap y := by
  unfold GaussianField_to_H1LinearMap
  rw [map_add]
  exact GaussianFieldPair_to_H1LinearMap_add _ _

/-- **R345** the field-level action preserves multiplication. -/
theorem GaussianField_to_H1LinearMap_map_mul
    (x y : GaussianRationalFieldCandidate) :
    GaussianField_to_H1LinearMap (x * y)
      = (GaussianField_to_H1LinearMap x).comp
          (GaussianField_to_H1LinearMap y) := by
  unfold GaussianField_to_H1LinearMap
  rw [map_mul]
  exact GaussianFieldPair_to_H1LinearMap_mul _ _

/-! ## Section 9: Mathlib cohomology functor blocker / disclosure -/

/-- **R345 blocker**: Mathlib has no usable singular / de Rham / étale
cohomology functor for elliptic curves at this level. Replacement
strategy: use the project's internal H¹ model (`ℚ × ℚ` from R203),
which packages the Hodge decomposition into the two coordinates. -/
def BlockingLemma_R345_Mathlib_No_Cohomology_Functor : Prop := True

/-- **R345 disclosure**: this builds the GAUSSIAN FIELD action on the
INTERNAL R203 H¹ model `ℚ × ℚ`, not on the real `H¹(E_K, ℚ)` (which
would require a functorial cohomology theory Mathlib does not provide
at the level needed). The internal model carries the same algebraic
structure used by `mtCorrespondencePackage`; the bridge to a real
Mathlib cohomology functor remains an explicit gap. -/
def L4_G_GaussianFieldActionOnInternalH1_InternalModel_NotRealH1 :
    Prop := True

/-! ## Section 10: status / `L4-G` markers / explicit non-closure -/

/-- **R345 status**: the pair-level `ℚ`-linear action is defined. -/
def R345_Status_PairLinearMap_Defined : Prop := True

/-- **R345 status**: addition-preservation of the pair-level action
is closed. -/
def R345_Status_PairLinearMap_Add_Closed : Prop := True

/-- **R345 status**: multiplication-preservation of the pair-level
action is closed. -/
def R345_Status_PairLinearMap_Mul_Closed : Prop := True

/-- **R345 status**: `i² = -id` at the LinearMap level is closed. -/
def R345_Status_PairLinearMap_I_Sq_Closed : Prop := True

/-- **R345 status**: the field-level action
`GaussianField_to_H1LinearMap` is defined. -/
def R345_Status_GaussianField_to_H1LinearMap_Defined : Prop := True

/-- **R345 status**: the field-level action's three ring-hom-like
preservation theorems (`_map_one`, `_map_add`, `_map_mul`) are closed. -/
def R345_Status_GaussianField_to_H1LinearMap_Hom_Closed : Prop := True

/-- **L4-G** bridge from R345 (internal H¹ action) to a future
Hodge-decomposition compatibility statement (R346+ target): the action
of `i` should split `ℚ × ℚ` into the `+i` and `-i` eigenspaces
matching `H^{1,0}` and `H^{0,1}`. -/
def L4_G_GaussianFieldActionOnInternalH1_To_HodgeDecomp : Prop := True

/-- **L4-G** bridge from R345 to a future cycle-class equivariance
statement (R347+ target): the action commutes with the cycle-class
map at the internal H² level. -/
def L4_G_GaussianFieldActionOnInternalH1_To_CycleClassEquivariance :
    Prop := True

/-- **L4-G** bridge from R345 to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R345 supplies the
cohomology-level ring-action evidence (on the internal H¹) that the
package consumes; the bridge between the internal model and a real
Mathlib cohomology functor remains an explicit gap. -/
def L4_G_GaussianFieldActionOnInternalH1_To_mtCorrespondencePackage :
    Prop := True

/-- **R345 non-closure (1/3)**: does NOT construct a real Mathlib
cohomology action — only the internal R203 H¹ = `ℚ × ℚ` model action.
A real cohomology functor for elliptic curves is unavailable at the
required level. -/
theorem R345_does_not_construct_real_cohomology_action : True := trivial

/-- **R345 non-closure (2/3)**: does NOT construct full algebraic
`End⁰(E_K)`. R345 supplies the internal H¹ action; the algebraic
endomorphism ring `End⁰` is downstream. -/
theorem R345_does_not_construct_End0 : True := trivial

/-- **R345 non-closure (3/3)**: does NOT close `canonicalE7ShimuraTor`
(the active HC cone field). R345 supplies one structural ingredient
along the R327-R345+ chain. -/
theorem R345_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
