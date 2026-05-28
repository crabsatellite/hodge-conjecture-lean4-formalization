/-
# HC Gap L4 — `ParametricCanonicalE7ShimuraTor` from the real-compatible
# profile (R399).

R397 introduced the real-compatible E_7 cohomology profile (non-PUnit
at high `k`). R398 supplied the matching algebraic-classes profile and
proved `VarietyHC` for the (full-algClasses = ⊤) internal instance.

R399 (this file) instantiates the R378 `ParametricCanonicalE7ShimuraTor`
on the real-compatible profile and derives a SECOND kernel-pure HC
headline (now on the richer profile carrier instead of the
PUnit-thin toy).

## Design

* `MTCorrespondencePackageAt_identity_realCompatibleE7 p` — identity
  template at the new profile, parallel to R386's identity at the toy.
* `ParametricCanonicalE7ShimuraTor_realCompatible` — full R378 instance.
* `hodgeConjectureReal_realCompatible_kernelPure` — kernel-pure HC on
  the profile, derived via R379's parametric headline.

## Round-end report (per user contract)

1. Toy theorem cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   kernel-pure — UNCHANGED.
2. Original theorem cone: still contains `canonicalE7ShimuraTor` —
   UNCHANGED.
3. Canonical replacement safe? **NO** (R399 produces a kernel-pure HC
   on the profile carrier, which is DIFFERENT from
   `canonicalE7ShimuraTor.cohomologyOfUnderlying`).
4. High-codim profile mismatch resolved or parameterised?
   **PARAMETERISED**: the profile no longer forces PUnit collapse;
   R399's HC headline holds on the (non-PUnit) profile carrier.

## What R399 does NOT do

* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT claim the profile IS the real canonical carrier.
* Does NOT identify R399 headline with original headline.

All R399 declarations kernel-pure: cone ⊆ `{propext, Classical.choice,
Quot.sound}`.
-/

import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor
import HodgeReduction.HCGapL4.ParametricHodgeConjectureReal
import HodgeReduction.HCGapL4.HodgeMorphism
import HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness
import HodgeReduction.HCGapL4.RealCompatibleE7AlgClassesProfile

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.RealCompatibleE7Carrier
open HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness

/-! ## Section 1: identity MT package on the real-compatible profile -/

/-- **R399 identity MT package** on the real-compatible E_7 profile at
every codim `p`. Same R204 template as R386's
`MTCorrespondencePackageAt_identity_E7ShimuraToy` — identity HSM +
identity ψ; commuting square = `rfl`; Hodge surjectivity =
`⟨x, hx, rfl⟩`. KERNEL-PURE. -/
theorem MTCorrespondencePackageAt_identity_realCompatibleE7 (p : ℕ) :
    MTCorrespondencePackageAt
      VarietyCohomologyData_realCompatibleE7
      VarietyCohomologyData_realCompatibleE7
      AlgebraicClassesData_realCompatibleE7
      AlgebraicClassesData_realCompatibleE7
      p := by
  letI _ := VarietyCohomologyData_realCompatibleE7.addCommGroup (2 * p)
  letI _ := VarietyCohomologyData_realCompatibleE7.module (2 * p)
  letI _ := VarietyCohomologyData_realCompatibleE7.hodgeStructure (2 * p)
  refine ⟨HodgeStructureMorphism.id_HSM, LinearMap.id, ?_, ?_⟩
  · intro z; rfl
  · intro x hx; exact ⟨x, hx, rfl⟩

/-! ## Section 2: full ∃-witness for the real-compatible profile -/

/-- **R399 full ∃-witness**: bundles `internalCMAbelianVariety_toy`
(from R386) + R398's `RealCompatibleE7Profile_VarietyHC` + the
identity MT packages at every `p`. KERNEL-PURE; cone does NOT include
`canonicalE7ShimuraTor`. -/
theorem realCompatible_FullCodimMTPackageWitness :
    ∃ (A : SmoothProjectiveVariety ℂ)
      (A_cohData : VarietyCohomologyData)
      (A_algData : AlgebraicClassesData A_cohData),
      IsCMAbelianVariety A ∧
      VarietyHC A_cohData A_algData ∧
      ∀ p : ℕ,
        MTCorrespondencePackageAt
          A_cohData VarietyCohomologyData_realCompatibleE7
          A_algData AlgebraicClassesData_realCompatibleE7 p := by
  refine ⟨internalCMAbelianVariety_toy,
          VarietyCohomologyData_realCompatibleE7,
          AlgebraicClassesData_realCompatibleE7,
          isCMAbelianVariety_internalCMAbelianVariety_toy,
          RealCompatibleE7Profile_VarietyHC,
          ?_⟩
  intro p
  exact MTCorrespondencePackageAt_identity_realCompatibleE7 p

/-! ## Section 3: parametric tor instance from the real-compatible profile -/

/-- **R399** `ParametricCanonicalE7ShimuraTor` instance using the
real-compatible E_7 profile. KERNEL-PURE; cone does NOT include
`canonicalE7ShimuraTor`. -/
noncomputable def ParametricCanonicalE7ShimuraTor_realCompatible :
    ParametricCanonicalE7ShimuraTor where
  cohomologyOfUnderlying  := VarietyCohomologyData_realCompatibleE7
  algClassesOfUnderlying  := AlgebraicClassesData_realCompatibleE7
  mtCorrespondencePackage := realCompatible_FullCodimMTPackageWitness

/-! ## Section 4: kernel-pure HC headline on the real-compatible profile -/

/-- **R399** SECOND kernel-pure HC headline (after R387's toy headline).
Derived through R379's parametric route applied to the real-compatible
profile instance. Same shape as `hodgeConjectureReal_canonical_kernelPure`
but on the richer profile carrier. KERNEL-PURE; cone does NOT include
`canonicalE7ShimuraTor`. -/
theorem hodgeConjectureReal_realCompatible_kernelPure :
    Infrastructure.HodgeStructure.VarietyHC
      VarietyCohomologyData_realCompatibleE7
      AlgebraicClassesData_realCompatibleE7 :=
  hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor
    ParametricCanonicalE7ShimuraTor_realCompatible

/-- **R399** codim-1 specialisation of the real-compatible HC headline. -/
theorem VarietyHCAt_realCompatible_codim1_kernelPure :
    Infrastructure.HodgeStructure.VarietyHCAt
      VarietyCohomologyData_realCompatibleE7
      AlgebraicClassesData_realCompatibleE7 1 :=
  hodgeConjectureReal_realCompatible_kernelPure 1

/-! ## Section 5: disclosure markers (Prop-only) -/

/-- **R399 disclosure**: this is a kernel-pure HC headline on a
PROFILE carrier (R397). The profile is NOT identified with the real
canonical E_7-Shimura cohomology. -/
def R399_RealCompatibleHeadline_KernelPure : Prop := True

/-- **R399 disclosure**: the original `hodgeConjectureReal_canonical`
headline references `canonicalE7ShimuraTor.{cohomology,algClasses}OfUnderlying`
literally; R399's kernel-pure headline is on the real-compatible
profile carrier instead. NOT the same theorem; original headline
unchanged. -/
def R399_NotOriginalCanonicalHeadline : Prop := True

/-- **R399 disclosure**: closing the original headline kernel-purely
requires identifying the real-compatible profile with the real
canonical E_7-Shimura cohomology (or providing such an identification
via Mathlib geometry). R400 confirmed Mathlib still lacks the
needed APIs. -/
def R399_RequiresRealGeometryIdentificationForFinalSwitch : Prop := True

/-! ## Section 6: status / markers -/

def R399_Status_IdentityMTPackage_RealCompatible_Closed : Prop := True
def R399_Status_FullCodimWitness_RealCompatible_Closed : Prop := True
def R399_Status_ParametricCanonicalE7ShimuraTor_realCompatible_Defined : Prop := True
def R399_Status_KernelPureHeadline_RealCompatibleProfile_Closed : Prop := True
def R399_Status_Codim1Specialisation_Provided : Prop := True

/-! ## Section 7: round-end report (Prop-only markers) -/

def R399_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R399_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R399_Report_CanonicalReplacement_StillNotSafe : Prop := True
def R399_Report_HighCodim_Mismatch_OnlyParameterised : Prop := True

/-! ## Section 8: graph edges -/

def L4_G_R399_To_R401_ComparisonWithToy : Prop := True
def L4_G_R399_To_R402_FrontierAfterProfile : Prop := True
def L4_G_R399_RequiresR400_NoRealGeometryYet : Prop := True

/-! ## Section 9: explicit non-closure -/

/-- **R399 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R399_does_not_delete_canonical_axiom : True := trivial

/-- **R399 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R399_does_not_alter_old_headline : True := trivial

/-- **R399 non-closure (3/5)**: does NOT claim the profile is the real
canonical carrier. -/
theorem R399_does_not_claim_profile_is_real_canonical : True := trivial

/-- **R399 non-closure (4/5)**: does NOT identify R399 headline with
the original headline (different statement on different carrier). -/
theorem R399_does_not_identify_R399_with_original_headline : True := trivial

/-- **R399 non-closure (5/5)**: does NOT close HC for the real
`canonicalE7ShimuraTor.cohomologyOfUnderlying` literally. -/
theorem R399_does_not_close_real_canonical_HC : True := trivial

end HCGapL4
end HodgeReduction
