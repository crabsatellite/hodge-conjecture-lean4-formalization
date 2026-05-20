/-
# HC Gap L4 — `AdjoinRoot (X²+1) →ₐ[ℚ] GaussianFieldPairCarrier` (R339).

R335 built `GaussianFieldPairCarrier` (the pair carrier `(re, im) : ℚ × ℚ`
with Gaussian multiplication) and proved it is a `CommRing` plus
`Module ℚ`. R339 picks up that infrastructure and constructs the
algebra-homomorphism `GaussianAdjoinRootCandidate →ₐ[ℚ]
GaussianFieldPairCarrier` sending `AdjoinRoot.root` to the pair
imaginary unit `(0, 1)`.

## Strategic anchor

R339 is the first half of the algebra equivalence
`GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`
needed for R342. Composed with R286's
`GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate`
this gives `ℚ(i) ≃ₐ[ℚ] GaussianFieldPairCarrier`. That AlgEquiv
transports the `IsLocalization`-lifted GaussianInt action on the pair
carrier back to a true `ℚ(i)`-action on `GaussianFieldPairCarrier`,
which then carries over via R335's embedding to the source-side
`PointEndHomQ` action consumed by
`canonicalE7ShimuraTor.mtCorrespondencePackage`.

## Mathlib API used

* `Mathlib.RingTheory.AdjoinRoot.liftHom` (`AdjoinRoot.lean:264`) —
  `liftHom (f : R[X]) (x : S) (hfx : aeval x f = 0) : AdjoinRoot f →ₐ[R] S`.
* `Mathlib.RingTheory.AdjoinRoot.liftHom_root` (`AdjoinRoot.lean:294`).
* `Mathlib.Algebra.Algebra.Defs.Algebra.ofModule` — build an
  `Algebra R A` from a `Module R A` plus the two `smul·mul` axioms.

## What R339 (this file) provides (all kernel-pure)

* `GaussianFieldPair_i : GaussianFieldPairCarrier := ⟨0, 1⟩`.
* `GaussianFieldPair_i_sq_eq_neg_one` — `i² = -1` in the pair carrier.
* `instance : Algebra ℚ GaussianFieldPairCarrier` — built via
  `Algebra.ofModule` from the R335 `Module ℚ` instance plus
  componentwise `smul`/`mul` compatibility.
* `aeval_GaussianPolynomialOverQ_GaussianFieldPair_i` — evaluating
  `X²+1` at the pair `i` gives `0`.
* `GaussianAdjoinRoot_to_GaussianFieldPair : GaussianAdjoinRootCandidate
   →ₐ[ℚ] GaussianFieldPairCarrier` — the AlgHom via `AdjoinRoot.liftHom`.
* `GaussianAdjoinRoot_to_GaussianFieldPair_root` — root maps to `i`.

## What R339 does NOT do

* Does NOT construct the reverse AlgHom (R340+).
* Does NOT construct the full AlgEquiv `≃ₐ[ℚ]` (R342).
* Does NOT define the `ℚ(i)`-action on `PointEndHomQ`.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.

All R339 declarations are kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`;
`:= True` reserved for markers / status / non-closure only.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianFieldSubringCommRing
import Mathlib.RingTheory.AdjoinRoot

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open Polynomial

/-! ## Section 1: the pair imaginary unit `(0, 1)` -/

/-- **R339** the pair imaginary unit: `(0, 1) : GaussianFieldPairCarrier`,
representing `0 + 1·i ∈ ℚ(i)`. -/
def GaussianFieldPair_i : GaussianFieldPairCarrier := ⟨0, 1⟩

@[simp] theorem GaussianFieldPair_i_re :
    GaussianFieldPair_i.re = 0 := rfl

@[simp] theorem GaussianFieldPair_i_im :
    GaussianFieldPair_i.im = 1 := rfl

/-! ## Section 2: `i² = -1` in the pair carrier

The Gaussian multiplication is `⟨a, b⟩ * ⟨c, d⟩ = ⟨a*c-b*d, a*d+b*c⟩`,
so `i² = ⟨0, 1⟩ * ⟨0, 1⟩ = ⟨-1, 0⟩ = -1`. -/

/-- **R339** the pair imaginary unit squares to `-1`. -/
theorem GaussianFieldPair_i_sq_eq_neg_one :
    GaussianFieldPair_i * GaussianFieldPair_i
      = (-1 : GaussianFieldPairCarrier) := by
  ext
  · show (0 : ℚ) * 0 - 1 * 1 = (-1 : GaussianFieldPairCarrier).re
    rw [GaussianFieldPairCarrier.neg_re,
        GaussianFieldPairCarrier.one_re]
    ring
  · show (0 : ℚ) * 1 + 1 * 0 = (-1 : GaussianFieldPairCarrier).im
    rw [GaussianFieldPairCarrier.neg_im,
        GaussianFieldPairCarrier.one_im]
    ring

/-! ## Section 3: `Algebra ℚ GaussianFieldPairCarrier`

R335 supplied a `Module ℚ` instance via the componentwise smul
`q • ⟨a, b⟩ = ⟨q*a, q*b⟩`. To upgrade this to a full `Algebra ℚ`
structure we use `Algebra.ofModule`, which only needs the two
compatibility axioms `(q • x) * y = q • (x * y)` and `x * (q • y) = q •
(x * y)`. Both hold by `ext + ring` on the rational components, as the
Gaussian multiplication is bilinear in each argument over ℚ. -/

/-- **R339** `Algebra ℚ GaussianFieldPairCarrier` via `Algebra.ofModule`
applied to the R335 `Module ℚ` structure. The two compatibility axioms
each reduce under `ext` to polynomial identities over ℚ on the `re` and
`im` components. -/
noncomputable instance instAlgebraQGaussianFieldPair :
    Algebra ℚ GaussianFieldPairCarrier :=
  Algebra.ofModule
    (fun q x y => by
      ext
      · show q * x.re * y.re - q * x.im * y.im
            = q * (x.re * y.re - x.im * y.im)
        ring
      · show q * x.re * y.im + q * x.im * y.re
            = q * (x.re * y.im + x.im * y.re)
        ring)
    (fun q x y => by
      ext
      · show x.re * (q * y.re) - x.im * (q * y.im)
            = q * (x.re * y.re - x.im * y.im)
        ring
      · show x.re * (q * y.im) + x.im * (q * y.re)
            = q * (x.re * y.im + x.im * y.re)
        ring)

/-! ## Section 4: `aeval` of `X² + 1` at the pair imaginary unit

`aeval` is the algebra-homomorphism evaluation. For `f = X² + 1` at
`a = ⟨0, 1⟩` we compute `a² + 1 = -1 + 1 = 0` using R339's
`i_sq_eq_neg_one`. -/

/-- **R339** evaluating `X² + 1 ∈ ℚ[X]` at the pair imaginary unit gives
`0` in `GaussianFieldPairCarrier`. -/
theorem aeval_GaussianPolynomialOverQ_GaussianFieldPair_i :
    (Polynomial.aeval GaussianFieldPair_i) GaussianPolynomialOverQ
      = 0 := by
  unfold GaussianPolynomialOverQ
  show (Polynomial.aeval GaussianFieldPair_i) (X^2 + 1) = 0
  rw [map_add, map_pow, Polynomial.aeval_X, map_one, sq,
      GaussianFieldPair_i_sq_eq_neg_one]
  rw [neg_add_cancel]

/-! ## Section 5: the AlgHom via `AdjoinRoot.liftHom`

With the `Algebra ℚ GaussianFieldPairCarrier` instance plus the
`aeval = 0` witness, `AdjoinRoot.liftHom` directly produces the AlgHom
`AdjoinRoot (X²+1) →ₐ[ℚ] GaussianFieldPairCarrier`. -/

/-- **R339** the AlgHom `GaussianAdjoinRootCandidate →ₐ[ℚ]
GaussianFieldPairCarrier` sending `AdjoinRoot.root GaussianPolynomialOverQ`
to `GaussianFieldPair_i`. -/
noncomputable def GaussianAdjoinRoot_to_GaussianFieldPair :
    GaussianAdjoinRootCandidate →ₐ[ℚ] GaussianFieldPairCarrier :=
  AdjoinRoot.liftHom GaussianPolynomialOverQ GaussianFieldPair_i
    aeval_GaussianPolynomialOverQ_GaussianFieldPair_i

/-! ## Section 6: root transports to the pair imaginary unit -/

/-- **R339** the AlgHom sends `AdjoinRoot.root` to `GaussianFieldPair_i`. -/
theorem GaussianAdjoinRoot_to_GaussianFieldPair_root :
    GaussianAdjoinRoot_to_GaussianFieldPair
        (AdjoinRoot.root GaussianPolynomialOverQ)
      = GaussianFieldPair_i :=
  AdjoinRoot.liftHom_root
    (a := GaussianFieldPair_i)
    (hfx := aeval_GaussianPolynomialOverQ_GaussianFieldPair_i)

/-! ## Section 7: `L4-G` disclosure markers -/

/-- **L4-G** bridge from the R339 forward AlgHom to the full
`AlgEquiv GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`
(R342 target). R339 supplies the forward direction; the reverse +
mutual-inverse proofs are downstream. -/
def L4_G_GaussianPairAdjoinRootAlgHom_To_AlgEquiv : Prop := True

/-- **L4-G** bridge from R339 to the source-side Gaussian field action
on `PointEndHomQ`. Composing the forthcoming R342 AlgEquiv with R286
gives `ℚ(i) ≃ₐ[ℚ] GaussianFieldPairCarrier`; the R335 embedding into
`PointEndHomQ` then carries the action across. -/
def L4_G_GaussianPairAdjoinRootAlgHom_To_GaussianFieldAction :
    Prop := True

/-- **L4-G** bridge to the active HC cone field
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R339 is one of the
algebra-equivalence ingredients for the source-side `End⁰`-action that
the package consumes. -/
def L4_G_GaussianPairAdjoinRootAlgHom_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 8: status -/

/-- **R339 status**: `i² = -1` in the pair carrier is closed. -/
def R339_Status_PairImaginaryUnit_SqNegOne_Closed : Prop := True

/-- **R339 status**: `aeval (X²+1) at pair i = 0` is closed. -/
def R339_Status_Aeval_GaussianPoly_AtPairI_Closed : Prop := True

/-- **R339 status**: the AlgHom `AdjoinRoot (X²+1) →ₐ[ℚ] pair carrier`
is closed. -/
def R339_Status_AlgHom_AdjoinRoot_To_Pair_Closed : Prop := True

/-- **R339 status**: `root ↦ pair i` is closed. -/
def R339_Status_Root_To_PairI_Closed : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R339 non-closure (1/3)**: does NOT close the full
`AlgEquiv GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`.
R339 supplies only the forward AlgHom; reverse direction + mutual
inverses are R340-R342 targets. -/
theorem R339_does_not_close_full_AlgEquiv : True := trivial

/-- **R339 non-closure (2/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. R339 supplies one
algebra-equivalence ingredient; the cohomology-action layer that the
package consumes is downstream. -/
theorem R339_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R339 non-closure (3/3)**: does NOT close `canonicalE7ShimuraTor`
(the active HC cone field). R339 supplies one structural ingredient
along the R327-R338+ chain. -/
theorem R339_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
