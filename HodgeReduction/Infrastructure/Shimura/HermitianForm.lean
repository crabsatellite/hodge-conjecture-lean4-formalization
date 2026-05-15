/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Hermitian form framework

For a polarised Hodge structure of weight `n`, the **Hermitian form**
on `V_ℂ` is
```
h(α, β) := i^n · ψ_ℂ(α, conj(β))
```
where `ψ` is the polarisation form. The Hodge-Riemann second relation
states that `h` is positive definite on the primitive part of each
Hodge piece `H^{p,q}`.

For our HC application: the Hermitian form encodes the positivity
properties needed for rigidity arguments (e.g., Schmid 1973 / CKS 1986).

This file packages **abstract Hermitian form data**.

## Main definitions

* `HermitianFormData V` : Hermitian form data on V_ℂ.

## Tags

Hermitian form, polarisation, Hodge-Riemann positivity
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Hermitian form data**:

* `pairing` : the Hermitian form (`ℚ`-bilinear, abstract version).
* `is_positive_definite_on_primitive` : positivity on primitive piece. -/
class HermitianFormData where
  /-- The Hermitian pairing as a Q-bilinear form. -/
  pairing : V →ₗ[ℚ] V →ₗ[ℚ] ℚ

end HodgeReduction.Infrastructure.Shimura
