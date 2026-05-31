/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.FullHodgeGoal

/-!
# E7 exotic residual status

Master tex labels: `prop:exotic-narrowing`, `open:torelli-evii`,
`open:exotic-residual`, and `prop:combined-closure`.

The master paper separates the known E7 closures from the hypothetical
high-dimensional exotic rigid non-Shimura residual.  This file records only
that logical status: what has been narrowed, what would close the residual,
and why the listed strategy packages do not self-close the full Hodge
conjecture.  It does not formalize the Beauville--Bogomolov decomposition,
Iitaka/MRC fibrations, Mok rigidity, Standard Conjectures, Tate, syntomic
comparison, or Bost--Charles algebraization.
-/

namespace HodgeReduction

/-- Dependency shape for `prop:exotic-narrowing`. -/
structure ExoticE7NarrowingData where
  highDimensionalE7Candidate : Prop
  shimuraFrameworkHandlesKnownCase : Prop
  c1Nonzero : Prop
  notFano : Prop
  kodairaResidualCasesOnly : Prop
  noKnownExample : Prop
  exoticResidualNarrowed : Prop
  exoticResidualEliminated : Prop
  narrowed_from_geometric_eliminations :
    highDimensionalE7Candidate ->
      c1Nonzero ->
        notFano ->
          kodairaResidualCasesOnly ->
            exoticResidualNarrowed

namespace ExoticE7NarrowingData

/-- The paper's narrowing conclusion follows from the geometric eliminations,
but this is not the same as eliminating the residual. -/
theorem exotic_residual_narrowed_from_geometric_eliminations
    (D : ExoticE7NarrowingData)
    (hCandidate : D.highDimensionalE7Candidate)
    (hC1 : D.c1Nonzero)
    (hNotFano : D.notFano)
    (hKodaira : D.kodairaResidualCasesOnly) :
    D.exoticResidualNarrowed :=
  D.narrowed_from_geometric_eliminations hCandidate hC1 hNotFano hKodaira

end ExoticE7NarrowingData

/-- A model in which the residual is narrowed but not eliminated. -/
def exoticNarrowedButOpenCountermodel : ExoticE7NarrowingData where
  highDimensionalE7Candidate := True
  shimuraFrameworkHandlesKnownCase := True
  c1Nonzero := True
  notFano := True
  kodairaResidualCasesOnly := True
  noKnownExample := True
  exoticResidualNarrowed := True
  exoticResidualEliminated := False
  narrowed_from_geometric_eliminations := fun _ _ _ _ => trivial

/-- The geometric narrowing statement does not by itself close the exotic
high-dimensional E7 residual. -/
theorem exotic_narrowing_does_not_self_close_residual :
    Not
      (forall D : ExoticE7NarrowingData,
        D.exoticResidualNarrowed -> D.exoticResidualEliminated) := by
  intro h
  exact h exoticNarrowedButOpenCountermodel trivial

/-- Dependency shape for `open:torelli-evii`. -/
structure TorelliEVIIQuestionData where
  arithmeticityOfMonodromy : Prop
  margulisArithmeticityAvailable : Prop
  mokConditional : Prop
  eviiUniformisation : Prop
  exoticRigidVacuity : Prop
  torelli_from_uniformisation :
    eviiUniformisation -> exoticRigidVacuity

namespace TorelliEVIIQuestionData

/-- If an independent EVII-uniformisation input is supplied, the Torelli-EVII
route can be consumed to rule out the exotic rigid case. -/
theorem exotic_rigid_vacuity_from_evii_uniformisation
    (D : TorelliEVIIQuestionData)
    (hUniform : D.eviiUniformisation) :
    D.exoticRigidVacuity :=
  D.torelli_from_uniformisation hUniform

end TorelliEVIIQuestionData

/-- A model in which arithmeticity and a Mok-style conditional are present
but the independent EVII-uniformisation input is absent. -/
def torelliEVIINoUniformisationCountermodel : TorelliEVIIQuestionData where
  arithmeticityOfMonodromy := True
  margulisArithmeticityAvailable := True
  mokConditional := True
  eviiUniformisation := False
  exoticRigidVacuity := False
  torelli_from_uniformisation := fun hUniform => False.elim hUniform

/-- Arithmeticity plus the broad Mok conditional package does not self-close
Torelli-EVII without an independent uniformisation input. -/
theorem arithmeticity_and_mok_do_not_self_close_torelli_evii :
    Not
      (forall D : TorelliEVIIQuestionData,
        D.arithmeticityOfMonodromy ->
          D.margulisArithmeticityAvailable ->
            D.mokConditional ->
              D.exoticRigidVacuity) := by
  intro h
  exact h torelliEVIINoUniformisationCountermodel trivial trivial trivial

/-- Dependency shape for `open:exotic-residual`. -/
structure ExoticE7ResidualData where
  cy3ReducibleSubclassClosed : Prop
  nonRigidFamiliesClosed : Prop
  currentlyKnownRigidCasesClosed : Prop
  kappaZeroSubcaseEliminated : Prop
  generalTypeSubcaseEliminatedOrSolved : Prop
  dimensionFiveSubbranchClosed : Prop
  dimensionSixSubbranchClosed : Prop
  dimensionAtLeastSevenSubbranchClosed : Prop
  exoticResidualEliminated : Prop
  residual_eliminated_from_all_subbranches :
    cy3ReducibleSubclassClosed ->
      nonRigidFamiliesClosed ->
        currentlyKnownRigidCasesClosed ->
          kappaZeroSubcaseEliminated ->
            generalTypeSubcaseEliminatedOrSolved ->
              dimensionFiveSubbranchClosed ->
                dimensionSixSubbranchClosed ->
                  dimensionAtLeastSevenSubbranchClosed ->
                    exoticResidualEliminated

namespace ExoticE7ResidualData

/-- The residual is eliminated only after every listed Kodaira and dimension
sub-branch is closed, in addition to the known CY3/non-rigid/known-rigid cases. -/
theorem exotic_residual_eliminated_from_all_subbranches
    (D : ExoticE7ResidualData)
    (hCY3 : D.cy3ReducibleSubclassClosed)
    (hNonRigid : D.nonRigidFamiliesClosed)
    (hKnownRigid : D.currentlyKnownRigidCasesClosed)
    (hKappaZero : D.kappaZeroSubcaseEliminated)
    (hGeneralType : D.generalTypeSubcaseEliminatedOrSolved)
    (hDim5 : D.dimensionFiveSubbranchClosed)
    (hDim6 : D.dimensionSixSubbranchClosed)
    (hDimGe7 : D.dimensionAtLeastSevenSubbranchClosed) :
    D.exoticResidualEliminated :=
  D.residual_eliminated_from_all_subbranches
    hCY3 hNonRigid hKnownRigid hKappaZero hGeneralType hDim5 hDim6 hDimGe7

end ExoticE7ResidualData

/-- A model in which the known cases are closed but the dimension/Kodaira
residual sub-branches remain open. -/
def knownE7CasesClosedButResidualOpenCountermodel : ExoticE7ResidualData where
  cy3ReducibleSubclassClosed := True
  nonRigidFamiliesClosed := True
  currentlyKnownRigidCasesClosed := True
  kappaZeroSubcaseEliminated := False
  generalTypeSubcaseEliminatedOrSolved := False
  dimensionFiveSubbranchClosed := False
  dimensionSixSubbranchClosed := False
  dimensionAtLeastSevenSubbranchClosed := False
  exoticResidualEliminated := False
  residual_eliminated_from_all_subbranches := fun _ _ _ hKappaZero _ _ _ _ =>
    False.elim hKappaZero

/-- Closing the CY3-reducible, non-rigid, and currently-known rigid cases does
not by itself eliminate the high-dimensional exotic residual. -/
theorem known_e7_cases_do_not_self_close_exotic_residual :
    Not
      (forall D : ExoticE7ResidualData,
        D.cy3ReducibleSubclassClosed ->
          D.nonRigidFamiliesClosed ->
            D.currentlyKnownRigidCasesClosed ->
              D.exoticResidualEliminated) := by
  intro h
  exact h knownE7CasesClosedButResidualOpenCountermodel trivial trivial trivial

/-- Final full-HC gate exposed by the residual analysis. -/
structure FullHCResidualGateData where
  currentReductionCoversNonResidualScope : Prop
  exoticResidualEliminatedOrSolved : Prop
  fullHodgeConjectureRealTarget : Prop
  full_hodge_from_scope_and_residual :
    currentReductionCoversNonResidualScope ->
      exoticResidualEliminatedOrSolved ->
        fullHodgeConjectureRealTarget

namespace FullHCResidualGateData

/-- A conditional bridge to the actual final target.  This keeps the
`FullHodgeConjectureReal` endpoint separate from E7 milestones. -/
theorem full_hodge_conjecture_from_residual_gate
    (D : FullHCResidualGateData)
    (hScope : D.currentReductionCoversNonResidualScope)
    (hResidual : D.exoticResidualEliminatedOrSolved) :
    D.fullHodgeConjectureRealTarget :=
  D.full_hodge_from_scope_and_residual hScope hResidual

end FullHCResidualGateData

/-- R613 concrete residual-gate specialization of the R612 route.

This does not prove the residual is eliminated.  It records that the
scope-or-complement route already packages the non-residual branch and the
independent complement/residual branch into the same Lean antecedent. -/
def r612ScopeOrComplementResidualGateData : FullHCResidualGateData where
  currentReductionCoversNonResidualScope :=
    CurrentReductionCoversOrSolvesAllSmoothProjective
  exoticResidualEliminatedOrSolved :=
    CurrentReductionCoversOrSolvesAllSmoothProjective
  fullHodgeConjectureRealTarget := FullHodgeConjectureReal
  full_hodge_from_scope_and_residual := fun hRoute _ =>
    fullHodgeConjectureReal_of_currentScopeOrComplementCoverage hRoute

/-- R613 routes the R612 scope-or-complement antecedent through the residual
gate vocabulary used by the master paper. -/
theorem fullHodgeConjectureReal_from_r612ResidualGate
    (hRoute : CurrentReductionCoversOrSolvesAllSmoothProjective) :
    FullHodgeConjectureReal :=
  FullHCResidualGateData.full_hodge_conjecture_from_residual_gate
    r612ScopeOrComplementResidualGateData hRoute hRoute

/-- Machine-readable status for the R613 residual-gate/R612 alignment. -/
structure R613ResidualGateRouteSnapshot where
  concreteResidualGateAvailable : Bool
  routeAntecedentCount : Nat
  consumesR612Route : Bool
  concludesFullHodgeTarget : Bool
  provesResidualEliminationUnconditionally : Bool
  fullHcClosureClaim : Bool
  deriving Repr, DecidableEq, Inhabited

/-- Current R613 status: the residual-gate vocabulary is aligned with the
R612 route, but the route antecedent remains open. -/
def currentR613ResidualGateRouteSnapshot :
    R613ResidualGateRouteSnapshot where
  concreteResidualGateAvailable := true
  routeAntecedentCount := 1
  consumesR612Route := true
  concludesFullHodgeTarget := true
  provesResidualEliminationUnconditionally := false
  fullHcClosureClaim := false

/-- R613 kernel-checked status for the residual-gate/R612 alignment. -/
theorem currentR613ResidualGateRouteSnapshot_eq_texStatus :
    currentR613ResidualGateRouteSnapshot =
      ({ concreteResidualGateAvailable := true
         routeAntecedentCount := 1
         consumesR612Route := true
         concludesFullHodgeTarget := true
         provesResidualEliminationUnconditionally := false
         fullHcClosureClaim := false } :
        R613ResidualGateRouteSnapshot) := by
  decide

/-- Dependency shape for `prop:combined-closure`. -/
structure E7ResidualStrategyData where
  thetaShimuraSideCycle : Prop
  thetaFibreTransferToResidual : Prop
  padicHCForOmega : Prop
  rationalDescentFromPadic : Prop
  exceptionalMTConjectureForX : Prop
  tateCodimThreeForX : Prop
  bostCharlesTechnicalHypotheses : Prop
  residualHC : Prop
  hc_from_theta_transfer :
    thetaShimuraSideCycle ->
      thetaFibreTransferToResidual ->
        residualHC
  hc_from_padic_route :
    padicHCForOmega ->
      rationalDescentFromPadic ->
        residualHC
  hc_from_bost_charles_route :
    exceptionalMTConjectureForX ->
      tateCodimThreeForX ->
        bostCharlesTechnicalHypotheses ->
          residualHC

namespace E7ResidualStrategyData

/-- The theta route closes the residual only after the Shimura-side cycle is
transferred to the hypothetical exotic rigid variety. -/
theorem residual_hc_from_theta_transfer
    (D : E7ResidualStrategyData)
    (hTheta : D.thetaShimuraSideCycle)
    (hTransfer : D.thetaFibreTransferToResidual) :
    D.residualHC :=
  D.hc_from_theta_transfer hTheta hTransfer

/-- The p-adic route closes the residual only after the p-adic HC input, not
from the elementary scalar-descent step alone. -/
theorem residual_hc_from_padic_route
    (D : E7ResidualStrategyData)
    (hPadic : D.padicHCForOmega)
    (hDescent : D.rationalDescentFromPadic) :
    D.residualHC :=
  D.hc_from_padic_route hPadic hDescent

/-- The Bost--Charles route consumes the exceptional MT conjecture, Tate in
codimension 3, and the Bost--Charles technical hypotheses. -/
theorem residual_hc_from_bost_charles_route
    (D : E7ResidualStrategyData)
    (hMT : D.exceptionalMTConjectureForX)
    (hTate : D.tateCodimThreeForX)
    (hBost : D.bostCharlesTechnicalHypotheses) :
    D.residualHC :=
  D.hc_from_bost_charles_route hMT hTate hBost

end E7ResidualStrategyData

/-- A model in which the Shimura-side theta cycle exists but no transfer to
the hypothetical exotic rigid residual is available. -/
def thetaCycleNoResidualTransferCountermodel : E7ResidualStrategyData where
  thetaShimuraSideCycle := True
  thetaFibreTransferToResidual := False
  padicHCForOmega := False
  rationalDescentFromPadic := True
  exceptionalMTConjectureForX := False
  tateCodimThreeForX := False
  bostCharlesTechnicalHypotheses := False
  residualHC := False
  hc_from_theta_transfer := fun _ hTransfer => False.elim hTransfer
  hc_from_padic_route := fun hPadic _ => False.elim hPadic
  hc_from_bost_charles_route := fun hMT _ _ => False.elim hMT

/-- The Shimura-side theta cycle alone does not close HC for the hypothetical
exotic rigid residual. -/
theorem theta_shimura_cycle_does_not_self_close_residual_hc :
    Not
      (forall D : E7ResidualStrategyData,
        D.thetaShimuraSideCycle -> D.residualHC) := by
  intro h
  exact h thetaCycleNoResidualTransferCountermodel trivial

/-- The elementary rational descent from a p-adic representative does not
self-close the p-adic HC input. -/
theorem padic_descent_does_not_self_close_residual_hc :
    Not
      (forall D : E7ResidualStrategyData,
        D.rationalDescentFromPadic -> D.residualHC) := by
  intro h
  exact h thetaCycleNoResidualTransferCountermodel trivial

/-- The Bost--Charles strategy is not a proof without its three open
exceptional-type inputs. -/
theorem bost_charles_framework_does_not_self_close_residual_hc :
    Not
      (forall D : E7ResidualStrategyData,
        D.residualHC) := by
  intro h
  exact h thetaCycleNoResidualTransferCountermodel

end HodgeReduction
