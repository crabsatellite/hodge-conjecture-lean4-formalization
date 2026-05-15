/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Octonion
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# The exceptional Jordan algebra `J₃(𝕆)` over `ℚ`

This file provides a **concrete construction** of the 27-dimensional
exceptional Jordan algebra `J₃(𝕆)` over `ℚ`, together with its **cubic
norm form** `N : J₃(𝕆) → ℚ`.

`J₃(𝕆)` consists of **Hermitian 3×3 matrices over the octonions**:
```
       ⎛ ξ₁  x₃  x̄₂ ⎞
   X = ⎜ x̄₃  ξ₂  x₁ ⎟
       ⎝ x₂  x̄₁  ξ₃ ⎠
```
where `ξ₁, ξ₂, ξ₃ ∈ ℚ` are diagonal entries and `x₁, x₂, x₃ ∈ 𝕆` are
off-diagonal octonion entries (with conjugates `x̄ᵢ` in mirror positions).

**Dimension**: `3 + 3·8 = 27` (matching the dimension of the 27-dim
minuscule representation `V₂₇` of `E₆`, of which `J₃(𝕆)` is the
natural realization).

**Connection to `E₆`**: the automorphism group of `J₃(𝕆)` is `F₄`
(compact real form); the structure group (preserving the cubic norm
up to scalar) is `E₆`. The 27-dim rep `V₂₇` of `E₆` IS `J₃(𝕆)`.

## Main definitions

* `J3O` — structure with 3 diagonal `ξᵢ : ℚ` and 3 off-diagonal `xᵢ : 𝕆`.
* `Zero`, `One` (identity matrix), `Add`, `Neg`, `SMul ℚ` instances.
* `J3O.cubicNorm` — the Freudenthal cubic norm
  `N(X) = ξ₁ξ₂ξ₃ - Σᵢ ξᵢ·n(xᵢ) + 2·Re(x₁·x₂·x₃)`.

## Sanity checks proved here

* `cubicNorm_zero : N(0) = 0`
* `cubicNorm_one : N(I₃) = 1` — the cubic norm of the identity matrix.
* `cubicNorm_smul : N(r · X) = r³ · N(X)` (homogeneous of degree 3).

## Future work

* `N(𝟙) = 27` for the all-ones element in the **weight basis** (the
  27 V_27-weight generators of J_3(O), summed). This is the P51
  master-tex computation; requires defining the explicit
  weight-basis-to-Hermitian-matrix correspondence.
* Adjoint operation `X^#` and the identity `X · X^# = N(X) · I`.
* `F₄ = Aut(J₃(𝕆))` and `E₆ = Str(J₃(𝕆))/center` (long-term).

## References

* T. A. Springer, F. D. Veldkamp, *Octonions, Jordan Algebras, and
  Exceptional Groups* (Springer 2000) §III.4.
* N. Jacobson, *Structure and Representations of Jordan Algebras*,
  AMS Coll. Publ. **39** (1968), Ch. VIII.
* H. Freudenthal, "Beziehungen der E_7 und E_8 zur Oktavenebene I-V",
  Indag. Math. **16-17** (1954-55).
* K. McCrimmon, *A Taste of Jordan Algebras* (Springer 2004), §VI.

## Tags

exceptional Jordan algebra, J_3(O), cubic norm, Freudenthal cubic norm,
E_6, F_4, 27-dimensional, exceptional Lie algebra
-/

namespace HodgeReduction.Infrastructure

/-- The exceptional Jordan algebra `J₃(𝕆)` over `ℚ`: Hermitian `3×3`
matrices over the octonions. Encoded by 3 real diagonal entries and
3 octonion off-diagonal entries (the conjugate-symmetric positions are
implicit). -/
@[ext]
structure J3O where
  /-- Diagonal entry `(1,1)`: `ξ₁`. -/
  xi1 : ℚ
  /-- Diagonal entry `(2,2)`: `ξ₂`. -/
  xi2 : ℚ
  /-- Diagonal entry `(3,3)`: `ξ₃`. -/
  xi3 : ℚ
  /-- Off-diagonal `(3,2) = x̄₁` (so `(2,3) = x₁`). -/
  x1 : OctonionQ
  /-- Off-diagonal `(1,3) = x̄₂` (so `(3,1) = x₂`). -/
  x2 : OctonionQ
  /-- Off-diagonal `(2,1) = x̄₃` (so `(1,2) = x₃`). -/
  x3 : OctonionQ
deriving DecidableEq

namespace J3O

/-! ### Algebraic structure -/

instance : Zero J3O := ⟨⟨0, 0, 0, 0, 0, 0⟩⟩

/-- The identity matrix `I₃ = diag(1, 1, 1)`. -/
instance : One J3O := ⟨⟨1, 1, 1, 0, 0, 0⟩⟩

/-! ### Component lemmas for `Zero` and `One` -/

@[simp] theorem zero_xi1 : (0 : J3O).xi1 = 0 := rfl
@[simp] theorem zero_xi2 : (0 : J3O).xi2 = 0 := rfl
@[simp] theorem zero_xi3 : (0 : J3O).xi3 = 0 := rfl
@[simp] theorem zero_x1 : (0 : J3O).x1 = 0 := rfl
@[simp] theorem zero_x2 : (0 : J3O).x2 = 0 := rfl
@[simp] theorem zero_x3 : (0 : J3O).x3 = 0 := rfl

@[simp] theorem one_xi1 : (1 : J3O).xi1 = 1 := rfl
@[simp] theorem one_xi2 : (1 : J3O).xi2 = 1 := rfl
@[simp] theorem one_xi3 : (1 : J3O).xi3 = 1 := rfl
@[simp] theorem one_x1 : (1 : J3O).x1 = 0 := rfl
@[simp] theorem one_x2 : (1 : J3O).x2 = 0 := rfl
@[simp] theorem one_x3 : (1 : J3O).x3 = 0 := rfl

instance : Add J3O := ⟨fun X Y => ⟨
  X.xi1 + Y.xi1, X.xi2 + Y.xi2, X.xi3 + Y.xi3,
  X.x1 + Y.x1, X.x2 + Y.x2, X.x3 + Y.x3⟩⟩

instance : Neg J3O := ⟨fun X => ⟨
  -X.xi1, -X.xi2, -X.xi3, -X.x1, -X.x2, -X.x3⟩⟩

instance : SMul ℚ J3O := ⟨fun r X => ⟨
  r * X.xi1, r * X.xi2, r * X.xi3,
  r • X.x1, r • X.x2, r • X.x3⟩⟩

/-! ### Cubic norm form -/

/-- The **Freudenthal cubic norm** on `J₃(𝕆)`:
```
N(X) = ξ₁·ξ₂·ξ₃ - ξ₁·n(x₁) - ξ₂·n(x₂) - ξ₃·n(x₃) + 2·Re(x₁·x₂·x₃)
```
where `n` is the octonion norm-squared and `Re` is the real part. The
parenthesisation `x₁·x₂·x₃ = (x₁·x₂)·x₃` is one of two consistent
choices; both give the same `Re(·)` because `Re` is symmetric under
cyclic permutation in any composition algebra. -/
def cubicNorm (X : J3O) : ℚ :=
  X.xi1 * X.xi2 * X.xi3
    - X.xi1 * OctonionQ.normSq X.x1
    - X.xi2 * OctonionQ.normSq X.x2
    - X.xi3 * OctonionQ.normSq X.x3
    + 2 * OctonionQ.re (X.x1 * X.x2 * X.x3)

/-! ### Sanity checks -/

@[simp] theorem cubicNorm_zero : cubicNorm 0 = 0 := by
  unfold cubicNorm
  show (0 : ℚ) * 0 * 0 - 0 * OctonionQ.normSq 0 - 0 * OctonionQ.normSq 0
       - 0 * OctonionQ.normSq 0 + 2 * OctonionQ.re (0 * 0 * 0) = 0
  simp [OctonionQ.re]

/-- For the identity matrix `I₃ = diag(1, 1, 1)`, the cubic norm
equals `1`. -/
@[simp] theorem cubicNorm_one : cubicNorm 1 = 1 := by
  unfold cubicNorm
  show (1 : ℚ) * 1 * 1 - 1 * OctonionQ.normSq 0 - 1 * OctonionQ.normSq 0
       - 1 * OctonionQ.normSq 0 + 2 * OctonionQ.re (0 * 0 * 0) = 1
  simp [OctonionQ.re]

/-- The cubic norm of a diagonal matrix `diag(a, b, c)` is `a·b·c`. -/
theorem cubicNorm_diagonal (a b c : ℚ) :
    cubicNorm ⟨a, b, c, 0, 0, 0⟩ = a * b * c := by
  unfold cubicNorm
  show a * b * c - a * OctonionQ.normSq 0 - b * OctonionQ.normSq 0
       - c * OctonionQ.normSq 0 + 2 * OctonionQ.re (0 * 0 * 0) = a * b * c
  simp [OctonionQ.re]

/-! ### Cubic-norm homogeneity (degree 3) -/

/-- Scalar-mult on `J₃(𝕆)` field-by-field. -/
@[simp] theorem smul_xi1 (r : ℚ) (X : J3O) : (r • X).xi1 = r * X.xi1 := rfl
@[simp] theorem smul_xi2 (r : ℚ) (X : J3O) : (r • X).xi2 = r * X.xi2 := rfl
@[simp] theorem smul_xi3 (r : ℚ) (X : J3O) : (r • X).xi3 = r * X.xi3 := rfl
@[simp] theorem smul_x1 (r : ℚ) (X : J3O) : (r • X).x1 = r • X.x1 := rfl
@[simp] theorem smul_x2 (r : ℚ) (X : J3O) : (r • X).x2 = r • X.x2 := rfl
@[simp] theorem smul_x3 (r : ℚ) (X : J3O) : (r • X).x3 = r • X.x3 := rfl

/-- **Cubic-norm homogeneity**: `N(r • X) = r³ · N(X)`. The cubic norm
is homogeneous of degree 3. -/
theorem cubicNorm_smul (r : ℚ) (X : J3O) :
    cubicNorm (r • X) = r^3 * cubicNorm X := by
  unfold cubicNorm
  simp only [smul_xi1, smul_xi2, smul_xi3, smul_x1, smul_x2, smul_x3,
             OctonionQ.normSq_smul,
             OctonionQ.smul_mul,    -- (s•a) * b = s • (a*b)
             OctonionQ.mul_smul,    -- a * (s•b) = s • (a*b)
             OctonionQ.smul_smul,   -- s • (t • x) = (s*t) • x
             OctonionQ.re_smul]     -- Re(r • z) = r * Re z
  ring

/-- The cubic norm is **odd** (degree 3): `N(-X) = -N(X)`. -/
theorem cubicNorm_neg (X : J3O) : cubicNorm (-X) = -cubicNorm X := by
  -- `-X = (-1) • X`; degree-3 homogeneity gives `N((-1)·X) = (-1)³·N(X) = -N(X)`.
  have h : -X = (-1 : ℚ) • X := by
    refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
    · show -X.xi1 = (-1 : ℚ) * X.xi1; ring
    · show -X.xi2 = (-1 : ℚ) * X.xi2; ring
    · show -X.xi3 = (-1 : ℚ) * X.xi3; ring
    · show -X.x1 = (-1 : ℚ) • X.x1; ext <;> simp
    · show -X.x2 = (-1 : ℚ) • X.x2; ext <;> simp
    · show -X.x3 = (-1 : ℚ) • X.x3; ext <;> simp
  rw [h, cubicNorm_smul]
  norm_num

/-! ### Trace on `J₃(𝕆)`

The **trace** of an Hermitian 3×3 matrix is the sum of its diagonal entries.
It is a ℚ-linear functional `J₃(𝕆) → ℚ` whose properties mirror the standard
trace on Hermitian matrices over a commutative ring. -/

/-- The **trace** of `X ∈ J₃(𝕆)`: `tr(X) = ξ₁ + ξ₂ + ξ₃`. -/
def trace (X : J3O) : ℚ := X.xi1 + X.xi2 + X.xi3

@[simp] theorem trace_zero : trace (0 : J3O) = 0 := by
  show (0 : ℚ) + 0 + 0 = 0; ring

@[simp] theorem trace_one : trace (1 : J3O) = 3 := by
  show (1 : ℚ) + 1 + 1 = 3; ring

theorem trace_add (X Y : J3O) : trace (X + Y) = trace X + trace Y := by
  show (X.xi1 + Y.xi1) + (X.xi2 + Y.xi2) + (X.xi3 + Y.xi3)
       = (X.xi1 + X.xi2 + X.xi3) + (Y.xi1 + Y.xi2 + Y.xi3)
  ring

theorem trace_neg (X : J3O) : trace (-X) = -trace X := by
  show (-X.xi1) + (-X.xi2) + (-X.xi3) = -(X.xi1 + X.xi2 + X.xi3)
  ring

theorem trace_smul (r : ℚ) (X : J3O) : trace (r • X) = r * trace X := by
  show (r * X.xi1) + (r * X.xi2) + (r * X.xi3) = r * (X.xi1 + X.xi2 + X.xi3)
  ring

/-- The trace of a diagonal matrix is the sum of its diagonal: `tr(diag(a,b,c)) = a+b+c`. -/
theorem trace_diagonal (a b c : ℚ) :
    trace ⟨a, b, c, 0, 0, 0⟩ = a + b + c := rfl

end J3O

end HodgeReduction.Infrastructure
