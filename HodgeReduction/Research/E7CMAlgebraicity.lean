/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# E7 CM-fibre absolute Hodge and algebraicity

Master tex labels: `hyp:AH-CM-E7`, `lem:CM-E7-algebraicity`.

The master paper treats the following as separate obligations:

* Deligne's theorem for abelian varieties and Andre's motivated-cycle
  framework live on the abelian span.
* The non-abelian `E_7` CM-fibre absolute-Hodge extension is an independent
  labelled hypothesis.
* Algebraicity at an `E_7` CM fibre still needs the cycle-level H-bundle
  realisation; absolute-Hodge status alone is not a Chow cycle.

This file formalizes that dependency shape and the two non-implications that
keep the paper's conditional narrative honest.  It does not prove Deligne's
absolute-Hodge theorem, Andre's theorem, the non-abelian `E_7` extension, or
the H-bundle cycle-seeding theorem.
-/

namespace HodgeReduction

/--
Abstract dependency shape for `hyp:AH-CM-E7` and the CM-fibre algebraicity
consumer `lem:CM-E7-algebraicity`.

The abelian frameworks are recorded separately from the non-abelian E7
extension because the master paper explicitly states that Deligne's abelian
absolute-Hodge theorem does not by itself cover non-abelian E7 Shimura data.
-/
structure E7CMAlgebraicityData where
  deligneAbelianAbsoluteHodgeFramework : Prop
  andreAbelianMotivatedSpan : Prop
  nonAbelianE7CMFibre : Prop
  e7InvariantClassAtOperativeCodim : Prop
  nonAbelianE7AbsoluteHodgeExtension : Prop
  e7InvariantClassAbsoluteHodge : Prop
  hBundleCycleSeeding : Prop
  e7InvariantClassAlgebraic : Prop
  absolute_hodge_from_nonabelian_extension :
    nonAbelianE7CMFibre ->
      e7InvariantClassAtOperativeCodim ->
        nonAbelianE7AbsoluteHodgeExtension ->
          e7InvariantClassAbsoluteHodge
  algebraic_from_absolute_hodge_and_hbundle :
    e7InvariantClassAbsoluteHodge ->
      hBundleCycleSeeding ->
        e7InvariantClassAlgebraic

namespace E7CMAlgebraicityData

/-- The `AH-CM-E7` consumer: once the non-abelian E7 extension is supplied,
an E7-invariant class at the operative codimensions is absolute Hodge. -/
theorem absolute_hodge_from_nonabelian_e7_extension
    (D : E7CMAlgebraicityData)
    (hCM : D.nonAbelianE7CMFibre)
    (hClass : D.e7InvariantClassAtOperativeCodim)
    (hExtension : D.nonAbelianE7AbsoluteHodgeExtension) :
    D.e7InvariantClassAbsoluteHodge :=
  D.absolute_hodge_from_nonabelian_extension hCM hClass hExtension

/-- The CM-fibre algebraicity consumer used by `lem:CM-E7-algebraicity`:
absolute-Hodge status must be paired with H-bundle cycle seeding. -/
theorem cm_e7_algebraicity_from_absolute_hodge_and_hbundle
    (D : E7CMAlgebraicityData)
    (hAH : D.e7InvariantClassAbsoluteHodge)
    (hHBundle : D.hBundleCycleSeeding) :
    D.e7InvariantClassAlgebraic :=
  D.algebraic_from_absolute_hodge_and_hbundle hAH hHBundle

/-- Full composition: the non-abelian AH extension plus H-bundle cycle seeding
gives algebraicity at the E7 CM fibre. -/
theorem cm_e7_algebraicity_from_full_package
    (D : E7CMAlgebraicityData)
    (hCM : D.nonAbelianE7CMFibre)
    (hClass : D.e7InvariantClassAtOperativeCodim)
    (hExtension : D.nonAbelianE7AbsoluteHodgeExtension)
    (hHBundle : D.hBundleCycleSeeding) :
    D.e7InvariantClassAlgebraic :=
  D.cm_e7_algebraicity_from_absolute_hodge_and_hbundle
    (D.absolute_hodge_from_nonabelian_e7_extension hCM hClass hExtension)
    hHBundle

end E7CMAlgebraicityData

/-- A model in which the abelian absolute-Hodge frameworks hold but the
non-abelian E7 extension and the desired absolute-Hodge conclusion do not. -/
def abelianFrameworksNoE7AHCountermodel : E7CMAlgebraicityData where
  deligneAbelianAbsoluteHodgeFramework := True
  andreAbelianMotivatedSpan := True
  nonAbelianE7CMFibre := True
  e7InvariantClassAtOperativeCodim := True
  nonAbelianE7AbsoluteHodgeExtension := False
  e7InvariantClassAbsoluteHodge := False
  hBundleCycleSeeding := False
  e7InvariantClassAlgebraic := False
  absolute_hodge_from_nonabelian_extension := fun _ _ hExtension => False.elim hExtension
  algebraic_from_absolute_hodge_and_hbundle := fun hAH _ => False.elim hAH

/--
Deligne's abelian absolute-Hodge theorem plus the Andre abelian-span framework
does not by itself close `AH-CM-E7` for non-abelian E7 CM fibres.
-/
theorem abelian_frameworks_do_not_self_close_nonabelian_e7_absolute_hodge :
    Not
      (forall D : E7CMAlgebraicityData,
        D.deligneAbelianAbsoluteHodgeFramework ->
          D.andreAbelianMotivatedSpan ->
            D.nonAbelianE7CMFibre ->
              D.e7InvariantClassAtOperativeCodim ->
                D.e7InvariantClassAbsoluteHodge) := by
  intro h
  exact h abelianFrameworksNoE7AHCountermodel trivial trivial trivial trivial

/-- A model in which the E7 class is absolute Hodge, but no H-bundle
cycle-seeding input is available and the algebraicity conclusion is absent. -/
def absoluteHodgeNoHBundleCountermodel : E7CMAlgebraicityData where
  deligneAbelianAbsoluteHodgeFramework := True
  andreAbelianMotivatedSpan := True
  nonAbelianE7CMFibre := True
  e7InvariantClassAtOperativeCodim := True
  nonAbelianE7AbsoluteHodgeExtension := True
  e7InvariantClassAbsoluteHodge := True
  hBundleCycleSeeding := False
  e7InvariantClassAlgebraic := False
  absolute_hodge_from_nonabelian_extension := fun _ _ _ => trivial
  algebraic_from_absolute_hodge_and_hbundle := fun _ hHBundle => False.elim hHBundle

/--
Absolute-Hodge status alone does not close algebraicity for non-abelian E7
CM fibres in the current paper interface; the H-bundle cycle input is
load-bearing.
-/
theorem absolute_hodge_does_not_self_close_cm_e7_algebraicity :
    Not
      (forall D : E7CMAlgebraicityData,
        D.e7InvariantClassAbsoluteHodge ->
          D.e7InvariantClassAlgebraic) := by
  intro h
  exact h absoluteHodgeNoHBundleCountermodel trivial

end HodgeReduction
