/-
# HC Gap L4 — generic internal cycle-action factory (R221).

R211-R220 hand-built specific instances of the codim-1 point cycle
action for `pt → E`. Each instance reconstructed the same
(action, preservation, hodge surjectivity, piece-shift) bundle from
scratch. R221 abstracts these into a reusable **factory structure**
`InternalCycleActionData_SHSM` that bundles the four ingredients
and produces a v2 SHSM2 package via `.to_SHSM2`.

The factory is a LINEAR-ALGEBRAIC stand-in for genuine Chow-cycle
push-pull-cup correspondence. R221 retains hooks for future
product-cycle provenance via the optional sister structure
`InternalCycleActionData` (without piece-shift), which produces R212
raw shifted package via `.to_R212_raw`. Full push-pull-cup semantics
are NOT enforced this round.

## What R221 provides (all kernel-pure)

* `InternalCycleActionData` — basic factory: action, preservation,
  hodge surjectivity. Produces R212 raw shifted package.
* `InternalCycleActionData.to_R212_raw` — conversion to raw R212.
* `InternalCycleActionData_SHSM` — SHSM-bundled factory extending
  the basic with shift / h_shift / piece-shift.
* `InternalCycleActionData_SHSM.toBase` — forget the SHSM extension,
  recover basic.
* `InternalCycleActionData_SHSM.to_SHSM2` — conversion to R218 v2
  SHSM2 package (ψ derived via R214 `inducedAlgClassMap`).
* `internalCycleActionData_SHSM_point_to_ellipticCurve` — concrete
  pt → E instance of the factory at `(0, 1)`.
* `SHSM2_point_to_E_from_internalCycleAction` — pt → E SHSM2 derived
  from the factory.
* `VarietyHCAt_ellipticCurve_codim1_via_internalCycleAction` — 13th
  kernel-pure HC route via the factory.

## What R221 does NOT do

* Does NOT implement real Chow correspondence push-pull-cup.
* Does NOT enforce product-cycle provenance (optional field omitted).
* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT do compose4 / n-step composition.
* Does NOT prove categorical associativity.
* Does NOT deprecate v1 as main work.

All R221 declarations are kernel-pure: `{propext, Classical.choice,
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
import HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

namespace HodgeReduction
namespace HCGapL4
namespace GenericCycleAction

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1
open HodgeReduction.HCGapL4.ShiftedCorrespondence
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM
open HodgeReduction.HCGapL4.InducedAlgClassMap
open HodgeReduction.HCGapL4.ShiftedCorrespondenceSHSM2

/-! ## Section 1: basic factory — `InternalCycleActionData`

Bundles the three ingredients needed for R212's raw shifted MT
correspondence package: action, algebraic-class preservation, target
Hodge-class surjectivity. -/

/-- **R221 basic factory**: linear-algebraic internal cycle-action
data, sufficient to produce R212's raw shifted MT correspondence
package. ψ is derived from preservation via R214 `inducedAlgClassMap`. -/
structure InternalCycleActionData
    (X_src X_tgt : VarietyCohomologyData)
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    (p_src p_tgt : ℕ) where
  /-- Cohomology action `H^{2 p_src}(X_src) →ₗ[ℚ] H^{2 p_tgt}(X_tgt)`. -/
  action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * p_tgt)
  /-- The action preserves the algebraic-class submodule (target's
  algClasses contains the image of source's algClasses). -/
  preservesAlgClasses :
    ∀ x ∈ A_src.algClasses p_src,
      action x ∈ A_tgt.algClasses p_tgt
  /-- Hodge-class surjectivity: every target Hodge class lifts via
  the action to a source Hodge class. -/
  hodgeSurj :
    PureHodgeStructure.hodgeClasses (X_tgt.H (2 * p_tgt)) p_tgt ≤
      Submodule.map action
        (PureHodgeStructure.hodgeClasses (X_src.H (2 * p_src)) p_src)

/-- **R221 conversion**: basic factory data yields R212's raw shifted
MT correspondence package. -/
theorem InternalCycleActionData.to_R212_raw
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p_src p_tgt : ℕ}
    (data : InternalCycleActionData X_src X_tgt A_src A_tgt p_src p_tgt) :
    ShiftedMTCorrespondencePackageAt X_src X_tgt A_src A_tgt p_src p_tgt :=
  ⟨data.action,
   inducedAlgClassMap A_src A_tgt data.action data.preservesAlgClasses,
   fun z => inducedAlgClassMap_subtype_apply A_src A_tgt data.action
              data.preservesAlgClasses z,
   data.hodgeSurj⟩

/-! ## Section 2: SHSM factory — `InternalCycleActionData_SHSM`

Extends the basic factory with the Tate-twist piece-shift compatibility
needed for R218's v2 SHSM2 package. -/

/-- **R221 SHSM factory**: linear-algebraic internal cycle-action data
with Tate-twist piece-shift compatibility. Produces R218's v2 SHSM2
package. -/
structure InternalCycleActionData_SHSM
    (X_src X_tgt : VarietyCohomologyData)
    (A_src : AlgebraicClassesData X_src)
    (A_tgt : AlgebraicClassesData X_tgt)
    (p_src p_tgt : ℕ)
    extends InternalCycleActionData X_src X_tgt A_src A_tgt p_src p_tgt where
  /-- The Tate twist shift `q`. -/
  shift : ℕ
  /-- Codim-shift equation `p_tgt = p_src + shift`. -/
  h_shift : p_tgt = p_src + shift
  /-- Tate-twist piece-shift compatibility: source piece `p_idx` maps
  into target piece `p_idx.val + shift`. -/
  pieceShift :
    ∀ (p_idx : Fin (2 * p_src + 1)),
      Submodule.map action
          (PureHodgeStructure.piece (V := X_src.H (2 * p_src)) p_idx) ≤
        PureHodgeStructure.piece (V := X_tgt.H (2 * p_tgt))
          (⟨p_idx.val + shift, by
            have := p_idx.is_lt
            have := h_shift
            omega⟩ : Fin (2 * p_tgt + 1))

/-- **R221 conversion**: SHSM factory data yields R218's v2 SHSM2
package. ψ is derived via R214 `inducedAlgClassMap`; commuting square
is `rfl` via `inducedAlgClassMap_subtype_apply`. -/
theorem InternalCycleActionData_SHSM.to_SHSM2
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p_src p_tgt : ℕ}
    (data : InternalCycleActionData_SHSM X_src X_tgt A_src A_tgt p_src p_tgt) :
    ShiftedMTCorrespondencePackageAt_SHSM2 X_src X_tgt A_src A_tgt p_src p_tgt := by
  refine ⟨data.shift, data.h_shift, data.action,
          inducedAlgClassMap A_src A_tgt data.action data.preservesAlgClasses,
          ?_, ?_, ?_⟩
  · -- piece-shift conjunct
    exact data.pieceShift
  · -- commuting square
    intro z
    exact inducedAlgClassMap_subtype_apply A_src A_tgt data.action
            data.preservesAlgClasses z
  · -- hodge surjectivity
    exact data.hodgeSurj

/-! ## Section 3: concrete pt → E factory instance at `(0, 1)`

Reuses:
* `cycleAction_H0_to_H2_pointCycle` (R211)
* `cycleAction_H0_to_H2_preserves_algClasses_point_to_ellipticCurve` (R214)
* hodge surjectivity construction from R212/R213/R214
* piece-shift construction from R213 -/

/-- **R221 concrete pt → E factory data**: SHSM-bundled internal cycle
action for pt → E at `(0, 1)` with shift = 1. -/
noncomputable def internalCycleActionData_SHSM_point_to_ellipticCurve :
    InternalCycleActionData_SHSM
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 where
  action := cycleAction_H0_to_H2_pointCycle
  preservesAlgClasses :=
    cycleAction_H0_to_H2_preserves_algClasses_point_to_ellipticCurve
  hodgeSurj := by
    intro x _
    refine ⟨x, ?_, ?_⟩
    · show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      rw [TrivialWeight.piece_ℚ_w0_zero]
      exact Submodule.mem_top
    · rfl
  shift := 1
  h_shift := rfl
  pieceShift := by
    intro p
    fin_cases p
    show Submodule.map _ _ ≤
      ProjectiveLine.piece_ℚ_Tate2 ⟨0 + 1, by omega⟩
    show Submodule.map _ _ ≤ ProjectiveLine.piece_ℚ_Tate2 ⟨1, by omega⟩
    rw [ProjectiveLine.piece_ℚ_Tate2_one]
    exact le_top

/-- **R221 pt → E SHSM2 via factory**: the v2 SHSM2 package derived
from the factory data. -/
theorem SHSM2_point_to_E_from_internalCycleAction :
    ShiftedMTCorrespondencePackageAt_SHSM2
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 :=
  internalCycleActionData_SHSM_point_to_ellipticCurve.to_SHSM2

/-- **R221 13th kernel-pure route** to `VarietyHCAt_ellipticCurve_codim1`:
via the generic internal cycle-action factory `to_SHSM2`. Distinct from
all prior routes by going through the **reusable factory abstraction**
rather than hand-built SHSM packages. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_internalCycleAction :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    (ShiftedMTCorrespondencePackageAt_SHSM2_toRaw
      SHSM2_point_to_E_from_internalCycleAction)
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 4: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_InternalCycleAction_To_RealPushPullCup**: the factory's
`action` is a linear-algebraic stand-in. Real Chow-cycle push-pull-cup
machinery (`p_* ∘ (· ∪ [Z]) ∘ q^*` for cycle `Z ⊂ X × Y`) is deferred. -/
abbrev L4_G_InternalCycleAction_To_RealPushPullCup : Prop := True

/-- **L4-G_InternalCycleAction_From_ChowCycle**: a constructor
`(Z ∈ CH^q(X × Y)_ℚ) ↦ InternalCycleActionData_SHSM X Y AX AY p_src p_tgt`
lifting a real Chow-cycle to the factory. R221 hand-builds the specific
`pt → E` factory; the generic Chow-cycle lifter is deferred. -/
abbrev L4_G_InternalCycleAction_From_ChowCycle : Prop := True

/-- **L4-G_InternalCycleAction_ProductProvenance**: the optional
product-cycle provenance fields (`cycleClass : X_prod.H (2 * q)`,
`cycleClass_mem_algClasses`) are NOT included in R221's factory.
Adding them gives a stronger structure but doesn't change the kernel-pure
linear-algebraic skeleton. Deferred. -/
abbrev L4_G_InternalCycleAction_ProductProvenance : Prop := True

/-- **L4-G_GenericCycleAction_To_E7MTCorrespondence**: scaling the
factory to the E_7 / EVII Shimura context (where the relevant cycle is
`canonicalE7ShimuraTor.mtCorrespondencePackage`'s data). Requires
real cohomology and real Tate-twist Hodge structure beyond the
internal point/elliptic-curve toy models. Deferred. -/
abbrev L4_G_GenericCycleAction_To_E7MTCorrespondence : Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R221 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R221_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R221 non-closure (2/5)**: does NOT implement real Chow group. -/
theorem R221_does_not_implement_real_chow : True := trivial

/-- **R221 non-closure (3/5)**: does NOT implement true scheme product
or push-pull-cup correspondence semantics. -/
theorem R221_does_not_implement_true_scheme_product : True := trivial

/-- **R221 non-closure (4/5)**: does NOT enforce product-cycle
provenance in the factory (optional fields omitted). -/
theorem R221_does_not_enforce_product_cycle_provenance : True := trivial

/-- **R221 non-closure (5/5)**: only abstracts the internal cycle-action
route into a reusable factory. No new HC closure beyond the 13th
elliptic-curve codim-1 route. -/
theorem R221_only_abstracts_internal_cycle_action_factory : True := trivial

end GenericCycleAction
end HCGapL4
end HodgeReduction
