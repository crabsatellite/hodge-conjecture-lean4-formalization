/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit
import HodgeReduction.Canonical.FullHodgeGoal
import HodgeReduction.Canonical.RouteReduction
import HodgeReduction.Canonical.ProgressiveReduction
import HodgeReduction.Canonical.ScalarExtensionDescent
import HodgeReduction.Canonical.LegacyArithmeticPatches
import HodgeReduction.Canonical.PaperLedgerGenerated

/-!
# Canonical Hodge audit chain

Only the canonical target/status surface and the generated paper ledger are
on this chain.  Historical attacks and failed reduction routes live outside
the `HodgeReduction.Canonical` namespace.
-/

namespace HodgeReduction.Canonical.MainChain

def config : ChainAudit.ProjectConfig := {
  projectName := "HodgeReduction.Canonical"
  rootNamespace := `HodgeReduction.Canonical
  endpoints := [
    ``HodgeReduction.Canonical.mtRouteCoverageTarget_trivial,
    ``HodgeReduction.Canonical.trivialMTResidualTarget_iff_fullHodge,
    ``HodgeReduction.Canonical.fullHodgeConjectureReal_of_progressiveReductions,
    ``HodgeReduction.Canonical.scalarExtensionDescent,
    ``HodgeReduction.Canonical.sg17ValuationObstruction,
    ``HodgeReduction.Canonical.currentFullHodgeClosureClaim_eq_false,
    ``HodgeReduction.Canonical.PaperLedgerGenerated.currentPaperLedgerClosureSnapshot_eq_generated
  ]
  openAxioms := []
  infraFiles := [
    "HodgeReduction.lean",
    "HodgeReduction/Infrastructure/HodgeStructure/Basic.lean",
    "HodgeReduction/Infrastructure/HodgeStructure/VarietyCohomology.lean",
    "HodgeReduction/Canonical/FullHodgeGoal.lean",
    "HodgeReduction/Canonical/RouteReduction.lean",
    "HodgeReduction/Canonical/ProgressiveReduction.lean",
    "HodgeReduction/Canonical/ScalarExtensionDescent.lean",
    "HodgeReduction/Canonical/LegacyArithmeticPatches.lean",
    "HodgeReduction/Canonical/MainChain.lean",
    "HodgeReduction/Canonical/Scripts/StatusEntry.lean",
    "HodgeReduction/Canonical/Scripts/CheckEntry.lean",
    "HodgeReduction/Canonical/PaperLedgerGenerated.lean"
  ]
  researchGaps := [
    {
      id := "G-formal-universe"
      title := "Geometric universe and cycle-class construction"
      status := "open"
      summary :=
        "Replace the supplied data interface by a kernel-checked universe of genuine smooth projective complex varieties, cohomology, and cycle-class images."
      files := [
        "HodgeReduction/Canonical/FullHodgeGoal.lean"
      ]
      decls := [
        "HodgeReduction.Canonical.SmoothProjectiveComplexUniverse",
        "HodgeReduction.Canonical.SmoothProjectiveComplexVarietyData"
      ]
    },
    {
      id := "G-progress-witness-binding"
      title := "Geometric witness to strict submodule step"
      status := "open"
      summary :=
        "Turn an exact nodal or normal-function witness into solvedPart, nextPart, algebraicity, coverage, and strictProgress fields."
      files := [
        "HodgeReduction/Canonical/ProgressiveReduction.lean"
      ]
      decls := [
        "HodgeReduction.Canonical.ProgressStepAt",
        "HodgeReduction.Canonical.progressStepAt_spec"
      ]
    },
    {
      id := "G-nodal-support"
      title := "Thomas nodal homology-support witnesses"
      status := "open"
      summary :=
        "Construct a nodal divisor with only ordinary double points and an exact middle-homology preimage of each target Poincare dual."
      files := [
        "HodgeReduction/Canonical/ProgressiveReduction.lean"
      ]
      decls := [
        "HodgeReduction.Canonical.ProgressiveReductionTarget",
        "HodgeReduction.Canonical.ProgressStepAt"
      ]
    },
    {
      id := "G-normal-function-singularities"
      title := "Primitive normal-function singularity witnesses"
      status := "open"
      summary :=
        "For every non-torsion primitive middle Hodge class, construct a power of a very ample system and a boundary point carrying the required non-torsion admissible-normal-function singularity."
      files := [
        "HodgeReduction/Canonical/ProgressiveReduction.lean"
      ]
      decls := [
        "HodgeReduction.Canonical.ProgressiveReductionTarget",
        "HodgeReduction.Canonical.ProgressStepAt"
      ]
    },
    {
      id := "G-full-hc"
      title := "Full Hodge Conjecture"
      status := "final-open"
      summary :=
        "The relative target schema is explicit.  A complete geometric universe and a kernel-checked closed target statement are not registered."
      files := [
        "HodgeReduction/Canonical/FullHodgeGoal.lean",
        "HodgeReduction/Canonical/ProgressiveReduction.lean",
        "HodgeReduction/Canonical/PaperLedgerGenerated.lean"
      ]
      decls := [
        "HodgeReduction.Canonical.FullHodgeConjectureReal",
        "HodgeReduction.Canonical.fullHodgeConjectureReal_of_progressiveReductions",
        "HodgeReduction.Canonical.currentFullHodgeClosureClaim_eq_false",
        "HodgeReduction.Canonical.PaperLedgerGenerated.fullHodgeProved_eq_false"
      ]
    }
  ]
  researchChains := [
    {
      id := "canonical-paper-evidence"
      title := "Canonical paper evidence gate"
      kind := "support"
      status := "closed"
      summary :=
        "Every retained paper obligation has an accepted kernel or local-reference support path.  This closes paper evidence only."
      files := [
        "HodgeReduction/Canonical/PaperLedgerGenerated.lean"
      ]
      entryDecls := [
        "HodgeReduction.Canonical.PaperLedgerGenerated.paperEvidenceClosed_eq_true"
      ]
      gapIds := ["G-full-hc"]
      successCriterion :=
        "Keep paperEvidenceClosed independently derived from the still-open full-HC target."
    },
    {
      id := "progressive-reduction-kernel"
      title := "Kernel-checked progressive reduction certificates"
      kind := "support"
      status := "closed"
      summary :=
        "The old route target is proved vacuous, while every accepted replacement step strictly shrinks its residual and every finite derivation is sound."
      files := [
        "HodgeReduction/Canonical/ProgressiveReduction.lean"
      ]
      entryDecls := [
        "HodgeReduction.Canonical.mtRouteCoverageTarget_trivial",
        "HodgeReduction.Canonical.trivialMTResidualTarget_iff_fullHodge",
        "HodgeReduction.Canonical.progressiveAlgebraicityAt_sound",
        "HodgeReduction.Canonical.fullHodgeConjectureReal_of_progressiveReductions"
      ]
      gapIds := [
        "G-progress-witness-binding",
        "G-nodal-support",
        "G-normal-function-singularities",
        "G-full-hc"
      ]
      successCriterion :=
        "Admit no research step whose next residual equals its input submodule."
    }
  ]
  primaryGapId := some "G-full-hc"
  gapPriority := [
    "G-formal-universe",
    "G-progress-witness-binding",
    "G-nodal-support",
    "G-normal-function-singularities",
    "G-full-hc"
  ]
}

end HodgeReduction.Canonical.MainChain
