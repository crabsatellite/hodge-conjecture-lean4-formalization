/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# Abelian varieties — abstract Hodge-theoretic data

An **abelian variety** `A` over a field `k` is a smooth projective
group variety over `k`. Its rational cohomology `H^*(A; ℚ)` is
`⋀^* H^1(A; ℚ)` (the exterior algebra on `H^1`), and each `H^{2p}(A)`
carries a Hodge structure of weight `2p`.

For our Mumford–Tate-reduction application, the relevant data is:

* `dim` : the complex dimension `dim_ℂ A = g`.
* `H1` : the rank-`2g` lattice `H^1(A; ℚ)` (with weight-1 Hodge structure).

From this, all `H^p(A; ℚ) = ⋀^p H^1(A; ℚ)` are determined.

We abstract the **carrier-level data** as a typeclass, just enough
to talk about the Hodge structure on `H^1`.

## Main definitions

* `AbelianVarietyHodgeData V` : a typeclass providing the H^1 Hodge
  structure of weight 1 on `V = H^1(A; ℚ)`.

## Tags

abelian variety, Hodge structure, exterior algebra, period domain
-/

namespace HodgeReduction.Infrastructure.AbelianVariety

variable (V : Type*) [AddCommGroup V] [Module ℚ V]

/-- The **Hodge data of an abelian variety** at the H^1 level:
`V = H^1(A; ℚ)` carries a polarised Hodge structure of weight 1.

The decomposition `V_ℂ = V^{1,0} ⊕ V^{0,1}` is the standard
"tangent-cotangent" splitting; both pieces have complex dimension `g`
(where `g = dim_ℂ A`). -/
class AbelianVarietyHodgeData where
  /-- The complex dimension of the abelian variety. -/
  g : ℕ
  /-- The polarised Hodge structure of weight 1 on `H^1`. -/
  hodgeOnH1 : HodgeReduction.Infrastructure.HodgeStructure.PolarisedHodgeStructure V 1

namespace AbelianVarietyHodgeData

variable {V} [AbelianVarietyHodgeData V]

/-- The dimension of the abelian variety as a complex variety. -/
abbrev complexDim : ℕ := g (V := V)

end AbelianVarietyHodgeData

end HodgeReduction.Infrastructure.AbelianVariety
