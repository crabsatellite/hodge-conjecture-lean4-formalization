# E7ShimuraTor structure split plan (R202)

**Status**: PLANNING ONLY — no refactoring done in R202.
**Goal**: make the **real proof-cone gap** transparent by separating
the 3 active fields from the ~57 inactive paper-archive fields, without
deleting the archive (so the paper ↔ Lean mirror is preserved).

## Current state (R200 → R201 → R202)

`E7ShimuraTor` ([OpenHypotheses.lean:698](../OpenHypotheses.lean#L698))
is a 60-field structure:

| Category | # fields | Used by `hodgeConjectureReal_canonical`? |
|---|---|---|
| underlying / cohomology / algClasses / mtCorrespondencePackage | 4 | **YES** (3 of 4 directly unpacked by the proof; `underlying` indirect) |
| R187 `mtE7FactorAtWeight3` + `inKnownE7ScopeUnderlying` | 2 | no |
| R124 pilot fields (Schwarz / Borel-Hirzebruch / Chern-subring) | 3 | no |
| R125 fields (Matsushima / BB / Mumford-canonical / CDK / BBT-BKT / PST / Kudla-Millson / Bruinier-Funke / Howard-Madapusi-Pera / Exceptional / VZ / BW-Hecke / Adams / GW / Archimedean / BKT-Hecke / BBT-period / Alg-locus) | 17 | no |
| R160 P11 cluster (4 propositions + 4 witnesses + 1 bridge) | 9 | no |
| R161 P16 cluster (5 propositions + 5 witnesses + 1 bridge) | 11 | no |
| R162 P14 cluster (7 propositions + 7 witnesses + 1 bridge) | 15 | no |
| **TOTAL ACTIVE** | **3 (+1 indirect)** | |
| **TOTAL INACTIVE / PAPER ARCHIVE** | **~57** | |

## Proposed split

### `E7ShimuraTorCore` (new structure — only active fields)

```lean
/-- Minimal active core: the 3 fields the headline proof actually
unpacks, plus `underlying` (required for the cohomology dependent
type). -/
structure E7ShimuraTorCore : Type 1 where
  underlying : SmoothProjectiveVariety ℂ
  cohomologyOfUnderlying : Infrastructure.HodgeStructure.VarietyCohomologyData
  algClassesOfUnderlying :
    Infrastructure.HodgeStructure.AlgebraicClassesData cohomologyOfUnderlying
  mtCorrespondencePackage :
    ∃ (A : SmoothProjectiveVariety ℂ)
      (A_cohData : Infrastructure.HodgeStructure.VarietyCohomologyData)
      (A_algData : Infrastructure.HodgeStructure.AlgebraicClassesData A_cohData),
      IsCMAbelianVariety A ∧
      Infrastructure.HodgeStructure.VarietyHC A_cohData A_algData ∧
      ∀ p : ℕ,
        Infrastructure.HodgeStructure.MTCorrespondencePackageAt
          A_cohData cohomologyOfUnderlying
          A_algData algClassesOfUnderlying p
```

### `E7ShimuraTorPaperArchive` (new structure — inactive ledger fields)

```lean
/-- Paper-hypothesis archive: the 56 inactive fields (R124/R125/R160/R161/R162
clusters) that preserve the paper ↔ Lean correspondence. NOT consumed by
the headline proof. Retained as a passive ledger; future rounds may
re-activate individual fields if the paper structure changes. -/
structure E7ShimuraTorPaperArchive (core : E7ShimuraTorCore) : Type 1 where
  mtE7FactorAtWeight3 :
    hasSimpleFactor (MumfordTateGroupDerived core.underlying 3) E7_neg25
  inKnownE7ScopeUnderlying : InKnownE7Scope core.underlying
  -- R124 pilot fields ...
  -- R125 fields ...
  -- R160 P11 cluster ...
  -- R161 P16 cluster ...
  -- R162 P14 cluster ...
  -- (full list per current E7ShimuraTor; ~56 fields total)
```

### `E7ShimuraTor` (refactored — composition of Core + Archive)

```lean
/-- Original `E7ShimuraTor` reconstructed as the composition. The
existing axiom `canonicalE7ShimuraTor : E7ShimuraTor` decomposes into
`canonicalE7ShimuraTorCore : E7ShimuraTorCore` (which alone is in the
headline cone) + `canonicalE7ShimuraTorPaperArchive` (paper ledger). -/
structure E7ShimuraTor : Type 1 where
  core : E7ShimuraTorCore
  archive : E7ShimuraTorPaperArchive core
```

with auto-generated projections `E7ShimuraTor.core.underlying` etc.

## Migration plan (if executed in a future round)

1. **R-N+1**: define `E7ShimuraTorCore` and `E7ShimuraTorPaperArchive`
   as new structures next to the current `E7ShimuraTor`, with parallel
   axioms `canonicalE7ShimuraTorCore`, `canonicalE7ShimuraTorPaperArchive`.
   Both built from `canonicalE7ShimuraTor` via projections — no new
   axiom-content introduced.
2. **R-N+2**: rewrite `hodgeConjectureReal_canonical` to reference
   `canonicalE7ShimuraTorCore` directly. Verify the cone collapses to
   `{propext, Classical.choice, canonicalE7ShimuraTorCore, Quot.sound}`
   (replacing `canonicalE7ShimuraTor`).
3. **R-N+3**: deprecate `canonicalE7ShimuraTor` (the old axiom). The
   paper ledger is preserved via `canonicalE7ShimuraTorPaperArchive`
   (an axiom of the smaller bundle), making explicit that ledger
   content does not bear on the headline.
4. **R-N+4** (optional): split `E7ShimuraTorCore` further if a future
   minimum-attack round closes one of its 4 fields with kernel-only
   content (e.g., constructing `algClassesOfUnderlying` from a real
   Mathlib cycle class map).

## Why R202 doesn't execute the split

The split is a **clarity refactor**, not a gap-closure step. It does
not reduce the headline cone (still 1 project-axiom, just renamed).
The user's R201–R202 mandate is to push **real gap closure** at L2; the
split is a parallel hygiene task. Deferring the split until L2 has
multiple closed instances (currently: `Spec ℂ` + `ℙ¹`) avoids the
churn of refactoring while infrastructure is still in active flux.

**Trigger for executing the split**: when a third concrete
`VarietyCohomologyData` + `AlgebraicClassesData` + `VarietyHC` triple
is closed (e.g., for `ℙ²` or for an elliptic curve), it becomes worth
formalising the split so future construction patterns route through
`E7ShimuraTorCore` directly, not via the 60-field bundle.

## What R202 DOES do (closure summary)

* `pureHodgeStructure_ℚ_Tate2 : PureHodgeStructure ℚ 2` — Tate-Hodge
  weight 2 instance on `ℚ`, kernel-pure.
* `VarietyCohomologyData_projectiveLine` — internal ℙ¹ cohomology
  model (H^0 = ℚ, H^2 = ℚ, others = PUnit; Hodge structures wired).
* `AlgebraicClassesData_projectiveLine` — `⊤` at codim 0,1; `⊥` at
  codim ≥ 2. NOT the `algClasses := hodgeClasses` trick.
* `VarietyHC_projectiveLine`, `VarietyHCAt_projectiveLine_codim0`,
  `VarietyHCAt_projectiveLine_codim1`,
  `VarietyHCAt_projectiveLine_codim_high` — full + per-codim closures.
* Internal-model disclosure markers (`L1_G_ProjectiveLine_RealVariety`,
  `L2_G_ProjectiveLine_RealCohomology`, etc.) — Prop-level Todo for
  the Mathlib-AG-backed realisation of `ℙ¹_ℂ`.

All 11 new declarations verified at `{propext, Classical.choice, Quot.sound}`
or smaller (the degree-support theorem depends only on `propext`).

## Aggregated kernel-pure variety-cohomology / HC infrastructure

After R201 + R202 the kernel-pure variety-cohomology library contains:

| object | dim | H-degrees populated | codims with VarietyHC |
|---|---|---|---|
| `Spec ℂ` (R201 `TrivialPoint`) | 0 | 0 | 0 |
| `ℙ¹` (R202 `ProjectiveLine`) | 1 | 0, 2 | 0, 1 |

Next-target candidates (R203+): `ℙ²` (dim 2, H-degrees 0, 2, 4),
`Spec(k_1 ⊔ k_2)` (disjoint union of points), elliptic curve internal
model (dim 1, H^0 = H^2 = ℚ, H^1 = ℚ² with non-trivial Hodge
structure splitting H^{1,0} ⊕ H^{0,1}).
