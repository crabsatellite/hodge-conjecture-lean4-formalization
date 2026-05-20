/-
# HC Gap L4 — Gaussian field action into `PointEndHomQ` (R343).

R342 closed the master AlgEquiv `ℚ(i) ≃ₐ[ℚ] GaussianFieldPairCarrier`.
R336 closed multiplication preservation of the pair embedding
`GaussianFieldPair_to_PointEndHomQ`.

R343 composes these to construct the actual
`GaussianRationalFieldCandidate → PointEndHomQ` action, then verifies:
* `1 ↦ pointEnd_id_Q`
* `gaussianRationalI ↦ gaussianCM_phi_Q`
* Additivity
* Multiplicativity (using R336)

This closes R338 next-target 2.

What R343 does NOT do:
* Does NOT construct cohomology action (R325 + R341+ next).
* Does NOT construct true algebraic `End⁰(E)`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianRationalPairAlgEquiv
import HodgeReduction.HCGapL4.GaussianFieldActionViaSubring

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: define the Gaussian field action -/

/-- **R343** the Gaussian field action `ℚ(i) → PointEndHomQ`,
defined as the composition `pair ∘ AlgEquiv`. -/
noncomputable def GaussianField_to_PointEndHomQ
    (x : GaussianRationalFieldCandidate) : PointEndHomQ :=
  GaussianFieldPair_to_PointEndHomQ
    (GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair x)

/-! ## Section 2: preservation theorems -/

/-- **R343** `1 ↦ pointEnd_id_Q`. -/
theorem GaussianField_to_PointEndHomQ_map_one :
    GaussianField_to_PointEndHomQ 1 = pointEnd_id_Q := by
  unfold GaussianField_to_PointEndHomQ
  rw [map_one]
  exact GaussianFieldPair_to_PointEndHomQ_one

/-- **R343** `0 ↦ 0`. -/
theorem GaussianField_to_PointEndHomQ_map_zero :
    GaussianField_to_PointEndHomQ 0 = 0 := by
  unfold GaussianField_to_PointEndHomQ
  rw [map_zero]
  exact GaussianFieldPair_to_PointEndHomQ_zero

/-- **R343** `gaussianRationalI ↦ gaussianCM_phi_Q`. -/
theorem GaussianField_to_PointEndHomQ_map_i :
    GaussianField_to_PointEndHomQ gaussianRationalI = gaussianCM_phi_Q := by
  unfold GaussianField_to_PointEndHomQ
  rw [GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair_map_i]
  -- Goal: GaussianFieldPair_to_PointEndHomQ pair_i = gaussianCM_phi_Q
  -- pair_i = ⟨0, 1⟩, so embedding gives 0 • id_Q + 1 • φ_Q = φ_Q
  show (GaussianFieldPair_i.re : ℚ) • pointEnd_id_Q
       + (GaussianFieldPair_i.im : ℚ) • gaussianCM_phi_Q
       = gaussianCM_phi_Q
  rw [GaussianFieldPair_i_re, GaussianFieldPair_i_im]
  simp

/-- **R343** additivity. -/
theorem GaussianField_to_PointEndHomQ_map_add
    (x y : GaussianRationalFieldCandidate) :
    GaussianField_to_PointEndHomQ (x + y)
      = GaussianField_to_PointEndHomQ x + GaussianField_to_PointEndHomQ y := by
  unfold GaussianField_to_PointEndHomQ
  rw [map_add]
  exact GaussianFieldPair_to_PointEndHomQ_add _ _

/-- **R343** negation. -/
theorem GaussianField_to_PointEndHomQ_map_neg
    (x : GaussianRationalFieldCandidate) :
    GaussianField_to_PointEndHomQ (-x) = -(GaussianField_to_PointEndHomQ x) := by
  unfold GaussianField_to_PointEndHomQ
  rw [map_neg]
  exact GaussianFieldPair_to_PointEndHomQ_neg _

/-- **R343** multiplicativity (using R336). -/
theorem GaussianField_to_PointEndHomQ_map_mul
    (x y : GaussianRationalFieldCandidate) :
    GaussianField_to_PointEndHomQ (x * y)
      = PointEndHomQ_mul
          (GaussianField_to_PointEndHomQ x)
          (GaussianField_to_PointEndHomQ y) := by
  unfold GaussianField_to_PointEndHomQ
  rw [map_mul]
  exact GaussianFieldPair_to_PointEndHomQ_mul _ _

/-! ## Section 3: close R338 target 2 -/

/-- **R343** closure of R338 next-target 2: the
`GaussianRationalFieldCandidate → PointEndHomQ` map exists. -/
theorem R338_NextTarget_GaussianField_To_PointEndHomQ_closed :
    Nonempty (GaussianRationalFieldCandidate → PointEndHomQ) :=
  ⟨GaussianField_to_PointEndHomQ⟩

/-! ## Section 4: status / markers -/

def R343_Status_Action_Defined : Prop := True
def R343_Status_Map_One_Closed : Prop := True
def R343_Status_Map_Zero_Closed : Prop := True
def R343_Status_Map_I_Closed : Prop := True
def R343_Status_Map_Add_Closed : Prop := True
def R343_Status_Map_Neg_Closed : Prop := True
def R343_Status_Map_Mul_Closed : Prop := True
def R343_Status_R338_Target2_Closed : Prop := True

def L4_G_GaussianFieldActionPointEndQ_To_CohomologyAction : Prop := True
def L4_G_GaussianFieldActionPointEndQ_To_mtCorrespondencePackage :
    Prop := True
def L4_G_GaussianFieldActionPointEndQ_PointEnd_NotYetTrueAlgebraicEnd :
    Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R343 non-closure (1/4)**: does NOT construct cohomology action. -/
theorem R343_does_not_construct_cohomology_action : True := trivial

/-- **R343 non-closure (2/4)**: does NOT construct true `End⁰(E)`. -/
theorem R343_does_not_construct_End0 : True := trivial

/-- **R343 non-closure (3/4)**: does NOT prove `PointEndHomQ` equals
true algebraic `End⁰`. -/
theorem R343_does_not_prove_pointEnd_eq_algebraicEnd : True := trivial

/-- **R343 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R343_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
