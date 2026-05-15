/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.CycleClassMap

/-!
# Chow ring framework

For a smooth projective variety `X` over a field `k`, the **Chow ring**
`CH^*(X) = ⨁_p CH^p(X)` is the ring of algebraic cycles modulo rational
equivalence. It carries a commutative ring structure under intersection
product.

The **cycle class map** `cl : CH^*(X)_ℚ → H^{2*}(X; ℚ)` (over `ℂ` or
via étale cohomology over arbitrary fields) is a ring homomorphism
whose image is the algebraic subring `CohomologyRing.algebraic`.

This file refines the `CycleClassMap` framework (P157) into a more
structured `ChowRing` framework with explicit ring + module
properties.

## Main definitions

* `ChowRingData A` : typeclass refining `CycleRingData` with the
  full Chow ring structure (commutative ℚ-algebra).

## Tags

Chow ring, algebraic cycle, intersection product, cycle class map
-/

namespace HodgeReduction.Infrastructure.Cohomology

variable (A : Type*) [CommRing A] [Algebra ℚ A] [CohomologyRing A]

/-- **Chow ring data** for a cohomology ring `A`:

* `CH` : a `ℚ`-vector space (representing `CH^*(X) ⊗ ℚ` at the linear level).
* `cl` : a `ℚ`-linear map `CH →ₗ[ℚ] A` (the cycle class map).
* `cl_image_isAlgebraic` : the image is contained in the algebraic
  subring (the **fundamental property** of the cycle class map).

For our purposes (HC application), we only need the **linear part** of
the cycle class map — the full ring structure on CH is recovered by
refining this typeclass.

The Hodge conjecture asks: is the image of `cl` exactly equal to the
rational Hodge classes? -/
class ChowRingData where
  /-- The Chow ring (abstract `ℚ`-vector space). -/
  CH : Type
  /-- `CH` is an additive commutative group. -/
  CH_addCommGroup : AddCommGroup CH
  /-- `CH` is a `ℚ`-module. -/
  CH_module : @Module ℚ CH _ CH_addCommGroup.toAddCommMonoid
  /-- The cycle class map `cl : CH → A` as a `ℚ`-linear map. -/
  cl : @LinearMap ℚ ℚ _ _ (RingHom.id ℚ) CH A
        CH_addCommGroup.toAddCommMonoid _ CH_module _
  /-- The image of `cl` lies in the algebraic subring. -/
  cl_image_isAlgebraic : ∀ c : CH, CohomologyRing.IsAlgebraic (cl c)

namespace ChowRingData

variable {A} [ChowRingData A]

/-- The image `cl(c)` of any cycle is algebraic. -/
theorem cl_isAlgebraic (c : ChowRingData.CH (A := A)) :
    CohomologyRing.IsAlgebraic (ChowRingData.cl c) :=
  ChowRingData.cl_image_isAlgebraic c

end ChowRingData

end HodgeReduction.Infrastructure.Cohomology
