# HodgeReduction -- route index

Decision-first index for the next research round.  Treat this as the base map: the proof spine is the endpoint closure, route labels are generated automatically from the Lean import graph, file names, source text, and audit route taxonomy.  The goal is to show which proof routes are active, blocked, closed, or orphaned before a new agent starts editing.

* endpoints: **8**  *  open mathematical cuts: **24**  *  route taxonomy chains: **6**  *  route taxonomy gaps: **8**  *  debt components: **28**  *  branch heads: **73**

## Audit Truth Contract

This file is generated.  Future agents should update Lean files, audit rules, or the route taxonomy config, then regenerate the reports.  Do not maintain a separate hand-written route ledger.

## Next Agent Brief

Research attack target:
- Primary proof gap: `gap:G-main-hc` -- The `hodgeConjectureReal_canonical` endpoint is a kernel-pure composition once the canonical target variety and its two E7-scope facts are accepted.  R542 derives the full `canonicalMTPackageAt` from the generic R517/R532 MT-witness route; R545 splits the chosen-witness package into a codim-one first target plus the remaining non-codim-one lift; R549 opens that codim-one target into Hodge-morphism, algebraic-map, commuting-square, and Hodge-surjectivity component cuts; R550 routes the separately audited codim-one HC slice directly through the classical Lefschetz (1,1) cut; R551 splits the full canonical proof by codimension so the `p = 1` branch no longer consumes the E7 -> CM package and the `p ≠ 1` branch consumes only the non-codim-one MT lift.  R551 also states the endpoint directly on canonical cohomology/algebraic-class data so the theorem type itself does not pull the legacy all-codim package.  Full HC is NOT unconditional.
- Route owner(s): `chain:main-hc-axiom-relative`
- Current constructive attack route: `chain:hcgap-l4-multifront-active`.  Use it to replace the primary cut; do not route around the configured gap ledger.
- Success criterion: A successful follow-up closes one of the remaining target cuts: construct `canonicalTargetVariety`, prove its E7 factor, prove it lies in known E7 scope, or reduce the generic R517/R532 MT-witness cuts by Chow / cycle-class data.

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
| 1 | `gap:G-hcgap-l4-multifront` (active-open) | 308 | `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond`, `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond`, `HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge`, +65 more | `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean`, +52 more |

Priority uses the project-configured `gapPriority` order first; remaining active subgaps are sorted mechanically by labelled debt file count.  It is a triage order, not a mathematical proof of easiest-first.

## New Agent Attack Cards

Readiness verdict: **actionable**.  The main cut and replacement route are clear.  Start from the priority gap cards below.

Current replacement plan:
- FrontC: R560/R567/R569 block abstract-interface closure of the compact-dual/Cartan/scalar-surjectivity targets.  R570 proves compactDual = Cartan plus `finrank trivialModulePart = 1` forces exact Cartan image.  R571 rewrites that into primitive EVII Matsushima targets already named by the interfaces: prove `surjectivity_source = MatsushimaData.source_invariants`, prove `MatsushimaData.source_invariants = CompactDualData.H8`, and prove `finrank MatsushimaData.target_invariants = 1`.  R572 routes the last target through the already-certified expected Betti slot, so the concrete target is `finrank MatsushimaData.target_invariants = shimuraEVIIExpectedBetti 8`.  R573 splits the source-invariants/H8 target into `source_invariants <= H8` plus `h^4` membership; R574 rewrites those through compactDual; R575 rewrites the carrier side again as `compactDual <= CartanH8` and `CartanH8 <= compactDual`; R576 rewrites source equality as `surjectivity_source <= CartanH8` and `CartanH8 <= surjectivity_source`; R577 blocks deriving target expected-Betti from those four containments alone; R578 routes target expected-Betti through `finrank target_invariants = hodgeSumAtDegree e7EVIICompactDualHodgeDiamond 8`; R579 derives that target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from the compactDual/Cartan containment pair plus scalar preimages; R581 proves scalar-preimage and target Hodge-sum rank are equivalent once the four carrier directions are fixed; R582 rewrites those four Cartan directions as source/compactDual H8 no-extra plus `h^4` generator-membership splits; R583 collapses each split to `surjectivity_source = H8` and `compactDual = H8`; R584 translates the target-side theorem to the exact boundary equality `surjectivity_target = trivialModulePart`; R585 proves this is equivalent to `MatsushimaV56BoundaryData` once `source = H8` and `compactDual = H8` are fixed; R586 blocks deriving that boundary data from the two H8 carrier equalities alone; R587 shows the remaining target boundary is exactly `trivialModulePart <= surjectivity_target` because the opposite containment follows from the H8 source/compactDual equalities, and the R586 countermodel still refutes deriving this reverse containment abstractly; R588 rewrites that reverse containment as the scalar-preimage theorem `forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta`, requiring only `source = H8`.  The live concrete targets are now the two H8 carrier equalities plus the genuine scalar-preimage/surjectivity theorem.  Feed R553/R554/R555/R556/R557/R558/R559/R561/R562/R563/R564/R565/R566/R568/R570/R571/R572/R573/R574/R575/R576/R577/R578/R579/R580/R581/R582/R583/R584/R585/R586/R587/R588 together.
- FrontB: replace the abstract connectedness pipeline with the genuine Baily--Borel connectedness theorem for arithmetic quotients.
- FrontD: deliver the E_7 -> CM Chow correspondence at codim 1 first, then lift to all p; this would discharge G-l4-mt-correspondence for the canonical case.
- Never re-bundle a closed front into a stronger hypothesis; chainAudit treats `def : Prop` placeholders and conjunction shells as hard failures.
- Final success criterion: A successful follow-up closes one of the remaining target cuts: construct `canonicalTargetVariety`, prove its E7 factor, prove it lies in known E7 scope, or reduce the generic R517/R532 MT-witness cuts by Chow / cycle-class data.

### Priority 1: `gap:G-hcgap-l4-multifront` -- HCGapL4 multi-front Layer-4 attack waves (R420 -- R588)

Active exploratory attack waves on the L4 / cohomology-profile / connectedness pipeline: FrontA (Deligne H0 sheaf realization), FrontB (Baily--Borel connectedness), FrontC (E_7 low-degree Hodge numbers + Hodge polynomial algebra + all-degree rank adapter + EVII/V56/Shimura expected Betti profile), FrontD (E_7 -> CM Chow correspondence + Deligne 1982 minimal fragment), FrontE (real-carrier profile matching + R405 conditional transfer feed).  Audits R451 / R456 / R460 / R465 / R470 / R476 are wave-level summaries.  R552 certifies the expected Shimura Betti profile degree-by-degree from EVII compact-dual Hodge sums plus the isolated V56 degree-3 contribution; R553 ties that finite V56 contribution to the actual `PureHodgeStructure V56 3` infrastructure; R554 combines the Matsushima, Eisenstein, and cuspidal trivial-module infrastructure into an honest boundary theorem; R555 proves the Cartan compact-dual source bridge and reduces the R554 source equality to `surjectivity_source = source_invariants`; R556 turns both source/target boundary equalities into finite-dimensional containment plus finrank obligations, routing the target through the cuspidal trivial-module part; R557 proves the target containment follows from source containment by Matsushima equivariance and the surjectivity image equation; R558 proves target finrank is transported from source finrank by `j_q` injectivity and the Matsushima image equation; R559 rewrites the remaining source obligations through the compact-dual/Cartan source subspace; R560 gives a Lean countermodel showing those compact-dual obligations are not consequences of the current abstract interface; R561 proves that compact-dual exact image plus target-invariant exactness is enough to recover the R554/R559 boundary data; R562 proves target exactness follows from compact-dual exact image plus the compact-dual-to-trivial rank bridge; R563 proves compact-dual exact image is equivalent to `surjectivity_source = compactDual`; R564 proves the actual compact-dual `H8` carrier has rank one and reduces the rank bridge to `compactDual = H8` plus rank-one of `trivialModulePart`; R565 proves that the trivial-module rank-one fact follows from exact Cartan image equality `Submodule.map j_q trivialModuleGK_H8 = trivialModulePart`; R566 rewrites source equality and compactDual/H8 identification through the same Cartan H8 line; R567 proves by countermodel that those Cartan-line exactness statements are not consequences of the current abstract interface; R568 rewrites the exact Cartan image equality as scalar surjectivity by `j_q (r • h^4)` onto the trivial-module part, and shows the containment direction follows from compactDual = Cartan; R569 gives a countermodel showing compactDual = Cartan still does not force scalar surjectivity; R570 proves rank-one of the trivial-module part plus compactDual = Cartan does force exact Cartan image and scalar preimages; R571 reframes the surviving obligations as source equality, source-invariants/H8 equality, and target rank; R572 routes the target rank through the expected degree-8 Shimura Betti slot; R573 splits source-invariants/H8 into no-extra-source containment plus membership of the generator `h^4`, with a rank-one alternate criterion; R574 pushes those two source-carrier facts back to the compact-dual carrier: prove `compactDual <= H8` and prove `h^4` lies in compactDual; R575 rewrites those compact-dual carrier targets as the two Cartan/compactDual containments; R576 rewrites the remaining source equality as two source/Cartan containment directions and feeds all four Cartan containment directions into the same boundary package; R577 proves by countermodel that those four carrier containments still do not force the target expected-Betti rank; R578 routes the target rank through the degree-8 compact-dual Hodge-sum profile certified in FrontC11; R579 derives that target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from compactDual/Cartan two-sided containment plus scalar preimage surjectivity; R581 proves that target Hodge-sum rank and scalar-preimage surjectivity are equivalent once the four Cartan carrier directions are fixed; R582 rewrites the four Cartan carrier directions as source/compactDual H8 no-extra plus h^4 generator-membership splits; R583 collapses each H8 split to exact equality with H8; R584 translates those H8 equalities into Matsushima boundary language and proves target Hodge-sum rank is equivalent to `surjectivity_target = trivialModulePart`; R585 proves that, after `compactDual = H8`, this concrete boundary package is equivalent to the existing `MatsushimaV56BoundaryData`; R586 records a countermodel showing the H8 carrier equalities alone do not force the target boundary equality or boundary data; R587 isolates the remaining target boundary as the single reverse containment `trivialModulePart <= surjectivity_target`, and proves that this containment is also not forced by the abstract H8 carrier interface; R588 proves this reverse containment is exactly the element-level scalar-preimage statement `forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta` once `source = H8`, with no finite-dimensional rank hypothesis.  The remaining concrete EVII facts are the two H8 carrier equalities plus genuine target Matsushima/EVII scalar-surjectivity geometry.  No new axioms.

- status: `active-open`
- owner route(s): `chain:hcgap-l4-multifront-active`
- prove/provide declaration(s): `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond`, `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond`, `HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge`, `HodgeReduction.HCGapL4.FrontC9_EVIIHodgeNumberComputation.eviiCompactDualCertification`, `HodgeReduction.HCGapL4.FrontC10_V56CohomologyIdentification.EVII_V56_CohomologyBridge`, `HodgeReduction.HCGapL4.FrontC11_ShimuraBettiComputation.shimuraEVIIExpectedBettiKnownHodgeSumCertification_current`, +62 more
- start files: `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean [registered]`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean [registered]`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean [registered]`, `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean [registered]`, `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean [registered]`, `HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean [registered]`, +49 more
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
| `chain:main-hc-axiom-relative` | main | conditional | - | `gap:G-main-hc`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-cm-abelian-hc`, +1 more | cut: 2, infra: 1, on-chain: 2 |
| `chain:unconditional-classical` | support | closed-modulo-cy3-citation | - | `gap:G-classical-mathlib-port` | cut: 1, on-chain: 1 |
| `chain:hcgap-l2-trivial-instances` | support | stable | `chain:main-hc-axiom-relative` | `gap:G-l2-cohomology-construction` | registered: 3 |
| `chain:hcgap-l4-multifront-active` | active | exploratory | `chain:main-hc-axiom-relative` | `gap:G-hcgap-l4-multifront` | on-disk-unloaded: 3, registered: 47 |
| `chain:concrete-evii-toy` | support | closed-toy | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 1 |
| `chain:historical-cone-audits` | infra | infra | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 4 |

## Gap Ledger

| gap | status | route owners | declarations | files |
|-----|--------|--------------|--------------|-------|
| `gap:G-main-hc` | conditional | `chain:main-hc-axiom-relative` | `HodgeReduction.CanonicalHCData`, `HodgeReduction.CanonicalHCDataByCodim`, `HodgeReduction.canonicalTargetVariety`, +15 more | cut: 2, infra: 1, on-chain: 1 |
| `gap:G-l1-e7-shimura-tor` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L1_G1_E7ShimuraTor_Inhabited`, `HodgeReduction.E7ShimuraTor` | cut: 1, infra: 1, on-disk-unloaded: 2, registered: 1 |
| `gap:G-l2-cohomology-construction` | open | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L2_G1_VarietyCohomologyData_Constructed_NonToy`, `HodgeReduction.HCGapRegistry.L2_G2_E7CanonicalCohomology_MatchesPaper`, `HodgeReduction.SmoothProjectiveVariety.cohomology` | infra: 1, on-chain: 1, registered: 4 |
| `gap:G-l3-v56-mt-identification` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L3_G1_V56_PureHodgeStructure_W3_HodgeDiamond`, `HodgeReduction.HCGapRegistry.L3_G2_V56_To_E7_Variety_Cohomology_Identification` | infra: 1, registered: 4 |
| `gap:G-l4-cm-abelian-hc` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.hyp_HC_CM_Ab_real`, `HodgeReduction.absHodgeClassesAtDegreeCM`, `HodgeReduction.deligne_1982_abs_hodge_cm`, +5 more | cut: 2, infra: 1, on-disk-unloaded: 2 |
| `gap:G-l4-mt-correspondence` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.mt_correspondence_e7_witness_exists`, `HodgeReduction.e7_cm_witness_exists`, `HodgeReduction.e7_chosen_witness_correspondence_package_exists`, +11 more | cut: 3, infra: 1, registered: 1 |
| `gap:G-classical-mathlib-port` | deferred | `chain:unconditional-classical` | `HodgeReduction.e6_classical_remainder_exists`, `HodgeReduction.e6_remainder_transfer`, `HodgeReduction.e6_factor_classical_transfer`, +9 more | cut: 3, on-chain: 2 |
| `gap:G-hcgap-l4-multifront` | active-open | `chain:hcgap-l4-multifront-active` | `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.e7EVIICompactDualHodgeDiamond`, `HodgeReduction.HCGapL4.FrontC7_E7EVIIHodgeDiamondInstance.v56Weight3HodgeDiamond`, `HodgeReduction.HCGapL4.FrontC8_V56MTBridge.EVIICompactDual_to_V56_Weight3_Bridge`, +65 more | on-disk-unloaded: 3, registered: 52 |

## Automatic Route Labels

These labels are generated for debt files from imports, names, source text, and the audit route taxonomy.  They are the route map an agent should use before opening individual files.

| route label | state | files | dominant bucket | classes | latest |
|-------------|-------|------:|-----------------|---------|--------|
| `chain:main-hc-axiom-relative` | active/exploring | 387 | core-support | on-disk-unloaded: 157, orphan: 230 | 2026-05-30 04:43 |
| `chain:hcgap-l4-multifront-active` | active/exploring | 308 | core-support | on-disk-unloaded: 96, orphan: 212 | 2026-05-30 04:43 |
| `gap:G-hcgap-l4-multifront` | active/exploring | 308 | core-support | on-disk-unloaded: 96, orphan: 212 | 2026-05-30 04:43 |
| `gap:G-main-hc` | active/exploring | 288 | core-support | on-disk-unloaded: 76, orphan: 212 | 2026-05-30 04:43 |
| `gap:G-l1-e7-shimura-tor` | active/exploring | 280 | core-support | on-disk-unloaded: 69, orphan: 211 | 2026-05-30 04:43 |
| `gap:G-l2-cohomology-construction` | active/exploring | 256 | core-support | on-disk-unloaded: 107, orphan: 149 | 2026-05-30 04:43 |
| `gap:G-l4-mt-correspondence` | active/exploring | 142 | core-support | on-disk-unloaded: 41, orphan: 101 | 2026-05-30 04:43 |
| `gap:G-l4-cm-abelian-hc` | active/exploring | 115 | core-support | on-disk-unloaded: 44, orphan: 71 | 2026-05-30 04:43 |
| `gap:G-l3-v56-mt-identification` | active/exploring | 96 | core-support | on-disk-unloaded: 67, orphan: 29 | 2026-05-30 04:43 |
| `chain:unconditional-classical` | active/exploring | 36 | core-support | on-disk-unloaded: 30, orphan: 6 | 2026-05-30 04:43 |
| `chain:hcgap-l2-trivial-instances` | closed/support | 256 | core-support | on-disk-unloaded: 107, orphan: 149 | 2026-05-30 04:43 |
| `chain:concrete-evii-toy` | closed/support | 155 | core-support | on-disk-unloaded: 80, orphan: 75 | 2026-05-30 04:43 |
| `gap:G-classical-mathlib-port` | classified | 28 | core-support | on-disk-unloaded: 23, orphan: 5 | 2026-05-30 04:43 |
| `chain:historical-cone-audits` | classified | 15 | core-support | on-disk-unloaded: 13, orphan: 2 | 2026-05-29 03:18 |

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
| `HodgeReduction.lean` | active/exploring | 28 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, +6 more |
| `HodgeReduction/HCGapL4/CY3SpringerDiscriminant.lean` | active/exploring | 5 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +1 more |
| `HodgeReduction/HCGapL2/AbelianSurface.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/HCGapL4/E6CaseProof.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence` |
| `HodgeReduction/HCGapL2/ProjectiveThreeSpace.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` |
| `HodgeReduction/HCGapL2/ProjectivePlane.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` |
| `HodgeReduction/HCGapL4/V56CohomologyRank.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +3 more |
| `HodgeReduction/HCGapL4/CY3NonexistenceDecomposition.lean` | active/exploring | 5 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +3 more |
| `HodgeReduction/HCGapL4/ClassicalCartanGapCard.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +3 more |
| `HodgeReduction/Infrastructure/ClassicalCominusculeClassification.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence` |
| `HodgeReduction/HCGapL4/E6CaseClosureConstraints.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more |
| `HodgeReduction/HCGapL4/DeligneCMHCSkeleton.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +1 more |
| `HodgeReduction/HCGapL4/Lefschetz11Arithmetic.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence` |
| `HodgeReduction/HCGapL4/NoetherLefschetzSkeleton.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +2 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorDecomposition.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more |
| `HodgeReduction/HCGapL4/CY3NonexistenceProof.lean` | active/exploring | 4 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +1 more |
| `HodgeReduction/HCGapL2/EVIICohomologyModel.lean` | active/exploring | 6 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-mt-correspondence`, +1 more |
| `HodgeReduction/Infrastructure/J3OAlgebra.lean` | active/exploring | 5 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Ledger.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
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
| `HodgeReduction/Infrastructure/Cohomology/RiemannRoch.lean` | active/exploring | 5 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Cohomology/LefschetzHyperplane.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/Infrastructure/Cohomology/HardLefschetz.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification` |
| `HodgeReduction/Infrastructure/Cohomology/ComparisonTheorem.lean` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` |
| `HodgeReduction/Infrastructure/Cohomology/ChowRing.lean` | active/exploring | 3 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` |
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
| `HodgeReduction/HCGapL4/HCFrontierAfterLocallyConstantBundle.lean` | active/exploring | 198 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/HCGapL4/HCFrontierAfterInternalMTPackage.lean` | active/exploring | 114 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/GaussianNumberFieldChainIntegration.lean` | active/exploring | 48 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/GaussianIntActionToGaussianFieldTarget.lean` | active/exploring | 80 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/GaussianFieldToEnd0Chain.lean` | active/exploring | 82 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/EllipticCurveCohomologyRealizationAudit.lean` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc`, `gap:G-l4-mt-correspondence`, +1 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorMTCorrespondenceReplacement.lean` | active/exploring | 32 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorFieldReplacementPlan.lean` | active/exploring | 36 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/E7ShimuraTorCohomologyReplacement.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` |
| `HodgeReduction/HCGapL4/E7ShimuraTorAlgClassesReplacementViaCycleClassMap.lean` | active/exploring | 14 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/CanonicalConeExtractionAudit.lean` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +4 more |
| `HodgeReduction/HCGapL4/CMSourceBridgeNextTarget.lean` | active/exploring | 43 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/CMFieldSequenceStoppingAudit.lean` | active/exploring | 40 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/AbelianVarietyInterfaceECProjectiveRealization.lean` | active/exploring | 33 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more |
| `HodgeReduction/HCGapL4/ACDReconciliation.lean` | active/exploring | 2 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` |
| `HodgeReduction/Concrete.lean` | active/exploring | 57 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +1 more |
| `HodgeReduction/HCGapL4/R504_MultiFrontWave16Audit.lean` | active/exploring | 199 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` | active/exploring | 180 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` | active/exploring | 177 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` | active/exploring | 164 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R217_ConeAudit.lean` | active/exploring | 13 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/Infrastructure/Shimura/SchubertCells.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/Cohomology/TateConjecture.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/Cohomology/Lattice.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/ExponentialSequence.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy`, `chain:historical-cone-audits` |

## Component Triage

Components are connected by actual Lean imports.  Large components should be split by strengthening automatic route rules, renaming ambiguous files, or quarantining failed tracks.

| component | state | files | bucket | automatic route labels | anchors |
|-----------|-------|------:|--------|------------------------|---------|
| `C001` | active/exploring | 97 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more | cut: 5, infra: 1, on-chain: 11, registered: 10 |
| `C002` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | on-chain: 1, registered: 1 |
| `C003` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` | on-chain: 3, registered: 3 |
| `C004` | active/exploring | 291 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more | cut: 13, on-chain: 69, registered: 75 |
| `C005` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more | cut: 1, on-chain: 1 |
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
| `C028` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc`, +2 more | cut: 1 |

## Unowned Debt

Files with no automatic route label.  These are the safest next candidates for comment-only classification, naming cleanup, quarantine, or deletion after a compile check.

- `HodgeReduction/Infrastructure/Automorphic/Basic.lean` -- orphan, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Automorphic/BorelBottWeil.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Automorphic/ModularForm.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Cohomology/AlgebraicCycle.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/Cohomology/PicardGroup.lean` -- on-disk-unloaded, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/DynkinMarks.lean` -- orphan, core-support, 2026-05-29
- `HodgeReduction/Infrastructure/KostantCominusculeClassification.lean` -- on-disk-unloaded, core-support, 2026-05-29

## Route Details

### `chain:main-hc-axiom-relative` -- Main Mumford--Tate-reduction HC chain

`OpenHypotheses` (R169 cohomology / algClasses bridge + R174a Deligne) composes with `MainTheorem` (R170 four-case main reduction + R171/R188/R542/R551 canonical headline) to reach `hodgeConjectureReal_canonical`.  R546 adds the separately audited codim-one endpoint `hodgeConjectureReal_canonical_codim1`; R550 reroutes it directly through the classical Lefschetz (1,1) cut; R551 uses that endpoint for the `p = 1` branch of the full canonical proof, uses the direct non-codim-one MT package for `p ≠ 1`, and avoids mentioning `canonicalHCDataByCodim` in the endpoint type.  Full HC remains conditional on a canonical target SPV, its E7 factor/scope facts, the non-codim-one MT-witness route, and the CM-source all-codim bridge for `p ≠ 1`.

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

Meyer / G_2 / F_4 / E_8 vacuity are kernel-pure derived theorems.  `thm_cy3_e7_nonexistence` still consumes `cy3_e7_nonexistence_paper_axiom` (paper §4 Stages A--D).

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

### `chain:hcgap-l4-multifront-active` -- HCGapL4 multi-front attack waves (R420 -- R588)

5 parallel attack fronts on the L4 cohomology-profile + connectedness pipeline.  Per-wave audits R451 / R456 / R460 / R465 / R470 / R476 enumerate substantive theorems per round.  R552 extends the FrontC numeric bridge through a buildable EVII compact-dual/V56/Shimura expected Betti profile: all degrees 0..8 are certified by known Hodge sums, with degree 3 explicitly routed through V56 rather than hidden in compact-dual odd cohomology.  R553 connects that finite V56 profile to the actual infrastructure `PureHodgeStructure V56 3`.  R554 proves the abstract Matsushima boundary composition: target invariants reduce to the cuspidal trivial-module part, and compact-dual image reduces to that part once concrete EVII source/target boundary equalities are provided.  R555 tightens the source-side obligation: Cartan's trivial-module H8 line rewrites to compact-dual H8, its classes are algebraic through `CompactDualData`, and the R554 source equality follows from `surjectivity_source = source_invariants`.  R556 converts the remaining boundary equalities into four concrete linear-algebra tasks; R557 shows target containment is forced by source containment; R558 transports target finrank from source finrank; R559 rewrites the remaining source obligations against compact-dual/Cartan data; R560 proves those obligations are not derivable from the current abstract interface alone; R561 replaces the three R559 obligations by the sharper compact-dual exact image target plus target-invariant exactness; R562 removes target-invariant exactness as an independent obligation by deriving it from exact image plus the compactDual/trivialModulePart rank bridge; R563 proves exact image is equivalent to the source equality `surjectivity_source = compactDual`; R564 closes the compact-dual H8 rank-one side and reduces the rank bridge to `compactDual = H8` plus `finrank trivialModulePart = 1`; R565 replaces that target rank-one obligation by exact Cartan image equality; R566 rewrites the remaining source and compact-dual carrier obligations to Cartan-line exactness; R567 blocks any attempt to derive those exactness statements from the current abstract interface alone; R568 turns exact Cartan image into the element-level scalar-preimage target `forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta`; R569 shows that even compactDual = Cartan does not force that scalar-surjectivity target; R570 proves that target rank-one plus compactDual = Cartan is enough for exact Cartan image; R571/R572 reduce the live target to source equality, source-invariants/H8, and expected Betti-8 target rank; R573 splits source-invariants/H8 into no-extra-source containment and `h^4` generator membership, with a source-rank-one alternate route; R574 rewrites that source-carrier split through `MatsushimaCompactDualData.compactDual`, leaving compactDual containment in H8 plus generator membership as the next concrete carrier targets; R575 rewrites those as the Cartan/compactDual containments `compactDual <= CartanH8` and `CartanH8 <= compactDual`; R576 rewrites source equality as source/Cartan two-sided containment and feeds the two source directions plus the two compactDual directions into the boundary package; R577 records that all four carrier directions still do not imply the target expected-Betti rank; R578 routes that target rank through the degree-8 compact-dual Hodge-sum profile; R579 derives the target Hodge-sum rank from exact Cartan image equality; R580 derives exact Cartan image from compactDual/Cartan two-sided containment plus scalar preimage surjectivity; R581 proves that target Hodge-sum rank and scalar-preimage surjectivity are equivalent once the four Cartan carrier directions are fixed; R582 rewrites the four Cartan carrier directions as source/compactDual H8 no-extra plus h^4 generator-membership splits; R583 collapses each H8 split to exact equality with H8; R584 translates those H8 equalities into Matsushima boundary language and proves target Hodge-sum rank is equivalent to `surjectivity_target = trivialModulePart`; R585 proves that, after `compactDual = H8`, this concrete boundary package is equivalent to the existing `MatsushimaV56BoundaryData`; R586 records a countermodel showing the H8 carrier equalities alone do not force the target boundary equality or boundary data; R587 isolates the remaining target boundary as the single reverse containment `trivialModulePart <= surjectivity_target`, and proves that this containment is also not forced by the abstract H8 carrier interface; R588 proves this reverse containment is exactly the element-level scalar-preimage statement `forall beta in trivialModulePart, exists r, j_q (r • h^4) = beta` once `source = H8`, with no finite-dimensional rank hypothesis.  The route remains exploratory, not a closure claim.

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
- `HodgeReduction/HCGapL4/FrontE6_FeedR405ConditionalTransfer.lean` -- on-disk-unloaded
- `HodgeReduction/HCGapL4/FrontD6_Deligne1982MinimalFragment.lean` -- on-disk-unloaded
- `HodgeReduction/HCGapL4/R476_MultiFrontWave6Audit.lean` -- on-disk-unloaded

### `chain:concrete-evii-toy` -- Concrete EVII sanity-check chain

`HC_for_Concrete_EVII` specialises the abstract closure `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` to a concrete `A_EVII := Polynomial ℚ` toy carrier.  Cone is `{propext, Classical.choice, Quot.sound}` (no project axioms) but the carrier is explicitly toy; per R201 mandate it is EXCLUDED from real-HC closure accounting.

Taxonomy files:
- `HodgeReduction/Concrete.lean` -- on-disk-unloaded

### `chain:historical-cone-audits` -- Historical per-round cone audit drivers (R217 -- R476)

85 per-round `#print axioms` / `#check` driver scripts produced at the end of each attack round.  Each script is a standalone audit consuming a fixed subset of the active chain at its timestamp; none are imported by `HodgeReduction.lean`.  Moved out of the project root into `HodgeReduction/ConeAudits/` and registered as `infraFiles` so the chainAudit classifier records them as infra rather than orphan.

Taxonomy files:
- `HodgeReduction/ConeAudits/R217_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` -- on-disk-unloaded

