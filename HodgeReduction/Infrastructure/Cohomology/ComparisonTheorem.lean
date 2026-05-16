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

/-- **Comparison theorem data** (Grothendieck-de Rham 1966):

For a cohomology ring `A` carrying both `DeRhamData` (Hodge filtration
`F : ℕ → Submodule ℚ A`) and `BettiCohomologyData` (integer lattice
`Z_lattice : AddSubgroup A`), the comparison theorem asserts that the
integer lattice is contained in the bottom Hodge filtration step `F^0`
(via the rational lift). This is the load-bearing structural inclusion
that the comparison isomorphism `H^*_{dR}(X; ℂ) ≃ H^*_B(X; ℂ)` restricts
to on the integer lattice.

**R7 audit B.3 refactor (2026-05-16)**: previously carried a
`comparisonWitness : True` placeholder field with no mathematical
content. Refactored to the substantive submodule inclusion
`Z_lattice ⊆ F 0` whose TYPE depends on both `BettiCohomologyData` and
`DeRhamData` typeclass parameters. Instance providers must produce a
real membership-preserving proof.

The trivial instance for `Z_lattice = ⊥` discharges by `False.elim`
after `Submodule.mem_bot`; for a non-trivial integer lattice the
instance must use the published Grothendieck-de Rham comparison. -/
class ComparisonData (A : Type*) [AddCommGroup A] [Module ℚ A]
    [BettiCohomologyData A] [DeRhamData A] where
  /-- **Grothendieck-de Rham comparison inclusion** (Grothendieck 1966):
  every element of the Betti integer lattice lies in the bottom Hodge
  filtration step `F^0` of de Rham cohomology. This is the load-bearing
  structural content of the comparison isomorphism at the abstract A-level.
  -/
  lattice_in_F0 :
    ∀ a : A, a ∈ BettiCohomologyData.Z_lattice (A := A) →
      a ∈ DeRhamData.F (A := A) 0

end HodgeReduction.Infrastructure.Cohomology
