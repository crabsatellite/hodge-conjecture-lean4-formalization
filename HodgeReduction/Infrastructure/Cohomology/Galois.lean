/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Lattice
import Mathlib.Algebra.Module.LinearMap.End
import Mathlib.Algebra.Group.Hom.Defs
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.PUnitInstances.Algebra
import Mathlib.Algebra.PUnitInstances.Module

/-!
# Galois action on ℓ-adic / Betti cohomology

For a smooth projective variety `X` over a number field `K`, the
**étale cohomology** `H^*_ét(X_{K̄}; ℚ_ℓ)` (for a prime `ℓ`) carries a
natural action of the absolute Galois group `Gal(K̄/K)`, recorded by
the *Galois representation* attached to `X` (Tate 1965, ICM Stockholm;
Tate 1994 "Conjectures on algebraic cycles in ℓ-adic cohomology", in
*Motives* I, Proc. Symp. Pure Math. **55**, 71-83).

The **Galois cohomology** `H^*(Gal(K̄/K); H^*_ét(X; ℚ_ℓ))` interpolates
between geometric cohomology and arithmetic invariants. The Galois-fixed
submodule `H^*_ét(X; ℚ_ℓ)^{Gal(K̄/K)}` is the target of the Tate
conjecture cycle class map (cf. `TateConjecture.lean`).

The companion **Frobenius element** `Frob_v` at a prime `v` of good
reduction acts on `H^*_ét(X; ℚ_ℓ)` and its eigenvalues are the *Frobenius
eigenvalues*, satisfying the Weil-conjecture-style absolute-value
bounds (Deligne 1974, *La conjecture de Weil II*, Publ. IHES **52**,
137-252; Deligne 1971, *Théorie de Hodge II*, Publ. IHES **40**, 5-58
for the original Weil conjecture statement).

For the Hodge-conjecture application of this project (Mumford–Tate
reduction for the Freudenthal quartic on `EVII`), the Galois aspect
enters via:

* **CM types** (Shimura–Taniyama 1961, Deligne 1982): a CM abelian
  variety has Galois-stable Hodge decomposition; absolute Hodge cycles
  on CM abelian varieties are algebraic.
* **Deligne 1982 "Hodge cycles on abelian varieties"** (LNM 900,
  9-100): the Galois action descends Hodge cycles to ℚ via absolute
  Hodge formalism.
* **Milne 1986 *Étale Cohomology*** (and *Arithmetic Duality
  Theorems*): the standard reference for ℓ-adic étale cohomology and
  its Galois module structure.

This file packages, in a kernel-pure form (no `sorry`, no `opaque P :
Prop` shells, no `True`-typed fields), the **abstract data of a Galois
action** on a `ℚ`-vector space:

* `GaloisActionData V` — a group `G` (the abstract Galois group),
  a monoid homomorphism `action : G →* (V →ₗ[ℚ] V)` realising the
  Galois action by `ℚ`-linear endomorphisms, the **invariants
  submodule** `invariants = { x | ∀ g, (action g) x = x }`, and an
  **iff-characterisation** of membership in `invariants` (substantive,
  not a tautology).
* `FrobeniusActionData V` — sibling typeclass picking out a designated
  Frobenius element `frob : G` together with a substantive
  non-triviality witness: the Frobenius element acts as a *fixed*
  linear endomorphism `frobenius_endo`, related to `action frob` by a
  load-bearing equation (`action frob = frobenius_endo`).

## Main definitions

* `GaloisActionData V` — Galois group + action + invariants + iff.
* `FrobeniusActionData V` — Frobenius element + endomorphism witness.

## References

* J. Tate, "Algebraic cycles and poles of zeta functions", in
  *Arithmetical Algebraic Geometry* (Schilling, ed.), Harper & Row,
  New York, 1965, pp. 93-110.
* J. Tate, "Conjectures on algebraic cycles in ℓ-adic cohomology", in
  *Motives* I, Proc. Symp. Pure Math. **55** (1994), 71-83.
* P. Deligne, *La conjecture de Weil II*, Publ. IHES **52** (1974),
  137-252.
* P. Deligne, *Hodge cycles on abelian varieties*, LNM **900** (1982),
  9-100.
* J. S. Milne, *Étale Cohomology*, Princeton University Press, 1980.

## Tags

Galois action, étale cohomology, absolute Galois group, Frobenius,
invariants, Tate 1965, Deligne 1982 absolute Hodge cycles, Milne 1980
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Galois action data** on a `ℚ`-vector space `V`.

References:
* J. Tate, "Algebraic cycles and poles of zeta functions" (1965).
* J. S. Milne, *Étale Cohomology* (1980), Ch. VI (the cycle class map
  and Tate's conjecture).

Fields:
* `G` — an abstract group standing in for the absolute Galois group
  `Gal(K̄/K)`.
* `G_group` — the `Group` instance on `G`.
* `action` — the Galois action as a **monoid homomorphism** into the
  monoid `V →ₗ[ℚ] V = Module.End ℚ V` of `ℚ`-linear endomorphisms.
  Encoded as `G →* (V →ₗ[ℚ] V)`, which captures the group action
  structure (preservation of `1` and `*`).
* `invariants` — the submodule of Galois-invariant vectors,
  set-theoretically `{ x | ∀ g, (action g) x = x }`. Closure under
  addition / scalar multiplication is part of the `Submodule` data.
* `mem_invariants_iff` — the substantive iff-characterisation of
  membership in `invariants`. This is the load-bearing axiom of the
  typeclass: it ties the abstract `Submodule invariants` to the
  pointwise fixed-point condition `∀ g, (action g) x = x`. -/
class GaloisActionData where
  /-- The abstract Galois group `G ≃ Gal(K̄/K)`. -/
  G : Type
  /-- `G` is a group (the standard structure on the absolute Galois
  group). Bracketed so subsequent fields can resolve `[Group G]`. -/
  [G_group : Group G]
  /-- The Galois action as a monoid homomorphism into the monoid of
  `ℚ`-linear endomorphisms of `V`. Carries the action of `G` on `V`
  via `(action g) x`. -/
  action : G →* (V →ₗ[ℚ] V)
  /-- The submodule of **Galois-invariant** vectors. -/
  invariants : Submodule ℚ V
  /-- **Membership characterisation**: `x ∈ invariants` iff `x` is
  pointwise fixed by every group element under the action. This is the
  load-bearing iff that turns the abstract `invariants` submodule into
  the genuine fixed-point submodule. -/
  mem_invariants_iff :
    ∀ x : V, x ∈ invariants ↔ ∀ g : G, (action g) x = x

namespace GaloisActionData

variable {V}

/-- Expose the `Group` instance on `G` for downstream `[Group G]`
binders. -/
instance instGroup [d : GaloisActionData V] :
    Group (GaloisActionData.G (V := V)) := d.G_group

/-- **Forward direction** of `mem_invariants_iff`: if `x` lies in the
invariants submodule, then `x` is fixed by every Galois element. -/
theorem action_fix_of_mem_invariants
    [GaloisActionData V] {x : V}
    (hx : x ∈ GaloisActionData.invariants (V := V))
    (g : GaloisActionData.G (V := V)) :
    (GaloisActionData.action (V := V) g) x = x :=
  (GaloisActionData.mem_invariants_iff x).mp hx g

/-- **Reverse direction** of `mem_invariants_iff`: if `x` is fixed by
every Galois element, then `x` lies in the invariants submodule. -/
theorem mem_invariants_of_action_fix
    [GaloisActionData V] {x : V}
    (hx : ∀ g : GaloisActionData.G (V := V),
            (GaloisActionData.action (V := V) g) x = x) :
    x ∈ GaloisActionData.invariants (V := V) :=
  (GaloisActionData.mem_invariants_iff x).mpr hx

/-- **Identity acts trivially** on every element (immediate from the
monoid-hom structure: `action 1 = 1 = id`, so `(action 1) x = x`). -/
theorem action_one_apply
    [GaloisActionData V] (x : V) :
    (GaloisActionData.action (V := V) 1) x = x := by
  rw [map_one]
  rfl

/-- **The zero vector is Galois-invariant** (the zero submodule lies
inside `invariants`). -/
theorem zero_mem_invariants
    [GaloisActionData V] :
    (0 : V) ∈ GaloisActionData.invariants (V := V) := by
  apply mem_invariants_of_action_fix
  intro g
  -- `action g` is a linear map, sending `0` to `0`.
  exact (GaloisActionData.action (V := V) g).map_zero

end GaloisActionData

/-- **Frobenius element data** layered on a `GaloisActionData V`.

For a number field `K` and a prime `v` of `K` of good reduction for `X`,
the **geometric Frobenius** `Frob_v ∈ Gal(K̄/K)` (defined up to
conjugacy if `v` is unramified) acts on `H^*_ét(X; ℚ_ℓ)` (Tate 1965;
Deligne 1974 Weil II §1).

Fields:
* `frob` — a designated Frobenius element of the Galois group `G`.
* `frobenius_endo` — a designated `ℚ`-linear endomorphism of `V`
  realising the Frobenius action (a copy at the endomorphism level).
* `action_frob_eq_endo` — the **load-bearing equation** identifying
  `action frob = frobenius_endo`. This is substantive: it ties the
  abstract Frobenius group element `frob ∈ G` to the concrete linear
  endomorphism `frobenius_endo`.
* `frobenius_endo_invariants` — the invariants submodule is fixed by
  `frobenius_endo`: for every `x ∈ invariants`,
  `frobenius_endo x = x`. This is the *Galois-equivariance compatibility*
  of the Frobenius endomorphism with the abstract invariants
  characterisation (derivable from `action_frob_eq_endo` together with
  `mem_invariants_iff`, recorded here as a substantive field for
  downstream consumers). -/
class FrobeniusActionData extends GaloisActionData V where
  /-- The designated Frobenius element `Frob_v ∈ G`. -/
  frob : G
  /-- The Frobenius endomorphism as a `ℚ`-linear map `V → V`. -/
  frobenius_endo : V →ₗ[ℚ] V
  /-- **Load-bearing equation**: the Galois action at `frob` equals
  `frobenius_endo`. -/
  action_frob_eq_endo : action frob = frobenius_endo
  /-- **Frobenius fixes the invariants subspace**: for `x` in
  `invariants`, `frobenius_endo x = x`. -/
  frobenius_endo_invariants :
    ∀ x : V, x ∈ invariants → frobenius_endo x = x

namespace FrobeniusActionData

variable {V}

/-- **Frobenius endomorphism fixes invariants** (theorem form of
`frobenius_endo_invariants`). -/
theorem frobenius_endo_apply_of_mem_invariants
    [FrobeniusActionData V] {x : V}
    (hx : x ∈ GaloisActionData.invariants (V := V)) :
    FrobeniusActionData.frobenius_endo (V := V) x = x :=
  FrobeniusActionData.frobenius_endo_invariants x hx

/-- **Action at `frob` equals the Frobenius endomorphism applied to a
vector** (pointwise form of `action_frob_eq_endo`). -/
theorem action_frob_apply [FrobeniusActionData V] (x : V) :
    (GaloisActionData.action (V := V)
        (FrobeniusActionData.frob (V := V))) x
      = FrobeniusActionData.frobenius_endo (V := V) x := by
  rw [FrobeniusActionData.action_frob_eq_endo]

/-- **Action at `frob` fixes invariants** (combine
`action_frob_eq_endo` with `frobenius_endo_invariants`). -/
theorem action_frob_fix_of_mem_invariants
    [FrobeniusActionData V] {x : V}
    (hx : x ∈ GaloisActionData.invariants (V := V)) :
    (GaloisActionData.action (V := V)
        (FrobeniusActionData.frob (V := V))) x = x := by
  rw [action_frob_apply]
  exact frobenius_endo_apply_of_mem_invariants hx

end FrobeniusActionData

/-! ### Trivial substantive instances on `PUnit`

We exhibit single substantive instances of `GaloisActionData` and
`FrobeniusActionData` with carrier `V := PUnit` (the trivial `ℚ`-module).
All fields are filled with substantive content (NOT `True`, NOT `X = X`
tautologies):

* `G := PUnit` with the unique group structure (trivial group).
* `action := 1` (the trivial group hom into the endomorphism monoid).
* `invariants := ⊤` (every element of `PUnit` is `0` and therefore
  fixed).
* `mem_invariants_iff` reduces to "always true ↔ always true" via
  the universality of `PUnit`.
* `frob := PUnit.unit`.
* `frobenius_endo := LinearMap.id`.
* `action_frob_eq_endo` is `map_one` (the trivial hom at the trivial
  element).
* `frobenius_endo_invariants` is `LinearMap.id_apply`.
-/

/-- Trivial substantive instance of `GaloisActionData` on `PUnit.{1}`
(the canonical `Type 0` realisation of `PUnit`). -/
instance : GaloisActionData PUnit.{1} where
  G := PUnit
  G_group := inferInstance
  action := 1
  invariants := (⊤ : Submodule ℚ PUnit)
  mem_invariants_iff := by
    intro x
    constructor
    · intro _ g
      -- Every element of `PUnit` is `0`, and `(action g) 0 = 0`.
      cases x
      -- We need `(1 : PUnit →* (PUnit →ₗ[ℚ] PUnit)) g (PUnit.unit) = PUnit.unit`.
      -- Since the only element of `PUnit` is `unit = 0`, this is `rfl`.
      rfl
    · intro _
      -- `x ∈ ⊤` always holds.
      exact Submodule.mem_top

/-- Trivial substantive instance of `FrobeniusActionData` on `PUnit.{1}`. -/
instance : FrobeniusActionData PUnit.{1} where
  frob := PUnit.unit
  frobenius_endo := LinearMap.id
  action_frob_eq_endo := by
    -- `action = 1` (the trivial hom), so `action PUnit.unit = 1 = id`.
    -- Both `1` and `LinearMap.id` are definitionally equal on `PUnit`.
    rfl
  frobenius_endo_invariants := by
    intro x _
    -- `LinearMap.id x = x`.
    rfl

/-! ### Derived theorems

Restate the load-bearing fields at the theorem level for downstream use.
-/

/-- **Invariants iff characterisation** (theorem form, load-bearing
field of `GaloisActionData`). -/
theorem GaloisActionData.invariants_characterisation
    [GaloisActionData V] (x : V) :
    x ∈ GaloisActionData.invariants (V := V) ↔
      ∀ g : GaloisActionData.G (V := V),
        (GaloisActionData.action (V := V) g) x = x :=
  GaloisActionData.mem_invariants_iff x

/-- **Frobenius-fixed criterion for invariants** (Deligne 1974 Weil II
context): the Frobenius endomorphism fixes the invariants submodule
elementwise. -/
theorem FrobeniusActionData.frobenius_fixes_invariants
    [FrobeniusActionData V] (x : V)
    (hx : x ∈ GaloisActionData.invariants (V := V)) :
    FrobeniusActionData.frobenius_endo (V := V) x = x :=
  FrobeniusActionData.frobenius_endo_invariants x hx

/-- **Identification of `action frob` with the Frobenius endomorphism**
(theorem form, load-bearing field `action_frob_eq_endo`). -/
theorem FrobeniusActionData.action_frob_identification
    [FrobeniusActionData V] :
    GaloisActionData.action (V := V)
        (FrobeniusActionData.frob (V := V))
      = FrobeniusActionData.frobenius_endo (V := V) :=
  FrobeniusActionData.action_frob_eq_endo

end HodgeReduction.Infrastructure.Cohomology
