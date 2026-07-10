import Mathlib.LinearAlgebra.TensorProduct.Tower
import Mathlib.RingTheory.Flat.FaithfullyFlat.Basic

/-!
# Faithfully-flat scalar-extension descent

This is the valid linear-algebra core of the old manuscript's
`p`-adic-descent claim.  It does not supply p-adic algebraicity; it only
descends membership in an already supplied cycle-class image.
-/

namespace HodgeReduction.Canonical

open TensorProduct

universe u v w

set_option maxHeartbeats 800000 in
theorem mem_of_one_tmul_mem_baseChange
    (F : Type u) (K : Type v) (W : Type w)
    [CommRing F] [CommRing K] [Algebra F K] [Module.FaithfullyFlat F K]
    [AddCommGroup W] [Module F W]
    (A : Submodule F W) (w : W)
    (h : (1 : K) ⊗ₜ[F] w ∈ A.baseChange K) :
    w ∈ A := by
  let q : W →ₗ[F] W ⧸ A := A.mkQ
  let qK : K ⊗[F] W →ₗ[K] K ⊗[F] (W ⧸ A) :=
    TensorProduct.AlgebraTensorModule.lTensor K K q
  have hann : ∀ z, z ∈ A.baseChange K → qK z = 0 := by
    intro z hz
    change z ∈ Submodule.span K (A.map (TensorProduct.mk F K W 1)) at hz
    induction hz using Submodule.span_induction with
    | mem z hz =>
        rcases hz with ⟨a, ha, rfl⟩
        simp [qK, q, (Submodule.Quotient.mk_eq_zero A).mpr ha]
    | zero => simp
    | add x y _ _ hx hy => simpa using congrArg₂ (· + ·) hx hy
    | smul k x _ hx => rw [map_smul, hx, smul_zero]
  have hz : qK ((1 : K) ⊗ₜ[F] w) = 0 := hann _ h
  have hquot : A.mkQ w = 0 :=
    (Module.FaithfullyFlat.one_tmul_eq_zero_iff
      (R := F) (M := W ⧸ A) (A := K) (A.mkQ w)).mp (by simpa [qK, q] using hz)
  exact (Submodule.Quotient.mk_eq_zero A).mp hquot

set_option maxHeartbeats 800000 in
theorem scalarExtensionDescent :
  ∀ (F : Type u) (K : Type v) (W : Type w),
    ∀ [CommRing F] [CommRing K] [Algebra F K] [Module.FaithfullyFlat F K]
      [AddCommGroup W] [Module F W],
      ∀ (A : Submodule F W) (w : W),
        (1 : K) ⊗ₜ[F] w ∈ A.baseChange K → w ∈ A := by
  intro F K W _ _ _ _ _ _ A w h
  exact mem_of_one_tmul_mem_baseChange F K W A w h

end HodgeReduction.Canonical
