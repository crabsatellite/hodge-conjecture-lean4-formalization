/-
# HC Gap L4 — Gaussian CM action projective polynomial preservation (R312).

R300 closed the base change of `y² = x³ + x` to `K = GaussianRationalFieldCandidate`
with `a₁ = a₂ = a₃ = a₆ = 0`, `a₄ = 1`. R301 closed affine equation
preservation under the CM action `(x, y) ↦ (-x, i·y)`. R302 closed
affine nonsingularity preservation. R305-R309 built the full
`AddMonoid.End` packaging.

R312 (this file) closes the **projective** counterpart: the homogeneous
Weierstrass polynomial `Y²Z - X³ - XZ²` is preserved (up to sign) by
the projective extension `(X, Y, Z) ↦ (-X, i·Y, Z)`, and the standard
point at infinity `[0:1:0]` maps to `[0:i:0]`, which is the same
projective point up to scalar.

## Mathematics

For the projective Weierstrass equation `Y²Z = X³ + XZ²` (the
homogenisation of `y² = x³ + x` with `a₁ = a₂ = a₃ = a₆ = 0`, `a₄ = 1`),
the CM action sends `(X, Y, Z) ↦ (-X, i·Y, Z)`. We compute:

  (i·Y)²·Z = i²·Y²·Z = -Y²·Z
  (-X)³ + (-X)·Z² = -X³ - X·Z² = -(X³ + X·Z²)

So `(i·Y)²·Z - (-X)³ - (-X)·Z² = -Y²·Z + X³ + X·Z² = -(Y²·Z - X³ - X·Z²)`.
Hence if the original polynomial is zero, so is the image.

At infinity, `[0 : 1 : 0]` maps to `[0 : i : 0]`, which is the same
projective point (scalar multiple by `i`).

## What R312 (this file) provides (all kernel-pure)

* `gaussianCMAction_projective_polynomial_preserves` — the function-level
  identity `(i·Y)²·Z - (-X)³ - (-X)·Z² = -(Y²·Z - X³ - X·Z²)`.
* `gaussianCMAction_projective_polynomial_preserves_zero` — corollary:
  if the original homogeneous polynomial vanishes, so does the image's.
* `gaussianCMAction_projective_infinity_image` — explicit triple-level
  identity `(-0, i·1, 0) = (0, i, 0)`.
* `gaussianCMAction_projective_infinity_equiv` — projective scalar
  identity `(0, i, 0) = i • (0, 1, 0)`.
* Status / target / non-closure markers.

## What R312 (this file) does NOT do

* Does NOT interface with Mathlib's `WeierstrassCurve.Projective.Point`
  (a quotient by `Rˣ` scalar action; heavy machinery left as target).
* Does NOT construct a global curve morphism (scheme morphism on `E_K`).
* Does NOT promote to algebraic `End(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations are kernel-pure: `{propext, Classical.choice, Quot.sound}`
or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: projective polynomial preservation -/

/-- **R312** the homogeneous Weierstrass polynomial `Y²·Z - X³ - X·Z²`
(corresponding to the projective form of `y² = x³ + x`) transforms by
a sign under the CM action `(X, Y, Z) ↦ (-X, i·Y, Z)`.

Proof: `(i·Y)²·Z = i²·Y²·Z = -Y²·Z` and `(-X)³ + (-X)·Z² = -(X³ + X·Z²)`,
so the difference `(i·Y)²·Z - (-X)³ - (-X)·Z² = -Y²·Z + X³ + X·Z²
= -(Y²·Z - X³ - X·Z²)`. -/
theorem gaussianCMAction_projective_polynomial_preserves
    (X Y Z : GaussianRationalFieldCandidate) :
    (gaussianRationalI * Y)^2 * Z - (-X)^3 - (-X) * Z^2
      = -(Y^2 * Z - X^3 - X * Z^2) := by
  have hi : (gaussianRationalI : GaussianRationalFieldCandidate)^2 = -1 :=
    gaussianRationalI_sq_eq_neg_one
  linear_combination Y^2 * Z * hi

/-- **R312** corollary: if the original homogeneous polynomial vanishes
at `(X, Y, Z)`, then it vanishes at the CM-image `(-X, i·Y, Z)`. This
is the projective analogue of `gaussianCMAction_preserves_equation`. -/
theorem gaussianCMAction_projective_polynomial_preserves_zero
    (X Y Z : GaussianRationalFieldCandidate)
    (h : Y^2 * Z - X^3 - X * Z^2 = 0) :
    (gaussianRationalI * Y)^2 * Z - (-X)^3 - (-X) * Z^2 = 0 := by
  rw [gaussianCMAction_projective_polynomial_preserves, h, neg_zero]

/-! ## Section 2: infinity preservation -/

/-- **R312** the CM action sends the triple `(-0, i·1, 0)` (the image
of `(0, 1, 0)` under `(X, Y, Z) ↦ (-X, i·Y, Z)`) to `(0, i, 0)`.

In projective coordinates, `[0 : i : 0]` is the SAME projective point
as `[0 : 1 : 0]` (the standard point at infinity), since `i ≠ 0` and
projective equivalence is up to nonzero scalar. -/
theorem gaussianCMAction_projective_infinity_image :
    (- (0 : GaussianRationalFieldCandidate),
      gaussianRationalI * 1,
      (0 : GaussianRationalFieldCandidate))
      = ((0 : GaussianRationalFieldCandidate),
         gaussianRationalI,
         (0 : GaussianRationalFieldCandidate)) := by
  simp

/-- **R312** the image `(0, i, 0)` is a unit-scalar multiple of
`(0, 1, 0)` in projective coordinates (via componentwise multiplication
by `i`). -/
theorem gaussianCMAction_projective_infinity_equiv :
    ((0 : GaussianRationalFieldCandidate),
      gaussianRationalI,
      (0 : GaussianRationalFieldCandidate))
      = (gaussianRationalI * (0 : GaussianRationalFieldCandidate),
         gaussianRationalI * (1 : GaussianRationalFieldCandidate),
         gaussianRationalI * (0 : GaussianRationalFieldCandidate)) := by
  simp

/-! ## Section 3: status markers -/

/-- **R312 status**: the projective homogeneous-polynomial preservation
identity is closed. -/
def R312_Status_Projective_Polynomial_Preserves : Prop := True

/-- **R312 status**: the projective infinity image identity
`(-0, i·1, 0) = (0, i, 0)` is closed. -/
def R312_Status_Projective_Infinity_Image : Prop := True

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ProjectiveCMAction_To_GlobalCurveMorphism**: the function-level
homogeneous-polynomial preservation does NOT yet assemble into a global
curve (scheme) morphism `E_K → E_K`. That step would require interfacing
with Mathlib's `WeierstrassCurve.Projective.Point` quotient or the
underlying scheme structure. -/
def L4_G_ProjectiveCMAction_To_GlobalCurveMorphism : Prop := True

/-- **L4-G_ProjectiveCMAction_MissingProjSchemeMorphism**: Mathlib's
projective Weierstrass `Point` type is a quotient by `Rˣ`-scalar action;
the heavy projective-scheme morphism machinery is left as target. -/
def L4_G_ProjectiveCMAction_MissingProjSchemeMorphism : Prop := True

/-- **L4-G_ProjectiveCMAction_To_AlgebraicEnd**: the projective polynomial
identities do NOT yet promote to algebraic `End(E_K)`; the R293 Mathlib
gap (algebraic-endomorphism ring vs `AddMonoid.End`) remains. -/
def L4_G_ProjectiveCMAction_To_AlgebraicEnd : Prop := True

/-! ## Section 5: optional target — affine/projective compatibility -/

/-- **R312 target** (left open): the projective CM action
`[X : Y : Z] ↦ [-X : i·Y : Z]` restricts on the affine chart `Z = 1`
to the affine CM action `(x, y) ↦ (-x, i·y)`. Mathlib's affine ↔
projective equivalence interface (`WeierstrassCurve.Affine.Point` vs
`WeierstrassCurve.Projective.Point`) is heavy; recorded as a target. -/
def Target_GaussianCMAction_Projective_Restricts_To_Affine : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R312 non-closure (1/3)**: does NOT construct a projective scheme
morphism on `E_K` (Mathlib's projective `Point` quotient by `Rˣ` left
as target). -/
theorem R312_does_not_construct_projective_scheme_morphism : True := trivial

/-- **R312 non-closure (2/3)**: does NOT construct algebraic `End(E_K)`
(R293 Mathlib gap on algebraic-endomorphism ring remains). -/
theorem R312_does_not_construct_algebraic_End : True := trivial

/-- **R312 non-closure (3/3)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R312_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
