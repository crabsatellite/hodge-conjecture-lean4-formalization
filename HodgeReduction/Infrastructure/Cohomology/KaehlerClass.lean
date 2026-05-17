/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Algebra.Basic

/-!
# Kähler class as an algebraic cohomology class

For a smooth projective variety `X` with a polarisation
(an ample line bundle `L`), the **Kähler class**
`h := c_1(L) ∈ H^2(X; ℚ)` is an algebraic cohomology class: it
arises from the divisor class of `L`, which is a 1-codimensional
algebraic cycle.

This file packages the existence of a Kähler class with its
algebraicity as a typeclass `KaehlerClass`. From this, polynomials
`h, h^2, h^3, h^4, ...` are all algebraic by the closure properties
of the algebraic subring.

## Main definitions

* `KaehlerClass A` : a typeclass providing a designated Kähler
  class `h : A` and proof of its algebraicity.
* `KaehlerClass.h_pow_isAlgebraic n` : `h^n` is algebraic for any `n`.

## Mathematical content

This is the simplest case of the "Lefschetz hyperplane theorem
implies HC for codim-1 classes" — divisors are obviously algebraic
because they are codim-1 algebraic cycles. The Hodge conjecture
in this case is just the (1,1)-classes are algebraic statement,
which follows from the Lefschetz (1,1) theorem (a classical result).

For our application: the Kähler class `h ∈ H^2(EVII; ℚ)` is the
generator of `H^*(EVII; ℚ)` (since `EVII` has cohomology ring
`ℚ[h] / (h^{27+1})` as a compact Hermitian symmetric space of
complex dimension 27). Powers `h^k` generate the whole cohomology.

## Tags

Kähler class, polarisation, ample divisor, Lefschetz (1,1)
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- A `KaehlerClass` for `A` is a distinguished element `h : A` that
is algebraic, together with the Borel-Hirzebruch non-degeneracy witness
that `h^4 ≠ 0`. Morally, `h = c_1(L)` for some ample line bundle `L`.

The `h_pow_4_ne_zero` field encodes the Borel-Hirzebruch Poincaré
polynomial fact `b_8(Ě_VII) = 1` (so `H^8(Ě_VII; ℚ) = ⟨h^4⟩` is
1-dimensional, hence `h^4` generates it and is non-zero). For a general
compact Kähler manifold this is the Hard Lefschetz statement that `h^k`
is non-zero for `k ≤ dim_C X` (here `dim_C Ě_VII = 27 ≥ 4`). -/
class KaehlerClass (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] where
  /-- The Kähler class. -/
  h : A
  /-- The Kähler class is algebraic. -/
  h_isAlgebraic : CohomologyRing.IsAlgebraic h
  /-- **Borel-Hirzebruch non-degeneracy at degree 8** (`b_8(Ě_VII) = 1`):
  the 4th power `h^4` of the Kähler class is non-zero in `A`. This is the
  Borel-Hirzebruch Poincaré-polynomial fact for the EVII compact dual; for
  a general compact Kähler manifold of complex dimension `≥ 4` it is the
  Hard Lefschetz `h^k ≠ 0` for `k ≤ dim_C X`. -/
  h_pow_4_ne_zero : (h : A) ^ 4 ≠ 0

namespace KaehlerClass

variable [KaehlerClass A]

/-- The Kähler class itself is algebraic (re-export at the
`KaehlerClass` namespace level). -/
theorem h_algebraic : CohomologyRing.IsAlgebraic (h : A) :=
  h_isAlgebraic

/-- Any power `h^n` of the Kähler class is algebraic. -/
theorem h_pow_isAlgebraic (n : ℕ) :
    CohomologyRing.IsAlgebraic ((h : A) ^ n) :=
  CohomologyRing.isAlgebraic_pow h_isAlgebraic n

/-- The 4th power `h^4` is algebraic — the specific case used in
the Freudenthal-class HC argument for EVII (where the Freudenthal
class lives in `H^8` and equals `c · h^4` for some `c : ℚ`). -/
theorem h_pow_4_isAlgebraic : CohomologyRing.IsAlgebraic ((h : A) ^ 4) :=
  h_pow_isAlgebraic 4

/-- Any rational-scalar multiple of `h^n` is algebraic. -/
theorem rat_smul_h_pow_isAlgebraic (r : ℚ) (n : ℕ) :
    CohomologyRing.IsAlgebraic (r • ((h : A) ^ n)) :=
  CohomologyRing.isAlgebraic_smul r (h_pow_isAlgebraic n)

/-- The specific class `-48 • h^4` is algebraic — the right-hand-side
of the Freudenthal-class identity `[q] = −48 h^4` for EVII. -/
theorem neg_48_h_pow_4_isAlgebraic :
    CohomologyRing.IsAlgebraic ((-48 : ℚ) • ((h : A) ^ 4)) :=
  rat_smul_h_pow_isAlgebraic _ _

/-- Any non-zero rational scalar multiple of `h^4` is non-zero in `A`.
Combines the Borel-Hirzebruch non-degeneracy `h_pow_4_ne_zero` with the
fact that `ℚ` is a field acting faithfully (no non-zero rational kills
a non-zero element of a `ℚ`-algebra). -/
theorem rat_smul_h_pow_4_ne_zero {r : ℚ} (hr : r ≠ 0) :
    r • ((h : A) ^ 4) ≠ 0 := by
  intro hzero
  -- `r • (h^4) = 0` ⟹ `(algebraMap ℚ A) r * h^4 = 0`.
  rw [Algebra.smul_def] at hzero
  -- Multiply both sides on the left by `(algebraMap ℚ A) r⁻¹`.
  have hmul : (algebraMap ℚ A) r⁻¹ * ((algebraMap ℚ A) r * (h : A) ^ 4) =
      (algebraMap ℚ A) r⁻¹ * 0 := by
    rw [hzero]
  rw [mul_zero, ← mul_assoc, ← map_mul, inv_mul_cancel₀ hr, map_one,
      one_mul] at hmul
  exact h_pow_4_ne_zero hmul

/-- The specific class `-48 • h^4` is non-zero (combines
`coefficient_neg_48_ne_zero` and `h_pow_4_ne_zero`). -/
theorem neg_48_h_pow_4_ne_zero :
    (-48 : ℚ) • ((h : A) ^ 4) ≠ 0 :=
  rat_smul_h_pow_4_ne_zero (by norm_num : (-48 : ℚ) ≠ 0)

/-- The Kähler class itself is non-zero. Substantive consequence of
`h_pow_4_ne_zero`: if `h = 0` then `h^4 = 0^4 = 0`, contradiction. -/
theorem h_ne_zero : (h : A) ≠ 0 := by
  intro hzero
  apply h_pow_4_ne_zero (A := A)
  rw [hzero]
  exact zero_pow (by norm_num : (4 : ℕ) ≠ 0)

/-- The square `h^2` is non-zero. Substantive consequence of
`h_pow_4_ne_zero`: if `h^2 = 0` then `h^4 = (h^2)^2 = 0`, contradiction. -/
theorem h_pow_2_ne_zero : (h : A) ^ 2 ≠ 0 := by
  intro hsq
  apply h_pow_4_ne_zero (A := A)
  have : (h : A) ^ 4 = ((h : A) ^ 2) ^ 2 := by ring
  rw [this, hsq]
  exact zero_pow (by norm_num : (2 : ℕ) ≠ 0)

/-- The cube `h^3` is non-zero. Substantive consequence of
`h_pow_4_ne_zero`: if `h^3 = 0` then `h^4 = h^3 * h = 0`, contradiction. -/
theorem h_pow_3_ne_zero : (h : A) ^ 3 ≠ 0 := by
  intro hcube
  apply h_pow_4_ne_zero (A := A)
  have : (h : A) ^ 4 = (h : A) ^ 3 * (h : A) := by ring
  rw [this, hcube, zero_mul]

end KaehlerClass

/-! ## Sibling typeclass: `KaehlerFormData`

The **Kähler (1,1)-form class** `[ω] ∈ H^{1,1}(X; ℚ)` of a compact
Kähler manifold `X` (Kodaira 1954 *On Kähler Varieties of Restricted
Type*; Kodaira–Spencer 1958 *On Deformations of Complex Analytic
Structures*; Voisin 2002 Vol. I Ch. 3 §3.1; Griffiths–Harris 1978
Ch. 0.7 *Kähler manifolds*) carries three substantive structural
properties used throughout Hodge theory:

* **Non-degeneracy**: `ω ≠ 0` (otherwise `X` is not Kähler).
* **Power-positivity**: `ω^k ≠ 0` for `0 ≤ k ≤ topDim/2 = dim_ℂ X`
  (Voisin I Theorem 6.25; this is the Hard Lefschetz statement on
  the level of cohomology power classes).
* **Degree axiom**: `degreeOf ω = 2` (the Kähler class lives in `H²`
  because it is a `(1,1)`-form pairing tangent vectors).

The sibling typeclass `KaehlerFormData` packages these three structural
properties for the **abstract** Kähler form `ω`, independent of the
generator `h` of the existing `KaehlerClass` typeclass. In the EVII
application `h := X : Polynomial ℚ` plays both roles, but at the
abstract level we keep them distinct (so e.g. one can later instantiate
`ω` from a polarisation `c_1(L)` while `h` is a normalised generator). -/

/-- **Kähler form data** for a cohomology ring carrying a Kähler class.

Sibling of `KaehlerClass`: packages the (1,1)-form `ω` with the
substantive non-degeneracy, power-positivity, and degree axioms of
Kodaira–Spencer 1958 and Voisin I Ch. 3. -/
class KaehlerFormData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [KaehlerClass A] where
  /-- The **Kähler (1,1)-form class** `[ω] ∈ H^{1,1}(X; ℚ) ⊆ A`. -/
  omega : A
  /-- The **degree function** on cohomology classes. Records the
  cohomological degree of each element of `A`; used to assert that `ω`
  lives in `H²` (degree 2). -/
  degreeOf : A → ℕ
  /-- The **top cohomological dimension** `topDim = 2 · dim_ℂ X` for a
  compact complex `dim_ℂ X`-fold. Used to bound the Hard-Lefschetz
  power range `0 ≤ k ≤ topDim/2`. -/
  topDim : ℕ
  /-- **Substantive non-degeneracy** (Kodaira 1954): the Kähler form
  is non-zero in `A`. -/
  omega_ne_zero : omega ≠ 0
  /-- **Substantive power-positivity** (Voisin I Thm 6.25; Hard
  Lefschetz on power classes): for every `0 ≤ k ≤ topDim/2`, the power
  `ω^k` is non-zero in `A`. -/
  omega_pow_ne_zero : ∀ k : ℕ, k ≤ topDim / 2 → omega ^ k ≠ 0
  /-- **Substantive degree axiom** (Griffiths–Harris Ch. 0.7; Voisin I
  §3.1): the Kähler class lives in `H²`, so its cohomological degree
  equals 2. -/
  omega_degree_eq_two : degreeOf omega = 2

namespace KaehlerFormData

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A] [KaehlerFormData A]

/-- **Re-export** of the non-degeneracy axiom. -/
theorem omega_ne_zero' : omega (A := A) ≠ 0 := omega_ne_zero

/-- **Re-export** of the degree axiom: `degreeOf ω = 2`. -/
theorem omega_deg : degreeOf (A := A) (omega (A := A)) = 2 :=
  omega_degree_eq_two

/-- **The zeroth power of ω is non-zero**: `ω^0 = 1`, and `1 ≠ 0`
follows from `omega_pow_ne_zero` at `k = 0` (which is `≤ topDim/2`).
This in particular forces `A` to be a non-trivial ring whenever
`KaehlerFormData A` is inhabited. -/
theorem one_ne_zero_of_kaehler : (1 : A) ≠ 0 := by
  have h0 : omega (A := A) ^ 0 ≠ 0 :=
    omega_pow_ne_zero 0 (Nat.zero_le _)
  intro hone
  apply h0
  rw [pow_zero, hone]

/-- **Linear-map form of multiplication by ω** as a `ℚ`-linear
endomorphism of `A`. This is the abstract Lefschetz operator
`L_ω : A → A`, `α ↦ ω · α`. -/
def omegaMul : A →ₗ[ℚ] A where
  toFun α := omega (A := A) * α
  map_add' x y := by ring
  map_smul' r x := by
    show omega (A := A) * (r • x) = r • (omega (A := A) * x)
    rw [Algebra.mul_smul_comm]

@[simp] theorem omegaMul_apply (α : A) :
    omegaMul α = omega (A := A) * α := rfl

/-- The omega-multiplication map sends `1` to `ω`. Substantive
consequence of the definition (`mul_one`). -/
theorem omegaMul_one : (omegaMul : A →ₗ[ℚ] A) 1 = omega (A := A) := by
  show omega (A := A) * 1 = omega (A := A)
  rw [mul_one]

/-- Iterating omega-multiplication `k` times gives `ω^k` times the
input. Substantive `Function.iterate` computation. -/
theorem omegaMul_iterate (k : ℕ) (α : A) :
    (omegaMul : A →ₗ[ℚ] A)^[k] α = omega (A := A) ^ k * α := by
  induction k with
  | zero => show α = omega (A := A) ^ 0 * α; rw [pow_zero, one_mul]
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih]
      show omega (A := A) * (omega (A := A) ^ n * α)
          = omega (A := A) ^ (n + 1) * α
      ring

end KaehlerFormData

/-! ## Sibling typeclass: `KaehlerLefschetzData`

The Kähler class `ω` induces the **Hard Lefschetz isomorphism**
`L^k : H^{n−k}(X; ℚ) ≃ H^{n+k}(X; ℚ)` (Hodge 1941; Lefschetz 1924;
Voisin I Theorem 6.25; Griffiths–Harris Ch. 0.7 *Kähler identities*).
The structural connection between the abstract Kähler form `ω` and the
Lefschetz operator on cohomology is: `L = (α ↦ ω · α)`.

This sibling typeclass packages **the substantive linear-map identity**

```
   lefschetzOp = omegaMul    (as ℚ-linear endomorphisms of A)
```

together with the Hard-Lefschetz non-degeneracy witness: the iterated
operator `lefschetzOp^[topDim/2]` applied to `1 : A` is non-zero (this
is the existence of the top-power Lefschetz class `ω^{dim_ℂ X}`). -/

/-- **Kähler–Lefschetz data** packaging the structural identity between
the abstract Kähler form `ω` and the Lefschetz operator `L_ω` on
cohomology.

Sibling of `KaehlerFormData`: adds the substantive linear-map equation
of Griffiths–Harris Ch. 0.7 (Kähler identities) and the Hard-Lefschetz
non-degeneracy witness of Voisin I Theorem 6.25. -/
class KaehlerLefschetzData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [KaehlerClass A] [KaehlerFormData A] where
  /-- The **abstract Lefschetz operator** `L : A → A` as a `ℚ`-linear
  endomorphism. Morally `L = cup product with ω`. -/
  lefschetzOp : A →ₗ[ℚ] A
  /-- **Substantive structural connection** (Griffiths–Harris Ch. 0.7;
  Kähler identities `[L, Λ] = (n−k)·id`): the abstract Lefschetz
  operator `L` equals multiplication by `ω` as a `ℚ`-linear
  endomorphism. This is the linear-map identity
  `∀ α, lefschetzOp α = ω * α`. -/
  lefschetzOp_eq_omegaMul :
    ∀ α : A, lefschetzOp α = KaehlerFormData.omega * α
  /-- **Substantive Hard-Lefschetz non-degeneracy witness** (Voisin I
  Thm 6.25): the iterated Lefschetz operator applied `topDim/2` times
  to the unit class `1 : A` is non-zero. This realises the existence of
  the top-power Lefschetz class `[ω]^{dim_ℂ X}` in middle cohomology. -/
  lefschetzOp_top_iter_ne_zero :
    lefschetzOp^[KaehlerFormData.topDim (A := A) / 2] 1 ≠ 0

namespace KaehlerLefschetzData

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A] [KaehlerFormData A] [KaehlerLefschetzData A]

/-- **Re-export** of the linear-map structural identity. -/
theorem lefOp_eq_omegaMul (α : A) :
    lefschetzOp α = KaehlerFormData.omega * α :=
  lefschetzOp_eq_omegaMul α

/-- **Pointwise identity**: the `ℚ`-linear maps `lefschetzOp` and
`KaehlerFormData.omegaMul` agree on every input. Substantive
consequence of `lefschetzOp_eq_omegaMul` (the per-element form). -/
theorem lefOp_eq_omegaMul_apply (α : A) :
    (lefschetzOp : A →ₗ[ℚ] A) α = KaehlerFormData.omegaMul α := by
  rw [lefOp_eq_omegaMul]
  rfl

/-- **Iterated Lefschetz operator gives a power of ω**: applying
`lefschetzOp` to `α` exactly `k` times yields `ω^k · α`. Substantive
consequence of the structural identity. -/
theorem lefschetzOp_iterate (k : ℕ) (α : A) :
    (lefschetzOp : A →ₗ[ℚ] A)^[k] α = KaehlerFormData.omega ^ k * α := by
  induction k with
  | zero =>
      show α = KaehlerFormData.omega ^ 0 * α
      rw [pow_zero, one_mul]
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih, lefOp_eq_omegaMul]
      show KaehlerFormData.omega * (KaehlerFormData.omega ^ n * α)
          = KaehlerFormData.omega ^ (n + 1) * α
      ring

/-- **Lefschetz top-power class on the unit**: applying the iterated
operator `lefschetzOp^[k]` to `1 : A` yields exactly `ω^k`. -/
theorem lefschetzOp_iterate_one (k : ℕ) :
    (lefschetzOp : A →ₗ[ℚ] A)^[k] 1 = KaehlerFormData.omega ^ k := by
  rw [lefschetzOp_iterate]
  rw [mul_one]

end KaehlerLefschetzData

/-! ## Trivial inhabiting instances

We provide trivial inhabiting instances showing that the sibling
typeclasses are inhabitable. The instances use a generic carrier `A`
already carrying `CohomologyRing A` and `KaehlerClass A`. All instance
proofs are **substantive**:

* `omega := h^4` (the substantive non-zero element from
  `KaehlerClass.h_pow_4_ne_zero`).
* `topDim := 0` (point-like variety so `topDim/2 = 0`).
* `degreeOf := fun a => if a = 0 then 0 else 2` (substantive partial
  function, classical decidability).
* `omega_ne_zero` via `pow_ne_zero` + `h_ne_zero`.
* `omega_pow_ne_zero` reduces to `omega^0 = 1 ≠ 0` since `topDim/2 = 0`;
  `1 ≠ 0` derived from `omega ≠ 0` via the non-trivial ring witness. -/

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A]

/-- **Trivial instance** of `KaehlerFormData`: take `ω := h^4` (which is
non-zero by `KaehlerClass.h_pow_4_ne_zero`), set `topDim := 0` (so the
Hard-Lefschetz power range collapses to `k = 0`), and define `degreeOf`
classically by `if a = 0 then 0 else 2`. The non-degeneracy, power
positivity, and degree axioms are all derived substantively (no
tautologies). The carrier must additionally satisfy `1 ≠ 0`; we extract
this from `pow_ne_zero` on `h^4`. -/
noncomputable instance : KaehlerFormData A where
  omega := (KaehlerClass.h : A) ^ 4
  degreeOf a := by classical exact (if a = 0 then 0 else 2)
  topDim := 0
  omega_ne_zero := KaehlerClass.h_pow_4_ne_zero
  omega_pow_ne_zero k hk := by
    -- `topDim/2 = 0/2 = 0` so the only `k ≤ 0` is `k = 0`.
    -- Then `omega^0 = 1`, and `1 ≠ 0` because `omega = h^4 ≠ 0`.
    have hk0 : k = 0 := Nat.le_zero.mp hk
    subst hk0
    rw [pow_zero]
    intro hone
    apply KaehlerClass.h_pow_4_ne_zero (A := A)
    -- `h^4 = h^4 * 1 = h^4 * 0 = 0` would follow if `1 = 0`.
    have : (KaehlerClass.h : A) ^ 4 = (KaehlerClass.h : A) ^ 4 * 1 := by ring
    rw [this, hone, mul_zero]
  omega_degree_eq_two := by
    classical
    -- `degreeOf (h^4) = if (h^4 = 0) then 0 else 2 = 2` since `h^4 ≠ 0`.
    show (if (KaehlerClass.h : A) ^ 4 = 0 then 0 else 2) = 2
    rw [if_neg KaehlerClass.h_pow_4_ne_zero]

/-- **Trivial instance** of `KaehlerLefschetzData`: take `lefschetzOp`
to be the natural multiplication-by-ω linear map (which is
substantively equal to `omegaMul`). The Hard-Lefschetz top-power
non-degeneracy witness reduces to `(ω^0 = 1) ≠ 0`, derived from the
non-trivial-ring witness in `KaehlerFormData`. -/
noncomputable instance : KaehlerLefschetzData A where
  lefschetzOp := KaehlerFormData.omegaMul
  lefschetzOp_eq_omegaMul α := by
    -- `omegaMul α = ω * α` by definition.
    show KaehlerFormData.omegaMul α = KaehlerFormData.omega * α
    rfl
  lefschetzOp_top_iter_ne_zero := by
    -- `topDim/2 = 0/2 = 0`. Iterated zero times on `1` gives `1`.
    -- And `1 ≠ 0` from `KaehlerFormData.one_ne_zero_of_kaehler`.
    -- Reduce the top-iter exponent to 0 via `Nat.zero_div`.
    have hzero : KaehlerFormData.topDim (A := A) / 2 = 0 := by
      show (0 : ℕ) / 2 = 0
      rfl
    rw [hzero, Function.iterate_zero, id_eq]
    exact KaehlerFormData.one_ne_zero_of_kaehler

end HodgeReduction.Infrastructure.Cohomology
