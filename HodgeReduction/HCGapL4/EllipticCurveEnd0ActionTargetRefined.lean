/-
# HC Gap L4 — refined End⁰(E) action target (R291).

R277 introduced the End⁰(E) action target. R291 refines it to consume
R290's local CMField evidence and names the precise next theorem
targets.

## What R291 (this file) provides (all kernel-pure)

* `EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton` —
  refined target structure consuming R290 local CMField evidence.
* `EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton_Gaussian` —
  concrete instance.
* `Target_Construct_*` next-theorem markers.
* `EllipticCurveEnd0ActionTargetRefinedChainSkeleton` — wrapper.
* Regression HC theorem.

## What R291 (this file) does NOT do

* Does NOT construct `End(E)`.
* Does NOT construct `End⁰(E)`.
* Does NOT embed Gaussian field into End⁰(E).
* Does NOT prove action on H¹/H².
* Does NOT close `canonicalE7ShimuraTor`.

All R291 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMFieldEvidence
import HodgeReduction.HCGapL4.EllipticCurveEnd0ActionTarget
import HodgeReduction.HCGapL4.ComplexMultiplicationInterface
import HodgeReduction.HCGapL4.CMAbelianToySkeleton

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ComplexMultiplicationInterface
open HodgeReduction.HCGapL4.CMAbelianToySkeleton

/-! ## Section 1: refined End⁰ target -/

/-- **R291 refined End⁰ target**. Consumes R290 local CMField
evidence + R261 elliptic-curve interface; lists 7 End⁰-specific
Prop targets. -/
structure EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton where
  /-- The R290 local CMField evidence. -/
  cmFieldEvidence : LocalCMFieldEvidenceSkeleton
  /-- The R261 EC interface. -/
  ellipticCurveSource : CMAbelianVarietyInterfaceSkeleton
  /-- Target: `End(E)` is a ring. -/
  EndRingTarget : Prop
  /-- Target: `End⁰(E) := End(E) ⊗ ℚ` carrier. -/
  End0CarrierTarget : Prop
  /-- Target: `End⁰(E)` is a ℚ-algebra. -/
  End0QAlgebraTarget : Prop
  /-- Target: ring embedding `ℚ(i) → End⁰(E)`. -/
  cmFieldEmbeddingIntoEnd0Target : Prop
  /-- Target: action on `H¹(E, ℚ)`. -/
  actionOnH1Target : Prop
  /-- Target: action on `H²(E, ℚ)`. -/
  actionOnH2Target : Prop
  /-- Target: compatibility with conjugation (Galois action). -/
  compatibilityWithConjugationTarget : Prop

/-- **R291** Gaussian instance with all End⁰ fields as markers. -/
noncomputable def EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton_Gaussian :
    EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton where
  cmFieldEvidence := LocalCMFieldEvidenceSkeleton_Gaussian
  ellipticCurveSource := CMAbelianVarietyInterfaceSkeleton_ellipticCurveLike
  EndRingTarget := True
  End0CarrierTarget := True
  End0QAlgebraTarget := True
  cmFieldEmbeddingIntoEnd0Target := True
  actionOnH1Target := True
  actionOnH2Target := True
  compatibilityWithConjugationTarget := True

/-! ## Section 2: precise next-theorem markers -/

/-- **R291 next theorem 1**: `End(E)` (endomorphism ring of EC). -/
def R291_Target_Construct_EndRing_EllipticCurve : Prop := True

/-- **R291 next theorem 2**: `End⁰(E) = End(E) ⊗ ℚ`. -/
def R291_Target_Construct_End0_EllipticCurve : Prop := True

/-- **R291 next theorem 3**: `ℚ(i) → End⁰(E)` ring embedding for a
specific CM elliptic curve. -/
def R291_Target_Construct_GaussianEmbedding_To_End0_EllipticCurve : Prop := True

/-- **R291 next theorem 4**: action on `H¹(E, ℚ)`. -/
def R291_Target_Construct_End0Action_On_H1 : Prop := True

/-- **R291 next theorem 5**: action on `H²(E, ℚ)`. -/
def R291_Target_Construct_End0Action_On_H2 : Prop := True

/-! ## Section 3: connection to R277 -/

/-- **R291** wrapper linking R277 old End⁰ target with R291 refined
target. -/
structure EllipticCurveEnd0ActionTargetRefinedChainSkeleton where
  /-- R277 old End⁰ target. -/
  oldTarget : EllipticCurveEnd0ActionTargetSkeleton
  /-- R291 refined End⁰ target with CMField evidence. -/
  refinedTarget :
    EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton

/-- **R291** Gaussian instance. -/
noncomputable def EllipticCurveEnd0ActionTargetRefinedChainSkeleton_current :
    EllipticCurveEnd0ActionTargetRefinedChainSkeleton where
  oldTarget := EllipticCurveEnd0ActionTargetSkeleton_Gaussian
  refinedTarget :=
    EllipticCurveEnd0ActionTargetWithCMFieldEvidenceSkeleton_Gaussian

/-! ## Section 4: regression HC theorem -/

/-- **R291** regression: HC at codim 1 for E_7-Shimura toy via the
refined End⁰ target chain. Delegates to R290's regression. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveEnd0ActionTargetRefined :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_LocalCMFieldEvidence

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_End0RefinedTarget_To_RealEndomorphismRing**: bridge to
real `End(E)` infrastructure. -/
def L4_G_End0RefinedTarget_To_RealEndomorphismRing : Prop := True

/-- **L4-G_End0RefinedTarget_To_CMEmbedding**: bridge to the
`ℚ(i) → End⁰(E)` embedding for a specific CM EC. -/
def L4_G_End0RefinedTarget_To_CMEmbedding : Prop := True

/-- **L4-G_End0RefinedTarget_To_CohomologyAction**: bridge to the
End⁰ action on H¹/H². -/
def L4_G_End0RefinedTarget_To_CohomologyAction : Prop := True

/-- **L4-G_End0RefinedTarget_To_Deligne1982**: bridge to Deligne 1982. -/
def L4_G_End0RefinedTarget_To_Deligne1982 : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R291 non-closure (1/5)**: does NOT construct `End(E)`. -/
theorem R291_does_not_construct_End : True := trivial

/-- **R291 non-closure (2/5)**: does NOT construct `End⁰(E)`. -/
theorem R291_does_not_construct_End0 : True := trivial

/-- **R291 non-closure (3/5)**: does NOT embed Gaussian field into
End⁰(E). -/
theorem R291_does_not_embed_Gaussian_into_End0 : True := trivial

/-- **R291 non-closure (4/5)**: does NOT prove action on cohomology. -/
theorem R291_does_not_prove_action_on_cohomology : True := trivial

/-- **R291 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R291_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
