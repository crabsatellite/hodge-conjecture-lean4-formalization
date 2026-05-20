/-
# HC Gap L4 — abstract Hodge source unification (R257).

R253 introduced `AbstractRationalCohomologySource` and
`AbstractRationalCohomologySourceToVCD`: an abstract `ℕ → Type`
cohomology source with ℚ-module structure per degree, plus a Prop-level
"agrees on H" marker pairing it with a target `VarietyCohomologyData`.

R257 consolidates the source side: a single `AbstractHodgeSource`
bundles both the cohomology source and its target VCD plus a
realization marker, so that downstream interfaces (R258 cycle-class-map
ACD, R259 MT-correspondence transfer) consume one object rather than
a tuple.

Per the user's R257 brief, the new structure is interface consolidation
only — no new mathematical content, no real cohomology construction,
and no real comparison theorem.

## What R257 (this file) provides (all kernel-pure)

* `AbstractHodgeSource` — unified bundle of an abstract cohomology
  source, a target `VarietyCohomologyData`, and a Prop-level
  `realizesVCDToy` marker.
* `AbstractHodgeSource.ofVCD` — adapter producing an
  `AbstractHodgeSource` from any existing `VarietyCohomologyData` by
  extracting `H`, the AddCommGroup instances, and the Module instances.
* `AbstractHodgeSource_E7ShimuraToy` — concrete instance for the
  E_7 Shimura toy carrier.
* `L1_G_AbstractHodgeSource_To_CohomologyReplacementNextTarget` —
  marker bridge back to R253's next-target registry.

## What R257 (this file) does NOT do

* Does NOT construct real cohomology.
* Does NOT prove a real comparison theorem between an
  `AbstractRationalCohomologySource` and a `VarietyCohomologyData`.
* Does NOT replace `canonicalE7ShimuraTor.cohomologyOfUnderlying`.
* Does NOT close `canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.

All R257 declarations are kernel-pure: `{propext, Classical.choice,
Quot.sound}` or smaller.
-/

import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.HCGapL4.E7ShimuraToyCarrier
import HodgeReduction.HCGapL4.CohomologyReplacementNextTarget

namespace HodgeReduction
namespace HCGapL4

open HodgeReduction.Infrastructure.HodgeStructure
open HodgeReduction.HCGapL4.E7ShimuraToyCarrier
open HodgeReduction.HCGapL4.CohomologyReplacementNextTarget

/-! ## Section 1: unified abstract Hodge source structure -/

/-- **R257 unified abstract Hodge source**. Bundles an
`AbstractRationalCohomologySource` (R253's `ℕ → Type` ℚ-module
cohomology interface) together with a target
`VarietyCohomologyData` and a Prop-level realization marker.

The `realizesVCDToy` field is paper-trail only: it stands in for the
actual "this cohomology source realizes this VCD" comparison theorem,
which is genuine bridge work not provable without a concrete
cohomology instance. Real implementations will fill this with the
real comparison statement (e.g. de Rham-to-Betti for the complex
manifold case, étale-to-Betti via Artin's comparison, etc.). -/
structure AbstractHodgeSource where
  /-- The abstract `ℕ → Type` cohomology source. -/
  cohomologySource : AbstractRationalCohomologySource
  /-- The target `VarietyCohomologyData` it is intended to realize. -/
  vcd : VarietyCohomologyData
  /-- Prop-level realization marker. -/
  realizesVCDToy : Prop

/-! ## Section 2: adapter from `VarietyCohomologyData` -/

namespace AbstractHodgeSource

/-- **R257 adapter**: any existing `VarietyCohomologyData` becomes an
`AbstractHodgeSource` by re-using its `H`, `addCommGroup`, and
`module` fields for the cohomology source side, and using the same VCD
on the target side. `realizesVCDToy := True` because the underlying
data is literally `X.H`. -/
def ofVCD (X : VarietyCohomologyData) : AbstractHodgeSource where
  cohomologySource :=
    { H := X.H
      instAddCommGroup := X.addCommGroup
      instModule := X.module }
  vcd := X
  realizesVCDToy := True

end AbstractHodgeSource

/-! ## Section 3: concrete E_7 Shimura toy instance -/

/-- **R257 concrete instance**: the E_7 Shimura toy carrier wrapped as
an `AbstractHodgeSource`. -/
noncomputable def AbstractHodgeSource_E7ShimuraToy : AbstractHodgeSource :=
  AbstractHodgeSource.ofVCD VarietyCohomologyData_E7ShimuraToy

/-! ## Section 4: marker bridge back to R253 -/

/-- **L1-G_AbstractHodgeSource_To_CohomologyReplacementNextTarget**:
bridge marker connecting R257's `AbstractHodgeSource` to R253's
`CohomologyReplacementNextTargetToySkeleton`. -/
def L1_G_AbstractHodgeSource_To_CohomologyReplacementNextTarget :
    Prop := True

/-! ## Section 5: explicit non-closure -/

/-- **R257 non-closure (1/4)**: does NOT construct real cohomology. -/
theorem R257_does_not_construct_real_cohomology : True := trivial

/-- **R257 non-closure (2/4)**: does NOT prove real cohomology ↔ VCD
comparison. -/
theorem R257_does_not_prove_real_comparison : True := trivial

/-- **R257 non-closure (3/4)**: does NOT replace
`canonicalE7ShimuraTor.cohomologyOfUnderlying`. -/
theorem R257_does_not_replace_cohomologyOfUnderlying : True := trivial

/-- **R257 non-closure (4/4)**: does NOT close `canonicalE7ShimuraTor`. -/
theorem R257_does_not_close_canonicalE7ShimuraTor : True := trivial

end HCGapL4
end HodgeReduction
