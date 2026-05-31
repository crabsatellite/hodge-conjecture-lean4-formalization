# HodgeReduction -- Lean4 Formalisation Toward the Full Hodge Conjecture

Status: **full-HC target realigned (2026-05-30)**. The final project
target is now explicitly recorded as `HodgeReduction.FullHodgeConjectureReal`,
i.e. HC-real for every smooth projective complex variety. The current
canonical `E_7` theorem remains a conditional milestone, not the final
theorem.

## Purpose

Formalise a route toward the full Hodge Conjecture and isolate every
load-bearing gap in a typed audit trail. The final target is

```
HodgeReduction.FullHodgeConjectureReal :
  Prop  -- forall X : SmoothProjectiveVariety Complex, HodgeConjectureReal X
```

The current main milestone is

```
HodgeReduction.hodgeConjectureReal_canonical :
  VarietyHC canonicalTargetCohomologyData canonicalTargetAlgClassesData
```

a per-codimension HC-real statement for the canonical AMRT toroidal
compactification of an `E_{7(-25)}`-Hermitian-symmetric-domain
arithmetic quotient. This milestone is **conditional** and does not by
itself prove the full Hodge Conjecture.

The formalisation matches the canonical Millennium-style infrastructure
shared with `abc-conjecture/lean4-formalization` (and the other
sibling problems): typed opaque carriers + Cat-2 classical inputs +
Cat-3 paper-novel atoms + chainAudit-driven gap ledger discipline.

## Layout

| File / Directory | Role | Status |
|---|---|---|
| [`HodgeReduction.lean`](HodgeReduction.lean) | Top-level re-export aggregator (also pulls in HCGapL4 active fronts) | bulk import surface |
| [`HodgeReduction/MainChain.lean`](HodgeReduction/MainChain.lean) | Audit entrypoint: `ProjectConfig` (endpoints, openAxioms, infraFiles, researchGaps, researchChains) | **seeded R-infra** |
| [`HodgeReduction/Scripts/StatusEntry.lean`](HodgeReduction/Scripts/StatusEntry.lean) | `runAudit` driver -> `chain-status/raw.json` | seeded |
| [`HodgeReduction/Scripts/CheckEntry.lean`](HodgeReduction/Scripts/CheckEntry.lean) | `runCheck` driver -> invariant exit code | seeded |
| [`HodgeReduction/Types.lean`](HodgeReduction/Types.lean) | Opaque carriers (scheme, variety, divisor, Mumford--Tate group, Hodge number, ...) | mature |
| [`HodgeReduction/ClassicalResults.lean`](HodgeReduction/ClassicalResults.lean) | Classical theorems (Meyer / Hasse--Minkowski, Kostant `G_2 / F_4`, SV1 `E_8`, Deligne absolute Hodge, `cy3_e7_nonexistence_paper_axiom`) | mature |
| [`HodgeReduction/OpenHypotheses.lean`](HodgeReduction/OpenHypotheses.lean) | Paper hypotheses + structural carriers (`E7ShimuraTor`, `canonicalE7ShimuraTor`, `hyp_HC_CM_Ab_real`, R169 cohomology / algClasses bridges) | mature, 204 axioms |
| [`HodgeReduction/MainTheorem.lean`](HodgeReduction/MainTheorem.lean) | R170 four-case main reduction + R171/R188 headline `hodgeConjectureReal_canonical` + the four paper-unconditional theorems | mature |
| [`HodgeReduction/FullHodgeGoal.lean`](HodgeReduction/FullHodgeGoal.lean) | Final full-HC target, pointwise codimension equivalent, and explicit scope-coverage blocker | target ledger |
| [`HodgeReduction/PaperInventory.lean`](HodgeReduction/PaperInventory.lean) | Canonical master-tex import ledger; non-master tex files are archive/background unless promoted into the master paper | import ledger |
| [`HodgeReduction/HCGapRegistry.lean`](HodgeReduction/HCGapRegistry.lean) | Layer-1/2/3/4 marker registry — every active gap in the headline cone | seeded |
| [`HodgeReduction/Strict.lean`](HodgeReduction/Strict.lean) | Cat-1+2-only strict-discipline restructure (P17+); explicit-content Cat-2 axioms + derived theorems + honest conditional structure | exploratory |
| [`HodgeReduction/Concrete/`](HodgeReduction/Concrete) | Concrete EVII toy instance (`A_EVII := Polynomial ℚ`); excluded from real-HC accounting per R201 mandate | sanity-check |
| [`HodgeReduction/Infrastructure/`](HodgeReduction/Infrastructure) | Mathlib-port-pending machinery (Cohomology, Shimura, HodgeStructure, AbelianVariety, Automorphic, LieAlgebra, AlgebraicGeometry) | active |
| [`HodgeReduction/HCGapL2/`](HodgeReduction/HCGapL2) | Layer-2 minimum-attack instances (TrivialPoint, ProjectiveLine, EllipticCurve) | stable |
| [`HodgeReduction/HCGapL4/`](HodgeReduction/HCGapL4) | Layer-4 multi-front attack waves (FrontA--FrontE, R420--R470 wave audits) | active-exploratory |
| [`HodgeReduction/ConeAudits/`](HodgeReduction/ConeAudits) | 83 per-round `#print axioms` driver scripts (R217--R470); audit-only, not imported by `HodgeReduction.lean` | infra |
| [`HodgeReduction/Research/`](HodgeReduction/Research) | Research notes (HC gap registry detailed layer discussion) | docs |
| [`docs/INFRA_DIAGRAM.md`](docs/INFRA_DIAGRAM.md) | Mermaid architecture diagrams: before/after layout, shared chainAudit / isolated build dirs, audit pipeline, headline cone, endpoint axiom map | docs |
| [`chain-status/`](chain-status) | Generated audit reports (`raw.json` + 13 markdown reports); regenerate via `Scripts/StatusEntry.lean` + post-processor | generated |

## Build

```powershell
cd e:\Dev\OpenExecution\research-line\academic-papers\millennium-problems\hodge-conjecture\lean4-formalization
lake exe cache get      # MANDATORY before lake build (memory feedback_lean_cache_only)
lake build
```

The shared `chainAudit` package at `../../../tools/chain-audit` writes
its compiled artefacts to a Lean-version-isolated build directory
(`.lake/build-<Lean.versionString>/`).  Both this project (Hodge) and
the sibling `abc-conjecture/lean4-formalization` (ABC) consume the
same checkout but stay independent of each other's main `.lake/build/`.

## Audit pipeline

After `lake build`:

```powershell
lake env lean --run HodgeReduction/Scripts/StatusEntry.lean
lake env lean --run HodgeReduction/Scripts/CheckEntry.lean
python ../../../tools/chain-audit/ChainAudit/Postprocess/post_process.py `
  --raw chain-status/raw.json --out chain-status
```

Generated `chain-status/*` artefacts:

| File | Purpose |
|---|---|
| `raw.json` | Machine-readable audit dump |
| `route-index.md` | Decision-first route / gap / branch index |
| `research-map.md` | Main / support / active / dead route graph |
| `graph.md` | Mermaid graph from kernel / cuts to endpoints |
| `onchain.md` | On-chain and cut file list |
| `offchain.md` | Quarantine / infra / orphan / on-disk-unloaded split |
| `orphans.md` | Files not wired into the audited chain |
| `orphan-debt.md` | Orphan components and branch heads |
| `cuts.md` | Every endpoint-reached axiom and whitelist status |
| `axioms.md` | Per-endpoint axiom ledger |
| `trick-audit.md` | Self-assumption / vacuous theorem / Prop-def audit |
| `underscore-audit.md` | `_`-prefixed binder review debt (`W7`) |
| `import-audit.md` | `W2` / `W4` import-prune candidates |
| `findings.md` | All `FAIL` / `WARN` findings grouped by rule |

## Gap ledger entry-points (load-bearing, status 2026-05-30)

1. **`G-full-hc`** — `final-open`.  Final target
   `FullHodgeConjectureReal`: `forall X : SmoothProjectiveVariety Complex,
   HodgeConjectureReal X`. Current work must feed this theorem, not just a
   canonical or E7-local theorem.

2. **`G-master-paper-import`** -- `in-progress`.  Canonical import of
   `../contributions/hodge-conjecture-master-proof.tex` into the Lean folder.
   Attack maps, literature surveys, and round-contribution tex files are
   archive/background unless a statement is promoted into the master tex.

3. **`G-main-hc`** — `conditional milestone`.  Headline
   `hodgeConjectureReal_canonical` proves the canonical `E_7` target modulo
   registered cuts. It is a route milestone toward full HC, not final closure.

4. **`G-l1-e7-shimura-tor`** — `open`.  AMRT 1975 / Baily--Borel 1966
   construction of `S_Γ^tor` as a `SmoothProjectiveVariety ℂ`.

5. **`G-l2-cohomology-construction`** — `open`.  `VarietyCohomologyData`
   constructed from a non-toy underlying variety; Mathlib singular
   cohomology + Hodge theorem dependency.

6. **`G-l3-v56-mt-identification`** — `open`.  `V_56` ↔ `H^3(S_Γ^tor, ℚ)`
   Hodge-structure identification via Matsushima / Borel--Wallach /
   Vogan--Zuckerman 1984.  The `V_56` side already kernel-pure
   (`V56Instance.instPureHodgeStructure_V56`).

7. **`G-l4-cm-abelian-hc`** — `open`.  Deligne 1982 HC for CM abelian
   varieties (the `hyp_HC_CM_Ab_real` axiom).

8. **`G-l4-mt-correspondence`** — `open`.  Per-codimension MT
   correspondence package; currently bundled in
   `canonicalE7ShimuraTor.mtCorrespondencePackage`.

9. **`G-classical-mathlib-port`** — `deferred`.  `cy3_e7_nonexistence_paper_axiom`
   (paper §4 Stages A--D + Springer disc + FTS ω-pairing).

10. **`G-hcgap-l4-multifront`** — `active-open`.  Active R420--R470 attack
   waves on the L4 cohomology-profile + connectedness pipeline.

See [`HodgeReduction/MainChain.lean`](HodgeReduction/MainChain.lean)
for the complete metadata record + per-gap file list + priority order
+ attack plans for each active chain.

## Layout migration notes (2026-05-25)

* **chainAudit integration (this round).**  `lakefile.lean` now
  requires the shared `tools/chain-audit` package; two new
  executables (`hodge-status`, `hodge-check`) drive the report
  pipeline.  The audit entrypoint is the new
  `HodgeReduction/MainChain.lean` (not the root aggregator
  `HodgeReduction.lean`, which intentionally re-exports many
  exploratory front-attack files).
* **Cone audit relocation (this round).**  83 per-round
  `R*_ConeAudit.lean` scripts have been moved from the project root
  into `HodgeReduction/ConeAudits/`.  They are not imported by
  `HodgeReduction.lean`; chainAudit classifies them as `infra` via
  the `infraFiles` registry in `MainChain.config`.

## Key references

* Hodge, W. V. D. *The Theory and Applications of Harmonic Integrals*,
  CUP, 1941.  (Pure Hodge structure on cohomology of compact Kähler
  manifolds.)
* Lefschetz, S. *L'Analysis Situs et la Géométrie Algébrique*,
  Gauthier--Villars, 1924.  (`(1,1)`-theorem; cycle class map.)
* Deligne, P., Milne, J. S., Ogus, A., Shih, K.-Y. *Hodge Cycles,
  Motives, and Shimura Varieties*, LNM 900, Springer, 1982.  (Absolute
  Hodge for abelian varieties.)
* Ash, A., Mumford, D., Rapoport, M., Tai, Y.-S. *Smooth
  Compactifications of Locally Symmetric Varieties*, Math. Sci. Press,
  1975.  (AMRT toroidal compactification.)
* Baily, W. L., Borel, A. *Compactification of Arithmetic Quotients of
  Bounded Symmetric Domains*, Ann. of Math. 84 (1966), 442--528.
* Matsushima, Y., Murakami, S. *On Vector Bundle Valued Harmonic Forms
  and Automorphic Forms on Symmetric Riemannian Manifolds*, Ann. of
  Math. 78 (1963).
* Vogan, D. A., Zuckerman, G. J. *Unitary Representations with
  Non-zero Cohomology*, Compositio Math. 53 (1984), 51--90.
* Borel, A., Wallach, N. *Continuous Cohomology, Discrete Subgroups,
  and Representations of Reductive Groups*, AMS, 2000 (2nd ed.).
* Li, A. C. *A Mumford--Tate Reduction of the Hodge Conjecture*,
  manuscript, 2026.  (Master proof; this formalisation.)
