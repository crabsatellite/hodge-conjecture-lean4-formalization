/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.RingTheory.Polynomial.Basic
import HodgeReduction.Infrastructure.AlgebraicGeometry.LineBundle
import HodgeReduction.Infrastructure.AlgebraicGeometry.PicardGroup

/-!
# First Chern class `c_1 : Pic(X) → H²(X; ℚ) ⊆ A` (R6-C)

For a smooth projective variety `X` over `ℂ` (or a compact Kähler
manifold), the **first Chern class** is a group homomorphism

```
c_1 : Pic(X) ⟶ H²(X; ℤ)
```

arising from the exponential exact sequence

```
0 ⟶ 2πi·ℤ ⟶ 𝒪_X ⟶ 𝒪_X^* ⟶ 0
```

The associated long exact sequence in sheaf cohomology gives a
connecting homomorphism `δ : H¹(𝒪_X^*) ⟶ H²(2πi·ℤ) ≃ H²(X; ℤ)`,
which under the identification `Pic(X) ≃ H¹(𝒪_X^*)` yields `c_1`.

For algebraic varieties, `c_1` factors as

```
Pic(X) ⟶ NS(X) ⟶ H²(X; ℤ)
```

(the Néron–Severi factorisation), with kernel `Pic⁰(X)` — the
identity component of the Picard scheme classifying line bundles
algebraically equivalent to `𝒪_X`.

## Lean design

This file sits on top of:

* `LineBundle.lean` (R6-A): provides the typeclass `LineBundleData X`
  and the iso-class quotient `LineBundleData.IsoClass X` with its
  `CommGroup` structure (the multiplicative form of `Pic(X)`).
* `PicardGroup.lean` (R6-B): provides the alias
  `Pic X := LineBundleData.IsoClass X`, the `PicZeroData X` typeclass
  for the `Pic⁰` subgroup, the `NeronSeveri X` quotient, and a
  `ChernOneData X H` typeclass for a `MonoidHom Pic X →* H` with
  generic abelian-group target.

This file is the **rational-cohomology-ring layer**: where R6-B's
`ChernOneData` targets a multiplicative abelian group `H` (suitable
for a torsion-free quotient of `H²(X; ℤ)`), this file's
`FirstChernClassData` targets an **additive** rational cohomology
carrier `A`, with the image landing in a designated `Submodule ℚ A`
representing `H²(X; ℚ)`.

* `FirstChernClassData X A` — the first-Chern-class function
  `c_1 : Pic X → A` (landing in a `H² ⊆ A` submodule), packaged
  with its three homomorphism identities.
* `FirstChernClass_NS_factorisation` — `c_1` factors through
  `NS(X) = Pic(X) / Pic⁰(X)` (i.e. `c_1 ≡ 0` on `Pic⁰`).

## Cat 1 kernel-purity

This file is **Category 1** (kernel-pure): every theorem is derived
via Mathlib + classical logic without invoking `sorry`,
`native_decide`, or broken-link axioms.

## Concrete example

`ConcreteExample` at the bottom of the file specialises the abstract
interface to:

* `X := PolyVar` (a one-point "scheme") with a divisor-degree-style
  `LineBundleData PolyVar` (`Carrier := ℤ`, `tensor := +`,
  `dual := -`, discrete-equality iso).
* `A := Polynomial ℚ`.
* `H² := Submodule.span ℚ {X}` (the `ℚ`-line spanned by `X`).
* `c_1 (classOf n) := (n : ℚ) • Polynomial.X` (sending the divisor of
  degree `n` to the cohomology class `n · h` where `h = X` plays the
  role of the polarisation).

The three homomorphism axioms reduce to: `(m + n) • X = m • X + n • X`,
`0 • X = 0`, `(-n) • X = -(n • X)`, all closed by `simp`/`add_smul`/
`neg_smul`.

## Tags

first Chern class, Picard group, Néron–Severi, line bundle,
exponential exact sequence, cycle class map
-/

namespace HodgeReduction.Infrastructure.AlgebraicGeometry

/-! ## R6-C: `FirstChernClassData` -/

/-- **First Chern class data** for a variety `X` (carrying R6-A
`LineBundleData`) with target a rational cohomology carrier `A`.

Packages the homomorphism `c_1 : Pic X → A` landing in a designated
`H² ⊆ A` submodule, together with the three defining identities:

* `c1_tensor`  — `c_1(L ⊗ M) = c_1(L) + c_1(M)` (tensor → addition).
* `c1_trivial` — `c_1(𝒪_X) = 0` (the trivial bundle has trivial class).
* `c1_dual`    — `c_1(L^∨) = -c_1(L)` (dual is negation).

The pair `(c1_tensor, c1_trivial)` already determines a monoid
homomorphism `(Pic X, *, 1) → (A, +, 0)`; we record `c1_dual`
separately for documentation, even though it follows from the monoid
hom structure on a group.

Cf. `Cohomology/PicardGroup.lean::PicardGroupData` for an alternative
abstraction that targets a `ℚ`-linear map out of `Pic(X)_ℚ`. The
present definition keeps `Pic X` as the multiplicative `CommGroup`
from R6-A and provides the `c_1` map directly. -/
class FirstChernClassData (X : Type*) [LineBundleData X]
    (A : Type*) [CommRing A] [Algebra ℚ A] where
  /-- The `H²(X; ℚ)` submodule of `A` (the target of `c_1`). -/
  H2 : Submodule ℚ A
  /-- The first Chern class as a function. -/
  c1 : Pic X → A
  /-- `c_1(L) ∈ H²(X; ℚ)` for every line bundle `L`. -/
  c1_in_H2 : ∀ L, c1 L ∈ H2
  /-- `c_1` carries tensor product to addition. -/
  c1_tensor : ∀ L M : Pic X, c1 (L * M) = c1 L + c1 M
  /-- `c_1` of the trivial bundle is zero. -/
  c1_trivial : c1 (1 : Pic X) = 0
  /-- `c_1` of the dual is the additive negation. -/
  c1_dual : ∀ L : Pic X, c1 L⁻¹ = - c1 L

namespace FirstChernClassData

variable {X : Type*} [LineBundleData X]
variable {A : Type*} [CommRing A] [Algebra ℚ A]
variable [FirstChernClassData X A]

/-! ### Direct re-exports as named theorems

These restate the typeclass-field identities at theorem level, so
downstream proofs can `rw [c1_tensor_eq]` / `exact c1_trivial_eq` etc.
without spelling out the typeclass-instance projection. -/

/-- Theorem-level restatement of `c1_tensor`. -/
theorem c1_tensor_eq (L M : Pic X) :
    (c1 (L * M) : A) = c1 L + c1 M :=
  FirstChernClassData.c1_tensor L M

/-- Theorem-level restatement of `c1_trivial`. -/
theorem c1_trivial_eq : (c1 (1 : Pic X) : A) = 0 :=
  FirstChernClassData.c1_trivial

/-- Theorem-level restatement of `c1_dual`. -/
theorem c1_dual_eq (L : Pic X) : (c1 L⁻¹ : A) = - c1 L :=
  FirstChernClassData.c1_dual L

/-! ### Derived theorems -/

/-- `c_1` of a division of line bundles is the difference of Chern
classes: `c_1(L ⊗ M^∨) = c_1(L) - c_1(M)`. -/
theorem c1_div (L M : Pic X) :
    (c1 (L / M) : A) = c1 L - c1 M := by
  rw [div_eq_mul_inv, c1_tensor_eq, c1_dual_eq, sub_eq_add_neg]

/-- `c_1` of an `ℕ`-power: `c_1(L^n) = n • c_1(L)`.

Proof: induction on `n`, using `pow_succ` in `Pic X` and
`c1_tensor` to reduce one factor at a time. -/
theorem c1_pow (L : Pic X) (n : ℕ) :
    (c1 (L ^ n) : A) = n • c1 L := by
  induction n with
  | zero =>
      rw [pow_zero, c1_trivial_eq, zero_nsmul]
  | succ k ih =>
      rw [pow_succ, c1_tensor_eq, ih, succ_nsmul]

/-- `c_1` of a `ℤ`-power: `c_1(L^n) = n • c_1(L)`. -/
theorem c1_zpow (L : Pic X) (n : ℤ) :
    (c1 (L ^ n) : A) = n • c1 L := by
  induction n with
  | ofNat k =>
      simp [zpow_natCast, c1_pow, Int.ofNat_eq_coe, natCast_zsmul]
  | negSucc k =>
      rw [zpow_negSucc, c1_dual_eq, c1_pow, negSucc_zsmul]

/-! ### `c_1` as a monoid homomorphism

Bundling `c_1` as a `MulHom Pic X (Multiplicative A)` aligns with
Mathlib's hom hierarchy. R6-B already provides a multiplicative-
target version (`ChernOneData X H`) for generic abelian `H`; here we
expose the bridge to `Multiplicative A` for completeness. -/

/-- `c_1` viewed as a `MulHom` from `Pic X` (under tensor product) into
the additive group `(A, +)` packaged multiplicatively via
`Multiplicative`. This shape is convenient when feeding `c_1` to a
generic monoid-hom API. -/
def c1AsMulHom : Pic X →ₙ* Multiplicative A where
  toFun L := Multiplicative.ofAdd (c1 L)
  map_mul' L M := by
    show Multiplicative.ofAdd (c1 (L * M))
        = Multiplicative.ofAdd (c1 L) * Multiplicative.ofAdd (c1 M)
    rw [c1_tensor_eq]
    rfl

/-! ### Membership in `H²`

These restate the `c1_in_H2` field as derived lemmas about
sums/negations/scalar-multiples/powers landing in `H²` (since `H²` is
a `Submodule` and the Chern classes are in `H²`). They are useful
when proving that linear combinations of Chern classes belong to `H²`. -/

/-- `c_1(L) + c_1(M) ∈ H²` (since each summand is). -/
theorem c1_add_mem_H2 (L M : Pic X) :
    (c1 L + c1 M : A) ∈ FirstChernClassData.H2 (X := X) (A := A) :=
  Submodule.add_mem _ (c1_in_H2 L) (c1_in_H2 M)

/-- `-c_1(L) ∈ H²`. -/
theorem c1_neg_mem_H2 (L : Pic X) :
    (-c1 L : A) ∈ FirstChernClassData.H2 (X := X) (A := A) :=
  Submodule.neg_mem _ (c1_in_H2 L)

/-- `r • c_1(L) ∈ H²` for any rational `r`. -/
theorem c1_smul_mem_H2 (r : ℚ) (L : Pic X) :
    (r • c1 L : A) ∈ FirstChernClassData.H2 (X := X) (A := A) :=
  Submodule.smul_mem _ r (c1_in_H2 L)

/-- `c_1(L^n) ∈ H²` for `n : ℕ` (via `c1_pow` reducing to `n • c_1 L`). -/
theorem c1_pow_mem_H2 (L : Pic X) (n : ℕ) :
    (c1 (L ^ n) : A) ∈ FirstChernClassData.H2 (X := X) (A := A) := by
  rw [c1_pow]
  -- Reduce `n • c_1 L ∈ H²` by induction: `0 • c_1 L = 0 ∈ H²`,
  -- and `(k+1) • c_1 L = c_1 L + k • c_1 L ∈ H²` by `add_mem`.
  induction n with
  | zero =>
      simp
  | succ k ih =>
      rw [succ_nsmul]
      exact Submodule.add_mem _ ih (c1_in_H2 L)

end FirstChernClassData

/-! ## Néron–Severi factorisation -/

/-- **Néron–Severi factorisation** of the first Chern class.

For algebraic varieties, `c_1 : Pic(X) → H²(X; ℤ)` factors through
the Néron–Severi quotient `NS(X) = Pic(X) / Pic⁰(X)`. Equivalently,
`c_1` vanishes on the `Pic⁰` subgroup.

This **typeclass commits** to that factorisation (i.e. the hypothesis
that for the variety at hand, the algebraic-equivalence relation in
`Pic⁰` is finer than the integral-cohomology equivalence). The
content is the single field `c1_trivial_on_picZero`.

The companion typeclass `ChernOneData X H` in R6-B provides the
analogous fact for a multiplicative target `H` via the kernel
inclusion `picZero ≤ MonoidHom.ker c₁`; here we restate it in the
additive-target setting. -/
class FirstChernClass_NS_factorisation (X : Type*) [LineBundleData X]
    [PicZeroData X]
    (A : Type*) [CommRing A] [Algebra ℚ A] [FirstChernClassData X A] : Prop where
  /-- `c_1` is trivial on the `Pic⁰` identity component. -/
  c1_trivial_on_picZero :
    ∀ L ∈ (picZero X : Subgroup (Pic X)),
      (FirstChernClassData.c1 L : A) = 0

namespace FirstChernClass_NS_factorisation

variable {X : Type*} [LineBundleData X] [PicZeroData X]
variable {A : Type*} [CommRing A] [Algebra ℚ A]
variable [FirstChernClassData X A]
variable [FirstChernClass_NS_factorisation X A]

/-- Abstract Lefschetz (1,1) reduction: two line bundles in the same
Néron–Severi class have equal first Chern classes.

This is the "abstract version of *Lefschetz (1,1) reduces to NS*":
once we mod out by `Pic⁰`, the residual class in `NS(X)_ℤ` already
fully determines `c_1` in `H²(X; ℤ)`. -/
theorem c1_eq_of_same_NS_class (L M : Pic X)
    (h : L / M ∈ (picZero X : Subgroup (Pic X))) :
    (FirstChernClassData.c1 L : A) = FirstChernClassData.c1 M := by
  have hLM : (FirstChernClassData.c1 (L / M) : A) = 0 :=
    FirstChernClass_NS_factorisation.c1_trivial_on_picZero (L / M) h
  rw [FirstChernClassData.c1_div] at hLM
  exact sub_eq_zero.mp hLM

end FirstChernClass_NS_factorisation

/-! ## Concrete example: `Polynomial ℚ` with degree-valued `c_1`

We exhibit a minimal concrete instance: take `X := PolyVar` to be a
singleton-carrier "scheme", define `LineBundleData PolyVar` with
`Carrier := ℤ`, `tensor := (+)`, `dual := (-·)`, `iso := Eq` (discrete
setoid), so that `Pic PolyVar = LineBundleData.IsoClass PolyVar ≃ ℤ`
(multiplicatively); then set `c_1 (classOf n) := (n : ℚ) • Polynomial.X`
in the ambient ring `Polynomial ℚ`.

The three Chern-class identities reduce to identities in `ℤ`-valued
classes:
* `tensor (m, n) = m + n` ↦ `(m + n) • X = m • X + n • X` (`add_smul`).
* `trivial = 0` ↦ `0 • X = 0` (`zero_smul`).
* `dual n = -n` ↦ `(-n) • X = -(n • X)` (`neg_smul`).

Each is dispatched by `simp` + `Quotient.inductionOn` to descend to
the carrier-level identity.

The R6-B default instance `picZero_trivial` automatically gives
`PicZeroData PolyVar` with `picZero := ⊥`, so `Pic⁰` is trivial and
`NS(PolyVar) = Pic(PolyVar)` — the Néron–Severi factorisation is
vacuous (the only `L ∈ Pic⁰` is `1`, on which `c_1 = 0` by
`c1_trivial`). -/

namespace ConcreteExample

open Polynomial

/-- A trivial carrier for the concrete example. -/
def PolyVar : Type := Unit

/-- The `LineBundleData PolyVar` instance: line bundles on `PolyVar`
are classified by an integer degree, with tensor product adding
degrees, dual negating, and the discrete-equality iso (two bundles are
iso iff they have the same degree).

This gives `Pic PolyVar = LineBundleData.IsoClass PolyVar ≃ ℤ` as a
commutative group (multiplicatively). -/
instance instLineBundleData : LineBundleData PolyVar where
  Carrier := ℤ
  trivial := 0
  tensor := fun m n => m + n
  dual := fun n => -n
  iso :=
    { r := fun m n => m = n
      iseqv :=
        { refl := fun _ => rfl
          symm := fun h => h.symm
          trans := fun h₁ h₂ => h₁.trans h₂ } }
  tensor_respects_iso := by
    intro L₁ L₂ M₁ M₂ hL hM
    show L₁ + M₁ = L₂ + M₂
    rw [hL, hM]
  dual_respects_iso := by
    intro L M h
    show -L = -M
    rw [h]
  tensor_trivial_left := by
    intro L
    show (0 : ℤ) + L = L
    exact zero_add L
  tensor_dual_right := by
    intro L
    show L + (-L) = (0 : ℤ)
    exact add_neg_cancel L
  tensor_comm := by
    intro L M
    show L + M = M + L
    exact add_comm L M
  tensor_assoc := by
    intro L M N
    show (L + M) + N = L + (M + N)
    exact add_assoc L M N

/-- The "degree" of a line bundle on `PolyVar`, descended to iso
classes. Concretely: `Pic PolyVar = LineBundleData.IsoClass PolyVar`
is the quotient of `ℤ` by discrete equality, so iso-class of `n` is
just `n` itself (up to canonical iso). The descent below is the
canonical liftOn. -/
def degree (L : Pic PolyVar) : ℤ :=
  Quotient.liftOn L (fun (n : ℤ) => n) (fun _ _ h => h)

@[simp]
theorem degree_classOf (n : ℤ) :
    degree (LineBundleData.classOf (X := PolyVar) n) = n :=
  rfl

@[simp]
theorem degree_one : degree (1 : Pic PolyVar) = 0 :=
  rfl

@[simp]
theorem degree_mul (L M : Pic PolyVar) :
    degree (L * M) = degree L + degree M := by
  refine Quotient.inductionOn₂ L M (fun m n => ?_)
  show degree (LineBundleData.classOf (X := PolyVar) m
                * LineBundleData.classOf (X := PolyVar) n)
      = degree (LineBundleData.classOf (X := PolyVar) m)
        + degree (LineBundleData.classOf (X := PolyVar) n)
  rw [LineBundleData.mul_classOf]
  -- `tensor m n = m + n` definitionally, so `classOf (tensor m n) = classOf (m+n)`.
  rfl

@[simp]
theorem degree_inv (L : Pic PolyVar) :
    degree L⁻¹ = - degree L := by
  refine Quotient.inductionOn L (fun n => ?_)
  show degree (LineBundleData.classOf (X := PolyVar) n)⁻¹
      = - degree (LineBundleData.classOf (X := PolyVar) n)
  rw [LineBundleData.inv_classOf]
  -- `dual n = -n` definitionally.
  rfl

/-- The concrete `FirstChernClassData` on `(PolyVar, Polynomial ℚ)`.

* `H²` is the `ℚ`-line spanned by `Polynomial.X`.
* `c_1 L = (degree L : ℚ) • Polynomial.X`. -/
noncomputable instance instFirstChernClassData :
    FirstChernClassData PolyVar (Polynomial ℚ) where
  H2 := Submodule.span ℚ ({(Polynomial.X : Polynomial ℚ)} : Set (Polynomial ℚ))
  c1 := fun L => ((degree L : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ)
  c1_in_H2 := by
    intro L
    -- `r • X ∈ Submodule.span ℚ {X}` via the singleton-span membership lemma.
    exact Submodule.smul_mem _ _ (Submodule.subset_span (Set.mem_singleton _))
  c1_tensor := by
    intro L M
    show ((degree (L * M) : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ)
        = ((degree L : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ)
          + ((degree M : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ)
    rw [degree_mul]
    push_cast
    rw [add_smul]
  c1_trivial := by
    show ((degree (1 : Pic PolyVar) : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ) = 0
    rw [degree_one]
    simp
  c1_dual := by
    intro L
    show ((degree L⁻¹ : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ)
        = - (((degree L : ℤ) : ℚ) • (Polynomial.X : Polynomial ℚ))
    rw [degree_inv]
    push_cast
    rw [neg_smul]

/-- **Sanity check**: `c_1 (classOf 3 ⊗ classOf 5) = c_1 (classOf 3) + c_1 (classOf 5)`.

Concretely, both sides equal `8 • Polynomial.X`. -/
example :
    FirstChernClassData.c1 (X := PolyVar) (A := Polynomial ℚ)
        (LineBundleData.classOf (X := PolyVar) (3 : ℤ)
          * LineBundleData.classOf (X := PolyVar) (5 : ℤ))
      = FirstChernClassData.c1 (X := PolyVar) (A := Polynomial ℚ)
            (LineBundleData.classOf (X := PolyVar) (3 : ℤ))
          + FirstChernClassData.c1 (X := PolyVar) (A := Polynomial ℚ)
            (LineBundleData.classOf (X := PolyVar) (5 : ℤ)) :=
  FirstChernClassData.c1_tensor_eq (X := PolyVar) (A := Polynomial ℚ) _ _

/-- **Sanity check**: `c_1 (𝒪_X) = 0` concretely. -/
example :
    FirstChernClassData.c1 (X := PolyVar) (A := Polynomial ℚ) (1 : Pic PolyVar) = 0 :=
  FirstChernClassData.c1_trivial_eq (X := PolyVar) (A := Polynomial ℚ)

/-- **Sanity check**: `c_1 (L^n) = n • c_1 L` for the concrete instance. -/
example (n : ℕ) :
    FirstChernClassData.c1 (X := PolyVar) (A := Polynomial ℚ)
        ((LineBundleData.classOf (X := PolyVar) (1 : ℤ)) ^ n)
      = n • FirstChernClassData.c1 (X := PolyVar) (A := Polynomial ℚ)
              (LineBundleData.classOf (X := PolyVar) (1 : ℤ)) :=
  FirstChernClassData.c1_pow (X := PolyVar) (A := Polynomial ℚ) _ n

/-- The concrete `c_1` is **trivial on `Pic⁰`** (vacuously, since
`Pic⁰ = ⊥` from R6-B's `picZero_trivial` default instance). Therefore
`c_1` factors through `NS(PolyVar) = Pic(PolyVar) / 0 = Pic(PolyVar) = ℤ`. -/
instance : FirstChernClass_NS_factorisation PolyVar (Polynomial ℚ) where
  c1_trivial_on_picZero := by
    intro L hL
    -- `picZero PolyVar = ⊥` from R6-B's `picZero_trivial` default instance.
    have hL' : L ∈ (⊥ : Subgroup (Pic PolyVar)) := hL
    rw [Subgroup.mem_bot] at hL'
    subst hL'
    exact FirstChernClassData.c1_trivial_eq

end ConcreteExample

/-! ## Phase 4 audit: kernel-purity diagnostic

Uncomment any of the lines below to inspect the axiom dependencies
of the derived theorems. Verified output (R6-C audit, 2026-05-16):
all 13 entries depend only on `[propext, Classical.choice, Quot.sound]`
(the kernel-pure axiom set). `instLineBundleData` requires `[propext]`
only. No `sorry`, no `native_decide`, no broken-link axioms.

```
-- #print axioms FirstChernClassData.c1_tensor_eq
-- #print axioms FirstChernClassData.c1_trivial_eq
-- #print axioms FirstChernClassData.c1_dual_eq
-- #print axioms FirstChernClassData.c1_div
-- #print axioms FirstChernClassData.c1_pow
-- #print axioms FirstChernClassData.c1_zpow
-- #print axioms FirstChernClassData.c1_add_mem_H2
-- #print axioms FirstChernClassData.c1_neg_mem_H2
-- #print axioms FirstChernClassData.c1_smul_mem_H2
-- #print axioms FirstChernClassData.c1_pow_mem_H2
-- #print axioms FirstChernClass_NS_factorisation.c1_eq_of_same_NS_class
-- #print axioms ConcreteExample.instFirstChernClassData
-- #print axioms ConcreteExample.instLineBundleData
```
-/

end HodgeReduction.Infrastructure.AlgebraicGeometry
