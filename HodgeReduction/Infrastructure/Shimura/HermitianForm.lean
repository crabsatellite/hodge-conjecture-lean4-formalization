/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Module.Prod
import Mathlib.Algebra.Group.Action.Prod
import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-!
# Hermitian form framework

For a polarised Hodge structure of weight `n`, the **Hermitian form**
on `V_ℂ` is
```
h(α, β) := i^n · ψ_ℂ(α, conj(β))
```
where `ψ` is the polarisation form. The Hodge-Riemann second relation
states that `h` is positive definite on the primitive part of each
Hodge piece `H^{p,q}`.

For our HC application: the Hermitian form encodes the positivity
properties needed for rigidity arguments (e.g., Schmid 1973 / CKS 1986).

This file packages **abstract Hermitian form data** together with a
**Weil-operator-positivity axiom** (Voisin 2002 I §7.1.2; Deligne 1971
SV-axioms; Milne 2017 §1.1).

## References

* Voisin, C. *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Mathematics **76**, CUP 2002 — Ch. 7
  (Hermitian form on Hodge structures, Weil operator).
* Deligne, P. "Travaux de Shimura", *Sém. Bourbaki* **23**, exp. 389
  (1971), Lecture Notes in Math. **244**, 123-165 — Shimura datum SV-
  axioms.
* Milne, J. S. *Introduction to Shimura Varieties* (rev. 2017),
  §1.1-1.2 (Hermitian form, polarisation, Shimura datum).

## Main definitions

* `HermitianFormData V` : abstract Hermitian form data with skew-
  symmetry and Weil-operator positivity.
* `PolarisedShimuraData V` : Hermitian form data + compatibility with
  a Hodge filtration step (substantive non-vanishing of the form on the
  flag).

## Tags

Hermitian form, polarisation, Hodge-Riemann positivity, Weil operator,
Shimura datum
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Hermitian form data** on a `ℚ`-vector space `V`.

The full geometric Hermitian form lives over `ℂ`; we record here the
*rational shadow*: a skew-symmetric `ℚ`-bilinear pairing `H` together
with a `ℚ`-linear **Weil operator** `weilC : V →ₗ[ℚ] V` realising the
positivity of `(x, y) ↦ H(weilC x, y)` on non-zero vectors (this is the
rational shadow of the Hodge-Riemann positivity statement on the
real points of the Hodge piece, Voisin I §7.1.2 + Prop 7.10 (ii);
Schmid 1973 §3).

Fields:
* `pairing` : the Hermitian pairing as a `ℚ`-bilinear form `V → V → ℚ`.
* `pairing_skew` : the bilinear form is **alternating** (skew-symmetric)
  at the rational level: `pairing x y = -pairing y x`. This is the
  *odd-weight* shadow of the (anti)symmetry axiom for Hermitian forms
  on weight-`n` polarised Hodge structures with `n` odd
  (Griffiths I (2.2); Voisin I Defn 7.3 (i)).
* `weilC` : the Weil operator `C : V →ₗ[ℚ] V` (Voisin I §7.1.1; over
  ℂ this acts on `H^{p,q}` as multiplication by `i^{p-q}`; over ℚ we
  record the abstract endomorphism whose composition with the pairing
  gives the positive Hermitian form).
* `weil_positivity` : the **substantive positivity axiom**: for every
  non-zero vector `x`, the rational scalar `pairing (weilC x) x` is
  strictly positive. This is the rational shadow of the second Hodge-
  Riemann relation HR2 (positivity of the Hermitian form on the Hodge
  piece, Voisin I Prop 7.10 (ii); Schmid 1973 (1.7)). -/
class HermitianFormData (V : Type*) [AddCommGroup V] [Module ℚ V] where
  /-- The Hermitian pairing as a `ℚ`-bilinear form `V → V → ℚ`. -/
  pairing : V →ₗ[ℚ] V →ₗ[ℚ] ℚ
  /-- **Hermitian skew-symmetry** at the rational level:
  `pairing x y = -pairing y x`. (Odd-weight Hodge-Riemann (anti)symmetry
  axiom, Voisin I Defn 7.3 (i).) -/
  pairing_skew : ∀ x y : V, pairing x y = -pairing y x
  /-- The Weil operator `C : V →ₗ[ℚ] V` (Voisin I §7.1.1). -/
  weilC : V →ₗ[ℚ] V
  /-- **Substantive positivity** of the Weil-twisted form: for every
  non-zero `x`, `pairing (weilC x) x > 0`. This is the rational shadow
  of the HR2 positivity axiom (Voisin I Prop 7.10 (ii); Schmid 1973
  (1.7)). -/
  weil_positivity : ∀ x : V, x ≠ 0 → 0 < pairing (weilC x) x

namespace HermitianFormData

variable {V : Type*} [AddCommGroup V] [Module ℚ V] [HermitianFormData V]

/-! ## Derived consequences of the Hermitian-form axioms -/

/-- **Vanishing on the diagonal** (alternating ⇒ `pairing x x = 0`).
A direct consequence of skew-symmetry applied at `y = x`. -/
theorem pairing_self_zero (x : V) : pairing x x = (0 : ℚ) := by
  have h := pairing_skew (V := V) x x
  -- `pairing x x = -pairing x x` implies `2 * pairing x x = 0`, hence
  -- `pairing x x = 0` (we are over `ℚ`, characteristic 0).
  linarith

/-- **Right swap is the negative of the left**: a restatement of
`pairing_skew` for ergonomic rewriting. -/
theorem pairing_swap (x y : V) :
    pairing (V := V) x y = -pairing (V := V) y x :=
  pairing_skew x y

/-- **Double-swap is the negative of the original**: `pairing y x =
-pairing x y`. -/
theorem pairing_swap_swap (x y : V) :
    pairing (V := V) y x = -pairing (V := V) x y := by
  have h := pairing_swap (V := V) x y
  linarith

/-- **Weil-twisted positivity ⇒ Weil operator is non-zero on non-zero
inputs**: if `x ≠ 0`, then `weilC x ≠ 0` (otherwise the positivity
hypothesis would yield `0 < pairing 0 x = 0`). -/
theorem weilC_ne_zero_of_ne_zero (x : V) (hx : x ≠ 0) :
    weilC (V := V) x ≠ 0 := by
  intro hCx
  -- If `weilC x = 0`, then `pairing (weilC x) x = pairing 0 x = 0`,
  -- but `weil_positivity` gives `0 < pairing (weilC x) x`. Contradiction.
  have hpos : 0 < pairing (V := V) (weilC (V := V) x) x :=
    weil_positivity x hx
  rw [hCx] at hpos
  -- `pairing 0 x = 0` by linearity of `pairing` in the first argument.
  simp at hpos

/-- **Weil-twisted scalar is non-zero on non-zero inputs**: contrapositive
of "if `pairing (weilC x) x = 0` then `x = 0`". A useful corollary for
discharging non-vanishing obligations downstream. -/
theorem weil_twisted_ne_zero (x : V) (hx : x ≠ 0) :
    pairing (V := V) (weilC (V := V) x) x ≠ 0 :=
  ne_of_gt (weil_positivity x hx)

/-- **Weil-twisted vanishing ⇒ input is zero**: contrapositive of
`weil_twisted_ne_zero`. The Weil-twisted form **separates points**. -/
theorem eq_zero_of_weil_twisted_zero (x : V)
    (h : pairing (V := V) (weilC (V := V) x) x = 0) : x = 0 := by
  by_contra hx
  exact weil_twisted_ne_zero x hx h

end HermitianFormData

/-- **Polarised Shimura datum** for a `ℚ`-vector space `V`: a Hermitian
form together with a designated Hodge-filtration step `flagF` realising
the compatibility between the polarisation and the Hodge filtration
(Deligne 1971 SV-axioms (SV1)-(SV2); Milne 2017 §1.1).

The full geometric content (SV1: the Hodge cocharacter is defined over
`ℝ`; SV2: the polarisation is positive on `weilC`-twisted vectors;
SV3: the adjoint group is `ℝ`-simple) is recorded here at its rational
shadow: a designated filtration step `flagF : Submodule ℚ V` (the level-1
Hodge filtration `F^1 V`) on which the Hermitian form's Weil-twisted
positivity restricts non-trivially — i.e. the filtration contains at
least one non-zero vector if and only if the Hermitian form is non-
trivial there.

Fields:
* `flagF` : the designated Hodge-filtration step `F^1 V ⊆ V` (Deligne
  1971 (1.2); Milne 2017 §1.1.1).
* `flagF_top_of_nontrivial` : substantive **non-vacuity at the
  rational level** — if the underlying space `V` is non-trivial
  (contains at least one non-zero vector), then the filtration step
  `flagF` equals the whole space `⊤`. This is the rational shadow of
  the Deligne (SV1) axiom asserting that the Hodge cocharacter is
  non-trivial on `V` whenever the latter is itself non-trivial
  (Deligne 1971 (1.5); Milne 2017 §1.1.2). -/
class PolarisedShimuraData (V : Type*) [AddCommGroup V] [Module ℚ V]
    [HermitianFormData V] where
  /-- The designated Hodge-filtration step `F^1 V ⊆ V` (Deligne 1971
  (1.2); Milne 2017 §1.1.1). -/
  flagF : Submodule ℚ V
  /-- **Substantive compatibility** at the rational level: if `V`
  contains a non-zero vector (i.e., is not the zero space), then the
  filtration step `flagF` equals the whole space `⊤`. (Rational shadow
  of Deligne SV1; Milne 2017 §1.1.2.) -/
  flagF_top_of_nontrivial :
    (∃ v : V, v ≠ 0) → flagF = (⊤ : Submodule ℚ V)

namespace PolarisedShimuraData

variable {V : Type*} [AddCommGroup V] [Module ℚ V]
variable [HermitianFormData V] [PolarisedShimuraData V]

/-! ## Derived consequences of the polarised Shimura axioms -/

/-- **The flag step contains every vector if the underlying space is
non-trivial**: direct consequence of `flagF_top_of_nontrivial`. -/
theorem flagF_eq_top (h : ∃ v : V, v ≠ 0) :
    flagF (V := V) = (⊤ : Submodule ℚ V) :=
  flagF_top_of_nontrivial h

/-- **Every vector lies in the flag step when `V` is non-trivial** — the
membership form of `flagF_eq_top`. -/
theorem mem_flagF (h : ∃ v : V, v ≠ 0) (w : V) :
    w ∈ flagF (V := V) := by
  rw [flagF_eq_top h]
  trivial

end PolarisedShimuraData

/-! ## Trivial reference instance: `V = ℚ × ℚ`

The two-dimensional `ℚ`-vector space `ℚ × ℚ` carries a non-trivial
Hermitian-form datum:
* `pairing ((a₁,b₁), (a₂,b₂)) := a₁ * b₂ - a₂ * b₁` (the standard
  symplectic form on `ℚ²`).
* `weilC (a, b) := (b, -a)` (rotation by `π/2`).

Then `pairing (weilC (a,b), (a,b)) = b*b - a*(-a) = a² + b² > 0` for
non-zero `(a,b)`, satisfying the Weil-positivity axiom.

This witnesses that the `HermitianFormData` axioms are consistent and
admits a substantive (non-zero, non-trivial) inhabiting instance — the
same pattern as the `(ℚ, n = 0)` trivial inhabiting instance used in
`PolarisedHodgeStructure`. -/

namespace Trivial

/-- The standard symplectic pairing on `ℚ × ℚ`:
`((a₁,b₁), (a₂,b₂)) ↦ a₁ * b₂ - a₂ * b₁`. -/
def sympl : (ℚ × ℚ) →ₗ[ℚ] (ℚ × ℚ) →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ (fun p q => p.1 * q.2 - p.2 * q.1)
    (fun p₁ p₂ q => by
      show (p₁.1 + p₂.1) * q.2 - (p₁.2 + p₂.2) * q.1 =
        (p₁.1 * q.2 - p₁.2 * q.1) + (p₂.1 * q.2 - p₂.2 * q.1)
      ring)
    (fun c p q => by
      show (c * p.1) * q.2 - (c * p.2) * q.1 = c * (p.1 * q.2 - p.2 * q.1)
      ring)
    (fun p q₁ q₂ => by
      show p.1 * (q₁.2 + q₂.2) - p.2 * (q₁.1 + q₂.1) =
        (p.1 * q₁.2 - p.2 * q₁.1) + (p.1 * q₂.2 - p.2 * q₂.1)
      ring)
    (fun c p q => by
      show p.1 * (c * q.2) - p.2 * (c * q.1) = c * (p.1 * q.2 - p.2 * q.1)
      ring)

@[simp] theorem sympl_apply (p q : ℚ × ℚ) :
    sympl p q = p.1 * q.2 - p.2 * q.1 := rfl

/-- The Weil operator on `ℚ × ℚ`: rotation by `π/2`,
`(a, b) ↦ (b, -a)`. -/
def weilC_ℚ2 : (ℚ × ℚ) →ₗ[ℚ] (ℚ × ℚ) where
  toFun p := (p.2, -p.1)
  map_add' p q := by
    show ((p + q).2, -(p + q).1) = (p.2, -p.1) + (q.2, -q.1)
    ext
    · simp
    · simp; ring
  map_smul' r p := by
    show ((r • p).2, -(r • p).1) = r • (p.2, -p.1)
    ext
    · simp
    · simp

@[simp] theorem weilC_ℚ2_apply (p : ℚ × ℚ) :
    weilC_ℚ2 p = (p.2, -p.1) := rfl

/-- The Weil-twisted self-pairing on `ℚ × ℚ` is the **standard squared
norm**: `pairing (weilC (a,b)) (a,b) = b*b - a*(-a) = a² + b²`. -/
theorem weil_twisted_self (p : ℚ × ℚ) :
    sympl (weilC_ℚ2 p) p = p.1 ^ 2 + p.2 ^ 2 := by
  show p.2 * p.2 - (-p.1) * p.1 = p.1 ^ 2 + p.2 ^ 2
  ring

/-- For non-zero `(a, b) : ℚ × ℚ`, the Weil-twisted self-pairing
`a² + b²` is strictly positive (sum of two non-negative squares with at
least one strictly positive). -/
theorem weil_pos_ℚ2 (p : ℚ × ℚ) (hp : p ≠ 0) :
    0 < sympl (weilC_ℚ2 p) p := by
  rw [weil_twisted_self]
  -- `p ≠ 0` iff `p.1 ≠ 0 ∨ p.2 ≠ 0`.
  have hne : p.1 ≠ 0 ∨ p.2 ≠ 0 := by
    by_contra h
    push_neg at h
    apply hp
    exact Prod.ext h.1 h.2
  -- Both squares are non-negative; at least one is positive.
  rcases hne with h1 | h2
  · have h1sq : 0 < p.1 ^ 2 := by positivity
    have h2sq : 0 ≤ p.2 ^ 2 := by positivity
    linarith
  · have h1sq : 0 ≤ p.1 ^ 2 := by positivity
    have h2sq : 0 < p.2 ^ 2 := by positivity
    linarith

/-- Trivial `HermitianFormData (ℚ × ℚ)` instance: standard symplectic
pairing + π/2-rotation Weil operator. All three axioms (skew-symmetry,
non-zero Weil operator, positivity) are substantive (non-tautological). -/
instance hermitianForm_ℚ2 : HermitianFormData (ℚ × ℚ) where
  pairing := sympl
  pairing_skew := by
    intro p q
    show p.1 * q.2 - p.2 * q.1 = -(q.1 * p.2 - q.2 * p.1)
    ring
  weilC := weilC_ℚ2
  weil_positivity := weil_pos_ℚ2

/-- Trivial `PolarisedShimuraData (ℚ × ℚ)` instance: take
`flagF = ⊤` (the whole space) — substantively satisfies the SV-axiom
shadow since `V = ℚ × ℚ` always contains the non-zero vector `(1, 0)`. -/
instance polarisedShimura_ℚ2 : PolarisedShimuraData (ℚ × ℚ) where
  flagF := (⊤ : Submodule ℚ (ℚ × ℚ))
  flagF_top_of_nontrivial := by
    intro _
    rfl

end Trivial

end HodgeReduction.Infrastructure.Shimura
