/-
# HC Gap L4 — local CMField evidence for ℚ(i) (R290).

R289 closed imaginary-quadratic nontriviality evidence. R290 wraps
into a local CMField evidence skeleton (Prop-slot pattern,
matching R268).

## What R290 (this file) provides (all kernel-pure)

* `LocalCMFieldEvidenceSkeleton` — Prop-slot bundle covering
  NumberField + Q-Algebra + finrank=2 + conjugation + involution +
  nontriviality + three CM-shape targets (totally imaginary,
  totally real subfield, quadratic over totally real).
* `LocalCMFieldEvidenceSkeleton_Gaussian` — Gaussian instance.
* `CMFieldRealizationWithLocalEvidenceSkeleton` — combined wrapper.
* `EllipticCurveCMInterfaceWithLocalCMFieldEvidenceSkeleton` — R261
  CM interface + local CM evidence.
* Adapter to R256 + regression HC theorem.

## What R290 (this file) does NOT do

* Does NOT implement Mathlib `CMField`.
* Does NOT construct End⁰(E).
* Does NOT prove Gaussian field acts on an elliptic curve.
* Does NOT prove Deligne 1982.
* Does NOT close `canonicalE7ShimuraTor`.

All R290 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianImaginaryQuadraticEvidence
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldClosed
import HodgeReduction.HCGapL4.GaussianNumberFieldClosureIntegration
import HodgeReduction.HCGapL4.ComplexMultiplicationInterface
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import HodgeReduction.HCGapL2.EllipticCurve

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ComplexMultiplicationInterface
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: local CMField evidence skeleton -/

/-- **R290 local CMField evidence bundle**. Prop-slot pattern;
specific Mathlib-backed Props filled at instantiation. -/
structure LocalCMFieldEvidenceSkeleton where
  /-- The candidate field type slot. -/
  K : Type
  /-- NumberField evidence Prop. -/
  numberFieldEvidence : Prop
  /-- Closure. -/
  numberFieldEvidence_proved : numberFieldEvidence
  /-- Q-Algebra evidence Prop. -/
  qAlgebraEvidence : Prop
  /-- Closure. -/
  qAlgebraEvidence_proved : qAlgebraEvidence
  /-- finrank = 2 evidence Prop. -/
  finrankTwoEvidence : Prop
  /-- Closure. -/
  finrankTwoEvidence_proved : finrankTwoEvidence
  /-- Conjugation evidence Prop. -/
  conjugationEvidence : Prop
  /-- Closure. -/
  conjugationEvidence_proved : conjugationEvidence
  /-- Conjugation involution Prop. -/
  conjugationInvolutiveEvidence : Prop
  /-- Closure. -/
  conjugationInvolutiveEvidence_proved : conjugationInvolutiveEvidence
  /-- Conjugation nontriviality Prop. -/
  conjugationNontrivial : Prop
  /-- Closure. -/
  conjugationNontrivial_proved : conjugationNontrivial
  /-- Totally imaginary target Prop (no real Mathlib evidence). -/
  totallyImaginaryTarget : Prop
  /-- Totally real subfield target Prop. -/
  totallyRealSubfieldTarget : Prop
  /-- Quadratic over totally real target Prop. -/
  quadraticOverTotallyRealTarget : Prop

/-- **R290** Gaussian local CMField evidence instance. -/
noncomputable def LocalCMFieldEvidenceSkeleton_Gaussian :
    LocalCMFieldEvidenceSkeleton where
  K := GaussianRationalFieldCandidate
  numberFieldEvidence := NumberField GaussianRationalFieldCandidate
  numberFieldEvidence_proved := inferInstance
  qAlgebraEvidence := Nonempty (Algebra ℚ GaussianRationalFieldCandidate)
  qAlgebraEvidence_proved := GaussianRationalFieldCandidate_has_QAlgebra
  finrankTwoEvidence := Module.finrank ℚ GaussianRationalFieldCandidate = 2
  finrankTwoEvidence_proved := GaussianRationalFieldCandidate_finrank_eq_two
  conjugationEvidence := Nonempty
    (GaussianRationalFieldCandidate ≃+* GaussianRationalFieldCandidate)
  conjugationEvidence_proved := ⟨GaussianRationalFieldCandidate_conj⟩
  conjugationInvolutiveEvidence :=
    Function.Involutive GaussianRationalFieldCandidate_conj
  conjugationInvolutiveEvidence_proved :=
    GaussianRationalFieldCandidate_conj_involutive
  conjugationNontrivial :=
    GaussianRationalFieldCandidate_conj gaussianRationalI ≠ gaussianRationalI
  conjugationNontrivial_proved :=
    GaussianRationalFieldCandidate_conj_nontrivial_on_i
  -- For ℚ(i): totally real subfield is ℚ; degree 2 over ℚ; totally imaginary.
  -- These remain targets (need NumberField.InfinitePlace formalization).
  totallyImaginaryTarget := True
  totallyRealSubfieldTarget := True
  quadraticOverTotallyRealTarget := True

/-! ## Section 2: combined wrapper on top of R288 -/

/-- **R290** combined wrapper. -/
structure CMFieldRealizationWithLocalEvidenceSkeleton where
  /-- The R288 NumberField-evidence wrapper for CMField realization. -/
  base : CMFieldRealizationWithNumberFieldEvidenceSkeleton
  /-- The R290 local CMField evidence. -/
  localCMFieldEvidence : LocalCMFieldEvidenceSkeleton

/-- **R290** Gaussian instance. -/
noncomputable def CMFieldRealizationWithLocalEvidenceSkeleton_Gaussian :
    CMFieldRealizationWithLocalEvidenceSkeleton where
  base := CMFieldRealizationWithNumberFieldEvidenceSkeleton_Gaussian
  localCMFieldEvidence := LocalCMFieldEvidenceSkeleton_Gaussian

/-! ## Section 3: R261 CM interface + local CM evidence -/

/-- **R290** wrapper bundling R261's CM interface with R290's local
CMField evidence. -/
structure EllipticCurveCMInterfaceWithLocalCMFieldEvidenceSkeleton where
  /-- R261 EC-like CM interface. -/
  baseCMInterface : CMAbelianVarietyInterfaceSkeleton
  /-- R290 local CMField evidence. -/
  localCMFieldEvidence : LocalCMFieldEvidenceSkeleton

/-- **R290** Gaussian instance. -/
noncomputable def EllipticCurveCMInterfaceWithLocalCMFieldEvidenceSkeleton_instance :
    EllipticCurveCMInterfaceWithLocalCMFieldEvidenceSkeleton where
  baseCMInterface := CMAbelianVarietyInterfaceSkeleton_ellipticCurveLike
  localCMFieldEvidence := LocalCMFieldEvidenceSkeleton_Gaussian

/-! ## Section 4: adapter to R256 -/

/-- **R290** adapter via R261 base. -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveLocalCMFieldEvidence :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_of_CMAbelianVarietyInterface
    EllipticCurveCMInterfaceWithLocalCMFieldEvidenceSkeleton_instance.baseCMInterface

/-! ## Section 5: regression HC theorem -/

/-- **R290** regression: HC at codim 1 for E_7-Shimura toy. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_LocalCMFieldEvidence :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    (source := AbstractCMAbelianHCSource_from_EllipticCurveLocalCMFieldEvidence)
    { correspondence := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1 }

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_LocalCMFieldEvidence_To_MathlibCMField**: bridge to a
future Mathlib `CMField` typeclass. -/
def L4_G_LocalCMFieldEvidence_To_MathlibCMField : Prop := True

/-- **L4-G_LocalCMFieldEvidence_To_End0Action**: bridge to End⁰(E)
construction (R291+). -/
def L4_G_LocalCMFieldEvidence_To_End0Action : Prop := True

/-- **L4-G_LocalCMFieldEvidence_MissingTotallyRealSubfield**:
"totally real subfield = ℚ" not formalized. -/
def L4_G_LocalCMFieldEvidence_MissingTotallyRealSubfield : Prop := True

/-- **L4-G_LocalCMFieldEvidence_MissingTotallyImaginaryProof**:
"totally imaginary" not formalized. -/
def L4_G_LocalCMFieldEvidence_MissingTotallyImaginaryProof : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R290 non-closure (1/5)**: does NOT implement Mathlib `CMField`. -/
theorem R290_does_not_implement_mathlib_CMField : True := trivial

/-- **R290 non-closure (2/5)**: does NOT construct End⁰(E). -/
theorem R290_does_not_construct_End0 : True := trivial

/-- **R290 non-closure (3/5)**: does NOT prove Gaussian field acts
on an elliptic curve. -/
theorem R290_does_not_prove_Gaussian_acts_on_EC : True := trivial

/-- **R290 non-closure (4/5)**: does NOT prove Deligne 1982. -/
theorem R290_does_not_prove_deligne_1982 : True := trivial

/-- **R290 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R290_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
