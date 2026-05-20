/-
# HC Gap L4 — NumberField chain integration (R283).

R280–R282 produced the following state on the NumberField construction
chain for `GaussianRationalFieldCandidate = FractionRing GaussianInt`:

**Closed (R280 — AdjoinRoot side)**:
* `(AdjoinRoot.root (X²+1))² + 1 = 0`.
* `FiniteDimensional ℚ (AdjoinRoot (X²+1))`.
* `Module.finrank ℚ (AdjoinRoot (X²+1)) = 2`.

**Closed (R281 — partial AlgEquiv pieces)**:
* `(gaussianRationalI)² = -1` in the fraction field.
* `aeval gaussianRationalI (X²+1) = 0`.
* Forward AlgHom `AdjoinRoot (X²+1) →ₐ[ℚ] GaussianRationalFieldCandidate`.
* Reverse ring hom `GaussianInt →+* AdjoinRoot (X²+1)`.

**Still open**:
* Full `AlgEquiv GaussianRationalFieldCandidate ≃ₐ[ℚ] AdjoinRoot (X²+1)`.
* `FiniteDimensional ℚ GaussianRationalFieldCandidate`.
* `NumberField GaussianRationalFieldCandidate`.
* `finrank ℚ GaussianRationalFieldCandidate = 2`.

**Smallest minimal blockers identified (R281 + R282)**:
* `Irreducible (X²+1 : ℚ[X])` (for `AdjoinRoot.instField`).
* Gaussian rational normal form `z = p + q·i`.
* Denominator rationalization `1/(c+d·i) = (c-d·i)/(c²+d²)`.
* ℚ-linear independence of `{1, i}` in the fraction field.

R283 integrates this state into the CM chain (R275/R276/R278) and
provides the precise continuation plan.

## What R283 (this file) provides (all kernel-pure)

* `GaussianNumberFieldChainStatusSkeleton` — combined status structure.
* `GaussianNumberFieldChainStatusSkeleton_current` — current instance.
* `ImaginaryQuadraticInterfaceWithNumberFieldStatusSkeleton` —
  updated wrapper for R275.
* `CMFieldRealizationWithNumberFieldStatusSkeleton` — updated wrapper
  for R276.
* Regression HC theorem (delegates to R268).
* Continuation ranking markers (smallest blockers first).

## What R283 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT claim NumberField if still unproved.
* Only integrates current NumberField status.

All R283 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianRationalAdjoinRoot
import HodgeReduction.HCGapL4.GaussianRationalAdjoinRootEquiv
import HodgeReduction.HCGapL4.GaussianRationalBasisOneI
import HodgeReduction.HCGapL4.ImaginaryQuadraticFieldRealizationInterface
import HodgeReduction.HCGapL4.CMFieldRealizationInterface
import HodgeReduction.HCGapL4.CMFieldChainIntegration
import HodgeReduction.HCGapL4.GaussianRationalConjugationLift

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier

/-! ## Section 1: combined status skeleton -/

/-- **R283 combined NumberField chain status**. Captures the
closed/open state of every link in the chain. -/
structure GaussianNumberFieldChainStatusSkeleton where
  /-- Field carrier closed (R267-B). -/
  fieldClosed : Prop
  /-- Q-Algebra carrier closed (R267-B). -/
  qAlgebraClosed : Prop
  /-- Conjugation closed (R279). -/
  conjugationClosed : Prop
  /-- AdjoinRoot-side finite-dimensional closed (R280). -/
  adjoinRootFiniteDimensionalClosed : Prop
  /-- AdjoinRoot-side `finrank = 2` closed (R280). -/
  adjoinRootFinrankTwoClosed : Prop
  /-- Forward AlgHom `AdjoinRoot → FractionRing` closed (R281). -/
  forwardAlgHomClosed : Prop
  /-- Reverse ring hom `GaussianInt → AdjoinRoot` closed (R281). -/
  reverseRingHomOnIntegersClosed : Prop
  /-- `FiniteDimensional ℚ GaussianRationalFieldCandidate` (still
  open). -/
  finiteDimensionalClosedOrTarget : Prop
  /-- `NumberField GaussianRationalFieldCandidate` (still open). -/
  numberFieldClosedOrTarget : Prop
  /-- `finrank ℚ GaussianRationalFieldCandidate = 2` (still open). -/
  finrankTwoClosedOrTarget : Prop
  /-- Next blocking lemma (smallest). -/
  nextBlockingLemma : Prop

/-- **R283** current chain status. -/
noncomputable def GaussianNumberFieldChainStatusSkeleton_current :
    GaussianNumberFieldChainStatusSkeleton where
  -- Already-closed pieces (real evidence Props from upstream rounds).
  fieldClosed := Nonempty
    (Field ComplexMultiplicationQuadraticFieldCandidate.GaussianRationalFieldCandidate)
  qAlgebraClosed := Nonempty
    (Algebra ℚ ComplexMultiplicationQuadraticFieldCandidate.GaussianRationalFieldCandidate)
  conjugationClosed :=
    Function.Involutive GaussianRationalFieldCandidate_conj
  adjoinRootFiniteDimensionalClosed :=
    FiniteDimensional ℚ GaussianAdjoinRootCandidate
  adjoinRootFinrankTwoClosed :=
    Module.finrank ℚ GaussianAdjoinRootCandidate = 2
  forwardAlgHomClosed := Nonempty
    (GaussianAdjoinRootCandidate →ₐ[ℚ]
      ComplexMultiplicationQuadraticFieldCandidate.GaussianRationalFieldCandidate)
  reverseRingHomOnIntegersClosed := Nonempty
    (GaussianInt →+* GaussianAdjoinRootCandidate)
  -- Still-open pieces (targets).
  finiteDimensionalClosedOrTarget := Target_R273_FiniteDimensional
  numberFieldClosedOrTarget := Target_R273_NumberField
  finrankTwoClosedOrTarget := Target_R273_finrank_eq_two
  nextBlockingLemma := BlockingLemma_R281_X_sq_add_one_irreducible_over_Q

/-! ## Section 2: updated imaginary quadratic wrapper -/

/-- **R283** updated wrapper on R275's imaginary quadratic interface,
attaching the R283 chain status. -/
structure ImaginaryQuadraticInterfaceWithNumberFieldStatusSkeleton where
  /-- The R275 imaginary quadratic realization interface. -/
  baseImaginaryQuadratic :
    ImaginaryQuadraticFieldRealizationInterfaceSkeleton
  /-- The R283 chain status. -/
  numberFieldStatus : GaussianNumberFieldChainStatusSkeleton

/-- **R283** Gaussian instance. -/
noncomputable def ImaginaryQuadraticInterfaceWithNumberFieldStatusSkeleton_Gaussian :
    ImaginaryQuadraticInterfaceWithNumberFieldStatusSkeleton where
  baseImaginaryQuadratic :=
    ImaginaryQuadraticFieldInterfaceRealizationSkeleton_Gaussian
  numberFieldStatus :=
    GaussianNumberFieldChainStatusSkeleton_current

/-! ## Section 3: updated CMField realization wrapper -/

/-- **R283** updated wrapper on R276's CMField realization. -/
structure CMFieldRealizationWithNumberFieldStatusSkeleton where
  /-- The R276 CMField realization interface. -/
  baseCMFieldRealization : CMFieldRealizationInterfaceSkeleton
  /-- The R283 chain status. -/
  numberFieldStatus : GaussianNumberFieldChainStatusSkeleton

/-- **R283** Gaussian instance. -/
noncomputable def CMFieldRealizationWithNumberFieldStatusSkeleton_Gaussian :
    CMFieldRealizationWithNumberFieldStatusSkeleton where
  baseCMFieldRealization := CMFieldRealizationInterfaceSkeleton_Gaussian
  numberFieldStatus := GaussianNumberFieldChainStatusSkeleton_current

/-! ## Section 4: regression HC theorem -/

/-- **R283** regression: HC at codim 1 for E_7-Shimura toy through
the updated chain. Delegates to R278's chain regression. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_GaussianNumberFieldChainStatus :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_CMFieldChainIntegration

/-! ## Section 5: continuation ranking — smallest blockers first

After R280–R282, the remaining blockers to `NumberField
GaussianRationalFieldCandidate` rank from smallest to largest:

1. **Smallest**: prove `Irreducible (X²+1 : ℚ[X])` — closes the
   AdjoinRoot field path. Mathlib has tools for irreducibility of
   `X²+a` when `a` is not a square in the base field; `-1` is not
   a square in ℚ via `Rat.not_isSquare_neg_one` style.

2. **Medium**: build `IsLocalization.lift` from the R281 reverse
   ring hom `GaussianInt → AdjoinRoot (X²+1)` to a fraction-field
   map `FractionRing GaussianInt → AdjoinRoot (X²+1)`. Requires
   `AdjoinRoot (X²+1)` to be a field (from (1)).

3. **Largest**: prove forward+reverse are mutual inverses, getting
   `AlgEquiv`.

4. **Direct alternative**: build the basis `{1, i}` directly. Needs
   normal-form lemma which requires fraction-field manipulation
   tools not directly in Mathlib for `Zsqrtd`-typed fractions. -/

/-- **R283 ranked next target 1**: prove
`Irreducible (X²+1 : ℚ[X])`. SMALLEST blocker, easiest path. -/
def R283_NextTarget_X_sq_add_one_irreducible : Prop :=
  Irreducible GaussianPolynomialOverQ

/-- **R283 ranked next target 2**: lift R281 reverse ring hom to
fraction field. Requires (1). -/
def R283_NextTarget_ReverseFractionLift : Prop :=
  Target_GaussianRational_to_GaussianAdjoinRoot

/-- **R283 ranked next target 3**: prove the AlgEquiv. Requires
(1) + (2) + inverse compatibility. -/
def R283_NextTarget_AlgEquiv : Prop :=
  Target_GaussianRationalFieldCandidate_AlgEquiv_AdjoinRoot

/-- **R283 alternative next target**: direct basis construction.
Requires Gaussian rational normal form. -/
def R283_AlternativeNextTarget_DirectBasis : Prop :=
  Target_GaussianRational_basis_one_i

/-! ## Section 6: explicit continuation markers -/

/-- **R283** entry marker for the smallest next blocker
(irreducibility). -/
def R283_NextTarget_AfterNumberFieldAudit : Prop := True

/-- **R283** marker: pursuing the AdjoinRoot AlgEquiv path. -/
def R283_NextTarget_AdjoinRootEquiv : Prop := True

/-- **R283** marker: pursuing the normal-form path (R282
fallback). -/
def R283_NextTarget_NormalForm : Prop := True

/-- **R283** marker: pursuing the rationalization path (R282
fallback). -/
def R283_NextTarget_Rationalization : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R283 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R283_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R283 non-closure (2/5)**: does NOT claim `NumberField` if
still unproved. -/
theorem R283_does_not_claim_unproved_NumberField : True := trivial

/-- **R283 non-closure (3/5)**: does NOT prove `FiniteDimensional ℚ
GaussianRationalFieldCandidate`. -/
theorem R283_does_not_prove_finiteDimensional : True := trivial

/-- **R283 non-closure (4/5)**: does NOT prove finrank = 2. -/
theorem R283_does_not_prove_finrank_eq_two : True := trivial

/-- **R283 non-closure (5/5)**: only integrates the current
NumberField status; the smallest blocker is irreducibility. -/
theorem R283_only_integrates_status : True := trivial

end HCGapL4
end HodgeReduction
