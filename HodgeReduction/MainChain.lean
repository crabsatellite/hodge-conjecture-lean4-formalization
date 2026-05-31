/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit
import HodgeReduction.AxiomInventory
import HodgeReduction.FullHodgeGoal
import HodgeReduction.PaperInventory
import HodgeReduction.MainTheorem
import HodgeReduction.HCGapRegistry
import HodgeReduction.Research.E7ResidualStatus
import HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion
import HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity
import HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence
import HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment
import HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual
import HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine
import HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence
import HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence
import HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence
import HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge

/-!
# Hodge main-chain audit configuration

This module is the single source of truth for the generated
`chain-status/*` reports.  The audit code derives the import closure,
open cuts, orphan files, and route labels from this Lean configuration
plus the actual compiled environment.

The final project goal is `FullHodgeConjectureReal`: HC-real for every
smooth projective complex variety.  The current kernel-checked endpoints
are milestones toward that goal, not the goal itself.  In particular,
`hodgeConjectureReal_canonical` is the active canonical `E_7` milestone;
closing it would still not prove the full Hodge conjecture unless it is
connected to a universal route.

The root aggregator `HodgeReduction.lean` intentionally is not the audit
entrypoint: it imports many historical and exploratory front-attack
files.  The audit entry is this file, whose endpoints isolate the
current proved/conditional milestone theorems:
(`hodgeConjectureReal_canonical`), its codimension-one slice
(`hodgeConjectureReal_canonical_codim1`), the four case-axiom-backed
sub-reductions (`main_reduction_real`), and the paper's unconditional
classical theorems (`thm_Meyer`, `thm_G2F4`, `thm_E8_vacuous`,
`thm_cy3_e7_nonexistence`, `thm_subcase3b_vacuous`).

The mathematical "gap container" is the single project axiom
`canonicalE7ShimuraTor : E7ShimuraTor`.  Its `mtCorrespondencePackage`
field already bundles the per-codimension Mumford--Tate correspondence
witnesses needed by `hodgeConjectureReal_canonical`; the field can be
unbundled only after Mathlib supplies arithmetic groups, Hermitian
symmetric domains, toroidal compactifications, singular cohomology of
complex varieties, and the Matsushima / Borel--Wallach apparatus.  The
layer breakdown of that single axiom lives in
`HodgeReduction.HCGapRegistry` (Layer 1 -- 4) and is the source for the
`researchGaps` registry below.
-/

namespace HodgeReduction.MainChain

open ChainAudit

def config : ChainAudit.ProjectConfig := {
  projectName := "HodgeReduction"
  rootNamespace := `HodgeReduction
  endpoints := [
    ``HodgeReduction.hodgeConjectureReal_canonical,
    ``HodgeReduction.hodgeConjectureReal_canonical_codim1,
    ``HodgeReduction.main_reduction_real,
    ``HodgeReduction.thm_Meyer,
    ``HodgeReduction.thm_G2F4,
    ``HodgeReduction.thm_E8_vacuous,
    ``HodgeReduction.thm_cy3_e7_nonexistence,
    ``HodgeReduction.thm_subcase3b_vacuous
  ]
  openAxioms := [
    -- R542 field-level project cuts for the headline: a canonical
    -- target SPV plus the two E7-scope facts needed to consume the
    -- generic R517/R532 MT-witness route.
    ``HodgeReduction.canonicalTargetVariety,
    ``HodgeReduction.canonicalTargetE7Factor,
    ``HodgeReduction.canonicalTargetInKnownE7Scope,
    -- R169 substantive bridge axioms (Hodge 1941 / Lefschetz 1924,
    -- awaiting a Mathlib singular cohomology + cycle-class port).
    ``HodgeReduction.SmoothProjectiveVariety.cohomology,
    ``HodgeReduction.SmoothProjectiveVariety.algClasses,
    -- R527/R515/R535/R543 decomposition of the former broad
    -- `hyp_HC_CM_Ab_real` cut: CM-scoped absolute-Hodge carrier +
    -- Deligne 1982 Hodge-to-absolute-Hodge theorem + the remaining
    -- CM-scoped AH-to-algebraic bridge.
    ``HodgeReduction.absHodgeClassesAtDegreeCM,
    ``HodgeReduction.deligne_1982_abs_hodge_cm,
    ``HodgeReduction.abs_hodge_cm_implies_algebraic,
    -- R550 codim-one bypass via Lefschetz (1,1), now at the
    -- theorem's classical all-SPV scope.  The old CM-scoped form is
    -- a theorem derived from this cut.
    ``HodgeReduction.lefschetz_11_hc_real_at_codim1,
    -- R172/R528/R534 case cuts used by main_reduction_real. The E6 case
    -- now consumes a chosen classical remainder plus a transfer cut; the
    -- CY3 case is a theorem routed through the R530/R531/R533 bridge below.
    ``HodgeReduction.hc_real_classical_cartan,
    ``HodgeReduction.e6_classical_remainder_exists,
    ``HodgeReduction.e6_remainder_transfer,
    -- R529/R517/R545/R549 decomposition of the former
    -- `mt_correspondence_e7_witness_exists` cut into CM source
    -- existence, four chosen-source codim-one package components, and
    -- the remaining non-codim-one lift.
    ``HodgeReduction.e7_cm_witness_exists,
    ``HodgeReduction.e7_chosen_witness_hsm_codim1,
    ``HodgeReduction.e7_chosen_witness_alg_map_codim1,
    ``HodgeReduction.e7_chosen_witness_square_codim1,
    ``HodgeReduction.e7_chosen_witness_hodge_surj_codim1,
    ``HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists,
    -- R533 decomposition of the former `cy3_e7_nonexistence_paper_axiom`
    -- into paper 搂4 stage cuts: Springer/V56, FTS omega, J3(O)
    -- nonrealization.
    ``HodgeReduction.cy3_e7_springer_stage,
    ``HodgeReduction.cy3_e7_fts_omega_stage,
    ``HodgeReduction.cy3_e7_j3o_nonrealization_stage,
    -- R531 CY3 vacuity bridge: weak E7-factor inheritance plus the two
    -- structural facts needed to recover the exact E7 type used by the
    -- CY3 nonexistence theorem.
    ``HodgeReduction.cy3_inherits_e7_factor,
    ``HodgeReduction.cy3_mtd_isSemisimple,
    ``HodgeReduction.cy3_e7_excludes_e6
  ]
  infraFiles := [
    -- Audit / tooling files (intentionally off-chain).
    "HodgeReduction/MainChain.lean",
    "HodgeReduction/Scripts/StatusEntry.lean",
    "HodgeReduction/Scripts/CheckEntry.lean",
    -- The HC gap registry is a Prop-marker registry, not part of the
    -- proved chain; it is documentation for the layer breakdown of
    -- `canonicalE7ShimuraTor`.
    "HodgeReduction/HCGapRegistry.lean",
    -- Canonical master-paper import ledger.  This is metadata, not a
    -- theorem dependency: it records which master-tex items have been
    -- mapped to Lean declarations or explicit gaps.
    "HodgeReduction/PaperInventory.lean",
    -- R629 trust-base inventory: machine-generated top-level count of
    -- project-prefixed axiom constants used by the paper's Lean-status prose.
    "HodgeReduction/AxiomInventory.lean",
    -- Per-round cone audit scripts (each one is a `#print axioms` /
    -- `#check` audit driver consuming the active chain at the round
    -- timestamp; not imported by `HodgeReduction.lean`).  After R217
    -- the cone audits live under `HodgeReduction/ConeAudits/` to keep
    -- the project-root tidy.
    "HodgeReduction/ConeAudits/R217_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R218_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R219_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R220_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R221_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R222_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R223_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R224_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R225_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R226_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R227_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R228_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R229_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R230_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R231_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R232_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R233_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R234_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R235_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R236_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R237_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R238_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R239_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R240_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R241_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R242_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R243_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R244_R247_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R248_R250_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R251_R253_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R254_R256_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R257_R259_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R260_R264_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R265A_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R265B_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R266_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R267A_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R267B_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R268_R272_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R273_R278_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R279_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R280_R283_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R284_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R285_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R286_R288_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R289_R292_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R293_R298_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R301_R304_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R305_R309_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R310_R315_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R316_R320_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R321_R326_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R327_R332_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R333_R338_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R339_R344_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R345_R350_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R351_R356_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R357_R362_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R363_R366_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R367_R370_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R371_R376_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R377_R384_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R385_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R385_R388_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R386_R387_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R389_R391_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R392_R396_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R397_R402_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R403_R406_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R407_R411_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R412_R416_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R417_R420_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R421_R425_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R426_R428_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R429_R432_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R433_R436_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R437_R442_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R443a_R446_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R451_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R452_R456_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R457_R460_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R462_R465_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean",
    "HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean"
  ]
  researchGaps := [
    {
      id := "G-full-hc"
      title := "Final target: full Hodge conjecture for all smooth projective complex varieties"
      status := "final-open"
      summary :=
        "The final project objective is `FullHodgeConjectureReal`, the universal theorem `forall X : SmoothProjectiveVariety Complex, HodgeConjectureReal X`.  The current canonical `E_7` endpoint and the four-case `main_reduction_real` theorem are milestones only.  `main_reduction_real` proves `InScope X -> HodgeConjectureReal X`; a full proof still needs either a proof that the current scope covers every smooth projective complex variety or a separate global route for varieties outside that scope.  R611 records that global closure route in `FullHodgeGoal.lean`, including the by-codimension consumer and the machine-checked status that the current state is not a full-HC closure claim.  R612 formalizes the second alternative as `CurrentReductionCoversOrSolvesAllSmoothProjective` and proves that this scope-or-complement route consumes `main_reduction_real` to conclude the full theorem.  R613 aligns the residual-gate vocabulary in `Research/E7ResidualStatus.lean` with the same R612 antecedent, so the paper's residual-gate route and the full-HC closure route are now the same kernel-visible interface.  R620 adds a zero-failure summary guard tying the paper's non-closure claim, final-open route status, and import-ledger sanity checks to Lean.  R621 fixes the exact ten route gap id/status pairs used by the paper summary, R627 fixes the exact nine primary labelled hypotheses that the paper summary lists as open inputs, R628 fixes the four scope-subclass status claims, R629 fixes the top-level project axiom-constant count used by the Lean trust-base prose, R630 fixes the direct `sorryAx` count for project declarations visible from the root import, R631 pins the exact endpoint-level open-cut ledger at 24 configured cuts, R632 assigns those endpoint cuts to registered route-level gap rows, and R633 isolates the only endpoint cut without direct master-paper claim coverage as structural cohomology infrastructure.  Do not treat closure of `G-main-hc`, `G-l4-mt-correspondence`, or any canonical target branch as closure of the full Hodge conjecture unless it feeds an explicit theorem concluding `FullHodgeConjectureReal`."
      files := [
        "HodgeReduction/FullHodgeGoal.lean",
        "HodgeReduction/AxiomInventory.lean",
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/Types.lean",
        "HodgeReduction/MainChain.lean"
      ]
      decls := [
        "HodgeReduction.FullHodgeConjectureReal",
        "HodgeReduction.FullHodgeConjectureRealByCodim",
        "HodgeReduction.fullHodgeConjectureReal_iff_byCodim",
        "HodgeReduction.CurrentReductionCoversAllSmoothProjective",
        "HodgeReduction.fullHodgeConjectureReal_of_currentScopeCoverage",
        "HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeCoverage",
        "HodgeReduction.currentFullHodgeClosureRouteNames",
        "HodgeReduction.FullHodgeClosureStatusSnapshot",
        "HodgeReduction.currentFullHodgeClosureStatusSnapshot",
        "HodgeReduction.currentFullHodgeClosureStatusSnapshot_eq_texStatus",
        "HodgeReduction.currentFullHodgeClosureRouteNames_eq_texStatus",
        "HodgeReduction.CurrentReductionCoversOrSolvesAllSmoothProjective",
        "HodgeReduction.currentScopeOrComplementCoverage_of_currentScopeCoverage",
        "HodgeReduction.fullHodgeConjectureReal_of_currentScopeOrComplementCoverage",
        "HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeOrComplementCoverage",
        "HodgeReduction.currentFullHodgeScopeOrComplementRouteNames",
        "HodgeReduction.FullHodgeScopeOrComplementSnapshot",
        "HodgeReduction.currentFullHodgeScopeOrComplementSnapshot",
        "HodgeReduction.currentFullHodgeScopeOrComplementSnapshot_eq_texStatus",
        "HodgeReduction.currentFullHodgeScopeOrComplementRouteNames_eq_texStatus",
        "HodgeReduction.MainChain.fullHcNarrativeClaimsCompleteProof",
        "HodgeReduction.MainChain.PaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot_eq_texStatus",
        "HodgeReduction.MainChain.fullHcCompletionOverclaimCount",
        "HodgeReduction.MainChain.fullHcFinalOpenStatusFailureCount",
        "HodgeReduction.MainChain.masterClaimTagPointerFailureCount",
        "HodgeReduction.MainChain.masterClaimDispositionTagMismatchCount",
        "HodgeReduction.MainChain.masterBrokenLinkDisciplineFailureCount",
        "HodgeReduction.MainChain.masterSubgapStatusMarkerFailureCount",
        "HodgeReduction.MainChain.masterPrimaryHypothesisDisciplineFailureCount",
        "HodgeReduction.MainChain.scopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceCount",
        "HodgeReduction.MainChain.allScopeSubclassRouteGapReferencesRegisteredInRoute",
        "HodgeReduction.MainChain.masterScopeSubclassStatusFailureCount",
        "HodgeReduction.MainChain.projectAxiomTrustBaseFailureCount",
        "HodgeReduction.MainChain.projectSorryAxFailureCount",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero",
        "HodgeReduction.MainChain.masterSourceDisciplineFailureCount",
        "HodgeReduction.MainChain.masterEnvironmentCoverageFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount_eq_zero",
        "HodgeReduction.MainChain.RouteGapStatusEntry",
        "HodgeReduction.MainChain.routeGapStatusLedger",
        "HodgeReduction.MainChain.routeGapStatusLedger_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutNames",
        "HodgeReduction.MainChain.endpointOpenCutCount",
        "HodgeReduction.MainChain.EndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutCount_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignment",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments_eq_texStatus",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignmentFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutPaperCoverageFailureCount",
        "HodgeReduction.main_reduction_real",
        "HodgeReduction.hodgeConjectureReal_canonical"
      ]
    },
    {
      id := "G-master-paper-import"
      title := "Canonical master-paper content imported into Lean"
      status := "in-progress"
      summary :=
        "`PaperInventory.lean` makes `../contributions/hodge-conjecture-master-proof.tex` the only canonical paper source for the import pass.  Attack maps, literature surveys, and round-contribution tex files are archive/background unless a later round promotes a statement into the master tex.  Each indexed master-paper environment is now claimed in the ledger: existing Lean declarations where available, published-input carriers where appropriate, and explicit `registeredGap` / `openHypothesis` / `openResidual` entries where the paper does not currently supply a kernel-checkable proof.  R620 ties the master-paper summary paragraph to a single zero-failure guard over route status, correspondence, tag, source, and theorem-environment checks; R621 pins the exact route gap id/status list behind that summary.  R622 pins the exact claim-id worklists for registered gaps, open hypotheses/residuals, conditional milestones, paper proofs not kernel-ported, external citations not kernel-ported, new-math gaps, and migration debt.  R623 pins the exact claim-id worklist attached to each route-level gap id/status pair.  R624 records that the only route rows without direct master-paper claim ids are the structural infrastructure gaps `G-l1-e7-shimura-tor` and `G-l2-cohomology-construction`.  R625 pins the exact broken-link predicate list and checks that those anchors stay attached to open/gap-facing master claims.  R626 pins the explicit sub-gap status markers in the master tex: four `gapPartial`, one `gapOpen`, and one `gapBlocked`.  R627 pins the exact nine primary labelled hypotheses used by the abstract, status box, and conclusion, and checks that they are exactly the open-hypothesis claim worklist.  R628 pins the four scope-subclass status claims, separating unconditional sub-arguments from inherited conditional machinery.  R629 pins the Lean trust-base prose to the generated top-level project axiom-constant count, R630 pins the compiled direct `sorryAx` count to zero, R631 pins the flat endpoint-open-cut count/list behind the route-index headline, R632 pins the route-gap assignment for each endpoint cut, and R633 pins the structural endpoint-cut exception without direct master-claim coverage.  This completes the master-environment triage pass, not the full Hodge theorem."
      files := [
        "HodgeReduction/PaperInventory.lean",
        "HodgeReduction/Research/AnisotropicResidue.lean",
        "HodgeReduction/Research/ClassicalExternalStatus.lean",
        "HodgeReduction/Research/CMFibreDensity.lean",
        "HodgeReduction/Research/E7ArithmeticityPipeline.lean",
        "HodgeReduction/Research/E7BBTSpreading.lean",
        "HodgeReduction/Research/E7CMAlgebraicity.lean",
        "HodgeReduction/Research/E7ChernWeilBridge.lean",
        "HodgeReduction/Research/E7ResidualStatus.lean",
        "HodgeReduction/Research/E7ThetaModularity.lean",
        "HodgeReduction/Research/FibreTransfer.lean",
        "HodgeReduction/Research/HBundleStatus.lean",
        "HodgeReduction/Research/LatticeGap.lean",
        "HodgeReduction/Research/MainTheoremInputStatus.lean",
        "HodgeReduction/Research/MainTheoremResidualStatus.lean",
        "HodgeReduction/Research/MokCircularity.lean",
        "HodgeReduction/Research/OmegaDiagonal.lean",
        "HodgeReduction/Research/PadicDescent.lean",
        "HodgeReduction/Research/Q4AbelianAlgebraicity.lean",
        "HodgeReduction/Research/ShimuraTypeFibre.lean",
        "HodgeReduction/Research/WitnessLatticeHypothesis.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/FullHodgeGoal.lean",
        "HodgeReduction/AxiomInventory.lean",
        "HodgeReduction/MainChain.lean"
      ]
      decls := [
        "HodgeReduction.PaperInventory.canonicalMasterSource",
        "HodgeReduction.PaperInventory.archivedBackgroundSources",
        "HodgeReduction.PaperInventory.allSources",
        "HodgeReduction.PaperInventory.knownSourceIds",
        "HodgeReduction.PaperInventory.sourceIdIsKnown",
        "HodgeReduction.PaperInventory.masterClaimsWithUnknownSourceIdCount",
        "HodgeReduction.PaperInventory.allMasterClaimSourceIdsKnown",
        "HodgeReduction.PaperInventory.masterClaimsOutsideCanonicalSourceCount",
        "HodgeReduction.PaperInventory.allMasterClaimsUseCanonicalMasterSource",
        "HodgeReduction.PaperInventory.canonicalMasterSourcePathIsMasterTex",
        "HodgeReduction.PaperInventory.canonicalMasterSourceRoleIsCanonical",
        "HodgeReduction.PaperInventory.archivedBackgroundSourceCount",
        "HodgeReduction.PaperInventory.allArchivedBackgroundSourcesHaveArchiveRole",
        "HodgeReduction.PaperInventory.MasterSourceDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.masterEnvironmentIndex",
        "HodgeReduction.PaperInventory.masterEnvironmentCount",
        "HodgeReduction.PaperInventory.environmentCoveringClaims",
        "HodgeReduction.PaperInventory.environmentCoveringClaimCount",
        "HodgeReduction.PaperInventory.allMasterEnvironmentsHaveUniqueClaim",
        "HodgeReduction.PaperInventory.masterEnvironmentsWithoutUniqueClaimCount",
        "HodgeReduction.PaperInventory.allClaimedMasterEnvironmentKindsMatch",
        "HodgeReduction.PaperInventory.masterEnvironmentsWithKindMismatchCount",
        "HodgeReduction.PaperInventory.masterClaimsNotCoveringMasterEnvironmentCount",
        "HodgeReduction.PaperInventory.MasterEnvironmentCoverageDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.masterClaims",
        "HodgeReduction.PaperInventory.openHypothesisClaims",
        "HodgeReduction.PaperInventory.registeredGapClaims",
        "HodgeReduction.PaperInventory.needsTriageClaims",
        "HodgeReduction.PaperInventory.formalizedClaims",
        "HodgeReduction.PaperInventory.provenInPaperClaims",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaims",
        "HodgeReduction.PaperInventory.externalCitationClaims",
        "HodgeReduction.PaperInventory.openResidualClaims",
        "HodgeReduction.PaperInventory.archiveOnlyClaims",
        "HodgeReduction.PaperInventory.ClaimAuditTag",
        "HodgeReduction.PaperInventory.effectiveAuditTags",
        "HodgeReduction.PaperInventory.kernelOnlyLeanClaims",
        "HodgeReduction.PaperInventory.kernelOnlyLeanClaimCount",
        "HodgeReduction.PaperInventory.paperProofNotKernelPortedClaims",
        "HodgeReduction.PaperInventory.paperProofNotKernelPortedClaimCount",
        "HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaims",
        "HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaimCount",
        "HodgeReduction.PaperInventory.newMathGapClaims",
        "HodgeReduction.PaperInventory.newMathGapClaimCount",
        "HodgeReduction.PaperInventory.migrationDebtClaims",
        "HodgeReduction.PaperInventory.migrationDebtClaimCount",
        "HodgeReduction.PaperInventory.claimIds",
        "HodgeReduction.PaperInventory.claimReferencesGapId",
        "HodgeReduction.PaperInventory.masterClaimsForGapId",
        "HodgeReduction.PaperInventory.masterClaimIdsForGapId",
        "HodgeReduction.PaperInventory.registeredGapClaimIds",
        "HodgeReduction.PaperInventory.openHypothesisClaimIds",
        "HodgeReduction.PaperInventory.openResidualClaimIds",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaimIds",
        "HodgeReduction.PaperInventory.paperProofNotKernelPortedClaimIds",
        "HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaimIds",
        "HodgeReduction.PaperInventory.newMathGapClaimIds",
        "HodgeReduction.PaperInventory.migrationDebtClaimIds",
        "HodgeReduction.PaperInventory.MasterClaimWorklistSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimWorklistSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimWorklistSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.untaggedMasterClaimCount",
        "HodgeReduction.PaperInventory.allMasterClaimsHaveEffectiveAuditTag",
        "HodgeReduction.PaperInventory.claimedMasterEnvironments",
        "HodgeReduction.PaperInventory.unclaimedMasterEnvironments",
        "HodgeReduction.PaperInventory.masterClaimCount",
        "HodgeReduction.PaperInventory.formalizedClaimCount",
        "HodgeReduction.PaperInventory.provenInPaperClaimCount",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaimCount",
        "HodgeReduction.PaperInventory.externalCitationClaimCount",
        "HodgeReduction.PaperInventory.registeredGapClaimCount",
        "HodgeReduction.PaperInventory.claimedMasterEnvironmentCount",
        "HodgeReduction.PaperInventory.unclaimedMasterEnvironmentCount",
        "HodgeReduction.PaperInventory.openResidualClaimCount",
        "HodgeReduction.PaperInventory.archiveOnlyClaimCount",
        "HodgeReduction.PaperInventory.claimHasMachineCorrespondence",
        "HodgeReduction.PaperInventory.claimsWithoutMachineCorrespondence",
        "HodgeReduction.PaperInventory.claimsWithoutMachineCorrespondenceCount",
        "HodgeReduction.PaperInventory.allMasterClaimsHaveMachineCorrespondence",
        "HodgeReduction.PaperInventory.claimHasLeanDecl",
        "HodgeReduction.PaperInventory.claimHasGapId",
        "HodgeReduction.PaperInventory.formalizedClaimsWithoutLeanDeclCount",
        "HodgeReduction.PaperInventory.allFormalizedClaimsHaveLeanDecl",
        "HodgeReduction.PaperInventory.kernelOnlyClaimsWithoutLeanDeclCount",
        "HodgeReduction.PaperInventory.allKernelOnlyClaimsHaveLeanDecl",
        "HodgeReduction.PaperInventory.registeredGapClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allRegisteredGapClaimsHaveGapId",
        "HodgeReduction.PaperInventory.openHypothesisClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allOpenHypothesisClaimsHaveGapId",
        "HodgeReduction.PaperInventory.openResidualClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allOpenResidualClaimsHaveGapId",
        "HodgeReduction.PaperInventory.newMathGapClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allNewMathGapClaimsHaveGapId",
        "HodgeReduction.PaperInventory.MasterClaimTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.claimHasEffectiveAuditTagValue",
        "HodgeReduction.PaperInventory.claimHasAnyOpenOrUnportedTag",
        "HodgeReduction.PaperInventory.formalizedClaimsWithOpenOrUnportedTagCount",
        "HodgeReduction.PaperInventory.allFormalizedClaimsAvoidOpenOrUnportedTags",
        "HodgeReduction.PaperInventory.openHypothesisClaimsWithoutNewMathGapTagCount",
        "HodgeReduction.PaperInventory.allOpenHypothesisClaimsTaggedNewMathGap",
        "HodgeReduction.PaperInventory.openResidualClaimsWithoutNewMathGapTagCount",
        "HodgeReduction.PaperInventory.allOpenResidualClaimsTaggedNewMathGap",
        "HodgeReduction.PaperInventory.registeredGapClaimsWithoutMigrationDebtTagCount",
        "HodgeReduction.PaperInventory.allRegisteredGapClaimsTaggedMigrationDebt",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount",
        "HodgeReduction.PaperInventory.allConditionalMilestoneClaimsTaggedConditionalLeanPackage",
        "HodgeReduction.PaperInventory.MasterClaimDispositionTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterBrokenLinkDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterSubgapStatusMarkerSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterPrimaryHypothesisSnapshot",
        "HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot",
        "HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterScopeSubclassStatusSnapshot",
        "HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot",
        "HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.ProjectAxiomTrustBaseSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus",
        "HodgeReduction.AxiomInventory.ProjectSorryAxSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero",
        "HodgeReduction.MainChain.routeGapIds",
        "HodgeReduction.MainChain.gapIdIsRouteRegistered",
        "HodgeReduction.MainChain.masterClaimGapReferenceIds",
        "HodgeReduction.MainChain.masterClaimGapReferenceCount",
        "HodgeReduction.MainChain.unregisteredMasterClaimGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredMasterClaimGapReferenceCount",
        "HodgeReduction.MainChain.masterClaimsWithUnregisteredGapIds",
        "HodgeReduction.MainChain.masterClaimsWithUnregisteredGapIdCount",
        "HodgeReduction.MainChain.allMasterClaimGapReferencesRegisteredInRoute",
        "HodgeReduction.MainChain.MasterClaimGapReferenceSnapshot",
        "HodgeReduction.MainChain.currentMasterClaimGapReferenceSnapshot",
        "HodgeReduction.MainChain.currentMasterClaimGapReferenceSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterAuditSnapshot",
        "HodgeReduction.PaperInventory.currentMasterAuditSnapshot",
        "HodgeReduction.PaperInventory.currentMasterAuditSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.routeLevelGapCount",
        "HodgeReduction.MainChain.routeLevelFinalOpenGapCount",
        "HodgeReduction.MainChain.routeLevelInProgressGapCount",
        "HodgeReduction.MainChain.routeLevelConditionalGapCount",
        "HodgeReduction.MainChain.routeLevelOpenGapCount",
        "HodgeReduction.MainChain.routeLevelDeferredGapCount",
        "HodgeReduction.MainChain.routeLevelActiveOpenGapCount",
        "HodgeReduction.MainChain.RouteGapStatusSnapshot",
        "HodgeReduction.MainChain.currentRouteGapStatusSnapshot",
        "HodgeReduction.MainChain.RouteGapStatusEntry",
        "HodgeReduction.MainChain.routeGapStatusLedger",
        "HodgeReduction.MainChain.gapStatusOf?",
        "HodgeReduction.MainChain.currentRouteGapStatusSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.routeGapStatusLedger_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutNames",
        "HodgeReduction.MainChain.endpointOpenCutCount",
        "HodgeReduction.MainChain.expectedEndpointOpenCutNames",
        "HodgeReduction.MainChain.expectedEndpointOpenCutCount",
        "HodgeReduction.MainChain.endpointOpenCutLedgerMatchesTexStatus",
        "HodgeReduction.MainChain.endpointOpenCutCountMatchesTexStatus",
        "HodgeReduction.MainChain.EndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutCount_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignment",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments_eq_texStatus",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignmentFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutPaperCoverageFailureCount",
        "HodgeReduction.MainChain.MasterRouteGapClaimEntry",
        "HodgeReduction.MainChain.masterRouteGapClaimLedger",
        "HodgeReduction.MainChain.masterRouteGapClaimLedgerClaimReferenceCount",
        "HodgeReduction.MainChain.currentMasterRouteGapClaimLedger_eq_texStatus",
        "HodgeReduction.MainChain.masterRouteGapClaimLedgerClaimReferenceCount_eq_masterClaimGapReferenceCount",
        "HodgeReduction.MainChain.masterRouteGapRowsWithMasterClaims",
        "HodgeReduction.MainChain.masterRouteGapRowsWithoutMasterClaims",
        "HodgeReduction.MainChain.masterRouteGapIdsWithoutMasterClaims",
        "HodgeReduction.MainChain.masterRouteGapRowsWithoutMasterClaimsAreExpectedStructuralInfra",
        "HodgeReduction.MainChain.MasterRouteGapClaimCoverageSnapshot",
        "HodgeReduction.MainChain.currentMasterRouteGapClaimCoverageSnapshot",
        "HodgeReduction.MainChain.currentMasterRouteGapClaimCoverageSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.masterRouteGapClaimCoverageFailureCount",
        "HodgeReduction.MainChain.fullHcGapStatus_eq_finalOpen",
        "HodgeReduction.MainChain.fullHcNarrativeClaimsCompleteProof",
        "HodgeReduction.MainChain.PaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot_eq_texStatus",
        "HodgeReduction.MainChain.fullHcCompletionOverclaimCount",
        "HodgeReduction.MainChain.fullHcFinalOpenStatusFailureCount",
        "HodgeReduction.MainChain.masterClaimTagPointerFailureCount",
        "HodgeReduction.MainChain.masterClaimDispositionTagMismatchCount",
        "HodgeReduction.MainChain.masterBrokenLinkDisciplineFailureCount",
        "HodgeReduction.MainChain.masterSubgapStatusMarkerFailureCount",
        "HodgeReduction.MainChain.masterPrimaryHypothesisDisciplineFailureCount",
        "HodgeReduction.MainChain.scopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceCount",
        "HodgeReduction.MainChain.allScopeSubclassRouteGapReferencesRegisteredInRoute",
        "HodgeReduction.MainChain.masterScopeSubclassStatusFailureCount",
        "HodgeReduction.MainChain.projectAxiomTrustBaseFailureCount",
        "HodgeReduction.MainChain.projectSorryAxFailureCount",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero",
        "HodgeReduction.MainChain.masterSourceDisciplineFailureCount",
        "HodgeReduction.MainChain.masterEnvironmentCoverageFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount_eq_zero",
        "HodgeReduction.PaperInventory.openHypothesisCount",
        "HodgeReduction.PaperInventory.needsTriageCount",
        "HodgeReduction.RanCoherenceInputData",
        "HodgeReduction.RanCoherenceInputData.coherence_lemma_from_oka_and_bbt_definable_oka",
        "HodgeReduction.RanCoherenceInputData.input_ran_from_coherence_lemma",
        "HodgeReduction.oka_coherence_does_not_self_close_ran_input",
        "HodgeReduction.CMDensityInputData",
        "HodgeReduction.CMDensityInputData.cm_density_in_special_subvariety_from_tsimerman",
        "HodgeReduction.CMDensityInputData.cm_density_in_hodge_locus_from_special_component",
        "HodgeReduction.specialness_does_not_self_close_cm_density",
        "HodgeReduction.PeterzilStarchenkoInputData",
        "HodgeReduction.PeterzilStarchenkoInputData.definable_closed_analytic_subset_is_algebraic",
        "HodgeReduction.definable_analytic_set_does_not_self_close_algebraicity",
        "HodgeReduction.VoisinIntegralCounterexampleData",
        "HodgeReduction.VoisinIntegralCounterexampleData.integral_hodge_counterexample_from_voisin",
        "HodgeReduction.VoisinIntegralCounterexampleData.voisin_integral_failure_does_not_contradict_rational_target",
        "HodgeReduction.integral_hc_failure_alone_does_not_self_close_rational_scope",
        "HodgeReduction.MargulisConditionalData",
        "HodgeReduction.MargulisConditionalData.arithmeticity_if_monodromy_is_lattice",
        "HodgeReduction.MargulisConditionalData.representation_extension_if_monodromy_is_lattice",
        "HodgeReduction.margulis_rank_inputs_do_not_self_close_without_lattice_hypothesis",
        "HodgeReduction.RationalScalarExtensionDescentData.padic_descent_linear_algebra_core",
        "HodgeReduction.WitnessLatticeHypothesis",
        "HodgeReduction.WitnessLatticeHypothesis.orthogonalComplement_signature_eq_p_two",
        "HodgeReduction.MonodromyLatticeContainmentData",
        "HodgeReduction.containment_in_arithmetic_lattice_does_not_force_finite_covolume",
        "HodgeReduction.ShimuraTypeFibreData",
        "HodgeReduction.ShimuraTypeFibreData.invariant_classes_realized_through_map",
        "HodgeReduction.aniso_empty_isotropic_core",
        "HodgeReduction.CMFibreDensityData",
        "HodgeReduction.CMFibreDensityData.shimura_fibre_density_from_transport",
        "HodgeReduction.cm_density_alone_does_not_force_e7_family_density",
        "HodgeReduction.RankTwoCMCY3CorrespondenceData",
        "HodgeReduction.RankTwoCMCY3CorrespondenceData.algebraicity_from_rank_two_cm_cy3_hypothesis",
        "HodgeReduction.blasius_deligne_do_not_self_close_cm_cy3_correspondence",
        "HodgeReduction.MotivicSpanData",
        "HodgeReduction.MotivicSpanData.rigid_nonabelian_cm_subcase_from_motivic_span",
        "HodgeReduction.cm_correspondence_does_not_self_close_motivic_span",
        "HodgeReduction.AbelianTypeCoverageData",
        "HodgeReduction.AbelianTypeCoverageData.abelian_type_coverage_from_hc_cm_and_ran",
        "HodgeReduction.hc_cm_abelian_does_not_self_close_abelian_type_coverage",
        "HodgeReduction.KugaSatakeP3Data",
        "HodgeReduction.KugaSatakeP3Data.ks_p3_from_spin_hodge_and_correspondence",
        "HodgeReduction.spin_abs_periodicity_does_not_self_close_ks_p3",
        "HodgeReduction.AbsoluteHodgeDescentData",
        "HodgeReduction.AbsoluteHodgeDescentData.ahd_from_wlh_hodge_locus_principleB_and_hcab",
        "HodgeReduction.hc_ab_and_hodge_locus_do_not_self_close_ahd",
        "HodgeReduction.GLBOrthClosureData",
        "HodgeReduction.GLBOrthClosureData.glb_orth_from_meyer_ahd_ks_and_hcab",
        "HodgeReduction.GLBOrthClosureData.orthogonal_coverage_from_glb_orth",
        "HodgeReduction.meyer_input_does_not_self_close_glb_orth",
        "HodgeReduction.GenericFibreInvariantData",
        "HodgeReduction.GenericFibreInvariantData.generic_fibre_invariant_from_full_package",
        "HodgeReduction.invariant_theory_and_chern_classes_do_not_self_close_generic_fibre",
        "HodgeReduction.SatakeAbelianClassificationData",
        "HodgeReduction.SatakeAbelianClassificationData.exceptional_eiii_evii_not_abelian_type",
        "HodgeReduction.exceptional_label_does_not_self_close_satake_classification",
        "HodgeReduction.E7ApproachFTotalSpaceData",
        "HodgeReduction.E7ApproachFTotalSpaceData.total_space_class_from_chern_weil_bridge",
        "HodgeReduction.approach_f_total_space_does_not_self_close_fibre_level_class",
        "HodgeReduction.CMEigenvalueSeparationData",
        "HodgeReduction.CMEigenvalueSeparationData.abelian_type_eigenvalue_separation_from_honda_tate",
        "HodgeReduction.CMEigenvalueSeparationData.nonabelian_e7_eigenvalue_separation_from_honda_tate_extension",
        "HodgeReduction.abelian_honda_tate_does_not_self_close_nonabelian_e7_eigenvalue_separation",
        "HodgeReduction.E7ArithmeticityStep1Data",
        "HodgeReduction.E7ArithmeticityStep1Data.arithmeticity_from_all_inputs",
        "HodgeReduction.e7_arithmeticity_not_from_boundary_data_alone",
        "HodgeReduction.BBTRigidReachData",
        "HodgeReduction.BBTRigidReachData.rigid_isolated_reach_from_full_package",
        "HodgeReduction.bbt_frameworks_do_not_self_close_rigid_isolated_reach",
        "HodgeReduction.NonRigidFamilyBridgeData",
        "HodgeReduction.NonRigidFamilyBridgeData.base_dimension_from_period_package",
        "HodgeReduction.NonRigidFamilyBridgeData.nonrigid_family_bridge_from_full_period_package",
        "HodgeReduction.nonrigidity_does_not_self_close_period_family_bridge",
        "HodgeReduction.E7BBTSpreadingData",
        "HodgeReduction.E7BBTSpreadingData.e7_bbt_spreading_from_full_package",
        "HodgeReduction.E7BBTSpreadingData.individual_scope_transfer_from_family_spreading_and_bridges",
        "HodgeReduction.bbt_cm_density_do_not_self_close_e7_bbt_spreading",
        "HodgeReduction.family_spreading_does_not_self_close_individual_e7_scope",
        "HodgeReduction.E7CMAlgebraicityData",
        "HodgeReduction.E7CMAlgebraicityData.absolute_hodge_from_nonabelian_e7_extension",
        "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_absolute_hodge_and_hbundle",
        "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_full_package",
        "HodgeReduction.abelian_frameworks_do_not_self_close_nonabelian_e7_absolute_hodge",
        "HodgeReduction.absolute_hodge_does_not_self_close_cm_e7_algebraicity",
        "HodgeReduction.E7ChernWeilBridgeData",
        "HodgeReduction.E7ChernWeilBridgeData.compact_dual_nonzero_from_schwarz_bridge",
        "HodgeReduction.E7ChernWeilBridgeData.toroidal_class_from_matsushima_descent",
        "HodgeReduction.E7ChernWeilBridgeData.algebraicity_from_chern_polynomial_identity",
        "HodgeReduction.E7ChernWeilBridgeData.e7_chern_weil_algebraicity_from_full_bridge",
        "HodgeReduction.schwarz_invariant_ring_does_not_self_close_e7_chern_weil",
        "HodgeReduction.cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil",
        "HodgeReduction.ExoticE7NarrowingData",
        "HodgeReduction.ExoticE7NarrowingData.exotic_residual_narrowed_from_geometric_eliminations",
        "HodgeReduction.exotic_narrowing_does_not_self_close_residual",
        "HodgeReduction.TorelliEVIIQuestionData",
        "HodgeReduction.TorelliEVIIQuestionData.exotic_rigid_vacuity_from_evii_uniformisation",
        "HodgeReduction.arithmeticity_and_mok_do_not_self_close_torelli_evii",
        "HodgeReduction.ExoticE7ResidualData",
        "HodgeReduction.ExoticE7ResidualData.exotic_residual_eliminated_from_all_subbranches",
        "HodgeReduction.known_e7_cases_do_not_self_close_exotic_residual",
        "HodgeReduction.FullHCResidualGateData",
        "HodgeReduction.FullHCResidualGateData.full_hodge_conjecture_from_residual_gate",
        "HodgeReduction.r612ScopeOrComplementResidualGateData",
        "HodgeReduction.fullHodgeConjectureReal_from_r612ResidualGate",
        "HodgeReduction.R613ResidualGateRouteSnapshot",
        "HodgeReduction.currentR613ResidualGateRouteSnapshot",
        "HodgeReduction.currentR613ResidualGateRouteSnapshot_eq_texStatus",
        "HodgeReduction.E7ResidualStrategyData",
        "HodgeReduction.E7ResidualStrategyData.residual_hc_from_theta_transfer",
        "HodgeReduction.E7ResidualStrategyData.residual_hc_from_padic_route",
        "HodgeReduction.E7ResidualStrategyData.residual_hc_from_bost_charles_route",
        "HodgeReduction.theta_shimura_cycle_does_not_self_close_residual_hc",
        "HodgeReduction.padic_descent_does_not_self_close_residual_hc",
        "HodgeReduction.bost_charles_framework_does_not_self_close_residual_hc",
        "HodgeReduction.OmegaDiagonalData",
        "HodgeReduction.OmegaDiagonalData.cohomological_identity_from_standard_conjecture_package",
        "HodgeReduction.OmegaDiagonalData.omega_algebraic_from_diagonal_standard_conjectures_and_schur",
        "HodgeReduction.OmegaDiagonalData.schur_projector_step_iff_omega_algebraicity",
        "HodgeReduction.standard_conjecture_pair_does_not_self_close_omega_diagonal",
        "HodgeReduction.andre_motivated_closure_does_not_self_close_chow_omega",
        "HodgeReduction.E7ChowModularityData",
        "HodgeReduction.E7ChowModularityData.chow_modularity_from_full_package",
        "HodgeReduction.ThetaIsChowModular",
        "HodgeReduction.IsExceptionalE7ChowModularityExtension_CONJECTURAL",
        "HodgeReduction.orthogonal_chow_frameworks_do_not_self_close_exceptional_e7_chow_modularity",
        "HodgeReduction.E7ThetaModularityData",
        "HodgeReduction.E7ThetaModularityData.cohomological_theta_modularity_from_kernel",
        "HodgeReduction.E7ThetaModularityData.e7_chow_modularity_from_full_package",
        "HodgeReduction.cohomological_theta_does_not_self_close_chow_valued_e7_modularity",
        "HodgeReduction.E7ThetaMatchData",
        "HodgeReduction.E7ThetaMatchData.theta_match_from_full_package",
        "HodgeReduction.E7ThetaMatchData.nonzero_algebraic_theta_cycle_from_match",
        "HodgeReduction.chow_modularity_and_theta_framework_do_not_self_close_theta_match",
        "HodgeReduction.E7ThetaStepIIIData",
        "HodgeReduction.E7ThetaStepIIIData.shimura_side_cycle_seeding_from_theta_package",
        "HodgeReduction.E7ThetaStepIIIData.hbundle_cycle_seeding_from_theta_and_fibre_transfer",
        "HodgeReduction.shimura_side_theta_cycle_does_not_self_close_fibre_transfer",
        "HodgeReduction.HBundleMatchingData",
        "HodgeReduction.HBundleMatchingData.bundle_matching_from_rigid_point_case",
        "HodgeReduction.HBundleMatchingData.bundle_matching_from_toroidal_reduction_package",
        "HodgeReduction.known_hbundle_cases_do_not_self_close_arbitrary_nontoroidal_boundary",
        "HodgeReduction.HBundleCycleSeedingData",
        "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_low_dimensional_lefschetz",
        "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_nonrigid_e7_package",
        "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_known_rigid_e7_package",
        "HodgeReduction.low_dimensional_hbundle_does_not_self_close_high_dimensional_residual",
        "HodgeReduction.HBundleInputData",
        "HodgeReduction.HBundleInputData.hbundle_input_from_matching_and_cycle_seeding",
        "HodgeReduction.bundle_matching_does_not_self_close_hbundle_input",
        "HodgeReduction.FibreTransferData",
        "HodgeReduction.FibreTransferData.base_level_algebraicity_from_shimura_side",
        "HodgeReduction.shimura_side_and_period_map_do_not_self_close_fibre_algebraicity",
        "HodgeReduction.E7FibreInvariantClassSplitData",
        "HodgeReduction.E7FibreInvariantClassSplitData.all_invariant_classes_from_h3_algebraicity",
        "HodgeReduction.motivated_h3_class_does_not_self_close_algebraicity",
        "HodgeReduction.Q4AbelianAlgebraicityData",
        "HodgeReduction.Q4AbelianAlgebraicityData.pointwise_q4_algebraicity_from_cm_abelian_bridge",
        "HodgeReduction.Q4AbelianAlgebraicityData.global_q4_algebraicity_from_full_transfer",
        "HodgeReduction.pointwise_q4_algebraicity_does_not_self_close_global_e7",
        "HodgeReduction.MokTorelliConditionalShape",
        "HodgeReduction.mok_conditional_does_not_self_close_torelli"
      ]
    },
    {
      id := "G-main-hc"
      title := "Hodge conjecture headline remains axiom-relative"
      status := "conditional"
      summary :=
        "The `hodgeConjectureReal_canonical` endpoint is a kernel-pure composition once the canonical target variety and its two E7-scope facts are accepted.  R542 derives the full `canonicalMTPackageAt` from the generic R517/R532 MT-witness route; R545 splits the chosen-witness package into a codim-one first target plus the remaining non-codim-one lift; R549 opens that codim-one target into Hodge-morphism, algebraic-map, commuting-square, and Hodge-surjectivity component cuts; R550 routes the separately audited codim-one HC slice directly through the classical Lefschetz (1,1) cut; R551 splits the full canonical proof by codimension so the `p = 1` branch no longer consumes the E7 -> CM package and the `p 鈮?1` branch consumes only the non-codim-one MT lift.  R551 also states the endpoint directly on canonical cohomology/algebraic-class data so the theorem type itself does not pull the legacy all-codim package.  Full HC is NOT unconditional."
      files := [
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/Types.lean",
        "HodgeReduction/HCGapRegistry.lean"
      ]
      decls := [
        "HodgeReduction.CanonicalHCData",
        "HodgeReduction.CanonicalHCDataByCodim",
        "HodgeReduction.canonicalTargetVariety",
        "HodgeReduction.canonicalTargetE7Factor",
        "HodgeReduction.canonicalTargetInKnownE7Scope",
        "HodgeReduction.canonicalTargetCohomologyData",
        "HodgeReduction.canonicalTargetAlgClassesData",
        "HodgeReduction.canonicalMTPackageAt",
        "HodgeReduction.canonicalMTPackageAt_codim1",
        "HodgeReduction.canonicalMTPackageAt_non_codim1",
        "HodgeReduction.canonicalHCDataByCodim",
        "HodgeReduction.hodgeConjectureReal_from_canonicalHCData",
        "HodgeReduction.hodgeConjectureReal_from_canonicalHCDataByCodim",
        "HodgeReduction.lefschetz_11_hc_real_at_codim1",
        "HodgeReduction.lefschetz_11_hc_real_at_codim1_cm",
        "HodgeReduction.hyp_HC_CM_Ab_real_codim1_via_lefschetz11",
        "HodgeReduction.hodgeConjectureReal_canonical_codim1",
        "HodgeReduction.hodgeConjectureReal_canonical"
      ]
    },
    {
      id := "G-l1-e7-shimura-tor"
      title := "Layer 1: true E_{7(-25)}-type Shimura toroidal compactification"
      status := "open"
      summary :=
        "AMRT 1975 / Baily--Borel 1966 construction of S_铻昢tor as a SmoothProjectiveVariety --  Required Mathlib infrastructure: arithmetic groups, Hermitian symmetric domains, toroidal compactifications."
      files := [
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/HCGapRegistry.lean",
        "HodgeReduction/Infrastructure/Shimura/ToroidalCompactification.lean",
        "HodgeReduction/Infrastructure/Shimura/HermitianSymmetric.lean",
        "HodgeReduction/Infrastructure/Shimura/ArithmeticGroup.lean"
      ]
      decls := [
        "HodgeReduction.HCGapRegistry.L1_G1_E7ShimuraTor_Inhabited",
        "HodgeReduction.E7ShimuraTor"
      ]
    },
    {
      id := "G-l2-cohomology-construction"
      title := "Layer 2: VarietyCohomologyData from a non-toy underlying variety"
      status := "open"
      summary :=
        "Construction of `VarietyCohomologyData` whose `H k` is the actual rational singular cohomology of `S_铻昢tor` at degree `k`, with `hodgeStructure k` the actual pure Hodge structure of weight `k` on `H^k(S_铻昢tor, --`.  Required Mathlib infrastructure: singular cohomology, Dolbeault decomposition, Hodge theorem for compact K鐩瞙ler manifolds."
      files := [
        "HodgeReduction/HCGapRegistry.lean",
        "HodgeReduction/Infrastructure/HodgeStructure/VarietyCohomology.lean",
        "HodgeReduction/Infrastructure/Cohomology/SheafCohomology.lean",
        "HodgeReduction/HCGapL2/TrivialPoint.lean",
        "HodgeReduction/HCGapL2/ProjectiveLine.lean",
        "HodgeReduction/HCGapL2/EllipticCurve.lean"
      ]
      decls := [
        "HodgeReduction.HCGapRegistry.L2_G1_VarietyCohomologyData_Constructed_NonToy",
        "HodgeReduction.HCGapRegistry.L2_G2_E7CanonicalCohomology_MatchesPaper",
        "HodgeReduction.SmoothProjectiveVariety.cohomology"
      ]
    },
    {
      id := "G-l3-v56-mt-identification"
      title := "Layer 3: V_56 -- H^3(S_铻昢tor, -- Hodge-structure identification"
      status := "open"
      summary :=
        "The H^3 piece of `S.cohomologyOfUnderlying` is identified with the 56-dimensional minuscule E_7-representation V_56 as a polarisable pure --Hodge structure of weight 3 with Hodge numbers (1, 27, 27, 1).  The V_56 side is kernel-pure (`V56Instance.instPureHodgeStructure_V56`); the identification is the open gap.  Required Mathlib infrastructure: Matsushima isomorphism, Borel--Wallach relative Lie-algebra cohomology, Vogan--Zuckerman 1984."
      files := [
        "HodgeReduction/HCGapRegistry.lean",
        "HodgeReduction/Infrastructure/HodgeStructure/V56Instance.lean",
        "HodgeReduction/Infrastructure/V56HodgeDecomp.lean",
        "HodgeReduction/Infrastructure/Automorphic/VoganZuckerman.lean",
        "HodgeReduction/Infrastructure/Cohomology/Matsushima.lean"
      ]
      decls := [
        "HodgeReduction.HCGapRegistry.L3_G1_V56_PureHodgeStructure_W3_HodgeDiamond",
        "HodgeReduction.HCGapRegistry.L3_G2_V56_To_E7_Variety_Cohomology_Identification"
      ]
    },
    {
      id := "G-l4-cm-abelian-hc"
      title := "Layer 4-G2: Hodge conjecture for CM abelian varieties (Deligne 1982)"
      status := "open"
      summary :=
        "R527/R515 decomposes the former broad `hyp_HC_CM_Ab_real` axiom into a theorem.  R535 narrows the remaining absolute-Hodge-to-algebraic bridge to CM abelian varieties, and R543 narrows the absolute-Hodge carrier itself to the same CM scope.  R547 adds a codim-one Lefschetz (1,1) bypass for CM sources; R550 widens that cut to the classical all-SPV Lefschetz theorem and derives the CM-scoped form from it.  The full CM-abelian HC surface remains the three CM-scoped cuts: carrier, Deligne 1982 Hodge-to-absolute-Hodge, and CM-scoped absolute-Hodge-to-algebraic bridge."
      files := [
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/HCGapL4/CMAbelianHCBridge.lean",
        "HodgeReduction/HCGapRegistry.lean",
        "HodgeReduction/Infrastructure/AbelianVariety/CMType.lean",
        "HodgeReduction/Infrastructure/AbelianVariety/KugaSatake.lean"
      ]
      decls := [
        "HodgeReduction.hyp_HC_CM_Ab_real",
        "HodgeReduction.absHodgeClassesAtDegreeCM",
        "HodgeReduction.deligne_1982_abs_hodge_cm",
        "HodgeReduction.abs_hodge_cm_implies_algebraic",
        "HodgeReduction.lefschetz_11_hc_real_at_codim1",
        "HodgeReduction.lefschetz_11_hc_real_at_codim1_cm",
        "HodgeReduction.hyp_HC_CM_Ab_real_codim1_via_lefschetz11",
        "HodgeReduction.HCGapRegistry.L4_G2_HC_For_CM_AbelianVariety"
      ]
    },
    {
      id := "G-l4-mt-correspondence"
      title := "Layer 4-G3: per-codim Mumford--Tate correspondence package (E_7 -> CM abelian)"
      status := "open"
      summary :=
        "R529/R517 decomposes the non-canonical MT correspondence witness; R532 tightens the package cut so it applies only to the witness selected by `e7_cm_witness_exists`, not to arbitrary CM abelian sources.  R545 splits that chosen-source package into the codim-one Chow-correspondence target and the remaining non-codim-one lift.  R549 decomposes the codim-one target into Hodge-morphism, algebraic-map, commuting-square, and Hodge-surjectivity cuts, so the audit can track exactly which piece of the first Chow-correspondence target remains open.  R550 shows the canonical codim-one HC endpoint itself should bypass this MT package entirely via Lefschetz (1,1).  R551 carries that bypass into the full canonical proof: the full endpoint no longer consumes the R549 codim-one component cuts, while the generic main-reduction theorem still consumes them through its all-scope E7 case."
      files := [
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/HCGapL4/MTWitnessDecomposition.lean",
        "HodgeReduction/HCGapRegistry.lean",
        "HodgeReduction/Infrastructure/HodgeStructure/MumfordTate.lean"
      ]
      decls := [
        "HodgeReduction.mt_correspondence_e7_witness_exists",
        "HodgeReduction.e7_cm_witness_exists",
        "HodgeReduction.e7_chosen_witness_correspondence_package_exists",
        "HodgeReduction.e7_chosen_witness_correspondence_package_codim1_exists",
        "HodgeReduction.e7_chosen_witness_hsm_codim1",
        "HodgeReduction.e7_chosen_witness_alg_map_codim1",
        "HodgeReduction.e7_chosen_witness_square_codim1",
        "HodgeReduction.e7_chosen_witness_hodge_surj_codim1",
        "HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists",
        "HodgeReduction.canonicalMTPackageAt_codim1",
        "HodgeReduction.canonicalMTPackageAt_non_codim1",
        "HodgeReduction.hodgeConjectureReal_canonical_codim1",
        "HodgeReduction.HCGapRegistry.L4_G3_MT_Correspondence_E7_To_CMAbelian",
        "HodgeReduction.HCGapRegistry.L34_FullPackage_For_E7Canonical"
      ]
    },
    {
      id := "G-classical-mathlib-port"
      title := "Classical published-literature axioms awaiting Mathlib port"
      status := "deferred"
      summary :=
        "Meyer / Kostant G_2 / Kostant F_4 / SV1 E_8 are already kernel-pure theorems (paper-grade proofs over R120/R121 structure refactor).  R534 decomposes the E6 branch through a chosen classical remainder plus transfer cut.  R533 decomposes `cy3_e7_nonexistence_paper_axiom` into Springer/V56, FTS omega, and J3(O) nonrealization stage cuts.  R530/R531 refines the CY3 reduction bridge with weak factor inheritance plus CY3 semisimplicity and CY3-scoped E7/E6 exclusivity."
      files := [
        "HodgeReduction/ClassicalResults.lean",
        "HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean",
        "HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean",
        "HodgeReduction/HCGapL4/CY3E7Bridge.lean",
        "HodgeReduction/HCGapL4/CY3VacuityDischarge.lean"
      ]
      decls := [
        "HodgeReduction.e6_classical_remainder_exists",
        "HodgeReduction.e6_remainder_transfer",
        "HodgeReduction.e6_factor_classical_transfer",
        "HodgeReduction.cy3_e7_nonexistence_paper_axiom",
        "HodgeReduction.cy3_e7_springer_stage",
        "HodgeReduction.cy3_e7_fts_omega_stage",
        "HodgeReduction.cy3_e7_j3o_nonrealization_stage",
        "HodgeReduction.cy3_inherits_e7_factor",
        "HodgeReduction.cy3_mtd_isSemisimple",
        "HodgeReduction.cy3_e7_excludes_e6",
        "HodgeReduction.cy3_e7_vacuity_via_bridge",
        "HodgeReduction.hc_real_cy3_reducible_via_vacuity"
      ]
    },
    {
      id := "G-hcgap-l4-multifront"
      title := "HCGapL4 multi-front Layer-4 attack waves (R420 -- R665)"
      status := "active-open"
      summary :=
        "Active exploratory attack waves on the L4 / cohomology-profile / connectedness pipeline: FrontA (Deligne H0 sheaf realization), FrontB (Baily--Borel connectedness), FrontC (E_7 low-degree Hodge numbers + Hodge polynomial algebra + all-degree rank adapter + EVII/V56/Shimura expected Betti profile), FrontD (E_7 -> CM Chow correspondence + Deligne 1982 minimal fragment), FrontE (real-carrier profile matching + R405 conditional transfer feed).  Audits R451 / R456 / R460 / R465 / R470 / R476 are wave-level summaries.  R552 certifies the expected Shimura Betti profile degree-by-degree from EVII compact-dual Hodge sums plus the isolated V56 degree-3 contribution; R553 ties that finite V56 contribution to the actual `PureHodgeStructure V56 3` infrastructure; R554 combines the Matsushima, Eisenstein, and cuspidal trivial-module infrastructure into an honest boundary theorem; R555 proves the Cartan compact-dual source bridge and reduces the R554 source equality to `surjectivity_source = source_invariants`; R556 turns both source/target boundary equalities into finite-dimensional containment plus finrank obligations, routing the target through the cuspidal trivial-module part; R557 proves the target containment follows from source containment by Matsushima equivariance and the surjectivity image equation; R558 proves target finrank is transported from source finrank by `j_q` injectivity and the Matsushima image equation; R559 rewrites the remaining source obligations through the compact-dual/Cartan source subspace; R560 gives a Lean countermodel showing those compact-dual obligations are not consequences of the current abstract interface; R561 proves that compact-dual exact image plus target-invariant exactness is enough to recover the R554/R559 boundary data; R562 proves target exactness follows from compact-dual exact image plus the compact-dual-to-trivial rank bridge; R563 proves compact-dual exact image is equivalent to `surjectivity_source = compactDual`; R564 proves the actual compact-dual `H8` carrier has rank one and reduces the rank bridge to `compactDual = H8` plus rank-one of `trivialModulePart`; R565 proves that the trivial-module rank-one fact follows from exact Cartan image equality `Submodule.map j_q trivialModuleGK_H8 = trivialModulePart`; R566 rewrites source equality and compactDual/H8 identification through the same Cartan H8 line; R567 proves by countermodel that those Cartan-line exactness statements are not consequences of the current abstract interface; R568 rewrites the exact Cartan image equality as scalar surjectivity by `j_q (r 鈥?h^4)` onto the trivial-module part, and shows the containment direction follows from compactDual = Cartan; R569 gives a countermodel showing compactDual = Cartan still does not force scalar surjectivity; R570 proves rank-one of the trivial-module part plus compactDual = Cartan does force exact Cartan image and scalar preimages; R571 reframes the surviving obligations as source equality, source-invariants/H8 equality, and target rank; R572 routes the target rank through the expected degree-8 Shimura Betti slot; R573 splits source-invariants/H8 into no-extra-source containment plus membership of the generator `h^4`, with a rank-one alternate criterion; R574 pushes those two source-carrier facts back to the compact-dual carrier: prove `compactDual <= H8` and prove `h^4` lies in compactDual; R575 rewrites those compact-dual carrier targets as the two Cartan/compactDual containments; R576 rewrites the remaining source equality as two source/Cartan containment directions and feeds all four Cartan containment directions into the same boundary package; R577 proves by countermodel that those four carrier containments still do not force the target expected-Betti rank; R578 routes the target rank through the degree-8 compact-dual Hodge-sum profile certified in FrontC11; R579 derives that target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from compactDual/Cartan two-sided containment plus scalar preimage surjectivity; R581 proves that target Hodge-sum rank and scalar-preimage surjectivity are equivalent once the four Cartan carrier directions are fixed; R582 rewrites the four Cartan carrier directions as source/compactDual H8 no-extra plus h^4 generator-membership splits; R583 collapses each H8 split to exact equality with H8; R584 translates those H8 equalities into Matsushima boundary language and proves target Hodge-sum rank is equivalent to `surjectivity_target = trivialModulePart`; R585 proves that, after `compactDual = H8`, this concrete boundary package is equivalent to the existing `MatsushimaV56BoundaryData`; R586 records a countermodel showing the H8 carrier equalities alone do not force the target boundary equality or boundary data; R587 isolates the remaining target boundary as the single reverse containment `trivialModulePart <= surjectivity_target`, and proves that this containment is also not forced by the abstract H8 carrier interface; R588 proves this reverse containment is exactly the element-level scalar-preimage statement `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta` once `source = H8`, with no finite-dimensional rank hypothesis; R589 proves that, under the two H8 carrier equalities, target boundary/scalar preimages/boundary data/target Hodge-sum are all equivalent to `finrank trivialModulePart = 1`, and the rank-one target is not forced by the abstract H8 carrier interface.  R590 proves the target expected-Betti rank is equivalent to that rank-one theorem, identifies boundary data with expected-Betti rank under the H8 carriers, and records that the H8 carrier interface still does not force the expected-Betti target.  R591 packages the exact residual obligation as the two H8 carrier equalities plus target-invariant rank one, and proves this package feeds the existing Matsushima boundary bridge.  R592 proves this rank-one residual package is equivalent to the scalar-preimage residual package.  R593 packages the equivalent target-boundary residual package and records that the abstract H8 carrier interface still does not force it.  R594 packages the same residual target as `compactDual = H8` plus the existing `MatsushimaV56BoundaryData` bridge.  R595 rewrites that residual bridge as `compactDual = H8`, compact-dual exact image, and target-invariant exactness.  R596 replaces that target-invariant exactness by the equivalent rank-one target `finrank trivialModulePart = 1` once compact-dual exact image is fixed.  R597 proves that this exact-image rank-one package is equivalent to Cartan-line source/compact-dual equalities plus `finrank trivialModulePart = 1`, exposing the live residual as Cartan H8 carrier exactness and target rank.  R598 rewrites that same residual as `surjectivity_source = source_invariants`, `source_invariants = H8`, and `finrank target_invariants = 1`.  R599 proves the R598 source-invariant package is directly equivalent to the earlier R591 H8/rank-one package, recovers the expected Betti-8 target rank from it, and records that `source_invariants = H8` alone still does not force the full residual.  R600 replaces the target-rank spelling inside that package by the expected-Betti-8 equality `finrank target_invariants = shimuraEVIIExpectedBetti 8`, proves equivalence with R598, and keeps the same obstruction visible.  R601 splits the source-invariants/H8 equality into the equivalent source-carrier targets `source_invariants <= H8` plus `h^4` membership, packages that split against the R600 expected-Betti target, and keeps the obstruction visible.  R602 moves that same residual to the equivalent compact-dual carrier targets `compactDual <= H8` plus `h^4` membership in `compactDual`, using the existing compactDual/source-invariants comparison and preserving the obstruction.  R603 proves this R602 package is equivalent to the four Cartan containment directions together with the same target expected-Betti theorem, and preserves the R577 obstruction that the carrier directions alone do not force target rank.  R604 splits the R603 residual into a four-direction carrier obligation and one independent target expected-Betti obligation, and certifies the paper-facing primitive target count as 5 without making a closure claim.  R605 proves that the fifth primitive target is equivalently available as scalar-preimage surjectivity once the four carrier directions are fixed, and records that carrier facts alone still do not force scalar preimages.  R606 flattens the same residual into the five named paper-facing primitive targets and kernel-checks that expected-Betti rank and scalar preimage are not counted separately.  R607 proves that the five paper-facing primitive targets are equivalent to the three proof-work obligations `surjectivity_source = CartanH8`, `compactDual = CartanH8`, and scalar-preimage surjectivity.  R608 reconciles scalar-preimage surjectivity with the older `finrank trivialModulePart = 1` rank-one target under the two Cartan-line equalities, so those spellings are not separate gaps.  R609 proves that the two Cartan-line carrier equalities alone do not force the scalar/rank-one target in the current abstract interface.  R610 packages the exact live proof-work contract as those two equalities plus one scalar/rank-one target, proves it is equivalent to the R607/R608 residual ledgers, and records that the contract is not a closure claim.  R634 rewrites that same contract as the source-invariant scalar contract `surjectivity_source = source_invariants`, `source_invariants = H8`, plus scalar/rank-one target, without adding finite-dimensional rank conversion or closure claim.  R635 replaces the first R634 equality by the equivalent exact-image equation `Submodule.map j_q source_invariants = surjectivity_target`, using only the existing Matsushima image equation and injectivity.  R636 replaces the scalar/rank-one target by the equivalent reverse target containment `trivialModulePart <= surjectivity_target` once exact image and `source_invariants = H8` are fixed.  R637 records the matching obstruction: those exact-image carriers do not force the reverse target containment in the current abstract interface.  R638 rewrites that target theorem as exact target-invariant saturation: under the R636 exact-image carrier, prove `Submodule.map j_q source_invariants = target_invariants`; the same countermodel shows the carrier side alone does not force this equality.  R639 reduces that saturation theorem to the finite-dimensional invariant-rank target `finrank source_invariants = finrank target_invariants`, proving both directions under finite target invariants and preserving the same carrier countermodel.  R640 reconciles that rank criterion with the existing R600 expected-Betti residual: under `source_invariants = H8`, the rank match is exactly `finrank target_invariants = shimuraEVIIExpectedBetti 8`, so R639 does not create a duplicate independent target gap.  R641 rewrites the same target side as vanishing of the target-invariant excess quotient by `Submodule.map j_q source_invariants`, equivalent to R638 saturation and, under `source_invariants = H8`, to the R600 expected-Betti target.  R642 identifies the kernel of this quotient map as the source-invariant image inside `target_invariants`, proves range/kernel rank-nullity, and turns quotient vanishing into codimension zero for that internal subspace.  R643 makes the codimension target numerical: prove `finrank targetInvariantExcessQuotient = 0`, equivalently the R600/R640 expected-Betti target under `source_invariants = H8`.  No new axioms."
      files := [
        "HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean",
        "HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean",
        "HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean",
        "HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean",
        "HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean",
        "HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean",
        "HodgeReduction/HCGapL4/FrontC7_E7EVIIHodgeDiamondInstance.lean",
        "HodgeReduction/HCGapL4/FrontC8_V56MTBridge.lean",
        "HodgeReduction/HCGapL4/FrontC9_EVIIHodgeNumberComputation.lean",
        "HodgeReduction/HCGapL4/FrontC10_V56CohomologyIdentification.lean",
        "HodgeReduction/HCGapL4/FrontC11_ShimuraBettiComputation.lean",
        "HodgeReduction/HCGapL4/FrontC12_V56InfrastructureProfileBridge.lean",
        "HodgeReduction/HCGapL4/FrontC13_MatsushimaV56BoundaryBridge.lean",
        "HodgeReduction/HCGapL4/FrontC14_CartanCompactDualSourceBridge.lean",
        "HodgeReduction/HCGapL4/FrontC15_MatsushimaBoundaryRankCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC16_MatsushimaTargetContainmentFromSource.lean",
        "HodgeReduction/HCGapL4/FrontC17_MatsushimaTargetRankFromSource.lean",
        "HodgeReduction/HCGapL4/FrontC18_MatsushimaSourceCompactDualRankBridge.lean",
        "HodgeReduction/HCGapL4/FrontC19_MatsushimaSourceCompactDualObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC20_MatsushimaCompactDualExactImageCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC21_MatsushimaExactImageRankBoundary.lean",
        "HodgeReduction/HCGapL4/FrontC22_MatsushimaExactImageSourceEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC23_MatsushimaCompactDualRankOne.lean",
        "HodgeReduction/HCGapL4/FrontC24_CartanImageTrivialRank.lean",
        "HodgeReduction/HCGapL4/FrontC25_CartanLineBoundaryExactness.lean",
        "HodgeReduction/HCGapL4/FrontC26_CartanLineExactnessObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC27_CartanImageScalarPreimage.lean",
        "HodgeReduction/HCGapL4/FrontC28_ScalarPreimageObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC29_CartanImageFromRankOne.lean",
        "HodgeReduction/HCGapL4/FrontC30_SourceInvariantsH8TargetRank.lean",
        "HodgeReduction/HCGapL4/FrontC31_TargetRankFromExpectedBetti.lean",
        "HodgeReduction/HCGapL4/FrontC32_SourceInvariantsH8CarrierCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC33_CompactDualH8CarrierCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC34_CartanContainmentsForCompactDual.lean",
        "HodgeReduction/HCGapL4/FrontC35_SourceCartanContainments.lean",
        "HodgeReduction/HCGapL4/FrontC36_TargetBettiObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC37_TargetRankHodgeSumBridge.lean",
        "HodgeReduction/HCGapL4/FrontC38_TargetHodgeSumFromCartanImage.lean",
        "HodgeReduction/HCGapL4/FrontC39_TargetHodgeSumFromScalarPreimage.lean",
        "HodgeReduction/HCGapL4/FrontC40_TargetRankScalarPreimageEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC41_CartanContainmentCarrierEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC42_H8CarrierEqualityRoute.lean",
        "HodgeReduction/HCGapL4/FrontC43_H8BoundaryEqualityRoute.lean",
        "HodgeReduction/HCGapL4/FrontC44_BoundaryDataH8Equivalence.lean",
        "HodgeReduction/HCGapL4/FrontC45_H8BoundaryDataObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC46_TargetSurjectivityContainmentCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC47_TargetContainmentScalarPreimageCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC48_H8BoundaryRankOneCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC49_H8BoundaryExpectedBettiCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC50_H8ResidualObligationPackage.lean",
        "HodgeReduction/HCGapL4/FrontC51_H8ResidualScalarPreimagePackage.lean",
        "HodgeReduction/HCGapL4/FrontC52_H8ResidualBoundaryPackage.lean",
        "HodgeReduction/HCGapL4/FrontC53_H8ResidualBoundaryDataPackage.lean",
        "HodgeReduction/HCGapL4/FrontC54_H8ResidualExactImagePackage.lean",
        "HodgeReduction/HCGapL4/FrontC55_H8ResidualExactImageRankOnePackage.lean",
        "HodgeReduction/HCGapL4/FrontC56_H8ResidualCartanRankOnePackage.lean",
        "HodgeReduction/HCGapL4/FrontC57_H8ResidualSourceInvariantTargetRankPackage.lean",
        "HodgeReduction/HCGapL4/FrontC58_H8ResidualSourceInvariantNormalization.lean",
        "HodgeReduction/HCGapL4/FrontC59_H8ResidualExpectedBettiPackage.lean",
        "HodgeReduction/HCGapL4/FrontC60_H8ResidualSourceCarrierSplitPackage.lean",
        "HodgeReduction/HCGapL4/FrontC61_H8ResidualCompactDualCarrierPackage.lean",
        "HodgeReduction/HCGapL4/FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.lean",
        "HodgeReduction/HCGapL4/FrontC63_H8ResidualPrimitiveGapSplit.lean",
        "HodgeReduction/HCGapL4/FrontC64_H8ResidualScalarPreimagePrimitiveSplit.lean",
        "HodgeReduction/HCGapL4/FrontC65_H8ResidualPrimitiveTargetLedger.lean",
        "HodgeReduction/HCGapL4/FrontC66_H8ResidualEqualityTargetLedger.lean",
        "HodgeReduction/HCGapL4/FrontC67_H8ResidualRankOneReconciliation.lean",
        "HodgeReduction/HCGapL4/FrontC68_H8ResidualCarrierEqualityObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC69_H8ResidualProofWorkContract.lean",
        "HodgeReduction/HCGapL4/FrontC70_H8ResidualSourceInvariantScalarContract.lean",
        "HodgeReduction/HCGapL4/FrontC71_H8ResidualSourceInvariantExactImageContract.lean",
        "HodgeReduction/HCGapL4/FrontC72_H8ResidualExactImageContainmentContract.lean",
        "HodgeReduction/HCGapL4/FrontC73_H8ResidualExactImageContainmentObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC74_H8ResidualTargetInvariantSaturation.lean",
        "HodgeReduction/HCGapL4/FrontC75_H8ResidualTargetInvariantRankCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC76_H8ResidualRankCriterionReconciliation.lean",
        "HodgeReduction/HCGapL4/FrontC77_H8ResidualTargetInvariantExcessQuotient.lean",
        "HodgeReduction/HCGapL4/FrontC78_H8ResidualTargetInvariantInternalQuotient.lean",
        "HodgeReduction/HCGapL4/FrontC79_H8ResidualTargetInvariantExcessFinrank.lean",
        "HodgeReduction/HCGapL4/FrontC80_H8ResidualTargetInvariantUpperBound.lean",
        "HodgeReduction/HCGapL4/FrontC81_H8ResidualTrivialModuleUpperBound.lean",
        "HodgeReduction/HCGapL4/FrontC82_H8ResidualAtlasMultiplicityCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC83_H8ResidualCartanImageScalarPreimage.lean",
        "HodgeReduction/HCGapL4/FrontC84_H8ResidualScalarPreimageQuotientEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC85_H8ResidualQuotientUpperBoundNoFinite.lean",
        "HodgeReduction/HCGapL4/FrontC86_H8ResidualTargetInvariantPreimageCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC87_H8ResidualInvariantMapSurjectivity.lean",
        "HodgeReduction/HCGapL4/FrontC88_H8ResidualInvariantMapBijectivity.lean",
        "HodgeReduction/HCGapL4/FrontC89_H8ResidualInvariantMapRightInverse.lean",
        "HodgeReduction/HCGapL4/FrontC90_H8ResidualInvariantMapRightInverseEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC92_H8ResidualCartanGeneratorLineCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC93_H8ResidualLineContainmentFromMultiplicity.lean",
        "HodgeReduction/HCGapL4/FrontC94_H8ResidualQuotientLineContainmentEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC95_H8ResidualSourceNoExtraFromLineContainment.lean",
        "HodgeReduction/HCGapL4/FrontC96_H8ResidualSourceGeneratorFromCompactDual.lean",
        "HodgeReduction/HCGapL4/FrontC97_H8ResidualCartanToCompactDualLine.lean",
        "HodgeReduction/HCGapL4/FrontC98_H8ResidualExactImageIndependence.lean",
        "HodgeReduction/HCGapL4/FrontC99_H8ResidualTargetLineIndependence.lean",
        "HodgeReduction/HCGapL4/FrontC100_H8ResidualCartanContainmentIndependence.lean",
        "HodgeReduction/HCGapL4/FrontC101_H8ResidualTargetInvariantLineBridge.lean",
        "HodgeReduction/HCGapL4/FrontE6_FeedR405ConditionalTransfer.lean",
        "HodgeReduction/HCGapL4/FrontD6_Deligne1982MinimalFragment.lean",
        "HodgeReduction/HCGapL4/R451_MultiFrontFrontierAudit.lean",
        "HodgeReduction/HCGapL4/R456_MultiFrontWave2Audit.lean",
        "HodgeReduction/HCGapL4/R460_MultiFrontWave3Audit.lean",
        "HodgeReduction/HCGapL4/R465_MultiFrontWave4Audit.lean",
        "HodgeReduction/HCGapL4/R470_MultiFrontWave5Audit.lean",
        "HodgeReduction/HCGapL4/R476_MultiFrontWave6Audit.lean"
      ]
      decls := [
        "HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond",
        "HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond",
        "HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge",
        "HodgeReduction.HCGapL4.FrontC9_EVIIHodgeNumberComputation.eviiCompactDualCertification",
        "HodgeReduction.HCGapL4.FrontC10_V56CohomologyIdentification.EVII_V56_CohomologyBridge",
        "HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBettiKnownHodgeSumCertification_current",
        "HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimura_expected_known_hodgeSum_total",
        "HodgeReduction.HCGapL4.FrontC12_V56InfrastructureProfileBridge.v56InfrastructureProfileCertification_current",
        "HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge.matsushima_compactDual_image_eq_trivialModulePart",
        "HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge.matsushimaV56BoundaryCertification_from_boundary",
        "HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.cartan_trivialModuleGK_H8_classes_are_algebraic",
        "HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.matsushimaV56BoundaryData_of_source_target_invariants",
        "HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.cartanCompactDualSourceCertification_current",
        "HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.source_eq_invariants_of_le_finrank",
        "HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.target_eq_trivialModulePart_of_le_finrank",
        "HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.matsushimaV56BoundaryData_of_rank_criteria",
        "HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.surjectivity_target_le_trivialModulePart_of_source_le",
        "HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.target_eq_invariants_of_source_le_target_finrank",
        "HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.matsushimaV56BoundaryData_of_source_le_source_rank_target_rank",
        "HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.surjectivity_target_finrank_eq_source",
        "HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.target_finrank_eq_trivialModulePart_of_source_finrank_trivial",
        "HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.matsushimaV56BoundaryData_of_source_le_source_rank_source_to_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.source_eq_invariants_of_source_le_compactDual_rank",
        "HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.source_finrank_eq_trivialModulePart_of_compactDual_rank",
        "HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.matsushimaV56BoundaryData_of_source_le_compactDual_rank_compactDual_to_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC19_MatsushimaSourceCompactDualObstruction.current_interface_does_not_force_R559_targets",
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.source_eq_compactDual_of_compactDual_image_eq_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.compactDual_finrank_eq_trivialModulePart_of_exact_image_target_eq",
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq",
        "HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.target_eq_invariants_of_compactDual_exact_image_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.matsushimaV56BoundaryData_of_compactDual_exact_image_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.matsushima_compactDual_image_eq_trivialModulePart_of_exact_image_rank",
        "HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.source_eq_compactDual_iff_compactDual_exact_image",
        "HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.matsushimaV56BoundaryData_of_source_eq_compactDual_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_rank",
        "HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_H8_finrank_eq_one",
        "HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_finrank_eq_trivialModulePart_of_H8_rank_one",
        "HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.matsushimaV56BoundaryData_of_source_eq_H8_rank_one",
        "HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.map_cartan_trivialModuleGK_H8_finrank_eq_one",
        "HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.trivialModulePart_finrank_eq_one_of_cartan_image",
        "HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.matsushimaV56BoundaryData_of_source_eq_H8_cartan_image",
        "HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.matsushima_compactDual_eq_H8_of_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.matsushimaV56BoundaryData_of_cartan_line_exactness",
        "HodgeReduction.HCGapL4.FrontC26_CartanLineExactnessObstruction.current_interface_does_not_force_cartan_line_exactness",
        "HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage.cartan_image_eq_trivialModulePart_iff_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC28_ScalarPreimageObstruction.current_interface_with_compactDual_cartan_does_not_force_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC29_CartanImageFromRankOne.cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one",
        "HodgeReduction.HCGapL4.FrontC30_SourceInvariantsH8TargetRank.matsushimaV56BoundaryData_of_source_invariants_H8_target_rank_one",
        "HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti.matsushimaV56BoundaryData_of_source_invariants_H8_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC32_SourceInvariantsH8CarrierCriterion.matsushimaV56BoundaryData_of_source_le_H8_h_pow_4_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC33_CompactDualH8CarrierCriterion.matsushimaV56BoundaryData_of_compactDual_le_H8_h_pow_4_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC34_CartanContainmentsForCompactDual.matsushimaV56BoundaryData_of_compactDual_cartan_containments_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC35_SourceCartanContainments.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction.current_interface_with_four_cartan_containments_does_not_force_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC37_TargetRankHodgeSumBridge.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_hodgeSum8",
        "HodgeReduction.HCGapL4.FrontC38_TargetHodgeSumFromCartanImage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_cartan_image",
        "HodgeReduction.HCGapL4.FrontC39_TargetHodgeSumFromScalarPreimage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC40_TargetRankScalarPreimageEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_cartan_containments",
        "HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_H8_splits",
        "HodgeReduction.HCGapL4.FrontC42_H8CarrierEqualityRoute.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence.target_hodgeSum8_iff_matsushimaV56BoundaryData_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.current_interface_with_H8_equalities_does_not_force_target_boundary",
        "HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.target_hodgeSum8_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.counterexample_not_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.target_boundary_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.counterexample_not_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion.target_boundary_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion.current_interface_with_H8_equalities_does_not_force_trivialModulePart_rank_one",
        "HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion.matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion.current_interface_with_H8_equalities_does_not_force_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.target_expected_betti8_iff_target_invariants_finrank_eq_one",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.EVIIH8ResidualRankOneObligations",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.target_expected_betti8_of_residual_obligations",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.matsushimaV56BoundaryData_of_residual_obligations",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.matsushimaV56BoundaryData_of_H8_and_target_rank_one",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.current_interface_with_H8_equalities_does_not_force_target_rank_one",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.target_expected_betti8_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.EVIIH8ResidualScalarPreimageObligations",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.rankOneResidual_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.scalarPreimageResidual_of_rankOneResidual",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.residual_rankOne_nonempty_iff_scalarPreimage_nonempty",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.matsushimaV56BoundaryData_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.current_interface_with_H8_equalities_does_not_force_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.EVIIH8ResidualBoundaryObligations",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.boundaryResidual_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.scalarPreimageResidual_of_boundaryResidual",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.residual_scalarPreimage_nonempty_iff_boundary_nonempty",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.residual_rankOne_nonempty_iff_boundary_nonempty",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.matsushimaV56BoundaryData_of_boundaryResidual",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.current_interface_with_H8_equalities_does_not_force_target_boundary",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.EVIIH8ResidualBoundaryDataObligations",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.boundaryResidual_of_boundaryDataResidual",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.boundaryDataResidual_of_boundaryResidual",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_boundary_nonempty_iff_boundaryData_nonempty",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_scalarPreimage_nonempty_iff_boundaryData_nonempty",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_rankOne_nonempty_iff_boundaryData_nonempty",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.matsushimaV56BoundaryData_of_boundaryDataResidual",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.current_interface_with_compactDual_eq_H8_does_not_force_boundaryData",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.EVIIH8ResidualExactImageObligations",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.exactImageResidual_of_boundaryDataResidual",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.boundaryDataResidual_of_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_boundaryData_nonempty_iff_exactImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_scalarPreimage_nonempty_iff_exactImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_rankOne_nonempty_iff_exactImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.matsushimaV56BoundaryData_of_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.current_interface_with_compactDual_eq_H8_does_not_force_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.EVIIH8ResidualExactImageRankOneObligations",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.exactImageResidual_of_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.exactImageRankOneResidual_of_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_exactImage_nonempty_iff_exactImageRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_boundaryData_nonempty_iff_exactImageRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_rankOne_nonempty_iff_exactImageRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.matsushimaV56BoundaryData_of_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.current_interface_with_compactDual_eq_H8_does_not_force_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.EVIIH8ResidualCartanRankOneObligations",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.exactImageRankOneResidual_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.cartanRankOneResidual_of_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.residual_exactImageRankOne_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.residual_boundaryData_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.matsushimaV56BoundaryData_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.current_interface_with_compactDual_eq_H8_does_not_force_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.EVIIH8ResidualSourceInvariantTargetRankObligations",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.cartanRankOneResidual_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.sourceInvariantTargetRankResidual_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.residual_cartanRankOne_nonempty_iff_sourceInvariantTargetRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.residual_boundaryData_nonempty_iff_sourceInvariantTargetRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.matsushimaV56BoundaryData_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.current_interface_with_compactDual_eq_H8_does_not_force_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.residualRankOne_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.sourceInvariantTargetRankResidual_of_residualRankOne",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.residual_rankOne_nonempty_iff_sourceInvariantTargetRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.target_expected_betti8_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.EVIIH8ResidualSourceInvariantExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.sourceInvariantExpectedBettiResidual_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.residual_sourceInvariantTargetRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.target_rank_one_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.matsushimaV56BoundaryData_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.source_invariants_eq_H8_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.h_pow_four_mem_source_invariants_of_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.sourceCarrierSplitResidual_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.residual_sourceInvariantExpectedBetti_nonempty_iff_sourceCarrierSplit_nonempty",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.matsushimaV56BoundaryData_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.EVIIH8ResidualCompactDualCarrierExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.sourceCarrierSplitResidual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.compactDualCarrierResidual_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.residual_sourceCarrierSplit_nonempty_iff_compactDualCarrier_nonempty",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.sourceInvariantExpectedBettiResidual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.matsushimaV56BoundaryData_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.current_interface_with_compactDualCarrier_does_not_force_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.EVIIH8ResidualCartanContainmentExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.compactDualCarrierResidual_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_of_h_pow_four_mem",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.compactDual_le_cartan_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_compactDual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.source_le_cartan_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_source_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartanContainmentResidual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.residual_compactDualCarrier_nonempty_iff_cartanContainment_nonempty",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.matsushimaV56BoundaryData_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.current_interface_with_cartanContainments_does_not_force_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.EVIIH8ResidualCartanCarrierObligations",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.EVIIH8ResidualExpectedBettiTargetObligation",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.cartanContainmentResidual_of_carrier_and_expectedBetti",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.carrierObligations_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.expectedBettiTargetObligation_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.residual_cartanContainment_nonempty_iff_carrier_and_expectedBetti_nonempty",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.matsushimaV56BoundaryData_of_carrier_and_expectedBetti",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.current_interface_with_carrierObligations_does_not_force_expectedBettiTarget",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.R604PrimitiveResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.currentR604PrimitiveResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.currentR604PrimitiveResidualSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.EVIIH8ResidualCartanScalarPreimageObligations",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.expectedBettiTarget_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.cartanContainmentResidual_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.carrierScalarPreimage_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.residual_cartanContainment_nonempty_iff_carrierScalarPreimage_nonempty",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.matsushimaV56BoundaryData_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.current_interface_with_carrierObligations_does_not_force_scalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.R605ScalarPreimageResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.currentR605ScalarPreimageResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.currentR605ScalarPreimageResidualSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.sourceToCartanPrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanToSourcePrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.compactDualToCartanPrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanToCompactDualPrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.scalarPreimagePrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.EVIIH8ResidualFivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.fivePrimitiveTargets_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.carrierScalarPreimage_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.residual_carrierScalarPreimage_nonempty_iff_fivePrimitiveTargets_nonempty",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanContainmentResidual_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.matsushimaV56BoundaryData_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetNames",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.R606PrimitiveTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetLedgerSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.sourceCartanEqualityTarget",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.compactDualCartanEqualityTarget",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.EVIIH8ResidualEqualityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.equalityScalarTargets_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.fivePrimitiveTargets_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.residual_fivePrimitiveTargets_nonempty_iff_equalityScalarTargets_nonempty",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.cartanContainmentResidual_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.matsushimaV56BoundaryData_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607ProofWorkTargetNames",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.R607EqualityTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607EqualityTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607EqualityTargetLedgerSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607ProofWorkTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.scalarPreimageResidual_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.equalityScalarTargets_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.residual_scalarPreimage_nonempty_iff_equalityScalarTargets_nonempty",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.cartanRankOneResidual_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.equalityScalarTargets_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.residual_equalityScalarTargets_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationTargetNames",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.R608RankOneReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.counterexample_source_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.counterexample_compactDual_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.current_interface_with_cartan_equalities_does_not_force_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.current_interface_with_cartan_equalities_does_not_force_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.R609CarrierEqualityObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609CarrierEqualityObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609CarrierEqualityObstructionSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609ObstructionTargetNames",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609ObstructionTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.EVIIH8ResidualProofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.proofWorkContract_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.equalityScalarTargets_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.residual_equalityScalarTargets_nonempty_iff_proofWorkContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.cartanContainmentResidual_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.matsushimaV56BoundaryData_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.residual_proofWorkContract_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.current_interface_with_cartan_equalities_does_not_force_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractTargetNames",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.R610ProofWorkContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.EVIIH8ResidualSourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.source_invariants_eq_H8_of_compactDualCartan",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.source_eq_invariants_of_sourceCartan_compactDualCartan",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.sourceInvariantScalarContract_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.proofWorkContract_of_sourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.residual_proofWorkContract_nonempty_iff_sourceInvariantScalarContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.matsushimaV56BoundaryData_of_sourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractTargetNames",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.R634SourceInvariantScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.EVIIH8ResidualSourceInvariantExactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantExactImage_of_source_eq_invariants",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.source_eq_invariants_of_sourceInvariantExactImage",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.source_eq_invariants_iff_sourceInvariantExactImage",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.exactImageScalarContract_of_sourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantScalarContract_of_exactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.residual_sourceInvariantScalarContract_nonempty_iff_exactImageScalarContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.matsushimaV56BoundaryData_of_sourceInvariantExactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractTargetNames",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.R635ExactImageScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.EVIIH8ResidualExactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.compactDual_eq_H8_of_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.exactImageContainmentContract_of_exactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.exactImageScalarContract_of_exactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.residual_exactImageScalar_nonempty_iff_exactImageContainment_nonempty",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.matsushimaV56BoundaryData_of_exactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentTargetNames",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.R636ExactImageContainmentSnapshot",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentSnapshot",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.counterexample_sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.counterexample_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.current_interface_with_exactImage_sourceH8_does_not_force_target_containment",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.current_interface_with_exactImage_sourceH8_does_not_force_R636_contract",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.R637ExactImageContainmentObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.currentR637ExactImageContainmentObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.currentR637ExactImageContainmentObstructionSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSurjectivityTarget",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturatesTargetInvariants",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_targetInvariantSurjectivity",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImage_eq_targetInvariants_of_saturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_of_sourceInvariantImage_eq_targetInvariants",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_image_eq_targetInvariants",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.EVIIH8ResidualTargetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSaturationContract_of_exactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.exactImageContainmentContract_of_targetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.residual_exactImageContainment_nonempty_iff_targetInvariantSaturation_nonempty",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.exactImageContainmentContract_of_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.counterexample_not_targetInvariantSurjectivity",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.counterexample_not_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationTargetNames",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.R638TargetInvariantSaturationSnapshot",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationSnapshot",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImage_finrank_eq_sourceInvariants",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImage_eq_targetInvariants_of_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImageSaturation_of_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantFinrank_of_sourceInvariantImage_eq_targetInvariants",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantFinrank_of_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImageSaturation_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.EVIIH8ResidualTargetInvariantRankContract",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantSaturationContract_of_targetInvariantRankContract",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantRankContract_of_targetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.residual_targetInvariantSaturation_nonempty_iff_targetInvariantRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.exactImageContainmentContract_of_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.counterexample_not_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankTargetNames",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.R639TargetInvariantRankSnapshot",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankSnapshot",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.targetInvariantFinrank_of_sourceH8_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.target_expected_betti8_of_sourceH8_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.sourceInvariantExpectedBettiResidual_of_targetInvariantRankContract",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.targetInvariantRankContract_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.residual_targetInvariantRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.exactImageContainmentContract_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationTargetNames",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.R640RankReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.map_mkQ_eq_bot_iff_le",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.sourceInvariantImage",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSurjectivity",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.EVIIH8ResidualTargetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.exactImageContainmentContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotientContract_of_targetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.counterexample_not_targetInvariantExcessQuotient_eq_bot",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientTargetNames",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.R641TargetInvariantExcessQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_map_eq_sourceInvariantImage",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap_range",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap_ker",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_finrank_add_sourceInvariantImageInsideTarget_finrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_eq_bot_iff_internalFinrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.counterexample_not_sourceInvariantImageInsideTarget_eq_top",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageInsideTarget",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientTargetNames",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.R642TargetInvariantInternalQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_finrank_add_sourceInvariants_finrank",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessFinrank_zero_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_finrank_add_expected_betti8_of_sourceH8",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessFinrank_zero_iff_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.current_interface_with_exactImage_sourceH8_finiteTarget_does_not_force_excessFinrankZero",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankTargetNames",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.R643TargetInvariantExcessFinrankSnapshot",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankSnapshot",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessFinrank_zero_of_sourceH8_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetExpectedBettiUpperBound_of_targetInvariantExcessFinrank_zero",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessFinrank_zero_iff_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.EVIIH8ResidualTargetInvariantUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessQuotientContract_of_targetInvariantUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.residual_targetInvariantUpperBound_nonempty_iff_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.current_interface_with_exactImage_sourceH8_does_not_force_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundTargetNames",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.R644TargetInvariantUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantExcessFinrank_zero_iff_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.EVIIH8ResidualTrivialModuleUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantUpperBoundContract_of_trivialModuleUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.trivialModuleUpperBoundContract_of_targetInvariantUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.residual_trivialModuleUpperBound_nonempty_iff_targetInvariantUpperBound_nonempty",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundTargetNames",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.R645TrivialModuleUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.atlasDeg8Classification_at_degree8",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.atlasDeg8Classification_and_currentInterface_do_not_force_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_le_cartanImage",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_le_sourceInvariantImage",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_exactImage_sourceH8_targetContainment",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.EVIIH8ResidualCartanImageUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModuleUpperBoundContract_of_cartanImageUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionTargetNames",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.R646AtlasMultiplicityCriterionSnapshot",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionSnapshot",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.trivialModulePart_le_cartanImage_iff_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.trivialModulePart_upper_bound_of_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.EVIIH8ResidualCartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.cartanImageUpperBoundContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.cartanScalarUpperBoundContract_of_cartanImageUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.residual_cartanScalar_nonempty_iff_cartanImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.current_interface_with_atlas_does_not_force_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarTargetNames",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.R647CartanScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.sourceInvariantImageSaturation_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.targetInvariantExcessQuotientContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.cartanScalarUpperBoundContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.residual_cartanScalar_nonempty_iff_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_quotient_or_cartan_scalar",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientTargetNames",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.R648ScalarQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.trivialModulePart_upper_bound_of_sourceH8_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetExpectedBettiUpperBound_of_sourceH8_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.trivialModuleUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetInvariantExcessQuotient_nonempty_to_targetInvariantUpperBound_nonempty_noFinite",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundTargetNames",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.R649NoFiniteQuotientUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantSourcePreimageTarget",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.sourceInvariantImageSaturation_iff_targetInvariantSourcePreimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.EVIIH8ResidualTargetInvariantPreimageContract",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantPreimageContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantExcessQuotientContract_of_targetInvariantPreimageContract",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantPreimage_nonempty",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantSourcePreimage_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantPreimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageTargetNames",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.R650TargetInvariantPreimageSnapshot",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageSnapshot",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap_range_eq_sourceInvariantImageInsideTarget",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_range_eq_top",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.EVIIH8ResidualInvariantMapSurjectivityContract",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.invariantMapSurjectivityContract_of_targetInvariantPreimageContract",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.targetInvariantPreimageContract_of_invariantMapSurjectivityContract",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.residual_targetInvariantPreimage_nonempty_iff_invariantMapSurjectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.residual_targetInvariantExcessQuotient_nonempty_iff_invariantMapSurjectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.current_interface_with_exactImage_sourceH8_does_not_force_invariantMapSurjectivity",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivityTargetNames",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.R651InvariantMapSurjectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivitySnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivityTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.sourceToTargetInvariantMap_injective",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.sourceToTargetInvariantMap_surjective_iff_range_eq_top",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_surjective",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.EVIIH8ResidualInvariantMapBijectivityContract",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.invariantMapBijectivityContract_of_invariantMapSurjectivityContract",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.invariantMapSurjectivityContract_of_invariantMapBijectivityContract",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.residual_invariantMapSurjectivity_nonempty_iff_invariantMapBijectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.current_interface_with_exactImage_sourceH8_does_not_force_invariantMapBijectivity",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivityTargetNames",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.R652InvariantMapBijectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivitySnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivityTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.sourceToTargetInvariantMap_range_eq_top_of_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.targetInvariantExcessQuotient_eq_bot_of_sourceToTargetInvariantMap_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.sourceToTargetInvariantMap_bijective_of_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.EVIIH8ResidualInvariantMapRightInverseContract",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.invariantMapBijectivityContract_of_invariantMapRightInverseContract",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.residual_invariantMapRightInverse_nonempty_to_invariantMapBijectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.current_interface_does_not_force_rightInverseContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseTargetNames",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.R653InvariantMapRightInverseSnapshot",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseSnapshot",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantLinearEquivOfBijective",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantMapRightInverseOfBijective",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantMap_comp_rightInverseOfBijective",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.invariantMapRightInverseContract_of_invariantMapBijectivityContract",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.residual_invariantMapBijectivity_nonempty_to_invariantMapRightInverse_nonempty",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.residual_invariantMapRightInverse_nonempty_iff_invariantMapBijectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_equivTarget",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceTargetNames",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.R654RightInverseEquivalenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.sourceToTargetInvariantMap_linearRightInverse_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.cartanScalarUpperBoundContract_of_invariantMapRightInverseContract",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.invariantMapRightInverseContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.residual_invariantMapRightInverse_nonempty_iff_cartanScalar_nonempty",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.sourceToTargetInvariantMap_bijective_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_or_scalar",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarTargetNames",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.R655RightInverseScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.matsushima_h_pow_four_image_ne_zero",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.matsushima_h_pow_four_mem_cartan_image",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_image_eq_span_matsushima_h_pow_four",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_image_contains_nonzero_generator",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.sourceToTargetInvariantMap_bijective_iff_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.EVIIH8ResidualCartanLineContainmentContract",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartanScalarUpperBoundContract_of_cartanLineContainmentContract",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartanLineContainmentContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.residual_cartanLine_nonempty_iff_cartanScalar_nonempty",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.current_interface_with_exactImage_sourceH8_does_not_force_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.R656CartanGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.matsushima_h_pow_four_mem_trivialModulePart_of_sourceH8",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.cartan_scalar_preimage_of_sourceH8_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.sourceToTargetInvariantMap_bijective_of_sourceH8_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.cartanLineContainmentContract_of_trivialModuleUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.residual_trivialModuleUpperBound_nonempty_to_cartanLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicityTargetNames",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.R657LineContainmentFromMultiplicitySnapshot",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicitySnapshot",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicitySnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicityTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.sourceToTargetInvariantMap_bijective_of_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.cartanLineContainmentContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.targetInvariantExcessQuotientContract_of_cartanLineContainmentContract",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.residual_targetInvariantExcessQuotient_nonempty_iff_cartanLine_nonempty_noFinite",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.invariantMapBijectivityContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.R658QuotientLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.source_invariants_eq_H8_of_h_pow_four_mem_source_and_line",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.EVIIH8ResidualGeneratorMembershipLineContract",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.cartanLineContainmentContract_of_generatorMembershipLineContract",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.targetInvariantExcessQuotientContract_of_generatorMembershipLineContract",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.residual_generatorMembershipLine_nonempty_to_cartanLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.residual_generatorMembershipLine_nonempty_to_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.R659SourceNoExtraFromLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.source_invariants_eq_H8_of_h_pow_four_mem_compactDual_and_line",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.EVIIH8ResidualCompactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.generatorMembershipLineContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.cartanLineContainmentContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.targetInvariantExcessQuotientContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.residual_compactDualGeneratorLine_nonempty_to_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.R660CompactDualGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.EVIIH8ResidualCartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.compactDualGeneratorLineContract_of_cartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.cartanToCompactDualLineContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.residual_compactDualGeneratorLine_nonempty_iff_cartanToCompactDualLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.targetInvariantExcessQuotientContract_of_cartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.source_invariants_eq_H8_of_cartanH8_le_compactDual_and_line",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.R661CartanToCompactDualLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_cartanH8_le_compactDual",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_trivialModulePart_le_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_not_sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.current_interface_with_cartanContainment_line_does_not_force_exactImage",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.R662ExactImageIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.currentR662ExactImageIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.currentR662ExactImageIndependenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.counterexample_cartanH8_le_compactDual",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.current_interface_with_exactImage_cartanContainment_does_not_force_target_line",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.R663TargetLineIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.currentR663TargetLineIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.currentR663TargetLineIndependenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.R663_substantiveTheoremCount_eq",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_trivialModulePart_le_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_not_cartanH8_le_compactDual",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.current_interface_with_exactImage_line_does_not_force_cartanContainment",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.R664CartanContainmentIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.currentR664CartanContainmentIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.currentR664CartanContainmentIndependenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.EVIIH8ResidualTargetInvariantLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.targetInvariantLineContract_of_cartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.cartanToCompactDualLineContract_of_targetInvariantLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.residual_cartanToCompactDualLine_nonempty_iff_targetInvariantLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.targetInvariantExcessQuotientContract_of_targetInvariantLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.source_invariants_eq_H8_of_cartanH8_le_compactDual_and_targetInvariantLine",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.R665TargetInvariantLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineTargetNames_eq_texStatus"
      ]
    }
  ]
  researchChains := [
    {
      id := "full-hc-final-target"
      title := "Final full Hodge conjecture target"
      kind := "main"
      status := "final-open"
      summary :=
        "`FullHodgeGoal.lean` records the actual theorem-closing objective: `FullHodgeConjectureReal`, not merely HC for the canonical `E_7` target.  The current `main_reduction_real` theorem is a scoped reduction, and `hodgeConjectureReal_canonical` is a single canonical milestone.  R611 adds the explicit by-codimension consumer plus a kernel-checked full-target status snapshot, so paper summary claims can point to the full target rather than to the L4 proof-work frontier alone.  R612 formalizes the second global closure alternative: prove `CurrentReductionCoversOrSolvesAllSmoothProjective`, then use the current reduction on the `InScope` branch and the independent proof on the complement branch.  R613 aligns the residual-gate vocabulary in `Research/E7ResidualStatus.lean` with that same R612 route, so residual-gate prose and full-HC closure prose now point to a single kernel-visible antecedent.  R620 adds `paperSummaryClaimFailureCount = 0`, so the summary status cannot silently drift from the route and paper-inventory ledgers.  R621 fixes the exact gap id/status table, R629 fixes the top-level project axiom-constant count, R630 fixes the direct `sorryAx` count, R631 fixes the 24-row endpoint open-cut ledger, R632 fixes its route-gap assignment ledger, and R633 fixes the endpoint-paper coverage exception behind the Lean-status prose, so the paper can no longer change those inventories without changing Lean.  Future work should be judged by whether it removes a blocker for the universal theorem or wires a milestone into an explicit implication to `FullHodgeConjectureReal`."
      files := [
        "HodgeReduction/FullHodgeGoal.lean",
        "HodgeReduction/AxiomInventory.lean",
        "HodgeReduction/Research/E7ResidualStatus.lean",
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/Types.lean"
      ]
      entryDecls := [
        "HodgeReduction.FullHodgeConjectureReal",
        "HodgeReduction.FullHodgeConjectureRealByCodim",
        "HodgeReduction.CurrentReductionCoversAllSmoothProjective",
        "HodgeReduction.fullHodgeConjectureReal_of_currentScopeCoverage",
        "HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeCoverage",
        "HodgeReduction.currentFullHodgeClosureRouteNames",
        "HodgeReduction.FullHodgeClosureStatusSnapshot",
        "HodgeReduction.currentFullHodgeClosureStatusSnapshot",
        "HodgeReduction.currentFullHodgeClosureStatusSnapshot_eq_texStatus",
        "HodgeReduction.currentFullHodgeClosureRouteNames_eq_texStatus",
        "HodgeReduction.CurrentReductionCoversOrSolvesAllSmoothProjective",
        "HodgeReduction.currentScopeOrComplementCoverage_of_currentScopeCoverage",
        "HodgeReduction.fullHodgeConjectureReal_of_currentScopeOrComplementCoverage",
        "HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeOrComplementCoverage",
        "HodgeReduction.currentFullHodgeScopeOrComplementRouteNames",
        "HodgeReduction.FullHodgeScopeOrComplementSnapshot",
        "HodgeReduction.currentFullHodgeScopeOrComplementSnapshot",
        "HodgeReduction.currentFullHodgeScopeOrComplementSnapshot_eq_texStatus",
        "HodgeReduction.currentFullHodgeScopeOrComplementRouteNames_eq_texStatus",
        "HodgeReduction.r612ScopeOrComplementResidualGateData",
        "HodgeReduction.fullHodgeConjectureReal_from_r612ResidualGate",
        "HodgeReduction.R613ResidualGateRouteSnapshot",
        "HodgeReduction.currentR613ResidualGateRouteSnapshot",
        "HodgeReduction.currentR613ResidualGateRouteSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.fullHcNarrativeClaimsCompleteProof",
        "HodgeReduction.MainChain.PaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot_eq_texStatus",
        "HodgeReduction.MainChain.fullHcCompletionOverclaimCount",
        "HodgeReduction.MainChain.fullHcFinalOpenStatusFailureCount",
        "HodgeReduction.MainChain.masterClaimTagPointerFailureCount",
        "HodgeReduction.MainChain.masterClaimDispositionTagMismatchCount",
        "HodgeReduction.MainChain.masterBrokenLinkDisciplineFailureCount",
        "HodgeReduction.MainChain.masterSubgapStatusMarkerFailureCount",
        "HodgeReduction.MainChain.masterPrimaryHypothesisDisciplineFailureCount",
        "HodgeReduction.MainChain.scopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceCount",
        "HodgeReduction.MainChain.allScopeSubclassRouteGapReferencesRegisteredInRoute",
        "HodgeReduction.MainChain.masterScopeSubclassStatusFailureCount",
        "HodgeReduction.MainChain.projectAxiomTrustBaseFailureCount",
        "HodgeReduction.MainChain.projectSorryAxFailureCount",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero",
        "HodgeReduction.MainChain.masterSourceDisciplineFailureCount",
        "HodgeReduction.MainChain.masterEnvironmentCoverageFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount_eq_zero",
        "HodgeReduction.MainChain.RouteGapStatusEntry",
        "HodgeReduction.MainChain.routeGapStatusLedger",
        "HodgeReduction.MainChain.routeGapStatusLedger_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutNames",
        "HodgeReduction.MainChain.endpointOpenCutCount",
        "HodgeReduction.MainChain.EndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutCount_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignment",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments_eq_texStatus",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignmentFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutPaperCoverageFailureCount"
      ]
      gapIds := ["G-full-hc"]
      dependsOn := []
      attackPlan := [
        "Keep the canonical `E_7` route as a hard milestone, not as the final theorem.",
        "Separate case closure from scope coverage: `main_reduction_real` gives `InScope X -> HC(X)`, while the full theorem needs all smooth projective complex varieties covered or an additional route for the complement.",
        "R612 consumer: proving `CurrentReductionCoversOrSolvesAllSmoothProjective` is now enough to close the full theorem via a kernel-checked scope-or-complement theorem.",
        "R613 alignment: the residual-gate bridge now consumes the same R612 antecedent, preventing a second paper-only full-HC route from drifting away from the Lean target.",
        "When a branch closes, require an explicit Lean theorem that either concludes `FullHodgeConjectureReal` or reduces one named full-HC blocker without replacing it by a stronger assumption."
      ]
      successCriterion :=
        "A theorem-closing round succeeds only when a kernel-checked theorem concludes `FullHodgeConjectureReal`; an intermediate round succeeds when it removes or strictly narrows a named blocker feeding that theorem."
    },
    {
      id := "master-paper-import-ledger"
      title := "Master tex import ledger"
      kind := "support"
      status := "in-progress"
      summary :=
        "`PaperInventory.lean` is the canonical ledger for moving the master proof into Lean.  It records the master tex as the sole canonical source, marks non-master tex files as archive/background, and tracks each load-bearing master item by line number, Lean declarations, and gap ids.  The current ledger has `claimedMasterEnvironmentCount = masterEnvironmentIndex.length`, `unclaimedMasterEnvironmentCount = 0`, and no `needsTriage` claims.  R614 checks that every load-bearing master claim has at least one machine correspondence: either a Lean declaration or an explicit route/gap id.  R615 strengthens the semantic tag discipline: formalized/kernel-only claims must carry Lean declarations, while registered-gap, open-hypothesis, open-residual, and new-math-gap claims must carry gap ids.  R616 strengthens the disposition/tag discipline: formalized claims must not carry open/unported tags, and open/gap/conditional dispositions must carry their matching semantic tags.  R617 checks that every master-claim gap id resolves to a route-level `researchGaps` entry.  R618 checks that all load-bearing claims use the single master tex canonical source while the other source families remain archive/background.  R619 checks that every theorem-like master environment has exactly one covering claim with a matching environment kind.  R620 aggregates those summary-facing checks into `paperSummaryClaimFailureCount = 0`, including the full-HC non-closure status.  R621 fixes the exact route gap id/status ledger referenced by those master claims.  R622 fixes exact claim-id worklists for the paper's remaining kernel-port debt and new-math/open-gap obligations.  R623 fixes the exact route-gap-to-master-claim worklists.  R624 records the expected exception: the only route rows with no direct master-paper claim ids are the structural infrastructure gaps `G-l1-e7-shimura-tor` and `G-l2-cohomology-construction`.  R625 records the exact broken-link predicate anchors and checks that they remain open/gap-facing new-math claims, not hidden closure claims.  R626 records the explicit master-tex sub-gap status markers, with four `gapPartial`, one `gapOpen`, and one `gapBlocked` marker tied to Lean declarations.  R627 records the exact nine primary labelled hypotheses used by the abstract, status box, and conclusion, and checks that they are exactly the open-hypothesis claim worklist.  R628 records the four scope-subclass status claims, separating unconditional sub-arguments from inherited conditional machinery.  R629 records the generated top-level project axiom-constant count for the master paper's Lean-status section; R630 records that the compiled root import has zero project declarations with direct `sorryAx` in their type/value; R631 records the exact 24 configured endpoint open cuts; R632 records the exact route-gap assignment for those cuts; R633 records the only endpoint assignment without direct master-paper claim coverage as the structural cohomology cut.  Further proof rounds should replace registered gaps and conditional milestones with kernel theorems where possible, without changing the theorem target away from `FullHodgeConjectureReal`."
      files := [
        "HodgeReduction/PaperInventory.lean",
        "HodgeReduction/Research/AnisotropicResidue.lean",
        "HodgeReduction/Research/ClassicalExternalStatus.lean",
        "HodgeReduction/Research/CMFibreDensity.lean",
        "HodgeReduction/Research/E7ArithmeticityPipeline.lean",
        "HodgeReduction/Research/E7BBTSpreading.lean",
        "HodgeReduction/Research/E7CMAlgebraicity.lean",
        "HodgeReduction/Research/E7ChernWeilBridge.lean",
        "HodgeReduction/Research/E7ResidualStatus.lean",
        "HodgeReduction/Research/E7ThetaModularity.lean",
        "HodgeReduction/Research/FibreTransfer.lean",
        "HodgeReduction/Research/HBundleStatus.lean",
        "HodgeReduction/Research/LatticeGap.lean",
        "HodgeReduction/Research/MainTheoremInputStatus.lean",
        "HodgeReduction/Research/MainTheoremResidualStatus.lean",
        "HodgeReduction/Research/MokCircularity.lean",
        "HodgeReduction/Research/OmegaDiagonal.lean",
        "HodgeReduction/Research/PadicDescent.lean",
        "HodgeReduction/Research/Q4AbelianAlgebraicity.lean",
        "HodgeReduction/Research/ShimuraTypeFibre.lean",
        "HodgeReduction/Research/WitnessLatticeHypothesis.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/AxiomInventory.lean"
      ]
      entryDecls := [
        "HodgeReduction.PaperInventory.canonicalMasterSource",
        "HodgeReduction.PaperInventory.archivedBackgroundSources",
        "HodgeReduction.PaperInventory.allSources",
        "HodgeReduction.PaperInventory.knownSourceIds",
        "HodgeReduction.PaperInventory.sourceIdIsKnown",
        "HodgeReduction.PaperInventory.masterClaimsWithUnknownSourceIdCount",
        "HodgeReduction.PaperInventory.allMasterClaimSourceIdsKnown",
        "HodgeReduction.PaperInventory.masterClaimsOutsideCanonicalSourceCount",
        "HodgeReduction.PaperInventory.allMasterClaimsUseCanonicalMasterSource",
        "HodgeReduction.PaperInventory.canonicalMasterSourcePathIsMasterTex",
        "HodgeReduction.PaperInventory.canonicalMasterSourceRoleIsCanonical",
        "HodgeReduction.PaperInventory.archivedBackgroundSourceCount",
        "HodgeReduction.PaperInventory.allArchivedBackgroundSourcesHaveArchiveRole",
        "HodgeReduction.PaperInventory.MasterSourceDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.masterEnvironmentIndex",
        "HodgeReduction.PaperInventory.environmentCoveringClaims",
        "HodgeReduction.PaperInventory.environmentCoveringClaimCount",
        "HodgeReduction.PaperInventory.allMasterEnvironmentsHaveUniqueClaim",
        "HodgeReduction.PaperInventory.masterEnvironmentsWithoutUniqueClaimCount",
        "HodgeReduction.PaperInventory.allClaimedMasterEnvironmentKindsMatch",
        "HodgeReduction.PaperInventory.masterEnvironmentsWithKindMismatchCount",
        "HodgeReduction.PaperInventory.masterClaimsNotCoveringMasterEnvironmentCount",
        "HodgeReduction.PaperInventory.MasterEnvironmentCoverageDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.masterClaims",
        "HodgeReduction.PaperInventory.openHypothesisClaims",
        "HodgeReduction.PaperInventory.registeredGapClaims",
        "HodgeReduction.PaperInventory.needsTriageClaims",
        "HodgeReduction.PaperInventory.formalizedClaims",
        "HodgeReduction.PaperInventory.provenInPaperClaims",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaims",
        "HodgeReduction.PaperInventory.externalCitationClaims",
        "HodgeReduction.PaperInventory.openResidualClaims",
        "HodgeReduction.PaperInventory.archiveOnlyClaims",
        "HodgeReduction.PaperInventory.ClaimAuditTag",
        "HodgeReduction.PaperInventory.effectiveAuditTags",
        "HodgeReduction.PaperInventory.kernelOnlyLeanClaims",
        "HodgeReduction.PaperInventory.kernelOnlyLeanClaimCount",
        "HodgeReduction.PaperInventory.paperProofNotKernelPortedClaims",
        "HodgeReduction.PaperInventory.paperProofNotKernelPortedClaimCount",
        "HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaims",
        "HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaimCount",
        "HodgeReduction.PaperInventory.newMathGapClaims",
        "HodgeReduction.PaperInventory.newMathGapClaimCount",
        "HodgeReduction.PaperInventory.migrationDebtClaims",
        "HodgeReduction.PaperInventory.migrationDebtClaimCount",
        "HodgeReduction.PaperInventory.claimIds",
        "HodgeReduction.PaperInventory.claimReferencesGapId",
        "HodgeReduction.PaperInventory.masterClaimsForGapId",
        "HodgeReduction.PaperInventory.masterClaimIdsForGapId",
        "HodgeReduction.PaperInventory.registeredGapClaimIds",
        "HodgeReduction.PaperInventory.openHypothesisClaimIds",
        "HodgeReduction.PaperInventory.openResidualClaimIds",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaimIds",
        "HodgeReduction.PaperInventory.paperProofNotKernelPortedClaimIds",
        "HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaimIds",
        "HodgeReduction.PaperInventory.newMathGapClaimIds",
        "HodgeReduction.PaperInventory.migrationDebtClaimIds",
        "HodgeReduction.PaperInventory.MasterClaimWorklistSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimWorklistSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimWorklistSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.untaggedMasterClaimCount",
        "HodgeReduction.PaperInventory.allMasterClaimsHaveEffectiveAuditTag",
        "HodgeReduction.PaperInventory.claimedMasterEnvironments",
        "HodgeReduction.PaperInventory.unclaimedMasterEnvironments",
        "HodgeReduction.PaperInventory.masterClaimCount",
        "HodgeReduction.PaperInventory.formalizedClaimCount",
        "HodgeReduction.PaperInventory.provenInPaperClaimCount",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaimCount",
        "HodgeReduction.PaperInventory.externalCitationClaimCount",
        "HodgeReduction.PaperInventory.registeredGapClaimCount",
        "HodgeReduction.PaperInventory.claimedMasterEnvironmentCount",
        "HodgeReduction.PaperInventory.unclaimedMasterEnvironmentCount",
        "HodgeReduction.PaperInventory.openResidualClaimCount",
        "HodgeReduction.PaperInventory.archiveOnlyClaimCount",
        "HodgeReduction.PaperInventory.claimHasMachineCorrespondence",
        "HodgeReduction.PaperInventory.claimsWithoutMachineCorrespondence",
        "HodgeReduction.PaperInventory.claimsWithoutMachineCorrespondenceCount",
        "HodgeReduction.PaperInventory.allMasterClaimsHaveMachineCorrespondence",
        "HodgeReduction.PaperInventory.claimHasLeanDecl",
        "HodgeReduction.PaperInventory.claimHasGapId",
        "HodgeReduction.PaperInventory.formalizedClaimsWithoutLeanDeclCount",
        "HodgeReduction.PaperInventory.allFormalizedClaimsHaveLeanDecl",
        "HodgeReduction.PaperInventory.kernelOnlyClaimsWithoutLeanDeclCount",
        "HodgeReduction.PaperInventory.allKernelOnlyClaimsHaveLeanDecl",
        "HodgeReduction.PaperInventory.registeredGapClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allRegisteredGapClaimsHaveGapId",
        "HodgeReduction.PaperInventory.openHypothesisClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allOpenHypothesisClaimsHaveGapId",
        "HodgeReduction.PaperInventory.openResidualClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allOpenResidualClaimsHaveGapId",
        "HodgeReduction.PaperInventory.newMathGapClaimsWithoutGapIdCount",
        "HodgeReduction.PaperInventory.allNewMathGapClaimsHaveGapId",
        "HodgeReduction.PaperInventory.MasterClaimTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.claimHasEffectiveAuditTagValue",
        "HodgeReduction.PaperInventory.claimHasAnyOpenOrUnportedTag",
        "HodgeReduction.PaperInventory.formalizedClaimsWithOpenOrUnportedTagCount",
        "HodgeReduction.PaperInventory.allFormalizedClaimsAvoidOpenOrUnportedTags",
        "HodgeReduction.PaperInventory.openHypothesisClaimsWithoutNewMathGapTagCount",
        "HodgeReduction.PaperInventory.allOpenHypothesisClaimsTaggedNewMathGap",
        "HodgeReduction.PaperInventory.openResidualClaimsWithoutNewMathGapTagCount",
        "HodgeReduction.PaperInventory.allOpenResidualClaimsTaggedNewMathGap",
        "HodgeReduction.PaperInventory.registeredGapClaimsWithoutMigrationDebtTagCount",
        "HodgeReduction.PaperInventory.allRegisteredGapClaimsTaggedMigrationDebt",
        "HodgeReduction.PaperInventory.conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount",
        "HodgeReduction.PaperInventory.allConditionalMilestoneClaimsTaggedConditionalLeanPackage",
        "HodgeReduction.PaperInventory.MasterClaimDispositionTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterBrokenLinkDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot",
        "HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterSubgapStatusMarkerSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot",
        "HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterPrimaryHypothesisSnapshot",
        "HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot",
        "HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterScopeSubclassStatusSnapshot",
        "HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot",
        "HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.ProjectAxiomTrustBaseSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount",
        "HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus",
        "HodgeReduction.AxiomInventory.ProjectSorryAxSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero",
        "HodgeReduction.MainChain.routeGapIds",
        "HodgeReduction.MainChain.gapIdIsRouteRegistered",
        "HodgeReduction.MainChain.masterClaimGapReferenceIds",
        "HodgeReduction.MainChain.masterClaimGapReferenceCount",
        "HodgeReduction.MainChain.unregisteredMasterClaimGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredMasterClaimGapReferenceCount",
        "HodgeReduction.MainChain.masterClaimsWithUnregisteredGapIds",
        "HodgeReduction.MainChain.masterClaimsWithUnregisteredGapIdCount",
        "HodgeReduction.MainChain.allMasterClaimGapReferencesRegisteredInRoute",
        "HodgeReduction.MainChain.MasterClaimGapReferenceSnapshot",
        "HodgeReduction.MainChain.currentMasterClaimGapReferenceSnapshot",
        "HodgeReduction.MainChain.currentMasterClaimGapReferenceSnapshot_eq_texStatus",
        "HodgeReduction.PaperInventory.MasterAuditSnapshot",
        "HodgeReduction.PaperInventory.currentMasterAuditSnapshot",
        "HodgeReduction.PaperInventory.currentMasterAuditSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.routeLevelGapCount",
        "HodgeReduction.MainChain.routeLevelFinalOpenGapCount",
        "HodgeReduction.MainChain.routeLevelInProgressGapCount",
        "HodgeReduction.MainChain.routeLevelConditionalGapCount",
        "HodgeReduction.MainChain.routeLevelOpenGapCount",
        "HodgeReduction.MainChain.routeLevelDeferredGapCount",
        "HodgeReduction.MainChain.routeLevelActiveOpenGapCount",
        "HodgeReduction.MainChain.RouteGapStatusSnapshot",
        "HodgeReduction.MainChain.currentRouteGapStatusSnapshot",
        "HodgeReduction.MainChain.RouteGapStatusEntry",
        "HodgeReduction.MainChain.routeGapStatusLedger",
        "HodgeReduction.MainChain.gapStatusOf?",
        "HodgeReduction.MainChain.currentRouteGapStatusSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.routeGapStatusLedger_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutNames",
        "HodgeReduction.MainChain.endpointOpenCutCount",
        "HodgeReduction.MainChain.expectedEndpointOpenCutNames",
        "HodgeReduction.MainChain.expectedEndpointOpenCutCount",
        "HodgeReduction.MainChain.endpointOpenCutLedgerMatchesTexStatus",
        "HodgeReduction.MainChain.endpointOpenCutCountMatchesTexStatus",
        "HodgeReduction.MainChain.EndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutCount_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignment",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignments_eq_texStatus",
        "HodgeReduction.MainChain.EndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutRouteAssignmentFailureCount",
        "HodgeReduction.MainChain.EndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot",
        "HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.endpointOpenCutPaperCoverageFailureCount",
        "HodgeReduction.MainChain.MasterRouteGapClaimEntry",
        "HodgeReduction.MainChain.masterRouteGapClaimLedger",
        "HodgeReduction.MainChain.masterRouteGapClaimLedgerClaimReferenceCount",
        "HodgeReduction.MainChain.currentMasterRouteGapClaimLedger_eq_texStatus",
        "HodgeReduction.MainChain.masterRouteGapClaimLedgerClaimReferenceCount_eq_masterClaimGapReferenceCount",
        "HodgeReduction.MainChain.masterRouteGapRowsWithMasterClaims",
        "HodgeReduction.MainChain.masterRouteGapRowsWithoutMasterClaims",
        "HodgeReduction.MainChain.masterRouteGapIdsWithoutMasterClaims",
        "HodgeReduction.MainChain.masterRouteGapRowsWithoutMasterClaimsAreExpectedStructuralInfra",
        "HodgeReduction.MainChain.MasterRouteGapClaimCoverageSnapshot",
        "HodgeReduction.MainChain.currentMasterRouteGapClaimCoverageSnapshot",
        "HodgeReduction.MainChain.currentMasterRouteGapClaimCoverageSnapshot_eq_texStatus",
        "HodgeReduction.MainChain.masterRouteGapClaimCoverageFailureCount",
        "HodgeReduction.MainChain.fullHcGapStatus_eq_finalOpen",
        "HodgeReduction.MainChain.fullHcNarrativeClaimsCompleteProof",
        "HodgeReduction.MainChain.PaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot",
        "HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot_eq_texStatus",
        "HodgeReduction.MainChain.fullHcCompletionOverclaimCount",
        "HodgeReduction.MainChain.fullHcFinalOpenStatusFailureCount",
        "HodgeReduction.MainChain.masterClaimTagPointerFailureCount",
        "HodgeReduction.MainChain.masterClaimDispositionTagMismatchCount",
        "HodgeReduction.MainChain.masterBrokenLinkDisciplineFailureCount",
        "HodgeReduction.MainChain.masterSubgapStatusMarkerFailureCount",
        "HodgeReduction.MainChain.masterPrimaryHypothesisDisciplineFailureCount",
        "HodgeReduction.MainChain.scopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceIds",
        "HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceCount",
        "HodgeReduction.MainChain.allScopeSubclassRouteGapReferencesRegisteredInRoute",
        "HodgeReduction.MainChain.masterScopeSubclassStatusFailureCount",
        "HodgeReduction.MainChain.projectAxiomTrustBaseFailureCount",
        "HodgeReduction.MainChain.projectSorryAxFailureCount",
        "HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus",
        "HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero",
        "HodgeReduction.MainChain.masterSourceDisciplineFailureCount",
        "HodgeReduction.MainChain.masterEnvironmentCoverageFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount",
        "HodgeReduction.MainChain.paperSummaryClaimFailureCount_eq_zero",
        "HodgeReduction.RanCoherenceInputData",
        "HodgeReduction.RanCoherenceInputData.coherence_lemma_from_oka_and_bbt_definable_oka",
        "HodgeReduction.RanCoherenceInputData.input_ran_from_coherence_lemma",
        "HodgeReduction.oka_coherence_does_not_self_close_ran_input",
        "HodgeReduction.CMDensityInputData",
        "HodgeReduction.CMDensityInputData.cm_density_in_special_subvariety_from_tsimerman",
        "HodgeReduction.CMDensityInputData.cm_density_in_hodge_locus_from_special_component",
        "HodgeReduction.specialness_does_not_self_close_cm_density",
        "HodgeReduction.PeterzilStarchenkoInputData",
        "HodgeReduction.PeterzilStarchenkoInputData.definable_closed_analytic_subset_is_algebraic",
        "HodgeReduction.definable_analytic_set_does_not_self_close_algebraicity",
        "HodgeReduction.VoisinIntegralCounterexampleData",
        "HodgeReduction.VoisinIntegralCounterexampleData.integral_hodge_counterexample_from_voisin",
        "HodgeReduction.VoisinIntegralCounterexampleData.voisin_integral_failure_does_not_contradict_rational_target",
        "HodgeReduction.integral_hc_failure_alone_does_not_self_close_rational_scope",
        "HodgeReduction.MargulisConditionalData",
        "HodgeReduction.MargulisConditionalData.arithmeticity_if_monodromy_is_lattice",
        "HodgeReduction.MargulisConditionalData.representation_extension_if_monodromy_is_lattice",
        "HodgeReduction.margulis_rank_inputs_do_not_self_close_without_lattice_hypothesis",
        "HodgeReduction.RationalScalarExtensionDescentData.padic_descent_linear_algebra_core",
        "HodgeReduction.WitnessLatticeHypothesis",
        "HodgeReduction.WitnessLatticeHypothesis.orthogonalComplement_signature_eq_p_two",
        "HodgeReduction.MonodromyLatticeContainmentData",
        "HodgeReduction.containment_in_arithmetic_lattice_does_not_force_finite_covolume",
        "HodgeReduction.ShimuraTypeFibreData",
        "HodgeReduction.ShimuraTypeFibreData.invariant_classes_realized_through_map",
        "HodgeReduction.aniso_empty_isotropic_core",
        "HodgeReduction.CMFibreDensityData",
        "HodgeReduction.CMFibreDensityData.shimura_fibre_density_from_transport",
        "HodgeReduction.cm_density_alone_does_not_force_e7_family_density",
        "HodgeReduction.RankTwoCMCY3CorrespondenceData",
        "HodgeReduction.RankTwoCMCY3CorrespondenceData.algebraicity_from_rank_two_cm_cy3_hypothesis",
        "HodgeReduction.blasius_deligne_do_not_self_close_cm_cy3_correspondence",
        "HodgeReduction.MotivicSpanData",
        "HodgeReduction.MotivicSpanData.rigid_nonabelian_cm_subcase_from_motivic_span",
        "HodgeReduction.cm_correspondence_does_not_self_close_motivic_span",
        "HodgeReduction.AbelianTypeCoverageData",
        "HodgeReduction.AbelianTypeCoverageData.abelian_type_coverage_from_hc_cm_and_ran",
        "HodgeReduction.hc_cm_abelian_does_not_self_close_abelian_type_coverage",
        "HodgeReduction.KugaSatakeP3Data",
        "HodgeReduction.KugaSatakeP3Data.ks_p3_from_spin_hodge_and_correspondence",
        "HodgeReduction.spin_abs_periodicity_does_not_self_close_ks_p3",
        "HodgeReduction.AbsoluteHodgeDescentData",
        "HodgeReduction.AbsoluteHodgeDescentData.ahd_from_wlh_hodge_locus_principleB_and_hcab",
        "HodgeReduction.hc_ab_and_hodge_locus_do_not_self_close_ahd",
        "HodgeReduction.GLBOrthClosureData",
        "HodgeReduction.GLBOrthClosureData.glb_orth_from_meyer_ahd_ks_and_hcab",
        "HodgeReduction.GLBOrthClosureData.orthogonal_coverage_from_glb_orth",
        "HodgeReduction.meyer_input_does_not_self_close_glb_orth",
        "HodgeReduction.GenericFibreInvariantData",
        "HodgeReduction.GenericFibreInvariantData.generic_fibre_invariant_from_full_package",
        "HodgeReduction.invariant_theory_and_chern_classes_do_not_self_close_generic_fibre",
        "HodgeReduction.SatakeAbelianClassificationData",
        "HodgeReduction.SatakeAbelianClassificationData.exceptional_eiii_evii_not_abelian_type",
        "HodgeReduction.exceptional_label_does_not_self_close_satake_classification",
        "HodgeReduction.E7ApproachFTotalSpaceData",
        "HodgeReduction.E7ApproachFTotalSpaceData.total_space_class_from_chern_weil_bridge",
        "HodgeReduction.approach_f_total_space_does_not_self_close_fibre_level_class",
        "HodgeReduction.CMEigenvalueSeparationData",
        "HodgeReduction.CMEigenvalueSeparationData.abelian_type_eigenvalue_separation_from_honda_tate",
        "HodgeReduction.CMEigenvalueSeparationData.nonabelian_e7_eigenvalue_separation_from_honda_tate_extension",
        "HodgeReduction.abelian_honda_tate_does_not_self_close_nonabelian_e7_eigenvalue_separation",
        "HodgeReduction.E7ArithmeticityStep1Data",
        "HodgeReduction.E7ArithmeticityStep1Data.arithmeticity_from_all_inputs",
        "HodgeReduction.e7_arithmeticity_not_from_boundary_data_alone",
        "HodgeReduction.BBTRigidReachData",
        "HodgeReduction.BBTRigidReachData.rigid_isolated_reach_from_full_package",
        "HodgeReduction.bbt_frameworks_do_not_self_close_rigid_isolated_reach",
        "HodgeReduction.NonRigidFamilyBridgeData",
        "HodgeReduction.NonRigidFamilyBridgeData.base_dimension_from_period_package",
        "HodgeReduction.NonRigidFamilyBridgeData.nonrigid_family_bridge_from_full_period_package",
        "HodgeReduction.nonrigidity_does_not_self_close_period_family_bridge",
        "HodgeReduction.E7BBTSpreadingData",
        "HodgeReduction.E7BBTSpreadingData.e7_bbt_spreading_from_full_package",
        "HodgeReduction.E7BBTSpreadingData.individual_scope_transfer_from_family_spreading_and_bridges",
        "HodgeReduction.bbt_cm_density_do_not_self_close_e7_bbt_spreading",
        "HodgeReduction.family_spreading_does_not_self_close_individual_e7_scope",
        "HodgeReduction.E7CMAlgebraicityData",
        "HodgeReduction.E7CMAlgebraicityData.absolute_hodge_from_nonabelian_e7_extension",
        "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_absolute_hodge_and_hbundle",
        "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_full_package",
        "HodgeReduction.abelian_frameworks_do_not_self_close_nonabelian_e7_absolute_hodge",
        "HodgeReduction.absolute_hodge_does_not_self_close_cm_e7_algebraicity",
        "HodgeReduction.E7ChernWeilBridgeData",
        "HodgeReduction.E7ChernWeilBridgeData.compact_dual_nonzero_from_schwarz_bridge",
        "HodgeReduction.E7ChernWeilBridgeData.toroidal_class_from_matsushima_descent",
        "HodgeReduction.E7ChernWeilBridgeData.algebraicity_from_chern_polynomial_identity",
        "HodgeReduction.E7ChernWeilBridgeData.e7_chern_weil_algebraicity_from_full_bridge",
        "HodgeReduction.schwarz_invariant_ring_does_not_self_close_e7_chern_weil",
        "HodgeReduction.cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil",
        "HodgeReduction.ExoticE7NarrowingData",
        "HodgeReduction.ExoticE7NarrowingData.exotic_residual_narrowed_from_geometric_eliminations",
        "HodgeReduction.exotic_narrowing_does_not_self_close_residual",
        "HodgeReduction.TorelliEVIIQuestionData",
        "HodgeReduction.TorelliEVIIQuestionData.exotic_rigid_vacuity_from_evii_uniformisation",
        "HodgeReduction.arithmeticity_and_mok_do_not_self_close_torelli_evii",
        "HodgeReduction.ExoticE7ResidualData",
        "HodgeReduction.ExoticE7ResidualData.exotic_residual_eliminated_from_all_subbranches",
        "HodgeReduction.known_e7_cases_do_not_self_close_exotic_residual",
        "HodgeReduction.FullHCResidualGateData",
        "HodgeReduction.FullHCResidualGateData.full_hodge_conjecture_from_residual_gate",
        "HodgeReduction.E7ResidualStrategyData",
        "HodgeReduction.E7ResidualStrategyData.residual_hc_from_theta_transfer",
        "HodgeReduction.E7ResidualStrategyData.residual_hc_from_padic_route",
        "HodgeReduction.E7ResidualStrategyData.residual_hc_from_bost_charles_route",
        "HodgeReduction.theta_shimura_cycle_does_not_self_close_residual_hc",
        "HodgeReduction.padic_descent_does_not_self_close_residual_hc",
        "HodgeReduction.bost_charles_framework_does_not_self_close_residual_hc",
        "HodgeReduction.OmegaDiagonalData",
        "HodgeReduction.OmegaDiagonalData.cohomological_identity_from_standard_conjecture_package",
        "HodgeReduction.OmegaDiagonalData.omega_algebraic_from_diagonal_standard_conjectures_and_schur",
        "HodgeReduction.OmegaDiagonalData.schur_projector_step_iff_omega_algebraicity",
        "HodgeReduction.standard_conjecture_pair_does_not_self_close_omega_diagonal",
        "HodgeReduction.andre_motivated_closure_does_not_self_close_chow_omega",
        "HodgeReduction.E7ChowModularityData",
        "HodgeReduction.E7ChowModularityData.chow_modularity_from_full_package",
        "HodgeReduction.ThetaIsChowModular",
        "HodgeReduction.IsExceptionalE7ChowModularityExtension_CONJECTURAL",
        "HodgeReduction.orthogonal_chow_frameworks_do_not_self_close_exceptional_e7_chow_modularity",
        "HodgeReduction.E7ThetaModularityData",
        "HodgeReduction.E7ThetaModularityData.cohomological_theta_modularity_from_kernel",
        "HodgeReduction.E7ThetaModularityData.e7_chow_modularity_from_full_package",
        "HodgeReduction.cohomological_theta_does_not_self_close_chow_valued_e7_modularity",
        "HodgeReduction.E7ThetaMatchData",
        "HodgeReduction.E7ThetaMatchData.theta_match_from_full_package",
        "HodgeReduction.E7ThetaMatchData.nonzero_algebraic_theta_cycle_from_match",
        "HodgeReduction.chow_modularity_and_theta_framework_do_not_self_close_theta_match",
        "HodgeReduction.E7ThetaStepIIIData",
        "HodgeReduction.E7ThetaStepIIIData.shimura_side_cycle_seeding_from_theta_package",
        "HodgeReduction.E7ThetaStepIIIData.hbundle_cycle_seeding_from_theta_and_fibre_transfer",
        "HodgeReduction.shimura_side_theta_cycle_does_not_self_close_fibre_transfer",
        "HodgeReduction.HBundleMatchingData",
        "HodgeReduction.HBundleMatchingData.bundle_matching_from_rigid_point_case",
        "HodgeReduction.HBundleMatchingData.bundle_matching_from_toroidal_reduction_package",
        "HodgeReduction.known_hbundle_cases_do_not_self_close_arbitrary_nontoroidal_boundary",
        "HodgeReduction.HBundleCycleSeedingData",
        "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_low_dimensional_lefschetz",
        "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_nonrigid_e7_package",
        "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_known_rigid_e7_package",
        "HodgeReduction.low_dimensional_hbundle_does_not_self_close_high_dimensional_residual",
        "HodgeReduction.HBundleInputData",
        "HodgeReduction.HBundleInputData.hbundle_input_from_matching_and_cycle_seeding",
        "HodgeReduction.bundle_matching_does_not_self_close_hbundle_input",
        "HodgeReduction.FibreTransferData",
        "HodgeReduction.FibreTransferData.base_level_algebraicity_from_shimura_side",
        "HodgeReduction.shimura_side_and_period_map_do_not_self_close_fibre_algebraicity",
        "HodgeReduction.E7FibreInvariantClassSplitData",
        "HodgeReduction.E7FibreInvariantClassSplitData.all_invariant_classes_from_h3_algebraicity",
        "HodgeReduction.motivated_h3_class_does_not_self_close_algebraicity",
        "HodgeReduction.Q4AbelianAlgebraicityData",
        "HodgeReduction.Q4AbelianAlgebraicityData.pointwise_q4_algebraicity_from_cm_abelian_bridge",
        "HodgeReduction.Q4AbelianAlgebraicityData.global_q4_algebraicity_from_full_transfer",
        "HodgeReduction.pointwise_q4_algebraicity_does_not_self_close_global_e7",
        "HodgeReduction.MokTorelliConditionalShape",
        "HodgeReduction.mok_conditional_does_not_self_close_torelli"
      ]
      gapIds := ["G-master-paper-import", "G-full-hc"]
      dependsOn := ["full-hc-final-target"]
      attackPlan := [
        "Use `../contributions/hodge-conjecture-master-proof.tex` as the only canonical source for paper import.",
        "For every master-paper theorem, hypothesis, input, and open question, choose exactly one Lean disposition: existing declaration, new theorem, external-citation carrier, or named gap.",
        "Treat attack-map, literature, and round-contribution tex files as archive/background until a statement is promoted into the master tex.",
        "Drive the import by reducing `unclaimedMasterEnvironments`; do not convert conditional master claims into unconditional theorem statements."
      ]
      successCriterion :=
        "All legitimate master-paper content is represented inside the Lean folder, with every unresolved item attached to an explicit gap id and no non-master source treated as canonical."
    },
    {
      id := "main-hc-axiom-relative"
      title := "Canonical E7 Mumford--Tate-reduction milestone"
      kind := "milestone"
      status := "conditional"
      summary :=
        "`OpenHypotheses` (R169 cohomology / algClasses bridge + R174a Deligne) composes with `MainTheorem` (R170 four-case main reduction + R171/R188/R542/R551 canonical headline) to reach `hodgeConjectureReal_canonical`.  This is explicitly a milestone toward `FullHodgeConjectureReal`, not the final project theorem.  R546 adds the separately audited codim-one endpoint `hodgeConjectureReal_canonical_codim1`; R550 reroutes it directly through the classical Lefschetz (1,1) cut; R551 uses that endpoint for the `p = 1` branch of the full canonical proof, uses the direct non-codim-one MT package for `p 鈮?1`, and avoids mentioning `canonicalHCDataByCodim` in the endpoint type.  Full HC still requires a universal route over all smooth projective complex varieties."
      files := [
        "HodgeReduction/Types.lean",
        "HodgeReduction/ClassicalResults.lean",
        "HodgeReduction/OpenHypotheses.lean",
        "HodgeReduction/MainTheorem.lean",
        "HodgeReduction/HCGapRegistry.lean"
      ]
      entryDecls := [
        "HodgeReduction.hodgeConjectureReal_canonical",
        "HodgeReduction.hodgeConjectureReal_canonical_codim1",
        "HodgeReduction.main_reduction_real"
      ]
      gapIds := [
        "G-full-hc",
        "G-main-hc",
        "G-l1-e7-shimura-tor",
        "G-l2-cohomology-construction",
        "G-l3-v56-mt-identification",
        "G-l4-cm-abelian-hc",
        "G-l4-mt-correspondence"
      ]
      dependsOn := ["full-hc-final-target"]
    },
    {
      id := "unconditional-classical"
      title := "Unconditional classical paper theorems"
      kind := "support"
      status := "closed-modulo-cy3-citation"
      summary :=
        "Meyer / G_2 / F_4 / E_8 vacuity are kernel-pure derived theorems.  `thm_cy3_e7_nonexistence` still consumes `cy3_e7_nonexistence_paper_axiom` (paper 搂4 Stages A--D)."
      files := [
        "HodgeReduction/ClassicalResults.lean",
        "HodgeReduction/MainTheorem.lean"
      ]
      entryDecls := [
        "HodgeReduction.thm_Meyer",
        "HodgeReduction.thm_G2F4",
        "HodgeReduction.thm_E8_vacuous",
        "HodgeReduction.thm_cy3_e7_nonexistence",
        "HodgeReduction.thm_subcase3b_vacuous"
      ]
      gapIds := ["G-classical-mathlib-port"]
      dependsOn := []
    },
    {
      id := "hcgap-l2-trivial-instances"
      title := "Layer-2 minimum attack: trivial-instance VarietyCohomologyData"
      kind := "support"
      status := "stable"
      summary :=
        "R201 minimum-attack instances of `VarietyCohomologyData`: trivial point (dim 0), projective line (dim 1), elliptic curve (dim 1).  Provides the template that a future E_7 construction must follow."
      files := [
        "HodgeReduction/HCGapL2/TrivialPoint.lean",
        "HodgeReduction/HCGapL2/ProjectiveLine.lean",
        "HodgeReduction/HCGapL2/EllipticCurve.lean"
      ]
      entryDecls := []
      gapIds := ["G-l2-cohomology-construction"]
      dependsOn := ["main-hc-axiom-relative"]
    },
    {
      id := "hcgap-l4-multifront-active"
      title := "HCGapL4 multi-front attack waves (R420 -- R665)"
      kind := "active"
      status := "exploratory"
      summary :=
        "5 parallel attack fronts on the L4 cohomology-profile + connectedness pipeline.  Per-wave audits R451 / R456 / R460 / R465 / R470 / R476 enumerate substantive theorems per round.  R552 extends the FrontC numeric bridge through a buildable EVII compact-dual/V56/Shimura expected Betti profile: all degrees 0..8 are certified by known Hodge sums, with degree 3 explicitly routed through V56 rather than hidden in compact-dual odd cohomology.  R553 connects that finite V56 profile to the actual infrastructure `PureHodgeStructure V56 3`.  R554 proves the abstract Matsushima boundary composition: target invariants reduce to the cuspidal trivial-module part, and compact-dual image reduces to that part once concrete EVII source/target boundary equalities are provided.  R555 tightens the source-side obligation: Cartan's trivial-module H8 line rewrites to compact-dual H8, its classes are algebraic through `CompactDualData`, and the R554 source equality follows from `surjectivity_source = source_invariants`.  R556 converts the remaining boundary equalities into four concrete linear-algebra tasks; R557 shows target containment is forced by source containment; R558 transports target finrank from source finrank; R559 rewrites the remaining source obligations against compact-dual/Cartan data; R560 proves those obligations are not derivable from the current abstract interface alone; R561 replaces the three R559 obligations by the sharper compact-dual exact image target plus target-invariant exactness; R562 removes target-invariant exactness as an independent obligation by deriving it from exact image plus the compactDual/trivialModulePart rank bridge; R563 proves exact image is equivalent to the source equality `surjectivity_source = compactDual`; R564 closes the compact-dual H8 rank-one side and reduces the rank bridge to `compactDual = H8` plus `finrank trivialModulePart = 1`; R565 replaces that target rank-one obligation by exact Cartan image equality; R566 rewrites the remaining source and compact-dual carrier obligations to Cartan-line exactness; R567 blocks any attempt to derive those exactness statements from the current abstract interface alone; R568 turns exact Cartan image into the element-level scalar-preimage target `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta`; R569 shows that even compactDual = Cartan does not force that scalar-surjectivity target; R570 proves that target rank-one plus compactDual = Cartan is enough for exact Cartan image; R571/R572 reduce the live target to source equality, source-invariants/H8, and expected Betti-8 target rank; R573 splits source-invariants/H8 into no-extra-source containment and `h^4` generator membership, with a source-rank-one alternate route; R574 rewrites that source-carrier split through `MatsushimaCompactDualData.compactDual`, leaving compactDual containment in H8 plus generator membership as the next concrete carrier targets; R575 rewrites those as the Cartan/compactDual containments `compactDual <= CartanH8` and `CartanH8 <= compactDual`; R576 rewrites source equality as source/Cartan two-sided containment and feeds the two source directions plus the two compactDual directions into the boundary package; R577 records that all four carrier directions still do not imply the target expected-Betti rank; R578 routes that target rank through the degree-8 compact-dual Hodge-sum profile; R579 derives the target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from compactDual/Cartan two-sided containment plus scalar preimage surjectivity; R581 proves that target Hodge-sum rank and scalar-preimage surjectivity are equivalent once the four Cartan carrier directions are fixed; R582 rewrites the four Cartan carrier directions as source/compactDual H8 no-extra plus h^4 generator-membership splits; R583 collapses each H8 split to exact equality with H8; R584 translates those H8 equalities into Matsushima boundary language and proves target Hodge-sum rank is equivalent to `surjectivity_target = trivialModulePart`; R585 proves that, after `compactDual = H8`, this concrete boundary package is equivalent to the existing `MatsushimaV56BoundaryData`; R586 records a countermodel showing the H8 carrier equalities alone do not force the target boundary equality or boundary data; R587 isolates the remaining target boundary as the single reverse containment `trivialModulePart <= surjectivity_target`, and proves that this containment is also not forced by the abstract H8 carrier interface; R588 proves this reverse containment is exactly the element-level scalar-preimage statement `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta` once `source = H8`, with no finite-dimensional rank hypothesis; R589 proves that, under the two H8 carrier equalities, target boundary/scalar preimages/boundary data/target Hodge-sum are all equivalent to `finrank trivialModulePart = 1`, and the rank-one target is not forced by the abstract H8 carrier interface.  R590 proves the target expected-Betti rank is equivalent to that rank-one theorem, identifies boundary data with expected-Betti rank under the H8 carriers, and records that the H8 carrier interface still does not force the expected-Betti target.  R591 names the exact residual package: prove the two H8 carrier equalities and target-invariant rank one; this package feeds the existing boundary bridge.  R592 proves this rank-one residual package is equivalent to the scalar-preimage residual package.  R593 packages the equivalent target-boundary residual package and records that the abstract H8 carrier interface still does not force it.  R594 packages the same residual target as `compactDual = H8` plus the existing `MatsushimaV56BoundaryData` bridge.  R595 rewrites that residual bridge as `compactDual = H8`, compact-dual exact image, and target-invariant exactness.  R596 replaces that target-invariant exactness by the equivalent rank-one target `finrank trivialModulePart = 1` once compact-dual exact image is fixed.  R597 proves that this exact-image rank-one package is equivalent to Cartan-line source/compact-dual equalities plus `finrank trivialModulePart = 1`, exposing the live residual as Cartan H8 carrier exactness and target rank.  R598 rewrites that same residual as `surjectivity_source = source_invariants`, `source_invariants = H8`, and `finrank target_invariants = 1`.  R599 proves the R598 source-invariant package is directly equivalent to the earlier R591 H8/rank-one residual package, recovers the expected Betti-8 target rank from it, and records that `source_invariants = H8` alone still does not force the full residual.  R600 replaces the target-rank spelling inside that package by the expected-Betti-8 equality `finrank target_invariants = shimuraEVIIExpectedBetti 8`, proves equivalence with R598, and keeps the same obstruction visible.  R601 splits the source-invariants/H8 equality into the equivalent source-carrier targets `source_invariants <= H8` plus `h^4` membership, packages that split against the R600 expected-Betti target, and keeps the obstruction visible.  R602 moves that same residual to the equivalent compact-dual carrier targets `compactDual <= H8` plus `h^4` membership in `compactDual`, using the existing compactDual/source-invariants comparison and preserving the obstruction.  R603 proves this R602 package is equivalent to the four Cartan containment directions together with the same target expected-Betti theorem, while preserving the R577 obstruction that carrier facts alone do not force target rank.  R604 splits the R603 residual into four carrier directions plus one target expected-Betti theorem and certifies primitive target count 5.  R605 proves that this fifth target can equivalently be attacked as scalar-preimage surjectivity under the same four carrier directions, so expected-Betti rank and scalar preimage are one target, not two.  R606 flattens the same residual into the five named paper-facing primitive targets and kernel-checks that expected-Betti rank and scalar preimage are not counted separately.  R607 proves that the five paper-facing primitive targets are equivalent to the three proof-work obligations `surjectivity_source = CartanH8`, `compactDual = CartanH8`, and scalar-preimage surjectivity.  R608 reconciles scalar-preimage surjectivity with the older `finrank trivialModulePart = 1` rank-one target under the two Cartan-line equalities, so those spellings are not separate gaps.  R609 proves that the two Cartan-line carrier equalities alone do not force the scalar/rank-one target in the current abstract interface.  R610 packages the exact live proof-work contract as those two equalities plus one scalar/rank-one target, proves it is equivalent to the R607/R608 residual ledgers, and records that the contract is not a closure claim.  R634 rewrites that same contract as the source-invariant scalar contract `surjectivity_source = source_invariants`, `source_invariants = H8`, plus scalar/rank-one target, without adding finite-dimensional rank conversion or closure claim.  R635 replaces the first R634 equality by the equivalent exact-image equation `Submodule.map j_q source_invariants = surjectivity_target`, using only the existing Matsushima image equation and injectivity.  R636 replaces the scalar/rank-one target by the equivalent reverse target containment `trivialModulePart <= surjectivity_target` once exact image and `source_invariants = H8` are fixed.  R637 records the matching obstruction: those exact-image carriers do not force the reverse target containment in the current abstract interface.  R638 rewrites that target theorem as exact Matsushima target-invariant image saturation: under exact image, the live target is `Submodule.map j_q source_invariants = target_invariants`, and the carrier countermodel still blocks deriving it abstractly.  R639 proves this saturation is equivalent to the finite-dimensional invariant-rank equality `finrank source_invariants = finrank target_invariants`, so the next target is a genuine EVII target-invariant rank computation.  R640 reconciles that target with the existing R600 expected-Betti residual, showing that under `source_invariants = H8` it is exactly `finrank target_invariants = shimuraEVIIExpectedBetti 8`.  R641 rewrites the target side as the vanishing of the target-invariant excess quotient by `Submodule.map j_q source_invariants`, equivalent to saturation and expected-Betti under `source_invariants = H8`.  R642 identifies the kernel of this quotient map as the source-invariant image inside `target_invariants`, proves range/kernel rank-nullity, and turns quotient vanishing into codimension zero for that internal subspace.  R643 makes the codimension target numerical: prove `finrank targetInvariantExcessQuotient = 0`, equivalently the R600/R640 expected-Betti target under `source_invariants = H8`.  The route remains exploratory, not a closure claim."
      files := [
        "HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean",
        "HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean",
        "HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean",
        "HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean",
        "HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean",
        "HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean",
        "HodgeReduction/HCGapL4/FrontC7_E7EVIIHodgeDiamondInstance.lean",
        "HodgeReduction/HCGapL4/FrontC8_V56MTBridge.lean",
        "HodgeReduction/HCGapL4/FrontC9_EVIIHodgeNumberComputation.lean",
        "HodgeReduction/HCGapL4/FrontC10_V56CohomologyIdentification.lean",
        "HodgeReduction/HCGapL4/FrontC11_ShimuraBettiComputation.lean",
        "HodgeReduction/HCGapL4/FrontC12_V56InfrastructureProfileBridge.lean",
        "HodgeReduction/HCGapL4/FrontC13_MatsushimaV56BoundaryBridge.lean",
        "HodgeReduction/HCGapL4/FrontC14_CartanCompactDualSourceBridge.lean",
        "HodgeReduction/HCGapL4/FrontC15_MatsushimaBoundaryRankCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC16_MatsushimaTargetContainmentFromSource.lean",
        "HodgeReduction/HCGapL4/FrontC17_MatsushimaTargetRankFromSource.lean",
        "HodgeReduction/HCGapL4/FrontC18_MatsushimaSourceCompactDualRankBridge.lean",
        "HodgeReduction/HCGapL4/FrontC19_MatsushimaSourceCompactDualObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC20_MatsushimaCompactDualExactImageCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC21_MatsushimaExactImageRankBoundary.lean",
        "HodgeReduction/HCGapL4/FrontC22_MatsushimaExactImageSourceEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC23_MatsushimaCompactDualRankOne.lean",
        "HodgeReduction/HCGapL4/FrontC24_CartanImageTrivialRank.lean",
        "HodgeReduction/HCGapL4/FrontC25_CartanLineBoundaryExactness.lean",
        "HodgeReduction/HCGapL4/FrontC26_CartanLineExactnessObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC27_CartanImageScalarPreimage.lean",
        "HodgeReduction/HCGapL4/FrontC28_ScalarPreimageObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC29_CartanImageFromRankOne.lean",
        "HodgeReduction/HCGapL4/FrontC30_SourceInvariantsH8TargetRank.lean",
        "HodgeReduction/HCGapL4/FrontC31_TargetRankFromExpectedBetti.lean",
        "HodgeReduction/HCGapL4/FrontC32_SourceInvariantsH8CarrierCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC33_CompactDualH8CarrierCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC34_CartanContainmentsForCompactDual.lean",
        "HodgeReduction/HCGapL4/FrontC35_SourceCartanContainments.lean",
        "HodgeReduction/HCGapL4/FrontC36_TargetBettiObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC37_TargetRankHodgeSumBridge.lean",
        "HodgeReduction/HCGapL4/FrontC38_TargetHodgeSumFromCartanImage.lean",
        "HodgeReduction/HCGapL4/FrontC39_TargetHodgeSumFromScalarPreimage.lean",
        "HodgeReduction/HCGapL4/FrontC40_TargetRankScalarPreimageEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC41_CartanContainmentCarrierEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC42_H8CarrierEqualityRoute.lean",
        "HodgeReduction/HCGapL4/FrontC43_H8BoundaryEqualityRoute.lean",
        "HodgeReduction/HCGapL4/FrontC44_BoundaryDataH8Equivalence.lean",
        "HodgeReduction/HCGapL4/FrontC45_H8BoundaryDataObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC46_TargetSurjectivityContainmentCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC47_TargetContainmentScalarPreimageCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC48_H8BoundaryRankOneCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC49_H8BoundaryExpectedBettiCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC50_H8ResidualObligationPackage.lean",
        "HodgeReduction/HCGapL4/FrontC51_H8ResidualScalarPreimagePackage.lean",
        "HodgeReduction/HCGapL4/FrontC52_H8ResidualBoundaryPackage.lean",
        "HodgeReduction/HCGapL4/FrontC53_H8ResidualBoundaryDataPackage.lean",
        "HodgeReduction/HCGapL4/FrontC54_H8ResidualExactImagePackage.lean",
        "HodgeReduction/HCGapL4/FrontC55_H8ResidualExactImageRankOnePackage.lean",
        "HodgeReduction/HCGapL4/FrontC56_H8ResidualCartanRankOnePackage.lean",
        "HodgeReduction/HCGapL4/FrontC57_H8ResidualSourceInvariantTargetRankPackage.lean",
        "HodgeReduction/HCGapL4/FrontC58_H8ResidualSourceInvariantNormalization.lean",
        "HodgeReduction/HCGapL4/FrontC59_H8ResidualExpectedBettiPackage.lean",
        "HodgeReduction/HCGapL4/FrontC60_H8ResidualSourceCarrierSplitPackage.lean",
        "HodgeReduction/HCGapL4/FrontC61_H8ResidualCompactDualCarrierPackage.lean",
        "HodgeReduction/HCGapL4/FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.lean",
        "HodgeReduction/HCGapL4/FrontC63_H8ResidualPrimitiveGapSplit.lean",
        "HodgeReduction/HCGapL4/FrontC64_H8ResidualScalarPreimagePrimitiveSplit.lean",
        "HodgeReduction/HCGapL4/FrontC65_H8ResidualPrimitiveTargetLedger.lean",
        "HodgeReduction/HCGapL4/FrontC66_H8ResidualEqualityTargetLedger.lean",
        "HodgeReduction/HCGapL4/FrontC67_H8ResidualRankOneReconciliation.lean",
        "HodgeReduction/HCGapL4/FrontC68_H8ResidualCarrierEqualityObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC69_H8ResidualProofWorkContract.lean",
        "HodgeReduction/HCGapL4/FrontC70_H8ResidualSourceInvariantScalarContract.lean",
        "HodgeReduction/HCGapL4/FrontC71_H8ResidualSourceInvariantExactImageContract.lean",
        "HodgeReduction/HCGapL4/FrontC72_H8ResidualExactImageContainmentContract.lean",
        "HodgeReduction/HCGapL4/FrontC73_H8ResidualExactImageContainmentObstruction.lean",
        "HodgeReduction/HCGapL4/FrontC74_H8ResidualTargetInvariantSaturation.lean",
        "HodgeReduction/HCGapL4/FrontC75_H8ResidualTargetInvariantRankCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC76_H8ResidualRankCriterionReconciliation.lean",
        "HodgeReduction/HCGapL4/FrontC77_H8ResidualTargetInvariantExcessQuotient.lean",
        "HodgeReduction/HCGapL4/FrontC78_H8ResidualTargetInvariantInternalQuotient.lean",
        "HodgeReduction/HCGapL4/FrontC79_H8ResidualTargetInvariantExcessFinrank.lean",
        "HodgeReduction/HCGapL4/FrontC80_H8ResidualTargetInvariantUpperBound.lean",
        "HodgeReduction/HCGapL4/FrontC81_H8ResidualTrivialModuleUpperBound.lean",
        "HodgeReduction/HCGapL4/FrontC82_H8ResidualAtlasMultiplicityCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC83_H8ResidualCartanImageScalarPreimage.lean",
        "HodgeReduction/HCGapL4/FrontC84_H8ResidualScalarPreimageQuotientEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC85_H8ResidualQuotientUpperBoundNoFinite.lean",
        "HodgeReduction/HCGapL4/FrontC86_H8ResidualTargetInvariantPreimageCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC87_H8ResidualInvariantMapSurjectivity.lean",
        "HodgeReduction/HCGapL4/FrontC88_H8ResidualInvariantMapBijectivity.lean",
        "HodgeReduction/HCGapL4/FrontC89_H8ResidualInvariantMapRightInverse.lean",
        "HodgeReduction/HCGapL4/FrontC90_H8ResidualInvariantMapRightInverseEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC92_H8ResidualCartanGeneratorLineCriterion.lean",
        "HodgeReduction/HCGapL4/FrontC93_H8ResidualLineContainmentFromMultiplicity.lean",
        "HodgeReduction/HCGapL4/FrontC94_H8ResidualQuotientLineContainmentEquivalence.lean",
        "HodgeReduction/HCGapL4/FrontC95_H8ResidualSourceNoExtraFromLineContainment.lean",
        "HodgeReduction/HCGapL4/FrontC96_H8ResidualSourceGeneratorFromCompactDual.lean",
        "HodgeReduction/HCGapL4/FrontC97_H8ResidualCartanToCompactDualLine.lean",
        "HodgeReduction/HCGapL4/FrontC98_H8ResidualExactImageIndependence.lean",
        "HodgeReduction/HCGapL4/FrontC99_H8ResidualTargetLineIndependence.lean",
        "HodgeReduction/HCGapL4/FrontC100_H8ResidualCartanContainmentIndependence.lean",
        "HodgeReduction/HCGapL4/FrontC101_H8ResidualTargetInvariantLineBridge.lean",
        "HodgeReduction/HCGapL4/FrontE6_FeedR405ConditionalTransfer.lean",
        "HodgeReduction/HCGapL4/FrontD6_Deligne1982MinimalFragment.lean",
        "HodgeReduction/HCGapL4/R476_MultiFrontWave6Audit.lean"
      ]
      entryDecls := [
        "HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBettiKnownHodgeSumCertification_current",
        "HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimura_expected_known_hodgeSum_total",
        "HodgeReduction.HCGapL4.FrontC12_V56InfrastructureProfileBridge.v56InfrastructureProfileCertification_current",
        "HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge.matsushima_compactDual_image_eq_trivialModulePart",
        "HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge.matsushimaV56BoundaryCertification_from_boundary",
        "HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.cartan_trivialModuleGK_H8_classes_are_algebraic",
        "HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.matsushimaV56BoundaryData_of_source_target_invariants",
        "HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.cartanCompactDualSourceCertification_current",
        "HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.source_eq_invariants_of_le_finrank",
        "HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.target_eq_trivialModulePart_of_le_finrank",
        "HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.matsushimaV56BoundaryData_of_rank_criteria",
        "HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.surjectivity_target_le_trivialModulePart_of_source_le",
        "HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.target_eq_invariants_of_source_le_target_finrank",
        "HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.matsushimaV56BoundaryData_of_source_le_source_rank_target_rank",
        "HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.surjectivity_target_finrank_eq_source",
        "HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.target_finrank_eq_trivialModulePart_of_source_finrank_trivial",
        "HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.matsushimaV56BoundaryData_of_source_le_source_rank_source_to_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.source_eq_invariants_of_source_le_compactDual_rank",
        "HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.source_finrank_eq_trivialModulePart_of_compactDual_rank",
        "HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.matsushimaV56BoundaryData_of_source_le_compactDual_rank_compactDual_to_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC19_MatsushimaSourceCompactDualObstruction.current_interface_does_not_force_R559_targets",
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.source_eq_compactDual_of_compactDual_image_eq_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.compactDual_finrank_eq_trivialModulePart_of_exact_image_target_eq",
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq",
        "HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.target_eq_invariants_of_compactDual_exact_image_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.matsushimaV56BoundaryData_of_compactDual_exact_image_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.matsushima_compactDual_image_eq_trivialModulePart_of_exact_image_rank",
        "HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.source_eq_compactDual_iff_compactDual_exact_image",
        "HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.matsushimaV56BoundaryData_of_source_eq_compactDual_trivial_rank",
        "HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_rank",
        "HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_H8_finrank_eq_one",
        "HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_finrank_eq_trivialModulePart_of_H8_rank_one",
        "HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.matsushimaV56BoundaryData_of_source_eq_H8_rank_one",
        "HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.map_cartan_trivialModuleGK_H8_finrank_eq_one",
        "HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.trivialModulePart_finrank_eq_one_of_cartan_image",
        "HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.matsushimaV56BoundaryData_of_source_eq_H8_cartan_image",
        "HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.matsushima_compactDual_eq_H8_of_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.matsushimaV56BoundaryData_of_cartan_line_exactness",
        "HodgeReduction.HCGapL4.FrontC26_CartanLineExactnessObstruction.current_interface_does_not_force_cartan_line_exactness",
        "HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage.cartan_image_eq_trivialModulePart_iff_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC28_ScalarPreimageObstruction.current_interface_with_compactDual_cartan_does_not_force_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC29_CartanImageFromRankOne.cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one",
        "HodgeReduction.HCGapL4.FrontC30_SourceInvariantsH8TargetRank.matsushimaV56BoundaryData_of_source_invariants_H8_target_rank_one",
        "HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti.matsushimaV56BoundaryData_of_source_invariants_H8_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC32_SourceInvariantsH8CarrierCriterion.matsushimaV56BoundaryData_of_source_le_H8_h_pow_4_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC33_CompactDualH8CarrierCriterion.matsushimaV56BoundaryData_of_compactDual_le_H8_h_pow_4_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC34_CartanContainmentsForCompactDual.matsushimaV56BoundaryData_of_compactDual_cartan_containments_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC35_SourceCartanContainments.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction.current_interface_with_four_cartan_containments_does_not_force_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC37_TargetRankHodgeSumBridge.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_hodgeSum8",
        "HodgeReduction.HCGapL4.FrontC38_TargetHodgeSumFromCartanImage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_cartan_image",
        "HodgeReduction.HCGapL4.FrontC39_TargetHodgeSumFromScalarPreimage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC40_TargetRankScalarPreimageEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_cartan_containments",
        "HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_H8_splits",
        "HodgeReduction.HCGapL4.FrontC42_H8CarrierEqualityRoute.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence.target_hodgeSum8_iff_matsushimaV56BoundaryData_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.current_interface_with_H8_equalities_does_not_force_target_boundary",
        "HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.target_hodgeSum8_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.counterexample_not_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.target_boundary_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.counterexample_not_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion.target_boundary_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion.current_interface_with_H8_equalities_does_not_force_trivialModulePart_rank_one",
        "HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion.matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion.current_interface_with_H8_equalities_does_not_force_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.target_expected_betti8_iff_target_invariants_finrank_eq_one",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.EVIIH8ResidualRankOneObligations",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.target_expected_betti8_of_residual_obligations",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.matsushimaV56BoundaryData_of_residual_obligations",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.matsushimaV56BoundaryData_of_H8_and_target_rank_one",
        "HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.current_interface_with_H8_equalities_does_not_force_target_rank_one",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.target_expected_betti8_iff_scalar_preimage_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.EVIIH8ResidualScalarPreimageObligations",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.rankOneResidual_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.scalarPreimageResidual_of_rankOneResidual",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.residual_rankOne_nonempty_iff_scalarPreimage_nonempty",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.matsushimaV56BoundaryData_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.current_interface_with_H8_equalities_does_not_force_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.EVIIH8ResidualBoundaryObligations",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.boundaryResidual_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.scalarPreimageResidual_of_boundaryResidual",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.residual_scalarPreimage_nonempty_iff_boundary_nonempty",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.residual_rankOne_nonempty_iff_boundary_nonempty",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.matsushimaV56BoundaryData_of_boundaryResidual",
        "HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.current_interface_with_H8_equalities_does_not_force_target_boundary",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.EVIIH8ResidualBoundaryDataObligations",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.boundaryResidual_of_boundaryDataResidual",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.boundaryDataResidual_of_boundaryResidual",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_boundary_nonempty_iff_boundaryData_nonempty",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_scalarPreimage_nonempty_iff_boundaryData_nonempty",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_rankOne_nonempty_iff_boundaryData_nonempty",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.matsushimaV56BoundaryData_of_boundaryDataResidual",
        "HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.current_interface_with_compactDual_eq_H8_does_not_force_boundaryData",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.EVIIH8ResidualExactImageObligations",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.exactImageResidual_of_boundaryDataResidual",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.boundaryDataResidual_of_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_boundaryData_nonempty_iff_exactImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_scalarPreimage_nonempty_iff_exactImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_rankOne_nonempty_iff_exactImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.matsushimaV56BoundaryData_of_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.current_interface_with_compactDual_eq_H8_does_not_force_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.EVIIH8ResidualExactImageRankOneObligations",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.exactImageResidual_of_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.exactImageRankOneResidual_of_exactImageResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_exactImage_nonempty_iff_exactImageRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_boundaryData_nonempty_iff_exactImageRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_rankOne_nonempty_iff_exactImageRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.matsushimaV56BoundaryData_of_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.current_interface_with_compactDual_eq_H8_does_not_force_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.EVIIH8ResidualCartanRankOneObligations",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.exactImageRankOneResidual_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.cartanRankOneResidual_of_exactImageRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.residual_exactImageRankOne_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.residual_boundaryData_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.matsushimaV56BoundaryData_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.current_interface_with_compactDual_eq_H8_does_not_force_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.EVIIH8ResidualSourceInvariantTargetRankObligations",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.cartanRankOneResidual_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.sourceInvariantTargetRankResidual_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.residual_cartanRankOne_nonempty_iff_sourceInvariantTargetRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.residual_boundaryData_nonempty_iff_sourceInvariantTargetRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.matsushimaV56BoundaryData_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.current_interface_with_compactDual_eq_H8_does_not_force_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.residualRankOne_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.sourceInvariantTargetRankResidual_of_residualRankOne",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.residual_rankOne_nonempty_iff_sourceInvariantTargetRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.target_expected_betti8_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.EVIIH8ResidualSourceInvariantExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.sourceInvariantExpectedBettiResidual_of_sourceInvariantTargetRankResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.residual_sourceInvariantTargetRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.target_rank_one_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.matsushimaV56BoundaryData_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.source_invariants_eq_H8_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.h_pow_four_mem_source_invariants_of_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.sourceCarrierSplitResidual_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.residual_sourceInvariantExpectedBetti_nonempty_iff_sourceCarrierSplit_nonempty",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.matsushimaV56BoundaryData_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.EVIIH8ResidualCompactDualCarrierExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.sourceCarrierSplitResidual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.compactDualCarrierResidual_of_sourceCarrierSplitResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.residual_sourceCarrierSplit_nonempty_iff_compactDualCarrier_nonempty",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.sourceInvariantExpectedBettiResidual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.matsushimaV56BoundaryData_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.current_interface_with_compactDualCarrier_does_not_force_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.EVIIH8ResidualCartanContainmentExpectedBettiObligations",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.compactDualCarrierResidual_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_of_h_pow_four_mem",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.compactDual_le_cartan_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_compactDual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.source_le_cartan_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_source_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartanContainmentResidual_of_compactDualCarrierResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.residual_compactDualCarrier_nonempty_iff_cartanContainment_nonempty",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.matsushimaV56BoundaryData_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.current_interface_with_cartanContainments_does_not_force_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.EVIIH8ResidualCartanCarrierObligations",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.EVIIH8ResidualExpectedBettiTargetObligation",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.cartanContainmentResidual_of_carrier_and_expectedBetti",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.carrierObligations_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.expectedBettiTargetObligation_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.residual_cartanContainment_nonempty_iff_carrier_and_expectedBetti_nonempty",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.matsushimaV56BoundaryData_of_carrier_and_expectedBetti",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.current_interface_with_carrierObligations_does_not_force_expectedBettiTarget",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.R604PrimitiveResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.currentR604PrimitiveResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.currentR604PrimitiveResidualSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.EVIIH8ResidualCartanScalarPreimageObligations",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.expectedBettiTarget_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.cartanContainmentResidual_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.carrierScalarPreimage_of_cartanContainmentResidual",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.residual_cartanContainment_nonempty_iff_carrierScalarPreimage_nonempty",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.matsushimaV56BoundaryData_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.current_interface_with_carrierObligations_does_not_force_scalarPreimage",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.R605ScalarPreimageResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.currentR605ScalarPreimageResidualSnapshot",
        "HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.currentR605ScalarPreimageResidualSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.sourceToCartanPrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanToSourcePrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.compactDualToCartanPrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanToCompactDualPrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.scalarPreimagePrimitiveTarget",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.EVIIH8ResidualFivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.fivePrimitiveTargets_of_carrierScalarPreimage",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.carrierScalarPreimage_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.residual_carrierScalarPreimage_nonempty_iff_fivePrimitiveTargets_nonempty",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanContainmentResidual_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.matsushimaV56BoundaryData_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetNames",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.R606PrimitiveTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetLedgerSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.sourceCartanEqualityTarget",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.compactDualCartanEqualityTarget",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.EVIIH8ResidualEqualityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.equalityScalarTargets_of_fivePrimitiveTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.fivePrimitiveTargets_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.residual_fivePrimitiveTargets_nonempty_iff_equalityScalarTargets_nonempty",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.cartanContainmentResidual_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.matsushimaV56BoundaryData_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607ProofWorkTargetNames",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.R607EqualityTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607EqualityTargetLedgerSnapshot",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607EqualityTargetLedgerSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607ProofWorkTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.scalarPreimageResidual_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.equalityScalarTargets_of_scalarPreimageResidual",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.residual_scalarPreimage_nonempty_iff_equalityScalarTargets_nonempty",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.cartanRankOneResidual_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.equalityScalarTargets_of_cartanRankOneResidual",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.residual_equalityScalarTargets_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationTargetNames",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.R608RankOneReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.counterexample_source_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.counterexample_compactDual_eq_cartan",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.current_interface_with_cartan_equalities_does_not_force_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.current_interface_with_cartan_equalities_does_not_force_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.R609CarrierEqualityObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609CarrierEqualityObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609CarrierEqualityObstructionSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609ObstructionTargetNames",
        "HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609ObstructionTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.EVIIH8ResidualProofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.proofWorkContract_of_equalityScalarTargets",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.equalityScalarTargets_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.residual_equalityScalarTargets_nonempty_iff_proofWorkContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.cartanContainmentResidual_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.matsushimaV56BoundaryData_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.residual_proofWorkContract_nonempty_iff_cartanRankOne_nonempty",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.current_interface_with_cartan_equalities_does_not_force_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractTargetNames",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.R610ProofWorkContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.EVIIH8ResidualSourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.source_invariants_eq_H8_of_compactDualCartan",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.source_eq_invariants_of_sourceCartan_compactDualCartan",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.sourceInvariantScalarContract_of_proofWorkContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.proofWorkContract_of_sourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.residual_proofWorkContract_nonempty_iff_sourceInvariantScalarContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.matsushimaV56BoundaryData_of_sourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractTargetNames",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.R634SourceInvariantScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.EVIIH8ResidualSourceInvariantExactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantExactImage_of_source_eq_invariants",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.source_eq_invariants_of_sourceInvariantExactImage",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.source_eq_invariants_iff_sourceInvariantExactImage",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.exactImageScalarContract_of_sourceInvariantScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantScalarContract_of_exactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.residual_sourceInvariantScalarContract_nonempty_iff_exactImageScalarContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.matsushimaV56BoundaryData_of_sourceInvariantExactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractTargetNames",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.R635ExactImageScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractSnapshot",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.EVIIH8ResidualExactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.compactDual_eq_H8_of_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.exactImageContainmentContract_of_exactImageScalarContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.exactImageScalarContract_of_exactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.residual_exactImageScalar_nonempty_iff_exactImageContainment_nonempty",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.matsushimaV56BoundaryData_of_exactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentTargetNames",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.R636ExactImageContainmentSnapshot",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentSnapshot",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.counterexample_sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.counterexample_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.current_interface_with_exactImage_sourceH8_does_not_force_target_containment",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.current_interface_with_exactImage_sourceH8_does_not_force_R636_contract",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.R637ExactImageContainmentObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.currentR637ExactImageContainmentObstructionSnapshot",
        "HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.currentR637ExactImageContainmentObstructionSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSurjectivityTarget",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturatesTargetInvariants",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_targetInvariantSurjectivity",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImage_eq_targetInvariants_of_saturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_of_sourceInvariantImage_eq_targetInvariants",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_image_eq_targetInvariants",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.EVIIH8ResidualTargetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSaturationContract_of_exactImageContainmentContract",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.exactImageContainmentContract_of_targetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.residual_exactImageContainment_nonempty_iff_targetInvariantSaturation_nonempty",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.exactImageContainmentContract_of_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.counterexample_not_targetInvariantSurjectivity",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.counterexample_not_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationTargetNames",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.R638TargetInvariantSaturationSnapshot",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationSnapshot",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImage_finrank_eq_sourceInvariants",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImage_eq_targetInvariants_of_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImageSaturation_of_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantFinrank_of_sourceInvariantImage_eq_targetInvariants",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantFinrank_of_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImageSaturation_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.EVIIH8ResidualTargetInvariantRankContract",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantSaturationContract_of_targetInvariantRankContract",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantRankContract_of_targetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.residual_targetInvariantSaturation_nonempty_iff_targetInvariantRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.exactImageContainmentContract_of_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.counterexample_not_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankTargetNames",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.R639TargetInvariantRankSnapshot",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankSnapshot",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.targetInvariantFinrank_of_sourceH8_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.target_expected_betti8_of_sourceH8_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.sourceInvariantExpectedBettiResidual_of_targetInvariantRankContract",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.targetInvariantRankContract_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.residual_targetInvariantRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.exactImageContainmentContract_of_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantExpectedBettiResidual",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationTargetNames",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.R640RankReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationSnapshot",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.map_mkQ_eq_bot_iff_le",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.sourceInvariantImage",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSurjectivity",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_surjectivity_target",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.EVIIH8ResidualTargetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.exactImageContainmentContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotientContract_of_targetInvariantSaturationContract",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantRank_nonempty",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.counterexample_not_targetInvariantExcessQuotient_eq_bot",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientTargetNames",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.R641TargetInvariantExcessQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_map_eq_sourceInvariantImage",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_sourceInvariantImageSaturation",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap_range",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap_ker",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_finrank_add_sourceInvariantImageInsideTarget_finrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_eq_bot_iff_internalFinrank",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.counterexample_not_sourceInvariantImageInsideTarget_eq_top",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageInsideTarget",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientTargetNames",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.R642TargetInvariantInternalQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_finrank_add_sourceInvariants_finrank",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessFinrank_zero_iff_targetInvariantFinrank",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_finrank_add_expected_betti8_of_sourceH8",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessFinrank_zero_iff_target_expected_betti8",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.current_interface_with_exactImage_sourceH8_finiteTarget_does_not_force_excessFinrankZero",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankTargetNames",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.R643TargetInvariantExcessFinrankSnapshot",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankSnapshot",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessFinrank_zero_of_sourceH8_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetExpectedBettiUpperBound_of_targetInvariantExcessFinrank_zero",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessFinrank_zero_iff_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.EVIIH8ResidualTargetInvariantUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessQuotientContract_of_targetInvariantUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.residual_targetInvariantUpperBound_nonempty_iff_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.current_interface_with_exactImage_sourceH8_does_not_force_targetExpectedBettiUpperBound",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundTargetNames",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.R644TargetInvariantUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantExcessFinrank_zero_iff_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.EVIIH8ResidualTrivialModuleUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantUpperBoundContract_of_trivialModuleUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.trivialModuleUpperBoundContract_of_targetInvariantUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.residual_trivialModuleUpperBound_nonempty_iff_targetInvariantUpperBound_nonempty",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundTargetNames",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.R645TrivialModuleUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.atlasDeg8Classification_at_degree8",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.atlasDeg8Classification_and_currentInterface_do_not_force_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_le_cartanImage",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_le_sourceInvariantImage",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_exactImage_sourceH8_targetContainment",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.EVIIH8ResidualCartanImageUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModuleUpperBoundContract_of_cartanImageUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionTargetNames",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.R646AtlasMultiplicityCriterionSnapshot",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionSnapshot",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.trivialModulePart_le_cartanImage_iff_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.trivialModulePart_upper_bound_of_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.EVIIH8ResidualCartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.cartanImageUpperBoundContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.cartanScalarUpperBoundContract_of_cartanImageUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.residual_cartanScalar_nonempty_iff_cartanImage_nonempty",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.current_interface_with_atlas_does_not_force_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarTargetNames",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.R647CartanScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.sourceInvariantImageSaturation_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.targetInvariantExcessQuotientContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.cartanScalarUpperBoundContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.residual_cartanScalar_nonempty_iff_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_quotient_or_cartan_scalar",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientTargetNames",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.R648ScalarQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientSnapshot",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.trivialModulePart_upper_bound_of_sourceH8_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetExpectedBettiUpperBound_of_sourceH8_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.trivialModuleUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetInvariantExcessQuotient_nonempty_to_targetInvariantUpperBound_nonempty_noFinite",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundTargetNames",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.R649NoFiniteQuotientUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundSnapshot",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantSourcePreimageTarget",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.sourceInvariantImageSaturation_iff_targetInvariantSourcePreimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.EVIIH8ResidualTargetInvariantPreimageContract",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantPreimageContract_of_targetInvariantExcessQuotientContract",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantExcessQuotientContract_of_targetInvariantPreimageContract",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantPreimage_nonempty",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantSourcePreimage_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantPreimage",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageTargetNames",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.R650TargetInvariantPreimageSnapshot",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageSnapshot",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap_range_eq_sourceInvariantImageInsideTarget",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_range_eq_top",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.EVIIH8ResidualInvariantMapSurjectivityContract",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.invariantMapSurjectivityContract_of_targetInvariantPreimageContract",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.targetInvariantPreimageContract_of_invariantMapSurjectivityContract",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.residual_targetInvariantPreimage_nonempty_iff_invariantMapSurjectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.residual_targetInvariantExcessQuotient_nonempty_iff_invariantMapSurjectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.current_interface_with_exactImage_sourceH8_does_not_force_invariantMapSurjectivity",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivityTargetNames",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.R651InvariantMapSurjectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivitySnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivityTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.sourceToTargetInvariantMap_injective",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.sourceToTargetInvariantMap_surjective_iff_range_eq_top",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_surjective",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.EVIIH8ResidualInvariantMapBijectivityContract",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.invariantMapBijectivityContract_of_invariantMapSurjectivityContract",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.invariantMapSurjectivityContract_of_invariantMapBijectivityContract",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.residual_invariantMapSurjectivity_nonempty_iff_invariantMapBijectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.current_interface_with_exactImage_sourceH8_does_not_force_invariantMapBijectivity",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivityTargetNames",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.R652InvariantMapBijectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivitySnapshot",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivitySnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivityTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.sourceToTargetInvariantMap_range_eq_top_of_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.targetInvariantExcessQuotient_eq_bot_of_sourceToTargetInvariantMap_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.sourceToTargetInvariantMap_bijective_of_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.EVIIH8ResidualInvariantMapRightInverseContract",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.invariantMapBijectivityContract_of_invariantMapRightInverseContract",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.residual_invariantMapRightInverse_nonempty_to_invariantMapBijectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.current_interface_does_not_force_rightInverseContract_nonempty",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseTargetNames",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.R653InvariantMapRightInverseSnapshot",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseSnapshot",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantLinearEquivOfBijective",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantMapRightInverseOfBijective",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantMap_comp_rightInverseOfBijective",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_linearRightInverse",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.invariantMapRightInverseContract_of_invariantMapBijectivityContract",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.residual_invariantMapBijectivity_nonempty_to_invariantMapRightInverse_nonempty",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.residual_invariantMapRightInverse_nonempty_iff_invariantMapBijectivity_nonempty",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_equivTarget",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceTargetNames",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.R654RightInverseEquivalenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.sourceToTargetInvariantMap_linearRightInverse_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.cartanScalarUpperBoundContract_of_invariantMapRightInverseContract",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.invariantMapRightInverseContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.residual_invariantMapRightInverse_nonempty_iff_cartanScalar_nonempty",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.sourceToTargetInvariantMap_bijective_iff_cartan_scalar_preimage",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_or_scalar",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarTargetNames",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.R655RightInverseScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarSnapshot",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.matsushima_h_pow_four_image_ne_zero",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.matsushima_h_pow_four_mem_cartan_image",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_image_eq_span_matsushima_h_pow_four",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_image_contains_nonzero_generator",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.sourceToTargetInvariantMap_bijective_iff_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.EVIIH8ResidualCartanLineContainmentContract",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartanScalarUpperBoundContract_of_cartanLineContainmentContract",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartanLineContainmentContract_of_cartanScalarUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.residual_cartanLine_nonempty_iff_cartanScalar_nonempty",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.current_interface_with_exactImage_sourceH8_does_not_force_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.R656CartanGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.matsushima_h_pow_four_mem_trivialModulePart_of_sourceH8",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.cartan_scalar_preimage_of_sourceH8_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.sourceToTargetInvariantMap_bijective_of_sourceH8_trivialModulePartUpperBound",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.cartanLineContainmentContract_of_trivialModuleUpperBoundContract",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.residual_trivialModuleUpperBound_nonempty_to_cartanLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicityTargetNames",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.R657LineContainmentFromMultiplicitySnapshot",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicitySnapshot",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicitySnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicityTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.sourceToTargetInvariantMap_bijective_of_targetInvariantExcessQuotient",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.cartanLineContainmentContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.targetInvariantExcessQuotientContract_of_cartanLineContainmentContract",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.residual_targetInvariantExcessQuotient_nonempty_iff_cartanLine_nonempty_noFinite",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.invariantMapBijectivityContract_of_targetInvariantExcessQuotientContract_noFinite",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.R658QuotientLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.source_invariants_eq_H8_of_h_pow_four_mem_source_and_line",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.EVIIH8ResidualGeneratorMembershipLineContract",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.cartanLineContainmentContract_of_generatorMembershipLineContract",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.targetInvariantExcessQuotientContract_of_generatorMembershipLineContract",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.residual_generatorMembershipLine_nonempty_to_cartanLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.residual_generatorMembershipLine_nonempty_to_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.R659SourceNoExtraFromLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.source_invariants_eq_H8_of_h_pow_four_mem_compactDual_and_line",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.EVIIH8ResidualCompactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.generatorMembershipLineContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.cartanLineContainmentContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.targetInvariantExcessQuotientContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.residual_compactDualGeneratorLine_nonempty_to_targetInvariantExcessQuotient_nonempty",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.R660CompactDualGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.EVIIH8ResidualCartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.compactDualGeneratorLineContract_of_cartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.cartanToCompactDualLineContract_of_compactDualGeneratorLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.residual_compactDualGeneratorLine_nonempty_iff_cartanToCompactDualLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.targetInvariantExcessQuotientContract_of_cartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.source_invariants_eq_H8_of_cartanH8_le_compactDual_and_line",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.R661CartanToCompactDualLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineTargetNames_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_cartanH8_le_compactDual",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_trivialModulePart_le_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_not_sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.current_interface_with_cartanContainment_line_does_not_force_exactImage",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.R662ExactImageIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.currentR662ExactImageIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.currentR662ExactImageIndependenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.counterexample_cartanH8_le_compactDual",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.current_interface_with_exactImage_cartanContainment_does_not_force_target_line",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.R663TargetLineIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.currentR663TargetLineIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.currentR663TargetLineIndependenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.R663_substantiveTheoremCount_eq",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_sourceInvariantExactImageTarget",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_trivialModulePart_le_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_not_cartanH8_le_compactDual",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.current_interface_with_exactImage_line_does_not_force_cartanContainment",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.R664CartanContainmentIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.currentR664CartanContainmentIndependenceSnapshot",
        "HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.currentR664CartanContainmentIndependenceSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.EVIIH8ResidualTargetInvariantLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.targetInvariantLineContract_of_cartanToCompactDualLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.cartanToCompactDualLineContract_of_targetInvariantLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.residual_cartanToCompactDualLine_nonempty_iff_targetInvariantLine_nonempty",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.targetInvariantExcessQuotientContract_of_targetInvariantLineContract",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.source_invariants_eq_H8_of_cartanH8_le_compactDual_and_targetInvariantLine",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineTargetNames",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.R665TargetInvariantLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineSnapshot",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineSnapshot_eq_texStatus",
        "HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineTargetNames_eq_texStatus"
      ]
      gapIds := ["G-hcgap-l4-multifront"]
      dependsOn := ["main-hc-axiom-relative"]
      attackPlan := [
        "FrontC: R560/R567/R569 block abstract-interface closure of the compact-dual/Cartan/scalar-surjectivity targets.  R570 proves compactDual = Cartan plus `finrank trivialModulePart = 1` forces exact Cartan image.  R571 rewrites that into primitive EVII Matsushima targets already named by the interfaces: prove `surjectivity_source = MatsushimaData.source_invariants`, prove `MatsushimaData.source_invariants = CompactDualData.H8`, and prove `finrank MatsushimaData.target_invariants = 1`.  R572 routes the last target through the already-certified expected Betti slot, so the concrete target is `finrank MatsushimaData.target_invariants = shimuraEVIIExpectedBetti 8`.  R573 splits the source-invariants/H8 target into `source_invariants <= H8` plus `h^4` membership; R574 rewrites those through compactDual; R575 rewrites the carrier side again as `compactDual <= CartanH8` and `CartanH8 <= compactDual`; R576 rewrites source equality as `surjectivity_source <= CartanH8` and `CartanH8 <= surjectivity_source`; R577 blocks deriving target expected-Betti from those four containments alone; R578 routes target expected-Betti through `finrank target_invariants = hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8`; R579 derives that target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from the compactDual/Cartan containment pair plus scalar preimages; R581 proves scalar-preimage and target Hodge-sum rank are equivalent once the four carrier directions are fixed; R582 rewrites those four Cartan directions as source/compactDual H8 no-extra plus `h^4` generator-membership splits; R583 collapses each split to `surjectivity_source = H8` and `compactDual = H8`; R584 translates the target-side theorem to the exact boundary equality `surjectivity_target = trivialModulePart`; R585 proves this is equivalent to `MatsushimaV56BoundaryData` once `source = H8` and `compactDual = H8` are fixed; R586 blocks deriving that boundary data from the two H8 carrier equalities alone; R587 shows the remaining target boundary is exactly `trivialModulePart <= surjectivity_target` because the opposite containment follows from the H8 source/compactDual equalities, and the R586 countermodel still refutes deriving this reverse containment abstractly; R588 rewrites that reverse containment as the scalar-preimage theorem `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta`, requiring only `source = H8`; R589 rewrites scalar-preimage/boundary data/target Hodge-sum again as the rank-one theorem `finrank trivialModulePart = 1` under the two H8 carrier equalities.  R590 proves this rank-one target is equivalent to `finrank target_invariants = shimuraEVIIExpectedBetti 8` and that H8 carriers still do not force it.  R591 packages the live concrete target as `EVIIH8ResidualRankOneObligations`: two H8 carrier equalities plus `finrank target_invariants = 1`.  R592 proves that package is equivalent to `EVIIH8ResidualScalarPreimageObligations`, replacing the target-rank item by the scalar-preimage theorem `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta`.  R593 packages the same residual target as `EVIIH8ResidualBoundaryObligations`, whose third item is the target-boundary equality `surjectivity_target = trivialModulePart`.  R594 packages it again as `EVIIH8ResidualBoundaryDataObligations`, replacing source equality plus target boundary by the existing `MatsushimaV56BoundaryData` bridge once `compactDual = H8` is supplied.  R595 rewrites the bridge as `EVIIH8ResidualExactImageObligations`, replacing boundary data by compact-dual exact image plus target-invariant exactness.  R596 replaces target-invariant exactness by `finrank trivialModulePart = 1` once compact-dual exact image is fixed.  R597 rewrites that live target as Cartan-line carrier equalities `surjectivity_source = CartanH8` and `compactDual = CartanH8` plus `finrank trivialModulePart = 1`.  R598 removes Cartan notation from the package, leaving exactly the primitive Matsushima targets `surjectivity_source = source_invariants`, `source_invariants = H8`, and `finrank target_invariants = 1`; the live gap is still to prove these three from genuine EVII/Matsushima geometry.  R599 normalizes this R598 package against the earlier R591 H8/rank-one package, proving the two inhabited residual targets equivalent and showing that `source_invariants = H8` alone still does not force the full residual; this keeps the paper ledger from treating the R591 and R598 spellings as separate gaps.  R600 normalizes the same package against the expected-Betti-8 target rank used in the paper-facing FrontC route, proving that the `finrank target_invariants = 1` and `finrank target_invariants = shimuraEVIIExpectedBetti 8` spellings are the same residual target.  R601 reopens the `source_invariants = H8` item as the equivalent source-carrier split `source_invariants <= H8` plus `h^4` membership, so the paper-facing residual can now be audited at that finer granularity.  R602 transfers that split to the compact-dual carrier package `compactDual <= H8` plus `h^4 in compactDual`, keeping the same source equality and target expected-Betti rank.  R603 repackages that same residual as the four Cartan containments plus target expected-Betti, so the next direct geometry target is the four Cartan carrier directions together with the independent target rank theorem, not a closure claim.  Feed R553/R554/R555/R556/R557/R558/R559/R561/R562/R563/R564/R565/R566/R568/R570/R571/R572/R573/R574/R575/R576/R577/R578/R579/R580/R581/R582/R583/R584/R585/R586/R587/R588/R589/R590/R591/R592/R593/R594/R595/R596/R597/R598/R599/R600/R601/R602/R603 together.",
        "R604 status: the R603 residual now has a kernel-checked primitive split into four carrier-direction obligations and one independent target expected-Betti obligation; this makes the paper-facing count five primitive targets, not a closure claim.",
        "R605 status: the fifth primitive target can be attacked as scalar-preimage surjectivity under the same four carrier directions; do not count expected-Betti rank and scalar preimage as separate gaps.",
        "R606 status: the five paper-facing primitive targets are now a flattened Lean ledger with named target declarations; use it for paper summaries of the live residual target list.",
        "R607 status: the five primitive targets are equivalent to three proof-work targets: two Cartan-line equalities plus scalar-preimage surjectivity; this is still not a closure claim.",
        "R608 status: the scalar-preimage proof-work target is equivalent to the older `finrank trivialModulePart = 1` rank-one target under the two Cartan-line equalities; do not count scalar-preimage and rank-one as separate gaps.",
        "R609 status: the two Cartan-line equality targets alone do not force the scalar/rank-one target in the current abstract interface; all three proof-work targets remain live obligations.",
        "R610 status: the live proof-work frontier is now a kernel-checked contract with exactly three obligations: two Cartan-line equalities and one scalar/rank-one target; the contract is equivalent to R607/R608 and is not a full-HC closure claim.",
        "R634 status: the same R610 contract now has a source-invariant spelling with exactly three obligations: `surjectivity_source = source_invariants`, `source_invariants = H8`, and scalar/rank-one target.  This equivalence does not require the finite-dimensional rank conversion and is not a full-HC closure claim.",
        "R635 status: the first R634 source equality is equivalent to the exact-image equation `Submodule.map j_q source_invariants = surjectivity_target`, using only `MatsushimaSurjectivityData.surjectivity_eq` and `j_q` injectivity.  The live proof work is now exact image, source-invariants/H8, and scalar/rank-one target; this is still not a full-HC closure claim.",
        "R636 status: the R635 scalar/rank-one target is equivalent to the reverse target containment `trivialModulePart <= surjectivity_target` once exact image and `source_invariants = H8` are fixed; the live proof work is now exact image, source-invariants/H8, and target containment, still not a full-HC closure claim.",
        "R637 status: the existing countermodel already satisfies the R636 exact-image carrier side and `source_invariants = H8`, while still failing `trivialModulePart <= surjectivity_target`; the target containment must be proved from genuine EVII/Matsushima target geometry, not from the carrier interface alone.",
        "R638 status: using the already-closed R554 identification `target_invariants = trivialModulePart`, the R636 containment target is now exactly target-invariant image saturation.  Under the R636 exact-image carrier the next concrete target is `Submodule.map j_q source_invariants = target_invariants`, and R638 proves the same countermodel still blocks deriving this equality from carriers alone.",
        "R639 status: finite-dimensional target-invariant saturation is equivalent to the rank equality `finrank source_invariants = finrank target_invariants`; this is now the next concrete target-side EVII computation, and the same countermodel shows the R636 carriers do not force it.",
        "R640 status: the R639 rank criterion is not a new independent gap.  Under `source_invariants = H8`, it is equivalent to the existing R600 target expected-Betti theorem `finrank target_invariants = shimuraEVIIExpectedBetti 8`; exact image is the R635 spelling of `surjectivity_source = source_invariants`.",
        "R641 status: the target-side theorem can now be attacked as quotient vanishing: prove the image of `target_invariants` in the quotient by `Submodule.map j_q source_invariants` is `bot`.  This is equivalent to R638 saturation, and under `source_invariants = H8` equivalent to the R600/R640 expected-Betti target; the carrier countermodel still shows it is genuine target geometry.",
        "R642 status: the R641 quotient map has a concrete source inside `target_invariants`: its kernel is `sourceInvariantImageInsideTarget`, its range is `targetInvariantExcessQuotient`, and rank-nullity reduces quotient vanishing to codimension zero of that internal source-image subspace.  This is a geometry computation target, not a closure claim.",
        "R643 status: the same target is now the numerical theorem `finrank targetInvariantExcessQuotient = 0`; R643 proves the rank formula `finrank excess + finrank source_invariants = finrank target_invariants` and, under `source_invariants = H8`, equivalence with the expected-Betti target.  The next attack should compute this excess dimension, not introduce a new assumption.",
        "R644 status: with `source_invariants = H8`, zero excess is equivalent to the one-sided upper bound `finrank target_invariants <= shimuraEVIIExpectedBetti 8`.  The next attack should rule out extra target-invariant classes via actual EVII/Matsushima cohomology, not assume the full target-rank equality.",
        "R645 status: using the existing R554 equality `target_invariants = trivialModulePart`, the R644 upper bound is exactly `finrank trivialModulePart <= 1`.  The next attack should prove this automorphic trivial-module multiplicity upper bound in degree 8.",
        "R646 status: the finite Atlas table proves the degree-8 label classification, but the current interface still does not bound the multiplicity of the trivial label.  A sufficient next target is now `trivialModulePart <= Submodule.map j_q trivialModuleGK_H8`, since R565 proves that Cartan image is one-dimensional and hence gives `finrank trivialModulePart <= 1`.",
        "R647 status: the R646 Cartan-image containment is exactly the element-level scalar-preimage theorem `forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta`.  Exact image, source-H8, and the Atlas label table still do not force this scalar-preimage target in the current abstract interface.",
        "R648 status: under `source_invariants = H8`, the R647 Cartan scalar-preimage target is equivalent to the R641 quotient-vanishing target `targetInvariantExcessQuotient = bot`.  Treat quotient vanishing, target-invariant saturation, expected-Betti rank, and scalar preimages as one target-side gap, not separate proof obligations.",
        "R649 status: once `source_invariants = H8` is available, `targetInvariantExcessQuotient = bot` feeds both `finrank trivialModulePart <= 1` and the R644 expected-Betti upper-bound contract without assuming `FiniteDimensional target_invariants`; the reverse upper-bound-to-quotient direction still belongs to the finite-dimensional rank formula.",
        "R650 status: quotient vanishing is exactly the element-level theorem that every `beta` in `target_invariants` has an `alpha` in `source_invariants` with `j_q alpha = beta`; under `source_invariants = H8` this specializes to the R647 Cartan scalar-preimage target.  The carrier countermodel still blocks deriving this from exact image plus source-H8 alone, so the next attack is genuine Matsushima target-surjectivity geometry.",
        "R651 status: the R650 preimage target is exactly `LinearMap.range (sourceToTargetInvariantMap) = top`, where `sourceToTargetInvariantMap : source_invariants -> target_invariants` is built from the existing Matsushima `j_q` and invariant-preservation field.  Its range is the R642 internal source-image subspace, so quotient vanishing is now a restricted invariant-map surjectivity theorem.",
        "R652 status: `sourceToTargetInvariantMap` is injective by the existing `MatsushimaData.j_q_injective`; hence quotient vanishing is exactly `Function.Bijective sourceToTargetInvariantMap`.  The remaining target work is to prove the onto half, or equivalently construct the inverse on target invariants.",
        "R653 status: a linear right inverse `target_invariants -> source_invariants` is now a kernel-checked sufficient construction target for the R652 bijectivity and R641 quotient-vanishing gap.  The current exact-image plus source-H8 carrier interface still does not force such a right inverse, so this is a genuine construction target, not an assumed closure.",
        "R654 status: the R653 right-inverse construction target is equivalent to R652 bijectivity and R641 quotient vanishing by `LinearEquiv.ofBijective`.  A new agent can attack either the onto half of `sourceToTargetInvariantMap` or a linear right inverse; they are the same target, not separate gaps.",
        "R655 status: under the already-isolated `source_invariants = H8` carrier target, the right-inverse/bijectivity target is equivalent to the Cartan scalar-preimage theorem for `trivialModulePart`.  The next mathematical attack is therefore the EVII/Matsushima scalar-preimage theorem, not another interface split.",
        "R656 status: the Cartan H8 image is now kernel-identified with the explicit non-zero generator line `span {j_q(h^4)}`.  Under `source_invariants = H8`, the R655 bijectivity/right-inverse/scalar-preimage target is equivalently the concrete containment `trivialModulePart <= span {j_q(h^4)}`.  The current exact-image plus source-H8 interface still does not force that containment, so the next attack is the genuine EVII/Matsushima target-line containment theorem.",
        "R657 status: under `source_invariants = H8`, `j_q(h^4)` is now kernel-proved to lie in `trivialModulePart`; with finite-dimensional `trivialModulePart`, the R645 multiplicity upper bound `finrank trivialModulePart <= 1` forces R656 line containment, scalar preimages, and restricted invariant-map bijectivity.  This does not prove the multiplicity upper bound; it makes that upper bound the precise remaining target-side theorem.",
        "R658 status: the R641 quotient target is now kernel-composed directly with the R656 generator-line target: under `source_invariants = H8`, `targetInvariantExcessQuotient = bot` is equivalent to `trivialModulePart <= span {j_q(h^4)}` and also feeds restricted invariant-map bijectivity without any finite-dimensional rank consumer.  The remaining target-side theorem is quotient vanishing / generator-line containment itself.",
        "R659 status: the target generator-line theorem now also forces the no-extra-source half `source_invariants <= H8`, because source invariants map into `target_invariants = trivialModulePart` and `j_q` is injective.  Therefore `source_invariants = H8` can be recovered from only `h^4 ∈ source_invariants` plus the same target line-containment theorem; do not keep `source_invariants <= H8` as an independent gap after line containment is available.",
        "R660 status: the remaining R659 source generator membership has been transferred to the compact-dual carrier via the existing `compactDual = source_invariants` comparison.  The live source-side target is now `h^4 ∈ compactDual`, plus exact image and the target generator-line/quotient theorem; this is a bridge, not a proof of compact-dual generator membership.",
        "R661 status: `h^4 ∈ compactDual` is equivalent to the one-sided Cartan carrier containment `CartanH8 <= compactDual`.  The current live contract should therefore be read as exact image, Cartan-to-compactDual containment, and target generator-line/quotient containment; the membership spelling is not a separate source-side gap.",
        "R662 status: exact image is not forced by the other two current live targets.  A one-dimensional countermodel satisfies `CartanH8 <= compactDual` and `trivialModulePart <= span {j_q(h^4)}` while `Submodule.map j_q source_invariants = surjectivity_target` fails, so exact image/source equality remains an independent Matsushima source-geometry target.",
        "R663 status: the target generator-line theorem is likewise not forced by exact image plus `CartanH8 <= compactDual`.  The R656 countermodel already has exact image and the current source carrier direction while failing `trivialModulePart <= span {j_q(h^4)}`, so target line/quotient vanishing remains an independent target-side theorem.",
        "R664 status: the Cartan-to-compactDual containment is also not forced by exact image plus the target generator-line theorem.  A one-dimensional countermodel has `source_invariants = compactDual = bot`, exact image, and vacuous target line, while nonzero `CartanH8 = span {h^4}` fails to lie in compactDual; the source-side carrier remains an independent compact-dual/Cartan geometry target.",
        "R665 status: the target generator-line theorem is equivalently `target_invariants <= span {j_q(h^4)}` by the existing R554 equality `target_invariants = trivialModulePart`.  The current live target names are exact image, `CartanH8 <= compactDual`, and target-invariant line containment; this is a bridge toward Matsushima target-invariant geometry, not a proof of the line theorem.",
        "FrontB: replace the abstract connectedness pipeline with the genuine Baily--Borel connectedness theorem for arithmetic quotients.",
        "FrontD: deliver the E_7 -> CM Chow correspondence at codim 1 first, then lift to all p; this would discharge G-l4-mt-correspondence for the canonical case.",
        "Never re-bundle a closed front into a stronger hypothesis; chainAudit treats `def : Prop` placeholders and conjunction shells as hard failures."
      ]
      successCriterion :=
        "A successful follow-up closes one live H8 residual target without adding assumptions: prove exact image, prove `CartanH8 <= compactDual` (equivalently `h^4 ∈ compactDual`), or prove `targetInvariantExcessQuotient = bot` / `target_invariants <= span {j_q(h^4)}`."
    },
    {
      id := "concrete-evii-toy"
      title := "Concrete EVII sanity-check chain"
      kind := "support"
      status := "closed-toy"
      summary :=
        "`HC_for_Concrete_EVII` specialises the abstract closure `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` to a concrete `A_EVII := Polynomial 鈩歚 toy carrier.  Cone is `{propext, Classical.choice, Quot.sound}` (no project axioms) but the carrier is explicitly toy; per R201 mandate it is EXCLUDED from real-HC closure accounting."
      files := [
        "HodgeReduction/Concrete.lean"
      ]
      entryDecls := []
      gapIds := []
      dependsOn := ["main-hc-axiom-relative"]
    },
    {
      id := "historical-cone-audits"
      title := "Historical per-round cone audit drivers (R217 -- R476)"
      kind := "infra"
      status := "infra"
      summary :=
        "85 per-round `#print axioms` / `#check` driver scripts produced at the end of each attack round.  Each script is a standalone audit consuming a fixed subset of the active chain at its timestamp; none are imported by `HodgeReduction.lean`.  Moved out of the project root into `HodgeReduction/ConeAudits/` and registered as `infraFiles` so the chainAudit classifier records them as infra rather than orphan."
      files := [
        "HodgeReduction/ConeAudits/R217_ConeAudit.lean",
        "HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean",
        "HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean",
        "HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean",
      ]
      entryDecls := []
      gapIds := []
      dependsOn := ["main-hc-axiom-relative"]
    }
  ]
  primaryGapId := some "G-full-hc"
  replacementRouteId := some "main-hc-axiom-relative"
  gapPriority := [
    "G-full-hc",
    "G-master-paper-import",
    "G-main-hc",
    "G-l1-e7-shimura-tor",
    "G-l2-cohomology-construction",
    "G-l3-v56-mt-identification",
    "G-l4-mt-correspondence",
    "G-l4-cm-abelian-hc",
    "G-classical-mathlib-port",
    "G-hcgap-l4-multifront",
    "G-main-hc"
  ]
  routeKeywordRules := [
    {
      labels := ["chain:full-hc-final-target", "gap:G-full-hc"]
      keywords := [
        "FullHodgeConjectureReal", "FullHodgeConjectureRealByCodim",
        "CurrentReductionCoversAllSmoothProjective",
        "fullHodgeConjectureReal", "full Hodge conjecture",
        "complete Hodge conjecture", "all smooth projective",
        "SmoothProjectiveVariety Complex", "HodgeConjectureReal X"
      ]
    },
    {
      labels := ["chain:master-paper-import-ledger", "gap:G-master-paper-import"]
      keywords := [
        "PaperInventory", "masterClaims", "canonicalMasterSource",
        "hodge-conjecture-master-proof.tex", "master-tex",
        "master paper", "canonical source", "archivedBackgroundSources",
        "needsTriageClaims", "unclaimedMasterEnvironments", "openHypothesisClaims"
      ]
    },
    {
      labels := ["chain:main-hc-axiom-relative", "gap:G-main-hc"]
      keywords := [
        "hodgeConjectureReal_canonical", "hodgeConjectureReal_canonical_codim1",
        "main_reduction_real",
        "canonicalTargetVariety", "canonicalTargetE7Factor",
        "canonicalTargetInKnownE7Scope", "canonicalTargetCohomologyData",
        "canonicalTargetAlgClassesData", "canonicalMTPackageAt",
        "canonicalMTPackageAt_codim1", "canonicalMTPackageAt_non_codim1",
        "canonicalHCDataByCodim", "canonicalE7ShimuraTor",
        "E7ShimuraTor", "VarietyHC", "mtCorrespondenceAt",
        "mtCorrespondencePackage", "CanonicalHCData", "CanonicalHCDataByCodim",
        "hodgeConjectureReal_from_canonicalHCDataByCodim",
        "lefschetz_11_hc_real_at_codim1",
        "lefschetz_11_hc_real_at_codim1_cm"
      ]
    },
    {
      labels := ["chain:main-hc-axiom-relative", "gap:G-l1-e7-shimura-tor"]
      keywords := [
        "ToroidalCompactification", "BailyBorel", "AMRT",
        "HermitianSymmetric", "ArithmeticGroup", "ShimuraToyCarrier",
        "ShimuraTor", "E7ShimuraTor"
      ]
    },
    {
      labels := ["chain:main-hc-axiom-relative", "gap:G-l2-cohomology-construction",
                 "chain:hcgap-l2-trivial-instances"]
      keywords := [
        "VarietyCohomologyData", "VarietyCohomology", "SheafCohomology",
        "BettiCohomology", "ComparisonTheorem", "PoincareDuality",
        "DeRham", "Lefschetz", "HodgeDecomposition", "HodgeStructure",
        "HCGapL2", "TrivialPoint", "ProjectiveLine", "EllipticCurve"
      ]
    },
    {
      labels := ["chain:main-hc-axiom-relative", "gap:G-l3-v56-mt-identification"]
      keywords := [
        "V56", "V_56", "VoganZuckerman", "BorelHirzebruch", "Matsushima",
        "GKCohomology", "FrankeEisensteinLayer", "Freudenthal",
        "JordanJ3O", "OctonionBasis", "PoincarePolynomialEVII"
      ]
    },
    {
      labels := ["chain:main-hc-axiom-relative", "gap:G-l4-cm-abelian-hc"]
      keywords := [
        "CMAbelian", "IsCMAbelianVariety", "CMType", "KugaSatake",
        "K3Surface", "HyperKahler", "TateModule", "hyp_HC_CM_Ab",
        "deligne_absolute_hodge_abelian", "absHodgeWitness",
        "absHodgeClassesAtDegreeCM", "abs_hodge_cm_implies_algebraic",
        "PolarisedAV", "GaussianCM", "imaginaryQuadratic"
      ]
    },
    {
      labels := ["chain:main-hc-axiom-relative", "gap:G-l4-mt-correspondence"]
      keywords := [
        "mtCorrespondencePackage", "MTCorrespondencePackageAt",
        "e7_chosen_witness_hsm_codim1", "e7_chosen_witness_alg_map_codim1",
        "e7_chosen_witness_square_codim1", "e7_chosen_witness_hodge_surj_codim1",
        "MumfordTate", "varietyHCAt_of_correspondence",
        "ShiftedMTCorrespondence", "CycleClassPresentation",
        "CycleInducedCorrespondence", "MTCorrespondenceMathlibAudit"
      ]
    },
    {
      labels := ["chain:unconditional-classical", "gap:G-classical-mathlib-port"]
      keywords := [
        "Meyer", "kostant_vacuity", "SV1_vacuity", "cy3_e7_nonexistence",
        "e6_classical_remainder_exists", "e6_remainder_transfer",
        "e6_factor_classical_transfer",
        "cy3_e7_springer_stage", "cy3_e7_fts_omega_stage",
        "cy3_e7_j3o_nonrealization_stage",
        "cy3_inherits_e7_factor", "cy3_mtd_isSemisimple", "cy3_e7_excludes_e6",
        "subcase3b_vacuous", "Hasse", "Minkowski", "Bourbaki",
        "RationalQuadraticForm", "G2_realForm", "F4_realForm", "E8_realForm"
      ]
    },
    {
      labels := ["chain:hcgap-l4-multifront-active", "gap:G-hcgap-l4-multifront"]
      keywords := [
        "HCGapL4", "FrontA", "FrontB", "FrontC", "FrontD", "FrontE",
        "MultiFrontWave", "MultiFrontFrontier", "HodgePolynomial",
        "ProfileMatching", "BailyBorelConnectedness",
        "DeligneH0SheafRealization", "E7ToCMChowCorrespondence",
        "RealCarrierProfileMatching", "HCFrontierAfter",
        "ParametricCanonicalE7ShimuraTor", "ToyToReal", "V56InfrastructureProfile",
        "MatsushimaV56Boundary", "CartanCompactDualSource", "MatsushimaBoundaryRankCriterion",
        "MatsushimaTargetContainmentFromSource", "MatsushimaTargetRankFromSource",
        "MatsushimaSourceCompactDualRankBridge",
        "MatsushimaSourceCompactDualObstruction",
        "MatsushimaCompactDualExactImageCriterion",
        "MatsushimaExactImageRankBoundary",
        "MatsushimaExactImageSourceEquivalence",
        "MatsushimaCompactDualRankOne",
        "CartanImageTrivialRank",
        "CartanLineBoundaryExactness",
        "CartanLineExactnessObstruction",
        "CartanImageScalarPreimage",
        "ScalarPreimageObstruction",
        "CartanImageFromRankOne",
        "SourceInvariantsH8TargetRank",
        "TargetRankFromExpectedBetti",
        "SourceInvariantsH8CarrierCriterion",
        "CompactDualH8CarrierCriterion",
        "CartanContainmentsForCompactDual",
        "SourceCartanContainments",
        "TargetBettiObstruction",
        "TargetRankHodgeSumBridge",
        "TargetHodgeSumFromCartanImage",
        "TargetHodgeSumFromScalarPreimage",
        "TargetRankScalarPreimageEquivalence",
        "CartanContainmentCarrierEquivalence",
        "H8CarrierEqualityRoute",
        "H8BoundaryEqualityRoute",
        "BoundaryDataH8Equivalence",
        "H8BoundaryDataObstruction",
        "RealCompatible", "AbstractConnectedH0", "LocallyConstant"
      ]
    },
    {
      labels := ["chain:concrete-evii-toy"]
      keywords := [
        "Concrete", "A_EVII", "HC_for_Concrete_EVII", "FreudenthalQuartic",
        "PolynomialQ"
      ]
    },
    {
      labels := ["chain:historical-cone-audits"]
      keywords := [
        "ConeAudit", "print axioms", "ConeAudits"
      ]
    }
  ]
}

/-- Number of route-level gap records in the current main-chain audit config. -/
def routeLevelGapCount : Nat :=
  config.researchGaps.length

/-- The route-level gap ids registered in the main-chain audit config. -/
def routeGapIds : List String :=
  config.researchGaps.map (fun g => g.id)

/-- Whether a paper-side or endpoint-side gap id resolves to a route-level gap
record. -/
def gapIdIsRouteRegistered (gapId : String) : Bool :=
  routeGapIds.any (fun registeredId => registeredId == gapId)

/-- Count route-level gaps by their audit status string. -/
def routeLevelGapStatusCount (status : String) : Nat :=
  (config.researchGaps.filter (fun g => g.status == status)).length

def routeLevelFinalOpenGapCount : Nat :=
  routeLevelGapStatusCount "final-open"

def routeLevelInProgressGapCount : Nat :=
  routeLevelGapStatusCount "in-progress"

def routeLevelConditionalGapCount : Nat :=
  routeLevelGapStatusCount "conditional"

def routeLevelOpenGapCount : Nat :=
  routeLevelGapStatusCount "open"

def routeLevelDeferredGapCount : Nat :=
  routeLevelGapStatusCount "deferred"

def routeLevelActiveOpenGapCount : Nat :=
  routeLevelGapStatusCount "active-open"

/-- Exact endpoint-level open-cut names configured for the chain audit.  This
is the flat kernel-cut ledger behind the generated route-index headline; it is
separate from the ten route-level research-gap rows. -/
def endpointOpenCutNames : List Lean.Name :=
  config.openAxioms

def endpointOpenCutCount : Nat :=
  endpointOpenCutNames.length

/-- R631 expected endpoint-cut list used by the master paper's Lean-status
summary.  If the configured open-cut ledger changes, the paper summary must
change with it. -/
def expectedEndpointOpenCutNames : List Lean.Name :=
  [``HodgeReduction.canonicalTargetVariety,
   ``HodgeReduction.canonicalTargetE7Factor,
   ``HodgeReduction.canonicalTargetInKnownE7Scope,
   ``HodgeReduction.SmoothProjectiveVariety.cohomology,
   ``HodgeReduction.SmoothProjectiveVariety.algClasses,
   ``HodgeReduction.absHodgeClassesAtDegreeCM,
   ``HodgeReduction.deligne_1982_abs_hodge_cm,
   ``HodgeReduction.abs_hodge_cm_implies_algebraic,
   ``HodgeReduction.lefschetz_11_hc_real_at_codim1,
   ``HodgeReduction.hc_real_classical_cartan,
   ``HodgeReduction.e6_classical_remainder_exists,
   ``HodgeReduction.e6_remainder_transfer,
   ``HodgeReduction.e7_cm_witness_exists,
   ``HodgeReduction.e7_chosen_witness_hsm_codim1,
   ``HodgeReduction.e7_chosen_witness_alg_map_codim1,
   ``HodgeReduction.e7_chosen_witness_square_codim1,
   ``HodgeReduction.e7_chosen_witness_hodge_surj_codim1,
   ``HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists,
   ``HodgeReduction.cy3_e7_springer_stage,
   ``HodgeReduction.cy3_e7_fts_omega_stage,
   ``HodgeReduction.cy3_e7_j3o_nonrealization_stage,
   ``HodgeReduction.cy3_inherits_e7_factor,
   ``HodgeReduction.cy3_mtd_isSemisimple,
   ``HodgeReduction.cy3_e7_excludes_e6]

def expectedEndpointOpenCutCount : Nat :=
  expectedEndpointOpenCutNames.length

def endpointOpenCutLedgerMatchesTexStatus : Bool :=
  endpointOpenCutNames == expectedEndpointOpenCutNames

def endpointOpenCutCountMatchesTexStatus : Bool :=
  endpointOpenCutCount == expectedEndpointOpenCutCount

/-- Machine-audited endpoint-level open-cut snapshot used by the master tex
status prose. -/
structure EndpointOpenCutSnapshot where
  endpointOpenCutCount : Nat
  expectedEndpointOpenCutCount : Nat
  endpointOpenCutNames : List Lean.Name
  endpointOpenCutLedgerMatchesTexStatus : Bool
  endpointOpenCutCountMatchesTexStatus : Bool
  deriving Repr, DecidableEq, Inhabited

def currentEndpointOpenCutSnapshot : EndpointOpenCutSnapshot where
  endpointOpenCutCount := endpointOpenCutCount
  expectedEndpointOpenCutCount := expectedEndpointOpenCutCount
  endpointOpenCutNames := endpointOpenCutNames
  endpointOpenCutLedgerMatchesTexStatus := endpointOpenCutLedgerMatchesTexStatus
  endpointOpenCutCountMatchesTexStatus := endpointOpenCutCountMatchesTexStatus

/-- R632 assignment of a flat endpoint-level open cut to one or more
route-level gap rows.  This is a narrative/audit ledger: it prevents the paper
from citing a 24-cut endpoint count without saying where those cuts sit in the
ten-row route-gap table. -/
structure EndpointOpenCutRouteAssignment where
  cutName : Lean.Name
  routeGapIds : List String
  deriving Repr, DecidableEq, Inhabited

/-- R632 exact endpoint-cut-to-route-gap assignment ledger. -/
def endpointOpenCutRouteAssignments : List EndpointOpenCutRouteAssignment := [
  { cutName := ``HodgeReduction.canonicalTargetVariety
    routeGapIds := ["G-main-hc"] },
  { cutName := ``HodgeReduction.canonicalTargetE7Factor
    routeGapIds := ["G-main-hc", "G-l1-e7-shimura-tor"] },
  { cutName := ``HodgeReduction.canonicalTargetInKnownE7Scope
    routeGapIds := ["G-main-hc", "G-l1-e7-shimura-tor"] },
  { cutName := ``HodgeReduction.SmoothProjectiveVariety.cohomology
    routeGapIds := ["G-l2-cohomology-construction"] },
  { cutName := ``HodgeReduction.SmoothProjectiveVariety.algClasses
    routeGapIds := ["G-full-hc"] },
  { cutName := ``HodgeReduction.absHodgeClassesAtDegreeCM
    routeGapIds := ["G-l4-cm-abelian-hc"] },
  { cutName := ``HodgeReduction.deligne_1982_abs_hodge_cm
    routeGapIds := ["G-l4-cm-abelian-hc"] },
  { cutName := ``HodgeReduction.abs_hodge_cm_implies_algebraic
    routeGapIds := ["G-l4-cm-abelian-hc"] },
  { cutName := ``HodgeReduction.lefschetz_11_hc_real_at_codim1
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.hc_real_classical_cartan
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.e6_classical_remainder_exists
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.e6_remainder_transfer
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.e7_cm_witness_exists
    routeGapIds := ["G-l4-mt-correspondence"] },
  { cutName := ``HodgeReduction.e7_chosen_witness_hsm_codim1
    routeGapIds := ["G-l4-mt-correspondence"] },
  { cutName := ``HodgeReduction.e7_chosen_witness_alg_map_codim1
    routeGapIds := ["G-l4-mt-correspondence"] },
  { cutName := ``HodgeReduction.e7_chosen_witness_square_codim1
    routeGapIds := ["G-l4-mt-correspondence"] },
  { cutName := ``HodgeReduction.e7_chosen_witness_hodge_surj_codim1
    routeGapIds := ["G-l4-mt-correspondence"] },
  { cutName := ``HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists
    routeGapIds := ["G-l4-mt-correspondence"] },
  { cutName := ``HodgeReduction.cy3_e7_springer_stage
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.cy3_e7_fts_omega_stage
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.cy3_e7_j3o_nonrealization_stage
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.cy3_inherits_e7_factor
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.cy3_mtd_isSemisimple
    routeGapIds := ["G-classical-mathlib-port"] },
  { cutName := ``HodgeReduction.cy3_e7_excludes_e6
    routeGapIds := ["G-classical-mathlib-port"] }
]

def endpointOpenCutRouteAssignmentNames : List Lean.Name :=
  endpointOpenCutRouteAssignments.map (fun entry => entry.cutName)

def endpointOpenCutRouteAssignmentCount : Nat :=
  endpointOpenCutRouteAssignments.length

def endpointOpenCutRouteAssignmentsCoverOpenCuts : Bool :=
  endpointOpenCutRouteAssignmentNames == endpointOpenCutNames

def endpointOpenCutRouteAssignmentCountMatchesOpenCuts : Bool :=
  endpointOpenCutRouteAssignmentCount == endpointOpenCutCount

def endpointOpenCutRouteAssignmentsWithoutRouteGap :
    List EndpointOpenCutRouteAssignment :=
  endpointOpenCutRouteAssignments.filter (fun entry => entry.routeGapIds.isEmpty)

def endpointOpenCutRouteAssignmentsWithoutRouteGapCount : Nat :=
  endpointOpenCutRouteAssignmentsWithoutRouteGap.length

def allEndpointOpenCutRouteAssignmentsHaveRouteGap : Bool :=
  endpointOpenCutRouteAssignmentsWithoutRouteGapCount == 0

def endpointOpenCutRouteAssignmentGapIds : List String :=
  endpointOpenCutRouteAssignments.flatMap (fun entry => entry.routeGapIds)

def unregisteredEndpointOpenCutRouteAssignmentGapIds : List String :=
  endpointOpenCutRouteAssignmentGapIds.filter
    (fun gapId => ! gapIdIsRouteRegistered gapId)

def unregisteredEndpointOpenCutRouteAssignmentGapIdCount : Nat :=
  unregisteredEndpointOpenCutRouteAssignmentGapIds.length

def allEndpointOpenCutRouteAssignmentGapIdsRegistered : Bool :=
  unregisteredEndpointOpenCutRouteAssignmentGapIdCount == 0

/-- Machine-audited R632 snapshot for the endpoint-cut-to-route-gap assignment
ledger. -/
structure EndpointOpenCutRouteAssignmentSnapshot where
  endpointOpenCutCount : Nat
  endpointOpenCutRouteAssignmentCount : Nat
  endpointOpenCutRouteAssignmentsCoverOpenCuts : Bool
  endpointOpenCutRouteAssignmentCountMatchesOpenCuts : Bool
  endpointOpenCutRouteAssignmentsWithoutRouteGapCount : Nat
  allEndpointOpenCutRouteAssignmentsHaveRouteGap : Bool
  endpointOpenCutRouteAssignmentGapReferenceCount : Nat
  unregisteredEndpointOpenCutRouteAssignmentGapIdCount : Nat
  allEndpointOpenCutRouteAssignmentGapIdsRegistered : Bool
  deriving Repr, DecidableEq, Inhabited

def currentEndpointOpenCutRouteAssignmentSnapshot :
    EndpointOpenCutRouteAssignmentSnapshot where
  endpointOpenCutCount := endpointOpenCutCount
  endpointOpenCutRouteAssignmentCount := endpointOpenCutRouteAssignmentCount
  endpointOpenCutRouteAssignmentsCoverOpenCuts :=
    endpointOpenCutRouteAssignmentsCoverOpenCuts
  endpointOpenCutRouteAssignmentCountMatchesOpenCuts :=
    endpointOpenCutRouteAssignmentCountMatchesOpenCuts
  endpointOpenCutRouteAssignmentsWithoutRouteGapCount :=
    endpointOpenCutRouteAssignmentsWithoutRouteGapCount
  allEndpointOpenCutRouteAssignmentsHaveRouteGap :=
    allEndpointOpenCutRouteAssignmentsHaveRouteGap
  endpointOpenCutRouteAssignmentGapReferenceCount :=
    endpointOpenCutRouteAssignmentGapIds.length
  unregisteredEndpointOpenCutRouteAssignmentGapIdCount :=
    unregisteredEndpointOpenCutRouteAssignmentGapIdCount
  allEndpointOpenCutRouteAssignmentGapIdsRegistered :=
    allEndpointOpenCutRouteAssignmentGapIdsRegistered

def routeGapHasMasterPaperClaimCoverage (gapId : String) : Bool :=
  ! (HodgeReduction.PaperInventory.masterClaimIdsForGapId gapId).isEmpty

def endpointOpenCutRouteAssignmentHasMasterPaperClaimCoverage
    (entry : EndpointOpenCutRouteAssignment) : Bool :=
  entry.routeGapIds.any routeGapHasMasterPaperClaimCoverage

def endpointOpenCutRouteAssignmentsWithMasterPaperClaimCoverage :
    List EndpointOpenCutRouteAssignment :=
  endpointOpenCutRouteAssignments.filter
    endpointOpenCutRouteAssignmentHasMasterPaperClaimCoverage

def endpointOpenCutRouteAssignmentsWithoutMasterPaperClaimCoverage :
    List EndpointOpenCutRouteAssignment :=
  endpointOpenCutRouteAssignments.filter
    (fun entry =>
      ! endpointOpenCutRouteAssignmentHasMasterPaperClaimCoverage entry)

def endpointOpenCutNamesWithoutMasterPaperClaimCoverage : List Lean.Name :=
  endpointOpenCutRouteAssignmentsWithoutMasterPaperClaimCoverage.map
    (fun entry => entry.cutName)

/-- R633 expected structural endpoint-cut exception list.  These endpoint cuts
are assigned only to structural route rows without direct master-paper claim
ids, so the paper must narrate them as infrastructure rather than theorem-like
paper claims. -/
def expectedStructuralEndpointOpenCutNamesWithoutMasterPaperClaimCoverage :
    List Lean.Name :=
  [``HodgeReduction.SmoothProjectiveVariety.cohomology]

def endpointOpenCutPaperCoverageExceptionsMatchTexStatus : Bool :=
  endpointOpenCutNamesWithoutMasterPaperClaimCoverage ==
    expectedStructuralEndpointOpenCutNamesWithoutMasterPaperClaimCoverage

/-- Machine-audited R633 snapshot: every endpoint cut assigned in R632 either
reaches a route gap with direct master-paper claim coverage or is the explicit
structural cohomology exception. -/
structure EndpointOpenCutPaperCoverageSnapshot where
  endpointOpenCutRouteAssignmentCount : Nat
  endpointOpenCutAssignmentsWithMasterPaperClaimCoverageCount : Nat
  endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount : Nat
  endpointOpenCutNamesWithoutMasterPaperClaimCoverage : List Lean.Name
  expectedStructuralEndpointOpenCutNamesWithoutMasterPaperClaimCoverage :
    List Lean.Name
  endpointOpenCutPaperCoverageExceptionsMatchTexStatus : Bool
  deriving Repr, DecidableEq, Inhabited

def currentEndpointOpenCutPaperCoverageSnapshot :
    EndpointOpenCutPaperCoverageSnapshot where
  endpointOpenCutRouteAssignmentCount := endpointOpenCutRouteAssignmentCount
  endpointOpenCutAssignmentsWithMasterPaperClaimCoverageCount :=
    endpointOpenCutRouteAssignmentsWithMasterPaperClaimCoverage.length
  endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount :=
    endpointOpenCutRouteAssignmentsWithoutMasterPaperClaimCoverage.length
  endpointOpenCutNamesWithoutMasterPaperClaimCoverage :=
    endpointOpenCutNamesWithoutMasterPaperClaimCoverage
  expectedStructuralEndpointOpenCutNamesWithoutMasterPaperClaimCoverage :=
    expectedStructuralEndpointOpenCutNamesWithoutMasterPaperClaimCoverage
  endpointOpenCutPaperCoverageExceptionsMatchTexStatus :=
    endpointOpenCutPaperCoverageExceptionsMatchTexStatus

/-- Machine-audited route-gap summary used by the master tex status box. -/
structure RouteGapStatusSnapshot where
  routeLevelGapCount : Nat
  routeLevelFinalOpenGapCount : Nat
  routeLevelInProgressGapCount : Nat
  routeLevelConditionalGapCount : Nat
  routeLevelOpenGapCount : Nat
  routeLevelDeferredGapCount : Nat
  routeLevelActiveOpenGapCount : Nat
  deriving Repr, DecidableEq, Inhabited

/-- Current route-gap status counts for the generated route ledger. -/
def currentRouteGapStatusSnapshot : RouteGapStatusSnapshot where
  routeLevelGapCount := routeLevelGapCount
  routeLevelFinalOpenGapCount := routeLevelFinalOpenGapCount
  routeLevelInProgressGapCount := routeLevelInProgressGapCount
  routeLevelConditionalGapCount := routeLevelConditionalGapCount
  routeLevelOpenGapCount := routeLevelOpenGapCount
  routeLevelDeferredGapCount := routeLevelDeferredGapCount
  routeLevelActiveOpenGapCount := routeLevelActiveOpenGapCount

/-- Exact route-level gap id/status pair used by the master tex status box. -/
structure RouteGapStatusEntry where
  gapId : String
  status : String
  deriving Repr, DecidableEq, Inhabited

/-- Exact route-level gap status ledger.  R621 fixes the id/status list, while
`currentRouteGapStatusSnapshot_eq_texStatus` fixes the aggregate counts. -/
def routeGapStatusLedger : List RouteGapStatusEntry :=
  config.researchGaps.map (fun g => { gapId := g.id, status := g.status })

/-- Exact route-level gap row annotated with the master-paper claim ids that
reference it. -/
structure MasterRouteGapClaimEntry where
  gapId : String
  status : String
  claimIds : List String
  deriving Repr, DecidableEq, Inhabited

/-- R623 route-gap-to-master-claim ledger.  This is the gap-status table that
the paper summary narrates, with the exact master-claim worklist attached to
each row. -/
def masterRouteGapClaimLedger : List MasterRouteGapClaimEntry :=
  routeGapStatusLedger.map
    (fun entry =>
      { gapId := entry.gapId
        status := entry.status
        claimIds :=
          HodgeReduction.PaperInventory.masterClaimIdsForGapId entry.gapId })

/-- Total number of per-gap master-claim references in the R623 ledger. -/
def masterRouteGapClaimLedgerClaimReferenceCount : Nat :=
  (masterRouteGapClaimLedger.map (fun entry => entry.claimIds.length)).foldl
    (fun total n => total + n) 0

/-- Route-gap rows with at least one direct master-paper claim reference. -/
def masterRouteGapRowsWithMasterClaims : List MasterRouteGapClaimEntry :=
  masterRouteGapClaimLedger.filter (fun entry => ! entry.claimIds.isEmpty)

/-- Route-gap rows with no direct master-paper claim reference.  These are not
automatically errors: some gaps are structural infrastructure gaps exposed by
the Lean route but not by a single theorem-like master-paper item. -/
def masterRouteGapRowsWithoutMasterClaims : List MasterRouteGapClaimEntry :=
  masterRouteGapClaimLedger.filter (fun entry => entry.claimIds.isEmpty)

/-- Route-level gap ids whose R623 row has no direct master-paper claim id. -/
def masterRouteGapIdsWithoutMasterClaims : List String :=
  masterRouteGapRowsWithoutMasterClaims.map (fun entry => entry.gapId)

/-- Expected R624 exception list: these two rows are structural infrastructure
gaps rather than master-paper claim rows. -/
def expectedStructuralInfraRouteGapIdsWithoutMasterClaims : List String :=
  ["G-l1-e7-shimura-tor", "G-l2-cohomology-construction"]

/-- R624 guard: only the known structural infrastructure gaps may have no
direct master-paper claim ids. -/
def masterRouteGapRowsWithoutMasterClaimsAreExpectedStructuralInfra : Bool :=
  masterRouteGapIdsWithoutMasterClaims ==
    expectedStructuralInfraRouteGapIdsWithoutMasterClaims

/-- Counts a mismatch between the R623 route-gap claim ledger and the R624
paper-summary exception list. -/
def masterRouteGapClaimCoverageFailureCount : Nat :=
  if masterRouteGapRowsWithoutMasterClaimsAreExpectedStructuralInfra then 0 else 1

/-- R624 paper-facing coverage snapshot for the route-gap-to-master-claim
ledger. -/
structure MasterRouteGapClaimCoverageSnapshot where
  routeLevelGapCount : Nat
  routeGapsWithMasterClaimsCount : Nat
  routeGapsWithoutMasterClaimsCount : Nat
  routeGapIdsWithoutMasterClaims : List String
  expectedStructuralInfraRouteGapIdsWithoutMasterClaims : List String
  allRowsWithoutMasterClaimsAreExpectedStructuralInfra : Bool
  masterRouteGapClaimCoverageFailureCount : Nat
  deriving Repr, DecidableEq, Inhabited

/-- Current R624 route-gap claim-coverage snapshot. -/
def currentMasterRouteGapClaimCoverageSnapshot :
    MasterRouteGapClaimCoverageSnapshot where
  routeLevelGapCount := routeLevelGapCount
  routeGapsWithMasterClaimsCount := masterRouteGapRowsWithMasterClaims.length
  routeGapsWithoutMasterClaimsCount :=
    masterRouteGapRowsWithoutMasterClaims.length
  routeGapIdsWithoutMasterClaims := masterRouteGapIdsWithoutMasterClaims
  expectedStructuralInfraRouteGapIdsWithoutMasterClaims :=
    expectedStructuralInfraRouteGapIdsWithoutMasterClaims
  allRowsWithoutMasterClaimsAreExpectedStructuralInfra :=
    masterRouteGapRowsWithoutMasterClaimsAreExpectedStructuralInfra
  masterRouteGapClaimCoverageFailureCount :=
    masterRouteGapClaimCoverageFailureCount

/-- Lookup the status string for a named research gap in the main-chain
configuration. -/
def gapStatusOf? (gapId : String) : Option String :=
  (config.researchGaps.find? (fun g => g.id == gapId)).map (fun g => g.status)

/-- All gap-id references appearing in the master-paper claim ledger. -/
def masterClaimGapReferenceIds : List String :=
  HodgeReduction.PaperInventory.masterClaims.flatMap (fun c => c.gapIds)

def masterClaimGapReferenceCount : Nat :=
  masterClaimGapReferenceIds.length

def unregisteredMasterClaimGapReferenceIds : List String :=
  masterClaimGapReferenceIds.filter
    (fun gapId => ! gapIdIsRouteRegistered gapId)

def unregisteredMasterClaimGapReferenceCount : Nat :=
  unregisteredMasterClaimGapReferenceIds.length

def masterClaimsWithUnregisteredGapIds :
    List HodgeReduction.PaperInventory.PaperClaim :=
  HodgeReduction.PaperInventory.masterClaims.filter
    (fun c => ! c.gapIds.all gapIdIsRouteRegistered)

def masterClaimsWithUnregisteredGapIdCount : Nat :=
  masterClaimsWithUnregisteredGapIds.length

def allMasterClaimGapReferencesRegisteredInRoute : Bool :=
  masterClaimGapReferenceIds.all gapIdIsRouteRegistered

/-- Machine-audited bridge from master-paper gap references to route gaps. -/
structure MasterClaimGapReferenceSnapshot where
  routeLevelGapCount : Nat
  masterClaimGapReferenceCount : Nat
  unregisteredMasterClaimGapReferenceCount : Nat
  masterClaimsWithUnregisteredGapIdCount : Nat
  allMasterClaimGapReferencesRegisteredInRoute : Bool
  deriving Repr, DecidableEq, Inhabited

def currentMasterClaimGapReferenceSnapshot :
    MasterClaimGapReferenceSnapshot where
  routeLevelGapCount := routeLevelGapCount
  masterClaimGapReferenceCount := masterClaimGapReferenceCount
  unregisteredMasterClaimGapReferenceCount :=
    unregisteredMasterClaimGapReferenceCount
  masterClaimsWithUnregisteredGapIdCount :=
    masterClaimsWithUnregisteredGapIdCount
  allMasterClaimGapReferencesRegisteredInRoute :=
    allMasterClaimGapReferencesRegisteredInRoute

/-- Kernel-checked certificate for the route-level status-count claims in the
master tex machine-audit snapshot. -/
theorem currentRouteGapStatusSnapshot_eq_texStatus :
    currentRouteGapStatusSnapshot =
      ({ routeLevelGapCount := 10
         routeLevelFinalOpenGapCount := 1
         routeLevelInProgressGapCount := 1
         routeLevelConditionalGapCount := 1
         routeLevelOpenGapCount := 5
         routeLevelDeferredGapCount := 1
         routeLevelActiveOpenGapCount := 1 } : RouteGapStatusSnapshot) := by
  decide

/-- R621 kernel-checked exact id/status ledger for the route-level gap summary
in the master tex. -/
theorem routeGapStatusLedger_eq_texStatus :
    routeGapStatusLedger =
      ([{ gapId := "G-full-hc", status := "final-open" },
        { gapId := "G-master-paper-import", status := "in-progress" },
        { gapId := "G-main-hc", status := "conditional" },
        { gapId := "G-l1-e7-shimura-tor", status := "open" },
        { gapId := "G-l2-cohomology-construction", status := "open" },
        { gapId := "G-l3-v56-mt-identification", status := "open" },
        { gapId := "G-l4-cm-abelian-hc", status := "open" },
        { gapId := "G-l4-mt-correspondence", status := "open" },
        { gapId := "G-classical-mathlib-port", status := "deferred" },
        { gapId := "G-hcgap-l4-multifront", status := "active-open" }] :
        List RouteGapStatusEntry) := by
  decide

/-- R631 kernel-checked endpoint-level open-cut ledger for the master tex
summary.  This is the exact flat `openAxioms` list used by the chain audit,
not the coarser ten-row route-gap ledger. -/
theorem currentEndpointOpenCutSnapshot_eq_texStatus :
    currentEndpointOpenCutSnapshot =
      ({ endpointOpenCutCount := 24
         expectedEndpointOpenCutCount := 24
         endpointOpenCutNames :=
          [``HodgeReduction.canonicalTargetVariety,
           ``HodgeReduction.canonicalTargetE7Factor,
           ``HodgeReduction.canonicalTargetInKnownE7Scope,
           ``HodgeReduction.SmoothProjectiveVariety.cohomology,
           ``HodgeReduction.SmoothProjectiveVariety.algClasses,
           ``HodgeReduction.absHodgeClassesAtDegreeCM,
           ``HodgeReduction.deligne_1982_abs_hodge_cm,
           ``HodgeReduction.abs_hodge_cm_implies_algebraic,
           ``HodgeReduction.lefschetz_11_hc_real_at_codim1,
           ``HodgeReduction.hc_real_classical_cartan,
           ``HodgeReduction.e6_classical_remainder_exists,
           ``HodgeReduction.e6_remainder_transfer,
           ``HodgeReduction.e7_cm_witness_exists,
           ``HodgeReduction.e7_chosen_witness_hsm_codim1,
           ``HodgeReduction.e7_chosen_witness_alg_map_codim1,
           ``HodgeReduction.e7_chosen_witness_square_codim1,
           ``HodgeReduction.e7_chosen_witness_hodge_surj_codim1,
           ``HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists,
           ``HodgeReduction.cy3_e7_springer_stage,
           ``HodgeReduction.cy3_e7_fts_omega_stage,
           ``HodgeReduction.cy3_e7_j3o_nonrealization_stage,
           ``HodgeReduction.cy3_inherits_e7_factor,
           ``HodgeReduction.cy3_mtd_isSemisimple,
           ``HodgeReduction.cy3_e7_excludes_e6]
         endpointOpenCutLedgerMatchesTexStatus := true
         endpointOpenCutCountMatchesTexStatus := true } :
        EndpointOpenCutSnapshot) := by
  rfl

theorem endpointOpenCutCount_eq_texStatus :
    endpointOpenCutCount = 24 := by
  rfl

/-- R632 kernel-checked endpoint-cut-to-route-gap assignment ledger.  This
keeps the flat 24-cut audit headline attached to the coarser route-gap table. -/
theorem endpointOpenCutRouteAssignments_eq_texStatus :
    endpointOpenCutRouteAssignments =
      ([{ cutName := ``HodgeReduction.canonicalTargetVariety
          routeGapIds := ["G-main-hc"] },
        { cutName := ``HodgeReduction.canonicalTargetE7Factor
          routeGapIds := ["G-main-hc", "G-l1-e7-shimura-tor"] },
        { cutName := ``HodgeReduction.canonicalTargetInKnownE7Scope
          routeGapIds := ["G-main-hc", "G-l1-e7-shimura-tor"] },
        { cutName := ``HodgeReduction.SmoothProjectiveVariety.cohomology
          routeGapIds := ["G-l2-cohomology-construction"] },
        { cutName := ``HodgeReduction.SmoothProjectiveVariety.algClasses
          routeGapIds := ["G-full-hc"] },
        { cutName := ``HodgeReduction.absHodgeClassesAtDegreeCM
          routeGapIds := ["G-l4-cm-abelian-hc"] },
        { cutName := ``HodgeReduction.deligne_1982_abs_hodge_cm
          routeGapIds := ["G-l4-cm-abelian-hc"] },
        { cutName := ``HodgeReduction.abs_hodge_cm_implies_algebraic
          routeGapIds := ["G-l4-cm-abelian-hc"] },
        { cutName := ``HodgeReduction.lefschetz_11_hc_real_at_codim1
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.hc_real_classical_cartan
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.e6_classical_remainder_exists
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.e6_remainder_transfer
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.e7_cm_witness_exists
          routeGapIds := ["G-l4-mt-correspondence"] },
        { cutName := ``HodgeReduction.e7_chosen_witness_hsm_codim1
          routeGapIds := ["G-l4-mt-correspondence"] },
        { cutName := ``HodgeReduction.e7_chosen_witness_alg_map_codim1
          routeGapIds := ["G-l4-mt-correspondence"] },
        { cutName := ``HodgeReduction.e7_chosen_witness_square_codim1
          routeGapIds := ["G-l4-mt-correspondence"] },
        { cutName := ``HodgeReduction.e7_chosen_witness_hodge_surj_codim1
          routeGapIds := ["G-l4-mt-correspondence"] },
        { cutName := ``HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists
          routeGapIds := ["G-l4-mt-correspondence"] },
        { cutName := ``HodgeReduction.cy3_e7_springer_stage
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.cy3_e7_fts_omega_stage
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.cy3_e7_j3o_nonrealization_stage
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.cy3_inherits_e7_factor
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.cy3_mtd_isSemisimple
          routeGapIds := ["G-classical-mathlib-port"] },
        { cutName := ``HodgeReduction.cy3_e7_excludes_e6
          routeGapIds := ["G-classical-mathlib-port"] }] :
        List EndpointOpenCutRouteAssignment) := by
  rfl

/-- R632 kernel-checked aggregate status for the endpoint-cut-to-route-gap
assignment ledger. -/
theorem currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus :
    currentEndpointOpenCutRouteAssignmentSnapshot =
      ({ endpointOpenCutCount := 24
         endpointOpenCutRouteAssignmentCount := 24
         endpointOpenCutRouteAssignmentsCoverOpenCuts := true
         endpointOpenCutRouteAssignmentCountMatchesOpenCuts := true
         endpointOpenCutRouteAssignmentsWithoutRouteGapCount := 0
         allEndpointOpenCutRouteAssignmentsHaveRouteGap := true
         endpointOpenCutRouteAssignmentGapReferenceCount := 26
         unregisteredEndpointOpenCutRouteAssignmentGapIdCount := 0
         allEndpointOpenCutRouteAssignmentGapIdsRegistered := true } :
        EndpointOpenCutRouteAssignmentSnapshot) := by
  decide

/-- R633 kernel-checked paper-coverage status for endpoint-cut assignments:
the only endpoint cut assigned solely to route rows without direct master-paper
claim coverage is the structural cohomology construction cut. -/
theorem currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus :
    currentEndpointOpenCutPaperCoverageSnapshot =
      ({ endpointOpenCutRouteAssignmentCount := 24
         endpointOpenCutAssignmentsWithMasterPaperClaimCoverageCount := 23
         endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount := 1
         endpointOpenCutNamesWithoutMasterPaperClaimCoverage :=
          [``HodgeReduction.SmoothProjectiveVariety.cohomology]
         expectedStructuralEndpointOpenCutNamesWithoutMasterPaperClaimCoverage :=
          [``HodgeReduction.SmoothProjectiveVariety.cohomology]
         endpointOpenCutPaperCoverageExceptionsMatchTexStatus := true } :
        EndpointOpenCutPaperCoverageSnapshot) := by
  decide

set_option maxRecDepth 40000

/-- R623 kernel-checked exact ledger from each route-level gap id/status row to
the master-paper claim ids that reference it.  This prevents the paper summary
from changing the per-gap worklists without changing Lean. -/
theorem currentMasterRouteGapClaimLedger_eq_texStatus :
    masterRouteGapClaimLedger =
      ([{ gapId := "G-full-hc", status := "final-open", claimIds :=
           ["conj:HC", "thm:main", "thm:general-variety-reduction",
            "prop:coverage", "thm:E7_scope", "prop:exotic-narrowing",
            "thm:sg17-partial-kill", "prop:d5-e7-closure",
            "cor:E7_full_closure", "prop:exc_covered",
            "thm:torelli-evii-verdict", "open:torelli-evii",
            "open:exotic-residual", "prop:omega-diagonal",
            "prop:theta-closure", "prop:combined-closure"] },
         { gapId := "G-master-paper-import", status := "in-progress",
           claimIds :=
           ["input:Ran", "thm:CDK", "thm:CMdensity", "thm:BKT",
            "thm:PS", "thm:BBT", "prop:coherence-lemma", "thm:HCab",
            "cor:Ab_covers", "thm:levi-reduction-min3", "thm:KUY",
            "thm:PrincipleB", "thm:AHD", "thm:generic_fiber",
            "thm:meyer_rank", "cor:aniso_empty", "thm:GLB_full",
            "cor:Orth_covers", "thm:Satake_abelian_classification",
            "thm:E6_chernweil", "cor:E7_shimura_closed",
            "thm:E7_scope", "thm:F-bkt-bbt", "lem:sg19-bilinear-invariants",
            "thm:E7_approachF", "lem:F-natural-V56",
            "thm:bundle-matching-unconditional", "prop:hbundle-low-dim",
            "prop:exotic-narrowing", "lem:sg17-stepA", "lem:sg17-stepB",
            "thm:sg17-partial-kill", "prop:d5-e7-closure",
            "lem:sg5-b2-b4-conditional", "lem:sg5-hodge-diamond-conditional",
            "cor:sg5-chi-omega-conditional", "cor:sg5-35to1-reduction",
            "cor:E7_full_closure", "prop:exc_covered", "thm:Voisin_integral",
            "thm:Andre_motivated", "prop:margulis-conditional",
            "prop:mok-conditional", "thm:torelli-evii-verdict",
            "lem:fibre-density", "prop:boundary-in-u7", "prop:w0-flip",
            "thm:parabolic-density", "thm:e7-arithmeticity",
            "thm:subcase3b-vacuous", "cor:hc-conditional-nonrigid-e7",
            "open:torelli-evii", "open:hbundle", "open:fibre-id",
            "prop:shimura-fibre-density", "thm:SL8-quartic-decomposition",
            "prop:q4-abelian-algebraicity", "prop:omega-diagonal",
            "lem:sg23-andre-closure", "lem:sg18-pi3-chow-conditional",
            "prop:theta-closure", "thm:E7-modularity", "thm:E7-theta-match",
            "cor:theta-step-iii", "lem:CM-E7-algebraicity",
            "thm:E7-BBT-spreading", "prop:quartic-chern",
            "prop:deligne-splitting", "cor:quartic-algebraic",
            "lem:sg22-tabuada-nc-no-shortcut", "thm:eigenvalue-separation",
            "lem:sg14-honda-tate-non-abelian-conditional", "thm:p-adic-descent",
            "lem:sg20-rho-omega-tate-conditional", "prop:combined-closure"] },
         { gapId := "G-main-hc", status := "conditional", claimIds :=
           ["hyp:CM-correspondences", "thm:main", "input:Hbundle",
            "input:motivic-span", "thm:general-variety-reduction", "thm:BKT",
            "thm:BBT", "cor:Ab_covers", "hyp:KS-p3",
            "thm:levi-reduction-min3", "def:WLH", "thm:KUY", "thm:AHD",
            "thm:generic_fiber", "thm:GLB_full", "cor:Orth_covers",
            "thm:Satake_abelian_classification", "thm:E6_chernweil", "thm:E7_chernweil",
            "cor:E7_shimura_closed", "rem:E7-chernweil-tautology",
            "thm:E7_scope", "thm:F-bkt-bbt", "thm:E7_approachF",
            "prop:exotic-narrowing", "lem:sg17-stepA", "lem:sg17-stepB",
            "thm:sg17-partial-kill", "prop:d5-e7-closure",
            "lem:sg5-b2-b4-conditional", "lem:sg5-hodge-diamond-conditional",
            "cor:sg5-chi-omega-conditional", "cor:sg5-35to1-reduction",
            "cor:E7_full_closure", "prop:exc_covered", "prop:lattice-gap",
            "prop:mok-conditional", "thm:torelli-evii-verdict",
            "lem:fibre-density", "prop:boundary-in-u7", "prop:w0-flip",
            "thm:parabolic-density", "thm:e7-arithmeticity", "hyp:hecke-bbt",
            "thm:subcase3b-vacuous", "cor:hc-conditional-nonrigid-e7",
            "open:torelli-evii", "open:exotic-residual", "open:hbundle",
            "open:fibre-id", "prop:shimura-fibre-density",
            "thm:SL8-quartic-decomposition", "prop:q4-abelian-algebraicity",
            "prop:omega-diagonal", "lem:sg23-andre-closure",
            "lem:sg18-pi3-chow-conditional", "prop:theta-closure",
            "thm:E7-modularity", "hyp:chow-modularity-E7",
            "thm:E7-theta-match", "cor:theta-step-iii",
            "lem:CM-E7-algebraicity", "hyp:AH-CM-E7",
            "hyp:ChernWeil-bridge-E7", "hyp:BBT-rigid-reach",
            "hyp:nonrigid-family-bridge", "thm:E7-BBT-spreading",
            "prop:quartic-chern", "prop:deligne-splitting",
            "cor:quartic-algebraic", "lem:sg22-tabuada-nc-no-shortcut",
            "thm:eigenvalue-separation",
            "lem:sg14-honda-tate-non-abelian-conditional",
            "lem:sg20-rho-omega-tate-conditional", "prop:combined-closure"] },
         { gapId := "G-l1-e7-shimura-tor", status := "open", claimIds := [] },
         { gapId := "G-l2-cohomology-construction", status := "open",
           claimIds := [] },
         { gapId := "G-l3-v56-mt-identification", status := "open",
           claimIds := ["lem:sg19-bilinear-invariants", "lem:F-natural-V56"] },
         { gapId := "G-l4-cm-abelian-hc", status := "open", claimIds :=
           ["thm:CMdensity", "thm:DelAH", "hyp:HC-CM-Ab", "thm:HCab",
            "cor:Ab_covers", "thm:PrincipleB", "thm:AHD", "thm:GLB_full",
            "cor:Orth_covers", "thm:DelAH_restated", "thm:Andre_motivated",
            "prop:q4-abelian-algebraicity", "lem:CM-E7-algebraicity"] },
         { gapId := "G-l4-mt-correspondence", status := "open", claimIds :=
           ["input:Hbundle", "thm:CDK", "thm:generic_fiber",
            "thm:E7_chernweil", "cor:E7_shimura_closed",
            "rem:E7-chernweil-tautology", "rem:borel-matsushima",
            "thm:F-bkt-bbt", "thm:E7_approachF", "lem:F-natural-V56",
            "thm:bundle-matching-unconditional", "prop:hbundle-low-dim",
            "prop:boundary-in-u7", "thm:e7-arithmeticity",
            "thm:subcase3b-vacuous", "cor:hc-conditional-nonrigid-e7",
            "open:hbundle", "open:fibre-id", "def:shimura-type-fibre",
            "thm:E7-modularity", "hyp:chow-modularity-E7",
            "thm:E7-theta-match", "cor:theta-step-iii", "hyp:AH-CM-E7",
            "hyp:ChernWeil-bridge-E7", "thm:E7-BBT-spreading",
            "prop:quartic-chern", "prop:deligne-splitting",
            "cor:quartic-algebraic"] },
         { gapId := "G-classical-mathlib-port", status := "deferred",
           claimIds :=
           ["input:Ran", "prop:coherence-lemma", "thm:meyer_rank",
            "cor:aniso_empty", "thm:E6_chernweil", "prop:hbundle-low-dim",
            "thm:cy3-e7-nonexistence", "thm:Voisin_integral",
            "prop:margulis-conditional", "lem:fibre-density", "prop:w0-flip",
            "thm:parabolic-density", "prop:shimura-fibre-density",
            "thm:SL8-quartic-decomposition"] },
         { gapId := "G-hcgap-l4-multifront", status := "active-open",
           claimIds := ["hyp:ChernWeil-bridge-E7"] }] :
        List MasterRouteGapClaimEntry) := by
  decide

/-- The R623 per-gap claim ledger accounts for the same 225 master-claim gap
references as the R617 flat reference ledger. -/
theorem masterRouteGapClaimLedgerClaimReferenceCount_eq_masterClaimGapReferenceCount :
    masterRouteGapClaimLedgerClaimReferenceCount = masterClaimGapReferenceCount := by
  decide

/-- R624 kernel-checked exception list for route-gap rows without direct
master-paper claim ids. -/
theorem currentMasterRouteGapClaimCoverageSnapshot_eq_texStatus :
    currentMasterRouteGapClaimCoverageSnapshot =
      ({ routeLevelGapCount := 10
         routeGapsWithMasterClaimsCount := 8
         routeGapsWithoutMasterClaimsCount := 2
         routeGapIdsWithoutMasterClaims :=
           ["G-l1-e7-shimura-tor", "G-l2-cohomology-construction"]
         expectedStructuralInfraRouteGapIdsWithoutMasterClaims :=
           ["G-l1-e7-shimura-tor", "G-l2-cohomology-construction"]
         allRowsWithoutMasterClaimsAreExpectedStructuralInfra := true
         masterRouteGapClaimCoverageFailureCount := 0 } :
        MasterRouteGapClaimCoverageSnapshot) := by
  decide

/-- Kernel-checked certificate that the full-HC target is still recorded as the
final open gap, not as a closed theorem. -/
theorem fullHcGapStatus_eq_finalOpen :
    gapStatusOf? "G-full-hc" = some "final-open" := by
  decide

set_option maxRecDepth 20000

/-- R617 kernel-checked certificate that every master-paper gap reference is a
registered route-level gap. -/
theorem currentMasterClaimGapReferenceSnapshot_eq_texStatus :
    currentMasterClaimGapReferenceSnapshot =
      ({ routeLevelGapCount := 10
         masterClaimGapReferenceCount := 225
         unregisteredMasterClaimGapReferenceCount := 0
         masterClaimsWithUnregisteredGapIdCount := 0
         allMasterClaimGapReferencesRegisteredInRoute := true } :
        MasterClaimGapReferenceSnapshot) := by
  decide

/-- Whether the current paper-facing full-HC summary claims a completed proof.
This deliberately combines the two full-target audit snapshots, so changing
either R611/R612 status forces the paper narrative certificate below to move. -/
def fullHcNarrativeClaimsCompleteProof : Bool :=
  HodgeReduction.currentFullHodgeClosureStatusSnapshot.fullHcClosureClaim ||
    HodgeReduction.currentFullHodgeScopeOrComplementSnapshot.fullHcClosureClaim ||
      HodgeReduction.currentR613ResidualGateRouteSnapshot.fullHcClosureClaim

/-- Convert a summary-check Boolean into a count so the paper can state a
single zero-failure guard. -/
def boolFailureCount (b : Bool) : Nat :=
  if b then 0 else 1

/-- Counts a paper-summary overclaim that the full Hodge conjecture is already
proved.  The current value is zero because the summary deliberately says the
full theorem is still open. -/
def fullHcCompletionOverclaimCount : Nat :=
  if fullHcNarrativeClaimsCompleteProof then 1 else 0

/-- Counts a mismatch between the paper summary and the route status of the
full-HC gap. -/
def fullHcFinalOpenStatusFailureCount : Nat :=
  if gapStatusOf? "G-full-hc" == some "final-open" then 0 else 1

/-- Aggregate R631 endpoint-cut ledger failures used by the paper summary
guard.  A nonzero value means the flat endpoint-level open-cut count or list in
the Lean-status prose has drifted from the audit config. -/
def endpointOpenCutFailureCount : Nat :=
  boolFailureCount endpointOpenCutLedgerMatchesTexStatus +
    boolFailureCount endpointOpenCutCountMatchesTexStatus

/-- Aggregate R632 endpoint-cut route-assignment failures used by the paper
summary guard.  A nonzero value means a configured endpoint cut lacks a
route-gap owner, the assignment ledger omits or adds a cut, or one of its
gap ids is not registered in the route ledger. -/
def endpointOpenCutRouteAssignmentFailureCount : Nat :=
  boolFailureCount
      currentEndpointOpenCutRouteAssignmentSnapshot.endpointOpenCutRouteAssignmentsCoverOpenCuts +
    boolFailureCount
        currentEndpointOpenCutRouteAssignmentSnapshot.endpointOpenCutRouteAssignmentCountMatchesOpenCuts +
      currentEndpointOpenCutRouteAssignmentSnapshot.endpointOpenCutRouteAssignmentsWithoutRouteGapCount +
        boolFailureCount
            currentEndpointOpenCutRouteAssignmentSnapshot.allEndpointOpenCutRouteAssignmentsHaveRouteGap +
          currentEndpointOpenCutRouteAssignmentSnapshot.unregisteredEndpointOpenCutRouteAssignmentGapIdCount +
            boolFailureCount
              currentEndpointOpenCutRouteAssignmentSnapshot.allEndpointOpenCutRouteAssignmentGapIdsRegistered

/-- Aggregate R633 endpoint-cut paper-coverage failures used by the paper
summary guard.  A nonzero value means an endpoint cut is assigned only to
route rows without direct master-paper claims, but is not one of the expected
structural-infrastructure exceptions. -/
def endpointOpenCutPaperCoverageFailureCount : Nat :=
  boolFailureCount
    currentEndpointOpenCutPaperCoverageSnapshot.endpointOpenCutPaperCoverageExceptionsMatchTexStatus

/-- Aggregate R615 tag-pointer failures used by the paper summary guard. -/
def masterClaimTagPointerFailureCount : Nat :=
  HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot.formalizedClaimsWithoutLeanDeclCount +
    HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot.kernelOnlyClaimsWithoutLeanDeclCount +
      HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot.registeredGapClaimsWithoutGapIdCount +
        HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot.openHypothesisClaimsWithoutGapIdCount +
          HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot.openResidualClaimsWithoutGapIdCount +
            HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot.newMathGapClaimsWithoutGapIdCount

/-- Aggregate R616 disposition/tag mismatch count used by the paper summary
guard. -/
def masterClaimDispositionTagMismatchCount : Nat :=
  HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot.formalizedClaimsWithOpenOrUnportedTagCount +
    HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot.openHypothesisClaimsWithoutNewMathGapTagCount +
      HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot.openResidualClaimsWithoutNewMathGapTagCount +
        HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot.registeredGapClaimsWithoutMigrationDebtTagCount +
          HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot.conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount

/-- Aggregate R625 broken-link discipline failures used by the paper summary
guard.  A nonzero value means the paper has named a broken-link predicate
outside the explicit open/gap-facing inventory. -/
def masterBrokenLinkDisciplineFailureCount : Nat :=
  HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot.brokenLinkDeclNamesMissingMasterClaim.length +
    boolFailureCount
        HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot.allBrokenLinkDeclsReferencedByMasterClaim +
      boolFailureCount
          HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot.allBrokenLinkClaimsHaveOpenOrGapDisposition +
        HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot.brokenLinkClaimsWithoutOpenOrGapDispositionCount +
          boolFailureCount
              HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot.allBrokenLinkClaimsTaggedNewMathGap +
            HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot.brokenLinkClaimsWithoutNewMathGapTagCount

/-- Aggregate R626 sub-gap status-marker failures used by the paper summary
guard.  A nonzero value means explicit `gapOpen` / `gapPartial` /
`gapBlocked` prose in the master tex has an unknown status or no Lean anchor. -/
def masterSubgapStatusMarkerFailureCount : Nat :=
  boolFailureCount
      HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot.allMarkersHaveAllowedStatus +
    HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot.markersWithUnknownStatusCount +
      boolFailureCount
          HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot.allMarkersHaveLeanDecl +
        HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot.markersWithoutLeanDeclCount

/-- Aggregate R627 primary-hypothesis list failures used by the paper summary
guard.  A nonzero value means the abstract/status/conclusion list no longer
matches the open-hypothesis ledger. -/
def masterPrimaryHypothesisDisciplineFailureCount : Nat :=
  HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot.primaryLabelledHypothesisDisciplineFailureCount

def scopeSubclassRouteGapReferenceIds : List String :=
  HodgeReduction.PaperInventory.masterScopeSubclassStatusEntries.flatMap
    (fun row => row.routeGapIds)

def unregisteredScopeSubclassRouteGapReferenceIds : List String :=
  scopeSubclassRouteGapReferenceIds.filter
    (fun gapId => ! gapIdIsRouteRegistered gapId)

def unregisteredScopeSubclassRouteGapReferenceCount : Nat :=
  unregisteredScopeSubclassRouteGapReferenceIds.length

def allScopeSubclassRouteGapReferencesRegisteredInRoute : Bool :=
  scopeSubclassRouteGapReferenceIds.all gapIdIsRouteRegistered

/-- Aggregate R628 scope-subclass status failures used by the paper summary
guard.  A nonzero value means the Scope paragraph or conclusion has drifted
from the four-row subclass ledger. -/
def masterScopeSubclassStatusFailureCount : Nat :=
  HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot.scopeSubclassStatusFailureCount +
    unregisteredScopeSubclassRouteGapReferenceCount +
      boolFailureCount allScopeSubclassRouteGapReferencesRegisteredInRoute

/-- Aggregate R629 trust-base inventory failures used by the paper summary
guard.  A nonzero value means the Lean-status section's axiom count has
drifted from the generated top-level project environment. -/
def projectAxiomTrustBaseFailureCount : Nat :=
  boolFailureCount
    HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot.countMatchesTexStatus

/-- Aggregate R630 direct `sorryAx` failures used by the paper summary guard.
This is a compiled-environment check over project-prefixed declarations visible
from the root import, not a textual search through comments or audit history. -/
def projectSorryAxFailureCount : Nat :=
  boolFailureCount
      HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot.noProjectDeclarationsWithSorryAx +
    HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot.projectDeclarationsWithSorryAxCount

/-- Aggregate R618 source-discipline failures used by the paper summary
guard. -/
def masterSourceDisciplineFailureCount : Nat :=
  boolFailureCount
      HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.canonicalMasterSourcePathIsMasterTex +
    boolFailureCount
        HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.canonicalMasterSourceRoleIsCanonical +
      boolFailureCount
          HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.allArchivedBackgroundSourcesHaveArchiveRole +
        boolFailureCount
            HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.allMasterClaimSourceIdsKnown +
          HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.masterClaimsWithUnknownSourceIdCount +
            boolFailureCount
                HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.allMasterClaimsUseCanonicalMasterSource +
              HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot.masterClaimsOutsideCanonicalSourceCount

/-- Aggregate R619 theorem-environment coverage failures used by the paper
summary guard.  The six load-bearing input/remark claims outside theorem-like
environments are not failures and are recorded separately by R619. -/
def masterEnvironmentCoverageFailureCount : Nat :=
  boolFailureCount
      HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot.allMasterEnvironmentsHaveUniqueClaim +
    HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot.masterEnvironmentsWithoutUniqueClaimCount +
      boolFailureCount
          HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot.allClaimedMasterEnvironmentKindsMatch +
        HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot.masterEnvironmentsWithKindMismatchCount

/-- R620 summary guard: every headline status claim in the master-paper
machine-audit paragraph is tied to the live route and paper-inventory
snapshots.  A nonzero value means the prose must be updated or the ledger must
be repaired before the paper summary is coherent. -/
def paperSummaryClaimFailureCount : Nat :=
  fullHcCompletionOverclaimCount +
    fullHcFinalOpenStatusFailureCount +
      endpointOpenCutFailureCount +
        endpointOpenCutRouteAssignmentFailureCount +
          endpointOpenCutPaperCoverageFailureCount +
            HodgeReduction.PaperInventory.currentMasterAuditSnapshot.unclaimedMasterEnvironmentCount +
              HodgeReduction.PaperInventory.currentMasterAuditSnapshot.untaggedMasterClaimCount +
                HodgeReduction.PaperInventory.currentMasterAuditSnapshot.claimsWithoutMachineCorrespondenceCount +
                  unregisteredMasterClaimGapReferenceCount +
                    masterClaimsWithUnregisteredGapIdCount +
                      masterClaimTagPointerFailureCount +
                        masterClaimDispositionTagMismatchCount +
                          masterBrokenLinkDisciplineFailureCount +
                              masterSubgapStatusMarkerFailureCount +
                                masterPrimaryHypothesisDisciplineFailureCount +
                                  masterScopeSubclassStatusFailureCount +
                                    projectAxiomTrustBaseFailureCount +
                                      projectSorryAxFailureCount +
                                        masterSourceDisciplineFailureCount +
                                          masterEnvironmentCoverageFailureCount +
                                            masterRouteGapClaimCoverageFailureCount +
                                              HodgeReduction.PaperInventory.currentMasterAuditSnapshot.needsTriageCount

/-- Single kernel-checked status record for summary prose in the master paper.

This ties together the full-HC non-closure claim, the route-level gap counts,
and the master-paper import counts.  It is audit metadata, not a mathematical
theorem about Hodge classes. -/
structure PaperNarrativeConsistencySnapshot where
  fullHcGapStatus : Option String
  fullHcNarrativeClaimsCompleteProof : Bool
  fullHcCompletionOverclaimCount : Nat
  fullHcFinalOpenStatusFailureCount : Nat
  r611FullClosureClaim : Bool
  r612ScopeOrComplementClosureClaim : Bool
  r613ResidualGateClosureClaim : Bool
  routeLevelGapCount : Nat
  routeLevelFinalOpenGapCount : Nat
  routeLevelInProgressGapCount : Nat
  routeLevelConditionalGapCount : Nat
  routeLevelOpenGapCount : Nat
  routeLevelDeferredGapCount : Nat
  routeLevelActiveOpenGapCount : Nat
  endpointOpenCutCount : Nat
  endpointOpenCutLedgerMatchesTexStatus : Bool
  endpointOpenCutFailureCount : Nat
  endpointOpenCutRouteAssignmentCount : Nat
  endpointOpenCutRouteAssignmentsCoverOpenCuts : Bool
  unregisteredEndpointOpenCutRouteAssignmentGapIdCount : Nat
  endpointOpenCutRouteAssignmentFailureCount : Nat
  endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount : Nat
  endpointOpenCutPaperCoverageExceptionsMatchTexStatus : Bool
  endpointOpenCutPaperCoverageFailureCount : Nat
  masterEnvironmentCount : Nat
  masterClaimCount : Nat
  unclaimedMasterEnvironmentCount : Nat
  untaggedMasterClaimCount : Nat
  allMasterClaimsHaveMachineCorrespondence : Bool
  claimsWithoutMachineCorrespondenceCount : Nat
  allMasterClaimGapReferencesRegisteredInRoute : Bool
  masterClaimGapReferenceCount : Nat
  unregisteredMasterClaimGapReferenceCount : Nat
  masterClaimsWithUnregisteredGapIdCount : Nat
  formalizedClaimCount : Nat
  provenInPaperClaimCount : Nat
  conditionalMilestoneClaimCount : Nat
  externalCitationClaimCount : Nat
  registeredGapClaimCount : Nat
  openHypothesisClaimCount : Nat
  openResidualClaimCount : Nat
  archiveOnlyClaimCount : Nat
  needsTriageCount : Nat
  kernelOnlyLeanClaimCount : Nat
  paperProofNotKernelPortedClaimCount : Nat
  externalCitationNotKernelPortedClaimCount : Nat
  newMathGapClaimCount : Nat
  migrationDebtClaimCount : Nat
  masterClaimTagPointerFailureCount : Nat
  masterClaimDispositionTagMismatchCount : Nat
  masterBrokenLinkDisciplineFailureCount : Nat
  masterSubgapStatusMarkerFailureCount : Nat
  masterPrimaryHypothesisDisciplineFailureCount : Nat
  scopeSubclassRouteGapReferenceCount : Nat
  unregisteredScopeSubclassRouteGapReferenceCount : Nat
  allScopeSubclassRouteGapReferencesRegisteredInRoute : Bool
  masterScopeSubclassStatusFailureCount : Nat
  projectAxiomConstantCount : Nat
  expectedProjectAxiomConstantCount : Nat
  projectAxiomConstantCountMatchesTexStatus : Bool
  projectAxiomTrustBaseFailureCount : Nat
  projectDeclarationsWithSorryAxCount : Nat
  noProjectDeclarationsWithSorryAx : Bool
  projectSorryAxFailureCount : Nat
  masterSourceDisciplineFailureCount : Nat
  masterEnvironmentCoverageFailureCount : Nat
  masterRouteGapClaimCoverageFailureCount : Nat
  paperSummaryClaimFailureCount : Nat
  deriving Repr, DecidableEq, Inhabited

/-- Current paper-narrative consistency record used by the master tex summary
box and the final-status prose near the open residual section. -/
def currentPaperNarrativeConsistencySnapshot :
    PaperNarrativeConsistencySnapshot where
  fullHcGapStatus := gapStatusOf? "G-full-hc"
  fullHcNarrativeClaimsCompleteProof := fullHcNarrativeClaimsCompleteProof
  fullHcCompletionOverclaimCount := fullHcCompletionOverclaimCount
  fullHcFinalOpenStatusFailureCount := fullHcFinalOpenStatusFailureCount
  r611FullClosureClaim :=
    HodgeReduction.currentFullHodgeClosureStatusSnapshot.fullHcClosureClaim
  r612ScopeOrComplementClosureClaim :=
    HodgeReduction.currentFullHodgeScopeOrComplementSnapshot.fullHcClosureClaim
  r613ResidualGateClosureClaim :=
    HodgeReduction.currentR613ResidualGateRouteSnapshot.fullHcClosureClaim
  routeLevelGapCount := currentRouteGapStatusSnapshot.routeLevelGapCount
  routeLevelFinalOpenGapCount :=
    currentRouteGapStatusSnapshot.routeLevelFinalOpenGapCount
  routeLevelInProgressGapCount :=
    currentRouteGapStatusSnapshot.routeLevelInProgressGapCount
  routeLevelConditionalGapCount :=
    currentRouteGapStatusSnapshot.routeLevelConditionalGapCount
  routeLevelOpenGapCount := currentRouteGapStatusSnapshot.routeLevelOpenGapCount
  routeLevelDeferredGapCount :=
    currentRouteGapStatusSnapshot.routeLevelDeferredGapCount
  routeLevelActiveOpenGapCount :=
    currentRouteGapStatusSnapshot.routeLevelActiveOpenGapCount
  endpointOpenCutCount := currentEndpointOpenCutSnapshot.endpointOpenCutCount
  endpointOpenCutLedgerMatchesTexStatus :=
    currentEndpointOpenCutSnapshot.endpointOpenCutLedgerMatchesTexStatus
  endpointOpenCutFailureCount := endpointOpenCutFailureCount
  endpointOpenCutRouteAssignmentCount :=
    currentEndpointOpenCutRouteAssignmentSnapshot.endpointOpenCutRouteAssignmentCount
  endpointOpenCutRouteAssignmentsCoverOpenCuts :=
    currentEndpointOpenCutRouteAssignmentSnapshot.endpointOpenCutRouteAssignmentsCoverOpenCuts
  unregisteredEndpointOpenCutRouteAssignmentGapIdCount :=
    currentEndpointOpenCutRouteAssignmentSnapshot.unregisteredEndpointOpenCutRouteAssignmentGapIdCount
  endpointOpenCutRouteAssignmentFailureCount :=
    endpointOpenCutRouteAssignmentFailureCount
  endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount :=
    currentEndpointOpenCutPaperCoverageSnapshot.endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount
  endpointOpenCutPaperCoverageExceptionsMatchTexStatus :=
    currentEndpointOpenCutPaperCoverageSnapshot.endpointOpenCutPaperCoverageExceptionsMatchTexStatus
  endpointOpenCutPaperCoverageFailureCount :=
    endpointOpenCutPaperCoverageFailureCount
  masterEnvironmentCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.masterEnvironmentCount
  masterClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.masterClaimCount
  unclaimedMasterEnvironmentCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.unclaimedMasterEnvironmentCount
  untaggedMasterClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.untaggedMasterClaimCount
  allMasterClaimsHaveMachineCorrespondence :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.allMasterClaimsHaveMachineCorrespondence
  claimsWithoutMachineCorrespondenceCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.claimsWithoutMachineCorrespondenceCount
  allMasterClaimGapReferencesRegisteredInRoute :=
    currentMasterClaimGapReferenceSnapshot.allMasterClaimGapReferencesRegisteredInRoute
  masterClaimGapReferenceCount :=
    currentMasterClaimGapReferenceSnapshot.masterClaimGapReferenceCount
  unregisteredMasterClaimGapReferenceCount :=
    currentMasterClaimGapReferenceSnapshot.unregisteredMasterClaimGapReferenceCount
  masterClaimsWithUnregisteredGapIdCount :=
    currentMasterClaimGapReferenceSnapshot.masterClaimsWithUnregisteredGapIdCount
  formalizedClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.formalizedClaimCount
  provenInPaperClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.provenInPaperClaimCount
  conditionalMilestoneClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.conditionalMilestoneClaimCount
  externalCitationClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.externalCitationClaimCount
  registeredGapClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.registeredGapClaimCount
  openHypothesisClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.openHypothesisClaimCount
  openResidualClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.openResidualClaimCount
  archiveOnlyClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.archiveOnlyClaimCount
  needsTriageCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.needsTriageCount
  kernelOnlyLeanClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.kernelOnlyLeanClaimCount
  paperProofNotKernelPortedClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.paperProofNotKernelPortedClaimCount
  externalCitationNotKernelPortedClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.externalCitationNotKernelPortedClaimCount
  newMathGapClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.newMathGapClaimCount
  migrationDebtClaimCount :=
    HodgeReduction.PaperInventory.currentMasterAuditSnapshot.migrationDebtClaimCount
  masterClaimTagPointerFailureCount := masterClaimTagPointerFailureCount
  masterClaimDispositionTagMismatchCount := masterClaimDispositionTagMismatchCount
  masterBrokenLinkDisciplineFailureCount :=
    masterBrokenLinkDisciplineFailureCount
  masterSubgapStatusMarkerFailureCount :=
    masterSubgapStatusMarkerFailureCount
  masterPrimaryHypothesisDisciplineFailureCount :=
    masterPrimaryHypothesisDisciplineFailureCount
  scopeSubclassRouteGapReferenceCount := scopeSubclassRouteGapReferenceIds.length
  unregisteredScopeSubclassRouteGapReferenceCount :=
    unregisteredScopeSubclassRouteGapReferenceCount
  allScopeSubclassRouteGapReferencesRegisteredInRoute :=
    allScopeSubclassRouteGapReferencesRegisteredInRoute
  masterScopeSubclassStatusFailureCount := masterScopeSubclassStatusFailureCount
  projectAxiomConstantCount :=
    HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot.projectAxiomConstantCount
  expectedProjectAxiomConstantCount :=
    HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot.expectedProjectAxiomConstantCount
  projectAxiomConstantCountMatchesTexStatus :=
    HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot.countMatchesTexStatus
  projectAxiomTrustBaseFailureCount := projectAxiomTrustBaseFailureCount
  projectDeclarationsWithSorryAxCount :=
    HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot.projectDeclarationsWithSorryAxCount
  noProjectDeclarationsWithSorryAx :=
    HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot.noProjectDeclarationsWithSorryAx
  projectSorryAxFailureCount := projectSorryAxFailureCount
  masterSourceDisciplineFailureCount := masterSourceDisciplineFailureCount
  masterEnvironmentCoverageFailureCount := masterEnvironmentCoverageFailureCount
  masterRouteGapClaimCoverageFailureCount :=
    masterRouteGapClaimCoverageFailureCount
  paperSummaryClaimFailureCount := paperSummaryClaimFailureCount

/-- Kernel-checked certificate for the master paper's one-paragraph summary
status.  If the route ledger, R611/R612 full-HC status, or paper inventory
counts change, this theorem forces the summary claim to be updated. -/
theorem currentPaperNarrativeConsistencySnapshot_eq_texStatus :
    currentPaperNarrativeConsistencySnapshot =
      ({ fullHcGapStatus := some "final-open"
         fullHcNarrativeClaimsCompleteProof := false
         fullHcCompletionOverclaimCount := 0
         fullHcFinalOpenStatusFailureCount := 0
         r611FullClosureClaim := false
         r612ScopeOrComplementClosureClaim := false
         r613ResidualGateClosureClaim := false
         routeLevelGapCount := 10
         routeLevelFinalOpenGapCount := 1
         routeLevelInProgressGapCount := 1
         routeLevelConditionalGapCount := 1
         routeLevelOpenGapCount := 5
         routeLevelDeferredGapCount := 1
         routeLevelActiveOpenGapCount := 1
         endpointOpenCutCount := 24
         endpointOpenCutLedgerMatchesTexStatus := true
         endpointOpenCutFailureCount := 0
         endpointOpenCutRouteAssignmentCount := 24
         endpointOpenCutRouteAssignmentsCoverOpenCuts := true
         unregisteredEndpointOpenCutRouteAssignmentGapIdCount := 0
         endpointOpenCutRouteAssignmentFailureCount := 0
         endpointOpenCutAssignmentsWithoutMasterPaperClaimCoverageCount := 1
         endpointOpenCutPaperCoverageExceptionsMatchTexStatus := true
         endpointOpenCutPaperCoverageFailureCount := 0
         masterEnvironmentCount := 100
         masterClaimCount := 106
         unclaimedMasterEnvironmentCount := 0
         untaggedMasterClaimCount := 0
         allMasterClaimsHaveMachineCorrespondence := true
         claimsWithoutMachineCorrespondenceCount := 0
         allMasterClaimGapReferencesRegisteredInRoute := true
         masterClaimGapReferenceCount := 225
         unregisteredMasterClaimGapReferenceCount := 0
         masterClaimsWithUnregisteredGapIdCount := 0
         formalizedClaimCount := 16
         provenInPaperClaimCount := 0
         conditionalMilestoneClaimCount := 33
         externalCitationClaimCount := 13
         registeredGapClaimCount := 29
         openHypothesisClaimCount := 9
         openResidualClaimCount := 6
         archiveOnlyClaimCount := 0
         needsTriageCount := 0
         kernelOnlyLeanClaimCount := 64
         paperProofNotKernelPortedClaimCount := 51
         externalCitationNotKernelPortedClaimCount := 29
         newMathGapClaimCount := 20
         migrationDebtClaimCount := 59
         masterClaimTagPointerFailureCount := 0
         masterClaimDispositionTagMismatchCount := 0
         masterBrokenLinkDisciplineFailureCount := 0
         masterSubgapStatusMarkerFailureCount := 0
         masterPrimaryHypothesisDisciplineFailureCount := 0
         scopeSubclassRouteGapReferenceCount := 15
         unregisteredScopeSubclassRouteGapReferenceCount := 0
         allScopeSubclassRouteGapReferencesRegisteredInRoute := true
         masterScopeSubclassStatusFailureCount := 0
         projectAxiomConstantCount := 250
         expectedProjectAxiomConstantCount := 250
         projectAxiomConstantCountMatchesTexStatus := true
         projectAxiomTrustBaseFailureCount := 0
         projectDeclarationsWithSorryAxCount := 0
         noProjectDeclarationsWithSorryAx := true
         projectSorryAxFailureCount := 0
         masterSourceDisciplineFailureCount := 0
         masterEnvironmentCoverageFailureCount := 0
         masterRouteGapClaimCoverageFailureCount := 0
         paperSummaryClaimFailureCount := 0 } :
        PaperNarrativeConsistencySnapshot) := by
  decide

/-- R620 kernel-checked guard for the master tex's summary-status paragraph. -/
theorem paperSummaryClaimFailureCount_eq_zero :
    paperSummaryClaimFailureCount = 0 := by
  decide

end HodgeReduction.MainChain
