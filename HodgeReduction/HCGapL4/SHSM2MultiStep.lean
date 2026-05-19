/-
# HC Gap L4 — v2 SHSM multi-step composition (R220).

R218 closed the general binary `SHSM2_compose` for v2 packages with
explicit `(p_src, p_tgt)` parameters. R219 closed the v1 → v2 bridge.
R220 demonstrates the v2 calculus extends operationally to multi-step
chains by iterating binary composition.

This round proves operational closure only. Categorical associativity
`(P₃ ∘ P₂) ∘ P₁ = P₃ ∘ (P₂ ∘ P₁)` is NOT proved (would require proof
irrelevance on existential witnesses + cast handling on the chained
shift Nat equation).

## What R220 provides (all kernel-pure)

* `ShiftedMTCorrespondencePackageAt_SHSM2_compose3` — three-step
  composition via two binary `SHSM2_compose` applications (one
  bracketing chosen; the other bracketing's equality NOT proved).
* `VarietyHCAt_of_SHSM2_composed3` — HC transfer via three-step
  composed package.
* `SHSM2_point_to_E_via_three_step_composition` — sanity instance:
  identity@pt ∘ R218-native pt → E ∘ identity@E.
* `VarietyHCAt_ellipticCurve_codim1_via_SHSM2_three_step_composition` —
  12th kernel-pure HC route via three-step compose.

## What R220 does NOT do

* Does NOT prove categorical associativity.
* Does NOT prove the two bracketings produce the same package.
* Does NOT do generic cycleAction across multi-step chains.
* Does NOT do general product correspondence.
* Does NOT rewrite or deprecate v1.
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT implement real Chow correspondence composition.

All R220 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

namespace HodgeReduction
namespace HCGapL4
namespace SHSM2MultiStep

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

/-! ## Section 1: Priority A — three-step composition

Iterate binary `SHSM2_compose`. Left-bracketing chosen:
`(P₁ ∘ P₂) ∘ P₃`. The right-bracketing `P₁ ∘ (P₂ ∘ P₃)` is also
typeable but its package-level equality with the left bracketing
requires proof irrelevance (deferred). -/

/-- **R220 three-step composition**: composing three v2 SHSM packages
sequentially via two binary `SHSM2_compose` applications. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM2_compose3
    {X Y Z W : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {AW : AlgebraicClassesData W}
    {p₀ p₁ p₂ p₃ : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt_SHSM2 X Y AX AY p₀ p₁)
    (P₂ : ShiftedMTCorrespondencePackageAt_SHSM2 Y Z AY AZ p₁ p₂)
    (P₃ : ShiftedMTCorrespondencePackageAt_SHSM2 Z W AZ AW p₂ p₃) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X W AX AW p₀ p₃ :=
  ShiftedMTCorrespondencePackageAt_SHSM2_compose
    (ShiftedMTCorrespondencePackageAt_SHSM2_compose P₁ P₂)
    P₃

/-! ## Section 2: Priority B — multi-step HC transfer -/

/-- **R220 multi-step HC transfer**: given three v2 SHSM packages
forming a chain and HC at the source, derive HC at the final target.
Implementation: compose into a single v2 package, drop to raw via
`toRaw`, apply R212's shifted transfer. -/
theorem VarietyHCAt_of_SHSM2_composed3
    {X Y Z W : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {AW : AlgebraicClassesData W}
    {p₀ p₁ p₂ p₃ : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt_SHSM2 X Y AX AY p₀ p₁)
    (P₂ : ShiftedMTCorrespondencePackageAt_SHSM2 Y Z AY AZ p₁ p₂)
    (P₃ : ShiftedMTCorrespondencePackageAt_SHSM2 Z W AZ AW p₂ p₃)
    (h_HC_src : VarietyHCAt X AX p₀) :
    VarietyHCAt W AW p₃ :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      (ShiftedMTCorrespondencePackageAt_SHSM2_compose3 P₁ P₂ P₃))
    h_HC_src

/-! ## Section 3: Priority C — sanity three-step instance

Chain three v2 packages:
* `identity_SHSM2` at point, codim 0 → 0
* R218-native `SHSM2_point_to_ellipticCurve_codim0_to_codim1`, codim 0 → 1
* `identity_SHSM2` at elliptic curve, codim 1 → 1

Composed: `pt → E` at codim 0 → 1 via three-step. -/

/-- **R220 sanity instance**: SHSM2 from pt to E at codim 0 → 1 via
three-step composition (identity@pt → pt→E → identity@E). -/
theorem SHSM2_point_to_E_via_three_step_composition :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  ShiftedMTCorrespondencePackageAt_SHSM2_compose3
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    ShiftedMTCorrespondencePackageAt_SHSM2_point_to_ellipticCurve_codim0_to_codim1
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1)

/-- **R220 12th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via three-step v2 composition. Exercises the multi-step compose calculus
operationally. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_SHSM2_three_step_composition :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_SHSM2_composed3
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    ShiftedMTCorrespondencePackageAt_SHSM2_point_to_ellipticCurve_codim0_to_codim1
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 4: Priority D — disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_SHSM2_CategoricalAssociativity**: the categorical equation
`(P₃ ∘ P₂) ∘ P₁ = P₃ ∘ (P₂ ∘ P₁)` at the v2 package level. Requires
proof irrelevance on existential witnesses for `shift`, `h_shift`,
`action`, `ψ`, and the three conjunct proofs. R220 picks ONE
bracketing for `compose3` and does NOT prove equality with the other. -/
abbrev L4_G_SHSM2_CategoricalAssociativity : Prop := True

/-- **L4-G_SHSM2_ProofIrrelevanceForPackageEquality**: showing two v2
SHSM packages are equal as Props requires proof-irrelevance treatment
of the existential bundles. Not standard in Mathlib for SHSM2-style
five-field existentials. Deferred. -/
abbrev L4_G_SHSM2_ProofIrrelevanceForPackageEquality : Prop := True

/-- **L4-G_SHSM2_MultiStepComposition_From_ChowCalculus**: derive
multi-step v2 SHSM composition from a real Chow-cycle composition
calculus (Manin–Voevodsky correspondences for n-step chains). R220
provides operational composition via iterated binary compose;
deriving it from genuine Chow calculus requires the deferred real
cycle correspondence machinery. -/
abbrev L4_G_SHSM2_MultiStepComposition_From_ChowCalculus : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R220 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R220_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R220 non-closure (2/4)**: does NOT prove categorical
associativity for v2 multi-step composition. Only operational
left-bracketed iteration. -/
theorem R220_does_not_prove_categorical_associativity : True := trivial

/-- **R220 non-closure (3/4)**: does NOT implement real Chow
correspondence composition for n-step chains. Linear-algebraic
skeleton only. -/
theorem R220_does_not_implement_real_chow_multistep : True := trivial

/-- **R220 non-closure (4/4)**: only demonstrates operational
multi-step composition via iterated binary compose. Does NOT prove
the two bracketings yield equal packages. -/
theorem R220_only_operational_multistep_not_bracketing_equality : True := trivial

end SHSM2MultiStep
end HCGapL4
end HodgeReduction
