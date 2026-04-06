/-
  HodgeConjecture/Meyer/Main.lean

  Main entry point for the Meyer module.  Combines quadratic form
  definitions, Meyer's theorem, and the anisotropic residue elimination
  into a clean export interface.

  Key exported results:
  - `meyer_theorem`: axiom (rank ≥ 5, indefinite → ℚ-isotropic)
  - `meyer_rank_verification`: proved (min(p,q) ≥ 3 → rank ≥ 5 ∧ indefinite)
  - `anisotropic_residue_empty`: proved (min(p,q) ≥ 4 → isotropic)
  - `orth_coverage_trichotomy`: proved (Hermitian ∨ (non-Hermitian ∧ WLH))
-/
import HodgeConjecture.Meyer.QuadraticForms
import HodgeConjecture.Meyer.MeyerTheorem
import HodgeConjecture.Meyer.AnisotropicResidue

namespace HodgeConjecture

-- ============================================================================
-- Re-exported summary theorems
-- ============================================================================

/-- **Meyer rank verification** (export): For SO(p,q) with min(p,q) ≥ 3,
    the associated quadratic form has rank ≥ 5 and is indefinite.
    Both conjuncts are proved by pure arithmetic from the signature bounds.
    Meyer's theorem then gives ℚ-isotropy. -/
theorem meyer_applies_to_geometric_orth (σ : OrthSignature)
    (h : σ.isNonHermitian_min3) :
    σ.toQuadForm.rank ≥ 5 ∧ σ.toQuadForm.isIndefinite ∧
    σ.toQuadForm.isIsotropic := by
  obtain ⟨hRank, hIndef⟩ := meyer_rank_verification σ h
  exact ⟨hRank, hIndef, nonHermitian_min3_isotropic σ h⟩

/-- **Anisotropic residue empty** (export): For all orthogonal signatures
    with min(p,q) ≥ 4, the quadratic form is ℚ-isotropic.  The anisotropic
    barrier in GLB/Orth is vacuous. -/
theorem meyer_eliminates_anisotropic_barrier :
    ∀ σ : OrthSignature, min σ.p σ.q ≥ 4 →
      σ.toQuadForm.isIsotropic ∧ WLH σ := by
  intro σ h
  have hIso := anisotropic_residue_empty σ h
  exact ⟨hIso, hIso⟩

/-- **Orthogonal coverage** (export): Every orthogonal Shimura datum is
    either Hermitian type (handled by HC/Ab via Kuga-Satake) or
    non-Hermitian with WLH guaranteed (handled by GLB/Orth via Levi
    reduction + AHD pipeline).  No orthogonal type escapes the proof. -/
theorem meyer_orthogonal_complete_coverage (σ : OrthSignature) :
    σ.isHermitian ∨ (σ.isNonHermitian_min3 ∧ WLH σ) :=
  orth_coverage_trichotomy σ

end HodgeConjecture
