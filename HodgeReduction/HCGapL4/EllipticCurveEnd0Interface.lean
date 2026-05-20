/-
# HC Gap L4 — End⁰(E) rationalized endomorphism algebra interface (R294).

R293 introduced an endomorphism-ring interface with `AddMonoid.End`
as group-endomorphism candidate. R294 adds the rationalized
End⁰(E) = End(E) ⊗_ℤ ℚ interface as honest Prop-slot targets.

For a CM elliptic curve E/ℚ with CM by ℤ[i]:
* `End(E)` is an order in ℚ(i) (a ℤ-algebra).
* `End⁰(E) := End(E) ⊗_ℤ ℚ ≅ ℚ(i)` as ℚ-algebras.

Mathlib gap: no `End(E)`, hence no `End⁰(E)`.

## What R294 (this file) provides (all kernel-pure)

* `EllipticCurveEnd0InterfaceSkeleton` — 5-field interface.
* `EllipticCurveEnd0InterfaceSkeleton_Gaussian` — Gaussian candidate
  using `GaussianRationalFieldCandidate` as End⁰ carrier (HONEST
  candidate, not constructed).
* `Target_*` markers for tensor construction + Q-algebra + finrank.
* `EllipticCurveEnd0InterfaceWithEndRingSkeleton` — combined wrapper.
* Regression HC theorem.

## What R294 (this file) does NOT do

* Does NOT construct `End⁰(E)`.
* Does NOT prove End⁰(E) is a ℚ-algebra.
* Does NOT prove Gaussian field embeds into End⁰(E).
* Does NOT close `canonicalE7ShimuraTor`.

All R294 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.EllipticCurveEndomorphismRingInterface
import HodgeReduction.HCGapL4.GaussianCMFieldEvidence
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: End⁰ interface -/

/-- **R294 End⁰ interface**. Bundles R293 endomorphism ring interface
+ End⁰ carrier slot + 4 ℚ-algebra targets. -/
structure EllipticCurveEnd0InterfaceSkeleton where
  /-- The R293 endomorphism ring interface. -/
  endRingInterface : EllipticCurveEndomorphismRingInterfaceSkeleton
  /-- End⁰ carrier type slot. -/
  end0Carrier : Type
  /-- Target: End⁰ is a ℚ-algebra. -/
  qAlgebraEvidenceTarget : Prop
  /-- Target: End⁰ obtained by scalar extension End ⊗ ℚ. -/
  scalarExtensionFromEndTarget : Prop
  /-- Target: tensor with ℚ construction. -/
  tensorWithQTarget : Prop
  /-- Target: End⁰ finite-dimensional ℚ-algebra. -/
  finiteDimensionalQAlgebraTarget : Prop

/-! ## Section 2: Gaussian End⁰ instance -/

/-- **R294** Gaussian End⁰ instance. End⁰ carrier set to
`GaussianRationalFieldCandidate` (the candidate CM subfield
target), all ℚ-algebra structure as markers. -/
noncomputable def EllipticCurveEnd0InterfaceSkeleton_Gaussian :
    EllipticCurveEnd0InterfaceSkeleton where
  endRingInterface :=
    EllipticCurveEndomorphismRingInterfaceSkeleton_PointGroupEnd
  end0Carrier := GaussianRationalFieldCandidate
  qAlgebraEvidenceTarget := True
  scalarExtensionFromEndTarget := True
  tensorWithQTarget := True
  finiteDimensionalQAlgebraTarget := True

/-! ## Section 3: gap markers -/

/-- **R294 gap**: construct `End⁰(E) := End(E) ⊗ℤ ℚ`. -/
def Target_Construct_End0_As_Tensor_EndE_Q : Prop := True

/-- **R294 gap**: prove End⁰ is ℚ-algebra. -/
def Target_Prove_End0_QAlgebra : Prop := True

/-- **R294 gap**: prove End⁰ is finite-dimensional over ℚ. -/
def Target_Prove_End0_FiniteDimensional : Prop := True

/-- **R294 gap**: compare Gaussian field with End⁰(E). -/
def Target_Compare_GaussianField_To_End0 : Prop := True

/-! ## Section 4: combined wrapper -/

/-- **R294** combined wrapper. -/
structure EllipticCurveEnd0InterfaceWithEndRingSkeleton where
  /-- The R293 wrapper with CMField evidence + endRing. -/
  endRingWithCM : EllipticCurveEndomorphismRingInterfaceWithCMFieldEvidenceSkeleton
  /-- The R294 End⁰ interface. -/
  end0Interface : EllipticCurveEnd0InterfaceSkeleton

/-- **R294** Gaussian instance. -/
noncomputable def EllipticCurveEnd0InterfaceWithEndRingSkeleton_Gaussian :
    EllipticCurveEnd0InterfaceWithEndRingSkeleton where
  endRingWithCM :=
    EllipticCurveEndomorphismRingInterfaceWithCMFieldEvidenceSkeleton_Gaussian
  end0Interface := EllipticCurveEnd0InterfaceSkeleton_Gaussian

/-! ## Section 5: regression HC theorem -/

/-- **R294** regression: HC at codim 1 for E_7-Shimura toy. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_End0Interface :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_EndomorphismRingInterface

/-! ## Section 6: disclosure markers -/

/-- **L4-G_End0Interface_To_TensorEndQ**: bridge to End ⊗_ℤ ℚ
construction. -/
def L4_G_End0Interface_To_TensorEndQ : Prop := True

/-- **L4-G_End0Interface_To_CMEmbedding**: bridge to ℚ(i) → End⁰(E). -/
def L4_G_End0Interface_To_CMEmbedding : Prop := True

/-- **L4-G_End0Interface_MissingQAlgebraStructure**: ℚ-algebra
structure on End⁰(E) is not constructed. -/
def L4_G_End0Interface_MissingQAlgebraStructure : Prop := True

/-- **L4-G_End0Interface_MissingFiniteDimensionality**: End⁰(E)
finite-dim over ℚ not proved. -/
def L4_G_End0Interface_MissingFiniteDimensionality : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R294 non-closure (1/4)**: does NOT construct `End⁰(E)`. -/
theorem R294_does_not_construct_End0 : True := trivial

/-- **R294 non-closure (2/4)**: does NOT prove End⁰ is ℚ-algebra. -/
theorem R294_does_not_prove_End0_QAlgebra : True := trivial

/-- **R294 non-closure (3/4)**: does NOT prove Gaussian field embeds. -/
theorem R294_does_not_prove_Gaussian_embedding : True := trivial

/-- **R294 non-closure (4/4)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R294_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
