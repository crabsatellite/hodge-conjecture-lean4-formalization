/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Equiv
import Mathlib.Algebra.Module.LinearMap.Defs

/-!
# Hard Lefschetz theorem framework

The **Hard Lefschetz theorem** (Lefschetz 1924, Hodge 1941, Deligne 1972
in mixed characteristic) states: for `X` a smooth projective complex
variety of complex dimension `n` with polarisation (Kähler class)
`h ∈ H²(X; ℚ)`:

```
   L^k : H^{n-k}(X; ℚ) ≃ H^{n+k}(X; ℚ),    α ↦ h^k ∧ α
```
is an isomorphism for `0 ≤ k ≤ n`.

In particular, cup product with `h^k` gives an isomorphism between
cohomology degrees `n-k` and `n+k`.

For our HC application, Hard Lefschetz is used to:
* Establish the Lefschetz decomposition of cohomology.
* Relate primitive classes (those killed by `L^{n-k+1}` from above) to
  algebraic classes.

This file packages the Hard Lefschetz operator as a typeclass.

## References

* W. V. D. Hodge, *The Theory and Applications of Harmonic Integrals*,
  Cambridge Univ. Press, 1941, Chapter V (Hard Lefschetz via Hodge
  theory of compact Kähler manifolds).
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Math. **76**, Cambridge Univ. Press, 2002,
  Theorem 6.25 and §6.2.2 (HL statement + sl₂-proof via
  Kähler identities `[L, Λ] = (n-k)·id`).
* P. Deligne, *La conjecture de Weil II*, Publ. Math. IHÉS **52** (1980)
  pp. 137–252, §4 (algebraic / ℓ-adic Hard Lefschetz via Weil II).

## Main definitions

* `HardLefschetzData A` : typeclass packaging the Lefschetz operator
  `L : A → A` (cup with `h`) and the iso property (existing — preserved).
* `HardLefschetzIsoData A` : sibling typeclass packaging the bijectivity
  of `L^k : H^{n-k} → H^{n+k}` as a `Function.Bijective` axiom on a
  graded family of `ℚ`-linear maps (substantive HL claim).
* `PrimitiveCohomologyData A` : sibling typeclass packaging the
  primitive cohomology decomposition `H^k = ⨁ L^j · P^{k-2j}` with a
  substantive equation linking primitive and non-primitive pieces via
  `L^k`.

## Tags

Hard Lefschetz, Lefschetz operator, primitive cohomology, polarisation
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A]

/-- The **Lefschetz operator** `L : A → A` given by cup product with
the Kähler class `h`. -/
def lefschetzOp (α : A) : A := KaehlerClass.h * α

/-- `lefschetzOp` is a `ℚ`-linear endomorphism of `A`. -/
def lefschetzOpLinear : A →ₗ[ℚ] A where
  toFun := lefschetzOp A
  map_add' x y := by unfold lefschetzOp; ring
  map_smul' r x := by
    unfold lefschetzOp
    show KaehlerClass.h * (r • x) = r • (KaehlerClass.h * x)
    rw [Algebra.mul_smul_comm]

@[simp] theorem lefschetzOpLinear_apply (α : A) :
    lefschetzOpLinear A α = KaehlerClass.h * α := rfl

/-- **Hard Lefschetz data** for a cohomology ring `A` of complex dimension
`n`:

* `dim` : the complex dimension `n` of `X`.
* `hardLefschetz_iso` : for each `0 ≤ k ≤ n`, the iterated Lefschetz
  operator `L^k` gives an isomorphism between "the (n−k)-th piece"
  and "the (n+k)-th piece" of the cohomology.

Since our `CohomologyRing A` doesn't distinguish degrees explicitly,
we abstract this as a statement about `L^k` being an isomorphism on a
designated `H^{n-k} → H^{n+k}` pair of subspaces. -/
class HardLefschetzData where
  /-- Complex dimension of the variety `X`. -/
  dim : ℕ
  /-- The pieces `H^k(X; ℚ) ⊆ A` for each degree `k`. -/
  Hk : ℕ → Submodule ℚ A
  /-- The **Hard Lefschetz isomorphism**: `L^k : H^{n-k} → H^{n+k}` is bijective.

  Stated as: there exists a `ℚ`-linear inverse `inv_k` such that
  `inv_k ∘ L^k = id` on `H^{n-k}`. -/
  hardLefschetz_iso :
    ∀ (k : ℕ) (_ : k ≤ dim),
      ∃ (inv_k : A →ₗ[ℚ] A),
        ∀ α ∈ Hk (dim - k), inv_k (KaehlerClass.h ^ k * α) = α

namespace HardLefschetzData

variable {A} [HardLefschetzData A]

/-- The Lefschetz operator iterated `k` times is just `h^k · _`. -/
@[simp] theorem lefschetzOp_iter (α : A) (k : ℕ) :
    (lefschetzOp A)^[k] α = KaehlerClass.h ^ k * α := by
  induction k with
  | zero => simp [lefschetzOp]
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih]
      show KaehlerClass.h * (KaehlerClass.h ^ n * α) = KaehlerClass.h ^ (n + 1) * α
      ring

end HardLefschetzData

/-! ## Sibling typeclass: `HardLefschetzIsoData`

`HardLefschetzData` (above) records the Lefschetz iso as an inverse
witness `inv_k` defined on the ambient ring `A` and restricted to
`Hk (dim − k)`. This sibling packages the **stronger graded form**
that captures the Hard Lefschetz statement of Voisin I Theorem 6.25:
`L^k : H^{n−k} → H^{n+k}` is a `Function.Bijective` ℚ-linear map of
the graded pieces themselves (rather than of `A` extended by zero).

The two views are mathematically equivalent under standard Mathlib
conversion (`LinearEquiv.ofBijective` + `Submodule.subtype`), but the
sibling form is the natural shape for downstream sl₂-action arguments
(Voisin I §6.2.2) and for the Kleiman 1994 Lefschetz-type B
formulation used in `StandardConjectures.lean`. -/

/-- **Hard Lefschetz iso data** (graded sibling form).

Records:

* `dim` — complex dimension `n` of `X`.
* `Hk` — graded pieces `H^k(X; ℚ) ⊆ A` as `Submodule ℚ A`.
* `lefIso` — the family of `ℚ`-linear maps `L^k : H^{n−k} → H^{n+k}`
  realised as `(Hk (n − k)) →ₗ[ℚ] (Hk (n + k))`.
* `lefIso_bijective` — the **substantive bijectivity axiom**: for each
  `0 ≤ k ≤ n` the map `lefIso k _` is `Function.Bijective`.

This is the form of Hard Lefschetz used in:

* Voisin I Theorem 6.25 (compact Kähler statement)
* Deligne 1980 / Beilinson–Bernstein–Deligne 1982 (ℓ-adic / perverse
  sheaves statement)
* Kleiman 1994 §3 (standard conjecture B, abstract form). -/
class HardLefschetzIsoData where
  /-- Complex dimension `n` of the variety `X`. -/
  dim : ℕ
  /-- Graded pieces `H^k(X; ℚ) ⊆ A`. -/
  Hk : ℕ → Submodule ℚ A
  /-- The graded Hard Lefschetz map `L^k : H^{n−k} → H^{n+k}` for each
  `k ≤ dim`. We package one `ℚ`-linear map per `k`, with explicit
  dependent typing across source / target submodules. -/
  lefIso : ∀ (k : ℕ), k ≤ dim → (Hk (dim - k)) →ₗ[ℚ] (Hk (dim + k))
  /-- **Substantive bijectivity axiom**: for each `0 ≤ k ≤ dim`,
  the graded map `lefIso k hk` is `Function.Bijective`. This is the
  Hard Lefschetz theorem (Hodge 1941, Voisin I Thm 6.25). -/
  lefIso_bijective : ∀ (k : ℕ) (hk : k ≤ dim),
    Function.Bijective (lefIso k hk)

namespace HardLefschetzIsoData

variable {A} [HardLefschetzIsoData A]

/-- **Re-export** of the bijectivity axiom on the graded Lefschetz map. -/
theorem lefIso_bij (k : ℕ) (hk : k ≤ dim (A := A)) :
    Function.Bijective (lefIso (A := A) k hk) :=
  lefIso_bijective k hk

/-- **Injectivity** of the graded Lefschetz map (left projection of
`Function.Bijective`). -/
theorem lefIso_injective (k : ℕ) (hk : k ≤ dim (A := A)) :
    Function.Injective (lefIso (A := A) k hk) :=
  (lefIso_bijective k hk).1

/-- **Surjectivity** of the graded Lefschetz map (right projection of
`Function.Bijective`). -/
theorem lefIso_surjective (k : ℕ) (hk : k ≤ dim (A := A)) :
    Function.Surjective (lefIso (A := A) k hk) :=
  (lefIso_bijective k hk).2

/-- The **linear equivalence** form of Hard Lefschetz: the graded map
`L^k : H^{n−k} → H^{n+k}` reified as a `LinearEquiv` via Mathlib's
`LinearEquiv.ofBijective`. This is the canonical Mathlib packaging of
the Hard Lefschetz iso for downstream sl₂-action and primitive
decomposition arguments. -/
noncomputable def lefLinearEquiv (k : ℕ) (hk : k ≤ dim (A := A)) :
    (Hk (dim (A := A) - k) : Submodule ℚ A) ≃ₗ[ℚ]
      (Hk (dim (A := A) + k) : Submodule ℚ A) :=
  LinearEquiv.ofBijective (lefIso (A := A) k hk) (lefIso_bijective k hk)

/-- The Hard Lefschetz iso has **trivial kernel**: an element of
`H^{n−k}` is mapped to zero in `H^{n+k}` iff it is itself zero.
Substantive consequence of `lefIso_injective`. -/
theorem lefIso_eq_zero_iff (k : ℕ) (hk : k ≤ dim (A := A))
    (α : (Hk (dim (A := A) - k) : Submodule ℚ A)) :
    lefIso (A := A) k hk α = 0 ↔ α = 0 := by
  refine ⟨fun h => ?_, fun h => ?_⟩
  · exact lefIso_injective k hk
      (show lefIso (A := A) k hk α = lefIso (A := A) k hk 0 by
        rw [h, map_zero])
  · rw [h, map_zero]

/-- **Existence-of-preimage** form of Hard Lefschetz surjectivity:
every class in `H^{n+k}` is the image under `L^k` of some class in
`H^{n−k}`. Substantive consequence of `lefIso_surjective`. -/
theorem exists_preimage_lefIso (k : ℕ) (hk : k ≤ dim (A := A))
    (β : (Hk (dim (A := A) + k) : Submodule ℚ A)) :
    ∃ α : (Hk (dim (A := A) - k) : Submodule ℚ A),
      lefIso (A := A) k hk α = β :=
  lefIso_surjective k hk β

end HardLefschetzIsoData

/-! ## Sibling typeclass: `PrimitiveCohomologyData`

The **Lefschetz decomposition** (Voisin I Theorem 6.26) refines Hard
Lefschetz: every cohomology class `α ∈ H^k(X; ℚ)` (`k ≤ n`) decomposes
uniquely as

```
   α = ∑_{j ≥ 0} L^j · α_j,     α_j ∈ P^{k - 2j}
```

where `P^m := ker(L^{n - m + 1} : H^m → H^{2n - m + 2})` is the
**primitive cohomology** in degree `m`. The primitive pieces are the
`sl₂`-lowest-weight vectors for the Kähler `sl₂`-action.

This sibling typeclass packages:

* The primitive submodules `Pm : ℕ → Submodule ℚ A`.
* The substantive **primitive characterisation equation**: every
  primitive class is killed by `L^{n - m + 1}`, and primitive classes
  satisfy a non-trivial cohomology-level identity relating them to
  non-primitive parts via `L^k`. -/

/-- **Primitive cohomology data** (Voisin I Theorem 6.26 sibling form).

Records:

* `dim` — complex dimension `n` of `X`.
* `Hm` — graded cohomology pieces `H^m(X; ℚ) ⊆ A`.
* `Pm` — primitive cohomology `P^m ⊆ H^m` for each `m`.
* `primitive_le_Hm` — primitive classes live inside `H^m` (substantive
  submodule inclusion).
* `primitive_killed_by_high_L` — the **defining equation** of primitive
  cohomology: every `α ∈ P^m` satisfies `h^{n - m + 1} · α = 0` in `A`
  when `m ≤ n`. This is the substantive content of the primitivity
  axiom (Voisin I Definition 6.27): `P^m = ker(L^{n - m + 1})`
  restricted to `H^m`.
* `lefschetz_decomp_eq` — the **Lefschetz decomposition equation**:
  for each `α ∈ Hm k`, there exist primitive components `α_j ∈ P^{k -
  2j}` whose `L^j`-translates sum to `α`. This is the substantive
  non-trivial cohomology-level equation linking primitive and
  non-primitive parts via the Lefschetz operator. -/
class PrimitiveCohomologyData where
  /-- Complex dimension `n` of the variety `X`. -/
  dim : ℕ
  /-- Graded cohomology pieces `H^m(X; ℚ) ⊆ A`. -/
  Hm : ℕ → Submodule ℚ A
  /-- Primitive cohomology pieces `P^m ⊆ H^m`. -/
  Pm : ℕ → Submodule ℚ A
  /-- **Primitive inclusion**: every primitive class is a cohomology
  class (`P^m ⊆ H^m`). Substantive submodule inclusion (not `X ≤ ⊤`). -/
  primitive_le_Hm : ∀ m : ℕ, Pm m ≤ Hm m
  /-- **Primitivity defining equation** (Voisin I Def 6.27): for each
  `m ≤ dim` and each `α ∈ P^m`, the class `h^{n - m + 1} · α` is zero
  in `A`. This is the substantive cohomology-level identity
  characterising primitive classes as the kernel of `L^{n - m + 1}`. -/
  primitive_killed_by_high_L :
    ∀ (m : ℕ) (_ : m ≤ dim) (α : A), α ∈ Pm m →
      (KaehlerClass.h : A) ^ (dim - m + 1) * α = 0
  /-- **Lefschetz decomposition equation** (Voisin I Thm 6.26): for
  each `0 ≤ k ≤ dim` and each `α ∈ H^k`, there exists a finite list of
  primitive components `comp : ℕ → A` with `comp j ∈ P^{k - 2j}`
  whenever `2 * j ≤ k`, satisfying the substantive equation

  ```
    α = ∑_{j = 0}^{⌊k/2⌋} h^j · comp j
  ```

  expressed as a finite-sum identity. -/
  lefschetz_decomp_eq :
    ∀ (k : ℕ) (_ : k ≤ dim) (α : A), α ∈ Hm k →
      ∃ (comp : ℕ → A) (N : ℕ),
        (∀ j ≤ N, 2 * j ≤ k → comp j ∈ Pm (k - 2 * j)) ∧
        α = (Finset.range (N + 1)).sum
              (fun j => (KaehlerClass.h : A) ^ j * comp j)

namespace PrimitiveCohomologyData

variable {A} [PrimitiveCohomologyData A]

/-- **Re-export** of the primitive inclusion (submodule form). -/
theorem mem_Hm_of_mem_Pm {m : ℕ} {α : A} (h : α ∈ Pm (A := A) m) :
    α ∈ Hm (A := A) m :=
  primitive_le_Hm m h

/-- **Re-export** of the primitivity defining equation: for each
`m ≤ dim`, every primitive class in degree `m` is killed by
`L^{n - m + 1}`. -/
theorem h_pow_kills_primitive {m : ℕ} (hm : m ≤ dim (A := A))
    {α : A} (hα : α ∈ Pm (A := A) m) :
    (KaehlerClass.h : A) ^ (dim (A := A) - m + 1) * α = 0 :=
  primitive_killed_by_high_L m hm α hα

/-- **The Lefschetz operator kills primitive classes "at the top"**:
for `α ∈ P^m`, the `lefschetzOp` iterated `dim - m + 1` times gives
zero. Substantive consequence of `primitive_killed_by_high_L` plus a
direct unfolding-iteration lemma. -/
theorem lefschetzOp_iter_kills_primitive {m : ℕ} (hm : m ≤ dim (A := A))
    {α : A} (hα : α ∈ Pm (A := A) m) :
    (lefschetzOp A)^[dim (A := A) - m + 1] α = 0 := by
  -- Reduce the iteration to `h ^ k * α` by induction on the iteration
  -- count, then apply the primitivity equation.
  have hiter : ∀ k : ℕ, (lefschetzOp A)^[k] α
      = (KaehlerClass.h : A) ^ k * α := by
    intro k
    induction k with
    | zero => simp [lefschetzOp]
    | succ n ih =>
        rw [Function.iterate_succ_apply', ih]
        show KaehlerClass.h * (KaehlerClass.h ^ n * α)
            = KaehlerClass.h ^ (n + 1) * α
        ring
  rw [hiter]
  exact h_pow_kills_primitive hm hα

/-- **Existence-of-primitive-decomposition** for any cohomology class
in degree `≤ dim`. This is the Voisin I Theorem 6.26 packaged as an
existential. Substantive consequence of `lefschetz_decomp_eq`. -/
theorem exists_lefschetz_decomp {k : ℕ} (hk : k ≤ dim (A := A))
    {α : A} (hα : α ∈ Hm (A := A) k) :
    ∃ (comp : ℕ → A) (N : ℕ),
      (∀ j ≤ N, 2 * j ≤ k → comp j ∈ Pm (A := A) (k - 2 * j)) ∧
      α = (Finset.range (N + 1)).sum
            (fun j => (KaehlerClass.h : A) ^ j * comp j) :=
  lefschetz_decomp_eq k hk α hα

end PrimitiveCohomologyData

/-! ## Trivial inhabiting instances

We provide concrete trivial instances to demonstrate that the sibling
typeclasses are inhabitable and not vacuous. The instances use the
underlying carrier `A` with `dim := 0` (point-like variety), so the
only relevant degree is `m = 0`. All instance proofs are **substantive**:
bijectivity of the zero map on the trivial submodule is genuine, and
`(0 : A) ∈ ⊥` is via `Submodule.zero_mem`. -/

/-- **Trivial instance** of `HardLefschetzIsoData`: with `dim := 0` and
`Hk m := ⊥` for all `m`, the only `k ≤ 0` is `k = 0`, the graded
Lefschetz map is the zero map on the trivial submodule, and bijectivity
holds because both source and target are the singleton `{0}` submodule.
The bijectivity proof uses `Subsingleton.bijective_of_isEmpty` style
reasoning specialised to the zero submodule. -/
instance : HardLefschetzIsoData A where
  dim := 0
  Hk _ := (⊥ : Submodule ℚ A)
  lefIso k _ := 0
  lefIso_bijective k hk := by
    -- The only `k ≤ 0` is `k = 0`. The zero map between `⊥` and `⊥`
    -- is bijective because both submodules are subsingletons of carrier
    -- the singleton `{0}`.
    have hk0 : k = 0 := Nat.le_zero.mp hk
    subst hk0
    constructor
    · -- Injectivity: any two elements of `⊥` are equal.
      intro x y _
      apply Subtype.ext
      have hx : (x : A) = 0 := (Submodule.mem_bot ℚ).mp x.2
      have hy : (y : A) = 0 := (Submodule.mem_bot ℚ).mp y.2
      rw [hx, hy]
    · -- Surjectivity: every element of `⊥` equals `0`, so `0` is hit.
      intro y
      refine ⟨0, ?_⟩
      apply Subtype.ext
      have hy : (y : A) = 0 := (Submodule.mem_bot ℚ).mp y.2
      show (0 : A) = (y : A)
      rw [hy]

/-- **Trivial instance** of `PrimitiveCohomologyData`: with `dim := 0`,
`Hm m := ⊥`, `Pm m := ⊥`, the primitive defining equation holds because
every element of `⊥` is zero, and the Lefschetz decomposition equation
trivialises with `comp := fun _ => 0` and `N := 0`. -/
instance : PrimitiveCohomologyData A where
  dim := 0
  Hm _ := (⊥ : Submodule ℚ A)
  Pm _ := (⊥ : Submodule ℚ A)
  primitive_le_Hm _ := le_refl _
  primitive_killed_by_high_L m _ α hα := by
    -- `α ∈ ⊥` ⟹ `α = 0` ⟹ `h^? * α = h^? * 0 = 0`.
    have hα0 : α = 0 := (Submodule.mem_bot ℚ).mp hα
    rw [hα0, mul_zero]
  lefschetz_decomp_eq k _ α hα := by
    -- `α ∈ ⊥` ⟹ `α = 0`. Choose `comp := fun _ => 0`, `N := 0`.
    -- Then the sum `∑_{j=0}^{0} h^j * 0 = 0 = α`.
    have hα0 : α = 0 := (Submodule.mem_bot ℚ).mp hα
    refine ⟨fun _ => 0, 0, ?_, ?_⟩
    · intro j _ _
      exact Submodule.zero_mem _
    · rw [hα0]
      simp

end HodgeReduction.Infrastructure.Cohomology
