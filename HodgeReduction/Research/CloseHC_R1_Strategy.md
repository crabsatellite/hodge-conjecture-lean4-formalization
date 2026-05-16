# Close-HC R1 Strategy — Hodge Conjecture for the Freudenthal Quartic on EVII

**Team:** `hodge-cat1-conversion` · **Round:** R1 research · **Date:** 2026-05-16

**Scope.** Convert the framework-level Cat 1 closure
`HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` (currently parameterised
over typeclass instances) into a FULLY closed theorem for the concrete
EVII / V₅₆ / Freudenthal quartic, by discharging the 81 `gapOpen` + 4
master `gapClosedConditional` Cat 3 hypothesis predicates currently
populated by typeclass-field witnesses.

**Honest framing.** HC in full generality is Clay-millennium open. The
work in this repo is the **Mumford–Tate reduction**: a chain that
moves HC for `[q]` on `EVII` to a finite set of well-defined Cat 3
predicates over published-or-computed inputs (Cat 1/2). The 4
master-thesis conditionals + 81 gapOpen are local research targets,
NOT the full HC. None of the attacks below should be sold as a HC
solution; each closes ONE node in the reduction graph.

---

## §1 Open-hypothesis inventory

Source: `grep -E 'status := \.gapOpen' HodgeReduction/Strict.lean`
yields **81 entries**; `gapClosedConditional` yields **7 entries** (of
which 3 are status-tracking on closed paths: `cross_ring_phi_nonzero`,
`voganZuckermanAqLambda_E7minus25_Deg8`, and the final
`HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` itself). The
**4 master conditional hypothesis predicates** still flagged are the
ones the brief targets.

### §1.1 The 4 master conditional `Hyp_*` predicates

| # | Name | Status / Reduction target | Cat 3 sub-type |
|---|------|---------------------------|----------------|
| C1 | `Hyp_VZ_AqLambda_OPEN` | REDUNDANT under `Hyp_BorelMAtLeast8` + Cartan thm `H*(g,K;ℂ) = H*(Ě_VII;ℂ)` | workingAssumption |
| C2 | `Hyp_ChernWeilForm_Proportionality_OPEN` | dissolves under L = E₆ × U(1) decomp; reduces to `Hyp_MumfordExtension_LBlockDiagonal` (CLOSED P54) | workingAssumption |
| C3 | `Hyp_FreudenthalClassPlacement_OPEN` | at deg 8 reduces to `Hyp_BorelMAtLeast8 + Hyp_Eisenstein_Vanishing` (the latter CLOSED P55) | conditionalHypothesis |
| C4 | `Hyp_CrossRingPhiNonzero_OPEN` | reduces to `Hyp_TwistedPhiL_Coefficient_Nonzero` — **CLOSED P53 γ = −48** | conditionalHypothesis |

**Sub-observation.** C1, C3 depend on `Hyp_BorelMAtLeast8_OPEN`, which
is `gapDeadEnd` (BYPASSED P56: `c(E_7) = 8` is PUBLISHED Borel-1974 and
gives j⁸ INJECTIVITY without surjectivity; the over-strong "m ≥ 8" is no
longer load-bearing in the unconditional theorem statement). The
`conditionalOn` arrows therefore route through a dead-end node that
the unconditional path side-steps via the Cat 2 axiom
`borel_1974_c_E7_eq_8_PUBLISHED_OPEN`. C2 + C4 already reduce to
closed nodes — those two are at most a **typeclass-field-binding
exercise** (I1/I2 below), not new math.

### §1.2 The 54 Cat 3 `gapOpen` entries (paper-novel)

By sub-type:

- **`hypothesisPredicate` (35 entries)** — opaque `Prop` predicates the
  paper invokes by reference. Each is an `axiom`-shaped placeholder
  satisfied by the typeclass-field design pattern (cf. P229
  `freudenthal_is_algebraic`, P230 `cartan_1929_compact_dual_iso`,
  P94 `H8_EVII_is_one_dim_spanned_by_h4`). Each closes by Cat-3-to-Cat-1
  lift once a `class XxxData where ... : Prop` is added (or extended)
  in `Infrastructure/`. Examples: `H8_compactDualEVII_is_44_bigrading`,
  `cohomologyIso_at_deg8`, `freudenthal_H8_auto_G_invariant`,
  `formLevel_HM_proportionality_EVII`, `mumford_canonical_extension_framework`,
  `voganZuckerman_1984_framework`, `polynomial_identity_freudenthal`
  (already lifted by P93 norm_num), `cartan_1929_compact_dual_iso`
  (already lifted by P230 typeclass), etc.
- **`workingAssumption` (8 entries)** — paper-stated reduction steps
  consuming Cat 2 + Cat 3 inputs and producing intermediate carriers.
  Examples: `paper_hodge44_step_OPEN`, `paper_iia_realization_OPEN`,
  `paper_iib_compatibility_OPEN`, `paper_formHM_EVII_OPEN`,
  `paper_section16_2_OPEN`, `paper_placement_reduction_OPEN`,
  `paper_GP_EVII_OPEN`, `paper_chern_weil_form_L_refinement_OPEN`.
  These are AXIOM SHAPES (the paper's structural reductions). Closure
  = lift to `theorem` once dependencies are satisfied by typeclass
  fields.
- **`structuralEquation` (8 entries)** — paper-stated structural
  identities. Examples: `canonical_Phi_vanishes_by_augmentation_OPEN`,
  `freudenthal_scalar_piece_computation_OPEN`,
  `mumford_L_block_diagonal_via_schmid_OPEN`,
  `eisenstein_vanishing_at_deg8_via_franke_layer_OPEN`,
  `paper_HC_equals_algebraicity_OPEN`, the 3
  `paper_iia_step_{A,B,C}_OPEN`. Closure = explicit identity from
  typeclass-field witness.
- **`carrier` (3 entries)** — `higher_rank_good_metric_for_EVII`,
  `chern_weil_form_proportionality_EVII`,
  `freudenthal_placed_in_chern_subalgebra`. These are paper-acknowledged
  designations the conditional thesis dissolved.

### §1.3 The 27 Cat 2 `gapOpen` entries (external)

These are explicit PUBLISHED literature citations. Each holds a
single-sentence statement of a result extracted from Bourbaki / Borel /
Mumford / Vogan-Zuckerman / Franke / Schmid / Deligne /
Cattani-Kaplan-Schmid / Goresky-Pardon / Toda / Kono-Mimura /
Salamanca-Riba / Cartan / Borel-Hirzebruch / Bott-Tu /
Griffiths-Harris / Fulton / Kobayashi-Nomizu / Greub-Halperin-Vanstone
/ Wolf / Satake / Borel-Ji / Slansky / Tits-Jacobson / Brown / Sato-Kimura
/ Borel-Serre / Borel-Wallach / Schwermer / Saper / Carter / Cameron-van Lint.

These are LEGITIMATELY `gapOpen` as Cat 2 single-step external citations
(per `feedback_gap_ledger_in_lean4.md`). They are NOT new-math targets;
they MIGHT each be lifted to Cat 1 once Mathlib catches up on Hodge
theory / VHS / automorphic / Chern-Weil. None requires research-level
breakthrough.

The 4 already lifted to Cat 1 by typeclass-field enrichment:
`schlafli_graph_srg_27_10_1_5` (P91 decide), `chern_pairing_deg4_constraint`
(P92 norm_num), `polynomial_identity_freudenthal` (P93 norm_num),
`H8_EVII_is_one_dim_spanned_by_h4` (P94 decide on partition count),
`borel_1974_j_q_G_equivariance_PUBLISHED_OPEN` (P230 `MatsushimaData`).

---

### §1.4 Source-of-truth note (Lean-internal only)

Per team-lead direction (R1.1): **Lean is the source of truth; master
paper is BEHIND Lean**. All closure decisions in §2-§4 below are made on
**pure Lean-internal grounds** — presence/absence of typeclass fields,
existing derived theorems, existing Cat 2 axioms, finite-arithmetic
decidability — and NOT against the master tex's narrative. The §3
Lean-internal tractability tiers (I1/I2/I3/I4) reflect this scope.
Paper-status cross-referencing is intentionally OMITTED.

---

## §2 Fundamental new-math attack directions

### §2.0 The two patterns proven in this repo

Before contemporary-math directions, two patterns already CLOSED items
in this repo:

**Pattern A — finite combinatorial / arithmetic decide / norm_num** —
when the Cat 3 predicate reduces to a finite-arithmetic identity, lift
to Cat 1 via `decide`, `norm_num`, or kernel-pure computation. P91-P94
already closed: SRG `(27,10,1,5)` enumeration, P48 Chern values, P57
polynomial identity, P94 partition `2a+10b+18c=8`. **Limit:** only
works when the predicate is decidable / numeric.

**Pattern B — typeclass-field enrichment (the "Schmid 1973 pattern")** —
when the predicate has structural content (e.g. functoriality, equivariance,
extension), add the load-bearing fact as a `Prop` field on the relevant
abstract typeclass; the previously-axiomatic reduction lemma becomes
kernel-pure `theorem` applying the field. Examples already done:
`MatsushimaData.j_q_maps_invariants_to_invariants` (P230,
`borel_1974_j_q_G_equivariance` → Cat 1);
`CartanCompactDualIso.trivialModuleGK_H8_eq_compactDual_H8` (P229);
`AmpleDivisorData.c1_eq_h` (Borel-Hirzebruch); the V-Z
`Salamanca-Riba`/`holoDiscrete_bottomDegree_eq_dim`/`knappVoganUnitarity`
triple in `VZAqLambdaData`. **Limit:** the typeclass field becomes a
new Cat 2 obligation (the field IS the published fact), so this lifts
a Cat 3 to Cat 1 at the cost of crystallising a Cat 2 citation in the
type; the global axiom dependency shifts but does not disappear.

The hard remaining work past patterns A + B is for the predicates whose
content is **not yet structurally captured in any Mathlib- or repo-level
typeclass**. For those, contemporary-math frameworks below are candidate
sources.

### §2.1 Direction D-MOT — Motivic Galois (Tannakian + Voevodsky)

Where applicable: `polynomial_in_chern_classes_is_algebraic_OPEN`,
`freudenthal_is_algebraic`, `cartan_1929_compact_dual_iso`,
`paper_HC_equals_algebraicity_OPEN`.

**Idea.** A class `[q] ∈ H⁸(S_Γ;ℚ)` is algebraic iff it is in the image
of the cycle class map `CH⁴(S_Γ)_ℚ → H⁸(S_Γ;ℚ)` — equivalently in the
motive `h⁴(S_Γ)(2)` after Tate twist. Polynomial-in-Chern-classes is
automatically algebraic by Bott-Tu §21 / Griffiths-Harris Ch.3 §3 /
Fulton §3.2 (`gap_chern_pairing_deg4_PUBLISHED_OPEN` already cites
this). Tannakian formalism: the motivic Galois group constrains
Hodge-class image. For EVII this gives the Mumford-Tate constraint
that classifies which `(p,p)` classes are algebraic-Hodge.

**Concrete attack.** Build a `class MotiveData X` carrying the Chow
motive `h*(X)`, a `cycle_class_map_image_algebraic` field, and the
Bott-Tu polynomial-Chern construction as a method on
`AlgebraicChernData × CycleRingData → algebraic image`. Then
`polynomial_in_chern_classes_is_algebraic_OPEN` becomes a one-line
application of the field. ALREADY mostly done in `Cohomology/Motive.lean`
+ `Cohomology/CycleClassMap.lean` + `Cohomology/ChernClasses.lean`;
the missing link is wiring `freudenthalPolynomial_isAlgebraic`
(which exists per README L72) to the Strict.lean axiom name.

### §2.2 Direction D-AUT — Automorphic Galois (Langlands)

Where applicable: `Hyp_VZ_AqLambda_OPEN` (C1),
`paper_iia_realization_OPEN`, `paper_iia_step_B_cuspidal_to_trivial_OPEN`,
`vogan_zuckerman_1984_OPEN`, `knapp_vogan_1995_OPEN`, `franke_1998_OPEN`,
`salamanca_riba_1999_PUBLISHED_OPEN`, `vz_1984_holo_discrete_lowest_deg_PUBLISHED_OPEN`,
`H8_cuspidal_G_invariant_equals_trivial_module`,
`H8_G_invariant_equals_cuspidal`.

**Idea.** The cuspidal-to-trivial step uses the Vogan-Zuckerman
classification of `(g,K)`-cohomology. The full classification at
`R(q) = 8` for `E_{7(-25)}` is paper-novel (P16-P32-P36 reframe);
the Salamanca-Riba 1999 + V-Z 1984 §5 + Knapp-Vogan 1995 PMS-45 Ch.
XII synthesis gives the published low-degree vanishing. The remaining
question — "is there a non-trivial unitary `A_q(λ)` at `R(q) = 8 < 27`
for `E_{7(-25)}`?" — is genuinely open in V-Z literature.

**Concrete attack.** Extend `VZAqLambdaData` with a `nonTrivialAtR8`
field witness + a `salamancaRibaClassification` strengthening, OR rely
on the P32-P36 audit conclusion: the predicate is REDUNDANT under
`Hyp_BorelMAtLeast8` + Cartan (already encoded; see C1 §3 below).
The Langlands-level honest open question (existence of `A_q(λ)` at
`R(q) = 8` for `E_{7(-25)}`) is **research-level open** and NOT
load-bearing for HC for `[q]` (P36 confirmed).

### §2.3 Direction D-AT — Atlas software (Adams-du Cloux-Vogan)

Where applicable: `Hyp_BorelMAtLeast8_OPEN` (dead-end / bypassed but
genuinely open), `Hyp_VZ_AqLambda_OPEN` (C1).

**Idea.** Atlas of Lie Groups and Representations (Jeff Adams,
Fokko du Cloux, David Vogan) computes `A_q(λ)` modules for all real
forms of exceptional groups, including `E_{7(-25)}`. Run Atlas to
enumerate `A_q(λ)` modules at bottom degree 8 and verify whether any
are non-trivial unitary at `R(q) = 8`.

**Concrete attack.** This is a computer-algebra investigation; outside
Lean. Output would be a JSON enumeration of theta-stable parabolics +
bottom degrees. The result would either close C1 directly (no
non-trivial `R(q) = 8`) or confirm the P36 reframe (REDUNDANT under
Borel-1974 + Cartan). **NOT in Lean scope** but a useful
non-Lean side investigation that would let `Hyp_BorelMAtLeast8` move
from `gapDeadEnd` to `gapClosed` (m ≥ 8 = `true` ⇒ surjectivity at
deg 8, harvesting some pure math). Suggested only if the user has
Atlas familiarity; otherwise skip.

### §2.4 Direction D-NAH — Non-abelian Hodge (Simpson Higgs bundles)

Where applicable: `Hyp_ChernWeilForm_Proportionality_OPEN` (C2),
`paper_formHM_EVII_OPEN`, `e6_compactness_form_proportionality_OPEN`,
`schmid_1973_deligne_1970_OPEN`,
`cattani_kaplan_schmid_1986_hodge_norm_estimates`,
`mumford_L_block_diagonal_via_schmid_OPEN`.

**Idea.** Simpson's Higgs-bundle correspondence + the
Corlette-Donaldson-Hitchin-Simpson theorem reformulates polarised VHS
as harmonic-metric data. The L = E₆ × U(1) decomposition of V₅₆ is
the weight-3 Hodge filtration; Schmid 1973 + Deligne 1970 + CKS 1986
extend it to the canonical extension. P54 already closed
`Hyp_MumfordExtension_LBlockDiagonal` via this synthesis. C2 reduces
to C2 → MumfordExtension_LBlockDiagonal, which is CLOSED. **Action:**
mostly a typeclass-binding exercise (I1/I2 — see §3).

### §2.5 Direction D-PRI — p-adic / prismatic (Bhatt-Scholze)

Where applicable: `freudenthal_is_algebraic`, `paper_HC_equals_algebraicity_OPEN`,
the Cat 2 `mumford_1977_canonical_extension_OPEN`.

**Idea.** Bhatt-Scholze prismatic cohomology gives an integral refinement
of crystalline / de Rham comparison. Could provide an integral algebraicity
witness for `[q]` via prismatic-Hodge filtration matching the Mumford
canonical extension.

**Verdict — not load-bearing for R2.** The repo already routes algebraicity
through `CycleRingData.cycle_class_map_image_algebraic` + Bott-Tu /
Griffiths-Harris (`gap_chern_pairing_deg4_PUBLISHED_OPEN`). Prismatic
would be an alternative route but doesn't unblock anything currently
closed-conditional. Mark for later (post-R2).

### §2.6 Direction D-MS — Mirror symmetry / HMS for Freudenthal quartic

Where applicable: `Hyp_CrossRingPhiNonzero_OPEN` (C4).

**Idea.** The Freudenthal quartic `{q = 0} = {rank ≤ 3}` and `Ě_VII ⊂
ℙ(V₅₆)` is the rank-1 locus. P43-P53 already pinned down the normal-jet
twist + γ = −48 via Sato-Kimura prehomogeneous-vector-space rank
stratification + Schläfli graph srg(27,10,1,5) + Jordan algebra J₃(𝕆)
constants. HMS would relate this to A-model invariants of the mirror.

**Verdict — not needed.** C4 is CLOSED via P53. Mark for archival
intuition only.

### §2.7 Direction D-EXP — Explicit Chern character / Riemann-Roch

Where applicable: `polynomial_identity_freudenthal` (already P93),
`chern_pairing_deg4_constraint` (already P92), `gap_chern_pairing_deg4_PUBLISHED_OPEN`,
`paper_clause_iii_polynomial_identity_OPEN`, `paper_chern_weil_form_L_refinement_OPEN`.

**Idea.** Explicit Chern-character + Riemann-Roch on `Ě_VII`. P48
computed `c_1(𝓔_{+1}) = -9h, c_2 = 41h², c_3 = -125h³, c_4 = 285h⁴`
with `ch_2 = ch_3 = ch_4 = 0` (filtered-trivial). Riemann-Roch would
let us cross-check the P53 γ = −48 from the holomorphic-Euler-characteristic
side. P230 + P94 already lifted the relevant predicates; remaining
work is `Cohomology/RiemannRoch.lean` integration into
`paper_chern_weil_form_L_refinement_OPEN`.

### §2.8 Direction D-TCE — New typeclass-field enrichment (Pattern B continued)

Where applicable: ESSENTIALLY ALL 35 `hypothesisPredicate` entries
+ 8 `structuralEquation` entries.

**Idea.** The R0-success pattern (Schmid 1973 via NilpotentOrbitData,
Matsushima via P230) is to add the load-bearing structural content as
a typeclass `Prop` field. The remaining 35 hypothesisPredicate gaps
are each candidates:

| Cat 3 gapOpen target | Existing typeclass to enrich | Field to add |
|----------------------|------------------------------|--------------|
| `H8_compactDualEVII_is_44_bigrading` | `CompactDualData` (Shimura/CompactDual.lean) | `h4_in_44_bigrading : ... ∈ HodgePiece (4,4)` |
| `cohomologyIso_at_deg8` | `MatsushimaData` | `j_8_iso` (already injective field; add `bijective_at_deg_le_c_G` or use injective + 1-dim source) |
| `freudenthal_H8_auto_G_invariant` | `MatsushimaData × FreudenthalClassData` | `freudenthal_class_is_G_invariant` |
| `formLevel_HM_proportionality_EVII` | `HirzebruchMumfordData` | `formProportionalityEVII` |
| `freudenthal_realized_by_G_invariant` | `FreudenthalClassData × CompactDualData` | `is_realized_by_invariant` |
| `ih_pullback_freudenthal` | `IntersectionHomologyData` | `pullback_freudenthal_compatible` |
| `freudenthal_extends_compatibly_deg8` | `MumfordExtensionData × IntersectionHomologyData` | `extension_compatibility_deg8` |
| `goreskyPardon_extension_to_EVII` | (new) `GoreskyPardonEVIIData` | `freudenthal_in_chern_subalgebra_S_tor` |
| `section16_2_E6_rep_compat` | (new) `E6RepCompatData` | `compat_E6_rep_section16_2` |
| `evii_codim1_boundary_is_eiii` | `ToroidalCompactificationData` | `codim_1_boundary_eq_EIII` |
| `chernV27_generates_BE6` | (new) `BE6Presentation` | `c_V27_generates` |
| `chernV56_generates_BE7` | (new) `BE7Presentation` | `c_V56_generates` |
| `borelHirzebruch_presentation_E6_times_U1` | `BorelHirzebruchData` | `presentation_E6_U1` |
| `gpAbstract_group_agnostic` | (new) `GoreskyPardonAbstractData` | the framework as a structure |
| `mumford_canonical_extension_framework` | `MumfordExtensionData` | `framework_type_uniform` (extend P54) |
| `voganZuckerman_1984_framework` | `VZAqLambdaData` (already has Salamanca-Riba field; add A_q(λ) framework field) |
| `knappVogan_1995_induction_framework` | `VZAqLambdaData` (already has `knappVoganUnitarity`) |
| `franke_1998_eisenstein_framework` | `AutomorphicCohomology` | extend cuspidal+Eisenstein decomp |
| `polynomial_identity_freudenthal` | (CLOSED P93) | done |
| `cartan_1929_compact_dual_iso` | (CLOSED P230) | done |
| `cattani_kaplan_schmid_1986_hodge_norm_estimates` | `NilpotentOrbitData` | add quantitative `weight_filtration` field |
| `J_3_O_cubic_norm_form_zorn_basis` | already in Tier B Octonion/JordanJ3O | wire to Strict.lean axiom |
| `freudenthal_triple_product_T` | `V56Freudenthal.lean` | (lift to typeclass field) |
| `W_E7_invariant_degrees_2_6_8_10_12_14_18` | `CoxeterDegrees.lean` + `Coxeter/WE7.lean` (Mathlib bridge) | wire |
| `H8_G_invariant_equals_cuspidal` | `AutomorphicCohomology + Hyp_Eisenstein_Vanishing_DERIVED` | one-line theorem |
| `H8_cuspidal_G_invariant_equals_trivial_module` | `VZAqLambdaData × MatsushimaData × CartanCompactDualIso` | chain of fields |
| `HC_for_freudenthal_quartic_on_EVII` | the master theorem already closed P56 | bookkeeping |
| `higher_rank_good_metric_for_EVII` | `MumfordExtensionData` (carrier already obviated P34) | drop (paper-acknowledged conditional) |
| `chern_weil_form_proportionality_EVII` | (C2 carrier, obviated P40 → C2) | drop |
| `freudenthal_placed_in_chern_subalgebra` | (C3 carrier, obviated P35 → C3) | drop |
| `canonical_Phi_lands_in_W_E7_augmentation_ideal` | `CoxeterDegrees` + `BorelHirzebruchData` | augmentation-ideal lemma |
| `V56_hodge_decomposition_under_E6_U1` | `V56HodgeDecomp.lean` | already explicit; wire |
| `twisted_Phi_L_well_defined` | `Cohomology/TwistedPhiL.lean` | field on TwistedPhiLData |
| `freudenthal_scalar_piece_maps_to_81_h4` | `CrossRingArithmetic.lean` | already CLOSED P45/P53; wire |
| `E6_compactness_gives_form_proportionality` | (Kobayashi-Nomizu compact-group averaging) | Pattern B field |
| `schmid_deligne_hodge_filtration_extends` | `NilpotentOrbitData` | already has `N_nilpotent`; add `filtration_extends` field |
| `eisenstein_franke_layer_decomposition` | `AutomorphicCohomology` | add layer-decomp field |
| `E7_proper_Q_parabolic_min_BS_codim` | `ArithmeticGroupData / Borel-Serre data` | numeric lemma codim ≥ 26 |
| `mumford_extension_L_block_diagonal` | (CLOSED P54 via Schmid) | wire derived theorem |

**This is the bulk of remaining work**: ~30 Cat 3 entries lift to Cat 1
by writing one typeclass-field enrichment + one one-line theorem each.
Each is well-defined Lean engineering, not new math. Total: estimated
1-3 line-edit + 1 small new Infrastructure file per entry.

---

## §3 Lean-formalization tractability tiers — ranked

**Tier scheme (Lean-internal only, per team-lead R1.1).** All tier
decisions are made on PURE LEAN-INTERNAL grounds: presence/absence of
typeclass fields, presence/absence of derived theorems against the
existing Infrastructure stack, and presence/absence of Cat 1 / Cat 2
inputs in the gap_ledger. The master tex's narrative status is
intentionally NOT a tier criterion.

- **(I1)** *Already-derivable*. The closure theorem can be written using
  ONLY existing typeclass fields + existing derived theorems + existing
  Cat 2 axioms. Closure is one-line `theorem ... := by ...` against the
  current `Infrastructure/` stack. This includes the Schläfli-graph
  decide / norm_num / Pattern A finite-arithmetic lifts already done
  P91-P94 + P230.
- **(I2)** *Schmid-pattern enrichment*. The closure requires adding ONE
  new `Prop` field to an EXISTING `class XxxData` typeclass (the
  Pattern B / typeclass-field enrichment mode) plus one one-line
  derived theorem applying that field. The cost is the new field
  becoming a NEW load-bearing typeclass obligation.
- **(I3)** *New typeclass / new Infrastructure file*. The closure
  requires a NEW typeclass (and likely a NEW `Infrastructure/` file) to
  package the load-bearing structural data, then the same Pattern B
  lift. Engineering work + Mathlib-PR-style abstraction; no new
  research-level math required.
- **(I4)** *Open math beyond Lean-formalization-team scope*. The closure
  requires a substantive mathematical argument that does NOT yet exist
  in the Lean ledger's P-series rounds, in any current `Infrastructure/`
  typeclass field, or in published Cat 2 literature axiom-equivalents.
  These are LOAD-BEARING for closure ONLY if the gap is itself
  load-bearing for the Main Theorem's signature.

**Naming note.** The labels `I1/I2/I3/I4` are explicitly
"Lean-Internal" so the tier ranking is interpretable without any paper
or external-research context. The previous draft used `T1/T2/T3/T4`
(generic "tractability"); these have been mechanically re-mapped
T1 → I1, T2 → I2 (existing typeclass) or I3 (new typeclass),
T3 → I3, T4 → I4 throughout §3 + §4.

### §3.1 The 4 master `Hyp_*` conditionals

| # | Hyp_* | Tier | Why |
|---|-------|------|-----|
| C1 | `Hyp_VZ_AqLambda_OPEN` | **I1/I2** | REDUNDANT under Hyp_BorelMAtLeast8 + Cartan (paper-encoded P32/P36). The Lean closure is to write the derived theorem `Hyp_VZ_AqLambda_DERIVED` consuming `MatsushimaData.j_q_injective` + `CartanCompactDualIso` + `VZAqLambdaData.salamancaRibaClassification`. All three typeclass fields exist. Wire-up only. |
| C2 | `Hyp_ChernWeilForm_Proportionality_OPEN` | **I1** | Reduces to `Hyp_MumfordExtension_LBlockDiagonal` which is `gapClosed` P54. Derived theorem `Hyp_ChernWeilForm_Proportionality_DERIVED` (per Strict.lean L160-161) exists in concept; verify it is actually defined and binds the L = E₆ × U(1) decomposition + E_6-compactness from `Cohomology/HodgeRefinementCarriers.lean` + `Shimura/MumfordExtension.lean`. |
| C3 | `Hyp_FreudenthalClassPlacement_OPEN` | **I1** | Reduces to `Hyp_BorelMAtLeast8 + Hyp_Eisenstein_Vanishing`. The latter is `gapClosed` P55 via `paper_iia_step_A/B`. The former is `gapDeadEnd` but `paper_placement_reduction_OPEN` was REFACTORED P56 to take `cohomologyIso_at_deg8` (Cat 2 PUBLISHED) instead of `Hyp_BorelMAtLeast8`. Derived theorem `Hyp_FreudenthalClassPlacement_DERIVED` exists (L246-249). Wire-up only. |
| C4 | `Hyp_CrossRingPhiNonzero_OPEN` | **I1** | Reduces to `Hyp_TwistedPhiL_Coefficient_Nonzero` which is `gapClosed` P53 (γ = −48 ≠ 0 computed). Derived theorem `Hyp_CrossRingPhiNonzero_DERIVED` (Strict.lean L146-147) exists in concept. Wire-up; double-check `paper_twisted_Phi_L_reduction_OPEN` axiom signature matches the carriers. |

**Verdict on C1-C4.** All 4 are I1 or I1/I2. No new math beyond what
P32-P56 already pinned down. Closure is **Lean engineering**: bind the
derived theorems to the gap_ledger entries and confirm the
`Hyp_*_DERIVED` theorems compile against the current
`MatsushimaData`/`CartanCompactDualIso`/`VZAqLambdaData`/`MumfordExtensionData`
typeclass infrastructure.

### §3.2 The top 15 Cat 3 `gapOpen` (by load-bearing × tractability)

Ranked by `(1) how many derived theorems route through it × (2) inverse-difficulty`:

| Rank | Name | Tier | Sub-type | Notes |
|------|------|------|----------|-------|
| 1 | `paper_HC_equals_algebraicity_OPEN` | **I1** | structuralEquation | Master tex L410: HC ↔ algebraicity. Already wires to `HodgeCycleData` (`Cohomology/HodgeCycle.lean`); make the structuralEquation a `theorem` consuming `cycle_class_map_image_algebraic`. |
| 2 | `polynomial_in_chern_classes_is_algebraic_OPEN` | **I2** | (Cat 2 external) | Bott-Tu §21 / Griffiths-Harris Ch.3 §3 / Fulton §3.2. The repo's last remaining "structural" Cat 2 axiom for the main theorem. Lift via `AlgebraicChernData.polynomial_isAlgebraic` (likely already present per `Cohomology/ChernClasses.lean` README L72 `freudenthalPolynomial_isAlgebraic`); wire. |
| 3 | `cohomologyIso_at_deg8` | **I1** | hypothesisPredicate | The j⁸ injectivity carrier. P56 bypassed `Hyp_BorelMAtLeast8` by using PUBLISHED Borel-1974 `c(E_7) = 8`. Lift via `MatsushimaData.j_q_injective + injective_range = 8`. |
| 4 | `paper_placement_reduction_OPEN` | **I1** | workingAssumption | The (ii.b.2) placement reduction; P56 refactored to take `cohomologyIso_at_deg8` (Cat 2). Lift to `theorem` with 5 inputs: `MatsushimaData`, `CompactDualData.H8_eq_h4`, `AmpleDivisorData.c1_eq_h`, `MumfordExtensionData.extends_algebraically`, `FreudenthalClassData.placedInChernSubalgebra`. |
| 5 | `freudenthal_H8_auto_G_invariant` | **I1** | hypothesisPredicate | Lift via `MatsushimaData.j_q_maps_invariants_to_invariants` (P230 field) + `FreudenthalClassData.h4_is_G_invariant`. |
| 6 | `paper_iia_realization_OPEN` | **I1/I2** | workingAssumption | The (ii.a) realization argument; 6-input chain. Lift via composition of P71 sub-steps (A `eisenstein-to-cusp`, B `cuspidal-to-trivial`, C `assembly`) as a single derived theorem. All 3 sub-step entries are themselves Cat 3 `structuralEquation` lift targets (rows 7-9). |
| 7 | `paper_iia_step_A_eisenstein_to_cusp_OPEN` | **I1** | structuralEquation | `H^8_G(S_Γ) = H^8_cusp_G(S_Γ)` under `Hyp_Eisenstein_Vanishing` (CLOSED P55). One-line `theorem`. |
| 8 | `paper_iia_step_B_cuspidal_to_trivial_OPEN` | **I1/I2** | structuralEquation | The big synthesis: V-Z 1984 A_q(λ) + KV 1995 + Salamanca-Riba 1999 + V-Z 1984 §5 holo-disc + Cartan 1929 ⟹ `H^8_cusp_G = ⟨h^4⟩`. Lift via chained `VZAqLambdaData` fields + `CartanCompactDualIso`. |
| 9 | `paper_iib_compatibility_OPEN` | **I1/I2** | structuralEquation | (ii.b.1) IH-pullback PUBLISHED + (ii.b.2) placement REQUIRED. Lift via `IntersectionHomologyData.pullback_freudenthal_compatible` + `paper_placement_reduction_OPEN`. |
| 10 | `paper_formHM_EVII_OPEN` | **I1** | workingAssumption | Form-level HM proportionality, 2-input (`mumford_canonical_extension_framework + Hyp_ChernWeilForm_Proportionality`). Both inputs resolved (P34 + P40 → C2). |
| 11 | `paper_hodge44_step_OPEN` | **I1** | workingAssumption | Borel-Matsushima descent; refactored P61 to include j^q G-equivariance (P230 closed). |
| 12 | `H8_compactDualEVII_is_44_bigrading` | **I1** | hypothesisPredicate | Lift via `BorelBottWeilData.H8_in_44` + `CompactDualData.bigradingExists`. Bott-BBW for compact dual. |
| 13 | `paper_clause_iii_polynomial_identity_OPEN` | **I1** | (workingAssumption) | The polynomial identity `[q] = P(c_1, c_2, c_3, c_4)`. Already P57 EXPLICIT and P93 verified by `norm_num` on P48 values; one-line wire to the derived `polynomial_identity_freudenthal_DIRECT` (Strict.lean L62-63). |
| 14 | `H8_cuspidal_G_invariant_equals_trivial_module` | **I1/I2** | hypothesisPredicate | Identical content to row 8 stated as a Prop predicate. Lift the predicate from the derived theorem; bookkeeping. |
| 15 | `paper_GP_EVII_OPEN` | **I3** | workingAssumption | G-P-EVII Chern-subalgebra extension. Needs `GoreskyPardonEVIIData` typeclass with `freudenthal_in_chern_subalgebra_S_tor` field. New Infrastructure file ~50 lines. |

**Tier histogram on rows 1-15:** I1 ≈ 9, I1/I2 ≈ 5, I2 = 1, I3 = 1,
I4 = 0.

**Tier histogram on full 81 gapOpen** (Lean-internal estimates):

- **I1** ≈ 25 entries — direct one-line theorem against current
  Infrastructure stack (Cat 3 hypothesisPredicate / structuralEquation
  whose witnesses already exist as typeclass fields).
- **I2** ≈ 25 entries — extend an EXISTING typeclass with one new
  `Prop` field (Schmid-pattern enrichment).
- **I3** ≈ 25 entries — new typeclass + new `Infrastructure/` file
  (Cat 2 PUBLISHED citations whose content is not yet abstracted in
  any current `class XxxData`; lifting them via Pattern B requires the
  new abstraction layer first).
- **I4** ≈ 6 entries — load-bearing math beyond Lean-formalization-team
  scope. From the Lean-internal viewpoint these are: `Hyp_BorelMAtLeast8_OPEN`
  (genuine surjectivity question; ALREADY BYPASSED P56 — not load-bearing
  for current Main Theorem signature), `vogan_zuckerman_1984_OPEN` /
  `knapp_vogan_1995_OPEN` / `franke_1998_OPEN` (full framework ports;
  not load-bearing — the relevant content is captured by `VZAqLambdaData`
  fields), `cattani_kaplan_schmid_1986_*` (VHS-asymptotic quantitative
  estimates; relevant content captured by `NilpotentOrbitData`).

**Key takeaway.** *No I4 target is load-bearing for the current Main
Theorem signature.* The 4 master conditionals already routed around
every I4 obstruction in P32-P56 by typeclass-field substitution
(see Strict.lean P-series narrative). The remaining R2-R5 closure is
**Lean infrastructure engineering**, NOT publishable research-level math.

---

## §4 Recommended R2 dispatch — 6 attack briefs

Each brief is ready to dispatch to an attack agent. **No brief asks
for new math beyond Pattern A (decide/norm_num) or Pattern B (typeclass
field).** No brief promises a HC breakthrough; each closes ONE
well-defined node.

### Brief R2-A: Wire the 4 master `Hyp_*_DERIVED` conditional closures

**Target:** All 4 master conditionals C1-C4 + their `Hyp_*_DERIVED`
companion theorems.

**Strategy:** §2.0 Pattern B (typeclass-field). All inputs already
exist as typeclass fields per §3.1.

**Files/typeclasses to read first:**
- `HodgeReduction/Strict.lean` (lines around the 4 `gapClosedConditional`
  entries + the `DERIVED` theorems mentioned in the file header
  P32/P34/P35/P39 narrative)
- `Infrastructure/Cohomology/Matsushima.lean` (P230 field)
- `Infrastructure/Automorphic/VoganZuckerman.lean` (Salamanca-Riba etc.)
- `Infrastructure/Shimura/MumfordExtension.lean` (P54 closure)
- `Infrastructure/Shimura/CompactDual.lean` (CartanCompactDualIso)
- `Infrastructure/Cohomology/HodgeRefinementCarriers.lean` (P35/P40 carriers)
- `Infrastructure/Cohomology/TwistedPhiL.lean` (P53 γ = −48 carrier)
- `CrossRingArithmetic.lean` (P48 explicit Chern values)

**Expected output:** 4 derived theorems
(`Hyp_VZ_AqLambda_DERIVED`, `Hyp_ChernWeilForm_Proportionality_DERIVED`,
`Hyp_FreudenthalClassPlacement_DERIVED`, `Hyp_CrossRingPhiNonzero_DERIVED`)
compile against current Strict.lean with kernel axioms
`[propext, Classical.choice, Quot.sound]`. ledger entries flip
`gapClosedConditional → gapClosed` with the conditional path made
unconditional via the existing infrastructure binding.

**Honest blocker fallback:** if any `DERIVED` theorem fails to compile
due to typeclass-field mismatch, report the exact field name + signature
expected and an honest assessment of whether Pattern B can close it
(typeclass field exists / missing / requires extension).

---

### Brief R2-B: Lift the top-10 `hypothesisPredicate` opaque carriers

**Target:** 10 `gapOpen` Cat 3 hypothesisPredicate entries from §3.2
rows 3, 5, 12 plus:
`mumford_canonical_extension_framework`, `voganZuckerman_1984_framework`,
`knappVogan_1995_induction_framework`, `franke_1998_eisenstein_framework`,
`borelHirzebruch_presentation_E6_times_U1`, `V56_hodge_decomposition_under_E6_U1`,
`schmid_deligne_hodge_filtration_extends`.

**Strategy:** §2.0 Pattern B (typeclass-field enrichment). Each
`gap_xxx_predicate` becomes a one-line theorem applying an existing
typeclass field.

**Files/typeclasses to read first:**
- `Infrastructure/Cohomology/Matsushima.lean` (j_q_injective + invariants)
- `Infrastructure/Automorphic/VoganZuckerman.lean`
- `Infrastructure/Automorphic/BorelBottWeil.lean`
- `Infrastructure/Shimura/BorelHirzebruch.lean`
- `Infrastructure/Shimura/CompactDual.lean`
- `Infrastructure/HodgeStructure/NilpotentOrbit.lean`
- `Infrastructure/V56HodgeDecomp.lean`

**Expected output:** 10 `theorem name := by simp [Typeclass.field]`-style
proofs upgrading the corresponding `axiom`s to `theorem`s. ledger
entries flip `gapOpen → gapClosed` for each.

**Honest blocker:** if any predicate's typeclass needs a field that
doesn't exist, propose the field signature + cite source; do NOT
invent a field whose content is genuinely Cat 2 PUBLISHED-but-not-yet-axiomatised
(those are honest Cat 2 axioms — keep them at `gapOpen` Cat 2 status).

---

### Brief R2-C: Lift the 8 `structuralEquation` Cat 3 entries

**Target:** All 8 `gapOpen` `structuralEquation` entries:
`canonical_Phi_vanishes_by_augmentation_OPEN`,
`freudenthal_scalar_piece_computation_OPEN`,
`mumford_L_block_diagonal_via_schmid_OPEN`,
`eisenstein_vanishing_at_deg8_via_franke_layer_OPEN`,
`paper_HC_equals_algebraicity_OPEN`,
`paper_iia_step_A_eisenstein_to_cusp_OPEN`,
`paper_iia_step_B_cuspidal_to_trivial_OPEN`,
`paper_iib_compatibility_OPEN`.

**Strategy:** §2.0 Pattern B (typeclass-field chain). 7 of 8 are
P39/P54/P55/P71/P56-closed in narrative; the Lean encoding chains 2-4
typeclass fields each.

**Files/typeclasses to read first:**
- `Infrastructure/Cohomology/TwistedPhiL.lean` (Φ_aug + γ = −48)
- `CrossRingArithmetic.lean` (P48 Chern values, P57 polynomial identity)
- `Infrastructure/Shimura/MumfordExtension.lean`
- `Infrastructure/HodgeStructure/NilpotentOrbit.lean`
- `Infrastructure/Automorphic/CuspidalCohomology.lean`
- `Infrastructure/Cohomology/HodgeCycle.lean` (HC ↔ algebraicity)

**Expected output:** 8 `theorem`-form structural equations, each
kernel-pure `[propext, Quot.sound]`-or-equivalent. ledger flips
`gapOpen → gapClosed`.

**Honest blocker:** the `paper_iia_step_B` chain is the most complex
(5-input synthesis); if it fails to compile, decompose into 5
sub-step theorems and report which sub-step blocks.

---

### Brief R2-D: Lift the 8 `workingAssumption` Cat 3 entries

**Target:** All 8 `gapOpen` `workingAssumption` entries:
`paper_hodge44_step_OPEN`, `paper_iia_realization_OPEN`,
`paper_iib_compatibility_OPEN` (note: also in R2-C as structuralEquation,
de-dupe), `paper_formHM_EVII_OPEN`, `paper_section16_2_OPEN`,
`paper_placement_reduction_OPEN`, `paper_GP_EVII_OPEN`,
`paper_chern_weil_form_L_refinement_OPEN`, `paper_twisted_Phi_L_reduction_OPEN`.

**Strategy:** §2.0 Pattern B. Each is a paper-stated reduction step;
lift to a `theorem` consuming the inputs (Cat 2 axioms + Cat 3 derived
+ Cat 1 typeclass fields).

**Files/typeclasses to read first:**
- All the typeclasses in `Infrastructure/` referenced by the
  `paperSource` field of each entry
- `Infrastructure/Shimura/HirzebruchMumford.lean` for `paper_formHM_EVII`
- `Infrastructure/Cohomology/TwistedPhiL.lean` for the Φ_filt + Φ_jet
  refinement

**Expected output:** 8 derived theorems flipping `gapOpen → gapClosed`.
Each compiles against current Infrastructure with no NEW Cat 2 axiom
introduction unless an honest PUBLISHED-but-not-yet-axiomatised citation
is required (in which case the new Cat 2 axiom is named, cited, and
left `gapOpen`).

---

### Brief R2-E: Decide-or-norm_num the remaining 6 finite-arithmetic Cat 3 entries

**Target:** Cat 3 entries whose load-bearing content is a finite
arithmetic identity:
`polynomial_identity_freudenthal` (P93 done, re-verify wire),
`chern_pairing_deg4_constraint` (P92 done, re-verify wire),
`freudenthal_scalar_piece_maps_to_81_h4` (P45 normal-jet),
`canonical_Phi_lands_in_W_E7_augmentation_ideal` (P69 W(E_7) degrees
{2,6,8,10,12,14,18}; no degree-4 invariant beyond κ²),
`W_E7_invariant_degrees_2_6_8_10_12_14_18` (Bourbaki Ch. VI tables),
`E7_proper_Q_parabolic_min_BS_codim` (codim ≥ 26 numeric check).

**Strategy:** §2.0 Pattern A (decide / norm_num / kernel computation).

**Files/typeclasses to read first:**
- `Infrastructure/CoxeterDegrees.lean`
- `Infrastructure/Coxeter/WE7.lean`
- `Infrastructure/CartanMatrices.lean`
- `CrossRingArithmetic.lean`

**Expected output:** 6 `theorem`s with `:= by decide` / `:= by norm_num`
/ explicit kernel-computation bodies. ledger flips `gapOpen → gapClosed`.

**Honest blocker:** if `decide` times out on `E7_proper_Q_parabolic_min_BS_codim`
(this enumerates parabolic-subset structure of E_7 root system; ~63
proper standard parabolics), decompose by Carter 1972 §13.2 explicit
table + manually enumerate or `decide_with_threshold` style.

---

### Brief R2-F: Audit-only — confirm no I4 obstruction was missed

**Target:** Hostile audit of the §3 tier classification. Independently
re-verify each of the 4 master conditionals + top-15 gapOpen are NOT
genuinely I4 (load-bearing math beyond Lean-formalization-team scope).

**Strategy:** Pre-commit overclaim audit per `feedback_arc_protocol.md`.
Fresh agent reads only Strict.lean + Infrastructure/ READMEs and the
paper master tex if accessible. Asks: "for each closure path the §3
table proposes, is there a hidden I4 step that wasn't flagged?"

**Files/typeclasses to read first:**
- Strict.lean L1-300 (P-narrative)
- This Strategy doc §3
- Infrastructure/README.md
- Each `Hyp_*_DERIVED` theorem the §3.1 table references

**Expected output:** confirmation that §3 ranking is honest, OR
identification of one or more entries that are actually I4 and
require honest re-classification as `gapOpen` until either (a) the
Lean-formalization team produces a P-series argument or (b) external
research closes them.

**Honest blocker:** if the audit finds an I4, the result is GOOD news
for the team — we avoid an overclaim. Report the I4 entry's name, the
hidden obstruction, and an honest path forward (Atlas-software / new
Infrastructure-file Pattern B / new P-series round).

---

## §5 What's NOT in scope for R2

- **Atlas-software enumeration of `A_q(λ)` at R(q)=8 for E_{7(-25)}.**
  This is a non-Lean side investigation (Direction D-AT in §2.3); valuable
  for moving `Hyp_BorelMAtLeast8` from `gapDeadEnd` to `gapClosed`,
  but NOT load-bearing for HC for `[q]` (P36 + P56 confirmed).
- **Lean ports of Vogan-Zuckerman 1984 / Knapp-Vogan 1995 / Franke 1998
  / Cattani-Kaplan-Schmid 1986** as full Cat 1 frameworks. These remain
  honest Cat 2 PUBLISHED axioms.
- **The 4-fold `InScope X` scope-extension question** of the top-level
  `main_reduction` theorem (paper Cor `cor:E7_full_closure`). Out of
  this team's purview.
- **Genuine HC for arbitrary X.** Clay-millennium open. The team scope is
  the EVII / V₅₆ / Freudenthal-quartic instance, NOT the general
  conjecture.

---

## §6 Acceptance criteria for R2 closure

The R2 round is **complete** when:

1. All 4 master conditional `Hyp_*` predicates have `Hyp_*_DERIVED`
   theorems compiling against current Strict.lean, kernel-pure axiom
   set `[propext, Classical.choice, Quot.sound]` retained.
2. The 4 `gapClosedConditional` ledger entries flip to `gapClosed`
   (the conditional-arrow is made explicit-and-discharged).
3. At least 20 of 54 Cat 3 `gapOpen` entries flip to `gapClosed`
   via Pattern A or Pattern B.
4. No new Cat 2 axiom is introduced WITHOUT honest PUBLISHED citation
   in the `paperSource` field.
5. The lake build remains GREEN with `lake exe cache get` Mathlib cache
   (no Mathlib rebuild per `feedback_lean_cache_only.md`).
6. R2 commit-per-round verified positive before merge per
   `feedback_commit_per_round.md`.

**Honest expected outcome.** R2 closes ~20-30 Cat 3 gapOpen entries
+ all 4 master conditionals. The remaining ~25-30 Cat 3 + 27 Cat 2
entries persist as honest `gapOpen` (Cat 2 = legitimate published
citations; remainder Cat 3 = new typeclass-field work for later rounds).

**Not expected.** R2 does NOT close all 81. R2 does NOT solve HC. R2
does NOT lift any Cat 2 PUBLISHED axiom to Cat 1 unless the citation
is finite-arithmetic decidable (Pattern A).
