/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Algebraic cycle framework (arbitrary codimension)

An **algebraic cycle** of codimension `p` on a smooth projective variety
`X` is a formal `ℤ`-linear combination of `p`-codimensional subvarieties.
The **cycle class map** sends such cycles to `H^{2p}(X; ℚ)`.

For codim 1: cycles modulo linear equivalence = `Pic(X)` (divisors).
For codim 2: cycles modulo rational equivalence = `CH²(X)` (a more
complex group).
For codim `p`: `CH^p(X)` (Chow group, hard to compute in general).

The Hodge conjecture asks: is the cycle class map surjective onto
the rational Hodge classes?

This file packages the **algebraic cycle** framework at codim `p`.

## Main definitions

* `AlgebraicCycleData A p` : the ℚ-subspace of codim-`p` algebraic
  cycle classes in `A`.

## Tags

algebraic cycle, Chow group, codimension p, cycle class map
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Algebraic cycle data of codimension `p`**:

* `cycles_p` : the ℚ-subspace of codim-`p` algebraic cycle classes.
* `cycles_p_le_algebraic` : every codim-`p` algebraic cycle is
  algebraic in the cohomology-ring sense. -/
class AlgebraicCycleData (p : ℕ) where
  /-- The ℚ-subspace of codim-`p` algebraic cycle classes. -/
  cycles_p : Submodule ℚ A
  /-- Every codim-`p` algebraic cycle class is algebraic. -/
  cycles_p_le_algebraic :
    ∀ α ∈ cycles_p, CohomologyRing.IsAlgebraic α

end HodgeReduction.Infrastructure.Cohomology
