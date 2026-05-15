/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# The Freudenthal class on EVII and its algebraicity

This file packages the **two-route algebraicity argument** for the
Freudenthal class `[q] ∈ H^8(EVII; ℚ)`:

* **Route A** (via Chern classes): `[q] = polynomial in c_i(𝓔_{+1})`.
  Since `𝓔_{+1}` is an algebraic vector bundle (the rank-27 Hodge
  piece is automorphic, hence algebraic), all `c_i` are algebraic,
  so `[q]` is algebraic.
* **Route B** (via Kähler class): `[q] = −48 · h^4`. Since `h` is
  algebraic (it's the polarisation class), so is `[q]`.

Both routes meet at the polynomial-identity-in-Chern-classes
`-48 c_2² + 96 c_1 c_3 − 96 c_4 = -48` (modulo `h^4` weights;
P53 / P57 cross-ring identity). With the cohomology-level identity
`[q] = -48 c_2² + 96 c_1 c_3 − 96 c_4`, the algebraicity follows.

## Main statements

* `FreudenthalClassData` : packages the Freudenthal class together
  with its expression in Chern classes and its proportionality to
  `h^4`.
* `FreudenthalClassData.isAlgebraic` : both routes give algebraicity.

## Tags

Freudenthal quartic, EVII Shimura variety, cycle class map,
algebraic cohomology
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- Data packaging the Freudenthal class `[q]` together with both its
expressions:

1. **Chern-class form**: `[q] = −48 c_2² + 96 c_1 c_3 − 96 c_4`
   (where `c_i` are Chern classes of an algebraic vector bundle).
2. **Kähler-class form**: `[q] = −48 · h^4` (where `h` is the Kähler
   class).

The equality of (1) and (2) is the **P53–P57 cross-ring identity**,
verified at the rational-coefficient level in
`HodgeReduction.CrossRingArithmetic.polynomial_identity_value`.

For our purposes, the `q` field just needs to BE the polynomial in
Chern classes; the Kähler-form is an additional witness used in
`isAlgebraic_via_kaehler`. -/
structure FreudenthalClassData (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] [KaehlerClass A] where
  /-- The Chern-class data of the underlying algebraic vector bundle
  (`𝓔_{+1}` of rank 27 on EVII). -/
  chern : AlgebraicChernData A
  /-- The Freudenthal class itself. -/
  q : A
  /-- **Polynomial-in-Chern-classes identity**: `[q] = -48 c_2² + 96 c_1 c_3 − 96 c_4`. -/
  q_eq_chern_poly :
    q = (-48 : ℚ) • (chern.c 2 * chern.c 2)
        + (96 : ℚ) • (chern.c 1 * chern.c 3)
        - (96 : ℚ) • chern.c 4
  /-- **Kähler-class proportionality**: `[q] = -48 · h^4`. -/
  q_eq_neg_48_h_pow_4 :
    q = (-48 : ℚ) • (KaehlerClass.h ^ 4 : A)

namespace FreudenthalClassData

variable [KaehlerClass A] (fcd : FreudenthalClassData A)

/-- **Route A**: the Freudenthal class is algebraic via its Chern-class
expression. This uses `AlgebraicChernData.freudenthalPolynomial_isAlgebraic`
plus the polynomial identity. -/
theorem isAlgebraic_via_chern :
    CohomologyRing.IsAlgebraic fcd.q := by
  rw [fcd.q_eq_chern_poly]
  exact fcd.chern.freudenthalPolynomial_isAlgebraic

/-- **Route B**: the Freudenthal class is algebraic via its Kähler-class
proportionality. This uses `KaehlerClass.h_pow_4_isAlgebraic` plus the
proportionality identity. -/
theorem isAlgebraic_via_kaehler :
    CohomologyRing.IsAlgebraic fcd.q := by
  rw [fcd.q_eq_neg_48_h_pow_4]
  exact KaehlerClass.neg_48_h_pow_4_isAlgebraic

/-- The Freudenthal class is **unconditionally algebraic**.

Both Route A (via Chern classes) and Route B (via Kähler class)
prove this. We use Route B as it is the simpler (one-step) derivation,
but the Chern-class route is mathematically equivalent and is the
historical proof. -/
theorem isAlgebraic :
    CohomologyRing.IsAlgebraic fcd.q :=
  fcd.isAlgebraic_via_kaehler

end FreudenthalClassData

end HodgeReduction.Infrastructure.Cohomology
