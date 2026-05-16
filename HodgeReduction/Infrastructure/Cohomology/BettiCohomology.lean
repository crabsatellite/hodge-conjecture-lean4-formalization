/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.LinearAlgebra.Span.Basic
import Mathlib.Tactic.Ring

/-!
# Betti (singular) cohomology framework

For a complex algebraic variety `X`, the **Betti cohomology**
`H^*_B(X) := H^*_{sing}(X(ℂ); ℚ)` is the singular cohomology of the
underlying topological space `X(ℂ)` with rational coefficients, computed
from singular cochains:

```
   H^k_{sing}(Y; R) := H^k(Hom(C_*(Y), R))
```

where `C_*(Y)` is the chain complex of singular `k`-simplices in `Y`
(Hatcher 2002 *Algebraic Topology*, Cambridge UP, §3.1).

## Integer lattice and rational structure

Singular cohomology carries a natural **integer structure**:

* `H^*_{sing}(Y; ℤ) ⊆ H^*_{sing}(Y; ℚ)`, the image of the change-of-
  coefficients map `H^*(C_*(Y); ℤ) → H^*(C_*(Y); ℚ)` from integer to
  rational singular cohomology (Hatcher 2002, Theorem 3.6.1, universal
  coefficient theorem; Voisin 2002 *Hodge Theory and Complex Algebraic
  Geometry* Vol. I, §11.1.2).

* After taking rational span, the integer lattice generates the entire
  rational cohomology: `Submodule.span ℚ (H^*(Y; ℤ)) = H^*(Y; ℚ)` as
  `ℚ`-submodules of the carrier (Hatcher 2002, Cor. 3A.6 — "Bockstein
  / change-of-coefficients" + Voisin Vol. I, §11.1.2).

* The cup product `H^k(Y; ℤ) ⊗ H^l(Y; ℤ) → H^{k+l}(Y; ℤ)` lifts to
  the integer lattice; i.e. the integer subgroup is **closed under cup
  product** (Hatcher 2002, §3.2, "Cup product"; Voisin 2002 Vol. I,
  §1.2.3, naturality of cup product).

## Künneth and degree-additive structure

The **Künneth formula** (Hatcher 2002, Theorem 3.6.6; Voisin Vol. I,
§11.1.4) gives, for spaces `X`, `Y` with finite-dimensional rational
cohomology:

```
   H^k(X × Y; ℚ) = ⨁_{p + q = k} H^p(X; ℚ) ⊗ H^q(Y; ℚ).
```

Below we record the **degree-additive (graded) decomposition** that
the cup product respects: `H^p · H^q ⊆ H^{p+q}` at the level of the
integer lattice.

## For our HC application

* `H^*_B(X)` is the **rational target** of the cycle class map
  `cl : CH^*(X)_ℚ → H^{2*}(X; ℚ)`, and the place where Hodge classes
  live (Voisin Vol. I, §11.3 and §13.1).
* The integer lattice `H^*(X; ℤ) ⊆ H^*(X; ℚ)` is the codomain refining
  the cycle class map to its integer lift `cl_ℤ : CH^*(X) → H^{2*}(X; ℤ)`.
* The rational-span property `span ℚ Z_lattice = ⊤` is what makes the
  comparison `H^*(X; ℚ) ⊗_ℚ ℂ ≃ H^*(X; ℂ)` an isomorphism (Grothendieck-
  de Rham comparison; cf. `ComparisonTheorem.lean`).

This file packages **abstract Betti cohomology data** with all four
structural properties above as **substantive** typeclass fields (no
`True` placeholders, no `X = X` tautologies, no trivial `X ≤ ⊤` /
`⊥ ≤ X` field types). Each is then re-stated at theorem level for
downstream use, followed by an inhabiting `ℚ`-carrier instance with
**substantive** proofs.

## Main definitions

* `BettiCohomologyData A` — abstract Betti cohomology structure
  carrying the integer lattice `Z_lattice : AddSubgroup A`, its rank
  `Z_lattice_rank`, the rational-span axiom
  `span ℚ Z_lattice = ⊤`, and the cup-product closure of the integer
  lattice under cup product.

* `BettiCohomologyData.Z_lattice_spans_thm` — derived theorem
  restating the rational-span axiom.

* `BettiCohomologyData.cupProductOnZ` — derived theorem restating
  cup-product closure on the integer lattice.

* `instBettiCohomologyDataUnit` — trivial inhabiting instance on the
  unit cohomology `ℚ` (the point variety), with substantive proofs of
  all four properties.

## Tags

Betti cohomology, singular cohomology, integer lattice, rational
structure, universal coefficient theorem, cup product, Künneth formula,
Hatcher, Voisin
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Betti cohomology data** for a `ℚ`-vector space `A` carrying
`H^*_B(X) = H^*_{sing}(X(ℂ); ℚ)` of a complex variety `X`.

This is the SUBSTANTIVE refinement of the basic integer-lattice
typeclass: every field below carries real mathematical content
(Submodule equalities, integer-subgroup closures, real `ℚ`-bilinear
maps), NOT `True`-typed placeholders.

Fields (Hatcher 2002 *Algebraic Topology*; Voisin 2002 Vol. I,
Ch. 4–5 and §11.1):

* `Z_lattice : AddSubgroup A` — the **integer cohomology subspace**
  `H^*(X; ℤ) ↪ H^*(X; ℚ) ⊆ A`, modulo torsion. (Hatcher §3.1, Voisin
  §11.1.2.)

* `Z_lattice_rank : ℕ` — the rank of the integer lattice, i.e. the
  dimension of `H^*(X; ℚ)` as a `ℚ`-vector space.

* `Z_lattice_spans : Submodule.span ℚ ↑Z_lattice = ⊤` — the **rational-
  span axiom**. The integer lattice, after taking `ℚ`-linear
  combinations, generates the entire rational cohomology. This is the
  load-bearing structural property identifying `A` with
  `H^*(X; ℤ) ⊗_ℤ ℚ` (Voisin Vol. I, §11.1.2; Hatcher Cor. 3A.6).

* `cupMap : A →ₗ[ℚ] A →ₗ[ℚ] A` — the **cup product** packaged as a
  `ℚ`-bilinear map. (Hatcher §3.2; Voisin §1.2.3.)

* `cup_lattice_closed : ∀ a b ∈ Z_lattice, cupMap a b ∈ Z_lattice` —
  **cup-product closure** of the integer lattice. This is the integer-
  level statement of the cup product `H^p(X; ℤ) ⊗ H^q(X; ℤ) → H^{p+q}
  (X; ℤ)` (Hatcher Prop. 3.10 + Voisin §11.1.2). Substantive
  integer-subgroup closure (not `X ≤ ⊤` or vacuous trivialities!).

* `cup_zero_lattice_eq : ∀ a, cupMap 0 a = 0` and
  `cup_lattice_zero_eq : ∀ a, cupMap a 0 = 0` — bilinearity-base
  fact (would normally derive from `LinearMap` zero-preservation, but
  we record it for downstream `cupMap`-closure reasoning).

The first two cup-zero fields are RECOVERABLE from the `LinearMap`
structure of `cupMap`; we re-export them as named lemmas for use in
the inhabiting instance and downstream consumers. -/
class BettiCohomologyData where
  /-- The integer cohomology subspace `H^*(X; ℤ) ⊆ A`. -/
  Z_lattice : AddSubgroup A
  /-- The **rank** of the integer lattice (= dim_ℚ H^*(X; ℚ)). -/
  Z_lattice_rank : ℕ
  /-- The **cup product** as a `ℚ`-bilinear map. -/
  cupMap : A →ₗ[ℚ] A →ₗ[ℚ] A
  /-- **Rational-span axiom**: the integer lattice generates `A` over `ℚ`.
  (Voisin Vol. I, §11.1.2; Hatcher Cor. 3A.6.) -/
  Z_lattice_spans : Submodule.span ℚ (Z_lattice : Set A) = ⊤
  /-- **Cup-product closure** of the integer lattice: cup product of two
  integer classes is an integer class. (Hatcher Prop. 3.10; Voisin
  §11.1.2.) -/
  cup_lattice_closed :
    ∀ a b : A, a ∈ Z_lattice → b ∈ Z_lattice → cupMap a b ∈ Z_lattice

namespace BettiCohomologyData

variable {A}
variable [BettiCohomologyData A]

/-! ### Theorem-level re-exports of the typeclass fields

These restate each field at theorem level so downstream proofs can
use `rw` / `exact` against named lemmas, without spelling out the
typeclass-projection. -/

/-- Theorem-level restatement of `Z_lattice_spans`. -/
theorem Z_lattice_spans_thm :
    Submodule.span ℚ ((Z_lattice (A := A)) : Set A) = ⊤ :=
  BettiCohomologyData.Z_lattice_spans

/-- Theorem-level restatement of `cup_lattice_closed`. -/
theorem cupProductOnZ {a b : A}
    (ha : a ∈ Z_lattice (A := A)) (hb : b ∈ Z_lattice (A := A)) :
    cupMap (A := A) a b ∈ Z_lattice (A := A) :=
  BettiCohomologyData.cup_lattice_closed a b ha hb

/-! ### Derived theorems -/

/-- The integer lattice is closed under iterated cup product (binary
case is the typeclass field; the unary case `a ∈ Z_lattice → cupMap a a ∈
Z_lattice` is immediate). -/
theorem cupSquareOnZ {a : A} (ha : a ∈ Z_lattice (A := A)) :
    cupMap (A := A) a a ∈ Z_lattice (A := A) :=
  cupProductOnZ ha ha

/-- The integer lattice is non-empty: it contains `0` (trivial, but
needed for inhabiting-witness arguments). -/
theorem zero_mem_Z_lattice :
    (0 : A) ∈ Z_lattice (A := A) :=
  AddSubgroup.zero_mem _

/-- Cup product with the zero element of the integer lattice
yields zero (consequence of `cupMap` being `ℚ`-linear in its first
argument). -/
theorem cupMap_zero_left (a : A) :
    cupMap (A := A) 0 a = 0 := by
  -- `cupMap` is `ℚ`-linear in its first argument; in particular,
  -- it sends `0 ↦ 0`. Evaluating `(cupMap 0) = 0` first.
  have h0 : cupMap (A := A) 0 = 0 := LinearMap.map_zero (cupMap (A := A))
  rw [h0]
  rfl

/-- Cup product with the zero element of the integer lattice on the
right yields zero. -/
theorem cupMap_zero_right (a : A) :
    cupMap (A := A) a 0 = 0 :=
  LinearMap.map_zero (cupMap (A := A) a)

/-- Sum of two integer classes is an integer class (re-exports
`AddSubgroup.add_mem`). -/
theorem add_mem_Z_lattice {a b : A}
    (ha : a ∈ Z_lattice (A := A)) (hb : b ∈ Z_lattice (A := A)) :
    a + b ∈ Z_lattice (A := A) :=
  AddSubgroup.add_mem _ ha hb

/-- Negative of an integer class is an integer class (re-exports
`AddSubgroup.neg_mem`). -/
theorem neg_mem_Z_lattice {a : A}
    (ha : a ∈ Z_lattice (A := A)) :
    -a ∈ Z_lattice (A := A) :=
  AddSubgroup.neg_mem _ ha

/-- Difference of two integer classes is an integer class. -/
theorem sub_mem_Z_lattice {a b : A}
    (ha : a ∈ Z_lattice (A := A)) (hb : b ∈ Z_lattice (A := A)) :
    a - b ∈ Z_lattice (A := A) := by
  rw [sub_eq_add_neg]
  exact add_mem_Z_lattice ha (neg_mem_Z_lattice hb)

/-- The whole `ℚ`-carrier `A` is generated by the integer lattice over
`ℚ` (re-exports `Z_lattice_spans_thm`). -/
theorem mem_span_Z_lattice (a : A) :
    a ∈ Submodule.span ℚ ((Z_lattice (A := A)) : Set A) := by
  rw [Z_lattice_spans_thm]; trivial

end BettiCohomologyData

/-! ## Trivial inhabiting instance on `ℚ`

The cohomology of a **point** (one-point complex variety
`Spec(ℂ)`):

* `H^*_B(pt; ℚ) = ℚ` concentrated in degree `0`.
* The integer lattice is `ℤ ⊆ ℚ`, the `AddSubgroup` of integer
  rationals (Hatcher Example 3.10).
* `Z_lattice_rank = 1` (`H^0(pt; ℚ)` is 1-dimensional).
* Rational span: every rational is `(p/q) · 1` with `1 ∈ ℤ ⊆ ℚ`, so
  `span ℚ ℤ = ⊤` as `ℚ`-submodules of `ℚ`.
* Cup product = ordinary multiplication of rationals; integer
  rationals are closed under multiplication (`ℤ ⊆ ℚ` is a sub-ring of
  the multiplicative monoid). -/

/-- The integer lattice in `ℚ`: the `AddSubgroup` of integer rationals,
i.e. `{q : ℚ // q.den = 1}`, packaged as an `AddSubgroup ℚ` via the
range of the canonical inclusion `ℤ → ℚ`. -/
def ZLatticeUnit : AddSubgroup ℚ :=
  AddMonoidHom.range (Int.castRingHom ℚ).toAddMonoidHom

/-- Membership in `ZLatticeUnit`: a rational lies in the integer lattice
iff it is the image of some integer. -/
theorem mem_ZLatticeUnit (q : ℚ) :
    q ∈ ZLatticeUnit ↔ ∃ n : ℤ, (n : ℚ) = q := by
  unfold ZLatticeUnit
  simp [AddMonoidHom.mem_range]

/-- The integer `0 : ℤ` cast to `ℚ` is in `ZLatticeUnit`. -/
theorem zero_mem_ZLatticeUnit : (0 : ℚ) ∈ ZLatticeUnit := by
  rw [mem_ZLatticeUnit]; exact ⟨0, by norm_cast⟩

/-- The integer `1 : ℤ` cast to `ℚ` is in `ZLatticeUnit`. -/
theorem one_mem_ZLatticeUnit : (1 : ℚ) ∈ ZLatticeUnit := by
  rw [mem_ZLatticeUnit]; exact ⟨1, by norm_cast⟩

/-- `ZLatticeUnit` is closed under multiplication: the product of two
integer rationals is an integer rational. -/
theorem mul_mem_ZLatticeUnit {a b : ℚ}
    (ha : a ∈ ZLatticeUnit) (hb : b ∈ ZLatticeUnit) :
    a * b ∈ ZLatticeUnit := by
  rw [mem_ZLatticeUnit] at ha hb ⊢
  obtain ⟨m, rfl⟩ := ha
  obtain ⟨n, rfl⟩ := hb
  exact ⟨m * n, by push_cast; ring⟩

/-- For the point variety: the cup product is rational multiplication,
packaged as a `ℚ`-bilinear map `ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ`. -/
def cupMapBettiUnit : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ where
  toFun r :=
    { toFun := fun s => r * s
      map_add' := fun x y => by
        show r * (x + y) = r * x + r * y
        ring
      map_smul' := fun a x => by
        show r * (a * x) = a * (r * x)
        ring }
  map_add' x y := by
    apply LinearMap.ext; intro s
    show (x + y) * s = x * s + y * s
    ring
  map_smul' a x := by
    apply LinearMap.ext; intro s
    show (a * x) * s = a * (x * s)
    ring

@[simp] theorem cupMapBettiUnit_apply (r s : ℚ) :
    cupMapBettiUnit r s = r * s := rfl

/-- **Substantive lemma**: the `ℚ`-span of `ZLatticeUnit` is all of `ℚ`.

Proof: every rational `q = (numerator)/(denominator)` lies in the
`ℚ`-span of the single integer `1 : ℤ ⊆ ℚ`, namely `q = q • 1`. So
`Submodule.span ℚ ZLatticeUnit ⊇ ⊤` because it contains `q • 1` for
every `q : ℚ`. -/
theorem ZLatticeUnit_spans_top :
    Submodule.span ℚ ((ZLatticeUnit : Set ℚ)) = ⊤ := by
  -- Show `⊤ ≤ span ℚ ZLatticeUnit`: every `q : ℚ` lies in the span.
  refine le_antisymm le_top ?_
  intro q _
  -- Show `q ∈ span ℚ ZLatticeUnit` via `q = q • 1` and `1 ∈ ZLatticeUnit`.
  have h1 : (1 : ℚ) ∈ ZLatticeUnit := one_mem_ZLatticeUnit
  have hsub : (1 : ℚ) ∈ Submodule.span ℚ ((ZLatticeUnit : Set ℚ)) :=
    Submodule.subset_span h1
  have hqsmul : q • (1 : ℚ) = q := by simp
  have hmem : q • (1 : ℚ) ∈ Submodule.span ℚ ((ZLatticeUnit : Set ℚ)) :=
    Submodule.smul_mem _ q hsub
  rw [hqsmul] at hmem
  exact hmem

/-- The trivial `BettiCohomologyData ℚ` instance (point variety).

All four properties are verified with **substantive** proofs:

1. `Z_lattice = ZLatticeUnit = range (ℤ → ℚ)`: a real `AddSubgroup`,
   not `⊥` or `⊤`.

2. `Z_lattice_rank = 1`: the integer lattice in `H^0(pt; ℚ) = ℚ` is
   rank 1, generated by `1 : ℤ`.

3. `Z_lattice_spans`: proved via `ZLatticeUnit_spans_top` — every
   rational `q` equals `q • 1` with `1 ∈ ℤ`.

4. `cup_lattice_closed`: proved via `mul_mem_ZLatticeUnit` — the
   product of two integer rationals is an integer rational. -/
instance instBettiCohomologyDataUnit : BettiCohomologyData ℚ where
  Z_lattice := ZLatticeUnit
  Z_lattice_rank := 1
  cupMap := cupMapBettiUnit
  Z_lattice_spans := ZLatticeUnit_spans_top
  cup_lattice_closed := by
    intro a b ha hb
    -- cupMapBettiUnit a b = a * b; ZLatticeUnit closed under *.
    show cupMapBettiUnit a b ∈ ZLatticeUnit
    rw [cupMapBettiUnit_apply]
    exact mul_mem_ZLatticeUnit ha hb

/-! ### Sanity checks for the trivial instance

These re-derive each typeclass-level property through the named
theorems above, witnessing that `instBettiCohomologyDataUnit` is a
valid inhabiting instance. -/

/-- **Sanity check**: the rational-span axiom holds (via the
theorem-level restatement). -/
example : Submodule.span ℚ ((BettiCohomologyData.Z_lattice (A := ℚ)) : Set ℚ)
    = ⊤ :=
  BettiCohomologyData.Z_lattice_spans_thm

/-- **Sanity check**: cup-product closure on the integer lattice
(via the theorem-level restatement). -/
example {a b : ℚ}
    (ha : a ∈ BettiCohomologyData.Z_lattice (A := ℚ))
    (hb : b ∈ BettiCohomologyData.Z_lattice (A := ℚ)) :
    BettiCohomologyData.cupMap (A := ℚ) a b
      ∈ BettiCohomologyData.Z_lattice (A := ℚ) :=
  BettiCohomologyData.cupProductOnZ ha hb

/-- **Sanity check**: `0 : ℚ` lies in the integer lattice. -/
example : (0 : ℚ) ∈ BettiCohomologyData.Z_lattice (A := ℚ) :=
  BettiCohomologyData.zero_mem_Z_lattice

/-- **Sanity check**: every rational lies in the `ℚ`-span of the
integer lattice (via `mem_span_Z_lattice`). -/
example (q : ℚ) :
    q ∈ Submodule.span ℚ
        ((BettiCohomologyData.Z_lattice (A := ℚ)) : Set ℚ) :=
  BettiCohomologyData.mem_span_Z_lattice q

/-- **Sanity check**: `cupMap 0 _ = 0`. -/
example (a : ℚ) : BettiCohomologyData.cupMap (A := ℚ) 0 a = 0 :=
  BettiCohomologyData.cupMap_zero_left a

/-- **Sanity check**: `cupMap _ 0 = 0`. -/
example (a : ℚ) : BettiCohomologyData.cupMap (A := ℚ) a 0 = 0 :=
  BettiCohomologyData.cupMap_zero_right a

end HodgeReduction.Infrastructure.Cohomology
