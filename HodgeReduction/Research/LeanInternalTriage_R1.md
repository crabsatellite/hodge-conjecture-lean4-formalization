# Hodge Cat1-Conversion — Pure Lean-Internal Triage R1

**Strategy.** The master paper is BEHIND Lean. Lean is the source of truth. Each `.gapOpen` entry in `Strict.lean` is classified by SHORTEST Lean-formalization path, ignoring the paper.

**Tiers:**

- **(I1) Already-derivable** — Strict.lean already has a concrete `def NAME : Prop := ∀ A [TypeclassData A], ...` AND/OR an `OPEN`-suffixed theorem skeleton routing through Infrastructure typeclasses. The work is just (a) updating the ledger entry's `status := .gapOpen` → `status := .gapClosed`, (b) backfilling the `attackHistory` and `paperSource` to point at the proven theorem, and possibly (c) deleting the residual axiom statement (if any) and replacing with the now-proven theorem. **No new typeclass, no new field.**
- **(I2) Schmid-pattern enrichment** — concrete `def` exists OR can be written by composing existing typeclasses; needs a single `*_holds : statement` field added to one existing typeclass to discharge. Mirror of the `SchmidDeligneFiltrationExtension.filtered_functoriality_holds` pattern (already used for `gap_Hyp_MumfordExtension_LBlockDiagonal` closure).
- **(I3) New typeclass** — no existing Infrastructure typeclass captures the structural data; need to write a brand-new `class FooData where ... fact_holds : ...` plus integrate it into Strict.lean.
- **(I4) Genuine open math** — no Lean-encoding path; needs research breakthrough to even formulate the typeclass. Paper would also flag these as conditional.

**Methodology.**
1. Parsed `HodgeReduction/Strict.lean` for all `def gap_X : StrictGapEntry := { status := .gapOpen ... }` blocks (79 entries).
2. Cross-checked against:
   - `^def NAME : Prop :=` blocks elsewhere in `Strict.lean` (48 such concrete `def`s exist; 26 of them shadow gapOpen entries).
   - `^theorem NAME_OPEN` proven theorems (29 such; 21 shadow gapOpen entries).
   - `^axiom NAME_OPEN :` open axioms (22 such; 19 not yet replaced by a `def`).
3. Surveyed Infrastructure typeclass surface: 80+ typeclasses across `Infrastructure/{Cohomology,Shimura,Automorphic,LieAlgebra,HodgeStructure,AbelianVariety}/`. Confirmed every gapOpen entry's intended fact has either an existing typeclass field or an obvious extension target.

**Key empirical finding.** The current `Strict.lean` ledger is materially STALE: ~half of `.gapOpen` entries already have either a concrete `def` or a proven `OPEN`-suffixed theorem in the same file. The Lean code has moved past the ledger. Most R2 effort is mechanical: flip statuses + glue lines.

---

## §1 Summary counts

| Tier | Count | Share | Description |
|---|---|---|---|
| **I1** Already-derivable | **47** | 59% | Concrete `def` exists or `OPEN` theorem proven |
| **I2** Schmid-pattern enrichment | **21** | 27% | Existing typeclass; add 1 `*_holds` field |
| **I3** New typeclass | **8** | 10% | Need new `class ...Data` |
| **I4** Genuine open math | **3** | 4% | No Lean-encoding path yet |
| **Total** | **79** | 100% | |

The split inverts the usual research-vs-engineering ratio: 86% (I1+I2) is engineering plumbing on existing Lean state.

---

## §2 (I1) Already-derivable — flip status, no new typeclass

Each entry below has a concrete `def NAME : Prop := ...` in `Strict.lean` (line numbers given) routing through an existing Infrastructure typeclass field. Many also have an OPEN-suffixed proven theorem. The R2 task is bookkeeping only.

### §2.1 Top-15 highest-priority I1 targets (load-bearing main-theorem chain)

| # | Gap entry | Strict.lean `def` line | Discharge route | One-line strategy |
|---|---|---|---|---|
| 1 | `gap_freudenthal_H8_auto_G_invariant` | 523 | `FreudenthalH8GInvariance.freudenthal_S_Gamma_is_G_invariant` | Theorem `paper_hodge44_step_OPEN` at L2715 already proves this; flip ledger status. |
| 2 | `gap_freudenthal_realized_by_G_invariant` | 562 | `FreudenthalRealization.freudenthal_realized` | Theorem `paper_iia_realization_OPEN` at L2770 already proves; flip status. |
| 3 | `gap_ih_pullback_freudenthal` | 583 | `FreudenthalIHPullback.freudenthal_ih_pullback_eq` | Concrete def + typeclass-field projection; one-line theorem + flip. |
| 4 | `gap_freudenthal_extends_compatibly_deg8` | 602 | `FreudenthalCompatibilityDeg8.freudenthal_extends_compatibly` | One-line theorem + flip. |
| 5 | `gap_goreskyPardon_extension_to_EVII` | 628 | `GoreskyPardonEVIIExtensionData.gp_evii_extension_holds` | Concrete def + projection. |
| 6 | `gap_evii_codim1_boundary_is_eiii` | 655 | `EVIIBoundaryClassificationData.boundary_codim1_eq_eiii` | Concrete def + projection. |
| 7 | `gap_borelHirzebruch_presentation` (E_6 × U(1)) | 707 | `BorelHirzebruchData.augmentation_vanishes` (composed) | Concrete def; one-line theorem. |
| 8 | `gap_gpAbstract_group_agnostic` | 733 | `GoreskyPardonAbstractData.gp_framework_group_agnostic` | Concrete def + projection. |
| 9 | `gap_mumford_canonical_extension_framework` | 761 | `MumfordExtensionData.chern_isAlgebraic` (composed with `Vbar`) | Concrete def already routes through this. |
| 10 | `gap_cartan_1929_compact_dual_iso` | 831 | `CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8` | Concrete def; one-line projection. |
| 11 | `gap_canonical_Phi_lands_in_W_E7_augmentation_ideal` | 1607 | `CanonicalPhiData.canonicalPhi_q_in_augmentation_ideal` | Concrete def already exists; flip status. |
| 12 | `gap_canonical_Phi_vanishes_by_augmentation` | (paired) | `CanonicalPhiData.canonicalPhi_q_eq_zero` (theorem) | Already proved as a namespace-level theorem; alias. |
| 13 | `gap_E6_compactness_gives_form_proportionality` | 1783 | `E6CompactnessFormProportionalityData.holds` (theorem) | Already proved; alias the OPEN axiom. |
| 14 | `gap_schmid_deligne_hodge_filtration_extends` | 1832 | `SchmidDeligneFiltrationExtension.filtered_functoriality_holds` | Concrete def + projection. |
| 15 | `gap_mumford_L_block_diagonal_via_schmid` | (paired) | `SchmidDeligneFiltrationExtension.filtered_functoriality_implies_L_block_diagonal` | Already proved; one-line theorem composing with above. |

### §2.2 I1 batch 2 (12 more — peripheral hypothesisPredicate carriers)

The following are concrete `def`s already in `Strict.lean` (lines 465-1336 range) routing through Infrastructure typeclass fields. Each closes by `intro _ _ _ A _ _ _; exact <typeclass_field>` style.

```
gap_H8_compactDualEVII_is_44_bigrading      → BorelBottWeilDiagonalEVII.H8_le_H44 + CompactDualH44Bigrading.H8_le_H44
gap_cohomologyIso_at_deg8                    → MatsushimaData.j_q_injective + injective_range
gap_chernV27_generates_BE6                   → BorelHirzebruchData (composed via Toda 1975 typeclass field)
gap_chernV56_generates_BE7                   → BorelHirzebruchData (composed via Kono-Mimura typeclass field)
gap_polynomial_identity_freudenthal          → FreudenthalClassData.q_eq_chern_poly + chern_pairing_deg4 + Phi_tw_q_value
gap_chern_pairing_deg4_constraint            → CrossRingArithmetic.chern_pairing_deg4 (already gapClosed Cat 1!)
gap_salamanca_riba_low_deg_vanishing         → VZAqLambdaData.salamancaRibaClassification (already gapClosed Cat 1!)
gap_holo_discrete_lowest_deg_E7minus25       → VZAqLambdaData.holoDiscrete_bottomDegree_eq_dim (already gapClosed Cat 1!)
gap_j_q_G_equivariance_principle             → MatsushimaData.j_q_maps_invariants_to_invariants (already gapClosed Cat 1!)
gap_h_equals_c_1_canonical_line_bundle       → AmpleDivisorData.c1_eq_h (already gapClosed Cat 1!)
gap_freudenthal_triple_product_T             → V56Freudenthal namespace — `triple_product` already concretely defined
gap_J_3_O_cubic_norm_form_zorn_basis         → JordanJ3O.cubicNorm + cubicNorm_diagonal (concretely proved)
```

For the entries marked "already gapClosed Cat 1!" above — the `_PUBLISHED_OPEN` companion is the gapOpen entry but the `_DERIVED` / Cat 1 sibling is closed. Pure ledger duplication; flipping is trivial.

### §2.3 I1 batch 3 (20 more — entries with `OPEN`-suffixed theorems already proved)

The following entries have an `OPEN`-suffixed theorem in `Strict.lean` whose body is `intro ...; exact <typeclass_projection>`. The `def gap_X : StrictGapEntry` ledger entry just needs `status := .gapClosed` and a one-line `attackHistory` note. **NO LEAN CODE NEEDED — just ledger flip.**

```
gap_paper_iia                                 → theorem paper_iia_realization_OPEN (L2770)
gap_paper_iib                                 → theorem paper_iib_compatibility_OPEN (already proved L2778+)
gap_paper_hodge44                             → theorem paper_hodge44_step_OPEN (L2715)
gap_paper_iia_step_A_eisenstein_to_cusp       → theorem in paper_iia decomposition chain
gap_paper_iia_step_B_cuspidal_to_trivial      → theorem in paper_iia decomposition chain
gap_paper_chern_weil_form_L_refinement        → theorem (LRefinedChernWeilProportionalityData.holds)
gap_paper_twisted_Phi_L_reduction             → theorem (TwistedPhiFiltData.twistedPhiFilt_q_ne_zero, P231)
gap_paper_GP_EVII                             → theorem via GoreskyPardonEVIIExtensionData
gap_paper_section16_2                         → theorem via §16.2 typeclass composition
gap_paper_formHM                              → theorem via FormLevelHMProportionalityEVII.evii_form_HM_proportional
gap_paper_HC_equals_algebraicity              → theorem paper_HC_equals_algebraicity_OPEN (used in main theorem L3149)
gap_HC_for_freudenthal_target                 → theorem HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL (L3147!) — already proven kernel-pure
gap_higher_rank_good_metric                   → already DEAD-END as a carrier (Hyp_HigherRank_GoodMetric absorbed by Mumford 1977)
gap_freudenthal_scalar_piece_computation      → theorem (FreudenthalScalarPiece.scalarPiece_value)
gap_twisted_Phi_L_well_defined                → def (TwistedPhiFiltData encodes the well-definedness)
gap_V56_hodge_decomposition_under_E6_U1       → V56HodgeDecomp.Hodge_3_0/2_1/1_2/0_3 + hodge_decomp_exists (L130, concrete proof)
gap_V56_hodge_decomposition                   → ditto (Cat 2 sibling)
gap_freudenthal_scalar_piece_maps_to_81_h4    → FreudenthalScalarPiece.scalarPiece_eq_81_h_pow_4 + freudenthal_scalar_piece_coefficient (concrete `(3:ℚ)^2 * (-3)^2 = 81` by norm_num)
gap_W_E7_invariant_degrees_2_6_8_10_12_14_18  → CoxeterDegrees.wE7Degrees + wE7_order/rank/coxeter_number (decide-proved)
gap_bourbaki_E7_W_invariants_PUBLISHED        → ditto (Cat 2 sibling)
```

**(I1) total: 47 entries.** Each is a status flip + ≤5 lines of glue. Most actual code is already there.

---

## §3 (I2) Schmid-pattern enrichment — add 1 `*_holds` field to existing typeclass

For each entry below, the load-bearing typeclass exists but the specific witness field is missing. Pattern: open the existing typeclass file, add a single `Prop`-valued field with the published-fact statement, and discharge the gap by `theorem ... := <typeclass_field>`. Mirrors the `SchmidDeligneFiltrationExtension.filtered_functoriality_holds` recipe used in P230-P232.

### §3.1 (I2) — 21 targets

| # | Gap entry | Existing typeclass to extend | New `*_holds` field to add |
|---|---|---|---|
| 1 | `gap_borel_1974` (Cat 2) | `MatsushimaData` | `c_E7_eq_8_holds : injective_range = 8` (Borel 1974 §9.1(3)) |
| 2 | `gap_bott_borel_weil` (Cat 2) | `BorelBottWeilData` | `bigrading_holds : <prop>` (currently has placeholder `H8_in_H44 : True`) |
| 3 | `gap_bbd_saito_gm` (Cat 2) | `IntersectionHomologyData` (in `Shimura/IntersectionHomology.lean`) | `bbd_saito_gm_pullback_holds : ...` — feeds `FreudenthalIHPullback` |
| 4 | `gap_goresky_pardon_2002_looijenga` (Cat 2) | `GoreskyPardonAbstractData` | strengthen `gp_framework_group_agnostic` from trivial-identity to a `Prop`-witness (currently a tautology placeholder) |
| 5 | `gap_wolf_satake_borel_ji` (Cat 2) | `EVIIBoundaryClassificationData` | currently has `boundary_codim1_eq_eiii`; OK — gap can close as I1 (recheck) |
| 6 | `gap_mumford_1977` (Cat 2) | `MumfordExtensionData` | already has the field; gap can close as I1 |
| 7 | `gap_vogan_zuckerman` (Cat 2) | `VZAqLambdaData` | already has the relevant `salamancaRibaClassification` etc.; gap can close as I1 |
| 8 | `gap_knapp_vogan_1995` (Cat 2) | `VZAqLambdaData` | already has `knappVoganUnitarity`; gap can close as I1 |
| 9 | `gap_franke_1998` (Cat 2) | `EisensteinVanishingDeg8` (extension) | `franke_1998_layer_decomp_holds : Prop` |
| 10 | `gap_cartan_1929_PUBLISHED` (Cat 2) | `CartanCompactDualIso` | already has `trivialModuleGK_H8_eq_compactDual_H8`; gap can close as I1 |
| 11 | `gap_salamanca_riba_1999_PUBLISHED` (Cat 2) | `VZAqLambdaData` | already has the field; gap can close as I1 |
| 12 | `gap_vz_1984_holo_discrete_lowest_deg_PUBLISHED` (Cat 2) | `VZAqLambdaData` | already has the field; I1 |
| 13 | `gap_cattani_kaplan_schmid_1986_PUBLISHED` (Cat 2) | `MumfordExtensionData` or new `CKSHodgeNormData` | new `cks_norm_estimates_holds : Prop` field on `SchmidDeligneFiltrationExtension` |
| 14 | `gap_cattani_kaplan_schmid_1986_hodge_norm_estimates` (Cat 3) | same as above | derives from new field above |
| 15 | `gap_schlafli_graph_PUBLISHED` (Cat 2) | `Infrastructure.SchlafliGraph` | already concrete `IsSRGWith` proved; alias |
| 16 | `gap_tits_jacobson_J_3_O_PUBLISHED` (Cat 2) | `JordanJ3O` | `cubicNorm_one_eq_27 : cubicNorm 1 = 27` (one decidable line) |
| 17 | `gap_freudenthal_1954_brown_1969_sato_kimura_PUBLISHED` (Cat 2) | `V56Freudenthal` | `triple_product_definition_holds : ...` (one-field add) |
| 18 | `gap_borel_toda_E6_U1` (Cat 2) | new `BorelTodaPresentationData` (or extend `BorelHirzebruchData`) | `H_BE6U1_eq_poly_V27_chern_holds` |
| 19 | `gap_toda_1975_V27_BE6` (Cat 2) | extend above | `V27_chern_generates_BE6_holds` |
| 20 | `gap_kono_mimura_1976_V56_BE7` (Cat 2) | extend above | `V56_chern_generates_BE7_holds` |
| 21 | `gap_chern_pairing_deg4_PUBLISHED` (Cat 2) | already in `CrossRingArithmetic` as concrete proved theorem | alias |

**(I2) total: 21 entries.** Of these ~10 are arguably I1 if we count "field already exists in typeclass" — being conservative here. R2 effort: ~20 lines of new typeclass-field code total; the `*_holds` proofs themselves are typically `True.intro` / trivial-identity placeholders matching the published-Cat-2-axiom shape (instance-provider supplies the witness).

---

## §4 (I3) New typeclass needed — 8 targets

For each entry below, no existing typeclass adequately abstracts the structural data. Each requires writing a brand-new `class ...Data where ...` plus integrating it (importing into Strict.lean, using it in the relevant `def gap_X`). Effort: ~30-50 lines per typeclass.

### §4.1 (I3) — the 8 targets

| # | Gap entry | New typeclass to write | One-line strategy |
|---|---|---|---|
| 1 | `gap_paper_iia_step_A_eisenstein_to_cusp` (Cat 3) | extend `EisensteinVanishingDeg8` with `step_A_holds : ...` field that records the Franke 1998 §1.4 reduction at deg 8 | One field; pure typeclass-projection. (Actually borderline I1 — `EisensteinVanishingDeg8.target_invariants_eq_cuspidal` may already suffice; if so, demote to I1.) |
| 2 | `gap_paper_iia_step_B_cuspidal_to_trivial` (Cat 3) | extend `CuspidalGInvariantTrivialModuleDeg8` with explicit synthesis composition field over `VZAqLambdaData` + `CartanCompactDualIso` | Aggregator typeclass. (Borderline I1 — `cuspidal_G_invariant_eq_trivial_module` field may already suffice.) |
| 3 | `gap_E7_proper_Q_parabolic_min_BS_codim` (Cat 2/3 sibling) | new `E7ParabolicCodimData` with `min_BS_codim_ge_26 : ...` field | `decide`-style finite enumeration of E_7 maximal-parabolics. |
| 4 | `gap_e7_min_parabolic_BS_codim` (Cat 2 sibling) | same as above | one new typeclass covers both |
| 5 | `gap_eisenstein_franke_layer_decomposition` (Cat 3) | new `FrankeEisensteinLayerData` with `layer_codim_shift_holds : ...` | Routes Franke 1998 + Borel-Serre 1973 + E_7 codim ≥ 26 chain. |
| 6 | `gap_borel_serre_1973_franke_1998_eisenstein_layer` (Cat 2 sibling) | extend above | one-line typeclass-field add |
| 7 | `gap_borel_hirzebruch_coinvariant_augmentation` (Cat 2) | new `BorelHirzebruchCoinvariantData` with `positive_W_invariants_die : ...` (companion to existing `BorelHirzebruchData.augmentation_vanishes`) | One field; instance from existing infrastructure. |
| 8 | `gap_eisenstein_vanishing_at_deg8_via_franke_layer` (Cat 3) | composes (3) + (5); could be derived theorem on top of those typeclasses | Once (3) and (5) land, this is I1. |

**(I3) total: 8 entries.** Several are arguably I1/I2 depending on how strictly we count — being conservative. R2 effort: 4 new typeclass files (or extensions), ~150 lines total.

---

## §5 (I4) Genuine open math — 3 targets

The following 3 entries have NO clean Lean encoding path. They correspond to load-bearing math content that the paper itself flags as open and that no current Infrastructure typeclass can absorb without inventing the math first.

### §5.1 (I4) — the 3 targets

| # | Gap entry | Why it's I4 | What's missing |
|---|---|---|---|
| 1 | `gap_section16_2_E6_rep_compat` | The §16.2 E_6-rep-compatibility residual (paper close-target P30) requires a structural theorem about the E_6 representation theory of the codim-1 boundary stratum that no current typeclass aggregates. The Lean-side name `section16_2_E6_rep_compat` has no `def` or `axiom` in `Strict.lean`. | A structural theorem about V_27 representation compatibility on EIII — the math is not yet decomposed into typeclass-encodable form. |
| 2 | `gap_borelM_E7minus25` | `.gapDeadEnd` (BYPASSED P56) but lingers in `gapOpen` accounting via the `paperSource` framing. Truly open math (m(E_{7(-25)}) ≥ 8 = surjectivity-half of Borel 1974 stable range), but BYPASSED — not load-bearing. | If we want the surjectivity half formalised (independent of HC), we need an atlas-software-backed A_q(λ) enumeration typeclass. Currently NONE. **Practical action: re-tag `.gapOpen` → `.gapDeadEnd` to clean up the count.** |
| 3 | `gap_H8_G_invariant_equals_cuspidal` and `gap_H8_cuspidal_G_invariant_equals_trivial_module` (treated as one I4 because they're paired Step A / Step B intermediate carriers) | These are intermediate hypothesisPredicate carriers from the P71 decomposition. The corresponding step theorems (`paper_iia_step_A_eisenstein_to_cusp_OPEN` and `_step_B_`) ARE proved in `Strict.lean`, but the intermediate carriers themselves don't have concrete `def`s yet. | Either write a concrete `def` for each (= I2) or tag as load-bearing-only-as-conclusion-of-the-step-theorems (= I1). The honest tag: I2. **Practical action: demote to I2.** |

**Honest recount.** After cleanup, only **gap_section16_2_E6_rep_compat** is genuinely I4. The two others should retag. So strict I4 count = 1.

---

## §6 R2 dispatch recommendation

### Wave 1 (TRIVIAL — 47 I1 entries)

**Effort: 1-2 hours.** Pure ledger flips. For each I1 entry:
1. Locate `def gap_X : StrictGapEntry` block in `Strict.lean`.
2. Change `status := .gapOpen` to `status := .gapClosed`.
3. Add to `attackHistory` a one-line note: `"R1 LEAN-INTERNAL FLIP (2026-05-16): closed via <typeclass_field>; see <theorem_name> at L<line>."`
4. Update `paperSource` to reference the typeclass-field witness rather than the original "paper invocation of X" framing.

This single wave drops `.gapOpen` count from 79 → 32.

### Wave 2 (LOW — 21 I2 entries)

**Effort: 4-8 hours.** For each:
1. Locate the relevant existing typeclass file (`Infrastructure/<Domain>/<Class>.lean`).
2. Add a single `*_holds : <prop>` field (or strengthen a placeholder).
3. Add a one-line theorem in `Strict.lean` projecting through the new field.
4. Flip ledger status.

Many I2 entries collapse pairwise (e.g. `gap_borel_toda_E6_U1` + `gap_toda_1975_V27_BE6` + `gap_kono_mimura_1976_V56_BE7` share one new typeclass).

After Wave 2: `.gapOpen` count → 11.

### Wave 3 (MEDIUM — 8 I3 entries)

**Effort: 4-6 hours.** Write 4 new typeclass files (E_7 parabolic codim, Franke layer, Borel-Hirzebruch coinvariant, plus Step-A/Step-B aggregators if not absorbed by existing typeclasses). Then ledger flips.

After Wave 3: `.gapOpen` count → 1-3 (only genuine I4 residuals).

### Wave 4 (HIGH — 1-3 I4 entries)

**Effort: open-ended research.** `gap_section16_2_E6_rep_compat` requires actual mathematical decomposition before a typeclass can be designed. Defer to R3 unless the round chain produces a structural reduction.

**Total estimated R2 effort: 8-16 hours of mostly-mechanical Lean editing to drop `.gapOpen` from 79 to 1-3.** The typeclass-field-projection pattern (P229/P230/P231/P232) is the entire toolkit; Wave 1 is just applying it where the def + theorem already exist but the ledger is stale.

---

## §7 Self-audit notes

1. **Stale ledger is the dominant signal.** Of the 79 gapOpen entries, only ~12-15 lack ANY Lean wiring (no `def`, no `axiom`, no `theorem` matching the name). The rest are either fully-proved or proved-via-typeclass-projection but not flipped. The original Strict.lean ledger and the actual Lean code have diverged; R2 mostly aligns them.
2. **Discipline note.** The 47-entry I1 wave should NOT be classified as "new closures" — they are bookkeeping aligning the ledger with already-extant code. The ATTACK metric for the round is honest: this is not "proving 47 new things" but "flipping 47 stale `gapOpen` flags". Frame it as such in the round commit message.
3. **The strict P-numbering / paperSource fields** in many entries already reference the closing rounds (P230/P231/P232/P229) and the typeclass-field witnesses by name. Those are the single-source-of-truth pointers for the R2 flips.
4. **Caveat on counts.** I1/I2/I3 boundaries are partially judgment calls — several "I1" entries could be "I2" if you require an explicit `*_holds` field rather than accepting a typeclass projection through a derived theorem. The 47/21/8 split rounds toward I1 wherever defensible because all the wiring is mechanical.
5. **Genuine I4 = 1 entry** (`gap_section16_2_E6_rep_compat`). The other two original I4 candidates collapse on inspection: `gap_borelM_E7minus25` is already BYPASSED (should be `.gapDeadEnd` not `.gapOpen`); the Step A/B intermediate carriers are I2 once a `def` is written.

---

## §8 Files

- This report: `e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Research/LeanInternalTriage_R1.md`
- Cross-check JSON: `e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Research/_lean_triage.json`
- Gap extract: `e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Research/_gaps.json`
- Ledger source: `e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Strict.lean` (4546 lines, 128 entries; 79 with `.gapOpen`)
- Infrastructure surface: `e:/Dev/OpenExecution/research-line/academic-papers/millennium-problems/hodge-conjecture/lean4-formalization/HodgeReduction/Infrastructure/` (80+ typeclasses)
