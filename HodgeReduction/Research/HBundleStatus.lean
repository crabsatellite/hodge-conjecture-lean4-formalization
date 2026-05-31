/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# H-bundle status

Master tex labels: `input:Hbundle`,
`thm:bundle-matching-unconditional`, `prop:hbundle-low-dim`, and
`open:hbundle`.

The master paper uses "H-bundle" for two different obligations:

* bundle matching for the pulled-back canonical `V_56` bundle;
* cycle-level seeding on fibres.

The paper claims bundle matching is closed at paper level, while cycle
seeding remains conditional in the `E_7` residual route.  This file records
that dependency shape and the non-closure facts needed to keep the paper and
the machine ledger consistent.  It does not formalize AMRT/KKMS, Schmid
nilpotent orbit theory, Deligne canonical extensions, Lefschetz (1,1), Hard
Lefschetz, or Chern-Weil theory.
-/

namespace HodgeReduction

/-- Dependency shape for H-bundle bundle matching. -/
structure HBundleMatchingData where
  rigidPointCase : Prop
  quasiUnipotentBaseChange : Prop
  semistableToroidalReduction : Prop
  moderateGrowthUniqueness : Prop
  finiteBaseChangeDescent : Prop
  knownAutomaticCases : Prop
  arbitraryNonToroidalBoundaryCase : Prop
  bundleMatching : Prop
  rigid_point_case_matches :
    rigidPointCase -> bundleMatching
  nonrigid_toroidal_reduction_matches :
    quasiUnipotentBaseChange ->
      semistableToroidalReduction ->
        moderateGrowthUniqueness ->
          finiteBaseChangeDescent ->
            bundleMatching

namespace HBundleMatchingData

/-- Rigid point bases satisfy the bundle-matching clause. -/
theorem bundle_matching_from_rigid_point_case
    (D : HBundleMatchingData)
    (hRigid : D.rigidPointCase) :
    D.bundleMatching :=
  D.rigid_point_case_matches hRigid

/-- The non-rigid paper proof routes bundle matching through unipotent
base change, toroidal/semistable reduction, moderate-growth uniqueness, and
descent. -/
theorem bundle_matching_from_toroidal_reduction_package
    (D : HBundleMatchingData)
    (hUnip : D.quasiUnipotentBaseChange)
    (hToroidal : D.semistableToroidalReduction)
    (hModerate : D.moderateGrowthUniqueness)
    (hDescent : D.finiteBaseChangeDescent) :
    D.bundleMatching :=
  D.nonrigid_toroidal_reduction_matches
    hUnip hToroidal hModerate hDescent

end HBundleMatchingData

/-- Known automatic cases do not by themselves cover arbitrary non-toroidal
boundary compactifications. -/
def hbundleKnownCasesButNonToroidalOpenCountermodel : HBundleMatchingData where
  rigidPointCase := False
  quasiUnipotentBaseChange := False
  semistableToroidalReduction := False
  moderateGrowthUniqueness := False
  finiteBaseChangeDescent := False
  knownAutomaticCases := True
  arbitraryNonToroidalBoundaryCase := True
  bundleMatching := False
  rigid_point_case_matches := fun h => False.elim h
  nonrigid_toroidal_reduction_matches := fun h _ _ _ => False.elim h

/-- The automatic cases listed in the paper do not self-close the arbitrary
non-toroidal boundary case without the reduction/descent package. -/
theorem known_hbundle_cases_do_not_self_close_arbitrary_nontoroidal_boundary :
    Not
      (forall D : HBundleMatchingData,
        D.knownAutomaticCases ->
          D.arbitraryNonToroidalBoundaryCase ->
            D.bundleMatching) := by
  intro h
  exact h hbundleKnownCasesButNonToroidalOpenCountermodel trivial trivial

/-- Dependency shape for H-bundle cycle seeding. -/
structure HBundleCycleSeedingData where
  lowDimensionalLefschetzPackage : Prop
  e6WeightParityVacuity : Prop
  nonrigidE7Subcase3bVacuity : Prop
  knownRigidE7ChernWeil : Prop
  chernWeilBridgeE7 : Prop
  ahCmE7 : Prop
  highDimensionalExoticResidual : Prop
  highDimensionalResidualCycleSeeding : Prop
  cycleSeeding : Prop
  low_dimensional_cycle_seeding :
    lowDimensionalLefschetzPackage -> cycleSeeding
  e6_cycle_seeding :
    e6WeightParityVacuity -> cycleSeeding
  nonrigid_e7_cycle_seeding :
    nonrigidE7Subcase3bVacuity ->
      chernWeilBridgeE7 ->
        ahCmE7 ->
          cycleSeeding
  known_rigid_e7_cycle_seeding :
    knownRigidE7ChernWeil ->
      chernWeilBridgeE7 ->
        ahCmE7 ->
          cycleSeeding

namespace HBundleCycleSeedingData

/-- Low-dimensional cycle seeding is the Lefschetz/Poincare-duality branch
recorded in `prop:hbundle-low-dim`. -/
theorem cycle_seeding_from_low_dimensional_lefschetz
    (D : HBundleCycleSeedingData)
    (hLow : D.lowDimensionalLefschetzPackage) :
    D.cycleSeeding :=
  D.low_dimensional_cycle_seeding hLow

/-- Non-rigid `E_7` cycle seeding is conditional on the Sub-case 3b vacuity
route plus the Chern-Weil and AH-CM-E7 inputs. -/
theorem cycle_seeding_from_nonrigid_e7_package
    (D : HBundleCycleSeedingData)
    (hVacuity : D.nonrigidE7Subcase3bVacuity)
    (hCW : D.chernWeilBridgeE7)
    (hAH : D.ahCmE7) :
    D.cycleSeeding :=
  D.nonrigid_e7_cycle_seeding hVacuity hCW hAH

/-- Currently-known rigid `E_7` cycle seeding uses direct Chern-Weil, still
modulo the Chern-Weil bridge and AH-CM-E7 inputs. -/
theorem cycle_seeding_from_known_rigid_e7_package
    (D : HBundleCycleSeedingData)
    (hRigidCW : D.knownRigidE7ChernWeil)
    (hCW : D.chernWeilBridgeE7)
    (hAH : D.ahCmE7) :
    D.cycleSeeding :=
  D.known_rigid_e7_cycle_seeding hRigidCW hCW hAH

end HBundleCycleSeedingData

/-- A model where the low-dimensional branch is closed but the high-dimensional
exotic residual still has no cycle seed. -/
def lowDimensionalHBundleOnlyCountermodel : HBundleCycleSeedingData where
  lowDimensionalLefschetzPackage := True
  e6WeightParityVacuity := False
  nonrigidE7Subcase3bVacuity := False
  knownRigidE7ChernWeil := False
  chernWeilBridgeE7 := False
  ahCmE7 := False
  highDimensionalExoticResidual := True
  highDimensionalResidualCycleSeeding := False
  cycleSeeding := True
  low_dimensional_cycle_seeding := fun _ => trivial
  e6_cycle_seeding := fun h => False.elim h
  nonrigid_e7_cycle_seeding := fun h _ _ => False.elim h
  known_rigid_e7_cycle_seeding := fun h _ _ => False.elim h

/-- Low-dimensional H-bundle cycle seeding does not self-close the
high-dimensional exotic residual branch. -/
theorem low_dimensional_hbundle_does_not_self_close_high_dimensional_residual :
    Not
      (forall D : HBundleCycleSeedingData,
        D.lowDimensionalLefschetzPackage ->
          D.highDimensionalExoticResidual ->
            D.highDimensionalResidualCycleSeeding) := by
  intro h
  exact h lowDimensionalHBundleOnlyCountermodel trivial trivial

/-- Dependency shape for the combined H-bundle structural input. -/
structure HBundleInputData where
  bundleMatching : Prop
  cycleSeeding : Prop
  hBundleInput : Prop
  hbundle_from_matching_and_cycle_seeding :
    bundleMatching -> cycleSeeding -> hBundleInput

namespace HBundleInputData

/-- The full H-bundle input is the conjunction of bundle matching and
cycle-level seeding. -/
theorem hbundle_input_from_matching_and_cycle_seeding
    (D : HBundleInputData)
    (hMatch : D.bundleMatching)
    (hSeed : D.cycleSeeding) :
    D.hBundleInput :=
  D.hbundle_from_matching_and_cycle_seeding hMatch hSeed

end HBundleInputData

/-- A model where bundle matching holds but the cycle-seeding half is still
absent. -/
def hbundleMatchingWithoutCycleSeedingCountermodel : HBundleInputData where
  bundleMatching := True
  cycleSeeding := False
  hBundleInput := False
  hbundle_from_matching_and_cycle_seeding := fun _ hSeed => False.elim hSeed

/-- Bundle matching alone is not the full H-bundle input used downstream. -/
theorem bundle_matching_does_not_self_close_hbundle_input :
    Not
      (forall D : HBundleInputData,
        D.bundleMatching -> D.hBundleInput) := by
  intro h
  exact h hbundleMatchingWithoutCycleSeedingCountermodel trivial

end HodgeReduction
