/-
  HodgeConjecture/Meyer/QuadraticForms.lean

  Rational quadratic forms: signature, indefiniteness, isotropy, anisotropy,
  Witt index, and Witt cancellation.

  A non-degenerate rational quadratic form Q on ℚ^n has a real signature (p,q)
  with p + q = n.  The form is indefinite when both p ≥ 1 and q ≥ 1.
  ℚ-isotropy means there exists a non-zero rational vector v with Q(v) = 0.
  The Witt index is the maximal dimension of a totally isotropic ℚ-subspace.
-/
import HodgeConjecture.Defs.MumfordTate

namespace HodgeConjecture

-- ============================================================================
-- Rational quadratic form (abstract)
-- ============================================================================

/-- A non-degenerate rational quadratic form, abstractly specified by its
    real signature (p, q) where p counts positive eigenvalues and q counts
    negative eigenvalues.  The rank is p + q. -/
structure RatQuadForm where
  /-- Number of positive eigenvalues in the real signature. -/
  posIndex : ℕ
  /-- Number of negative eigenvalues in the real signature. -/
  negIndex : ℕ
  /-- Non-degeneracy: the form has positive rank. -/
  hRank : posIndex + negIndex ≥ 1

/-- The rank of a rational quadratic form. -/
def RatQuadForm.rank (Q : RatQuadForm) : ℕ := Q.posIndex + Q.negIndex

-- ============================================================================
-- Indefiniteness
-- ============================================================================

/-- A rational quadratic form is indefinite if it represents both positive
    and negative values over ℝ, i.e., both signature indices are positive. -/
def RatQuadForm.isIndefinite (Q : RatQuadForm) : Prop :=
  Q.posIndex ≥ 1 ∧ Q.negIndex ≥ 1

-- ============================================================================
-- ℚ-isotropy and ℚ-anisotropy
-- ============================================================================

/-- A rational quadratic form is ℚ-isotropic if there exists a non-zero
    rational vector v such that Q(v) = 0.  This is an abstract predicate;
    we do not formalize the vector space. -/
axiom RatQuadForm.isIsotropic : RatQuadForm → Prop

/-- A rational quadratic form is ℚ-anisotropic if it is not ℚ-isotropic. -/
def RatQuadForm.isAnisotropic (Q : RatQuadForm) : Prop :=
  ¬ Q.isIsotropic

-- ============================================================================
-- Witt index and Witt decomposition
-- ============================================================================

/-- The Witt index of a rational quadratic form: the maximal dimension of
    a totally isotropic ℚ-subspace. -/
axiom RatQuadForm.wittIndex : RatQuadForm → ℕ

/-- The Witt index is at most min(posIndex, negIndex). -/
axiom RatQuadForm.wittIndex_le_min (Q : RatQuadForm) :
  Q.wittIndex ≤ min Q.posIndex Q.negIndex

/-- A form is ℚ-isotropic iff its Witt index is at least 1. -/
axiom RatQuadForm.isotropic_iff_wittIndex (Q : RatQuadForm) :
  Q.isIsotropic ↔ Q.wittIndex ≥ 1

-- ============================================================================
-- Construction: the quadratic form associated to an orthogonal signature
-- ============================================================================

/-- The standard rational quadratic form of signature (p, q) associated to
    the real group SO(p, q).  Since p ≥ 1 and q ≥ 1 by OrthSignature, this
    form has rank p + q ≥ 2 and is indefinite. -/
def OrthSignature.toQuadForm (σ : OrthSignature) : RatQuadForm where
  posIndex := σ.p
  negIndex := σ.q
  hRank := by have := σ.hp; omega

/-- The quadratic form of an OrthSignature is indefinite. -/
theorem OrthSignature.quadForm_indefinite (σ : OrthSignature) :
    σ.toQuadForm.isIndefinite := by
  constructor
  · exact σ.hp
  · exact σ.hq

/-- The rank of the quadratic form equals p + q. -/
theorem OrthSignature.quadForm_rank (σ : OrthSignature) :
    σ.toQuadForm.rank = σ.p + σ.q := by
  rfl

end HodgeConjecture
