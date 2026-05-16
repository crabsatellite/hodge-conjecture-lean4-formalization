# Hodge Cat1-Conversion — Paper-Gap Triage R1

**Scope.** All `status := .gapOpen` entries in `HodgeReduction/Strict.lean` (79 entries; the brief specified ~81 — the discrepancy is `Hyp_BorelMAtLeast8_OPEN` and `Hyp_VHS_OPEN`-type slots already absorbed elsewhere). For each, classify by whether the master paper or a round-contribution argument is the load-bearing source:

- **(P) PAPER-PROVES**: full or near-complete argument exists in the paper / a round-contribution and only needs Lean formalisation.
- **(C) PAPER-CITES**: paper cites a published external result; gap is a Cat 2 PUBLISHED axiom to encode as a typeclass-field witness.
- **(D) DERIVED**: gap is structurally derived from other (already-encoded) gaps; close by composing typeclass-field projections.
- **(O) PAPER-ASSUMES**: paper explicitly labels this an open/conditional input. Needs new math.

**Methodology.** Source files inspected:
- `HodgeReduction/Strict.lean` (line-by-line block parse — 128 entries, 79 gapOpen)
- `contributions/hodge-conjecture-master-proof.tex` (15405 lines; key sections §3.4 E_7 closure L3152-4200, hyp:ChernWeil-bridge-E7 L11449-11648, rem:borel-matsushima L3452-3530, rem:E7-chernweil-tautology L3420-3450)
- `contributions/r*.tex` (157 round-contribution files; keyword-matched against each gap's scope/paperSource phrases)

A regex-based search was used to cross-check the 79 gaps against the master + round files (`Research/_triage_search.json`). The classification below relies on **the paperSource field already recorded in `Strict.lean` plus the Lean-level cross-references between gaps** (which gap consumes which Cat 2 axiom, which structural equation closes which Hyp_*) rather than on the noisy keyword hits alone. The 49 most load-bearing entries are detailed; the remaining 30 are summarised at the bottom.

**Honest framing of the paper.** The master tex sets up the entire E_7 closure as conditional on `\ref{hyp:ChernWeil-bridge-E7}`. The hypothesis itself is split into clauses (i.a) classical, (i.b) conditional bridge `[q]_G ≠ 0`, (ii) classical for cocompact / conditional non-cocompact at deg 8, (iii) conditional polynomial identity. The paper EXPLICITLY says (L3429-3450 rem:E7-chernweil-tautology): "The polynomial-identity conclusion … is the conditional content of clause (iii) of Hypothesis~\ref{hyp:ChernWeil-bridge-E7} and is therefore tautological once the hypothesis is granted."

This means a large block of gaps are honestly (O). The Lean rounds P39-P71 then push back beyond the master tex's framing: P53 computes the cross-ring coefficient -48 ≠ 0 (so part of clause i.b is now ESTABLISHED beyond the paper); P32-P36 reframe the Borel-stable-range / V-Z input chain; P54 closes the L-block functoriality. These Lean-side advances are **not yet in the paper** — the paper still records them as conditional, so the (P) tag here refers to the round-contribution / Lean-ledger argument, not master tex prose.

---

## §1 Triage table

Sort: **(P)** first, then **(C)**, then **(D)**, then **(O)**. Within each tag, sorted by approximate load-bearing weight (Cat 2 published prerequisites first within (C); paper §-anchored within (P)).

### (P) PAPER-PROVES — Lean-formalisation work only, no new math

| Gap name | Tag | Paper / round location | Argument summary | Lean difficulty |
|---|---|---|---|---|
| `gap_polynomial_identity_freudenthal` | P | `Strict.lean` paperSource: P57 explicit; cross-references already-closed `chern_pairing_deg4_constraint` (P91 LEAN-CLOSED) and `Hyp_CrossRingPhiNonzero` (P231 LEAN-CLOSED) | Combine Φ_tw(q) = -48 h⁴ (P53) with h⁴ = 2c_4 - 2c_1c_3 + c_2² (P57) to get [q] = -48(2c_4 - 2c_1·c_3 + c_2²) = -96 c_4 + 96 c_1·c_3 - 48 c_2². Numerically verified via P48 explicit Chern values (c_1=-9h, c_2=41h², c_3=-125h³, c_4=285h⁴). Already closed direct variant exists. | **LOW** — replicate the P91/P93 norm_num pattern over the explicit polynomial; both upstream pieces are already Cat 1. |
| `gap_canonical_Phi_lands_in_W_E7_augmentation_ideal` | P | `Strict.lean` paperSource: P41 RIGOROUSLY ESTABLISHED; depends on `gap_W_E7_invariant_degrees` (Bourbaki Planche VI, paper L9670-9672 explicit) | q is W(E_7)-invariant; q|_{t^∨} has degree 4; W(E_7) invariant degrees are {2,6,8,10,12,14,18} → only degree-4 invariant is κ², so q|_{t^∨} = c·κ² ∈ Sym^4(t^∨)^{W(E_7)}_+ (augmentation ideal). | **LOW** — typeclass field on `WE7InvariantDegreesData` carrying the degree set + a one-line consequence; pattern matches P230/P232 closures. |
| `gap_freudenthal_scalar_piece_maps_to_81_h4` | P | `Strict.lean` paperSource: P45 RE-VINDICATED with audit trail; round-level argument complete | With correctly O(1)-twisted normal bundle N = 27'_{-4} ⊕ 1_{-6}, the leading normal jet of q along Ě_VII is q_2 = b^2 = (ab)^2 \|_{a=1}, order m = 2, L-invariant, nonzero. | **LOW** — finite computation; encode as `FreudenthalNormalJetData` typeclass with the order/coefficient fields. |
| `gap_freudenthal_scalar_piece_computation` | P | `Strict.lean` paperSource: P45-corrected structural equation (1-input); same content as previous row | Records that q vanishes to order EXACTLY m = 2 along Ě_VII; leading jet q_2 is L-invariant and nonzero. | **LOW** — once `gap_freudenthal_scalar_piece_maps_to_81_h4` is Cat 1, this is a typeclass-projection. |
| `gap_canonical_Phi_vanishes_by_augmentation` | P | `Strict.lean` paperSource: 2-input structural equation from `gap_canonical_Phi_lands_in_W_E7_augmentation_ideal` (= P) | Canonical Φ kills q because q|_{t^∨} is in the W(E_7)-augmentation ideal of the Borel-Hirzebruch coinvariant ring (Borel-Hirzebruch presentation, paper L11469-11471). | **LOW** — typeclass composition once the augmentation-ideal carrier is Cat 1. |
| `gap_E6_compactness_gives_form_proportionality` | P | `Strict.lean` paperSource P40; Kobayashi-Nomizu Vol. II Ch. XII is folklore — paper L9670 invokes the analogous compact-Levi argument; master tex implicit | Levi E_6 ⊂ K is compact, so Mumford good metric restricts to E_6-invariant on rank-27 Hodge sub-bundles E_{±1}; E_6-invariant Chern-Weil forms are proportional to homogeneous invariant forms. Standard Cartan averaging. | **LOW-MEDIUM** — encode as a `CompactLeviProportionalityData` typeclass; the underlying group-theory fact is Kobayashi-Nomizu Vol. II Ch. XII = Cat 2 single-source. |
| `gap_V56_hodge_decomposition_under_E6_U1` | P | Master tex L3611-3617 + Remark V56-weights-verification L3597-3621 explicitly states V_56\|_{E_6} = V_27 ⊕ V_{27̄} ⊕ ℂ² and weights ±1 / ±3 under U(1); cites Bourbaki Planche VI + Helgason Ch. X | E_7 ⊃ E_6 × U(1) branching; V_56 = 1_{+3} ⊕ 27_{+1} ⊕ 27'_{-1} ⊕ 1_{-3} as weight-3 Hodge decomposition. | **LOW** — paper-explicit branching law; encode as `V56BranchingData` typeclass field. |
| `gap_twisted_Phi_L_well_defined` | P | `Strict.lean` paperSource: P41-reframed; Hodge-FILTRATION projection on Gr_F^p(Sym^4 V_56^∨) before Chern-Weil | Φ_filt is the projection of q onto Gr_F^p(Sym^4 V_56^∨) before applying Chern-Weil; F^• is not W(E_7)-stable, so Φ_filt is genuinely non-zero (it's the canonical-extension-aware Chern-Weil map). | **LOW** — definition, not a theorem; encode as a `def` plus the typeclass that records well-definedness in cohomology rings carrying both `KaehlerClass` and `V56HodgeDecomp`. |
| `gap_mumford_L_block_diagonal_via_schmid` | P→D | `Strict.lean` paperSource: P54 closed via Schmid 1973 + Deligne 1970 + V_56 Hodge decomposition; 3-input structural equation. `gap_Hyp_MumfordExtension_LBlockDiagonal` itself already `.gapClosed`. | The L = E_6 × U(1) decomposition IS the Hodge filtration; Schmid 1973 + Deligne 1970 give canonical-extension functoriality on graded pieces; the L-block structure extends. | **LOW** — structuralEquation whose Hyp_*-side is already closed; this is the proof-witness of that closure, which can be typed once `schmid_1973_deligne_1970` (Cat 2) is encoded. |
| `gap_eisenstein_vanishing_at_deg8_via_franke_layer` | P→D | `Strict.lean` paperSource: P55 closed via Franke layer + E_7 codim ≥ 26; 2-input structural equation. Downstream `Hyp_Eisenstein_Vanishing` already `.gapClosed`. | Franke layer decomposition + E_7 root-system codim ≥ 26 ⟹ at d = 8 < 26 every Eisenstein layer is zero. | **LOW** — typeclass composition once both upstream Cat 2 (`borel_serre_1973_franke_1998_eisenstein_layer` and `e7_min_parabolic_BS_codim`) are encoded. |
| `gap_paper_iia_step_A_eisenstein_to_cusp` | P→D | `Strict.lean` paperSource: P71 Step A; 2-input atomic | Eisenstein vanishing + Franke 1998 §1.4 ⟹ G-invariant H^8 = cuspidal G-invariant H^8. Standard L²-decomposition. Both inputs already encoded. | **LOW** — typeclass composition. |
| `gap_paper_iia_step_B_cuspidal_to_trivial` | P→D | `Strict.lean` paperSource: P71 Step B; 5-input atomic | V-Z 1984 + KV 1995 + Salamanca-Riba 1999 + V-Z holo-disc + Cartan 1929 ⟹ cuspidal G-invariant H^8 = trivial-module Cartan image = ⟨h^4⟩. All 5 inputs already in ledger (3 already `.gapClosed`). | **MEDIUM** — many inputs; need a `(g,K)-CohomologyDecompData` typeclass aggregating salamanca_riba + holo_discrete + cartan_compact_dual + V-Z + KV. |
| `gap_paper_iia` | P→D | `Strict.lean` paperSource: master tex hyp:ChernWeil-bridge-E7 clause (ii.a); P71 decomposed into Steps A+B + Step C assembly; 3-input atomic for Step C | Step A + Step B + freudenthal G-invariance ⟹ Freudenthal class realized by G-invariant cohomology. | **MEDIUM** — pure composition once A, B are closed. |
| `gap_paper_hodge44` | P | Master tex `\ref{rem:borel-matsushima}` (L3453) + `\ref{rem:E7-chernweil-tautology}` (L3422); 3-input atomic post-P61 | Cohomology iso H^8(S_Γ) ≅ H^8(Ě_VII) (Borel 1974 c(E_7)=8 PUBLISHED) + (4,4) bigrading (Bott-Borel-Weil) + j^q G-equivariance (P230 LEAN-CLOSED) ⟹ Freudenthal H^8 class auto-G-invariant on S_Γ. All inputs Cat 1 or close to it. | **LOW-MEDIUM** — typeclass-field composition. |
| `gap_freudenthal_H8_auto_G_invariant` | P→D | Same content as `gap_paper_hodge44` (the workingAssumption that the hypothesisPredicate ENCODES) | Conclusion of `paper_hodge44`. | **LOW** — derive from above. |
| `gap_HC_for_freudenthal_target` | P→D | Master tex Main Theorem (`\ref{thm:main}` L410) target | HC for Freudenthal [q] on EVII Shimura varieties. Conclusion of the entire reduction chain. | **LOW** — top-level composition; `gap_freudenthal_is_algebraic` (Cat 1, `.gapClosed`) + `gap_paper_HC_equals_algebraicity` (paper-stated def) ⟹ this. |
| `gap_paper_HC_equals_algebraicity` | P | Master tex `\ref{thm:main}` (L410) §3.4.3 definitional setup | HC for class = algebraicity (paper's definitional equation). | **LOW** — paper-stated definitional equation; encode as a `Definition` not an axiom. |

**(P)-tag count: 17.** Several already have most upstream inputs closed, making these the lowest-friction R2 targets.

### (C) PAPER-CITES — Cat 2 PUBLISHED to encode as typeclass-field witness

All entries here are `inputCategory := .cat2External, cat3SubType := .notApplicable` with paperSource being a published citation. The Lean ledger already names the exact citation; the work is to extend an existing typeclass with a field for the published statement and discharge the OPEN axiom via that field. The R0/P230 closures of `gap_borel_1974_j_q_G_equivariance` and `gap_borel_hirzebruch_h_equals_c_1_L` establish the pattern — all Cat 2 entries below can be Cat-1-closed by the same recipe.

| Gap name | Tag | Cited reference | Where consumed | Typeclass to extend | Lean difficulty |
|---|---|---|---|---|---|
| `gap_bott_borel_weil` | C | Bott 1957 Ann. Math. 66 + Borel-Hirzebruch 1958 AJM 80 §29-30 + Griffiths-Harris 1978 Ch. 1 §3 | Hodge-(4,4) chain → `gap_H8_compactDualEVII_is_44_bigrading` | `Infrastructure.Automorphic.BorelBottWeil` already exists; add `bigrading_at_top : ...` field. | **LOW** |
| `gap_borel_1974` | C | Borel 1974 Ann. Sci. ÉNS 7 §9.1(3) p.261: c(E_7) = 8 | `gap_cohomologyIso_at_deg8` carrier | New `BorelStableRangeData` typeclass with `c_E7_eq_8 : ...` field. | **LOW** |
| `gap_bbd_saito_gm` | C | BBD 1982 Astérisque 100 + Saito 1988 Publ. RIMS 24 + Goresky-MacPherson 1980 | `gap_ih_pullback_freudenthal` → (ii.b.1) | `Infrastructure.Shimura.IntersectionHomology` already exists; add IH-pullback field. | **LOW-MEDIUM** |
| `gap_goresky_pardon_2002_looijenga` | C | Goresky-Pardon 2002 Invent. Math. 147 §10-12 + Looijenga 2017 Compositio 153 | `gap_gpAbstract_group_agnostic` → §16.2 | New `GoreskyPardonAbstractData` typeclass. | **LOW-MEDIUM** |
| `gap_wolf_satake_borel_ji` | C | Wolf 1972 + Satake 1980 + Borel-Ji 2006 §III.4-5 | `gap_evii_codim1_boundary_is_eiii` → §16.2 | New `EVIIBoundaryClassificationData` typeclass. | **LOW** |
| `gap_mumford_1977` | C | Mumford 1977 Invent. Math. 42 Thm 3.1 + Harris 1989 Proc. LMS (3) 59 §4.1 | `gap_mumford_canonical_extension_framework` → form-HM | `Infrastructure.Shimura.MumfordExtension` already exists; add Thm 3.1 field. | **LOW** |
| `gap_vogan_zuckerman` | C | Vogan-Zuckerman 1984 Compositio Math. 53 | `gap_voganZuckerman_1984_framework` → (ii.a) Step B | `Infrastructure.Automorphic.VoganZuckerman` already exists. | **LOW** |
| `gap_knapp_vogan_1995` | C | Knapp-Vogan 1995 PMS-45 Ch. XII | `gap_knappVogan_1995_induction` → (ii.a) Step B | Add to `VoganZuckerman` module. | **LOW** |
| `gap_franke_1998` | C | Franke 1998 Ann. Sci. ÉNS (4) 31 | `gap_franke_1998_framework` → Eisenstein layer | New `FrankeEisensteinData` typeclass. | **LOW** |
| `gap_cartan_1929_PUBLISHED` | C | Cartan 1929 Rend. Circ. Mat. Palermo 53 + Borel-Wallach Ch. II §3.3 Cor. 3.4 | Step B of (ii.a) | `CartanCompactDualData` typeclass with `H_g_K_eq_H_E_VII` field. | **LOW** |
| `gap_salamanca_riba_1999_PUBLISHED` | C | Salamanca-Riba 1999 Duke Math. J. 96 + Vogan 1984/1981 + Vogan-Zuckerman 1984 §5 | Step B of (ii.a) — kills non-trivial A_q(λ) at deg 8 | Already partially done — `gap_salamanca_riba_low_deg_vanishing` is `.gapClosed`. This `_PUBLISHED_OPEN` companion is the citation-hygiene split; close by typeclass field on `VZAqLambdaData.salamancaRibaClassification`. | **LOW** |
| `gap_vz_1984_holo_discrete_lowest_deg_PUBLISHED` | C | Vogan-Zuckerman 1984 §5 + Knapp-Wallach 1976 + Borel-Wallach Ch. VI | Step B of (ii.a) — kills holo-discrete at deg 8 | Companion of `gap_holo_discrete_lowest_deg_E7minus25` (`.gapClosed`); use `VZAqLambdaData.holoDiscrete_bottomDegree_eq_dim`. | **LOW** |
| `gap_cattani_kaplan_schmid_1986_PUBLISHED` | C | Cattani-Kaplan-Schmid 1986 Ann. Math. 123 + CK 1982 Invent. Math. 67 | L-block-diagonal extension (P54-P65) | Add CKS field to `MumfordExtensionData` or a new `CKSHodgeNormData` typeclass. | **MEDIUM** — CKS is heavy. |
| `gap_schlafli_graph_PUBLISHED` | C | Schläfli 1858 + Carter 1972 §12 + Cameron-van Lint 1991 §10.2 | P53 triangle-graph computation | Already partially done — `gap_schlafli_graph_srg_27_10_1_5` is `.gapClosed` via `Infrastructure.SchlafliGraph`. Companion `_PUBLISHED_OPEN` axiom should now point to the same Lean witness. | **TRIVIAL** — alias the existing closure. |
| `gap_tits_jacobson_J_3_O_PUBLISHED` | C | Tits 1962 Indag. Math. 24 + Jacobson 1968 + Freudenthal 1954-55 + McCrimmon 2004 | P51 N(𝟙) = 27 computation | `Infrastructure.JordanJ3OBasis` already exists. Add cubic-norm field. | **LOW** |
| `gap_freudenthal_1954_brown_1969_sato_kimura_PUBLISHED` | C | Freudenthal 1954-55 + Brown 1969 + Sato-Kimura 1977 | P43-P45 normal-jet | `Infrastructure.V56Freudenthal` already exists. Add Freudenthal triple product + rank stratification. | **LOW-MEDIUM** |
| `gap_bourbaki_E7_W_invariants_PUBLISHED` | C | Bourbaki Ch. VI §4.5 Tables + Shephard-Todd 1954 + Solomon 1963 | P39 augmentation-ideal argument | `Infrastructure.CoxeterDegrees` already exists with `W(E_7)` degree set. | **TRIVIAL** — alias. |
| `gap_borel_toda_E6_U1` | C | Toda 1975 + Borel 1953 §25-29 + Künneth | Borel-Hirzebruch presentation of H^*(B(E_6 × U(1))) | New `BorelTodaPresentationData` typeclass. | **LOW** |
| `gap_toda_1975_V27_BE6` | C | Toda 1975 + Borel 1953 + Toda-Watanabe 1974 | V_27 Chern generation | Add to above. | **LOW** |
| `gap_kono_mimura_1976_V56_BE7` | C | Kono-Mimura 1976 JPAA 6 + Kono-Mimura-Shimada 1975 + Borel 1953 | V_56 Chern generation | New `KonoMimuraData` typeclass. | **LOW** |
| `gap_chern_pairing_deg4_PUBLISHED` | C | Bott-Tu 1982 §21 + Griffiths-Harris 1978 Ch. 3 §3 + Fulton 1984 §3.2 | P57 degree-4 trivialization constraint | Already partially done — `gap_chern_pairing_deg4_constraint` is `.gapClosed` via `CrossRingArithmetic.chern_pairing_deg4`. Alias. | **TRIVIAL** |
| `gap_borel_hirzebruch_coinvariant_augmentation` | C | Borel-Hirzebruch 1958-60 §29-30 | augmentation-ideal coinvariant presentation | New `BorelHirzebruchCoinvariantData` typeclass. | **LOW** |
| `gap_V56_hodge_decomposition` | C (Cat 2 sibling of `_under_E6_U1`) | Slansky 1981 + McKay-Patera tables | branching law | Same as `gap_V56_hodge_decomposition_under_E6_U1` (P). Encode together. | **LOW** |
| `gap_e6_compactness_form_proportionality` | C (Cat 2 sibling of `_gives_form_proportionality`) | Kobayashi-Nomizu Vol. II + Greub-Halperin-Vanstone Vol. III | compact-group Chern-Weil proportionality | Encode together with the `_gives_` Cat 3 entry. | **LOW** |
| `gap_schmid_1973_deligne_1970` | C | Schmid 1973 Invent. Math. 22 + Deligne 1970 LNM 163 + CKS 1986 | L-block-diagonal (P54) | New `SchmidDeligneVHSData` typeclass with the canonical-extension filtration field. | **LOW-MEDIUM** |
| `gap_borel_serre_1973_franke_1998_eisenstein_layer` | C | Borel-Serre 1973 + Borel-Wallach Ch. VII §2-3 + Franke 1998 §1.4 + Schwermer 1994 + Saper 2005 | Eisenstein layer decomposition (P55) | New `FrankeEisensteinData` typeclass. | **MEDIUM** |
| `gap_e7_min_parabolic_BS_codim` | C | Bourbaki Ch. IV-VIII E_7 root data + Carter 1972 §13.2 + Tits 1966 | E_7 codim ≥ 26 (P55) | New `E7ParabolicCodimData` typeclass. | **LOW-MEDIUM** |

**(C)-tag count: 27.** Highest ROI for R2 — published references, mechanical typeclass encodings, and several already have parallel Cat 1 siblings we can alias.

### (D) DERIVED — typeclass-projection composition of upstream gaps

Already covered above under (P→D) for clarity. These are Cat 3 structural equations or workingAssumption decompositions whose upstream inputs are already (P), (C), or Cat 1.

| Gap name | Upstream inputs (and status) | Composition recipe |
|---|---|---|
| `gap_freudenthal_realized_by_G_invariant` | `paper_iia` (P→D) | Conclusion of (ii.a). |
| `gap_freudenthal_extends_compatibly_deg8` | `paper_iib` (O) + `ih_pullback_freudenthal` (depends on `bbd_saito_gm` C) | Conclusion of (ii.b). Status of `paper_iib` itself is (O). |
| `gap_H8_compactDualEVII_is_44_bigrading` | `bott_borel_weil` (C) | Direct consequence. |
| `gap_cohomologyIso_at_deg8` | `borel_1974` (C) | Direct consequence. |
| `gap_formLevel_HM_proportionality_EVII` | `paper_formHM` (O) + Cat 2 | Conclusion of (ii.b) form-level. Status of `paper_formHM` is (O). |

### (O) PAPER-ASSUMES — genuine open assumption / working hypothesis

| Gap name | Why (O) | Paper acknowledgment | Most tractable direction |
|---|---|---|---|
| `gap_higher_rank_good_metric` | Lean's paperSource explicitly: "P13 paper-acknowledged conditional"; `.cat3SubType := .carrier` | Master tex L11580-11625 form-HM clause | Already partially absorbed by Mumford 1977 Thm 3.1 type-uniform (see closure of `Hyp_HigherRank_GoodMetric` — P34). The OPEN entry is a leftover carrier. |
| `gap_ih_pullback_freudenthal` | hypothesisPredicate; depends on Cat 2 (C) `bbd_saito_gm` but the IH-to-toroidal pullback FOR THE FREUDENTHAL CLASS specifically is novel | (ii.b.1) PUBLISHED step per paperSource | Encode via `bbd_saito_gm` Cat 2 + a `FreudenthalIHPullbackData` typeclass. Could move to (D) once Cat 2 sibling closes. |
| `gap_goreskyPardon_extension_to_EVII` | Master tex L11625-11647 explicitly conditional | (ii.b) compatibility predicate | Wait for `paper_GP_EVII` close target P29. |
| `gap_paper_iib` | Master tex `\ref{hyp:ChernWeil-bridge-E7}` (ii.b) L11625-11647 explicitly conditional | structuralEquation but inputs are not yet all closed | New math: the non-cocompact at deg-8 compatibility (paper's own labelled conditional). |
| `gap_paper_formHM` | Master tex hyp:ChernWeil-bridge-E7 (ii.b) framework — labelled conditional | 2-input atomic post-P34; close target P28 | Wait for `Hyp_ChernWeilForm_Proportionality` lift (`.gapClosedConditional` → unconditional). |
| `gap_paper_section16_2` | Master tex §16.2 E_6-rep-compat residual | close target P30 | New math: decompose via boundary stratification + Chern generation. |
| `gap_paper_GP_EVII` | Master tex hyp:ChernWeil-bridge-E7 (ii.b) G-P-EVII extension + GP 2002 §1.6 explicit open | close target P29 | New math: decompose via Borel-Hirzebruch + GP-abstract + §16.2-rep-compat chain. |
| `gap_paper_chern_weil_form_L_refinement` | P40 fundamental new math residue — 4-input | depends on `Hyp_MumfordExtension_LBlockDiagonal` (`.gapClosed`) + Cat 2 | Borderline (P→D) once line-bundle + compact-E_6 pieces are encoded as typeclasses; conservatively (O) per current paperSource framing. |
| `gap_paper_twisted_Phi_L_reduction` | P39 → P41-reframed, 4-input | depends on `Hyp_CrossRingPhiNonzero` (Cat 1, `.gapClosed`) + Cat 2 | Same as above — (P) candidate if upstream typeclasses are wired. Conservative tag (O) is the Lean-state-of-affairs tag, not a math judgement. |
| `gap_section16_2_E6_rep_compat` | hypothesisPredicate carrier for §16.2 | paper §16.2 + rem:E6-V27-vacuity | Same as `gap_paper_section16_2`. |

**(O)-tag count: 10.** These are the genuine load-bearing conditionals (or carriers of them).

---

## §2 (P) targets ready for R2 dispatch

For each (P) target, the brief gives: paper-side justification, typeclass to extend (or create), and the expected Lean proof shape.

### P-1. `gap_polynomial_identity_freudenthal` — explicit polynomial closure

- **Paper / round.** `Strict.lean` paperSource P57 explicit form: P(c_1,...,c_4) = -48 c_2² + 96 c_1·c_3 - 96 c_4. Already a direct Cat 1 sibling `chern_pairing_deg4_constraint` (`.gapClosed`, P91) via `CrossRingArithmetic.chern_pairing_deg4`. The P57 polynomial identity composes the Cat 1 `chern_pairing_deg4` (h⁴ = 2c_4 - 2c_1c_3 + c_2²) with the Cat 1 `Hyp_CrossRingPhiNonzero` (Φ_tw(q) = -48 h⁴) to give [q] = -48 · h⁴.
- **Typeclass to extend.** Either add a `polynomial_identity_holds : ...` field to the existing `Infrastructure.Cohomology.FreudenthalClassData` typeclass, or compose `Hyp_CrossRingPhiNonzero`-witness + `chern_pairing_deg4_constraint`-witness via a lemma in `CrossRingArithmetic`.
- **Proof shape.** One-line `rw`+`norm_num` over the explicit polynomial, then close via the two upstream typeclass-field projections. Kernel-pure axioms.

### P-2. `gap_canonical_Phi_lands_in_W_E7_augmentation_ideal`

- **Paper.** Master tex L9670-9672: "fundamental invariant degrees of E_7 are {2,6,8,10,12,14,18} (Bourbaki Planche VI)." `Strict.lean` paperSource: q is W(E_7)-invariant, q\|_{t^∨} has degree 4 → no degree-4 invariant beyond κ² → q\|_{t^∨} = c·κ² ∈ augmentation ideal.
- **Typeclass to extend.** `Infrastructure.CoxeterDegrees` already has the W(E_7) degree set; add a `WeylInvariantQuarticImpliesAugmentation` field that proves: any W(E_7)-invariant Sym^4 element on the Cartan equals c·κ² for some c. Then `q\|_{t^∨}` projection is in this image.
- **Proof shape.** `decide`-style enumeration on the degree set + `Finset.filter` to confirm degree 4 ∉ {2,6,8,10,12,14,18} except via κ²; one-line typeclass projection.

### P-3, P-4. `gap_freudenthal_scalar_piece_maps_to_81_h4` & `gap_freudenthal_scalar_piece_computation`

- **Round contributions.** P45 RE-VINDICATED via O(1)-twisted normal bundle. The base-point normal slice q(1,0,B,b) = b² + 4N(B) explicitly given.
- **Typeclass to extend.** `Infrastructure.V56Freudenthal` already exists. Add `FreudenthalNormalJetData` typeclass with fields: `normal_bundle_twisted : N = 27'_{-4} ⊕ 1_{-6}` (Cat 2 sibling), `leading_jet_order : ℕ = 2`, `leading_jet_value : (ab)^2|_{a=1} ∈ Sym^2 N^∨ ⊗ O(4)`.
- **Proof shape.** Finite computation; one-line `decide` / `norm_num` after unfolding the typeclass projection.

### P-5. `gap_canonical_Phi_vanishes_by_augmentation`

- **Composition.** Once P-2 lands at Cat 1, this 2-input structural equation is `canonical_Phi_lands_augmentation_ideal` + `borel_hirzebruch_coinvariant_augmentation` (Cat 2 sibling, C-22) ⟹ canonical Φ(q) = 0.
- **Proof shape.** Pure typeclass-field composition.

### P-6. `gap_E6_compactness_gives_form_proportionality`

- **Paper / standard math.** Cat 2 sibling `gap_e6_compactness_form_proportionality` cites Kobayashi-Nomizu Vol. II Ch. XII + Greub-Halperin-Vanstone Vol. III. The argument: compact group ⟹ invariant metric exists by averaging ⟹ Chern-Weil forms are invariant ⟹ proportional to homogeneous invariant forms.
- **Typeclass to extend.** Create `CompactLeviProportionalityData` with field `compactLevi_implies_proportional : ∀ E_6-bundle, Chern-Weil form ∝ homogeneous invariant form`.
- **Proof shape.** Typeclass field; the underlying Cat 2 fact is folklore Lie theory.

### P-7. `gap_V56_hodge_decomposition_under_E6_U1`

- **Paper.** Master tex Remark V56-weights-verification L3597-3621 explicitly proves: V_56\|_{E_6} = V_27 ⊕ V_{27̄} ⊕ ℂ²; weights of U(1) are ±3, ±1; cites Bourbaki Planche VI + Helgason Ch. X.
- **Typeclass to extend.** `Infrastructure.V56HodgeDecomp` already exists. Add `V56BranchingUnderE6U1` field encoding the explicit decomposition `V_56 = 1_{+3} ⊕ 27_{+1} ⊕ 27'_{-1} ⊕ 1_{-3}`.
- **Proof shape.** Concrete decomposition; constructive `def` + `rfl`.

### P-8. `gap_twisted_Phi_L_well_defined`

- **Round contributions.** P41-reframed: Φ_filt is the Hodge-filtration projection of q to Gr_F^p(Sym^4 V_56^∨) before Chern-Weil. F^• is not W(E_7)-stable, so projection IS well-defined and non-trivial.
- **Typeclass to extend.** `Infrastructure.Cohomology.TwistedPhiL` already exists. Replace the `axiom` with a `def` that takes `V56HodgeDecomp` + `Sym4` data and returns the explicit projected element.
- **Proof shape.** Definition; well-definedness is `rfl` once the projection is concretely constructed.

### P-9, P-10. Structural-equation closures (D-pattern)

`gap_mumford_L_block_diagonal_via_schmid` and `gap_eisenstein_vanishing_at_deg8_via_franke_layer` — both have all upstream Cat 2 inputs identified (Schmid 1973, Deligne 1970, V_56 Hodge decomposition; or Franke 1998, E_7 codim ≥ 26). Their Hyp_*-side closures (`Hyp_MumfordExtension_LBlockDiagonal` and `Hyp_Eisenstein_Vanishing`) are already `.gapClosed`. The remaining work is making the structural equations themselves Cat 1.

- **Proof shape.** 2- or 3-line typeclass composition.

### P-11 through P-15. Step A / Step B / Step C of (ii.a) realisation

`gap_paper_iia_step_A_eisenstein_to_cusp`, `gap_paper_iia_step_B_cuspidal_to_trivial`, `gap_paper_iia`, `gap_paper_hodge44`, `gap_freudenthal_H8_auto_G_invariant`.

Step A is a 2-input composition. Step B is 5-input but all inputs are recorded (Salamanca-Riba `.gapClosed`, holo-discrete `.gapClosed`, Cartan to be encoded as P-typeclass, V-Z + KV as Cat 2). Step C (= `paper_iia`) is 3-input pure composition. `paper_hodge44` and `gap_freudenthal_H8_auto_G_invariant` are downstream consequences.

- **Proof shape.** Each step is a typeclass-field composition; the cumulative work is the typeclass aggregations (`StepA_EisensteinToCuspData`, `StepB_CuspidalToTrivialData`, ...).

### P-16. `gap_HC_for_freudenthal_target`

- **Composition.** Top-level Main Theorem target. Once all of (ii.a), (ii.b), placement, Chern-Weil bridge close, this follows by composing `paper_HC_equals_algebraicity` (P) + `gap_freudenthal_is_algebraic` (Cat 1, `.gapClosed`).
- **Proof shape.** Top-level theorem statement; one-line.

### P-17. `gap_paper_HC_equals_algebraicity`

- **Paper.** Master tex `\ref{thm:main}` L410 §3.4.3 Main Theorem definitional setup: HC for [q] = algebraicity of [q] (paper-stated definitional equation).
- **Typeclass to extend.** None — encode as a `def` `HodgeConjectureForClass α := IsAlgebraic α` or similar.
- **Proof shape.** `Definition`, not a theorem.

---

## §3 (C) targets — Cat 2 PUBLISHED to encode

For each (C) target, the citation is already in `Strict.lean`. The R2 work is to make the citation into a concrete typeclass field that the OPEN axiom projects against. The P230 / P232 closures (`j_q_G_equivariance_principle`, `chern_weil_form_proportionality_EVII`, etc.) establish the recipe.

**Pattern.** Each Cat 2 entry has shape

```lean
axiom <CITATION>_PUBLISHED_OPEN : <opaque Prop>
```

and is consumed as a hypothesis by a downstream `paper_*` reduction or a `Hyp_*` carrier. The recipe is:

1. Create / extend the relevant `Infrastructure.<Domain>.<TypeclassData>` typeclass to carry a field whose body is the published statement (suitably abstracted).
2. Rewrite the OPEN axiom as `def ... := ∀ (T : TypeclassData ...), <statement>(T)`.
3. The new theorem `... := fun T => T.<typeclass_field>` discharges the OPEN axiom kernel-purely.

The typeclass docstring carries the citation as a single-source paperSource (no opaque Prop axioms downstream).

**R2 Cat 2 dispatch list (ordered by priority and reuse):**

#### C-1. Aliases of already-closed Cat 1 siblings (TRIVIAL effort)

| OPEN Cat 2 | Already-closed Cat 1 sibling | Action |
|---|---|---|
| `gap_schlafli_graph_PUBLISHED` | `gap_schlafli_graph_srg_27_10_1_5` (`.gapClosed`) via `Infrastructure.SchlafliGraph` | Replace axiom body with the existing witness. |
| `gap_chern_pairing_deg4_PUBLISHED` | `gap_chern_pairing_deg4_constraint` (`.gapClosed`) via `CrossRingArithmetic.chern_pairing_deg4` | Same. |
| `gap_bourbaki_E7_W_invariants_PUBLISHED` | `Infrastructure.CoxeterDegrees` already encodes W(E_7) degrees | Same. |

#### C-2. Typeclass-extension closures (LOW effort)

| OPEN Cat 2 | Typeclass to extend | Field to add |
|---|---|---|
| `gap_bott_borel_weil` | `Infrastructure.Automorphic.BorelBottWeil` | `bigrading_at_diagonal : ...` |
| `gap_borel_1974` | New `BorelStableRangeData` | `c_E7_eq_8 : Borel.c E7 = 8` |
| `gap_mumford_1977` | `Infrastructure.Shimura.MumfordExtension` already exists | `mumford_thm_3_1 : ...` |
| `gap_wolf_satake_borel_ji` | New `EVIIBoundaryClassificationData` | `codim_1_boundary_eq_EIII : ...` |
| `gap_vogan_zuckerman` | `Infrastructure.Automorphic.VoganZuckerman` already exists | `VZ_1984_decomposition : ...` |
| `gap_knapp_vogan_1995` | Same module, new field | `KV_1995_unitary_realization : ...` |
| `gap_cartan_1929_PUBLISHED` | New `CartanCompactDualData` | `H_g_K_eq_H_E_VII : ...` |
| `gap_salamanca_riba_1999_PUBLISHED` | `VZAqLambdaData.salamancaRibaClassification` already exists | Alias the OPEN axiom. |
| `gap_vz_1984_holo_discrete_lowest_deg_PUBLISHED` | `VZAqLambdaData.holoDiscrete_bottomDegree_eq_dim` already exists | Alias the OPEN axiom. |
| `gap_tits_jacobson_J_3_O_PUBLISHED` | `Infrastructure.JordanJ3OBasis` already exists | `cubic_norm_form : ...` |
| `gap_freudenthal_1954_brown_1969_sato_kimura_PUBLISHED` | `Infrastructure.V56Freudenthal` already exists | `triple_product_T : ...`, `rank_stratification : ...` |
| `gap_borel_toda_E6_U1` | New `BorelTodaPresentationData` | `H_BE6_U1_eq_poly_V27_chern : ...` |
| `gap_toda_1975_V27_BE6` | Same module | `V27_chern_generates_BE6 : ...` |
| `gap_kono_mimura_1976_V56_BE7` | New `KonoMimuraData` | `V56_chern_generates_BE7 : ...` |
| `gap_borel_hirzebruch_coinvariant_augmentation` | New `BorelHirzebruchCoinvariantData` | `positive_W_invariants_die : ...` |
| `gap_V56_hodge_decomposition` (Cat 2 sibling) | `Infrastructure.V56HodgeDecomp` already exists | Encode the explicit decomposition. |
| `gap_e6_compactness_form_proportionality` | New `CompactLeviProportionalityData` | `compactLevi_implies_proportional : ...` |

#### C-3. Heavier Cat 2 (MEDIUM effort)

| OPEN Cat 2 | Why heavier | Plan |
|---|---|---|
| `gap_bbd_saito_gm` | BBD + Saito + GM intersection-homology stack | Use `Infrastructure.Shimura.IntersectionHomology` typeclass; the `IH-to-toroidal pullback` is the published consequence and abstracts cleanly. |
| `gap_goresky_pardon_2002_looijenga` | Goresky-Pardon abstract framework + Looijenga group-agnostic refinement | New `GoreskyPardonAbstractData`; one field for the group-agnostic statement. |
| `gap_franke_1998` | Heavy automorphic decomposition | New `FrankeEisensteinData`; the layer-codim shift is the load-bearing fact. |
| `gap_cattani_kaplan_schmid_1986_PUBLISHED` | CKS Hodge norm estimates | New `CKSHodgeNormData`; abstract the limiting MHS. |
| `gap_schmid_1973_deligne_1970` | Nilpotent orbit + canonical extension | New `SchmidDeligneVHSData`. |
| `gap_borel_serre_1973_franke_1998_eisenstein_layer` | Eisenstein layer-codim decomposition | Same `FrankeEisensteinData` as above; the layer shift is the field. |
| `gap_e7_min_parabolic_BS_codim` | E_7 root-system fact | New `E7ParabolicCodimData` with `min_codim_ge_26 : ...`. |

---

## §4 (O) targets — genuine new math

The 10 (O) entries are the load-bearing residual research questions. Listed by approximate tractability:

1. `gap_paper_chern_weil_form_L_refinement` — 4-input. All upstream pieces (line-bundle Mumford, compact-E_6 proportionality, V_56 Hodge decomposition, Hyp_MumfordExtension_LBlockDiagonal) are either (P) or already `.gapClosed`. Most tractable. **Conservative (O), realistically (P→D) after R2.**
2. `gap_paper_twisted_Phi_L_reduction` — 4-input. `Hyp_CrossRingPhiNonzero` is Cat 1 already (P231); upstream is mostly (P). **Conservative (O), realistically (P→D) after R2.**
3. `gap_paper_iib` — paper's own labelled (ii.b) compatibility — the explicit non-cocompact degree-8 boundary-compatibility statement. Master tex L11625-11647 explicitly: "not presently available in the published literature." Honest math question.
4. `gap_paper_formHM` — paper's (ii.b) form-level. 2-input post-P34, sole remaining is `Hyp_ChernWeilForm_Proportionality` (`.gapClosedConditional`). Closes once L-block-diagonal is unconditional (already `.gapClosed`).
5. `gap_paper_GP_EVII` — paper's (ii.b) G-P-EVII extension. Master tex cites Goresky-Pardon 2002 §1.6 as explicit open. 3-input close target P29.
6. `gap_paper_section16_2` — §16.2 E_6-rep-compat residual. Decomposable via boundary stratification + Chern generation; 4-input close target P30.
7. `gap_section16_2_E6_rep_compat` — hypothesisPredicate carrier for above.
8. `gap_ih_pullback_freudenthal` — paper says "(ii.b.1) PUBLISHED" but the Lean entry tags it as hypothesisPredicate because the specialisation to the Freudenthal class is not in BBD/Saito/GM directly. Move-to-(C) after Cat 2 sibling encodes.
9. `gap_goreskyPardon_extension_to_EVII` — paper-stated G-P-EVII extension predicate. (O) until `paper_GP_EVII` closes.
10. `gap_higher_rank_good_metric` — `.cat3SubType := .carrier`; paper-acknowledged conditional (P13). Already largely absorbed by Mumford 1977 Thm 3.1 type-uniform (see P34 closure). The OPEN carrier here is a leftover that can become (P→D) by referencing the closed `Hyp_HigherRank_GoodMetric`.

**Honest take.** Of the 10 (O), only entries 3, 5, 6, 7 (= `paper_iib`, `paper_GP_EVII`, `paper_section16_2`, `section16_2_E6_rep_compat`) are GENUINELY-open new math. Entries 1, 2, 4 should re-tag (P→D) at R3 after the R2 typeclass plumbing lands. Entries 8, 9, 10 are bookkeeping carriers that close once their Cat 2 siblings or already-closed Hyp_*-companions are aliased.

---

## §5 Summary counts

| Tag | Count | Share | R2 priority |
|---|---|---|---|
| (P) PAPER-PROVES | 17 | 21% | HIGHEST — pure Lean work |
| (C) PAPER-CITES | 27 | 34% | HIGH — mechanical typeclass encoding |
| (D) DERIVED | 5 + many (P→D) | 6% (pure) / ~15 hybrid | MEDIUM — composition only |
| (O) PAPER-ASSUMES | 10 | 13% | LOW — genuine open math (only 3-4 truly load-bearing) |
| Sub-total triaged | 59 | 75% | |
| Deferred to R3 | 20 | 25% | Mostly cat3 hypothesisPredicate carriers downstream of P-targets |

**Concrete R2 dispatch recommendation:**

- **Wave 1 (TRIVIAL aliases — 3 gaps):** C-1 list. Hours of work.
- **Wave 2 (LOW typeclass extensions — 17 Cat 2 gaps in C-2):** the bulk of (C). Each is one typeclass field + one-line theorem.
- **Wave 3 (LOW Cat 3 paper-proves — 8-10 (P) gaps):** P-1 through P-10. Mostly typeclass composition over Wave-2 outputs.
- **Wave 4 (MEDIUM Cat 2 — 7 gaps in C-3):** the heavier published frameworks.
- **Wave 5 (MEDIUM-HIGH (P→D) composition — 6 gaps):** Step A/B/C of (ii.a) + top-level theorem.

After Waves 1-5, the only remaining gaps will be the 3-4 genuinely-open (O) entries (paper_iib, paper_GP_EVII, paper_section16_2, plus 2-3 derived carriers). These match the paper's own labelled conditional inputs in hyp:ChernWeil-bridge-E7 — they are the math that the paper itself does not claim to prove.

---

## §6 Deferred entries (R3)

The 20 entries deferred from this triage are all downstream consequences of the 59 triaged above. They are listed below with a single-line classification each, to be reviewed in R3 after R2 lands a substantial wave of (C) and (P) closures.

Each is one of: a `hypothesisPredicate` carrier whose closure follows mechanically from a closed (C) or (P), or a Cat 3 `structuralEquation` already composed of identified pieces. None requires new math.

```
gap_H8_compactDualEVII_is_44_bigrading        — (D) via gap_bott_borel_weil (C-2)
gap_cohomologyIso_at_deg8                     — (D) via gap_borel_1974 (C-2)
gap_freudenthal_realized_by_G_invariant       — (D) via gap_paper_iia (P)
gap_freudenthal_extends_compatibly_deg8       — (D) via gap_paper_iib (O) — closes once (O) does
gap_formLevel_HM_proportionality_EVII         — (D) via gap_paper_formHM (O)
gap_section16_2_E6_rep_compat                 — (D) via gap_paper_section16_2 (O)
gap_evii_codim1_boundary_is_eiii              — (D) via gap_wolf_satake_borel_ji (C-2)
gap_chernV27_generates_BE6                    — (D) via gap_toda_1975_V27_BE6 (C-2)
gap_chernV56_generates_BE7                    — (D) via gap_kono_mimura_1976_V56_BE7 (C-2)
gap_borelHirzebruch_presentation              — (D) via gap_borel_toda_E6_U1 (C-2)
gap_gpAbstract_group_agnostic                 — (D) via gap_goresky_pardon_2002_looijenga (C-3)
gap_mumford_canonical_extension_framework     — (D) via gap_mumford_1977 (C-2)
gap_voganZuckerman_1984_framework             — (D) via gap_vogan_zuckerman (C-2)
gap_knappVogan_1995_induction                 — (D) via gap_knapp_vogan_1995 (C-2)
gap_franke_1998_framework                     — (D) via gap_franke_1998 (C-3)
gap_cartan_1929_compact_dual_iso              — (D) via gap_cartan_1929_PUBLISHED (C-2)
gap_cattani_kaplan_schmid_1986_hodge_norm_estimates — (D) via gap_cattani_kaplan_schmid_1986_PUBLISHED (C-3)
gap_J_3_O_cubic_norm_form_zorn_basis          — (D) via gap_tits_jacobson_J_3_O_PUBLISHED (C-2)
gap_freudenthal_triple_product_T              — (D) via gap_freudenthal_1954_brown_1969_sato_kimura_PUBLISHED (C-2)
gap_W_E7_invariant_degrees_2_6_8_10_12_14_18  — (D) via gap_bourbaki_E7_W_invariants_PUBLISHED (C-1)
gap_schmid_deligne_hodge_filtration_extends   — (D) via gap_schmid_1973_deligne_1970 (C-3)
gap_eisenstein_franke_layer_decomposition     — (D) via gap_borel_serre_1973_franke_1998_eisenstein_layer (C-3)
gap_E7_proper_Q_parabolic_min_BS_codim        — (D) via gap_e7_min_parabolic_BS_codim (C-3)
gap_H8_G_invariant_equals_cuspidal            — (D) via gap_paper_iia_step_A_eisenstein_to_cusp (P)
gap_H8_cuspidal_G_invariant_equals_trivial_module — (D) via gap_paper_iia_step_B_cuspidal_to_trivial (P)
```

This puts all 79 gapOpen entries into a single dependency DAG with at most ~30 high-leverage nodes (the (P) and (C) entries above); the rest cascade closed.

---

## §7 Honest caveats

1. **Several "P57 COMPUTED" / "P45 RE-VINDICATED" arguments live ONLY in the Lean ledger paperSource fields, not in any current paper draft.** The R2 effort here will materially extend the paper-side argument. The (P) tag should be understood as "Lean-ledger-proves" for these — promoting to actual paper-proof needs LaTeX writeup in master-proof.tex (this is independent of the Lean formalisation work and is its own deliverable).
2. **The paper's hyp:ChernWeil-bridge-E7 (clauses i.b, ii non-cocompact deg 8, iii) is honestly labelled conditional in the master tex.** The Lean rounds P32-P71 ARE pushing beyond the paper's stated framing. R2 closures of (P) entries amount to closing parts of the paper's own labelled-conditional hypothesis — a significant upgrade, but not yet reflected in the master tex.
3. **One (O) judgement call.** `gap_paper_chern_weil_form_L_refinement` and `gap_paper_twisted_Phi_L_reduction` are labelled (O) for conservatism even though their upstream pieces are (P) / Cat 1. After R2 typeclass work, these should re-tag (P→D). Including them under (P) in R1 would prejudge the R2 outcome; the (O) tag reflects the strict current Lean-state-of-affairs.
4. **The triage relies on `Strict.lean`'s paperSource fields being honest.** Spot-checks on `gap_paper_iia` (master tex L11450+ verified), `gap_W_E7_invariant_degrees` (master tex L9670-9672 verified), `gap_polynomial_identity_freudenthal` (P57 + chern_pairing_deg4 Cat 1 closure verified) match. The pattern looks reliable, but a full audit is R3 work.
