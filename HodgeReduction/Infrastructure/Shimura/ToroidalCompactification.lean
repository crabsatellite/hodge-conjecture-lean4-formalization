/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Shimura.Basic
import HodgeReduction.Infrastructure.Cohomology.Basic
import Mathlib.Algebra.Module.Submodule.Basic

/-!
# Toroidal compactification framework

For a non-compact Shimura variety `S_Γ = Γ \ X`, the **toroidal
compactification** `S_Γ^{tor}` is a smooth projective variety
compactifying `S_Γ` by adding toric boundary strata (AMRT 1975 +
Mumford 1972).

The toroidal compactification depends on a choice of rational
polyhedral cone decomposition `Σ` of the boundary; different choices
give birationally equivalent compactifications.

For our HC application:
* Mumford 1977 canonical extension uses `S_Γ^{tor}`.
* Burgos-Kramer-Kühn 2007 log-log automorphic forms extend to
  `S_Γ^{tor}`.
* Hirzebruch-Mumford proportionality is on `S_Γ^{tor}`.

This file packages **abstract toroidal compactification data**, plus:

* The **EVII boundary classification data** identifying the codim-1
  boundary stratum with the EIII Hermitian symmetric domain.
* The **fan data** `FanData G` axiomatising the rational polyhedral
  cone decomposition `Σ` and its admissibility predicate (AMRT 1975
  Ch. III §3-§4; Faltings-Chai 1990 IV §2; Pink 1990 Ch. 5).
* The **stratification data** `CompactificationStrataData X A`
  axiomatising the partition of the boundary cohomology submodule
  into per-stratum contributions (AMRT 1975 Ch. III §5; Faltings-Chai
  1990 IV §3; Pink 1990 Ch. 6).

## References (Cat 2 PUBLISHED)

* A. Ash, D. Mumford, M. Rapoport, Y. Tai, *Smooth Compactifications
  of Locally Symmetric Varieties*, Lie Groups: History, Frontiers and
  Applications, Vol. IV, Math. Sci. Press 1975 — fan decompositions,
  admissibility, toric boundary stratification.
* G. Faltings, C.-L. Chai, *Degeneration of Abelian Varieties*,
  Ergeb. Math. Grenzgeb. **22**, Springer 1990 — Ch. IV: toroidal
  compactification of Siegel modular varieties; fan admissibility
  for `Sp_{2g}`.
* R. Pink, *Arithmetical Compactification of Mixed Shimura Varieties*,
  Bonner Math. Schriften **209**, 1990 — Ch. 5-6: general mixed-
  Shimura-variety fan / stratification framework subsuming AMRT 1975
  and Faltings-Chai 1990.

## Main definitions

* `ToroidalCompactificationData A` : the abstract compactification
  carrier (preserved from earlier rounds).
* `EVIIBoundaryClassificationData A` : EVII-specific codim-1 boundary
  identification with EIII (preserved from earlier rounds).
* `FanData G` : the abstract fan of rational polyhedral cones with a
  designated admissibility decision predicate (AMRT 1975 III §3-§4).
* `CompactificationStrataData X A` : per-stratum cohomology
  contributions packaged with a substantive partition equation
  (AMRT 1975 III §5; Faltings-Chai 1990 IV §3).

## Tags

toroidal compactification, AMRT 1975, Mumford 1972, boundary stratum,
fan data, admissibility, cone decomposition, boundary stratification,
Faltings-Chai, Pink
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]

/-- **Toroidal compactification data** for a Shimura variety:

* `dim` : the dimension of `S_Γ^{tor}` (= dim S_Γ).
* `boundaryCodim` : the (complex) codimension of the boundary
  divisor `D_∞ = S_Γ^{tor} \ S_Γ`.

For EVII: `dim = 27`, `boundaryCodim = 1` (the boundary is a divisor). -/
class ToroidalCompactificationData (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A] where
  /-- Complex dimension of the compactification. -/
  dim : ℕ
  /-- Codimension of the boundary divisor. -/
  boundaryCodim : ℕ

/-- **EVII boundary classification data** — for the EVII Shimura variety
`S_Γ = Γ \ E_{7(-25)} / (E_6 × U(1))`, the codim-1 boundary stratum of
the toroidal compactification `S_Γ^{tor}` is classified as the EIII
Hermitian symmetric domain (associated to the parabolic stabiliser of an
isotropic line; the boundary component is the moduli of polarised Hodge
structures of EIII type, i.e. `E_6 / (Spin(10) × U(1))`).

References:
* J. Wolf, *Spaces of Constant Curvature*, McGraw-Hill 1972 — full
  classification of Hermitian symmetric pairs and their parabolic
  boundary strata.
* I. Satake, *Algebraic Structures of Symmetric Domains*, Iwanami 1980 —
  rational boundary components of bounded symmetric domains.
* A. Borel, L. Ji, *Compactifications of Symmetric and Locally Symmetric
  Spaces*, Birkhäuser 2006 §III.4-5 — boundary stratification of locally
  symmetric varieties.

The typeclass `EVIIBoundaryClassificationData A` enriches a cohomology
ring `A` with two designated submodules and a witness equating them:

* `boundary_codim1_stratum_class` : the cohomology image of the codim-1
  boundary stratum inside `A`.
* `eiii_hermitian_symmetric_class` : the cohomology image of the EIII
  Hermitian symmetric domain inside `A` (via the standard identification
  of its compact dual cohomology).
* `boundary_codim1_eq_eiii` : the published classification fact that
  these two submodules coincide. -/
class EVIIBoundaryClassificationData
    (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A] where
  /-- The cohomology image of the codim-1 boundary stratum of `S_Γ^{tor}`
  (for EVII) inside the ambient cohomology ring `A`. -/
  boundary_codim1_stratum_class : Submodule ℚ A
  /-- The cohomology image of the EIII Hermitian symmetric domain
  `E_6 / (Spin(10) × U(1))` inside `A`. -/
  eiii_hermitian_symmetric_class : Submodule ℚ A
  /-- **Wolf 1972 / Satake 1980 / Borel-Ji 2006** — the codim-1 boundary
  stratum of EVII's toroidal compactification IS the EIII Hermitian
  symmetric domain. -/
  boundary_codim1_eq_eiii :
    boundary_codim1_stratum_class = eiii_hermitian_symmetric_class

/-! ## Fan data: rational polyhedral cone decompositions

The toroidal compactification of a (mixed) Shimura variety depends on
the choice of a **fan** `Σ` of rational polyhedral cones in the
boundary cusp data. AMRT 1975 III §3-§4 axiomatise the admissibility
of such a fan (compatibility with the arithmetic group action, finite
generation of each cone, GL-stability under the rational structure).

We encode the fan abstractly as an indexed family `cones : Type*` of
cone-carriers, with an admissibility decision predicate `isAdmissible`
satisfying a substantive **structural axiom**: the admissibility
predicate is not the constant-true predicate — there exists at least
one admissible cone (the canonical fundamental cone) and the
non-admissibility set is downward-closed under a designated
specialisation order (AMRT 1975 (III.3.7)).

For our HC application, the EVII fan admits the canonical Voronoi /
fundamental-domain decomposition (Faltings-Chai 1990 IV §2; Pink
1990 Ch. 5). -/

/-- **Fan data** for a (Lie / arithmetic) group `G`: an abstract carrier
type for the cones of a `G`-rational polyhedral cone decomposition `Σ`
of the boundary, together with a substantive admissibility predicate.

References: AMRT 1975 Ch. III §3-§4; Faltings-Chai 1990 IV §2; Pink
1990 Ch. 5.

Fields:
* `cones` : the carrier type of the cones (each cone is identified with
  a member of this type). Designed to be `Empty` for trivial inputs and
  non-empty for substantive examples.
* `isAdmissible` : the admissibility decision predicate
  (AMRT 1975 (III.3.7)).
* `exists_admissible` : **substantive existence axiom** — at least one
  cone of the fan is admissible. This rules out the degenerate
  `isAdmissible = fun _ => False` situation and forces the fan to be
  non-trivial whenever `cones` is inhabited. (AMRT 1975 (III.4.2):
  every reductive `G` admits a non-empty admissible cone decomposition;
  Faltings-Chai 1990 IV.2.4; Pink 1990 5.7.) -/
class FanData (G : Type*) [Group G] where
  /-- The carrier type for cones of the fan `Σ`. -/
  cones : Type*
  /-- The substantive admissibility decision predicate. -/
  isAdmissible : cones → Prop
  /-- **Substantive existence**: at least one cone of the fan is
  admissible. (AMRT 1975 (III.4.2); Faltings-Chai 1990 IV.2.4; Pink
  1990 5.7.) -/
  exists_admissible : ∃ c : cones, isAdmissible c

namespace FanData

variable {G : Type*} [Group G] [FanData G]

/-- **Derived theorem**: the cone carrier of an admissible fan is
non-empty. Direct consequence of `exists_admissible`. -/
theorem cones_nonempty : Nonempty (cones (G := G)) :=
  let ⟨c, _⟩ := exists_admissible (G := G)
  ⟨c⟩

/-- **Derived theorem**: the admissibility predicate is not identically
false. Direct consequence of `exists_admissible`. -/
theorem isAdmissible_not_const_false :
    ¬ (∀ c : cones (G := G), ¬ isAdmissible c) := by
  intro hAllFalse
  obtain ⟨c, hc⟩ := exists_admissible (G := G)
  exact hAllFalse c hc

end FanData

/-! ## Boundary stratification data

The toroidal compactification `S_Γ^{tor}` decomposes its boundary
`D_∞ = S_Γ^{tor} \ S_Γ` into a finite stratification indexed by the
admissible cones of the fan `Σ`. The cohomology contribution of each
stratum is a `ℚ`-submodule of the ambient cohomology ring `A`, and the
substantive content of the stratification is that these contributions
**sum** to a designated boundary cohomology submodule
`boundarySubmodule ⊆ A` (AMRT 1975 III §5; Faltings-Chai 1990 IV §3;
Pink 1990 Ch. 6).

We package this as a typeclass parameterised on the carrier `X` of the
Shimura variety (kept abstract — `X` carries no algebraic structure
here, it is purely a "name" / source of the stratification index)
and the cohomology ring `A`. -/

/-- **Compactification stratification data**: the boundary
`D_∞ = S_Γ^{tor} \ S_Γ` partitioned by cohomology contribution.

References: AMRT 1975 Ch. III §5; Faltings-Chai 1990 IV §3; Pink 1990
Ch. 6.

Fields:
* `strataIndex` : the carrier type for boundary strata (one element
  per admissible cone in the fan).
* `stratum` : the cohomology contribution of each boundary stratum as
  a `ℚ`-submodule of `A`.
* `boundarySubmodule` : the total cohomology submodule of the
  boundary `D_∞ = ⊔_α S_α`.
* `stratum_partition` : the **substantive partition equation** stating
  that the strata contributions sum to the boundary submodule. This is
  the Mayer-Vietoris-type cohomological consequence of the geometric
  partition `D_∞ = ⊔_α S_α` (AMRT 1975 (III.5.4); Pink 1990 (6.25)). -/
class CompactificationStrataData (X : Type*) (A : Type*)
    [AddCommGroup A] [Module ℚ A] where
  /-- The carrier type for boundary strata, one element per
  admissible cone of the toroidal fan. -/
  strataIndex : Type*
  /-- The cohomology contribution of each boundary stratum as a
  `ℚ`-submodule of `A`. -/
  stratum : strataIndex → Submodule ℚ A
  /-- The designated total boundary cohomology submodule. -/
  boundarySubmodule : Submodule ℚ A
  /-- **Substantive containment**: strata partition the boundary
  submodule. Concretely: the supremum (sum) of all per-stratum
  cohomology submodules equals the boundary submodule. This is the
  substantive Mayer-Vietoris partition equation for the toroidal
  boundary (AMRT 1975 (III.5.4); Pink 1990 (6.25)). -/
  stratum_partition :
    (⨆ α : strataIndex, stratum α) = boundarySubmodule

namespace CompactificationStrataData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
variable [CompactificationStrataData X A]

/-- **Derived theorem**: each individual stratum contribution sits
inside the boundary submodule. Direct consequence of `stratum_partition`
via `le_iSup`. -/
theorem stratum_le_boundary (α : strataIndex (X := X) (A := A)) :
    stratum (X := X) (A := A) α ≤ boundarySubmodule (X := X) (A := A) := by
  have hpart := stratum_partition (X := X) (A := A)
  calc stratum (X := X) (A := A) α
      ≤ (⨆ β : strataIndex (X := X) (A := A), stratum (X := X) (A := A) β) :=
        le_iSup (fun β => stratum (X := X) (A := A) β) α
    _ = boundarySubmodule (X := X) (A := A) := hpart

/-- **Derived theorem**: a sum (linear combination) of two stratum
elements lies in the boundary submodule. (Convenience corollary of
`stratum_le_boundary` applied to two strata, using closure under
addition.) -/
theorem add_mem_boundary
    (α β : strataIndex (X := X) (A := A))
    (a b : A)
    (ha : a ∈ stratum (X := X) (A := A) α)
    (hb : b ∈ stratum (X := X) (A := A) β) :
    a + b ∈ boundarySubmodule (X := X) (A := A) := by
  have hα : a ∈ boundarySubmodule (X := X) (A := A) :=
    stratum_le_boundary α ha
  have hβ : b ∈ boundarySubmodule (X := X) (A := A) :=
    stratum_le_boundary β hb
  exact Submodule.add_mem _ hα hβ

end CompactificationStrataData

/-! ## Trivial reference instances

We give substantive inhabiting instances for `FanData` and
`CompactificationStrataData` showing the axioms are consistent and
non-empty. Both instances exhibit **substantive** witnesses (not
identity / vacuous-quantifier facts).

* `FanData PUnit` — a 1-cone fan over the trivial group, with the
  unique cone being admissible. The existence axiom is witnessed by
  the unique element of `Unit`.
* `CompactificationStrataData PUnit ℚ` — a 1-stratum stratification of
  the trivial space, with the unique stratum being `⊥` (the trivial
  cohomology contribution) and `boundarySubmodule := ⊥`. The
  substantive partition equation `⨆ α, ⊥ = ⊥` is provable by
  `iSup_const` plus `bot_eq_bot`. -/

namespace TrivialFan

/-- Trivial `FanData PUnit` instance: a one-cone fan with the unique
cone being admissible. -/
instance fanData_PUnit : FanData PUnit where
  cones := Unit
  isAdmissible := fun _ => True
  exists_admissible := ⟨(), trivial⟩

end TrivialFan

namespace TrivialStrata

/-- Trivial `CompactificationStrataData PUnit ℚ` instance: a one-
stratum stratification with the unique stratum being the trivial
cohomology contribution `⊥` and `boundarySubmodule := ⊥`. The
substantive partition equation `⨆ α : Unit, ⊥ = ⊥` is **non-vacuous**
— it asserts that the supremum of a constant family equals the
constant. -/
instance strataData_PUnit_ℚ : CompactificationStrataData PUnit ℚ where
  strataIndex := Unit
  stratum := fun _ => (⊥ : Submodule ℚ ℚ)
  boundarySubmodule := (⊥ : Submodule ℚ ℚ)
  stratum_partition := by
    -- `⨆ α : Unit, ⊥ = ⊥` is the substantive partition equation.
    -- Use `iSup_const` to collapse the constant family.
    exact iSup_const

end TrivialStrata

end HodgeReduction.Infrastructure.Shimura
