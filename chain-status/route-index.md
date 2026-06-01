# HodgeReduction -- route index

Decision-first index for the next research round.  Treat this as the base map: the proof spine is the endpoint closure, route labels are generated automatically from the Lean import graph, file names, source text, and audit route taxonomy.  The goal is to show which proof routes are active, blocked, closed, or orphaned before a new agent starts editing.

* endpoints: **8**  *  open mathematical cuts: **24**  *  route taxonomy chains: **8**  *  route taxonomy gaps: **10**  *  debt components: **28**  *  branch heads: **73**

## Audit Truth Contract

This file is generated.  Future agents should update Lean files, audit rules, or the route taxonomy config, then regenerate the reports.  Do not maintain a separate hand-written route ledger.

## Next Agent Brief

Research attack target:
- Primary proof gap: `gap:G-full-hc` -- The final project objective is `FullHodgeConjectureReal`, the universal theorem `forall X : SmoothProjectiveVariety Complex, HodgeConjectureReal X`.  The current canonical `E_7` endpoint and the four-case `main_reduction_real` theorem are milestones only.  `main_reduction_real` proves `InScope X -> HodgeConjectureReal X`; a full proof still needs either a proof that the current scope covers every smooth projective complex variety or a separate global route for varieties outside that scope.  R611 records that global closure route in `FullHodgeGoal.lean`, including the by-codimension consumer and the machine-checked status that the current state is not a full-HC closure claim.  R612 formalizes the second alternative as `CurrentReductionCoversOrSolvesAllSmoothProjective` and proves that this scope-or-complement route consumes `main_reduction_real` to conclude the full theorem.  R613 aligns the residual-gate vocabulary in `Research/E7ResidualStatus.lean` with the same R612 antecedent, so the paper's residual-gate route and the full-HC closure route are now the same kernel-visible interface.  R620 adds a zero-failure summary guard tying the paper's non-closure claim, final-open route status, and import-ledger sanity checks to Lean.  R621 fixes the exact ten route gap id/status pairs used by the paper summary, R627 fixes the exact nine primary labelled hypotheses that the paper summary lists as open inputs, R628 fixes the four scope-subclass status claims, R629 fixes the top-level project axiom-constant count used by the Lean trust-base prose, R630 fixes the direct `sorryAx` count for project declarations visible from the root import, R631 pins the exact endpoint-level open-cut ledger at 24 configured cuts, R632 assigns those endpoint cuts to registered route-level gap rows, and R633 isolates the only endpoint cut without direct master-paper claim coverage as structural cohomology infrastructure.  Do not treat closure of `G-main-hc`, `G-l4-mt-correspondence`, or any canonical target branch as closure of the full Hodge conjecture unless it feeds an explicit theorem concluding `FullHodgeConjectureReal`.
- Route owner(s): `chain:full-hc-final-target`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`
- Current constructive attack route: `chain:main-hc-axiom-relative`.  Use it to replace the primary cut; do not route around the configured gap ledger.

Kernel cut ledger.  These are audit-visible unresolved constants on the endpoint closure; use the configured route/gap above to decide the next research attack, not this flat list alone:
- `HodgeReduction.SmoothProjectiveVariety.algClasses` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.SmoothProjectiveVariety.cohomology` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.absHodgeClassesAtDegreeCM` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.abs_hodge_cm_implies_algebraic` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.canonicalTargetE7Factor` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.canonicalTargetInKnownE7Scope` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.canonicalTargetVariety` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.cy3_e7_excludes_e6` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_e7_fts_omega_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_j3o_nonrealization_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_springer_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_inherits_e7_factor` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_mtd_isSemisimple` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.deligne_1982_abs_hodge_cm` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.e6_classical_remainder_exists` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e6_remainder_transfer` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e7_chosen_witness_alg_map_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_hodge_surj_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_hsm_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_square_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_cm_witness_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.hc_real_classical_cartan` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.lefschetz_11_hc_real_at_codim1` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`

Live subgaps exposed by the current route:
| priority | gap | labelled debt files | declarations | taxonomy files |
|---------:|-----|--------------------:|--------------|----------------|
| 1 | `gap:G-hcgap-l4-multifront` (active-open) | 308 | `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond`, `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond`, `HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge`, +777 more | `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean`, +117 more |

Priority uses the project-configured `gapPriority` order first; remaining active subgaps are sorted mechanically by labelled debt file count.  It is a triage order, not a mathematical proof of easiest-first.

## New Agent Attack Cards

Readiness verdict: **actionable**.  The main cut and replacement route are clear.  Start from the priority gap cards below.

### Priority 1: `gap:G-hcgap-l4-multifront` -- HCGapL4 multi-front Layer-4 attack waves (R420 -- R676)

Active exploratory attack waves on the L4 / cohomology-profile / connectedness pipeline: FrontA (Deligne H0 sheaf realization), FrontB (Baily--Borel connectedness), FrontC (E_7 low-degree Hodge numbers + Hodge polynomial algebra + all-degree rank adapter + EVII/V56/Shimura expected Betti profile), FrontD (E_7 -> CM Chow correspondence + Deligne 1982 minimal fragment), FrontE (real-carrier profile matching + R405 conditional transfer feed).  Audits R451 / R456 / R460 / R465 / R470 / R476 are wave-level summaries.  R552 certifies the expected Shimura Betti profile degree-by-degree from EVII compact-dual Hodge sums plus the isolated V56 degree-3 contribution; R553 ties that finite V56 contribution to the actual `PureHodgeStructure V56 3` infrastructure; R554 combines the Matsushima, Eisenstein, and cuspidal trivial-module infrastructure into an honest boundary theorem; R555 proves the Cartan compact-dual source bridge and reduces the R554 source equality to `surjectivity_source = source_invariants`; R556 turns both source/target boundary equalities into finite-dimensional containment plus finrank obligations, routing the target through the cuspidal trivial-module part; R557 proves the target containment follows from source containment by Matsushima equivariance and the surjectivity image equation; R558 proves target finrank is transported from source finrank by `j_q` injectivity and the Matsushima image equation; R559 rewrites the remaining source obligations through the compact-dual/Cartan source subspace; R560 gives a Lean countermodel showing those compact-dual obligations are not consequences of the current abstract interface; R561 proves that compact-dual exact image plus target-invariant exactness is enough to recover the R554/R559 boundary data; R562 proves target exactness follows from compact-dual exact image plus the compactDual/trivialModulePart rank bridge; R563 proves compact-dual exact image is equivalent to `surjectivity_source = compactDual`; R564 proves the actual compact-dual `H8` carrier has rank one and reduces the rank bridge to `compactDual = H8` plus rank-one of `trivialModulePart`; R565 proves that the trivial-module rank-one fact follows from exact Cartan image equality `Submodule.map j_q trivialModuleGK_H8 = trivialModulePart`; R566 rewrites source equality and compactDual/H8 identification through the same Cartan H8 line; R567 proves by countermodel that those Cartan-line exactness statements are not consequences of the current abstract interface; R568 rewrites the exact Cartan image equality as scalar surjectivity by `j_q (r * h^4)` onto the trivial-module part, and shows the containment direction follows from compactDual = Cartan; R569 gives a countermodel showing compactDual = Cartan still does not force scalar surjectivity; R570 proves rank-one of the trivial-module part plus compactDual = Cartan does force exact Cartan image and scalar preimages; R571 reframes the surviving obligations as source equality, source-invariants/H8 equality, and target rank; R572 routes the target rank through the expected degree-8 Shimura Betti slot; R573 splits source-invariants/H8 into no-extra-source containment plus membership of the generator `h^4`, with a rank-one alternate criterion; R574 pushes those two source-carrier facts back to the compact-dual carrier: prove `compactDual <= H8` and prove `h^4` lies in compactDual; R575 rewrites those compact-dual carrier targets as the two Cartan/compactDual containments; R576 rewrites the remaining source equality as two source/Cartan containment directions and feeds all four Cartan containment directions into the same boundary package; R577 proves by countermodel that those four carrier containments still do not force the target expected-Betti rank; R578 routes the target rank through the degree-8 compact-dual Hodge-sum profile certified in FrontC11; R579 derives that target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from compactDual/Cartan two-sided containment plus scalar preimage surjectivity; R581 proves that target Hodge-sum rank and scalar-preimage surjectivity are equivalent once the four carrier directions are fixed; R582 rewrites the four Cartan carrier directions as source/compactDual H8 no-extra plus h^4 generator-membership splits; R583 collapses each H8 split to exact equality with H8; R584 translates those H8 equalities into Matsushima boundary language and proves target Hodge-sum rank is equivalent to `surjectivity_target = trivialModulePart`; R585 proves that, after `compactDual = H8`, this concrete boundary package is equivalent to the existing `MatsushimaV56BoundaryData`; R586 records a countermodel showing the H8 carrier equalities alone do not force the target boundary equality or boundary data; R587 isolates the remaining target boundary as the single reverse containment `trivialModulePart <= surjectivity_target`, and proves that this containment is also not forced by the abstract H8 carrier interface; R588 proves this reverse containment is exactly the element-level scalar-preimage statement `forall beta in trivialModulePart, exists r, j_q (r * h^4) = beta` once `source = H8`, with no finite-dimensional rank hypothesis; R589--R643 progressively normalize the same target side through rank-one, expected-Betti, saturation, quotient, and excess-finrank spellings.  R644--R675 identify the currently preferred target-side spellings as one gap: `targetInvariantExcessQuotient = bot`, `target_invariants <= span {j_q(h^4)}`, `target_invariants = span {j_q(h^4)}`, and bundled finite-dimensional target invariants plus `finrank target_invariants <= shimuraEVIIExpectedBetti 8`; R672 proves that honest `MatsushimaV56BoundaryData` closes exact image and, with source-H8, feeds this target-side theorem; R673 proves this boundary-data/source-H8 spelling is equivalent to the current line-equality residual, so it is not a stronger hidden premise; R674 proves that under boundary data the target-line equality itself recovers source-H8; R675 proves the same boundary route can be read as boundary data plus `compactDual = H8`, equivalently target-line equality; R676 proves the R636 exact-image/reverse-containment contract is equivalent to the current target-line residual and the boundary-data/compact-dual spelling, so exact image, source-H8, and `trivialModulePart <= surjectivity_target` are a current concrete attack route, not a stronger premise.  No new axioms.

- status: `active-open`
- owner route(s): `chain:hcgap-l4-multifront-active`
- prove/provide declaration(s): `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond`, `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond`, `HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge`, `HodgeReduction.HCGapL4.FrontC9_EVIIHodgeNumberComputation.eviiCompactDualCertification`, `HodgeReduction.HCGapL4.FrontC10_V56CohomologyIdentification.EVII_V56_CohomologyBridge`, `HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBettiKnownHodgeSumCertification_current`, +774 more
- start files: `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean [registered]`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean [registered]`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean [registered]`, `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean [registered]`, `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean [registered]`, `HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean [registered]`, +114 more
- classification note: `orphan` / `on-disk-unloaded` here means the file is not endpoint-reached yet.  For an active replacement route this is expected until a new theorem consumes the branch and removes the main cut; it is not by itself a quarantine signal.
- trick-audit priority: no W5 Prop-definition finding in the listed start files.
- import-graph heads touching this gap:
  - `HodgeReduction/HCGapL4/R504_MultiFrontWave16Audit.lean` -- active/exploring, closure 199, core-support
  - `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` -- active/exploring, closure 180, core-support
  - `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` -- active/exploring, closure 177, core-support

## Main Proof Spine

| endpoint | mathematical cuts | full axiom count |
|----------|-------------------|-----------------:|
| `HodgeReduction.hodgeConjectureReal_canonical` | `HodgeReduction.SmoothProjectiveVariety.algClasses`, `HodgeReduction.SmoothProjectiveVariety.cohomology`, `HodgeReduction.absHodgeClassesAtDegreeCM`, `HodgeReduction.abs_hodge_cm_implies_algebraic`, `HodgeReduction.canonicalTargetE7Factor`, +6 more | 14 |
| `HodgeReduction.hodgeConjectureReal_canonical_codim1` | `HodgeReduction.SmoothProjectiveVariety.algClasses`, `HodgeReduction.SmoothProjectiveVariety.cohomology`, `HodgeReduction.canonicalTargetVariety`, `HodgeReduction.lefschetz_11_hc_real_at_codim1` | 7 |
| `HodgeReduction.main_reduction_real` | `HodgeReduction.SmoothProjectiveVariety.algClasses`, `HodgeReduction.SmoothProjectiveVariety.cohomology`, `HodgeReduction.absHodgeClassesAtDegreeCM`, `HodgeReduction.abs_hodge_cm_implies_algebraic`, `HodgeReduction.cy3_e7_excludes_e6`, +15 more | 23 |
| `HodgeReduction.thm_Meyer` | - | 0 |
| `HodgeReduction.thm_G2F4` | - | 3 |
| `HodgeReduction.thm_E8_vacuous` | - | 3 |
| `HodgeReduction.thm_cy3_e7_nonexistence` | `HodgeReduction.cy3_e7_fts_omega_stage`, `HodgeReduction.cy3_e7_j3o_nonrealization_stage`, `HodgeReduction.cy3_e7_springer_stage` | 6 |
| `HodgeReduction.thm_subcase3b_vacuous` | - | 0 |

Open mathematical cut ledger:
- `HodgeReduction.SmoothProjectiveVariety.algClasses` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.SmoothProjectiveVariety.cohomology` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.absHodgeClassesAtDegreeCM` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.abs_hodge_cm_implies_algebraic` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.canonicalTargetE7Factor` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.canonicalTargetInKnownE7Scope` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.canonicalTargetVariety` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.cy3_e7_excludes_e6` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_e7_fts_omega_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_j3o_nonrealization_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_springer_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_inherits_e7_factor` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_mtd_isSemisimple` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.deligne_1982_abs_hodge_cm` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.e6_classical_remainder_exists` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e6_remainder_transfer` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e7_chosen_witness_alg_map_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_correspondence_package_non_codim1_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_hodge_surj_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_hsm_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_chosen_witness_square_codim1` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_cm_witness_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.hc_real_classical_cartan` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.lefschetz_11_hc_real_at_codim1` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`

## Route Taxonomy

| id | role | status | depends on | gaps | files |
|----|------|--------|------------|------|-------|
| `chain:full-hc-final-target` | main | final-open | - | `gap:G-full-hc` | cut: 2, infra: 1, on-chain: 1, registered: 2 |
| `chain:master-paper-import-ledger` | support | in-progress | `chain:full-hc-final-target` | `gap:G-master-paper-import`, `gap:G-full-hc` | cut: 2, infra: 2, registered: 20 |
| `chain:main-hc-axiom-relative` | milestone | conditional | `chain:full-hc-final-target` | `gap:G-full-hc`, `gap:G-main-hc`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +2 more | cut: 2, infra: 1, on-chain: 2 |
| `chain:unconditional-classical` | support | closed-modulo-cy3-citation | - | `gap:G-classical-mathlib-port` | cut: 1, on-chain: 1 |
| `chain:hcgap-l2-trivial-instances` | support | stable | `chain:main-hc-axiom-relative` | `gap:G-l2-cohomology-construction` | registered: 3 |
| `chain:hcgap-l4-multifront-active` | active | exploratory | `chain:main-hc-axiom-relative` | `gap:G-hcgap-l4-multifront` | on-disk-unloaded: 3, registered: 108 |
| `chain:concrete-evii-toy` | support | closed-toy | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 1 |
| `chain:historical-cone-audits` | infra | infra | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 4 |

## Gap Ledger

| gap | status | route owners | declarations | files |
|-----|--------|--------------|--------------|-------|
| `gap:G-full-hc` | final-open | `chain:full-hc-final-target`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger` | `HodgeReduction.FullHodgeConjectureReal`, `HodgeReduction.FullHodgeConjectureRealByCodim`, `HodgeReduction.fullHodgeConjectureReal_iff_byCodim`, +66 more | cut: 2, infra: 2, on-chain: 1, registered: 1 |
| `gap:G-master-paper-import` | in-progress | `chain:master-paper-import-ledger` | `HodgeReduction.PaperInventory.canonicalMasterSource`, `HodgeReduction.PaperInventory.archivedBackgroundSources`, `HodgeReduction.PaperInventory.allSources`, +387 more | cut: 2, infra: 3, registered: 21 |
| `gap:G-main-hc` | conditional | `chain:main-hc-axiom-relative` | `HodgeReduction.CanonicalHCData`, `HodgeReduction.CanonicalHCDataByCodim`, `HodgeReduction.canonicalTargetVariety`, +15 more | cut: 2, infra: 1, on-chain: 1 |
| `gap:G-l1-e7-shimura-tor` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L1_G1_E7ShimuraTor_Inhabited`, `HodgeReduction.E7ShimuraTor` | cut: 1, infra: 1, on-disk-unloaded: 2, registered: 1 |
| `gap:G-l2-cohomology-construction` | open | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L2_G1_VarietyCohomologyData_Constructed_NonToy`, `HodgeReduction.HCGapRegistry.L2_G2_E7CanonicalCohomology_MatchesPaper`, `HodgeReduction.SmoothProjectiveVariety.cohomology` | infra: 1, on-chain: 1, registered: 4 |
| `gap:G-l3-v56-mt-identification` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L3_G1_V56_PureHodgeStructure_W3_HodgeDiamond`, `HodgeReduction.HCGapRegistry.L3_G2_V56_To_E7_Variety_Cohomology_Identification` | infra: 1, registered: 4 |
| `gap:G-l4-cm-abelian-hc` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.hyp_HC_CM_Ab_real`, `HodgeReduction.absHodgeClassesAtDegreeCM`, `HodgeReduction.deligne_1982_abs_hodge_cm`, +5 more | cut: 2, infra: 1, on-disk-unloaded: 2 |
| `gap:G-l4-mt-correspondence` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.mt_correspondence_e7_witness_exists`, `HodgeReduction.e7_cm_witness_exists`, `HodgeReduction.e7_chosen_witness_correspondence_package_exists`, +11 more | cut: 3, infra: 1, registered: 1 |
| `gap:G-classical-mathlib-port` | deferred | `chain:unconditional-classical` | `HodgeReduction.e6_classical_remainder_exists`, `HodgeReduction.e6_remainder_transfer`, `HodgeReduction.e6_factor_classical_transfer`, +9 more | cut: 3, on-chain: 2 |
| `gap:G-hcgap-l4-multifront` | active-open | `chain:hcgap-l4-multifront-active` | `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond`, `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond`, `HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge`, +777 more | on-disk-unloaded: 3, registered: 117 |

## Automatic Route Labels

These labels are generated for debt files from imports, names, source text, and the audit route taxonomy.  They are the route map an agent should use before opening individual files.

| route label | state | files | dominant bucket | classes | latest |
|-------------|-------|------:|-----------------|---------|--------|
| `chain:main-hc-axiom-relative` | active/exploring | 387 | core-support | on-disk-unloaded: 145, orphan: 242 | 2026-06-01 13:30 |
| `chain:hcgap-l4-multifront-active` | active/exploring | 308 | core-support | on-disk-unloaded: 94, orphan: 214 | 2026-06-01 13:30 |
| `gap:G-hcgap-l4-multifront` | active/exploring | 308 | core-support | on-disk-unloaded: 94, orphan: 214 | 2026-06-01 13:30 |
| `gap:G-main-hc` | active/exploring | 288 | core-support | on-disk-unloaded: 74, orphan: 214 | 2026-06-01 13:30 |
| `gap:G-l1-e7-shimura-tor` | active/exploring | 280 | core-support | on-disk-unloaded: 68, orphan: 212 | 2026-06-01 13:30 |
| `gap:G-l2-cohomology-construction` | active/exploring | 256 | core-support | on-disk-unloaded: 100, orphan: 156 | 2026-06-01 13:30 |
| `gap:G-l4-mt-correspondence` | active/exploring | 142 | core-support | on-disk-unloaded: 39, orphan: 103 | 2026-06-01 13:30 |
| `gap:G-l4-cm-abelian-hc` | active/exploring | 115 | core-support | on-disk-unloaded: 43, orphan: 72 | 2026-06-01 13:30 |
| `gap:G-l3-v56-mt-identification` | active/exploring | 96 | core-support | on-disk-unloaded: 59, orphan: 37 | 2026-06-01 13:30 |
| `chain:unconditional-classical` | active/exploring | 36 | core-support | on-disk-unloaded: 24, orphan: 12 | 2026-06-01 13:30 |
| `chain:full-hc-final-target` | active/exploring | 25 | core-support | on-disk-unloaded: 16, orphan: 9 | 2026-06-01 13:30 |
| `gap:G-full-hc` | active/exploring | 25 | core-support | on-disk-unloaded: 16, orphan: 9 | 2026-06-01 13:30 |
| `chain:hcgap-l2-trivial-instances` | closed/support | 256 | core-support | on-disk-unloaded: 100, orphan: 156 | 2026-06-01 13:30 |
| `chain:concrete-evii-toy` | closed/support | 155 | core-support | on-disk-unloaded: 66, orphan: 89 | 2026-06-01 13:30 |
| `chain:master-paper-import-ledger` | closed/support | 21 | core-support | on-disk-unloaded: 14, orphan: 7 | 2026-06-01 13:30 |
| `gap:G-classical-mathlib-port` | classified | 28 | core-support | on-disk-unloaded: 17, orphan: 11 | 2026-06-01 13:30 |
| `gap:G-master-paper-import` | classified | 21 | core-support | on-disk-unloaded: 14, orphan: 7 | 2026-06-01 13:30 |
| `chain:historical-cone-audits` | classified | 15 | core-support | on-disk-unloaded: 10, orphan: 5 | 2026-05-29 03:18 |

## Branch Head State Summary

| state | heads | closure files |
|-------|------:|--------------:|
| active/exploring | 68 | 1825 |
| closed/support | 4 | 4 |
| unclassified | 1 | 1 |

## Branch Work Queue

Branch heads are off-chain files that no other off-chain debt file imports.  Their closure follows real Lean imports downward.  This table is sorted by generated state, recency, and size so live, mixed, and blocked attempts are visible without opening the files first.

| head | state | closure | bucket | automatic route labels |
|------|-------|--------:|--------|------------------------|
| `HodgeReduction.lean` | active/exploring | 28 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +10 more |
| `HodgeReduction/HCGapL4/CY3SpringerDiscriminant.lean` | active/exploring | 5 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +1 more |
| `HodgeReduction/HCGapL2/AbelianSurface.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/HCGapL4/E6CaseProof.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence` |
| `HodgeReduction/HCGapL2/ProjectiveThreeSpace.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` |
| `HodgeReduction/HCGapL2/ProjectivePlane.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` |
| `HodgeReduction/HCGapL4/V56CohomologyRank.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +3 more |
| `HodgeReduction/HCGapL4/CY3NonexistenceDecomposition.lean` | active/exploring | 5 | core-support | `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, +7 more |
| `HodgeReduction/HCGapL4/ClassicalCartanGapCard.lean` | active/exploring | 6 | core-support | `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, +7 more |
| `HodgeReduction/Infrastructure/ClassicalCominusculeClassification.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence` |
| `HodgeReduction/HCGapL4/E6CaseClosureConstraints.lean` | active/exploring | 6 | core-support | `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, +8 more |
| `HodgeReduction/HCGapL4/DeligneCMHCSkeleton.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +1 more |
| `HodgeReduction/HCGapL4/Lefschetz11Arithmetic.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence` |
| `HodgeReduction/HCGapL4/NoetherLefschetzSkeleton.lean` | active/exploring | 6 | core-support | `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, `gap:G-hcgap-l4-multifront`, +4 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorDecomposition.lean` | active/exploring | 6 | core-support | `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, +8 more |
| `HodgeReduction/HCGapL4/CY3NonexistenceProof.lean` | active/exploring | 4 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +1 more |
| `HodgeReduction/HCGapL2/EVIICohomologyModel.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-mt-correspondence`, +1 more |
| `HodgeReduction/Infrastructure/J3OAlgebra.lean` | active/exploring | 5 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `gap:G-l3-v56-mt-identification`, `gap:G-master-paper-import` |
| `HodgeReduction/Ledger.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, +9 more |
| `HodgeReduction/Infrastructure/Shimura/PeriodDomain.lean` | active/exploring | 2 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Shimura/HermitianSymmetric.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l1-e7-shimura-tor` |
| `HodgeReduction/Infrastructure/Shimura/HermitianForm.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/Infrastructure/Shimura/ArithmeticGroup.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l1-e7-shimura-tor` |
| `HodgeReduction/Infrastructure/Shimura/Adelic.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port` |
| `HodgeReduction/Infrastructure/PoincarePolynomialEVII.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/LieAlgebra/ReductiveGroup.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/LieAlgebra/Basic.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/HodgeStructure/NilpotentOrbit.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/HodgeStructure/MixedHodgeModule.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/HodgeStructure/GaussManin.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Cohomology/RiemannRoch.lean` | active/exploring | 5 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:main-hc-axiom-relative`, `gap:G-full-hc`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Cohomology/LefschetzHyperplane.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/Infrastructure/Cohomology/HardLefschetz.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-full-hc`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Cohomology/ComparisonTheorem.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/Infrastructure/Cohomology/ChowRing.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:main-hc-axiom-relative`, `gap:G-full-hc`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Automorphic/GKCohomology.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Automorphic/HeckeCorrespondence.lean` | active/exploring | 1 | core-support | `chain:unconditional-classical`, `gap:G-classical-mathlib-port` |
| `HodgeReduction/Infrastructure/Automorphic/AtlasE7minus25.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/AbelianVariety/TateModule.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` |
| `HodgeReduction/Infrastructure/AbelianVariety/PolarisedAV.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-cm-abelian-hc` |
| `HodgeReduction/Infrastructure/AbelianVariety/KugaSatake.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-cm-abelian-hc` |
| `HodgeReduction/Infrastructure/AbelianVariety/HyperKahler.lean` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` |
| `HodgeReduction/Infrastructure/AbelianVariety/K3Surface.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc` |
| `HodgeReduction/Infrastructure/AbelianVariety/CMType.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` |
| `HodgeReduction/HCGapL4/ShiftedCorrespondenceSHSM2Bridge.lean` | active/exploring | 11 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/ProductCycleFactoryProjectiveLineToEllipticCurve.lean` | active/exploring | 22 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/HCFrontierAfterParametricRefactorPreparation.lean` | active/exploring | 130 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/HCFrontierAfterLocallyConstantBundle.lean` | active/exploring | 198 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +9 more |
| `HodgeReduction/HCGapL4/HCFrontierAfterInternalMTPackage.lean` | active/exploring | 114 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/GaussianNumberFieldChainIntegration.lean` | active/exploring | 48 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/GaussianIntActionToGaussianFieldTarget.lean` | active/exploring | 80 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/GaussianFieldToEnd0Chain.lean` | active/exploring | 82 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/EllipticCurveCohomologyRealizationAudit.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc`, `gap:G-l4-mt-correspondence`, +1 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorMTCorrespondenceReplacement.lean` | active/exploring | 32 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorFieldReplacementPlan.lean` | active/exploring | 36 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorCohomologyReplacement.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` |
| `HodgeReduction/HCGapL4/E7ShimuraTorAlgClassesReplacementViaCycleClassMap.lean` | active/exploring | 14 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/CanonicalConeExtractionAudit.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +8 more |
| `HodgeReduction/HCGapL4/CMSourceBridgeNextTarget.lean` | active/exploring | 43 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/CMFieldSequenceStoppingAudit.lean` | active/exploring | 40 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/AbelianVarietyInterfaceECProjectiveRealization.lean` | active/exploring | 33 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/ACDReconciliation.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` |
| `HodgeReduction/Concrete.lean` | active/exploring | 57 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, +5 more |
| `HodgeReduction/HCGapL4/R504_MultiFrontWave16Audit.lean` | active/exploring | 199 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, +9 more |
| `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` | active/exploring | 180 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +9 more |
| `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` | active/exploring | 177 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +9 more |
| `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` | active/exploring | 164 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +9 more |
| `HodgeReduction/ConeAudits/R217_ConeAudit.lean` | active/exploring | 13 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, +9 more |
| `HodgeReduction/Infrastructure/Shimura/SchubertCells.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/Cohomology/TateConjecture.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/Cohomology/Lattice.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/ExponentialSequence.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy`, `chain:historical-cone-audits` |

## Component Triage

Components are connected by actual Lean imports.  Large components should be split by strengthening automatic route rules, renaming ambiguous files, or quarantining failed tracks.

| component | state | files | bucket | automatic route labels | anchors |
|-----------|-------|------:|--------|------------------------|---------|
| `C001` | active/exploring | 97 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, +8 more | cut: 5, infra: 1, on-chain: 11, registered: 10 |
| `C002` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | on-chain: 1, registered: 1 |
| `C003` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` | on-chain: 3, registered: 3 |
| `C004` | active/exploring | 291 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, +8 more | cut: 13, on-chain: 69, registered: 75 |
| `C005` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-full-hc`, `gap:G-hcgap-l4-multifront`, +7 more | cut: 1, on-chain: 1 |
| `C006` | closed/support | 1 | core-support | `chain:concrete-evii-toy` | - |
| `C007` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l1-e7-shimura-tor` | - |
| `C008` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l2-cohomology-construction` | - |
| `C009` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l1-e7-shimura-tor` | - |
| `C010` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port` | - |
| `C011` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` | - |
| `C012` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l3-v56-mt-identification` | - |
| `C013` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l3-v56-mt-identification` | - |
| `C014` | closed/support | 1 | core-support | `chain:concrete-evii-toy` | - |
| `C015` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | - |
| `C016` | closed/support | 1 | core-support | `chain:concrete-evii-toy` | - |
| `C017` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | - |
| `C018` | unclassified | 1 | core-support | - | - |
| `C019` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` | - |
| `C020` | active/exploring | 1 | core-support | `chain:unconditional-classical`, `gap:G-classical-mathlib-port` | - |
| `C021` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` | registered: 1 |
| `C022` | closed/support | 1 | core-support | `chain:concrete-evii-toy`, `chain:historical-cone-audits` | - |
| `C023` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` | - |
| `C024` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` | - |
| `C025` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc` | - |
| `C026` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` | - |
| `C027` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` | - |
| `C028` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:full-hc-final-target`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:master-paper-import-ledger`, `chain:unconditional-classical`, `gap:G-full-hc`, `gap:G-hcgap-l4-multifront`, +6 more | cut: 1 |

## Unowned Debt

Files with no automatic route label.  These are the safest next candidates for comment-only classification, naming cleanup, quarantine, or deletion after a compile check.

- `HodgeReduction/Infrastructure/Automorphic/Basic.lean` -- orphan, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Automorphic/BorelBottWeil.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Automorphic/ModularForm.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Cohomology/AlgebraicCycle.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Cohomology/PicardGroup.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/DynkinMarks.lean` -- orphan, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/KostantCominusculeClassification.lean` -- orphan, core-support, 2026-05-29

## Route Details

### `chain:full-hc-final-target` -- Final full Hodge conjecture target

`FullHodgeGoal.lean` records the actual theorem-closing objective: `FullHodgeConjectureReal`, not merely HC for the canonical `E_7` target.  The current `main_reduction_real` theorem is a scoped reduction, and `hodgeConjectureReal_canonical` is a single canonical milestone.  R611 adds the explicit by-codimension consumer plus a kernel-checked full-target status snapshot, so paper summary claims can point to the full target rather than to the L4 proof-work frontier alone.  R612 formalizes the second global closure alternative: prove `CurrentReductionCoversOrSolvesAllSmoothProjective`, then use the current reduction on the `InScope` branch and the independent proof on the complement branch.  R613 aligns the residual-gate vocabulary in `Research/E7ResidualStatus.lean` with that same R612 route, so residual-gate prose and full-HC closure prose now point to a single kernel-visible antecedent.  R620 adds `paperSummaryClaimFailureCount = 0`, so the summary status cannot silently drift from the route and paper-inventory ledgers.  R621 fixes the exact gap id/status table, R629 fixes the top-level project axiom-constant count, R630 fixes the direct `sorryAx` count, R631 fixes the 24-row endpoint open-cut ledger, R632 fixes its route-gap assignment ledger, and R633 fixes the endpoint-paper coverage exception behind the Lean-status prose, so the paper can no longer change those inventories without changing Lean.  Future work should be judged by whether it removes a blocker for the universal theorem or wires a milestone into an explicit implication to `FullHodgeConjectureReal`.

Entry declarations:
- `HodgeReduction.FullHodgeConjectureReal`
- `HodgeReduction.FullHodgeConjectureRealByCodim`
- `HodgeReduction.CurrentReductionCoversAllSmoothProjective`
- `HodgeReduction.fullHodgeConjectureReal_of_currentScopeCoverage`
- `HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeCoverage`
- `HodgeReduction.currentFullHodgeClosureRouteNames`
- `HodgeReduction.FullHodgeClosureStatusSnapshot`
- `HodgeReduction.currentFullHodgeClosureStatusSnapshot`
- `HodgeReduction.currentFullHodgeClosureStatusSnapshot_eq_texStatus`
- `HodgeReduction.currentFullHodgeClosureRouteNames_eq_texStatus`
- `HodgeReduction.CurrentReductionCoversOrSolvesAllSmoothProjective`
- `HodgeReduction.currentScopeOrComplementCoverage_of_currentScopeCoverage`
- `HodgeReduction.fullHodgeConjectureReal_of_currentScopeOrComplementCoverage`
- `HodgeReduction.fullHodgeConjectureRealByCodim_of_currentScopeOrComplementCoverage`
- `HodgeReduction.currentFullHodgeScopeOrComplementRouteNames`
- `HodgeReduction.FullHodgeScopeOrComplementSnapshot`
- `HodgeReduction.currentFullHodgeScopeOrComplementSnapshot`
- `HodgeReduction.currentFullHodgeScopeOrComplementSnapshot_eq_texStatus`
- `HodgeReduction.currentFullHodgeScopeOrComplementRouteNames_eq_texStatus`
- `HodgeReduction.r612ScopeOrComplementResidualGateData`
- `HodgeReduction.fullHodgeConjectureReal_from_r612ResidualGate`
- `HodgeReduction.R613ResidualGateRouteSnapshot`
- `HodgeReduction.currentR613ResidualGateRouteSnapshot`
- `HodgeReduction.currentR613ResidualGateRouteSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.fullHcNarrativeClaimsCompleteProof`
- `HodgeReduction.MainChain.PaperNarrativeConsistencySnapshot`
- `HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot`
- `HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot_eq_texStatus`
- `HodgeReduction.MainChain.fullHcCompletionOverclaimCount`
- `HodgeReduction.MainChain.fullHcFinalOpenStatusFailureCount`
- `HodgeReduction.MainChain.masterClaimTagPointerFailureCount`
- `HodgeReduction.MainChain.masterClaimDispositionTagMismatchCount`
- `HodgeReduction.MainChain.masterBrokenLinkDisciplineFailureCount`
- `HodgeReduction.MainChain.masterSubgapStatusMarkerFailureCount`
- `HodgeReduction.MainChain.masterPrimaryHypothesisDisciplineFailureCount`
- `HodgeReduction.MainChain.scopeSubclassRouteGapReferenceIds`
- `HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceIds`
- `HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceCount`
- `HodgeReduction.MainChain.allScopeSubclassRouteGapReferencesRegisteredInRoute`
- `HodgeReduction.MainChain.masterScopeSubclassStatusFailureCount`
- `HodgeReduction.MainChain.projectAxiomTrustBaseFailureCount`
- `HodgeReduction.MainChain.projectSorryAxFailureCount`
- `HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus`
- `HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus`
- `HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus`
- `HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero`
- `HodgeReduction.MainChain.masterSourceDisciplineFailureCount`
- `HodgeReduction.MainChain.masterEnvironmentCoverageFailureCount`
- `HodgeReduction.MainChain.paperSummaryClaimFailureCount`
- `HodgeReduction.MainChain.paperSummaryClaimFailureCount_eq_zero`
- `HodgeReduction.MainChain.RouteGapStatusEntry`
- `HodgeReduction.MainChain.routeGapStatusLedger`
- `HodgeReduction.MainChain.routeGapStatusLedger_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutNames`
- `HodgeReduction.MainChain.endpointOpenCutCount`
- `HodgeReduction.MainChain.EndpointOpenCutSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutCount_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutFailureCount`
- `HodgeReduction.MainChain.EndpointOpenCutRouteAssignment`
- `HodgeReduction.MainChain.endpointOpenCutRouteAssignments`
- `HodgeReduction.MainChain.endpointOpenCutRouteAssignments_eq_texStatus`
- `HodgeReduction.MainChain.EndpointOpenCutRouteAssignmentSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutRouteAssignmentFailureCount`
- `HodgeReduction.MainChain.EndpointOpenCutPaperCoverageSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutPaperCoverageFailureCount`

Taxonomy files:
- `HodgeReduction/FullHodgeGoal.lean` -- registered
- `HodgeReduction/AxiomInventory.lean` -- infra
- `HodgeReduction/Research/E7ResidualStatus.lean` -- registered
- `HodgeReduction/MainTheorem.lean` -- cut
- `HodgeReduction/OpenHypotheses.lean` -- cut
- `HodgeReduction/Types.lean` -- on-chain

### `chain:master-paper-import-ledger` -- Master tex import ledger

`PaperInventory.lean` is the canonical ledger for moving the master proof into Lean.  It records the master tex as the sole canonical source, marks non-master tex files as archive/background, and tracks each load-bearing master item by line number, Lean declarations, and gap ids.  The current ledger has `claimedMasterEnvironmentCount = masterEnvironmentIndex.length`, `unclaimedMasterEnvironmentCount = 0`, and no `needsTriage` claims.  R614 checks that every load-bearing master claim has at least one machine correspondence: either a Lean declaration or an explicit route/gap id.  R615 strengthens the semantic tag discipline: formalized/kernel-only claims must carry Lean declarations, while registered-gap, open-hypothesis, open-residual, and new-math-gap claims must carry gap ids.  R616 strengthens the disposition/tag discipline: formalized claims must not carry open/unported tags, and open/gap/conditional dispositions must carry their matching semantic tags.  R617 checks that every master-claim gap id resolves to a route-level `researchGaps` entry.  R618 checks that all load-bearing claims use the single master tex canonical source while the other source families remain archive/background.  R619 checks that every theorem-like master environment has exactly one covering claim with a matching environment kind.  R620 aggregates those summary-facing checks into `paperSummaryClaimFailureCount = 0`, including the full-HC non-closure status.  R621 fixes the exact route gap id/status ledger referenced by those master claims.  R622 fixes exact claim-id worklists for the paper's remaining kernel-port debt and new-math/open-gap obligations.  R623 fixes the exact route-gap-to-master-claim worklists.  R624 records the expected exception: the only route rows with no direct master-paper claim ids are the structural infrastructure gaps `G-l1-e7-shimura-tor` and `G-l2-cohomology-construction`.  R625 records the exact broken-link predicate anchors and checks that they remain open/gap-facing new-math claims, not hidden closure claims.  R626 records the explicit master-tex sub-gap status markers, with four `gapPartial`, one `gapOpen`, and one `gapBlocked` marker tied to Lean declarations.  R627 records the exact nine primary labelled hypotheses used by the abstract, status box, and conclusion, and checks that they are exactly the open-hypothesis claim worklist.  R628 records the four scope-subclass status claims, separating unconditional sub-arguments from inherited conditional machinery.  R629 records the generated top-level project axiom-constant count for the master paper's Lean-status section; R630 records that the compiled root import has zero project declarations with direct `sorryAx` in their type/value; R631 records the exact 24 configured endpoint open cuts; R632 records the exact route-gap assignment for those cuts; R633 records the only endpoint assignment without direct master-paper claim coverage as the structural cohomology cut.  Further proof rounds should replace registered gaps and conditional milestones with kernel theorems where possible, without changing the theorem target away from `FullHodgeConjectureReal`.

Entry declarations:
- `HodgeReduction.PaperInventory.canonicalMasterSource`
- `HodgeReduction.PaperInventory.archivedBackgroundSources`
- `HodgeReduction.PaperInventory.allSources`
- `HodgeReduction.PaperInventory.knownSourceIds`
- `HodgeReduction.PaperInventory.sourceIdIsKnown`
- `HodgeReduction.PaperInventory.masterClaimsWithUnknownSourceIdCount`
- `HodgeReduction.PaperInventory.allMasterClaimSourceIdsKnown`
- `HodgeReduction.PaperInventory.masterClaimsOutsideCanonicalSourceCount`
- `HodgeReduction.PaperInventory.allMasterClaimsUseCanonicalMasterSource`
- `HodgeReduction.PaperInventory.canonicalMasterSourcePathIsMasterTex`
- `HodgeReduction.PaperInventory.canonicalMasterSourceRoleIsCanonical`
- `HodgeReduction.PaperInventory.archivedBackgroundSourceCount`
- `HodgeReduction.PaperInventory.allArchivedBackgroundSourcesHaveArchiveRole`
- `HodgeReduction.PaperInventory.MasterSourceDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterSourceDisciplineSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.masterEnvironmentIndex`
- `HodgeReduction.PaperInventory.environmentCoveringClaims`
- `HodgeReduction.PaperInventory.environmentCoveringClaimCount`
- `HodgeReduction.PaperInventory.allMasterEnvironmentsHaveUniqueClaim`
- `HodgeReduction.PaperInventory.masterEnvironmentsWithoutUniqueClaimCount`
- `HodgeReduction.PaperInventory.allClaimedMasterEnvironmentKindsMatch`
- `HodgeReduction.PaperInventory.masterEnvironmentsWithKindMismatchCount`
- `HodgeReduction.PaperInventory.masterClaimsNotCoveringMasterEnvironmentCount`
- `HodgeReduction.PaperInventory.MasterEnvironmentCoverageDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterEnvironmentCoverageDisciplineSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.masterClaims`
- `HodgeReduction.PaperInventory.openHypothesisClaims`
- `HodgeReduction.PaperInventory.registeredGapClaims`
- `HodgeReduction.PaperInventory.needsTriageClaims`
- `HodgeReduction.PaperInventory.formalizedClaims`
- `HodgeReduction.PaperInventory.provenInPaperClaims`
- `HodgeReduction.PaperInventory.conditionalMilestoneClaims`
- `HodgeReduction.PaperInventory.externalCitationClaims`
- `HodgeReduction.PaperInventory.openResidualClaims`
- `HodgeReduction.PaperInventory.archiveOnlyClaims`
- `HodgeReduction.PaperInventory.ClaimAuditTag`
- `HodgeReduction.PaperInventory.effectiveAuditTags`
- `HodgeReduction.PaperInventory.kernelOnlyLeanClaims`
- `HodgeReduction.PaperInventory.kernelOnlyLeanClaimCount`
- `HodgeReduction.PaperInventory.paperProofNotKernelPortedClaims`
- `HodgeReduction.PaperInventory.paperProofNotKernelPortedClaimCount`
- `HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaims`
- `HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaimCount`
- `HodgeReduction.PaperInventory.newMathGapClaims`
- `HodgeReduction.PaperInventory.newMathGapClaimCount`
- `HodgeReduction.PaperInventory.migrationDebtClaims`
- `HodgeReduction.PaperInventory.migrationDebtClaimCount`
- `HodgeReduction.PaperInventory.claimIds`
- `HodgeReduction.PaperInventory.claimReferencesGapId`
- `HodgeReduction.PaperInventory.masterClaimsForGapId`
- `HodgeReduction.PaperInventory.masterClaimIdsForGapId`
- `HodgeReduction.PaperInventory.registeredGapClaimIds`
- `HodgeReduction.PaperInventory.openHypothesisClaimIds`
- `HodgeReduction.PaperInventory.openResidualClaimIds`
- `HodgeReduction.PaperInventory.conditionalMilestoneClaimIds`
- `HodgeReduction.PaperInventory.paperProofNotKernelPortedClaimIds`
- `HodgeReduction.PaperInventory.externalCitationNotKernelPortedClaimIds`
- `HodgeReduction.PaperInventory.newMathGapClaimIds`
- `HodgeReduction.PaperInventory.migrationDebtClaimIds`
- `HodgeReduction.PaperInventory.MasterClaimWorklistSnapshot`
- `HodgeReduction.PaperInventory.currentMasterClaimWorklistSnapshot`
- `HodgeReduction.PaperInventory.currentMasterClaimWorklistSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.untaggedMasterClaimCount`
- `HodgeReduction.PaperInventory.allMasterClaimsHaveEffectiveAuditTag`
- `HodgeReduction.PaperInventory.claimedMasterEnvironments`
- `HodgeReduction.PaperInventory.unclaimedMasterEnvironments`
- `HodgeReduction.PaperInventory.masterClaimCount`
- `HodgeReduction.PaperInventory.formalizedClaimCount`
- `HodgeReduction.PaperInventory.provenInPaperClaimCount`
- `HodgeReduction.PaperInventory.conditionalMilestoneClaimCount`
- `HodgeReduction.PaperInventory.externalCitationClaimCount`
- `HodgeReduction.PaperInventory.registeredGapClaimCount`
- `HodgeReduction.PaperInventory.claimedMasterEnvironmentCount`
- `HodgeReduction.PaperInventory.unclaimedMasterEnvironmentCount`
- `HodgeReduction.PaperInventory.openResidualClaimCount`
- `HodgeReduction.PaperInventory.archiveOnlyClaimCount`
- `HodgeReduction.PaperInventory.claimHasMachineCorrespondence`
- `HodgeReduction.PaperInventory.claimsWithoutMachineCorrespondence`
- `HodgeReduction.PaperInventory.claimsWithoutMachineCorrespondenceCount`
- `HodgeReduction.PaperInventory.allMasterClaimsHaveMachineCorrespondence`
- `HodgeReduction.PaperInventory.claimHasLeanDecl`
- `HodgeReduction.PaperInventory.claimHasGapId`
- `HodgeReduction.PaperInventory.formalizedClaimsWithoutLeanDeclCount`
- `HodgeReduction.PaperInventory.allFormalizedClaimsHaveLeanDecl`
- `HodgeReduction.PaperInventory.kernelOnlyClaimsWithoutLeanDeclCount`
- `HodgeReduction.PaperInventory.allKernelOnlyClaimsHaveLeanDecl`
- `HodgeReduction.PaperInventory.registeredGapClaimsWithoutGapIdCount`
- `HodgeReduction.PaperInventory.allRegisteredGapClaimsHaveGapId`
- `HodgeReduction.PaperInventory.openHypothesisClaimsWithoutGapIdCount`
- `HodgeReduction.PaperInventory.allOpenHypothesisClaimsHaveGapId`
- `HodgeReduction.PaperInventory.openResidualClaimsWithoutGapIdCount`
- `HodgeReduction.PaperInventory.allOpenResidualClaimsHaveGapId`
- `HodgeReduction.PaperInventory.newMathGapClaimsWithoutGapIdCount`
- `HodgeReduction.PaperInventory.allNewMathGapClaimsHaveGapId`
- `HodgeReduction.PaperInventory.MasterClaimTagDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterClaimTagDisciplineSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.claimHasEffectiveAuditTagValue`
- `HodgeReduction.PaperInventory.claimHasAnyOpenOrUnportedTag`
- `HodgeReduction.PaperInventory.formalizedClaimsWithOpenOrUnportedTagCount`
- `HodgeReduction.PaperInventory.allFormalizedClaimsAvoidOpenOrUnportedTags`
- `HodgeReduction.PaperInventory.openHypothesisClaimsWithoutNewMathGapTagCount`
- `HodgeReduction.PaperInventory.allOpenHypothesisClaimsTaggedNewMathGap`
- `HodgeReduction.PaperInventory.openResidualClaimsWithoutNewMathGapTagCount`
- `HodgeReduction.PaperInventory.allOpenResidualClaimsTaggedNewMathGap`
- `HodgeReduction.PaperInventory.registeredGapClaimsWithoutMigrationDebtTagCount`
- `HodgeReduction.PaperInventory.allRegisteredGapClaimsTaggedMigrationDebt`
- `HodgeReduction.PaperInventory.conditionalMilestoneClaimsWithoutConditionalLeanPackageTagCount`
- `HodgeReduction.PaperInventory.allConditionalMilestoneClaimsTaggedConditionalLeanPackage`
- `HodgeReduction.PaperInventory.MasterClaimDispositionTagDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterClaimDispositionTagDisciplineSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.MasterBrokenLinkDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot`
- `HodgeReduction.PaperInventory.currentMasterBrokenLinkDisciplineSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.MasterSubgapStatusMarkerSnapshot`
- `HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot`
- `HodgeReduction.PaperInventory.currentMasterSubgapStatusMarkerSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.MasterPrimaryHypothesisSnapshot`
- `HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot`
- `HodgeReduction.PaperInventory.currentMasterPrimaryHypothesisSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.MasterScopeSubclassStatusSnapshot`
- `HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot`
- `HodgeReduction.PaperInventory.currentMasterScopeSubclassStatusSnapshot_eq_texStatus`
- `HodgeReduction.AxiomInventory.ProjectAxiomTrustBaseSnapshot`
- `HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot`
- `HodgeReduction.AxiomInventory.currentProjectAxiomTrustBaseSnapshot_eq_texStatus`
- `HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount`
- `HodgeReduction.AxiomInventory.topLevelProjectAxiomConstantCount_eq_texStatus`
- `HodgeReduction.AxiomInventory.ProjectSorryAxSnapshot`
- `HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot`
- `HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus`
- `HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount`
- `HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero`
- `HodgeReduction.MainChain.routeGapIds`
- `HodgeReduction.MainChain.gapIdIsRouteRegistered`
- `HodgeReduction.MainChain.masterClaimGapReferenceIds`
- `HodgeReduction.MainChain.masterClaimGapReferenceCount`
- `HodgeReduction.MainChain.unregisteredMasterClaimGapReferenceIds`
- `HodgeReduction.MainChain.unregisteredMasterClaimGapReferenceCount`
- `HodgeReduction.MainChain.masterClaimsWithUnregisteredGapIds`
- `HodgeReduction.MainChain.masterClaimsWithUnregisteredGapIdCount`
- `HodgeReduction.MainChain.allMasterClaimGapReferencesRegisteredInRoute`
- `HodgeReduction.MainChain.MasterClaimGapReferenceSnapshot`
- `HodgeReduction.MainChain.currentMasterClaimGapReferenceSnapshot`
- `HodgeReduction.MainChain.currentMasterClaimGapReferenceSnapshot_eq_texStatus`
- `HodgeReduction.PaperInventory.MasterAuditSnapshot`
- `HodgeReduction.PaperInventory.currentMasterAuditSnapshot`
- `HodgeReduction.PaperInventory.currentMasterAuditSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.routeLevelGapCount`
- `HodgeReduction.MainChain.routeLevelFinalOpenGapCount`
- `HodgeReduction.MainChain.routeLevelInProgressGapCount`
- `HodgeReduction.MainChain.routeLevelConditionalGapCount`
- `HodgeReduction.MainChain.routeLevelOpenGapCount`
- `HodgeReduction.MainChain.routeLevelDeferredGapCount`
- `HodgeReduction.MainChain.routeLevelActiveOpenGapCount`
- `HodgeReduction.MainChain.RouteGapStatusSnapshot`
- `HodgeReduction.MainChain.currentRouteGapStatusSnapshot`
- `HodgeReduction.MainChain.RouteGapStatusEntry`
- `HodgeReduction.MainChain.routeGapStatusLedger`
- `HodgeReduction.MainChain.gapStatusOf?`
- `HodgeReduction.MainChain.currentRouteGapStatusSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.routeGapStatusLedger_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutNames`
- `HodgeReduction.MainChain.endpointOpenCutCount`
- `HodgeReduction.MainChain.expectedEndpointOpenCutNames`
- `HodgeReduction.MainChain.expectedEndpointOpenCutCount`
- `HodgeReduction.MainChain.endpointOpenCutLedgerMatchesTexStatus`
- `HodgeReduction.MainChain.endpointOpenCutCountMatchesTexStatus`
- `HodgeReduction.MainChain.EndpointOpenCutSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutCount_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutFailureCount`
- `HodgeReduction.MainChain.EndpointOpenCutRouteAssignment`
- `HodgeReduction.MainChain.endpointOpenCutRouteAssignments`
- `HodgeReduction.MainChain.endpointOpenCutRouteAssignments_eq_texStatus`
- `HodgeReduction.MainChain.EndpointOpenCutRouteAssignmentSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutRouteAssignmentSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutRouteAssignmentFailureCount`
- `HodgeReduction.MainChain.EndpointOpenCutPaperCoverageSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot`
- `HodgeReduction.MainChain.currentEndpointOpenCutPaperCoverageSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.endpointOpenCutPaperCoverageFailureCount`
- `HodgeReduction.MainChain.MasterRouteGapClaimEntry`
- `HodgeReduction.MainChain.masterRouteGapClaimLedger`
- `HodgeReduction.MainChain.masterRouteGapClaimLedgerClaimReferenceCount`
- `HodgeReduction.MainChain.currentMasterRouteGapClaimLedger_eq_texStatus`
- `HodgeReduction.MainChain.masterRouteGapClaimLedgerClaimReferenceCount_eq_masterClaimGapReferenceCount`
- `HodgeReduction.MainChain.masterRouteGapRowsWithMasterClaims`
- `HodgeReduction.MainChain.masterRouteGapRowsWithoutMasterClaims`
- `HodgeReduction.MainChain.masterRouteGapIdsWithoutMasterClaims`
- `HodgeReduction.MainChain.masterRouteGapRowsWithoutMasterClaimsAreExpectedStructuralInfra`
- `HodgeReduction.MainChain.MasterRouteGapClaimCoverageSnapshot`
- `HodgeReduction.MainChain.currentMasterRouteGapClaimCoverageSnapshot`
- `HodgeReduction.MainChain.currentMasterRouteGapClaimCoverageSnapshot_eq_texStatus`
- `HodgeReduction.MainChain.masterRouteGapClaimCoverageFailureCount`
- `HodgeReduction.MainChain.fullHcGapStatus_eq_finalOpen`
- `HodgeReduction.MainChain.fullHcNarrativeClaimsCompleteProof`
- `HodgeReduction.MainChain.PaperNarrativeConsistencySnapshot`
- `HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot`
- `HodgeReduction.MainChain.currentPaperNarrativeConsistencySnapshot_eq_texStatus`
- `HodgeReduction.MainChain.fullHcCompletionOverclaimCount`
- `HodgeReduction.MainChain.fullHcFinalOpenStatusFailureCount`
- `HodgeReduction.MainChain.masterClaimTagPointerFailureCount`
- `HodgeReduction.MainChain.masterClaimDispositionTagMismatchCount`
- `HodgeReduction.MainChain.masterBrokenLinkDisciplineFailureCount`
- `HodgeReduction.MainChain.masterSubgapStatusMarkerFailureCount`
- `HodgeReduction.MainChain.masterPrimaryHypothesisDisciplineFailureCount`
- `HodgeReduction.MainChain.scopeSubclassRouteGapReferenceIds`
- `HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceIds`
- `HodgeReduction.MainChain.unregisteredScopeSubclassRouteGapReferenceCount`
- `HodgeReduction.MainChain.allScopeSubclassRouteGapReferencesRegisteredInRoute`
- `HodgeReduction.MainChain.masterScopeSubclassStatusFailureCount`
- `HodgeReduction.MainChain.projectAxiomTrustBaseFailureCount`
- `HodgeReduction.MainChain.projectSorryAxFailureCount`
- `HodgeReduction.AxiomInventory.currentProjectSorryAxSnapshot_eq_texStatus`
- `HodgeReduction.AxiomInventory.projectDeclarationsWithSorryAxCount_eq_zero`
- `HodgeReduction.MainChain.masterSourceDisciplineFailureCount`
- `HodgeReduction.MainChain.masterEnvironmentCoverageFailureCount`
- `HodgeReduction.MainChain.paperSummaryClaimFailureCount`
- `HodgeReduction.MainChain.paperSummaryClaimFailureCount_eq_zero`
- `HodgeReduction.RanCoherenceInputData`
- `HodgeReduction.RanCoherenceInputData.coherence_lemma_from_oka_and_bbt_definable_oka`
- `HodgeReduction.RanCoherenceInputData.input_ran_from_coherence_lemma`
- `HodgeReduction.oka_coherence_does_not_self_close_ran_input`
- `HodgeReduction.CMDensityInputData`
- `HodgeReduction.CMDensityInputData.cm_density_in_special_subvariety_from_tsimerman`
- `HodgeReduction.CMDensityInputData.cm_density_in_hodge_locus_from_special_component`
- `HodgeReduction.specialness_does_not_self_close_cm_density`
- `HodgeReduction.PeterzilStarchenkoInputData`
- `HodgeReduction.PeterzilStarchenkoInputData.definable_closed_analytic_subset_is_algebraic`
- `HodgeReduction.definable_analytic_set_does_not_self_close_algebraicity`
- `HodgeReduction.VoisinIntegralCounterexampleData`
- `HodgeReduction.VoisinIntegralCounterexampleData.integral_hodge_counterexample_from_voisin`
- `HodgeReduction.VoisinIntegralCounterexampleData.voisin_integral_failure_does_not_contradict_rational_target`
- `HodgeReduction.integral_hc_failure_alone_does_not_self_close_rational_scope`
- `HodgeReduction.MargulisConditionalData`
- `HodgeReduction.MargulisConditionalData.arithmeticity_if_monodromy_is_lattice`
- `HodgeReduction.MargulisConditionalData.representation_extension_if_monodromy_is_lattice`
- `HodgeReduction.margulis_rank_inputs_do_not_self_close_without_lattice_hypothesis`
- `HodgeReduction.RationalScalarExtensionDescentData.padic_descent_linear_algebra_core`
- `HodgeReduction.WitnessLatticeHypothesis`
- `HodgeReduction.WitnessLatticeHypothesis.orthogonalComplement_signature_eq_p_two`
- `HodgeReduction.MonodromyLatticeContainmentData`
- `HodgeReduction.containment_in_arithmetic_lattice_does_not_force_finite_covolume`
- `HodgeReduction.ShimuraTypeFibreData`
- `HodgeReduction.ShimuraTypeFibreData.invariant_classes_realized_through_map`
- `HodgeReduction.aniso_empty_isotropic_core`
- `HodgeReduction.CMFibreDensityData`
- `HodgeReduction.CMFibreDensityData.shimura_fibre_density_from_transport`
- `HodgeReduction.cm_density_alone_does_not_force_e7_family_density`
- `HodgeReduction.RankTwoCMCY3CorrespondenceData`
- `HodgeReduction.RankTwoCMCY3CorrespondenceData.algebraicity_from_rank_two_cm_cy3_hypothesis`
- `HodgeReduction.blasius_deligne_do_not_self_close_cm_cy3_correspondence`
- `HodgeReduction.MotivicSpanData`
- `HodgeReduction.MotivicSpanData.rigid_nonabelian_cm_subcase_from_motivic_span`
- `HodgeReduction.cm_correspondence_does_not_self_close_motivic_span`
- `HodgeReduction.AbelianTypeCoverageData`
- `HodgeReduction.AbelianTypeCoverageData.abelian_type_coverage_from_hc_cm_and_ran`
- `HodgeReduction.hc_cm_abelian_does_not_self_close_abelian_type_coverage`
- `HodgeReduction.KugaSatakeP3Data`
- `HodgeReduction.KugaSatakeP3Data.ks_p3_from_spin_hodge_and_correspondence`
- `HodgeReduction.spin_abs_periodicity_does_not_self_close_ks_p3`
- `HodgeReduction.AbsoluteHodgeDescentData`
- `HodgeReduction.AbsoluteHodgeDescentData.ahd_from_wlh_hodge_locus_principleB_and_hcab`
- `HodgeReduction.hc_ab_and_hodge_locus_do_not_self_close_ahd`
- `HodgeReduction.GLBOrthClosureData`
- `HodgeReduction.GLBOrthClosureData.glb_orth_from_meyer_ahd_ks_and_hcab`
- `HodgeReduction.GLBOrthClosureData.orthogonal_coverage_from_glb_orth`
- `HodgeReduction.meyer_input_does_not_self_close_glb_orth`
- `HodgeReduction.GenericFibreInvariantData`
- `HodgeReduction.GenericFibreInvariantData.generic_fibre_invariant_from_full_package`
- `HodgeReduction.invariant_theory_and_chern_classes_do_not_self_close_generic_fibre`
- `HodgeReduction.SatakeAbelianClassificationData`
- `HodgeReduction.SatakeAbelianClassificationData.exceptional_eiii_evii_not_abelian_type`
- `HodgeReduction.exceptional_label_does_not_self_close_satake_classification`
- `HodgeReduction.E7ApproachFTotalSpaceData`
- `HodgeReduction.E7ApproachFTotalSpaceData.total_space_class_from_chern_weil_bridge`
- `HodgeReduction.approach_f_total_space_does_not_self_close_fibre_level_class`
- `HodgeReduction.CMEigenvalueSeparationData`
- `HodgeReduction.CMEigenvalueSeparationData.abelian_type_eigenvalue_separation_from_honda_tate`
- `HodgeReduction.CMEigenvalueSeparationData.nonabelian_e7_eigenvalue_separation_from_honda_tate_extension`
- `HodgeReduction.abelian_honda_tate_does_not_self_close_nonabelian_e7_eigenvalue_separation`
- `HodgeReduction.E7ArithmeticityStep1Data`
- `HodgeReduction.E7ArithmeticityStep1Data.arithmeticity_from_all_inputs`
- `HodgeReduction.e7_arithmeticity_not_from_boundary_data_alone`
- `HodgeReduction.BBTRigidReachData`
- `HodgeReduction.BBTRigidReachData.rigid_isolated_reach_from_full_package`
- `HodgeReduction.bbt_frameworks_do_not_self_close_rigid_isolated_reach`
- `HodgeReduction.NonRigidFamilyBridgeData`
- `HodgeReduction.NonRigidFamilyBridgeData.base_dimension_from_period_package`
- `HodgeReduction.NonRigidFamilyBridgeData.nonrigid_family_bridge_from_full_period_package`
- `HodgeReduction.nonrigidity_does_not_self_close_period_family_bridge`
- `HodgeReduction.E7BBTSpreadingData`
- `HodgeReduction.E7BBTSpreadingData.e7_bbt_spreading_from_full_package`
- `HodgeReduction.E7BBTSpreadingData.individual_scope_transfer_from_family_spreading_and_bridges`
- `HodgeReduction.bbt_cm_density_do_not_self_close_e7_bbt_spreading`
- `HodgeReduction.family_spreading_does_not_self_close_individual_e7_scope`
- `HodgeReduction.E7CMAlgebraicityData`
- `HodgeReduction.E7CMAlgebraicityData.absolute_hodge_from_nonabelian_e7_extension`
- `HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_absolute_hodge_and_hbundle`
- `HodgeReduction.E7CMAlgebraicityData.cm_e7_algebraicity_from_full_package`
- `HodgeReduction.abelian_frameworks_do_not_self_close_nonabelian_e7_absolute_hodge`
- `HodgeReduction.absolute_hodge_does_not_self_close_cm_e7_algebraicity`
- `HodgeReduction.E7ChernWeilBridgeData`
- `HodgeReduction.E7ChernWeilBridgeData.compact_dual_nonzero_from_schwarz_bridge`
- `HodgeReduction.E7ChernWeilBridgeData.toroidal_class_from_matsushima_descent`
- `HodgeReduction.E7ChernWeilBridgeData.algebraicity_from_chern_polynomial_identity`
- `HodgeReduction.E7ChernWeilBridgeData.e7_chern_weil_algebraicity_from_full_bridge`
- `HodgeReduction.schwarz_invariant_ring_does_not_self_close_e7_chern_weil`
- `HodgeReduction.cocompact_matsushima_does_not_self_close_noncompact_e7_chern_weil`
- `HodgeReduction.ExoticE7NarrowingData`
- `HodgeReduction.ExoticE7NarrowingData.exotic_residual_narrowed_from_geometric_eliminations`
- `HodgeReduction.exotic_narrowing_does_not_self_close_residual`
- `HodgeReduction.TorelliEVIIQuestionData`
- `HodgeReduction.TorelliEVIIQuestionData.exotic_rigid_vacuity_from_evii_uniformisation`
- `HodgeReduction.arithmeticity_and_mok_do_not_self_close_torelli_evii`
- `HodgeReduction.ExoticE7ResidualData`
- `HodgeReduction.ExoticE7ResidualData.exotic_residual_eliminated_from_all_subbranches`
- `HodgeReduction.known_e7_cases_do_not_self_close_exotic_residual`
- `HodgeReduction.FullHCResidualGateData`
- `HodgeReduction.FullHCResidualGateData.full_hodge_conjecture_from_residual_gate`
- `HodgeReduction.E7ResidualStrategyData`
- `HodgeReduction.E7ResidualStrategyData.residual_hc_from_theta_transfer`
- `HodgeReduction.E7ResidualStrategyData.residual_hc_from_padic_route`
- `HodgeReduction.E7ResidualStrategyData.residual_hc_from_bost_charles_route`
- `HodgeReduction.theta_shimura_cycle_does_not_self_close_residual_hc`
- `HodgeReduction.padic_descent_does_not_self_close_residual_hc`
- `HodgeReduction.bost_charles_framework_does_not_self_close_residual_hc`
- `HodgeReduction.OmegaDiagonalData`
- `HodgeReduction.OmegaDiagonalData.cohomological_identity_from_standard_conjecture_package`
- `HodgeReduction.OmegaDiagonalData.omega_algebraic_from_diagonal_standard_conjectures_and_schur`
- `HodgeReduction.OmegaDiagonalData.schur_projector_step_iff_omega_algebraicity`
- `HodgeReduction.standard_conjecture_pair_does_not_self_close_omega_diagonal`
- `HodgeReduction.andre_motivated_closure_does_not_self_close_chow_omega`
- `HodgeReduction.E7ChowModularityData`
- `HodgeReduction.E7ChowModularityData.chow_modularity_from_full_package`
- `HodgeReduction.ThetaIsChowModular`
- `HodgeReduction.IsExceptionalE7ChowModularityExtension_CONJECTURAL`
- `HodgeReduction.orthogonal_chow_frameworks_do_not_self_close_exceptional_e7_chow_modularity`
- `HodgeReduction.E7ThetaModularityData`
- `HodgeReduction.E7ThetaModularityData.cohomological_theta_modularity_from_kernel`
- `HodgeReduction.E7ThetaModularityData.e7_chow_modularity_from_full_package`
- `HodgeReduction.cohomological_theta_does_not_self_close_chow_valued_e7_modularity`
- `HodgeReduction.E7ThetaMatchData`
- `HodgeReduction.E7ThetaMatchData.theta_match_from_full_package`
- `HodgeReduction.E7ThetaMatchData.nonzero_algebraic_theta_cycle_from_match`
- `HodgeReduction.chow_modularity_and_theta_framework_do_not_self_close_theta_match`
- `HodgeReduction.E7ThetaStepIIIData`
- `HodgeReduction.E7ThetaStepIIIData.shimura_side_cycle_seeding_from_theta_package`
- `HodgeReduction.E7ThetaStepIIIData.hbundle_cycle_seeding_from_theta_and_fibre_transfer`
- `HodgeReduction.shimura_side_theta_cycle_does_not_self_close_fibre_transfer`
- `HodgeReduction.HBundleMatchingData`
- `HodgeReduction.HBundleMatchingData.bundle_matching_from_rigid_point_case`
- `HodgeReduction.HBundleMatchingData.bundle_matching_from_toroidal_reduction_package`
- `HodgeReduction.known_hbundle_cases_do_not_self_close_arbitrary_nontoroidal_boundary`
- `HodgeReduction.HBundleCycleSeedingData`
- `HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_low_dimensional_lefschetz`
- `HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_nonrigid_e7_package`
- `HodgeReduction.HBundleCycleSeedingData.cycle_seeding_from_known_rigid_e7_package`
- `HodgeReduction.low_dimensional_hbundle_does_not_self_close_high_dimensional_residual`
- `HodgeReduction.HBundleInputData`
- `HodgeReduction.HBundleInputData.hbundle_input_from_matching_and_cycle_seeding`
- `HodgeReduction.bundle_matching_does_not_self_close_hbundle_input`
- `HodgeReduction.FibreTransferData`
- `HodgeReduction.FibreTransferData.base_level_algebraicity_from_shimura_side`
- `HodgeReduction.shimura_side_and_period_map_do_not_self_close_fibre_algebraicity`
- `HodgeReduction.E7FibreInvariantClassSplitData`
- `HodgeReduction.E7FibreInvariantClassSplitData.all_invariant_classes_from_h3_algebraicity`
- `HodgeReduction.motivated_h3_class_does_not_self_close_algebraicity`
- `HodgeReduction.Q4AbelianAlgebraicityData`
- `HodgeReduction.Q4AbelianAlgebraicityData.pointwise_q4_algebraicity_from_cm_abelian_bridge`
- `HodgeReduction.Q4AbelianAlgebraicityData.global_q4_algebraicity_from_full_transfer`
- `HodgeReduction.pointwise_q4_algebraicity_does_not_self_close_global_e7`
- `HodgeReduction.MokTorelliConditionalShape`
- `HodgeReduction.mok_conditional_does_not_self_close_torelli`

Taxonomy files:
- `HodgeReduction/PaperInventory.lean` -- infra
- `HodgeReduction/Research/AnisotropicResidue.lean` -- registered
- `HodgeReduction/Research/ClassicalExternalStatus.lean` -- registered
- `HodgeReduction/Research/CMFibreDensity.lean` -- registered
- `HodgeReduction/Research/E7ArithmeticityPipeline.lean` -- registered
- `HodgeReduction/Research/E7BBTSpreading.lean` -- registered
- `HodgeReduction/Research/E7CMAlgebraicity.lean` -- registered
- `HodgeReduction/Research/E7ChernWeilBridge.lean` -- registered
- `HodgeReduction/Research/E7ResidualStatus.lean` -- registered
- `HodgeReduction/Research/E7ThetaModularity.lean` -- registered
- `HodgeReduction/Research/FibreTransfer.lean` -- registered
- `HodgeReduction/Research/HBundleStatus.lean` -- registered
- `HodgeReduction/Research/LatticeGap.lean` -- registered
- `HodgeReduction/Research/MainTheoremInputStatus.lean` -- registered
- `HodgeReduction/Research/MainTheoremResidualStatus.lean` -- registered
- `HodgeReduction/Research/MokCircularity.lean` -- registered
- `HodgeReduction/Research/OmegaDiagonal.lean` -- registered
- `HodgeReduction/Research/PadicDescent.lean` -- registered
- `HodgeReduction/Research/Q4AbelianAlgebraicity.lean` -- registered
- `HodgeReduction/Research/ShimuraTypeFibre.lean` -- registered
- `HodgeReduction/Research/WitnessLatticeHypothesis.lean` -- registered
- `HodgeReduction/OpenHypotheses.lean` -- cut
- `HodgeReduction/MainTheorem.lean` -- cut
- `HodgeReduction/AxiomInventory.lean` -- infra

### `chain:main-hc-axiom-relative` -- Canonical E7 Mumford--Tate-reduction milestone

`OpenHypotheses` (R169 cohomology / algClasses bridge + R174a Deligne) composes with `MainTheorem` (R170 four-case main reduction + R171/R188/R542/R551 canonical headline) to reach `hodgeConjectureReal_canonical`.  This is explicitly a milestone toward `FullHodgeConjectureReal`, not the final project theorem.  R546 adds the separately audited codim-one endpoint `hodgeConjectureReal_canonical_codim1`; R550 reroutes it directly through the classical Lefschetz (1,1) cut; R551 uses that endpoint for the `p = 1` branch of the full canonical proof, uses the direct non-codim-one MT package for `p 鈮?1`, and avoids mentioning `canonicalHCDataByCodim` in the endpoint type.  Full HC still requires a universal route over all smooth projective complex varieties.

Entry declarations:
- `HodgeReduction.hodgeConjectureReal_canonical`
- `HodgeReduction.hodgeConjectureReal_canonical_codim1`
- `HodgeReduction.main_reduction_real`

Taxonomy files:
- `HodgeReduction/Types.lean` -- on-chain
- `HodgeReduction/ClassicalResults.lean` -- on-chain
- `HodgeReduction/OpenHypotheses.lean` -- cut
- `HodgeReduction/MainTheorem.lean` -- cut
- `HodgeReduction/HCGapRegistry.lean` -- infra

### `chain:unconditional-classical` -- Unconditional classical paper theorems

Meyer / G_2 / F_4 / E_8 vacuity are kernel-pure derived theorems.  `thm_cy3_e7_nonexistence` still consumes `cy3_e7_nonexistence_paper_axiom` (paper 搂4 Stages A--D).

Entry declarations:
- `HodgeReduction.thm_Meyer`
- `HodgeReduction.thm_G2F4`
- `HodgeReduction.thm_E8_vacuous`
- `HodgeReduction.thm_cy3_e7_nonexistence`
- `HodgeReduction.thm_subcase3b_vacuous`

Taxonomy files:
- `HodgeReduction/ClassicalResults.lean` -- on-chain
- `HodgeReduction/MainTheorem.lean` -- cut

### `chain:hcgap-l2-trivial-instances` -- Layer-2 minimum attack: trivial-instance VarietyCohomologyData

R201 minimum-attack instances of `VarietyCohomologyData`: trivial point (dim 0), projective line (dim 1), elliptic curve (dim 1).  Provides the template that a future E_7 construction must follow.

Taxonomy files:
- `HodgeReduction/HCGapL2/TrivialPoint.lean` -- registered
- `HodgeReduction/HCGapL2/ProjectiveLine.lean` -- registered
- `HodgeReduction/HCGapL2/EllipticCurve.lean` -- registered

### `chain:hcgap-l4-multifront-active` -- HCGapL4 multi-front attack waves (R420 -- R676)

5 parallel attack fronts on the L4 cohomology-profile + connectedness pipeline.  Per-wave audits R451 / R456 / R460 / R465 / R470 / R476 enumerate substantive theorems per round.  R552 extends the FrontC numeric bridge through a buildable EVII compact-dual/V56/Shimura expected Betti profile: all degrees 0..8 are certified by known Hodge sums, with degree 3 explicitly routed through V56 rather than hidden in compact-dual odd cohomology.  R553 connects that finite V56 profile to the actual infrastructure `PureHodgeStructure V56 3`.  R554 proves the abstract Matsushima boundary composition: target invariants reduce to the cuspidal trivial-module part, and compact-dual image reduces to that part once concrete EVII source/target boundary equalities are provided.  R555 tightens the source-side obligation: Cartan's trivial-module H8 line rewrites to compact-dual H8, its classes are algebraic through `CompactDualData`, and the R554 source equality follows from `surjectivity_source = source_invariants`.  R556 converts the remaining boundary equalities into four concrete linear-algebra tasks; R557 shows target containment is forced by source containment; R558 transports target finrank from source finrank; R559 rewrites the remaining source obligations against compact-dual/Cartan data; R560 proves those obligations are not derivable from the current abstract interface alone; R561 replaces the three R559 obligations by the sharper compact-dual exact image target plus target-invariant exactness; R562 removes target-invariant exactness as an independent obligation by deriving it from exact image plus the compactDual/trivialModulePart rank bridge; R563 proves exact image is equivalent to the source equality `surjectivity_source = compactDual`; R564 closes the compact-dual H8 rank-one side and reduces the rank bridge to `compactDual = H8` plus `finrank trivialModulePart = 1`; R565 replaces that target rank-one obligation by exact Cartan image equality; R566 rewrites the remaining source and compact-dual carrier obligations to Cartan-line exactness; R567 blocks any attempt to derive those exactness statements from the current abstract interface alone; R568 turns exact Cartan image into the element-level scalar-preimage target `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta`; R569 shows that even compactDual = Cartan does not force that scalar-surjectivity target; R570 proves that target rank-one plus compactDual = Cartan is enough for exact Cartan image; R571/R572 reduce the live target to source equality, source-invariants/H8, and expected Betti-8 target rank; R573 splits source-invariants/H8 into no-extra-source containment and `h^4` generator membership, with a source-rank-one alternate route; R574 rewrites that source-carrier split through `MatsushimaCompactDualData.compactDual`, leaving compactDual containment in H8 plus generator membership as the next concrete carrier targets; R575 rewrites those as the Cartan/compactDual containments `compactDual <= CartanH8` and `CartanH8 <= compactDual`; R576 rewrites source equality as source/Cartan two-sided containment and feeds the two source directions plus the two compactDual directions into the boundary package; R577 records that all four carrier directions still do not imply the target expected-Betti rank; R578 routes that target rank through the degree-8 compact-dual Hodge-sum profile; R579 derives the target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from compactDual/Cartan two-sided containment plus scalar preimage surjectivity; R581 proves that target Hodge-sum rank and scalar-preimage surjectivity are equivalent once the four Cartan carrier directions are fixed; R582 rewrites the four Cartan carrier directions as source/compactDual H8 no-extra plus h^4 generator-membership splits; R583 collapses each H8 split to exact equality with H8; R584 translates those H8 equalities into Matsushima boundary language and proves target Hodge-sum rank is equivalent to `surjectivity_target = trivialModulePart`; R585 proves that, after `compactDual = H8`, this concrete boundary package is equivalent to the existing `MatsushimaV56BoundaryData`; R586 records a countermodel showing the H8 carrier equalities alone do not force the target boundary equality or boundary data; R587 isolates the remaining target boundary as the single reverse containment `trivialModulePart <= surjectivity_target`, and proves that this containment is also not forced by the abstract H8 carrier interface; R588 proves this reverse containment is exactly the element-level scalar-preimage statement `forall beta in trivialModulePart, exists r, j_q (r 鈥?h^4) = beta` once `source = H8`, with no finite-dimensional rank hypothesis; R589 proves that, under the two H8 carrier equalities, target boundary/scalar preimages/boundary data/target Hodge-sum are all equivalent to `finrank trivialModulePart = 1`, and the rank-one target is not forced by the abstract H8 carrier interface.  R590 proves the target expected-Betti rank is equivalent to that rank-one theorem, identifies boundary data with expected-Betti rank under the H8 carriers, and records that the H8 carrier interface still does not force the expected-Betti target.  R591 names the exact residual package: prove the two H8 carrier equalities and target-invariant rank one; this package feeds the existing boundary bridge.  R592 proves this rank-one residual package is equivalent to the scalar-preimage residual package.  R593 packages the equivalent target-boundary residual package and records that the abstract H8 carrier interface still does not force it.  R594 packages the same residual target as `compactDual = H8` plus the existing `MatsushimaV56BoundaryData` bridge.  R595 rewrites that residual bridge as `compactDual = H8`, compact-dual exact image, and target-invariant exactness.  R596 replaces that target-invariant exactness by the equivalent rank-one target `finrank trivialModulePart = 1` once compact-dual exact image is fixed.  R597 proves that this exact-image rank-one package is equivalent to Cartan-line source/compact-dual equalities plus `finrank trivialModulePart = 1`, exposing the live residual as Cartan H8 carrier exactness and target rank.  R598 rewrites that same residual as `surjectivity_source = source_invariants`, `source_invariants = H8`, and `finrank target_invariants = 1`.  R599 proves the R598 source-invariant package is directly equivalent to the earlier R591 H8/rank-one residual package, recovers the expected Betti-8 target rank from it, and records that `source_invariants = H8` alone still does not force the full residual.  R600 replaces the target-rank spelling inside that package by the expected-Betti-8 equality `finrank target_invariants = shimuraEVIIExpectedBetti 8`, proves equivalence with R598, and keeps the same obstruction visible.  R601 splits the source-invariants/H8 equality into the equivalent source-carrier targets `source_invariants <= H8` plus `h^4` membership, packages that split against the R600 expected-Betti target, and keeps the obstruction visible.  R602 moves that same residual to the equivalent compact-dual carrier targets `compactDual <= H8` plus `h^4` membership in `compactDual`, using the existing compactDual/source-invariants comparison and preserving the obstruction.  R603 proves this R602 package is equivalent to the four Cartan containment directions together with the same target expected-Betti theorem, while preserving the R577 obstruction that carrier facts alone do not force target rank.  R604 splits the R603 residual into four carrier directions plus one target expected-Betti theorem and certifies primitive target count 5.  R605 proves that this fifth target can equivalently be attacked as scalar-preimage surjectivity under the same four carrier directions, so expected-Betti rank and scalar preimage are one target, not two.  R606 flattens the same residual into the five named paper-facing primitive targets and kernel-checks that expected-Betti rank and scalar preimage are not counted separately.  R607 proves that the five paper-facing primitive targets are equivalent to the three proof-work obligations `surjectivity_source = CartanH8`, `compactDual = CartanH8`, and scalar-preimage surjectivity.  R608 reconciles scalar-preimage surjectivity with the older `finrank trivialModulePart = 1` rank-one target under the two Cartan-line equalities, so those spellings are not separate gaps.  R609 proves that the two Cartan-line carrier equalities alone do not force the scalar/rank-one target in the current abstract interface.  R610 packages the exact live proof-work contract as those two equalities plus one scalar/rank-one target, proves it is equivalent to the R607/R608 residual ledgers, and records that the contract is not a closure claim.  R634 rewrites that same contract as the source-invariant scalar contract `surjectivity_source = source_invariants`, `source_invariants = H8`, plus scalar/rank-one target, without adding finite-dimensional rank conversion or closure claim.  R635 replaces the first R634 equality by the equivalent exact-image equation `Submodule.map j_q source_invariants = surjectivity_target`, using only the existing Matsushima image equation and injectivity.  R636 replaces the scalar/rank-one target by the equivalent reverse target containment `trivialModulePart <= surjectivity_target` once exact image and `source_invariants = H8` are fixed.  R637 records the matching obstruction: those exact-image carriers do not force the reverse target containment in the current abstract interface.  R638 rewrites that target theorem as exact Matsushima target-invariant image saturation: under exact image, the live target is `Submodule.map j_q source_invariants = target_invariants`, and the carrier countermodel still blocks deriving it abstractly.  R639 proves this saturation is equivalent to the finite-dimensional invariant-rank equality `finrank source_invariants = finrank target_invariants`, so the next target is a genuine EVII target-invariant rank computation.  R640 reconciles that target with the existing R600 expected-Betti residual, showing that under `source_invariants = H8` it is exactly `finrank target_invariants = shimuraEVIIExpectedBetti 8`.  R641 rewrites the target side as the vanishing of the target-invariant excess quotient by `Submodule.map j_q source_invariants`, equivalent to saturation and expected-Betti under `source_invariants = H8`.  R642 identifies the kernel of this quotient map as the source-invariant image inside `target_invariants`, proves range/kernel rank-nullity, and turns quotient vanishing into codimension zero for that internal subspace.  R643 makes the codimension target numerical: prove `finrank targetInvariantExcessQuotient = 0`, equivalently the R600/R640 expected-Betti target under `source_invariants = H8`.  The route remains exploratory, not a closure claim.

Entry declarations:
- `HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBettiKnownHodgeSumCertification_current`
- `HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimura_expected_known_hodgeSum_total`
- `HodgeReduction.HCGapL4.FrontC12_V56InfrastructureProfileBridge.v56InfrastructureProfileCertification_current`
- `HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge.matsushima_compactDual_image_eq_trivialModulePart`
- `HodgeReduction.HCGapL4.FrontC13_MatsushimaV56BoundaryBridge.matsushimaV56BoundaryCertification_from_boundary`
- `HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.cartan_trivialModuleGK_H8_classes_are_algebraic`
- `HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.matsushimaV56BoundaryData_of_source_target_invariants`
- `HodgeReduction.HCGapL4.FrontC14_CartanCompactDualSourceBridge.cartanCompactDualSourceCertification_current`
- `HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.source_eq_invariants_of_le_finrank`
- `HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.target_eq_trivialModulePart_of_le_finrank`
- `HodgeReduction.HCGapL4.FrontC15_MatsushimaBoundaryRankCriterion.matsushimaV56BoundaryData_of_rank_criteria`
- `HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.surjectivity_target_le_trivialModulePart_of_source_le`
- `HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.target_eq_invariants_of_source_le_target_finrank`
- `HodgeReduction.HCGapL4.FrontC16_MatsushimaTargetContainmentFromSource.matsushimaV56BoundaryData_of_source_le_source_rank_target_rank`
- `HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.surjectivity_target_finrank_eq_source`
- `HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.target_finrank_eq_trivialModulePart_of_source_finrank_trivial`
- `HodgeReduction.HCGapL4.FrontC17_MatsushimaTargetRankFromSource.matsushimaV56BoundaryData_of_source_le_source_rank_source_to_trivial_rank`
- `HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.source_eq_invariants_of_source_le_compactDual_rank`
- `HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.source_finrank_eq_trivialModulePart_of_compactDual_rank`
- `HodgeReduction.HCGapL4.FrontC18_MatsushimaSourceCompactDualRankBridge.matsushimaV56BoundaryData_of_source_le_compactDual_rank_compactDual_to_trivial_rank`
- `HodgeReduction.HCGapL4.FrontC19_MatsushimaSourceCompactDualObstruction.current_interface_does_not_force_R559_targets`
- `HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.source_eq_compactDual_of_compactDual_image_eq_surjectivity_target`
- `HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.compactDual_finrank_eq_trivialModulePart_of_exact_image_target_eq`
- `HodgeReduction.HCGapL4.FrontC20_MatsushimaCompactDualExactImageCriterion.matsushimaV56BoundaryData_of_compactDual_exact_image_target_eq`
- `HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.target_eq_invariants_of_compactDual_exact_image_trivial_rank`
- `HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.matsushimaV56BoundaryData_of_compactDual_exact_image_trivial_rank`
- `HodgeReduction.HCGapL4.FrontC21_MatsushimaExactImageRankBoundary.matsushima_compactDual_image_eq_trivialModulePart_of_exact_image_rank`
- `HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.source_eq_compactDual_iff_compactDual_exact_image`
- `HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.matsushimaV56BoundaryData_of_source_eq_compactDual_trivial_rank`
- `HodgeReduction.HCGapL4.FrontC22_MatsushimaExactImageSourceEquivalence.matsushima_compactDual_image_eq_trivialModulePart_of_source_eq_rank`
- `HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_H8_finrank_eq_one`
- `HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.compactDual_finrank_eq_trivialModulePart_of_H8_rank_one`
- `HodgeReduction.HCGapL4.FrontC23_MatsushimaCompactDualRankOne.matsushimaV56BoundaryData_of_source_eq_H8_rank_one`
- `HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.map_cartan_trivialModuleGK_H8_finrank_eq_one`
- `HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.trivialModulePart_finrank_eq_one_of_cartan_image`
- `HodgeReduction.HCGapL4.FrontC24_CartanImageTrivialRank.matsushimaV56BoundaryData_of_source_eq_H8_cartan_image`
- `HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.matsushima_compactDual_eq_H8_of_eq_cartan`
- `HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.source_eq_compactDual_of_source_eq_cartan_and_compactDual_eq_cartan`
- `HodgeReduction.HCGapL4.FrontC25_CartanLineBoundaryExactness.matsushimaV56BoundaryData_of_cartan_line_exactness`
- `HodgeReduction.HCGapL4.FrontC26_CartanLineExactnessObstruction.current_interface_does_not_force_cartan_line_exactness`
- `HodgeReduction.HCGapL4.FrontC27_CartanImageScalarPreimage.cartan_image_eq_trivialModulePart_iff_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC28_ScalarPreimageObstruction.current_interface_with_compactDual_cartan_does_not_force_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC29_CartanImageFromRankOne.cartan_image_eq_trivialModulePart_of_compactDual_eq_cartan_trivial_rank_one`
- `HodgeReduction.HCGapL4.FrontC30_SourceInvariantsH8TargetRank.matsushimaV56BoundaryData_of_source_invariants_H8_target_rank_one`
- `HodgeReduction.HCGapL4.FrontC31_TargetRankFromExpectedBetti.matsushimaV56BoundaryData_of_source_invariants_H8_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC32_SourceInvariantsH8CarrierCriterion.matsushimaV56BoundaryData_of_source_le_H8_h_pow_4_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC33_CompactDualH8CarrierCriterion.matsushimaV56BoundaryData_of_compactDual_le_H8_h_pow_4_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC34_CartanContainmentsForCompactDual.matsushimaV56BoundaryData_of_compactDual_cartan_containments_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC35_SourceCartanContainments.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC36_TargetBettiObstruction.current_interface_with_four_cartan_containments_does_not_force_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC37_TargetRankHodgeSumBridge.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_target_hodgeSum8`
- `HodgeReduction.HCGapL4.FrontC38_TargetHodgeSumFromCartanImage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_cartan_image`
- `HodgeReduction.HCGapL4.FrontC39_TargetHodgeSumFromScalarPreimage.matsushimaV56BoundaryData_of_source_compactDual_cartan_containments_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC40_TargetRankScalarPreimageEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_cartan_containments`
- `HodgeReduction.HCGapL4.FrontC41_CartanContainmentCarrierEquivalence.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_H8_splits`
- `HodgeReduction.HCGapL4.FrontC42_H8CarrierEqualityRoute.target_hodgeSum8_iff_scalar_preimage_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC43_H8BoundaryEqualityRoute.target_hodgeSum8_iff_surjectivity_target_eq_trivialModulePart_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC44_BoundaryDataH8Equivalence.target_hodgeSum8_iff_matsushimaV56BoundaryData_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC45_H8BoundaryDataObstruction.current_interface_with_H8_equalities_does_not_force_target_boundary`
- `HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.target_hodgeSum8_iff_trivialModulePart_le_surjectivity_target_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC46_TargetSurjectivityContainmentCriterion.counterexample_not_trivialModulePart_le_surjectivity_target`
- `HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.target_boundary_iff_scalar_preimage_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC47_TargetContainmentScalarPreimageCriterion.counterexample_not_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion.target_boundary_iff_trivialModulePart_finrank_eq_one_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC48_H8BoundaryRankOneCriterion.current_interface_with_H8_equalities_does_not_force_trivialModulePart_rank_one`
- `HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion.matsushimaV56BoundaryData_iff_target_expected_betti8_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC49_H8BoundaryExpectedBettiCriterion.current_interface_with_H8_equalities_does_not_force_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.target_expected_betti8_iff_target_invariants_finrank_eq_one`
- `HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.EVIIH8ResidualRankOneObligations`
- `HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.target_expected_betti8_of_residual_obligations`
- `HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.matsushimaV56BoundaryData_of_residual_obligations`
- `HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.matsushimaV56BoundaryData_of_H8_and_target_rank_one`
- `HodgeReduction.HCGapL4.FrontC50_H8ResidualObligationPackage.current_interface_with_H8_equalities_does_not_force_target_rank_one`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.target_rank_one_iff_scalar_preimage_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.target_expected_betti8_iff_scalar_preimage_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.EVIIH8ResidualScalarPreimageObligations`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.rankOneResidual_of_scalarPreimageResidual`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.scalarPreimageResidual_of_rankOneResidual`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.residual_rankOne_nonempty_iff_scalarPreimage_nonempty`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.matsushimaV56BoundaryData_of_scalarPreimageResidual`
- `HodgeReduction.HCGapL4.FrontC51_H8ResidualScalarPreimagePackage.current_interface_with_H8_equalities_does_not_force_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.target_boundary_iff_scalar_preimageTarget_of_source_compactDual_eq_H8`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.EVIIH8ResidualBoundaryObligations`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.boundaryResidual_of_scalarPreimageResidual`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.scalarPreimageResidual_of_boundaryResidual`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.residual_scalarPreimage_nonempty_iff_boundary_nonempty`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.residual_rankOne_nonempty_iff_boundary_nonempty`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.matsushimaV56BoundaryData_of_boundaryResidual`
- `HodgeReduction.HCGapL4.FrontC52_H8ResidualBoundaryPackage.current_interface_with_H8_equalities_does_not_force_target_boundary`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.EVIIH8ResidualBoundaryDataObligations`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.boundaryResidual_of_boundaryDataResidual`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.boundaryDataResidual_of_boundaryResidual`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_boundary_nonempty_iff_boundaryData_nonempty`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_scalarPreimage_nonempty_iff_boundaryData_nonempty`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.residual_rankOne_nonempty_iff_boundaryData_nonempty`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.matsushimaV56BoundaryData_of_boundaryDataResidual`
- `HodgeReduction.HCGapL4.FrontC53_H8ResidualBoundaryDataPackage.current_interface_with_compactDual_eq_H8_does_not_force_boundaryData`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.EVIIH8ResidualExactImageObligations`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.exactImageResidual_of_boundaryDataResidual`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.boundaryDataResidual_of_exactImageResidual`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_boundaryData_nonempty_iff_exactImage_nonempty`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_scalarPreimage_nonempty_iff_exactImage_nonempty`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.residual_rankOne_nonempty_iff_exactImage_nonempty`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.matsushimaV56BoundaryData_of_exactImageResidual`
- `HodgeReduction.HCGapL4.FrontC54_H8ResidualExactImagePackage.current_interface_with_compactDual_eq_H8_does_not_force_exactImageResidual`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.EVIIH8ResidualExactImageRankOneObligations`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.exactImageResidual_of_exactImageRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.exactImageRankOneResidual_of_exactImageResidual`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_exactImage_nonempty_iff_exactImageRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_boundaryData_nonempty_iff_exactImageRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.residual_rankOne_nonempty_iff_exactImageRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.matsushimaV56BoundaryData_of_exactImageRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC55_H8ResidualExactImageRankOnePackage.current_interface_with_compactDual_eq_H8_does_not_force_exactImageRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.EVIIH8ResidualCartanRankOneObligations`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.exactImageRankOneResidual_of_cartanRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.cartanRankOneResidual_of_exactImageRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.residual_exactImageRankOne_nonempty_iff_cartanRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.residual_boundaryData_nonempty_iff_cartanRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.matsushimaV56BoundaryData_of_cartanRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC56_H8ResidualCartanRankOnePackage.current_interface_with_compactDual_eq_H8_does_not_force_cartanRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.EVIIH8ResidualSourceInvariantTargetRankObligations`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.cartanRankOneResidual_of_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.sourceInvariantTargetRankResidual_of_cartanRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.residual_cartanRankOne_nonempty_iff_sourceInvariantTargetRank_nonempty`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.residual_boundaryData_nonempty_iff_sourceInvariantTargetRank_nonempty`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.matsushimaV56BoundaryData_of_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC57_H8ResidualSourceInvariantTargetRankPackage.current_interface_with_compactDual_eq_H8_does_not_force_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.residualRankOne_of_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.sourceInvariantTargetRankResidual_of_residualRankOne`
- `HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.residual_rankOne_nonempty_iff_sourceInvariantTargetRank_nonempty`
- `HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.target_expected_betti8_of_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC58_H8ResidualSourceInvariantNormalization.current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.EVIIH8ResidualSourceInvariantExpectedBettiObligations`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.sourceInvariantExpectedBettiResidual_of_sourceInvariantTargetRankResidual`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.sourceInvariantTargetRankResidual_of_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.residual_sourceInvariantTargetRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.target_rank_one_of_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.matsushimaV56BoundaryData_of_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC59_H8ResidualExpectedBettiPackage.current_interface_with_source_invariants_eq_H8_does_not_force_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.EVIIH8ResidualSourceCarrierSplitExpectedBettiObligations`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.source_invariants_eq_H8_of_sourceCarrierSplitResidual`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.h_pow_four_mem_source_invariants_of_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.sourceInvariantExpectedBettiResidual_of_sourceCarrierSplitResidual`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.sourceCarrierSplitResidual_of_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.residual_sourceInvariantExpectedBetti_nonempty_iff_sourceCarrierSplit_nonempty`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.matsushimaV56BoundaryData_of_sourceCarrierSplitResidual`
- `HodgeReduction.HCGapL4.FrontC60_H8ResidualSourceCarrierSplitPackage.current_interface_with_sourceCarrierSplit_does_not_force_sourceCarrierSplitResidual`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.EVIIH8ResidualCompactDualCarrierExpectedBettiObligations`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.sourceCarrierSplitResidual_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.compactDualCarrierResidual_of_sourceCarrierSplitResidual`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.residual_sourceCarrierSplit_nonempty_iff_compactDualCarrier_nonempty`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.sourceInvariantExpectedBettiResidual_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.matsushimaV56BoundaryData_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC61_H8ResidualCompactDualCarrierPackage.current_interface_with_compactDualCarrier_does_not_force_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.EVIIH8ResidualCartanContainmentExpectedBettiObligations`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.compactDualCarrierResidual_of_cartanContainmentResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_of_h_pow_four_mem`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.compactDual_le_cartan_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_compactDual_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.source_le_cartan_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartan_le_source_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.cartanContainmentResidual_of_compactDualCarrierResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.residual_compactDualCarrier_nonempty_iff_cartanContainment_nonempty`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.matsushimaV56BoundaryData_of_cartanContainmentResidual`
- `HodgeReduction.HCGapL4.FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.current_interface_with_cartanContainments_does_not_force_cartanContainmentResidual`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.EVIIH8ResidualCartanCarrierObligations`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.EVIIH8ResidualExpectedBettiTargetObligation`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.cartanContainmentResidual_of_carrier_and_expectedBetti`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.carrierObligations_of_cartanContainmentResidual`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.expectedBettiTargetObligation_of_cartanContainmentResidual`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.residual_cartanContainment_nonempty_iff_carrier_and_expectedBetti_nonempty`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.matsushimaV56BoundaryData_of_carrier_and_expectedBetti`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.current_interface_with_carrierObligations_does_not_force_expectedBettiTarget`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.R604PrimitiveResidualSnapshot`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.currentR604PrimitiveResidualSnapshot`
- `HodgeReduction.HCGapL4.FrontC63_H8ResidualPrimitiveGapSplit.currentR604PrimitiveResidualSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.EVIIH8ResidualCartanScalarPreimageObligations`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.expectedBettiTarget_of_carrierScalarPreimage`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.cartanContainmentResidual_of_carrierScalarPreimage`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.carrierScalarPreimage_of_cartanContainmentResidual`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.residual_cartanContainment_nonempty_iff_carrierScalarPreimage_nonempty`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.matsushimaV56BoundaryData_of_carrierScalarPreimage`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.current_interface_with_carrierObligations_does_not_force_scalarPreimage`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.R605ScalarPreimageResidualSnapshot`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.currentR605ScalarPreimageResidualSnapshot`
- `HodgeReduction.HCGapL4.FrontC64_H8ResidualScalarPreimagePrimitiveSplit.currentR605ScalarPreimageResidualSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.sourceToCartanPrimitiveTarget`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanToSourcePrimitiveTarget`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.compactDualToCartanPrimitiveTarget`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanToCompactDualPrimitiveTarget`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.scalarPreimagePrimitiveTarget`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.EVIIH8ResidualFivePrimitiveTargets`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.fivePrimitiveTargets_of_carrierScalarPreimage`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.carrierScalarPreimage_of_fivePrimitiveTargets`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.residual_carrierScalarPreimage_nonempty_iff_fivePrimitiveTargets_nonempty`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.cartanContainmentResidual_of_fivePrimitiveTargets`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.matsushimaV56BoundaryData_of_fivePrimitiveTargets`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetNames`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.R606PrimitiveTargetLedgerSnapshot`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetLedgerSnapshot`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetLedgerSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC65_H8ResidualPrimitiveTargetLedger.currentR606PrimitiveTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.sourceCartanEqualityTarget`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.compactDualCartanEqualityTarget`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.EVIIH8ResidualEqualityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.equalityScalarTargets_of_fivePrimitiveTargets`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.fivePrimitiveTargets_of_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.residual_fivePrimitiveTargets_nonempty_iff_equalityScalarTargets_nonempty`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.cartanContainmentResidual_of_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.matsushimaV56BoundaryData_of_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607ProofWorkTargetNames`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.R607EqualityTargetLedgerSnapshot`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607EqualityTargetLedgerSnapshot`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607EqualityTargetLedgerSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC66_H8ResidualEqualityTargetLedger.currentR607ProofWorkTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.scalarPreimageResidual_of_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.equalityScalarTargets_of_scalarPreimageResidual`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.residual_scalarPreimage_nonempty_iff_equalityScalarTargets_nonempty`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.cartanRankOneResidual_of_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.equalityScalarTargets_of_cartanRankOneResidual`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.residual_equalityScalarTargets_nonempty_iff_cartanRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationTargetNames`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.R608RankOneReconciliationSnapshot`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationSnapshot`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC67_H8ResidualRankOneReconciliation.currentR608RankOneReconciliationTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.counterexample_source_eq_cartan`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.counterexample_compactDual_eq_cartan`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.current_interface_with_cartan_equalities_does_not_force_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.current_interface_with_cartan_equalities_does_not_force_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.R609CarrierEqualityObstructionSnapshot`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609CarrierEqualityObstructionSnapshot`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609CarrierEqualityObstructionSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609ObstructionTargetNames`
- `HodgeReduction.HCGapL4.FrontC68_H8ResidualCarrierEqualityObstruction.currentR609ObstructionTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.EVIIH8ResidualProofWorkContract`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.proofWorkContract_of_equalityScalarTargets`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.equalityScalarTargets_of_proofWorkContract`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.residual_equalityScalarTargets_nonempty_iff_proofWorkContract_nonempty`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.cartanContainmentResidual_of_proofWorkContract`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.matsushimaV56BoundaryData_of_proofWorkContract`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.residual_proofWorkContract_nonempty_iff_cartanRankOne_nonempty`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.current_interface_with_cartan_equalities_does_not_force_proofWorkContract`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractTargetNames`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.R610ProofWorkContractSnapshot`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractSnapshot`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC69_H8ResidualProofWorkContract.currentR610ProofWorkContractTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.EVIIH8ResidualSourceInvariantScalarContract`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.source_invariants_eq_H8_of_compactDualCartan`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.source_eq_invariants_of_sourceCartan_compactDualCartan`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.sourceInvariantScalarContract_of_proofWorkContract`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.proofWorkContract_of_sourceInvariantScalarContract`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.residual_proofWorkContract_nonempty_iff_sourceInvariantScalarContract_nonempty`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.matsushimaV56BoundaryData_of_sourceInvariantScalarContract`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractTargetNames`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.R634SourceInvariantScalarContractSnapshot`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractSnapshot`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC70_H8ResidualSourceInvariantScalarContract.currentR634SourceInvariantScalarContractTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantExactImageTarget`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.EVIIH8ResidualSourceInvariantExactImageScalarContract`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantExactImage_of_source_eq_invariants`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.source_eq_invariants_of_sourceInvariantExactImage`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.source_eq_invariants_iff_sourceInvariantExactImage`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.exactImageScalarContract_of_sourceInvariantScalarContract`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.sourceInvariantScalarContract_of_exactImageScalarContract`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.residual_sourceInvariantScalarContract_nonempty_iff_exactImageScalarContract_nonempty`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.matsushimaV56BoundaryData_of_sourceInvariantExactImageScalarContract`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractTargetNames`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.R635ExactImageScalarContractSnapshot`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractSnapshot`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC71_H8ResidualSourceInvariantExactImageContract.currentR635ExactImageScalarContractTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.EVIIH8ResidualExactImageContainmentContract`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.source_eq_H8_of_sourceInvariantExactImage_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.compactDual_eq_H8_of_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.exactImageContainmentContract_of_exactImageScalarContract`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.exactImageScalarContract_of_exactImageContainmentContract`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.residual_exactImageScalar_nonempty_iff_exactImageContainment_nonempty`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.matsushimaV56BoundaryData_of_exactImageContainmentContract`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentTargetNames`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.R636ExactImageContainmentSnapshot`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentSnapshot`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC72_H8ResidualExactImageContainmentContract.currentR636ExactImageContainmentTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.counterexample_sourceInvariantExactImageTarget`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.counterexample_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.current_interface_with_exactImage_sourceH8_does_not_force_target_containment`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.current_interface_with_exactImage_sourceH8_does_not_force_R636_contract`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.R637ExactImageContainmentObstructionSnapshot`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.currentR637ExactImageContainmentObstructionSnapshot`
- `HodgeReduction.HCGapL4.FrontC73_H8ResidualExactImageContainmentObstruction.currentR637ExactImageContainmentObstructionSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSurjectivityTarget`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturatesTargetInvariants`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSurjectivity_iff_trivialModulePart_le_surjectivity_target`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_targetInvariantSurjectivity`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_trivialModulePart_le_surjectivity_target`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImage_eq_targetInvariants_of_saturation`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_of_sourceInvariantImage_eq_targetInvariants`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.sourceInvariantImageSaturation_iff_image_eq_targetInvariants`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.EVIIH8ResidualTargetInvariantSaturationContract`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.targetInvariantSaturationContract_of_exactImageContainmentContract`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.exactImageContainmentContract_of_targetInvariantSaturationContract`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.residual_exactImageContainment_nonempty_iff_targetInvariantSaturation_nonempty`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.exactImageContainmentContract_of_sourceInvariantImageSaturation`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.counterexample_not_targetInvariantSurjectivity`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.counterexample_not_sourceInvariantImageSaturation`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantSaturation`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageSaturation`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationTargetNames`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.R638TargetInvariantSaturationSnapshot`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationSnapshot`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC74_H8ResidualTargetInvariantSaturation.currentR638TargetInvariantSaturationTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImage_finrank_eq_sourceInvariants`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImage_eq_targetInvariants_of_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImageSaturation_of_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantFinrank_of_sourceInvariantImage_eq_targetInvariants`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantFinrank_of_sourceInvariantImageSaturation`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.sourceInvariantImageSaturation_iff_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.EVIIH8ResidualTargetInvariantRankContract`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantSaturationContract_of_targetInvariantRankContract`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.targetInvariantRankContract_of_targetInvariantSaturationContract`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.residual_targetInvariantSaturation_nonempty_iff_targetInvariantRank_nonempty`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.exactImageContainmentContract_of_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.counterexample_not_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankTargetNames`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.R639TargetInvariantRankSnapshot`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankSnapshot`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC75_H8ResidualTargetInvariantRankCriterion.currentR639TargetInvariantRankTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.sourceInvariantFinrank_eq_one_of_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.targetInvariantFinrank_of_sourceH8_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.target_expected_betti8_of_sourceH8_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.sourceInvariantExpectedBettiResidual_of_targetInvariantRankContract`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.targetInvariantRankContract_of_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.residual_targetInvariantRank_nonempty_iff_sourceInvariantExpectedBetti_nonempty`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.exactImageContainmentContract_of_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantExpectedBettiResidual`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationTargetNames`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.R640RankReconciliationSnapshot`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationSnapshot`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC76_H8ResidualRankCriterionReconciliation.currentR640RankReconciliationTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.map_mkQ_eq_bot_iff_le`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.sourceInvariantImage`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageSaturation`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSurjectivity`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_surjectivity_target`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotient_eq_bot_iff_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.EVIIH8ResidualTargetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.exactImageContainmentContract_of_targetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.targetInvariantExcessQuotientContract_of_targetInvariantSaturationContract`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantRank_nonempty`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.counterexample_not_targetInvariantExcessQuotient_eq_bot`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientTargetNames`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.R641TargetInvariantExcessQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC77_H8ResidualTargetInvariantExcessQuotient.currentR641TargetInvariantExcessQuotientTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_map_eq_sourceInvariantImage`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_sourceInvariantImageSaturation`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_eq_bot_iff_sourceInvariantImageInsideTarget_eq_top`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_finrank_eq_sourceInvariants`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_internalFinrank`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.sourceInvariantImageInsideTarget_eq_top_iff_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap_range`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantQuotientMap_ker`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_finrank_add_sourceInvariantImageInsideTarget_finrank`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.targetInvariantExcessQuotient_eq_bot_iff_internalFinrank`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.counterexample_not_sourceInvariantImageInsideTarget_eq_top`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.current_interface_with_exactImage_sourceH8_does_not_force_sourceInvariantImageInsideTarget`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientTargetNames`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.R642TargetInvariantInternalQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC78_H8ResidualTargetInvariantInternalQuotient.currentR642TargetInvariantInternalQuotientTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_finrank_add_sourceInvariants_finrank`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_eq_bot_iff_excessFinrank_zero`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessFinrank_zero_iff_targetInvariantFinrank`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessQuotient_finrank_add_expected_betti8_of_sourceH8`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.targetInvariantExcessFinrank_zero_iff_target_expected_betti8`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.current_interface_with_exactImage_sourceH8_finiteTarget_does_not_force_excessFinrankZero`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankTargetNames`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.R643TargetInvariantExcessFinrankSnapshot`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankSnapshot`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC79_H8ResidualTargetInvariantExcessFinrank.currentR643TargetInvariantExcessFinrankTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessFinrank_zero_of_sourceH8_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetExpectedBettiUpperBound_of_targetInvariantExcessFinrank_zero`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessFinrank_zero_iff_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessQuotient_eq_bot_iff_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.EVIIH8ResidualTargetInvariantUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantExcessQuotientContract_of_targetInvariantUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.residual_targetInvariantUpperBound_nonempty_iff_targetInvariantExcessQuotient_nonempty`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.current_interface_with_exactImage_sourceH8_does_not_force_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundTargetNames`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.R644TargetInvariantUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC80_H8ResidualTargetInvariantUpperBound.currentR644TargetInvariantUpperBoundTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetExpectedBettiUpperBound_iff_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantExcessFinrank_zero_iff_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.EVIIH8ResidualTrivialModuleUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.targetInvariantUpperBoundContract_of_trivialModuleUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.trivialModuleUpperBoundContract_of_targetInvariantUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.residual_trivialModuleUpperBound_nonempty_iff_targetInvariantUpperBound_nonempty`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.current_interface_with_exactImage_sourceH8_does_not_force_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundTargetNames`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.R645TrivialModuleUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC81_H8ResidualTrivialModuleUpperBound.currentR645TrivialModuleUpperBoundTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.atlasDeg8Classification_at_degree8`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.atlasDeg8Classification_and_currentInterface_do_not_force_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_le_cartanImage`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_le_sourceInvariantImage`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModulePart_upper_bound_of_exactImage_sourceH8_targetContainment`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.EVIIH8ResidualCartanImageUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.trivialModuleUpperBoundContract_of_cartanImageUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionTargetNames`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.R646AtlasMultiplicityCriterionSnapshot`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionSnapshot`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC82_H8ResidualAtlasMultiplicityCriterion.currentR646AtlasMultiplicityCriterionTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.trivialModulePart_le_cartanImage_iff_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.trivialModulePart_upper_bound_of_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.EVIIH8ResidualCartanScalarUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.cartanImageUpperBoundContract_of_cartanScalarUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.cartanScalarUpperBoundContract_of_cartanImageUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.residual_cartanScalar_nonempty_iff_cartanImage_nonempty`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.current_interface_with_atlas_does_not_force_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarTargetNames`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.R647CartanScalarSnapshot`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarSnapshot`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC83_H8ResidualCartanImageScalarPreimage.currentR647CartanScalarTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.sourceInvariantImageSaturation_iff_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.targetInvariantExcessQuotient_eq_bot_iff_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.targetInvariantExcessQuotientContract_of_cartanScalarUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.cartanScalarUpperBoundContract_of_targetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.residual_cartanScalar_nonempty_iff_targetInvariantExcessQuotient_nonempty`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_quotient_or_cartan_scalar`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientTargetNames`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.R648ScalarQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC84_H8ResidualScalarPreimageQuotientEquivalence.currentR648ScalarQuotientTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.trivialModulePart_upper_bound_of_sourceH8_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetExpectedBettiUpperBound_of_sourceH8_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.trivialModuleUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetInvariantUpperBoundContract_of_targetInvariantExcessQuotientContract_noFinite`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.targetInvariantExcessQuotient_nonempty_to_targetInvariantUpperBound_nonempty_noFinite`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundTargetNames`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.R649NoFiniteQuotientUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC85_H8ResidualQuotientUpperBoundNoFinite.currentR649NoFiniteQuotientUpperBoundTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantSourcePreimageTarget`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.sourceInvariantImageSaturation_iff_targetInvariantSourcePreimage`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantExcessQuotient_eq_bot_iff_targetInvariantSourcePreimage`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.EVIIH8ResidualTargetInvariantPreimageContract`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantPreimageContract_of_targetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantExcessQuotientContract_of_targetInvariantPreimageContract`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantPreimage_nonempty`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.targetInvariantSourcePreimage_iff_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.current_interface_with_exactImage_sourceH8_does_not_force_targetInvariantPreimage`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageTargetNames`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.R650TargetInvariantPreimageSnapshot`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageSnapshot`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC86_H8ResidualTargetInvariantPreimageCriterion.currentR650TargetInvariantPreimageTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap_range_eq_sourceInvariantImageInsideTarget`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.sourceToTargetInvariantMap_range_eq_top_iff_targetInvariantSourcePreimage`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_range_eq_top`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.EVIIH8ResidualInvariantMapSurjectivityContract`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.invariantMapSurjectivityContract_of_targetInvariantPreimageContract`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.targetInvariantPreimageContract_of_invariantMapSurjectivityContract`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.residual_targetInvariantPreimage_nonempty_iff_invariantMapSurjectivity_nonempty`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.residual_targetInvariantExcessQuotient_nonempty_iff_invariantMapSurjectivity_nonempty`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.current_interface_with_exactImage_sourceH8_does_not_force_invariantMapSurjectivity`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivityTargetNames`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.R651InvariantMapSurjectivitySnapshot`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivitySnapshot`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivitySnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC87_H8ResidualInvariantMapSurjectivity.currentR651InvariantMapSurjectivityTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.sourceToTargetInvariantMap_injective`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.sourceToTargetInvariantMap_surjective_iff_range_eq_top`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_surjective`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_bijective`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.EVIIH8ResidualInvariantMapBijectivityContract`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.invariantMapBijectivityContract_of_invariantMapSurjectivityContract`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.invariantMapSurjectivityContract_of_invariantMapBijectivityContract`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.residual_invariantMapSurjectivity_nonempty_iff_invariantMapBijectivity_nonempty`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.current_interface_with_exactImage_sourceH8_does_not_force_invariantMapBijectivity`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivityTargetNames`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.R652InvariantMapBijectivitySnapshot`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivitySnapshot`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivitySnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC88_H8ResidualInvariantMapBijectivity.currentR652InvariantMapBijectivityTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.sourceToTargetInvariantMap_range_eq_top_of_linearRightInverse`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.targetInvariantExcessQuotient_eq_bot_of_sourceToTargetInvariantMap_linearRightInverse`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.sourceToTargetInvariantMap_bijective_of_linearRightInverse`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.EVIIH8ResidualInvariantMapRightInverseContract`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.invariantMapBijectivityContract_of_invariantMapRightInverseContract`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.residual_invariantMapRightInverse_nonempty_to_invariantMapBijectivity_nonempty`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.current_interface_with_exactImage_sourceH8_does_not_force_linearRightInverse`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.current_interface_does_not_force_rightInverseContract_nonempty`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseTargetNames`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.R653InvariantMapRightInverseSnapshot`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseSnapshot`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC89_H8ResidualInvariantMapRightInverse.currentR653InvariantMapRightInverseTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantLinearEquivOfBijective`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantMapRightInverseOfBijective`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.sourceToTargetInvariantMap_comp_rightInverseOfBijective`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.targetInvariantExcessQuotient_eq_bot_iff_sourceToTargetInvariantMap_linearRightInverse`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.invariantMapRightInverseContract_of_invariantMapBijectivityContract`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.residual_invariantMapBijectivity_nonempty_to_invariantMapRightInverse_nonempty`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.residual_invariantMapRightInverse_nonempty_iff_invariantMapBijectivity_nonempty`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_equivTarget`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceTargetNames`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.R654RightInverseEquivalenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC90_H8ResidualInvariantMapRightInverseEquivalence.currentR654RightInverseEquivalenceTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.sourceToTargetInvariantMap_linearRightInverse_iff_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.cartanScalarUpperBoundContract_of_invariantMapRightInverseContract`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.invariantMapRightInverseContract_of_cartanScalarUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.residual_invariantMapRightInverse_nonempty_iff_cartanScalar_nonempty`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.sourceToTargetInvariantMap_bijective_iff_cartan_scalar_preimage`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.current_interface_with_exactImage_sourceH8_does_not_force_rightInverse_or_scalar`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarTargetNames`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.R655RightInverseScalarSnapshot`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarSnapshot`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.currentR655RightInverseScalarTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.matsushima_h_pow_four_image_ne_zero`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.matsushima_h_pow_four_mem_cartan_image`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_image_eq_span_matsushima_h_pow_four`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_image_contains_nonzero_generator`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartan_scalar_preimage_iff_trivialModulePart_le_matsushima_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.sourceToTargetInvariantMap_bijective_iff_trivialModulePart_le_matsushima_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.EVIIH8ResidualCartanLineContainmentContract`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartanScalarUpperBoundContract_of_cartanLineContainmentContract`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.cartanLineContainmentContract_of_cartanScalarUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.residual_cartanLine_nonempty_iff_cartanScalar_nonempty`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.current_interface_with_exactImage_sourceH8_does_not_force_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.R656CartanGeneratorLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC92_H8ResidualCartanGeneratorLineCriterion.currentR656CartanGeneratorLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.matsushima_h_pow_four_mem_trivialModulePart_of_sourceH8`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.cartan_scalar_preimage_of_sourceH8_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.sourceToTargetInvariantMap_bijective_of_sourceH8_trivialModulePartUpperBound`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.cartanLineContainmentContract_of_trivialModuleUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.residual_trivialModuleUpperBound_nonempty_to_cartanLine_nonempty`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicityTargetNames`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.R657LineContainmentFromMultiplicitySnapshot`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicitySnapshot`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicitySnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC93_H8ResidualLineContainmentFromMultiplicity.currentR657LineContainmentFromMultiplicityTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.targetInvariantExcessQuotient_eq_bot_iff_trivialModulePart_le_matsushima_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.trivialModulePart_le_matsushima_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.sourceToTargetInvariantMap_bijective_of_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.cartanLineContainmentContract_of_targetInvariantExcessQuotientContract_noFinite`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.targetInvariantExcessQuotientContract_of_cartanLineContainmentContract`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.residual_targetInvariantExcessQuotient_nonempty_iff_cartanLine_nonempty_noFinite`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.invariantMapBijectivityContract_of_targetInvariantExcessQuotientContract_noFinite`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.R658QuotientLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC94_H8ResidualQuotientLineContainmentEquivalence.currentR658QuotientLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.source_invariants_le_H8_of_trivialModulePart_le_matsushima_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.source_invariants_eq_H8_of_h_pow_four_mem_source_and_line`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.EVIIH8ResidualGeneratorMembershipLineContract`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.cartanLineContainmentContract_of_generatorMembershipLineContract`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.targetInvariantExcessQuotientContract_of_generatorMembershipLineContract`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.residual_generatorMembershipLine_nonempty_to_cartanLine_nonempty`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.residual_generatorMembershipLine_nonempty_to_targetInvariantExcessQuotient_nonempty`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.R659SourceNoExtraFromLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC95_H8ResidualSourceNoExtraFromLineContainment.currentR659SourceNoExtraFromLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.h_pow_four_mem_source_invariants_of_h_pow_four_mem_compactDual`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.source_invariants_eq_H8_of_h_pow_four_mem_compactDual_and_line`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.EVIIH8ResidualCompactDualGeneratorLineContract`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.generatorMembershipLineContract_of_compactDualGeneratorLineContract`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.cartanLineContainmentContract_of_compactDualGeneratorLineContract`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.targetInvariantExcessQuotientContract_of_compactDualGeneratorLineContract`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.residual_compactDualGeneratorLine_nonempty_to_targetInvariantExcessQuotient_nonempty`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.R660CompactDualGeneratorLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC96_H8ResidualSourceGeneratorFromCompactDual.currentR660CompactDualGeneratorLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.cartanH8_le_compactDual_iff_h_pow_four_mem_compactDual`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.EVIIH8ResidualCartanToCompactDualLineContract`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.compactDualGeneratorLineContract_of_cartanToCompactDualLineContract`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.cartanToCompactDualLineContract_of_compactDualGeneratorLineContract`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.residual_compactDualGeneratorLine_nonempty_iff_cartanToCompactDualLine_nonempty`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.targetInvariantExcessQuotientContract_of_cartanToCompactDualLineContract`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.source_invariants_eq_H8_of_cartanH8_le_compactDual_and_line`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.R661CartanToCompactDualLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC97_H8ResidualCartanToCompactDualLine.currentR661CartanToCompactDualLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_cartanH8_le_compactDual`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_trivialModulePart_le_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.counterexample_not_sourceInvariantExactImageTarget`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.current_interface_with_cartanContainment_line_does_not_force_exactImage`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.R662ExactImageIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.currentR662ExactImageIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC98_H8ResidualExactImageIndependence.currentR662ExactImageIndependenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.counterexample_cartanH8_le_compactDual`
- `HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.current_interface_with_exactImage_cartanContainment_does_not_force_target_line`
- `HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.R663TargetLineIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.currentR663TargetLineIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.currentR663TargetLineIndependenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC99_H8ResidualTargetLineIndependence.R663_substantiveTheoremCount_eq`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_sourceInvariantExactImageTarget`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_trivialModulePart_le_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.counterexample_not_cartanH8_le_compactDual`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.current_interface_with_exactImage_line_does_not_force_cartanContainment`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.R664CartanContainmentIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.currentR664CartanContainmentIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC100_H8ResidualCartanContainmentIndependence.currentR664CartanContainmentIndependenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.target_invariants_le_h_pow_four_line_iff_trivialModulePart_le_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.EVIIH8ResidualTargetInvariantLineContract`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.targetInvariantLineContract_of_cartanToCompactDualLineContract`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.cartanToCompactDualLineContract_of_targetInvariantLineContract`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.residual_cartanToCompactDualLine_nonempty_iff_targetInvariantLine_nonempty`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.targetInvariantExcessQuotientContract_of_targetInvariantLineContract`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.source_invariants_eq_H8_of_cartanH8_le_compactDual_and_targetInvariantLine`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.R665TargetInvariantLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC101_H8ResidualTargetInvariantLineBridge.currentR665TargetInvariantLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.cartanH8_le_compactDual_of_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.targetInvariantExcessQuotient_eq_bot_iff_target_invariants_le_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.target_invariants_le_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.targetInvariantLineContract_of_targetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.residual_targetInvariantLine_nonempty_iff_targetInvariantExcessQuotient_nonempty`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.invariantMapBijectivityContract_of_targetInvariantLineContract`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.currentR666TargetInvariantQuotientTargetNames`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.R666TargetInvariantQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.currentR666TargetInvariantQuotientSnapshot`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.currentR666TargetInvariantQuotientSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC102_H8ResidualTargetInvariantQuotientEquivalence.currentR666TargetInvariantQuotientTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.counterexample_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.counterexample_targetInvariantExcessQuotient_eq_bot`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.current_interface_with_sourceH8_quotient_does_not_force_exactImage`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.R667ExactImageQuotientIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.currentR667ExactImageQuotientIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.currentR667ExactImageQuotientIndependenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC103_H8ResidualExactImageQuotientIndependence.R667_substantiveTheoremCount_eq`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.counterexample_targetInvariantExcessQuotient_eq_bot`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.counterexample_not_source_invariants_eq_H8`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.current_interface_with_exactImage_quotient_does_not_force_sourceH8`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.R668SourceH8QuotientIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.currentR668SourceH8QuotientIndependenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.currentR668SourceH8QuotientIndependenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC104_H8ResidualSourceH8QuotientIndependence.R668_substantiveTheoremCount_eq`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.target_invariants_eq_h_pow_four_line_iff_target_invariants_le_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.target_invariants_eq_h_pow_four_line_of_sourceH8_targetInvariantExcessQuotient`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.EVIIH8ResidualTargetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.targetInvariantLineEqualityContract_of_targetInvariantExcessQuotientContract`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.targetInvariantExcessQuotientContract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.residual_targetInvariantExcessQuotient_nonempty_iff_targetInvariantLineEquality_nonempty`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.targetInvariantLineContract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.currentR669TargetInvariantLineEqualityTargetNames`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.R669TargetInvariantLineEqualitySnapshot`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.currentR669TargetInvariantLineEqualitySnapshot`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.currentR669TargetInvariantLineEqualitySnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC105_H8ResidualTargetInvariantLineEquality.currentR669TargetInvariantLineEqualityTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.target_invariants_eq_h_pow_four_line_iff_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.target_invariants_eq_h_pow_four_line_of_sourceH8_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.targetInvariantLineEqualityContract_of_targetInvariantUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.targetInvariantUpperBoundContract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.residual_targetInvariantUpperBound_nonempty_iff_targetInvariantLineEquality_nonempty`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.currentR670LineEqualityUpperBoundTargetNames`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.R670LineEqualityUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.currentR670LineEqualityUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.currentR670LineEqualityUpperBoundSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.currentR670LineEqualityUpperBoundTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC106_H8ResidualLineEqualityUpperBoundCriterion.R670_substantiveTheoremCount`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.target_invariants_finiteDimensional_of_eq_h_pow_four_line`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.target_invariants_eq_h_pow_four_line_iff_finite_targetExpectedBettiUpperBound`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.EVIIH8ResidualFiniteUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.finiteUpperBoundContract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.targetInvariantLineEqualityContract_of_finiteUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.residual_targetInvariantLineEquality_nonempty_iff_finiteUpperBound_nonempty`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.targetInvariantUpperBoundContract_of_finiteUpperBoundContract`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.currentR671FiniteUpperBoundTargetNames`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.R671FiniteUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.currentR671FiniteUpperBoundSnapshot`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.currentR671FiniteUpperBoundSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.currentR671FiniteUpperBoundTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC107_H8ResidualLineEqualityFiniteUpperBound.R671_substantiveTheoremCount`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.sourceInvariantExactImageTarget_of_matsushimaV56BoundaryData`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.target_invariants_eq_h_pow_four_line_of_boundaryData_sourceH8`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.EVIIH8ResidualBoundaryDataSourceH8Contract`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.targetInvariantLineEqualityContract_of_boundaryDataSourceH8Contract`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.finiteUpperBoundContract_of_boundaryDataSourceH8Contract`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.residual_boundaryDataSourceH8_nonempty_to_finiteUpperBound_nonempty`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.currentR672BoundaryDataLineEqualityTargetNames`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.R672BoundaryDataLineEqualitySnapshot`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.currentR672BoundaryDataLineEqualitySnapshot`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.currentR672BoundaryDataLineEqualitySnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.currentR672BoundaryDataLineEqualityTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC108_H8ResidualBoundaryDataLineEquality.R672_substantiveTheoremCount`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.matsushimaV56BoundaryData_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.boundaryDataSourceH8Contract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.residual_boundaryDataSourceH8_nonempty_iff_targetInvariantLineEquality_nonempty`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.residual_boundaryDataSourceH8_nonempty_iff_finiteUpperBound_nonempty`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.finiteUpperBoundContract_of_targetInvariantLineEqualityContract_viaBoundaryData`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.currentR673BoundaryDataEquivalenceTargetNames`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.R673BoundaryDataEquivalenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.currentR673BoundaryDataEquivalenceSnapshot`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.currentR673BoundaryDataEquivalenceSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.currentR673BoundaryDataEquivalenceTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC109_H8ResidualBoundaryDataEquivalence.R673_substantiveTheoremCount`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.source_invariants_eq_H8_of_boundaryData_targetLine`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.source_H8_iff_targetLine_of_boundaryData`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.EVIIH8ResidualBoundaryDataTargetLineContract`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.targetInvariantLineEqualityContract_of_boundaryDataTargetLineContract`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.boundaryDataTargetLineContract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.residual_boundaryDataTargetLine_nonempty_iff_targetInvariantLineEquality_nonempty`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.residual_boundaryDataTargetLine_nonempty_iff_boundaryDataSourceH8_nonempty`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.currentR674BoundaryDataTargetLineTargetNames`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.R674BoundaryDataTargetLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.currentR674BoundaryDataTargetLineSnapshot`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.currentR674BoundaryDataTargetLineSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.currentR674BoundaryDataTargetLineTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC110_H8ResidualBoundaryDataTargetLineEquivalence.R674_substantiveTheoremCount`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.compactDual_eq_H8_iff_targetLine_of_boundaryData`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.EVIIH8ResidualBoundaryDataCompactDualH8Contract`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.boundaryDataTargetLineContract_of_boundaryDataCompactDualH8Contract`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.boundaryDataCompactDualH8Contract_of_boundaryDataTargetLineContract`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataTargetLine_nonempty`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.residual_boundaryDataCompactDualH8_nonempty_iff_targetInvariantLineEquality_nonempty`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.residual_boundaryDataCompactDualH8_nonempty_iff_boundaryDataSourceH8_nonempty`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.currentR675BoundaryDataCompactDualTargetNames`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.R675BoundaryDataCompactDualSnapshot`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.currentR675BoundaryDataCompactDualSnapshot`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.currentR675BoundaryDataCompactDualSnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.currentR675BoundaryDataCompactDualTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC111_H8ResidualBoundaryDataCompactDualEquivalence.R675_substantiveTheoremCount`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.boundaryDataCompactDualH8Contract_of_exactImageContainmentContract`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.targetInvariantLineEqualityContract_of_exactImageContainmentContract`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.exactImageContainmentContract_of_targetInvariantLineEqualityContract`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.residual_exactImageContainment_nonempty_iff_targetInvariantLineEquality_nonempty`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.residual_exactImageContainment_nonempty_iff_boundaryDataCompactDualH8_nonempty`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.currentR676ExactImageContainmentBoundaryTargetNames`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.R676ExactImageContainmentBoundarySnapshot`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.currentR676ExactImageContainmentBoundarySnapshot`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.currentR676ExactImageContainmentBoundarySnapshot_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.currentR676ExactImageContainmentBoundaryTargetNames_eq_texStatus`
- `HodgeReduction.HCGapL4.FrontC112_H8ResidualExactImageContainmentBoundaryEquivalence.R676_substantiveTheoremCount`

Taxonomy files:
- `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean` -- registered
- `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean` -- registered
- `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC7_E7EVIIHodgeDiamondInstance.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC8_V56MTBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC9_EVIIHodgeNumberComputation.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC10_V56CohomologyIdentification.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC11_ShimuraBettiComputation.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC12_V56InfrastructureProfileBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC13_MatsushimaV56BoundaryBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC14_CartanCompactDualSourceBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC15_MatsushimaBoundaryRankCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC16_MatsushimaTargetContainmentFromSource.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC17_MatsushimaTargetRankFromSource.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC18_MatsushimaSourceCompactDualRankBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC19_MatsushimaSourceCompactDualObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC20_MatsushimaCompactDualExactImageCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC21_MatsushimaExactImageRankBoundary.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC22_MatsushimaExactImageSourceEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC23_MatsushimaCompactDualRankOne.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC24_CartanImageTrivialRank.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC25_CartanLineBoundaryExactness.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC26_CartanLineExactnessObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC27_CartanImageScalarPreimage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC28_ScalarPreimageObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC29_CartanImageFromRankOne.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC30_SourceInvariantsH8TargetRank.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC31_TargetRankFromExpectedBetti.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC32_SourceInvariantsH8CarrierCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC33_CompactDualH8CarrierCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC34_CartanContainmentsForCompactDual.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC35_SourceCartanContainments.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC36_TargetBettiObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC37_TargetRankHodgeSumBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC38_TargetHodgeSumFromCartanImage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC39_TargetHodgeSumFromScalarPreimage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC40_TargetRankScalarPreimageEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC41_CartanContainmentCarrierEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC42_H8CarrierEqualityRoute.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC43_H8BoundaryEqualityRoute.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC44_BoundaryDataH8Equivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC45_H8BoundaryDataObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC46_TargetSurjectivityContainmentCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC47_TargetContainmentScalarPreimageCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC48_H8BoundaryRankOneCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC49_H8BoundaryExpectedBettiCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC50_H8ResidualObligationPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC51_H8ResidualScalarPreimagePackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC52_H8ResidualBoundaryPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC53_H8ResidualBoundaryDataPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC54_H8ResidualExactImagePackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC55_H8ResidualExactImageRankOnePackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC56_H8ResidualCartanRankOnePackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC57_H8ResidualSourceInvariantTargetRankPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC58_H8ResidualSourceInvariantNormalization.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC59_H8ResidualExpectedBettiPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC60_H8ResidualSourceCarrierSplitPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC61_H8ResidualCompactDualCarrierPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC62_H8ResidualCartanContainmentExpectedBettiPackage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC63_H8ResidualPrimitiveGapSplit.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC64_H8ResidualScalarPreimagePrimitiveSplit.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC65_H8ResidualPrimitiveTargetLedger.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC66_H8ResidualEqualityTargetLedger.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC67_H8ResidualRankOneReconciliation.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC68_H8ResidualCarrierEqualityObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC69_H8ResidualProofWorkContract.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC70_H8ResidualSourceInvariantScalarContract.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC71_H8ResidualSourceInvariantExactImageContract.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC72_H8ResidualExactImageContainmentContract.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC73_H8ResidualExactImageContainmentObstruction.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC74_H8ResidualTargetInvariantSaturation.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC75_H8ResidualTargetInvariantRankCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC76_H8ResidualRankCriterionReconciliation.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC77_H8ResidualTargetInvariantExcessQuotient.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC78_H8ResidualTargetInvariantInternalQuotient.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC79_H8ResidualTargetInvariantExcessFinrank.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC80_H8ResidualTargetInvariantUpperBound.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC81_H8ResidualTrivialModuleUpperBound.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC82_H8ResidualAtlasMultiplicityCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC83_H8ResidualCartanImageScalarPreimage.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC84_H8ResidualScalarPreimageQuotientEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC85_H8ResidualQuotientUpperBoundNoFinite.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC86_H8ResidualTargetInvariantPreimageCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC87_H8ResidualInvariantMapSurjectivity.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC88_H8ResidualInvariantMapBijectivity.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC89_H8ResidualInvariantMapRightInverse.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC90_H8ResidualInvariantMapRightInverseEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC91_H8ResidualRightInverseScalarPreimageEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC92_H8ResidualCartanGeneratorLineCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC93_H8ResidualLineContainmentFromMultiplicity.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC94_H8ResidualQuotientLineContainmentEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC95_H8ResidualSourceNoExtraFromLineContainment.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC96_H8ResidualSourceGeneratorFromCompactDual.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC97_H8ResidualCartanToCompactDualLine.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC98_H8ResidualExactImageIndependence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC99_H8ResidualTargetLineIndependence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC100_H8ResidualCartanContainmentIndependence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC101_H8ResidualTargetInvariantLineBridge.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC102_H8ResidualTargetInvariantQuotientEquivalence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC103_H8ResidualExactImageQuotientIndependence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC104_H8ResidualSourceH8QuotientIndependence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC105_H8ResidualTargetInvariantLineEquality.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC106_H8ResidualLineEqualityUpperBoundCriterion.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC107_H8ResidualLineEqualityFiniteUpperBound.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC108_H8ResidualBoundaryDataLineEquality.lean` -- registered
- `HodgeReduction/HCGapL4/FrontE6_FeedR405ConditionalTransfer.lean` -- on-disk-unloaded
- `HodgeReduction/HCGapL4/FrontD6_Deligne1982MinimalFragment.lean` -- on-disk-unloaded
- `HodgeReduction/HCGapL4/R476_MultiFrontWave6Audit.lean` -- on-disk-unloaded

### `chain:concrete-evii-toy` -- Concrete EVII sanity-check chain

`HC_for_Concrete_EVII` specialises the abstract closure `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` to a concrete `A_EVII := Polynomial 鈩歚 toy carrier.  Cone is `{propext, Classical.choice, Quot.sound}` (no project axioms) but the carrier is explicitly toy; per R201 mandate it is EXCLUDED from real-HC closure accounting.

Taxonomy files:
- `HodgeReduction/Concrete.lean` -- on-disk-unloaded

### `chain:historical-cone-audits` -- Historical per-round cone audit drivers (R217 -- R476)

85 per-round `#print axioms` / `#check` driver scripts produced at the end of each attack round.  Each script is a standalone audit consuming a fixed subset of the active chain at its timestamp; none are imported by `HodgeReduction.lean`.  Moved out of the project root into `HodgeReduction/ConeAudits/` and registered as `infraFiles` so the chainAudit classifier records them as infra rather than orphan.

Taxonomy files:
- `HodgeReduction/ConeAudits/R217_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` -- on-disk-unloaded

