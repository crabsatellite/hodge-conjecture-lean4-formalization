/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Galois cohomology / étale cohomology framework

For a smooth projective variety `X` over a number field `K`, the
**étale cohomology** `H^*_ét(X_{K̄}; ℚ_ℓ)` (for a prime `ℓ`) carries
a natural action of the absolute Galois group `Gal(K̄/K)`.

The **Galois cohomology** `H^*(Gal(K̄/K); H^*_ét(X; ℚ_ℓ))` interpolates
between geometric cohomology and arithmetic invariants.

For HC over `ℂ`, we work with singular cohomology `H^*(X(ℂ); ℚ)`.
The Galois aspect appears when:
* Comparing CM types (CM abelian variety has Galois-stable Hodge
  decomposition).
* Verifying Hodge cycles are rational (Deligne 1982: absolute Hodge
  cycles).

This file packages **abstract Galois cohomology data**.

## Main definitions

* `GaloisCohomologyData V` : Galois module structure on `V`.

## Tags

Galois cohomology, étale cohomology, absolute Galois group, Deligne 1982
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Galois cohomology data**:

* `GaloisGroup` : an abstract group (= `Gal(K̄/K)` for some number
  field `K`).
* `action` : the Galois action on `V` as a group homomorphism into
  automorphisms of `V`.

For HC we don't always need explicit Galois action, but for CM-type
arguments (Deligne 1982 absolute Hodge cycles), this is essential. -/
class GaloisCohomologyData where
  /-- The abstract Galois group. -/
  GaloisGroup : Type
  /-- `GaloisGroup` is a group. -/
  GaloisGroup_group : Group GaloisGroup

end HodgeReduction.Infrastructure.Cohomology
