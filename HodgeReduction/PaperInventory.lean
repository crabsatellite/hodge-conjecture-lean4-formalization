/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction.FullHodgeGoal

/-!
# Canonical master-paper import inventory

This module records the paper-to-Lean import policy.  The canonical source
for the formalisation is
`../contributions/hodge-conjecture-master-proof.tex`; attack maps,
literature surveys, and round notes are archive/background material unless a
later round explicitly promotes a statement back into the master tex.

The entries below are metadata, not new mathematical axioms.  Their purpose is
to keep the master-paper content auditable while each item is either mapped to
existing Lean declarations, converted into a theorem, or registered as a named
gap in the existing audit format.
-/

namespace HodgeReduction
namespace PaperInventory

/-- Role of a paper-side source in the formalisation import. -/
inductive SourceRole where
  | canonicalMaster
  | archivedBackground
  deriving Repr, DecidableEq, Inhabited

/-- Coarse kind of a master-paper item. -/
inductive ClaimKind where
  | conjecture
  | hypothesis
  | theorem
  | proposition
  | lemma
  | corollary
  | definition
  | input
  | openQuestion
  | remark
  | section
  deriving Repr, DecidableEq, Inhabited

/-- Current Lean-side disposition of a master-paper item. -/
inductive ClaimDisposition where
  | formalized
  | provenInPaper
  | conditionalMilestone
  | externalCitation
  | registeredGap
  | openHypothesis
  | openResidual
  | archiveOnly
  | needsTriage
  deriving Repr, DecidableEq, Inhabited

/--
Machine-readable correspondence tags between a master-paper item and the Lean
project.

These tags are intentionally about audit status, not mathematical optimism.
`kernelOnlyLeanCode` should be used only for items represented by Lean
declarations/proofs that are intended to be checked by the kernel.  Items whose
mathematics is accepted from a paper, book, or the manuscript itself but not
yet ported to a kernel proof remain `paperProofNotKernelPorted` or
`externalCitationNotKernelPorted`.  A `newMathGap` marks a real open
mathematical obligation; `migrationDebt` marks content that is expected to be
formalizable but has not yet been moved into Lean code.
-/
inductive ClaimAuditTag where
  | kernelOnlyLeanCode
  | paperProofNotKernelPorted
  | externalCitationNotKernelPorted
  | newMathGap
  | migrationDebt
  | conditionalLeanPackage
  | archiveOnly
  deriving Repr, DecidableEq, Inhabited

/-- Source file or source family.  Archive entries are not moved on disk; the
role records that they are non-canonical for formalisation import. -/
structure PaperSource where
  id : String
  path : String
  role : SourceRole
  title : String
  note : String
  deriving Repr, DecidableEq, Inhabited

/-- A master-paper item that should either map to Lean declarations or to an
explicit gap. -/
structure PaperClaim where
  id : String
  sourceId : String
  line : Nat
  kind : ClaimKind
  disposition : ClaimDisposition
  title : String
  leanDecls : List String := []
  gapIds : List String := []
  auditTags : List ClaimAuditTag := []
  notes : String := ""
  deriving Repr, DecidableEq, Inhabited

/-- One theorem-like environment extracted from the canonical master tex. -/
structure MasterEnvironment where
  line : Nat
  kind : ClaimKind
  label : String
  title : String
  deriving Repr, DecidableEq, Inhabited

/-- A status marker for a sub-gap or sub-gap-like master-paper item.
These markers track the explicit `gapOpen` / `gapPartial` / `gapBlocked`
claims in the canonical master tex. -/
structure MasterSubgapStatusMarker where
  id : String
  status : String
  line : Nat
  masterClaimIds : List String := []
  leanDecls : List String := []
  notes : String := ""
  deriving Repr, DecidableEq, Inhabited

/-- A status row for one of the four scope sub-classes in the master-paper
abstract and conclusion.  These rows are summary metadata: they prevent the
paper from changing a high-level "conditional/unconditional" scope claim
without changing the Lean inventory. -/
structure MasterScopeSubclassStatus where
  id : String
  summaryStatus : String
  line : Nat
  masterClaimIds : List String := []
  routeGapIds : List String := []
  leanDecls : List String := []
  notes : String := ""
  deriving Repr, DecidableEq, Inhabited

/-- Complete first-pass index of theorem-like master-tex environments.
This is a triage queue: each item should eventually map to a claim disposition below. -/
def masterEnvironmentIndex : List MasterEnvironment := [
  { line := 507, kind := .conjecture, label := "conj:HC", title := "Hodge Conjecture (HC), Hodge 1950" },
  { line := 530, kind := .hypothesis, label := "hyp:CM-correspondences", title := "Algebraicity of Hom_mathrmmot between rank-2 CM motives of CY_3-type" },
  { line := 536, kind := .theorem, label := "thm:main", title := "Main Theorem" },
  { line := 1010, kind := .theorem, label := "thm:general-variety-reduction", title := "General Variety Reduction" },
  { line := 1146, kind := .proposition, label := "prop:coverage", title := "Mumford--Tate/Cartan coverage table" },
  { line := 1265, kind := .definition, label := "", title := "Hodge locus of alpha" },
  { line := 1276, kind := .theorem, label := "thm:CDK", title := "Cattani--Deligne--Kaplan citeCDK" },
  { line := 1291, kind := .theorem, label := "thm:CMdensity", title := "CM density; classical, cf. Tsimerman citeTsimerman18" },
  { line := 1313, kind := .theorem, label := "thm:DelAH", title := "Deligne citeDeligne_AH, Hodge cycles on AV" },
  { line := 1356, kind := .hypothesis, label := "hyp:HC-CM-Ab", title := "Hodge conjecture for CM abelian varieties" },
  { line := 1379, kind := .theorem, label := "thm:BKT", title := "Bakker--Klingler--Tsimerman citeBKT" },
  { line := 1398, kind := .theorem, label := "thm:PS", title := "Peterzil--Starchenko citePS_Chow" },
  { line := 1406, kind := .theorem, label := "thm:BBT", title := "Bakker--Brunebarbe--Tsimerman citeBBT" },
  { line := 1432, kind := .proposition, label := "prop:coherence-lemma", title := "Coherence lemma, unconditional" },
  { line := 1720, kind := .theorem, label := "thm:HCab", title := "" },
  { line := 1882, kind := .corollary, label := "cor:Ab_covers", title := "" },
  { line := 1919, kind := .theorem, label := "thm:levi-reduction-min3", title := "" },
  { line := 1962, kind := .hypothesis, label := "hyp:KS-p3", title := "(KS-(p,3)) Kuga--Satake at signature (p,3)" },
  { line := 2155, kind := .definition, label := "def:WLH", title := "Witness Lattice Hypothesis (WLH)" },
  { line := 2165, kind := .theorem, label := "thm:KUY", title := "CDK citeCDK; Klingler--Ullmo--Yafaev citeKUY" },
  { line := 2175, kind := .theorem, label := "thm:PrincipleB", title := "Deligne's Principle B, citeDeligne_AH" },
  { line := 2183, kind := .theorem, label := "thm:AHD", title := "AHD procedure" },
  { line := 2624, kind := .theorem, label := "thm:generic_fiber", title := "Generic-fibre invariant theorem" },
  { line := 2726, kind := .theorem, label := "thm:meyer_rank", title := "Meyer rank verification" },
  { line := 2752, kind := .theorem, label := "thm:Meyer", title := "Meyer citeMeyer; Hasse--Minkowski citeMinkowski; input refinput:Meyer" },
  { line := 2757, kind := .corollary, label := "cor:aniso_empty", title := "Anisotropic residue is empty" },
  { line := 2791, kind := .theorem, label := "thm:GLB_full", title := "" },
  { line := 2836, kind := .corollary, label := "cor:Orth_covers", title := "" },
  { line := 2853, kind := .theorem, label := "thm:G2F4", title := "" },
  { line := 2970, kind := .theorem, label := "thm:Satake_abelian_classification", title := "" },
  { line := 3104, kind := .theorem, label := "thm:E6_chernweil", title := "" },
  { line := 3371, kind := .theorem, label := "thm:E7_chernweil", title := "" },
  { line := 3548, kind := .corollary, label := "cor:E7_shimura_closed", title := "" },
  { line := 3675, kind := .theorem, label := "thm:E7_scope", title := "Scope bridge analysis" },
  { line := 3782, kind := .theorem, label := "thm:F-bkt-bbt", title := "BKT + BBT for V_56-period maps" },
  { line := 4036, kind := .lemma, label := "lem:sg19-bilinear-invariants", title := "Bilinear E_7-invariants on V_56" },
  { line := 4169, kind := .theorem, label := "thm:E7_approachF", title := "Approach F total-space construction, non-rigid case" },
  { line := 4420, kind := .lemma, label := "lem:F-natural-V56", title := "Natural V_56-bundle on the relative total space" },
  { line := 4524, kind := .theorem, label := "thm:bundle-matching-unconditional", title := "Bundle matching is unconditional" },
  { line := 4625, kind := .proposition, label := "prop:hbundle-low-dim", title := "Cycle seeding is unconditional in low dimensions" },
  { line := 4703, kind := .proposition, label := "prop:exotic-narrowing", title := "" },
  { line := 5032, kind := .theorem, label := "thm:cy3-e7-nonexistence", title := "CY_3 non-existence with MT = E_7(-25)" },
  { line := 5520, kind := .lemma, label := "lem:sg17-stepA", title := "lambda'inZZ" },
  { line := 5533, kind := .lemma, label := "lem:sg17-stepB", title := "FTS scaling bounds" },
  { line := 5545, kind := .theorem, label := "thm:sg17-partial-kill", title := "SG-17 partial kill" },
  { line := 5589, kind := .proposition, label := "prop:d5-e7-closure", title := "" },
  { line := 5733, kind := .lemma, label := "lem:sg5-b2-b4-conditional", title := "" },
  { line := 5797, kind := .lemma, label := "lem:sg5-hodge-diamond-conditional", title := "" },
  { line := 5941, kind := .corollary, label := "cor:sg5-chi-omega-conditional", title := "" },
  { line := 6006, kind := .corollary, label := "cor:sg5-35to1-reduction", title := "" },
  { line := 6110, kind := .corollary, label := "cor:E7_full_closure", title := "E_7 closure status" },
  { line := 6215, kind := .theorem, label := "thm:E8_vacuous", title := "E_8-MT vacuity" },
  { line := 6246, kind := .corollary, label := "cor:E8_vacuous", title := "" },
  { line := 6255, kind := .proposition, label := "prop:exc_covered", title := "" },
  { line := 7236, kind := .theorem, label := "thm:Voisin_integral", title := "Voisin citeVoisin_integral" },
  { line := 7253, kind := .theorem, label := "thm:DelAH_restated", title := "Deligne citeDeligne_AH" },
  { line := 7280, kind := .theorem, label := "thm:Andre_motivated", title := "Andr'e citeAndre96" },
  { line := 7382, kind := .proposition, label := "prop:lattice-gap", title := "" },
  { line := 7463, kind := .proposition, label := "prop:margulis-conditional", title := "Margulis applies if monodromy is a lattice" },
  { line := 7501, kind := .proposition, label := "prop:mok-conditional", title := "Mok rigidity if monodromy is arithmetic" },
  { line := 7578, kind := .theorem, label := "thm:torelli-evii-verdict", title := "Status of the V--M--M chain toward Torelli-EVII" },
  { line := 7648, kind := .lemma, label := "lem:fibre-density", title := "Fibre density for parabolics" },
  { line := 7695, kind := .proposition, label := "prop:boundary-in-u7", title := "Boundary monodromy in mathfraku_7" },
  { line := 7773, kind := .proposition, label := "prop:w0-flip", title := "w_0-flip: opposite unipotent existence" },
  { line := 7843, kind := .theorem, label := "thm:parabolic-density", title := "Density of parabolic monodromy" },
  { line := 7906, kind := .theorem, label := "thm:e7-arithmeticity", title := "Arithmeticity of E_7-type monodromy" },
  { line := 8256, kind := .hypothesis, label := "hyp:hecke-bbt", title := "(Hecke-BBT-equivariance, extended scope)" },
  { line := 8468, kind := .theorem, label := "thm:subcase3b-vacuous", title := "Sub-case 3b is vacuous" },
  { line := 8728, kind := .corollary, label := "cor:hc-conditional-nonrigid-e7", title := "" },
  { line := 8861, kind := .openQuestion, label := "open:torelli-evii", title := "Torelli-EVII / exotic rigid E_7-type vacuity" },
  { line := 9026, kind := .openQuestion, label := "open:exotic-residual", title := "" },
  { line := 9207, kind := .openQuestion, label := "open:hbundle", title := "H-bundle matching in the non-toroidal-boundary case" },
  { line := 9315, kind := .openQuestion, label := "open:fibre-id", title := "Fibre-level algebraic cycle from the Shimura side" },
  { line := 9393, kind := .definition, label := "def:shimura-type-fibre", title := "Shimura-type fibre" },
  { line := 9464, kind := .proposition, label := "prop:shimura-fibre-density", title := "Density of CM fibres in E_7-type families" },
  { line := 9560, kind := .theorem, label := "thm:SL8-quartic-decomposition", title := "SL(8) decomposition of the Freudenthal quartic" },
  { line := 9622, kind := .proposition, label := "prop:q4-abelian-algebraicity", title := "Algebraicity of q_4 on the abelian-type side" },
  { line := 10113, kind := .proposition, label := "prop:omega-diagonal", title := "Diagonal characterisation of the symplectic class" },
  { line := 10409, kind := .lemma, label := "lem:sg23-andre-closure", title := "SG-23 closure at appendix scope via Andr'e motives" },
  { line := 10472, kind := .lemma, label := "lem:sg18-pi3-chow-conditional", title := "" },
  { line := 10516, kind := .proposition, label := "prop:theta-closure", title := "" },
  { line := 10735, kind := .theorem, label := "thm:E7-modularity", title := "Modularity of the E_7 generating series" },
  { line := 10940, kind := .hypothesis, label := "hyp:chow-modularity-E7", title := "" },
  { line := 11029, kind := .theorem, label := "thm:E7-theta-match", title := "" },
  { line := 11304, kind := .corollary, label := "cor:theta-step-iii", title := "Step (iii): Shimura-side cycle seeding for E_7" },
  { line := 11425, kind := .lemma, label := "lem:CM-E7-algebraicity", title := "Algebraicity at CM fibres of exceptional type" },
  { line := 11584, kind := .hypothesis, label := "hyp:AH-CM-E7", title := "(AH-CM-E7) Absolute Hodge for E_7-type CM fibres" },
  { line := 11613, kind := .hypothesis, label := "hyp:ChernWeil-bridge-E7", title := "" },
  { line := 11814, kind := .hypothesis, label := "hyp:BBT-rigid-reach", title := "(BBT-rigid-reach) BBT spreading reaches rigid isolated points" },
  { line := 11872, kind := .hypothesis, label := "hyp:nonrigid-family-bridge", title := "" },
  { line := 11953, kind := .theorem, label := "thm:E7-BBT-spreading", title := "BBT spreading for E_7-type families" },
  { line := 12348, kind := .proposition, label := "prop:quartic-chern", title := "" },
  { line := 12506, kind := .proposition, label := "prop:deligne-splitting", title := "Shimura-side and base-level algebraicity" },
  { line := 12553, kind := .corollary, label := "cor:quartic-algebraic", title := "Fibre-level algebraicity for E_7-type" },
  { line := 12961, kind := .lemma, label := "lem:sg22-tabuada-nc-no-shortcut", title := "Noncommutative route does not shortcut HC" },
  { line := 13005, kind := .theorem, label := "thm:eigenvalue-separation", title := "" },
  { line := 13110, kind := .lemma, label := "lem:sg14-honda-tate-non-abelian-conditional", title := "" },
  { line := 13159, kind := .theorem, label := "thm:p-adic-descent", title := "" },
  { line := 13293, kind := .lemma, label := "lem:sg20-rho-omega-tate-conditional", title := "" },
  { line := 13532, kind := .proposition, label := "prop:combined-closure", title := "" }
]

def masterEnvironmentCount : Nat :=
  masterEnvironmentIndex.length

/-- The only canonical paper source for the current import pass. -/
def canonicalMasterSource : PaperSource :=
  { id := "master-tex"
    path := "../contributions/hodge-conjecture-master-proof.tex"
    role := .canonicalMaster
    title := "A Mumford--Tate Reduction of the Hodge Conjecture"
    note := "Canonical source for the Lean import.  Other tex files are background unless promoted into this master file." }

/-- Non-canonical source families retained as archive/background. -/
def archivedBackgroundSources : List PaperSource := [
  { id := "attack-map-index"
    path := "../attack-map-index.tex"
    role := .archivedBackground
    title := "Attack map command index"
    note := "Background planning index; not a canonical proof source for import." },
  { id := "attacks"
    path := "../attacks/*.tex"
    role := .archivedBackground
    title := "Primary and secondary attack-path files"
    note := "Exploratory strategy notes; import only after promotion into the master tex." },
  { id := "literature"
    path := "../literature/*.tex"
    role := .archivedBackground
    title := "Literature survey files"
    note := "Reference background; individual citations enter Lean only through master-paper claims." },
  { id := "round-contributions"
    path := "../contributions/r*.tex"
    role := .archivedBackground
    title := "Round contribution files"
    note := "Historical development notes; master tex is the canonical synthesis." },
  { id := "legacy-archive"
    path := "../_archive/**"
    role := .archivedBackground
    title := "Legacy archive"
    note := "Historical material outside the canonical import surface." }
]

/-- All known paper sources for the import policy. -/
def allSources : List PaperSource :=
  canonicalMasterSource :: archivedBackgroundSources

/-- First-pass inventory of the load-bearing master-paper items. -/
def masterClaims : List PaperClaim := [
  { id := "conj:HC"
    sourceId := "master-tex"
    line := 507
    kind := .conjecture
    disposition := .formalized
    title := "Full Hodge conjecture statement"
    leanDecls := [
      "HodgeReduction.HodgeConjectureReal",
      "HodgeReduction.HodgeConjectureRealAt",
      "HodgeReduction.FullHodgeConjectureReal",
      "HodgeReduction.FullHodgeConjectureRealByCodim",
      "HodgeReduction.fullHodgeConjectureReal_iff_byCodim",
      "HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeCoverage",
      "HodgeReduction.currentFullHodgeClosureStatusSnapshot_eq_texStatus",
      "HodgeReduction.currentFullHodgeClosureRouteNames_eq_texStatus",
      "HodgeReduction.CurrentReductionCoversOrSolvesAllSmoothProjective",
      "HodgeReduction.fullHodgeConjectureReal_of_currentScopeOrComplementCoverage",
      "HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeOrComplementCoverage",
      "HodgeReduction.currentFullHodgeScopeOrComplementSnapshot_eq_texStatus",
      "HodgeReduction.currentFullHodgeScopeOrComplementRouteNames_eq_texStatus",
      "HodgeReduction.fullHodgeConjectureReal_from_r612ResidualGate",
      "HodgeReduction.currentR613ResidualGateRouteSnapshot_eq_texStatus"
    ]
    gapIds := ["G-full-hc"]
    notes := "This is the final theorem target, not the canonical E7 milestone." },
  { id := "hyp:CM-correspondences"
    sourceId := "master-tex"
    line := 530
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Algebraicity of Hom_mot between rank-2 CM motives of CY3 type"
    leanDecls := [
      "HodgeReduction.RankTwoCMCY3CorrespondenceData",
      "HodgeReduction.RankTwoCMCY3CorrespondenceData.algebraicity_from_rank_two_cm_cy3_hypothesis",
      "HodgeReduction.blasius_deligne_do_not_self_close_cm_cy3_correspondence"
    ]
    gapIds := ["G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "Kernel records the dependency boundary and a countermodel showing that Blasius critical-value algebraicity plus Deligne absolute-Hodge input do not self-close this codimension-3 CM-CY3 correspondence hypothesis.  The hypothesis remains a genuine new-math input." },
  { id := "thm:main"
    sourceId := "master-tex"
    line := 536
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Main theorem: scoped Mumford-Tate reduction"
    leanDecls := [
      "HodgeReduction.main_reduction_real",
      "HodgeReduction.hodgeConjectureReal_canonical"
    ]
    gapIds := ["G-full-hc", "G-main-hc"]
    notes := "Lean must keep this conditional and scoped; it does not prove FullHodgeConjectureReal." },
  { id := "input:Ran"
    sourceId := "master-tex"
    line := 607
    kind := .input
    disposition := .registeredGap
    title := "BBT coherence verification input"
    leanDecls := [
      "HodgeReduction.RanCoherenceInputData",
      "HodgeReduction.RanCoherenceInputData.input_ran_from_coherence_lemma",
      "HodgeReduction.oka_coherence_does_not_self_close_ran_input"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the BBT/Ran coherence dependency shape and certifies that ordinary Oka coherence alone does not self-close the definable BBT input.  The paper-level proof and external o-minimal/BBT ingredients are still not ported as kernel proofs." },
  { id := "input:Meyer"
    sourceId := "master-tex"
    line := 619
    kind := .input
    disposition := .formalized
    title := "Meyer/Hasse-Minkowski descent verification input"
    leanDecls := ["HodgeReduction.thm_Meyer"]
    notes := "Kernel-side theorem exists, with Mathlib-port debt tracked separately." },
  { id := "input:Hbundle"
    sourceId := "master-tex"
    line := 644
    kind := .input
    disposition := .registeredGap
    title := "H-bundle structural input for E6/E7 type varieties"
    leanDecls := [
      "HodgeReduction.HBundleInputData",
      "HodgeReduction.HBundleInputData.hbundle_input_from_matching_and_cycle_seeding",
      "HodgeReduction.bundle_matching_does_not_self_close_hbundle_input"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The Lean dependency shape now separates the two H-bundle clauses: bundle matching and fibre-level cycle seeding.  A countermodel certifies that bundle matching alone is not the full H-bundle input used downstream." },
  { id := "input:motivic-span"
    sourceId := "master-tex"
    line := 683
    kind := .input
    disposition := .registeredGap
    title := "Motivic span for rigid non-abelian CM sub-case"
    leanDecls := [
      "HodgeReduction.MotivicSpanData",
      "HodgeReduction.MotivicSpanData.rigid_nonabelian_cm_subcase_from_motivic_span",
      "HodgeReduction.cm_correspondence_does_not_self_close_motivic_span"
    ]
    gapIds := ["G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .migrationDebt]
    notes := "Kernel records that the rigid non-abelian CM subcase consumes both the CM-CY3 correspondence input and a separate motivic-span input; the CM correspondence alone does not self-close the span obligation.  This remains scoped import debt, not a full-HC theorem." },
  { id := "thm:general-variety-reduction"
    sourceId := "master-tex"
    line := 1010
    kind := .theorem
    disposition := .conditionalMilestone
    title := "General variety reduction"
    leanDecls := ["HodgeReduction.main_reduction_real"]
    gapIds := ["G-full-hc", "G-main-hc"]
    notes := "This corresponds to the scoped theorem InScope X -> HodgeConjectureReal X." },
  { id := "prop:coverage"
    sourceId := "master-tex"
    line := 1146
    kind := .proposition
    disposition := .registeredGap
    title := "Mumford-Tate/Cartan coverage table"
    leanDecls := ["HodgeReduction.CurrentReductionCoversAllSmoothProjective"]
    gapIds := ["G-full-hc"]
    notes := "Full HC needs universal scope coverage or a route for the complement." },
  { id := "def:hodge-locus-alpha"
    sourceId := "master-tex"
    line := 1265
    kind := .definition
    disposition := .formalized
    title := "Hodge locus of alpha"
    leanDecls := [
      "HodgeReduction.Infrastructure.Cohomology.HodgeLocusData",
      "HodgeReduction.Infrastructure.Cohomology.HodgeLocusData.hodgeLocus"
    ]
    notes := "Lean has an abstract Hodge-locus carrier; geometric period-map instances remain external infrastructure." },
  { id := "thm:CDK"
    sourceId := "master-tex"
    line := 1276
    kind := .theorem
    disposition := .externalCitation
    title := "Cattani-Deligne-Kaplan algebraicity of Hodge loci"
    leanDecls := [
      "HodgeReduction.Infrastructure.Cohomology.HodgeLocusData.hodgeLocus_eq",
      "HodgeReduction.IsCDKLocusOfHodgeClassesAlgebraic"
    ]
    gapIds := ["G-master-paper-import", "G-l4-mt-correspondence"]
    notes := "Encoded as a typeclass field/projection where the downstream E7 framework consumes it; full geometric CDK is still a published-input carrier." },
  { id := "thm:CMdensity"
    sourceId := "master-tex"
    line := 1291
    kind := .theorem
    disposition := .externalCitation
    title := "CM density in special subvarieties"
    leanDecls := [
      "HodgeReduction.CMDensityInputData",
      "HodgeReduction.CMDensityInputData.cm_density_in_special_subvariety_from_tsimerman",
      "HodgeReduction.CMDensityInputData.cm_density_in_hodge_locus_from_special_component",
      "HodgeReduction.specialness_does_not_self_close_cm_density"
    ]
    gapIds := ["G-master-paper-import", "G-l4-cm-abelian-hc"]
    auditTags := [.kernelOnlyLeanCode, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the external Tsimerman/Andre-Oort CM-density input and its Hodge-locus-specialization consumer.  A countermodel records that specialness alone does not self-close CM density; the published theorem remains external-citation import debt." },
  { id := "thm:DelAH"
    sourceId := "master-tex"
    line := 1313
    kind := .theorem
    disposition := .formalized
    title := "Deligne absolute Hodge theorem for abelian varieties"
    leanDecls := [
      "HodgeReduction.absHodgeWitness",
      "HodgeReduction.deligne_absolute_hodge_abelian",
      "HodgeReduction.deligne_1982_abs_hodge_cm"
    ]
    gapIds := ["G-l4-cm-abelian-hc"]
    notes := "Formalized only as absolute-Hodge, not algebraicity; HC for CM abelian varieties remains separate." },
  { id := "hyp:HC-CM-Ab"
    sourceId := "master-tex"
    line := 1356
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Hodge conjecture for CM abelian varieties"
    leanDecls := ["HodgeReduction.hyp_HC_CM_Ab_real"]
    gapIds := ["G-l4-cm-abelian-hc"]
    notes := "Codimension-one is bypassed by Lefschetz (1,1); higher codimension remains open." },
  { id := "thm:BKT"
    sourceId := "master-tex"
    line := 1379
    kind := .theorem
    disposition := .externalCitation
    title := "Bakker-Klingler-Tsimerman period-map definability and Hodge loci"
    leanDecls := [
      "HodgeReduction.IsBBTBKTPeriodMapDefinable",
      "HodgeReduction.IsBKTHeckeCorrespondencesDefinable_E7Minus25"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "The E7-specific framework records the consumed BKT-style facts; the general theorem remains an external citation." },
  { id := "thm:PS"
    sourceId := "master-tex"
    line := 1398
    kind := .theorem
    disposition := .externalCitation
    title := "Peterzil-Starchenko definable analytic algebraization"
    leanDecls := [
      "HodgeReduction.PeterzilStarchenkoInputData",
      "HodgeReduction.PeterzilStarchenkoInputData.definable_closed_analytic_subset_is_algebraic",
      "HodgeReduction.definable_analytic_set_does_not_self_close_algebraicity"
    ]
    gapIds := ["G-master-paper-import"]
    auditTags := [.kernelOnlyLeanCode, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the Peterzil-Starchenko algebraization theorem as an external input carrier and certifies that definable analytic closedness alone is not a kernel proof of algebraicity." },
  { id := "thm:BBT"
    sourceId := "master-tex"
    line := 1406
    kind := .theorem
    disposition := .externalCitation
    title := "Bakker-Brunebarbe-Tsimerman definable GAGA"
    leanDecls := ["HodgeReduction.IsBBTPeriodImageQuasiProjective_E7Minus25"]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Recorded where the E7 Hecke-BBT route consumes it; the generic definable-GAGA theorem is still an external citation." },
  { id := "prop:coherence-lemma"
    sourceId := "master-tex"
    line := 1432
    kind := .proposition
    disposition := .registeredGap
    title := "Definable ideal-sheaf coherence lemma"
    leanDecls := [
      "HodgeReduction.RanCoherenceInputData",
      "HodgeReduction.RanCoherenceInputData.coherence_lemma_from_oka_and_bbt_definable_oka",
      "HodgeReduction.RanCoherenceInputData.input_ran_from_coherence_lemma",
      "HodgeReduction.oka_coherence_does_not_self_close_ran_input"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the manuscript's three-route coherence shape through a status carrier.  The carrier is kernel-only, but Oka/BBT/o-minimal definable coherence itself remains paper-proof and external-citation import debt rather than a Mathlib theorem." },
  { id := "thm:HCab"
    sourceId := "master-tex"
    line := 1720
    kind := .theorem
    disposition := .conditionalMilestone
    title := "HC/Ab integrated version conditional on HC for CM abelian varieties"
    leanDecls := ["HodgeReduction.hyp_HC_CM_Ab_real"]
    gapIds := ["G-l4-cm-abelian-hc", "G-master-paper-import"]
    notes := "This theorem is conditional on hyp:HC-CM-Ab plus the coherence machinery; do not record it as unconditional HC/Ab." },
  { id := "cor:Ab_covers"
    sourceId := "master-tex"
    line := 1882
    kind := .corollary
    disposition := .conditionalMilestone
    title := "Abelian-type coverage modulo HC for CM abelian varieties"
    leanDecls := [
      "HodgeReduction.AbelianTypeCoverageData",
      "HodgeReduction.AbelianTypeCoverageData.abelian_type_coverage_from_hc_cm_and_ran",
      "HodgeReduction.hc_cm_abelian_does_not_self_close_abelian_type_coverage"
    ]
    gapIds := ["G-main-hc", "G-l4-cm-abelian-hc", "G-master-paper-import"]
    auditTags := [
      .kernelOnlyLeanCode,
      .conditionalLeanPackage,
      .paperProofNotKernelPorted,
      .externalCitationNotKernelPorted,
      .migrationDebt
    ]
    notes := "Kernel records the dependency composition: HC for CM abelian varieties plus the Ran/coherence and BKT/PS/BBT algebraisation package plus the Hermitian spin bridge.  HC/CM-Ab alone does not self-close this coverage corollary." },
  { id := "hyp:KS-p3"
    sourceId := "master-tex"
    line := 1962
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Kuga-Satake at signature (p,3)"
    leanDecls := [
      "HodgeReduction.KugaSatakeP3Data",
      "HodgeReduction.KugaSatakeP3Data.ks_p3_from_spin_hodge_and_correspondence",
      "HodgeReduction.spin_abs_periodicity_does_not_self_close_ks_p3"
    ]
    gapIds := ["G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "Kernel records the load-bearing clauses: weight-one Hodge homomorphism on Cliff^+, polarization compatibility, and algebraic correspondence realization.  Spin embedding plus ABS periodicity does not self-close KS-(p,3); the hypothesis remains a genuine new-math input." },
  { id := "thm:levi-reduction-min3"
    sourceId := "master-tex"
    line := 1919
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Levi reduction for the min(p,q)=3 orthogonal stratum"
    leanDecls := [
      "HodgeReduction.Infrastructure.AbelianVariety.KugaSatake.KugaSatakeData"
    ]
    gapIds := ["G-main-hc", "G-master-paper-import"]
    notes := "Conditional on hyp:KS-p3.  The current Lean code has Kuga-Satake infrastructure, but no exact kernel theorem for this p,3 Levi reduction." },
  { id := "def:WLH"
    sourceId := "master-tex"
    line := 2155
    kind := .definition
    disposition := .formalized
    title := "Witness Lattice Hypothesis"
    leanDecls := [
      "HodgeReduction.WitnessLatticeHypothesis",
      "HodgeReduction.WitnessLatticeHypothesis.two_le_q",
      "HodgeReduction.WitnessLatticeHypothesis.orthogonalComplement_signature_eq_p_two"
    ]
    gapIds := ["G-main-hc"]
    notes := "The master-paper definition is now represented by an abstract Lean carrier, with a kernel-checked proof that signature additivity gives the orthogonal complement signature `(p, 2)`.  This does not assert that the required witness lattice exists for every form; the AHD/theorem-consuming route remains conditional where it uses WLH." },
  { id := "thm:KUY"
    sourceId := "master-tex"
    line := 2165
    kind := .theorem
    disposition := .externalCitation
    title := "CDK/Klingler-Ullmo-Yafaev drop-locus and CM density input"
    leanDecls := ["HodgeReduction.IsCDKLocusOfHodgeClassesAlgebraic"]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "The algebraic Hodge-locus carrier exists, but the KUY density/drop-locus theorem is still an external published input, not a Lean theorem." },
  { id := "thm:PrincipleB"
    sourceId := "master-tex"
    line := 2175
    kind := .theorem
    disposition := .externalCitation
    title := "Deligne Principle B for absolute Hodge classes"
    leanDecls := [
      "HodgeReduction.absHodgeWitness",
      "HodgeReduction.deligne_absolute_hodge_abelian"
    ]
    gapIds := ["G-master-paper-import", "G-l4-cm-abelian-hc"]
    notes := "Lean has absolute-Hodge carriers and Deligne abelian input, but not the full family-level Principle B theorem." },
  { id := "thm:AHD"
    sourceId := "master-tex"
    line := 2183
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Absolute Hodge Descent procedure for non-Hermitian orthogonal type"
    leanDecls := [
      "HodgeReduction.AbsoluteHodgeDescentData",
      "HodgeReduction.AbsoluteHodgeDescentData.ahd_from_wlh_hodge_locus_principleB_and_hcab",
      "HodgeReduction.hc_ab_and_hodge_locus_do_not_self_close_ahd"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-cm-abelian-hc"]
    auditTags := [
      .kernelOnlyLeanCode,
      .conditionalLeanPackage,
      .paperProofNotKernelPorted,
      .externalCitationNotKernelPorted,
      .migrationDebt
    ]
    notes := "Kernel records the full dependency package: WLH, Hodge-locus algebraicity, Principle B, BBT spreading/definable GAGA, Witt iteration, and HC/Ab.  HC/Ab plus Hodge-locus algebraicity alone does not self-close AHD; the geometric theorem is still paper-proof/external-citation debt." },
  { id := "thm:generic_fiber"
    sourceId := "master-tex"
    line := 2624
    kind := .theorem
    disposition := .registeredGap
    title := "Generic-fibre invariant theorem"
    leanDecls := [
      "HodgeReduction.GenericFibreInvariantData",
      "HodgeReduction.GenericFibreInvariantData.generic_fibre_invariant_from_full_package",
      "HodgeReduction.invariant_theory_and_chern_classes_do_not_self_close_generic_fibre"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the invariant-theory/Hodge-bundle dependency shape and certifies that the off-middle vanishing, Euler-generation, and Chern-class algebraicity pieces do not self-close the theorem without the Griffiths-Schmid normalisation input.  The geometric theorem remains paper-proof/external-citation import debt." },
  { id := "thm:meyer_rank"
    sourceId := "master-tex"
    line := 2726
    kind := .theorem
    disposition := .registeredGap
    title := "Meyer rank verification for orthogonal MT factors"
    leanDecls := [
      "HodgeReduction.meyer_hasse_minkowski",
      "HodgeReduction.thm_Meyer",
      "HodgeReduction.HCGapL4.FrontC12_ClassicalCartanDerivation.step1_meyer_applies"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port"]
    notes := "The classical Meyer theorem is formalized, but the exact smooth-projective MT-factor rank verification is not yet an exact Lean theorem." },
  { id := "thm:Meyer"
    sourceId := "master-tex"
    line := 2752
    kind := .theorem
    disposition := .formalized
    title := "Meyer rank verification"
    leanDecls := ["HodgeReduction.thm_Meyer"]
    notes := "Classical verification input already represented by a Lean theorem." },
  { id := "cor:aniso_empty"
    sourceId := "master-tex"
    line := 2757
    kind := .corollary
    disposition := .registeredGap
    title := "Anisotropic residue is empty"
    leanDecls := [
      "HodgeReduction.thm_Meyer",
      "HodgeReduction.min_signature_ge_four_forces_meyer_hypotheses",
      "HodgeReduction.aniso_empty_isotropic_core"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port"]
    notes := "The Meyer/isotropy core is now kernel-checked: min(p,q)>=4 gives Q-isotropic.  The full corollary remains registered because the WLH witness-lattice conclusion still needs an exact Witt-cancellation iteration rather than only the first isotropic vector." },
  { id := "thm:GLB_full"
    sourceId := "master-tex"
    line := 2791
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Integrated GLB/Orth closure"
    leanDecls := [
      "HodgeReduction.GLBOrthClosureData",
      "HodgeReduction.GLBOrthClosureData.glb_orth_from_meyer_ahd_ks_and_hcab",
      "HodgeReduction.meyer_input_does_not_self_close_glb_orth"
    ]
    gapIds := ["G-main-hc", "G-master-paper-import", "G-l4-cm-abelian-hc"]
    auditTags := [
      .kernelOnlyLeanCode,
      .conditionalLeanPackage,
      .paperProofNotKernelPorted,
      .externalCitationNotKernelPorted,
      .migrationDebt
    ]
    notes := "Kernel records the integrated case split through Meyer/aniso-empty, AHD, KS-(p,3), and HC/Ab.  Meyer input alone does not self-close GLB/Orth; the integrated theorem is still paper-proof/external-citation debt." },
  { id := "cor:Orth_covers"
    sourceId := "master-tex"
    line := 2836
    kind := .corollary
    disposition := .conditionalMilestone
    title := "Orthogonal input coverage for the general reduction"
    leanDecls := [
      "HodgeReduction.GLBOrthClosureData",
      "HodgeReduction.GLBOrthClosureData.orthogonal_coverage_from_glb_orth",
      "HodgeReduction.meyer_input_does_not_self_close_glb_orth"
    ]
    gapIds := ["G-main-hc", "G-master-paper-import", "G-l4-cm-abelian-hc"]
    auditTags := [
      .kernelOnlyLeanCode,
      .conditionalLeanPackage,
      .paperProofNotKernelPorted,
      .externalCitationNotKernelPorted,
      .migrationDebt
    ]
    notes := "Kernel records the coverage corollary as downstream of integrated GLB/Orth.  It remains conditional import debt until the GLB/Orth package is formalized beyond the status carrier." },
  { id := "thm:G2F4"
    sourceId := "master-tex"
    line := 2853
    kind := .theorem
    disposition := .formalized
    title := "Kostant-mark vacuity for G2 and F4"
    leanDecls := [
      "HodgeReduction.kostant_vacuity_G2",
      "HodgeReduction.kostant_vacuity_F4",
      "HodgeReduction.thm_G2F4"
    ]
    notes := "Kernel theorem exists in MainTheorem.lean." },
  { id := "thm:Satake_abelian_classification"
    sourceId := "master-tex"
    line := 2970
    kind := .theorem
    disposition := .externalCitation
    title := "Satake-Milne classification of abelian-type Hermitian domains"
    leanDecls := [
      "HodgeReduction.SatakeAbelianClassificationData",
      "HodgeReduction.SatakeAbelianClassificationData.exceptional_eiii_evii_not_abelian_type",
      "HodgeReduction.exceptional_label_does_not_self_close_satake_classification"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the consumed Satake-Milne criterion and the EIII/EVII non-abelian-type conclusion as a kernel status carrier; a countermodel certifies that merely naming the exceptional domains is not a kernel proof of the criterion.  The classical classification remains external-citation import debt." },
  { id := "thm:E6_chernweil"
    sourceId := "master-tex"
    line := 3104
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Chern-Weil closure on S_E6 under weight-parity vacuity"
    leanDecls := [
      "HodgeReduction.hc_real_e6_case",
      "HodgeReduction.HCGapL4.E6CaseClassicalBridge.e6_factor_classical_transfer",
      "HodgeReduction.HCGapL4.E6CaseClassicalBridge.e6_classical_remainder_exists",
      "HodgeReduction.HCGapL4.E6CaseClassicalBridge.e6_remainder_transfer"
    ]
    gapIds := ["G-main-hc", "G-master-paper-import", "G-classical-mathlib-port"]
    notes := "The E6 branch has a Lean theorem-level route, but the exact S_E6 Chern-Weil theorem is represented only through the E6 case bridge and classical-remainder cuts." },
  { id := "thm:E7_chernweil"
    sourceId := "master-tex"
    line := 3371
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Chern-Weil closure on S_E7 under the E7 bridge"
    leanDecls := [
      "HodgeReduction.E7ChernWeilBridgeData",
      "HodgeReduction.E7ChernWeilBridgeData.compact_dual_nonzero_from_schwarz_bridge",
      "HodgeReduction.E7ChernWeilBridgeData.toroidal_class_from_matsushima_descent",
      "HodgeReduction.E7ChernWeilBridgeData.algebraicity_from_chern_polynomial_identity",
      "HodgeReduction.E7ChernWeilBridgeData.e7_chern_weil_algebraicity_from_full_bridge",
      "HodgeReduction.schwarz_invariant_ring_does_not_self_close_e7_chern_weil",
      "HodgeReduction.cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [
      .kernelOnlyLeanCode,
      .conditionalLeanPackage,
      .paperProofNotKernelPorted,
      .externalCitationNotKernelPorted,
      .migrationDebt
    ]
    notes := "The Lean side records only the conditional dependency composition for the E7 Chern-Weil route, plus countermodels showing that Schwarz invariants or cocompact Matsushima alone do not self-close the non-cocompact E7 conclusion.  The theorem still depends on hyp:ChernWeil-bridge-E7 and is not an unconditional closure." },
  { id := "cor:E7_shimura_closed"
    sourceId := "master-tex"
    line := 3548
    kind := .corollary
    disposition := .conditionalMilestone
    title := "E7 Shimura-side invariant Hodge classes are algebraic under the bridge"
    leanDecls := ["HodgeReduction.hodgeConjectureReal_canonical"]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence", "G-master-paper-import"]
    notes := "The old exact corollary declaration was deleted after a Unit-placeholder audit; the current Lean anchor is the canonical E7 theorem, not this corollary as a standalone theorem." },
  { id := "rem:E7-chernweil-tautology"
    sourceId := "master-tex"
    line := 3556
    kind := .remark
    disposition := .registeredGap
    title := "Honest content of E7 Chern-Weil theorem modulo the bridge"
    leanDecls := [
      "HodgeReduction.E7ChernWeilBridgeData",
      "HodgeReduction.E7ChernWeilBridgeData.algebraicity_from_chern_polynomial_identity",
      "HodgeReduction.E7ChernWeilBridgeData.e7_chern_weil_algebraicity_from_full_bridge"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .migrationDebt]
    notes := "Kernel records the tautological dependency: once the toroidal class and Chern-polynomial identity clause of the bridge are supplied, the algebraicity conclusion follows.  The actual polynomial identity remains paper-proof/kernel-port debt." },
  { id := "rem:borel-matsushima"
    sourceId := "master-tex"
    line := 3587
    kind := .remark
    disposition := .externalCitation
    title := "Borel-Matsushima chain for invariant cohomology"
    leanDecls := [
      "HodgeReduction.E7ChernWeilBridgeData",
      "HodgeReduction.E7ChernWeilBridgeData.toroidal_class_from_matsushima_descent",
      "HodgeReduction.cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil"
    ]
    gapIds := ["G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Kernel records the dependency boundary: compact-dual/Matsushima descent reaches the toroidal class only after non-cocompact boundary compatibility is supplied.  The cited Borel-Matsushima chain remains external citation debt for the Lean kernel." },
  { id := "thm:E7_scope"
    sourceId := "master-tex"
    line := 3675
    kind := .theorem
    disposition := .registeredGap
    title := "E7 scope bridge analysis"
    leanDecls := [
      "HodgeReduction.InKnownE7Scope",
      "HodgeReduction.mt_correspondence_e7_reduction",
      "HodgeReduction.hc_real_e7_case"
    ]
    gapIds := ["G-full-hc", "G-main-hc", "G-master-paper-import"]
    notes := "The analysis explicitly leaves the dim>=5 exotic non-CY3 residual open; the Lean side has scoped E7 assumptions, not a full scope theorem." },
  { id := "thm:F-bkt-bbt"
    sourceId := "master-tex"
    line := 3782
    kind := .theorem
    disposition := .externalCitation
    title := "BKT and BBT for V56 period maps"
    leanDecls := [
      "HodgeReduction.IsBBTBKTPeriodMapDefinable",
      "HodgeReduction.IsBKTHeckeCorrespondencesDefinable_E7Minus25",
      "HodgeReduction.IsBBTPeriodImageQuasiProjective_E7Minus25"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    notes := "The E7 framework has predicate carriers for the BKT/BBT inputs; the full V56 period-map theorem remains an external citation." },
  { id := "lem:sg19-bilinear-invariants"
    sourceId := "master-tex"
    line := 4036
    kind := .lemma
    disposition := .externalCitation
    title := "Bilinear E7-invariants on V56"
    leanDecls := [
      "HodgeReduction.Infrastructure.omega",
      "HodgeReduction.Infrastructure.omega_antisymm",
      "HodgeReduction.Infrastructure.omega_nondegenerate",
      "HodgeReduction.IsSchwarzE7QuarticGenerator"
    ]
    gapIds := ["G-master-paper-import", "G-l3-v56-mt-identification"]
    notes := "Lean has the Freudenthal symplectic infrastructure and Schwarz-quartic carrier, but not the exact representation-theory lemma about Sym^2/Lambda^2 invariant dimensions." },
  { id := "thm:E7_approachF"
    sourceId := "master-tex"
    line := 4169
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Approach F total-space construction"
    leanDecls := [
      "HodgeReduction.E7ApproachFTotalSpaceData",
      "HodgeReduction.E7ApproachFTotalSpaceData.total_space_class_from_chern_weil_bridge",
      "HodgeReduction.approach_f_total_space_does_not_self_close_fibre_level_class"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence", "G-master-paper-import"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "Lean now records the exact warning in the theorem: Approach F constructs a total-space pullback class from the Chern-Weil/non-rigid-family package, but that total-space class does not self-close the fibre-level algebraicity needed for the original variety." },
  { id := "lem:F-natural-V56"
    sourceId := "master-tex"
    line := 4420
    kind := .lemma
    disposition := .registeredGap
    title := "Natural V56 bundle on the relative total space"
    leanDecls := [
      "HodgeReduction.Infrastructure.HodgeStructure.V56Instance.instPureHodgeStructure_V56"
    ]
    gapIds := ["G-master-paper-import", "G-l3-v56-mt-identification", "G-l4-mt-correspondence"]
    notes := "The V56 Hodge structure is formalized, but the family-level automorphic-bundle matching lemma is not an exact Lean theorem." },
  { id := "thm:bundle-matching-unconditional"
    sourceId := "master-tex"
    line := 4524
    kind := .theorem
    disposition := .registeredGap
    title := "Bundle matching is unconditional"
    leanDecls := [
      "HodgeReduction.HBundleMatchingData",
      "HodgeReduction.HBundleMatchingData.bundle_matching_from_rigid_point_case",
      "HodgeReduction.HBundleMatchingData.bundle_matching_from_toroidal_reduction_package",
      "HodgeReduction.known_hbundle_cases_do_not_self_close_arbitrary_nontoroidal_boundary"
    ]
    gapIds := ["G-master-paper-import", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "The Lean side records the proof dependency shape: rigid point cases are direct, while non-rigid cases route through quasi-unipotent base change, semistable/toroidal reduction, moderate-growth uniqueness, and descent.  Those AMRT/KKMS/Schmid/Deligne ingredients are not kernel-ported." },
  { id := "prop:hbundle-low-dim"
    sourceId := "master-tex"
    line := 4625
    kind := .proposition
    disposition := .registeredGap
    title := "Cycle seeding is unconditional in low dimensions"
    leanDecls := [
      "HodgeReduction.HBundleCycleSeedingData",
      "HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_low_dimensional_lefschetz",
      "HodgeReduction.low_dimensional_hbundle_does_not_self_close_high_dimensional_residual"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "The Lean side records the low-dimensional Lefschetz/Poincare-duality consumer and a non-closure certificate: this branch does not close the high-dimensional exotic residual." },
  { id := "prop:exotic-narrowing"
    sourceId := "master-tex"
    line := 4703
    kind := .proposition
    disposition := .registeredGap
    title := "Geometric narrowing of the exotic E7 residual"
    leanDecls := [
      "HodgeReduction.ExoticE7NarrowingData",
      "HodgeReduction.ExoticE7NarrowingData.exotic_residual_narrowed_from_geometric_eliminations",
      "HodgeReduction.exotic_narrowing_does_not_self_close_residual"
    ]
    gapIds := ["G-full-hc", "G-main-hc", "G-master-paper-import"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .newMathGap, .migrationDebt]
    notes := "The Lean dependency shape now records the geometric narrowing separately from residual elimination.  A countermodel certifies that narrowing the high-dimensional exotic E7 residual does not self-close the residual." },
  { id := "thm:cy3-e7-nonexistence"
    sourceId := "master-tex"
    line := 5032
    kind := .theorem
    disposition := .formalized
    title := "CY3 non-existence with MT = E7(-25)"
    leanDecls := ["HodgeReduction.thm_cy3_e7_nonexistence"]
    gapIds := ["G-classical-mathlib-port"]
    notes := "Lean theorem exists but still consumes the paper-stage axiom package listed in the audit." },
  { id := "lem:sg17-stepA"
    sourceId := "master-tex"
    line := 5520
    kind := .lemma
    disposition := .registeredGap
    title := "SG17 lambda prime integrality step"
    leanDecls := [
      "HodgeReduction.IsPartialKill3CoprimeLambdaPrime_sg17",
      "HodgeReduction.li_2026_partial_kill_3_coprime_lambda_prime_sg17"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Recorded inside the SG17 partial-kill carrier; no standalone kernel theorem for the integrally-closed lambda-prime step has been found." },
  { id := "lem:sg17-stepB"
    sourceId := "master-tex"
    line := 5533
    kind := .lemma
    disposition := .registeredGap
    title := "SG17 FTS scaling bounds"
    leanDecls := [
      "HodgeReduction.IsPartialKill3CoprimeLambdaPrime_sg17",
      "HodgeReduction.li_2026_partial_kill_3_coprime_lambda_prime_sg17"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Recorded inside the SG17 partial-kill carrier; no standalone kernel theorem for the q4-integrality scaling bounds has been found." },
  { id := "thm:sg17-partial-kill"
    sourceId := "master-tex"
    line := 5545
    kind := .theorem
    disposition := .conditionalMilestone
    title := "SG17 partial kill of the 3-coprime lambda-prime stratum"
    leanDecls := [
      "HodgeReduction.IsPartialKill3CoprimeLambdaPrime_sg17",
      "HodgeReduction.IsResidual3DivLambdaPrimeClosure_sg17_CONJECTURAL",
      "HodgeReduction.li_2026_partial_kill_3_coprime_lambda_prime_sg17",
      "HodgeReduction.integral_hard_lefschetz_or_chern_weil_bound_or_cm_rigidity_sg17_CONJECTURAL",
      "HodgeReduction.sg17_from_framework_and_extension",
      "HodgeReduction.sg_17_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    notes := "The paper proves only the 3-coprime partial kill; the 3-divisible lambda-prime residual is an explicit conjectural extension, so this is not a full E7 or full-HC closure." },
  { id := "prop:d5-e7-closure"
    sourceId := "master-tex"
    line := 5589
    kind := .proposition
    disposition := .openResidual
    title := "D5 E7 universal sub-pencil sign failure"
    leanDecls := [
      "HodgeReduction.d5_e7_general_type_blocked_conditional",
      "HodgeReduction.d5_e7_general_type_blocked_via_non_p1_only",
      "HodgeReduction.IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    notes := "The master proposition is diagnostic and explicitly labels the d=5 exotic non-Shimura branch OPEN; Lean keeps only conditional obstruction bridges plus the remaining non-P1-family broken link." },
  { id := "lem:sg5-b2-b4-conditional"
    sourceId := "master-tex"
    line := 5733
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG5 Betti pinning under Assumption chi-b"
    leanDecls := [
      "HodgeReduction.IsMinimalMTAnsatzAssumptionChiB_sg5",
      "HodgeReduction.IsHardLefschetzRationalForBettiPinning_sg5",
      "HodgeReduction.IsHodgeNumerologyPicZHsg5",
      "HodgeReduction.IsPDArithmeticUnderAssumptionChiB_sg5",
      "HodgeReduction.sg5_from_antecedent_framework_and_computation",
      "HodgeReduction.sg_5_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Conditional computation under Assumption chi-b; useful for the d=5 diagnostic but not an unconditional theorem in the main HC chain." },
  { id := "lem:sg5-hodge-diamond-conditional"
    sourceId := "master-tex"
    line := 5797
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG5 Hodge diamond under Assumption chi-b"
    leanDecls := [
      "HodgeReduction.HodgeDiamondPinnedSG5d5e7",
      "HodgeReduction.sg5_hodge_diamond_from_chi_b_and_five_atoms",
      "HodgeReduction.sg_5_hodge_diamond_pinned"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Conditional strengthening of SG5 from Betti totals to the full Hodge diamond; it still depends on Assumption chi-b." },
  { id := "cor:sg5-chi-omega-conditional"
    sourceId := "master-tex"
    line := 5941
    kind := .corollary
    disposition := .conditionalMilestone
    title := "SG5 holomorphic Euler characteristics under Assumption chi-b"
    leanDecls := [
      "HodgeReduction.ChiOmegaPinnedSG5d5e7",
      "HodgeReduction.chi_omega_from_hodge_diamond_sg5",
      "HodgeReduction.sg_5_chi_omega_pinned"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Direct conditional corollary of the SG5 Hodge-diamond pin." },
  { id := "cor:sg5-35to1-reduction"
    sourceId := "master-tex"
    line := 6006
    kind := .corollary
    disposition := .conditionalMilestone
    title := "SG5 Lefschetz-pin residual reduction from 35 candidates to 1"
    leanDecls := [
      "HodgeReduction.LefschetzPin35to1ReductionSG5d5e7",
      "HodgeReduction.lefschetz_pin_35to1_from_chi_omega_sg5",
      "HodgeReduction.sg_5_lefschetz_pin_35to1_reduction"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Narrows the d=5 residual under Assumption chi-b; the surviving candidate is not eliminated, so this is explicitly not a closure." },
  { id := "cor:E7_full_closure"
    sourceId := "master-tex"
    line := 6110
    kind := .corollary
    disposition := .openResidual
    title := "E7 closure status with dim>=5 exotic residual open"
    leanDecls := [
      "HodgeReduction.hc_real_e7_shimura",
      "HodgeReduction.thm_cy3_e7_nonexistence",
      "HodgeReduction.thm_subcase3b_vacuous",
      "HodgeReduction.d5_e7_general_type_blocked_via_non_p1_only"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    notes := "The corollary is a status record, not a full closure theorem: known rigid/non-rigid and CY3-reducible parts are covered under their hypotheses, while the dim=5, dim=6, and dim>=7 exotic c1!=0 residual sub-branches remain open." },
  { id := "thm:E8_vacuous"
    sourceId := "master-tex"
    line := 6215
    kind := .theorem
    disposition := .formalized
    title := "E8 Mumford-Tate vacuity"
    leanDecls := ["HodgeReduction.thm_E8_vacuous"]
    notes := "Classical exceptional-type vacuity route is represented in Lean." },
  { id := "cor:E8_vacuous"
    sourceId := "master-tex"
    line := 6246
    kind := .corollary
    disposition := .formalized
    title := "E8 exceptional-type HC branch is vacuous"
    leanDecls := ["HodgeReduction.thm_E8_vacuous"]
    notes := "The corollary is the HC-programme restatement of the kernel-side E8 Mumford-Tate vacuity theorem." },
  { id := "prop:exc_covered"
    sourceId := "master-tex"
    line := 6255
    kind := .proposition
    disposition := .conditionalMilestone
    title := "Exceptional-type coverage summary"
    leanDecls := [
      "HodgeReduction.thm_G2F4",
      "HodgeReduction.thm_E8_vacuous",
      "HodgeReduction.hc_real_e6_case",
      "HodgeReduction.hc_real_e7_shimura",
      "HodgeReduction.thm_cy3_e7_nonexistence",
      "HodgeReduction.thm_subcase3b_vacuous"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    notes := "Exceptional coverage is mixed: G2/F4/E8 are formalized vacuity theorems, E6/E7 consume scoped bridge hypotheses, and the dim>=5 exotic E7 c1!=0 residual remains open." },
  { id := "thm:Voisin_integral"
    sourceId := "master-tex"
    line := 7236
    kind := .theorem
    disposition := .externalCitation
    title := "Voisin counterexamples to integral Hodge conjecture"
    leanDecls := [
      "HodgeReduction.VoisinIntegralCounterexampleData",
      "HodgeReduction.VoisinIntegralCounterexampleData.integral_hodge_counterexample_from_voisin",
      "HodgeReduction.VoisinIntegralCounterexampleData.voisin_integral_failure_does_not_contradict_rational_target",
      "HodgeReduction.integral_hc_failure_alone_does_not_self_close_rational_scope"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port"]
    auditTags := [.kernelOnlyLeanCode, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records Voisin's result as an integral-HC external theorem and separately records the scope delimiter that integral failure does not itself decide the rational HC target.  The literature theorem is not kernel-ported." },
  { id := "thm:DelAH_restated"
    sourceId := "master-tex"
    line := 7253
    kind := .theorem
    disposition := .formalized
    title := "Deligne absolute Hodge theorem for abelian varieties, restated"
    leanDecls := [
      "HodgeReduction.absHodgeWitness",
      "HodgeReduction.deligne_1982_LNM_900_absolute_hodge_abelian_framework",
      "HodgeReduction.deligne_absolute_hodge_abelian"
    ]
    gapIds := ["G-l4-cm-abelian-hc"]
    notes := "This restates the earlier Deligne absolute-Hodge input; Lean represents absolute-Hodge, while AH-to-algebraic for CM abelian varieties remains a separate open bridge." },
  { id := "thm:Andre_motivated"
    sourceId := "master-tex"
    line := 7280
    kind := .theorem
    disposition := .formalized
    title := "Andre motivated cycles on abelian Tannakian span"
    leanDecls := [
      "HodgeReduction.IsAndre1996MotivatedAbelianSpan",
      "HodgeReduction.andre_1996_motivated_motives_abelian_span"
    ]
    gapIds := ["G-master-paper-import", "G-l4-cm-abelian-hc"]
    notes := "Lean has the Andre motivated-abelian-span carrier and witness as structure-field projections; it does not turn motivated cycles into a general HC proof outside the scoped bridge." },
  { id := "prop:lattice-gap"
    sourceId := "master-tex"
    line := 7382
    kind := .proposition
    disposition := .formalized
    title := "Monodromy image need not be a lattice from containment alone"
    leanDecls := [
      "HodgeReduction.MonodromyLatticeContainmentData",
      "HodgeReduction.monodromy_lattice_gap_countermodel",
      "HodgeReduction.containment_in_arithmetic_lattice_does_not_force_finite_covolume"
    ]
    gapIds := ["G-main-hc"]
    notes := "The diagnostic non-implication is formalized by an abstract countermodel: containment in an ambient arithmetic lattice plus finite covolume of the ambient lattice does not logically force finite covolume of the monodromy image.  This is not a negative theorem about the actual E7 monodromy representation; it only records why the V-M-M chain needs an arithmeticity input." },
  { id := "prop:margulis-conditional"
    sourceId := "master-tex"
    line := 7463
    kind := .proposition
    disposition := .externalCitation
    title := "Margulis applies if E7 monodromy is a lattice"
    leanDecls := [
      "HodgeReduction.MargulisConditionalData",
      "HodgeReduction.MargulisConditionalData.arithmeticity_if_monodromy_is_lattice",
      "HodgeReduction.MargulisConditionalData.representation_extension_if_monodromy_is_lattice",
      "HodgeReduction.margulis_rank_inputs_do_not_self_close_without_lattice_hypothesis"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port"]
    auditTags := [.kernelOnlyLeanCode, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the Margulis step as conditional on the monodromy image already being a lattice, with a countermodel certifying that rank and Margulis theorem availability do not self-close the missing lattice hypothesis.  The Lie-group theorem remains external-citation import debt." },
  { id := "prop:mok-conditional"
    sourceId := "master-tex"
    line := 7501
    kind := .proposition
    disposition := .registeredGap
    title := "Mok rigidity conditional and circular for Torelli-EVII"
    leanDecls := [
      "HodgeReduction.MokTorelliConditionalShape",
      "HodgeReduction.mok_conditional_does_not_self_close_torelli",
      "HodgeReduction.mok_conditional_closes_with_uniformisation"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .migrationDebt]
    notes := "The logical non-closure certificate is kernel-checked: a Mok-style conditional `EVII uniformisation -> Torelli-EVII` does not by itself produce Torelli-EVII.  The entry remains registered because the actual Mok/Baily-Borel/BKT analytic geometry theorem is not ported to Lean." },
  { id := "thm:torelli-evii-verdict"
    sourceId := "master-tex"
    line := 7578
    kind := .theorem
    disposition := .registeredGap
    title := "V-M-M chain status toward Torelli-EVII"
    leanDecls := [
      "HodgeReduction.MokTorelliConditionalShape",
      "HodgeReduction.mok_conditional_does_not_self_close_torelli"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The Step-3 circularity core is kernel-checked as a logical non-implication.  The full status theorem remains registered because Step 1 arithmeticity, Step 2 Margulis, and the irreducible-residual identification are not all present as exact Lean theorem dependencies." },
  { id := "lem:fibre-density"
    sourceId := "master-tex"
    line := 7648
    kind := .lemma
    disposition := .registeredGap
    title := "Fibre density for parabolics"
    leanDecls := [
      "HodgeReduction.E7ArithmeticityStep1Data",
      "HodgeReduction.E7ArithmeticityStep1Data.boundary_to_u7_density",
      "HodgeReduction.E7ArithmeticityStep1Data.parabolic_density"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port", "G-main-hc"]
    auditTags := [.paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "The dependency slot is now Lean-recorded in the E7 arithmeticity pipeline.  The Borel-density/Borel-Tits theorem itself is not kernel-ported, so this remains import debt rather than a silently consumed monodromy theorem." },
  { id := "prop:boundary-in-u7"
    sourceId := "master-tex"
    line := 7695
    kind := .proposition
    disposition := .registeredGap
    title := "Boundary monodromy lands in u7"
    leanDecls := [
      "HodgeReduction.E7ArithmeticityStep1Data",
      "HodgeReduction.E7ArithmeticityStep1Data.boundaryMonodromyInU7",
      "HodgeReduction.E7ArithmeticityStep1Data.parabolic_density"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "The proposition is represented as a named input to the kernel-checked dependency pipeline.  The Schmid/CKS, Borel-extension, and EVII grading proof is not yet a standalone Lean theorem." },
  { id := "prop:w0-flip"
    sourceId := "master-tex"
    line := 7773
    kind := .proposition
    disposition := .registeredGap
    title := "w0 flip produces opposite unipotent intersection"
    leanDecls := [
      "HodgeReduction.E7ArithmeticityStep1Data",
      "HodgeReduction.E7ArithmeticityStep1Data.w0_flip"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port", "G-main-hc"]
    auditTags := [.paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "The w0/opposite-unipotent slot is Lean-recorded in the pipeline, but the Chevalley/Bruhat group-theory proof is not yet kernel-ported." },
  { id := "thm:parabolic-density"
    sourceId := "master-tex"
    line := 7843
    kind := .theorem
    disposition := .registeredGap
    title := "Density of parabolic monodromy"
    leanDecls := [
      "HodgeReduction.E7ArithmeticityStep1Data",
      "HodgeReduction.E7ArithmeticityStep1Data.parabolic_density"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The Lean theorem composes the named dependency fields to the parabolic-density conclusion.  The actual fibre-density, boundary-monodromy, and E6 irreducibility inputs remain non-kernel-ported." },
  { id := "thm:e7-arithmeticity"
    sourceId := "master-tex"
    line := 7906
    kind := .theorem
    disposition := .registeredGap
    title := "Arithmeticity of E7-type monodromy"
    leanDecls := [
      "HodgeReduction.thm_subcase3b_vacuous",
      "HodgeReduction.E7ArithmeticityStep1Data",
      "HodgeReduction.E7ArithmeticityStep1Data.arithmeticity_from_all_inputs",
      "HodgeReduction.e7_arithmeticity_not_from_boundary_data_alone"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The Step 1 dependency composition is kernel-checked, including a non-compression certificate showing boundary data alone is insufficient.  The standalone arithmeticity theorem still depends on non-ported Borel/Schmid/Bruhat/Steinberg/MVW inputs, so it remains registered import debt." },
  { id := "hyp:hecke-bbt"
    sourceId := "master-tex"
    line := 8256
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Hecke-equivariance of BBT spreading"
    leanDecls := [
      "HodgeReduction.hyp_hecke_bbt_a",
      "HodgeReduction.hyp_hecke_bbt_b",
      "HodgeReduction.hyp_hecke_bbt_c",
      "HodgeReduction.hyp_hecke_bbt_d",
      "HodgeReduction.hyp_hecke_bbt_core"
    ]
    gapIds := ["G-main-hc"]
    notes := "Composite primary input; several clauses are theorem projections but the parent remains conditional." },
  { id := "thm:subcase3b-vacuous"
    sourceId := "master-tex"
    line := 8468
    kind := .theorem
    disposition := .formalized
    title := "Sub-case 3b vacuity"
    leanDecls := [
      "HodgeReduction.E7Family",
      "HodgeReduction.thm_subcase3b_vacuous_paper_axiom",
      "HodgeReduction.thm_subcase3b_vacuous"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    notes := "Lean has an explicit theorem with the paper hypotheses as E7Family fields; the theorem still packages the paper route through the family witness field." },
  { id := "cor:hc-conditional-nonrigid-e7"
    sourceId := "master-tex"
    line := 8728
    kind := .corollary
    disposition := .conditionalMilestone
    title := "HC for non-rigid E7-type families under labelled hypotheses"
    leanDecls := [
      "HodgeReduction.E7Family",
      "HodgeReduction.thm_subcase3b_vacuous"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    notes := "Family-level non-rigid E7 milestone conditional on Chern-Weil bridge, AH-CM-E7, and the fibre-level nonrigid-family bridge; no unconditional fibre-level theorem is claimed." },
  { id := "open:torelli-evii"
    sourceId := "master-tex"
    line := 8861
    kind := .openQuestion
    disposition := .openResidual
    title := "Torelli-EVII and exotic rigid E7-type vacuity"
    leanDecls := [
      "HodgeReduction.TorelliEVIIQuestionData",
      "HodgeReduction.TorelliEVIIQuestionData.exotic_rigid_vacuity_from_evii_uniformisation",
      "HodgeReduction.arithmeticity_and_mok_do_not_self_close_torelli_evii"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The Lean side now records Torelli-EVII as a residual vacuity question: arithmeticity and a Mok-style conditional do not close the exotic rigid case without an independent EVII-uniformisation input." },
  { id := "open:exotic-residual"
    sourceId := "master-tex"
    line := 9026
    kind := .openQuestion
    disposition := .openResidual
    title := "Exotic rigid non-Shimura E7 residual"
    leanDecls := [
      "HodgeReduction.ExoticE7ResidualData",
      "HodgeReduction.ExoticE7ResidualData.exotic_residual_eliminated_from_all_subbranches",
      "HodgeReduction.known_e7_cases_do_not_self_close_exotic_residual",
      "HodgeReduction.FullHCResidualGateData",
      "HodgeReduction.FullHCResidualGateData.full_hodge_conjecture_from_residual_gate",
      "HodgeReduction.r612ScopeOrComplementResidualGateData",
      "HodgeReduction.fullHodgeConjectureReal_from_r612ResidualGate",
      "HodgeReduction.IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK",
      "HodgeReduction.IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK",
      "HodgeReduction.currentR613ResidualGateRouteSnapshot_eq_texStatus"
    ]
    gapIds := ["G-full-hc", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The Lean side records the residual as a gate to `FullHodgeConjectureReal`: known CY3/non-rigid/known-rigid cases do not eliminate the kappa and dimension sub-branches.  R613 now aligns this residual-gate vocabulary with the R612 scope-or-complement route; R625 records the kappa=0 broken-link hypotheses as open-residual anchors rather than hidden closure claims." },
  { id := "open:hbundle"
    sourceId := "master-tex"
    line := 9207
    kind := .openQuestion
    disposition := .registeredGap
    title := "H-bundle matching in the non-toroidal-boundary case"
    leanDecls := [
      "HodgeReduction.HBundleMatchingData",
      "HodgeReduction.HBundleMatchingData.bundle_matching_from_toroidal_reduction_package",
      "HodgeReduction.known_hbundle_cases_do_not_self_close_arbitrary_nontoroidal_boundary"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "The master text now treats this as a boundary-matching status label rather than a new-math open residual: known automatic cases do not self-close the arbitrary non-toroidal case, but the paper's claimed closure routes through toroidal reduction and descent.  The analytic/algebraic geometry ingredients remain kernel-port debt." },
  { id := "open:fibre-id"
    sourceId := "master-tex"
    line := 9315
    kind := .openQuestion
    disposition := .registeredGap
    title := "Fibre-level algebraic cycle from the Shimura side"
    leanDecls := [
      "HodgeReduction.FibreTransferData",
      "HodgeReduction.shimura_side_and_period_map_do_not_self_close_fibre_algebraicity",
      "HodgeReduction.FibreTransferData.fibre_level_algebraicity_from_bbt_spreading_inputs"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The fibre-transfer non-implication is kernel-checked: Shimura-side algebraicity plus an algebraic period map does not by itself produce fibre-level algebraicity.  The BBT/H-bundle/AH route is represented as a conditional consumer, so the entry remains a registered gap until those inputs are kernel-ported or otherwise discharged." },
  { id := "def:shimura-type-fibre"
    sourceId := "master-tex"
    line := 9393
    kind := .definition
    disposition := .formalized
    title := "Shimura-type fibre"
    leanDecls := [
      "HodgeReduction.ShimuraTypeFibreData",
      "HodgeReduction.ShimuraTypeFibreData.has_algebraic_map_to_shimura_target",
      "HodgeReduction.ShimuraTypeFibreData.selected_class_is_pulled_back_from_chern_weil",
      "HodgeReduction.ShimuraTypeFibreData.invariant_classes_realized_through_map"
    ]
    gapIds := ["G-l4-mt-correspondence"]
    notes := "The definition is now represented by an abstract Lean carrier recording the arithmetic lattice, EVII toroidal target, algebraic fibre map, Chern-Weil pullback condition, and equivalent all-invariant-classes formulation.  This does not prove density of such fibres or the Chern-Weil/BBT bridge used later." },
  { id := "prop:shimura-fibre-density"
    sourceId := "master-tex"
    line := 9464
    kind := .proposition
    disposition := .registeredGap
    title := "Density of CM fibres in E7-type families"
    leanDecls := [
      "HodgeReduction.CMFibreDensityData",
      "HodgeReduction.CMFibreDensityData.shimura_fibre_density_from_transport",
      "HodgeReduction.cm_density_alone_does_not_force_e7_family_density"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .migrationDebt]
    notes := "Lean now records the dependency shape: CM density on the Shimura side reaches E7-family density only after a dominant-period-map route or weakly-special fallback is supplied, and a countermodel certifies that CM density alone does not self-close the claim.  The Andre-Oort/CM-density and geometric transport theorems are not kernel-ported." },
  { id := "thm:SL8-quartic-decomposition"
    sourceId := "master-tex"
    line := 9560
    kind := .theorem
    disposition := .registeredGap
    title := "SL8 decomposition of the Freudenthal quartic"
    leanDecls := [
      "HodgeReduction.FreudenthalInvariantData",
      "HodgeReduction.FreudenthalEvaluationData"
    ]
    gapIds := ["G-master-paper-import", "G-classical-mathlib-port", "G-main-hc"]
    notes := "Lean has abstract Freudenthal quartic carriers, but not the explicit SL8 branching and Pfaffian/tr(AB) quartic decomposition theorem." },
  { id := "prop:q4-abelian-algebraicity"
    sourceId := "master-tex"
    line := 9622
    kind := .proposition
    disposition := .conditionalMilestone
    title := "Algebraicity of q4 on the abelian-type side"
    leanDecls := [
      "HodgeReduction.Q4AbelianAlgebraicityData",
      "HodgeReduction.Q4AbelianAlgebraicityData.pointwise_q4_algebraicity_from_cm_abelian_bridge",
      "HodgeReduction.Q4AbelianAlgebraicityData.global_q4_algebraicity_from_full_transfer",
      "HodgeReduction.pointwise_q4_algebraicity_does_not_self_close_global_e7"
    ]
    gapIds := ["G-master-paper-import", "G-l4-cm-abelian-hc", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "Lean now separates the pointwise CM/abelian q4 algebraicity consumer from the global E7-family transfer.  The kernel-checked countermodel records that the pointwise package does not by itself supply a global abelian-type Shimura morphism or close global E7 q4 algebraicity." },
  { id := "prop:omega-diagonal"
    sourceId := "master-tex"
    line := 10113
    kind := .proposition
    disposition := .registeredGap
    title := "Diagonal characterisation of the symplectic class"
    leanDecls := [
      "HodgeReduction.OmegaDiagonalData",
      "HodgeReduction.OmegaDiagonalData.cohomological_identity_from_standard_conjecture_package",
      "HodgeReduction.OmegaDiagonalData.omega_algebraic_from_diagonal_standard_conjectures_and_schur",
      "HodgeReduction.OmegaDiagonalData.schur_projector_step_iff_omega_algebraicity",
      "HodgeReduction.standard_conjecture_pair_does_not_self_close_omega_diagonal",
      "HodgeReduction.andre_motivated_closure_does_not_self_close_chow_omega"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .newMathGap, .migrationDebt]
    notes := "The Lean dependency shape now records the cohomological diagonal formula separately from the Chow-level obligations.  Countermodels certify that SC(B)3 + SC(C)3 and the Andre motivated closure do not self-close omega algebraicity without the Schur projector / motivated-to-Chow descent, and the Schur projector step is equivalent to the desired omega conclusion." },
  { id := "lem:sg23-andre-closure"
    sourceId := "master-tex"
    line := 10409
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG23 closure at appendix scope via Andre motives"
    leanDecls := [
      "HodgeReduction.kleiman_1968_SCB_implies_SCC_at_Chow_sg23",
      "HodgeReduction.kleiman_1994_kunneth_polynomial_in_L_Lambda_sg23",
      "HodgeReduction.andre_1996_SCB_SCC_in_MAE_via_Thm_0_5_sg23",
      "HodgeReduction.mae_to_chow_descent_sg23_INVENTION_CLASS",
      "HodgeReduction.sg_23_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Formalized as an appendix-scope motivated-motive package, but Chow descent remains a named-open/invention-class extension and does not close HC." },
  { id := "lem:sg18-pi3-chow-conditional"
    sourceId := "master-tex"
    line := 10472
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG18 pi3 Chow lift conditional on Murre B"
    leanDecls := [
      "HodgeReduction.IsMurre1990Pi3ChowLift_sg18_NAMED_OPEN",
      "HodgeReduction.murre_1990_pi3_chow_lift_sg18_NAMED_OPEN",
      "HodgeReduction.sg18_from_framework_and_named_open_extension",
      "HodgeReduction.sg_18_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "The Lean SG18 package records the Murre B i=3 named-open dependency; the lemma is appendix-level and not a main-chain closure." },
  { id := "prop:theta-closure"
    sourceId := "master-tex"
    line := 10516
    kind := .proposition
    disposition := .openResidual
    title := "Cycle seeding on known E7-type varieties"
    leanDecls := [
      "HodgeReduction.thm_cy3_e7_nonexistence",
      "HodgeReduction.thm_subcase3b_vacuous"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    notes := "Records useful conditional seeding for known E7 cases, while explicitly preserving the hypothetical rigid dim>=5 non-Shimura residual." },
  { id := "thm:E7-modularity"
    sourceId := "master-tex"
    line := 10735
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Modularity of the E7 generating series"
    leanDecls := [
      "HodgeReduction.E7ThetaModularityData",
      "HodgeReduction.E7ThetaModularityData.cohomological_theta_modularity_from_kernel",
      "HodgeReduction.E7ThetaModularityData.e7_chow_modularity_from_full_package",
      "HodgeReduction.cohomological_theta_does_not_self_close_chow_valued_e7_modularity"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The dependency shape is now kernel-recorded: the cohomological theta transformation and rank-3 special-cycle algebraicity do not self-close the Chow-valued E7 modularity theorem without the labelled Chow-class modularity input." },
  { id := "hyp:chow-modularity-E7"
    sourceId := "master-tex"
    line := 10940
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Chow-class modularity of the E7 theta series"
    leanDecls := [
      "HodgeReduction.E7ChowModularityData",
      "HodgeReduction.E7ChowModularityData.chow_modularity_from_full_package",
      "HodgeReduction.ThetaIsChowModular",
      "HodgeReduction.IsExceptionalE7ChowModularityExtension_CONJECTURAL",
      "HodgeReduction.orthogonal_chow_frameworks_do_not_self_close_exceptional_e7_chow_modularity"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The Lean side now records the exact four-component package and reuses the existing OpenHypotheses predicate `ThetaIsChowModular`.  A countermodel certifies that the cohomological and orthogonal Chow frameworks do not self-close the exceptional E7 Chow lift plus Hermitian real-form descent." },
  { id := "thm:E7-theta-match"
    sourceId := "master-tex"
    line := 11029
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Theta-lift matching represents the invariant class"
    leanDecls := [
      "HodgeReduction.E7ThetaMatchData",
      "HodgeReduction.E7ThetaMatchData.theta_match_from_full_package",
      "HodgeReduction.E7ThetaMatchData.nonzero_algebraic_theta_cycle_from_match",
      "HodgeReduction.chow_modularity_and_theta_framework_do_not_self_close_theta_match"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The theta-match dependency shape is now kernel-recorded: Chow modularity, exceptional theta, the Hermitian (g,K) degree computation, rank-3 Whittaker non-vanishing, rank-3 special cycles, and a nonzero cusp form are separate load-bearing inputs.  A countermodel records that the broad theta framework does not close the match without rank-3 non-vanishing." },
  { id := "cor:theta-step-iii"
    sourceId := "master-tex"
    line := 11304
    kind := .corollary
    disposition := .conditionalMilestone
    title := "Step iii Shimura-side cycle seeding for E7"
    leanDecls := [
      "HodgeReduction.E7ThetaStepIIIData",
      "HodgeReduction.E7ThetaStepIIIData.shimura_side_cycle_seeding_from_theta_package",
      "HodgeReduction.E7ThetaStepIIIData.hbundle_cycle_seeding_from_theta_and_fibre_transfer",
      "HodgeReduction.shimura_side_theta_cycle_does_not_self_close_fibre_transfer"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The Step (iii) corollary is now kernel-recorded as Shimura-side cycle seeding from modularity, theta-match, special cycles, and a controlled-degree bound.  A countermodel keeps the fibre-level transfer to arbitrary E7 families separate." },
  { id := "lem:CM-E7-algebraicity"
    sourceId := "master-tex"
    line := 11425
    kind := .lemma
    disposition := .conditionalMilestone
    title := "Algebraicity at CM fibres of exceptional type"
    leanDecls := [
      "HodgeReduction.E7CMAlgebraicityData",
      "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_absolute_hodge_and_hbundle",
      "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_full_package",
      "HodgeReduction.absolute_hodge_does_not_self_close_cm_e7_algebraicity"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-cm-abelian-hc"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The dependency shape is now kernel-recorded: AH-CM-E7 plus H-bundle cycle seeding gives the CM-fibre algebraicity consumer, and a countermodel records that absolute-Hodge status alone does not self-close algebraicity for non-abelian E7 type." },
  { id := "hyp:AH-CM-E7"
    sourceId := "master-tex"
    line := 11584
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Absolute Hodge for E7-type CM fibres"
    leanDecls := [
      "HodgeReduction.E7CMAlgebraicityData",
      "HodgeReduction.E7CMAlgebraicityData.absolute_hodge_from_nonabelian_e7_extension",
      "HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_full_package",
      "HodgeReduction.abelian_frameworks_do_not_self_close_nonabelian_e7_absolute_hodge"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The AH-CM-E7 dependency shape is now kernel-recorded and explicitly separated from Deligne/Andre abelian-span frameworks.  A countermodel certifies that the abelian absolute-Hodge frameworks do not self-close the non-abelian E7 CM-fibre extension." },
  { id := "hyp:ChernWeil-bridge-E7"
    sourceId := "master-tex"
    line := 11613
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Chern-Weil bridge for the E7 Freudenthal quartic"
    leanDecls := [
      "HodgeReduction.E7ChernWeilBridgeData",
      "HodgeReduction.E7ChernWeilBridgeData.compact_dual_nonzero_from_schwarz_bridge",
      "HodgeReduction.E7ChernWeilBridgeData.toroidal_class_from_matsushima_descent",
      "HodgeReduction.E7ChernWeilBridgeData.e7_chern_weil_algebraicity_from_full_bridge",
      "HodgeReduction.schwarz_invariant_ring_does_not_self_close_e7_chern_weil",
      "HodgeReduction.cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil"
    ]
    gapIds := ["G-main-hc", "G-l4-mt-correspondence", "G-hcgap-l4-multifront"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The dependency shape is now kernel-recorded: Schwarz/Sato-Kimura, compact-dual bridge, non-cocompact Matsushima/Mumford boundary compatibility, and Chern-polynomial identity are separated, with countermodels showing that the classical invariant-ring statement or cocompact Matsushima alone do not self-close the E7 Chern-Weil conclusion.  The actual bridge remains a labelled new-math gap." },
  { id := "hyp:BBT-rigid-reach"
    sourceId := "master-tex"
    line := 11814
    kind := .hypothesis
    disposition := .openHypothesis
    title := "BBT spreading reaches rigid isolated points"
    leanDecls := [
      "HodgeReduction.BBTRigidReachData",
      "HodgeReduction.BBTRigidReachData.rigid_isolated_reach_from_full_package",
      "HodgeReduction.bbt_frameworks_do_not_self_close_rigid_isolated_reach"
    ]
    gapIds := ["G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The Lean dependency shape now separates BBT/CM framework inputs from the rigid isolated-limit extension.  A countermodel certifies that the BBT/CM package and CM-point cycles do not self-close the rigid isolated-point reach hypothesis." },
  { id := "hyp:nonrigid-family-bridge"
    sourceId := "master-tex"
    line := 11872
    kind := .hypothesis
    disposition := .openHypothesis
    title := "Generically finite period-map family through a non-rigid variety"
    leanDecls := [
      "HodgeReduction.NonRigidFamilyBridgeData",
      "HodgeReduction.NonRigidFamilyBridgeData.base_dimension_from_period_package",
      "HodgeReduction.NonRigidFamilyBridgeData.nonrigid_family_bridge_from_full_period_package",
      "HodgeReduction.nonrigidity_does_not_self_close_period_family_bridge"
    ]
    gapIds := ["G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .newMathGap, .migrationDebt]
    notes := "The Lean dependency shape now separates fibre-level non-rigidity and Kuranishi existence from the generically-finite and dominant period-map package.  A countermodel certifies that non-rigidity alone does not self-close the family bridge." },
  { id := "thm:E7-BBT-spreading"
    sourceId := "master-tex"
    line := 11953
    kind := .theorem
    disposition := .conditionalMilestone
    title := "BBT spreading for E7-type families"
    leanDecls := [
      "HodgeReduction.E7BBTSpreadingData",
      "HodgeReduction.E7BBTSpreadingData.e7_bbt_spreading_from_full_package",
      "HodgeReduction.E7BBTSpreadingData.individual_scope_transfer_from_family_spreading_and_bridges",
      "HodgeReduction.bbt_cm_density_do_not_self_close_e7_bbt_spreading",
      "HodgeReduction.family_spreading_does_not_self_close_individual_e7_scope"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The Lean dependency shape now records the family-level E7 BBT-spreading package and the separate individual-scope transfer through rigid-reach and non-rigid-family bridge inputs.  Countermodels certify that BBT/CM density alone does not close E7 spreading, and family-level spreading alone does not close the individual-scope statement." },
  { id := "prop:quartic-chern"
    sourceId := "master-tex"
    line := 12348
    kind := .proposition
    disposition := .conditionalMilestone
    title := "Freudenthal quartic as Chern class under Chern-Weil bridge"
    leanDecls := [
      "HodgeReduction.ChernWeilBridge_E7_i",
      "HodgeReduction.ChernWeilBridge_E7_ii",
      "HodgeReduction.ChernWeilBridge_E7_iii"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    notes := "Inherits hyp:ChernWeil-bridge-E7, including the explicit Freudenthal polynomial/sign-tracking and compact-dual transfer issues." },
  { id := "prop:deligne-splitting"
    sourceId := "master-tex"
    line := 12506
    kind := .proposition
    disposition := .registeredGap
    title := "Shimura-side and base-level algebraicity"
    leanDecls := [
      "HodgeReduction.FibreTransferData",
      "HodgeReduction.FibreTransferData.base_level_algebraicity_from_shimura_side",
      "HodgeReduction.shimura_side_and_period_map_do_not_self_close_fibre_algebraicity"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The Lean dependency shape now separates Shimura-side/base-level algebraicity from fibre-level algebraicity and records the non-implication.  The actual BBT, Chern-Weil, and fibre-cycle geometry remains import debt." },
  { id := "cor:quartic-algebraic"
    sourceId := "master-tex"
    line := 12553
    kind := .corollary
    disposition := .conditionalMilestone
    title := "Fibre-level algebraicity for E7-type"
    leanDecls := [
      "HodgeReduction.E7FibreInvariantClassSplitData",
      "HodgeReduction.E7FibreInvariantClassSplitData.all_invariant_classes_from_h3_algebraicity",
      "HodgeReduction.motivated_h3_class_does_not_self_close_algebraicity"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-l4-mt-correspondence"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .migrationDebt]
    notes := "The fibre-class split is now kernel-recorded: Chern/Lefschetz pieces are separated from the H3-derived component, and motivatedness alone is certified not to self-close algebraicity.  The corollary remains conditional on H-bundle, BBT coherence, and Chern-Weil/AH inputs." },
  { id := "lem:sg22-tabuada-nc-no-shortcut"
    sourceId := "master-tex"
    line := 12961
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG22 noncommutative route does not shortcut HC"
    leanDecls := [
      "HodgeReduction.tabuada_2013_chow_nc_comparison_sg22",
      "HodgeReduction.lin_2021_nchc_equiv_hc_sg22",
      "HodgeReduction.nc_pi3_to_classical_chow_lift_sg22_INVENTION_CLASS",
      "HodgeReduction.sg_22_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Lean records the comparison/equivalence plus the invention-class classical-Chow lift; the NC route is a no-shortcut diagnostic, not a closure." },
  { id := "thm:eigenvalue-separation"
    sourceId := "master-tex"
    line := 13005
    kind := .theorem
    disposition := .conditionalMilestone
    title := "Eigenvalue separation for CM fibres"
    leanDecls := [
      "HodgeReduction.CMEigenvalueSeparationData",
      "HodgeReduction.CMEigenvalueSeparationData.abelian_type_eigenvalue_separation_from_honda_tate",
      "HodgeReduction.CMEigenvalueSeparationData.nonabelian_e7_eigenvalue_separation_from_honda_tate_extension",
      "HodgeReduction.abelian_honda_tate_does_not_self_close_nonabelian_e7_eigenvalue_separation"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .externalCitationNotKernelPorted, .newMathGap, .migrationDebt]
    notes := "Lean now separates the abelian-type Honda-Tate consumer from the non-abelian E7 CM clause and certifies that classical Honda-Tate for abelian motives does not self-close the non-abelian eigenvalue-separation statement.  This remains appendix-level and conditional on the SG14 Honda-Tate extension." },
  { id := "lem:sg14-honda-tate-non-abelian-conditional"
    sourceId := "master-tex"
    line := 13110
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG14 Honda-Tate extension to non-abelian CM motives"
    leanDecls := [
      "HodgeReduction.tate_1966_endomorphisms_abelian_finite_field_sg14",
      "HodgeReduction.honda_1968_weil_q_number_realization_sg14",
      "HodgeReduction.tate_1968_bourbaki_honda_tate_dictionary_sg14",
      "HodgeReduction.kmps_2022_honda_tate_extension_non_abelian_cm_sg14_NAMED_OPEN",
      "HodgeReduction.sg_14_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Formalized as a framework-plus-named-open SG14 package; it is not part of the main theorem chain and does not close non-abelian CM algebraicity." },
  { id := "thm:p-adic-descent"
    sourceId := "master-tex"
    line := 13159
    kind := .theorem
    disposition := .formalized
    title := "p-adic descent for rational Hodge classes"
    leanDecls := [
      "HodgeReduction.RationalScalarExtensionDescentData",
      "HodgeReduction.RationalScalarExtensionDescentData.mem_rationalSubspace_of_base_mem_extendedSubspace",
      "HodgeReduction.RationalScalarExtensionDescentData.padic_descent_linear_algebra_core"
    ]
    gapIds := ["G-master-paper-import"]
    notes := "The kernel-checked theorem formalizes the proof's faithful scalar-extension quotient step `(V tensor K) intersection W = V`.  It does not close the surrounding syntomic/p-adic-HC input, which remains a reduction rather than a theorem of algebraic cycles." },
  { id := "lem:sg20-rho-omega-tate-conditional"
    sourceId := "master-tex"
    line := 13293
    kind := .lemma
    disposition := .conditionalMilestone
    title := "SG20 arithmetic descent of rho_omega conditional on Tate plus MT"
    leanDecls := [
      "HodgeReduction.tate_1965_conjecture_codim_3_on_x_sg20_NAMED_OPEN",
      "HodgeReduction.mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN",
      "HodgeReduction.sg20_from_antecedent_framework_and_named_open_extensions",
      "HodgeReduction.sg_20_closed"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc"]
    notes := "Lean records the published framework atoms plus two named-open inputs, Tate codim 3 and MT for H3; appendix-level only." },
  { id := "prop:combined-closure"
    sourceId := "master-tex"
    line := 13532
    kind := .proposition
    disposition := .openResidual
    title := "Proof strategies for the E7 residual"
    leanDecls := [
      "HodgeReduction.E7ResidualStrategyData",
      "HodgeReduction.E7ResidualStrategyData.residual_hc_from_theta_transfer",
      "HodgeReduction.E7ResidualStrategyData.residual_hc_from_padic_route",
      "HodgeReduction.E7ResidualStrategyData.residual_hc_from_bost_charles_route",
      "HodgeReduction.theta_shimura_cycle_does_not_self_close_residual_hc",
      "HodgeReduction.padic_descent_does_not_self_close_residual_hc",
      "HodgeReduction.bost_charles_framework_does_not_self_close_residual_hc"
    ]
    gapIds := ["G-master-paper-import", "G-main-hc", "G-full-hc"]
    auditTags := [.kernelOnlyLeanCode, .conditionalLeanPackage, .paperProofNotKernelPorted, .newMathGap, .migrationDebt]
    notes := "The Lean side now records the three residual strategy routes and the missing load-bearing inputs: theta needs fibre transfer, p-adic descent needs p-adic HC, and Bost-Charles needs exceptional MT, Tate codim 3, and its technical algebraization hypotheses." }
]

def claimsWithDisposition (d : ClaimDisposition) : List PaperClaim :=
  masterClaims.filter (fun c => decide (c.disposition = d))

def openHypothesisClaims : List PaperClaim :=
  claimsWithDisposition .openHypothesis

def registeredGapClaims : List PaperClaim :=
  claimsWithDisposition .registeredGap

def needsTriageClaims : List PaperClaim :=
  claimsWithDisposition .needsTriage

def formalizedClaims : List PaperClaim :=
  claimsWithDisposition .formalized

def provenInPaperClaims : List PaperClaim :=
  claimsWithDisposition .provenInPaper

def conditionalMilestoneClaims : List PaperClaim :=
  claimsWithDisposition .conditionalMilestone

def externalCitationClaims : List PaperClaim :=
  claimsWithDisposition .externalCitation

def openResidualClaims : List PaperClaim :=
  claimsWithDisposition .openResidual

def archiveOnlyClaims : List PaperClaim :=
  claimsWithDisposition .archiveOnly

/-- Claim ids for a paper-claim worklist. -/
def claimIds (claims : List PaperClaim) : List String :=
  claims.map (fun c => c.id)

/-- Whether a master-paper claim is explicitly assigned to a route-level gap. -/
def claimReferencesGapId (gapId : String) (c : PaperClaim) : Bool :=
  c.gapIds.any (fun registeredId => registeredId == gapId)

/-- Master-paper claims that reference a route-level gap id. -/
def masterClaimsForGapId (gapId : String) : List PaperClaim :=
  masterClaims.filter (claimReferencesGapId gapId)

/-- Master-paper claim ids that reference a route-level gap id. -/
def masterClaimIdsForGapId (gapId : String) : List String :=
  claimIds (masterClaimsForGapId gapId)

/-- Default correspondence tags inferred from the current disposition.  Explicit
`auditTags` on a claim override this coarse fallback. -/
def inferredAuditTags (c : PaperClaim) : List ClaimAuditTag :=
  match c.disposition with
  | .formalized => [.kernelOnlyLeanCode]
  | .provenInPaper => [.paperProofNotKernelPorted]
  | .conditionalMilestone => [.conditionalLeanPackage, .paperProofNotKernelPorted]
  | .externalCitation => [.externalCitationNotKernelPorted]
  | .registeredGap => [.migrationDebt]
  | .openHypothesis => [.newMathGap]
  | .openResidual => [.newMathGap]
  | .archiveOnly => [.archiveOnly]
  | .needsTriage => [.migrationDebt]

/-- Effective paper-to-Lean audit tags for a claim. -/
def effectiveAuditTags (c : PaperClaim) : List ClaimAuditTag :=
  if c.auditTags.isEmpty then inferredAuditTags c else c.auditTags

def claimHasEffectiveAuditTag (c : PaperClaim) : Bool :=
  !(effectiveAuditTags c).isEmpty

def claimsWithAuditTag (t : ClaimAuditTag) : List PaperClaim :=
  masterClaims.filter
    (fun c => (effectiveAuditTags c).any (fun u => decide (u = t)))

def kernelOnlyLeanClaims : List PaperClaim :=
  claimsWithAuditTag .kernelOnlyLeanCode

def kernelOnlyLeanClaimCount : Nat :=
  kernelOnlyLeanClaims.length

def paperProofNotKernelPortedClaims : List PaperClaim :=
  claimsWithAuditTag .paperProofNotKernelPorted

def paperProofNotKernelPortedClaimCount : Nat :=
  paperProofNotKernelPortedClaims.length

def externalCitationNotKernelPortedClaims : List PaperClaim :=
  claimsWithAuditTag .externalCitationNotKernelPorted

def externalCitationNotKernelPortedClaimCount : Nat :=
  externalCitationNotKernelPortedClaims.length

def newMathGapClaims : List PaperClaim :=
  claimsWithAuditTag .newMathGap

def newMathGapClaimCount : Nat :=
  newMathGapClaims.length

def migrationDebtClaims : List PaperClaim :=
  claimsWithAuditTag .migrationDebt

def migrationDebtClaimCount : Nat :=
  migrationDebtClaims.length

def registeredGapClaimIds : List String :=
  claimIds registeredGapClaims

def openHypothesisClaimIds : List String :=
  claimIds openHypothesisClaims

def openResidualClaimIds : List String :=
  claimIds openResidualClaims

def conditionalMilestoneClaimIds : List String :=
  claimIds conditionalMilestoneClaims

def paperProofNotKernelPortedClaimIds : List String :=
  claimIds paperProofNotKernelPortedClaims

def externalCitationNotKernelPortedClaimIds : List String :=
  claimIds externalCitationNotKernelPortedClaims

def newMathGapClaimIds : List String :=
  claimIds newMathGapClaims

def migrationDebtClaimIds : List String :=
  claimIds migrationDebtClaims

def untaggedMasterClaims : List PaperClaim :=
  masterClaims.filter (fun c => ! claimHasEffectiveAuditTag c)

def untaggedMasterClaimCount : Nat :=
  untaggedMasterClaims.length

def allMasterClaimsHaveEffectiveAuditTag : Bool :=
  masterClaims.all claimHasEffectiveAuditTag

/-- Whether a master-paper claim covers a theorem-like environment from the
canonical index.  A labelled environment may be covered either by matching the
paper label in `id` or by matching its line number; unlabeled environments use
the line number. -/
def claimCoversEnvironment (c : PaperClaim) (e : MasterEnvironment) : Bool :=
  c.sourceId == "master-tex" &&
    (c.line == e.line || (e.label != "" && c.id == e.label))

def environmentHasClaim (e : MasterEnvironment) : Bool :=
  masterClaims.any (fun c => claimCoversEnvironment c e)

def claimedMasterEnvironments : List MasterEnvironment :=
  masterEnvironmentIndex.filter environmentHasClaim

def unclaimedMasterEnvironments : List MasterEnvironment :=
  masterEnvironmentIndex.filter (fun e => ! environmentHasClaim e)

def environmentCoveringClaims (e : MasterEnvironment) : List PaperClaim :=
  masterClaims.filter (fun c => claimCoversEnvironment c e)

def environmentCoveringClaimCount (e : MasterEnvironment) : Nat :=
  (environmentCoveringClaims e).length

def environmentHasUniqueClaim (e : MasterEnvironment) : Bool :=
  environmentCoveringClaimCount e == 1

def masterEnvironmentsWithoutUniqueClaim : List MasterEnvironment :=
  masterEnvironmentIndex.filter (fun e => ! environmentHasUniqueClaim e)

def masterEnvironmentsWithoutUniqueClaimCount : Nat :=
  masterEnvironmentsWithoutUniqueClaim.length

def allMasterEnvironmentsHaveUniqueClaim : Bool :=
  masterEnvironmentIndex.all environmentHasUniqueClaim

def environmentClaimKindsMatch (e : MasterEnvironment) : Bool :=
  (environmentCoveringClaims e).all (fun c => decide (c.kind = e.kind))

def masterEnvironmentsWithKindMismatch : List MasterEnvironment :=
  masterEnvironmentIndex.filter (fun e => ! environmentClaimKindsMatch e)

def masterEnvironmentsWithKindMismatchCount : Nat :=
  masterEnvironmentsWithKindMismatch.length

def allClaimedMasterEnvironmentKindsMatch : Bool :=
  masterEnvironmentIndex.all environmentClaimKindsMatch

def claimCoversSomeMasterEnvironment (c : PaperClaim) : Bool :=
  masterEnvironmentIndex.any (fun e => claimCoversEnvironment c e)

def masterClaimsNotCoveringMasterEnvironment : List PaperClaim :=
  masterClaims.filter (fun c => ! claimCoversSomeMasterEnvironment c)

def masterClaimsNotCoveringMasterEnvironmentCount : Nat :=
  masterClaimsNotCoveringMasterEnvironment.length

def masterClaimCount : Nat :=
  masterClaims.length

def formalizedClaimCount : Nat :=
  formalizedClaims.length

def provenInPaperClaimCount : Nat :=
  provenInPaperClaims.length

def conditionalMilestoneClaimCount : Nat :=
  conditionalMilestoneClaims.length

def externalCitationClaimCount : Nat :=
  externalCitationClaims.length

def registeredGapClaimCount : Nat :=
  registeredGapClaims.length

def claimedMasterEnvironmentCount : Nat :=
  claimedMasterEnvironments.length

def unclaimedMasterEnvironmentCount : Nat :=
  unclaimedMasterEnvironments.length

def openHypothesisCount : Nat :=
  openHypothesisClaims.length

def openResidualClaimCount : Nat :=
  openResidualClaims.length

def archiveOnlyClaimCount : Nat :=
  archiveOnlyClaims.length

def needsTriageCount : Nat :=
  needsTriageClaims.length

/-- Every master-paper claim should have at least one concrete Lean declaration
or one explicit route/gap id.  Audit tags alone are not enough correspondence. -/
def claimHasMachineCorrespondence (c : PaperClaim) : Bool :=
  !c.leanDecls.isEmpty || !c.gapIds.isEmpty

def claimsWithoutMachineCorrespondence : List PaperClaim :=
  masterClaims.filter (fun c => ! claimHasMachineCorrespondence c)

def claimsWithoutMachineCorrespondenceCount : Nat :=
  claimsWithoutMachineCorrespondence.length

def allMasterClaimsHaveMachineCorrespondence : Bool :=
  masterClaims.all claimHasMachineCorrespondence

/-- Claims marked as Lean/kernel-side should point to at least one Lean declaration. -/
def claimHasLeanDecl (c : PaperClaim) : Bool :=
  !c.leanDecls.isEmpty

/-- Claims marked as open or gap-bearing should point to at least one route/gap id. -/
def claimHasGapId (c : PaperClaim) : Bool :=
  !c.gapIds.isEmpty

def masterClaimById? (claimId : String) : Option PaperClaim :=
  masterClaims.find? (fun c => c.id == claimId)

def masterClaimIdIsPresent (claimId : String) : Bool :=
  match masterClaimById? claimId with
  | some _ => true
  | none => false

def masterClaimIdHasDisposition (claimId : String)
    (disposition : ClaimDisposition) : Bool :=
  match masterClaimById? claimId with
  | some claim => decide (claim.disposition = disposition)
  | none => false

def masterClaimIdHasLeanDecl (claimId : String) : Bool :=
  match masterClaimById? claimId with
  | some claim => claimHasLeanDecl claim
  | none => false

def masterClaimIdHasGapId (claimId : String) : Bool :=
  match masterClaimById? claimId with
  | some claim => claimHasGapId claim
  | none => false

def stringListContains (xs : List String) (x : String) : Bool :=
  xs.any (fun y => y == x)

/-- Primary labelled hypotheses in the order used by the abstract, status box,
and conclusion of the master tex. -/
def primaryLabelledHypothesisIds : List String := [
  "hyp:HC-CM-Ab",
  "hyp:CM-correspondences",
  "hyp:KS-p3",
  "hyp:AH-CM-E7",
  "hyp:ChernWeil-bridge-E7",
  "hyp:BBT-rigid-reach",
  "hyp:nonrigid-family-bridge",
  "hyp:chow-modularity-E7",
  "hyp:hecke-bbt"
]

def primaryLabelledHypothesisCount : Nat :=
  primaryLabelledHypothesisIds.length

def primaryLabelledHypothesisMissingIds : List String :=
  primaryLabelledHypothesisIds.filter (fun claimId => ! masterClaimIdIsPresent claimId)

def primaryLabelledHypothesisMissingIdCount : Nat :=
  primaryLabelledHypothesisMissingIds.length

def allPrimaryLabelledHypothesesExist : Bool :=
  primaryLabelledHypothesisIds.all masterClaimIdIsPresent

def allPrimaryLabelledHypothesesAreOpenHypotheses : Bool :=
  primaryLabelledHypothesisIds.all
    (fun claimId => masterClaimIdHasDisposition claimId .openHypothesis)

def allPrimaryLabelledHypothesesHaveLeanDecl : Bool :=
  primaryLabelledHypothesisIds.all masterClaimIdHasLeanDecl

def allPrimaryLabelledHypothesesHaveGapId : Bool :=
  primaryLabelledHypothesisIds.all masterClaimIdHasGapId

def primaryLabelledHypothesesCoverOpenHypothesisClaims : Bool :=
  openHypothesisClaimIds.all
    (fun claimId => stringListContains primaryLabelledHypothesisIds claimId)

def openHypothesisClaimsCoverPrimaryLabelledHypotheses : Bool :=
  primaryLabelledHypothesisIds.all
    (fun claimId => stringListContains openHypothesisClaimIds claimId)

def paperInventoryBoolFailureCount (b : Bool) : Nat :=
  if b then 0 else 1

def primaryLabelledHypothesisDisciplineFailureCount : Nat :=
  paperInventoryBoolFailureCount (primaryLabelledHypothesisCount == 9) +
    primaryLabelledHypothesisMissingIdCount +
      paperInventoryBoolFailureCount allPrimaryLabelledHypothesesExist +
        paperInventoryBoolFailureCount allPrimaryLabelledHypothesesAreOpenHypotheses +
          paperInventoryBoolFailureCount allPrimaryLabelledHypothesesHaveLeanDecl +
            paperInventoryBoolFailureCount allPrimaryLabelledHypothesesHaveGapId +
              paperInventoryBoolFailureCount primaryLabelledHypothesesCoverOpenHypothesisClaims +
                paperInventoryBoolFailureCount openHypothesisClaimsCoverPrimaryLabelledHypotheses

/-- R628 status rows for the four sub-classes in the abstract Scope paragraph.
The status strings are intentionally precise: they distinguish unconditional
sub-arguments from inherited conditional machinery. -/
def masterScopeSubclassStatusEntries : List MasterScopeSubclassStatus := [
  { id := "scope-i-classical-no-e6-e7"
    summaryStatus := "conditional"
    line := 193
    masterClaimIds := [
      "thm:general-variety-reduction",
      "prop:coverage",
      "thm:HCab",
      "cor:Ab_covers",
      "thm:GLB_full",
      "cor:Orth_covers",
      "input:motivic-span"
    ]
    routeGapIds := [
      "G-main-hc",
      "G-l4-cm-abelian-hc",
      "G-l4-mt-correspondence",
      "G-master-paper-import"
    ]
    leanDecls := [
      "HodgeReduction.hc_real_classical_cartan",
      "HodgeReduction.hyp_HC_CM_Ab_real",
      "HodgeReduction.KugaSatakeP3Data.ks_p3_from_spin_hodge_and_correspondence",
      "HodgeReduction.RankTwoCMCY3CorrespondenceData.algebraicity_from_rank_two_cm_cy3_hypothesis"
    ]
    notes := "Classical/no-E6E7 scope is conditional on the CM abelian, KS-(p,3), CM-CY3 correspondence, Schur-bypass, and import-debt inputs named in the abstract." },
  { id := "scope-ii-e6-factor"
    summaryStatus := "e6-factor-unconditional-other-factors-inherit-conditional"
    line := 210
    masterClaimIds := [
      "thm:E6_chernweil",
      "prop:exc_covered"
    ]
    routeGapIds := [
      "G-main-hc",
      "G-master-paper-import",
      "G-classical-mathlib-port"
    ]
    leanDecls := [
      "HodgeReduction.hc_real_e6_case",
      "HodgeReduction.HCGapL4.E6CaseClassicalBridge.e6_factor_classical_transfer",
      "HodgeReduction.HCGapL4.E6CaseClassicalBridge.e6_remainder_transfer"
    ]
    notes := "Only the E6 factor contribution is recorded as unconditional by weight-parity vacuity; any other simple MT factor inherits the status of its own branch." },
  { id := "scope-iii-known-e7"
    summaryStatus := "conditional"
    line := 215
    masterClaimIds := [
      "thm:E7_chernweil",
      "cor:E7_shimura_closed",
      "thm:E7_scope",
      "cor:E7_full_closure",
      "cor:hc-conditional-nonrigid-e7"
    ]
    routeGapIds := [
      "G-main-hc",
      "G-l4-mt-correspondence",
      "G-l4-cm-abelian-hc",
      "G-master-paper-import",
      "G-full-hc"
    ]
    leanDecls := [
      "HodgeReduction.hc_real_e7_shimura",
      "HodgeReduction.mt_correspondence_e7_reduction",
      "HodgeReduction.thm_subcase3b_vacuous",
      "HodgeReduction.d5_e7_general_type_blocked_via_non_p1_only"
    ]
    notes := "Known E7 cases are conditional on the E7 Chern-Weil, AH-CM-E7, rigid-reach, nonrigid-family, Chow-modularity, and Hecke-BBT inputs." },
  { id := "scope-iv-cy3-reducible-exotic-e7"
    summaryStatus := "cy3-nonexistence-unconditional-e7-machinery-inherited-conditional"
    line := 236
    masterClaimIds := [
      "thm:cy3-e7-nonexistence",
      "cor:E7_full_closure"
    ]
    routeGapIds := [
      "G-main-hc",
      "G-full-hc",
      "G-classical-mathlib-port"
    ]
    leanDecls := [
      "HodgeReduction.thm_cy3_e7_nonexistence",
      "HodgeReduction.hc_real_cy3_reducible"
    ]
    notes := "The CY3 non-existence sub-argument is recorded as an unconditional elimination, but the surrounding E7 closure machinery remains inherited from the conditional known-E7 branch." }
]

def masterScopeSubclassStatusIds : List String :=
  masterScopeSubclassStatusEntries.map (fun row => row.id)

def masterScopeSubclassSummaryStatuses : List String :=
  masterScopeSubclassStatusEntries.map (fun row => row.summaryStatus)

def masterScopeSubclassStatusLines : List Nat :=
  masterScopeSubclassStatusEntries.map (fun row => row.line)

def masterScopeSubclassStatusCount : Nat :=
  masterScopeSubclassStatusEntries.length

def allowedMasterScopeSubclassSummaryStatuses : List String := [
  "conditional",
  "e6-factor-unconditional-other-factors-inherit-conditional",
  "cy3-nonexistence-unconditional-e7-machinery-inherited-conditional"
]

def masterScopeSubclassSummaryStatusAllowed
    (row : MasterScopeSubclassStatus) : Bool :=
  allowedMasterScopeSubclassSummaryStatuses.any
    (fun status => status == row.summaryStatus)

def masterScopeSubclassStatusesWithUnknownSummaryStatus :
    List MasterScopeSubclassStatus :=
  masterScopeSubclassStatusEntries.filter
    (fun row => ! masterScopeSubclassSummaryStatusAllowed row)

def masterScopeSubclassStatusesWithUnknownSummaryStatusCount : Nat :=
  masterScopeSubclassStatusesWithUnknownSummaryStatus.length

def allMasterScopeSubclassSummaryStatusesAllowed : Bool :=
  masterScopeSubclassStatusEntries.all masterScopeSubclassSummaryStatusAllowed

def masterScopeSubclassStatusesWithoutLeanDecl :
    List MasterScopeSubclassStatus :=
  masterScopeSubclassStatusEntries.filter (fun row => row.leanDecls.isEmpty)

def masterScopeSubclassStatusesWithoutLeanDeclCount : Nat :=
  masterScopeSubclassStatusesWithoutLeanDecl.length

def allMasterScopeSubclassStatusesHaveLeanDecl : Bool :=
  masterScopeSubclassStatusEntries.all (fun row => ! row.leanDecls.isEmpty)

def masterScopeSubclassStatusesWithoutMasterClaimId :
    List MasterScopeSubclassStatus :=
  masterScopeSubclassStatusEntries.filter (fun row => row.masterClaimIds.isEmpty)

def masterScopeSubclassStatusesWithoutMasterClaimIdCount : Nat :=
  masterScopeSubclassStatusesWithoutMasterClaimId.length

def allMasterScopeSubclassStatusesHaveMasterClaimId : Bool :=
  masterScopeSubclassStatusEntries.all (fun row => ! row.masterClaimIds.isEmpty)

def allMasterScopeSubclassMasterClaimIdsExist : Bool :=
  masterScopeSubclassStatusEntries.all
    (fun row => row.masterClaimIds.all masterClaimIdIsPresent)

def masterScopeSubclassStatusesWithoutRouteGapId :
    List MasterScopeSubclassStatus :=
  masterScopeSubclassStatusEntries.filter (fun row => row.routeGapIds.isEmpty)

def masterScopeSubclassStatusesWithoutRouteGapIdCount : Nat :=
  masterScopeSubclassStatusesWithoutRouteGapId.length

def allMasterScopeSubclassStatusesHaveRouteGapId : Bool :=
  masterScopeSubclassStatusEntries.all (fun row => ! row.routeGapIds.isEmpty)

def masterScopeSubclassStatusFailureCount : Nat :=
  paperInventoryBoolFailureCount (masterScopeSubclassStatusCount == 4) +
    masterScopeSubclassStatusesWithUnknownSummaryStatusCount +
      paperInventoryBoolFailureCount allMasterScopeSubclassSummaryStatusesAllowed +
        masterScopeSubclassStatusesWithoutLeanDeclCount +
          paperInventoryBoolFailureCount allMasterScopeSubclassStatusesHaveLeanDecl +
            masterScopeSubclassStatusesWithoutMasterClaimIdCount +
              paperInventoryBoolFailureCount allMasterScopeSubclassStatusesHaveMasterClaimId +
                paperInventoryBoolFailureCount allMasterScopeSubclassMasterClaimIdsExist +
                  masterScopeSubclassStatusesWithoutRouteGapIdCount +
                    paperInventoryBoolFailureCount allMasterScopeSubclassStatusesHaveRouteGapId

def formalizedClaimsWithoutLeanDecl : List PaperClaim :=
  formalizedClaims.filter (fun c => ! claimHasLeanDecl c)

def formalizedClaimsWithoutLeanDeclCount : Nat :=
  formalizedClaimsWithoutLeanDecl.length

def allFormalizedClaimsHaveLeanDecl : Bool :=
  formalizedClaims.all claimHasLeanDecl

def kernelOnlyClaimsWithoutLeanDecl : List PaperClaim :=
  kernelOnlyLeanClaims.filter (fun c => ! claimHasLeanDecl c)

def kernelOnlyClaimsWithoutLeanDeclCount : Nat :=
  kernelOnlyClaimsWithoutLeanDecl.length

def allKernelOnlyClaimsHaveLeanDecl : Bool :=
  kernelOnlyLeanClaims.all claimHasLeanDecl

def registeredGapClaimsWithoutGapId : List PaperClaim :=
  registeredGapClaims.filter (fun c => ! claimHasGapId c)

def registeredGapClaimsWithoutGapIdCount : Nat :=
  registeredGapClaimsWithoutGapId.length

def allRegisteredGapClaimsHaveGapId : Bool :=
  registeredGapClaims.all claimHasGapId

def openHypothesisClaimsWithoutGapId : List PaperClaim :=
  openHypothesisClaims.filter (fun c => ! claimHasGapId c)

def openHypothesisClaimsWithoutGapIdCount : Nat :=
  openHypothesisClaimsWithoutGapId.length

def allOpenHypothesisClaimsHaveGapId : Bool :=
  openHypothesisClaims.all claimHasGapId

def openResidualClaimsWithoutGapId : List PaperClaim :=
  openResidualClaims.filter (fun c => ! claimHasGapId c)

def openResidualClaimsWithoutGapIdCount : Nat :=
  openResidualClaimsWithoutGapId.length

def allOpenResidualClaimsHaveGapId : Bool :=
  openResidualClaims.all claimHasGapId

def newMathGapClaimsWithoutGapId : List PaperClaim :=
  newMathGapClaims.filter (fun c => ! claimHasGapId c)

def newMathGapClaimsWithoutGapIdCount : Nat :=
  newMathGapClaimsWithoutGapId.length

def allNewMathGapClaimsHaveGapId : Bool :=
  newMathGapClaims.all claimHasGapId

def knownSourceIds : List String :=
  allSources.map (fun s => s.id)

def sourceIdIsKnown (sourceId : String) : Bool :=
  knownSourceIds.any (fun knownId => knownId == sourceId)

def claimSourceIdIsKnown (c : PaperClaim) : Bool :=
  sourceIdIsKnown c.sourceId

def masterClaimsWithUnknownSourceId : List PaperClaim :=
  masterClaims.filter (fun c => ! claimSourceIdIsKnown c)

def masterClaimsWithUnknownSourceIdCount : Nat :=
  masterClaimsWithUnknownSourceId.length

def allMasterClaimSourceIdsKnown : Bool :=
  masterClaims.all claimSourceIdIsKnown

def claimUsesCanonicalMasterSource (c : PaperClaim) : Bool :=
  c.sourceId == canonicalMasterSource.id

def masterClaimsOutsideCanonicalSource : List PaperClaim :=
  masterClaims.filter (fun c => ! claimUsesCanonicalMasterSource c)

def masterClaimsOutsideCanonicalSourceCount : Nat :=
  masterClaimsOutsideCanonicalSource.length

def allMasterClaimsUseCanonicalMasterSource : Bool :=
  masterClaims.all claimUsesCanonicalMasterSource

def canonicalMasterSourcePathIsMasterTex : Bool :=
  canonicalMasterSource.path == "../contributions/hodge-conjecture-master-proof.tex"

def canonicalMasterSourceRoleIsCanonical : Bool :=
  decide (canonicalMasterSource.role = .canonicalMaster)

def archivedBackgroundSourceCount : Nat :=
  archivedBackgroundSources.length

def allArchivedBackgroundSourcesHaveArchiveRole : Bool :=
  archivedBackgroundSources.all
    (fun source => decide (source.role = .archivedBackground))

def claimHasEffectiveAuditTagValue (c : PaperClaim) (t : ClaimAuditTag) : Bool :=
  (effectiveAuditTags c).any (fun u => decide (u = t))

/-- Exact broken-link predicates that appear in the master-paper import ledger.
These are not proofs; they are named anchors for still-open or still-unported
steps that the paper must not narrate as closed. -/
def brokenLinkLeanDeclNames : List String := [
  "HodgeReduction.IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK",
  "HodgeReduction.IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK",
  "HodgeReduction.IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK"
]

def claimReferencesLeanDecl (declName : String) (c : PaperClaim) : Bool :=
  c.leanDecls.any (fun registeredName => registeredName == declName)

def claimReferencesAnyLeanDecl (declNames : List String) (c : PaperClaim) : Bool :=
  declNames.any (fun declName => claimReferencesLeanDecl declName c)

def brokenLinkClaims : List PaperClaim :=
  masterClaims.filter (claimReferencesAnyLeanDecl brokenLinkLeanDeclNames)

def brokenLinkClaimIds : List String :=
  claimIds brokenLinkClaims

def brokenLinkDeclNamesReferencedByMasterClaim : List String :=
  brokenLinkLeanDeclNames.filter
    (fun declName => masterClaims.any (claimReferencesLeanDecl declName))

def brokenLinkDeclNamesMissingMasterClaim : List String :=
  brokenLinkLeanDeclNames.filter
    (fun declName => ! masterClaims.any (claimReferencesLeanDecl declName))

def allBrokenLinkDeclsReferencedByMasterClaim : Bool :=
  brokenLinkDeclNamesMissingMasterClaim.isEmpty

def claimDispositionAllowsBrokenLink (c : PaperClaim) : Bool :=
  decide (c.disposition = .registeredGap) ||
    decide (c.disposition = .openHypothesis) ||
      decide (c.disposition = .openResidual)

def brokenLinkClaimsWithoutOpenOrGapDisposition : List PaperClaim :=
  brokenLinkClaims.filter (fun c => ! claimDispositionAllowsBrokenLink c)

def brokenLinkClaimsWithoutOpenOrGapDispositionCount : Nat :=
  brokenLinkClaimsWithoutOpenOrGapDisposition.length

def allBrokenLinkClaimsHaveOpenOrGapDisposition : Bool :=
  brokenLinkClaims.all claimDispositionAllowsBrokenLink

def brokenLinkClaimsWithoutNewMathGapTag : List PaperClaim :=
  brokenLinkClaims.filter
    (fun c => ! claimHasEffectiveAuditTagValue c .newMathGap)

def brokenLinkClaimsWithoutNewMathGapTagCount : Nat :=
  brokenLinkClaimsWithoutNewMathGapTag.length

def allBrokenLinkClaimsTaggedNewMathGap : Bool :=
  brokenLinkClaims.all
    (fun c => claimHasEffectiveAuditTagValue c .newMathGap)

/-- Exact R626 status markers for master-tex sub-gap status prose.

This is not the full sub-gap inventory.  It is the smaller list of explicit
`gapOpen` / `gapPartial` / `gapBlocked` status claims currently made in the
canonical master tex, so those prose claims cannot drift silently from Lean. -/
def masterSubgapStatusMarkers : List MasterSubgapStatusMarker := [
  { id := "SG-17"
    status := "gapPartial"
    line := 5616
    masterClaimIds := ["thm:sg17-partial-kill"]
    leanDecls := [
      "HodgeReduction.IsResidual3DivLambdaPrimeClosure_sg17_CONJECTURAL",
      "HodgeReduction.sg17_from_framework_and_extension",
      "HodgeReduction.sg_17_closed"
    ]
    notes := "The residual 3-divisible lambda-prime stratum remains conjectural; the partial-kill theorem is not an unconditional SG-17 closure." },
  { id := "open:exotic-residual-kappa0"
    status := "gapBlocked"
    line := 9186
    masterClaimIds := ["open:exotic-residual"]
    leanDecls := [
      "HodgeReduction.IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK",
      "HodgeReduction.IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK",
      "HodgeReduction.exotic_residual_kappa_zero_subcase_closed_conditional"
    ]
    notes := "The kappa=0 exotic residual has only a conditional broken-link bridge; the unconditional status remains blocked." },
  { id := "SG-21"
    status := "gapPartial"
    line := 13404
    leanDecls := [
      "HodgeReduction.sg21_reduces_to_ah_cm_e7_or_sg20_mt",
      "HodgeReduction.sg_21_closed"
    ]
    notes := "The compatibility item reduces to AH-CM-E7 or SG-20 MT input and is not a separate unconditional input." },
  { id := "SG-15b"
    status := "gapOpen"
    line := 13876
    leanDecls := [
      "HodgeReduction.IsHodgeBidegreeWeightFiltrationCutsTrivialSummand_sg15b"
    ]
    notes := "The Hodge-bidegree weight-filtration ingredient remains the open invention-class part." },
  { id := "SG-15"
    status := "gapPartial"
    line := 13899
    leanDecls := [
      "HodgeReduction.sg15_from_ingredients",
      "HodgeReduction.sg15_via_R42_dim_counting",
      "HodgeReduction.sg_15_closed"
    ]
    notes := "The alternate dim-counting route gives a conditional partial status under the SG-5 hypothesis, while SG-15b remains open." },
  { id := "SG-16"
    status := "gapPartial"
    line := 13899
    leanDecls := [
      "HodgeReduction.sg16_reduces_to_sg15_ingredients",
      "HodgeReduction.sg16_via_R42_dim_counting",
      "HodgeReduction.sg_16_closed"
    ]
    notes := "The dim-5 Casimir item shares the SG-15a/SG-15b reduction and the conditional dim-counting bypass." }
]

def masterSubgapStatusMarkerIds : List String :=
  masterSubgapStatusMarkers.map (fun marker => marker.id)

def masterSubgapStatusMarkerLines : List Nat :=
  masterSubgapStatusMarkers.map (fun marker => marker.line)

def masterSubgapStatusMarkerCount : Nat :=
  masterSubgapStatusMarkers.length

def masterSubgapStatusMarkerStatusCount (status : String) : Nat :=
  (masterSubgapStatusMarkers.filter (fun marker => marker.status == status)).length

def allowedMasterSubgapStatusValues : List String :=
  ["gapOpen", "gapPartial", "gapBlocked"]

def masterSubgapStatusMarkerHasAllowedStatus
    (marker : MasterSubgapStatusMarker) : Bool :=
  allowedMasterSubgapStatusValues.any
    (fun allowedStatus => allowedStatus == marker.status)

def masterSubgapStatusMarkersWithUnknownStatus : List MasterSubgapStatusMarker :=
  masterSubgapStatusMarkers.filter
    (fun marker => ! masterSubgapStatusMarkerHasAllowedStatus marker)

def masterSubgapStatusMarkersWithUnknownStatusCount : Nat :=
  masterSubgapStatusMarkersWithUnknownStatus.length

def allMasterSubgapStatusMarkersHaveAllowedStatus : Bool :=
  masterSubgapStatusMarkers.all masterSubgapStatusMarkerHasAllowedStatus

def masterSubgapStatusMarkersWithoutLeanDecl : List MasterSubgapStatusMarker :=
  masterSubgapStatusMarkers.filter (fun marker => marker.leanDecls.isEmpty)

def masterSubgapStatusMarkersWithoutLeanDeclCount : Nat :=
  masterSubgapStatusMarkersWithoutLeanDecl.length

def allMasterSubgapStatusMarkersHaveLeanDecl : Bool :=
  masterSubgapStatusMarkers.all (fun marker => ! marker.leanDecls.isEmpty)

def claimHasAnyOpenOrUnportedTag (c : PaperClaim) : Bool :=
  claimHasEffectiveAuditTagValue c .paperProofNotKernelPorted ||
    claimHasEffectiveAuditTagValue c .externalCitationNotKernelPorted ||
      claimHasEffectiveAuditTagValue c .newMathGap

def formalizedClaimsWithOpenOrUnportedTag : List PaperClaim :=
  formalizedClaims.filter claimHasAnyOpenOrUnportedTag

def formalizedClaimsWithOpenOrUnportedTagCount : Nat :=
  formalizedClaimsWithOpenOrUnportedTag.length

def allFormalizedClaimsAvoidOpenOrUnportedTags : Bool :=
  formalizedClaims.all (fun c => ! claimHasAnyOpenOrUnportedTag c)

def openHypothesisClaimsWithoutNewMathGapTag : List PaperClaim :=
  openHypothesisClaims.filter
    (fun c => ! claimHasEffectiveAuditTagValue c .newMathGap)

def openHypothesisClaimsWithoutNewMathGapTagCount : Nat :=
  openHypothesisClaimsWithoutNewMathGapTag.length

def allOpenHypothesisClaimsTaggedNewMathGap : Bool :=
  openHypothesisClaims.all
    (fun c => claimHasEffectiveAuditTagValue c .newMathGap)

def openResidualClaimsWithoutNewMathGapTag : List PaperClaim :=
  openResidualClaims.filter
    (fun c => ! claimHasEffectiveAuditTagValue c .newMathGap)

def openResidualClaimsWithoutNewMathGapTagCount : Nat :=
  openResidualClaimsWithoutNewMathGapTag.length

def allOpenResidualClaimsTaggedNewMathGap : Bool :=
  openResidualClaims.all
    (fun c => claimHasEffectiveAuditTagValue c .newMathGap)

def registeredGapClaimsWithoutMigrationDebtTag : List PaperClaim :=
  registeredGapClaims.filter
    (fun c => ! claimHasEffectiveAuditTagValue c .migrationDebt)

def registeredGapClaimsWithoutMigrationDebtTagCount : Nat :=
  registeredGapClaimsWithoutMigrationDebtTag.length

def allRegisteredGapClaimsTaggedMigrationDebt : Bool :=
  registeredGapClaims.all
    (fun c => claimHasEffectiveAuditTagValue c .migrationDebt)

def conditionalMilestoneClaimsWithoutConditionalLeanPackageTag :
    List PaperClaim :=
  conditionalMilestoneClaims.filter
    (fun c => ! claimHasEffectiveAuditTagValue c .conditionalLeanPackage)

def conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount : Nat :=
  conditionalMilestoneClaimsWithoutConditionalLeanPackageTag.length

def allConditionalMilestoneClaimsTaggedConditionalLeanPackage : Bool :=
  conditionalMilestoneClaims.all
    (fun c => claimHasEffectiveAuditTagValue c .conditionalLeanPackage)

/-- Machine-audited discipline between dispositions and semantic audit tags.

R615 checks that the relevant pointers exist.  R616 checks that the tags do not
change the meaning of the disposition: formalized claims must not be tagged as
open/unported, and open/gap/conditional dispositions must carry their matching
semantic tags. -/
structure MasterClaimDispositionTagDisciplineSnapshot where
  allFormalizedClaimsAvoidOpenOrUnportedTags : Bool
  formalizedClaimsWithOpenOrUnportedTagCount : Nat
  allOpenHypothesisClaimsTaggedNewMathGap : Bool
  openHypothesisClaimsWithoutNewMathGapTagCount : Nat
  allOpenResidualClaimsTaggedNewMathGap : Bool
  openResidualClaimsWithoutNewMathGapTagCount : Nat
  allRegisteredGapClaimsTaggedMigrationDebt : Bool
  registeredGapClaimsWithoutMigrationDebtTagCount : Nat
  allConditionalMilestoneClaimsTaggedConditionalLeanPackage : Bool
  conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount : Nat
  needsTriageCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterClaimDispositionTagDisciplineSnapshot :
    MasterClaimDispositionTagDisciplineSnapshot where
  allFormalizedClaimsAvoidOpenOrUnportedTags :=
    allFormalizedClaimsAvoidOpenOrUnportedTags
  formalizedClaimsWithOpenOrUnportedTagCount :=
    formalizedClaimsWithOpenOrUnportedTagCount
  allOpenHypothesisClaimsTaggedNewMathGap :=
    allOpenHypothesisClaimsTaggedNewMathGap
  openHypothesisClaimsWithoutNewMathGapTagCount :=
    openHypothesisClaimsWithoutNewMathGapTagCount
  allOpenResidualClaimsTaggedNewMathGap :=
    allOpenResidualClaimsTaggedNewMathGap
  openResidualClaimsWithoutNewMathGapTagCount :=
    openResidualClaimsWithoutNewMathGapTagCount
  allRegisteredGapClaimsTaggedMigrationDebt :=
    allRegisteredGapClaimsTaggedMigrationDebt
  registeredGapClaimsWithoutMigrationDebtTagCount :=
    registeredGapClaimsWithoutMigrationDebtTagCount
  allConditionalMilestoneClaimsTaggedConditionalLeanPackage :=
    allConditionalMilestoneClaimsTaggedConditionalLeanPackage
  conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount :=
    conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount
  needsTriageCount := needsTriageCount

/-- R625 discipline for broken-link predicates named by the master paper.

Every broken-link predicate must be attached to an explicit master-paper claim,
and those claims must remain open/gap-facing with a new-math tag. -/
structure MasterBrokenLinkDisciplineSnapshot where
  brokenLinkDeclNames : List String
  brokenLinkDeclNamesReferencedByMasterClaim : List String
  brokenLinkDeclNamesMissingMasterClaim : List String
  brokenLinkClaimIds : List String
  brokenLinkDeclCount : Nat
  brokenLinkReferencedDeclCount : Nat
  brokenLinkClaimCount : Nat
  allBrokenLinkDeclsReferencedByMasterClaim : Bool
  allBrokenLinkClaimsHaveOpenOrGapDisposition : Bool
  brokenLinkClaimsWithoutOpenOrGapDispositionCount : Nat
  allBrokenLinkClaimsTaggedNewMathGap : Bool
  brokenLinkClaimsWithoutNewMathGapTagCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterBrokenLinkDisciplineSnapshot :
    MasterBrokenLinkDisciplineSnapshot where
  brokenLinkDeclNames := brokenLinkLeanDeclNames
  brokenLinkDeclNamesReferencedByMasterClaim :=
    brokenLinkDeclNamesReferencedByMasterClaim
  brokenLinkDeclNamesMissingMasterClaim := brokenLinkDeclNamesMissingMasterClaim
  brokenLinkClaimIds := brokenLinkClaimIds
  brokenLinkDeclCount := brokenLinkLeanDeclNames.length
  brokenLinkReferencedDeclCount :=
    brokenLinkDeclNamesReferencedByMasterClaim.length
  brokenLinkClaimCount := brokenLinkClaims.length
  allBrokenLinkDeclsReferencedByMasterClaim :=
    allBrokenLinkDeclsReferencedByMasterClaim
  allBrokenLinkClaimsHaveOpenOrGapDisposition :=
    allBrokenLinkClaimsHaveOpenOrGapDisposition
  brokenLinkClaimsWithoutOpenOrGapDispositionCount :=
    brokenLinkClaimsWithoutOpenOrGapDispositionCount
  allBrokenLinkClaimsTaggedNewMathGap := allBrokenLinkClaimsTaggedNewMathGap
  brokenLinkClaimsWithoutNewMathGapTagCount :=
    brokenLinkClaimsWithoutNewMathGapTagCount

/-- R626 discipline for explicit master-tex sub-gap status markers. -/
structure MasterSubgapStatusMarkerSnapshot where
  markerIds : List String
  markerLines : List Nat
  markerCount : Nat
  gapOpenCount : Nat
  gapPartialCount : Nat
  gapBlockedCount : Nat
  allMarkersHaveAllowedStatus : Bool
  markersWithUnknownStatusCount : Nat
  allMarkersHaveLeanDecl : Bool
  markersWithoutLeanDeclCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterSubgapStatusMarkerSnapshot :
    MasterSubgapStatusMarkerSnapshot where
  markerIds := masterSubgapStatusMarkerIds
  markerLines := masterSubgapStatusMarkerLines
  markerCount := masterSubgapStatusMarkerCount
  gapOpenCount := masterSubgapStatusMarkerStatusCount "gapOpen"
  gapPartialCount := masterSubgapStatusMarkerStatusCount "gapPartial"
  gapBlockedCount := masterSubgapStatusMarkerStatusCount "gapBlocked"
  allMarkersHaveAllowedStatus :=
    allMasterSubgapStatusMarkersHaveAllowedStatus
  markersWithUnknownStatusCount :=
    masterSubgapStatusMarkersWithUnknownStatusCount
  allMarkersHaveLeanDecl := allMasterSubgapStatusMarkersHaveLeanDecl
  markersWithoutLeanDeclCount :=
    masterSubgapStatusMarkersWithoutLeanDeclCount

/-- Machine-audited source discipline for the master-paper import.

R618 records that the master tex is the sole canonical import surface; other
tex families remain archive/background unless promoted into the master file. -/
structure MasterSourceDisciplineSnapshot where
  knownSourceCount : Nat
  archivedBackgroundSourceCount : Nat
  canonicalMasterSourcePathIsMasterTex : Bool
  canonicalMasterSourceRoleIsCanonical : Bool
  allArchivedBackgroundSourcesHaveArchiveRole : Bool
  allMasterClaimSourceIdsKnown : Bool
  masterClaimsWithUnknownSourceIdCount : Nat
  allMasterClaimsUseCanonicalMasterSource : Bool
  masterClaimsOutsideCanonicalSourceCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterSourceDisciplineSnapshot :
    MasterSourceDisciplineSnapshot where
  knownSourceCount := allSources.length
  archivedBackgroundSourceCount := archivedBackgroundSourceCount
  canonicalMasterSourcePathIsMasterTex := canonicalMasterSourcePathIsMasterTex
  canonicalMasterSourceRoleIsCanonical := canonicalMasterSourceRoleIsCanonical
  allArchivedBackgroundSourcesHaveArchiveRole :=
    allArchivedBackgroundSourcesHaveArchiveRole
  allMasterClaimSourceIdsKnown := allMasterClaimSourceIdsKnown
  masterClaimsWithUnknownSourceIdCount := masterClaimsWithUnknownSourceIdCount
  allMasterClaimsUseCanonicalMasterSource :=
    allMasterClaimsUseCanonicalMasterSource
  masterClaimsOutsideCanonicalSourceCount :=
    masterClaimsOutsideCanonicalSourceCount

/-- Machine-audited coverage discipline for theorem-like master environments.

R619 checks that every indexed theorem-like environment has exactly one
paper-claim entry and that the Lean-side claim kind matches the master-tex
environment kind.  The six remaining claims are load-bearing input/remark
items outside the theorem-like environment index. -/
structure MasterEnvironmentCoverageDisciplineSnapshot where
  masterEnvironmentCount : Nat
  masterClaimCount : Nat
  claimedMasterEnvironmentCount : Nat
  unclaimedMasterEnvironmentCount : Nat
  allMasterEnvironmentsHaveUniqueClaim : Bool
  masterEnvironmentsWithoutUniqueClaimCount : Nat
  allClaimedMasterEnvironmentKindsMatch : Bool
  masterEnvironmentsWithKindMismatchCount : Nat
  masterClaimsNotCoveringMasterEnvironmentCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterEnvironmentCoverageDisciplineSnapshot :
    MasterEnvironmentCoverageDisciplineSnapshot where
  masterEnvironmentCount := masterEnvironmentCount
  masterClaimCount := masterClaimCount
  claimedMasterEnvironmentCount := claimedMasterEnvironmentCount
  unclaimedMasterEnvironmentCount := unclaimedMasterEnvironmentCount
  allMasterEnvironmentsHaveUniqueClaim :=
    allMasterEnvironmentsHaveUniqueClaim
  masterEnvironmentsWithoutUniqueClaimCount :=
    masterEnvironmentsWithoutUniqueClaimCount
  allClaimedMasterEnvironmentKindsMatch :=
    allClaimedMasterEnvironmentKindsMatch
  masterEnvironmentsWithKindMismatchCount :=
    masterEnvironmentsWithKindMismatchCount
  masterClaimsNotCoveringMasterEnvironmentCount :=
    masterClaimsNotCoveringMasterEnvironmentCount

/-- Exact claim-id worklists for the master-paper import debt.

R622 fixes which master claims still rely on paper proofs, external citations,
new mathematics, migration debt, or open/gap dispositions.  This complements
the numeric R614--R621 guards: the paper should not merely say how many items
remain; it should have a kernel-checked list of which items remain. -/
structure MasterClaimWorklistSnapshot where
  registeredGapClaimIds : List String
  openHypothesisClaimIds : List String
  openResidualClaimIds : List String
  conditionalMilestoneClaimIds : List String
  paperProofNotKernelPortedClaimIds : List String
  externalCitationNotKernelPortedClaimIds : List String
  newMathGapClaimIds : List String
  migrationDebtClaimIds : List String
  deriving Repr, DecidableEq, Inhabited

def currentMasterClaimWorklistSnapshot : MasterClaimWorklistSnapshot where
  registeredGapClaimIds := registeredGapClaimIds
  openHypothesisClaimIds := openHypothesisClaimIds
  openResidualClaimIds := openResidualClaimIds
  conditionalMilestoneClaimIds := conditionalMilestoneClaimIds
  paperProofNotKernelPortedClaimIds := paperProofNotKernelPortedClaimIds
  externalCitationNotKernelPortedClaimIds :=
    externalCitationNotKernelPortedClaimIds
  newMathGapClaimIds := newMathGapClaimIds
  migrationDebtClaimIds := migrationDebtClaimIds

/-- Exact primary labelled hypothesis list used by the paper's summary prose.

R627 separates the ordered summary list in the abstract/status box/conclusion
from the source-order `openHypothesisClaimIds` worklist, while checking that
the two lists contain exactly the same nine open-hypothesis claims. -/
structure MasterPrimaryHypothesisSnapshot where
  primaryLabelledHypothesisIds : List String
  primaryLabelledHypothesisCount : Nat
  openHypothesisClaimIds : List String
  openHypothesisClaimCount : Nat
  primaryLabelledHypothesisMissingIdCount : Nat
  allPrimaryLabelledHypothesesExist : Bool
  allPrimaryLabelledHypothesesAreOpenHypotheses : Bool
  allPrimaryLabelledHypothesesHaveLeanDecl : Bool
  allPrimaryLabelledHypothesesHaveGapId : Bool
  primaryLabelledHypothesesCoverOpenHypothesisClaims : Bool
  openHypothesisClaimsCoverPrimaryLabelledHypotheses : Bool
  primaryLabelledHypothesisDisciplineFailureCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterPrimaryHypothesisSnapshot :
    MasterPrimaryHypothesisSnapshot where
  primaryLabelledHypothesisIds := primaryLabelledHypothesisIds
  primaryLabelledHypothesisCount := primaryLabelledHypothesisCount
  openHypothesisClaimIds := openHypothesisClaimIds
  openHypothesisClaimCount := openHypothesisCount
  primaryLabelledHypothesisMissingIdCount :=
    primaryLabelledHypothesisMissingIdCount
  allPrimaryLabelledHypothesesExist := allPrimaryLabelledHypothesesExist
  allPrimaryLabelledHypothesesAreOpenHypotheses :=
    allPrimaryLabelledHypothesesAreOpenHypotheses
  allPrimaryLabelledHypothesesHaveLeanDecl :=
    allPrimaryLabelledHypothesesHaveLeanDecl
  allPrimaryLabelledHypothesesHaveGapId :=
    allPrimaryLabelledHypothesesHaveGapId
  primaryLabelledHypothesesCoverOpenHypothesisClaims :=
    primaryLabelledHypothesesCoverOpenHypothesisClaims
  openHypothesisClaimsCoverPrimaryLabelledHypotheses :=
    openHypothesisClaimsCoverPrimaryLabelledHypotheses
  primaryLabelledHypothesisDisciplineFailureCount :=
    primaryLabelledHypothesisDisciplineFailureCount

/-- R628 snapshot for the abstract/conclusion scope subclass status claims. -/
structure MasterScopeSubclassStatusSnapshot where
  scopeSubclassStatusIds : List String
  scopeSubclassSummaryStatuses : List String
  scopeSubclassStatusLines : List Nat
  scopeSubclassStatusCount : Nat
  allSummaryStatusesAllowed : Bool
  statusesWithUnknownSummaryStatusCount : Nat
  allStatusesHaveLeanDecl : Bool
  statusesWithoutLeanDeclCount : Nat
  allStatusesHaveMasterClaimId : Bool
  statusesWithoutMasterClaimIdCount : Nat
  allMasterClaimIdsExist : Bool
  allStatusesHaveRouteGapId : Bool
  statusesWithoutRouteGapIdCount : Nat
  scopeSubclassStatusFailureCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterScopeSubclassStatusSnapshot :
    MasterScopeSubclassStatusSnapshot where
  scopeSubclassStatusIds := masterScopeSubclassStatusIds
  scopeSubclassSummaryStatuses := masterScopeSubclassSummaryStatuses
  scopeSubclassStatusLines := masterScopeSubclassStatusLines
  scopeSubclassStatusCount := masterScopeSubclassStatusCount
  allSummaryStatusesAllowed := allMasterScopeSubclassSummaryStatusesAllowed
  statusesWithUnknownSummaryStatusCount :=
    masterScopeSubclassStatusesWithUnknownSummaryStatusCount
  allStatusesHaveLeanDecl := allMasterScopeSubclassStatusesHaveLeanDecl
  statusesWithoutLeanDeclCount :=
    masterScopeSubclassStatusesWithoutLeanDeclCount
  allStatusesHaveMasterClaimId :=
    allMasterScopeSubclassStatusesHaveMasterClaimId
  statusesWithoutMasterClaimIdCount :=
    masterScopeSubclassStatusesWithoutMasterClaimIdCount
  allMasterClaimIdsExist := allMasterScopeSubclassMasterClaimIdsExist
  allStatusesHaveRouteGapId := allMasterScopeSubclassStatusesHaveRouteGapId
  statusesWithoutRouteGapIdCount :=
    masterScopeSubclassStatusesWithoutRouteGapIdCount
  scopeSubclassStatusFailureCount := masterScopeSubclassStatusFailureCount

/-- Machine-audited discipline for the semantic claim tags.

This prevents the paper from saying "kernel-only" when no Lean declaration is
registered, or saying "gap/new math" when no route/gap id is registered. -/
structure MasterClaimTagDisciplineSnapshot where
  allFormalizedClaimsHaveLeanDecl : Bool
  formalizedClaimsWithoutLeanDeclCount : Nat
  allKernelOnlyClaimsHaveLeanDecl : Bool
  kernelOnlyClaimsWithoutLeanDeclCount : Nat
  allRegisteredGapClaimsHaveGapId : Bool
  registeredGapClaimsWithoutGapIdCount : Nat
  allOpenHypothesisClaimsHaveGapId : Bool
  openHypothesisClaimsWithoutGapIdCount : Nat
  allOpenResidualClaimsHaveGapId : Bool
  openResidualClaimsWithoutGapIdCount : Nat
  allNewMathGapClaimsHaveGapId : Bool
  newMathGapClaimsWithoutGapIdCount : Nat
  deriving Repr, DecidableEq, Inhabited

def currentMasterClaimTagDisciplineSnapshot :
    MasterClaimTagDisciplineSnapshot where
  allFormalizedClaimsHaveLeanDecl := allFormalizedClaimsHaveLeanDecl
  formalizedClaimsWithoutLeanDeclCount :=
    formalizedClaimsWithoutLeanDeclCount
  allKernelOnlyClaimsHaveLeanDecl := allKernelOnlyClaimsHaveLeanDecl
  kernelOnlyClaimsWithoutLeanDeclCount := kernelOnlyClaimsWithoutLeanDeclCount
  allRegisteredGapClaimsHaveGapId := allRegisteredGapClaimsHaveGapId
  registeredGapClaimsWithoutGapIdCount := registeredGapClaimsWithoutGapIdCount
  allOpenHypothesisClaimsHaveGapId := allOpenHypothesisClaimsHaveGapId
  openHypothesisClaimsWithoutGapIdCount := openHypothesisClaimsWithoutGapIdCount
  allOpenResidualClaimsHaveGapId := allOpenResidualClaimsHaveGapId
  openResidualClaimsWithoutGapIdCount := openResidualClaimsWithoutGapIdCount
  allNewMathGapClaimsHaveGapId := allNewMathGapClaimsHaveGapId
  newMathGapClaimsWithoutGapIdCount := newMathGapClaimsWithoutGapIdCount

/-- Machine-audited summary of the master-paper import ledger.

This is not a new mathematical theorem.  It is the Lean-side counterpart of
the master tex's summary-status paragraph, so headline paper claims about
"how much is kernel-only" or "how much remains import/gap debt" have a named
definition rather than an informal hand count. -/
structure MasterAuditSnapshot where
  masterEnvironmentCount : Nat
  masterClaimCount : Nat
  claimedMasterEnvironmentCount : Nat
  unclaimedMasterEnvironmentCount : Nat
  allMasterClaimsHaveEffectiveAuditTag : Bool
  untaggedMasterClaimCount : Nat
  allMasterClaimsHaveMachineCorrespondence : Bool
  claimsWithoutMachineCorrespondenceCount : Nat
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
  deriving Repr, DecidableEq, Inhabited

/-- Current master-paper import snapshot used by the master tex status box. -/
def currentMasterAuditSnapshot : MasterAuditSnapshot where
  masterEnvironmentCount := masterEnvironmentCount
  masterClaimCount := masterClaimCount
  claimedMasterEnvironmentCount := claimedMasterEnvironmentCount
  unclaimedMasterEnvironmentCount := unclaimedMasterEnvironmentCount
  allMasterClaimsHaveEffectiveAuditTag := allMasterClaimsHaveEffectiveAuditTag
  untaggedMasterClaimCount := untaggedMasterClaimCount
  allMasterClaimsHaveMachineCorrespondence :=
    allMasterClaimsHaveMachineCorrespondence
  claimsWithoutMachineCorrespondenceCount :=
    claimsWithoutMachineCorrespondenceCount
  formalizedClaimCount := formalizedClaimCount
  provenInPaperClaimCount := provenInPaperClaimCount
  conditionalMilestoneClaimCount := conditionalMilestoneClaimCount
  externalCitationClaimCount := externalCitationClaimCount
  registeredGapClaimCount := registeredGapClaimCount
  openHypothesisClaimCount := openHypothesisCount
  openResidualClaimCount := openResidualClaimCount
  archiveOnlyClaimCount := archiveOnlyClaimCount
  needsTriageCount := needsTriageCount
  kernelOnlyLeanClaimCount := kernelOnlyLeanClaimCount
  paperProofNotKernelPortedClaimCount := paperProofNotKernelPortedClaimCount
  externalCitationNotKernelPortedClaimCount := externalCitationNotKernelPortedClaimCount
  newMathGapClaimCount := newMathGapClaimCount
  migrationDebtClaimCount := migrationDebtClaimCount

set_option maxRecDepth 10000

/-- R615 kernel-checked discipline for paper-to-Lean semantic tags. -/
theorem currentMasterClaimTagDisciplineSnapshot_eq_texStatus :
    currentMasterClaimTagDisciplineSnapshot =
      ({ allFormalizedClaimsHaveLeanDecl := true
         formalizedClaimsWithoutLeanDeclCount := 0
         allKernelOnlyClaimsHaveLeanDecl := true
         kernelOnlyClaimsWithoutLeanDeclCount := 0
         allRegisteredGapClaimsHaveGapId := true
         registeredGapClaimsWithoutGapIdCount := 0
         allOpenHypothesisClaimsHaveGapId := true
         openHypothesisClaimsWithoutGapIdCount := 0
         allOpenResidualClaimsHaveGapId := true
         openResidualClaimsWithoutGapIdCount := 0
         allNewMathGapClaimsHaveGapId := true
         newMathGapClaimsWithoutGapIdCount := 0 } :
        MasterClaimTagDisciplineSnapshot) := by
  decide

/-- R616 kernel-checked discipline between claim dispositions and audit tags. -/
theorem currentMasterClaimDispositionTagDisciplineSnapshot_eq_texStatus :
    currentMasterClaimDispositionTagDisciplineSnapshot =
      ({ allFormalizedClaimsAvoidOpenOrUnportedTags := true
         formalizedClaimsWithOpenOrUnportedTagCount := 0
         allOpenHypothesisClaimsTaggedNewMathGap := true
         openHypothesisClaimsWithoutNewMathGapTagCount := 0
         allOpenResidualClaimsTaggedNewMathGap := true
         openResidualClaimsWithoutNewMathGapTagCount := 0
         allRegisteredGapClaimsTaggedMigrationDebt := true
         registeredGapClaimsWithoutMigrationDebtTagCount := 0
         allConditionalMilestoneClaimsTaggedConditionalLeanPackage := true
         conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount := 0
         needsTriageCount := 0 } :
        MasterClaimDispositionTagDisciplineSnapshot) := by
  decide

/-- R625 kernel-checked broken-link ledger for the master-paper summary. -/
theorem currentMasterBrokenLinkDisciplineSnapshot_eq_texStatus :
    currentMasterBrokenLinkDisciplineSnapshot =
      ({ brokenLinkDeclNames :=
          ["HodgeReduction.IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK",
           "HodgeReduction.IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK",
           "HodgeReduction.IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK"]
         brokenLinkDeclNamesReferencedByMasterClaim :=
          ["HodgeReduction.IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK",
           "HodgeReduction.IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK",
           "HodgeReduction.IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK"]
         brokenLinkDeclNamesMissingMasterClaim := []
         brokenLinkClaimIds := ["prop:d5-e7-closure", "open:exotic-residual"]
         brokenLinkDeclCount := 3
         brokenLinkReferencedDeclCount := 3
         brokenLinkClaimCount := 2
         allBrokenLinkDeclsReferencedByMasterClaim := true
         allBrokenLinkClaimsHaveOpenOrGapDisposition := true
         brokenLinkClaimsWithoutOpenOrGapDispositionCount := 0
         allBrokenLinkClaimsTaggedNewMathGap := true
         brokenLinkClaimsWithoutNewMathGapTagCount := 0 } :
        MasterBrokenLinkDisciplineSnapshot) := by
  decide

/-- R626 kernel-checked sub-gap status marker ledger for master-tex prose. -/
theorem currentMasterSubgapStatusMarkerSnapshot_eq_texStatus :
    currentMasterSubgapStatusMarkerSnapshot =
      ({ markerIds :=
          ["SG-17", "open:exotic-residual-kappa0", "SG-21", "SG-15b",
           "SG-15", "SG-16"]
         markerLines := [5616, 9186, 13404, 13876, 13899, 13899]
         markerCount := 6
         gapOpenCount := 1
         gapPartialCount := 4
         gapBlockedCount := 1
         allMarkersHaveAllowedStatus := true
         markersWithUnknownStatusCount := 0
         allMarkersHaveLeanDecl := true
         markersWithoutLeanDeclCount := 0 } :
        MasterSubgapStatusMarkerSnapshot) := by
  decide

/-- R618 kernel-checked discipline for canonical-vs-archive source usage. -/
theorem currentMasterSourceDisciplineSnapshot_eq_texStatus :
    currentMasterSourceDisciplineSnapshot =
      ({ knownSourceCount := 6
         archivedBackgroundSourceCount := 5
         canonicalMasterSourcePathIsMasterTex := true
         canonicalMasterSourceRoleIsCanonical := true
         allArchivedBackgroundSourcesHaveArchiveRole := true
         allMasterClaimSourceIdsKnown := true
         masterClaimsWithUnknownSourceIdCount := 0
         allMasterClaimsUseCanonicalMasterSource := true
         masterClaimsOutsideCanonicalSourceCount := 0 } :
        MasterSourceDisciplineSnapshot) := by
  decide

/-- R619 kernel-checked coverage for theorem-like master environments. -/
theorem currentMasterEnvironmentCoverageDisciplineSnapshot_eq_texStatus :
    currentMasterEnvironmentCoverageDisciplineSnapshot =
      ({ masterEnvironmentCount := 100
         masterClaimCount := 106
         claimedMasterEnvironmentCount := 100
         unclaimedMasterEnvironmentCount := 0
         allMasterEnvironmentsHaveUniqueClaim := true
         masterEnvironmentsWithoutUniqueClaimCount := 0
         allClaimedMasterEnvironmentKindsMatch := true
         masterEnvironmentsWithKindMismatchCount := 0
         masterClaimsNotCoveringMasterEnvironmentCount := 6 } :
        MasterEnvironmentCoverageDisciplineSnapshot) := by
  decide

/-- R622 kernel-checked exact worklists for master-claim import debt. -/
theorem currentMasterClaimWorklistSnapshot_eq_texStatus :
    currentMasterClaimWorklistSnapshot =
      ({ registeredGapClaimIds :=
          ["input:Ran", "input:Hbundle", "input:motivic-span", "prop:coverage",
           "prop:coherence-lemma", "thm:generic_fiber", "thm:meyer_rank",
           "cor:aniso_empty", "rem:E7-chernweil-tautology", "thm:E7_scope",
           "lem:F-natural-V56", "thm:bundle-matching-unconditional",
           "prop:hbundle-low-dim", "prop:exotic-narrowing", "lem:sg17-stepA",
           "lem:sg17-stepB", "prop:mok-conditional", "thm:torelli-evii-verdict",
           "lem:fibre-density", "prop:boundary-in-u7", "prop:w0-flip",
           "thm:parabolic-density", "thm:e7-arithmeticity", "open:hbundle",
           "open:fibre-id", "prop:shimura-fibre-density",
           "thm:SL8-quartic-decomposition", "prop:omega-diagonal",
           "prop:deligne-splitting"]
         openHypothesisClaimIds :=
          ["hyp:CM-correspondences", "hyp:HC-CM-Ab", "hyp:KS-p3",
           "hyp:hecke-bbt", "hyp:chow-modularity-E7", "hyp:AH-CM-E7",
           "hyp:ChernWeil-bridge-E7", "hyp:BBT-rigid-reach",
           "hyp:nonrigid-family-bridge"]
         openResidualClaimIds :=
          ["prop:d5-e7-closure", "cor:E7_full_closure", "open:torelli-evii",
           "open:exotic-residual", "prop:theta-closure",
           "prop:combined-closure"]
         conditionalMilestoneClaimIds :=
          ["thm:main", "thm:general-variety-reduction", "thm:HCab",
           "cor:Ab_covers", "thm:levi-reduction-min3", "thm:AHD",
           "thm:GLB_full", "cor:Orth_covers", "thm:E6_chernweil",
           "thm:E7_chernweil", "cor:E7_shimura_closed", "thm:E7_approachF",
           "thm:sg17-partial-kill", "lem:sg5-b2-b4-conditional",
           "lem:sg5-hodge-diamond-conditional", "cor:sg5-chi-omega-conditional",
           "cor:sg5-35to1-reduction", "prop:exc_covered",
           "cor:hc-conditional-nonrigid-e7", "prop:q4-abelian-algebraicity",
           "lem:sg23-andre-closure", "lem:sg18-pi3-chow-conditional",
           "thm:E7-modularity", "thm:E7-theta-match", "cor:theta-step-iii",
           "lem:CM-E7-algebraicity", "thm:E7-BBT-spreading",
           "prop:quartic-chern", "cor:quartic-algebraic",
           "lem:sg22-tabuada-nc-no-shortcut", "thm:eigenvalue-separation",
           "lem:sg14-honda-tate-non-abelian-conditional",
           "lem:sg20-rho-omega-tate-conditional"]
         paperProofNotKernelPortedClaimIds :=
          ["thm:main", "input:Ran", "input:Hbundle",
           "thm:general-variety-reduction", "prop:coherence-lemma", "thm:HCab",
           "cor:Ab_covers", "thm:levi-reduction-min3", "thm:AHD",
           "thm:generic_fiber", "thm:GLB_full", "cor:Orth_covers",
           "thm:E6_chernweil", "thm:E7_chernweil", "cor:E7_shimura_closed",
           "rem:E7-chernweil-tautology", "thm:E7_approachF",
           "thm:bundle-matching-unconditional", "prop:hbundle-low-dim",
           "prop:exotic-narrowing", "thm:sg17-partial-kill",
           "lem:sg5-b2-b4-conditional", "lem:sg5-hodge-diamond-conditional",
           "cor:sg5-chi-omega-conditional", "cor:sg5-35to1-reduction",
           "prop:exc_covered", "lem:fibre-density", "prop:boundary-in-u7",
           "prop:w0-flip", "thm:parabolic-density", "thm:e7-arithmeticity",
           "cor:hc-conditional-nonrigid-e7", "open:hbundle",
           "prop:shimura-fibre-density", "prop:q4-abelian-algebraicity",
           "prop:omega-diagonal", "lem:sg23-andre-closure",
           "lem:sg18-pi3-chow-conditional", "thm:E7-modularity",
           "thm:E7-theta-match", "cor:theta-step-iii",
           "lem:CM-E7-algebraicity", "thm:E7-BBT-spreading",
           "prop:quartic-chern", "prop:deligne-splitting",
           "cor:quartic-algebraic", "lem:sg22-tabuada-nc-no-shortcut",
           "thm:eigenvalue-separation",
           "lem:sg14-honda-tate-non-abelian-conditional",
           "lem:sg20-rho-omega-tate-conditional", "prop:combined-closure"]
         externalCitationNotKernelPortedClaimIds :=
          ["input:Ran", "thm:CDK", "thm:CMdensity", "thm:BKT", "thm:PS",
           "thm:BBT", "prop:coherence-lemma", "cor:Ab_covers", "thm:KUY",
           "thm:PrincipleB", "thm:AHD", "thm:generic_fiber", "thm:GLB_full",
           "cor:Orth_covers", "thm:Satake_abelian_classification",
           "thm:E7_chernweil", "rem:borel-matsushima", "thm:F-bkt-bbt",
           "lem:sg19-bilinear-invariants", "thm:bundle-matching-unconditional",
           "prop:hbundle-low-dim", "thm:Voisin_integral",
           "prop:margulis-conditional", "lem:fibre-density",
           "prop:boundary-in-u7", "prop:w0-flip", "open:hbundle",
           "prop:shimura-fibre-density", "thm:eigenvalue-separation"]
         newMathGapClaimIds :=
          ["hyp:CM-correspondences", "hyp:HC-CM-Ab", "hyp:KS-p3",
           "prop:exotic-narrowing", "prop:d5-e7-closure",
           "cor:E7_full_closure", "thm:torelli-evii-verdict", "hyp:hecke-bbt",
           "open:torelli-evii", "open:exotic-residual", "open:fibre-id",
           "prop:omega-diagonal", "prop:theta-closure",
           "hyp:chow-modularity-E7", "hyp:AH-CM-E7",
           "hyp:ChernWeil-bridge-E7", "hyp:BBT-rigid-reach",
           "hyp:nonrigid-family-bridge", "thm:eigenvalue-separation",
           "prop:combined-closure"]
         migrationDebtClaimIds :=
          ["hyp:CM-correspondences", "input:Ran", "input:Hbundle",
           "input:motivic-span", "prop:coverage", "thm:CMdensity", "thm:PS",
           "prop:coherence-lemma", "cor:Ab_covers", "hyp:KS-p3", "thm:AHD",
           "thm:generic_fiber", "thm:meyer_rank", "cor:aniso_empty",
           "thm:GLB_full", "cor:Orth_covers",
           "thm:Satake_abelian_classification", "thm:E7_chernweil",
           "rem:E7-chernweil-tautology", "rem:borel-matsushima",
           "thm:E7_scope", "thm:E7_approachF", "lem:F-natural-V56",
           "thm:bundle-matching-unconditional", "prop:hbundle-low-dim",
           "prop:exotic-narrowing", "lem:sg17-stepA", "lem:sg17-stepB",
           "thm:Voisin_integral", "prop:margulis-conditional",
           "prop:mok-conditional", "thm:torelli-evii-verdict",
           "lem:fibre-density", "prop:boundary-in-u7", "prop:w0-flip",
           "thm:parabolic-density", "thm:e7-arithmeticity",
           "open:torelli-evii", "open:exotic-residual", "open:hbundle",
           "open:fibre-id", "prop:shimura-fibre-density",
           "thm:SL8-quartic-decomposition", "prop:q4-abelian-algebraicity",
           "prop:omega-diagonal", "thm:E7-modularity",
           "hyp:chow-modularity-E7", "thm:E7-theta-match",
           "cor:theta-step-iii", "lem:CM-E7-algebraicity", "hyp:AH-CM-E7",
           "hyp:ChernWeil-bridge-E7", "hyp:BBT-rigid-reach",
           "hyp:nonrigid-family-bridge", "thm:E7-BBT-spreading",
           "prop:deligne-splitting", "cor:quartic-algebraic",
           "thm:eigenvalue-separation", "prop:combined-closure"] } :
        MasterClaimWorklistSnapshot) := by
  decide

/-- R627 kernel-checked exact primary labelled hypothesis list for the
abstract, machine-audit status box, and conclusion. -/
theorem currentMasterPrimaryHypothesisSnapshot_eq_texStatus :
    currentMasterPrimaryHypothesisSnapshot =
      ({ primaryLabelledHypothesisIds :=
          ["hyp:HC-CM-Ab", "hyp:CM-correspondences", "hyp:KS-p3",
           "hyp:AH-CM-E7", "hyp:ChernWeil-bridge-E7",
           "hyp:BBT-rigid-reach", "hyp:nonrigid-family-bridge",
           "hyp:chow-modularity-E7", "hyp:hecke-bbt"]
         primaryLabelledHypothesisCount := 9
         openHypothesisClaimIds :=
          ["hyp:CM-correspondences", "hyp:HC-CM-Ab", "hyp:KS-p3",
           "hyp:hecke-bbt", "hyp:chow-modularity-E7", "hyp:AH-CM-E7",
           "hyp:ChernWeil-bridge-E7", "hyp:BBT-rigid-reach",
           "hyp:nonrigid-family-bridge"]
         openHypothesisClaimCount := 9
         primaryLabelledHypothesisMissingIdCount := 0
         allPrimaryLabelledHypothesesExist := true
         allPrimaryLabelledHypothesesAreOpenHypotheses := true
         allPrimaryLabelledHypothesesHaveLeanDecl := true
         allPrimaryLabelledHypothesesHaveGapId := true
         primaryLabelledHypothesesCoverOpenHypothesisClaims := true
         openHypothesisClaimsCoverPrimaryLabelledHypotheses := true
         primaryLabelledHypothesisDisciplineFailureCount := 0 } :
        MasterPrimaryHypothesisSnapshot) := by
  decide

/-- R628 kernel-checked scope-subclass status snapshot for the abstract and
conclusion. -/
theorem currentMasterScopeSubclassStatusSnapshot_eq_texStatus :
    currentMasterScopeSubclassStatusSnapshot =
      ({ scopeSubclassStatusIds :=
          ["scope-i-classical-no-e6-e7",
           "scope-ii-e6-factor",
           "scope-iii-known-e7",
           "scope-iv-cy3-reducible-exotic-e7"]
         scopeSubclassSummaryStatuses :=
          ["conditional",
           "e6-factor-unconditional-other-factors-inherit-conditional",
           "conditional",
           "cy3-nonexistence-unconditional-e7-machinery-inherited-conditional"]
         scopeSubclassStatusLines := [193, 210, 215, 236]
         scopeSubclassStatusCount := 4
         allSummaryStatusesAllowed := true
         statusesWithUnknownSummaryStatusCount := 0
         allStatusesHaveLeanDecl := true
         statusesWithoutLeanDeclCount := 0
         allStatusesHaveMasterClaimId := true
         statusesWithoutMasterClaimIdCount := 0
         allMasterClaimIdsExist := true
         allStatusesHaveRouteGapId := true
         statusesWithoutRouteGapIdCount := 0
         scopeSubclassStatusFailureCount := 0 } :
        MasterScopeSubclassStatusSnapshot) := by
  decide

/-- Kernel-checked certificate for the numeric status claims in the master tex
machine-audit snapshot.  If the ledger changes, this theorem is the line that
forces the paper-facing counts to be updated. -/
theorem currentMasterAuditSnapshot_eq_texStatus :
    currentMasterAuditSnapshot =
      ({ masterEnvironmentCount := 100
         masterClaimCount := 106
         claimedMasterEnvironmentCount := 100
         unclaimedMasterEnvironmentCount := 0
         allMasterClaimsHaveEffectiveAuditTag := true
         untaggedMasterClaimCount := 0
         allMasterClaimsHaveMachineCorrespondence := true
         claimsWithoutMachineCorrespondenceCount := 0
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
         migrationDebtClaimCount := 59 } : MasterAuditSnapshot) := by
  decide

end PaperInventory
end HodgeReduction
