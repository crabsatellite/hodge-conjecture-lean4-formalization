/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.NeronSeveri

/-!
# Picard group framework

For a smooth projective variety `X` over a field `k`, the **Picard group**
`Pic(X) = H¹(X, 𝒪_X^*)` classifies isomorphism classes of holomorphic
(or algebraic, over `k`) line bundles on `X`.

For `X` smooth projective over `ℂ`:
* `Pic^0(X)` — connected component of identity (= line bundles
  algebraically equivalent to `𝒪_X`).
* `NS(X) = Pic(X) / Pic^0(X)` — **Néron-Severi group** (already
  abstracted in `NeronSeveri.lean`).

The **exponential exact sequence** `0 → ℤ → 𝒪_X → 𝒪_X^* → 1` gives:
```
… → H¹(X; ℤ) → H¹(X; 𝒪_X) → Pic(X) → H²(X; ℤ) → H²(X; 𝒪_X) → …
```
inducing `c_1 : Pic(X) → H²(X; ℤ)`, whose image is `NS(X)`.

## Main definitions

* `PicardGroupData A` : typeclass packaging the rational Picard data
  (the `Pic(X)_ℚ` vector space + `c_1` linear map into `A`).

## Tags

Picard group, Pic, line bundle, Chern class, divisor
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Picard group data** for a cohomology ring `A`:

* `PicRat` : the rational Picard subspace `Pic(X)_ℚ ⊆ ?` (we
  abstract as a `ℚ`-vector space, separate from `A`).
* `c1` : the `c_1` linear map `PicRat →ₗ[ℚ] A`.
* `c1_image_isAlgebraic` : the image is algebraic (since Pic comes
  from divisors which are algebraic codim-1 cycles).

This refines the abstraction of `NeronSeveri.NS_rat` (which is the
image of `c_1`). -/
class PicardGroupData where
  /-- The rational Picard group `Pic(X)_ℚ`. -/
  PicRat : Type
  /-- `PicRat` is an additive commutative group. -/
  PicRat_addCommGroup : AddCommGroup PicRat
  /-- `PicRat` is a `ℚ`-module. -/
  PicRat_module : @Module ℚ PicRat _ PicRat_addCommGroup.toAddCommMonoid
  /-- The first Chern class map `c_1 : Pic(X)_ℚ → H²(X; ℚ) ⊆ A`. -/
  c1 : @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) PicRat A
        PicRat_addCommGroup.toAddCommMonoid _ PicRat_module _
  /-- The image of `c_1` is algebraic (divisors are codim-1 cycles). -/
  c1_image_isAlgebraic : ∀ L : PicRat, CohomologyRing.IsAlgebraic (c1 L)

namespace PicardGroupData

variable {A} [PicardGroupData A]

/-- The first Chern class of any line bundle is algebraic. -/
theorem c1_isAlgebraic (L : PicardGroupData.PicRat (A := A)) :
    CohomologyRing.IsAlgebraic (PicardGroupData.c1 L) :=
  PicardGroupData.c1_image_isAlgebraic L

end PicardGroupData

end HodgeReduction.Infrastructure.Cohomology
