/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.PicardGroup
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Ample divisor framework

For a smooth projective variety `X`, an **ample line bundle** `L`
provides a polarisation: `c_1(L) ∈ H²(X; ℚ)` is the **polarisation
class** (Kähler class in the complex topology).

The ample line bundles form a cone in `Pic(X)`. For our HC application,
we only need:
* The existence of at least one ample line bundle (polarisation).
* The first Chern class of that bundle equals the Kähler class.

This file bridges `PicardGroupData` and `KaehlerClass`: if we have a
designated ample line bundle, we can derive `KaehlerClass.h_isAlgebraic`
from `PicardGroupData.c1_isAlgebraic`.

## Main definitions

* `AmpleDivisorData A` : typeclass providing a distinguished ample line
  bundle whose `c_1` is the Kähler class.

## Tags

ample divisor, polarisation, Kähler class, very ample line bundle
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [KaehlerClass A] [PicardGroupData A]

/-- **Ample divisor data**: a distinguished ample line bundle `L_amp`
whose first Chern class `c_1(L_amp) = h` is the Kähler class. -/
class AmpleDivisorData where
  /-- The ample line bundle. -/
  L_amp : PicardGroupData.PicRat A
  /-- `c_1(L_amp) = h` (Kähler class). -/
  c1_eq_h : PicardGroupData.c1 L_amp = (KaehlerClass.h : A)

namespace AmpleDivisorData

variable {A} [AmpleDivisorData A]

/-- **Bridge theorem**: the Kähler class `h` is algebraic, derived from
`PicardGroupData.c1_isAlgebraic` and the identity `c_1(L_amp) = h`.

This DERIVES `KaehlerClass.h_isAlgebraic` from `PicardGroupData` +
`AmpleDivisorData` — no separate axiom needed. -/
theorem h_isAlgebraic_via_picard :
    CohomologyRing.IsAlgebraic (KaehlerClass.h : A) := by
  rw [← c1_eq_h]
  exact PicardGroupData.c1_isAlgebraic _

end AmpleDivisorData

end HodgeReduction.Infrastructure.Cohomology
