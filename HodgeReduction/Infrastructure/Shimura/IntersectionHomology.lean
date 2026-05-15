/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.Algebra.Module.Submodule.Basic
import Mathlib.Algebra.Order.Field.Rat
import Mathlib.Algebra.Module.LinearMap.Defs

/-!
# Intersection homology and the BBD–Saito IH-pullback

For a complex algebraic variety `X` (singular in general), the
**intersection cohomology** `IH^*(X; ℚ)` is a `ℚ`-cohomology theory
that agrees with `H^*` on smooth varieties and has Poincaré duality
even on singular varieties.

Key papers:
* Beilinson-Bernstein-Deligne (BBD) 1982: "Faisceaux Pervers".
* Saito 1988: mixed Hodge modules and the Hodge structure on IH.
* Goresky-MacPherson (GM) 1980: intersection cohomology original.

For our application (Shimura variety EVII + toroidal compactification):

* The intersection-cohomology pullback `IH^*(Š_Γ) → IH^*(S_Γ) = H^*(S_Γ)`
  preserves Hodge filtration (BBD 1982 + Saito 1988).
* The Freudenthal class `[q]` extends canonically along the
  IH-pullback.

This file abstracts the **carrier-level data** of the BBD-Saito IH
pullback for the EVII application.

## Main definitions

* `IntersectionHomologyData` : a typeclass carrying the IH-pullback
  data for a Shimura variety and its compactification.

## Tags

intersection cohomology, BBD, perverse sheaves, Saito, IH-pullback
-/

namespace HodgeReduction.Infrastructure.Shimura

/-- **Intersection-homology pullback data** for a Shimura variety
`S_Γ` and its toroidal compactification `Š_Γ`:

* `IH_compactification` : `ℚ`-vector space `IH^*(Š_Γ; ℚ)`.
* `IH_open` : `ℚ`-vector space `IH^*(S_Γ; ℚ) = H^*(S_Γ; ℚ)`.
* `pullback` : the BBD-Saito IH-pullback as a `ℚ`-linear map.

The key property of the pullback is **Hodge filtration preservation**:
the pullback is compatible with the Hodge structure on intersection
cohomology (Saito 1988 mixed Hodge modules). -/
structure IntersectionHomologyData
    (IH_compactification : Type*) (IH_open : Type*)
    [AddCommGroup IH_compactification] [Module ℚ IH_compactification]
    [AddCommGroup IH_open] [Module ℚ IH_open] where
  /-- The IH-pullback (a `ℚ`-linear map). -/
  pullback : IH_compactification →ₗ[ℚ] IH_open

end HodgeReduction.Infrastructure.Shimura
