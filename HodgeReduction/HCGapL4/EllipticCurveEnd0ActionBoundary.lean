/-
# HC Gap L4 — End⁰(E) action boundary interface (R271).

R268/R269/R270 built a Mathlib-backed Field carrier `ℚ(i)` plus
CMField / NumberField / imaginary-quadratic interface layers, but
all are SOURCE-side: they describe a candidate CM field. The
crucial CM **action** on an elliptic curve via `End⁰(E)` remains
absent from Mathlib (R267-A audit).

R271 introduces a clean **library-boundary interface** for a future
`End⁰(E)`-action — analogous to R262's Deligne 1982 boundary
interface. The candidate End⁰ carrier is set to the R267-B Gaussian
field; the cohomology actions and EC-compatibility are Prop markers.

Per the user's R271 brief, this is interface construction only: NO
construction of `End(E)`, NO construction of `End⁰(E)`, NO claim
that the Gaussian field acts on any specific elliptic curve.

## What R271 (this file) provides (all kernel-pure)

* `EllipticCurveEnd0ActionBoundarySkeleton` — 6-field interface.
* `EllipticCurveEnd0ActionBoundarySkeleton_Gaussian` — concrete
  instance using R267-B candidate as the End⁰ carrier slot.
* `EllipticCurveCMInterfaceWithEnd0BoundarySkeleton` — combined
  wrapper on top of R270.
* Adapter to R256 + regression HC theorem (delegating to R268 path).

## What R271 (this file) does NOT do

* Does NOT construct `End(E)` (endomorphism ring of EC).
* Does NOT construct `End⁰(E) = End(E) ⊗ ℚ`.
* Does NOT prove Gaussian field acts on any specific EC.
* Does NOT prove EC has CM.
* Does NOT prove `CMField`.
* Does NOT prove Deligne 1982.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R271 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.CMFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.ImaginaryQuadraticFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL2.EllipticCurve

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL2

/-! ## Section 1: End⁰ action boundary interface -/

/-- **R271 End⁰ action boundary interface**. Six fields: a source
interface (R270 imaginary quadratic), a type slot for the End⁰
carrier, two Prop slots for End⁰ field / Q-algebra evidence, two
Prop markers for cohomology actions, and a compatibility marker. -/
structure EllipticCurveEnd0ActionBoundarySkeleton where
  /-- The R270 source interface (imaginary quadratic). -/
  sourceInterface :
    EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton
  /-- The End⁰ carrier type slot. -/
  end0CarrierToy : Type
  /-- Prop marker for `Field end0CarrierToy` evidence. -/
  end0FieldEvidenceToy : Prop
  /-- Prop marker for `Algebra ℚ end0CarrierToy` evidence. -/
  end0QAlgebraEvidenceToy : Prop
  /-- Prop marker for action on `H^1(E, ℚ)`. -/
  actionOnH1Toy : Prop
  /-- Prop marker for action on `H^2(E, ℚ)`. -/
  actionOnH2Toy : Prop
  /-- Prop marker for compatibility with the Gaussian field
  candidate from R267-B / R270. -/
  compatibleWithGaussianCandidateToy : Prop

/-! ## Section 2: Gaussian End⁰ boundary instance

Uses R267-B `GaussianRationalFieldCandidate` as the End⁰ carrier
slot. The Field + Q-Algebra evidence Props are bound to the
Mathlib-backed Props proved in R267-B. Cohomology actions remain
markers (no real End⁰(E) action constructed). -/

/-- **R271** Gaussian End⁰ boundary instance. -/
noncomputable def EllipticCurveEnd0ActionBoundarySkeleton_Gaussian :
    EllipticCurveEnd0ActionBoundarySkeleton where
  sourceInterface :=
    EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton_instance
  end0CarrierToy := GaussianRationalFieldCandidate
  -- Real Mathlib-backed Props (closed in R267-B but kept as
  -- Prop slots here — see R272 for the stopping rationale).
  end0FieldEvidenceToy := Nonempty (Field GaussianRationalFieldCandidate)
  end0QAlgebraEvidenceToy := Nonempty (Algebra ℚ GaussianRationalFieldCandidate)
  -- Cohomology action markers (no real End⁰ action).
  actionOnH1Toy := True
  actionOnH2Toy := True
  -- Compatibility marker (no actual ring map K → End⁰(E)).
  compatibleWithGaussianCandidateToy := True

/-! ## Section 3: combined wrapper on top of R270 -/

/-- **R271** combined wrapper bundling R270's imaginary-quadratic
candidate wrapper with R271's End⁰ boundary skeleton. -/
structure EllipticCurveCMInterfaceWithEnd0BoundarySkeleton where
  /-- The R270 imaginary-quadratic candidate wrapper. -/
  imaginaryQuadraticCandidate :
    EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton
  /-- The R271 End⁰ action boundary skeleton. -/
  end0Boundary :
    EllipticCurveEnd0ActionBoundarySkeleton

/-- **R271** concrete combined-wrapper instance. -/
noncomputable def EllipticCurveCMInterfaceWithEnd0BoundarySkeleton_instance :
    EllipticCurveCMInterfaceWithEnd0BoundarySkeleton where
  imaginaryQuadraticCandidate :=
    EllipticCurveCMInterfaceWithImaginaryQuadraticCandidateSkeleton_instance
  end0Boundary :=
    EllipticCurveEnd0ActionBoundarySkeleton_Gaussian

/-! ## Section 4: adapter to R256 + regression

R271 delegates the adapter and regression to R268 (via R270 chain).
The End⁰ boundary adds metadata only at the source side; the
abstract CM source extracted from the EC seed is unchanged. -/

/-- **R271** adapter (delegates via R268). -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveEnd0Boundary :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_from_EllipticCurveCMFieldCandidateInterface

/-- **R271** regression: HC at codim 1 for the E_7-Shimura toy
(delegates to R268). -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveEnd0Boundary :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveCMFieldCandidateInterface

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_End0ActionBoundary_To_RealEnd0EllipticCurve**: bridge to a
real `End⁰(E)` infrastructure on a specific elliptic curve. -/
def L4_G_End0ActionBoundary_To_RealEnd0EllipticCurve : Prop := True

/-- **L4-G_End0ActionBoundary_To_GaussianCMAction**: bridge to the
Gaussian field acting on a specific CM elliptic curve (e.g.
`y² = x³ - x` or `y² = x³ + 1`). -/
def L4_G_End0ActionBoundary_To_GaussianCMAction : Prop := True

/-- **L4-G_End0ActionBoundary_MissingEndomorphismRing**: `End(E)`
infrastructure absent in Mathlib. -/
def L4_G_End0ActionBoundary_MissingEndomorphismRing : Prop := True

/-- **L4-G_End0ActionBoundary_MissingTensorWithQ**: even if `End(E)`
existed, `End(E) ⊗_ℤ ℚ = End⁰(E)` would need additional rational
tensor-product infrastructure. -/
def L4_G_End0ActionBoundary_MissingTensorWithQ : Prop := True

/-- **L4-G_End0ActionBoundary_MissingCohomologyAction**: the actual
ring map `End⁰(E) → End(H¹(E, ℚ))` is absent. -/
def L4_G_End0ActionBoundary_MissingCohomologyAction : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R271 non-closure (1/5)**: does NOT construct `End(E)`. -/
theorem R271_does_not_construct_End : True := trivial

/-- **R271 non-closure (2/5)**: does NOT construct `End⁰(E)`. -/
theorem R271_does_not_construct_End0 : True := trivial

/-- **R271 non-closure (3/5)**: does NOT prove Gaussian field acts
on any specific elliptic curve. -/
theorem R271_does_not_prove_Gaussian_acts_on_EC : True := trivial

/-- **R271 non-closure (4/5)**: does NOT prove EC CM. -/
theorem R271_does_not_prove_EC_CM : True := trivial

/-- **R271 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R271_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
