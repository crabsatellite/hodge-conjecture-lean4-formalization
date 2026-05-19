/-
# HC Gap L4 — Hodge morphism / correspondence prototype (R204).

First L4-interface file. The `HodgeStructureMorphism` *type* already
exists in `Infrastructure/HodgeStructure/Basic.lean:631` (with `id_HSM`
+ `comp` + `map_hodgeClasses` + `map_filt`). R204 does NOT redefine
it; instead R204:

1. Extends the morphism API with two kernel-pure helpers
   (`zero_HSM`, `smul_HSM`) needed for any future construction
   building Hodge morphisms from rational combinations.
2. Instantiates the morphism type on the R203 elliptic-curve internal
   `H^1` carrier `(ℚ × ℚ)` at weight 1 (identity / diagonal scaling /
   zero), giving the first kernel-pure non-toy `HodgeStructureMorphism`
   witnesses in the library.
3. Closes a kernel-pure witness for the existential predicate
   `MTCorrespondencePackageAt` between the R203 elliptic-curve
   internal model and itself, using the identity correspondence
   at every codimension. This demonstrates the package-type is
   **inhabitable kernel-purely**, NOT that the headline
   `canonicalE7ShimuraTor.mtCorrespondencePackage` is closed.

**What R204 does NOT do**:
* It does NOT close `mtCorrespondencePackage` for the canonical E_7
  Shimura variety. The identity correspondence on an elliptic curve
  is trivially an MT correspondence; the substantive headline content
  is the V_56-induced correspondence between an E_7 Shimura variety
  and a CM abelian variety (paper §6).
* It does NOT equate "Hodge morphism" with "algebraic correspondence".
  A Hodge morphism is a ℚ-linear map preserving the bigrading; an
  algebraic correspondence is a cycle class on the product variety
  inducing such a map. The converse (every Hodge morphism is
  cycle-induced) IS the Hodge Conjecture for the product variety.
  The four disclosure markers at the end of the file name this gap
  and the related residual L4 bridges.

All R204 declarations are kernel-pure: `{propext, Classical.choice, Quot.sound}`.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.EllipticCurve

namespace HodgeReduction
namespace HCGapL4
namespace HodgeMorphism

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: extend the `HodgeStructureMorphism` API

The base type lives at `Infrastructure/HodgeStructure/Basic.lean:631`
with `id_HSM` + `comp` + `map_hodgeClasses` + `map_filt` + `map_piece`
already proven kernel-pure. R204 adds two helpers needed for any
future ℚ-linear combination construction of Hodge morphisms.
-/

section ExtendedAPI

variable {V W : Type*} [AddCommGroup V] [AddCommGroup W]
  [Module ℚ V] [Module ℚ W] {n : ℕ}
  [PureHodgeStructure V n] [PureHodgeStructure W n]

/-- **R204**: the zero Hodge structure morphism `V → W`. Sends every
vector to `0 ∈ W`; trivially preserves each Hodge piece since `0`
lies in every submodule. -/
def zero_HSM : HodgeStructureMorphism V W n where
  toLinearMap := 0
  map_piece := fun p => by
    intro x ⟨y, _, hy⟩
    have hx : x = 0 := by
      rw [← hy]; rfl
    rw [hx]
    exact Submodule.zero_mem _

/-- **R204**: scalar multiplication of a Hodge morphism by a rational.
Each Hodge piece is a ℚ-submodule (closed under scalar multiplication),
so the rescaled map still maps `piece p → piece p`. -/
def smul_HSM (c : ℚ) (f : HodgeStructureMorphism V W n) :
    HodgeStructureMorphism V W n where
  toLinearMap := c • f.toLinearMap
  map_piece := fun p => by
    intro x ⟨y, hy, hyx⟩
    rw [← hyx]
    have hfy : f.toLinearMap y ∈ PureHodgeStructure.piece (V := W) p :=
      f.map_piece p ⟨y, hy, rfl⟩
    show (c • f.toLinearMap) y ∈ PureHodgeStructure.piece (V := W) p
    rw [LinearMap.smul_apply]
    exact Submodule.smul_mem _ c hfy

end ExtendedAPI

/-! ## Section 2: example Hodge morphisms on R203 elliptic-curve `H^1`

The R203 internal model gives `H^1(E) = ℚ × ℚ` with weight-1 pure
Hodge structure splitting into `H^{1,0} = Submodule.prod ⊤ ⊥` and
`H^{0,1} = Submodule.prod ⊥ ⊤`. Section 2 instantiates the morphism
type on this carrier, giving the first kernel-pure non-toy
`HodgeStructureMorphism` witnesses in the library.
-/

open HodgeReduction.HCGapL2.EllipticCurve

/-- Identity Hodge morphism on `H^1(E_internal) = ℚ × ℚ` at weight 1.
Specialisation of `HodgeStructureMorphism.id_HSM`. -/
def id_H1_ellipticCurve :
    HodgeStructureMorphism (ℚ × ℚ) (ℚ × ℚ) 1 :=
  HodgeStructureMorphism.id_HSM

/-- Diagonal scaling Hodge morphism on `H^1(E_internal)` by a rational
`c`. The map `v ↦ c • v` preserves each Hodge piece since `H^{1,0}` and
`H^{0,1}` are ℚ-submodules (closed under scalar multiplication). -/
def diagonal_scaling_H1_ellipticCurve (c : ℚ) :
    HodgeStructureMorphism (ℚ × ℚ) (ℚ × ℚ) 1 :=
  smul_HSM c id_H1_ellipticCurve

/-- Zero Hodge morphism on `H^1(E_internal)`. Sends every cohomology
class to `0`. -/
def zero_H1_ellipticCurve :
    HodgeStructureMorphism (ℚ × ℚ) (ℚ × ℚ) 1 :=
  zero_HSM

/-! ## Section 3: identity MT correspondence on the R203 elliptic curve

The kernel-pure inhabitation of `MTCorrespondencePackageAt`
between `(VarietyCohomologyData_ellipticCurve,
AlgebraicClassesData_ellipticCurve)` and itself, using the identity
at every level. This demonstrates the package-type is inhabitable
kernel-purely on the R203 carrier — NOT a closure of
`L4_G3_MT_Correspondence_E7_To_CMAbelian`.
-/

/-- **R204 milestone**: kernel-pure witness for `MTCorrespondencePackageAt`
between the R203 elliptic-curve internal model and itself at every
codimension. Uses identity Hodge morphism + identity algebraic-class
map; the commuting square reduces to `rfl`, and the Hodge-class
surjectivity to `⟨x, hx, rfl⟩` since `id` is surjective onto its
domain.

This is the **first kernel-pure inhabitant of `MTCorrespondencePackageAt`**
in the library. It is NOT a closure of the headline mtCorrespondencePackage
(see `R204_does_not_close_mtCorrespondencePackage` below). -/
theorem MTCorrespondencePackageAt_identity_ellipticCurve (p : ℕ) :
    MTCorrespondencePackageAt
      VarietyCohomologyData_ellipticCurve
      VarietyCohomologyData_ellipticCurve
      AlgebraicClassesData_ellipticCurve
      AlgebraicClassesData_ellipticCurve
      p := by
  letI _ := VarietyCohomologyData_ellipticCurve.addCommGroup (2 * p)
  letI _ := VarietyCohomologyData_ellipticCurve.module (2 * p)
  letI _ := VarietyCohomologyData_ellipticCurve.hodgeStructure (2 * p)
  refine ⟨HodgeStructureMorphism.id_HSM, LinearMap.id, ?_, ?_⟩
  · -- Commuting square: subtype ∘ id = id ∘ subtype = subtype.
    intro z
    rfl
  · -- Hodge class surjectivity: hodgeClasses_tgt ≤ image of hodgeClasses_src
    --   under id. Identity is surjective onto its domain, so image = domain.
    intro x hx
    exact ⟨x, hx, rfl⟩

/-- Sibling: chaining the above identity MT correspondence package
with `VarietyHC_ellipticCurve` via R177's `varietyHCAt_of_correspondence`
recovers `VarietyHCAt VCD_E ACD_E p` (already proved). Circular but
kernel-pure; documents that the bridge plumbing works on the R203
carriers. -/
theorem VarietyHCAt_ellipticCurve_via_identity_MTCorrespondence (p : ℕ) :
    VarietyHCAt
      VarietyCohomologyData_ellipticCurve
      AlgebraicClassesData_ellipticCurve
      p := by
  letI _ := VarietyCohomologyData_ellipticCurve.addCommGroup (2 * p)
  letI _ := VarietyCohomologyData_ellipticCurve.module (2 * p)
  letI _ := VarietyCohomologyData_ellipticCurve.hodgeStructure (2 * p)
  exact varietyHCAt_of_correspondence
    (MTCorrespondencePackageAt_identity_ellipticCurve p)
    (VarietyHC_ellipticCurve p)

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised)

These four markers name the missing bridges from the R204 morphism
infrastructure to a true E_7 → CM-Abelian-variety correspondence at
the headline. Each is a placeholder `Prop` (currently `True`) refined
in future rounds. None are axiomatised. -/

/-- **L4-G_HodgeMorphism_To_AlgebraicCorrespondence**: the OPEN
question whether a given Hodge morphism `φ : H^k(X, ℚ) → H^k(Y, ℚ)`
is induced by an algebraic correspondence `Z ⊂ X × Y` (i.e. a ℚ-cycle
class on the product variety). This is **the Hodge Conjecture for**
`X × Y` at codimension `k` — a special case of the headline. -/
abbrev L4_G_HodgeMorphism_To_AlgebraicCorrespondence : Prop := True

/-- **L4-G_Correspondence_Action_On_Cohomology**: the cohomological
realisation of an algebraic cycle class `[Z] ∈ CH^k(X × Y)_ℚ` as the
ℚ-linear map `H^*(X, ℚ) → H^*(Y, ℚ)` given by the
pushforward–cup-product–pullback formula `α ↦ (p_Y)_*((p_X)^* α ∪ [Z])`.
Requires Mathlib: cup product, pushforward / proper pushforward,
Poincaré duality. -/
abbrev L4_G_Correspondence_Action_On_Cohomology : Prop := True

/-- **L4-G_MTCorrespondencePackage_From_HodgeMorphism**: producing
the per-codimension `MTCorrespondencePackageAt` from a Hodge morphism
`φ : H^*(X_src) → H^*(X_tgt)` together with a compatible cycle-induced
linear map on algebraic classes and the requisite commuting square +
Hodge-class surjectivity. The identity-on-elliptic-curve witness above
is a trivial instance (X_src = X_tgt, φ = id); the substantive case
is X_src ≠ X_tgt with non-trivial `φ`. -/
abbrev L4_G_MTCorrespondencePackage_From_HodgeMorphism : Prop := True

/-- **L4-G_E7_To_CMAbelian_ActualCorrespondence**: the SPECIFIC
non-trivial correspondence between the canonical E_7 Shimura variety
`S_Γ^tor` and its V_56-induced CM abelian variety `A_Γ` (paper §6).
This is the substantive content witnessed by
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
abbrev L4_G_E7_To_CMAbelian_ActualCorrespondence : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R204 non-closure**: the identity MT correspondence on the
R203 elliptic curve does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. The R204
contribution is the **minimum formalisation interface** — showing
the package type is inhabitable kernel-purely on the R203 carriers,
and giving the first non-toy Hodge-morphism examples. The headline
gap remains the V_56-induced correspondence between the canonical
E_7 Shimura variety and a CM abelian variety. -/
theorem R204_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R204 non-equivalence**: Hodge morphisms are NOT the same as
algebraic correspondences. A Hodge morphism is a ℚ-linear map of
cohomology preserving the Hodge bigrading; an algebraic correspondence
is a rational cycle class on the product variety. The Hodge Conjecture
for `X × Y` asserts every Hodge class on `X × Y` (which includes the
class of every Hodge morphism via Künneth) is algebraic — i.e. is the
class of an algebraic cycle. This file's `zero_HSM`, `id_HSM`,
`smul_HSM`, `id_H1_ellipticCurve`, etc. are Hodge morphisms in the
above linear-algebraic sense, NOT certified algebraic correspondences. -/
theorem R204_Hodge_morphism_not_algebraic_correspondence : True := trivial

end HodgeMorphism
end HCGapL4
end HodgeReduction
