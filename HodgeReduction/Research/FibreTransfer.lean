/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# Fibre-transfer status for the E7 scope bridge

Master tex labels: `open:fibre-id`, `prop:deligne-splitting`,
`cor:quartic-algebraic`.

The master paper distinguishes three statements:

* Shimura-side Chern classes are algebraic.
* Pulling them back along the period map gives base-level algebraic classes.
* Algebraicity of individual fibre classes is a separate input, supplied only
  conditionally by BBT spreading plus the H-bundle/AH-CM-E7 package.

This file formalizes that dependency shape and the non-implication behind the
fibre-identification gap.  It does not formalize BBT, Chern-Weil theory,
Andres motivated cycles, or the algebraic geometry of Shimura varieties.
-/

namespace HodgeReduction

/-- Abstract dependency shape for the fibre-identification problem. -/
structure FibreTransferData where
  shimuraSideAlgebraic : Prop
  periodMapAlgebraic : Prop
  baseLevelAlgebraic : Prop
  bbtSpreadingInput : Prop
  hBundleCycleSeeding : Prop
  ahCmE7Input : Prop
  fibreLevelAlgebraic : Prop
  shimura_to_base :
    shimuraSideAlgebraic ->
      periodMapAlgebraic ->
        baseLevelAlgebraic
  bbt_hbundle_to_fibre :
    bbtSpreadingInput ->
      hBundleCycleSeeding ->
        ahCmE7Input ->
          fibreLevelAlgebraic

namespace FibreTransferData

/-- Shimura-side algebraicity plus algebraicity of the period map gives only
the base-level statement. -/
theorem base_level_algebraicity_from_shimura_side
    (D : FibreTransferData)
    (hShimura : D.shimuraSideAlgebraic)
    (hPeriod : D.periodMapAlgebraic) :
    D.baseLevelAlgebraic :=
  D.shimura_to_base hShimura hPeriod

/-- Fibre-level algebraicity follows once the independent BBT/H-bundle/AH
package is supplied. -/
theorem fibre_level_algebraicity_from_bbt_spreading_inputs
    (D : FibreTransferData)
    (hBBT : D.bbtSpreadingInput)
    (hHBundle : D.hBundleCycleSeeding)
    (hAH : D.ahCmE7Input) :
    D.fibreLevelAlgebraic :=
  D.bbt_hbundle_to_fibre hBBT hHBundle hAH

end FibreTransferData

/-- A model of the paper's fibre-transfer warning: the Shimura-side and
period-map facts can both hold while the fibre-level conclusion is absent. -/
def fibreTransferGapCountermodel : FibreTransferData where
  shimuraSideAlgebraic := True
  periodMapAlgebraic := True
  baseLevelAlgebraic := True
  bbtSpreadingInput := False
  hBundleCycleSeeding := False
  ahCmE7Input := False
  fibreLevelAlgebraic := False
  shimura_to_base := fun _ _ => trivial
  bbt_hbundle_to_fibre := fun hBBT _ _ => False.elim hBBT

/--
Shimura-side algebraicity and an algebraic period map do not by themselves
close fibre-level algebraicity.
-/
theorem shimura_side_and_period_map_do_not_self_close_fibre_algebraicity :
    Not
      (forall D : FibreTransferData,
        D.shimuraSideAlgebraic ->
          D.periodMapAlgebraic ->
            D.fibreLevelAlgebraic) := by
  intro h
  exact h fibreTransferGapCountermodel trivial trivial

/--
Abstract split of E7-invariant fibre classes used in
`cor:quartic-algebraic`.

The H3-derived component is separated from Chern/Lefschetz classes because
the paper treats it as the component that needs the BBT/H-bundle route or a
separate algebraicity theorem.
-/
structure E7FibreInvariantClassSplitData where
  chernLefschetzClassesAlgebraic : Prop
  h3DerivedClassesMotivated : Prop
  h3DerivedClassesAlgebraic : Prop
  mixedProductsAlgebraic : Prop
  allInvariantClassesAlgebraic : Prop
  mixed_from_h3 :
    h3DerivedClassesAlgebraic ->
      mixedProductsAlgebraic
  all_from_components :
    chernLefschetzClassesAlgebraic ->
      h3DerivedClassesAlgebraic ->
        mixedProductsAlgebraic ->
          allInvariantClassesAlgebraic

namespace E7FibreInvariantClassSplitData

/-- Once the H3-derived component is algebraic, the fibre-class split gives
algebraicity of all invariant classes. -/
theorem all_invariant_classes_from_h3_algebraicity
    (D : E7FibreInvariantClassSplitData)
    (hChern : D.chernLefschetzClassesAlgebraic)
    (hH3 : D.h3DerivedClassesAlgebraic) :
    D.allInvariantClassesAlgebraic :=
  D.all_from_components hChern hH3 (D.mixed_from_h3 hH3)

end E7FibreInvariantClassSplitData

/-- Motivatedness of the H3-derived class is not, in the current interface,
itself an algebraicity proof. -/
def motivatedButNotAlgebraicCountermodel : E7FibreInvariantClassSplitData where
  chernLefschetzClassesAlgebraic := True
  h3DerivedClassesMotivated := True
  h3DerivedClassesAlgebraic := False
  mixedProductsAlgebraic := False
  allInvariantClassesAlgebraic := False
  mixed_from_h3 := fun hH3 => False.elim hH3
  all_from_components := fun _ hH3 _ => False.elim hH3

/--
The paper's motivated-cycle observation does not self-close algebraicity for
non-abelian E7-type fibres without an additional algebraicity input.
-/
theorem motivated_h3_class_does_not_self_close_algebraicity :
    Not
      (forall D : E7FibreInvariantClassSplitData,
        D.h3DerivedClassesMotivated ->
          D.h3DerivedClassesAlgebraic) := by
  intro h
  exact h motivatedButNotAlgebraicCountermodel trivial

end HodgeReduction
