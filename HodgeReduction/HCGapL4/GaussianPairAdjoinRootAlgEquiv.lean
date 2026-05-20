/-
# HC Gap L4 — `GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier` (R341).

R339 closed the forward AlgHom `AdjoinRoot → pair` via `liftHom`,
sending `root` to `(0, 1)`. R340 closed the reverse AlgHom
`pair → AdjoinRoot` via `(a, b) ↦ a + b·root`. R341 assembles the
two into a full algebra equivalence by verifying mutual inverse.

Mutual inverse proofs use two extensionality principles:
* `AdjoinRoot.algHom_ext` — two AlgHoms out of `AdjoinRoot f` are
  equal iff they agree on `root f`.
* Pair extensionality — two pair values are equal iff their `.re`
  and `.im` agree.

## What R341 provides (kernel-pure)

* `GaussianPair_rev_comp_fwd_eq_id` — `pair → AdjoinRoot → pair = id`
  on pair.
* `GaussianPair_fwd_comp_rev_eq_id` — `AdjoinRoot → pair → AdjoinRoot
  = id` on AdjoinRoot.
* `GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair` — the packaged AlgEquiv.
* `GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair_map_root` —
  generator transport.

All declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.GaussianPairAdjoinRootAlgHom
import HodgeReduction.HCGapL4.GaussianPairToAdjoinRootAlgHom

set_option maxSynthPendingDepth 4

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: AdjoinRoot → pair → AdjoinRoot = id -/

/-- **R341** the composition `AdjoinRoot → pair → AdjoinRoot` equals
the identity on `AdjoinRoot`. Uses `AdjoinRoot.algHom_ext`:
two AlgHoms out of `AdjoinRoot f` are equal iff they agree on the
generator `root`. -/
theorem GaussianPair_fwd_comp_rev_eq_id :
    GaussianFieldPair_to_GaussianAdjoinRoot.comp
        GaussianAdjoinRoot_to_GaussianFieldPair
      = AlgHom.id ℚ GaussianAdjoinRootCandidate := by
  refine AdjoinRoot.algHom_ext ?_
  -- Show: (rev ∘ fwd) root = root
  -- fwd root = pair_i (R339)
  -- rev pair_i = root (R340)
  show GaussianFieldPair_to_GaussianAdjoinRoot
          (GaussianAdjoinRoot_to_GaussianFieldPair
            (AdjoinRoot.root GaussianPolynomialOverQ))
        = AdjoinRoot.root GaussianPolynomialOverQ
  rw [GaussianAdjoinRoot_to_GaussianFieldPair_root]
  exact GaussianFieldPair_to_GaussianAdjoinRoot_pair_i

/-! ## Section 2: pair → AdjoinRoot → pair = id -/

/-- **R341** the composition `pair → AdjoinRoot → pair` equals the
identity on pair. Uses pair extensionality: an AlgHom out of pair is
determined by its values at `1` and at `pair_i`, since pair is
generated as ℚ-algebra by these two elements. We discharge by direct
computation on the normal-form representation `⟨a, b⟩ = a + b·pair_i`. -/
private theorem GaussianPair_rev_comp_fwd_pointwise
    (x : GaussianFieldPairCarrier) :
    GaussianAdjoinRoot_to_GaussianFieldPair
      (GaussianFieldPair_to_GaussianAdjoinRoot x) = x := by
  -- rev x = algebraMap x.re + algebraMap x.im * root
  -- fwd applied: algebraMap x.re + algebraMap x.im * pair_i
  show GaussianAdjoinRoot_to_GaussianFieldPair
        (GaussianFieldPair_to_GaussianAdjoinRoot_fun x) = x
  unfold GaussianFieldPair_to_GaussianAdjoinRoot_fun
  rw [map_add, map_mul, AlgHom.commutes, AlgHom.commutes,
      GaussianAdjoinRoot_to_GaussianFieldPair_root]
  -- Goal: algebraMap ℚ pair x.re + algebraMap ℚ pair x.im * pair_i = x
  apply GaussianFieldPairCarrier.ext
  · show (algebraMap ℚ GaussianFieldPairCarrier x.re).re
         + ((algebraMap ℚ GaussianFieldPairCarrier x.im)
             * GaussianFieldPair_i).re = x.re
    show (algebraMap ℚ GaussianFieldPairCarrier x.re).re
         + ((algebraMap ℚ GaussianFieldPairCarrier x.im).re
             * GaussianFieldPair_i.re
             - (algebraMap ℚ GaussianFieldPairCarrier x.im).im
               * GaussianFieldPair_i.im) = x.re
    rw [algebraMap_GaussianFieldPair_re, algebraMap_GaussianFieldPair_re,
        algebraMap_GaussianFieldPair_im,
        GaussianFieldPair_i_re, GaussianFieldPair_i_im]
    ring
  · show (algebraMap ℚ GaussianFieldPairCarrier x.re).im
         + ((algebraMap ℚ GaussianFieldPairCarrier x.im)
             * GaussianFieldPair_i).im = x.im
    show (algebraMap ℚ GaussianFieldPairCarrier x.re).im
         + ((algebraMap ℚ GaussianFieldPairCarrier x.im).re
             * GaussianFieldPair_i.im
             + (algebraMap ℚ GaussianFieldPairCarrier x.im).im
               * GaussianFieldPair_i.re) = x.im
    rw [algebraMap_GaussianFieldPair_im, algebraMap_GaussianFieldPair_re,
        algebraMap_GaussianFieldPair_im,
        GaussianFieldPair_i_re, GaussianFieldPair_i_im]
    ring

theorem GaussianPair_rev_comp_fwd_eq_id :
    GaussianAdjoinRoot_to_GaussianFieldPair.comp
        GaussianFieldPair_to_GaussianAdjoinRoot
      = AlgHom.id ℚ GaussianFieldPairCarrier := by
  apply AlgHom.ext
  intro x
  exact GaussianPair_rev_comp_fwd_pointwise x

/-! ## Section 3: the AlgEquiv -/

/-- **R341** the algebra equivalence `GaussianAdjoinRootCandidate
≃ₐ[ℚ] GaussianFieldPairCarrier`. Forward: `R339`; reverse: `R340`;
mutual inverse: this file. -/
noncomputable def GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair :
    GaussianAdjoinRootCandidate ≃ₐ[ℚ] GaussianFieldPairCarrier :=
  AlgEquiv.ofAlgHom
    GaussianAdjoinRoot_to_GaussianFieldPair
    GaussianFieldPair_to_GaussianAdjoinRoot
    GaussianPair_rev_comp_fwd_eq_id
    GaussianPair_fwd_comp_rev_eq_id

/-! ## Section 4: generator transport -/

/-- **R341** the AlgEquiv sends `AdjoinRoot.root` to `pair_i`. -/
theorem GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair_map_root :
    GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair
        (AdjoinRoot.root GaussianPolynomialOverQ)
      = GaussianFieldPair_i :=
  GaussianAdjoinRoot_to_GaussianFieldPair_root

/-- **R341** the inverse AlgEquiv sends `pair_i` to `AdjoinRoot.root`. -/
theorem GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair_symm_map_pair_i :
    GaussianAdjoinRoot_AlgEquiv_GaussianFieldPair.symm GaussianFieldPair_i
      = AdjoinRoot.root GaussianPolynomialOverQ :=
  GaussianFieldPair_to_GaussianAdjoinRoot_pair_i

/-! ## Section 5: status / markers -/

def R341_Status_Fwd_Comp_Rev_Id_Closed : Prop := True
def R341_Status_Rev_Comp_Fwd_Id_Closed : Prop := True
def R341_Status_AlgEquiv_Closed : Prop := True
def R341_Status_Generator_Transport_Closed : Prop := True

def L4_G_GaussianPairAdjoinRootAlgEquiv_To_GaussianRationalField :
    Prop := True
def L4_G_GaussianPairAdjoinRootAlgEquiv_To_PointEndQAction : Prop := True
def L4_G_GaussianPairAdjoinRootAlgEquiv_To_mtCorrespondencePackage :
    Prop := True

/-! ## Section 6: explicit non-closure -/

theorem R341_does_not_close_full_ℚi_pair_equiv : True := trivial
theorem R341_does_not_close_mtCorrespondencePackage : True := trivial
theorem R341_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
