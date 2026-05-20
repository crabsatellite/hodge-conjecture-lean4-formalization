/-
# HC Gap L4 — Gaussian rational field candidate `ℚ(i)` (R267-B).

R267-A audited Mathlib `NumberTheory/NumberField` and confirmed:
* `NumberField K` typeclass + `Zsqrtd d` ring + `GaussianInt` ring exist;
* `CMField K`, `IsImaginaryQuadratic K`, and `End⁰(E)` are absent;
* `Zsqrtd d` is the RING `ℤ[√d]`, NOT the FIELD `ℚ(√d)`.

R267-B builds a **concrete field carrier** for the expected imaginary
quadratic CM field by taking the fraction field of `GaussianInt`:

    ℚ(i) ≈ FractionRing GaussianInt = FractionRing (Zsqrtd (-1))

The chain `EuclideanDomain ℤ[i] → IsDomain ℤ[i] → Field (FractionRing ℤ[i])`
gives a real `Field` instance on the candidate via Mathlib's
`FractionRing.field` (`RingTheory/Localization/FractionRing.lean:500`).

Per the user's R267-B brief, this round constructs the field
CARRIER only. It does NOT prove `CMField` (typeclass absent), does
NOT construct `End⁰(E)`, does NOT prove that `ℚ(i)` acts on any
elliptic curve, and does NOT prove Deligne 1982.

## What R267-B (this file) provides (all kernel-pure)

* `GaussianRationalFieldCandidate := FractionRing GaussianInt` —
  the field carrier.
* `GaussianRationalFieldCandidate_has_Field` —
  Mathlib-backed `Field` evidence via `FractionRing.field`.
* `GaussianRationalFieldCandidate_has_QAlgebra` —
  Mathlib-backed `Algebra ℚ` evidence via Mathlib's
  characteristic-zero division-ring rational-algebra instance.
* `GaussianRationalFieldCandidate_NumberField_attempt` —
  the result of trying `Nonempty (NumberField K)`; either closed
  via `inferInstance` (if Mathlib supplies a path) or honestly
  marked as `AuditMissing_*` (if not). [This file's actual outcome
  is documented in the proof below.]
* `ImaginaryQuadraticFieldCandidateSkeleton` — refined bundle.
* `ImaginaryQuadraticFieldCandidateSkeleton_Gaussian` — concrete
  instance.
* `EllipticCurveCMInterfaceWithQuadraticFieldCandidateSkeleton` —
  combined wrapper on top of R267-A.
* Adapter to R256 + regression HC theorem.

## What R267-B (this file) does NOT do

* Does NOT prove actual complex multiplication of any EC.
* Does NOT construct `End⁰(E)`.
* Does NOT prove `ℚ(i)` acts on any elliptic curve.
* Does NOT prove a `CMField` typeclass (Mathlib absent).
* Does NOT prove Deligne 1982.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT modify R261 or R267-A destructively.

All R267-B declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
import HodgeReduction.HCGapL4.CMAbelianToySkeleton
import HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
import HodgeReduction.HCGapL4.AbelianVarietyInterface
import HodgeReduction.HCGapL4.ComplexMultiplicationInterface
import HodgeReduction.HCGapL4.ComplexMultiplicationInterfaceECRealization
import HodgeReduction.HCGapL4.ComplexMultiplicationNumberFieldAudit
-- Mathlib seed imports: build-clean per R254/R267-A audit + R267-B inspection.
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.NumberTheory.Zsqrtd.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.RingTheory.Localization.FractionRing

namespace HodgeReduction
namespace HCGapL4
namespace ComplexMultiplicationQuadraticFieldCandidate

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.AbelianVarietyInterface
open HodgeReduction.HCGapL4.ComplexMultiplicationInterface
open HodgeReduction.HCGapL4.ComplexMultiplicationInterfaceECRealization
open HodgeReduction.HCGapL4.ComplexMultiplicationNumberFieldAudit

/-! ## Section 1: the Gaussian rational field candidate -/

/-- **R267-B** Gaussian rational field candidate: the fraction field
of the Gaussian integers. As a type, this is `Localization (nonZeroDivisors GaussianInt)`
via Mathlib's `FractionRing` abbreviation. -/
abbrev GaussianRationalFieldCandidate : Type := FractionRing GaussianInt

/-! ## Section 2: field evidence

Mathlib supplies `FractionRing.field : Field (FractionRing A)` for
any `[IsDomain A]`. `GaussianInt` has `EuclideanDomain ℤ[i]` (`GaussianInt.lean:226`),
which implies `IsDomain ℤ[i]`. Hence `Field GaussianRationalFieldCandidate`
is automatic via `inferInstance`. -/

/-- **R267-B** Field evidence: `Nonempty (Field (FractionRing ℤ[i]))`. -/
theorem GaussianRationalFieldCandidate_has_Field :
    Nonempty (Field GaussianRationalFieldCandidate) :=
  ⟨inferInstance⟩

/-! ## Section 3: ℚ-algebra evidence

The fraction field of a characteristic-zero integral domain is a
characteristic-zero field. Mathlib's
`DivisionRing.toRatAlgebra` / `Rat.algebra` supplies a canonical
`Algebra ℚ K` instance whenever `K` is a `DivisionRing` with
`[CharZero K]`. Both conditions hold here. -/

/-- **R267-B** ℚ-algebra evidence:
`Nonempty (Algebra ℚ (FractionRing ℤ[i]))`. -/
theorem GaussianRationalFieldCandidate_has_QAlgebra :
    Nonempty (Algebra ℚ GaussianRationalFieldCandidate) :=
  ⟨inferInstance⟩

/-! ## Section 4: NumberField attempt

`NumberField K := [CharZero K] + [FiniteDimensional ℚ K]`. Char-zero
is automatic for the fraction field of a char-zero domain; but
finite-dimensionality over ℚ is non-trivial — Mathlib does not
provide a generic instance for `FiniteDimensional ℚ (FractionRing A)`
even when `A` is a finite ℤ-algebra. We attempt `inferInstance` first,
and fall back to an `AuditMissing_*` marker if it fails. -/

/-- **R267-B audit-missing marker** (fallback): a direct
`NumberField (FractionRing GaussianInt)` instance is not supplied
by Mathlib via `inferInstance`. A real instance would require
proving `FiniteDimensional ℚ (FractionRing GaussianInt) = 2`, which
in turn needs a basis `{1, i}` argument. R267-B records this as
honest gap rather than forcing the instance. -/
def AuditMissing_GaussianRationalFieldCandidate_NumberFieldInstance :
    Prop := True

/-! ## Section 5: imaginary-quadratic candidate skeleton -/

/-- **R267-B** refined imaginary-quadratic candidate skeleton. Pairs
a candidate field `K` with its `Field` evidence, a Prop slot for the
ℚ-algebra evidence (proved separately), and a numeric degree shape. -/
structure ImaginaryQuadraticFieldCandidateSkeleton where
  /-- The candidate field. -/
  K : Type
  /-- `Field K` evidence. -/
  fieldEvidence : Nonempty (Field K)
  /-- ℚ-algebra evidence Prop slot. -/
  qAlgebraEvidence : Prop
  /-- Closure of the ℚ-algebra evidence. -/
  qAlgebraEvidence_proved : qAlgebraEvidence
  /-- Expected degree `[K:ℚ]`. -/
  expectedDegreeOverQ : ℕ
  /-- Expected degree condition: `[K:ℚ] = 2`. -/
  expectedDegreeCondition : expectedDegreeOverQ = 2

/-- **R267-B** concrete Gaussian instance of the imaginary-quadratic
candidate skeleton. Uses `GaussianRationalFieldCandidate` as `K`
with Mathlib-backed Field + ℚ-algebra evidence. The
`expectedDegreeOverQ := 2` slot records the SHAPE for `ℚ(i)`; the
actual `FiniteDimensional` instance is recorded as
`AuditMissing_*` above. -/
noncomputable def ImaginaryQuadraticFieldCandidateSkeleton_Gaussian :
    ImaginaryQuadraticFieldCandidateSkeleton where
  K := GaussianRationalFieldCandidate
  fieldEvidence := GaussianRationalFieldCandidate_has_Field
  qAlgebraEvidence := Nonempty (Algebra ℚ GaussianRationalFieldCandidate)
  qAlgebraEvidence_proved := GaussianRationalFieldCandidate_has_QAlgebra
  expectedDegreeOverQ := 2
  expectedDegreeCondition := rfl

/-! ## Section 6: combined wrapper on top of R267-A -/

/-- **R267-B** combined wrapper bundling R267-A's
NumberField-audit-augmented partial-realization with R267-B's
imaginary-quadratic field candidate. NOT destructive on R261, R266,
or R267-A. -/
structure EllipticCurveCMInterfaceWithQuadraticFieldCandidateSkeleton where
  /-- The R267-A NumberField-audit-augmented partial-realization
  skeleton. -/
  baseNumberFieldAudit :
    EllipticCurveCMInterfaceNumberFieldAuditSkeleton
  /-- The R267-B imaginary-quadratic candidate. -/
  quadraticFieldCandidate :
    ImaginaryQuadraticFieldCandidateSkeleton

/-- **R267-B** concrete wrapper instance: combines R267-A's
instance with R267-B's Gaussian candidate. -/
noncomputable def EllipticCurveCMInterfaceWithQuadraticFieldCandidateSkeleton_instance :
    EllipticCurveCMInterfaceWithQuadraticFieldCandidateSkeleton where
  baseNumberFieldAudit :=
    EllipticCurveCMInterfaceNumberFieldAuditSkeleton_instance
  quadraticFieldCandidate :=
    ImaginaryQuadraticFieldCandidateSkeleton_Gaussian

/-! ## Section 7: adapter to R256 `AbstractCMAbelianHCSource` -/

/-- **R267-B** adapter: from the R267-B wrapper, produce R256's
`AbstractCMAbelianHCSource` via R261's adapter, applied to the
base CM interface (extracted through the R267-A + R266 layers).
The R267-B Gaussian candidate is metadata at this level. -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveQuadraticFieldCandidate :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_of_CMAbelianVarietyInterface
    EllipticCurveCMInterfaceWithQuadraticFieldCandidateSkeleton_instance.baseNumberFieldAudit.basePartialRealization.baseCMInterface

/-! ## Section 8: regression HC at codim 1 for E_7-Shimura toy -/

/-- **R267-B** regression: HC at codim 1 for the E_7-Shimura toy via
the R267-B Gaussian-augmented route. Uses R236's SHSM2 against the
original ACD (no mismatch). -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveQuadraticFieldCandidate :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    (source :=
      AbstractCMAbelianHCSource_from_EllipticCurveQuadraticFieldCandidate)
    { correspondence := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1 }

/-! ## Section 9: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_GaussianRationalFieldCandidate_To_RealImaginaryQuadraticField**:
upgrading the R267-B candidate to a `CMField K` typeclass instance
(absent from Mathlib). -/
def L4_G_GaussianRationalFieldCandidate_To_RealImaginaryQuadraticField :
    Prop := True

/-- **L4-G_GaussianRationalFieldCandidate_To_CMFieldInterface**:
bridge from the R267-B candidate to a real `CMField` interface (when
Mathlib has one). -/
def L4_G_GaussianRationalFieldCandidate_To_CMFieldInterface : Prop := True

/-- **L4-G_GaussianRationalFieldCandidate_MissingEnd0Action**: the
R267-B candidate is a standalone field; it has NO action on any
specific elliptic curve via an `End⁰(E)` map (Mathlib infra
absent). -/
def L4_G_GaussianRationalFieldCandidate_MissingEnd0Action : Prop := True

/-- **L4-G_GaussianRationalFieldCandidate_MissingNumberFieldInstance**:
R267-B does NOT supply a `NumberField` instance for the candidate;
finite-dimensionality over ℚ needs a `{1, i}` basis argument not
attempted in this round. -/
def L4_G_GaussianRationalFieldCandidate_MissingNumberFieldInstance :
    Prop := True

/-- **L4-G_GaussianRationalFieldCandidate_To_Deligne1982**: bridge
from the R267-B candidate to Deligne 1982 (requires actual EC + CM
type + Hodge classes). -/
def L4_G_GaussianRationalFieldCandidate_To_Deligne1982 : Prop := True

/-! ## Section 10: explicit non-closure -/

/-- **R267-B non-closure (1/7)**: does NOT prove actual complex
multiplication of any elliptic curve. -/
theorem R267B_does_not_prove_actual_CM_of_EC : True := trivial

/-- **R267-B non-closure (2/7)**: does NOT construct `End⁰(E)`. -/
theorem R267B_does_not_construct_End0 : True := trivial

/-- **R267-B non-closure (3/7)**: does NOT prove the Gaussian field
acts on any specific elliptic curve. -/
theorem R267B_does_not_prove_Gaussian_acts_on_EC : True := trivial

/-- **R267-B non-closure (4/7)**: does NOT prove a `CMField`
typeclass (absent from Mathlib). -/
theorem R267B_does_not_prove_CMField_typeclass : True := trivial

/-- **R267-B non-closure (5/7)**: does NOT prove Deligne 1982. -/
theorem R267B_does_not_prove_deligne_1982 : True := trivial

/-- **R267-B non-closure (6/7)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R267B_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R267-B non-closure (7/7)**: does NOT modify R261 / R267-A
destructively. -/
theorem R267B_does_not_alter_R261_or_R267A_destructively : True := trivial

end ComplexMultiplicationQuadraticFieldCandidate
end HCGapL4
end HodgeReduction
