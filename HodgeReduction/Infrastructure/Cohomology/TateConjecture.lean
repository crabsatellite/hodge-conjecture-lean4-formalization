/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Range
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Data.Nat.Prime.Basic

/-!
# Tate conjecture framework

The **Tate conjecture** (J. Tate 1965, ICM Stockholm; revisited in
Tate 1994 "Conjectures on algebraic cycles in ℓ-adic cohomology",
*Motives* I, AMS Proc. Symp. Pure Math. 55, 71-83) is the `ℓ`-adic
étale analog of the Hodge conjecture.

For `X` smooth projective over a finitely-generated field `k` and prime
`ℓ ≠ char(k)`, with `k̄` an algebraic closure:
```
(Tate)_p :   cl_ℓ : CH^p(X)_{ℚ_ℓ} → H²ᵖ_ét(X_{k̄}; ℚ_ℓ(p))^{Gal(k̄/k)}
             is SURJECTIVE onto the Galois-fixed subspace.
```
Equivalently: the image of the `ℓ`-adic cycle class map `cl_ℓ` equals
the subspace of Galois-invariant étale classes.

For HC, the Tate conjecture provides a parallel characterisation of
algebraic cycles via Galois invariants rather than Hodge type. Tate
1994 (and Faltings 1983 in special cases) shows: Tate ⟹ Hodge holds
modulo absolute-Hodge formalism (Deligne 1982).

This file packages the **abstract Tate conjecture framework** in three
typeclasses tracking, respectively, the carrier data, the cycle class
map, and the conjectural surjectivity.

## Main definitions

* `TateConjectureData`         — Galois-module carrier data (V_ℓ + Frobenius
                                 action + Galois-fixed submodule + Chow image
                                 inclusion).
* `TateCycleClassData`         — ℓ-adic cycle class map with Galois-equivariance.
* `TateConjectureHolds`        — predicate: image of cycle class map equals
                                 the Galois-fixed subspace (substantive
                                 `Submodule` equality).

## References

* J. Tate, "Algebraic cycles and poles of zeta functions", in
  *Arithmetical Algebraic Geometry* (Schilling, ed.), Harper & Row,
  New York, 1965, pp. 93-110.
* J. Tate, "Conjectures on algebraic cycles in ℓ-adic cohomology", in
  *Motives* I, Proc. Symp. Pure Math. **55** (1994), 71-83.
* J. S. Milne, *Étale Cohomology*, Princeton University Press, 1980,
  esp. Ch. VI (the cycle class map and Tate's conjecture).

## Tags

Tate conjecture, ℓ-adic cohomology, Galois invariant, cycle class map,
Frobenius, étale cohomology, Milne 1980, ICM Stockholm 1965
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ### Step 1 — Galois-module carrier data for ℓ-adic étale cohomology

The carrier `V_ell` (= `H²ᵖ_ét(X_{k̄}; ℚ_ℓ(p))`) and its `ℚ`-module
structure are taken as parameters of the typeclass, exposed via the
binder syntax `[AddCommGroup V_ell] [Module ℚ V_ell]`. This is the
standard Mathlib idiom for carrying both data and structure cleanly
(cf. `Mathlib.Algebra.Module.Submodule.Range` etc.). -/

/-- **Tate conjecture data** for a smooth projective `X` (abstract carrier
+ Galois-action data + Chow image inclusion).

The prime `ℓ` is abstractly a natural number, carrying its primality
hypothesis via `[hℓ : Fact (Nat.Prime ℓ)]`. The étale cohomology
`V_ell ≃ H²ᵖ_ét(X_{k̄}; ℚ_ℓ(p))` is realised as a `ℚ`-vector space — the
typeclass-level abstraction does not commit to the `ℚ_ℓ` topology, only
to the underlying `ℚ`-linear structure (enough for the cycle-class
inclusion + Galois-invariance equations relevant to HC reduction).

Fields:
* `frobenius`              — a designated `ℚ`-linear endomorphism encoding
                             the geometric Frobenius (or, for `k` a number
                             field, a fixed Frobenius-at-a-prime).
* `galois_fixed`            — the Galois-fixed submodule (= eigenspace of
                             Frobenius on the eigenvalue `1` after twist).
* `frobenius_fixed_on_galois_fixed`
                           — Frobenius acts as the identity on `galois_fixed`
                             (the load-bearing equation that links the
                             Frobenius endomorphism to the Galois-invariants
                             submodule).
* `chow_image`             — the image of the Chow group inside `V_ell`,
                             as a `ℚ`-submodule.
* `chow_image_le_galois_fixed`
                           — the **easy direction** of Tate: every cycle
                             class lands in the Galois-fixed subspace.
                             (This is classical via functoriality of the
                             cycle class map for Galois automorphisms.) -/
class TateConjectureData (X : Type*) (ℓ : ℕ) [Fact (Nat.Prime ℓ)]
    (V_ell : Type*) [AddCommGroup V_ell] [Module ℚ V_ell] where
  /-- Geometric Frobenius endomorphism. -/
  frobenius : V_ell →ₗ[ℚ] V_ell
  /-- The Galois-fixed submodule `V_ℓ^{Gal(k̄/k)}`. -/
  galois_fixed : Submodule ℚ V_ell
  /-- Frobenius acts trivially on the Galois-fixed submodule (load-bearing
  equation tying the Frobenius endomorphism to the Galois-invariant
  submodule). -/
  frobenius_fixed_on_galois_fixed :
    ∀ α : V_ell, α ∈ galois_fixed → frobenius α = α
  /-- The image of the Chow group inside `V_ell`, as a `ℚ`-submodule. -/
  chow_image : Submodule ℚ V_ell
  /-- **Easy direction of Tate**: every cycle class is Galois-invariant. -/
  chow_image_le_galois_fixed : chow_image ≤ galois_fixed

namespace TateConjectureData

variable {X : Type*} {ℓ : ℕ} [Fact (Nat.Prime ℓ)]
  {V_ell : Type*} [AddCommGroup V_ell] [Module ℚ V_ell]
  [TateConjectureData X ℓ V_ell]

/-- **Easy direction (one-element version)**: every Chow-image class is
fixed by the absolute Galois group. -/
theorem isGaloisFixed_of_chow_image {α : V_ell}
    (hα : α ∈ chow_image (X := X) (ℓ := ℓ) (V_ell := V_ell)) :
    α ∈ galois_fixed (X := X) (ℓ := ℓ) (V_ell := V_ell) :=
  chow_image_le_galois_fixed hα

/-- **Easy direction (Frobenius form)**: every Chow-image class is fixed
by the Frobenius endomorphism. -/
theorem frobenius_fixed_of_chow_image {α : V_ell}
    (hα : α ∈ chow_image (X := X) (ℓ := ℓ) (V_ell := V_ell)) :
    frobenius (X := X) (ℓ := ℓ) (V_ell := V_ell) α = α :=
  frobenius_fixed_on_galois_fixed (X := X) (ℓ := ℓ) (V_ell := V_ell)
    α (chow_image_le_galois_fixed hα)

end TateConjectureData

/-! ### Step 2 — ℓ-adic cycle class map with Galois equivariance

The Tate conjecture is the surjectivity claim for the `ℓ`-adic cycle
class map `cl_ℓ : CH^p(X) ⊗ ℚ_ℓ → V_ℓ^{Gal(k̄/k)}`. We package the
linear map and its Galois-equivariance property. -/

/-- **Étale cycle class map data** (Milne 1980 *Étale Cohomology* Ch. VI):

* `cl_ell` — the cycle class map `CH_ell →ₗ[ℚ] V_ell`.
* `cl_ell_range_eq_chow_image` — by definition the image of `cl_ell`
  equals the `chow_image` field of the underlying carrier data. -/
class TateCycleClassData (X : Type*) (ℓ : ℕ) [Fact (Nat.Prime ℓ)]
    (V_ell : Type*) [AddCommGroup V_ell] [Module ℚ V_ell]
    [TateConjectureData X ℓ V_ell]
    (CH_ell : Type*) [AddCommGroup CH_ell] [Module ℚ CH_ell] where
  /-- The ℓ-adic cycle class map. -/
  cl_ell : CH_ell →ₗ[ℚ] V_ell
  /-- **Definitional compatibility**: `range cl_ell = chow_image`. The
  range of the cycle class map IS the `chow_image` submodule (this is
  how `chow_image` is defined in any concrete instance). -/
  cl_ell_range_eq_chow_image :
    LinearMap.range cl_ell =
      TateConjectureData.chow_image (X := X) (ℓ := ℓ) (V_ell := V_ell)

namespace TateCycleClassData

variable {X : Type*} {ℓ : ℕ} [Fact (Nat.Prime ℓ)]
  {V_ell : Type*} [AddCommGroup V_ell] [Module ℚ V_ell]
  [TateConjectureData X ℓ V_ell]
  {CH_ell : Type*} [AddCommGroup CH_ell] [Module ℚ CH_ell]
  [TateCycleClassData X ℓ V_ell CH_ell]

/-- **Galois equivariance of the cycle class map**: every image lies in
the Galois-fixed subspace.

This is the composite of the definitional `cl_ell_range_eq_chow_image`
with the easy-direction `chow_image_le_galois_fixed` field. -/
theorem cl_ell_image_le_galois_fixed :
    LinearMap.range (cl_ell (X := X) (ℓ := ℓ) (V_ell := V_ell)
                            (CH_ell := CH_ell)) ≤
      TateConjectureData.galois_fixed (X := X) (ℓ := ℓ) (V_ell := V_ell) := by
  rw [cl_ell_range_eq_chow_image]
  exact TateConjectureData.chow_image_le_galois_fixed

/-- **Pointwise Galois-fixedness**: for every cycle `c`, the image
`cl_ℓ(c)` is Galois-invariant (equivalently, fixed by Frobenius). -/
theorem cl_ell_apply_frobenius_fixed (c : CH_ell) :
    TateConjectureData.frobenius (X := X) (ℓ := ℓ) (V_ell := V_ell)
        (cl_ell (X := X) (ℓ := ℓ) (V_ell := V_ell) (CH_ell := CH_ell) c) =
      cl_ell (X := X) (ℓ := ℓ) (V_ell := V_ell) (CH_ell := CH_ell) c := by
  apply TateConjectureData.frobenius_fixed_on_galois_fixed
  exact cl_ell_image_le_galois_fixed (X := X) (ℓ := ℓ) (V_ell := V_ell)
        (CH_ell := CH_ell) ⟨c, rfl⟩

end TateCycleClassData

/-! ### Step 3 — The Tate conjecture as a substantive `Submodule` equality

The **Tate conjecture** at codim `p` for `(X, ℓ)` is the statement that
the image of the cycle class map equals the Galois-fixed subspace.
We package this as a `Submodule`-equality predicate. -/

/-- **Tate conjecture holds** for `(X, ℓ, V_ell)`: the image of the
`ℓ`-adic cycle class map equals the Galois-fixed submodule of `V_ℓ`.

Substantive content (NO `True` / NO tautology): the LHS `chow_image` and
the RHS `galois_fixed` are two *a priori distinct* submodules of `V_ell`.
The easy direction `≤` is part of `TateConjectureData`. The reverse
direction `≥` (Galois-invariant ⟹ algebraic) is the Tate conjecture
proper. The field below encodes the equality `chow_image = galois_fixed`
as a single `Submodule` equation. -/
class TateConjectureHolds (X : Type*) (ℓ : ℕ) [Fact (Nat.Prime ℓ)]
    (V_ell : Type*) [AddCommGroup V_ell] [Module ℚ V_ell]
    [TateConjectureData X ℓ V_ell] : Prop where
  /-- The Tate equality: image of cycle class map = Galois-fixed subspace. -/
  tate_eq : TateConjectureData.chow_image (X := X) (ℓ := ℓ) (V_ell := V_ell) =
            TateConjectureData.galois_fixed (X := X) (ℓ := ℓ) (V_ell := V_ell)

namespace TateConjectureHolds

variable {X : Type*} {ℓ : ℕ} [Fact (Nat.Prime ℓ)]
  {V_ell : Type*} [AddCommGroup V_ell] [Module ℚ V_ell]
  [TateConjectureData X ℓ V_ell] [TateConjectureHolds X ℓ V_ell]

/-- **Surjectivity onto Galois-fixed subspace** (Tate 1965): every
Galois-invariant class is the image of some cycle class. -/
theorem isAlgebraic_of_galois_fixed {α : V_ell}
    (hα : α ∈ TateConjectureData.galois_fixed
                (X := X) (ℓ := ℓ) (V_ell := V_ell)) :
    α ∈ TateConjectureData.chow_image (X := X) (ℓ := ℓ) (V_ell := V_ell) := by
  rw [tate_eq]
  exact hα

/-- **Tate equality contrapositive**: a class is in the Chow image
iff it is Galois-invariant. -/
theorem chow_image_iff_galois_fixed (α : V_ell) :
    α ∈ TateConjectureData.chow_image (X := X) (ℓ := ℓ) (V_ell := V_ell) ↔
      α ∈ TateConjectureData.galois_fixed
            (X := X) (ℓ := ℓ) (V_ell := V_ell) := by
  constructor
  · exact TateConjectureData.isGaloisFixed_of_chow_image
  · exact isAlgebraic_of_galois_fixed

/-- **Pointwise Frobenius criterion**: if Frobenius fixes `α` (and `α`
is Galois-invariant), then `α` lies in the Chow image (assuming Tate).
This is the "Frobenius-eigenvalue form" of the Tate conjecture. -/
theorem chow_image_of_frobenius_fixed (α : V_ell)
    (hα : α ∈ TateConjectureData.galois_fixed
                (X := X) (ℓ := ℓ) (V_ell := V_ell)) :
    TateConjectureData.frobenius (X := X) (ℓ := ℓ) (V_ell := V_ell) α = α ∧
      α ∈ TateConjectureData.chow_image
            (X := X) (ℓ := ℓ) (V_ell := V_ell) :=
  ⟨TateConjectureData.frobenius_fixed_on_galois_fixed α hα,
   isAlgebraic_of_galois_fixed hα⟩

end TateConjectureHolds

end HodgeReduction.Infrastructure.Cohomology
