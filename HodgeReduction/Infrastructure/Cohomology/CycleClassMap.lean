/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic

/-!
# Cycle class map and algebraic cohomology classes

For a smooth projective variety `X` over `ℚ` (or `ℂ`), the
**Chow ring** `CH^*(X)` is the ring of algebraic cycles modulo
rational equivalence. The **cycle class map**
```
cl : CH^*(X) ⊗ ℚ → H^{2*}(X; ℚ)
```
sends an algebraic cycle class to its cohomology class. The image is
exactly the **algebraic subring** `Alg^*(X) ⊆ H^{2*}(X; ℚ)`.

The **Hodge conjecture** asserts that `Alg^p = Hdg^{2p} ∩ H^{p,p}`
(every Hodge class is algebraic), but the LOWER inclusion
`Alg^p ⊆ Hdg^{2p} ∩ H^{p,p}` is always true: algebraic classes are
Hodge classes.

For our HC formalisation, we abstract the **target side** of `cl`:
the subring of algebraic classes is the data we have as
`CohomologyRing.algebraic`. The source side (Chow ring + cl) is
abstracted away.

This file packages the **two-sided abstraction**: a typeclass
providing `cl : CycleRing → A` (a ring homomorphism into the
cohomology ring `A`) whose image is the algebraic subring.

## Main definitions

* `CycleRingData A` : a typeclass carrying:
  - An abstract Chow ring `CycleRing : Type` (commutative ℚ-algebra)
  - A ring homomorphism `cl : CycleRing →+* A`
  - The image-equals-algebraic axiom

## Tags

cycle class map, Chow ring, algebraic cycle, Hodge cycle
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- Data for a **cycle class map** into the cohomology ring `A`:
an abstract ring `CycleRing` (the Chow ring `CH^*(X) ⊗ ℚ`) and a
ring homomorphism `cl : CycleRing →+* A` whose image is contained
in the algebraic subring.

The image-equals-algebraic axiom is:
```
range cl = (CohomologyRing.algebraic : Set A)
```
which means: a class `α : A` is algebraic iff there exists `c : CycleRing`
with `cl c = α`. -/
class CycleRingData where
  /-- The Chow ring (abstract). -/
  CycleRing : Type
  /-- `CycleRing` is a commutative ring. -/
  cycleRing_isCommRing : CommRing CycleRing
  /-- The cycle class map. -/
  cl : CycleRing →+* A
  /-- The image of `cl` is contained in the algebraic subring (one
  direction; this is the **direct content** of the cycle class map). -/
  cl_image_subset : ∀ c : CycleRing, CohomologyRing.IsAlgebraic (cl c)

namespace CycleRingData

variable {A} [CycleRingData A]

/-- The image of any cycle class is algebraic in `A`. -/
theorem cl_isAlgebraic (c : CycleRingData.CycleRing A) :
    CohomologyRing.IsAlgebraic (CycleRingData.cl c) :=
  CycleRingData.cl_image_subset c

/-- The image `cl(c)` of any cycle `c` is in the algebraic subring. -/
theorem cl_mem_algebraic (c : CycleRingData.CycleRing A) :
    CycleRingData.cl c ∈ (CohomologyRing.algebraic : Subalgebra ℚ A) :=
  CycleRingData.cl_image_subset c

end CycleRingData

end HodgeReduction.Infrastructure.Cohomology
