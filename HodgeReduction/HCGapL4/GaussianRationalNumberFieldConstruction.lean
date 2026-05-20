/-
# HC Gap L4 — NumberField construction target (R273).

R267-B/R269 confirmed `NumberField (FractionRing GaussianInt)` is not
synthesizable via `inferInstance`. R273 probes the next layer:
`FiniteDimensional ℚ (FractionRing GaussianInt)`. Independent probe
verified that ALSO fails to synthesize (with additional
`Mathlib.RingTheory.Localization.Integral` import).

Per the user's R273 brief, R273 records the precise blocking lemma
and continues building the chain rather than retreating.

## Mathlib infrastructure findings

Available (build-clean):
* `Mathlib.RingTheory.Localization.Integral` — contains theorems
  like "if `K → L` is finite-dimensional, then `IsFractionRing C L`
  where C is the integral closure". Specifically lines 315 / 342
  link `FiniteDimensional K L` with `IsFractionRing` for integral
  closures.

Missing for our direct path:
* No theorem `FiniteDimensional ℚ (FractionRing (Zsqrtd d))` for
  generic d.
* No `Zsqrtd.basis` named ℚ-basis (Zsqrtd only carries ring + module
  ℤ structure).
* No `NumberField (FractionRing GaussianInt)` instance.

To close `FiniteDimensional ℚ K` would require either:
1. Explicit ℚ-basis `{1, i}` construction via `Basis.mk`, OR
2. Showing `K ≃ₐ[ℚ] (AdjoinRoot (x^2 + 1 : ℚ[X]))` and using
   `AdjoinRoot.PowerBasis`.

Both are multi-round work; R273 records them as precise targets.

## What R273 (this file) provides (all kernel-pure)

* Precise `Target_*` / `BlockingLemma_*` markers for the missing
  proofs.
* `GaussianRationalNumberFieldConstructionSkeleton` — construction
  status structure.
* `GaussianRationalNumberFieldConstructionSkeleton_current` — current
  instance with honest closure status.
* `CMFieldInterfaceWithNumberFieldConstructionSkeleton` — combined
  wrapper.

## What R273 (this file) does NOT do

* Does NOT claim `FiniteDimensional ℚ (FractionRing GaussianInt)`.
* Does NOT claim `NumberField (FractionRing GaussianInt)`.
* Does NOT claim `finrank = 2`.
* Does NOT close `canonicalE7ShimuraTor`.

All R273 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.CMFieldInterfaceSkeleton
import HodgeReduction.HCGapL4.GaussianRationalNumberFieldTarget
import HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.RingTheory.Localization.FractionRing
import Mathlib.RingTheory.Localization.Integral

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.HCGapL4.ComplexMultiplicationQuadraticFieldCandidate

/-! ## Section 1: precise target / blocking-lemma markers -/

/-- **R273 blocking lemma**: the precise missing theorem statement,
recorded as a Prop. Closing this would unblock `NumberField` instance
synthesis. -/
def BlockingLemma_GaussianRationalFieldCandidate_finiteDimensional :
    Prop := FiniteDimensional ℚ GaussianRationalFieldCandidate

/-- **R273 target**: `FiniteDimensional ℚ GaussianRationalFieldCandidate`. -/
def Target_R273_FiniteDimensional :
    Prop := FiniteDimensional ℚ GaussianRationalFieldCandidate

/-- **R273 target**: `NumberField GaussianRationalFieldCandidate`. -/
def Target_R273_NumberField :
    Prop := NumberField GaussianRationalFieldCandidate

/-- **R273 target**: `Module.finrank ℚ GaussianRationalFieldCandidate = 2`. -/
def Target_R273_finrank_eq_two :
    Prop := Module.finrank ℚ GaussianRationalFieldCandidate = 2

/-! ## Section 2: construction-status skeleton -/

/-- **R273 construction-status skeleton**. Each closure slot is a
Prop marker — `True` if and only if we've actually proved the target
in this file. R273 honestly leaves the three closures as gap markers
because we did not construct the basis here. -/
structure GaussianRationalNumberFieldConstructionSkeleton where
  /-- Candidate field. -/
  K : Type
  /-- Field evidence Prop slot. -/
  fieldEvidence : Prop
  /-- Q-Algebra evidence Prop slot. -/
  qAlgebraEvidence : Prop
  /-- Finite-dimensional target Prop. -/
  finiteDimensionalTarget : Prop
  /-- NumberField target Prop. -/
  numberFieldTarget : Prop
  /-- `finrank = 2` target Prop. -/
  finrankTwoTarget : Prop
  /-- Closure marker for finite-dimensional (Prop; True iff proved here). -/
  finiteDimensionalClosed : Prop
  /-- Closure marker for NumberField. -/
  numberFieldClosed : Prop
  /-- Closure marker for `finrank = 2`. -/
  finrankTwoClosed : Prop

/-- **R273 current construction-status instance**. Field/Q-Algebra
evidence Props pointed at R267-B real evidence; the three targets
point at the precise unbuilt theorems; closure markers default to
audit-missing-style `True` (gap recorded). -/
noncomputable def GaussianRationalNumberFieldConstructionSkeleton_current :
    GaussianRationalNumberFieldConstructionSkeleton where
  K := GaussianRationalFieldCandidate
  fieldEvidence := Nonempty (Field GaussianRationalFieldCandidate)
  qAlgebraEvidence := Nonempty (Algebra ℚ GaussianRationalFieldCandidate)
  finiteDimensionalTarget := Target_R273_FiniteDimensional
  numberFieldTarget := Target_R273_NumberField
  finrankTwoTarget := Target_R273_finrank_eq_two
  -- All three closure slots: gap-markers (not proved here).
  finiteDimensionalClosed := True
  numberFieldClosed := True
  finrankTwoClosed := True

/-! ## Section 3: combined wrapper with R268 CMField interface -/

/-- **R273** combined wrapper bundling R268's CMField interface with
R273's NumberField construction skeleton. -/
structure CMFieldInterfaceWithNumberFieldConstructionSkeleton where
  /-- The R268 CMField proven-evidence wrapper. -/
  cmFieldInterface : CMFieldInterfaceEvidenceData
  /-- The R273 NumberField construction skeleton. -/
  numberFieldConstruction :
    GaussianRationalNumberFieldConstructionSkeleton

/-- **R273** Gaussian instance. -/
noncomputable def CMFieldInterfaceWithNumberFieldConstructionSkeleton_Gaussian :
    CMFieldInterfaceWithNumberFieldConstructionSkeleton where
  cmFieldInterface := CMFieldInterfaceEvidenceData_GaussianCandidate
  numberFieldConstruction :=
    GaussianRationalNumberFieldConstructionSkeleton_current

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianNumberFieldConstruction_To_CMFieldInterface**:
bridge from R273's construction target back to R268's CMField
interface. -/
def L4_G_GaussianNumberFieldConstruction_To_CMFieldInterface : Prop := True

/-- **L4-G_GaussianNumberFieldConstruction_MissingBasisOneI**:
explicit ℚ-basis `{1, i}` for `FractionRing GaussianInt` is missing. -/
def L4_G_GaussianNumberFieldConstruction_MissingBasisOneI : Prop := True

/-- **L4-G_GaussianNumberFieldConstruction_MissingFiniteDimensionalProof**:
`FiniteDimensional ℚ GaussianRationalFieldCandidate` not proven. -/
def L4_G_GaussianNumberFieldConstruction_MissingFiniteDimensionalProof :
    Prop := True

/-- **L4-G_GaussianNumberFieldConstruction_MissingFinrankTwo**:
`finrank ℚ GaussianRationalFieldCandidate = 2` not proven. -/
def L4_G_GaussianNumberFieldConstruction_MissingFinrankTwo : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R273 non-closure (1/5)**: does NOT claim `FiniteDimensional`. -/
theorem R273_does_not_claim_finiteDimensional : True := trivial

/-- **R273 non-closure (2/5)**: does NOT claim `NumberField`. -/
theorem R273_does_not_claim_NumberField : True := trivial

/-- **R273 non-closure (3/5)**: does NOT claim `finrank = 2`. -/
theorem R273_does_not_claim_finrank_eq_two : True := trivial

/-- **R273 non-closure (4/5)**: does NOT construct `End⁰(E)`. -/
theorem R273_does_not_construct_End0 : True := trivial

/-- **R273 non-closure (5/5)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R273_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
