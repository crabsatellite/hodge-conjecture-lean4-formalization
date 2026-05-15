/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.PicardGroup

/-!
# Divisor class framework

A **divisor** on a smooth projective variety `X` is a formal `ℤ`-linear
combination of codim-1 subvarieties of `X`. Divisors modulo linear
equivalence form the **Picard group** `Pic(X)` (already abstracted in
`PicardGroup.lean`); divisors modulo algebraic equivalence form the
**Néron-Severi group** `NS(X)` (already abstracted in `NeronSeveri.lean`).

The **divisor class** of a subvariety `D ⊂ X` of codim 1 gives an
element of `H²(X; ℤ)` via:
* The Poincaré dual / Lefschetz cycle class map.
* Or equivalently, `[D] = c_1(𝒪_X(D))` for the associated line bundle.

This file packages the **abstract divisor class** framework.

## Main definitions

* `DivisorClassData A` : divisor classes as a ℚ-subspace of `A`.

## Tags

divisor, divisor class, codim 1 cycle, line bundle
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Divisor class data**:

* `divisors` : the ℚ-subspace of divisor classes in `A`.
* `divisor_isAlgebraic` : every divisor class is algebraic
  (since divisors are codim-1 algebraic cycles). -/
class DivisorClassData where
  /-- The ℚ-subspace of divisor classes. -/
  divisors : Submodule ℚ A
  /-- Every divisor class is algebraic. -/
  divisor_isAlgebraic : ∀ α ∈ divisors, CohomologyRing.IsAlgebraic α

namespace DivisorClassData

variable {A} [DivisorClassData A]

/-- Every divisor class is algebraic. -/
theorem isAlgebraic_of_divisor {α : A} (hα : α ∈ divisors (A := A)) :
    CohomologyRing.IsAlgebraic α :=
  divisor_isAlgebraic α hα

end DivisorClassData

end HodgeReduction.Infrastructure.Cohomology
