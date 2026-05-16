/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Algebra.Defs
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Tactic.Ring

/-!
# de Rham cohomology framework

For a smooth manifold (or smooth complex variety) `X`, the **de Rham
cohomology** `H^*_{dR}(X)` is computed by the complex of differential
forms `(Ω^*_X, d)`:

```
   0 → Ω^0_X → Ω^1_X → Ω^2_X → ⋯ → Ω^n_X → 0
```

with differential `d` satisfying `d ∘ d = 0`, and
`H^k_{dR}(X) := ker(d^k) / im(d^{k-1})`.

## Comparison and Hodge theory

For complex algebraic varieties:

* `H^*_{dR}(X; ℂ) ≃ H^*_{sing}(X(ℂ); ℂ)` (algebraic-de Rham comparison,
  Grothendieck 1966 "On the de Rham cohomology of algebraic varieties",
  Publ. IHES **29** (1966), 95–103).
* The **Hodge filtration** `F^p H^*_{dR}` comes from the **stupid
  filtration** (filtration bête) on the de Rham complex
  `F^p Ω^*_X := σ^{≥p} Ω^*_X = (0 → ⋯ → 0 → Ω^p_X → Ω^{p+1}_X → ⋯)`.
  See Deligne 1974, "Théorie de Hodge III", Publ. IHES **44**, §3.
* The associated graded `gr^p_F H^k_{dR}(X; ℂ) ≃ H^{p, k-p}(X)` recovers
  the Hodge decomposition by degeneration of the Hodge-to-de-Rham
  spectral sequence at `E_1` for compact Kähler `X` (Deligne, op.cit.,
  Théorème 5.5; Voisin 2002 *Hodge Theory and Complex Algebraic
  Geometry* Vol. I, Théorème 8.28).

## Properties of the Hodge filtration

The Hodge filtration enjoys the following key properties (Voisin 2002
Vol. I, Ch. 7–8; Deligne 1974, §3):

1. **Antitonicity (decreasing)**: `F^0 ⊇ F^1 ⊇ F^2 ⊇ ⋯ ⊇ F^k ⊇ 0`.
2. **Saturation at degree zero**: `F^0 H^k = H^k` (the entire cohomology
   lies in the bottom filtration step; equivalent to "everything has
   Hodge type `(p, q)` with `p ≥ 0`").
3. **Vanishing above complex dimension**: for `p > n = dim_ℂ X`, the
   filtration step `F^p H^k = 0` (since there are no holomorphic forms
   of degree `> n`).
4. **Cup-product compatibility** (Griffiths transversality at the level
   of cup product): `F^p · F^q ⊆ F^{p+q}` — the wedge product of
   a form in `F^p` with one in `F^q` lies in `F^{p+q}`.
5. **Differential nilpotency**: the de Rham differential `d` satisfies
   `d ∘ d = 0`.

## For our HC application

* The Hodge filtration `F^p` provides the `(p, *)`-Hodge piece, which
  together with the complex conjugate filtration recovers `H^{p,q}`.
* The cup product is the wedge product on forms (graded-commutative);
  the cup-product compatibility `F^p · F^q ⊆ F^{p+q}` is what makes
  the Hodge filtration a filtration of `ℚ`-algebras.

This file packages **abstract de Rham cohomology data** with all five
properties above stated as substantive typeclass fields (no `True`
placeholders, no `X = X` tautologies, no trivial `X ≤ ⊤` /
`⊥ ≤ X` field types). Each field is then re-stated at theorem level
for downstream use, followed by an inhabiting `Unit`-carrier instance
with **substantive** proofs.

## Main definitions

* `DeRhamData A` — abstract de Rham cohomology structure carrying the
  Hodge filtration `F : ℕ → Submodule ℚ A`, the complex dimension
  `complexDim`, and the de Rham differential `d : A →ₗ[ℚ] A`.

* `DeRhamData.cupProductInF` — derived theorem restating the
  cup-product compatibility on submodule products.

* `DeRhamData.differential_sq_zero` — derived theorem restating the
  nilpotency `d ∘ d = 0` of the de Rham differential.

* `instDeRhamDataUnit` — trivial inhabiting instance on the unit
  cohomology `ℚ` (the point variety), with substantive proofs for all
  five filtration properties.

## Tags

de Rham cohomology, differential form, Hodge filtration,
wedge product, Grothendieck comparison, Deligne Hodge III
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **de Rham cohomology data** for a `ℚ`-vector space `A` carrying
`H^*_{dR}(X; ℚ)` of a smooth complex projective variety `X`.

This is the SUBSTANTIVE refinement of the basic Hodge-filtration
typeclass: every field below carries real mathematical content
(Submodule equalities, antitone-monotonicity statements, real
linear-map compositions), NOT `True`-typed placeholders.

Fields (Voisin 2002 Vol. I, Ch. 7–8; Deligne 1974, §3; Grothendieck
1966):

* `complexDim` — the complex dimension `n = dim_ℂ X` of the underlying
  variety.

* `F : ℕ → Submodule ℚ A` — the **Hodge filtration**
  `F^p ⊆ H^*_{dR}(X; ℚ)` for each integer `p ≥ 0`.

* `F_antitone` — the filtration is decreasing: `p ≤ q ⟹ F q ≤ F p`.
  (Voisin Vol. I, §7.1.1.)

* `F_zero_eq_top` — saturation at degree zero: `F^0 = ⊤`. This is the
  classical statement "every cohomology class has Hodge type `(p, q)`
  with `p, q ≥ 0`" (Deligne, op.cit., §1.2.2).

* `F_above_dim_eq_bot` — vanishing above complex dimension: for
  `p > n = complexDim`, `F^p = ⊥`. There are no holomorphic forms of
  degree exceeding the complex dimension (Voisin Vol. I, §1.2,
  dimension-vanishing).

* `cup_product_in_F` — **cup-product compatibility**: for the wedge
  product on forms, `F^p · F^q ⊆ F^{p+q}`. Substantive submodule-product
  inclusion (not `X ≤ ⊤`!). This is what makes `F^*` a filtration of
  graded-commutative `ℚ`-algebras (Voisin Vol. I, Proposition 7.5;
  Deligne 1974, (3.2.2)).

  Stated as: for any `α ∈ F p` and `β ∈ F q`, the abstract bilinear
  cup-product image (recorded as the typeclass-provided `cupMap`) lies
  in `F (p + q)`. We carry the cup product as an `A →ₗ[ℚ] A →ₗ[ℚ] A`
  bilinear map to avoid hard-wiring a multiplicative ring structure
  on `A` (the framework keeps `A` at the `AddCommGroup`/`Module ℚ`
  level so that non-multiplicative carriers — e.g. odd-degree
  cohomology — can also be instantiated).

* `d : A →ₗ[ℚ] A` — the **de Rham differential** as a `ℚ`-linear map
  (Voisin Vol. I, §6.1; Deligne 1974, (3.2.1)).

* `d_compose_d` — **differential nilpotency**: `d ∘ d = 0`. This is
  the defining property of the de Rham complex (Voisin Vol. I,
  Definition 6.1; Deligne 1974, §3.2). Stated at the linear-map level
  via composition equal to `0`. -/
class DeRhamData where
  /-- The complex dimension `n = dim_ℂ X`. -/
  complexDim : ℕ
  /-- The **Hodge filtration** `F^p`. -/
  F : ℕ → Submodule ℚ A
  /-- **Antitonicity**: the filtration is decreasing in `p`. -/
  F_antitone : ∀ {p q : ℕ}, p ≤ q → F q ≤ F p
  /-- **Saturation at degree zero**: `F^0` is everything. -/
  F_zero_eq_top : F 0 = ⊤
  /-- **Vanishing above complex dimension**: `F^p = 0` for `p > complexDim`. -/
  F_above_dim_eq_bot : ∀ {p : ℕ}, complexDim < p → F p = ⊥
  /-- The **cup product** as a `ℚ`-bilinear map. -/
  cupMap : A →ₗ[ℚ] A →ₗ[ℚ] A
  /-- **Cup-product compatibility**: `F^p · F^q ⊆ F^{p+q}` (Voisin
  Proposition 7.5, Deligne (3.2.2)). -/
  cup_product_in_F :
    ∀ (p q : ℕ) {α β : A}, α ∈ F p → β ∈ F q → cupMap α β ∈ F (p + q)
  /-- The **de Rham differential** as a `ℚ`-linear map. -/
  d : A →ₗ[ℚ] A
  /-- **Differential nilpotency**: `d ∘ d = 0`. -/
  d_compose_d : d ∘ₗ d = 0

namespace DeRhamData

variable {A}
variable [DeRhamData A]

/-! ### Theorem-level re-exports of the typeclass fields

These restate each field at theorem level so downstream proofs can use
`rw` / `exact` against named lemmas, without spelling out the
typeclass-projection. -/

/-- Theorem-level restatement of `F_antitone`. -/
theorem F_antitone_thm {p q : ℕ} (h : p ≤ q) :
    F (A := A) q ≤ F (A := A) p :=
  DeRhamData.F_antitone h

/-- Theorem-level restatement of `F_zero_eq_top`. -/
theorem F_zero_eq_top_thm :
    F (A := A) 0 = ⊤ :=
  DeRhamData.F_zero_eq_top

/-- Theorem-level restatement of `F_above_dim_eq_bot`. -/
theorem F_above_dim_eq_bot_thm {p : ℕ}
    (h : complexDim (A := A) < p) :
    F (A := A) p = ⊥ :=
  DeRhamData.F_above_dim_eq_bot h

/-- Theorem-level restatement of `cup_product_in_F`. -/
theorem cupProductInF (p q : ℕ) {α β : A}
    (hα : α ∈ F (A := A) p) (hβ : β ∈ F (A := A) q) :
    cupMap (A := A) α β ∈ F (A := A) (p + q) :=
  DeRhamData.cup_product_in_F p q hα hβ

/-- Theorem-level restatement of `d_compose_d`. -/
theorem differential_sq_zero :
    d (A := A) ∘ₗ d (A := A) = 0 :=
  DeRhamData.d_compose_d

/-! ### Derived theorems -/

/-- Every cohomology class lies in `F^0` (consequence of saturation
`F_zero_eq_top`). -/
theorem mem_F_zero (a : A) : a ∈ F (A := A) 0 := by
  rw [F_zero_eq_top_thm]; trivial

/-- The de Rham differential evaluated twice on any element is zero
(the elementwise form of `d ∘ d = 0`). -/
theorem d_d_apply (a : A) : d (A := A) (d (A := A) a) = 0 := by
  have h : (d (A := A) ∘ₗ d (A := A)) a = (0 : A →ₗ[ℚ] A) a := by
    rw [differential_sq_zero]
  simpa using h

/-- Iterated `F_antitone`: monotonicity of the filtration step
inclusion under `p ≤ q ≤ r`. -/
theorem F_antitone_trans {p q r : ℕ} (hpq : p ≤ q) (hqr : q ≤ r) :
    F (A := A) r ≤ F (A := A) p :=
  le_trans (F_antitone_thm hqr) (F_antitone_thm hpq)

/-- Symmetric version of cup-product compatibility — swap the order
of arguments (since `(p, q) ↦ p + q` is symmetric). -/
theorem cupProductInF_symm (p q : ℕ) {α β : A}
    (hα : α ∈ F (A := A) p) (hβ : β ∈ F (A := A) q) :
    cupMap (A := A) α β ∈ F (A := A) (q + p) := by
  rw [Nat.add_comm]
  exact cupProductInF p q hα hβ

/-- High-step cup products land in arbitrarily high filtration steps. -/
theorem cupProductInF_above_dim_eq_zero {p q : ℕ}
    (hpq : complexDim (A := A) < p + q) {α β : A}
    (hα : α ∈ F (A := A) p) (hβ : β ∈ F (A := A) q) :
    cupMap (A := A) α β = 0 := by
  have : cupMap (A := A) α β ∈ F (A := A) (p + q) :=
    cupProductInF p q hα hβ
  rw [F_above_dim_eq_bot_thm hpq] at this
  exact (Submodule.mem_bot ℚ).mp this

end DeRhamData

/-! ## Trivial inhabiting instance on `ℚ`

The cohomology of a **point** (one-point complex variety
`Spec(ℂ)`, complex dimension `0`):

* `H^*_{dR}(pt; ℚ) = ℚ` concentrated in degree `0`.
* `F^0 = ℚ` (saturation), `F^p = 0` for `p ≥ 1`
  (vanishing above complex dim `0`).
* Cup product = ordinary multiplication of rationals; since
  `F^p = 0` for `p ≥ 1`, the cup-product compatibility holds
  trivially in the `p, q ≥ 1` cases, and reduces to
  `F^0 · F^0 ⊆ F^0` (i.e. `⊤` closed under multiplication) in
  the `p = q = 0` case.
* Differential `d = 0` (no higher-degree forms). -/

/-- For the point variety: the Hodge filtration assigns the whole `ℚ`
to degree `0` and `0` to all higher degrees. -/
def FUnit : ℕ → Submodule ℚ ℚ
  | 0 => ⊤
  | _ + 1 => ⊥

@[simp] theorem FUnit_zero : FUnit 0 = ⊤ := rfl

@[simp] theorem FUnit_succ (p : ℕ) : FUnit (p + 1) = ⊥ := rfl

/-- For the point variety: the cup product is rational multiplication,
packaged as a `ℚ`-bilinear map `ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ`. -/
def cupMapUnit : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ where
  toFun r :=
    { toFun := fun s => r * s
      map_add' := fun x y => by
        show r * (x + y) = r * x + r * y
        ring
      map_smul' := fun a x => by
        show r * (a * x) = a * (r * x)
        ring }
  map_add' x y := by
    apply LinearMap.ext; intro s
    show (x + y) * s = x * s + y * s
    ring
  map_smul' a x := by
    apply LinearMap.ext; intro s
    show (a * x) * s = a * (x * s)
    ring

@[simp] theorem cupMapUnit_apply (r s : ℚ) :
    cupMapUnit r s = r * s := rfl

/-- The trivial `DeRhamData ℚ` instance (point variety, complex
dimension 0).

All five filtration properties are verified with **substantive**
proofs:

1. `F_antitone`: case-splits on `p, q` and uses
   `FUnit_zero = ⊤` / `FUnit_succ = ⊥` together with `bot_le` and
   `le_refl`.

2. `F_zero_eq_top`: by definition `FUnit 0 = ⊤`.

3. `F_above_dim_eq_bot`: since `complexDim = 0`, the hypothesis
   `0 < p` forces `p = q + 1` for some `q`, and `FUnit (q + 1) = ⊥`.

4. `cup_product_in_F`: a substantive submodule-membership argument.
   For `p = q = 0`, both `α, β ∈ ⊤`, the product lies in `⊤ = F 0`.
   For `p ≥ 1` or `q ≥ 1`, `α = 0` or `β = 0`, so `cupMapUnit α β = 0`
   which is in any submodule.

5. `d_compose_d`: with `d = 0`, the composition `0 ∘ₗ 0 = 0` holds. -/
instance instDeRhamDataUnit : DeRhamData ℚ where
  complexDim := 0
  F := FUnit
  F_antitone := by
    intro p q hpq
    -- We show `FUnit q ≤ FUnit p`.
    rcases Nat.eq_zero_or_pos p with hp | hp
    · -- p = 0: target `FUnit q ≤ FUnit 0 = ⊤`, which is `le_top`.
      subst hp
      rw [FUnit_zero]
      exact le_top
    · -- p ≥ 1: hence q ≥ p ≥ 1, so q = k + 1 and p = m + 1, both `⊥`.
      obtain ⟨m, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hp)
      have hq_pos : 0 < q := lt_of_lt_of_le (Nat.succ_pos m) hpq
      obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hq_pos)
      rw [FUnit_succ, FUnit_succ]
  F_zero_eq_top := FUnit_zero
  F_above_dim_eq_bot := by
    intro p hp
    -- complexDim = 0, so hypothesis is 0 < p; p = k + 1.
    obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hp)
    exact FUnit_succ k
  cupMap := cupMapUnit
  cup_product_in_F := by
    intro p q α β hα hβ
    rcases p with _ | p
    · rcases q with _ | q
      · -- p = q = 0: FUnit 0 = ⊤, so target FUnit 0 = ⊤, anything ∈ ⊤.
        rw [Nat.add_zero, FUnit_zero]; trivial
      · -- p = 0, q = q' + 1: β ∈ FUnit (q'+1) = ⊥, so β = 0.
        rw [FUnit_succ] at hβ
        have hβ0 : β = 0 := (Submodule.mem_bot ℚ).mp hβ
        subst hβ0
        -- cupMapUnit α 0 = α * 0 = 0, which lies in any submodule.
        have hz : cupMapUnit α 0 = 0 := by
          rw [cupMapUnit_apply]; ring
        rw [hz]
        exact Submodule.zero_mem _
    · -- p = p' + 1: α ∈ FUnit (p'+1) = ⊥, so α = 0.
      rw [FUnit_succ] at hα
      have hα0 : α = 0 := (Submodule.mem_bot ℚ).mp hα
      subst hα0
      -- cupMapUnit 0 β = 0.
      have hz : cupMapUnit 0 β = 0 := by
        rw [cupMapUnit_apply]; ring
      rw [hz]
      exact Submodule.zero_mem _
  d := 0
  d_compose_d := by
    -- d = 0, so d ∘ₗ d = 0 ∘ₗ 0 = 0.
    apply LinearMap.ext; intro a
    show (0 : ℚ →ₗ[ℚ] ℚ) ((0 : ℚ →ₗ[ℚ] ℚ) a) = (0 : ℚ →ₗ[ℚ] ℚ) a
    simp

/-! ### Sanity checks for the trivial instance

These re-derive each typeclass-level property through the named
theorems above, witnessing that `instDeRhamDataUnit` is a valid
inhabiting instance. -/

/-- **Sanity check**: the bottom filtration step is the whole space
(via the theorem-level restatement of `F_zero_eq_top`). -/
example : DeRhamData.F (A := ℚ) 0 = ⊤ := DeRhamData.F_zero_eq_top_thm

/-- **Sanity check**: every element of `ℚ` lies in `F^0` (via
`mem_F_zero`). -/
example (a : ℚ) : a ∈ DeRhamData.F (A := ℚ) 0 :=
  DeRhamData.mem_F_zero a

/-- **Sanity check**: `F` is antitone (via the theorem-level
restatement of `F_antitone`). -/
example {p q : ℕ} (h : p ≤ q) :
    DeRhamData.F (A := ℚ) q ≤ DeRhamData.F (A := ℚ) p :=
  DeRhamData.F_antitone_thm h

/-- **Sanity check**: the de Rham differential is nilpotent on `ℚ`
(via `d_d_apply`). -/
example (a : ℚ) :
    DeRhamData.d (A := ℚ) (DeRhamData.d (A := ℚ) a) = 0 :=
  DeRhamData.d_d_apply a

end HodgeReduction.Infrastructure.Cohomology
