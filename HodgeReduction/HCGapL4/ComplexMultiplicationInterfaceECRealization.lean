/-
# HC Gap L4 — partial EC realization of CM interface (R266).

R261 introduced `ComplexMultiplicationInterfaceSkeleton` with four
Prop slots (`hasAlgebraStructureToy`, `hasCMFieldToy`,
`rankConditionToy`, `actsOnCohomologyToy`). The dim-1 EC-like seed
instance set all four to `True` and used `ℚ` as the placeholder
endomorphism algebra (`endomorphismAlgebraToy := ℚ`).

R266 reduces the two low-risk slots using Mathlib-backed evidence:

* `hasAlgebraStructureToy` ← evidence that `ℚ` has a `Field` instance
  and a `Algebra ℚ ℚ` instance.
* `actsOnCohomologyToy` ← evidence that ℚ acts (by scalar
  multiplication) on the EC toy cohomology carriers
  `EllipticCurve.VarietyCohomologyData_ellipticCurve.H k` for
  `k = 1, 2` (i.e., `ℚ × ℚ` and `ℚ`).

The two genuinely CM-specific slots (`hasCMFieldToy`,
`rankConditionToy`) remain `True` markers in R261 — a generic EC is
NOT CM, and forging CM evidence would violate the
"don't claim CM" constraint.

Per the user's R266 brief, this is interface-level scalar-action
evidence, NOT a real `End⁰(E)` algebra. The construction is
additive: R261's CM-like seed instance is unchanged; R266 adds a
parallel `PartialRealization` skeleton.

## What R266 (this file) provides (all kernel-pure)

* `rationalEndomorphismAlgebraEvidence_for_EC_CMInterface_proved` —
  `Nonempty (Field ℚ)`.
* `rationalEndomorphismAlgebra_has_QAlgebraEvidence_proved` —
  `Nonempty (Algebra ℚ ℚ)`.
* `ellipticCurve_H1_has_QModule_for_CMInterface` — `ℚ`-module
  evidence on the EC toy `H 1` carrier.
* `ellipticCurve_H2_has_QModule_for_CMInterface` — `ℚ`-module
  evidence on the EC toy `H 2` carrier.
* `EllipticCurveCMInterfacePartialRealizationSkeleton` — refined
  bundle with proof-producing fields paired with their closures.
* `EllipticCurveCMInterfacePartialRealizationSkeleton_instance` —
  concrete ℚ-instance.
* `AbstractCMAbelianHCSource_from_EllipticCurveCMPartialRealization`
  — adapter to R256 via R261 path.
* `VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveCMPartialRealization`
  — regression HC theorem at codim 1.

## What R266 (this file) does NOT do

* Does NOT prove actual complex multiplication.
* Does NOT construct `End⁰(E)` (the real rational endomorphism
  algebra of an elliptic curve).
* Does NOT prove the CM field degree condition `[K : ℚ] = 2 · dim A`.
* Does NOT prove Deligne 1982.
* Does NOT replace `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT modify R261's original CM-like seed instance destructively.

All R266 declarations are kernel-pure: `{propext, Classical.choice,
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

namespace HodgeReduction
namespace HCGapL4
namespace ComplexMultiplicationInterfaceECRealization

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2
open HodgeReduction.HCGapL4.CMAbelianToySkeleton
open HodgeReduction.HCGapL4.MTCorrespondenceReplacementNextTarget
open HodgeReduction.HCGapL4.AbelianVarietyInterface
open HodgeReduction.HCGapL4.ComplexMultiplicationInterface

/-! ## Section 1: algebra-structure evidence

Replaces R261's `hasAlgebraStructureToy := True` with two
Mathlib-backed witnesses for the placeholder endomorphism algebra `ℚ`:
* ℚ has a `Field` instance;
* ℚ has an `Algebra ℚ ℚ` instance (the canonical self-algebra). -/

/-- **R266** Prop alias: ℚ has a `Field` instance. -/
def rationalEndomorphismAlgebraEvidence_for_EC_CMInterface : Prop :=
  Nonempty (Field ℚ)

/-- **R266** closure: `inferInstance` recovers Mathlib's `Field ℚ`. -/
theorem rationalEndomorphismAlgebraEvidence_for_EC_CMInterface_proved :
    rationalEndomorphismAlgebraEvidence_for_EC_CMInterface :=
  ⟨inferInstance⟩

/-- **R266** Prop alias: ℚ is a ℚ-algebra (self-algebra). -/
def rationalEndomorphismAlgebra_has_QAlgebraEvidence : Prop :=
  Nonempty (Algebra ℚ ℚ)

/-- **R266** closure: `inferInstance` recovers Mathlib's `Algebra.id ℚ`. -/
theorem rationalEndomorphismAlgebra_has_QAlgebraEvidence_proved :
    rationalEndomorphismAlgebra_has_QAlgebraEvidence :=
  ⟨inferInstance⟩

/-! ## Section 2: scalar action on cohomology evidence

Replaces R261's `actsOnCohomologyToy := True` with Mathlib-backed
witnesses that ℚ (the placeholder endomorphism algebra) acts on the
EC toy cohomology carriers
`EllipticCurve.VarietyCohomologyData_ellipticCurve.H k` at the two
non-trivial codim degrees `k = 1, 2`.

Carrier inspection: `EllipticCurve.cohomologyType_ellipticCurve k` is
`ℚ` for k=0, `ℚ × ℚ` for k=1, `ℚ` for k=2, `PUnit` for k≥3. The
ℚ-module instances are supplied by the VCD's bundled `module` field. -/

/-- **R266** evidence that ℚ acts on the EC toy `H 1 = ℚ × ℚ` as a
ℚ-module. -/
theorem ellipticCurve_H1_has_QModule_for_CMInterface :
    Nonempty (Module ℚ (EllipticCurve.VarietyCohomologyData_ellipticCurve.H 1)) :=
  ⟨EllipticCurve.VarietyCohomologyData_ellipticCurve.module 1⟩

/-- **R266** evidence that ℚ acts on the EC toy `H 2 = ℚ` as a
ℚ-module. -/
theorem ellipticCurve_H2_has_QModule_for_CMInterface :
    Nonempty (Module ℚ (EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2)) :=
  ⟨EllipticCurve.VarietyCohomologyData_ellipticCurve.module 2⟩

/-! ## Section 3: refined CM partial-realization evidence skeleton -/

/-- **R266** refined CM partial-realization bundle. Each evidence
field is paired with its closure proof, so the skeleton itself
certifies kernel-pure availability of each evidence claim. -/
structure EllipticCurveCMInterfacePartialRealizationSkeleton where
  /-- The R261 CM-like seed CM interface. -/
  baseCMInterface : CMAbelianVarietyInterfaceSkeleton
  /-- Algebra-structure evidence (Prop slot). -/
  algebraStructureEvidence : Prop
  /-- Closure of the algebra-structure evidence. -/
  algebraStructureEvidence_proved : algebraStructureEvidence
  /-- Scalar action on H 1 evidence. -/
  actsOnH1Evidence : Prop
  /-- Closure of the H 1 action evidence. -/
  actsOnH1Evidence_proved : actsOnH1Evidence
  /-- Scalar action on H 2 evidence. -/
  actsOnH2Evidence : Prop
  /-- Closure of the H 2 action evidence. -/
  actsOnH2Evidence_proved : actsOnH2Evidence

/-! ## Section 4: instantiate refined CM partial-realization -/

/-- **R266** concrete instance: uses R261 CM-like seed + ℚ-algebra
evidence + ℚ-action on EC toy `H 1` and `H 2`. -/
noncomputable def EllipticCurveCMInterfacePartialRealizationSkeleton_instance :
    EllipticCurveCMInterfacePartialRealizationSkeleton where
  baseCMInterface := CMAbelianVarietyInterfaceSkeleton_ellipticCurveLike
  algebraStructureEvidence := rationalEndomorphismAlgebra_has_QAlgebraEvidence
  algebraStructureEvidence_proved :=
    rationalEndomorphismAlgebra_has_QAlgebraEvidence_proved
  actsOnH1Evidence :=
    Nonempty (Module ℚ (EllipticCurve.VarietyCohomologyData_ellipticCurve.H 1))
  actsOnH1Evidence_proved := ellipticCurve_H1_has_QModule_for_CMInterface
  actsOnH2Evidence :=
    Nonempty (Module ℚ (EllipticCurve.VarietyCohomologyData_ellipticCurve.H 2))
  actsOnH2Evidence_proved := ellipticCurve_H2_has_QModule_for_CMInterface

/-! ## Section 5: adapter to R256 `AbstractCMAbelianHCSource` -/

/-- **R266** adapter: from the R266 partial-realization skeleton,
produce R256's `AbstractCMAbelianHCSource` via R261's existing
adapter applied to the wrapper's `baseCMInterface`. The R266
evidence strengthens the interface claim without altering the
adapter output. -/
noncomputable def AbstractCMAbelianHCSource_from_EllipticCurveCMPartialRealization :
    AbstractCMAbelianHCSource :=
  AbstractCMAbelianHCSource_of_CMAbelianVarietyInterface
    EllipticCurveCMInterfacePartialRealizationSkeleton_instance.baseCMInterface

/-! ## Section 6: regression HC at codim 1 for E_7-Shimura toy -/

/-- **R266** regression: HC at codim 1 for the E_7-Shimura toy via
the R266 partial-realization route. Uses R236's SHSM2 against the
original ACD (no mismatch). -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_EllipticCurveCMPartialRealization :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_of_AbstractCMAbelianHCSource_and_MTCorrespondence
    (source := AbstractCMAbelianHCSource_from_EllipticCurveCMPartialRealization)
    { correspondence := SHSM2_ellipticCurve_to_E7ShimuraToy_codim1_to_codim1 }

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ECCMPartialRealization_To_CMInterface**: the bridge from
R266's partial-realization skeleton back to R261's
`CMAbelianVarietyInterfaceSkeleton`. -/
def L4_G_ECCMPartialRealization_To_CMInterface : Prop := True

/-- **L4-G_ECCMPartialRealization_RationalEndomorphismAlgebraOnly**:
R266 uses ℚ as the placeholder endomorphism algebra. This matches
the generic (non-CM) EC case where `End⁰(E) = ℚ`. Real CM elliptic
curves have `End⁰(E)` equal to an imaginary quadratic field —
deferred. -/
def L4_G_ECCMPartialRealization_RationalEndomorphismAlgebraOnly :
    Prop := True

/-- **L4-G_ECCMPartialRealization_MissingActualCMField**: R266 does
NOT construct an actual CM field (imaginary quadratic field for
dim-1 EC, or CM field of degree `2 · dim A` for higher dim). -/
def L4_G_ECCMPartialRealization_MissingActualCMField : Prop := True

/-- **L4-G_ECCMPartialRealization_MissingRankCondition**: R266 does
NOT prove the rank condition `[K : ℚ] = 2 · dim A`. -/
def L4_G_ECCMPartialRealization_MissingRankCondition : Prop := True

/-- **L4-G_ECCMPartialRealization_MissingTrueEnd0**: R266 does NOT
construct the actual rational endomorphism algebra `End⁰(E)` of an
elliptic curve (which would require Mathlib's elliptic-curve
endomorphism / isogeny infrastructure, currently absent for higher
dim and partial for dim 1). -/
def L4_G_ECCMPartialRealization_MissingTrueEnd0 : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R266 non-closure (1/6)**: does NOT prove actual complex
multiplication. -/
theorem R266_does_not_prove_actual_CM : True := trivial

/-- **R266 non-closure (2/6)**: does NOT construct `End⁰(E)`. -/
theorem R266_does_not_construct_End0 : True := trivial

/-- **R266 non-closure (3/6)**: does NOT prove the CM field rank
condition. -/
theorem R266_does_not_prove_rank_condition : True := trivial

/-- **R266 non-closure (4/6)**: does NOT prove Deligne 1982. -/
theorem R266_does_not_prove_deligne_1982 : True := trivial

/-- **R266 non-closure (5/6)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R266_does_not_close_canonicalE7ShimuraTor : True := trivial

/-- **R266 non-closure (6/6)**: does NOT modify R261's original
CM-like seed instance destructively. -/
theorem R266_does_not_alter_R261_destructively : True := trivial

end ComplexMultiplicationInterfaceECRealization
end HCGapL4
end HodgeReduction
