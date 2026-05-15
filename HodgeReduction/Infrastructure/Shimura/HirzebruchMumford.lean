/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Hirzebruch–Mumford proportionality

For a Hermitian symmetric space `G/K` of non-compact type with
arithmetic locally-symmetric Shimura variety `S_Γ = Γ \\ G/K`, the
**Hirzebruch–Mumford proportionality** says:

* `χ(S_Γ; F) = (vol Γ \\ G) · χ(Ǧ/K; F̌)`
  (Euler characteristics, up to volume normalisation)
* On the form-level: Chern-Weil forms of an automorphic line/vector
  bundle `F` on `S_Γ` are proportional to those of the dual `F̌` on
  the compact dual `Ǧ/K`.

For our HC application (EVII), the H-M proportionality is the bridge
that carries facts from the compact dual `Ě_VII` (computable via BBW
+ Borel-Hirzebruch) to the Shimura variety `S_Γ_EVII` (where the
Hodge conjecture is asked).

Specifically:
* On compact dual: `H^8(Ě_VII; ℚ) = ℚ · h^4` (Borel-Hirzebruch).
* H-M: corresponding statement on `S_Γ`'s automorphic cohomology
  (with appropriate twist by `Γ`).

This file abstracts the **form-level proportionality data**.

## Main definitions

* `HirzebruchMumfordData A` : a typeclass carrying the H-M proportionality
  constant + form-level proportionality.

## Tags

Hirzebruch-Mumford, proportionality, compact dual, automorphic bundle
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]
    [HodgeReduction.Infrastructure.Cohomology.KaehlerClass A]

/-- **Hirzebruch-Mumford proportionality data**:

For an automorphic vector bundle on a Hermitian symmetric Shimura
variety, the Chern-Weil forms on `S_Γ` are proportional to those on
the compact dual `Ǧ/K` (with proportionality constant depending on
the volume of `Γ \\ G`).

We abstract the **proportionality constant** + the **proportionality
witness** (a designated class in `A` proportional to `h^4`). -/
class HirzebruchMumfordData where
  /-- The proportionality constant (a non-zero rational, depending on
  the volume of the arithmetic quotient). -/
  k : ℚ
  /-- The constant is non-zero. -/
  k_ne_zero : k ≠ 0
  /-- A designated class `α : A` that equals `k • h^4` (the H-M-form
  proportionality witness). -/
  alpha : A
  /-- The proportionality identity. -/
  alpha_eq : alpha = k • (HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h : A) ^ 4

namespace HirzebruchMumfordData

variable {A} [HirzebruchMumfordData A]

/-- The H-M proportionality witness `α` is **algebraic**: it equals
`k • h^4`, both factors are in the algebraic subring. -/
theorem alpha_isAlgebraic :
    HodgeReduction.Infrastructure.Cohomology.CohomologyRing.IsAlgebraic
      (alpha (A := A)) := by
  rw [alpha_eq]
  exact HodgeReduction.Infrastructure.Cohomology.CohomologyRing.isAlgebraic_smul _
    HodgeReduction.Infrastructure.Cohomology.KaehlerClass.h_pow_4_isAlgebraic

end HirzebruchMumfordData

end HodgeReduction.Infrastructure.Shimura
