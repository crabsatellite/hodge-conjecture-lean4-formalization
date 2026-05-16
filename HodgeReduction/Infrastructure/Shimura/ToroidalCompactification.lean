/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.Infrastructure.Shimura.Basic
import HodgeReduction.Infrastructure.Cohomology.Basic
import Mathlib.Algebra.Module.Submodule.Basic

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
class ToroidalCompactificationData (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A] where
  /-- Complex dimension of the compactification. -/
  dim : ℕ
  /-- Codimension of the boundary divisor. -/
  boundaryCodim : ℕ

/-- **EVII boundary classification data** — for the EVII Shimura variety
`S_Γ = Γ \ E_{7(-25)} / (E_6 × U(1))`, the codim-1 boundary stratum of
the toroidal compactification `S_Γ^{tor}` is classified as the EIII
Hermitian symmetric domain (associated to the parabolic stabiliser of an
isotropic line; the boundary component is the moduli of polarised Hodge
structures of EIII type, i.e. `E_6 / (Spin(10) × U(1))`).

References:
* J. Wolf, *Spaces of Constant Curvature*, McGraw-Hill 1972 — full
  classification of Hermitian symmetric pairs and their parabolic
  boundary strata.
* I. Satake, *Algebraic Structures of Symmetric Domains*, Iwanami 1980 —
  rational boundary components of bounded symmetric domains.
* A. Borel, L. Ji, *Compactifications of Symmetric and Locally Symmetric
  Spaces*, Birkhäuser 2006 §III.4-5 — boundary stratification of locally
  symmetric varieties.

The typeclass `EVIIBoundaryClassificationData A` enriches a cohomology
ring `A` with two designated submodules and a witness equating them:

* `boundary_codim1_stratum_class` : the cohomology image of the codim-1
  boundary stratum inside `A`.
* `eiii_hermitian_symmetric_class` : the cohomology image of the EIII
  Hermitian symmetric domain inside `A` (via the standard identification
  of its compact dual cohomology).
* `boundary_codim1_eq_eiii` : the published classification fact that
  these two submodules coincide. -/
class EVIIBoundaryClassificationData
    (A : Type*) [CommRing A] [Algebra ℚ A]
    [HodgeReduction.Infrastructure.Cohomology.CohomologyRing A] where
  /-- The cohomology image of the codim-1 boundary stratum of `S_Γ^{tor}`
  (for EVII) inside the ambient cohomology ring `A`. -/
  boundary_codim1_stratum_class : Submodule ℚ A
  /-- The cohomology image of the EIII Hermitian symmetric domain
  `E_6 / (Spin(10) × U(1))` inside `A`. -/
  eiii_hermitian_symmetric_class : Submodule ℚ A
  /-- **Wolf 1972 / Satake 1980 / Borel-Ji 2006** — the codim-1 boundary
  stratum of EVII's toroidal compactification IS the EIII Hermitian
  symmetric domain. -/
  boundary_codim1_eq_eiii :
    boundary_codim1_stratum_class = eiii_hermitian_symmetric_class

end HodgeReduction.Infrastructure.Shimura
