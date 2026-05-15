/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Module.LinearMap.Defs

/-!
# Hecke correspondence framework

For an arithmetic Shimura variety `S_Γ = Γ \\ X`, the **Hecke algebra**
`ℋ(G, K)` acts on `H^*(S_Γ; ℂ)` by **Hecke correspondences**: for each
`g ∈ G(ℚ)`, the double coset `K g K` gives an endomorphism of `H^*`
via the diagram
```
              π_1    π_2
   S_Γ' ────→ S_Γ ←────  S_Γ''
```
of finite covers, with `π_2 * π_1^*` defining the Hecke operator.

For our HC application:
* The Hecke algebra structure provides additional symmetries on
  `H^*(S_Γ_EVII)`.
* The G-equivariance of `j^q : H^*(Ě_VII; ℚ) → H^*(S_Γ; ℚ)^G` is a
  Hecke-equivariance statement.

This file packages **abstract Hecke correspondence data**.

## Main definitions

* `HeckeAlgebraData A` : abstract Hecke algebra acting on `A`.

## Tags

Hecke algebra, Hecke correspondence, arithmetic Shimura variety,
G-equivariance
-/

namespace HodgeReduction.Infrastructure.Automorphic

variable (A : Type*) [AddCommGroup A] [Module ℚ A]

/-- **Hecke algebra data** acting on a `ℚ`-vector space `A`:

* `HeckeAlg` : abstract Hecke algebra (a `ℚ`-algebra).
* `action` : the action of `HeckeAlg` on `A`.

For our application: `A = H^*(S_Γ; ℚ)` and `HeckeAlg = ℋ(G, K)`. -/
class HeckeAlgebraData where
  /-- Abstract Hecke algebra. -/
  HeckeAlg : Type
  /-- `HeckeAlg` is a `ℚ`-vector space (linear part). -/
  HeckeAlg_addCommGroup : AddCommGroup HeckeAlg
  HeckeAlg_module : @Module ℚ HeckeAlg _ HeckeAlg_addCommGroup.toAddCommMonoid
  /-- The action of `HeckeAlg` on `A` (as a `ℚ`-bilinear map). -/
  action :
    @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) HeckeAlg
      (A →ₗ[ℚ] A)
      HeckeAlg_addCommGroup.toAddCommMonoid _ HeckeAlg_module _

end HodgeReduction.Infrastructure.Automorphic
