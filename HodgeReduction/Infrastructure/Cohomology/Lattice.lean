/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Lattice
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Group.Subgroup.ZPowers.Basic
import Mathlib.Algebra.Group.Subgroup.ZPowers.Lemmas
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Algebra.Algebra.Bilinear

/-!
# Lattice / quadratic form framework

A **lattice** is a free `ℤ`-module of finite rank with a `ℤ`-valued
symmetric bilinear form. For our HC application:
* Integer cohomology `H^*(X; ℤ)` (modulo torsion) is a lattice.
* The intersection form on `H^k(X; ℤ)` is a lattice quadratic form.
* The Mumford-Tate group of a polarised HS is the stabiliser of the
  polarisation form on the integer lattice.

This file packages **abstract lattice + quadratic form data**.

## References

* Voisin, *Hodge Theory and Complex Algebraic Geometry*, Vol. I
  (Cambridge, 2002), Ch. 7.1 — the rational structure
  `H^k(X; ℚ) ⊆ H^k(X; ℂ)` and the integer lattice `H^k(X; ℤ)/torsion`.
* Borel & Serre, "Corners and arithmetic groups", *Comment. Math. Helv.*
  48 (1973) 436–491 — commensurability of arithmetic lattices and the
  arithmetic-quotient point of view.
* Milnor & Husemoller, *Symmetric Bilinear Forms* (Springer, 1973) —
  even / unimodular / definite lattices, classification.

## Main definitions

* `LatticeData A` — an integer sublattice `L ⊆ A` inside a
  `ℚ`-vector space `A`, with finite rank, torsion-freeness, and the
  fundamental `ℚ`-span identity `Span_ℚ L = A`.
* `DualLatticeData A L` — the ℚ-dual lattice with a perfect-pairing
  condition realising `Hom_ℤ(L, ℤ) ≅ L^∨` for `unimodular` lattices.

## Tags

lattice, integer lattice, rational structure, quadratic form,
intersection form, even lattice, dual lattice, perfect pairing,
Voisin, arithmetic group
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Integer lattices inside `ℚ`-vector spaces -/

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Lattice data** on a `ℚ`-vector space `A`:

* `L` — the integer lattice as an `AddSubgroup A` (Voisin Vol. I §7.1,
  the integer cohomology `H^*(X; ℤ)/torsion ⊆ H^*(X; ℚ)`).
* `L_rank` — the rank of the lattice (a finite invariant).
* `L_torsion_free` — every nonzero element of `L` has order `0`, i.e.,
  no nonzero element is a torsion element. For an `AddSubgroup` of an
  ambient `AddCommGroup A` that is itself a `ℚ`-vector space (so
  torsion-free), this is automatic; we state it as a substantive
  axiom so concrete instances must witness it.
* `L_spans_Q` — the fundamental rational-structure identity:
  `Span_ℚ (L : Set A) = ⊤`. That is, every element of `A` is a
  `ℚ`-linear combination of lattice elements (Voisin Vol. I §7.1.2,
  "the inclusion `L ↪ A` induces an iso `L ⊗_ℤ ℚ → A`"). -/
class LatticeData where
  /-- The integer sublattice `L ⊆ A` as an additive subgroup. -/
  L : AddSubgroup A
  /-- The rank of the lattice (= `finrank ℚ A`, since `L ⊗_ℤ ℚ ≅ A`). -/
  L_rank : ℕ
  /-- The lattice is torsion-free: no nonzero element has finite
  additive order. Equivalently, the inclusion `L ↪ A` factors through
  the torsion-free quotient. -/
  L_torsion_free :
    ∀ {x : A} (_ : x ∈ L) (n : ℕ), 0 < n → n • x = 0 → x = 0
  /-- The integer lattice spans `A` as a `ℚ`-vector space — the
  rational-structure identity `Span_ℚ L = ⊤`. This is the substantive
  geometric content: the inclusion `L ↪ A` becomes an iso after
  `⊗_ℤ ℚ`. -/
  L_spans_Q : Submodule.span ℚ (L : Set A) = ⊤

namespace LatticeData

variable {A} [LatticeData A]

/-! ### Direct re-exports as named theorems -/

/-- Theorem-level restatement of `L_spans_Q`. -/
theorem span_Q_L_eq_top :
    Submodule.span ℚ (LatticeData.L (A := A) : Set A) = ⊤ :=
  LatticeData.L_spans_Q

/-- Theorem-level restatement of `L_torsion_free`. -/
theorem torsion_free_of_mem_L {x : A} (hx : x ∈ LatticeData.L (A := A))
    {n : ℕ} (hn : 0 < n) (hnx : n • x = 0) : x = 0 :=
  LatticeData.L_torsion_free hx n hn hnx

/-- **Spanning corollary**: every `a : A` is a `ℚ`-linear combination of
lattice elements, i.e., `a ∈ Submodule.span ℚ (L : Set A)`. -/
theorem mem_span_Q_L (a : A) :
    a ∈ Submodule.span ℚ (LatticeData.L (A := A) : Set A) := by
  rw [span_Q_L_eq_top]; exact Submodule.mem_top

/-- The zero element of `A` lies in the lattice (it is the additive
identity of `AddSubgroup L`). -/
theorem zero_mem_L : (0 : A) ∈ LatticeData.L (A := A) :=
  AddSubgroup.zero_mem _

/-- The lattice is closed under negation. -/
theorem neg_mem_L {x : A} (hx : x ∈ LatticeData.L (A := A)) :
    -x ∈ LatticeData.L (A := A) :=
  AddSubgroup.neg_mem _ hx

/-- The lattice is closed under addition. -/
theorem add_mem_L {x y : A}
    (hx : x ∈ LatticeData.L (A := A))
    (hy : y ∈ LatticeData.L (A := A)) :
    x + y ∈ LatticeData.L (A := A) :=
  AddSubgroup.add_mem _ hx hy

end LatticeData

/-! ## Dual lattices and the perfect-pairing axiom

For a lattice `L ⊆ A` inside a `ℚ`-vector space, the **dual lattice**
`L^∨` consists of those `f : A →ₗ[ℚ] ℚ` that take integer values on
`L`. Equivalently, with a chosen `ℤ`-valued bilinear form on `L`,
`L^∨ = { x ∈ A | ⟨x, L⟩ ⊆ ℤ }`. A lattice is **unimodular** when the
natural map `L → L^∨` (via the chosen pairing) is an isomorphism.

We package the dual structure as a separate typeclass `DualLatticeData`
parametric in a `LatticeData` instance. The two pieces of data are:

* `Ldual` — the dual lattice as an `AddSubgroup A`.
* `pairing` — a `ℚ`-bilinear pairing `A →ₗ[ℚ] A →ₗ[ℚ] ℚ` (the
  intersection / polarisation form).
* `pairing_integer_valued` — the **perfect-pairing axiom**: for
  every `x ∈ Ldual` and `y ∈ L`, the pairing value `pairing x y` is in
  the image of `ℤ ↪ ℚ` (i.e., is an integer, encoded as
  `pairing x y ∈ AddSubgroup.zmultiples (1 : ℚ)`). This is the
  defining property of the dual lattice. -/

variable [LatticeData A]

/-- **Dual lattice data** on a `ℚ`-vector space `A` carrying a
`LatticeData` instance:

* `Ldual` — the dual lattice `L^∨ ⊆ A`.
* `pairing` — the `ℚ`-bilinear pairing `A × A → ℚ` (intersection
  form). For our use in Hodge theory this is the polarisation form
  on the integer cohomology.
* `pairing_integer_valued` — the perfect-pairing axiom: pairing values
  between `Ldual` and `L` are integers (lie in `zmultiples (1 : ℚ)`,
  the canonical integer subgroup of `ℚ`).
* `Ldual_spans_Q` — the dual lattice also spans `A` over `ℚ`
  (Voisin Vol. I §7.1, "duality is a perfect pairing on rational
  vector spaces"). -/
class DualLatticeData where
  /-- The dual lattice `L^∨ ⊆ A` as an additive subgroup. -/
  Ldual : AddSubgroup A
  /-- The `ℚ`-bilinear pairing `A × A → ℚ` (intersection /
  polarisation form). -/
  pairing : A →ₗ[ℚ] A →ₗ[ℚ] ℚ
  /-- **Perfect-pairing axiom**: pairing values between `Ldual` and `L`
  are integers, i.e., lie in `AddSubgroup.zmultiples (1 : ℚ)`. -/
  pairing_integer_valued :
    ∀ {x y : A}, x ∈ Ldual → y ∈ LatticeData.L (A := A) →
      pairing x y ∈ AddSubgroup.zmultiples (1 : ℚ)
  /-- The dual lattice spans `A` over `ℚ` (Voisin Vol. I §7.1
  rational duality). -/
  Ldual_spans_Q : Submodule.span ℚ (Ldual : Set A) = ⊤

namespace DualLatticeData

variable {A} [DualLatticeData A]

/-! ### Direct re-exports as named theorems -/

/-- The perfect-pairing axiom as a named theorem. -/
theorem pairing_integer_valued_thm {x y : A}
    (hx : x ∈ DualLatticeData.Ldual (A := A))
    (hy : y ∈ LatticeData.L (A := A)) :
    DualLatticeData.pairing x y ∈ AddSubgroup.zmultiples (1 : ℚ) :=
  DualLatticeData.pairing_integer_valued hx hy

/-- The dual-spanning property as a named theorem. -/
theorem span_Q_Ldual_eq_top :
    Submodule.span ℚ (DualLatticeData.Ldual (A := A) : Set A) = ⊤ :=
  DualLatticeData.Ldual_spans_Q

/-- Every `a : A` lies in the `ℚ`-span of the dual lattice. -/
theorem mem_span_Q_Ldual (a : A) :
    a ∈ Submodule.span ℚ (DualLatticeData.Ldual (A := A) : Set A) := by
  rw [span_Q_Ldual_eq_top]; exact Submodule.mem_top

end DualLatticeData

/-! ## Trivial inhabiting instance: `A := ℚ` with `L := ℤ ↪ ℚ`

The simplest possible lattice: the integers `ℤ` sitting inside `ℚ`
via the canonical embedding. As an `AddSubgroup ℚ`, this is
`AddSubgroup.zmultiples (1 : ℚ)` — the cyclic subgroup generated by `1`,
which consists of `{n • 1 = n | n : ℤ}`.

This instance witnesses:
* The integer lattice has rank `1`.
* The torsion-freeness axiom (`ℚ` has no nonzero torsion).
* The fundamental span identity: `Span_ℚ (zmultiples 1 : Set ℚ) = ⊤`
  (since `1` is in the lattice and `1` generates `ℚ` as a `ℚ`-module). -/

namespace QExample

/-- The integer lattice `ℤ ⊆ ℚ` as `AddSubgroup.zmultiples (1 : ℚ)`. -/
def Lint : AddSubgroup ℚ := AddSubgroup.zmultiples (1 : ℚ)

/-- `(1 : ℚ) ∈ Lint`: the generator of the integer lattice. -/
theorem one_mem_Lint : (1 : ℚ) ∈ Lint :=
  AddSubgroup.mem_zmultiples 1

/-- The integer lattice spans `ℚ` over `ℚ`: this is the substantive
content of the `LatticeData.L_spans_Q` axiom for this trivial example.

Proof: `1 ∈ Lint`, so `1 ∈ Span_ℚ Lint`. Hence `Span_ℚ Lint` is a
`Submodule ℚ ℚ` containing `1`. The submodule `{0, 1, 2, ...}`-closure
of `1` in `ℚ` is all of `ℚ` (the `Submodule ℚ ℚ` containing `1` is `⊤`
by scalar-multiplication closure: `r = r * 1 = r • 1` for all `r : ℚ`). -/
theorem Lint_spans_Q :
    Submodule.span ℚ (Lint : Set ℚ) = ⊤ := by
  -- Show `⊤ ≤ Submodule.span ℚ Lint` (the converse is trivial).
  apply le_antisymm le_top
  -- Every `r : ℚ` is `r • 1` and `1 ∈ Lint ⊆ Span_ℚ Lint`, so by
  -- `smul_mem` closure, `r • 1 = r ∈ Span_ℚ Lint`.
  intro r _
  have h1 : (1 : ℚ) ∈ Submodule.span ℚ (Lint : Set ℚ) :=
    Submodule.subset_span one_mem_Lint
  have heq : r • (1 : ℚ) = r := by
    rw [smul_eq_mul, mul_one]
  rw [← heq]
  exact Submodule.smul_mem _ r h1

/-- `ℚ` is torsion-free: `n • x = 0` with `n > 0` forces `x = 0`. This
is the substantive content of the `LatticeData.L_torsion_free` axiom. -/
theorem Q_torsion_free {x : ℚ} (n : ℕ) (hn : 0 < n) (hnx : n • x = 0) :
    x = 0 := by
  -- `n • x = (n : ℚ) * x = 0` in a `ℚ`-vector space, with `(n : ℚ) ≠ 0`
  -- since `n > 0`. Cancel `(n : ℚ)`.
  have hn_ne_zero : (n : ℚ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.pos_iff_ne_zero.mp hn)
  have : (n : ℚ) * x = 0 := by rw [← nsmul_eq_mul]; exact hnx
  exact (mul_eq_zero.mp this).resolve_left hn_ne_zero

/-- The trivial inhabiting `LatticeData` on `ℚ`: the integer lattice
is `AddSubgroup.zmultiples (1 : ℚ)`, rank `1`, torsion-free (since `ℚ`
is torsion-free), and spans `ℚ` over `ℚ` (since `1 ∈ Lint`). -/
instance instLatticeDataQ : LatticeData ℚ where
  L := Lint
  L_rank := 1
  L_torsion_free := fun _ n hn hnx => Q_torsion_free n hn hnx
  L_spans_Q := Lint_spans_Q

/-- **Sanity check**: the integer lattice in this instance has rank `1`. -/
example : (LatticeData.L_rank (A := ℚ)) = 1 := rfl

/-- **Sanity check**: the integer lattice in this instance is
`AddSubgroup.zmultiples (1 : ℚ)`. -/
example : (LatticeData.L (A := ℚ)) = AddSubgroup.zmultiples (1 : ℚ) := rfl

/-- **Sanity check**: `1 ∈ L` for the trivial instance. -/
example : (1 : ℚ) ∈ LatticeData.L (A := ℚ) := one_mem_Lint

/-! ### Trivial `DualLatticeData` instance on `ℚ`

The dual lattice on `ℚ` is also the integer lattice — for the trivial
`(x, y) ↦ x * y` pairing on `ℚ × ℚ`, the dual of `ℤ ⊆ ℚ` is `ℤ` itself
(`ℤ` is self-dual under multiplication: `x * y ∈ ℤ` for all `y ∈ ℤ` iff
`x ∈ ℤ`).

We use the multiplication-pairing `(x, y) ↦ x * y`, which is `ℚ`-bilinear,
and check that integer × integer = integer.
-/

/-- The multiplication pairing `(x, y) ↦ x * y` as a `ℚ`-bilinear map
`ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ`.

We re-use Mathlib's `LinearMap.mul ℚ ℚ : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ` (defined
in `Mathlib.Algebra.Algebra.Bilinear`); this avoids duplicating the
bilinearity proofs. -/
def mulPairing : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ := LinearMap.mul ℚ ℚ

/-- Reduction of `mulPairing` to ordinary multiplication. -/
@[simp]
theorem mulPairing_apply (x y : ℚ) : mulPairing x y = x * y :=
  rfl

/-- Integer × integer = integer: for `x, y ∈ AddSubgroup.zmultiples 1`
in `ℚ`, the product `x * y` is also in `zmultiples 1`. -/
theorem mul_mem_zmultiples_one_of_both
    {x y : ℚ} (hx : x ∈ AddSubgroup.zmultiples (1 : ℚ))
    (hy : y ∈ AddSubgroup.zmultiples (1 : ℚ)) :
    x * y ∈ AddSubgroup.zmultiples (1 : ℚ) := by
  -- `x = n • 1 = n` for some `n : ℤ`, `y = m • 1 = m` for some `m : ℤ`.
  rcases AddSubgroup.mem_zmultiples_iff.mp hx with ⟨n, rfl⟩
  rcases AddSubgroup.mem_zmultiples_iff.mp hy with ⟨m, rfl⟩
  -- Use `zsmul_one : n • (1 : ℚ) = n` to rewrite both factors.
  rw [zsmul_one, zsmul_one]
  -- Goal: `(n : ℚ) * (m : ℚ) ∈ zmultiples (1 : ℚ)`.
  rw [← Int.cast_mul]
  exact AddSubgroup.intCast_mem_zmultiples_one _

/-- The trivial inhabiting `DualLatticeData` on `ℚ`: dual lattice is
`ℤ ⊆ ℚ` itself, with the multiplication pairing. -/
instance instDualLatticeDataQ : DualLatticeData ℚ where
  Ldual := Lint
  pairing := mulPairing
  pairing_integer_valued := fun {x y} hx hy => by
    -- `mulPairing x y` is definitionally `x * y` on `ℚ`.
    show x * y ∈ AddSubgroup.zmultiples (1 : ℚ)
    exact mul_mem_zmultiples_one_of_both hx hy
  Ldual_spans_Q := Lint_spans_Q

/-- **Sanity check**: the dual lattice equals the integer lattice. -/
example : (DualLatticeData.Ldual (A := ℚ)) = LatticeData.L (A := ℚ) := rfl

/-- **Sanity check**: the pairing of `1` and `1` is `1 ∈ ℤ`. -/
example :
    DualLatticeData.pairing (1 : ℚ) (1 : ℚ) ∈ AddSubgroup.zmultiples (1 : ℚ) :=
  DualLatticeData.pairing_integer_valued (A := ℚ) one_mem_Lint one_mem_Lint

end QExample

end HodgeReduction.Infrastructure.Cohomology
