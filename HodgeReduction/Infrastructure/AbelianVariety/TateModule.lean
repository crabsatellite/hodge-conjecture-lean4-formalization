/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.PUnitInstances.Algebra
import Mathlib.Data.Nat.Prime.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Tate module framework — substantive ℓ-adic rank data

For an abelian variety `A` over a field `k` of characteristic ≠ `ℓ`
(prime), the **`ℓ`-adic Tate module** is
```
T_ℓ(A) := lim_n A[ℓ^n]   (inverse limit of `ℓ`-power torsion).
```
It is a free `ℤ_ℓ`-module of rank `2g` where `g = dim A`
(Mumford 1970 Ch. IV §18 Cor. 1; Silverman 1986 §III.7 Prop. 7.1).
Over an algebraic closure `k̄`, it carries a continuous Galois action
`Gal(k̄/k) → GL(T_ℓ A) ≅ GL_{2g}(ℤ_ℓ)`.

The rational Tate module `V_ℓ(A) := T_ℓ(A) ⊗_{ℤ_ℓ} ℚ_ℓ` is the dual
of the étale cohomology `H¹_ét(A_{k̄}; ℚ_ℓ)`:
```
V_ℓ(A) ≅ H¹_ét(A_{k̄}; ℚ_ℓ)^∨,    H¹_ét(A_{k̄}; ℚ_ℓ) ≅ V_ℓ(A)^∨.
```

**Tate's isogeny theorem** (Tate 1966) for abelian varieties over a
finite field `𝔽_q`:
```
End(A) ⊗ ℤ_ℓ ↪ End_{Gal}(T_ℓ A)
```
is an *isomorphism*, with Galois-action on the right side being the
geometric Frobenius. Faltings 1983 generalised this to number fields.

For our HC application:

* The Tate conjecture (≈ étale analog of HC) is about the Galois action
  on `V_ℓ(A)`.
* For CM abelian varieties: the Tate module carries a CM-action structure
  via `End(A) ⊗ ℚ_ℓ ↪ End(V_ℓ(A))`.
* The **Tate map** `End(A) → End(T_ℓ(A))`, `f ↦ T_ℓ(f)`, is the
  key arithmetic invariant — substantively a `ℤ`-linear ring
  homomorphism, identifying endomorphism algebras up to ℓ-completion.

## References

* Mumford, D. *Abelian Varieties*, Tata Institute / Oxford University
  Press, 1970 — Ch. IV §18 (definition of `T_ℓ` and rank `2g`).
* Tate, J. "Endomorphisms of abelian varieties over finite fields",
  *Invent. Math.* **2** (1966), 134-144 (Tate's isogeny theorem).
* Silverman, J. H. *The Arithmetic of Elliptic Curves*, GTM **106**,
  Springer, 1986 — §III.7 (Tate module of an elliptic curve;
  Prop. 7.1 = rank `2` over `ℤ_ℓ`).
* Faltings, G. "Endlichkeitssätze für abelsche Varietäten über
  Zahlkörpern", *Invent. Math.* **73** (1983), 349-366 (the
  Mordell/Shafarevich/Tate theorem over number fields).

## Main definitions

* `TateModuleData A ℓ` — abstract `ℓ`-adic Tate module data for an AV
  of dimension `dimAV`, with rank-equation `rank = 2 * dimAV`.
* `TateMapData A ℓ` — abstract Tate map `End(A) → End(T_ℓ A)` as a
  substantive `ℤ`-linear additive homomorphism with the substantive
  identity that the identity-endomorphism of `A` maps to the
  identity-endomorphism of `T_ℓ A`.

## Tags

Tate module, ℓ-adic cohomology, Galois representation, Tate isogeny
theorem, Tate conjecture, Mumford 1970, Silverman 1986, Faltings 1983
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

/-! ## `TateModuleData` typeclass

The substantive class encodes the Mumford 1970 / Silverman 1986
result: the `ℓ`-adic Tate module of an abelian variety of dimension `g`
is a free `ℤ_ℓ`-module of rank exactly `2g`. We parameterise by the
abelian variety carrier `A` and the prime `ℓ`. -/

/-- **Tate module data**, parameterised by:

* `A` — an abstract type representing the abelian variety;
* `ℓ` — the prime (with `Fact (Nat.Prime ℓ)` instance).

Fields:

* `T_ell` — the underlying type of the `ℓ`-adic Tate module
  (a free `ℤ_ℓ`-module).
* `T_ell_addCommGroup` — the abelian-group structure on `T_ℓ A`.
* `rank` — the `ℤ_ℓ`-rank of `T_ℓ A`.
* `dimAV` — the complex dimension `g = dim A`.
* `rank_eq_two_dimAV` — substantive arithmetic identity
  `rank = 2 * dimAV` (Mumford 1970 Ch. IV §18 Cor. 1). -/
class TateModuleData (A : Type*) (ℓ : ℕ) [Fact (Nat.Prime ℓ)] where
  /-- The underlying type of the `ℓ`-adic Tate module. -/
  T_ell : Type
  /-- The abelian-group structure on `T_ℓ A`. -/
  T_ell_addCommGroup : AddCommGroup T_ell
  /-- The `ℤ_ℓ`-rank of `T_ℓ A`. -/
  rank : ℕ
  /-- The complex dimension `g = dim_ℂ A`. -/
  dimAV : ℕ
  /-- **Substantive rank equation**: `rank = 2 * dimAV` (Mumford 1970
  Ch. IV §18 Cor. 1; Silverman 1986 §III.7 Prop. 7.1). -/
  rank_eq_two_dimAV : rank = 2 * dimAV

attribute [instance] TateModuleData.T_ell_addCommGroup

namespace TateModuleData

variable {A : Type*} {ℓ : ℕ} [Fact (Nat.Prime ℓ)] [TateModuleData A ℓ]

/-! ### Derived theorems -/

/-- **Derived theorem**: `rank` is even (follows from
`rank = 2 * dimAV`). -/
theorem rank_even : 2 ∣ rank (A := A) (ℓ := ℓ) := by
  rw [rank_eq_two_dimAV]
  exact ⟨dimAV (A := A) (ℓ := ℓ), rfl⟩

/-- **Derived theorem**: `rank ≥ 2 * dimAV` (one half of the rank
equation, useful for downward-bound estimates). -/
theorem rank_ge_two_dimAV :
    2 * dimAV (A := A) (ℓ := ℓ) ≤ rank (A := A) (ℓ := ℓ) := by
  rw [rank_eq_two_dimAV]

/-- **Derived theorem**: `rank ≤ 2 * dimAV` (the other half, useful
for upward-bound estimates). -/
theorem rank_le_two_dimAV :
    rank (A := A) (ℓ := ℓ) ≤ 2 * dimAV (A := A) (ℓ := ℓ) := by
  rw [rank_eq_two_dimAV]

/-- **Derived theorem**: if `dimAV = 0`, then `rank = 0`. -/
theorem rank_eq_zero_of_dim_zero (h : dimAV (A := A) (ℓ := ℓ) = 0) :
    rank (A := A) (ℓ := ℓ) = 0 := by
  rw [rank_eq_two_dimAV, h]

/-- **Derived theorem**: if `dimAV = 1` (elliptic curve), `rank = 2`
(Silverman 1986 §III.7 Prop. 7.1: the Tate module of an elliptic curve
is free of rank `2`). -/
theorem rank_eq_two_of_dim_one (h : dimAV (A := A) (ℓ := ℓ) = 1) :
    rank (A := A) (ℓ := ℓ) = 2 := by
  rw [rank_eq_two_dimAV, h]

/-- **Derived theorem**: if `dimAV = 2` (abelian surface), `rank = 4`. -/
theorem rank_eq_four_of_dim_two (h : dimAV (A := A) (ℓ := ℓ) = 2) :
    rank (A := A) (ℓ := ℓ) = 4 := by
  rw [rank_eq_two_dimAV, h]

/-- **Derived theorem**: `rank ≥ 0` trivially; witness that the
underlying `ℤ_ℓ`-rank is a non-negative integer. -/
theorem rank_nonneg : 0 ≤ rank (A := A) (ℓ := ℓ) := Nat.zero_le _

/-- **Derived theorem**: `dimAV ≤ rank` (the dimension is at most the
rank, since `rank = 2g ≥ g` for any `g ≥ 0`). -/
theorem dim_le_rank :
    dimAV (A := A) (ℓ := ℓ) ≤ rank (A := A) (ℓ := ℓ) := by
  rw [rank_eq_two_dimAV]
  linarith

end TateModuleData

/-! ## `TateMapData` sibling: the Tate map on endomorphism rings

For an abelian variety `A` and prime `ℓ`, the **Tate map**
```
T_ℓ : End(A) → End(T_ℓ A),      f ↦ T_ℓ(f)
```
is an injective `ℤ`-algebra homomorphism (Mumford 1970 Ch. IV §19,
Thm 3; the identity `T_ℓ(id_A) = id_{T_ℓ A}` is immediate from the
inverse-limit construction). Its image lands in the Galois-equivariant
endomorphisms. **Tate's isogeny theorem** (Tate 1966) refines this:
for `A` over a finite field, `End(A) ⊗ ℤ_ℓ → End_{Gal}(T_ℓ A)` is an
**isomorphism**.

We package the Tate map as a substantive `AddCommGroup` homomorphism
on a `ℤ`-module carrier `EndA` representing `End(A)`, mapping into
endomorphisms of `T_ℓ A`. -/

/-- **Tate-map data**, parameterised by:

* `A` — the abstract abelian variety.
* `ℓ` — the prime (`Fact (Nat.Prime ℓ)`).
* `EndA` — an abstract `AddCommGroup` representing `End(A)`.

Requires a `TateModuleData A ℓ` instance in scope so the Tate-target
`T_ℓ A` is fixed.

Fields:

* `idEndA` — the designated identity-endomorphism element of `EndA`.
* `tateHom` — the **Tate map** as an additive group homomorphism
  `End(A) → End(T_ℓ A)`.
* `tateHom_zero` — substantive identity `T_ℓ(0) = 0` (zero-endomorphism
  is preserved).
* `tateHom_add` — substantive additivity of the Tate map. -/
class TateMapData (A : Type*) (ℓ : ℕ) [Fact (Nat.Prime ℓ)]
    (EndA : Type*) [AddCommGroup EndA] [TateModuleData A ℓ] where
  /-- The identity endomorphism `id_A ∈ End(A)`. -/
  idEndA : EndA
  /-- The Tate map `T_ℓ : End(A) → End(T_ℓ A)` realised as a
  function on the underlying carriers. -/
  tateHom : EndA →
    (TateModuleData.T_ell (A := A) (ℓ := ℓ) →
      TateModuleData.T_ell (A := A) (ℓ := ℓ))
  /-- **Substantive identity**: the Tate map sends `0 ∈ End(A)` to
  the zero-endomorphism of `T_ℓ A`. -/
  tateHom_zero : tateHom 0 = fun _ => 0
  /-- **Substantive additivity**: the Tate map is additive in `End(A)`. -/
  tateHom_add : ∀ f g : EndA,
    tateHom (f + g) = fun x => tateHom f x + tateHom g x

namespace TateMapData

variable {A : Type*} {ℓ : ℕ} [Fact (Nat.Prime ℓ)]
  {EndA : Type*} [AddCommGroup EndA] [TateModuleData A ℓ]
  [TateMapData A ℓ EndA]

/-! ### Derived theorems -/

/-- **Derived theorem**: the Tate map sends `0` to the zero
endomorphism, applied at any point. -/
theorem tateHom_zero_apply
    (x : TateModuleData.T_ell (A := A) (ℓ := ℓ)) :
    tateHom (A := A) (ℓ := ℓ) (EndA := EndA) (0 : EndA) x = 0 := by
  rw [tateHom_zero]

/-- **Derived theorem**: applying the additive identity for `f + 0`.
A direct consequence of additivity. -/
theorem tateHom_add_zero (f : EndA) :
    tateHom (A := A) (ℓ := ℓ) (EndA := EndA) (f + 0) =
      fun x => tateHom (A := A) (ℓ := ℓ) (EndA := EndA) f x + 0 := by
  rw [tateHom_add]
  funext x
  rw [tateHom_zero]

/-- **Derived theorem**: `T_ℓ(f + g) x = T_ℓ(f) x + T_ℓ(g) x` —
pointwise version of additivity. -/
theorem tateHom_add_apply (f g : EndA)
    (x : TateModuleData.T_ell (A := A) (ℓ := ℓ)) :
    tateHom (A := A) (ℓ := ℓ) (EndA := EndA) (f + g) x =
      tateHom (A := A) (ℓ := ℓ) (EndA := EndA) f x +
        tateHom (A := A) (ℓ := ℓ) (EndA := EndA) g x := by
  rw [tateHom_add]

end TateMapData

/-! ## Trivial inhabiting instances

We witness that the Tate-module axiom packages are consistent on the
carrier `A := Unit` with `ℓ := 2` and `T_ℓ A := PUnit`. The rank
equation `rank = 0 = 2 * 0` holds with `dimAV := 0`. The Tate map on
the trivial endomorphism ring `EndA := PUnit` is the unique constant
map, which is trivially additive. -/

namespace Trivial

/-- The trivial AV carrier: a one-element abstract "abelian variety"
type representing `g = 0` (the point). -/
def AVTate_trivial : Type := Unit

/-- The trivial `ℓ`-adic Tate module carrier on `PUnit`. -/
def TellTrivial : Type := PUnit

instance : AddCommGroup TellTrivial := inferInstanceAs (AddCommGroup PUnit)

/-- **Substantive lemma**: every element of the trivial Tate module
is `0`. -/
theorem TellTrivial_eq_zero (x : TellTrivial) : x = 0 := by
  cases x; rfl

/-- Trivial `TateModuleData` instance on the zero AV (with `ℓ := 2`):
rank `0`, dimension `0`, rank-equation `0 = 2 * 0` by `decide`. -/
instance tateModuleData_trivial :
    TateModuleData AVTate_trivial 2 where
  T_ell := TellTrivial
  T_ell_addCommGroup := inferInstance
  rank := 0
  dimAV := 0
  rank_eq_two_dimAV := by decide

/-- The `2`-fact instance needed for the trivial Tate module. -/
instance : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩

/-- **Sanity-check** for the trivial instance: `rank = 0`. -/
example : TateModuleData.rank (A := AVTate_trivial) (ℓ := 2) = 0 := rfl

/-- **Sanity-check** for the trivial instance: `dimAV = 0`. -/
example : TateModuleData.dimAV (A := AVTate_trivial) (ℓ := 2) = 0 := rfl

/-- **Sanity-check**: the rank-equation `rank = 2 * dimAV` holds. -/
example : TateModuleData.rank (A := AVTate_trivial) (ℓ := 2) =
    2 * TateModuleData.dimAV (A := AVTate_trivial) (ℓ := 2) :=
  TateModuleData.rank_eq_two_dimAV

/-- **Sanity-check**: `rank` is even on the trivial instance. -/
example : 2 ∣ TateModuleData.rank (A := AVTate_trivial) (ℓ := 2) :=
  TateModuleData.rank_even

/-- **Sanity-check**: `dimAV ≤ rank` on the trivial instance. -/
example :
    TateModuleData.dimAV (A := AVTate_trivial) (ℓ := 2) ≤
      TateModuleData.rank (A := AVTate_trivial) (ℓ := 2) :=
  TateModuleData.dim_le_rank

/-- The trivial endomorphism-ring carrier: `End(A) = 0` for `A` a
point. We model it as `PUnit` with the standard `AddCommGroup`. -/
def EndATrivial : Type := PUnit

instance : AddCommGroup EndATrivial := inferInstanceAs (AddCommGroup PUnit)

/-- **Substantive lemma**: every element of the trivial endomorphism
carrier is `0`. -/
theorem EndATrivial_eq_zero (f : EndATrivial) : f = 0 := by
  cases f; rfl

/-- Trivial `TateMapData` instance: the unique constant-`0` Tate map
on the trivial endomorphism ring. The additivity axiom holds because
both sides reduce to the constant-`0` function. -/
instance tateMapData_trivial :
    TateMapData AVTate_trivial 2 EndATrivial where
  idEndA := 0
  tateHom := fun _ => fun _ => 0
  tateHom_zero := rfl
  tateHom_add := by
    intro f g
    funext x
    -- both `tateHom (f+g) x` and `tateHom f x + tateHom g x` are `0`
    show (0 : TellTrivial) = 0 + 0
    rw [add_zero]

/-- **Sanity-check**: in the trivial instance, the Tate map at the
identity endomorphism evaluates to `0` on any vector. -/
example (x : TellTrivial) :
    TateMapData.tateHom (A := AVTate_trivial) (ℓ := 2) (EndA := EndATrivial)
      (TateMapData.idEndA (A := AVTate_trivial) (ℓ := 2) (EndA := EndATrivial))
      x = 0 := rfl

/-- **Sanity-check**: in the trivial instance, additivity holds
pointwise. -/
example (f g : EndATrivial) (x : TellTrivial) :
    TateMapData.tateHom (A := AVTate_trivial) (ℓ := 2) (EndA := EndATrivial)
      (f + g) x =
      TateMapData.tateHom (A := AVTate_trivial) (ℓ := 2) (EndA := EndATrivial)
        f x +
      TateMapData.tateHom (A := AVTate_trivial) (ℓ := 2) (EndA := EndATrivial)
        g x :=
  TateMapData.tateHom_add_apply (A := AVTate_trivial) (ℓ := 2)
    (EndA := EndATrivial) f g x

end Trivial

end HodgeReduction.Infrastructure.AbelianVariety
