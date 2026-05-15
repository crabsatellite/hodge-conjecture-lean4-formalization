/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass

/-!
# Lefschetz theorems framework

For a smooth projective complex variety `X` with polarisation (Kähler
class) `h ∈ H²(X; ℚ)`, the **Lefschetz theorems** give:

1. **Lefschetz (1,1) theorem**: every Hodge class of type (1, 1) in
   `H²(X; ℤ)` is the first Chern class of a line bundle, hence algebraic.
   This is the **codimension-1 case of the Hodge conjecture** — proven
   classically (Lefschetz 1924; reproven by Hodge 1941, Kodaira 1953).

2. **Hard Lefschetz theorem**: for a Kähler class `h ∈ H²` on a compact
   Kähler manifold `X` of complex dimension `n`, cup product with `hᵏ`
   gives an isomorphism `H^{n-k}(X; ℚ) ≃ H^{n+k}(X; ℚ)` for `0 ≤ k ≤ n`.

3. **Lefschetz hyperplane theorem**: for `i_X : Y ↪ X` a smooth
   hyperplane section, the restriction `H^k(X; ℚ) → H^k(Y; ℚ)` is an
   isomorphism for `k < dim Y` and injective for `k = dim Y`.

This file packages the **Lefschetz (1,1) theorem** as a framework
typeclass. The full proof requires complex-analytic input (exponential
sequence + Picard group + cycle class map for divisors) not yet in
Mathlib.

## Main definitions

* `Lefschetz11Data A` : typeclass packaging the `H^{1,1}` subspace and
  the Lefschetz (1,1) algebraicity property.

## Tags

Lefschetz (1,1) theorem, divisor algebraicity, Hodge conjecture codim 1,
Néron-Severi group
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Lefschetz (1,1) theorem data** for a cohomology ring `A`:

* `H2` : the degree-2 cohomology subspace `H²(X; ℚ) ⊆ A`.
* `H11` : the `(1,1)`-Hodge piece `H^{1,1}(X; ℚ) ⊆ H²`.
* `lefschetz_11` : the **Lefschetz (1,1) theorem** — every rational
  `H^{1,1}` class is algebraic. This is the classical theorem
  (Lefschetz 1924), proven via the exponential sequence + Néron-Severi
  group + Picard variety.

For our HC application, this captures the **trivial codimension-1 case**
of HC. We use it to:
* Verify that `h ∈ H²` is `(1,1)` (since it's the polarisation).
* Derive `h ∈ algebraic` from `Lefschetz11Data` (without needing a
  separate `KaehlerClass.h_isAlgebraic` axiom). -/
class Lefschetz11Data where
  /-- The degree-2 cohomology subspace. -/
  H2 : Submodule ℚ A
  /-- The (1,1)-Hodge piece. -/
  H11 : Submodule ℚ A
  /-- The (1,1)-piece is contained in `H²`. -/
  H11_le_H2 : H11 ≤ H2
  /-- **Lefschetz (1,1) theorem**: every `H^{1,1}` rational class is
  algebraic. This is the load-bearing axiomatic content (a CLASSICAL
  THEOREM, proven by Lefschetz 1924). -/
  lefschetz_11 : ∀ α ∈ H11, CohomologyRing.IsAlgebraic α

namespace Lefschetz11Data

variable {A} [Lefschetz11Data A]

/-- Every `(1,1)`-Hodge class is algebraic (Lefschetz (1,1) theorem). -/
theorem isAlgebraic_of_H11 {α : A} (hα : α ∈ H11 (A := A)) :
    CohomologyRing.IsAlgebraic α :=
  lefschetz_11 α hα

end Lefschetz11Data

/-! ### Bridge: Kähler class is in `H^{1,1}` → algebraic via Lefschetz (1,1)

If the cohomology ring has both a `KaehlerClass` and `Lefschetz11Data`,
and if the Kähler class lies in `H^{1,1}`, then it's algebraic via
Lefschetz (1,1) — providing an ALTERNATIVE proof of
`KaehlerClass.h_isAlgebraic` not requiring it as a separate axiom. -/

variable [Lefschetz11Data A] [KaehlerClass A]

/-- **Bridge theorem**: if the Kähler class `h` is in `H^{1,1}`, then
`h` is algebraic via Lefschetz (1,1). This DERIVES `h_isAlgebraic`
from `Lefschetz11Data` (rather than assuming it). -/
theorem KaehlerClass.h_isAlgebraic_via_lefschetz11
    (h_in_H11 : (KaehlerClass.h : A) ∈ Lefschetz11Data.H11) :
    CohomologyRing.IsAlgebraic (KaehlerClass.h : A) :=
  Lefschetz11Data.isAlgebraic_of_H11 h_in_H11

end HodgeReduction.Infrastructure.Cohomology
