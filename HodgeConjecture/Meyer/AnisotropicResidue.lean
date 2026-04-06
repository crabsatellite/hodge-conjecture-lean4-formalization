/-
  HodgeConjecture/Meyer/AnisotropicResidue.lean

  The anisotropic residue is empty for geometric orthogonal factors.

  For SO(p,q) with min(p,q) ≥ 4, the associated quadratic form has
  rank p + q ≥ 8 ≥ 5 and is indefinite, so Meyer's theorem gives
  ℚ-isotropy.  Combined with Witt cancellation, we reduce to a
  Hermitian-type residual.  The key conclusion: there is no anisotropic
  obstruction in the GLB/Orth reduction.

  The Witness Lattice Hypothesis (WLH) states that a lattice embedding
  witnessing the ℚ-isotropy exists.  Meyer's theorem guarantees this
  for all geometric orthogonal types, making the anisotropic barrier
  vacuous.
-/
import HodgeConjecture.Meyer.MeyerTheorem

namespace HodgeConjecture

-- ============================================================================
-- Witness Lattice Hypothesis (WLH)
-- ============================================================================

/-- The Witness Lattice Hypothesis for an orthogonal signature:
    the quadratic form admits a rational isotropic vector, which
    provides a lattice witness for the Levi reduction in GLB/Orth.

    When WLH holds, the orthogonal Shimura variety admits a
    rational boundary component of the correct type, enabling
    the Levi reduction to proceed. -/
def WLH (σ : OrthSignature) : Prop := σ.toQuadForm.isIsotropic

-- ============================================================================
-- WLH holds for min(p,q) ≥ 3
-- ============================================================================

/-- WLH holds for all orthogonal signatures with min(p,q) ≥ 3.
    This follows directly from Meyer's theorem since rank ≥ 6 ≥ 5
    and the form is indefinite. -/
theorem WLH_of_nonHermitian_min3 (σ : OrthSignature)
    (h : σ.isNonHermitian_min3) : WLH σ :=
  nonHermitian_min3_isotropic σ h

-- ============================================================================
-- WLH holds for min(p,q) ≥ 4 (the anisotropic residue case)
-- ============================================================================

/-- min(p,q) ≥ 4 implies min(p,q) ≥ 3. -/
theorem min_ge4_nonHermitian (σ : OrthSignature) (h : min σ.p σ.q ≥ 4) :
    σ.isNonHermitian_min3 := by
  show min σ.p σ.q ≥ 3
  omega

/-- WLH holds for all orthogonal signatures with min(p,q) ≥ 4.
    This is the case that was potentially obstructed by anisotropic
    forms, but Meyer's theorem (rank ≥ 8 ≥ 5) eliminates the
    obstruction entirely. -/
theorem WLH_of_min_ge4 (σ : OrthSignature) (h : min σ.p σ.q ≥ 4) :
    WLH σ :=
  WLH_of_nonHermitian_min3 σ (min_ge4_nonHermitian σ h)

-- ============================================================================
-- The anisotropic residue is empty
-- ============================================================================

/-- **Anisotropic residue elimination**: For every orthogonal signature
    with min(p,q) ≥ 4, the quadratic form is ℚ-isotropic.  There is
    no anisotropic case to handle.

    This is the key result for the GLB/Orth reduction: the "anisotropic
    barrier" that could potentially obstruct the proof is vacuous.
    Every geometric orthogonal factor of non-Hermitian type admits
    a rational isotropic vector, and hence a lattice witness for the
    Levi reduction.

    The proof chain:
    1. min(p,q) ≥ 4 → min(p,q) ≥ 3 (arithmetic)
    2. min(p,q) ≥ 3 → p + q ≥ 6 ≥ 5 (arithmetic)
    3. p ≥ 1 ∧ q ≥ 1 → indefinite (from OrthSignature)
    4. rank ≥ 5 ∧ indefinite → ℚ-isotropic (Meyer's theorem)
    5. ℚ-isotropic → WLH (definition)
    6. WLH → no anisotropic residue (definition) -/
theorem anisotropic_residue_empty :
    ∀ σ : OrthSignature, min σ.p σ.q ≥ 4 → σ.toQuadForm.isIsotropic := by
  intro σ h
  exact WLH_of_min_ge4 σ h

/-- Equivalent formulation: there is no orthogonal signature with
    min(p,q) ≥ 4 that is ℚ-anisotropic. -/
theorem no_anisotropic_geometric_form :
    ¬ ∃ σ : OrthSignature, min σ.p σ.q ≥ 4 ∧ σ.toQuadForm.isAnisotropic := by
  intro ⟨σ, hMin, hAniso⟩
  exact hAniso (anisotropic_residue_empty σ hMin)

-- ============================================================================
-- Corollary: the GLB/Orth barrier is vacuous
-- ============================================================================

/-- The "anisotropic barrier" in the GLB/Orth analysis is vacuous:
    for every geometric orthogonal factor (min(p,q) ≥ 3), Meyer's
    theorem guarantees ℚ-isotropy, so WLH always holds and the
    Levi reduction proceeds unconditionally. -/
theorem glb_orth_no_anisotropic_barrier :
    ∀ σ : OrthSignature, σ.isNonHermitian_min3 →
      WLH σ ∧ σ.toQuadForm.isIsotropic := by
  intro σ h
  have hIso := nonHermitian_min3_isotropic σ h
  exact ⟨hIso, hIso⟩

-- ============================================================================
-- Full coverage: all geometric orthogonal types are handled
-- ============================================================================

/-- For any orthogonal signature, either it is Hermitian type (min ≤ 2,
    handled by HC/Ab) or it is non-Hermitian (min ≥ 3, where Meyer
    applies and WLH holds).

    This trichotomy is exhaustive:
    - min(p,q) ≤ 2: Hermitian symmetric domain, abelian-type Shimura variety
    - min(p,q) = 3: non-Hermitian, rank ≥ 6, Meyer applies
    - min(p,q) ≥ 4: non-Hermitian, rank ≥ 8, Meyer applies a fortiori -/
theorem orth_coverage_trichotomy (σ : OrthSignature) :
    σ.isHermitian ∨ (σ.isNonHermitian_min3 ∧ WLH σ) := by
  by_cases h : min σ.p σ.q ≤ 2
  · left
    exact h
  · right
    push Not at h
    have h3 : min σ.p σ.q ≥ 3 := by omega
    exact ⟨h3, WLH_of_nonHermitian_min3 σ h3⟩

end HodgeConjecture
