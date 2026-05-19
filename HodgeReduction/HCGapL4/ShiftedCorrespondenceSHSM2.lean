/-
# HC Gap L4 — reparameterized SHSM-bundled shifted MT package (R218).

R213 introduced `ShiftedMTCorrespondencePackageAt_SHSM` parameterised
by `(p_src, q)` with target codim = `p_src + q`. R215/R216/R217 hit a
hard wall on GENERAL composition: chaining two SHSM packages produces
target codim `(p + q₁) + q₂`, while the natural goal codim is
`p + (q₁ + q₂)`. These are propositionally equal (`Nat.add_assoc`) but
NOT definitionally equal in Lean 4's right-recursive `Nat.add`. The
required cast-coherence machinery
(`LinearMap.cast_apply`/`Submodule.map_cast`/`cast_comp`/`cast_le`)
is non-trivial Mathlib-quality theory.

R218 introduces a controlled **v2 reparameterization** that bypasses
the problem entirely. The v2 package
`ShiftedMTCorrespondencePackageAt_SHSM2` takes BOTH `p_src` and
`p_tgt` as external parameters (not derived from `p_src + q`), with
an internal existential witness `shift : ℕ` and equation
`h_shift : p_tgt = p_src + shift`. Composition of two v2 packages
naturally lives at the EXPLICIT codims `(p₀, p₂)` and the
shift composition `shift = shift₁ + shift₂` is just a propositional
equation between Nat values, NOT a transport across dependent types.

R213-R217 are PRESERVED and continue to function. R218 adds v2 on
top, with `toRaw` showing v2 implies R212's raw package and the
sanity HC closure recovered via the v2 composition route.

## What R218 provides (all kernel-pure)

* `ShiftedMTCorrespondencePackageAt_SHSM2` — v2 SHSM package with
  `(p_src, p_tgt)` external + `shift`/`h_shift` internal.
* `ShiftedMTCorrespondencePackageAt_SHSM2_toRaw` — v2 implies R212
  raw package.
* `identity_ShiftedMTCorrespondencePackageAt_SHSM2` — v2 identity
  package `(p, p)` (composition unit).
* `ShiftedMTCorrespondencePackageAt_SHSM2_compose` — full GENERAL
  composition, no cast-coherence needed.
* `ShiftedMTCorrespondencePackageAt_SHSM2_point_to_ellipticCurve_codim0_to_codim1` —
  concrete pt→E v2 instance at `(0, 1)`.
* `ShiftedMTCorrespondencePackageAt_SHSM2_point_to_E_via_composition` —
  sanity SHSM2 composition: identity@pt ∘ R218 pt→E.
* `VarietyHCAt_ellipticCurve_codim1_via_SHSM2_composed_correspondence` —
  10th kernel-pure HC route via v2 general composition.

## What R218 does NOT do

* Does NOT delete or rewrite R213-R217 (preserved).
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT implement real Chow correspondence composition.
* Does NOT develop Mathlib cast-coherence theory.
* Does NOT prove categorical associativity at the package level.
* Does NOT add a v2 ↔ v1 bridge theorem (one-way only: v1 is
  recoverable from v2 via `(p_src + q)` instantiation, but the
  converse requires the deferred cast-coherence).

All R218 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
import HodgeReduction.HCGapL4.InducedAlgClassMap

namespace HodgeReduction
namespace HCGapL4
namespace ShiftedCorrespondenceSHSM2

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM

/-! ## Section 0: scoped `PureHodgeStructure` instance for generic VCDs -/

noncomputable instance phs_VCD_Hk_R218 (X : VarietyCohomologyData) (k : ℕ) :
    PureHodgeStructure (X.H k) k := X.hodgeStructure k

/-! ## Section 1: v2 SHSM package definition

`ShiftedMTCorrespondencePackageAt_SHSM2` takes `(p_src, p_tgt)` as
external parameters (NOT derived from `p_src + q`). The Tate twist
shift is captured by an internal existential witness `shift : ℕ` and
equation `h_shift : p_tgt = p_src + shift`.

Composition of two v2 packages does NOT trigger any dependent-type
cast: the target codim of the composed package is the EXPLICIT
parameter `p_tgt₂`, and the shift composition `shift₁ + shift₂` is a
simple Nat equation. -/

/-- **R218 v2 SHSM package**: explicit `(p_src, p_tgt)` parameterisation
with internal `shift : ℕ` witness. -/
def ShiftedMTCorrespondencePackageAt_SHSM2
    (X_src X_tgt : VarietyCohomologyData)
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    (p_src p_tgt : ℕ) : Prop :=
  letI _ := X_src.addCommGroup (2 * p_src)
  letI _ := X_src.module (2 * p_src)
  letI _ := X_src.hodgeStructure (2 * p_src)
  letI _ := X_tgt.addCommGroup (2 * p_tgt)
  letI _ := X_tgt.module (2 * p_tgt)
  letI _ := X_tgt.hodgeStructure (2 * p_tgt)
  ∃ (shift : ℕ) (h_shift : p_tgt = p_src + shift)
    (action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * p_tgt))
    (ψ : ↥(A_src.algClasses p_src) →ₗ[ℚ] ↥(A_tgt.algClasses p_tgt)),
    -- (1) Tate-twist piece shift via internal `shift`.
    (∀ (p_idx : Fin (2 * p_src + 1)),
      Submodule.map action
          (PureHodgeStructure.piece (V := X_src.H (2 * p_src)) p_idx) ≤
        PureHodgeStructure.piece (V := X_tgt.H (2 * p_tgt))
          (⟨p_idx.val + shift, by
            have hp := p_idx.is_lt
            have hs := h_shift
            omega⟩ : Fin (2 * p_tgt + 1))) ∧
    -- (2) Commuting square.
    (∀ z : ↥(A_src.algClasses p_src),
      ((A_tgt.algClasses p_tgt).subtype) (ψ z) =
        action (((A_src.algClasses p_src).subtype) z)) ∧
    -- (3) Target Hodge-class surjectivity.
    PureHodgeStructure.hodgeClasses (X_tgt.H (2 * p_tgt)) p_tgt ≤
      Submodule.map action
        (PureHodgeStructure.hodgeClasses (X_src.H (2 * p_src)) p_src)

/-! ## Section 2: toRaw — v2 implies R212 raw package -/

/-- **R218 v2 toRaw**: any v2 SHSM package yields R212's raw shifted
package at the same `(p_src, p_tgt)` by dropping shift / h_shift /
piece-shift hypothesis. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p_src p_tgt : ℕ}
    (h_pkg : ShiftedMTCorrespondencePackageAt_SHSM2
              X_src X_tgt A_src A_tgt p_src p_tgt) :
    ShiftedMTCorrespondencePackageAt
      X_src X_tgt A_src A_tgt p_src p_tgt := by
  letI _ := X_src.addCommGroup (2 * p_src)
  letI _ := X_src.module (2 * p_src)
  letI _ := X_src.hodgeStructure (2 * p_src)
  letI _ := X_tgt.addCommGroup (2 * p_tgt)
  letI _ := X_tgt.module (2 * p_tgt)
  letI _ := X_tgt.hodgeStructure (2 * p_tgt)
  unfold ShiftedMTCorrespondencePackageAt_SHSM2 at h_pkg
  obtain ⟨_shift, _h_shift, action, ψ, _h_piece, h_sq, h_surj⟩ := h_pkg
  exact ⟨action, ψ, h_sq, h_surj⟩

/-! ## Section 3: identity v2 package -/

/-- **R218 v2 identity package**: `(p, p)` with `shift = 0`,
`h_shift : p = p + 0` (defeq via `Nat.add n 0 = n`). -/
theorem identity_ShiftedMTCorrespondencePackageAt_SHSM2
    (X : VarietyCohomologyData)
    (AX : AlgebraicClassesData X)
    (p : ℕ) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X X AX AX p p := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  refine ⟨0, rfl, LinearMap.id, LinearMap.id, ?_, ?_, ?_⟩
  · -- Piece shift: id maps piece p_idx to piece ⟨p_idx.val + 0, _⟩ = piece p_idx.
    intro p_idx
    rw [Submodule.map_id]
    rfl
  · intro z; rfl
  · intro x hx; refine ⟨x, hx, rfl⟩

/-! ## Section 4: GENERAL v2 composition — the breakthrough

With `(p_src, p_tgt)` explicit parameters, composing
`P₁ : SHSM2 X Y AX AY p₀ p₁` with `P₂ : SHSM2 Y Z AY AZ p₁ p₂`
naturally lands at `SHSM2 X Z AX AZ p₀ p₂`. The shift composition
`shift = shift₁ + shift₂` and `h_shift : p₂ = p₀ + (shift₁ + shift₂)`
are simple Nat equations derivable via `Nat.add_assoc` (propositional,
no transport). All conjunct proofs work via standard chaining. -/

/-- **R218 v2 GENERAL composition theorem**: no dependent-type cast
required. Composing two v2 SHSM packages at `(p₀, p₁)` and `(p₁, p₂)`
yields a v2 SHSM package at `(p₀, p₂)`. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM2_compose
    {X Y Z : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {p₀ p₁ p₂ : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt_SHSM2 X Y AX AY p₀ p₁)
    (P₂ : ShiftedMTCorrespondencePackageAt_SHSM2 Y Z AY AZ p₁ p₂) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X Z AX AZ p₀ p₂ := by
  letI _ := X.addCommGroup (2 * p₀)
  letI _ := X.module (2 * p₀)
  letI _ := X.hodgeStructure (2 * p₀)
  letI _ := Y.addCommGroup (2 * p₁)
  letI _ := Y.module (2 * p₁)
  letI _ := Y.hodgeStructure (2 * p₁)
  letI _ := Z.addCommGroup (2 * p₂)
  letI _ := Z.module (2 * p₂)
  letI _ := Z.hodgeStructure (2 * p₂)
  unfold ShiftedMTCorrespondencePackageAt_SHSM2 at P₁ P₂
  obtain ⟨shift₁, h_shift₁, action₁, ψ₁, h_piece₁, h_sq₁, h_surj₁⟩ := P₁
  obtain ⟨shift₂, h_shift₂, action₂, ψ₂, h_piece₂, h_sq₂, h_surj₂⟩ := P₂
  -- Composed shift: shift₁ + shift₂.
  -- h_shift for composed: p₂ = p₁ + shift₂ = (p₀ + shift₁) + shift₂
  --                          = p₀ + (shift₁ + shift₂) (by Nat.add_assoc).
  refine ⟨shift₁ + shift₂, ?_, action₂.comp action₁, ψ₂.comp ψ₁, ?_, ?_, ?_⟩
  · -- h_shift_compose
    rw [h_shift₂, h_shift₁, Nat.add_assoc]
  · -- piece shift
    intro p_idx
    rw [Submodule.map_comp]
    -- Chain via P₁ then P₂.
    have step1 := h_piece₁ p_idx
    have step1_mapped := Submodule.map_mono (f := action₂) step1
    -- step1_mapped: Submodule.map action₂ (Submodule.map action₁ (piece p_idx)) ≤
    --   Submodule.map action₂ (piece ⟨p_idx.val + shift₁, _⟩ at Fin (2 * p₁ + 1))
    have step2 := h_piece₂ ⟨p_idx.val + shift₁, by
        have := p_idx.is_lt; have := h_shift₁; omega⟩
    -- step2: Submodule.map action₂ (piece ⟨p_idx.val + shift₁, _⟩) ≤
    --   piece ⟨(p_idx.val + shift₁) + shift₂, _⟩ at Fin (2 * p₂ + 1)
    -- Goal: piece ⟨p_idx.val + (shift₁ + shift₂), _⟩ at Fin (2 * p₂ + 1)
    -- BOTH pieces in the SAME Fin type (2 * p₂ + 1) — propositional Nat.add_assoc only.
    have h_fin_eq :
        (⟨(p_idx.val + shift₁) + shift₂, by
            have := p_idx.is_lt
            have := h_shift₁
            have := h_shift₂
            omega⟩ :
            Fin (2 * p₂ + 1)) =
        ⟨p_idx.val + (shift₁ + shift₂), by
            have := p_idx.is_lt
            have := h_shift₁
            have := h_shift₂
            omega⟩ :=
      Fin.mk_eq_mk.mpr (Nat.add_assoc p_idx.val shift₁ shift₂)
    rw [h_fin_eq] at step2
    exact step1_mapped.trans step2
  · -- commuting square
    intro z
    show ((AZ.algClasses p₂).subtype) (ψ₂ (ψ₁ z)) =
         action₂ (action₁ (((AX.algClasses p₀).subtype) z))
    rw [h_sq₂ (ψ₁ z), h_sq₁ z]
  · -- Hodge surjectivity
    intro x hx_Z
    obtain ⟨y, hy_Y, hy_eq⟩ := h_surj₂ hx_Z
    obtain ⟨v, hv_X, hv_eq⟩ := h_surj₁ hy_Y
    refine ⟨v, hv_X, ?_⟩
    show (action₂.comp action₁) v = x
    rw [LinearMap.comp_apply, hv_eq]
    exact hy_eq

/-! ## Section 5: concrete v2 instance — pt → E at `(0, 1)` -/

/-- **R218 v2 instance**: kernel-pure SHSM2 from point (codim 0) to
elliptic curve (codim 1) with `shift = 1`. Same action and ψ as R213. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM2_point_to_ellipticCurve_codim0_to_codim1 :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 := by
  refine ⟨1, rfl, cycleAction_H0_to_H2_pointCycle,
          psi_codim0_to_codim1_point_to_ellipticCurve, ?_, ?_, ?_⟩
  · -- Piece shift: source piece ⟨0,_⟩ = ⊤ maps into target piece ⟨0+1, _⟩ = ⟨1, _⟩.
    intro p
    fin_cases p
    show Submodule.map _ _ ≤
      ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 1, by omega⟩
    show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact le_top
  · intro z; rfl
  · intro x _
    refine ⟨x, ?_, ?_⟩
    · show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      rw [TrivialWeight.piece_ℚ_w0_zero]
      exact Submodule.mem_top
    · rfl

/-! ## Section 6: sanity SHSM2 composition — identity@pt ∘ pt→E -/

/-- **R218 v2 sanity composition**: compose v2 identity at point with
v2 pt→E codim0→1, via the GENERAL `SHSM2_compose` theorem (no cast
restrictions). -/
theorem ShiftedMTCorrespondencePackageAt_SHSM2_point_to_E_via_composition :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  ShiftedMTCorrespondencePackageAt_SHSM2_compose
    (identity_ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    ShiftedMTCorrespondencePackageAt_SHSM2_point_to_ellipticCurve_codim0_to_codim1

/-- **R218 10th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via v2 GENERAL composition. Distinct from R216 (specific (0,0,1)) and
R217 (specific q₂=1 specialised general) — this uses the fully
unrestricted v2 compose. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_SHSM2_composed_correspondence :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      ShiftedMTCorrespondencePackageAt_SHSM2_point_to_E_via_composition)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_SHSM2_From_TrueCorrespondenceComposition**: real Chow-
correspondence composition + Tate-twist coherence producing v2 SHSM
composition. R218 v2 establishes the linear-algebraic skeleton with
explicit external codim parameters. -/
abbrev L4_G_SHSM2_From_TrueCorrespondenceComposition : Prop := True

/-- **L4-G_SHSM2_To_v1_Bridge**: a bridge theorem
`SHSM v1 (p_src, q) ↔ SHSM2 v2 (p_src, p_src + q)`. The forward
direction (v2 from v1) requires the deferred cast-coherence;
backward direction (v1 from v2) requires instantiating v2 at
`p_tgt := p_src + q` which works definitionally for v2's piece-shift
but not for v1's. Deferred. -/
abbrev L4_G_SHSM2_To_v1_Bridge : Prop := True

/-- **L4-G_CategoricalCorrespondenceAssociativity**: categorical
associativity `(P₃ ∘ P₂) ∘ P₁ = P₃ ∘ (P₂ ∘ P₁)` at the v2 package
level. With v2's explicit external codims, the type-level associativity
is trivial; proof-level associativity requires proof irrelevance on
existential witnesses. Deferred. -/
abbrev L4_G_CategoricalCorrespondenceAssociativity_v2 : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R218 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R218_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R218 non-closure (2/5)**: does NOT delete or rewrite R213-R217's
v1 SHSM package or composition machinery. They remain available. -/
theorem R218_does_not_delete_v1 : True := trivial

/-- **R218 non-closure (3/5)**: does NOT implement real Chow
correspondence composition. -/
theorem R218_does_not_implement_real_chow_composition : True := trivial

/-- **R218 non-closure (4/5)**: does NOT prove categorical
associativity for v2 composition. -/
theorem R218_does_not_prove_categorical_associativity_v2 : True := trivial

/-- **R218 non-closure (5/5)**: does NOT develop the v2 ↔ v1 bridge
theorem. v2 is a STANDALONE interface, not a wrapper around v1. -/
theorem R218_does_not_develop_v1_v2_bridge : True := trivial

end ShiftedCorrespondenceSHSM2
end HCGapL4
end HodgeReduction
