/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.Algebra.Module.Submodule.Basic

/-!
# Automorphic cohomology: Eisenstein/cuspidal decomposition

For an arithmetic locally-symmetric space `S_Γ := Γ \\ X` with `Γ`
a congruence subgroup of a reductive `ℚ`-algebraic group `G`,
the rational cohomology `H^*(S_Γ; ℚ)` decomposes:
```
H^*(S_Γ; ℚ) = H^*_{cusp}(S_Γ; ℚ) ⊕ H^*_{Eis}(S_Γ; ℚ)
```
where:

* `H^*_{cusp}` is the **cuspidal cohomology** (Borel 1974;
  Franke 1998 §1.2).
* `H^*_{Eis}` is the **Eisenstein cohomology** (Borel-Serre 1973;
  Franke 1998 §1.4).

The Eisenstein cohomology further decomposes by associate classes
of parabolic subgroups (Franke 1998 §1.4). For our HC application,
the key fact is:

**Eisenstein vanishing at deg 8 for EVII**: `H^8_{Eis}(S_Γ; ℚ) = 0`
when restricted to G-invariants, by Borel-Serre + Franke + the
codim-26 boundary stratum bound.

## Main definitions

* `AutomorphicCohomology A` : a typeclass providing the Eisenstein/cuspidal
  decomposition data.

## Tags

automorphic cohomology, Eisenstein cohomology, cuspidal cohomology,
Franke 1998, Borel-Serre 1973
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Automorphic cohomology decomposition** data:

* `cuspidalPart` : the cuspidal cohomology subspace `H^*_{cusp} ⊆ A`.
* `eisensteinPart` : the Eisenstein cohomology subspace `H^*_{Eis} ⊆ A`.

The two parts are required to sum to all of `A` (i.e., the
decomposition is exhaustive) and to be disjoint at the submodule level. -/
class AutomorphicCohomology where
  /-- The cuspidal cohomology piece. -/
  cuspidalPart : Submodule ℚ A
  /-- The Eisenstein cohomology piece. -/
  eisensteinPart : Submodule ℚ A
  /-- The two pieces span all of `A`. -/
  span_eq_top : cuspidalPart ⊔ eisensteinPart = ⊤
  /-- The two pieces have trivial intersection. -/
  inter_eq_bot : cuspidalPart ⊓ eisensteinPart = ⊥

namespace AutomorphicCohomology

variable {A} [AutomorphicCohomology A]

/-- Any cohomology class `α ∈ A` decomposes as `α = α_cusp + α_Eis`
with `α_cusp ∈ cuspidalPart` and `α_Eis ∈ eisensteinPart`. -/
theorem decomposition_exists (α : A) :
    ∃ (αc : cuspidalPart (A := A)) (αE : eisensteinPart (A := A)),
      α = αc.val + αE.val := by
  have hspan : α ∈ (cuspidalPart (A := A) ⊔ eisensteinPart (A := A)) := by
    rw [span_eq_top]
    exact Submodule.mem_top
  rw [Submodule.mem_sup] at hspan
  obtain ⟨αc, hαc, αE, hαE, hsum⟩ := hspan
  exact ⟨⟨αc, hαc⟩, ⟨αE, hαE⟩, hsum.symm⟩

end AutomorphicCohomology

end HodgeReduction.Infrastructure.Automorphic
