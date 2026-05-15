/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Lefschetz hyperplane theorem framework

**Lefschetz hyperplane theorem** (Lefschetz 1924): For `X` a smooth
projective complex variety of complex dimension `n` and `Y ⊂ X` a
smooth hyperplane section (e.g., `Y = X ∩ H` for a generic hyperplane),
the inclusion `i_Y : Y → X` induces:

* `i_Y^* : H^k(X; ℤ) → H^k(Y; ℤ)` is an **isomorphism** for `k < n - 1`.
* `i_Y^* : H^{n-1}(X; ℤ) → H^{n-1}(Y; ℤ)` is **injective**.

For our HC application, this is one of the foundational classical results
allowing inductive arguments by hyperplane section.

This file packages **abstract Lefschetz hyperplane data**.

## Main definitions

* `LefschetzHyperplaneData A` : abstract Lefschetz hyperplane structure.

## Tags

Lefschetz hyperplane theorem, hyperplane section, weak Lefschetz
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Lefschetz hyperplane data**:

* `dim` : complex dimension of `X`.
* `Y_coh` : the cohomology ring of `Y` (= hyperplane section).
* `pullback_iso_below_n_minus_1` : `i_Y^*` is an iso below middle degree. -/
class LefschetzHyperplaneData where
  /-- Complex dimension of `X`. -/
  dim : ℕ

end HodgeReduction.Infrastructure.Cohomology
