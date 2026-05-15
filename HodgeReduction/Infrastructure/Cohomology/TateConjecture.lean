/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat

/-!
# Tate conjecture framework

The **Tate conjecture** (Tate 1965, ICM Stockholm) is the `ℓ`-adic
étale analog of the Hodge conjecture:

For `X` smooth projective over a finitely-generated field `k` and prime
`ℓ ≠ char(k)`:
```
(Tate)_p : the cycle class map CH^p(X)_ℚ_ℓ → H²ᵖ_ét(X_{k̄}; ℚ_ℓ(p))^{Gal(k̄/k)}
           is SURJECTIVE.
```

Tate conjecture implies Hodge conjecture for varieties over number
fields (under Deligne's "absolute Hodge cycles" formalism).

For our HC application: the Tate conjecture provides a parallel
characterisation of algebraic cycles using Galois invariants instead
of Hodge type.

This file packages **abstract Tate conjecture statement**.

## Main definitions

* `TateConjectureData` : abstract Tate-conjecture data.

## Tags

Tate conjecture, ℓ-adic cohomology, Galois invariant, ICM Stockholm 1965
-/

namespace HodgeReduction.Infrastructure.Cohomology

/-- **Tate conjecture data** (abstract):

* `ell` : the prime ℓ.
* `tate_conj` : the Tate conjecture statement (as a Prop). -/
class TateConjectureData where
  /-- The prime ℓ. -/
  ell : ℕ
  /-- The Tate conjecture statement. -/
  tate_conj : Prop

end HodgeReduction.Infrastructure.Cohomology
