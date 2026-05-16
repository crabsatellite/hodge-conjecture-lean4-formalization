/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Sheaf cohomology framework (abstract)

For a smooth projective variety `X` and a coherent sheaf `F` on `X`,
the **sheaf cohomology** `H^i(X; F)` is the right-derived functor of
global sections.

Key cases for HC:
* `H^i(X; ℚ)` (constant sheaf) = singular cohomology over `ℚ`.
* `H^i(X; 𝒪_X)` = sheaf cohomology of structure sheaf (Hodge `(0, i)`-piece).
* `H^i(X; Ω^p_X)` = sheaf cohomology of `p`-forms (Hodge `(p, i)`-piece).
* Hodge decomposition: `H^k(X; ℂ) = ⨁_{p+q=k} H^q(X; Ω^p_X)`.

For our HC application, the Hodge decomposition for the rational
cohomology is the source of the (p, p)-Hodge bigrading.

This file packages **abstract sheaf cohomology data**.

## Main definitions

* `SheafCohomologyData` : abstract sheaf cohomology functor data.

## Tags

sheaf cohomology, Hodge decomposition, coherent sheaf, Dolbeault
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Sheaf cohomology data** for a smooth projective variety:

* `H_pq` : the Hodge `(p, q)`-piece for `p + q = k`.

For our HC application: this is the Hodge decomposition at the
abstract level. The full theory requires complex-analytic input
(de Rham / Dolbeault cohomology).

**R7 audit B.3 refactor (2026-05-16)**: previously carried a
`H_pq_bigrading_compatible : True` placeholder field with no
mathematical content. That field was deleted. The substantive
`H_pq : ℕ → ℕ → Submodule ℚ A` Submodule-valued data is retained;
downstream consumers will refine this with concrete bigrading axioms
on a per-variety basis (e.g., `V56HodgeDecomp`). -/
class SheafCohomologyData (A : Type*) [AddCommGroup A] [Module ℚ A] where
  /-- The `(p, q)`-Hodge piece of `A`. -/
  H_pq : ℕ → ℕ → Submodule ℚ A

end HodgeReduction.Infrastructure.Cohomology
