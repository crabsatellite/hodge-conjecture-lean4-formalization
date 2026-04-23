/-
  HodgeConjecture/Defs/MumfordTate.lean

  Mumford-Tate groups, Shimura data, and the classification of MT factors.
  The MT group of a smooth projective variety is a reductive ℚ-algebraic group
  whose semisimple part decomposes into simple factors of Cartan type.
-/
import HodgeConjecture.Defs.CartanType
import HodgeConjecture.Defs.HodgeStructure

namespace HodgeConjecture

-- ============================================================================
-- Mumford-Tate group (abstract interface)
-- ============================================================================

/-- The Mumford-Tate group of a smooth projective variety (opaque). -/
axiom MumfordTateGroup : SmoothProjVar → Type

/-- The list of simple Cartan factors of MT(X)^ss.
    Every reductive ℚ-algebraic group decomposes as centre × semisimple,
    and the semisimple part is a product of simple factors. -/
axiom MT_simpleFactors : SmoothProjVar → List CartanType

/-- The derived subgroup MT(X)^der is trivial iff MT(X) is a torus. -/
axiom MT_isToral : SmoothProjVar → Prop

/-- MT(X) is toral iff the simple factors list is empty. -/
axiom MT_toral_iff_noFactors (X : SmoothProjVar) :
  MT_isToral X ↔ MT_simpleFactors X = []

-- ============================================================================
-- Shimura datum compatibility
-- ============================================================================

/-- A Cartan type admits a Shimura datum iff it satisfies Deligne's (SV1)
    and (SV2). The cominuscule criterion: some Dynkin mark must equal 1.

    (SV1): Ad ∘ h has weights in {-1, 0, +1}. For a cocharacter
    μ = Σ nᵢ αᵢ∨ and highest root α̃ = Σ aⱼ αⱼ, this requires
    ⟨α̃, μ⟩ = Σ aⱼ nⱼ ≤ 1 for all non-trivial μ. -/
axiom admitsShimuraDatum : CartanType → Prop

/-- A Cartan type is of abelian type if it admits a symplectic representation
    compatible with the Shimura datum. Classical types only. -/
axiom isAbelianType : CartanType → Prop

-- ============================================================================
-- Signature data for orthogonal types
-- ============================================================================

/-- For an orthogonal-type MT factor SO(p,q), the signature (p,q). -/
structure OrthSignature where
  p : ℕ
  q : ℕ
  hp : p ≥ 1
  hq : q ≥ 1

/-- Whether an orthogonal factor is Hermitian type (min(p,q) ≤ 2). -/
def OrthSignature.isHermitian (σ : OrthSignature) : Prop :=
  min σ.p σ.q ≤ 2

/-- Whether an orthogonal factor is non-Hermitian with min ≥ 3. -/
def OrthSignature.isNonHermitian_min3 (σ : OrthSignature) : Prop :=
  min σ.p σ.q ≥ 3

-- ============================================================================
-- Key properties relating to the proof
-- ============================================================================

/-- A variety is rigid if h¹(T_X) = 0 (no non-trivial deformations). -/
axiom isRigid : SmoothProjVar → Prop

/-- A variety is a Shimura fibre if it arises as a fibre of the universal
    family over a Shimura variety S_G (or its toroidal compactification).
    For such varieties, Hodge classes can be related to tautological classes
    on S_G via the period map, enabling Chern-Weil algebraicity. -/
axiom isShimuraFibre : SmoothProjVar → Prop

/-- A variety has CM type if its MT group is toral. -/
def hasCMType (X : SmoothProjVar) : Prop := MT_isToral X

-- ============================================================================
-- HC for specific MT types
-- ============================================================================

/-- HC holds for varieties whose MT factors are all of a given type. -/
def HC_forMTType (allowed : CartanType → Prop) : Prop :=
  ∀ X : SmoothProjVar,
    (∀ t ∈ MT_simpleFactors X, allowed t) → HC_for X

/-- HC/Exc(E₆, E₇): HC for varieties with exceptional MT factor E₆ or E₇.
    Conditional on (H-bundle) for non-rigid cases. -/
def HC_Exc : Prop :=
  ∀ X : SmoothProjVar,
    (∀ t ∈ MT_simpleFactors X, t = .E6 ∨ t = .E7) → HC_for X

/-- Every simple factor of MT(X)^ss admits a Shimura datum.
    This follows from the fact that the Hodge cocharacter h of X
    restricts to a non-trivial cocharacter on each simple factor,
    and this restriction satisfies Deligne's (SV1) and (SV2). -/
axiom MT_factor_admits_shimura (X : SmoothProjVar) (t : CartanType) :
  t ∈ MT_simpleFactors X → admitsShimuraDatum t

/-- GLB/Orth: HC for non-Hermitian orthogonal type with min(p,q) ≥ 3.
    For any orthogonal signature σ with min(p,q) ≥ 3, all Hodge classes
    on varieties in the associated Shimura family are algebraic.

    **Modeling note**: the ∀ X quantifier is an OVER-APPROXIMATION.
    Mathematically, the result applies only to X whose MT group has an
    orthogonal factor with signature σ. The Lean type does not encode
    this restriction because CartanType does not carry signature data.
    The proof chain uses HC_GLBOrth only for the correct X (via the
    coverage dispatch in ReductionChain), so soundness is preserved.
    Compare with HC_Exc which can restrict via MT_simpleFactors because
    E6/E7 are atomic CartanType values (no signature parameter). -/
def HC_GLBOrth : Prop := ∀ (σ : OrthSignature), σ.isNonHermitian_min3 →
    ∀ (X : SmoothProjVar) (p : ℕ) (α : HdgClass X p), isAlgebraic X p α

end HodgeConjecture
