/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Matsushima homomorphism framework

**Y. Matsushima 1962** ("On Betti numbers of compact, locally
symmetric Riemannian manifolds", Osaka Math. J. 14, 1-20) constructs
the **Matsushima homomorphism**:
```
j^q : H^q(Ě; ℂ) → H^q(S_Γ; ℂ)^G
```
from the compact-dual cohomology to the G-invariant part of the
arithmetic-quotient cohomology.

**A. Borel 1974** ("Stable real cohomology of arithmetic groups",
Ann. Sci. ÉNS 7, 235-272) proves the **stable range theorem**:
`j^q` is INJECTIVE for `q ≤ c(G)`, where `c(G)` is a specific constant
depending on `G`.

For our HC application:
* `c(E_7) = 8` is the load-bearing fact: `j^8` is injective on
  `H^8(Ě_VII; ℚ) = ⟨h^4⟩`.
* Combined with Cartan 1929 (`H^*(g, K; ℂ) = H^*(Ě; ℂ)`), this gives
  the trivial-module Cartan image identification.

This file packages **abstract Matsushima homomorphism data**.

## Main definitions

* `MatsushimaData A B` : the j^q homomorphism + its injective range.

## Tags

Matsushima homomorphism, Borel stable range, j^q, compact dual
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]
    (B : Type*) [AddCommGroup B] [Module ℚ B]

/-- **Matsushima homomorphism data**:

* `j_q` : the j^q map at degree `q` (linear).
* `injective_range` : the injective range (= `c(G)`).
* `j_q_injective` : `j_q` is injective for `q ≤ injective_range`.

For our EVII application: `injective_range = 8` (Borel 1974 c(E_7)). -/
class MatsushimaData where
  /-- The Matsushima homomorphism j^q. -/
  j_q : A →ₗ[ℚ] B
  /-- The injective range constant (e.g., c(E_7) = 8). -/
  injective_range : ℕ
  /-- j^q is injective on its image (= image-trivial-kernel). -/
  j_q_injective : Function.Injective j_q

end HodgeReduction.Infrastructure.Cohomology
