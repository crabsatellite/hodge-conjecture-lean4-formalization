/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit
import HodgeReduction.MainTheorem
import HodgeReduction.HCGapRegistry

/-!
# Hodge main-chain audit configuration

This module is the single source of truth for the generated
`chain-status/*` reports.  The audit code derives the import closure,
open cuts, orphan files, and route labels from this Lean configuration
plus the actual compiled environment.

The root aggregator `HodgeReduction.lean` intentionally is not the audit
entrypoint: it imports many historical and exploratory front-attack
files.  The audit entry is this file, whose endpoints isolate the
headline Mumford--Tate reduction theorem
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
    -- into paper §4 stage cuts: Springer/V56, FTS omega, J3(O)
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
      id := "G-main-hc"
      title := "Hodge conjecture headline remains axiom-relative"
      status := "conditional"
      summary :=
        "The `hodgeConjectureReal_canonical` endpoint is a kernel-pure composition once the canonical target variety and its two E7-scope facts are accepted.  R542 derives the full `canonicalMTPackageAt` from the generic R517/R532 MT-witness route; R545 splits the chosen-witness package into a codim-one first target plus the remaining non-codim-one lift; R549 opens that codim-one target into Hodge-morphism, algebraic-map, commuting-square, and Hodge-surjectivity component cuts; R550 routes the separately audited codim-one HC slice directly through the classical Lefschetz (1,1) cut; R551 splits the full canonical proof by codimension so the `p = 1` branch no longer consumes the E7 -> CM package and the `p ≠ 1` branch consumes only the non-codim-one MT lift.  R551 also states the endpoint directly on canonical cohomology/algebraic-class data so the theorem type itself does not pull the legacy all-codim package.  Full HC is NOT unconditional."
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
        "AMRT 1975 / Baily--Borel 1966 construction of S_Γ^tor as a SmoothProjectiveVariety --  Required Mathlib infrastructure: arithmetic groups, Hermitian symmetric domains, toroidal compactifications."
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
        "Construction of `VarietyCohomologyData` whose `H k` is the actual rational singular cohomology of `S_Γ^tor` at degree `k`, with `hodgeStructure k` the actual pure Hodge structure of weight `k` on `H^k(S_Γ^tor, --`.  Required Mathlib infrastructure: singular cohomology, Dolbeault decomposition, Hodge theorem for compact Kähler manifolds."
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
      title := "Layer 3: V_56 -- H^3(S_Γ^tor, -- Hodge-structure identification"
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
      title := "HCGapL4 multi-front Layer-4 attack waves (R420 -- R561)"
      status := "active-open"
      summary :=
        "Active exploratory attack waves on the L4 / cohomology-profile / connectedness pipeline: FrontA (Deligne H0 sheaf realization), FrontB (Baily--Borel connectedness), FrontC (E_7 low-degree Hodge numbers + Hodge polynomial algebra + all-degree rank adapter + EVII/V56/Shimura expected Betti profile), FrontD (E_7 -> CM Chow correspondence + Deligne 1982 minimal fragment), FrontE (real-carrier profile matching + R405 conditional transfer feed).  Audits R451 / R456 / R460 / R465 / R470 / R476 are wave-level summaries.  R552 certifies the expected Shimura Betti profile degree-by-degree from EVII compact-dual Hodge sums plus the isolated V56 degree-3 contribution; R553 ties that finite V56 contribution to the actual `PureHodgeStructure V56 3` infrastructure; R554 combines the Matsushima, Eisenstein, and cuspidal trivial-module infrastructure into an honest boundary theorem; R555 proves the Cartan compact-dual source bridge and reduces the R554 source equality to `surjectivity_source = source_invariants`; R556 turns both source/target boundary equalities into finite-dimensional containment plus finrank obligations, routing the target through the cuspidal trivial-module part; R557 proves the target containment follows from source containment by Matsushima equivariance and the surjectivity image equation; R558 proves target finrank is transported from source finrank by `j_q` injectivity and the Matsushima image equation; R559 rewrites the remaining source obligations through the compact-dual/Cartan source subspace; R560 gives a Lean countermodel showing those compact-dual obligations are not consequences of the current abstract interface; R561 proves that compact-dual exact image plus target-invariant exactness is enough to recover the R554/R559 boundary data.  The concrete EVII compact-dual exact image statement and target exactness remain open and must come from genuine EVII geometry.  No new axioms."
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
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq"
      ]
    }
  ]
  researchChains := [
    {
      id := "main-hc-axiom-relative"
      title := "Main Mumford--Tate-reduction HC chain"
      kind := "main"
      status := "conditional"
      summary :=
        "`OpenHypotheses` (R169 cohomology / algClasses bridge + R174a Deligne) composes with `MainTheorem` (R170 four-case main reduction + R171/R188/R542/R551 canonical headline) to reach `hodgeConjectureReal_canonical`.  R546 adds the separately audited codim-one endpoint `hodgeConjectureReal_canonical_codim1`; R550 reroutes it directly through the classical Lefschetz (1,1) cut; R551 uses that endpoint for the `p = 1` branch of the full canonical proof, uses the direct non-codim-one MT package for `p ≠ 1`, and avoids mentioning `canonicalHCDataByCodim` in the endpoint type.  Full HC remains conditional on a canonical target SPV, its E7 factor/scope facts, the non-codim-one MT-witness route, and the CM-source all-codim bridge for `p ≠ 1`."
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
        "G-main-hc",
        "G-l1-e7-shimura-tor",
        "G-l2-cohomology-construction",
        "G-l3-v56-mt-identification",
        "G-l4-cm-abelian-hc",
        "G-l4-mt-correspondence"
      ]
      dependsOn := []
    },
    {
      id := "unconditional-classical"
      title := "Unconditional classical paper theorems"
      kind := "support"
      status := "closed-modulo-cy3-citation"
      summary :=
        "Meyer / G_2 / F_4 / E_8 vacuity are kernel-pure derived theorems.  `thm_cy3_e7_nonexistence` still consumes `cy3_e7_nonexistence_paper_axiom` (paper §4 Stages A--D)."
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
      title := "HCGapL4 multi-front attack waves (R420 -- R561)"
      kind := "active"
      status := "exploratory"
      summary :=
        "5 parallel attack fronts on the L4 cohomology-profile + connectedness pipeline.  Per-wave audits R451 / R456 / R460 / R465 / R470 / R476 enumerate substantive theorems per round.  R552 extends the FrontC numeric bridge through a buildable EVII compact-dual/V56/Shimura expected Betti profile: all degrees 0..8 are certified by known Hodge sums, with degree 3 explicitly routed through V56 rather than hidden in compact-dual odd cohomology.  R553 connects that finite V56 profile to the actual infrastructure `PureHodgeStructure V56 3`.  R554 proves the abstract Matsushima boundary composition: target invariants reduce to the cuspidal trivial-module part, and compact-dual image reduces to that part once concrete EVII source/target boundary equalities are provided.  R555 tightens the source-side obligation: Cartan's trivial-module H8 line rewrites to compact-dual H8, its classes are algebraic through `CompactDualData`, and the R554 source equality follows from `surjectivity_source = source_invariants`.  R556 converts the remaining boundary equalities into four concrete linear-algebra tasks; R557 shows target containment is forced by source containment; R558 transports target finrank from source finrank; R559 rewrites the remaining source obligations against compact-dual/Cartan data; R560 proves those obligations are not derivable from the current abstract interface alone; R561 replaces the three R559 obligations by the sharper compact-dual exact image target plus target-invariant exactness.  The route remains exploratory, not a closure claim."
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
        "HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq"
      ]
      gapIds := ["G-hcgap-l4-multifront"]
      dependsOn := ["main-hc-axiom-relative"]
      attackPlan := [
        "FrontC: R560 blocks any abstract-interface proof of the R559 compact-dual obligations; R561 shows that the next genuine EVII target is the compact-dual exact image `Submodule.map j_q compactDual = surjectivity_target` plus `surjectivity_target = target_invariants`.  Prove those two geometric facts, then feed R553/R554/R555/R556/R557/R558/R559/R561 together.",
        "FrontB: replace the abstract connectedness pipeline with the genuine Baily--Borel connectedness theorem for arithmetic quotients.",
        "FrontD: deliver the E_7 -> CM Chow correspondence at codim 1 first, then lift to all p; this would discharge G-l4-mt-correspondence for the canonical case.",
        "Never re-bundle a closed front into a stronger hypothesis; chainAudit treats `def : Prop` placeholders and conjunction shells as hard failures."
      ]
      successCriterion :=
        "A successful follow-up closes one of the remaining target cuts: construct `canonicalTargetVariety`, prove its E7 factor, prove it lies in known E7 scope, or reduce the generic R517/R532 MT-witness cuts by Chow / cycle-class data."
    },
    {
      id := "concrete-evii-toy"
      title := "Concrete EVII sanity-check chain"
      kind := "support"
      status := "closed-toy"
      summary :=
        "`HC_for_Concrete_EVII` specialises the abstract closure `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` to a concrete `A_EVII := Polynomial ℚ` toy carrier.  Cone is `{propext, Classical.choice, Quot.sound}` (no project axioms) but the carrier is explicitly toy; per R201 mandate it is EXCLUDED from real-HC closure accounting."
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
  primaryGapId := some "G-main-hc"
  replacementRouteId := some "hcgap-l4-multifront-active"
  gapPriority := [
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

end HodgeReduction.MainChain

