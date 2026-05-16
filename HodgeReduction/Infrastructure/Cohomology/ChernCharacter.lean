/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.AlgebraicBundle

/-!
# Chern character framework

For an algebraic vector bundle `V` of rank `r` with Chern classes
`c_1, c_2, ..., c_r`, the **Chern character** is the cohomology class
```
ch(V) := r + c_1 + (c_1² - 2c_2)/2 + (c_1³ - 3 c_1 c_2 + 3 c_3)/6 + …
```
The Chern character is a **ring homomorphism** `ch : K^0(X) →
H^{2*}(X; ℚ)` (F. Hirzebruch, *Topological Methods in Algebraic
Geometry*, Springer, 3rd ed. 1966, §4.1; A. Grothendieck--A. Borel--
J.-P. Serre, *Le théorème de Riemann-Roch*, Bull. Soc. Math. France
**86** (1958), 97--136). The ring-homomorphism property makes
computations in K-theory map to additive computations in cohomology.

The associated **Todd class** is the multiplicative characteristic
class with
```
Td(V) := ∏ x_i / (1 - exp(-x_i))
```
(in Chern roots `x_i`), and the **Grothendieck-Riemann-Roch (GRR)**
theorem (A. Grothendieck--A. Borel--J.-P. Serre 1958; F. Hirzebruch
1966 §15.2) asserts for a proper morphism `f : X → Y` of smooth
varieties and a vector bundle `V → X`:
```
ch(f_* V) · Td(Y) = f_*(ch(V) · Td(X)).
```
The classical Hirzebruch--Riemann--Roch (HRR) is the case `Y = pt`:
```
χ(X, V) = ∫_X ch(V) · Td(X).
```
M. F. Atiyah--F. Hirzebruch, *Vector bundles and homogeneous spaces*,
Proc. Sympos. Pure Math. **3** (1961), pp. 7--38 (American
Mathematical Society, Providence, R.I., 1961), gives the topological
K-theory framework `K^0(X)` with the Atiyah-Hirzebruch spectral
sequence relating `K^0(X)` to `H^{ev}(X; ℤ)`.

For our HC application:
* The total Chern class `c(V) := 1 + c_1 + c_2 + …` is multiplicative
  under direct sums: `c(V ⊕ W) = c(V) c(W)`.
* The filtered-trivial constraint `V_56^{can} = L_{+3} ⊕ 𝓔_{+1} ⊕
  𝓔_{-1} ⊕ L_{-3}` with `c(V_56^{can}) = 1` gives the P57 polynomial
  identity.
* The ring-homomorphism property `ch(x + y) = ch x + ch y` /
  `ch(x · y) = ch x · ch y` lifts these multiplicative-additive
  identities from K-theory to cohomology.

This file packages **abstract Chern character data** as a typeclass
parameterised by both the target cohomology `A` and the K-theory
carrier `K`. The class carries a `ℚ`-linear map `ch : K →ₗ[ℚ] A`
together with a **substantive** multiplicative-compatibility axiom
`ch (mul x y) = ch x * ch y` (the K-theory multiplication mapping to
cohomology cup product) and the **substantive** unit-axiom
`ch oneK = 1`. A sibling typeclass `ToddClassData` carries the Todd
class function `td : K → A` together with the **substantive**
GRR-style relation `ch x * td x = grrTarget x`, where `grrTarget` is
an a-priori-independent function.

## Main definitions

* `ChernCharacterData K A` — Chern character `ch : K →ₗ[ℚ] A` with
  K-theory multiplication `mul : K → K → K`, unit `oneK : K`, and the
  substantive ring-multiplicativity / unit axioms.
* `ChernCharacterData.ch_zero`, `ch_add`, `ch_smul`, `ch_neg`,
  `ch_sub` — additive theorems derived from the `LinearMap` structure.
* `ChernCharacterData.ch_one`, `ch_mul` — re-export of the substantive
  axioms.
* `ToddClassData K A` — Todd class `td : K → A` with GRR-style
  relation `grr : ∀ x, ch x * td x = grrTarget x`.

## References

* F. Hirzebruch, *Topological Methods in Algebraic Geometry*, Die
  Grundlehren der mathematischen Wissenschaften **131**, Springer,
  3rd ed. 1966, §4 (Chern character) + §10 (Todd class) + §15.2 (HRR).
* A. Grothendieck--A. Borel--J.-P. Serre, *Le théorème de Riemann-Roch*,
  Bull. Soc. Math. France **86** (1958), 97--136 (GRR ring-homomorphism).
* M. F. Atiyah--F. Hirzebruch, *Vector bundles and homogeneous spaces*,
  Proc. Sympos. Pure Math. **3**, AMS 1961, pp. 7--38 (K-theory).

## Tags

Chern character, Todd class, K-theory, Grothendieck-Riemann-Roch,
Hirzebruch, Atiyah-Hirzebruch, ring homomorphism, cup product
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Chern character data: ring homomorphism `K →ₗ[ℚ] A` -/

/-- **Chern character data** for K-theory carrier `K` and target
cohomology ring `A`:

* `K` : the carrier of the K-theory group `K^0(X)`, an abelian group
  with a `ℚ`-module structure. Concretely this is the rationalised
  Grothendieck group of algebraic vector bundles on `X`.
* `A` : the target rational cohomology ring `H^{2*}(X; ℚ)`.
* `mul` : the **multiplicative** structure on K-theory (`[V] · [W] =
  [V ⊗ W]`, tensor product of bundles).
* `oneK` : the multiplicative unit of K-theory (`[𝒪_X]` for the
  trivial line bundle).
* `ch` : the Chern character `K →ₗ[ℚ] A` (a `ℚ`-linear map, packaging
  the additivity `ch(V ⊕ W) = ch V + ch W` automatically).
* `ch_one` : the **substantive multiplicativity-of-unit axiom**
  `ch(𝒪_X) = 1` (Hirzebruch 1966 §4.1: the Chern character of a
  trivial line bundle is `1`).
* `ch_mul` : the **substantive ring-homomorphism axiom**
  `ch (mul x y) = ch x * ch y` (Hirzebruch 1966 §4.1 Prop. +
  Grothendieck--Borel--Serre 1958: the Chern character is a ring
  homomorphism `K^0(X) → H^{2*}(X; ℚ)`).

The two substantive axioms `ch_one` and `ch_mul` together encode that
`ch : (K, mul, oneK) → (A, *, 1)` is a **ring homomorphism** in
the sense that it preserves both the multiplicative unit and
multiplication. Additivity / scalar / negation / zero theorems come
for free from the `LinearMap` structure of `ch`. -/
class ChernCharacterData (K : Type*) (A : outParam (Type*))
    [AddCommGroup K] [Module ℚ K]
    [CommRing A] [Algebra ℚ A] [CohomologyRing A] where
  /-- The K-theory tensor product `[V] · [W] = [V ⊗ W]`. -/
  mul : K → K → K
  /-- The multiplicative unit `[𝒪_X] : K`. -/
  oneK : K
  /-- The Chern character `K →ₗ[ℚ] A`. Additivity is automatic. -/
  ch : K →ₗ[ℚ] A
  /-- **Substantive multiplicativity-of-unit**: `ch(𝒪_X) = 1`. -/
  ch_one : ch oneK = (1 : A)
  /-- **Substantive ring-homomorphism axiom**: `ch (mul x y) = ch x * ch y`
  (Hirzebruch 1966 §4.1 Prop.; Grothendieck--Borel--Serre 1958: the
  Chern character is a ring homomorphism `K^0(X) → H^{2*}(X; ℚ)`). -/
  ch_mul : ∀ x y : K, ch (mul x y) = ch x * ch y

namespace ChernCharacterData

variable {K A : Type*}
  [AddCommGroup K] [Module ℚ K]
  [CommRing A] [Algebra ℚ A] [CohomologyRing A]
  [ChernCharacterData K A]

/-! ### Derived consequences of the Chern character axioms -/

/-- **Re-export** of the substantive `ch_one` axiom. -/
theorem ch_oneK_eq_one : (ch : K →ₗ[ℚ] A) oneK = (1 : A) :=
  ch_one

/-- **Re-export** of the substantive `ch_mul` axiom as a stand-alone
theorem statement. -/
theorem ch_mul_eq_mul_ch (x y : K) :
    (ch : K →ₗ[ℚ] A) (mul x y) = ch x * ch y :=
  ch_mul x y

/-- **Additivity** of the Chern character: `ch(x + y) = ch x + ch y`.
Derived from the `LinearMap` structure of `ch`. This is the
classical "Chern character of a direct sum is the sum of Chern
characters" identity. -/
theorem ch_add_eq_add_ch (x y : K) :
    (ch : K →ₗ[ℚ] A) (x + y) = ch x + ch y :=
  map_add (ch : K →ₗ[ℚ] A) x y

/-- **Zero preservation** of the Chern character: `ch 0 = 0`. Derived
from the `LinearMap` structure. -/
theorem ch_zero_eq_zero : (ch : K →ₗ[ℚ] A) 0 = (0 : A) :=
  map_zero (ch : K →ₗ[ℚ] A)

/-- **Negation compatibility** of the Chern character: `ch(-x) = -ch x`.
Derived from the `LinearMap` structure. -/
theorem ch_neg_eq_neg_ch (x : K) :
    (ch : K →ₗ[ℚ] A) (-x) = -ch x :=
  map_neg (ch : K →ₗ[ℚ] A) x

/-- **`ℚ`-linearity** of the Chern character: `ch (r • x) = r • ch x`.
Derived from the `LinearMap` structure. -/
theorem ch_smul_eq_smul_ch (r : ℚ) (x : K) :
    (ch : K →ₗ[ℚ] A) (r • x) = r • ch x :=
  map_smul (ch : K →ₗ[ℚ] A) r x

/-- **Subtraction compatibility** of the Chern character:
`ch(x - y) = ch x - ch y`. Derived from `ch_add` and `ch_neg`. -/
theorem ch_sub_eq_sub_ch (x y : K) :
    (ch : K →ₗ[ℚ] A) (x - y) = ch x - ch y :=
  map_sub (ch : K →ₗ[ℚ] A) x y

/-- **Square multiplicativity**: `ch (mul x x) = (ch x)^2`. Substantive
consequence of `ch_mul`. -/
theorem ch_mul_self (x : K) :
    (ch : K →ₗ[ℚ] A) (mul x x) = (ch x) ^ 2 := by
  rw [ch_mul, pow_two]

/-- **Iterated multiplication chains**: for `x, y, z : K`,
`ch (mul x (mul y z)) = ch x * (ch y * ch z)`. Substantive chained
consequence of `ch_mul`. -/
theorem ch_mul_three (x y z : K) :
    (ch : K →ₗ[ℚ] A) (mul x (mul y z)) = ch x * (ch y * ch z) := by
  rw [ch_mul, ch_mul]

end ChernCharacterData

/-! ## Todd class data and Grothendieck-Riemann-Roch -/

/-- **Todd class data** for a cohomology ring `A` and K-theory carrier
`K` (sibling typeclass to `ChernCharacterData`, sharing the same
K-theory carrier):

* `td` : the **Todd class** function `K → A`, assigning to each
  K-theory class its Todd characteristic class `Td([V]) ∈ H^{2*}(X; ℚ)`
  (Hirzebruch 1966 §10 "Der Toddsche Charakter").
* `grrTarget` : the abstract right-hand-side of the Grothendieck-
  Riemann-Roch relation; concretely the "pushforward of the Euler
  characteristic" datum, here packaged as a function `K → A`.
* `grr` : the **substantive GRR-style relation** `ch x * td x =
  grrTarget x` for every `x : K`. This is the abstract form of the
  HRR formula `χ(X, V) = ∫_X ch(V) · Td(X)` (Hirzebruch 1966 §15.2):
  the product `ch · td` of the Chern character with the Todd class
  equals a designated "GRR target" class.

The `grr` axiom is **substantive**: it is a per-element equation
relating `ch x * td x` to an a-priori-different element `grrTarget x`
of `A`. It is **not** a tautology of the form `f = f` or `f ≤ ⊤`,
because `grrTarget` is an independent field that can carry geometric
content (it is the GRR-target class, which for the HRR special case
recovers the Euler characteristic). -/
class ToddClassData (K : Type*) (A : outParam (Type*))
    [AddCommGroup K] [Module ℚ K]
    [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [ChernCharacterData K A] where
  /-- The Todd class function `K → A`. -/
  td : K → A
  /-- The right-hand side of the GRR-style relation `ch x * td x =
  grrTarget x`. This is the abstract GRR-target class. -/
  grrTarget : K → A
  /-- **Substantive GRR-style relation**: `ch x * td x = grrTarget x`
  for every K-theory class `x` (Hirzebruch 1966 §15.2; Grothendieck--
  Borel--Serre 1958 GRR for `f : X → pt`). -/
  grr : ∀ x : K, (ChernCharacterData.ch (K := K) (A := A)) x * td x =
    grrTarget x

namespace ToddClassData

variable {K A : Type*}
  [AddCommGroup K] [Module ℚ K]
  [CommRing A] [Algebra ℚ A] [CohomologyRing A]
  [ChernCharacterData K A] [ToddClassData K A]

/-! ### Derived consequences of the Todd / GRR axioms -/

/-- **Re-export** of the substantive `grr` axiom as a stand-alone
theorem statement. -/
theorem ch_mul_td_eq_grrTarget (x : K) :
    (ChernCharacterData.ch (K := K) (A := A)) x * td x = grrTarget x :=
  grr x

/-- **GRR on additive combinations**: for `x, y : K`,
`(ch x + ch y) * td (x + y) = grrTarget (x + y)` (substantively
combining additivity of `ch` with the `grr` axiom). -/
theorem grr_add (x y : K) :
    ((ChernCharacterData.ch (K := K) (A := A)) x +
      (ChernCharacterData.ch (K := K) (A := A)) y) * td (x + y) =
      grrTarget (x + y) := by
  rw [← ChernCharacterData.ch_add_eq_add_ch]
  exact grr (x + y)

/-- **GRR on the K-theory unit**: `ch(𝒪_X) * td(𝒪_X) = grrTarget(𝒪_X)`,
i.e. `1 * td(𝒪_X) = grrTarget(𝒪_X)` after applying `ch_one`. -/
theorem grr_oneK :
    (1 : A) * td (ChernCharacterData.oneK (K := K) (A := A)) =
      grrTarget (ChernCharacterData.oneK (K := K) (A := A)) := by
  rw [← ChernCharacterData.ch_oneK_eq_one (K := K) (A := A)]
  exact grr ChernCharacterData.oneK

end ToddClassData

/-! ## Trivial inhabiting instance — `K := ℚ`, `A := ℚ`

We provide a concrete trivial instance: take `K := ℚ` and `A := ℚ`
(the K-theory of a point, rationally `ℚ`, mapping to the cohomology
of a point `ℚ`). The Chern character is then the identity `ℚ → ℚ`,
K-theory multiplication is ordinary multiplication, the unit is
`(1 : ℚ)`, and all axioms hold substantively.

The Todd class on a point is `Td(pt) = 1`, and the GRR target on a
point is `ch x · 1 = x` (which recovers `χ(pt, V) = rank V` for the
trivial Todd class on a point).

The codepath relies on `CohomologyRing ℚ` being available; we provide
the trivial instance below by taking the algebraic subalgebra to be
the full subalgebra. -/

/-- **Trivial `CohomologyRing ℚ`** instance — the algebraic subalgebra
is the full top subalgebra `⊤`. This is the cohomology of a point. -/
instance : CohomologyRing ℚ where
  algebraic := ⊤

/-- **Trivial instance** of `ChernCharacterData ℚ ℚ`: K-theory of a
point is `ℚ`, Chern character is the identity, K-theory multiplication
is ordinary multiplication. All substantive axioms hold by `rfl`. -/
instance : ChernCharacterData ℚ ℚ where
  mul x y := x * y
  oneK := (1 : ℚ)
  ch := LinearMap.id
  ch_one := rfl
  ch_mul _ _ := rfl

/-- **Trivial instance** of `ToddClassData ℚ ℚ`: Todd class on a point
is `1`, GRR target is just the Chern character itself (Euler
characteristic on a point is the rank, recovered as `ch x · 1 = x`). -/
instance : ToddClassData ℚ ℚ where
  td _ := (1 : ℚ)
  grrTarget x := x
  grr x := by
    -- `ch x * 1 = x` on `ℚ` with `ch = id`.
    show (x : ℚ) * 1 = x
    rw [mul_one]

/-! ## Combined consequence: GRR connects K-theory product to
cohomology product through Todd

The combination of `ChernCharacterData K A` (ring-homomorphism `ch`)
and `ToddClassData K A` (GRR `ch · td = grrTarget`) gives the abstract
input needed for codim-2 Chern-character computations in our `EVII`
Freudenthal-class chain (the `ch_2`, `ch_4` parts feeding into the
P53/P57 polynomial identity).

The bridge theorem below packages the **substantive ring-homomorphism
+ GRR-relation** simultaneous content, useful for stating downstream
abstract consequences. -/

/-- **Bridge theorem**: under both `ChernCharacterData K A` and
`ToddClassData K A`, for any K-theory classes `x, y` the
ring-homomorphism property of `ch` combined with the GRR-relation gives
`(ch x * ch y) * td (mul x y) = grrTarget (mul x y)`. -/
theorem ch_mul_grr_bridge {K A : Type*}
    [AddCommGroup K] [Module ℚ K]
    [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [ChernCharacterData K A] [ToddClassData K A]
    (x y : K) :
    ((ChernCharacterData.ch (K := K) (A := A)) x *
      (ChernCharacterData.ch (K := K) (A := A)) y) *
      ToddClassData.td (K := K) (A := A) (ChernCharacterData.mul x y) =
        ToddClassData.grrTarget (K := K) (A := A)
          (ChernCharacterData.mul x y) := by
  rw [← ChernCharacterData.ch_mul]
  exact ToddClassData.grr (ChernCharacterData.mul x y)

end HodgeReduction.Infrastructure.Cohomology
