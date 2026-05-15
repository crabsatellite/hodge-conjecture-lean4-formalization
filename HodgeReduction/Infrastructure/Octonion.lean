/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Algebra.Module.Basic
import Mathlib.Algebra.Group.Basic

/-!
# Octonions over `ℚ` (8-dimensional non-associative `ℚ`-algebra)

This file provides a **concrete elementary construction** of the
octonion algebra over `ℚ` using an explicit Fano-plane multiplication
table on 8 basis elements `e₀ = 1, e₁, e₂, …, e₇`.

The octonions form an 8-dimensional **non-associative** but **alternative**
composition algebra over `ℚ`. They are the largest of the four normed
division algebras (`ℝ ⊂ ℂ ⊂ ℍ ⊂ 𝕆`) given by the Cayley-Dickson
construction.

## Main definitions

* `OctonionQ` — structure with 8 fields `e0, e1, …, e7 : ℚ`.
* Addition, negation, scalar multiplication (componentwise).
* Multiplication via the standard Fano-plane rules.
* `OctonionQ.conj` — octonion conjugation `x̄`.
* `OctonionQ.normSq` — `‖x‖² = Σ xᵢ²` (composition norm).
* `OctonionQ.re` — real part `e₀`.

## Fano-plane multiplication convention

We use the convention compatible with Cayley-Dickson:
```
  e_1 · e_2 = e_3,   e_1 · e_4 = e_5,   e_1 · e_6 = e_7,
  e_2 · e_4 = e_6,   e_2 · e_7 = e_5,
  e_3 · e_4 = e_7,   e_3 · e_5 = e_6.
```
All other products of distinct `e_i · e_j` (`i, j ∈ 1..7`) follow from
anti-commutativity `e_j · e_i = -e_i · e_j` and the 7 Fano-plane lines.

## Future work

* Verify alternative-algebra axioms `(x·x)·y = x·(x·y)` and
  `(y·x)·x = y·(x·x)` (octonions are non-associative but alternative).
* Verify composition axiom `‖x·y‖² = ‖x‖²·‖y‖²` (Hurwitz / Cayley-Dickson).
* Construct `J₃(𝕆)` exceptional Jordan algebra.
* Compute `N(𝟙) = 27` for the all-ones element in J₃(𝕆) weight basis.

## References

* J. C. Baez, "The octonions", Bull. Amer. Math. Soc. **39** (2002), 145-205.
* T. A. Springer, F. D. Veldkamp, *Octonions, Jordan Algebras, and
  Exceptional Groups*, Springer Monographs in Mathematics, 2000.

## Tags

octonion, Cayley-Dickson, alternative algebra, composition algebra,
Fano plane
-/

namespace HodgeReduction.Infrastructure

/-- The octonion algebra `𝕆` over `ℚ` as an 8-tuple. Components
correspond to coefficients of basis vectors `e₀ = 1, e₁, …, e₇`. -/
@[ext]
structure OctonionQ where
  /-- The real (`e₀`) coefficient. -/
  e0 : ℚ
  /-- The `e₁` coefficient. -/
  e1 : ℚ
  /-- The `e₂` coefficient. -/
  e2 : ℚ
  /-- The `e₃` coefficient. -/
  e3 : ℚ
  /-- The `e₄` coefficient. -/
  e4 : ℚ
  /-- The `e₅` coefficient. -/
  e5 : ℚ
  /-- The `e₆` coefficient. -/
  e6 : ℚ
  /-- The `e₇` coefficient. -/
  e7 : ℚ
deriving DecidableEq

namespace OctonionQ

/-! ### Algebraic structure: `Zero`, `One`, `Add`, `Neg`, `SMul ℚ`, `Mul` -/

instance : Zero OctonionQ := ⟨⟨0, 0, 0, 0, 0, 0, 0, 0⟩⟩

instance : One OctonionQ := ⟨⟨1, 0, 0, 0, 0, 0, 0, 0⟩⟩

instance : Add OctonionQ := ⟨fun x y => ⟨
  x.e0 + y.e0, x.e1 + y.e1, x.e2 + y.e2, x.e3 + y.e3,
  x.e4 + y.e4, x.e5 + y.e5, x.e6 + y.e6, x.e7 + y.e7⟩⟩

instance : Neg OctonionQ := ⟨fun x => ⟨
  -x.e0, -x.e1, -x.e2, -x.e3, -x.e4, -x.e5, -x.e6, -x.e7⟩⟩

instance : Sub OctonionQ := ⟨fun x y => x + (-y)⟩

instance : SMul ℚ OctonionQ := ⟨fun r x => ⟨
  r * x.e0, r * x.e1, r * x.e2, r * x.e3,
  r * x.e4, r * x.e5, r * x.e6, r * x.e7⟩⟩

/-- Octonion multiplication using standard Fano-plane convention. -/
instance : Mul OctonionQ := ⟨fun x y => {
  e0 := x.e0*y.e0 - x.e1*y.e1 - x.e2*y.e2 - x.e3*y.e3
        - x.e4*y.e4 - x.e5*y.e5 - x.e6*y.e6 - x.e7*y.e7
  e1 := x.e0*y.e1 + x.e1*y.e0 + x.e2*y.e3 - x.e3*y.e2
        + x.e4*y.e5 - x.e5*y.e4 - x.e6*y.e7 + x.e7*y.e6
  e2 := x.e0*y.e2 - x.e1*y.e3 + x.e2*y.e0 + x.e3*y.e1
        + x.e4*y.e6 + x.e5*y.e7 - x.e6*y.e4 - x.e7*y.e5
  e3 := x.e0*y.e3 + x.e1*y.e2 - x.e2*y.e1 + x.e3*y.e0
        + x.e4*y.e7 - x.e5*y.e6 + x.e6*y.e5 - x.e7*y.e4
  e4 := x.e0*y.e4 - x.e1*y.e5 - x.e2*y.e6 - x.e3*y.e7
        + x.e4*y.e0 + x.e5*y.e1 + x.e6*y.e2 + x.e7*y.e3
  e5 := x.e0*y.e5 + x.e1*y.e4 - x.e2*y.e7 + x.e3*y.e6
        - x.e4*y.e1 + x.e5*y.e0 - x.e6*y.e3 + x.e7*y.e2
  e6 := x.e0*y.e6 + x.e1*y.e7 + x.e2*y.e4 - x.e3*y.e5
        - x.e4*y.e2 + x.e5*y.e3 + x.e6*y.e0 - x.e7*y.e1
  e7 := x.e0*y.e7 - x.e1*y.e6 + x.e2*y.e5 + x.e3*y.e4
        - x.e4*y.e3 - x.e5*y.e2 + x.e6*y.e1 + x.e7*y.e0
}⟩

/-! ### Component lemmas -/

@[simp] theorem zero_e0 : (0 : OctonionQ).e0 = 0 := rfl
@[simp] theorem zero_e1 : (0 : OctonionQ).e1 = 0 := rfl
@[simp] theorem zero_e2 : (0 : OctonionQ).e2 = 0 := rfl
@[simp] theorem zero_e3 : (0 : OctonionQ).e3 = 0 := rfl
@[simp] theorem zero_e4 : (0 : OctonionQ).e4 = 0 := rfl
@[simp] theorem zero_e5 : (0 : OctonionQ).e5 = 0 := rfl
@[simp] theorem zero_e6 : (0 : OctonionQ).e6 = 0 := rfl
@[simp] theorem zero_e7 : (0 : OctonionQ).e7 = 0 := rfl

@[simp] theorem one_e0 : (1 : OctonionQ).e0 = 1 := rfl
@[simp] theorem one_e1 : (1 : OctonionQ).e1 = 0 := rfl
@[simp] theorem one_e2 : (1 : OctonionQ).e2 = 0 := rfl
@[simp] theorem one_e3 : (1 : OctonionQ).e3 = 0 := rfl
@[simp] theorem one_e4 : (1 : OctonionQ).e4 = 0 := rfl
@[simp] theorem one_e5 : (1 : OctonionQ).e5 = 0 := rfl
@[simp] theorem one_e6 : (1 : OctonionQ).e6 = 0 := rfl
@[simp] theorem one_e7 : (1 : OctonionQ).e7 = 0 := rfl

/-! ### Component lemmas for `Add`, `Neg`, `Sub`. -/

@[simp] theorem add_e0 (x y : OctonionQ) : (x + y).e0 = x.e0 + y.e0 := rfl
@[simp] theorem add_e1 (x y : OctonionQ) : (x + y).e1 = x.e1 + y.e1 := rfl
@[simp] theorem add_e2 (x y : OctonionQ) : (x + y).e2 = x.e2 + y.e2 := rfl
@[simp] theorem add_e3 (x y : OctonionQ) : (x + y).e3 = x.e3 + y.e3 := rfl
@[simp] theorem add_e4 (x y : OctonionQ) : (x + y).e4 = x.e4 + y.e4 := rfl
@[simp] theorem add_e5 (x y : OctonionQ) : (x + y).e5 = x.e5 + y.e5 := rfl
@[simp] theorem add_e6 (x y : OctonionQ) : (x + y).e6 = x.e6 + y.e6 := rfl
@[simp] theorem add_e7 (x y : OctonionQ) : (x + y).e7 = x.e7 + y.e7 := rfl

@[simp] theorem neg_e0 (x : OctonionQ) : (-x).e0 = -x.e0 := rfl
@[simp] theorem neg_e1 (x : OctonionQ) : (-x).e1 = -x.e1 := rfl
@[simp] theorem neg_e2 (x : OctonionQ) : (-x).e2 = -x.e2 := rfl
@[simp] theorem neg_e3 (x : OctonionQ) : (-x).e3 = -x.e3 := rfl
@[simp] theorem neg_e4 (x : OctonionQ) : (-x).e4 = -x.e4 := rfl
@[simp] theorem neg_e5 (x : OctonionQ) : (-x).e5 = -x.e5 := rfl
@[simp] theorem neg_e6 (x : OctonionQ) : (-x).e6 = -x.e6 := rfl
@[simp] theorem neg_e7 (x : OctonionQ) : (-x).e7 = -x.e7 := rfl

@[simp] theorem sub_e0 (x y : OctonionQ) : (x - y).e0 = x.e0 - y.e0 := by
  show (x + (-y)).e0 = _; simp; ring
@[simp] theorem sub_e1 (x y : OctonionQ) : (x - y).e1 = x.e1 - y.e1 := by
  show (x + (-y)).e1 = _; simp; ring
@[simp] theorem sub_e2 (x y : OctonionQ) : (x - y).e2 = x.e2 - y.e2 := by
  show (x + (-y)).e2 = _; simp; ring
@[simp] theorem sub_e3 (x y : OctonionQ) : (x - y).e3 = x.e3 - y.e3 := by
  show (x + (-y)).e3 = _; simp; ring
@[simp] theorem sub_e4 (x y : OctonionQ) : (x - y).e4 = x.e4 - y.e4 := by
  show (x + (-y)).e4 = _; simp; ring
@[simp] theorem sub_e5 (x y : OctonionQ) : (x - y).e5 = x.e5 - y.e5 := by
  show (x + (-y)).e5 = _; simp; ring
@[simp] theorem sub_e6 (x y : OctonionQ) : (x - y).e6 = x.e6 - y.e6 := by
  show (x + (-y)).e6 = _; simp; ring
@[simp] theorem sub_e7 (x y : OctonionQ) : (x - y).e7 = x.e7 - y.e7 := by
  show (x + (-y)).e7 = _; simp; ring

/-! ### Multiplication unfolding `@[simp]` lemmas (one per component). -/

@[simp] theorem mul_e0 (x y : OctonionQ) :
    (x * y).e0 = x.e0*y.e0 - x.e1*y.e1 - x.e2*y.e2 - x.e3*y.e3
                 - x.e4*y.e4 - x.e5*y.e5 - x.e6*y.e6 - x.e7*y.e7 := rfl

@[simp] theorem mul_e1 (x y : OctonionQ) :
    (x * y).e1 = x.e0*y.e1 + x.e1*y.e0 + x.e2*y.e3 - x.e3*y.e2
                 + x.e4*y.e5 - x.e5*y.e4 - x.e6*y.e7 + x.e7*y.e6 := rfl

@[simp] theorem mul_e2 (x y : OctonionQ) :
    (x * y).e2 = x.e0*y.e2 - x.e1*y.e3 + x.e2*y.e0 + x.e3*y.e1
                 + x.e4*y.e6 + x.e5*y.e7 - x.e6*y.e4 - x.e7*y.e5 := rfl

@[simp] theorem mul_e3 (x y : OctonionQ) :
    (x * y).e3 = x.e0*y.e3 + x.e1*y.e2 - x.e2*y.e1 + x.e3*y.e0
                 + x.e4*y.e7 - x.e5*y.e6 + x.e6*y.e5 - x.e7*y.e4 := rfl

@[simp] theorem mul_e4 (x y : OctonionQ) :
    (x * y).e4 = x.e0*y.e4 - x.e1*y.e5 - x.e2*y.e6 - x.e3*y.e7
                 + x.e4*y.e0 + x.e5*y.e1 + x.e6*y.e2 + x.e7*y.e3 := rfl

@[simp] theorem mul_e5 (x y : OctonionQ) :
    (x * y).e5 = x.e0*y.e5 + x.e1*y.e4 - x.e2*y.e7 + x.e3*y.e6
                 - x.e4*y.e1 + x.e5*y.e0 - x.e6*y.e3 + x.e7*y.e2 := rfl

@[simp] theorem mul_e6 (x y : OctonionQ) :
    (x * y).e6 = x.e0*y.e6 + x.e1*y.e7 + x.e2*y.e4 - x.e3*y.e5
                 - x.e4*y.e2 + x.e5*y.e3 + x.e6*y.e0 - x.e7*y.e1 := rfl

@[simp] theorem mul_e7 (x y : OctonionQ) :
    (x * y).e7 = x.e0*y.e7 - x.e1*y.e6 + x.e2*y.e5 + x.e3*y.e4
                 - x.e4*y.e3 - x.e5*y.e2 + x.e6*y.e1 + x.e7*y.e0 := rfl

/-! ### Basic algebraic identities -/

theorem add_comm (x y : OctonionQ) : x + y = y + x := by
  ext <;> show _ + _ = _ + _ <;> ring

theorem add_zero (x : OctonionQ) : x + 0 = x := by
  ext <;> show _ + (0 : ℚ) = _ <;> ring

theorem zero_add (x : OctonionQ) : 0 + x = x := by
  ext <;> show (0 : ℚ) + _ = _ <;> ring

theorem add_assoc (x y z : OctonionQ) : x + y + z = x + (y + z) := by
  ext <;> show _ + _ + _ = _ + (_ + _) <;> ring

theorem neg_add_cancel (x : OctonionQ) : -x + x = 0 := by
  ext <;> show -(_ : ℚ) + _ = 0 <;> ring

/-! ### Conjugation, real part, norm -/

/-- Octonion conjugation: `x̄ = (x.e0, -x.e1, …, -x.e7)`. -/
def conj (x : OctonionQ) : OctonionQ :=
  ⟨x.e0, -x.e1, -x.e2, -x.e3, -x.e4, -x.e5, -x.e6, -x.e7⟩

/-- Real part: `Re(x) = x.e0`. -/
def re (x : OctonionQ) : ℚ := x.e0

/-- Norm-squared (composition norm): `‖x‖² = Σ xᵢ²`. -/
def normSq (x : OctonionQ) : ℚ :=
  x.e0^2 + x.e1^2 + x.e2^2 + x.e3^2 +
  x.e4^2 + x.e5^2 + x.e6^2 + x.e7^2

/-! ### Sanity checks -/

@[simp] theorem conj_zero : conj 0 = 0 := by ext <;> simp [conj]

@[simp] theorem conj_one : conj 1 = 1 := by ext <;> simp [conj]

@[simp] theorem normSq_zero : normSq 0 = 0 := by
  show (0:ℚ)^2 + 0^2 + 0^2 + 0^2 + 0^2 + 0^2 + 0^2 + 0^2 = 0
  ring

@[simp] theorem normSq_one : normSq 1 = 1 := by
  show (1:ℚ)^2 + 0^2 + 0^2 + 0^2 + 0^2 + 0^2 + 0^2 + 0^2 = 1
  ring

@[simp] theorem re_zero : re 0 = 0 := rfl

@[simp] theorem re_one : re 1 = 1 := rfl

/-- `conj` is involutive: `conj (conj x) = x`. -/
theorem conj_conj (x : OctonionQ) : conj (conj x) = x := by
  ext <;> simp [conj]

/-- Norm-squared is non-negative (a fundamental composition-algebra property). -/
theorem normSq_nonneg (x : OctonionQ) : 0 ≤ normSq x := by
  unfold normSq
  positivity

/-! ### Multiplication by zero -/

@[simp] theorem mul_zero (x : OctonionQ) : x * 0 = 0 := by
  ext <;> simp

@[simp] theorem zero_mul (x : OctonionQ) : (0 : OctonionQ) * x = 0 := by
  ext <;> simp

/-! ### Multiplication by one -/

@[simp] theorem mul_one (x : OctonionQ) : x * 1 = x := by
  ext <;> simp

@[simp] theorem one_mul (x : OctonionQ) : (1 : OctonionQ) * x = x := by
  ext <;> simp

/-! ### Re-associativity and Re-cyclic identities

For any composition algebra (octonions included), the trace `tr(x) = 2*Re(x)`
satisfies the "associative-on-trace" property:
* `Re((ab)c) = Re(a(bc))` (the associator vanishes on Re)
* `Re((ab)c) = Re((bc)a) = Re((ca)b)` (cyclic in 3 args)

These follow from the explicit Fano-plane multiplication via `ring`. -/

/-- **Re-associativity** for octonion triple products. -/
theorem re_mul_assoc (a b c : OctonionQ) :
    re ((a * b) * c) = re (a * (b * c)) := by
  show ((a * b) * c).e0 = (a * (b * c)).e0
  simp; ring

/-- **Re-cyclic** for octonion triple products: `Re((ab)c) = Re((bc)a)`. -/
theorem re_mul_cyclic (a b c : OctonionQ) :
    re ((a * b) * c) = re ((b * c) * a) := by
  show ((a * b) * c).e0 = ((b * c) * a).e0
  simp; ring

/-- **Re-cyclic** alternative form: `Re((ab)c) = Re((ca)b)`. -/
theorem re_mul_cyclic' (a b c : OctonionQ) :
    re ((a * b) * c) = re ((c * a) * b) := by
  show ((a * b) * c).e0 = ((c * a) * b).e0
  simp; ring

/-! ### Alternative-algebra laws

Octonions are **non-associative** but **alternative**, meaning:
* `mul_left_alt`: `(x*x)*y = x*(x*y)`  (left alternativity)
* `mul_right_alt`: `(y*x)*x = y*(x*x)`  (right alternativity)
* `mul_flex`: `(x*y)*x = x*(y*x)`  (flexibility law)

These follow from Artin's theorem: any subalgebra generated by two
elements is associative. Verified here directly via `ring` over the
8 components.
-/

/-- **Left-alternativity** of octonion multiplication: `(x · x) · y = x · (x · y)`. -/
theorem mul_left_alt (x y : OctonionQ) : (x * x) * y = x * (x * y) := by
  ext <;> simp <;> ring

/-- **Right-alternativity** of octonion multiplication: `(y · x) · x = y · (x · x)`. -/
theorem mul_right_alt (y x : OctonionQ) : (y * x) * x = y * (x * x) := by
  ext <;> simp <;> ring

/-- **Flexibility law**: `(x · y) · x = x · (y · x)`. -/
theorem mul_flex (x y : OctonionQ) : (x * y) * x = x * (y * x) := by
  ext <;> simp <;> ring

/-! ### Hurwitz composition law

Octonions are the maximal **composition algebra** over `ℝ` (or `ℚ`):
the norm-squared is multiplicative, `‖x·y‖² = ‖x‖²·‖y‖²`. This is
Hurwitz's theorem — the four normed division algebras `ℝ ⊂ ℂ ⊂ ℍ ⊂ 𝕆`
are the unique composition algebras over `ℝ`.

For our `ℚ`-version of `𝕆`, the same identity holds as a polynomial
identity in the 16 components (8 of `x` and 8 of `y`), verifiable
by `ring`.
-/

/-- **Hurwitz composition law**: `‖x·y‖² = ‖x‖² · ‖y‖²`. -/
theorem normSq_mul (x y : OctonionQ) : normSq (x * y) = normSq x * normSq y := by
  unfold normSq
  simp only [mul_e0, mul_e1, mul_e2, mul_e3, mul_e4, mul_e5, mul_e6, mul_e7]
  ring

/-! ### Scalar multiplication component lemmas -/

@[simp] theorem smul_e0 (r : ℚ) (x : OctonionQ) : (r • x).e0 = r * x.e0 := rfl
@[simp] theorem smul_e1 (r : ℚ) (x : OctonionQ) : (r • x).e1 = r * x.e1 := rfl
@[simp] theorem smul_e2 (r : ℚ) (x : OctonionQ) : (r • x).e2 = r * x.e2 := rfl
@[simp] theorem smul_e3 (r : ℚ) (x : OctonionQ) : (r • x).e3 = r * x.e3 := rfl
@[simp] theorem smul_e4 (r : ℚ) (x : OctonionQ) : (r • x).e4 = r * x.e4 := rfl
@[simp] theorem smul_e5 (r : ℚ) (x : OctonionQ) : (r • x).e5 = r * x.e5 := rfl
@[simp] theorem smul_e6 (r : ℚ) (x : OctonionQ) : (r • x).e6 = r * x.e6 := rfl
@[simp] theorem smul_e7 (r : ℚ) (x : OctonionQ) : (r • x).e7 = r * x.e7 := rfl

/-! ### Homogeneity of `normSq`, `re`, multiplication -/

/-- `normSq` is **quadratic** (homogeneous of degree 2). -/
theorem normSq_smul (r : ℚ) (x : OctonionQ) :
    normSq (r • x) = r^2 * normSq x := by
  unfold normSq
  simp
  ring

/-- **Polarization** of `normSq`:
`‖a + b‖² = ‖a‖² + ‖b‖² + 2 Re(a · conj b)`,
where `Re(a · conj b)` is the Euclidean inner product on `OctonionQ`. -/
theorem normSq_add (a b : OctonionQ) :
    normSq (a + b) = normSq a + normSq b + 2 * re (a * conj b) := by
  unfold normSq re conj
  show (a + b).e0^2 + (a + b).e1^2 + (a + b).e2^2 + (a + b).e3^2
       + (a + b).e4^2 + (a + b).e5^2 + (a + b).e6^2 + (a + b).e7^2
       = (a.e0^2 + a.e1^2 + a.e2^2 + a.e3^2 + a.e4^2 + a.e5^2 + a.e6^2 + a.e7^2)
       + (b.e0^2 + b.e1^2 + b.e2^2 + b.e3^2 + b.e4^2 + b.e5^2 + b.e6^2 + b.e7^2)
       + 2 * (a * ⟨b.e0, -b.e1, -b.e2, -b.e3, -b.e4, -b.e5, -b.e6, -b.e7⟩).e0
  simp
  ring

/-- **3-term polarization** of `normSq` (used in bilinearity proofs):
`‖a + b + c‖² = ‖a‖² + ‖b‖² + ‖c‖²
              + 2 Re(a · conj b) + 2 Re(a · conj c) + 2 Re(b · conj c)`. -/
theorem normSq_add₃ (a b c : OctonionQ) :
    normSq (a + b + c)
    = normSq a + normSq b + normSq c
      + 2 * re (a * conj b) + 2 * re (a * conj c) + 2 * re (b * conj c) := by
  rw [normSq_add, normSq_add]
  have h : re ((a + b) * conj c) = re (a * conj c) + re (b * conj c) := by
    show ((a + b) * conj c).e0 = (a * conj c).e0 + (b * conj c).e0
    simp; ring
  rw [h]
  ring

/-- `re` distributes over octonion addition (left): `Re((a + b) * c) = Re(a*c) + Re(b*c)`. -/
theorem re_add_mul (a b c : OctonionQ) :
    re ((a + b) * c) = re (a * c) + re (b * c) := by
  show ((a + b) * c).e0 = (a * c).e0 + (b * c).e0
  simp; ring

/-- `re` distributes over octonion addition (right): `Re(a * (b + c)) = Re(a*b) + Re(a*c)`. -/
theorem re_mul_add (a b c : OctonionQ) :
    re (a * (b + c)) = re (a * b) + re (a * c) := by
  show (a * (b + c)).e0 = (a * b).e0 + (a * c).e0
  simp; ring

/-- `re` is `ℚ`-linear: `Re(r • x) = r · Re(x)`. -/
@[simp] theorem re_smul (r : ℚ) (x : OctonionQ) : re (r • x) = r * re x := rfl

/-- `Mul` is **bilinear** with `ℚ`-scalar absorption:
`(r • x) · (s • y) = (r·s) • (x · y)`. -/
theorem smul_mul_smul (r s : ℚ) (x y : OctonionQ) :
    (r • x) * (s • y) = (r * s) • (x * y) := by
  ext <;> simp <;> ring

/-- `Mul` is left-linear in `ℚ`-scalars: `(r • x) · y = r • (x · y)`. -/
theorem smul_mul (r : ℚ) (x y : OctonionQ) :
    (r • x) * y = r • (x * y) := by
  ext <;> simp <;> ring

/-- `Mul` is right-linear in `ℚ`-scalars: `x · (r • y) = r • (x · y)`. -/
theorem mul_smul (r : ℚ) (x y : OctonionQ) :
    x * (r • y) = r • (x * y) := by
  ext <;> simp <;> ring

/-- Scalar-multiplication compatibility: `r • (s • x) = (r·s) • x`. -/
theorem smul_smul (r s : ℚ) (x : OctonionQ) :
    r • (s • x) = (r * s) • x := by
  ext <;> show r * (s * _) = (r * s) * _ <;> ring

/-- Conjugation is `ℚ`-linear: `conj (r • x) = r • conj x`. -/
@[simp] theorem conj_smul (r : ℚ) (x : OctonionQ) :
    conj (r • x) = r • conj x := by
  ext <;> simp [conj]

/-- Scalar absorption over subtraction: `r • (x - y) = r • x - r • y`. -/
theorem smul_sub (r : ℚ) (x y : OctonionQ) :
    r • (x - y) = r • x - r • y := by
  ext <;> simp <;> ring

/-- Scalar absorption over addition: `r • (x + y) = r • x + r • y`. -/
theorem smul_add (r : ℚ) (x y : OctonionQ) :
    r • (x + y) = r • x + r • y := by
  ext <;> simp <;> ring

/-! ### Hurwitz inversion and conjugate-multiplication identity

The fundamental composition-algebra identity:
```
   x · x̄ = ‖x‖² · 1   (and symmetrically  x̄ · x = ‖x‖² · 1)
```
This says: multiplying an octonion by its conjugate gives a scalar — the
norm-squared, embedded as `(normSq x) • 1 ∈ 𝕆`.

Together with `normSq` being a quadratic form satisfying `‖x·y‖² = ‖x‖²·‖y‖²`
(Hurwitz composition, already proved), this gives `𝕆` the structure of a
**composition algebra** and lets us invert nonzero elements:
```
   x⁻¹ = (1/‖x‖²) · x̄    for ‖x‖² ≠ 0
```

For octonions over `ℚ`, `‖x‖² = 0 ↔ x = 0`, so every nonzero octonion is
invertible — `𝕆` is a (non-associative) division algebra. This is the
final classical Hurwitz/Frobenius/Cayley-Dickson invariant.
-/

/-- The fundamental conjugate-multiplication identity:
`x · conj x = (normSq x) • 1`. -/
theorem mul_conj_self (x : OctonionQ) :
    x * conj x = normSq x • (1 : OctonionQ) := by
  ext <;> simp [conj, normSq] <;> ring

/-- The symmetric version: `conj x · x = (normSq x) • 1`. -/
theorem conj_self_mul (x : OctonionQ) :
    conj x * x = normSq x • (1 : OctonionQ) := by
  ext <;> simp [conj, normSq] <;> ring

/-- `normSq x = 0 ↔ x = 0` over `ℚ`: octonions form a division algebra. -/
theorem normSq_eq_zero_iff (x : OctonionQ) : normSq x = 0 ↔ x = 0 := by
  constructor
  · intro h
    -- `normSq x = 0` means `Σ xᵢ² = 0`. Over `ℚ` this forces every `xᵢ = 0`.
    have hx : x.e0^2 + x.e1^2 + x.e2^2 + x.e3^2 +
              x.e4^2 + x.e5^2 + x.e6^2 + x.e7^2 = 0 := h
    -- Each `xᵢ² ≥ 0` and they sum to 0, so each `xᵢ² = 0`, hence `xᵢ = 0`.
    have h0 : x.e0 = 0 ∧ x.e1 = 0 ∧ x.e2 = 0 ∧ x.e3 = 0 ∧
              x.e4 = 0 ∧ x.e5 = 0 ∧ x.e6 = 0 ∧ x.e7 = 0 := by
      refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
      all_goals nlinarith [sq_nonneg x.e0, sq_nonneg x.e1, sq_nonneg x.e2,
                           sq_nonneg x.e3, sq_nonneg x.e4, sq_nonneg x.e5,
                           sq_nonneg x.e6, sq_nonneg x.e7]
    obtain ⟨h0, h1, h2, h3, h4, h5, h6, h7⟩ := h0
    ext <;> simp [h0, h1, h2, h3, h4, h5, h6, h7]
  · intro h; subst h; exact normSq_zero

/-- `normSq x ≠ 0 ↔ x ≠ 0`. -/
theorem normSq_ne_zero_iff (x : OctonionQ) : normSq x ≠ 0 ↔ x ≠ 0 := by
  rw [Ne, normSq_eq_zero_iff]

/-- The **multiplicative inverse** of a nonzero octonion: `x⁻¹ = (1/‖x‖²) · x̄`. -/
noncomputable def inv (x : OctonionQ) : OctonionQ :=
  (normSq x)⁻¹ • conj x

/-- The defining property of `inv`: `x · x⁻¹ = 1` for nonzero `x`. -/
theorem mul_inv_cancel (x : OctonionQ) (hx : x ≠ 0) : x * inv x = 1 := by
  unfold inv
  rw [mul_smul, mul_conj_self, smul_smul]
  have hne : normSq x ≠ 0 := (normSq_ne_zero_iff x).mpr hx
  rw [inv_mul_cancel₀ hne]
  ext <;> simp

/-- The symmetric inverse property: `x⁻¹ · x = 1` for nonzero `x`. -/
theorem inv_mul_cancel (x : OctonionQ) (hx : x ≠ 0) : inv x * x = 1 := by
  unfold inv
  rw [smul_mul, conj_self_mul, smul_smul]
  have hne : normSq x ≠ 0 := (normSq_ne_zero_iff x).mpr hx
  rw [inv_mul_cancel₀ hne]
  ext <;> simp

/-! ### Mathlib typeclass upgrade: `AddCommGroup` + `Module ℚ`

Promote the explicit standalone instances `Zero`, `Add`, `Neg`, `Sub`,
`SMul ℚ` to a full Mathlib `AddCommGroup` + `Module ℚ` structure. This
opens access to all of Mathlib's linear-algebra machinery (`LinearMap`,
`Basis`, `Module.rank`, `FiniteDimensional`, ...).

The `nsmul` / `zsmul` actions are defined component-wise via the
`ℕ → ℚ` / `ℤ → ℚ` casts, avoiding the `nsmulRec`/`zsmulRec` default
which sometimes fails to elaborate for struct-of-fields types.
-/

instance instAddCommGroup : AddCommGroup OctonionQ where
  zero := (0 : OctonionQ)
  add := (· + ·)
  neg := Neg.neg
  sub := Sub.sub
  add_assoc x y z := by ext <;> show _ + _ + _ = _ + (_ + _) <;> ring
  zero_add x := by ext <;> show (0 : ℚ) + _ = _ <;> ring
  add_zero x := by ext <;> show _ + (0 : ℚ) = _ <;> ring
  add_comm x y := by ext <;> show _ + _ = _ + _ <;> ring
  neg_add_cancel x := by ext <;> show -(_ : ℚ) + _ = 0 <;> ring
  nsmul := nsmulRec
  zsmul := zsmulRec

instance instModuleRat : Module ℚ OctonionQ where
  smul := SMul.smul
  one_smul x := by ext <;> show (1 : ℚ) * _ = _ <;> ring
  mul_smul r s x := by ext <;> show (_ * _) * _ = _ * (_ * _) <;> ring
  smul_zero r := by ext <;> simp
  smul_add r x y := by ext <;> show _ * (_ + _) = _ * _ + _ * _ <;> ring
  add_smul r s x := by ext <;> show (_ + _) * _ = _ * _ + _ * _ <;> ring
  zero_smul x := by ext <;> simp

end OctonionQ

end HodgeReduction.Infrastructure
