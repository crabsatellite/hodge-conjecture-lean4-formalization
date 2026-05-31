/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# CM fibre-density dependency shape

Master tex label: `prop:shimura-fibre-density`.

The master paper uses CM-density / Andre--Oort input together with either a
dominant period-map route or a weakly-special fallback to obtain density of CM
fibres in the E7-type family.  This file formalizes only that dependency
shape.  It does not port Andre--Oort, period-map dominance, or weakly-special
geometry to Lean.
-/

namespace HodgeReduction

/--
Abstract dependency shape for the CM-fibre-density step.

The fields separate the published/arithmetic input from the geometric
transport step.  This keeps the master-paper claim represented in Lean without
silently treating external density theorems as kernel proofs.
-/
structure CMFibreDensityData where
  cmDenseOnShimuraSide : Prop
  periodMapDominant : Prop
  weaklySpecialFallback : Prop
  cmDenseInE7Family : Prop
  density_from_dominant_period_map :
    cmDenseOnShimuraSide ->
      periodMapDominant ->
        cmDenseInE7Family
  density_from_weakly_special_fallback :
    cmDenseOnShimuraSide ->
      weaklySpecialFallback ->
        cmDenseInE7Family

namespace CMFibreDensityData

/-- The direct dominant-period-map consumer for the master-paper density step. -/
theorem density_from_dominance
    (D : CMFibreDensityData)
    (hCM : D.cmDenseOnShimuraSide)
    (hDominant : D.periodMapDominant) :
    D.cmDenseInE7Family :=
  D.density_from_dominant_period_map hCM hDominant

/-- The weakly-special fallback consumer for the master-paper density step. -/
theorem density_from_weakly_special
    (D : CMFibreDensityData)
    (hCM : D.cmDenseOnShimuraSide)
    (hFallback : D.weaklySpecialFallback) :
    D.cmDenseInE7Family :=
  D.density_from_weakly_special_fallback hCM hFallback

/--
The kernel-checked dependency composition: CM density on the Shimura side gives
E7-family CM-fibre density only after one of the two geometric transport routes
is supplied.
-/
theorem shimura_fibre_density_from_transport
    (D : CMFibreDensityData)
    (hCM : D.cmDenseOnShimuraSide)
    (hTransport : D.periodMapDominant ∨ D.weaklySpecialFallback) :
    D.cmDenseInE7Family := by
  cases hTransport with
  | inl hDominant => exact D.density_from_dominance hCM hDominant
  | inr hFallback => exact D.density_from_weakly_special hCM hFallback

end CMFibreDensityData

/-- A minimal model showing why CM density alone is not the E7-family density
statement used by the master paper. -/
def cmFibreDensityMissingTransportCountermodel : CMFibreDensityData where
  cmDenseOnShimuraSide := True
  periodMapDominant := False
  weaklySpecialFallback := False
  cmDenseInE7Family := False
  density_from_dominant_period_map := fun _ hDominant => False.elim hDominant
  density_from_weakly_special_fallback := fun _ hFallback => False.elim hFallback

/--
CM density on the Shimura side does not by itself close density in the E7-type
family; the dominant-period-map or weakly-special transport input is genuinely
load-bearing in the current interface.
-/
theorem cm_density_alone_does_not_force_e7_family_density :
    Not
      (forall D : CMFibreDensityData,
        D.cmDenseOnShimuraSide ->
          D.cmDenseInE7Family) := by
  intro h
  exact h cmFibreDensityMissingTransportCountermodel trivial

end HodgeReduction
