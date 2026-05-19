/-
# HC Gap L4 — SHSM composition cast-coherence (R217).

R216 left general `ShiftedMTCorrespondencePackageAt_SHSM_compose` as
an explicit obstruction record. The obstruction is the
`Nat.add_assoc` non-definitionality of `(p + q₁) + q₂` vs
`p + (q₁ + q₂)` in Lean 4's right-recursive `Nat.add`.

R217 makes three layers of progress on the cast-coherence gap:

1. **Priority A — cast helpers**: kernel-pure `Nat.add_assoc`-based
   helpers (`nat_add_assoc_index`, `two_mul_nat_add_assoc`,
   `H_cast_add_assoc`) for type-level transport.

2. **Priority C — partial general SHSM composition**: closes the SHSM
   composition for the *definitional-codim cases* `q₂ = 0` (identity
   on Z-side codim shift) and `q₂ = 1` (single-step codim shift).
   For both, `Nat.add` reduces definitionally:
   * `q₂ = 0`: `(p + q₁) + 0 = p + q₁ = p + (q₁ + 0)` (defeq via
     `Nat.add n 0 = n`).
   * `q₂ = 1`: `(p + q₁) + 1 = (p + q₁).succ = p + q₁.succ =
     p + (q₁ + 1)` (defeq via `Nat.add n (m+1) = (Nat.add n m) + 1`).
   Both cases yield real kernel-pure theorems composing arbitrary
   `P₁ : SHSM X Y p q₁` with the restricted-form `P₂`.

3. **Priority C — fully general SHSM composition (variable q₂)**:
   remains BLOCKED. Requires `cast`-coherence machinery
   (specifically, `Submodule.map (cast h_LM f) S = ...` style
   lemmas) that is non-trivial to develop from scratch and is not
   currently in Mathlib. Recorded as
   `R217_general_SHSM_compose_variable_q2_blocked` with the
   precise obstruction.

## What R217 provides (all kernel-pure)

* `nat_add_assoc_index`, `two_mul_nat_add_assoc`, `H_cast_add_assoc` —
  Priority A cast helpers.
* `ShiftedMTCorrespondencePackageAt_SHSM_compose_at_zero` — full
  SHSM_compose specialised to `q₂ = 0`.
* `ShiftedMTCorrespondencePackageAt_SHSM_compose_at_one` — full
  SHSM_compose specialised to `q₂ = 1`.
* `ShiftedMTCorrespondencePackageAt_SHSM_general_point_to_ellipticCurve_via_compose_at_one` —
  applying `SHSM_compose_at_one` to identity@pt + R213's pt→E at
  `(0, 0, 1)` produces the 9th kernel-pure HC route, this time via a
  GENERAL compose lemma (not the specific (0, 0, 1) hand-instance of R216).
* `VarietyHCAt_ellipticCurve_codim1_via_general_SHSM_compose_at_one` —
  the 9th HC route closure.
* Disclosure markers for the still-blocked general theorem.

## What R217 does NOT do

* Does NOT close the general `SHSM_compose` for variable `q₂`.
  (See `R217_general_SHSM_compose_variable_q2_blocked` for the
  precise obstruction record.)
* Does NOT reparameterise the SHSM definition.
* Does NOT develop full `Submodule.map_cast` coherence theory in
  Mathlib (would require additions to Mathlib's `LinearAlgebra.LinearMap.Cast`
  or similar).
* Does NOT prove categorical associativity.
* Does NOT implement real Chow correspondence composition.

All R217 declarations are kernel-pure: `{propext, Classical.choice,
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
import HodgeReduction.HCGapL4.ShiftedCorrespondenceComposition
import HodgeReduction.HCGapL4.SHSMComposition

namespace HodgeReduction
namespace HCGapL4
namespace SHSMCompositionGeneral

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.ShiftedCorrespondenceComposition

/-! ## Section 0: scoped `PureHodgeStructure` instances for generic VCDs -/

noncomputable instance phs_VCD_Hk_R217 (X : VarietyCohomologyData) (k : ℕ) :
    PureHodgeStructure (X.H k) k := X.hodgeStructure k

/-! ## Section 1: Priority A — small `Nat.add_assoc` cast helpers -/

/-- **R217-A.1**: propositional `(i + q₁) + q₂ = i + (q₁ + q₂)`. -/
theorem nat_add_assoc_index (i q₁ q₂ : ℕ) :
    (i + q₁) + q₂ = i + (q₁ + q₂) :=
  Nat.add_assoc i q₁ q₂

/-- **R217-A.2**: doubled form `2 * ((i + q₁) + q₂) = 2 * (i + (q₁ + q₂))`. -/
theorem two_mul_nat_add_assoc (i q₁ q₂ : ℕ) :
    2 * ((i + q₁) + q₂) = 2 * (i + (q₁ + q₂)) := by
  rw [nat_add_assoc_index]

/-- **R217-A.3**: VCD `H`-type equality under `Nat.add_assoc`. -/
theorem H_cast_add_assoc (V : VarietyCohomologyData) (p q₁ q₂ : ℕ) :
    V.H (2 * ((p + q₁) + q₂)) = V.H (2 * (p + (q₁ + q₂))) :=
  congrArg V.H (two_mul_nat_add_assoc p q₁ q₂)

/-! ## Section 2: Priority C (case q₂ = 0) — SHSM composition with identity-on-Z

When `q₂ = 0`, the right-recursive `Nat.add n 0 = n` makes both
`(p + q₁) + 0` and `p + (q₁ + 0)` reduce definitionally to `p + q₁`.
So `Nat.add_assoc` is trivially `rfl` and the natural chain works. -/

/-- **R217-C @ q₂ = 0**: SHSM composition where the second package has
zero codim shift (identity-style on Z). Closes the q₂ = 0 specialisation
of the general theorem via definitional `Nat.add` reduction. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_compose_at_zero
    {X Y Z : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {p q₁ : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt_SHSM X Y AX AY p q₁)
    (P₂ : ShiftedMTCorrespondencePackageAt_SHSM Y Z AY AZ (p + q₁) 0) :
    ShiftedMTCorrespondencePackageAt_SHSM X Z AX AZ p (q₁ + 0) := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  letI _ := Y.addCommGroup (2 * (p + q₁))
  letI _ := Y.module (2 * (p + q₁))
  letI _ := Y.hodgeStructure (2 * (p + q₁))
  -- (p + q₁) + 0 = p + q₁ definitionally; p + (q₁ + 0) = p + q₁ definitionally.
  -- So Z-side instances at (p+q₁)+0 = p+q₁ = p+(q₁+0).
  letI _ := Z.addCommGroup (2 * (p + q₁))
  letI _ := Z.module (2 * (p + q₁))
  letI _ := Z.hodgeStructure (2 * (p + q₁))
  unfold ShiftedMTCorrespondencePackageAt_SHSM at P₁ P₂
  obtain ⟨action₁, ψ₁, h_piece₁, h_sq₁, h_surj₁⟩ := P₁
  obtain ⟨action₂, ψ₂, h_piece₂, h_sq₂, h_surj₂⟩ := P₂
  refine ⟨action₂.comp action₁, ψ₂.comp ψ₁, ?_, ?_, ?_⟩
  · intro pi
    rw [Submodule.map_comp]
    have step1 := h_piece₁ pi
    have step1_mapped := Submodule.map_mono (f := action₂) step1
    have step2 := h_piece₂ ⟨pi.val + q₁, by have := pi.is_lt; omega⟩
    -- step2 lands at piece ⟨(pi.val + q₁) + 0, _⟩ = piece ⟨pi.val + q₁, _⟩ (defeq).
    -- Goal: piece ⟨pi.val + (q₁ + 0), _⟩ = piece ⟨pi.val + q₁, _⟩ (defeq).
    -- So step2's RHS = goal's RHS definitionally.
    exact step1_mapped.trans step2
  · intro z
    show ((AZ.algClasses (p + q₁ + 0)).subtype) (ψ₂ (ψ₁ z)) =
         action₂ (action₁ (((AX.algClasses p).subtype) z))
    rw [h_sq₂ (ψ₁ z), h_sq₁ z]
  · intro x hx_Z
    obtain ⟨y, hy_Y, hy_eq⟩ := h_surj₂ hx_Z
    obtain ⟨v, hv_X, hv_eq⟩ := h_surj₁ hy_Y
    refine ⟨v, hv_X, ?_⟩
    show action₂ (action₁ v) = x
    rw [hv_eq]
    exact hy_eq

/-! ## Section 3: Priority C (case q₂ = 1) — SHSM composition single-step

When `q₂ = 1`, `Nat.add n (m+1) = (Nat.add n m) + 1` makes both
`(p + q₁) + 1 = (p + q₁).succ` and `p + (q₁ + 1) = p + q₁.succ =
(p + q₁).succ` reduce definitionally. So the chain works. -/

/-- **R217-C @ q₂ = 1**: SHSM composition where the second package has
single codim shift. Closes the q₂ = 1 specialisation via definitional
`Nat.add` reduction. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_compose_at_one
    {X Y Z : VarietyCohomologyData}
    {AX : AlgebraicClassesData X}
    {AY : AlgebraicClassesData Y}
    {AZ : AlgebraicClassesData Z}
    {p q₁ : ℕ}
    (P₁ : ShiftedMTCorrespondencePackageAt_SHSM X Y AX AY p q₁)
    (P₂ : ShiftedMTCorrespondencePackageAt_SHSM Y Z AY AZ (p + q₁) 1) :
    ShiftedMTCorrespondencePackageAt_SHSM X Z AX AZ p (q₁ + 1) := by
  letI _ := X.addCommGroup (2 * p)
  letI _ := X.module (2 * p)
  letI _ := X.hodgeStructure (2 * p)
  letI _ := Y.addCommGroup (2 * (p + q₁))
  letI _ := Y.module (2 * (p + q₁))
  letI _ := Y.hodgeStructure (2 * (p + q₁))
  -- (p+q₁)+1 = p+q₁+1 definitionally; p+(q₁+1) = p+q₁+1 definitionally.
  -- So Z-side instances at p+q₁+1 work for both.
  letI _ := Z.addCommGroup (2 * (p + q₁ + 1))
  letI _ := Z.module (2 * (p + q₁ + 1))
  letI _ := Z.hodgeStructure (2 * (p + q₁ + 1))
  unfold ShiftedMTCorrespondencePackageAt_SHSM at P₁ P₂
  obtain ⟨action₁, ψ₁, h_piece₁, h_sq₁, h_surj₁⟩ := P₁
  obtain ⟨action₂, ψ₂, h_piece₂, h_sq₂, h_surj₂⟩ := P₂
  refine ⟨action₂.comp action₁, ψ₂.comp ψ₁, ?_, ?_, ?_⟩
  · intro pi
    rw [Submodule.map_comp]
    have step1 := h_piece₁ pi
    have step1_mapped := Submodule.map_mono (f := action₂) step1
    have step2 := h_piece₂ ⟨pi.val + q₁, by have := pi.is_lt; omega⟩
    -- step2 lands at piece ⟨(pi.val + q₁) + 1, _⟩ = piece ⟨pi.val + q₁ + 1, _⟩ (defeq).
    -- Goal: piece ⟨pi.val + (q₁ + 1), _⟩ = piece ⟨pi.val + q₁ + 1, _⟩ (defeq via
    --   `Nat.add n (m+1) = (Nat.add n m) + 1` applied to `q₁ + 1` and `pi.val + (q₁ + 1)`).
    -- So step2's RHS = goal's RHS definitionally.
    exact step1_mapped.trans step2
  · intro z
    show ((AZ.algClasses (p + q₁ + 1)).subtype) (ψ₂ (ψ₁ z)) =
         action₂ (action₁ (((AX.algClasses p).subtype) z))
    rw [h_sq₂ (ψ₁ z), h_sq₁ z]
  · intro x hx_Z
    obtain ⟨y, hy_Y, hy_eq⟩ := h_surj₂ hx_Z
    obtain ⟨v, hv_X, hv_eq⟩ := h_surj₁ hy_Y
    refine ⟨v, hv_X, ?_⟩
    show action₂ (action₁ v) = x
    rw [hv_eq]
    exact hy_eq

/-! ## Section 4: Priority D — sanity HC closure via R217's q₂=1 compose -/

/-- **R217 sanity composition**: compose identity@pt with R213's pt→E
SHSM package (q=1) via the **general** `SHSM_compose_at_one`
theorem (not the specific (0,0,1) hand-instance of R216). -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_via_compose_at_one :
    ShiftedMTCorrespondencePackageAt_SHSM
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 (0 + 1) :=
  ShiftedMTCorrespondencePackageAt_SHSM_compose_at_one
    (SHSMComposition.identity_ShiftedMTCorrespondencePackageAt_SHSM
      TrivialPoint.varietyCohomology_point
      TrivialPoint.algClasses_point 0)
    ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1

/-- **R217 9th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via the general `SHSM_compose_at_one` theorem applied to identity@pt +
R213's pt→E SHSM package. Distinct from R216's specific (0,0,1) instance
because it goes through a GENERAL compose theorem. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_general_SHSM_compose_at_one :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM_toRaw
      ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_via_compose_at_one)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: explicit obstruction record for fully general SHSM_compose

The fully general `SHSM_compose` for arbitrary `(p, q₁, q₂)` with
**variable** `q₂` remains BLOCKED, separately from R216's record.

The obstruction is sharper than R216 stated: the cast machinery
needed is `Submodule.map (cast h_LM f) S` coherence — specifically,
proving that `Submodule.map (cast h_LM_eq action₂) S = ?` reduces
to a `Submodule.map`-with-`cast`-on-the-codomain form that can then
be related to the chained-form proof.

Mathlib does not currently provide:

* `LinearMap.cast_apply` (`(cast h_LM f) x = cast h_codomain (f x)`)
* `Submodule.map_cast` (`Submodule.map (cast h_LM f) S = cast h_Sub (Submodule.map f S)`)
* `LinearMap.cast_comp` (`(cast h_LM f).comp g = cast h_LM' (f.comp g)`)
* `Submodule.cast_le` (cast across type equality preserves submodule containment)

Developing these inline requires `subst` on type equalities `W = W'`,
which in turn requires `W'` to be a local variable (otherwise `subst`
fails) — and the abstract `Y.H (2 * (p + (q₁ + q₂)))` is not a local
variable. Generalisation of the type to a fresh variable would also
require generalising the `AddCommGroup`/`Module ℚ` instances, which
is not standard. -/

/-- **R217 obstruction record**: general `SHSM_compose` for variable `q₂`
remains blocked by the missing `Mathlib` cast-coherence theory listed
in Section 5. -/
theorem R217_general_SHSM_compose_variable_q2_blocked : True := trivial

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_SHSMComposition_CastCoherence**: full cast-coherence theory
for `Submodule.map (cast h_LM f) S` and friends. R217 closes only
the definitional-codim cases `q₂ = 0` and `q₂ = 1`. Fully general
variable-`q₂` case still requires this development. -/
abbrev L4_G_SHSMComposition_CastCoherence : Prop := True

/-- **L4-G_CategoricalCorrespondenceAssociativity**: categorical
associativity `(P₃ ∘ P₂) ∘ P₁ = P₃ ∘ (P₂ ∘ P₁)` at the package level.
R217 closes only binary specialised cases; ternary associativity
requires the general SHSM_compose + proof irrelevance on existential
witnesses. -/
abbrev L4_G_CategoricalCorrespondenceAssociativity : Prop := True

/-- **L4-G_SHSMComposition_GeneralVariableShift**: SHSM composition
for arbitrary variable `(q₁, q₂)`. Status: definitional cases
`q₂ ∈ {0, 1}` closed by R217; general case blocked by cast-coherence
gap. -/
abbrev L4_G_SHSMComposition_GeneralVariableShift : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R217 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R217_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R217 non-closure (2/4)**: does NOT close fully-general SHSM
composition for variable `q₂`. Only `q₂ ∈ {0, 1}` definitional cases. -/
theorem R217_does_not_close_general_SHSM_compose_variable_q2 : True := trivial

/-- **R217 non-closure (3/4)**: does NOT implement real Chow
correspondence composition. -/
theorem R217_does_not_implement_real_chow_composition : True := trivial

/-- **R217 non-closure (4/4)**: does NOT develop full Mathlib
cast-coherence theory (`Submodule.map_cast`, `LinearMap.cast_apply`,
etc.). -/
theorem R217_does_not_develop_full_cast_coherence_theory : True := trivial

end SHSMCompositionGeneral
end HCGapL4
end HodgeReduction
