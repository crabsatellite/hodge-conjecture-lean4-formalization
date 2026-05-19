# HC Gap Registry (R201)

**Purpose**: machine-checkable, layer-classified ledger of every gap
*actually load-bearing on `hodgeConjectureReal_canonical`*. Replaces the
historical "204 axiom paper-hypothesis ledger" view with the honest
"active proof cone" view.

**Invariant** (verified by `#print axioms`):

```
HodgeReduction.hodgeConjectureReal_canonical depends on axioms:
  [propext, Classical.choice, HodgeReduction.canonicalE7ShimuraTor, Quot.sound]
```

The only project-specific axiom in the cone is `canonicalE7ShimuraTor :
E7ShimuraTor`. This is the **gap container**, NOT a closed theorem.
`E7ShimuraTor` is a `structure` with ~60 fields; the headline proof
unpacks **only** three of them. The remaining 57 fields are dead in
the active cone (paper-hypothesis ledger from R124/R125/R160/R161/R162).

The concrete EVII chain (`HC_for_Concrete_EVII`, axiom-set
`{propext, Classical.choice, Quot.sound}`) uses the toy carrier
`A_EVII := Polynomial ℚ`. It is **explicitly EXCLUDED** from "real HC
closure" accounting per the R201 mandate.

## Active fields of `E7ShimuraTor` used by `hodgeConjectureReal_canonical`

Source: [HodgeReduction/MainTheorem.lean:323-332](../MainTheorem.lean#L323-L332).

```
theorem hodgeConjectureReal_canonical :
    Infrastructure.HodgeStructure.VarietyHC
      canonicalE7ShimuraTor.cohomologyOfUnderlying
      canonicalE7ShimuraTor.algClassesOfUnderlying := by
  intro p
  obtain ⟨_A, _A_cohData, _A_algData, _hA_CM, h_HC_A, h_pkg⟩ :=
    canonicalE7ShimuraTor.mtCorrespondencePackage
  exact Infrastructure.HodgeStructure.varietyHCAt_of_correspondence
    (h_pkg p) (h_HC_A p)
```

Fields referenced:
1. `cohomologyOfUnderlying : VarietyCohomologyData`
2. `algClassesOfUnderlying : AlgebraicClassesData cohomologyOfUnderlying`
3. `mtCorrespondencePackage : ∃ A A_coh A_alg, IsCMAbelianVariety A ∧
   VarietyHC A_coh A_alg ∧ ∀ p, MTCorrespondencePackageAt A_coh ... p`

The first field implicitly carries `underlying : SmoothProjectiveVariety ℂ`
via the cohomology-data type signature on the variety, but the proof
does NOT pattern-match on `underlying` directly.

## Layer classification of E7ShimuraTor fields

### Layer 1 — object existence / true E₇ Shimura variety construction

| Field | Lean type | File:line | Used by main proof? |
|---|---|---|---|
| `underlying` | `SmoothProjectiveVariety ℂ` | OpenHypotheses.lean:702 | indirect (via cohomology) |

Sub-gaps:
- `AbstractScheme ℂ` inhabitation (Types.lean:89; currently 3 opaque Prop fields, trivially inhabitable)
- Smoothness / projectivity / connectedness predicates with content
- `dim`, `hodgeNumber`, `mumfordTateGroup` etc. (~10 ℕ/Prop fields on SmoothProjectiveVariety)
- **The real gap**: a true geometric construction of an `E₇₍₋₂₅₎`-type Shimura toroidal compactification `S_Γ^tor` à la AMRT 1975 / Baily–Borel 1966. Requires Mathlib infrastructure for: arithmetic groups, Hermitian symmetric domains, toroidal compactifications.

### Layer 2 — cohomology / Hodge structure / cycle class infrastructure

| Field | Lean type | File:line | Used by main proof? |
|---|---|---|---|
| `cohomologyOfUnderlying` | `VarietyCohomologyData` | OpenHypotheses.lean:718 | **YES** |

Sub-gaps inside `VarietyCohomologyData` (defined at VarietyCohomology.lean:69):
- `H : ℕ → Type` — actual rational cohomology spaces (singular cohomology)
- `addCommGroup, module, finite` — vector space structure (Mathlib-derivable once `H` is given)
- `hodgeStructure : ∀ k, PureHodgeStructure (H k) k` — Hodge decomposition

**Existing infrastructure**:
- `PureHodgeStructure ℚ 0` instance (Basic.lean:1662) — kernel-pure
- `PureHodgeStructure V_56 3` instance (V56Instance.lean:261) — kernel-pure
  with concrete Hodge numbers (1, 27, 27, 1) for the 56-dim minuscule E₇ rep

**Real gap**: lifting from individual-piece Hodge structures to the
full `VarietyCohomologyData` for `S_Γ^tor`. Requires Mathlib-level
singular cohomology + Hodge theory + identification of `H^k(S_Γ^tor, ℚ)`
with V_56-representation theory of E₇ at the relevant degrees.

### Layer 3 — E₇ representation / Mumford-Tate / Freudenthal identification

| Field | Lean type | File:line | Used by main proof? |
|---|---|---|---|
| `mtE7FactorAtWeight3` | `hasSimpleFactor (MumfordTateGroupDerived underlying 3) E7_neg25` | OpenHypotheses.lean:708 | no |
| `inKnownE7ScopeUnderlying` | `InKnownE7Scope underlying` | OpenHypotheses.lean:714 | no |

The Layer 3 content (V_56, E₇ Lie group, MT identification) leaks into
the `mtCorrespondencePackage` existential below (Layer 4) — it's where
the V_56 → CM-Abelian-variety correspondence is implicitly used.

**Existing infrastructure**: `V56`, `V56Basis`, `J3OInnerProduct`,
`V56HodgeRank`, `V56HodgeDecomp` modules — all kernel-pure (no project
axioms).

**Real gap**: connecting V_56 as a representation of E₇ to the actual
rational cohomology of `S_Γ^tor` at weight 3.

### Layer 4 — algebraic correspondence / CM / Hodge class algebraicity

| Field | Lean type | File:line | Used by main proof? |
|---|---|---|---|
| `algClassesOfUnderlying` | `AlgebraicClassesData cohomologyOfUnderlying` | OpenHypotheses.lean:722 | **YES** |
| `mtCorrespondencePackage` | (existential, see source) | OpenHypotheses.lean:736 | **YES** |

Sub-gaps inside `mtCorrespondencePackage`:
- `A : SmoothProjectiveVariety ℂ` — the canonical CM abelian variety `A_Γ`
- `A_cohData, A_algData` — its cohomology + algebraic-classes bundles
- `IsCMAbelianVariety A` — Deligne–Milne 1982 CM Hodge structure data
- `VarietyHC A_cohData A_algData` — **HC for the CM abelian variety A** (Deligne 1982)
- `∀ p, MTCorrespondencePackageAt ...` — per-codimension correspondence morphism
  - inside: `HodgeStructureMorphism (H_A) (H_target) (2p)`
  - inside: `ℚ`-linear `ψ : algClasses(A) → algClasses(target)` with commuting square
  - inside: Hodge-class surjectivity bound

**Real gap**: this is the biggest single Layer 4 hole. Closing it
requires:
- Mathlib HC for CM abelian varieties (Deligne 1982 *Hodge Cycles on Abelian Varieties*)
- The V_56 → A_Γ explicit correspondence construction (paper §6)
- Hodge-class transfer via the correspondence morphism

### Ledger-only / inactive fields (NOT in proof cone)

57 fields from R124/R125/R160/R161/R162. All bundled as paper-hypothesis
predicates (Schwarz, Borel–Hirzebruch, Matsushima, Chern subring,
Vogan–Zuckerman A_q(λ), Knapp–Vogan cohomological induction, etc.). They
preserve the paper ↔ Lean correspondence for future re-activation work
but do not load-bear on `hodgeConjectureReal_canonical`.

Full list (60 - 4 = 56 inactive paper-hypothesis fields, plus the 2
Layer-3 fields `mtE7FactorAtWeight3` + `inKnownE7ScopeUnderlying` that
are bundled but not consumed):

`isSchwarzE7QuarticGenerator`, `isBorelHirzebruchNonvanishH8`,
`isChernSubringSurjectiveOntoH8_E7P7`, `isMatsushimaDescentToSGamma`,
`isBorelWallachStableInvariantDescentFramework_E7`,
`isMumfordCanonicalExtensionToTor`, `isCDKLocusOfHodgeClassesAlgebraic`,
`isBBTBKTPeriodMapDefinable`, `isPSTAndreOortCMDensity`,
`isKudlaMillson1986_1990CohomologicalModularity`,
`isBruinierFunke2004OrthogonalChowLift`,
`isHowardMadapusiPera2017ArithKudlaOrthogonal`,
`isExceptionalE7ChowModularityExtension_CONJECTURAL`,
`isVoganZuckermanQQBidegree_E7Minus25`,
`isBorelWallachHeckeEquivariantMatsushima_E7Minus25`,
`isAdamsSelfConjugateLowestKType_E7Minus25`,
`isGWParallelPortHermE7Minus25_CONJECTURAL`,
`isArchimedeanRank3WhittakerNonvanishSplit_E7`,
`isBKTHeckeCorrespondencesDefinable_E7Minus25`,
`isBBTPeriodImageQuasiProjective_E7Minus25`,
`isAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL`,
P11 cluster (4 fields + 4 witnesses + 1 bridge),
P16 cluster (5 fields + 5 witnesses + 1 bridge),
P14 cluster (7 fields + 7 witnesses + 1 bridge).

## Minimum attackable field (R201)

**Selection**: Layer 2 sub-gap — `PureHodgeStructure PUnit n` instance +
`VarietyCohomologyData.point` (the cohomology bundle of a single
geometric point `Spec ℂ`).

### Current axiom / typeclass dependencies

`PureHodgeStructure` (Basic.lean:90) requires
- `V : Type*`, `[AddCommGroup V] [Module ℚ V]`
- `piece : Fin (n + 1) → Submodule ℚ V`
- `isInternal : DirectSum.IsInternal piece`

`VarietyCohomologyData` (VarietyCohomology.lean:69) requires
- `H : ℕ → Type` + per-degree (`addCommGroup`, `module`, `finite`,
  `hodgeStructure`)

For `PUnit`: Mathlib gives `AddCommGroup PUnit`, `Module ℚ PUnit` (the
unique trivial module), and `Module.Finite ℚ PUnit` (rank 0). The only
gap is the `PureHodgeStructure` proof for arbitrary weight `n`.

### Math source

Trivial Hodge structure on `0` of weight `n`: every piece is `⊥`,
direct sum is trivially internal (canonical map `0 → 0` is bijective).
This is **NOT toy** — it's the simplest geometric content: a single
point `Spec ℂ` has `H^k(pt, ℚ) = 0` for `k > 0` and `H^0(pt, ℚ) = ℚ`
with the trivial weight-0 Hodge structure (already discharged for `ℚ`
in Basic.lean:1662).

### Minimum real Lean theorem target

```lean
instance pureHodgeStructure_PUnit (n : ℕ) : PureHodgeStructure PUnit n where
  piece := fun _ => ⊥
  isInternal := /- Mathlib derivation from PUnit being a zero module -/

noncomputable def VarietyCohomologyData.point : VarietyCohomologyData where
  H := fun k => if k = 0 then ℚ else PUnit
  /- per-degree instances derived from existing infra -/

theorem AlgebraicClassesData.point : AlgebraicClassesData VarietyCohomologyData.point where
  algClasses := fun p => if p = 0 then ⊤ else ⊥
  algClasses_le_hodgeClasses := /- trivial from piece definitions -/

theorem VarietyHC_point : VarietyHC VarietyCohomologyData.point AlgebraicClassesData.point :=
  /- trivially: codim 0 is all of ℚ; codim p > 0 has both sides ⊥ -/
```

### Mathlib infra needed

All exists:
- `AddCommGroup PUnit` ✓
- `Module ℚ PUnit` ✓
- `Module.Finite ℚ PUnit` ✓
- `Submodule.bot_eq_top_iff_subsingleton` ✓
- `DirectSum.IsInternal` for trivial-module case ✓

### Why this is highest leverage

1. **First constructive `VarietyCohomologyData` from kernel + Mathlib only.** Sets the template for all future variety-cohomology constructions, including the eventual E₇ Shimura case.
2. **First kernel-pure `VarietyHC` proof from scratch.** Currently only `hodgeConjectureReal_canonical` (axiom-routed) and concrete EVII (toy carrier) provide `VarietyHC` witnesses.
3. **Bridges Layer 2 → Layer 4** in a single dim-0 case: shows the entire pipeline (cohomology data → algClasses data → HC proof) can be discharged with kernel-only content.
4. **Cannot be done with `:= True` or trivial inhabitant**: HC at a point requires real `Submodule.subsingleton`-type reasoning at degree 0 and `PUnit`-cohomology vanishing at degree > 0. The proof obligation `algClasses ≤ hodgeClasses` and the HC inclusion are non-vacuous.
5. **No risk of inflating the headline cone**: this work creates a NEW theorem `VarietyHC_point` independent of `hodgeConjectureReal_canonical` — the canonical headline cone stays `{propext, Classical.choice, canonicalE7ShimuraTor, Quot.sound}` exactly.

### If this round cannot close the full target

Smaller next theorem (one strict step down):

```lean
instance pureHodgeStructure_PUnit_zero : PureHodgeStructure PUnit 0 where
  piece := fun _ => ⊥
  isInternal := /- Mathlib derivation -/
```

Closing just the weight-0 PUnit case (single Fin 1 piece, the simplest
non-already-instantiated PureHodgeStructure case) is the strict minimum
forward step. Even if the general-`n` case turns out to need extra
Mathlib lemmas, the weight-0 PUnit case must go through.

## Round 201 deliverables

1. **This document** — gap registry with layer classification.
2. **`HodgeReduction.HCGapRegistry`** ([Lean module](../HCGapRegistry.lean)) — machine-readable `Prop`-level gap declarations naming every active gap, with paper sources. No new axioms, no `sorry`, no placeholders; each gap is a precise `Prop`/`Type` statement.
3. **`HodgeReduction.HCGapL2.TrivialPoint`** ([Lean module](../HCGapL2/TrivialPoint.lean)) — the minimum attack: constructive `PureHodgeStructure PUnit n` + `VarietyCohomologyData.point` + `VarietyHC_point` if the round closes; otherwise just the strict-minimum weight-0 PUnit closure + an unclosed-target `Prop` in the registry.
4. **Dependency cone audit** — `#print axioms hodgeConjectureReal_canonical` re-verified post-round: must remain `{propext, Classical.choice, canonicalE7ShimuraTor, Quot.sound}`.
5. **Concrete-EVII exclusion**: `HC_for_Concrete_EVII` (toy Polynomial ℚ carrier) is documented but NOT counted toward real HC closure.

## What R201 is NOT

- NOT a dead-axiom deletion round (203 dead OpenHypotheses axioms remain untouched as paper ledger).
- NOT a bundle-expansion round (`E7ShimuraTor` structure unchanged).
- NOT a `canonicalE7ShimuraTor` attack (explicitly forbidden — gap container).
- NOT a concrete-carrier optimisation (toy chain excluded from real-HC accounting).
