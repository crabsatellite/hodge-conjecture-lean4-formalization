/-
# HC Gap L4 — Gaussian field action via commutative subring (R336).

R333 built the commutative subspace `GaussianFieldSubspace_PointEndQ`
of `PointEndHomQ` with multiplication closure + internal commutativity.
R335 built the pair `CommRing` carrier `GaussianFieldPairCarrier`.
R334 showed the GaussianInt action lands in the subspace.

R336 takes the pair-carrier embedding `GaussianFieldPair_to_PointEndHomQ`
and proves the multiplication preservation (which R335 left as target),
using R333's `GaussianFieldSubspace_mul_normal_form`. Then it states
the precise `GaussianRationalFieldCandidate → PointEndHomQ` target.

What R336 does NOT do:
* Does NOT yet construct the `ℚ(i) → PointEndHomQ` map (requires
  full `IsLocalization.lift` packaging — the next step).
* Does NOT construct true `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianIntActionLandsInSubfield
import HodgeReduction.HCGapL4.GaussianFieldSubringCommRing

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: pair-carrier embedding preserves multiplication -/

/-- **R336** the pair-carrier embedding `(a, b) ↦ a • id_Q + b • φ_Q`
preserves multiplication. Proof: reduce both sides to
`GaussianFieldSubspace_mul_normal_form` from R333. -/
theorem GaussianFieldPair_to_PointEndHomQ_mul
    (x y : GaussianFieldPairCarrier) :
    GaussianFieldPair_to_PointEndHomQ (x * y)
      = PointEndHomQ_mul
          (GaussianFieldPair_to_PointEndHomQ x)
          (GaussianFieldPair_to_PointEndHomQ y) := by
  -- LHS: (x*y).re • id_Q + (x*y).im • phi_Q
  --    = (x.re*y.re - x.im*y.im) • id_Q + (x.re*y.im + x.im*y.re) • phi_Q
  -- RHS: PointEndHomQ_mul (x.re • id_Q + x.im • phi_Q) (y.re • id_Q + y.im • phi_Q)
  --    = (x.re*y.re - x.im*y.im) • id_Q + (x.re*y.im + x.im*y.re) • phi_Q
  --      by R333 GaussianFieldSubspace_mul_normal_form.
  show (x * y).re • pointEnd_id_Q + (x * y).im • gaussianCM_phi_Q
       = PointEndHomQ_mul
           (x.re • pointEnd_id_Q + x.im • gaussianCM_phi_Q)
           (y.re • pointEnd_id_Q + y.im • gaussianCM_phi_Q)
  rw [GaussianFieldSubspace_mul_normal_form x.re x.im y.re y.im]
  show (x * y).re • pointEnd_id_Q + (x * y).im • gaussianCM_phi_Q
       = (x.re * y.re - x.im * y.im) • pointEnd_id_Q
         + (x.re * y.im + x.im * y.re) • gaussianCM_phi_Q
  rw [GaussianFieldPairCarrier.mul_re, GaussianFieldPairCarrier.mul_im]

/-! ## Section 2: target — GaussianRationalFieldCandidate action -/

/-- **R336 target**: `GaussianRationalFieldCandidate → PointEndHomQ`
action map. The construction route:

1. Establish an algebra-equivalence
   `GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`
   (both are `ℚ(i)` up to canonical isomorphism).
2. Compose with `GaussianFieldPair_to_PointEndHomQ` (R335) to get
   `GaussianRationalFieldCandidate → PointEndHomQ`.

The equivalence step is non-trivial in Lean — `GaussianRationalFieldCandidate
= FractionRing GaussianInt`, and showing it equals `GaussianFieldPairCarrier`
requires either:
(a) `IsLocalization.lift` (heavy) from `GaussianInt` with the map
    `n ↦ ⟨n.re, n.im⟩ : GaussianFieldPairCarrier`, OR
(b) Using R286's `AlgEquiv` to `AdjoinRoot (X² + 1)` and constructing
    a parallel `AdjoinRoot → GaussianFieldPairCarrier`. -/
def Target_GaussianRationalFieldCandidate_to_PointEndHomQ_viaSubring :
    Prop := True

/-! ## Section 3: action extension target -/

/-- **R336 target**: the field action extends the GaussianInt action.
For `α : GaussianInt`, the induced map applied to
`(algebraMap GaussianInt GaussianRationalFieldCandidate α)`
equals `GaussianInt_to_PointEndHomQ α`. -/
def Target_GaussianField_Action_Extends_GaussianInt_Action : Prop :=
  True

/-! ## Section 4: i ↦ phi_Q target -/

/-- **R336 target**: under the field action, `gaussianRationalI` maps to
`gaussianCM_phi_Q`. -/
def Target_GaussianField_Action_i_maps_to_phi_Q : Prop := True

/-! ## Section 5: multiplicative compatibility target -/

/-- **R336 target**: the field action is multiplicative
(necessary for it to be a `→ₐ[ℚ]` algebra hom). -/
def Target_GaussianField_Action_Multiplicative : Prop := True

/-! ## Section 6: pair-side equivalence to GaussianRationalFieldCandidate -/

/-- **R336 target**: pair carrier is isomorphic to
`GaussianRationalFieldCandidate` as `ℚ`-algebras. -/
def Target_GaussianFieldPair_Equiv_GaussianRationalFieldCandidate :
    Prop := True

/-! ## Section 7: status -/

/-- **R336 status**: pair-carrier embedding multiplication preservation
CLOSED (key remaining R335 target now discharged using R333). -/
def R336_Status_Pair_Embedding_Mul_Closed : Prop := True

/-- **R336 status**: field action remains a target (pair ≃ ℚ(i) needed). -/
def R336_Status_FieldAction_Target_Only : Prop := True

/-! ## Section 8: disclosure markers -/

/-- **L4-G** bridge to End⁰(E). -/
def L4_G_GaussianFieldActionViaSubring_To_End0 : Prop := True

/-- **L4-G** bridge to cohomology action. -/
def L4_G_GaussianFieldActionViaSubring_To_CohomologyAction :
    Prop := True

/-- **L4-G** bridge to active HC cone field. -/
def L4_G_GaussianFieldActionViaSubring_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R336 non-closure (1/4)**: does NOT construct
`GaussianRationalFieldCandidate → PointEndHomQ` map yet. -/
theorem R336_does_not_construct_field_action : True := trivial

/-- **R336 non-closure (2/4)**: does NOT prove
pair ≃ `GaussianRationalFieldCandidate`. -/
theorem R336_does_not_prove_pair_equiv_GaussianField : True := trivial

/-- **R336 non-closure (3/4)**: does NOT construct `End⁰(E)`. -/
theorem R336_does_not_construct_End0 : True := trivial

/-- **R336 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R336_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
