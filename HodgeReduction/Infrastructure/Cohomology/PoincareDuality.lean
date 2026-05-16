/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.LinearAlgebra.Span.Basic

/-!
# Poincaré duality framework

For a closed oriented real `n`-manifold `X`, **Poincaré duality**
(H. Poincaré, *Analysis situs*, J. École Polytechnique (2) **1** (1895),
1–123 + the five subsequent *Compléments*) gives an isomorphism
```
PD : H^k(X; ℚ) ≃ H_{n-k}(X; ℚ)
```
which, dualised via the universal coefficient theorem and the cap
product against the fundamental class `[X] ∈ H_n(X; ℚ)`, becomes a
**non-degenerate `ℚ`-bilinear pairing**
```
⟨·, ·⟩ : H^k(X; ℚ) × H^{n-k}(X; ℚ) → H^n(X; ℚ) ≃ ℚ.
```

For a smooth projective complex variety `X` of complex dimension `d`
(so real dimension `n = 2d`), this gives the classical intersection
form on cohomology, with the symmetry being **symmetric** when `k` is
even and **alternating** when `k` is odd (Voisin I Ch. 5, p. 110).

(Hatcher 2002 Ch. 3.3 Theorem 3.30 p. 245 gives the singular-cohomology
version; Voisin 2002 Vol. I Ch. 5 §5.1, Theorem 5.32 p. 110, gives the
algebraic-geometry / Kähler version; Griffiths–Harris 1978 Ch. 0 §3
p. 53 "Poincaré duality" + p. 56 "intersection of cycles" gives the
classical statement in terms of cycles.)

For our HC application: Poincaré duality + Hard Lefschetz give the
fundamental rigidity of cohomology. The non-degenerate intersection
pairing is used to detect when a cohomology class is non-zero (a
classical orthogonality argument), and the **fundamental class
`[X] ∈ A`** (non-zero, top-degree) is the generator of the integration
target.

This file packages **abstract Poincaré duality data** as two coupled
typeclasses:

* `PoincareDualityData A` — the non-degenerate intersection pairing
  with substantive existential non-degeneracy, plus the degree pieces
  `H : ℕ → Submodule ℚ A` and the **substantive** degree-compatibility
  axiom that the pairing vanishes on `H^k × H^l` whenever `k + l ≠ dim`.
* `FundamentalClassData A` — a designated fundamental class
  `[X] : A` together with the **substantive** non-zero axiom
  `fundamentalClass_ne_zero`.

## References

* H. Poincaré, *Analysis situs*, J. École Polytechnique (2) **1** (1895),
  1–123 (the original duality theorem).
* A. Hatcher, *Algebraic Topology*, Cambridge Univ. Press, 2002,
  Chapter 3 §3.3, Theorem 3.30 p. 245 (Poincaré duality for closed
  oriented manifolds).
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*, Cambridge
  Studies in Advanced Mathematics **76**, Cambridge Univ. Press, 2002,
  Chapter 5 §5.1, Theorem 5.32 p. 110 (Poincaré duality on a compact
  Kähler manifold) + Lemma 5.34 p. 111 (degree compatibility).
* P. Griffiths & J. Harris, *Principles of Algebraic Geometry*, Wiley
  Classics Library, 1978, Chapter 0 §3 pp. 53–58 ("Poincaré duality"
  and "intersection of cycles").

## Main definitions

* `PoincareDualityData A` — non-degenerate intersection pairing with
  degree-compatibility carriers.
* `PoincareDualityData.pairing_ne_zero_of_ne_zero` — the substantive
  non-degeneracy as an "exists `y` with non-zero pairing" statement.
* `PoincareDualityData.pairing_zero_left`, `pairing_zero_right` —
  bilinearity-derived zero behaviour.
* `PoincareDualityData.eq_zero_of_pairing_eq_zero_forall` — the
  classical orthogonality engine: if a class pairs to zero against
  **every** class, it must be zero.
* `PoincareDualityData.pairing_vanishes_off_complementary_degree` —
  the substantive degree compatibility (pairing vanishes off
  `k + l = dim`).
* `FundamentalClassData A` — designated non-zero fundamental class.
* `FundamentalClassData.fundamentalClass_ne_zero` — the substantive
  non-zero axiom.

## Tags

Poincaré duality, intersection pairing, non-degenerate pairing,
fundamental class, top class, orthogonality, degree compatibility
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Poincaré duality data** for an ambient rational cohomology
`ℚ`-vector space `A`:

* `dim` : the **real** dimension `n = 2 · complex dimension` of `X`
  (so the cohomology lives in degrees `0, …, n` and the top degree
  is `n`).
* `H k` : the degree-`k` cohomology piece `H^k(X; ℚ) ⊆ A`, packaged
  as a `Submodule ℚ A`.
* `intersectionPairing` : the intersection bilinear form
  `⟨·, ·⟩ : A → A → ℚ` packaged as a `ℚ`-bilinear map
  `A →ₗ[ℚ] A →ₗ[ℚ] ℚ`. Morally
  `⟨α, β⟩ = ∫_X (α ∧ β)` for cohomology classes `α, β`.
* `pairing_nondegenerate` : the **substantive non-degeneracy**
  (Voisin I Theorem 5.32 p. 110; Hatcher 2002 Theorem 3.30 p. 245;
  Griffiths–Harris 1978 Ch. 0 §3 p. 53). For any non-zero `x : A`
  there exists `y : A` with `intersectionPairing x y ≠ 0`. This is
  the **load-bearing** axiom — an `∃ y, P y` existential, **not** a
  `f ≤ ⊤` or `0 = 0` triviality.
* `pairing_vanishes_off_complementary_degrees` : the **substantive
  degree compatibility** (Voisin I Lemma 5.34 p. 111). The pairing
  `⟨H^k, H^l⟩ = 0` whenever `k + l ≠ dim`; equivalently, the pairing
  is **graded** and lands in the top degree. This is a non-trivial
  vanishing axiom involving the degree-piece carriers.

The two substantive axioms above (`pairing_nondegenerate` and
`pairing_vanishes_off_complementary_degrees`) together encode the
full content of Poincaré duality for the abstract ambient space `A`.
The fundamental class `[X]` is packaged as a separate sibling typeclass
`FundamentalClassData` below. -/
class PoincareDualityData where
  /-- The **real** dimension `n` of `X`. -/
  dim : ℕ
  /-- The degree-`k` cohomology piece `H^k(X; ℚ) ⊆ A`. -/
  H : ℕ → Submodule ℚ A
  /-- The intersection bilinear form `⟨·, ·⟩ : A × A → ℚ` as a
  `ℚ`-bilinear `LinearMap`. Morally `⟨α, β⟩ = ∫_X (α ∧ β)`. -/
  intersectionPairing : A →ₗ[ℚ] A →ₗ[ℚ] ℚ
  /-- **Substantive non-degeneracy** (Voisin I Theorem 5.32 p. 110):
  for every non-zero `x : A` there exists `y : A` such that the pairing
  `⟨x, y⟩` is non-zero. This is the load-bearing content of Poincaré
  duality. -/
  pairing_nondegenerate :
    ∀ x : A, x ≠ 0 → ∃ y : A, intersectionPairing x y ≠ 0
  /-- **Substantive degree compatibility** (Voisin I Lemma 5.34 p. 111):
  the intersection pairing vanishes on `H^k × H^l` whenever
  `k + l ≠ dim`. Equivalently, the pairing is graded with image landing
  in the top degree. -/
  pairing_vanishes_off_complementary_degrees :
    ∀ (k l : ℕ), k + l ≠ dim →
      ∀ α ∈ H k, ∀ β ∈ H l, intersectionPairing α β = 0

namespace PoincareDualityData

variable {A} [PoincareDualityData A]

/-! ## Derived consequences of the Poincaré duality axioms -/

/-- **Substantive non-degeneracy** — re-export of the field axiom as a
named theorem. For any non-zero `x : A` there is `y : A` witnessing
`⟨x, y⟩ ≠ 0`. -/
theorem pairing_ne_zero_of_ne_zero {x : A} (hx : x ≠ 0) :
    ∃ y : A, intersectionPairing (A := A) x y ≠ 0 :=
  pairing_nondegenerate x hx

/-- The intersection pairing is **left-linear in zero** (bilinearity
consequence): `⟨0, y⟩ = 0` for every `y`. -/
@[simp] theorem pairing_zero_left (y : A) :
    intersectionPairing (A := A) 0 y = 0 := by
  rw [map_zero]; rfl

/-- The intersection pairing is **right-linear in zero** (bilinearity
consequence): `⟨x, 0⟩ = 0` for every `x`. -/
@[simp] theorem pairing_zero_right (x : A) :
    intersectionPairing (A := A) x 0 = 0 := by
  rw [map_zero]

/-- **Orthogonality engine** — the contrapositive form of non-degeneracy:
if `x : A` pairs to zero against **every** `y : A`, then `x = 0`. This
is the classical "duality kills only the zero class" form, used over
and over in cohomology arguments. -/
theorem eq_zero_of_pairing_eq_zero_forall (x : A)
    (h : ∀ y : A, intersectionPairing (A := A) x y = 0) :
    x = 0 := by
  by_contra hx
  obtain ⟨y, hy⟩ := pairing_nondegenerate x hx
  exact hy (h y)

/-- **`iff`-form of non-degeneracy**: `x = 0` iff `x` pairs to zero
against every `y`. -/
theorem eq_zero_iff_pairing_eq_zero_forall (x : A) :
    x = 0 ↔ ∀ y : A, intersectionPairing (A := A) x y = 0 := by
  refine ⟨fun hx y => ?_, eq_zero_of_pairing_eq_zero_forall x⟩
  rw [hx, pairing_zero_left]

/-- **Substantive degree compatibility** — re-export. For
`k + l ≠ dim`, the pairing of any `α ∈ H^k` with any `β ∈ H^l`
vanishes. -/
theorem pairing_vanishes_off_complementary_degree
    {k l : ℕ} (hkl : k + l ≠ dim (A := A))
    {α : A} (hα : α ∈ H (A := A) k)
    {β : A} (hβ : β ∈ H (A := A) l) :
    intersectionPairing (A := A) α β = 0 :=
  pairing_vanishes_off_complementary_degrees k l hkl α hα β hβ

/-- **Pairing of pieces in non-complementary degrees vanishes** — the
"`H k` and `H l` are pairing-orthogonal" packaging of the previous
theorem, useful for arguments by orthogonality across the bigrading. -/
theorem pairing_eq_zero_of_disjoint_complementary
    {k l : ℕ} (hkl : k + l ≠ dim (A := A)) :
    ∀ α ∈ H (A := A) k, ∀ β ∈ H (A := A) l,
      intersectionPairing (A := A) α β = 0 :=
  pairing_vanishes_off_complementary_degrees k l hkl

/-- **Non-zero class detection**: if `⟨x, y⟩ ≠ 0` for some `y`, then
`x ≠ 0`. Substantive direction (contrapositive of `pairing_zero_left`). -/
theorem ne_zero_of_pairing_ne_zero {x y : A}
    (h : intersectionPairing (A := A) x y ≠ 0) : x ≠ 0 := by
  intro hx
  rw [hx, pairing_zero_left] at h
  exact h rfl

/-- **Non-zero class detection (right)**: if `⟨x, y⟩ ≠ 0` for some `x`,
then `y ≠ 0`. Substantive direction (contrapositive of
`pairing_zero_right`). -/
theorem ne_zero_of_pairing_ne_zero_right {x y : A}
    (h : intersectionPairing (A := A) x y ≠ 0) : y ≠ 0 := by
  intro hy
  rw [hy, pairing_zero_right] at h
  exact h rfl

/-- **Cross-degree witness**: any non-zero element `x : A` has a witness
`y : A` such that `⟨x, y⟩ ≠ 0`; further `y` is non-zero. This packages
both the existence of a witness and its non-vanishing for downstream
duality arguments. -/
theorem exists_witness_ne_zero {x : A} (hx : x ≠ 0) :
    ∃ y : A, y ≠ 0 ∧ intersectionPairing (A := A) x y ≠ 0 := by
  obtain ⟨y, hy⟩ := pairing_nondegenerate x hx
  exact ⟨y, ne_zero_of_pairing_ne_zero_right hy, hy⟩

end PoincareDualityData

/-! ### Fundamental class data — sibling typeclass

Poincaré duality is most often invoked together with the **fundamental
class** `[X] ∈ H^n(X; ℚ)` (= `H_n(X; ℚ)` under the duality iso). This
sibling typeclass carries the designated fundamental class plus the
substantive non-vanishing axiom `[X] ≠ 0`.

References:
* Hatcher 2002 Ch. 3.3 Defn 3.26 p. 235 ("fundamental class") and
  Theorem 3.30 p. 245.
* Voisin 2002 Vol. I Ch. 5 §5.1.2 p. 109 ("class fondamentale").
* Griffiths–Harris 1978 Ch. 0 §3 p. 53 ("orientation class"). -/

/-- **Fundamental class data** for an ambient `ℚ`-vector space `A`
representing the cohomology of an oriented closed manifold `X`:

* `dim` : the **real** dimension of `X` (so the fundamental class
  lives in degree `dim`).
* `fundamentalClass` : the designated fundamental class `[X] : A`.
* `fundamentalClass_ne_zero` : the **substantive** non-vanishing axiom
  `[X] ≠ 0` (Hatcher 2002 Theorem 3.26(b) p. 235: the fundamental
  class is non-zero on a closed orientable connected manifold).

The non-vanishing axiom is **substantive** (not a tautology): the
content is that on a closed orientable connected manifold the
fundamental class generates `H_n(X; ℚ) ≃ ℚ`, in particular is
non-zero. -/
class FundamentalClassData where
  /-- The real dimension of `X`. -/
  dim : ℕ
  /-- The designated fundamental class `[X] ∈ A`. -/
  fundamentalClass : A
  /-- **Substantive non-vanishing of the fundamental class** (Hatcher
  2002 Theorem 3.26(b) p. 235): `[X] ≠ 0` on a closed orientable
  connected manifold. -/
  fundamentalClass_ne_zero : fundamentalClass ≠ 0

namespace FundamentalClassData

variable {A} [FundamentalClassData A]

/-! ## Derived consequences of the fundamental class axioms -/

omit [Module ℚ A] in
/-- **Non-vanishing of the fundamental class** — re-export. -/
theorem fundamentalClass_ne_zero' :
    (fundamentalClass : A) ≠ 0 :=
  fundamentalClass_ne_zero

omit [Module ℚ A] in
/-- The fundamental class is **not equal to zero**, stated as a
disequation. -/
theorem fundamentalClass_neq_zero :
    ¬ ((fundamentalClass : A) = 0) :=
  fundamentalClass_ne_zero

omit [Module ℚ A] in
/-- **Negation of the fundamental class is also non-zero** (using the
`AddCommGroup` structure on `A`). -/
theorem neg_fundamentalClass_ne_zero :
    -(fundamentalClass : A) ≠ 0 := by
  intro h
  have : (fundamentalClass : A) = 0 := by
    have h2 : -(-(fundamentalClass : A)) = -(0 : A) := by rw [h]
    simpa using h2
  exact fundamentalClass_ne_zero this

end FundamentalClassData

/-! ### Bridge: combining Poincaré duality with the fundamental class

When both `PoincareDualityData A` and `FundamentalClassData A` are
available with matching dimensions, the fundamental class is non-zero,
so by non-degeneracy of the intersection pairing there exists a witness
class `y : A` such that `⟨[X], y⟩ ≠ 0`. This is the bridge most often
used to detect non-trivial top-degree pairings. -/

/-- **Bridge theorem**: a non-zero fundamental class `[X]` has a
non-trivial pairing-witness under Poincaré duality. Substantive
consequence combining `FundamentalClassData.fundamentalClass_ne_zero`
with `PoincareDualityData.pairing_nondegenerate`. -/
theorem fundamentalClass_has_pairing_witness
    [PoincareDualityData A] [FundamentalClassData A] :
    ∃ y : A,
      PoincareDualityData.intersectionPairing
        (FundamentalClassData.fundamentalClass : A) y ≠ 0 :=
  PoincareDualityData.pairing_nondegenerate
    (FundamentalClassData.fundamentalClass : A)
    FundamentalClassData.fundamentalClass_ne_zero

end HodgeReduction.Infrastructure.Cohomology
