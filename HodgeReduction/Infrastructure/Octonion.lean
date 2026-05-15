/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

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
  ext <;> simp <;> ring

@[simp] theorem one_mul (x : OctonionQ) : (1 : OctonionQ) * x = x := by
  ext <;> simp <;> ring

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

end OctonionQ

end HodgeReduction.Infrastructure
