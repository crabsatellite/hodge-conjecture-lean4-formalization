/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Kähler class as an algebraic cohomology class

For a smooth projective variety `X` with a polarisation
(an ample line bundle `L`), the **Kähler class**
`h := c_1(L) ∈ H^2(X; ℚ)` is an algebraic cohomology class: it
arises from the divisor class of `L`, which is a 1-codimensional
algebraic cycle.

This file packages the existence of a Kähler class with its
algebraicity as a typeclass `KaehlerClass`. From this, polynomials
`h, h^2, h^3, h^4, ...` are all algebraic by the closure properties
of the algebraic subring.

## Main definitions

* `KaehlerClass A` : a typeclass providing a designated Kähler
  class `h : A` and proof of its algebraicity.
* `KaehlerClass.h_pow_isAlgebraic n` : `h^n` is algebraic for any `n`.

## Mathematical content

This is the simplest case of the "Lefschetz hyperplane theorem
implies HC for codim-1 classes" — divisors are obviously algebraic
because they are codim-1 algebraic cycles. The Hodge conjecture
in this case is just the (1,1)-classes are algebraic statement,
which follows from the Lefschetz (1,1) theorem (a classical result).

For our application: the Kähler class `h ∈ H^2(EVII; ℚ)` is the
generator of `H^*(EVII; ℚ)` (since `EVII` has cohomology ring
`ℚ[h] / (h^{27+1})` as a compact Hermitian symmetric space of
complex dimension 27). Powers `h^k` generate the whole cohomology.

## Tags

Kähler class, polarisation, ample divisor, Lefschetz (1,1)
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- A `KaehlerClass` for `A` is a distinguished element `h : A` that
is algebraic. Morally, `h = c_1(L)` for some ample line bundle `L`. -/
class KaehlerClass (A : Type*) [CommRing A] [Algebra ℚ A]
    [CohomologyRing A] where
  /-- The Kähler class. -/
  h : A
  /-- The Kähler class is algebraic. -/
  h_isAlgebraic : CohomologyRing.IsAlgebraic h

namespace KaehlerClass

variable [KaehlerClass A]

/-- The Kähler class itself is algebraic (re-export at the
`KaehlerClass` namespace level). -/
theorem h_algebraic : CohomologyRing.IsAlgebraic (h : A) :=
  h_isAlgebraic

/-- Any power `h^n` of the Kähler class is algebraic. -/
theorem h_pow_isAlgebraic (n : ℕ) :
    CohomologyRing.IsAlgebraic ((h : A) ^ n) :=
  CohomologyRing.isAlgebraic_pow h_isAlgebraic n

/-- The 4th power `h^4` is algebraic — the specific case used in
the Freudenthal-class HC argument for EVII (where the Freudenthal
class lives in `H^8` and equals `c · h^4` for some `c : ℚ`). -/
theorem h_pow_4_isAlgebraic : CohomologyRing.IsAlgebraic ((h : A) ^ 4) :=
  h_pow_isAlgebraic 4

/-- Any rational-scalar multiple of `h^n` is algebraic. -/
theorem rat_smul_h_pow_isAlgebraic (r : ℚ) (n : ℕ) :
    CohomologyRing.IsAlgebraic (r • ((h : A) ^ n)) :=
  CohomologyRing.isAlgebraic_smul r (h_pow_isAlgebraic n)

/-- The specific class `-48 • h^4` is algebraic — the right-hand-side
of the Freudenthal-class identity `[q] = −48 h^4` for EVII. -/
theorem neg_48_h_pow_4_isAlgebraic :
    CohomologyRing.IsAlgebraic ((-48 : ℚ) • ((h : A) ^ 4)) :=
  rat_smul_h_pow_isAlgebraic _ _

end KaehlerClass

end HodgeReduction.Infrastructure.Cohomology
