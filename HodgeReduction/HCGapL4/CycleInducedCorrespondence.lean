/-
# HC Gap L4 — first cycle-induced HodgeStructureMorphism prototype (R210).

R205 built the first cross-object `MTCorrespondencePackageAt` between
the point and the elliptic curve at codim 0, but with `φ` defined
DIRECTLY as a Lean linear map (`underlyingLinearMap_point_to_ellipticCurve_at_H0`)
— the construction did not exhibit `φ` as the cohomological action
of a cycle on the product. R209 then built the `pt × E` product
carrier with its own cycle family.

R210 closes the loop at the minimum level: define a **parameterised
cycle-action operator** at H^0 that takes a cycle element
`c ∈ H^0(pt × E)` and produces a `H^0(pt) → H^0(E)` linear map
`α ↦ c · α`. Specialised at the FUNDAMENTAL CYCLE `c = 1`, the
operator reproduces R205's identity-on-ℚ linear map. We then
construct the corresponding `MTCorrespondencePackageAt` and the HC
transfer, all kernel-pure.

## Geometric content (informally)

For `Z ⊂ X × Y` a cycle of codim `p` with cohomology class
`[Z] ∈ H^{2p}(X × Y, ℚ)`, the cycle acts on cohomology via

```
α ∈ H^k(X, ℚ)  ↦  (p_Y)_*((p_X)^* α ∪ [Z]) ∈ H^{k + 2p - 2 dim X}(Y, ℚ)
```

For `X = pt`, `Y = E`, `p = 0`, `k = 0`: this is `H^0(pt) → H^0(E)`,
and reduces to scalar multiplication by `[Z] ∈ H^0(pt × E) = ℚ`.
At the FUNDAMENTAL CYCLE `[Z] = 1`, this is the identity.

## What R210 provides (all kernel-pure)

* `cycleAction_H0 c : H^0(pt) →ₗ[ℚ] H^0(E)` — parameterised cycle
  action sending `α ↦ c * α`.
* `cycleActionHSM_H0 c` — wrapped as a `HodgeStructureMorphism`
  (preserves weight-0 piece `⊤ ↦ ⊤`).
* Agreement theorem: at `c = 1`, `cycleAction_H0 1` equals R205's
  `underlyingLinearMap_point_to_ellipticCurve_at_H0`.
* `MTCorrespondencePackageAt_point_to_ellipticCurve_codim0_cycle_induced`
  — the MT package built from `cycleActionHSM_H0 1`.
* `VarietyHCAt_ellipticCurve_codim0_via_cycle_induced_correspondence`
  — first HC closure derived from a cycle-induced HSM via
  `varietyHCAt_of_correspondence`.

## What R210 does NOT do

* It does NOT implement the general push-pull-cup formula on
  arbitrary smooth-projective pairs.
* It does NOT prove that the cycle-action AGREES with the
  cohomological action of a real Chow correspondence (the agreement
  is asserted as a Prop-level marker, not proved).
* It does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* It does NOT extend to codim `≥ 1` (the prototype is codim-0 H^0 only).

All R210 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL2.TrivialPoint
import HodgeReduction.HCGapL2.EllipticCurve
import HodgeReduction.HCGapL4.HodgeMorphism
import HodgeReduction.HCGapL4.NontrivialCorrespondence
import HodgeReduction.HCGapL4.ProductCohomology

namespace HodgeReduction
namespace HCGapL4
namespace CycleInducedCorrespondence

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.NontrivialCorrespondence
open HodgeReduction.HCGapL4.ProductCohomology

/-! ## Section 1: parameterised cycle-action operator at H^0

The operator takes a cycle element `c ∈ H^0(pt × E) = ℚ` and produces
the ℚ-linear map `H^0(pt) → H^0(E)` sending `α ↦ c · α`. All three
H^0 carriers reduce to `ℚ`; multiplication is just `ℚ` multiplication. -/

/-- **R210 cycle-action operator** at H^0: a cycle element `c` acts
on `H^0(pt) → H^0(E)` by scalar multiplication. Modelling the
push-pull-cup formula `α ↦ (p_E)_*((p_pt)^* α ∪ [Z])` in the specific
case `(X, Y, p) = (pt, E, 0)`. Built as `c • R205's underlying linear
map` so the `c = 1` case reduces to the original via `one_smul`. -/
noncomputable def cycleAction_H0
    (c : VarietyCohomologyData_pointTimesEllipticCurve.H 0) :
    TrivialPoint.varietyCohomology_point.H 0 →ₗ[ℚ]
    EllipticCurve.VarietyCohomologyData_ellipticCurve.H 0 :=
  (show ℚ from c) • underlyingLinearMap_point_to_ellipticCurve_at_H0

/-! ## Section 2: `HodgeStructureMorphism` wrapper -/

/-- **R210 cycle-action HSM** at H^0: wraps `cycleAction_H0 c` as a
`HodgeStructureMorphism`. The map_piece obligation reduces to
`Submodule.map _ ⊤ ≤ ⊤` after rewriting the target's only piece. -/
noncomputable def cycleActionHSM_H0
    (c : VarietyCohomologyData_pointTimesEllipticCurve.H 0) :
    HodgeStructureMorphism
      (TrivialPoint.varietyCohomology_point.H 0)
      (EllipticCurve.VarietyCohomologyData_ellipticCurve.H 0)
      0 where
  toLinearMap := cycleAction_H0 c
  map_piece := fun p => by
    fin_cases p
    show Submodule.map _ _ ≤ TrivialWeight.piece_ℚ_w0 ⟨0, by omega⟩
    rw [TrivialWeight.piece_ℚ_w0_zero]
    exact le_top

/-! ## Section 3: agreement with R205 underlying linear map

At the FUNDAMENTAL CYCLE `c = 1`, the cycle action reduces to the
identity on ℚ. This matches R205's `underlyingLinearMap_point_to_ellipticCurve_at_H0`
exactly. -/

/-- **R210 agreement (LinearMap-level)**: at the FUNDAMENTAL cycle
`c = 1`, the cycle action equals R205's underlying linear map as
ℚ-linear maps. Direct consequence of `one_smul`. -/
theorem cycleAction_H0_fundamentalCycle_eq :
    cycleAction_H0 (1 : ℚ) =
    underlyingLinearMap_point_to_ellipticCurve_at_H0 := by
  show (1 : ℚ) • underlyingLinearMap_point_to_ellipticCurve_at_H0 = _
  exact one_smul ℚ _

/-- **R210 agreement (pointwise)**: at `c = 1`, the cycle action
applied to any `x ∈ H^0(pt)` yields the same value as R205's
underlying linear map. -/
theorem cycleAction_H0_fundamentalCycle_apply (x : ℚ) :
    (cycleAction_H0 (1 : ℚ)) x =
    underlyingLinearMap_point_to_ellipticCurve_at_H0 x := by
  rw [cycleAction_H0_fundamentalCycle_eq]

/-! ## Section 4: cycle-induced MT correspondence package

Construct `MTCorrespondencePackageAt` between point and elliptic curve
at codim 0, using `cycleActionHSM_H0 1` as the Hodge morphism instead
of `phi_point_to_ellipticCurve_at_H0` from R205. The package's other
components (ψ = R205's psi, commuting square, Hodge surjectivity)
are the same as R205, just with `1 · x` instead of `x` everywhere. -/

/-- **R210 milestone**: kernel-pure `MTCorrespondencePackageAt` from
point to elliptic curve at codim 0, with `φ` constructed as the
cycle-action of the FUNDAMENTAL CYCLE on `pt × E`. -/
theorem MTCorrespondencePackageAt_point_to_ellipticCurve_codim0_cycle_induced :
    MTCorrespondencePackageAt
      TrivialPoint.varietyCohomology_point
      EllipticCurve.VarietyCohomologyData_ellipticCurve
      TrivialPoint.algClasses_point
      EllipticCurve.AlgebraicClassesData_ellipticCurve
      0 := by
  refine ⟨cycleActionHSM_H0 (1 : ℚ),
          psi_point_to_ellipticCurve_at_codim0, ?_, ?_⟩
  · -- Commuting square: subtype (ψ z) = cycleActionHSM 1 (subtype z)
    -- ψ z = ⟨z.val, mem_top⟩, so LHS = z.val.
    -- cycleActionHSM_H0 1 = R205's id linear map (via fundamentalCycle_eq), so RHS = z.val.
    intro z
    show z.val = (cycleAction_H0 (1 : ℚ)) z.val
    rw [cycleAction_H0_fundamentalCycle_apply]
    rfl
  · -- Hodge class surjectivity: hodgeClasses_tgt ≤ image of hodgeClasses_src
    --   under cycleActionHSM 1. Identity-by-fundamental-cycle, so image = domain.
    intro x _
    refine ⟨x, ?_, ?_⟩
    · exact Submodule.mem_top
    · show (cycleAction_H0 (1 : ℚ)) x = x
      rw [cycleAction_H0_fundamentalCycle_apply]
      rfl

/-! ## Section 5: HC transfer via the cycle-induced correspondence -/

/-- **R210 transfer demo**: HC at codim 0 for the elliptic curve,
derived from HC at codim 0 for the point via the **CYCLE-INDUCED**
MT correspondence package. First HC-via-cycle-induced-correspondence
closure in the library. -/
theorem VarietyHCAt_ellipticCurve_codim0_via_cycle_induced_correspondence :
    VarietyHCAt EllipticCurve.VarietyCohomologyData_ellipticCurve
      EllipticCurve.AlgebraicClassesData_ellipticCurve 0 :=
  varietyHCAt_of_correspondence
    MTCorrespondencePackageAt_point_to_ellipticCurve_codim0_cycle_induced
    (TrivialPoint.VarietyHCAt_point 0)

/-! ## Section 6: disclosure markers (Prop-only, NEVER axiomatised) -/

/-- **L4-G_RealPushPullCupFormula**: a true Mathlib `α ↦ (p_Y)_*((p_X)^* α ∪ [Z])`
formula on arbitrary `(X, Y, p, k)`, requiring real cohomological
pushforward / pullback / cup product on `SmoothProjectiveVariety ℂ`.
R210 only models the formula for `(X, Y, p, k) = (pt, E, 0, 0)` as
explicit scalar multiplication. -/
abbrev L4_G_RealPushPullCupFormula : Prop := True

/-- **L4-G_CycleAction_AgreesWith_ChowCorrespondence**: the
cohomological cycle-action operator agrees with the action induced
by an actual Chow-group correspondence `[Z] ∈ CH^*(X × Y)_ℚ` via the
cycle class map. The agreement is asserted at the marker level; R210
exhibits only the H^0 fundamental-cycle case where both sides reduce
to identity. -/
abbrev L4_G_CycleAction_AgreesWith_ChowCorrespondence : Prop := True

/-- **L4-G_CycleOnProduct_To_TrueAlgebraicCorrespondence**: a real
algebraic correspondence between two `SmoothProjectiveVariety ℂ`
realised as a closed subscheme of the product, with the cohomology
class lifting from the cycle class map. R210's `1 : ℚ` is a
linear-algebraic stand-in. -/
abbrev L4_G_CycleOnProduct_To_TrueAlgebraicCorrespondence : Prop := True

/-- **L4-G_CycleInduced_MTCorrespondencePackage_General**: the
construction `(Z ∈ CH^*(X × Y)_ℚ) ↦ MTCorrespondencePackageAt`
quantified over arbitrary `(X, Y, p)`. R210 exhibits only the
specific case `(X, Y, p) = (pt, E, 0)` with `Z = 1`. The general
construction would need real cohomological functoriality across the
product, plus the Hodge-half automatic from cycle algebraicity. -/
abbrev L4_G_CycleInduced_MTCorrespondencePackage_General : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R210 non-closure (1/5)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
theorem R210_does_not_close_mtCorrespondencePackage : True := trivial

/-- **R210 non-closure (2/5)**: does NOT implement the general
push-pull-cup formula. Only the specific
`(X, Y, p, k) = (pt, E, 0, 0)` case is modelled as scalar
multiplication. -/
theorem R210_does_not_implement_real_pushpullcup : True := trivial

/-- **R210 non-closure (3/5)**: does NOT implement real Chow group
`CH^*(X × Y)_ℚ`. The "cycle" `c` is an element of the internal H^0,
not an actual algebraic-geometric cycle modulo rational equivalence. -/
theorem R210_does_not_implement_real_chow : True := trivial

/-- **R210 non-closure (4/5)**: does NOT implement a real Mathlib
scheme product. The cycle-action is constructed entirely at the
cohomology level via the R209 internal `pt × E` carrier. -/
theorem R210_does_not_implement_real_scheme_product : True := trivial

/-- **R210 non-closure (5/5)**: only the codim-0 H^0 prototype is
exhibited. Codim 1 (involving cup with point class on `pt × E`'s
H^2) and the corresponding mapping `H^0(pt) → H^2(E)` are deferred. -/
theorem R210_only_codim0_H0_prototype : True := trivial

end CycleInducedCorrespondence
end HCGapL4
end HodgeReduction
