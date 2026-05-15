/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Poincaré duality framework

For a closed oriented `n`-manifold `X`, **Poincaré duality** gives an
isomorphism:
```
PD : H^k(X; ℚ) ≃ H_{n-k}(X; ℚ).
```

For a smooth projective complex variety of complex dimension `n` (so
real dimension `2n`), this gives:
```
H^k(X; ℚ) ≃ H^{2n-k}(X; ℚ)^∨ (= H^{2n-k}(X; ℚ) by self-duality with
                                top class).
```

The pairing `H^k × H^{2n-k} → H^{2n} ≃ ℚ` (via cup product + top class)
is **non-degenerate**.

For our HC application: Poincaré duality + Hard Lefschetz give the
fundamental rigidity of cohomology.

This file packages **abstract Poincaré duality data**.

## Main definitions

* `PoincareDualityData A` : duality pairing.

## Tags

Poincaré duality, top class, non-degenerate pairing
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Poincaré duality data** for a smooth projective variety:

* `dim` : complex dimension `n`.
* `topClass` : the top class `[X] ∈ H^{2n}(X; ℚ)`.
* `integral` : the integration map `A → ℚ` (= projection onto top
  class). -/
class PoincareDualityData where
  /-- Complex dimension. -/
  dim : ℕ
  /-- The top cohomology class. -/
  topClass : A
  /-- Integration map `α ↦ ∫_X α` as a ℚ-linear map. -/
  integral : A →ₗ[ℚ] ℚ

end HodgeReduction.Infrastructure.Cohomology
