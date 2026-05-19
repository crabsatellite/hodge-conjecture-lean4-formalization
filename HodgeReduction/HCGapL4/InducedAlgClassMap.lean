/-
# HC Gap L4 — induced algebraic-class map (R214).

R213's SHSM-bundled shifted MT correspondence package took the
cohomology `action` field from R211's `cycleAction_H0_to_H2_pointCycle`
(genuinely cycle-induced) but the algebraic-class linear map `ψ` was
constructed independently (`psi_codim0_to_codim1_point_to_ellipticCurve`)
without explicit derivation from `action`.

R214 closes this structural gap: define a generic `inducedAlgClassMap`
that, given a cohomology action plus a proof that the action preserves
algebraic-class membership, automatically constructs the ℚ-linear map
between algClasses subtypes. The commuting square between the induced
map and the action becomes `rfl`. R213's SHSM-bundled package is then
reclosed with the induced ψ, and HC at codim 1 of `E` is re-derived
through the fully cycle-action-driven route.

## What R214 provides (all kernel-pure)

* `inducedAlgClassMap A_src A_tgt action h_preserves` — generic
  constructor lifting `action : H^{2 p_src}(X_src) →ₗ[ℚ] H^{2 p_tgt}(X_tgt)`
  plus algebraic-class preservation to a ℚ-linear map
  `↥(A_src.algClasses p_src) →ₗ[ℚ] ↥(A_tgt.algClasses p_tgt)`.
* `inducedAlgClassMap_subtype_apply` — commuting-square `rfl` lemma.
* `cycleAction_H0_to_H2_preserves_algClasses_point_to_ellipticCurve` —
  preservation witness for R211's codim-1 point cycle action.
* `ShiftedMTCorrespondencePackageAt_SHSM_..._inducedPsi` — SHSM-bundled
  package with the induced ψ.
* `VarietyHCAt_..._inducedPsi` — HC reclosure through the induced ψ
  route.
* `inducedPsi_agrees_with_R213_psi` — pointwise agreement with R213's
  hand-written ψ.

## What R214 does NOT do

* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT implement real Chow-group functoriality.
* It does NOT implement real push-pull-cup on arbitrary schemes.
* It does NOT make `inducedAlgClassMap` derivable from a "true"
  Chow-correspondence pushforward — the preservation hypothesis must
  still be supplied.

All R214 declarations are kernel-pure: `{propext, Classical.choice,
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

namespace HodgeReduction
namespace HCGapL4
namespace InducedAlgClassMap

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM

/-! ## Section 0: generic scoped typeclass instances on `VCD.H k`

To define `inducedAlgClassMap` generically over arbitrary `X_src,
X_tgt : VarietyCohomologyData`, the function-type elaboration needs
`AddCommGroup (X.H k)` and `Module ℚ (X.H k)` for any `X, k`.
Declare them as scoped instances parameterised by `X` and `k`. -/

noncomputable instance acg_VCD_Hk (X : VarietyCohomologyData) (k : ℕ) :
    AddCommGroup (X.H k) := X.addCommGroup k

noncomputable instance mod_VCD_Hk (X : VarietyCohomologyData) (k : ℕ) :
    Module ℚ (X.H k) := X.module k

/-! ## Section 1: generic `inducedAlgClassMap` -/

/-- **R214 generic constructor**: given a cohomology `action :
H^{2 p_src}(X_src) →ₗ[ℚ] H^{2 p_tgt}(X_tgt)` and a proof `h_preserves`
that `action` sends `A_src.algClasses p_src` into `A_tgt.algClasses p_tgt`,
produce the ℚ-linear map between algClasses subtypes. -/
noncomputable def inducedAlgClassMap
    {X_src X_tgt : VarietyCohomologyData}
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    {p_src p_tgt : ℕ}
    (action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * p_tgt))
    (h_preserves : ∀ x ∈ A_src.algClasses p_src,
                     action x ∈ A_tgt.algClasses p_tgt) :
    ↥(A_src.algClasses p_src) →ₗ[ℚ] ↥(A_tgt.algClasses p_tgt) where
  toFun z := ⟨action z.val, h_preserves z.val z.property⟩
  map_add' x y := by
    apply Subtype.ext
    exact action.map_add x.val y.val
  map_smul' c x := by
    apply Subtype.ext
    exact action.map_smul c x.val

/-! ## Section 2: commuting square lemma -/

/-- **R214 commuting square (rfl)**: the subtype inclusion of
`inducedAlgClassMap action h z` equals `action` applied to the subtype
inclusion of `z`. Direct from the def — the induced map's `.val` IS
`action z.val`. -/
@[simp] theorem inducedAlgClassMap_subtype_apply
    {X_src X_tgt : VarietyCohomologyData}
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    {p_src p_tgt : ℕ}
    (action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * p_tgt))
    (h_preserves : ∀ x ∈ A_src.algClasses p_src,
                     action x ∈ A_tgt.algClasses p_tgt)
    (z : ↥(A_src.algClasses p_src)) :
    ((A_tgt.algClasses p_tgt).subtype)
        (inducedAlgClassMap A_src A_tgt action h_preserves z) =
      action (((A_src.algClasses p_src).subtype) z) := rfl

/-! ## Section 3: preservation witness for R211 codim-1 point cycle action

`algClasses_ellipticCurve 1` = `⊤ : Submodule ℚ ℚ` (R203 case-split).
Any element is in `⊤`, including the image of `cycleAction_H0_to_H2_pointCycle`. -/

/-- **R214 preservation witness**: R211's codim-1 point cycle action
sends elements of `algClasses_point 0` into `algClasses_ellipticCurve 1`.
For our internal model, `algClasses_ellipticCurve 1 = ⊤`, so this is
trivially via `Submodule.mem_top`. -/
theorem cycleAction_H0_to_H2_preserves_algClasses_point_to_ellipticCurve :
    ∀ x ∈ TrivialPoint.algClasses_point.algClasses 0,
      cycleAction_H0_to_H2_pointCycle x ∈
        EllipticCurve.AlgebraicClassesData_ellipticCurve.algClasses 1 := by
  intro x _
  exact Submodule.mem_top

/-! ## Section 4: rebuild SHSM package with induced ψ -/

/-- **R214 milestone**: kernel-pure SHSM-bundled shifted MT package
from point (codim 0) to elliptic curve (codim 1), with **ψ derived
from action via `inducedAlgClassMap`** rather than constructed
independently. The commuting square is `rfl` via
`inducedAlgClassMap_subtype_apply`. -/
theorem ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1_inducedPsi :
    ShiftedMTCorrespondencePackageAt_SHSM
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 := by
  refine ⟨cycleAction_H0_to_H2_pointCycle,
          inducedAlgClassMap _ _ cycleAction_H0_to_H2_pointCycle
            cycleAction_H0_to_H2_preserves_algClasses_point_to_ellipticCurve,
          ?_, ?_, ?_⟩
  · -- (1) Piece shift: same as R213.
    intro p
    fin_cases p
    show Submodule.map _ _ ≤
      ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 1, by omega⟩
    show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact le_top
  · -- (2) Commuting square: directly from `inducedAlgClassMap_subtype_apply`.
    intro z
    exact inducedAlgClassMap_subtype_apply _ _ _ _ z
  · -- (3) Hodge surjectivity: same as R213.
    intro x _
    refine ⟨x, ?_, ?_⟩
    · show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      rw [TrivialWeight.piece_ℚ_w0_zero]
      exact Submodule.mem_top
    · rfl

/-! ## Section 5: reclose HC via induced-ψ route -/

/-- **R214 reclosure**: HC at codim 1 for the elliptic curve, derived
via the **induced-ψ** SHSM-bundled shifted cycle-induced
correspondence. Fully cycle-action-driven route: both `action` and
`ψ` originate from R211's cycle action (the latter via R214's
`inducedAlgClassMap`). -/
theorem VarietyHCAt_ellipticCurve_codim1_via_SHSM_shifted_cycle_induced_correspondence_inducedPsi :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM_toRaw
      ShiftedMTCorrespondencePackageAt_SHSM_point_to_ellipticCurve_codim0_to_codim1_inducedPsi)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 6: optional — induced ψ agrees with R213 hand-written ψ -/

/-- **R214 optional agreement**: R214's induced ψ is pointwise equal
to R213's hand-written `psi_codim0_to_codim1_point_to_ellipticCurve`.
Both have `.val = z.val`, so after `Subtype.ext` the goal is `rfl`. -/
theorem inducedPsi_agrees_with_R213_psi
    (z : ↥(TrivialPoint.algClasses_point.algClasses 0)) :
    inducedAlgClassMap _ _ cycleAction_H0_to_H2_pointCycle
        cycleAction_H0_to_H2_preserves_algClasses_point_to_ellipticCurve z =
      psi_codim0_to_codim1_point_to_ellipticCurve z := by
  apply Subtype.ext
  rfl

/-! ## Section 7: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_InducedAlgClassMap_From_ChowFunctoriality**: a true
Chow-functoriality version of `inducedAlgClassMap` would not require
the `h_preserves` hypothesis — it would be a theorem derivable from
the fact that a real cycle correspondence's cohomological action
automatically maps cycle classes to cycle classes. R214's prototype
takes preservation as an input. -/
abbrev L4_G_InducedAlgClassMap_From_ChowFunctoriality : Prop := True

/-- **L4-G_CorrespondenceAction_PreservesCycleClassImages**: the
general statement "the cohomological action of an algebraic
correspondence preserves cycle-class image submodules" requires real
Chow-group + cycle class map infrastructure. R214 establishes the
specific instance for the codim-1 point cycle action on `pt × E`. -/
abbrev L4_G_CorrespondenceAction_PreservesCycleClassImages : Prop := True

/-- **L4-G_InducedPsi_AgreesWith_TruePushPull**: agreement of the
induced ψ with the actual cohomological pushforward via a real
algebraic correspondence cycle. R214 only proves agreement with
R213's hand-written ψ (which itself was a linear-algebraic stand-in). -/
abbrev L4_G_InducedPsi_AgreesWith_TruePushPull : Prop := True

/-- **L4-G_GeneralCycleInducedShiftedPackage**: a fully cycle-induced
shifted MT correspondence package construction quantified over
arbitrary `(X_src, X_tgt, p_src, q, cycle)`, producing both the
action and the induced ψ from the cycle data alone. R214 hand-builds
only the `pt → E` at `(0, 1)` instance. -/
abbrev L4_G_GeneralCycleInducedShiftedPackage : Prop := True

/-! ## Section 8: explicit non-closure -/

/-- **R214 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R214_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R214 non-closure (2/5)**: does NOT implement real Chow group
or its cycle class map. -/
theorem R214_does_not_implement_real_chow : True := trivial

/-- **R214 non-closure (3/5)**: does NOT implement real
push-pull-cup on arbitrary schemes. -/
theorem R214_does_not_implement_real_pushpullcup : True := trivial

/-- **R214 non-closure (4/5)**: `inducedAlgClassMap` requires a
`h_preserves` hypothesis. Real Chow-functoriality would make this
automatic from a correspondence cycle's pushforward, but R214 does
NOT claim that level of generality. -/
theorem R214_does_not_claim_real_chow_functoriality : True := trivial

/-- **R214 non-closure (5/5)**: only the specific `pt → E` at `(0, 1)`
instance is hand-built. A general cycle-induced shifted package
constructor across arbitrary VCDs / cycles is deferred. -/
theorem R214_only_internal_action_induced : True := trivial

end InducedAlgClassMap
end HCGapL4
end HodgeReduction
