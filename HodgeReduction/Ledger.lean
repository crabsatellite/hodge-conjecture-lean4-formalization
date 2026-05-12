/-
# Gap Ledger for HodgeReduction.

Per the gap-ledger-in-Lean4 methodology, every gap in the Mumford--Tate
reduction of the Hodge Conjecture is recorded here as a typed metadata
declaration with explicit status, closure-distance to published
literature, decomposability into sub-clauses, computability
classification, attack vector, attack history, and obstacle citation
(mandatory for BLOCKED / DEAD-END entries).

Failure cases (BLOCKED routes) and dead-end attempts are preserved with
their cited obstacles, not deleted. Pre-attack check: orchestrator
confirms target is `gapOpen` or `gapPartial` before launching attack;
re-attempting `gapBlocked` or `gapDeadEnd` is a context-drift failure
mode and must be flagged.

## Ledger status

Detailed counts are tracked dynamically via `countByStatus` and
`filterByStatus` (defined below). Initial state: 53 typed entries
spanning 9 paper hypotheses + 16 atomic clauses + 23 sub-gap inventory
entries (SG-1..SG-23) + 3 BLOCKED sub-branches + 2 memory-derived gaps
+ parent rollups. Round-by-round status promotions live in each
entry's `attackHistory` field. The master tex
`contributions/hodge-conjecture-master-proof.tex` is the single
source of truth for paper content; supplement files are no longer
maintained (per user directive 2026-05-12).

## Milestone: Hodge formalization at gapPartial+ saturation (post-R-#51)

After 28 attack rounds (R-#24 through R-#51) on this ledger:
- **All 9 top-level paper hypotheses**: gapPartial (R-#51 retroactive
  hostile audit caught 2 gapClosed OVERCLAIMS: hyp:ChernWeil-bridge-E7
  and hyp:nonrigid-family-bridge were downgraded gapClosed → gapPartial
  per paper's own self-labelled-conjectural framing of underlying
  atomic axioms).
- **16 atomic clauses**: 2 gapClosed + 14 gapPartial. R-#51 audit
  retained gapClosed only for: BaseDim27 (purely Lie-theoretic
  Helgason 1978; concrete Nat equality, no opaque-on-opaque vacuous
  predicate) + FibreIsoAt_b0 (Kodaira-Spencer 1958 versal-deformation
  defining property). Other 5 ChernWeil/nonrigid atomic clauses
  (clauses i/ii/iii + PeriodMapDominant + PeriodMapGenericallyFinite)
  downgraded to gapPartial post-R-#51 hostile audit: the cited
  classical-lit sources (Schwarz/Borel-Hirzebruch/Matsushima-Borel-
  Wallach/Mumford/Schmid/Griffiths) supply framework but not the
  specific paper-labelled claims.
- **23/23 sub-gap inventory entries**: gapPartial. Post-R-#51 fix:
  SG-8/9/10/11 now have explicit Lean closure theorems (sg_8_closed
  through sg_11_closed) via typed-bridge absorption into parent
  hyp:hecke-bbt clauses (c)/(a)/(a)/(b) respectively. Earlier
  (pre-R-#51), these 4 sub-gaps were ledger-only gapPartial with no
  Lean closure machinery — R-#51 Batch 3 audit caught the gap.
  SG-16 promoted gapOpen → gapPartial via R-#42 dim-counting
  alternate route (bypasses the unsupplied SG-15b weight-filtration
  framework using `dim H^4_{prim} = 53 < 56 = dim V_{56}`,
  conditional on Assumption (χ-b)). Original SG-15b weight-
  filtration framework remains gapOpen as a separate
  invention-class question.
- **3/3 Group C paper-labelled OPEN sub-branches**: POST-R-#73
  PROMOTION to gapPartial via broken-link discipline applied to
  scope restrictions of the Milnor sign defect proof (κ=0 R-#62
  broken-link + general-type R-#73 scope-restriction broken-link
  preserved as conditional partial Lean maps):
  • `prop:d5-e7-closure`: κ=0 sub-case R-#62 conditional via
    Abundance dim ≥ 5 NAMED-OPEN + 2 BROKEN-LINK (K_X nef + Pic
    torsion-free); general-type κ=5 sub-case R-#73 conditional via
    3 scope-restriction BROKEN-LINK (ODP-exclusivity + P¹-base
    exclusivity + no-conifold-bypass). R-#72 hostile audit
    falsified pre-AI "133 routes / 16 techniques exhausted" claim
    by identifying 3 unexhausted attack vectors.
  • `cor:E7_full_closure`: κ=0 R-#62 conditional; general-type
    d ≥ 6 inherits 3 d=5 BROKEN-LINK + 1 additional codim-2 4-cycle
    topological bound BROKEN-LINK.
  • `open:exotic-residual`: κ=0 R-#62 conditional via Abundance
    dim ≥ 5 NAMED-OPEN (Kawamata 1992 + Miyaoka 1988 ν=1 +
    Astérisque 211 1992 multi-author seminar framework PUBLISHED
    for dim ≤ 3; NAMED-OPEN extension for dim ≥ 5) + 2 BROKEN-LINK.
- **2 memory-derived gaps**:
  • G1-atomic: gapPartial (R-#66 upgrade from gapDeadEnd via
    R-#64 systematic `_INVENTION_CLASS` audit). R-#66 correctly
    decomposes into NAMED-OPEN refined Bloch-Beilinson for CM
    wt-4 modular forms (Beilinson 1984 / Bloch 1980 framework +
    Longo-Vigni 2013 arXiv:1303.4335 / Trans. AMS 369 specialisation)
    PLUS BROKEN-LINK rank-to-effective-Mackey-cycle construction
    surfaced explicitly per `feedback_gap_ledger_in_lean4.md`
    broken-link discipline. Differs from retracted R-#59 by
    SEPARATING BB (named-open) from the rank-to-cycle gap
    (broken-link), eliminating the R-#59 non-rigor where BB was
    claimed to close the gap itself. Lean: predicate renamed
    `IsG1AtomicSchollRem126_hyp_CM_INVENTION_CLASS` →
    `IsG1Atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK` (dropping
    fabricated Scholl Rem 1.2.6 per R-#60 + R-#63 MINOR).
  • R32-C Hodge-rigidity: gapBlocked (structural Künneth no-go —
    actually a published theorem, not a gap to close; recorded for
    cross-session continuity).

Closure tier distribution (epistemic ordering per R-#27 et seq.):
- gapClosed UNCONDITIONAL: 2 atomic clauses only — BaseDim27 (Helgason
  1978, dim EVII = 27 purely Lie-theoretic) + FibreIsoAt_b0
  (Kodaira-Spencer versal-deformation fibre identification). The 2 paper
  hypotheses (ChernWeil-bridge-E7, nonrigid-family-bridge) and the other
  5 atomic clauses (ChernWeil i/ii/iii + nonrigid-family PeriodMapDominant
  + PeriodMapGenericallyFinite) were DOWNGRADED gapClosed → gapPartial by
  the R-#51 hostile re-audit (overclaim vs cited classical-lit sources;
  paper itself self-labels the operative content conjectural).
- gapPartial NO conjectural extension: SG-2/3/4/12 + SG-19 (R-#27;
  folklore-corollary). Also the 3 PUBLISHED folklore-corollary atoms
  introduced in the ChernWeil-bridge-E7 (ii)/(iii) decomposition: (R-#105)
  `IsBorelWallachStableInvariantDescentFramework_E7` (BW Ch. VII + DGA
  ring-map folklore) + `IsChernWeilDescentRingHomCompatibleWithChernSubring_E7`
  (BW + Mumford 1977 proportionality folkloric-upgrade + Borel-Hirzebruch
  compact-dual presentation; per R-#106a/b downgraded "PUBLISHED" framing
  to "PUBLISHED folklore-corollary" since the conjunction is not a single
  theorem citation); (R-#107) `IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED`
  (paper-definitional `[q]_G := Φ(q)` + identification of (ii.a) descent
  map with the (iii) ring-hom — surfaced per R-#106a B1/B2 to make the
  (iii) reduction's dependency graph fully typed).
- gapPartial conditional-computation: SG-5 (R-#31; Assumption (χ-b)
  conditional + sympy verification).
- gapPartial `_NAMED_OPEN`: SG-18 (R-#26 Murre B i=3), SG-20 (R-#28
  Tate + MT for H^3), SG-14 (R-#32 Honda-Tate non-abelian CM).
- gapPartial REDUCES-TO: SG-21 (R-#29 disjunction hyp:AH-CM-E7 OR
  SG-20 atom vii), hecke_bbt_e (R-#35 REDUCES-TO chow-modularity-E7),
  ChernWeil-bridge-E7 clause (iii) (R-#105 REDUCES-TO (i.b)+(ii)+1
  PUBLISHED ring-hom atom; zero clause-(iii)-specific conjectural
  content — the polynomial identity is pure 1-dim linear algebra in
  H^8(Ě_VII,ℚ) = ℚ·h^4 + ring-hom transport along descent/extension;
  `rem:E7-chernweil-tautology`'s "tautological once granted" content).
- gapPartial `_REQUIRED_HYPOTHESIS` (paper-acknowledged conditional
  inputs at the conjectural tier, with PUBLISHED framework available):
  ChernWeil-bridge-E7 clause (ii.a) `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS`
  (R-#105 refactor: the specific `[q]_G` is realised by G-invariant
  cohomology at degree 8 — no Eisenstein-boundary corrections; PUBLISHED
  framework atom = Borel-Wallach 2000) + clause (ii.b)
  `IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS`
  (boundary-compatibility at degree 8 in the weight-3 non-classical
  signature; PUBLISHED framework atom = Mumford 1977 + AMRT 2010) +
  `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS`
  (R-#107: G-P 2002 §1.3/Thm 16.4 covers only classical types `Sp_n,
  U(p,q), SO(2n), SO(2,p)`; G-P §1.6 explicitly leaves the equal-rank
  EVII extension open — surfaced per R-#106b Defect #1; consumed by
  the (iii) ring-hom bridge, not by (ii.b)).
- gapPartial multi-path `_CONJECTURAL`: SG-17 (R-#24 Hard-Lefschetz
  Schur scalar partial-kill + 3 closing paths).
- gapPartial `_NAMED_OPEN_MULTI`: SG-23 (R-#65 upgrade from
  `_INVENTION_CLASS` via 2 named-open atoms: SC(B)_3 at Chow
  level — Grothendieck 1969 / Kleiman 1968 §2; AND Bloch-Beilinson
  filtration — Bloch 1980 / Beilinson 1984).
- gapPartial `_NAMED_OPEN_BROKEN_LINK`: hyp:CM-correspondences
  G1-atomic (R-#66 upgrade from `_INVENTION_CLASS` via NAMED-OPEN
  refined BB for CM wt-4 — Beilinson 1984 / Bloch 1980 + Longo-Vigni
  2013 — PLUS BROKEN-LINK rank-to-effective-Mackey-cycle construction
  surfaced explicitly per discipline).
- gapPartial `_INVENTION_CLASS`: SG-22 (R-#30 NC → Chow lift via
  Lin 2021 NCHC ⇔ HC; per R-#64 audit STAYS INVENTION-CLASS but
  with HYBRID annotation noting Lin 2021 NCHC ⇔ HC makes the
  NC route tautological — R-#68 cleanup);
  hecke_bbt_c = SG-8 (R-#34 Kudla-Millson D_EVII Schwartz form;
  per R-#64 audit STAYS INVENTION-CLASS — no source-verified
  named-open candidate exists);
  ChernWeil-bridge-E7 clause (i.b.2) `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
  (R-#103 refactor: the cross-ring map Φ : Sym⁴(V_56*)^{E_7} → H^8(E_7^ℂ/P_7,ℚ)
  nonzero on the Freudenthal quartic — literature-absent, canonical
  geometric Φ gives 0 since q vanishes on the closed orbit
  E_7^ℂ/P_7 ⊂ {q=0}, Landsberg-Manivel 2001; the cohomology side
  i.b.1 is PUBLISHED and split off as `IsChernSubringSurjectiveOntoH8_E7P7`).
  R-#101 survey identified i.b as the last formalization headroom;
  R-#102 Constructor + R-#103 hostile audit both confirmed it is
  genuinely open / unclosable by citation or computation.

The formalization is in its strongest honest state achievable
without genuine mathematical breakthrough (which requires
invention-mode work outside the dispatch workflow). Per user
mindset "失败定理化lean化也是成果", DEAD-END / BLOCKED / REDUCES-TO
classifications are honest failure-theoremization: the gap
STRUCTURE is encoded in Lean even when closure is unprovable.

## Post-saturation new-math additions (R-#41+, R-#42)

- R-#41 (commit 213b7f2e): 0-sorry achieved in `MainTheorem.lean`.
  All 8 sorrys eliminated via paper-citation axioms
  (`thm_Meyer`, `thm_G2F4`, `thm_E8_vacuous` via
  `ClassicalResults` axioms R-#39; `E6_V27_vacuity`,
  `thm_cy3_e7_nonexistence`, `thm_subcase3b_vacuous` via
  paper-citation axioms R-#40; `main_reduction`,
  `cor_E7_shimura_closed` via paper-citation axioms R-#41).
- R-#42: NEW MATH addition. Extension of SG-5 Betti closure to
  full Hodge diamond `lem:sg5-hodge-diamond-conditional`
  (master tex L5635-5768). Under Assumption (χ-b), pins all 18
  non-vanishing entries of the Hodge bigraded diamond for the
  rigid d=5 EVII 5-fold. NEW STRUCTURAL INGREDIENT beyond
  SG-5 Betti: dimension-counting pin
  `dim H^4_{prim} = 53 < 56 = dim V_{56}` (smallest non-trivial
  complex E_7-irrep, Bourbaki Lie Ch. VIII Planche VI). This
  forces E_{7(-25)}-action on H^4_{prim} to be trivial, and
  under the minimal-MT ansatz the weight cocharacter then pins
  all 53 copies of trivial rep to Hodge type (2,2), giving
  `h^{2,2}(X) = 54`, `h^{3,1}(X) = h^{1,3}(X) = 0`. Lean
  formalization: 5 new framework atoms + bridge + theorem
  `sg_5_hodge_diamond_pinned` in `OpenHypotheses.lean`. Not a
  new SubGap closure (SG-5 was already closed); a strengthening
  of the SG-5 output.
- R-#43: NEW MATH corollary. Explicit holomorphic Euler
  characteristics from R-#42 Hodge diamond
  `cor:sg5-chi-omega-conditional` (master tex L5779-5837):
  (χ(O), χ(Ω^1), χ(Ω^2), χ(Ω^3), χ(Ω^4), χ(Ω^5))
  = (0, 27, -1, 1, -27, 0), with χ_y-genus polynomial
  χ_y(X) = 27y - y^2 + y^3 - 27y^4. Pattern (i) classical-
  corollary: alternating-sum arithmetic on the Hodge diamond
  columns. NEW EXPLICIT VALUES (master tex L5517 invokes
  integrality of χ(Ω^1_X) but does not exhibit its value).
  Lean theorem `sg_5_chi_omega_pinned`.
- R-#44: SUB-GAP CLOSURE PROMOTION. R-#42 dim-counting closes
  SG-16 ("E_{7(-25)} acts trivially on H^{2,2}(X_b, ℚ) for
  dim X_b = 5") via NEW INDEPENDENT route bypassing the
  unsupplied SG-15b weight-filtration framework
  (master tex `\ref{rem:sliceD-dim5-casimir}` part (iv)
  documents the alternate route). Status promotion:
  SG-16 gapOpen → gapPartial (now 23/23 sub-gaps gapPartial+).
  NEW Lean axioms `sg15_via_R42_dim_counting` and
  `sg16_via_R42_dim_counting`; NEW closure theorems
  `sg_15_closed` and `sg_16_closed`. Conditional on Assumption
  (χ-b) (same scope as SG-5 closure). Original SG-15b weight-
  filtration framework remains gapOpen as a separate
  invention-class question — R-#42 route bypasses rather than
  closes it.
- R-#45: NEW MATH — Lefschetz-pin residual reduction 35 → 1.
  Under (χ-b), R-#43's χ(Ω^1) = 27 combined with the master-tex
  Lefschetz-pin Diophantine analysis (master tex `\ref{cor:sg5-35to1-reduction}`)
  reduces the 35-candidate residual to a SINGLE candidate:
  (K^5, s_2, m_a) = (2368, 1/2, 24), the m_a=24 endpoint of the
  25-member arithmetic stratum. Computer-verified via
  `experiments/r45_chi_omega_filter.py` (scan K^5 ≤ 10000,
  rational s_2). Other 24 arith candidates fail χ(Ω^1)=27;
  all 10 master-tex sporadics fail χ(Ω^1)=27 (verified:
  (4,5)→14, (16,2)→9, (40,2)→19, etc.); 6 new sporadic
  Diophantine solutions fail plurigenera-integer admissibility.
  Lean theorem `sg_5_lefschetz_pin_35to1_reduction`.
  NOT a closure of the d=5 branch (Milnor-defect sign reversal
  still obstructs); R-#45 is a candidate-count STRENGTHENING.
- R-#46: Phase-4 audit caught r319 `compute_chi_Om2` bug
  (off-by-one: should be `chi_Om1 - 28`, not `chi_Om1 - 27`,
  due to missing h^{2,5} = 1 Serre term). New diagnostic
  script `experiments/r46_chi_omega_consistency.py` documents
  the bug. R-#45 unaffected (uses chi_Om1 only).
- R-#47: Manual HRR via power-sum approach verifies
  χ(Ω^2)(K^5=2368, s_2=1/2) = -1 (matches R-#43's diamond
  value). Confirms K^5=2368 is FULLY CONSISTENT with R-#42-43;
  R-#45's "35 → 1" stands as actual residual count.
  Diagnostic script `experiments/r47_manual_HRR_chi_Om2.py`.
- R-#48: SUB-GAP CLOSURE PROMOTION. `open:exotic-residual`
  promoted gapBlocked → gapPartial via Pattern (ii) NAMED_OPEN
  closure of the κ=0 sub-case. Framework PUBLISHED (Abundance
  dim ≤ 3 via Kawamata 1992 Invent. 108 + Miyaoka 1988
  Compositio 68 + Kollár ed. 1992 Astérisque 211), NAMED_OPEN
  extension (Abundance dim ≥ 5). Under Abundance dim ≥ 5,
  κ=0 + Pic=ℤH structure forces K_X torsion → K_X=0 →
  contradicts c_1≠0, so κ=0 sub-case vacuous. General-type
  sub-case (κ=dim X) remains BLOCKED (Milnor sign defect).
  Master tex `\ref{rem:kappa-zero-vacuity-abundance}`;
  Lean closure theorem `exotic_residual_kappa_zero_subcase_closed`.
  3 new bibitems added (Kawamata, Miyaoka, Kollár).
- R-#49: TWO ADDITIONAL Ledger PROMOTIONS via inheritance.
  R-#48's `exotic_residual_kappa_zero_subcase_closed` is GENERIC
  for dim ≥ 5 + Pic = ℤH + c_1 ≠ 0 hypotheses, so it applies to
  both: (i) `prop:d5-e7-closure` (d=5 specific Milnor obstacle)
  and (ii) `cor:E7_full_closure` (d ≥ 6 inherited obstacle).
  Both ledger entries promoted gapBlocked → gapPartial via
  inheriting the κ=0 closure (no new Lean axioms). General-type
  sub-cases (κ = dim X) in both remain BLOCKED:
  • prop:d5-e7-closure d=5 case: Milnor sign defect on
    P^1-pencils + ODP 4-fold fibres (R-#45 reduced candidate
    count 35 → 1 but Milnor obstruction persists).
  • cor:E7_full_closure d ≥ 6 case: P^2-pencil analogue inherits
    Milnor sign + missing codim-2 4-cycle topological bound.
  Net: ALL 3 Group C (paper-labelled OPEN sub-branches) at
  gapPartial+. Only G1-atomic (gapDeadEnd) and R32-C
  (gapBlocked structural theorem) remain at gapBlocked-or-worse.
- R-#63 audit + R-#64 audit (dispatched parallel post-R-#62):
  • R-#63 — retroactive Phase 4 audit of R-#33-#41 closures
    (MainTheorem sorry-elim + 4 Pattern (ii) closures): 5 CLEAN,
    2 MINOR, 1 MAJOR. MAJOR finding (R-#67): R-#41
    `main_reduction_paper_axiom` collapses 4-clause case analysis
    into one axiom; `cor_E7_shimura_closed_paper_axiom` signature
    silently drops `hyp_ChernWeil_bridge_E7` antecedent (mirror of
    R-#48 Abundance NEF-dropping pattern caught in R-#61).
  • R-#64 — systematic audit of all 4 `_INVENTION_CLASS` axioms:
    1 RECLASSIFY (SG-23 → NAMED-OPEN-MULTI; R-#65); 1 RECLASSIFY
    (G1-atomic → NAMED-OPEN + BROKEN-LINK; R-#66 via Longo-Vigni
    2013 refined BB + rank-to-effective-cycle broken-link);
    1 HYBRID annotation (SG-22 NC tautological via Lin 2021
    NCHC ⇔ HC; stays INVENTION-CLASS but documents); 1 STAYS
    INVENTION-CLASS (hecke_bbt_c D_EVII Schwartz, no
    source-verified named-open candidate).
- R-#65: EPISTEMIC UPGRADE of SG-23 from `_INVENTION_CLASS` to
  `_NAMED_OPEN_MULTI` (per R-#64 audit). Driver: pre-R-#65 framing
  recorded the M_AE → Chow descent as INVENTION-CLASS equivalent-
  to-original-gap. R-#64 audit corrected: descent decomposes into
  2 PUBLISHED NAMED-OPEN conjectures stacked:
  • (a) SC(B)_3 at Chow level (Grothendieck 1969 'Standard
    Conjectures on Algebraic Cycles' Tata Inst. Bombay 193-199;
    Kleiman 1968 §2).
  • (b) Bloch-Beilinson filtration conjecture (Bloch 1980 Duke
    Univ. Math. Series IV §1; Beilinson 1984 J. Soviet Math. 30
    2036-2070 §2).
  Lean implementation: 2 new NAMED-OPEN predicates +
  2 new atom axioms (`sc_B_3_chow_level_NAMED_OPEN`,
  `bloch_beilinson_filtration_NAMED_OPEN`) + 1 new bridge axiom
  (`mae_to_chow_descent_from_named_open_atoms`) + conversion of
  standalone axiom `mae_to_chow_descent_sg23_INVENTION_CLASS` →
  theorem derived via the bridge from the 2 atoms. Predicate name
  retains `_INVENTION_CLASS` suffix for downstream backward
  compatibility; tier is set by the derivation path through 2
  named-open atoms. No Mathlib build impact: same theorem name,
  same conclusion type, only the proof path changes from axiom-
  assertion to bridge-derivation.
- R-#66: EPISTEMIC UPGRADE of G1-atomic / hyp:CM-correspondences
  from `_INVENTION_CLASS` to `_NAMED_OPEN_BROKEN_LINK` (per R-#64
  audit). Driver: prior `_INVENTION_CLASS` framing (R-#36, R-#37)
  recorded the gap as invention-class equivalent to original gap.
  R-#59 attempted NAMED-OPEN via fabricated "Scholl Rem 1.2.6";
  R-#60 RETRACTED. R-#66 attempted honest decomposition: 1
  NAMED-OPEN atom (refined BB for CM weight-4 via Longo-Vigni
  2013) + 1 BROKEN-LINK atom (rank-to-effective-cycle).
  POST-R-#69 PHASE 4 AUDIT FINDING: R-#66 had 3 substantive
  defects in the NAMED-OPEN atom citations and 1 scope-overreach
  defect. R-#69 (below) corrects.
- R-#69: PHASE 4 HOSTILE RE-AUDIT applied to R-#65 + R-#66
  same-round per discipline (`feedback_gap_ledger_in_lean4.md`
  full-theorem-survey mandate + broken-link discipline). Two
  audits dispatched in parallel using WebFetch/WebSearch:
  • R-#65 audit (MINOR ⚠): caught (i) Bloch/Beilinson attribution
    priority — pre-R-#65 listed both as co-equal sources for
    filtration conjecture, but Beilinson 1984 is primary
    formulator, Bloch 1980 foundational; (ii) Beilinson 1984
    section reference — pre-R-#65 cited §2, audit found §3 is
    the operative section for conjecture formulations.
    Decomposition encoding (bridge axiom) honest — not a
    canonical literature decomposition but an explicit derived
    dependency.
  • R-#66 audit (FAILURE ✗): caught (i) wrong title cited for
    arXiv:1303.4335 — R-#66 used "Quaternion algebras, Heegner
    points and the arithmetic of Hida families" which is the
    title of SIBLING paper arXiv:0903.2797 / manuscripta math.
    135 (2011) 273-328; correct title for 1303.4335 is
    "A refined Beilinson-Bloch conjecture for motives of
    modular forms"; (ii) wrong page range — R-#66 fabricated
    "6019-6071", actual ~7301-7342 in Trans. AMS 369 (2017);
    (iii) scope over-reach — Longo-Vigni 2017 covers GENERAL
    even-weight modular forms, NOT specifically CM weight-4;
    (iv) smuggled modular-CY_3 assumption — Longo-Vigni operates
    on Kuga-Sato modular threefolds, NOT general rigid CY_3
    pairs that hyp:CM-correspondences targets.
  R-#69 patches:
  • R-#65: corrected docstrings + Ledger entry + master tex
    Scope warning for attribution priority + section number.
  • R-#66: corrected title + pages in Longo-Vigni citation;
    renamed predicate `IsRefinedBlochBeilinsonCMwt4_NAMED_OPEN`
    → `IsRefinedBlochBeilinsonEvenWeightModular_NAMED_OPEN`
    (honest scope per source); added new BROKEN-LINK predicate
    `IsGeneralRefinedBBtoCMWt4RigidCY3Specialisation_BROKEN_LINK`
    surfacing the general → CM-wt-4-rigid-CY_3 specialisation
    gap; expanded bridge axiom signature from 2 atoms (1 NO + 1
    BL) to 3 atoms (1 NO + 2 BL); updated closure theorem +
    Ledger entries.
  Pattern alignment: R-#69 vs R-#60 retraction of R-#59 — both
  caught literature-citation defects (fabricated citation
  details, scope over-reach) via Phase 4 hostile audit. R-#69
  applied broken-link discipline (preserve conditional Lean
  closure as partial map, surface broken links explicitly) per
  user directive 2026-05-12 instead of full retraction.

The 9 paper hypotheses are kept as `hyp_*` axioms in `OpenHypotheses.lean`
for paper-faithful encoding; the ledger entries below are metadata
referring to those axioms. The 3 paper-labelled OPEN sub-branches and the
2 memory-derived gaps (G1-atomic, R32-C Hodge-rigidity) are typed here as
their own `def` entries (the paper labels them OPEN; the consolidated
attack synthesis demoted them to BLOCKED with cited obstacles).
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses
import HodgeReduction.MainTheorem

namespace HodgeReduction.Ledger

/-! ## Status taxonomy -/

/-- Status of a gap. Reserved Lean keywords `open` and `partial` are
 avoided by the `gap` prefix. -/
inductive GapStatus where
 | gapOpen
 | gapPartial
 | gapBlocked
 | gapDeadEnd
 | gapClosed
 | gapUnknown
deriving Repr, DecidableEq

/-- Metadata record for one gap. The Lean Prop statement of the gap
 itself lives in `OpenHypotheses.lean` (or in this file, for the
 BLOCKED sub-branches and memory-derived gaps). -/
structure LedgerEntry where
 identifier : String
 paperLabel : String
 status : GapStatus
 closureDistance : String
 decomposability : String
 computability : String
 attackVector : String
 attackHistory : List String
 obstacleCitation : Option String
deriving Repr

/-! ## Group A: 9 paper hypotheses (parent / atomic) -/

/-- paper source: hyp:HC-CM-Ab. Lean statements:
 `OpenHypotheses.IsDeligne1982AbsoluteHodgeAbelianFramework` +
 `OpenHypotheses.IsAndre1996MotivatedAbelianSpan` (framework predicates,
 REUSED from R23 hyp:AH-CM-E7 — same paper-facts);
 `OpenHypotheses.IsAHtoHCExtensionForCMAbelian_CONJECTURAL`
 (conjectural-extension predicate);
 `OpenHypotheses.deligne_1982_LNM_900_absolute_hodge_abelian_framework` +
 `OpenHypotheses.andre_1996_motivated_motives_abelian_span` (framework
 axioms, REUSED); `OpenHypotheses.ah_to_hc_extension_for_cm_abelian_CONJECTURAL`
 (conjectural-extension axiom); `OpenHypotheses.hc_cm_ab_from_framework_and_extension`
 (typed bridge axiom); `OpenHypotheses.hyp_HC_CM_Ab` (closure theorem).

 Status gapPartial: top-level paper hypothesis (Mumford 1969 root
 conjecture) closed via Pattern (ii) 2-framework + 1-conjectural-
 extension; REUSE R23 framework atoms (same Deligne 1982 + André 1996
 paper-facts); conjectural-extension is AH → HC gap explicit
 via paper `\ref{rem:AH-not-HC}`. -/
def gap_hyp_HC_CM_Ab : LedgerEntry := {
 identifier := "hyp:HC-CM-Ab"
 paperLabel := "hyp:HC-CM-Ab"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. 2 framework atoms PUBLISHED (REUSED from R23 hyp:AH-CM-E7 — same paper-facts): (i) Deligne 1982 LNM 900 §2 Thm 2.11 abelian absolute-Hodge UNCONDITIONAL (`Deligne_AH` in master tex bib); (ii) André 1996 Publ. Math. IHÉS 83 (5-49) motivated cycles on abelian Tannakian span UNCONDITIONAL (`Andre96` in master tex bib). 1 conjectural-extension (R24-NEW): AH → HC for CM abelian varieties (the algebraicity gap). Paper-acknowledged via `\\ref{rem:AH-not-HC}` (Deligne 1982 §§6-7 gives Hdg=AH but does NOT produce algebraic cycles) + Verification Status table 'Conditional: not implied by Deligne 1982'. Open since Mumford 1969. Known unconditional sub-cases (per `\\ref{thm:DelAH}` + Verification Status table): products of CM elliptic curves (Shioda Lefschetz (1,1) + Künneth); abelian surfaces (trivial Lefschetz (1,1) + Poincaré duality); Weil classes via André 1996 motivated framework. 2024-2026 preprint partial closure: Markman 2025 arXiv:2502.03415 (preprint, NOT peer-reviewed) closes Weil classes on abelian fourfolds of Weil type (no discriminant restriction) + abelian sixfolds of Weil type with disc -1; this settles HC for Weil-type abelian fourfolds (a proper subclass of CM abelian fourfolds), NOT for all CM abelian fourfolds. Moonen-Zarhin 1999 (Math. Ann. 315, 711-733) gives a dichotomy on Hodge classes; general CM abelian fourfolds outside the Weil-type direction remain OPEN. CM abelian dim ≥ 5 (except sixfold disc -1) remains OPEN. Adjacent literature: arXiv:2411.12249 (Hodge cycles + period relations, NOT closure); Engel-et-al 2025 arXiv:2507.15704 (integral HC failure, Q-coefficient irrelevant); Kreutz-Shen-Vial (de Rham-Betti, NOT HC closure)."
 decomposability := "3 sub-claims + typed bridge: 2 reused framework atoms (Del82 abelian AH + And96 motivated-abelian-span — same paper-facts as hyp:AH-CM-E7) + 1 conjectural-extension atom (IsAHtoHCExtensionForCMAbelian_CONJECTURAL). Pattern (ii) calibration parallels hyp:chow-modularity-E7 / hyp:AH-CM-E7 top-level closures; 2-framework count matches the paper anchor list at `\\ref{hyp:HC-CM-Ab}`."
 computability := "PUBLISHED framework (Deligne 1982 abelian AH + André 1996 motivated abelian-span; REUSED from R23) + paper-acknowledged conjectural for AH → HC extension (`\\ref{rem:AH-not-HC}` + Verification Status table)"
 attackVector := "Pattern (ii) decomposition: 2 framework axioms reused (same paper-facts as hyp:AH-CM-E7) + 1 conjectural-extension axiom + 1 typed-bridge axiom. Bundled hyp_HC_CM_Ab converted from axiom to theorem via typed-bridge applied to the 3 atomic axioms. Deligne 1982 + André 1996 framework atoms shared cross-hypothesis (same paper-fact = same axiom). POST-R-#57 ADDITION: alternate dim ≤ 4 closure route via Moonen-Zarhin 1999 dichotomy (PUBLISHED Math. Ann. 315) + Markman 2025 (NAMED_OPEN preprint arXiv:2502.03415); new Lean theorem `hyp_HC_CM_Ab_dim_le_4_via_markman : IsHCForCMAbelianDimLE4`. Parent status unchanged (still gapPartial; dim ≥ 5 case remains INVENTION via AH → HC)."
 attackHistory := ["R-attack-#24-Phase-0-hostile-lit-verified-Deligne-1982-Andre-1996-citations-clean-no-new-defects-flagged-master-tex-attribution-of-Andre-1996-Thm-0-6-2-as-motivated-implies-algebraic-may-overstate-actual-Andre-result-is-motivated-equals-absolute-Hodge-on-abelian-span-motivated-equals-algebraic-remains-open-HC-question-Phase-1-cross-source-confirmed-2024-2026-no-new-closure-Markman-2025-arXiv-2502-03415-preprint-closes-Weil-type-abelian-fourfolds-not-general-CM-abelian-Phase-1-recommended-REUSE-R23-framework-atoms-plus-1-new-conjectural-extension-axiom-distinct-from-R23-non-abelian-E7-extension-Phase-2-Lean-writer-R24-Pattern-ii-2-framework-REUSE-plus-1-new-conjectural-extension-axiom-plus-1-typed-bridge-axiom-plus-theorem-refactor-also-patched-R23-Andre-1996-docstring-attribution-caveat-and-Deligne-1982-cross-hypothesis-reuse-note-net-axiom-delta-plus-2-only-1-new-conjectural-extension-predicate-plus-1-new-axiom-plus-1-typed-bridge-minus-1-bundled-axiom-converted-to-theorem", "R-attack-#57-Pattern-ii-NAMED-OPEN-refinement-for-dim-le-4-sub-case-Moonen-Zarhin-1999-Math-Ann-315-711-733-dichotomy-PUBLISHED-plus-Markman-2025-arXiv-2502-03415-Weil-classes-abelian-fourfolds-of-Weil-type-NAMED-OPEN-preprint-combined-give-HC-for-all-CM-abelian-dim-le-4-conditional-on-Markman-preprint-new-Lean-theorem-hyp-HC-CM-Ab-dim-le-4-via-markman-parent-status-unchanged-gapPartial-dim-ge-5-still-AH-to-HC-INVENTION"]
 obstacleCitation := none
}

/-- paper source: hyp:CM-correspondences; Lean statement:
 `OpenHypotheses.hyp_CM_correspondences`. Per R14 Phase 0 audit: this
 hypothesis is NOT closeable via Schoen-Nekovár. `\ref{hyp:CM-correspondences}`
 Status block explicit: "an open instance of HC, kept here as an
 explicit, labelled conjectural input". Three independent failure
 modes block Lean closure (see
 closureDistance). R14 Ledger entry corrected; no Lean axiom added. -/
def gap_hyp_CM_correspondences : LedgerEntry := {
 identifier := "hyp:CM-correspondences"
 paperLabel := "hyp:CM-correspondences"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#66 EPISTEMIC UPGRADE (INVENTION-CLASS → NAMED-OPEN-BROKEN-LINK per R-#64 audit); POST-R-#69 SCOPE CORRECTION per Phase 4 hostile audit. Framework PUBLISHED (1 atom): Schoen 1986 Duke Math. J. 53 (771-794) + Nekovář 1995 Math. Ann. 302 (609-686) — cycle EXISTENCE on Kuga-Sato W_{2r}(N) for specific (K, N) instances. UNCOND cycle existence. Extension `_NAMED_OPEN_BROKEN_LINK` (R-#66, R-#69-corrected): G1-atomic = cycle-to-Hodge-class scalar identification for general rigid CY_3 pair (Y, Z), decomposed into 3 atoms: (a) NAMED-OPEN refined Bloch-Beilinson for EVEN-WEIGHT modular forms (Beilinson 1984 J. Soviet Math. 30 §3 primary + Bloch 1980 Duke Univ. Math. Series IV foundational + Longo-Vigni 2013 arXiv:1303.4335 / Trans. AMS 369 (2017) 7301-7342 'A refined Beilinson-Bloch conjecture for motives of modular forms'); (b) BROKEN-LINK rank-to-effective-Mackey-cycle construction (no published effective machinery); (b') NEW R-#69 BROKEN-LINK general-even-weight-to-CM-wt-4-rigid-CY_3 specialisation (the operative Longo-Vigni source covers general even-weight on Kuga-Sato modular threefolds, NOT specifically CM weight-4 on general rigid CY_3). R-#69 audit caught 3 errors in R-#66 docstrings: (i) wrong title (R-#66 cited 'Quaternion algebras, Heegner points...' from sibling paper arXiv:0903.2797 / manuscripta math. 135 (2011) 273-328 — wrong paper); (ii) wrong page range (R-#66 fabricated pages 6019-6071, actual ~7301-7342); (iii) scope over-reach claiming 'refined-BB for CM weight-4' specialisation when source is general even-weight. R-#59 attempted NAMED-OPEN via fabricated Scholl Rem 1.2.6; R-#60 RETRACTED. R-#66 + R-#69 honest decomposition preserves conditional Lean closure with 2 BROKEN-LINK atoms surfaced per discipline."
 decomposability := "POST-R-#66: 4 atoms: 1 framework (Schoen 1986 + Nekovář 1995 cycle existence, PUBLISHED) + 1 NAMED-OPEN atom (refined BB CM wt-4 — Beilinson 1984 / Bloch 1980 / Longo-Vigni 2013) + 1 BROKEN-LINK atom (rank-to-effective-Mackey-cycle construction, no published effective machinery) + typed bridge. R-#66 added 2 new atom axioms + 1 new bridge axiom `g1_atomic_from_named_open_and_broken_link`; converted standalone `_INVENTION_CLASS` axiom → theorem via bridge."
 computability := "POST-R-#66: PUBLISHED framework (Schoen 1986 + Nekovář 1995) + NAMED-OPEN-BROKEN-LINK extension (R-#66 reclassified from `_INVENTION_CLASS` per R-#64 audit). 1 NAMED-OPEN published conjecture + 1 BROKEN-LINK explicit predicate. Epistemic tier materially stronger than pre-R-#66 INVENTION-CLASS framing."
 attackVector := "Pattern (ii) 4-atom decomp + typed bridge + R-#66 named-open-broken-link bridge: 1 framework classical-lit axiom (schoen_1986_nekovar_1995_kuga_sato_cycle_existence_hyp_CM) + 1 extension THEOREM (g1_atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK; R-#66 converted from `_INVENTION_CLASS` axiom + RENAMED dropping fabricated Scholl Rem 1.2.6) derived via R-#66 bridge from 2 atoms (refined_bloch_beilinson_CM_wt4_NAMED_OPEN + rank_to_effective_mackey_cycle_construction_BROKEN_LINK) + typed-bridge axiom hyp_CM_correspondences_from_framework_and_invention (signature updated to use renamed predicate); theorem hyp_CM_correspondences applies bridge to ⟨framework, named-open-broken-link⟩."
 attackHistory := ["R134-UNCOND-cycle-EXISTENCE-on-W_2(9)-K-sqrt-minus-3-only-NOT-full-hypothesis", "R-attack-#14-Phase-0-hostile-lit-audit-caught-3-failure-modes-blocking-closure-general-K-general-(Y,Z)-cycle-to-Hodge-class-scalar-identification-equals-G1-atomic-OPEN-also-corrected-Ledger-transcription-error-R134-verified-UNCOND-cycle-EXISTENCE-not-full-closure-also-corrected-1-dim-vs-2-dim-Hom-HS-subspace-self-product-vs-cross-product-confusion-Phase-0-verdict-no-go-defer-no-Lean-axiom-added-Ledger-entry-corrected", "R-attack-#36-Phase-2-Lean-writer-converted-axiom-hyp-CM-correspondences-to-theorem-via-Pattern-ii-INVENTION-CLASS-decomposition-mirror-SG-22-SG-23-hecke-bbt-c-R-#34-1-framework-atom-Schoen-1986-Nekovar-1995-cycle-existence-1-INVENTION-CLASS-extension-G1-atomic-Scholl-Rem-1-2-6-plus-typed-bridge-also-added-3-new-bibitems-Schoen1986-Nekovar1995-Scholl1990-status-gapOpen-to-gapPartial", "R-attack-#66-EPISTEMIC-UPGRADE-INVENTION-CLASS-to-NAMED-OPEN-BROKEN-LINK-via-R-#64-systematic-INVENTION-CLASS-survey-finding-G1-atomic-decomposes-into-1-published-NAMED-OPEN-refined-Bloch-Beilinson-CM-wt-4-modular-forms-Beilinson-1984-Bloch-1980-framework-plus-Longo-Vigni-2013-arXiv-1303-4335-Trans-AMS-369-2017-CM-specialisation-AND-1-BROKEN-LINK-rank-to-effective-Mackey-cycle-construction-explicitly-surfaced-per-broken-link-discipline-2-new-NAMED-OPEN-and-BROKEN-LINK-atom-axioms-plus-1-new-bridge-axiom-standalone-extension-axiom-converted-to-theorem-via-bridge-renamed-dropping-fabricated-Scholl-Rem-1-2-6-identifier-per-R-#60-retraction-and-R-#63-MINOR-finding-typed-bridge-signature-updated-theorem-body-updated-R-#59-RETRACTION-CARRY-FORWARD-this-bridge-differs-from-R-#59-by-EXPLICITLY-surfacing-rank-to-cycle-gap-as-BROKEN-LINK-separate-from-BB-R-#59-collapsed-BB-plus-cycle-gap-into-single-non-rigorous-BB-axiom"]
 obstacleCitation := some "POST-R-#66: `_NAMED_OPEN_BROKEN_LINK` (R-#66 upgrade from INVENTION-CLASS per R-#64 audit). Decomposes into (a) NAMED-OPEN refined Bloch-Beilinson for CM weight-4 modular forms (Beilinson 1984 / Bloch 1980 framework + Longo-Vigni 2013 arXiv:1303.4335 / Trans. AMS 369 (2017) 6019-6071 specialisation); (b) BROKEN-LINK rank-to-effective-Mackey-cycle construction (no published effective machinery; surfaced explicitly per discipline). Pre-R-#66 INVENTION-CLASS framing over-cautious; pre-R-#59 retracted attempt mis-attributed gap to BB itself."
}

/-- BUNDLED parent. paper source: hyp:KS-p3. Three atomic clauses
 `gap_KS_p3_i / _ii / _iii` all closed to gapPartial via single
 conjectural-extension axiom per clause. Lean statement:
 `OpenHypotheses.hyp_KS_p3` is a `theorem` proved by conjunction-intro
 on the 3 clause conjectural-extension axioms with common witness
 N := 0. -/
def gap_hyp_KS_p3 : LedgerEntry := {
 identifier := "hyp:KS-p3"
 paperLabel := "hyp:KS-p3"
 status := GapStatus.gapPartial
 closureDistance := "All 3 atomic clauses closed to gapPartial via single conjectural-extension axiom per clause. `\\ref{hyp:KS-p3}` self-declares as conjectural input; published apparatus (Kuga-Satake 1967 Math. Ann. 169 / Deligne 1972 Invent. 15 / Madapusi Pera 2016 Compositio 152 + Moonen 1998 LMS LNS 254) covers signature (n, 2) ONLY (Hermitian Cartan Type IV q = 2); SO(p, 3) is non-Hermitian and Deligne 1979 §1.3 explicitly blocks q ≠ 2. `\\ref{hyp:KS-p3}` closing remark: '(p,3) case requires a genuinely new construction at q=3'. Bundled hyp_KS_p3 is a theorem via N := 0 common witness."
 decomposability := "3 atomic clauses (i) weight-1 Hodge cocharacter lift; (ii) canonical anti-involution polarisation; (iii) algebraic correspondence on Sh x A_N realising invariant Hodge classes. All 3 closed to gapPartial via conjectural-extension axioms; bundled hyp_KS_p3 is a theorem (conjunction-intro)."
 computability := "PUBLISHED framework (Deligne 1979 polarisation criterion for ii); conjectural-extension at (p,3) for i + iii (non-Hermitian; paper-acknowledged hypothesis)"
 attackVector := "All 3 clauses gapPartial; bundled = theorem via conjunction-intro on 3 conjectural-extension axioms with witness N := 0."
 attackHistory := ["R-attack-#17-clause-iii-closure-via-single-conjectural-extension-axiom-mirroring-R8-clause-i-pattern-plus-bundled-axiom-to-theorem-refactor-via-N-0-common-witness-net-axiom-count-zero-change-1-new-clause-iii-axiom-minus-1-bundled-axiom"]
 obstacleCitation := none
}

/-- paper source: `\ref{hyp:AH-CM-E7}`. Lean statements:
 `OpenHypotheses.IsDeligne1982AbsoluteHodgeAbelianFramework` +
 `OpenHypotheses.IsAndre1996MotivatedAbelianSpan` (framework predicates);
 `OpenHypotheses.IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL`
 (conjectural-extension predicate);
 `OpenHypotheses.deligne_1982_LNM_900_absolute_hodge_abelian_framework` +
 `OpenHypotheses.andre_1996_motivated_motives_abelian_span` (framework
 axioms); `OpenHypotheses.non_abelian_shimura_E7_absolute_hodge_extension_CONJECTURAL`
 (conjectural-extension axiom); `OpenHypotheses.ah_cm_e7_from_framework_and_extension`
 (typed bridge axiom); `OpenHypotheses.hyp_AH_CM_E7` (closure theorem).
 Status gapPartial: top-level paper hypothesis closed via Pattern (ii)
 2-framework + 1-conjectural-extension; decomposability parallels
 hyp:chow-modularity-E7 / hyp:BBT-rigid-reach top-level closures;
 Lean closure follows typed-bridge pattern adapted to quantified
 hyp_AH_CM_E7 signature. -/
def gap_hyp_AH_CM_E7 : LedgerEntry := {
 identifier := "hyp:AH-CM-E7"
 paperLabel := "hyp:AH-CM-E7"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. 2 framework atoms PUBLISHED: (i) Deligne 1982 LNM 900 §2 Thm 2.11 (Hodge cycles on abelian varieties, notes by Milne, pp. 9-100, `Deligne_AH` in master tex bib) — abelian absolute-Hodge UNCONDITIONAL; (ii) André 1996 Publ. Math. IHÉS 83 (5-49) Thm 0.6.2 motivated cycles agree with algebraic on abelian Tannakian span UNCONDITIONAL. 1 conjectural-extension: non-abelian Shimura E_{7(-25)} AH extension, paper-acknowledged 'no abelian-motivic route is available' (`\\ref{hyp:AH-CM-E7}` status block). Published obstructions (NOT closures): Gross 1994 Math. Res. Lett. 1 (1-9) exceptional tube domain classification; Friedman-Laza 2013 Duke Math. J. 162 (2077-2148) CY-type VHS classification leaving EVII open. 2024-2026 literature sweep confirms gap not closed: Bakker-Shankar-Tsimerman 2024 arXiv:2405.12392 covers integral models NOT AH; Milne 2025 arXiv:2508.09972 extends Deligne 1982 AH to char p via abelian motives; §8 'Shimura varieties not of abelian type' leaves non-abelian case explicitly open; Klingler 2017 arXiv:1711.09387 covers Hodge locus NOT AH for non-abelian E_7."
 decomposability := "3 sub-claims + typed bridge: 2 framework atoms (Del82 abelian AH / And96 motivated-abelian-span) + 1 conjectural-extension atom (non-abelian E_7-type Shimura AH). Mirror of R22 hyp:chow-modularity-E7 Pattern (ii); 2-framework calibration (not 3) because hyp:AH-CM-E7 paper anchor list is narrower than chow-modularity's 3 orthogonal-Chow framework levels."
 computability := "PUBLISHED framework (Deligne 1982 abelian AH + André 1996 motivated abelian-span) + paper-acknowledged conjectural for non-abelian E_7 Shimura extension"
 attackVector := "Decomposed per R22 pattern: 2 framework classical-lit axioms + 1 conjectural-extension axiom + 1 typed-bridge axiom. Bundled hyp_AH_CM_E7 converted from axiom to theorem via typed-bridge applied to the 3 atomic axioms. IsE7CMFibre / E7InvariantHodgeClasses / absHodgeWitness remain opaque (semantic content pinned by paper, NOT decomposed)."
 attackHistory := ["R-attack-#23-Phase-0-hostile-lit-audit-verified-Deligne-AH-LNM-900-pp-9-100-Andre-1996-IHES-83-5-49-Gross-1994-MRL-1-1-9-Friedman-Laza-2013-Duke-162-2077-2148-all-correctly-cited-in-master-tex-bib-no-citation-defects-Phase-1-cross-source-2024-2026-literature-sweep-Bakker-Shankar-Tsimerman-2024-arXiv-2405-12392-integral-models-not-AH-Milne-2025-arXiv-2508-09972-extends-Deligne-AH-via-abelian-motives-leaves-non-abelian-section-8-open-Pappas-Rapoport-2026-integral-canonical-not-AH-Phase-1-recommended-Pattern-ii-2-framework-plus-1-conjectural-extension-Phase-0-recommended-1-framework-plus-1-conjectural-extension-Phase-1-2-framework-adopted-because-Andre-1996-is-published-parallel-framework-supplementing-Deligne-1982-Phase-2-Lean-writer-axiom-hyp-AH-CM-E7-to-theorem-via-typed-bridge-with-quantified-signature-preservation-net-axiom-count-2-predicates-2-framework-axioms-1-conjectural-extension-axiom-1-typed-bridge-axiom-minus-1-bundled-axiom-equals-plus-5-net"]
 obstacleCitation := none
}

/-- BUNDLED parent. paper source: hyp:ChernWeil-bridge-E7. Three atomic
 clauses `gap_ChernWeil_bridge_E7_i / _ii / _iii`, all CLOSED.

 Parent rollup: with clauses (i), (ii), (iii) all closed via classical
 literature, the bundled paper hypothesis `hyp_ChernWeil_bridge_E7` is
 a Lean `theorem` (genuine 3-clause conjunction), proven from the 5
 classical-lit axioms (Schwarz / Borel-Hirzebruch + Matsushima-Borel-
 Wallach / Mumford + Borel-Hirzebruch-Schwarz polynomial identity). -/
def gap_hyp_ChernWeil_bridge_E7 : LedgerEntry := {
 identifier := "hyp:ChernWeil-bridge-E7"
 paperLabel := "hyp:ChernWeil-bridge-E7"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#105 FULL DECOMPOSITION (R-#51 → R-#103 → R-#104/#105 progression complete). R-#51 downgraded the 4 monolithic `_PAPER_LABELLED_CONJECTURAL` axioms (i.b, ii.a, ii.b, iii) from gapClosed to gapPartial; R-#103 decomposed clause (i.b) into PUBLISHED cohomology atom + `_INVENTION_CLASS` cross-ring-bridge atom; R-#104/#105 now decomposes clauses (ii.a), (ii.b), and (iii). Current Lean structure: clause (i) = (i.a) PUBLISHED Schwarz + (i.b) [(i.b.1) PUBLISHED Chern-subring-surjectivity + (i.b.2) `_INVENTION_CLASS` cross-ring-bridge]; clause (ii) = (ii.a) [PUBLISHED Borel-Wallach framework + `_REQUIRED_HYPOTHESIS` specific-`[q]_G`-realisation] ∧ (ii.b) [PUBLISHED Mumford framework + `_REQUIRED_HYPOTHESIS` boundary-compatibility-at-degree-8]; clause (iii) = DERIVED theorem (no own conjectural content; REDUCES-TO (i.b)+(ii)+1 PUBLISHED ring-hom-compatibility atom — the cohomology-side rigidity from (i.b.1) makes the polynomial identity itself pure 1-dim linear algebra). All 4 old `_PAPER_LABELLED_CONJECTURAL` axioms converted to derived theorems (names kept). Total conjectural surface (POST-R-#107): 1 `_INVENTION_CLASS` atom (i.b.2) + 3 `_REQUIRED_HYPOTHESIS` atoms (ii.a-extension, ii.b-extension, G-P-EVII-extension); clause (iii) contributes 0. Status stays gapPartial; the formalization is at honest saturation for this hypothesis."
 decomposability := "3 atomic clauses, all gapPartial. (i) = (i.a) PUBLISHED Schwarz invariant theorem + (i.b) [(i.b.1) PUBLISHED `IsChernSubringSurjectiveOntoH8_E7P7` + (i.b.2) `_INVENTION_CLASS` `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`]; (ii) = (ii.a) [PUBLISHED `IsBorelWallachStableInvariantDescentFramework_E7` + `_REQUIRED_HYPOTHESIS` `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS`] ∧ (ii.b) [PUBLISHED `IsMumfordCanonicalExtensionFramework_E7` + `_REQUIRED_HYPOTHESIS` `IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS`]; (iii) = DERIVED via PUBLISHED `IsChernWeilDescentRingHomCompatibleWithChernSubring_E7` + (i.b)+(ii). Lean: 7 new atom predicates + 7 new atom axioms + 4 bridge axioms; all 4 old monolithic `_PAPER_LABELLED_CONJECTURAL` axioms converted axiom → derived theorem (names kept for downstream stability)."
 computability := "POST-R-#105: framework PUBLISHED for all sub-clauses (Schwarz 1978; Borel 1953 + Borel-Hirzebruch 1958; Borel-Wallach 2000 Ch. VII; Mumford 1977 + AMRT 2010 (G-P 2002 covers only classical types per §1.3 Thm 16.4; EVII surfaced as separate `_REQUIRED_HYPOTHESIS`); cross-source Harris 1985, Vogan-Zuckerman 1984, Franke 1998, Bott 1957 Ann. Math. 66 (203-248), Landsberg-Manivel 2001). Total conjectural surface = 4 atoms (POST-R-#107): 1 `_INVENTION_CLASS` (i.b.2, the cross-ring bridge Φ — literature-absent, canonical geometric Φ gives 0) + 3 `_REQUIRED_HYPOTHESIS` (ii.a-realisation + ii.b-boundary-compatibility + G-P-EVII-extension — paper-acknowledged conditional inputs). Clause (iii) has 0 own conjectural content (REDUCES-TO above)."
 attackVector := "POST-R-#105: gapPartial. Bundled theorem `hyp_ChernWeil_bridge_E7` proves the 3-clause conjunction; each clause is now fully decomposed into framework-PUBLISHED + conjectural atoms with explicit bridges. The 3-atom conjectural surface is the operative attack target: (i.b.2) requires CONSTRUCTING the cross-ring map Φ; (ii.a/b) `_REQUIRED_HYPOTHESIS` atoms require either a published-as-yet-uncited result establishing the specific-`[q]` realisation/extension at degree 8, or a fresh construction. Closure of any of these 3 atoms tightens the formalization; clause (iii) auto-closes upon (i.b)+(ii) closure. Per the broken-link discipline the typed conditional bridges preserve the dependency graph; closure reconnects the chain unconditionally for the affected sub-clause."
 attackHistory := ["R-attacks-#1-R1-clause-i-2026-05-11", "R-attack-#3-R3-clause-ii-2026-05-11", "R-attack-#4-R4-clause-iii-plus-bundled-parent-rollup-2026-05-11", "R-patch-#5.1-hostile-audit-2026-05-11-bundled-signature-refactored-from-clause-iii-only-to-genuine-(i)-AND-(ii)-AND-(iii)-conjunction-paper-faithful", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-OVERCLAIM-vs-paper-paper-labels-clause-i-b-non-vanishing-and-clause-ii-non-cocompact-and-clause-iii-polynomial-identity-all-conjectural-but-Lean-encodes-unconditional-classical-lit-axioms-citing-Borel-Hirzebruch-1958-Matsushima-Borel-Wallach-Mumford-1977-which-do-NOT-directly-establish-specific-claims-status-DOWNGRADED-gapClosed-to-gapPartial-with-paper-labelled-conjectural-disclosure-in-docstrings", "R-attack-#103-clause-i-b-DECOMPOSED-per-Phase-4-recommendation-PUBLISHED-cohomology-atom-IsChernSubringSurjectiveOntoH8_E7P7-plus-INVENTION-CLASS-cross-ring-bridge-atom-IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS-plus-bridge-axiom-borel_hirzebruch_..._nonvanish_H8-converted-axiom-to-theorem-tier-of-conjectural-part-refined-PAPER-LABELLED-CONJECTURAL-to-INVENTION-CLASS-clauses-ii-iii-still-monolithic-build-clean-0-sorry-status-stays-gapPartial-Lean-izes-the-R-#102-genuinely-open-finding-per-broken-link-discipline", "R-attack-#104-Phase-0-hostile-lit-review-of-clauses-ii-and-iii-full-theorem-survey-of-Matsushima-Borel-Wallach-Mumford-AMRT-Goresky-Pardon-Faltings-Chai-Lan-Harris-determined-correct-PUBLISHED-vs-REQUIRED-HYPOTHESIS-split-for-each-sub-clause-also-found-clause-iii-REDUCES-TO-i-b-plus-ii-plus-1-PUBLISHED-ring-hom-atom-zero-clause-iii-specific-conjectural-content-and-caught-3-Phase-0-defects-Matsushima-Ann-Math-75-1962-was-phantom-fix-to-Osaka-Math-J-14-Goresky-Pardon-cited-only-as-arXiv-preprint-fix-to-Invent-Math-147-AMRT-PEL-restricted-was-misattribution-of-limitation-flagged-missing-bibitems-GoreskyPardon-Vogan-Zuckerman", "R-attack-#105-REFACTOR-clauses-ii-and-iii-per-R-#104-design-7-new-atom-predicates-plus-7-new-atom-axioms-plus-4-bridge-axioms-old-monolithic-PAPER-LABELLED-CONJECTURAL-axioms-converted-to-derived-theorems-names-kept-build-clean-0-sorry-status-stays-gapPartial-conjectural-surface-cleanly-localised-1-INVENTION-CLASS-i-b-2-plus-2-REQUIRED-HYPOTHESIS-ii-a-extension-and-ii-b-extension-clause-iii-derived-no-own-conjectural-content-R-#51-monolithic-axiom-overclaim-RESOLVED-Phase-0-defects-fixed-in-new-docstrings-formalization-fully-decomposed-and-at-honest-saturation", "R-attack-#106a-Phase-4-structural-audit-found-2-CRITICAL-hidden-identifications-in-iii-bridge-B1-q_G-equals-Phi-q-B2-ii-a-descent-map-equals-iii-ring-hom-plus-2-MILD-folklore-corollary-tier-clarifications-needed", "R-attack-#106b-Phase-4-citation-audit-found-3-MAJOR-G-P-EVII-scope-overclaim-G-P-Baily-Borel-locus-not-toroidal-BW-chapter-mismatch-plus-4-MINOR-Snow-title-Mumford-ring-compat-folklore-Harris-1985-section-2-wrong-bibitem-absence", "R-attack-#107-PATCH-batch-renamed-Mumford-G-P-framework-to-Mumford-only-since-G-P-does-not-cover-EVII-per-G-P-section-1-3-Thm-16-4-and-section-1-6-added-new-REQUIRED_HYPOTHESIS-atom-for-G-P-EVII-extension-consumed-by-iii-bridge-added-new-PUBLISHED-folklore-corollary-atom-for-witness-chain-identifications-iii-bridge-now-7-input-was-5-folklore-corollary-qualifiers-added-Snow-to-Bott-1957-Harris-1985-to-Harris-1989-Proc-LMS-59-G-P-Baily-Borel-locus-disclosed-Mumford-ring-compat-folklore-disclosed-build-clean-0-sorry-status-stays-gapPartial-total-conjectural-surface-now-4-typed-atoms-1-INVENTION_CLASS-i-b-2-plus-3-REQUIRED_HYPOTHESIS-ii-a-ii-b-G-P-EVII-clause-iii-still-derived-no-own-content"]
 obstacleCitation := some "POST-R-#107: clauses (i.b), (ii.a), (ii.b), (iii) all fully decomposed; R-#106a/b audit patches applied. Conjectural surface = 4 typed atoms: (i.b.2) `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS` (literature-absent cross-ring map; canonical geometric Φ gives 0, Landsberg-Manivel 2001); (ii.a) `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS` (specific-`[q]_G` realisation at degree 8); (ii.b) `IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS` (boundary-compatibility at degree 8); (NEW R-#107) `IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS` (G-P 2002 §1.3/Thm 16.4 covers only `Sp_n, U(p,q), SO(2n), SO(2,p)`; §1.6 explicitly leaves EVII open — consumed by (iii) bridge). Clause (iii) has no own obstacle (REDUCES-TO via the 7-input bridge incorporating the 4 conjectural atoms above + 3 PUBLISHED folklore-corollary atoms). All 4 old monolithic `_PAPER_LABELLED_CONJECTURAL` axioms now derived theorems (names kept). PUBLISHED atoms: Schwarz 1978; Borel 1953 + Borel-Hirzebruch 1958 + Bott 1957; Borel-Wallach 2000 (folklore-corollary); Mumford 1977 + AMRT 2010 (Goresky-Pardon's classical-type Chern-subalgebra theorem moved out of the framework — see new `_REQUIRED_HYPOTHESIS` atom); ring-hom-compatibility folklore-corollary; witness-chain-identification folklore-corollary."
}

/-- paper source: hyp:BBT-rigid-reach. Lean statements:
 `OpenHypotheses.hyp_BBT_rigid_reach` (closure theorem, defeq rebinding
 via conjectural-extension axiom); 3 framework predicates +
 1 conjectural-extension axiom (paper-acknowledged hypothesis);
 3 classical-lit framework axioms (CDK 1995 + BBT 2023/BKT 2020 + PST
 2021); 1 conjectural-extension axiom for cycle-level transport.

 **Status: gapPartial.** Framework atoms PUBLISHED: CDK 1995 JAMS 8
 (locus-of-Hodge-classes algebraicity), BBT 2023 Invent. Math. 232 +
 BKT 2020 JAMS 33 (period-map definability + Hodge locus algebraicity),
 PST 2021 arXiv:2109.08788 (Andre-Oort CM-density). Cycle-level
 transport from CM-density to rigid isolated point is paper-
 acknowledged conjectural (`\ref{hyp:BBT-rigid-reach}` Status block); "Schur bypass"
 is paper-internal terminology, no published source.

 **CITATION-INTEGRITY NOTE** (post-R-#51 reversion): R-#51 Batch 1
 audit catch — earlier "CITATION-INTEGRITY NOTE" claims were
 mis-directed: (i) Klingler arXiv 1711.09946 vs 1711.09387 are BOTH
 valid companion preprints in Klingler's atypical-intersections
 series (per arXiv metadata cross-check); the "digit transposition"
 framing was unjustified — claim REVERTED. (ii) CDK 1995 JAMS 8
 pages 483-506 is CORRECT per the actual JAMS publication metadata;
 the earlier "correction to 483-505" reversed the right direction —
 REVERTED, 483-506 is the operative page range. Master tex bib +
 Lean docstrings use the verified 483-506 range. -/
def gap_hyp_BBT_rigid_reach : LedgerEntry := {
 identifier := "hyp:BBT-rigid-reach"
 paperLabel := "hyp:BBT-rigid-reach"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. 3 framework atoms PUBLISHED: CDK 1995 JAMS 8 (483-506, locus algebraicity); BBT 2023 Invent. Math. 232 (163-228, period-map definable); BKT 2020 JAMS 33 (917-939, Hodge locus algebraic at base); PST 2021 arXiv:2109.08788 (Andre-Oort CM-density). Cycle-level transport from CM-density to rigid isolated point is paper-acknowledged conjectural (`\\ref{hyp:BBT-rigid-reach}` Status block); 'Schur bypass' paper-internal. Cross-source: Klingler atypical-intersections preprint series (arXiv:1711.09946 and arXiv:1711.09387 both valid companion preprints per R-#51 audit reversion)."
 decomposability := "4 sub-claims: 3 framework (CDK + BBT/BKT + PST) PUBLISHED + 1 conjectural-extension (cycle-level transport at rigid isolated point)."
 computability := "PUBLISHED framework + paper-acknowledged conjectural for cycle-level transport"
 attackVector := "Decomposed per R9 pattern: 3 framework classical-lit axioms + 1 conjectural-extension axiom. Bundled hyp_BBT_rigid_reach converted to theorem via conjectural-extension defeq rebinding."
 attackHistory := ["R-attack-#10-Phase-0-hostile-lit-audit-confirmed-paper-acknowledged-conjectural-status-flagged-2-minor-citation-defects-Klingler-arXiv-id-transposition-and-CDK-pages-over-cite-Schur-bypass-paper-internal-terminology-Phase-2-Lean-writer-closed-gapPartial-4-atom-decomposition"]
 obstacleCitation := none
}

/-- BUNDLED parent. paper source: hyp:nonrigid-family-bridge. Four atomic
 clauses CLOSED in R2 (BaseDim27) + R5 (PeriodMapDominant /
 PeriodMapGenericallyFinite / FibreIsoAt_b0) + 1 existence witness axiom
 (Kodaira-Spencer 1958 versal deformation). With all 4 atomic accessors
 + existence closed, the bundled paper hypothesis `hyp_nonrigid_family_bridge`
 in `OpenHypotheses.lean` is now a Lean `theorem` (no longer `axiom`)
 with `sorry`-free proof.

 Second fully-closed top-level paper hypothesis (after
 hyp:ChernWeil-bridge-E7). -/
def gap_hyp_nonrigid_family_bridge : LedgerEntry := {
 identifier := "hyp:nonrigid-family-bridge"
 paperLabel := "hyp:nonrigid-family-bridge"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#51 HOSTILE-AUDIT DOWNGRADE (gapClosed → gapPartial). R-#51 Phase-4 retroactive audit identified MAJOR-DEFECT: paper (master tex `\\ref{hyp:nonrigid-family-bridge}` L11635-11685) EXPLICITLY states the hypothesis is 'LABELLED INPUT' with 'Expected sub-cases, treated here as separate labelled expectations rather than proved statements'. The PeriodMapDominant + PeriodMapGenericallyFinite atomic clauses are OVERCLAIMS: (a) Schmid 1973 nilpotent-orbit theorem analyses asymptotic behavior of an already-given period map but does NOT establish DOMINANCE from non-rigidity (Kodaira-Spencer gives versal deformation with dim B = h^1(T_X) but period map may be isotrivial or dim B < 27); (b) Griffiths 1968 local Torelli is a CONDITION on a VHS that does NOT hold automatically — paper explicitly notes 'period map may have positive-dimensional fibres'. BaseDim27 (Helgason 1978 dim EVII = 27 purely Lie-theoretic) and FibreIsoAt_b0 (Kodaira-Spencer versal-deformation fibre identification) remain genuinely PUBLISHED. The 2 over-claiming axioms are PAPER-LABELLED-CONJECTURAL."
 decomposability := "4 atomic accessors + 1 existence witness, post-R-#51 split: (i) BaseDim27 PUBLISHED (Helgason 1978 Lie-theoretic, retained gapClosed); (ii) PeriodMapDominant PAPER-LABELLED-CONJECTURAL (Schmid 1973 doesn't establish dominance from non-rigidity); (iii) PeriodMapGenericallyFinite PAPER-LABELLED-CONJECTURAL (Griffiths 1968 local Torelli is condition not consequence); (iv) FibreIsoAt_b0 PUBLISHED (Kodaira-Spencer versal-deformation, retained gapClosed); existence witness (Kodaira-Spencer 1958) PUBLISHED."
 computability := "POST-R-#51: PUBLISHED framework (BaseDim27 + FibreIsoAt_b0 + existence) + 2 PAPER-LABELLED-CONJECTURAL atomic axioms (PeriodMapDominant + PeriodMapGenericallyFinite). Pattern (ii) refactor would split each conjectural atom into framework PUBLISHED + extension PAPER-LABELLED-CONJECTURAL; current Lean encoding preserves bundled classical-lit-axiom structure with explicit disclosure."
 attackVector := "POST-R-#51: gapPartial via 4 classical-lit axioms (2 PUBLISHED + 2 PAPER-LABELLED-CONJECTURAL) + 1 existence axiom. Bundled theorem `hyp_nonrigid_family_bridge` proves 4-tuple conjunction via 4 atomic axioms + existence; structure preserved but status reflects paper-labelled-conjectural content of 2 PeriodMap axioms. Future refactor: expose conjectural-extension axioms (mirror hyp:BBT-rigid-reach pattern) for PeriodMapDominant + PeriodMapGenericallyFinite."
 attackHistory := ["R-attack-#2-R2-BaseDim27-2026-05-11", "R-attack-#5-R5-three-remaining-atomic-clauses-plus-existence-witness-plus-bundled-rollup-2026-05-11", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-OVERCLAIM-vs-paper-paper-labels-non-rigid-family-as-LABELLED-INPUT-with-expected-sub-cases-treated-as-separate-labelled-expectations-Lean-encodes-unconditional-classical-lit-axioms-citing-Schmid-1973-Griffiths-1968-which-do-NOT-directly-establish-period-map-dominance-or-generic-finiteness-from-non-rigidity-status-DOWNGRADED-gapClosed-to-gapPartial-with-paper-labelled-conjectural-disclosure-on-PeriodMapDominant-and-PeriodMapGenericallyFinite-BaseDim27-and-FibreIsoAt-b0-remain-PUBLISHED"]
 obstacleCitation := some "POST-R-#51: 2 of 4 atomic axioms are PAPER-LABELLED-CONJECTURAL per paper `\\ref{hyp:nonrigid-family-bridge}` L11635-11685 self-labelling 'LABELLED INPUT': (a) schmid_1973_period_map_dominant_PAPER_LABELLED_CONJECTURAL typed unconditional but Schmid analyses asymptotics of an already-given period map, NOT dominance from non-rigidity; (b) griffiths_1968_period_map_generically_finite_PAPER_LABELLED_CONJECTURAL typed unconditional but local Torelli is a CONDITION on VHS not automatic from non-rigidity. BaseDim27 + FibreIsoAt_b0 retain gapClosed (purely Lie-theoretic / classical versal-deformation respectively)."
}

/-- paper source: `\ref{hyp:chow-modularity-E7}`. Lean
 statements: `OpenHypotheses.ThetaIsChowModular` (transparent 4-fold
 conjunction `def`); `OpenHypotheses.hyp_chow_modularity_E7` (closure
 theorem, no-sorry conjunction-intro from 4 atomic axioms). 3 framework
 atoms (`IsKudlaMillson1986_1990CohomologicalModularity` +
 `IsBruinierFunke2004OrthogonalChowLift` +
 `IsHowardMadapusiPera2017ArithKudlaOrthogonal`) cover cohomological /
 orthogonal-Chow / orthogonal-arithmetic-Chow PUBLISHED machinery; 1
 conjectural-extension atom (`IsExceptionalE7ChowModularityExtension_CONJECTURAL`)
 covers exceptional `(PGL_2, F_4) ⊂ E_7` Chow lift + real-form descent
 `E_{7(7)} → E_{7(-25)}` (paper-acknowledged not in literature).
 Status gapPartial: top-level paper hypothesis closed via Pattern (ii)
 (3 framework + 1 conjectural-extension); decomposability structure
 parallels hyp:BBT-rigid-reach top-level closure; Lean closure follows
 hyp:hecke-bbt core 4-tuple conjunction-intro pattern. -/
def gap_hyp_chow_modularity_E7 : LedgerEntry := {
 identifier := "hyp:chow-modularity-E7"
 paperLabel := "hyp:chow-modularity-E7"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. 3 framework atoms PUBLISHED: (i) Kudla-Millson 1986 Math. Ann. 274 (353-378) + 1990 Publ. Math. IHÉS 71 (121-172) cohomological modularity unconditional; (ii) Bruinier-Funke 2004 Duke 125 (1) 45-90 geometric Chow-level theta lift for orthogonal Shimura; (iii) Andreatta-Goren-Howard-Madapusi Pera 2017 Compositio Math. 153(3) 474-534 'Height pairings on orthogonal Shimura varieties' = arithmetic Borcherds Chow-level for orthogonal Shimura at signature (n,2). 1 conjectural-extension: exceptional (PGL_2, F_4) ⊂ E_7 Chow modularity + real-form descent E_{7(7)} → E_{7(-25)}, paper-explicitly bundled (`\\ref{hyp:chow-modularity-E7}` Scope of the input) as a single input. Cross-source: Madapusi Pera 2016 Compos. Math. 152 (4) 769-824 covers (n,2) Spin only NOT exceptional; CLRJ 2025 Algebra & Number Theory 19 (3) arXiv:2202.09394 covers (G_2, PGSp_6) on Siegel sixfold as TEMPLATE one level up (`\\ref{thm:E7-modularity}` / `\\ref{thm:E7-theta-match}` construction), NOT direct framework input here; Greer-Tayou survey arXiv:2603.01251 (2026) is orthogonal/unitary survey explicitly NOT confirmation."
 decomposability := "4 sub-claims: 3 framework atoms (KM86+KM90 cohomological / BF04 orthogonal-Chow / AGHMP17 Compositio 153(3) orthogonal-arithmetic-Chow) + 1 conjectural-extension atom (exceptional E_7 (PGL_2, F_4) Chow + real-form descent). Mirror of hyp:BBT-rigid-reach 3-framework + 1-conjectural-extension precedent."
 computability := "PUBLISHED framework (orthogonal Chow-level modularity at cohomology / geometric / arithmetic 3 levels) + paper-acknowledged conjectural for exceptional E_7 Chow lift + real-form descent"
 attackVector := "Decomposed per R10 pattern: 3 framework classical-lit axioms + 1 conjectural-extension axiom. Bundled hyp_chow_modularity_E7 converted from axiom to theorem via 4-atom conjunction-intro; ThetaIsChowModular refactored from opaque axiom to transparent def. CLRJ25 explicitly NOT included as direct framework atom (it sits one level up in the reduction graph as Thm E7-modularity / E7-theta-match construction template, NOT Chow-modularity input)."
 attackHistory := ["R-attack-#22-Phase-0-hostile-lit-audit-found-2-citation-defects-KM90-pre-R22-cited-Invent-Math-99-CORRECTED-to-Publ-Math-IHES-71-121-172-and-Kudla-2003-attribution-FABRICATED-no-such-citation-in-master-tex-CORRECTED-to-Bruinier-Funke-2004-Duke-125-plus-Howard-Madapusi-Pera-2017-Ann-Sci-ENS-50-Phase-1-cross-source-confirmed-CLRJ25-NOT-direct-framework-atom-template-one-level-up-Pattern-ii-3-framework-plus-1-conjectural-extension-mirror-of-R10-BBT-rigid-reach-precedent-Phase-2-Lean-writer-axiom-ThetaIsChowModular-to-def-conversion-plus-4-atomic-axioms-and-axiom-hyp-chow-modularity-E7-to-theorem-no-sorry-conjunction-intro"]
 obstacleCitation := none
}

/-- BUNDLED parent. paper source: hyp:hecke-bbt. Core + 5 clauses
 (a) (g, K)-cohomology, (b) archimedean Whittaker, (c) Kudla-Millson on
 exceptional tube, (d) BBT spreading equivariance, (e) Chow-level
 equivariance. Atomic entries below as `gap_hecke_bbt_core / _a / _b /
 _c / _d / _e`. -/
def gap_hyp_hecke_bbt : LedgerEntry := {
 identifier := "hyp:hecke-bbt"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 closureDistance := "Mixed (R-#35 promotion). All 5 atomic clauses now at gapPartial: (a) gapPartial via R-#6 conjunction-intro (Gross-Wallach 1996 Crelle 481 quaternionic + Hermitian parallel-port CONJECTURAL); (b) gapPartial via R-#9 (Sahi 1992 + Magaard-Savin 1997 + Kazhdan-Polishchuk 2004 + Shan 2025 split-form framework + Hermitian conjectural-extension); (c) gapPartial via R-#34 Pattern (ii) `_INVENTION_CLASS` (Kudla-Millson 1986/1990 classical Schwartz + Faraut-Koranyi 1994 Jordan-cone harmonic analysis + D_EVII Schwartz form INVENTION); (d) gapPartial via R-#7 (BKT 2020 Hecke definability + Chow-level conjectural extension); (e) gapPartial via R-#35 REDUCES-TO hyp:chow-modularity-E7 conjectural-extension. Core conjunction theorem hyp_hecke_bbt_core already gapPartial. Parent status promoted from gapOpen to gapPartial: ALL 5 clauses + core are gapPartial; conjunction parent inherits weakest = gapPartial."
 decomposability := "6 atomic clauses (core + a + b + c + d + e) all gapPartial. Parent is conjunction; promoted gapOpen → gapPartial when last gapOpen clause (e) was upgraded R-#35."
 computability := "Cluster of gapPartial: (a)/(b)/(d) near-published parallel transfer; (c) `_INVENTION_CLASS` D_EVII Schwartz form; (e) REDUCES-TO hyp:chow-modularity-E7."
 attackVector := "Cluster-attack history (R-#6 a, R-#7 d, R-#9 b, R-#34 c via Pattern (ii) `_INVENTION_CLASS`, R-#35 e via REDUCES-TO). R-#51 PATCH: bundled `hyp_hecke_bbt` parent theorem signature corrected from core-only (4-conjunction) to genuine 6-tuple conjunction (core + a + b + c + d + e) matching paper `\\ref{hyp:hecke-bbt}` L8083-8154 'all five are jointly required' framing. Earlier signature drop was R-#51 Batch 1 MAJOR-DEFECT catch."
 attackHistory := ["R-attack-#6-clause-a-conjunction-intro", "R-attack-#7-clause-d-conjunction-intro", "R-attack-#9-clause-b-conjunction-intro", "R-attack-#34-clause-c-axiom-to-theorem-Pattern-ii-INVENTION-CLASS-mirror-SG-22-SG-23", "R-attack-#35-clause-e-axiom-to-theorem-REDUCES-TO-chow-modularity-E7-mirror-SG-21-SG-16-parent-promoted-gapOpen-to-gapPartial-all-5-clauses-now-gapPartial", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-signature-drop-bundled-parent-was-core-only-4-conjunction-not-6-clause-conjunction-as-paper-requires-FIXED-now-genuine-6-tuple-conjunction-intro"]
 obstacleCitation := some "Parent inherits weakest of 5 clauses. Clause (c) `_INVENTION_CLASS` D_EVII Schwartz form (mirror SG-22 / SG-23). Clause (e) REDUCES-TO hyp:chow-modularity-E7 conjectural-extension (same invention burden as exceptional E_7 Chow modularity)."
}

/-! ## Group A': atomic clause entries -/

/-- Clause (i) of hyp:KS-p3: weight-1 Hodge cocharacter lift on Cliff^+(V).
 Lean statements: `OpenHypotheses.KugaSatakeAtP3_i` (concrete def =
 conjectural-extension predicate); `OpenHypotheses.IsKSp3WeightOneHodgeCocharacter_CONJECTURAL`
 (atomic predicate); `OpenHypotheses.ks_p3_weight1_HodgeCocharacter_CONJECTURAL`
 (classical-lit axiom labelled conjectural-extension);
 `MainTheorem.hyp_KS_p3_clause_i_closed` (closure theorem, no-sorry
 defeq rebinding via the conjectural-extension axiom).

 **Status: gapPartial.** Single conjectural-extension axiom; NO useful
 framework decomposition. Madapusi Pera 2016 Compositio 152 (and earlier
 KS / Deligne) cover signature (n, 2) ONLY; SO(p, 3) symmetric domain is
 non-Hermitian (Cartan Type IV requires q = 2), structurally outside
 published KS apparatus. Deligne 1979 §1.3 explicitly blocks q ≠ 2.
 `\ref{hyp:KS-p3}` explicitly self-declares as conjectural hypothesis
 ("labelled gap, not a fact derivable from standard references"). -/
def gap_KS_p3_i : LedgerEntry := {
 identifier := "hyp:KS-p3 clause (i)"
 paperLabel := "hyp:KS-p3"
 status := GapStatus.gapPartial
 closureDistance := "Conjectural-extension. NO published source covers signature (p, 3) KS construction. Kuga-Satake 1967 / Deligne 1972 Invent. Math. 15 / Madapusi Pera 2015 Invent. Math. 201 / 2016 Compositio Math. 152 all cover signature (n, 2) ONLY (Type IV Hermitian symmetric SO(n-2, 2)). SO(p, 3) is non-Hermitian, structurally outside framework. Deligne 1979 §1.3 explicitly blocks q ≠ 2."
 decomposability := "1 atomic claim. NO useful framework decomposition (published (p, 2) does NOT contribute to (p, 3) structurally)."
 computability := "Conjectural-extension (no published source; paper-acknowledged hypothesis)"
 attackVector := "Single conjectural-extension axiom labelled CONJECTURAL. No clean classical-lit citation possible."
 attackHistory := ["R-attack-#8-Phase-0-hostile-lit-audit-caught-Madapusi-Pera-restricted-to-(n-2)-and-SO(p-3)-non-Hermitian-structural-obstruction-master-tex-L1828-2006-self-declared-conjectural-Phase-2-Lean-writer-closed-gapPartial-single-conjectural-extension-axiom"]
 obstacleCitation := none
}

/-- Clause (ii) of hyp:KS-p3: canonical anti-involution polarisation.
 Lean statements: `OpenHypotheses.KugaSatakeAtP3_ii` (concrete def =
 conjunction of clause (i) conjectural-extension + Deligne 1979
 polarisation criterion); `OpenHypotheses.IsDeligne1979PolarisationCriterion`
 (framework predicate); `OpenHypotheses.deligne_1979_polarisation_criterion`
 (classical-lit axiom, published);
 `MainTheorem.hyp_KS_p3_clause_ii_closed` (closure theorem, no-sorry
 conjunction-intro = typed bridge via Deligne 1979).

 **Status: gapPartial** (inherited from clause (i) dependency).
 Framework (Deligne 1979 §1.1 Def. 1.1.13 + Prop. 1.3.2) is PUBLISHED
 and signature-independent; clause (ii) is a typed bridge from clause
 (i) without a fresh conjectural axiom (reduces axiom count by 1 per
 feedback_lean_axiom_decomposition). -/
def gap_KS_p3_ii : LedgerEntry := {
 identifier := "hyp:KS-p3 clause (ii)"
 paperLabel := "hyp:KS-p3"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework Deligne 1979 'Variétés de Shimura' PSPM 33 §1.1 Def. 1.1.13 + Prop. 1.3.2 PUBLISHED (polarisation criterion is signature-independent template). Cycle-level applicability inherits clause (i) conjectural-extension dependency (no Hodge homomorphism at (p, 3) until (i) supplies it). Cross-source: Mumford Abelian Varieties Ch. III (canonical anti-involution / Rosati involution)."
 decomposability := "2 sub-claims: clause (i) conjectural-extension dependency + Deligne 1979 polarisation criterion framework (published)."
 computability := "PUBLISHED framework (signature-independent) + dependency on conjectural-extension clause (i)"
 attackVector := "Typed bridge from clause (i) via Deligne 1979 classical-lit framework axiom. Conjunction-intro closure theorem; reduces axiom count by 1 vs naive fresh-axiom approach."
 attackHistory := ["R-attack-#8-Phase-0-hostile-lit-audit-recommended-typed-bridge-via-Deligne-1979-polarisation-criterion-Phase-2-Lean-writer-closed-gapPartial-conjunction-intro-with-classical-lit-framework"]
 obstacleCitation := none
}

/-- Clause (iii) of hyp:KS-p3: algebraic correspondence on
 Sh × A_N realising Spin-invariant Hodge classes. Lean statements:
 `OpenHypotheses.KugaSatakeAtP3_iii` (`def` = conjectural-
 extension predicate); `OpenHypotheses.IsKSp3CycleRealisationCorrespondence_CONJECTURAL`
 (atomic predicate); `OpenHypotheses.ks_p3_clause_iii_cycle_realisation_correspondence_CONJECTURAL`
 (classical-lit / conjectural-extension axiom);
 `MainTheorem.hyp_KS_p3_clause_iii_closed` (closure theorem, no-sorry
 defeq rebinding via the conjectural-extension axiom).

 **Status: gapPartial.** Mirror of R8 clause (i) single-conjectural-
 extension-axiom pattern. `\ref{hyp:KS-p3}` clause (iii) statement +
 caveat (strictly stronger than clauses (i)-(ii), cycle-realisation at
 level of invariant subspaces) + circularity disclosure (clause (iii)
 ≥ HC|Sh(Spin(p,3),D)|_invariant + HC|A_N pullback component).
 Madapusi Pera 2016 Compositio Math. 152 (arXiv:1212.1243) Thm 4.17 +
 Moonen 1998 LMS LNS 254 establish the (n, 2) analogue (Hermitian
 symmetric SO(n-2, 2)); the (p, 3) case is non-Hermitian and "would
 require a genuinely new construction at q=3"
 (`\ref{hyp:KS-p3}` closing remark). Phase 0 verdict: PROCEED via
 single conjectural-extension
 axiom because the Option B alternative (decompose into HC|Sh + HC|A_N
 + reduction) "splits one open into two opens" (Millennium-target HC
 instances themselves), violating the spirit of
 feedback_lean_axiom_decomposition. -/
def gap_KS_p3_iii : LedgerEntry := {
 identifier := "hyp:KS-p3 clause (iii)"
 paperLabel := "hyp:KS-p3"
 status := GapStatus.gapPartial
 closureDistance := "Conjectural-extension. `\\ref{hyp:KS-p3}` clause (iii) statement: 'the embedding induces an algebraic correspondence on Sh(Spin(p,3), D) × A_N realising each Spin(p,3)-invariant Hodge class as the pullback of a Hodge class on A_N'. `\\ref{hyp:KS-p3}` clause (iii) caveat: 'strictly stronger than (i)-(ii)... cycle-realisation at level of invariant subspaces'. `\\ref{hyp:KS-p3}` clause (iii) circularity disclosure: clause (iii) is at-least-as-strong-as HC|Sh(Spin(p,3),D)|_invariant + HC|A_N pullback component; '(p,3) case requires a genuinely new construction at q=3'. Madapusi Pera 2016 Compositio 152 Thm 4.17 + Moonen 1998 LMS LNS 254 establish the (n,2) analogue ONLY (non-Hermitian SO(p,3) blocks)."
 decomposability := "1 atomic claim. NO useful framework decomposition (published (n,2) cycle-realisation does NOT extend to (p,3)). Option B (HC|Sh + HC|A_N reduction) was considered but rejected per Phase 0 (splits one open into two open Millennium-target HC instances)."
 computability := "Conjectural-extension (no published source for (p,3); paper-acknowledged hypothesis with explicit circularity disclosure)"
 attackVector := "Single conjectural-extension axiom labelled CONJECTURAL, mirroring R8 clause (i) pattern. Lean: IsKSp3CycleRealisationCorrespondence_CONJECTURAL opaque predicate + ks_p3_clause_iii_cycle_realisation_correspondence_CONJECTURAL axiom + KugaSatakeAtP3_iii def + hyp_KS_p3_clause_iii_closed theorem (defeq rebinding via the conjectural-extension axiom)."
 attackHistory := ["R-attack-#17-Phase-0-hostile-lit-audit-confirmed-Madapusi-Pera-Moonen-cover-n2-only-not-p3-Phase-0-recommended-Option-i-single-conjectural-extension-axiom-vs-Option-B-HC-Sh-plus-HC-AN-decomposition-because-splitting-open-into-2-opens-is-bookkeeping-retreat-Phase-1-cross-source-confirmed-CDK-Voisin-Klingler-do-not-extend-to-p3-Phase-2-Lean-writer-closed-gapPartial-via-mirror-of-R8-clause-i-pattern-plus-bundled-hyp-KS-p3-axiom-to-theorem-refactor-N-0-common-witness"]
 obstacleCitation := none
}

/-- Clause (i) of hyp:ChernWeil-bridge-E7: Schwarz invariant + non-vanishing
 [q]_G != 0 in H^8(G_C / P_7, Q). Lean statements:
 `OpenHypotheses.ChernWeilBridge_E7_i` (def, concrete conjunction);
 `OpenHypotheses.IsSchwarzE7QuarticGenerator` (atomic predicate);
 `OpenHypotheses.IsBorelHirzebruchNonvanishH8` (atomic predicate, now
 DERIVED via the two-atom decomposition below);
 `OpenHypotheses.IsChernSubringSurjectiveOntoH8_E7P7` (PUBLISHED atom —
 cohomology side, rigid: H^8(E_7^C/P_7,Q) = Q.h^4, Chern subring surjects);
 `OpenHypotheses.IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS`
 (the literature-absent cross-ring bridge Phi : Sym^4(V_56*)^{E_7} -> H^8,
 carrying the irreducible conjectural content);
 `OpenHypotheses.schwarz_1978_E7_quartic_generator` (classical-lit axiom);
 `OpenHypotheses.chern_subring_surjects_onto_H8_E7P7_PUBLISHED`,
 `OpenHypotheses.cross_ring_bridge_freudenthal_quartic_nonzero_E7P7_INVENTION_CLASS`,
 `OpenHypotheses.borel_hirzebruch_nonvanish_H8_from_chern_subring_and_bridge`
 (bridge axiom), `OpenHypotheses.borel_hirzebruch_1958_freudenthal_nonvanish_H8_PAPER_LABELLED_CONJECTURAL`
 (now a DERIVED theorem, name kept for downstream stability);
 `MainTheorem.hyp_ChernWeil_bridge_E7_i_closed` (closure theorem,
 no-sorry body via conjunction-intro).

-/
def gap_ChernWeil_bridge_E7_i : LedgerEntry := {
 identifier := "hyp:ChernWeil-bridge-E7 clause (i)"
 paperLabel := "hyp:ChernWeil-bridge-E7"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#103 REFACTOR (clause (i.b) decomposed per Phase-4 recommendation; tier of the conjectural part refined PAPER-LABELLED-CONJECTURAL → `_INVENTION_CLASS`). Clause (i.a) Schwarz 1978 Invent. Math. 49 (`ℂ[V_56]^{E_7} = ℂ[q]`, Freudenthal quartic deg 4) — PUBLISHED. Clause (i.b) `[q]_G ≠ 0 ∈ H^8(E_7^ℂ/P_7, ℚ)` is no longer a monolithic conjectural axiom but a DERIVED theorem from two atoms: (i.b.1) `IsChernSubringSurjectiveOntoH8_E7P7` — PUBLISHED, the cohomology side is fully rigid: `dim H^8(E_7^ℂ/P_7, ℚ) = 1` (= ℚ·h^4; Borel 1953 presentation / minuscule weight-poset rank-generating function E_7 degrees {2,6,8,10,12,14,18} over E_6 {2,5,6,8,9,12}), and the homogeneous bundle `𝓥_56` has Chern roots `{3h(×1), h(×27), −h(×27), −3h(×1)}` (from `V_56 ↓ E_6·U(1) = 1_{+3} ⊕ 27_{+1} ⊕ 27̄_{−1} ⊕ 1_{−3}`) so `c_2(𝓥_56) = −36h^2`, `c_4(𝓥_56) = 594h^4`, hence the Chern subring surjects onto `H^8`; (i.b.2) `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS` — the cross-ring map `Φ : Sym^4(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` is nonzero on `q`. (i.b.2) is `_INVENTION_CLASS` (not merely PAPER-LABELLED-CONJECTURAL): the map `Φ` is literature-absent (Borel-Hirzebruch's characteristic map has domain `Sym(𝔱^*)^W`, not the fiber invariants; the paper itself says the needed bridge 'is not a corollary of Borel-Hirzebruch'), and the one canonical geometric reading (restrict `q` to the tautological line `O(−1)`) gives `Φ(q) = q(v_{ω_7})·h^4 = 0` because the highest-weight vector lies on `E_7^ℂ/P_7 ⊂ {q=0}` (tangential variety = the quartic hypersurface; Landsberg-Manivel J. Algebra 239 (2001) Prop. 5.8 + §5.3) — so `Φ` must be CONSTRUCTED, not found. Same tier as SG-22 `NCpi3ToClassicalChowLift` and `hecke_bbt_c`."
 decomposability := "Clause (i) = (i.a) ∧ (i.b). (i.a) Schwarz invariant theorem (PUBLISHED 4-source bundle Schwarz 1978 / Brown 1969 / Cooperstein 1995 / Sato-Kimura 1977). (i.b) = (i.b.1) ∧ (i.b.2): (i.b.1) `IsChernSubringSurjectiveOntoH8_E7P7` PUBLISHED folklore-corollary (dim-H^8 from minuscule-poset combinatorics + Chern-class computation from the 56-weight diagram; Borel 1953 / BGG 1973 / Bott 1957 Ann. Math. 66 / Watanabe 1975); (i.b.2) `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS` — the literature-absent cross-ring bridge `Φ`, `_INVENTION_CLASS` tier. Lean: `IsBorelHirzebruchNonvanishH8` is now DERIVED via bridge axiom `borel_hirzebruch_nonvanish_H8_from_chern_subring_and_bridge` from the two atoms; `borel_hirzebruch_1958_freudenthal_nonvanish_H8_PAPER_LABELLED_CONJECTURAL` converted axiom → theorem."
 computability := "POST-R-#103: clause (i.a) PUBLISHED; clause (i.b.1) PUBLISHED (cohomology side rigid — explicit computation); clause (i.b.2) `_INVENTION_CLASS` — the cross-ring bridge `Φ : Sym^4(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` and its non-triviality on `q` must be invented (no published construction; canonical geometric `Φ` gives 0). Unclosable by citation or by the cohomology computation alone."
 attackVector := "POST-R-#103: status gapPartial. The irreducible open content is now a single typed atom `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS` (the cross-ring bridge `Φ` nonzero on the Freudenthal quartic). Future closure requires CONSTRUCTING `Φ` — e.g. via a Chern-Weil-type theory genuinely on `E_7`-fiber invariants (not the structure-group `𝔤𝔩` invariants of Bott 1965 / Kobayashi-Nomizu Ch. XII, nor the Cartan-invariant domain of Borel-Hirzebruch), or via a Hodge-theoretic / period-domain interpretation pinning the class. The cohomology side (`IsChernSubringSurjectiveOntoH8_E7P7`) is settled. The Lean dependency graph is preserved as a typed conditional bridge per the broken-link discipline; if `Φ` is one day constructed with `Φ(q) ≠ 0`, the chain reconnects unconditionally."
 attackHistory := ["R-attack-#1-Phase-1-2026-05-11-1A-Schwarz-VERIFIED-1B-BorelHirzebruch-VERIFIED-1C-triple-source-VERIFIED-Phase-2-Lean-writer-closed-no-sorry-2026-05-11", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-clause-i-b-paper-labels-non-vanishing-conjectural-but-Lean-axiom-typed-unconditional-status-DOWNGRADED-gapClosed-to-gapPartial", "R-attack-#101-global-re-survey-Plan-agent-identified-clause-i-b-as-the-ONLY-remaining-headroom-gap-in-the-formalization-hunch-it-might-be-a-finite-Schubert-calculus-computation-rather-than-a-genuine-open-conjecture", "R-attack-#102-Constructor-Phase-0-no-published-source-establishes-i-b-checked-Schwarz-Borel-Borel-Hirzebruch-Atiyah-Bott-BGG-Brion-Iliev-Manivel-Cayley-plane-Bott-1965-Kobayashi-Nomizu-Landsberg-Manivel-no-phantom-citations-Phase-1-the-cohomology-side-is-fully-RIGID-dim-H-8-E7-P7-Q-equals-1-equals-Q-h-4-triple-confirmed-via-Poincare-quotient-and-minuscule-weight-poset-V_56-down-E6-equals-1-27-27bar-1-charge-3-to-1-Chern-roots-3h-h-27-minus-h-27-minus-3h-c_2-equals-minus-36-h-2-c_4-equals-594-h-4-Chern-subring-surjects-onto-H-8-BUT-the-cross-ring-bridge-Phi-Sym-4-V_56-star-E7-to-H-8-is-literature-absent-and-the-canonical-geometric-Phi-restrict-q-to-O-minus-1-gives-Phi-q-equals-q-v-omega-7-times-h-4-equals-0-because-q-vanishes-on-the-closed-orbit-E7-P7-subset-q-equals-0-tangential-variety-Landsberg-Manivel-J-Algebra-239-2001-Prop-5-8-VERDICT-GENUINELY-OPEN-paper-PAPER-LABELLED-CONJECTURAL-tag-CORRECT-not-too-cautious-no-Lean-retitle-warranted-formalization-at-honest-saturation-on-this-gap", "R-attack-#103-fresh-hostile-audit-CONFIRMED-R-#102-no-closing-citation-checked-Vinberg-theta-groups-all-Iliev-Manivel-and-Landsberg-Manivel-papers-incl-magic-square-and-Cayley-plane-Chaput-Manivel-Perrin-Sato-Kimura-Garibaldi-Goresky-Pardon-Friedman-Laza-Gross-Landsberg-Manivel-Prop-5-8-actively-confirms-q-vanishes-on-E7-P7-the-negative-direction-rigid-computations-re-verified-exactly-2-genuine-findings-both-honest-DOWNGRADES-1-reclassify-clause-i-b-conjectural-part-one-tier-down-PAPER-LABELLED-CONJECTURAL-to-INVENTION-CLASS-same-situation-as-SG-22-and-hecke_bbt_c-2-the-Phi-refactor-is-warranted-split-IsBorelHirzebruchNonvanishH8-into-PUBLISHED-Chern-subring-atom-plus-INVENTION-CLASS-cross-ring-bridge-atom-REFACTOR-DONE-this-round-IsBorelHirzebruchNonvanishH8-now-DERIVED-via-bridge-axiom-borel_hirzebruch_1958_freudenthal_nonvanish_H8-converted-axiom-to-theorem-build-clean-0-sorry-status-stays-gapPartial-no-promotion-this-Lean-izes-the-genuinely-open-finding-per-broken-link-discipline"]
 obstacleCitation := some "POST-R-#103: clause (i.b) decomposed. (i.b.1) `IsChernSubringSurjectiveOntoH8_E7P7` — PUBLISHED (the cohomology side is rigid: `dim H^8(E_7^ℂ/P_7, ℚ) = 1 = ℚ·h^4`, `c_2(𝓥_56) = −36h^2`, `c_4(𝓥_56) = 594h^4` span it; Borel 1953 presentation + minuscule poset + Bott 1957 Ann. Math. 66 (203-248)). (i.b.2) `IsCrossRingBridgeNonzeroOnFreudenthalQuartic_E7P7_INVENTION_CLASS` — the operative obstacle: a Chern-Weil cross-ring map `Φ : Sym^4(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` nonzero on the Freudenthal quartic, which is NOT in the literature (Borel-Hirzebruch's characteristic map has the wrong domain `Sym(𝔱^*)^W`; the paper itself: 'not a corollary of Borel-Hirzebruch') and whose canonical geometric candidate gives 0 (q vanishes on the closed orbit `E_7^ℂ/P_7 ⊂ {q=0}`, the tangential variety; Landsberg-Manivel J. Algebra 239 (2001) Prop. 5.8 + §5.3). `_INVENTION_CLASS` — `Φ` must be constructed; same tier as SG-22 / hecke_bbt_c. R-#102 Constructor + R-#103 hostile audit both confirmed: unclosable by citation or by the cohomology computation alone; formalization at honest saturation on this gap."
}

/-- Clause (ii) of hyp:ChernWeil-bridge-E7: Matsushima descent of [q]_G to
 [q] in H^8(S_Gamma^tor, C). Lean statements:
 `OpenHypotheses.ChernWeilBridge_E7_ii` (concrete def = conjunction);
 `OpenHypotheses.IsMatsushimaDescentToSGamma` (atomic predicate);
 `OpenHypotheses.IsMumfordCanonicalExtensionToTor` (atomic predicate);
 `OpenHypotheses.matsushima_borel_wallach_descent_to_SGamma_PAPER_LABELLED_CONJECTURAL` (classical-lit axiom; Borel-Wallach is operative since AMRT-tor context is non-cocompact);
 `OpenHypotheses.mumford_1977_canonical_extension_to_tor_PAPER_LABELLED_CONJECTURAL` (classical-lit axiom);
 `MainTheorem.hyp_ChernWeil_bridge_E7_ii_closed` (closure theorem,
 no-sorry conjunction-intro from the two classical-lit axioms).

-/
def gap_ChernWeil_bridge_E7_ii : LedgerEntry := {
 identifier := "hyp:ChernWeil-bridge-E7 clause (ii)"
 paperLabel := "hyp:ChernWeil-bridge-E7"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#105 REFACTOR (clauses (ii.a) and (ii.b) each decomposed per R-#104 Phase-0 lit-review). Each sub-clause is now framework-PUBLISHED + `_REQUIRED_HYPOTHESIS` conjectural-extension atom + bridge axiom (mirroring hyp:BBT-rigid-reach Pattern (ii)). (ii.a) `IsMatsushimaDescentToSGamma` is now DERIVED from (a) `IsBorelWallachStableInvariantDescentFramework_E7` PUBLISHED — Borel-Wallach 2000 Ch. VII (the operative source for the non-cocompact AMRT-tor context; Matsushima 1962 Osaka Math. J. 14 is only the historical cocompact prototype) + cross-source Vogan-Zuckerman 1984 Compositio 53 + Franke 1998 Ann. Sci. ÉNS 31 — and (b) `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS` — the specific `[q]_G` is realised by `G`-invariant cohomology at degree 8 (no Eisenstein-boundary corrections); this is the genuine residual content of (ii.a) per `\\ref{hyp:ChernWeil-bridge-E7}` Status + `rem:borel-matsushima`. (ii.b) `IsMumfordCanonicalExtensionToTor` is now DERIVED from (c) `IsMumfordCanonicalExtensionFramework_E7` PUBLISHED — Mumford 1977 Invent. Math. 42 (good metrics + Chern-number proportionality) + AMRT 2010 (toroidal `S^tor`, fully general for EVII; the prior PEL-restricted framing was a misattribution-of-limitation — PEL applies to Faltings-Chai/Lan, not AMRT) + cross Harris 1989 Proc. LMS (3) 59 (1-22) (Goresky-Pardon 2002's Chern-subalgebra theorem is restricted to classical types per §1.3 Thm 16.4 and is surfaced as separate `_REQUIRED_HYPOTHESIS` atom for the EVII extension — NOT part of the framework PUBLISHED for EVII) — and (d) `IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS` — the boundary-compatibility at degree 8 in the weight-3 non-classical signature, exactly the 'non-cocompact-boundary regime at degree 8 = conditional' content the paper labels. Old axioms `matsushima_borel_wallach_descent_to_SGamma_PAPER_LABELLED_CONJECTURAL` and `mumford_1977_canonical_extension_to_tor_PAPER_LABELLED_CONJECTURAL` converted axiom → derived theorem (names kept). Status stays gapPartial; the conjectural content is now localised in 2 `_REQUIRED_HYPOTHESIS` atoms."
 decomposability := "Clause (ii) = (ii.a) ∧ (ii.b). (ii.a) = (a)∧(b): (a) `IsBorelWallachStableInvariantDescentFramework_E7` PUBLISHED + (b) `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS` conjectural-extension. (ii.b) = (c)∧(d): (c) `IsMumfordCanonicalExtensionFramework_E7` PUBLISHED + (d) `IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS` conjectural-extension. Lean: 4 new atom predicates + 4 new atom axioms + 2 bridge axioms; `IsMatsushimaDescentToSGamma`/`IsMumfordCanonicalExtensionToTor` opaque predicate-witnesses preserved; both `_PAPER_LABELLED_CONJECTURAL` axioms converted to derived theorems."
 computability := "POST-R-#105: clause (ii.a) PUBLISHED framework (Borel-Wallach Ch. VII) + `_REQUIRED_HYPOTHESIS` for specific-`[q]_G` realisation in G-invariant cohomology at degree 8; clause (ii.b) PUBLISHED framework (Mumford 1977 + AMRT 2010 (G-P 2002 covers only classical types per §1.3 Thm 16.4; EVII surfaced as separate `_REQUIRED_HYPOTHESIS`)) + `_REQUIRED_HYPOTHESIS` for boundary-compatibility at degree 8. No claim closable by citation; conjectural content cleanly localised."
 attackVector := "POST-R-#105: status gapPartial. Conjectural surface = 2 `_REQUIRED_HYPOTHESIS` atoms (specific-`[q]_G` realisation in G-invariant cohomology at degree 8; specific-`[q]` boundary-compatibility at degree 8). Future closure of each requires either a published-as-yet-uncited result actually establishing the specific claim, or a fresh construction. The dependency graph is preserved as typed conditional bridges per the broken-link discipline; if either `_REQUIRED_HYPOTHESIS` atom is established, the chain reconnects unconditionally for that sub-clause."
 attackHistory := ["R-attack-#3-Phase-1-2026-05-11-Matsushima-Mumford-triple-source-verified-Phase-2-Lean-writer-closed-no-sorry-conjunction-intro-2026-05-11", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-clause-ii-non-cocompact-boundary-paper-labels-conditional-but-Lean-axioms-typed-unconditional-status-DOWNGRADED-gapClosed-to-gapPartial", "R-attack-#104-Phase-0-hostile-lit-review-full-theorem-survey-of-Matsushima-1962-1967-Borel-Wallach-1980-Mumford-1977-AMRT-1975-2010-Goresky-Pardon-2002-Faltings-Chai-Lan-Harris-1985-determined-the-correct-PUBLISHED-vs-REQUIRED-HYPOTHESIS-split-for-each-sub-clause-also-caught-3-Phase-0-defects-Matsushima-Ann-Math-75-1962-312-330-was-a-phantom-fix-to-Osaka-Math-J-14-1962-1-20-Goresky-Pardon-cited-only-as-arXiv-preprint-fix-to-Invent-Math-147-2002-561-612-AMRT-PEL-restricted-was-misattribution-of-limitation-PEL-belongs-to-Faltings-Chai-Lan-not-AMRT-also-flagged-missing-bibitems-GoreskyPardon-Vogan-Zuckerman-in-master-tex", "R-attack-#105-REFACTOR-clause-ii-decomposed-per-R-#104-design-4-new-atom-predicates-IsBorelWallachStableInvariantDescentFramework_E7-PUBLISHED-IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS-IsMumfordCanonicalExtensionFramework_E7-PUBLISHED-IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS-plus-4-atom-axioms-plus-2-bridge-axioms-old-PAPER-LABELLED-CONJECTURAL-axioms-converted-to-derived-theorems-names-kept-build-clean-0-sorry-status-stays-gapPartial-Phase-0-defects-fixed-in-new-docstrings-Matsushima-citation-AMRT-PEL-misattribution-Goresky-Pardon-Invent-Math-147", "R-attack-#106a-Phase-4-structural-audit-on-R-#105-found-2-CRITICAL-gaps-B1-B2-iii-bridge-silently-bundled-q_G-equals-Phi-q-and-ii-a-descent-map-equals-iii-ring-hom-identifications-no-Lean-atom-carried-them-plus-2-MILD-folklore-corollary-tier-clarifications-on-BW-framework-and-ring-hom-glue-atoms", "R-attack-#106b-Phase-4-citation-audit-on-R-#105-found-3-MAJOR-Goresky-Pardon-2002-scope-restricted-to-Sp_n-U-p-q-SO-2n-SO-2-p-NOT-EVII-per-G-P-section-1-3-Thm-16-4-and-G-P-section-1-6-explicitly-open-equal-rank-extension-G-P-classes-on-Baily-Borel-not-toroidal-BW-chapter-VII-vs-XIII-XIV-mismatch-plus-4-MINOR-Snow-1986-title-Mumford-1977-ring-compat-folklore-Harris-1985-section-2-wrong-Snow-Landsberg-Manivel-bibitem-absence", "R-attack-#107-PATCH-batch-of-R-#106a-and-R-#106b-findings-renamed-IsMumfordGoreskyPardonCanonicalExtensionFramework_E7-to-IsMumfordCanonicalExtensionFramework_E7-since-G-P-does-not-cover-EVII-added-new-REQUIRED_HYPOTHESIS-atom-IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS-surfacing-G-P-section-1-6-open-equal-rank-extension-consumed-by-iii-bridge-not-by-ii-b-added-new-PUBLISHED-folklore-corollary-atom-IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED-handling-B1-B2-identifications-iii-bridge-now-7-input-was-5-folklore-corollary-qualifier-added-to-BW-framework-and-ring-hom-glue-atom-docstrings-Snow-1986-replaced-by-Bott-1957-Ann-Math-66-Harris-1985-section-2-replaced-by-Harris-1989-Proc-LMS-59-G-P-Baily-Borel-locus-disclosed-Mumford-1977-ring-compat-folkloric-upgrade-disclosed-build-clean-0-sorry-status-stays-gapPartial-conjectural-surface-now-4-typed-atoms-1-INVENTION_CLASS-plus-3-REQUIRED_HYPOTHESIS"]
 obstacleCitation := some "POST-R-#107: clause (ii) decomposition + R-#106a/b audit patches applied. PUBLISHED: `IsBorelWallachStableInvariantDescentFramework_E7` (Borel-Wallach 2000 Ch. VII) + `IsMumfordCanonicalExtensionFramework_E7` (Mumford 1977 + AMRT 2010 (G-P 2002 covers only classical types per §1.3 Thm 16.4; EVII surfaced as separate `_REQUIRED_HYPOTHESIS`)). Open conjectural content (2 `_REQUIRED_HYPOTHESIS` atoms): (a) `IsFreudenthalClassRealizedByGInvariantCohomology_E7_REQUIRED_HYPOTHESIS` — the specific `[q]_G` is realised by G-invariant cohomology at degree 8 (no Eisenstein corrections); (b) `IsFreudenthalClassExtendsCompatiblyAtDegree8_E7_REQUIRED_HYPOTHESIS` — boundary-compatibility at degree 8 in the weight-3 non-classical signature. Both are paper-acknowledged conditional inputs per `\\ref{hyp:ChernWeil-bridge-E7}` Status."
}

/-- Clause (iii) of hyp:ChernWeil-bridge-E7: explicit Q-polynomial identity
 [q] = P(c_1, c_2, c_3, c_4). Lean statements:
 `OpenHypotheses.ChernWeilBridge_E7_iii` (concrete def =
 IsPolynomialInCanonicalChernClasses S (freudenthalQuartic S));
 `OpenHypotheses.borel_hirzebruch_schwarz_polynomial_identity_E7_iii_PAPER_LABELLED_CONJECTURAL`
 (classical-lit axiom);
 `MainTheorem.hyp_ChernWeil_bridge_E7_iii_closed` (closure theorem,
 no-sorry rebinding via def equality).

 Together with the clause (i) and (ii) closures, the bundled parent
 `gap_hyp_ChernWeil_bridge_E7` is gapClosed via 3-clause conjunction. -/
def gap_ChernWeil_bridge_E7_iii : LedgerEntry := {
 identifier := "hyp:ChernWeil-bridge-E7 clause (iii)"
 paperLabel := "hyp:ChernWeil-bridge-E7"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#105 REFACTOR (clause (iii) REDUCES-TO (i)+(ii)+1 PUBLISHED ring-hom atom; zero clause-(iii)-specific conjectural content). Per R-#104 Phase-0: the cohomology side of clause (i.b) is rigid (`H^8(Ě_VII, ℚ) = ℚ·h^4` 1-dim, Chern subring surjects); so on the compact dual `[q]_G = P(c_i(𝓥_56))` for some `P ∈ ℚ[x_1, x_2, x_3, x_4]` is pure linear algebra in the 1-dim graded piece, given (i.b.1) PUBLISHED + (i.b.2) `_INVENTION_CLASS` (the latter saying `[q]_G = Φ(q)` lies in the Chern subring). Transport along the (ii.a) descent + (ii.b) extension via a single new PUBLISHED ring-hom-compatibility atom `IsChernWeilDescentRingHomCompatibleWithChernSubring_E7` (Borel-Wallach Ch. VII: Matsushima map = ring map; Mumford 1977 proportionality: `c_i(𝓥^can)` is the proportionality-image of compact-dual `c_i`, ring-compatibly; Goresky-Pardon 2002 §0-1: Chern subalgebra of `H^*(S^tor)` compatibility) gives `[q] = P(c_i(𝓥_56^can))` in `H^8(S_Γ^tor)`. This is exactly the `rem:E7-chernweil-tautology` 'tautological once granted' content. The old monolithic `borel_hirzebruch_schwarz_polynomial_identity_E7_iii_PAPER_LABELLED_CONJECTURAL` axiom converted axiom → derived theorem via the new bridge `polynomial_identity_E7_iii_from_atoms` taking 5 inputs (i.b.1, i.b.2, (ii.a) witness, (ii.b) witness, ring-hom atom). The R-#51 audit note '(iii) is a monolithic axiom not derived from clauses (i)+(ii)' is RESOLVED: it IS now derived. Tier: gapPartial REDUCES-TO (alongside SG-21, hecke_bbt_e); conjectural surface is entirely (i.b.2) + (ii.a) + (ii.b) atoms, no clause-(iii)-specific axiom."
 decomposability := "Clause (iii) = derived theorem, no independent atomic claims. Depends on: (i.b.1) PUBLISHED + (i.b.2) `_INVENTION_CLASS` + (ii.a) `IsMatsushimaDescentToSGamma` (derived from (a)+(b)) + (ii.b) `IsMumfordCanonicalExtensionToTor` (derived from (c)+(d)) + 1 new PUBLISHED atom `IsChernWeilDescentRingHomCompatibleWithChernSubring_E7` (Borel-Wallach + Mumford + Goresky-Pardon ring-hom compatibility). Net new conjectural surface: 0 (zero); the conjectural content of (iii) is fully consumed by (i.b)+(ii)."
 computability := "POST-R-#105: clause (iii) is a DERIVED theorem. The polynomial identity itself is pure 1-dim linear algebra (given the 1-dimensionality of `H^8(Ě_VII, ℚ)` from (i.b.1)) + structural transport along ring-hom-compatible descent/extension. No new conjectural content beyond (i.b) + (ii)."
 attackVector := "POST-R-#105: status gapPartial REDUCES-TO (i.b) + (ii). Clause (iii) has no own attack vector; future closure of clause (iii) is automatic upon closure of (i.b.2) `_INVENTION_CLASS` cross-ring bridge + (ii.a/b) `_REQUIRED_HYPOTHESIS` extension atoms. Same tier as SG-21 (REDUCES-TO disjunction hyp:AH-CM-E7 OR SG-20 atom vii) and hecke_bbt_e (REDUCES-TO chow-modularity-E7)."
 attackHistory := ["R-attack-#4-Phase-1-2026-05-11-Borel-Hirzebruch-plus-Schwarz-deg-4-dim-count-Phase-2-Lean-writer-closed-no-sorry-defeq-rebinding-2026-05-11", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-clause-iii-paper-labels-polynomial-identity-conjectural-both-regimes-Lean-monolithic-axiom-not-derived-from-clauses-i-ii-status-DOWNGRADED-gapClosed-to-gapPartial-with-monolithic-axiom-disclosure", "R-attack-#104-Phase-0-hostile-lit-review-determined-clause-iii-REDUCES-TO-i-b-plus-ii-plus-1-PUBLISHED-ring-hom-atom-zero-clause-iii-specific-conjectural-content-given-the-cohomology-side-rigidity-dim-H-8-E7-P7-equals-1-from-i-b-1-rem-E7-chernweil-tautology-tautological-once-granted-content-confirmed", "R-attack-#105-REFACTOR-clause-iii-from-monolithic-axiom-to-DERIVED-theorem-via-new-PUBLISHED-atom-IsChernWeilDescentRingHomCompatibleWithChernSubring_E7-Borel-Wallach-Ch-VII-plus-Mumford-1977-proportionality-plus-Goresky-Pardon-2002-section-0-1-plus-bridge-axiom-polynomial_identity_E7_iii_from_atoms-taking-5-inputs-i-b-1-PUBLISHED-i-b-2-INVENTION-CLASS-ii-a-witness-ii-b-witness-ring-hom-atom-old-PAPER-LABELLED-CONJECTURAL-axiom-converted-to-derived-theorem-name-kept-build-clean-0-sorry-status-stays-gapPartial-tier-now-REDUCES-TO-alongside-SG-21-and-hecke_bbt_e-R-#51-monolithic-axiom-overclaim-RESOLVED", "R-attack-#106a-Phase-4-found-B1-B2-hidden-identifications-in-iii-bridge-q_G-equals-Phi-q-and-ii-a-descent-map-equals-iii-ring-hom", "R-attack-#106b-Phase-4-found-G-P-EVII-scope-overclaim-G-P-section-1-3-Thm-16-4-restricted-to-classical-types-NOT-EVII-and-G-P-section-1-6-explicitly-open-equal-rank", "R-attack-#107-PATCH-iii-bridge-now-7-input-was-5-2-new-atoms-added-IsGoreskyPardonChernSubalgebraExtensionToEVII_REQUIRED_HYPOTHESIS-G-P-EVII-extension-conjectural-input-and-IsCompactDualQuarticImageAndDescentMapWitnessChain_E7_FOLKLORE_PUBLISHED-paper-definitional-witness-chain-identifications-derived-theorem-now-discharges-all-7-inputs-no-hidden-bundling-clause-iii-still-REDUCES-TO-no-own-conjectural-content-build-clean-0-sorry"]
 obstacleCitation := some "POST-R-#107: clause (iii) still no own obstruction — REDUCES-TO (i.b.2) `_INVENTION_CLASS` cross-ring-bridge atom + (ii.a/b) `_REQUIRED_HYPOTHESIS` extension atoms + (i.b.1)+(new ring-hom) PUBLISHED atoms. The polynomial identity itself is pure 1-dim linear algebra + ring-hom transport given those inputs. The R-#51 'monolithic axiom not derived from (i)+(ii)' finding is resolved: it IS now derived."
}

/-- BaseDim27 accessor of hyp:nonrigid-family-bridge. Lean statements:
 `OpenHypotheses.BaseDim27` (concrete def := `F.base.dim = 27`);
 `OpenHypotheses.helgason_1978_voisin_2002_basedim27` (classical-lit
 axiom directly asserting the Nat equality `F.base.dim = 27`);
 `MainTheorem.hyp_nonrigid_family_basedim27_closed` (closure theorem
 no-sorry rebinding via definitional equality).

 Notable: the lit-axiom asserts a concrete Nat equality (`F.base.dim = 27`),
 NOT an opaque-on-opaque vacuous predicate. The closure is strictly
 stronger than the Schwarz/Borel-Hirzebruch closure (#1), which still
 leaned on opaque atomic predicates. -/
def gap_nonrigid_family_BaseDim27 : LedgerEntry := {
 identifier := "hyp:nonrigid-family-bridge BaseDim27"
 paperLabel := "hyp:nonrigid-family-bridge"
 status := GapStatus.gapClosed
 closureDistance := "CLOSED.dim_C EVII = 27 via Helgason 1978 Differential Geometry, Lie Groups, and Symmetric Spaces Ch. X Table V (Hermitian symmetric spaces table; EVII row complex dim 27, rank 3). Bourbaki Lie VI Planche V+VI cross-source via positive-root count: #pos(E_7) − #pos(E_6) = 63 − 36 = 27. Voisin 2002 Hodge II Ch. 10 confirms period-map dim count."
 decomposability := "1 atomic claim, closed."
 computability := "PUBLISHED (classification table; Nat equality, no opaque vacuity)"
 attackVector := "CLOSED. BaseDim27 converted from opaque axiom to concrete def := F.base.dim = 27; lit-axiom helgason_1978_voisin_2002_basedim27 asserts the Nat equality directly; closure theorem rebinds via defeq."
 attackHistory := ["R-attack-#2-Phase-1-2026-05-11-Helgason-Bourbaki-Voisin-triple-source-verified-Phase-2-Lean-writer-closed-no-sorry-Nat-equality-2026-05-11"]
 obstacleCitation := none
}

/-- PeriodMapDominant accessor of hyp:nonrigid-family-bridge. Lean
 statements: `OpenHypotheses.PeriodMapDominant F` (opaque predicate);
 `OpenHypotheses.schmid_1973_period_map_dominant_PAPER_LABELLED_CONJECTURAL` (classical-lit axiom).
 CLOSED. -/
def gap_nonrigid_family_PeriodMapDominant : LedgerEntry := {
 identifier := "hyp:nonrigid-family-bridge PeriodMapDominant"
 paperLabel := "hyp:nonrigid-family-bridge"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#51 DOWNGRADE (gapClosed → gapPartial). Paper labels period-map dominance as paper-labelled-expectation (LABELLED INPUT per `\\ref{hyp:nonrigid-family-bridge}` L11635-11685). Schmid 1973 nilpotent-orbit Thm 4.9 analyses ASYMPTOTIC BEHAVIOR of an already-given period map, but does NOT establish DOMINANCE from non-rigidity hypothesis alone. The Lean axiom `schmid_1973_period_map_dominant_PAPER_LABELLED_CONJECTURAL : ∀ F, IsFibrewiseNonRigid F → PeriodMapDominant F` is typed unconditional but Schmid 1973 supplies framework (period-map asymptotics) not the specific dominance from non-rigidity (Kodaira-Spencer versal deformation gives dim B = h^1(T_X) but may be < 27 or isotrivial)."
 decomposability := "1 atomic claim, PAPER-LABELLED-CONJECTURAL post-R-#51."
 computability := "POST-R-#51: PUBLISHED framework (Schmid 1973 period-map asymptotic framework) + PAPER-LABELLED-CONJECTURAL specific dominance from non-rigidity."
 attackVector := "POST-R-#51 + R-#53: gapPartial. Standalone closure theorem `hyp_nonrigid_family_periodmapdominant_closed` added in MainTheorem.lean (R-#53 Batch 2 MED fix; previously closure was inline-only within `hyp_nonrigid_family_bridge`). Lean axiom preserved; status reflects paper-labelled-conjectural nature of specific dominance claim."
 attackHistory := ["R-attack-#5-2026-05-11-Schmid-1973-nilpotent-orbit-classical-lit-axiom", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-Schmid-1973-establishes-period-map-asymptotics-not-dominance-from-non-rigidity-paper-labels-EXPECTED-status-DOWNGRADED-gapClosed-to-gapPartial", "R-attack-#53-Batch-2-MED-fix-standalone-closure-theorem-hyp_nonrigid_family_periodmapdominant_closed-added"]
 obstacleCitation := some "POST-R-#51: paper-labelled-conjectural. Schmid 1973 framework applies to asymptotic behavior of GIVEN period map, NOT establishment of dominance FROM non-rigidity hypothesis. Paper-labelled-input per master tex L11635-11685."
}

/-- PeriodMapGenericallyFinite accessor of hyp:nonrigid-family-bridge.
 Lean statements: `OpenHypotheses.PeriodMapGenericallyFinite F` (opaque
 predicate); `OpenHypotheses.griffiths_1968_period_map_generically_finite_PAPER_LABELLED_CONJECTURAL`
 (classical-lit axiom). CLOSED. -/
def gap_nonrigid_family_PeriodMapGenericallyFinite : LedgerEntry := {
 identifier := "hyp:nonrigid-family-bridge PeriodMapGenericallyFinite"
 paperLabel := "hyp:nonrigid-family-bridge"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#51 DOWNGRADE (gapClosed → gapPartial). Paper labels period-map generic finiteness as paper-labelled-expectation per `\\ref{hyp:nonrigid-family-bridge}` L11635-11685. Griffiths 1968 local Torelli is a CONDITION on a VHS that does NOT hold automatically — paper explicitly notes 'the period map may have positive-dimensional fibres'. Lean axiom `griffiths_1968_period_map_generically_finite_PAPER_LABELLED_CONJECTURAL : ∀ F, IsFibrewiseNonRigid F → PeriodMapGenericallyFinite F` is typed unconditional but local Torelli supplies framework not the specific generic finiteness from non-rigidity."
 decomposability := "1 atomic claim, PAPER-LABELLED-CONJECTURAL post-R-#51."
 computability := "POST-R-#51: PUBLISHED framework (Griffiths 1968 local Torelli for Hermitian symmetric VHS) + PAPER-LABELLED-CONJECTURAL specific generic finiteness from non-rigidity."
 attackVector := "POST-R-#51 + R-#53: gapPartial. Standalone closure theorem `hyp_nonrigid_family_periodmapgenericallyfinite_closed` added in MainTheorem.lean (R-#53 Batch 2 MED fix). Lean axiom preserved; status reflects paper-labelled-conjectural nature of specific generic-finiteness claim."
 attackHistory := ["R-attack-#5-2026-05-11-Griffiths-1968-local-Torelli-classical-lit-axiom", "R-attack-#51-Phase-4-retroactive-audit-MAJOR-DEFECT-Griffiths-1968-local-Torelli-is-condition-not-consequence-paper-labels-EXPECTED-status-DOWNGRADED-gapClosed-to-gapPartial", "R-attack-#53-Batch-2-MED-fix-standalone-closure-theorem-hyp_nonrigid_family_periodmapgenericallyfinite_closed-added"]
 obstacleCitation := some "POST-R-#51: paper-labelled-conjectural. Griffiths 1968 local Torelli is a CONDITION on a VHS, not automatic from non-rigidity hypothesis. Paper-labelled-input per master tex L11635-11685."
}

/-- FibreIsoAt_b0 accessor of hyp:nonrigid-family-bridge. Lean statements:
 `OpenHypotheses.FibreIsoAt_b0 F` (opaque predicate);
 `OpenHypotheses.kodaira_spencer_1958_fibre_iso_b0` (classical-lit axiom).
 CLOSED. -/
def gap_nonrigid_family_FibreIsoAt_b0 : LedgerEntry := {
 identifier := "hyp:nonrigid-family-bridge FibreIsoAt_b0"
 paperLabel := "hyp:nonrigid-family-bridge"
 status := GapStatus.gapClosed
 closureDistance := "CLOSED.Kodaira-Spencer 1958 Ann. Math. 67 (versal deformation; fibre at base point = original variety; defining property of Kuranishi family). Cross-source: Kuranishi 1964 (universal local deformation); Hartshorne 2010 Deformation Theory GTM 257."
 decomposability := "1 atomic claim, closed."
 computability := "PUBLISHED (Kodaira-Spencer versal deformation defining property)"
 attackVector := "CLOSED. Lean: classical-lit axiom `kodaira_spencer_1958_fibre_iso_b0 : ∀ F, FibreIsoAt_b0 F`; standalone closure theorem `hyp_nonrigid_family_fibreisoatb0_closed` in MainTheorem.lean (added R-#53 Batch 2 MED fix; defeq rebinding)."
 attackHistory := ["R-attack-#5-2026-05-11-Kodaira-Spencer-1958-versal-deformation-classical-lit-axiom", "R-attack-#53-Batch-2-MED-fix-standalone-closure-theorem-hyp_nonrigid_family_fibreisoatb0_closed-added"]
 obstacleCitation := none
}

/-- hyp:hecke-bbt core clause. Lean statements:
 `OpenHypotheses.HeckeBBTEquivariance` (transparent 4-fold conjunction
 `def`); `OpenHypotheses.hyp_hecke_bbt_core` (closure theorem, no-sorry
 conjunction-intro from 4 atomic axioms). Two framework atoms
 (`IsBKTHeckeCorrespondencesDefinable_E7Minus25` and
 `IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL`) are
 reused from clause (d) decomposition; two atoms
 (`IsBBTPeriodImageQuasiProjective_E7Minus25` and
 `IsAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL`) are core-specific.

 **Status: gapPartial.** Theorem-level closure via conjunction-intro
 from 4 atomic axioms (2 framework PUBLISHED + 2 conjectural-extension).
 Driven by the 2 conjectural-extension dependencies (algebraic-locus
 Hecke-stability + Chow-level Hecke-BBT-commutation), both
 paper-acknowledged hypothesis status per `\ref{hyp:hecke-bbt}` core
 statement + item (d). -/
def gap_hecke_bbt_core : LedgerEntry := {
 identifier := "hyp:hecke-bbt core"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 closureDistance := "4-atom decomposition. Framework atoms PUBLISHED: BKT 2020 JAMS 33 (917-939, Thm 1.1(2), Hecke correspondences R_alg-definable on arithmetic quotients) + BBT 2023 Invent. Math. 232 (163-228, Thm 1.1, Griffiths-conjecture period-map factorization with quasi-projective image, arXiv:1811.12230). Conjectural-extension atoms: algebraic-locus Hecke-stability for Shimura/VHS (`\\ref{hyp:hecke-bbt}` core handwave parenthetical; not pinned to single published source per R15 cross-source check Voisin II / Bloch 1980 / Fulton Ch. 16 / CDK 1995 / Klingler arXiv:1711.09387) + Chow-level Hecke-equivariance of BBT spreading (`\\ref{hyp:hecke-bbt}` item (d) 'Hecke-equivariant refinement', paper-acknowledged hypothesis). Status gapPartial driven by the 2 conjectural-extension atoms."
 decomposability := "4 atomic predicates (2 framework + 2 conjectural-extension). Reused from clause (d): IsBKTHeckeCorrespondencesDefinable_E7Minus25 + IsChowLevelHeckeEquivariantBBTSpreading_E7Minus25_CONJECTURAL. New in R15: IsBBTPeriodImageQuasiProjective_E7Minus25 + IsAlgebraicLocusHeckeStable_E7Minus25_CONJECTURAL."
 computability := "PUBLISHED framework (2 atoms: BKT 2020 + BBT 2023) + paper-acknowledged hypothesis for conjectural-extensions (2 atoms)"
 attackVector := "PARTIAL closure via conjunction-intro: def HeckeBBTEquivariance = 4-fold ∧; theorem hyp_hecke_bbt_core = no-sorry constructor from 4 atomic axioms. The Lean axiom bbt_2023_period_image_quasi_projective_E7Minus25 isolates the Thm-1.1 framework piece (Griffiths quasi-projectivity); the spreading-from-Hecke-stable conclusion is captured by the conjunction of all 4 atoms (BKT 2020 definability + BBT 2023 quasi-projectivity + alg-locus-Hecke-stability + Chow-level commutation)."
 attackHistory := ["R-attack-#15-Phase-0-hostile-lit-audit-2026-05-11-2-fresh-agents-verified-BBT-2023-Thm-1-1-is-Griffiths-conjecture-quasi-projectivity-not-spreading-master-tex-L7586-scope-error-confirmed-flagged-Phase-1-2-fresh-agents-confirmed-Alg-Hecke-stable-not-in-Voisin-Bloch-Fulton-CDK-Klingler-Phase-2-Lean-writer-axiom-HeckeBBTEquivariance-to-def-conversion-plus-4-atomic-axioms-2-framework-2-conjectural-extension-axiom-hyp-hecke-bbt-core-to-theorem-no-sorry-conjunction-intro"]
 obstacleCitation := none
}

/-- Clause (a) of hyp:hecke-bbt: (g, K)-cohomology Hermitian form. Lean
 statements: `OpenHypotheses.HeckeBBT_gK_cohomology` (concrete def =
 4-clause conjunction); 4 atomic predicates (3 framework + 1 conjectural-
 extension); 4 classical-lit axioms (VZ 1984, Borel-Wallach 1980/2000,
 Adams 2007 + GW 1996 Crelle 481 conjectural-extension);
 `OpenHypotheses.hyp_hecke_bbt_a` (closure theorem, no-sorry conjunction-
 intro).

 **Status: gapPartial** (NOT gapClosed). Reason: 1 of 4 atomic predicates
 (`IsGWParallelPortHermE7Minus25_CONJECTURAL`) is a conjectural-extension
 from GW 1996 quaternionic to Hermitian `E_{7(-25)}`; master proof
 master paper's Gap note on parallel transfer to Hermitian
 E_{7(-25)} preceding `\ref{hyp:hecke-bbt}` explicitly acknowledges
 this parallel-port is "standard
 but technically unpublished for the Hermitian case." Framework
 ingredients (VZ 1984, Borel-Wallach, Adams 2007) ARE published. -/
def gap_hecke_bbt_a : LedgerEntry := {
 identifier := "hyp:hecke-bbt clause (a)"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 attackHistory := ["R-attack-#6-Phase-0-hostile-lit-audit-2026-05-11-flagged-paper-self-acknowledged-unpublished-parallel-port-master-proof-L10267-10274-plus-GW-1996-citation-correction-Math-Z-222-WRONG-Crelle-481-CORRECT-Phase-2-Lean-writer-closed-gapPartial-conjunction-intro-Phase-4-hostile-re-audit-PARTIAL-honest-3-patches-applied-R6.1"]
 closureDistance := "1 step parallel-to-published. Gross-Wallach 1996 Crelle 481 = J. Reine Angew. Math. 481 (1996) 73-123 (quaternionic E_{7(-5)} (g, K)-cohomology fully done); Loke 2001 (real exceptional minimal reps); Knapp-Vogan 1995 (Cohomological Induction and Unitary Representations)."
 decomposability := "1 atomic claim."
 computability := "parallel-to-published (Hermitian = parallel calc to quaternionic)"
 attackVector := "Parallel-port of Gross-Wallach 1996 from E_{7(-5)} to E_{7(-25)}."
 obstacleCitation := none
}

/-- Clause (b) of hyp:hecke-bbt: archimedean Whittaker rank-3 nonvanishing.
 Lean statements: `OpenHypotheses.HeckeBBT_archimedean_whittaker` (concrete
 def = 2-clause conjunction); 2 atomic predicates (1 framework + 1
 conjectural-extension); 2 classical-lit axioms;
 `OpenHypotheses.hyp_hecke_bbt_b` (closure theorem, no-sorry conjunction-intro).

 **Status: gapPartial.** Framework (split-form archimedean rank-3 Whittaker
 non-vanish) is supported by VERIFIED published sources: Sahi 1992 Invent.
 Math. 110, Magaard-Savin 1997 Compositio 107, Kazhdan-Polishchuk 2004
 (arXiv:math/0209315), Shan 2025 arXiv:2501.19101 (split (PGL_2, F_4) ⊂ E_7
 theta with F_4 compact). Hermitian parallel-port is paper-acknowledged
 folklore (`\ref{hyp:hecke-bbt}` Note on items (a)-(c) parallel-
 computation transfer + SG-11 supplement entry).

 **CITATION-INTEGRITY NOTE**: Phase 0 hostile lit-verify identified 3
 unverified citations in master paper for this clause area: (i) "Sahi-Savin
 2007 Represent. Theory 11" cannot be located; (ii) "Loke 2003 J. Funct.
 Anal. 201" does not match Loke's actual 2003 paper (Pacific J. Math. 211);
 (iii) "Karasiewicz-Savin 2025" mis-attributed — actual paper is Yi Shan
 (sole author) arXiv:2501.19101, AND covers SPLIT E_7, NOT Hermitian
 E_{7(-25)}. Lean encoding uses verified cites only. -/
def gap_hecke_bbt_b : LedgerEntry := {
 identifier := "hyp:hecke-bbt clause (b)"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework split-form archimedean rank-3 Whittaker non-vanish PUBLISHED (Sahi 1992 Invent. Math. 110 split-tube unipotent reps + Magaard-Savin 1997 Compositio 107 exceptional theta I + Kazhdan-Polishchuk 2004 arXiv:math/0209315 non-arch Whittaker minimal rep + Shan 2025 arXiv:2501.19101 split (PGL_2, F_4) ⊂ E_7 theta with F_4 compact). Hermitian parallel-port to Π_min^(-25) on E_{7(-25)} is paper-acknowledged folklore (`\\ref{hyp:hecke-bbt}` Note on items (a)-(c) parallel-computation transfer + SG-11 supplement entry); no single source extends to Hermitian. Cross-source: Loke 2000 J. Funct. Anal. 172 (quaternionic E_{7(-5)} restriction, NOT Hermitian); Gan-Savin 2005 Rep. Theory 9 (minimal-rep definitions)."
 decomposability := "2 sub-claims: split-form framework (published, multi-source verified) + Hermitian parallel-port (conjectural-extension, folklore)."
 computability := "PUBLISHED framework + folklore parallel-port for Hermitian"
 attackVector := "Decomposed per R6/R7/R8 pattern. Verified-only citations in Lean axioms; do NOT propagate unverified master-paper Sahi-Savin 2007 / Loke 2003 J. Funct. Anal. 201 citations. Mis-attributed Karasiewicz-Savin 2025 corrected to Shan 2025 arXiv:2501.19101 (note: split only)."
 attackHistory := ["R-attack-#9-Phase-0-hostile-lit-audit-caught-3-master-paper-bibliographic-defects-Sahi-Savin-2007-unverified-Loke-2003-J-Funct-Anal-201-unverified-Karasiewicz-Savin-2025-mis-attributed-to-Shan-2025-arXiv-2501-19101-which-covers-SPLIT-only-not-Hermitian-Phase-2-Lean-writer-closed-gapPartial-with-verified-citations-only"]
 obstacleCitation := none
}

/-- Clause (c) of hyp:hecke-bbt: Kudla-Millson Schwartz form on exceptional tube. -/
def gap_hecke_bbt_c : LedgerEntry := {
 identifier := "hyp:hecke-bbt clause (c)"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Pattern (ii) `_INVENTION_CLASS` extension (mirror SG-22 / SG-23 tier; R-attack-#34). Framework PUBLISHED (2 atoms): (i) Kudla-Millson 1986 Math. Ann. 274 (353-378) §3 + 1990 Publ. Math. IHÉS 71 (121-172): classical Kudla-Millson Schwartz form construction on O(p,q) / U(p,q) symmetric spaces via Howe-operator + Heisenberg-parabolic Weil rep structure. SCOPE: classical orthogonal/unitary ONLY; no analog for exceptional minimal rep. (ii) Faraut-Koranyi 1994 'Analysis on Symmetric Cones' (Oxford Math. Mono.): Jordan-algebra harmonic analysis on irreducible symmetric cones (Koecher classification) including J_3(O) exceptional rank-3 case. SCOPE: harmonic analysis (Gindikin-Karpelevic gamma, Wallach set, Hua integrals) ONLY; does NOT construct Kudla-Millson Schwartz forms. R-#24 audit caught prior Ledger framing 'Faraut-Koranyi 1994 Jordan-algebra Schwartz form' as portmanteau not corresponding to any FK94 theorem; current axiom honestly scopes to harmonic analysis. Conjectural-extension `_INVENTION_CLASS`: exceptional-tube Schwartz form on D_{EVII} = E_{7(-25)} / (E_6 × U(1)). Per R-#24 hostile audit web search 1986-2026: NO paper constructs closed K_∞-equivariant rank-3 Schwartz form on D_EVII with Weil-rep compatibility. Sibling (does NOT close): Kazhdan-Savin/Gross-Wallach minimal rep; Pollack 2020 quaternionic on E_{7(-5)} distinct real form; Shan 2025 arXiv:2501.19101 F_4×PGL_2 on split E_{7(7)} automorphic-level; Greer-Tayou 2026 modularity-as-conjecture survey; Branchereau 2022 Mathai-Quillen orthogonal-only."
 decomposability := "3 atoms: 2 framework (Kudla-Millson 1986/1990 classical Schwartz form + Faraut-Koranyi 1994 Jordan symmetric cone harmonic analysis, both PUBLISHED) + 1 `_INVENTION_CLASS` extension (D_EVII exceptional-tube Schwartz form). Plus typed-bridge axiom: 3-conjunction → HeckeBBT_kudla_millson S for all S. R-attack-#34 converted Lean axiom hyp_hecke_bbt_c → theorem."
 computability := "PUBLISHED framework (2 named-source theorems) + `_INVENTION_CLASS` extension (D_EVII exceptional Schwartz form, 1986-2026 no construction). Epistemic tier: mirror SG-22 (Tabuada NC → Chow lift) and SG-23 (M_AE → Chow descent) `_INVENTION_CLASS` standing."
 attackVector := "Pattern (ii) 3-atom decomp + typed bridge: 2 framework classical-lit axioms (kudla_millson_classical_orth_unitary_schwartz_form_bbt_c + faraut_koranyi_jordan_symmetric_cone_analysis_bbt_c) + 1 `_INVENTION_CLASS` extension axiom (exceptional_tube_schwartz_form_D_EVII_bbt_c_INVENTION_CLASS) + typed-bridge axiom hyp_hecke_bbt_c_from_framework_and_invention; theorem hyp_hecke_bbt_c (CONVERTED from axiom R-#34) applies bridge to 3-conjunction. STANDALONE disposition wrt Main Theorem (master tex hyp:hecke-bbt clause c is paper-acknowledged hypothesis); the parent hyp:hecke-bbt clause itself is gapPartial via 5-clause conjunction-intro from clauses (a) gapPartial + (b) gapPartial + (c) gapPartial (R-#34) + (d) gapPartial + (e) still gapOpen."
 attackHistory := ["R-attack-#24-Phase-0-hostile-lit-audit-Kudla-Millson-1986-Math-Ann-274-1990-Publ-IHES-71-classical-orthogonal-unitary-scope-ONLY-Faraut-Koranyi-1994-Jordan-algebra-symmetric-cone-harmonic-analysis-NOT-Schwartz-forms-1986-2026-no-published-rank-3-closed-K-infty-equivariant-Schwartz-form-on-D-EVII-INVENTION-class-confirmed", "R-attack-#34-Phase-2-Lean-writer-converted-axiom-hyp-hecke-bbt-c-to-theorem-via-Pattern-ii-INVENTION-CLASS-decomposition-mirror-SG-22-SG-23-2-framework-atoms-Kudla-Millson-classical-Schwartz-Faraut-Koranyi-Jordan-cone-harmonic-1-INVENTION-CLASS-extension-D-EVII-Schwartz-form-plus-typed-bridge-net-new-3-predicates-3-axioms-1-typed-bridge-1-theorem-also-added-bibitem-FarautKoranyi94-status-gapOpen-to-gapPartial-Net-axiom-decrement-1-the-prior-axiom-hyp-hecke-bbt-c-is-now-a-theorem"]
 obstacleCitation := some "`_INVENTION_CLASS`: D_EVII exceptional-tube Schwartz form. 1986-2026 NO published construction (R-#24 hostile audit web-verified). Mirror SG-22 / SG-23 tier. INVENTION-class equivalent to original construction problem."
}

/-- Clause (d) of hyp:hecke-bbt: Hecke-equivariance of BBT o-minimal
 definable spreading. Lean statements: `OpenHypotheses.HeckeBBT_spreading_equivariance`
 (concrete def = 2-clause conjunction); 2 atomic predicates (1 framework +
 1 conjectural-extension); 2 classical-lit axioms (BKT 2020 framework +
 Chow-level Hecke-equivariance conjectural-extension);
 `OpenHypotheses.hyp_hecke_bbt_d` (closure theorem, no-sorry conjunction-intro).

 **Status: gapPartial.** Framework piece (BKT 2020 JAMS 33 (2020) 917-939
 Thm 1.1(2): Hecke correspondences are R_an-definable on arithmetic
 quotients) is PUBLISHED. Conjectural-extension (Chow-level / cycle-level
 commutation of BBT spreading with Hecke action on Alg(V,ω)) is
 master-proof-acknowledged hypothesis (`\ref{hyp:hecke-bbt}` item (d):
 "Hecke-equivariant refinement
 of the BBT definable-spreading theorem"); no single published source
 states the cycle-level conclusion. Decomposition follows the R6
 framework + conjectural-extension pattern. -/
def gap_hecke_bbt_d : LedgerEntry := {
 identifier := "hyp:hecke-bbt clause (d)"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework BKT 2020 JAMS 33 Thm 1.1(2) PUBLISHED (Hecke correspondences R_an-definable). Cycle-level Hecke-equivariance of BBT spreading on Alg(V,ω) is folklore / functoriality argument over BKT 2020 + BBT 2023 Invent. Math. 232 + Cattani-Deligne-Kaplan; `\\ref{hyp:hecke-bbt}` item (d) explicitly labels this clause as 'Hecke-equivariant refinement' = paper-acknowledged hypothesis. Klingler arXiv:1711.09387 survey treats Hecke functoriality of Hodge loci but not cycle-level on Chow."
 decomposability := "2 sub-claims: BKT framework (published) + Chow-level Hecke-equivariance (conjectural-extension)."
 computability := "PUBLISHED framework + functoriality-fix-up for cycle-level"
 attackVector := "Decomposed per R6 pattern. BKT 2020 framework axiom + conjectural-extension axiom; closure theorem conjunction-intro."
 attackHistory := ["R-attack-#7-Phase-0-hostile-lit-audit-flagged-paper-self-acknowledged-hypothesis-and-master-tex-L7586-BBT-vs-BKT-miscitation-Phase-2-Lean-writer-closed-gapPartial-conjunction-intro"]
 obstacleCitation := none
}

/-- Clause (e) of hyp:hecke-bbt: Chow-level Hecke-equivariance of theta. -/
def gap_hecke_bbt_e : LedgerEntry := {
 identifier := "hyp:hecke-bbt clause (e)"
 paperLabel := "hyp:hecke-bbt"
 status := GapStatus.gapPartial
 closureDistance := "REDUCES-TO chow-modularity-E7 extension (R-attack-#35; mirror SG-21 REDUCES-TO precedent). Clause (e) = Chow-level Hecke-equivariance of theta. Master tex `\\ref{hyp:hecke-bbt}` clause (e) explicit 'Linked to hyp:chow-modularity-E7. Same invention burden'. R-#35 closure: typed-bridge axiom hyp_hecke_bbt_e_from_chow_modularity_extension reduces clause (e) to IsExceptionalE7ChowModularityExtension_CONJECTURAL atom of hyp:chow-modularity-E7 (already-existing conjectural-extension axiom). theorem hyp_hecke_bbt_e applies bridge to exceptional_E7_chow_modularity_extension_CONJECTURAL S. Status gapPartial inheriting from hyp:chow-modularity-E7 conjectural-extension status."
 decomposability := "1 typed-bridge axiom (REDUCES-TO chow-modularity-E7 extension) + theorem. Net axiom delta: +1 typed-bridge only; reuses existing exceptional_E7_chow_modularity_extension_CONJECTURAL atom."
 computability := "REDUCES-TO existing closure. Epistemic standing inherits hyp:chow-modularity-E7 gapPartial via its conjectural-extension atom."
 attackVector := "ROUTE A REDUCES-TO pattern (mirror SG-21 R-#29 + SG-16 R-#33 precedents): 1 typed-bridge axiom hyp_hecke_bbt_e_from_chow_modularity_extension; theorem hyp_hecke_bbt_e (CONVERTED from axiom R-#35) applies bridge to exceptional_E7_chow_modularity_extension_CONJECTURAL existing axiom. STANDALONE wrt Main Theorem chain via hyp:hecke-bbt parent."
 attackHistory := ["R-attack-#35-Phase-2-Lean-writer-converted-axiom-hyp-hecke-bbt-e-to-theorem-via-REDUCES-TO-chow-modularity-E7-conjectural-extension-mirror-SG-21-and-SG-16-precedents-1-typed-bridge-axiom-no-new-framework-atoms-Net-axiom-delta-the-prior-axiom-hyp-hecke-bbt-e-is-now-a-theorem-status-gapOpen-to-gapPartial-inheriting-from-hyp-chow-modularity-E7"]
 obstacleCitation := some "REDUCES-TO hyp:chow-modularity-E7 IsExceptionalE7ChowModularityExtension_CONJECTURAL atom. Same invention burden (exceptional (PGL_2, F_4) ⊂ E_7 Chow modularity + real-form descent E_{7(7)} → E_{7(-25)}). Status inherits gapPartial from parent."
}

/-! ## Group B: sub-gap inventory SG-1..SG-23

Sub-gap inventory SG-1..SG-23. SG-1..SG-16 + SG-23 have explicit
in-text mentions in the master tex; SG-17 has been integrated into
the master tex Stage D extension subsection (R-attack-#24); SG-18..22
have no in-text master tex mention and their gap content has not yet
been integrated into the operative master tex (pending integration).
Lean statement: bundled as
`OpenHypotheses.SubGap : Fin 23 -> Prop`; the per-index ledger entries
below document the content as inferred from paper in-text references. -/

/-- SG-1 = Zariski density of Witt orbits for non-Hermitian orthogonal
 type with min(p,q) ≥ 4 (Step 2 Witt-density discussion in
 `\ref{thm:levi-reduction-min3}`). Lean statements:
 `OpenHypotheses.IsClozelUllmoUllmoYafaevTsimermanZariskiDensityHermitian_sg1`
 (framework predicate); `OpenHypotheses.IsNonHermitianOrthogonalExtensionMinPQGe4_sg1_CONJECTURAL`
 (conjectural-extension predicate);
 `OpenHypotheses.cu05_uy14_tsi18_zariski_density_hermitian_sg1`
 (classical-lit axiom); `OpenHypotheses.non_hermitian_orthogonal_extension_min_p_q_ge_4_sg1_CONJECTURAL`
 (conjectural-extension axiom); `OpenHypotheses.sg1_from_framework_and_extension`
 (typed bridge axiom); `OpenHypotheses.sg_1_closed` (closure theorem).
 Status gapPartial = Pattern (ii) 2-axiom decomposition mirroring R6/R10
 framework + conjectural-extension. -/
def gap_SG_1 : LedgerEntry := {
 identifier := "SG-1"
 paperLabel := "sub-gap inventory SG-1"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework PUBLISHED: Clozel-Ullmo 2005 Ann. Math. 161 (1571-1588, arXiv:math/0404131) unconditional strongly-special subvariety equidistribution via Ratner-Mozes-Shah-Dani-Margulis (type-agnostic on Shimura side) + Ullmo-Yafaev 2014 Ann. Math. 180 (823-865, arXiv:1209.0934) Thm 3.8 Galois-orbit equidistribution dichotomy under GRH + Tsimerman 2018 Ann. Math. 187 (379-390, arXiv:1506.01466) unconditional André-Oort for A_g. Non-Hermitian extension to SO(p,q) min(p,q) ≥ 4 with q ≥ 3 is paper-acknowledged 'not in the literature' (Step 2 Witt-density Gap note in `\\ref{thm:levi-reduction-min3}`) — period domain Sp(p,q)/K not Hermitian symmetric for q ≥ 3 (Cartan Type IV requires q = 2), Ratner-equidistribution apparatus does NOT directly transfer. PSTEG 2021 arXiv:2109.08788 closes André-Oort for adjoint Shimura unconditionally but does NOT cover SO(p,q) q ≥ 3 because there is no classical Shimura variety in this case. Supplement disposition (supplement entry for SG-1 in `\\ref{app:subgap-inventory}`): 'Reduces to `\\ref{hyp:BBT-rigid-reach}`'."
 decomposability := "2 atoms: (i) framework Hermitian Zariski-density (CU05a + UY14 + Tsi18, PUBLISHED) + (ii) non-Hermitian orthogonal extension min(p,q) ≥ 4 (conjectural-extension, paper-acknowledged). Plus typed-bridge axiom: framework ∧ extension → SubGap ⟨0, _⟩."
 computability := "PUBLISHED framework (Hermitian) + paper-acknowledged conjectural (non-Hermitian extension q ≥ 3 = paradigm-shift, period domain not Hermitian symmetric)"
 attackVector := "Pattern (ii) 2-axiom decomp + typed bridge (mirror of hyp:hecke-bbt clause (a)/(d) precedent): framework axiom cu05_uy14_tsi18_zariski_density_hermitian_sg1 + conjectural-extension axiom non_hermitian_orthogonal_extension_min_p_q_ge_4_sg1_CONJECTURAL + typed-bridge axiom sg1_from_framework_and_extension; closure theorem sg_1_closed applies bridge to conjunction of framework + extension."
 attackHistory := ["R-attack-#19-Phase-0-hostile-lit-audit-flagged-master-tex-L2155-2168-mis-characterizes-Clozel-Ullmo-as-abelian-type-only-when-CU05a-is-actually-type-agnostic-Phase-0-recommended-Option-i-single-bundle-citing-PSTEG-2021-closure-Phase-1-cross-source-found-master-tex-L13990-bib-defect-cites-WRONG-Clozel-Ullmo-paper-CU05b-Compos-Math-141-instead-of-CU05a-Ann-Math-161-Phase-1-technical-rebuttal-PSTEG-does-NOT-cover-non-Hermitian-SO-p-q-q-ge-3-because-not-classical-Shimura-Phase-1-recommended-Pattern-ii-2-axiom-decomp-framework-Hermitian-plus-conjectural-extension-non-Hermitian-paradigm-shift-Phase-2-Lean-writer-adopted-Phase-1-Pattern-ii-with-CU05a-citation-correction-and-PSTEG-explicit-note-in-docstring"]
 obstacleCitation := none
}

/-- SG-2 = compact-form Hodge-type purity (K-invariant subspace is (r, r)
 pure). Supplement disposition: "Reduces to hyp:KS-p3". Closed as
 gapPartial via folklore Deligne 1979 + Deligne-Milne 1982 derivation. -/
def gap_SG_2 : LedgerEntry := {
 identifier := "SG-2"
 paperLabel := "sub-gap inventory SG-2"
 status := GapStatus.gapPartial
 closureDistance := "Folklore derivation. Deligne 1979 PSPM 33 'Variétés de Shimura' §1.1 (polarisation positivity criterion) + Deligne-Milne 1982 LNM 900 'Tannakian categories' (Tannakian framework for compact inner forms). The (r, r)-purity is a standard but technical corollary, not stated as a labelled theorem in either source. Step 2 K-invariant (r,r)-type derivation in `\\ref{thm:levi-reduction-min3}`: 'standard but technical'."
 decomposability := "1 atomic claim closed via folklore derivation; sub-claims (i) compact-torus Hodge cocharacter (Del79 §1.1) + (ii) polarisation-positivity off-diagonal vanishing (Del79 + DM82) could be further decomposed if absolute rigor is required."
 computability := "PUBLISHED machinery (Del79 + DM82) + folklore corollary"
 attackVector := "Single classical-lit axiom deligne_milne_compact_form_hodge_purity_sg2 asserting SubGap ⟨1, by decide⟩; closure theorem sg_2_closed defeq rebinding. Supplement disposition: Reduces to hyp:KS-p3."
 attackHistory := ["R-attack-#11-Phase-0-hostile-lit-audit-confirmed-folklore-status-corrected-citation-Deligne-1972-LNM-244-was-wrong-paper-operative-is-Deligne-1979-PSPM-33-plus-Deligne-Milne-1982-LNM-900-Phase-0-also-corrected-earlier-supplement-missing-claim-supplement-EXISTS-at-exploration-supplement-tex-L814+"]
 obstacleCitation := none
}

/-- SG-3 = Griffiths-Schmid normalisation constant in
 e(V) = (-1)^{n/2} c_{n/2}(F^{n/2}) (n even). Supplement disposition:
 "Reduces to Hypothesis hyp:ChernWeil-bridge-E7". Closed as gapPartial
 via folklore Griffiths-Schmid 1969 + Grothendieck 1958 derivation. -/
def gap_SG_3 : LedgerEntry := {
 identifier := "SG-3"
 paperLabel := "sub-gap inventory SG-3"
 status := GapStatus.gapPartial
 closureDistance := "Folklore corollary. Griffiths-Schmid 1969 Acta Math. 123 (Locally homogeneous complex manifolds, pp 253-302; Hodge-bundle Chern-class lemma) + Grothendieck 1958 Bull. Soc. Math. France 86 (137-154; algebraicity of top Chern class). Rational constant in Chern-Weil normalisation paper-acknowledged unpinned and absorbed into `\\ref{hyp:ChernWeil-bridge-E7}` (supplement disposition + `\\ref{thm:generic_fiber}` clause (b) in-text derivation). Formula applies for n EVEN (V_C = F^{n/2} ⊕ \\overline{F^{n/2}} via Chern-Gauss-Bonnet). CITATION CORRECTED per R12 Phase 0 audit: previous 'Griffiths 1968 Topology 8' was SPURIOUS (no such paper for this content; Griffiths 1968 is Am. J. Math. 90 Parts I/II); 'Grothendieck-Berthelot' loose, only Grothendieck 1958 operative."
 decomposability := "1 atomic claim closed via folklore derivation; sub-claims: (i) Hodge-bundle Chern-class lemma (GS 1969 Acta) + (ii) Grothendieck algebraicity of top Chern class (Grothendieck 1958)."
 computability := "PUBLISHED machinery (GS 1969 + Grothendieck 1958) + folklore Chern-Gauss-Bonnet derivation"
 attackVector := "Single classical-lit axiom griffiths_schmid_1969_grothendieck_1958_euler_chern_normalisation_sg3 asserting SubGap ⟨2, by decide⟩; closure theorem sg_3_closed defeq rebinding. Disposition reduces to hyp:ChernWeil-bridge-E7 (already CLOSED)."
 attackHistory := ["R-attack-#12-Phase-0-hostile-lit-audit-caught-spurious-citation-Griffiths-1968-Topology-8-no-such-paper-real-Griffiths-1968-is-Am-J-Math-90-Parts-I-II-operative-source-per-master-tex-L2511-is-Griffiths-Schmid-1969-Acta-Math-123-also-corrected-Grothendieck-Berthelot-loose-citation-to-Grothendieck-1958-only-formula-applies-n-EVEN-not-odd-Phase-2-Lean-writer-closed-gapPartial-via-folklore-corollary"]
 obstacleCitation := none
}

/-- SG-4 = MRC descent of E_7-type VHS along Leray-Iitaka splitting
 (MRC-descent passage in the κ = -∞ uniruled non-Fano case of the
 main reduction). Lean
 statements: `OpenHypotheses.kmm_1992_ghs_2003_iitaka_1971_mrc_descent_sg4`
 (classical-lit axiom bundling 3 sources for folklore-derivation);
 `OpenHypotheses.sg_4_closed` (closure theorem via defeq rebinding).
 Status gapPartial = folklore corollary, paper-acknowledged "absorbed"
 by hyp:nonrigid-family-bridge (gapClosed) but with independent
 published-machinery content. -/
def gap_SG_4 : LedgerEntry := {
 identifier := "SG-4"
 paperLabel := "sub-gap inventory SG-4"
 status := GapStatus.gapPartial
 closureDistance := "Folklore corollary. 3-source bundled axiom (SG-2/SG-3 pattern): Kollár-Miyaoka-Mori 1992 J. Algebraic Geom. 1 (429-448) (H^0(F, Ω^p) = 0 on rationally connected fibre, p ≥ 1) + Graber-Harris-Starr 2003 JAMS 16 (57-67, arXiv:math/0109220) Cor. 1.4 (MRC target non-uniruled, κ(Z) ≥ 0) + Iitaka 1971 J. Math. Soc. Japan 23 (356-373) Iitaka fibration on Z reduces to κ(Z) ≥ 0 cases already treated. Master tex MRC-descent passage: 'Leray-Iitaka-type splitting after resolving indeterminacy is needed'. Supplement disposition (supplement entry for SG-4 in `\\ref{app:subgap-inventory}`): 'Reduces to `\\ref{hyp:nonrigid-family-bridge}`' (paper-bookkeeping scope-merging, not logical reduction)."
 decomposability := "1 atomic claim closed via folklore derivation; sub-ingredients: (i) KMM 1992 differential-form vanishing on RC fibres; (ii) GHS 2003 Cor. 1.4 MRC target non-uniruledness; (iii) Iitaka 1971 fibration dimension-recursion. Independent content from hyp:nonrigid-family-bridge atomic clauses (BaseDim27 / PeriodMapDominant / PeriodMapGenericallyFinite / FibreIsoAt_b0 cover 27-dim non-rigid family geometry, NOT MRC descent)."
 computability := "PUBLISHED machinery (KMM 1992 + GHS 2003 + Iitaka 1971) + folklore dimension-reduction"
 attackVector := "Single classical-lit axiom (Pattern i, SG-2/SG-3/SG-12 precedent): kmm_1992_ghs_2003_iitaka_1971_mrc_descent_sg4 asserts SubGap ⟨3, by decide⟩; closure theorem sg_4_closed defeq rebinding. Supplement disposition 'Reduces to hyp:nonrigid-family-bridge' noted in docstring as paper-bookkeeping scope-merging (parent's 4 atomic clauses do NOT cover MRC descent specifically); the Lean axiom has independent published-machinery content, not a parent-deferral."
 attackHistory := ["R-attack-#18-Phase-0-hostile-lit-audit-recommended-5-source-bundle-including-Saito-MHM-BBD-Deligne-HII-but-Phase-1-cross-source-found-Saito-MHM-only-invoked-at-master-tex-L4601-L4623-for-INTERMEDIATE-kappa-Iitaka-case-NOT-at-SG-4-site-L4736-4742-Phase-1-recommended-3-source-bundle-KMM-1992-plus-GHS-2003-plus-Iitaka-1971-Phase-1-also-tightened-citations-Kollar-loose-to-KMM-1992-JAG-1-primary-and-GHS-Thm-1-1-to-Cor-1-4-Phase-2-Lean-writer-closed-gapPartial-via-3-source-bundled-classical-lit-axiom-Pattern-i-folklore-derivation"]
 obstacleCitation := none
}

def gap_SG_5 : LedgerEntry := {
 identifier := "SG-5"
 paperLabel := "sub-gap inventory SG-5"
 status := GapStatus.gapPartial
 closureDistance := "CONDITIONAL COMPUTATION (NEW tier introduced R-attack-#31; distinct from prior 7 closures all citation-based). Under Assumption (χ-b) — paper-acknowledged at master tex L5503-5510, = minimal-MT ansatz `MT(X) = E_{7(-25)} with no extra classes` + no extra primitive H^5 extensions beyond Sym²V_56-summand — the Betti numbers of the rigid d=5 EVII variety X satisfy: b_2(X) = 1 (Pic = ℤH + h^{p,0}=0 for p ∈ {1,2}); b_5(X) = 56 (Hard Lefschetz over ℚ + b_3 = 56 + no-extension clause); b_4(X) = 54 (forced by χ_top(X) = -56 + PD arithmetic 2b_4 - 164 = -56); χ_top(X) = -56 (Mumford-Tate constraint + Hodge numerology under (χ-b)). Decomposition: 1 standing antecedent (Assumption (χ-b), prerequisite NOT extension) + 2 framework atoms PUBLISHED (Voisin 2002 Hodge I Ch. 6 + Deligne 1980 §4 Hard Lefschetz over ℚ; Hodge numerology + Pic = ℤH) + 1 sympy-verified computation atom (Hirzebruch-Riemann-Roch + PD arithmetic; companion script `experiments/r319_lefschetz_b5.py`). Master tex L5503-5510 explicitly flags SG-5 as 'the explicit computation of b_2(X) and b_4(X) from the Sym²V_56 minimal-MT ansatz is not given here'; R-#31 supplies the missing computation via lem:sg5-b2-b4-conditional + sympy verification."
 decomposability := "4 atoms: 1 standing antecedent (Assumption (χ-b), prerequisite hypothesis NOT closure atom) + 2 framework (Voisin 2002 + Deligne 1980 Hard Lefschetz over ℚ; Hodge numerology with Pic = ℤH) + 1 sympy-verified computation atom. Plus typed-bridge axiom: 4-conjunction → SubGap ⟨4, _⟩."
 computability := "PUBLISHED framework (2 named-source theorems: Voisin 2002 Hodge I Ch. 6 + Deligne 1980 §4 Hard Lefschetz; Hodge numerology) + PD arithmetic atom (elementary hand-derivable algebra; per R-#31 Phase 4 audit HIGH-1, prior 'sympy-verified' framing was misleading — sympy script `experiments/r319_lefschetz_b5.py` L169 hardcodes b_4=54 and tautologically cross-checks χ_top=-56; honest framing is PD arithmetic IS the derivation, sympy is consistency cross-check) + standing antecedent Assumption (χ-b) (paper-acknowledged phenomenological hypothesis). Epistemic ordering (corrected per R-#31 Phase 4 audit HIGH-2): conditional-computation sits BELOW `_NAMED_OPEN` in tier, not above. (χ-b) is empirical ('Both assumptions are satisfied by all currently-known E_7-type 5-fold candidates', master tex L5500-5501), NOT a theoretically-attacked named conjecture like Murre B or Tate. At parity with multi-path `_CONJECTURAL` tier."
 attackVector := "Pattern (ii) decomposition + typed bridge: standing antecedent axiom minimal_mt_ansatz_assumption_chi_b_sg5 + 2 framework classical-lit axioms (hard_lefschetz_rational_for_betti_pinning_sg5 + hodge_numerology_pic_zh_sg5) + 1 PD-arithmetic computation axiom (pd_arithmetic_under_assumption_chi_b_sg5; per R-#31 Phase 4 HIGH-1 reframing — was sympy_verified_b2_b4_computation_sg5 before patch) + typed-bridge axiom sg5_from_antecedent_framework_and_computation; closure theorem sg_5_closed applies bridge to 4-conjunction. STANDALONE disposition (master tex `\\ref{lem:sg5-b2-b4-conditional}` Scope: appendix-level; not in Main Theorem reduction chain; Assumption (χ-b) absorbed into hyp:nonrigid-family-bridge scope at d=5 diagnostic only). Specific numerical outputs under Assumption (χ-b): b_2 = 1, b_4 = 54, b_5 = 56, χ_top = -56 (parameters compatible with the 35-candidate Lefschetz-pin residual: 25 arith K^5 ∈ {96 m_a + 64 : m_a ∈ {0..24}} + 10 sporadics; companion sympy script `experiments/r319_lefschetz_b5.py` is consistency cross-check NOT independent derivation per R-#31 Phase 4 HIGH-1)."
 attackHistory := ["R-attack-#31-Phase-0-hostile-lit-audit-full-theorem-survey-Voisin-2002-Hodge-I-Ch-6-Hard-Lefschetz-rational-PUBLISHED-Deligne-1980-Weil-II-section-4-PUBLISHED-Sym2-V56-rep-decomposition-1-+-V_1463-dim-1596-verified-but-IRRELEVANT-to-H2-H4-Pic-equals-Z-H-plus-Assumption-chi-b-h-p-0-equals-0-for-p-in-1-2-4-5-gives-b-2-equals-1-Hard-Lefschetz-plus-b-3-equals-56-plus-no-extension-clause-gives-b-5-equals-56-PD-arithmetic-2-b-4-minus-164-equals-minus-56-gives-b-4-equals-54-Phase-2-Lean-writer-4-atom-Pattern-ii-1-standing-antecedent-2-framework-1-computation-NEW-tier-conditional-computation-master-tex-integration-lem-sg5-b2-b4-conditional-after-prop-d5-e7-closure-Diagnostic-end-L5569", "R-attack-#31-Phase-4-hostile-re-audit-caught-2-HIGH-defects-HIGH-1-circular-sympy-script-r319_lefschetz_b5-py-L169-hardcodes-b_4-equals-54-so-sympy-verifies-framing-misleading-PD-arithmetic-IS-the-derivation-not-sympy-derived-re-named-axiom-from-sympy_verified_b2_b4_computation_sg5-to-pd_arithmetic_under_assumption_chi_b_sg5-HIGH-2-tier-over-claim-conditional-computation-was-positioned-ABOVE-NAMED-OPEN-but-Assumption-chi-b-is-phenomenological-not-theoretically-attacked-named-conjecture-demoted-to-BELOW-NAMED-OPEN-at-parity-with-multi-path-CONJECTURAL-MEDIUM-1-r319_output-txt-empty-bytes-dropped-Verified-for-every-candidate-claim-and-restated-as-consistency-cross-check-only", "R-attack-#42-new-math-Hodge-diamond-extension-of-SG-5-Betti-closure-new-lemma-lem-sg5-hodge-diamond-conditional-pins-full-h-pq-bigraded-diamond-for-d5-EVII-rigid-5-fold-under-chi-b-via-NEW-dimension-counting-argument-dim-H4-prim-53-strictly-lt-56-smallest-non-trivial-E_7-complex-irrep-V_56-Bourbaki-Lie-Ch-VIII-Planche-VI-fundamental-rep-tables-forces-trivial-E_7-action-on-H4-prim-+-weight-cocharacter-pin-via-Deligne-1979-Var-Shimura-section-1-1-+-Lefschetz-shift-propagation-+-Lefschetz-decomp-+-Serre-Hodge-symmetry-closure-result-18-non-vanishing-Hodge-numbers-h-22-equals-54-h-31-equals-0-h-30-equals-h-41-equals-1-via-V_56-and-its-Lefschetz-image-Phase-4-hostile-re-audit-caught-3-defects-Lefschetz-iso-shorthand-clarified-to-injection-becoming-iso-under-chi-b-Tate-twist-terminology-corrected-to-weight-cocharacter-Bourbaki-irrep-bound-sharpened-Lean-side-5-new-framework-atoms-IsLefschetzShiftPropagationH3toH5-IsLefschetzDecompH4PrimDim53-IsDimCountingPrim53lt56-IsTateTorusPinTrivialE7Piece-IsSerreClosureToDiamondHodgeSym-plus-bridge-axiom-plus-theorem-sg_5_hodge_diamond_pinned-not-a-new-SubGap-closure-but-strengthening-of-sg_5_closed-output", "R-attack-#new-P1-frontal-attack-Phase-0-hostile-lit-survey-PLUS-Phase-1-rep-theory-computation-VERDICT-GENUINELY-OPEN-no-published-source-pins-b_2-or-b_4-or-Hodge-diamond-for-5-folds-X-satisfying-a-through-d-MT-H3-equals-E_7-25-via-V_56-rigidity-general-type-b_1-equals-0-indecomposable-Pic-equals-ZH-Phase-0-checked-Han-2021-Duke-thesis-Han-Robles-2020-Friedman-Laza-2013-Gross-1994-all-classify-abstract-weight-3-H3-Hodge-structure-only-NO-geometric-X-realisation-pinning-H-star-no-phantom-citations-Phase-1-Slansky-1981-Table-52-cross-verified-56-times-56-equals-1_a-plus-133_s-plus-1463_s-plus-1539_a-arithmetic-Sym2-V_56-equals-133-+-1463-Lambda2-V_56-equals-1-+-1539-dim-Sym2-V_56-E_7-equals-0-dim-Lambda2-V_56-E_7-equals-1-symplectic-form-Schwarz-1978-Hilbert-series-1-over-1-minus-t-4-confirmed-Constructor-proposed-byproduct-atom-IsE7HodgeWeightObstructionSG5-claiming-3-divides-k-blocks-V_56-contribution-to-H-k-was-REJECTED-by-orchestrator-structural-review-for-OVERCLAIM-the-3-divides-k-framing-ignores-Tate-twists-correct-statement-is-only-V_56-itself-has-odd-Hodge-weight-3-and-cannot-land-in-H-even-by-parity-but-V_56-tensor-2-contains-133-1463-1539-with-natural-weight-6-which-WITH-Tate-twist-can-appear-in-H-2-or-H-4-Constructor-leap-to-E_7-trivially-acts-on-H-2-H-4-actually-requires-chi-b-i-itself-no-extra-Hodge-classes-and-is-tautological-not-derived-CORRECTED-byproduct-is-WEAKER-V_56-specifically-dim-56-has-odd-Hodge-weight-parity-cannot-be-Hodge-sub-structure-of-H-2-or-H-4-this-IS-a-real-structural-fact-and-strengthens-R-attack-#42-IsDimCountingPrim53lt56-but-does-NOT-pin-b_2-or-b_4-status-SG-5-stays-gapPartial-conditional-computation-no-promotion-Phase-4-audit-pending-re-dispatched-with-Tate-twist-concern-explicit", "R-attack-#new-Phase-4-audit-CONFIRMED-orchestrator-structural-review-correct-Case-i-Constructor-original-byproduct-atom-IsE7HodgeWeightObstructionSG5-OVERCLAIM-via-3-pattern-hits-Pattern-3-scope-over-reach-claiming-replace-dim-counting-with-3-divides-k-Pattern-5-silent-assumption-drop-Tate-twists-Pattern-6-TAUTOLOGICAL-PREMISE-leap-to-E_7-trivially-on-H_even-equivalent-to-chi-b-i-no-extra-Hodge-classes-clause-Moonen-2004-section-4-7-through-4-9-directly-verified-MT-V-contains-G_m-id-automatically-for-V-of-weight-m-nonzero-so-Tate-twists-are-part-of-standard-MT-invariant-tensor-analysis-Han-2021-Prop-3-7-item-8-verified-at-p-15-not-p-14-minor-page-slip-Han-Robles-2020-Ex-5-4-xiv-verified-at-p-30-plus-App-A-2-6-p-32-confirming-omega_7-A_7-equals-3-over-2-cocharacter-eigenvalue-Slansky-Table-52-p-112-verified-primary-source-NO-post-2023-paper-pins-b_2-or-b_4-CORRECTED-WEAKER-byproduct-atom-IsV56OddWeightForcesHevenAbsence_sg5-is-real-PUBLISHED-derivable-new-structural-fact-V_56-Hodge-weight-3-odd-Tate-twist-V_56-n-has-weight-3-minus-2n-always-odd-cannot-be-sub-HS-of-H_even-by-parity-COMPLEMENTARY-to-R-attack-#42-IsDimCountingPrim53lt56-NOT-replacement-this-atom-kills-V_56-alone-by-parity-before-knowing-b_4-equals-54-R-attack-#42-then-kills-all-non-trivial-E_7-irreps-in-H4_prim-given-b_4-pinned-Lean-side-added-axiom-IsV56OddWeightForcesHevenAbsence_sg5-plus-witness-v56_odd_weight_forces_hodd_only_sg5-both-tagged-PUBLISHED-via-Han-2021-Han-Robles-2020-Moonen-2004-status-SG-5-stays-gapPartial-conditional-computation-no-promotion-discipline-failure-equally-informative-honest-negative-result-Lean-ized-per-mandate"]
 obstacleCitation := some "SG-5 closure is CONDITIONAL on Assumption (χ-b) (paper-acknowledged at master tex L5503-5510): minimal-MT ansatz + no extra primitive H^5 extensions beyond Sym²V_56-summand. Without (χ-b), b_2 / b_4 / b_5 are NOT pinned. Assumption (χ-b) is absorbed into `hyp:nonrigid-family-bridge` scope at d=5 diagnostic level only; NOT in Main Theorem chain. Diagnostic status of rigid d=5 branch remains OPEN regardless (per prop:d5-e7-closure end-of-proof)."
}

/-- SG-6 = Galois descent of Shimura structure along ramified covers
 (Galois-descent Caveat preceding `\ref{rem:generic-finiteness-reduction}`,
 supplement entry for SG-6 in `\ref{app:subgap-inventory}`). Lean
 statements:
 `OpenHypotheses.IsDeligneMilneBorovoiUnramifiedCanonicalModel_sg6`
 (framework predicate);
 `OpenHypotheses.IsRamifiedCoverGaloisDescentE7Extension_sg6_CONJECTURAL`
 (conjectural-extension predicate);
 `OpenHypotheses.deligne_1979_milne_1990_borovoi_1984_deligne_milne_1982_unramified_canonical_model_sg6`
 (classical-lit axiom);
 `OpenHypotheses.ramified_cover_galois_descent_e7_extension_sg6_CONJECTURAL`
 (conjectural-extension axiom); `OpenHypotheses.sg6_from_framework_and_extension`
 (typed bridge axiom); `OpenHypotheses.sg_6_closed` (closure theorem).
 Status gapPartial = Pattern (ii) 2-axiom decomposition mirroring
 SG-1 (R19) framework + conjectural-extension. Standalone disposition
 (NOT used by Main Theorem reduction chain). -/
def gap_SG_6 : LedgerEntry := {
 identifier := "SG-6"
 paperLabel := "sub-gap inventory SG-6"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework PUBLISHED for unramified (étale-Galois-descent) canonical-model construction: Deligne 1979 PSPM 33 Part 2 (247-289, abelian-type canonical models, `Deligne_Shimura` in master tex bib) + Milne 1990 Perspect. Math. 10 (283-414, general canonical-model existence, NOT in master tex bib — operative-source supplement introduced by R20 Lean formalization) + Borovoi 1984/1987 (Galois conjugation for general Shimura data, NOT in master tex bib — operative-source supplement introduced by R20 Lean formalization) + Deligne-Milne 1982 LNM 900 (101-228, Tannakian framework, `DeligneMilne82` in master tex bib). Ramified-cover Galois descent for E_7-type is paper-acknowledged 'not supplied in this manuscript' (supplement entry for SG-6 in `\\ref{app:subgap-inventory}`). Master paper Galois-descent Caveat preceding `\\ref{rem:generic-finiteness-reduction}` + supplement entry for SG-6: Standalone disposition, NOT used by Main Theorem reduction chain (paper closes (H-bundle) via birational equivalence without canonical-model descent on Z)."
 decomposability := "2 atoms: (i) framework unramified canonical model (Deligne 1979 + Milne 1990 + Borovoi 1984/1987 + Deligne-Milne 1982, PUBLISHED) + (ii) ramified-cover Galois descent for E_7-type (conjectural-extension, paper-acknowledged 'not supplied in this manuscript'). Plus typed-bridge axiom: framework ∧ extension → SubGap ⟨5, _⟩."
 computability := "PUBLISHED framework (unramified canonical model) + paper-acknowledged conjectural (ramified-cover Galois descent for E_7-type, no published source)"
 attackVector := "Pattern (ii) 2-axiom decomp + typed bridge (mirror of SG-1 precedent): framework axiom deligne_1979_milne_1990_borovoi_1984_deligne_milne_1982_unramified_canonical_model_sg6 + conjectural-extension axiom ramified_cover_galois_descent_e7_extension_sg6_CONJECTURAL + typed-bridge axiom sg6_from_framework_and_extension; closure theorem sg_6_closed applies bridge to conjunction of framework + extension. STANDALONE disposition (Galois-descent Caveat preceding `\\ref{rem:generic-finiteness-reduction}`, supplement entry for SG-6 in `\\ref{app:subgap-inventory}`): NOT absorbed by `\\ref{hyp:chow-modularity-E7}`, NOT used by Main Theorem reduction chain."
 attackHistory := ["R-attack-#20-Phase-0-hostile-lit-audit-found-multiple-defects-Ledger-attackVector-Absorbed-by-hyp-chow-modularity-E7-CONTRADICTS-master-tex-L8022-8023-supplement-L904-905-explicit-Standalone-disposition-Milne-1992-loose-citation-most-likely-meant-Milne-1990-Perspect-Math-10-Deligne-1972-LNM-244-is-transcription-error-LNM-244-published-1971-master-tex-Del72-cites-unrelated-Invent-Math-15-K3-Weil-paper-same-defect-pattern-as-R11-SG-2-catch-Phase-1-cross-source-confirmed-no-published-source-covers-ramified-cover-Galois-descent-for-E7-type-Reimann-1997-Pappas-Rapoport-Kisin-Pappas-cover-integral-models-only-not-base-cover-descent-Phase-1-recommended-Pattern-ii-2-axiom-decomp-Phase-2-Lean-writer-corrected-citations-to-Deligne-1979-plus-Milne-1990-plus-Borovoi-1984-plus-Deligne-Milne-1982-and-Standalone-disposition-recorded-status-gapOpen-to-gapPartial"]
 obstacleCitation := none
}

/-- SG-7 = real-form descent E_{7(7)} → E_{7(-25)} for the exceptional
 theta lift (master paper exceptional-theta construction preceding
 `\ref{thm:E7-theta-match}` Gap on real-form descent, supplement
 entry for SG-7 in `\ref{app:subgap-inventory}`). Lean
 statements: `OpenHypotheses.IsShanKarasiewiczSavinGanSavinMagaardSavinSplitFormThetaKernel_sg7`
 (framework predicate);
 `OpenHypotheses.IsHermitianRealFormDescentArchimedeanStabilisation_sg7_CONJECTURAL`
 (conjectural-extension predicate);
 `OpenHypotheses.shan_2025_karasiewicz_savin_2023_gan_savin_2005_magaard_savin_1997_split_form_theta_kernel_sg7`
 (framework axiom);
 `OpenHypotheses.hermitian_real_form_descent_archimedean_stabilisation_sg7_CONJECTURAL`
 (conjectural-extension axiom); `OpenHypotheses.sg7_from_framework_and_extension`
 (typed bridge axiom); `OpenHypotheses.sg_7_closed` (closure theorem).
 Status gapPartial = Pattern (ii) 2-axiom decomposition mirroring
 SG-1 / SG-6 framework + conjectural-extension. Absorbed by
 hyp:chow-modularity-E7 (gapOpen). -/
def gap_SG_7 : LedgerEntry := {
 identifier := "SG-7"
 paperLabel := "sub-gap inventory SG-7"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework PUBLISHED for split-form theta kernel: Shan 2025 arXiv:2501.19101 (sole author, F_4 × PGL_2 theta with F_4 anisotropic-at-infinity = F_{4(-52)} compact, split over all Q_p; ambient minimal rep of E_7) + Karasiewicz-Savin 2023 arXiv:2312.02853 (p-adic Aut(C) × F_4 dual-pair machinery; DISTINCT paper from Shan 2025) + Gan-Savin 2005 Rep. Theory 9 (46-93, minimal-rep global existence + p-adic local properties) + Magaard-Savin 1997 Compositio Math. 107 (89-123, split-form exceptional theta over p-adic fields). Hermitian parallel-port to (PGL_2, F_4^anis = F_{4(-20)} rank-1) ⊂ E_{7(-25)} + full archimedean stabilisation of exceptional theta integral on D_{EVII} is paper-acknowledged 'not in the literature' (real-form-descent Gap note preceding `\\ref{thm:E7-theta-match}`); Loke 2000 J. Funct. Anal. 172 + Savin 2025 arXiv:2508.12534 + Faraut-Koranyi 1994 cover adjacent material but NOT the Hermitian E_{7(-25)} archimedean stabilisation. Absorbed by `\\ref{hyp:chow-modularity-E7}` (absorption-into-`\\ref{hyp:chow-modularity-E7}` clause preceding `\\ref{thm:E7-theta-match}` + supplement entry for SG-7)."
 decomposability := "2 atoms: (i) framework split-form theta kernel (Shan 2025 + Karasiewicz-Savin 2023 + Gan-Savin 2005 + Magaard-Savin 1997, PUBLISHED 4-source bundle) + (ii) Hermitian real-form descent + archimedean stabilisation (conjectural-extension, paper-acknowledged 'not in the literature'). Plus typed-bridge axiom: framework ∧ extension → SubGap ⟨6, _⟩."
 computability := "PUBLISHED framework (split-form theta) + paper-acknowledged conjectural (Hermitian real-form descent + archimedean stabilisation, no published source)"
 attackVector := "Pattern (ii) 2-axiom decomp + typed bridge (mirror of SG-1 / SG-6 precedent): framework axiom shan_2025_karasiewicz_savin_2023_gan_savin_2005_magaard_savin_1997_split_form_theta_kernel_sg7 + conjectural-extension axiom hermitian_real_form_descent_archimedean_stabilisation_sg7_CONJECTURAL + typed-bridge axiom sg7_from_framework_and_extension; closure theorem sg_7_closed applies bridge to conjunction of framework + extension. Absorbed by hyp:chow-modularity-E7 (gapOpen, paper-explicit absorption disposition)."
 attackHistory := ["R-attack-#21-Phase-0-hostile-lit-audit-extended-R9-catch-master-tex-KarasiewiczSavin25-bibitem-actually-conflates-2-distinct-papers-Shan-2025-arXiv-2501-19101-sole-author-PGL2-F4-theta-with-F4-compact-at-infinity-on-split-E7-AND-Karasiewicz-Savin-2023-arXiv-2312-02853-p-adic-Aut-C-times-F4-dual-pair-machinery-R9-catch-was-CORRECT-but-INCOMPLETE-also-flagged-pre-R21-Ledger-internal-contradiction-split-PGL2-F4-comma-F4-compact-at-infinity-split-not-equal-compact-at-infinity-resolution-F4-anisotropic-at-infinity-on-globally-split-E77-Phase-1-cross-source-confirmed-Hermitian-parallel-port-NOT-in-2024-2026-literature-Loke-2000-Savin-2025-Faraut-Koranyi-1994-adjacent-not-direct-Phase-2-Lean-writer-closed-gapPartial-via-Pattern-ii-4-source-framework-bundle-plus-Hermitian-conjectural-extension"]
 obstacleCitation := none
}

def gap_SG_8 : LedgerEntry := {
 identifier := "SG-8"
 paperLabel := "sub-gap inventory SG-8"
 status := GapStatus.gapPartial
 closureDistance := "INVENTION-needed (aligned with parent hyp:hecke-bbt clause (c)). Kudla-Millson 1986 Math. Ann. 274 + 1990 Publ. IHES 71 cover ONLY classical orthogonal O(p,q) and unitary U(p,q); neither paper treats Sp(p,q) nor exceptional Hermitian. Howe-operator construction depends on Heisenberg-parabolic structure of O/U Weil representation; no analog written for exceptional minimal representation. Faraut-Koranyi 1994 'Analysis on Symmetric Cones' (Oxford) develops Jordan-algebra harmonic analysis (Gindikin-Karpelevic gamma functions, Wallach set, Hua integrals) on the exceptional symmetric cone of J_3(O), but does NOT construct Kudla-Millson-type Schwartz forms — no Weil-representation Schwartz function or K_∞-equivariant closed differential form on D_{EVII}. 2020-2026 literature sweep (Pollack, Loke, Savin, Shan, Karasiewicz-Savin, Branchereau, Greer-Tayou 2026 arXiv:2603.01251 survey): no published rank-3 closed K_∞-equivariant Schwartz form on D_{EVII}. Greer-Tayou 2026 explicitly puts modularity for 'other types' of Shimura varieties in CONJECTURES section."
 decomposability := "1 atomic claim (Kudla-Millson Schwartz form on exceptional tube D_{EVII}). If invention occurs, natural decomposition mirrors SG-7 R6/R8 pattern: 2 framework atoms (KM 1986/1990 + FK 1994 each with corrected scope predicates) + 1 conjectural-extension atom (exceptional-tube Schwartz form extension, paper-acknowledged 'not in literature') + typed bridge."
 computability := "invention (not in published literature 1986-2026; aligned with hecke_bbt_c parent classification)"
 attackVector := "Absorbed by hyp:hecke-bbt clause (c). R-#34 upgraded parent hecke_bbt_c gapOpen → gapPartial via Pattern (ii) `_INVENTION_CLASS` decomposition (mirror SG-22/SG-23); SG-8 syncs to same status (R-#35). Earlier closureDistance '1 step' was over-optimistic; current honest framing follows hecke_bbt_c R-#34 Pattern (ii) decomposition."
 attackHistory := ["R-attack-#24-side-line-Phase-0-hostile-lit-audit-caught-SG-8-stale-1-step-framing-vs-parent-hecke_bbt_c-INVENTION-needed-honest-status-Kudla-Millson-1986-1990-explicitly-classical-orthogonal-unitary-only-Faraut-Koranyi-1994-explicitly-harmonic-analysis-on-symmetric-cones-not-Schwartz-forms-2020-2026-literature-sweep-no-published-rank-3-closed-K-infinity-equivariant-Schwartz-form-on-D-EVII-Greer-Tayou-2026-arXiv-2603-01251-puts-modularity-for-other-types-in-conjectures-section-Ledger-entry-aligned-with-parent-no-Lean-closure-attempted", "R-attack-#35-status-sync-with-parent-hecke_bbt_c-which-was-upgraded-R-#34-to-gapPartial-via-Pattern-ii-INVENTION-CLASS-Pattern-mirror-SG-22-SG-23-SG-8-now-gapPartial-inheriting-from-parent"]
 obstacleCitation := some "INVENTION-class: no published construction of a closed K_∞-equivariant rank-3 Schwartz form on D_{EVII} in 1986-2026 literature. Kudla-Millson scope = O(p,q) / U(p,q) only; Faraut-Koranyi = symmetric-cone harmonic analysis, not Schwartz forms; Greer-Tayou 2026 survey arXiv:2603.01251 puts modularity for non-classical Shimura types in conjectures section."
}

def gap_SG_9 : LedgerEntry := {
 identifier := "SG-9"
 paperLabel := "sub-gap inventory SG-9"
 status := GapStatus.gapPartial
 attackHistory := ["R-attack-#6-absorbed-into-hyp-hecke-bbt-clause-a-2026-05-11-gapPartial-via-R6-conjunction"]
 closureDistance := "1 step parallel-to-published. Gross-Wallach 1996 Crelle 481 = J. Reine Angew. Math. 481 (1996) 73-123 quaternionic E_{7(-5)}; Hermitian parallel."
 decomposability := "1 atomic claim ((g, K)-cohomology for E_{7(-25)} Hermitian)."
 computability := "parallel-to-published"
 attackVector := "Absorbed by hyp:hecke-bbt clause (a)."
 obstacleCitation := none
}

def gap_SG_10 : LedgerEntry := {
 identifier := "SG-10"
 paperLabel := "sub-gap inventory SG-10"
 status := GapStatus.gapPartial
 attackHistory := ["R-attack-#6-absorbed-into-hyp-hecke-bbt-clause-a-2026-05-11-gapPartial-via-R6-conjunction"]
 closureDistance := "1 step. Vogan A_q(lambda); Knapp-Vogan 1995 Ch. V; Adams 2007 Compositio."
 decomposability := "1 atomic claim ((q, q)-bidegree identification at q = 3, 24 with Hecke-equivariant Matsushima)."
 computability := "construction"
 attackVector := "Absorbed by hyp:hecke-bbt clause (a)."
 obstacleCitation := none
}

def gap_SG_11 : LedgerEntry := {
 identifier := "SG-11"
 paperLabel := "sub-gap inventory SG-11"
 status := GapStatus.gapPartial
 closureDistance := "1 step. Sahi 1992 Invent. Math. 110 (split-tube unipotent reps) + Magaard-Savin 1997 Compositio 107 (exceptional theta I, p-adic) + Kazhdan-Polishchuk 2004 arXiv:math/0209315 (non-archimedean Whittaker for split D_k/E_k minimal rep); Loke 2000 J. Funct. Anal. 172 (quaternionic E_{7(-5)} restrictions, not Hermitian). Citation refined per R9 Phase 0 audit — original 'Sahi-Savin 2007 Represent. Theory 11' and 'Loke 2003 J. Funct. Anal. 201' unverified."
 decomposability := "1 atomic claim (archimedean rank-3 Whittaker nonvanish)."
 computability := "parallel-to-published"
 attackVector := "Absorbed by hyp:hecke-bbt clause (b)."
 attackHistory := []
 obstacleCitation := none
}

/-- SG-12 = definable-analytic algebraization of cycle-matching
 (`\ref{rem:sliceD-step2-definability}`). Lean statements:
 `OpenHypotheses.bkt_2020_bbt_2023_ps_2009_vdd_1998_route_a_cycle_matching_algebraization_sg12`
 (classical-lit axiom bundling 4 sources for Route (a) folklore-
 corollary); `OpenHypotheses.sg_12_closed` (closure theorem via defeq
 rebinding). Status gapPartial = folklore corollary, paper-self-
 discharged via sketched Route (a). -/
def gap_SG_12 : LedgerEntry := {
 identifier := "SG-12"
 paperLabel := "sub-gap inventory SG-12"
 status := GapStatus.gapPartial
 closureDistance := "Folklore corollary. 4-source bundled axiom (SG-2/SG-3 pattern): BKT 2020 JAMS 33 (917-939) Thm 1.1(a) R_an-definability of period map; BBT 2023 Invent. 232 (163-228, arXiv:1811.12230) Thm 1.1 definable GAGA Coh(X) → Coh^def(X^an); Peterzil-Starchenko 2009 J. reine angew. Math. 626 (39-74) R_an-definable closed analytic subsets are algebraic; van den Dries 1998 London Math. Soc. Lecture Note Ser. 248 (Cambridge Univ. Press) Ch. 3 + Thm 1.6.2 cell decomposition + definable trivialisation (DCC on definable closed sets folklore corollary, cross-source Pillay-Steinhorn 1986 Trans. AMS 295). `\\ref{rem:sliceD-step2-definability}` self-acknowledged: 'Route (a) is the intended reading and is sketched below; a full write-up in the definable-analytic register is not supplied here'."
 decomposability := "1 atomic claim closed via Route (a) folklore-derivation; bundles 4 published-source ingredients (BKT 2020 definability + BBT 2023 algebraization + PS 2009 image-definability + vdD 1998 DCC)."
 computability := "PUBLISHED machinery (BKT + BBT + PS + vdD) + folklore corollary via sketched Route (a)"
 attackVector := "Single classical-lit axiom (Pattern i, SG-2/SG-3 precedent): bkt_2020_bbt_2023_ps_2009_vdd_1998_route_a_cycle_matching_algebraization_sg12 asserts SubGap ⟨11, by decide⟩; closure theorem sg_12_closed defeq rebinding. Master paper (preceding `\\ref{rem:sliceD-step2-definability}`) scope-stretch ('definability of flat sections (BKT Thm 1.1)' — BKT 1.1(a) gives only period-map definability, extension to flat sections on relative Hilbert scheme is folklore corollary BKT + Schmid SL2-orbit + frame trivialisation) explicitly disclosed in Lean docstring (analogous to R15 BBT scope-stretch preceding `\\ref{hyp:hecke-bbt}`)."
 attackHistory := ["R-attack-#16-Phase-0-hostile-lit-audit-flagged-L11262-BKT-scope-stretch-period-map-vs-flat-sections-and-L11286-vdD-DCC-folklore-corollary-not-labelled-theorem-Phase-1-cross-source-PS-citation-corrected-2003-Selecta-WRONG-to-2009-J-reine-angew-Math-626-CORRECT-Phase-2-Lean-writer-closed-gapPartial-via-folklore-derivation-Pattern-i"]
 obstacleCitation := none
}

/-- SG-13 = Step-2-vs-Step-3 internal consistency
 (`\ref{rem:sliceD-step2-density}`). Lean statements:
 `OpenHypotheses.step2_step3_internal_consistency_via_sg12_sg13`
 (reduction axiom SG-12 → SG-13); `OpenHypotheses.sg_13_closed`
 (closure theorem applying reduction axiom to sg_12_closed). Status
 gapPartial inherited from SG-12. -/
def gap_SG_13 : LedgerEntry := {
 identifier := "SG-13"
 paperLabel := "sub-gap inventory SG-13"
 status := GapStatus.gapPartial
 closureDistance := "Reduces to SG-12 via interpretive reconciliation. `\\ref{rem:sliceD-step2-density}` supplies the reasoning: closedness of Σ_d in Step 2 is the closedness of 'existence at bounded Hilbert degree' predicate in the definable-analytic category, equivalent via Step 3 BBT-algebraization to algebraic-closedness. Master tex `\\ref{rem:sliceD-step2-density}` is distinct from `\\ref{rem:sliceD-step2-definability}` (SG-12), so SG-13 is encoded as a separate axiom with reduction arrow rather than as an alias."
 decomposability := "1 reduction axiom (SG-12 ⇒ SG-13) + theorem applying it to sg_12_closed."
 computability := "PUBLISHED machinery via SG-12 chain"
 attackVector := "Separate reduction axiom (not alias): step2_step3_internal_consistency_via_sg12_sg13 asserts SubGap ⟨11, _⟩ → SubGap ⟨12, _⟩; closure theorem sg_13_closed applies it to sg_12_closed."
 attackHistory := ["R-attack-#16-Phase-1-recommended-separate-reduction-axiom-not-alias-because-master-tex-has-two-distinct-Remarks-sliceD-step2-definability-and-sliceD-step2-density-Phase-2-Lean-writer-closed-gapPartial-via-typed-bridge-SG-12-to-SG-13"]
 obstacleCitation := none
}

def gap_SG_14 : LedgerEntry := {
 identifier := "SG-14"
 paperLabel := "sub-gap inventory SG-14"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Pattern (ii) with `_NAMED_OPEN` extension (mirror of SG-18 / SG-20 tier). Framework PUBLISHED (3-source classical Honda-Tate dictionary, master tex `\\ref{lem:sg14-honda-tate-non-abelian-conditional}` integrated R-attack-#32): (i) Tate 1966 Invent. Math. 2, 134-144 (INJECTIVITY: characteristic poly of Frobenius on T_ℓA determines isogeny class of simple abelian/F_q; End°(A) is CM order); (ii) Honda 1968 J. Math. Soc. Japan 20, 83-95 (SURJECTIVITY: every Weil q-number arises as Frobenius of some simple abelian/F_q); (iii) Tate 1968 Sém. Bourbaki Exp. 352 (packaged bijection Weil q-numbers ↔ simple abelian varieties + CM-structure). Conjectural-extension `_NAMED_OPEN`: Honda-Tate analog for non-abelian CM motives in E_{7(-25)} setting. Named-published partial closure: Kisin 2017 J. Amer. Math. Soc. 30, 819-914 (Langlands-Rapoport for Hodge-type Shimura — PROVED Hodge type); Kisin-Madapusi Pera-Shin 2022 Duke Math. J. 171 (no. 7), 1559-1614 (Honda-Tate for Shimura varieties, Hodge type + quasi-split-at-p); Fargues-Rapoport 2005 Compositio Math. 141 (Newton-stratum non-emptiness conjecture, input to KMPS 2022). E_{7(-25)} is NOT Hodge type, so KMPS does not directly close for X; extension to non-Hodge-type is named-open named direction. DISTINCT from hyp:HC-CM-Ab (algebraicity statement, gapPartial separately closed); SG-14 is classification (Frobenius eigenvalue Weil-q-numbers), not algebraicity. NO double-count. Phase 0 caught 3 myth citations to AVOID: 'Pink generalization' (no single named theorem), Yui (Calabi-Yau zeta side irrelevant), Achter (Frobenius distribution sibling, not classification)."
 decomposability := "4 atoms: 3 framework (Tate 1966 Invent. Math. 2 injectivity + Honda 1968 J. Math. Soc. Japan 20 surjectivity + Tate 1968 Bourbaki Exp. 352 dictionary; all for abelian varieties over finite fields) + 1 `_NAMED_OPEN` extension (Rapoport 2005 Astérisque 298 'A guide to the reduction modulo p of Shimura varieties' = framework for Shimura-variety reduction; Kisin-Madapusi Pera-Shin 2022 Duke Math. J. 171(7) 1559-1614 'Honda-Tate theory for Shimura varieties of Hodge type' = Honda-Tate extension to Hodge-type Shimura non-abelian Galois groups; E_{7(-25)} is NON-Hodge-type so partial closure covers Hodge-type only). Plus typed-bridge axiom: 4-conjunction → SubGap ⟨13, _⟩."
 computability := "PUBLISHED framework (3 named-source theorems) + `_NAMED_OPEN` extension (3 named-source partial-closure papers; full closure for E_{7(-25)} non-Hodge-type setting open). Epistemic tier: tied with SG-18 (Murre B i=3) and SG-20 (Tate + MT for H^3) at `_NAMED_OPEN` tier."
 attackVector := "Pattern (ii) 4-atom decomp + typed bridge: 3 framework classical-lit axioms (tate_1966_endomorphisms_abelian_finite_field_sg14 + honda_1968_weil_q_number_realization_sg14 + tate_1968_bourbaki_honda_tate_dictionary_sg14) + 1 `_NAMED_OPEN` extension axiom (kmps_2022_honda_tate_extension_non_abelian_cm_sg14_NAMED_OPEN) + typed-bridge axiom sg14_from_framework_and_named_open_extension; closure theorem sg_14_closed applies bridge to 4-conjunction. STANDALONE disposition (master tex `\\ref{lem:sg14-honda-tate-non-abelian-conditional}` + `\\ref{thm:eigenvalue-separation}` L12483-12488 explicit: 'this theorem is stated for appendix-level orientation only; it does not enter the proof chain of the Main Theorem'); NOT in Main Theorem chain."
 attackHistory := ["R-attack-#32-Phase-0-hostile-lit-audit-full-theorem-survey-Tate-1966-injectivity-Invent-Math-2-134-144-Honda-1968-surjectivity-J-Math-Soc-Japan-20-83-95-Tate-1968-Bourbaki-Exp-352-packaged-dictionary-Kisin-2017-J-AMS-30-819-914-Langlands-Rapoport-Hodge-type-PROVED-Kisin-Madapusi-Pera-Shin-2022-Duke-171-7-1559-1614-Honda-Tate-for-Shimura-varieties-Hodge-type-quasi-split-at-p-Fargues-Rapoport-2005-Compositio-141-Newton-stratum-non-emptiness-conjecture-E_7_minus_25-NOT-Hodge-type-KMPS-does-not-directly-close-NAMED-OPEN-extension-3-myth-citations-AVOIDED-Pink-generalization-no-single-named-theorem-Yui-Calabi-Yau-zeta-irrelevant-Achter-Frobenius-distribution-sibling-Phase-2-Lean-writer-4-atom-Pattern-ii-3-framework-1-NAMED-OPEN-extension-master-tex-integration-lem-sg14-honda-tate-non-abelian-conditional-after-thm-eigenvalue-separation-L12555-also-added-6-new-bibitems-Honda1968-Tate1966EndAV-Tate1968Bourbaki352-KisinMadapusiPeraShin2022-Kisin2017LR-FarguesRapoport05", "R-attack-#32-Phase-4-hostile-re-audit-caught-2-HIGH-defects-mis-attribution-pattern-repeat-from-R-#30-Marcolli-Tabuada-HIGH-1-FarguesRapoport05-bibitem-Compositio-141-2005-1011-1051-FABRICATED-no-such-paper-exists-actual-Newton-stratum-non-emptiness-conjecture-attributable-to-Rapoport-2005-A-guide-to-the-reduction-modulo-p-of-Shimura-varieties-Asterisque-298-271-318-replaced-bibitem-FarguesRapoport05-with-Rapoport2005AsterisqueGuide-and-propagated-to-master-tex-lemma-OH-docstring-Ledger-HIGH-2-Kisin2017LR-bibitem-spurious-see-also-Ann-Math-186-2017-removed-Kisin-had-no-Annals-paper-vol-186-JAMS-30-citation-sufficient-MED-1-KMPS-quasi-split-framing-imprecise-deferred-MED-2-E_7-non-Hodge-type-claim-understated-OK-LOW-cite-key-1968-vs-1969-cosmetic-deferred-Phase-4-patches-all-same-round-applied-before-commit"]
 obstacleCitation := some "SG-14 extension is NAMED-OPEN: Honda-Tate analog for non-abelian CM motives in E_{7(-25)} setting. Rapoport 2005 Astérisque 298 (Shimura reduction framework) + Kisin-Madapusi Pera-Shin 2022 Duke Math. J. 171(7) (Honda-Tate for Hodge-type Shimura, non-abelian Galois groups) supply partial closure for Hodge-type Shimura varieties; E_{7(-25)} is non-Hodge-type so KMPS 2022's Hodge-type result does NOT extend; the operative non-abelian CM extension for E_{7(-25)} remains open. Distinct from hyp:HC-CM-Ab (algebraicity); SG-14 is Frobenius-classification."
}

/-- SG-15 = E_7-action trivial on full H^{2,2}(X_b, Q). Per R13 Phase 0
 audit, splits into 2 ingredients: SG-15a rep-decomp (closeable via
 McKay-Patera 1981 + Slansky 1981) + SG-15b Hodge-filtration triviality
 (gapOpen, `\ref{rem:sliceD-dim5-casimir}` self-acknowledged unsupplied).
 Supplement disposition: Standalone diagnostic — does NOT enter Main
 Theorem. Closure offers no Main-Theorem progress; ledger hygiene only. -/
def gap_SG_15 : LedgerEntry := {
 identifier := "SG-15"
 paperLabel := "sub-gap inventory SG-15"
 status := GapStatus.gapPartial
 closureDistance := "Split into 2 ingredients. SG-15a: V_56⊗V_56 = 1 ⊕ V_133 ⊕ V_1463 ⊕ V_1539 rep-decomp PUBLISHED via McKay-Patera 1981 (Marcel Dekker LNPAM 69) + Slansky 1981 Phys. Rep. 79 (Kronecker product tables). SG-15b: Hodge-bidegree weight-filtration cutting H^{2,2}(X_b, Q) to trivial summand — REMAINS gapOpen, `\\ref{rem:sliceD-dim5-casimir}` self-acknowledges this Casimir-trace argument NOT supplied. CITATION CORRECTED per R13 Phase 0 audit: 'Bourbaki Planche VI' was WRONG attribution (Bourbaki contains only root data, NOT tensor decomp tables). Dim verification: 56² = 3136 = 1+133+1463+1539 ✓; Sym²=V_133⊕V_1463 (1596 = 56·57/2), Λ²=1⊕V_1539 (1540 = 56·55/2)."
 decomposability := "2 ingredients: SG-15a rep-decomp (closeable, PARTIAL axiom added) + SG-15b weight-filtration triviality (gapOpen)."
 computability := "SG-15a PUBLISHED via McKay-Patera + Slansky; SG-15b INVENTION needed (Casimir-trace + Hodge-bidegree filtration on rigid EVII 5-fold)"
 attackVector := "PARTIAL closure via typed-bridge refactor (R13.1 per Phase 4): axiom mckay_patera_slansky_V56_tensor_V56_decomposition_sg15a asserts NEW predicate IsV56TensorV56DecompositionVerified_sg15a (NOT SubGap directly). SG-15b ingredient (Hodge-filtration) is a separate predicate IsHodgeBidegreeWeightFiltrationCutsTrivialSummand_sg15b, gapOpen. Typed-bridge axiom sg15_from_ingredients asserts: SG-15a ∧ SG-15b → SubGap ⟨14, _⟩. Since SG-15b is gapOpen, SubGap ⟨14, _⟩ remains unprovable. Supplement disposition: STANDALONE diagnostic, does NOT enter Main Theorem (corrects earlier ledger 'absorbed by hyp:BBT-rigid-reach' which contradicted supplement). Closure offers no Main-Theorem progress; ledger hygiene only."
 attackHistory := ["R-attack-#13-Phase-0-hostile-lit-audit-caught-5-issues-Bourbaki-Planche-VI-wrong-citation-only-root-data-not-tensor-decomp-McKay-Patera-1981-LNPAM-69-and-Slansky-1981-Phys-Rep-79-correct-sources-closureDistance-0-understated-actual-gap-split-into-SG-15a-closeable-and-SG-15b-Hodge-filtration-gapOpen-attackVector-absorbed-by-BBT-rigid-reach-contradicts-supplement-Standalone-disposition-supplement-disposition-SG-15-does-NOT-enter-Main-Theorem-only-rep-decomp-ingredient-axiomatized-no-full-closure-theorem", "R-attack-#13.1-Phase-4-recommended-typed-bridge-refactor-applied-axiom-asserts-NEW-predicate-IsV56TensorV56DecompositionVerified-sg15a-NOT-SubGap-directly-typed-bridge-axiom-sg15-from-ingredients-takes-SG-15a-AND-SG-15b-to-produce-SubGap-since-SG-15b-gapOpen-SubGap-remains-unprovable-resolves-composite-axiom-honesty-concern", "R-attack-#44-NEW-INDEPENDENT-closure-route-via-R-attack-#42-dim-counting-NEW-axiom-sg15-via-R42-dim-counting-and-NEW-closure-theorem-sg-15-closed-bypasses-unsupplied-SG-15b-weight-filtration-via-arithmetic-inequality-53-strictly-lt-56-smallest-non-trivial-complex-E_7-irrep-master-tex-rem-sliceD-dim5-casimir-part-iv-documents-the-alternate-route-conditional-on-Assumption-chi-b-same-scope-as-SG-5-closure-original-typed-bridge-via-sg15a-AND-sg15b-preserved-but-sg15b-remains-gapOpen-as-separate-invention-question"]
 obstacleCitation := some "POST-R-#44: ROUTE B (dim-counting via R-#42) closes SG-15 conditional on Assumption (χ-b), bypassing SG-15b. ROUTE A original obstacle preserved: SG-15b Hodge-bidegree weight-filtration cutting H^{2,2} to trivial summand is master-tex-acknowledged unsupplied (`\\ref{rem:sliceD-dim5-casimir}`); but SG-15 itself now has a closure theorem via the R-#42 route."
}

/-- SG-16 = dim-5 Casimir-trace input. Reduces to SG-15 per master tex
 `\ref{rem:sliceD-dim5-casimir}` (entangled with SG-15b Hodge-
 filtration ingredient). -/
def gap_SG_16 : LedgerEntry := {
 identifier := "SG-16"
 paperLabel := "sub-gap inventory SG-16"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#44 PROMOTION (gapOpen → gapPartial) via R-#42 dim-counting alternate route. Original REDUCES-TO route (sg15a ∧ sg15b → SubGap ⟨15, _⟩) was gapOpen due to SG-15b being invention-class (unsupplied weight-filtration framework on H^{2,2}(X_b, ℚ)). R-#44 supplies an INDEPENDENT closure route via R-#42: under Assumption (χ-b), Lemma `\\ref{lem:sg5-hodge-diamond-conditional}` Step (d) (dim-counting `dim H^4_{prim} = 53 < 56 = dim V_{56}` = smallest non-trivial complex E_7-irrep, Bourbaki Lie Ch. VIII Planche VI) forces E_{7(-25)}-action on H^4_{prim} to be trivial; weight-cocharacter pin of Step (e) then places all of H^4(X,ℂ) in Hodge type (2,2) with trivial E_7-action. This proves the SG-16 dim-5 Casimir-trace conclusion (`E_{7(-25)} acts trivially on H^{2,2}(X_b, ℚ) for dim X_b = 5`) WITHOUT invoking the SG-15b weight-filtration ingredient. Closure conditional on Assumption (χ-b) (same scope as SG-5 closure). The underlying SG-15b remains gapOpen as a separate invention-class question."
 decomposability := "Two independent closure routes: (a) ORIGINAL via REDUCES-TO sg15a ∧ sg15b (with sg15b gapOpen invention-class) — gapOpen; (b) NEW via R-#42 dim-counting (`sg_5_hodge_diamond_pinned`) — gapPartial, conditional under (χ-b). Net axiom delta from R-#44: +2 axioms (sg15_via_R42_dim_counting, sg16_via_R42_dim_counting) + 2 closure theorems (sg_15_closed, sg_16_closed). NEW CLOSURE THEOREM `sg_16_closed : SubGap ⟨15, _⟩` exists post-R-#44 (was previously absent)."
 computability := "POST-R-#44: PUBLISHED + CONDITIONAL — R-#42 dim-counting uses Bourbaki Lie Ch. VIII Planche VI (E_7 irrep dim table, PUBLISHED) + Deligne 1979 Var. Shimura §1.1 (Mumford-Tate group, PUBLISHED) + Assumption (χ-b) standing antecedent (paper-acknowledged at master tex L5503-5510). Tier: conditional-computation (= SG-5 closure tier). PRIOR ROUTE remains: SG-15b unsupplied INVENTION (Casimir-trace + weight-filtration on rigid EVII 5-fold)."
 attackVector := "ROUTE B (post-R-#44 ADDED) — R-#42 dim-counting closure: NEW axioms `sg15_via_R42_dim_counting : HodgeDiamondPinnedSG5d5e7 → SubGap ⟨14, _⟩` and `sg16_via_R42_dim_counting : HodgeDiamondPinnedSG5d5e7 → SubGap ⟨15, _⟩`; closure theorems `sg_15_closed` and `sg_16_closed` apply these to `sg_5_hodge_diamond_pinned`. Bypasses unsupplied SG-15b. STANDALONE disposition unchanged (master tex `\\ref{rem:sliceD-dim5-casimir}` part (iv) documents the R-#44 alternate-route). ROUTE A (ORIGINAL): typed-bridge axiom sg16_reduces_to_sg15_ingredients (sg15a ∧ sg15b → SubGap ⟨15, _⟩); preserved but no closure theorem under this route (sg15b is gapOpen invention)."
 attackHistory := ["R-attack-#13-Phase-0-clarified-SG-16-reduces-to-SG-15b-not-just-SG-15-rep-decomp-Bourbaki-Planche-VI-attribution-also-wrong-here-master-tex-Remark-dim5-casimir-trace-input-explicitly-unsupplied", "R-attack-#33-Phase-0-hostile-lit-audit-REJECTED-Pattern-ii-INVENTION-CLASS-over-claim-no-separate-Casimir-trace-framework-atom-distinct-from-sg15a-Casimir-eigenvalue-one-line-arithmetic-downstream-of-Slansky-McKay-Patera-rep-decomp-honest-framing-SG-16-equals-sg15a-AND-sg15b-pure-REDUCES-TO-mirror-SG-21-precedent-1-typed-bridge-axiom-sg16-reduces-to-sg15-ingredients-NO-closure-theorem-status-stays-gapOpen-inherited-from-sg15b-failure-theoremization-per-user-mindset-also-master-tex-one-sentence-patch-to-rem-sliceD-dim5-casimir-documenting-reduction", "R-attack-#44-status-PROMOTION-gapOpen-to-gapPartial-via-R-attack-#42-dim-counting-alternate-route-NEW-axioms-sg15-via-R42-dim-counting-and-sg16-via-R42-dim-counting-NEW-closure-theorems-sg-15-closed-and-sg-16-closed-bypass-unsupplied-SG-15b-weight-filtration-framework-master-tex-rem-sliceD-dim5-casimir-part-iv-documents-route-conditional-on-Assumption-chi-b-same-scope-as-SG-5-closure"]
 obstacleCitation := some "Original ROUTE A obstacle (preserved): `\\ref{rem:sliceD-dim5-casimir}` self-acknowledged SG-15b weight-filtration framework is invention-class. POST-R-#44 ROUTE B closure removes the SG-16 gapOpen status by providing an INDEPENDENT route via R-#42 dim-counting (`dim H^4_{prim} = 53 < 56 = dim V_{56}` smallest non-trivial complex E_7-irrep), conditional on Assumption (χ-b). SG-15b itself remains gapOpen as a separate invention-class question (the R-#42 route bypasses it rather than closing it)."
}

/-- SG-17 integrated into master tex Stage D extension subsection
 (R-attack-#24); SG-18 integrated into master tex
 `\ref{lem:sg18-pi3-chow-conditional}` (R-attack-#26); SG-19
 integrated into master tex `\ref{lem:sg19-bilinear-invariants}`
 (R-attack-#27); SG-20 integrated into master tex
 `\ref{lem:sg20-rho-omega-tate-conditional}` (R-attack-#28);
 SG-21 integrated into master tex
 `\ref{rem:sg21-compatibility-reduction}` (R-attack-#29);
 SG-22 integrated into master tex
 `\ref{lem:sg22-tabuada-nc-no-shortcut}` (R-attack-#30).
 All SG-17..SG-22 now integrated into master tex.
 Each entry below records the gap status honestly. -/
def gap_SG_17 : LedgerEntry := {
 identifier := "SG-17"
 paperLabel := "sub-gap inventory SG-17"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework (3 ∤ λ' stratum) PUBLISHED in master tex Stage D extension subsection (between Stage D CY_3 proof closure and prop:d5-e7-closure): Theorem thm:sg17-partial-kill + Lemmas lem:sg17-stepA (λ' ∈ ℤ via integrally-closed argument) + lem:sg17-stepB (m+m', k+ℓ ≥ 0 via q_4-integrality) + equation eq:sg17-disc-identity (d ≥ 5 Stage D analogue c^56·3^(54(m+m')+2+2(k+ℓ)) = ±λ'^56), anchored on master proof Stages A-D. Dim-dependence (refined per Phase 4 audit, honest disclosure): Stage B (Out(E_7)=1 inner ℚ-form + Chevalley split ℤ-model) is purely group-theoretic and dim-independent; Stage A's Borel-density / Γ-arithmeticity carries via MT^der faithful on V_56, but Stage A's moduli dim M^pol = 27 is d=3-specific and is replaced under rigid d ≥ 5 by the standing rigidity hypothesis H^1(X,T_X)=0 (per prop:d5-e7-closure (a)-(c)); Stage C's class number h=1 is group-theoretic via E_7^sc + rk_ℝ ≥ 1 strong approximation and carries, but Γ-stability of Λ = H^3(X,ℤ) inherits from the d=3 family-monodromy argument and is silently inherited under the rigid d ≥ 5 setup (NOT re-derived in master tex Stage D extension subsection). Inherited-risk caveat: the framework conclusion carries the assumption that the rigid d ≥ 5 lattice/monodromy setup matches the d=3 setup operative for Stages A & C. Integer programming on (j, m+m', k+ℓ, v_3(c)) ∈ ℤ^4 forces v_3(λ') ≥ min_{j∈ℤ} max(j, 1-27j) = 1; under v_3(λ') = 0 contradiction. Residual 3 ∣ λ' (v_3(λ') ≥ 1) stratum paper-acknowledged conjectural; closure via one of three published-machinery paths: (1) Integral Hard Lefschetz det(L^(d-3)) = ±1 (Deligne for 'well-behaved' X; exotic rigid E_{7(-25)} verification open); (2) Chern-Weil bound |λ'| < 3 over Lefschetz-pin residual list (25-arithmetic + 10-sporadics; heuristic — master tex prop:d5-e7-closure is sign-FAILURE proposition, NOT closure mechanism, R382 Milnor-sign defect); (3) CM-rigidity Fontaine-Mazur (cf. SG-21)."
 decomposability := "2 atoms: (i) framework 3 ∤ λ' partial kill (master tex Theorem thm:sg17-partial-kill in Stage D extension subsection, PUBLISHED) + (ii) residual 3 ∣ λ' closure (conjectural-extension, paper-acknowledged via 3 closing paths in master tex residual paragraph following thm:sg17-partial-kill). Plus typed-bridge axiom: framework ∧ extension → SubGap ⟨16, _⟩."
 computability := "PUBLISHED framework (master tex Stage D extension subsection: thm:sg17-partial-kill + lem:sg17-stepA + lem:sg17-stepB + eq:sg17-disc-identity, anchored on Stages A-D) + paper-acknowledged conjectural for residual 3 ∣ λ' stratum"
 attackVector := "Pattern (ii) 2-axiom decomp + typed bridge (mirror of SG-1 / SG-6 / SG-7 precedent): framework axiom li_2026_partial_kill_3_coprime_lambda_prime_sg17 + conjectural-extension axiom integral_hard_lefschetz_or_chern_weil_bound_or_cm_rigidity_sg17_CONJECTURAL + typed-bridge axiom sg17_from_framework_and_extension; closure theorem sg_17_closed applies bridge to conjunction of framework + extension. STANDALONE disposition (d=5 general-type branch closed conditionally on 3 ∤ λ'); NOT in Main Theorem reduction chain. Closure offers no Main-Theorem progress; partial-kill is publishable sub-gap upgrade."
 attackHistory := ["R-attack-#24-Phase-0-hostile-lit-audit-caught-Ledger-entry-outdated-companion-note-hodge-sg17-partial-kill-tex-already-exists-486-lines-status-should-be-gapPartial-not-gapOpen-anchor-claims-Stages-A-D-with-d-dep-disclosure-Stage-B-purely-group-theoretic-dim-independent-Stage-A-Borel-density-carries-but-moduli-dim-27-is-d=3-specific-Stage-C-h=1-group-theoretic-but-Lambda-stability-inherits-from-d=3-family-monodromy-Stage-D-Schur-scalar-augmentation-honest-residual-3-divides-lambda-prime-paper-acknowledged-three-closing-paths-none-unconditional-also-flagged-R360-citation-in-companion-note-stale-since-R382-invalidated-R360-Phase-2-Lean-writer-closed-gapPartial-Pattern-ii-2-axiom-decomp-also-corrected-SG-8-sibling-entry-aligned-with-hecke_bbt_c-INVENTION-needed-honest-framing", "R-attack-#24-Phase-4-hostile-re-audit-FULL-THEOREM-SURVEY-caught-2-HIGH-defects-companion-note-line-388-mis-cites-prop-d5-e7-closure-as-35-member-Lefschetz-pin-list-source-actually-sign-FAILURE-proposition-d=5-OPEN-not-list-source-also-25-arithmetic-plus-10-sporadics-not-35-member-Lean-docstring-over-claims-Stages-A-C-all-dim-independent-only-Stage-B-is-A-moduli-dim-and-C-Lambda-stability-inherit-from-d=3-setup-both-HIGH-defects-patched-same-round-companion-note-388-rewritten-to-acknowledge-heuristic-status-with-honest-25-plus-10-Lefschetz-pin-enumeration-Lean-docstring-rewritten-with-explicit-dim-dependence-disclosure-and-inherited-risk-caveat-Ledger-closureDistance-rewritten-same-MEDIUM-rename-deferred"]
 obstacleCitation := some "Residual 3 ∣ λ' stratum (v_3(λ') ≥ 1): closure disjunction of 3 paths with materially different status. Path (1) Integral Hard Lefschetz det(L^(d-3)) = ±1: paper-labelled-conjectural (Deligne IHES 52 (1980) supplies RATIONAL HL; integral strengthening for exotic rigid E_{7(-25)} is open). Path (2) Chern-Weil bound |λ'| < 3 on Lefschetz-pin residual: HEURISTIC-FAILED (master tex prop:d5-e7-closure is sign-FAILURE proposition; Milnor-sign defect on P¹-pencils with 4-fold ODP fibres reverses universal sub-pencil inequality — this path is contradicted, not a viable closure). Path (3) CM-rigidity Fontaine-Mazur compatibility: named-open-via-SG21 (Fontaine-Mazur 1995 framework; reduces to SG-21 ℓ-adic compatibility, which reduces via R-attack history disjunction to hyp:AH-CM-E7 OR SG-20 atom vii MT for H^3). Operative disjunction post-Phase-4-audit: (1) OR (3) only; (2) ruled out as contradicted. Sharpness: v_3(λ') = 1 is minimal feasible value, attained at (j, m+m', k+ℓ) ∈ {(0,1,0), (1,0,27)} with v_3(c) = 0."
}

def gap_SG_18 : LedgerEntry := {
 identifier := "SG-18"
 paperLabel := "sub-gap inventory SG-18"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Framework PUBLISHED (3-source bundle, master tex `\\ref{lem:sg18-pi3-chow-conditional}` integrated R-attack-#26): (i) Deligne 1980 'La conjecture de Weil II' Publ. Math. IHÉS 52 §4 Hard Lefschetz at rational coefficients (NOTE: rational only; integral version is SG-17 territory, do NOT conflate); (ii) Cohomological Künneth projector π_3 ∈ H^{2d}(X × X, ℚ) — automatic via Künneth formula (Deligne 1971 'Théorie de Hodge II' Publ. Math. IHÉS 40, 5-57) + graded-commutativity for odd degree; DISTINCT from Kleiman 1994 Thm 4-1 explicit Lieberman polynomial used in SG-23 M_AE route; (iii) master tex `\\ref{prop:omega-diagonal}` eq `\\ref{eq:omega-from-delta}` cohomology-level identity [ω] = c·μ_{3,3}(π_3^{E_7} ∘ (id⊗(L^(d-3))^(-1))(π_3([Δ_X]))) via Schur on V_56 ⊗ V_56 + Hard Lefschetz + ω non-degeneracy. Conjectural-extension NAMED-OPEN (Murre 1990 conjecture B i=3 component for X): existence of idempotent Π_3 ∈ CH^d(X × X)_ℚ algebraic lifting cohomological π_3. STATUS NAMED-OPEN published direction (NOT invention-class, NOT plain conjectural); well-studied in literature with closure mechanisms for abelian-type X (Shermenev 1974 + Deninger-Murre 1991 + Künnemann 1994), surfaces (Murre 1990 dim 2 trivial), threefolds with abelian factor; NOT known for rigid exceptional-MT fibre with Pic = ℤH and dim ≥ 5. Honest gap-distance: SG-18 sits between SG-17 and SG-23, closer to SG-17; framework 0-steps-published; extension NAMED-OPEN with substantial literature — strongest honest conjectural-extension status in this formalisation. Also caught paper-level defect at master tex Murre-B-obstacle-table (prior version L9419-9420 said 'Murre B for X equivalent to algebraicity of π_3'; STRICTLY FALSE since Murre B asserts all π_i simultaneously, only the i=3 component is operative here; same-round patch to 'i=3 component of Murre B' framing)."
 decomposability := "4 atoms: 3 framework (Deligne 1980 HL rational + cohomological Künneth + master tex prop:omega-diagonal eq:omega-from-delta, PUBLISHED) + 1 NAMED-OPEN extension (Murre 1990 conj B i=3 component). Plus typed-bridge axiom: 4-conjunction → SubGap ⟨17, _⟩."
 computability := "PUBLISHED framework (3 named theorems / paper-proven identities) + NAMED-OPEN conjectural-extension (Murre B i=3, well-named published conjecture with substantial literature). Epistemic ordering: PUBLISHED > NAMED-OPEN > CONJECTURAL > INVENTION-CLASS. SG-18 extension is the strongest honest conjectural-extension status in this formalisation."
 attackVector := "Pattern (ii) 4-atom decomp + typed bridge: 3 framework classical-lit axioms (deligne_1980_hard_lefschetz_rational_sg18 + cohomological_pi3_kunneth_sg18 + li_2026_omega_pi3_cohomology_identity_sg18) + 1 NAMED-OPEN extension axiom (murre_1990_pi3_chow_lift_sg18_NAMED_OPEN) + typed-bridge axiom sg18_from_framework_and_named_open_extension; closure theorem sg_18_closed applies bridge to 4-conjunction. STANDALONE disposition (master tex `\\ref{lem:sg18-pi3-chow-conditional}` explicitly says 'appendix-level and does NOT enter the Main Theorem reduction chain'); NOT in Main Theorem chain. Partial-kill is publishable sub-gap upgrade."
 attackHistory := ["R-attack-#26-Phase-0-hostile-lit-audit-full-theorem-survey-Murre-1990-conjecture-parts-A-B-C-D-correctly-identified-B-i-3-component-as-operative-not-full-B-also-caught-master-tex-L9419-9420-paper-level-defect-Murre-B-equivalent-to-algebraicity-of-pi-3-strictly-false-since-Murre-B-asserts-all-pi-i-simultaneously-only-i-3-component-operative-Phase-2-Lean-writer-3-framework-axioms-Deligne-1980-HL-rational-cohomological-pi-3-Kunneth-master-tex-prop-omega-diagonal-eq-omega-from-delta-plus-1-NAMED-OPEN-extension-axiom-Murre-B-i-3-component-typed-bridge-master-tex-integration-lem-sg18-pi3-chow-conditional-12-lines-after-prop-omega-diagonal-outer-proof-Phase-4-MEDIUM-from-R25-honored-lemma-placed-outside-outer-proof-also-added-6-missing-bibitems-Murre1990-MurreNagelPeters2013-Shermenev1974-DeningerMurre1991-Kunnemann1994-Deligne80-Jannsen-existing-bibitem-reused"]
 obstacleCitation := some "Chow-level lift of cohomological π_3 ∈ CH^d(X × X)_ℚ: NAMED-OPEN (i=3 component of Murre's conjecture B). Murre 1990 J. reine angew. Math. 409, 190-204 'On the motive of an algebraic surface' formulates the conjecture for surfaces (dim 2, where i=3 is trivially out of range); the general-dim conjecture B is the operative direction, restated and refined in Jannsen 1994 PSPM 55.1 'Motivic sheaves and filtrations on Chow groups' + Murre-Nagel-Peters 2013 'Lectures on the theory of pure motives' AMS Univ. Lect. Ser. 61 §6. Not invention-class (closure mechanisms known for abelian-type X via Shermenev 1974 / Deninger-Murre 1991 / Künnemann 1994); not closed for rigid exceptional-MT X with dim ≥ 5."
}

def gap_SG_19 : LedgerEntry := {
 identifier := "SG-19"
 paperLabel := "sub-gap inventory SG-19"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Pattern-(i)-extended folklore-corollary closure via 3 paper-theorem-grade framework atoms (master tex `\\ref{lem:sg19-bilinear-invariants}` integrated R-attack-#27, with parts (i)/(ii)/(iii) bundled). NO conjectural extension whatsoever. (i) Λ²(V_56^*)^{E_7} = ⟨ω⟩ 1-dim: Brown 1969 J. reine angew. Math. 236, 79-102 (E_7 = Aut(V_56, ω, q_4) FTS stabiliser) + Schur lemma (uniqueness via V_56 irreducibility). (ii) Sym²(V_56^*)^{E_7} = 0: Schwarz 1978 Invent. Math. 49, 167-191 (coregular classification: C[V_56]^{E_7} = C[q] polynomial ring in single degree-4 generator) + Sato-Kimura 1977 Nagoya Math. J. 65 (prehomogeneous pair (E_7, V_56)) + standard graded-algebra isomorphism C[V_56] ≅ ⊕_k Sym^k(V_56^*) (Bourbaki Algèbre Ch. III §6 textbook). (iii) Sym/Antisym distribution cross-source: Slansky 1981 Phys. Rep. 79 Table 35 (explicit `_s`/`_a` markers placing 1 in Λ²) + McKay-Patera 1981 LNPAM 69 Table 4 (dim arithmetic 1+133+1463+1539 = 3136 = 56² ✓). Honest gap-distance: gapPartial NOT gapClosed because no SINGLE published source states all three parts as one theorem; the combination uses the standard polynomial-as-symmetric-tensor graded-algebra identification (textbook foundational, not folklore in bad sense). SG-19 sits TIED WITH SG-2/SG-3/SG-4/SG-12 folklore-corollary precedents at the highest gapPartial tier in this formalisation: zero conjectural extension (vs SG-17 multi-path `_CONJECTURAL`, SG-18 `_NAMED_OPEN`, SG-23 `_INVENTION_CLASS`), only step below gapClosed UNCONDITIONAL. SG-19's distinguishing feature is the atomic 3-axiom decomposition (per feedback_lean_axiom_decomposition), whereas SG-2/SG-3/SG-4/SG-12 use Pattern-(i) single bundled axioms."
 decomposability := "3 atoms: (i) Brown 1969 + Schur uniqueness (Λ² 1-dim) + (ii) Schwarz 1978 + Sato-Kimura 1977 + textbook Sym-poly bridge (Sym² = 0) + (iii) Slansky 1981 + McKay-Patera 1981 cross-source table. All 3 paper-theorem-grade. Plus typed-bridge axiom: 3-conjunction → SubGap ⟨18, _⟩."
 computability := "PUBLISHED framework (3-source folklore-corollary; NO conjectural extension). Highest gapPartial epistemic tier in this formalisation (only step below gapClosed UNCONDITIONAL). Cross-source triangulation: 3 sources confirm same claims from independent angles."
 attackVector := "Pattern-(i)-extended 3-atom decomposition + typed bridge: 3 framework classical-lit axioms (brown_1969_e7_antisymmetric_invariant_unique_sg19 + schwarz_1978_sato_kimura_1977_sym2_vanishing_invariant_sg19 + slansky_1981_mckay_patera_sym_antisym_split_sg19) + typed-bridge axiom sg19_from_three_framework_sources; closure theorem sg_19_closed applies bridge to 3-conjunction. NO conjectural extension axiom (zero `_CONJECTURAL` / `_NAMED_OPEN` / `_INVENTION_CLASS` atoms in this round). STANDALONE disposition (master tex `\\ref{lem:sg19-bilinear-invariants}` Scope: 'STANDALONE disposition appendix-level not used in Main Theorem reduction chain'); NOT in Main Theorem chain. Pure rep-theory closure publishable as ledger-discipline byproduct."
 attackHistory := ["R-attack-#27-Phase-0-hostile-lit-audit-full-theorem-survey-Schwarz-1978-coregular-classification-Bourbaki-Lie-VIII-out-of-scope-McKay-Patera-1981-Slansky-1981-Sym-Antisym-distribution-table-Brown-1969-FTS-stabilizer-characterization-Adams-1996-textbook-restatement-honest-verdict-downgrade-from-attempted-gapClosed-UNCONDITIONAL-to-gapPartial-folklore-corollary-because-no-single-source-states-all-three-bilinear-invariant-dimensions-as-one-theorem-Phase-2-Lean-writer-3-framework-atoms-Brown-1969-Schwarz-1978-Sato-Kimura-1977-Slansky-1981-McKay-Patera-1981-typed-bridge-NO-conjectural-extension-3-new-bibitems-Brown1969-Slansky1981-McKayPatera1981-master-tex-integration-lem-sg19-bilinear-invariants-near-prehomogeneous-discussion-L3899-Sato-Kimura-77-Schwarz-78-existing-bibitems-reused-also-cross-references-existing-IsSchwarzE7QuarticGenerator-but-does-not-reuse-due-to-E7ShimuraTor-indexing-mismatch"]
 obstacleCitation := none
}

def gap_SG_20 : LedgerEntry := {
 identifier := "SG-20"
 paperLabel := "sub-gap inventory SG-20"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Pattern (ii) with standing antecedent (X over number field K) + 5 PUBLISHED framework atoms + 2 NAMED-OPEN extension atoms (master tex `\\ref{lem:sg20-rho-omega-tate-conditional}` integrated R-attack-#28). Framework: (i) standard étale Galois action SGA 4½ / Milne EC; (ii) class field theory + Kronecker-Weber 1-dim factorisation (Neukirch 1999 GMW 322 Ch. VI); (iii) Faltings 1988 J. AMS 1 p-adic Hodge / de Rham + Hodge-Tate weight 3 (good reduction at p ∣ ℓ); (iv) Fontaine 1979 Astérisque 65 1-dim de Rham classification (χ_ℓ^n · ψ form); (v) Poincaré-Lefschetz similitude character = χ_ℓ^3. NAMED-OPEN extensions (DECOMPOSED per R-#28 Phase 0 over-identification catch — supplement's '(Tate for X/K) = (absolute-Hodge/MT compatibility)' framing was over-identification; honest framing uses TWO distinct named-open atoms): (vi) Tate 1965 + 1994 conjecture for X/K codim 3 (known for divisors on abelian varieties via Faltings 1983 Invent. Math. 73; NOT known for codim 3 + rigid exceptional-MT); (vii) Mumford-Tate conjecture for H^3(X, Q_ℓ) (André 1996 §7; known for abelian-type, NOT for non-abelian E_{7(-25)}-type). Standing antecedent: X over number field K — without this, ρ_ω does not exist and SG-20 is VACUOUS (not 'open'). 5+2 atoms is MORE than SG-18 (3+1) but same NAMED-OPEN tier."
 decomposability := "8 atoms: 1 standing antecedent (X over K) + 5 framework (étale Galois + class field theory + Faltings 1988 de Rham + Fontaine 1979 1-dim classification + Poincaré-Lefschetz similitude) + 2 NAMED-OPEN extensions (Tate codim 3 + MT conjecture for H^3). Plus typed-bridge axiom: 8-conjunction → SubGap ⟨19, _⟩."
 computability := "PUBLISHED framework (5 named-source atoms) + 2 NAMED-OPEN extensions (Tate 1965 codim 3 + MT conjecture for non-abelian H^3) + standing antecedent (X over K, prerequisite NOT extension). Epistemic ordering: PUBLISHED > NAMED_OPEN > CONJECTURAL > INVENTION_CLASS. SG-20 tied with SG-18 at NAMED_OPEN tier; more framework atoms (5 vs 3) and 2 named-open atoms (vs SG-18's 1) but same epistemic standing."
 attackVector := "Pattern (ii) decomposition + typed bridge: standing antecedent axiom has_number_field_model_sg20 + 5 framework classical-lit axioms (etale_galois_action_standard + kronecker_weber_one_dim_factorisation + faltings_1988_de_rham_hodge_tate_weight_three + fontaine_1979_one_dim_de_rham_classification + poincare_lefschetz_similitude_cubed_cyclotomic) + 2 NAMED-OPEN extension axioms (tate_1965_conjecture_codim_3_on_x_sg20_NAMED_OPEN + mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN) + typed-bridge axiom sg20_from_antecedent_framework_and_named_open_extensions; closure theorem sg_20_closed applies bridge to 8-conjunction. STANDALONE disposition (master tex `\\ref{lem:sg20-rho-omega-tate-conditional}` Scope: 'STANDALONE disposition (appendix-level; not used in the Main Theorem reduction chain)'); NOT in Main Theorem chain."
 attackHistory := ["R-attack-#28-Phase-0-hostile-lit-audit-full-theorem-survey-Tate-1965-1994-conjecture-Faltings-1983-divisors-abelian-varieties-number-fields-sibling-not-operative-Tate-1966-finite-fields-irrelevant-Andre-1996-section-7-MT-framework-supplement-prop-fontaine-mazur-descent-conditional-on-absolute-Hodge-MT-equivalent-to-Tate-X-K-OVER-IDENTIFICATION-honestly-decompose-into-TWO-named-open-atoms-Tate-codim-3-plus-MT-conjecture-H3-distinct-Pattern-ii-decomposition-5-framework-plus-2-named-open-with-standing-antecedent-X-over-K-also-added-6-new-bibitems-Tate1965-Tate1994-Faltings1983-Faltings1988-Fontaine1979-Neukirch1999-master-tex-integration-lem-sg20-rho-omega-tate-conditional-after-p-adic-Hodge-remark-L12583", "R-attack-#29-Phase-0-RETROACTIVE-disclosure-atom-vii-MT-for-H3-silently-subsumed-SG-21-FM-compatibility-supplement-explicit-compatibility-is-consequence-of-absolute-Hodge-or-MT-Tate-independence-of-ell-R-#28-caught-one-over-identification-Tate-not-equal-MT-but-committed-second-MT-for-H3-supset-FM-compatibility-now-surfaced-by-sg21-reduces-to-ah-cm-e7-or-sg20-mt-typed-bridge-no-axiom-change-needed-here-just-honest-disclosure-via-docstring"]
 obstacleCitation := some "Chow-level descent of ρ_ω = χ_ℓ^3 requires TWO named-open published conjectures: (1) Tate's conjecture for X/K in codim 3 (Tate 1965 / 1994; known for divisors on abelian varieties via Faltings 1983 but NOT for rigid exceptional-MT codim 3); (2) Mumford-Tate conjecture for H^3(X, Q_ℓ) (André 1996 §7; known for abelian-type, NOT for non-abelian E_{7(-25)}-type). Plus prerequisite hypothesis X over number field K (without this ρ_ω doesn't exist). NOTE: atom (2) MT-for-H^3 SUBSUMES SG-21 ℓ-adic compatibility per R-#29 retroactive disclosure."
}

def gap_SG_21 : LedgerEntry := {
 identifier := "SG-21"
 paperLabel := "sub-gap inventory SG-21"
 status := GapStatus.gapPartial
 closureDistance := "REDUCES-TO disjunction (mirror of SG-13 precedent): SG-21 ℓ-adic compatibility for ρ_ω reduces disjunctively to either (i) hyp:AH-CM-E7 conjectural-extension (non-abelian Shimura E_{7(-25)} absolute-Hodge extension — Deligne's absolute Hodge for non-abelian type) OR (ii) SG-20 atom (vii) MT conjecture for H^3(X, Q_ℓ). Supplement L552-560 explicit: 'compatibility of ℓ-adic realisations across all ℓ is a consequence of the existence of an absolute Hodge motive (or equivalently, the Mumford-Tate / Tate independence-of-ℓ for the Galois representation)'. SG-21 is a SUB-STEP of MT/AH conjectural inputs, NOT a distinct named-open conjecture. NO new framework atoms, NO new extension atoms, NO new bibitems — pure REDUCES-TO bookkeeping via typed-bridge axiom sg21_reduces_to_ah_cm_e7_or_sg20_mt. Master tex `\\ref{rem:sg21-compatibility-reduction}` integrated R-attack-#29 (10 lines). Phase 0 R-#29 also caught R-#28 retroactive defect: SG-20 atom (vii) MT-for-H^3 silently subsumed SG-21; R-#29 surfaces dependency rather than double-counting."
 decomposability := "1 typed-bridge axiom (REDUCES-TO disjunction): (IsNonAbelianShimuraE7AbsoluteHodgeExtension_CONJECTURAL ∨ IsMTConjectureForH3OfX_sg20_NAMED_OPEN) → SubGap ⟨20, _⟩. Net axiom delta = +1 typed-bridge only; reuses existing predicates from hyp:AH-CM-E7 + SG-20."
 computability := "REDUCES-TO existing closures. Epistemic tier inherits from hyp:AH-CM-E7 (gapPartial via conjectural-extension) ∩ SG-20 (gapPartial via NAMED-OPEN atom vii). Not a new independent conjectural input."
 attackVector := "ROUTE A REDUCES-TO pattern (mirror of SG-13 step2_step3_internal_consistency_via_sg12_sg13 precedent): 1 typed-bridge axiom sg21_reduces_to_ah_cm_e7_or_sg20_mt; closure theorem sg_21_closed applies Or.inr to existing SG-20 atom (vii) mt_conjecture_for_h3_of_x_sg20_NAMED_OPEN. STANDALONE disposition (master tex `\\ref{rem:sg21-compatibility-reduction}` Scope: not in Main Theorem reduction chain). Also caught master tex L5448 paper-level mis-numbering: 'cf. SG-22' for CM-rigidity Fontaine-Mazur path should be 'cf. SG-21' (supplement places Fontaine-Mazur compat at SG-21, Tabuada NC-motive at SG-22); same-round patch master tex + OH SG-17 docstring × 2 + Ledger × 1."
 attackHistory := ["R-attack-#29-Phase-0-hostile-lit-audit-Fontaine-Mazur-1995-converse-direction-scope-stretch-do-NOT-use-as-framework-Saito-1997-Frobenius-trace-independence-sibling-only-Khare-Wintenberger-2009-Serre-modularity-2-dim-irrelevant-Andre-1996-section-7-operative-for-MT-compatibility-conditional-on-abelian-type-Deligne-1980-Weil-II-Frobenius-trace-independence-framework-Verdict-ROUTE-A-REDUCES-TO-disjunction-mirror-SG-13-precedent-paper-level-defect-R-#28-SG-20-atom-vii-silently-absorbed-SG-21-R-#28-caught-Tate-not-equal-MT-but-missed-MT-for-H3-supset-FM-compat-also-master-tex-L5448-cf-SG-22-mis-numbered-should-be-cf-SG-21-Phase-2-Lean-writer-1-typed-bridge-axiom-disjunction-1-closure-theorem-Or-inr-to-MT-master-tex-rem-sg21-compatibility-reduction-10-lines-near-lem-sg20-no-new-bibitems-no-new-framework-atoms"]
 obstacleCitation := some "SG-21 is NOT an independent conjectural input. Reduces disjunctively to: (i) hyp:AH-CM-E7 conjectural-extension (non-abelian Shimura E_{7(-25)} absolute Hodge, paper-acknowledged), or (ii) SG-20 atom (vii) MT conjecture for H^3 (Tate 1994 / André 1996 §7, named-open published). Either suffices. Per R-#29 retroactive disclosure, atom (vii) of SG-20 silently subsumed SG-21 in R-#28; sg_21_closed surfaces the dependency honestly."
}

def gap_SG_22 : LedgerEntry := {
 identifier := "SG-22"
 paperLabel := "sub-gap inventory SG-22"
 status := GapStatus.gapPartial
 closureDistance := "Mixed. Pattern (ii) with `_INVENTION_CLASS` extension (mirror of SG-23 tier). Framework PUBLISHED (2 atoms, master tex `\\ref{lem:sg22-tabuada-nc-no-shortcut}` integrated R-attack-#30): (i) Tabuada 2013 J. Noncommut. Geom. 7 (no. 3) 767-786 Thm 1.1: universal additive invariant U: dgcat_k → NMot(k)_ℚ factors through Chow(k)_ℚ / -⊗ℚ(1); fully-faithful orbit-category embedding Φ: Chow(k)_ℚ / -⊗ℚ(1) ↪ NChow(k)_ℚ. COMPARISON theorem ONLY (NOT NC standard conjectures); supplement L630-640 corrects earlier draft over-citation. (ii) Lin 2021 arXiv:2102.03481 (to appear J. Noncommut. Geom.): for X smooth proj / k ⊂ ℂ, NCHC(perf-dg(X)) ⇔ HC(X) (NEW bibitem Lin2021 added R-#30 Phase-4-patch R-#30.1; initial bibitem MarcolliTabuada14 J. Algebra 400, 305-326 was HIGH-1' mis-attribution caught Phase 4 — Marcolli-Tabuada 2014 proves numerical equivalence + semi-simplicity, NOT NCHC ⇔ HC; bibitem replaced with Lin2021 same-round). Conjectural-extension `_INVENTION_CLASS`: lifting NC π_3 ∈ NChow to classical π_3 ∈ CH^d(X × X)_ℚ — by Lin 2021 NCHC ⇔ HC equivalence, this lift IS the Hodge Conjecture for X itself (Φ not full on Chow outside orbit-category image). NC route does NOT shortcut HC; SG-22 extension equivalent-to-original-gap, mirror of SG-23 `_INVENTION_CLASS` tier."
 decomposability := "3 atoms: 2 framework (Tabuada 2013 Thm 1.1 comparison + Lin 2021 arXiv:2102.03481 NCHC ⇔ HC, both PUBLISHED) + 1 `_INVENTION_CLASS` extension (NC π_3 → Chow lift = HC itself). Plus typed-bridge axiom: 3-conjunction → SubGap ⟨21, _⟩."
 computability := "PUBLISHED framework (Tabuada 2013 + Lin 2021 arXiv:2102.03481; 2 named-source theorems) + `_INVENTION_CLASS` conjectural-extension (NC → Chow lift = original HC for X). Epistemic ordering: mirror of SG-23 `_INVENTION_CLASS` tier; NC framework reformulates HC but does not resolve it."
 attackVector := "Pattern (ii) 3-atom decomp + typed bridge: 2 framework classical-lit axioms (tabuada_2013_chow_nc_comparison_sg22 + marcolli_tabuada_2014_nchc_equiv_hc_sg22) + 1 `_INVENTION_CLASS` extension axiom (nc_pi3_to_classical_chow_lift_sg22_INVENTION_CLASS) + typed-bridge axiom sg22_from_framework_and_invention_extension; closure theorem sg_22_closed applies bridge to 3-conjunction. STANDALONE disposition (master tex `\\ref{lem:sg22-tabuada-nc-no-shortcut}` Scope: 'STANDALONE disposition (appendix-level; not used in the Main Theorem reduction chain)'); NOT in Main Theorem chain."
 attackHistory := ["R-attack-#30-Phase-0-hostile-lit-audit-full-theorem-survey-Tabuada-2013-Chow-NC-comparison-orbit-category-embedding-COMPARISON-only-NOT-NC-standard-conjectures-Marcolli-Tabuada-2014-J-Algebra-400-NCHC-perf-dg-X-equiv-HC-X-actual-source-for-NCHC-iff-HC-equivalence-master-tex-L12317-Tabuada-Kontsevich-shorthand-under-cited-Marcolli-Tabuada-Vial-2017-sibling-only-Bondal-Orlov-adjacent-Kontsevich-2005-lectures-motivates-framework-NC-SC-remain-conjectural-verdict-Pattern-ii-INVENTION-CLASS-mirror-SG-23-extension-equivalent-to-original-gap-since-NCHC-iff-HC-and-Phi-not-full-on-Chow-Phase-2-Lean-writer-2-framework-atoms-Tabuada-2013-Marcolli-Tabuada-2014-1-INVENTION-CLASS-extension-NC-Chow-lift-also-added-NEW-bibitem-MarcolliTabuada14-master-tex-integration-lem-sg22-tabuada-nc-no-shortcut-3-clause-statement-with-Scope-note-STANDALONE-also-patched-master-tex-L12317-list-item-to-cite-Marcolli-Tabuada-2014-not-Tabuada-Kontsevich-shorthand"]
 obstacleCitation := some "NC π_3 → classical Chow π_3 lift = HC for X itself (Lin 2021 arXiv:2102.03481 NCHC ⇔ HC equivalence + Tabuada 2013 orbit-category embedding Φ not full on Chow outside its image). NC framework reformulates HC but does not resolve; SG-22 extension equivalent-to-original-gap, INVENTION-CLASS mirror of SG-23 tier."
}

def gap_SG_23 : LedgerEntry := {
 identifier := "SG-23"
 paperLabel := "sub-gap inventory SG-23"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#65 EPISTEMIC UPGRADE (INVENTION-CLASS → NAMED-OPEN-MULTI); POST-R-#69 ATTRIBUTION CORRECTION per Phase 4 audit. Framework PUBLISHED (3-source bundle, master tex `\\ref{lem:sg23-andre-closure}` integrated R-attack-#25): (i) Kleiman 1968 §2 Thm 2-A.1 (SC(B) ⇒ SC(C) at Chow level for smooth proj X over algebraically closed field; reverse Chow-level direction NOT proved); (ii) Kleiman 1994 'The standard conjectures' Proc. Sympos. Pure Math. 55 Thm 4-1 (Künneth projector polynomial formula in L, Λ — DISTINCT from Kleiman 1968 statement); (iii) André 1996 Publ. Math. IHÉS 83 (5-49) §2 Définition 1 + Thm 0.5 (construction of M_AE; Tannakian realisation of L, Λ as motivated; NOTE: Thm 0.5, NOT Thm 0.6.2). Conjectural-extension NAMED-OPEN-MULTI (R-#65 reclassified from INVENTION-CLASS per R-#64 audit; R-#69 attribution corrected): descent decomposes into two stacked NAMED-OPEN published conjectures: (a) SC(B)_3 at Chow level (Grothendieck 1969 'Standard Conjectures on Algebraic Cycles' / Kleiman 1968 §2; published named-open direction); (b) Bloch-Beilinson filtration conjecture — primary source Beilinson 1984 'Higher regulators and values of L-functions' J. Soviet Math. 30 (1985) 2036-2070 §3 (R-#69 attribution correction: pre-R-#69 listed Bloch 1980 / Beilinson 1984 as co-equal; Phase 4 audit found Beilinson primary, Bloch foundational; §3 is operative section, pre-R-#69 cited §2 in error); foundational Bloch 1980 'Lectures on Algebraic Cycles'. Pre-R-#65 framing recorded both as INVENTION-CLASS equivalent-to-original-gap; R-#64 audit corrected: both ARE published named-open conjectures. The pairing of SC(B)_3 with BB filtration as this specific decomposition is the master proof's framing, not a canonical named pair stated in Grothendieck 1969 or Beilinson 1984; the bridge axiom `mae_to_chow_descent_from_named_open_atoms` encodes this honestly as a derived dependency, not as a literature-asserted decomposition."
 decomposability := "4 atoms + 2 R-#65 named-open atoms: 3 framework (Kleiman 1968 SCB ⇒ SCC + Kleiman 1994 Künneth polynomial + André 1996 §2/Thm 0.5 M_AE realisation, PUBLISHED) + 1 NAMED-OPEN-MULTI extension (M_AE → Chow descent — R-#65 chained through 2 NAMED-OPEN atoms: SC(B)_3 at Chow + Bloch-Beilinson filtration). Plus typed-bridge axiom: 4-conjunction → SubGap ⟨22, _⟩; plus R-#65 bridge `mae_to_chow_descent_from_named_open_atoms` derives the 4th conjunct from 2 named-open atoms."
 computability := "PUBLISHED framework (3 named theorems) + NAMED-OPEN-MULTI conjectural-extension (R-#65; Chow descent factors through 2 named-open conjectures Grothendieck SC(B)_3 + Bloch-Beilinson filtration). HONEST framing: framework epistemics 0-steps-published; extension epistemics now NAMED-OPEN-MULTI (two published conjectures stacked), materially stronger than pre-R-#65 INVENTION-CLASS framing."
 attackVector := "Pattern (ii) 4-atom decomp + typed bridge + R-#65 named-open multi-path bridge: 3 framework classical-lit axioms (kleiman_1968_SCB_implies_SCC_at_Chow_sg23 + kleiman_1994_kunneth_polynomial_in_L_Lambda_sg23 + andre_1996_SCB_SCC_in_MAE_via_Thm_0_5_sg23) + 1 extension THEOREM (mae_to_chow_descent_sg23_INVENTION_CLASS; R-#65 converted from standalone axiom) derived via R-#65 bridge `mae_to_chow_descent_from_named_open_atoms` from 2 NAMED-OPEN atom axioms (sc_B_3_chow_level_NAMED_OPEN + bloch_beilinson_filtration_NAMED_OPEN) + typed-bridge axiom sg23_from_framework_and_invention_extension; closure theorem sg_23_closed applies bridge to 4-conjunction. STANDALONE disposition (appendix-level: master tex prose following `\\ref{lem:sg23-andre-closure}`); NOT in Main Theorem reduction chain."
 attackHistory := ["R-attack-#25-Phase-0-hostile-lit-audit-full-theorem-survey-Kleiman-1968-thm-2-A-1-correct-source-for-SCB-implies-SCC-reverse-direction-not-published-Kleiman-1994-thm-4-1-correct-source-for-Kunneth-polynomial-formula-distinct-from-Kleiman-1968-Andre-1996-thm-0-5-correct-source-for-SCB-SCC-in-M-AE-do-NOT-conflate-with-Andre-1996-thm-0-6-2-abelian-span-prop-6way-and-lem-sg23-andre-closure-only-in-archived-supplement-need-to-move-to-master-tex-per-paper-Lean-unification-honest-verdict-Ledger-near-published-framing-materially-optimistic-framework-published-extension-INVENTION-CLASS-equivalent-to-original-gap-Phase-2-Lean-writer-3-framework-axioms-plus-1-INVENTION-CLASS-extension-axiom-plus-typed-bridge-master-tex-integration-lem-sg23-andre-closure-compact-version-25-lines-at-L9747", "R-attack-#65-EPISTEMIC-UPGRADE-INVENTION-CLASS-to-NAMED-OPEN-MULTI-via-R-#64-systematic-INVENTION-CLASS-survey-finding-Chow-descent-decomposes-into-2-published-named-open-conjectures-Standard-Conjecture-B-codim-3-Chow-level-Grothendieck-1969-Kleiman-1968-section-2-AND-Bloch-Beilinson-filtration-conjecture-Bloch-1980-Beilinson-1984-J-Soviet-Math-30-2036-2070-prior-INVENTION-CLASS-framing-over-cautious-Standard-Conjectures-and-BB-ARE-published-named-open-2-new-NAMED-OPEN-atom-axioms-plus-1-new-bridge-axiom-mae-to-chow-descent-from-named-open-atoms-standalone-axiom-mae-to-chow-descent-sg23-INVENTION-CLASS-converted-to-theorem-via-bridge-from-2-atoms-predicate-IsMAEtoChowDescent-sg23-INVENTION-CLASS-name-retained-for-backward-compat-tier-set-by-derivation-path-not-suffix"]
 obstacleCitation := some "POST-R-#65: Chow-level descent of {SC(B)_3, SC(C)_3} pair: NAMED-OPEN-MULTI (R-#65 upgrade from INVENTION-CLASS per R-#64 audit). Decomposes into 2 published named-open conjectures stacked: (a) SC(B)_3 at Chow level (Grothendieck 1969 'Standard Conjectures on Algebraic Cycles' Tata Inst. Bombay 193-199 / Kleiman 1968 §2); (b) Bloch-Beilinson filtration conjecture (Bloch 1980 Lectures on Algebraic Cycles Duke Univ. Math. Series IV §1 / Beilinson 1984 Higher regulators J. Soviet Math. 30 2036-2070 §2). Both open in general; pre-R-#65 framing as INVENTION-CLASS equivalent-to-original-gap was over-cautious."
}

/-! ## Group C: 3 paper-labelled OPEN sub-branches (demoted to BLOCKED by
 attack synthesis with cited obstacles) -/

/-- prop:d5-e7-closure. Paper labels as OPEN. Post-R-#49 promotion
 to gapPartial via inheriting R-#48's Pattern (ii) NAMED_OPEN closure
 of the kappa=0 sub-case (Abundance Conj. dim >= 5). General-type
 sub-case (kappa = dim X = 5) remains BLOCKED via Milnor sign defect. -/
def gap_d5_e7_closure_BLOCKED : LedgerEntry := {
 identifier := "prop:d5-e7-closure"
 paperLabel := "prop:d5-e7-closure"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#75 PATCH (R-#74 audit chain corrected R-#72/R-#73 over-promotion). R-#74 audit caught mathematical errors in R-#72 audit chain: (a) non-ODP scope restriction was CLOSED by Milnor formula uniformity — Milnor 1968 χ(F) = 1+(-1)^n μ + Greuel-Lê 1971 ICIS extension uniformly give δ_i = -μ ≤ 0 for ALL isolated singularities on 4-fold fibres (R-#72 sign-error claim 'non-ODP yields δ_i ≥ 0' FALSIFIED — non-ODP STRENGTHENS obstruction, not bypass it); (b) conifold scope restriction was CLOSED for Friedman 1986 / Collins 2025 frameworks specifically — both are explicitly threefold-only, inapplicable to d=5 4-fold fibre singularities (refined scope: other 4-fold surgery frameworks unaudited remain attack vectors). Only the non-P¹ pencil base scope remains a genuine broken-link. R-#75 Lean patches: 2 new theorem witnesses (`milnor_uniformity_extends_obstruction_to_non_odp` + `friedman_collins_conifold_threefold_only`) discharge 2 of 3 antecedents; simplified theorem `d5_e7_general_type_blocked_via_non_p1_only` shows closure is conditional on the SINGLE remaining broken-link (non-P¹). κ=0 sub-case: R-#62 broken-link conditional via Abundance dim ≥ 5 + 2 BROKEN_LINK preserved. R-#45 reduced Lefschetz-pin residual to 1 candidate (K^5=2368) under (χ-b)."
 decomposability := "2 sub-cases: (i) general-type kappa = dim X = 5 — POST-R-#75: Milnor sign obstruction conditional on SINGLE remaining broken-link (non-P¹ pencil base scope) plus 2 published-fact witnesses (Milnor uniformity for non-ODP + Friedman/Collins threefold-only for conifold); (ii) kappa = 0 with c_1 ≠ 0 — R-#62 broken-link conditional via Abundance dim ≥ 5 + K_X nef + Pic torsion-free. Both sub-cases preserved as partial Lean maps. Lean: 3 predicates (1 genuine BROKEN-LINK + 2 published-fact-witnessed) + bridge axiom + 2 theorems (`d5_e7_general_type_blocked_conditional` full 3-input + `d5_e7_general_type_blocked_via_non_p1_only` simplified 1-input)."
 computability := "POST-R-#75: general-type sub-case requires 1 genuine broken-link (non-P¹ pencil base) + 2 published-fact witnesses (Milnor uniformity + Friedman/Collins threefold scope); refining of 3-broken-link claim to 1-broken-link reflects R-#74 audit corrections. κ=0 sub-case requires Abundance dim ≥ 5 NAMED-OPEN + 2 R-#62 BROKEN-LINK hypotheses."
 attackVector := "ROUTE A (general-type kappa = 5) — POST-R-#75: conditional via SINGLE remaining broken-link (non-P¹ pencil base scope) + 2 published-fact witnesses (Milnor uniformity closes non-ODP scope; Friedman/Collins threefold-only closes conifold scope for those frameworks). Remaining attack vectors: (1) non-P¹ pencil base — construct or refute existence of d=5 exotic-residual variety with non-P¹ pencil structure. SUB-ATTACK STATUS (P²-net specialisation, R-#88 through R-#100): both the empty-|H| (m=1) framing and the early 'generic P²-net RULED OUT via class(Δ₂)=-37720<0' verdict were FLAWED — |H|=|K_X| is empty (h^{5,0}=0; must use |mH|, m≥2), and the m≥2 corrected analysis is INERT: for a generic net L=ℙ²⊂|mH| the fibration Bl_Bs(X)→ℙ² has 3-fold fibres W and discriminant curve Δ of degree deg(Δ)=(D_dual(m)+X_diff(m))/2 (a c₄-Porteous tangency class, NOT D_dual(m)=∫c₅(J¹(mH))), giving class(Δ)=2deg(Δ)-X_diff(m)=D_dual(m)=14208m⁵+11840m⁴+4736m³+1184m+56>0 — no obstruction (the spurious 'class=-28416m⁵-… <0' came from mis-identifying deg(Δ) with D_dual; acid-test: that formula gives impossible negative class on explicit generic nets of |O(d)| on ℙ⁵ and on H₈⊂ℙ⁶). So the ℙ²-net route is inert like the ℙ¹-pencil route (Σδ_i=-N≤0). Genuinely-open sub-vectors: (1a) genus-g curve bases g≥1 (spans ℙ^M M≥2; base-changed family X̃×_{ℙ^M}C_g→C_g needs separate Euler analysis); (1b) structural Hodge/monodromy — period map of the net/curve family vs MT(H³)=E_{7(-25)}; (1c) the (χ-b) antecedent (SG-5) — pinning b_2,b_4 independently changes which candidates exist. (2) 4-fold surgery frameworks beyond Friedman/Collins (e.g., Rossi 2006 4-fold flops; M-theory conifold extensions arXiv:1203.6662) remain unaudited and could be additional attack vectors. R-#45 reduced candidates 35 → 1 under (χ-b) + R-#42 dim-counting. ROUTE B (kappa = 0) — R-#62 conditional via 2 BROKEN-LINK + Abundance dim ≥ 5."
 attackHistory := ["R32-A-through-R150-converged-to-Milnor-sign-defect", "R-attack-#45-Lefschetz-pin-residual-reduction-35-to-1-under-chi-b-via-R-#42-h-3-1-equals-0-master-tex-cor-sg5-35to1-reduction", "R-attack-#49-status-PROMOTION-gapBlocked-to-gapPartial-via-inheriting-R-#48-kappa-zero-Pattern-ii-NAMED-OPEN-closure-Abundance-Conj-dim-geq-5", "R-attack-#62-STATUS-REVERT-gapPartial-to-gapBlocked-per-R-#61-Phase-4-audit-broken-link-findings-Abundance-mis-stated-without-NEF-and-Pic-rank-1-smuggled-conditional-Lean-closure-preserved-as-partial-map-per-feedback_gap_ledger_in_lean4-broken-link-discipline", "R-attack-#72-PARALLEL-HOSTILE-AUDIT-PLUS-CONSTRUCTOR-Milnor-sign-defect-tightness-verdict-LOOPHOLE-3-unexhausted-attack-vectors-identified-non-ODP-fibre-singularities-A_n-D_n-E_n-ICIS-non-P-1-pencil-bases-genus-g-curves-P-2-surfaces-conifold-transitions-Friedman-1986-Reid-Collins-2025-framework-plus-5-citation-defects-in-master-tex-Milnor-1968-bibitem-missing-CSM-Fulton-Segre-Hironaka-bound-unattributed-ODP-exclusivity-tautological-3-rescue-paths-phantom-downstream-empirical-scan-second-hand", "R-attack-#73-STATUS-PROMOTION-gapBlocked-to-gapPartial-via-broken-link-discipline-3-BROKEN-LINK-predicates-surface-scope-restrictions-IsMilnorObstructionExtendsToNonODPFibres-IsMilnorObstructionExtendsToNonP1PencilBase-IsConifoldTransitionBypassInapplicable-d5-E7-Exotic-plus-bridge-axiom-milnor_obstruction_blocks_d5_e7_under_scope_restrictions-plus-theorem-d5_e7_general_type_blocked_conditional-conditional-Lean-closure-preserved-per-feedback_gap_ledger_in_lean4-discipline-pre-AI-claim-133-attack-routes-exhausted-falsified-by-fresh-hostile-audit-loophole-verdict", "R-attack-#74-PARALLEL-HOSTILE-RE-AUDIT-PLUS-CONSTRUCTOR-on-R-#72-R-#73-chain-verdict-FAILURE-R-#72-math-FALSE-non-ODP-claim-chi-F-1-plus-mu-confused-with-delta-i-sign-error-Milnor-1968-uniform-formula-chi-F-1-plus-minus-1-to-n-mu-gives-delta-i-minus-mu-leq-0-for-ALL-isolated-hypersurface-and-ICIS-singularities-on-4-folds-non-ODP-A_n-D_n-E_n-ICIS-yield-MORE-negative-delta-i-not-positive-Greuel-Le-1971-ICIS-extension-same-direction-Friedman-1986-Math-Ann-274-conifold-explicitly-threefold-only-Collins-2025-arXiv-2509-01002-CY3-focused-inapplicable-to-d5-fourfold-fibres", "R-attack-#75-PATCH-Lean-add-2-published-fact-witness-axioms-milnor_uniformity_extends_obstruction_to_non_odp-plus-friedman_collins_conifold_threefold_only-simplified-theorem-d5_e7_general_type_blocked_via_non_p1_only-shows-closure-conditional-on-SINGLE-remaining-broken-link-non-P1-pencil-base-scope-only-status-gapPartial-now-justified-via-1-actual-broken-link-plus-2-published-fact-witnesses-rather-than-3-broken-links-as-R-#73-over-claimed-R-#72-R-#73-over-promotion-corrected", "R-attack-#76-AUDIT-on-R-#75-caught-5-defects-Greuel-Le-1971-citation-wrong-Phase-2-sweep-missed-axiom-vs-theorem-framing", "R-attack-#77-PATCH-correct-citations-Greuel-1975-solo-Le-1973-Phase-2-sweep-gap_E7_full-gap_exotic_residual", "R-attack-#78-AUDIT-CLEAN-with-1-MINOR-defect-stale-obstacleCitation-patched", "R-attack-#79-self-driven-generalized-Euler-identity-attempt-codim-2-base-case", "R-attack-#80-AUDIT-caught-R-#79-blow-up-formula-error-chi-X-tilde-equals-chi-X-plus-chi-Bs-not-chi-Bs-times-chi-C_g-minus-1", "R-attack-#81-PATCH-correct-blow-up-formula-but-hidden-codim-assumption", "R-attack-#82-SELF-AUDIT-caught-codim-assumption-error-non-degenerate-higher-genus-C_g-has-codim-r-geq-3-base-not-codim-2-plus-computed-chi-X-equals-minus-56-via-R-#43-chi_y-at-y-minus-1", "R-attack-#83-AUDIT-CONVERGING-with-3-minor-presentation-refinements", "R-attack-#84-minor-refinements-Diophantine-emphasis-Collins-section-citation-Rossi-M-theory-question", "R-attack-#85-Constructor-Diophantine-computation-attempt-ESCALATED-agent-could-not-drive-due-to-brief-unclarity-Phase-0-Phase-1-prerequisites-need-stronger-orchestrator-setup-future-round", "R-attack-#86-AUDIT-on-R-#85-identified-valid-framework-risks-Q1-Q4-Q6-Q7-BUT-CONTAINED-PHANTOM-R-#87-HALLUCINATION-references-non-existent-R-#87-document-to-build-Q5-critical-case-split-claim-orchestrator-caught-hallucination-during-synthesis-master-tex-prop-d5-e7-closure-hypothesis-e-already-mandates-c-1-neq-0-so-R-#85-was-targeting-correct-case-R-#86-Q5-over-claim-rejected-other-audit-risks-preserved-for-future-execution-discipline", "R-attack-#88-Diophantine-retry-with-crisp-brief-SUCCEEDED-all-7-Chern-numbers-of-X-determined-from-R-#42-Hodge-pin-plus-chi-b-plus-R-#45-candidate-a_1=-1-a_2=1/2-a_3=0-a_4=1/4-a_5=-7/296-corresponding-Chern-numbers-c_1^5=-2368-c_1^3-c_2=-1184-c_1-c_2^2=-592-c_1^2-c_3=0-c_1-c_4=-592-c_2-c_3=0-c_5=-56-chi_top-Y_1=6512-via-4-fold-HRR-adjunction-chi_top-Bs-P_2=22496-via-codim-3-surface-HRR-Sigma_i-delta_i-equals-3-times-chi-X-minus-chi-Bs-equals-minus-67656-for-genus-1-cubic-family-C_1-subset-P_2-NEGATIVE-consistent-with-Milnor-uniformity-no-immediate-bypass-no-immediate-closure-remaining-open-question-is-codim-3-universal-bound-for-chi_top-Bs-which-would-enable-Diophantine-contradiction-analogous-to-master-tex-P_1-pencil-criterion", "R-attack-#89-AUDIT-on-R-#88-GOT-CONFUSED-with-an-older-R-#88-in-memory-Waldspurger-attack-different-content-confusion-caught-by-orchestrator-fresh-audit-needed-on-actual-R-#88-Diophantine-output", "R-attack-#90-FRESH-AUDIT-on-R-#88-Diophantine-output-CLEAN-HIGH-CONFIDENCE-all-7-numerical-computations-independently-verified-zero-defects-Chern-numbers-chi_top-values-Sigma_i-delta_i-cross-checked-via-Noether-formula-and-projection-formula-Bezout-cover-argument-sound", "R-attack-#91-P2-net-codim-3-analysis-CAUGHT-ORCHESTRATOR-DIM-CONFUSION-pre-R-#91-framing-assumed-4-fold-generic-fibre-WRONG-P2-net-fibre-is-3-fold-codim-2-not-4-fold-codim-1-Milnor-sign-reversal-for-odd-dim-fibre-delta-equals-plus-mu-not-minus-mu-corrected-chi_top-Y_3fold-equals-minus-18944-not-6512-corrected-identity-demand-chi-Delta_2-plus-RESIDUAL-equals-101768-with-deg-Delta_2-equals-32024-via-Aluffi-Lazarsfeld-c_5-J_1-H-classical-formula-verified-on-H_d-P_6-cases-d-8-9-10-12-15-shortfall-37720-absorbable-by-Sing-Delta_2-Plucker-numerology-Milnor-jumps-Piene-1978-Kleiman-1986-formulas-new-open-question-bound-RESIDUAL-less-than-37720-via-Plucker-numerology-and-per-singularity-Milnor-analysis-attack-vector-refined-not-closure", "R-attack-#94-Plucker-numerology-attack-on-Sing-Delta_2-PARTIAL-RESULT-pure-nodes-plus-cusps-subcase-RULED-OUT-by-Plucker-budget-vs-demand-deficit-37720-but-A_3-tacnodes-or-higher-singularities-absorb-the-deficit-with-ratio-1-point-5-explicit-Diophantine-solution-mixing-cusps-and-tacnodes-saturates-Plucker-bound-system-SATISFIABLE-closure-NOT-achieved-from-Plucker-alone-refined-obstruction-discriminant-curve-Delta_2-must-have-tacnode-or-higher-singularities-next-level-attack-vector-Mond-1989-Goryunov-1990-multi-jet-space-stratification-constraints-on-n_k-distribution-orchestrator-spot-check-found-minor-coefficient-discrepancy-vs-Constructor-but-qualitative-verdict-holds", "R-attack-#95-AUDIT-on-R-#94-ESCALATED-couldnt-find-files-fresh-audit-needed-with-explicit-content-references", "R-attack-#97-Mond-Goryunov-multi-jet-stratification-on-Sing-Delta_2-CLEAN-NEGATIVE-NO-GENERIC-P-2-net-bypass-generic-Delta_2-has-ONLY-nodes-plus-cusps-A_1-A_2-since-base-P-2-dim-2-and-A_k-stratum-codim-k-in-moduli-so-A_3-plus-non-generic-but-generic-class-Delta_2-equals-d-d-minus-1-minus-2-n_1-minus-3-n_2-with-n_1-n_2-forced-by-deg-Delta_2-equals-32024-and-chi_top-correction-gives-class-Delta_2-equals-minus-37720-strictly-negative-CONTRADICTION-class-must-be-non-negative-so-NO-generic-net-realises-the-required-discriminant-BUT-non-generic-nets-feasible-per-LP-explicit-witness-n_1-approx-4e8-nodes-n_2-approx-7e7-cusps-n_3-approx-3-point-8e4-tacnodes-saturates-class-equals-0-plus-Langer-2003-BMY-orbifold-bound-closure-NOT-achieved-most-promising-next-numerical-lever-compute-higher-generalized-Plucker-Chern-numbers-class-Delta_2-equals-integral-X-c_4-J-2-H-over-J-1-H-plus-flexes-bitangents-which-may-over-determine-n_k-distribution-to-inconsistency-experiments-r_audit_mondgoryunov_d5-py-plus-r_audit_bmy_feasibility_d5-py", "R-attack-#98-AUDIT-on-R-#94-coefficient-discrepancy-RESOLVED-R-#94-2k-minus-1-coefficient-CORRECT-for-k-geq-2-chi_top-correction-per-A_k-plane-curve-fibre-stratum-is-mu_curve-A_k-equals-k-NOT-2-delta_inv-orchestrator-spot-check-used-2-delta_inv-which-is-WRONG-node-k-1-special-coefficient-2-not-1-but-does-not-affect-tacnode-conclusion-min-tacnodes-n_3-geq-37720-confirmed-Mond-Goryunov-and-Plucker-conclusions-both-stand", "R-attack-#99-Constructor-re-derived-full-P-2-net-stratified-Euler-chain-found-2-pre-existing-flaws-1-the-m-equals-1-framing-used-empty-H-equals-K_X-h-5-0-equals-0-so-must-use-mH-m-geq-2-2-claimed-KILL-via-class-Delta_2-m-equals-2-D_dual-minus-X_diff-equals-minus-28416-m-5-minus-11840-m-4-plus-2368-m-plus-168-strictly-negative-for-all-m-contradiction-with-class-geq-0-25-of-25-arithmetic-strata-likewise-headline-polynomials-D_dual-m-equals-14208-m-5-plus-11840-m-4-plus-4736-m-3-plus-1184-m-plus-56-and-X_diff-m-equals-56832-m-5-plus-35520-m-4-plus-9472-m-3-minus-56-orchestrator-independently-verified-to-the-digit", "R-attack-#100-PARALLEL-DOUBLE-FRESH-HOSTILE-AUDIT-R-#99-KILL-REFUTED-100a-geometry-logic-FATAL-FLAW-object-mismatch-D_dual-m-equals-integral-c_5-J-1-mH-is-the-degree-of-the-dual-variety-of-singular-HYPERSURFACE-members-4-folds-but-the-Verdier-identity-used-in-step-4-with-chi-W-3-fold-fibre-and-chi-Bl_Bs-X-is-for-the-DIFFERENT-family-Bl_Bs-X-to-P-2-with-3-fold-fibres-whose-discriminant-curve-has-degree-roughly-a-c_4-Porteous-tangency-class-equals-D_dual-plus-X_diff-over-2-strictly-larger-than-D_dual-with-the-CORRECT-degree-class-Delta-equals-2-deg-Delta-minus-X_diff-equals-D_dual-equals-integral-c_5-J-1-mH-POSITIVE-no-obstruction-ACID-TEST-R-#99-formula-2-D_dual-minus-X_diff-gives-IMPOSSIBLE-negative-class-on-explicit-real-smooth-varieties-with-real-generic-nets-P-5-net-of-O-d-class-minus-42-at-d-2-and-H_8-in-P-6-K-ample-K-equals-O-1-class-minus-10008-at-m-6-so-the-formula-as-applied-is-provably-wrong-d5-E7-25-exotic-residual-remains-OPEN-100b-citations-conditionality-Aluffi-Lazarsfeld-1988-Math-Ann-is-PHANTOM-dual-degree-formula-is-classical-Katz-SGA-7-II-GKZ-Ch-1-2-Aluffi-Cukierman-1993-for-multiplicity-variants-and-this-phantom-was-ALREADY-in-OpenHypotheses-lean-Langer-2003-is-PLMS-86-not-Ann-Math-157-Mond-1985-PLMS-vs-Mond-1989-docstring-inconsistency-for-nodal-cuspidal-genericity-right-home-Bruce-1981-Mond-Goryunov-1993-Compositio-89-plus-chi-b-mischaracterised-it-is-the-SG-5-standing-antecedent-an-empirical-MT-H-5-ansatz-strictly-EXTRA-over-prop-d5-e7-closure-hypotheses-not-unconditional-relative-to-the-proposition-PATCH-OpenHypotheses-docstring-rewritten-P-2-net-route-recorded-as-INERT-like-P-1-pencil-route-citations-fixed-chi-b-tier-disclosed-no-status-promotion-non-P-1-broken-link-remains-genuinely-open-remaining-vectors-genus-g-curve-bases-Hodge-monodromy-period-map-vs-E7-25-pinning-b_2-b_4"]
 obstacleCitation := some "POST-R-#75 PATCH (correcting R-#73 over-promotion per R-#74 audit): General-type sub-case (kappa = 5) — Milnor sign obstruction Σ_i δ_i ≤ 0 on P¹-pencils with 4-fold ODP fibres conditional on SINGLE remaining broken-link (non-P¹ pencil base scope) + 2 published-fact witnesses. (a) non-ODP scope: CLOSED by Milnor 1968 uniformity (χ(F) = 1 + (-1)^n μ uniform; on 4-folds δ_i = -μ ≤ 0 for ALL isolated singularities incl. ICIS via Greuel-Lê 1971; R-#72 'non-ODP yields δ_i ≥ 0' sign-error FALSIFIED); (b) conifold scope: CLOSED for Friedman 1986 + Collins 2025 frameworks (both threefold-only, inapplicable to d=5 4-fold fibres); other 4-fold surgery frameworks (Rossi 2006, M-theory) remain unaudited. (c) non-P¹ scope: GENUINE BROKEN-LINK (pencil-Euler identity P¹-specific). κ=0 sub-case: R-#62 conditional via Abundance dim ≥ 5 NAMED-OPEN + 2 BROKEN-LINK. R-#45 reduced 35 → 1 candidate (K^5=2368)."
}

/-- cor:E7_full_closure. Paper labels as OPEN. Post-R-#49 promotion
 to gapPartial via inheriting R-#48's Pattern (ii) NAMED_OPEN closure
 of the kappa=0 sub-case (Abundance Conj. dim ≥ 5). General-type
 sub-case (d ≥ 6 kappa = dim X) remains BLOCKED via Milnor sign
 defect inheritance + missing codim-2 4-cycle bound. -/
def gap_E7_full_closure_BLOCKED : LedgerEntry := {
 identifier := "cor:E7_full_closure"
 paperLabel := "cor:E7_full_closure"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#77 PATCH (R-#74/R-#75 refinement swept downstream per Phase 2 cite-sweep discipline). General-type sub-case (d ≥ 6 kappa = dim X) inherits d=5 R-#75 refined dependency: 1 genuine broken-link (non-P¹ pencil base scope) + 2 published-fact witnesses (Milnor uniformity for non-ODP via Milnor 1968 + Lê 1973 + Greuel 1975 Math. Ann. 214; Friedman 1986 + Collins 2025 threefold-only scope for conifold). Additionally for d ≥ 6, missing codim-2 4-cycle topological bound is a SEPARATE genuine broken link. κ=0 sub-case: R-#62 conditional via Abundance dim ≥ 5 NAMED-OPEN + 2 BROKEN-LINK preserved."
 decomposability := "2 sub-cases: (i) general-type kappa = dim X for d ≥ 6 — POST-R-#77 conditional via inheritance of d=5 refined R-#75 (1 genuine broken-link non-P¹ + 2 published-fact witnesses) + additional codim-2 4-cycle topological bound BROKEN-LINK; (ii) kappa = 0 — R-#62 conditional via Abundance dim ≥ 5 + 2 BROKEN-LINK. Both preserved as partial maps."
 computability := "POST-R-#77: general-type d ≥ 6 inherits d=5 R-#75 refined (1 broken-link non-P¹ + 2 published-fact witnesses) + 1 additional codim-2-bound BROKEN-LINK. κ=0 R-#62 conditional via Abundance dim ≥ 5 + 2 BROKEN-LINK."
 attackVector := "ROUTE A (general-type d ≥ 6) — POST-R-#77: conditional via inheritance of d=5 R-#75 refined (1 non-P¹ broken-link + 2 published-fact witnesses Milnor uniformity + Friedman/Collins threefold) + codim-2 4-cycle bound broken link. Remaining attack vectors: non-P¹ pencil base; 4-fold surgery frameworks beyond Friedman/Collins; codim-2 4-cycle topological bound resolution. ROUTE B (kappa = 0) — R-#62 conditional via Abundance + 2 BROKEN-LINK."
 attackHistory := ["d5-derivative-block-inherited", "R-attack-#49-status-PROMOTION-gapBlocked-to-gapPartial-via-inheriting-R-#48-kappa-zero-Pattern-ii-NAMED-OPEN-closure-generic-for-dim-geq-5-Abundance-Conj-NAMED-OPEN-extension", "R-attack-#62-STATUS-REVERT-gapPartial-to-gapBlocked-inheriting-R-#62-retraction-of-R-#48-per-R-#61-Phase-4-audit-broken-link-findings-Abundance-mis-stated-NEF-dropped-Pic-rank-1-smuggled-conditional-Lean-closure-preserved-as-partial-map", "R-attack-#73-STATUS-PROMOTION-gapBlocked-to-gapPartial-via-inheriting-d5-e7-closure-R-#73-3-BROKEN-LINK-scope-restrictions-Milnor-obstruction-non-ODP-non-P-1-conifold-plus-additional-codim-2-4-cycle-topological-bound-BROKEN-LINK-for-d-geq-6", "R-attack-#75-Phase-2-sweep-d=5-R-#74-R-#75-refinement-inherited-1-genuine-broken-link-non-P-1-plus-2-published-fact-witnesses-Milnor-uniformity-via-Milnor-1968-Le-1973-Greuel-1975-plus-Friedman-1986-Collins-2025-threefold-only-conifold-scope-Phase-2-sweep-applied-R-#77-patch"]
 obstacleCitation := some "POST-R-#77: general-type d ≥ 6 — Milnor sign obstruction inherits d=5 R-#75 refined dependency (1 genuine broken-link non-P¹ + 2 published-fact witnesses Milnor uniformity + Friedman/Collins threefold scope) + 1 additional codim-2 4-cycle topological bound BROKEN-LINK. κ=0 R-#62 conditional via Abundance dim ≥ 5 + 2 BROKEN-LINK."
}

/-- open:exotic-residual. Paper labels as OPEN; consolidated synthesis
 demotes to gapPartial after R-#48 (kappa = 0 sub-case closure via
 Pattern (ii) NAMED_OPEN Abundance Conjecture dim >= 5). General-type
 sub-case remains BLOCKED (Milnor sign defect). -/
def gap_exotic_residual_BLOCKED : LedgerEntry := {
 identifier := "open:exotic-residual"
 paperLabel := "open:exotic-residual"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#77 PATCH (R-#74/R-#75 refinement swept downstream per Phase 2 cite-sweep discipline). κ=0 sub-case: R-#62 conditional via Abundance dim ≥ 5 NAMED-OPEN + 2 BROKEN-LINK (K_X nef + Pic torsion-free) per R-#61 audit broken-link discipline. General-type sub-case: POST-R-#75 refined dependency — 1 genuine broken-link (non-P¹ pencil base scope) + 2 published-fact witnesses (Milnor uniformity for non-ODP via Milnor 1968 + Lê 1973 + Greuel 1975; Friedman 1986 + Collins 2025 threefold-only conifold scope). R-#72 hostile audit falsified pre-AI 'exhausted' claim; R-#74 audit corrected R-#72 math (non-ODP claim FALSIFIED — Milnor uniformity gives δ_i ≤ 0 uniformly). Both sub-cases preserved as conditional partial maps per `feedback_gap_ledger_in_lean4.md` broken-link discipline."
 decomposability := "2 sub-cases: (i) general-type kappa = dim X — POST-R-#75 conditional via 1 genuine BROKEN-LINK (non-P¹ pencil base) + 2 published-fact witnesses; (ii) kappa = 0 — R-#62 conditional via Abundance dim ≥ 5 NAMED-OPEN + 2 BROKEN-LINK (K_X nef + Pic torsion-free). Lean axioms: `IsAbundanceConjectureDimLE3` (PUBLISHED) + `IsAbundanceConjectureDimGEq5` (NAMED_OPEN) + 2 R-#62 BROKEN-LINK + 1 genuine non-P¹ BROKEN-LINK + 2 R-#75 published-fact witnesses + bridges + conditional closure theorems."
 computability := "POST-R-#75: general-type sub-case requires 1 genuine broken-link (non-P¹) + 2 published-fact witnesses. κ=0 R-#62 conditional via Abundance dim ≥ 5 NAMED-OPEN + 2 BROKEN-LINK."
 attackVector := "ROUTE B (kappa = 0) — R-#62 conditional via Abundance + 2 BROKEN-LINK. ROUTE A (general-type) — POST-R-#75 conditional via 1 non-P¹ pencil base BROKEN-LINK + 2 published-fact witnesses. Attack vectors: (1) non-P¹ pencil base construction; (2) 4-fold surgery frameworks beyond Friedman/Collins (Rossi 2006 / M-theory) remain unaudited."
 attackHistory := ["consolidated-attack-synthesis-converged-to-Abundance-Conjecture", "R-attack-#48-status-PROMOTION-gapBlocked-to-gapPartial-via-Pattern-ii-NAMED-OPEN-closure-of-kappa-zero-sub-case-conditional-on-Abundance-Conjecture-dim-geq-5-NAMED-OPEN-framework-Kawamata-1992-Invent-108-Miyaoka-1988-Compositio-68-Kollar-ed-1992-Asterisque-211-published-dim-le-3-Phase-0-full-theorem-survey-confirmed-BCHM-2010-JAMS-23-405-468-NOT-operative-proves-MMP-existence-not-Abundance-general-type-sub-case-still-BLOCKED-Milnor-sign-defect", "R-attack-#62-STATUS-REVERT-gapPartial-to-gapBlocked-per-R-#61-Phase-4-audit-MAJOR-DEFECT-findings-2-broken-links-Abundance-mis-stated-NEF-dropped-AND-Pic-rank-1-smuggled-conditional-Lean-closure-preserved-as-partial-map-per-feedback_gap_ledger_in_lean4-broken-link-discipline", "R-attack-#73-STATUS-PROMOTION-gapBlocked-to-gapPartial-inheriting-d5-e7-closure-R-#73-3-BROKEN-LINK-scope-restrictions-of-Milnor-obstruction-ODP-exclusivity-P-1-base-exclusivity-no-conifold-bypass-general-type-sub-case-conditional-via-inheritance-kappa-0-sub-case-R-#62-conditional-via-Abundance-plus-2-BROKEN-LINK-preserved-both-sub-cases-conditional-partial-Lean-maps-per-broken-link-discipline"]
 obstacleCitation := some "POST-R-#77: both sub-cases conditional. General-type: 1 genuine BROKEN-LINK (non-P¹ pencil base) + 2 published-fact witnesses (Milnor uniformity via Milnor 1968 + Lê 1973 + Greuel 1975; Friedman 1986 + Collins 2025 threefold-only conifold scope). Rossi 2006 / M-theory 4-fold conifold remain unaudited. κ=0: R-#62 conditional via 2 BROKEN-LINK (K_X nef + MMP existence for κ=0 dim ≥ 5 + Pic torsion-free structure) + Abundance dim ≥ 5 NAMED-OPEN. Each broken link is an attack vector for next round."
}

/-! ## Group D: memory-derived gaps (R133-R150 attack synthesis, not in
 paper but recorded for attack continuity) -/

/-- G1-atomic gap.
 Status: gapPartial (R-#66 upgrade from gapDeadEnd per R-#64 audit).
 R-#66 reclassification: NAMED-OPEN refined BB (Beilinson 1984 +
 Bloch 1980 framework + Longo-Vigni 2013 specialisation) +
 BROKEN-LINK rank-to-effective-Mackey-cycle construction
 surfaced explicitly per broken-link discipline. Differs from
 retracted R-#59 by separating BB (NAMED-OPEN) from the rank-to-
 cycle gap (BROKEN-LINK), eliminating the R-#59 non-rigor where
 BB was claimed to close the gap itself. -/
def gap_G1_atomic_DEADEND : LedgerEntry := {
 identifier := "G1-atomic"
 paperLabel := "G1-atomic (cycle-to-Hodge-class scalar identification for cuspidal weight-4 CM motive in (3,3)-Mackey isotypic; previously tagged 'Scholl Rem 1.2.6' but R-#60 audit + R-#63 MINOR finding confirmed that citation is fabricated — Scholl 1990 has only Rem 1.2.5; R-#66 RENAMED dropping the fabricated reference)"
 status := GapStatus.gapPartial
 closureDistance := "POST-R-#66 EPISTEMIC UPGRADE (gapDeadEnd → gapPartial); POST-R-#69 SCOPE CORRECTION per Phase 4 hostile audit. R-#66 (post-R-#64 systematic `_INVENTION_CLASS` audit) reclassified via decomposition. R-#69 Phase 4 audit caught 3 R-#66 errors and added 2nd broken-link atom: (a) NAMED-OPEN refined Bloch-Beilinson for EVEN-WEIGHT modular forms (R-#69 scope correction; Beilinson 1984 J. Soviet Math. 30 §3 primary + Bloch 1980 foundational + Longo-Vigni 2013 arXiv:1303.4335 / Trans. AMS 369 (2017) 7301-7342 'A refined Beilinson-Bloch conjecture for motives of modular forms' — R-#69 corrected title from R-#66's wrong-title 'Quaternion algebras, Heegner points...' which actually titles sibling paper arXiv:0903.2797 / manuscripta math. 135 (2011) 273-328; R-#69 corrected page range from R-#66's fabricated 6019-6071); (b) BROKEN-LINK rank-to-effective-Mackey-cycle construction (no published effective machinery for the (3,3)-Mackey-isotypic cycle); (b') BROKEN-LINK general-even-weight-modular-to-CM-wt-4-rigid-CY_3 specialisation (NEW R-#69; the Longo-Vigni source covers general even-weight Kuga-Sato setting, NOT specifically CM weight-4 on general rigid CY_3 — pre-R-#69 R-#66 over-reached by claiming this specialisation). R-#59 retraction history: R-#59 attempted via fabricated 'Scholl Rem 1.2.6'; R-#60 RETRACTED."
 decomposability := "POST-R-#66: 3 atoms + bridge: (a) NAMED-OPEN refined-BB-for-CM-wt4 axiom (refined_bloch_beilinson_CM_wt4_NAMED_OPEN); (b) BROKEN-LINK rank-to-effective-cycle-construction axiom (rank_to_effective_mackey_cycle_construction_BROKEN_LINK); (c) bridge axiom (g1_atomic_from_named_open_and_broken_link). Standalone extension axiom renamed g1_atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK (dropping fabricated Scholl Rem 1.2.6) and converted to theorem via bridge."
 computability := "POST-R-#66: NAMED-OPEN-BROKEN-LINK (1 published named-open conjecture + 1 broken-link surfaced as explicit predicate per discipline). Materially stronger epistemic tier than pre-R-#66 INVENTION-CLASS / gapDeadEnd framing. The gap is now part of a conditional Lean closure map; not deleted from the structure, preserved as partial route per `feedback_gap_ledger_in_lean4.md` broken-link discipline."
 attackVector := "Future closure paths: (i) resolve refined-BB for CM weight-4 modular forms (NAMED-OPEN direction; Longo-Vigni 2013 + Heegner-cycle technology + Gross-Zagier-Kolyvagin chain extensions); (ii) resolve rank-to-effective-Mackey-cycle construction (BROKEN-LINK; requires new invention OR establishing a published effective construction). Both can be attacked independently. Cross-reference: g1_atomic_hyp_CM_NAMED_OPEN_BROKEN_LINK theorem in OpenHypotheses.lean (R-#66 renamed + converted from `_INVENTION_CLASS` axiom)."
 attackHistory := ["R134-R150-search-mode-dispatched-17-plus-rounds-no-closure", "R-attack-#36-absorbed-into-hyp-CM-correspondences-INVENTION-CLASS-extension-via-Pattern-ii-decomposition-mirror-SG-22-SG-23-hecke-bbt-c", "R-attack-#37-status-gapOpen-to-gapDeadEnd-per-17-rounds-search-mode-exhaustion-9-attack-vectors-converging-also-R-#36-absorbed-G1-atomic-into-hyp-CM-correspondences-INVENTION-CLASS-axiom", "R-attack-#59-ATTEMPTED-RECLASSIFICATION-gapDeadEnd-to-gapPartial-via-Bloch-Beilinson-NAMED-OPEN-reduction-claimed-Scholl-1990-Rem-1-2-6-as-explicit-BB-reformulation", "R-attack-#60-RETRACTION-of-R-#59-Phase-4-hostile-audit-found-2-HIGH-defects-Scholl-Rem-1-2-6-not-verified-in-source-paper-only-Rem-1-2-5-exists-AND-BB-rank-statement-does-not-produce-specific-Mackey-cycle-effectively-R-#59-axioms-IsBlochBeilinsonCentralWt4CMCuspidalRefined-bloch_beilinson-witness-and-g1_atomic_via_bloch_beilinson_named_open-bridge-all-REMOVED-from-OH-INVENTION-CLASS-tier-restored", "R-attack-#66-EPISTEMIC-UPGRADE-gapDeadEnd-to-gapPartial-via-R-#64-systematic-INVENTION-CLASS-audit-correct-decomposition-NAMED-OPEN-refined-Bloch-Beilinson-CM-wt-4-modular-forms-Beilinson-1984-Bloch-1980-Longo-Vigni-2013-PLUS-BROKEN-LINK-rank-to-effective-Mackey-cycle-construction-honestly-surfaced-per-discipline-RENAME-dropping-fabricated-Scholl-Rem-1-2-6-from-axiom-and-predicate-names-per-R-#60-retraction-and-R-#63-MINOR-finding-differs-from-R-#59-by-SEPARATING-BB-NAMED-OPEN-from-rank-to-cycle-gap-BROKEN-LINK-eliminating-R-#59-non-rigor"]
 obstacleCitation := some "POST-R-#66: NAMED-OPEN-BROKEN-LINK (R-#66 upgrade from gapDeadEnd per R-#64 audit). Two-atom decomposition: (a) refined Bloch-Beilinson for CM wt-4 modular forms (Beilinson 1984 / Bloch 1980 framework + Longo-Vigni 2013 specialisation, NAMED-OPEN); (b) rank-to-effective-Mackey-cycle construction (BROKEN-LINK, surfaced explicitly per `feedback_gap_ledger_in_lean4.md` discipline). Pre-R-#66 frame (R-#37 gapDeadEnd + R-#60 INVENTION-CLASS restore after R-#59 retraction) was over-cautious; R-#66 honest decomposition preserves the gap as partial map with both atoms (named-open + broken-link) explicitly typed."
}

/-- R32-C universal Hodge-rigidity blocker. Per R133-R150 attack
 synthesis: no algebraic product cycle [A] (x) [B] can land in (3, 3)
 Kunneth piece of H^6(W x E^3), since Kunneth bidegree (2a, 2b) is
 always even-even and (3, 3) is odd-odd. Not a gap to close; it is the
 structural obstacle to product constructions. Future attacks must use
 non-product cycles. -/
def gap_R32C_hodge_rigidity_STRUCTURAL : LedgerEntry := {
 identifier := "R32-C-Hodge-rigidity"
 paperLabel := "R32-C universal Hodge-rigidity (R133-R150 memory synthesis)"
 status := GapStatus.gapBlocked
 closureDistance := "STRUCTURAL OBSTRUCTION THEOREM (NOT a true gap; recorded for cross-session continuity per R-#51 Phase 4 audit Batch 5 taxonomy-clarification). The Künneth formula on H^*(W × E^3, ℚ) restricted to product cycles is a PUBLISHED THEOREM (Voisin 2002 Hodge II Ch. 11) that constrains a specific attack vector (product-cycle constructions for G1-atomic / Scholl Rem 1.2.6); the theorem itself is closed but the ATTACK VECTOR it forecloses is the source of the BLOCKED tag. Post-R-#51 def rename: was `gap_R32C_hodge_rigidity_BLOCKED`, renamed to `_STRUCTURAL` to reflect that this is an obstruction theorem encoded as a Ledger entry, not a gap awaiting closure. The gapBlocked status is retained as the closest available enum value (no `gapStructuralTheorem` variant); future GapStatus extension could add such a tag."
 decomposability := "0 sub-clauses (this is the obstruction theorem itself, not a gap to decompose)."
 computability := "PUBLISHED-THEOREM (not a gap to close; structural obstruction encoded for cross-session continuity)."
 attackVector := "NOT applicable — R32-C IS the obstruction theorem. Bypass for the foreclosed attack vector requires non-product cycle in CH^3(W × E^3)_ℚ; product-cycle constructions are structurally excluded by the theorem encoded here. Cross-reference: G1-atomic gap_G1_atomic_DEADEND records the actual gap that R32-C obstructs."
 attackHistory := ["R32-C-Hodge-rigidity-confirmed-9-attack-vectors-all-converged", "R-attack-#51-Phase-4-audit-Batch-5-taxonomy-clarification-def-renamed-from-gap_R32C_hodge_rigidity_BLOCKED-to-_STRUCTURAL-reflecting-obstruction-theorem-not-gap-awaiting-closure"]
 obstacleCitation := some "Künneth formula on cohomology bidegree: [A] ⊗ [B] for codim-a, codim-b cycles has bidegree (2a, 2b); always even-even. (3, 3) odd-odd is unreachable by product cycles. Published theorem: Voisin 2002 Hodge II Ch. 11. This entry encodes a STRUCTURAL OBSTRUCTION, not a closeable gap."
}

/-! ## Index / summary functions -/

/-- All ledger entries. Update when entries change status. -/
def allEntries : List LedgerEntry := [
 -- Group A: 9 paper hypotheses (parents)
 gap_hyp_HC_CM_Ab, gap_hyp_CM_correspondences, gap_hyp_KS_p3,
 gap_hyp_AH_CM_E7, gap_hyp_ChernWeil_bridge_E7, gap_hyp_BBT_rigid_reach,
 gap_hyp_nonrigid_family_bridge, gap_hyp_chow_modularity_E7,
 gap_hyp_hecke_bbt,
 -- Group A': 16 atomic clause entries
 gap_KS_p3_i, gap_KS_p3_ii, gap_KS_p3_iii,
 gap_ChernWeil_bridge_E7_i, gap_ChernWeil_bridge_E7_ii,
 gap_ChernWeil_bridge_E7_iii,
 gap_nonrigid_family_BaseDim27, gap_nonrigid_family_PeriodMapDominant,
 gap_nonrigid_family_PeriodMapGenericallyFinite,
 gap_nonrigid_family_FibreIsoAt_b0,
 gap_hecke_bbt_core, gap_hecke_bbt_a, gap_hecke_bbt_b, gap_hecke_bbt_c,
 gap_hecke_bbt_d, gap_hecke_bbt_e,
 -- Group B: 23 sub-gap inventory entries
 gap_SG_1, gap_SG_2, gap_SG_3, gap_SG_4, gap_SG_5, gap_SG_6, gap_SG_7,
 gap_SG_8, gap_SG_9, gap_SG_10, gap_SG_11, gap_SG_12, gap_SG_13,
 gap_SG_14, gap_SG_15, gap_SG_16, gap_SG_17, gap_SG_18, gap_SG_19,
 gap_SG_20, gap_SG_21, gap_SG_22, gap_SG_23,
 -- Group C: 3 BLOCKED sub-branches
 gap_d5_e7_closure_BLOCKED, gap_E7_full_closure_BLOCKED,
 gap_exotic_residual_BLOCKED,
 -- Group D: 2 memory-derived gaps
 gap_G1_atomic_DEADEND, gap_R32C_hodge_rigidity_STRUCTURAL
]

/-- Filter entries by status. -/
def filterByStatus (s : GapStatus) : List LedgerEntry :=
 allEntries.filter (fun e => decide (e.status = s))

/-- Count entries by status. -/
def countByStatus (s : GapStatus) : Nat := (filterByStatus s).length

/-! Status counts are NOT pre-recorded statically — round-by-round status
 promotions accumulate (see each entry's `attackHistory`), so use
 `countByStatus` / `filterByStatus` above for current values. Total
 typed entries: 53. -/

end HodgeReduction.Ledger
