/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

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

## Main definitions

* `HardLefschetzData A` : typeclass packaging the Lefschetz operator
  `L : A → A` (cup with `h`) and the iso property.

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

end HodgeReduction.Infrastructure.Cohomology
