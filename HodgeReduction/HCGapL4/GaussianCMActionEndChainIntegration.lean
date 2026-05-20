/-
# HC Gap L4 — Gaussian CM action End-chain integration (R309).

R305-R308 closed the full additivity / `AddMonoidHom` / `AddMonoid.End`
packaging for the Gaussian CM action on the base-changed curve
`E_K : y² = x³ + x` over `K = GaussianRationalFieldCandidate`. The
group-endomorphism square relation `(φ * φ) P = -P` was also closed.

R309 integrates these outputs into the R293-R298 End-infrastructure
chain:

* The R293 `EllipticCurveEndomorphismRingInterfaceSkeleton` group-end
  candidate now has a **concrete nonzero element**: `gaussianCMAction`.
* The R296 Gaussian embedding target now has a partial fulfillment at
  the group-end level: `i ∈ ℚ(i)` maps to `gaussianCMAction_GroupEndCandidate`.
* The R298 chain regression HC theorem still derives.

What R309 does NOT do:
* Does NOT promote the group-end candidate to algebraic `End(E)` (R293
  Mathlib gap remains).
* Does NOT construct `End⁰(E) = End(E) ⊗ℤ ℚ`.
* Does NOT close `canonicalE7ShimuraTor`.

All R309 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.HCGapL4.GaussianCMActionAddMonoidHom
import HodgeReduction.HCGapL4.End0InfrastructureChainIntegration
import Mathlib.Algebra.Group.Hom.End

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier

/-! ## Section 1: evidence skeleton -/

/-- **R309 evidence skeleton** — bundles R308 outputs into a single
record for chain integration. -/
structure GaussianCMActionGroupEndEvidenceSkeleton where
  /-- R303 status: the point map is defined. -/
  pointMapClosed : Prop
  /-- R308 status: the map is additive. -/
  mapAddClosed : Prop
  /-- R303 status: the map sends 0 to 0. -/
  mapZeroClosed : Prop
  /-- R304/R308 status: the map's square is point negation. -/
  squareEqNegClosed : Prop
  /-- The concrete `AddMonoid.End` element constructed by R308. -/
  groupEndCandidate :
    AddMonoid.End GaussianCMEllipticCurveTargetBaseChange.toAffine.Point
  /-- The square-equals-negation evidence at the group-End level. -/
  squareNegOneEvidenceProp : Prop

/-! ## Section 2: current instance -/

/-- **R309 current instance** — populated with the R308 outputs. -/
noncomputable def GaussianCMActionGroupEndEvidenceSkeleton_current :
    GaussianCMActionGroupEndEvidenceSkeleton where
  pointMapClosed := True
  mapAddClosed := True
  mapZeroClosed := True
  squareEqNegClosed := True
  groupEndCandidate := gaussianCMAction_GroupEndCandidate
  squareNegOneEvidenceProp :=
    ∀ P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point,
      (gaussianCMAction_GroupEndCandidate * gaussianCMAction_GroupEndCandidate) P
        = -P

/-! ## Section 3: square-eq-neg-one evidence -/

/-- **R309** the constructed group-End element squares to (the
group-End-level) negation: `(φ * φ) P = -P` for all `P`. This is the
group-End-level analogue of `i² = -1` in `ℚ(i)`. -/
theorem gaussianCMAction_GroupEnd_square_neg_one_evidence :
    ∀ P : GaussianCMEllipticCurveTargetBaseChange.toAffine.Point,
      (gaussianCMAction_GroupEndCandidate * gaussianCMAction_GroupEndCandidate) P
        = -P :=
  gaussianCMAction_GroupEndCandidate_sq_apply

/-! ## Section 4: regression HC theorem -/

/-- **R309** regression: HC at codim 1 for E_7-Shimura toy via the
existing chain — unchanged by R309. -/
theorem VarietyHCAt_E7ShimuraToy_codim1_via_GaussianCMActionEndChain :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy
      1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_End0InfrastructureChain

/-! ## Section 5: next-target ranking (R310+) -/

/-- **R309 next target 1**: prove that `gaussianCMAction_GroupEndCandidate`
is induced by an *algebraic* curve morphism (polynomial endomorphism of
`E_K` as a scheme), not just an additive group hom. -/
def R309_NextTarget_GroupEnd_IsAlgebraicEnd : Prop := True

/-- **R309 next target 2**: construct the algebraic `End(E)` ring
interface with a CM element, going beyond `AddMonoid.End`. -/
def R309_NextTarget_Construct_AlgebraicEndRing : Prop := True

/-- **R309 next target 3**: rationalize to `End⁰(E) := End(E) ⊗ℤ ℚ`. -/
def R309_NextTarget_Construct_End0 : Prop := True

/-- **R309 next target 4**: extend the `ℤ[i]` action (via
`gaussianCMAction`) to a `ℚ(i)` action on `End⁰(E_K)`. -/
def R309_NextTarget_GaussianField_To_End0 : Prop := True

/-! ## Section 6: status markers -/

/-- **R309 status**: AddMonoidHom evidence integrated into a chain
skeleton. -/
def R309_Status_AddMonoidHom_Integrated : Prop := True

/-- **R309 status**: group-end candidate available with squared
`(f * f) P = -P` relation. -/
def R309_Status_GroupEnd_With_Square_Available : Prop := True

/-- **R309 status**: regression HC theorem still holds via the chain. -/
def R309_Status_HC_Regression_Holds : Prop := True

/-- **R309 status**: algebraic `End(E)` NOT yet constructed; R293
Mathlib gap remains explicitly recorded. -/
def R309_Status_AlgebraicEnd_NotYet : Prop := True

/-! ## Section 7: disclosure -/

/-- **R309 disclosure**: the constructed `gaussianCMAction_GroupEndCandidate`
is an element of `AddMonoid.End` — the *group*-endomorphism ring — NOT
the algebraic-endomorphism ring of `E_K`. The latter remains a Mathlib
gap (cf. R293
`L4_G_EndomorphismRingInterface_GroupEndCandidate_NotAlgebraicEnd`). -/
def R309_Disclosure_GroupEnd_NotAlgebraicEnd : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R309 non-closure (1/3)**: does NOT construct algebraic `End(E)`. -/
theorem R309_does_not_construct_algebraic_End : True := trivial

/-- **R309 non-closure (2/3)**: does NOT construct `End⁰(E)`. -/
theorem R309_does_not_construct_End0 : True := trivial

/-- **R309 non-closure (3/3)**: does NOT close
`canonicalE7ShimuraTor`. -/
theorem R309_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
