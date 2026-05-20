/-
# HC Gap L4 — Gaussian CM action point-level map (R301-R304 / Agent C).

Building on:
* R299/R300 — `E_K : y² = x³ + x` over `K = ℚ(i)` is elliptic.
* Agent A (R301) — affine `Point` representation is the right target.
* Agent B (R301) — `gaussianCMAction_preserves_equation` and
  `gaussianCMAction_preserves_nonsingular`.
* Agent D (R302) — coordinate-level square `i·(i·y) = negY x y`.

This file defines the actual CM action as a function

    gaussianCMAction_affinePoint : E_K.toAffine.Point → E_K.toAffine.Point

via pattern-matching on the inductive `Point | zero | some h`. It uses
Agent B's nonsingular preservation lemma to construct the codomain
witness directly.

## What this file provides (all kernel-pure)

* `gaussianCMAction_affinePoint` — the point-level CM action map.
* `gaussianCMAction_affinePoint_zero` — `φ(0) = 0`.
* `gaussianCMAction_affinePoint_some` — definitional equation on
  `some h`.
* Target markers for the next layers: `Square_Eq_Neg`,
  `AddMonoidHom`, `End_Element`.
* Explicit `BlockingLemma_*` for the Point-extensionality square step.

All declarations kernel-pure: `{propext, Classical.choice, Quot.sound}`
or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMActionEquationPreservation
import HodgeReduction.HCGapL4.GaussianCMActionCoordinateSquare

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: point-level CM action -/

/-- **R303** the Gaussian CM action `(x, y) ↦ (-x, i·y)` as a function
on the inductive affine point type. On `zero` it returns `zero`; on
`some h` it returns `some` of the preserved-nonsingular witness from
Agent B's R301 lemma. -/
noncomputable def gaussianCMAction_affinePoint :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.Point →
    GaussianCMEllipticCurveTargetBaseChange.toAffine.Point
  | .zero => .zero
  | .some h => .some (gaussianCMAction_preserves_nonsingular _ _ h)

/-! ## Section 2: zero / infinity preservation -/

/-- **R303** the CM action sends the point at infinity to itself. -/
theorem gaussianCMAction_affinePoint_zero :
    gaussianCMAction_affinePoint
        (0 : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) = 0 :=
  rfl

/-- **R303** definitional unfolding on `some` constructor. -/
theorem gaussianCMAction_affinePoint_some
    {x y : GaussianRationalFieldCandidate}
    (h : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x y) :
    gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h) =
      WeierstrassCurve.Affine.Point.some
        (gaussianCMAction_preserves_nonsingular x y h) :=
  rfl

/-! ## Section 3: status / closure -/

/-- **R303 status**: CM action defined as a function. -/
def R303_Status_CMAction_PointMap_Defined : Prop := True

/-- **R303 status**: zero preservation closed. -/
def R303_Status_CMAction_Zero_Preserved : Prop := True

/-! ## Section 4: next-target markers (R304+) -/

/-- **R304 target**: prove `φ ∘ φ = - id` at the `Point` level. -/
def Target_gaussianCMAction_square_eq_negId : Prop := True

/-- **R304 target**: package as an `AddMonoidHom`
`E_K.toAffine.Point →+ E_K.toAffine.Point`. -/
def Target_gaussianCMAction_is_addMonoidHom : Prop := True

/-- **R304 target**: package as an element of `End(E_K)` (depends on
algebraic End-ring construction — Mathlib gap recorded in R293). -/
def Target_gaussianCMAction_packaged_as_EndE : Prop := True

/-! ## Section 5: blocking lemmas

These mark genuine downstream obstacles that are NOT solved here.
Each is a `Prop := True` MARKER (not a substantive math closure). -/

/-- **R304 blocker**: lifting the coordinate-level square law
`i·(i·y) = negY x y` to a `Point`-level identity
`φ(φ(some h)) = -some h` requires reconciling the implicit `x y`
arguments of `Point.some` after rewriting `-(-x) = x` and
`i·(i·y) = negY x y`. This is a dependent-type / proof-irrelevance
manipulation, not a new math fact, but it requires `Point.some.injEq`
or a `cast` argument. -/
def BlockingLemma_gaussianCMAction_square_at_Point_via_HEq : Prop := True

/-- **R304 blocker**: proving the group-homomorphism property
`φ(P + Q) = φ(P) + φ(Q)` requires either (a) a high-level
"endomorphism of elliptic curve over fixed base" API (Mathlib's
`Point.map` is base-change only, NOT applicable here per Agent E's
audit), or (b) chord-tangent case analysis. R305+ target. -/
def BlockingLemma_gaussianCMAction_addMonoidHom_chord_tangent :
    Prop := True

/-- **R304 blocker**: packaging the verified CM action as an
element of `End(E_K)` requires the algebraic `End(E)` construction,
which is the R293 Mathlib gap. -/
def BlockingLemma_gaussianCMAction_End_packaging : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R303 non-closure (1/4)**: does NOT prove `φ ∘ φ = -id` at Point
level. -/
theorem R303_does_not_prove_square_eq_neg : True := trivial

/-- **R303 non-closure (2/4)**: does NOT prove `φ` is `AddMonoidHom`. -/
theorem R303_does_not_prove_addMonoidHom : True := trivial

/-- **R303 non-closure (3/4)**: does NOT construct `End(E_K)`. -/
theorem R303_does_not_construct_End : True := trivial

/-- **R303 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R303_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
