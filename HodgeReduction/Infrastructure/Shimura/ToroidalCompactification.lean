/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Shimura.Basic

/-!
# Toroidal compactification framework

For a non-compact Shimura variety `S_Γ = Γ \ X`, the **toroidal
compactification** `S_Γ^{tor}` is a smooth projective variety
compactifying `S_Γ` by adding toric boundary strata (AMRT 1975 +
Mumford 1972).

The toroidal compactification depends on a choice of rational
polyhedral cone decomposition `Σ` of the boundary; different choices
give birationally equivalent compactifications.

For our HC application:
* Mumford 1977 canonical extension uses `S_Γ^{tor}`.
* Burgos-Kramer-Kühn 2007 log-log automorphic forms extend to
  `S_Γ^{tor}`.
* Hirzebruch-Mumford proportionality is on `S_Γ^{tor}`.

This file packages **abstract toroidal compactification data**.

## Main definitions

* `ToroidalCompactificationData` : the abstract compactification.

## Tags

toroidal compactification, AMRT 1975, Mumford 1972, boundary stratum
-/

namespace HodgeReduction.Infrastructure.Shimura

variable (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A]

/-- **Toroidal compactification data** for a Shimura variety:

* `dim` : the dimension of `S_Γ^{tor}` (= dim S_Γ).
* `boundaryCodim` : the (complex) codimension of the boundary
  divisor `D_∞ = S_Γ^{tor} \ S_Γ`.

For EVII: `dim = 27`, `boundaryCodim = 1` (the boundary is a divisor). -/
class ToroidalCompactificationData where
  /-- Complex dimension of the compactification. -/
  dim : ℕ
  /-- Codimension of the boundary divisor. -/
  boundaryCodim : ℕ

end HodgeReduction.Infrastructure.Shimura
