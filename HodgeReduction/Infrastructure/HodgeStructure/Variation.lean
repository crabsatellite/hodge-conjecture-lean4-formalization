/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Variations of Hodge structures (VHS)

A **variation of Hodge structures** of weight `n` on a complex manifold
`B` is a family `V → B` of polarised Hodge structures of weight `n`,
satisfying Griffiths' transversality and the Hodge-Riemann positivity
conditions.

For our purposes (the Mumford–Tate reduction), we abstract just the
data structure we need:

* `B` : a base (a Shimura variety, or more generally a complex algebraic
  variety).
* For each `b : B`, a polarised Hodge structure on the fibre `V_b`.

This is enough to express the **period map** `φ : B → Γ\D` (where `D`
is the period domain) and the **Mumford–Tate group** `MT(b) ⊆ MT(V_b)`.

The full VHS theory (Griffiths transversality, Schmid's nilpotent orbit
theorem, etc.) is far beyond Lean's current state. We provide the
**carrier-level abstraction** here.

## Main definitions

* `VHSData B V n` : a typeclass providing a `B → PolarisedHodgeStructure`
  function (the family of polarised Hodge structures over `B`).

## Tags

variation of Hodge structures, VHS, Griffiths transversality, period map
-/

namespace HodgeReduction.Infrastructure.HodgeStructure

variable (B : Type*) (V : B → Type*) [∀ b, AddCommGroup (V b)] [∀ b, Module ℚ (V b)]

/-- A **variation of Hodge structures** on `B` with fibres `V_b`,
all of weight `n`.

We require: each fibre `V_b` carries a `PolarisedHodgeStructure V_b n`. -/
class VHSData (n : ℕ) where
  /-- Each fibre is equipped with a polarised Hodge structure of weight `n`. -/
  isPolarisedHodge : ∀ b : B, PolarisedHodgeStructure (V b) n

namespace VHSData

variable {B V} {n : ℕ} [VHSData B V n]

/-- The polarised Hodge structure on the fibre over `b`. -/
def fibreHodge (b : B) : PolarisedHodgeStructure (V b) n :=
  VHSData.isPolarisedHodge b

end VHSData

end HodgeReduction.Infrastructure.HodgeStructure
