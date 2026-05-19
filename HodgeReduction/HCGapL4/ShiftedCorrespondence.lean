/-
# HC Gap L4 — codim-shifted MT correspondence package (R212).

R211 surfaced a type-level obstruction: the existing
`MTCorrespondencePackageAt X_src X_tgt A_src A_tgt p` takes a SINGLE
codim parameter `p` and requires both source and target Hodge data
at the SAME degree `2p`. This blocks the codim-1 cycle-induced
correspondence `pt → E` because the cycle action shifts degree
(`H^0(pt) → H^2(E)`, source codim 0, target codim 1).

R212 closes the obstruction by introducing the codim-shifted variant:

```
ShiftedMTCorrespondencePackageAt X_src X_tgt A_src A_tgt p_src p_tgt
```

plus a shifted transfer theorem

```
VarietyHCAt_of_shifted_correspondence :
  ShiftedMTCorrespondencePackageAt X Y AX AY p_src p_tgt →
  VarietyHCAt X AX p_src →
  VarietyHCAt Y AY p_tgt
```

and the concrete cycle-induced shifted package for `pt → E` at
`(0, 1)`, finally enabling the closure
`VarietyHCAt_ellipticCurve_codim1_via_shifted_cycle_induced_correspondence`
that R211 was unable to deliver.

## Design choice: raw `LinearMap` action, not `ShiftedHodgeStructureMorphism`

For the HC transfer, the only Hodge-side ingredient used is the
**Hodge-class surjectivity**: every target Hodge class must lift to
a source Hodge class via the action. Piece-preservation of the
action (as an HSM or SHSM) is a STRONGER property than HC transfer
needs.

R212 therefore uses a raw `LinearMap` for the action field, leaving
the SHSM-style Hodge-compatibility check as an OPTIONAL upstream
property (verifiable separately via R211's `ShiftedHodgeStructureMorphism`).
This matches the user's "prototype transfer interface" framing.

## What R212 does NOT do

* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT implement a real Chow-group cycle correspondence.
* It does NOT implement real Mathlib scheme-level products / push-pull-cup.
* It does NOT promote `ShiftedMTCorrespondencePackageAt` to a "final"
  MT correspondence package — only a prototype transfer interface.

All R212 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.CycleInducedCodim1

namespace HodgeReduction
namespace HCGapL4
namespace ShiftedCorrespondence

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.CycleInducedCodim1

/-! ## Section 0: scoped `PureHodgeStructure` instances

R205/R208 declared `AddCommGroup` + `Module ℚ` on `(point.H k)` and
`(EC.H k)` parameterised by `k`. R212 additionally needs
`PureHodgeStructure (X.H k) k` at general `k` for both point and
elliptic curve so the codim-shifted package's `hodgeClasses` access
resolves. -/

noncomputable instance phs_point_Hk (k : ℕ) :
    PureHodgeStructure (TrivialPoint.varietyCohomology_point.H k) k :=
  TrivialPoint.varietyCohomology_point.hodgeStructure k

noncomputable instance phs_ellipticCurve_Hk (k : ℕ) :
    PureHodgeStructure
      (EllipticCurve.VarietyCohomologyData_ellipticCurve.H k) k :=
  EllipticCurve.VarietyCohomologyData_ellipticCurve.hodgeStructure k

/-! ## Section 1: `ShiftedMTCorrespondencePackageAt`

Existential predicate parameterised by separate source/target codims
`(p_src, p_tgt)`. Components:
* `action : H^{2 p_src}(X) →ₗ[ℚ] H^{2 p_tgt}(Y)` — raw ℚ-linear map.
* `ψ : ↥(A_src.algClasses p_src) →ₗ[ℚ] ↥(A_tgt.algClasses p_tgt)` —
  algebraic-class linear map.
* Commuting square: `subtype (ψ z) = action (subtype z)`.
* Hodge-class surjectivity: every target Hodge class lifts via
  `action` to a source Hodge class. -/

/-- **R212 shifted MT package prototype**: codim-shifted variant of
`MTCorrespondencePackageAt` allowing `p_src ≠ p_tgt`. Bridges
`H^{2 p_src}(X)` and `H^{2 p_tgt}(Y)` via a raw ℚ-linear action and a
compatible algebraic-class map. The Hodge-surjectivity field is the
only Hodge-side ingredient; piece-preservation (SHSM-style) is left
as a separate optional upstream property. -/
def ShiftedMTCorrespondencePackageAt
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
  ∃ (action : X_src.H (2 * p_src) →ₗ[ℚ] X_tgt.H (2 * p_tgt))
    (ψ : ↥(A_src.algClasses p_src) →ₗ[ℚ] ↥(A_tgt.algClasses p_tgt)),
    (∀ z : ↥(A_src.algClasses p_src),
      ((A_tgt.algClasses p_tgt).subtype) (ψ z) =
        action (((A_src.algClasses p_src).subtype) z)) ∧
    PureHodgeStructure.hodgeClasses (X_tgt.H (2 * p_tgt)) p_tgt ≤
      Submodule.map action
        (PureHodgeStructure.hodgeClasses (X_src.H (2 * p_src)) p_src)

/-! ## Section 2: shifted transfer theorem -/

/-- **R212 shifted transfer theorem**: given a
`ShiftedMTCorrespondencePackageAt X Y AX AY p_src p_tgt` and HC on the
source at codim `p_src`, derive HC on the target at codim `p_tgt`.

Proof: unpack the existential to get `(action, ψ, square, surj)`.
For any target Hodge class `x`, use `surj` to lift to a source Hodge
class `y` with `action y = x`. By source HC, `y` is algebraic. The
commuting square then transports `y`'s algebraic-class lift via `ψ`
to a target algebraic class equal to `x`. Hence `x` is algebraic. -/
theorem VarietyHCAt_of_shifted_correspondence
    {X_src X_tgt : VarietyCohomologyData}
    {A_src : AlgebraicClassesData X_src}
    {A_tgt : AlgebraicClassesData X_tgt}
    {p_src p_tgt : ℕ}
    (h_pkg : ShiftedMTCorrespondencePackageAt X_src X_tgt A_src A_tgt p_src p_tgt)
    (h_HC_src : VarietyHCAt X_src A_src p_src) :
    VarietyHCAt X_tgt A_tgt p_tgt := by
  letI _ := X_src.addCommGroup (2 * p_src)
  letI _ := X_src.module (2 * p_src)
  letI _ := X_src.hodgeStructure (2 * p_src)
  letI _ := X_tgt.addCommGroup (2 * p_tgt)
  letI _ := X_tgt.module (2 * p_tgt)
  letI _ := X_tgt.hodgeStructure (2 * p_tgt)
  unfold ShiftedMTCorrespondencePackageAt at h_pkg
  obtain ⟨action, ψ, h_square, h_surj⟩ := h_pkg
  intro x hx_tgt_hodge
  -- hx_tgt_hodge : x ∈ hodgeClassesAtDegree p_tgt (in X_tgt)
  -- Lift to a source Hodge class via h_surj
  obtain ⟨y, hy_src_hodge, hy_action⟩ := h_surj hx_tgt_hodge
  -- y : X_src.H (2 * p_src), hy_src_hodge : y ∈ hodgeClasses_src,
  --   hy_action : action y = x.
  -- By source HC, y is algebraic in X_src.
  have hy_src_alg : y ∈ A_src.algClasses p_src := h_HC_src hy_src_hodge
  -- Lift y to its subtype representation.
  let y_alg : ↥(A_src.algClasses p_src) := ⟨y, hy_src_alg⟩
  -- ψ y_alg is in A_tgt.algClasses p_tgt by typing.
  -- By the commuting square, subtype (ψ y_alg) = action (subtype y_alg)
  --   = action y = x.
  have h_eq : ((A_tgt.algClasses p_tgt).subtype) (ψ y_alg) = x := by
    rw [h_square y_alg]
    show action y = x
    exact hy_action
  -- Therefore x = subtype (ψ y_alg) ∈ A_tgt.algClasses p_tgt.
  rw [← h_eq]
  exact (ψ y_alg).property

/-! ## Section 3: cycle-induced shifted package for `pt → E` at `(0, 1)` -/

/-- **R212 algebraic-class map for the codim-1 cycle-induced package**:
`↥(point.algClasses 0) → ↥(EC.algClasses 1)` via subtype lifting on
the underlying `ℚ`-value. Honest construction (not the
`algClasses := hodgeClasses` trick), matching R205's `psi_point_to_ellipticCurve_at_codim0`
but at a different (target codim 1) submodule. -/
noncomputable def psi_codim0_to_codim1_point_to_ellipticCurve :
    ↥(TrivialPoint.algClasses_point.algClasses 0) →ₗ[ℚ]
    ↥(EllipticCurve.AlgebraicClassesData_ellipticCurve.algClasses 1) where
  toFun z := ⟨z.val, Submodule.mem_top⟩
  map_add' _ _ := by ext; rfl
  map_smul' _ _ := by ext; rfl

/-- **R212 milestone**: kernel-pure `ShiftedMTCorrespondencePackageAt`
from point (codim 0) to elliptic curve (codim 1), with the action
constructed as the codim-1 point cycle on `pt × E` (R211's
`cycleAction_H0_to_H2_pointCycle`). First codim-shifted cycle-induced
MT package in the library. -/
theorem ShiftedMTCorrespondencePackageAt_point_to_ellipticCurve_codim0_to_codim1 :
    ShiftedMTCorrespondencePackageAt
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 1 := by
  refine ⟨cycleAction_H0_to_H2_pointCycle,
          psi_codim0_to_codim1_point_to_ellipticCurve, ?_, ?_⟩
  · -- Commuting square: subtype (ψ z) = action (subtype z)
    -- subtype (ψ z) = z.val
    -- action (subtype z) = cycleAction (subtype z) = z.val
    intro z
    rfl
  · -- Hodge-class surjectivity: hodgeClasses_E (1) ≤
    --   Submodule.map cycleAction (hodgeClasses_pt (0))
    -- LHS = piece ⟨1, _⟩ of Tate-Hodge weight 2 on ℚ = ⊤.
    -- RHS = Submodule.map (fun x => x) ⊤ in ℚ = ⊤.
    -- So ⊤ ≤ ⊤; any x has preimage x, action x = x.
    intro x _
    refine ⟨x, ?_, ?_⟩
    · -- x ∈ hodgeClasses_pt 0 = piece ⟨0, _⟩ of TrivialWeight.pureHodgeStructure_ℚ_0 = ⊤
      show x ∈ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
      rw [TrivialWeight.piece_ℚ_w0_zero]
      exact Submodule.mem_top
    · rfl

/-! ## Section 4: HC closure via the shifted cycle-induced correspondence -/

/-- **R212 closure (R211's deferred target)**: HC at codim 1 for the
elliptic curve, derived from HC at codim 0 for the point via the
codim-shifted cycle-induced correspondence. Closes the route
R211 was unable to deliver. -/
theorem VarietyHCAt_ellipticCurve_codim1_via_shifted_cycle_induced_correspondence :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 1 :=
  VarietyHCAt_of_shifted_correspondence
    ShiftedMTCorrespondencePackageAt_point_to_ellipticCurve_codim0_to_codim1
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 5: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_ShiftedMT_To_TrueAlgebraicCorrespondence**: a real
algebraic correspondence `Z ⊂ X × Y` (closed subscheme) whose
cohomological action via the cycle class map is the action in the
shifted MT package. R212's `cycleAction_H0_to_H2_pointCycle` is a
linear-algebraic stand-in for the cycle class of an actual point on
`E`. -/
abbrev L4_G_ShiftedMT_To_TrueAlgebraicCorrespondence : Prop := True

/-- **L4-G_ShiftedTransfer_CompatibilityWith_TateTwist**: R212's
shifted transfer uses a RAW LinearMap action; the Tate-twist
(piece-preservation) compatibility is left as an optional upstream
check via R211's `ShiftedHodgeStructureMorphism`. A complete
Tate-twist-enforced transfer theorem would require the package to
bundle an `SHSM`-style piece-shift hypothesis, which the present
prototype omits. -/
abbrev L4_G_ShiftedTransfer_CompatibilityWith_TateTwist : Prop := True

/-- **L4-G_ShiftedPackage_From_ChowCycle**: a constructor
`(Z ∈ CH^{p_tgt - p_src}(X × Y)_ℚ) ↦ ShiftedMTCorrespondencePackageAt
X Y AX AY p_src p_tgt`, lifting a real Chow-group cycle to the
shifted package via the cycle class map + push-pull-cup formula.
R212 hand-builds the specific `pt → E` case at `(0, 1)`. -/
abbrev L4_G_ShiftedPackage_From_ChowCycle : Prop := True

/-- **L4-G_GeneralCodimShiftedCorrespondence**: a fully general
codim-shifted correspondence framework allowing arbitrary
`(p_src, p_tgt)` and arbitrary source/target VCDs, with the
prototype-to-final-package promotion path. R212 provides only the
prototype + a single concrete instance. -/
abbrev L4_G_GeneralCodimShiftedCorrespondence : Prop := True

/-! ## Section 6: explicit non-closure -/

/-- **R212 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. The headline
correspondence (V_56-induced E_7 Shimura → CM abelian) is a same-codim
case at the codim levels relevant to the canonical proof; the codim-
shifted machinery R212 builds is orthogonal to that. -/
theorem R212_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R212 non-closure (2/4)**: does NOT implement a real Chow group
or cycle class map. The cycle-induced action is constructed at the
linear-algebraic level only. -/
theorem R212_does_not_implement_real_chow : True := trivial

/-- **R212 non-closure (3/4)**: does NOT implement a real Mathlib
scheme-level product or the general push-pull-cup formula. -/
theorem R212_does_not_implement_real_scheme_product_or_pushpullcup : True := trivial

/-- **R212 non-closure (4/4)**: `ShiftedMTCorrespondencePackageAt` is
a PROTOTYPE transfer interface, NOT a final MT correspondence
package. It uses a raw LinearMap action (no SHSM bundle) and is not
claimed to capture all the structure of a real algebraic
correspondence. -/
theorem R212_shiftedPackage_is_prototype_not_final : True := trivial

end ShiftedCorrespondence
end HCGapL4
end HodgeReduction
