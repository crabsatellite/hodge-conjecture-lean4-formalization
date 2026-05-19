/-
# HC Gap L4 — composition calculus for shifted MT packages (R215).

R212–R214 built shifted MT correspondence packages (raw,
SHSM-bundled, induced-ψ variants) that transfer HC across codim
shifts. R215 establishes the **composition calculus**: composing two
shifted packages produces a third, with the cohomological and
algebraic-class maps composed pointwise.

## What R215 provides (all kernel-pure)

* `ShiftedMTCorrespondencePackageAt_compose` — raw R212 package
  composition: `(X → Y at (p_src, p_mid))` composed with
  `(Y → Z at (p_mid, p_tgt))` yields `(X → Z at (p_src, p_tgt))`.
* `identity_ShiftedMTCorrespondencePackageAt` — identity raw package
  `(X → X at (p, p))`, used as the composition unit.
* `VarietyHCAt_of_composed_shifted_correspondence` — transfer via
  the composed package (one-step closure).
* Sanity instance: `identity@pt ∘ R214's pt → E` package recovers
  HC at E codim 1 through the composition route.
* `R215_SHSM_composition_obstruction_record` — the SHSM-bundled
  composition's target codim involves `Nat.add_assoc`, which is
  propositional but not definitional. R215 records this as a
  theorem-level obstruction; SHSM composition is deferred.

## What R215 does NOT do

* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT implement real Chow correspondence composition.
* It does NOT implement general cycleAction or push-pull-cup.
* It does NOT prove SHSM-bundled composition (target codim's
  `Nat.add_assoc` blocks the type-level unification; obstruction
  recorded).

All R215 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap

namespace HodgeReduction
namespace HCGapL4
namespace ShiftedCorrespondenceComposition

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.InducedAlgClassMap

/-! ## Section 1: raw R212 shifted package composition

Given R212 packages `P₁ : X → Y at (p_src, p_mid)` and
`P₂ : Y → Z at (p_mid, p_tgt)`, produce `X → Z at (p_src, p_tgt)`
with `action := action₂ ∘ₗ action₁` and `ψ := ψ₂ ∘ₗ ψ₁`.

The commuting square and Hodge-surjectivity proofs chain the
component proofs from `P₁` and `P₂`. -/

/-- **R215 raw composition theorem**. -/
theorem ShiftedMTCorrespondencePackageAt_compose
    {X Y Z : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {p_src p_mid p_tgt : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt X Y AX AY p_src p_mid)
    (P₂ : ShiftedMTCorrespondencePackageAt Y Z AY AZ p_mid p_tgt) :
    ShiftedMTCorrespondencePackageAt X Z AX AZ p_src p_tgt := by
  letI _ := X.addCommGroup (2 * p_src)
  letI _ := X.module (2 * p_src)
  letI _ := X.hodgeStructure (2 * p_src)
  letI _ := Y.addCommGroup (2 * p_mid)
  letI _ := Y.module (2 * p_mid)
  letI _ := Y.hodgeStructure (2 * p_mid)
  letI _ := Z.addCommGroup (2 * p_tgt)
  letI _ := Z.module (2 * p_tgt)
  letI _ := Z.hodgeStructure (2 * p_tgt)
  unfold ShiftedMTCorrespondencePackageAt at P₁ P₂
  obtain ⟨action₁, ψ₁, h_sq₁, h_surj₁⟩ := P₁
  obtain ⟨action₂, ψ₂, h_sq₂, h_surj₂⟩ := P₂
  refine ⟨action₂ ∘ₗ action₁, ψ₂ ∘ₗ ψ₁, ?_, ?_⟩
  · -- Commuting square: subtype (ψ₂ (ψ₁ z)) = action₂ (action₁ (subtype z))
    intro z
    show ((AZ.algClasses p_tgt).subtype) (ψ₂ (ψ₁ z)) =
         action₂ (action₁ (((AX.algClasses p_src).subtype) z))
    rw [h_sq₂ (ψ₁ z), h_sq₁ z]
  · -- Hodge surjectivity: chain h_surj₂ then h_surj₁.
    intro x hx_Z
    obtain ⟨y, hy_Y, hy_eq⟩ := h_surj₂ hx_Z
    obtain ⟨v, hv_X, hv_eq⟩ := h_surj₁ hy_Y
    refine ⟨v, hv_X, ?_⟩
    show (action₂ ∘ₗ action₁) v = x
    rw [LinearMap.comp_apply, hv_eq]
    exact hy_eq

/-! ## Section 2: identity raw shifted package `(X → X at (p, p))`

The composition unit: same-object, same-codim, identity action and
identity ψ. Commuting square and Hodge surjectivity are trivial
`rfl`/identity facts. -/

/-- **R215 identity raw package**: `ShiftedMTCorrespondencePackageAt X X AX AX p p`
with both action and ψ taken to be the identity. -/
theorem identity_ShiftedMTCorrespondencePackageAt
    (X : VarietyCohomologyData)
    (AX : AlgebraicClassesData X)
    (p : ℕ) :
    ShiftedMTCorrespondencePackageAt X X AX AX p p := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  refine ⟨LinearMap.id, LinearMap.id, ?_, ?_⟩
  · -- Commuting square: subtype (id z) = id (subtype z) = subtype z; rfl.
    intro z
    rfl
  · -- Hodge surjectivity: hodgeClasses ≤ Submodule.map id hodgeClasses
    intro x hx
    refine ⟨x, hx, ?_⟩
    rfl

/-! ## Section 3: transfer via composed package -/

/-- **R215 composition transfer theorem**: given two shifted packages
that compose, and HC at the source, derive HC at the target.

Equivalent to chaining two `varietyHCAt_of_shifted_correspondence`
calls, or to one call on the composed package. -/
theorem VarietyHCAt_of_composed_shifted_correspondence
    {X Y Z : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {p_src p_mid p_tgt : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt X Y AX AY p_src p_mid)
    (P₂ : ShiftedMTCorrespondencePackageAt Y Z AY AZ p_mid p_tgt)
    (h_HC_X : VarietyHCAt X AX p_src) :
    VarietyHCAt Z AZ p_tgt :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_compose P₁ P₂)
    h_HC_X

/-! ## Section 4: sanity instance — composition recovers HC at E codim 1

Compose `identity_ShiftedMTCorrespondencePackageAt` at the point
(p = 0) with R212's `ShiftedMTCorrespondencePackageAt_point_to_ellipticCurve_codim0_to_codim1`.
The composed package is `pt → E at (0, 1)`, equivalent to the direct
R212 package; the HC closure via composition recovers
`VarietyHCAt_ellipticCurve_codim1`. -/

/-- **R215 sanity composition**: identity@pt composed with R212's
pt→E codim0→1 package, yielding a `(0, 1)` package via the
composition route. -/
theorem ShiftedMTCorrespondencePackageAt_point_to_ellipticCurve_via_composition :
    ShiftedMTCorrespondencePackageAt
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  ShiftedMTCorrespondencePackageAt_compose
    (identity_ShiftedMTCorrespondencePackageAt
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    ShiftedMTCorrespondencePackageAt_point_to_ellipticCurve_codim0_to_codim1

/-- **R215 7th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via the composition of the identity package at the point with R212's
pt→E codim0→1 package. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_composed_correspondence :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_composed_shifted_correspondence
    (identity_ShiftedMTCorrespondencePackageAt
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    ShiftedMTCorrespondencePackageAt_point_to_ellipticCurve_codim0_to_codim1
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: SHSM composition obstruction

The SHSM-bundled package (R213) is parameterised as
`ShiftedMTCorrespondencePackageAt_SHSM X Y AX AY p_src q` with
target codim `p_src + q`. Composing two SHSM packages:

* `P₁ : SHSM X Y AX AY p_src q₁` — target codim `p_src + q₁`.
* `P₂ : SHSM Y Z AY AZ (p_src + q₁) q₂` — source codim `p_src + q₁`,
  target codim `(p_src + q₁) + q₂`.

The composed package would be `SHSM X Z AX AZ p_src (q₁ + q₂)` with
target codim `p_src + (q₁ + q₂)`. But this requires the type-level
identity `p_src + (q₁ + q₂) = (p_src + q₁) + q₂`, which is
`Nat.add_assoc` — **propositionally true, but NOT definitionally**
in Lean 4. Typeclass synthesis and Fin-indexing both reject the
mismatch; an `Eq.mpr`/`cast`-based bridge would be required and is
deferred. -/

/-- **R215 SHSM composition obstruction record**: composing two
SHSM-bundled shifted packages requires `Nat.add_assoc` at the
type-level codim arithmetic. R215 records the obstruction; the
work-around (transport via `Nat.add_assoc`) is deferred. -/
theorem R215_SHSM_composition_obstruction_record_NatAddAssoc : True := trivial

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ShiftedCorrespondenceComposition_From_ChowComposition**:
real Chow-correspondence composition (Manin–Voevodsky correspondence
calculus) producing the shifted MT package composition. R215
constructs the linear-algebraic skeleton only. -/
abbrev L4_G_ShiftedCorrespondenceComposition_From_ChowComposition : Prop := True

/-- **L4-G_CycleActionComposition_PushPullFormula**: the
push-pull-cup composition formula for two algebraic correspondences
`Z₁ ⊂ X × Y` and `Z₂ ⊂ Y × Z`, producing the composite cycle
`Z₂ ∘ Z₁ ⊂ X × Z`. R215 composes linear maps directly without
modelling the underlying cycle composition. -/
abbrev L4_G_CycleActionComposition_PushPullFormula : Prop := True

/-- **L4-G_SHSMComposition_TateTwistAssociativity**: the SHSM-bundled
composition's target codim arithmetic `p_src + (q₁ + q₂) = (p_src + q₁) + q₂`.
Propositionally `Nat.add_assoc`, but type-level unification requires
either a definitional version or an explicit `Eq.mpr`/`cast` transport.
R215 records the obstruction; the transport-based SHSM composition is
deferred. -/
abbrev L4_G_SHSMComposition_TateTwistAssociativity : Prop := True

/-- **L4-G_MTCorrespondencePackage_Composition_Final**: a "final"
composition framework promoting `ShiftedMTCorrespondencePackageAt` to
a properly categorical correspondence calculus (composable, with
identity unit, associative up to definitional equality, supporting
inverse / adjoint operations). R215 establishes the kernel-pure
prototype (composition + identity unit); associativity and the
SHSM-level extension are deferred. -/
abbrev L4_G_MTCorrespondencePackage_Composition_Final : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R215 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R215_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R215 non-closure (2/5)**: does NOT implement real Chow
correspondence composition (the Manin–Voevodsky composition formula). -/
theorem R215_does_not_implement_real_chow_composition : True := trivial

/-- **R215 non-closure (3/5)**: does NOT implement general
cycleAction or push-pull-cup. R215 composes linear maps directly. -/
theorem R215_does_not_implement_general_cycleAction : True := trivial

/-- **R215 non-closure (4/5)**: does NOT close SHSM-bundled
composition. The target codim arithmetic `Nat.add_assoc` is
non-definitional; the transport-based work-around is deferred. -/
theorem R215_does_not_close_SHSM_composition : True := trivial

/-- **R215 non-closure (5/5)**: does NOT prove categorical
associativity of composition. Only the binary composition + identity
unit are established; the associativity equation
`(P₃ ∘ P₂) ∘ P₁ = P₃ ∘ (P₂ ∘ P₁)` would require proof irrelevance on
the existential witness extraction. -/
theorem R215_does_not_prove_composition_associativity : True := trivial

end ShiftedCorrespondenceComposition
end HCGapL4
end HodgeReduction
