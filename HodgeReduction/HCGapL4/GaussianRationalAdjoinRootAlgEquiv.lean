/-
# HC Gap L4 — full AlgEquiv `ℚ(i) ≃ₐ[ℚ] AdjoinRoot (X²+1)` (R286).

R281 gave the forward AlgHom
`GaussianAdjoinRoot_to_GaussianRational : AdjoinRoot →ₐ[ℚ] FractionRing`.
R285 gave the reverse AlgHom
`GaussianRational_to_GaussianAdjoinRoot_AlgHom : FractionRing →ₐ[ℚ] AdjoinRoot`.
R286 proves they are mutual inverses and constructs the `AlgEquiv`.

## Mathlib API used

* `AdjoinRoot.algHom_ext` (`AdjoinRoot.lean:166`) — AlgHom from
  `AdjoinRoot` agree iff they agree on `root`.
* `AdjoinRoot.liftHom_root` (`AdjoinRoot.lean:294`) — `liftHom f a hfx
  (root f) = a`.
* `IsLocalization.ringHom_ext` (`Localization/Defs.lean:501`) — two
  ring homs from a localization agree iff they agree precomposed
  with `algebraMap R S`.
* `IsFractionRing.lift_algebraMap` (`Localization/FractionRing.lean:265`) —
  the lift agrees with the original ring hom on `algebraMap A K`.
* `Zsqrtd.hom_ext` (`Zsqrtd/Basic.lean:885`) — two ring homs from
  `ℤ√d` agree iff they agree on `sqrtd`.
* `AlgEquiv.ofAlgHom` (`Algebra/Equiv.lean:472`).

## What R286 (this file) provides (all kernel-pure)

* `GaussianAdjoinRoot_to_GaussianRational_root` — `fwd root = gaussianRationalI`.
* `GaussianRational_to_GaussianAdjoinRoot_AlgHom_algebraMap` — `rev
  (algebraMap x) = GaussianInt_to_GaussianAdjoinRoot x`.
* `rev_comp_fwd_eq_id` — `rev ∘ fwd = AlgHom.id` on AdjoinRoot.
* `fwd_comp_rev_eq_id` — `fwd ∘ rev = AlgHom.id` on FractionRing.
* `GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot` — full AlgEquiv.
* Generator transport sanity theorems.
* Closure of R281's `Target_GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot`.

## What R286 (this file) does NOT do

* Does NOT transfer FiniteDimensional / NumberField — that is R287's job.
* Does NOT prove CMField / End⁰(E).
* Does NOT close `canonicalE7ShimuraTor`.

All R286 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalToAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.GaussianPolynomialIrreducible
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.RingTheory.Localization.FractionRing

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: generator computations -/

/-- **R286** `fwd root = gaussianRationalI` (where `fwd` is R281's
forward AlgHom). -/
theorem GaussianAdjoinRoot_to_GaussianRational_root :
    GaussianAdjoinRoot_to_GaussianRational
        (AdjoinRoot.root GaussianPolynomialOverQ) =
      gaussianRationalI :=
  AdjoinRoot.liftHom_root
    (a := gaussianRationalI)
    (hfx := aeval_gaussianPolynomial_gaussianRationalI)

/-- **R286** `rev (algebraMap x) = GaussianInt_to_GaussianAdjoinRoot x`. -/
theorem GaussianRational_to_GaussianAdjoinRoot_AlgHom_algebraMap
    (x : GaussianInt) :
    GaussianRational_to_GaussianAdjoinRoot_AlgHom
        (algebraMap GaussianInt GaussianRationalFieldCandidate x) =
      GaussianInt_to_GaussianAdjoinRoot x := by
  show GaussianRational_to_GaussianAdjoinRoot_RingHom
        (algebraMap GaussianInt GaussianRationalFieldCandidate x) = _
  exact IsFractionRing.lift_algebraMap _ x

/-- **R286** `GaussianInt_to_GaussianAdjoinRoot sqrtd = root`.
Proof via the inverse half of the `Zsqrtd.lift` equivalence:
`Zsqrtd.lift.symm` extracts the `√d`-image, so the constructed
ring hom evaluates at `sqrtd` to the chosen root. -/
theorem GaussianInt_to_GaussianAdjoinRoot_sqrtd :
    GaussianInt_to_GaussianAdjoinRoot (Zsqrtd.sqrtd : GaussianInt) =
      AdjoinRoot.root GaussianPolynomialOverQ := by
  -- By definition of GaussianInt_to_GaussianAdjoinRoot via Zsqrtd.lift,
  -- applied to sqrtd, we recover the chosen root (the `√d`-image).
  -- Use the Equiv.symm_apply_apply / right_inv structure of Zsqrtd.lift.
  have h := (Zsqrtd.lift.symm_apply_apply
              (⟨AdjoinRoot.root GaussianPolynomialOverQ,
                gaussianAdjoinRootI_sq_eq_neg_one_int⟩ :
                { r : GaussianAdjoinRootCandidate // r * r = ((-1 : ℤ) : _) }))
  -- h : Zsqrtd.lift.symm (Zsqrtd.lift ⟨root, _⟩) = ⟨root, _⟩
  -- And Zsqrtd.lift.symm f = ⟨f sqrtd, _⟩ by definition.
  -- So `f sqrtd = root` for `f = Zsqrtd.lift ⟨root, _⟩ = GaussianInt_to_GaussianAdjoinRoot`.
  exact congr_arg Subtype.val h

/-- **R286** `rev gaussianRationalI = root`. -/
theorem GaussianRational_to_GaussianAdjoinRoot_AlgHom_i :
    GaussianRational_to_GaussianAdjoinRoot_AlgHom gaussianRationalI =
      AdjoinRoot.root GaussianPolynomialOverQ := by
  unfold gaussianRationalI
  show GaussianRational_to_GaussianAdjoinRoot_AlgHom
        (algebraMap GaussianInt GaussianRationalFieldCandidate gaussianIntI) = _
  rw [GaussianRational_to_GaussianAdjoinRoot_AlgHom_algebraMap]
  show GaussianInt_to_GaussianAdjoinRoot (Zsqrtd.sqrtd : GaussianInt) = _
  exact GaussianInt_to_GaussianAdjoinRoot_sqrtd

/-! ## Section 2: rev ∘ fwd = id on AdjoinRoot -/

/-- **R286** the AdjoinRoot-side inverse. -/
theorem rev_comp_fwd_eq_id :
    GaussianRational_to_GaussianAdjoinRoot_AlgHom.comp
      GaussianAdjoinRoot_to_GaussianRational =
        AlgHom.id ℚ GaussianAdjoinRootCandidate := by
  apply AdjoinRoot.algHom_ext
  -- Show agreement on root: rev (fwd root) = id root = root
  show GaussianRational_to_GaussianAdjoinRoot_AlgHom
        (GaussianAdjoinRoot_to_GaussianRational
          (AdjoinRoot.root GaussianPolynomialOverQ)) =
       AdjoinRoot.root GaussianPolynomialOverQ
  rw [GaussianAdjoinRoot_to_GaussianRational_root,
      GaussianRational_to_GaussianAdjoinRoot_AlgHom_i]

/-! ## Section 3: fwd ∘ rev = id on FractionRing -/

/-- **R286** the FractionRing-side inverse. -/
theorem fwd_comp_rev_eq_id :
    GaussianAdjoinRoot_to_GaussianRational.comp
      GaussianRational_to_GaussianAdjoinRoot_AlgHom =
        AlgHom.id ℚ GaussianRationalFieldCandidate := by
  apply AlgHom.coe_ringHom_injective
  apply IsLocalization.ringHom_ext (nonZeroDivisors GaussianInt)
  -- Now: two ring homs GaussianInt → FractionRing GaussianInt
  --   LHS: fwd ∘ rev ∘ algebraMap = fwd ∘ GaussianInt_to_GaussianAdjoinRoot
  --   RHS: id ∘ algebraMap = algebraMap
  -- Apply Zsqrtd.hom_ext: agree iff agree on sqrtd.
  apply Zsqrtd.hom_ext (d := -1)
  -- Goal: LHS sqrtd = RHS sqrtd
  show GaussianAdjoinRoot_to_GaussianRational
        (GaussianRational_to_GaussianAdjoinRoot_AlgHom
          (algebraMap GaussianInt GaussianRationalFieldCandidate Zsqrtd.sqrtd)) =
       algebraMap GaussianInt GaussianRationalFieldCandidate Zsqrtd.sqrtd
  rw [GaussianRational_to_GaussianAdjoinRoot_AlgHom_algebraMap,
      GaussianInt_to_GaussianAdjoinRoot_sqrtd,
      GaussianAdjoinRoot_to_GaussianRational_root]
  -- Now goal: gaussianRationalI = algebraMap _ _ sqrtd
  -- By definition gaussianRationalI = algebraMap _ _ gaussianIntI = algebraMap _ _ sqrtd
  rfl

/-! ## Section 4: full AlgEquiv -/

/-- **R286** the full AlgEquiv between `GaussianRationalFieldCandidate`
and `GaussianAdjoinRootCandidate`. -/
noncomputable def GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot :
    GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate :=
  AlgEquiv.ofAlgHom
    GaussianRational_to_GaussianAdjoinRoot_AlgHom
    GaussianAdjoinRoot_to_GaussianRational
    rev_comp_fwd_eq_id
    fwd_comp_rev_eq_id

/-! ## Section 5: generator transport sanity theorems -/

/-- **R286** sanity: the AlgEquiv maps `i` to `root`. -/
theorem GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot_map_i :
    GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot gaussianRationalI =
      AdjoinRoot.root GaussianPolynomialOverQ :=
  GaussianRational_to_GaussianAdjoinRoot_AlgHom_i

/-- **R286** sanity: the inverse AlgEquiv maps `root` to `i`. -/
theorem GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot_symm_map_root :
    GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot.symm
      (AdjoinRoot.root GaussianPolynomialOverQ) =
        gaussianRationalI :=
  GaussianAdjoinRoot_to_GaussianRational_root

/-! ## Section 6: closure of R281 AlgEquiv target -/

/-- **R286** closure: R281's
`Target_GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot` is now
real evidence. -/
theorem Target_GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot_closed :
    Nonempty (GaussianRationalFieldCandidate ≃ₐ[ℚ] GaussianAdjoinRootCandidate) :=
  ⟨GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot⟩

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianRationalAdjoinRootAlgEquiv_To_NumberField**:
R286 closure unlocks NumberField transfer (R287 target). -/
def L4_G_GaussianRationalAdjoinRootAlgEquiv_To_NumberField : Prop := True

/-- **L4-G_GaussianRationalAdjoinRootAlgEquiv_To_FiniteDimensional**:
finite-dim transfer via AlgEquiv (R287 target). -/
def L4_G_GaussianRationalAdjoinRootAlgEquiv_To_FiniteDimensional :
    Prop := True

/-- **L4-G_GaussianRationalAdjoinRootAlgEquiv_To_finrankTwo**: finrank
= 2 transfer (R287 target). -/
def L4_G_GaussianRationalAdjoinRootAlgEquiv_To_finrankTwo : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R286 non-closure (1/4)**: does NOT transfer FiniteDimensional /
NumberField (R287 target). -/
theorem R286_does_not_transfer_NumberField : True := trivial

/-- **R286 non-closure (2/4)**: does NOT prove CMField. -/
theorem R286_does_not_prove_CMField : True := trivial

/-- **R286 non-closure (3/4)**: does NOT construct `End⁰(E)`. -/
theorem R286_does_not_construct_End0 : True := trivial

/-- **R286 non-closure (4/4)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R286_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
