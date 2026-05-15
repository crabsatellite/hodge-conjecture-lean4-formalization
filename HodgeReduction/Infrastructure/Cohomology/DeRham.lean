/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# de Rham cohomology framework

For a smooth manifold (or smooth complex variety) `X`, the **de Rham
cohomology** `H^*_{dR}(X)` is computed by the complex of differential
forms.

For complex algebraic varieties:
* `H^*_{dR}(X; ℂ) = H^*(X; ℂ)` (de Rham comparison, Grothendieck 1966).
* The Hodge filtration `F^p H^*_{dR}` comes from the stupid filtration
  on the de Rham complex.

For our HC application:
* The Hodge filtration `F^p` provides the (p, *)-Hodge piece.
* The cup product is the wedge product on forms (graded-commutative).

This file packages **abstract de Rham cohomology data**.

## Main definitions

* `DeRhamData A` : abstract de Rham cohomology structure.

## Tags

de Rham cohomology, differential form, Hodge filtration, wedge product
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A]

/-- **de Rham cohomology data**:

* `F` : the Hodge filtration `F^p ⊆ A` for each `p`.
* `F_monotone` : the filtration is decreasing in `p`. -/
class DeRhamData where
  /-- The Hodge filtration F^p. -/
  F : ℕ → Submodule ℚ A
  /-- The filtration is decreasing. -/
  F_monotone : ∀ {p q : ℕ}, p ≤ q → F q ≤ F p

end HodgeReduction.Infrastructure.Cohomology
