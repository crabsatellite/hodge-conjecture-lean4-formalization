/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.AbelianVariety.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised

/-!
# Polarised abelian variety framework

A **polarised abelian variety** `(A, λ)` is an abelian variety `A`
together with a polarisation `λ : A → Â` (an isogeny to its dual,
arising from an ample line bundle).

For our HC application, the EVII Shimura variety parameterises
abelian varieties (modulo finite covers) with extra structure:
* A polarisation of a specific type.
* An action of a CM field / quaternion algebra (the EVII-type
  structure).

This file extends `AbelianVarietyHodgeData` to include polarisation
data.

## Main definitions

* `PolarisedAbelianVarietyData V` : abelian variety with polarisation.

## Tags

polarised abelian variety, isogeny, dual abelian variety
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- **Polarised abelian variety data**:

* Inherits `AbelianVarietyHodgeData` (H¹ Hodge structure of weight 1).
* `polarisationType` : the abstract type of the polarisation
  (degree, partial CM type, etc.).

The polarisation gives `V = H¹(A; ℚ)` the symplectic structure
which appears in the polarised Hodge structure. -/
class PolarisedAbelianVarietyData extends AbelianVarietyHodgeData V where
  /-- Abstract polarisation type (e.g., principally polarised, or
  with CM type). -/
  polarisationType : Type

end HodgeReduction.Infrastructure.AbelianVariety
