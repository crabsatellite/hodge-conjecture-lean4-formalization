# HodgeReduction -- route index

Decision-first index for the next research round.  Treat this as the base map: the proof spine is the endpoint closure, route labels are generated automatically from the Lean import graph, file names, source text, and audit route taxonomy.  The goal is to show which proof routes are active, blocked, closed, or orphaned before a new agent starts editing.

* endpoints: **7**  *  open mathematical cuts: **17**  *  route taxonomy chains: **6**  *  route taxonomy gaps: **8**  *  debt components: **30**  *  branch heads: **74**

## Audit Truth Contract

This file is generated.  Future agents should update Lean files, audit rules, or the route taxonomy config, then regenerate the reports.  Do not maintain a separate hand-written route ledger.

## Next Agent Brief

Research attack target:
- Primary proof gap: `gap:G-main-hc` -- The `hodgeConjectureReal_canonical` endpoint is a kernel-pure composition once the project axiom `canonicalHCDataByCodim` is accepted.  R538/R539 weakens the R536/R537 uniform package, and R540 removes the hidden source-HC field: the source is now a genuine CM abelian variety with its own `A.cohomology` / `A.algClasses`, while source HC is derived through the CM bridge.  It is NOT an unconditional proof of HC; it remains conditional on constructing those degreewise fields for the AMRT E_{7(-25)} toroidal compactification.
- Route owner(s): `chain:main-hc-axiom-relative`
- Current constructive attack route: `chain:hcgap-l4-multifront-active`.  Use it to replace the primary cut; do not route around the configured gap ledger.
- Success criterion: A successful follow-up decomposes `canonicalHCDataByCodim` into target cohomology, target algebraic classes, a genuine CM source at p, and one-codimension MT-correspondence construction cuts, or closes the `mtCorrespondenceAt p` field for a genuine canonical codimension by Chow / cycle-class data.

Kernel cut ledger.  These are audit-visible unresolved constants on the endpoint closure; use the configured route/gap above to decide the next research attack, not this flat list alone:
- `HodgeReduction.SmoothProjectiveVariety.algClasses` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.SmoothProjectiveVariety.cohomology` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.absHodgeClassesAtDegree` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.abs_hodge_cm_implies_algebraic` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.canonicalHCDataByCodim` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.cy3_e7_excludes_e6` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_e7_fts_omega_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_j3o_nonrealization_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_springer_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_inherits_e7_factor` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_mtd_isSemisimple` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.deligne_1982_abs_hodge_cm` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.e6_classical_remainder_exists` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e6_remainder_transfer` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e7_chosen_witness_correspondence_package_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_cm_witness_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.hc_real_classical_cartan` in `HodgeReduction/MainTheorem.lean`

Live subgaps exposed by the current route:
| priority | gap | labelled debt files | declarations | taxonomy files |
|---------:|-----|--------------------:|--------------|----------------|
| 1 | `gap:G-hcgap-l4-multifront` (active-open) | 315 | - | `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean`, +11 more |

Priority uses the project-configured `gapPriority` order first; remaining active subgaps are sorted mechanically by labelled debt file count.  It is a triage order, not a mathematical proof of easiest-first.

## New Agent Attack Cards

Readiness verdict: **actionable with caveat**.  The main cut and replacement route are clear, but the active branch-head queue is still contaminated by dead-route labels.  Start from the gap cards and taxonomy files below; use the branch-head queue only for import triage.

Current replacement plan:
- FrontC: enrich the low-degree Hodge polynomial algebra so it feeds the profile-matching dispatcher (FrontE).
- FrontB: replace the abstract connectedness pipeline with the genuine Baily--Borel connectedness theorem for arithmetic quotients.
- FrontD: deliver the E_7 -> CM Chow correspondence at codim 1 first, then lift to all p; this would discharge G-l4-mt-correspondence for the canonical case.
- Never re-bundle a closed front into a stronger hypothesis; chainAudit treats `def : Prop` placeholders and conjunction shells as hard failures.
- Final success criterion: A successful follow-up decomposes `canonicalHCDataByCodim` into target cohomology, target algebraic classes, a genuine CM source at p, and one-codimension MT-correspondence construction cuts, or closes the `mtCorrespondenceAt p` field for a genuine canonical codimension by Chow / cycle-class data.

### Priority 1: `gap:G-hcgap-l4-multifront` -- HCGapL4 multi-front Layer-4 attack waves (R420 -- R476)

Active exploratory attack waves on the L4 / cohomology-profile / connectedness pipeline: FrontA (Deligne H0 sheaf realization), FrontB (Baily--Borel connectedness), FrontC (E_7 low-degree Hodge numbers + Hodge polynomial algebra + all-degree rank adapter), FrontD (E_7 -> CM Chow correspondence + Deligne 1982 minimal fragment), FrontE (real-carrier profile matching + R405 conditional transfer feed).  Audits R451 / R456 / R460 / R465 / R470 / R476 are wave-level summaries.  R476 reports 51 cumulative substantive theorems across 6 waves; Front D activated in Wave 6.

- status: `active-open`
- owner route(s): `chain:hcgap-l4-multifront-active`
- prove/provide declaration(s): -
- start files: `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean [registered]`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean [registered]`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean [registered]`, `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean [registered]`, `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean [registered]`, `HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean [on-disk-unloaded]`, +8 more
- classification note: `orphan` / `on-disk-unloaded` here means the file is not endpoint-reached yet.  For an active replacement route this is expected until a new theorem consumes the branch and removes the main cut; it is not by itself a quarantine signal.
- trick-audit priority: no W5 Prop-definition finding in the listed start files.
- import-graph heads touching this gap:
  - `HodgeReduction/HCGapL4/R504_MultiFrontWave16Audit.lean` -- active/exploring, closure 205, core-support
  - `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` -- active/exploring, closure 182, core-support
  - `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` -- active/exploring, closure 178, core-support

## Main Proof Spine

| endpoint | mathematical cuts | full axiom count |
|----------|-------------------|-----------------:|
| `HodgeReduction.hodgeConjectureReal_canonical` | `HodgeReduction.SmoothProjectiveVariety.algClasses`, `HodgeReduction.SmoothProjectiveVariety.cohomology`, `HodgeReduction.absHodgeClassesAtDegree`, `HodgeReduction.abs_hodge_cm_implies_algebraic`, `HodgeReduction.canonicalHCDataByCodim`, +1 more | 9 |
| `HodgeReduction.main_reduction_real` | `HodgeReduction.SmoothProjectiveVariety.algClasses`, `HodgeReduction.SmoothProjectiveVariety.cohomology`, `HodgeReduction.absHodgeClassesAtDegree`, `HodgeReduction.abs_hodge_cm_implies_algebraic`, `HodgeReduction.cy3_e7_excludes_e6`, +11 more | 19 |
| `HodgeReduction.thm_Meyer` | - | 0 |
| `HodgeReduction.thm_G2F4` | - | 3 |
| `HodgeReduction.thm_E8_vacuous` | - | 3 |
| `HodgeReduction.thm_cy3_e7_nonexistence` | `HodgeReduction.cy3_e7_fts_omega_stage`, `HodgeReduction.cy3_e7_j3o_nonrealization_stage`, `HodgeReduction.cy3_e7_springer_stage` | 6 |
| `HodgeReduction.thm_subcase3b_vacuous` | - | 0 |

Open mathematical cut ledger:
- `HodgeReduction.SmoothProjectiveVariety.algClasses` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.SmoothProjectiveVariety.cohomology` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.absHodgeClassesAtDegree` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.abs_hodge_cm_implies_algebraic` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.canonicalHCDataByCodim` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.cy3_e7_excludes_e6` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_e7_fts_omega_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_j3o_nonrealization_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_e7_springer_stage` in `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean`
- `HodgeReduction.cy3_inherits_e7_factor` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.cy3_mtd_isSemisimple` in `HodgeReduction/HCGapL4/CY3E7Bridge.lean`
- `HodgeReduction.deligne_1982_abs_hodge_cm` in `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean`
- `HodgeReduction.e6_classical_remainder_exists` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e6_remainder_transfer` in `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean`
- `HodgeReduction.e7_chosen_witness_correspondence_package_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.e7_cm_witness_exists` in `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean`
- `HodgeReduction.hc_real_classical_cartan` in `HodgeReduction/MainTheorem.lean`

## Route Taxonomy

| id | role | status | depends on | gaps | files |
|----|------|--------|------------|------|-------|
| `chain:main-hc-axiom-relative` | main | conditional | - | `gap:G-main-hc`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-cm-abelian-hc`, +1 more | cut: 2, infra: 1, on-chain: 2 |
| `chain:unconditional-classical` | support | closed-modulo-cy3-citation | - | `gap:G-classical-mathlib-port` | cut: 1, on-chain: 1 |
| `chain:hcgap-l2-trivial-instances` | support | stable | `chain:main-hc-axiom-relative` | `gap:G-l2-cohomology-construction` | registered: 3 |
| `chain:hcgap-l4-multifront-active` | active | exploratory | `chain:main-hc-axiom-relative` | `gap:G-hcgap-l4-multifront` | on-disk-unloaded: 4, registered: 5 |
| `chain:concrete-evii-toy` | support | closed-toy | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 1 |
| `chain:historical-cone-audits` | infra | infra | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 4 |

## Gap Ledger

| gap | status | route owners | declarations | files |
|-----|--------|--------------|--------------|-------|
| `gap:G-main-hc` | conditional | `chain:main-hc-axiom-relative` | `HodgeReduction.CanonicalHCData`, `HodgeReduction.CanonicalHCDataByCodim`, `HodgeReduction.canonicalHCDataByCodim`, +3 more | cut: 2, infra: 1, on-chain: 1 |
| `gap:G-l1-e7-shimura-tor` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L1_G1_E7ShimuraTor_Inhabited`, `HodgeReduction.E7ShimuraTor` | cut: 1, infra: 1, on-disk-unloaded: 2, registered: 1 |
| `gap:G-l2-cohomology-construction` | open | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L2_G1_VarietyCohomologyData_Constructed_NonToy`, `HodgeReduction.HCGapRegistry.L2_G2_E7CanonicalCohomology_MatchesPaper`, `HodgeReduction.SmoothProjectiveVariety.cohomology` | infra: 1, on-chain: 1, registered: 4 |
| `gap:G-l3-v56-mt-identification` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L3_G1_V56_PureHodgeStructure_W3_HodgeDiamond`, `HodgeReduction.HCGapRegistry.L3_G2_V56_To_E7_Variety_Cohomology_Identification` | infra: 1, registered: 4 |
| `gap:G-l4-cm-abelian-hc` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.hyp_HC_CM_Ab_real`, `HodgeReduction.absHodgeClassesAtDegree`, `HodgeReduction.deligne_1982_abs_hodge_cm`, +2 more | cut: 2, infra: 1, on-disk-unloaded: 2 |
| `gap:G-l4-mt-correspondence` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.mt_correspondence_e7_witness_exists`, `HodgeReduction.e7_cm_witness_exists`, `HodgeReduction.e7_chosen_witness_correspondence_package_exists`, +2 more | cut: 2, infra: 1, registered: 1 |
| `gap:G-classical-mathlib-port` | deferred | `chain:unconditional-classical` | `HodgeReduction.e6_classical_remainder_exists`, `HodgeReduction.e6_remainder_transfer`, `HodgeReduction.e6_factor_classical_transfer`, +9 more | cut: 3, on-chain: 2 |
| `gap:G-hcgap-l4-multifront` | active-open | `chain:hcgap-l4-multifront-active` | - | on-disk-unloaded: 4, registered: 10 |

## Automatic Route Labels

These labels are generated for debt files from imports, names, source text, and the audit route taxonomy.  They are the route map an agent should use before opening individual files.

| route label | state | files | dominant bucket | classes | latest |
|-------------|-------|------:|-----------------|---------|--------|
| `chain:main-hc-axiom-relative` | active/exploring | 393 | core-support | on-disk-unloaded: 167, orphan: 226 | 2026-05-29 11:22 |
| `chain:hcgap-l4-multifront-active` | active/exploring | 315 | core-support | on-disk-unloaded: 103, orphan: 212 | 2026-05-29 11:22 |
| `gap:G-hcgap-l4-multifront` | active/exploring | 315 | core-support | on-disk-unloaded: 103, orphan: 212 | 2026-05-29 11:22 |
| `gap:G-main-hc` | active/exploring | 290 | core-support | on-disk-unloaded: 78, orphan: 212 | 2026-05-29 11:22 |
| `gap:G-l1-e7-shimura-tor` | active/exploring | 280 | core-support | on-disk-unloaded: 69, orphan: 211 | 2026-05-29 11:22 |
| `gap:G-l2-cohomology-construction` | active/exploring | 256 | core-support | on-disk-unloaded: 108, orphan: 148 | 2026-05-29 11:22 |
| `gap:G-l4-mt-correspondence` | active/exploring | 143 | core-support | on-disk-unloaded: 42, orphan: 101 | 2026-05-29 11:22 |
| `gap:G-l4-cm-abelian-hc` | active/exploring | 116 | core-support | on-disk-unloaded: 45, orphan: 71 | 2026-05-29 11:22 |
| `gap:G-l3-v56-mt-identification` | active/exploring | 101 | core-support | on-disk-unloaded: 76, orphan: 25 | 2026-05-29 11:22 |
| `chain:unconditional-classical` | active/exploring | 37 | core-support | on-disk-unloaded: 31, orphan: 6 | 2026-05-29 11:22 |
| `chain:hcgap-l2-trivial-instances` | closed/support | 256 | core-support | on-disk-unloaded: 108, orphan: 148 | 2026-05-29 11:22 |
| `chain:concrete-evii-toy` | closed/support | 159 | core-support | on-disk-unloaded: 85, orphan: 74 | 2026-05-29 11:22 |
| `gap:G-classical-mathlib-port` | classified | 29 | core-support | on-disk-unloaded: 24, orphan: 5 | 2026-05-29 11:22 |
| `chain:historical-cone-audits` | classified | 15 | core-support | on-disk-unloaded: 13, orphan: 2 | 2026-05-29 03:18 |

## Branch Head State Summary

| state | heads | closure files |
|-------|------:|--------------:|
| active/exploring | 68 | 1829 |
| mixed-active/dead | 1 | 1 |
| closed/support | 4 | 4 |
| unclassified | 1 | 1 |

## Branch Work Queue

Branch heads are off-chain files that no other off-chain debt file imports.  Their closure follows real Lean imports downward.  This table is sorted by generated state, recency, and size so live, mixed, and blocked attempts are visible without opening the files first.

| head | state | closure | bucket | automatic route labels |
|------|-------|--------:|--------|------------------------|
| `HodgeReduction.lean` | active/exploring | 23 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, +6 more |
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
| `HodgeReduction/HCGapL4/R504_MultiFrontWave16Audit.lean` | active/exploring | 205 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R477_R480_ConeAudit.lean` | active/exploring | 182 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R471_R476_ConeAudit.lean` | active/exploring | 178 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` | active/exploring | 164 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R217_ConeAudit.lean` | active/exploring | 13 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/HCGapL4/CY3VacuousClosure.lean` | mixed-active/dead | 1 | failed-pattern | `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l4-cm-abelian-hc`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` |
| `HodgeReduction/Infrastructure/Shimura/SchubertCells.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/Cohomology/TateConjecture.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/Cohomology/Lattice.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy` |
| `HodgeReduction/Infrastructure/AlgebraicGeometry/ExponentialSequence.lean` | closed/support | 1 | core-support | `chain:concrete-evii-toy`, `chain:historical-cone-audits` |

## Component Triage

Components are connected by actual Lean imports.  Large components should be split by strengthening automatic route rules, renaming ambiguous files, or quarantining failed tracks.

| component | state | files | bucket | automatic route labels | anchors |
|-----------|-------|------:|--------|------------------------|---------|
| `C001` | active/exploring | 76 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more | cut: 1, infra: 1, on-chain: 4, registered: 9 |
| `C002` | active/exploring | 21 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more | cut: 4, on-chain: 7, registered: 1 |
| `C003` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | on-chain: 1, registered: 1 |
| `C004` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-main-hc` | on-chain: 3, registered: 3 |
| `C005` | active/exploring | 297 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more | cut: 13, on-chain: 69, registered: 63 |
| `C006` | mixed-active/dead | 1 | failed-pattern | `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l4-cm-abelian-hc`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` | cut: 1, on-chain: 1 |
| `C007` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, +3 more | cut: 1, on-chain: 1 |
| `C008` | closed/support | 1 | core-support | `chain:concrete-evii-toy` | - |
| `C009` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l1-e7-shimura-tor` | - |
| `C010` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l2-cohomology-construction` | - |
| `C011` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l1-e7-shimura-tor` | - |
| `C012` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port` | - |
| `C013` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` | - |
| `C014` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l3-v56-mt-identification` | - |
| `C015` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l3-v56-mt-identification` | - |
| `C016` | closed/support | 1 | core-support | `chain:concrete-evii-toy` | - |
| `C017` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | - |
| `C018` | closed/support | 1 | core-support | `chain:concrete-evii-toy` | - |
| `C019` | active/exploring | 3 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction` | - |
| `C020` | unclassified | 1 | core-support | - | - |
| `C021` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` | - |
| `C022` | active/exploring | 1 | core-support | `chain:unconditional-classical`, `gap:G-classical-mathlib-port` | - |
| `C023` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l3-v56-mt-identification` | registered: 1 |
| `C024` | closed/support | 1 | core-support | `chain:concrete-evii-toy`, `chain:historical-cone-audits` | - |
| `C025` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` | - |
| `C026` | active/exploring | 1 | core-support | `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` | - |
| `C027` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc` | - |
| `C028` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:main-hc-axiom-relative`, `gap:G-l4-cm-abelian-hc` | - |
| `C029` | active/exploring | 1 | core-support | `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:main-hc-axiom-relative`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc`, `gap:G-l4-mt-correspondence`, `gap:G-main-hc` | - |
| `C030` | active/exploring | 1 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l4-cm-abelian-hc`, +2 more | cut: 1 |

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

`OpenHypotheses` (R169 cohomology / algClasses bridge + R174a Deligne) composes with `MainTheorem` (R170 four-case main reduction + R171/R188/R540 canonical headline) to reach `hodgeConjectureReal_canonical`.  Conditional on the degreewise axiom `canonicalHCDataByCodim`; not an unconditional proof of HC.

Entry declarations:
- `HodgeReduction.hodgeConjectureReal_canonical`
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

### `chain:hcgap-l4-multifront-active` -- HCGapL4 multi-front attack waves (R420 -- R476)

5 parallel attack fronts on the L4 cohomology-profile + connectedness pipeline.  Per-wave audits R451 / R456 / R460 / R465 / R470 / R476 enumerate substantive theorems per round.  R476 announces 51 cumulative substantive theorems across 6 waves with 0 added axioms; Front D activated in Wave 6.

Taxonomy files:
- `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean` -- registered
- `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean` -- registered
- `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean` -- registered
- `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean` -- registered
- `HodgeReduction/HCGapL4/FrontC6_AllDegreeHodgeRankAdapter.lean` -- on-disk-unloaded
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

