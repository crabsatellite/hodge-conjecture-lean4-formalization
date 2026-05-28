# HodgeReduction -- route index

Decision-first index for the next research round.  Treat this as the base map: the proof spine is the endpoint closure, route labels are generated automatically from the Lean import graph, file names, source text, and audit route taxonomy.  The goal is to show which proof routes are active, blocked, closed, or orphaned before a new agent starts editing.

* endpoints: **7**  *  open mathematical cuts: **9**  *  route taxonomy chains: **6**  *  route taxonomy gaps: **8**  *  debt components: **1**  *  branch heads: **4**

## Audit Truth Contract

This file is generated.  Future agents should update Lean files, audit rules, or the route taxonomy config, then regenerate the reports.  Do not maintain a separate hand-written route ledger.

## Next Agent Brief

Research attack target:
- Primary proof gap: `gap:G-l1-e7-shimura-tor` -- AMRT 1975 / Baily--Borel 1966 construction of S_Γ^tor as a SmoothProjectiveVariety ℂ.  Required Mathlib infrastructure: arithmetic groups, Hermitian symmetric domains, toroidal compactifications.
- Route owner(s): `chain:main-hc-axiom-relative`
- Current constructive attack route: `chain:hcgap-l4-multifront-active`.  Use it to replace the primary cut; do not route around the configured gap ledger.
- Success criterion: A successful follow-up either retires `canonicalE7ShimuraTor` for a smaller-axiom variant, or shrinks `mtCorrespondencePackage` by exhibiting an unconditional per-codim MT correspondence package via Chow / cycle-class data.

Kernel cut ledger.  These are audit-visible unresolved constants on the endpoint closure; use the configured route/gap above to decide the next research attack, not this flat list alone:
- `HodgeReduction.SmoothProjectiveVariety.algClasses` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.SmoothProjectiveVariety.cohomology` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.canonicalE7ShimuraTor` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.cy3_e7_nonexistence_paper_axiom` in `HodgeReduction/ClassicalResults.lean`
- `HodgeReduction.hc_real_classical_cartan` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.hc_real_cy3_reducible` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.hc_real_e6_case` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.hyp_HC_CM_Ab_real` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.mt_correspondence_e7_witness_exists` in `HodgeReduction/MainTheorem.lean`

Live subgaps exposed by the current route:
| priority | gap | labelled debt files | declarations | taxonomy files |
|---------:|-----|--------------------:|--------------|----------------|
| 1 | `gap:G-hcgap-l4-multifront` (active-open) | 275 | - | `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean`, +7 more |

Priority uses the project-configured `gapPriority` order first; remaining active subgaps are sorted mechanically by labelled debt file count.  It is a triage order, not a mathematical proof of easiest-first.

## New Agent Attack Cards

Readiness verdict: **actionable with caveat**.  The main cut and replacement route are clear, but the active branch-head queue is still contaminated by dead-route labels.  Start from the gap cards and taxonomy files below; use the branch-head queue only for import triage.

Current replacement plan:
- FrontC: enrich the low-degree Hodge polynomial algebra so it feeds the profile-matching dispatcher (FrontE).
- FrontB: replace the abstract connectedness pipeline with the genuine Baily--Borel connectedness theorem for arithmetic quotients.
- FrontD: deliver the E_7 -> CM Chow correspondence at codim 1 first, then lift to all p; this would discharge G-l4-mt-correspondence for the canonical case.
- Never re-bundle a closed front into a stronger hypothesis; chainAudit treats `def : Prop` placeholders and conjunction shells as hard failures.
- Final success criterion: A successful follow-up either retires `canonicalE7ShimuraTor` for a smaller-axiom variant, or shrinks `mtCorrespondencePackage` by exhibiting an unconditional per-codim MT correspondence package via Chow / cycle-class data.

### Priority 1: `gap:G-hcgap-l4-multifront` -- HCGapL4 multi-front Layer-4 attack waves (R420 -- R470)

Active exploratory attack waves on the L4 / cohomology-profile / connectedness pipeline: FrontA (Deligne H0 sheaf realization), FrontB (Baily--Borel connectedness), FrontC (E_7 low-degree Hodge numbers + Hodge polynomial algebra), FrontD (E_7 -> CM Chow correspondence), FrontE (real-carrier profile matching).  Audits R451 / R456 / R460 / R465 / R470 are wave-level summaries.  These files are loaded by `HodgeReduction.lean` but are exploratory and do not yet contribute to the headline kernel-pure closure.

- status: `active-open`
- owner route(s): `chain:hcgap-l4-multifront-active`
- prove/provide declaration(s): -
- start files: `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean [orphan]`, `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean [orphan]`, `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean [orphan]`, `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean [orphan]`, `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean [orphan]`, `HodgeReduction/HCGapL4/R451_MultiFrontFrontierAudit.lean [orphan]`, +4 more
- classification note: `orphan` / `on-disk-unloaded` here means the file is not endpoint-reached yet.  For an active replacement route this is expected until a new theorem consumes the branch and removes the main cut; it is not by itself a quarantine signal.
- trick-audit priority: **348 suspicious Prop definition(s)** in the listed start files; inspect `trick-audit.md` before promotion.
- import-graph heads touching this gap:
  - `HodgeReduction.lean` -- active/exploring, closure 372, core-support
  - `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` -- active/exploring, closure 181, core-support

## Main Proof Spine

| endpoint | mathematical cuts | full axiom count |
|----------|-------------------|-----------------:|
| `HodgeReduction.hodgeConjectureReal_canonical` | `HodgeReduction.canonicalE7ShimuraTor` | 4 |
| `HodgeReduction.main_reduction_real` | `HodgeReduction.SmoothProjectiveVariety.algClasses`, `HodgeReduction.SmoothProjectiveVariety.cohomology`, `HodgeReduction.hc_real_classical_cartan`, `HodgeReduction.hc_real_cy3_reducible`, `HodgeReduction.hc_real_e6_case`, +2 more | 10 |
| `HodgeReduction.thm_Meyer` | - | 0 |
| `HodgeReduction.thm_G2F4` | - | 3 |
| `HodgeReduction.thm_E8_vacuous` | - | 3 |
| `HodgeReduction.thm_cy3_e7_nonexistence` | `HodgeReduction.cy3_e7_nonexistence_paper_axiom` | 4 |
| `HodgeReduction.thm_subcase3b_vacuous` | - | 0 |

Open mathematical cut ledger:
- `HodgeReduction.SmoothProjectiveVariety.algClasses` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.SmoothProjectiveVariety.cohomology` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.canonicalE7ShimuraTor` in `HodgeReduction/OpenHypotheses.lean`
- `HodgeReduction.cy3_e7_nonexistence_paper_axiom` in `HodgeReduction/ClassicalResults.lean`
- `HodgeReduction.hc_real_classical_cartan` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.hc_real_cy3_reducible` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.hc_real_e6_case` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.hyp_HC_CM_Ab_real` in `HodgeReduction/MainTheorem.lean`
- `HodgeReduction.mt_correspondence_e7_witness_exists` in `HodgeReduction/MainTheorem.lean`

## Route Taxonomy

| id | role | status | depends on | gaps | files |
|----|------|--------|------------|------|-------|
| `chain:main-hc-axiom-relative` | main | conditional | - | `gap:G-main-hc`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, `gap:G-l3-v56-mt-identification`, `gap:G-l4-cm-abelian-hc`, +1 more | cut: 3, infra: 1, on-chain: 1 |
| `chain:unconditional-classical` | support | closed-modulo-cy3-citation | - | `gap:G-classical-mathlib-port` | cut: 2 |
| `chain:hcgap-l2-trivial-instances` | support | stable | `chain:main-hc-axiom-relative` | `gap:G-l2-cohomology-construction` | orphan: 3 |
| `chain:hcgap-l4-multifront-active` | active | exploratory | `chain:main-hc-axiom-relative` | `gap:G-hcgap-l4-multifront` | infra: 1, orphan: 5 |
| `chain:concrete-evii-toy` | support | closed-toy | `chain:main-hc-axiom-relative` | - | infra: 1 |
| `chain:historical-cone-audits` | infra | infra | `chain:main-hc-axiom-relative` | - | on-disk-unloaded: 2 |

## Gap Ledger

| gap | status | route owners | declarations | files |
|-----|--------|--------------|--------------|-------|
| `gap:G-main-hc` | conditional | `chain:main-hc-axiom-relative` | `HodgeReduction.hodgeConjectureReal_canonical`, `HodgeReduction.canonicalE7ShimuraTor` | cut: 2, infra: 1, on-chain: 1 |
| `gap:G-l1-e7-shimura-tor` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L1_G1_E7ShimuraTor_Inhabited`, `HodgeReduction.E7ShimuraTor` | cut: 1, infra: 3, orphan: 1 |
| `gap:G-l2-cohomology-construction` | open | `chain:hcgap-l2-trivial-instances`, `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L2_G1_VarietyCohomologyData_Constructed_NonToy`, `HodgeReduction.HCGapRegistry.L2_G2_E7CanonicalCohomology_MatchesPaper`, `HodgeReduction.SmoothProjectiveVariety.cohomology` | infra: 1, on-chain: 1, orphan: 4 |
| `gap:G-l3-v56-mt-identification` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.HCGapRegistry.L3_G1_V56_PureHodgeStructure_W3_HodgeDiamond`, `HodgeReduction.HCGapRegistry.L3_G2_V56_To_E7_Variety_Cohomology_Identification` | infra: 2, orphan: 3 |
| `gap:G-l4-cm-abelian-hc` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.hyp_HC_CM_Ab_real`, `HodgeReduction.HCGapRegistry.L4_G2_HC_For_CM_AbelianVariety` | cut: 1, infra: 3 |
| `gap:G-l4-mt-correspondence` | open | `chain:main-hc-axiom-relative` | `HodgeReduction.mt_correspondence_e7_witness_exists`, `HodgeReduction.HCGapRegistry.L4_G3_MT_Correspondence_E7_To_CMAbelian`, `HodgeReduction.HCGapRegistry.L34_FullPackage_For_E7Canonical` | cut: 2, infra: 1, orphan: 1 |
| `gap:G-classical-mathlib-port` | deferred | `chain:unconditional-classical` | `HodgeReduction.cy3_e7_nonexistence_paper_axiom` | cut: 1 |
| `gap:G-hcgap-l4-multifront` | active-open | `chain:hcgap-l4-multifront-active` | - | infra: 1, orphan: 9 |

## Automatic Route Labels

These labels are generated for debt files from imports, names, source text, and the audit route taxonomy.  They are the route map an agent should use before opening individual files.

| route label | state | files | dominant bucket | classes | latest |
|-------------|-------|------:|-----------------|---------|--------|
| `chain:main-hc-axiom-relative` | active/exploring | 352 | core-support | on-disk-unloaded: 79, orphan: 273 | 2026-05-21 22:37 |
| `gap:G-l1-e7-shimura-tor` | active/exploring | 276 | core-support | on-disk-unloaded: 52, orphan: 224 | 2026-05-21 22:37 |
| `gap:G-main-hc` | active/exploring | 276 | core-support | on-disk-unloaded: 53, orphan: 223 | 2026-05-21 22:37 |
| `chain:hcgap-l4-multifront-active` | active/exploring | 275 | core-support | on-disk-unloaded: 55, orphan: 220 | 2026-05-21 22:37 |
| `gap:G-hcgap-l4-multifront` | active/exploring | 275 | core-support | on-disk-unloaded: 55, orphan: 220 | 2026-05-21 22:37 |
| `gap:G-l2-cohomology-construction` | active/exploring | 233 | core-support | on-disk-unloaded: 66, orphan: 167 | 2026-05-21 22:37 |
| `gap:G-l4-mt-correspondence` | active/exploring | 131 | core-support | on-disk-unloaded: 28, orphan: 103 | 2026-05-21 22:37 |
| `gap:G-l4-cm-abelian-hc` | active/exploring | 103 | core-support | on-disk-unloaded: 30, orphan: 73 | 2026-05-21 22:37 |
| `gap:G-l3-v56-mt-identification` | active/exploring | 71 | core-support | on-disk-unloaded: 18, orphan: 53 | 2026-05-21 22:37 |
| `chain:unconditional-classical` | active/exploring | 19 | core-support | on-disk-unloaded: 12, orphan: 7 | 2026-05-21 22:37 |
| `chain:hcgap-l2-trivial-instances` | closed/support | 233 | core-support | on-disk-unloaded: 66, orphan: 167 | 2026-05-21 22:37 |
| `chain:concrete-evii-toy` | closed/support | 149 | core-support | on-disk-unloaded: 39, orphan: 110 | 2026-05-21 22:37 |
| `gap:G-classical-mathlib-port` | classified | 15 | core-support | on-disk-unloaded: 9, orphan: 6 | 2026-05-21 22:37 |
| `chain:historical-cone-audits` | classified | 14 | core-support | on-disk-unloaded: 5, orphan: 9 | 2026-05-21 22:37 |

## Branch Head State Summary

| state | heads | closure files |
|-------|------:|--------------:|
| active/exploring | 4 | 631 |

## Branch Work Queue

Branch heads are off-chain files that no other off-chain debt file imports.  Their closure follows real Lean imports downward.  This table is sorted by generated state, recency, and size so live, mixed, and blocked attempts are visible without opening the files first.

| head | state | closure | bucket | automatic route labels |
|------|-------|--------:|--------|------------------------|
| `HodgeReduction.lean` | active/exploring | 372 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, +6 more |
| `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` | active/exploring | 181 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/ConeAudits/R217_ConeAudit.lean` | active/exploring | 16 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, +5 more |
| `HodgeReduction/Concrete/EVII.lean` | active/exploring | 62 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +2 more |

## Component Triage

Components are connected by actual Lean imports.  Large components should be split by strengthening automatic route rules, renaming ambiguous files, or quarantining failed tracks.

| component | state | files | bucket | automatic route labels | anchors |
|-----------|-------|------:|--------|------------------------|---------|
| `C001` | active/exploring | 375 | core-support | `chain:concrete-evii-toy`, `chain:hcgap-l2-trivial-instances`, `chain:hcgap-l4-multifront-active`, `chain:historical-cone-audits`, `chain:main-hc-axiom-relative`, `chain:unconditional-classical`, `gap:G-classical-mathlib-port`, `gap:G-hcgap-l4-multifront`, `gap:G-l1-e7-shimura-tor`, `gap:G-l2-cohomology-construction`, +4 more | cut: 11, infra: 3, on-chain: 76 |

## Unowned Debt

Files with no automatic route label.  These are the safest next candidates for comment-only classification, naming cleanup, quarantine, or deletion after a compile check.

- `HodgeReduction/Infrastructure/Automorphic/Basic.lean` -- orphan, core-support, 2026-05-17
- `HodgeReduction/Infrastructure/Automorphic/BorelBottWeil.lean` -- orphan, core-support, 2026-05-17
- `HodgeReduction/Infrastructure/Automorphic/ModularForm.lean` -- on-disk-unloaded, core-support, 2026-05-17
- `HodgeReduction/Infrastructure/Cohomology/AlgebraicCycle.lean` -- orphan, core-support, 2026-05-17
- `HodgeReduction/Infrastructure/Cohomology/PicardGroup.lean` -- orphan, core-support, 2026-05-17

## Route Details

### `chain:main-hc-axiom-relative` -- Main Mumford--Tate-reduction HC chain

`OpenHypotheses` (R169 cohomology / algClasses bridge + R174a Deligne) composes with `MainTheorem` (R170 four-case main reduction + R171/R188 canonical headline) to reach `hodgeConjectureReal_canonical`.  Conditional on the single axiom `canonicalE7ShimuraTor`; not an unconditional proof of HC.

Entry declarations:
- `HodgeReduction.hodgeConjectureReal_canonical`
- `HodgeReduction.main_reduction_real`

Taxonomy files:
- `HodgeReduction/Types.lean` -- on-chain
- `HodgeReduction/ClassicalResults.lean` -- cut
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
- `HodgeReduction/ClassicalResults.lean` -- cut
- `HodgeReduction/MainTheorem.lean` -- cut

### `chain:hcgap-l2-trivial-instances` -- Layer-2 minimum attack: trivial-instance VarietyCohomologyData

R201 minimum-attack instances of `VarietyCohomologyData`: trivial point (dim 0), projective line (dim 1), elliptic curve (dim 1).  Provides the template that a future E_7 construction must follow.

Taxonomy files:
- `HodgeReduction/HCGapL2/TrivialPoint.lean` -- orphan
- `HodgeReduction/HCGapL2/ProjectiveLine.lean` -- orphan
- `HodgeReduction/HCGapL2/EllipticCurve.lean` -- orphan

### `chain:hcgap-l4-multifront-active` -- HCGapL4 multi-front attack waves (R420 -- R470)

5 parallel attack fronts on the L4 cohomology-profile + connectedness pipeline.  Per-wave audits R451 / R456 / R460 / R465 / R470 enumerate substantive theorems per round.  R470 announces 44 substantive theorems across 5 waves with 0 added axioms.

Taxonomy files:
- `HodgeReduction/HCGapL4/FrontA_DeligneH0SheafRealization.lean` -- orphan
- `HodgeReduction/HCGapL4/FrontB_BailyBorelConnectedness.lean` -- orphan
- `HodgeReduction/HCGapL4/FrontC_E7LowDegreeHodgeNumbers.lean` -- orphan
- `HodgeReduction/HCGapL4/FrontD_E7ToCMChowCorrespondence.lean` -- orphan
- `HodgeReduction/HCGapL4/FrontE_RealCarrierProfileMatching.lean` -- orphan
- `HodgeReduction/HCGapL4/R470_MultiFrontWave5Audit.lean` -- infra

### `chain:concrete-evii-toy` -- Concrete EVII sanity-check chain

`HC_for_Concrete_EVII` specialises the abstract closure `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` to a concrete `A_EVII := Polynomial ℚ` toy carrier.  Cone is `{propext, Classical.choice, Quot.sound}` (no project axioms) but the carrier is explicitly toy; per R201 mandate it is EXCLUDED from real-HC closure accounting.

Taxonomy files:
- `HodgeReduction/Concrete.lean` -- infra

### `chain:historical-cone-audits` -- Historical per-round cone audit drivers (R217 -- R470)

84 per-round `#print axioms` / `#check` driver scripts produced at the end of each attack round.  Each script is a standalone audit consuming a fixed subset of the active chain at its timestamp; none are imported by `HodgeReduction.lean`.  Moved out of the project root into `HodgeReduction/ConeAudits/` and registered as `infraFiles` so the chainAudit classifier records them as infra rather than orphan.

Taxonomy files:
- `HodgeReduction/ConeAudits/R217_ConeAudit.lean` -- on-disk-unloaded
- `HodgeReduction/ConeAudits/R467_R470_ConeAudit.lean` -- on-disk-unloaded

