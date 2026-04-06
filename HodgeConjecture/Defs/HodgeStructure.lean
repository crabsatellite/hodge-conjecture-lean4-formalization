/-
  HodgeConjecture/Defs/HodgeStructure.lean

  Abstract definitions of Hodge structures, Hodge classes, the cycle class map,
  and the formal statement of the Hodge Conjecture.

  These are opaque types: the deep algebraic geometry is not formalized.
  We declare them as axioms/constants to serve as the interface for the
  proof chain.
-/
import Mathlib.Tactic

namespace HodgeConjecture

-- ============================================================================
-- Core mathematical objects (opaque)
-- ============================================================================

/-- A smooth projective variety over ℂ. Opaque type. -/
axiom SmoothProjVar : Type

/-- The dimension of a smooth projective variety. -/
axiom SmoothProjVar.dim : SmoothProjVar → ℕ

/-- An abelian variety over ℂ (subtype of smooth projective varieties). -/
axiom AbelianVar : Type

/-- Coercion: every abelian variety is a smooth projective variety. -/
axiom AbelianVar.toSmoothProjVar : AbelianVar → SmoothProjVar

noncomputable instance : Coe AbelianVar SmoothProjVar := ⟨AbelianVar.toSmoothProjVar⟩

/-- Rational Hodge class space: Hdg^{2p}(X, ℚ) = H^{p,p}(X) ∩ H^{2p}(X, ℚ).
    Elements are rational cohomology classes of Hodge type (p,p). -/
axiom HdgClass (X : SmoothProjVar) (p : ℕ) : Type

/-- The Chow group CH^p(X)_ℚ of codimension-p algebraic cycles tensored with ℚ. -/
axiom ChowGroup (X : SmoothProjVar) (p : ℕ) : Type

/-- The cycle class map cl_X : CH^p(X)_ℚ → Hdg^{2p}(X, ℚ). -/
axiom cycleClassMap (X : SmoothProjVar) (p : ℕ) :
  ChowGroup X p → HdgClass X p

/-- A Hodge class is algebraic if it lies in the image of the cycle class map. -/
def isAlgebraic (X : SmoothProjVar) (p : ℕ) (α : HdgClass X p) : Prop :=
  ∃ z : ChowGroup X p, cycleClassMap X p z = α

-- ============================================================================
-- The Hodge Conjecture: formal statement
-- ============================================================================

/-- The Hodge Conjecture for a specific variety X and codimension p. -/
def HC_at (X : SmoothProjVar) (p : ℕ) : Prop :=
  ∀ α : HdgClass X p, isAlgebraic X p α

/-- The Hodge Conjecture for a specific variety X (all codimensions). -/
def HC_for (X : SmoothProjVar) : Prop :=
  ∀ p : ℕ, HC_at X p

/-- The full Hodge Conjecture: for all smooth projective varieties. -/
def HodgeConjecture : Prop :=
  ∀ X : SmoothProjVar, HC_for X

-- ============================================================================
-- HC restricted to abelian varieties
-- ============================================================================

/-- HC/Ab: the Hodge Conjecture for all abelian varieties. -/
def HC_Ab : Prop :=
  ∀ (A : AbelianVar) (p : ℕ), HC_at (↑A : SmoothProjVar) p

end HodgeConjecture
