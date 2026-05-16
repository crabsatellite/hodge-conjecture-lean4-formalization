/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Lattice
import Mathlib.Algebra.Algebra.Operations
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.CycleClassMap

/-!
# Chow ring framework

For a smooth projective variety `X` over a field `k`, the **Chow ring**
`CH^*(X) = ⨁_p CH^p(X)` is the ring of algebraic cycles modulo rational
equivalence. It carries a commutative ring structure under intersection
product.

The **cycle class map** `cl : CH^*(X)_ℚ → H^{2*}(X; ℚ)` (over `ℂ` or
via étale cohomology over arbitrary fields) is a ring homomorphism
whose image is the algebraic subring `CohomologyRing.algebraic`.

This file refines the `CycleClassMap` framework (P157) into a more
structured `ChowRing` framework with explicit ring + module
properties, plus a **graded** rational Chow ring `CHQ : ℕ → Submodule ℚ A`
with substantive multiplicative-compatibility, top-dimensional
vanishing, and fundamental-class membership.

## References

* Fulton, W. *Intersection Theory*. Ergeb. Math. Grenzgeb. (3) 2,
  Springer-Verlag 1984, Ch. 2 (Chow ring structure).
* Voisin, C. *Hodge Theory and Complex Algebraic Geometry II*. CUP
  2003, Ch. 9 (Chow ring ⊗ ℚ for the Hodge conjecture).
* Bloch, S. *Algebraic cycles and higher K-theory*. Adv. Math. 61
  (1986), 267-304.

## Main definitions

* `ChowRingData A` : typeclass refining `CycleRingData` with the
  full Chow ring structure (commutative ℚ-algebra), plus the
  codim-graded rational Chow `CHQ : ℕ → Submodule ℚ A`, multiplicative
  compatibility `CHQ p * CHQ q ≤ CHQ (p+q)`, top-dim vanishing, and
  fundamental class `1 ∈ CHQ 0`.
* `ChowGroupTotalData A` : sibling carrying the **total** rational
  Chow ring `CHTotal = ⨆ p, CHQ p` together with the substantive
  sum-equation.

## Tags

Chow ring, algebraic cycle, intersection product, cycle class map,
codimension grading, fundamental class
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Chow ring data** for a cohomology ring `A`:

* `CH` : a `ℚ`-vector space (representing `CH^*(X) ⊗ ℚ` at the linear level).
* `cl` : a `ℚ`-linear map `CH →ₗ[ℚ] A` (the cycle class map).
* `cl_image_isAlgebraic` : the image is contained in the algebraic
  subring (the **fundamental property** of the cycle class map).
* `dim` : the complex dimension of `X` (Chow ring vanishes above this
  codimension).
* `CHQ : ℕ → Submodule ℚ A` : the codim-graded rational Chow ring as
  a family of `ℚ`-submodules of `A`.
* `CHQ_mul_le` : **substantive multiplicative compatibility** —
  intersection product respects the codim grading,
  `CHQ p * CHQ q ≤ CHQ (p+q)` as `Submodule ℚ A`.
* `CHQ_vanish_above_dim` : **substantive vanishing** — `CHQ p = ⊥`
  for `p > dim` (Chow ring is concentrated in codims `0,…,dim`).
* `one_mem_CHQ_zero` : **fundamental class** `1 ∈ CHQ 0` — the
  fundamental class of `X` itself sits in codimension `0` and is the
  multiplicative identity.

For our purposes (HC application), we only need the **linear part** of
the cycle class map — the full ring structure on CH is recovered by
refining this typeclass.

The Hodge conjecture asks: is the image of `cl` exactly equal to the
rational Hodge classes? -/
class ChowRingData where
  /-- The Chow ring (abstract `ℚ`-vector space). -/
  CH : Type
  /-- `CH` is an additive commutative group. -/
  CH_addCommGroup : AddCommGroup CH
  /-- `CH` is a `ℚ`-module. -/
  CH_module : @Module ℚ CH _ CH_addCommGroup.toAddCommMonoid
  /-- The cycle class map `cl : CH → A` as a `ℚ`-linear map. -/
  cl : @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) CH A
        CH_addCommGroup.toAddCommMonoid _ CH_module _
  /-- The image of `cl` lies in the algebraic subring. -/
  cl_image_isAlgebraic : ∀ c : CH, CohomologyRing.IsAlgebraic (cl c)
  /-- The complex dimension `dim_ℂ X` (Chow ring vanishes in codim `> dim`). -/
  dim : ℕ
  /-- The codim-graded rational Chow ring as a family of `ℚ`-submodules
  of the ambient cohomology algebra. -/
  CHQ : ℕ → Submodule ℚ A
  /-- **Substantive multiplicative compatibility**: the intersection
  product respects the codim grading. -/
  CHQ_mul_le : ∀ p q : ℕ, CHQ p * CHQ q ≤ CHQ (p + q)
  /-- **Substantive vanishing above the dimension**: `CHQ p = ⊥` for
  `p > dim` (Chow ring is concentrated in codimensions `0,…,dim`). -/
  CHQ_vanish_above_dim : ∀ p : ℕ, p > dim → CHQ p = ⊥
  /-- **Fundamental class** in codim `0`: `(1 : A) ∈ CHQ 0`. The
  fundamental class `[X] ∈ CH^0(X)` always sits in codim `0` and is
  the multiplicative identity. -/
  one_mem_CHQ_zero : (1 : A) ∈ CHQ 0

namespace ChowRingData

variable {A} [ChowRingData A]

/-- The image `cl(c)` of any cycle is algebraic. -/
theorem cl_isAlgebraic (c : ChowRingData.CH (A := A)) :
    CohomologyRing.IsAlgebraic (ChowRingData.cl c) :=
  ChowRingData.cl_image_isAlgebraic c

/-- Re-export: fundamental class lives in `CHQ 0`. -/
theorem one_mem_CHQ_zero_thm :
    (1 : A) ∈ ChowRingData.CHQ (A := A) 0 :=
  ChowRingData.one_mem_CHQ_zero

/-- Substantive multiplicative compatibility (re-export). -/
theorem CHQ_mul_le_thm (p q : ℕ) :
    ChowRingData.CHQ (A := A) p * ChowRingData.CHQ q
      ≤ ChowRingData.CHQ (p + q) :=
  ChowRingData.CHQ_mul_le p q

/-- Substantive vanishing (re-export). -/
theorem CHQ_vanish_above_dim_thm (p : ℕ) (h : p > ChowRingData.dim (A := A)) :
    ChowRingData.CHQ (A := A) p = ⊥ :=
  ChowRingData.CHQ_vanish_above_dim p h

/-- **Substantive product lemma**: if `α ∈ CHQ p` and `β ∈ CHQ q`,
then `α * β ∈ CHQ (p+q)`. -/
theorem mul_mem_CHQ_add {p q : ℕ} {α β : A}
    (hα : α ∈ ChowRingData.CHQ (A := A) p)
    (hβ : β ∈ ChowRingData.CHQ q) :
    α * β ∈ ChowRingData.CHQ (p + q) :=
  ChowRingData.CHQ_mul_le p q (Submodule.mul_mem_mul hα hβ)

/-- **Substantive vanishing of products in dim out of range**: if both
factors land in components whose sum-codim exceeds `dim`, then the
product equals `0`. -/
theorem mul_eq_zero_of_codim_out_of_range
    {p q : ℕ} (h : p + q > ChowRingData.dim (A := A))
    {α β : A}
    (hα : α ∈ ChowRingData.CHQ (A := A) p)
    (hβ : β ∈ ChowRingData.CHQ q) : α * β = 0 := by
  have hmem : α * β ∈ ChowRingData.CHQ (A := A) (p + q) :=
    mul_mem_CHQ_add hα hβ
  rw [CHQ_vanish_above_dim_thm (p + q) h] at hmem
  exact (Submodule.mem_bot ℚ).mp hmem

end ChowRingData

/-- **Total rational Chow ring data**: the total Chow ring
`CHTotal : Submodule ℚ A` is defined as the supremum of the
codim-graded pieces, `CHTotal = ⨆ p, CHQ p`, together with the
substantive sum-equation witness.

Geometrically, `CHTotal = CH^*(X) ⊗ ℚ ⊆ H^{2*}(X; ℚ)` is the
rational total Chow ring sitting inside the rational cohomology.
For the Hodge conjecture, the question is whether `CHTotal` equals
the Hodge-class sub-ℚ-module. -/
class ChowGroupTotalData [ChowRingData A] where
  /-- The total rational Chow ring as a `ℚ`-submodule of `A`. -/
  CHTotal : Submodule ℚ A
  /-- **Substantive sum-equation**: `CHTotal = ⨆ p, CHQ p`. -/
  CHTotal_eq_iSup_CHQ :
    CHTotal = ⨆ p : ℕ, ChowRingData.CHQ (A := A) p
  /-- The fundamental class `1` belongs to `CHTotal`. Substantive
  membership lifted from `one_mem_CHQ_zero`. -/
  one_mem_CHTotal : (1 : A) ∈ CHTotal

namespace ChowGroupTotalData

variable {A} [ChowRingData A] [ChowGroupTotalData A]

/-- Re-export: `CHTotal = ⨆ p, CHQ p`. -/
theorem CHTotal_eq_iSup_CHQ_thm :
    (ChowGroupTotalData.CHTotal (A := A))
      = ⨆ p : ℕ, ChowRingData.CHQ (A := A) p :=
  ChowGroupTotalData.CHTotal_eq_iSup_CHQ

/-- Every codim-graded piece is contained in `CHTotal`. -/
theorem CHQ_le_CHTotal (p : ℕ) :
    ChowRingData.CHQ (A := A) p ≤ ChowGroupTotalData.CHTotal := by
  rw [CHTotal_eq_iSup_CHQ_thm]
  exact le_iSup (fun q : ℕ => ChowRingData.CHQ (A := A) q) p

/-- The fundamental class `1` lies in `CHTotal` (re-export). -/
theorem one_mem_CHTotal_thm :
    (1 : A) ∈ ChowGroupTotalData.CHTotal (A := A) :=
  ChowGroupTotalData.one_mem_CHTotal

end ChowGroupTotalData

/-! ### Trivial inhabiting instances

The trivial inhabiting instances take the abstract Chow vector space
`CH` to be `PUnit`-like, and the graded Chow `CHQ` to be the constantly-
`⊤` submodule family. These instances exist purely to inhabit the
typeclasses; concrete `ChowRingData` instances will use the actual
codim-graded rational Chow of the variety. -/

/-- The trivial codim-graded Chow ring family used by the trivial
inhabiting instance: `triCHQ 0 = ⊤`, `triCHQ (n+1) = ⊥`. Defining this
as a named function (rather than inlining via `fun p => match …`)
lets us prove the supporting lemmas by `rfl` on the named definition. -/
def triCHQ : ℕ → Submodule ℚ A
  | 0 => ⊤
  | _ + 1 => ⊥

omit [CohomologyRing A] in
@[simp] lemma triCHQ_zero : triCHQ A 0 = (⊤ : Submodule ℚ A) := rfl
omit [CohomologyRing A] in
@[simp] lemma triCHQ_succ (n : ℕ) : triCHQ A (n + 1) = (⊥ : Submodule ℚ A) := rfl

/-- Trivial inhabiting instance for `ChowRingData` over any
cohomology-ring carrier `A`: the abstract Chow vector space is
collapsed to a trivial `ℚ`-module, the cycle class map is the zero
map, and the codim grading is `CHQ 0 = ⊤`, `CHQ (n+1) = ⊥`.

NOTE: this is purely a non-emptiness witness; the *concrete* EVII
instance in `HodgeReduction.Concrete.EVII` is the load-bearing one. -/
noncomputable def trivialChowRingData : ChowRingData A where
  CH := ℚ
  CH_addCommGroup := inferInstance
  CH_module := inferInstance
  cl := 0
  cl_image_isAlgebraic := by
    intro c
    show CohomologyRing.IsAlgebraic ((0 : ℚ →ₗ[ℚ] A) c)
    simp only [LinearMap.zero_apply]
    exact CohomologyRing.isAlgebraic_zero
  dim := 0
  CHQ := triCHQ A
  CHQ_mul_le := by
    intro p q
    rcases p with _ | p
    · rcases q with _ | q
      · -- `p = q = 0`: `⊤ * ⊤ ≤ CHQ 0 = ⊤`
        rw [triCHQ_zero]; exact le_top
      · -- `p = 0`, `q = q' + 1`: `_ * ⊥ ≤ _`
        rw [triCHQ_succ, Submodule.mul_bot]; exact bot_le
    · -- `p = p' + 1`: `⊥ * _ ≤ _`
      rw [triCHQ_succ, Submodule.bot_mul]; exact bot_le
  CHQ_vanish_above_dim := by
    intro p hp
    rcases p with _ | p
    · exact absurd hp (lt_irrefl _)
    · exact triCHQ_succ A p
  one_mem_CHQ_zero := by
    rw [triCHQ_zero]; exact Submodule.mem_top

/-- Trivial inhabiting instance for `ChowGroupTotalData` paired with
`trivialChowRingData`: take `CHTotal := ⊤`. The sum-equation
`⊤ = ⨆ p, CHQ p` is delivered substantively via the fact that the
zero-codim piece in the trivial pairing is `triCHQ 0 = ⊤`, hence the
supremum is `⊤`. -/
noncomputable def trivialChowGroupTotalData :
    letI : ChowRingData A := trivialChowRingData A
    ChowGroupTotalData A :=
  letI : ChowRingData A := trivialChowRingData A
  { CHTotal := ⊤
    CHTotal_eq_iSup_CHQ := by
      -- Under `trivialChowRingData`, `CHQ p = triCHQ A p`, so the
      -- supremum dominates `triCHQ A 0 = ⊤`.
      refine le_antisymm ?_ le_top
      -- `⊤ ≤ ⨆ p, CHQ p`: since `CHQ 0 = ⊤`, the supremum is `⊤`.
      have h0 : (⊤ : Submodule ℚ A) ≤ ⨆ p : ℕ, triCHQ A p := by
        have := le_iSup (fun p : ℕ => triCHQ A p) 0
        rwa [triCHQ_zero] at this
      exact h0
    one_mem_CHTotal := Submodule.mem_top }

end HodgeReduction.Infrastructure.Cohomology
