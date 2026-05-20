/-
# HC Gap L4 — Gaussian CM action additivity, easy branches (R306).

R305 closed `negY` compatibility for the Gaussian CM coordinate map
`(x, y) ↦ (-x, i·y)` on the affine model of
`E_K = GaussianCMEllipticCurveTargetBaseChange`. R306 begins the
attack on Point-level additivity

    φ(P + Q) = φ(P) + φ(Q)

by closing the EASY branches:

* **Zero left**: `φ(0 + P) = φ(0) + φ(P)` (both sides equal `φ(P)`).
* **Zero right**: `φ(P + 0) = φ(P) + φ(0)` (both sides equal `φ(P)`).
* **Inverse branch condition is preserved**: if
  `(x₁, y₁)` and `(x₂, y₂)` satisfy the Mathlib inverse-branch
  hypotheses `x₁ = x₂` and `y₁ = negY x₂ y₂`, then so do their
  CM-action images `(-x₁, i·y₁)` and `(-x₂, i·y₂)`. This is the
  bridge fact extracted from R305's `negY` compatibility.
* **Inverse branch additivity**: in the inverse case
  (`x₁ = x₂` ∧ `y₁ = negY x₂ y₂`), `some h₁ + some h₂ = 0` on both
  sides because Mathlib's `Point.add_of_Y_eq` triggers on both
  the source and the image pair.

These four branches will be combined with the harder generic-add
branch (`add_of_Y_ne` / `add_of_X_ne`, requiring `nonsingular_add`
compatibility) in a later round.

## What this file provides (all kernel-pure)

* `gaussianCMAction_affinePoint_zero_add` — Theorem 1.
* `gaussianCMAction_affinePoint_add_zero` — Theorem 2.
* `gaussianCMAction_inverse_branch_condition_preserved` — Theorem 3.
* `gaussianCMAction_add_inverse_branch` — Theorem 4.
* Status / non-closure markers for the R306 attack.

All declarations are kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` substantive closure.
-/

import HodgeReduction.HCGapL4.GaussianCMActionPointMap
import HodgeReduction.HCGapL4.GaussianCMActionNegYCompat

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: zero branches -/

/-- **R306 Theorem 1** — zero left compatibility:

    φ(0 + P) = φ(0) + φ(P).

Proof: The Mathlib `Point.add` is a pattern-match-defined function
whose `| 0, P => P` clause fires once the FIRST argument is matched
against `0 = Point.zero`. Since `noncomputable def add` requires
the first argument to be in WHNF for pattern reduction in the
kernel, we do explicit case analysis on `P` and use `rfl` in each
branch. (For the `P = 0` case, both sides become `φ(0)`; for the
`P = some h` case, both sides become `φ(some h)` because `φ(0) = 0`
and `add 0 P = P` by the `| 0, _ => _` clause.) -/
theorem gaussianCMAction_affinePoint_zero_add
    (P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    gaussianCMAction_affinePoint (0 + P)
      = gaussianCMAction_affinePoint 0 + gaussianCMAction_affinePoint P := by
  rcases P with _ | h
  · rfl
  · rfl

/-- **R306 Theorem 2** — zero right compatibility:

    φ(P + 0) = φ(P) + φ(0).

Proof: symmetric to Theorem 1. The Mathlib `add` definition on
`Point` matches `| P, 0 => P` for the second argument; we do case
analysis on `P` to expose this. -/
theorem gaussianCMAction_affinePoint_add_zero
    (P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    gaussianCMAction_affinePoint (P + 0)
      = gaussianCMAction_affinePoint P + gaussianCMAction_affinePoint 0 := by
  rcases P with _ | h
  · rfl
  · rfl

/-! ## Section 2: inverse branch condition preservation -/

/-- **R306 Theorem 3** — the Mathlib `add_of_Y_eq` hypothesis on
`y₁ = negY x₂ y₂` is preserved by the Gaussian CM coordinate map.

Concretely, if `y₁ = negY x₂ y₂`, then

    i · y₁ = negY (-x₂) (i · y₂).

Proof: by R305 `gaussianCMAction_negY_compat` we have
`negY (-x₂) (i·y₂) = i · negY x₂ y₂`. Combined with `hy`, the right
hand side is `i · y₁`.

Note: `_hx` is recorded in the signature so that the Theorem 4
calling site can pass `(hx, hy)` as a uniform pair (mirroring the
shape of Mathlib's `Point.add_of_Y_eq`). It is not used in the
proof body; the underscore prefix silences the unused-variable
linter. -/
theorem gaussianCMAction_inverse_branch_condition_preserved
    {x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate}
    (_hx : x₁ = x₂)
    (hy : y₁ = GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x₂ y₂) :
    (gaussianRationalI * y₁) =
      GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
        (-x₂) (gaussianRationalI * y₂) := by
  rw [gaussianCMAction_negY_compat]
  rw [hy]

/-! ## Section 3: inverse branch additivity -/

/-- **R306 Theorem 4** — inverse branch additivity:

In the inverse branch (`x₁ = x₂` ∧ `y₁ = negY x₂ y₂`), Mathlib's
`Point.add_of_Y_eq` says `some h₁ + some h₂ = 0`. The CM action
preserves both branch-defining equalities (by `hx` directly for the
`x` coordinate, and by Theorem 3 for the `y` coordinate), so the
image pair also lies in the inverse branch and its sum is `0`. Since
`φ(0) = 0`, both sides equal `0`. -/
theorem gaussianCMAction_add_inverse_branch
    {x₁ x₂ y₁ y₂ : GaussianRationalFieldCandidate}
    (h₁ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₁ y₁)
    (h₂ : GaussianCMEllipticCurveTargetBaseChange.toAffine.Nonsingular x₂ y₂)
    (hx : x₁ = x₂)
    (hy : y₁ = GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x₂ y₂) :
    gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₁
          + WeierstrassCurve.Affine.Point.some h₂)
      = gaussianCMAction_affinePoint (WeierstrassCurve.Affine.Point.some h₁)
        + gaussianCMAction_affinePoint (WeierstrassCurve.Affine.Point.some h₂) := by
  -- LHS: source pair lies in inverse branch ⇒ `some h₁ + some h₂ = 0` ⇒
  -- `φ(0) = 0`.
  rw [WeierstrassCurve.Affine.Point.add_of_Y_eq hx hy,
      gaussianCMAction_affinePoint_zero]
  -- RHS: rewrite both φ(some hᵢ) to their definitional `some (preserves hᵢ)`.
  rw [show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₁)
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular x₁ y₁ h₁) from rfl,
      show gaussianCMAction_affinePoint
        (WeierstrassCurve.Affine.Point.some h₂)
        = WeierstrassCurve.Affine.Point.some
            (gaussianCMAction_preserves_nonsingular x₂ y₂ h₂) from rfl]
  -- Image pair also lies in inverse branch:
  -- `-x₁ = -x₂` (from `hx`) and `i·y₁ = negY (-x₂) (i·y₂)` (Theorem 3).
  have hx' : (-x₁ : GaussianRationalFieldCandidate) = -x₂ := by rw [hx]
  have hy' : gaussianRationalI * y₁
      = GaussianCMEllipticCurveTargetBaseChange.toAffine.negY
          (-x₂) (gaussianRationalI * y₂) :=
    gaussianCMAction_inverse_branch_condition_preserved hx hy
  rw [WeierstrassCurve.Affine.Point.add_of_Y_eq hx' hy']

/-! ## Section 4: status / closure -/

/-- **R306 status**: zero-add and add-zero compatibilities closed. -/
def R306_Status_Zero_Cases_Closed : Prop := True

/-- **R306 status**: inverse branch additivity closed. -/
def R306_Status_Inverse_Branch_Closed : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R306 non-closure (1/4)**: does NOT close the generic
`add_of_Y_ne` / `add_of_X_ne` branches (the chord-tangent /
secant-line case requires compatibility of `nonsingular_add` with
the CM action and is the R307+ target). -/
theorem R306_does_not_close_generic_add_branches : True := trivial

/-- **R306 non-closure (2/4)**: does NOT package the CM action as
an `AddMonoidHom Point Point`. Even after generic branches close,
explicit `map_zero` and `map_add` need to be assembled. -/
theorem R306_does_not_construct_addMonoidHom : True := trivial

/-- **R306 non-closure (3/4)**: does NOT construct the algebraic
endomorphism `i ∈ End(E_K)`; the R293 Mathlib gap on the
`End`-construction remains. -/
theorem R306_does_not_construct_End : True := trivial

/-- **R306 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R306_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
