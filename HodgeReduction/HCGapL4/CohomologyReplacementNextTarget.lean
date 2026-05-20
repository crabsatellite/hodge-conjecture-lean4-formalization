/-
# HC Gap L4 — smallest next non-toy target for cohomology replacement (R253).

R251 audited Mathlib for cohomology replacement feasibility (all three
cohomology routes — singular / de Rham / étale — are blocked at the
Mathlib cohomology-functor stage). R252 mapped the dependencies and
recommended a scheme-agnostic adapter interface as the smallest
formal next target.

R253 implements that recommendation: the smallest non-toy Lean
interface is an **abstract rational cohomology source** plus a
**comparison-to-VCD adapter**. This is honest scaffolding: any future
real cohomology theory (singular / de Rham / étale once Mathlib has
them) plugs into this adapter, and the existing toy `VarietyCohomologyData`
sits on the receiving side.

This is NOT real E_7 Shimura cohomology. It is the smallest
non-toy-cohomology Lean object that can EVER be filled by a real
cohomology theory.

## What R253 (this file) provides (all kernel-pure)

* `CohomologyReplacementNextTargetToySkeleton` — target registry
  structure with audit / dependency-map context fields.
* `AbstractRationalCohomologySource` — abstract `H : ℕ → Type` source
  with ℚ-module structure per degree. NOT toy-only — this is a real
  interface waiting to be inhabited by genuine cohomology.
* `AbstractRationalCohomologySourceToVCD` — adapter skeleton: an
  abstract source + a target `VarietyCohomologyData` + a Prop-level
  "agrees on H" marker (the actual comparison theorem is the real
  bridge work and not provable without a concrete instance).
* `Target_SmoothProjectiveComplexVariety_RationalCohomologyInterface` —
  the chosen smallest formal target marker.
* `L1_G_NextCohomologyReplacementTarget_To_R245Plan` — bridge back to
  the R245 cohomology replacement plan.

## What R253 (this file) does NOT do

* Does NOT construct real E_7 Shimura variety.
* Does NOT construct actual singular / de Rham / étale cohomology.
* Does NOT prove any concrete comparison with
  `VarietyCohomologyData_E7ShimuraToy`.
* Does NOT replace `canonicalE7ShimuraTor.cohomologyOfUnderlying`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R253 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL4.CohomologyReplacementMathlibAudit
import HodgeReduction.HCGapL4.CohomologyReplacementDependencyMap

namespace HodgeReduction
namespace HCGapL4
namespace CohomologyReplacementNextTarget

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.CohomologyReplacementMathlibAudit
open HodgeReduction.HCGapL4.CohomologyReplacementDependencyMap

/-! ## Section 1: target registry structure -/

/-- **R253 next-target registry** for `cohomologyOfUnderlying`
replacement. Bundles R252's dependency map with metadata about the
chosen target: its name, whether the statement is currently
available, whether it requires new Mathlib, whether it can be worked
without an E_7-side construction, and whether it blocks the toy-to-real
comparison. -/
structure CohomologyReplacementNextTargetToySkeleton where
  /-- The R252 dependency map context. -/
  dependencyMap : CohomologyOfUnderlyingReplacementDependencyMapToySkeleton
  /-- Display name for the chosen target. -/
  targetNameToy : String
  /-- Marker: the target statement can be stated in current Lean. -/
  targetStatementAvailableToy : Prop
  /-- Marker: the target requires new Mathlib infrastructure. -/
  targetRequiresNewMathlibToy : Prop
  /-- Marker: the target can be worked on without first constructing
  the real E_7 side. -/
  targetCanBeWorkedWithoutE7Toy : Prop
  /-- Marker: the target blocks (or unblocks) the toy-to-real
  comparison once available. -/
  targetBlocksToyToRealComparisonToy : Prop

/-! ## Section 2: chosen target — abstract rational cohomology source

The smallest non-toy interface that can sit on the source side of a
future real → toy comparison. NOT named `Toy` because this is a real
interface; future real cohomology theories must inhabit this. -/

/-- **R253 chosen smallest target**: a `ℕ → Type` source with ℚ-module
structure per degree. Real singular / de Rham / étale cohomology with
ℚ-coefficients will each inhabit this interface (once Mathlib has
them). The interface itself is real, kernel-pure, and minimal. -/
structure AbstractRationalCohomologySource where
  /-- Cohomology functor `k ↦ H^k(_, ℚ)` as a type-valued function. -/
  H : ℕ → Type
  /-- Each `H k` is an additive commutative group. -/
  instAddCommGroup : ∀ k, AddCommGroup (H k)
  /-- Each `H k` is a ℚ-module. -/
  instModule : ∀ k,
    @Module ℚ (H k) _ (instAddCommGroup k).toAddCommMonoid

/-! ## Section 3: adapter skeleton

A skeleton interface for "an abstract source agrees with a chosen
`VarietyCohomologyData`". The `agreesOnH` field is a Prop-level marker;
the actual comparison is real bridge work and is NOT proved here. -/

/-- **R253 adapter skeleton**: pairs an `AbstractRationalCohomologySource`
with a target `VarietyCohomologyData` and a Prop-level marker for the
underlying agreement claim. The marker is paper-trail only. -/
structure AbstractRationalCohomologySourceToVCD where
  /-- The abstract source. -/
  source : AbstractRationalCohomologySource
  /-- The target toy `VarietyCohomologyData`. -/
  vcd : VarietyCohomologyData
  /-- Marker: `source.H` agrees with `vcd.H` at relevant degrees. -/
  agreesOnH : Prop

/-! ## Section 4: chosen smallest-target Prop marker -/

/-- **R253 chosen target marker**: smooth projective complex variety
with a rational cohomology interface. Per R252's recommendation, this
is encoded via the abstract `AbstractRationalCohomologySource` +
`AbstractRationalCohomologySourceToVCD` adapter, not a full
`SmoothProjectiveVariety ℂ` typeclass (whose bundling is currently
absent from Mathlib per R251). -/
def Target_SmoothProjectiveComplexVariety_RationalCohomologyInterface :
    Prop := True

/-- **R253 alternative target marker 1** (recorded for reference):
generic adapter from abstract cohomology theory to `VarietyCohomologyData`.
Subsumed by `AbstractRationalCohomologySourceToVCD` above. -/
def Target_AbstractCohomologyTheory_to_VarietyCohomologyData :
    Prop := True

/-- **R253 alternative target marker 2** (recorded for reference):
comparison interface between a real cohomology source and the existing
toy `VarietyCohomologyData`. Subsumed by
`AbstractRationalCohomologySourceToVCD` above. -/
def Target_CohomologySource_compares_to_VarietyCohomologyData :
    Prop := True

/-! ## Section 5: next-target registry instance -/

/-- **R253 next-target registry instance** with chosen target =
"AbstractRationalCohomologySource + adapter to VCD". -/
def CohomologyReplacementNextTargetToySkeleton_chosen :
    CohomologyReplacementNextTargetToySkeleton where
  dependencyMap :=
    CohomologyOfUnderlyingReplacementDependencyMapToySkeleton_E7Shimura
  targetNameToy := "AbstractRationalCohomologySource + adapter to VCD"
  targetStatementAvailableToy := True
  -- Requires new Mathlib for ANY real cohomology theory to inhabit.
  targetRequiresNewMathlibToy := True
  -- Can be worked without E_7: the interface is scheme-agnostic.
  targetCanBeWorkedWithoutE7Toy := True
  -- Unblocks toy-to-real comparison once a real cohomology fills the
  -- `source` field.
  targetBlocksToyToRealComparisonToy := True

/-! ## Section 6: bridge back to R245 -/

/-- **L1-G_NextCohomologyReplacementTarget_To_R245Plan**: bridge marker
connecting R253's chosen target to R245's `CohomologyOfUnderlyingReplacementToyPlan`. -/
def L1_G_NextCohomologyReplacementTarget_To_R245Plan : Prop := True

/-! ## Section 7: explicit non-closure -/

/-- **R253 non-closure (1/4)**: does NOT construct real E_7 Shimura
variety. -/
theorem R253_does_not_construct_real_E7_shimura_variety : True := trivial

/-- **R253 non-closure (2/4)**: does NOT construct actual singular /
de Rham / étale cohomology. -/
theorem R253_does_not_construct_actual_cohomology : True := trivial

/-- **R253 non-closure (3/4)**: does NOT prove comparison with
`VarietyCohomologyData_E7ShimuraToy`. -/
theorem R253_does_not_prove_comparison_with_toyVCD : True := trivial

/-- **R253 non-closure (4/4)**: does NOT replace
`canonicalE7ShimuraTor.cohomologyOfUnderlying` or close
`canonicalE7ShimuraTor`. -/
theorem R253_does_not_replace_cohomologyOfUnderlying : True := trivial

end CohomologyReplacementNextTarget
end HCGapL4
end HodgeReduction
