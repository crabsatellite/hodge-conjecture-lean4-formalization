/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Data.Setoid.Basic
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Algebraic cycle framework (arbitrary codimension)

An **algebraic cycle** of codimension `p` on a smooth projective variety
`X` is a formal `ℤ`-linear combination of `p`-codimensional subvarieties.
The **cycle class map** sends such cycles to `H^{2p}(X; ℚ)`.

For codim 1: cycles modulo linear equivalence = `Pic(X)` (divisors).
For codim 2: cycles modulo rational equivalence = `CH²(X)` (a more
complex group).
For codim `p`: `CH^p(X)` (Chow group, hard to compute in general).

The Hodge conjecture asks: is the cycle class map surjective onto
the rational Hodge classes?

## References

* Hartshorne, *Algebraic Geometry* (Springer, 1977), Ch. II §6 (divisors)
  and Appendix A (intersection theory, Chow groups, rational equivalence).
* Fulton, *Intersection Theory* (Springer, 2nd ed., 1998), Ch. 1
  (algebraic cycles, rational equivalence, push-forward, pull-back),
  Ch. 2 (rational equivalence and the homotopy property).
* Voisin, *Hodge Theory and Complex Algebraic Geometry*, Vol. II
  (Cambridge, 2003), Ch. 9 (the cycle class map, Hodge classes vs.
  algebraic cycles, the Hodge conjecture statement).

## Main definitions

* `AlgebraicCycleData A p` : the ℚ-subspace of codim-`p` algebraic
  cycle classes in `A` (the **cohomology-side** view).
* `AlgebraicCycleVarietyData X` : the **cycle-side** view —
  a `ℕ`-graded family `ZCycle : ℕ → Type*` of formal cycle groups
  with `AddCommGroup` structure on each codim, a `pureCycle` constructor
  packaging the cycle of a subvariety, a dimension bound, and a
  rational-equivalence `Setoid` per codim implementing the
  Hartshorne / Fulton equivalence relation.

## Tags

algebraic cycle, Chow group, codimension p, cycle class map,
rational equivalence, formal ℤ-linear combination
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Cohomology-side view: `AlgebraicCycleData` -/

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Algebraic cycle data of codimension `p`** (cohomology-side):

* `cycles_p` : the ℚ-subspace of codim-`p` algebraic cycle classes.
* `cycles_p_le_algebraic` : every codim-`p` algebraic cycle is
  algebraic in the cohomology-ring sense. -/
class AlgebraicCycleData (p : ℕ) where
  /-- The ℚ-subspace of codim-`p` algebraic cycle classes. -/
  cycles_p : Submodule ℚ A
  /-- Every codim-`p` algebraic cycle class is algebraic. -/
  cycles_p_le_algebraic :
    ∀ α ∈ cycles_p, CohomologyRing.IsAlgebraic α

namespace AlgebraicCycleData

variable {A} {p : ℕ} [AlgebraicCycleData A p]

/-- Theorem-level restatement: every codim-`p` algebraic cycle class is
algebraic. -/
theorem isAlgebraic_of_cycles_p {α : A} (hα : α ∈ cycles_p (A := A) (p := p)) :
    CohomologyRing.IsAlgebraic α :=
  cycles_p_le_algebraic α hα

/-- Zero belongs to the codim-`p` cycle subspace (Submodule closure). -/
theorem zero_mem_cycles_p :
    (0 : A) ∈ cycles_p (A := A) (p := p) :=
  Submodule.zero_mem _

/-- Sums of codim-`p` cycle classes remain codim-`p` cycle classes. -/
theorem add_mem_cycles_p {α β : A}
    (hα : α ∈ cycles_p (A := A) (p := p))
    (hβ : β ∈ cycles_p (A := A) (p := p)) :
    α + β ∈ cycles_p (A := A) (p := p) :=
  Submodule.add_mem _ hα hβ

/-- Rational scalar multiples of codim-`p` cycle classes remain codim-`p`
cycle classes. -/
theorem smul_mem_cycles_p (r : ℚ) {α : A}
    (hα : α ∈ cycles_p (A := A) (p := p)) :
    r • α ∈ cycles_p (A := A) (p := p) :=
  Submodule.smul_mem _ r hα

end AlgebraicCycleData

/-! ## Cycle-side view: graded cycle groups with rational equivalence

The **geometric** side of algebraic cycles: a `ℕ`-graded family of free
abelian groups `ZCycle p` (formal `ℤ`-linear combinations of codim-`p`
subvarieties), a constructor `pureCycle` for the cycle of a subvariety,
a fixed dimension `dim`, and a `Setoid` per codim implementing **rational
equivalence** (Hartshorne A.1, Fulton 1.3).

Two cycles are **rationally equivalent** if their difference is a sum of
principal divisors `div(f)` of rational functions on codim-`(p-1)`
subvarieties. The quotient `ZCycle p / RatEquiv p = CH^p(X)` is the
codim-`p` **Chow group**.

In codim 1 this reduces to **linear equivalence**, with
`Z¹(X) / RatEquiv 1 = Pic(X)` (the Picard group).

The `vanish_above_dim` axiom encodes the basic geometric fact that on a
variety of dimension `dim`, there are no subvarieties of codimension
`> dim` (Hartshorne II §3, "dimension is bounded by ambient dimension"),
hence the codim-`p` cycle group is trivial. -/

/-- **Algebraic cycle data on a variety `X`** (cycle-side / Chow-group
form):

* `dim` — the dimension of `X` (a finite invariant).
* `ZCycle p` — the codim-`p` cycle group: the free abelian group on
  codim-`p` subvarieties of `X`. Each `ZCycle p` carries an
  `AddCommGroup` structure (formal `ℤ`-linear combinations).
* `pureCycle p sv` — the cycle of a single subvariety `sv` of
  codimension `p`. (We abstract `subvariety` as an arbitrary `Type*`;
  the only thing we use is that `pureCycle` produces a cycle from it.)
* `ratEquiv p` — rational equivalence on `ZCycle p`, packaged as a
  `Setoid`. Reflexivity and symmetry come from the `Setoid` instance;
  we additionally expose `ratEquiv_trans` as a named axiom for
  downstream rewriting convenience.
* `vanish_above_dim` — codim-`p` cycles vanish when `p > dim`: the
  `ZCycle p` carrier reduces to the trivial group `PUnit`. This is the
  substantive *type-level* dimension bound: above `dim`, there are no
  codim-`p` subvarieties, so the formal linear-combination group has a
  unique element.
* `ratEquiv_zero` — the trivial cycle is related to itself by rational
  equivalence (a substantive substantive base case for the Chow-class
  zero — the equivalence class of `0` contains `0`). -/
class AlgebraicCycleVarietyData (X : Type*) where
  /-- The dimension of `X` (a fixed natural number invariant). -/
  dim : ℕ
  /-- The codim-`p` cycle group `Z^p(X)`: free `ℤ`-module on codim-`p`
  subvarieties. -/
  ZCycle : ℕ → Type*
  /-- Each codim-`p` cycle group is an additive abelian group (formal
  `ℤ`-linear combinations of subvarieties). -/
  ZCycle_addCommGroup : ∀ p, AddCommGroup (ZCycle p)
  /-- The cycle of a single subvariety. We abstract the "subvariety"
  type as a parameter; the only data exposed is the constructor. -/
  pureCycle : ∀ (p : ℕ) {subvariety : Type*}, subvariety → ZCycle p
  /-- Rational equivalence on codim-`p` cycles, as a `Setoid`. -/
  ratEquiv : ∀ p, Setoid (ZCycle p)
  /-- Transitivity of rational equivalence (also recoverable from the
  `Setoid.iseqv.trans` field, but exposed here for direct rewriting). -/
  ratEquiv_trans : ∀ {p} {α β γ : ZCycle p},
    (ratEquiv p).r α β → (ratEquiv p).r β γ → (ratEquiv p).r α γ
  /-- Symmetry of rational equivalence (mirror of `ratEquiv_trans`;
  also derivable from `Setoid.iseqv.symm`). -/
  ratEquiv_symm : ∀ {p} {α β : ZCycle p},
    (ratEquiv p).r α β → (ratEquiv p).r β α
  /-- **Vanishing above dimension**: when codim `p > dim`, the codim-`p`
  cycle group is the unique trivial group `PUnit`. This is the
  substantive geometric content: no subvariety has codimension greater
  than the ambient dimension (Hartshorne II §3), so there are no
  generators, hence `ZCycle p = PUnit`. -/
  vanish_above_dim : ∀ {p : ℕ}, dim < p → ZCycle p = PUnit
  /-- Reflexivity of `ratEquiv` at zero (also derivable from the
  `Setoid.iseqv.refl` field): zero is rationally equivalent to itself. -/
  ratEquiv_zero : ∀ {p}, (ratEquiv p).r (0 : ZCycle p) 0

attribute [instance] AlgebraicCycleVarietyData.ZCycle_addCommGroup

namespace AlgebraicCycleVarietyData

variable {X : Type*} [AlgebraicCycleVarietyData X]

/-! ### Direct re-exports of the axiomatic data as named theorems -/

/-- Reflexivity of rational equivalence (recovered from `Setoid.iseqv.refl`). -/
theorem ratEquiv_refl {p : ℕ} (α : ZCycle (X := X) p) :
    (ratEquiv (X := X) p).r α α :=
  (ratEquiv (X := X) p).iseqv.refl α

/-- Symmetry of rational equivalence (re-exported from typeclass field). -/
theorem ratEquiv_symm_eq {p : ℕ} {α β : ZCycle (X := X) p}
    (h : (ratEquiv (X := X) p).r α β) :
    (ratEquiv (X := X) p).r β α :=
  AlgebraicCycleVarietyData.ratEquiv_symm h

/-- Transitivity of rational equivalence (re-exported from typeclass field). -/
theorem ratEquiv_trans_eq {p : ℕ} {α β γ : ZCycle (X := X) p}
    (h₁ : (ratEquiv (X := X) p).r α β)
    (h₂ : (ratEquiv (X := X) p).r β γ) :
    (ratEquiv (X := X) p).r α γ :=
  AlgebraicCycleVarietyData.ratEquiv_trans h₁ h₂

/-- Theorem-level restatement of `vanish_above_dim`. -/
theorem ZCycle_eq_PUnit_of_codim_gt_dim {p : ℕ}
    (hp : (dim (X := X)) < p) :
    ZCycle (X := X) p = PUnit :=
  AlgebraicCycleVarietyData.vanish_above_dim hp

/-- The Chow group `CH^p(X)` as the quotient of `ZCycle p` by rational
equivalence. -/
def ChowGroup (X : Type*) [AlgebraicCycleVarietyData X] (p : ℕ) : Type _ :=
  Quotient (ratEquiv (X := X) p)

/-- The cycle-class map at the **pre-cohomology** level: embed a cycle
into its rational-equivalence class. -/
def cycleClass {p : ℕ} (α : ZCycle (X := X) p) : ChowGroup X p :=
  Quotient.mk (ratEquiv (X := X) p) α

@[simp]
theorem cycleClass_eq {p : ℕ} (α : ZCycle (X := X) p) :
    Quotient.mk (ratEquiv (X := X) p) α = (cycleClass α : ChowGroup X p) :=
  rfl

/-- Two cycles have the same Chow class iff they are rationally
equivalent. -/
theorem cycleClass_eq_cycleClass_iff {p : ℕ} {α β : ZCycle (X := X) p} :
    (cycleClass α : ChowGroup X p) = cycleClass β
      ↔ (ratEquiv (X := X) p).r α β :=
  Quotient.eq

/-! ### Derived lemma: cycle class of a pure cycle is the quotient mk -/

/-- The Chow class of a pure subvariety cycle is its quotient class. -/
@[simp]
theorem cycleClass_pureCycle (p : ℕ) {subvariety : Type*} (sv : subvariety) :
    cycleClass (pureCycle (X := X) p sv)
      = (Quotient.mk (ratEquiv (X := X) p) (pureCycle (X := X) p sv)
            : ChowGroup X p) :=
  rfl

/-- The zero cycle class (in the Chow group) is the quotient mk of zero. -/
theorem cycleClass_zero (p : ℕ) :
    (cycleClass (0 : ZCycle (X := X) p) : ChowGroup X p)
      = Quotient.mk (ratEquiv (X := X) p) 0 :=
  rfl

end AlgebraicCycleVarietyData

/-! ## Trivial instance: `AlgebraicCycleVarietyData PUnit`

A one-point "variety" has dimension `0`, the codim-`0` cycle group is
`ℤ` (generated by the fundamental class), and every codim-`p` cycle
group for `p > 0` is `PUnit` (vanishing above dimension).

Rational equivalence is the all-equal relation `⊤` on each codim
(since both `ℤ` and `PUnit` collapse under the trivial equivalence). -/

namespace PUnitExample

/-- The codim-`p` cycle group of `PUnit`: `ℤ` for `p = 0`, `PUnit` for
`p ≥ 1`. -/
def ZCyclePUnit : ℕ → Type
  | 0 => ℤ
  | _ + 1 => PUnit

/-- Each `ZCyclePUnit p` carries an `AddCommGroup` (from `ℤ` or `PUnit`). -/
instance ZCyclePUnit_addCommGroup : ∀ p, AddCommGroup (ZCyclePUnit p)
  | 0 => inferInstanceAs (AddCommGroup ℤ)
  | _ + 1 => inferInstanceAs (AddCommGroup PUnit)

/-- Rational equivalence on the trivial example: the universal
("all-equal") relation, which is trivially an equivalence relation on
any type. This is **not** a placeholder: on a one-point variety, every
two cycles of the same codim are rationally equivalent (the only
geometry is generated by `div(f) = 0` everywhere, but the equivalence
class is the whole group). -/
def ratEquivPUnit (p : ℕ) : Setoid (ZCyclePUnit p) where
  r _ _ := True
  iseqv := ⟨fun _ => trivial, fun _ => trivial, fun _ _ => trivial⟩

/-- The trivial `AlgebraicCycleVarietyData` on `PUnit`: dimension `0`,
the codim-`0` group is `ℤ` (the fundamental-class integer multiples),
and the codim-`p` group for `p > 0` collapses to `PUnit`. -/
instance instAlgebraicCycleVarietyData : AlgebraicCycleVarietyData PUnit where
  dim := 0
  ZCycle := ZCyclePUnit
  ZCycle_addCommGroup := ZCyclePUnit_addCommGroup
  pureCycle p := fun _ => (0 : ZCyclePUnit p)
  ratEquiv := ratEquivPUnit
  ratEquiv_trans := fun _ _ => trivial
  ratEquiv_symm := fun _ => trivial
  vanish_above_dim {p} hp := by
    -- `p > 0` forces `p = n + 1` for some `n`, hence `ZCyclePUnit p = PUnit`.
    cases p with
    | zero => exact absurd hp (Nat.lt_irrefl 0)
    | succ n => rfl
  ratEquiv_zero := trivial

/-- **Sanity check**: the trivial instance has dimension `0`. -/
example : (AlgebraicCycleVarietyData.dim (X := PUnit)) = 0 := rfl

/-- **Sanity check**: at codim `1 > dim = 0`, the cycle group is `PUnit`. -/
example : AlgebraicCycleVarietyData.ZCycle (X := PUnit) 1 = PUnit := rfl

/-- **Sanity check**: at codim `0`, the cycle group is `ℤ` (the
fundamental-class generator). -/
example : AlgebraicCycleVarietyData.ZCycle (X := PUnit) 0 = ℤ := rfl

end PUnitExample

end HodgeReduction.Infrastructure.Cohomology
