/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Period domain framework

For a polarised pure Hodge structure type `(V, n, ψ)`, the **period
domain** `D` is the moduli space of all such structures on a fixed
`V` with fixed `(n, ψ)`. It is a homogeneous space `G_ℝ / V` where
`G = Aut(V, ψ)` and `V` is the isotropy group of a reference Hodge
filtration.

For our HC application, the EVII Shimura variety arises as the
arithmetic quotient `Γ \ D` for `D = E_{7(-25)} / (E_6 × U(1))`,
which is a Hermitian symmetric domain of complex dimension 27.

This file packages **abstract period domain data**.

## Main definitions

* `PeriodDomainData V n` : abstract period domain for polarised
  Hodge structures of weight `n` on `V`.

## Tags

period domain, Hodge variation, Shimura variety, Hermitian symmetric
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Period domain data** for polarised Hodge structures of weight `n`
on `V`:

* `D` : the period domain as an abstract type.
* `complexDim` : the complex dimension of `D` (= 27 for EVII).
* `inhabited_D` : the period domain is non-empty.

This is the **carrier-level** abstraction. The full geometry of `D` as
a complex manifold / open subset of a flag variety is heavy and
deferred. -/
class PeriodDomainData (n : ℕ) where
  /-- The period domain. -/
  D : Type
  /-- The complex dimension of `D`. -/
  complexDim : ℕ
  /-- The period domain is non-empty. -/
  inhabited_D : Inhabited D

-- (Derived accessors for the period domain are deferred.)

end HodgeReduction.Infrastructure.Shimura
