/-
# HC Gap L4 — Hodge decomposition compatibility (R347).

R345 built the internal H¹ action: `(a + bi) • (v₁, v₂) =
(a*v₁ - b*v₂, b*v₁ + a*v₂)`. R346 built the H² action via norm.
R347 records the Hodge decomposition compatibility:

* `i² = -id` on H¹ at the internal model (proved structurally in R345).
* For the elliptic curve E with CM by ℚ(i), after tensoring H¹ with ℂ,
  the i-action has eigenvalues `±i`, giving the Hodge decomposition
  `H¹_ℂ = H^{1,0} ⊕ H^{0,1}` as the i and -i eigenspaces.
* At the internal ℚ-model (without complexification), we record
  this as a target structure with `i² + id = 0` (the minimal
  polynomial relation).

What R347 does NOT do:
* Does NOT complexify the internal H¹.
* Does NOT construct the eigenspace decomposition over ℂ.
* Does NOT close `mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianFieldActionOnInternalH1
import HodgeReduction.HCGapL4.GaussianFieldActionOnInternalH2

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: i² + id = 0 on H¹ (already in R345) -/

/-- **R347** the i-action on H¹ satisfies its minimal polynomial
`T² + 1 = 0`. This is the precise CM-eigenvalue structure: after
complexification, the i-action splits H¹_ℂ into ±i eigenspaces. -/
theorem GaussianFieldPair_to_H1LinearMap_pair_i_min_poly :
    (GaussianFieldPair_to_H1LinearMap GaussianFieldPair_i).comp
        (GaussianFieldPair_to_H1LinearMap GaussianFieldPair_i)
      + LinearMap.id = 0 := by
  rw [GaussianFieldPair_to_H1LinearMap_i_sq]
  ext v <;> simp

/-! ## Section 2: gaussianRationalI satisfies the minimal polynomial -/

/-- **R347** at the field level: `i ∈ ℚ(i)` acts on H¹ satisfying
`T² + 1 = 0`. -/
theorem GaussianField_to_H1LinearMap_gaussianRationalI_min_poly :
    (GaussianField_to_H1LinearMap gaussianRationalI).comp
        (GaussianField_to_H1LinearMap gaussianRationalI)
      + LinearMap.id = 0 := by
  unfold GaussianField_to_H1LinearMap
  rw [GaussianRationalFieldCandidate_AlgEquiv_GaussianFieldPair_map_i]
  exact GaussianFieldPair_to_H1LinearMap_pair_i_min_poly

/-! ## Section 3: Hodge decomposition target -/

/-- **R347 target**: after complexification of H¹ to `H¹_ℂ`, the
i-action gives the Hodge decomposition `H¹_ℂ = H^{1,0} ⊕ H^{0,1}`
as i and -i eigenspaces. Requires complex tensor product
`ℚ × ℚ ⊗[ℚ] ℂ`, which is Mathlib-heavy. -/
def Target_R347_Hodge_Decomposition_Via_Complexification : Prop := True

/-- **R347 target**: the eigenspace `H^{1,0}` is spanned by `(1, -i) ⊗ 1`
in `(ℚ × ℚ) ⊗[ℚ] ℂ` (i-eigenvalue `i`). -/
def Target_R347_H1_0_Eigenvector : Prop := True

/-- **R347 target**: the eigenspace `H^{0,1}` is spanned by `(1, i) ⊗ 1`
in `(ℚ × ℚ) ⊗[ℚ] ℂ` (i-eigenvalue `-i`). -/
def Target_R347_H0_1_Eigenvector : Prop := True

/-! ## Section 4: status / markers -/

def R347_Status_PairI_MinPoly_Closed : Prop := True
def R347_Status_FieldI_MinPoly_Closed : Prop := True
def R347_Status_Hodge_Decomposition_Target_Pending : Prop := True

def L4_G_HodgeDecompCompatibility_To_CycleClassEquivariance : Prop := True
def L4_G_HodgeDecompCompatibility_To_mtCorrespondencePackage : Prop := True

theorem R347_does_not_construct_eigenspace_decomp : True := trivial
theorem R347_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
