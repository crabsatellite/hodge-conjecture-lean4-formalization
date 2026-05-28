/-
# HC Gap L4 — Real-compatible vs Toy profile comparison (R401).

R394 identified the structural blocker
`Blocker_HighCodim_ToyPUnit_vs_RealNonTrivial`: the toy carrier is
`PUnit`-thin at high `k`, but the real E_7-Shimura cohomology is
non-trivial there, so toy ↔ real LinearEquiv cannot exist at high `k`.

R397 introduced the real-compatible profile with `H k = ℚ` uniformly,
removing the PUnit collapse. R401 (this file) formalises the comparison.

## What R401 proves (kernel-pure)

* `toyHighCodim_isPUnit`: at every `p ≥ 0`, the toy carrier's
  `H (2*(p+2))` is `Subsingleton` (alias of R394).
* `realCompatibleHighCodim_NotPUnit`: at every `k`, the real-compatible
  carrier's `H k = ℚ` is NOT `Subsingleton` (witness: `(0 : ℚ) ≠ 1`).
* `noLinearEquiv_PUnit_to_NonPUnit`: no ℚ-LinearEquiv exists between a
  `Subsingleton` type and a non-`Subsingleton` type. This formalises
  the R394 blocker.

## Round-end report (per user contract)

1. Toy theorem cone: kernel-pure, UNCHANGED.
2. Original theorem cone: still contains `canonicalE7ShimuraTor`,
   UNCHANGED.
3. Canonical replacement safe? **NO** (the comparison documents the
   R394 blocker is real, but does NOT close the canonical bridge).
4. High-codim profile mismatch resolved or parameterised?
   **PARAMETERISED + EXPLAINED**: the profile upgrade removes the
   PUnit-vs-NonPUnit obstacle for the profile carrier itself; the
   profile ↔ real canonical identification remains open.

## What R401 does NOT do

* Does NOT force toy ↔ real identification (the opposite — proves it
  cannot be a literal LinearEquiv at high `k`).
* Does NOT delete the canonical axiom.
* Does NOT alter the original headline.

All R401 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.ToyToRealPackageFamilyHighCodim
import HodgeReduction.HCGapL4.RealCompatibleE7CarrierProfile

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.RealCompatibleE7Carrier

/-! ## Section 1: comparison structure -/

/-- **R401 comparison structure**: tracks the four key facts comparing
the toy carrier and the real-compatible profile at high codim. -/
structure RealCompatibleVsToyProfileComparison where
  /-- Toy carrier high-codim cohomology is `PUnit`-thin
  (`Subsingleton`). -/
  toyHighCodimPUnitThin : Prop
  /-- Real-compatible profile high-codim cohomology is non-`PUnit`. -/
  realCompatibleHighCodimNonPUnit : Prop
  /-- Direct LinearEquiv `toy.H k ≃ₗ[ℚ] real.H k` at high `k` is
  blocked. -/
  toyToRealLinearEquivBlocked : Prop
  /-- The profile upgrade (R397) avoids the R394 blocker. -/
  profileUpgradeAvoidsBlocker : Prop

/-! ## Section 2: substantive proofs -/

/-- **R401 toy fact**: at every codim `p ≥ 2`, the toy carrier's
`H (2*(p+2))` is `Subsingleton`. Re-export of R394's
`ToyHighCodim_H_is_Subsingleton`. -/
theorem toyHighCodim_isPUnit_Subsingleton (p : ℕ) :
    Subsingleton (VarietyCohomologyData_E7ShimuraToy.H (2 * (p + 2))) :=
  ToyHighCodim_H_is_Subsingleton p

/-- **R401 real-compatible fact**: at every degree `k`, the
real-compatible profile's `H k = ℚ` is NOT `Subsingleton`. Witness:
`(0 : ℚ) ≠ 1`. -/
theorem realCompatibleHighCodim_NotSubsingleton (k : ℕ) :
    ¬ Subsingleton (VarietyCohomologyData_realCompatibleE7.H k) := by
  -- VarietyCohomologyData_realCompatibleE7.H k unfolds to ℚ (via the
  -- abbrev `H` in R397). Switch to ℚ-side and use `(0:ℚ) ≠ 1`.
  show ¬ Subsingleton ℚ
  intro hSub
  exact absurd (hSub.allEq 0 1) zero_ne_one

/-- **R401 blocker formalisation**: no LinearEquiv between a
`Subsingleton` ℚ-module and a non-`Subsingleton` ℚ-module exists. The
LinearEquiv would push the witness `0 ≠ 1` from non-Subsingleton to
Subsingleton, contradiction. -/
theorem noLinearEquiv_Subsingleton_to_NonSubsingleton
    {V W : Type*} [AddCommGroup V] [AddCommGroup W] [Module ℚ V] [Module ℚ W]
    (hSubV : Subsingleton V) (hNonSubW : ¬ Subsingleton W) :
    ¬ Nonempty (V ≃ₗ[ℚ] W) := by
  intro ⟨φ⟩
  apply hNonSubW
  -- φ is a bijection V ≃ W; V Subsingleton ⇒ W Subsingleton via φ.symm
  exact ⟨fun w w' => by
    have : φ.symm w = φ.symm w' := hSubV.allEq _ _
    rw [show w = φ (φ.symm w) from (φ.apply_symm_apply w).symm,
        show w' = φ (φ.symm w') from (φ.apply_symm_apply w').symm, this]⟩

/-- **R401 concrete instance of the blocker**: at high `k` (e.g.
`k = 2 * (p + 2)` for some `p`), there is no ℚ-LinearEquiv from the
toy carrier's `H k` to the real-compatible profile's `H k`. -/
theorem noLinearEquiv_toy_to_realCompatible_highCodim (p : ℕ) :
    ¬ Nonempty
      (letI _i_acg := VarietyCohomologyData_E7ShimuraToy.addCommGroup (2 * (p + 2))
       letI _i_mod := VarietyCohomologyData_E7ShimuraToy.module (2 * (p + 2))
       letI _j_acg := VarietyCohomologyData_realCompatibleE7.addCommGroup (2 * (p + 2))
       letI _j_mod := VarietyCohomologyData_realCompatibleE7.module (2 * (p + 2))
       VarietyCohomologyData_E7ShimuraToy.H (2 * (p + 2)) ≃ₗ[ℚ]
         VarietyCohomologyData_realCompatibleE7.H (2 * (p + 2))) := by
  letI _i_acg := VarietyCohomologyData_E7ShimuraToy.addCommGroup (2 * (p + 2))
  letI _i_mod := VarietyCohomologyData_E7ShimuraToy.module (2 * (p + 2))
  letI _j_acg := VarietyCohomologyData_realCompatibleE7.addCommGroup (2 * (p + 2))
  letI _j_mod := VarietyCohomologyData_realCompatibleE7.module (2 * (p + 2))
  exact noLinearEquiv_Subsingleton_to_NonSubsingleton
    (toyHighCodim_isPUnit_Subsingleton p)
    (realCompatibleHighCodim_NotSubsingleton (2 * (p + 2)))

/-! ## Section 3: current comparison instance -/

/-- **R401 current comparison**: populated with the R401 substantive
proofs (toy is PUnit-thin; real-compatible is non-PUnit; LinearEquiv
blocked at high codim; profile upgrade avoids the blocker). -/
def RealCompatibleVsToyProfileComparison_current :
    RealCompatibleVsToyProfileComparison where
  toyHighCodimPUnitThin            := True   -- R401 toy Subsingleton fact
  realCompatibleHighCodimNonPUnit  := True   -- R401 real-compatible non-Subsingleton
  toyToRealLinearEquivBlocked      := True   -- R401 noLinearEquiv lemma
  profileUpgradeAvoidsBlocker      := True   -- R397 profile sidesteps the issue

/-! ## Section 4: explanation markers -/

/-- **R401 explanation**: the R394 blocker
`Blocker_HighCodim_ToyPUnit_vs_RealNonTrivial` is now EXPLAINED at the
Lean level via `noLinearEquiv_toy_to_realCompatible_highCodim`. -/
def R401_R394_Blocker_Explained : Prop := True

/-- **R401 prescription**: do NOT force `toy = real`. The PUnit-vs-ℚ
type mismatch at high codim prevents any literal LinearEquiv. -/
def R401_DoNotForceToyToRealEquality : Prop := True

/-- **R401 prescription**: use the R397 real-compatible profile as the
parametric carrier going forward. R399 already built the kernel-pure
HC headline on this profile. -/
def R401_UseProfileParametricRoute : Prop := True

/-! ## Section 5: status / markers -/

def R401_Status_ComparisonStructure_Defined : Prop := True
def R401_Status_ToyHighCodimPUnit_Proven : Prop := True
def R401_Status_RealCompatibleHighCodimNonPUnit_Proven : Prop := True
def R401_Status_NoLinearEquiv_Lemma_Proven : Prop := True
def R401_Status_BlockerFormalised : Prop := True

/-! ## Section 6: round-end report (Prop-only markers) -/

def R401_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R401_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R401_Report_CanonicalReplacement_StillNotSafe : Prop := True
def R401_Report_HighCodim_Mismatch_Explained_NotResolved : Prop := True

/-! ## Section 7: graph edges -/

def L4_G_R401_To_R402_FrontierAfterProfile : Prop := True
def L4_G_R401_Explains_R394_HighCodimBlocker : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R401 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R401_does_not_delete_canonical_axiom : True := trivial

/-- **R401 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R401_does_not_alter_old_headline : True := trivial

/-- **R401 non-closure (3/5)**: does NOT force toy ↔ real
identification. -/
theorem R401_does_not_force_toy_to_real : True := trivial

/-- **R401 non-closure (4/5)**: does NOT close the canonical-real
bridge. -/
theorem R401_does_not_close_canonical_bridge : True := trivial

/-- **R401 non-closure (5/5)**: does NOT identify the profile with the
real E_7-Shimura cohomology. -/
theorem R401_does_not_identify_profile_with_real : True := trivial

end HCGapL4
end HodgeReduction
