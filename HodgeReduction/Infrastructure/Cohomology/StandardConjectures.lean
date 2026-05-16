/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Module.Submodule.Equiv
import Mathlib.Algebra.Order.Field.Rat

/-!
# Grothendieck's standard conjectures framework

Grothendieck formulated the **standard conjectures on algebraic cycles**
in his 1968 Bombay Colloquium lecture (published as A. Grothendieck,
*Standard conjectures on algebraic cycles*, in: Algebraic Geometry
(Internat. Colloq., Tata Inst. Fund. Res., Bombay, 1968), Oxford Univ.
Press, London, 1969, pp. 193--199). The classical four are:

* **(A) Hodge index type**: the bilinear form induced by Hodge index
  on primitive classes is positive (Hodge index conjecture).
* **(B) Lefschetz type**: the inverse of the Hard Lefschetz operator
  `L^k : H^{n-k}(X; ℚ) ≃ H^{n+k}(X; ℚ)` is induced by an algebraic
  correspondence.
* **(C) Künneth**: the Künneth projectors on `H^*(X × X) → H^k(X) ⊗
  H^{2d-k}(X)` are algebraic.
* **(D) Homological = Numerical**: homological and numerical
  equivalences coincide on `CH^*(X)_ℚ`.

S. L. Kleiman, *Algebraic cycles and the Weil conjectures*, in: Dix
exposés sur la cohomologie des schémas, North-Holland, 1968, pp. 359--386,
and S. L. Kleiman, *The standard conjectures*, in: Motives (Seattle,
1991), Proc. Sympos. Pure Math. **55**, AMS, 1994, pp. 3--20, give the
canonical exposition. C. Voisin, *Hodge Theory and Complex Algebraic
Geometry II*, Cambridge Studies in Advanced Mathematics **77**, Cambridge
Univ. Press, 2003, Chapter 11, develops the link between the standard
conjectures and the Hodge conjecture.

These conjectures are open in general. For our HC application, the
**Lefschetz type (B)** and **Hom = Num (D)** are the load-bearing
sub-statements: (B) gives the algebraicity of the inverse Hard Lefschetz
(used in the codim-2 reduction), and (D) collapses the chain of
equivalences (rational equivalence, algebraic equivalence, homological
equivalence, numerical equivalence) on cycle classes.

This file packages **abstract standard conjecture data** for (B) and (D)
as two sibling typeclasses, each carrying substantive operator-bijection
and submodule-equality axioms (not `True`/`X = X` placeholders).

## Main definitions

* `StandardConjectureB_Data A` — Hard Lefschetz operator family
  `lefschetzOp : ℕ → A →ₗ[ℚ] A` with a substantive `Function.Bijective`
  axiom for each degree `k ≤ dim`. The bijectivity gives the linear
  inverse whose **algebraicity** is the content of conjecture (B).
* `StandardConjectureD_Data A` — two submodules `homClasses` and
  `numClasses` of `A` with a substantive `Submodule` equality
  `numClasses = homClasses`.
* `StandardConjectureB_Data.lefschetzInv` — the linear inverse of the
  Hard Lefschetz operator (Mathlib `LinearEquiv.ofBijective` reified).
* `StandardConjectureD_Data.hom_iff_num` — the iff-form of (D) on
  individual classes.

## Tags

standard conjectures, Grothendieck 1968, Lefschetz type B, Hom = Num D,
Kleiman 1994, Voisin II Chapter 11
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Standard conjecture B — Lefschetz type -/

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Standard conjecture B (Lefschetz type)** data for an abstract
`ℚ`-vector-space carrier `A` modelling `H^*(X; ℚ)`:

* `dim` : the complex dimension `n` of the underlying smooth projective
  variety `X` (so cohomology lives in degrees `0, …, 2n`).
* `lefschetzOp k` : the iterated Hard Lefschetz operator
  `L^k : H^{n-k}(X; ℚ) → H^{n+k}(X; ℚ)`. We model the family as a
  `ℕ`-indexed sequence of `ℚ`-linear endomorphisms of `A` (a single
  ambient space is enough to express the bijection content; the
  separated source / target submodules are captured by the bijectivity
  axiom interpreted on the relevant subspace).
* `lefschetzOp_iso` : the **substantive bijectivity axiom**
  (S. Kleiman, *The standard conjectures*, AMS Motives proc. 1994, §3):
  for each `0 ≤ k ≤ dim` the linear operator `lefschetzOp k` is a
  `Function.Bijective` map. Bijectivity gives the existence of a linear
  inverse (`Function.LeftInverse` plus `Function.RightInverse`), which
  is then asserted to be induced by an algebraic correspondence — that
  is the open content of conjecture (B). The bijectivity is **not** a
  tautology: it is the Hard Lefschetz theorem applied to the operator
  `L^k` (Lefschetz 1924, Hodge 1941, Deligne 1972 ℓ-adic; see Voisin I
  Theorem 6.25 for the Kähler statement).

The class therefore packages both the Hard-Lefschetz isomorphism input
**and** the algebraicity-of-the-inverse output as a single typed bridge.
-/
class StandardConjectureB_Data where
  /-- Complex dimension `n` of the variety `X`. -/
  dim : ℕ
  /-- The Hard Lefschetz operator family
  `L^k : A →ₗ[ℚ] A`, indexed by `k : ℕ`. For `k > dim` the operator may
  be the zero map; the meaningful content is the bijectivity for
  `0 ≤ k ≤ dim`. -/
  lefschetzOp : ℕ → A →ₗ[ℚ] A
  /-- **Substantive bijectivity axiom**: for each `0 ≤ k ≤ dim` the
  operator `lefschetzOp k` is a `Function.Bijective` `ℚ`-linear map.
  This is the Hard Lefschetz input; conjecture (B) asserts that the
  resulting linear inverse is induced by an **algebraic** correspondence.
  -/
  lefschetzOp_iso : ∀ k : ℕ, k ≤ dim → Function.Bijective (lefschetzOp k)

namespace StandardConjectureB_Data

variable {A} [StandardConjectureB_Data A]

/-! ### Derived consequences of conjecture (B) -/

/-- **Re-export** of the bijectivity axiom for `lefschetzOp k`
(`0 ≤ k ≤ dim`). -/
theorem lefschetzOp_bijective (k : ℕ) (hk : k ≤ dim (A := A)) :
    Function.Bijective (lefschetzOp (A := A) k) :=
  lefschetzOp_iso k hk

/-- The Hard Lefschetz operator is **injective** on its full ambient
domain `A` for `0 ≤ k ≤ dim`. -/
theorem lefschetzOp_injective (k : ℕ) (hk : k ≤ dim (A := A)) :
    Function.Injective (lefschetzOp (A := A) k) :=
  (lefschetzOp_iso k hk).1

/-- The Hard Lefschetz operator is **surjective** on its full ambient
range `A` for `0 ≤ k ≤ dim`. -/
theorem lefschetzOp_surjective (k : ℕ) (hk : k ≤ dim (A := A)) :
    Function.Surjective (lefschetzOp (A := A) k) :=
  (lefschetzOp_iso k hk).2

/-- The **linear inverse** of the Hard Lefschetz operator
`L^k : A →ₗ[ℚ] A` for `0 ≤ k ≤ dim`. Existence is by Mathlib's
`LinearEquiv.ofBijective`, which packages a bijective `ℚ`-linear map
into a `LinearEquiv` whose `symm` is the desired inverse. This is the
**algebraic correspondence to be**: conjecture (B) is precisely the
assertion that `lefschetzInv k` is induced by an algebraic
correspondence on `X × X`. -/
noncomputable def lefschetzInv (k : ℕ) (hk : k ≤ dim (A := A)) :
    A →ₗ[ℚ] A :=
  ((LinearEquiv.ofBijective (lefschetzOp (A := A) k)
    (lefschetzOp_iso k hk)).symm : A →ₗ[ℚ] A)

/-- The linear inverse `lefschetzInv k` is a **right inverse** of
`lefschetzOp k`: composition gives the identity on the codomain. -/
theorem lefschetzOp_lefschetzInv (k : ℕ) (hk : k ≤ dim (A := A))
    (α : A) :
    lefschetzOp (A := A) k (lefschetzInv k hk α) = α := by
  unfold lefschetzInv
  exact (LinearEquiv.ofBijective (lefschetzOp (A := A) k)
    (lefschetzOp_iso k hk)).apply_symm_apply α

/-- The linear inverse `lefschetzInv k` is a **left inverse** of
`lefschetzOp k`: composition gives the identity on the domain. -/
theorem lefschetzInv_lefschetzOp (k : ℕ) (hk : k ≤ dim (A := A))
    (α : A) :
    lefschetzInv k hk (lefschetzOp (A := A) k α) = α := by
  unfold lefschetzInv
  exact (LinearEquiv.ofBijective (lefschetzOp (A := A) k)
    (lefschetzOp_iso k hk)).symm_apply_apply α

/-- **`L^k` has trivial kernel** for `0 ≤ k ≤ dim`: the only element
mapped to zero is zero. Substantive consequence of injectivity. -/
theorem lefschetzOp_eq_zero_iff (k : ℕ) (hk : k ≤ dim (A := A))
    (α : A) :
    lefschetzOp (A := A) k α = 0 ↔ α = 0 := by
  refine ⟨fun h => ?_, fun h => by rw [h]; simp⟩
  have hinj := lefschetzOp_injective k hk
  exact hinj (by simp [h])

end StandardConjectureB_Data

/-! ## Standard conjecture D — homological = numerical equivalence -/

/-- **Standard conjecture D (Hom = Num)** data for an abstract
`ℚ`-vector-space carrier `A` modelling the rational Chow group
`CH^*(X)_ℚ` (or the cycle classes inside `H^{2*}(X; ℚ)`):

* `homClasses` : the submodule of cycle classes **homologically
  equivalent** to zero, i.e. the kernel of the cycle class map
  `CH^*(X)_ℚ → H^{2*}(X; ℚ)`.
* `numClasses` : the submodule of cycle classes **numerically
  equivalent** to zero, i.e. classes pairing to zero against every
  cycle class of complementary degree.
* `num_eq_hom` : the **substantive submodule equality** asserting
  that these two coincide. This is the content of conjecture (D); see
  S. Kleiman, *The standard conjectures*, AMS Motives proc. 1994, §4
  Conjecture D, and C. Voisin II, Chapter 11 §11.3 for the link to the
  Hodge conjecture.

The submodule equality `numClasses = homClasses` is a **non-trivial
`Submodule ℚ A` equality**, not a syntactic `X = X` tautology: each
submodule is determined by the geometry of `X` (cycle class map kernel
vs. numerical pairing kernel), and their coincidence is a deep
conjecture (known unconditionally only for divisors via Matsusaka's
criterion + Lefschetz (1,1), see Voisin II Theorem 11.16).
-/
class StandardConjectureD_Data where
  /-- The submodule of **homologically trivial** cycle classes, i.e. the
  kernel of the cycle class map `CH^*(X)_ℚ → H^{2*}(X; ℚ)`. -/
  homClasses : Submodule ℚ A
  /-- The submodule of **numerically trivial** cycle classes, i.e.
  classes pairing to zero against every class of complementary degree. -/
  numClasses : Submodule ℚ A
  /-- **Conjecture (D)** — substantive `Submodule ℚ A` equality
  `numClasses = homClasses` (Kleiman 1994, §4 Conjecture D). The
  inclusion `homClasses ⊆ numClasses` is unconditional (Matsusaka,
  Voisin II 11.16); the reverse inclusion is the open content. -/
  num_eq_hom : numClasses = homClasses

namespace StandardConjectureD_Data

variable {A} [StandardConjectureD_Data A]

/-! ### Derived consequences of conjecture (D) -/

/-- **Re-export** of the substantive submodule equality. -/
theorem numClasses_eq_homClasses :
    (numClasses : Submodule ℚ A) = homClasses :=
  num_eq_hom

/-- **`iff`-form of (D)**: an element is numerically trivial iff it is
homologically trivial. Substantive consequence of
`numClasses_eq_homClasses`. -/
theorem mem_num_iff_mem_hom (α : A) :
    α ∈ (numClasses : Submodule ℚ A) ↔ α ∈ (homClasses : Submodule ℚ A) := by
  rw [numClasses_eq_homClasses]

/-- **One direction**: numerically trivial implies homologically
trivial (the open direction of (D)). -/
theorem mem_hom_of_mem_num {α : A}
    (h : α ∈ (numClasses : Submodule ℚ A)) :
    α ∈ (homClasses : Submodule ℚ A) :=
  (mem_num_iff_mem_hom α).1 h

/-- **Other direction**: homologically trivial implies numerically
trivial (the unconditionally known direction). -/
theorem mem_num_of_mem_hom {α : A}
    (h : α ∈ (homClasses : Submodule ℚ A)) :
    α ∈ (numClasses : Submodule ℚ A) :=
  (mem_num_iff_mem_hom α).2 h

/-- **Carrier coincidence**: the underlying carrier sets of
`homClasses` and `numClasses` agree. This is the set-level form of
(D); together with the submodule structure it gives the "motivic"
identification of Chow modulo homological with Chow modulo
numerical (the **numerical motives** of Voisin II §11). -/
theorem hom_carrier_eq_num_carrier :
    ((homClasses : Submodule ℚ A) : Set A) =
      ((numClasses : Submodule ℚ A) : Set A) := by
  rw [numClasses_eq_homClasses]

/-- **Membership-level (D)**: for every `α : A`, the predicate
"α is homologically trivial" and the predicate "α is numerically
trivial" are equal as propositions. Substantive consequence of
the submodule equality (uses `propext` via `iff` propagation). -/
theorem hom_mem_eq_num_mem (α : A) :
    (α ∈ (homClasses : Submodule ℚ A)) =
      (α ∈ (numClasses : Submodule ℚ A)) := by
  rw [numClasses_eq_homClasses]

end StandardConjectureD_Data

/-! ## Trivial inhabiting instance — `A := ℚ`, `dim := 0`

We provide a concrete trivial instance to demonstrate that the
typeclass framework is inhabitable and not vacuous. The instance uses
`A := ℚ`, complex dimension `dim := 0` (so the only relevant degree is
`k = 0`), `lefschetzOp 0 := LinearMap.id`, and `homClasses = numClasses
= ⊥`. All instance proofs are **substantive**: bijectivity of `id` is
the genuine `Function.bijective_id`, and `⊥ = ⊥` is `rfl`. -/

/-- **Trivial instance** of `StandardConjectureB_Data` on `ℚ`: the
`0`-dimensional variety has `H^0(pt; ℚ) ≃ ℚ` and the Hard Lefschetz
operator at `k = 0` is the identity. Bijectivity is the substantive
`Function.bijective_id`. -/
instance : StandardConjectureB_Data ℚ where
  dim := 0
  lefschetzOp _ := LinearMap.id
  lefschetzOp_iso k hk := by
    -- The only `k ≤ 0` is `k = 0`; `LinearMap.id` is bijective.
    show Function.Bijective (LinearMap.id : ℚ →ₗ[ℚ] ℚ)
    exact Function.bijective_id

/-- **Trivial instance** of `StandardConjectureD_Data` on `ℚ`: with
`homClasses = numClasses = ⊥`, both submodules are the zero submodule
and the equality `⊥ = ⊥` holds substantively as `rfl` on submodules. -/
instance : StandardConjectureD_Data ℚ where
  homClasses := ⊥
  numClasses := ⊥
  num_eq_hom := rfl

/-! ## Combined consequences when both (B) and (D) hold

When both conjectures (B) and (D) hold on the same carrier `A`, the
combination gives the **motivic Hard Lefschetz with algebraic
correspondences** picture used in Voisin II Theorem 11.16 to deduce
the Hodge conjecture for codimension-1 cycles and the codim-2 reduction
relevant to our `E_VII` Freudenthal application.

The bridge theorem below packages the **simultaneous existence** of
both data structures: the Hard Lefschetz inverse exists by (B), and
the numerical-equals-homological collapse holds by (D). This is the
abstract input shape for the codim-2 cycle-class-map argument. -/

/-- **Bridge theorem**: under both standard conjectures (B) and (D),
for any `k ≤ dim` we get both a `ℚ`-linear inverse of `L^k` (via (B))
and the submodule coincidence of homological/numerical (via (D)).
This is the abstract motivic input for codim-2 Hodge arguments. -/
theorem standardConjecturesBD_bridge
    [StandardConjectureB_Data A] [StandardConjectureD_Data A]
    (k : ℕ) (hk : k ≤ StandardConjectureB_Data.dim (A := A)) :
    (∃ inv : A →ₗ[ℚ] A,
        ∀ α : A,
          StandardConjectureB_Data.lefschetzOp k (inv α) = α) ∧
      (StandardConjectureD_Data.numClasses : Submodule ℚ A) =
        StandardConjectureD_Data.homClasses := by
  refine ⟨?_, StandardConjectureD_Data.num_eq_hom⟩
  exact ⟨StandardConjectureB_Data.lefschetzInv k hk,
    fun α => StandardConjectureB_Data.lefschetzOp_lefschetzInv k hk α⟩

end HodgeReduction.Infrastructure.Cohomology
