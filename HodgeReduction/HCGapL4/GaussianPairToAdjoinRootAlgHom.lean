/-
# HC Gap L4 — `GaussianFieldPairCarrier →ₐ[ℚ] AdjoinRoot (X²+1)` (R340).

R339 supplied the forward AlgHom `GaussianAdjoinRootCandidate →ₐ[ℚ]
GaussianFieldPairCarrier` via the universal property of `AdjoinRoot`
(`AdjoinRoot.liftHom`). R340 supplies the **reverse** AlgHom
`GaussianFieldPairCarrier →ₐ[ℚ] GaussianAdjoinRootCandidate`,
constructed directly by the formula
`⟨a, b⟩ ↦ algebraMap ℚ _ a + algebraMap ℚ _ b * AdjoinRoot.root`.

Together R339 + R340 will give (via R341/R342) the full algebra
equivalence `GaussianAdjoinRootCandidate ≃ₐ[ℚ]
GaussianFieldPairCarrier`. Composed with R286
(`GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate`)
this gives `ℚ(i) ≃ₐ[ℚ] GaussianFieldPairCarrier`, i.e. the carrier
equivalence needed for the Gaussian-field action consumed by
`canonicalE7ShimuraTor.mtCorrespondencePackage`.

## Strategic anchor

R340 is the reverse half of the algebra equivalence `pair ≃ₐ[ℚ]
AdjoinRoot`. Together with R339 + R286, the chain `ℚ(i) ≃ pair`
constructs the carrier equivalence consumed by
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R335 builds the
embedding `pair → PointEndHomQ`; R340 supplies the missing reverse
direction of the algebra equivalence that promotes the embedding into
a true `ℚ(i)`-action.

## Mathlib API used

* `Mathlib.RingTheory.AdjoinRoot.eval₂_root` (`AdjoinRoot.lean:214`) —
  `f.eval₂ (of f) (root f) = 0`. We use it to derive `root² = -1`.
* `Mathlib.Algebra.Algebra.Defs.Algebra.algebraMap_eq_smul_one`
  (`Defs.lean:268`) — `algebraMap R A r = r • (1 : A)`.

## What R340 (this file) provides (all kernel-pure)

* `GaussianAdjoinRoot_root_sq_eq_neg_one` — `root² = -1` in
  AdjoinRoot via `GaussianAdjoinRoot_root_sq_add_one` (R280).
* `GaussianFieldPair_to_GaussianAdjoinRoot_fun` — the candidate
  function `⟨a, b⟩ ↦ a + b · root`.
* Pointwise unfold lemmas.
* `_zero / _one / _add / _mul` preservation theorems (all closed).
* `algebraMap_GaussianFieldPair_re` / `_im` — the canonical
  `algebraMap ℚ` evaluates to `⟨q, 0⟩` componentwise (used in
  `commutes'`).
* `GaussianFieldPair_to_GaussianAdjoinRoot` — the packaged AlgHom.
* `GaussianFieldPair_to_GaussianAdjoinRoot_pair_i` — the AlgHom
  sends `GaussianFieldPair_i` (the R339 imaginary unit) to
  `AdjoinRoot.root`.
* `L4-G` disclosure markers + status + non-closure markers.

## What R340 does NOT do

* Does NOT construct the full `AlgEquiv` (R341/R342 target).
* Does NOT define the `ℚ(i)`-action on `PointEndHomQ`.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.

All R340 declarations are kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`;
`:= True` reserved for markers / status / non-closure only.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianFieldSubringCommRing
import HodgeReduction.HCGapL4.GaussianPairAdjoinRootAlgHom
import Mathlib.RingTheory.AdjoinRoot

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open Polynomial

/-! ## Section 1: `root² = -1` in AdjoinRoot

From R280 we have `(root)² + 1 = 0` (the relation imposed by the
quotient defining `AdjoinRoot (X² + 1)`). Subtracting `1` gives
`root² = -1`. -/

/-- **R340** in `AdjoinRoot (X² + 1 : ℚ[X])`, the canonical `root`
satisfies `root² = -1`. Proof: R280 supplies `root² + 1 = 0`; subtract
`1` from both sides via `eq_neg_of_add_eq_zero_left`. -/
theorem GaussianAdjoinRoot_root_sq_eq_neg_one :
    (AdjoinRoot.root GaussianPolynomialOverQ)^2
      = (-1 : GaussianAdjoinRootCandidate) :=
  eq_neg_of_add_eq_zero_left GaussianAdjoinRoot_root_sq_add_one

/-! ## Section 2: the candidate function `⟨a, b⟩ ↦ a + b · root` -/

/-- **R340** the candidate function `GaussianFieldPairCarrier →
GaussianAdjoinRootCandidate` sending `⟨a, b⟩` to
`algebraMap ℚ _ a + algebraMap ℚ _ b * AdjoinRoot.root`. -/
noncomputable def GaussianFieldPair_to_GaussianAdjoinRoot_fun
    (p : GaussianFieldPairCarrier) : GaussianAdjoinRootCandidate :=
  algebraMap ℚ GaussianAdjoinRootCandidate p.re
    + algebraMap ℚ GaussianAdjoinRootCandidate p.im
        * AdjoinRoot.root GaussianPolynomialOverQ

/-- **R340** pointwise unfold at an explicit pair. -/
@[simp] theorem GaussianFieldPair_to_GaussianAdjoinRoot_fun_apply
    (a b : ℚ) :
    GaussianFieldPair_to_GaussianAdjoinRoot_fun ⟨a, b⟩
      = algebraMap ℚ GaussianAdjoinRootCandidate a
        + algebraMap ℚ GaussianAdjoinRootCandidate b
            * AdjoinRoot.root GaussianPolynomialOverQ := rfl

/-! ## Section 3: preservation of `0`, `1`, `+`, `*` -/

/-- **R340** the candidate function sends `0` to `0`. -/
theorem GaussianFieldPair_to_GaussianAdjoinRoot_fun_zero :
    GaussianFieldPair_to_GaussianAdjoinRoot_fun 0 = 0 := by
  show algebraMap ℚ GaussianAdjoinRootCandidate (0 : GaussianFieldPairCarrier).re
        + algebraMap ℚ GaussianAdjoinRootCandidate (0 : GaussianFieldPairCarrier).im
            * AdjoinRoot.root GaussianPolynomialOverQ = 0
  rw [GaussianFieldPairCarrier.zero_re, GaussianFieldPairCarrier.zero_im,
      map_zero]
  ring

/-- **R340** the candidate function sends `1` to `1`. -/
theorem GaussianFieldPair_to_GaussianAdjoinRoot_fun_one :
    GaussianFieldPair_to_GaussianAdjoinRoot_fun 1 = 1 := by
  show algebraMap ℚ GaussianAdjoinRootCandidate (1 : GaussianFieldPairCarrier).re
        + algebraMap ℚ GaussianAdjoinRootCandidate (1 : GaussianFieldPairCarrier).im
            * AdjoinRoot.root GaussianPolynomialOverQ = 1
  rw [GaussianFieldPairCarrier.one_re, GaussianFieldPairCarrier.one_im,
      map_zero, map_one, zero_mul, add_zero]

/-- **R340** the candidate function preserves addition. -/
theorem GaussianFieldPair_to_GaussianAdjoinRoot_fun_add
    (p q : GaussianFieldPairCarrier) :
    GaussianFieldPair_to_GaussianAdjoinRoot_fun (p + q)
      = GaussianFieldPair_to_GaussianAdjoinRoot_fun p
        + GaussianFieldPair_to_GaussianAdjoinRoot_fun q := by
  show algebraMap ℚ GaussianAdjoinRootCandidate (p + q).re
        + algebraMap ℚ GaussianAdjoinRootCandidate (p + q).im
            * AdjoinRoot.root GaussianPolynomialOverQ
      = (algebraMap ℚ GaussianAdjoinRootCandidate p.re
          + algebraMap ℚ GaussianAdjoinRootCandidate p.im
              * AdjoinRoot.root GaussianPolynomialOverQ)
        + (algebraMap ℚ GaussianAdjoinRootCandidate q.re
            + algebraMap ℚ GaussianAdjoinRootCandidate q.im
                * AdjoinRoot.root GaussianPolynomialOverQ)
  rw [GaussianFieldPairCarrier.add_re, GaussianFieldPairCarrier.add_im,
      map_add, map_add, add_mul]
  ring

/-- **R340** the candidate function preserves multiplication.

The expansion uses `root² = -1`. Schematically:
`(a + b·root)(c + d·root) = a·c + (a·d + b·c)·root + b·d·root²
= (a·c - b·d) + (a·d + b·c)·root`. This matches the Gaussian
multiplication formula on the pair carrier
`⟨a, b⟩ * ⟨c, d⟩ = ⟨a·c - b·d, a·d + b·c⟩`. -/
theorem GaussianFieldPair_to_GaussianAdjoinRoot_fun_mul
    (p q : GaussianFieldPairCarrier) :
    GaussianFieldPair_to_GaussianAdjoinRoot_fun (p * q)
      = GaussianFieldPair_to_GaussianAdjoinRoot_fun p
        * GaussianFieldPair_to_GaussianAdjoinRoot_fun q := by
  show algebraMap ℚ GaussianAdjoinRootCandidate (p * q).re
        + algebraMap ℚ GaussianAdjoinRootCandidate (p * q).im
            * AdjoinRoot.root GaussianPolynomialOverQ
      = (algebraMap ℚ GaussianAdjoinRootCandidate p.re
          + algebraMap ℚ GaussianAdjoinRootCandidate p.im
              * AdjoinRoot.root GaussianPolynomialOverQ)
        * (algebraMap ℚ GaussianAdjoinRootCandidate q.re
            + algebraMap ℚ GaussianAdjoinRootCandidate q.im
                * AdjoinRoot.root GaussianPolynomialOverQ)
  rw [GaussianFieldPairCarrier.mul_re, GaussianFieldPairCarrier.mul_im,
      map_sub, map_add, map_mul, map_mul, map_mul, map_mul]
  have hroot_sq := GaussianAdjoinRoot_root_sq_eq_neg_one
  linear_combination
    -(algebraMap ℚ GaussianAdjoinRootCandidate p.im
      * algebraMap ℚ GaussianAdjoinRootCandidate q.im) * hroot_sq

/-! ## Section 4: `algebraMap ℚ pair` evaluates componentwise

The `Algebra ℚ GaussianFieldPairCarrier` instance from R339 is built
via `Algebra.ofModule`, so `algebraMap ℚ pair q = q • (1 : pair) =
q • ⟨1, 0⟩ = ⟨q, 0⟩`. We record this as componentwise lemmas. -/

/-- **R340** `re` of `algebraMap ℚ pair q` is `q`. -/
@[simp] theorem algebraMap_GaussianFieldPair_re (q : ℚ) :
    (algebraMap ℚ GaussianFieldPairCarrier q).re = q := by
  rw [Algebra.algebraMap_eq_smul_one]
  show q * (1 : GaussianFieldPairCarrier).re = q
  rw [GaussianFieldPairCarrier.one_re, mul_one]

/-- **R340** `im` of `algebraMap ℚ pair q` is `0`. -/
@[simp] theorem algebraMap_GaussianFieldPair_im (q : ℚ) :
    (algebraMap ℚ GaussianFieldPairCarrier q).im = 0 := by
  rw [Algebra.algebraMap_eq_smul_one]
  show q * (1 : GaussianFieldPairCarrier).im = 0
  rw [GaussianFieldPairCarrier.one_im, mul_zero]

/-! ## Section 5: package as an AlgHom -/

/-- **R340** the AlgHom `GaussianFieldPairCarrier →ₐ[ℚ]
GaussianAdjoinRootCandidate`. -/
noncomputable def GaussianFieldPair_to_GaussianAdjoinRoot :
    GaussianFieldPairCarrier →ₐ[ℚ] GaussianAdjoinRootCandidate where
  toFun := GaussianFieldPair_to_GaussianAdjoinRoot_fun
  map_zero' := GaussianFieldPair_to_GaussianAdjoinRoot_fun_zero
  map_one' := GaussianFieldPair_to_GaussianAdjoinRoot_fun_one
  map_add' := GaussianFieldPair_to_GaussianAdjoinRoot_fun_add
  map_mul' := GaussianFieldPair_to_GaussianAdjoinRoot_fun_mul
  commutes' q := by
    show GaussianFieldPair_to_GaussianAdjoinRoot_fun
            (algebraMap ℚ GaussianFieldPairCarrier q)
          = algebraMap ℚ GaussianAdjoinRootCandidate q
    show algebraMap ℚ GaussianAdjoinRootCandidate
            (algebraMap ℚ GaussianFieldPairCarrier q).re
          + algebraMap ℚ GaussianAdjoinRootCandidate
              (algebraMap ℚ GaussianFieldPairCarrier q).im
            * AdjoinRoot.root GaussianPolynomialOverQ
        = algebraMap ℚ GaussianAdjoinRootCandidate q
    rw [algebraMap_GaussianFieldPair_re,
        algebraMap_GaussianFieldPair_im, map_zero, zero_mul, add_zero]

/-! ## Section 6: `GaussianFieldPair_i` ↦ root -/

/-- **R340** the reverse AlgHom sends the pair imaginary unit
`GaussianFieldPair_i = ⟨0, 1⟩` to `AdjoinRoot.root`. -/
theorem GaussianFieldPair_to_GaussianAdjoinRoot_pair_i :
    GaussianFieldPair_to_GaussianAdjoinRoot GaussianFieldPair_i
      = AdjoinRoot.root GaussianPolynomialOverQ := by
  show GaussianFieldPair_to_GaussianAdjoinRoot_fun ⟨0, 1⟩
        = AdjoinRoot.root GaussianPolynomialOverQ
  rw [GaussianFieldPair_to_GaussianAdjoinRoot_fun_apply,
      map_zero, map_one, zero_add, one_mul]

/-! ## Section 7: `L4-G` disclosure markers -/

/-- **L4-G** bridge from the R340 reverse AlgHom to the full
`AlgEquiv GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`
(R341/R342 target). R340 supplies the reverse direction; mutual
inverse proofs are downstream. -/
def L4_G_GaussianPairToAdjoinRoot_To_AlgEquiv : Prop := True

/-- **L4-G** bridge from R340 to the source-side Gaussian field action
on `PointEndHomQ`. Composing the forthcoming R342 AlgEquiv with R286
gives `ℚ(i) ≃ₐ[ℚ] GaussianFieldPairCarrier`; the R335 embedding into
`PointEndHomQ` then carries the action across. -/
def L4_G_GaussianPairToAdjoinRoot_To_GaussianFieldAction : Prop := True

/-- **L4-G** bridge to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R340 is one of the
algebra-equivalence ingredients for the source-side `End⁰`-action that
the package consumes. -/
def L4_G_GaussianPairToAdjoinRoot_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 8: status -/

/-- **R340 status**: `root² = -1` in AdjoinRoot is closed. -/
def R340_Status_Root_Sq_Closed : Prop := True

/-- **R340 status**: the candidate function `pair → AdjoinRoot` is
defined. -/
def R340_Status_Function_Defined : Prop := True

/-- **R340 status**: the AlgHom `pair →ₐ[ℚ] AdjoinRoot` is
constructed. -/
def R340_Status_AlgHom_Constructed : Prop := True

/-- **R340 status**: `pair_i ↦ root` is closed. -/
def R340_Status_PairI_To_Root_Closed : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R340 non-closure (1/3)**: does NOT close the full
`AlgEquiv GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`.
R340 supplies only the reverse AlgHom; mutual-inverse proofs (which
combine with R339's forward direction) are R341/R342 targets. -/
theorem R340_does_not_close_full_AlgEquiv : True := trivial

/-- **R340 non-closure (2/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R340 supplies one
algebra-equivalence ingredient; the cohomology-action layer that the
package consumes is downstream. -/
theorem R340_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R340 non-closure (3/3)**: does NOT close `canonicalE7ShimuraTor`
(the active HC cone field). R340 supplies one structural ingredient
along the R327-R342+ chain. -/
theorem R340_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
