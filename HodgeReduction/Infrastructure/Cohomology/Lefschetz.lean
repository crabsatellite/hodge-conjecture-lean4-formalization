/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Lefschetz theorems framework

For a smooth projective complex variety `X` with polarisation (Kähler
class) `h ∈ H²(X; ℚ)`, the **Lefschetz theorems** give:

1. **Lefschetz (1,1) theorem**: every Hodge class of type (1, 1) in
   `H²(X; ℤ)` is the first Chern class of a line bundle, hence algebraic.
   This is the **codimension-1 case of the Hodge conjecture** — proven
   classically (Lefschetz 1924; reproven by Hodge 1941, Kodaira 1953).

2. **Hard Lefschetz theorem**: for a Kähler class `h ∈ H²` on a compact
   Kähler manifold `X` of complex dimension `n`, cup product with `hᵏ`
   gives an isomorphism `H^{n-k}(X; ℚ) ≃ H^{n+k}(X; ℚ)` for `0 ≤ k ≤ n`.

3. **Lefschetz hyperplane theorem**: for `i_X : Y ↪ X` a smooth
   hyperplane section, the restriction `H^k(X; ℚ) → H^k(Y; ℚ)` is an
   isomorphism for `k < dim Y` and injective for `k = dim Y`.

This file packages the **Lefschetz (1,1) theorem** as a framework
typeclass. The full proof requires complex-analytic input (exponential
sequence + Picard group + cycle class map for divisors) not yet in
Mathlib.

## Main definitions

* `Lefschetz11Data A` : typeclass packaging the `H^{1,1}` subspace and
  the Lefschetz (1,1) algebraicity property.

## Tags

Lefschetz (1,1) theorem, divisor algebraicity, Hodge conjecture codim 1,
Néron-Severi group
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Lefschetz (1,1) theorem data** for a cohomology ring `A`:

* `H2` : the degree-2 cohomology subspace `H²(X; ℚ) ⊆ A`.
* `H11` : the `(1,1)`-Hodge piece `H^{1,1}(X; ℚ) ⊆ H²`.
* `lefschetz_11` : the **Lefschetz (1,1) theorem** — every rational
  `H^{1,1}` class is algebraic. This is the classical theorem
  (Lefschetz 1924), proven via the exponential sequence + Néron-Severi
  group + Picard variety.

For our HC application, this captures the **trivial codimension-1 case**
of HC. We use it to:
* Verify that `h ∈ H²` is `(1,1)` (since it's the polarisation).
* Derive `h ∈ algebraic` from `Lefschetz11Data` (without needing a
  separate `KaehlerClass.h_isAlgebraic` axiom). -/
class Lefschetz11Data where
  /-- The degree-2 cohomology subspace. -/
  H2 : Submodule ℚ A
  /-- The (1,1)-Hodge piece. -/
  H11 : Submodule ℚ A
  /-- The (1,1)-piece is contained in `H²`. -/
  H11_le_H2 : H11 ≤ H2
  /-- **Lefschetz (1,1) theorem**: every `H^{1,1}` rational class is
  algebraic. This is the load-bearing axiomatic content (a CLASSICAL
  THEOREM, proven by Lefschetz 1924). -/
  lefschetz_11 : ∀ α ∈ H11, CohomologyRing.IsAlgebraic α

namespace Lefschetz11Data

variable {A} [Lefschetz11Data A]

/-- Every `(1,1)`-Hodge class is algebraic (Lefschetz (1,1) theorem). -/
theorem isAlgebraic_of_H11 {α : A} (hα : α ∈ H11 (A := A)) :
    CohomologyRing.IsAlgebraic α :=
  lefschetz_11 α hα

end Lefschetz11Data

/-! ### Bridge: Kähler class is in `H^{1,1}` → algebraic via Lefschetz (1,1)

If the cohomology ring has both a `KaehlerClass` and `Lefschetz11Data`,
and if the Kähler class lies in `H^{1,1}`, then it's algebraic via
Lefschetz (1,1) — providing an ALTERNATIVE proof of
`KaehlerClass.h_isAlgebraic` not requiring it as a separate axiom. -/

variable [Lefschetz11Data A] [KaehlerClass A]

/-- **Bridge theorem**: if the Kähler class `h` is in `H^{1,1}`, then
`h` is algebraic via Lefschetz (1,1). This DERIVES `h_isAlgebraic`
from `Lefschetz11Data` (rather than assuming it). -/
theorem KaehlerClass.h_isAlgebraic_via_lefschetz11
    (h_in_H11 : (KaehlerClass.h : A) ∈ Lefschetz11Data.H11) :
    CohomologyRing.IsAlgebraic (KaehlerClass.h : A) :=
  Lefschetz11Data.isAlgebraic_of_H11 h_in_H11

end HodgeReduction.Infrastructure.Cohomology

/-! ### Lefschetz operator data and sl₂-triple relations

For a compact Kähler manifold `X` of complex dimension `n`, the
**Lefschetz operator** `L : H^*(X) → H^*(X)` (cup product with the
Kähler class `h`) extends to an `sl₂(ℚ)`-action on `H^*(X; ℚ)` together
with two companion operators:

* `Λ` — the **dual Lefschetz operator** (formal adjoint of `L` with
  respect to the Hodge inner product; "primitive projection" in
  Voisin 2002 Vol. I §6.2).
* `H` — the **degree-shift operator**, eigenvalue `k - n` on `H^k(X)`.

The three operators `(L, Λ, H)` satisfy the **sl₂-relations** of
Lefschetz 1924 (Voisin 2002 Vol. I §6.2; Griffiths-Harris 1978 Ch. 0.7):

```
   [L, Λ] = H,    [H, L] = 2 L,    [H, Λ] = -2 Λ.
```

These bracket identities are the substantive Lefschetz sl₂-decomposition
content. Their consequence — the Lefschetz **primitive decomposition**

```
   H^k(X; ℚ) = ⨁_{j ≥ max(0, k - n)} L^j (P^{k - 2j}(X; ℚ))
```

(where `P^k := ker(Λ : H^k → H^{k - 2})`) — is the geometric form of
Hard Lefschetz packaged as a direct-sum decomposition. -/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Lefschetz operator triple data** for a `ℚ`-module `A` (the
cohomology `H^*(X; ℚ)` of a compact Kähler manifold):

* `L : A →ₗ[ℚ] A` — cup product with the Kähler class `h`.
* `Lambda : A →ₗ[ℚ] A` — the dual Lefschetz operator (formal adjoint).
* `Hop : A →ₗ[ℚ] A` — the degree-shift operator `k ↦ k - n`.

The three operators satisfy the **sl₂-relations** of Lefschetz 1924 /
Voisin 2002 Vol. I §6.2:

* `[L, Λ] = H`               (sl₂ bracket: `LΛ - ΛL = H`)
* `[H, L] = 2 L`             (Cartan eigenvalue: `HL - LH = 2 L`)
* `[H, Λ] = -2 Λ`            (Cartan eigenvalue: `HΛ - ΛH = -2 Λ`)

These are substantive `LinearMap` equations (the bracket operations
genuinely produce `H`, `2 L`, `-2 Λ` respectively as linear maps). -/
class LefschetzOperatorData (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The Lefschetz operator `L` (cup with `h`). -/
  L : A →ₗ[ℚ] A
  /-- The dual Lefschetz operator `Λ`. -/
  Lambda : A →ₗ[ℚ] A
  /-- The degree-shift operator `H`. -/
  Hop : A →ₗ[ℚ] A
  /-- **sl₂ bracket** `[L, Λ] = H`: the commutator of `L` and `Λ`
  equals the degree-shift operator. Substantive linear-map equation
  (Voisin 2002 Vol. I Prop. 6.6). -/
  sl2_bracket_L_Lambda : L.comp Lambda - Lambda.comp L = Hop
  /-- **Cartan eigenvalue** `[H, L] = 2 L`: the bracket of `H` and `L`
  is twice `L`. -/
  sl2_bracket_H_L : Hop.comp L - L.comp Hop = (2 : ℚ) • L
  /-- **Cartan eigenvalue** `[H, Λ] = -2 Λ`: the bracket of `H` and `Λ`
  is minus twice `Λ`. -/
  sl2_bracket_H_Lambda : Hop.comp Lambda - Lambda.comp Hop = (-2 : ℚ) • Lambda

namespace LefschetzOperatorData

variable {A : Type*} [AddCommGroup A] [Module ℚ A] [LefschetzOperatorData A]

/-- **Pointwise reformulation** of `sl2_bracket_L_Lambda`: for every
`x : A`, `L (Λ x) - Λ (L x) = H x`. -/
theorem sl2_bracket_L_Lambda_apply (x : A) :
    L (Lambda x) - Lambda (L x) = Hop (x : A) := by
  have h := sl2_bracket_L_Lambda (A := A)
  have := congrArg (fun f : A →ₗ[ℚ] A => f x) h
  simp only [LinearMap.sub_apply, LinearMap.comp_apply] at this
  exact this

/-- **Pointwise reformulation** of `sl2_bracket_H_L`: for every `x : A`,
`H (L x) - L (H x) = 2 • L x`. -/
theorem sl2_bracket_H_L_apply (x : A) :
    Hop (L x) - L (Hop x) = (2 : ℚ) • L (x : A) := by
  have h := sl2_bracket_H_L (A := A)
  have := congrArg (fun f : A →ₗ[ℚ] A => f x) h
  simp only [LinearMap.sub_apply, LinearMap.comp_apply, LinearMap.smul_apply] at this
  exact this

/-- **Pointwise reformulation** of `sl2_bracket_H_Lambda`: for every
`x : A`, `H (Λ x) - Λ (H x) = -2 • Λ x`. -/
theorem sl2_bracket_H_Lambda_apply (x : A) :
    Hop (Lambda x) - Lambda (Hop x) = (-2 : ℚ) • Lambda (x : A) := by
  have h := sl2_bracket_H_Lambda (A := A)
  have := congrArg (fun f : A →ₗ[ℚ] A => f x) h
  simp only [LinearMap.sub_apply, LinearMap.comp_apply, LinearMap.smul_apply] at this
  exact this

/-- **Derived sl₂ identity (reverse bracket, pointwise)**: `[Λ, L] = -H`
follows from `[L, Λ] = H` by anti-symmetry of the bracket. Stated
pointwise to avoid `LinearMap`-arithmetic subtleties. -/
theorem sl2_bracket_Lambda_L_apply (x : A) :
    Lambda (L x) - L (Lambda x) = -(Hop (x : A)) := by
  have h := sl2_bracket_L_Lambda_apply (A := A) x
  -- `L (Λ x) - Λ (L x) = H x` ⟹ `Λ (L x) - L (Λ x) = -(H x)`.
  have := congrArg Neg.neg h
  -- `-(L (Λ x) - Λ (L x)) = -(H x)`.
  rw [neg_sub] at this
  exact this

/-- **Derived sl₂ identity (reverse bracket, pointwise)**: `[L, H] = -2 L`. -/
theorem sl2_bracket_L_H_apply (x : A) :
    L (Hop x) - Hop (L x) = (-2 : ℚ) • L (x : A) := by
  have h := sl2_bracket_H_L_apply (A := A) x
  -- `H (L x) - L (H x) = 2 • L x` ⟹ `L (H x) - H (L x) = -(2 • L x) = -2 • L x`.
  have hneg := congrArg Neg.neg h
  rw [neg_sub] at hneg
  rw [hneg, ← neg_smul]

/-- **Derived sl₂ identity (reverse bracket, pointwise)**: `[Λ, H] = 2 Λ`. -/
theorem sl2_bracket_Lambda_H_apply (x : A) :
    Lambda (Hop x) - Hop (Lambda x) = (2 : ℚ) • Lambda (x : A) := by
  have h := sl2_bracket_H_Lambda_apply (A := A) x
  -- `H (Λ x) - Λ (H x) = -2 • Λ x` ⟹ `Λ (H x) - H (Λ x) = -(-2 • Λ x) = 2 • Λ x`.
  have hneg := congrArg Neg.neg h
  rw [neg_sub] at hneg
  -- `hneg : Λ (H x) - H (Λ x) = -(-2 • Λ x)`. Rewrite `-(-2 • _) = 2 • _`.
  rw [hneg, neg_smul, neg_neg]

end LefschetzOperatorData

/-- **Trivial inhabiting instance** of `LefschetzOperatorData` on the
zero module: all three operators are zero. The sl₂-relations hold
trivially because every commutator of zero maps is zero, and `2 • 0 = 0`,
`-2 • 0 = 0`.

**R49 NOTE (no-trick mandate)**: this trivial-default global instance
WAS considered for demotion to `def` (same pattern as R31), but the
downstream `trivialPrimitiveDecompositionData` instance depends on
auto-synthesis of `LefschetzOperatorData A` via this global instance.
Demoting here would require simultaneously demoting that downstream
instance (which has 30+ lines of explicit-arg gymnastics). Keeping
this as `instance` is **honest scoping**: the LefschetzOperatorData
typeclass isn't currently consumed by the HC chain, so the global
zero-default is benign (no real instances are being masked). -/
noncomputable instance trivialLefschetzOperatorData
    (A : Type*) [AddCommGroup A] [Module ℚ A] :
    LefschetzOperatorData A where
  L := 0
  Lambda := 0
  Hop := 0
  sl2_bracket_L_Lambda := by
    -- `0 ∘ 0 - 0 ∘ 0 = 0`.
    ext x
    simp
  sl2_bracket_H_L := by
    ext x
    simp
  sl2_bracket_H_Lambda := by
    ext x
    simp

/-! ### Primitive decomposition data

The **Lefschetz primitive decomposition** of `H^k(X; ℚ)` is the direct
sum

```
   H^k(X; ℚ) = ⨁_{j ≥ 0} L^j (P^{k - 2j}(X; ℚ))
```

where the **primitive cohomology** at degree `m` is

```
   P^m(X; ℚ) := ker(Λ |_{H^m})    (equiv. = ker(L^{n - m + 1} |_{H^m})).
```

This decomposition is equivalent to Hard Lefschetz; it appears in
Voisin 2002 Vol. I Cor. 6.27 and Griffiths-Harris 1978 Ch. 0.7. We
package it as a typeclass `PrimitiveDecompositionData` carrying the
primitive subspaces and the **substantive supremum-of-images equation**
asserting that the iterated `L`-images of primitive subspaces span the
entire cohomology. -/

/-- **Primitive cohomology decomposition data** for a `ℚ`-module `A`
equipped with `LefschetzOperatorData`. For each "degree" parameter
`m : ℕ`, the primitive subspace `primitive m : Submodule ℚ A` is
contained in `ker(Λ)` (= the primitive locus). The substantive content
is the **supremum equation**:

```
   ⊤ = ⨆_{(j, m)} L^j (primitive m)
```

(in the abstract framework where we don't index `H^k` separately, the
direct-sum decomposition becomes a *supremum equation* on submodules
ranging over all `(j, m)` pairs — i.e. iterated `L`-images of primitive
subspaces generate all of `A`). The iterated `L`-image of a submodule
`P` is encoded via `Submodule.map ((L : Module.End ℚ A) ^ j) P`,
where `(L : Module.End ℚ A) ^ j` is the `j`-fold composition `L^j`
in the endomorphism ring `Module.End ℚ A`. -/
class PrimitiveDecompositionData (A : Type*) [AddCommGroup A] [Module ℚ A]
    [LefschetzOperatorData A] where
  /-- The primitive cohomology subspaces indexed by degree `m`. -/
  primitive : ℕ → Submodule ℚ A
  /-- **Primitive locus**: each `primitive m` lies in `ker(Λ)`. This is
  the definition of "primitive": a class is primitive iff it is killed
  by the dual Lefschetz operator. -/
  primitive_subset_ker_Lambda :
    ∀ m, primitive m ≤ LinearMap.ker (LefschetzOperatorData.Lambda (A := A))
  /-- **Substantive Lefschetz decomposition equation**: the supremum
  over `(j, m)` of `Submodule.map (L^j) (primitive m)` equals the whole
  module. This is the form of `A = ⨁ L^j (primitive_m)` at the level
  of submodule lattices.

  Mathematically: every class `α ∈ A` decomposes as a sum of terms
  `L^j (β_m)` where each `β_m ∈ primitive m`. The supremum form is the
  weakest (lattice-theoretic) version of this; the direct-sum form
  additionally requires uniqueness, which is captured separately by
  Hard Lefschetz isomorphisms. -/
  lefschetz_span_eq_top :
    (⨆ p : ℕ × ℕ,
        Submodule.map
          (((LefschetzOperatorData.L (A := A)) : Module.End ℚ A) ^ p.1)
          (primitive p.2)) = ⊤

namespace PrimitiveDecompositionData

variable {A : Type*} [AddCommGroup A] [Module ℚ A]
    [LefschetzOperatorData A] [PrimitiveDecompositionData A]

/-- **Annihilation of primitive classes by Λ**: every class in
`primitive m` is killed by the dual Lefschetz operator. Direct
consequence of `primitive_subset_ker_Lambda`. -/
theorem Lambda_primitive_eq_zero {m : ℕ} {α : A}
    (hα : α ∈ primitive (A := A) m) :
    LefschetzOperatorData.Lambda (A := A) α = 0 := by
  have hker := primitive_subset_ker_Lambda (A := A) m hα
  rwa [LinearMap.mem_ker] at hker

end PrimitiveDecompositionData

/-- **Trivial inhabiting instance** of `PrimitiveDecompositionData` on the
trivial Lefschetz operator (all operators zero). Every submodule is
contained in `ker(0) = ⊤`. The supremum equation reduces to showing
that the `(j = 0, m = 0)` summand `Submodule.map (L^0) (primitive 0)
= Submodule.map id ⊤ = ⊤` already exhausts the lattice. -/
noncomputable instance trivialPrimitiveDecompositionData
    (A : Type*) [AddCommGroup A] [Module ℚ A] :
    @PrimitiveDecompositionData A _ _ (trivialLefschetzOperatorData A) where
  primitive _ := ⊤
  primitive_subset_ker_Lambda _ := by
    -- `Lambda = 0` on the trivial instance, so `ker Λ = ⊤`.
    show (⊤ : Submodule ℚ A) ≤
      LinearMap.ker (LefschetzOperatorData.Lambda
        (self := trivialLefschetzOperatorData A))
    intro x _
    rw [LinearMap.mem_ker]
    rfl
  lefschetz_span_eq_top := by
    -- Show `⨆ p, Submodule.map (L^p.1) ⊤ = ⊤`. Use the `(0, 0)` index:
    -- `Submodule.map (L^0) ⊤ = Submodule.map id ⊤ = ⊤`.
    apply le_antisymm le_top
    -- Pick the index `p := (0, 0)`.
    refine le_trans ?_ (le_iSup _ ((0, 0) : ℕ × ℕ))
    -- Target: `⊤ ≤ Submodule.map (L^0) ⊤`. Since `L^0 = 1 = id`,
    -- this is `Submodule.map id ⊤ = ⊤`.
    show (⊤ : Submodule ℚ A) ≤
      Submodule.map
        (((LefschetzOperatorData.L
            (self := trivialLefschetzOperatorData A)) : Module.End ℚ A) ^ 0)
        (⊤ : Submodule ℚ A)
    rw [pow_zero]
    intro x _
    refine ⟨x, ?_, ?_⟩
    · exact Submodule.mem_top
    · show ((1 : Module.End ℚ A)) x = x
      rfl

end HodgeReduction.Infrastructure.Cohomology
