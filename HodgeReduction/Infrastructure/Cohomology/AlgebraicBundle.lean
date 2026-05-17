/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.Algebra.Module.Submodule.Basic

/-!
# Abstract algebraic vector bundles and their Chern classes

Captures the data needed for the Hodge-conjecture EVII application:

* `AlgebraicVectorBundle A` — algebraic-bundle Chern-class data
  (rank + Chern classes valued in `A`, all algebraic).
* `HolomorphicBundleData X A` — holomorphic bundle's rank and Chern
  classes valued in `A`, with substantive `chern 0 = 1` and per-index
  vanishing equations.
* `FilteredBundleData X A` — substantive `Submodule ℚ A` filtration.
* `ChernCharacterRelationData X A` — substantive per-degree Chern-
  character equations.

## References

* R. Hartshorne, *Algebraic Geometry*, GTM 52 (Springer 1977),
  Ch. II §5.
* D. Mumford, *Abelian Varieties* (Oxford 1970), §10.
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I*,
  CSAM 76 (CUP 2002), Ch. 5.
* F. Hirzebruch, *Topological Methods in Algebraic Geometry*
  (Springer 3rd ed. 1966), §4.

## Tags

algebraic vector bundle, Chern class, cycle class map, Hodge
conjecture, holomorphic bundle, filtration, Chern character
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- An **abstract algebraic vector bundle** on a smooth projective
variety with cohomology ring `A`, packaged as:

* A natural-number `rank` (the rank of the bundle).
* A function `chern : ℕ → A` giving Chern classes (with `chern 0 = 1`
  by convention, and `chern i = 0` for `i > rank`).
* A proof that all Chern classes are algebraic.

This is the typeclass-form of `AlgebraicChernData` packaged together
with the bundle's rank for tracking dimension constraints. -/
structure AlgebraicVectorBundle where
  /-- The rank of the bundle (as a vector bundle, equivalent to the
  rank of the underlying sheaf as a coherent sheaf). -/
  rank : ℕ
  /-- The Chern classes `c_i = chern i`. -/
  chern : ℕ → A
  /-- `c_0 = 1` (the unit class). -/
  chern_zero : chern 0 = 1
  /-- `c_i = 0` for `i > rank`. -/
  chern_above_rank : ∀ i, rank < i → chern i = 0
  /-- All Chern classes are algebraic. -/
  chern_isAlgebraic : ∀ i, CohomologyRing.IsAlgebraic (chern i)

namespace AlgebraicVectorBundle

variable {A} (E : AlgebraicVectorBundle A)

/-- Convert an `AlgebraicVectorBundle` to an `AlgebraicChernData`. -/
def toAlgebraicChernData : AlgebraicChernData A :=
  { c := E.chern, isAlgebraic := E.chern_isAlgebraic }

/-- The Chern class `c_i` is algebraic. -/
theorem chern_algebraic (i : ℕ) : CohomologyRing.IsAlgebraic (E.chern i) :=
  E.chern_isAlgebraic i

/-- A polynomial in Chern classes is algebraic.
We state the specific case `-48·c_2² + 96·c_1·c_3 − 96·c_4`, which
is the Freudenthal-quartic-Chern-class expression. -/
theorem freudenthalChernPolynomial_isAlgebraic :
    CohomologyRing.IsAlgebraic
      ((-48 : ℚ) • (E.chern 2 * E.chern 2)
        + (96 : ℚ) • (E.chern 1 * E.chern 3)
        - (96 : ℚ) • E.chern 4) :=
  E.toAlgebraicChernData.freudenthalPolynomial_isAlgebraic

end AlgebraicVectorBundle

/-! ## Holomorphic bundle data (sibling typeclass)

By GAGA (Serre 1956), every holomorphic bundle in the projective
algebraic setting is algebraic; `HolomorphicBundleData X A` is the
abstract shadow with substantive `chern 0 = 1` (Voisin 2002 Vol. I
Def. 11.4) and per-index vanishing `chern k = 0` for `k > rank`
(Hartshorne 1977 App. A.3).
-/

/-- **Holomorphic bundle data**: rank + Chern classes valued in the
commutative `ℚ`-algebra `A`, with substantive `chern 0 = 1` (Voisin
2002 Vol. I Def. 11.4) and per-index vanishing `chern k = 0` for
`k > rank` (Hartshorne 1977 App. A.3). Carrier `X` is an abstract Type
placeholder distinguishing instances. -/
class HolomorphicBundleData (X : Type*) (A : Type*) [CommRing A]
    [Algebra ℚ A] where
  /-- The rank of the holomorphic bundle. -/
  rank : ℕ
  /-- The Chern classes `c_0, c_1, …, c_rank, …`. -/
  chern : ℕ → A
  /-- **Substantive arithmetic identity**: `c_0 = 1`. -/
  chern_zero : chern 0 = 1
  /-- **Substantive per-index vanishing**: `c_k = 0` for `k > rank`. -/
  vanish : ∀ k : ℕ, rank < k → chern k = 0

namespace HolomorphicBundleData

variable {X A : Type*} [CommRing A] [Algebra ℚ A] [HolomorphicBundleData X A]

/-! ### Derived consequences of the holomorphic-bundle axioms -/

/-- **Re-export** of the `chern_zero` substantive equation under a
theorem-level name. -/
theorem chern_zero_eq_one : chern (X := X) (A := A) 0 = 1 :=
  HolomorphicBundleData.chern_zero

/-- **Re-export** of the per-index vanishing equation under a theorem-
level name. -/
theorem chern_eq_zero_of_gt {k : ℕ} (hk : rank (X := X) (A := A) < k) :
    chern (X := X) (A := A) k = 0 :=
  HolomorphicBundleData.vanish k hk

/-- **Concrete instance** of vanishing: index `rank + 1` is above the
rank, so `chern (rank + 1) = 0`. -/
theorem chern_succ_rank_eq_zero :
    chern (X := X) (A := A) (rank (X := X) (A := A) + 1) = 0 :=
  chern_eq_zero_of_gt (Nat.lt_succ_self _)

/-- **Concrete instance** of vanishing: index `rank + 2` is above the
rank, so `chern (rank + 2) = 0`. -/
theorem chern_rank_plus_two_eq_zero :
    chern (X := X) (A := A) (rank (X := X) (A := A) + 2) = 0 :=
  chern_eq_zero_of_gt (by omega)

end HolomorphicBundleData

/-! ## Filtered bundle data (sibling typeclass)

A filtration on a holomorphic bundle (Voisin 2002 Vol. I §7.1 Hodge
filtration, Hartshorne 1977 Ch. II §5 Harder-Narasimhan): substantive
`Submodule ℚ A` per index with antitonicity, saturation at zero, and
vanishing above the rank.
-/

/-- **Filtered holomorphic bundle data**: substantive `Submodule ℚ A`
filtration with antitonicity (`p ≤ q ⟹ filt q ≤ filt p`), saturation
(`filt 0 = ⊤`), and vanishing above rank (`filt k = ⊥` for
`k > rank`). -/
class FilteredBundleData (X : Type*) (A : Type*) [CommRing A]
    [Algebra ℚ A] [HolomorphicBundleData X A] where
  /-- The filtration `filt p : Submodule ℚ A`. -/
  filt : ℕ → Submodule ℚ A
  /-- **Substantive antitone monotonicity**: `p ≤ q ⟹ filt q ≤ filt p`. -/
  filt_antitone : ∀ {p q : ℕ}, p ≤ q → filt q ≤ filt p
  /-- **Substantive saturation at zero**: `filt 0 = ⊤`. -/
  filt_zero_eq_top : filt 0 = ⊤
  /-- **Substantive vanishing above rank**: `filt k = ⊥` for `k > rank`. -/
  filt_above_rank_eq_bot :
    ∀ {k : ℕ}, HolomorphicBundleData.rank (X := X) (A := A) < k → filt k = ⊥

namespace FilteredBundleData

variable {X A : Type*} [CommRing A] [Algebra ℚ A]
  [HolomorphicBundleData X A] [FilteredBundleData X A]

/-! ### Derived consequences of the filtration axioms -/

/-- **Re-export** of `filt_antitone` under a theorem-level name. -/
theorem filt_antitone_thm {p q : ℕ} (h : p ≤ q) :
    filt (X := X) (A := A) q ≤ filt (X := X) (A := A) p :=
  FilteredBundleData.filt_antitone h

/-- **Re-export** of `filt_zero_eq_top` under a theorem-level name. -/
theorem filt_zero_eq_top_thm :
    filt (X := X) (A := A) 0 = ⊤ :=
  FilteredBundleData.filt_zero_eq_top

/-- **Re-export** of `filt_above_rank_eq_bot` under a theorem-level
name. -/
theorem filt_above_rank_eq_bot_thm {k : ℕ}
    (hk : HolomorphicBundleData.rank (X := X) (A := A) < k) :
    filt (X := X) (A := A) k = ⊥ :=
  FilteredBundleData.filt_above_rank_eq_bot hk

/-- **Specialised vanishing**: `filt (rank + 1) = ⊥`. -/
theorem filt_succ_rank_eq_bot :
    filt (X := X) (A := A)
        (HolomorphicBundleData.rank (X := X) (A := A) + 1) = ⊥ :=
  filt_above_rank_eq_bot_thm (Nat.lt_succ_self _)

/-- **Specialised inclusion**: `filt 2 ≤ filt 1` from antitonicity. -/
theorem filt_two_le_one :
    filt (X := X) (A := A) 2 ≤ filt (X := X) (A := A) 1 :=
  filt_antitone_thm (by omega)

end FilteredBundleData

/-! ## Chern-character relation data (sibling typeclass)

The Chern character has the polynomial expansion
`ch(E) = rank + c₁ + (c₁² − 2 c₂)/2 + (c₁³ − 3 c₁ c₂ + 3 c₃)/6 + …`
(Hirzebruch 1966 §4.1; Voisin 2002 Vol. I §11.2.2). We encode the
first few per-degree substantive arithmetic equations.
-/

/-- **Chern-character relation data** for a holomorphic bundle on `X`
with cohomology in the commutative `ℚ`-algebra `A`. Three substantive
arithmetic identities: `ch 0 = (rank : A)`, `ch 1 = c_1`,
`2 • ch 2 = c_1² − 2 c_2` (Hirzebruch 1966 §4.1.1-§4.1.2). -/
class ChernCharacterRelationData (X : Type*) (A : Type*) [CommRing A]
    [Algebra ℚ A] [HolomorphicBundleData X A] where
  /-- The Chern-character components `ch i : A`. -/
  ch : ℕ → A
  /-- **Substantive arithmetic identity**:
  `ch 0 = (algebraMap ℚ A) (rank : ℚ)`. -/
  ch_zero_eq_rank :
    ch 0 = (algebraMap ℚ A)
      ((HolomorphicBundleData.rank (X := X) (A := A) : ℚ))
  /-- **Substantive arithmetic identity**: `ch 1 = c_1`. -/
  ch_one_eq_c_one :
    ch 1 = HolomorphicBundleData.chern (X := X) (A := A) 1
  /-- **Substantive arithmetic identity**: `2 • ch 2 = c_1² − 2 c_2`. -/
  ch_two_relation :
    (2 : ℚ) • ch 2 =
      HolomorphicBundleData.chern (X := X) (A := A) 1 *
        HolomorphicBundleData.chern (X := X) (A := A) 1
      - (2 : ℚ) • HolomorphicBundleData.chern (X := X) (A := A) 2

namespace ChernCharacterRelationData

variable {X A : Type*} [CommRing A] [Algebra ℚ A]
  [HolomorphicBundleData X A] [ChernCharacterRelationData X A]

/-! ### Derived consequences of the Chern-character relations -/

/-- **Re-export** of `ch_zero_eq_rank` under a theorem-level name. -/
theorem ch_zero_eq_rank_thm :
    ch (X := X) (A := A) 0 = (algebraMap ℚ A)
      ((HolomorphicBundleData.rank (X := X) (A := A) : ℚ)) :=
  ChernCharacterRelationData.ch_zero_eq_rank

/-- **Re-export** of `ch_one_eq_c_one` under a theorem-level name. -/
theorem ch_one_eq_c_one_thm :
    ch (X := X) (A := A) 1 = HolomorphicBundleData.chern (X := X) (A := A) 1 :=
  ChernCharacterRelationData.ch_one_eq_c_one

/-- **Re-export** of `ch_two_relation` under a theorem-level name. -/
theorem ch_two_relation_thm :
    (2 : ℚ) • ch (X := X) (A := A) 2 =
      HolomorphicBundleData.chern (X := X) (A := A) 1 *
        HolomorphicBundleData.chern (X := X) (A := A) 1
      - (2 : ℚ) • HolomorphicBundleData.chern (X := X) (A := A) 2 :=
  ChernCharacterRelationData.ch_two_relation

end ChernCharacterRelationData

/-! ## Trivial inhabiting instances

Non-emptiness witnesses on `X := PUnit` and `A := ℚ`: trivial rank-0
holomorphic bundle with `c_0 = 1` / `c_k = 0` (`k > 0`), the trivial
`⊤ / ⊥` filtration, and Chern character identically `0`. -/

namespace Trivial

/-- **Trivial holomorphic bundle** on `PUnit` with target `ℚ`:
rank `0`, all higher Chern classes `= 0`, and `c_0 = 1`. -/
instance holomorphicPunitQ : HolomorphicBundleData PUnit ℚ where
  rank := 0
  chern k := if k = 0 then 1 else 0
  chern_zero := by
    -- if-branch on `0 = 0` → `1`.
    show (if (0 : ℕ) = 0 then (1 : ℚ) else 0) = 1
    rw [if_pos rfl]
  vanish k hk := by
    -- `rank = 0 < k` so `k ≠ 0` and the if-branch gives `0`.
    have hk' : k ≠ 0 := Nat.pos_iff_ne_zero.mp hk
    show (if k = 0 then (1 : ℚ) else 0) = 0
    rw [if_neg hk']

/-- **Trivial filtration** on the trivial holomorphic bundle: `filt 0 =
⊤` and `filt k = ⊥` for `k > 0` (which includes `k > rank = 0`). -/
instance filteredPunitQ : FilteredBundleData PUnit ℚ where
  filt k := if k = 0 then ⊤ else ⊥
  filt_antitone {p q} h := by
    -- Case split on `p` and `q`.
    by_cases hp : p = 0
    · -- `p = 0`: `filt p = ⊤`, so `filt q ≤ ⊤` trivially via `le_top`.
      rw [hp]
      show (if q = 0 then (⊤ : Submodule ℚ ℚ) else ⊥) ≤ ⊤
      exact le_top
    · -- `p ≠ 0`, so `p ≥ 1`, hence `q ≥ 1` (from `p ≤ q`), so
      -- `filt q = ⊥`. Then `⊥ ≤ filt p` via `bot_le`.
      have hp' : 0 < p := Nat.pos_iff_ne_zero.mpr hp
      have hq : 0 < q := lt_of_lt_of_le hp' h
      have hq' : q ≠ 0 := Nat.pos_iff_ne_zero.mp hq
      show (if q = 0 then (⊤ : Submodule ℚ ℚ) else ⊥) ≤
        (if p = 0 then (⊤ : Submodule ℚ ℚ) else ⊥)
      rw [if_neg hq']
      exact bot_le
  filt_zero_eq_top := by
    show (if (0 : ℕ) = 0 then (⊤ : Submodule ℚ ℚ) else ⊥) = ⊤
    rw [if_pos rfl]
  filt_above_rank_eq_bot {k} hk := by
    -- `rank = 0 < k` so `k ≠ 0` and the if-branch gives `⊥`.
    have hk' : k ≠ 0 := Nat.pos_iff_ne_zero.mp hk
    show (if k = 0 then (⊤ : Submodule ℚ ℚ) else ⊥) = ⊥
    rw [if_neg hk']

/-- **Trivial Chern character** on the trivial holomorphic bundle:
`ch 0 = rank = 0`, `ch 1 = c_1 = 0`, `ch 2 = 0` (so the codim-2
relation `2 • 0 = 0 * 0 − 2 • 0 = 0` holds trivially). -/
instance chernCharacterPunitQ : ChernCharacterRelationData PUnit ℚ where
  ch _ := 0
  ch_zero_eq_rank := by
    -- `ch 0 = 0` and `algebraMap ℚ ℚ ((0 : ℕ) : ℚ) = 0`.
    show (0 : ℚ) = (algebraMap ℚ ℚ) (((0 : ℕ) : ℚ))
    rw [Nat.cast_zero, map_zero]
  ch_one_eq_c_one := by
    -- `ch 1 = 0`, `HolomorphicBundleData.chern (X := PUnit) (A := ℚ) 1 = 0`
    -- since `1 ≠ 0` triggers the if-branch.
    show (0 : ℚ) = (if (1 : ℕ) = 0 then (1 : ℚ) else 0)
    rw [if_neg (by decide : (1 : ℕ) ≠ 0)]
  ch_two_relation := by
    -- `2 • 0 = 0 * 0 − 2 • 0 = 0`.
    show (2 : ℚ) • (0 : ℚ) =
      (if (1 : ℕ) = 0 then (1 : ℚ) else 0) *
        (if (1 : ℕ) = 0 then (1 : ℚ) else 0)
      - (2 : ℚ) • (if (2 : ℕ) = 0 then (1 : ℚ) else 0)
    rw [if_neg (by decide : (1 : ℕ) ≠ 0),
        if_neg (by decide : (2 : ℕ) ≠ 0)]
    -- `2 • 0 = 0 * 0 − 2 • 0`, both sides reduce to `0`.
    simp

end Trivial

end HodgeReduction.Infrastructure.Cohomology
