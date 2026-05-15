/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import Mathlib.LinearAlgebra.BilinearForm.Basic

/-!
# Polarised pure ℚ-Hodge structures

A **polarisation** of a pure ℚ-Hodge structure of weight `n` on `V` is
a non-degenerate `ℚ`-bilinear form `ψ : V × V → ℚ`, satisfying:

1. **Symmetry/antisymmetry**: `ψ` is symmetric if `n` is even, antisymmetric
   if `n` is odd.
2. **First Hodge-Riemann relation**: `ψ(F^p, F^{n-p+1}) = 0` (the Hodge
   filtration pieces are isotropic).
3. **Second Hodge-Riemann relation** (positivity): the complexification
   `ψ^ℂ` satisfies appropriate sign conditions on each `(p, q)`-piece.

For our application, we only need (1) and (2). The complex positivity (3)
is what distinguishes Hodge structures from "Hodge-de-Rham" structures
and is the source of the rigidity arguments (Schmid 1973, etc.).

## Main definitions

* `PolarisedHodgeStructure V n` : a typeclass extending `PureHodgeStructure`
  with a bilinear form `psi : V →ₗ[ℚ] V →ₗ[ℚ] ℚ` and an antisymmetry/symmetry
  bit depending on `n % 2`.

## Tags

Hodge structure, polarisation, symplectic form, Hodge-Riemann
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- A **polarisation** for a pure Hodge structure of weight `n` is a
non-degenerate `ℚ`-bilinear form on `V`, symmetric if `n` is even and
antisymmetric if `n` is odd.

For our V_56 application (weight 3, ODD), the polarisation is the
**symplectic form** `ω : V_56 × V_56 → ℚ`. -/
class PolarisedHodgeStructure (n : ℕ) extends PureHodgeStructure V n where
  /-- The polarisation form as a Mathlib bilinear map. -/
  psi : V →ₗ[ℚ] V →ₗ[ℚ] ℚ
  /-- `psi` is non-degenerate. -/
  psi_nondegen : ∀ v : V, (∀ w : V, psi v w = 0) → v = 0
  /-- For odd weight `n`, `psi` is antisymmetric: `psi v w = -psi w v`. -/
  psi_alternating_of_odd : n % 2 = 1 → ∀ v w : V, psi v w = -psi w v
  /-- For even weight `n`, `psi` is symmetric: `psi v w = psi w v`. -/
  psi_symmetric_of_even : n % 2 = 0 → ∀ v w : V, psi v w = psi w v

namespace PolarisedHodgeStructure

variable {V} {n : ℕ} [PolarisedHodgeStructure V n]

/-- For odd weight, `psi(v, v) = 0` (alternating). -/
theorem psi_self_of_odd (hodd : n % 2 = 1) (v : V) :
    PolarisedHodgeStructure.psi v v (n := n) = 0 := by
  have h := PolarisedHodgeStructure.psi_alternating_of_odd (V := V) (n := n) hodd v v
  linarith

end PolarisedHodgeStructure

end HodgeReduction.Infrastructure.HodgeStructure
