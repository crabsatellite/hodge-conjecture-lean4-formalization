/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/

/-!
# E7 theta modularity and Shimura-side cycle seeding

Master tex labels: `thm:E7-modularity`, `hyp:chow-modularity-E7`,
`thm:E7-theta-match`, and `cor:theta-step-iii`.

The master paper's theta programme has a cohomological part, a Chow-level
modularity input, a theta-match statement, and a Shimura-side cycle-seeding
corollary.  This file records only the dependency shape and the corresponding
non-implications.  It does not formalize Kudla--Millson theory, exceptional
theta correspondences, `(g,K)`-cohomology, Whittaker non-vanishing, or Chow
groups of exceptional Shimura varieties.
-/

namespace HodgeReduction

/-- Dependency shape for `hyp:chow-modularity-E7`. -/
structure E7ChowModularityData where
  kudlaMillsonCohomologicalModularity : Prop
  bruinierFunkeOrthogonalChowLift : Prop
  howardMadapusiPeraOrthogonalArithmeticChow : Prop
  exceptionalE7ChowLiftAndRealFormDescent : Prop
  e7ThetaChowModular : Prop
  chow_modularity_from_components :
    kudlaMillsonCohomologicalModularity ->
      bruinierFunkeOrthogonalChowLift ->
        howardMadapusiPeraOrthogonalArithmeticChow ->
          exceptionalE7ChowLiftAndRealFormDescent ->
            e7ThetaChowModular

namespace E7ChowModularityData

/-- Chow-class modularity follows only after the exceptional E7 Chow lift and
Hermitian real-form descent input is supplied in addition to the classical and
orthogonal framework package. -/
theorem chow_modularity_from_full_package
    (D : E7ChowModularityData)
    (hKM : D.kudlaMillsonCohomologicalModularity)
    (hBF : D.bruinierFunkeOrthogonalChowLift)
    (hHMP : D.howardMadapusiPeraOrthogonalArithmeticChow)
    (hE7 : D.exceptionalE7ChowLiftAndRealFormDescent) :
    D.e7ThetaChowModular :=
  D.chow_modularity_from_components hKM hBF hHMP hE7

end E7ChowModularityData

/-- A model in which the cohomological and orthogonal Chow-level frameworks
are present but the exceptional E7 Chow lift and Hermitian real-form descent
input is absent. -/
def e7ChowNoExceptionalExtensionCountermodel : E7ChowModularityData where
  kudlaMillsonCohomologicalModularity := True
  bruinierFunkeOrthogonalChowLift := True
  howardMadapusiPeraOrthogonalArithmeticChow := True
  exceptionalE7ChowLiftAndRealFormDescent := False
  e7ThetaChowModular := False
  chow_modularity_from_components := fun _ _ _ hE7 => False.elim hE7

/-- The classical and orthogonal theta-modularity frameworks do not by
themselves close the exceptional E7 Chow-modularity hypothesis. -/
theorem orthogonal_chow_frameworks_do_not_self_close_exceptional_e7_chow_modularity :
    Not
      (forall D : E7ChowModularityData,
        D.kudlaMillsonCohomologicalModularity ->
          D.bruinierFunkeOrthogonalChowLift ->
            D.howardMadapusiPeraOrthogonalArithmeticChow ->
              D.e7ThetaChowModular) := by
  intro h
  exact h e7ChowNoExceptionalExtensionCountermodel trivial trivial trivial

/-- Dependency shape for `thm:E7-modularity`. -/
structure E7ThetaModularityData where
  rank27WeilTransformation : Prop
  exceptionalThetaKernelCompatibility : Prop
  rank3SpecialCyclesAlgebraic : Prop
  cohomologicalThetaModularity : Prop
  chowClassModularityInput : Prop
  e7GeneratingSeriesChowModular : Prop
  cohomological_from_weil_and_kernel :
    rank27WeilTransformation ->
      exceptionalThetaKernelCompatibility ->
        cohomologicalThetaModularity
  chow_modularity_from_cohomological_and_input :
    cohomologicalThetaModularity ->
      rank3SpecialCyclesAlgebraic ->
        chowClassModularityInput ->
          e7GeneratingSeriesChowModular

namespace E7ThetaModularityData

/-- The cohomological theta transformation law is a separate input from the
Chow-level modularity conclusion. -/
theorem cohomological_theta_modularity_from_kernel
    (D : E7ThetaModularityData)
    (hWeil : D.rank27WeilTransformation)
    (hKernel : D.exceptionalThetaKernelCompatibility) :
    D.cohomologicalThetaModularity :=
  D.cohomological_from_weil_and_kernel hWeil hKernel

/-- The Chow-valued modularity theorem consumes the cohomological
transformation law, algebraicity of rank-3 special cycles, and the separate
Chow-class modularity input. -/
theorem e7_chow_modularity_from_full_package
    (D : E7ThetaModularityData)
    (hWeil : D.rank27WeilTransformation)
    (hKernel : D.exceptionalThetaKernelCompatibility)
    (hCycles : D.rank3SpecialCyclesAlgebraic)
    (hChow : D.chowClassModularityInput) :
    D.e7GeneratingSeriesChowModular :=
  D.chow_modularity_from_cohomological_and_input
    (D.cohomological_theta_modularity_from_kernel hWeil hKernel)
    hCycles
    hChow

end E7ThetaModularityData

/-- A model in which the cohomological theta transformation and special-cycle
algebraicity are present, but the Chow-valued modularity input is absent. -/
def e7ThetaNoChowInputCountermodel : E7ThetaModularityData where
  rank27WeilTransformation := True
  exceptionalThetaKernelCompatibility := True
  rank3SpecialCyclesAlgebraic := True
  cohomologicalThetaModularity := True
  chowClassModularityInput := False
  e7GeneratingSeriesChowModular := False
  cohomological_from_weil_and_kernel := fun _ _ => trivial
  chow_modularity_from_cohomological_and_input := fun _ _ hChow => False.elim hChow

/-- Cohomological modularity and algebraic special cycles do not by themselves
produce the Chow-valued E7 modularity conclusion. -/
theorem cohomological_theta_does_not_self_close_chow_valued_e7_modularity :
    Not
      (forall D : E7ThetaModularityData,
        D.rank27WeilTransformation ->
          D.exceptionalThetaKernelCompatibility ->
            D.rank3SpecialCyclesAlgebraic ->
              D.e7GeneratingSeriesChowModular) := by
  intro h
  exact h e7ThetaNoChowInputCountermodel trivial trivial trivial

/-- Dependency shape for `thm:E7-theta-match`. -/
structure E7ThetaMatchData where
  chowModularity : Prop
  exceptionalThetaLiftProducesMinimalRepresentation : Prop
  gKCohomologyDegree3 : Prop
  rank3WhittakerNonvanishing : Prop
  rank3SpecialCyclesAlgebraic : Prop
  nonzeroWeight27Over2CuspForm : Prop
  thetaLiftMatchesInvariantClass : Prop
  nonzeroAlgebraicThetaCycle : Prop
  match_from_full_package :
    chowModularity ->
      exceptionalThetaLiftProducesMinimalRepresentation ->
        gKCohomologyDegree3 ->
          rank3WhittakerNonvanishing ->
            rank3SpecialCyclesAlgebraic ->
              nonzeroWeight27Over2CuspForm ->
                thetaLiftMatchesInvariantClass
  cycle_from_match_and_cycles :
    thetaLiftMatchesInvariantClass ->
      rank3SpecialCyclesAlgebraic ->
        nonzeroAlgebraicThetaCycle

namespace E7ThetaMatchData

/-- Theta-lift matching consumes Chow modularity, exceptional theta, the
Hermitian `(g,K)` degree computation, rank-3 Whittaker non-vanishing,
rank-3 special cycles, and a nonzero half-integral weight cusp form. -/
theorem theta_match_from_full_package
    (D : E7ThetaMatchData)
    (hChow : D.chowModularity)
    (hTheta : D.exceptionalThetaLiftProducesMinimalRepresentation)
    (hGK : D.gKCohomologyDegree3)
    (hWhittaker : D.rank3WhittakerNonvanishing)
    (hCycles : D.rank3SpecialCyclesAlgebraic)
    (hCusp : D.nonzeroWeight27Over2CuspForm) :
    D.thetaLiftMatchesInvariantClass :=
  D.match_from_full_package hChow hTheta hGK hWhittaker hCycles hCusp

/-- The nonzero algebraic theta-cycle conclusion follows from the matching
statement only after rank-3 special cycles are supplied as algebraic cycles. -/
theorem nonzero_algebraic_theta_cycle_from_match
    (D : E7ThetaMatchData)
    (hChow : D.chowModularity)
    (hTheta : D.exceptionalThetaLiftProducesMinimalRepresentation)
    (hGK : D.gKCohomologyDegree3)
    (hWhittaker : D.rank3WhittakerNonvanishing)
    (hCycles : D.rank3SpecialCyclesAlgebraic)
    (hCusp : D.nonzeroWeight27Over2CuspForm) :
    D.nonzeroAlgebraicThetaCycle :=
  D.cycle_from_match_and_cycles
    (D.theta_match_from_full_package hChow hTheta hGK hWhittaker hCycles hCusp)
    hCycles

end E7ThetaMatchData

/-- A model in which the Chow modularity and representation-theoretic inputs
are present except for rank-3 Whittaker non-vanishing. -/
def e7ThetaMatchNoWhittakerCountermodel : E7ThetaMatchData where
  chowModularity := True
  exceptionalThetaLiftProducesMinimalRepresentation := True
  gKCohomologyDegree3 := True
  rank3WhittakerNonvanishing := False
  rank3SpecialCyclesAlgebraic := True
  nonzeroWeight27Over2CuspForm := True
  thetaLiftMatchesInvariantClass := False
  nonzeroAlgebraicThetaCycle := False
  match_from_full_package := fun _ _ _ hWhittaker _ _ => False.elim hWhittaker
  cycle_from_match_and_cycles := fun hMatch _ => False.elim hMatch

/-- Chow modularity plus the broad theta framework does not self-close the
theta-match theorem without the rank-3 non-vanishing input. -/
theorem chow_modularity_and_theta_framework_do_not_self_close_theta_match :
    Not
      (forall D : E7ThetaMatchData,
        D.chowModularity ->
          D.exceptionalThetaLiftProducesMinimalRepresentation ->
            D.gKCohomologyDegree3 ->
              D.rank3SpecialCyclesAlgebraic ->
                D.nonzeroWeight27Over2CuspForm ->
                  D.thetaLiftMatchesInvariantClass) := by
  intro h
  exact h e7ThetaMatchNoWhittakerCountermodel trivial trivial trivial trivial trivial

/-- Dependency shape for `cor:theta-step-iii`. -/
structure E7ThetaStepIIIData where
  e7ModularityTheorem : Prop
  thetaLiftMatchTheorem : Prop
  rank3SpecialCyclesAlgebraic : Prop
  controlledDegreeBound : Prop
  shimuraSideCycleSeeding : Prop
  fibreLevelTransferToArbitraryE7Families : Prop
  hBundleCycleSeedingForShimuraSubvarieties : Prop
  step_iii_from_modularity_match_and_cycles :
    e7ModularityTheorem ->
      thetaLiftMatchTheorem ->
        rank3SpecialCyclesAlgebraic ->
          controlledDegreeBound ->
            shimuraSideCycleSeeding
  hbundle_from_shimura_seeding_and_family_scope :
    shimuraSideCycleSeeding ->
      fibreLevelTransferToArbitraryE7Families ->
        hBundleCycleSeedingForShimuraSubvarieties

namespace E7ThetaStepIIIData

/-- The Step (iii) corollary produces Shimura-side cycle seeding from the
modularity theorem, theta-match theorem, special-cycle algebraicity, and the
controlled-degree bound. -/
theorem shimura_side_cycle_seeding_from_theta_package
    (D : E7ThetaStepIIIData)
    (hMod : D.e7ModularityTheorem)
    (hMatch : D.thetaLiftMatchTheorem)
    (hCycles : D.rank3SpecialCyclesAlgebraic)
    (hDegree : D.controlledDegreeBound) :
    D.shimuraSideCycleSeeding :=
  D.step_iii_from_modularity_match_and_cycles hMod hMatch hCycles hDegree

/-- H-bundle cycle seeding for the family scope consumes a further
fibre-level transfer beyond the Shimura-side theta cycle. -/
theorem hbundle_cycle_seeding_from_theta_and_fibre_transfer
    (D : E7ThetaStepIIIData)
    (hMod : D.e7ModularityTheorem)
    (hMatch : D.thetaLiftMatchTheorem)
    (hCycles : D.rank3SpecialCyclesAlgebraic)
    (hDegree : D.controlledDegreeBound)
    (hFibre : D.fibreLevelTransferToArbitraryE7Families) :
    D.hBundleCycleSeedingForShimuraSubvarieties :=
  D.hbundle_from_shimura_seeding_and_family_scope
    (D.shimura_side_cycle_seeding_from_theta_package hMod hMatch hCycles hDegree)
    hFibre

end E7ThetaStepIIIData

/-- A model in which the Shimura-side cycle exists, but no fibre-level
transfer to arbitrary E7 families has been supplied. -/
def e7ThetaStepIIINoFibreTransferCountermodel : E7ThetaStepIIIData where
  e7ModularityTheorem := True
  thetaLiftMatchTheorem := True
  rank3SpecialCyclesAlgebraic := True
  controlledDegreeBound := True
  shimuraSideCycleSeeding := True
  fibreLevelTransferToArbitraryE7Families := False
  hBundleCycleSeedingForShimuraSubvarieties := False
  step_iii_from_modularity_match_and_cycles := fun _ _ _ _ => trivial
  hbundle_from_shimura_seeding_and_family_scope := fun _ hFibre => False.elim hFibre

/-- The Shimura-side theta cycle does not by itself transfer cycle seeding to
arbitrary E7 families; the fibre-level transfer remains load-bearing. -/
theorem shimura_side_theta_cycle_does_not_self_close_fibre_transfer :
    Not
      (forall D : E7ThetaStepIIIData,
        D.e7ModularityTheorem ->
          D.thetaLiftMatchTheorem ->
            D.rank3SpecialCyclesAlgebraic ->
              D.controlledDegreeBound ->
                D.hBundleCycleSeedingForShimuraSubvarieties) := by
  intro h
  exact h e7ThetaStepIIINoFibreTransferCountermodel trivial trivial trivial trivial

end HodgeReduction
