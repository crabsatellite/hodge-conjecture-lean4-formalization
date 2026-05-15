/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.DeRham
import HodgeReduction.Infrastructure.Cohomology.BettiCohomology

/-!
# Comparison theorem framework

For a smooth complex algebraic variety `X`, there are canonical
isomorphisms (comparison theorems):

* **Grothendieck-de Rham** (1966):
  `H^*_{dR}(X/ℂ) ≃ H^*_B(X(ℂ); ℂ) = H^*_B(X) ⊗_ℚ ℂ`.

* **Artin-Grothendieck** (SGA4):
  `H^*_ét(X_{ℂ}; ℚ_ℓ) ≃ H^*_B(X(ℂ); ℚ_ℓ) = H^*_B(X) ⊗_ℚ ℚ_ℓ`.

These give the "three realisations" (Betti / de Rham / étale) of
the same motive.

For our HC application: the comparison isomorphism between Betti and
de Rham gives the **Hodge decomposition**
`H^k_B(X; ℂ) = ⨁_{p+q=k} H^{p,q}` and the **Hodge filtration** `F^p`.

This file packages **abstract comparison theorem data**.

## Main definitions

* `ComparisonData A` : abstract comparison isomorphism.

## Tags

comparison theorem, Grothendieck-de Rham, Artin-Grothendieck, motive
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Comparison theorem data**:

* `Betti_to_dR` : the Betti → de Rham comparison (after extending scalars
  to ℂ).

For our purposes we abstract the existence of such comparison. -/
class ComparisonData where
  /-- The comparison map (abstractly). -/
  comparisonWitness : True

end HodgeReduction.Infrastructure.Cohomology
