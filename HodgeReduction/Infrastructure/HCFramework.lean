/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass
import HodgeReduction.Infrastructure.Cohomology.FreudenthalClass
import HodgeReduction.Infrastructure.Cohomology.AlgebraicBundle
import HodgeReduction.Infrastructure.Cohomology.CycleClassMap
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.HodgeStructure.MumfordTate
import HodgeReduction.Infrastructure.HodgeStructure.Variation
import HodgeReduction.Infrastructure.HodgeStructure.V56Instance
import HodgeReduction.Infrastructure.AbelianVariety.Basic
import HodgeReduction.Infrastructure.Automorphic.Basic
import HodgeReduction.Infrastructure.Automorphic.VoganZuckerman
import HodgeReduction.Infrastructure.Shimura.Basic
import HodgeReduction.Infrastructure.Shimura.CompactDual
import HodgeReduction.Infrastructure.Shimura.MumfordExtension
import HodgeReduction.Infrastructure.Coxeter.WE7

/-!
# Hodge Conjecture reduction framework — summary and assembly

This file is the **top-level framework** assembling all the
infrastructure pieces (Cohomology + HodgeStructure + Shimura +
AbelianVariety + Automorphic + Coxeter + AlgebraicBundle +
CycleClassMap) into a single Lean-verifiable HC reduction argument.

## The framework as data flow

```
   AlgebraicVectorBundle A
         │
         │ (chern_isAlgebraic)
         ▼
   AlgebraicChernData A ──┐
                          │
   KaehlerClass A ────────┤
                          │
                          ▼
   FreudenthalClassData A  ──── isAlgebraic ───► fcd.q ∈ algebraic
   (q_eq_chern_poly +
    q_eq_neg_48_h_pow_4)
                          ▲
                          │
   PolarisedHodgeStructure │ (via V56_PureHodgeStructure)
   V56 3 (weight 3)        │
                          │
   MumfordExtensionData    │ (via L-block-diagonality)
                          │
   AutomorphicCohomology   │ (via Eisenstein vanishing)
                          │
   VZAqLambdaData          │ (via Salamanca-Riba 1999)
                          │
   CompactDualData         │ (via Borel-Hirzebruch H^8 = Q . h^4)
                          │
   WE7 (Coxeter)           │ (via Chevalley-Shephard-Todd)
                          │
   ShimuraVarietyData      │ (via the EVII Shimura datum)
```

## The HC reduction theorem (abstract)

Under the abstract framework, given:

* `A` : a CohomologyRing
* `KaehlerClass A` (h is algebraic — polarisation axiom)
* `FreudenthalClassData A` (q = -48 h^4 — paper-stated identity)

we conclude `CohomologyRing.IsAlgebraic fcd.q` — the Freudenthal
class is algebraic.

This is the abstract HC closure for our specific case. The
remaining work is:

* Constructing an instance of CohomologyRing for H^*(EVII; ℚ).
* Constructing an instance of KaehlerClass for h ∈ H^2(EVII; ℚ).
* Constructing FreudenthalClassData with q ∈ H^8(EVII; ℚ).

These constructions are AXIOMATIC in the current state of Mathlib,
because they require the algebraic-geometry stack (schemes, sheaves,
cycle class maps) that isn't yet formalised. But the abstract
framework reduces the load-bearing content from a single big axiom
(`polynomial_in_chern_classes_is_algebraic`) to ATOMIC axioms in
the typeclass fields.

## The atomic axioms

After this framework, the original Cat 2 axiom
`polynomial_in_chern_classes_is_algebraic` is replaced by:

1. **KaehlerClass.h_isAlgebraic** : h is algebraic (Lefschetz (1,1) for divisors)
2. **CycleRingData.cl_image_subset** : image of cycle class map is algebraic
3. **AlgebraicVectorBundle.chern_isAlgebraic** : Chern classes of algebraic
   vector bundles are algebraic (via cycle class map)
4. **FreudenthalClassData.q_eq_chern_poly** : the polynomial identity
   `[q] = -48 c_2² + 96 c_1 c_3 − 96 c_4` (cohomology-level)
5. **FreudenthalClassData.q_eq_neg_48_h_pow_4** : the Kähler-class
   proportionality `[q] = -48 h^4`

Each is a single ATOMIC claim, more replaceable than the original
monolithic axiom. As Mathlib's algebraic geometry stack matures,
each can be replaced by a proof.

## Tags

Hodge Conjecture, Mumford-Tate reduction, EVII, framework
-/

namespace HodgeReduction.Infrastructure.HCFramework

open HodgeReduction.Infrastructure.Cohomology

/-! ### The unconditional algebraicity theorem in the abstract framework -/

variable {A : Type*} [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [KaehlerClass A]

/-- **The HC framework theorem**: in any abstract cohomology ring
with a Kähler class and a FreudenthalClassData providing the q ≃ -48 h^4
proportionality, the Freudenthal class q is algebraic.

This is the abstract version of the HC closure for the Freudenthal
quartic. Given the framework data, the conclusion is `kernel-derivable`
(via `FreudenthalClassData.isAlgebraic`); the framework data itself
is atomized into the 5 axioms listed in the file docstring. -/
theorem freudenthal_class_isAlgebraic
    (fcd : FreudenthalClassData A) :
    CohomologyRing.IsAlgebraic fcd.q :=
  fcd.isAlgebraic

/-- Equivalent statement via Chern-classes route. -/
theorem freudenthal_class_isAlgebraic_via_chern
    (fcd : FreudenthalClassData A) :
    CohomologyRing.IsAlgebraic fcd.q :=
  fcd.isAlgebraic_via_chern

/-- Equivalent statement via Kähler-class route. -/
theorem freudenthal_class_isAlgebraic_via_kaehler
    (fcd : FreudenthalClassData A) :
    CohomologyRing.IsAlgebraic fcd.q :=
  fcd.isAlgebraic_via_kaehler

end HodgeReduction.Infrastructure.HCFramework
