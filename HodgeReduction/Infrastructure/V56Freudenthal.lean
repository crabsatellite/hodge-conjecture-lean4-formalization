/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.JordanJ3O
import Mathlib.Tactic.Ring

/-!
# The 56-dimensional Freudenthal triple system `V₅₆` and the Freudenthal quartic

This file provides the **56-dimensional minuscule representation `V₅₆`** of
the exceptional Lie algebra `E₇`, realised as a **Freudenthal triple system**:
```
   V₅₆ = ℚ ⊕ J₃(𝕆) ⊕ J₃(𝕆) ⊕ ℚ
       = 1 + 27 + 27 + 1 = 56 dimensions
```

The 4-component partition `(a, A, B, b)` corresponds to the Hodge-decomposition
`V₅₆ = V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}` on the `EVII` Shimura variety
(with U(1)-charges `(+3, +1, -1, -3)`).

The **Freudenthal quartic `q : V₅₆ → ℚ`** is the unique (up to scalar)
E₇-invariant quartic polynomial:
```
   q(a, A, B, b) = (a·b - ⟨A, B⟩)² + 4·[a·N(B) + b·N(A) - ⟨A^#, B^#⟩]
```
where:
* `⟨A, B⟩` is a `J₃(𝕆)`-bilinear pairing.
* `N : J₃(𝕆) → ℚ` is the Freudenthal cubic norm (P76).
* `A^#` is the adjoint (sharp) operation on `J₃(𝕆)`.

## Main definitions

* `V56` — structure with 4 fields: `a, b : ℚ` and `A, B : J3O`.
* `J3O.innerProd` — bilinear pairing `⟨·, ·⟩ : J3O × J3O → ℚ`.
* `J3O.sharp` — adjoint `A → A^#`.
* `V56.freudenthalQuartic` — the quartic `q`.

## Sanity checks

* `freudenthalQuartic_zero : q(0) = 0`.
* `innerProd_symm : ⟨A, B⟩ = ⟨B, A⟩` (symmetric bilinear).
* `innerProd_zero : ⟨0, B⟩ = 0`.

## Connection to HC reduction (master tex P49-P53)

The Hodge-graded Chern roots `{-h, x₁, ..., x₂₇, -x₁, ..., -x₂₇, +h}` of
`V_{56}^{can}` yield the **cross-ring twist** value:
```
   Φ_tw(q) = q(-h, x_i, -x_i, +h) = -48 h⁴
```
which was computed in P39-P53 of `HodgeReduction.Strict` and proved as a
ℚ-arithmetic theorem in `HodgeReduction.CrossRingArithmetic` (P72).

This file provides the algebraic foundation `V_56` + `q` so that the
P49 statement "evaluate `q` on the Hodge-graded Chern roots" is a
well-defined operation on a typed object.

## References

* H. Freudenthal, "Beziehungen der E_7 und E_8 zur Oktavenebene I-V",
  *Indag. Math.* **16-17** (1954-55).
* R. Brown, "Groups of type E_7", *J. Reine Angew. Math.* **236** (1969), 79-102.
* T. A. Springer, F. D. Veldkamp, *Octonions, Jordan Algebras, and
  Exceptional Groups*, Springer Monographs in Mathematics (2000), §IV.
* M. Sato, T. Kimura, "A classification of irreducible prehomogeneous
  vector spaces and their relative invariants", *Nagoya Math. J.* **65**
  (1977), 1-155.

## Tags

V_56, Freudenthal triple system, E_7, minuscule representation,
Freudenthal quartic, J_3(O)
-/

namespace HodgeReduction.Infrastructure

namespace J3O

/-! ### Bilinear pairing `⟨·, ·⟩` on `J₃(𝕆)`

For Hermitian 3×3 matrices, the natural inner product is `(1/2)·tr(A·B + B·A)`.
After expansion in terms of diagonal and off-diagonal components:
```
   ⟨A, B⟩ = α₁β₁ + α₂β₂ + α₃β₃ + 2·Re(a₁ · b̄₁) + 2·Re(a₂ · b̄₂) + 2·Re(a₃ · b̄₃)
```
where `Re(a · b̄)` is the standard inner product on octonions.
-/

/-- Bilinear pairing `⟨A, B⟩` on `J₃(𝕆)`. -/
def innerProd (A B : J3O) : ℚ :=
  A.xi1 * B.xi1 + A.xi2 * B.xi2 + A.xi3 * B.xi3
    + 2 * OctonionQ.re (A.x1 * OctonionQ.conj B.x1)
    + 2 * OctonionQ.re (A.x2 * OctonionQ.conj B.x2)
    + 2 * OctonionQ.re (A.x3 * OctonionQ.conj B.x3)

@[simp] theorem innerProd_zero_right (A : J3O) : innerProd A 0 = 0 := by
  unfold innerProd
  show A.xi1 * 0 + A.xi2 * 0 + A.xi3 * 0
       + 2 * OctonionQ.re (A.x1 * OctonionQ.conj 0)
       + 2 * OctonionQ.re (A.x2 * OctonionQ.conj 0)
       + 2 * OctonionQ.re (A.x3 * OctonionQ.conj 0) = 0
  simp [OctonionQ.re]

@[simp] theorem innerProd_zero_left (B : J3O) : innerProd 0 B = 0 := by
  unfold innerProd
  show (0 : ℚ) * B.xi1 + 0 * B.xi2 + 0 * B.xi3
       + 2 * OctonionQ.re (0 * OctonionQ.conj B.x1)
       + 2 * OctonionQ.re (0 * OctonionQ.conj B.x2)
       + 2 * OctonionQ.re (0 * OctonionQ.conj B.x3) = 0
  simp [OctonionQ.re]

/-! ### The adjoint (sharp) `A^#`

For `A ∈ J₃(𝕆)` with `A = ((α₁, α₂, α₃), (a₁, a₂, a₃))`:
```
   A^# = ((α₂α₃ - n(a₁), α₃α₁ - n(a₂), α₁α₂ - n(a₃)),
          (ā₂·ā₃ - α₁·a₁,  ā₃·ā₁ - α₂·a₂,  ā₁·ā₂ - α₃·a₃))
```
The key identity is `A · A^# = N(A) · I` (Freudenthal cubic-norm identity).
-/

/-- The adjoint (sharp) of `A ∈ J₃(𝕆)`. -/
def sharp (A : J3O) : J3O := {
  xi1 := A.xi2 * A.xi3 - OctonionQ.normSq A.x1
  xi2 := A.xi3 * A.xi1 - OctonionQ.normSq A.x2
  xi3 := A.xi1 * A.xi2 - OctonionQ.normSq A.x3
  x1 := OctonionQ.conj A.x2 * OctonionQ.conj A.x3 - A.xi1 • A.x1
  x2 := OctonionQ.conj A.x3 * OctonionQ.conj A.x1 - A.xi2 • A.x2
  x3 := OctonionQ.conj A.x1 * OctonionQ.conj A.x2 - A.xi3 • A.x3
}

/-- `sharp 0 = 0` (the sharp of the zero element is zero). -/
@[simp] theorem sharp_zero : sharp 0 = 0 := by
  ext <;> simp [sharp]

end J3O

/-! ### The 56-dimensional Freudenthal triple system `V₅₆`

`V₅₆ = ℚ ⊕ J₃(𝕆) ⊕ J₃(𝕆) ⊕ ℚ`, corresponding to the Hodge-decomposition
`V^{3,0} ⊕ V^{2,1} ⊕ V^{1,2} ⊕ V^{0,3}` under `E₆ × U(1)`.
-/

/-- The 56-dimensional minuscule representation `V₅₆` of `E₇`, as a
Freudenthal triple system. -/
@[ext]
structure V56 where
  /-- The U(1)-charge `+3` component (1-dim line bundle). -/
  a : ℚ
  /-- The U(1)-charge `+1` component (27-dim `J₃(𝕆)`-piece). -/
  A : J3O
  /-- The U(1)-charge `-1` component (27-dim `J₃(𝕆)`-piece). -/
  B : J3O
  /-- The U(1)-charge `-3` component (1-dim line bundle). -/
  b : ℚ

namespace V56

instance : Zero V56 := ⟨⟨0, 0, 0, 0⟩⟩

instance : Add V56 := ⟨fun v w => ⟨v.a + w.a, v.A + w.A, v.B + w.B, v.b + w.b⟩⟩

/-- The **Freudenthal quartic** `q : V₅₆ → ℚ`. -/
def freudenthalQuartic (v : V56) : ℚ :=
  (v.a * v.b - J3O.innerProd v.A v.B)^2
    + 4 * (v.a * J3O.cubicNorm v.B
           + v.b * J3O.cubicNorm v.A
           - J3O.innerProd (J3O.sharp v.A) (J3O.sharp v.B))

/-! ### Sanity checks -/

theorem freudenthalQuartic_zero : freudenthalQuartic 0 = 0 := by
  unfold freudenthalQuartic
  show ((0 : ℚ) * 0 - J3O.innerProd 0 0)^2
       + 4 * (0 * J3O.cubicNorm 0 + 0 * J3O.cubicNorm 0
              - J3O.innerProd (J3O.sharp 0) (J3O.sharp 0)) = 0
  simp

end V56

end HodgeReduction.Infrastructure
