/-
# HC Gap L4 — Real-compatible E_7 carrier profile (R397).

R389-R396 isolated `Blocker_HighCodim_ToyPUnit_vs_RealNonTrivial`: the
existing toy carrier `VarietyCohomologyData_E7ShimuraToy` has `H k =
PUnit` for high k, while a real E_7-Shimura variety has non-trivial
high-codim cohomology. ⇒ Forcing toy = real is the wrong target.

R397 (this file) introduces a **real-compatible** E_7 cohomology
profile that:

1. Does NOT depend on `canonicalE7ShimuraTor`.
2. Is NOT `PUnit`-thin at high `k` (uniform `H k = ℚ`).
3. Carries a valid `PureHodgeStructure ℚ k` at every weight `k`
   (via the new generic `pureHodgeStructure_ℚ_atIndex`).
4. Converts cleanly to `VarietyCohomologyData`.

The profile is NOT a real E_7 Shimura cohomology bundle — it is a
**carrier profile** that no longer trivially collapses at high codim.
Closing the headline still requires real-geometry identification.

## Round-end report (per user contract)

1. Toy theorem cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Original theorem cone: `hodgeConjectureReal_canonical` cone still
   contains `canonicalE7ShimuraTor` — UNCHANGED.
3. Canonical replacement safe? **NO** (profile alone doesn't establish
   any link to canonical; safety verdict unchanged).
4. High-codim profile mismatch resolved or only parameterised?
   **PARAMETERISED**: the profile structure no longer forces PUnit
   collapse at high `k`. Whether the real E_7 cohomology MATCHES this
   profile in particular (Tate-twist diagonal Hodge-Tate at every even
   weight) is itself an obligation; R397 only removes the structural
   PUnit blocker.

## What R397 does NOT do

* Does NOT claim the profile IS the real E_7-Shimura cohomology.
* Does NOT replace `canonicalE7ShimuraTor`.
* Does NOT modify `hodgeConjectureReal_canonical`.
* Does NOT supply algebraic-classes data (R398 task) or per-codim
  MT package transport (R399 task).

All R397 declarations kernel-pure.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology

namespace HodgeReduction
namespace HCGapL4
namespace RealCompatibleE7Carrier

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Section 1: generic ℚ-at-index PureHodgeStructure constructor -/

/-- **R397 generic ℚ-piece**: for weight `n` and chosen index `m`,
set `piece m = ⊤` (the whole `ℚ`) and `piece i = ⊥` for `i ≠ m`. -/
def piece_ℚ_atIndex (n : ℕ) (m : Fin (n + 1)) :
    Fin (n + 1) → Submodule ℚ ℚ :=
  fun i => if i = m then (⊤ : Submodule ℚ ℚ) else ⊥

/-- **R397 ℚ-piece at m**: evaluation at the chosen index gives `⊤`. -/
@[simp] theorem piece_ℚ_atIndex_eq (n : ℕ) (m : Fin (n + 1)) :
    piece_ℚ_atIndex n m m = ⊤ := by
  simp [piece_ℚ_atIndex]

/-- **R397 ℚ-piece off-index**: evaluation at any other index gives `⊥`. -/
theorem piece_ℚ_atIndex_off (n : ℕ) (m : Fin (n + 1)) {i : Fin (n + 1)}
    (h : i ≠ m) :
    piece_ℚ_atIndex n m i = ⊥ := by
  simp [piece_ℚ_atIndex, h]

/-- **R397 supremum over off-index = ⊥**: for any `i`, the supremum of
`piece_ℚ_atIndex` over `j ≠ i` is `⊥` when `i = m` (since the only
non-⊥ piece is at `m`, which is excluded). -/
theorem iSup_piece_ℚ_atIndex_off_at_m (n : ℕ) (m : Fin (n + 1)) :
    (⨆ (j : Fin (n + 1)) (_ : j ≠ m), piece_ℚ_atIndex n m j) =
      (⊥ : Submodule ℚ ℚ) := by
  apply le_antisymm _ bot_le
  apply iSup_le; intro j
  apply iSup_le; intro hj
  rw [piece_ℚ_atIndex_off n m hj]

/-- **R397 independence**: the `piece_ℚ_atIndex` family is iSup-independent. -/
theorem iSupIndep_piece_ℚ_atIndex (n : ℕ) (m : Fin (n + 1)) :
    iSupIndep (piece_ℚ_atIndex n m) := by
  intro i
  by_cases hi : i = m
  · -- i = m: piece i = ⊤; supremum over j ≠ i is ⊥; Disjoint ⊤ ⊥.
    subst hi
    rw [iSup_piece_ℚ_atIndex_off_at_m]
    exact disjoint_bot_right
  · -- i ≠ m: piece i = ⊥; Disjoint ⊥ anything.
    rw [piece_ℚ_atIndex_off n m hi]
    exact disjoint_bot_left

/-- **R397 supremum = ⊤**: the family sums to the whole space (piece m
is already `⊤`). -/
theorem iSup_piece_ℚ_atIndex_eq_top (n : ℕ) (m : Fin (n + 1)) :
    (⨆ i, piece_ℚ_atIndex n m i) = (⊤ : Submodule ℚ ℚ) := by
  apply le_antisymm le_top
  rw [show (⊤ : Submodule ℚ ℚ) = piece_ℚ_atIndex n m m from
    (piece_ℚ_atIndex_eq n m).symm]
  exact le_iSup _ m

/-- **R397 PureHodgeStructure ℚ n at chosen index m**: kernel-pure
generic constructor. For each weight `n` and chosen Hodge-piece index
`m ∈ Fin (n+1)`, gives a valid `PureHodgeStructure ℚ n`. -/
noncomputable def pureHodgeStructure_ℚ_atIndex (n : ℕ) (m : Fin (n + 1)) :
    PureHodgeStructure ℚ n where
  piece := piece_ℚ_atIndex n m
  isInternal := DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top
    (iSupIndep_piece_ℚ_atIndex n m)
    (iSup_piece_ℚ_atIndex_eq_top n m)

/-! ## Section 2: per-weight Hodge index choice -/

/-- **R397 Hodge-index choice**: for weight `k`, pick index `⌊k/2⌋`.
At even `k = 2p`, this is `p` (Hodge-Tate position `(p, p)`). At odd
`k = 2p+1`, this is `p` (an arbitrary valid choice; HC at codim p only
sees even degrees `2p`, so odd-weight Hodge choices don't affect HC). -/
def realCompatibleE7_hodgeIndex (k : ℕ) : Fin (k + 1) :=
  ⟨k / 2, by omega⟩

/-- **R397 evaluation at HC-relevant weight**: at weight `2p`, the
chosen index is `⟨p, _⟩` (the Hodge-Tate diagonal position). -/
theorem realCompatibleE7_hodgeIndex_at_2p (p : ℕ) :
    realCompatibleE7_hodgeIndex (2 * p) =
      ⟨p, by omega⟩ := by
  unfold realCompatibleE7_hodgeIndex
  ext
  simp [Nat.mul_div_cancel_left]

/-! ## Section 3: uniform ℚ carrier + instances -/

/-- **R397 uniform carrier**: `H k = ℚ` at every degree `k`. NOT
`PUnit`-collapsed at high `k` (the structural fix to R394's blocker). -/
abbrev H (k : ℕ) : Type := ℚ

set_option linter.unusedVariables false in
/-- **R397 carrier AddCommGroup**: standard ℚ instance, uniform. -/
noncomputable def H_addCommGroup (k : ℕ) : AddCommGroup (H k) :=
  inferInstanceAs (AddCommGroup ℚ)

set_option linter.unusedVariables false in
/-- **R397 carrier ℚ-module**: standard, uniform. -/
noncomputable def H_module (k : ℕ) :
    @Module ℚ (H k) _ (H_addCommGroup k).toAddCommMonoid :=
  inferInstanceAs (Module ℚ ℚ)

set_option linter.unusedVariables false in
/-- **R397 carrier finiteness**: `ℚ` is finite-dimensional over `ℚ`. -/
noncomputable def H_finite (k : ℕ) :
    @Module.Finite ℚ (H k) _ (H_addCommGroup k).toAddCommMonoid
      (H_module k) :=
  inferInstanceAs (Module.Finite ℚ ℚ)

/-- **R397 carrier PureHodgeStructure**: `pureHodgeStructure_ℚ_atIndex`
applied with the chosen index `⌊k/2⌋`. -/
noncomputable def H_hodgeStructure (k : ℕ) :
    @PureHodgeStructure (H k) (H_addCommGroup k) (H_module k) k :=
  pureHodgeStructure_ℚ_atIndex k (realCompatibleE7_hodgeIndex k)

/-! ## Section 4: profile structure -/

/-- **R397 RealCompatibleE7CohomologyProfile** structure: parametric
carrier profile bundling the cohomology data + two Prop targets
documenting outstanding obligations (non-triviality at high codim;
matching the real E_7 geometry). -/
structure RealCompatibleE7CohomologyProfile where
  /-- Cohomology type at degree `k`. -/
  H : ℕ → Type
  /-- AddCommGroup instance at every degree. -/
  instAddCommGroup : ∀ k, AddCommGroup (H k)
  /-- ℚ-module instance at every degree. -/
  instModule : ∀ k,
    @Module ℚ (H k) _ (instAddCommGroup k).toAddCommMonoid
  /-- Finiteness at every degree. -/
  instFinite : ∀ k,
    @Module.Finite ℚ (H k) _ (instAddCommGroup k).toAddCommMonoid
      (instModule k)
  /-- PureHodgeStructure of weight `k` at every degree. -/
  hodgeStructure : ∀ k,
    @PureHodgeStructure (H k) (instAddCommGroup k) (instModule k) k
  /-- Target Prop: profile carries genuinely non-trivial high-codim
  cohomology (matching the real E_7 expected geometry). For the
  minimal `internalProfile` instance below, this is set to `True` as
  a marker; a real witness would need finrank ≥ expected E_7
  cohomology dimension. -/
  nontrivialHighCodimTarget : Prop
  /-- Target Prop: profile matches the expected E_7-Shimura geometry
  (Hodge numbers + MT group + Shimura datum). Marker only at the
  profile-structure level. -/
  expectedE7GeometryTarget : Prop

/-! ## Section 5: conversion to VarietyCohomologyData -/

/-- **R397 toVCD**: convert a `RealCompatibleE7CohomologyProfile` into
the project's standard `VarietyCohomologyData` bundle. Direct field
copy. -/
noncomputable def RealCompatibleE7CohomologyProfile.toVCD
    (P : RealCompatibleE7CohomologyProfile) : VarietyCohomologyData where
  H := P.H
  addCommGroup := P.instAddCommGroup
  module := P.instModule
  finite := P.instFinite
  hodgeStructure := P.hodgeStructure

/-! ## Section 6: minimal internal instance (uniform ℚ) -/

/-- **R397 minimal internal instance**: `H k = ℚ` uniformly, with the
ℚ-at-index PHS at every weight. The two Prop targets are set to `True`
as MARKERS (the instance is a carrier profile, not a real cohomology
witness). -/
noncomputable def internalProfile : RealCompatibleE7CohomologyProfile where
  H := H
  instAddCommGroup := H_addCommGroup
  instModule := H_module
  instFinite := H_finite
  hodgeStructure := H_hodgeStructure
  -- markers (Prop only); see Section 7
  nontrivialHighCodimTarget := True
  expectedE7GeometryTarget := True

/-- **R397 internal VCD**: alias for `internalProfile.toVCD`. -/
noncomputable def VarietyCohomologyData_realCompatibleE7 : VarietyCohomologyData :=
  internalProfile.toVCD

/-! ## Section 7: disclosure markers (Prop-only) -/

/-- **R397 disclosure**: at every `k`, the internal profile's `H k = ℚ`
is non-`PUnit`. This is the STRUCTURAL improvement over
`VarietyCohomologyData_E7ShimuraToy`, but it does NOT itself match the
real E_7 expected geometry (which would have higher rank at most
degrees). -/
def R397_HighCodim_NotPUnitThin : Prop := True

/-- **R397 disclosure**: the internal profile is a UNIFORM ℚ profile;
real E_7 cohomology has degree-dependent rank (e.g. `h^{p,q}` data).
Matching it requires either (a) replacing `H k = ℚ` with `H k =
Fin (expectedRank k) → ℚ`, or (b) constructing the real cohomology
directly. R397 records both as future targets. -/
def R397_UniformProfile_NotDegreewiseRank : Prop := True

/-- **R397 disclosure**: the Hodge-Tate diagonal-piece choice
`piece (⟨p,_⟩) = ⊤` at weight `2p` is the SIMPLEST valid PHS on ℚ.
Real E_7 cohomology has a more complex Hodge decomposition (e.g.
`h^{p, q} ≠ 0` for several `(p, q)` with `p + q = 2p`). The profile
matches the diagonal Hodge-Tate type only. -/
def R397_DiagonalHodgeTate_NotFullHodgeDecomposition : Prop := True

/-! ## Section 8: non-closure markers -/

/-- **R397 non-closure**: does NOT claim the profile IS the real
E_7-Shimura cohomology. -/
def R397_DoesNotClaimRealE7Geometry : Prop := True

/-- **R397 non-closure**: does NOT replace `canonicalE7ShimuraTor`. -/
def R397_DoesNotReplaceCanonicalE7ShimuraTor : Prop := True

/-- **R397 non-closure**: the profile is a profile only, NOT a true
cohomology of a real variety. -/
def R397_ProfileOnly_NotTrueCohomology : Prop := True

/-! ## Section 9: status / markers -/

def R397_Status_GenericPHSConstruction_Closed : Prop := True
def R397_Status_RealCompatibleProfile_Structure_Defined : Prop := True
def R397_Status_toVCD_Conversion_Closed : Prop := True
def R397_Status_InternalProfile_Instance_Created : Prop := True
def R397_Status_VarietyCohomologyData_realCompatibleE7_Alias_Available : Prop := True
def R397_Status_HighCodim_NotPUnitThin_Disclosure_Made : Prop := True

/-! ## Section 10: round-end report (Prop-only markers) -/

def R397_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R397_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R397_Report_CanonicalReplacement_StillNotSafe : Prop := True
def R397_Report_HighCodim_Mismatch_OnlyParameterised : Prop := True

/-! ## Section 11: graph edges -/

def L4_G_R397_To_R398_AlgClassesProfile : Prop := True
def L4_G_R397_To_R399_ParametricCanonicalTor : Prop := True
def L4_G_R397_To_R401_ComparisonWithToy : Prop := True
def L4_G_R397_To_R402_FrontierAfterProfile : Prop := True

/-! ## Section 12: explicit non-closure theorems -/

/-- **R397 non-closure (1/5)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R397_does_not_delete_canonical_axiom : True := trivial

/-- **R397 non-closure (2/5)**: does NOT alter `hodgeConjectureReal_canonical`. -/
theorem R397_does_not_alter_old_headline : True := trivial

/-- **R397 non-closure (3/5)**: does NOT claim the profile is the
real E_7-Shimura cohomology. -/
theorem R397_does_not_claim_real_E7_geometry : True := trivial

/-- **R397 non-closure (4/5)**: does NOT supply algebraic-classes data
(R398 task). -/
theorem R397_does_not_supply_alg_classes : True := trivial

/-- **R397 non-closure (5/5)**: does NOT construct any
`MTCorrespondencePackageAt` for the profile (R399 task). -/
theorem R397_does_not_construct_MT_package : True := trivial

end RealCompatibleE7Carrier
end HCGapL4
end HodgeReduction
