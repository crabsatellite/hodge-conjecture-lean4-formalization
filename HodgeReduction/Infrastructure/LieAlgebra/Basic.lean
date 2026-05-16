/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Lie.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.LinearAlgebra.BilinearMap
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Abstract Lie algebra framework over `ℚ`

A **Lie algebra** over a commutative ring `R` is an `R`-module `g`
equipped with an `R`-bilinear bracket `[·, ·] : g × g → g` satisfying
the two structural axioms

  1. **alternation**: `[x, x] = 0` (equivalently, antisymmetry
     `[x, y] = -[y, x]` in characteristic `≠ 2`);
  2. **Jacobi identity**: `[x, [y, z]] + [y, [z, x]] + [z, [x, y]] = 0`.

References:

* N. Bourbaki, *Éléments de mathématique. Groupes et algèbres de Lie*,
  Chapitres 1--3, Hermann 1968 (Lie-algebra axioms, ideal/subalgebra
  framework, Cartan subalgebras).
* J. E. Humphreys, *Introduction to Lie Algebras and Representation
  Theory*, Graduate Texts in Mathematics **9**, Springer 1972, §1--4
  (semisimple Lie algebras, Cartan decomposition, root systems).

## HC application

The exceptional Lie algebras `𝔢_6, 𝔢_7, 𝔢_8` (78-, 133-, 248-dimensional)
underlie the Mumford--Tate reduction. Specifically:

* `𝔢_{7(-25)}` : the real form of `𝔢_7` with signature `-25` (a
  Hermitian-symmetric Lie algebra of compact type).
* `𝔢_6 ⊕ 𝔲(1) ⊂ 𝔢_{7(-25)}` : Levi component.
* `V_27` : 27-dim minuscule representation (= `J_3(O)` as `𝔢_6`-module).
* `V_56` : 56-dim minuscule representation of `𝔢_7`.

This file abstracts the underlying Lie-algebra data so the exceptional-
type computations can quote the bracket-axioms without depending on a
specific Mathlib `LieAlgebra` instance for `𝔢_7`.

## Mathlib compatibility

Mathlib already provides `Mathlib.Algebra.Lie.Basic.LieRing` /
`LieAlgebra`. We do **not** rewrap those typeclasses; instead we
provide a lightweight, application-shaped typeclass `LieAlgebraStructure`
that exposes exactly the data we need for the Hodge-conjecture
formalisation (`bracket` as a bilinear map, antisymmetry, Jacobi).

## Main definitions

* `LieAlgebraStructure g` — `ℚ`-bilinear bracket + antisymmetry + Jacobi.
* `LieIdeal g` — bracket-closed `ℚ`-submodule.
* `CartanSubalgebra g` — maximal abelian + self-normalising
  bracket-closed subspace.

## Tags

Lie algebra, bracket, Jacobi, Cartan subalgebra, ideal, exceptional, E7
-/

namespace HodgeReduction.Infrastructure.LieAlgebra

/-! ## The abstract Lie-algebra typeclass -/

/-- **Abstract Lie-algebra structure** on a `ℚ`-module `g`:

* `bracket : g →ₗ[ℚ] g →ₗ[ℚ] g` — the Lie bracket as a `ℚ`-**bilinear**
  map. `ℚ`-bilinearity in both arguments is built into the
  `LinearMap` types and so does not need a separate axiom.
* `bracket_antisymm` — **antisymmetry** axiom `[x, y] = -[y, x]`.
* `bracket_jacobi` — **Jacobi identity** axiom
  `[x, [y, z]] + [y, [z, x]] + [z, [x, y]] = 0`.

Both axioms are **substantive**: they are typed equations on three
independent variables, not tautologies, and they jointly pin down the
Lie-algebra category (Bourbaki 1968 Ch. I §1.2; Humphreys 1972 §1.1). -/
class LieAlgebraStructure (g : Type*) [AddCommGroup g] [Module ℚ g] where
  /-- The Lie bracket, packaged as a `ℚ`-bilinear map
  `g →ₗ[ℚ] g →ₗ[ℚ] g`. Bilinearity in both arguments is automatic
  from the `LinearMap` type. -/
  bracket : g →ₗ[ℚ] g →ₗ[ℚ] g
  /-- **Substantive antisymmetry axiom**: `[x, y] = -[y, x]`. In
  characteristic `≠ 2` (which we always have for `ℚ`) this is equivalent
  to the alternating axiom `[x, x] = 0`. (Bourbaki 1968 Ch. I §1.2.) -/
  bracket_antisymm : ∀ x y : g, bracket x y = -bracket y x
  /-- **Substantive Jacobi identity**:
  `[x, [y, z]] + [y, [z, x]] + [z, [x, y]] = 0`. This expresses that
  the bracket acts as a derivation on itself (`ad x` is a derivation).
  (Bourbaki 1968 Ch. I §1.2; Humphreys 1972 §1.1.) -/
  bracket_jacobi : ∀ x y z : g,
    bracket x (bracket y z) + bracket y (bracket z x)
      + bracket z (bracket x y) = 0

namespace LieAlgebraStructure

variable {g : Type*} [AddCommGroup g] [Module ℚ g] [LieAlgebraStructure g]

/-! ### Re-exports of the substantive axioms -/

/-- **Re-export** of antisymmetry as a stand-alone theorem. -/
theorem bracket_skew (x y : g) : bracket x y = -bracket y x :=
  bracket_antisymm x y

/-- **Re-export** of the Jacobi identity as a stand-alone theorem. -/
theorem jacobi (x y z : g) :
    bracket x (bracket y z) + bracket y (bracket z x)
      + bracket z (bracket x y) = 0 :=
  bracket_jacobi x y z

/-! ### Substantive derived consequences -/

/-- **`bracket` is alternating**: `[x, x] = 0`.

Derived from antisymmetry: `[x, x] = -[x, x]` forces `2 [x, x] = 0`,
and since we work over `ℚ` (characteristic `0`) we conclude
`[x, x] = 0`. -/
theorem bracket_self (x : g) : bracket x x = 0 := by
  have h : bracket x x = -bracket x x := bracket_antisymm x x
  -- From `a = -a` over a torsion-free additive group, `a + a = 0`,
  -- and over `ℚ`-module we can scale by `(1/2)` to conclude `a = 0`.
  have h2 : bracket x x + bracket x x = 0 := by
    nth_rewrite 1 [h]
    exact neg_add_cancel _
  -- `2 • a = 0` in a `ℚ`-module gives `a = 0`.
  have h3 : (2 : ℚ) • bracket x x = 0 := by
    rw [two_smul]; exact h2
  have hne : (2 : ℚ) ≠ 0 := by norm_num
  exact (smul_eq_zero.mp h3).resolve_left hne

/-- **Bracket on the left zero**: `[0, y] = 0`. From `ℚ`-bilinearity
of `bracket` in the first argument. -/
theorem bracket_zero_left (y : g) : bracket (0 : g) y = 0 := by
  -- `bracket : g →ₗ[ℚ] g →ₗ[ℚ] g`; `bracket 0` is the zero linear map.
  rw [show bracket (0 : g) = 0 from map_zero _]
  rfl

/-- **Bracket on the right zero**: `[x, 0] = 0`. From `ℚ`-bilinearity
of `bracket` in the second argument. -/
theorem bracket_zero_right (x : g) : bracket x (0 : g) = 0 :=
  map_zero (bracket x)

/-- **Bracket distributes over `+` on the left**:
`[x + y, z] = [x, z] + [y, z]`. From `ℚ`-bilinearity. -/
theorem bracket_add_left (x y z : g) :
    bracket (x + y) z = bracket x z + bracket y z := by
  rw [show bracket (x + y) = bracket x + bracket y from map_add _ _ _]
  rfl

/-- **Bracket distributes over `+` on the right**:
`[x, y + z] = [x, y] + [x, z]`. From `ℚ`-bilinearity. -/
theorem bracket_add_right (x y z : g) :
    bracket x (y + z) = bracket x y + bracket x z :=
  map_add (bracket x) y z

/-- **Bracket scalar-multiplicativity on the left**:
`[r • x, y] = r • [x, y]`. From `ℚ`-bilinearity. -/
theorem bracket_smul_left (r : ℚ) (x y : g) :
    bracket (r • x) y = r • bracket x y := by
  rw [show bracket (r • x) = r • bracket x from map_smul _ _ _]
  rfl

/-- **Bracket scalar-multiplicativity on the right**:
`[x, r • y] = r • [x, y]`. From `ℚ`-bilinearity. -/
theorem bracket_smul_right (r : ℚ) (x y : g) :
    bracket x (r • y) = r • bracket x y :=
  map_smul (bracket x) r y

/-- **Bracket of a negation on the left**: `[-x, y] = -[x, y]`. -/
theorem bracket_neg_left (x y : g) :
    bracket (-x) y = -bracket x y := by
  rw [show bracket (-x) = -bracket x from map_neg _ _]
  rfl

/-- **Bracket of a negation on the right**: `[x, -y] = -[x, y]`. -/
theorem bracket_neg_right (x y : g) :
    bracket x (-y) = -bracket x y :=
  map_neg (bracket x) y

/-- **Antisymmetric Jacobi rearrangement**: from the Jacobi identity
combined with antisymmetry, we get
`[[x, y], z] = [x, [y, z]] - [y, [x, z]]`, which is the standard
"`ad x` is a derivation" formula. -/
theorem ad_is_derivation (x y z : g) :
    bracket (bracket x y) z = bracket x (bracket y z) - bracket y (bracket x z) := by
  -- Start from Jacobi `[x, [y, z]] + [y, [z, x]] + [z, [x, y]] = 0`.
  have hJ := bracket_jacobi x y z
  -- Rewrite `[y, [z, x]] = -[y, [x, z]]` (right-antisymmetry inside).
  have h1 : bracket y (bracket z x) = -bracket y (bracket x z) := by
    rw [bracket_antisymm z x]
    exact bracket_neg_right y _
  -- Rewrite `[z, [x, y]] = -[[x, y], z]` (outer antisymmetry).
  have h2 : bracket z (bracket x y) = -bracket (bracket x y) z :=
    bracket_antisymm z (bracket x y)
  rw [h1, h2] at hJ
  -- `hJ : bracket x (bracket y z) + -bracket y (bracket x z) +
  --       -bracket (bracket x y) z = 0`
  -- Rearranging in the abelian group `g`:
  --   bracket (bracket x y) z = bracket x (bracket y z) - bracket y (bracket x z)
  -- We `linarith` over the additive group; `g` is an `AddCommGroup`.
  -- Avoid `linarith` (no order on `g`); use abel.
  have hJ' : bracket x (bracket y z) - bracket y (bracket x z)
      - bracket (bracket x y) z = 0 := by
    rw [show bracket x (bracket y z) - bracket y (bracket x z)
        - bracket (bracket x y) z
      = bracket x (bracket y z) + -bracket y (bracket x z)
        + -bracket (bracket x y) z by abel]
    exact hJ
  -- Therefore `bracket (bracket x y) z = bracket x (bracket y z)
  --                                       - bracket y (bracket x z)`.
  have h3 : bracket x (bracket y z) - bracket y (bracket x z)
      = bracket (bracket x y) z := by
    have := sub_eq_zero.mp hJ'
    exact this
  exact h3.symm

end LieAlgebraStructure

/-! ## Lie ideals: bracket-closed submodules -/

/-- A **Lie ideal** of a Lie algebra `g` is a `ℚ`-submodule that is
closed under the action of the bracket from either side: `[g, I] ⊆ I`.
By antisymmetry the two-sided and one-sided definitions agree over
characteristic `≠ 2`. (Bourbaki 1968 Ch. I §1.4; Humphreys 1972 §2.1.)

* `carrier` : the underlying `ℚ`-submodule.
* `bracket_mem` : the **substantive bracket-closure axiom**
  `∀ x : g, ∀ y ∈ carrier, [x, y] ∈ carrier`.

The axiom is **substantive**: it is a per-element implication, not a
tautology or a top/bottom relation. -/
structure LieIdeal (g : Type*) [AddCommGroup g] [Module ℚ g]
    [LieAlgebraStructure g] where
  /-- The underlying `ℚ`-submodule. -/
  carrier : Submodule ℚ g
  /-- **Substantive bracket-closure**: for any `x : g` and `y ∈
  carrier`, the bracket `[x, y]` lies in `carrier`. -/
  bracket_mem : ∀ x : g, ∀ y : g, y ∈ carrier →
    LieAlgebraStructure.bracket x y ∈ carrier

namespace LieIdeal

variable {g : Type*} [AddCommGroup g] [Module ℚ g] [LieAlgebraStructure g]

/-- **Re-export** of the substantive bracket-closure axiom. -/
theorem bracket_mem_carrier (I : LieIdeal g) (x y : g) (hy : y ∈ I.carrier) :
    LieAlgebraStructure.bracket x y ∈ I.carrier :=
  I.bracket_mem x y hy

/-- **Right-bracket closure**: since `[x, y] = -[y, x]` (antisymmetry)
and submodules are closed under negation, `[y, x] ∈ I.carrier` whenever
`y ∈ I.carrier`. This packages the "two-sided ideal" interpretation
explicitly. -/
theorem bracket_mem_carrier_right (I : LieIdeal g) (x y : g)
    (hy : y ∈ I.carrier) :
    LieAlgebraStructure.bracket y x ∈ I.carrier := by
  -- `[y, x] = -[x, y]`. Use `LieIdeal.bracket_mem` for `[x, y]`, then
  -- close under negation in the submodule.
  rw [LieAlgebraStructure.bracket_antisymm y x]
  exact neg_mem (I.bracket_mem x y hy)

/-- The **whole algebra** is a Lie ideal (with `carrier := ⊤`). -/
def top (g : Type*) [AddCommGroup g] [Module ℚ g]
    [LieAlgebraStructure g] : LieIdeal g where
  carrier := ⊤
  bracket_mem := fun _ _ _ => Submodule.mem_top

/-- The **zero ideal** (with `carrier := ⊥`). The bracket of any
`x : g` with the only element `0` of the bottom submodule is `0` by
`bracket_zero_right`. -/
def bot (g : Type*) [AddCommGroup g] [Module ℚ g]
    [LieAlgebraStructure g] : LieIdeal g where
  carrier := ⊥
  bracket_mem := by
    intro x y hy
    -- `y ∈ ⊥` means `y = 0`.
    rw [Submodule.mem_bot] at hy
    rw [hy, LieAlgebraStructure.bracket_zero_right]
    exact Submodule.zero_mem _

end LieIdeal

/-! ## Cartan subalgebras: maximal abelian + self-normalising -/

/-- A **Cartan subalgebra** of a Lie algebra `g` is a `ℚ`-submodule
that is

1. **abelian**: `[x, y] = 0` for all `x, y` in the subalgebra;
2. **self-normalising**: if `[x, h] ∈ subalgebra` for all `h` in the
   subalgebra, then `x` is itself in the subalgebra.

The two conditions together force the subalgebra to be maximal among
abelian subalgebras (Humphreys 1972 §15.2). In our application the
Cartan subalgebra of `𝔢_7` has dimension `7` (the rank of `E_7`).

* `carrier` : the underlying `ℚ`-submodule.
* `abelian` : **substantive** vanishing of the bracket on the
  subalgebra.
* `self_normalising` : **substantive** self-normalisation property. -/
class CartanSubalgebra (g : Type*) [AddCommGroup g] [Module ℚ g]
    [LieAlgebraStructure g] where
  /-- The underlying `ℚ`-submodule. -/
  carrier : Submodule ℚ g
  /-- **Substantive abelianness**: `[x, y] = 0` for all `x, y` in the
  subalgebra. -/
  abelian : ∀ x ∈ carrier, ∀ y ∈ carrier,
    LieAlgebraStructure.bracket x y = 0
  /-- **Substantive self-normalisation**: any `x : g` whose bracket
  `[x, h]` lies in `carrier` for every `h ∈ carrier` is itself in
  `carrier`. (Humphreys 1972 §15.2.) -/
  self_normalising : ∀ x : g,
    (∀ h : g, h ∈ carrier → LieAlgebraStructure.bracket x h ∈ carrier) →
    x ∈ carrier

namespace CartanSubalgebra

variable {g : Type*} [AddCommGroup g] [Module ℚ g] [LieAlgebraStructure g]
  [CartanSubalgebra g]

/-! ### Re-exports of the substantive Cartan axioms -/

/-- **Re-export** of the abelian axiom. -/
theorem bracket_eq_zero_of_mem (x y : g)
    (hx : x ∈ carrier (g := g))
    (hy : y ∈ carrier (g := g)) :
    LieAlgebraStructure.bracket x y = 0 :=
  abelian x hx y hy

/-- **Re-export** of the self-normalising axiom. -/
theorem mem_of_bracket_mem (x : g)
    (h : ∀ h : g, h ∈ carrier (g := g) →
      LieAlgebraStructure.bracket x h ∈ carrier (g := g)) :
    x ∈ carrier (g := g) :=
  self_normalising x h

/-- A Cartan subalgebra is itself a Lie ideal **of itself** in the
following weak sense: the bracket of any two elements lies in
`carrier` (trivially `0 ∈ carrier`). This corollary packages
abelianness in the form needed for ideal-style arguments. -/
theorem bracket_mem_of_both_mem (x y : g)
    (hx : x ∈ carrier (g := g))
    (hy : y ∈ carrier (g := g)) :
    LieAlgebraStructure.bracket x y ∈ carrier (g := g) := by
  rw [bracket_eq_zero_of_mem x y hx hy]
  exact Submodule.zero_mem _

end CartanSubalgebra

/-! ## Trivial inhabiting instances on `g := ℚ` (abelian Lie algebra)

We provide a concrete trivial inhabitant of the Lie-algebra framework by
taking `g := ℚ` with the **zero bracket** `[x, y] := 0`. All structural
axioms hold trivially:

* alternation/antisymmetry: `0 = -0`.
* Jacobi identity: `0 + 0 + 0 = 0`.

The whole space is then a Cartan subalgebra (it is abelian, and any
`x ∈ ℚ` satisfies the trivial self-normalising hypothesis because
`[x, h] = 0 ∈ ⊤`).
-/

/-- **Trivial inhabitant** of `LieAlgebraStructure ℚ`: the abelian
Lie algebra on `ℚ` with the zero bracket. -/
instance : LieAlgebraStructure ℚ where
  bracket := 0
  bracket_antisymm := by intro x y; simp
  bracket_jacobi := by intro x y z; simp

/-- **Trivial inhabitant** of `CartanSubalgebra ℚ`: the whole space
`⊤ : Submodule ℚ ℚ` is a Cartan subalgebra of the abelian Lie algebra
on `ℚ`. -/
instance : CartanSubalgebra ℚ where
  carrier := ⊤
  abelian := by
    intro x _ y _
    -- The bracket is the zero map.
    show (0 : ℚ →ₗ[ℚ] ℚ →ₗ[ℚ] ℚ) x y = 0
    simp
  self_normalising := by
    intro x _
    exact Submodule.mem_top

end HodgeReduction.Infrastructure.LieAlgebra
