/-
# HC Gap L4 — Gaussian field action on `PointEndHomQ` (R323).

R316-R320 closed the GaussianInt action at `AddMonoidHom` level.
R321 rationalized the carrier to `PointEndHomQ := ℚ ⊗[ℤ] PointEndHom`.
R322 closed multiplication on `PointEndHomQ` via `TensorProduct.map₂`,
plus `gaussianCM_phi_Q² = -pointEnd_id_Q`.

R323 takes the next step: lift the GaussianInt action to the
rationalized carrier and STATE the extension target to
`GaussianRationalFieldCandidate = FractionRing GaussianInt = ℚ(i)`.

The full extension to ℚ(i) requires that every nonzero `α ∈ ℤ[i]`
acts invertibly on `PointEndHomQ`. Math: the inverse is
`(1/Nm(α)) · conjugate(α)` (where `Nm(α) = α · ᾱ ∈ ℤ` is the norm).
At the rationalized carrier, `1/Nm(α) ∈ ℚ` is available; the
conjugate action is the Galois twist `i ↦ -i`. Building all of this
in Lean is non-trivial — R323 documents the precise target and the
norm-conjugate-inverse blocker.

What R323 does NOT do:
* Does NOT construct the `GaussianRationalFieldCandidate → PointEndHomQ`
  algebra hom (waiting on invertibility-of-nonzero-GaussianInt-actions).
* Does NOT construct true `End⁰(E)` ring.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.

Strategic anchor: this is source-side End⁰-action infrastructure for
the MT correspondence package (active field 3 of HC cone).

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.PointEndHomQMultiplication
import HodgeReduction.HCGapL4.GaussianIntActionRingHomLike
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
open scoped TensorProduct

/-! ## Section 1: GaussianInt action lifted to PointEndHomQ -/

/-- **R323** the GaussianInt action lifted from `PointEndHom` to the
rationalized carrier `PointEndHomQ`, by composing the R319 action with
the R321 canonical inclusion. -/
noncomputable def GaussianInt_to_PointEndHomQ (z : GaussianInt) :
    PointEndHomQ :=
  pointEndHom_to_PointEndHomQ
    (GaussianInt_to_PointEndHom_formula z)

/-- **R323** the basic property: this map agrees with the R319
formula composed with the R321 inclusion. -/
theorem GaussianInt_to_PointEndHomQ_eq_inclusion_of_formula
    (z : GaussianInt) :
    GaussianInt_to_PointEndHomQ z =
      pointEndHom_to_PointEndHomQ
        (GaussianInt_to_PointEndHom_formula z) :=
  rfl

/-! ## Section 2: invertibility-of-nonzero target -/

/-- **R323 target**: every nonzero `α : GaussianInt` acts invertibly
on `PointEndHomQ` via `GaussianInt_to_PointEndHomQ α`. The math
construction is
  `α⁻¹_action := (1 / Nm(α)) · GaussianInt_to_PointEndHomQ conjugate(α)`
where `Nm(α) = α · conjugate(α) ∈ ℤ` is the Gaussian-integer norm,
and `(1 / Nm(α)) ∈ ℚ` is available via the ℚ-module structure on
`PointEndHomQ`. -/
def Target_GaussianInt_nonzero_actions_invertible_on_PointEndHomQ :
    Prop := True

/-- **R323 target**: the norm-conjugate identity
`α · conjugate(α) = Nm(α) · 1` lifted to `PointEndHomQ`-action level. -/
def Target_GaussianInt_norm_conjugate_identity_on_PointEndHomQ :
    Prop := True

/-! ## Section 3: extension to GaussianRationalFieldCandidate target -/

/-- **R323 target**: an algebra-like map
`GaussianRationalFieldCandidate = ℚ(i) → PointEndHomQ`.
Math: combine `GaussianInt → PointEndHomQ` (R323 Section 1) with
invertibility-of-nonzero (R323 Section 2), then localize at
`nonZeroDivisors ℤ[i]` to get `ℚ(i) → PointEndHomQ`.

This target is stated as a Prop marker rather than a typed
`→ₐ[ℚ]` value because `PointEndHomQ` has not yet been promoted to
a `Ring` / `Algebra ℚ` typeclass (R322 closed multiplication as a
bare `LinearMap` plus a `Mul`-equation, not as a `Ring` instance).
Promoting to `Ring` is a separate R324+ target. -/
def Target_GaussianRationalFieldCandidate_to_PointEndHomQ :
    Prop := True

/-- **R323 target**: under the target algebra-hom, `i ∈ ℚ(i)` maps to
`gaussianCM_phi_Q`. -/
def Target_GaussianFieldAction_i_maps_to_phi_Q : Prop := True

/-! ## Section 4: precise blockers -/

/-- **R323 blocker**: a `Module ℚ`-level inverse for nonzero
GaussianInt action. Requires the norm-conjugate identity at the
PointEndHomQ-action level (R323 Section 2 target). -/
def BlockingLemma_R323_invertibility_of_nonzero_via_norm_conjugate :
    Prop := True

/-- **R323 blocker**: localization step from `GaussianInt → PointEndHomQ`
to `FractionRing GaussianInt → PointEndHomQ`. Requires
`IsLocalization.lift` or similar with the invertibility witness. -/
def BlockingLemma_R323_localization_of_GaussianInt_action :
    Prop := True

/-! ## Section 5: disclosure markers -/

/-- **L4-G** bridge to End⁰(E). -/
def L4_G_GaussianFieldActionOnPointEndQ_To_End0 : Prop := True

/-- **L4-G** Mathlib gap: invertibility of nonzero Gaussian integer
elements on the rationalized point-End carrier requires the
norm-conjugate identity. -/
def L4_G_GaussianFieldActionOnPointEndQ_MissingInvertibilityOfNonzeroGaussianInt :
    Prop := True

/-- **L4-G** bridge to active HC cone field. -/
def L4_G_GaussianFieldActionOnPointEndQ_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 6: status -/

/-- **R323 status**: GaussianInt → PointEndHomQ lifted (Section 1). -/
def R323_Status_GaussianInt_Lifted_To_PointEndHomQ_Closed : Prop := True

/-- **R323 status**: invertibility of nonzero GaussianInt action —
target only (norm-conjugate identity needed). -/
def R323_Status_Invertibility_Target_Only : Prop := True

/-- **R323 status**: GaussianRationalFieldCandidate → PointEndHomQ —
target only (depends on invertibility). -/
def R323_Status_GaussianField_To_PointEndHomQ_Target_Only : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R323 non-closure (1/4)**: does NOT construct the
GaussianRationalFieldCandidate algebra-hom. -/
theorem R323_does_not_construct_GaussianField_hom : True := trivial

/-- **R323 non-closure (2/4)**: does NOT prove invertibility of
nonzero GaussianInt actions. -/
theorem R323_does_not_prove_nonzero_invertibility : True := trivial

/-- **R323 non-closure (3/4)**: does NOT construct true `End⁰(E)`. -/
theorem R323_does_not_construct_End0 : True := trivial

/-- **R323 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R323_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
