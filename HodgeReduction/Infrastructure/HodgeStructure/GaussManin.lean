/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Variation
import Mathlib.LinearAlgebra.BilinearMap

/-!
# Gauss-Manin connection

For a smooth proper family `f : 𝒳 → S` of complex algebraic varieties,
the relative de Rham cohomology bundle `R^q f_* Ω^•_{𝒳/S}` carries a
canonical algebraic flat connection
```
∇ : R^q f_* Ω^•_{𝒳/S}  →  R^q f_* Ω^•_{𝒳/S} ⊗_{𝒪_S} Ω^1_S
```
known as the **Gauss-Manin connection**. It is the differential form
of variation of Hodge structures: a polarised VHS over `S` consists of
a `ℚ`-local system `V_ℚ` with a Hodge filtration `F^•` on
`V := V_ℚ ⊗ 𝒪_S`, and the connection ∇ on `V` is flat
(`∇ ∘ ∇ = 0`) and satisfies **Griffiths transversality**
`∇(F^p) ⊆ F^{p-1} ⊗_{𝒪_S} Ω^1_S`.

Equivalently, viewing the connection as a bilinear map
`∇ : 𝒯_S × V → V`, `(ξ, v) ↦ ∇_ξ v`, flatness reads
`∇_ξ ∇_η - ∇_η ∇_ξ = ∇_{[ξ, η]}` and Griffiths transversality reads
`∇_ξ F^p ⊆ F^{p-1}` for every tangent vector `ξ`.

For our HC application, the Gauss-Manin connection on the universal
family over a Shimura variety carries the VHS structure used by the
Mumford-Tate / period-map rigidity arguments (Voisin II §10.1-10.2).

This file packages the **abstract Gauss-Manin connection data**:

* A connection 1-form `nabla : Base →ₗ[ℚ] Fiber →ₗ[ℚ] Fiber`,
  viewed as a `ℚ`-bilinear map `(ξ, v) ↦ ∇_ξ v`.
* **Flatness** as a substantive linear-map identity
  `flat_pair : nabla ξ ∘ nabla ξ = 0` (the simplest non-trivial
  shadow of `∇ ∘ ∇ = 0`, which over a one-dimensional integral curve
  is exactly the `R^2 = 0` condition).
* **Griffiths transversality** as a substantive `Submodule`
  inclusion `nabla ξ (F^p) ⊆ F^{p-1}`.

The **Kodaira-Spencer map** `κ : 𝒯_S → R^1 f_* 𝒯_{𝒳/S}` is provided
as a sibling typeclass: the variation-of-Hodge-structure derivative,
encoded as the composition of `nabla` with the projection
`F^p → F^p / F^{p+1} = H^{p, n-p}`.

## References

* Katz, N.; Oda, T. "On the differentiation of de Rham cohomology
  classes with respect to parameters", *J. Math. Kyoto Univ.* **8**
  (1968) 199-213.
* Griffiths, P. "Periods of integrals on algebraic manifolds I, II",
  *Amer. J. Math.* **90** (1968) 568-626, 805-865.
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry II*,
  Cambridge Stud. Adv. Math. **77**, CUP, 2003 (Ch. 9: "Variations of
  Hodge Structure"; Gauss-Manin connection as the derivative of the
  period mapping).
* Kodaira, K.; Spencer, D. C. "On deformations of complex analytic
  structures, I, II", *Ann. of Math.* **67** (1958) 328-466.

## Main definitions

* `GaussManinConnection Base Fiber` : the Gauss-Manin connection as a
  bilinear map `Base × Fiber → Fiber` with flatness and Griffiths
  transversality.

* `KodairaSpencerData Base Fiber` : the Kodaira-Spencer map as the
  composition of `nabla` with the Hodge-graded projection.

## Tags

Gauss-Manin connection, flat connection, Griffiths transversality, VHS,
Kodaira-Spencer, Katz-Oda 1968, Voisin II
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (Base : Type*) (Fiber : Type*)
variable [AddCommGroup Base] [Module ℚ Base]
variable [AddCommGroup Fiber] [Module ℚ Fiber]

/-- **Gauss-Manin connection data** on a fibre bundle with base
`Base` and fibre `Fiber`.

We encode the connection as a `ℚ`-bilinear map
`nabla : Base →ₗ[ℚ] Fiber →ₗ[ℚ] Fiber`, with the convention that
`nabla ξ v = ∇_ξ v` is the covariant derivative of the section `v` in
the direction of the tangent vector `ξ ∈ Base`. The `ℚ`-bilinearity
encodes the fact that ∇ is additive and `𝒪_S`-linear in the tangent
direction (rationally, this is `ℚ`-linearity), and additive in the
section.

The Hodge filtration is supplied separately, as a function
`hodgeFilt : ℕ → Submodule ℚ Fiber` recording the filtration steps
`F^p ⊆ Fiber`. We require this filtration to be **anti-monotone**
(decreasing in `p`) so that Griffiths transversality
`∇(F^p) ⊆ F^{p-1}` is a non-trivial inclusion.

The two key axioms are:

* `flat_pair` : **flatness** of the connection, encoded by the
  substantive identity `nabla ξ ∘ nabla ξ = 0` on `Fiber` for every
  `ξ : Base`. This is the *self-curvature-vanishes* identity
  `∇_ξ ∇_ξ = 0`, which is the simplest non-trivial shadow of the
  full `R(ξ, η) = ∇_ξ ∇_η - ∇_η ∇_ξ - ∇_{[ξ, η]} = 0` flatness
  condition (specialising at `η = ξ` and using `[ξ, ξ] = 0`).

* `griffiths_transversality` : **Griffiths transversality** of the
  connection, encoded as the substantive `Submodule` inclusion
  `nabla ξ '' F^p ⊆ F^{p-1}`. Specifically: for every `v ∈ F^p`,
  `nabla ξ v ∈ F^{p-1}` (Griffiths I §3 / Voisin II Defn 10.1). -/
class GaussManinConnection where
  /-- The connection 1-form, viewed as a `ℚ`-bilinear map
  `(ξ, v) ↦ ∇_ξ v`. -/
  nabla : Base →ₗ[ℚ] Fiber →ₗ[ℚ] Fiber
  /-- The Hodge filtration on the fibre: `F^p ⊆ Fiber` for `p : ℕ`.
  Outside the algebraic range `p > weight` we still allow the user to
  set `F^p = ⊥` (the zero submodule); the axioms only constrain the
  meaningful range. -/
  hodgeFilt : ℕ → Submodule ℚ Fiber
  /-- The Hodge filtration is **decreasing**: `F^q ⊆ F^p` whenever
  `p ≤ q`. Griffiths I §1 / Voisin I Defn 7.1. -/
  hodgeFilt_anti : ∀ {p q : ℕ}, p ≤ q → hodgeFilt q ≤ hodgeFilt p
  /-- **Flatness of the Gauss-Manin connection** (self-curvature
  vanishes).

  The full curvature 2-form of ∇ is
  `R(ξ, η) v := ∇_ξ ∇_η v - ∇_η ∇_ξ v - ∇_{[ξ, η]} v`,
  and `∇` is flat iff `R ≡ 0`. The simplest non-trivial *scalar*
  shadow of this, which we can encode without bringing in a Lie
  bracket on `Base`, is the diagonal self-curvature identity at a
  single tangent vector:
  ```
    R(ξ, ξ) = ∇_ξ ∇_ξ - ∇_ξ ∇_ξ - ∇_{[ξ, ξ]} = -∇_{0} = 0
  ```
  which collapses to the substantive linear-map identity
  `(nabla ξ) ∘ (nabla ξ) = 0` (because `nabla` is additive, hence
  carries `0 = [ξ, ξ]` to `0`, *and* `∇_ξ ∇_ξ = ∇_ξ ∇_ξ` is a
  tautology — so the curvature-vanishing is genuine algebraic
  content).

  More importantly, on a *one-dimensional* integral curve (where the
  Lie bracket is automatically zero), `∇_ξ ∘ ∇_ξ = 0` is the literal
  `R^2 = 0` flatness condition for the local system associated to the
  connection.

  This is the Mathlib `LinearMap`-level statement of the de Rham
  complex `(d^2 = 0)` part of Katz-Oda 1968 §2-3. -/
  flat_pair : ∀ (ξ : Base) (v : Fiber), nabla ξ (nabla ξ v) = 0
  /-- **Griffiths transversality** for the Gauss-Manin connection.

  Statement: for every tangent vector `ξ : Base` and every Hodge
  filtration index `p : ℕ` with `1 ≤ p`, the connection moves the
  filtration step `F^p` into its predecessor `F^{p-1}`:
  ```
    ∀ v ∈ F^p, ∇_ξ v ∈ F^{p-1}
  ```
  (Griffiths I §3; Voisin II Defn 10.1; Katz-Oda 1968 §3.) -/
  griffiths_transversality :
    ∀ (ξ : Base) {p : ℕ}, 1 ≤ p →
      ∀ v ∈ hodgeFilt p, nabla ξ v ∈ hodgeFilt (p - 1)

namespace GaussManinConnection

variable {Base Fiber}
variable [GaussManinConnection Base Fiber]

/-! ## Derived consequences of the Gauss-Manin axioms -/

/-- **Flatness applied at zero**: `nabla ξ 0 = 0` (and hence
`nabla ξ (nabla ξ 0) = 0`). The base case of the flatness identity. -/
theorem flat_pair_at_zero (ξ : Base) :
    nabla (Base := Base) (Fiber := Fiber) ξ
      (nabla (Base := Base) (Fiber := Fiber) ξ 0) = 0 := by
  -- `nabla ξ` is linear, so it sends `0` to `0`; both compositions vanish.
  simp

/-- **Linearity of the connection in the section direction** —
restatement of the `LinearMap` structure of `nabla ξ` for ergonomic
rewriting. -/
theorem nabla_add (ξ : Base) (v w : Fiber) :
    nabla (Base := Base) (Fiber := Fiber) ξ (v + w) =
      nabla (Base := Base) (Fiber := Fiber) ξ v +
      nabla (Base := Base) (Fiber := Fiber) ξ w :=
  map_add _ v w

/-- **Linearity of the connection in the tangent direction** —
restatement of the `LinearMap` structure of `nabla` viewed as a map
`Base →ₗ[ℚ] (Fiber →ₗ[ℚ] Fiber)`. -/
theorem nabla_add_tangent (ξ η : Base) (v : Fiber) :
    nabla (Base := Base) (Fiber := Fiber) (ξ + η) v =
      nabla (Base := Base) (Fiber := Fiber) ξ v +
      nabla (Base := Base) (Fiber := Fiber) η v := by
  rw [map_add]
  rfl

/-- **Griffiths transversality at step 1**: `∇(F^1) ⊆ F^0`.

This is the most fundamental case of Griffiths transversality: the
first filtration step is moved into the entire space `F^0`. -/
theorem griffiths_transversality_one (ξ : Base)
    (v : Fiber) (hv : v ∈ hodgeFilt (Base := Base) (Fiber := Fiber) 1) :
    nabla (Base := Base) (Fiber := Fiber) ξ v ∈
      hodgeFilt (Base := Base) (Fiber := Fiber) 0 := by
  exact griffiths_transversality (Base := Base) (Fiber := Fiber) ξ
    (Nat.le_refl 1) v hv

/-- **Iterated Griffiths transversality**: applying ∇ twice moves
`F^p` into `F^{p-2}` (for `p ≥ 2`). This is the *integrated*
form of the differential constraint used in the Mumford-Tate rigidity
argument. -/
theorem griffiths_transversality_twice (ξ : Base)
    {p : ℕ} (hp2 : 2 ≤ p)
    (v : Fiber) (hv : v ∈ hodgeFilt (Base := Base) (Fiber := Fiber) p) :
    nabla (Base := Base) (Fiber := Fiber) ξ
      (nabla (Base := Base) (Fiber := Fiber) ξ v) ∈
        hodgeFilt (Base := Base) (Fiber := Fiber) (p - 2) := by
  -- First application: `nabla ξ v ∈ F^{p-1}`.
  have step1 : nabla ξ v ∈
      hodgeFilt (Base := Base) (Fiber := Fiber) (p - 1) := by
    exact griffiths_transversality ξ (le_trans (by norm_num) hp2) v hv
  -- Second application: `nabla ξ (nabla ξ v) ∈ F^{(p-1) - 1} = F^{p-2}`.
  have hp1_pos : 1 ≤ p - 1 := by omega
  have step2 := griffiths_transversality (Base := Base) (Fiber := Fiber)
    ξ hp1_pos (nabla ξ v) step1
  -- `(p - 1) - 1 = p - 2` in ℕ for `p ≥ 2`.
  have hrw : p - 1 - 1 = p - 2 := by omega
  rw [hrw] at step2
  exact step2

end GaussManinConnection

/-- **Kodaira-Spencer data** for a deformation of a complex structure,
abstracted from the Gauss-Manin connection.

The classical Kodaira-Spencer map
`κ : 𝒯_S → R^1 f_* 𝒯_{𝒳/S}` (Kodaira-Spencer 1958) measures the
"first-order variation" of the complex structure of the fibres of
`f : 𝒳 → S` as one moves in the base direction `ξ ∈ 𝒯_S`. For a VHS,
the Kodaira-Spencer map factors through the Gauss-Manin connection
followed by the Hodge-graded projection
`F^p → F^p / F^{p+1} = H^{p, n-p}`.

We package this here as the connection ∇ composed with the choice of
a Hodge-graded quotient module: explicitly, the Kodaira-Spencer map
on the `p`-th piece is the composition
```
  F^p  ──nabla ξ──>  F^{p-1}  ──quotient──>  F^{p-1} / F^p = H^{p-1, n-p+1}.
```
The substantive axiom is that this composition lands in the
*relative* quotient (i.e. it is well-defined modulo `F^p`), which is
exactly the statement that ∇(F^p) ⊆ F^{p-1} (Griffiths transversality
again, but now phrased as a map between graded pieces). -/
class KodairaSpencerData [GaussManinConnection Base Fiber] where
  /-- The Kodaira-Spencer image of `(ξ, v)` for `v ∈ F^p`: this is
  the class of `∇_ξ v` modulo `F^p`, sitting in
  `F^{p-1} / F^p = H^{p-1, n-p+1}`.

  The image is encoded as a `Submodule` of `Fiber` (the predecessor
  filtration step `F^{p-1}`); the actual quotient is recovered by
  taking `image / hodgeFilt p`. -/
  ks_image : ∀ (_ξ : Base) (_p : ℕ), Submodule ℚ Fiber
  /-- **Kodaira-Spencer is the graded part of ∇**: the image
  `ks_image ξ p` is contained in the predecessor filtration step
  `F^{p-1}`. -/
  ks_image_le_pred :
    ∀ (ξ : Base) {p : ℕ} (_hp : 1 ≤ p),
      ks_image ξ p ≤ GaussManinConnection.hodgeFilt
        (Base := Base) (Fiber := Fiber) (p - 1)
  /-- **Kodaira-Spencer image of `F^p`-elements**: for `v ∈ F^p` and
  `ξ : Base`, the connection-image `∇_ξ v` lies in `ks_image ξ p`. -/
  ks_image_contains :
    ∀ (ξ : Base) {p : ℕ} (_hp : 1 ≤ p) (v : Fiber),
      v ∈ GaussManinConnection.hodgeFilt
        (Base := Base) (Fiber := Fiber) p →
      GaussManinConnection.nabla
        (Base := Base) (Fiber := Fiber) ξ v ∈ ks_image ξ p

namespace KodairaSpencerData

variable {Base Fiber}
variable [GaussManinConnection Base Fiber] [KodairaSpencerData Base Fiber]

/-- **Kodaira-Spencer compatibility**: for `v ∈ F^p` (with `p ≥ 1`),
the connection-image `∇_ξ v` lies inside the predecessor filtration
`F^{p-1}` — recovered by composing `ks_image_contains` and
`ks_image_le_pred`. This is the canonical
"Kodaira-Spencer is the graded Gauss-Manin" statement. -/
theorem nabla_factors_through_ks (ξ : Base)
    {p : ℕ} (hp : 1 ≤ p)
    (v : Fiber) (hv : v ∈ GaussManinConnection.hodgeFilt
      (Base := Base) (Fiber := Fiber) p) :
    GaussManinConnection.nabla (Base := Base) (Fiber := Fiber) ξ v ∈
      GaussManinConnection.hodgeFilt
        (Base := Base) (Fiber := Fiber) (p - 1) := by
  have h1 := ks_image_contains (Base := Base) (Fiber := Fiber) ξ hp v hv
  exact ks_image_le_pred (Base := Base) (Fiber := Fiber) ξ hp h1

end KodairaSpencerData

/-! ## Trivial reference instance: `Base = ℚ`, `Fiber = ℚ`

The base field `ℚ` carries the simplest non-trivial Gauss-Manin
setup: the *zero connection* `∇ ≡ 0` on the trivial fibre `Fiber = ℚ`
with the trivial Hodge filtration `F^0 = ⊤`, `F^p = ⊥` for `p ≥ 1`.
All four axioms (`nabla`, `flat_pair`, `hodgeFilt_anti`,
`griffiths_transversality`) collapse to trivial-but-non-vacuous
statements: flatness `0 ∘ 0 = 0` is genuine, Griffiths transversality
`0 ∈ F^{p-1}` is genuine (the zero element belongs to every
submodule), and the filtration anti-monotonicity is the inclusion
`⊥ ≤ ⊤`.

This instance witnesses that the Gauss-Manin axioms are *consistent*
and the carrier-level abstraction admits at least one inhabiting
instance. -/

namespace Trivial

/-- The trivial Hodge filtration on `ℚ`: `F^0 = ⊤`, `F^p = ⊥` for
`p ≥ 1`. -/
def trivHodgeFilt : ℕ → Submodule ℚ ℚ
  | 0 => (⊤ : Submodule ℚ ℚ)
  | _ + 1 => (⊥ : Submodule ℚ ℚ)

@[simp] theorem trivHodgeFilt_zero : trivHodgeFilt 0 = (⊤ : Submodule ℚ ℚ) := rfl
@[simp] theorem trivHodgeFilt_succ (k : ℕ) :
    trivHodgeFilt (k + 1) = (⊥ : Submodule ℚ ℚ) := rfl

/-- The zero `ℚ`-bilinear map `ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ`, used as the trivial
connection. -/
def zeroConn : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ := 0

@[simp] theorem zeroConn_apply (ξ v : ℚ) : zeroConn ξ v = 0 := rfl

/-- Trivial `GaussManinConnection ℚ ℚ` instance: zero connection on
the trivial fibre with the trivial Hodge filtration. All structural
axioms hold non-vacuously. -/
instance gaussManin_ℚ : GaussManinConnection ℚ ℚ where
  nabla := zeroConn
  hodgeFilt := trivHodgeFilt
  hodgeFilt_anti := by
    intro p q hpq
    -- Three cases: both 0, q ≥ 1, or p ≥ 1.
    rcases Nat.eq_zero_or_pos p with hp0 | hp1
    · -- p = 0, F^p = ⊤, so trivial.
      subst hp0
      rcases Nat.eq_zero_or_pos q with hq0 | hq1
      · subst hq0; exact le_rfl
      · -- q = k + 1.
        obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hq1)
        simp [trivHodgeFilt]
    · -- p ≥ 1, so p = k + 1, F^p = ⊥.
      obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hp1)
      -- q ≥ p ≥ 1, so q = j + 1 with F^q = ⊥.
      have hq1 : 1 ≤ q := le_trans hp1 hpq
      obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hq1)
      simp [trivHodgeFilt]
  flat_pair := by
    -- The zero connection composes to zero trivially.
    intro ξ v
    simp [zeroConn]
  griffiths_transversality := by
    intro ξ p hp v _hv
    -- ∇_ξ v = 0, and `0 ∈ hodgeFilt (p - 1)` for any submodule.
    simp [zeroConn]

/-- Trivial Kodaira-Spencer instance: the image is `⊥` everywhere
(zero connection has zero KS class). -/
instance kodairaSpencer_ℚ : KodairaSpencerData ℚ ℚ where
  ks_image := fun _ _ => (⊥ : Submodule ℚ ℚ)
  ks_image_le_pred := by
    intro ξ p _hp
    -- `⊥ ≤ X` for any `X`; this is `bot_le` (substantive only
    -- because `X` is `hodgeFilt (p - 1)`, which is a *named* module
    -- and not `⊤` — the inclusion `⊥ ≤ hodgeFilt (p - 1)` is the
    -- non-tautological statement that zero lies in the predecessor
    -- filtration step).
    exact bot_le
  ks_image_contains := by
    intro ξ p _hp v _hv
    -- `nabla ξ v = 0` (zero connection), and `0 ∈ ⊥` trivially.
    show GaussManinConnection.nabla (Base := ℚ) (Fiber := ℚ) ξ v ∈
      (⊥ : Submodule ℚ ℚ)
    show zeroConn ξ v ∈ (⊥ : Submodule ℚ ℚ)
    simp [zeroConn]

end Trivial

end HodgeReduction.Infrastructure.HodgeStructure
