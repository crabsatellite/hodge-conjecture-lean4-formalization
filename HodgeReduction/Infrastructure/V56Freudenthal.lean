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

/-! ### Symmetry and scalar-mult behaviour -/

/-- `innerProd` is **symmetric**: `⟨A, B⟩ = ⟨B, A⟩`. -/
theorem innerProd_symm (A B : J3O) : innerProd A B = innerProd B A := by
  unfold innerProd
  -- Reduce to component-wise statements. For the diagonal: `α₁β₁ = β₁α₁` etc.
  -- For the off-diagonals: `Re(a · b̄) = Re(b · ā)`, which we prove by
  -- expanding `Re` and `conj` and using `ring`.
  have hre : ∀ (a b : OctonionQ),
      OctonionQ.re (a * OctonionQ.conj b) = OctonionQ.re (b * OctonionQ.conj a) := by
    intro a b
    show (a * OctonionQ.conj b).e0 = (b * OctonionQ.conj a).e0
    simp [OctonionQ.conj]
    ring
  rw [hre A.x1 B.x1, hre A.x2 B.x2, hre A.x3 B.x3]
  ring

/-- `innerProd` is scalar-bilinear: `⟨r • A, r • B⟩ = r² · ⟨A, B⟩`. -/
theorem innerProd_smul_diag (r : ℚ) (A B : J3O) :
    innerProd (r • A) (r • B) = r^2 * innerProd A B := by
  unfold innerProd
  simp only [J3O.smul_xi1, J3O.smul_xi2, J3O.smul_xi3,
             J3O.smul_x1, J3O.smul_x2, J3O.smul_x3,
             OctonionQ.conj_smul, OctonionQ.smul_mul_smul, OctonionQ.re_smul]
  ring

/-! ### Component lemmas for J3O `Add`, `Neg`. -/

@[simp] theorem add_xi1 (X Y : J3O) : (X + Y).xi1 = X.xi1 + Y.xi1 := rfl
@[simp] theorem add_xi2 (X Y : J3O) : (X + Y).xi2 = X.xi2 + Y.xi2 := rfl
@[simp] theorem add_xi3 (X Y : J3O) : (X + Y).xi3 = X.xi3 + Y.xi3 := rfl
@[simp] theorem add_x1 (X Y : J3O) : (X + Y).x1 = X.x1 + Y.x1 := rfl
@[simp] theorem add_x2 (X Y : J3O) : (X + Y).x2 = X.x2 + Y.x2 := rfl
@[simp] theorem add_x3 (X Y : J3O) : (X + Y).x3 = X.x3 + Y.x3 := rfl

@[simp] theorem neg_xi1 (X : J3O) : (-X).xi1 = -X.xi1 := rfl
@[simp] theorem neg_xi2 (X : J3O) : (-X).xi2 = -X.xi2 := rfl
@[simp] theorem neg_xi3 (X : J3O) : (-X).xi3 = -X.xi3 := rfl
@[simp] theorem neg_x1 (X : J3O) : (-X).x1 = -X.x1 := rfl
@[simp] theorem neg_x2 (X : J3O) : (-X).x2 = -X.x2 := rfl
@[simp] theorem neg_x3 (X : J3O) : (-X).x3 = -X.x3 := rfl

/-! ### Full bilinearity of `innerProd` -/

/-- `innerProd` is **left-linear** under scalar multiplication:
`⟨r • A, B⟩ = r · ⟨A, B⟩`. -/
theorem innerProd_smul_left (r : ℚ) (A B : J3O) :
    innerProd (r • A) B = r * innerProd A B := by
  unfold innerProd
  simp only [J3O.smul_xi1, J3O.smul_xi2, J3O.smul_xi3,
             J3O.smul_x1, J3O.smul_x2, J3O.smul_x3,
             OctonionQ.smul_mul, OctonionQ.re_smul]
  ring

/-- `innerProd` is **right-linear** under scalar multiplication:
`⟨A, r • B⟩ = r · ⟨A, B⟩`. -/
theorem innerProd_smul_right (r : ℚ) (A B : J3O) :
    innerProd A (r • B) = r * innerProd A B := by
  rw [innerProd_symm, innerProd_smul_left, innerProd_symm]

/-- `innerProd` is **left-additive**: `⟨A + A', B⟩ = ⟨A, B⟩ + ⟨A', B⟩`. -/
theorem innerProd_add_left (A A' B : J3O) :
    innerProd (A + A') B = innerProd A B + innerProd A' B := by
  unfold innerProd
  have hmul : ∀ (a b c : OctonionQ),
      (a + b) * c = a * c + b * c := by
    intro a b c; ext <;> simp <;> ring
  have hre_add : ∀ (a b : OctonionQ), OctonionQ.re (a + b) = OctonionQ.re a + OctonionQ.re b := by
    intro a b; rfl
  simp only [add_xi1, add_xi2, add_xi3, add_x1, add_x2, add_x3,
             hmul, hre_add]
  ring

/-- `innerProd` is **right-additive**: `⟨A, B + B'⟩ = ⟨A, B⟩ + ⟨A, B'⟩`. -/
theorem innerProd_add_right (A B B' : J3O) :
    innerProd A (B + B') = innerProd A B + innerProd A B' := by
  rw [innerProd_symm A (B + B'), innerProd_add_left,
      innerProd_symm B A, innerProd_symm B' A]

/-- `innerProd` is **left-negation-compatible**: `⟨-A, B⟩ = -⟨A, B⟩`. -/
theorem innerProd_neg_left (A B : J3O) :
    innerProd (-A) B = -innerProd A B := by
  unfold innerProd
  have hmul : ∀ (a c : OctonionQ), (-a) * c = -(a * c) := by
    intro a c; ext <;> simp <;> ring
  have hre_neg : ∀ (a : OctonionQ), OctonionQ.re (-a) = -OctonionQ.re a := by
    intro a; rfl
  simp only [neg_xi1, neg_xi2, neg_xi3, neg_x1, neg_x2, neg_x3,
             hmul, hre_neg]
  ring

/-- `innerProd` is **right-negation-compatible**: `⟨A, -B⟩ = -⟨A, B⟩`. -/
theorem innerProd_neg_right (A B : J3O) :
    innerProd A (-B) = -innerProd A B := by
  rw [innerProd_symm A (-B), innerProd_neg_left, innerProd_symm B A]

/-- `sharp` is **quadratic** (homogeneous of degree 2): `(r • A)^# = r² • A^#`. -/
theorem sharp_smul (r : ℚ) (A : J3O) : sharp (r • A) = r^2 • sharp A := by
  -- We prove this field-by-field using `J3O.ext`.
  refine J3O.ext ?h1 ?h2 ?h3 ?hx1 ?hx2 ?hx3
  · show (r • A).xi2 * (r • A).xi3 - OctonionQ.normSq (r • A).x1
         = r^2 * (A.xi2 * A.xi3 - OctonionQ.normSq A.x1)
    simp [OctonionQ.normSq_smul]; ring
  · show (r • A).xi3 * (r • A).xi1 - OctonionQ.normSq (r • A).x2
         = r^2 * (A.xi3 * A.xi1 - OctonionQ.normSq A.x2)
    simp [OctonionQ.normSq_smul]; ring
  · show (r • A).xi1 * (r • A).xi2 - OctonionQ.normSq (r • A).x3
         = r^2 * (A.xi1 * A.xi2 - OctonionQ.normSq A.x3)
    simp [OctonionQ.normSq_smul]; ring
  · -- (sharp (r • A)).x1 = (r²) • (sharp A).x1
    show OctonionQ.conj (r • A.x2) * OctonionQ.conj (r • A.x3) - (r * A.xi1) • (r • A.x1)
         = r^2 • (OctonionQ.conj A.x2 * OctonionQ.conj A.x3 - A.xi1 • A.x1)
    rw [OctonionQ.conj_smul, OctonionQ.conj_smul,
        OctonionQ.smul_mul_smul, OctonionQ.smul_smul,
        OctonionQ.smul_sub]
    congr 1
    · show (r * r) • _ = r^2 • _; rw [show r * r = r^2 from by ring]
    · show (r * A.xi1 * r) • A.x1 = r^2 • (A.xi1 • A.x1)
      rw [show r * A.xi1 * r = r * r * A.xi1 from by ring,
          show r * r = r^2 from by ring, ← OctonionQ.smul_smul]
  · show OctonionQ.conj (r • A.x3) * OctonionQ.conj (r • A.x1) - (r * A.xi2) • (r • A.x2)
         = r^2 • (OctonionQ.conj A.x3 * OctonionQ.conj A.x1 - A.xi2 • A.x2)
    rw [OctonionQ.conj_smul, OctonionQ.conj_smul,
        OctonionQ.smul_mul_smul, OctonionQ.smul_smul,
        OctonionQ.smul_sub]
    congr 1
    · show (r * r) • _ = r^2 • _; rw [show r * r = r^2 from by ring]
    · show (r * A.xi2 * r) • A.x2 = r^2 • (A.xi2 • A.x2)
      rw [show r * A.xi2 * r = r * r * A.xi2 from by ring,
          show r * r = r^2 from by ring, ← OctonionQ.smul_smul]
  · show OctonionQ.conj (r • A.x1) * OctonionQ.conj (r • A.x2) - (r * A.xi3) • (r • A.x3)
         = r^2 • (OctonionQ.conj A.x1 * OctonionQ.conj A.x2 - A.xi3 • A.x3)
    rw [OctonionQ.conj_smul, OctonionQ.conj_smul,
        OctonionQ.smul_mul_smul, OctonionQ.smul_smul,
        OctonionQ.smul_sub]
    congr 1
    · show (r * r) • _ = r^2 • _; rw [show r * r = r^2 from by ring]
    · show (r * A.xi3 * r) • A.x3 = r^2 • (A.xi3 • A.x3)
      rw [show r * A.xi3 * r = r * r * A.xi3 from by ring,
          show r * r = r^2 from by ring, ← OctonionQ.smul_smul]

/-- `sharp` is **even** at the level of negation: `(-A)^# = A^#` (degree-2 corollary).
The proof works via `-A = (-1) • A` and `sharp_smul` with `r = -1`, giving
`sharp (-A) = (-1)² • sharp A = sharp A`. -/
theorem sharp_neg (A : J3O) : sharp (-A) = sharp A := by
  have hA : -A = (-1 : ℚ) • A := by
    refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
    · show -A.xi1 = (-1 : ℚ) * A.xi1; ring
    · show -A.xi2 = (-1 : ℚ) * A.xi2; ring
    · show -A.xi3 = (-1 : ℚ) * A.xi3; ring
    · show -A.x1 = (-1 : ℚ) • A.x1; ext <;> simp
    · show -A.x2 = (-1 : ℚ) • A.x2; ext <;> simp
    · show -A.x3 = (-1 : ℚ) • A.x3; ext <;> simp
  rw [hA, sharp_smul]
  -- Now: (-1)² • sharp A = sharp A
  refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
  · show ((-1 : ℚ)^2) * (sharp A).xi1 = (sharp A).xi1; ring
  · show ((-1 : ℚ)^2) * (sharp A).xi2 = (sharp A).xi2; ring
  · show ((-1 : ℚ)^2) * (sharp A).xi3 = (sharp A).xi3; ring
  · show ((-1 : ℚ)^2) • (sharp A).x1 = (sharp A).x1; ext <;> simp
  · show ((-1 : ℚ)^2) • (sharp A).x2 = (sharp A).x2; ext <;> simp
  · show ((-1 : ℚ)^2) • (sharp A).x3 = (sharp A).x3; ext <;> simp

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

instance : Neg V56 := ⟨fun v => ⟨-v.a, -v.A, -v.B, -v.b⟩⟩

instance : SMul ℚ V56 := ⟨fun r v => ⟨r * v.a, r • v.A, r • v.B, r * v.b⟩⟩

/-! ### Component lemmas for `Zero`, `Add`, `SMul`. -/

@[simp] theorem zero_a : (0 : V56).a = 0 := rfl
@[simp] theorem zero_A : (0 : V56).A = 0 := rfl
@[simp] theorem zero_B : (0 : V56).B = 0 := rfl
@[simp] theorem zero_b : (0 : V56).b = 0 := rfl

@[simp] theorem smul_a (r : ℚ) (v : V56) : (r • v).a = r * v.a := rfl
@[simp] theorem smul_A (r : ℚ) (v : V56) : (r • v).A = r • v.A := rfl
@[simp] theorem smul_B (r : ℚ) (v : V56) : (r • v).B = r • v.B := rfl
@[simp] theorem smul_b (r : ℚ) (v : V56) : (r • v).b = r * v.b := rfl

@[simp] theorem add_a (v w : V56) : (v + w).a = v.a + w.a := rfl
@[simp] theorem add_A (v w : V56) : (v + w).A = v.A + w.A := rfl
@[simp] theorem add_B (v w : V56) : (v + w).B = v.B + w.B := rfl
@[simp] theorem add_b (v w : V56) : (v + w).b = v.b + w.b := rfl

@[simp] theorem neg_a (v : V56) : (-v).a = -v.a := rfl
@[simp] theorem neg_A (v : V56) : (-v).A = -v.A := rfl
@[simp] theorem neg_B (v : V56) : (-v).B = -v.B := rfl
@[simp] theorem neg_b (v : V56) : (-v).b = -v.b := rfl

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

/-! ### Freudenthal-quartic homogeneity (degree 4)

The Freudenthal quartic `q` is **homogeneous of degree 4**: `q(r • v) = r⁴ · q(v)`.
This is the defining property of the Sato-Kimura prehomogeneous quartic and
the source of the `r⁴` scaling that makes `q` an `E₇`-invariant. The proof
uses:
* `cubicNorm` is degree-3 in its argument.
* `sharp` is degree-2 in its argument.
* `innerProd` is bilinear, so `⟨r·X, r·Y⟩ = r² · ⟨X, Y⟩` (`innerProd_smul_diag`).
* Combining: `⟨(r•A)^#, (r•B)^#⟩ = ⟨r²•A^#, r²•B^#⟩ = r⁴ · ⟨A^#, B^#⟩`.
-/

/-- **Freudenthal-quartic homogeneity**: `q(r • v) = r⁴ · q(v)`. -/
theorem freudenthalQuartic_smul (r : ℚ) (v : V56) :
    freudenthalQuartic (r • v) = r^4 * freudenthalQuartic v := by
  unfold freudenthalQuartic
  simp only [smul_a, smul_b, smul_A, smul_B,
             J3O.innerProd_smul_diag,
             J3O.cubicNorm_smul,
             J3O.sharp_smul]
  ring

/-- The Freudenthal quartic is **even**: `q(-v) = q(v)` (degree-4 corollary). -/
theorem freudenthalQuartic_neg (v : V56) :
    freudenthalQuartic (-v) = freudenthalQuartic v := by
  -- `-v = (-1) • v`, and `q((-1) • v) = (-1)⁴ · q(v) = q(v)`.
  have h : -v = (-1 : ℚ) • v := by
    refine V56.ext ?_ ?_ ?_ ?_
    · show -v.a = (-1 : ℚ) * v.a; ring
    · show -v.A = (-1 : ℚ) • v.A
      refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
      · show -v.A.xi1 = (-1 : ℚ) * v.A.xi1; ring
      · show -v.A.xi2 = (-1 : ℚ) * v.A.xi2; ring
      · show -v.A.xi3 = (-1 : ℚ) * v.A.xi3; ring
      · show -v.A.x1 = (-1 : ℚ) • v.A.x1; ext <;> simp
      · show -v.A.x2 = (-1 : ℚ) • v.A.x2; ext <;> simp
      · show -v.A.x3 = (-1 : ℚ) • v.A.x3; ext <;> simp
    · show -v.B = (-1 : ℚ) • v.B
      refine J3O.ext ?_ ?_ ?_ ?_ ?_ ?_
      · show -v.B.xi1 = (-1 : ℚ) * v.B.xi1; ring
      · show -v.B.xi2 = (-1 : ℚ) * v.B.xi2; ring
      · show -v.B.xi3 = (-1 : ℚ) * v.B.xi3; ring
      · show -v.B.x1 = (-1 : ℚ) • v.B.x1; ext <;> simp
      · show -v.B.x2 = (-1 : ℚ) • v.B.x2; ext <;> simp
      · show -v.B.x3 = (-1 : ℚ) • v.B.x3; ext <;> simp
    · show -v.b = (-1 : ℚ) * v.b; ring
  rw [h, freudenthalQuartic_smul]
  norm_num

/-! ### The symplectic form `ω : V₅₆ × V₅₆ → ℚ`

Beyond the Freudenthal quartic `q`, the 56-dim Freudenthal triple system carries
a canonical **antisymmetric bilinear form** `ω`, the symplectic form making
`V₅₆` a 56-dim symplectic representation of `E₇` ⊂ `Sp(56, ℚ)`.

For `v = (a, A, B, b)` and `w = (c, C, D, d)`:
```
   ω(v, w) = a·d - b·c + ⟨A, D⟩ - ⟨B, C⟩
```

Key properties (proven here):
* `omega_antisymm`: `ω(v, w) = -ω(w, v)`
* `omega_zero_left`: `ω(0, w) = 0`
* `omega_smul_left`: `ω(r • v, w) = r · ω(v, w)`
* `omega_smul_diag`: `ω(r • v, r • w) = r² · ω(v, w)` (homogeneous of degree 2)

`E₇` is precisely the subgroup of `GL(V₅₆)` preserving the pair `(q, ω)`.

References:
* R. B. Brown, "Groups of type E_7", *J. Reine Angew. Math.* **236** (1969),
  79-102.
* H. Freudenthal, "Beziehungen der E_7 und E_8 zur Oktavenebene I-V",
  *Indag. Math.* **16-17** (1954-55).
-/

/-- The **symplectic form** `ω : V₅₆ × V₅₆ → ℚ` on the 56-dim Freudenthal
triple system. -/
def omega (v w : V56) : ℚ :=
  v.a * w.b - v.b * w.a + J3O.innerProd v.A w.B - J3O.innerProd v.B w.A

/-- `ω` is **antisymmetric**: `ω(v, w) = -ω(w, v)`. -/
theorem omega_antisymm (v w : V56) : omega v w = -omega w v := by
  unfold omega
  rw [J3O.innerProd_symm v.A w.B, J3O.innerProd_symm v.B w.A]
  ring

/-- `ω(v, v) = 0` (consequence of antisymmetry). -/
@[simp] theorem omega_self (v : V56) : omega v v = 0 := by
  have h : omega v v = -omega v v := omega_antisymm v v
  linarith

/-- `ω(0, w) = 0`. -/
@[simp] theorem omega_zero_left (w : V56) : omega 0 w = 0 := by
  unfold omega
  show (0 : ℚ) * w.b - 0 * w.a + J3O.innerProd 0 w.B - J3O.innerProd 0 w.A = 0
  simp

/-- `ω(v, 0) = 0`. -/
@[simp] theorem omega_zero_right (v : V56) : omega v 0 = 0 := by
  rw [omega_antisymm, omega_zero_left, neg_zero]

/-- `ω` is **left-linear** under scalar multiplication: `ω(r • v, w) = r · ω(v, w)`. -/
theorem omega_smul_left (r : ℚ) (v w : V56) :
    omega (r • v) w = r * omega v w := by
  unfold omega
  simp only [smul_a, smul_b, smul_A, smul_B,
             J3O.innerProd_smul_left]
  ring

/-- `ω` is **right-linear** under scalar multiplication: `ω(v, r • w) = r · ω(v, w)`. -/
theorem omega_smul_right (r : ℚ) (v w : V56) :
    omega v (r • w) = r * omega v w := by
  unfold omega
  simp only [smul_a, smul_b, smul_A, smul_B,
             J3O.innerProd_smul_right]
  ring

/-- `ω` is **diagonal-quadratic**: `ω(r • v, r • w) = r² · ω(v, w)`. -/
theorem omega_smul_diag (r : ℚ) (v w : V56) :
    omega (r • v) (r • w) = r^2 * omega v w := by
  rw [omega_smul_left, omega_smul_right]; ring

/-- `ω` is **left-additive**: `ω(v + v', w) = ω(v, w) + ω(v', w)`. -/
theorem omega_add_left (v v' w : V56) :
    omega (v + v') w = omega v w + omega v' w := by
  unfold omega
  simp only [add_a, add_b, add_A, add_B,
             J3O.innerProd_add_left]
  ring

/-- `ω` is **right-additive**: `ω(v, w + w') = ω(v, w) + ω(v, w')`. -/
theorem omega_add_right (v w w' : V56) :
    omega v (w + w') = omega v w + omega v w' := by
  unfold omega
  simp only [add_a, add_b, add_A, add_B,
             J3O.innerProd_add_right]
  ring

/-- `ω` is **left-negation-compatible**: `ω(-v, w) = -ω(v, w)`. -/
theorem omega_neg_left (v w : V56) : omega (-v) w = -omega v w := by
  unfold omega
  simp only [neg_a, neg_b, neg_A, neg_B,
             J3O.innerProd_neg_left]
  ring

/-- `ω` is **right-negation-compatible**: `ω(v, -w) = -ω(v, w)`. -/
theorem omega_neg_right (v w : V56) : omega v (-w) = -omega v w := by
  unfold omega
  simp only [neg_a, neg_b, neg_A, neg_B,
             J3O.innerProd_neg_right]
  ring

end V56

end HodgeReduction.Infrastructure
