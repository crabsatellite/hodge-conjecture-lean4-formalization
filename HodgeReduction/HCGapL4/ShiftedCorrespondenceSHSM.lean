/-
# HC Gap L4 — SHSM-bundled shifted MT correspondence package (R213).

R212 introduced `ShiftedMTCorrespondencePackageAt` as a minimum
prototype: action is a raw ℚ-LinearMap, with no piece-preservation
enforcement. R211 introduced `ShiftedHodgeStructureMorphism V W m q`
carrying a Tate-twist `map_piece_shifted` field. R213 closes the loop:
define `ShiftedMTCorrespondencePackageAt_SHSM`, a strictly Hodge-bundled
variant that ENFORCES piece-shift compatibility inside the package
itself, and prove a `toRaw` forgetful theorem deriving R212's raw
package from any SHSM-bundled instance.

## What R213 provides (all kernel-pure)

* `ShiftedMTCorrespondencePackageAt_SHSM X Y AX AY p_src q` —
  SHSM-bundled prototype, parameterised by source codim `p_src` and
  codim SHIFT `q`. Target codim is `p_src + q`. Includes an explicit
  Tate-twist piece-shift hypothesis.
* `ShiftedMTCorrespondencePackageAt_SHSM_toRaw` — forgetful theorem
  dropping the piece-shift hypothesis (recovers R212's raw package at
  `(p_src, p_src + q)`).
* `ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1` —
  concrete kernel-pure instance at `(p_src, q) = (0, 1)`.
* `VarietyHCAt_ellipticCurve_codim1_via_SHSM_shifted_cycle_induced_correspondence` —
  reclosure of R212's HC result, now via the SHSM-bundled route.
* `cycleActionSHSM_R213_agrees_with_R211_fundamentalCycle` — optional
  agreement: R211's `cycleActionSHSM_H0_to_H2_pointCycle.toLinearMap`
  is pointwise equal to the action used in R213.

## Design choice: parameterise by `(p_src, q)` not `(p_src, p_tgt, h_shift)`

The Fin-bound proof inside the piece-shift hypothesis needs
`p.val + q < 2 * (p_src + q) + 1`. With `p.val ≤ 2 * p_src`, this
reduces to `2 * p_src + q ≤ 2 * p_src + 2 * q`, i.e., `q ≤ 2 * q`,
which is true unconditionally in ℕ — `omega` closes it without
needing the awkward `h_shift : p_src ≤ p_tgt` hypothesis that the
`(p_src, p_tgt)` parameterisation would require. Target codim is
recovered as `p_src + q`.

## What R213 does NOT do

* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT implement a real Chow-group cycle correspondence.
* It does NOT implement real Mathlib scheme-level products /
  push-pull-cup formula.
* It does NOT promote the SHSM-bundled prototype to "final" MT
  package; still a prototype transfer interface (now with Hodge-side
  enforcement).

All R213 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1
import HodgeReduction.HCGapL4.ShiftedCorrespondence

namespace HodgeReduction
namespace HCGapL4
namespace ShiftedCorrespondenceSHSM

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence

/-! ## Section 1: SHSM-bundled shifted MT package

Same shape as R212's raw `ShiftedMTCorrespondencePackageAt`, with
ONE additional conjunct: a Tate-twist piece-shift hypothesis
encoding R211's `map_piece_shifted`. -/

/-- **R213 SHSM-bundled prototype**: codim-shifted MT correspondence
package with explicit Tate-twist piece-shift hypothesis. Parameters
are source codim `p_src` and codim SHIFT `q`; target codim is
`p_src + q`. -/
def ShiftedMTCorrespondencePackageAt_SHSM
    (X_src X_tgt : VarietyCohomologyData)
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    (p_src q : ℕ) : Prop :=
  letI _ := X_src.addCommGroup (2 * p_src)
  letI _ := X_src.module (2 * p_src)
  letI _ := X_src.hodgeStructure (2 * p_src)
  letI _ := X_tgt.addCommGroup (2 * (p_src + q))
  letI _ := X_tgt.module (2 * (p_src + q))
  letI _ := X_tgt.hodgeStructure (2 * (p_src + q))
  ∃ (action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * (p_src + q)))
    (ψ : ↥(A_src.algClasses p_src) →ₗ[ℚ] ↥(A_tgt.algClasses (p_src + q))),
    -- (1) Tate-twist piece shift: source piece `p` maps into target
    --     piece `p.val + q`. Explicit `Fin (2 * (p_src + q) + 1)`
    --     annotation forces typeclass `[PureHodgeStructure W (2 * (p_src + q))]`
    --     so the upper-bound proof goal is concrete.
    (∀ (p : Fin (2 * p_src + 1)),
      Submodule.map action
          (PureHodgeStructure.piece (V := X_src.H (2 * p_src)) p) ≤
        PureHodgeStructure.piece (V := X_tgt.H (2 * (p_src + q)))
          (⟨p.val + q, by
            have hp := p.is_lt
            omega⟩ : Fin (2 * (p_src + q) + 1))) ∧
    -- (2) Commuting square (same as R212).
    (∀ z : ↥(A_src.algClasses p_src),
      ((A_tgt.algClasses (p_src + q)).subtype) (ψ z) =
        action (((A_src.algClasses p_src).subtype) z)) ∧
    -- (3) Hodge-class surjectivity (same as R212).
    PureHodgeStructure.hodgeClasses (X_tgt.H (2 * (p_src + q))) (p_src + q) ≤
      Submodule.map action
        (PureHodgeStructure.hodgeClasses (X_src.H (2 * p_src)) p_src)

/-! ## Section 2: forgetful `toRaw` theorem -/

/-- **R213 forgetful theorem**: any SHSM-bundled shifted package
yields R212's raw shifted package at `(p_src, p_src + q)` by dropping
the piece-shift hypothesis. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_toRaw
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p_src q : ℕ}
    (h_pkg : ShiftedMTCorrespondencePackageAt_SHSM
              X_src X_tgt A_src A_tgt p_src q) :
    ShiftedMTCorrespondencePackageAt
      X_src X_tgt A_src A_tgt p_src (p_src + q) := by
  letI _ := X_src.addCommGroup (2 * p_src)
  letI _ := X_src.module (2 * p_src)
  letI _ := X_src.hodgeStructure (2 * p_src)
  letI _ := X_tgt.addCommGroup (2 * (p_src + q))
  letI _ := X_tgt.module (2 * (p_src + q))
  letI _ := X_tgt.hodgeStructure (2 * (p_src + q))
  unfold ShiftedMTCorrespondencePackageAt_SHSM at h_pkg
  obtain ⟨action, ψ, _h_piece_shift, h_square, h_surj⟩ := h_pkg
  exact ⟨action, ψ, h_square, h_surj⟩

/-! ## Section 3: concrete SHSM-bundled package for `pt → E` at `(0, 1)`

`(p_src, q) = (0, 1)`: source codim 0 (`H^0(pt)`), target codim
`0 + 1 = 1` (`H^2(E)`). Hodge shift by 1 Tate twist. -/

/-- **R213 milestone**: kernel-pure SHSM-bundled shifted MT package
from the point (codim 0) to the elliptic curve (codim 1), with action
constructed as R211's codim-1 point cycle action. The piece-shift
hypothesis is discharged via the same `piece_ℚ_w0_zero` /
`piece_ℚ_Tate2_one` rewrites used in R211's `cycleActionSHSM_H0_to_H2_pointCycle`. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1 :
    ShiftedMTCorrespondencePackageAt_SHSM
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 := by
  refine ⟨cycleAction_H0_to_H2_pointCycle,
          psi_codim0_to_codim1_point_to_ellipticCurve, ?_, ?_, ?_⟩
  · -- (1) Piece shift: source piece ⟨0,_⟩ = ⊤ maps into target piece
    --     ⟨0 + 1, _⟩ = ⟨1, _⟩ of Tate-Hodge weight 2 = ⊤.
    intro p
    fin_cases p
    show Submodule.map _ _ ≤
      ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 1, by omega⟩
    show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact le_top
  · -- (2) Commuting square: subtype (ψ z) = action (subtype z) = z.val
    intro z
    rfl
  · -- (3) Hodge surjectivity: hodgeClasses_E 1 = ⊤ ≤ map id ⊤ = ⊤
    intro x _
    refine ⟨x, ?_, ?_⟩
    · show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      rw [TrivialWeight.piece_ℚ_w0_zero]
      exact Submodule.mem_top
    · rfl

/-! ## Section 4: HC closure via SHSM-bundled route + R212 transfer -/

/-- **R213 closure**: HC at codim 1 for the elliptic curve, derived
from the **SHSM-bundled** shifted cycle-induced correspondence via
`toRaw` + R212's `VarietyHCAt_of_shifted_correspondence`. Reclosure
of the R212 result through the more-Hodge-safe route. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_SHSM_shifted_cycle_induced_correspondence :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM_toRaw
      ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: optional — agreement with R211's `cycleActionSHSM`

R211 built `cycleActionSHSM_H0_to_H2_pointCycle :
ShiftedHodgeStructureMorphism (...) 0 1` whose `.toLinearMap` is
`cycleAction_H0_to_H2_pointCycle`. R213's SHSM-bundled package uses
the same action by construction; the pointwise agreement is `rfl`. -/

/-- **R213 optional agreement**: R211's
`cycleActionSHSM_H0_to_H2_pointCycle.toLinearMap` is the action used
in R213's SHSM-bundled package, pointwise. Confirms the SHSM-bundled
route is genuinely a use of R211's SHSM, not an independent definition. -/
@[simp] theorem cycleActionSHSM_R213_agrees_with_R211_fundamentalCycle (x : ℚ) :
    cycleActionSHSM_H0_to_H2_pointCycle.toLinearMap x =
    cycleAction_H0_to_H2_pointCycle x := rfl

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_SHSMShiftedPackage_From_ChowCycle**: a constructor
`(Z ∈ CH^q(X × Y)_ℚ) ↦ ShiftedMTCorrespondencePackageAt_SHSM X Y AX
AY p_src q` lifting a real Chow-group cycle to the SHSM-bundled
package via the cycle class map. R213 hand-builds only the specific
`pt → E` case at `(0, 1)`. -/
abbrev L4_G_SHSMShiftedPackage_From_ChowCycle : Prop := True

/-- **L4-G_SHSMShiftedPackage_TateTwistGeneralization**: the
SHSM-bundled package's piece-shift hypothesis enforces the Tate
twist by `q`. A full Tate-twist API (composition, identity-at-zero-
shift, contravariance under shift inversion) is deferred. -/
abbrev L4_G_SHSMShiftedPackage_TateTwistGeneralization : Prop := True

/-- **L4-G_SHSMShiftedPackage_To_TrueMTCorrespondence**: promoting
the SHSM-bundled prototype to a "final" MT correspondence package
requires bundling additional data (explicit Tate twist Lie-algebra
interpretation, MT-group compatibility, integral lattice matching).
R213's package is the kernel-pure linear-algebraic skeleton. -/
abbrev L4_G_SHSMShiftedPackage_To_TrueMTCorrespondence : Prop := True

/-- **L4-G_SHSMShiftedPackage_PushPullCupCompatibility**: verifying
the SHSM-bundled action is the actual cohomological push-pull-cup of
a real algebraic cycle on `X × Y`. R213's action is a linear-algebraic
stand-in, with the cycle-induced framing supported only at the
internal model level (R211 `cycleAction_H0_to_H2_pointCycle`). -/
abbrev L4_G_SHSMShiftedPackage_PushPullCupCompatibility : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R213 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R213_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R213 non-closure (2/5)**: does NOT implement a real Chow group
or cycle class map. -/
theorem R213_does_not_implement_real_chow : True := trivial

/-- **R213 non-closure (3/5)**: does NOT implement real Mathlib
scheme-level products or push-pull-cup. -/
theorem R213_does_not_implement_real_scheme_product_or_pushpullcup : True := trivial

/-- **R213 non-closure (4/5)**: SHSM-bundled package is still a
PROTOTYPE transfer interface, NOT a final MT correspondence package.
R213 only tightens R212's raw-LinearMap action to include explicit
Hodge piece-shift compatibility. -/
theorem R213_SHSMPackage_is_prototype_not_final : True := trivial

/-- **R213 non-closure (5/5)**: only the specific `(p_src, q) =
(0, 1)` instance for `pt → E` is hand-built. A general construction
quantified over arbitrary VCDs / codim shifts is deferred. -/
theorem R213_only_codim0_to_codim1_instance : True := trivial

end ShiftedCorrespondenceSHSM
end HCGapL4
end HodgeReduction
