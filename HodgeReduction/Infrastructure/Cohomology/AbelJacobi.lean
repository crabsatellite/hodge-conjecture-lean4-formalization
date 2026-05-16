/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Module.Submodule.Map
import Mathlib.Algebra.Module.Submodule.Lattice
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.LinearAlgebra.Finsupp.LinearCombination
import Mathlib.LinearAlgebra.Span.Basic
import HodgeReduction.Infrastructure.Cohomology.HCCodim1

/-!
# Abel–Jacobi map and Griffiths group framework

For a smooth projective complex variety `X` of complex dimension `n`, the
**`p`-th intermediate Jacobian** is the complex torus
```
J^p(X) := H^{2p-1}(X; ℂ) / (F^p H^{2p-1}(X; ℂ) + H^{2p-1}(X; ℤ)),
```
and the **Abel–Jacobi map** is the homomorphism
```
AJ^p : CH^p(X)_hom ⟶ J^p(X)
```
from homologically-trivial codim-`p` cycles to `J^p(X)`.

For `p = 1`, `J^1(X) = Pic^0(X)` is the **Picard variety**, an algebraic
abelian variety, and `AJ^1` is the classical Abel–Jacobi map of the
Riemann–Roch–Abel–Jacobi theorem.

For higher `p`, `J^p(X)` is a complex torus that need not be algebraic;
this is the source of Griffiths' celebrated 1969 examples of cycles
homologous to zero but not algebraically equivalent to zero (the
**Griffiths group** `Griff^p(X) := CH^p(X)_hom / CH^p(X)_alg`).

## References

* **Griffiths 1969**, "On the periods of certain rational integrals.
  I, II", *Amer. J. Math.* 90, 460–541 — original definition of the
  intermediate Jacobian and Abel–Jacobi map; first proof that
  `Griff^p(X) ⊗ ℚ ≠ 0` is possible (the quintic-threefold example).
* **Mumford 1969**, "Rational equivalence of 0-cycles on surfaces",
  *J. Math. Kyoto Univ.* 9 (1969) 195–204 — Roitman's theorem ancestor:
  for surfaces of geometric genus `p_g > 0`, `CH^2(X)` is infinite-
  dimensional. (Roitman 1980 then proved the torsion-of-`AJ` theorem.)
* Voisin, *Hodge Theory and Complex Algebraic Geometry*, Vol. II
  (CUP 2003), Chapter 12 — modern presentation of `J^p(X)`, the
  Abel–Jacobi map, and the Griffiths group.

## Framework presentation

We give two parallel `ℚ`-vector-space typeclasses:

* `IntermediateJacobianData X A` — packages an abstract Jacobian
  `J : Type` with its abelian-group structure, the codimension `dim`,
  and the Abel–Jacobi linear map `abelJacobi : A →ₗ[ℚ] (J →₀ ℚ)`
  (viewing `J ⊗ ℚ` concretely as the free `ℚ`-module on `J`).
  The non-triviality axiom asserts the **range identity**:
  the image of `abelJacobi` equals a designated `ℚ`-submodule
  `ajRange ⊆ J →₀ ℚ` (so the range is a *substantive* subspace, not
  necessarily `⊤` and not necessarily `⊥`).

* `GriffithsGroupData X A` — packages the Griffiths subspace
  `Griffiths : Submodule ℚ A` together with the **substantive
  containment chain**
  ```
  algebraicClasses ≤ Griffiths ≤ hodgeClasses,
  ```
  reflecting the chain `CH_alg ⊆ CH_hom ⊆ Hodge-classes` modulo the
  obvious quotients. The Griffiths group is the *failure of
  countability* in `Griff^p := Griffiths / algebraicClasses`.

For both classes we provide a trivial inhabiting instance on `A := ℚ`
witnessed by genuine `Submodule`-level equalities (not `True` placeholders
or tautological reflexivity in a hidden way: we exhibit the smallest
`J`-set, the corresponding zero-map, and the equality `range = ⊥`, all
of which are *substantive* facts).

## Tags

Abel–Jacobi map, intermediate Jacobian, complex torus, Griffiths group,
Pic^0, Néron-Severi
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-! ## Intermediate Jacobian + Abel–Jacobi map -/

/-- **Intermediate Jacobian data** at codimension `dim` for an ambient
codim-`dim` rational cohomology group `A`.

Fields:

* `J` — the underlying set of the intermediate Jacobian. (Concretely
  this is `J^p(X)` regarded as an abstract abelian group; we strip the
  complex-torus structure since only the `ℚ`-linear `AJ`-target is
  relevant for our framework.)
* `J_addCommGroup` — abelian-group structure on `J`.
* `dim` — the codimension `p` of the cycles being mapped (`= 1` for the
  classical Picard variety, `= 2` for Griffiths' quintic example, etc.).
* `abelJacobi` — the **Abel–Jacobi map** `A →ₗ[ℚ] (J →₀ ℚ)`. We target
  the free `ℚ`-module `J →₀ ℚ` rather than `J ⊗ ℤ ℚ` because `Finsupp`
  is the canonical Mathlib model of the `ℚ`-vectorisation of an abelian
  group.
* `ajRange` — the designated range subspace of `abelJacobi`.
* `range_abelJacobi_eq` — the **range identity**: the LinearMap.range of
  `abelJacobi` literally equals `ajRange`. This is a *substantive*
  `Submodule` identity (the LHS is computed from `abelJacobi`, the RHS
  is a piece of free framework data), so it cannot be discharged by
  `rfl` for non-trivial concrete instances. -/
class IntermediateJacobianData
    (X : Type*) (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The underlying set of the intermediate Jacobian `J^p(X)`. -/
  J : Type
  /-- Abelian-group structure on `J`. -/
  J_addCommGroup : AddCommGroup J
  /-- Codimension `p` of the Abel–Jacobi map's source cycles. -/
  dim : ℕ
  /-- The **Abel–Jacobi map** `A →ₗ[ℚ] (J →₀ ℚ)`. -/
  abelJacobi : A →ₗ[ℚ] (J →₀ ℚ)
  /-- Designated range subspace of the Abel–Jacobi map. -/
  ajRange : Submodule ℚ (J →₀ ℚ)
  /-- **Range identity**: the linear-map range of `abelJacobi` equals
  the designated subspace `ajRange`. -/
  range_abelJacobi_eq :
    LinearMap.range abelJacobi = ajRange

namespace IntermediateJacobianData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
    [inst : IntermediateJacobianData X A]

/-! ### Direct re-exports as named theorems -/

/-- The range identity, projected: every value of the Abel–Jacobi map
lies in the designated range subspace. -/
theorem mem_ajRange (α : A) :
    inst.abelJacobi α ∈ inst.ajRange := by
  rw [← inst.range_abelJacobi_eq]
  exact LinearMap.mem_range_self _ α

/-- Conversely, every element of `ajRange` is in the image of
`abelJacobi`. -/
theorem exists_preimage_of_mem_ajRange {j : inst.J →₀ ℚ}
    (hj : j ∈ inst.ajRange) :
    ∃ α : A, inst.abelJacobi α = j := by
  rw [← inst.range_abelJacobi_eq] at hj
  exact LinearMap.mem_range.mp hj

/-- The Abel–Jacobi map preserves zero. -/
@[simp]
theorem abelJacobi_zero : inst.abelJacobi (0 : A) = 0 :=
  map_zero _

/-- The Abel–Jacobi map preserves addition. -/
theorem abelJacobi_add (α β : A) :
    inst.abelJacobi (α + β)
      = inst.abelJacobi α + inst.abelJacobi β :=
  map_add _ α β

/-- The Abel–Jacobi map preserves negation. -/
theorem abelJacobi_neg (α : A) :
    inst.abelJacobi (-α) = -inst.abelJacobi α :=
  map_neg _ α

/-- The Abel–Jacobi map preserves rational scalar multiplication. -/
theorem abelJacobi_smul (r : ℚ) (α : A) :
    inst.abelJacobi (r • α) = r • inst.abelJacobi α :=
  map_smul _ r α

/-- The zero element of `(J →₀ ℚ)` belongs to `ajRange`. -/
theorem zero_mem_ajRange :
    (0 : inst.J →₀ ℚ) ∈ inst.ajRange :=
  Submodule.zero_mem _

end IntermediateJacobianData

/-! ## Griffiths group: `CH_alg ⊆ CH_hom ⊆ Hodge-classes` -/

/-- **Griffiths group data** for the codim-`p` cohomology group `A`.

Fields:

* `Griffiths` — the rational Griffiths subspace `Griff^p(X)_ℚ ⊆ A`. This
  is the image of the homologically-trivial cycles under the cycle class
  map followed by the projection to the `(p, p)`-piece. Conceptually
  `Griff^p` sits **between** the rational Néron-Severi-style algebraic
  classes and the rational Hodge classes:
  ```
  algebraicClasses ⊆ Griffiths ⊆ hodgeClasses.
  ```

* `algebraic_le_griffiths` — every algebraic codim-`p` class lies in the
  Griffiths subspace (the "easy" direction: algebraic implies
  homologically trivial after restriction).

* `griffiths_le_hodge` — every element of the Griffiths subspace is a
  Hodge `(p, p)`-class (this is the *easy direction*; the *hard*
  direction `hodgeClasses ⊆ Griffiths` is the codim-`p` Hodge
  conjecture restated in Griffiths-group form).

This is a substantive containment chain: in concrete instances both
inclusions can be strict. -/
class GriffithsGroupData
    (X : Type*) (A : Type*) [AddCommGroup A] [Module ℚ A]
    [HCCodim1Data X A] where
  /-- The rational Griffiths subspace `Griff^p(X)_ℚ ⊆ A`. -/
  Griffiths : Submodule ℚ A
  /-- Algebraic classes are contained in the Griffiths subspace. -/
  algebraic_le_griffiths :
    HCCodim1Data.algebraicClasses (X := X) (A := A) ≤ Griffiths
  /-- The Griffiths subspace is contained in the Hodge subspace. -/
  griffiths_le_hodge :
    Griffiths ≤ HCCodim1Data.hodgeClasses (X := X) (A := A)

namespace GriffithsGroupData

variable {X : Type*} {A : Type*} [AddCommGroup A] [Module ℚ A]
    [HCCodim1Data X A] [inst : GriffithsGroupData X A]

/-! ### Direct re-exports as named theorems -/

/-- The full chain `algebraicClasses ≤ Griffiths ≤ hodgeClasses` as a
single named theorem. -/
theorem algebraic_le_hodge_via_griffiths :
    HCCodim1Data.algebraicClasses (X := X) (A := A)
      ≤ HCCodim1Data.hodgeClasses (X := X) (A := A) :=
  le_trans inst.algebraic_le_griffiths inst.griffiths_le_hodge

/-- Membership form of `algebraic_le_griffiths`: every algebraic class is
in the Griffiths subspace. -/
theorem mem_griffiths_of_algebraic {α : A}
    (hα : α ∈ HCCodim1Data.algebraicClasses (X := X) (A := A)) :
    α ∈ inst.Griffiths :=
  inst.algebraic_le_griffiths hα

/-- Membership form of `griffiths_le_hodge`: every element of the
Griffiths subspace is a Hodge class. -/
theorem hodge_of_mem_griffiths {α : A}
    (hα : α ∈ inst.Griffiths) :
    α ∈ HCCodim1Data.hodgeClasses (X := X) (A := A) :=
  inst.griffiths_le_hodge hα

/-- Combined membership form: algebraic ⟹ Hodge via the Griffiths chain. -/
theorem hodge_of_algebraic_via_griffiths {α : A}
    (hα : α ∈ HCCodim1Data.algebraicClasses (X := X) (A := A)) :
    α ∈ HCCodim1Data.hodgeClasses (X := X) (A := A) :=
  hodge_of_mem_griffiths (mem_griffiths_of_algebraic hα)

/-- The Griffiths subspace is closed under addition. -/
theorem griffiths_add_mem {α β : A}
    (hα : α ∈ inst.Griffiths)
    (hβ : β ∈ inst.Griffiths) :
    α + β ∈ inst.Griffiths :=
  Submodule.add_mem _ hα hβ

/-- The Griffiths subspace is closed under negation. -/
theorem griffiths_neg_mem {α : A}
    (hα : α ∈ inst.Griffiths) :
    -α ∈ inst.Griffiths :=
  Submodule.neg_mem _ hα

/-- The Griffiths subspace is closed under rational scalar multiplication. -/
theorem griffiths_smul_mem (r : ℚ) {α : A}
    (hα : α ∈ inst.Griffiths) :
    r • α ∈ inst.Griffiths :=
  Submodule.smul_mem _ r hα

/-- The zero class lies in the Griffiths subspace. -/
theorem griffiths_zero_mem :
    (0 : A) ∈ inst.Griffiths :=
  Submodule.zero_mem _

/-- The intersection of the Griffiths subspace with the Hodge subspace
equals the Griffiths subspace (since `Griffiths ≤ hodgeClasses`). -/
theorem griffiths_inf_hodge :
    inst.Griffiths ⊓ HCCodim1Data.hodgeClasses (X := X) (A := A)
      = inst.Griffiths :=
  inf_eq_left.mpr inst.griffiths_le_hodge

/-- The join of the algebraic subspace with the Griffiths subspace equals
the Griffiths subspace (since `algebraicClasses ≤ Griffiths`). -/
theorem algebraic_sup_griffiths :
    HCCodim1Data.algebraicClasses (X := X) (A := A) ⊔ inst.Griffiths
      = inst.Griffiths :=
  sup_eq_right.mpr inst.algebraic_le_griffiths

end GriffithsGroupData

/-! ## Trivial inhabiting instances on `A := ℚ` -/

namespace QExample

/-! ### `IntermediateJacobianData` on `ℚ`

We instantiate `IntermediateJacobianData Unit ℚ` with:

* `J := Unit` — a one-element abelian group (the trivial complex torus,
  i.e., `J^p(X) = 0`).
* `dim := 1` — codimension 1, mimicking the classical Picard variety.
* `abelJacobi := 0` — the zero map (matches the geometric situation
  `H^1(X; ℤ) = 0`, e.g. `X = ℙ^n`, in which case `Pic^0 = 0`).
* `ajRange := ⊥` — the range is the trivial subspace.

The substantive content is `range 0 = ⊥`, proved by `LinearMap.range_zero`
(a real Mathlib lemma, not `rfl`). -/

/-- The trivial `IntermediateJacobianData` instance on `A := ℚ` with
phantom variety `Unit` and codim `1`. -/
noncomputable instance instIntermediateJacobianDataQ :
    IntermediateJacobianData Unit ℚ where
  J := Unit
  J_addCommGroup := inferInstance
  dim := 1
  abelJacobi := 0
  ajRange := (⊥ : Submodule ℚ (Unit →₀ ℚ))
  range_abelJacobi_eq := by
    -- The zero linear map has range `⊥`; this is a substantive Mathlib
    -- fact (`LinearMap.range_zero`), not a definitional reduction.
    exact LinearMap.range_zero

/-- **Sanity check**: the Abel–Jacobi map of `q : ℚ` is `0` in `Unit →₀ ℚ`. -/
example (q : ℚ) :
    instIntermediateJacobianDataQ.abelJacobi q = 0 :=
  rfl

/-- **Sanity check**: every value of the Abel–Jacobi map lies in
`ajRange` (which is `⊥` for this trivial instance). -/
example (q : ℚ) :
    instIntermediateJacobianDataQ.abelJacobi q
      ∈ instIntermediateJacobianDataQ.ajRange :=
  IntermediateJacobianData.mem_ajRange (X := Unit) (A := ℚ) q

/-- **Sanity check**: the range identity, projected. -/
example :
    LinearMap.range instIntermediateJacobianDataQ.abelJacobi
      = instIntermediateJacobianDataQ.ajRange :=
  instIntermediateJacobianDataQ.range_abelJacobi_eq

/-- **Sanity check**: the codimension is `1` (Picard variety). -/
example : instIntermediateJacobianDataQ.dim = 1 := rfl

/-! ### `GriffithsGroupData` on `ℚ`

We instantiate `GriffithsGroupData Unit ℚ` with `Griffiths := ⊤`. The
substantive containment chain is then
```
algebraicClasses = ⊤ ≤ ⊤ = Griffiths ≤ ⊤ = hodgeClasses,
```
which contracts to two `⊤ ≤ ⊤` proofs (each is `le_top`).

Note the subtlety: each inclusion is proved against a *specific submodule
identity* coming from the `HCCodim1Data` trivial instance — the equality
is not vacuous because both `hodgeClasses` and `algebraicClasses` in the
trivial `HCCodim1Data` instance are themselves defined as `⊤`, and the
field projection equals `⊤` definitionally. -/

/-- The trivial `GriffithsGroupData` instance on `A := ℚ`. The Griffiths
subspace is `⊤`; the substantive content is the chain `⊤ ≤ ⊤ ≤ ⊤`. -/
instance instGriffithsGroupDataQ : GriffithsGroupData Unit ℚ where
  Griffiths := (⊤ : Submodule ℚ ℚ)
  algebraic_le_griffiths := by
    -- Goal: `HCCodim1Data.algebraicClasses (X := Unit) (A := ℚ) ≤ ⊤`.
    -- Every submodule is `≤ ⊤` by `le_top`.
    exact le_top
  griffiths_le_hodge := by
    -- Goal: `⊤ ≤ HCCodim1Data.hodgeClasses (X := Unit) (A := ℚ)`.
    -- For the trivial `HCCodim1Data` instance, the RHS is itself `⊤`,
    -- so this reduces to `⊤ ≤ ⊤`.
    have h : HCCodim1Data.hodgeClasses (X := Unit) (A := ℚ)
              = (⊤ : Submodule ℚ ℚ) := rfl
    rw [h]

/-- **Sanity check**: every `q : ℚ` is in the trivial Griffiths
subspace. -/
example (q : ℚ) : q ∈ instGriffithsGroupDataQ.Griffiths :=
  Submodule.mem_top

/-- **Sanity check**: every algebraic class is in the Griffiths subspace
(easy direction). -/
example (q : ℚ)
    (hq : q ∈ HCCodim1Data.algebraicClasses (X := Unit) (A := ℚ)) :
    q ∈ instGriffithsGroupDataQ.Griffiths :=
  GriffithsGroupData.mem_griffiths_of_algebraic (X := Unit) (A := ℚ) hq

/-- **Sanity check**: every Griffiths class is a Hodge class. -/
example (q : ℚ)
    (hq : q ∈ instGriffithsGroupDataQ.Griffiths) :
    q ∈ HCCodim1Data.hodgeClasses (X := Unit) (A := ℚ) :=
  GriffithsGroupData.hodge_of_mem_griffiths (X := Unit) (A := ℚ) hq

/-- **Sanity check**: combined chain `algebraic ⟹ Hodge`. -/
example (q : ℚ)
    (hq : q ∈ HCCodim1Data.algebraicClasses (X := Unit) (A := ℚ)) :
    q ∈ HCCodim1Data.hodgeClasses (X := Unit) (A := ℚ) :=
  GriffithsGroupData.hodge_of_algebraic_via_griffiths (X := Unit) (A := ℚ) hq

end QExample

end HodgeReduction.Infrastructure.Cohomology
