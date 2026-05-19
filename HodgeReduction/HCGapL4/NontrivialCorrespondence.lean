/-
# HC Gap L4 — first cross-object MT correspondence prototype (R205).

R204 inhabited `MTCorrespondencePackageAt` with the **identity**
self-correspondence on the R203 elliptic-curve internal model — a
trivial witness that establishes the type is non-empty. R205 builds
the **first cross-object** witness: a correspondence package between
the R201 point and the R203 elliptic curve at codimension 0, with
genuinely distinct source/target variety triples.

## What R205 does

* Constructs a `HodgeStructureMorphism` at degree 0 from
  `varietyCohomology_point.H 0` to `VarietyCohomologyData_ellipticCurve.H 0`.
  Both carriers are definitionally `ℚ` (same `cohomologyType_*` reducing
  to ℚ at `k = 0`) and both share the same PureHodgeStructure instance
  (`TrivialWeight.pureHodgeStructure_ℚ_0`). The morphism's underlying
  ℚ-linear map is `fun x => x` (explicitly constructed via
  `LinearMap.mk`, NOT via `LinearMap.id` — the source/target Lean
  types are formally distinct even though definitionally equal).
* Constructs a ℚ-linear map between the two algClasses subtypes via
  `⟨z.val, Submodule.mem_top⟩` — honest subtype rewriting between
  `↥⊤` and `↥⊤` in two different ambient spaces.
* Closes `MTCorrespondencePackageAt_point_to_ellipticCurve_codim0`.
* Chains it with `TrivialPoint.VarietyHCAt_point 0` via
  `varietyHCAt_of_correspondence` to recover
  `VarietyHCAt_ellipticCurve_codim0` (already proved in R203, but now
  via the genuine cross-object transfer route).
* Documents the audit of `varietyHCAt_of_correspondence`: direction,
  strength, and the "any Hodge morphism could be misused" risk.

## What R205 does NOT do

* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT certify the point ↔ elliptic-curve correspondence comes
  from an actual algebraic cycle on `pt × E` (the geometric content
  would be the diagonal class of the inclusion `pt ↪ E`; here we
  build only the Lean linear-algebraic data, not the cycle).
* It does NOT exercise the package at codimension `p > 0`. At codim 1
  the point's `H^2` is `PUnit` while E's `H^2` is `ℚ`; this would be a
  proper "rank-mismatch" prototype, deferred to R206+.
* It does NOT cover the V_56 → CM-Abelian E_7 case (the headline gap).

All R205 declarations are kernel-pure: `{propext, Classical.choice, Quot.sound}`
or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.HodgeMorphism

namespace HodgeReduction
namespace HCGapL4
namespace NontrivialCorrespondence

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2

/-! ## Section 0: scoped typeclass instances

The dependent expressions `varietyCohomology_point.H k` and
`VarietyCohomologyData_ellipticCurve.H k` need explicit typeclass
declarations for the type elaborator to find `AddCommGroup` /
`Module ℚ` / `PureHodgeStructure ... k` instances on them. We
declare these once at the file level (parameterized by `k`) so the
subsequent defs/proofs inherit them globally — including at
expressions like `H (2 * 0)` that arise inside `MTCorrespondencePackageAt`. -/

noncomputable instance acg_point_Hk (k : ℕ) :
    AddCommGroup (TrivialPoint.varietyCohomology_point.H k) :=
  TrivialPoint.varietyCohomology_point.addCommGroup k

noncomputable instance mod_point_Hk (k : ℕ) :
    Module ℚ (TrivialPoint.varietyCohomology_point.H k) :=
  TrivialPoint.varietyCohomology_point.module k

noncomputable instance phs_point_Hk (k : ℕ) :
    PureHodgeStructure (TrivialPoint.varietyCohomology_point.H k) k :=
  TrivialPoint.varietyCohomology_point.hodgeStructure k

noncomputable instance acg_ellipticCurve_Hk (k : ℕ) :
    AddCommGroup (EllipticCurve.VarietyCohomologyData_ellipticCurve.H k) :=
  EllipticCurve.VarietyCohomologyData_ellipticCurve.addCommGroup k

noncomputable instance mod_ellipticCurve_Hk (k : ℕ) :
    Module ℚ (EllipticCurve.VarietyCohomologyData_ellipticCurve.H k) :=
  EllipticCurve.VarietyCohomologyData_ellipticCurve.module k

noncomputable instance phs_ellipticCurve_Hk (k : ℕ) :
    PureHodgeStructure (EllipticCurve.VarietyCohomologyData_ellipticCurve.H k) k :=
  EllipticCurve.VarietyCohomologyData_ellipticCurve.hodgeStructure k

/-! ## Section 1: underlying ℚ-linear map `H^0(pt) → H^0(E)`

Both carriers reduce to `ℚ`; the natural transfer is `fun x => x`.
Constructed explicitly via `LinearMap.mk`, NOT `LinearMap.id`
(which would presuppose source and target Lean types are literally
identical). -/

/-- ℚ-linear underlying map: `H^0(point) → H^0(elliptic curve)`.
Both carriers reduce to `ℚ`; the map is "same scalar". -/
def underlyingLinearMap_point_to_ellipticCurve_at_H0 :
    TrivialPoint.varietyCohomology_point.H 0 →ₗ[ℚ]
    EllipticCurve.VarietyCohomologyData_ellipticCurve.H 0 where
  toFun (x : ℚ) := (x : ℚ)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-! ## Section 2: Hodge structure morphism at H^0

Both bundles place the same Hodge structure at degree 0 (the trivial
`TrivialWeight.pureHodgeStructure_ℚ_0` with single piece `⟨0,_⟩ = ⊤`).
The morphism's `map_piece` obligation reduces to "image of ⊤ ⊆ ⊤". -/

/-- **R205 part 1**: Hodge structure morphism `H^0(pt) → H^0(E)` at
weight 0. The target piece is `TrivialWeight.piece_ℚ_w0 ⟨0,_⟩ = ⊤`
(only `Fin 1` index), so any submodule's image is `≤ ⊤`. -/
def phi_point_to_ellipticCurve_at_H0 :
    HodgeStructureMorphism
      (TrivialPoint.varietyCohomology_point.H 0)
      (EllipticCurve.VarietyCohomologyData_ellipticCurve.H 0)
      0 where
  toLinearMap := underlyingLinearMap_point_to_ellipticCurve_at_H0
  map_piece := fun p => by
    fin_cases p
    show Submodule.map _ _ ≤ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact le_top

/-! ## Section 3: ℚ-linear map on algebraic classes

Both `algClasses 0` are `⊤ : Submodule ℚ ℚ` (in different ambient
spaces with the same underlying carrier `ℚ`). Subtype lifting via
`⟨z.val, Submodule.mem_top⟩` is the honest construction. -/

/-- **R205 part 2**: ℚ-linear map between the algClasses subtypes at
codim 0: `↥(algClasses_point 0) → ↥(algClasses_ellipticCurve 0)`. -/
def psi_point_to_ellipticCurve_at_codim0 :
    ↥(TrivialPoint.algClasses_point.algClasses 0) →ₗ[ℚ]
    ↥(EllipticCurve.AlgebraicClassesData_ellipticCurve.algClasses 0) where
  toFun z := ⟨z.val, Submodule.mem_top⟩
  map_add' _ _ := by ext; rfl
  map_smul' _ _ := by ext; rfl

/-! ## Section 4: the full MT correspondence package -/

/-- **R205 milestone**: kernel-pure witness for `MTCorrespondencePackageAt`
from the R201 point to the R203 elliptic curve at codimension 0.
First **cross-object** (non-identity) witness in the library.

The four components:
* `φ`: `phi_point_to_ellipticCurve_at_H0` — Hodge morphism with
  underlying `fun x => x : ℚ → ℚ`.
* `ψ`: `psi_point_to_ellipticCurve_at_codim0` — subtype lifting on
  `↥⊤ → ↥⊤`.
* Commuting square: both sides reduce to `z.val ∈ ℚ`; closed by `rfl`.
* Hodge class surjectivity: `hodgeClasses 0 (E) = ⊤ ≤ Submodule.map φ
  (hodgeClasses 0 (pt) = ⊤)`. For `x ∈ ⊤` on the E side, take preimage
  = `x` on the pt side; then `φ x = x`. -/
theorem MTCorrespondencePackageAt_point_to_ellipticCurve_codim0 :
    MTCorrespondencePackageAt
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 := by
  refine ⟨phi_point_to_ellipticCurve_at_H0,
          psi_point_to_ellipticCurve_at_codim0, ?_, ?_⟩
  · -- Commuting square: subtype (ψ z) = φ (subtype z) = z.val
    intro z
    rfl
  · -- Hodge class surjectivity: hodgeClasses (E_H 0) ≤ Submodule.map φ (hodgeClasses (pt_H 0))
    intro x _
    refine ⟨x, ?_, ?_⟩
    · exact Submodule.mem_top
    · rfl

/-! ## Section 5: HC transfer via the cross-object correspondence -/

/-- **R205 transfer demo**: HC at codim 0 for the elliptic curve,
derived from HC at codim 0 for the point via the R205 cross-object
correspondence. Not new information about HC, but the **first
non-circular run** of `varietyHCAt_of_correspondence` (R204's
self-identity case was circular). -/
theorem VarietyHCAt_ellipticCurve_codim0_via_point_correspondence :
    VarietyHCAt
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 :=
  varietyHCAt_of_correspondence
    MTCorrespondencePackageAt_point_to_ellipticCurve_codim0
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 6: audit of `varietyHCAt_of_correspondence`

Theorem reference: `HodgeReduction.Infrastructure.HodgeStructure.varietyHCAt_of_correspondence`
([VarietyCohomology.lean:381](../Infrastructure/HodgeStructure/VarietyCohomology.lean#L381)).

Statement:
```
theorem varietyHCAt_of_correspondence
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p : ℕ}
    (h_pkg : MTCorrespondencePackageAt X_src X_tgt A_src A_tgt p)
    (h_HC_src : VarietyHCAt X_src A_src p) :
    VarietyHCAt X_tgt A_tgt p
```

### Direction
`src → tgt`. Consumes `HC(src at p)` and produces `HC(tgt at p)`.
The source must already satisfy HC at codim `p`; the target inherits
HC at codim `p` through the correspondence.

### Strength
The theorem is a **type-level transfer principle**, not an
algebraicity certificate. It requires only:
1. A Hodge morphism `φ` (preserves bigrading, pure linear-algebraic
   condition).
2. A ℚ-linear map `ψ` on algClasses subtypes (no cycle-induction
   required).
3. A commuting square between `φ` (on cohomology) and `ψ` (on
   algClasses) via the subtype inclusions.
4. Hodge-class surjectivity: every Hodge class on `tgt` lifts to a
   Hodge class on `src` via `φ`.

### What it does NOT require
* `φ` need not be induced by an algebraic cycle (the
  L4_G_HodgeMorphism_To_AlgebraicCorrespondence gap from R204).
* `ψ` need not be the "cohomological action" of an actual
  correspondence cycle `Z ⊂ X_src × X_tgt`. It is any ℚ-linear map
  on algClasses-as-submodules satisfying the square.

### "Any Hodge morphism misused as algebraic correspondence" risk
**Bounded by the algClasses TYPE.** Even if `φ` is a non-cycle Hodge
morphism, the LinearMap `ψ` has codomain `↥(A_tgt.algClasses p)` —
a submodule that IS (by the AlgebraicClassesData semantics) the
cycle class map image on the target. So any `z ∈ A_src.algClasses p`
is mapped by `ψ` into `A_tgt.algClasses p`, i.e., into the actual
algebraic-class submodule on the target. The HC conclusion on `tgt`
is therefore honest at the algClasses-submodule level — no falsely-
"algebraic" Hodge class can be conjured.

The remaining audit point is the **construction** of `ψ`: nothing
in `MTCorrespondencePackageAt` enforces that `ψ` is the
cohomological action of a real algebraic cycle. A user could (in
principle) construct any compatible LinearMap and claim the package
is satisfied. The HC conclusion would still be honest given honest
source-side AlgebraicClassesData, but the **package's geometric
meaning** (which cycle induces it?) is not certified by the type.

For the headline use case: paper §6 supplies the V_56-induced
correspondence with `ψ` being the actual cohomological action on
algClasses; the Lean theorem accepts this without checking. R205's
cross-object package between point and E is similarly **not**
certified to come from an actual cycle on `pt × E` (which would be
the diagonal of the inclusion); only the linear-algebraic data is
exhibited.

### Verdict
`varietyHCAt_of_correspondence` is the **correct shape** for the
abstract MT reduction argument. Its safety relies on the
AlgebraicClassesData submodules being honestly defined as cycle
class map images. The "Hodge morphism = correspondence" identification
is NOT introduced; the theorem only requires Hodge-morphism +
algClasses-LinearMap data, with algebraicity provided structurally
by the AlgebraicClassesData typing. -/

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_PointToElliptic_NotCycleInduced**: the R205 cross-object
correspondence package is constructed at the linear-algebraic level;
it is NOT certified to come from an algebraic cycle on `pt × E`. The
geometric content would be the diagonal class of the closed immersion
`pt ↪ E` (one rational point), but this cycle-induction is not
exhibited here. -/
abbrev L4_G_PointToElliptic_NotCycleInduced : Prop := True

/-- **L4-G_HCTransfer_AcceptsNonAlgebraicData**: `varietyHCAt_of_correspondence`
accepts any (φ, ψ, square, surj) without checking either φ or ψ comes
from an algebraic cycle. The conclusion `HC(tgt)` is still honest at
the algClasses-submodule level (since ψ's codomain enforces
algebraicity by typing), but the package's geometric meaning is not
certified. -/
abbrev L4_G_HCTransfer_AcceptsNonAlgebraicData : Prop := True

/-- **L4-G_CrossObjectCorrespondence_AtHigherCodim**: extending the
R205 cross-object prototype to codim 1 (and beyond) introduces
rank-mismatch issues: `H^2(pt) = PUnit` vs `H^2(E) = ℚ`, so the
Hodge morphism cannot be the "same scalar" — it must be the zero
map, or take values in `⊥`. Deferred to R206+. -/
abbrev L4_G_CrossObjectCorrespondence_AtHigherCodim : Prop := True

/-- **L4-G_CrossObject_PerformanceOnAllCodims**: a complete
cross-object correspondence package quantified over **all** codims
between two non-equivalent variety triples; needs the rank-mismatch
issue resolved at each codim, plus a consistent global structure. -/
abbrev L4_G_CrossObject_PerformanceOnAllCodims : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R205 non-closure (1/3)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. The R205 cross-object
package is between point and elliptic curve, NOT between an E_7
Shimura variety and a CM abelian variety. -/
theorem R205_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R205 non-closure (2/3)**: does NOT certify the point ↔ elliptic
correspondence comes from a real algebraic cycle. The Lean linear-
algebraic data is exhibited; the cycle-induction is left as the
`L4_G_PointToElliptic_NotCycleInduced` open marker. -/
theorem R205_does_not_certify_algebraicity_of_correspondence : True := trivial

/-- **R205 non-closure (3/3)**: only codim 0 is covered. Codim 1 and
above require resolving the rank-mismatch between point and elliptic
curve (`H^2(pt) = PUnit` vs `H^2(E) = ℚ`), tracked as
`L4_G_CrossObjectCorrespondence_AtHigherCodim`. -/
theorem R205_only_codim0_covered : True := trivial

end NontrivialCorrespondence
end HCGapL4
end HodgeReduction
