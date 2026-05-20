/-
# HC Gap L4 — Gaussian CM action as `AddMonoidHom` and `AddMonoid.End` (R308).

R306 closed the easy additivity branches (zero-add / add-zero /
inverse branch). R307 closed the generic secant (`x₁ ≠ x₂`) and
tangent (`x₁ = x₂` ∧ `y₁ ≠ negY x₂ y₂`) branches. R308 assembles
all four branches into the unified additivity theorem

    φ(P + Q) = φ(P) + φ(Q)

and packages the verified function as an `AddMonoidHom` and an
element of `AddMonoid.End` (the group-endomorphism candidate from
R293).

## What this file provides (all kernel-pure)

* `gaussianCMAction_affinePoint_map_add` — full additivity theorem
  (Theorem A; case analysis on `P` then `Q`, dispatching to R306/R307).
* `gaussianCMAction_AddMonoidHom` — packaged as `AddMonoidHom`
  (Theorem B).
* `gaussianCMAction_GroupEndCandidate` — packaged as element of
  `AddMonoid.End` (Theorem C).
* `gaussianCMAction_GroupEndCandidate_sq_apply` — `(φ * φ) P = -P`
  for all `P` (Theorem D; square law lifted to the ring structure on
  `AddMonoid.End`).
* Status / bridge / non-closure markers.

The R293 disclosure that `AddMonoid.End` is the group-endomorphism
ring (NOT the algebraic endomorphism ring) is preserved as explicit
markers — R308 does NOT close that gap.

All declarations are kernel-pure: axiom cone
`⊆ {propext, Classical.choice, Quot.sound}`. No `axiom`, no `sorry`,
no `:= True` for substantive closure.
-/

import HodgeReduction.HCGapL4.GaussianCMActionAddCasesBasic
import HodgeReduction.HCGapL4.GaussianCMActionAddCasesGeneric
import HodgeReduction.HCGapL4.GaussianCMActionPointSquare
import Mathlib.Algebra.Group.Hom.End

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section A: full additivity theorem (assemble R306 + R307 branches) -/

/-- **R308 Theorem A** — full additivity for `gaussianCMAction_affinePoint`:

    φ(P + Q) = φ(P) + φ(Q)

for all `P Q : E_K.toAffine.Point`. Proof by case analysis:

* `P = zero`: dispatch to R306 `gaussianCMAction_affinePoint_zero_add`.
* `P = some h₁`, `Q = zero`: dispatch to R306
  `gaussianCMAction_affinePoint_add_zero`.
* `P = some h₁`, `Q = some h₂` (both nonzero): split on whether
  `x₁ = x₂`:
  * if `x₁ = x₂`, split on whether `y₁ = negY x₂ y₂`:
    * yes: dispatch to R306 `gaussianCMAction_add_inverse_branch`.
    * no: dispatch to R307 `gaussianCMAction_add_Y_ne_branch`.
  * if `x₁ ≠ x₂`: dispatch to R307 `gaussianCMAction_add_X_ne_branch`.

All four leaf branches are kernel-pure by the imported R306/R307
theorems. The case split is exhaustive and matches Mathlib's three
add-clauses (`add_of_Y_eq`, `add_of_Y_ne`, `add_of_X_ne`). -/
theorem gaussianCMAction_affinePoint_map_add
    (P Q : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    gaussianCMAction_affinePoint (P + Q)
      = gaussianCMAction_affinePoint P + gaussianCMAction_affinePoint Q := by
  cases P with
  | zero => exact gaussianCMAction_affinePoint_zero_add Q
  | @some x₁ y₁ h₁ =>
    cases Q with
    | zero => exact gaussianCMAction_affinePoint_add_zero _
    | @some x₂ y₂ h₂ =>
      by_cases hx : x₁ = x₂
      · by_cases hy : y₁ =
            GaussianCMEllipticCurveTargetBaseChange.toAffine.negY x₂ y₂
        · -- Inverse branch (`x₁ = x₂` ∧ `y₁ = negY x₂ y₂`):
          -- R306 `gaussianCMAction_add_inverse_branch`.
          exact gaussianCMAction_add_inverse_branch h₁ h₂ hx hy
        · -- Tangent branch (`x₁ = x₂` ∧ `y₁ ≠ negY x₂ y₂`):
          -- R307 `gaussianCMAction_add_Y_ne_branch`.
          exact gaussianCMAction_add_Y_ne_branch h₁ h₂ hx hy
      · -- Secant branch (`x₁ ≠ x₂`):
        -- R307 `gaussianCMAction_add_X_ne_branch`.
        exact gaussianCMAction_add_X_ne_branch h₁ h₂ hx

/-! ## Section B: package as `AddMonoidHom` -/

/-- **R308 Theorem B** — the Gaussian CM action `(x, y) ↦ (-x, i·y)`
packaged as an `AddMonoidHom` on the affine point group of `E_K`.

* `toFun := gaussianCMAction_affinePoint` (R303).
* `map_zero' := gaussianCMAction_affinePoint_zero` (R303).
* `map_add' := gaussianCMAction_affinePoint_map_add` (Theorem A above).
-/
noncomputable def gaussianCMAction_AddMonoidHom :
    GaussianCMEllipticCurveTargetBaseChange.toAffine.Point →+
      GaussianCMEllipticCurveTargetBaseChange.toAffine.Point where
  toFun := gaussianCMAction_affinePoint
  map_zero' := gaussianCMAction_affinePoint_zero
  map_add' := gaussianCMAction_affinePoint_map_add

/-- **R308** — definitional unfolding of the bundled hom's underlying
function. -/
theorem gaussianCMAction_AddMonoidHom_apply
    (P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    gaussianCMAction_AddMonoidHom P = gaussianCMAction_affinePoint P :=
  rfl

/-! ## Section C: package as `AddMonoid.End` -/

/-- **R308 Theorem C** — the Gaussian CM action packaged as an element
of `AddMonoid.End` on the affine point group of `E_K`. Since
`AddMonoid.End M = M →+ M` definitionally for `[AddCommGroup M]`,
this is just the `AddMonoidHom` of Theorem B viewed as a member of
the ring `AddMonoid.End (E_K.toAffine.Point)` (whose `Ring` structure
is given by R293 / Mathlib `Algebra.Group.Hom.End`).

Note (R293 disclosure): `AddMonoid.End` is the GROUP-endomorphism
ring, NOT the algebraic-endomorphism ring `End(E_K)`. The bridge to
the algebraic `End(E_K)` remains the R293 / R296+ gap. -/
noncomputable def gaussianCMAction_GroupEndCandidate :
    AddMonoid.End GaussianCMEllipticCurveTargetBaseChange.toAffine.Point :=
  gaussianCMAction_AddMonoidHom

/-- **R308** — `gaussianCMAction_GroupEndCandidate` applied to a
point equals `gaussianCMAction_affinePoint` applied. -/
theorem gaussianCMAction_GroupEndCandidate_apply
    (P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    gaussianCMAction_GroupEndCandidate P = gaussianCMAction_affinePoint P :=
  rfl

/-! ## Section D: square law in `AddMonoid.End`

Mathlib's `AddMonoid.End` inherits multiplication from
`Monoid.End`: `(f * g : Monoid.End M) = f.comp g`, and
`AddMonoid.End.coe_mul` (via `Monoid.End.coe_mul`) gives
`((f * g) : M → M) = f ∘ g`. So `(φ * φ) P = φ (φ P)` is
definitional. -/

/-- **R308 Theorem D** — square law in `AddMonoid.End`:

    (φ * φ) P = -P

for all `P : E_K.toAffine.Point`. Here `φ * φ` is multiplication in
the ring `AddMonoid.End (E_K.toAffine.Point)`, which is composition:
`(f * g) P = f (g P)` definitionally. The right-hand side `-P` is
negation in the abelian point group.

Proof: by R304 `gaussianCMAction_affinePoint_square_eq_neg` after
unfolding the `AddMonoid.End` multiplication. -/
theorem gaussianCMAction_GroupEndCandidate_sq_apply
    (P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point) :
    (gaussianCMAction_GroupEndCandidate * gaussianCMAction_GroupEndCandidate) P
      = -P := by
  -- `AddMonoid.End` mul is composition: `(f * g) P = f (g P)`.
  -- Since `gaussianCMAction_GroupEndCandidate` unfolds to the bundled
  -- hom whose `toFun` is `gaussianCMAction_affinePoint`, the LHS
  -- definitionally reduces to `gaussianCMAction_affinePoint
  -- (gaussianCMAction_affinePoint P)`.
  show gaussianCMAction_affinePoint (gaussianCMAction_affinePoint P) = -P
  exact gaussianCMAction_affinePoint_square_eq_neg P

/-! ## Section E: status / bridge / non-closure markers -/

/-- **R308 status**: full additivity theorem closed. -/
def R308_Status_FullAdditivity_Closed : Prop := True

/-- **R308 status**: `gaussianCMAction_AddMonoidHom` defined. -/
def R308_Status_AddMonoidHom_Defined : Prop := True

/-- **R308 status**: `gaussianCMAction_GroupEndCandidate` defined
as element of `AddMonoid.End E_K.toAffine.Point`. -/
def R308_Status_GroupEnd_Defined : Prop := True

/-- **R308 status**: square law `(φ * φ) P = -P` closed at the
`AddMonoid.End` ring level. -/
def R308_Status_GroupEnd_Square_Eq_Neg_Closed : Prop := True

/-- **L4-G_GaussianCMActionAddMonoidHom_To_AlgebraicEndE**: bridge
from the packaged `AddMonoidHom` / `AddMonoid.End` element to the
algebraic `End(E_K)` (Mathlib gap; R293 / R296+ target). -/
def L4_G_GaussianCMActionAddMonoidHom_To_AlgebraicEndE : Prop := True

/-- **L4-G_GaussianCMActionAddMonoidHom_To_End0**: bridge from the
packaged `AddMonoid.End` element to `End⁰(E_K)` (depends on the
algebraic `End(E_K)` construction; R294+ target). -/
def L4_G_GaussianCMActionAddMonoidHom_To_End0 : Prop := True

/-- **L4-G_GaussianCMActionAddMonoidHom_GroupEnd_NotYetAlgebraicEnd**:
disclosure: `AddMonoid.End` packaging is at the GROUP-endomorphism
ring level (R293), NOT the algebraic-endomorphism ring. R308 does
NOT close the bridge. -/
def L4_G_GaussianCMActionAddMonoidHom_GroupEnd_NotYetAlgebraicEnd :
    Prop := True

/-! ## Section F: explicit non-closure -/

/-- **R308 non-closure (1/3)**: does NOT construct the algebraic
endomorphism ring `End(E_K)` (R293 Mathlib gap). The packaging here
is `AddMonoid.End` = group-endomorphism ring only. -/
theorem R308_does_not_construct_algebraic_End : True := trivial

/-- **R308 non-closure (2/3)**: does NOT construct `End⁰(E_K)`. The
bridge depends on the algebraic-End construction (R294+). -/
theorem R308_does_not_construct_End0 : True := trivial

/-- **R308 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R308_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
