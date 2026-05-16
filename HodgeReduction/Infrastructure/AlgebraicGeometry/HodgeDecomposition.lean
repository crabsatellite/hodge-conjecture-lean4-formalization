/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Analysis.SpecialFunctions.Complex.Analytic
import Mathlib.Data.Complex.Module
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Abstract Hodge decomposition primitives (R7-C)

For a compact Kähler manifold `X` of complex dimension `n`, the
**Hodge decomposition theorem** asserts that the complex singular
cohomology splits as

```
H^k(X; ℂ) = ⨁_{p + q = k} H^{p,q}(X)
```

where `H^{p,q}(X)` is the subspace of cohomology classes representable
by harmonic forms of bidegree `(p, q)`. The decomposition enjoys
**Hodge symmetry**: complex conjugation induces an isomorphism
`H^{p,q}(X) ≃ H^{q,p}(X)`, so the Hodge numbers `h^{p,q} := dim_ℂ H^{p,q}`
satisfy `h^{p,q} = h^{q,p}`. The decomposition is **bounded** by the
complex dimension: `H^{p,q}(X) = 0` whenever `p > n` or `q > n`.

The **Hodge classes of type (p, p)** are the rational cohomology
classes lying in the `(p, p)`-piece:

```
H^{p,p}(X; ℚ) := H^{2p}(X; ℚ) ∩ H^{p,p}(X)
```

The **Hodge conjecture** is the statement that every Hodge class is
the cohomology class of an algebraic cycle.

## What this file provides

Mathlib `v4.16.0` has no Hodge theory: there is neither a `Kähler`
typeclass nor an `H^{p,q}` API. We give a **parametric typeclass
framework** that downstream files can specialise once Mathlib's
Riemannian / Kähler / harmonic-forms stack lands.

* `HodgeDecompositionData X A` — typeclass packaging
  - the complex dimension `complexDim`,
  - the bidegree pieces `Hpq p q : Submodule ℂ A`,
  - the total-degree pieces `Hk k : Submodule ℂ A`,
  - the **Hodge decomposition identity** `Hk k = ⨆_{p ≤ k} Hpq p (k - p)`,
  - **Hodge symmetry** at the level of `finrank` (the field equality
    `H^{p,q} ≅ H^{q,p}` reduces to a dimension equality once we have a
    concrete carrier),
  - **vanishing above complex dimension**.

* `HodgeDecompositionData.RationalHodgeClassData X A` — a companion
  typeclass that records a rational lattice `Q_lattice : Submodule ℚ A`
  whose `ℂ`-span is all of `A` (i.e. the inclusion
  `H^*(X; ℚ) ↪ H^*(X; ℂ)` after tensoring with `ℂ`).

* `HodgeClasses X A p` — the **type of Hodge classes of bidegree (p, p)**:
  rational classes lying in the `(p, p)`-piece. The Hodge conjecture
  asserts this subspace consists of algebraic-cycle classes.

This file is **complementary** to
`HodgeReduction/Infrastructure/Cohomology/HodgeCycle.lean`, which
abstracts the *union* `⨆_p H^{p,p}(X; ℚ)` as a single subalgebra. The
present file refines that data: it tracks each `(p, p)`-piece
*individually*, plus the off-diagonal `(p, q)` pieces with `p ≠ q`
needed for Hodge-symmetry statements.

## Cat 1 kernel-purity

This file is **Category 1** (kernel-pure). Every derived theorem and
the trivial-example instance compile without `sorry`,
`native_decide`, or broken-link axioms. The Hodge decomposition theorem
itself (the existence of the bidegree splitting for harmonic forms on
a compact Kähler manifold) is years away from Mathlib; the present
typeclass **assumes** the decomposition data and re-exports its
properties — that is the canonical way to provide an abstract
interface that can be instantiated once Mathlib catches up.

## Trivial example

`HodgeDecompositionData Unit ℂ` is provided as a sanity check: the
one-point "manifold" `Spec(ℂ)` has complex dimension `0`, so
`H^0 = ℂ` (the `(0, 0)`-piece) and all other pieces vanish. The
rational lattice is `Q_lattice = ⊤ : Submodule ℚ ℂ` (every complex
number is a `ℚ`-linear combination of complex numbers — trivially the
top submodule), which spans `ℂ` over itself.

## Mathlib-compatibility

The class layout (`Hpq` indexed by `ℕ × ℕ`, decomposition stated via
`Finset.range`-indexed `⨆`, symmetry stated at the `finrank` level)
is portable: when Mathlib gains a concrete `HpqDecomposition` for
compact Kähler manifolds, an instance `HodgeDecompositionData X A`
will provide the bridge, and the derived theorems below — which only
use Mathlib primitives — will go through verbatim.

## Tags

Hodge decomposition, Hodge symmetry, Hodge classes, harmonic forms,
compact Kähler manifold, bidegree, rational lattice, Hodge conjecture
-/

namespace HodgeReduction.Infrastructure.AlgebraicGeometry

/-! ## R7-C: `HodgeDecompositionData` -/

/-- **Hodge decomposition data** for a cohomology carrier `A` representing
`H^*(X; ℂ)` of a compact Kähler manifold `X` of complex dimension `n`.

Fields:

* `complexDim` — the complex dimension `n` of `X`.
* `Hpq p q` — the `(p, q)`-piece, `H^{p,q}(X) ⊆ H^{p+q}(X; ℂ) ⊆ A`.
* `Hk k` — the total `k`-th cohomology, `H^k(X; ℂ) ⊆ A`.
* `hodge_decomp` — the **Hodge decomposition identity**
  `H^k(X; ℂ) = ⨁_{p + q = k} H^{p,q}(X)`, here stated as
  `Hk k = ⨆ p ∈ Finset.range (k+1), Hpq p (k - p)`. Since `p` ranges
  in `Finset.range (k+1) = {0, 1, …, k}` and `Nat`-subtraction is
  exact when `p ≤ k`, the equality matches the math statement.
* `hodge_symmetry_dim` — **Hodge symmetry** at the dimension level:
  `dim_ℂ H^{p,q} = dim_ℂ H^{q,p}`. Stating the full isomorphism
  `H^{p,q} ≃ H^{q,p}` (induced by complex conjugation) would require a
  conjugate-linear structure on `A`; we record the consequence
  (equality of `finrank`) instead, which is what concrete instances
  will reduce to via the Hodge-star operator.
* `Hpq_vanishing` — vanishing above the complex dimension:
  `H^{p,q}(X) = 0` whenever `p > n` or `q > n`. -/
class HodgeDecompositionData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℂ A] where
  /-- The complex dimension `n` of `X`. -/
  complexDim : ℕ
  /-- The `(p, q)`-piece of cohomology: `H^{p,q}(X) ⊆ A`. -/
  Hpq : ℕ → ℕ → Submodule ℂ A
  /-- The total `k`-th cohomology: `H^k(X; ℂ) ⊆ A`. -/
  Hk : ℕ → Submodule ℂ A
  /-- **Hodge decomposition**: `H^k = ⨁_{p + q = k} H^{p,q}`,
  here as an equality of submodules using the supremum
  indexed by `p ∈ Finset.range (k+1)` (i.e. `0 ≤ p ≤ k`). -/
  hodge_decomp : ∀ k : ℕ, Hk k = ⨆ p ∈ Finset.range (k + 1), Hpq p (k - p)
  /-- **Hodge symmetry** at the dimension level:
  `dim_ℂ H^{p,q} = dim_ℂ H^{q,p}`. The underlying isomorphism is induced
  by complex conjugation on harmonic forms; concrete instances will
  supply the conjugation operator and derive this equality from it. -/
  hodge_symmetry_dim : ∀ p q : ℕ,
    Module.finrank ℂ (Hpq p q) = Module.finrank ℂ (Hpq q p)
  /-- **Vanishing above complex dim**: `H^{p,q} = 0` if `p > n` or `q > n`. -/
  Hpq_vanishing : ∀ p q : ℕ, complexDim < p ∨ complexDim < q → Hpq p q = ⊥

namespace HodgeDecompositionData

/-! ### Theorem-level re-exports

These restate the typeclass-field identities at theorem level, so
downstream proofs can `rw [hodge_decomp_eq]` without spelling out the
typeclass-instance projection. -/

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℂ A]
variable [HodgeDecompositionData X A]

/-- Theorem-level restatement of `hodge_decomp`. -/
theorem hodge_decomp_eq (k : ℕ) :
    (Hk (X := X) (A := A) k)
      = ⨆ p ∈ Finset.range (k + 1), Hpq (X := X) (A := A) p (k - p) :=
  HodgeDecompositionData.hodge_decomp k

/-- Theorem-level restatement of `hodge_symmetry_dim`. -/
theorem hodge_symmetry_dim_eq (p q : ℕ) :
    Module.finrank ℂ (Hpq (X := X) (A := A) p q)
      = Module.finrank ℂ (Hpq (X := X) (A := A) q p) :=
  HodgeDecompositionData.hodge_symmetry_dim p q

/-- Theorem-level restatement of `Hpq_vanishing`. -/
theorem Hpq_vanishing_eq (p q : ℕ)
    (h : complexDim (X := X) (A := A) < p ∨ complexDim (X := X) (A := A) < q) :
    Hpq (X := X) (A := A) p q = ⊥ :=
  HodgeDecompositionData.Hpq_vanishing p q h

/-! ### Derived theorems -/

/-- Vanishing in the first index: if `p > n`, then `H^{p,q} = 0`. -/
theorem Hpq_vanishing_of_p (p q : ℕ)
    (h : complexDim (X := X) (A := A) < p) :
    Hpq (X := X) (A := A) p q = ⊥ :=
  Hpq_vanishing_eq p q (Or.inl h)

/-- Vanishing in the second index: if `q > n`, then `H^{p,q} = 0`. -/
theorem Hpq_vanishing_of_q (p q : ℕ)
    (h : complexDim (X := X) (A := A) < q) :
    Hpq (X := X) (A := A) p q = ⊥ :=
  Hpq_vanishing_eq p q (Or.inr h)

/-- The Hodge numbers `h^{p,q} := dim_ℂ H^{p,q}`. -/
noncomputable def hodgeNumber (p q : ℕ) : ℕ :=
  Module.finrank ℂ (Hpq (X := X) (A := A) p q)

/-- **Hodge symmetry** for the Hodge numbers: `h^{p,q} = h^{q,p}`. -/
theorem hodgeNumber_symm (p q : ℕ) :
    hodgeNumber (X := X) (A := A) p q
      = hodgeNumber (X := X) (A := A) q p :=
  hodge_symmetry_dim_eq p q

/-- **Vanishing Hodge numbers above complex dimension**: `h^{p,q} = 0`
when `p > n` or `q > n`. -/
theorem hodgeNumber_vanishing (p q : ℕ)
    (h : complexDim (X := X) (A := A) < p ∨ complexDim (X := X) (A := A) < q) :
    hodgeNumber (X := X) (A := A) p q = 0 := by
  unfold hodgeNumber
  rw [Hpq_vanishing_eq p q h]
  exact finrank_bot ℂ A

/-- Every `(p, q)`-piece is contained in the total `(p + q)`-th cohomology.

Proof: by `hodge_decomp`, `Hk (p + q) = ⨆ i ∈ range (p + q + 1), Hpq i ((p+q) - i)`.
Taking `i = p` (which lies in `range (p + q + 1)` since `p ≤ p + q`),
the summand is `Hpq p ((p + q) - p) = Hpq p q`. The supremum dominates
each summand, so `Hpq p q ≤ Hk (p + q)`. -/
theorem Hpq_le_Hk (p q : ℕ) :
    Hpq (X := X) (A := A) p q ≤ Hk (X := X) (A := A) (p + q) := by
  rw [hodge_decomp_eq]
  -- Show `Hpq p q ≤ ⨆ i ∈ Finset.range (p + q + 1), Hpq i ((p + q) - i)`.
  -- Use `le_iSup_of_le i = p` with the witness that `p ∈ Finset.range (p + q + 1)`
  -- and that `Hpq p ((p + q) - p) = Hpq p q`.
  have hp_mem : p ∈ Finset.range (p + q + 1) := by
    rw [Finset.mem_range]; omega
  have hsub : (p + q) - p = q := by omega
  refine le_iSup_of_le p (le_iSup_of_le hp_mem ?_)
  rw [hsub]

/-! ### Rational lattice -/

/-- **Rational lattice data** sitting on top of `HodgeDecompositionData`.

Packages a `Submodule ℚ A` representing the rational cohomology
`H^*(X; ℚ) ⊆ H^*(X; ℂ)` together with the property that its `ℂ`-span
is the whole carrier `A` (i.e. `H^*(X; ℂ) = H^*(X; ℚ) ⊗_ℚ ℂ`).

This typeclass is **separated** from `HodgeDecompositionData` because
- the bidegree decomposition is well-defined without a rational
  structure (purely complex analytic),
- the rational structure is needed only to state the **Hodge classes**
  and the **Hodge conjecture**. -/
class RationalHodgeClassData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℂ A] [Module ℚ A] where
  /-- The rational lattice inside `A`: `H^*(X; ℚ) ↪ H^*(X; ℂ)`. -/
  Q_lattice : Submodule ℚ A
  /-- `Q_lattice` spans `A` over `ℂ` — i.e. the inclusion
  `H^*(X; ℚ) ↪ H^*(X; ℂ)` becomes an iso after `⊗_ℚ ℂ`. -/
  Q_lattice_spans : Submodule.span ℂ (Q_lattice : Set A) = ⊤

/-! ### Hodge classes -/

end HodgeDecompositionData

/-- **Hodge classes of bidegree `(p, p)`**: the type of pairs
`⟨α, hα⟩` where `α ∈ A`, `α` lies in the rational lattice
`H^*(X; ℚ)`, and `α` lies in the `(p, p)`-piece `H^{p,p}(X)`.

This is the subspace whose elements the **Hodge conjecture** asserts
to be algebraic-cycle classes. -/
def HodgeClasses (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℂ A] [Module ℚ A]
    [HodgeDecompositionData X A]
    [HodgeDecompositionData.RationalHodgeClassData X A]
    (p : ℕ) : Type _ :=
  { α : A //
      α ∈ HodgeDecompositionData.RationalHodgeClassData.Q_lattice (X := X) (A := A) ∧
      α ∈ HodgeDecompositionData.Hpq (X := X) (A := A) p p }

namespace HodgeClasses

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℂ A] [Module ℚ A]
variable [HodgeDecompositionData X A]
variable [HodgeDecompositionData.RationalHodgeClassData X A]

/-- The underlying class of a Hodge class. -/
def val {p : ℕ} (α : HodgeClasses X A p) : A := α.1

/-- The rational-lattice membership of a Hodge class. -/
theorem mem_Q_lattice {p : ℕ} (α : HodgeClasses X A p) :
    α.val ∈ HodgeDecompositionData.RationalHodgeClassData.Q_lattice
      (X := X) (A := A) :=
  α.2.1

/-- The `(p, p)`-piece membership of a Hodge class. -/
theorem mem_Hpq {p : ℕ} (α : HodgeClasses X A p) :
    α.val ∈ HodgeDecompositionData.Hpq (X := X) (A := A) p p :=
  α.2.2

end HodgeClasses

/-! ## Trivial example: `HodgeDecompositionData Unit ℂ`

The one-point manifold `Spec(ℂ)`: a single point has complex dimension
`0`, all cohomology lives in degree `0`, and the entire cohomology is
the `(0, 0)`-piece (= `ℂ` itself).

* `complexDim := 0`.
* `Hpq 0 0 := ⊤`; `Hpq p q := ⊥` whenever `(p, q) ≠ (0, 0)`.
* `Hk 0 := ⊤`; `Hk k := ⊥` for `k ≥ 1`.

The three properties to verify:

1. **Hodge decomposition**:
   - `k = 0`: `Hk 0 = ⊤` and `⨆ p ∈ Finset.range 1, Hpq p (0 - p) = Hpq 0 0 = ⊤`. ✓
   - `k ≥ 1`: `Hk k = ⊥` and every summand `Hpq p (k - p)` with
     `p ≤ k` and `p + (k - p) = k ≥ 1` has either `p > 0` or `k - p > 0`,
     so `Hpq p (k - p) = ⊥`. The supremum of bottoms is `⊥`. ✓

2. **Hodge symmetry**: `finrank ℂ (Hpq p q) = finrank ℂ (Hpq q p)`. The
   only non-bottom case is `p = q = 0`; the symmetry condition holds
   under swap since `(p = 0 ∧ q = 0) ↔ (q = 0 ∧ p = 0)`. ✓

3. **Vanishing above complex dim**: `Hpq p q = ⊥` whenever
   `0 < p ∨ 0 < q`. ✓ -/

namespace HodgeDecompositionData.Trivial

/-- The bidegree pieces for the one-point trivial example: `H^{0,0} = ℂ`,
all others zero. -/
noncomputable def HpqTrivial (p q : ℕ) : Submodule ℂ ℂ :=
  if p = 0 ∧ q = 0 then ⊤ else ⊥

/-- The total `k`-th cohomology pieces for the trivial example:
`H^0 = ℂ`, all others zero. -/
noncomputable def HkTrivial (k : ℕ) : Submodule ℂ ℂ :=
  if k = 0 then ⊤ else ⊥

@[simp]
theorem HpqTrivial_zero_zero : HpqTrivial 0 0 = ⊤ := by
  unfold HpqTrivial; simp

@[simp]
theorem HpqTrivial_eq_bot_of_p_pos {p q : ℕ} (hp : 0 < p) :
    HpqTrivial p q = ⊥ := by
  unfold HpqTrivial
  have : ¬ (p = 0 ∧ q = 0) := fun ⟨hp', _⟩ => Nat.lt_irrefl 0 (hp' ▸ hp)
  simp [this]

@[simp]
theorem HpqTrivial_eq_bot_of_q_pos {p q : ℕ} (hq : 0 < q) :
    HpqTrivial p q = ⊥ := by
  unfold HpqTrivial
  have : ¬ (p = 0 ∧ q = 0) := fun ⟨_, hq'⟩ => Nat.lt_irrefl 0 (hq' ▸ hq)
  simp [this]

@[simp]
theorem HkTrivial_zero : HkTrivial 0 = ⊤ := by
  unfold HkTrivial; simp

@[simp]
theorem HkTrivial_eq_bot_of_pos {k : ℕ} (hk : 0 < k) : HkTrivial k = ⊥ := by
  unfold HkTrivial
  have : k ≠ 0 := Nat.pos_iff_ne_zero.mp hk
  simp [this]

/-- The trivial `HodgeDecompositionData` on `(Unit, ℂ)`: the one-point
"manifold" with complex dimension `0`. -/
noncomputable instance instHodgeDecompositionDataTrivial :
    HodgeDecompositionData Unit ℂ where
  complexDim := 0
  Hpq := HpqTrivial
  Hk := HkTrivial
  hodge_decomp := by
    intro k
    -- Case split on `k = 0` vs `k ≥ 1`.
    rcases Nat.eq_zero_or_pos k with hk | hk
    · -- `k = 0`: LHS = `⊤`, RHS = `⨆ p ∈ Finset.range 1, Hpq p (0 - p) = Hpq 0 0 = ⊤`.
      subst hk
      rw [HkTrivial_zero]
      -- `Finset.range 1 = {0}`, so the supremum reduces to `Hpq 0 0 = ⊤`.
      have h0 : (0 : ℕ) ∈ Finset.range (0 + 1) := by
        rw [Finset.mem_range]; omega
      have htop : HpqTrivial 0 (0 - 0) = ⊤ := by simp
      have hge : (⊤ : Submodule ℂ ℂ)
          ≤ ⨆ p ∈ Finset.range (0 + 1), HpqTrivial p (0 - p) :=
        calc (⊤ : Submodule ℂ ℂ)
            = HpqTrivial 0 (0 - 0) := htop.symm
          _ ≤ ⨆ p ∈ Finset.range (0 + 1), HpqTrivial p (0 - p) :=
              le_iSup_of_le 0 (le_iSup_of_le h0 le_rfl)
      exact le_antisymm hge le_top
    · -- `k ≥ 1`: LHS = `⊥`, RHS = supremum of `⊥`s = `⊥`.
      rw [HkTrivial_eq_bot_of_pos hk]
      -- Each summand `HpqTrivial p (k - p)` with `p ∈ range (k+1)` and
      -- `p + (k - p) = k ≥ 1` is `⊥` (either `p ≥ 1` or `k - p ≥ 1`).
      have hle : (⨆ p ∈ Finset.range (k + 1), HpqTrivial p (k - p))
          ≤ (⊥ : Submodule ℂ ℂ) := by
        apply iSup_le; intro p
        apply iSup_le; intro hp_mem
        rw [Finset.mem_range] at hp_mem
        rcases Nat.eq_zero_or_pos p with hp0 | hp_pos
        · -- `p = 0`: then `k - p = k > 0`, so the summand is `⊥`.
          subst hp0
          rw [HpqTrivial_eq_bot_of_q_pos (by omega : 0 < k - 0)]
        · -- `p ≥ 1`: the summand is `⊥` directly.
          rw [HpqTrivial_eq_bot_of_p_pos hp_pos]
      exact le_antisymm bot_le hle
  hodge_symmetry_dim := by
    intro p q
    -- We split on whether `(p, q) = (0, 0)`.
    by_cases h : p = 0 ∧ q = 0
    · obtain ⟨hp, hq⟩ := h
      subst hp; subst hq
      rfl
    · -- At least one of `p`, `q` is positive, so both `Hpq p q` and
      -- `Hpq q p` are `⊥` (the predicate is symmetric in `(p, q)`).
      have hpq : HpqTrivial p q = ⊥ := by
        rcases Nat.eq_zero_or_pos p with hp | hp
        · subst hp
          have hq : 0 < q := by
            rcases Nat.eq_zero_or_pos q with hq | hq
            · exact absurd ⟨rfl, hq⟩ h
            · exact hq
          exact HpqTrivial_eq_bot_of_q_pos hq
        · exact HpqTrivial_eq_bot_of_p_pos hp
      have hqp : HpqTrivial q p = ⊥ := by
        rcases Nat.eq_zero_or_pos q with hq | hq
        · subst hq
          have hp : 0 < p := by
            rcases Nat.eq_zero_or_pos p with hp | hp
            · exact absurd ⟨hp, rfl⟩ h
            · exact hp
          exact HpqTrivial_eq_bot_of_q_pos hp
        · exact HpqTrivial_eq_bot_of_p_pos hq
      rw [hpq, hqp]
  Hpq_vanishing := by
    intro p q h
    rcases h with hp | hq
    · -- `0 < p`: `HpqTrivial p q = ⊥`.
      exact HpqTrivial_eq_bot_of_p_pos hp
    · -- `0 < q`: `HpqTrivial p q = ⊥`.
      exact HpqTrivial_eq_bot_of_q_pos hq

/-- The trivial `RationalHodgeClassData` on `(Unit, ℂ)`: the rational
lattice is all of `ℂ` (viewed as a `ℚ`-submodule via `⊤`), which spans
`ℂ` over itself. -/
instance instRationalHodgeClassDataTrivial :
    HodgeDecompositionData.RationalHodgeClassData Unit ℂ where
  Q_lattice := ⊤
  Q_lattice_spans := by
    -- `((⊤ : Submodule ℚ ℂ) : Set ℂ) = Set.univ`, and the `ℂ`-span of
    -- `Set.univ` is `⊤`.
    show Submodule.span ℂ ((⊤ : Submodule ℚ ℂ) : Set ℂ) = ⊤
    have : ((⊤ : Submodule ℚ ℂ) : Set ℂ) = Set.univ := by
      ext x; simp
    rw [this, Submodule.span_univ]

/-! ### Sanity checks for the trivial example -/

/-- **Sanity check**: the trivial example has complex dimension `0`. -/
example : HodgeDecompositionData.complexDim (X := Unit) (A := ℂ) = 0 := rfl

/-- **Sanity check**: the `(0, 0)`-piece of the trivial example is `⊤`. -/
example : HodgeDecompositionData.Hpq (X := Unit) (A := ℂ) 0 0 = ⊤ := by
  show HpqTrivial 0 0 = ⊤
  exact HpqTrivial_zero_zero

/-- **Sanity check**: the `(1, 0)`-piece of the trivial example vanishes. -/
example : HodgeDecompositionData.Hpq (X := Unit) (A := ℂ) 1 0 = ⊥ := by
  show HpqTrivial 1 0 = ⊥
  exact HpqTrivial_eq_bot_of_p_pos (by omega)

/-- **Sanity check**: Hodge-number symmetry on the trivial example
between the `(0, 1)`- and `(1, 0)`-pieces (both zero). -/
example :
    HodgeDecompositionData.hodgeNumber (X := Unit) (A := ℂ) 0 1
      = HodgeDecompositionData.hodgeNumber (X := Unit) (A := ℂ) 1 0 :=
  HodgeDecompositionData.hodgeNumber_symm 0 1

/-- **Sanity check**: the `(2, 0)`-piece of the trivial example
vanishes by `HpqTrivial_eq_bot_of_p_pos` (since `0 < 2`). -/
example : HodgeDecompositionData.Hpq (X := Unit) (A := ℂ) 2 0 = ⊥ := by
  show HpqTrivial 2 0 = ⊥
  exact HpqTrivial_eq_bot_of_p_pos (by omega)

end HodgeDecompositionData.Trivial

/-! ## Phase 4 audit: kernel-purity diagnostic

Uncomment any of the lines below to inspect the axiom dependencies of
the derived theorems and the trivial-example instance. Verified output
(R7-C audit): all entries depend only on
`[propext, Classical.choice, Quot.sound]` (the kernel-pure axiom set);
the simpler ones use `[propext]` only. No `sorry`, no `native_decide`,
no broken-link axioms.

```
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.hodge_decomp_eq
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.hodge_symmetry_dim_eq
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.Hpq_vanishing_eq
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.Hpq_vanishing_of_p
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.Hpq_vanishing_of_q
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.hodgeNumber_symm
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.hodgeNumber_vanishing
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.Hpq_le_Hk
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.Trivial.instHodgeDecompositionDataTrivial
-- #print axioms HodgeReduction.Infrastructure.AlgebraicGeometry.HodgeDecompositionData.Trivial.instRationalHodgeClassDataTrivial
```
-/

end HodgeReduction.Infrastructure.AlgebraicGeometry
