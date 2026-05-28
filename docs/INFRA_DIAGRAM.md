# Hodge ChainAudit Infrastructure — Architecture Diagram

Mirrors the `abc-conjecture/lean4-formalization` chain-audit pipeline.
Produced at infra-parity round 2026-05-25 (after `lake env lean --run
HodgeReduction/Scripts/StatusEntry.lean` + post-processor smoke test
passed with `0 fail / 9609 warn / 12 axioms / all whitelisted`).

## 1. Before / after layout of `lean4-formalization/`

```mermaid
graph TB
    subgraph BEFORE["BEFORE (2026-05-21)"]
        direction TB
        B_root["lean4-formalization/"]
        B_lakefile["lakefile.lean<br/>only mathlib"]
        B_hodge["HodgeReduction.lean<br/>(bulk aggregator)"]
        B_hodgedir["HodgeReduction/<br/>Types, OpenHypotheses,<br/>MainTheorem, Strict,<br/>Infrastructure/, HCGapL2/,<br/>HCGapL4/, Concrete/, Research/"]
        B_orphans["R217..R470_ConeAudit.lean<br/>x83 LOOSE AT ROOT"]
        B_no_chainaudit[no chainAudit dep]
        B_no_scripts[no Scripts/]
        B_no_mainchain[no MainChain.lean]
        B_no_readme[no README.md]
        B_no_status[no chain-status/]
        B_no_docs[no docs/]
        B_root --> B_lakefile
        B_root --> B_hodge
        B_root --> B_hodgedir
        B_root --> B_orphans
        B_root --> B_no_chainaudit
        B_root --> B_no_scripts
        B_root --> B_no_mainchain
        B_root --> B_no_readme
        B_root --> B_no_status
        B_root --> B_no_docs
    end

    subgraph AFTER["AFTER (2026-05-25)"]
        direction TB
        A_root["lean4-formalization/"]
        A_lakefile["lakefile.lean<br/>+chainAudit path dep<br/>+lean_exe hodge-status<br/>+lean_exe hodge-check"]
        A_hodge["HodgeReduction.lean<br/>(unchanged aggregator)"]
        A_hodgedir["HodgeReduction/<br/>Types, OpenHypotheses,<br/>MainTheorem, Strict,<br/>HCGapRegistry,<br/>Infrastructure/, HCGapL2/,<br/>HCGapL4/, Concrete/, Research/"]
        A_mainchain["HodgeReduction/MainChain.lean<br/>ProjectConfig:<br/>7 endpoints, 9 openAxioms,<br/>87 infraFiles,<br/>8 researchGaps,<br/>6 researchChains"]
        A_scripts["HodgeReduction/Scripts/<br/>StatusEntry.lean<br/>CheckEntry.lean"]
        A_cones["HodgeReduction/ConeAudits/<br/>R217...R470 ConeAudit.lean<br/>x83 (moved from root)"]
        A_readme["README.md<br/>(layout + build + gap ledger)"]
        A_status["chain-status/<br/>raw.json + 13 .md reports"]
        A_docs["docs/<br/>INFRA_DIAGRAM.md (this file)"]
        A_root --> A_lakefile
        A_root --> A_hodge
        A_root --> A_hodgedir
        A_hodgedir --> A_mainchain
        A_hodgedir --> A_scripts
        A_hodgedir --> A_cones
        A_root --> A_readme
        A_root --> A_status
        A_root --> A_docs
    end

    BEFORE -.->|migration round 2026-05-25| AFTER
    style BEFORE fill:#fde2e2,stroke:#b91c1c
    style AFTER fill:#dcfce7,stroke:#16a34a
    style B_orphans fill:#fecaca,stroke:#b91c1c
    style B_no_chainaudit fill:#fecaca,stroke:#b91c1c
    style B_no_scripts fill:#fecaca,stroke:#b91c1c
    style B_no_mainchain fill:#fecaca,stroke:#b91c1c
    style B_no_readme fill:#fecaca,stroke:#b91c1c
    style B_no_status fill:#fecaca,stroke:#b91c1c
    style B_no_docs fill:#fecaca,stroke:#b91c1c
    style A_mainchain fill:#86efac,stroke:#15803d
    style A_scripts fill:#86efac,stroke:#15803d
    style A_cones fill:#86efac,stroke:#15803d
    style A_status fill:#86efac,stroke:#15803d
```

## 2. Lake dependency graph (shared chainAudit, isolated build dirs)

```mermaid
graph TB
    subgraph TOOLS["tools/chain-audit/  (shared package)"]
        ChainAudit_src["ChainAudit.lean<br/>Basic + Reflection + Classification<br/>+ Audit + Json + Status<br/>+ Postprocess/post_process.py"]
        ChainAudit_4_16_0[".lake/build-4.16.0/<br/>(Lean 4.16.0 artefacts)"]
        ChainAudit_4_30[".lake/build-4.30.0-rc2/<br/>(Lean 4.30 artefacts)"]
        ChainAudit_src --> ChainAudit_4_16_0
        ChainAudit_src --> ChainAudit_4_30
    end

    subgraph ABC["abc-conjecture/lean4-formalization/"]
        ABC_lakefile["lakefile.lean<br/>require chainAudit from path<br/>require mathlib v4.16.0"]
        ABC_mainchain["ABCReduction/MainChain.lean<br/>3+ endpoints, 15 openAxioms,<br/>8 infraFiles,<br/>10 researchGaps,<br/>8 researchChains"]
        ABC_build[".lake/build/<br/>(Hodge-independent)"]
        ABC_status["chain-status/<br/>14 reports"]
        ABC_lakefile --> ABC_mainchain
        ABC_mainchain --> ABC_build
        ABC_build --> ABC_status
    end

    subgraph HODGE["hodge-conjecture/lean4-formalization/  (NEW)"]
        HODGE_lakefile["lakefile.lean<br/>+ require chainAudit from path<br/>require mathlib v4.16.0"]
        HODGE_mainchain["HodgeReduction/MainChain.lean<br/>7 endpoints, 9 openAxioms,<br/>87 infraFiles,<br/>8 researchGaps,<br/>6 researchChains"]
        HODGE_build[".lake/build/<br/>(ABC-independent)"]
        HODGE_status["chain-status/<br/>14 reports (NEW)"]
        HODGE_lakefile --> HODGE_mainchain
        HODGE_mainchain --> HODGE_build
        HODGE_build --> HODGE_status
    end

    MATHLIB["mathlib v4.16.0<br/>(per-consumer .lake/packages/)"]
    ChainAudit_4_16_0 -. linked into .-> ABC_lakefile
    ChainAudit_4_16_0 -. linked into .-> HODGE_lakefile
    MATHLIB -.-> ABC_lakefile
    MATHLIB -.-> HODGE_lakefile

    style TOOLS fill:#fef9c3,stroke:#a16207
    style ChainAudit_4_16_0 fill:#fde68a,stroke:#a16207
    style ABC fill:#dbeafe,stroke:#1d4ed8
    style HODGE fill:#dcfce7,stroke:#15803d
    style HODGE_mainchain fill:#86efac,stroke:#15803d
    style HODGE_status fill:#86efac,stroke:#15803d
    style HODGE_lakefile fill:#86efac,stroke:#15803d
```

**Key invariant from the chainAudit package's `lakefile.lean`:**

```lean
def chainAuditBuildDir : System.FilePath :=
  System.FilePath.mk (".lake/build-" ++ Lean.versionString)
```

This isolates chainAudit's compiled artefacts per Lean version, so both
ABC (Lean 4.16.0) and Hodge (Lean 4.16.0) safely share one source
checkout under `tools/chain-audit/` without colliding artefacts.  Each
consumer keeps its own default `.lake/build/` for its main library
(ABCReduction / HodgeReduction).

## 3. Audit pipeline (StatusEntry / CheckEntry → chain-status/)

```mermaid
flowchart LR
    A["HodgeReduction/MainChain.lean<br/>ProjectConfig"]
    B["HodgeReduction/Scripts/StatusEntry.lean<br/>(def main: IO UInt32 :=<br/>  ChainAudit.Status.runAudit ...)"]
    C["lake env lean --run<br/>Scripts/StatusEntry.lean"]
    D["chain-status/raw.json<br/>(3.3 MB JSON dump)"]
    E["python tools/chain-audit/.../post_process.py<br/>--raw chain-status/raw.json --out chain-status"]
    F["chain-status/*.md<br/>13 generated markdown reports"]

    G["HodgeReduction/Scripts/CheckEntry.lean<br/>(def main: IO UInt32 :=<br/>  ChainAudit.Status.runCheck ...)"]
    H["lake env lean --run<br/>Scripts/CheckEntry.lean"]
    I{"exit code"}
    J["FAIL = 0 OK"]
    K["FAIL > 0 -- block PR"]

    A --> B
    A --> G
    B --> C --> D --> E --> F
    G --> H --> I
    I -->|0| J
    I -->|nonzero| K

    style A fill:#dbeafe,stroke:#1d4ed8
    style D fill:#fef9c3,stroke:#a16207
    style F fill:#dcfce7,stroke:#15803d
    style J fill:#86efac,stroke:#15803d
    style K fill:#fca5a5,stroke:#b91c1c
```

## 4. Audit cone of the headline endpoint

`#print axioms HodgeReduction.hodgeConjectureReal_canonical` is now
the audit invariant.  Measured today by the StatusEntry smoke run:

```mermaid
graph TB
    Top["theorem<br/>HodgeReduction.hodgeConjectureReal_canonical:<br/>VarietyHC canonicalE7ShimuraTor.cohomologyOfUnderlying<br/>            canonicalE7ShimuraTor.algClassesOfUnderlying"]

    subgraph KernelAxioms["3 kernel axioms (whitelisted)"]
        propext["propext"]
        choice["Classical.choice"]
        quot["Quot.sound"]
    end

    subgraph ProjectAxiom["1 project axiom (the gap container)"]
        canonical["HodgeReduction.canonicalE7ShimuraTor :<br/>E7ShimuraTor"]
    end

    subgraph CanonicalFields["E7ShimuraTor fields (~60),<br/>only 3 used by headline:"]
        F1["cohomologyOfUnderlying<br/>: VarietyCohomologyData"]
        F2["algClassesOfUnderlying<br/>: AlgebraicClassesData"]
        F3["mtCorrespondencePackage<br/>: ∃ A, IsCMAbelianVariety A ∧<br/>     VarietyHC A_coh A_alg ∧<br/>     ∀ p, MTCorrespondencePackageAt ..."]
        F_rest["57 paper-hypothesis<br/>fields dead in headline"]
    end

    subgraph HCGapLayers["HCGapRegistry layer breakdown<br/>(documents the gap, not in headline cone)"]
        L1["L1: E7 Shimura toroidal compactification<br/>AMRT 1975 / Baily--Borel 1966"]
        L2["L2: VarietyCohomologyData<br/>(singular cohomology + Hodge theorem)"]
        L3["L3: V_56 to H3 identification<br/>Matsushima / Vogan--Zuckerman 1984"]
        L4_G2["L4-G2: HC for CM abelian (Deligne 1982)"]
        L4_G3["L4-G3: MT correspondence package"]
    end

    Top --> propext
    Top --> choice
    Top --> quot
    Top --> canonical
    canonical --> F1
    canonical --> F2
    canonical --> F3
    canonical -.-> F_rest
    F1 -.documents.-> L2
    F2 -.documents.-> L4_G3
    F3 -.documents.-> L4_G2
    F3 -.documents.-> L4_G3
    canonical -.documents.-> L1
    canonical -.documents.-> L3

    style Top fill:#86efac,stroke:#15803d,stroke-width:3px
    style canonical fill:#fde68a,stroke:#a16207,stroke-width:2px
    style KernelAxioms fill:#dbeafe,stroke:#1d4ed8
    style ProjectAxiom fill:#fef9c3,stroke:#a16207
    style CanonicalFields fill:#fff7ed,stroke:#c2410c
    style HCGapLayers fill:#f3e8ff,stroke:#7e22ce
    style F_rest fill:#e5e7eb,stroke:#6b7280
```

## 5. Endpoint axiom summary (from `chain-status/axioms.md` today)

```mermaid
graph LR
    subgraph Headline["Headline (4 axioms)"]
        E0["hodgeConjectureReal_canonical"]
        E0 --> A0_1["propext"]
        E0 --> A0_2["Classical.choice"]
        E0 --> A0_3["Quot.sound"]
        E0 --> A0_4["canonicalE7ShimuraTor"]
    end

    subgraph MainRed["main_reduction_real (10 axioms)"]
        E1["main_reduction_real"]
        E1 --> A1_1["propext + Classical + Quot"]
        E1 --> A1_2["SmoothProjectiveVariety.cohomology"]
        E1 --> A1_3["SmoothProjectiveVariety.algClasses"]
        E1 --> A1_4["hc_real_classical_cartan"]
        E1 --> A1_5["hc_real_e6_case"]
        E1 --> A1_6["hc_real_cy3_reducible"]
        E1 --> A1_7["hyp_HC_CM_Ab_real"]
        E1 --> A1_8["mt_correspondence_e7_witness_exists"]
    end

    subgraph Classical["Classical unconditional"]
        E2["thm_Meyer (0 axioms)"]
        E3["thm_G2F4 (3 kernel)"]
        E4["thm_E8_vacuous (3 kernel)"]
        E5["thm_cy3_e7_nonexistence (3 kernel + cy3_axiom)"]
        E6["thm_subcase3b_vacuous (0 axioms)"]
    end

    style Headline fill:#dcfce7,stroke:#15803d
    style MainRed fill:#fef9c3,stroke:#a16207
    style Classical fill:#dbeafe,stroke:#1d4ed8
    style E0 fill:#86efac,stroke:#15803d,stroke-width:3px
    style A0_4 fill:#fde68a,stroke:#a16207,stroke-width:2px
```

## 6. What this round fixed

| Issue | Before | After |
|---|---|---|
| Shared chainAudit dependency | absent | `require chainAudit from "../../../tools/chain-audit"` in `lakefile.lean` |
| `hodge-status` executable | absent | `lean_exe «hodge-status»` registered |
| `hodge-check` executable | absent | `lean_exe «hodge-check»` registered |
| Audit entrypoint | absent | `HodgeReduction/MainChain.lean` (7 endpoints, 9 axioms, 87 infra files, 8 gaps, 6 chains) |
| Status driver script | absent | `HodgeReduction/Scripts/StatusEntry.lean` (runs `runAudit`) |
| Check driver script | absent | `HodgeReduction/Scripts/CheckEntry.lean` (runs `runCheck`) |
| Project README | absent | `README.md` (layout + build + gap ledger entry points) |
| Architecture docs | absent | `docs/INFRA_DIAGRAM.md` (this file) |
| Stale package name in manifest | `"HodgePhantom"` | `"HodgeReduction"` (auto-fixed by `lake update`) |
| Loose root-level `R*_ConeAudit.lean` clutter | 83 files at project root | moved to `HodgeReduction/ConeAudits/` and listed as `infraFiles` |
| `chain-status/*` reports | absent | `raw.json` + 13 markdown reports generated, 0 hard failures |

## 7. Reproduction checklist

```powershell
cd e:\Dev\OpenExecution\research-line\academic-papers\millennium-problems\hodge-conjecture\lean4-formalization

# resolve deps + fetch mathlib cache (one-time per fresh checkout)
lake update                 # auto-runs `lake exe cache get` via mathlib post-update hook
# OR explicitly:
# lake exe cache get

# build the project (full project build is heavy; below is the fast path)
lake build HodgeReduction.MainChain   # builds the single audit-entry module
# OR for a full rebuild:
# lake build

# run the audit (writes chain-status/raw.json)
lake env lean --run HodgeReduction/Scripts/StatusEntry.lean

# post-process JSON to markdown reports (writes 13 .md files into chain-status/)
python ../../../tools/chain-audit/ChainAudit/Postprocess/post_process.py `
  --raw chain-status/raw.json --out chain-status

# CI gate: invariant check (exit code 1 on any FAIL finding)
lake env lean --run HodgeReduction/Scripts/CheckEntry.lean
```

Expected output of `Scripts/CheckEntry.lean` today (2026-05-25):

```
[HodgeReduction] invariant check
  total findings: 9609
  failures: 0
  warnings: 9609
```

The warnings are dominated by W5 (Prop-valued `def`-as-status markers
in HCGapL4 active attack waves) and W6 (vacuous `True`-conclusion
status theorems in the same waves) — both expected for active
research files and not affecting the headline cone.
