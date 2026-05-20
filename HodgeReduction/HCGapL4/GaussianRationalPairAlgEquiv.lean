/-
# HC Gap L4 — `GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier` (R342).

R286 closed `GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate`.
R341 closed `GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`.
R342 composes them to obtain the master equivalence:
  `GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`,
i.e. `ℚ(i) ≃ₐ[ℚ] pair carrier`.

This closes R338 next-target 1.

What R342 does NOT do:
* Does NOT yet construct `GaussianRationalFieldCandidate → PointEndHomQ`
  (R343 target, composes R342 with R335 embedding).
* Does NOT close `mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianPairAdjoinRootAlgEquiv
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootAlgEquiv

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: composed algebra equivalence -/

/-- **R342** the master algebra equivalence
`GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`,
obtained by composing R286 with R341. -/
noncomputable def GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair :
    GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier :=
  GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot.trans
    GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair

/-! ## Section 2: i ↦ pair_i -/

/-- **R342** the AlgEquiv sends `gaussianRationalI` to `GaussianFieldPair_i`.
Proof: R286 sends `gaussianRationalI` to `AdjoinRoot.root`
(`GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot_map_i`); R341 sends
`AdjoinRoot.root` to `pair_i`
(`GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair_map_root`). -/
theorem GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair_map_i :
    GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair
        gaussianRationalI
      = GaussianFieldPair_i := by
  show GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair
        (GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot gaussianRationalI)
      = GaussianFieldPair_i
  rw [GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot_map_i]
  exact GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair_map_root

/-- **R342** the inverse sends `pair_i` to `gaussianRationalI`. -/
theorem GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair_symm_map_pair_i :
    GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair.symm
        GaussianFieldPair_i
      = gaussianRationalI := by
  -- symm of (a.trans b) = b.symm.trans a.symm
  -- (R341.symm) pair_i = root, (R286.symm) root = gaussianRationalI
  rw [show (GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair.symm
              GaussianFieldPair_i)
            = GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot.symm
                (GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair.symm
                   GaussianFieldPair_i) from rfl]
  rw [GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair_symm_map_pair_i]
  -- Now: R286.symm root = gaussianRationalI
  -- This is the R286 inverse application at root.
  -- From R286: forward sends i to root, so symm sends root to i.
  have h : GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot.symm
              (GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot
                gaussianRationalI)
            = gaussianRationalI := by
    rw [AlgEquiv.symm_apply_apply]
  rw [GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot_map_i] at h
  exact h

/-! ## Section 3: close R338 target 1 -/

/-- **R342** closure of R338 next-target 1: there exists an AlgEquiv
`GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier`. -/
theorem R338_NextTarget_PairCarrier_AlgEquiv_GaussianField_closed :
    Nonempty (GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier) :=
  ⟨GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair⟩

/-! ## Section 4: status / markers -/

def R342_Status_AlgEquiv_Closed : Prop := True
def R342_Status_I_Maps_To_PairI_Closed : Prop := True
def R342_Status_R338_Target1_Closed : Prop := True

def L4_G_GaussianRationalPairAlgEquiv_To_PointEndHomQAction : Prop := True
def L4_G_GaussianRationalPairAlgEquiv_To_CohomologyAction : Prop := True
def L4_G_GaussianRationalPairAlgEquiv_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 5: explicit non-closure -/

theorem R342_does_not_construct_field_to_PointEndHomQ : True := trivial
theorem R342_does_not_close_mtCorrespondencePackage : True := trivial
theorem R342_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
