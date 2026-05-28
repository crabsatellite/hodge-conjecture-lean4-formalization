/-
# HC Gap L4 — full ∀-codim VarietyHC for the internal toy E_7-Shimura carrier (R385).

R385 bundles the (essentially trivial) codim-0 and codim-≥-2 cases with the
existing R229 codim-1 closure `VarietyHCAt_E7ShimuraToy_codim1_via_productCycleFactory`
into a SINGLE `∀ p, VarietyHCAt …` proof:

  `InternalToy_VarietyHC :
     VarietyHC VarietyCohomologyData_E7ShimuraToy
               AlgebraicClassesData_E7ShimuraToy`

This is the FIRST explicit bridge obligation identified by R384's frontier
audit (`R384_NextTarget_R385_Trivial_Carrier_FullCodim_HC`) — step 1 of
constructing an axiom-free `ParametricCanonicalE7ShimuraTor` instance.

## Strategy

The internal toy carrier `VarietyCohomologyData_E7ShimuraToy` has cohomology
`H 0 = ℚ`, `H 1 = PUnit`, `H 2 = ℚ`, `H k = PUnit` for `k ≥ 3`, with
algebraic classes `⊤` at codim 0/1 and `⊥` at codim ≥ 2.

* **p = 0**: `algClasses 0 = ⊤`, so `hodgeClasses ≤ ⊤` is trivial.
* **p = 1**: `H 2 = ℚ` (Tate-2); R229 closes this via the product-cycle
  factory (`VarietyHCAt_E7ShimuraToy_codim1_via_productCycleFactory`),
  kernel-pure with NO `canonicalE7ShimuraTor` in cone (per R229 audit).
* **p ≥ 2**: `H (2 * p) = PUnit` (since `2 * p ≥ 4`); every element is
  `0 ∈ ⊥ = algClasses (p + 2)`.

## What R385 (this file) provides (all kernel-pure)

* `InternalToy_VarietyHCAt_codim0` — HC at codim 0.
* `InternalToy_VarietyHCAt_codim1` — HC at codim 1 (alias of R229 closure).
* `InternalToy_VarietyHCAt_codim_ge_two` — HC at codim ≥ 2.
* `InternalToy_VarietyHC` — full ∀-codim VarietyHC.

## What R385 (this file) does NOT do

* Does NOT close `canonicalE7ShimuraTor.mtCorrespondencePackage`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT claim the toy carrier is the real E_7 Shimura variety.
* Does NOT construct the `ParametricCanonicalE7ShimuraTor` instance
  (that is R386+).

All declarations are kernel-pure: axiom cone ⊆ `{propext, Classical.choice,
Quot.sound}`. CRITICAL: cone does NOT include `canonicalE7ShimuraTor`.
-/

import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.E7ShimuraToyProductCycleFactory

namespace HodgeReduction
namespace HCGapL4
namespace InternalToyFullCodimHC

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL2
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.E7ShimuraToyProductCycleFactory

/-! ## Section 1: codim-0 closure -/

/-- **R385 codim-0 closure**: HC for the internal toy at codimension 0.
`algClasses_E7ShimuraToy 0 = ⊤`, so `hodgeClasses 0 ≤ ⊤` is trivial. -/
theorem InternalToy_VarietyHCAt_codim0 :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy 0 := by
  letI _acg := VarietyCohomologyData_E7ShimuraToy.addCommGroup 0
  letI _mod := VarietyCohomologyData_E7ShimuraToy.module 0
  letI _phs := VarietyCohomologyData_E7ShimuraToy.hodgeStructure 0
  intro x _
  show x ∈ algClasses_E7ShimuraToy 0
  exact Submodule.mem_top

/-! ## Section 2: codim-1 closure (alias of R229 product-cycle factory route) -/

/-- **R385 codim-1 closure**: HC for the internal toy at codimension 1.
Direct alias of the R229 product-cycle factory route, which is kernel-pure
({propext, Classical.choice, Quot.sound}) with NO `canonicalE7ShimuraTor`
in cone (verified by R229 audit). -/
theorem InternalToy_VarietyHCAt_codim1 :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy 1 :=
  VarietyHCAt_E7ShimuraToy_codim1_via_productCycleFactory

/-! ## Section 3: codim-≥-2 closure (PUnit subsingleton) -/

/-- **R385 codim-≥-2 closure**: HC for the internal toy at codimension
`p + 2`. The carrier at `H (2 * (p + 2)) = H (2*p + 4)` is `PUnit`
(subsingleton), so every element is `0`, hence lies in `⊥ =
algClasses_E7ShimuraToy (p + 2)`. -/
theorem InternalToy_VarietyHCAt_codim_ge_two (p : ℕ) :
    VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy (p + 2) := by
  intro x _
  show x ∈ algClasses_E7ShimuraToy (p + 2)
  letI _j_acg := VarietyCohomologyData_E7ShimuraToy.addCommGroup (2 * (p + 2))
  letI _j_mod := VarietyCohomologyData_E7ShimuraToy.module (2 * (p + 2))
  -- `H (2 * (p + 2)) = cohomologyType_E7ShimuraToy (2 * (p + 2))`
  -- with `2 * (p + 2) ≠ 0` and `2 * (p + 2) ≠ 2`; subsingleton support applies.
  have hSub : Subsingleton (VarietyCohomologyData_E7ShimuraToy.H (2 * (p + 2))) := by
    show Subsingleton (cohomologyType_E7ShimuraToy (2 * (p + 2)))
    apply cohomologyType_E7ShimuraToy_support
    constructor <;> omega
  have hx0 : x = 0 := Subsingleton.elim _ _
  rw [hx0]
  exact Submodule.zero_mem _

/-! ## Section 4: full ∀-codim assembly -/

/-- **R385 main**: full ∀-codim VarietyHC for the internal toy
E_7-Shimura-shaped carrier. Combines codim 0, codim 1 (R229 product-cycle
factory route), and codim ≥ 2 (PUnit subsingleton).

All cases kernel-pure; cone ⊆ `{propext, Classical.choice, Quot.sound}`.
CRITICAL: cone does NOT include `canonicalE7ShimuraTor`. -/
theorem InternalToy_VarietyHC :
    VarietyHC
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy := by
  intro p
  match p with
  | 0     => exact InternalToy_VarietyHCAt_codim0
  | 1     => exact InternalToy_VarietyHCAt_codim1
  | n + 2 => exact InternalToy_VarietyHCAt_codim_ge_two n

/-! ## Section 5: non-closure markers (Prop-only, NEVER axiomatised) -/

/-- **R385 non-closure (1/4)**: does NOT close
`canonicalE7ShimuraTor.mtCorrespondencePackage`. The toy carrier is
internal; the headline axiom is unchanged. -/
def R385_does_not_close_canonicalE7ShimuraTor : Prop := True

/-- **R385 non-closure (2/4)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
def R385_does_not_alter_hodgeConjectureReal_canonical : Prop := True

/-- **R385 non-closure (3/4)**: does NOT claim the toy carrier is the
real E_7 Shimura variety. -/
def R385_does_not_claim_real_E7Shimura : Prop := True

/-- **R385 non-closure (4/4)**: does NOT construct the
`ParametricCanonicalE7ShimuraTor` instance (that is R386+). -/
def R385_does_not_construct_parametric_canonical_instance : Prop := True

/-- **R385 status**: first explicit bridge obligation from R384
(`R384_NextTarget_R385_Trivial_Carrier_FullCodim_HC`) is now CLOSED. -/
def R385_first_explicit_bridge_obligation_closed : Prop := True

end InternalToyFullCodimHC
end HCGapL4
end HodgeReduction
