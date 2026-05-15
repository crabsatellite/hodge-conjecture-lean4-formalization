/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Automorphic.Basic

/-!
# Cuspidal cohomology framework

The **cuspidal cohomology** `H^*_{cusp}(S_Γ; ℚ)` is the contribution to
`H^*(S_Γ; ℚ)` from cuspidal automorphic representations of `G(𝔸)`. By
Borel-Wallach 1980 + Franke 1998, it can be computed via:
```
H^*_{cusp}(S_Γ; ℂ) = ⨁_π H^*(g, K; π_∞) ⊗ π_f^Γ_f
```
where the sum is over cuspidal representations `π = π_∞ ⊗ π_f`.

For the Hermitian symmetric pair `(E_{7(-25)}, E_6 × U(1))`, by
Salamanca-Riba 1999 + V-Z 1984: the cuspidal G-invariant H^8 reduces
to the trivial-module contribution.

This file packages **abstract cuspidal cohomology data**.

## Main definitions

* `CuspidalCohomologyData A` : abstract cuspidal subspace data.

## Tags

cuspidal cohomology, automorphic representation, Borel-Wallach 1980,
trivial module
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Cuspidal cohomology data**:

* `cuspidalSubspace` : the cuspidal subspace `H^*_{cusp}(S_Γ; ℚ) ⊆ A`.
* `trivialModulePart` : the trivial-module part `(via Cartan thm)`.

For the EVII case: at degree 8, `trivialModulePart` equals the
image of `j^8 : H^8(Ě_VII; ℚ) → H^8(S_Γ; ℚ)^G`. -/
class CuspidalCohomologyData where
  /-- The cuspidal cohomology subspace. -/
  cuspidalSubspace : Submodule ℚ A
  /-- The trivial-module part of the cuspidal cohomology. -/
  trivialModulePart : Submodule ℚ A
  /-- The trivial-module part is contained in the cuspidal part. -/
  trivial_le_cuspidal : trivialModulePart ≤ cuspidalSubspace

end HodgeReduction.Infrastructure.Automorphic
