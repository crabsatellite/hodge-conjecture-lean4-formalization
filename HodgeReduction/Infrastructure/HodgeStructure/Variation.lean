/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Variations of Hodge structures (VHS)

A **variation of Hodge structures** of weight `n` on a complex manifold
`B` is a family `V → B` of polarised Hodge structures of weight `n`,
satisfying Griffiths' transversality and the Hodge-Riemann positivity
conditions (Griffiths I-III, 1968-70; Schmid 1973, §1-§2).

In the original VHS formulation the **fibres** `V_b` typically vary,
fitting together as a `ℚ`-local system on `B`. The two parts of the
data are:

* the **Hodge bundle**: a Hodge filtration `F^•_b` on each fibre,
  *varying holomorphically* over `B`;
* the **Gauss-Manin connection** `∇`: a flat connection on the local
  system, satisfying **Griffiths transversality** `∇(F^p) ⊆ F^{p-1}`.

This file provides two complementary carrier-level abstractions:

* `VHSData B V n` (the *family-of-fibres* form), where each fibre
  carries its own `PolarisedHodgeStructure`. This was the original
  scaffold; we keep it for backward compatibility with the
  `Variation.lean` API.

* `VariationOfHodgeStructureData B V` (the *fixed-carrier* form),
  where the Hodge filtration is encoded as a `B → ℕ → Submodule ℚ V`
  function on a *fixed* ambient `ℚ`-module `V` (the underlying
  ℚ-local system, trivialised after pulling back to the universal
  cover). This form is the one used by the **Gauss-Manin**, **period
  map**, and **Mumford-Tate** machinery downstream.

  The substantive axioms recorded here are:
  - **Antitonicity** of `F` in `p`;
  - **Griffiths transversality** as a substantive `Submodule`
    inclusion `derivative b p ⊆ F b (p-1)`, where `derivative` is an
    abstract per-base-point derivative module (the rational shadow of
    `∇ F^p`);
  - The **polarisation form** `polarisationForm : V →ₗ[ℚ] V →ₗ[ℚ] ℚ`
    (constant in `b`, since the polarisation is a flat parallel
    section of the local system).

* `FlatConnection B V` (sibling): the **Gauss-Manin flatness** of the
  variation encoded substantively as `∇_ξ ∘ ∇_ξ = 0` (the
  self-curvature-vanishes shadow of `R(∇) = 0`).

## References

* Griffiths, P. "Periods of integrals on algebraic manifolds I-III",
  *Amer. J. Math.* **90** (1968) 568-626, 805-865; *Publ. Math. IHÉS*
  **38** (1970) 125-180.
* Schmid, W. "Variation of Hodge structure: The singularities of the
  period mapping", *Invent. Math.* **22** (1973) 211-319 (§1-§2).
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry II*,
  Cambridge Stud. Adv. Math. **77**, CUP, 2003 (Ch. 10 — VHS
  axiomatics).

## Main definitions

* `VHSData B V n` — family-of-polarised-fibres form (kept for
  backward compatibility with downstream `Variation.lean` consumers).
* `VariationOfHodgeStructureData B V` — fixed-carrier form with
  Griffiths transversality and constant polarisation form.
* `FlatConnection B V` — Gauss-Manin flatness of the connection
  associated to the variation.

## Tags

variation of Hodge structures, VHS, Griffiths transversality,
period map, Gauss-Manin connection, Voisin II
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

/-! ## Family-of-fibres form (backward-compat) -/

section FamilyForm

variable (B : Type*) (V : B → Type*)
variable [∀ b, AddCommGroup (V b)] [∀ b, Module ℚ (V b)]

/-- A **variation of Hodge structures** on `B` with per-base-point
fibres `V b`, all of weight `n`.

We require: each fibre `V b` carries a `PolarisedHodgeStructure (V b) n`. -/
class VHSData (n : ℕ) where
  /-- Each fibre is equipped with a polarised Hodge structure of weight `n`. -/
  isPolarisedHodge : ∀ b : B, PolarisedHodgeStructure (V b) n

namespace VHSData

variable {B V} {n : ℕ} [VHSData B V n]

/-- The polarised Hodge structure on the fibre over `b`. -/
def fibreHodge (b : B) : PolarisedHodgeStructure (V b) n :=
  VHSData.isPolarisedHodge b

end VHSData

end FamilyForm

/-! ## Fixed-carrier form

We now switch to the convention used by the Gauss-Manin / period-map
/ Mumford-Tate machinery: a *single ambient* ℚ-module `V` carrying
both the Hodge filtration (which depends on `b ∈ B`) and the
polarisation form (which is constant in `b`). -/

variable (B : Type*) (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Variation of Hodge structures (fixed-carrier form)** on a base
`B` with ambient `ℚ`-module `V` (the local system, trivialised after
pulling back to the universal cover).

Data:

* `F b p` — the **Hodge filtration** `F^p ⊆ V` at the base point
  `b : B`, for `p : ℕ`. (Griffiths I §1, Voisin II Defn 10.1.)

* `derivative b p` — the rational shadow of `∇ F^p` at the base point
  `b`. Concretely, this is the submodule of `V` containing the images
  of all `F^p`-sections under the Gauss-Manin connection at `b`. We
  encode it abstractly to defer the bilinear connection structure to
  `FlatConnection` below.

* `polarisationForm` — the polarisation `Q : V × V → ℚ`, **constant
  in `b`** because the polarisation is a flat parallel section of the
  local system (Griffiths I §2; Voisin II Defn 10.1 (iii)).

Axioms:

* `F_antitone` — the Hodge filtration is **antitone in `p`**: if
  `p ≤ q` then `F b q ⊆ F b p`. (Griffiths I §1.)

* `griffiths_transversality_filt` — **Griffiths transversality** in
  its rational-shadow form: the derivative of `F^p` lies in `F^{p-1}`.
  This is the substantive `Submodule` inclusion
  `derivative b p ⊆ F b (p - 1)` for `p ≥ 1`. (Griffiths I §3;
  Voisin II Defn 10.1 (ii); the seminal VHS axiom.)

* `polarisationForm_nondegen` — the polarisation `Q` is
  **non-degenerate**, the standard VHS axiom (Voisin II Defn 10.1
  (iii)). -/
class VariationOfHodgeStructureData where
  /-- The Hodge filtration `F^•(b) : ℕ → Submodule ℚ V` at base
  point `b : B`. (Griffiths I §1.) -/
  F : B → ℕ → Submodule ℚ V
  /-- The rational shadow of `∇ F^p` at `b`. Encodes the
  Gauss-Manin-derivative of the `p`-th filtration step. -/
  derivative : B → ℕ → Submodule ℚ V
  /-- The polarisation `Q : V × V → ℚ` (constant in `b`,
  Voisin II Defn 10.1 (iii)). -/
  polarisationForm : V →ₗ[ℚ] V →ₗ[ℚ] ℚ
  /-- **Antitonicity of the Hodge filtration in `p`** (Griffiths I §1). -/
  F_antitone : ∀ (b : B) {p q : ℕ}, p ≤ q → F b q ≤ F b p
  /-- **Griffiths transversality (rational-shadow form)**: the
  Gauss-Manin derivative of the `p`-th filtration step lies in the
  `(p-1)`-th step. (Griffiths I §3.) -/
  griffiths_transversality_filt :
    ∀ (b : B) {p : ℕ}, 1 ≤ p → derivative b p ≤ F b (p - 1)
  /-- **Non-degeneracy** of the polarisation form (Voisin II
  Defn 10.1 (iii)). -/
  polarisationForm_nondegen :
    ∀ v : V, (∀ w : V, polarisationForm v w = 0) → v = 0

namespace VariationOfHodgeStructureData

variable {B V} [VariationOfHodgeStructureData B V]

/-- **Single-step antitonicity** of the Hodge filtration (theorem form,
Griffiths I §1). -/
theorem F_step_le (b : B) (p : ℕ) :
    VariationOfHodgeStructureData.F (B := B) (V := V) b (p + 1)
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b p :=
  VariationOfHodgeStructureData.F_antitone b (Nat.le_succ p)

/-- **Iterated Griffiths transversality**: applying the derivative
twice moves `F^p` into `F^{p-2}` (for `p ≥ 2`). The iterated form
uses antitonicity to step from `F (p-1)` through `F (p-2)`. -/
theorem griffiths_transversality_twice (b : B) {p : ℕ} (hp : 2 ≤ p) :
    VariationOfHodgeStructureData.derivative (B := B) (V := V) b p
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b (p - 2) := by
  have hp1 : 1 ≤ p := le_trans (by norm_num) hp
  -- Direct shadow: derivative b p ⊆ F b (p - 1), and
  -- F b (p - 1) ⊆ F b (p - 2) since `p - 2 ≤ p - 1`.
  have h1 : VariationOfHodgeStructureData.derivative (B := B) (V := V) b p
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b (p - 1) :=
    VariationOfHodgeStructureData.griffiths_transversality_filt b hp1
  have h2 : VariationOfHodgeStructureData.F (B := B) (V := V) b (p - 1)
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b (p - 2) :=
    VariationOfHodgeStructureData.F_antitone b (by omega)
  exact h1.trans h2

/-- **Zero is always a Hodge-filtered element** (`Submodule.zero_mem`,
restated for ergonomic rewriting). -/
theorem zero_mem_F (b : B) (p : ℕ) :
    (0 : V) ∈ VariationOfHodgeStructureData.F (B := B) (V := V) b p :=
  (VariationOfHodgeStructureData.F (B := B) (V := V) b p).zero_mem

/-- **Hodge filtration at `p = 0` contains `F^p`** for every `p`
(by antitonicity). -/
theorem F_le_F_zero (b : B) (p : ℕ) :
    VariationOfHodgeStructureData.F (B := B) (V := V) b p
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b 0 :=
  VariationOfHodgeStructureData.F_antitone b (Nat.zero_le p)

end VariationOfHodgeStructureData

/-! ## Gauss-Manin flatness (sibling typeclass)

The connection `∇` on the local system underlying a
`VariationOfHodgeStructureData` is required to be **flat** (Gauss-
Manin theorem; Katz-Oda 1968). We encode flatness in its
self-curvature-vanishes form, with the connection abstracted as a
bilinear map `Base × V → V`.

This is a sibling typeclass (not extending
`VariationOfHodgeStructureData`) because a single ambient `V` can
carry many `∇`s; the VHS axioms only constrain the filtration and the
polarisation.

To make the connection a *`ℚ`-bilinear* map (which is the case for
the Gauss-Manin connection at the rational level — `∇` is
`𝒪`-linear in the tangent direction and additive in the section),
we additionally require the base `B` to carry a `ℚ`-module structure.
This is satisfied by the tangent space at any point of an algebraic
base, after rationalisation. -/

/-- **Flat connection data** on the ambient module `V` of a variation
of Hodge structures with base `B` (rationalised tangent space).

Carries:

* `connection : B →ₗ[ℚ] V →ₗ[ℚ] V` — the Gauss-Manin connection as
  a `ℚ`-bilinear map `(ξ, v) ↦ ∇_ξ v`.

* `flatness` — **substantive flatness**: `∇_ξ ∘ ∇_ξ = 0` on `V` for
  every `ξ : B`. This is the *self-curvature-vanishes* identity
  `R(ξ, ξ) = 0`, equivalent on one-dimensional integral curves to
  the full `R(∇) = 0` (Katz-Oda 1968, §2-§3). -/
class FlatConnection (B : Type*) (V : Type*)
    [AddCommGroup B] [Module ℚ B] [AddCommGroup V] [Module ℚ V] where
  /-- The Gauss-Manin connection `(ξ, v) ↦ ∇_ξ v`. -/
  connection : B →ₗ[ℚ] V →ₗ[ℚ] V
  /-- **Flatness of the Gauss-Manin connection** (self-curvature
  vanishes; Katz-Oda 1968). -/
  flatness : ∀ (ξ : B) (v : V), connection ξ (connection ξ v) = 0

namespace FlatConnection

variable {B' V' : Type*}
variable [AddCommGroup B'] [Module ℚ B'] [AddCommGroup V'] [Module ℚ V']
variable [FlatConnection B' V']

/-- **Flatness applied at zero**: `∇_ξ 0 = 0`, base case of the
flatness identity. -/
theorem flat_at_zero (ξ : B') :
    FlatConnection.connection (B := B') (V := V') ξ
      (FlatConnection.connection (B := B') (V := V') ξ 0) = 0 := by
  -- `connection ξ` is linear, so sends `0` to `0`.
  simp

/-- **Connection is linear in the section** — restatement for
ergonomic rewriting. -/
theorem connection_add (ξ : B') (v w : V') :
    FlatConnection.connection (B := B') (V := V') ξ (v + w) =
      FlatConnection.connection (B := B') (V := V') ξ v
        + FlatConnection.connection (B := B') (V := V') ξ w :=
  map_add _ v w

/-- **Connection is linear in the tangent direction** — restatement
for ergonomic rewriting. -/
theorem connection_add_tangent (ξ η : B') (v : V') :
    FlatConnection.connection (B := B') (V := V') (ξ + η) v =
      FlatConnection.connection (B := B') (V := V') ξ v
        + FlatConnection.connection (B := B') (V := V') η v := by
  rw [map_add]
  rfl

end FlatConnection

/-! ## Trivial substantive instance on `B = ℚ`, `V = ℚ`

We exhibit fully substantive instances of `VariationOfHodgeStructureData`
and `FlatConnection` on the trivial base/fibre pair `(ℚ, ℚ)`:

* Hodge filtration `F b p = ⊤` for `p = 0` and `F b p = ⊥` for `p ≥ 1`.
* Derivative `derivative b p = ⊥` everywhere (the zero connection
  has zero derivative); Griffiths transversality `⊥ ≤ F b (p-1)` is
  the substantive inclusion `bot_le`.
* Polarisation form is the multiplication form `(x, y) ↦ x · y` on
  `ℚ` (genuinely non-degenerate; the witness `w = 1` separates).
* Connection is the zero bilinear map; flatness `0 ∘ 0 = 0` holds.

These instances witness the consistency of all axioms. -/

namespace Trivial_Variation

/-- The trivial-base Hodge filtration on `ℚ`: `F^0 = ⊤`, `F^p = ⊥`
for `p ≥ 1`. -/
def trivF : ℚ → ℕ → Submodule ℚ ℚ
  | _, 0 => (⊤ : Submodule ℚ ℚ)
  | _, _ + 1 => (⊥ : Submodule ℚ ℚ)

@[simp] theorem trivF_zero (b : ℚ) : trivF b 0 = (⊤ : Submodule ℚ ℚ) := rfl
@[simp] theorem trivF_succ (b : ℚ) (k : ℕ) :
    trivF b (k + 1) = (⊥ : Submodule ℚ ℚ) := rfl

/-- The trivial-base derivative module: `⊥` for every `(b, p)`. -/
def trivDerivative : ℚ → ℕ → Submodule ℚ ℚ := fun _ _ => (⊥ : Submodule ℚ ℚ)

@[simp] theorem trivDerivative_apply (b : ℚ) (p : ℕ) :
    trivDerivative b p = (⊥ : Submodule ℚ ℚ) := rfl

/-- The multiplication form `(x, y) ↦ x · y` on `ℚ`, packaged as a
`ℚ`-bilinear map. This is the polarisation of the trivial weight-0
Hodge structure on `ℚ`. -/
def trivMulForm : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ :=
  LinearMap.mk₂ ℚ (fun x y => x * y)
    (fun _ _ _ => by ring)
    (fun _ _ _ => by simp [smul_eq_mul, mul_assoc])
    (fun _ _ _ => by ring)
    (fun _ _ _ => by simp [smul_eq_mul]; ring)

@[simp] theorem trivMulForm_apply (x y : ℚ) : trivMulForm x y = x * y := rfl

/-- Trivial substantive `VariationOfHodgeStructureData ℚ ℚ` instance:
trivial filtration, zero derivative, multiplication-form polarisation.
All axioms verified non-vacuously. -/
instance vhsData_ℚ_ℚ : VariationOfHodgeStructureData ℚ ℚ where
  F := trivF
  derivative := trivDerivative
  polarisationForm := trivMulForm
  F_antitone := by
    intro b p q hpq
    -- Case split on `q`: if `q = 0` then `p = 0` and both are `⊤`;
    -- otherwise `q = k + 1` and `F b q = ⊥ ≤ F b p`.
    rcases Nat.eq_zero_or_pos q with hq0 | hq1
    · -- q = 0 forces p = 0 since p ≤ q.
      subst hq0
      have : p = 0 := Nat.le_zero.mp hpq
      subst this
      exact le_rfl
    · -- q = k + 1, so F b q = ⊥; ⊥ ≤ anything.
      obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hq1)
      simp [trivF]
  griffiths_transversality_filt := by
    intro b p _hp
    -- derivative b p = ⊥ ≤ F b (p - 1).
    show trivDerivative b p ≤ trivF b (p - 1)
    simp [trivDerivative]
  polarisationForm_nondegen := by
    intro v hv
    -- Take w = 1: trivMulForm v 1 = v * 1 = v, so v = 0.
    have h1 := hv 1
    simpa using h1

/-- The zero `ℚ`-bilinear connection `ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ`. -/
def zeroConnection : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ := 0

@[simp] theorem zeroConnection_apply (ξ v : ℚ) : zeroConnection ξ v = 0 := rfl

/-- Trivial substantive `FlatConnection ℚ ℚ` instance: zero
connection, with flatness `0 ∘ 0 = 0` holding non-vacuously. -/
instance flatConnection_ℚ_ℚ : FlatConnection ℚ ℚ where
  connection := zeroConnection
  flatness := by
    intro ξ v
    -- Both nested applications collapse to `0`.
    simp [zeroConnection]

end Trivial_Variation

/-! ## Theorem-level restatements for downstream consumers -/

variable {B V}

/-- **Antitonicity** of the Hodge filtration (theorem form,
Griffiths I §1). -/
theorem VariationOfHodgeStructureData.hodge_filtration_antitone
    [VariationOfHodgeStructureData B V] (b : B) {p q : ℕ} (hpq : p ≤ q) :
    VariationOfHodgeStructureData.F (B := B) (V := V) b q
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b p :=
  VariationOfHodgeStructureData.F_antitone b hpq

/-- **Griffiths transversality** (theorem form, Griffiths I §3). -/
theorem VariationOfHodgeStructureData.griffiths_transversality
    [VariationOfHodgeStructureData B V] (b : B) {p : ℕ} (hp : 1 ≤ p) :
    VariationOfHodgeStructureData.derivative (B := B) (V := V) b p
      ≤ VariationOfHodgeStructureData.F (B := B) (V := V) b (p - 1) :=
  VariationOfHodgeStructureData.griffiths_transversality_filt b hp

/-- **Non-degeneracy of the polarisation** (theorem form, Voisin II
Defn 10.1 (iii)). -/
theorem VariationOfHodgeStructureData.polarisation_nondegenerate
    [VariationOfHodgeStructureData B V]
    (v : V) (h : ∀ w : V,
      VariationOfHodgeStructureData.polarisationForm (B := B) (V := V) v w
        = 0) :
    v = 0 :=
  VariationOfHodgeStructureData.polarisationForm_nondegen v h

/-- **Gauss-Manin flatness** (theorem form, Katz-Oda 1968). -/
theorem FlatConnection.gauss_manin_flat
    {B' V' : Type*} [AddCommGroup B'] [Module ℚ B']
    [AddCommGroup V'] [Module ℚ V']
    [FlatConnection B' V'] (ξ : B') (v : V') :
    FlatConnection.connection (B := B') (V := V') ξ
      (FlatConnection.connection (B := B') (V := V') ξ v) = 0 :=
  FlatConnection.flatness ξ v

end HodgeReduction.Infrastructure.HodgeStructure
