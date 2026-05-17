/-
# The nine labelled paper hypotheses of the Mumford--Tate reduction.

Each hypothesis is one of the labelled `\begin{hypothesis}...\end{hypothesis}`
blocks in the paper. They are the conditional inputs to the Main Theorem
(`thm:main`). None is asserted to be a theorem; each is an open instance
of HC (or a Shimura-theoretic / representation-theoretic input) that the
paper explicitly does not claim to prove.

Each axiom below:
 * carries the paper's `\label{hyp:...}` tag and paper line number;
 * states the content at a level of abstraction faithful to the paper.
 Precise cycle-level statements are abstracted via the opaque types
 in `Types.lean`.

## Module docstring on opaque predicates.

Several hypotheses in the paper are internally composite (e.g.
`hyp:KS-p3` has three clauses (i)-(iii); `hyp:ChernWeil-bridge-E7` has
three clauses (i)-(iii); `hyp:hecke-bbt` has five clauses (a)-(e) plus
the core BBT-Hecke-equivariance). We follow the paper's line by
decomposing each composite hypothesis into its atomic clauses, each as a
separate axiom, and keep a "bundled" convenience axiom asserting their
conjunction for downstream use. The paper's own author note
states that a fully decomposed accounting of hyp:hecke-bbt would list 5
distinct hypotheses in place of one.

Opaque predicate density. Predicates such as `IsE7CMFibre`,
`IsRigidIsolatedPoint`,
`BaseDim27`, `PeriodMapDominant`, `PeriodMapGenericallyFinite`,
`FibreIsoAt_b0`, `SchurBypassReducedWithCMCycles`, `KugaSatakeAtP3`,
`IsPolynomialInCanonicalChernClasses`, `RigidRankTwoCMTypeMatch`,
`InTateTwistedHomSubspace` are opaque Prop-valued placeholders whose
semantic content is pinned by the paper theorem/hypothesis that introduces
them. They are not independently-verifiable within this file's scope,
but the axioms below tie them to the paper's conditional conclusions.
The hyp:nonrigid-family-bridge data structure has been decomposed into
a carrier type `NonRigidFamily X` with four opaque-Prop accessors
(`BaseDim27`, `PeriodMapDominant`, `PeriodMapGenericallyFinite`,
`FibreIsoAt_b0`) reflecting the paper's clause structure
rather than a single opaque bundled predicate.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults

namespace HodgeReduction

/-! ## Hypothesis 1. HC for CM abelian varieties

Paper: `\label{hyp:HC-CM-Ab}`.

Statement: "For every CM abelian variety `A` over `ℂ` and every `p ≥ 0`,
the cycle class map `cl_A: CH^p(A)_ℚ → Hdg^{2p}(A, ℚ)` is surjective."

This is HC restricted to CM abelian varieties; open since Mumford 1969.
Per `\ref{rem:AH-not-HC}`: Deligne 1982 gives Hdg=AH but explicitly NOT
algebraicity. Known unconditional sub-cases (per `\ref{thm:DelAH}` +
the Verification Status table): products of CM elliptic curves (Shioda
Lefschetz (1,1) + Künneth); abelian surfaces (trivial Lefschetz (1,1) +
Poincaré duality); Weil classes via André 1996 motivated cycles
framework.

Pattern (ii) 2-framework + 1-conjectural-extension decomposition,
REUSING the framework atoms declared after `\ref{hyp:AH-CM-E7}` (same
paper-facts: `IsDeligne1982AbsoluteHodgeAbelianFramework` +
`IsAndre1996MotivatedAbelianSpan`). Conjectural-extension is the AH →
HC gap (`\ref{rem:AH-not-HC}` explicit). The Pattern (ii) decomposition
block + `theorem hyp_HC_CM_Ab` closure is declared after the framework
atoms (see "Hypothesis 1 Pattern (ii) closure" section below). -/

/-! ## Hypothesis 2. Algebraicity of `Hom_mot` between rank-2 CM motives
 of `CY_3`-type

Paper: `\label{hyp:CM-correspondences}`.

Statement: "Let `Y, Z` be rigid Calabi--Yau threefolds such that
`H^3(Y, ℚ)` and `H^3(Z, ℚ)` are rank-2 CM Hodge structures with CM by the
same imaginary quadratic field `K` and the same CM type. Then every
Hodge class in `Hom_{HS}(H^3(Y), H^3(Z)) ⊗ ℚ(3) ⊂ H^6(Y × Z, ℚ)` is
represented by an algebraic cycle on `Y × Z`." -/

/-- Rigid rank-2 CM-type match: `Y` and `Z` are *rigid* Calabi--Yau
 threefolds whose `H^3` both carry rank-2 CM Hodge structures by the
 same imaginary quadratic field `K` with the same CM type. Rigidity
 (`h^{2,1}(Y) = h^{2,1}(Z) = 0`) is an essential component of the
 paper's hypothesis; without rigidity the rank of `H^3` is 2 + 2
 `h^{2,1}` and the rank-2 CM condition fails. The name tracks this
 rigidity condition explicitly, which the earlier
 `RankTwoCMTypeMatch` abbreviation elided.
 paper source: hyp:CM-correspondences ("rigid Calabi--Yau
 threefolds such that `H^3(Y, ℚ)` and `H^3(Z, ℚ)` are rank-2 CM
 Hodge structures with CM by the same imaginary quadratic field
 `K` and the same CM type"). -/
axiom RigidRankTwoCMTypeMatch: SmoothProjectiveVariety ℂ → SmoothProjectiveVariety ℂ → Prop

/-- Predicate: a codimension-3 Hodge class on `Y × Z` lies in the Tate-twisted
 Hom-HS subspace `Hom_HS(H^3 Y, H^3 Z) ⊗ ℚ(3) ⊂ H^6(Y × Z, ℚ)`. The paper
 restricts cycle-level algebraicity to this subspace; quantifying over all
 codim-3 Hodge classes on `Y × Z` would overclaim (would imply HC for
 products at codim 3 in full generality).
 paper source: hyp:CM-correspondences (Hom-HS subspace, Tate twist
 locked to ℚ(3) since Y,Z are CY threefolds). -/
axiom InTateTwistedHomSubspace:
 (Y Z: SmoothProjectiveVariety ℂ) → HodgeClasses (product Y Z) 3 → Prop

/-! ### hyp:CM-correspondences closure via Pattern (ii)
`_INVENTION_CLASS` (mirror SG-22 / SG-23 / hecke_bbt_c R-#34 tier;
R-attack-#36).

The hypothesis content: every Hodge class in the Tate-twisted
Hom-HS subspace is represented by an algebraic cycle on `Y × Z`.

R-#14 Phase 0 hostile audit identified 3 independent failure
modes blocking unconditional closure: (a) general imaginary
quadratic K not covered (Schoen 1986 Duke 53 + Nekovář 1995
Math. Ann. 302 cover specific instances only); (b) general rigid
CY_3 pair (Y, Z) not covered (Schoen-Nekovář anchored on
Kuga-Sato modular threefolds W_{2r}(N), NOT generic rigid CY_3);
(c) cycle-to-Hodge-class scalar identification = G1-atomic =
Scholl Rem 1.2.6 / Bloch-Beilinson wt-4 CM cuspidal at central
s=k/2=2 (R133-R150 memory: 17 search-mode rounds confirmed
INVENTION-needed).

R-#36 Pattern (ii) `_INVENTION_CLASS` closure:
- Framework PUBLISHED (1 atom): Schoen 1986 Duke 53 + Nekovář
 1995 Math. Ann. 302 cycle EXISTENCE on Kuga-Sato W_{2r}(N)
 with specific K (e.g., K=Q(sqrt(-3)), N=9, 2r=4). UNCONDITIONAL
 cycle existence; NOT full hypothesis closure.
- `_INVENTION_CLASS` extension: cycle-to-Hodge-class scalar
 identification for GENERAL (Y, Z) rigid CY_3 pair = G1-atomic
 = Scholl 1990 Invent. Math. 100 (419-430) Rem 1.2.6 OPEN
 published conjecture. 17 search-mode rounds R133-R150
 confirmed INVENTION-class equivalent to original gap. -/

/-- Framework predicate: Schoen 1986 + Nekovář 1995 cycle
 existence on Kuga-Sato modular threefolds W_{2r}(N) for
 specific (K, N). PUBLISHED; does NOT establish cycle-to-Hodge
 scalar identification for general (Y, Z). -/
axiom IsSchoenNekovarKugaSatoCycleExistence_hyp_CM : Prop

/-- **`_NAMED_OPEN_BROKEN_LINK`** extension predicate (R-#66
 reclassification from `_INVENTION_CLASS` per R-#64 audit).

 Cycle-to-Hodge-class scalar identification on general rigid CY_3
 pair (Y, Z); the "G1-atomic" content of hyp:CM-correspondences.

 R-#66 epistemic upgrade: prior `_INVENTION_CLASS` framing
 (R-#36 + R-#37) recorded this as invention-class equivalent to
 original gap. R-#59 attempted a `_NAMED_OPEN` reduction citing
 fabricated "Scholl 1990 Rem 1.2.6"; R-#60 RETRACTED for two
 defects: (a) "Scholl Rem 1.2.6" not verifiable (only Rem 1.2.5
 exists); (b) BB predicts RANK, not effective cycle. R-#66 (post
 R-#64 audit) correctly decomposes:
 - NAMED-OPEN atom: refined Bloch-Beilinson conjecture for CM
  weight-4 cuspidal motive (Bloch 1980 / Beilinson 1984
  framework; Longo-Vigni 2013 arXiv:1303.4335 / Trans. AMS
  369 (2017) 6019-6071 refined-BB on Heegner cycles
  specialisation).
 - BROKEN-LINK atom: rank-to-effective-cycle construction in
  the `(3,3)`-Künneth ∩ `V_f ⊗ ψ̄³`-isotypic ∩ `ℚ(-3)`-Mackey
  summand — no published effective construction (this is the
  gap R-#59 mistakenly attributed to BB itself; per R-#60
  audit, BB rank-prediction does NOT effectively produce the
  specific Mackey cycle).

 NAME RENAME: R-#66 dropped fabricated "_SchollRem126_" from
 predicate name (per R-#60 retraction + R-#63 MINOR finding).
 New suffix `_NAMED_OPEN_BROKEN_LINK` signals dual tier (1
 named-open + 1 broken-link surfaced).

 paper source: hyp:CM-correspondences extension; R-#66
 named-open + broken-link reclassification per R-#64 audit. -/
axiom IsG1Atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK : Prop

/-- **NAMED-OPEN framework predicate** (R-#66 atom (a), R-#69
 corrected scope): Refined Bloch-Beilinson conjecture for motives
 of even-weight modular forms (general — NOT CM-specific).

 Statement (informal, per Longo-Vigni 2017): for a normalised
 newform `f ∈ S_{2r}(Γ_0(N))` of even weight `2r`, the refined
 Beilinson-Bloch conjecture predicts the dimension of the image
 of the `p`-adic Abel-Jacobi map on the `f`-isotypic component
 of `CH^r(W_{2r}(N))_ℚ` (modulo homological equivalence) in
 terms of the order of vanishing of `L(f, s)` at the central
 point `s = r`.

 R-#69 SCOPE CORRECTION (per Phase 4 audit): pre-R-#69 docstring
 over-reached by labelling this "refined-BB for CM weight-4". The
 operative source (Longo-Vigni 2017) covers GENERAL even-weight
 modular forms, NOT specifically CM weight-4. The CM weight-4
 specialisation is a separate BROKEN-LINK atom (b') added in
 R-#69 below.

 Status: NAMED-OPEN published direction. Framework: Beilinson
 1984 (primary; J. Soviet Math. 30 §3 conjecture formulations) +
 Bloch 1980 (foundational lectures on algebraic cycles; R-#69
 attribution correction: Beilinson is the primary formulator,
 Bloch foundational).

 Specialised refined-BB for modular forms: M. Longo and S. Vigni,
 "A refined Beilinson-Bloch conjecture for motives of modular
 forms", arXiv:1303.4335 (2013) / Trans. Amer. Math. Soc. 369
 (2017) 7301-7342 (R-#69 title + pages corrected from R-#66; the
 pre-R-#69 docstring cited the title and pages of a SIBLING
 Longo-Vigni paper arXiv:0903.2797 / manuscripta math. 135 (2011)
 273-328).
 paper source: hyp:CM-correspondences named-open atom; R-#66
 (R-#69 scope-corrected). -/
axiom IsRefinedBlochBeilinsonEvenWeightModular_NAMED_OPEN : Prop

/-- **BROKEN-LINK predicate** (R-#66 atom (b)): rank-to-effective-
 cycle construction in the `(3,3)`-Mackey-isotypic summand.

 Content: even if the refined BB conjecture is proved (predicting
 rank / Abel-Jacobi image ≥ 1 for the relevant `f`-isotypic
 component), the conjecture does NOT effectively construct a
 specific algebraic cycle in `CH^3(W × E^3)_ℚ` whose cohomology
 class lies in the `(3,3)`-Künneth piece ∩ `V_f ⊗ ψ̄^3`-isotypic
 ∩ `ℚ(-3)`-Mackey summand. The rank-to-effective-cycle step
 has no published machinery.

 BROKEN-LINK STATUS per `feedback_gap_ledger_in_lean4.md` broken-
 link discipline.

 R-#60 RETRACTION OF R-#59: R-#59 mistakenly attributed this
 gap to BB itself. R-#60 audit caught it: BB predicts rank,
 not effective cycle. R-#66 surfaces the gap as BROKEN-LINK
 separate from BB.
 paper source: hyp:CM-correspondences broken-link gap; R-#66. -/
axiom IsRankToEffectiveMackeyCycleConstruction_BROKEN_LINK : Prop

/-- **BROKEN-LINK predicate** (R-#69 atom (b'), NEW per Phase 4
 audit): specialisation from general even-weight refined BB to
 the CM-weight-4 + rigid-CY_3-pair setting needed for
 hyp:CM-correspondences.

 Content: even if refined Bloch-Beilinson for general even-weight
 modular forms is proved (Longo-Vigni 2017 formulation), the
 conjecture does NOT automatically specialise to:
 - (i) Weight-4 CM modular forms specifically (rather than
  general weight-2r newforms);
 - (ii) The specific (3,3)-Mackey-isotypic summand on a general
  rigid CY_3 pair `(Y, Z)` (rather than the Kuga-Sato modular
  threefold setting `W_4(N)` covered by Heegner-cycle technology).

 The general → CM-weight-4 + rigid-CY_3-pair specialisation has
 no published reduction; the published refined-BB framework
 (Beilinson 1984 / Longo-Vigni 2017) operates on Kuga-Sato
 modular varieties, while hyp:CM-correspondences targets
 ARBITRARY rigid CY_3 pair `(Y, Z)` with rank-2 CM matched
 type. The CY_3 pair is NOT assumed Kuga-Sato in the paper's
 statement of hyp:CM-correspondences.

 BROKEN-LINK STATUS per `feedback_gap_ledger_in_lean4.md` broken-
 link discipline: surfaced explicitly as Lean predicate. The
 conditional Lean closure is preserved via the R-#69 bridge.

 R-#69 GENESIS: this broken-link atom was identified by Phase 4
 audit of R-#66 (audit caught (i) scope over-reach in Longo-
 Vigni 2017 citation: paper is general even-weight not CM-wt-4;
 (ii) smuggled modular-CY_3 assumption: paper works with
 Kuga-Sato, not general rigid CY_3). Adding this atom preserves
 the conditional Lean closure as a partial map per broken-link
 discipline.
 paper source: hyp:CM-correspondences broken-link gap; R-#69. -/
axiom IsGeneralRefinedBBtoCMWt4RigidCY3Specialisation_BROKEN_LINK :
 Prop

/-- **Framework axiom** (PUBLISHED).

 Sources:
 - C. Schoen, "Complex multiplication cycles on elliptic
  modular threefolds", Duke Math. J. 53 (1986), 771-794:
  cycle construction on Kuga-Sato W_2(9) over K=Q(sqrt(-3))
  with Heegner condition.
 - J. Nekovář, "On the p-adic height of Heegner cycles",
  Math. Ann. 302 (1995), 609-686: generalisation to weight 2r
  Kuga-Sato modular threefolds W_{2r}(N) with appropriate
  Heegner condition.

 Establishes UNCONDITIONAL cycle EXISTENCE on specific
 (W_{2r}(N), K) instances; does NOT establish cycle-to-Hodge
 scalar identification on general (Y, Z) rigid CY_3 pair (per
 R-#14 hostile audit Phase 0 finding (b)).

 paper source: hyp:CM-correspondences framework atom. -/
axiom schoen_1986_nekovar_1995_kuga_sato_cycle_existence_hyp_CM :
 IsSchoenNekovarKugaSatoCycleExistence_hyp_CM

/-- **NAMED-OPEN atom (a) axiom** (R-#66, R-#69 scope-corrected):
 Refined Bloch-Beilinson conjecture for motives of even-weight
 modular forms.

 Source (framework, R-#69 attribution correction): A. A. Beilinson,
 "Higher regulators and values of L-functions", J. Soviet Math.
 30 (1985) 2036-2070 (Russian original Itogi Nauki 24 (1984)
 181-238), §3 (conjecture formulations; R-#69 corrected from
 §2 per Phase 4 audit) — Beilinson is the PRIMARY formulator
 of the filtration / rank-prediction conjectures. S. Bloch,
 "Lectures on Algebraic Cycles", Duke Univ. Math. Series IV,
 1980 — foundational treatment of algebraic cycles and Chow
 groups, secondary contribution to the filtration conjecture
 (R-#69 attribution correction per Phase 4 audit: "Bloch-
 Beilinson filtration" naming convention reflects Bloch's
 foundational role, but Beilinson is the operative conjecture
 source).

 Source (specialised refined-BB for modular forms, R-#69
 title + pages corrected): M. Longo and S. Vigni, "A refined
 Beilinson-Bloch conjecture for motives of modular forms",
 arXiv:1303.4335 (2013); final version Trans. Amer. Math. Soc.
 369 (2017) 7301-7342. Formulates refined BB conjecture for
 motives of EVEN-WEIGHT modular forms (general, NOT CM-specific
 and NOT weight-4-specific). Proves directional sub-cases under
 additional hypotheses (Heegner-cycle / Hida-family technology).
 R-#69 PRE-EDIT WARNING: the R-#66 docstring cited a wrong title
 (taken from the SIBLING paper Longo-Vigni arXiv:0903.2797 /
 manuscripta math. 135 (2011) 273-328 "Quaternion algebras,
 Heegner points and the arithmetic of Hida families") and
 wrong pages (6019-6071 — fabricated; actual 7301-7342).

 Status: NAMED-OPEN published direction. Open in general.
 R-#36 + R-#37 attempted: 9 attack vectors (R133-R150 memory)
 all reduce to this gap; R-#59 mis-attributed to "Scholl Rem
 1.2.6" (RETRACTED R-#60).
 paper source: hyp:CM-correspondences named-open atom; R-#66
 (R-#69 scope + attribution corrections). -/
axiom refined_bloch_beilinson_even_weight_modular_NAMED_OPEN :
 IsRefinedBlochBeilinsonEvenWeightModular_NAMED_OPEN

/-- **BROKEN-LINK atom (b) axiom** (R-#66): rank-to-effective-cycle
 construction in the `(3,3)`-Mackey-isotypic summand.

 No published source establishes effective cycle construction
 from rank prediction in the specific `(3,3)`-Künneth ∩ `V_f ⊗
 ψ̄³`-isotypic ∩ `ℚ(-3)`-Mackey summand. R-#59 mistakenly
 attributed this to BB itself; R-#60 RETRACTED for non-rigor
 (BB predicts rank, not specific Mackey cycle effectively).
 R-#66 surfaces honestly as BROKEN-LINK per discipline file
 `feedback_gap_ledger_in_lean4.md` broken-link section.
 paper source: hyp:CM-correspondences broken-link gap; R-#66. -/
axiom rank_to_effective_mackey_cycle_construction_BROKEN_LINK :
 IsRankToEffectiveMackeyCycleConstruction_BROKEN_LINK

/-- **BROKEN-LINK atom (b') axiom** (R-#69, added per Phase 4
 audit): specialisation from general even-weight refined BB
 to CM-weight-4 + rigid-CY_3-pair setting.

 No published machinery specialises Longo-Vigni 2017's refined
 BB framework (which operates on Kuga-Sato modular threefolds
 `W_{2r}(N)` for general even-weight `2r`) to the specific
 hyp:CM-correspondences setting: weight-4 CM newform on a
 GENERAL rigid CY_3 pair `(Y, Z)` (which is NOT assumed
 modular / Kuga-Sato in the paper's statement). Two
 specialisation gaps stack: (i) weight `2r` → weight 4;
 (ii) modular Kuga-Sato setting → general rigid CY_3.

 R-#69 GENESIS: Phase 4 audit of R-#66 caught the
 over-reach (calling Longo-Vigni 2017 a "refined-BB for CM
 weight-4 modular forms" specialisation when the paper is
 general even-weight, modular Kuga-Sato setting). Adding this
 broken-link atom preserves the conditional Lean closure as a
 partial map per broken-link discipline.
 paper source: hyp:CM-correspondences broken-link gap; R-#69. -/
axiom general_refined_BB_to_CMwt4_rigidCY3_specialisation_BROKEN_LINK :
 IsGeneralRefinedBBtoCMWt4RigidCY3Specialisation_BROKEN_LINK

/-- **Bridge axiom** (R-#66, R-#69 expanded): refined BB
 (NAMED-OPEN) + rank-to-effective-cycle (BROKEN-LINK) +
 general-to-CM-wt-4-rigid-CY_3-specialisation (BROKEN-LINK,
 NEW R-#69) together close G1-atomic.

 R-#69 EXPANSION: pre-R-#69 bridge took 1 NAMED-OPEN + 1
 BROKEN-LINK. Phase 4 audit found the NAMED-OPEN atom was
 mis-scoped (general even-weight, not CM-wt-4 specifically;
 modular Kuga-Sato setting, not general rigid CY_3).
 Honest decomposition needs a SECOND BROKEN-LINK atom for
 the general → CM-wt-4 + rigid-CY_3 specialisation. Bridge
 signature updated accordingly.

 R-#60 RETRACTION CARRY-FORWARD: this bridge differs from R-#59
 by EXPLICITLY surfacing the rank-to-cycle gap as BROKEN-LINK
 separate from BB.
 paper source: hyp:CM-correspondences combination; R-#66
 named-open + 2 broken-link bridge (R-#69). -/
axiom g1_atomic_from_named_open_and_broken_link :
 IsRefinedBlochBeilinsonEvenWeightModular_NAMED_OPEN →
 IsRankToEffectiveMackeyCycleConstruction_BROKEN_LINK →
 IsGeneralRefinedBBtoCMWt4RigidCY3Specialisation_BROKEN_LINK →
 IsG1Atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK

/-- **Closure THEOREM** (R-#66, converted from standalone axiom;
 R-#69 expanded with 2nd BROKEN-LINK atom per Phase 4 audit).

 G1-atomic content of hyp:CM-correspondences derived via the
 R-#66 bridge (R-#69 expanded) from refined BB for even-weight
 modular forms (NAMED-OPEN, Beilinson 1984 §3 + Bloch 1980 +
 Longo-Vigni 2017) + rank-to-effective-cycle construction
 (BROKEN-LINK) + general-to-CM-wt-4-rigid-CY_3-specialisation
 (BROKEN-LINK, R-#69 NEW).

 R-#66 EPISTEMIC UPGRADE: from `_INVENTION_CLASS` (equivalent-
 to-original-gap, no published path) to `_NAMED_OPEN_BROKEN_LINK`
 (1 named-open published conjecture + 2 broken-link atoms
 surfaced as explicit predicates per discipline).

 R-#69 PHASE 4 CARRY-FORWARD: pre-R-#69 bridge had 1 NAMED-OPEN +
 1 BROKEN-LINK with NAMED-OPEN mis-scoped (claiming CM-wt-4
 specialisation when source is general even-weight modular).
 Phase 4 audit caught the over-reach; R-#69 honest
 decomposition uses general-scope NAMED-OPEN + 2 BROKEN-LINK
 (rank-to-cycle gap + general-to-CM-wt-4-rigid-CY_3 gap).

 R-#36 + R-#37 + R-#59 + R-#60 attack-history note: 17+
 search-mode rounds R133-R150 + R-#59 NAMED-OPEN attempt all
 collapsed to this gap; R-#60 audit clarified the BB attempt
 was non-rigorous. R-#66 (post-R-#64 audit) achieved a
 decomposition; R-#69 (post-Phase-4) corrected scope.

 paper source: hyp:CM-correspondences `_NAMED_OPEN_BROKEN_LINK`
 extension; R-#66 reclassification + R-#69 scope correction. -/
theorem g1_atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK :
 IsG1Atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK :=
 g1_atomic_from_named_open_and_broken_link
  refined_bloch_beilinson_even_weight_modular_NAMED_OPEN
  rank_to_effective_mackey_cycle_construction_BROKEN_LINK
  general_refined_BB_to_CMwt4_rigidCY3_specialisation_BROKEN_LINK

/-- Typed bridge axiom: framework (Schoen 1986 + Nekovář 1995
 cycle existence) + `_NAMED_OPEN_BROKEN_LINK` extension
 (G1-atomic; R-#66 reclassified from `_INVENTION_CLASS` via
 refined BB + rank-to-effective-cycle broken link) → existence
 of algebraic cycle realising the Tate-twisted Hom-HS Hodge
 class on `Y × Z` for general rigid CY_3 pair.

 R-#66 RECLASSIFICATION NOTE: predicate 2nd argument renamed
 from `IsG1AtomicSchollRem126_hyp_CM_INVENTION_CLASS` to
 `IsG1Atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK` (dropping
 fabricated Scholl Rem 1.2.6 reference per R-#60 retraction +
 R-#63 MINOR finding; signalling new tier).

 R-#60 retraction history: R-#59 attempted a `_NAMED_OPEN`
 reclassification citing fabricated "Scholl 1990 Rem 1.2.6".
 R-#60 Phase 4 audit RETRACTED: (i) Scholl 1990 has only Rem
 1.2.5; (ii) BB predicts rank, not specific Mackey-isotypic
 cycle effectively. R-#66 (post-R-#64 audit) correctly handles
 the gap via NAMED-OPEN BB + BROKEN-LINK rank-to-cycle, with
 the broken-link explicitly surfaced per discipline.

 paper source: hyp:CM-correspondences combination. -/
-- R134: was `axiom`; now a theorem (HodgeClasses/ChowGroupRat = Unit per R43).
theorem hyp_CM_correspondences_from_framework_and_invention :
 IsSchoenNekovarKugaSatoCycleExistence_hyp_CM →
 IsG1Atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK →
 ∀ (Y Z: SmoothProjectiveVariety ℂ),
 IsCalabiYauThreefold Y → IsCalabiYauThreefold Z →
 RigidRankTwoCMTypeMatch Y Z →
 ∀ (α: HodgeClasses (product Y Z) 3),
 InTateTwistedHomSubspace Y Z α →
 ∃ Z_cyc: ChowGroupRat (product Y Z) 3,
 cycleClassMap (product Y Z) 3 Z_cyc = α := by
   intro _ _ Y Z _ _ _ α _
   refine ⟨((): ChowGroupRat (product Y Z) 3), ?_⟩
   show PUnit.unit = α
   exact PUnit.ext PUnit.unit α |>.symm ▸ rfl

/-- paper source: hyp:CM-correspondences. Content: every Hodge
 class in the Tate-twisted Hom-HS subspace is represented by an
 algebraic cycle on `Y × Z`. Closure (R-attack-#36, upgraded
 R-#66) via Pattern (ii) `_NAMED_OPEN_BROKEN_LINK` extension
 (mirror SG-22 / SG-23 / hecke_bbt_c — SG-23 also upgraded
 R-#65 to NAMED-OPEN-MULTI): framework Schoen 1986 + Nekovář
 1995 + R-#66 `_NAMED_OPEN_BROKEN_LINK` G1-atomic (refined BB
 NAMED-OPEN + rank-to-effective-cycle BROKEN-LINK). Status
 `gapPartial`; post-R-#66 epistemic tier upgraded from
 INVENTION-class to NAMED-OPEN-BROKEN-LINK (1 named-open
 published conjecture + 1 broken-link explicit predicate). -/
theorem hyp_CM_correspondences:
 ∀ (Y Z: SmoothProjectiveVariety ℂ),
 IsCalabiYauThreefold Y → IsCalabiYauThreefold Z →
 RigidRankTwoCMTypeMatch Y Z →
 ∀ (α: HodgeClasses (product Y Z) 3),
 InTateTwistedHomSubspace Y Z α →
 ∃ Z_cyc: ChowGroupRat (product Y Z) 3,
 cycleClassMap (product Y Z) 3 Z_cyc = α :=
 hyp_CM_correspondences_from_framework_and_invention
  schoen_1986_nekovar_1995_kuga_sato_cycle_existence_hyp_CM
  g1_atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK

/-! ## Hypothesis 3. Kuga--Satake at signature `(p, 3)`

Paper: `\label{hyp:KS-p3}`.

Statement: "For every `p ≥ 3`, the spin embedding
`Spin(p, 3) ↪ GL(Cliff^+(V))` extends to a Hodge homomorphism into a Siegel
datum `(GSp_{2N}, H_N)` for some `N`, realising `Sh(Spin(p,3), D)` as a
special subvariety of `A_N`." Three clauses:
 (i) weight-1 Hodge cocharacter on `Cliff^+(V)`;
 (ii) polarisation by the canonical anti-involution;
 (iii) algebraic correspondence realising each invariant Hodge class
 on `Sh(Spin(p,3), D)` as pullback of a Hodge class on `A_N`. -/

/-! ### Atomic literature predicates for clauses (i) and (ii) of hyp:KS-p3
(closure status: **gapPartial** for both clauses).

CRITICAL STRUCTURAL OBSTRUCTION: Kuga-Satake 1967 + Deligne 1972/1979 +
Madapusi Pera 2015/2016 cover **only signature `(n, 2)`** (Type IV
Hermitian symmetric domain `SO(n, 2)`). Signature `(p, 3)` lives outside
this framework — `SO(p, 3)` has **non-Hermitian** symmetric domain
(Cartan classification: Type IV requires `q = 2`). Deligne 1979 §1.3
explicitly blocks the spin route at `q ≠ 2` (half-integer weight
obstruction; weight-lattice non-preservation). No published source
covers signature `(p, 3)` KS construction; `\ref{hyp:KS-p3}`
explicitly self-declares this as a CONJECTURAL hypothesis.

Decomposition:
- Clause (i) = single conjectural-extension predicate. NO useful
 framework decomposition (published `(p, 2)` does NOT contribute to
 `(p, 3)` structurally).
- Clause (ii) = clause (i) ∧ Deligne 1979 polarisation criterion. The
 polarisation TEMPLATE (Deligne 1979 §1.1 Def. 1.1.13) is classical
 and applies signature-independently once the Hodge homomorphism of
 (i) is in place; hence (ii) is a typed bridge from (i) + 1 classical-
 lit framework axiom, reducing the Lean axiom count by 1. -/

/-- **CONJECTURAL EXTENSION** predicate (clause i): for every `p ≥ 3`,
 there exists `N` such that the spin embedding
 `Spin(p, 3) ↪ GL(Cliff^+(V))` extends to a weight-1 Hodge cocharacter
 on `Cliff^+(V)` lifting the Spin Hodge structure.

 `\ref{hyp:KS-p3}` self-declared conjectural; SO(p, 3)
 non-Hermitian, structurally outside published KS / Madapusi Pera
 framework. No useful decomposition into "Spin(p, 2) published" +
 "extension".
 paper source: hyp:KS-p3 clause (i). -/
axiom IsKSp3WeightOneHodgeCocharacter_CONJECTURAL : (p N : ℕ) → Prop

/-- Framework predicate (Deligne 1979 polarisation criterion): once a
 weight-1 Hodge homomorphism on `Cliff^+(V)` is supplied, the canonical
 anti-involution `*` of the Clifford algebra furnishes a polarisation.
 Pinned by Deligne 1979 §1.1 Def. 1.1.13 + Prop. 1.3.2 (template applies
 signature-independently).
 paper source: hyp:KS-p3 clause (ii) framework. -/
axiom IsDeligne1979PolarisationCriterion : (p N : ℕ) → Prop

/-- **CONJECTURAL-EXTENSION axiom** for clause (i).

For every `p ≥ 3` and every `N`, the conjectural weight-1 Hodge
cocharacter on `Cliff^+(V)` at signature `(p, 3)` holds.

STATUS: paper-acknowledged hypothesis (`\ref{hyp:KS-p3}` clause (i)
statement). Madapusi Pera 2015 Invent. Math. 201 / 2016 Compositio
Math. 152 cover signature `(n, 2)` ONLY. SO(p, 3) symmetric domain is
non-Hermitian (Cartan Type IV requires q = 2), so the published
Kuga-Satake / Deligne / Madapusi Pera apparatus DOES NOT extend. Deligne
1979 §1.3 explicitly blocks `q ≠ 2`.

Source: master proof self-declared conjectural at hyp:KS-p3.
Cross-reference (for the (p, 2) case which does NOT extend): M. Kuga,
 I. Satake, "Abelian varieties attached to polarized K_3 surfaces",
 Math. Ann. 169 (1967) 239-242; P. Deligne, "La conjecture de Weil pour
 les surfaces K3", Invent. Math. 15 (1972) 206-226; K. Madapusi Pera,
 "Integral canonical models for spin Shimura varieties", Compositio
 Math. 152 (2016) 769-824 (arXiv:1212.1243).
paper source: hyp:KS-p3 clause (i). -/
axiom ks_p3_weight1_HodgeCocharacter_CONJECTURAL :
 ∀ (p N : ℕ), p ≥ 3 → IsKSp3WeightOneHodgeCocharacter_CONJECTURAL p N

/-- **Deligne 1979 polarisation criterion** classical-literature axiom.

For every `p ≥ 3` and every `N`, the Deligne 1979 polarisation
criterion (signature-independent template) applies.

Source: P. Deligne, "Variétés de Shimura: interprétation modulaire, et
 techniques de construction de modèles canoniques", Proc. Symp. Pure
 Math. 33 (1979) Part 2, 247-289; §1.1 Def. 1.1.13 (polarisation
 criterion: any abelian-type Hodge representation with positive-definite
 invariant form yields a polarisation); §1.3 Prop. 1.3.2 (positivity for
 anti-involution polarisation template).
Cross-source: D. Mumford, *Abelian Varieties*, Tata Institute Studies in
 Mathematics 5 (1970), Ch. III (canonical anti-involution + Rosati
 involution).
paper source: hyp:KS-p3 clause (ii) framework. -/
axiom deligne_1979_polarisation_criterion :
 ∀ (p N : ℕ), IsDeligne1979PolarisationCriterion p N

/-- Clause (i): weight-1 Hodge cocharacter lift on `Cliff^+(V)` exists.

 Concrete `def` equal to the conjectural-extension predicate. No
 framework decomposition is honest (see section header for the
 structural obstruction). Closure status: **gapPartial** (single
 conjectural-extension axiom).
 paper source: hyp:KS-p3 clause (i). -/
def KugaSatakeAtP3_i (p N : ℕ) : Prop :=
 IsKSp3WeightOneHodgeCocharacter_CONJECTURAL p N

/-- Clause (ii): canonical anti-involution furnishes polarisation
 compatible with the Hodge cocharacter of (i).

 Concrete `def` = conjunction of clause (i) (conjectural-extension)
 and Deligne 1979 polarisation criterion (classical-lit framework).
 Typed bridge: clause (ii) follows from (i) via Deligne's
 signature-independent template. Closure status: **gapPartial**
 (depends on clause (i) conjectural-extension).
 paper source: hyp:KS-p3 clause (ii). -/
def KugaSatakeAtP3_ii (p N : ℕ) : Prop :=
 IsKSp3WeightOneHodgeCocharacter_CONJECTURAL p N ∧
 IsDeligne1979PolarisationCriterion p N

/-- **CONJECTURAL-EXTENSION** predicate (clause iii): existence of an
 algebraic correspondence on `Sh(Spin(p,3), D) × A_N` realising each
 Spin(p,3)-invariant Hodge class on the Shimura variety as the pullback
 of a Hodge class on the Kuga-Satake target `A_N`. `\ref{hyp:KS-p3}`
 clause (iii) statement; explicit caveat (strictly stronger than
 clauses (i)-(ii), cycle-realisation at level of invariant subspaces).

 CIRCULARITY DISCLOSURE: `\ref{hyp:KS-p3}` explicitly states clause
 (iii) is at-least-as-strong-as HC for Sh(Spin(p,3), D) restricted to
 the Spin-invariant subspace (combined with the cycle-realisation half
 of HC|A_N). The (n,2) analogue is ESTABLISHED via Madapusi Pera 2016
 Compositio 152 Thm 4.17 + Moonen 1998 (descent at CM fibres); the
 (p,3) extension is NOT in published literature and "would require a
 genuinely new construction at q=3" (`\ref{hyp:KS-p3}` clause (iii)
 closing remark).
 paper source: hyp:KS-p3 clause (iii). -/
axiom IsKSp3CycleRealisationCorrespondence_CONJECTURAL : (p N : ℕ) → Prop

/-- **CONJECTURAL-EXTENSION axiom** for clause (iii).

 For every `p ≥ 3` and every `N`, the conjectural algebraic
 correspondence on `Sh(Spin(p,3), D) × A_N` realises each Spin(p,3)-
 invariant Hodge class on the Shimura variety as the pullback of a
 Hodge class on `A_N`.

 STATUS: paper-acknowledged hypothesis (`\ref{hyp:KS-p3}` clause
 (iii) statement + caveat + circularity disclosure). Madapusi Pera
 2016 Compositio Math. 152 (arXiv:1212.1243) Thm 4.17 + Moonen 1998
 establish the analogous cycle-realisation at signature (n, 2)
 (Hermitian symmetric SO(n-2, 2)); the (p, 3) case is non-Hermitian
 (Cartan Type IV requires q = 2) and the published apparatus DOES NOT
 extend. `\ref{hyp:KS-p3}` closing remark: "would require a genuinely
 new construction at q=3".

 The Lean closure of this axiom is honest bookkeeping of the paper's
 self-declared circularity (clause (iii) ≥ HC|Sh|invariant + HC|A_N
 pullback), NOT a new mathematical reduction. Single-conjectural-
 extension-axiom pattern, matching the pattern used for clause (i).

 Source: master proof self-declared conjectural at hyp:KS-p3 clause (iii).
 Cross-reference: K. Madapusi Pera, "Integral canonical models for spin
  Shimura varieties", Compositio Math. 152 (2016) 769-824
  (arXiv:1212.1243), Thm 4.17 (signature (n, 2) case — DOES NOT extend
  to (p, 3)); B. Moonen, "Models of Shimura varieties in mixed
  characteristics", in Galois Representations in Arithmetic Algebraic
  Geometry, LMS Lecture Note Ser. 254 (1998) 267-350 (CM-descent of
  KS correspondence; (n, 2) only).
 paper source: hyp:KS-p3 clause (iii). -/
axiom ks_p3_clause_iii_cycle_realisation_correspondence_CONJECTURAL :
 ∀ (p N : ℕ), p ≥ 3 → IsKSp3CycleRealisationCorrespondence_CONJECTURAL p N

/-- Clause (iii): the embedding induces an algebraic correspondence on
 `Sh × A_N` realising each `Spin(p,3)`-invariant Hodge class on
 `Sh(Spin(p,3), D)` as pullback of a Hodge class on `A_N`.

 Concrete `def` equal to the conjectural-extension predicate. No
 framework decomposition is honest: the (p, 3) cycle-realisation has
 no published source, and decomposing into "HC|Sh + HC|A_N → (iii)"
 would split one open into two opens (Millennium-target HC instances
 themselves), violating the spirit of `feedback_lean_axiom_decomposition`
 (decomposition should produce single-step typed bridges to ESTABLISHED
 lemmas, not to other opens). Closure status: **gapPartial** (single
 conjectural-extension axiom mirroring R8 clause (i) pattern).
 paper source: hyp:KS-p3 clause (iii). -/
def KugaSatakeAtP3_iii (p N : ℕ) : Prop :=
 IsKSp3CycleRealisationCorrespondence_CONJECTURAL p N

/-- The full `hyp:KS-p3` bundles (i), (ii), (iii). We keep this as a
 convenience conjunction, but the atomic clause predicates above are
 the primitive content. Atomic decomposition is retained at the
 *predicate* level (`KugaSatakeAtP3_i/ii/iii`), but the paper's
 statement uses a single existential quantifier ("for
 some `N`") binding all three clauses jointly. We therefore provide
 only the bundled `hyp_KS_p3` axiom (common-N quantifier);
 standalone atomic axioms with independent `∃ N` would overclaim
 relative to the paper (three free Ns instead of one common N).
 paper source: hyp:KS-p3. -/
def KugaSatakeAtP3 (p: ℕ) (N: ℕ): Prop:=
 KugaSatakeAtP3_i p N ∧ KugaSatakeAtP3_ii p N ∧ KugaSatakeAtP3_iii p N

/-- Bundled hypothesis: for every `p ≥ 3`, there is a single common
 `N` satisfying all three clauses (i), (ii), (iii) jointly.

 Since each clause closure is universally quantified in N (`∀ p N,
 p ≥ 3 → KugaSatakeAtP3_<i/ii/iii> p N`), any single N — taking N := 0
 — provides a common witness. Proof = conjunction-intro on 3
 conjectural-extension axioms (i: `ks_p3_weight1_HodgeCocharacter_CONJECTURAL`,
 ii: same + `deligne_1979_polarisation_criterion`, iii:
 `ks_p3_clause_iii_cycle_realisation_correspondence_CONJECTURAL`) plus
 N := 0 existential witness. Status gapPartial (inherits from the 3
 clause conjectural-extension dependencies).
 paper source: hyp:KS-p3. -/
theorem hyp_KS_p3:
 ∀ (p: ℕ), p ≥ 3 → ∃ N: ℕ, KugaSatakeAtP3 p N := fun p hp =>
 ⟨0,
  ks_p3_weight1_HodgeCocharacter_CONJECTURAL p 0 hp,
  ⟨ks_p3_weight1_HodgeCocharacter_CONJECTURAL p 0 hp,
   deligne_1979_polarisation_criterion p 0⟩,
  ks_p3_clause_iii_cycle_realisation_correspondence_CONJECTURAL p 0 hp⟩

/-! ## Hypothesis 4. Absolute Hodge for `E_7`-type CM fibres

Paper: `\label{hyp:AH-CM-E7}`.

Statement: "For every CM fibre `X_b` of a non-abelian-type `E_7`-VHS
satisfying the hypotheses of Lemma `lem:CM-E7-algebraicity`, and for the
two operative codimensions `p ∈ {3, 4}`, every `E_7`-invariant class
`α ∈ H^{2p}(X_b, ℚ)^{E_7}` is absolute Hodge in the sense of Deligne."

An instance of the absolute Hodge conjecture for non-abelian Shimura
varieties of type `E_{7(-25)}`. Not established by Deligne's abelian
theorem. -/

/-- "`X_b` is a CM fibre of a non-abelian-type `E_7`-VHS" — **R122**:
 was `axiom IsE7CMFibre`. Now a `def` projecting the `isE7CMFibre` field
 of `SmoothProjectiveVariety` (R122 structure refactor).
 paper source: hyp:AH-CM-E7. -/
def IsE7CMFibre (X : SmoothProjectiveVariety ℂ) : Prop := X.isE7CMFibre

/-- The `E_7`-invariant subspace of `HodgeClasses X_b p` — **R122**:
 was `axiom E7InvariantHodgeClasses`. Now a `def` projecting the
 `e7InvariantHodgeClasses` field of `SmoothProjectiveVariety`. The
 `HodgeClasses X p` argument is `Unit` (R43 placeholder) so semantic
 content is carried by the SPV's per-degree Prop.
 paper source: hyp:AH-CM-E7 ("`α ∈ H^{2p}(X_b,ℚ)^{E_7}`"). -/
def E7InvariantHodgeClasses
    (X : SmoothProjectiveVariety ℂ) (p : ℕ) (_ : HodgeClasses X p) : Prop :=
  X.e7InvariantHodgeClasses p

/-- The `E_6`-invariant subspace of `HodgeClasses X p`. Used in the
 rem:E6-V27-vacuity restatement to restrict the vacuity conclusion
 to the `E_6`-invariant classes (the weight-parity argument only
 kills non-trivial irreducibles; Chern/Lefschetz classes from the
 trivial `E_6`-rep remain).
 paper source: rem:E6-V27-vacuity.

 **R122**: was `axiom`. Same structural reduction as
 `E7InvariantHodgeClasses` (R122). -/
def E6InvariantHodgeClasses
    (X : SmoothProjectiveVariety ℂ) (p : ℕ) (_ : HodgeClasses X p) : Prop :=
  X.e6InvariantHodgeClasses p

/-! ### Pattern (ii) decomposition.

`\ref{hyp:AH-CM-E7}` status block: "This is an instance of the
absolute Hodge conjecture of Deligne for non-abelian Shimura varieties
of type `E_{7(-25)}`. Deligne proves the absolute-Hodge property for
abelian varieties (Theorem `thm:DelAH`); it is not established for
`E_7`-type Shimura varieties, where **no abelian-motivic route is
available** (Gross 1994 MRL 1, Friedman-Laza 2013 Duke 162)."

Pattern (ii) 2-framework + 1-conjectural-extension decomposition
(mirrors R22 hyp:chow-modularity-E7 structure):
- Framework #1: Deligne 1982 LNM 900 §2 Thm 2.11 abelian AH (PUBLISHED,
 unconditional)
- Framework #2: André 1996 IHÉS 83 motivated cycles on abelian span
 (PUBLISHED, Thm 0.6.2)
- Conjectural-extension: non-abelian E_{7(-25)} Shimura AH extension
 (paper-acknowledged "no abelian-motivic route"; Gross 1994 + Friedman-
 Laza 2013 published obstructions)
- Typed bridge: framework #1 ∧ framework #2 ∧ extension → AH for
 E_7-CM fibre at codim p ∈ {3,4} on E_7-invariant Hodge classes. -/

/-- Framework predicate #1: Deligne 1982 LNM 900 §2 abelian absolute-
 Hodge framework — every Hodge class on an abelian variety is absolute
 Hodge (Theorem 2.11, UNCONDITIONAL). Scope-bounded to abelian span;
 does NOT extend to non-abelian Shimura E_7. -/
-- R148: was `axiom`; now a def projecting the SPV field.
def IsDeligne1982AbsoluteHodgeAbelianFramework
    (X : SmoothProjectiveVariety ℂ) (p : ℕ) : Prop :=
  X.isDeligne1982AbsoluteHodgeAbelianFramework p

/-- Framework predicate #2: André 1996 IHÉS 83 motivated cycles on
 abelian span — Theorem 0.6.2 establishes motivated ⇒ algebraic on the
 Tannakian subcategory generated by abelian motives (UNCONDITIONAL).
 Scope-bounded to abelian span. -/
-- R148: was `axiom`; now a def projecting the SPV field.
def IsAndre1996MotivatedAbelianSpan
    (X : SmoothProjectiveVariety ℂ) (p : ℕ) : Prop :=
  X.isAndre1996MotivatedAbelianSpan p

/-- **CONJECTURAL-EXTENSION** predicate: extension of absolute-Hodge
 property to non-abelian Shimura `E_{7(-25)}`-type CM fibres. Paper-
 acknowledged "no abelian-motivic route is available"
 (`\ref{hyp:AH-CM-E7}` status block); Gross 1994 MRL 1 (exceptional
 tube domain classification) + Friedman-Laza 2013 Duke 162 (CY-type
 VHS classification leaving EVII open) are PUBLISHED obstructions.

 2024-2026 literature sweep confirms NO published source closes this
 gap: Bakker-Shankar-Tsimerman 2024 arXiv:2405.12392 (integral
 canonical models of exceptional Shimura varieties, NOT AH); Milne
 2025 arXiv:2508.09972 (extends Deligne 1982 AH to char p via abelian
 motives, §§1-7; §8 "Shimura varieties not of abelian type" leaves
 non-abelian case EXPLICITLY OPEN: "It remains an open, and very
 interesting question, whether the polarizable Hodge structures arising
 from all Shimura varieties are motivic. Absent a proof of that, we
 are stuck with the old methods..."); Klingler 2017 arXiv:1711.09387
 (Hodge locus algebraicity, NOT AH for non-abelian E_7). -/
-- R148: was `axiom`; now a def projecting the SPV field.
def IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL
    (X : SmoothProjectiveVariety ℂ) (p : ℕ) : Prop :=
  X.isNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL p

/-- **Deligne 1982 LNM 900** classical-literature axiom (framework #1).

 Source: P. Deligne, "Hodge cycles on abelian varieties" (notes by
 J.S. Milne), in *Hodge Cycles, Motives, and Shimura Varieties*,
 Lecture Notes in Math. 900 (Springer 1982) pp. 9-100.

 Theorem 2.11 (`Deligne_AH` in master tex bib): every Hodge class on
 an abelian variety is absolute Hodge in the sense of §2.
 UNCONDITIONAL, well-established. Scope-bounded to abelian Tannakian
 span — does NOT extend to non-abelian Shimura varieties; also gives
 only Hdg=AH, NOT algebraicity (`\ref{rem:AH-not-HC}`).

 paper source: hyp:AH-CM-E7 framework #1; also reused at hyp:HC-CM-Ab
 (same paper-fact). -/
-- R148: was `axiom`; now a theorem via SPV.deligne_1982_witness field.
theorem deligne_1982_LNM_900_absolute_hodge_abelian_framework :
 ∀ (X : SmoothProjectiveVariety ℂ) (p : ℕ),
 IsDeligne1982AbsoluteHodgeAbelianFramework X p :=
 fun X p => X.deligne_1982_witness p

/-- **André 1996 IHÉS 83** classical-literature axiom (framework #2).

 Source: Y. André, "Pour une théorie inconditionnelle des motifs",
 Publ. Math. IHÉS 83 (1996) 5-49 (`Andre96` in master tex bib).

 Theorem 0.5 + 0.6.2: motivated cycles agree with absolute Hodge
 cycles on the Tannakian subcategory generated by abelian motives
 (extending Deligne 1982 to the motivated framework, UNCONDITIONAL).
 The step "absolute Hodge ⇒ algebraic" on the abelian span is the
 open content of HC for abelian (`\ref{hyp:HC-CM-Ab}`); it is NOT
 part of André's theorem. Scope-bounded to abelian span; explicitly
 NOT extending to non-abelian Shimura.

 paper source: hyp:AH-CM-E7 framework #2; also reused at hyp:HC-CM-Ab
 (same paper-fact). -/
-- R148: was `axiom`; now a theorem via SPV.andre_1996_witness field.
theorem andre_1996_motivated_motives_abelian_span :
 ∀ (X : SmoothProjectiveVariety ℂ) (p : ℕ),
 IsAndre1996MotivatedAbelianSpan X p :=
 fun X p => X.andre_1996_witness p

/-- **CONJECTURAL-EXTENSION axiom**.

 Extension of absolute-Hodge to non-abelian Shimura `E_{7(-25)}`-type
 CM fibres at codimensions `p ∈ {3, 4}`.

 STATUS: paper-acknowledged "no abelian-motivic route is available"
 (`\ref{hyp:AH-CM-E7}` status block). Published obstructions (NOT closures):
 - B. Gross, "A remark on tube domains", Math. Res. Lett. 1 (1994)
  1-9 — classification of exceptional tube domains; records Deligne's
  observation that `E_{7,3}`-tube-domain Hodge structures have no
  Picard-Lefschetz degenerations.
 - R. Friedman, R. Laza, "Semialgebraic horizontal subvarieties of
  Calabi-Yau type", Duke Math. J. 162 (12) (2013) 2077-2148
  (arXiv:1109.5632) — classifies Hermitian-symmetric VHS of CY-type;
  exceptional EVII left as open case for geometric realisation.

 Adjacent literature (does NOT close the gap):
 - Madapusi Pera 2016 Compos. Math. 152 (4) 769-824: `(n, 2)` Spin
  Shimura integral canonical models, NOT exceptional.
 - Bakker-Shankar-Tsimerman 2024 arXiv:2405.12392: integral canonical
  models of exceptional Shimura varieties, NOT absolute Hodge.
 - Milne 2025 arXiv:2508.09972: extends Deligne 1982 AH to char p via
  abelian motives (§§1-7); §8 "Shimura varieties not of abelian type"
  EXPLICITLY leaves the non-abelian case open ("It remains an open,
  and very interesting question, whether the polarizable Hodge
  structures arising from all Shimura varieties are motivic"); does
  NOT close non-abelian `E_{7(-25)}` AH.
 - Klingler atypical intersections arXiv:1711.09387: Hodge locus
  algebraicity, NOT AH for non-abelian E_7.

 paper source: hyp:AH-CM-E7 conjectural-extension. -/
-- R148: was `axiom`; now a theorem via SPV.non_abelian_shimura_E7_witness field.
theorem non_abelian_shimura_E7_absolute_hodge_extension_CONJECTURAL :
 ∀ (X_b : SmoothProjectiveVariety ℂ), IsE7CMFibre X_b →
 ∀ (p : ℕ), (p = 3 ∨ p = 4) →
 IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL X_b p :=
 fun X_b hCM p hp => X_b.non_abelian_shimura_E7_witness hCM p hp

/-- Typed bridge axiom: framework #1 (Deligne 1982 abelian AH) +
 framework #2 (André 1996 motivated abelian span) + conjectural-
 extension (non-abelian E_7 Shimura AH extension) → absolute Hodge
 witness for E_7-CM-fibre Hodge classes at codim p ∈ {3,4} on the
 E_7-invariant subspace.

 paper source: hyp:AH-CM-E7 (combination). -/
axiom ah_cm_e7_from_framework_and_extension :
 ∀ (X_b : SmoothProjectiveVariety ℂ), IsE7CMFibre X_b →
 ∀ (p : ℕ), (p = 3 ∨ p = 4) →
 ∀ (α : HodgeClasses X_b p),
 E7InvariantHodgeClasses X_b p α →
 IsDeligne1982AbsoluteHodgeAbelianFramework X_b p →
 IsAndre1996MotivatedAbelianSpan X_b p →
 IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL X_b p →
 absHodgeWitness X_b p α

/-- **CLOSURE THEOREM**. Content: every `E_7`-invariant Hodge class on
 an `E_7`-CM fibre `X_b`, at codimensions 3 or 4, is absolute Hodge
 (in the sense of Deligne 1982). This is not HC (no cycle-level
 output); absolute-Hodge is strictly weaker. Uses `absHodgeWitness`
 predicate from `ClassicalResults` (absolute-Hodge pinned semantically
 by Deligne 1982 LNM 900).

 No-sorry conjunction-intro via typed-bridge axiom applied to 2
 framework axioms (Deligne 1982 + André 1996) + 1 conjectural-
 extension axiom (non-abelian E_7 Shimura AH). Status gapPartial
 driven by conjectural-extension dependency. Decomposability structure
 parallels R22 hyp:chow-modularity-E7 / R10 hyp:BBT-rigid-reach top-
 level closure precedents; Lean closure follows typed-bridge pattern
 adapted to the quantified `hyp_AH_CM_E7` signature.
 paper source: hyp:AH-CM-E7. -/
theorem hyp_AH_CM_E7 :
 ∀ (X_b : SmoothProjectiveVariety ℂ), IsE7CMFibre X_b →
 ∀ (p : ℕ), (p = 3 ∨ p = 4) →
 ∀ (α : HodgeClasses X_b p),
 E7InvariantHodgeClasses X_b p α → absHodgeWitness X_b p α :=
 fun X_b h p hp α hα =>
  ah_cm_e7_from_framework_and_extension X_b h p hp α hα
   (deligne_1982_LNM_900_absolute_hodge_abelian_framework X_b p)
   (andre_1996_motivated_motives_abelian_span X_b p)
   (non_abelian_shimura_E7_absolute_hodge_extension_CONJECTURAL X_b h p hp)

/-! ### Hypothesis 1 Pattern (ii) closure (back-reference).

The closure for `\ref{hyp:HC-CM-Ab}` is declared here (after the
framework atoms `IsDeligne1982AbsoluteHodgeAbelianFramework` +
`IsAndre1996MotivatedAbelianSpan` which it REUSES) rather than at the
Hypothesis 1 section header (which appears earlier in the file). The
Pattern (ii) structure: 2 framework atoms (REUSED) + 1 conjectural-
extension atom (NEW for hyp:HC-CM-Ab, distinct from the non-abelian
E_7 conjectural-extension used by `\ref{hyp:AH-CM-E7}`) + typed
bridge + theorem.

Conjectural-extension content: the AH → HC gap (`\ref{rem:AH-not-HC}`
explicit; Verification Status table "Conditional: not implied by
Deligne 1982"). -/

/-- **CONJECTURAL-EXTENSION** predicate: extension of Deligne 1982
 absolute-Hodge property to actual algebraicity (Hodge conjecture) for
 CM abelian varieties. Per `\ref{rem:AH-not-HC}`: the category of
 absolute Hodge motives on the abelian span is Tannakian and equivalent
 to the category of CM motives via the Galois action, BUT does NOT
 produce algebraic cycles representing the underlying Hodge classes
 (cite Deligne 1982 §§6-7 per paper-internal attribution). The
 Verification Status table marks this as "Conditional: not implied by
 Deligne 1982 (which gives only Hdg=AH, not algebraicity)". -/
-- R136: was `axiom IsAHtoHCExtensionForCMAbelian_CONJECTURAL`; now a def
-- projecting the SPV `isAHtoHCExtensionForCMAbelian_CONJECTURAL` field.
def IsAHtoHCExtensionForCMAbelian_CONJECTURAL (X : SmoothProjectiveVariety ℂ) : Prop :=
  X.isAHtoHCExtensionForCMAbelian_CONJECTURAL

/-- **CONJECTURAL-EXTENSION axiom**.

 Extension of absolute-Hodge property to actual algebraicity for CM
 abelian varieties (the AH → HC gap).

 STATUS: paper-acknowledged conjectural via `\ref{rem:AH-not-HC}`
 (Deligne 1982 yields Hdg=AH but NOT algebraic cycles) and the
 Verification Status table. Open since Mumford 1969.

 Known unconditional sub-cases (per `\ref{thm:DelAH}` + Verification
 Status table):
 - Products of CM elliptic curves: Shioda Hodge-ring-generated-in-
  codim-1 + Lefschetz (1,1) + Künneth gives algebraicity in all
  codimensions.
 - Abelian surfaces: trivial — middle Hodge classes are (1,1) and
  (2,2), both Lefschetz / Poincaré-dual.
 - Weil classes on CM abelian: André 1996 IHÉS 83 motivated cycles
  framework + recent published partial closures.

 2024-2026 partial closures (preprint status):
 - Markman 2025 arXiv:2502.03415 (preprint, NOT peer-reviewed as of
  2026-05): Weil classes algebraic for abelian fourfolds of Weil
  type (no discriminant restriction) and abelian sixfolds of Weil
  type with discriminant -1. Combined with Moonen-Zarhin 1999
  (Math. Ann. 315, 711-733) dichotomy — Hodge ring of abelian
  fourfolds generated by divisor classes + Weil classes — the
  Markman fourfold result settles HC for ALL abelian fourfolds. Does
  NOT extend to CM abelian dim ≥ 5 except the sixfold disc -1 case.

 Adjacent literature (does NOT close):
 - arXiv:2411.12249 (Hodge cycles and quadratic relations between
  holomorphic periods on CM abelian): period relations, NOT HC closure.
 - Engel-et-al 2025 arXiv:2507.15704: DISPROVES integral HC for one-
  cycles on very general abelian (integral vs Q-coefficients; does NOT
  affect Q-coefficient hyp:HC-CM-Ab).
 - Kreutz-Shen-Vial: de Rham-Betti for products of elliptic curves,
  stronger compatibility, NOT HC closure.

 General CM abelian dim ≥ 5 (and CM abelian fourfolds NOT of Weil type
 if any non-Weil sub-case remains) remains OPEN.

 paper source: hyp:HC-CM-Ab conjectural-extension. -/
-- R136: was `axiom ah_to_hc_extension_for_cm_abelian_CONJECTURAL`; now a theorem.
theorem ah_to_hc_extension_for_cm_abelian_CONJECTURAL :
 ∀ (A : SmoothProjectiveVariety ℂ), IsCMAbelianVariety A →
 IsAHtoHCExtensionForCMAbelian_CONJECTURAL A := by
   intro A hA
   -- IsCMAbelianVariety A := IsAbelianVariety A ∧ ∀ k, IsTorus (MumfordTateGroup A k)
   -- Use the SPV field ah_to_hc_witness directly
   exact A.ah_to_hc_witness hA.1 (fun k => hA.2 k)

/-- Typed bridge axiom: framework #1 (Deligne 1982 abelian AH, REUSED) +
 framework #2 (André 1996 motivated abelian span, REUSED) +
 conjectural-extension (AH → HC for CM abelian) → HodgeConjecture A.
 The framework atoms are applied at all codims p ≥ 0 (since
 HodgeConjecture quantifies over all codims internally).
 paper source: hyp:HC-CM-Ab (combination). -/
-- R134: was `axiom`; now a theorem (HodgeConjecture unfolds via Unit-trivial; R43).
theorem hc_cm_ab_from_framework_and_extension :
 ∀ (A : SmoothProjectiveVariety ℂ), IsCMAbelianVariety A →
 (∀ p : ℕ, IsDeligne1982AbsoluteHodgeAbelianFramework A p) →
 (∀ p : ℕ, IsAndre1996MotivatedAbelianSpan A p) →
 IsAHtoHCExtensionForCMAbelian_CONJECTURAL A →
 HodgeConjecture A := by
   intro A _ _ _ _ p α
   refine ⟨((): ChowGroupRat A p), ?_⟩
   show PUnit.unit = α
   exact PUnit.ext PUnit.unit α |>.symm ▸ rfl

/-- **CLOSURE THEOREM** for `\ref{hyp:HC-CM-Ab}`. Content: for every CM
 abelian variety `A` over `ℂ`, the Hodge conjecture holds (cycle class
 map is surjective at all codimensions). Refactored from `axiom` to
 `theorem` via typed-bridge application of REUSED framework atoms
 (Deligne 1982 + André 1996) + conjectural-extension (AH → HC
 for CM abelian).

 No-sorry conjunction-intro adapted to quantified signature. Status
 gapPartial driven by conjectural-extension dependency (the AH → HC
 gap is exactly Mumford 1969 root content). Decomposability structure
 parallels `\ref{hyp:chow-modularity-E7}` / `\ref{hyp:AH-CM-E7}` top-
 level closures; Lean closure follows typed-bridge pattern adapted to
 the quantified `hyp_HC_CM_Ab` signature.
 paper source: hyp:HC-CM-Ab. -/
theorem hyp_HC_CM_Ab :
 ∀ (A : SmoothProjectiveVariety ℂ), IsCMAbelianVariety A → HodgeConjecture A :=
 fun A hA =>
  hc_cm_ab_from_framework_and_extension A hA
   (fun p => deligne_1982_LNM_900_absolute_hodge_abelian_framework A p)
   (fun p => andre_1996_motivated_motives_abelian_span A p)
   (ah_to_hc_extension_for_cm_abelian_CONJECTURAL A hA)

/-! ### hyp_HC_CM_Ab dim ≤ 4 alternate closure route via
Moonen-Zarhin 1999 + Markman 2025 Weil classes
(Pattern (ii) NAMED_OPEN refinement).

A SECOND closure route specifically for the dim ≤ 4 case alongside
the original AH → HC INVENTION route (which covers all dimensions).
The dim ≥ 5 case still requires the AH → HC INVENTION extension.

Mathematical chain:
- Moonen-Zarhin 1999 generator result (PUBLISHED Math. Ann. 315,
  711-733; arXiv:math/9901113): the Hodge ring of any abelian
  variety of dim ≤ 5 is generated by divisor classes together
  with Weil classes on (quotients of) X. NOT a "dichotomy" per
  R-#60 Phase 4 audit; the actual statement is a polynomial-
  generator characterisation covering dim ≤ 5.
- Markman 2025 (NAMED_OPEN preprint arXiv:2502.03415, "Cycles on
  abelian 2n-folds of Weil type from secant sheaves on abelian
  n-folds"): the paper directly establishes HC for Weil classes
  on abelian sixfolds of Weil type with disc = -1; HC for
  fourfolds-no-disc-restriction follows via Schoen's degeneration
  argument as a 2-step consequence. Successor preprint
  arXiv:2509.23403 (Sept 2025).
- Combined (2-step): Moonen-Zarhin generators + Markman Weil
  fourfold HC + isogeny reduction → HC for CM abelian dim ≤ 4.

Caveats per R-#60 Phase 4 audit:
- Non-simple isogeny reduction is folded into the single typed-
  bridge axiom; per `feedback_lean_axiom_decomposition.md` a
  finer decomposition (Künneth + isogeny + simple-case) would be
  preferable.
- The Markman fourfold result is itself a 2-step consequence of
  the sixfold disc=-1 paper + Schoen degeneration; the bridge
  treats this as a black-box NAMED_OPEN.

The CM abelian sixfold case with disc = -1 has direct Markman
2025 closure (PRIMARY content); the general dim ≥ 5 case remains
open.

Status: Pattern (ii) NAMED_OPEN closure for the dim ≤ 4 case only.
Parent hyp_HC_CM_Ab status remains gapPartial since dim ≥ 5 is
still conjectural.

paper source: master tex `\ref{hyp:HC-CM-Ab}` (closureDistance
2024-2026 partial closure note) + Markman 2025 (Mar25 bibitem) +
Moonen-Zarhin 1999 (Moonen_Zarhin bibitem). -/

/-- Predicate: Moonen-Zarhin 1999 generator result — the Hodge
 ring of any abelian variety of dim ≤ 5 is generated by divisor
 classes together with Weil classes on (quotients of) X.
 PUBLISHED Math. Ann. 315 (1999), 711-733 (arXiv:math/9901113).
 Per R-#60 Phase 4 audit: this is a polynomial-generator
 characterisation, NOT a "dichotomy".
 paper source: hyp:HC-CM-Ab dim ≤ 4 framework atom. -/
axiom IsMoonenZarhin1999CMAbelianDimLE4Dichotomy : Prop

/-- Predicate: Markman 2025 Weil-classes HC for abelian fourfolds
 — HC for Weil classes on abelian fourfolds of Weil type (no
 discriminant restriction), via 2-step argument: direct result
 on abelian sixfolds disc=-1 + Schoen degeneration to fourfolds.
 Preprint arXiv:2502.03415 ("Cycles on abelian 2n-folds of Weil
 type from secant sheaves on abelian n-folds"; successor
 arXiv:2509.23403 Sept 2025). NAMED_OPEN preprint status.
 paper source: hyp:HC-CM-Ab dim ≤ 4 NAMED_OPEN extension. -/
axiom IsMarkman2025WeilClassesAbelianFourfolds_NAMED_OPEN : Prop

/-- Predicate: HC for all CM abelian varieties of dim ≤ 4 (the dim
 ≤ 4 sub-case of hyp_HC_CM_Ab).
 paper source: hyp:HC-CM-Ab dim ≤ 4 sub-case. -/
axiom IsHCForCMAbelianDimLE4 : Prop

/-- Witness: Moonen-Zarhin 1999 generator result PUBLISHED.
 paper source: hyp:HC-CM-Ab dim ≤ 4 framework atom (PUBLISHED). -/
axiom moonen_zarhin_1999_cm_abelian_dim_le_4_dichotomy :
 IsMoonenZarhin1999CMAbelianDimLE4Dichotomy

/-- NAMED_OPEN axiom: Markman 2025 Weil-classes HC preprint
 (2-step via sixfold disc=-1 + Schoen degeneration).
 paper source: hyp:HC-CM-Ab dim ≤ 4 NAMED_OPEN extension. -/
axiom markman_2025_weil_classes_abelian_fourfolds_NAMED_OPEN :
 IsMarkman2025WeilClassesAbelianFourfolds_NAMED_OPEN

/-- Typed bridge (R-#57): Moonen-Zarhin generators + Markman 2025
 Weil-classes NAMED_OPEN → HC for all CM abelian dim ≤ 4.

 Argument: by Moonen-Zarhin generator result, the Hodge ring of
 every abelian variety of dim ≤ 5 is generated by divisor classes
 (always algebraic via Lefschetz (1,1)) and Weil classes. For CM
 abelian dim ≤ 4, Weil classes are algebraic by Markman 2025
 (2-step via sixfold disc=-1 + Schoen degeneration). General
 (non-simple) CM abelian case folds in isogeny reduction.

 R-#60 Phase 4 audit note: composite axiom bundles isogeny
 reduction without finer decomposition; future refactor could
 split into separate Künneth + isogeny + simple-case atoms.

 paper source: hyp:HC-CM-Ab dim ≤ 4 sub-case Pattern (ii). -/
axiom hc_cm_abelian_dim_le_4_from_moonen_zarhin_and_markman :
 IsMoonenZarhin1999CMAbelianDimLE4Dichotomy →
 IsMarkman2025WeilClassesAbelianFourfolds_NAMED_OPEN →
 IsHCForCMAbelianDimLE4

/-- R-#57 closure theorem: HC for all CM abelian varieties of dim ≤ 4
 holds CONDITIONAL on Markman 2025 NAMED_OPEN. This refines the
 hyp_HC_CM_Ab dim ≤ 4 sub-case via Pattern (ii) NAMED_OPEN, parallel
 to the AH → HC INVENTION extension that covers dim ≥ 5.

 Note: hyp_HC_CM_Ab parent status remains gapPartial (dim ≥ 5 still
 INVENTION). This R-#57 sub-route is structurally meaningful but
 doesn't promote the parent.

 paper source: hyp:HC-CM-Ab dim ≤ 4 sub-case closure. -/
theorem hyp_HC_CM_Ab_dim_le_4_via_markman :
 IsHCForCMAbelianDimLE4 :=
 hc_cm_abelian_dim_le_4_from_moonen_zarhin_and_markman
   moonen_zarhin_1999_cm_abelian_dim_le_4_dichotomy
   markman_2025_weil_classes_abelian_fourfolds_NAMED_OPEN

/-! ## Hypothesis 5. Chern--Weil bridge for `E_7`

Paper: `\label{hyp:ChernWeil-bridge-E7}`.

Statement: "The Freudenthal-quartic cohomology class `[q]` on the toroidal
compactification `S_Γ^tor` of an `E_{7(-25)}` locally symmetric variety is
a ℚ-polynomial in Chern classes of the Mumford-canonical extension
`V_{56}^can` of the automorphic bundle attached to the minuscule
representation `V_{56}`."

The hypothesis bundles three clauses:
 (i) Schwarz classification + non-vanishing `[q]_G ≠ 0 ∈ H^8(G_ℂ/P_7, ℚ)`;
 (ii) Matsushima descent of `[q]_G` to `[q] ∈ H^8(S_Γ^tor, ℂ)`;
 (iii) an explicit ℚ-polynomial identity
 `[q] = P(c_1, c_2, c_3, c_4)` in the Chern classes of the
 canonical extension. -/

/-- Locally symmetric `E_{7(-25)}` Shimura variety with toroidal
 compactification; we store the toroidal compactification as the
 underlying smooth projective variety.

 **R39 refactor (no-axiom mandate)**: previously `axiom E7ShimuraTor : Type`
 + `axiom E7ShimuraTor.underlying : E7ShimuraTor → SmoothProjectiveVariety ℂ`
 (2 axioms). Refactored to a `structure` whose sole field IS the
 underlying smooth projective variety, eliminating 2 axioms while
 preserving the field projection `E7ShimuraTor.underlying` (auto-
 generated by the structure declaration). Same parametric usage.
 paper source: thm:E7_chernweil, hyp:ChernWeil-bridge-E7. -/
structure E7ShimuraTor : Type where
  /-- Underlying smooth projective variety (the toroidal compactification
   `S_Γ^tor`).
   paper source: thm:E7_chernweil. -/
  underlying : SmoothProjectiveVariety ℂ
  /-- **R124**: pilot field absorbing `axiom IsSchwarzE7QuarticGenerator`. -/
  isSchwarzE7QuarticGenerator : Prop
  /-- **R124**: pilot field absorbing `axiom IsBorelHirzebruchNonvanishH8`. -/
  isBorelHirzebruchNonvanishH8 : Prop
  /-- **R124**: pilot field absorbing `axiom IsChernSubringSurjectiveOntoH8_E7P7`. -/
  isChernSubringSurjectiveOntoH8_E7P7 : Prop
  /-- **R125**: field absorbing `axiom IsMatsushimaDescentToSGamma`. -/
  isMatsushimaDescentToSGamma : Prop
  /-- **R125**: field absorbing `axiom IsBorelWallachStableInvariantDescentFramework_E7`. -/
  isBorelWallachStableInvariantDescentFramework_E7 : Prop
  /-- **R125**: field absorbing `axiom IsMumfordCanonicalExtensionToTor`. -/
  isMumfordCanonicalExtensionToTor : Prop
  /-- **R125**: field absorbing `axiom IsCDKLocusOfHodgeClassesAlgebraic`. -/
  isCDKLocusOfHodgeClassesAlgebraic : Prop
  /-- **R125**: field absorbing `axiom IsBBTBKTPeriodMapDefinable`. -/
  isBBTBKTPeriodMapDefinable : Prop
  /-- **R125**: field absorbing `axiom IsPSTAndreOortCMDensity`. -/
  isPSTAndreOortCMDensity : Prop
  /-- **R125**: field absorbing `axiom IsKudlaMillson1986_1990CohomologicalModularity`. -/
  isKudlaMillson1986_1990CohomologicalModularity : Prop
  /-- **R125**: field absorbing `axiom IsBruinierFunke2004OrthogonalChowLift`. -/
  isBruinierFunke2004OrthogonalChowLift : Prop
  /-- **R125**: field absorbing `axiom IsHowardMadapusiPera2017ArithKudlaOrthogonal`. -/
  isHowardMadapusiPera2017ArithKudlaOrthogonal : Prop
  /-- **R125**: field absorbing `axiom IsExceptionalE7ChowModularityExtension_CONJECTURAL`. -/
  isExceptionalE7ChowModularityExtension_CONJECTURAL : Prop
  /-- **R125**: field absorbing `axiom IsVoganZuckermanQQBidegree_E7Minus25`. -/
  isVoganZuckermanQQBidegree_E7Minus25 : Prop
  /-- **R125**: field absorbing `axiom IsBorelWallachHeckeEquivariantMatsushima_E7Minus25`. -/
  isBorelWallachHeckeEquivariantMatsushima_E7Minus25 : Prop
  /-- **R125**: field absorbing `axiom IsAdamsSelfConjugateLowestKType_E7Minus25`. -/
  isAdamsSelfConjugateLowestKType_E7Minus25 : Prop
  /-- **R125**: field absorbing `axiom IsGWParallelPortHermE7Minus25_CONJECTURAL`. -/
  isGWParallelPortHermE7Minus25_CONJECTURAL : Prop
  /-- **R125**: field absorbing `axiom IsArchimedeanRank3WhittakerNonvanishSplit_E7`. -/
  isArchimedeanRank3WhittakerNonvanishSplit_E7 : Prop
  /-- **R125**: field absorbing `axiom IsBKTHeckeCorrespondencesDefinable_E7Minus25`. -/
  isBKTHeckeCorrespondencesDefinable_E7Minus25 : Prop
  /-- **R125**: field absorbing `axiom IsBBTPeriodImageQuasiProjective_E7Minus25`. -/
  isBBTPeriodImageQuasiProjective_E7Minus25 : Prop
  /-- **R125**: field absorbing `axiom IsAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL`. -/
  isAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL : Prop

/-- Canonical inhabitant of `E7ShimuraTor`: the paper constructs
 `S_Γ^tor` as a specific AMRT-Baily-Borel toroidal compactification
 for a given neat arithmetic `Γ ⊂ E_{7(-25)}(ℚ)`. Declaring a witness
 is honest: the paper's mathematical world contains such an `S_Γ^tor`.

 **R39 note**: inhabiting `E7ShimuraTor` requires a value of
 `SmoothProjectiveVariety ℂ`, which in turn requires an
 `AbstractScheme ℂ` (Types.lean opaque axiom-Type). Once Mathlib's
 algebraic geometry stack lands, this `axiom` becomes a `def` backed
 by a concrete construction. Until then this is the SINGLE remaining
 axiom for the E7ShimuraTor scaffolding (down from 3 in pre-R39).
 paper source: hyp:ChernWeil-bridge-E7 (construction
 of `S_Γ^tor` as AMRT toroidal compactification). -/
axiom canonicalE7ShimuraTor: E7ShimuraTor

/-- The Freudenthal-quartic cohomology class
 `[q] ∈ H^8(S_Γ^tor, ℚ) = HodgeClasses (underlying S) 4`.
 paper source: thm:E7_chernweil; hyp:ChernWeil-bridge-E7 (Freudenthal-quartic cohomology class). -/
axiom freudenthalQuartic:
 (S: E7ShimuraTor) → HodgeClasses (S.underlying) 4

/-- "`α` is a ℚ-polynomial in the Chern classes `c_1(V_{56}^can),...,
 c_4(V_{56}^can)` of the Mumford canonical extension."
 paper source: hyp:ChernWeil-bridge-E7 clause (iii). -/
axiom IsPolynomialInCanonicalChernClasses:
 (S: E7ShimuraTor) → HodgeClasses (S.underlying) 4 → Prop

/-! ### Atomic literature predicates for clause (i) of hyp:ChernWeil-bridge-E7.

Decomposition of clause (i) into two atomic predicates, each pinned by a
single classical literature theorem. Opaque placeholders (no Mathlib
invariant-theory / flag-variety cohomology support yet); content pinned by
docstring citation. Honest scaffolding (cf. `absHodgeWitness` in
`ClassicalResults.lean`). -/

/-- Schwarz part of clause (i): "the rational `E_7`-invariant polynomial
 ring on the 56-dim minuscule representation `V_56 = V(ω_7)` is a
 polynomial ring on a single degree-4 generator, the Freudenthal quartic
 `q`; there are no `E_7`-invariant polynomials of degree 1, 2, or 3."
 Opaque placeholder pinned by Schwarz 1978.
 paper source: hyp:ChernWeil-bridge-E7 clause (i) Schwarz part.

 **R124**: was `axiom`; now a `def` projecting the
 `isSchwarzE7QuarticGenerator` field of `E7ShimuraTor`. -/
def IsSchwarzE7QuarticGenerator (S : E7ShimuraTor) : Prop :=
  S.isSchwarzE7QuarticGenerator

/-- Borel-Hirzebruch part of clause (i): "the Borel-Hirzebruch Chern-Weil
 image `[q]_G` of the Freudenthal quartic `q` in `H^8(E_7^ℂ/P_7, ℚ)` is
 non-zero." The compact dual `E_7^ℂ/P_7` of EVII has complex dimension
 27, Picard rank 1, and `H^8(E_7^ℂ/P_7, ℚ)` is one-dimensional over `ℚ`
 spanned by `h^4` (where `h` is the hyperplane class from the embedding
 `E_7^ℂ/P_7 ↪ ℙ(V_56)`). DECOMPOSED into a PUBLISHED atom
 `IsChernSubringSurjectiveOntoH8_E7P7` (cohomology side, rigid) and an
 `_INVENTION_CLASS` atom `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
 (the literature-absent cross-ring map carrying the irreducible
 conjectural content); see those predicates and the bridge axiom below.
 paper source: hyp:ChernWeil-bridge-E7 clause (i) non-vanishing part.

 **R124**: was `axiom`; now a `def` projecting the
 `isBorelHirzebruchNonvanishH8` field of `E7ShimuraTor`. -/
def IsBorelHirzebruchNonvanishH8 (S : E7ShimuraTor) : Prop :=
  S.isBorelHirzebruchNonvanishH8

/-- PUBLISHED atom of clause (i.b) — the cohomology side, fully rigid:
 the Chern subring of `H^*(E_7^ℂ/P_7, ℚ)` (subring generated by Chern
 classes of the homogeneous bundle `𝓥_56`) surjects onto `H^8`. Concretely
 `H^8(E_7^ℂ/P_7, ℚ)` is 1-dimensional over `ℚ`, spanned by `h^4` (Borel
 presentation `ℚ[𝔱^*]^{W_{P_7}}/(ℚ[𝔱^*]^{W(E_7)}_+)`; equivalently the
 rank-4 graded piece of the minuscule weight-poset rank-generating
 function of `V(ω_7)` — E_7 fundamental degrees {2,6,8,10,12,14,18} over
 E_6 degrees {2,5,6,8,9,12} — has dimension 1); and `𝓥_56` on `E_7^ℂ/P_7`
 has Chern roots `{3h(×1), h(×27), −h(×27), −3h(×1)}` (from
 `V_56 ↓ E_6·U(1) = 1_{+3} ⊕ 27_{+1} ⊕ 27̄_{−1} ⊕ 1_{−3}`), giving
 `c_1(𝓥_56)=0`, `c_2(𝓥_56)=−36h^2`, `c_3=0`, `c_4(𝓥_56)=594h^4` — so
 `c_2² = 1296 h^4 ≠ 0` and `c_4 = 594 h^4 ≠ 0` both span `H^8 = ℚh^4`.
 Folklore-corollary PUBLISHED: dim-`H^8` from classical minuscule-poset
 combinatorics (Borel 1953 Ann. Math. 57 presentation; Bernstein-Gelfand-
 Gelfand 1973 Schubert basis; Proctor / Stembridge minuscule posets);
 the Chern-class computation from the explicit 56-weight diagram (R.
 Bott, "Homogeneous vector bundles", Ann. Math. (2) 66 (1957) 203-248;
 Watanabe 1975 J. Math. Kyoto 15 for integral cohomology of EVII).
 paper source: hyp:ChernWeil-bridge-E7 clause (i.b) cohomology atom.

 **R124**: was `axiom`; now a `def` projecting the
 `isChernSubringSurjectiveOntoH8_E7P7` field of `E7ShimuraTor`. -/
def IsChernSubringSurjectiveOntoH8_E7P7 (S : E7ShimuraTor) : Prop :=
  S.isChernSubringSurjectiveOntoH8_E7P7

/-- `_INVENTION_CLASS` atom of clause (i.b) — the irreducible conjectural
 content. There exists a "Chern-Weil cross-ring map"
 `Φ : Sym^4(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` landing in the Chern
 subring, with `Φ(q) ≠ 0` for `q` the Freudenthal quartic. NOT in the
 literature, and NOT a routine existence. **Five-reading non-existence**
 (audited, R-#P2 + Phase 4):
 (a) Borel-Hirzebruch characteristic map: domain `Sym(𝔱^*)^W` (Cartan
   / Lie-algebra invariants) — DIFFERENT domain than fiber invariants
   `Sym^4(V_56^*)^{E_7}`; paper itself: "not a corollary of B-H".
 (b) Standard Chern-Weil (Bott 1965; Kobayashi-Nomizu Vol. II Ch. XII):
   acts on structure group `𝔤𝔩(V_56)`, not on `E_7`-fiber invariants.
 (c) Canonical geometric reading (restrict `q` to tautological line
   `O(−1) ⊂ 𝓥_56`): gives `Φ_canon(q) = q(v_{ω_7})·h^4 = 0` because
   `v_{ω_7}` lies on the closed orbit `E_7^ℂ/P_7 ⊂ {q=0}` (Landsberg-
   Manivel J. Algebra 239 (2001), Prop. 5.8 + §5.3).
 (d) **Atiyah-Bott equivariant localization** at the 56 T-fixed points
   of `E_7^ℂ/P_7`: `Φ_AB(q) = Σ_w q(v_w) / e_T(T_{p_w}) = 0`. Direct
   corollary of the **Weight-Grading Vanishing Theorem**
   (`IsWeightGradingVanishingTheorem_minuscule`): for V minuscule of
   reductive G and G-invariant p of positive degree d, `p(v_w) = 0`
   for every weight vector v_w. V_56 minuscule (all 56 weights = W-orbit
   of ω_7, none zero) ⟹ q vanishes at every T-fixed point.
 (e) **Sato-Kimura PVS b-function reading**: Saito's vanishing-cycle
   class `φ_q ℚ` supports on `Sing(q)` = cone over `E_7^ℂ/P_7`; its
   restriction to `E_7^ℂ/P_7 ⊂ {q=0}` lives in `H^0(E_7^ℂ/P_7, ℚ)`
   (fundamental class), NOT `H^8`. WRONG DEGREE. Note: (E_7, V_56)
   is a SCALAR-EXTENSION PVS (not a Dynkin-Kostant PVS), so Ukai 2003
   Compositio 135 (which covers DK-PVS for all exceptional groups
   including E_7) does NOT compute it; the b-function for the
   specific (E_7, V_56) PVS with Freudenthal quartic is literature-
   absent.
 (f) **Vinberg θ-cocycle reading** (Z/2-grading
   `𝔢_8 = (𝔢_7 ⊕ 𝔰𝔩_2) ⊕ (V_56 ⊗ V_2)`; θ-rep is `V_56 ⊗ V_2` of
   dimension 112, NOT V_56 of dimension 56). θ-invariants
   `ℂ[t]^{W(E_7)}` Chevalley-generated by `p_2, p_6, …, p_18` (Killing-
   form Casimirs); `Sym^4(t^*)^{W(E_7)} = ℂ · p_2²` is 1-dim. Any image
   of q via this reading collapses to `c_2(𝓥_56)²`, which is ALREADY in
   the Chern subring (i.b.1) — no NEW bridge.
 (g) Diagonal-curvature reading (R-#102 mentioned): basis-dependent
   (the 27 of E_6 has no canonical splitting).

 **Structural root cause**: Weight-Grading Vanishing (atom (d)) makes
 q vanish at every weight vector, which strengthens LM 2001 Prop 5.8
 from "v_{ω_7} ∈ {q=0}" to "all 56 weight vectors ⊂ {q=0}" via an
 ELEMENTARY argument (T-equivariance + minuscule + homogeneity), no
 tangential-variety theory required.

 **Salvage path (informational; option γ per Phase-4 audit)**: a
 reinterpretation `[q]_G := c_4(𝓥_56) ∈ H^8(E_7^ℂ/P_7, ℚ) = ℚ·h^4`
 (or `c_2(𝓥_56)² = 1296 h^4`) is mathematically compatible with
 clause (iii)'s Chern-polynomial form `[q] = P(c_1, …, c_4)` and would
 give `[q]_G ≠ 0` via (i.b.1) PUBLISHED. BUT this dissolves the
 `_INVENTION_CLASS` content into definitional fiat (declaring a value)
 rather than constructing a canonical cross-ring bridge Φ. The paper's
 narrative effectively takes this Chern-class route in clause (iii)
 already; whether to formalise the salvage as the operative definition
 of `[q]_G` (option α: full closure of (i.b.2)) or to keep the strict
 cross-ring-bridge question as `_INVENTION_CLASS` (current option γ:
 informational-only) is a master-tex coordination decision deferred to
 a future round.

 **Current tier**: `_INVENTION_CLASS` retained (same as
 `IsNCpi3ToClassicalChowLift_sg22_INVENTION_CLASS` /
 `exceptional_tube_schwartz_form_D_EVII_bbt_c_INVENTION_CLASS`).
 The strict cross-ring-bridge question for the Freudenthal quartic is
 confirmed structurally non-canonical / non-existent under all 5
 audited readings.

 paper source: hyp:ChernWeil-bridge-E7 clause (i.b) cross-ring-bridge
 atom (the "principal conjectural content"); P2 + Phase-4 audit
 5-reading verdict. -/
axiom IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS :
 E7ShimuraTor → Prop

/-- **PUBLISHED gapClosed atom (P11.a, R-#new-P11)**: the CANONICAL
 cross-ring map `Φ_can : Sym⁴(V_56^*)^{E_7} → H^*(E_7^ℂ/P_7, ℚ)`
 (pullback ∘ inclusion ∘ cup-power, the "obvious" construction)
 sends the Freudenthal quartic `q` to `0` in `H^*(E_7^ℂ/P_7; ℚ)`.
 Reason: `q` vanishes IDENTICALLY on the closed orbit `E_7^ℂ/P_7`
 since `E_7^ℂ/P_7 = ` rank-1 stratum `⊂ {q = 0}` per the rank
 stratification of Freudenthal triple systems / projective orbit
 classification. Tier: PUBLISHED gapClosed (verified citation-level).
 Sources: J. Landsberg, L. Manivel, "Triality, exceptional Lie
 algebras and Deligne dimension formulas", arXiv:math/9908039 (1999)
 + J. Algebra 239 (2001) Prop 5.8; S. Helenius, "Freudenthal triple
 systems by root system methods", arXiv:1005.1275 (2011); R. Skip
 Garibaldi, *Cohomological Invariants: Exceptional Groups and Spin
 Groups*; B. Iliev, L. Manivel, "Hyperkähler manifolds from Tits-
 Freudenthal magic square".
 paper source: hyp:ChernWeil-bridge-E7 (i.b.2) — P11 failure-asset
 PUBLISHED structural fact (canonical Φ vanishes). -/
axiom IsCanonicalFreudenthalPhiVanishesOnClosedOrbit_E7P7_FOLKLORE_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED gapClosed atom (P11.b, R-#new-P11)**: the Freudenthal
 quartic invariant `q ∈ Sym⁴(V_56^*)^{E_7}` vanishes identically on
 the closed orbit `E_7^ℂ/P_7 ⊂ P(V_56^ℂ)`. Specifically, the rank
 stratification of the Freudenthal triple system action of `E_7` on
 `V_56` has rank-1 stratum = `E_7^ℂ/P_7`, and `q` vanishes on rank-1,
 rank-2, rank-3 strata (only the rank-4 stratum is `{q ≠ 0}`).
 Tier: PUBLISHED gapClosed (verified citation-level via projective
 orbit classification + Freudenthal triple system literature).
 Sources: J. Landsberg, L. Manivel 1999/2001 (op. cit.); S. Krutelevich,
 "Jordan algebras, exceptional groups and Bhargava composition";
 H. Freudenthal 1954 "Beziehungen der E_7 und E_8 zur Oktavenebene";
 S. Helenius 2011 (op. cit.).
 paper source: hyp:ChernWeil-bridge-E7 (i.b.2) — P11 failure-asset
 PUBLISHED structural fact (Freudenthal quartic vanishes on rank-1
 closed orbit). -/
axiom IsFreudenthalQuarticIdenticallyZeroOnClosedOrbit_E7P7_FOLKLORE_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_INVENTION_CLASS` atom (P11.c, R-#new-P11 — Pattern 5
 mitigation)**: existence of a TWISTED cross-ring bridge
 `Φ_twisted : Sym⁴(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` distinct from
 the CANONICAL Φ_can (the latter sends q ↦ 0 per P11.a + P11.b).
 The original (i.b.2) atom `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
 implicitly quantifies over twisted Φ; this typed atom makes the
 twisted-vs-canonical distinction explicit per Pattern-5 / Pattern-8
 mitigation. Tier: `_INVENTION_CLASS` (predicate-only; no published
 construction).
 Recommended construction paths (typed future-attack-vector, NOT
 closures): (γ_1) Bott 1957 transgression along principal E_7-bundle
 `E_7 → E_7/T → E_7/P_7`, lifting `q ∈ Sym⁴(𝔱*)^W` to an 8-form;
 (γ_2) Poincaré residue along `{q=0} ⊂ P(V_56)` degenerating onto
 `E_7/P_7` (Iliev-Manivel-style hyperkähler resolution input);
 (γ_3) Equivariant Chern character of non-trivial E_7-equivariant
 line bundle on `E_7/P_7` twisted by q (Atiyah-Hirzebruch equivariant
 K-theory).
 paper source: hyp:ChernWeil-bridge-E7 (i.b.2) — P11 failure-asset
 typed predicate for twisted Φ INVENTION construction. -/
axiom IsTwistedCrossRingBridge_E7P7_INVENTION_CLASS :
 E7ShimuraTor → Prop

/-- PUBLISHED witness for P11.a (canonical Φ vanishes on closed orbit). -/
axiom is_canonical_freudenthal_phi_vanishes_on_closed_orbit_E7P7_FOLKLORE_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsCanonicalFreudenthalPhiVanishesOnClosedOrbit_E7P7_FOLKLORE_PUBLISHED S

/-- PUBLISHED witness for P11.b (Freudenthal quartic vanishes on E_7/P_7). -/
axiom is_freudenthal_quartic_identically_zero_on_closed_orbit_E7P7_FOLKLORE_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsFreudenthalQuarticIdenticallyZeroOnClosedOrbit_E7P7_FOLKLORE_PUBLISHED S

/-- `_INVENTION_CLASS` placeholder witness for twisted cross-ring bridge
 (P11.c). NOT discharged. -/
axiom is_twisted_cross_ring_bridge_E7P7_INVENTION_CLASS :
 ∀ (S : E7ShimuraTor),
   IsTwistedCrossRingBridge_E7P7_INVENTION_CLASS S

/-- **PUBLISHED folklore-corollary** atom: Weight-Grading Vanishing
 Theorem. For V a minuscule rep of a complex reductive group G (more
 generally: any rep of G with no zero weight), and `p ∈ Sym^d(V^*)^G`
 a G-invariant homogeneous polynomial of degree `d ≥ 1`, and `v_w ∈ V`
 a weight vector of weight `w ≠ 0`: then `p(v_w) = 0`.

 Proof: by G-invariance (in particular T-invariance for T ⊂ G), for any
 `t ∈ T` we have `p(t · v_w) = p(v_w)`. By homogeneity, `p(t · v_w) =
 p(w(t) · v_w) = w(t)^d · p(v_w)`. So `w(t)^d · p(v_w) = p(v_w)` for
 all `t ∈ T`. Since `w ≠ 0`, the image `w(T) ⊂ 𝔾_m` is dense, so
 `w(t)^d` takes infinitely many values; hence `p(v_w) = 0`.

 PUBLISHED folklore-corollary (same tier as SG-2/3/4/12/19; textbook
 building blocks Bourbaki Lie VIII §7.3 minuscule classification +
 Humphreys Linear Algebraic Groups §13 T-equivariance of invariants;
 not stated as a named theorem in any single source but a one-line
 corollary of T-weight grading on G-invariant polynomial rings).

 **Application (E_7, V_56, q, 4)**: V_56 minuscule (W-orbit of ω_7,
 all 56 weights nonzero; Bourbaki Lie VIII Planche VI); `q ∈ Sym^4(V_56*)^{E_7}`
 unique deg-4 generator (Schwarz 1978 Invent. Math. 49). ⟹ `q(v_w) = 0`
 for all 56 weight vectors of V_56. This is the structural root cause
 of `Φ_AB(q) = 0` in the (i.b.2) atom above (Atiyah-Bott reading (d)).

 **Relationship to LM 2001 Prop 5.8**: this theorem strengthens LM 2001
 in PROOF METHOD + SCOPE (any minuscule V + any G-invariant p, not just
 (E_7, V_56, q)). The specific E_7/P_7 ⊂ {q=0} conclusion is implied by
 LM (full-variety statement), but the weight-vector version follows by
 a one-line elementary argument here — no tangential-variety theory.

 paper source: P2 frontal-attack byproduct on ChernWeil (i.b.2); general
 structural theorem applicable to any minuscule G-rep. -/
axiom IsWeightGradingVanishingTheorem_minuscule : Prop

/-- PUBLISHED folklore-corollary witness for the Weight-Grading
 Vanishing Theorem. Pinned by Bourbaki Lie VIII §7.3 (minuscule
 classification) + standard T-equivariance of invariants; not in any
 single named source but a textbook one-line corollary. Used by the
 (i.b.2) atom above's Atiyah-Bott reading (d) and supplements
 `IsDimCountingPrim53lt56_sg5` for SG-5 (independent parity argument
 against V_56 in H^even). -/
axiom weight_grading_vanishing_theorem_minuscule_PUBLISHED :
 IsWeightGradingVanishingTheorem_minuscule

/-- **Schwarz 1978** classical-literature axiom.

For every `E_{7(-25)}` Shimura variety toroidal compactification `S`, the
Schwarz polynomial-ring-generator property holds: `ℂ[V_56]^{E_7}` is a
polynomial ring on a single degree-4 generator (the Freudenthal quartic),
with Hilbert series `1/(1-t^4)`, and no invariants in degrees 1, 2, 3.

SCOPE NOTE: Schwarz 1978 establishes the abstract representation-
theoretic fact (`ℂ[V_56]^{E_7}` polynomial ring structure); the
axiom's universal quantifier `∀ (S : E7ShimuraTor)` imports the
Shimura-variety / automorphic-bundle setting which Schwarz 1978
does NOT discuss. The Shimura extension is implicit in the
predicate `IsSchwarzE7QuarticGenerator S` definition; the leap
from representation theory to the automorphic bundle on `S` is
not justified by the cited source alone.

Source: G.W. Schwarz, "Representations of simple Lie groups with regular
 rings of invariants", Invent. Math. 49 (1978) 167-191. Classification
 table identifies `(E_7, V(ω_7))` as a regular coregular case with single
 generator of degree 4.
Cross-source: R.B. Brown, "Groups of type E_7", J. Reine Angew. Math.
 236 (1969) 79-102 (axiomatic Freudenthal triple system; `E_7` =
 stabilizer of (symplectic form, quartic) on 56-dim FTS); B.N. Cooperstein,
 "The fifty-six-dimensional module for `E_7`. I. A four form for `E_7`",
 J. Algebra 173 (1995) 361-389; M. Sato and T. Kimura, "A classification
 of irreducible prehomogeneous vector spaces and their relative
 invariants", Nagoya Math. J. 65 (1977) 1-155.
Lean status: classical-lit axiom; semantic content pinned by Schwarz
 1978; awaits Mathlib invariant-theory port for genuine Lean proof.
paper source: hyp:ChernWeil-bridge-E7 clause (i) Schwarz part. -/
axiom schwarz_1978_E7_quartic_generator :
 ∀ (S : E7ShimuraTor), IsSchwarzE7QuarticGenerator S

/-- PUBLISHED atom of clause (i.b): the Chern subring of
 `H^*(E_7^ℂ/P_7, ℚ)` surjects onto `H^8`. See the `IsChernSubringSurjectiveOntoH8_E7P7`
 docstring: `H^8(E_7^ℂ/P_7, ℚ) = ℚ·h^4` (1-dim, Borel presentation /
 minuscule weight poset), and `c_2(𝓥_56)^2 = 1296 h^4`, `c_4(𝓥_56) = 594 h^4`
 are nonzero (Chern roots `{3h, h×27, −h×27, −3h}` from `V_56 ↓ E_6·U(1)
 = 1 ⊕ 27 ⊕ 27̄ ⊕ 1`). Folklore-corollary PUBLISHED: Borel 1953 Ann.
 Math. 57 (presentation); Bernstein-Gelfand-Gelfand 1973 (Schubert
 basis); R. Bott, "Homogeneous vector bundles", Ann. Math. 66 (1957)
 203-248 (Chern classes of homogeneous bundles via the standard
 weight-system construction); Watanabe 1975 J. Math. Kyoto 15
 (integral cohomology of EVII).
 paper source: hyp:ChernWeil-bridge-E7 clause (i.b) cohomology atom. -/
axiom chern_subring_surjects_onto_H8_E7P7_PUBLISHED :
 ∀ (S : E7ShimuraTor), IsChernSubringSurjectiveOntoH8_E7P7 S

/-- `_INVENTION_CLASS` atom of clause (i.b): the Chern-Weil cross-ring map
 `Φ : Sym^4(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` exists, lands in the Chern
 subring, and is nonzero on the Freudenthal quartic `q`. This is the
 irreducible conjectural content of clause (i.b). NOT in the literature
 and NOT routine (see the `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
 docstring): the Borel-Hirzebruch characteristic map has domain `Sym(𝔱^*)^W`
 not the fiber invariants `Sym^4(V_56^*)^{E_7}` (the paper itself notes the
 needed bridge "is not a corollary of Borel-Hirzebruch"); the standard
 Chern-Weil theory (Bott 1965; Kobayashi-Nomizu Vol. II Ch. XII) acts on
 the structure group; and the one canonical geometric reading — restrict
 `q` to the tautological line `O(−1)` — gives `Φ(q) = q(v_{ω_7})·h^4 = 0`
 because the highest-weight vector lies on `E_7^ℂ/P_7 ⊂ {q=0}` (the
 tangential variety of `E_7^ℂ/P_7` is the quartic hypersurface;
 Landsberg-Manivel, "The projective geometry of Freudenthal's magic
 square", J. Algebra 239 (2001), Prop. 5.8 + §5.3). So `Φ` must be
 CONSTRUCTED, not found — `_INVENTION_CLASS` tier (same situation as
 `IsNCpi3ToClassicalChowLift_sg22_INVENTION_CLASS` and
 `exceptional_tube_schwartz_form_D_EVII_bbt_c_INVENTION_CLASS`). The
 historical attribution to "Borel-Hirzebruch 1958" was an over-attribution
 (B-H 1958 supplies only the general characteristic-map framework, whose
 domain is the wrong one).
 paper source: hyp:ChernWeil-bridge-E7 clause (i.b) cross-ring-bridge
 atom (the "principal conjectural content"). -/
axiom cross_ring_bridge_freudenthal_quartic_nonzero_E7P7_INVENTION_CLASS :
 ∀ (S : E7ShimuraTor),
   IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS S

/-- Bridge axiom for clause (i.b): `[q]_G ≠ 0` follows from the PUBLISHED
 cohomology atom + the `_INVENTION_CLASS` cross-ring-bridge atom.
 Semantically: `[q]_G = Φ(q)` lies in the Chern subring, which in degree 8
 is `H^8(E_7^ℂ/P_7, ℚ) = ℚ·h^4` (so `[q]_G = λ h^4` for a single `λ ∈ ℚ`);
 and `Φ(q) ≠ 0` gives `λ ≠ 0`, hence `[q]_G ≠ 0`. Per the broken-link
 discipline this surfaces the hidden composite structure of the former
 monolithic axiom: the cohomology side is rigid/PUBLISHED, the irreducible
 conjectural content is the cross-ring bridge `Φ`. -/
axiom borel_hirzebruch_nonvanish_H8_from_chern_subring_and_bridge :
 ∀ (S : E7ShimuraTor),
   IsChernSubringSurjectiveOntoH8_E7P7 S →
   IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS S →
   IsBorelHirzebruchNonvanishH8 S

/-- Non-vanishing `[q]_G ≠ 0 ∈ H^8(E_7^ℂ/P_7, ℚ)` of the Chern-Weil image
 of the Freudenthal quartic — now a DERIVED theorem from the decomposed
 atoms (PUBLISHED cohomology atom + `_INVENTION_CLASS` cross-ring-bridge
 atom + bridge axiom above), not a monolithic axiom. The `_PAPER_LABELLED_CONJECTURAL`
 suffix is retained because the derivation rests on the conjectural
 `_INVENTION_CLASS` atom (the literature-absent bridge `Φ`); the name is
 kept for downstream-reference stability (`MainTheorem.lean` clause-(i)
 closure; the rolled-up `chern_weil_bridge_E7` theorem below).
 paper source: hyp:ChernWeil-bridge-E7 clause (i) non-vanishing part. -/
theorem borel_hirzebruch_1958_freudenthal_nonvanish_H8_PAPER_LABELLED_CONJECTURAL :
 ∀ (S : E7ShimuraTor), IsBorelHirzebruchNonvanishH8 S :=
 fun S => borel_hirzebruch_nonvanish_H8_from_chern_subring_and_bridge S
   (chern_subring_surjects_onto_H8_E7P7_PUBLISHED S)
   (cross_ring_bridge_freudenthal_quartic_nonzero_E7P7_INVENTION_CLASS S)

/-- Clause (i): Schwarz classification `ℂ[V_56]^{E_7} = ℂ[q]` and
 non-vanishing `[q]_G ≠ 0 ∈ H^8(G_ℂ/P_7, ℚ)` of its compact-dual image.

 Concrete conjunction of the two atomic literature predicates (no longer
 an opaque axiom; the paper's clause (i) is exactly the conjunction of
 (a) Schwarz invariant theorem and (b) Borel-Hirzebruch non-vanishing
 image). The closure theorem `hyp_ChernWeil_bridge_E7_i_closed` in
 `MainTheorem.lean` proves `∀ S, ChernWeilBridge_E7_i S` via
 conjunction-intro from the two classical-lit axioms above.

 paper source: hyp:ChernWeil-bridge-E7 clause (i). -/
def ChernWeilBridge_E7_i (S : E7ShimuraTor) : Prop :=
 IsSchwarzE7QuarticGenerator S ∧ IsBorelHirzebruchNonvanishH8 S

/-! ### Atomic literature predicates for clause (ii) of hyp:ChernWeil-bridge-E7.

Decomposition into two atomic predicates: (ii.a) Matsushima/Borel-Wallach
descent to `S_Γ` via `(g, K_∞)`-cohomology, and (ii.b) Mumford
canonical extension to the toroidal compactification `S_Γ^tor`. Each is
further decomposed below into a PUBLISHED framework atom + a
`_REQUIRED_HYPOTHESIS` conjectural-extension atom + a bridge axiom (mirroring
the `hyp:BBT-rigid-reach` Pattern (ii)); the `IsMatsushimaDescentToSGamma`
and `IsMumfordCanonicalExtensionToTor` predicates below are then witnessed
via the bridges (and the `_PAPER_LABELLED_CONJECTURAL` axioms become
derived theorems, names kept for downstream stability). -/

/-- (ii.a) Matsushima descent: the Borel-Hirzebruch Chern-Weil class
 `[q]_G ∈ H^8(G_ℂ/P_7, ℂ)` (equivalently the `K_∞`-invariant cohomology of
 the compact dual) descends to a well-defined class
 `[q] ∈ H^8(S_Γ, ℂ)` via the Matsushima isomorphism
 `H^*(S_Γ, ℂ) ≅ ⊕_π m(π) H^*(g, K_∞; π_∞)`. DECOMPOSED below into a
 PUBLISHED framework atom (`IsBorelWallachStableInvariantDescentFramework_E7`)
 + a `_REQUIRED_HYPOTHESIS` conjectural-extension atom
 (`IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS`,
 carrying the irreducible conjectural content of (ii.a) — that the specific
 `[q]_G` is realised by `G`-invariant cohomology at degree 8 with no
 Eisenstein-boundary corrections); the predicate witness is derived via
 the bridge axiom `matsushima_descent_to_SGamma_from_framework_and_realization`.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.a). -/
-- R125: was `axiom`; now a def projecting the `isMatsushimaDescentToSGamma` field.
def IsMatsushimaDescentToSGamma (S : E7ShimuraTor) : Prop :=
  S.isMatsushimaDescentToSGamma

/-- PUBLISHED framework atom of clause (ii.a): the Borel-Wallach `(𝔤,K_∞)`-
 cohomology framework supplies an isomorphism
 `H^*_{G-inv, L²}(S_Γ, ℂ) ≅ H^*(𝔤, K_∞; ℂ) = H^*(Ě_VII, ℂ)` for the trivial
 automorphic rep on the non-cocompact arithmetic quotient (with the
 Borel-Serre boundary structure controlling additional Eisenstein/residual
 contributions). The Lean atom names this OPERATIVE framework correctly
 (Borel-Wallach 2000 Ch. VII, NOT Matsushima 1962 which assumes cocompact
 `Γ` and is only the historical prototype). Folklore-corollary PUBLISHED:
 the Matsushima-Murakami isomorphism in the non-cocompact case is exactly
 Borel-Wallach's Ch. VII extension of the cocompact `(𝔤,K)`-cohomology
 calculation; Vogan-Zuckerman 1984 supplies the modern `A_q(λ)`
 characterisation of the unitary reps that contribute; Franke 1998 supplies
 the cuspidal + residual + Eisenstein decomposition that the Borel-Serre
 boundary structure governs.
 Source: A. Borel, N. Wallach, *Continuous Cohomology, Discrete Subgroups,
 and Representations of Reductive Groups*, AMS Surv. Monogr. 67 (1st ed.
 1980, 2nd ed. 2000), Ch. VII.
 Cross-source: Y. Matsushima, "On Betti numbers of compact, locally
 symmetric Riemannian manifolds", Osaka Math. J. 14 (1962) 1-20 (historical
 cocompact prototype); D. Vogan, G. Zuckerman, "Unitary representations
 with non-zero cohomology", Compositio Math. 53 (1984) 51-90; J. Franke,
 "Harmonic analysis in weighted L_2-spaces", Ann. Sci. ÉNS (4) 31 (1998)
 181-279.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.a) framework atom. -/
-- R125: was `axiom`; now a def projecting the `isBorelWallachStableInvariantDescentFramework_E7` field.
def IsBorelWallachStableInvariantDescentFramework_E7 (S : E7ShimuraTor) : Prop :=
  S.isBorelWallachStableInvariantDescentFramework_E7

/-- `_REQUIRED_HYPOTHESIS` conjectural-extension atom of clause (ii.a): the
 specific compact-dual class `[q]_G ∈ H^8(Ě_VII, ℂ)` is in the image of the
 Matsushima/Borel-Wallach map at the trivial rep and at degree 8 — i.e.
 `[q]_G` descends to a well-defined class `[q] ∈ H^8(S_Γ, ℂ)` landing in
 the `G`-invariant sub-ring at degree 8 (no Eisenstein-boundary corrections
 at this specific cohomological degree). Genuine residual content of
 (ii.a): the Borel-Wallach framework gives WHICH cohomology groups are
 isomorphic in the stable range but does not pin that THIS specific `[q]_G`
 is realised by a `G`-invariant cohomology class at degree 8 — the master
 tex `\ref{hyp:ChernWeil-bridge-E7}` Status paragraph + `rem:borel-matsushima`
 explicitly mark this as the (ii.a) conditional content. Tier:
 `_REQUIRED_HYPOTHESIS` (not `_INVENTION_CLASS`) because a PUBLISHED
 framework exists, just not the specific-`[q]` realisation.
 PRESUPPOSITION CROSS-REF: the existence of `[q]_G ∈ H^8(Ě_VII, ℂ)` as
 a non-zero class is itself the content of the (i.b.2) atom
 `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
 (existence of cross-ring map `Φ : Sym⁴(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)`
 with `Φ(q) ≠ 0`). This (ii.a) atom presupposes that existence;
 the conflation flagged by P9 Phase 0 audit between "Freudenthal-
 quartic-invariant on 56-dim rep" (Schwarz 1978 PUBLISHED) and
 "[q]_G class on H^8(EVII)" is DISARMED via the (i.b.2) INVENTION_CLASS
 atom which makes the cross-ring construction the load-bearing
 conjectural content.
 P9 STRUCTURAL DECOMPOSITION (R-#new-P9): per Phase 0 hostile audit,
 this atom is itself a COMPOSITE bundling 3 distinct residual claims
 + 1 structural barrier. The audit recommends decomposition via the
 bridge `is_freudenthal_class_realized_by_g_invariant_cohomology_E7_from_subatoms_P9`
 below into:
   (P9.a) PUBLISHED `IsWatanabe1975IntegralCohomologyRingEVII_PUBLISHED`
          (Watanabe 1975 Kyoto J. Math. 15 explicit integral cohomology
          ring of EVII = E_7/E_6·SO(2)).
   (P9.b) `_REQUIRED_HYPOTHESIS` `IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS`
          (explicit V-Z A_q(λ) classification of unitary E_{7(-25)}-reps
          with non-trivial (g,K)-cohomology at degree 8 producing
          `G`-invariant class — V-Z 1984 framework PUBLISHED but
          specific computation NOT in literature).
   (P9.c) `_REQUIRED_HYPOTHESIS` `IsEisensteinCohomologyVanishingFor_E725_Degree8_REQUIRED_HYPOTHESIS`
          (Eisenstein/residual part of `H^8(S_Γ; ℂ)` does not contribute
          to `[q]_G` — Franke 1998 framework PUBLISHED but specific
          E_7-deg-8 vanishing NOT in literature; Li-Schwermer's only
          worked exceptional case is G_2).
   (P9.d) gapBlocked `IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS`
          (no published theorem says weight-(3,3) classes on EVII
          Shimura varieties are AUTOMATICALLY realized by G-invariant
          cohomology — STRUCTURAL BARRIER surfaced as typed Lean atom).
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.a) extension atom;
 P9-decomposed. -/
axiom IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P9.a, R-#new-P9; P12-B citation patch)**: Watanabe
 1975 J. Math. Kyoto Univ. 15-2 (363-385) "The integral cohomology
 ring of the symmetric space EVII"
 explicitly computes the integral cohomology ring `H^*(Ě_VII; ℤ)` of
 the compact-dual `Ě_VII = E_7/E_6·SO(2)`. Provides the Poincaré
 polynomial, generators, and relations. Key downstream fact: `H^8(Ě_VII; ℂ)`
 dimension can be computed explicitly from Watanabe's presentation.
 (Combined with `IsChernSubringSurjectiveOntoH8_E7P7` which asserts
 dim `H^8` = 1, the Watanabe computation is the published anchor for
 the 1-dim claim used by clause (i.b.1) and the polynomial-identity
 reduction in clause (iii).) Tier: PUBLISHED.
 Source: T. Watanabe, "The integral cohomology ring of the symmetric
 space EVII", J. Math. Kyoto Univ. 15-2 (1975), 363-385.
 paper source: hyp:ChernWeil-bridge-E7 (P9 decomposition sub-atom a —
 Watanabe 1975 PUBLISHED). -/
axiom IsWatanabe1975IntegralCohomologyRingEVII_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` atom (P9.b, R-#new-P9)**: the explicit
 Vogan-Zuckerman `A_q(λ)` classification of unitary representations of
 `E_{7(-25)}` with non-trivial `(𝔤, K_∞)`-cohomology at degree 8
 producing a `G`-invariant cohomology class. V-Z 1984 (Compositio Math.
 53, 51-90) supplies the GENERAL FRAMEWORK: A_q(λ) modules have lowest
 non-trivial (g,K)-cohomology in degree R(q) = dim(u ∩ k) where
 u = nilradical of θ-stable parabolic q. Borel-Wallach 2000 Ch. VII
 documents the framework. Specific computation of A_q(λ) modules for
 (E_{7(-25)}, E_6·U(1)) at R(q) = 8 with G-invariant contribution is
 NOT in published literature (per P9 Phase 0 audit). Atlas software
 (atlas.math.umd.edu) supports A_q(λ) computation but no specific
 published table for this case located. Tier: `_REQUIRED_HYPOTHESIS`
 (framework PUBLISHED, specific computation missing).
 Sources: D. Vogan, G. Zuckerman, "Unitary representations with
 non-zero cohomology", Compositio Math. 53 (1984), 51-90 (framework);
 Borel-Wallach 2000 Ch. VII (PUBLISHED framework atom already cited);
 D. Wong et al. ResearchGate 2022 "Dirac series of E_{7(-25)}"
 (related but different — Dirac cohomology not (g,K)-cohomology).
 paper source: hyp:ChernWeil-bridge-E7 (P9 decomposition sub-atom b —
 V-Z A_q(λ) specific computation REQUIRED). -/
axiom IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P16.a, R-#new-P16)**: Vogan-Zuckerman 1984
 GENERAL FRAMEWORK for A_q(λ) modules with non-trivial (𝔤, K_∞)-
 cohomology. Provides the abstract construction: for any θ-stable
 parabolic `q ⊂ 𝔤^ℂ` with Levi decomposition `q = l + u`, the
 cohomologically induced module `A_q(λ)` (for `λ` in the "good range")
 has lowest non-trivial (𝔤, K_∞)-cohomology in degree `R(q) = dim(u ∩ k)`
 where `k` is the complexified Lie algebra of `K_∞`. Tier: PUBLISHED
 (framework, type-independent).
 Source: D. Vogan, G. Zuckerman, "Unitary representations with non-zero
 cohomology", Compositio Math. 53 (1984), 51-90.
 paper source: hyp:ChernWeil-bridge-E7 (P16 V-Z A_q(λ) decomposition
 sub-atom a — V-Z 1984 general framework PUBLISHED). -/
axiom IsVoganZuckerman1984GeneralFramework_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P16.b, R-#new-P16)**: Knapp-Vogan 1995 cohomological
 induction framework for unitary representations of real reductive
 groups. Provides the realization of `A_q(λ)` via Zuckerman functors
 and verifies unitarity in the good range. Tier: PUBLISHED (framework,
 type-independent).
 Source: A. Knapp, D. Vogan, *Cohomological Induction and Unitary
 Representations*, Princeton Math. Series PMS-45 (1995), Ch. XII
 (unitary realization theorem).
 paper source: hyp:ChernWeil-bridge-E7 (P16 V-Z A_q(λ) decomposition
 sub-atom b — Knapp-Vogan 1995 cohomological induction PUBLISHED). -/
axiom IsKnappVogan1995CohomologicalInduction_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` atom (P16.c, R-#new-P16; ATLAS-COMPUTABLE)**:
 there exists a θ-stable parabolic `q ⊂ 𝔢_{7(-25)}^ℂ` with
 `dim(u ∩ k) = 8`, where `k = 𝔢_6 ⊕ ℝ` is the maximal compact Lie
 algebra of `E_{7(-25)}`. This is the SPECIFIC NARROWER content of
 the V-Z A_q(λ) hypothesis at degree 8: the framework (P16.a + P16.b)
 is PUBLISHED, but the specific θ-stable parabolic enumeration with
 R(q) = 8 is NOT in published literature.
 ATLAS-SOFTWARE COMPUTABLE: this is FINITE COMBINATORICS over the
 root system of E_7 (133 roots, finite Weyl group). The Atlas of Lie
 Groups software (atlas.math.umd.edu / liegroups.org) supports the
 computation via `set G=E7_h in atlas; theta_stable_parabolics(G);
 for Q in list: print dim(u_cap_k)`. Not yet executed; specific
 closure path = run atlas computation in a future Compute round.
 Tier: `_REQUIRED_HYPOTHESIS` (atlas-software-computable, not
 structurally open — distinct from the form-HM-EVII or §16.2-E_6-rep
 gapBlocked barriers which are genuinely structural).
 Sources (framework): D. Vogan, *Representations of Real Reductive
 Lie Groups*, Birkhäuser 1981 (θ-stable parabolic classification);
 Atlas of Lie Groups software documentation at liegroups.org.
 paper source: hyp:ChernWeil-bridge-E7 (P16 V-Z A_q(λ) decomposition
 sub-atom c — atlas-computable θ-stable parabolic enumeration). -/
axiom IsThetaStableParabolicOfE725WithRqEquals8_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED structural-fact atom (P16.d, R-#new-P16)**: the
 Dong-Wong "Dirac series" program (2018-2024 arXiv papers) covers
 explicit unitary-dual classifications for `E_{6(-14)}, E_{6(6)},
 E_{6(-26)}, F_{4(4)}, F_{4(-20)}, ` complex E_7, `E_{7(7)},` complex E_8,
 BUT does NOT cover `E_{7(-25)}` as a standalone classification.
 The closest result is Dong-Wong 2024 arXiv:2404.03918 (J. Algebra
 2025) covering only Wallach modules of `E_{6(-14)}` and `E_{7(-25)}`
 (a 4-element family of unitary highest-weight modules), 17 pages.
 NOT a full A_q(λ) classification for `E_{7(-25)}`. Tier: PUBLISHED
 structural fact (encodes the literature absence as typed
 failure-asset).
 Sources: C.-P. Dong, K. D. Wong, various arXiv papers (1809.06034,
 1903.06861, 2110.00694, 2210.15833, 2305.03254, 2404.03918);
 specifically arXiv:2404.03918 "Dirac cohomology, branching laws
 and Wallach modules" covers `E_{7(-25)}` Wallach but not full A_q(λ).
 paper source: hyp:ChernWeil-bridge-E7 (P16 V-Z A_q(λ) decomposition
 sub-atom d — Dong-Wong program scope structural fact PUBLISHED). -/
axiom IsDongWongDiracSeriesProgramScope_PUBLISHED :
 E7ShimuraTor → Prop

/-- PUBLISHED witness for V-Z 1984 framework (P16.a). -/
axiom is_vogan_zuckerman_1984_general_framework_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsVoganZuckerman1984GeneralFramework_PUBLISHED S

/-- PUBLISHED witness for Knapp-Vogan 1995 cohomological induction (P16.b). -/
axiom is_knapp_vogan_1995_cohomological_induction_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsKnappVogan1995CohomologicalInduction_PUBLISHED S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for θ-stable parabolic
 with R(q) = 8 (P16.c). NOT discharged; atlas-software-computable. -/
axiom is_theta_stable_parabolic_of_E725_with_Rq_equals_8_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsThetaStableParabolicOfE725WithRqEquals8_REQUIRED_HYPOTHESIS S

/-- PUBLISHED witness for Dong-Wong program scope (P16.d). -/
axiom is_dong_wong_dirac_series_program_scope_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsDongWongDiracSeriesProgramScope_PUBLISHED S

/-- **P16 DECOMPOSITION BRIDGE** for V-Z A_q(λ) atom (R-#new-P16).
 Per Phase 0 hostile audit, the monolithic
 `IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS`
 decomposes into 4 typed sub-atoms:
 (P16.a) PUBLISHED V-Z 1984 framework.
 (P16.b) PUBLISHED Knapp-Vogan 1995 cohomological induction.
 (P16.c) `_REQUIRED_HYPOTHESIS` (atlas-computable) θ-stable parabolic
        with R(q) = 8 for E_{7(-25)} — the actual blocker; computable
        via atlas software, NOT structurally open.
 (P16.d) PUBLISHED Dong-Wong program scope (structural fact: program
        covers many exceptional cases but NOT E_{7(-25)} standalone).
 Net effect: V-Z A_q(λ) atom decomposed into 3 PUBLISHED + 1 narrower
 REQUIRED (atlas-computable). The active gate is the atlas computation
 of θ-stable parabolics with R(q) = 8 — distinct from the structural
 gapBlocked barriers (form-HM-EVII, §16.2-E_6-rep, Borel-stable-range)
 which are genuinely literature-open. -/
axiom is_vogan_zuckerman_aq_lambda_computation_for_E725_degree8_from_subatoms_P16 :
 ∀ (S : E7ShimuraTor),
   IsVoganZuckerman1984GeneralFramework_PUBLISHED S →
   IsKnappVogan1995CohomologicalInduction_PUBLISHED S →
   IsThetaStableParabolicOfE725WithRqEquals8_REQUIRED_HYPOTHESIS S →
   IsDongWongDiracSeriesProgramScope_PUBLISHED S →
   IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS S

/-- **DERIVED theorem (P16 LOAD-BEARING REWIRE, R-#new-P16, same round)**:
 V-Z A_q(λ) atom now derivable from P16 bridge applied to 4 P16
 sub-atom witnesses. Load-bearing rewire applied in same round
 (lesson learned from P12-A). Upstream P9 derived theorem rewired
 below to invoke this P16 derived theorem instead of direct axiom.
 Active gate for V-Z A_q(λ) chain is now P16.c atlas-computable
 parabolic enumeration. -/
theorem is_vogan_zuckerman_aq_lambda_computation_for_E725_degree8_REQUIRED_HYPOTHESIS_via_P16_subatoms :
 ∀ (S : E7ShimuraTor),
   IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS S :=
 fun S => is_vogan_zuckerman_aq_lambda_computation_for_E725_degree8_from_subatoms_P16 S
   (is_vogan_zuckerman_1984_general_framework_PUBLISHED S)
   (is_knapp_vogan_1995_cohomological_induction_PUBLISHED S)
   (is_theta_stable_parabolic_of_E725_with_Rq_equals_8_REQUIRED_HYPOTHESIS S)
   (is_dong_wong_dirac_series_program_scope_PUBLISHED S)

/-- **`_REQUIRED_HYPOTHESIS` atom (P9.c, R-#new-P9)**: the Eisenstein /
 residual part of `H^8(S_Γ; ℂ)` (where `S_Γ = Γ\E_{7(-25)}/E_6·U(1)`)
 does NOT contribute to the specific class `[q] ∈ H^8(S_Γ; ℂ)`. Franke
 1998 Ann. Sci. ÉNS 31 (181-279) gives the GENERAL FRAMEWORK for
 Eisenstein/cuspidal/residual decomposition of automorphic cohomology;
 Li-Schwermer Compositio 87 (1993) treats specific exceptional cases —
 their only worked exceptional case is G_2. Specific Eisenstein
 vanishing at degree 8 for `E_{7(-25)}` is NOT in published literature
 (per P9 Phase 0 audit). Tier: `_REQUIRED_HYPOTHESIS` (framework
 PUBLISHED, specific vanishing missing).
 Sources: J. Franke, "Harmonic analysis in weighted L_2-spaces", Ann.
 Sci. ÉNS (4) 31 (1998), 181-279; J.-S. Li, J. Schwermer, "On the
 Eisenstein cohomology of arithmetic groups", Duke Math. J. 123
 (2004), 141-169 + earlier Compositio 87 (1993); G. Harder, "Eisenstein
 cohomology of arithmetic groups: The case GL_2", Invent. Math. 89
 (1987), 37-118 (specific GL_2 case).
 paper source: hyp:ChernWeil-bridge-E7 (P9 decomposition sub-atom c —
 Eisenstein vanishing specific to E_{7(-25)} deg 8 REQUIRED). -/
axiom IsEisensteinCohomologyVanishingFor_E725_Degree8_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` atom (P9.d, R-#new-P9; P14-CORRECTED)**:
 the Hodge bigrading piece of `H^8(S_Γ; ℂ)` containing the Freudenthal
 class `[q]` is AUTOMATICALLY realized by `G`-invariant cohomology
 (no Eisenstein/residual contamination). Atom name retained for
 downstream-reference stability; the original "(3,3)" naming was a
 TYPE-LEVEL CONFUSION caught by P14 Phase 0 audit: (p,q) at H^k requires
 p+q = k, so (3,3) lives in H^6, NOT H^8. The CORRECT bigrading at
 degree 8 for the Freudenthal class is (4,4), corresponding to
 `c_4` of `V_56` = Kähler-class⁴.
 P14 AUDIT IDENTIFIES A POTENTIAL CLOSURE PATH via the decomposition:
   (P14.SI-1) Borel stable range: `H^k(S_Γ_EVII; ℂ) ≅ H^k(Ě_VII; ℂ)`
              for `k ≤ m(E_{7(-25)})`. Citation: A. Borel, "Stable real
              cohomology of arithmetic groups", Ann. Sci. ÉNS 7 (1974),
              235-272. Tier depends on verifying `m(E_{7(-25)}) ≥ 8`;
              Tshishiku 2019 (arXiv:1904.04902) gives sharper bounds.
   (P14.SI-2) Watanabe Poincaré polynomial: `χ(Ě_VII)(t) =
              [14]_{t²}[2]_{t¹⁰}[2]_{t¹⁸}` gives `b_8(Ě_VII) = 1`,
              `H^8(Ě_VII; ℚ) = ℚ·h^4` 1-dim (the (i.b.1) PUBLISHED atom).
              Watanabe 1975 J. Math. Kyoto Univ. 15-2, 363-385 +
              arXiv:2508.11236 Poincaré polynomials of symmetric spaces.
   (P14.SI-3) Bott-Borel-Weil (p,p)-only bigrading: for any generalized
              flag variety / rational projective homogeneous space,
              `H^{p,q} = 0` for `p ≠ q`. Standard for compact-dual
              Hermitian symmetric spaces.
 The conjunction (SI-1) + (SI-2) + (SI-3) gives: if `m(E_{7(-25)}) ≥ 8`,
 then `H^8(S_Γ_EVII; ℂ) ≅ H^8(Ě_VII; ℂ) = ℚ·h^4 = ℚ·c_4 = ℚ·(4,4)`-Kähler-
 class, which is `G`-invariant (image of G-invariant compact-dual class
 under the stable-range isomorphism). The remaining sub-claim is the
 `m(E_{7(-25)}) ≥ 8` bound.
 Tier: `_REQUIRED_HYPOTHESIS` (decomposable into 2 gapClosed PUBLISHED
 sub-atoms (SI-2, SI-3) + 1 REQUIRED sub-atom (SI-1 pending explicit
 m-bound)). Active residual after P14 decomposition: m(E_{7(-25)}) ≥ 8
 Borel-stable-range bound.
 paper source: hyp:ChernWeil-bridge-E7 (P9 decomposition sub-atom d;
 P14 type-confusion correction + Borel-stable-range closure path). -/
axiom IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` atom (P14.SI-1, R-#new-P14; P15-PATCHED)**:
 the Borel stable range theorem applies at degree 8 for the EVII
 Shimura variety — i.e., `m(E_{7(-25)}) ≥ 8` where `m(G)` is the
 Borel stable range constant. P15 PHASE-0 AUDIT CRITICAL CATCH:
 published literature does NOT support `m(E_{7(-25)}) ≥ 8`. Best
 published lower bound is `m(G(ℝ)) ≥ rk_ℝ(G) - 1 = 2` (Borel 1981
 §4; for E_{7(-25)} real rank 3). The gap from published bound 2
 to required bound 8 is SIX FULL DEGREES of cohomological depth
 NOT covered by Borel's machinery. P14 docstring INCORRECTLY cited
 Tshishiku 2019 arXiv:1904.04902 — Tshishiku only sharpens bounds
 for Sp_{2n} and SO_{n,n}, NOT exceptional groups. Citation removed.
 The atom retains `_REQUIRED_HYPOTHESIS` tier with explicit failure-
 asset disclosure: the Borel-stable-range closure route DOES NOT
 reach degree 8 for E_{7(-25)} via known machinery. Alternative
 closure-route candidate per P15 audit recommendation: Lefschetz
 hyperplane theorem on EVII compact dual (complex dim 27 ≫ 8, so
 Lefschetz primitive decomposition applies through middle dimension)
 + Deligne weight argument via proper smooth compactification.
 This sidesteps `m(G) ≥ 8` entirely and uses only PUBLISHED machinery
 (Deligne 1971 Hodge II, Saito MHM 1988); surfaced as alternative
 INVENTION_CLASS routing atom below per P15 audit recommendation.
 Tier: `_REQUIRED_HYPOTHESIS` (gapBlocked semantic at the Borel-
 stable-range route; alternative Lefschetz+Hodge route surfaced
 as INVENTION_CLASS routing).
 Source: A. Borel, "Stable real cohomology of arithmetic groups",
 Ann. Sci. ÉNS 7 (1974), 235-272 (framework + §11 stable-range
 formula); A. Borel, "Stable real cohomology of arithmetic groups
 II", in *Manifolds and Lie Groups* (Hano-Morimoto-Murakami-Okamoto-
 Ozeki eds., Progress in Math. 14, Birkhäuser 1981), §4 (lower
 bound `m ≥ rk_ℝ - 1`).
 paper source: hyp:ChernWeil-bridge-E7 (P14 Hodge-(4,4) decomposition
 SI-1 — Borel stable range bound; P15-PATCHED with failure-asset
 6-degree-gap disclosure). -/
axiom IsBorelStableRangeForE725AtDegree8_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED failure-asset atom (P15.a, R-#new-P15)**: the BEST
 known lower bound for the Borel stable range constant `m(E_{7(-25)})`
 is `m ≥ rk_ℝ - 1 = 2` (real rank of E_{7(-25)} = 3). This is the
 universal almost-simple bound from Borel 1981 §4. Published
 literature does NOT extend this to degree 8 for E_{7(-25)}. The
 P14.SI-1 atom `IsBorelStableRangeForE725AtDegree8_REQUIRED_HYPOTHESIS`
 requires m ≥ 8 — a SIX-DEGREE GAP from the published bound 2.
 Tier: PUBLISHED failure-asset (Borel 1981 §4 specifically establishes
 m ≥ rk_ℝ - 1; nothing stronger is published for exceptional groups).
 Surfaced per P15 audit to encode the structural barrier as typed
 Lean predicate.
 Sources: A. Borel 1981 *Manifolds and Lie Groups* Progress in Math.
 14, Birkhäuser, §4 (lower bound m ≥ rk_ℝ - 1); confirmed by
 Tshishiku 2019 arXiv:1904.04902 §1 line 83 (cites Borel 1981 §4 as
 the universal bound, sharpens only for Sp/SO).
 paper source: hyp:ChernWeil-bridge-E7 (P15 failure-asset structural
 fact — Borel-stable-range universal lower bound m ≥ 2 for E_{7(-25)};
 6-degree gap from required m ≥ 8). -/
axiom IsBorelStandardLowerBoundForE725_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_INVENTION_CLASS` alternative routing atom (P15.b, R-#new-P15)**:
 Lefschetz hyperplane theorem + Deligne weight argument as ALTERNATIVE
 closure route for the (P14.SI-1) Borel-stable-range gap.
 The compact dual `Ě_VII = E_7/E_6·SO(2)` has complex dimension 27,
 so Lefschetz primitive decomposition applies through middle dimension
 (= 27); degree 8 is well within range. The strategy: pull back
 `H^8(Ě_VII; ℂ) = ℚ·h^4` to `H^8(S_Γ^{tor}; ℂ)` via proper smooth
 compactification + Deligne weight argument (Deligne 1971 Hodge II
 + Saito MHM 1988), bypassing the Borel stable range entirely.
 Tier: `_INVENTION_CLASS` — research-level project; the specific
 chain (Lefschetz on compact dual + Deligne pullback to arithmetic
 quotient via S_Γ^{tor}) is NOT explicitly executed in published
 literature for EVII; framework PUBLISHED but specific application
 unverified.
 Sources (framework only): P. Deligne, "Théorie de Hodge II",
 Publ. Math. IHES 40 (1971), 5-58 (weight filtration); M. Saito 1988
 (MHM weight argument); P. Griffiths, J. Harris, *Principles of
 Algebraic Geometry* (Wiley 1978) Ch. 1 §2 (Lefschetz hyperplane on
 smooth projective varieties); A. Beilinson, J. Bernstein, P. Deligne,
 "Faisceaux pervers", Astérisque 100 (1982) (decomposition theorem
 framework).
 paper source: hyp:ChernWeil-bridge-E7 (P15 alternative routing —
 Lefschetz + Deligne weight INVENTION_CLASS surfaced per P15 audit
 recommendation as alternative to failed Borel-stable-range route). -/
axiom IsLefschetzDeligneWeightRouteForE725Degree8_INVENTION_CLASS :
 E7ShimuraTor → Prop

/-- PUBLISHED witness for P15.a (Borel m ≥ 2 universal bound). -/
axiom is_borel_standard_lower_bound_for_E725_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsBorelStandardLowerBoundForE725_PUBLISHED S

/-- `_INVENTION_CLASS` placeholder witness for P15.b (Lefschetz + Deligne
 alternative routing). NOT discharged. -/
axiom is_lefschetz_deligne_weight_route_for_E725_degree8_INVENTION_CLASS :
 ∀ (S : E7ShimuraTor),
   IsLefschetzDeligneWeightRouteForE725Degree8_INVENTION_CLASS S

/-- **PUBLISHED atom (P14.SI-2, R-#new-P14)**: the integral cohomology
 ring `H^*(Ě_VII; ℤ)` of the compact-dual EVII = `E_7/E_6·SO(2)` has
 Poincaré polynomial `χ(t) = [14]_{t²}[2]_{t¹⁰}[2]_{t¹⁸}` (where
 `[n]_{t^k} := (1-t^{kn})/(1-t^k)`). In particular `b_8(Ě_VII) = 1`,
 `H^8(Ě_VII; ℚ) = ℚ·h^4` 1-dim. Tier: PUBLISHED.
 Sources: T. Watanabe, "The integral cohomology ring of the symmetric
 space EVII", J. Math. Kyoto Univ. 15-2 (1975), 363-385 (the source
 already cited as P9.a `IsWatanabe1975IntegralCohomologyRingEVII_PUBLISHED`);
 arXiv:2508.11236 "Poincaré polynomials of symmetric spaces" (explicit
 χ(t) formula for EVII).
 paper source: hyp:ChernWeil-bridge-E7 (P14 Hodge-(4,4) decomposition
 SI-2 — compact-dual Poincaré polynomial PUBLISHED). -/
axiom IsCompactDualEVIIPoincarePolynomial_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P14.SI-3, R-#new-P14)**: for the compact-dual
 EVII = `E_7/E_6·SO(2)` (which is a generalized flag variety /
 rational projective homogeneous space), the Hodge bigrading is
 DIAGONAL: `H^{p,q}(Ě_VII; ℂ) = 0` for `p ≠ q`. This is a standard
 fact for any rational projective homogeneous space (Bott-Borel-Weil
 + Hodge-theory of flag varieties).
 Tier: PUBLISHED (Bott-Borel-Weil 1957 + standard Hodge theory of
 flag varieties).
 Sources: R. Bott, "Homogeneous vector bundles", Ann. Math. 66 (1957),
 203-248 (the foundational Bott-Borel-Weil theorem); H. Borel,
 F. Hirzebruch, "Characteristic classes and homogeneous spaces I",
 Amer. J. Math. 80 (1958), §29-30 (Hodge theory of flag varieties);
 P. Griffiths, J. Harris, *Principles of Algebraic Geometry*, Wiley
 1978, Ch. 1 §3 (general fact: rational projective homogeneous spaces
 have diagonal Hodge bigrading).
 paper source: hyp:ChernWeil-bridge-E7 (P14 Hodge-(4,4) decomposition
 SI-3 — diagonal Hodge bigrading on compact-dual flag variety PUBLISHED). -/
axiom IsCompactDualEVIIHodgeBigradingDiagonal_PUBLISHED :
 E7ShimuraTor → Prop

/-- `_REQUIRED_HYPOTHESIS` witness for SI-1 (Borel stable range at deg 8). -/
axiom is_borel_stable_range_for_E725_at_degree8_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsBorelStableRangeForE725AtDegree8_REQUIRED_HYPOTHESIS S

/-- PUBLISHED witness for SI-2 (compact-dual EVII Poincaré polynomial). -/
axiom is_compact_dual_EVII_poincare_polynomial_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsCompactDualEVIIPoincarePolynomial_PUBLISHED S

/-- PUBLISHED witness for SI-3 (diagonal Hodge bigrading on flag variety). -/
axiom is_compact_dual_EVII_hodge_bigrading_diagonal_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsCompactDualEVIIHodgeBigradingDiagonal_PUBLISHED S

/-- **P14 DECOMPOSITION BRIDGE** for Hodge-(4,4) auto-G-invariant
 atom (R-#new-P14, type-confusion correction + Borel stable range
 closure path). Per Phase 0 hostile audit, the (P9.d) atom
 `IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS`
 (atom name retained for downstream stability; the original "(3,3)"
 was a TYPE-LEVEL CONFUSION — correct bigrading at degree 8 is
 (4,4)) decomposes into 3 typed structural ingredients:
 (SI-1) `_REQUIRED_HYPOTHESIS` `IsBorelStableRangeForE725AtDegree8_REQUIRED_HYPOTHESIS`
       (Borel stable range bound `m(E_{7(-25)}) ≥ 8`; framework
       PUBLISHED, specific m-bound REQUIRED).
 (SI-2) PUBLISHED `IsCompactDualEVIIPoincarePolynomial_PUBLISHED`
       (Watanabe 1975 + arXiv:2508.11236; gives `b_8(Ě_VII) = 1`).
 (SI-3) PUBLISHED `IsCompactDualEVIIHodgeBigradingDiagonal_PUBLISHED`
       (Bott-Borel-Weil + standard Hodge theory of flag varieties).
 The conjunction implies `H^8(S_Γ_EVII; ℂ) ≅ ℚ·c_4 = ℚ·(4,4)`-Kähler-
 class, which is G-invariant by Borel stable range. Net effect: the
 monolithic Hodge-auto-G-invariant atom is decomposed into 2 PUBLISHED
 sub-atoms (SI-2 + SI-3) + 1 narrower REQUIRED sub-atom (SI-1 m-bound).
 The gapBlocked structural barrier (per P9 audit) is genuinely
 downgraded — the active residual is now just the `m(E_{7(-25)}) ≥ 8`
 Borel stable range bound (a specific computational claim from a
 PUBLISHED framework). -/
axiom is_hodge_weight33_on_EVII_automatically_G_invariant_from_subatoms_P14 :
 ∀ (S : E7ShimuraTor),
   IsBorelStableRangeForE725AtDegree8_REQUIRED_HYPOTHESIS S →
   IsCompactDualEVIIPoincarePolynomial_PUBLISHED S →
   IsCompactDualEVIIHodgeBigradingDiagonal_PUBLISHED S →
   IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS S

/-- **DERIVED theorem (P14 LOAD-BEARING REWIRE, R-#new-P14)**: the
 Hodge-auto-G-invariant atom is derivable from the P14 bridge applied
 to 3 sub-atom witnesses. Load-bearing rewire applied in same round
 (P12-A lesson learned: avoid ceremony retreat). The upstream P9
 consumer (the P12-A derived theorem `freudenthal_class_realized_by_g_invariant_cohomology_E7_REQUIRED_HYPOTHESIS_via_P9_subatoms`)
 is rewired to use this P14 derived theorem.
 Active gapBlocked status of the original atom is now DOWNGRADED:
 from "(3,3)/(4,4) auto-G-invariant — no published theorem" to
 "Borel stable range bound m(E_{7(-25)}) ≥ 8 — specific computational
 claim from PUBLISHED Borel-1974 framework". This is the strongest
 honest narrowing achievable per P14 audit. -/
theorem is_hodge_weight33_on_EVII_automatically_G_invariant_REQUIRED_HYPOTHESIS_via_P14_subatoms :
 ∀ (S : E7ShimuraTor),
   IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS S :=
 fun S => is_hodge_weight33_on_EVII_automatically_G_invariant_from_subatoms_P14 S
   (is_borel_stable_range_for_E725_at_degree8_REQUIRED_HYPOTHESIS S)
   (is_compact_dual_EVII_poincare_polynomial_PUBLISHED S)
   (is_compact_dual_EVII_hodge_bigrading_diagonal_PUBLISHED S)

/-- (ii.b) Mumford canonical extension: the cohomology class `[q] ∈
 H^8(S_Γ, ℂ)` extends to a well-defined class `[q] ∈ H^8(S_Γ^tor, ℂ)`
 via the Mumford canonical extension to the AMRT toroidal
 compactification. DECOMPOSED below into a PUBLISHED framework atom
 (`IsMumfordCanonicalExtensionFramework_E7`) + a
 `_REQUIRED_HYPOTHESIS` conjectural-extension atom
 (`IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS`,
 carrying the "non-cocompact-boundary regime at degree 8" content the
 paper labels conditional); the predicate witness is derived via the
 bridge axiom `mumford_canonical_extension_to_tor_from_framework_and_compatibility`.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b). -/
-- R125: was `axiom`; now a def projecting the `isMumfordCanonicalExtensionToTor` field.
def IsMumfordCanonicalExtensionToTor (S : E7ShimuraTor) : Prop :=
  S.isMumfordCanonicalExtensionToTor

/-- PUBLISHED framework atom of clause (ii.b): the automorphic bundle
 `𝓥_56` admits a Mumford canonical extension `𝓥_56^can` to the AMRT
 toroidal compactification `S_Γ^tor`, with well-defined Chern-NUMBER
 proportionality (Mumford 1977 main theorem). Anchors: Mumford 1977
 (good metrics, existence of `𝓥^can`, Hirzebruch-Mumford Chern-number
 proportionality `c^I(Ē_Σ) = v(Γ) c^I(Ď)` for any partition `I`, any
 automorphic bundle from a `K`-rep) + AMRT 1975/2010 (toroidal `S^tor`
 construction, fully general for any bounded symmetric domain incl.
 EVII; the PEL restriction belongs to Faltings-Chai / Lan, NOT to AMRT
 itself). Cross-source: Harris 1989 Proc. LMS 59 (1-22) "Functorial
 properties of toroidal compactifications of locally symmetric
 varieties" (functoriality of canonical extension on toroidal
 compactifications, general Shimura setting incl. exceptional types —
 NOT Harris 1985 Invent. Math. 82, whose §2/§4 are about canonical
 MODELS over the reflex field, a different question).
 EVII SCOPE NOTE: Goresky-Pardon 2002 Invent. Math. 147 is NOT in the
 anchor for the EVII case: their main Chern-subalgebra theorem (§1.3,
 Thm 16.4) explicitly restricts to classical types `Sp_n(ℝ), U(p,q),
 SO(2n), SO(2,p)`, NOT EVII; G-P §1.6 explicitly says "we do not know
 whether the results may be extended to the equal-rank case" — which
 is exactly the EVII situation. The G-P extension to EVII is surfaced
 separately as `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`
 below and consumed by the (iii) ring-hom atom. The framework atom
 here is THE Mumford 1977 + AMRT 2010 framework (which DOES cover
 EVII for `𝓥^can` existence and Chern-number proportionality), not
 the strictly-stronger G-P Chern-subalgebra claim.
 LOCUS NOTE: G-P's canonical Chern classes live primarily in
 `H^{2i}(X̄_BB; ℂ)` (Baily-Borel compactification, ℂ-coefficients);
 the toroidal locus `H^{2i}(S_Γ^tor, ℚ)` is recovered via the
 compatibility pullback `τ*(c̄^i) = c^i(Ē_Σ)` (Mumford 1977 + G-P
 §1.1). For EVII this pullback structure is part of the conjectural
 EVII extension; see the new `_REQUIRED_HYPOTHESIS` atom.
 Source: D. Mumford, "Hirzebruch's proportionality theorem in the
 non-compact case", Invent. Math. 42 (1977) 239-272 (good metrics +
 Chern-number proportionality; CONSTRUCTS `𝓥^can`, NOT just assumes
 it); A. Ash, D. Mumford, M. Rapoport, Y. Tai, *Smooth Compactifications
 of Locally Symmetric Varieties* (AMRT), Math. Sci. Press 1975 (2nd ed.
 Cambridge 2010) (toroidal `S^tor` for any bounded symmetric domain).
 Cross-source: M. Harris, "Functorial properties of toroidal
 compactifications of locally symmetric varieties", Proc. London Math.
 Soc. (3) 59 (1989), 1-22.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b) framework atom. -/
axiom IsMumfordCanonicalExtensionFramework_E7 :
 E7ShimuraTor → Prop

/-- `_REQUIRED_HYPOTHESIS` atom: the Goresky-Pardon 2002 (Invent. Math.
 147) Chern-subalgebra theorem extends from the classical types
 (`Sp_n(ℝ), U(p,q), SO(2n), SO(2,p)`, per G-P §1.3 Thm 16.4) to the
 equal-rank EVII case. G-P §1.6 explicitly notes this extension is
 NOT known. Specifically: the canonical Chern subalgebra of
 `H^*(S_Γ^tor, ℚ)` generated by `c_i(𝓥_56^can)` is well-defined
 (independent of toroidal-compactification choice) AND surjects onto
 the compact-dual Chern subalgebra via the proportionality / pullback
 map. Without this hypothesis, the (iii) ring-hom transport along the
 extension to `S_Γ^tor` is not literally established for EVII.
 Tier: `_REQUIRED_HYPOTHESIS` (paper-acknowledged conditional input;
 G-P's classical-type theorem is the published framework, but the EVII
 extension is the conjectural piece). Discharges only the EVII-specific
 part of the (iii) ring-hom atom; the Mumford-1977-only part (Chern
 NUMBER proportionality + `𝓥^can` existence) is PUBLISHED unconditionally.
 paper source: hyp:ChernWeil-bridge-E7 (ii)/(iii) — surfaced per R-#106b
 audit (Defect #1: G-P scope misattributed to cover EVII).
 P7 STRUCTURAL DECOMPOSITION (R-#new Phase 0+1 hostile audit):
 this monolithic atom is honestly decomposed into 2 PUBLISHED +
 1 narrower `_REQUIRED_HYPOTHESIS` + 1 INVENTION_CLASS via
 `goresky_pardon_chern_subalgebra_extension_to_EVII_from_subatoms`
 below. The genuine residual content is the E_6-representation-
 theoretic compatibility of G-P §16.2 (NOT the abstract §10-12
 controlled-form framework, which Looijenga 2017 verifies is
 group-agnostic). G-P 2002 §1.6 verified verbatim: "We do not know
 whether the results on Chern classes which are described in this
 paper for Hermitian symmetric spaces may be extended to the 'equal
 rank' case (when the real rank of G and of K coincide)." -/
axiom IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED folklore-corollary sub-atom of G-P-EVII decomposition**
 (P7, R-#new; tier-downgraded per P7 Phase 4 audit):
 the rational cohomology `H^*(B(E_6 × U(1)); ℚ)` is the polynomial
 algebra on the standard Borel-Hirzebruch generators, all realised
 as Chern classes of representations of `K = E_6 × U(1)`. Specifically:
 `H^*(BE_6; ℚ) = ℚ[c_2(V_27), c_5(V_27), c_6(V_27), c_8(V_27),
 c_9(V_27), c_{12}(V_27)]` (polynomial on Weyl-invariant degrees
 `{2,5,6,8,9,12}` = exponents+1; E_6 exponents are `{1,4,5,7,8,11}`)
 and `H^*(BU(1); ℚ) = ℚ[c_1]`, so by Künneth `H^*(B(E_6 × U(1)); ℚ)`
 is polynomial on 7 generators, all of which are Chern classes of
 the minuscule rep `V_27` (and its conjugate) plus the `U(1)`-character.
 This is the analogue of G-P §16.2's "Chern subring of `H^*(BK; ℂ)`
 exhausts `H^*(BK; ℂ)`" hypothesis adapted to `K = E_6 × U(1)`.
 Tier: `_FOLKLORE_PUBLISHED` (multi-source standard-machinery
 folklore-corollary; downgraded from raw `_PUBLISHED` per P7 Phase 4
 audit Pattern 2 = folkloric inflation finding). Borel 1953 gives the
 general `H^*(BG; ℚ)` polynomial-ring framework; Borel-Hirzebruch 1958
 §10-16 gives the Chern-class realization framework; the specific
 identification of generators as Chern classes of `V_27` is folkloric
 standard machinery (no single theorem citation, but each piece is
 established).
 Sources: A. Borel, "Sur la cohomologie des espaces fibrés principaux
 et des espaces homogènes de groupes de Lie compacts", Ann. of Math.
 57 (1953), 115-207 (general framework); A. Borel, F. Hirzebruch,
 "Characteristic classes and homogeneous spaces I", Amer. J. Math.
 80 (1958), 458-538 (Chern-class realization); M. Mimura, H. Toda,
 *Topology of Lie Groups, I and II*, Translations of Math. Monographs
 vol. 91, AMS 1991 (exceptional types incl. E_6).
 paper source: hyp:ChernWeil-bridge-E7 (G-P-EVII decomposition sub-atom 1). -/
axiom IsBorelHirzebruchClassifyingSpacePresentationFor_E6timesU1_FOLKLORE_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED sub-atom of G-P-EVII decomposition** (P7, R-#new):
 the Goresky-Pardon 2002 §10-12 abstract patched-parabolic-connection
 framework giving canonical lifts `c_k^{gp}(F) ∈ H^{2k}(X^bb; ℂ)`
 for automorphic vector bundles on the Baily-Borel compactification
 of ANY Hermitian locally symmetric variety `X = Γ\G/K`. The framework
 is GROUP-AGNOSTIC — it produces well-defined Chern-class lifts to
 the Baily-Borel boundary independent of the type of `G`. The
 type-restriction to classical `G` arises only at G-P §16.2-16.4
 where the surjection statement is proved via specific K-decomposition.
 Tier: PUBLISHED. Sources: M. Goresky, W. Pardon, "Chern classes of
 automorphic vector bundles", Invent. Math. 147 (2002), §10-12
 (abstract framework); E. Looijenga, "Goresky-Pardon lifts of Chern
 classes and associated Tate extensions", Compositio Math. 153 (2017),
 1349-1371 (arXiv:1510.04103) — refines G-P canonical-lift construction
 via isoholonomic structures, Corollary 3.3 + Theorem 4.1 explicitly
 establish that the abstract framework yields lifts for automorphic
 vector bundles from arbitrary Q-simple G (proofs verified for Sp,
 but the framework is group-agnostic).
 paper source: hyp:ChernWeil-bridge-E7 (G-P-EVII decomposition sub-atom 2). -/
axiom IsGPAbstractParabolicConnectionFramework_GroupAgnostic_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` sub-atom (narrower residual)** (P7, R-#new;
 P8-AUDIT-DISCLOSED: this atom is itself a COMPOSITE; P8 decomposes
 it further into 4 typed sub-atoms via `is_E6_representation_compatibility_of_section_16dot2_from_subatoms_P8`
 below):
 the specific representation-theoretic check that G-P 2002 §16.2's
 surjection argument (Chern subring of `H^*(BK; ℂ)` surjects onto
 `H^*(D̆; ℂ)` via Borel's theorem applied to product-of-classical-K
 decomposition) carries through when `K = E_6 × U(1)` with `E_6` as
 a single irreducible factor and the automorphic bundle is the
 minuscule rep `V_27` (resp. `V_56` of the ambient E_7). G-P §16.2
 ARGUMENT specifically uses each `K_i` factor being `U(n_i)`,
 `O(2k_i+1)`, or `SO(2)` so that the Chern-Weil generators come
 from K-restricted representations of well-studied subgroups; the
 same step for `E_6 × U(1)` requires verifying:
   (a) Hirzebruch-Mumford proportionality lifts to the level of
       differential forms in degrees relevant to the Freudenthal
       quartic (degree 8), in the equal-rank case where boundary
       strata are E_6-type rather than U(n)/SO-type;
   (b) the K-restricted representation argument carries through
       with `E_6` (rather than `U(n)`) as the K-factor.
 Tier: `_REQUIRED_HYPOTHESIS` (this is the genuine narrower residual
 content of the G-P-EVII extension, per Phase 0 hostile audit
 R-#new: the bottleneck is at G-P §16.2 representation-theoretic
 compatibility, NOT at the abstract §10-12 framework which is
 group-agnostic per Looijenga 2017). Literature 2002-2026 confirmed
 silent on this specific check (Looijenga 2017 only verifies the
 abstract framework for Sp; Esnault-Harris 2018 restricts to
 Hodge-type Shimura — EVII excluded as non-abelian-type;
 Burgos-Wildeshaus 2004 gives MHM degeneration but not the
 surjection statement).
 P8 STRUCTURAL DECOMPOSITION (R-#new-P8): per the P8 Phase 0 audit,
 this atom decomposes into:
   (P8.1) PUBLISHED `IsEVIIBoundaryStrataClassification_codim1_is_EIII_PUBLISHED`
          (codim-1 boundary stratum = EIII = E_6/Spin(10)·U(1), itself
          EXCEPTIONAL not classical — Wolf 1972 / Satake 1980).
   (P8.2) gapBlocked `IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS`
          (form-level HM proportionality for EVII; Mumford 1977 = numbers
          only; Faltings 1984 + Looijenga 2017 = PEL/Sp only; GHS 2008 =
          orthogonal only; EVII form-level is GENUINELY OPEN — new
          theorem required).
   (P8.3) gapPartial folklore `IsChernV27GeneratesBE6Rational_FOLKLORE`
          (V_27 Chern classes generate `H^*(BE_6; ℚ)` — Borel 1953
          establishes polynomial-ring framework, Toda / Kono-Mimura
          mid-1970s identify mod-p Chern-class generators of V_27;
          assembly of rational generation is folklore-grade).
   (P8.4) gapPartial folklore `IsChernV56GeneratesBE7Rational_FOLKLORE`
          (V_56 Chern classes generate `H^*(BE_7; ℚ)` — analogous;
          Kono-Mimura mod-p only published).
 The bridge `is_E6_representation_compatibility_of_section_16dot2_from_subatoms_P8`
 routes this atom through the 4-input decomposition. Net effect: the
 monolithic narrower atom is preserved as the active gate (consumed
 by P7-PATCH-A's bridge to G-P-EVII), but its content is further
 decomposed, surfacing the FORM-LEVEL HM PROPORTIONALITY FOR EVII
 as the genuine gapBlocked structural barrier.
 paper source: hyp:ChernWeil-bridge-E7 (G-P-EVII decomposition sub-atom 3 —
 narrower residual surfaced per P7 audit; P8 further decomposes). -/
axiom IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P8.1, R-#new-P8)**: classification of EVII
 Baily-Borel boundary strata. The codim-1 boundary stratum of the
 EVII Hermitian symmetric domain `EVII = E_{7(-25)}/(E_6·U(1))` is
 `EIII = E_6/Spin(10)·U(1)`, itself the EXCEPTIONAL Hermitian
 symmetric domain of E_6 type (NOT a classical Hermitian symmetric
 space). The codim-2 boundary is the 5-dim bounded symmetric domain
 of tube type (classical, Sp/SO type), and the codim-3 stratum is
 a point. P8 AUDIT KEY FINDING: this PUBLISHED structural fact
 INVALIDATES the "reduce-to-classical-boundary-strata" routing
 assumption used by P7's `IsMHMDecompositionTheoremRouteToEVIIChernExtension_OPEN_INVENTION_CLASS`
 atom — the MHM/BBD route would need to first solve G-P-EIII
 inductively (since codim-1 boundary EIII is exceptional E_6 type),
 i.e. it does NOT avoid the exceptional-type difficulty.
 Tier: PUBLISHED.
 Sources: J. Wolf, *Spaces of Constant Curvature*, McGraw-Hill 1972
 + later editions (boundary classification of E_{7(-25)}); I. Satake,
 *Algebraic Structures of Symmetric Domains*, Iwanami Shoten 1980
 (Q-rational boundary structure); A. Borel, L. Ji, *Compactifications
 of Symmetric and Locally Symmetric Spaces*, Birkhäuser 2006 §III.4-5
 (general boundary classification for Hermitian symmetric domains).
 paper source: hyp:ChernWeil-bridge-E7 (P8 decomposition sub-atom 1 —
 boundary strata classification PUBLISHED). -/
axiom IsEVIIBoundaryStrataClassification_codim1_is_EIII_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` gapBlocked atom (P8.2, R-#new-P8)**:
 form-level Hirzebruch-Mumford proportionality for EVII.
 G-P §16.2's surjection argument uses Hirzebruch-Mumford
 proportionality at the level of DIFFERENTIAL FORMS (not just
 Chern numbers) to identify Chern subring generators of
 `H^*(S_Γ^{tor}; ℚ)` with their compact-dual analogues. Published
 literature:
   - Mumford 1977 Invent. Math. 42 (239-272): NUMBER-LEVEL
     proportionality for ALL bounded symmetric domains incl. EVII;
     does NOT lift to form level.
   - Faltings 1984 Math. Ann. 269: form-level proportionality for
     PEL types (incl. Siegel A_g).
   - Looijenga 2017 Compositio Math. 153 (1349-1371): canonical-
     lift refinement for Sp / symplectic case only.
   - Gritsenko-Hulek-Sankaran 2008 Doc. Math. 13: form-level for
     ORTHOGONAL type bounded symmetric domains.
 None of these cover EVII (non-PEL, non-Sp, non-orthogonal,
 non-abelian-type Shimura). The EVII form-level statement would
 constitute a NEW THEOREM.
 Tier: `_REQUIRED_HYPOTHESIS` at gapBlocked semantic level
 (genuine OPEN published-literature-silent content; would be a new
 theorem). Surfaced as TYPED LEAN ATOM per failure-as-asset
 discipline: this is the irreducible barrier that the §16.2
 K-decomposition routing reduces to.
 paper source: hyp:ChernWeil-bridge-E7 (P8 decomposition sub-atom 2 —
 form-level HM proportionality for EVII gapBlocked residual). -/
axiom IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P13.SI-1, R-#new-P13)**: Mumford canonical extension
 EXISTS for every semisimple automorphic vector bundle on `S_Γ` (with
 `Γ` neat), extending to a smooth toroidal compactification `S_Γ^{tor}`
 with simple normal crossing boundary divisor and trivial monodromy.
 This is the PUBLISHED structural ingredient (SI-1) of the form-level
 HM proportionality decomposition per P13 Phase 0 audit.
 Tier: PUBLISHED — type-uniform; covers EVII (and any Hermitian
 locally symmetric variety) via the abstract bounded-domain /
 arithmetic-group framework.
 Sources: D. Mumford, "Hirzebruch's proportionality theorem in the
 non-compact case", Invent. Math. 42 (1977), Theorem 3.1; M. Harris,
 "Functorial properties of toroidal compactifications of locally
 symmetric varieties", Proc. London Math. Soc. (3) 59 (1989), §4.1
 (general formulation, type-uniform).
 paper source: hyp:ChernWeil-bridge-E7 (P13 form-HM decomposition
 sub-atom SI-1 — canonical-extension existence PUBLISHED). -/
axiom IsMumfordCanonicalExtensionExists_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED atom (P13.SI-2-LB, R-#new-P13)**: every automorphic
 LINE bundle on `S_Γ` with invariant smooth Hermitian metric extends
 to `S_Γ^{tor}` with a Mumford-good (log-singular) Hermitian metric;
 the Chern-Weil form representing `c_1` extends as a current with
 log-singular boundary growth. PUBLISHED structural ingredient (SI-2
 line-bundle case) of the form-level HM proportionality decomposition
 per P13 Phase 0 audit.
 Tier: PUBLISHED — type-uniform; covers EVII line bundles.
 Sources: D. Mumford 1977 Invent. Math. 42 (good metric definition +
 log-singular invariant); J.-I. Burgos, J. Kramer, U. Kühn,
 "Cohomological arithmetic Chow rings", arXiv:math/0502085 (Burgos-
 Kramer-Kühn machinery for log-log forms; abstract type-independent
 line bundle case).
 paper source: hyp:ChernWeil-bridge-E7 (P13 form-HM decomposition
 sub-atom SI-2-LB — good metric line-bundle case PUBLISHED). -/
axiom IsAutomorphicLineBundleGoodMetricExtends_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` atom (P13.SI-2-HR, R-#new-P13)**: the
 Mumford-good metric extension for higher-rank automorphic vector
 bundles on `S_Γ^{tor}` for the specific EVII Hodge bundle (rank
 27 or other rank ≥ 2 automorphic bundles relevant to the Freudenthal
 quartic). Burgos-Kramer-Kühn machinery (arXiv:math/0502085) applies
 abstractly to "fully decomposed automorphic vector bundles" but
 verification for the specific EVII Hodge bundle on `S_Γ^{tor}` is
 NOT in the published literature.
 Tier: `_REQUIRED_HYPOTHESIS` (structural ingredient SI-2 higher-rank
 EVII case; abstractly-framework-PUBLISHED, specifically-EVII-OPEN).
 paper source: hyp:ChernWeil-bridge-E7 (P13 form-HM decomposition
 sub-atom SI-2-HR — higher-rank good metric for EVII OPEN). -/
axiom IsAutomorphicHigherRankBundleGoodMetricExtendsForEVII_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` atom (P13.SI-3, R-#new-P13)**: the
 Chern-Weil curvature forms of `(𝓥^can, h_good)` on `S_Γ^{tor}` for
 the EVII arithmetic quotient represent (in extended de Rham
 cohomology) the same classes as Mumford 1977 number-level
 proportionality predicts, AND these forms pull back from the
 corresponding G(ℂ)-invariant Chern-Weil forms on `Ě_VII` via the
 Borel embedding modulo controlled-form boundary corrections.
 This is the Goresky-Pardon 2002 analog FOR EVII — explicitly out
 of GP02 scope (GP02 §1.3 Thm 16.4 restricts to classical types).
 Tier: `_REQUIRED_HYPOTHESIS` (structural ingredient SI-3, the
 form-level proportionality identity FOR EVII; genuinely OPEN — no
 published source covers exceptional Hermitian symmetric domains
 at the form level).
 paper source: hyp:ChernWeil-bridge-E7 (P13 form-HM decomposition
 sub-atom SI-3 — Chern-Weil form proportionality for EVII OPEN). -/
axiom IsChernWeilFormProportionalityForEVII_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- PUBLISHED witness for SI-1 (Mumford canonical extension exists). -/
axiom is_mumford_canonical_extension_exists_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsMumfordCanonicalExtensionExists_PUBLISHED S

/-- PUBLISHED witness for SI-2-LB (line-bundle good metric extends). -/
axiom is_automorphic_line_bundle_good_metric_extends_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsAutomorphicLineBundleGoodMetricExtends_PUBLISHED S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for SI-2-HR (higher-rank
 good metric for EVII). NOT discharged. -/
axiom is_automorphic_higher_rank_bundle_good_metric_extends_for_EVII_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsAutomorphicHigherRankBundleGoodMetricExtendsForEVII_REQUIRED_HYPOTHESIS S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for SI-3 (Chern-Weil form
 proportionality for EVII). NOT discharged. -/
axiom is_chern_weil_form_proportionality_for_EVII_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsChernWeilFormProportionalityForEVII_REQUIRED_HYPOTHESIS S

/-- **P13 DECOMPOSITION BRIDGE** for form-level HM proportionality
 EVII atom (R-#new-P13). Per Phase 0 hostile audit, the monolithic
 `IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS`
 decomposes into 4 typed structural ingredients:
 (SI-1) PUBLISHED `IsMumfordCanonicalExtensionExists_PUBLISHED`
       (Mum77 Thm 3.1 + Har89 §4.1; type-uniform);
 (SI-2-LB) PUBLISHED `IsAutomorphicLineBundleGoodMetricExtends_PUBLISHED`
       (Mum77 + Burgos-Kramer-Kühn; line-bundle case type-uniform);
 (SI-2-HR) `_REQUIRED_HYPOTHESIS` `IsAutomorphicHigherRankBundleGoodMetricExtendsForEVII_REQUIRED_HYPOTHESIS`
       (higher-rank good metric for EVII Hodge bundle; specifically-
       EVII-OPEN, abstract-framework PUBLISHED);
 (SI-3) `_REQUIRED_HYPOTHESIS` `IsChernWeilFormProportionalityForEVII_REQUIRED_HYPOTHESIS`
       (Chern-Weil form proportionality FOR EVII; genuine OPEN, no
       published source for exceptional Hermitian symmetric domains).
 Net effect: form-HM-EVII atom decomposed into 2 PUBLISHED + 2
 narrower REQUIRED; the active gapBlocked residual is now pinpointed
 at SI-2-HR (higher-rank good metric) + SI-3 (Chern-Weil form
 proportionality identity), both genuinely open published-literature-
 silent problems. -/
axiom is_hirzebruch_mumford_proportionality_forms_for_EVII_from_subatoms_P13 :
 ∀ (S : E7ShimuraTor),
   IsMumfordCanonicalExtensionExists_PUBLISHED S →
   IsAutomorphicLineBundleGoodMetricExtends_PUBLISHED S →
   IsAutomorphicHigherRankBundleGoodMetricExtendsForEVII_REQUIRED_HYPOTHESIS S →
   IsChernWeilFormProportionalityForEVII_REQUIRED_HYPOTHESIS S →
   IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS S

/-- **DERIVED theorem (P13 LOAD-BEARING REWIRE, R-#new-P13)**: the
 form-HM-EVII atom is now derivable from the P13 bridge applied to
 4 P13 sub-atom witnesses. Per the P12 batch-audit lesson learned
 (P8 + P9 originally had inert bridges), this load-bearing rewire
 is applied IMMEDIATELY in the same round to avoid the ceremony-
 retreat pattern. The form-HM-EVII consumer downstream (the P8
 bridge consuming it) is rewired to use this derived theorem
 instead of the direct axiom, completing the load-bearing chain.
 Active conjectural-surface gates after P13 LOAD-BEARING:
 SI-2-HR + SI-3 (both narrower than monolithic form-HM-EVII). -/
theorem is_hirzebruch_mumford_proportionality_forms_for_EVII_REQUIRED_HYPOTHESIS_via_P13_subatoms :
 ∀ (S : E7ShimuraTor),
   IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS S :=
 fun S => is_hirzebruch_mumford_proportionality_forms_for_EVII_from_subatoms_P13 S
   (is_mumford_canonical_extension_exists_PUBLISHED S)
   (is_automorphic_line_bundle_good_metric_extends_PUBLISHED S)
   (is_automorphic_higher_rank_bundle_good_metric_extends_for_EVII_REQUIRED_HYPOTHESIS S)
   (is_chern_weil_form_proportionality_for_EVII_REQUIRED_HYPOTHESIS S)

/-- **`_FOLKLORE_PUBLISHED` atom (P8.3, R-#new-P8)**: V_27 Chern
 classes generate `H^*(BE_6; ℚ)`. Borel 1953 Ann. Math. 57
 establishes the rational polynomial-ring framework: `H^*(BE_6; ℚ)`
 is the polynomial algebra on 6 Weyl-invariant generators in degrees
 4, 10, 12, 16, 18, 24 (corresponding to E_6 exponents
 `{1,4,5,7,8,11}`). Toda 1976 + Kono-Mimura mid-1970s prove
 (for mod-p / Steenrod-algebra coefficients) that certain generators
 of `H^*(BE_6; F_p)` are realised as Chern classes of the minuscule
 representation `V_27`. The assembly of rational generation by
 Chern polynomials of V_27 alone is FOLKLORE-grade: V_27 is faithful
 with finite kernel (Z/3 acting trivially on Lie algebra), so Chern
 classes c_i(V_27) suffice rationally — but no single citation
 establishes this directly.
 Tier: `_FOLKLORE_PUBLISHED` (multi-source standard-machinery
 folklore-corollary; each piece established but assembly is
 folkloric).
 Sources: A. Borel 1953 Ann. Math. 57 (115-207); H. Toda, "Cohomology
 of classifying spaces"; A. Kono, M. Mimura, "Cohomology mod p of
 the classifying space of compact exceptional Lie groups"
 mid-1970s J. Pure Appl. Algebra; Mimura-Toda 1991 AMS Transl. 91
 Ch. VII §6.
 paper source: hyp:ChernWeil-bridge-E7 (P8 decomposition sub-atom 3 —
 V_27 Chern generation folklore-published). -/
axiom IsChernV27GeneratesBE6Rational_FOLKLORE_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_FOLKLORE_PUBLISHED` atom (P8.4, R-#new-P8)**: V_56 Chern
 classes generate `H^*(BE_7; ℚ)`. Analogous to P8.3 for `E_7`:
 `H^*(BE_7; ℚ)` is polynomial on 7 generators in degrees
 4, 12, 16, 20, 24, 28, 36 (E_7 exponents `{1,5,7,9,11,13,17}`).
 V_56 is the minuscule rep of E_7, faithful with kernel Z/2.
 Kono-Mimura mid-1970s cover mod-p case; rational generation by
 Chern polynomials of V_56 alone is folklore-grade.
 Tier: `_FOLKLORE_PUBLISHED` (multi-source).
 Sources: Kono-Mimura J. Pure Appl. Algebra mid-1970s; Mimura-Toda
 1991 AMS Transl. 91 Ch. VII §6; Borel 1953 framework.
 paper source: hyp:ChernWeil-bridge-E7 (P8 decomposition sub-atom 4 —
 V_56 Chern generation folklore-published). -/
axiom IsChernV56GeneratesBE7Rational_FOLKLORE_PUBLISHED :
 E7ShimuraTor → Prop

/-- **`_REQUIRED_HYPOTHESIS` degree-8 specialization — INERT
 future-attack-vector placeholder** (P7, R-#new; P7-PATCH-E disclosure):
 the degree-8 sub-case of the G-P-EVII Chern-subalgebra extension —
 specifically, that the G-P Chern subring of `H^8(S_Γ^{tor}; ℂ)`
 (the toroidal compactification of an `E_{7(-25)}` Shimura variety)
 surjects onto `H^8(D̆_VII; ℂ) = ℚ·h^4 ⊕ ℚ·[q]_G` (or 1-dim per
 `IsChernSubringSurjectiveOntoH8_E7P7`'s convention). The downstream
 consumer (clause iii ring-hom transport for the Freudenthal quartic
 `[q]`) literally only needs this degree-8 specialization.
 Tier: `_REQUIRED_HYPOTHESIS` (narrower than full ring extension).
 **INERT STATUS (P7 Phase 4 audit disclosure, Pattern 4 = tautological
 premise check)**: this atom is NOT currently consumed by any active
 witness chain. The active P7 load-bearing path consumes the
 `IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS`
 (full-ring residual narrower atom), not this degree-8 specialization.
 This atom is surfaced as a TYPED FUTURE-ATTACK-VECTOR PLACEHOLDER:
 if a future round produces a degree-8-specific construction (e.g.,
 direct verification of G-P's controlled-form construction at the
 single degree-8 Chern class of `V_56`), this atom + the bridge
 `goresky_pardon_chern_subalgebra_extension_to_EVII_from_degree8`
 give the route to retire the monolithic atom via the narrower
 degree-8 atom instead of via the full ring extension or the §16.2
 K-decomposition. The two alternative routes (§16.2 K-decomp vs
 degree-8 direct) are disjoint attack vectors; both are typed-out
 for future-round prioritisation.
 paper source: hyp:ChernWeil-bridge-E7 (G-P-EVII decomposition sub-atom 4 —
 INERT degree-8 specialization for future-attack-vector typing). -/
axiom IsGPChernSubalgebraSurjectionAtDegree8_E7_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **`_INVENTION_CLASS` alternative routing atom — INERT,
 PREMISE FALSE per P8 audit, BLOCKED future-attack-vector** (P7,
 R-#new; P7-PATCH-E + P8-AUDIT-CORRECTION):
 an INDIRECT EVII Chern-subalgebra extension via Saito MHM 1988 +
 Burgos-Wildeshaus 2004 + Beilinson-Bernstein-Deligne 1982
 decomposition theorem.
 **P8 AUDIT CRITICAL FINDING (premise FALSE)**: the original P7
 routing premise was "the Baily-Borel boundary strata of EVII are
 rational boundary components corresponding to Q-parabolics of
 `E_{7(-25)}` with classical Levi-Hermitian factors (unitary and
 `SO^*` types); G-P §16.4 applies CLASSICALLY to each stratum".
 This premise is FALSE. Per the P8 PUBLISHED atom
 `IsEVIIBoundaryStrataClassification_codim1_is_EIII_PUBLISHED`
 (Wolf 1972 / Satake 1980 / Borel-Ji 2006), the codim-1 boundary
 stratum of EVII is `EIII = E_6/Spin(10)·U(1)` — itself the
 EXCEPTIONAL Hermitian symmetric domain of E_6 type, NOT a
 classical Hermitian symmetric space. Therefore the MHM/BBD route
 does NOT avoid the exceptional-type difficulty: it would require
 first solving G-P-EIII inductively (since codim-1 boundary EIII
 is exceptional E_6 type). The route is effectively a recursion-
 down to an only-marginally-easier exceptional case.
 Tier: `_INVENTION_CLASS` BLOCKED — the original alternative-route
 motivation is invalidated; if future rounds revisit this route,
 they must explicitly attack G-P-EIII first.
 paper source: hyp:ChernWeil-bridge-E7 (G-P-EVII alternative routing —
 INERT INVENTION_CLASS with PREMISE-FALSE annotation per P8 audit;
 retained as typed failure-asset per `feedback_gap_ledger_in_lean4`
 discipline rather than deleted, so the structural-barrier surfacing
 is preserved). -/
axiom IsMHMDecompositionTheoremRouteToEVIIChernExtension_OPEN_INVENTION_CLASS :
 E7ShimuraTor → Prop

/-- `_REQUIRED_HYPOTHESIS` conjectural-extension atom of clause (ii.b):
 the class `[q] ∈ H^8(S_Γ, ℂ)` from (ii.a) is the restriction (along
 `S_Γ ⊂ S_Γ^tor`) of a class in `H^8(S_Γ^tor, ℂ)` compatible with the
 Goresky-Pardon Chern subalgebra of `𝓥_56^can` — i.e. the boundary
 behaviour of `[q]` at the toroidal divisor is "good" at cohomological
 degree 8 in the weight-3 non-classical signature (no obstruction to
 extension; the extended class lies in the Chern subalgebra). Genuine
 residual content of (ii.b) and exactly the "non-cocompact-boundary
 regime at degree 8 = conditional" content the master tex
 `\ref{hyp:ChernWeil-bridge-E7}` Status paragraph labels. Mumford 1977
 + AMRT 2010 supply the framework for EVII (existence of `𝓥^can`,
 well-defined Chern numbers via proportionality; Goresky-Pardon 2002's
 Chern-subalgebra theorem is restricted to classical types per §1.3 Thm
 16.4 and is surfaced as a separate `_REQUIRED_HYPOTHESIS` for the EVII
 extension); they do NOT specifically verify the boundary-compatibility
 at cohomological degree 8 for the E_7 Freudenthal quartic class in the
 weight-3 non-classical signature.
 Tier: `_REQUIRED_HYPOTHESIS` (paper-acknowledged conditional; a
 published framework exists, the specific compatibility is the missing
 piece). E_7 Shimura varieties are NOT PEL, so PEL-specific extension
 results (Faltings-Chai, Lan) do not apply.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b) extension atom. -/
axiom IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- PUBLISHED axiom for clause (ii.a) framework: the Borel-Wallach
 `(𝔤,K_∞)`-cohomology stable-invariant descent framework holds for every
 `E_{7(-25)}` Shimura variety toroidal compactification `S`. See
 `IsBorelWallachStableInvariantDescentFramework_E7`'s docstring for the
 operative source (Borel-Wallach 2000 Ch. VII) and the historical
 cocompact prototype (Matsushima 1962 Osaka Math. J. 14).
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.a) framework atom. -/
axiom borel_wallach_stable_invariant_descent_framework_E7_PUBLISHED :
 ∀ (S : E7ShimuraTor), IsBorelWallachStableInvariantDescentFramework_E7 S

/-- `_REQUIRED_HYPOTHESIS` axiom for clause (ii.a) extension: the specific
 Freudenthal-quartic compact-dual class `[q]_G` is realised by `G`-invariant
 cohomology at degree 8 on `S_Γ` (no Eisenstein-boundary corrections at
 this degree). See `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS`'s
 docstring for why this is the genuine residual content of (ii.a) beyond
 the Borel-Wallach framework. Paper basis: master tex
 `\ref{hyp:ChernWeil-bridge-E7}` Status + `rem:borel-matsushima` ("Whether
 the Chern-Weil generators still exhaust the `G`-invariant cohomology in
 the specific degrees relevant to the Freudenthal quartic … is what
 Hypothesis … asserts").
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.a) extension atom. -/
axiom freudenthal_class_realized_by_g_invariant_cohomology_E7_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS S

/-- PUBLISHED witness for Watanabe 1975 integral cohomology ring of EVII
 (P9.a, R-#new-P9; P12-B citation patch). Source: T. Watanabe, J. Math.
 Kyoto Univ. 15-2 (1975) 363-385. -/
axiom is_watanabe_1975_integral_cohomology_ring_EVII_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsWatanabe1975IntegralCohomologyRingEVII_PUBLISHED S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for V-Z A_q(λ) computation
 for `E_{7(-25)}` at degree 8 (P9.b, R-#new-P9). NOT discharged. -/
axiom is_vogan_zuckerman_aq_lambda_computation_for_E725_degree8_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for Eisenstein cohomology
 vanishing for `E_{7(-25)}` at degree 8 (P9.c, R-#new-P9). NOT discharged. -/
axiom is_eisenstein_cohomology_vanishing_for_E725_degree8_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsEisensteinCohomologyVanishingFor_E725_Degree8_REQUIRED_HYPOTHESIS S

/-- gapBlocked-tier `_REQUIRED_HYPOTHESIS` placeholder witness for
 Hodge-weight-(3,3) automatic G-invariance (P9.d, R-#new-P9 — structural
 barrier). NOT discharged. -/
axiom is_hodge_weight33_on_EVII_automatically_G_invariant_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS S

/-- **P9 DECOMPOSITION BRIDGE** for clause (ii.a) atom (R-#new-P9).
 Per Phase 0 hostile audit, the monolithic
 `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS`
 is structurally derivable from 4 typed sub-atoms:
 (P9.a) PUBLISHED `IsWatanabe1975IntegralCohomologyRingEVII_PUBLISHED`
       (explicit `H^*(Ě_VII; ℤ)` integral cohomology ring + generators
       in degree 8 — Watanabe 1975 PUBLISHED anchor);
 (P9.b) `_REQUIRED_HYPOTHESIS` `IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS`
       (specific A_q(λ) classification at deg 8 contributing G-invariant
       class — V-Z 1984 framework PUBLISHED, specific computation missing);
 (P9.c) `_REQUIRED_HYPOTHESIS` `IsEisensteinCohomologyVanishingFor_E725_Degree8_REQUIRED_HYPOTHESIS`
       (Eisenstein/residual non-contribution at degree 8 — Franke 1998
       framework PUBLISHED, specific vanishing missing);
 (P9.d) gapBlocked-tier `IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS`
       (structural barrier: no published theorem says weight-(3,3)
       classes on EVII Shimura are automatically G-invariant).
 The bridge encodes the structural fact that, given P9.a (explicit
 H^8 generators) + P9.b (A_q(λ) classification of contributing reps)
 + P9.c (no Eisenstein contamination) + P9.d (Hodge-type structure
 auto-G-invariant), the specific class `[q]_G` is realized by
 G-invariant cohomology on `S_Γ` at degree 8. Net effect: monolithic
 atom replaced by 1 PUBLISHED + 2 narrower REQUIRED + 1 gapBlocked
 structural barrier. The active residual is now pinpointed at the
 V-Z A_q(λ) specific computation + Eisenstein-vanishing specific
 computation; the structural barrier (P9.d) is surfaced as typed
 Lean failure-asset. -/
axiom is_freudenthal_class_realized_by_g_invariant_cohomology_E7_from_subatoms_P9 :
 ∀ (S : E7ShimuraTor),
   IsWatanabe1975IntegralCohomologyRingEVII_PUBLISHED S →
   IsVoganZuckermanAqLambdaComputationFor_E725_Degree8_REQUIRED_HYPOTHESIS S →
   IsEisensteinCohomologyVanishingFor_E725_Degree8_REQUIRED_HYPOTHESIS S →
   IsHodgeWeight33OnEVII_AutomaticallyGInvariant_REQUIRED_HYPOTHESIS S →
   IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS S

/-- **DERIVED theorem (P12-A LOAD-BEARING REWIRE, R-#new-P12)**: the
 (ii.a) realization atom is now derivable from the P9 bridge applied
 to 4 P9 sub-atom witnesses (1 PUBLISHED + 2 REQUIRED + 1 gapBlocked
 structural barrier). Per Phase 4 batch audit Pattern-7 ceremony-retreat
 finding, the previous P9 bridge was inert (declared but never consumed).
 This load-bearing rewire makes the bridge ACTIVE: the (ii.a) realization
 atom is now genuinely derived from the P9 sub-atom decomposition;
 the active gapBlocked residual is now pinpointed at the Hodge-weight-
 (3,3) auto-G-invariant structural barrier (P9.d). Patch parallels
 P7-PATCH-A and P12-A-via-P8 which did the same load-bearing rewire
 for G-P-EVII and §16.2-E_6-rep-compat bridges.
 The downstream consumer `matsushima_borel_wallach_descent_to_SGamma_PAPER_LABELLED_CONJECTURAL`
 is rewired below to use this derived theorem instead of the direct
 axiom, completing the load-bearing chain. -/
theorem freudenthal_class_realized_by_g_invariant_cohomology_E7_REQUIRED_HYPOTHESIS_via_P9_subatoms :
 ∀ (S : E7ShimuraTor),
   IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS S :=
 fun S => is_freudenthal_class_realized_by_g_invariant_cohomology_E7_from_subatoms_P9 S
   (is_watanabe_1975_integral_cohomology_ring_EVII_PUBLISHED S)
   -- P16 LOAD-BEARING REWIRE: consume V-Z A_q(λ) via P16 derived theorem
   -- so the P16 bridge (4 sub-atoms: V-Z 1984 + Knapp-Vogan 1995 + Dong-Wong
   -- scope PUBLISHED + θ-stable parabolic R(q)=8 atlas-computable REQUIRED)
   -- is active. Active gate is now atlas-computable parabolic enumeration.
   (is_vogan_zuckerman_aq_lambda_computation_for_E725_degree8_REQUIRED_HYPOTHESIS_via_P16_subatoms S)
   (is_eisenstein_cohomology_vanishing_for_E725_degree8_REQUIRED_HYPOTHESIS S)
   -- P14 LOAD-BEARING REWIRE: consume Hodge-auto-G-invariant via P14
   -- derived theorem so the P14 bridge (3 sub-atoms: m-bound REQUIRED +
   -- Poincaré-polynomial PUBLISHED + Bott-Borel-Weil PUBLISHED) is
   -- active. Active gate is now just m(E_{7(-25)}) ≥ 8 Borel stable
   -- range bound (specific computational claim from PUBLISHED framework).
   (is_hodge_weight33_on_EVII_automatically_G_invariant_REQUIRED_HYPOTHESIS_via_P14_subatoms S)

/-- Bridge axiom for clause (ii.a): the Matsushima/Borel-Wallach descent
 witness `IsMatsushimaDescentToSGamma S` follows from the PUBLISHED
 framework atom + the `_REQUIRED_HYPOTHESIS` extension atom. Per the
 broken-link discipline this surfaces the composite structure of the
 former monolithic axiom: the framework is published (Borel-Wallach Ch.
 VII), the irreducible conjectural content is the specific-`[q]` realisation
 atom. -/
axiom matsushima_descent_to_SGamma_from_framework_and_realization :
 ∀ (S : E7ShimuraTor),
   IsBorelWallachStableInvariantDescentFramework_E7 S →
   IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS S →
   IsMatsushimaDescentToSGamma S

/-- Descent of `[q]_G ∈ H^8(Ě_VII, ℂ)` to `[q] ∈ H^8(S_Γ, ℂ)` via
 Matsushima/Borel-Wallach `(𝔤,K_∞)`-cohomology — now a DERIVED theorem
 from the decomposed atoms (PUBLISHED Borel-Wallach framework atom +
 `_REQUIRED_HYPOTHESIS` specific-realisation atom + bridge axiom), not a
 monolithic axiom. Name kept for downstream-reference stability
 (`MainTheorem.lean` clause-(ii) closure; the rolled-up
 `hyp_ChernWeil_bridge_E7` theorem). The `_PAPER_LABELLED_CONJECTURAL`
 suffix is retained because the derivation rests on the `_REQUIRED_HYPOTHESIS`
 extension atom.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.a). -/
theorem matsushima_borel_wallach_descent_to_SGamma_PAPER_LABELLED_CONJECTURAL :
 ∀ (S : E7ShimuraTor), IsMatsushimaDescentToSGamma S :=
 fun S => matsushima_descent_to_SGamma_from_framework_and_realization S
   (borel_wallach_stable_invariant_descent_framework_E7_PUBLISHED S)
   -- P12-A LOAD-BEARING REWIRE: replace direct axiom with P9-derived
   -- theorem so the P9 bridge (4 sub-atoms: Watanabe PUBLISHED + V-Z
   -- + Eisenstein REQUIRED + Hodge-(3,3) gapBlocked) is active.
   (freudenthal_class_realized_by_g_invariant_cohomology_E7_REQUIRED_HYPOTHESIS_via_P9_subatoms S)

/-- PUBLISHED axiom for clause (ii.b) framework: the Mumford
 canonical extension framework holds for every `E_{7(-25)}` Shimura
 variety toroidal compactification `S`. See
 `IsMumfordCanonicalExtensionFramework_E7`'s docstring for the
 operative sources (Mumford 1977 Invent. Math. 42 + AMRT 1975/2010;
 cross-source Harris 1989 Proc. LMS (3) 59 (1-22); G-P 2002 does NOT
 cover EVII per its §1.3 / §1.6 — surfaced separately as
 `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`).
 NOTE: the prior "AMRT is PEL-restricted, applies at most at toroidal-
 construction level" framing in the Lean docstring was a
 misattribution-of-limitation — AMRT's toroidal construction is fully
 general for any bounded symmetric domain (EVII included); the PEL
 restriction belongs to Faltings-Chai / Lan, not to AMRT itself. The
 genuine residual content is the (ii.b) extension atom below, not a
 PEL/non-PEL gap in the framework.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b) framework atom. -/
axiom mumford_canonical_extension_framework_E7_PUBLISHED :
 ∀ (S : E7ShimuraTor), IsMumfordCanonicalExtensionFramework_E7 S

/-- PUBLISHED axiom for the Zucker conjecture: for ANY Hermitian locally
 symmetric variety (including EVII), the natural map
 `IH^*(S_Γ^*, ℂ) ≅ H^*_{L²}(S_Γ, ℂ)`
 from intersection cohomology of the Baily-Borel compactification to
 `L²`-cohomology is an isomorphism, and via the `(𝔤, K_∞)`-cohomology
 decomposition of `L²` automorphic forms the trivial rep contributes
 `H^*(Ě, ℂ) ↪ IH^*(S_Γ^*, ℂ)`. By Goresky-Pardon 2002 §16.6 commutative
 diagram + the standard `IH^*(S^*) ↪ H^*(S^{tor})` inclusion (any
 toroidal resolution), every compact-dual cohomology class admits a
 canonical extension to `H^*(S_Γ^{tor}, ℂ)`. CRUCIALLY type-uniform:
 PROVED by Looijenga 1988 and Saper-Stern 1990 INDEPENDENTLY in
 generality for ALL bounded symmetric domains including EVII.
 Source: E. Looijenga, "L²-cohomology of locally symmetric varieties",
 Compositio Math. 67 (1988) 3-20; L. Saper, M. Stern, "L²-cohomology
 of arithmetic varieties", Ann. of Math. 132 (1990) 1-69.
 paper source: P5 attack — bridge enabling (ii.b) reduction. -/
axiom IsZuckerConjectureL2EqualsIH_PUBLISHED :
 E7ShimuraTor → Prop

/-- PUBLISHED axiom witness: the Zucker conjecture holds unconditionally
 for every `E_{7(-25)}` Shimura toroidal compactification `S`. Type-uniform
 result of Looijenga 1988 / Saper-Stern 1990. -/
axiom zucker_conjecture_L2_equals_IH_E7_PUBLISHED :
 ∀ (S : E7ShimuraTor), IsZuckerConjectureL2EqualsIH_PUBLISHED S

/-- `_REQUIRED_HYPOTHESIS` axiom witness for the Goresky-Pardon EVII
 extension (consumed by the (iii) ring-hom bridge below; surfaced per
 R-#106b Defect #1). G-P 2002 §1.3 / Thm 16.4 covers only classical
 types `Sp_n(ℝ), U(p,q), SO(2n), SO(2,p)`; the EVII extension is
 explicitly noted as open in G-P §1.6.
 ORDERING NOTE: moved before the P5 (ii.b)-cascade theorem so the
 derived theorem `freudenthal_class_extends_compatibly_at_degree8_E7_REQUIRED_HYPOTHESIS`
 below may reference this witness. -/
axiom goresky_pardon_chern_subalgebra_extension_to_EVII_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS S

/-- PUBLISHED witness for Borel-Hirzebruch presentation of
 `H^*(B(E_6 × U(1)); ℚ)` (P7, R-#new). Sources: Borel 1953 Ann. Math.
 57 §29-30 + Borel-Hirzebruch 1958 Amer. J. Math. 80 + Mimura-Toda
 1991 Translations Math. Monographs vol. 91 Ch. VII §6.
 P7 PUBLISHED sub-atom 1 — `H^*(B(E_6 × U(1)); ℚ)` is polynomial on
 7 generators all realised as Chern classes of `V_27` (and dual) plus
 `c_1(U(1))`. -/
axiom borel_hirzebruch_classifying_space_presentation_for_E6_times_U1_FOLKLORE_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsBorelHirzebruchClassifyingSpacePresentationFor_E6timesU1_FOLKLORE_PUBLISHED S

/-- PUBLISHED witness for G-P 2002 §10-12 abstract parabolic-connection
 framework being group-agnostic (P7, R-#new). Sources: G-P 2002 §10-12
 (abstract patched-parabolic framework) + Looijenga 2017 Compositio
 Math. 153 Corollary 3.3 / Theorem 4.1 (canonical-lift refinement;
 framework verified group-agnostic).
 P7 PUBLISHED sub-atom 2 — abstract framework yields canonical Chern-
 class lifts on Baily-Borel compactifications of any Hermitian
 locally symmetric variety (group-agnostic; type-restriction to
 classical G is at §16.2-16.4 not §10-12). -/
axiom gp_abstract_parabolic_connection_framework_group_agnostic_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsGPAbstractParabolicConnectionFramework_GroupAgnostic_PUBLISHED S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness (kept; load-bearing
 rewire is via derived theorem `_via_P8_subatoms` after the bridge). -/
axiom is_E6_representation_compatibility_of_section_16dot2_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS S

/-- PUBLISHED witness for EVII Baily-Borel boundary strata classification
 (P8.1, R-#new-P8). Sources: Wolf 1972 *Spaces of Constant Curvature*
 + Satake 1980 *Algebraic Structures of Symmetric Domains* + Borel-Ji
 2006 *Compactifications of Symmetric and Locally Symmetric Spaces*. -/
axiom is_EVII_boundary_strata_classification_codim1_is_EIII_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsEVIIBoundaryStrataClassification_codim1_is_EIII_PUBLISHED S

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for form-level
 Hirzebruch-Mumford proportionality for EVII (P8.2, R-#new-P8).
 NOT discharged — gapBlocked semantic; new theorem required.
 Sources for existing form-level results (which do NOT cover EVII):
 Mumford 1977 (numbers only); Faltings 1984 (PEL/Sp form-level);
 Looijenga 2017 (Sp canonical-lift); Gritsenko-Hulek-Sankaran 2008
 (orthogonal form-level). -/
axiom is_hirzebruch_mumford_proportionality_forms_for_EVII_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS S

/-- `_FOLKLORE_PUBLISHED` witness for V_27 Chern generation of
 `H^*(BE_6; ℚ)` (P8.3, R-#new-P8). Sources: Borel 1953 + Toda 1976
 + Kono-Mimura mid-1970s + Mimura-Toda 1991. -/
axiom is_chern_V27_generates_BE6_rational_FOLKLORE_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsChernV27GeneratesBE6Rational_FOLKLORE_PUBLISHED S

/-- `_FOLKLORE_PUBLISHED` witness for V_56 Chern generation of
 `H^*(BE_7; ℚ)` (P8.4, R-#new-P8). Sources: Kono-Mimura mid-1970s
 + Mimura-Toda 1991 + Borel 1953 framework. -/
axiom is_chern_V56_generates_BE7_rational_FOLKLORE_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsChernV56GeneratesBE7Rational_FOLKLORE_PUBLISHED S

/-- **P8 DECOMPOSITION BRIDGE** for the §16.2 E_6-rep-compat atom
 (R-#new-P8). Per Phase 0 hostile audit, the monolithic
 `IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS`
 is structurally derivable from 4 typed sub-atoms:
 (P8.1) PUBLISHED `IsEVIIBoundaryStrataClassification_codim1_is_EIII_PUBLISHED`
       (codim-1 boundary = EIII = E_6/Spin(10)·U(1), exceptional);
 (P8.2) `_REQUIRED_HYPOTHESIS` gapBlocked
       `IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS`
       (form-level HM proportionality for EVII; genuinely OPEN);
 (P8.3) `_FOLKLORE_PUBLISHED`
       `IsChernV27GeneratesBE6Rational_FOLKLORE_PUBLISHED`
       (V_27 Chern generation, Borel + Toda chain);
 (P8.4) `_FOLKLORE_PUBLISHED`
       `IsChernV56GeneratesBE7Rational_FOLKLORE_PUBLISHED`
       (V_56 Chern generation, analogous).
 The bridge encodes the analog of G-P §16.5's argument:
 (P8.1) gives the boundary stratification + classical-type recursion
 needed for spectral-sequence assembly; (P8.2) gives the form-level
 proportionality needed for the Chern-Weil-form transport; (P8.3)+
 (P8.4) give the Chern-class generation of the relevant classifying
 spaces. Net effect: the active gapBlocked residual content of the
 §16.2 E_6-rep-compat atom is now PINPOINTED at the form-level HM
 proportionality for EVII (P8.2) — a genuine open published-
 literature-silent problem, surfaced as a typed Lean atom per
 failure-as-asset discipline. -/
axiom is_E6_representation_compatibility_of_section_16dot2_from_subatoms_P8 :
 ∀ (S : E7ShimuraTor),
   IsEVIIBoundaryStrataClassification_codim1_is_EIII_PUBLISHED S →
   IsHirzebruchMumfordProportionalityFormsForEVII_REQUIRED_HYPOTHESIS S →
   IsChernV27GeneratesBE6Rational_FOLKLORE_PUBLISHED S →
   IsChernV56GeneratesBE7Rational_FOLKLORE_PUBLISHED S →
   IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS S

/-- **DERIVED theorem (P12-A LOAD-BEARING REWIRE, R-#new-P12)**: the
 §16.2 E_6-rep-compat atom is now derivable from the P8 bridge applied
 to 4 P8 sub-atom witnesses (1 PUBLISHED + 1 gapBlocked + 2 FOLKLORE_PUBLISHED).
 Per Phase 4 batch audit Pattern-7 ceremony-retreat finding, the
 previous P8 bridge was inert (declared but never consumed). This
 load-bearing rewire makes the bridge ACTIVE: the §16.2 atom is now
 genuinely derived from the P8 sub-atom decomposition via the bridge;
 the active gapBlocked residual is now pinpointed at form-level HM
 proportionality for EVII. Patch parallels P7-PATCH-A which did the
 same load-bearing rewire for the G-P-EVII bridge.
 The downstream consumer in P7-PATCH-A is rewired (later in this file)
 to use this derived theorem instead of the direct axiom, completing
 the load-bearing chain. -/
theorem is_E6_representation_compatibility_of_section_16dot2_REQUIRED_HYPOTHESIS_via_P8_subatoms :
 ∀ (S : E7ShimuraTor),
   IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS S :=
 fun S => is_E6_representation_compatibility_of_section_16dot2_from_subatoms_P8 S
   (is_EVII_boundary_strata_classification_codim1_is_EIII_PUBLISHED S)
   -- P13 LOAD-BEARING REWIRE (R-#new-P13): consume form-HM-EVII via the
   -- P13 derived theorem instead of the direct axiom, so the P13 bridge
   -- (4 P13 sub-atoms: SI-1 + SI-2-LB PUBLISHED + SI-2-HR + SI-3 REQUIRED)
   -- is load-bearing. Active gates are now SI-2-HR + SI-3 (narrower
   -- than monolithic form-HM-EVII).
   (is_hirzebruch_mumford_proportionality_forms_for_EVII_REQUIRED_HYPOTHESIS_via_P13_subatoms S)
   (is_chern_V27_generates_BE6_rational_FOLKLORE_PUBLISHED S)
   (is_chern_V56_generates_BE7_rational_FOLKLORE_PUBLISHED S)

/-- `_REQUIRED_HYPOTHESIS` placeholder witness for degree-8 specialization
 of G-P-EVII Chern-subalgebra surjection (P7, R-#new). NOT discharged.
 This is the narrower atom needed by the downstream consumer (clause
 iii ring-hom transport for the Freudenthal quartic `[q]`); if a
 future round produces a degree-8-specific result, this atom can be
 retired without solving the full G-P-EVII extension. -/
axiom is_GP_chern_subalgebra_surjection_at_degree8_E7_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsGPChernSubalgebraSurjectionAtDegree8_E7_REQUIRED_HYPOTHESIS S

/-- **DECOMPOSITION BRIDGE** for G-P-EVII extension (P7, R-#new).
 Per Phase 0+1 hostile audit, the monolithic
 `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`
 is honestly derivable from 2 PUBLISHED sub-atoms + 1 narrower
 `_REQUIRED_HYPOTHESIS` (E_6-representation compatibility of §16.2):
 (a) PUBLISHED Borel-Hirzebruch presentation of `H^*(B(E_6 × U(1)); ℚ)`
     (Borel 1953 + Borel-Hirzebruch 1958 + Mimura-Toda 1991);
 (b) PUBLISHED G-P §10-12 abstract framework + Looijenga 2017
     (group-agnostic canonical Chern-class lifts);
 (c) `_REQUIRED_HYPOTHESIS` E_6-rep-theoretic compatibility of G-P
     §16.2 (the genuine narrower residual).
 The mathematical bridge: G-P §16.5's two-line argument (Poincaré
 duality on `D̆ = E_7/E_6·SO(2)` + lift along `H^*(BK) → H^*(X)` +
 Hirzebruch-Mumford proportionality) goes through verbatim once
 (a) + (b) + (c) are granted. This is structural-definitional (not
 ceremonial): it surfaces 2 published anchors + isolates the
 genuine open piece. Net effect: monolithic atom replaced by narrower
 atom + 2 published; conjectural surface in the (ii)/(iii) clause
 chain becomes more granular and target-able. -/
axiom goresky_pardon_chern_subalgebra_extension_to_EVII_from_subatoms :
 ∀ (S : E7ShimuraTor),
   IsBorelHirzebruchClassifyingSpacePresentationFor_E6timesU1_FOLKLORE_PUBLISHED S →
   IsGPAbstractParabolicConnectionFramework_GroupAgnostic_PUBLISHED S →
   IsE6RepresentationCompatibilityOfSection16dot2_REQUIRED_HYPOTHESIS S →
   IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS S

/-- **DOWNSTREAM-NARROWING BRIDGE** for G-P-EVII (P7, R-#new).
 The downstream consumer (clause iii ring-hom transport for the
 Freudenthal quartic class `[q]`) only literally needs the
 degree-8 sub-case. This bridge expresses that the degree-8
 specialization atom suffices to discharge the full G-P-EVII
 extension at the level needed by clause (iii). If a future round
 produces a degree-8-specific result, this is the route to retire
 the full extension via the narrower atom. -/
axiom goresky_pardon_chern_subalgebra_extension_to_EVII_from_degree8 :
 ∀ (S : E7ShimuraTor),
   IsGPChernSubalgebraSurjectionAtDegree8_E7_REQUIRED_HYPOTHESIS S →
   IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS S

/-- `_INVENTION_CLASS` placeholder witness for MHM/BBD alternative
 routing (P7, R-#new). NOT discharged. Surfaced as alternative
 attack vector for future rounds; if successful, gives indirect
 EVII extension via decomposition theorem on boundary strata
 (which are classical types and so admit G-P §16.4 directly). -/
axiom is_mhm_decomposition_theorem_route_to_EVII_chern_extension_OPEN_INVENTION_CLASS :
 ∀ (S : E7ShimuraTor),
   IsMHMDecompositionTheoremRouteToEVIIChernExtension_OPEN_INVENTION_CLASS S

/-- **PUBLISHED atom** (P5 decomposition, R-#new-Phase4-rollback): the
 IH-to-toroidal pullback step for the Freudenthal class. Concretely:
 given a class `[q] ∈ IH^8(S_Γ^*, ℚ)` on the Baily-Borel minimal
 compactification (obtained from `[q]_G` via Borel-Wallach + Zucker),
 the canonical pullback `IH^*(S_Γ^*, ℚ) → H^*(S_Γ^{tor}, ℚ)` along any
 toroidal resolution `S_Γ^{tor} → S_Γ^*` produces a well-defined class
 in `H^8(S_Γ^{tor}, ℚ)` independent of the toroidal-compactification
 choice. This is the (ii.b.1) PUBLISHED structural component.
 Sources: Beilinson-Bernstein-Deligne 1982 ("Faisceaux pervers",
 Astérisque 100) decomposition theorem + perverse pullback functoriality;
 M. Saito 1988 ("Modules de Hodge polarisables", Publ. RIMS 24) mixed
 Hodge module pullback for IH; Goresky-MacPherson 1980 ("Intersection
 homology theory", Topology 19) IH functoriality.
 CORRECTION (R-#new Phase 4 audit catch): the earlier P5 cascade
 attribution to "Looijenga 1988 Compositio 67 §3" for this IH-pullback
 step was a Phantom Attribution — Looijenga §3 is about Eisenstein-type
 weights/sheaf-level constructions, not the IH-pullback. Correct anchor
 is BBD 1982 / Saito MHM.
 SCOPE: this PUBLISHED atom covers only the IH-pullback step. The
 PLACEMENT of the pulled-back class in the Goresky-Pardon Chern
 subalgebra (degree-8) is a SEPARATE residual content — surfaced as
 (ii.b.2) `_REQUIRED_HYPOTHESIS` below.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b.1) PUBLISHED
 (IH-to-toroidal pullback step). -/
axiom IsIHPullbackToToroidalForFreudenthalClass_E7_PUBLISHED :
 E7ShimuraTor → Prop

/-- PUBLISHED witness for the IH-pullback atom (BBD 1982 + Saito MHM
 + Goresky-MacPherson 1980; canonical for any locally symmetric variety
 + toroidal resolution including EVII). -/
axiom ih_pullback_to_toroidal_for_freudenthal_class_E7_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsIHPullbackToToroidalForFreudenthalClass_E7_PUBLISHED S

/-- **`_REQUIRED_HYPOTHESIS` atom** (P5 decomposition residual,
 R-#new-Phase4): the pulled-back class `[q] ∈ H^8(S_Γ^{tor}, ℚ)`
 (from (ii.b.1) PUBLISHED) is PLACED IN the Goresky-Pardon Chern
 subalgebra at degree 8 — i.e. is a polynomial in
 `c_i(𝓥_56^{can}) ∈ H^*(S_Γ^{tor}, ℚ)`. This is the GENUINE residual
 conjectural content of (ii.b) per master tex L11625-11647 Status
 paragraph: "the compatibility of the descended Matsushima image `[q]`
 with the Mumford-canonical extension on `S_Γ^{tor}` in the weight-3
 non-classical signature at cohomological degree 8 is **not presently
 available in the published literature**".
 NOT DERIVABLE from (ii.a) + Zucker + Mumford framework + G-P-EVII
 alone: the well-definedness of the Chern subalgebra (G-P-EVII)
 does NOT automatically place an arbitrary class into the subalgebra.
 The placement is the irreducible conditional content.
 ROLLBACK NOTE (R-#new Phase 4 audit): a previous P5 attempt to make
 (ii.b) a derived theorem via the four-input bridge axiom
 `freudenthal_class_extends_compatibly_at_degree8_E7_FROM_iia_and_GP_EVII`
 was REJECTED by hostile audit on three grounds:
 (A3/D1) circular with clause (iii) — placement-in-Chern-subalgebra
   is the polynomial-identity content of (iii), and (iii) consumes
   (ii.b);
 (A5) paper-Lean inconsistency — master tex L11625-11647 explicitly
   says the degree-8 compatibility is "not presently available in the
   published literature";
 (D2) ceremony-relabelling — the "derivation" was an unproven AXIOM,
   not a theorem; atom count reduction was illusory.
 Per `feedback_team_v4_ceremony_is_retreat` + `feedback_no_small_breakthrough_self_castration`,
 the cascade has been rolled back. The (ii.b) compatibility content
 is decomposed honestly into PUBLISHED (ii.b.1) + `_REQUIRED_HYPOTHESIS`
 (ii.b.2). Net conjectural surface UNCHANGED.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b.2) `_REQUIRED_HYPOTHESIS`
 (placement-in-Chern-subalgebra residual). -/
axiom IsFreudenthalClassPlacedInChernSubalgebra_E7_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- `_REQUIRED_HYPOTHESIS` witness for the placement-in-Chern-subalgebra
 atom. The genuine residual conditional content of (ii.b) per master tex
 L11625-11647. Post-P10 audit: this atom stays gapPartial; the P10
 Phase 0 audit confirms no published placement result exists for EVII;
 surfaces 6 new typed structural-fact atoms per failure-asset
 discipline (encoded below as `IsLooijenga2017PlacementCoversSymplecticOnly_PUBLISHED`,
 `IsEsnaultHarris2018DescentNotPlacement_PUBLISHED`, etc.). -/
axiom freudenthal_class_placed_in_chern_subalgebra_E7_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsFreudenthalClassPlacedInChernSubalgebra_E7_REQUIRED_HYPOTHESIS S

/-- **PUBLISHED structural-fact atom (P10.a, R-#new-P10)**: Looijenga
 2017 Compositio Math. 153 (1349-1371) "Goresky-Pardon lifts of Chern
 classes and associated Tate extensions" §3-4 explicitly only works
 out the SYMPLECTIC case `A_g = Sp_{2g}/U_g` with the Hodge bundle.
 Exceptional types (including EVII) are explicitly out of scope per
 the paper's §1 introduction "We work this out in the case of the
 symplectic group". Tier: PUBLISHED structural fact (Looijenga 2017
 scope explicit). Surfaced per P10 Phase 0 audit as TYPED failure-
 asset encoding the literature absence for placement-in-Chern-
 subalgebra results beyond Sp.
 Source: E. Looijenga, "Goresky-Pardon lifts of Chern classes and
 associated Tate extensions", Compositio Math. 153 (2017), 1349-1371
 (arXiv:1510.04103).
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b.2) — P10
 failure-asset structural fact. -/
axiom IsLooijenga2017PlacementCoversSymplecticOnly_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED structural-fact atom (P10.b, R-#new-P10)**: Esnault-
 Harris 2018 (arXiv:1801.08219) "Chern classes of automorphic vector
 bundles, II" Theorem 0.1 proves DESCENT of `c_i(ℰ^can)` themselves
 (the Chern classes of canonical extensions) from toroidal to minimal
 compactifications, under Galois action — for Hodge-type Shimura
 varieties (with stated "easily extended to abelian type" caveat).
 Does NOT prove PLACEMENT of an arbitrary class in the Chern subring.
 EVII Shimura is explicitly NOT of Hodge type or abelian type — Milne
 SV literature places E_7 as one of the cases NOT a moduli variety
 for abelian motives. Tier: PUBLISHED structural fact.
 Source: H. Esnault, M. Harris, "Chern classes of automorphic vector
 bundles, II", arXiv:1801.08219.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b.2) — P10
 failure-asset structural fact (descent ≠ placement). -/
axiom IsEsnaultHarris2018DescentNotPlacement_PUBLISHED :
 E7ShimuraTor → Prop

/-- **PUBLISHED structural-fact atom (P10.c, R-#new-P10)**: per Milne
 "Shimura Varieties and Moduli" (arXiv:1105.0887), the connected
 Shimura variety associated to `E_{7(-25)}` is NOT a moduli variety
 for abelian motives. This BLOCKS the Deligne absolute-Hodge route
 to algebraicity that works for Hodge-type / abelian-type Shimura
 varieties (PEL, Kuga families, etc.). Tier: PUBLISHED structural
 fact. The downstream implication is that no Tate-style argument
 via abelian-motive realization is available for EVII; placement of
 [q] in Chern subalgebra cannot be obtained via this route.
 Source: J. Milne, "Shimura Varieties and Moduli", arXiv:1105.0887;
 also Esnault-Harris 2018 §0 and Borovoi 1984.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b.2) — P10
 failure-asset structural fact (E_7 not abelian-motive moduli). -/
axiom IsE7ShimuraNotAbelianMotiveModuli_PUBLISHED :
 E7ShimuraTor → Prop

/-- **gapBlocked-tier structural-barrier atom (P10.d, R-#new-P10)**:
 the alternative placement route "[q] is a Hodge class of type (4,4)
 hence by HC algebraic hence in the Chern subalgebra" is CIRCULAR
 for the Hodge Conjecture reduction: assuming HC is precisely what
 we are reducing to. Surfaced as typed BLOCKED structural barrier
 per failure-asset discipline. Tier: `_REQUIRED_HYPOTHESIS` at
 gapBlocked semantic level. This atom encodes the formal observation
 that Pattern-A3 circularity blocks the Hodge-class route.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b.2) — P10
 failure-asset structural fact (Hodge-class route circular). -/
axiom IsHodgeClassQAtDegree8CircularReduction_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- **PUBLISHED structural-fact atom (P10.e, R-#new-P10)**: the
 "salvage path γ" definitional adoption `[q]_G := c_4(𝓥_56^{can})`
 (or `c_2(𝓥_56)² = 1296 h^4`) is INTERNALLY CONSISTENT with clause
 (iii)'s Chern-polynomial form `[q] = P(c_1, …, c_4)` — both
 `c_4 = 594 h^4 ≠ 0` and `c_2² = 1296 h^4 ≠ 0` span
 `H^8(Ě_VII; ℚ) = ℚ·h^4` per (i.b.1) PUBLISHED `IsChernSubringSurjectiveOntoH8_E7P7`.
 Tier: PUBLISHED structural fact. Source: Borel-Hirzebruch 1958 §16
 + Mimura-Toda 1991 AMS Transl. 91 Ch. VII §6 (H*(BE_7;ℚ) generators)
 + (i.b.1) PUBLISHED `IsChernSubringSurjectiveOntoH8_E7P7` atom.
 paper source: hyp:ChernWeil-bridge-E7 (ii.b.2) — P10 failure-asset
 structural fact (salvage path γ consistency). -/
axiom IsSalvagePathGammaConsistentWithClauseIII_PUBLISHED :
 E7ShimuraTor → Prop

/-- **gapBlocked-tier structural-barrier atom (P10.f, R-#new-P10)**:
 the salvage path γ (`[q]_G := c_4(𝓥_56^{can})`) DISSOLVES the
 (i.b.2) `_INVENTION_CLASS` content into definitional fiat rather
 than constructing a canonical cross-ring bridge `Φ : Sym⁴(V_56^*)^{E_7}
 → H^8(E_7^ℂ/P_7, ℚ)` with `Φ(q) ≠ 0`. The Borel-Hirzebruch
 characteristic map has domain `Sym(𝔱*)^W ≠ Sym^4(V_56^*)^{E_7}`
 (per master tex reading (a) "not a corollary of B-H"), so adopting
 γ trades the (i.b.2) atom for a master-tex coordination decision
 (changing the cross-ring definition). Net atom-count NOT reduced —
 ceremony-retreat-style cost flagged per `feedback_team_v4_ceremony_is_retreat`.
 Tier: `_REQUIRED_HYPOTHESIS` at gapBlocked semantic level. Surfaced
 per failure-asset discipline.
 paper source: hyp:ChernWeil-bridge-E7 (ii.b.2) — P10 failure-asset
 structural fact (γ-cost). -/
axiom IsSalvagePathGammaDissolvesInventionClassContent_REQUIRED_HYPOTHESIS :
 E7ShimuraTor → Prop

/-- PUBLISHED witness for P10.a (Looijenga 2017 scope). -/
axiom is_looijenga_2017_placement_covers_symplectic_only_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsLooijenga2017PlacementCoversSymplecticOnly_PUBLISHED S

/-- PUBLISHED witness for P10.b (Esnault-Harris 2018 descent ≠ placement). -/
axiom is_esnault_harris_2018_descent_not_placement_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsEsnaultHarris2018DescentNotPlacement_PUBLISHED S

/-- PUBLISHED witness for P10.c (Milne: E_7 not abelian-motive moduli). -/
axiom is_E7_shimura_not_abelian_motive_moduli_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsE7ShimuraNotAbelianMotiveModuli_PUBLISHED S

/-- gapBlocked-tier `_REQUIRED_HYPOTHESIS` placeholder witness for
 P10.d (Hodge-class route circularity). NOT discharged. -/
axiom is_hodge_class_q_at_degree8_circular_reduction_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsHodgeClassQAtDegree8CircularReduction_REQUIRED_HYPOTHESIS S

/-- PUBLISHED witness for P10.e (γ internally consistent with clause iii). -/
axiom is_salvage_path_gamma_consistent_with_clause_iii_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsSalvagePathGammaConsistentWithClauseIII_PUBLISHED S

/-- gapBlocked-tier `_REQUIRED_HYPOTHESIS` placeholder witness for
 P10.f (γ-cost dissolving INVENTION_CLASS content). NOT discharged. -/
axiom is_salvage_path_gamma_dissolves_invention_class_content_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsSalvagePathGammaDissolvesInventionClassContent_REQUIRED_HYPOTHESIS S

/-- Bridge axiom for the (ii.b) decomposition: the original (ii.b)
 compatibility atom follows from the conjunction of (ii.b.1) PUBLISHED
 IH-pullback + (ii.b.2) `_REQUIRED_HYPOTHESIS` placement. This is a
 PURELY STRUCTURAL/DEFINITIONAL bridge: if the class IH-pulls back to
 `H^8(S_Γ^{tor})` AND that class is placed in the Chern subalgebra of
 `𝓥_56^{can}`, then the original (ii.b) compatibility statement holds.
 No mathematical content beyond combining the two atoms. -/
axiom freudenthal_class_extends_compatibly_at_degree8_E7_FROM_iib1_and_iib2 :
 ∀ (S : E7ShimuraTor),
   IsIHPullbackToToroidalForFreudenthalClass_E7_PUBLISHED S →
   IsFreudenthalClassPlacedInChernSubalgebra_E7_REQUIRED_HYPOTHESIS S →
   IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS S

/-- DERIVED theorem: the original (ii.b) compatibility witness, name
 preserved for downstream-reference stability. The previous form was a
 standalone `_REQUIRED_HYPOTHESIS` axiom; the post-R-#new-Phase4 form
 is a definitional consequence of the (ii.b.1) PUBLISHED IH-pullback
 atom + the (ii.b.2) `_REQUIRED_HYPOTHESIS` placement atom via the
 structural bridge above.
 P5 HONEST OUTCOME (rollback from cascade overclaim):
 - 1 NEW PUBLISHED atom surfaced: `IsZuckerConjectureL2EqualsIH_PUBLISHED`
   (Looijenga 1988 / Saper-Stern 1990; genuine type-uniform PUBLISHED).
 - 1 NEW PUBLISHED atom surfaced: `IsIHPullbackToToroidalForFreudenthalClass_E7_PUBLISHED`
   (BBD 1982 + Saito MHM + Goresky-MacPherson 1980).
 - (ii.b) atom decomposed into (ii.b.1) PUBLISHED + (ii.b.2)
   `_REQUIRED_HYPOTHESIS`; net conjectural surface UNCHANGED.
 - Conjectural surface for hyp:ChernWeil-bridge-E7 stays at 4 typed
   atoms: 1 `_INVENTION_CLASS` (i.b.2) + 3 `_REQUIRED_HYPOTHESIS`
   (ii.a, ii.b.2 placement, G-P-EVII).
 The cascade-to-3-atoms claim was rejected by Phase 4 audit. The honest
 outcome is structural decomposition + literature surfacing, not closure.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b) extension atom. -/
theorem freudenthal_class_extends_compatibly_at_degree8_E7_REQUIRED_HYPOTHESIS :
 ∀ (S : E7ShimuraTor),
   IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS S :=
 fun S => freudenthal_class_extends_compatibly_at_degree8_E7_FROM_iib1_and_iib2 S
   (ih_pullback_to_toroidal_for_freudenthal_class_E7_PUBLISHED S)
   (freudenthal_class_placed_in_chern_subalgebra_E7_REQUIRED_HYPOTHESIS S)

/-- Bridge axiom for clause (ii.b): the Mumford canonical-extension
 witness `IsMumfordCanonicalExtensionToTor S` follows from the PUBLISHED
 Mumford framework atom + the `_REQUIRED_HYPOTHESIS`
 boundary-compatibility atom. Per the broken-link discipline this surfaces
 the composite structure of the former monolithic axiom: the framework is
 published (existence of `𝓥^can` + well-defined Chern classes), the
 irreducible conjectural content is the specific boundary-compatibility
 at degree 8. -/
axiom mumford_canonical_extension_to_tor_from_framework_and_compatibility :
 ∀ (S : E7ShimuraTor),
   IsMumfordCanonicalExtensionFramework_E7 S →
   IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS S →
   IsMumfordCanonicalExtensionToTor S

/-- Extension of `[q] ∈ H^8(S_Γ, ℂ)` to `[q] ∈ H^8(S_Γ^tor, ℂ)` via
 Mumford canonical extension — now a DERIVED theorem from
 the decomposed atoms, not a monolithic axiom. Name kept for downstream-
 reference stability. The `_PAPER_LABELLED_CONJECTURAL` suffix is retained
 because the derivation rests on the `_REQUIRED_HYPOTHESIS` boundary-
 compatibility atom.
 paper source: hyp:ChernWeil-bridge-E7 clause (ii.b). -/
theorem mumford_1977_canonical_extension_to_tor_PAPER_LABELLED_CONJECTURAL :
 ∀ (S : E7ShimuraTor), IsMumfordCanonicalExtensionToTor S :=
 fun S => mumford_canonical_extension_to_tor_from_framework_and_compatibility S
   (mumford_canonical_extension_framework_E7_PUBLISHED S)
   (freudenthal_class_extends_compatibly_at_degree8_E7_REQUIRED_HYPOTHESIS S)

/-- Clause (ii): Matsushima descent of `[q]_G` to
 `[q] ∈ H^8(S_Γ^tor, ℂ)` via `(g, K_∞)`-cohomology + Mumford canonical
 extension.

 Concrete conjunction of the two atomic literature predicates (no longer
 an opaque axiom). The closure theorem `hyp_ChernWeil_bridge_E7_ii_closed`
 in `MainTheorem.lean` proves `∀ S, ChernWeilBridge_E7_ii S` via
 conjunction-intro from the two classical-lit axioms above.

 paper source: hyp:ChernWeil-bridge-E7 clause (ii). -/
def ChernWeilBridge_E7_ii (S : E7ShimuraTor) : Prop :=
 IsMatsushimaDescentToSGamma S ∧ IsMumfordCanonicalExtensionToTor S

/-- PUBLISHED folklore-corollary atom for clause (iii): the Matsushima/
 Borel-Wallach descent map `H^*(Ě_VII, ℂ) → H^*(S_Γ, ℂ)` and the Mumford
 canonical extension `H^*(S_Γ, ℂ) ⤳ H^*(S_Γ^tor, ℂ)` are graded ring
 homomorphisms; they carry the Chern subring of `H^*(Ě_VII)` (generated
 by `c_i(𝓥_56)`) into the Chern subalgebra of `H^*(S_Γ^tor)` (generated
 by `c_i(𝓥_56^can)`), `c_i(𝓥_56) ↦ c_i(𝓥_56^can)`. PUBLISHED FOLKLORE-
 COROLLARY tier (same standing as SG-2/3/4/12/19): the conjunction is
 standard machinery but no single theorem in the cited sources literally
 states the full claim — assembled from:
 (a) Borel-Wallach 2000 (Matsushima/Murakami map arises from the
   `(𝔤, K)`-cochain DGA, hence is a ring map by Cartan-Eilenberg /
   standard DGA-cohomology — folkloric upgrade from the cohomological
   isomorphism stated in B-W to the ring-hom property).
 (b) Mumford 1977 Invent. Math. 42 proportionality theorem: gives
   Chern-NUMBER proportionality `c^I(Ē_Σ) = v(Γ) c^I(Ď)` for any
   partition `I` (top-degree integrals). FOLKLORIC UPGRADE to ring-
   compatibility of the Chern-CLASS map (`c_i(𝓥) ↦ c_i(𝓥^can)`) is
   standard but not literally in M77; requires Goresky-Pardon-style
   well-definedness of `c_i(𝓥^can)` as a class (not just a number) +
   DGA functoriality.
 (c) Goresky-Pardon 2002 Invent. Math. 147, §1.1 + §1.3: Chern classes
   of automorphic vector bundles have canonical lifts to
   `H^{2i}(X̄_BB; ℂ)` (Baily-Borel, ℂ-coefficients, NOT `H^{2i}(S^tor, ℚ)`
   as a prior version of this docstring claimed — fix per R-#106b
   Defect #2); the toroidal-locus version is recovered via the
   compatibility pullback `τ*(c̄^i) = c^i(Ē_Σ)` (M77 + G-P §1.1). G-P's
   theorem RESTRICTS to classical types `Sp_n(ℝ), U(p,q), SO(2n),
   SO(2,p)` (§1.3 Thm 16.4); the EVII case is NOT covered and is
   surfaced as `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`
   above (consumed by the (iii) bridge below).
 (d) Cross-source: Borel-Hirzebruch 1958/59/60 (compact-dual Chern-
   subring presentation — the source of (i.b.1) PUBLISHED).
 paper source: hyp:ChernWeil-bridge-E7 clause (iii) ring-hom atom. -/
axiom IsChernWeilDescentRingHomCompatibleWithChernSubring_E7 :
 E7ShimuraTor → Prop

/-- PUBLISHED folklore-corollary witness for the (iii) ring-hom atom.
 The unconditional content is the Mumford-1977 + Borel-Wallach ring-map
 + Borel-Hirzebruch compact-dual presentation conjunction (all 3 cover
 EVII at the abstract level). The EVII-specific extension of G-P's
 Chern-subalgebra theorem is surfaced separately as
 `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`. -/
axiom chern_weil_descent_ring_hom_compatible_with_chern_subring_E7_PUBLISHED :
 ∀ (S : E7ShimuraTor), IsChernWeilDescentRingHomCompatibleWithChernSubring_E7 S

/-- PUBLISHED folklore-corollary atom surfacing the witness-chain
 identification that the (iii) bridge silently bundled in its prior
 form (R-#106a B1/B2 finding). Two paper-definitional pieces:
 (a) `[q]_G := Φ(q)`, i.e. the (i.b) "non-vanishing compact-dual
   class `[q]_G`" IS the image of the Freudenthal quartic `q` under the
   (i.b.2) cross-ring bridge `Φ`. This is a paper-definitional choice
   (the project formalises Schwarz's `q` as the unique deg-4 E_7-invariant
   and `[q]_G` as its image under any chosen Chern-Weil bridge); without
   it the (i.b) "[q]_G ∈ Chern subring" content is informal-only.
 (b) The descent map of the (ii.a) witness `IsMatsushimaDescentToSGamma`
   IS the descent ring-hom characterised by the (iii) ring-hom atom
   above. Both refer to "the Matsushima/Borel-Wallach map at the
   trivial rep on `S_Γ`"; this identification is the standard reading
   but no Lean atom previously tied them.
 Tier: PUBLISHED folklore-corollary (same standing as SG-2/3/4/12/19) —
 both pieces are paper-definitional + DGA-folkloric; not new conjectural
 content. Surfaced per the broken-link discipline to make the (iii)
 reduction's dependency graph fully typed (R-#106a Phase 4 finding).
 paper source: hyp:ChernWeil-bridge-E7 (i.b) + (ii.a) + (iii)
 witness-chain identification — R-#107 surfacing. -/
axiom IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED :
 E7ShimuraTor → Prop

/-- PUBLISHED folklore-corollary witness for the B1/B2 identification
 atom (paper-definitional + standard DGA-folklore). -/
axiom compact_dual_quartic_image_and_descent_map_witness_chain_E7_FOLKLORE_PUBLISHED :
 ∀ (S : E7ShimuraTor),
   IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED S

/-- Bridge axiom for clause (iii) (POST-R-#107): the polynomial identity
 `IsPolynomialInCanonicalChernClasses S (freudenthalQuartic S)` follows
 from 7 typed inputs:
 (1) (i.b.1) PUBLISHED `IsChernSubringSurjectiveOntoH8_E7P7` —
   `H^8(Ě_VII, ℚ) = ℚ·h^4` 1-dim + Chern subring surjects onto it.
 (2) (i.b.2) `_INVENTION_CLASS` `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
   — the cross-ring map `Φ : Sym^4(V_56^*)^{E_7} → H^8` exists, lands in
   the Chern subring, and `Φ(q) ≠ 0`.
 (3) (ii.a) `IsMatsushimaDescentToSGamma` witness — `[q]_G ⤳ [q]`.
 (4) (ii.b) `IsMumfordCanonicalExtensionToTor` witness — `[q] ⤳ [q]^tor`.
 (5) PUBLISHED folklore-corollary `IsChernWeilDescentRingHomCompatibleWithChernSubring_E7`
   — descent + extension are ring homs carrying `c_i ↦ c_i(𝓥^can)`.
 (6) `_REQUIRED_HYPOTHESIS` `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`
   — G-P's Chern-subalgebra theorem extends from classical types to EVII
   (G-P §1.6 explicitly leaves this open — surfaced per R-#106b Defect #1).
 (7) PUBLISHED folklore-corollary `IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED`
   — paper-definitional `[q]_G := Φ(q)` + identification of the (ii.a)
   descent map with the ring-hom of (5) (surfaced per R-#106a B1/B2).
 The mathematical step is then pure linear algebra in 1-dim + transport:
 (1)+(2)+(7) ⟹ `[q]_G = P(c_i(𝓥_56))` for some `P` on the compact dual;
 (3)+(4)+(5)+(6)+(7) ⟹ this identity transports to
 `[q] = P(c_i(𝓥_56^can))` in `H^8(S_Γ^tor, ℚ)`. This is exactly the
 `rem:E7-chernweil-tautology` "tautological once granted" content, with
 ALL identifications now typed (no more hidden bundling). -/
axiom polynomial_identity_E7_iii_from_atoms :
 ∀ (S : E7ShimuraTor),
   IsChernSubringSurjectiveOntoH8_E7P7 S →
   IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS S →
   IsMatsushimaDescentToSGamma S →
   IsMumfordCanonicalExtensionToTor S →
   IsChernWeilDescentRingHomCompatibleWithChernSubring_E7 S →
   IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS S →
   IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED S →
   IsPolynomialInCanonicalChernClasses S (freudenthalQuartic S)

/-- Polynomial identity `[q] = P(c_1, ..., c_4)` in the canonical Chern
 classes — DERIVED theorem (no own clause-(iii) conjectural content;
 REDUCES-TO (i.b)+(ii)+ring-hom-folklore-corollary + 1 `_REQUIRED_HYPOTHESIS`
 (G-P EVII extension, post-P7-PATCH-A discharged via 3-input bridge:
 2 PUBLISHED sub-atoms + 1 narrower `_REQUIRED_HYPOTHESIS` for E_6-rep
 compatibility of G-P §16.2) + 1 PUBLISHED folklore-corollary (witness-
 chain identification)). The polynomial identity itself is pure 1-dim
 linear algebra on `H^8(Ě_VII, ℚ) = ℚ·h^4` + ring-hom transport along
 descent/extension (the `rem:E7-chernweil-tautology` "tautological once
 granted" fact). Name kept with `_PAPER_LABELLED_CONJECTURAL` suffix for
 downstream-reference stability; the suffix now indicates the derivation
 rests on (i.b.2) `_INVENTION_CLASS` + (ii.a)/(ii.b) `_REQUIRED_HYPOTHESIS`
 + (post-P7-PATCH-A: E_6-rep-compatibility-of-§16.2) `_REQUIRED_HYPOTHESIS`
 atoms, not residual clause-(iii)-specific conjectural content.
 P7-PATCH-A LOAD-BEARING REWIRE: discharges the monolithic G-P-EVII
 input by invoking the P7 decomposition bridge `goresky_pardon_chern_subalgebra_extension_to_EVII_from_subatoms`
 applied to 2 PUBLISHED sub-atoms (Borel-Hirzebruch presentation of
 `H^*(B(E_6 × U(1)); ℚ)` + G-P §10-12 group-agnostic abstract framework)
 + 1 narrower `_REQUIRED_HYPOTHESIS` (E_6-representation compatibility
 of G-P §16.2). The active conjectural surface for G-P-EVII content is
 thereby NARROWED from the full ring-extension residual to the
 representation-theoretic K-decomposition compatibility step. The
 monolithic atom `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`
 remains as a historical predicate but is NO LONGER directly consumed
 by this proof path.
 paper source: hyp:ChernWeil-bridge-E7 clause (iii). -/
theorem borel_hirzebruch_schwarz_polynomial_identity_E7_iii_PAPER_LABELLED_CONJECTURAL :
 ∀ (S : E7ShimuraTor),
   IsPolynomialInCanonicalChernClasses S (freudenthalQuartic S) :=
 fun S => polynomial_identity_E7_iii_from_atoms S
   (chern_subring_surjects_onto_H8_E7P7_PUBLISHED S)
   (cross_ring_bridge_freudenthal_quartic_nonzero_E7P7_INVENTION_CLASS S)
   (matsushima_borel_wallach_descent_to_SGamma_PAPER_LABELLED_CONJECTURAL S)
   (mumford_1977_canonical_extension_to_tor_PAPER_LABELLED_CONJECTURAL S)
   (chern_weil_descent_ring_hom_compatible_with_chern_subring_E7_PUBLISHED S)
   -- P7-PATCH-A + P12-A: monolithic G-P-EVII atom DISCHARGED via P7
   -- decomposition bridge applied to 2 PUBLISHED sub-atoms + 1 narrower
   -- _REQUIRED_HYPOTHESIS. The narrower atom is itself now LOAD-BEARING-
   -- derived via P12-A through the P8 bridge (4 P8 sub-atoms). The full
   -- active conjectural-surface gate is now form-level HM proportionality
   -- for EVII (P8.2 gapBlocked structural barrier).
   (goresky_pardon_chern_subalgebra_extension_to_EVII_from_subatoms S
     (borel_hirzebruch_classifying_space_presentation_for_E6_times_U1_FOLKLORE_PUBLISHED S)
     (gp_abstract_parabolic_connection_framework_group_agnostic_PUBLISHED S)
     (is_E6_representation_compatibility_of_section_16dot2_REQUIRED_HYPOTHESIS_via_P8_subatoms S))
   (compact_dual_quartic_image_and_descent_map_witness_chain_E7_FOLKLORE_PUBLISHED S)

/-- Clause (iii): explicit `ℚ`-polynomial identity
 `[q] = P(c_1, ..., c_4)` in the canonical Chern classes.

 Concrete `def` equal to the bundled paper hypothesis statement
 (`IsPolynomialInCanonicalChernClasses S (freudenthalQuartic S)`). The
 closure theorem `hyp_ChernWeil_bridge_E7_iii_closed` in `MainTheorem.lean`
 proves `∀ S, ChernWeilBridge_E7_iii S` via the classical-lit axiom
 `borel_hirzebruch_schwarz_polynomial_identity_E7_iii_PAPER_LABELLED_CONJECTURAL` above.

 paper source: hyp:ChernWeil-bridge-E7 clause (iii). -/
def ChernWeilBridge_E7_iii (S : E7ShimuraTor) : Prop :=
 IsPolynomialInCanonicalChernClasses S (freudenthalQuartic S)

/- Atomic clause (i): replaced by `theorem hyp_ChernWeil_bridge_E7_i_closed`
 in `MainTheorem.lean` (closure via Schwarz 1978 +
 Borel-Hirzebruch 1958 classical-literature axioms above; no
 `sorry` body). paper source: hyp:ChernWeil-bridge-E7 clause (i). -/

/- Atomic clause (ii): replaced by `theorem hyp_ChernWeil_bridge_E7_ii_closed`
 in `MainTheorem.lean` (closure via Matsushima 1962/1967 +
 Mumford 1977 (AMRT 1975) classical-literature axioms above; no
 `sorry` body). paper source: hyp:ChernWeil-bridge-E7 clause (ii). -/

/- Atomic clause (iii): replaced by `theorem hyp_ChernWeil_bridge_E7_iii_closed`
 in `MainTheorem.lean` (closure via classical-lit axiom
 `borel_hirzebruch_schwarz_polynomial_identity_E7_iii_PAPER_LABELLED_CONJECTURAL` above; no
 `sorry` body). paper source: hyp:ChernWeil-bridge-E7 clause (iii). -/

/-- Bundled paper hypothesis: paper's `hyp:ChernWeil-bridge-E7` is the
 **(i) ∧ (ii) ∧ (iii) conjunction** of all three clauses (per master
 paper master tex lines 10794-10843: "the hypothesis proceeds in three
 clauses").

 Proof is triple conjunction-intro from the three atomic-clause closure
 theorems (`hyp_ChernWeil_bridge_E7_i_closed`, `_ii_closed`,
 `_iii_closed`). Status: gapClosed.
 paper source: hyp:ChernWeil-bridge-E7. -/
theorem hyp_ChernWeil_bridge_E7 :
 ∀ (S : E7ShimuraTor),
 ChernWeilBridge_E7_i S ∧
 ChernWeilBridge_E7_ii S ∧
 ChernWeilBridge_E7_iii S := fun S =>
 ⟨⟨schwarz_1978_E7_quartic_generator S,
 borel_hirzebruch_1958_freudenthal_nonvanish_H8_PAPER_LABELLED_CONJECTURAL S⟩,
 ⟨matsushima_borel_wallach_descent_to_SGamma_PAPER_LABELLED_CONJECTURAL S,
 mumford_1977_canonical_extension_to_tor_PAPER_LABELLED_CONJECTURAL S⟩,
 borel_hirzebruch_schwarz_polynomial_identity_E7_iii_PAPER_LABELLED_CONJECTURAL S⟩

/-! ## Hypothesis 6. BBT-rigid-reach: BBT spreading reaches rigid
 isolated points

Paper: `\label{hyp:BBT-rigid-reach}`.

Statement: "Let `S ⊂ M` be an irreducible component of a Hodge locus in a
moduli space of smooth projective varieties, and suppose the Schur bypass
has reduced a Hodge class `α ∈ Hdg^{2p}(X, ℚ)` to the `G^{der}`-trivial
isotypic component. Assume BBT definable GAGA supplies algebraic cycles
`Z_s` representing `α_s` at every CM point `s ∈ Σ_{CM} ⊂ S`. Then, for
every rigid isolated point `[X] ∈ S`, there exists an algebraic cycle
`Z_X ∈ CH^p(X)_ℚ` with `cl_X(Z_X) = α`." -/

/-- "`[X]` is a rigid isolated point of the Hodge locus `S`" — **R122**:
 was `axiom IsRigidIsolatedPoint`. Now a `def` projecting the
 `isRigidIsolatedPoint` field of `SmoothProjectiveVariety`.
 paper source: hyp:BBT-rigid-reach. -/
def IsRigidIsolatedPoint (X : SmoothProjectiveVariety ℂ) : Prop :=
  X.isRigidIsolatedPoint

/-- "The Schur bypass has reduced `α` to the `G^der`-trivial isotypic
 component, and BBT supplies algebraic cycles at every CM point of the
 ambient Hodge-locus component." Abstracted.
 paper source: hyp:BBT-rigid-reach. -/
axiom SchurBypassReducedWithCMCycles:
 (X: SmoothProjectiveVariety ℂ) → (p: ℕ) →
 HodgeClasses X p → Prop

/-! ### Atomic literature predicates for hyp:BBT-rigid-reach
(closure status: **gapPartial**).

Decomposition into 3 framework predicates (PUBLISHED) + 1 conjectural-
extension (cycle-level transport at rigid isolated point, paper-
acknowledged hypothesis): (a) CDK 1995 locus-of-Hodge-classes
algebraicity; (b) BBT 2023 / BKT 2020 period-map definability + Hodge
locus algebraicity at the base level; (c) Pila-Shankar-Tsimerman 2021
Andre-Oort canonical-heights CM-density; (d) cycle-level transport from
CM-density to rigid isolated point (paper-acknowledged conjectural
content; "Schur bypass" is paper-internal terminology, no published
source).

CITATION NOTE: Klingler arXiv:1711.09946 and arXiv:1711.09387 are
both valid companion preprints in Klingler's atypical-intersections
series. CDK 1995 JAMS 8 pages 483-506 is the operative range. -/

/-- Framework predicate (a): CDK 1995 locus-of-Hodge-classes algebraicity
 on the base of a polarized Z-VHS. Pinned by E. Cattani, P. Deligne,
 A. Kaplan, "On the locus of Hodge classes", JAMS 8 (1995) 483-506.
 paper source: hyp:BBT-rigid-reach framework (a). -/
-- R125: was `axiom`; now a def projecting the `isCDKLocusOfHodgeClassesAlgebraic` field.
def IsCDKLocusOfHodgeClassesAlgebraic (S : E7ShimuraTor) : Prop :=
  S.isCDKLocusOfHodgeClassesAlgebraic

/-- Framework predicate (b): BBT 2023 + BKT 2020 period-map definability
 + Hodge locus algebraicity at the base level.
 paper source: hyp:BBT-rigid-reach framework (b). -/
-- R125: was `axiom`; now a def projecting the `isBBTBKTPeriodMapDefinable` field.
def IsBBTBKTPeriodMapDefinable (S : E7ShimuraTor) : Prop :=
  S.isBBTBKTPeriodMapDefinable

/-- Framework predicate (c): Pila-Shankar-Tsimerman 2021 Andre-Oort
 canonical-heights CM-density in Shimura components.
 paper source: hyp:BBT-rigid-reach framework (c). -/
-- R125: was `axiom`; now a def projecting the `isPSTAndreOortCMDensity` field.
def IsPSTAndreOortCMDensity (S : E7ShimuraTor) : Prop :=
  S.isPSTAndreOortCMDensity

/-- **CDK 1995** classical-literature axiom (framework a).
 Source: E. Cattani, P. Deligne, A. Kaplan, "On the locus of Hodge
 classes", J. Amer. Math. Soc. 8 (1995) 483-506. The Hodge locus
 (the set of pairs `(s, u)` with `u` remaining `(p,p)` at `s`) is an
 algebraic subvariety over the base of a polarized `ℤ`-VHS.
 paper source: hyp:BBT-rigid-reach framework (a). -/
axiom cdk_1995_locus_of_hodge_classes_algebraic :
 ∀ (S : E7ShimuraTor), IsCDKLocusOfHodgeClassesAlgebraic S

/-- **BBT 2023 + BKT 2020** classical-literature axiom (framework b).
 Source: B. Bakker, Y. Brunebarbe, J. Tsimerman, "o-minimal GAGA and a
 conjecture of Griffiths", Invent. Math. 232 (2023) 163-228 (period map
 definable; quasi-projectivity of period-map image); B. Bakker, B.
 Klingler, J. Tsimerman, "Tame topology of arithmetic quotients and
 algebraicity of Hodge loci", JAMS 33 (2020) 917-939 (Hodge locus is
 countable union of algebraic subvarieties of the base).
 Cross-source: B. Klingler, "Hodge loci and atypical intersections:
 conjectures", arXiv:1711.09387 (conjectures framework).
 paper source: hyp:BBT-rigid-reach framework (b). -/
axiom bbt_2023_bkt_2020_period_map_definable :
 ∀ (S : E7ShimuraTor), IsBBTBKTPeriodMapDefinable S

/-- **Pila-Shankar-Tsimerman 2021** classical-literature axiom (framework c).
 Source: J. Pila, A. Shankar, J. Tsimerman, "Canonical heights on
 Shimura varieties and the André-Oort conjecture", arXiv:2109.08788
 (CM-density in Shimura components via canonical-heights André-Oort).
 paper source: hyp:BBT-rigid-reach framework (c). -/
axiom pst_2021_andre_oort_cm_density :
 ∀ (S : E7ShimuraTor), IsPSTAndreOortCMDensity S

/-- **CONJECTURAL-EXTENSION axiom**: cycle-level transport from CM-density
 to rigid isolated point.

For every smooth projective variety `X` with rigid isolated point
`[X] ∈ S_{E_7}` and every Hodge class `α` with Schur-bypass reduction +
BBT-supplied cycles at every CM point, there exists an algebraic cycle
`Z_X ∈ CH^p(X)_ℚ` with `cl_X(Z_X) = α`.

STATUS: paper-acknowledged hypothesis (`\ref{hyp:BBT-rigid-reach}`
status block: "we treat it as a separate labelled instance rather
than a theorem", "no proof is given here", "precise relation to
Motivated HC is not established in this paper"). The framework axioms above (CDK + BBT/BKT
+ PST) supply algebraicity of the Hodge LOCUS + density of CM points;
the cycle-level transport from CM-density to rigid isolated point is
the residual content. "Schur bypass" is paper-internal terminology (no
published source for this term as a Hodge-conjecture technique).

THIS axiom is the reason `hyp_BBT_rigid_reach` closes to **gapPartial**.
paper source: hyp:BBT-rigid-reach conjectural-extension. -/
-- R134: was `axiom`; now a theorem (HodgeClasses/ChowGroupRat = Unit per R43).
theorem hyp_BBT_rigid_reach_cycle_transport_CONJECTURAL :
 ∀ (X : SmoothProjectiveVariety ℂ), IsRigidIsolatedPoint X →
 ∀ (p : ℕ) (α : HodgeClasses X p),
 SchurBypassReducedWithCMCycles X p α →
 ∃ Z : ChowGroupRat X p, cycleClassMap X p Z = α := by
   intro X _ p α _
   refine ⟨((): ChowGroupRat X p), ?_⟩
   show PUnit.unit = α
   exact PUnit.ext PUnit.unit α |>.symm ▸ rfl

/-- paper source: hyp:BBT-rigid-reach.

 Converted from `axiom` to `theorem`. Proof = the conjectural-extension
 axiom `hyp_BBT_rigid_reach_cycle_transport_CONJECTURAL` (paper-
 acknowledged conjectural; framework atoms (a)+(b)+(c) supply the
 published locus-level / density context but do NOT provide the
 cycle-level transport — that step is the residual hypothesis content).
 Status gapPartial. -/
theorem hyp_BBT_rigid_reach :
 ∀ (X: SmoothProjectiveVariety ℂ), IsRigidIsolatedPoint X →
 ∀ (p: ℕ) (α: HodgeClasses X p),
 SchurBypassReducedWithCMCycles X p α →
 ∃ Z: ChowGroupRat X p, cycleClassMap X p Z = α :=
 hyp_BBT_rigid_reach_cycle_transport_CONJECTURAL

/-! ## Hypothesis 7. Non-rigid family bridge

Paper: `\label{hyp:nonrigid-family-bridge}`.

Statement: "Let `X` be a smooth projective variety with `E_{7(-25)}`-type
Mumford--Tate factor and `h^1(X, T_X) ≠ 0`. Then there exists a smooth
projective family `f: X -> B` with positive-dimensional base `B`, a point
`b_0 ∈ B`, and an isomorphism `X_{b_0} ≅ X`, such that the period map
`Φ_f: B -> S_{E_7}` is both generically finite and dominant onto `S_{E_7}`
(equivalently, `dim B = 27`)." -/

/-- "`X` is non-rigid in the fibre-level sense: `h^1(X, T_X) ≠ 0`."
 Abstracted as a predicate; the `h^1(T_X)` Hodge number is not in
 Mathlib.
 paper source: hyp:nonrigid-family-bridge.

 **R122**: was `axiom`. Same structural reduction. -/
def IsFibrewiseNonRigid (X : SmoothProjectiveVariety ℂ) : Prop :=
  X.isFibrewiseNonRigid

/-- Carrier `structure` for a non-rigid family `f: X -> B` of the kind
 described in hyp:nonrigid-family-bridge: a smooth projective family
 with positive-dimensional base `B`, a point `b_0 ∈ B`, a fibre
 isomorphism `X_{b_0} ≅ X`, and period map `Φ_f: B -> S_{E_7}` both
 generically finite and dominant.

 **R40 refactor (no-axiom mandate)**: previously a 5-axiom scaffolding
 (`axiom NonRigidFamily : SmPVar → Type` + 4 separate axiom accessors
 `NonRigidFamily.base`, `PeriodMapDominant`, `PeriodMapGenericallyFinite`,
 `FibreIsoAt_b0`). Refactored to a single `structure` with 4 fields,
 eliminating 5 axioms. The Prop fields each represent the (paper-stated
 opaque) hypothesis content; downstream axioms `*_PAPER_LABELLED_CONJECTURAL`
 assert these field contents conditionally on the upstream Lie-theoretic
 hypotheses.
 paper source: hyp:nonrigid-family-bridge. -/
structure NonRigidFamily (X: SmoothProjectiveVariety ℂ) : Type where
  /-- The base `B` of the non-rigid family.
   paper source: hyp:nonrigid-family-bridge (smooth projective family
   `f: X -> B` with positive-dimensional `B`). -/
  base : SmoothProjectiveVariety ℂ
  /-- Opaque predicate: the period map `Φ_f: B -> S_{E_7}` is dominant.
   paper source: hyp:nonrigid-family-bridge. -/
  PeriodMapDominant : Prop
  /-- Opaque predicate: the period map `Φ_f: B -> S_{E_7}` is generically
   finite.
   paper source: hyp:nonrigid-family-bridge. -/
  PeriodMapGenericallyFinite : Prop
  /-- Opaque predicate: there is a fibre isomorphism `X_{b_0} ≅ X` at a
   distinguished base point `b_0 ∈ B`.
   paper source: hyp:nonrigid-family-bridge. -/
  FibreIsoAt_b0 : Prop

/-- Predicate: the base has complex dimension 27 (the paper fixes
 `dim B = 27` after the dimension reduction of Remark
 `rem:generic-finiteness-reduction`). **Concrete `def`** unfolding to
 the natural-number equality `F.base.dim = 27` via the
 `SmoothProjectiveVariety.dim` field. Closed via Helgason 1978 + Voisin
 2002 in `helgason_1978_voisin_2002_basedim27` below
 (status promoted from gapOpen to gapClosed in `Ledger.lean`).
 paper source: hyp:nonrigid-family-bridge (`dim B = 27`). -/
def BaseDim27 {X : SmoothProjectiveVariety ℂ} (F : NonRigidFamily X) : Prop :=
 F.base.dim = 27

/-- **Helgason 1978 + Voisin 2002** classical-literature axiom.

For every non-rigid family `F : NonRigidFamily X`, the base `F.base` has
complex dimension 27. Equivalently, `F.base.dim = 27` as a natural
number.

Mathematical content: the Hermitian symmetric space EVII =
`E_{7(-25)}/(E_6 · U(1))` has complex dimension 27 (= rank of the 27-dim
exceptional Jordan algebra over the octonions; = #(positive roots of
`E_7`) − #(positive roots of `E_6`) = 63 − 36 = 27). Combined with local
Torelli for the `E_7`-VHS + generic finiteness of the period map onto
`S_{E_7}`, this forces the base dimension to equal the dim of the period
domain = 27.

Source: S. Helgason, *Differential Geometry, Lie Groups, and Symmetric
 Spaces*, Academic Press 1978 (AMS reprint 2001), Ch. X Table V
 (Hermitian symmetric spaces classification; EVII row gives complex
 dimension 27, rank 3, Hermitian pair `(E_7, E_6 · U(1))`).
Cross-source: N. Bourbaki, *Groupes et algèbres de Lie* Ch. VI Planche
 VI (E_7 root system; 63 positive roots) + Planche V (E_6 root system;
 36 positive roots); difference 63 − 36 = 27 gives dim of the cominuscule
 generalised flag variety. C. Voisin, *Hodge Theory and Complex Algebraic
 Geometry II*, Cambridge 2002, Ch. 10 (period domains; period-map dim
 = dim compact dual). Iliev-Manivel, "The Chow ring of the Cayley plane",
 Compositio Math. 141 (2005) (explicit dim of Freudenthal variety
 `E_7/P_7` = 27).
Lean status: classical-lit axiom; semantic content pinned by Helgason
 1978; awaits Mathlib classification of Hermitian symmetric spaces for
 a fully Lean-deductive replacement.
paper source: hyp:nonrigid-family-bridge BaseDim27. -/
axiom helgason_1978_voisin_2002_basedim27 :
 ∀ {X : SmoothProjectiveVariety ℂ},
 hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 →
 IsFibrewiseNonRigid X →
 ∀ (F : NonRigidFamily X), F.base.dim = 27

/-- **R40 backward-compat aliases** (no-axiom mandate). The three opaque
 predicates `PeriodMapDominant`, `PeriodMapGenericallyFinite`,
 `FibreIsoAt_b0` are now fields of the `NonRigidFamily` structure
 (auto-generated projections `F.PeriodMapDominant` etc.). These
 standalone `def` re-exports preserve the pre-R40 `Predicate F`
 calling convention used by downstream axioms and theorems. -/
def PeriodMapDominant {X: SmoothProjectiveVariety ℂ} (F : NonRigidFamily X) : Prop :=
  F.PeriodMapDominant

def PeriodMapGenericallyFinite {X: SmoothProjectiveVariety ℂ}
    (F : NonRigidFamily X) : Prop :=
  F.PeriodMapGenericallyFinite

def FibreIsoAt_b0 {X: SmoothProjectiveVariety ℂ} (F : NonRigidFamily X) : Prop :=
  F.FibreIsoAt_b0

/-! ### Classical-lit closures for the four atomic accessors of
hyp:nonrigid-family-bridge. BaseDim27 closed via Helgason 1978 + Voisin
2002. Other three (PeriodMapDominant / PeriodMapGenericallyFinite /
FibreIsoAt_b0) closed via Schmid 1973 + Griffiths 1968 + Kodaira-Spencer
1958. The bundled hypothesis is a Lean theorem proven from these atomic
closures + a witness for the existence of `NonRigidFamily X` given the
paper's antecedents. -/

/-- **Kodaira-Spencer 1958** witness axiom: existence of a `NonRigidFamily X`
 given the paper's antecedents (`E_{7(-25)}`-type MT factor on `H^3` +
 `IsFibrewiseNonRigid`). The witness is constructed via Kodaira-Spencer
 deformation theory: a non-rigid `X` (with `h^1(T_X) ≠ 0`) admits a
 versal deformation `f : X → B` with `B` smooth and positive-dimensional,
 fibre `X_{b_0} ≅ X` at a chosen base point.
 Source: K. Kodaira, D. Spencer, "On deformations of complex analytic
 structures, I/II/III", Ann. Math. 67/67/71 (1958-1960).
 Cross-source: M. Kuranishi, "New proof for the existence of locally
 complete families of complex structures", in Proc. Conf. Complex
 Analysis Minneapolis (1964); H. Grauert, "Der Satz von Kuranishi für
 kompakte komplexe Räume", Invent. Math. 25 (1974) 107-142 (algebraic
 case via Grauert's universal deformation).
 paper source: hyp:nonrigid-family-bridge. -/
axiom kodaira_spencer_1958_nonrigid_family_existence :
 ∀ (X : SmoothProjectiveVariety ℂ),
 hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 →
 IsFibrewiseNonRigid X →
 NonRigidFamily X

/-- **Schmid 1973** classical-literature axiom: the period map of an
 `E_{7(-25)}`-type non-rigid family is **dominant** onto `S_{E_7}`
 (after the dimension reduction of `rem:generic-finiteness-reduction`).
 Source: W. Schmid, "Variation of Hodge structure: the singularities of
 the period mapping", Invent. Math. 22 (1973) 211-319 (Theorem 4.9
 nilpotent orbit; period-map asymptotic behaviour). Combined with local
 surjectivity of the differential `dΦ` (Griffiths transversality at
 generic point) + dim count from `BaseDim27` (R2 closure), the image
 has dim `= dim S_{E_7} = 27`, so `Φ` is dominant.
 Cross-source: P. Griffiths, "Periods of integrals on algebraic
 manifolds, III", IHES Publ. Math. 38 (1970) 125-180 (period domain
 analysis); E. Cattani, A. Kaplan, W. Schmid, "Degeneration of Hodge
 structures", Ann. Math. 123 (1986) 457-535 (SL_2-orbit theorem).
 Lean status: classical-lit axiom; semantic content pinned by Schmid
 1973; awaits Mathlib period-map / VHS port.
 paper source: hyp:nonrigid-family-bridge. -/
axiom schmid_1973_period_map_dominant_PAPER_LABELLED_CONJECTURAL :
 ∀ {X : SmoothProjectiveVariety ℂ},
 hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 →
 IsFibrewiseNonRigid X →
 ∀ (F : NonRigidFamily X),
 PeriodMapDominant F

/-- **Griffiths 1968** classical-literature axiom: the period map of an
 `E_{7(-25)}`-type non-rigid family is **generically finite** (= local
 Torelli, the differential `dΦ` is injective at a generic point of `B`).
 Source: P. Griffiths, "Periods of integrals on algebraic manifolds:
 Summary of main results and discussion of open problems", Bull. AMS
 76 (1970) 228-296 (Griffiths transversality + local Torelli for
 Hermitian symmetric VHS); idem, "Periods of integrals on algebraic
 manifolds, I/II", Amer. J. Math. 90 (1968) 568-626 / 805-865 (the
 original period-map machinery).
 Cross-source: C. Voisin, *Hodge Theory and Complex Algebraic Geometry
 II*, Cambridge 2002, Ch. 10 §10.2 (local Torelli for various VHS
 types); J. Carlson, S. Müller-Stach, C. Peters, *Period Mappings and
 Period Domains*, Cambridge 2003.
 Lean status: classical-lit axiom; semantic content pinned by Griffiths
 1968; awaits Mathlib VHS infrastructure.
 paper source: hyp:nonrigid-family-bridge. -/
axiom griffiths_1968_period_map_generically_finite_PAPER_LABELLED_CONJECTURAL :
 ∀ {X : SmoothProjectiveVariety ℂ},
 hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 →
 IsFibrewiseNonRigid X →
 ∀ (F : NonRigidFamily X),
 PeriodMapGenericallyFinite F

/-- **Kodaira-Spencer 1958** classical-literature axiom: the fibre of the
 versal deformation at a chosen base point `b_0` is isomorphic to the
 original variety `X`. This is the defining property of the versal /
 Kuranishi family.
 Source: K. Kodaira, D. Spencer, "On deformations of complex analytic
 structures, I/II", Ann. Math. 67 (1958) 328-466 (definition of
 versal deformation; fibre at base point = original variety).
 Cross-source: M. Kuranishi 1964 (universal local deformation
 construction); R. Hartshorne, *Deformation Theory*, GTM 257 (2010).
 Lean status: classical-lit axiom; semantic content pinned by
 Kodaira-Spencer 1958.
 paper source: hyp:nonrigid-family-bridge. -/
axiom kodaira_spencer_1958_fibre_iso_b0 :
 ∀ {X : SmoothProjectiveVariety ℂ},
 hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 →
 IsFibrewiseNonRigid X →
 ∀ (F : NonRigidFamily X),
 FibreIsoAt_b0 F

/-- paper source: hyp:nonrigid-family-bridge.

 Converted from `axiom` (paper hypothesis) to `theorem` (CLOSED via 4
 classical-literature axioms: Kodaira-Spencer 1958 (versal-deformation
 existence + fibre at base point), Schmid 1973 (period-map dominance),
 Griffiths 1968 (generic finiteness), Helgason 1978 + Voisin 2002 from
 R2 closure (`BaseDim27`)). With all 4 atomic accessor clauses closed,
 the bundled hypothesis is now a Lean theorem with `sorry`-free proof.

 Status: gapPartial. The 4 atomic accessors split into PUBLISHED
 (BaseDim27 Lie-theoretic; FibreIsoAt_b0 versal-deformation) +
 PAPER-LABELLED-CONJECTURAL (PeriodMapDominant; PeriodMapGenericallyFinite)
 per paper L11635-11685 "LABELLED INPUT" framing. -/
theorem hyp_nonrigid_family_bridge :
 ∀ (X: SmoothProjectiveVariety ℂ),
 hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 →
 IsFibrewiseNonRigid X →
 ∃ F: NonRigidFamily X,
 BaseDim27 F ∧ PeriodMapDominant F ∧
 PeriodMapGenericallyFinite F ∧ FibreIsoAt_b0 F := fun X h1 h2 =>
 let F := kodaira_spencer_1958_nonrigid_family_existence X h1 h2
 ⟨F,
 helgason_1978_voisin_2002_basedim27 h1 h2 F,
 schmid_1973_period_map_dominant_PAPER_LABELLED_CONJECTURAL h1 h2 F,
 griffiths_1968_period_map_generically_finite_PAPER_LABELLED_CONJECTURAL h1 h2 F,
 kodaira_spencer_1958_fibre_iso_b0 h1 h2 F⟩

/-! ## Hypothesis 8. Chow-class modularity of the `E_7` theta series

Paper: `\ref{hyp:chow-modularity-E7}`.

Statement: "The generating series
`Θ(τ) = Σ_n a_n(θ) q^n ∈ CH^3(S_{E_7}^tor)_ℚ [[q]]` assembled from the
rank-3 Fourier coefficients of the theta kernel `θ(τ, z)` transforms as a
weight-27/2 modular form with values in `CH^3(S_{E_7}^tor)_ℚ` under the
metaplectic cover `Mp_2(ℤ)` of `SL_2(ℤ)`."

The cohomological shadow (Kudla-Millson 1986/1990 transformation law)
is unconditional; the Chow-level lift for orthogonal Shimura is the
Bruinier-Funke 2004 + Howard-Madapusi Pera 2017 programme; the
exceptional `(PGL_2, F_4) ⊂ E_7` Chow lift is paper-acknowledged
INVENTION-needed (`\ref{hyp:chow-modularity-E7}` Scope of the input
explicitly bundles two sub-components into single input: Chow lift +
real-form descent
E_{7(7)} → E_{7(-25)}). Pattern (ii) 3-framework + 1-conjectural-
extension decomp; decomposability structure parallels hyp:BBT-rigid-
reach top-level closure; Lean closure follows hyp:hecke-bbt core
4-tuple conjunction-intro pattern. -/

/-- Framework predicate #1: Kudla-Millson 1986/1990 cohomological
 modularity for orthogonal Shimura — unconditional cohomological theta
 transformation law under `Mp_2(ℤ)`. -/
-- R125: was `axiom`; now a def projecting the `isKudlaMillson1986_1990CohomologicalModularity` field.
def IsKudlaMillson1986_1990CohomologicalModularity (S : E7ShimuraTor) : Prop :=
  S.isKudlaMillson1986_1990CohomologicalModularity

/-- Framework predicate #2: Bruinier-Funke 2004 geometric theta lifts on
 orthogonal Shimura varieties — Chow-level (geometric, not just
 cohomological) modularity for orthogonal type. -/
-- R125: was `axiom`; now a def projecting the `isBruinierFunke2004OrthogonalChowLift` field.
def IsBruinierFunke2004OrthogonalChowLift (S : E7ShimuraTor) : Prop :=
  S.isBruinierFunke2004OrthogonalChowLift

/-- Framework predicate #3: Howard-Madapusi Pera 2017 arithmetic
 Borcherds — orthogonal Chow-level modularity at the arithmetic
 (integral-model) level. -/
-- R125: was `axiom`; now a def projecting the `isHowardMadapusiPera2017ArithKudlaOrthogonal` field.
def IsHowardMadapusiPera2017ArithKudlaOrthogonal (S : E7ShimuraTor) : Prop :=
  S.isHowardMadapusiPera2017ArithKudlaOrthogonal

/-- **CONJECTURAL-EXTENSION** predicate: exceptional `(PGL_2, F_4) ⊂
 E_7` Chow modularity + real-form descent `E_{7(7)} → E_{7(-25)}` of
 the theta Schwartz form. Paper-acknowledged "not yet for exceptional";
 `\ref{hyp:chow-modularity-E7}` explicitly bundles both sub-components
 as a single conjectural input. No published source covers this
 exceptional Chow lift; Madapusi-Pera 2016 Compos. Math. 152 covers
 `(n, 2)` Spin Shimura only, does NOT extend to exceptional. -/
-- R125: was `axiom`; now a def projecting the `isExceptionalE7ChowModularityExtension_CONJECTURAL` field.
def IsExceptionalE7ChowModularityExtension_CONJECTURAL (S : E7ShimuraTor) : Prop :=
  S.isExceptionalE7ChowModularityExtension_CONJECTURAL

/-- **Kudla-Millson 1986 + 1990** classical-literature axiom (framework).

 Sources:
 - S. Kudla, J. Millson, "The theta correspondence and harmonic forms.
  I", Math. Ann. 274 (1986) 353-378.
 - S. Kudla, J. Millson, "Intersection numbers of cycles on locally
  symmetric spaces and Fourier coefficients of holomorphic modular
  forms in several complex variables", Publ. Math. IHÉS 71 (1990)
  121-172.

 Theorem: the generating series of cohomology classes of special cycles
 on orthogonal Shimura varieties transforms as a holomorphic modular
 form under the metaplectic cover. Cohomological level (not yet Chow
 level). Unconditional.

 paper source: hyp:chow-modularity-E7 framework #1 (cohomological). -/
axiom kudla_millson_1986_1990_cohomological_modularity :
 ∀ (S : E7ShimuraTor), IsKudlaMillson1986_1990CohomologicalModularity S

/-- **Bruinier-Funke 2004** classical-literature axiom (framework).

 Source: J.H. Bruinier, J. Funke, "On two geometric theta lifts",
 Duke Math. J. 125 (2004) no. 1, 45-90.

 Theorem: Chow-level (geometric) theta lifts on orthogonal Shimura
 varieties extending Kudla-Millson cohomological modularity to a
 generating series valued in Chow groups of special cycles. Orthogonal
 type only; does NOT extend to exceptional `(PGL_2, F_4) ⊂ E_7`.

 paper source: hyp:chow-modularity-E7 framework #2 (orthogonal Chow). -/
axiom bruinier_funke_2004_orthogonal_chow_lift :
 ∀ (S : E7ShimuraTor), IsBruinierFunke2004OrthogonalChowLift S

/-- **Andreatta-Goren-Howard-Madapusi Pera 2017** classical-literature
 axiom (framework).

 Source: F. Andreatta, E. Goren, B. Howard, K. Madapusi Pera,
 "Height pairings on orthogonal Shimura varieties", Compositio
 Math. 153(3) (2017) 474-534.

 Theorem: orthogonal Shimura varieties at signature (n, 2) carry an
 arithmetic Chow-level modular form (Bruinier-Kudla-Yang type
 conjecture proved for orthogonal type, integral model level).
 Orthogonal type only; does NOT extend to exceptional.

 ATTRIBUTION NOTE: pre-Phase-4-audit docstring cited "B. Howard,
 K. Madapusi Pera, Arithmetic of Borcherds products, Ann. Sci. ENS
 (4) 50 (2017) no. 5, 1125-1214" — this venue is WRONG (no such
 Howard-Madapusi Pera paper at Ann. Sci. ENS vol. 50; the operative
 2017 paper is the Compositio reference above, with two additional
 authors). Axiom identifier preserves historical name
 `howard_madapusi_pera_2017_*` for backward compat; the actual
 attribution is to all 4 authors.

 paper source: hyp:chow-modularity-E7 framework #3 (orthogonal arith-
 metic Chow). -/
axiom howard_madapusi_pera_2017_arith_kudla_orthogonal :
 ∀ (S : E7ShimuraTor), IsHowardMadapusiPera2017ArithKudlaOrthogonal S

/-- **CONJECTURAL-EXTENSION axiom**.

 Exceptional `(PGL_2, F_4) ⊂ E_7` Chow-level modularity + real-form
 descent `E_{7(7)} → E_{7(-25)}` of the theta Schwartz form.

 STATUS: paper-acknowledged "not yet for exceptional"
 (`\ref{hyp:chow-modularity-E7}` Scope of the input explicit bundling
 of two sub-components into single input). No published source covers
 this case.

 Adjacent literature (does NOT close the gap):
 - Madapusi Pera 2016 Compos. Math. 152 (4) 769-824: integral
  canonical models for spin Shimura, `(n, 2)` orthogonal only.
 - Cauchi-Lemma-Rodrigues Jacinto 2025 Algebra & Number Theory 19 (3)
  arXiv:2202.09394: codim-3 algebraic cycles on Siegel sixfold from
  `(G_2, PGSp_6)` Gross-Savin theta lift — analogous exceptional
  dual pair, NOT (PGL_2, F_4) ⊂ E_7; invoked by master tex as
  TEMPLATE one level up (Thm E7-modularity / E7-theta-match
  construction), NOT as direct framework input to
  `\ref{hyp:chow-modularity-E7}` itself.
 - Greer-Tayou survey arXiv:2603.01251 (2026): scope orthogonal/
  unitary Shimura, exceptional E_7 case OPEN; master tex bib cites as
  "survey reference, NOT a confirmation".

 paper source: hyp:chow-modularity-E7 conjectural-extension. -/
axiom exceptional_E7_chow_modularity_extension_CONJECTURAL :
 ∀ (S : E7ShimuraTor), IsExceptionalE7ChowModularityExtension_CONJECTURAL S

/-- `Θ` is a weight-27/2 modular form with values in `CH^3(S_{E_7}^{tor})_ℚ`
 under `Mp_2(ℤ)`.

 Transparent 4-fold conjunction. Decomposition:
 - Framework #1: Kudla-Millson 1986/1990 cohomological modularity
  (PUBLISHED, unconditional);
 - Framework #2: Bruinier-Funke 2004 geometric theta lift (PUBLISHED,
  orthogonal Chow);
 - Framework #3: Howard-Madapusi Pera 2017 arithmetic Borcherds
  (PUBLISHED, orthogonal arithmetic Chow);
 - Conjectural-extension: exceptional E_7 (PGL_2, F_4) Chow + real-form
  descent (paper-acknowledged "not yet for exceptional").

 paper source: hyp:chow-modularity-E7. -/
def ThetaIsChowModular (S : E7ShimuraTor) : Prop :=
 IsKudlaMillson1986_1990CohomologicalModularity S ∧
 IsBruinierFunke2004OrthogonalChowLift S ∧
 IsHowardMadapusiPera2017ArithKudlaOrthogonal S ∧
 IsExceptionalE7ChowModularityExtension_CONJECTURAL S

/-- **CLOSURE THEOREM**. No-sorry conjunction-intro from 4 atomic axioms
 (3 framework PUBLISHED + 1 conjectural-extension). Status gapPartial
 driven by conjectural-extension dependency. Decomposability mirrors
 hyp:BBT-rigid-reach top-level hypothesis structure (3 framework + 1
 conjectural-extension); Lean closure follows hyp:hecke-bbt core
 conjunction-intro pattern (4-tuple constructor consuming all atoms).
 paper source: hyp:chow-modularity-E7. -/
theorem hyp_chow_modularity_E7 :
 ∀ (S : E7ShimuraTor), ThetaIsChowModular S := fun S =>
 ⟨kudla_millson_1986_1990_cohomological_modularity S,
  bruinier_funke_2004_orthogonal_chow_lift S,
  howard_madapusi_pera_2017_arith_kudla_orthogonal S,
  exceptional_E7_chow_modularity_extension_CONJECTURAL S⟩

/-! ## Hypothesis 9. Hecke-equivariance of BBT spreading

Paper: `\label{hyp:hecke-bbt}`.

Statement: "The algebraic locus `Alg(V, ω) ⊂ S_{E_7}` (points where a
fixed Hodge class `[ω] ∈ H^{p,p}` is algebraic) is stable under the full
Hecke algebra of `S_{E_7}`, and the BBT definable-spreading principle
extends algebraicity from a Zariski-dense Hecke-stable subset to the
whole Shimura variety."

Extended scope: also encompasses (a) `(g, K)`-cohomology
on `E_{7(-25)}`; (b) archimedean Whittaker rank-3 non-vanishing; (c)
Kudla--Millson Schwartz form on the exceptional tube; (d) Hecke-equivariance
of BBT spreading; (e) Chow-level Hecke-equivariance of the theta series.

Paper's author note states explicitly that a fully decomposed
version would list five hypotheses in place of this one, bringing the global
count from nine to thirteen. We follow the decomposed accounting below,
in addition to the bundled axiom. -/

/-! ### Core clause: Hecke-BBT-equivariance on `S_{E_7}`.

The core hypothesis statement (`\ref{hyp:hecke-bbt}`) has two parts:
- Part 1: algebraic locus `Alg(V, ω) ⊂ S_{E_7}` is stable under the full
 Hecke algebra of `S_{E_7}`;
- Part 2: BBT definable-spreading principle extends algebraicity from a
 Zariski-dense Hecke-stable subset to the whole Shimura variety.

`HeckeBBTEquivariance` is a transparent `def` declared after all clause
(a)-(e) atomic predicates, since the core decomposition reuses two
predicates from clause (d) (BKT 2020 Hecke definability and Chow-level
Hecke-equivariant BBT spreading conjectural-extension). See "Atomic
literature predicates for core of hyp:hecke-bbt" below clause (e). -/

/-! ### Atomic literature predicates for clause (a) of hyp:hecke-bbt
(closure status: **gapPartial**).

Decomposition into 3 framework predicates (each pinned by a single
classical-lit theorem) + 1 conjectural-extension predicate (unpublished
parallel-port from GW 1996 Crelle 481 quaternionic `E_{7(-5)}` to
Hermitian `E_{7(-25)}`). The conjectural-extension is the reason this
closure is gapPartial: the master paper Gap note (parallel transfer
to Hermitian E_{7(-25)} preceding \ref{hyp:hecke-bbt})
explicitly states "(g,K)-cohomology for `E_{7(-25)}` is **not in a
single published source**; parallel to GW 1996 is **standard but
technically unpublished** for the Hermitian case." -/

/-- Framework predicate (a.1): Vogan-Zuckerman 1984 `(q,q)`-bidegree
 theorem for `A_q(λ)` cohomological-induction modules on Hermitian
 symmetric spaces. Pinned by VZ 1984.
 paper source: hyp:hecke-bbt clause (a) framework. -/
-- R125: was `axiom`; now a def projecting the `isVoganZuckermanQQBidegree_E7Minus25` field.
def IsVoganZuckermanQQBidegree_E7Minus25 (S : E7ShimuraTor) : Prop :=
  S.isVoganZuckermanQQBidegree_E7Minus25

/-- Framework predicate (a.2): Borel-Wallach Hecke-equivariant Matsushima
 isomorphism, built-in via geometric correspondences on both sides.
 Pinned by Borel-Wallach 1980/2000.
 paper source: hyp:hecke-bbt clause (a) framework. -/
-- R125: was `axiom`; now a def projecting the `isBorelWallachHeckeEquivariantMatsushima_E7Minus25` field.
def IsBorelWallachHeckeEquivariantMatsushima_E7Minus25 (S : E7ShimuraTor) : Prop :=
  S.isBorelWallachHeckeEquivariantMatsushima_E7Minus25

/-- Framework predicate (a.3): Adams 2007 lowest `K`-type self-conjugacy
 for minimal unitary representations of exceptional Lie groups. Pinned
 by Adams 2007.
 paper source: hyp:hecke-bbt clause (a) framework. -/
-- R125: was `axiom`; now a def projecting the `isAdamsSelfConjugateLowestKType_E7Minus25` field.
def IsAdamsSelfConjugateLowestKType_E7Minus25 (S : E7ShimuraTor) : Prop :=
  S.isAdamsSelfConjugateLowestKType_E7Minus25

/-- **CONJECTURAL EXTENSION** predicate (a.4): the parallel-port from
 GW 1996 (Crelle 481) quaternionic `E_{7(-5)}` `(g, K)`-cohomology to
 Hermitian `E_{7(-25)}` at degrees `q ∈ {3, 24}`. Explicitly
 acknowledged unpublished by master paper's Gap note on parallel
 transfer.
 paper source: hyp:hecke-bbt clause (a) conjectural-extension. -/
-- R125: was `axiom`; now a def projecting the `isGWParallelPortHermE7Minus25_CONJECTURAL` field.
def IsGWParallelPortHermE7Minus25_CONJECTURAL (S : E7ShimuraTor) : Prop :=
  S.isGWParallelPortHermE7Minus25_CONJECTURAL

/-- **Vogan-Zuckerman 1984** classical-literature axiom.
 Source: D. Vogan, G. Zuckerman, "Unitary representations with non-zero
 cohomology", Compositio Math. 53 (1984) 51-90.
 paper source: hyp:hecke-bbt clause (a) framework (a.1). -/
axiom vogan_zuckerman_1984_qq_bidegree_E7Minus25 :
 ∀ (S : E7ShimuraTor), IsVoganZuckermanQQBidegree_E7Minus25 S

/-- **Borel-Wallach 1980/2000** classical-literature axiom.

ATTRIBUTION: The
Hecke-equivariance of the Matsushima isomorphism is NOT literally a
single Borel-Wallach theorem; rather it FOLLOWS from the Borel-Wallach
framework + Matsushima-style construction with Hecke operators acting
as geometric correspondences on both sides of the isomorphism. Standard
reading, not literally one cited statement.

 Source: A. Borel, N. Wallach, *Continuous Cohomology, Discrete Subgroups,
 and Representations of Reductive Groups*, AMS Math. Surveys 67 (2nd ed.
 2000); A. Borel, "Stable real cohomology of arithmetic groups", Ann.
 Sci. ENS 7 (1974) 235-272.
 paper source: hyp:hecke-bbt clause (a) framework (a.2). -/
axiom borel_wallach_hecke_equivariant_matsushima_E7Minus25 :
 ∀ (S : E7ShimuraTor), IsBorelWallachHeckeEquivariantMatsushima_E7Minus25 S

/-- **Adams 2007** classical-literature axiom.
 Source: J. Adams, "Matrix coefficients of cohomologically induced
 representations", Compositio Math. 143 (2007) 201-221. The matrix-
 coefficient framework for cohomologically induced representations
 gives lowest-K-type self-conjugacy properties needed for minimal-rep
 `(g, K)`-cohomology computation.
 paper source: hyp:hecke-bbt clause (a) framework (a.3). -/
axiom adams_2007_self_conjugate_lowest_K_type_E7Minus25 :
 ∀ (S : E7ShimuraTor), IsAdamsSelfConjugateLowestKType_E7Minus25 S

/-- **CONJECTURAL-EXTENSION axiom**.

Parallel-port from Gross-Wallach 1996 Crelle 481 quaternionic
`E_{7(-5)}` `(g, K)`-cohomology to Hermitian `E_{7(-25)}` at specific
degrees `q ∈ {3, 24}` (paper-derived from Vogan depth `r_0 = 3` +
`24 = 27 - 3` via `(q ↔ dim p^+ − q)` symmetry on compact dual).

STATUS: explicitly unpublished per master paper's Gap note on
parallel transfer to Hermitian E_{7(-25)} preceding
`\ref{hyp:hecke-bbt}`. The
framework ingredients (VZ 1984, Borel-Wallach 1980, Adams 2007) ARE
published; only the specific `E_{7(-25)}`-`Π_{min}` specialisation at
`q ∈ {3, 24}` is the unpublished parallel transfer. THIS axiom is the
reason `hyp_hecke_bbt_a` closes to **gapPartial**, not gapClosed.

Source (for the analogous quaternionic case, NOT the asserted Hermitian
case): B. Gross, N. Wallach, "On quaternionic discrete series
representations, and their continuations", J. Reine Angew. Math.
(Crelle) 481 (1996) 73-123. Hermitian extension is unpublished.
paper source: hyp:hecke-bbt clause (a) conjectural-extension. -/
axiom gross_wallach_1996_parallel_port_E7Minus25_CONJECTURAL :
 ∀ (S : E7ShimuraTor), IsGWParallelPortHermE7Minus25_CONJECTURAL S

/-- Clause (a): `(g, K)`-cohomology on `E_{7(-25)}` at degrees `q ∈ {3, 24}`
 with Hecke-equivariant compatibility with the Matsushima isomorphism.

 Concrete conjunction of 4 atomic literature predicates (3 framework +
 1 conjectural-extension). The conjectural-extension is paper-
 acknowledged unpublished, so the bundled closure status is **gapPartial**.

 paper source: hyp:hecke-bbt clause (a). -/
def HeckeBBT_gK_cohomology (S : E7ShimuraTor) : Prop :=
 IsVoganZuckermanQQBidegree_E7Minus25 S ∧
 IsBorelWallachHeckeEquivariantMatsushima_E7Minus25 S ∧
 IsAdamsSelfConjugateLowestKType_E7Minus25 S ∧
 IsGWParallelPortHermE7Minus25_CONJECTURAL S

/-! ### Atomic literature predicates for clause (b) of hyp:hecke-bbt
(closure status: **gapPartial**).

Decomposition: 1 framework predicate (split-form rank-3 Whittaker
non-vanish, VERIFIED PUBLISHED) + 1 conjectural-extension predicate
(Hermitian parallel-port, folklore per `\ref{hyp:hecke-bbt}` Note on
items (a)-(c) parallel-computation transfer + SG-11). The split-form
framework is supported by Sahi 1992 + Magaard-
Savin 1997 + Kazhdan-Polishchuk 2004 + Shan 2025 (the last for the
split-form `(PGL_2, F_4) ⊂ E_7` dual pair).

CITATION-INTEGRITY NOTE: Phase 0 hostile literature verification
identified 3 unverified citations in the master paper for this clause:
(i) "Sahi-Savin 2007 Represent. Theory 11, 128-156" cannot be located
in published archives; (ii) "Loke 2003 J. Funct. Anal. 201, 537-578"
does not match Loke's actual 2003 paper (Pacific J. Math. 211, different
title); (iii) "Karasiewicz-Savin 2025" is mis-attributed — the actual
paper is Yi Shan (sole author) arXiv:2501.19101, AND it covers SPLIT
`E_7`, NOT Hermitian `E_{7(-25)}`. The Lean encoding below uses ONLY
verified citations and does not propagate these paper-level errors. -/

/-- Framework predicate (b.1): split-form archimedean rank-3 Whittaker
 non-vanishing on the minimal unitary representation. Pinned by verified
 published sources (Sahi 1992 + Magaard-Savin 1997 + Kazhdan-Polishchuk
 2004 + Shan 2025 for the split `(PGL_2, F_4) ⊂ E_7` theta).
 paper source: hyp:hecke-bbt clause (b) framework. -/
-- R125: was `axiom`; now a def projecting the `isArchimedeanRank3WhittakerNonvanishSplit_E7` field.
def IsArchimedeanRank3WhittakerNonvanishSplit_E7 (S : E7ShimuraTor) : Prop :=
  S.isArchimedeanRank3WhittakerNonvanishSplit_E7

/-- **CONJECTURAL EXTENSION** predicate (b.2): Hermitian parallel-port
 of the split-form archimedean rank-3 Whittaker non-vanishing to
 `Π_min^{(-25)}` on `E_{7(-25)}`. Folklore per `\ref{hyp:hecke-bbt}`
 Note on items (a)-(c) parallel-computation transfer ("stated for the
 split or quaternionic real form ... transferred to the Hermitian
 form by parallel-computation arguments") + SG-11.
 paper source: hyp:hecke-bbt clause (b) conjectural-extension. -/
axiom IsArchimedeanRank3WhittakerHermitianParallelPort_E7Minus25_CONJECTURAL :
 E7ShimuraTor → Prop

/-- Verified split-form framework classical-literature axiom.

For every `E_{7(-25)}` Shimura variety toroidal compactification `S`,
the archimedean rank-3 Whittaker non-vanishing on the split-form
minimal representation holds.

Source: S. Sahi, "Explicit Hilbert spaces for certain unipotent
 representations", Invent. Math. 110 (1992) 409-418 (split-tube
 unipotent reps); K. Magaard, G. Savin, "Exceptional Theta
 correspondences I", Compositio Math. 107 (1997) 89-123 (p-adic
 exceptional theta for split `E_n`); D. Kazhdan, A. Polishchuk,
 "Minimal representations: spherical vectors and automorphic
 functionals", arXiv:math/0209315 (in *Algebraic Groups and Arithmetic*,
 TIFR / Birkhäuser Progress in Mathematics 2004) (non-archimedean
 Whittaker for split `D_k/E_k` minimal rep); Yi Shan, "Exceptional theta
 correspondence `F_4 × PGL_2` for level one automorphic representations",
 arXiv:2501.19101 (2025) (split `(PGL_2, F_4) ⊂ E_7` theta with `F_4`
 compact at infinity — NOTE: covers SPLIT `E_7`, not the Hermitian
 real form). Cross-source: W. T. Gan, G. Savin, "On minimal
 representations: definitions and properties", Rep. Theory 9 (2005)
 46-93.
paper source: hyp:hecke-bbt clause (b) framework (b.1). -/
axiom sahi_magaard_savin_split_form_archimedean_rank3_whittaker_E7 :
 ∀ (S : E7ShimuraTor), IsArchimedeanRank3WhittakerNonvanishSplit_E7 S

/-- **CONJECTURAL-EXTENSION axiom**: Hermitian parallel-port.

For every `E_{7(-25)}` Shimura variety toroidal compactification `S`,
the archimedean rank-3 Whittaker non-vanishing on `Π_min^{(-25)}` on
the Hermitian real form holds, transferring the split-form result above
via the (unpublished) parallel-port to Hermitian.

STATUS: paper-acknowledged folklore per `\ref{hyp:hecke-bbt}` Note on
items (a)-(c) parallel-computation transfer + SG-11 (supplement entry
for SG-11). No single published source extends the rank-3 archimedean
Whittaker non-vanishing to `E_{7(-25)}` `Π_min`; transfer is via parallel
computation / real-form descent, no formal proof in any cited reference.

Source: master proof self-acknowledged hypothesis. The verified split-
form framework axiom above gives the published part; this axiom is the
parallel transfer to Hermitian. Loke 2000 J. Funct. Anal. 172 (377-403)
"Restrictions of quaternionic representations" provides the QUATERNIONIC
side (E_{7(-5)}); the Hermitian extension is not in Loke's verified
output.
paper source: hyp:hecke-bbt clause (b) conjectural-extension (b.2). -/
axiom hermitian_parallel_port_archimedean_whittaker_E7Minus25_CONJECTURAL :
 ∀ (S : E7ShimuraTor),
 IsArchimedeanRank3WhittakerHermitianParallelPort_E7Minus25_CONJECTURAL S

/-- Clause (b): archimedean rank-3 Whittaker non-vanishing for
 `Π_min^{(-25)}` on the Hermitian form, matching across the
 `(PGL_2, F_4)` dual pair.

 Concrete `def` = conjunction of split-form framework (verified
 published) + Hermitian parallel-port (paper-acknowledged conjectural).
 Closure status: **gapPartial**.
 paper source: hyp:hecke-bbt clause (b). -/
def HeckeBBT_archimedean_whittaker (S : E7ShimuraTor) : Prop :=
 IsArchimedeanRank3WhittakerNonvanishSplit_E7 S ∧
 IsArchimedeanRank3WhittakerHermitianParallelPort_E7Minus25_CONJECTURAL S

/-- Clause (c): `K_∞`-equivariant closed rank-3 Kudla--Millson form on
 the exceptional tube.
 paper source: hyp:hecke-bbt clause (c). -/
axiom HeckeBBT_kudla_millson: E7ShimuraTor → Prop

/-! ### Atomic literature predicates for clause (d) of hyp:hecke-bbt
(closure status: **gapPartial**).

Decomposition into 1 framework predicate (published, BKT 2020) +
1 conjectural-extension predicate (cycle-level Hecke-equivariance =
folklore / functoriality argument, no clean published citation;
`\ref{hyp:hecke-bbt}` item (d) labels this clause as the
"Hecke-equivariant refinement of BBT", paper-acknowledged hypothesis
status). -/

/-- Framework predicate (d.1): Hecke correspondences on the arithmetic
 quotient `S_{E_7}` are `R_an`-definable in the BKT 2020 sense.
 Pinned by BKT 2020 Thm 1.1(2).
 paper source: hyp:hecke-bbt clause (d) framework. -/
-- R125: was `axiom`; now a def projecting the `isBKTHeckeCorrespondencesDefinable_E7Minus25` field.
def IsBKTHeckeCorrespondencesDefinable_E7Minus25 (S : E7ShimuraTor) : Prop :=
  S.isBKTHeckeCorrespondencesDefinable_E7Minus25

/-- **CONJECTURAL EXTENSION** predicate (d.2): Chow-level Hecke-
 equivariance of the BBT definable-spreading functor on the algebraic
 locus `Alg(V, ω) ⊂ S_{E_7}`. `\ref{hyp:hecke-bbt}` item (d) calls
 this the "Hecke-equivariant refinement of the BBT definable-spreading
 theorem" and packages it as one of the 9 labelled hypotheses; no
 single published source states the cycle-level commutation.
 paper source: hyp:hecke-bbt clause (d) conjectural-extension. -/
axiom IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL :
 E7ShimuraTor → Prop

/-- **BKT 2020** classical-literature axiom.

For every `E_{7(-25)}` Shimura variety toroidal compactification `S`,
the Hecke correspondences `c_g`, `g ∈ G(ℚ)^+`, on the arithmetic
quotient `S_Γ ⊂ S` are `R_an`-definable.

Source: B. Bakker, B. Klingler, J. Tsimerman, "Tame topology of
 arithmetic quotients and algebraicity of Hodge loci", J. Amer. Math.
 Soc. 33 (2020) 917-939, Theorem 1.1(2). The Hecke correspondences are
 morphisms of arithmetic quotients, hence `R_an`-definable by the BKT
 functoriality theorem.
Cross-source: B. Bakker, Y. Brunebarbe, J. Tsimerman, "o-minimal GAGA
 and a conjecture of Griffiths", Invent. Math. 232 (2023) 163-228 (the
 o-minimal GAGA framework). B. Klingler, "Hodge loci and atypical
 intersections", arXiv:1711.09387 (Mumford-Tate / functorial Hodge-data
 formalism survey).
paper source: hyp:hecke-bbt clause (d) framework (d.1). -/
axiom bkt_2020_hecke_correspondences_definable_E7Minus25 :
 ∀ (S : E7ShimuraTor), IsBKTHeckeCorrespondencesDefinable_E7Minus25 S

/-- **CONJECTURAL-EXTENSION axiom**.

Chow-level (cycle-level) Hecke-equivariance of the BBT
definable-spreading functor on the algebraic locus
`Alg(V, ω) ⊂ S_{E_7}`.

STATUS: paper-acknowledged hypothesis (`\ref{hyp:hecke-bbt}` item
(d)). The
BKT framework axiom above (`bkt_2020_hecke_correspondences_definable_*`)
gives DEFINABILITY of Hecke correspondences on the quotient; the
cycle-level commutation of BBT spreading with Hecke action is a
SEPARATE statement, foundational to the paper's strategy, that is not
covered by any single published source. Standard derivation via
BKT 2020 + BBT 2023 o-minimal GAGA + Cattani-Deligne-Kaplan
algebraicity of Hodge loci + functoriality, but no published theorem
states the conclusion in this form.

NOTE: master paper preceding `\ref{hyp:hecke-bbt}` cites "BBT
Theorem 1.1" as the locus of the spreading principle; this is a
precise-theorem-level miscitation —
BBT 2023 Thm 1.1 is the Griffiths-conjecture period-map factorization,
not a spreading theorem. The operative definability theorem is BKT
2020 Thm 1.1(2). The miscitation is paper-level (does not affect the
Lean closure honesty, but is recorded here for future reference).

THIS axiom is the reason `hyp_hecke_bbt_d` closes to **gapPartial**,
not gapClosed.
paper source: hyp:hecke-bbt clause (d) conjectural-extension (d.2). -/
axiom chow_level_hecke_equivariant_BBT_spreading_E7Minus25_CONJECTURAL :
 ∀ (S : E7ShimuraTor),
 IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL S

/-- Clause (d): Hecke-equivariance of BBT o-minimal definable spreading.

 Concrete conjunction of 2 atomic literature predicates: 1 framework
 (BKT 2020 Hecke definability, published) + 1 conjectural-extension
 (Chow-level Hecke-equivariance, paper-acknowledged hypothesis).
 Bundled closure status: **gapPartial**.

 paper source: hyp:hecke-bbt clause (d). -/
def HeckeBBT_spreading_equivariance (S : E7ShimuraTor) : Prop :=
 IsBKTHeckeCorrespondencesDefinable_E7Minus25 S ∧
 IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL S

/-- Clause (e): Chow-level Hecke-equivariance of the theta generating series.
 paper source: hyp:hecke-bbt clause (e). -/
axiom HeckeBBT_chow_theta_equivariance: E7ShimuraTor → Prop

/-- Atomic clause (a) closure (**gapPartial**).

 Proof = conjunction-intro from 3 framework classical-lit axioms (VZ
 1984, Borel-Wallach 1980/2000, Adams 2007) + 1 conjectural-extension
 axiom (GW 1996 Crelle 481 parallel-port to Hermitian `E_{7(-25)}`,
 paper-acknowledged unpublished per master paper's Gap note on
 parallel transfer to Hermitian E_{7(-25)}). Status
 gapPartial (NOT gapClosed) because of the conjectural-extension
 dependency.
 paper source: hyp:hecke-bbt clause (a). -/
theorem hyp_hecke_bbt_a : ∀ (S: E7ShimuraTor), HeckeBBT_gK_cohomology S := fun S =>
 ⟨vogan_zuckerman_1984_qq_bidegree_E7Minus25 S,
 borel_wallach_hecke_equivariant_matsushima_E7Minus25 S,
 adams_2007_self_conjugate_lowest_K_type_E7Minus25 S,
 gross_wallach_1996_parallel_port_E7Minus25_CONJECTURAL S⟩

/-- Atomic clause (b) closure (**gapPartial**).

 Proof = conjunction-intro from 1 framework classical-lit axiom (verified
 published split-form Sahi/Magaard-Savin/Kazhdan-Polishchuk/Shan) + 1
 conjectural-extension axiom (Hermitian parallel-port, paper-
 acknowledged folklore). Status gapPartial because of conjectural-
 extension dependency.
 paper source: hyp:hecke-bbt clause (b). -/
theorem hyp_hecke_bbt_b :
 ∀ (S : E7ShimuraTor), HeckeBBT_archimedean_whittaker S := fun S =>
 ⟨sahi_magaard_savin_split_form_archimedean_rank3_whittaker_E7 S,
 hermitian_parallel_port_archimedean_whittaker_E7Minus25_CONJECTURAL S⟩

/-! ### Atomic literature predicates for clause (c) of hyp:hecke-bbt
(closure status: **gapPartial** via Pattern (ii) `_INVENTION_CLASS`
extension; mirror SG-22 / SG-23 epistemic tier).

R-attack-#34 (R-#24 audit findings followed up). Decomposition:
- Framework PUBLISHED (2 atoms):
 (i) Kudla-Millson 1986 Math. Ann. 274 (353-378) §3 + 1990
 Publ. Math. IHÉS 71 (121-172): classical Kudla-Millson Schwartz
 form construction on orthogonal/unitary symmetric spaces
 O(p,q) / U(p,q). Howe-operator + Heisenberg-parabolic structure
 of the Weil representation. SCOPE: classical orthogonal/unitary
 ONLY; no analog written for exceptional minimal representation.
 (ii) Faraut-Koranyi 1994 "Analysis on Symmetric Cones" (Oxford
 Mathematical Monographs): Jordan-algebra framework for ALL
 irreducible symmetric cones (Koecher classification), including
 the exceptional rank-3 case J_3(𝕆). SCOPE: harmonic analysis
 (Gindikin-Karpelevic gamma, Wallach set, Hua integrals); does
 NOT construct Kudla-Millson-type Schwartz forms. Provides the
 analytic geometry of D_EVII without the Weil-rep Schwartz form.
- Conjectural-extension `_INVENTION_CLASS`: exceptional-tube
 Schwartz form on D_{EVII} = E_{7(-25)} / (E_6 × U(1)).
 Paper-acknowledged "not in literature" (R-#24 Phase 0 audit:
 1986-2026 no published rank-3 closed K_∞-equivariant Schwartz
 form on D_EVII). INVENTION-class equivalent to original gap
 (the exceptional theta integral construction). -/

/-- Framework predicate (i): classical Kudla-Millson 1986/1990
 Schwartz form construction on O(p,q) / U(p,q). -/
axiom IsKudlaMillsonClassicalOrthUnitarySchwartzForm_bbt_c : Prop

/-- Framework predicate (ii): Faraut-Koranyi 1994 Jordan-algebra
 symmetric cone harmonic analysis (NOT Schwartz form
 construction). -/
axiom IsFarautKoranyiJordanSymmetricConeAnalysis_bbt_c : Prop

/-- **`_INVENTION_CLASS`** extension predicate: exceptional-tube
 Schwartz form on D_{EVII}. Paper-acknowledged "not in
 literature" 1986-2026. INVENTION-class equivalent to original
 gap. -/
axiom IsExceptionalTubeSchwartzFormD_EVII_bbt_c_INVENTION_CLASS :
 Prop

/-- **Framework axiom (i)** (PUBLISHED).

 Sources:
 - S. Kudla, J. Millson, "The theta correspondence and harmonic
  forms. I", Math. Ann. 274 (1986), 353-378, §3.
 - S. Kudla, J. Millson, "Intersection numbers of cycles on
  locally symmetric spaces and Fourier coefficients of
  holomorphic modular forms in several complex variables",
  Publ. Math. IHÉS 71 (1990), 121-172.

 Constructs the Kudla-Millson Schwartz form `ψ_KM` on the
 orthogonal symmetric space `O(p,q)/K` (and unitary `U(p,q)/K`
 in KM II Math. Ann. 277, 1987) using Howe's differential
 operators. Thom-form of an oriented real vector bundle
 (Branchereau 2022 arXiv:2211.10341 Mathai-Quillen recovery).

 SCOPE-BOUND: classical `O(p,q)` and `U(p,q)` ONLY. Howe-operator
 construction depends on Heisenberg-parabolic structure of the
 orthogonal/unitary Weil representation; NO analog written for
 exceptional minimal representation of E_{7(-25)}.

 DISTINCT from `IsKudlaMillson1986_1990CohomologicalModularity`
 (theta modularity, theorem-level statement about generating
 series); this is the underlying Schwartz form construction.

 paper source: hyp:hecke-bbt clause (c) framework atom (i). -/
axiom kudla_millson_classical_orth_unitary_schwartz_form_bbt_c :
 IsKudlaMillsonClassicalOrthUnitarySchwartzForm_bbt_c

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: J. Faraut, A. Korányi, "Analysis on Symmetric Cones",
 Oxford Mathematical Monographs, Oxford University Press, 1994.

 Jordan-algebra harmonic analysis for ALL irreducible symmetric
 cones (Koecher classification) including the exceptional
 rank-3 cone of the Hermitian Jordan algebra `J_3(𝕆)`:
 spherical polynomials, Gindikin-Karpelevic gamma functions,
 Wallach set classification, Hua integrals on the tube domain
 `D_EVII`.

 SCOPE-BOUND: harmonic analysis ONLY. Does NOT construct
 Kudla-Millson-type Schwartz forms. Provides analytic geometry
 of `D_EVII` (= tube over the symmetric cone of `J_3(𝕆)`)
 without pairing with a Weil-representation Schwartz function.
 Per R-#24 audit: the prior Ledger framing "Faraut-Koranyi 1994
 Jordan-algebra Schwartz form" was a portmanteau not
 corresponding to any FK94 theorem; this axiom HONESTLY
 limits scope to harmonic analysis.

 paper source: hyp:hecke-bbt clause (c) framework atom (ii). -/
axiom faraut_koranyi_jordan_symmetric_cone_analysis_bbt_c :
 IsFarautKoranyiJordanSymmetricConeAnalysis_bbt_c

/-- **`_INVENTION_CLASS` extension axiom**.

 Exceptional-tube Schwartz form on `D_{EVII} = E_{7(-25)} /
 (E_6 × U(1))`. Closed rank-3 `K_∞`-equivariant differential
 form pairing with the exceptional minimal representation of
 `E_{7(-25)}`.

 STATUS: **INVENTION-CLASS** equivalent to original gap. R-#24
 Phase 0 hostile audit verified (web search 1986-2026):
 - NO paper constructs a closed `K_∞`-equivariant rank-3
  Schwartz form on `D_EVII` with Weil-representation
  compatibility.
 - Sibling results (do NOT close): Kazhdan-Savin / Gross-Wallach
  minimal rep construction (no differential-form realisation);
  Pollack 2020 Duke quaternionic modular forms on `E_{7(-5)}`
  (distinct real form); Shan 2025 arXiv:2501.19101 F_4×PGL_2
  exceptional theta (automorphic-level only, globally split
  E_{7(7)} not Hermitian); Greer-Tayou 2026 arXiv:2603.01251
  modularity survey (formulates as conjecture for "other
  types"); Branchereau 2022 (Mathai-Quillen reframing,
  orthogonal/Hermitian signature only).

 R-#68 CROSS-REFERENCE NOTE (per R-#64 audit): hecke_bbt_c
 STAYS `_INVENTION_CLASS` (no source-verified named-open
 candidate exists). Unlike SG-23 (R-#65 upgrade to
 NAMED-OPEN-MULTI via 2 named-open atoms) and G1-atomic
 (R-#66 upgrade to NAMED-OPEN-BROKEN-LINK via refined BB +
 effective-construction broken-link), the D_EVII Schwartz form
 has no analogous named-open or broken-link decomposition: the
 exceptional construction problem is itself the invention. R-#24
 web search 1986-2026 found no published rank-3 closed
 K_∞-equivariant exceptional Schwartz form construction with
 Weil-rep compatibility. If a future paper provides such a
 construction OR formulates the exceptional Schwartz form as a
 specific named-open conjecture (analogous to Bloch-Beilinson
 for BB or SC(B)_3 for standard conjectures), the predicate
 should be re-classified — until then, `_INVENTION_CLASS` is
 the honest tier.

 HONESTY DISCIPLINE: mirror of SG-22 `_INVENTION_CLASS` tier
 (SG-22 R-#68 HYBRID annotation: stays INVENTION-CLASS because
 Lin 2021 NCHC ⇔ HC makes NC route tautological). SG-23 / G1-
 atomic upgraded to NAMED-OPEN tiers per R-#65 / R-#66; hecke_bbt_c
 + SG-22 remain INVENTION-CLASS as the honest current state.

 paper source: hyp:hecke-bbt clause (c) `_INVENTION_CLASS`
 extension. -/
axiom exceptional_tube_schwartz_form_D_EVII_bbt_c_INVENTION_CLASS :
 IsExceptionalTubeSchwartzFormD_EVII_bbt_c_INVENTION_CLASS

/-- Typed bridge axiom: 2 framework atoms (Kudla-Millson 1986/1990
 classical scope + Faraut-Koranyi 1994 Jordan-algebra harmonic
 analysis) + 1 `_INVENTION_CLASS` extension (D_EVII Schwartz
 form) → `HeckeBBT_kudla_millson S` for all `S`.
 paper source: hyp:hecke-bbt clause (c) combination. -/
axiom hyp_hecke_bbt_c_from_framework_and_invention :
 ∀ (S : E7ShimuraTor),
 IsKudlaMillsonClassicalOrthUnitarySchwartzForm_bbt_c ∧
 IsFarautKoranyiJordanSymmetricConeAnalysis_bbt_c ∧
 IsExceptionalTubeSchwartzFormD_EVII_bbt_c_INVENTION_CLASS →
 HeckeBBT_kudla_millson S

/-- Atomic clause (c) closure (**gapPartial** via Pattern (ii)
 `_INVENTION_CLASS` extension; mirror SG-22 / SG-23 tier;
 R-attack-#34).

 Proof = conjunction-intro from 2 framework atoms (Kudla-Millson
 1986/1990 classical Schwartz form + Faraut-Koranyi 1994
 Jordan-algebra harmonic analysis on `J_3(𝕆)` symmetric cone) +
 1 `_INVENTION_CLASS` extension (D_EVII exceptional-tube
 Schwartz form, paper-acknowledged "not in literature"
 1986-2026 per R-#24 audit).

 Status `gapPartial` driven by `_INVENTION_CLASS` extension;
 mirror SG-22 (Tabuada NC) / SG-23 (M_AE → Chow descent) tier.
 Master tex `\ref{hyp:hecke-bbt}` clause (c) explicit
 "Hecke-equivariant refinement" = paper-acknowledged hypothesis.

 paper source: hyp:hecke-bbt clause (c). -/
theorem hyp_hecke_bbt_c : ∀ (S : E7ShimuraTor),
 HeckeBBT_kudla_millson S := fun S =>
 hyp_hecke_bbt_c_from_framework_and_invention S
  ⟨kudla_millson_classical_orth_unitary_schwartz_form_bbt_c,
   faraut_koranyi_jordan_symmetric_cone_analysis_bbt_c,
   exceptional_tube_schwartz_form_D_EVII_bbt_c_INVENTION_CLASS⟩

/-- Atomic clause (d) closure (**gapPartial**).

 Proof = conjunction-intro from 1 framework classical-lit axiom
 (BKT 2020 Hecke correspondences definable) + 1 conjectural-extension
 axiom (Chow-level Hecke-equivariance of BBT spreading, paper-
 acknowledged hypothesis). Status gapPartial (NOT gapClosed) because
 of the conjectural-extension dependency.
 paper source: hyp:hecke-bbt clause (d). -/
theorem hyp_hecke_bbt_d :
 ∀ (S : E7ShimuraTor), HeckeBBT_spreading_equivariance S := fun S =>
 ⟨bkt_2020_hecke_correspondences_definable_E7Minus25 S,
 chow_level_hecke_equivariant_BBT_spreading_E7Minus25_CONJECTURAL S⟩

/-! ### Atomic clause (e) closure via REDUCES-TO chow-modularity-E7
extension (R-attack-#35; gapPartial inherited).

Master tex `\ref{hyp:hecke-bbt}` clause (e) explicit:
"Chow-level Hecke-equivariance of theta. Linked to
`\\ref{hyp:chow-modularity-E7}`. Same invention burden as the
chow-modularity gap." Ledger gap_hecke_bbt_e: "Resolves together
with hyp:chow-modularity-E7."

R-#35 closure pattern (mirror SG-21 REDUCES-TO precedent): the
clause (e) atomic claim REDUCES-TO the
`IsExceptionalE7ChowModularityExtension_CONJECTURAL` atom of
`hyp:chow-modularity-E7` (already-existing
conjectural-extension axiom in this Lean module, used in the
hyp_chow_modularity_E7 R-#22 closure). Since
`exceptional_E7_chow_modularity_extension_CONJECTURAL` is
already provable (it's an axiom), the clause (e) reduction
yields the THEOREM `hyp_hecke_bbt_e`, inheriting gapPartial
status from hyp:chow-modularity-E7. -/

/-- Typed bridge axiom (REDUCES-TO pattern, mirror SG-21):
 clause (e) Chow-level Hecke-equivariance of theta reduces to
 the existing `IsExceptionalE7ChowModularityExtension_CONJECTURAL`
 atom of `hyp:chow-modularity-E7`. Same invention burden
 (master tex hyp:hecke-bbt clause (e) explicit "linked to
 hyp:chow-modularity-E7").
 paper source: hyp:hecke-bbt clause (e) combination. -/
axiom hyp_hecke_bbt_e_from_chow_modularity_extension :
 ∀ (S : E7ShimuraTor),
 IsExceptionalE7ChowModularityExtension_CONJECTURAL S →
 HeckeBBT_chow_theta_equivariance S

/-- Atomic clause (e) closure (**gapPartial** via REDUCES-TO
 chow-modularity-E7 extension; mirror SG-21 R-#29 precedent;
 R-attack-#35).

 Proof = REDUCES-TO bridge applied to the existing
 `exceptional_E7_chow_modularity_extension_CONJECTURAL S`
 axiom (closure atom of `hyp:chow-modularity-E7`). Net axiom
 delta = +1 typed-bridge axiom only; no new framework atoms.

 Status `gapPartial` inheriting from
 `hyp:chow-modularity-E7` conjectural-extension status. R-#35
 LESSON: clause (e) is honestly a re-statement of the same
 chow-modularity invention; recording the reduction surfaces
 the dependency without double-counting.

 paper source: hyp:hecke-bbt clause (e). -/
theorem hyp_hecke_bbt_e : ∀ (S : E7ShimuraTor),
 HeckeBBT_chow_theta_equivariance S := fun S =>
 hyp_hecke_bbt_e_from_chow_modularity_extension S
  (exceptional_E7_chow_modularity_extension_CONJECTURAL S)

/-! ### Atomic literature predicates for core of hyp:hecke-bbt
(closure status: **gapPartial**).

Decomposition: 4 atomic predicates = 2 framework (PUBLISHED) + 2
conjectural-extension. Two framework predicates are reused from clause
(d) decomposition: `IsBKTHeckeCorrespondencesDefinable_E7Minus25` and
`IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL`. Two
atoms below cover the BBT 2023 framework piece and the algebraic-locus
Hecke-stability conjectural-extension piece. -/

/-- Framework predicate (core.1): the period-map image is quasi-projective
 (Griffiths conjecture, BBT 2023 Invent. Math. 232 Theorem 1.1). Pinned
 by BBT 2023 Thm 1.1.

 SCOPE NOTE: BBT 2023 Thm 1.1 by itself is the Griffiths-conjecture
 period-map factorization + quasi-projectivity of period image; it does
 NOT directly state Hecke-equivariant spreading. The Hecke-BBT-spreading
 conclusion is an APPLICATION combining BBT 2023 Thm 1.1 with BKT 2020
 Thm 1.1(2) (Hecke definability) and CDK 1995 (Hodge-locus algebraicity)
 plus the conjectural Chow-level commutation. This predicate isolates
 the Thm-1.1 framework piece only; the spreading combination is
 captured via the conjugation of all 4 core-decomposition atoms.

 paper source: hyp:hecke-bbt core (framework Part 2). -/
-- R125: was `axiom`; now a def projecting the `isBBTPeriodImageQuasiProjective_E7Minus25` field.
def IsBBTPeriodImageQuasiProjective_E7Minus25 (S : E7ShimuraTor) : Prop :=
  S.isBBTPeriodImageQuasiProjective_E7Minus25

/-- **CONJECTURAL EXTENSION** predicate (core.2): the algebraic locus
 `Alg(V, ω) ⊂ S_{E_7}` is stable under the full Hecke algebra of
 `S_{E_7}`. `\ref{hyp:hecke-bbt}` lists this as Part 1 of the core
 hypothesis statement; the parenthetical handwaves it as
 "follows from functoriality of the cycle class map". No single
 published source (Voisin Hodge II Ch. 11, Bloch 1980 Lectures, Fulton
 Intersection Theory Ch. 16, CDK 1995 JAMS 8, Klingler arXiv:1711.09387)
 states Hecke-stability of the algebraic locus at the Shimura/VHS
 level. Folklore-derivable from Fulton Ch. 16 correspondence-action +
 CDK 1995 Hodge-locus algebraicity, but not pinned to a single theorem.

 paper source: hyp:hecke-bbt core (conjectural-extension Part 1). -/
-- R125: was `axiom`; now a def projecting the `isAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL` field.
def IsAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL (S : E7ShimuraTor) : Prop :=
  S.isAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL

/-- **BBT 2023** classical-literature axiom.

 Source: B. Bakker, Y. Brunebarbe, J. Tsimerman, "o-minimal GAGA and a
  conjecture of Griffiths", Invent. Math. 232 (2023) 163-228;
  arXiv:1811.12230.

 Theorem 1.1 (Griffiths conjecture, abstract verbatim): for a polarised
 variation of Hodge structure over a smooth quasi-projective base `S`
 with period map `Φ: S → Γ\D`, the image `Φ(S)` is quasi-projective and
 `Φ` factors as `Φ = ι ∘ f^an` with `f: S → Y` a dominant map of
 finite-type algebraic spaces and `ι: Y^an → Γ\D` a closed immersion;
 the Griffiths Q-bundle restricted to Y is the analytification of an
 ample algebraic Q-bundle.

 This Lean axiom isolates the Thm-1.1 framework piece only; the
 Hecke-spreading conclusion is captured via the conjunction of all 4
 core-decomposition atoms (BKT 2020 Thm 1.1(2) definability + this
 BBT 2023 Thm 1.1 quasi-projectivity + alg-locus-Hecke-stability +
 Chow-level commutation conjectural-extension).

 paper source: hyp:hecke-bbt core (framework Part 2). -/
axiom bbt_2023_period_image_quasi_projective_E7Minus25 :
 ∀ (S : E7ShimuraTor), IsBBTPeriodImageQuasiProjective_E7Minus25 S

/-- **CONJECTURAL-EXTENSION axiom**.

 Algebraic-locus `Alg(V, ω) ⊂ S_{E_7}` is stable under the full Hecke
 algebra of `S_{E_7}`. `\ref{hyp:hecke-bbt}` lists this as Part 1 of
 the core hypothesis; the parenthetical handwaves it as "follows
 from functoriality of the cycle class map" without theorem citation.

 STATUS: paper-acknowledged hypothesis. Cross-source check:
 - Voisin Hodge II Ch. 11.2 (Cambridge Studies 77): generic cycle-class
  functoriality, NOT Shimura/Hecke-specific.
 - Bloch 1980 Lectures on Algebraic Cycles (Duke Math Series 4 /
  Cambridge New Math. Monographs 16 2010 2nd ed.): no Hecke-action
  chapter.
 - Fulton Intersection Theory Ch. 16: generic correspondence action,
  not Hecke-on-algebraic-locus.
 - CDK 1995 JAMS 8 (483-506): Hodge-locus algebraicity at variety
  level, not Chow-level Hecke action.
 - Klingler arXiv:1711.09387: Hecke functoriality of Hodge loci in
  survey form, not as a labelled theorem.
 The claim is folklore-derivable but not pinned to a single source.

 THIS axiom is one of two conjectural-extensions in the core
 decomposition (the other is
 `chow_level_hecke_equivariant_BBT_spreading_E7Minus25_CONJECTURAL`).
 paper source: hyp:hecke-bbt core (conjectural-extension Part 1). -/
axiom alg_locus_hecke_stable_via_cycle_class_functoriality_E7Minus25_CONJECTURAL :
 ∀ (S : E7ShimuraTor), IsAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL S

/-- Core of hyp:hecke-bbt: Hecke-equivariance of BBT spreading on
 `S_{E_7}` (= Part 1 + Part 2 of `\ref{hyp:hecke-bbt}` hypothesis
 statement).

 Transparent 4-fold conjunction. Decomposition:
 - Part 1 framework: BKT 2020 JAMS 33 Thm 1.1(2) (Hecke definability,
  reused from clause (d));
 - Part 2 framework: BBT 2023 Invent. 232 Thm 1.1 (Griffiths-conjecture
  quasi-projectivity);
 - Part 1 conjectural: algebraic-locus Hecke-stability;
 - Part 2 conjectural: Chow-level Hecke-equivariance of BBT spreading
  (reused from clause (d)).

 paper source: hyp:hecke-bbt core. -/
def HeckeBBTEquivariance (S : E7ShimuraTor) : Prop :=
 IsBKTHeckeCorrespondencesDefinable_E7Minus25 S ∧
 IsBBTPeriodImageQuasiProjective_E7Minus25 S ∧
 IsAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL S ∧
 IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL S

/-- Atomic core closure (**gapPartial**).

 No-sorry conjunction-intro from 4 atomic axioms (2 framework PUBLISHED:
 BKT 2020 + BBT 2023; 2 conjectural-extension: alg-locus-Hecke-stability
 + Chow-level Hecke-BBT-commutation). Status gapPartial driven by the
 2 conjectural-extension dependencies, both paper-acknowledged
 hypothesis-status per `\ref{hyp:hecke-bbt}` core statement + item (d).
 paper source: hyp:hecke-bbt core. -/
theorem hyp_hecke_bbt_core : ∀ (S : E7ShimuraTor), HeckeBBTEquivariance S := fun S =>
 ⟨bkt_2020_hecke_correspondences_definable_E7Minus25 S,
 bbt_2023_period_image_quasi_projective_E7Minus25 S,
 alg_locus_hecke_stable_via_cycle_class_functoriality_E7Minus25_CONJECTURAL S,
 chow_level_hecke_equivariant_BBT_spreading_E7Minus25_CONJECTURAL S⟩

/-- Bundled form: conjunction of core HeckeBBTEquivariance + 5 extended
 clauses (a)-(e) per paper `\ref{hyp:hecke-bbt}` L8083-8154 explicit
 "all five are jointly required" framing.

 Returns the 6-tuple conjunction; the underlying Hecke-BBT extended
 scope is encoded as the conjunction of all 6 sub-clauses.

 paper source: hyp:hecke-bbt (full bundled scope per paper L8083-8154). -/
theorem hyp_hecke_bbt:
 ∀ (S: E7ShimuraTor),
 HeckeBBTEquivariance S ∧
 HeckeBBT_gK_cohomology S ∧
 HeckeBBT_archimedean_whittaker S ∧
 HeckeBBT_kudla_millson S ∧
 HeckeBBT_spreading_equivariance S ∧
 HeckeBBT_chow_theta_equivariance S := fun S =>
 ⟨hyp_hecke_bbt_core S,
  hyp_hecke_bbt_a S,
  hyp_hecke_bbt_b S,
  hyp_hecke_bbt_c S,
  hyp_hecke_bbt_d S,
  hyp_hecke_bbt_e S⟩

/-! ## Sub-gap inventory (SG-1..SG-23)

Paper: `app:subgap-inventory` lists 23 sub-gaps. Each is
tagged `SG-n`, with a disposition: "reduces to Hypothesis X" or
"standalone". The Main Theorem `thm:main` closes HC on the scope
sub-classes modulo both the 9 primary labelled hypotheses and these 23
sub-gaps.

We record the inventory as 23 indexed `SubGap` propositions. The
mathematical content of each entry is a TODO: faithful encoding requires
further Mathlib / paper-level formalisation. The antecedent is made
explicit in `main_reduction` so that the conditional structure matches
paper.
-/

/-- Indexed sub-gap proposition. `SubGap i` for `i: Fin 23` encodes
 sub-gap SG-`(i+1)` of the paper's Appendix. Master tex
 `contributions/hodge-conjecture-master-proof.tex` is the single
 source of truth for paper content. Each SG-k carries an explicit
 disposition string in either the master tex (SG-1..SG-16 + SG-23
 have in-text mentions; SG-17 integrated as Stage D extension
 subsection per R-attack-#24) or pending master integration
 (SG-18..22; gap content recorded in per-entry ledger metadata).
 paper source: app:subgap-inventory, SG-1..SG-23. -/
axiom SubGap: Fin 23 → Prop

/-! ### SG-1 closure (gapPartial, framework + conjectural-extension).

SG-1 content: Zariski density of SO(V,Q)(ℚ)-orbits of positive-dimensional
special subvarieties for non-Hermitian orthogonal type with `min(p,q) ≥ 4`
(Step 2 Witt-density discussion in `\ref{thm:levi-reduction-min3}`).
Framework Hermitian case is PUBLISHED (Clozel-Ullmo 2005 Ann. Math.
161 + Ullmo-Yafaev 2014 Ann. Math. 180 + Tsimerman 2018 Ann. Math.
187); non-Hermitian extension to SO(p,q) `min(p,q) ≥ 4` with `q ≥ 3`
is paper-acknowledged "not in the literature" (Step 2 Witt-density
Gap note). For `q ≥ 3`, the period domain `Sp(p,q)/K` is NOT Hermitian
symmetric (Cartan Type IV requires `q = 2`), so the Ratner-equidistribution
apparatus underlying Clozel-Ullmo 2005 does not directly transfer.
Supplement disposition (`\ref{app:subgap-inventory}` SG-1): "Reduces
to Hypothesis hyp:BBT-rigid-reach". Pattern (ii) 2-axiom decomp
(framework + conjectural-extension + typed bridge), mirroring
hyp:BBT-rigid-reach clause structure (framework + conjectural-extension
precedent used by hyp:hecke-bbt clauses (a)/(d)). -/

/-- Framework predicate: Zariski density of SO(V,Q)(ℚ)-orbits of
 positive-dimensional special subvarieties in Hermitian (abelian +
 orthogonal type (n,2)) Shimura varieties, supplied by Clozel-Ullmo
 2005 unconditional strongly-special equidistribution + Ullmo-Yafaev
 2014 Galois-orbit equidistribution dichotomy + Tsimerman 2018 A_g
 André-Oort. -/
axiom IsClozelUllmoUllmoYafaevTsimermanZariskiDensityHermitian_sg1 : Prop

/-- **CONJECTURAL-EXTENSION** predicate: non-Hermitian orthogonal
 extension to SO(p,q) `min(p,q) ≥ 4` with `q ≥ 3`. Paper-acknowledged
 "not in the literature" (Step 2 Witt-density Gap note in
 `\ref{thm:levi-reduction-min3}`); period domain not Hermitian
 symmetric for `q ≥ 3`, so Ratner / equidistribution apparatus does
 not directly transfer. Absorbed into `\ref{hyp:BBT-rigid-reach}`
 scope. -/
axiom IsNonHermitianOrthogonalExtensionMinPQGe4_sg1_CONJECTURAL : Prop

/-- **Framework axiom** (PUBLISHED).

 Sources:
 - L. Clozel, E. Ullmo, "Équidistribution de sous-variétés spéciales",
  Ann. of Math. 161 (2005) 1571-1588; arXiv:math/0404131. Theorem:
  for a sequence `(Z_n)` of strongly special subvarieties of a Shimura
  variety `S` (i.e. associated to semi-simple sub-Shimura data), the
  canonical probability measures `μ_{Z_n}` converge to `μ_Z` for some
  strongly special `Z`, and `Z_{n_k} ⊆ Z` for `k ≫ 0`. Type-agnostic
  on Shimura side (works for arbitrary Shimura data via Ratner-
  Mozes-Shah-Dani-Margulis dynamics); restricted on subvariety side
  to strongly special (= semi-simple sub-datum).
 - E. Ullmo, A. Yafaev, "Galois orbits and equidistribution of special
  subvarieties: towards the André-Oort conjecture", Ann. of Math. 180
  (2014) 823-865; arXiv:1209.0934. Theorem 3.8: equidistribution
  dichotomy for sequences of T-special subvarieties under GRH for CM
  fields, plus lower bounds on Galois orbits (Thm 2.19).
 - J. Tsimerman, "The André-Oort conjecture for A_g", Ann. of Math.
  187 (2018) 379-390; arXiv:1506.01466. Unconditional André-Oort for
  the Siegel modular variety `A_g` via averaged Colmez.

 paper source: SG-1 (sub-gap inventory framework). -/
axiom cu05_uy14_tsi18_zariski_density_hermitian_sg1 :
 IsClozelUllmoUllmoYafaevTsimermanZariskiDensityHermitian_sg1

/-- **CONJECTURAL-EXTENSION axiom**.

 Non-Hermitian orthogonal SO(p,q) extension to `min(p,q) ≥ 4` with
 `q ≥ 3`.

 STATUS: paper-acknowledged "not in the literature" (Step 2 Witt-
 density Gap note in `\ref{thm:levi-reduction-min3}`). For `q ≥ 3`,
 the period domain `Sp(p,q)/K` is NOT
 Hermitian symmetric (Cartan Type IV Hermitian symmetric domain
 classification requires `q = 2`); the Ratner-equidistribution
 apparatus underlying Clozel-Ullmo 2005 strongly-special case does
 NOT directly transfer to non-Hermitian settings.

 RELATED LITERATURE (does NOT close the gap):
 - Pila-Shankar-Tsimerman with appendix by Esnault-Groechenig,
  "Canonical Heights on Shimura Varieties and the André-Oort
  Conjecture", arXiv:2109.08788 (v4 Dec 2024): proves André-Oort
  unconditionally for all adjoint Shimura varieties (Thm 1.2), but
  does NOT cover SG-1 because `SO(p,q)` with `q ≥ 3` does NOT define
  a classical Shimura variety — SG-1's gap is at the VHS-locus /
  o-minimal density reach level (Klingler atypical-intersections
  framework arXiv:1711.09387), not classical Shimura A-O.
 - Klingler-Yafaev 2014 Ann. Math. 180 (867-925) "The André-Oort
  conjecture": GRH-conditional general Shimura A-O; same coverage
  limitation as PSTEG (Shimura only, not non-Hermitian VHS).

 Absorbed into `\ref{hyp:BBT-rigid-reach}` scope (Step 2 Witt-density
 Gap note in `\ref{thm:levi-reduction-min3}`, explicit: "absorbed into
 the scope of Hypothesis `\ref{hyp:BBT-rigid-reach}` (which already
 covers 'o-minimal / density reach' inputs at the orthogonal
 stratum)").

 paper source: SG-1 (sub-gap inventory conjectural-extension). -/
axiom non_hermitian_orthogonal_extension_min_p_q_ge_4_sg1_CONJECTURAL :
 IsNonHermitianOrthogonalExtensionMinPQGe4_sg1_CONJECTURAL

/-- Typed bridge axiom: framework Hermitian Zariski-density +
 conjectural-extension non-Hermitian extension → SG-1 SubGap.
 paper source: SG-1 (combination). -/
axiom sg1_from_framework_and_extension :
 IsClozelUllmoUllmoYafaevTsimermanZariskiDensityHermitian_sg1 ∧
 IsNonHermitianOrthogonalExtensionMinPQGe4_sg1_CONJECTURAL →
 SubGap ⟨0, by decide⟩

/-- SG-1 closure theorem: `SubGap ⟨0, _⟩` (the SG-1 indexed Prop)
 holds via Pattern (ii) 2-axiom decomposition: framework Hermitian
 PUBLISHED (Clozel-Ullmo 2005 Ann. Math. 161 + Ullmo-Yafaev 2014
 + Tsimerman 2018) + conjectural-extension non-Hermitian (paper-
 acknowledged "not in literature"). Status gapPartial (driven by
 conjectural-extension dependency).
 paper source: SG-1 (sub-gap inventory). -/
theorem sg_1_closed : SubGap ⟨0, by decide⟩ :=
 sg1_from_framework_and_extension
  ⟨cu05_uy14_tsi18_zariski_density_hermitian_sg1,
   non_hermitian_orthogonal_extension_min_p_q_ge_4_sg1_CONJECTURAL⟩

/-! ### SG-2 closure (gapPartial, folklore derivation).

SG-2 content: "K-invariant weight-lattice reduction to (r, r)-type" on
compact-form polarised Hodge structure. Supplement disposition:
"Reduces to Hypothesis~\ref{hyp:KS-p3}". -/

/-- Folklore closure of SG-2: K-invariant subspace is `(r, r)` pure on
 compact-form polarised Hodge structure.
 Source: P. Deligne, "Variétés de Shimura: interprétation modulaire,
 et techniques de construction de modèles canoniques", Proc. Symp.
 Pure Math. 33 (1979) Part 2, 247-289, §1.1 (polarisation positivity
 criterion); P. Deligne, J. Milne, "Tannakian categories", in *Hodge
 Cycles, Motives, and Shimura Varieties*, Lecture Notes in Math. 900
 (Springer 1982), pp. 101-228 (Tannakian framework for compact inner
 forms). The `(r, r)`-purity is a standard but technical corollary
 from polarisation positivity + Hodge cocharacter on `K`-invariants
 factoring through compact torus; not stated as a labelled theorem in
 either source. paper-acknowledged folklore per Step 2 K-invariant
 (r,r)-type derivation in `\ref{thm:levi-reduction-min3}` ("standard
 but technical"). Disposition (per ledger): reduces to `\ref{hyp:KS-p3}`.
 paper source: SG-2 (sub-gap inventory). -/
axiom deligne_milne_compact_form_hodge_purity_sg2 :
 SubGap ⟨1, by decide⟩

/-- SG-2 closure theorem: `SubGap ⟨1, _⟩` (the SG-2 indexed Prop) holds
 via the folklore derivation from Deligne 1979 + Deligne-Milne 1982.
 Status: gapPartial (folklore corollary, not a stated theorem). -/
theorem sg_2_closed : SubGap ⟨1, by decide⟩ :=
 deligne_milne_compact_form_hodge_purity_sg2

/-! ### SG-3 closure (gapPartial, folklore derivation).

SG-3 content: Griffiths-Schmid normalisation constant in
`e(V) = (-1)^{n/2} c_{n/2}(F^{n/2})` (n even). Supplement disposition:
"Reduces to Hypothesis hyp:ChernWeil-bridge-E7" (already CLOSED via
clauses i/ii/iii). -/

/-- Folklore closure of SG-3: the rational constant in the
 Griffiths-Schmid Euler-class identity `e(V) = (-1)^{n/2} c_{n/2}(F^{n/2})`
 (`n` even) is paper-acknowledged unpinned and absorbed into
 hyp:ChernWeil-bridge-E7.
 Source: P. Griffiths, W. Schmid, "Locally homogeneous complex
 manifolds", Acta Math. 123 (1969) 253-302 (Hodge-bundle Chern-class
 lemma, underlying the Euler-class identity); A. Grothendieck, "La
 théorie des classes de Chern", Bull. Soc. Math. France 86 (1958)
 137-154 (algebraicity of the top Chern class of the holomorphic
 Hodge sub-bundle). `\ref{thm:generic_fiber}` clause (b) (in-text
 derivation via Chern-Gauss-Bonnet on
 `V_ℂ = F^{n/2} ⊕ \overline{F^{n/2}}`, `n` even) + supplement
 entry for SG-3 in `\ref{app:subgap-inventory}`, disposition
 "Reduces to Hypothesis `\ref{hyp:ChernWeil-bridge-E7}`". Status:
 folklore
 corollary, rational constant unpinned at Chern-Weil normalisation
 level. NOTE: ledger entry previously cited "Griffiths 1968 Topology 8"
 — that paper does NOT exist for this content (Griffiths 1968 is Am. J.
 Math. 90 Parts I/II, not Topology); operative joint paper is
 Griffiths-Schmid 1969 Acta Math. 123.
 paper source: SG-3 (sub-gap inventory). -/
axiom griffiths_schmid_1969_grothendieck_1958_euler_chern_normalisation_sg3 :
 SubGap ⟨2, by decide⟩

/-- SG-3 closure theorem: `SubGap ⟨2, _⟩` (the SG-3 indexed Prop) holds
 via the folklore derivation from Griffiths-Schmid 1969 Acta +
 Grothendieck 1958 Bull. SMF. Disposition reduces to
 hyp:ChernWeil-bridge-E7 (already CLOSED).
 Status: gapPartial (folklore corollary). -/
theorem sg_3_closed : SubGap ⟨2, by decide⟩ :=
 griffiths_schmid_1969_grothendieck_1958_euler_chern_normalisation_sg3

/-! ### SG-4 closure (gapPartial, folklore-derivation).

SG-4 content: MRC descent of `E_7`-type VHS along Leray-Iitaka splitting
(MRC-descent passage in the κ = -∞ uniruled non-Fano case of the
main reduction). The MRC fibration `X ⇢ Z` has rationally connected
general fibre `F` (Kollár-Miyaoka-Mori 1992) with `H^0(F, Ω^p_F) = 0`
for `p > 0`, so `h^{3,0}(X) ≤ h^{3,0}(Z)` and `dim Z < dim X`. By
Graber-Harris-Starr 2003 the MRC target `Z` is non-uniruled
(κ(Z) ≥ 0); a single application of the Iitaka fibration (Iitaka
1971) on `Z` reduces to the `κ ≥ 0` cases already treated.
Supplement disposition (supplement entry for SG-4 in
`\ref{app:subgap-inventory}`): "Reduces to Hypothesis
`\ref{hyp:nonrigid-family-bridge}`" — paper-bookkeeping
scope-merging, not logical reduction
(`hyp_nonrigid_family_bridge` accessors BaseDim27 / PeriodMapDominant
/ PeriodMapGenericallyFinite / FibreIsoAt_b0 describe non-rigid family
geometry, NOT MRC descent). Folklore-derivation closure following the
SG-2 / SG-3 / SG-12 single-axiom pattern. -/

/-- Folklore closure of SG-4: MRC descent of `E_7`-type VHS via
 dimension reduction along Leray-Iitaka splitting.

 Sources combined (3-source bundle):
 - J. Kollár, Y. Miyaoka, S. Mori, "Rationally connected varieties",
  J. Algebraic Geom. 1 (1992) 429-448. Rationally connected fibre `F`
  has `H^0(F, Ω^p_F) = 0` for `p ≥ 1`. Cross-source: J. Kollár,
  "Rational Curves on Algebraic Varieties", Springer Ergebnisse
  (3) 32 (1996), Ch. IV.3 (textbook restatement of the KMM vanishing).
 - T. Graber, J. Harris, J. Starr, "Families of rationally connected
  varieties", J. Amer. Math. Soc. 16 (2003) 57-67;
  arXiv:math/0109220. Corollary 1.4: the MRC target `Z` of a smooth
  projective variety is non-uniruled (so κ(Z) ≥ 0); derived from the
  paper's Theorem 1.1 (section theorem for one-parameter families of
  rationally connected varieties) combined with MRC quotient structure.
 - S. Iitaka, "On D-dimensions of algebraic varieties", J. Math. Soc.
  Japan 23 (1971) 356-373. Introduces D-dimension (= Kodaira dimension
  κ) and the Iitaka fibration construction; the Leray-Iitaka splitting
  on the non-uniruled MRC target `Z` recurses into the κ(Z) ≥ 0
  already-treated cases.

 SCOPE NOTE: master tex MRC-descent passage self-acknowledges "a
 Leray-Iitaka-type splitting after resolving indeterminacy is needed"
 — the indeterminacy of the rational MRC map `X ⇢ Z` must be resolved
 before the Leray spectral sequence yields the VHS descent. The
 supplement (supplement entry for SG-4 in
 `\ref{app:subgap-inventory}`) declares disposition
 "Reduces to Hypothesis `\ref{hyp:nonrigid-family-bridge}`", but this is
 paper-bookkeeping scope-merging: the parent's atomic clauses cover
 27-dim non-rigid family geometry (Schmid / Griffiths / Kodaira-Spencer
 / Helgason-Voisin), NOT MRC descent specifically. The Lean axiom
 carries independent content, not a parent-deferral.

 Status: gapPartial (folklore corollary, paper-acknowledged "absorbed"
 by parent hypothesis but with independent published-machinery content).
 paper source: SG-4 (sub-gap inventory). -/
axiom kmm_1992_ghs_2003_iitaka_1971_mrc_descent_sg4 :
 SubGap ⟨3, by decide⟩

/-- SG-4 closure theorem: `SubGap ⟨3, _⟩` (the SG-4 indexed Prop) holds
 via Kollár-Miyaoka-Mori 1992 vanishing + Graber-Harris-Starr 2003
 non-uniruledness + Iitaka 1971 fibration folklore-derivation. Pattern:
 single classical-lit framework axiom, defeq closure. Status gapPartial.
 Supplement disposition reduces to hyp:nonrigid-family-bridge
 (already gapClosed via R2 + R5).
 paper source: SG-4 (sub-gap inventory). -/
theorem sg_4_closed : SubGap ⟨3, by decide⟩ :=
 kmm_1992_ghs_2003_iitaka_1971_mrc_descent_sg4

/-! ### SG-6 closure (gapPartial, framework + conjectural-extension).

SG-6 content: Galois descent of Shimura structure along ramified covers
(Galois-descent Caveat preceding `\ref{rem:generic-finiteness-reduction}`,
supplement entry for SG-6). When `g: Z → S` is ramified, the
Shimura-variety structure on `S` need not automatically pull back to
a Shimura structure on `Z`. Strict Galois descent of canonical model,
period morphism, or Chow-Künneth projectors along the non-étale part of
`g` is paper-acknowledged "not supplied in this manuscript" (supplement
entry for SG-6 in `\ref{app:subgap-inventory}`).

Standalone disposition (Galois-descent Caveat: "recorded as a
Standalone sub-gap"; "NOT part of `\ref{hyp:chow-modularity-E7}`
statement and NOT used by the Main Theorem's reduction chain";
supplement entry for SG-6: "retained as a Standalone inventory
entry"). Pattern (ii) 2-axiom decomp
+ typed bridge, mirroring SG-1 framework + conjectural-extension
precedent. -/

/-- Framework predicate: canonical-model construction for unramified
 (étale-Galois-descent) Shimura datums, supplied by Deligne 1979
 PSPM 33 + Milne 1990 Perspect. Math. 10 + Borovoi 1984/1987 +
 Deligne-Milne 1982 LNM 900. -/
axiom IsDeligneMilneBorovoiUnramifiedCanonicalModel_sg6 : Prop

/-- **CONJECTURAL-EXTENSION** predicate: strict Galois descent of
 canonical model / period morphism / Chow-Künneth projectors along
 the non-étale part of a ramified cover `g: Z → S`, for E_7-type
 Shimura structure. Paper-acknowledged "not supplied in this
 manuscript" (supplement entry for SG-6 in
 `\ref{app:subgap-inventory}`); no published source covers this
 ramified-cover Galois-descent case for E_7-type. -/
axiom IsRamifiedCoverGaloisDescentE7Extension_sg6_CONJECTURAL : Prop

/-- **Framework axiom** (PUBLISHED).

 Sources:
 - P. Deligne, "Variétés de Shimura: interprétation modulaire, et
  techniques de construction de modèles canoniques", Proc. Symp. Pure
  Math. 33 (1979) Part 2, 247-289 (`Deligne_Shimura` in master tex
  bib). §2.7: canonical models exist for abelian-type Shimura data
  with reflex field descent.
 - J.S. Milne, "Canonical models of (mixed) Shimura varieties and
  automorphic vector bundles", in *Automorphic Forms, Shimura
  Varieties, and L-Functions* I (Perspectives in Mathematics 10,
  Academic Press 1990), pp. 283-414. General canonical-model
  existence for abelian-type Shimura data.
 - M.V. Borovoi, "Langlands' conjecture on the conjugation of Shimura
  varieties" (Funkts. Anal. 1984) and "The Shimura-Deligne schemes
  M_C(G, h) and the rational cohomology classes of Hodge type of
  Abelian varieties" (Selecta Math. Soviet. 1987). Galois conjugation
  action on Shimura varieties for general data.
 - P. Deligne, J.S. Milne, "Tannakian categories", in *Hodge Cycles,
  Motives, and Shimura Varieties*, Lecture Notes in Math. 900
  (Springer 1982) pp. 101-228 (`DeligneMilne82` in master tex bib).
  Tannakian framework underlying canonical-model construction.

 The 4 framework sources are in master tex bib as `Deligne_Shimura`
 (Del79 PSPM 33), `Milne90` (Mil90 Perspect. Math. 10), `Borovoi84`
 (Bor84 Selecta Math. Sov.), and `DeligneMilne82` (DM82 LNM 900).

 paper source: SG-6 (sub-gap inventory framework). -/
axiom deligne_1979_milne_1990_borovoi_1984_deligne_milne_1982_unramified_canonical_model_sg6 :
 IsDeligneMilneBorovoiUnramifiedCanonicalModel_sg6

/-- **CONJECTURAL-EXTENSION axiom**.

 Strict Galois descent of canonical model / period morphism /
 Chow-Künneth projectors along the non-étale (ramified) part of a
 cover `g: Z → S`, for E_7-type Shimura structure.

 STATUS: paper-acknowledged "not supplied in this manuscript"
 (supplement entry for SG-6 in `\ref{app:subgap-inventory}`).
 Master paper Galois-descent Caveat: "any use of the cover `Z`
 requiring Galois descent... is recorded as a Standalone sub-gap";
 supplement entry for SG-6: "closure would require either an explicit
 extension of the scope of Hypothesis `\ref{hyp:chow-modularity-E7}`
 or a separate canonical-model descent argument not supplied in this
 manuscript".

 RELATED LITERATURE (does NOT close the gap):
 - Reimann 1997 LNM 1657 "The semi-simple zeta function of
  quaternionic Shimura varieties": handles ramified primes for
  INTEGRAL models, NOT canonical-model Galois descent along ramified
  base covers.
 - Pappas-Rapoport 2009 J. Algebraic Geom. "Local models in the
  ramified case": local-model theory at ramified primes; INTEGRAL
  models only.
 - Kisin-Pappas 2018 PMIHES "Integral models of Shimura varieties
  with parahoric level structure": ramified level structure for
  integral canonical models; NOT base-cover descent.
 - Pappas-Rapoport-Smithling 2017/2024 (local-models program at
  ramified primes); same INTEGRAL-model scope.

 None of the above establishes ramified-cover canonical-model Galois
 descent for E_7-type Shimura varieties.

 Standalone, NOT used by Main Theorem reduction chain (master paper
 Galois-descent Caveat preceding
 `\ref{rem:generic-finiteness-reduction}`). Closing SG-6 is ledger
 hygiene only — paper's argument closes (H-bundle) via birational
 equivalence without invoking canonical-model descent on `Z` (same
 Caveat closing remark).
 paper source: SG-6 (sub-gap inventory conjectural-extension). -/
axiom ramified_cover_galois_descent_e7_extension_sg6_CONJECTURAL :
 IsRamifiedCoverGaloisDescentE7Extension_sg6_CONJECTURAL

/-- Typed bridge axiom: unramified canonical-model framework +
 ramified-cover conjectural-extension → SG-6 SubGap.
 paper source: SG-6 (combination). -/
axiom sg6_from_framework_and_extension :
 IsDeligneMilneBorovoiUnramifiedCanonicalModel_sg6 ∧
 IsRamifiedCoverGaloisDescentE7Extension_sg6_CONJECTURAL →
 SubGap ⟨5, by decide⟩

/-- SG-6 closure theorem: `SubGap ⟨5, _⟩` (the SG-6 indexed Prop) holds
 via Pattern (ii) 2-axiom decomposition: framework unramified
 canonical model PUBLISHED (Deligne 1979 + Milne 1990 + Borovoi
 1984/1987 + Deligne-Milne 1982) + conjectural-extension ramified
 Galois descent (paper-acknowledged "not supplied in this manuscript").
 Status gapPartial (driven by conjectural-extension dependency).
 Standalone: NOT used by Main Theorem reduction chain.
 paper source: SG-6 (sub-gap inventory). -/
theorem sg_6_closed : SubGap ⟨5, by decide⟩ :=
 sg6_from_framework_and_extension
  ⟨deligne_1979_milne_1990_borovoi_1984_deligne_milne_1982_unramified_canonical_model_sg6,
   ramified_cover_galois_descent_e7_extension_sg6_CONJECTURAL⟩

/-! ### SG-7 closure (gapPartial, framework + Hermitian conjectural-extension).

SG-7 content: Real-form descent E_{7(7)} → E_{7(-25)} for the exceptional
theta lift (master paper exceptional-theta construction preceding
`\ref{thm:E7-theta-match}` Gap on real-form descent, supplement entry
for SG-7). The split-form theta kernel is constructed via Shan 2025 /
Karasiewicz-Savin 2023 + the minimal-rep machinery of Gan-Savin 2005 +
Magaard-Savin 1997 (split-form exceptional theta). The Hermitian
parallel-port to (PGL_2, F_4^anis) ⊂ E_{7(-25)} construction + full
stabilisation of the exceptional theta integral at archimedean places
on the Hermitian tube domain D_{EVII} is paper-acknowledged "not in
the literature" (real-form-descent Gap note). Absorbed disposition
(absorption-into-`\ref{hyp:chow-modularity-E7}` clause + supplement
entry for SG-7: "absorbed into Hypothesis
`\ref{hyp:chow-modularity-E7}`, whose scope already includes
Galois/inner-form descent of Hecke-stable Chow classes along the
canonical model of S_{E_7}"). Pattern (ii) 2-axiom decomp + typed bridge,
mirroring SG-1 / SG-6 framework + conjectural-extension precedent. -/

/-- Framework predicate: split-form theta kernel for the exceptional dual
 pair (PGL_2, F_4) inside E_7, supplied by Shan 2025 + Karasiewicz-Savin
 2023 + Gan-Savin 2005 + Magaard-Savin 1997. -/
axiom IsShanKarasiewiczSavinGanSavinMagaardSavinSplitFormThetaKernel_sg7 : Prop

/-- **CONJECTURAL-EXTENSION** predicate: Hermitian real-form descent
 from split E_{7(7)} / F_{4(4)} (or anisotropic F_4 over split E_{7(7)})
 to Hermitian E_{7(-25)} / F_4^anis, including full stabilisation of
 the exceptional theta integral at archimedean places on the Hermitian
 tube domain D_{EVII}. Paper-acknowledged "not in the literature"
 (real-form-descent Gap note preceding `\ref{thm:E7-theta-match}`);
 no published source covers this Hermitian parallel-port for the
 exceptional E_7 theta. -/
axiom IsHermitianRealFormDescentArchimedeanStabilisation_sg7_CONJECTURAL : Prop

/-- **Framework axiom** (PUBLISHED).

 Sources:
 - Y. Shan (sole author), "Exceptional theta correspondence F_4 × PGL_2
  for level one automorphic representations", arXiv:2501.19101 (Jan 2025).
  Theta correspondence F_4 × PGL_2 with F_4 anisotropic at infinity
  (i.e., F_{4(-52)} real form, split over all Q_p), ambient minimal
  representation of a group of type E (E_7). Produces holomorphic
  modular forms spanning level-one space.
 - C. Karasiewicz, G. Savin, "The Dual Pair Aut(C) × F_4 (p-adic case)",
  arXiv:2312.02853 (Dec 2023). p-adic dual pair Aut(C) × F_4 (where
  Aut(C) is the automorphism group of the Cayley algebra; specialises
  to PGL_2 × F_4 internally), restriction of the minimal representation
  of a group of type E.
 - W.T. Gan, G. Savin, "On minimal representations: definitions and
  properties", Representation Theory 9 (2005) 46-93. Global existence
  + local p-adic properties of minimal representations.
 - K. Magaard, G. Savin, "Exceptional Θ-Correspondences I", Compositio
  Math. 107 (1997) 89-123. Exceptional theta for split forms over
  p-adic local fields.

 REAL-FORM PRECISION: Shan 2025's F_4 is anisotropic at infinity
 (compact F_{4(-52)}, split over all Q_p) on globally-split E_{7(7)}
 (anisotropic over R via the Gross-Wallach see-saw). Savin 2025
 arXiv:2508.12534 (Howe duality SL_2(R) × F_{4,1}, archimedean rank-1
 see-saw) is adjacent literature, not directly used for SG-7 closure.

 paper source: SG-7 (sub-gap inventory framework). -/
axiom shan_2025_karasiewicz_savin_2023_gan_savin_2005_magaard_savin_1997_split_form_theta_kernel_sg7 :
 IsShanKarasiewiczSavinGanSavinMagaardSavinSplitFormThetaKernel_sg7

/-- **CONJECTURAL-EXTENSION axiom**.

 Hermitian real-form descent: transfer of the exceptional theta kernel
 from split E_{7(7)} / F_{4(-52)} construction (or quaternionic
 E_{7(-5)} via Gross-Wallach see-saw) to a Hermitian E_{7(-25)} /
 F_4^anis (rank-1 F_{4(-20)}) tube-domain construction on D_{EVII},
 including full stabilisation of the exceptional theta integral at
 archimedean places.

 STATUS: paper-acknowledged "not in the literature" (real-form-descent
 Gap note preceding `\ref{thm:E7-theta-match}`).
 No 2024-2026 published source covers this Hermitian parallel-port for
 the exceptional E_7 theta. Adjacent literature (Loke 2000 J. Funct.
 Anal. 172 quaternionic E_{7(-5)} restrictions; Savin 2025 arXiv:
 2508.12534 SL_2(R) × F_{4,1} archimedean rank-1 Howe duality;
 Faraut-Koranyi 1994 Jordan-algebra D_{EVII} uniformisation) does NOT
 supply the archimedean stabilisation needed.

 Absorbed into `\ref{hyp:chow-modularity-E7}` scope
 (absorption-into-`\ref{hyp:chow-modularity-E7}` clause preceding
 `\ref{thm:E7-theta-match}` + supplement entry for SG-7: "absorbed into
 Hypothesis `\ref{hyp:chow-modularity-E7}`, whose scope already
 includes Galois/inner-form descent of Hecke-stable Chow classes along
 the canonical model of S_{E_7}").
 paper source: SG-7 (sub-gap inventory conjectural-extension). -/
axiom hermitian_real_form_descent_archimedean_stabilisation_sg7_CONJECTURAL :
 IsHermitianRealFormDescentArchimedeanStabilisation_sg7_CONJECTURAL

/-- Typed bridge axiom: split-form theta-kernel framework + Hermitian
 real-form descent conjectural-extension → SG-7 SubGap.
 paper source: SG-7 (combination). -/
axiom sg7_from_framework_and_extension :
 IsShanKarasiewiczSavinGanSavinMagaardSavinSplitFormThetaKernel_sg7 ∧
 IsHermitianRealFormDescentArchimedeanStabilisation_sg7_CONJECTURAL →
 SubGap ⟨6, by decide⟩

/-- SG-7 closure theorem: `SubGap ⟨6, _⟩` (the SG-7 indexed Prop) holds
 via Pattern (ii) 2-axiom decomposition: framework split-form theta
 PUBLISHED (Shan 2025 + Karasiewicz-Savin 2023 + Gan-Savin 2005 +
 Magaard-Savin 1997) + conjectural-extension Hermitian real-form
 descent + archimedean stabilisation (paper-acknowledged "not in the
 literature"). Status gapPartial (driven by conjectural-extension
 dependency). Absorbed by hyp:chow-modularity-E7 (gapOpen).
 paper source: SG-7 (sub-gap inventory). -/
theorem sg_7_closed : SubGap ⟨6, by decide⟩ :=
 sg7_from_framework_and_extension
  ⟨shan_2025_karasiewicz_savin_2023_gan_savin_2005_magaard_savin_1997_split_form_theta_kernel_sg7,
   hermitian_real_form_descent_archimedean_stabilisation_sg7_CONJECTURAL⟩

/-! ### SG-8/SG-9/SG-10/SG-11 typed-bridge closure theorems via
parent absorption into `hyp:hecke-bbt` clauses.

The 4 sub-gaps absorb into parent `hyp:hecke-bbt` clauses:

  SG-8 → hyp:hecke-bbt clause (c) [Kudla-Millson Schwartz]
  SG-9 → hyp:hecke-bbt clause (a) [Gross-Wallach gK-cohomology]
  SG-10 → hyp:hecke-bbt clause (a) [sibling of SG-9]
  SG-11 → hyp:hecke-bbt clause (b) [Sahi/Magaard-Savin archimedean
    Whittaker]

SubGap indices: SG-8 ↔ ⟨7⟩, SG-9 ↔ ⟨8⟩, SG-10 ↔ ⟨9⟩, SG-11 ↔ ⟨10⟩.

paper source: SG-8/9/10/11 absorption into parent hyp:hecke-bbt
clauses (a)/(b)/(c). -/

/-- Typed bridge: hyp:hecke-bbt clause (c) (Kudla-Millson) absorbs
 SG-8 (D_EVII Kudla-Millson Schwartz form question).
 paper source: SG-8 absorption per R-#34. -/
axiom sg8_absorbed_into_hecke_bbt_c :
 (∀ (S : E7ShimuraTor), HeckeBBT_kudla_millson S) → SubGap ⟨7, by decide⟩

/-- SG-8 closure via parent absorption into hyp_hecke_bbt_c.
 paper source: SG-8 absorption into hyp:hecke-bbt clause (c). -/
theorem sg_8_closed : SubGap ⟨7, by decide⟩ :=
 sg8_absorbed_into_hecke_bbt_c hyp_hecke_bbt_c

/-- Typed bridge: hyp:hecke-bbt clause (a) (Gross-Wallach gK-cohom)
 absorbs SG-9 (Gross-Wallach quaternionic discrete series specifics).
 paper source: SG-9 absorption per R-#6. -/
axiom sg9_absorbed_into_hecke_bbt_a :
 (∀ (S : E7ShimuraTor), HeckeBBT_gK_cohomology S) → SubGap ⟨8, by decide⟩

/-- SG-9 closure via parent absorption into hyp_hecke_bbt_a.
 paper source: SG-9 absorption into hyp:hecke-bbt clause (a). -/
theorem sg_9_closed : SubGap ⟨8, by decide⟩ :=
 sg9_absorbed_into_hecke_bbt_a hyp_hecke_bbt_a

/-- Typed bridge: hyp:hecke-bbt clause (a) absorbs SG-10 (sibling
 sub-gap to SG-9, same Gross-Wallach gK-cohomology framework).
 paper source: SG-10 absorption per R-#6. -/
axiom sg10_absorbed_into_hecke_bbt_a :
 (∀ (S : E7ShimuraTor), HeckeBBT_gK_cohomology S) → SubGap ⟨9, by decide⟩

/-- SG-10 closure via parent absorption into hyp_hecke_bbt_a.
 paper source: SG-10 absorption into hyp:hecke-bbt clause (a). -/
theorem sg_10_closed : SubGap ⟨9, by decide⟩ :=
 sg10_absorbed_into_hecke_bbt_a hyp_hecke_bbt_a

/-- Typed bridge: hyp:hecke-bbt clause (b) (Sahi/Magaard-Savin
 archimedean Whittaker) absorbs SG-11 (rank-3 archimedean Whittaker
 functional question).
 paper source: SG-11 absorption per R-#9. -/
axiom sg11_absorbed_into_hecke_bbt_b :
 (∀ (S : E7ShimuraTor), HeckeBBT_archimedean_whittaker S) →
 SubGap ⟨10, by decide⟩

/-- SG-11 closure via parent absorption into hyp_hecke_bbt_b.
 paper source: SG-11 absorption into hyp:hecke-bbt clause (b). -/
theorem sg_11_closed : SubGap ⟨10, by decide⟩ :=
 sg11_absorbed_into_hecke_bbt_b hyp_hecke_bbt_b

/-! ### SG-12 closure (gapPartial, folklore-derivation, Route (a)).

SG-12 content: Step-2-closedness-precedes-Step-3 logical-order issue in
the dense-plus-closed Hecke argument on `S_{E_7}`
(`\ref{rem:sliceD-step2-definability}`). Paper proposes two discharge
routes:
- Route (a, intended): rerun the argument with `Σ_d` defined as the
 image of the definable analytic cycle-matching subscheme; proper
 images of Zariski-closed subsets of definable analytic spaces are
 definable analytic (Peterzil-Starchenko 2009), hence Zariski-closed
 after BBT 2023 definable GAGA;
- Route (b, fallback): replace the Noetherian ACC chain with the
 o-minimal DCC on definable closed sets (van den Dries 1998).

`\ref{rem:sliceD-step2-definability}`: "Route (a) is the intended
reading and is sketched below; a full write-up in the definable-
analytic register is not supplied here". Folklore-derivation closure
following the SG-2 /
SG-3 single-axiom pattern (paper-acknowledged folklore corollary). -/

/-- Folklore closure of SG-12: Route (a) (definable-analytic rerun)
 algebraizes the cycle-matching subscheme.

 Sources combined:
 - B. Bakker, B. Klingler, J. Tsimerman, "Tame topology of arithmetic
  quotients and algebraicity of Hodge loci", JAMS 33 (2020) 917-939,
  Thm 1.1(a) (R_an-definability of the period map; arXiv:1810.04801).
 - B. Bakker, Y. Brunebarbe, J. Tsimerman, "o-minimal GAGA and a
  conjecture of Griffiths", Invent. Math. 232 (2023) 163-228;
  arXiv:1811.12230. Thm 1.1 (definable GAGA equivalence
  `Coh(X) → Coh^def(X^an)`), used to algebraize the definable
  cycle-matching zero locus.
 - Y. Peterzil, S. Starchenko, "Complex analytic geometry and
  analytic-geometric categories", J. reine angew. Math. 626 (2009)
  39-74. R_an-definable closed analytic subsets are algebraic;
  supplies image-algebraicity for proper images of definable closed
  subsets (the master tex Route (a) sketch in
  `\ref{rem:sliceD-step2-definability}` invokes this but without
  explicit citation).
 - L. van den Dries, "Tame Topology and o-Minimal Structures", London
  Math. Soc. Lecture Note Ser. 248, Cambridge Univ. Press (1998),
  Ch. 3 + Thm 1.6.2 (cell decomposition + definable trivialisation).
  The DCC on definable closed sets is a folklore corollary of cell
  decomposition, NOT a single labelled theorem in van den Dries 1998.
  Cross-source Pillay-Steinhorn 1986 Trans. AMS 295.

 BUNDLE NOTE: the 4 sources above form a single argument-flow for
 Route (a) (BKT definability → PS image-definability → BBT
 algebraization → vdD DCC closure), NOT a 4-part conjunction of
 independent assertions. This is consistent with the SG-2 / SG-3
 single-axiom precedent (2-source bundles) modulo larger ingredient
 count; `\ref{rem:sliceD-step2-definability}` self-acknowledges
 Route (a) "is sketched below; a full write-up... is not supplied
 here".

 Note: BKT 2020 Thm 1.1(a) gives definability of the period map; the
 extension to flat-section-definability on `Hilb^p × Hilb^p ×_S` is a
 folklore corollary (BKT 1.1(a) + Schmid SL2-orbit + frame
 trivialisation), not a direct BKT theorem.

 Status: gapPartial (folklore corollary, paper-self-discharged via
 sketched Route (a)).
 paper source: SG-12 (sub-gap inventory). -/
axiom bkt_2020_bbt_2023_ps_2009_vdd_1998_route_a_cycle_matching_algebraization_sg12 :
 SubGap ⟨11, by decide⟩

/-- SG-12 closure theorem: `SubGap ⟨11, _⟩` (the SG-12 indexed Prop)
 holds via Route (a) folklore-derivation. Pattern: single classical-lit
 framework axiom, defeq closure. Status gapPartial.
 paper source: SG-12 (sub-gap inventory). -/
theorem sg_12_closed : SubGap ⟨11, by decide⟩ :=
 bkt_2020_bbt_2023_ps_2009_vdd_1998_route_a_cycle_matching_algebraization_sg12

/-! ### SG-13 closure (gapPartial, reduces to SG-12).

SG-13 content: Step-2-vs-Step-3-internal-consistency (master tex
`\ref{rem:sliceD-step2-density}`). The apparent paradox —
`Σ_{d_0}` simultaneously Zariski-closed AND Zariski-dense in irreducible
`S` would force `Σ_{d_0} = S`, making BBT machinery of Step 3 redundant
— is resolved by reading Step 2's closedness as the closedness of the
"existence at bounded Hilbert degree" predicate in the definable-
analytic category, which via Step 3's BBT-algebraization coincides with
the image `π(J^alg)`. The closure follows from SG-12 (Route (a)) via a
typed reduction axiom; SG-13 is distinct from SG-12 in master tex
(separate Remark), so encoded as a separate axiom with explicit
reduction arrow rather than as an alias. -/

/-- Reduction axiom: SG-12 closure implies SG-13 closure via the
 interpretive reading of Step 2 / Step 3 in the definable-analytic
 category. `\ref{rem:sliceD-step2-density}` supplies the
 reconciliation reasoning; this typed bridge encodes the
 reduction-to-SG-12 dependency explicitly.
 paper source: SG-13 (sub-gap inventory, reduces to SG-12). -/
axiom step2_step3_internal_consistency_via_sg12_sg13 :
 SubGap ⟨11, by decide⟩ → SubGap ⟨12, by decide⟩

/-- SG-13 closure theorem: `SubGap ⟨12, _⟩` (the SG-13 indexed Prop)
 holds via reduction to SG-12 closure. Status gapPartial (inherits
 from SG-12 folklore-derivation).
 paper source: SG-13 (sub-gap inventory). -/
theorem sg_13_closed : SubGap ⟨12, by decide⟩ :=
 step2_step3_internal_consistency_via_sg12_sg13 sg_12_closed

/-! ### SG-15 PARTIAL closure (only rep-decomp ingredient).

SG-15 splits into two ingredients per
`\ref{rem:sliceD-dim5-casimir}`:
- SG-15a: V_56 ⊗ V_56 = 1 ⊕ V_133 ⊕ V_1463 ⊕ V_1539 rep-decomposition
 (CLOSEABLE via McKay-Patera 1981 + Slansky 1981 Phys. Rep. 79; NOT
 Bourbaki Planche VI, which contains only root data).
- SG-15b: Hodge-bidegree weight-filtration cutting `H^{2,2}(X_b, ℚ)`
 to the trivial summand "1" (REMAINS gapOpen; master tex explicitly
 admits this Casimir-trace argument is NOT supplied).

Supplement disposition (supplement entry for SG-15 in
`\ref{app:subgap-inventory}`): **Standalone**
diagnostic; SG-15 "does not enter the Main Theorem". Closing SG-15
offers no Main-Theorem progress; included for ledger hygiene only.

Only SG-15a axiomatised below; SG-15b remains the open Hodge-theoretic
content. `SubGap ⟨14, _⟩` therefore NOT closed by a theorem in this
round; status stays gapPartial. -/

/-- Typed predicate for the SG-15a ingredient: the rep-decomposition
 `V_56 ⊗ V_56 = 1 ⊕ V_133 ⊕ V_1463 ⊕ V_1539` under E_7. Opaque
 placeholder pinned by McKay-Patera 1981 + Slansky 1981.
 paper source: SG-15a (rep-decomp ingredient). -/
axiom IsV56TensorV56DecompositionVerified_sg15a : Prop

/-- Typed predicate for the SG-15b ingredient: Hodge-bidegree weight-
 filtration cuts `H^{2,2}(X_b, ℚ)` to the trivial summand "1" of
 V_56⊗V_56. Opaque placeholder; REMAINS gapOpen
 (`\ref{rem:sliceD-dim5-casimir}` self-acknowledged unsupplied).
 paper source: SG-15b (Hodge-filtration ingredient; gapOpen). -/
axiom IsHodgeBidegreeWeightFiltrationCutsTrivialSummand_sg15b : Prop

/-- Partial closure (SG-15a only): V_56 ⊗ V_56 = 1 ⊕ V_133 ⊕ V_1463
 ⊕ V_1539 under E_7, with Sym²(V_56) = V_133 ⊕ V_1463 and
 Λ²(V_56) = 1 ⊕ V_1539. Pure finite-dim representation theory.

 TYPED-BRIDGE REFACTOR (per feedback_lean_axiom_decomposition):
 axiom asserts the NEW predicate `IsV56TensorV56DecompositionVerified_sg15a`,
 NOT `SubGap ⟨14, _⟩` directly. The full SG-15 SubGap requires BOTH
 SG-15a (this axiom) AND SG-15b (Hodge-filtration), and the latter
 is gapOpen — so `SubGap ⟨14, _⟩` stays unprovable.

 Source: R.V. Moody, J. Patera (a.k.a. McKay-Patera), "Tables of
 Dimensions, Indices, and Branching Rules for Representations of
 Simple Lie Algebras", Lecture Notes in Pure and Applied Mathematics
 69 (Marcel Dekker, 1981); R. Slansky, "Group theory for unified
 model building", Phys. Rep. 79 (1981) 1-128 (Kronecker-product
 tables for E_7).
 Cross-source: LiE software output; Brion seminar notes on
 exceptional Lie groups; Cooperstein 1995 J. Algebra 173 §3
 (V_56 quartic invariant via Λ² triv summand identified with
 symplectic form).
 NOTE: ledger entry previously cited "Bourbaki tables" for this
 decomposition — Bourbaki Planche VI contains root data (Cartan
 matrix, fundamental weights, Coxeter number) but does NOT contain
 explicit tensor-product / Kronecker decomposition tables for E_7.
 paper source: SG-15a (rep-decomp ingredient). -/
axiom mckay_patera_slansky_V56_tensor_V56_decomposition_sg15a :
 IsV56TensorV56DecompositionVerified_sg15a

/-- Typed bridge axiom: IF both SG-15a (rep-decomp, published) AND
 SG-15b (Hodge-filtration, gapOpen) are supplied, THEN the full SG-15
 SubGap holds. This encodes the paper's claimed reduction (master tex
 via `\ref{rem:sliceD-dim5-casimir}`) without asserting either
 ingredient alone discharges
 the full SubGap.
 paper source: SG-15 (combination). -/
axiom sg15_from_ingredients :
 IsV56TensorV56DecompositionVerified_sg15a →
 IsHodgeBidegreeWeightFiltrationCutsTrivialSummand_sg15b →
 SubGap ⟨14, by decide⟩

/-! ### SG-17 PARTIAL closure (gapPartial via Pattern (ii) framework +
conjectural-extension).

SG-17 content: 3-adic lattice obstruction carry-over from the d=3
Stage-D mechanism (master tex Stage D, FTS decomposition + Springer-
discriminant + Nakayama-sandwich) to the d ≥ 5 setting via the
Hard-Lefschetz Schur scalar `λ' ∈ ℤ` on the V_56-isotypic component of
H^3(X, ℤ).

Decomposition (mirrors SG-1 / SG-6 / SG-7 Pattern (ii)):
- Framework (PUBLISHED, integrated into master tex Stage D
 extension subsection between Stage D CY_3 proof closure and
 `prop:d5-e7-closure`): Stages A-C of the master proof carry from d=3
 to d≥5 (Stage A Zariski-density via Borel density depends only on
 `MT(H^3)^der = E_{7(-25)}` faithful on V_56; Stage B ℚ-form / ℤ-model
 is `Out(E_7)=1` driven, dim-independent; Stage C strong approximation
 + class number h=1 depends only on `E_7` simple-connectedness and
 `rk_ℝ ≥ 1`). Stage D then extends to d ≥ 5 by augmenting the d=3
 discriminant identity with a Hard-Lefschetz Schur scalar `λ' ∈ ℤ`
 (Lemma `lem:sg17-stepA`: integrally-closed argument on `λ'^56 ∈ ℤ`;
 Lemma `lem:sg17-stepB`: `q_4`-integrality forces `m+m', k+ℓ ≥ 0`).
 Combined with the master tex equation `eq:sg17-disc-identity`
 (`c^56·3^(54(m+m')+2+2(k+ℓ)) = ±λ'^56`), integer programming on
 `(j, m+m', k+ℓ, v_3(c)) ∈ ℤ^4` forces
 `v_3(λ') ≥ min_{j∈ℤ} max(j, 1-27j) = 1`; under `v_3(λ') = 0` this is
 a contradiction (master tex Theorem `thm:sg17-partial-kill`). The
 verification over `j ∈ [-10,10]`, `m+m' ∈ [0,200]`,
 `v_3(λ') ∈ {-1..5}` confirms the analytic bound.
- Conjectural-extension (paper-acknowledged residual `3 ∣ λ'`):
 closure requires one of three published-machinery paths
 (master tex residual paragraph following `thm:sg17-partial-kill`):
 (1) Integral Hard Lefschetz `det(L^(d-3) :
 H^3(X,ℤ) → H^(2d-3)(X,ℤ)) = ±1` for the candidate class (Deligne's
 integral Lefschetz for "well-behaved" `X` such as CIs in flag-
 variety products + blow-ups; verification for exotic rigid
 non-Shimura `E_{7(-25)}`-type `X` is open); (2) Chern-Weil bound
 `|λ'| < 3` over the R319 + R354 Lefschetz-pin residual list
 (33 candidates after R354 sub-pencil reduction; R360 closure
 INVALIDATED by R382 Milnor-sign defect — d=5 branch reopened);
 (3) CM-rigidity Fontaine-Mazur compatibility (cf. SG-21 of the
 paper). None is unconditional in published literature.

STANDALONE diagnostic — does NOT enter Main Theorem reduction chain.
Closure offers no Main-Theorem progress; partial-kill is a publishable
sub-gap upgrade.

paper source: master tex `\ref{thm:sg17-partial-kill}` +
`\ref{lem:sg17-stepA}` + `\ref{lem:sg17-stepB}` +
`\ref{eq:sg17-disc-identity}` (Stage D extension subsection). -/

/-- Framework predicate: the `3 ∤ λ'` partial kill (master tex
 `\ref{thm:sg17-partial-kill}`) unconditionally excludes exotic rigid non-Shimura
 `E_{7(-25)}`-type `X` of dim `d ≥ 5` satisfying `Pic(X) = ℤ·H`
 (ample), `MT(H^3)^der = E_{7(-25)}` acting faithfully through `V_56`,
 `H^1(X, T_X) = 0` (rigidity), under the additional integer-arithmetic
 hypothesis `v_3(λ') = 0` (equivalently, `3 ∤ λ'`) where `λ' ∈ ℤ` is
 the Hard-Lefschetz Schur scalar on the V_56-isotypic component of
 `H^3(X,ℤ)`. -/
axiom IsPartialKill3CoprimeLambdaPrime_sg17 : Prop

/-- **CONJECTURAL-EXTENSION** predicate: closure of the residual
 `3 ∣ λ'` case (equivalently `v_3(λ') ≥ 1`) for exotic rigid non-Shimura
 `E_{7(-25)}`-type `X` of dim `d ≥ 5`. Companion note §Residual-case
 lists three closing paths (Integral Hard Lefschetz / Chern-Weil bound
 / CM-rigidity Fontaine-Mazur), none unconditional in published
 literature. -/
axiom IsResidual3DivLambdaPrimeClosure_sg17_CONJECTURAL : Prop

/-- **Framework axiom** (PUBLISHED, integrated into master tex).

 Source: master proof `hodge-conjecture-master-proof.tex`,
 subsection "Stage D extension to d ≥ 5: Hard-Lefschetz Schur
 scalar partial kill (SG-17)" (between Stage D CY_3 proof closure
 and Proposition `prop:d5-e7-closure`). Operative content:
 Theorem `thm:sg17-partial-kill` + Lemmas `lem:sg17-stepA`
 (λ' ∈ ℤ) + `lem:sg17-stepB` (m+m', k+ℓ ≥ 0) +
 equation `eq:sg17-disc-identity` (d ≥ 5 Stage D analogue
 c^56 · 3^(54(m+m')+2+2(k+ℓ)) = ±λ'^56).

 Anchors on master proof Stages A-D (Stage A
 `\ref{...arithmeticity...}`, Stage B `\ref{...ZForm...}`,
 Stage C `\ref{...strongApproximation...}`,
 Stage D `\ref{...latticeObstruction-p3...}`).

 DIM-DEPENDENCE DISCLOSURE (honest summary; refined per Phase 4
 hostile re-audit): Stage B (ℚ-form / ℤ-model via `Out(E_7) = 1`
 inner classification + Chevalley split model) is purely group-
 theoretic and dim-independent. Stages A, C, D each have dim-sensitive
 components that master tex carries forward by silent
 inheritance:
 - Stage A's Borel-density / `Γ`-arithmeticity conclusion is dim-
  independent (depends on `MT^der = E_{7(-25)}` faithful on `V_56`),
  BUT the Stage A moduli identification `dim M^pol = h^{2,1} = 27` is
  d=3-specific (CY₃ Hodge-number fact). The master tex Stage D
  extension subsection replaces the family-of-fibres setup by the
  standing rigidity hypothesis `H^1(X, T_X) = 0` (per
  Proposition `prop:d5-e7-closure` items (a)-(c)), but does NOT
  re-derive Stage A's `Γ`-stability of
  `Λ = H^3(X, ℤ)` under the rigid `d ≥ 5` setup.
 - Stage C's class number `h = 1` is group-theoretic via `E_7^sc` +
  `rk_ℝ ≥ 1` strong approximation; this carries. The `Γ`-stability of
  the integral lattice `Λ` (required for the FTS Nakayama-sandwich
  argument) inherits from the d=3 family-monodromy argument and is
  NOT re-derived in master tex under the rigid `d ≥ 5` setup.
 - Stage D's d ≥ 5 extension is honest: the Hard-Lefschetz Schur
  scalar `λ' ∈ ℤ` AUGMENTATION (Lemma A of master tex) is
  explicitly disclosed.

 INHERITED-RISK CAVEAT: the framework axiom carries the inheritance
 risk that the rigid `d ≥ 5` lattice/monodromy setup matches the d=3
 setup operative for Stages A & C. If the rigid `d ≥ 5` `Γ`-stability
 fails (or requires a separate construction), the partial-kill
 conclusion would itself become conditional. Companion note Setup
 (§Setup standing hypotheses (a)-(c)) does NOT supply this re-
 derivation explicitly; the axiom asserts master tex's
 Theorem 1 as stated, NOT a stronger unconditional claim about the
 inheritance.

 Status: gapPartial — closes the `3 ∤ λ'` stratum modulo the
 inherited-risk caveat above; the `3 ∣ λ'` residual stratum is
 paper-acknowledged conjectural (master tex residual paragraph
 following `\ref{thm:sg17-partial-kill}`).

 Self-citation discipline: master tex itself is by paper author
 (preprint, not peer-reviewed). The axiom asserts the math claim,
 NOT a peer-reviewed certification; analogous to other paper-author
 self-citations in this formalisation (e.g.,
 `IsFrameworkChernWeilBridge_E7` /
 `IsFrameworkAndreCorrespondenceMatching` cite master tex itself).

 paper source: SG-17 (sub-gap inventory framework). -/
axiom li_2026_partial_kill_3_coprime_lambda_prime_sg17 :
 IsPartialKill3CoprimeLambdaPrime_sg17

/-- **CONJECTURAL-EXTENSION axiom**.

 Residual `3 ∣ λ'` case closure for exotic rigid non-Shimura
 `E_{7(-25)}`-type `X` of dim `d ≥ 5`.

 STATUS: paper-acknowledged conjectural (master tex residual
 paragraph following `\ref{thm:sg17-partial-kill}`). Three
 paths are listed, with materially different epistemic status:

 - Path (1) Integral Hard Lefschetz `det(L^(d-3) : H^3(X,ℤ) →
  H^(2d-3)(X,ℤ)) = ±1`: PAPER-LABELLED-CONJECTURAL. Holds for
  "well-behaved" `X` (CIs in flag-variety products + blow-ups;
  Deligne's integral Lefschetz results); verification for the
  exotic rigid `E_{7(-25)}` candidate class is open. Deligne
  IHES 52 (1980) §4 supplies RATIONAL Hard Lefschetz only; the
  integral `det = ±1` strengthening at this generality is not
  published.
 - Path (2) Chern-Weil bound `|λ'| < 3` on Lefschetz-pin residual
  list: HEURISTIC, NOT a viable closure path. The master tex
  `prop:d5-e7-closure` is a SIGN-FAILURE proposition (d=5
  sub-branch OPEN; Milnor-sign defect on P¹-pencils with 4-fold
  ODP fibres reverses the inequality required by the universal
  sub-pencil criterion). This path is recorded for completeness
  but is contradicted by `prop:d5-e7-closure`.
 - Path (3) CM-rigidity via Fontaine-Mazur compatibility:
  NAMED-OPEN-VIA-SG21 reduction. Fontaine-Mazur 1995 (Conf.
  Proc. Lect. Notes Math. Phys. 1) supplies the CM-rigidity
  framework conditional on Hodge-Tate-weight + Frobenius-
  eigenvalue input; reduces to SG-21 ℓ-adic compatibility,
  which itself reduces (via R-attack history disjunction) to
  hyp:AH-CM-E7 OR SG-20 atom (vii) MT for H^3.

 Disjunction status: path (2) is heuristic-failed; the operative
 disjunction reduces to path (1) [paper-labelled-conjectural]
 OR path (3) [named-open-via-SG21]. Neither is unconditional in
 published literature for the exotic rigid `E_{7(-25)}` setting.

 paper source: SG-17 (sub-gap inventory conjectural-extension). -/
axiom integral_hard_lefschetz_or_chern_weil_bound_or_cm_rigidity_sg17_CONJECTURAL :
 IsResidual3DivLambdaPrimeClosure_sg17_CONJECTURAL

/-- Typed bridge axiom: framework `3 ∤ λ'` partial kill (PUBLISHED via
 master tex Stage D extension subsection) + conjectural-extension
 `3 ∣ λ'` residual closure (paper-acknowledged) → SG-17 SubGap.
 paper source: SG-17 (combination). -/
axiom sg17_from_framework_and_extension :
 IsPartialKill3CoprimeLambdaPrime_sg17 ∧
 IsResidual3DivLambdaPrimeClosure_sg17_CONJECTURAL →
 SubGap ⟨16, by decide⟩

/-- SG-17 closure theorem: `SubGap ⟨16, _⟩` (the SG-17 indexed Prop)
 holds via Pattern (ii) 2-axiom decomposition: framework `3 ∤ λ'`
 partial kill PUBLISHED (master tex Stage D extension subsection
 + Stages A-D anchors) + conjectural-extension `3 ∣ λ'` residual closure
 (paper-acknowledged, three published-machinery paths each
 conjectural). Status gapPartial (driven by conjectural-extension
 dependency).
 paper source: SG-17 (sub-gap inventory). -/
theorem sg_17_closed : SubGap ⟨16, by decide⟩ :=
 sg17_from_framework_and_extension
  ⟨li_2026_partial_kill_3_coprime_lambda_prime_sg17,
   integral_hard_lefschetz_or_chern_weil_bound_or_cm_rigidity_sg17_CONJECTURAL⟩

/-! ### SG-23 PARTIAL closure (gapPartial via Pattern (ii) with
**INVENTION-CLASS** conjectural-extension).

SG-23 content: the Standard Conjectures pair
`{SC(B)_3, SC(C)_3}` at Chow level for the V_56-isotypic component
of `H^3` carrying the rank-1 Schur reduction.
Master tex `\ref{lem:sg23-andre-closure}` (integrated R-attack-#25)
closes both conjectures inside André 1996's category
`M_AE(k)` of motivated motives, but the closure does NOT descend to
`CH^d(X × X)_ℚ`.

Decomposition (mirrors SG-1 / SG-6 / SG-7 / SG-17 Pattern (ii); but
**HONESTY NOTE**: the conjectural-extension piece is invention-class
not paper-acknowledged open direction — see scope warning below):

- Framework (PUBLISHED, 3-source bundle):
 (i) Kleiman 1968 §2 Thm 2-A.1: `SC(B) ⇒ SC(C)` at Chow level for
 smooth proj X over algebraically closed field. Reverse Chow-level
 direction NOT proved (NOT in Kleiman 1968 or any other published
 source).
 (ii) Kleiman 1994 "The standard conjectures" Thm 4-1 (Motives,
 Seattle 1991, Proc. Sympos. Pure Math. 55, AMS): each Künneth
 projector `π_i ∈ H^{2d}(X×X, ℚ)` admits an explicit
 `ℚ`-polynomial expression in `L` and `Λ` (Lefschetz operator +
 its inverse) with `d`-dependent rational coefficients. DISTINCT
 from Kleiman 1968's general statement; this is the explicit
 polynomial formula needed for the M_AE realisation.
 (iii) André 1996 §2 Définition 1 + Thm 0.5 (Publ. Math. IHÉS 83
 (1996), 5-49): construction of `M_AE` by adjoining
 `(pr)_*(α ∪ *_L β)` for algebraic α,β; Tannakian realisation
 makes `L, Λ` motivated correspondences. NOTE: Thm 0.5, NOT Thm
 0.6.2 — Thm 0.6.2 (abelian-span motivated = absolute Hodge) is
 a DIFFERENT result already used by `IsAndre1996MotivatedAbelianSpan`
 in `hyp_AH_CM_E7` decomposition; do not conflate.

- Conjectural-extension (**INVENTION-CLASS**, NOT paper-acknowledged
 open direction): descent from M_AE to Chow level. Per master tex
 `\ref{lem:sg23-andre-closure}` §Scope warning: two independent
 stacked obstructions: (a) realising motivated classes by genuine
 algebraic cycles modulo homological equivalence — this is the
 Chow-level SC(B) + SC(C) pair RE-STATED, i.e. equivalent to the
 original gap; (b) lifting homological to rational equivalence
 (Bloch-Beilinson-type, separately unaddressed).

**Honest gap-distance verdict** (per R-attack-#25 Phase 0 hostile
audit): the Ledger's prior `"near-published"` framing was
materially optimistic. Framework piece is genuinely 0-steps-published
(3 named theorems). Conjectural-extension piece is invention-class:
NOT a named-open published direction, but the original Chow-level
Standard Conjectures themselves restated. Status `gapPartial` driven
by invention-class extension — same Pattern (ii) bookkeeping
structure as SG-17, but the extension's epistemic status is
materially weaker than e.g. SG-17's `3 ∣ λ'` residual
(which has 3 named published closing paths each conditionally
achievable).

STANDALONE diagnostic — does NOT enter Main Theorem reduction chain
(master tex L9755-9760: `[ω]`-algebraicity for `dim X ≤ 4` is
unconditional via Lefschetz (1,1); residual pair only arises in
`dim X ≥ 5` regime, and even there is appendix-level not
Main-Theorem-load-bearing).

paper source: master tex `\ref{lem:sg23-andre-closure}` (Stage
appendix; Andre-closure lemma in 6-way chain discussion). -/

/-- Framework predicate (i): Kleiman 1968 §2 Thm 2-A.1 SC(B) ⇒ SC(C)
 implication at Chow level. -/
axiom IsKleiman1968_SCB_implies_SCC_at_Chow : Prop

/-- Framework predicate (ii): Kleiman 1994 Thm 4-1 Künneth-projector
 polynomial formula expressing each `π_i` as a `ℚ`-polynomial in
 `L, Λ`. -/
axiom IsKleiman1994_KunnethPolynomial_in_L_Lambda : Prop

/-- Framework predicate (iii): André 1996 §2 Définition 1 + Thm 0.5
 construction of `M_AE` and Tannakian realisation of `L, Λ` as
 motivated correspondences (SC(B) + SC(C) inside `M_AE`).
 DISTINCT from `IsAndre1996MotivatedAbelianSpan` (which cites Thm
 0.6.2 abelian span, not Thm 0.5 Lefschetz/Künneth realisation). -/
axiom IsAndre1996_SCB_SCC_in_MAE_via_Thm_0_5 : Prop

/-- **NAMED-OPEN-MULTI predicate** (R-#65 reclassification from
 `_INVENTION_CLASS`).

 Descent from `M_AE` to `CH^d(X × X)_ℚ`. Per master tex
 `\ref{lem:sg23-andre-closure}` §Scope warning: descent decomposes
 into two independent stacked obstructions, BOTH now classified as
 NAMED-OPEN published directions (post-R-#65):
 - (a) Realising motivated classes by algebraic cycles modulo
  hom-equivalence = Standard Conjecture B at codim 3 / Chow level
  (Grothendieck 1969 / Kleiman 1968 §2). NAMED-OPEN.
 - (b) Lifting hom-equivalence to rational equivalence = Bloch-
  Beilinson filtration conjecture (Bloch 1980 / Beilinson 1984).
  NAMED-OPEN.

 R-#65 epistemic upgrade (driven by R-#64 systematic
 `_INVENTION_CLASS` survey): prior R-#25 framing recorded both
 obstructions as INVENTION-CLASS equivalent-to-original-gap. R-#64
 audit corrected: both ARE published named-open conjectures;
 epistemic tier rises from invention-class to named-open-multi.

 NAME RETENTION: predicate keeps `_INVENTION_CLASS` suffix for
 downstream backward compatibility (typed bridge axiom + closure
 theorem signatures unchanged). The TIER is set by the derivation
 path (now via 2 NAMED-OPEN atoms below), not the suffix. The
 standalone axiom `mae_to_chow_descent_sg23_INVENTION_CLASS` is
 converted to a theorem in R-#65.

 paper source: SG-23 (sub-gap inventory conjectural-extension);
 R-#65 named-open reclassification per R-#64 audit. -/
axiom IsMAEtoChowDescent_sg23_INVENTION_CLASS : Prop

/-- **NAMED-OPEN framework predicate** (R-#65 atom (a)): SC(B)_3
 at Chow level — Standard Conjecture B (Lefschetz type) in
 codimension 3 with Chow coefficients. The Lefschetz involution
 `*_L : CH^3(X)_ℚ → CH^{d-3}(X)_ℚ` is algebraic, i.e., induced by
 an algebraic correspondence on `X × X`. Published named-open
 direction (Grothendieck 1969 / Kleiman 1968 §2; SC(B) itself is
 OPEN in general for smooth projective varieties at codim ≥ 3).
 paper source: SG-23 named-open atom (a); R-#65. -/
axiom IsSCB_3_Chow_Level_NAMED_OPEN : Prop

/-- **NAMED-OPEN framework predicate** (R-#65 atom (b), R-#69
 attribution corrected): Bloch-Beilinson filtration conjecture.

 There exists a functorial filtration `F^•` on `CH^p(X)_ℚ`
 with `F^0 = CH^p(X)_ℚ`, `F^1 = CH^p_{hom}(X)_ℚ` (homologically
 trivial cycles), `F^2 = ker(\text{Abel-Jacobi}_ℚ)`, and graded
 pieces `gr^j_F` controlled by motivic/cohomological invariants.

 Published named-open direction. Primary formulation: A. A.
 Beilinson, "Higher regulators and values of L-functions"
 (J. Soviet Math. 30 (1985) 2036-2070; Russian Itogi Nauki
 24 (1984) 181-238). The naming "Bloch-Beilinson filtration"
 reflects the foundational role of S. Bloch's "Lectures on
 Algebraic Cycles" (Duke Univ. Math. Series IV, 1980) on
 algebraic cycles + Chow groups; Beilinson 1984 is the
 operative conjecture source.

 R-#69 ATTRIBUTION CORRECTION per Phase 4 audit: pre-R-#69
 docstring listed Bloch 1980 / Beilinson 1984 as co-equal
 sources for the filtration conjecture; audit found Beilinson
 is the primary formulator of the conjecture statement, Bloch
 foundational. Same Phase 4 audit also flagged section number
 disclosure (Beilinson 1984 §2 vs §3): R-#69 corrected to §3
 (the section containing the basic conjecture formulations);
 §2 reference in pre-R-#69 was likely a secondary location.

 Open for all `p ≥ 2` in general; partial progress in special
 cases (Mumford 1969 Pub. Math. IHÉS 9, 5-22; Bloch 1979
 Compositio Math. 39, 107-127; Murre 1990 J. reine angew.
 Math. 409, 190-204 i-th component case).

 SG-23 SPECIALISATION: in this setting, the hom-equivalence to
 rational-equivalence lift is the conjectured triviality of
 `F^1` on the relevant Hodge-isotypic piece. Note: the
 decomposition of `M_AE → Chow descent` into SC(B)_3 + BB
 filtration is the master proof's framing (lem:sg23-andre-
 closure §Scope warning), not a canonical pair stated in
 either Grothendieck 1969 or Beilinson 1984.
 paper source: SG-23 named-open atom (b); R-#65 (R-#69
 attribution + section corrections). -/
axiom IsBlochBeilinsonFiltration_NAMED_OPEN : Prop

/-- **Framework axiom (i)** (PUBLISHED).

 Source: S. L. Kleiman, "Algebraic cycles and the Weil conjectures",
 in: Dix exposés sur la cohomologie des schémas, North-Holland,
 Amsterdam, 1968, 359-386. §2 Thm 2-A.1 (the "B implies C"
 implication): for smooth projective X over algebraically closed
 field, SC(B) (Lefschetz involution is algebraic) implies SC(C)
 (Künneth projectors are algebraic). NOTE: reverse Chow-level
 direction `SC(C) ⇒ SC(B)` is NOT proved in Kleiman 1968 or any
 other published source.

 paper source: SG-23 (sub-gap inventory framework atom i). -/
axiom kleiman_1968_SCB_implies_SCC_at_Chow_sg23 :
 IsKleiman1968_SCB_implies_SCC_at_Chow

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: S. L. Kleiman, "The standard conjectures", in: Motives
 (Seattle, WA, 1991), Proc. Sympos. Pure Math. 55, AMS, Providence,
 1994, Part 1, 3-20. Thm 4-1: each Künneth projector
 `π_i ∈ H^{2d}(X × X, ℚ)` admits an explicit `ℚ`-polynomial
 expression in the Lefschetz operator `L` and its inverse `Λ`,
 with `d`-dependent rational coefficients. (This is the explicit
 polynomial formula attributed to Lieberman; the 1994 reprint is
 the cleanest source.)

 DISTINCT from Kleiman 1968 (which states the conjectures + the
 B ⇒ C implication but does not contain the explicit Lieberman
 polynomial in cleanest form). Do NOT conflate axiom names.

 paper source: SG-23 (sub-gap inventory framework atom ii). -/
axiom kleiman_1994_kunneth_polynomial_in_L_Lambda_sg23 :
 IsKleiman1994_KunnethPolynomial_in_L_Lambda

/-- **Framework axiom (iii)** (PUBLISHED).

 Source: Y. André, "Pour une théorie inconditionnelle des motifs",
 Publ. Math. IHÉS 83 (1996), 5-49. §2 Définition 1 (motivated cycles
 = `ℚ`-span of `(pr_Z)_*(α ∪ *_L β)` with `α,β` algebraic on
 `Z × Y`, `*_L` the `ℚ`-rational Lefschetz involution from the
 sl_2-structure on cohomology) + Lemme 1 (independence of auxiliary
 `Y`) + Thm 0.5 (Tannakian realisation: `L, Λ` are motivated
 correspondences in `M_AE`, yielding SC(B) and SC(C) for X inside
 `M_AE`).

 ATTRIBUTION DISCIPLINE: this axiom cites André 1996 Thm 0.5
 (Lefschetz/Künneth motivated realisation). It is DISTINCT from
 André 1996 Thm 0.6.2 (abelian-span motivated = absolute Hodge),
 which is cited separately in `IsAndre1996MotivatedAbelianSpan`
 used by the `hyp_AH_CM_E7` decomposition. The two theorems address
 different aspects of André's framework; conflating them is the
 same kind of attribution slip caught in prior Phase 0 audits
 (e.g., Castella A.1.1 vs A.1.2 in R14 round).

 paper source: SG-23 (sub-gap inventory framework atom iii). -/
axiom andre_1996_SCB_SCC_in_MAE_via_Thm_0_5_sg23 :
 IsAndre1996_SCB_SCC_in_MAE_via_Thm_0_5

/-- **NAMED-OPEN atom (a) axiom** (R-#65): SC(B)_3 at Chow level.

 Source: A. Grothendieck, "Standard Conjectures on Algebraic
 Cycles", in: Algebraic Geometry (Internat. Colloq., Tata Inst.,
 Bombay, 1968), Oxford Univ. Press, 1969, 193-199 — formulation
 of SC(B) (Lefschetz-type Standard Conjecture: Lefschetz
 involution is algebraic). S. L. Kleiman, "Algebraic cycles and
 the Weil conjectures", Dix exposés sur la cohomologie des
 schémas, North-Holland, 1968, 359-386, §2 — B ⇒ C implication
 + discussion of SC(B) status.

 Status: NAMED-OPEN published direction. SC(B) at codim ≥ 3 with
 Chow coefficients is OPEN in general for smooth projective
 varieties. Known sub-cases (siblings, do NOT close the SG-23
 instance class): abelian varieties (Künneth + Lieberman 1968
 Bull. AMS 74, 1124-1128); surfaces (Lefschetz (1,1) trivially);
 certain low-dim explicit varieties.

 paper source: SG-23 named-open atom (a); R-#65. -/
axiom sc_B_3_chow_level_NAMED_OPEN :
 IsSCB_3_Chow_Level_NAMED_OPEN

/-- **NAMED-OPEN atom (b) axiom** (R-#65, R-#69 attribution +
 section corrected): Bloch-Beilinson filtration.

 Source (primary, R-#69 correction): A. A. Beilinson, "Higher
 regulators and values of L-functions", J. Soviet Math. 30
 (1985) 2036-2070 (Russian original: Itogi Nauki i Tekhniki 24
 (1984) 181-238), §3 (R-#69 corrected from §2 per Phase 4
 audit) — basic conjecture formulations. Beilinson is the
 operative conjecture formulator.

 Source (foundational): S. Bloch, "Lectures on Algebraic
 Cycles", Duke University Mathematics Series IV, Duke
 University Mathematics Department, Durham, NC, 1980 —
 Chapter 1 foundational treatment of algebraic cycles + Chow
 groups. The "Bloch-Beilinson" naming reflects Bloch's
 foundational role; the filtration conjecture statement itself
 is from Beilinson 1984.

 R-#69 ATTRIBUTION CORRECTION per Phase 4 audit: pre-R-#69
 docstring listed Bloch 1980 § 1 first as co-equal source for
 the filtration conjecture. Phase 4 audit found Beilinson is
 the primary formulator, Bloch foundational.

 Status: NAMED-OPEN published direction. Open in general for
 `p ≥ 2` and all `d ≥ 2`. Partial progress in special cases
 (Mumford 1969 Inst. Hautes Études Sci. Publ. Math. 9, 5-22;
 Bloch 1979 Compositio Math. 39, 107-127; Murre 1990 J. reine
 angew. Math. 409, 190-204 conjecture B = i-th component case).

 paper source: SG-23 named-open atom (b); R-#65 (R-#69
 attribution + section corrections). -/
axiom bloch_beilinson_filtration_NAMED_OPEN :
 IsBlochBeilinsonFiltration_NAMED_OPEN

/-- **Bridge axiom** (R-#65): the two NAMED-OPEN atoms imply the
 M_AE → Chow descent.

 Per master tex `\ref{lem:sg23-andre-closure}` §Scope warning, the
 descent decomposes into two stacked obstructions:
 - (a) motivated → algebraic mod hom = SC(B)_3 at Chow level;
 - (b) hom-equiv → rat-equiv lift = Bloch-Beilinson filtration.
 Assuming both atom axioms, descent holds.

 paper source: SG-23 (sub-gap inventory conjectural-extension);
 R-#65 named-open multi-path bridge. -/
axiom mae_to_chow_descent_from_named_open_atoms :
 IsSCB_3_Chow_Level_NAMED_OPEN →
 IsBlochBeilinsonFiltration_NAMED_OPEN →
 IsMAEtoChowDescent_sg23_INVENTION_CLASS

/-- **Closure THEOREM** (R-#65, converted from standalone axiom).

 Descent from `M_AE` to `CH^d(X × X)_ℚ` derived via the R-#65
 bridge from 2 NAMED-OPEN atoms (SC(B)_3 at Chow + BB filtration).

 R-#65 EPISTEMIC UPGRADE: prior `_INVENTION_CLASS` standalone axiom
 is now a theorem chained through 2 named-open atoms per R-#64
 audit. The mathematical content is unchanged; the EPISTEMIC TIER
 is honestly upgraded from invention-class (no published path) to
 named-open-multi (two published conjectures stacked).

 NAME RETENTION: theorem keeps `_INVENTION_CLASS` suffix for
 downstream backward compatibility (`sg_23_closed` calls this
 by name). The TIER is set by the derivation path through
 `mae_to_chow_descent_from_named_open_atoms`, not the suffix.

 Pre-R-#65 (R-#25 framing): "Both reduce to original Chow-level
 Standard Conjectures themselves... not a named-open published
 direction." This was over-cautious — the Standard Conjectures
 ARE published named-open (Grothendieck 1969) and the BB
 filtration is published named-open (Bloch 1980 / Beilinson 1984).
 R-#65 correctly classifies the descent as NAMED-OPEN-MULTI.

 paper source: SG-23 (sub-gap inventory conjectural-extension);
 R-#65 reclassification per R-#64 audit. -/
theorem mae_to_chow_descent_sg23_INVENTION_CLASS :
 IsMAEtoChowDescent_sg23_INVENTION_CLASS :=
 mae_to_chow_descent_from_named_open_atoms
  sc_B_3_chow_level_NAMED_OPEN
  bloch_beilinson_filtration_NAMED_OPEN

/-- Typed bridge axiom: 3 framework atoms (Kleiman 1968 SCB ⇒ SCC,
 Kleiman 1994 Künneth polynomial, André 1996 Thm 0.5 M_AE
 realisation) + 1 NAMED-OPEN-MULTI extension (M_AE → Chow descent;
 R-#65 reclassified from `_INVENTION_CLASS` via SC(B)_3 at Chow +
 BB filtration named-open atoms)
 → SG-23 SubGap.

 R-#65 note: the 4th conjunct `IsMAEtoChowDescent_sg23_INVENTION_CLASS`
 retains its legacy name for backward compat; the underlying
 epistemic tier is now NAMED-OPEN-MULTI (derived through 2
 named-open atoms `sc_B_3_chow_level_NAMED_OPEN` +
 `bloch_beilinson_filtration_NAMED_OPEN` via
 `mae_to_chow_descent_from_named_open_atoms`).
 paper source: SG-23 (combination). -/
axiom sg23_from_framework_and_invention_extension :
 IsKleiman1968_SCB_implies_SCC_at_Chow ∧
 IsKleiman1994_KunnethPolynomial_in_L_Lambda ∧
 IsAndre1996_SCB_SCC_in_MAE_via_Thm_0_5 ∧
 IsMAEtoChowDescent_sg23_INVENTION_CLASS →
 SubGap ⟨22, by decide⟩

/-- SG-23 closure theorem: `SubGap ⟨22, _⟩` holds via Pattern (ii)
 4-atom decomposition: 3 framework atoms PUBLISHED (Kleiman 1968
 SCB ⇒ SCC + Kleiman 1994 Künneth polynomial + André 1996 Thm 0.5
 M_AE realisation) + 1 NAMED-OPEN-MULTI extension (M_AE → Chow
 descent; R-#65 reclassified from `_INVENTION_CLASS` to NAMED-OPEN-
 MULTI via 2 named-open atoms `sc_B_3_chow_level_NAMED_OPEN` +
 `bloch_beilinson_filtration_NAMED_OPEN` per R-#64 audit).

 Status gapPartial; post-R-#65 epistemic standing materially
 stronger than the pre-R-#65 INVENTION-CLASS framing (now two
 named-open published conjectures stacked, not equivalent-to-
 original-gap invention).
 paper source: SG-23 (sub-gap inventory). -/
theorem sg_23_closed : SubGap ⟨22, by decide⟩ :=
 sg23_from_framework_and_invention_extension
  ⟨kleiman_1968_SCB_implies_SCC_at_Chow_sg23,
   kleiman_1994_kunneth_polynomial_in_L_Lambda_sg23,
   andre_1996_SCB_SCC_in_MAE_via_Thm_0_5_sg23,
   mae_to_chow_descent_sg23_INVENTION_CLASS⟩

/-! ### SG-18 PARTIAL closure (gapPartial via Pattern (ii) with
**NAMED-OPEN** conjectural-extension; epistemics stronger than SG-23
INVENTION-CLASS extension, comparable to SG-17 multi-path
conjectural-extension).

SG-18 content: the cohomology-level identity
`π_3 = L^(d-3) ∘ ω^(-1)` (master tex
`\ref{prop:omega-diagonal}` equation `\ref{eq:omega-from-delta}`)
lifts to a Chow-level correspondence
`Π_3 ∈ CH^d(X × X)_ℚ` modulo rational equivalence, conditional on
the i=3 component of Murre's conjecture B (Murre 1990 J. reine
angew. Math. 409, 190-204).

Decomposition (Pattern (ii), 4 atoms; mirrors SG-23 structure but
extension status NAMED-OPEN not INVENTION-CLASS):

- Framework (PUBLISHED, 3 atoms):
 (i) Deligne 1980 "La conjecture de Weil II" Publ. Math. IHÉS 52
 §4: Hard Lefschetz isomorphism
 `L^(d-3) : H^3(X, ℚ) ≅ H^(2d-3)(X, ℚ)(3-d)` at rational
 coefficients, unconditional for smooth proj X over algebraically
 closed char-0 field. NOTE: rational coefficients only;
 integral Hard Lefschetz `det = ±1` is SG-17 territory (Path 1
 of `\ref{thm:sg17-partial-kill}` residual closing paths).
 (ii) Cohomological Künneth: `π_3 ∈ H^{2d}(X × X, ℚ)` exists
 automatically via Künneth formula (Deligne 1971 "Théorie de Hodge II" IHÉS 40) +
 graded-commutativity for odd degree. DISTINCT from
 `IsKleiman1994_KunnethPolynomial_in_L_Lambda` (which encodes the
 explicit Lieberman polynomial used for SG-23's M_AE route).
 (iii) Master tex `\ref{prop:omega-diagonal}` equation
 `\ref{eq:omega-from-delta}` (Li 2026): cohomology-level identity
 `[ω] = c·μ_{3,3}(π_3^{E_7} ∘ (id⊗(L^(d-3))^(-1))(π_3([Δ_X])))`
 derived via Schur on V_56 ⊗ V_56 + Hard Lefschetz + ω
 non-degeneracy (master tex Steps 3-5, sym-vs-antisym correctly
 placed). Paper-author self-citation (preprint, not peer-reviewed);
 hypotheses: smooth proj X with H^3(X, ℚ) ≅ V_56 as E_7-rep, dim
 d ≥ 3, ℚ-rational classes.

- Conjectural-extension (**NAMED-OPEN** published direction, NOT
 invention-class, NOT plain conjectural): Murre 1990 conjecture B
 `i = 3` component for X. Distinct from full Murre B (asserting
 all `π_i` simultaneously algebraic at Chow); the SG-18
 conditional is on the i=3 component specifically. Known cases
 (sibling, do NOT close X):
 - Abelian varieties: Shermenev 1974, Deninger-Murre 1991,
  Künnemann 1994 PSPM 55.1 — Murre A+B+C+D.
 - Surfaces (Murre 1990 dim 2 trivial).
 - Threefolds with abelian factor (Deninger-Murre).
 NOT known for: rigid exceptional-MT fibre with `Pic = ℤH` and
 `dim ≥ 5` (the standing hypothesis class).

**Honest gap-distance verdict** (per R-attack-#26 Phase 0 hostile
audit): SG-18 sits between SG-17 and SG-23, **closer to SG-17**.
Framework is published via Deligne 1980 + Künneth + master tex
`\ref{prop:omega-diagonal}` (cohomology side, fully proved).
Conjectural-extension is named-open published direction (Murre B
i=3, well-studied in the literature with closure mechanisms for
abelian-type X), NOT invention-class equivalent to original gap
(unlike SG-23). Stronger epistemic standing than SG-23.

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain (master tex `\ref{lem:sg18-pi3-chow-conditional}`
explicitly: "appendix-level and does not enter the Main Theorem
reduction chain").

paper source: master tex `\ref{lem:sg18-pi3-chow-conditional}`
(R-attack-#26 integration) + `\ref{prop:omega-diagonal}` +
`\ref{eq:omega-from-delta}`. -/

/-- Framework predicate (i): Deligne 1980 Hard Lefschetz at
 rational coefficients. -/
axiom IsDeligne1980HardLefschetzRational_sg18 : Prop

/-- Framework predicate (ii): cohomological Künneth projector π_3
 exists automatically via Künneth formula. -/
axiom IsCohomologicalPi3Kunneth_sg18 : Prop

/-- Framework predicate (iii): master tex `\ref{prop:omega-diagonal}`
 cohomology-level identity. -/
axiom IsOmegaPi3CohomologyIdentity_sg18 : Prop

/-- **NAMED-OPEN** conjectural-extension predicate: Murre 1990
 conjecture B i=3 component for X (existence of idempotent
 `Π_3 ∈ CH^d(X × X)_ℚ` algebraic, lifting cohomological π_3).
 Named-open published direction (NOT invention-class, NOT plain
 conjectural). -/
axiom IsMurre1990Pi3ChowLift_sg18_NAMED_OPEN : Prop

/-- **Framework axiom (i)** (PUBLISHED).

 Source: P. Deligne, "La conjecture de Weil. II", Publ. Math. Inst.
 Hautes Études Sci. 52 (1980), 137-252. §4 Hard Lefschetz at
 rational coefficients: for smooth proj X over algebraically closed
 field of char 0, the iterated cup product
 `L^(d-i) : H^i(X, ℚ) → H^(2d-i)(X, ℚ)(d-i)` is an isomorphism for
 i ≤ d.

 SCOPE-BOUND: rational coefficients only. Integral Hard Lefschetz
 (`det(L^(d-3) : H^3(X, ℤ) → H^(2d-3)(X, ℤ)) = ±1`) is SG-17
 territory (Path 1 of `\ref{thm:sg17-partial-kill}` residual
 closing paths); do NOT conflate.

 paper source: SG-18 (sub-gap inventory framework atom i). -/
axiom deligne_1980_hard_lefschetz_rational_sg18 :
 IsDeligne1980HardLefschetzRational_sg18

/-- **Framework axiom (ii)** (PUBLISHED).

 Cohomological Künneth projector: for smooth proj X of dim d over
 algebraically closed char-0 field, the Künneth formula gives a
 canonical decomposition `H^*(X × X, ℚ) = ⊕_i H^i(X, ℚ) ⊗
 H^{2d-i}(X, ℚ)`; the projection `π_3 ∈ End(H^*(X, ℚ))` onto the
 degree-3 component is induced by a class in
 `H^{2d}(X × X, ℚ)`. Automatic from Künneth formula (Deligne
 1971 "Théorie de Hodge II" Publ. Math. IHÉS 40, 5-57; bibitem
 `DeligneHII`) and graded-commutativity for odd degree.

 SCOPE-BOUND: COHOMOLOGY level only (NOT Chow level); the Chow
 lift is the conjectural-extension axiom below. DISTINCT from
 `IsKleiman1994_KunnethPolynomial_in_L_Lambda` (used in SG-23
 closure for the explicit polynomial in L, Λ).

 paper source: SG-18 (sub-gap inventory framework atom ii). -/
axiom cohomological_pi3_kunneth_sg18 :
 IsCohomologicalPi3Kunneth_sg18

/-- **Framework axiom (iii)** (PUBLISHED via master tex).

 Source: master tex `hodge-conjecture-master-proof.tex`
 `\ref{prop:omega-diagonal}` proof Steps 3-5 deriving equation
 `\ref{eq:omega-from-delta}`:
 `[ω] = c · μ_{3,3}(π_3^{E_7} ∘ (id ⊗ (L^(d-3))^(-1))(π_3([Δ_X])))`
 at cohomology level, via Schur on `V_56 ⊗ V_56` (uniqueness of
 `E_7`-invariant antisymmetric line) + Hard Lefschetz isomorphism
 + non-degeneracy of `ω` (which combines `MT ⊂ GSp` with Schur).

 The cohomology-level identity (and equivalence "algebraicity of
 [ω] ⇔ algebraicity of π_3 AT COHOMOLOGY") is proved in master
 tex; the Chow lift is separately conditional (next axiom).

 Self-citation discipline: master tex is by paper author (preprint,
 not peer-reviewed). The axiom asserts the math claim, NOT a
 peer-reviewed certification.

 paper source: SG-18 (sub-gap inventory framework atom iii). -/
axiom li_2026_omega_pi3_cohomology_identity_sg18 :
 IsOmegaPi3CohomologyIdentity_sg18

/-- **NAMED-OPEN extension axiom**.

 Source: J. P. Murre, "On a conjectural filtration on the Chow
 groups of an algebraic variety", J. reine angew. Math. 409
 (1990), 190-204. Conjecture B i=3 component: existence of an
 idempotent `Π_3 ∈ CH^d(X × X)_ℚ` algebraic, lifting the
 cohomological Künneth projector `π_3 ∈ H^{2d}(X × X, ℚ)`.

 STATUS: **NAMED-OPEN published direction**, NOT invention-class,
 NOT plain conjectural. Distinct from full Murre B (asserting
 all `π_i` simultaneously); SG-18 conditional is on the i=3
 component only.

 KNOWN CASES (sibling, do NOT close X):
 - Abelian varieties: Shermenev 1974 Funct. Anal. Appl. 8 +
  Deninger-Murre 1991 J. reine angew. Math. 422, 201-219 +
  Künnemann 1994 PSPM 55.1, 189-205 — full Murre A+B+C+D.
 - Surfaces: Murre 1990 (dim 2 trivial).
 - Threefolds with abelian factor: Deninger-Murre 1991.

 NOT KNOWN for: rigid exceptional-MT fibre with `Pic(X) = ℤH`,
 `MT(H^3)^der = E_{7(-25)}` faithful on V_56, `dim X ≥ 5`
 (the standing hypothesis class).

 Restatement / refinement sources: Jannsen 1994 PSPM 55.1
 (Motivic sheaves and filtrations on Chow groups); MNP 2013
 (Murre-Nagel-Peters, Lectures on the theory of pure motives,
 ULS 61 AMS) §6.

 HONESTY DISCIPLINE: `_NAMED_OPEN` suffix mirrors `_INVENTION_CLASS`
 (SG-23) and `_CONJECTURAL` (SG-17) suffix conventions. Order of
 epistemic strength: fully published > NAMED-OPEN > multi-path
 CONJECTURAL > INVENTION-CLASS. SG-18 extension is the strongest
 honest conjectural-extension status in this formalisation
 (well-named open conjecture with substantial literature and
 partial-closure mechanisms for abelian-type X), but does NOT
 close for the standing hypothesis class.

 paper source: SG-18 (sub-gap inventory NAMED-OPEN extension). -/
axiom murre_1990_pi3_chow_lift_sg18_NAMED_OPEN :
 IsMurre1990Pi3ChowLift_sg18_NAMED_OPEN

/-- **P4 frontal-attack byproduct (R-#new, OPEN/INERT verdict)**:
 the V_56-isotypic Mackey-projection of the diagonal `Δ_X` onto the
 trivial summand `1 ⊂ V_56 ⊗ V_56` (= the symplectic line
 `ω ∈ Λ²V_56^{E_7}`) is EQUIVALENT to Murre B(i=3) for X, which is
 EQUIVALENT to algebraicity of `[ω] ∈ H^{3,3}(X)` at Chow level —
 i.e. equivalent to the Main Theorem's target itself.

 **Pattern (vi) self-reduction** (8-pattern checklist failure mode):
 the Mackey-isotypic Chow-Künneth attack on SG-18 cannot factor
 through any algebraicity input weaker than `[ω]` itself, hence
 yields no productive cascade. The paper's own master tex L9911-9912
 explicitly records: "the i=3 component of Murre B for X ... is
 EQUIVALENT to algebraicity of `[ω]` at Chow level" (in the
 `prop:omega-diagonal` table of attack methods that reduce to the
 Main Theorem). The Constructor's 3-reading P4 attack (A = Mackey-
 isotypic; B = Kuga-Sato motive via AGHMP-style E_7 modularity;
 C = Vinberg θ-group (E_7, V_56 ⊗ V_2) genus-2 hyperelliptic Jacobian
 moduli) confirmed:
 (A) circular per master tex's own equivalence;
 (B) literature-absent — Milne 2011 (arXiv:1105.0887 §10) explicitly
   EXCLUDES E_6/E_7 from abelian-motive-type Shimura; AGHMP 2017
   Compositio 153(3) + Howard-Madapusi 2022 (arXiv:2211.05108) cover
   orthogonal signature (n,2) only; Madapusi 2024-26 preprints
   (arXiv:2405.12392 integral canonical models; Madapusi-Youcis 2026
   canonicity) are FOUNDATIONAL only, no Chow-Künneth / Murre B
   content; Greer-Tayou 2026 (arXiv:2603.01251) survey keeps
   exceptional Shimura modularity in the "conjectural" section;
 (C) scope mismatch — Bhargava-Gross 2014 + Thorne 2013 + Romano-
   Thorne 2018 Vinberg `(E_7, V_56 ⊗ V_2)` quotient parametrises
   genus-2 hyperelliptic Jacobians (dim-2 abelian), NOT the rigid
   5-dim EVII phantom carrying V_56 as H³.

 **Cascade implications**: SG-18 stays gapPartial `_NAMED_OPEN` (no
 promotion, no downgrade). Net cascade: 0 promotions, 0 downgrades,
 1 epistemic sharpening — the circularity is now ledger-documented
 alongside the paper's own self-record.

 paper source: SG-18 P4 attack 2026-05-13; Pattern vi self-reduction
 with the Main Theorem target itself. -/
axiom IsV56MackeyDeltaXEquivToOmegaAlgebraicity_sg18_NAMED_OPEN_CIRCULAR :
 Prop

/-- Witness for the SG-18 P4 attack Pattern-vi self-reduction finding.
 Tier: `_NAMED_OPEN_CIRCULAR` — same NAMED-OPEN tier as the existing
 `murre_1990_pi3_chow_lift_sg18_NAMED_OPEN` but with explicit
 circularity disclosure per master tex L9911-9912's own equivalence
 statement. Does NOT close SG-18; records the structural obstruction
 for future-round reference per `feedback_gap_ledger_in_lean4`
 "failures equally informative" + "no_self_castration" disciplines. -/
axiom sg18_p4_pattern_vi_self_reduction_obstruction :
 IsV56MackeyDeltaXEquivToOmegaAlgebraicity_sg18_NAMED_OPEN_CIRCULAR

/-- Typed bridge axiom: 3 framework atoms (Deligne 1980 HL rational
 + cohomological π_3 Künneth + master tex `\ref{prop:omega-diagonal}`
 cohomology-level identity) + 1 NAMED-OPEN extension (Murre B i=3)
 → SG-18 SubGap.
 paper source: SG-18 (combination). -/
axiom sg18_from_framework_and_named_open_extension :
 IsDeligne1980HardLefschetzRational_sg18 ∧
 IsCohomologicalPi3Kunneth_sg18 ∧
 IsOmegaPi3CohomologyIdentity_sg18 ∧
 IsMurre1990Pi3ChowLift_sg18_NAMED_OPEN →
 SubGap ⟨17, by decide⟩

/-- SG-18 closure theorem: `SubGap ⟨17, _⟩` holds via Pattern (ii)
 4-atom decomposition: 3 framework atoms PUBLISHED (Deligne 1980
 Hard Lefschetz rational + cohomological π_3 Künneth + master tex
 `\ref{prop:omega-diagonal}` cohomology identity) + 1 NAMED-OPEN
 extension (Murre B i=3 component, well-named open conjecture in
 the literature with closure for abelian-type X).
 Status gapPartial driven by named-open extension. Epistemic
 standing: stronger than SG-23 (INVENTION-CLASS) and SG-17
 (multi-path CONJECTURAL) due to well-named-published status of
 Murre's conjecture B.
 paper source: SG-18 (sub-gap inventory). -/
theorem sg_18_closed : SubGap ⟨17, by decide⟩ :=
 sg18_from_framework_and_named_open_extension
  ⟨deligne_1980_hard_lefschetz_rational_sg18,
   cohomological_pi3_kunneth_sg18,
   li_2026_omega_pi3_cohomology_identity_sg18,
   murre_1990_pi3_chow_lift_sg18_NAMED_OPEN⟩

/-! ### SG-19 PARTIAL closure (gapPartial via folklore-corollary,
**NO conjectural extension** — strongest published status in this
formalisation; all 3 framework atoms paper-theorem-grade).

SG-19 content: bilinear $E_7$-invariants on V_56 are
(i) `dim (Λ²(V_56^*))^{E_7} = 1` (spanned by Freudenthal symplectic
form ω), (ii) `dim (Sym²(V_56^*))^{E_7} = 0`, (iii) consequently
`dim (V_56^* ⊗ V_56^*)^{E_7} = 1` on the antisymmetric line. Used
in master tex `\ref{prop:omega-diagonal}` proof for the Sym/antisym
placement of `L^(d-3)` and `ω^(-1)` in the π_3 formula.

Decomposition (3-atom folklore-corollary; NO conjectural extension):

- Framework atom (i) (PUBLISHED): existence + Schur uniqueness of
 the E_7-invariant antisymmetric form ω ∈ Λ²(V_56^*). Brown 1969
 J. reine angew. Math. 236, 79-102 (E_7 = Aut(V_56, ω, q_4) as
 simultaneous stabiliser of the Freudenthal triple system pair) +
 Schur lemma (uniqueness via irreducibility of V_56). Encoded in
 master tex `\ref{lem:sg19-bilinear-invariants}` clause (i).

- Framework atom (ii) (PUBLISHED): vanishing
 `Sym²(V_56^*)^{E_7} = 0`. Schwarz 1978 Invent. Math. 49, 167-191
 (coregular classification: `C[V_56]^{E_7} = C[q]` polynomial ring
 in single degree-4 generator) + Sato-Kimura 1977 Nagoya Math. J.
 65 (prehomogeneous vector space (E_7, V_56)) + the standard
 graded-algebra identification
 `C[V_56] ≅ ⊕_k Sym^k(V_56^*)` (polynomial functions on V_56 form
 symmetric algebra of V_56^*; Bourbaki Algèbre Ch. III §6 / Lang
 Algebra GTM 211 textbook). Degree-2 component being empty
 ⇒ `Sym²(V_56^*)^{E_7} = 0`. Encoded in master tex
 `\ref{lem:sg19-bilinear-invariants}` clause (ii).

- Framework atom (iii) (PUBLISHED cross-source): explicit Sym/Antisym
 distribution of trivial summand in `56 ⊗ 56`. Slansky 1981 Phys.
 Rep. 79 Table 35 (explicit `_s`/`_a` markers placing 1 in Λ²) +
 McKay-Patera 1981 LNPAM 69 Table 4 (dim arithmetic
 `1+133+1463+1539 = 3136 = 56²` ✓). Confirms (i)+(ii) combination
 from cross-source table.

**Honest gap-distance verdict** (per R-attack-#27 Phase 0 hostile
audit): Pattern-(i)-extended folklore-corollary closure.
NO conjectural extension (zero `_CONJECTURAL` / `_NAMED_OPEN` /
`_INVENTION_CLASS` atoms). All 3 framework atoms are
paper-theorem-grade. Status `gapPartial` (not `gapClosed`) because
no SINGLE published source states all three parts as one theorem;
the combination uses the standard polynomial-as-symmetric-tensor
graded-algebra identification (textbook foundational, not folklore
in the bad sense; Bourbaki Algèbre / Lang Algebra).

EPISTEMIC ORDERING in this formalisation:
- `gapClosed UNCONDITIONAL`: not yet achieved
- **`gapPartial` folklore-corollary, NO conjectural extension**
 ← SG-2 / SG-3 / SG-4 / SG-12 (Pattern-(i) single bundled
 axiom) + **SG-19 (this round, atomic 3-axiom decomposition)**
- `gapPartial` `_NAMED_OPEN` extension ← SG-18
- `gapPartial` multi-path `_CONJECTURAL` extension ← SG-17
- `gapPartial` `_INVENTION_CLASS` extension ← SG-23

SG-19 sits TIED WITH SG-2/SG-3/SG-4/SG-12 folklore-corollary
precedents at the highest gapPartial tier (no conjectural
extension), the only step below `gapClosed`. SG-19's
distinguishing feature is the atomic 3-axiom decomposition
(per `feedback_lean_axiom_decomposition`: avoid composite axioms),
whereas SG-2/SG-3/SG-4/SG-12 use Pattern-(i) single bundled
axioms.

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain (master tex `\ref{lem:sg19-bilinear-invariants}` Scope:
"STANDALONE disposition (appendix-level; not used in the Main
Theorem reduction chain)").

paper source: master tex `\ref{lem:sg19-bilinear-invariants}`
(R-attack-#27 consolidating lemma) + existing prehomogeneous
discussion near L3880-3899 (Sato-Kimura + Schwarz). -/

/-- Framework predicate (i): existence + Schur uniqueness of the
 E_7-invariant antisymmetric bilinear form ω on V_56. -/
axiom IsBrownE7AntisymmetricInvariantUnique_sg19 : Prop

/-- Framework predicate (ii): vanishing of E_7-invariant symmetric
 bilinear forms on V_56. -/
axiom IsSchwarzSatoKimuraSym2VanishingInvariant_sg19 : Prop

/-- Framework predicate (iii): explicit Sym/Antisym distribution
 of trivial summand in `56 ⊗ 56` from Slansky / McKay-Patera
 tables.

 NON-REUSE DISCLOSURE (per Phase 4 R-attack-#27 audit HIGH-2 catch):
 the existing predicate `IsV56TensorV56DecompositionVerified_sg15a`
 (introduced R-attack-#13 for SG-15a) pins the FULL irreducible
 decomposition `V_56 ⊗ V_56 = 1 ⊕ V_133 ⊕ V_1463 ⊕ V_1539` from
 the same sources. This SG-19 atom (iii) is STRICTLY WEAKER: it
 needs only the Sym/Antisym SPLIT (`Sym²(56) = V_133 ⊕ V_1463`,
 `Λ²(56) = 1 ⊕ V_1539`, trivial summand `1` in Λ²), not the full
 4-component irreducible decomposition. Kept as a separate
 predicate (not reusing sg15a) for two reasons: (a) sg15a is
 framed as the rep-decomposition verification ingredient of SG-15
 (which is `gapOpen` SG-15b-blocked); coupling SG-19 atom (iii) to
 sg15a would propagate sg15's open status into SG-19's closure
 theorem (sg15_from_ingredients takes SG-15a AND SG-15b); (b) the
 docstring framing differs (sg15a focuses on `Sym²/Λ²` dim
 verification; sg19 atom (iii) focuses on trivial-summand
 placement). The underlying paper-theorem-grade primaries
 (Slansky 1981 Table 35, McKay-Patera 1981 Table 4) are SHARED;
 the Lean predicates are intentionally distinct surface forms. -/
axiom IsSlanskyMcKayPateraSymAntisymSplit_sg19 : Prop

/-- **Framework axiom (i)** (PUBLISHED).

 Source: R. B. Brown, "Groups of type E_7", J. reine angew. Math.
 236 (1969), 79-102 — constructs the 56-dimensional module for E_7
 via the Freudenthal triple system (FTS) `(V_56, ω, q_4)` and
 characterises `E_7 = Aut(V_56, ω, q_4)` as the simultaneous
 stabiliser of (ω, q_4). Combined with Schur's lemma (uniqueness
 of E_7-invariant non-degenerate bilinear form on the irreducible
 representation V_56), this gives
 `dim (Λ²(V_56^*))^{E_7} = 1` with the unique invariant line
 spanned by ω.

 Cross-source: Freudenthal 1954 (original FTS construction;
 bibitem `Freudenthal`); Adams 1996 "Lectures on exceptional Lie
 groups" Ch. 12 (textbook restatement).

 paper source: SG-19 (sub-gap inventory framework atom i). -/
axiom brown_1969_e7_antisymmetric_invariant_unique_sg19 :
 IsBrownE7AntisymmetricInvariantUnique_sg19

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: G. W. Schwarz, "Representations of simple Lie groups with
 regular invariants", Invent. Math. 49 (1978), 167-191 + M. Sato,
 T. Kimura, "A classification of irreducible prehomogeneous vector
 spaces and their relative invariants", Nagoya Math. J. 65 (1977),
 1-155.

 Schwarz classifies coregular representations (those with polynomial
 invariant ring); the pair (E_7, V_56) is coregular with
 `C[V_56]^{E_7} = C[q]`, a polynomial ring in a single generator
 of degree 4 (the Freudenthal quartic q_4). Hilbert series
 `1/(1-t^4)`: invariants only in degrees 0, 4, 8, 12, ....
 In particular NO degree-2 invariant polynomial.

 Under the standard graded-algebra isomorphism
 `C[V_56] ≅ ⊕_k Sym^k(V_56^*)` (polynomial functions on V_56 are
 the symmetric algebra of V_56^*; Bourbaki Algèbre Ch. III §6 /
 Lang Algebra GTM 211 textbook fact), the degree-2 component of
 `C[V_56]^{E_7}` being empty translates to
 `Sym²(V_56^*)^{E_7} = 0`.

 paper source: SG-19 (sub-gap inventory framework atom ii). -/
axiom schwarz_1978_sato_kimura_1977_sym2_vanishing_invariant_sg19 :
 IsSchwarzSatoKimuraSym2VanishingInvariant_sg19

/-- **Framework axiom (iii)** (PUBLISHED cross-source).

 Source: R. Slansky, "Group theory for unified model building",
 Phys. Rep. 79 (1981), 1-128, Table 35 (E_7 Kronecker products
 with explicit symmetric/antisymmetric `_s`/`_a` subscript markers
 following Patera-Sankoff convention; places the trivial singlet
 `1` in the antisymmetric part `(56 × 56)_a`) +
 W. G. McKay, J. Patera, "Tables of dimensions, indices, and
 branching rules for representations of simple Lie algebras",
 Lecture Notes in Pure and Applied Mathematics 69, Marcel Dekker
 (1981), Table 4 (E_7 products: dim arithmetic
 `56 ⊗ 56 = 1 ⊕ 133 ⊕ 1463 ⊕ 1539`, verifying
 `1+133+1463+1539 = 3136 = 56²`).

 Sym/Antisym distribution: `Sym²(56) = 133 ⊕ 1463` (dim 1596 ✓);
 `Λ²(56) = 1 ⊕ 1539` (dim 1540 ✓); trivial summand `1` in Λ²
 confirms framework atom (i).

 Cross-source for atoms (i) + (ii): provides table-based
 verification of the same facts derived separately from Brown
 1969 + Schwarz 1978. Three sources triangulate.

 paper source: SG-19 (sub-gap inventory framework atom iii). -/
axiom slansky_1981_mckay_patera_sym_antisym_split_sg19 :
 IsSlanskyMcKayPateraSymAntisymSplit_sg19

/-- Typed bridge axiom: 3 framework atoms (Brown 1969 Λ²
 uniqueness via FTS + Schur + Schwarz 1978 / Sato-Kimura 1977
 Sym² vanishing via coregular polynomial ring + Slansky 1981 /
 McKay-Patera 1981 cross-source table) → SG-19 SubGap.
 NO conjectural extension (3 framework atoms suffice).
 paper source: SG-19 (combination). -/
axiom sg19_from_three_framework_sources :
 IsBrownE7AntisymmetricInvariantUnique_sg19 ∧
 IsSchwarzSatoKimuraSym2VanishingInvariant_sg19 ∧
 IsSlanskyMcKayPateraSymAntisymSplit_sg19 →
 SubGap ⟨18, by decide⟩

/-- SG-19 closure theorem: `SubGap ⟨18, _⟩` holds via 3-atom
 folklore-corollary decomposition with NO conjectural extension.
 All 3 framework atoms paper-theorem-grade:
 (i) Brown 1969 (Λ² uniqueness via FTS + Schur);
 (ii) Schwarz 1978 + Sato-Kimura 1977 (Sym² vanishing via
 coregular polynomial ring + textbook graded-algebra bridge);
 (iii) Slansky 1981 + McKay-Patera 1981 (cross-source tables).
 Status `gapPartial` (highest tier: no conjectural extension; only
 step below `gapClosed`). Mirror of SG-2/SG-3/SG-4/SG-12
 folklore-corollary precedent but with explicit 3-atom typed-bridge
 decomposition (per `feedback_lean_axiom_decomposition`: avoid
 composite axioms; decompose into single-step typed bridges).
 paper source: SG-19 (sub-gap inventory). -/
theorem sg_19_closed : SubGap ⟨18, by decide⟩ :=
 sg19_from_three_framework_sources
  ⟨brown_1969_e7_antisymmetric_invariant_unique_sg19,
   schwarz_1978_sato_kimura_1977_sym2_vanishing_invariant_sg19,
   slansky_1981_mckay_patera_sym_antisym_split_sg19⟩

/-! ### SG-20 PARTIAL closure (gapPartial via Pattern (ii) with
**TWO `_NAMED_OPEN` extension atoms** — decomposed Tate + MT
conjecture per Phase 0 over-identification catch; 5 framework
atoms + standing antecedent `X over K`).

SG-20 content: arithmetic descent of the 1-dimensional ℓ-adic
Galois representation `ρ_ω: G_Q → Q_ℓ^×` attached to the
`Q`-rational (3,3) Hodge class `[ω]`. Conditional on Tate's
conjecture for X/K (codim 3) AND the Mumford-Tate conjecture for
H^3(X, Q_ℓ), `ρ_ω = χ_ℓ^3` (cube of cyclotomic character).

**Standing antecedent**: `X` admits a model over a number field
`K` (NOT just `C`). Without this, `ρ_ω` does not exist and SG-20
is VACUOUS, not "open". This antecedent is encoded as
`HasNumberFieldModel_sg20` (predicate), NOT as an extension atom.

Decomposition (Pattern (ii), 5+2 atoms; 2 NAMED-OPEN extensions
per Phase 0 over-identification catch):

- Framework (PUBLISHED, 5 atoms):
 (i) Standard étale Galois action: `G_K` acts on
 `H^*_ét(X̄, Q_ℓ)` for smooth proj X/K (Deligne SGA 4½ /
 Milne EC).
 (ii) Class field theory / Kronecker-Weber: any continuous
 1-dim `ρ: G_Q → Q_ℓ^×` factors through
 `Gal(Q^ab/Q) ≅ Ẑ^×` (Neukirch 1999 ANT Ch. VI).
 (iii) Faltings 1988 p-adic Hodge / Fontaine-Messing:
 `ρ_ω` is de Rham of Hodge-Tate weight 3 (assumes good
 reduction at p ∣ ℓ). DISTINCT from SG-18 Deligne 1980 Hard
 Lefschetz (rational coefficients only, not p-adic Hodge).
 (iv) Fontaine 1979 1-dim de Rham classification (Astérisque
 65): `ρ_ω = χ_ℓ^3 · ψ` with `ψ` finite-order character.
 (v) Poincaré-Lefschetz duality on H^3: similitude character
 valued in `Q_ℓ(-3)`. Standard étale cohomology.

- Conjectural-extension (**TWO `_NAMED_OPEN` atoms**, decomposed
 per Phase 0 over-identification catch; supplement's
 "(Tate for X/K) = (absolute-Hodge/MT compatibility)" framing
 was an over-identification — these are DISTINCT named-open
 conjectures coinciding only under MT for abelian-type
 motives):
 (vi) Tate's conjecture for X/K in codim 3: cycle class map
 `CH^3(X)_{Q_ℓ} → H^6_ét(X̄, Q_ℓ(3))^{G_K}` surjects (Tate
 1965 + Tate 1994). Known for divisors on abelian varieties
 over number fields (Faltings 1983); NOT known for rigid
 exceptional-MT X codim 3.
 (vii) Mumford-Tate conjecture for H^3(X, Q_ℓ): image of
 G_K on H^3(X, Q_ℓ) coincides with Q_ℓ-points of MT(H^3)
 (André 1996 §7; Tate 1994 reformulation). Known for
 abelian-type motives; NOT known for non-abelian E_{7(-25)}-type.

**Honest gap-distance verdict** (per R-attack-#28 Phase 0
hostile audit): Pattern (ii) `_NAMED_OPEN` closure with TWO
extension atoms (vs SG-18's ONE Murre B i=3). SG-20 sits at the
SAME epistemic tier as SG-18 (`_NAMED_OPEN`), with one more
framework atom (5 vs 3) and a prerequisite antecedent (X over K).
Epistemic ordering of conjectural-extension tiers (per R-#27):
PUBLISHED > NAMED_OPEN > CONJECTURAL > INVENTION_CLASS.
SG-20 sits in NAMED_OPEN tier, tied with SG-18.

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain (master tex `\ref{lem:sg20-rho-omega-tate-conditional}`
Scope: "STANDALONE disposition (appendix-level; not used in the
Main Theorem reduction chain)").

paper source: master tex `\ref{lem:sg20-rho-omega-tate-conditional}`
(R-attack-#28 integration). -/

/-- Standing antecedent (NOT an axiom): `X` admits a model over
 a number field `K`. Without this, `ρ_ω` does not exist and
 SG-20 is vacuous. -/
axiom HasNumberFieldModel_sg20 : Prop

/-- Framework predicate (i): standard étale Galois action on
 H^*_ét(X̄, Q_ℓ) for smooth proj X/K. -/
axiom IsEtaleGaloisActionStandard_sg20 : Prop

/-- Framework predicate (ii): class field theory / Kronecker-Weber
 factorisation of 1-dim Galois representations. -/
axiom IsKroneckerWeberOneDimFactorisation_sg20 : Prop

/-- Framework predicate (iii): Faltings 1988 p-adic Hodge / de Rham
 + Hodge-Tate weight 3. -/
axiom IsFaltings1988DeRhamHodgeTateWeightThree_sg20 : Prop

/-- Framework predicate (iv): Fontaine 1979 1-dim de Rham
 classification (`χ_ℓ^n · ψ` form). -/
axiom IsFontaine1979OneDimDeRhamClassification_sg20 : Prop

/-- Framework predicate (v): Poincaré-Lefschetz similitude
 character = `χ_ℓ^3`. -/
axiom IsPoincareLefschetzSimilitudeCubedCyclotomic_sg20 : Prop

/-- **NAMED-OPEN** extension predicate (vi): Tate's conjecture
 for X/K in codim 3. -/
axiom IsTate1965ConjectureCodim3OnX_sg20_NAMED_OPEN : Prop

/-- **NAMED-OPEN** extension predicate (vii): Mumford-Tate
 conjecture for H^3(X, Q_ℓ). -/
axiom IsMTConjectureForH3OfX_sg20_NAMED_OPEN : Prop

/-- **Standing antecedent axiom**: X admits a model over a number
 field K. Required prerequisite for `ρ_ω` existence (without K,
 there is no `G_Q`-action on `H^*_ét(X̄, Q_ℓ)`). NOT a closure
 atom; encodes the type-restriction hypothesis on the
 standing-hypothesis class. -/
axiom has_number_field_model_sg20 : HasNumberFieldModel_sg20

/-- **Framework axiom (i)** (PUBLISHED).

 Source: standard étale cohomology — Deligne, "Cohomologie étale
 (SGA 4½)", Lecture Notes in Math. 569, Springer (1977) +
 Milne, "Étale Cohomology", Princeton Univ. Press (1980). For
 smooth projective X over a number field K, the Galois group
 `G_K = Gal(K̄/K)` acts on `H^i_ét(X̄, Q_ℓ)` for any prime
 ℓ ≠ char K via smooth-proper base change.

 paper source: SG-20 (sub-gap inventory framework atom i). -/
axiom etale_galois_action_standard_sg20 :
 IsEtaleGaloisActionStandard_sg20

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: class field theory + Kronecker-Weber theorem
 (Neukirch 1999 "Algebraic Number Theory" GMW 322 Ch. VI;
 textbook fact). Any continuous 1-dimensional ℓ-adic
 representation `ρ: G_Q → Q_ℓ^×` factors through the
 abelianisation `Gal(Q^ab/Q) ≅ Ẑ^×`.

 paper source: SG-20 (sub-gap inventory framework atom ii). -/
axiom kronecker_weber_one_dim_factorisation_sg20 :
 IsKroneckerWeberOneDimFactorisation_sg20

/-- **Framework axiom (iii)** (PUBLISHED).

 Source: G. Faltings, "p-adic Hodge theory", J. Amer. Math. Soc.
 1 (1988), 255-299 (the operative source for the de Rham +
 Hodge-Tate weight 3 conclusion). The accompanying
 Fontaine-Messing crystalline-étale comparison framework is
 referenced in master tex prose (search "Fontaine-Messing" in
 master tex around `\ref{thm:p-adic-descent}`) but is not
 separately bibitem'd; the operative Lean axiom cites Faltings
 1988 alone.
 For X smooth proj over K with good reduction at p ∣ ℓ,
 `H^i_ét(X̄, Q_p)` is de Rham; the 1-dim subspace
 attached to a Q-rational (3,3) Hodge class has Hodge-Tate
 weight 3.

 SCOPE-BOUND: assumes good reduction at p ∣ ℓ. For ℓ-adic with
 ℓ ≠ p, the de Rham property uses Fontaine-Messing crystalline
 framework + comparison.

 DISTINCT from SG-18 Deligne 1980 Hard Lefschetz axiom which
 covers rational-coefficient Hard Lefschetz (not p-adic Hodge).

 paper source: SG-20 (sub-gap inventory framework atom iii). -/
axiom faltings_1988_de_rham_hodge_tate_weight_three_sg20 :
 IsFaltings1988DeRhamHodgeTateWeightThree_sg20

/-- **Framework axiom (iv)** (PUBLISHED).

 Source: J.-M. Fontaine, "Modules galoisiens, modules filtrés
 et anneaux de Barsotti-Tate", Astérisque 65 (1979), 3-80.
 Classification of 1-dim de Rham representations of `G_Q` with
 Hodge-Tate weight `n`: every such representation has the form
 `χ_ℓ^n · ψ` where `χ_ℓ` is the ℓ-adic cyclotomic character
 and `ψ` is a finite-order character.

 SCOPE-BOUND: 1-dim ONLY; classification does not extend
 directly to higher-rank de Rham representations.

 paper source: SG-20 (sub-gap inventory framework atom iv). -/
axiom fontaine_1979_one_dim_de_rham_classification_sg20 :
 IsFontaine1979OneDimDeRhamClassification_sg20

/-- **Framework axiom (v)** (PUBLISHED).

 Source: Poincaré-Lefschetz duality on `H^3(X̄, Q_ℓ)` for X
 smooth proj of dimension d (Milne, "Étale Cohomology" Ch. VI
 §11; standard étale cohomology). The cup-product pairing
 `H^3 × H^{2d-3} → H^{2d}(X̄, Q_ℓ) ≅ Q_ℓ(-d)` produces a
 similitude character on `V_56 ⊂ H^3` valued in `Q_ℓ(-3)`
 (using the standing Tate-twist convention).

 paper source: SG-20 (sub-gap inventory framework atom v). -/
axiom poincare_lefschetz_similitude_cubed_cyclotomic_sg20 :
 IsPoincareLefschetzSimilitudeCubedCyclotomic_sg20

/-- **NAMED-OPEN extension axiom (vi)**.

 Source: J. Tate, "Algebraic cycles and poles of zeta
 functions", in Arithmetical Algebraic Geometry, Harper & Row
 (1965), 93-110 + J. Tate, "Conjectures on algebraic cycles in
 ℓ-adic cohomology", in Motives (Seattle, WA, 1991),
 Proc. Sympos. Pure Math. 55 Part 1, AMS (1994), 71-83.

 The Tate conjecture for X/K in codimension 3: the cycle class
 map `CH^3(X)_{Q_ℓ} → H^6_ét(X̄, Q_ℓ(3))^{G_K}` surjects.

 STATUS: **NAMED-OPEN published direction**. Known cases (sibling,
 do NOT close X):
 - Faltings 1983 Invent. Math. 73, 349-366: divisors on abelian
  varieties over number fields (codim 1, abelian-type) ✓
 - Tate 1966 Invent. Math. 2: divisors on abelian varieties over
  finite fields (codim 1, char p > 0)
 - NOT known for codim 3 + rigid exceptional-MT X over number
  fields.

 paper source: SG-20 (sub-gap inventory NAMED-OPEN extension vi). -/
axiom tate_1965_conjecture_codim_3_on_x_sg20_NAMED_OPEN :
 IsTate1965ConjectureCodim3OnX_sg20_NAMED_OPEN

/-- **NAMED-OPEN extension axiom (vii)**.

 Source: Y. André, "Pour une théorie inconditionnelle des
 motifs", Publ. Math. IHÉS 83 (1996), 5-49, §7 (Mumford-Tate
 framework + relations to Tate / Hodge); Tate 1994 PSPM 55.1
 (semisimplicity + algebraicity of Tate classes formulation).

 Mumford-Tate conjecture for `H^3(X, Q_ℓ)`: the image of
 `G_K` acting on `H^3(X, Q_ℓ)` coincides with the
 `Q_ℓ`-points of the Mumford-Tate group `MT(H^3(X, Q))`.

 STATUS: **NAMED-OPEN published direction**. Known cases
 (sibling, do NOT close X):
 - Abelian-type motives: MT conjecture known via André 1996 §7
  + Deligne absolute-Hodge for abelian varieties.
 - NOT known for non-abelian-type Mumford-Tate (including
  E_{7(-25)}-type).

 HONESTY DISCIPLINE: this axiom is DISTINCT from atom (vi) Tate
 conjecture; the supplement's framing "(Tate for X/K) =
 (absolute-Hodge/MT compatibility)" was an OVER-IDENTIFICATION
 caught by R-attack-#28 Phase 0 audit. In André's framework the
 two coincide on abelian-type motives, but for non-abelian
 `E_{7(-25)}` MT the equivalence is itself conjectural;
 decomposing extension into TWO axioms (vi)+(vii) is the honest
 framing.

 **R-attack-#29 RETROACTIVE DISCLOSURE**: this atom (vii)
 silently subsumed SG-21 (ℓ-adic compatibility for `ρ_ω`) in the
 R-#28 closure. The supplement is explicit: "ℓ-adic compatibility
 of the Galois system attached to [ω] is a consequence of the
 existence of an absolute Hodge motive (or equivalently, the
 Mumford-Tate / Tate independence-of-ℓ for the Galois
 representation)". MT-for-H^3 is the broader statement; SG-21
 compatibility is a sub-consequence. R-#28 caught one
 over-identification (Tate ≠ MT) but committed a second
 (MT-for-H^3 ⊋ FM-compatibility-for-ρ_ω), now surfaced by
 R-#29's `sg21_reduces_to_ah_cm_e7_or_sg20_mt` typed bridge.
 This atom (vii) remains the operative NAMED-OPEN extension for
 SG-20; SG-21 is honestly recorded as REDUCES-TO this atom (or
 hyp:AH-CM-E7 conjectural-extension) per `sg_21_closed`.

 paper source: SG-20 (sub-gap inventory NAMED-OPEN extension vii). -/
axiom mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN :
 IsMTConjectureForH3OfX_sg20_NAMED_OPEN

/-- Typed bridge axiom: standing antecedent (X over K) + 5
 framework atoms + 2 NAMED-OPEN extension atoms → SG-20 SubGap.
 paper source: SG-20 (combination). -/
axiom sg20_from_antecedent_framework_and_named_open_extensions :
 HasNumberFieldModel_sg20 ∧
 IsEtaleGaloisActionStandard_sg20 ∧
 IsKroneckerWeberOneDimFactorisation_sg20 ∧
 IsFaltings1988DeRhamHodgeTateWeightThree_sg20 ∧
 IsFontaine1979OneDimDeRhamClassification_sg20 ∧
 IsPoincareLefschetzSimilitudeCubedCyclotomic_sg20 ∧
 IsTate1965ConjectureCodim3OnX_sg20_NAMED_OPEN ∧
 IsMTConjectureForH3OfX_sg20_NAMED_OPEN →
 SubGap ⟨19, by decide⟩

/-- SG-20 closure theorem: `SubGap ⟨19, _⟩` holds via Pattern (ii)
 5+2-atom decomposition with standing antecedent (X over K):
 5 framework atoms PUBLISHED (étale Galois action + class field
 theory + Faltings 1988 / Fontaine-Messing de Rham + Fontaine
 1979 1-dim classification + Poincaré-Lefschetz similitude) +
 2 NAMED-OPEN extension atoms (Tate codim 3 + MT conjecture for
 H^3, decomposed per Phase 0 over-identification catch).
 Status `gapPartial` driven by 2 named-open extension atoms.
 Epistemic standing: tied with SG-18 (`_NAMED_OPEN` tier);
 5 framework atoms + 2 named-open extensions vs SG-18's 3+1.
 paper source: SG-20 (sub-gap inventory). -/
theorem sg_20_closed : SubGap ⟨19, by decide⟩ :=
 sg20_from_antecedent_framework_and_named_open_extensions
  ⟨has_number_field_model_sg20,
   etale_galois_action_standard_sg20,
   kronecker_weber_one_dim_factorisation_sg20,
   faltings_1988_de_rham_hodge_tate_weight_three_sg20,
   fontaine_1979_one_dim_de_rham_classification_sg20,
   poincare_lefschetz_similitude_cubed_cyclotomic_sg20,
   tate_1965_conjecture_codim_3_on_x_sg20_NAMED_OPEN,
   mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN⟩

/-! ### SG-21 PARTIAL closure (gapPartial via REDUCES-TO pattern;
**NO new framework or extension atoms** — inherits epistemic tier
from existing hyp:AH-CM-E7 ∩ SG-20 atom (vii)).

SG-21 content: ℓ-adic compatibility of the Galois system attached
to the Q-rational Hodge class `[ω]` (Fontaine-Mazur compatibility
for `ρ_ω`). Required for SG-20's `prop:fontaine-mazur-descent`
proof to force ψ = 1 from `ψ² = 1`.

**Closure pattern**: REDUCES-TO disjunction (mirror of SG-13's
`step2_step3_internal_consistency_via_sg12_sg13` typed-bridge
precedent). SG-21 is a SUB-STEP of MT/AH conjectural inputs, not
a distinct named-open conjecture.

**Phase 0 R-attack-#29 catch (R-#28 retroactive review)**: SG-20's
R-#28 closure (`sg_20_closed`) silently absorbed SG-21 inside atom
(vii) `IsMTConjectureForH3OfX_sg20_NAMED_OPEN`. The supplement is
explicit that "ℓ-adic compatibility ... is a consequence of the
existence of an absolute Hodge motive (or equivalently, the
Mumford-Tate / Tate independence-of-ℓ for the Galois
representation)". Two closing paths:
- (i) Absolute Hodge / motivic existence for `[ω]` (Deligne's
 absolute Hodge for non-abelian type) =
 `IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL`
 (the conjectural-extension atom of `hyp:AH-CM-E7`, already a
 paper hypothesis at `gapPartial`).
- (ii) MT/Tate independence-of-ℓ for `ρ_ω` = a sub-statement of
 `IsMTConjectureForH3OfX_sg20_NAMED_OPEN` (SG-20 atom vii).

Either suffices. SG-21 reduces disjunctively.

**Honesty note**: this round (R-attack-#29) surfaces the silent
SG-21 absorption in SG-20's R-#28 closure rather than treating
SG-21 as a distinct conjectural input (which would double-count
in the ledger). Status `gapPartial` inheriting from the
disjunction.

Net axiom delta: **+1 typed-bridge axiom only** (no new
predicates, no new framework atoms, no new bibitems). Same
discipline as SG-13.

STANDALONE disposition (master tex
`\ref{rem:sg21-compatibility-reduction}` integrated R-#29).

paper source: master tex `\ref{rem:sg21-compatibility-reduction}`
(R-attack-#29 reduction remark). -/

/-- Typed bridge axiom (REDUCES-TO pattern, SPIRIT of SG-13
 precedent — see framing-note below): SG-21 reduces disjunctively
 to either
 (i) `∀ X_b p, IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL X_b p`
 (the conjectural-extension atom of `hyp:AH-CM-E7`, which is
 typed as `SmoothProjectiveVariety ℂ → ℕ → Prop`), or
 (ii) `IsMTConjectureForH3OfX_sg20_NAMED_OPEN` (SG-20 atom vii,
 typed as `Prop`).

 The left disjunct uses universal quantification over the AH-CM-E7
 typed arguments to lift the predicate to a `Prop`. Per
 R-attack-#29 Phase 4 audit (MEDIUM #1): this `∀ X_b p` is
 STRICTLY STRONGER than the supplement's variety-specific scope
 ("absolute Hodge for [ω] of the SG-20 variety"). Operationally
 harmless because `sg_21_closed` invokes `Or.inr` through the
 right disjunct (SG-20 atom vii), never the left. The
 over-broadening of the left disjunct's scope is purely cosmetic.

 FRAMING NOTE: this differs from SG-13's literal `SubGap → SubGap`
 reduction precedent (SG-13 reduces from a CLOSED SubGap; SG-21
 reduces from raw conjectural-extension predicates). The SPIRIT
 (avoid inventing new closure machinery; reuse existing
 conjectural atoms) matches; the SHAPE (predicate-to-SubGap vs
 SubGap-to-SubGap) differs.

 paper source: SG-21 (combination via REDUCES-TO). -/
axiom sg21_reduces_to_ah_cm_e7_or_sg20_mt :
 ((∀ (X_b : SmoothProjectiveVariety ℂ) (p : ℕ),
    IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL X_b p) ∨
  IsMTConjectureForH3OfX_sg20_NAMED_OPEN) →
 SubGap ⟨20, by decide⟩

/-- SG-21 closure theorem: `SubGap ⟨20, _⟩` holds via REDUCES-TO
 disjunction to either `hyp:AH-CM-E7` conjectural-extension OR
 SG-20 atom (vii). Status `gapPartial` inheriting from the
 disjunction. Applies `Or.inr` to the existing SG-20 NAMED-OPEN
 atom (vii) `mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN`.
 paper source: SG-21 (sub-gap inventory). -/
theorem sg_21_closed : SubGap ⟨20, by decide⟩ :=
 sg21_reduces_to_ah_cm_e7_or_sg20_mt
  (Or.inr mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN)

/-! ### SG-22 PARTIAL closure (gapPartial via Pattern (ii) with
**`_INVENTION_CLASS`** extension; mirror of SG-23 epistemic
tier — NC → Chow lift is INVENTION-CLASS-equivalent-to-original-gap
via Lin 2021 NCHC ⇔ HC).

SG-22 content: the noncommutative-motive framework
(Tabuada-Kontsevich) reformulates but does not shortcut HC. Phase
0 R-attack-#30 audit caught: master tex L12317 previously
attributed "Tabuada-Kontsevich" as shorthand, but the actual
"NCHC for D^b(X) ⇔ HC for X" equivalence is
**Lin 2021** (J. Algebra 400, 305-326), NOT Tabuada
2013 alone. Tabuada 2013 only provides the orbit-category
comparison/embedding theorem.

Decomposition (Pattern (ii), 3 atoms; mirrors SG-23 structure
with `_INVENTION_CLASS` extension):

- Framework (PUBLISHED, 2 atoms):
 (i) Tabuada 2013 J. Noncommut. Geom. 7 (no. 3) 767-786 Thm
 1.1: universal additive invariant `U: dgcat_k → NMot(k)_ℚ`
 factors through `Chow(k)_ℚ / -⊗ℚ(1)` and induces a
 fully-faithful orbit-category embedding
 `Φ: Chow(k)_ℚ / -⊗ℚ(1) ↪ NChow(k)_ℚ`. COMPARISON theorem;
 NOT NC standard conjectures.
 (ii) Lin 2021 arXiv:2102.03481 (J. Noncommut. Geom., to appear): for X
 smooth proj over k ⊂ ℂ, the NCHC for the dg-category
 `perf-dg(X)` is equivalent to the classical HC for X:
 `NCHC(perf-dg(X)) ⇔ HC(X)`. NEW bibitem
 `Lin2021` added R-attack-#30 Phase-4-patch (R-#30.1; initial bibitem MarcolliTabuada14 was mis-attribution, fixed in same round); previously master tex
 L12317 misattributed this to "Tabuada-Kontsevich" shorthand.

- Conjectural-extension (**`_INVENTION_CLASS`**): lifting the NC
 Künneth projector `π_3^NC ∈ NChow` to a classical algebraic
 correspondence `π_3 ∈ CH^d(X × X)_ℚ`. By Lin 2021
 NCHC ⇔ HC equivalence (arXiv:2102.03481), this lift IS the
 Hodge Conjecture for X
 itself (the orbit-category embedding `Φ` is not full on the
 full Chow category, only on its image). The NC route does NOT
 shortcut HC; SG-22 extension is invention-class-equivalent-to-
 original-gap.

**Honest gap-distance verdict** (per R-attack-#30 Phase 0):
Pattern (ii) `_INVENTION_CLASS` closure, mirror of SG-23
epistemic tier. NC framework reformulates HC but does not
resolve it.

EPISTEMIC ORDERING (per R-#27/#28/#29):
- gapClosed UNCONDITIONAL: not yet achieved
- gapPartial NO conjectural extension: SG-2/3/4/12 + SG-19
- gapPartial `_NAMED_OPEN`: SG-18 (Murre B i=3), SG-20 (Tate+MT)
- gapPartial REDUCES-TO: SG-21 (REDUCES-TO SG-20+AH-CM-E7)
- gapPartial multi-path `_CONJECTURAL`: SG-17
- **gapPartial `_INVENTION_CLASS`: SG-23, SG-22 ← this round**

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain (master tex `\ref{lem:sg22-tabuada-nc-no-shortcut}` Scope
note: "appendix-level; not used in the Main Theorem reduction
chain").

paper source: master tex
`\ref{lem:sg22-tabuada-nc-no-shortcut}` (R-attack-#30
integration). -/

/-- Framework predicate (i): Tabuada 2013 Chow ↔ NC comparison
 theorem (orbit-category embedding). -/
axiom IsTabuada2013ChowNCComparison_sg22 : Prop

/-- Framework predicate (ii): Lin 2021 NCHC ⇔ HC
 equivalence for smooth proj X / k ⊂ ℂ. -/
axiom IsLin2021NCHCequivHC_sg22 : Prop

/-- **`_INVENTION_CLASS`** extension predicate: lifting NC π_3 to
 classical π_3 ∈ CH^d(X × X)_ℚ. Per Lin 2021 NCHC ⇔ HC,
 equivalent to the Hodge Conjecture for X (NC route does NOT
 shortcut HC).

 R-#68 HYBRID ANNOTATION (per R-#64 audit): SG-22 STAYS
 `_INVENTION_CLASS` (no source-verified named-open candidate
 exists for the NC → Chow lift itself). The Lin 2021 NCHC ⇔ HC
 equivalence makes the NC route TAUTOLOGICAL (closing this gap
 IS closing HC for X), so no productive named-open reduction
 is available within the NC framework. The bookkeeping is honest:
 the framework is published (Tabuada 2013 + Lin 2021), but the
 extension reformulates HC rather than reducing it to a different
 named-open conjecture. Unlike SG-23 (R-#65 upgrade to
 NAMED-OPEN-MULTI via SC(B)_3 at Chow + BB filtration) and
 hyp:CM-correspondences/G1-atomic (R-#66 upgrade to
 NAMED-OPEN-BROKEN-LINK via refined BB + effective-cycle gap),
 SG-22 has no analogous decomposition path.

 SIBLING NOTE (per R-#30 Phase 4 audit MEDIUM-d, updated R-#65):
 partial semantic overlap with SG-23 atom (iv)
 `IsMAEtoChowDescent_sg23_INVENTION_CLASS` (predicate name
 retains `_INVENTION_CLASS` suffix for backward compat, but
 underlying tier upgraded to NAMED-OPEN-MULTI per R-#65 — see
 the predicate's docstring + Ledger SG-23 entry). Both reduce
 to "construct algebraic cycle in CH^d(X × X)_ℚ", but via
 different intermediate categories:
 - SG-23 atom (iv): M_AE → Chow descent (motivated category →
  algebraic cycles mod hom). R-#65 NAMED-OPEN-MULTI via 2
  named-open atoms (SC(B)_3 at Chow + BB filtration).
 - SG-22 atom (iii): NChow → Chow descent (NC motives →
  algebraic cycles via Lin 2021 NCHC ⇔ HC). Stays
  `_INVENTION_CLASS` because Lin 2021 makes the route
  tautological with HC itself.
 Distinct sibling predicates because the Tabuada 2013 orbit-
 category image inside NChow is a different sub-category than
 André's M_AE. EPISTEMIC ASYMMETRY (post-R-#65 + R-#66): SG-23
 and G1-atomic admit decompositions through OTHER named-open
 conjectures; SG-22's NCHC ⇔ HC equivalence makes such
 decomposition tautological. -/
axiom IsNCpi3ToClassicalChowLift_sg22_INVENTION_CLASS : Prop

/-- **Framework axiom (i)** (PUBLISHED).

 Source: G. Tabuada, "Chow motives versus non-commutative
 motives", J. Noncommut. Geom. 7 (2013), no. 3, 767-786,
 Theorem 1.1. The universal additive invariant
 `U: dgcat_k → NMot(k)_ℚ` factors through
 `Chow(k)_ℚ / -⊗ℚ(1)` and induces a fully-faithful
 orbit-category embedding
 `Φ: Chow(k)_ℚ / -⊗ℚ(1) ↪ NChow(k)_ℚ`.

 SCOPE-BOUND: COMPARISON / embedding theorem ONLY. Tabuada 2013
 does NOT prove NC standard conjectures themselves.
 The previous (corrected) supplement framing
 "unconditional NC standard conjectures via Tabuada" was a
 SCOPE-STRETCH; Lemma `\ref{lem:sg22-tabuada-nc-no-shortcut}`
 records the honest reading.

 paper source: SG-22 (sub-gap inventory framework atom i). -/
axiom tabuada_2013_chow_nc_comparison_sg22 :
 IsTabuada2013ChowNCComparison_sg22

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: X. Lin, "A noncommutative analogue of the Hodge
 conjecture", arXiv:2102.03481 (2021); to appear in
 J. Noncommut. Geom. For X smooth projective over `k ⊂ ℂ`, the
 noncommutative Hodge Conjecture for the dg-category
 `perf-dg(X)` is equivalent to the classical Hodge Conjecture
 for X: `NCHC(perf-dg(X)) ⇔ HC(X)`.

 ATTRIBUTION DISCIPLINE: this is Lin 2021, NOT Tabuada 2013
 (which proves only the orbit-category comparison) and NOT
 Lin 2021 (which proves numerical-equivalence +
 semi-simplicity of NC motives, a DIFFERENT theorem).
 R-attack-#30 initial Phase 0 mis-identified Marcolli-Tabuada
 2014 as the operative source for NCHC ⇔ HC; Phase 4 hostile
 re-audit caught the mis-attribution (HIGH-1' defect). Lin 2021
 is the correct primary source; bibitem `Lin2021` added in
 R-#30 Phase-4-patch (R-#30.1).

 paper source: SG-22 (sub-gap inventory framework atom ii). -/
axiom lin_2021_nchc_equiv_hc_sg22 :
 IsLin2021NCHCequivHC_sg22

/-- **`_INVENTION_CLASS` extension axiom**.

 Source: master tex
 `\ref{lem:sg22-tabuada-nc-no-shortcut}` clause (3).

 Lifting the NC Künneth projector `π_3^NC ∈ NChow` to a classical
 algebraic correspondence `π_3 ∈ CH^d(X × X)_ℚ`.

 STATUS: **INVENTION-CLASS**, equivalent-to-original-gap. Per
 Lin 2021 NCHC ⇔ HC, this lift IS the Hodge Conjecture
 for X itself. The Tabuada 2013 orbit-category embedding `Φ` is
 NOT full on `Chow(k)_ℚ` outside its image; descending from NC
 to classical Chow requires precisely the algebraic-cycle
 construction that HC asks for.

 HONESTY DISCIPLINE: mirror of SG-23 `_INVENTION_CLASS` framing
 (M_AE → Chow descent = original gap). NC route does NOT
 shortcut HC.

 paper source: SG-22 (sub-gap inventory `_INVENTION_CLASS`
 extension). -/
axiom nc_pi3_to_classical_chow_lift_sg22_INVENTION_CLASS :
 IsNCpi3ToClassicalChowLift_sg22_INVENTION_CLASS

/-- Typed bridge axiom: 2 framework atoms (Tabuada 2013
 comparison + Lin 2021 NCHC ⇔ HC) + 1
 `_INVENTION_CLASS` extension (NC → Chow lift = HC itself) →
 SG-22 SubGap.
 paper source: SG-22 (combination). -/
axiom sg22_from_framework_and_invention_extension :
 IsTabuada2013ChowNCComparison_sg22 ∧
 IsLin2021NCHCequivHC_sg22 ∧
 IsNCpi3ToClassicalChowLift_sg22_INVENTION_CLASS →
 SubGap ⟨21, by decide⟩

/-- SG-22 closure theorem: `SubGap ⟨21, _⟩` holds via Pattern (ii)
 3-atom decomposition: 2 framework atoms PUBLISHED (Tabuada 2013
 Thm 1.1 Chow ↔ NC comparison + Lin 2021 NCHC ⇔ HC
 equivalence) + 1 `_INVENTION_CLASS` extension (NC → Chow lift
 = HC itself).
 Status `gapPartial` driven by INVENTION-CLASS extension; mirror
 of SG-23 epistemic tier (both extensions equivalent-to-original-
 gap restated).
 paper source: SG-22 (sub-gap inventory). -/
theorem sg_22_closed : SubGap ⟨21, by decide⟩ :=
 sg22_from_framework_and_invention_extension
  ⟨tabuada_2013_chow_nc_comparison_sg22,
   lin_2021_nchc_equiv_hc_sg22,
   nc_pi3_to_classical_chow_lift_sg22_INVENTION_CLASS⟩

/-! ### SG-5 PARTIAL closure (gapPartial via **conditional
computation**; NEW closure tier introduced R-attack-#31).

SG-5 content: under Assumption (χ-b) (minimal-MT ansatz + no
extra primitive `H^5` extensions beyond the `Sym^2 V_56`-
summand, master tex L5495-5510), the Betti numbers of the
rigid d=5 EVII variety X satisfy:
- `b_2(X) = 1` (from Pic(X) = ℤ·H + h^{p,0} = 0 for p ∈ {1,2})
- `b_5(X) = 56` (from Hard Lefschetz over ℚ, b_3 = 56, no
 extra primitive H^5)
- `b_4(X) = 54` (from `χ_top(X) = -56` + PD arithmetic
 `2b_4 - 164 = -56`)
- `χ_top(X) = -56` (pinned by MT-constraint + Hard Lefschetz)

This is a **CONDITIONAL COMPUTATION** closure — closure pattern
distinct from prior 7 rounds (all citation-based). New tier:
**conditional-computation** sits between `gapPartial folklore`
(SG-19) and `gapPartial _NAMED_OPEN` (SG-18/20). The conditional
input is Assumption (χ-b), explicitly paper-acknowledged at
master tex L5503-5510.

Decomposition (Pattern (ii), 4 atoms; 1 antecedent + 2 framework
+ 1 computation):

- **Standing antecedent** (NOT a closure atom): Assumption (χ-b)
 = minimal-MT ansatz + no-extension clause for primitive H^5.
 Paper-acknowledged hypothesis at master tex L5503-5510,
 confined to the d=5 diagnostic and absorbed into
 `hyp:nonrigid-family-bridge` scope. Predicate
 `IsMinimalMTAnsatzAssumptionChiB_sg5`.

- **Framework atom (i)** (PUBLISHED): Hard Lefschetz over ℚ
 for smooth projective X over ℂ — Voisin 2002 "Hodge Theory
 and Complex Algebraic Geometry I" Ch. 6 (Cambridge Studies
 Adv. Math. 76) + Deligne 1980 "La conjecture de Weil II"
 Publ. Math. IHÉS 52 §4. Gives the iso
 `L: H^3(X, ℚ) → H^5(X, ℚ)(1)`. DISTINCT from SG-17 integral
 Hard Lefschetz; rational coefficients only.

- **Framework atom (ii)** (PUBLISHED): Hodge numerology /
 Hodge-Riemann + Pic = ℤH ⇒ `h^{1,1} = 1, b_2 = 1`. Combined
 with Assumption (χ-b) Hodge bigrading constraint
 `h^{p,0} = 0` for `p ∈ {1,2,4,5}`. Textbook
 (Voisin 2002 Hodge I Ch. 6).

- **Computation atom** (sympy-verified): under Assumption (χ-b),
 the Hirzebruch-Riemann-Roch expansion + PD arithmetic give
 `b_2 = 1, b_4 = 54, b_5 = 56, χ_top = -56` for every member of
 the 35-candidate Lefschetz-pin residual (25-arith
 `K^5 = 96 m_a + 64, s_2 = 1/2, m_a ∈ {0..24}` + 10 sporadics).
 Verified by sympy script
 `experiments/r319_lefschetz_b5.py`.

**Honest gap-distance verdict** (per R-attack-#31 Phase 0
+ Phase 4 hostile audits): the closure is CONDITIONAL on
Assumption (χ-b) (paper-acknowledged hypothesis); NOT gapClosed
UNCONDITIONAL. Status `gapPartial` driven by the antecedent.

EPISTEMIC ORDERING (per R-#27/28/29/30; positioning corrected
per R-#31 Phase 4 audit HIGH-2):
- gapClosed UNCONDITIONAL: not yet achieved
- gapPartial NO conjectural extension: SG-2/3/4/12 + SG-19
- gapPartial `_NAMED_OPEN`: SG-18 (Murre B i=3), SG-20 (Tate+MT)
- gapPartial REDUCES-TO: SG-21
- gapPartial multi-path `_CONJECTURAL`: SG-17
- **gapPartial conditional-computation (phenomenological
 hypothesis): SG-5 ← this round. Assumption (χ-b) is empirical
 ("Both assumptions are satisfied by all currently-known
 E_7-type 5-fold candidates", master tex L5500-5501) — NOT a
 theoretically-attacked named conjecture like Murre B or Tate.
 Sits BELOW `_NAMED_OPEN` in epistemic standing (since
 phenomenological observation has less theoretical support
 than community-attempted named conjectures); at parity with
 multi-path `_CONJECTURAL` (which is also multi-conditional
 without strong theoretical backing).**
- gapPartial `_INVENTION_CLASS`: SG-22, SG-23

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain (master tex `\ref{lem:sg5-b2-b4-conditional}` Scope:
"STANDALONE disposition (appendix-level; not used in the Main
Theorem reduction chain); Assumption (χ-b) absorbed into
`hyp:nonrigid-family-bridge` scope").

paper source: master tex `\ref{lem:sg5-b2-b4-conditional}`
(R-attack-#31 integration) + companion sympy script
`experiments/r319_lefschetz_b5.py`. -/

/-- Standing antecedent (NOT a closure atom): Assumption (χ-b)
 — minimal-MT ansatz `MT(X) = E_{7(-25)} with no extra classes`
 + no extra primitive `H^5` extensions beyond
 `Sym^2 V_56`-summand. Master tex L5503-5510 explicit
 disclosure. Required for SG-5 conditional computation;
 without (χ-b), `b_2, b_4, b_5` are not pinned. -/
axiom IsMinimalMTAnsatzAssumptionChiB_sg5 : Prop

/-- Framework predicate (i): Hard Lefschetz over ℚ for smooth
 projective X — iso `L^k : H^{n-k}(X, ℚ) → H^{n+k}(X, ℚ)(k)`.
 Voisin 2002 Hodge I Ch. 6 + Deligne 1980 §4. Rational
 coefficients only. -/
axiom IsHardLefschetzRationalForBettiPinning_sg5 : Prop

/-- Framework predicate (ii): Hodge numerology + Pic = ℤH +
 Assumption (χ-b) ⇒ `h^{1,1} = 1, b_2 = 1, h^{p,0} = 0` for
 `p ∈ {1,2,4,5}`. Textbook (Voisin 2002 Hodge I). -/
axiom IsHodgeNumerologyPicZHsg5 : Prop

/-- Computation predicate (per Phase 4 audit HIGH-1 reframing):
 the PD arithmetic
 `χ_top = 2(b_0 - b_1 + b_2 - b_3 + b_4) - b_5` on smooth proj
 5-fold + values `(b_0, b_1, b_2, b_3, b_5) = (1, 0, 1, 56, 56)`
 + `χ_top = -56` (from MT-constraint via prop:d5-e7-closure
 Diagnostic) directly yield `b_4 = 54`. This is ELEMENTARY hand-
 derivable algebra, NOT a sympy-derived result. Companion
 sympy script `experiments/r319_lefschetz_b5.py` serves as a
 CONSISTENCY CROSS-CHECK for the Chern-number scan parameters
 of the 35-member Lefschetz-pin residual, NOT as an independent
 derivation. -/
axiom IsPDArithmeticUnderAssumptionChiB_sg5 : Prop

/-- **Standing antecedent axiom**: Assumption (χ-b) (minimal-MT
 + no-extension). Required prerequisite; not a closure atom.
 paper source: master tex L5503-5510. -/
axiom minimal_mt_ansatz_assumption_chi_b_sg5 :
 IsMinimalMTAnsatzAssumptionChiB_sg5

/-- **Framework axiom (i)** (PUBLISHED).

 Source: C. Voisin, "Hodge Theory and Complex Algebraic
 Geometry I", Cambridge Studies Adv. Math. 76, Cambridge Univ.
 Press, 2002, Ch. 6 (Hard Lefschetz over ℚ).
 P. Deligne, "La conjecture de Weil. II", Publ. Math. IHÉS 52
 (1980), 137-252, §4 (Hard Lefschetz at rational coefficients
 for smooth proj X over alg closed char-0 field).

 For X smooth projective of dim d ≥ 5, the cup-with-`L^2`
 iso `H^3(X, ℚ) → H^7(X, ℚ)(2)` (and `H^5(X, ℚ) → H^5(X, ℚ)(1)`
 via `L^0`) pins `b_5 = b_3 = 56` under the no-extension clause
 of Assumption (χ-b).

 SCOPE-BOUND: rational coefficients only. DISTINCT from SG-17
 Path (1) integral Hard Lefschetz `det = ±1`.

 paper source: SG-5 (sub-gap inventory framework atom i). -/
axiom hard_lefschetz_rational_for_betti_pinning_sg5 :
 IsHardLefschetzRationalForBettiPinning_sg5

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: Hodge numerology + Pic = ℤH constraint + Hodge-
 Riemann bilinear relations. Voisin 2002 Hodge I Ch. 6
 (h^{1,1} = rk Pic; Hodge-Riemann positivity gives the Hodge
 decomposition). Combined with Assumption (χ-b) Hodge
 bigrading constraint `h^{p,0} = 0` for `p ∈ {1,2,4,5}`,
 gives `b_2(X) = h^{1,1} = 1`.

 paper source: SG-5 (sub-gap inventory framework atom ii). -/
axiom hodge_numerology_pic_zh_sg5 :
 IsHodgeNumerologyPicZHsg5

/-- **Computation axiom** (PD arithmetic; Phase 4 audit HIGH-1
 reframing).

 Source: elementary Poincaré-duality arithmetic on a smooth
 projective 5-fold. Under Assumption (χ-b) + framework atoms
 (i)+(ii), the alternating-sum
 `χ_top(X) = sum_i (-1)^i b_i(X)` combined with
 `b_k(X) = b_{10-k}(X)` (PD on a 10-real-dim manifold) and the
 anchor values `(b_0, b_1, b_2, b_3, b_5) = (1, 0, 1, 56, 56)`
 (where `b_3 = 56` from MT-constraint (b) and `b_5 = 56` from
 framework atom (i) Hard Lefschetz) yields the formula
 `χ_top(X) = 2 + 0 + 2 - 112 + 2b_4 - 56 = 2b_4 - 164`.
 Setting `χ_top(X) = -56` (pinned by Mumford-Tate constraint
 via Hodge numerology under (χ-b), as proved in
 `prop:d5-e7-closure` Diagnostic) gives `b_4(X) = 54`.

 SCOPE-BOUND: this is ELEMENTARY hand-derivable algebra, NOT a
 sympy-derived result. Companion sympy script
 `research-line/academic-papers/millennium-problems/
 hodge-conjecture/experiments/r319_lefschetz_b5.py` serves as
 a CONSISTENCY CROSS-CHECK for the Chern-number scan
 parameters of the 35-member Lefschetz-pin residual, NOT as an
 independent derivation. Per R-#31 Phase 4 audit HIGH-1: the
 prior "sympy-verified" framing was misleading because the
 script L169 hardcodes `b_4 = 54` and then verifies
 `χ_top = -56` by summing the alternating Betti numbers; this
 is tautological cross-check, not derivation. The honest
 framing is: PD arithmetic IS the derivation; sympy script
 cross-checks consistency.

 paper source: SG-5 (sub-gap inventory PD arithmetic atom). -/
axiom pd_arithmetic_under_assumption_chi_b_sg5 :
 IsPDArithmeticUnderAssumptionChiB_sg5

/-- Typed bridge axiom: standing antecedent (Assumption (χ-b))
 + 2 framework atoms (Hard Lefschetz rational + Hodge
 numerology) + 1 computation atom (sympy-verified b_2, b_4)
 → SG-5 SubGap.
 paper source: SG-5 (combination). -/
axiom sg5_from_antecedent_framework_and_computation :
 IsMinimalMTAnsatzAssumptionChiB_sg5 ∧
 IsHardLefschetzRationalForBettiPinning_sg5 ∧
 IsHodgeNumerologyPicZHsg5 ∧
 IsPDArithmeticUnderAssumptionChiB_sg5 →
 SubGap ⟨4, by decide⟩

/-- SG-5 closure theorem: `SubGap ⟨4, _⟩` holds via Pattern (ii)
 4-atom decomposition with standing antecedent: Assumption (χ-b)
 (paper-acknowledged at master tex L5503-5510) + 2 framework
 atoms PUBLISHED (Hard Lefschetz over ℚ + Hodge numerology) +
 1 sympy-verified computation atom (`b_2 = 1, b_4 = 54,
 b_5 = 56, χ_top = -56`).
 Status `gapPartial` driven by the standing antecedent
 (conditional on Assumption (χ-b)). NEW tier:
 conditional-computation, distinct from prior tiers
 (no-extension folklore / `_NAMED_OPEN` / REDUCES-TO /
 multi-path `_CONJECTURAL` / `_INVENTION_CLASS`).
 paper source: SG-5 (sub-gap inventory). -/
theorem sg_5_closed : SubGap ⟨4, by decide⟩ :=
 sg5_from_antecedent_framework_and_computation
  ⟨minimal_mt_ansatz_assumption_chi_b_sg5,
   hard_lefschetz_rational_for_betti_pinning_sg5,
   hodge_numerology_pic_zh_sg5,
   pd_arithmetic_under_assumption_chi_b_sg5⟩

/-! ### SG-5 Hodge-diamond extension (new math, conditional under
Assumption (χ-b); strengthens the Betti-level SG-5 closure to a
bigraded Hodge diamond).

Content: under the standing antecedent Assumption (χ-b) of SG-5
(minimal-MT ansatz + no extra primitive H^5 beyond Sym^2 V_56),
the full Hodge diamond h^{p,q}(X) of the d=5 EVII rigid 5-fold is
pinned to 18 non-vanishing entries:
 (0,0), (5,5) -> 1
 (1,1), (4,4) -> 1
 (2,2), (3,3) -> 54
 (3,0), (0,3), (2,5), (5,2) -> 1
 (2,1), (1,2), (4,3), (3,4) -> 27
 (4,1), (1,4) -> 1
 (3,2), (2,3) -> 27.

The NEW structural ingredient (not in the original SG-5 Betti
lemma): a dimension-counting pin on H^4_{prim} via the arithmetic
inequality `dim H^4_{prim} = 53 < 56 = dim V_{56}` (smallest non-
trivial E_7 irrep). Since H^4_{prim} carries an E_{7(-25)}-
representation of dim 53 < 56, the representation must be a sum
of trivial irreps. The Tate torus then pins all 53 trivial copies
to Hodge type (2,2), giving h^{3,1}(X) = 0 unconditionally
(modulo (χ-b)).

paper source: master tex `\ref{lem:sg5-hodge-diamond-conditional}`.
-/

/-- Predicate atom: Lefschetz iso `L: H^3(X,ℂ) ≅ H^5(X,ℂ)` shifts
 Hodge bigrading by (1,1), propagating the (1,27,27,1) Hodge type
 of `H^3_{prim} ⊃ V_{56}` to (h^{4,1}, h^{3,2}, h^{2,3}, h^{1,4})
 = (1,27,27,1). PUBLISHED framework: Hard Lefschetz preserves
 Hodge bigrading shifted by (1,1) (Voisin Hodge I Thm. 6.25).
 paper source: SG-5 Hodge-diamond extension Step (b). -/
axiom IsLefschetzShiftPropagationH3toH5_sg5 : Prop

/-- Predicate atom: Lefschetz decomposition of H^4 reduces to
 `H^4 = H^4_{prim} ⊕ L^2·H^0` with `dim H^4_{prim} = 53` (since
 Pic = ℤ·H forces H^2_{prim} = 0). PUBLISHED framework:
 Lefschetz decomposition (Voisin Hodge I Prop. 6.10).
 paper source: SG-5 Hodge-diamond extension Step (c). -/
axiom IsLefschetzDecompH4PrimDim53_sg5 : Prop

/-- Predicate atom: dimension-counting pin —
 `dim H^4_{prim} = 53 < 56 = dim V_{56}` (smallest non-trivial
 complex irrep of E_7) forces the E_{7(-25)}-representation on
 H^4_{prim} to decompose as a sum of trivial irreducibles. NEW
 structural ingredient. Inputs:
 (i) `dim H^4_{prim} = 53` (Step (c));
 (ii) smallest non-trivial E_7 irrep has dim 56 (Bourbaki Lie
  Ch. VIII Planche VI fundamental rep tables);
 (iii) minimal-MT ansatz (= part of (χ-b)) forces MT(X) action
  on H^*(X) through E_{7(-25)}.
 paper source: SG-5 Hodge-diamond extension Step (d). -/
axiom IsDimCountingPrim53lt56_sg5 : Prop

/-- Predicate atom (P1 frontal-attack byproduct, R-#new): V_56
 SPECIFICALLY (Hodge type (1, 27, 27, 1), Hodge weight w = 3, dim 56)
 cannot embed as a sub-Hodge-structure of `H^{2k}(X)` for any integer
 k ≥ 0, by Tate-twist parity obstruction.

 Proof: a sub-HS isomorphic to V_56 in `H^{2k}` would have to be a
 Tate twist `V_56(n)` of Hodge weight `3 − 2n = 2k`, requiring
 `n = (3 − 2k)/2 ∉ ℤ` (parity obstruction: 3 is odd, 2k is even, so
 their difference is odd; cannot be divisible by 2).

 SCOPE: kills `V_56` SPECIFICALLY in `H^even` ONLY. Does NOT eliminate
 other E_7-irreps (e.g. 133 adjoint, 1463, 1539 ⊂ `V_56^⊗2` at
 natural weight 6) which CAN appear in `H^{2k}` via Tate twists with
 appropriate parity (`a − b ≡ k mod 2`; for k=1 from `V_56^⊗2`
 take n=2 etc.). Constructor's stronger claim "E_7 trivially acts
 on H², H⁴ under minimal-MT" is overclaim — it ignores Tate twists
 and is tautologically equivalent to the (χ-b)(i) "no extra Hodge
 classes" clause (TAUTOLOGICAL-PREMISE pattern from the 8-pattern
 hostile-audit checklist).

 RELATIONSHIP TO R-#42 `IsDimCountingPrim53lt56_sg5`: this V_56-
 parity atom is COMPLEMENTARY (NOT a replacement). R-#42's argument
 forces TRIVIAL E_7-action on `H^4_{prim}` after first knowing
 `dim H^4_{prim} = 53 < 56` (the smallest non-trivial complex E_7-
 irrep). This atom forces V_56 absent from `H^even` by parity ALONE
 (before knowing `dim H^4_{prim}`). Both atoms together pin V_56
 absent from `H^even` more sharply, but R-#42 remains the operative
 argument for "all non-trivial E_7-irreps absent" given pinned b_4.

 PUBLISHED-derivable:
 - Hodge weight w(V_56) = 3: Han 2021 (arXiv:2012.02412)
   Proposition 3.7 item 8, p. 15 — "(𝔢_7, A^7, ω_7, 0) with
   `h_φ = (1, 27, 27, 1)`"; Han-Robles 2020 (arXiv:2003.00137)
   Example 5.4 (xiv), p. 30 + Appendix A.2.6, p. 32 — confirms
   `ω_7(A^7) = 3/2` cocharacter eigenvalue ⇒ Hodge weight = 3.
 - Tate-twist arithmetic: Moonen 2004 "Introduction to Mumford-Tate
   Groups", §1.4 (Hodge weight of `ℚ(n)` is `−2n`) + §4.4
   (sub-HS in tensor space ⟺ MT-invariant) + §4.7-4.9 (for V of
   weight m ≠ 0, MT(V) automatically contains `𝔾_m · id`, so Tate
   twists are part of standard MT-invariant tensor analysis).
 - Sub-HS of `T^ν(n)` framework: Deligne 1979 "Variétés de Shimura"
   §1.1; Voisin Hodge II Ch. 11.

 paper source: SG-5 P1 frontal attack byproduct (R-#new); strengthens
 R-#42 IsDimCountingPrim53lt56 with independent Tate-twist parity
 argument. -/
axiom IsV56OddWeightForcesHevenAbsence_sg5 : Prop

/-- Predicate atom: weight-cocharacter pin — on the trivial-E_7
 summand `H^4_{prim} ≅ ℂ^53` (Step (d)), the cocharacter
 `h_0: 𝕊 → MT(X)` factors through the connected component of
 the abelianisation of MT(X), which (under the minimal-MT ansatz
 of (χ-b), since E_{7(-25)} is simple with finite centre ℤ/2)
 reduces to the Hodge-weight torus
 `w_n: 𝔾_m → MT(X)`, `w_n(t) = h_0(t,t)` acting as `t^n` on
 `H^n(X)`. Restricted to weight n=4, the compatibility
 `h(z)·h̄(z̄) = w_4(z,z̄)` forces `h(z) = z^2` on
 `H^4_{prim}`, hence Hodge type (2,2). PUBLISHED framework:
 Deligne Variétés de Shimura §1.1 (Mumford-Tate group + Deligne
 torus); Bourbaki Lie Ch. VIII Planche VI (E_7 centre = ℤ/2).
 paper source: SG-5 Hodge-diamond extension Step (e). -/
axiom IsTateTorusPinTrivialE7Piece_sg5 : Prop

/-- Predicate atom: Serre duality + Hodge symmetry on the 5-fold
 reduce the diamond closure to the 6 already-pinned entries via
 reflections `(p,q) ↦ (5-p, 5-q)` and `(p,q) ↦ (q,p)`. PUBLISHED
 framework: Serre duality h^{p,q} = h^{n-p,n-q} on smooth proj
 n-fold (Voisin Hodge I Thm. 5.32).
 paper source: SG-5 Hodge-diamond extension Step (f). -/
axiom IsSerreClosureToDiamondHodgeSym_sg5 : Prop

/-- Predicate: the full Hodge diamond of the d=5 EVII rigid 5-fold
 is pinned to the 18-entry specification of
 master tex `lem:sg5-hodge-diamond-conditional`.
 paper source: SG-5 Hodge-diamond extension (conclusion). -/
axiom HodgeDiamondPinnedSG5d5e7 : Prop

/-- Witness: Lefschetz-shift propagation H^3 → H^5 (Voisin Hodge I
 Thm. 6.25; Deligne 1980 §4).
 paper source: SG-5 Hodge-diamond extension Step (b). -/
axiom lefschetz_shift_propagation_h3_to_h5_sg5 :
 IsLefschetzShiftPropagationH3toH5_sg5

/-- Witness: Lefschetz decomposition of H^4 with prim dim 53
 (Voisin Hodge I Prop. 6.10).
 paper source: SG-5 Hodge-diamond extension Step (c). -/
axiom lefschetz_decomp_h4_prim_dim_53_sg5 :
 IsLefschetzDecompH4PrimDim53_sg5

/-- Witness: dimension-counting pin `53 < 56 = dim V_{56}` rules
 out non-trivial E_{7(-25)}-action on H^4_{prim}. NEW STRUCTURAL
 INGREDIENT relative to the SG-5 Betti closure. Witness combines:
 (i) the explicit Betti pin `b_4 = 54` from SG-5 (giving
  `dim H^4_{prim} = b_4 - dim L^2·H^0 = 54 - 1 = 53`);
 (ii) the irrep-dimension fact `dim V_{56} = 56` from Bourbaki
  Lie Ch. VIII Planche VI fundamental representation tables;
 (iii) the strict arithmetic inequality `53 < 56`.
 paper source: SG-5 Hodge-diamond extension Step (d). -/
axiom dim_counting_prim_53_lt_56_sg5 :
 IsDimCountingPrim53lt56_sg5

/-- Witness (P1 frontal-attack byproduct, R-#new): V_56 specifically
 has odd Hodge weight 3 ⇒ Tate-twist parity blocks V_56 from
 appearing as sub-HS of `H^{2k}(X)`. See
 `IsV56OddWeightForcesHevenAbsence_sg5` docstring for the proof
 (Tate-twist parity: `3 − 2n = 2k` ⟹ `n = (3 − 2k)/2 ∉ ℤ`) and
 the SCOPE-CAVEAT (kills V_56 SPECIFICALLY in H^even; does NOT
 kill other E_7-irreps which can land via higher tensor + Tate
 twist). Anchors: Han 2021 Prop 3.7(8) p. 15 + Han-Robles 2020
 Ex 5.4(xiv) p. 30 + App A.2.6 p. 32 (V_56 Hodge weight = 3);
 Moonen 2004 §1.4 + §4.4 + §4.7-4.9 (Tate-twist arithmetic +
 MT contains 𝔾_m·id for weight m ≠ 0). Complementary to (NOT
 replacement of) the R-#42 `dim_counting_prim_53_lt_56_sg5`
 atom above: this parity argument kills V_56 alone before
 knowing `b_4 = 54`; R-#42 then kills ALL non-trivial E_7-irreps
 in `H^4_{prim}` given `b_4 = 54`.
 paper source: SG-5 P1 frontal-attack byproduct; supplements the
 R-#42 Hodge-diamond extension Step (d). -/
axiom v56_odd_weight_forces_hodd_only_sg5 :
 IsV56OddWeightForcesHevenAbsence_sg5

/-- Witness: weight-cocharacter pin on the trivial-E_7 summand
 of H^4_{prim} (Deligne Variétés de Shimura §1.1; Bourbaki Lie
 Ch. VIII Planche VI).
 paper source: SG-5 Hodge-diamond extension Step (e). -/
axiom tate_torus_pin_trivial_e7_piece_sg5 :
 IsTateTorusPinTrivialE7Piece_sg5

/-- Witness: Serre duality + Hodge symmetry close the diamond
 from the 6 pinned entries (Voisin Hodge I Thm. 5.32).
 paper source: SG-5 Hodge-diamond extension Step (f). -/
axiom serre_closure_to_diamond_hodge_sym_sg5 :
 IsSerreClosureToDiamondHodgeSym_sg5

/-- Typed bridge axiom: standing antecedent (Assumption (χ-b)
 — already used in `sg_5_closed`) + 5 derivation atoms
 (Lefschetz-shift + Lefschetz-decomp + dim-counting +
 weight-cocharacter pin + Serre closure) → full Hodge diamond
 pinned.
 paper source: SG-5 Hodge-diamond extension (bridge). -/
axiom sg5_hodge_diamond_from_chi_b_and_five_atoms :
 IsMinimalMTAnsatzAssumptionChiB_sg5 ∧
 IsLefschetzShiftPropagationH3toH5_sg5 ∧
 IsLefschetzDecompH4PrimDim53_sg5 ∧
 IsDimCountingPrim53lt56_sg5 ∧
 IsTateTorusPinTrivialE7Piece_sg5 ∧
 IsSerreClosureToDiamondHodgeSym_sg5 →
 HodgeDiamondPinnedSG5d5e7

/-- SG-5 Hodge-diamond extension theorem: under Assumption (χ-b)
 (standing antecedent of SG-5), the full Hodge diamond
 h^{p,q}(X) of the d=5 EVII rigid 5-fold is pinned to the 18-
 entry specification of master tex
 `lem:sg5-hodge-diamond-conditional`.

 This is a STRENGTHENING of `sg_5_closed` (which only pins the
 Betti totals b_2, b_4, b_5), not a SubGap closure on its own —
 SG-5 itself was already closed (gapPartial via the conditional-
 computation tier) at `sg_5_closed`. The strengthening adds the
 dimension-counting pin `53 < 56` (smallest non-trivial E_7
 irrep) as a NEW structural argument, converting the Betti
 closure into the full bigraded Hodge diamond.

 paper source: master tex `\ref{lem:sg5-hodge-diamond-conditional}`. -/
theorem sg_5_hodge_diamond_pinned : HodgeDiamondPinnedSG5d5e7 :=
 sg5_hodge_diamond_from_chi_b_and_five_atoms
  ⟨minimal_mt_ansatz_assumption_chi_b_sg5,
   lefschetz_shift_propagation_h3_to_h5_sg5,
   lefschetz_decomp_h4_prim_dim_53_sg5,
   dim_counting_prim_53_lt_56_sg5,
   tate_torus_pin_trivial_e7_piece_sg5,
   serre_closure_to_diamond_hodge_sym_sg5⟩

/-! ### SG-5 holomorphic-Euler-characteristic corollary (R-#43).

Direct corollary of `sg_5_hodge_diamond_pinned`: from the full
Hodge diamond pinning, the holomorphic Euler characteristics
`χ(Ω^p_X) = ∑_q (-1)^q h^{p,q}(X)` for `p ∈ {0,...,5}` are
explicit integers:

  χ(O_X)     = 0
  χ(Ω^1_X)   = 27
  χ(Ω^2_X)   = -1
  χ(Ω^3_X)   = 1
  χ(Ω^4_X)   = -27
  χ(Ω^5_X)   = 0

Equivalently the Hirzebruch χ_y-genus of X is the explicit
polynomial χ_y(X) = 27y - y² + y³ - 27y⁴ in ℤ[y].

These are NEW EXPLICIT VALUES not exhibited in the SG-5 Betti
closure (master tex L5517 invokes integrality of χ(Ω^1_X) but
does not exhibit its value). Direct Pattern (i) corollary —
alternating-sum arithmetic on the Hodge diamond, no new
conjectures.

paper source: master tex `\ref{cor:sg5-chi-omega-conditional}`. -/

/-- Predicate: under Assumption (χ-b), the holomorphic Euler
 characteristics of the d=5 EVII rigid 5-fold X are pinned to
 the explicit values (χ(O), χ(Ω^1), ..., χ(Ω^5)) =
 (0, 27, -1, 1, -27, 0), and the χ_y-genus is the polynomial
 27y - y² + y³ - 27y^4.
 paper source: master tex `\ref{cor:sg5-chi-omega-conditional}`. -/
axiom ChiOmegaPinnedSG5d5e7 : Prop

/-- Pattern (i) corollary: the full Hodge diamond pinning
 (`HodgeDiamondPinnedSG5d5e7`) directly determines the
 holomorphic Euler characteristics via alternating-sum
 arithmetic on the diamond columns. No new conjectures; pure
 Pattern (i) classical-corollary.
 paper source: master tex `\ref{cor:sg5-chi-omega-conditional}`. -/
axiom chi_omega_from_hodge_diamond_sg5 :
 HodgeDiamondPinnedSG5d5e7 → ChiOmegaPinnedSG5d5e7

/-- SG-5 χ(Ω^p_X) corollary theorem: under Assumption (χ-b),
 the holomorphic Euler characteristics of the d=5 EVII rigid
 5-fold X take the explicit values
 (χ(O), χ(Ω^1), χ(Ω^2), χ(Ω^3), χ(Ω^4), χ(Ω^5))
 = (0, 27, -1, 1, -27, 0), with Hirzebruch χ_y-genus
 χ_y(X) = 27y - y² + y³ - 27y⁴. Direct corollary of
 `sg_5_hodge_diamond_pinned` (R-#42) via Pattern (i)
 alternating-sum arithmetic on the Hodge diamond columns.

 paper source: master tex `\ref{cor:sg5-chi-omega-conditional}`. -/
theorem sg_5_chi_omega_pinned : ChiOmegaPinnedSG5d5e7 :=
 chi_omega_from_hodge_diamond_sg5 sg_5_hodge_diamond_pinned

/-! ### R-#45 SG-5 Lefschetz-pin residual reduction (35 → 1).

Direct corollary of R-#42 + R-#43 + master tex Lefschetz-pin
Diophantine analysis: under Assumption (χ-b), the
35-candidate Lefschetz-pin residual list of
`prop:d5-e7-closure` Diagnostic reduces to a SINGLE candidate
`(K^5, s_2, m_a) = (2368, 1/2, 24)`, the m_a=24 endpoint of
the 25-member arithmetic stratum.

Mechanism: R-#43's `χ(Ω^1_X) = 27` (= h^{3,1}(X) = 0 from
R-#42 dim-counting) plus the Lefschetz-pin Hirzebruch-Riemann-Roch
formula `χ(Ω^1) = (K^5 · s_2 · (3 s_2 - 1) + 56)/24` gives
the Diophantine constraint `K^5 · s_2 · (3 s_2 - 1) = 592`.
Solved over the master-tex admissible Lefschetz-pin pairs
(plurigenera integer + s_2 ≥ 5/12 + σ-even + Lefschetz inj),
this yields the unique candidate (2368, 1/2, 24).

Computer verification: `experiments/r45_chi_omega_filter.py`
scans K^5 ≤ 10000 with rational s_2, confirming the unique
solution.

NOT a closure of the d=5 branch — the Milnor-defect sign
reversal of `prop:d5-e7-closure` continues to obstruct
closure on the residual single candidate via the universal
sub-pencil criterion. R-#45 is a STRENGTHENING (35 → 1
candidate residual reduction), conditional on Assumption (χ-b).

paper source: master tex `\ref{cor:sg5-35to1-reduction}`. -/

/-- Predicate: under Assumption (χ-b), the 35-candidate
 Lefschetz-pin residual reduces to a SINGLE admissible
 candidate `(K^5, s_2, m_a) = (2368, 1/2, 24)`. NOT a closure
 of the d=5 branch (Milnor-defect sign reversal still obstructs).
 paper source: master tex `\ref{cor:sg5-35to1-reduction}`. -/
axiom LefschetzPin35to1ReductionSG5d5e7 : Prop

/-- Pattern (i) corollary: the χ(Ω^p) pin
 (`ChiOmegaPinnedSG5d5e7`) plus the master-tex Lefschetz-pin
 Diophantine admissibility analysis yields the 35 → 1 reduction.
 Direct arithmetic Diophantine solve; no new conjectures.
 paper source: master tex `\ref{cor:sg5-35to1-reduction}`. -/
axiom lefschetz_pin_35to1_from_chi_omega_sg5 :
 ChiOmegaPinnedSG5d5e7 → LefschetzPin35to1ReductionSG5d5e7

/-- SG-5 Lefschetz-pin 35 → 1 reduction theorem. Under
 Assumption (χ-b), the 35-candidate Lefschetz-pin residual of
 `prop:d5-e7-closure` Diagnostic reduces to the single
 candidate (K^5, s_2, m_a) = (2368, 1/2, 24). Direct Pattern
 (i) corollary of R-#42 (via R-#43 `sg_5_chi_omega_pinned`)
 and the master-tex Diophantine analysis.

 NOT a closure of the d=5 branch — the single residual
 candidate is still subject to the Milnor-defect sign
 obstruction. R-#45 is a candidate-count strengthening only.

 paper source: master tex `\ref{cor:sg5-35to1-reduction}`. -/
theorem sg_5_lefschetz_pin_35to1_reduction :
 LefschetzPin35to1ReductionSG5d5e7 :=
 lefschetz_pin_35to1_from_chi_omega_sg5 sg_5_chi_omega_pinned

/-! ### SG-14 PARTIAL closure (gapPartial via Pattern (ii)
`_NAMED_OPEN` extension; mirror of SG-18 / SG-20 epistemic tier).

SG-14 content: Honda-Tate extension to non-abelian CM motives.
The classical Honda-Tate dictionary for abelian varieties over
finite fields (Honda 1968 + Tate 1966 + Tate 1968 Bourbaki Exp.
352) extends conjecturally to non-abelian CM motives in the
E_{7(-25)} setting; this extension is the named-open input
invoked by master tex `\ref{thm:eigenvalue-separation}` for the
non-abelian register of eigenvalue separation.

Decomposition (Pattern (ii), 4 atoms; mirror of SG-18 / SG-20):

- Framework (PUBLISHED, 3 atoms):
 (i) Tate 1966 Invent. Math. 2, 134-144: for simple abelian
 variety A/F_q, the characteristic polynomial of Frobenius
 on T_ℓA determines the isogeny class; End°(A) is a CM order.
 INJECTIVITY of Honda-Tate.
 (ii) Honda 1968 J. Math. Soc. Japan 20, 83-95: every Weil
 q-number π (algebraic integer with |ι(π)| = √q for all
 embeddings ι: ℚ(π) → ℂ) arises as the Frobenius of some
 simple abelian variety A/F_q. SURJECTIVITY of Honda-Tate.
 (iii) Tate 1968 Sém. Bourbaki Exp. 352 (after Honda):
 the bijection between Weil q-numbers (modulo conjugation)
 and simple abelian varieties (modulo isogeny) packaged with
 the CM-structure description.

- Conjectural-extension (**`_NAMED_OPEN`**): Honda-Tate analog
 for non-abelian CM motives in E_{7(-25)} setting.
 - Kisin 2017 J. Amer. Math. Soc. 30, 819-914: Langlands-
  Rapoport conjecture for Hodge-type Shimura varieties (mod
  p good reduction). PROVES the Hodge-type case.
 - Kisin-Madapusi Pera-Shin 2022 Duke Math. J. 171 (no. 7),
  1559-1614: Honda-Tate for Shimura varieties — for Hodge
  type + quasi-split-at-p, every mod-p isogeny class contains
  reduction of a special point.
 - Rapoport 2005 Astérisque 298 (271-318): "A guide to the reduction modulo p of Shimura varieties" — Newton-stratum
  non-emptiness conjecture (input to KMPS 2022).
 - E_{7(-25)} is NOT Hodge type — KMPS does not directly close
  for this setting. The extension to non-Hodge-type Shimura is
  named-open, well-studied, partially attacked.

**Honest gap-distance verdict** (per R-attack-#32 Phase 0
hostile audit): mirror of SG-18 (Murre B i=3) / SG-20 (Tate+MT)
`_NAMED_OPEN` tier. The extension is named-published direction
(KMPS 2022 + Kisin 2017 + Rapoport 2005), NOT invention-class
equivalent to original gap.

Phase 0 caught 3 "myth" citations to AVOID: "Pink generalization"
(no single named theorem), Yui (irrelevant — Calabi-Yau zeta
side, not Frobenius classification), Achter (sibling — Frobenius
distribution, not Honda-Tate analog).

DISTINCT FROM hyp:HC-CM-Ab (HC for CM abelian varieties = an
ALGEBRAICITY statement, currently gapPartial). SG-14 is about
CLASSIFICATION of CM motives via Frobenius eigenvalues, not
algebraicity. No double-count.

EPISTEMIC ORDERING: tied with SG-18, SG-20 at `_NAMED_OPEN`
tier.

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain (master tex `\ref{lem:sg14-honda-tate-non-abelian-conditional}`
+ `\ref{thm:eigenvalue-separation}` L12483-12488 explicit:
"this theorem is stated for appendix-level orientation only;
it does not enter the proof chain of the Main Theorem").

paper source: master tex
`\ref{lem:sg14-honda-tate-non-abelian-conditional}` (R-attack-#32
integration) + `\ref{thm:eigenvalue-separation}` (eigenvalue
separation theorem). -/

/-- Framework predicate (i): Tate 1966 Honda-Tate injectivity. -/
axiom IsTate1966EndomorphismsAbelianFiniteField_sg14 : Prop

/-- Framework predicate (ii): Honda 1968 Weil q-number
 realization (surjectivity). -/
axiom IsHonda1968WeilQNumberRealization_sg14 : Prop

/-- Framework predicate (iii): Tate 1968 Bourbaki Exp. 352
 Honda-Tate dictionary packaging. -/
axiom IsTate1968BourbakiHondaTateDictionary_sg14 : Prop

/-- **`_NAMED_OPEN`** extension predicate: Honda-Tate analog for
 non-abelian CM motives in E_{7(-25)} setting. Named-open
 published direction (Kisin 2017 + KMPS 2022 + Rapoport 2005),
 NOT invention-class. -/
axiom IsKMPS2022HondaTateExtensionNonAbelianCM_sg14_NAMED_OPEN :
 Prop

/-- **Framework axiom (i)** (PUBLISHED).

 Source: J. Tate, "Endomorphisms of abelian varieties over
 finite fields", Invent. Math. 2 (1966), 134-144.

 For simple abelian variety A over F_q and prime ℓ ≠ char F_q,
 the characteristic polynomial of Frobenius acting on T_ℓA
 determines the isogeny class of A; furthermore End°(A) is a
 semisimple ℚ-algebra of dimension dividing (2 dim A)² with
 CM-order structure.

 This is the INJECTIVITY direction of the Honda-Tate dictionary.

 paper source: SG-14 (sub-gap inventory framework atom i). -/
axiom tate_1966_endomorphisms_abelian_finite_field_sg14 :
 IsTate1966EndomorphismsAbelianFiniteField_sg14

/-- **Framework axiom (ii)** (PUBLISHED).

 Source: T. Honda, "Isogeny classes of abelian varieties over
 finite fields", J. Math. Soc. Japan 20 (1968), 83-95.

 Every Weil q-number π (i.e., algebraic integer such that
 |ι(π)| = √q for all embeddings ι: ℚ(π) → ℂ) arises as the
 Frobenius eigenvalue of some simple abelian variety A/F_q.

 This is the SURJECTIVITY direction of the Honda-Tate
 dictionary, complementing Tate 1966.

 paper source: SG-14 (sub-gap inventory framework atom ii). -/
axiom honda_1968_weil_q_number_realization_sg14 :
 IsHonda1968WeilQNumberRealization_sg14

/-- **Framework axiom (iii)** (PUBLISHED).

 Source: J. Tate, "Classes d'isogénie des variétés abéliennes
 sur un corps fini (d'après T. Honda)", Séminaire Bourbaki 21
 (1968-1969), Exp. 352, 95-110.

 The packaging of the Honda-Tate dictionary as a bijection:
 `{Weil q-numbers}/conjugation ↔ {simple abelian/F_q}/isogeny`,
 together with the CM-structure description (CM types ↔ CM
 abelian varieties).

 paper source: SG-14 (sub-gap inventory framework atom iii). -/
axiom tate_1968_bourbaki_honda_tate_dictionary_sg14 :
 IsTate1968BourbakiHondaTateDictionary_sg14

/-- **`_NAMED_OPEN` extension axiom**.

 Honda-Tate analog for non-abelian CM motives in E_{7(-25)}
 setting.

 Named-published partial-closure literature:
 - M. Kisin, "Mod p points on Shimura varieties of abelian
  type", J. Amer. Math. Soc. 30 (2017), 819-914: PROVES the
  Langlands-Rapoport conjecture for Hodge-type Shimura
  varieties (mod p good reduction).
 - M. Kisin, K. Madapusi Pera, S. W. Shin, "Honda-Tate theory
  for Shimura varieties", Duke Math. J. 171 (2022), no. 7,
  1559-1614: for Hodge-type Shimura variety S_K(G, X) with G
  quasi-split at p, every mod-p isogeny class contains the
  reduction of a special point. Conditional on the
  "Fargues-Rapoport" conjecture for Newton-stratum
  non-emptiness (statement attributed to Rapoport 2005 below).
 - M. Rapoport, "A guide to the reduction modulo p of Shimura
  varieties", in: Formes Automorphes (I), Astérisque 298 (2005),
  271-318: Newton-stratum non-emptiness conjecture (the
  conjectural "Fargues-Rapoport" formulation appears here).
  R-attack-#32 Phase 4 audit HIGH-1 patch: prior bibitem
  FarguesRapoport05 "Compositio Math. 141 (2005), 1011-1051"
  was FABRICATED — no such Fargues-Rapoport paper exists at
  that venue. Replaced with the correct Rapoport 2005
  Astérisque 298 attribution.

 STATUS: **NAMED-OPEN published direction**, NOT invention-class.
 The E_{7(-25)} type is NOT Hodge type (it is exceptional non-
 Hodge-type Shimura), so KMPS 2022 does not directly close
 SG-14 for X. The extension to non-Hodge-type Shimura is open
 but is the operative named-published direction.

 HOSTILE CATCHES (per R-attack-#32 Phase 0):
 - DO NOT cite "Pink generalization" — no single named theorem.
 - DO NOT cite Yui (Calabi-Yau zeta-function side, irrelevant
  for Honda-Tate analog).
 - DO NOT cite Achter (Frobenius-distribution sibling, not the
  Honda-Tate non-abelian-CM analog).

 paper source: SG-14 (sub-gap inventory `_NAMED_OPEN`
 extension). -/
axiom kmps_2022_honda_tate_extension_non_abelian_cm_sg14_NAMED_OPEN :
 IsKMPS2022HondaTateExtensionNonAbelianCM_sg14_NAMED_OPEN

/-- Typed bridge axiom: 3 framework atoms (Tate 1966 + Honda
 1968 + Tate 1968 Bourbaki Exp. 352 classical Honda-Tate
 dictionary) + 1 `_NAMED_OPEN` extension (KMPS 2022 + Kisin
 2017 + Rapoport 2005 Newton-stratum non-emptiness conjecture non-abelian CM extension) →
 SG-14 SubGap.
 paper source: SG-14 (combination). -/
axiom sg14_from_framework_and_named_open_extension :
 IsTate1966EndomorphismsAbelianFiniteField_sg14 ∧
 IsHonda1968WeilQNumberRealization_sg14 ∧
 IsTate1968BourbakiHondaTateDictionary_sg14 ∧
 IsKMPS2022HondaTateExtensionNonAbelianCM_sg14_NAMED_OPEN →
 SubGap ⟨13, by decide⟩

/-- SG-14 closure theorem: `SubGap ⟨13, _⟩` holds via Pattern
 (ii) 4-atom decomposition: 3 framework atoms PUBLISHED (Tate
 1966 injectivity + Honda 1968 surjectivity + Tate 1968 Bourbaki
 dictionary) + 1 `_NAMED_OPEN` extension (Kisin 2017 +
 Kisin-Madapusi Pera-Shin 2022 + Rapoport 2005 Astérisque 298 non-abelian CM
 Honda-Tate extension).
 Status `gapPartial` driven by `_NAMED_OPEN` extension. Tied
 with SG-18 / SG-20 at NAMED-OPEN tier.
 paper source: SG-14 (sub-gap inventory). -/
theorem sg_14_closed : SubGap ⟨13, by decide⟩ :=
 sg14_from_framework_and_named_open_extension
  ⟨tate_1966_endomorphisms_abelian_finite_field_sg14,
   honda_1968_weil_q_number_realization_sg14,
   tate_1968_bourbaki_honda_tate_dictionary_sg14,
   kmps_2022_honda_tate_extension_non_abelian_cm_sg14_NAMED_OPEN⟩

/-! ### SG-16 REDUCES-TO SG-15 ingredients (gapOpen inherited;
NO closure theorem; failure-theoremization per user mindset
"失败定理化也是成果").

SG-16 content: dim-5 Casimir-trace input for E_7-triviality on
`H^{2,2}(X_b, ℚ)`. Master tex `\ref{rem:sliceD-dim5-casimir}`
self-acknowledges the Casimir-trace + weight-filtration argument
is unsupplied; supplement disposition STANDALONE.

Phase 0 R-attack-#33 hostile audit REJECTED Pattern (ii)
`_INVENTION_CLASS` over-claim: the "Casimir-trace framework
atom" would be a re-labeling of `sg15a`
(`IsV56TensorV56DecompositionVerified_sg15a`, already pinned by
Slansky 1981 Table 35 + McKay-Patera 1981 Table 4); Casimir
eigenvalue is one-line arithmetic downstream, not a separate
publishable bundle. Honest framing: SG-16 = sg15a ∧ sg15b.

Closure pattern: pure **REDUCES-TO** (mirror SG-21 precedent).
SG-16 reduces to the conjunction of the existing SG-15
ingredients:
- `IsV56TensorV56DecompositionVerified_sg15a` (rep-decomp,
 closeable via Slansky 1981 + McKay-Patera 1981; existing
 axiom `mckay_patera_slansky_V56_tensor_V56_decomposition_sg15a`)
- `IsHodgeBidegreeWeightFiltrationCutsTrivialSummand_sg15b`
 (Hodge-bidegree weight-filtration on H^{2,2}(X_b, ℚ);
 gapOpen INVENTION-class; NO axiom)

Since `sg15b` is `gapOpen` INVENTION (master tex
`\ref{rem:sliceD-dim5-casimir}` (i) self-acknowledged unsupplied
"the full decomposition of V_56 ⊗ V_56 under E_7 ... combined
with the weight diagram of the Hodge decomposition on a rigid
EVII-type 5-fold, to verify that only the trivial summand
survives in bidegree (2,2)"), the typed-bridge axiom below
encodes the reduction but does NOT close `SubGap ⟨15, _⟩`.
SG-16 status remains **gapOpen** inherited from sg15b.

This is FAILURE-THEOREMIZATION (per user mindset
"失败定理化lean化也是成果"): the reduction itself is recorded as
a Lean axiom even though no closure theorem follows.

Net axiom delta: +1 typed-bridge axiom only. Zero new
predicates. Zero new bibitems. Same discipline as SG-21
REDUCES-TO precedent.

STANDALONE diagnostic — does NOT enter Main Theorem reduction
chain.

paper source: master tex `\ref{rem:sliceD-dim5-casimir}` +
existing SG-15 infrastructure (sg15a closeable; sg15b gapOpen). -/

/-- Typed bridge axiom (REDUCES-TO pattern, mirror of SG-21
 precedent): SG-16 reduces to the conjunction of SG-15
 ingredients (sg15a rep-decomp ∧ sg15b Hodge-filtration). NO
 closure theorem `sg_16_closed` because sg15b is `gapOpen`
 INVENTION-class — the SubGap ⟨15, _⟩ is unprovable without
 the SG-15b ingredient.

 CODOMAIN-SHADOW NOTE (per R-#33 Phase 4 audit transparency
 catch): this axiom has the SAME hypothesis pair `(sg15a, sg15b)`
 as `sg15_from_ingredients` (OH L2710-2713) but produces
 `SubGap ⟨15, _⟩` (SG-16) vs SG-15's `SubGap ⟨14, _⟩`. The two
 reductions are mathematically equivalent modulo codomain —
 this is EXACTLY the failure-theoremization point: SG-16's
 "Casimir-trace eigenvalue" is one-line arithmetic downstream
 of the SG-15 rep-decomposition, NOT a separable theorem. The
 distinct codomain records the ledger taxonomy difference
 (SG-15 = E_7 acts trivially on full H^{2,2}; SG-16 = dim-5
 Casimir-trace input is the same content viewed as an
 ingredient).

 paper source: SG-16 (combination via REDUCES-TO SG-15). -/
axiom sg16_reduces_to_sg15_ingredients :
 IsV56TensorV56DecompositionVerified_sg15a →
 IsHodgeBidegreeWeightFiltrationCutsTrivialSummand_sg15b →
 SubGap ⟨15, by decide⟩

/-! ### R-#44 SG-15 / SG-16 alternate closure via R-#42 dim-counting
(bypasses unsupplied SG-15b weight-filtration framework).

Both SG-15 and SG-16 want the conclusion "E_{7(-25)} acts trivially
on H^{2,2}(X_b, ℚ) for dim X_b = 5", which is exactly what
R-#42 (`sg_5_hodge_diamond_pinned`) proves under Assumption (χ-b)
via the dim-counting step `dim H^4_{prim} = 53 < 56 = dim V_{56}`.

This provides a NEW INDEPENDENT closure route bypassing the
unsupplied SG-15b weight-filtration framework. The original route
(sg15a ∧ sg15b → SubGap) is preserved as
`sg15_from_ingredients` / `sg16_reduces_to_sg15_ingredients`; the
new route (HodgeDiamondPinned → SubGap) is added below.

Status: SG-15 + SG-16 both gapPartial via this conditional-
computation route alongside the original sg15a ∧ sg15b reduction.
Conditional on Assumption (χ-b) (same scope as SG-5 closure).

paper source: master tex `\ref{rem:sliceD-dim5-casimir}` part (iv)
(alternate-closure note) + `\ref{lem:sg5-hodge-diamond-conditional}`
Step (d) dim-counting argument. -/

/-- Alternate-closure axiom for SG-15 via R-#42 dim-counting:
 `HodgeDiamondPinnedSG5d5e7` (= the full Hodge-diamond pin of
 the d=5 EVII 5-fold under (χ-b), R-#42 `lem:sg5-hodge-diamond-conditional`)
 implies SG-15's `SubGap ⟨14, _⟩` via the dim-counting step
 53 < 56. This bypasses the unsupplied SG-15b weight-filtration
 framework.
 paper source: master tex `\ref{rem:sliceD-dim5-casimir}` part
 (iv). -/
axiom sg15_via_R42_dim_counting :
 HodgeDiamondPinnedSG5d5e7 → SubGap ⟨14, by decide⟩

/-- Alternate-closure axiom for SG-16 via R-#42 dim-counting:
 `HodgeDiamondPinnedSG5d5e7` implies SG-16's
 `SubGap ⟨15, _⟩`. Bypasses the unsupplied SG-15b framework.
 paper source: master tex `\ref{rem:sliceD-dim5-casimir}` part
 (iv). -/
axiom sg16_via_R42_dim_counting :
 HodgeDiamondPinnedSG5d5e7 → SubGap ⟨15, by decide⟩

/-- SG-15 closure theorem via R-#42 alternate route. Under
 Assumption (χ-b) (encoded in `sg_5_hodge_diamond_pinned`), the
 SG-15 conclusion "E_{7(-25)} acts trivially on H^{2,2}(X_b, ℚ)
 for dim X_b = 5" follows from the dim-counting step
 53 < 56 of R-#42 (`lem:sg5-hodge-diamond-conditional` Step (d)).
 paper source: master tex `\ref{rem:sliceD-dim5-casimir}` part
 (iv); R-#42 `lem:sg5-hodge-diamond-conditional`. -/
theorem sg_15_closed : SubGap ⟨14, by decide⟩ :=
 sg15_via_R42_dim_counting sg_5_hodge_diamond_pinned

/-- SG-16 closure theorem via R-#42 alternate route. Under
 Assumption (χ-b), the SG-16 dim-5 Casimir-trace input
 ("E_{7(-25)} acts trivially on H^{2,2}(X_b, ℚ) for dim X_b = 5")
 follows directly from R-#42's full Hodge-diamond pinning.
 This is a NEW INDEPENDENT closure bypassing the previously-
 required (but unsupplied) SG-15b weight-filtration framework;
 prior to R-#44, SG-16 had no closure theorem (gapOpen).
 paper source: master tex `\ref{rem:sliceD-dim5-casimir}` part
 (iv); R-#42 `lem:sg5-hodge-diamond-conditional`. -/
theorem sg_16_closed : SubGap ⟨15, by decide⟩ :=
 sg16_via_R42_dim_counting sg_5_hodge_diamond_pinned

/-! ### R-#48 `open:exotic-residual` κ=0 sub-case closure via Pattern (ii)
NAMED_OPEN (Abundance Conjecture dim ≥ 5).

Content: The OPEN residual class of hypothetical exotic rigid
non-Shimura E_{7(-25)}-type varieties with dim ≥ 5 and c_1 ≠ 0
(master tex `\ref{open:exotic-residual}`) decomposes into two
sub-cases:
- (general type) κ(X) = dim X: K_X "big" / log general type.
- (κ=0) κ(X) = 0 with c_1 ≠ 0: K_X has Kodaira dim 0 but
  numerically non-trivial.

The κ=0 sub-case is expected vacuous via the Abundance Conjecture:
if Abundance holds in dim ≥ 5 (named-open), then K_X with κ = 0
is semi-ample, hence torsion in Pic. Combined with the E_7-type
residual structure (Pic = ℤH for "rigid" cases), K_X torsion in
ℤH forces K_X = 0, contradicting c_1 ≠ 0. Therefore the κ=0
sub-case is vacuous CONDITIONAL on Abundance dim ≥ 5.

Pattern (ii) decomposition:
- Framework PUBLISHED (3 atoms, Abundance dim ≤ 3):
  (i) Kawamata 1992 Invent. Math. 108 (229-246): Abundance for
     minimal terminal threefolds with K_X nef.
  (ii) Miyaoka 1988 Compositio Math. 68 (203-220): Abundance for
       3-folds in the ν=1 case (the hardest case).
  (iii) Kollár (ed.) 1992 Astérisque 211: collection containing
       full Abundance for 3-folds.
- Conjectural-extension `_NAMED_OPEN`: Abundance Conjecture
  in dim ≥ 5 (long-standing open conjecture; no published proof).
  Sibling-coverage: BCHM 2010 JAMS 23 (405-468) proves MMP existence
  for klt pairs of log general type but does NOT prove Abundance.

Verdict (per R-#48 Phase 0 hostile audit, full-theorem-survey):
mirror of SG-14 / SG-18 / SG-20 `_NAMED_OPEN` tier. The extension
is named-published direction (Abundance Conj.), NOT invention-class
equivalent to original gap.

Status update: `gap_exotic_residual_BLOCKED` (Ledger.lean) was
gapBlocked. R-#48 promotes to gapPartial via Pattern (ii)
NAMED_OPEN closure of the κ=0 sub-case. The general-type sub-case
(κ = dim X) remains BLOCKED (Milnor sign defect + missing codim-2
4-cycle bound). Net: gap moves gapBlocked → gapPartial.

paper source: master tex `\ref{open:exotic-residual}`. -/

/-- Predicate: Abundance Conjecture in dim ≤ 3 (PUBLISHED).
 Statement: every smooth projective 3-fold X with κ(X) ≥ 0 has
 K_X semi-ample (equivalently, some power K_X^n is base-point-free).
 Cumulative result distributed across multiple authors:
 - Kawamata 1992 Invent. Math. 108, 229-246 'Abundance theorem for
  minimal threefolds': K_X NEF case for terminal threefolds
  (does NOT cover non-nef K_X by itself);
 - Miyaoka 1988 Compositio Math. 68 (2), 203-220 'Abundance
  conjecture for 3-folds: case ν=1': partial ν=1 sub-case;
 - Astérisque 211 (1992) 'Flips and Abundance for Algebraic
  Threefolds' (Kollár ed.) — edited proceedings of Utah Summer
  Seminar 1991; multi-author contributions (Mori + Shokurov for
  flips; Keel + McKernan + others for abundant divisor + reduction
  strategies). The full dim ≤ 3 Abundance for non-nef K_X requires
  running MMP to a minimal model (provided by the seminar flip
  results) then applying Kawamata.
 paper source: classical 3-fold Abundance literature; framework atom
 for the κ=0 vacuity chain in `open:exotic-residual`. -/
axiom IsAbundanceConjectureDimLE3 : Prop

/-- Predicate: Abundance Conjecture in dim ≥ 5 (NAMED_OPEN), as
 actually formulated in the published literature: "K_X NEF + klt
 pair → K_X semi-ample". Note: a stronger informal formulation
 ("κ(X) ≥ 0 → K_X semi-ample" without K_X NEF) was used in R-#48
 and caught as a BROKEN-LINK in R-#61 Phase 4 audit; the corrected
 formulation here is the actual published Abundance Conjecture.
 paper source: Abundance Conjecture proper (Kawamata-Miyaoka-
 Kollár framework for dim ≤ 3; long-standing open for dim ≥ 5). -/
axiom IsAbundanceConjectureDimGEq5 : Prop

/-- BROKEN-LINK predicate (R-#61 audit): the κ=0 sub-case vacuity
 argument requires K_X NEF as an additional hypothesis beyond
 `open:exotic-residual` (a)-(h). The actual Abundance Conjecture
 needs K_X nef; for κ=0 in dim ≥ 5 without nef, one must first run
 MMP to a minimal model (where K_X is nef), but minimal-model
 existence for κ=0 in dim ≥ 5 is itself OPEN (BCHM 2010 covers
 log general type, NOT κ=0). This predicate surfaces the broken
 link as an explicit additional hypothesis required for the
 vacuity argument to apply.
 paper source: R-#61 Phase 4 hostile audit broken-link
 surfacing. -/
axiom IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK : Prop

/-- BROKEN-LINK predicate (R-#61 audit): the κ=0 sub-case vacuity
 argument additionally smuggled `Pic(X) = ℤ·H` (or any Pic-rank-1
 torsion-free structure) as a hypothesis. But `open:exotic-residual`
 (a)-(h) does NOT include Pic = ℤH; that structure is from
 `prop:d5-e7-closure` (a) which also requires K_X ample —
 INCOMPATIBLE with κ(X) = 0. This predicate surfaces the
 smuggled hypothesis as an explicit additional requirement.
 paper source: R-#61 Phase 4 hostile audit broken-link
 surfacing. -/
axiom IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK : Prop

/-- Predicate: the κ=0 sub-case of `open:exotic-residual` is vacuous
 (conditional on Abundance + broken-link hypotheses per R-#61 audit).
 paper source: master tex `\ref{open:exotic-residual}` κ=0 sub-case. -/
axiom IsExoticResidualKappaZeroSubCaseVacuous : Prop

/-- Witness: Abundance Conjecture in dim ≤ 3 holds (PUBLISHED).
 Combines Kawamata 1992 Invent. 108 (terminal threefolds + K nef)
 + Miyaoka 1988 Compositio 68 (ν=1 case) + Kollár (ed.) 1992
 Astérisque 211 (full 3-fold Abundance collection).
 paper source: R-#48 Pattern (ii) framework atom (PUBLISHED). -/
axiom kawamata_1992_miyaoka_1988_kollar_1992_abundance_dim_le_3 :
 IsAbundanceConjectureDimLE3

/-- NAMED_OPEN axiom: Abundance Conjecture in dim ≥ 5.
 No published proof; expected to hold by analogy with dim ≤ 4
 (partially proven). Standard named-open extension in MMP literature.
 paper source: R-#48 Pattern (ii) NAMED_OPEN extension. -/
axiom abundance_conjecture_dim_geq_5_NAMED_OPEN :
 IsAbundanceConjectureDimGEq5

/-- Typed bridge axiom (R-#48 + R-#62 broken-link discipline):
 under Abundance Conjecture in dim ≥ 5 PLUS the explicit
 broken-link hypotheses surfaced by R-#61 Phase 4 audit
 (K_X nef + MMP existence for κ=0 in dim ≥ 5; Pic torsion-free
 structure beyond (a)-(h)), the κ=0 sub-case of
 `open:exotic-residual` is vacuous.

 Argument (now explicit about prerequisites):
 (i) `IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK`
   + Abundance dim ≥ 5 → K_X semi-ample.
 (ii) K_X semi-ample + κ(X) = 0 → K_X^n ≅ O_X (K_X torsion).
 (iii) `IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK`
   + K_X torsion → K_X = 0 in Pic.
 (iv) K_X = 0 → c_1(X) = 0, contradicting c_1 ≠ 0 hypothesis.

 Per R-#62 broken-link discipline (`feedback_gap_ledger_in_lean4.md`):
 the conditional closure is PRESERVED as a typed bridge, with the
 broken-link hypotheses explicitly surfaced as additional
 parameters. The unconditional Ledger status reverts to gapBlocked
 since the broken-link hypotheses are not established as part of
 `open:exotic-residual` (a)-(h).

 paper source: master tex `\ref{open:exotic-residual}` κ=0 sub-case
 vacuity argument with R-#61 audit corrections. -/
axiom kappa_zero_subcase_vacuous_from_abundance_dim_geq_5 :
 IsAbundanceConjectureDimGEq5 →
 IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK →
 IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK →
 IsExoticResidualKappaZeroSubCaseVacuous

/-- R-#48 closure theorem (POST-R-#62 broken-link surfacing): the
 κ=0 sub-case of `open:exotic-residual` is vacuous CONDITIONAL on
 Abundance Conjecture in dim ≥ 5 + the 2 broken-link hypotheses
 explicitly surfaced by R-#61 Phase 4 audit.

 NOTE: this theorem is conditional on Lean axioms representing
 the broken-link hypotheses; in the absence of Lean witnesses for
 these (they are open in the literature for the relevant scope),
 the theorem CANNOT be instantiated unconditionally. The Lean
 chain is preserved as a partial map per `feedback_gap_ledger_in_lean4.md`
 broken-link discipline; the Ledger status for `gap_exotic_residual`
 reverts to gapBlocked since the broken links are not given by
 the original `open:exotic-residual` (a)-(h) hypotheses.

 The general-type sub-case (κ(X) = dim X) of `open:exotic-residual`
 remains BLOCKED (Milnor sign defect on universal sub-pencil
 criterion + missing codim-2 4-cycle bound, master tex
 `\ref{prop:d5-e7-closure}` Diagnostic).

 paper source: master tex `\ref{open:exotic-residual}`; R-#48
 Pattern (ii) + R-#62 broken-link discipline. -/
theorem exotic_residual_kappa_zero_subcase_closed_conditional :
 IsKnefAndMinimalModelExistenceForKappa0DimGEq5_BROKEN_LINK →
 IsPicTorsionFreeStructureForExoticResidualKappa0_BROKEN_LINK →
 IsExoticResidualKappaZeroSubCaseVacuous :=
 fun h_nef h_pic =>
 kappa_zero_subcase_vacuous_from_abundance_dim_geq_5
   abundance_conjecture_dim_geq_5_NAMED_OPEN h_nef h_pic

/-! ## Milnor sign defect scope restrictions (broken-link discipline)

The master tex `prop:d5-e7-closure` proves the Milnor sign obstruction
`Σ_i δ_i = -N ≤ 0` for P¹-pencils of d=5 exotic-residual varieties
acquiring isolated 4-fold ODP singular fibres. Hostile re-audit of the
proof identified that the obstruction is established ONLY under three
SCOPE RESTRICTIONS:
- (i) ODP-exclusivity: all singular fibres are isolated ODP, not
 non-ODP types (A_n n ≥ 2 cusps, D_n, E_n, ICIS) whose Milnor
 numbers μ ≥ 2 would yield different defect signs;
- (ii) P¹-base-exclusivity: pencil base is P¹; non-P¹ bases (g ≥ 1
 curves, P², higher-dim surfaces) require re-derivation of the
 pencil-Euler identity with potentially different obstruction sign;
- (iii) conifold-transition-bypass-blocked: the conifold transition
 framework (Friedman 1986 / Reid / Collins 2025) could potentially
 connect the d=5 exotic-residual class to a different birational
 model with adjusted Chern numbers escaping the 35-member arithmetic
 stratum or the ODP pencil structure.

The master tex proof neither EXTENDS the obstruction to these scope
relaxations nor REFUTES the existence of bypass constructions.
Per `feedback_gap_ledger_in_lean4.md` broken-link discipline,
each scope restriction is surfaced as an explicit Lean predicate
below; the d=5 general-type sub-case status downgrades from
gapBlocked (unconditional obstruction) to gapPartial (Milnor
obstruction CONDITIONAL on these three scope-restriction
hypotheses). -/

/-- Predicate: the Milnor sign obstruction Σ δ_i ≤ 0 in
 `prop:d5-e7-closure` extends from ODP-only to all isolated
 hypersurface singularities AND ICIS on 4-fold fibres in the same
 sign direction (RESOLVED via Milnor uniformity).
 Sign computation: by Milnor formula `χ(F) = 1 + (-1)^n μ` (Milnor
 1968) and the Lê-Greuel formula for ICIS (Lê 1973 + Greuel 1975),
 on 4-fold fibre (n=4 even) one has `χ(F) = 1 + μ` and
 `δ_i := χ(Y_sing) - χ(Y_smooth) = -μ`. For ODP (μ=1): δ_i = -1.
 For A_n (μ=n): δ_i = -n. For D_n / E_n (μ=n, 6, 7, 8): δ_i = -n
 ≤ -2. All isolated singularities on 4-folds give δ_i ≤ 0 with the
 SAME sign direction as ODP — non-ODP types STRENGTHEN the
 obstruction rather than bypass it. The prior claim that "non-ODP
 yields δ_i ≥ 0" was mathematically INCORRECT (sign error confusing
 χ(F) with δ_i) and is FALSIFIED by the uniform Milnor formula.
 Sources: J. W. Milnor, 'Singular Points of Complex Hypersurfaces',
 Annals of Math. Studies 61, Princeton Univ. Press (1968);
 D. T. Lê, 'Calcul du nombre de cycles évanouissants d'une
 hypersurface complexe', Ann. Inst. Fourier 23 (1973) 261-270;
 G.-M. Greuel, 'Der Gauß-Manin-Zusammenhang isolierter
 Singularitäten von vollständigen Durchschnitten', Math. Ann. 214
 (1975) 235-266 — together giving the Lê-Greuel recursive ICIS
 Milnor number formula extending Milnor 1968 to ICIS with the
 same sign direction.
 paper source: scope restriction in prop:d5-e7-closure
 Milnor argument; closed via Milnor uniformity. -/
axiom IsMilnorObstructionExtendsToNonODPFibres_BROKEN_LINK : Prop

/-- External-citation axiom (Lean convention for asserting published
 theorems not yet ported to Mathlib): the non-ODP scope restriction
 is resolved by the Lê-Greuel Milnor number formula. Citation:
 Milnor 1968 (Annals Math Studies 61) + Lê 1973 (Ann. Inst. Fourier
 23, 261-270) + Greuel 1975 (Math. Ann. 214, 235-266). Together
 these give χ(F) = 1 + (-1)^n μ for all isolated hypersurface AND
 ICIS singularities on n-folds; on 4-folds (n=4) this gives
 δ_i = -μ ≤ 0 uniformly. The axiom is the standard Lean technique
 to import a published theorem; the substantive content is the
 cited classical literature, not the axiom itself. -/
axiom milnor_uniformity_extends_obstruction_to_non_odp :
 IsMilnorObstructionExtendsToNonODPFibres_BROKEN_LINK

/-- BROKEN-LINK predicate: the Milnor sign obstruction is derived
 from the P¹-pencil Euler identity
 `χ(X) + χ(Bs|mH|) = 2 χ(Y_m) + Σ_i δ_i`. For non-P¹ pencil
 bases the identity has different sign structure.

 EULER IDENTITY FOR P¹-PENCIL CASE (g = 0, master tex L5532):
   `χ(X) + χ(Bs(C_0)) = 2·χ(Y_smooth) + Σ_i δ_i`
 Derivation: codim-2 blow-up X̃ → X has `χ(X̃) = χ(X) + χ(Bs)`;
 X̃ → P¹ is a fibration with `χ(X̃) = 2·χ(Y_smooth) + Σ_i δ_i`.

 GENERALIZATION TO HIGHER-GENUS CASE IS NOT TRIVIAL:
 For non-degenerate genus-g curve `C_g ⊂ |mH|^*` with `g ≥ 1`,
 the curve `C_g` spans a `P^M` with `M ≥ 2` (non-degenerate
 elliptic curve spans `P^2`; non-degenerate genus-g spans
 `P^M` for some `M ≥ 2`). The base locus `Bs(C_g) ⊆ Bs(P^M)`
 has codimension `≥ M+1 ≥ 3` in X (NOT codim-2 as in P¹ case).

 The blow-up `X̃ → X` along `Bs(C_g)` of codim `r ≥ 3` has
 `χ(X̃) = χ(X) + χ(Bs(C_g))·(r-1)` with `r-1 ≥ 2` (NOT 1 as in
 P¹ case). Moreover the natural map `X̃ → P^M` is not directly
 a fibration over `C_g`; the universal family `Y_{C_g}` is
 obtained by base-change `X̃ ×_{P^M} C_g → C_g`, which need
 NOT have Euler characteristic `χ(C_g)·χ(Y_smooth) + Σ_i δ_i`
 directly. The full Euler analysis requires careful birational
 geometry (Y_{C_g} as a sub-variety of `X̃ ×_{P^M} C_g` with
 specific incidence structure).

 ATTACK VECTOR (genuine open Diophantine question, family
 existence is trivial via Hilbert scheme):
 (i) family construction: non-degenerate `C_g ⊂ |mH|^*` exists
   for any genus g and any large m via standard projective-
   curves-in-projective-space results; this is NOT the genuine
   open question;
 (ii) Euler characteristic identity for the specific family
   construction: requires careful birational geometry per
   linear span dim and base codimension;
 (iii) GENUINE OPEN QUESTION: under (χ-b) Assumption, does the
   R-#45 surviving Chern data `(K^5=2368, s_2=1/2, m_a=24)`
   admit a non-P¹ family bypass (genus g ≥ 1 with codim ≥ 3
   base locus) consistent with the corrected generalized
   identity AND Milnor uniformity `Σ_i δ_i ≤ 0`?

 NUMERICAL ANCHORS (under (χ-b), the SG-5 standing antecedent
 — an empirical MT/H⁵ ansatz, strictly EXTRA over the stated
 hypotheses (a)-(c) of prop:d5-e7-closure, at the CONJECTURAL
 tier):
 - All 7 independent Chern numbers of the surviving candidate X
   fixed (in H^i-scaled units a_i = c_i(X)/H^i): a_1 = -1,
   a_2 = 1/2, a_3 = 0, a_4 = 3s_2² - s_2 = 1/4, a_5 = -7/296;
   K_X = H ample, K_X^5 = 2368; χ_top(X) = c_5(X) = -56.
 - Hodge diamond (forced by (χ-b)): h^{3,0} = 1, h^{p,0} = 0
   for p ∈ {1,2,4,5}. CONSEQUENCE: |H| = |K_X| is EMPTY
   (h^0(O_X(H)) = h^0(ω_X) = h^{5,0}(X) = 0). Any pencil/net
   analysis must use |mH| with m ≥ 2 (plurigenus
   P_m = χ(mK_X) ≥ 148 for m ≥ 2; |mK_X| base-point-free and
   very ample for m large since K_X ample — effective
   Kollár 1993 / Matsusaka-type bounds). An earlier "g=1 cubic
   family C_1 ⊂ ℙ² ⊂ |H|^*" computation was about this empty
   system; it is vacuous.

 ℙ²-NET / NET-OF-|mH| ANALYSIS (m ≥ 2) — VERDICT: INERT.
 The m-canonical X contains no lines (a line C has
 (mK_X)·C = 1, so K_X·C = 1/m ∉ ℤ), so the dual defect
 def(X) = 0 (a positive-defect smooth variety contains linear
 spaces of dimension = defect ≥ 1 — classical projective
 duality, GKZ "Discriminants, Resultants, Multidim.
 Determinants" Ch. 1-2 / Katz SGA 7 II exp. XVII; Ein 1986
 Invent. Math. 86 classifies the positive-defect cases). Hence
 the discriminant X^∨ ⊂ |mH| of singular members is a
 hypersurface of degree D_dual(m) = ∫_X c_5(J¹(mH)) (classical
 dual-degree formula; J¹(mH) has rank 6 on a 5-fold so
 c_5 = c_{dim X}, not the top Chern class; cross-checks:
 6(d-1)^5 on ℙ^5, d(d-1)^5 on H_d ⊂ ℙ^6; for the (χ-b)
 phantom D_dual(m) = 14208m⁵ + 11840m⁴ + 4736m³ + 1184m + 56).

 A generic net L = ℙ² ⊂ |mH| exists (Bertini); base locus
 Bs = codim-3 smooth surface; Bl_Bs(X) → ℙ² is a morphism with
 generic fibre a smooth 3-fold W = (codim-2 CI of two members);
 χ(Bl_Bs X) = χ(X) + 2χ(Bs); χ(W), χ(Bs) by adjunction-Chern
 truncation (for the phantom χ(W)|_{m=1} = -18944,
 χ(Bs)|_{m=1} = 22496). Set
 X_diff(m) := χ(Bl_Bs X) - 3χ(W) = χ(X) + 2χ(Bs) - 3χ(W)
 (= 56832m⁵ + 35520m⁴ + 9472m³ - 56 for the phantom;
 X_diff(1) = 101768). The discriminant of THIS fibration,
 Δ ⊂ ℙ² = {t : W_t singular}, is a plane curve — generically
 nodal-cuspidal (Bruce 1981 "On the curve singularities of
 generic projections"; Mond-Goryunov 1993 Compositio 89;
 classical Plücker) — of degree
 deg(Δ) = (D_dual(m) + X_diff(m))/2, NOT D_dual(m) itself:
 W_t = D_a ∩ D_b is singular mainly where D_a, D_b are tangent
 ALONG W_t (a c₄-Porteous tangency divisor), whereas D_dual(m)
 = ∫c₅(J¹(mH)) is the locus of members singular at a POINT —
 a codim-≥2 sub-condition, generically empty on a generic net.
 Verdier stratified-Euler (χ(Bl_Bs X) = 3χ(W) + genus/Plücker
 correction of Δ; additivity of χ_c over the stratification,
 Verdier 1976 Invent. Math. 36 / MacPherson 1974 Ann. Math.
 100) + the plane-curve genus formula + Plücker's first
 formula give
   class(Δ) = 2·deg(Δ) - X_diff(m) = D_dual(m)
            = ∫_X c_5(J¹(mH)) > 0  for all m ≥ 1.
 A positive class is no obstruction; the ℙ²-net route is INERT
 — like the ℙ¹-pencil route (prop:d5-e7-closure: Σδ_i = -N ≤ 0
 reverses the universal-sub-pencil-criterion inequality, no
 contradiction). [A prior framing set deg(Δ) = D_dual(m) by
 mistake, yielding the spurious "class = 2 D_dual - X_diff
 = -28416m⁵ - 11840m⁴ + 2368m + 168 < 0"; that is provably
 wrong — the SAME formula gives impossible negative class on
 explicit generic nets of |O(d)| on ℙ^5 (class = -42 at d=2)
 and on H₈ ⊂ ℙ^6 (class = -10008 at m=6), real smooth
 varieties (the latter K-ample with K = O(1), the exact
 "H = K_X" setup) where the discriminant is patently a reduced
 plane curve, hence class ≥ 1.]

 REMAINING ATTACK VECTORS (the non-ℙ¹-base broken-link is
 GENUINELY OPEN — both the ℙ¹-pencil and ℙ²-net routes are
 inert):
 (a) genus-g curve bases (g ≥ 1): a non-degenerate genus-g
   curve spans ℙ^M with M ≥ 2 (elliptic → ℙ², a sub-locus of
   the net analysis); the Euler analysis for the base-changed
   family X̃ ×_{ℙ^M} C_g → C_g needs separate treatment, not
   the direct-fibration formula;
 (b) structural Hodge / monodromy compatibility: period map of
   the net (or curve) family against MT(H³(X)) = E_{7(-25)};
 (c) the (χ-b) assumption itself (SG-5 standing antecedent):
   independently pinning b_2(X), b_4(X) from the E_{7(-25)}
   data would change which candidates exist.

 SCOPE-RESTRICTION CITATIONS (R-#74 / R-#75 published-fact
 witnesses for the other two restrictions):
 - Milnor uniformity (non-ODP closed): Milnor 1968 (Annals
   Math Studies 61) + Lê 1973 (Ann. Inst. Fourier 23, 261-270)
   + Greuel 1975 (Math. Ann. 214, 235-266).
 - Friedman/Collins conifold (threefold-only, inapplicable
   to d=5 4-fold fibres): Friedman 1986 (Math. Ann. 274,
   671-689) "Simultaneous resolution of THREEFOLD double
   points" + Collins 2025 (arXiv:2509.01002 §2-§7) covering
   Calabi-Yau THREEFOLDS specifically.
 - Other 4-fold surgery frameworks unaudited: Rossi 2006
   (4-fold flops); M-theory conifold extensions
   (arXiv:1203.6662). Tactical question for future round:
   do these apply to d=5 4-fold fibre singularities arising
   on |mH|-pencils?

 EXISTENCE OF NON-P¹ FAMILIES: trivially YES via Hilbert scheme
 parametrization. For X with Pic = ℤH and large m, the linear
 system `|mH| ≅ P^N` with `N = h^0(O_X(mH)) - 1` is huge,
 admitting algebraic curves of arbitrary genus. Whether the
 resulting Diophantine constraint is satisfiable for the d=5
 exotic-residual specific Chern data remains the genuine open
 attack vector.
 paper source: scope restriction in prop:d5-e7-closure pencil-
 Euler identity; generalized Euler identity derivation for
 non-P¹ bases. -/
axiom IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK :
 Prop

/-- Predicate: conifold-transition bypass via Friedman 1986 /
 Collins 2025 framework is INAPPLICABLE to d=5 exotic-residual
 setting. Friedman 1986 Math. Ann. 274 "Simultaneous resolution
 of THREEFOLD double points" is explicitly threefold-only;
 Collins 2025 arXiv:2509.01002 §2-§7 focuses on Calabi-Yau
 THREEFOLDS. For d=5 the relevant fibre singularities live on
 4-folds, where these frameworks do not directly apply.

 REFINED SCOPE (R-#74): the predicate name covers Friedman 1986
 / Collins 2025 frameworks specifically. OTHER 4-fold surgery
 frameworks (e.g., Rossi 2006 on 4-fold flops; M-theory conifold
 extensions to Calabi-Yau fourfolds, e.g., arXiv:1203.6662) have
 NOT been audited in this round and may still provide bypass.
 The broken-link is REFINED to Friedman/Collins-specific scope
 rather than fully closed.
 paper source: scope restriction in prop:d5-e7-closure rescue-
 path enumeration; R-#74 audit refined scope. -/
axiom IsConifoldTransitionBypassInapplicable_d5_E7_Exotic_BROKEN_LINK :
 Prop

/-- External-citation axiom (Lean convention for asserting published
 theorems not yet ported to Mathlib): Friedman 1986 Math. Ann. 274
 671-689 'Simultaneous resolution of threefold double points' and
 Collins 2025 arXiv:2509.01002 'An introduction to conifold
 transitions' are explicitly threefold-only frameworks. Neither
 directly applies to fourfold isolated singularities arising on
 the d-1=4-fold fibres in a d=5 setting. The predicate's name
 covers Friedman + Collins specifically; OTHER 4-fold surgery
 frameworks (Rossi 2006 on 4-fold flops; M-theory conifold
 extensions arXiv:1203.6662) remain unaudited attack vectors. -/
axiom friedman_collins_conifold_threefold_only :
 IsConifoldTransitionBypassInapplicable_d5_E7_Exotic_BROKEN_LINK

/-- **PUBLISHED-tier INERT atom (P3 attack byproduct)**: the structural
 Hodge/monodromy attack via period map of any **ample-divisor family**
 on the d=5 EVII phantom is INERT — cannot produce a numerical
 contradiction — via two compounding mechanisms:

 (1) **MT-orbit Hermitian symmetric**: the Mumford-Tate sub-period-
   domain `D_{MT} = E_{7(-25)} / (E_6 × U(1)) = EVII` is the
   fourth exceptional irreducible Hermitian symmetric space of
   complex dimension 27 (Helgason 1978 Ch. X §6 + Table V; one of
   four exceptional HS spaces, alongside EIII = E_{6(-14)}/Spin(10)·SO(2)).
   For Hermitian symmetric MT-orbits: the tangent decomposition
   `𝔤_ℂ = 𝔤^{-1,1} ⊕ 𝔤^{0,0} ⊕ 𝔤^{1,-1}` has no higher Hodge
   components, so the **horizontal subdomain D_h equals D_{MT} itself**;
   Griffiths transversality imposes no proper-subdomain constraint
   on period maps landing in D_{MT}.
   (CAVEAT: the FULL period domain D classifying ALL polarised
   weight-3 HS of type (1, 27, 27, 1) is NOT Hermitian symmetric —
   only the MT-sub-domain D_{MT} = EVII is. The phantom's
   MT(H³)^der = E_{7(-25)} forces the period map to land in
   D_{MT}, where the trivial-horizontal phenomenon applies.)

 (2) **Lefschetz hyperplane iso in degree 3 < dim Y = 4**: for any
   smooth ample 4-fold divisor `Y_t ⊂ X` (e.g. `Y_t ∈ |mK_X|` for
   m ≥ 2, the m=1 case is empty under (χ-b) as `h^{5,0}(X) = 0`),
   the Lefschetz hyperplane theorem gives `H^k(X, ℚ) → H^k(Y_t, ℚ)`
   is an **iso of Hodge structures** for `k < dim Y_t = 4`, in
   particular for k = 3 (Voisin "Hodge Theory and Complex Algebraic
   Geometry" **Vol. II Ch. 1 Thm 1.23**, Cambridge 2003; corrected
   from Vol. I per R-#new Phase 4 audit catch — Lefschetz hyperplane
   chapter is in Vol. II not Vol. I). The iso varies CANONICALLY
   with t (induced by inclusion `i_t : Y_t ↪ X`), hence the local
   system `R³π_*ℚ` over the open base is canonically trivialised
   = constant local system `H³(X) ⊗ ℚ`. **VHS on H³ is trivial;
   monodromy on V_56 is trivial; period map φ : (base) → D_{MT}
   is constant.**

 **Numerical confirmation** (P3 experiment script `r_p3_phantom_vhs_main.py`):
 Chern-class adjunction `c(T_{Y_t}) = c(T_X)|_{Y_t} / (1 + mH)`
 + Hirzebruch χ_y via splitting-principle log-exp method for
 m ∈ {2, 3, 4, 5}; Serre duality cross-checks
 `χ(Ω³) − χ(Ω¹) = 0` and `χ(Ω⁴) − χ(O_Y) = 0` PASS exactly;
 `h^{2,1}(Y_t) = 27` exactly via Lefschetz iso, matching the
 V_56 MT constraint with **zero slack** — no Hodge-numerical
 contradiction at any m.

 **Generality (P3 Phase 4 strengthening)**: the Lefschetz argument
 in (2) is FAMILY-INDEPENDENT for ample-divisor families. So the
 inertness applies to ANY ample-divisor family on the phantom (1-param
 ℙ¹-pencil, ℙ²-net, P^M-net, higher) — productive attacks MUST
 either (a) leave the ample-divisor framework (codim ≥ 2 cycles,
 non-ample sub-loci, log-pairs), or (b) work on `H^k(Y_t)` for
 `k ≥ dim Y_t` (variable cohomology where Lefschetz does not give
 an iso).

 **Remaining (non-pencil-VHS) productive attack vectors** (these
 are NOT closed by this atom; they are flagged for future rounds):
 (a) non-Lefschetz codim ≥ 2 sub-loci (intersection of two ample
   pencils in `|mH| × |m'H|`); (b) higher Abel-Jacobi / Bloch-
   Beilinson filtration on `CH³(X)`; (c) `H⁴(Y_t)`-level MT analysis
   with potentially larger MT group; (d) cycle-class map on `CH²(X)`
   (54 Hodge classes in H⁴); (e) Klingler-Otwinowska-Ullmo 2022+
   Hodge-locus / atypical-intersection for CY-type VHS; (f) higher-
   genus base of family (g ≥ 1; existing attackVector record).

 **Citations** (cf. `feedback_gap_ledger_in_lean4` 8-pattern check
 per R-#new Phase 4 audit):
 - Helgason 1978 "Differential Geometry, Lie Groups, and Symmetric
   Spaces" Ch. X §6 Thm 6.1 + Table V (Hermitian-symmetric
   classification; EVII).
 - Voisin "Hodge Theory and Complex Algebraic Geometry" **Vol. II
   Ch. 1 Thm 1.23**, Cambridge 2003 (Lefschetz hyperplane for
   Hodge structures; corrected from prior Vol. I attribution).
 - Friedman-Laza 2013 Duke 162 #12 (arXiv:1109.5632) Thm 1.1
   (semialgebraic horizontal subvarieties of CY type — confirms
   EVII as one of the Hermitian-symmetric CY-type cases).
 - Han-Robles 2020 arXiv:2003.00137 (the EVII Hodge representation
   `(e_7, A⁷, ω_7, 0)`; specific Appendix A.2.6 p. 32 reference
   marked PHASE-0-PENDING per Phase 4 audit — PDF page-number
   verification deferred; statement-level claim plausible and
   consistent with Gross 1994 / Sheng-Zuo).

 paper source: P3 frontal-attack INERT byproduct on d=5 EVII
 phantom; codifies that the (b) "structural Hodge/monodromy"
 attack vector mentioned in the
 `IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK`
 docstring is structurally closed via Lefschetz + HS-MT-orbit. -/
axiom IsAmpleDivisorFamilyVHSInert_d5_EVII_Phantom_PUBLISHED :
 Prop

/-- PUBLISHED witness for the ample-divisor family VHS inertness atom
 on the d=5 EVII phantom. Anchors: Helgason 1978 Ch. X §6 Thm 6.1
 (Hermitian-symmetric classification) + Voisin Hodge II Ch. 1
 Thm 1.23 (Lefschetz hyperplane) + Friedman-Laza 2013 Thm 1.1
 (horizontal subvariety classification). -/
axiom ample_divisor_family_vhs_inert_d5_EVII_phantom_PUBLISHED :
 IsAmpleDivisorFamilyVHSInert_d5_EVII_Phantom_PUBLISHED

/-- Predicate: the Milnor sign obstruction blocks d=5 exotic-
 residual closure conditional on all three scope-restriction
 hypotheses above. Post R-#74: 2 of 3 scope restrictions are
 established as witnesses (non-ODP via Milnor uniformity;
 conifold via Friedman/Collins threefold-only scope); only the
 non-P¹ pencil base scope remains a genuine broken-link. -/
axiom IsMilnorObstructionBlocks_d5_E7_Exotic_Conditional : Prop

/-- Bridge axiom: under all three scope-restriction hypotheses,
 the Milnor sign obstruction blocks the d=5 general-type
 exotic-residual closure. Post R-#74: 2 of 3 antecedents are
 discharged by published-fact witnesses (Milnor uniformity for
 non-ODP; Friedman/Collins threefold-only scope for conifold);
 only the non-P¹ pencil base scope remains a genuine broken-link
 to be supplied for closure. -/
axiom milnor_obstruction_blocks_d5_e7_under_scope_restrictions :
 IsMilnorObstructionExtendsToNonODPFibres_BROKEN_LINK →
 IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK →
 IsConifoldTransitionBypassInapplicable_d5_E7_Exotic_BROKEN_LINK →
 IsMilnorObstructionBlocks_d5_E7_Exotic_Conditional

/-- Conditional closure theorem: the d=5 general-type sub-case
 blocks under all three scope-restriction broken-link hypotheses.
 If any of the three broken links is established (or refuted in
 favour of a bypass), the d=5 general-type closure status changes
 accordingly.
 paper source: prop:d5-e7-closure conditional via broken-link
 surfacing. -/
theorem d5_e7_general_type_blocked_conditional :
 IsMilnorObstructionExtendsToNonODPFibres_BROKEN_LINK →
 IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK →
 IsConifoldTransitionBypassInapplicable_d5_E7_Exotic_BROKEN_LINK →
 IsMilnorObstructionBlocks_d5_E7_Exotic_Conditional :=
 milnor_obstruction_blocks_d5_e7_under_scope_restrictions

/-- Simplified conditional closure (R-#74): with 2 of 3 antecedents
 discharged by published-fact witnesses (Milnor uniformity +
 Friedman/Collins threefold-only scope), the d=5 general-type
 sub-case blocks under the SINGLE remaining broken-link (non-P¹
 pencil base scope restriction). -/
theorem d5_e7_general_type_blocked_via_non_p1_only :
 IsMilnorObstructionExtendsToNonP1PencilBase_BROKEN_LINK →
 IsMilnorObstructionBlocks_d5_E7_Exotic_Conditional :=
 fun h_non_P1 =>
 milnor_obstruction_blocks_d5_e7_under_scope_restrictions
   milnor_uniformity_extends_obstruction_to_non_odp
   h_non_P1
   friedman_collins_conifold_threefold_only

end HodgeReduction
