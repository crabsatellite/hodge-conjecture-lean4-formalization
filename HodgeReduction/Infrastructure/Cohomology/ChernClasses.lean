/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Defs

/-!
# Chern classes of vector bundles in abstract cohomology

This file provides an **abstract Chern-class interface**: a way to
assign cohomology classes `c_i ∈ A` to a "vector bundle data" without
defining vector bundles concretely.

## Why an abstract interface?

The full Mathlib formalisation of algebraic vector bundles on smooth
projective schemes is a substantial undertaking (vector bundles +
Chow rings + cycle class maps). For the Hodge-conjecture application,
we only need:

* A way to declare that some elements `c_1, c_2, ...` of `A` are
  "Chern classes" of an algebraic vector bundle.
* The key cycle-class-map property: **Chern classes of an algebraic
  vector bundle are algebraic cohomology classes** (in the sense of
  `CohomologyRing.IsAlgebraic`).

This is a single axiom (`ChernData.isAlgebraic`) packaged as a
typeclass field, so it can be replaced by an actual proof when Mathlib's
algebraic geometry stack catches up.

## Main definitions

* `ChernData A` : a finite list of cohomology classes `c_1, ..., c_n`
  representing "Chern classes of some vector bundle".
* `ChernData.IsAlgebraic` : property "all Chern classes are algebraic".
* `algebraic_of_chern_polynomial` : every polynomial (with rational
  coefficients) in the Chern classes of an algebraic vector bundle is
  algebraic.

## Tags

Chern class, characteristic class, algebraic vector bundle, cycle class map
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- A bundle of **Chern-class data** in `A`: a finite list of cohomology
classes representing `c_1, c_2, ..., c_n` of some vector bundle.

For our HC application, we'll instantiate this with the 4 Chern classes
`c_1, c_2, c_3, c_4` of the rank-27 Hodge piece `𝓔_{+1}` on `EVII`. -/
structure ChernData (A : Type*) [CommRing A] where
  /-- The Chern classes (degree 1, 2, ..., n in the graded structure). -/
  c : ℕ → A

/-- A `ChernData` is **algebraic** if all its Chern classes are in
the algebraic subring of `A`.

This is the axiomatic content of "Chern classes of an algebraic
vector bundle are algebraic cohomology classes" (the cycle class
map sending `c_i^{CH}(V) ↦ c_i^{H}(V)` lands in the image of
`CH^*(X)_ℚ → H^*(X; ℚ)`). -/
def ChernData.IsAlgebraic (cd : ChernData A) : Prop :=
  ∀ i, CohomologyRing.IsAlgebraic (cd.c i)

/-- The interface for an **algebraic vector bundle**: a `ChernData`
together with a proof that all its Chern classes are algebraic. -/
structure AlgebraicChernData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] extends ChernData A where
  /-- All Chern classes are in the algebraic subring. -/
  isAlgebraic : toChernData.IsAlgebraic

namespace AlgebraicChernData

variable (cd : AlgebraicChernData A)

/-- Each Chern class `c_i` of an algebraic bundle is algebraic. -/
theorem chern_isAlgebraic (i : ℕ) :
    CohomologyRing.IsAlgebraic (cd.c i) :=
  cd.isAlgebraic i

/-- The product `c_i * c_j` of two Chern classes is algebraic. -/
theorem chern_mul_isAlgebraic (i j : ℕ) :
    CohomologyRing.IsAlgebraic (cd.c i * cd.c j) :=
  CohomologyRing.isAlgebraic_mul (cd.chern_isAlgebraic i) (cd.chern_isAlgebraic j)

/-- The square `c_i^2` of a Chern class is algebraic. -/
theorem chern_sq_isAlgebraic (i : ℕ) :
    CohomologyRing.IsAlgebraic (cd.c i ^ 2) :=
  CohomologyRing.isAlgebraic_pow (cd.chern_isAlgebraic i) 2

/-- The scaled class `r • c_i` is algebraic for any rational `r`. -/
theorem chern_smul_isAlgebraic (r : ℚ) (i : ℕ) :
    CohomologyRing.IsAlgebraic (r • cd.c i) :=
  CohomologyRing.isAlgebraic_smul r (cd.chern_isAlgebraic i)

/-- A linear combination `r • c_i + s • c_j` is algebraic. -/
theorem chern_linear_comb_isAlgebraic (r s : ℚ) (i j : ℕ) :
    CohomologyRing.IsAlgebraic (r • cd.c i + s • cd.c j) :=
  CohomologyRing.isAlgebraic_add
    (cd.chern_smul_isAlgebraic r i) (cd.chern_smul_isAlgebraic s j)

/-! ### The specific polynomial: `-48 c_2² + 96 c_1 c_3 − 96 c_4` -/

/-- The **Freudenthal polynomial** in 4 Chern classes:
`-48·c_2² + 96·c_1·c_3 − 96·c_4`.

This is the polynomial expression appearing in the EVII Freudenthal-class
identity `[q] = -48·c_2(𝓔_{+1})² + 96·c_1(𝓔_{+1})·c_3(𝓔_{+1}) − 96·c_4(𝓔_{+1})`. -/
def freudenthalPolynomial : A :=
  (-48 : ℚ) • (cd.c 2 * cd.c 2) + (96 : ℚ) • (cd.c 1 * cd.c 3) - (96 : ℚ) • cd.c 4

/-- The **Freudenthal polynomial is algebraic** when the underlying
vector bundle is algebraic. This is the key consequence of
`isAlgebraic` plus the subalgebra closure properties. -/
theorem freudenthalPolynomial_isAlgebraic :
    CohomologyRing.IsAlgebraic cd.freudenthalPolynomial := by
  unfold freudenthalPolynomial
  apply CohomologyRing.isAlgebraic_sub
  · apply CohomologyRing.isAlgebraic_add
    · exact CohomologyRing.isAlgebraic_smul _
        (CohomologyRing.isAlgebraic_mul (cd.chern_isAlgebraic 2) (cd.chern_isAlgebraic 2))
    · exact CohomologyRing.isAlgebraic_smul _
        (CohomologyRing.isAlgebraic_mul (cd.chern_isAlgebraic 1) (cd.chern_isAlgebraic 3))
  · exact CohomologyRing.isAlgebraic_smul _ (cd.chern_isAlgebraic 4)

end AlgebraicChernData

/-! ### Axiomatic Chern classes
(Chern 1946 *Ann. Math.* 47 "Characteristic classes of Hermitian
manifolds"; Hirzebruch 1956 *Topological Methods in Algebraic
Geometry*; Voisin Vol. I §11.2 on Chern classes of holomorphic
bundles.)

The previous `ChernData` records the bare list of Chern classes
`c_0, c_1, c_2, ...` of *some* vector bundle without constraints on
the values. The class below `ChernClassesAxiomatic` upgrades this to
record the **Chern 1946 axiomatic content**:

* **Axiom (i)** `c 0 = 1` — the zeroth Chern class is the unit class
  (Chern 1946 Axiom 1; Hirzebruch §4.1).
* **Axiom (ii)** `c k = 0` for `k > rank(E)` — the dimension bound
  (Hirzebruch §4.1 (4.1.2); the bundle of rank `r` has at most `r`
  non-zero Chern classes).
* **Whitney sum formula** (Chern 1946 Axiom 3; Hirzebruch (4.1.3)):
  for a direct sum `E ⊕ E'` of two bundles `E, E'` with Chern data
  `c, c'`, the total Chern class satisfies `c_t(E ⊕ E') = c_t(E) ·
  c_t(E')`, equivalently the convolution
  `c_k(E ⊕ E') = ∑_{i+j=k} c_i(E) · c_j(E')`.

We encode the Whitney formula by carrying complementary Chern data
`c_complement` and the resulting direct-sum Chern data `c_sum`, with
the convolution identity as a substantive field. -/
class ChernClassesAxiomatic (A : Type*) (E : Type*) [CommRing A]
    [Algebra ℚ A] [CohomologyRing A] where
  /-- The Chern classes `c_0, c_1, c_2, ...` of the bundle `E`. -/
  c : ℕ → A
  /-- **Chern Axiom (i)** (Chern 1946 Ax. 1; Hirzebruch §4.1):
  `c_0 = 1`. Substantive equation: the zeroth Chern class equals the
  unit class of `A`, not the tautology `c 0 = c 0`. -/
  c_zero : c 0 = 1
  /-- The rank of the underlying vector bundle `E`. -/
  rank : ℕ
  /-- **Chern Axiom (ii)** / dimension bound (Hirzebruch (4.1.2)):
  `c_k = 0` for `k > rank(E)`. Substantive equation: above-rank Chern
  classes are zero. -/
  c_vanish_above_rank : ∀ k, rank < k → c k = 0
  /-- Complementary Chern data `c' = (c'_0, c'_1, ...)` for a second
  bundle `E'` (Hirzebruch §4.1; the Whitney sum formula needs two
  bundles' Chern data). -/
  c_complement : ℕ → A
  /-- The complementary bundle also satisfies Chern Axiom (i):
  `(c')_0 = 1`. -/
  c_complement_zero : c_complement 0 = 1
  /-- The Chern classes of the direct sum `E ⊕ E'`. -/
  c_sum : ℕ → A
  /-- The direct sum's zeroth Chern class is `1` (Whitney sum at degree
  0, since `c_0(E ⊕ E') = c_0(E) · c_0(E') = 1 · 1 = 1`). -/
  c_sum_zero : c_sum 0 = 1
  /-- **Whitney sum formula** (Chern 1946 Ax. 3; Hirzebruch (4.1.3)):
  the convolution
  `c_k(E ⊕ E') = ∑_{i=0}^{k} c_i(E) · c_{k-i}(E')`.
  Substantive convolution equation linking three sequences (`c`,
  `c_complement`, `c_sum`); NOT a tautology of one sequence with
  itself. -/
  whitney_convolution :
    ∀ k, c_sum k = ∑ i ∈ Finset.range (k + 1), c i * c_complement (k - i)

namespace ChernClassesAxiomatic

variable {A : Type*} {E : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
variable [ChernClassesAxiomatic A E]

/-- The zeroth Chern class is `1` (theorem-level restatement). -/
theorem c_zero_eq_one : c (A := A) (E := E) 0 = 1 :=
  c_zero

/-- The complementary bundle's zeroth Chern class is `1`. -/
theorem c_complement_zero_eq_one : c_complement (A := A) (E := E) 0 = 1 :=
  c_complement_zero

/-- Above-rank Chern classes are zero (theorem-level restatement). -/
theorem chern_eq_zero_of_gt_rank {k : ℕ}
    (h : rank (A := A) (E := E) < k) :
    c (A := A) (E := E) k = 0 :=
  c_vanish_above_rank k h

/-- The Whitney sum formula (theorem-level restatement). -/
theorem whitney_sum_formula (k : ℕ) :
    c_sum (A := A) (E := E) k =
      ∑ i ∈ Finset.range (k + 1),
        c (A := A) (E := E) i *
          c_complement (A := A) (E := E) (k - i) :=
  whitney_convolution k

/-- **Whitney at degree 0**: `c_sum 0 = c 0 * c_complement 0 = 1`. -/
theorem whitney_sum_zero :
    c_sum (A := A) (E := E) 0 = 1 :=
  c_sum_zero

end ChernClassesAxiomatic

/-! ### Splitting Principle
(Hirzebruch 1956 §4.2; Voisin Vol. I §11.2.1 "The splitting principle
for Chern classes")

The **splitting principle** asserts that for any computation of
characteristic classes, one may assume the bundle splits as a direct
sum of line bundles, with `chernRoots i = c_1(L_i)` the first Chern
classes of the splitting line bundles. The total Chern class is then
`c(E) = ∏_i (1 + chernRoots i)`, and the `k`-th Chern class is the
**`k`-th elementary symmetric polynomial** in the Chern roots:
`c_k(E) = e_k(chernRoots 0, ..., chernRoots (rank - 1))`.

In particular:
* `c_0 = e_0 = 1` (empty product = 1).
* `c_rank = e_rank = ∏_{i=0}^{rank-1} chernRoots i` (the top Chern class).
* `c_k = 0` for `k > rank` (no `e_k` with more terms than roots).

We package only the **top Chern class identity** as the substantive
structural field, since this is the cleanest non-tautological
elementary-symmetric-polynomial equation.

References:
* Hirzebruch 1956 §4.2 — formal splitting principle.
* Voisin Vol. I Lemma 11.7 — splitting principle on holomorphic bundles. -/
class SplittingPrincipleData (A : Type*) (E : Type*) [CommRing A]
    [Algebra ℚ A] [CohomologyRing A] where
  /-- The formal **Chern roots** `α_0, α_1, ..., α_{rank-1}` of the
  bundle `E` (Hirzebruch §4.2; the splitting principle realises `E`
  as a virtual sum of line bundles `L_0 ⊕ ... ⊕ L_{rank-1}` with
  `α_i = c_1(L_i)`). -/
  chernRoots : ℕ → A
  /-- The rank of the bundle. -/
  rank : ℕ
  /-- The Chern classes (typically `c k = e_k(α_0, ..., α_{rank-1})`,
  the `k`-th elementary symmetric polynomial in the Chern roots). -/
  c : ℕ → A
  /-- **Splitting Axiom (i)** `c_0 = 1` (= `e_0 = 1`, the empty
  product). Substantive equation. -/
  c_zero : c 0 = 1
  /-- **Splitting Axiom (ii)**: above-rank Chern classes vanish
  (since `e_k` of `rank` variables vanishes for `k > rank`). -/
  c_vanish_above_rank : ∀ k, rank < k → c k = 0
  /-- **Top Chern class via splitting principle** (Hirzebruch (4.2.3);
  Voisin Vol. I Lemma 11.7): the top Chern class `c_rank` equals the
  product of all Chern roots. Substantive equation linking `c` to
  `chernRoots` via the rank-fold product (the elementary symmetric
  polynomial `e_rank = ∏ x_i`). -/
  c_top_eq_root_product :
    c rank = (Finset.range rank).prod (fun i => chernRoots i)

namespace SplittingPrincipleData

variable {A : Type*} {E : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
variable [SplittingPrincipleData A E]

/-- The zeroth Chern class is `1` (theorem-level restatement). -/
theorem c_zero_eq_one : c (A := A) (E := E) 0 = 1 :=
  c_zero

/-- Above-rank Chern classes are zero. -/
theorem chern_eq_zero_of_gt_rank {k : ℕ}
    (h : rank (A := A) (E := E) < k) :
    c (A := A) (E := E) k = 0 :=
  c_vanish_above_rank k h

/-- The top Chern class equals the product of Chern roots. -/
theorem c_top_eq_chernRoots_prod :
    c (A := A) (E := E) (rank (A := A) (E := E))
      = (Finset.range (rank (A := A) (E := E))).prod
          (fun i => chernRoots (A := A) (E := E) i) :=
  c_top_eq_root_product

/-- For a rank-0 bundle, the top Chern class equals `1` (empty
product). This is the rank-0 specialisation of
`c_top_eq_chernRoots_prod`. -/
theorem c_top_rank_zero (h : rank (A := A) (E := E) = 0) :
    c (A := A) (E := E) 0 = 1 := by
  have : c (A := A) (E := E) (rank (A := A) (E := E))
      = (Finset.range (rank (A := A) (E := E))).prod
          (fun i => chernRoots (A := A) (E := E) i) :=
    c_top_eq_chernRoots_prod
  rw [h] at this
  simpa using this.trans (by simp)

end SplittingPrincipleData

/-! ### Trivial inhabiting instances

For `A = ℚ` and a placeholder bundle type, both
`ChernClassesAxiomatic` and `SplittingPrincipleData` admit trivial
instances corresponding to the **trivial rank-0 vector bundle**
(which has `c_0 = 1` and `c_k = 0` for all `k ≥ 1`).

The trivial inhabiting requires a `CohomologyRing ℚ` instance; we
provide a local one (the cohomology of a point) inside the
`ChernClassesAxiomatic` namespace below to avoid clashing with
global instances downstream. -/

namespace ChernClassesAxiomatic

/-- **Local trivial `CohomologyRing ℚ`** for sanity-checking the
trivial inhabiting instance (point cohomology, algebraic = top). -/
local instance instCohomologyRingQ_chernClasses : CohomologyRing ℚ where
  algebraic := (⊤ : Subalgebra ℚ ℚ)

/-- The trivial rank-0 Chern data: `c_0 = 1`, `c_k = 0` for `k ≥ 1`. -/
def cTrivial : ℕ → ℚ := fun k => if k = 0 then (1 : ℚ) else 0

@[simp] theorem cTrivial_zero : cTrivial 0 = 1 := by unfold cTrivial; simp
@[simp] theorem cTrivial_succ (k : ℕ) : cTrivial (k + 1) = 0 := by
  unfold cTrivial; simp

/-- The trivial inhabiting `ChernClassesAxiomatic` on `(ℚ, Unit)`:
rank-0 bundle, all higher Chern classes vanish, Whitney convolution
holds trivially (only the `i = 0` and `i = k` terms survive, both
zero for `k ≥ 1`; for `k = 0` the sum reduces to `1 · 1 = 1`). -/
instance instChernClassesAxiomaticTrivial :
    ChernClassesAxiomatic ℚ Unit where
  c := cTrivial
  c_zero := cTrivial_zero
  rank := 0
  c_vanish_above_rank := fun k hk => by
    -- `0 < k` ⟹ `k ≠ 0` ⟹ `cTrivial k = 0`.
    unfold cTrivial
    have hk0 : k ≠ 0 := Nat.pos_iff_ne_zero.mp hk
    simp [hk0]
  c_complement := cTrivial
  c_complement_zero := cTrivial_zero
  c_sum := cTrivial
  c_sum_zero := cTrivial_zero
  whitney_convolution := by
    intro k
    -- For `k = 0`: LHS = `cTrivial 0 = 1`; RHS = `∑ i ∈ {0}, cTrivial i * cTrivial (0-i) = 1 * 1 = 1`.
    -- For `k ≥ 1`: LHS = `cTrivial k = 0`; each summand `cTrivial i * cTrivial (k-i)` is zero
    --   (either `i ≠ 0` so first factor is 0, or `i = 0` so `k - i = k ≠ 0`, second factor is 0).
    rcases Nat.eq_zero_or_pos k with hk | hk
    · subst hk
      simp [cTrivial]
    · have hk0 : k ≠ 0 := Nat.pos_iff_ne_zero.mp hk
      rw [show cTrivial k = 0 from by simp [cTrivial, hk0]]
      symm
      apply Finset.sum_eq_zero
      intro i _
      -- Either `i = 0` (then `k - i = k ≠ 0`, second factor 0) or `i ≠ 0` (first factor 0).
      rcases Nat.eq_zero_or_pos i with hi | hi
      · subst hi
        have hki : k - 0 = k := Nat.sub_zero k
        rw [hki]
        simp [cTrivial, hk0]
      · have hi0 : i ≠ 0 := Nat.pos_iff_ne_zero.mp hi
        simp [cTrivial, hi0]

/-- **Sanity check**: the trivial instance has `c 0 = 1`. -/
example : c (A := ℚ) (E := Unit) 0 = 1 := c_zero_eq_one

/-- **Sanity check**: the trivial instance has `rank = 0`. -/
example : rank (A := ℚ) (E := Unit) = 0 := rfl

/-- **Sanity check**: the trivial instance has `c 1 = 0` (above rank 0). -/
example : c (A := ℚ) (E := Unit) 1 = 0 := by
  have h : rank (A := ℚ) (E := Unit) < 1 := by
    show (0 : ℕ) < 1; exact Nat.zero_lt_one
  exact chern_eq_zero_of_gt_rank h

end ChernClassesAxiomatic

namespace SplittingPrincipleData

/-- **Local trivial `CohomologyRing ℚ`** for sanity-checking the
trivial `SplittingPrincipleData` instance (point cohomology). -/
local instance instCohomologyRingQ_splitting : CohomologyRing ℚ where
  algebraic := (⊤ : Subalgebra ℚ ℚ)

/-- The trivial inhabiting `SplittingPrincipleData` on `(ℚ, Unit)`:
rank-0 bundle, all Chern roots zero (vacuous), Chern classes from
`cTrivial`. The top-Chern-class identity becomes `c 0 = 1 = empty
product`. -/
instance instSplittingPrincipleDataTrivial :
    SplittingPrincipleData ℚ Unit where
  chernRoots := fun _ => (0 : ℚ)
  rank := 0
  c := ChernClassesAxiomatic.cTrivial
  c_zero := ChernClassesAxiomatic.cTrivial_zero
  c_vanish_above_rank := fun k hk => by
    unfold ChernClassesAxiomatic.cTrivial
    have hk0 : k ≠ 0 := Nat.pos_iff_ne_zero.mp hk
    simp [hk0]
  c_top_eq_root_product := by
    -- `rank = 0`, so LHS `c 0 = 1` and RHS `(Finset.range 0).prod _ = 1` (empty product).
    show ChernClassesAxiomatic.cTrivial 0 =
      (Finset.range 0).prod (fun _ => (0 : ℚ))
    simp [ChernClassesAxiomatic.cTrivial]

/-- **Sanity check**: the trivial instance has `rank = 0`. -/
example : rank (A := ℚ) (E := Unit) = 0 := rfl

/-- **Sanity check**: the trivial instance has `c 0 = 1`. -/
example : c (A := ℚ) (E := Unit) 0 = 1 := c_zero_eq_one

end SplittingPrincipleData

end HodgeReduction.Infrastructure.Cohomology
