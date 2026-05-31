/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# E7 BBT spreading and non-rigidity bridge status

Master tex labels: `hyp:BBT-rigid-reach`,
`hyp:nonrigid-family-bridge`, and `thm:E7-BBT-spreading`.

The master paper separates three statements that are easy to conflate:

* ordinary BBT/o-minimal framework inputs and CM-density data;
* the extra cycle-level reach from CM points to rigid isolated points;
* the bridge from fibre-level non-rigidity to a family with a generically
  finite, dominant period map.

This file records only that dependency shape and the corresponding
non-implications.  It does not formalize BBT, Hilbert schemes, Kuranishi
families, period maps, or algebraic cycles.
-/

namespace HodgeReduction

/-- Dependency shape for `hyp:BBT-rigid-reach`. -/
structure BBTRigidReachData where
  cdkHodgeLocusAlgebraicity : Prop
  bktBbtDefinableGaga : Prop
  andreOortCmDensity : Prop
  cyclesAtCmPoints : Prop
  positiveDimensionalSpreading : Prop
  rigidIsolatedLimitExtension : Prop
  rigidIsolatedCycles : Prop
  rigid_from_full_package :
    cdkHodgeLocusAlgebraicity ->
      bktBbtDefinableGaga ->
        andreOortCmDensity ->
          cyclesAtCmPoints ->
            rigidIsolatedLimitExtension ->
              rigidIsolatedCycles

namespace BBTRigidReachData

/-- Rigid isolated-point reach follows only after the isolated-limit extension
input is supplied in addition to the BBT/CM framework package. -/
theorem rigid_isolated_reach_from_full_package
    (D : BBTRigidReachData)
    (hCDK : D.cdkHodgeLocusAlgebraicity)
    (hBBT : D.bktBbtDefinableGaga)
    (hCM : D.andreOortCmDensity)
    (hCycles : D.cyclesAtCmPoints)
    (hLimit : D.rigidIsolatedLimitExtension) :
    D.rigidIsolatedCycles :=
  D.rigid_from_full_package hCDK hBBT hCM hCycles hLimit

end BBTRigidReachData

/-- A model in which the BBT/CM framework is present but the rigid isolated
limit extension is absent. -/
def bbtRigidNoLimitCountermodel : BBTRigidReachData where
  cdkHodgeLocusAlgebraicity := True
  bktBbtDefinableGaga := True
  andreOortCmDensity := True
  cyclesAtCmPoints := True
  positiveDimensionalSpreading := True
  rigidIsolatedLimitExtension := False
  rigidIsolatedCycles := False
  rigid_from_full_package := fun _ _ _ _ hLimit => False.elim hLimit

/-- BBT/CM framework inputs and CM-point cycles do not by themselves close
the rigid isolated-point reach hypothesis. -/
theorem bbt_frameworks_do_not_self_close_rigid_isolated_reach :
    Not
      (forall D : BBTRigidReachData,
        D.cdkHodgeLocusAlgebraicity ->
          D.bktBbtDefinableGaga ->
            D.andreOortCmDensity ->
              D.cyclesAtCmPoints ->
                D.rigidIsolatedCycles) := by
  intro h
  exact h bbtRigidNoLimitCountermodel trivial trivial trivial trivial

/-- Dependency shape for `hyp:nonrigid-family-bridge`. -/
structure NonRigidFamilyBridgeData where
  fibrewiseNonRigid : Prop
  kuranishiFamilyExists : Prop
  fibreIsoAtBase : Prop
  periodMapGenericallyFinite : Prop
  periodMapDominant : Prop
  baseDimensionTwentySeven : Prop
  familyBridge : Prop
  base_dim_from_period_package :
    periodMapGenericallyFinite ->
      periodMapDominant ->
        baseDimensionTwentySeven
  bridge_from_period_package :
    fibrewiseNonRigid ->
      kuranishiFamilyExists ->
        fibreIsoAtBase ->
          periodMapGenericallyFinite ->
            periodMapDominant ->
              familyBridge

namespace NonRigidFamilyBridgeData

/-- Once the generically-finite and dominant period-map package is supplied,
the base-dimension statement follows in the abstract bridge interface. -/
theorem base_dimension_from_period_package
    (D : NonRigidFamilyBridgeData)
    (hFinite : D.periodMapGenericallyFinite)
    (hDominant : D.periodMapDominant) :
    D.baseDimensionTwentySeven :=
  D.base_dim_from_period_package hFinite hDominant

/-- The non-rigid family bridge consumes more than fibre-level non-rigidity:
it also needs a family witness, fibre identification, and the two period-map
properties. -/
theorem nonrigid_family_bridge_from_full_period_package
    (D : NonRigidFamilyBridgeData)
    (hNonRigid : D.fibrewiseNonRigid)
    (hFamily : D.kuranishiFamilyExists)
    (hFibre : D.fibreIsoAtBase)
    (hFinite : D.periodMapGenericallyFinite)
    (hDominant : D.periodMapDominant) :
    D.familyBridge :=
  D.bridge_from_period_package hNonRigid hFamily hFibre hFinite hDominant

end NonRigidFamilyBridgeData

/-- A model in which a non-rigid deformation family exists, but the required
generically-finite and dominant period-map package is absent. -/
def nonRigidNoPeriodPackageCountermodel : NonRigidFamilyBridgeData where
  fibrewiseNonRigid := True
  kuranishiFamilyExists := True
  fibreIsoAtBase := True
  periodMapGenericallyFinite := False
  periodMapDominant := False
  baseDimensionTwentySeven := False
  familyBridge := False
  base_dim_from_period_package := fun hFinite _ => False.elim hFinite
  bridge_from_period_package := fun _ _ _ hFinite _ => False.elim hFinite

/-- Fibre-level non-rigidity plus a local deformation family does not by
itself close the period-map family bridge. -/
theorem nonrigidity_does_not_self_close_period_family_bridge :
    Not
      (forall D : NonRigidFamilyBridgeData,
        D.fibrewiseNonRigid ->
          D.kuranishiFamilyExists ->
            D.fibreIsoAtBase ->
              D.familyBridge) := by
  intro h
  exact h nonRigidNoPeriodPackageCountermodel trivial trivial trivial

/-- Dependency shape for the conditional `thm:E7-BBT-spreading`. -/
structure E7BBTSpreadingData where
  bbtCoherence : Prop
  cmFibreDensity : Prop
  weaklySpecialInputs : Prop
  hBundleAlgebraicity : Prop
  hBundleCycleSeeding : Prop
  ahCmE7Input : Prop
  familyLevelE7Spreading : Prop
  bbtRigidReachInput : Prop
  nonrigidFamilyBridgeInput : Prop
  individualE7ScopeTransfer : Prop
  family_spreading_from_full_package :
    bbtCoherence ->
      cmFibreDensity ->
        weaklySpecialInputs ->
          hBundleAlgebraicity ->
            hBundleCycleSeeding ->
              ahCmE7Input ->
                familyLevelE7Spreading
  individual_scope_from_family_and_bridges :
    familyLevelE7Spreading ->
      bbtRigidReachInput ->
        nonrigidFamilyBridgeInput ->
          individualE7ScopeTransfer

namespace E7BBTSpreadingData

/-- Family-level E7 BBT spreading follows from the full conditional package
recorded in the master paper. -/
theorem e7_bbt_spreading_from_full_package
    (D : E7BBTSpreadingData)
    (hBBT : D.bbtCoherence)
    (hCM : D.cmFibreDensity)
    (hWeak : D.weaklySpecialInputs)
    (hBundleA : D.hBundleAlgebraicity)
    (hBundleB : D.hBundleCycleSeeding)
    (hAH : D.ahCmE7Input) :
    D.familyLevelE7Spreading :=
  D.family_spreading_from_full_package hBBT hCM hWeak hBundleA hBundleB hAH

/-- The paper-level individual-scope transfer consumes the separate rigid
reach and non-rigid family bridge inputs after family-level spreading is known. -/
theorem individual_scope_transfer_from_family_spreading_and_bridges
    (D : E7BBTSpreadingData)
    (hFamily : D.familyLevelE7Spreading)
    (hRigid : D.bbtRigidReachInput)
    (hNonRigid : D.nonrigidFamilyBridgeInput) :
    D.individualE7ScopeTransfer :=
  D.individual_scope_from_family_and_bridges hFamily hRigid hNonRigid

end E7BBTSpreadingData

/-- A model in which BBT coherence and CM density are present but the H-bundle
cycle seeding and AH-CM-E7 inputs are missing. -/
def e7BbtNoHBundleCountermodel : E7BBTSpreadingData where
  bbtCoherence := True
  cmFibreDensity := True
  weaklySpecialInputs := True
  hBundleAlgebraicity := True
  hBundleCycleSeeding := False
  ahCmE7Input := False
  familyLevelE7Spreading := False
  bbtRigidReachInput := True
  nonrigidFamilyBridgeInput := True
  individualE7ScopeTransfer := False
  family_spreading_from_full_package := fun _ _ _ _ hBundleB _ => False.elim hBundleB
  individual_scope_from_family_and_bridges := fun hFamily _ _ => False.elim hFamily

/-- BBT coherence, CM density, and weakly-special inputs do not self-close the
E7 BBT-spreading theorem without the H-bundle/AH package. -/
theorem bbt_cm_density_do_not_self_close_e7_bbt_spreading :
    Not
      (forall D : E7BBTSpreadingData,
        D.bbtCoherence ->
          D.cmFibreDensity ->
            D.weaklySpecialInputs ->
              D.familyLevelE7Spreading) := by
  intro h
  exact h e7BbtNoHBundleCountermodel trivial trivial trivial

/-- Family-level E7 spreading alone does not close the individual-scope
statement if the rigid and non-rigid bridge inputs are absent. -/
def familySpreadingNoBridgeCountermodel : E7BBTSpreadingData where
  bbtCoherence := True
  cmFibreDensity := True
  weaklySpecialInputs := True
  hBundleAlgebraicity := True
  hBundleCycleSeeding := True
  ahCmE7Input := True
  familyLevelE7Spreading := True
  bbtRigidReachInput := False
  nonrigidFamilyBridgeInput := False
  individualE7ScopeTransfer := False
  family_spreading_from_full_package := fun _ _ _ _ _ _ => trivial
  individual_scope_from_family_and_bridges := fun _ hRigid _ => False.elim hRigid

theorem family_spreading_does_not_self_close_individual_e7_scope :
    Not
      (forall D : E7BBTSpreadingData,
        D.familyLevelE7Spreading ->
          D.individualE7ScopeTransfer) := by
  intro h
  exact h familySpreadingNoBridgeCountermodel trivial

end HodgeReduction
