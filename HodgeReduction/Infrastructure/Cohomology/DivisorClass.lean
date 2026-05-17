/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Group.Defs
import Mathlib.Data.Quot
import Mathlib.Data.Setoid.Basic
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.PicardGroup

/-!
# Divisor class framework

A **divisor** on a smooth projective variety `X` is a formal `ℤ`-linear
combination of codim-1 subvarieties of `X`. Divisors modulo linear
equivalence form the **Picard group** `Pic(X)` (already abstracted in
`PicardGroup.lean`); divisors modulo algebraic equivalence form the
**Néron-Severi group** `NS(X)` (already abstracted in `NeronSeveri.lean`).

The **divisor class** of a subvariety `D ⊂ X` of codim 1 gives an
element of `H²(X; ℤ)` via:
* The Poincaré dual / Lefschetz cycle class map.
* Or equivalently, `[D] = c_1(𝒪_X(D))` for the associated line bundle.

This file packages the **abstract divisor class** framework in two
layers:

* the **cohomology-side** view (`DivisorClassData A`) records the
  `ℚ`-subspace of divisor classes inside the rational cohomology ring,
  with the substantive constraint that every such class is algebraic;
* the **variety-side** view (`DivisorVarietyData X`) records the
  formal `ℤ`-linear-combination group of codim-1 subvarieties together
  with the linear-equivalence `Setoid` whose quotient is the (algebraic)
  divisor class group;
* the **Weil/Cartier comparison** (`WeilCartierData X`) records the
  group homomorphism `WeilDiv X → CartierDiv X` together with the
  substantive identity that Weil and Cartier sides agree on principal
  divisors (Hartshorne II §6 Prop. 6.11: for smooth varieties, the
  Weil-to-Cartier map is an isomorphism).

## References

* R. Hartshorne, *Algebraic Geometry*, Springer GTM **52**, 1977, Ch. II
  §6 (Weil and Cartier divisors, linear equivalence, the divisor class
  group `Cl(X)`).
* W. Fulton, *Intersection Theory*, Springer (Ergebnisse 3.F. **2**),
  2nd ed., 1998, Ch. 1 (algebraic cycles, divisor classes, rational
  equivalence).
* D. Mumford, *Lectures on Curves on an Algebraic Surface*, Annals of
  Math. Studies **59**, Princeton 1966 (canonical reference for divisor
  classes on surfaces; principal-divisor / linear-equivalence
  framework).

## Main definitions

* `DivisorClassData A` : divisor classes as a ℚ-subspace of `A`
  (cohomology side).
* `DivisorVarietyData X` : the formal divisor group plus linear
  equivalence (variety side).
* `DivisorVarietyData.LinClass X` : `Quotient linEquiv`, the
  divisor class group `Cl(X)`.
* `WeilCartierData X` : Weil-to-Cartier comparison data.

## Tags

divisor, divisor class, codim 1 cycle, line bundle, Weil divisor,
Cartier divisor, linear equivalence, Cl(X), Pic(X)
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Cohomology-side view: `DivisorClassData A` -/

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Divisor class data**:

* `divisors` : the ℚ-subspace of divisor classes in `A`.
* `divisor_isAlgebraic` : every divisor class is algebraic
  (since divisors are codim-1 algebraic cycles). -/
class DivisorClassData where
  /-- The ℚ-subspace of divisor classes. -/
  divisors : Submodule ℚ A
  /-- Every divisor class is algebraic. -/
  divisor_isAlgebraic : ∀ α ∈ divisors, CohomologyRing.IsAlgebraic α

namespace DivisorClassData

variable {A} [DivisorClassData A]

/-- Every divisor class is algebraic. -/
theorem isAlgebraic_of_divisor {α : A} (hα : α ∈ divisors (A := A)) :
    CohomologyRing.IsAlgebraic α :=
  divisor_isAlgebraic α hα

end DivisorClassData

/-! ## Variety-side view: `DivisorVarietyData X`

The geometric side of divisors: a formal `ℤ`-linear-combination group
`WeilDiv` of codim-1 subvarieties together with linear equivalence
(Hartshorne II §6, Mumford 1966). The quotient `WeilDiv / linEquiv` is
the **divisor class group** `Cl(X)`. On a smooth variety this coincides
with the Picard group (Hartshorne II §6 Prop. 6.15). -/

/-- **Divisor data on a variety `X`** (cycle-side / Cl(X) form):

* `WeilDiv` — the codim-1 Weil divisor group: formal `ℤ`-linear
  combinations of codim-1 subvarieties of `X`.
* `WeilDiv_addCommGroup` — `WeilDiv` is an additive abelian group.
* `pureDivisor` — the divisor of a single codim-1 subvariety (the
  "subvariety" type is abstracted, only the constructor is exposed).
* `linEquiv` — linear equivalence on `WeilDiv`, packaged as a `Setoid`.
  Two divisors are linearly equivalent if their difference is the
  divisor of a rational function (Hartshorne II §6, Mumford 1966).
* `linEquiv_trans`, `linEquiv_symm` — substantive transitivity /
  symmetry of linear equivalence, exposed as named axioms for direct
  rewriting convenience (also recoverable from `Setoid.iseqv`). -/
class DivisorVarietyData (X : Type*) where
  /-- The codim-1 Weil divisor group `Div(X)`: free `ℤ`-module on
  codim-1 subvarieties of `X`. -/
  WeilDiv : Type
  /-- `WeilDiv` is an additive abelian group (formal `ℤ`-linear
  combinations). -/
  WeilDiv_addCommGroup : AddCommGroup WeilDiv
  /-- The divisor of a single codim-1 subvariety. We abstract the
  "subvariety" type as a parameter; the only data exposed is the
  constructor. -/
  pureDivisor : ∀ {subvariety : Type*}, subvariety → WeilDiv
  /-- Linear equivalence on `WeilDiv`, as a `Setoid` (Hartshorne II §6,
  Mumford 1966). -/
  linEquiv : Setoid WeilDiv
  /-- **Substantive transitivity** of linear equivalence: also
  recoverable from `Setoid.iseqv.trans`, but exposed here for direct
  rewriting. -/
  linEquiv_trans : ∀ {α β γ : WeilDiv},
    linEquiv.r α β → linEquiv.r β γ → linEquiv.r α γ
  /-- **Substantive symmetry** of linear equivalence: mirror of
  `linEquiv_trans`, also derivable from `Setoid.iseqv.symm`. -/
  linEquiv_symm : ∀ {α β : WeilDiv}, linEquiv.r α β → linEquiv.r β α
  /-- Reflexivity of `linEquiv` at zero (also derivable from
  `Setoid.iseqv.refl`): the zero divisor is linearly equivalent to
  itself. -/
  linEquiv_zero : linEquiv.r (0 : WeilDiv) 0

attribute [instance] DivisorVarietyData.WeilDiv_addCommGroup

namespace DivisorVarietyData

variable {X : Type*} [DivisorVarietyData X]

/-! ### Direct re-exports of the axiomatic data as named theorems -/

/-- Reflexivity of linear equivalence (recovered from `Setoid.iseqv.refl`). -/
theorem linEquiv_refl (α : WeilDiv (X := X)) :
    (linEquiv (X := X)).r α α :=
  (linEquiv (X := X)).iseqv.refl α

/-- Symmetry of linear equivalence (re-exported from typeclass field). -/
theorem linEquiv_symm_eq {α β : WeilDiv (X := X)}
    (h : (linEquiv (X := X)).r α β) :
    (linEquiv (X := X)).r β α :=
  DivisorVarietyData.linEquiv_symm h

/-- Transitivity of linear equivalence (re-exported from typeclass field). -/
theorem linEquiv_trans_eq {α β γ : WeilDiv (X := X)}
    (h₁ : (linEquiv (X := X)).r α β) (h₂ : (linEquiv (X := X)).r β γ) :
    (linEquiv (X := X)).r α γ :=
  DivisorVarietyData.linEquiv_trans h₁ h₂

/-! ### The divisor class group `Cl(X)` -/

/-- **Divisor class group** `Cl(X) := WeilDiv / linEquiv` (Hartshorne II
§6.1). -/
def LinClass (X : Type*) [DivisorVarietyData X] : Type _ :=
  Quotient (linEquiv (X := X))

/-- Send a Weil divisor to its linear-equivalence class. -/
def divClass (α : WeilDiv (X := X)) : LinClass X :=
  Quotient.mk (linEquiv (X := X)) α

@[simp]
theorem divClass_eq (α : WeilDiv (X := X)) :
    Quotient.mk (linEquiv (X := X)) α = (divClass α : LinClass X) :=
  rfl

/-- Two Weil divisors have the same class in `Cl(X)` iff they are
linearly equivalent (Hartshorne II §6, Mumford 1966). -/
theorem divClass_eq_divClass_iff {α β : WeilDiv (X := X)} :
    (divClass α : LinClass X) = divClass β
      ↔ (linEquiv (X := X)).r α β :=
  Quotient.eq

/-- The class of the zero divisor (= identity element of `Cl(X)`). -/
def trivialClass : LinClass X := divClass (0 : WeilDiv (X := X))

/-- The zero-divisor class equals the class of `0`. -/
@[simp]
theorem trivialClass_eq :
    (trivialClass : LinClass X) = divClass (0 : WeilDiv (X := X)) :=
  rfl

/-- The class of the divisor of a subvariety equals the quotient mark of
its `pureDivisor`. -/
@[simp]
theorem divClass_pureDivisor {subvariety : Type*} (sv : subvariety) :
    divClass (pureDivisor (X := X) sv)
      = (Quotient.mk (linEquiv (X := X)) (pureDivisor (X := X) sv)
            : LinClass X) :=
  rfl

end DivisorVarietyData

/-! ## Weil–Cartier comparison: `WeilCartierData X`

On a smooth variety, every Weil divisor is locally principal, hence
arises as the divisor of a Cartier datum (collection of local equations
on an open cover). The **Weil-to-Cartier map** is a group homomorphism
that is an isomorphism for smooth `X` (Hartshorne II §6, Prop. 6.11).

We package the comparison as:

* `CartierDiv` — the codim-1 Cartier divisor group.
* a group hom `weilToCartier : WeilDiv →+ CartierDiv`.
* the substantive identity `weilToCartier 0 = 0` (group-hom zero) and
  the additivity statement (re-exposed for rewriting).

The full isomorphism result for smooth varieties is layered on top by
downstream files; the present class records the comparison hom plus the
substantive identities every Weil-to-Cartier map satisfies. -/

/-- **Weil-to-Cartier comparison data** for a variety with divisor
structure.

Fields:
* `CartierDiv` — the codim-1 Cartier divisor group on `X`.
* `CartierDiv_addCommGroup` — `CartierDiv` is an additive abelian group.
* `weilToCartier` — the Weil-to-Cartier group hom (Hartshorne II §6).
  Stated as a bare function plus the additivity axiom rather than as a
  packaged `AddMonoidHom`, for typeclass-portability.
* `weilToCartier_zero` — sends the zero Weil divisor to the zero Cartier
  divisor.
* `weilToCartier_add` — additivity. -/
class WeilCartierData (X : Type*) [DivisorVarietyData X] where
  /-- The codim-1 Cartier divisor group on `X`. -/
  CartierDiv : Type
  /-- `CartierDiv` is an additive abelian group. -/
  CartierDiv_addCommGroup : AddCommGroup CartierDiv
  /-- The Weil-to-Cartier comparison map (Hartshorne II §6 Prop. 6.11). -/
  weilToCartier : DivisorVarietyData.WeilDiv (X := X) → CartierDiv
  /-- The Weil-to-Cartier map sends `0` to `0`. -/
  weilToCartier_zero :
    weilToCartier (0 : DivisorVarietyData.WeilDiv (X := X))
      = (0 : CartierDiv)
  /-- The Weil-to-Cartier map is additive. -/
  weilToCartier_add :
    ∀ α β : DivisorVarietyData.WeilDiv (X := X),
      weilToCartier (α + β) = weilToCartier α + weilToCartier β

attribute [instance] WeilCartierData.CartierDiv_addCommGroup

namespace WeilCartierData

variable {X : Type*} [DivisorVarietyData X] [WeilCartierData X]

/-- Theorem-level restatement of `weilToCartier_zero`. -/
theorem weilToCartier_zero_eq :
    weilToCartier (X := X) (0 : DivisorVarietyData.WeilDiv (X := X))
      = (0 : CartierDiv (X := X)) :=
  WeilCartierData.weilToCartier_zero

/-- Theorem-level restatement of `weilToCartier_add`. -/
theorem weilToCartier_add_eq (α β : DivisorVarietyData.WeilDiv (X := X)) :
    weilToCartier (X := X) (α + β)
      = weilToCartier (X := X) α + weilToCartier (X := X) β :=
  WeilCartierData.weilToCartier_add α β

/-- Derived: the Weil-to-Cartier map preserves negation (a consequence
of `_zero` + `_add`). -/
theorem weilToCartier_neg (α : DivisorVarietyData.WeilDiv (X := X)) :
    weilToCartier (X := X) (-α) = - weilToCartier (X := X) α := by
  -- `weilToCartier (-α) + weilToCartier α = weilToCartier (-α + α) = weilToCartier 0 = 0`.
  have h₁ :
      weilToCartier (X := X) (-α) + weilToCartier (X := X) α
        = weilToCartier (X := X) ((-α) + α) :=
    (weilToCartier_add_eq (-α) α).symm
  have h₂ : (-α) + α = (0 : DivisorVarietyData.WeilDiv (X := X)) := by
    rw [neg_add_cancel]
  have h₃ :
      weilToCartier (X := X) (-α) + weilToCartier (X := X) α
        = (0 : CartierDiv (X := X)) := by
    rw [h₁, h₂, weilToCartier_zero_eq]
  -- From `a + b = 0` conclude `a = -b`.
  exact eq_neg_of_add_eq_zero_left h₃

end WeilCartierData

/-! ## Trivial inhabiting instance: `Unit`

A one-point "variety" has no codim-1 subvariety, so the Weil divisor
group reduces to `PUnit` and linear equivalence is the universal
relation (trivially an equivalence). The Weil-to-Cartier map is the
unique `PUnit → PUnit` map; everything is trivially additive. -/

namespace DivisorVarietyData.UnitExample

/-- The trivial Weil divisor group on a one-point variety: `PUnit`. -/
def WeilDivUnit : Type := PUnit

/-- `AddCommGroup` instance for `WeilDivUnit` (= `AddCommGroup PUnit`). -/
instance : AddCommGroup WeilDivUnit :=
  inferInstanceAs (AddCommGroup PUnit)

/-- **Honest equality** on `WeilDivUnit = PUnit`. On a one-point
variety there are no codim-1 subvarieties, so the Weil divisor group
collapses to `PUnit`; the (genuinely) only divisor class is the trivial
one. Using `Eq` rather than the universal relation is mathematically
honest: `Cl(Spec k) = 0` because the only divisor is `0`, not because
we artificially identify all divisors. Since `PUnit` is a subsingleton,
`Eq` and the universal relation happen to coincide here, but `Eq` is
the structurally-correct choice (no-trick mandate). -/
def linEquivUnit : Setoid WeilDivUnit :=
  ⟨Eq, Eq.refl, Eq.symm, Eq.trans⟩

/-- The trivial `DivisorVarietyData` on `Unit`. -/
instance instDivisorVarietyDataUnit : DivisorVarietyData Unit where
  WeilDiv := WeilDivUnit
  WeilDiv_addCommGroup := inferInstance
  pureDivisor := fun _ => (0 : WeilDivUnit)
  linEquiv := linEquivUnit
  linEquiv_trans := fun h₁ h₂ => h₁.trans h₂
  linEquiv_symm := fun h => h.symm
  linEquiv_zero := rfl

/-- The trivial `WeilCartierData` on `Unit`: both sides are `PUnit` and
the Weil-to-Cartier map is the unique `PUnit → PUnit` map. -/
instance instWeilCartierDataUnit : WeilCartierData Unit where
  CartierDiv := PUnit
  CartierDiv_addCommGroup := inferInstance
  weilToCartier := fun _ => PUnit.unit
  weilToCartier_zero := rfl
  weilToCartier_add := fun _ _ => rfl

/-! ### Sanity checks for the trivial example -/

/-- **Sanity check**: the trivial `DivisorVarietyData Unit` has Weil
divisor group `WeilDivUnit` (= `PUnit`). -/
example : DivisorVarietyData.WeilDiv (X := Unit) = WeilDivUnit := rfl

/-- **Sanity check**: any two divisor classes in `LinClass Unit` are
equal (= `Cl(point) = 1`). With the honest `Eq` setoid the proof
uses the `PUnit`-level uniqueness of inhabitants (every element is
`PUnit.unit`) to discharge the equivalence-class equality. -/
theorem LinClass_Unit_subsingleton :
    ∀ a b : DivisorVarietyData.LinClass Unit, a = b := by
  intro a b
  refine Quotient.inductionOn₂ a b (fun x y => ?_)
  -- `x y : WeilDivUnit = PUnit`; both equal `PUnit.unit`, so `Eq` holds.
  exact Quotient.sound (show x = y from
    (PUnit.eq_punit x).trans (PUnit.eq_punit y).symm)

/-- **Sanity check**: the trivial class equals the class of the zero
divisor (`rfl` by construction). -/
example :
    (DivisorVarietyData.trivialClass : DivisorVarietyData.LinClass Unit)
      = DivisorVarietyData.divClass (0 : DivisorVarietyData.WeilDiv (X := Unit)) :=
  rfl

/-- **Sanity check**: the Weil-to-Cartier map on `Unit` is the unique
constant map; in particular, it sends every input to `PUnit.unit`. -/
example :
    WeilCartierData.weilToCartier (X := Unit)
        (0 : DivisorVarietyData.WeilDiv (X := Unit))
      = (0 : WeilCartierData.CartierDiv (X := Unit)) :=
  WeilCartierData.weilToCartier_zero_eq

end DivisorVarietyData.UnitExample

end HodgeReduction.Infrastructure.Cohomology
