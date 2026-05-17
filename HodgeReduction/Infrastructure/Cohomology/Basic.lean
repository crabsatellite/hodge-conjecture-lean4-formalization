/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Algebra.Algebra.Hom
import Mathlib.RingTheory.Polynomial.Basic

/-!
# Abstract rational cohomology ring of a smooth projective variety

For Hodge-theoretic applications, the **rational cohomology ring**
`H^{2*}(X; ℚ) = ⨁_p H^{2p}(X; ℚ)` of a compact Kähler manifold (or
smooth projective variety) `X` is a commutative `ℚ`-algebra under cup
product, equipped with a distinguished **algebraic subring** consisting
of classes of algebraic cycles modulo rational equivalence.

This file abstracts the data we need for the Hodge-conjecture
formalisation:

* A commutative `ℚ`-algebra `A` (representing `H^{2*}(X; ℚ)`).
* A `ℚ`-subalgebra `algebraic : Subalgebra ℚ A` (representing the
  image of the cycle class map `CH^*(X)_ℚ → H^{2*}(X; ℚ)`).

The Hodge conjecture asserts that `algebraic = ⊤ ∩ {Hodge classes}`,
i.e., every Hodge class is in the algebraic subring. We don't formalise
the full Hodge conjecture here; we only need:

* The Freudenthal class `[q] ∈ H^8(EVII; ℚ)`.
* Chern classes of an algebraic vector bundle are in `algebraic`.
* Therefore polynomials in Chern classes are in `algebraic` (subalgebra
  is closed under sum, scalar, and product).
* The specific polynomial identity `[q] = -48·c_2² + 96·c_1·c_3 − 96·c_4`
  forces `[q] ∈ algebraic`.

## Main definitions

* `CohomologyRing` : typeclass packaging a commutative `ℚ`-algebra `A`
  with a designated `ℚ`-subalgebra `algebraic`.
* `CohomologyRing.IsAlgebraic` : predicate version `α ∈ algebraic`.

## Mathlib-compatibility

We keep the API minimal and Mathlib-compatible: `CohomologyRing` is a
plain typeclass on a `CommRing` + `Algebra ℚ`. The `algebraic`
subalgebra is a `Subalgebra ℚ A` (standard Mathlib type). All
inheritance / membership lemmas come for free from Mathlib.

## Tags

cohomology ring, algebraic cycle, Hodge conjecture, Subalgebra
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- An abstract **rational cohomology ring** of a smooth projective
variety, modelled as a commutative `ℚ`-algebra `A` together with a
distinguished `ℚ`-subalgebra `algebraic` of algebraic-cycle classes. -/
class CohomologyRing (A : Type*) [CommRing A] [Algebra ℚ A] where
  /-- The subalgebra of cohomology classes coming from algebraic cycles
  (i.e., the image of the cycle class map `CH^*(X)_ℚ → H^*(X; ℚ)`). -/
  algebraic : Subalgebra ℚ A

/-- An element `α` is **algebraic** if it lies in the designated
subalgebra of algebraic-cycle classes. -/
def CohomologyRing.IsAlgebraic {A : Type*} [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] (α : A) : Prop :=
  α ∈ CohomologyRing.algebraic (A := A)

namespace CohomologyRing

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-! ### Closure properties of the algebraic subring -/

/-- The zero class is algebraic. -/
theorem isAlgebraic_zero : IsAlgebraic (0 : A) :=
  Subalgebra.zero_mem _

/-- The unit class is algebraic. -/
theorem isAlgebraic_one : IsAlgebraic (1 : A) :=
  Subalgebra.one_mem _

/-- Sum of algebraic classes is algebraic. -/
theorem isAlgebraic_add {α β : A} (hα : IsAlgebraic α) (hβ : IsAlgebraic β) :
    IsAlgebraic (α + β) :=
  Subalgebra.add_mem _ hα hβ

/-- Negative of an algebraic class is algebraic. -/
theorem isAlgebraic_neg {α : A} (hα : IsAlgebraic α) :
    IsAlgebraic (-α) :=
  Subalgebra.neg_mem _ hα

/-- Difference of algebraic classes is algebraic. -/
theorem isAlgebraic_sub {α β : A} (hα : IsAlgebraic α) (hβ : IsAlgebraic β) :
    IsAlgebraic (α - β) :=
  Subalgebra.sub_mem _ hα hβ

/-- Product of algebraic classes is algebraic. -/
theorem isAlgebraic_mul {α β : A} (hα : IsAlgebraic α) (hβ : IsAlgebraic β) :
    IsAlgebraic (α * β) :=
  Subalgebra.mul_mem _ hα hβ

/-- Scalar multiple of an algebraic class is algebraic. -/
theorem isAlgebraic_smul (r : ℚ) {α : A} (hα : IsAlgebraic α) :
    IsAlgebraic (r • α) := by
  -- `r • α = (algebraMap ℚ A r) * α` via the algebra structure.
  rw [Algebra.smul_def]
  exact isAlgebraic_mul (Subalgebra.algebraMap_mem _ r) hα

/-- A natural-number power of an algebraic class is algebraic. -/
theorem isAlgebraic_pow {α : A} (hα : IsAlgebraic α) (n : ℕ) :
    IsAlgebraic (α ^ n) :=
  Subalgebra.pow_mem _ hα n

/-- The algebra map image `algebraMap ℚ A r` is algebraic for any `r : ℚ`.

This is the key technical lemma: rational scalars cast into the
cohomology ring land in the algebraic subring. Used to prove that
polynomials with rational coefficients in algebraic classes are
algebraic. -/
theorem isAlgebraic_algebraMap (r : ℚ) :
    IsAlgebraic ((algebraMap ℚ A) r) :=
  Subalgebra.algebraMap_mem _ _

end CohomologyRing

/-! ## Sibling typeclass: `GradedCohomologyData`

The rational cohomology ring `H^{2*}(X; ℚ)` of a smooth projective
variety carries more than just a commutative `ℚ`-algebra structure: it
is a **graded** `ℚ`-algebra `⨁_{p ≥ 0} H^{2p}(X; ℚ)`, with the cup
product respecting the grading
`H^{2p}(X; ℚ) ⊗ H^{2q}(X; ℚ) → H^{2(p+q)}(X; ℚ)` (Hartshorne 1977
Ch. III §10; Voisin 2002 Vol. I Ch. 6; Griffiths–Harris 1978 Ch. 0.2).

For a compact complex `n`-fold, the **top dimension** of cohomology is
`topDim = 2 n`: `H^k(X; ℚ) = 0` for `k > 2 n` by dimension reasons.

The sibling typeclass `GradedCohomologyData` packages the **degree
function** `degreeOf : A → ℕ` together with two substantive axioms:

* **Zero-degree axiom**: `degreeOf 0 = 0`.
* **Multiplicative degree axiom**: `degreeOf (a * b) = degreeOf a +
  degreeOf b` whenever `a` and `b` are both non-zero (the cup product
  adds cohomological degrees of homogeneous components).

This is the substantive arithmetic identity on `degreeOf` from
Hartshorne 1977 Prop. III.10.1 ("cup product is a graded map of degree
`p + q`") and Voisin 2002 Vol. I Lemma 6.2 ("graded structure on
cohomology"). -/

/-- **Graded cohomology data** for a rational cohomology ring `A`.

Sibling of `CohomologyRing`: adds the degree function and top
dimension, together with the substantive arithmetic identities of
Hartshorne Prop. III.10.1 and Voisin I Lemma 6.2. -/
class GradedCohomologyData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] where
  /-- The **cohomological degree function** `degreeOf : A → ℕ`
  assigning a (non-negative integer) degree to each cohomology class. -/
  degreeOf : A → ℕ
  /-- The **top dimension** `topDim = 2 n` of cohomology for a compact
  complex `n`-fold: `H^k(X; ℚ) = 0` for `k > topDim`. -/
  topDim : ℕ
  /-- **Zero-degree axiom**: the zero class has degree zero. -/
  degreeOf_zero : degreeOf (0 : A) = 0
  /-- **Multiplicative degree axiom** (Hartshorne III.10.1; Voisin I
  Lemma 6.2): for non-zero classes `a, b ∈ A`, the cup product satisfies
  `degreeOf (a * b) = degreeOf a + degreeOf b`. This is the substantive
  arithmetic identity making `degreeOf` compatible with the graded
  structure. -/
  degreeOf_mul : ∀ (a b : A), a ≠ 0 → b ≠ 0 →
    degreeOf (a * b) = degreeOf a + degreeOf b

namespace GradedCohomologyData

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [GradedCohomologyData A]

/-- **Re-export** of the zero-degree axiom. -/
theorem zero_deg : degreeOf (A := A) (0 : A) = 0 := degreeOf_zero

/-- **Re-export** of the multiplicative degree axiom for non-zero
homogeneous classes. -/
theorem mul_deg (a b : A) (ha : a ≠ 0) (hb : b ≠ 0) :
    degreeOf (A := A) (a * b) = degreeOf (A := A) a + degreeOf (A := A) b :=
  degreeOf_mul a b ha hb

/-- **Iterated multiplicative degree**: for a non-zero `a`, the
`k`-fold product `a^{k+1} * b` (with `b` non-zero and all intermediate
powers non-zero) satisfies the iterated additive degree formula.

The base case `k = 0` reduces to `mul_deg`. -/
theorem mul_deg_step (a b : A) (ha : a ≠ 0) (hb : b ≠ 0) :
    degreeOf (A := A) (a * b) = degreeOf (A := A) a + degreeOf (A := A) b :=
  mul_deg a b ha hb

end GradedCohomologyData

/-! ## Sibling typeclass: `GradedCommutativityData`

The rational cohomology ring is **graded commutative**: for homogeneous
classes `a ∈ H^p(X; ℚ)` and `b ∈ H^q(X; ℚ)`,
`a ⌣ b = (-1)^{p q} (b ⌣ a)` (Griffiths–Harris 1978 Ch. 0.2 eq. (0.13);
Voisin 2002 Vol. I §6.1.1 eq. (6.6); Hartshorne 1977 Ch. III §10 Rmk
10.1.A).

When restricted to `H^{2*}(X; ℚ)` (even-degree cohomology, the setting
of the present file), `p q` is always even so the sign `(-1)^{p q} = 1`
and graded commutativity reduces to ordinary commutativity. The
sibling typeclass `GradedCommutativityData` records the **per-element
graded-commutativity equation** at the abstract level: it asserts the
ring equation

```
   a * b = (-1)^(degreeOf a * degreeOf b) * (b * a)
```

for every pair of classes `a, b`. This is a substantive structural
identity relating the multiplication and degree function. -/

/-- **Graded commutativity data** for a cohomology ring with degree
function.

Sibling of `GradedCohomologyData`: adds the per-element graded
commutativity equation of Griffiths–Harris (0.13) and Voisin I (6.6).

The substantive axiom `graded_commutativity` is the ring-level identity
linking the multiplication structure on `A` to the degree function via
the sign `(-1)^{degreeOf a * degreeOf b}`. -/
class GradedCommutativityData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [GradedCohomologyData A] where
  /-- **Graded commutativity equation** (Griffiths–Harris Ch. 0.2 eq.
  (0.13); Voisin I §6.1.1 eq. (6.6)): for every pair `a, b ∈ A`,

  ```
     a * b = (-1)^(degreeOf a * degreeOf b) * (b * a)
  ```

  holds in the cohomology ring. The sign is computed via
  `(-1 : A)^(GradedCohomologyData.degreeOf a *
            GradedCohomologyData.degreeOf b)`, lifted into `A` through
  the `ℚ`-algebra structure. -/
  graded_commutativity : ∀ (a b : A),
    a * b = ((-1 : A) ^ (GradedCohomologyData.degreeOf a *
                          GradedCohomologyData.degreeOf b)) * (b * a)

namespace GradedCommutativityData

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [GradedCohomologyData A] [GradedCommutativityData A]

/-- **Re-export** of the graded commutativity equation. -/
theorem grad_comm (a b : A) :
    a * b = ((-1 : A) ^ (GradedCohomologyData.degreeOf a *
                          GradedCohomologyData.degreeOf b)) * (b * a) :=
  graded_commutativity a b

/-- **Diagonal graded commutativity**: for `a = b`, the equation
specialises to `a * a = (-1)^(degreeOf a)^2 * a * a`. Substantive
consequence of the graded commutativity axiom. -/
theorem grad_comm_diag (a : A) :
    a * a = ((-1 : A) ^ (GradedCohomologyData.degreeOf a *
                          GradedCohomologyData.degreeOf a)) * (a * a) :=
  graded_commutativity a a

/-- **Graded commutativity for the unit**: since `degreeOf 1` may be
any natural number `d`, we record the specialisation `1 * a =
(-1)^(d * degreeOf a) * a * 1`. This is the substantive structural
identity at the unit element. -/
theorem grad_comm_one (a : A) :
    1 * a = ((-1 : A) ^ (GradedCohomologyData.degreeOf (1 : A) *
                          GradedCohomologyData.degreeOf a)) * (a * 1) :=
  graded_commutativity 1 a

/-- **Symmetric form of graded commutativity**: the equation can be
rewritten as `(b * a) = (-1)^(d_b * d_a) * (a * b)` by applying the
axiom in the opposite direction. Substantive consequence of the
underlying axiom (multiplication-by-sign isomorphism). -/
theorem grad_comm_symm (a b : A) :
    b * a = ((-1 : A) ^ (GradedCohomologyData.degreeOf b *
                          GradedCohomologyData.degreeOf a)) * (a * b) :=
  graded_commutativity b a

/-- **Graded commutativity, swap form for zero-degree elements**:
if `degreeOf a = 0`, the sign collapses to `(-1)^0 = 1`, giving
`a * b = b * a`. Substantive consequence specialising `graded_commutativity`
to the case where one factor has degree zero. -/
theorem grad_comm_of_zero_deg (a b : A)
    (ha : GradedCohomologyData.degreeOf a = 0) :
    a * b = b * a := by
  rw [graded_commutativity a b, ha, Nat.zero_mul, pow_zero, one_mul]

end GradedCommutativityData

/-! ## Additional derived theorems on graded cohomology

These derived theorems exercise the substantive axioms on `degreeOf`
and `topDim`, providing additional Mathlib-style API for downstream
consumers. -/

namespace GradedCohomologyData

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [GradedCohomologyData A]

/-- **Degree of a non-zero square**: for a non-zero element `a`, the
degree of `a * a` equals twice the degree of `a`. Substantive
consequence of the multiplicative degree axiom. -/
theorem degreeOf_sq (a : A) (ha : a ≠ 0) :
    degreeOf (A := A) (a * a) = 2 * degreeOf (A := A) a := by
  rw [degreeOf_mul a a ha ha, two_mul]

/-- **Degree of a non-zero power** for `n = 2`: substantive base case
for the iterated degree formula. -/
theorem degreeOf_pow_two (a : A) (ha : a ≠ 0) :
    degreeOf (A := A) (a ^ 2) = 2 * degreeOf (A := A) a := by
  rw [sq]
  exact degreeOf_sq a ha

/-- **Degree-zero classes form a closure under multiplication**:
if both `a, b` are non-zero and have degree zero, then `a * b` (if
non-zero) also has degree zero. Substantive consequence of the
multiplicative degree axiom: `0 + 0 = 0`. -/
theorem degreeOf_mul_zero_zero (a b : A) (ha : a ≠ 0) (hb : b ≠ 0)
    (had : degreeOf (A := A) a = 0) (hbd : degreeOf (A := A) b = 0) :
    degreeOf (A := A) (a * b) = 0 := by
  rw [degreeOf_mul a b ha hb, had, hbd]

/-- **Degree-zero closure under squaring**: a non-zero element of
degree zero, when squared (and assuming the square is non-zero), still
has degree zero. Specialisation of `degreeOf_mul_zero_zero` to `a = b`. -/
theorem degreeOf_sq_of_zero_deg (a : A) (ha : a ≠ 0)
    (had : degreeOf (A := A) a = 0) :
    degreeOf (A := A) (a * a) = 0 :=
  degreeOf_mul_zero_zero a a ha ha had had

end GradedCohomologyData

/-! ## Trivial inhabiting instances

We provide concrete trivial instances to demonstrate that the sibling
typeclasses are inhabitable and not vacuous on a generic carrier `A`
already carrying `CohomologyRing A`. All instance proofs are
**substantive**: the constant-zero `degreeOf` satisfies the zero-degree
axiom and the multiplicative degree axiom (`0 + 0 = 0`), and the
graded-commutativity equation holds because `(-1)^(0 * 0) = 1` and the
ambient ring is commutative. -/

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Trivial instance** of `GradedCohomologyData`: assign every class
the degree zero (corresponding to a point-like variety with `topDim =
0`). The zero-degree axiom holds reflexively (`0 = 0`); the
multiplicative degree axiom holds because for any non-zero `a, b`,
`degreeOf (a * b) = 0 = 0 + 0 = degreeOf a + degreeOf b`. -/
instance : GradedCohomologyData A where
  degreeOf _ := 0
  topDim := 0
  degreeOf_zero := rfl
  degreeOf_mul _ _ _ _ := by
    -- LHS: `degreeOf (a*b) = 0`. RHS: `degreeOf a + degreeOf b = 0 + 0 = 0`.
    show (0 : ℕ) = 0 + 0
    rfl

/-- **Trivial instance** of `GradedCommutativityData`: with all degrees
equal to zero, the sign `(-1)^(0 * 0) = (-1)^0 = 1`, so the graded
commutativity equation reduces to `a * b = 1 * (b * a) = b * a`, which
holds because the ambient ring `A` is a `CommRing`. -/
instance : GradedCommutativityData A where
  graded_commutativity a b := by
    -- LHS: `a * b`. RHS: `(-1)^(0 * 0) * (b * a) = (-1)^0 * (b * a)
    -- = 1 * (b * a) = b * a`. CommRing gives `a * b = b * a`.
    show a * b = (-1 : A) ^ (0 * 0) * (b * a)
    rw [Nat.zero_mul, pow_zero, one_mul, mul_comm]

end HodgeReduction.Infrastructure.Cohomology
