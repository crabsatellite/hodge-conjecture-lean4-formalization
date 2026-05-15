/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.Lefschetz
import HodgeReduction.Infrastructure.Cohomology.HodgeCycle

/-!
# Néron–Severi group framework

For a smooth projective complex variety `X`, the **Néron–Severi group**
is `NS(X) := Pic(X) / Pic^0(X)`, a finitely-generated abelian group.
Its rational version `NS(X)_ℚ ⊆ H²(X; ℚ)` consists of the algebraic
classes of codimension 1 (= divisor classes modulo numerical/algebraic
equivalence).

By the **Lefschetz (1,1) theorem** (Lefschetz 1924, Hodge 1941):
```
NS(X)_ℚ = H^{1,1}(X; ℝ) ∩ H²(X; ℚ).
```

That is, every rational `(1,1)`-class is in `NS(X)_ℚ`, i.e., comes
from a divisor (equivalently, is in the image of `c_1 : Pic(X)_ℚ →
H²(X; ℚ)`).

For our HC application, this gives the **codimension-1 case of HC**
as a proven classical result.

## Main definitions

* `NeronSeveriData A` : typeclass packaging the Néron-Severi
  rational sub-vector space `NS_ℚ ⊆ A` and the Lefschetz (1,1)
  identification.

## Tags

Néron-Severi group, divisor class, Lefschetz (1,1) theorem,
Picard group, HC codim 1
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Néron–Severi data** for a cohomology ring `A`:

The rational Néron-Severi subspace `NS_ℚ ⊆ A` is a `ℚ`-vector subspace
containing the algebraic codim-1 classes. By the Lefschetz (1,1)
theorem, this equals the rational `(1, 1)`-Hodge classes in `H²`.

We capture this as a typeclass with:
* `NS_rat` : the `ℚ`-submodule of `NS(X)_ℚ` inside `A`.
* `NS_rat_le_algebraic` : NS_ℚ classes are all algebraic
  (cycle-class-map / Lefschetz (1,1) input). -/
class NeronSeveriData where
  /-- The rational Néron-Severi subspace `NS(X)_ℚ ⊆ A`. -/
  NS_rat : Submodule ℚ A
  /-- Every NS-rational class is algebraic (the **codim-1 case of HC**,
  proven classically via Lefschetz (1,1)). -/
  NS_rat_le_algebraic :
    ∀ α ∈ NS_rat, CohomologyRing.IsAlgebraic α

namespace NeronSeveriData

variable {A} [NeronSeveriData A]

/-- Every NS-rational class is algebraic (Lefschetz (1,1)). -/
theorem isAlgebraic_of_NS_rat {α : A} (hα : α ∈ NS_rat (A := A)) :
    CohomologyRing.IsAlgebraic α :=
  NS_rat_le_algebraic α hα

end NeronSeveriData

/-! ### Bridge: Lefschetz (1,1) data → Néron-Severi data

If `A` has `Lefschetz11Data`, then we get `NeronSeveriData` by setting
`NS_rat := H^{1,1}` (the (1,1)-piece of the Hodge bigrading on H²). -/

variable [Lefschetz11Data A]

/-- **Bridge**: Lefschetz (1,1) data gives Néron-Severi data.

We take `NS_rat := H^{1,1}` (the (1,1)-Hodge piece). The algebraicity
of `NS_rat` follows from the Lefschetz (1,1) field axiom. -/
def NeronSeveriOfLefschetz11 : NeronSeveriData A where
  NS_rat := Lefschetz11Data.H11
  NS_rat_le_algebraic := Lefschetz11Data.lefschetz_11

end HodgeReduction.Infrastructure.Cohomology
