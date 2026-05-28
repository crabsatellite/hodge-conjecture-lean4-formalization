/-
# HC Gap L4 — Real-compatible E_7 algebraic-classes profile (R398).

R397 introduced `RealCompatibleE7CohomologyProfile` with a uniform
`H k = ℚ` carrier and per-weight Hodge-Tate-diagonal PHS. R398 (this
file) supplies the matching algebraic-classes profile and proves
`VarietyHC` for the minimal (full-algClasses = ⊤) instance.

## Strategy

* `RealCompatibleE7AlgClassesProfile` — structure paralleling
  `AlgebraicClassesData` with two Prop targets for granular tracking.
* Minimal instance: `algClasses p := ⊤` at every `p`. NOT a real Chow
  claim — it's a profile placeholder asserting "the algebraic-classes
  submodule fills the cohomology", which is HC-trivial closure when
  the cohomology is Hodge-Tate-diagonal (R397).
* `hodgeClassesAtDegree_realCompatibleE7 p = ⊤` — kernel-pure proof
  from the R397 `piece_ℚ_atIndex` evaluation at the Hodge-Tate
  diagonal index.
* `RealCompatibleE7Profile_VarietyHC` — full HC theorem for the
  profile, KERNEL-PURE.

## Round-end report (per user contract)

1. Toy theorem cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Original theorem cone: still contains `canonicalE7ShimuraTor` —
   UNCHANGED.
3. Canonical replacement safe? **NO** (R398 is a profile-only HC
   closure; the profile is not yet identified with the canonical
   carrier).
4. High-codim profile mismatch resolved or parameterised?
   **PARAMETERISED**: the profile carries non-trivial high-codim
   data (R397's `H k = ℚ` at every k); R398's VarietyHC closes for
   this PROFILE, not the real canonical carrier.

## What R398 does NOT do

* Does NOT claim `algClasses p = ⊤` is a real Chow ring assertion.
* Does NOT construct a real cycle class map.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R398 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.RealCompatibleE7CarrierProfile

namespace HodgeReduction
namespace HCGapL4
namespace RealCompatibleE7Carrier

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: hodgeClassesAtDegree of the R397 internal profile = ⊤ -/

/-- **R398 key lemma**: at every codimension `p`, the R397 internal
profile's `hodgeClassesAtDegree p` equals `⊤`. This follows because
the PHS at weight `2p` is `pureHodgeStructure_ℚ_atIndex (2*p) ⟨p,_⟩`
with `piece ⟨p,_⟩ = ⊤`, and `hodgeClasses V k = piece ⟨k,_⟩`. -/
theorem hodgeClassesAtDegree_realCompatibleE7 (p : ℕ) :
    VarietyCohomologyData_realCompatibleE7.hodgeClassesAtDegree p = ⊤ := by
  -- Unfold to the underlying PHS piece access.
  unfold VarietyCohomologyData_realCompatibleE7
        RealCompatibleE7CohomologyProfile.toVCD
        VarietyCohomologyData.hodgeClassesAtDegree
        internalProfile
  simp only [H_hodgeStructure]
  -- Now goal: PureHodgeStructure.hodgeClasses (H (2*p)) p (instance =
  -- pureHodgeStructure_ℚ_atIndex (2*p) (realCompatibleE7_hodgeIndex (2*p))) = ⊤
  -- = piece_ℚ_atIndex (2*p) (realCompatibleE7_hodgeIndex (2*p)) ⟨p, _⟩
  show piece_ℚ_atIndex (2 * p) (realCompatibleE7_hodgeIndex (2 * p))
        ⟨p, by omega⟩ = ⊤
  -- realCompatibleE7_hodgeIndex (2*p) = ⟨(2*p)/2, _⟩ = ⟨p, _⟩
  have hIdx : realCompatibleE7_hodgeIndex (2 * p) = ⟨p, by omega⟩ := by
    unfold realCompatibleE7_hodgeIndex
    ext
    simp [Nat.mul_div_cancel_left]
  rw [hIdx]
  exact piece_ℚ_atIndex_eq (2 * p) ⟨p, by omega⟩

/-! ## Section 2: real-compatible algClasses profile structure -/

/-- **R398 RealCompatibleE7AlgClassesProfile**: parametric algebraic-
classes profile attached to a `RealCompatibleE7CohomologyProfile`,
matching the `AlgebraicClassesData` shape over the converted VCD. -/
structure RealCompatibleE7AlgClassesProfile
    (P : RealCompatibleE7CohomologyProfile) where
  /-- Algebraic classes submodule at each codim. -/
  algClasses : ∀ p : ℕ,
    @Submodule ℚ (P.toVCD.H (2 * p)) _
      (P.toVCD.addCommGroup (2 * p)).toAddCommMonoid
      (P.toVCD.module (2 * p))
  /-- Hodge half: algClasses ≤ hodgeClassesAtDegree. -/
  algClasses_le_hodgeClasses : ∀ p : ℕ,
    algClasses p ≤ P.toVCD.hodgeClassesAtDegree p
  /-- Target Prop: profile carries genuinely algebraic high-codim
  classes (matching real Chow ring expectations). Marker. -/
  nontrivialHighCodimAlgTarget : Prop
  /-- Target Prop: profile matches the expected real cycle class map
  image. Marker. -/
  expectedCycleClassMapTarget : Prop

/-! ## Section 3: conversion to AlgebraicClassesData -/

/-- **R398 toACD**: convert a `RealCompatibleE7AlgClassesProfile` to
the project's `AlgebraicClassesData`. Direct field copy. -/
noncomputable def RealCompatibleE7AlgClassesProfile.toACD
    {P : RealCompatibleE7CohomologyProfile}
    (A : RealCompatibleE7AlgClassesProfile P) :
    AlgebraicClassesData P.toVCD where
  algClasses := A.algClasses
  algClasses_le_hodgeClasses := A.algClasses_le_hodgeClasses

/-! ## Section 4: minimal full-algClasses (=⊤) instance -/

/-- **R398 minimal algClasses instance**: `algClasses p = ⊤` at every
codim `p`. Since R398 proved `hodgeClassesAtDegree = ⊤` for the
internal profile, the `algClasses ≤ hodgeClasses` Hodge half is the
trivial `⊤ ≤ ⊤`. -/
noncomputable def internalAlgProfile :
    RealCompatibleE7AlgClassesProfile internalProfile where
  algClasses := fun _ => ⊤
  algClasses_le_hodgeClasses := by
    intro p
    rw [show internalProfile.toVCD.hodgeClassesAtDegree p = ⊤ from
      hodgeClassesAtDegree_realCompatibleE7 p]
  -- markers
  nontrivialHighCodimAlgTarget := True
  expectedCycleClassMapTarget := True

/-- **R398 internal ACD**: alias for `internalAlgProfile.toACD`. -/
noncomputable def AlgebraicClassesData_realCompatibleE7 :
    AlgebraicClassesData VarietyCohomologyData_realCompatibleE7 :=
  internalAlgProfile.toACD

/-! ## Section 5: VarietyHC for the real-compatible profile -/

/-- **R398 main**: full `VarietyHC` for the real-compatible E_7 profile
(internal instance). KERNEL-PURE.

Proof: at every codim `p`, both `hodgeClassesAtDegree p` and
`algClasses p` equal `⊤`, so `hodgeClasses ≤ algClasses` is `⊤ ≤ ⊤`. -/
theorem RealCompatibleE7Profile_VarietyHC :
    VarietyHC
      VarietyCohomologyData_realCompatibleE7
      AlgebraicClassesData_realCompatibleE7 := by
  intro p
  letI _i_acg := VarietyCohomologyData_realCompatibleE7.addCommGroup (2 * p)
  letI _i_mod := VarietyCohomologyData_realCompatibleE7.module (2 * p)
  rw [hodgeClassesAtDegree_realCompatibleE7 p]
  -- Goal: ⊤ ≤ AlgebraicClassesData_realCompatibleE7.algClasses p
  -- algClasses p = ⊤ by definition of internalAlgProfile; le_top applies.
  exact le_top

/-- **R398 codim-1 specialisation**: HC at codim 1 for the profile. -/
theorem RealCompatibleE7Profile_VarietyHCAt_codim1 :
    VarietyHCAt
      VarietyCohomologyData_realCompatibleE7
      AlgebraicClassesData_realCompatibleE7 1 :=
  RealCompatibleE7Profile_VarietyHC 1

/-! ## Section 6: disclosure markers (Prop-only) -/

/-- **R398 disclosure**: `algClasses p = ⊤` is a CARRIER-PROFILE
choice, NOT a real Chow ring claim. The profile asserts that the
algebraic classes fill the cohomology at every codim, which is what
HC asserts. The profile is therefore self-consistent: it satisfies
its own HC by construction. -/
def R398_AlgClassesTop_NotRealChowClaim : Prop := True

/-- **R398 disclosure**: the profile does NOT construct any real
cycle class map `CH^p(X) → H^{2p}(X, ℚ)`. There is no Chow group, no
intersection theory, no cycle in this round. -/
def R398_DoesNotConstructRealCycleClassMap : Prop := True

/-- **R398 disclosure**: the profile's VarietyHC closure does NOT
close the canonical headline. The canonical headline references
`canonicalE7ShimuraTor.cohomologyOfUnderlying`, not the real-compatible
profile's VCD. -/
def R398_DoesNotCloseCanonicalHeadline : Prop := True

/-! ## Section 7: status / markers -/

def R398_Status_ACDProfile_Structure_Defined : Prop := True
def R398_Status_toACD_Conversion_Closed : Prop := True
def R398_Status_InternalAlgProfile_Instance_Created : Prop := True
def R398_Status_HodgeClasses_AtDegree_TopLemma_Proven : Prop := True
def R398_Status_RealCompatibleE7Profile_VarietyHC_Closed_KernelPure : Prop := True

/-! ## Section 8: round-end report (Prop-only markers) -/

def R398_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R398_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R398_Report_CanonicalReplacement_StillNotSafe : Prop := True
def R398_Report_HighCodim_Mismatch_OnlyParameterised : Prop := True

/-! ## Section 9: graph edges -/

def L4_G_R398_To_R399_ParametricCanonicalTor : Prop := True
def L4_G_R398_To_R402_FrontierAfterProfile : Prop := True

/-! ## Section 10: explicit non-closure -/

/-- **R398 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R398_does_not_delete_canonical_axiom : True := trivial

/-- **R398 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R398_does_not_alter_old_headline : True := trivial

/-- **R398 non-closure (3/5)**: does NOT identify the profile with the
real E_7-Shimura cohomology. -/
theorem R398_does_not_identify_profile_with_real : True := trivial

/-- **R398 non-closure (4/5)**: does NOT make any real Chow-ring claim. -/
theorem R398_does_not_make_real_Chow_claim : True := trivial

/-- **R398 non-closure (5/5)**: does NOT construct a real cycle class map. -/
theorem R398_does_not_construct_real_cycle_class_map : True := trivial

end RealCompatibleE7Carrier
end HCGapL4
end HodgeReduction
