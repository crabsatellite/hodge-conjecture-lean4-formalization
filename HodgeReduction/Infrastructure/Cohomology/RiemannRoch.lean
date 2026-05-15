/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernCharacter

/-!
# Grothendieck-Riemann-Roch framework

The **Grothendieck-Riemann-Roch theorem** (GRR): for a proper morphism
`f : X → Y` of smooth varieties and a vector bundle `V → X`,

```
ch(f_*V) · Td(Y) = f_*(ch(V) · Td(X))
```

where `Td` is the Todd class.

The classical Hirzebruch-Riemann-Roch (HRR) is the case `Y = pt`:
```
χ(X, V) = ∫_X ch(V) · Td(X)
```

For our HC application: HRR/GRR computations give specific polynomial
identities in Chern classes (like the P57 polynomial identity for the
Freudenthal class).

This file packages **abstract Riemann-Roch data**.

## Main definitions

* `RiemannRochData A` : Todd class for the cohomology ring.

## Tags

Riemann-Roch, Grothendieck-Riemann-Roch, Todd class, HRR
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Riemann-Roch / Todd class data**:

* `todd` : the Todd class of the tangent bundle (a specific element
  in the cohomology ring).
* `dim` : complex dimension of the variety. -/
class RiemannRochData where
  /-- The Todd class `Td(X) ∈ A`. -/
  todd : A
  /-- Complex dimension `n` of `X`. -/
  dim : ℕ

end HodgeReduction.Infrastructure.Cohomology
