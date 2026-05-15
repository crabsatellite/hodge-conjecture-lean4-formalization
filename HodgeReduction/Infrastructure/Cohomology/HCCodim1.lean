/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.HodgeCycle
import HodgeReduction.Infrastructure.Cohomology.NeronSeveri
import HodgeReduction.Infrastructure.Cohomology.Lefschetz

/-!
# Codimension-1 Hodge Conjecture (PROVABLE)

The **codimension-1 case of the Hodge Conjecture** is classically proven
(Lefschetz 1924, Hodge 1941): every rational (1,1)-class in `H²(X; ℚ)`
is the cohomology class of a divisor, hence algebraic.

In our framework, this is the bridge:
```
H^{1,1} class  →  NS(X)_ℚ class  →  algebraic class
```
where the first arrow is Lefschetz (1,1) (via `Lefschetz11Data`) and
the second is the `cycle class map` (via `NeronSeveriData`).

This file packages the codim-1 HC as a **proven theorem** of the
framework, depending only on:
* `Lefschetz11Data` (the classical Lefschetz (1,1) theorem)
* `HodgeCycleData` (the framework's Hodge subalgebra)

## Main theorem

`HC_codim_1`: every `(1,1)`-Hodge class is algebraic, in any
cohomology ring `A` with `Lefschetz11Data` and `HodgeCycleData`.

## Tags

Hodge conjecture, codim 1, Lefschetz (1,1), divisor algebraicity
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable {A : Type*} [CommRing A] [Algebra ℚ A] [CohomologyRing A]
    [Lefschetz11Data A]

/-- **Codimension-1 Hodge Conjecture** (Lefschetz (1,1) theorem):
every rational `(1,1)`-Hodge class is algebraic.

Proof: by `Lefschetz11Data.lefschetz_11` (the classical Lefschetz (1,1)
theorem packaged as a typeclass field axiom). -/
theorem HC_codim_1 {α : A} (hα : α ∈ Lefschetz11Data.H11) :
    CohomologyRing.IsAlgebraic α :=
  Lefschetz11Data.isAlgebraic_of_H11 hα

end HodgeReduction.Infrastructure.Cohomology
