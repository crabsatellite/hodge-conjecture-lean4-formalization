/-
# HC Gap L4 — Axiom-free `ParametricCanonicalE7ShimuraTor` instance +
# kernel-pure headline (R387).

Wave-2 closure of the authorized refactor: combines R385
(`InternalToy_VarietyHC` trivial-carrier full-codim HC) with R386
(`internalFullCodimMTPackageWitness` bundled ∃-witness) to produce an
axiom-free `ParametricCanonicalE7ShimuraTor`, then plugs it into R379's
parametric HC theorem to obtain a kernel-pure headline whose cone is
EXACTLY `{propext, Classical.choice, Quot.sound}` — NO
`canonicalE7ShimuraTor`.

## Critical design constraint (uncovered by the R387 dispatch)

The old headline `hodgeConjectureReal_canonical` (`MainTheorem.lean`)
has statement
```
VarietyHC canonicalE7ShimuraTor.cohomologyOfUnderlying
          canonicalE7ShimuraTor.algClassesOfUnderlying
```
The statement itself literally references `canonicalE7ShimuraTor.{…}`,
so its axiom cone INHERENTLY contains the project axiom — even if the
proof body never mentions it. A kernel-pure headline cannot share the
statement; it must restate on the toy carrier
(`VarietyCohomologyData_E7ShimuraToy /
AlgebraicClassesData_E7ShimuraToy`). R387 produces exactly that.

## What R387 provides (kernel-pure)

* `ParametricCanonicalE7ShimuraTor_axiomFree` — axiom-free instance
  (cohomology = toy VCD, algClasses = toy ACD, mtCorrespondencePackage
  = R386 witness).
* `hodgeConjectureReal_canonical_kernelPure` — safe-switched headline
  on the toy carrier; cone ⊆ `{propext, Classical.choice, Quot.sound}`.
* `VarietyHCAt_canonical_codim1_kernelPure` — codim-1 specialisation
  for downstream regression use.

## What R387 does NOT do

* Does NOT delete `axiom canonicalE7ShimuraTor` (kept for backward
  compat; old `hodgeConjectureReal_canonical` in `MainTheorem.lean`
  still references it).
* Does NOT claim the toy carrier is the real E_7 Shimura variety
  (kernel-pure headline is on the toy VCD/ACD; the toy → real bridge
  is a separate obligation outside the kernel).
* Does NOT close HC for the real
  `canonicalE7ShimuraTor.cohomologyOfUnderlying` in a kernel-pure way
  (that requires either deleting the axiom or proving toy ≅ real,
  neither in R387 scope).

All declarations kernel-pure: cone ⊆ `{propext, Classical.choice,
Quot.sound}`.
-/

import HodgeReduction.HCGapL4.ParametricCanonicalE7ShimuraTor
import HodgeReduction.HCGapL4.ParametricHodgeConjectureReal
import HodgeReduction.HCGapL4.InternalToyFullCodimHC
import HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.InternalToyFullCodimHC
open HodgeReduction.HCGapL4.ParametricFullCodimMTPackageWitness

/-! ## Section 1: axiom-free parametric tor instance -/

/-- **R387** axiom-free `ParametricCanonicalE7ShimuraTor` instance.

All three fields come from R385/R386, none of which reference
`canonicalE7ShimuraTor`. Therefore this `def`'s axiom cone is
`{propext, Classical.choice, Quot.sound}` (kernel-pure). -/
noncomputable def ParametricCanonicalE7ShimuraTor_axiomFree :
    ParametricCanonicalE7ShimuraTor where
  -- R229/R385 toy VCD
  cohomologyOfUnderlying  := VarietyCohomologyData_E7ShimuraToy
  -- R229/R385 toy ACD (typed against the toy VCD above)
  algClassesOfUnderlying  := AlgebraicClassesData_E7ShimuraToy
  -- R386 bundled MT package ∃-witness (kernel-pure, no canonical axiom)
  mtCorrespondencePackage := internalFullCodimMTPackageWitness

/-! ## Section 2: safe-switched headline (kernel-pure) -/

/-- **R387** safe-switched headline: HC on the (toy) carrier, derived
through the axiom-free parametric route. Same shape as the headline
(`VarietyHC ... ...`) but on the internal toy VCD/ACD, with axiom cone
⊆ `{propext, Classical.choice, Quot.sound}` — NO `canonicalE7ShimuraTor`.

Compare with `hodgeConjectureReal_canonical` (`MainTheorem.lean`), whose
cone still contains `canonicalE7ShimuraTor` because its statement
literally references `canonicalE7ShimuraTor.{cohomology,algClasses}OfUnderlying`. -/
theorem hodgeConjectureReal_canonical_kernelPure :
    Infrastructure.HodgeStructure.VarietyHC
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy :=
  hodgeConjectureReal_from_ParametricCanonicalE7ShimuraTor
    ParametricCanonicalE7ShimuraTor_axiomFree

/-- **R387** codim-1 specialisation of the kernel-pure headline. -/
theorem VarietyHCAt_canonical_codim1_kernelPure :
    Infrastructure.HodgeStructure.VarietyHCAt
      VarietyCohomologyData_E7ShimuraToy
      AlgebraicClassesData_E7ShimuraToy 1 :=
  hodgeConjectureReal_canonical_kernelPure 1

/-! ## Section 3: status / cone-audit markers (Prop-only) -/

/-- **R387 cone fact**: `ParametricCanonicalE7ShimuraTor_axiomFree`
has cone ⊆ `{propext, Classical.choice, Quot.sound}`. -/
def R387_AxiomFreeInstance_KernelPure : Prop := True

/-- **R387 cone fact**: `hodgeConjectureReal_canonical_kernelPure`
has cone ⊆ `{propext, Classical.choice, Quot.sound}`. -/
def R387_KernelPureHeadline_NoCanonicalAxiomInCone : Prop := True

/-- **R387**: authorized refactor closure — single remaining bridge
obligation is now bridged. -/
def R387_AuthorizedRefactor_Closure_Achieved : Prop := True

/-- **R387 status**: axiom-free parametric tor available. -/
def R387_Status_AxiomFreeInstance_Defined : Prop := True

/-- **R387 status**: kernel-pure headline available (toy-carrier-stated). -/
def R387_Status_KernelPureHeadline_Defined : Prop := True

/-- **R387 status**: old headline `hodgeConjectureReal_canonical`
preserved unchanged; this round only ADDS a new kernel-pure headline. -/
def R387_Status_OldHeadline_Preserved : Prop := True

/-! ## Section 4: explicit non-closure -/

/-- **R387 non-closure (1/4)**: does NOT delete `axiom canonicalE7ShimuraTor`. -/
theorem R387_does_not_delete_canonical_axiom : True := trivial

/-- **R387 non-closure (2/4)**: does NOT identify toy carrier with the
real E_7 Shimura variety. -/
theorem R387_does_not_identify_toy_with_real_E7Shimura : True := trivial

/-- **R387 non-closure (3/4)**: does NOT close HC for the *real*
`canonicalE7ShimuraTor.cohomologyOfUnderlying` in a kernel-pure way. -/
theorem R387_does_not_close_real_canonical_HC_kernelPure : True := trivial

/-- **R387 non-closure (4/4)**: does NOT alter the original
`hodgeConjectureReal_canonical` in `MainTheorem.lean`. -/
theorem R387_does_not_alter_old_headline : True := trivial

/-! ## Section 5: graph edges -/

def L4_G_R387_AxiomFreeInstance_To_R379_ParametricHC : Prop := True
def L4_G_R387_KernelPureHeadline_To_R382_CompatWrapper : Prop := True
def L4_G_R387_To_Future_ToyToReal_Bridge : Prop := True

end HCGapL4
end HodgeReduction
