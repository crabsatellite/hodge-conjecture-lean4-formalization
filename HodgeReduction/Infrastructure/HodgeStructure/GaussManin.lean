/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Variation

/-!
# Gauss-Manin connection framework

For a smooth proper family `f : 𝒳 → S` of varieties, the cohomology
sheaves `R^q f_* ℚ` carry the **Gauss-Manin connection** ∇, an
algebraic flat connection on `R^q f_* 𝒪_S ⊗ ℂ`.

The Gauss-Manin connection is the differential form of variation of
Hodge structures: a VHS over `S` consists of a `ℚ`-local system
`V_ℚ` with a Hodge filtration `F^•` on `V_ℚ ⊗ 𝒪_S`, and `∇ : V_𝒪 →
V_𝒪 ⊗ Ω^1_S` satisfies Griffiths transversality `∇(F^p) ⊆ F^{p-1}
⊗ Ω^1_S`.

For our HC application: the Gauss-Manin connection on the universal
family over a Shimura variety carries the VHS structure.

This file packages **abstract Gauss-Manin connection data**.

## Main definitions

* `GaussManinData B V` : abstract Gauss-Manin connection on `V` over base `B`.

## Tags

Gauss-Manin connection, flat connection, Griffiths transversality, VHS
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (B : Type*) (V : B → Type*)

/-- **Gauss-Manin connection data** over a base `B`:

* `connection` : the connection itself, abstractly as a function
  `B → B`(?) — for our purposes we only need its existence as data.

Full theory requires sheaves + differential forms + flat-connection
axioms. We abstract at the carrier level. -/
class GaussManinData where
  /-- Abstract connection witness. -/
  connectionWitness : ∀ _ : B, Type

end HodgeReduction.Infrastructure.HodgeStructure
