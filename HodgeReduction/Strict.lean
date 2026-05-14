import Mathlib.Data.Nat.Defs

/-
# HodgeReduction.Strict — strict Cat 1-3 ATOMIC MINIMAL UNITS discipline

Proof-stage formalization of the Mumford-Tate reduction of the Hodge Conjecture
under the canonical 4-input-category × 6-tier-status discipline (per
`feedback_gap_ledger_in_lean4.md` 2026-05-13).

## P25 audit-driven consolidation (2026-05-14)

P23 → P24 Phase 4 audit caught 5 fresh violations: invented intermediate
carriers without paper anchor (N1), discarded proof step creating phantom
chain (N2), 3-input axiom (N3), decorative Cat 1 (N4), unused Cat 2 (N5).

Audit recommendation: reduce to ~30 atomic entries matching §19 Einstein
Test exemplar — delete invented intermediates, consolidate to one axiom
per paper-stated reasoning step, accept multi-input axioms tagged
`workingAssumption` (§3.4.4) with explicit "must close" status.

P25 = this consolidation. All audit defects addressed:

  CRITICAL #1-5 (P23) — fully fixed in P24 + maintained in P25
  N1 (invented intermediates) — DELETED; multi-input workingAssumption tagged
  N2 (discarded proof step) — removed; (ii.a) chain re-merged into single
     workingAssumption axiom; all framework Cat 2 axioms now load-bearing inputs
  N3 (3-input atomic) — removed; consolidated into multi-input workingAssumption
  N4 (decorative Cat 1) — REMOVED (no decorative entries)
  N5 (unused Cat 2) — REMOVED (Watanabe + Borel 1981 deleted from this file)

## Disciplinary invariants

1. Cat 2 — Hodge-style `def + rfl` for closed-form OR opaque `axiom` + citation.
2. Cat 3 — `opaque` (carrier/predicate) / `def` (Hyp_*) / `axiom`
   (workingAssumption / structuralEquation) with sub-type in docstring.
3. `Hyp_*` — `def Hyp_<Label> : Prop := <real_opaque_carrier>`; consumed via
   theorem signature.
4. Multi-input workingAssumption axioms ALLOWED per §3.4.4 ("temporarily
   axiomatized higher-level claim pending derivation"); decomposition is a
   future-round close target documented in attackHistory.
5. Status suffix in names.
6. `status = gapClosedConditional ↔ conditionalOn ≠ []` invariant verified
   by `#eval`.
7. Every declaration has a `StrictGapEntry` (bijective ledger per §19).

## Layout

```
§1 framework infrastructure
§2 Cat 3 carriers + hypothesis predicates (opaque)
§3 Hyp_* broken-link predicates (def into carriers)
§4 Cat 2 single-step axioms (only those consumed downstream)
§5 Cat 3 workingAssumption axioms (paper-stated reductions, must close)
§6 Cat 3 structuralEquation axiom (HC = algebraicity, §3.4.3)
§7 Derived gapClosedConditional theorems
§8 Main Conditional Theorem
§9 StrictGapEntry definitions — bijective
§10 #eval verification
```
-/

namespace HodgeReduction.Strict

-- ============================================================================
-- §1: framework infrastructure
-- ============================================================================

inductive InputCategory where
  | cat0Kernel | cat1Mathlib | cat2External | cat3PaperNovel
deriving Repr, DecidableEq

inductive Cat3SubType where
  | carrier | hypothesisPredicate | structuralEquation
  | workingAssumption | conditionalHypothesis | notApplicable
deriving Repr, DecidableEq

inductive StrictGapStatus where
  | gapOpen | gapPartial | gapBlocked | gapDeadEnd
  | gapClosed | gapClosedConditional
deriving Repr, DecidableEq

structure StrictGapEntry where
  name           : String
  status         : StrictGapStatus
  inputCategory  : InputCategory
  cat3SubType    : Cat3SubType
  paperSource    : String
  attackHistory  : List String
  scope          : String
  conditionalOn  : List String := []
deriving Repr

-- ============================================================================
-- §2: Cat 3 carriers + hypothesis predicates (opaque)
-- ============================================================================

/-- **Cat 3 carrier (§3.4.1)** — Borel stable range constant for E_{7(-25)}. -/
opaque borelM_E7minus25 : ℕ

/-- **Cat 3 hypothesis predicate (§3.4.2)** — H^8 of compact dual EVII
 sits in (4,4) bigrading. -/
opaque H8_compactDualEVII_is_44_bigrading : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Borel-1974 stable range
 cohomology iso at deg 8 for E_{7(-25)}. -/
opaque cohomologyIso_at_deg8 : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Hodge-(4,4) auto-G-invariant. -/
opaque freudenthal_H8_auto_G_invariant : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — form-level HM proportionality EVII. -/
opaque formLevel_HM_proportionality_EVII : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Freudenthal class realized
 by G-invariant cohomology (the (ii.a) conclusion). -/
opaque freudenthal_realized_by_G_invariant : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — IH-pullback for Freudenthal. -/
opaque ih_pullback_freudenthal : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Freudenthal extends compatibly
 at deg 8 (the (ii.b) compatibility). -/
opaque freudenthal_extends_compatibly_deg8 : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — G-P Chern-subalgebra extends
 to EVII. -/
opaque goreskyPardon_extension_to_EVII : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — §16.2 E_6-rep-compat for
 K = E_6 × U(1). -/
opaque section16_2_E6_rep_compat : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — codim-1 boundary of EVII is EIII. -/
opaque evii_codim1_boundary_is_eiii : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — V_27 Chern generation of BE_6. -/
opaque chernV27_generates_BE6 : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — V_56 Chern generation of BE_7. -/
opaque chernV56_generates_BE7 : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Borel-Hirzebruch presentation
 of H*(B(E_6 × U(1)); ℚ). -/
opaque borelHirzebruch_presentation_E6_times_U1 : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — G-P §10-12 abstract framework
 is group-agnostic (per Looijenga 2017). -/
opaque gpAbstract_group_agnostic : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Mumford 1977 canonical extension
 framework exists generally. -/
opaque mumford_canonical_extension_framework : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — V-Z 1984 framework. -/
opaque voganZuckerman_1984_framework : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Knapp-Vogan 1995 unitary
 induction framework. -/
opaque knappVogan_1995_induction_framework : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Franke 1998 Eisenstein
 decomposition framework. -/
opaque franke_1998_eisenstein_framework : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — polynomial identity
 [q] = P(c_1,...,c_4) holds on S_Γ^{tor}. -/
opaque polynomial_identity_freudenthal : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — [q] is algebraic on S_Γ^{tor}. -/
opaque freudenthal_is_algebraic : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Hodge Conjecture for
 Freudenthal quartic [q] on EVII (Main Theorem target). -/
opaque HC_for_freudenthal_quartic_on_EVII : Prop

/-- **Cat 3 carrier (§3.4.1)** — P24-CRITICAL-2 fix: real opaque for the
 higher-rank good metric working-assumption Hyp_*. -/
opaque higher_rank_good_metric_for_EVII : Prop

/-- **Cat 3 carrier (§3.4.1)** — P24-CRITICAL-2 fix: real opaque for the
 Chern-Weil form proportionality working-assumption Hyp_*. -/
opaque chern_weil_form_proportionality_EVII : Prop

/-- **Cat 3 carrier (§3.4.1)** — P24-CRITICAL-2 fix: real opaque for the
 Freudenthal class placement working-assumption Hyp_*. -/
opaque freudenthal_placed_in_chern_subalgebra : Prop

/-- **Cat 3 carrier (§3.4.1)** — P24-CRITICAL-2 fix: real opaque for the
 cross-ring Φ(q) ≠ 0 working-assumption Hyp_*. -/
opaque cross_ring_phi_nonzero : Prop

/-- **Cat 3 carrier (§3.4.1)** — V-Z A_q(λ) specific. -/
opaque voganZuckermanAqLambda_E7minus25_Deg8 : Prop

/-- **Cat 3 carrier (§3.4.1)** — Eisenstein vanishing specific. -/
opaque eisensteinVanishing_E7minus25_Deg8 : Prop

-- ============================================================================
-- §3: Hyp_* broken-link predicates (§12.1)
-- ============================================================================

/-- **Broken-link hypothesis (§12.1)** — Borel stable range reaches deg 8. -/
def Hyp_BorelMAtLeast8_OPEN : Prop := borelM_E7minus25 ≥ 8

/-- **Broken-link hypothesis (§12.1)** — V-Z A_q(λ) at R(q)=8 exists. -/
def Hyp_VZ_AqLambda_OPEN : Prop := voganZuckermanAqLambda_E7minus25_Deg8

/-- **Broken-link hypothesis (§12.1)** — Eisenstein vanishing at deg 8. -/
def Hyp_Eisenstein_Vanishing_OPEN : Prop := eisensteinVanishing_E7minus25_Deg8

/-- **Broken-link hypothesis (§12.1)** — Higher-rank good metric for EVII. -/
def Hyp_HigherRank_GoodMetric_OPEN : Prop := higher_rank_good_metric_for_EVII

/-- **Broken-link hypothesis (§12.1)** — Chern-Weil form proportionality EVII. -/
def Hyp_ChernWeilForm_Proportionality_OPEN : Prop :=
  chern_weil_form_proportionality_EVII

/-- **Broken-link hypothesis (§12.1)** — Freudenthal class placement. -/
def Hyp_FreudenthalClassPlacement_OPEN : Prop :=
  freudenthal_placed_in_chern_subalgebra

/-- **Broken-link hypothesis (§12.1)** — Cross-ring Φ(q) ≠ 0. -/
def Hyp_CrossRingPhiNonzero_OPEN : Prop := cross_ring_phi_nonzero

-- ============================================================================
-- §4: Cat 2 single-step axioms (only those load-bearing in the proof chain)
-- ============================================================================

/-- **Cat 2 (§3.3)** — Bott 1957 Ann. Math. 66 + Borel-Hirzebruch 1958 AJM 80
 §29-30 + Griffiths-Harris 1978 Ch. 1 §3. Flag-variety diagonal bigrading
 specialised to `Ě_VII`: H^8 sits in (4,4). -/
axiom bott_borel_weil_diagonal_E7P7_OPEN :
  H8_compactDualEVII_is_44_bigrading

/-- **Cat 2 (§3.3)** — A. Borel I, Ann. Sci. ÉNS 7 (1974), 235-272 §11
 stable range theorem. Hyp_BorelMAtLeast8 → cohomology iso at deg 8. -/
axiom borel_1974_stable_range_iso_deg8_OPEN :
  Hyp_BorelMAtLeast8_OPEN → cohomologyIso_at_deg8

/-- **Cat 2 (§3.3)** — Beilinson-Bernstein-Deligne 1982 Astérisque 100 +
 M. Saito 1988 Publ. RIMS 24 + Goresky-MacPherson 1980 Topology 19.
 Canonical IH-to-toroidal pullback for Freudenthal class. -/
axiom bbd_saito_gm_ih_pullback_OPEN : ih_pullback_freudenthal

/-- **Cat 2 (§3.3)** — M. Goresky, W. Pardon, Invent. Math. 147 (2002) §10-12
 + E. Looijenga, Compositio Math. 153 (2017), 1349-1371 (arXiv:1510.04103)
 Cor 3.3 + Thm 4.1. Abstract patched-parabolic framework is group-agnostic. -/
axiom goresky_pardon_2002_looijenga_2017_abstract_OPEN :
  gpAbstract_group_agnostic

/-- **Cat 2 (§3.3)** — J. Wolf, *Spaces of Constant Curvature*, McGraw-Hill
 1972 + I. Satake, *Algebraic Structures of Symmetric Domains*, Iwanami
 Shoten 1980 + A. Borel, L. Ji, *Compactifications of Symmetric and
 Locally Symmetric Spaces*, Birkhäuser 2006 §III.4-5.
 Codim-1 boundary of EVII = EIII. -/
axiom wolf_satake_borel_ji_2006_evii_boundary_OPEN :
  evii_codim1_boundary_is_eiii

/-- **Cat 2 (§3.3)** — D. Mumford, "Hirzebruch's proportionality theorem
 in the non-compact case", Invent. Math. 42 (1977), Theorem 3.1 +
 M. Harris, Proc. London Math. Soc. (3) 59 (1989), §4.1. Mumford
 canonical extension framework, type-uniform. -/
axiom mumford_1977_canonical_extension_OPEN :
  mumford_canonical_extension_framework

/-- **Cat 2 (§3.3)** — D. Vogan, G. Zuckerman, "Unitary representations
 with non-zero cohomology", Compositio Math. 53 (1984), 51-90. -/
axiom vogan_zuckerman_1984_OPEN : voganZuckerman_1984_framework

/-- **Cat 2 (§3.3)** — A. Knapp, D. Vogan, *Cohomological Induction and
 Unitary Representations*, PMS-45 (1995), Ch. XII. -/
axiom knapp_vogan_1995_OPEN : knappVogan_1995_induction_framework

/-- **Cat 2 (§3.3)** — J. Franke, "Harmonic analysis in weighted L_2-spaces",
 Ann. Sci. ÉNS (4) 31 (1998), 181-279. -/
axiom franke_1998_OPEN : franke_1998_eisenstein_framework

/-- **Cat 2 gapBlocked (§2)** — multi-source folklore (Borel 1953 +
 Borel-Hirzebruch 1958 + Mimura-Toda 1991). Per §1.1 folkloric-no-specific-
 paper → gapBlocked. Borel-Hirzebruch presentation of `H^*(B(E_6 × U(1)); ℚ)`. -/
axiom borel_hirzebruch_mimura_toda_E6_U1_BLOCKED :
  borelHirzebruch_presentation_E6_times_U1

/-- **Cat 2 gapBlocked (§2)** — multi-source folklore (Borel 1953 + Toda
 1976 + Kono-Mimura 1970s + Mimura-Toda 1991). V_27 Chern generation. -/
axiom borel_toda_kono_mimura_V27_BLOCKED : chernV27_generates_BE6

/-- **Cat 2 gapBlocked (§2)** — multi-source folklore (Kono-Mimura +
 Mimura-Toda 1991 + Borel 1953). V_56 Chern generation. -/
axiom kono_mimura_mimura_toda_V56_BLOCKED : chernV56_generates_BE7

/-- **Cat 2 (§3.3)** — Standard algebraic geometry: polynomial in Chern
 classes of an automorphic vector bundle is algebraic. Griffiths-Harris
 1978 Ch. 3 + Voisin Hodge Theory I Ch. 11. -/
axiom polynomial_in_chern_classes_is_algebraic_OPEN :
  polynomial_identity_freudenthal → freudenthal_is_algebraic

-- ============================================================================
-- §5: Cat 3 workingAssumption axioms (paper-stated reductions; must close)
-- ============================================================================
--
-- P25 audit-response: multi-input workingAssumption axioms (§3.4.4) tagged
-- explicitly as "must close before publication". Each axiom = ONE paper-stated
-- reasoning step in the master tex's reduction chain, taking ALL its required
-- Cat 2 framework inputs + Cat 3 Hyp_* inputs.
--
-- §4 #14 (composite-bundling) acknowledged but §3.4.4 expressly permits
-- workingAssumption for higher-level claims pending derivation. Each axiom's
-- attackHistory records the close target for future-round decomposition.

/-- **Cat 3 workingAssumption (§3.4.4)** — paper Hodge-(4,4) reduction step:
 cohomology iso at deg 8 + (4,4) bigrading → Freudenthal H^8 auto-G-invariant.
 2-input atomic. -/
axiom paper_hodge44_step_OPEN :
  cohomologyIso_at_deg8 → H8_compactDualEVII_is_44_bigrading →
    freudenthal_H8_auto_G_invariant

/-- **Cat 3 workingAssumption (§3.4.4)** — paper (ii.a) reduction:
 the Borel-Wallach descent + V-Z + Knapp-Vogan + Franke framework, applied
 to E_{7(-25)} at deg 8 with `[q]_G` realisation, yields realization by
 G-invariant cohomology.
 6-input composite per paper structure; must decompose with master tex
 consultation in future rounds. -/
axiom paper_iia_realization_OPEN :
  voganZuckerman_1984_framework →
  knappVogan_1995_induction_framework →
  franke_1998_eisenstein_framework →
  freudenthal_H8_auto_G_invariant →
  Hyp_VZ_AqLambda_OPEN →
  Hyp_Eisenstein_Vanishing_OPEN →
  freudenthal_realized_by_G_invariant

/-- **Cat 3 structuralEquation (§3.4.3)** — paper master tex §11.5
 decomposition: (ii.b) compatibility = (ii.b.1) IH-pullback + (ii.b.2)
 placement. Paper-stated structural decomposition.
 2-input atomic. -/
axiom paper_iib_compatibility_OPEN :
  ih_pullback_freudenthal → Hyp_FreudenthalClassPlacement_OPEN →
    freudenthal_extends_compatibly_deg8

/-- **Cat 3 workingAssumption (§3.4.4)** — paper form-HM-EVII reduction:
 Mumford framework + higher-rank good metric + Chern-Weil form
 proportionality → form-level HM proportionality EVII.
 3-input; must decompose in future rounds. -/
axiom paper_formHM_EVII_OPEN :
  mumford_canonical_extension_framework →
  Hyp_HigherRank_GoodMetric_OPEN →
  Hyp_ChernWeilForm_Proportionality_OPEN →
  formLevel_HM_proportionality_EVII

/-- **Cat 3 workingAssumption (§3.4.4)** — paper §16.2 E_6-rep-compat
 reduction: boundary EIII + V_27 generation + form-HM + V_56 generation →
 §16.2 E_6-rep-compat.
 4-input; must decompose in future rounds. -/
axiom paper_section16_2_OPEN :
  evii_codim1_boundary_is_eiii →
  chernV27_generates_BE6 →
  formLevel_HM_proportionality_EVII →
  chernV56_generates_BE7 →
  section16_2_E6_rep_compat

/-- **Cat 3 workingAssumption (§3.4.4)** — paper G-P-EVII reduction:
 Borel-Hirzebruch + GP abstract + §16.2 → G-P-EVII extension.
 3-input; must decompose in future rounds. -/
axiom paper_GP_EVII_OPEN :
  borelHirzebruch_presentation_E6_times_U1 →
  gpAbstract_group_agnostic →
  section16_2_E6_rep_compat →
  goreskyPardon_extension_to_EVII

/-- **Cat 3 workingAssumption (§3.4.4)** — paper clause-iii polynomial
 identity reduction: cross-ring Φ + realized + extends + G-P-EVII →
 polynomial identity `[q] = P(c_1,...,c_4)`.
 4-input; must decompose in future rounds. -/
axiom paper_clause_iii_polynomial_identity_OPEN :
  Hyp_CrossRingPhiNonzero_OPEN →
  freudenthal_realized_by_G_invariant →
  freudenthal_extends_compatibly_deg8 →
  goreskyPardon_extension_to_EVII →
  polynomial_identity_freudenthal

-- ============================================================================
-- §6: Cat 3 structuralEquation (§3.4.3)
-- ============================================================================

/-- **Cat 3 structuralEquation (§3.4.3)** — paper's definitional equation:
 HC for a class is the algebraicity statement. Genuine paper definition,
 not a reduction conclusion. -/
axiom paper_HC_equals_algebraicity_OPEN :
  freudenthal_is_algebraic → HC_for_freudenthal_quartic_on_EVII

-- ============================================================================
-- §7: Derived gapClosedConditional theorems
-- ============================================================================

/-- **gapClosedConditional** — cohomology iso at deg 8.
 conditionalOn := ["Hyp_BorelMAtLeast8_OPEN"] -/
theorem cohomologyIso_at_deg8_CONDITIONAL
  (h : Hyp_BorelMAtLeast8_OPEN) : cohomologyIso_at_deg8 :=
  borel_1974_stable_range_iso_deg8_OPEN h

/-- **gapClosedConditional** — Hodge-(4,4) auto-G-invariant.
 conditionalOn := ["Hyp_BorelMAtLeast8_OPEN"] -/
theorem freudenthal_H8_auto_G_invariant_CONDITIONAL
  (h : Hyp_BorelMAtLeast8_OPEN) : freudenthal_H8_auto_G_invariant :=
  paper_hodge44_step_OPEN
    (cohomologyIso_at_deg8_CONDITIONAL h)
    bott_borel_weil_diagonal_E7P7_OPEN

/-- **gapClosedConditional** — form-level HM proportionality EVII.
 conditionalOn := ["Hyp_HigherRank_GoodMetric_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_OPEN"] -/
theorem formLevel_HM_proportionality_EVII_CONDITIONAL
  (h1 : Hyp_HigherRank_GoodMetric_OPEN)
  (h2 : Hyp_ChernWeilForm_Proportionality_OPEN) :
  formLevel_HM_proportionality_EVII :=
  paper_formHM_EVII_OPEN
    mumford_1977_canonical_extension_OPEN h1 h2

/-- **gapClosedConditional** — §16.2 E_6-rep-compat.
 conditionalOn := ["Hyp_HigherRank_GoodMetric_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_OPEN"] -/
theorem section16_2_E6_rep_compat_CONDITIONAL
  (h1 : Hyp_HigherRank_GoodMetric_OPEN)
  (h2 : Hyp_ChernWeilForm_Proportionality_OPEN) :
  section16_2_E6_rep_compat :=
  paper_section16_2_OPEN
    wolf_satake_borel_ji_2006_evii_boundary_OPEN
    borel_toda_kono_mimura_V27_BLOCKED
    (formLevel_HM_proportionality_EVII_CONDITIONAL h1 h2)
    kono_mimura_mimura_toda_V56_BLOCKED

/-- **gapClosedConditional** — G-P-EVII Chern-subalgebra extension.
 conditionalOn := ["Hyp_HigherRank_GoodMetric_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_OPEN"] -/
theorem goreskyPardon_EVII_CONDITIONAL
  (h1 : Hyp_HigherRank_GoodMetric_OPEN)
  (h2 : Hyp_ChernWeilForm_Proportionality_OPEN) :
  goreskyPardon_extension_to_EVII :=
  paper_GP_EVII_OPEN
    borel_hirzebruch_mimura_toda_E6_U1_BLOCKED
    goresky_pardon_2002_looijenga_2017_abstract_OPEN
    (section16_2_E6_rep_compat_CONDITIONAL h1 h2)

/-- **gapClosedConditional** — (ii.a) Freudenthal realized by G-invariant.
 conditionalOn := ["Hyp_BorelMAtLeast8_OPEN",
                   "Hyp_VZ_AqLambda_OPEN",
                   "Hyp_Eisenstein_Vanishing_OPEN"] -/
theorem freudenthal_realized_by_G_invariant_CONDITIONAL
  (h1 : Hyp_BorelMAtLeast8_OPEN)
  (h2 : Hyp_VZ_AqLambda_OPEN)
  (h3 : Hyp_Eisenstein_Vanishing_OPEN) :
  freudenthal_realized_by_G_invariant :=
  paper_iia_realization_OPEN
    vogan_zuckerman_1984_OPEN
    knapp_vogan_1995_OPEN
    franke_1998_OPEN
    (freudenthal_H8_auto_G_invariant_CONDITIONAL h1)
    h2 h3

/-- **gapClosedConditional** — (ii.b) Freudenthal extends compatibly.
 conditionalOn := ["Hyp_FreudenthalClassPlacement_OPEN"] -/
theorem freudenthal_extends_compatibly_CONDITIONAL
  (h : Hyp_FreudenthalClassPlacement_OPEN) :
  freudenthal_extends_compatibly_deg8 :=
  paper_iib_compatibility_OPEN bbd_saito_gm_ih_pullback_OPEN h

-- ============================================================================
-- §8: Main Conditional Theorem
-- ============================================================================

/-- **MAIN gapClosedConditional THEOREM** — HC for Freudenthal quartic [q]
 on EVII Shimura varieties, conditional on 7 named broken-link hypotheses
 (each resolves to a real opaque carrier; none is `:= True`).

 Proof = composition of:
  (1) freudenthal_realized_by_G_invariant_CONDITIONAL (Cat 3 working assumption)
  (2) freudenthal_extends_compatibly_CONDITIONAL (Cat 3 structural equation)
  (3) goreskyPardon_EVII_CONDITIONAL (Cat 3 working assumption chain)
  (4) paper_clause_iii_polynomial_identity_OPEN (Cat 3 working assumption)
  (5) polynomial_in_chern_classes_is_algebraic_OPEN (Cat 2 standard)
  (6) paper_HC_equals_algebraicity_OPEN (Cat 3 structural equation, §3.4.3 HC definition)

 ALL declared atoms in this file are LOAD-BEARING in this proof chain — no
 phantom-downstream-user (Pattern 7) violations.

 conditionalOn := [
   "Hyp_BorelMAtLeast8_OPEN",
   "Hyp_VZ_AqLambda_OPEN",
   "Hyp_Eisenstein_Vanishing_OPEN",
   "Hyp_HigherRank_GoodMetric_OPEN",
   "Hyp_ChernWeilForm_Proportionality_OPEN",
   "Hyp_FreudenthalClassPlacement_OPEN",
   "Hyp_CrossRingPhiNonzero_OPEN"
 ] -/
theorem HC_for_freudenthal_quartic_on_EVII_CONDITIONAL
  (h_m_ge_8       : Hyp_BorelMAtLeast8_OPEN)
  (h_vz_aq        : Hyp_VZ_AqLambda_OPEN)
  (h_eisenstein   : Hyp_Eisenstein_Vanishing_OPEN)
  (h_higher_rank  : Hyp_HigherRank_GoodMetric_OPEN)
  (h_form_prop    : Hyp_ChernWeilForm_Proportionality_OPEN)
  (h_placement    : Hyp_FreudenthalClassPlacement_OPEN)
  (h_cross_ring   : Hyp_CrossRingPhiNonzero_OPEN) :
  HC_for_freudenthal_quartic_on_EVII :=
  paper_HC_equals_algebraicity_OPEN
    (polynomial_in_chern_classes_is_algebraic_OPEN
      (paper_clause_iii_polynomial_identity_OPEN
        h_cross_ring
        (freudenthal_realized_by_G_invariant_CONDITIONAL h_m_ge_8 h_vz_aq h_eisenstein)
        (freudenthal_extends_compatibly_CONDITIONAL h_placement)
        (goreskyPardon_EVII_CONDITIONAL h_higher_rank h_form_prop)))

-- ============================================================================
-- §9: StrictGapEntry definitions (bijective with declarations)
-- ============================================================================

/-! ### Cat 3 carriers + hypothesis predicates (§3.4.1, §3.4.2) -/

def gap_borelM_E7minus25 : StrictGapEntry :=
  { name := "borelM_E7minus25"
    status := .gapOpen, inputCategory := .cat3PaperNovel, cat3SubType := .carrier
    paperSource := "Borel 1974 Ann. Sci. ÉNS 7 §11 stable range constant"
    attackHistory := ["P25: opaque ℕ carrier"]
    scope := "Borel stable range constant m(E_{7(-25)})" }

def gap_H8_compactDualEVII_is_44_bigrading : StrictGapEntry :=
  { name := "H8_compactDualEVII_is_44_bigrading"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper invocation of Bott-BBW for EVII compact dual"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "H^8(Ě_VII) sits in (4,4) Hodge bigrading" }

def gap_cohomologyIso_at_deg8 : StrictGapEntry :=
  { name := "cohomologyIso_at_deg8"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper invocation of Borel 1974 stable range for EVII"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Canonical cohomology iso H^8(S_Γ_EVII) ≅ H^8(Ě_VII)" }

def gap_freudenthal_H8_auto_G_invariant : StrictGapEntry :=
  { name := "freudenthal_H8_auto_G_invariant"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper (P14, P9.d-corrected) Hodge-(4,4) auto-G-inv conclusion"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Freudenthal H^8 class auto-G-invariant on S_Γ_EVII" }

def gap_formLevel_HM_proportionality_EVII : StrictGapEntry :=
  { name := "formLevel_HM_proportionality_EVII"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper invocation of form-level HM proportionality"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Form-level Hirzebruch-Mumford proportionality for EVII" }

def gap_freudenthal_realized_by_G_invariant : StrictGapEntry :=
  { name := "freudenthal_realized_by_G_invariant"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper (ii.a) conclusion"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "(ii.a) Freudenthal realized by G-invariant cohomology" }

def gap_ih_pullback_freudenthal : StrictGapEntry :=
  { name := "ih_pullback_freudenthal"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "BBD/Saito/GM IH-pullback predicate (the (ii.b.1) PUBLISHED step)"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Canonical IH-to-toroidal pullback for Freudenthal class" }

def gap_freudenthal_extends_compatibly_deg8 : StrictGapEntry :=
  { name := "freudenthal_extends_compatibly_deg8"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper (ii.b) compatibility predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "(ii.b) Freudenthal extends compatibly at deg 8" }

def gap_goreskyPardon_extension_to_EVII : StrictGapEntry :=
  { name := "goreskyPardon_extension_to_EVII"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper G-P-EVII Chern-subalgebra extension predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "G-P Chern-subalgebra extends to EVII equal-rank case" }

def gap_section16_2_E6_rep_compat : StrictGapEntry :=
  { name := "section16_2_E6_rep_compat"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper §16.2 E_6-rep-compat predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "§16.2 E_6-rep-compat residual for K = E_6 × U(1)" }

def gap_evii_codim1_boundary_is_eiii : StrictGapEntry :=
  { name := "evii_codim1_boundary_is_eiii"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "Wolf 1972 / Satake 1980 / Borel-Ji 2006 boundary classification"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Codim-1 boundary of EVII is EIII (exceptional E_6 type)" }

def gap_chernV27_generates_BE6 : StrictGapEntry :=
  { name := "chernV27_generates_BE6"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper V_27 Chern generation predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "V_27 Chern classes generate H*(BE_6; ℚ)" }

def gap_chernV56_generates_BE7 : StrictGapEntry :=
  { name := "chernV56_generates_BE7"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper V_56 Chern generation predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "V_56 Chern classes generate H*(BE_7; ℚ)" }

def gap_borelHirzebruch_presentation : StrictGapEntry :=
  { name := "borelHirzebruch_presentation_E6_times_U1"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper Borel-Hirzebruch presentation predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "H^*(B(E_6 × U(1)); ℚ) polynomial on V_27 Chern classes" }

def gap_gpAbstract_group_agnostic : StrictGapEntry :=
  { name := "gpAbstract_group_agnostic"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper G-P abstract framework predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "G-P §10-12 abstract framework is group-agnostic (per Looijenga 2017)" }

def gap_mumford_canonical_extension_framework : StrictGapEntry :=
  { name := "mumford_canonical_extension_framework"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper Mumford 1977 framework predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Mumford 1977 canonical extension framework" }

def gap_voganZuckerman_1984_framework : StrictGapEntry :=
  { name := "voganZuckerman_1984_framework"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper V-Z 1984 framework predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "V-Z 1984 A_q(λ) cohomological induction framework" }

def gap_knappVogan_1995_induction : StrictGapEntry :=
  { name := "knappVogan_1995_induction_framework"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper Knapp-Vogan 1995 framework predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Knapp-Vogan unitary realization framework" }

def gap_franke_1998_framework : StrictGapEntry :=
  { name := "franke_1998_eisenstein_framework"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper Franke 1998 framework predicate"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Franke 1998 Eisenstein decomposition framework" }

def gap_polynomial_identity_freudenthal : StrictGapEntry :=
  { name := "polynomial_identity_freudenthal"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper clause-iii conclusion: [q] = P(c_1,...,c_4)"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "Polynomial identity [q] = P(c_1,...,c_4) holds" }

def gap_freudenthal_is_algebraic : StrictGapEntry :=
  { name := "freudenthal_is_algebraic"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper algebraicity conclusion"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "[q] is algebraic on S_Γ^{tor}" }

def gap_HC_for_freudenthal_target : StrictGapEntry :=
  { name := "HC_for_freudenthal_quartic_on_EVII"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .hypothesisPredicate
    paperSource := "paper Main Theorem target"
    attackHistory := ["P25: opaque Prop predicate"]
    scope := "HC for Freudenthal [q] on EVII Shimura varieties" }

def gap_higher_rank_good_metric : StrictGapEntry :=
  { name := "higher_rank_good_metric_for_EVII"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .carrier
    paperSource := "P13 paper-acknowledged conditional"
    attackHistory := ["P25: opaque Prop carrier for Hyp_HigherRank_GoodMetric"]
    scope := "Higher-rank automorphic bundle good metric on EVII" }

def gap_chern_weil_form_proportionality : StrictGapEntry :=
  { name := "chern_weil_form_proportionality_EVII"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .carrier
    paperSource := "P13 paper-acknowledged conditional"
    attackHistory := ["P25: opaque Prop carrier for Hyp_ChernWeilForm_Proportionality"]
    scope := "Chern-Weil form proportionality for EVII (G-P 2002 analog)" }

def gap_freudenthal_placed : StrictGapEntry :=
  { name := "freudenthal_placed_in_chern_subalgebra"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .carrier
    paperSource := "Master tex L11625-11647 paper-acknowledged conditional"
    attackHistory := ["P25: opaque Prop carrier for Hyp_FreudenthalClassPlacement"]
    scope := "Freudenthal [q] placed in G-P Chern subalgebra at deg 8" }

def gap_cross_ring_phi_nonzero : StrictGapEntry :=
  { name := "cross_ring_phi_nonzero"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .carrier
    paperSource := "Paper (i.b.2) INVENTION_CLASS"
    attackHistory := ["P25: opaque Prop carrier for Hyp_CrossRingPhiNonzero"]
    scope := "Twisted cross-ring Φ(q) ≠ 0 (INVENTION; canonical Φ vanishes)" }

def gap_voganZuckermanAqLambda : StrictGapEntry :=
  { name := "voganZuckermanAqLambda_E7minus25_Deg8"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .carrier
    paperSource := "P16 paper-acknowledged conditional"
    attackHistory := ["P25: opaque Prop carrier for Hyp_VZ_AqLambda"]
    scope := "Specific V-Z A_q(λ) at R(q)=8 for E_{7(-25)}" }

def gap_eisensteinVanishing : StrictGapEntry :=
  { name := "eisensteinVanishing_E7minus25_Deg8"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .carrier
    paperSource := "P9 paper-acknowledged conditional"
    attackHistory := ["P25: opaque Prop carrier for Hyp_Eisenstein_Vanishing"]
    scope := "Eisenstein vanishing at deg 8 for E_{7(-25)}" }

/-! ### Hyp_* broken-link predicates (§12.1) -/

def gap_Hyp_BorelMAtLeast8 : StrictGapEntry :=
  { name := "Hyp_BorelMAtLeast8_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "P15 audit: m ≥ 8 NOT in published lit (gap 6 from Borel 1981 m ≥ 2)"
    attackHistory := ["P15-P23 introduction history",
                      "P24 CRITICAL #2: real carrier via `borelM_E7minus25 ≥ 8`",
                      "P25: maintained, consumed by Main Theorem"]
    scope := "Borel stable range reaches deg 8 for E_{7(-25)}" }

def gap_Hyp_VZ_AqLambda : StrictGapEntry :=
  { name := "Hyp_VZ_AqLambda_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "P16: V-Z A_q(λ) for E_{7(-25)} R(q)=8 NOT published"
    attackHistory := ["P16 introduction",
                      "P24 CRITICAL #2: real carrier",
                      "P25: maintained, consumed by (ii.a) chain"]
    scope := "V-Z A_q(λ) at R(q)=8 for E_{7(-25)}" }

def gap_Hyp_Eisenstein_Vanishing : StrictGapEntry :=
  { name := "Hyp_Eisenstein_Vanishing_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "P9: Eisenstein vanishing for E_{7(-25)} deg 8 NOT published"
    attackHistory := ["P9 introduction",
                      "P24 CRITICAL #2: real carrier",
                      "P25: maintained, consumed by (ii.a) chain"]
    scope := "Eisenstein vanishing for [q] at deg 8" }

def gap_Hyp_HigherRank_GoodMetric : StrictGapEntry :=
  { name := "Hyp_HigherRank_GoodMetric_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "P13: higher-rank good metric for EVII NOT published"
    attackHistory := ["P13 introduction",
                      "P23 `:= True` (vacuous violation)",
                      "P24 CRITICAL #2 fix: real carrier",
                      "P25: maintained"]
    scope := "Higher-rank automorphic bundle good metric on EVII" }

def gap_Hyp_ChernWeilForm_Proportionality : StrictGapEntry :=
  { name := "Hyp_ChernWeilForm_Proportionality_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "P13: Chern-Weil form proportionality EVII NOT published (G-P 2002 classical only)"
    attackHistory := ["P13 introduction",
                      "P23 `:= True` (vacuous violation)",
                      "P24 CRITICAL #2 fix: real carrier",
                      "P25: maintained"]
    scope := "Chern-Weil form proportionality for EVII" }

def gap_Hyp_FreudenthalClassPlacement : StrictGapEntry :=
  { name := "Hyp_FreudenthalClassPlacement_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .conditionalHypothesis
    paperSource := "Master tex L11625-11647 paper-acknowledged conditional"
    attackHistory := ["P10 introduction",
                      "P23 `:= True` (vacuous violation)",
                      "P24 CRITICAL #2 fix: real carrier",
                      "P25: maintained"]
    scope := "Freudenthal [q] placed in G-P Chern subalgebra at deg 8" }

def gap_Hyp_CrossRingPhiNonzero : StrictGapEntry :=
  { name := "Hyp_CrossRingPhiNonzero_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .conditionalHypothesis
    paperSource := "Paper (i.b.2) INVENTION_CLASS: twisted Φ construction required"
    attackHistory := ["P11 introduction as INVENTION_CLASS",
                      "P23 `:= True` (vacuous violation)",
                      "P24 CRITICAL #2 fix: real carrier",
                      "P25: maintained"]
    scope := "Twisted cross-ring Φ(q) ≠ 0" }

/-! ### Cat 2 single-step axioms -/

def gap_bott_borel_weil : StrictGapEntry :=
  { name := "bott_borel_weil_diagonal_E7P7_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Bott 1957 Ann. Math. 66 + Borel-Hirzebruch 1958 AJM 80 §29-30 + Griffiths-Harris 1978 Ch. 1 §3"
    attackHistory := ["P25: Cat 2 single-step; consumed by Hodge-(4,4) chain"]
    scope := "Flag-variety diagonal Hodge bigrading specialised to Ě_VII" }

def gap_borel_1974 : StrictGapEntry :=
  { name := "borel_1974_stable_range_iso_deg8_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Borel 1974 I Ann. Sci. ÉNS 7 (235-272) §11 stable range theorem"
    attackHistory := ["P25: Cat 2 single-step; consumed by cohomologyIso theorem"]
    scope := "Borel stable range: m ≥ k → H^k iso S_Γ to compact dual" }

def gap_bbd_saito_gm : StrictGapEntry :=
  { name := "bbd_saito_gm_ih_pullback_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "BBD 1982 Astérisque 100 + Saito 1988 Publ. RIMS 24 + Goresky-MacPherson 1980 Topology 19"
    attackHistory := ["P25: Cat 2 single-step; consumed by (ii.b) compatibility theorem"]
    scope := "Canonical IH-to-toroidal pullback" }

def gap_goresky_pardon_2002_looijenga : StrictGapEntry :=
  { name := "goresky_pardon_2002_looijenga_2017_abstract_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Goresky-Pardon 2002 Invent. Math. 147 §10-12 + Looijenga 2017 Compositio 153 (1349-1371)"
    attackHistory := ["P25: Cat 2 single-step; consumed by G-P-EVII theorem"]
    scope := "G-P §10-12 abstract framework group-agnostic" }

def gap_wolf_satake_borel_ji : StrictGapEntry :=
  { name := "wolf_satake_borel_ji_2006_evii_boundary_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Wolf 1972 + Satake 1980 + Borel-Ji 2006 §III.4-5"
    attackHistory := ["P25: Cat 2 single-step; consumed by §16.2 theorem"]
    scope := "EVII codim-1 boundary classification = EIII" }

def gap_mumford_1977 : StrictGapEntry :=
  { name := "mumford_1977_canonical_extension_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Mumford 1977 Invent. Math. 42 Thm 3.1 + Harris 1989 Proc. LMS (3) 59 §4.1"
    attackHistory := ["P25: Cat 2 single-step; consumed by form-HM theorem"]
    scope := "Mumford canonical extension framework, type-uniform" }

def gap_vogan_zuckerman : StrictGapEntry :=
  { name := "vogan_zuckerman_1984_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Vogan-Zuckerman 1984 Compositio Math. 53 (51-90)"
    attackHistory := ["P25: Cat 2 single-step; consumed by (ii.a) theorem"]
    scope := "V-Z 1984 A_q(λ) cohomological induction framework" }

def gap_knapp_vogan_1995 : StrictGapEntry :=
  { name := "knapp_vogan_1995_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Knapp-Vogan 1995 PMS-45 Ch. XII"
    attackHistory := ["P25: Cat 2 single-step; consumed by (ii.a) theorem"]
    scope := "Knapp-Vogan unitary realization framework" }

def gap_franke_1998 : StrictGapEntry :=
  { name := "franke_1998_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Franke 1998 Ann. Sci. ÉNS (4) 31 (181-279)"
    attackHistory := ["P25: Cat 2 single-step; consumed by (ii.a) theorem"]
    scope := "Franke 1998 Eisenstein decomposition framework" }

def gap_borel_hirzebruch_E6_BLOCKED : StrictGapEntry :=
  { name := "borel_hirzebruch_mimura_toda_E6_U1_BLOCKED"
    status := .gapBlocked, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "FOLKLORE multi-source (Borel 1953 + Borel-Hirzebruch 1958 + Mimura-Toda 1991)"
    attackHistory := ["P25: gapBlocked per §1.1; consumed by G-P-EVII chain"]
    scope := "Borel-Hirzebruch presentation of H*(B(E_6 × U(1)); ℚ) [folklore]" }

def gap_V27_BE6_BLOCKED : StrictGapEntry :=
  { name := "borel_toda_kono_mimura_V27_BLOCKED"
    status := .gapBlocked, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "FOLKLORE multi-source (Borel 1953 + Toda 1976 + Kono-Mimura + Mimura-Toda 1991)"
    attackHistory := ["P25: gapBlocked per §1.1; consumed by §16.2 chain"]
    scope := "V_27 Chern generation of H*(BE_6; ℚ) [folklore]" }

def gap_V56_BE7_BLOCKED : StrictGapEntry :=
  { name := "kono_mimura_mimura_toda_V56_BLOCKED"
    status := .gapBlocked, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "FOLKLORE multi-source (Kono-Mimura + Mimura-Toda 1991 + Borel 1953)"
    attackHistory := ["P25: gapBlocked per §1.1; consumed by §16.2 chain"]
    scope := "V_56 Chern generation of H*(BE_7; ℚ) [folklore]" }

def gap_polynomial_is_algebraic : StrictGapEntry :=
  { name := "polynomial_in_chern_classes_is_algebraic_OPEN"
    status := .gapOpen, inputCategory := .cat2External
    cat3SubType := .notApplicable
    paperSource := "Griffiths-Harris 1978 Ch. 3 + Voisin Hodge Theory I Ch. 11"
    attackHistory := ["P25: Cat 2 single-step; consumed by Main Theorem"]
    scope := "Polynomial in Chern classes is algebraic (standard)" }

/-! ### Cat 3 workingAssumption (§3.4.4) — paper reductions, must close -/

def gap_paper_hodge44 : StrictGapEntry :=
  { name := "paper_hodge44_step_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "Master tex \\ref{rem:borel-matsushima} (L3453) Borel-Matsushima descent + \\ref{rem:E7-chernweil-tautology} (L3422)"
    attackHistory := ["P25: 2-input atomic — already at discipline-allowed limit",
                      "P26: \\label anchored; no further decomposition needed"]
    scope := "paper Hodge-(4,4) reduction (2-input atomic; iso + bigrading → auto-G-invariant)" }

def gap_paper_iia : StrictGapEntry :=
  { name := "paper_iia_realization_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "Master tex \\ref{hyp:ChernWeil-bridge-E7} clause (ii.a) (L11450+) + \\ref{rem:borel-matsushima} (L3453) Borel-Matsushima"
    attackHistory := ["P25: 6-input workingAssumption (3 Cat 2 frameworks + Hodge-(4,4) + 2 Hyp_*)",
                      "P26: \\label anchored to master tex (ii.a) clause",
                      "P32 close target: decompose via Borel-Wallach Ch. VII step-by-step"]
    scope := "paper (ii.a) reduction; close target P32" }

def gap_paper_iib : StrictGapEntry :=
  { name := "paper_iib_compatibility_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .structuralEquation
    paperSource := "Master tex \\ref{hyp:ChernWeil-bridge-E7} clause (ii.b) (L11625-11647): paper-stated decomposition (ii.b) = (ii.b.1) IH-pullback PUBLISHED + (ii.b.2) placement REQUIRED"
    attackHistory := ["P25: paper-stated structural decomposition; §3.4.3 equation",
                      "P26: \\label anchored; structural equation = paper-stated definition"]
    scope := "paper (ii.b) compatibility = (ii.b.1) IH-pullback + (ii.b.2) placement" }

def gap_paper_formHM : StrictGapEntry :=
  { name := "paper_formHM_EVII_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "Master tex \\ref{hyp:ChernWeil-bridge-E7} clause (ii.b) framework (L11580-11625) — form-level HM proportionality for EVII"
    attackHistory := ["P25: 3-input workingAssumption",
                      "P26: \\label anchored",
                      "P28 close target: decompose via Mumford 1977 + BKK 2002 + EVII-specific extensions"]
    scope := "paper form-HM-EVII reduction; close target P28" }

def gap_paper_section16_2 : StrictGapEntry :=
  { name := "paper_section16_2_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "Master tex §16.2 E_6-rep-compat residual + \\ref{rem:E6-V27-vacuity} (L3063) V_27 vacuity discussion"
    attackHistory := ["P25: 4-input workingAssumption",
                      "P26: \\label anchored to §16.2 + V_27 vacuity remark",
                      "P30 close target: decompose via boundary stratification + Chern generation"]
    scope := "paper §16.2 E_6-rep-compat reduction; close target P30" }

def gap_paper_GP_EVII : StrictGapEntry :=
  { name := "paper_GP_EVII_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "Master tex \\ref{hyp:ChernWeil-bridge-E7} (ii.b) G-P-EVII extension + Goresky-Pardon 2002 Invent. Math. 147 §1.6 explicit open"
    attackHistory := ["P25: 3-input workingAssumption",
                      "P26: \\label anchored",
                      "P29 close target: decompose via Borel-Hirzebruch + GP-abstract + §16.2-rep-compat chain"]
    scope := "paper G-P-EVII Chern-subalgebra extension; close target P29" }

def gap_paper_clause_iii : StrictGapEntry :=
  { name := "paper_clause_iii_polynomial_identity_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .workingAssumption
    paperSource := "Master tex \\ref{thm:E7_chernweil} (L3237) clause (iii) polynomial identity theorem"
    attackHistory := ["P25: 4-input workingAssumption — paper's clause (iii) reduction",
                      "P26: \\label anchored to thm:E7_chernweil + cor:E7_shimura_closed",
                      "P31 close target: decompose via (i.b) + (ii.a) + (ii.b) + G-P-EVII chain per master tex L3237-3414"]
    scope := "paper clause-iii polynomial identity [q] = P(c_1,...,c_4); close target P31" }

def gap_paper_HC_equals_algebraicity : StrictGapEntry :=
  { name := "paper_HC_equals_algebraicity_OPEN"
    status := .gapOpen, inputCategory := .cat3PaperNovel
    cat3SubType := .structuralEquation
    paperSource := "Master tex \\ref{thm:main} (L410) Main Theorem definitional setup: HC for class = algebraicity"
    attackHistory := ["P25: §3.4.3 structural defining equation; HC = algebraicity (paper def)",
                      "P26: \\label anchored to thm:main"]
    scope := "paper HC = algebraicity definitional equation (§3.4.3 paper-stated)" }

/-! ### Derived gapClosedConditional theorems -/

def gap_cohomologyIso_CONDITIONAL : StrictGapEntry :=
  { name := "cohomologyIso_at_deg8_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived: Borel 1974 applied to Hyp_BorelMAtLeast8"
    attackHistory := ["P25: derived theorem"]
    scope := "cohomology iso (derived)"
    conditionalOn := ["Hyp_BorelMAtLeast8_OPEN"] }

def gap_freudenthal_H8_auto_CONDITIONAL : StrictGapEntry :=
  { name := "freudenthal_H8_auto_G_invariant_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived via paper_hodge44_step + cohomologyIso + Bott-BBW"
    attackHistory := ["P25: derived theorem"]
    scope := "Hodge-(4,4) auto-G-invariant (derived)"
    conditionalOn := ["Hyp_BorelMAtLeast8_OPEN"] }

def gap_formHM_CONDITIONAL : StrictGapEntry :=
  { name := "formLevel_HM_proportionality_EVII_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived via paper_formHM_EVII applied to Mumford + 2 Hyp_*"
    attackHistory := ["P25: derived theorem"]
    scope := "form-HM-EVII (derived)"
    conditionalOn := ["Hyp_HigherRank_GoodMetric_OPEN",
                      "Hyp_ChernWeilForm_Proportionality_OPEN"] }

def gap_section16_2_CONDITIONAL : StrictGapEntry :=
  { name := "section16_2_E6_rep_compat_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived via paper_section16_2 + boundary + V_27/V_56 folklore + form-HM-CONDITIONAL"
    attackHistory := ["P25: derived theorem"]
    scope := "§16.2 E_6-rep-compat (derived)"
    conditionalOn := ["Hyp_HigherRank_GoodMetric_OPEN",
                      "Hyp_ChernWeilForm_Proportionality_OPEN"] }

def gap_goreskyPardon_EVII_CONDITIONAL : StrictGapEntry :=
  { name := "goreskyPardon_EVII_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived via paper_GP_EVII + B-H folklore + G-P-2002 + §16.2-CONDITIONAL"
    attackHistory := ["P25: derived theorem"]
    scope := "G-P-EVII (derived)"
    conditionalOn := ["Hyp_HigherRank_GoodMetric_OPEN",
                      "Hyp_ChernWeilForm_Proportionality_OPEN"] }

def gap_freudenthal_realized_CONDITIONAL : StrictGapEntry :=
  { name := "freudenthal_realized_by_G_invariant_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived via paper_iia_realization + V-Z + KV + Franke + Hodge-(4,4)-CONDITIONAL + 2 Hyp_*"
    attackHistory := ["P25: derived theorem; consumes all (ii.a) Cat 2 frameworks"]
    scope := "(ii.a) realization (derived)"
    conditionalOn := ["Hyp_BorelMAtLeast8_OPEN",
                      "Hyp_VZ_AqLambda_OPEN",
                      "Hyp_Eisenstein_Vanishing_OPEN"] }

def gap_freudenthal_extends_CONDITIONAL : StrictGapEntry :=
  { name := "freudenthal_extends_compatibly_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "derived via paper_iib_compatibility + BBD/Saito/GM + Hyp_*"
    attackHistory := ["P25: derived theorem"]
    scope := "(ii.b) compatibility (derived)"
    conditionalOn := ["Hyp_FreudenthalClassPlacement_OPEN"] }

def gap_HC_Main : StrictGapEntry :=
  { name := "HC_for_freudenthal_quartic_on_EVII_CONDITIONAL"
    status := .gapClosedConditional, inputCategory := .cat3PaperNovel
    cat3SubType := .notApplicable
    paperSource := "Master tex \\ref{thm:main} (L410) Main Theorem: HC for [q] on EVII via Mumford-Tate reduction"
    attackHistory := [
      "P7-P22 exploratory reduction-stage ledger",
      "P23 strict refactor (had vacuous Hyp_* + composite axioms)",
      "P24 audit-driven fix (introduced invented intermediates)",
      "P25 audit-driven consolidation: deleted intermediates, multi-input workingAssumption tagged honestly, all Cat 2 frameworks load-bearing",
      "P26 minor: \\label anchors + folkloric Cat 2 dependencies acknowledged + round close-targets in workingAssumption attackHistory"
    ]
    scope := "HC for Freudenthal quartic [q] on EVII Shimura varieties"
    conditionalOn := [
      -- 7 Hyp_* broken-link predicates (explicit in theorem signature)
      "Hyp_BorelMAtLeast8_OPEN", "Hyp_VZ_AqLambda_OPEN",
      "Hyp_Eisenstein_Vanishing_OPEN", "Hyp_HigherRank_GoodMetric_OPEN",
      "Hyp_ChernWeilForm_Proportionality_OPEN",
      "Hyp_FreudenthalClassPlacement_OPEN",
      "Hyp_CrossRingPhiNonzero_OPEN",
      -- 3 folkloric Cat 2 BLOCKED dependencies (also in proof chain per P26 audit suggestion)
      "borel_hirzebruch_mimura_toda_E6_U1_BLOCKED",
      "borel_toda_kono_mimura_V27_BLOCKED",
      "kono_mimura_mimura_toda_V56_BLOCKED",
      -- 7 paper workingAssumption axioms (must close pending derivation)
      "paper_iia_realization_OPEN", "paper_formHM_EVII_OPEN",
      "paper_section16_2_OPEN", "paper_GP_EVII_OPEN",
      "paper_clause_iii_polynomial_identity_OPEN",
      "paper_hodge44_step_OPEN", "paper_iib_compatibility_OPEN"
    ] }

/-! ### All-entries roll-up -/

def allEntries : List StrictGapEntry := [
  -- Cat 3 carriers + hypothesis predicates (28)
  gap_borelM_E7minus25, gap_H8_compactDualEVII_is_44_bigrading,
  gap_cohomologyIso_at_deg8, gap_freudenthal_H8_auto_G_invariant,
  gap_formLevel_HM_proportionality_EVII, gap_freudenthal_realized_by_G_invariant,
  gap_ih_pullback_freudenthal, gap_freudenthal_extends_compatibly_deg8,
  gap_goreskyPardon_extension_to_EVII, gap_section16_2_E6_rep_compat,
  gap_evii_codim1_boundary_is_eiii, gap_chernV27_generates_BE6,
  gap_chernV56_generates_BE7, gap_borelHirzebruch_presentation,
  gap_gpAbstract_group_agnostic, gap_mumford_canonical_extension_framework,
  gap_voganZuckerman_1984_framework, gap_knappVogan_1995_induction,
  gap_franke_1998_framework, gap_polynomial_identity_freudenthal,
  gap_freudenthal_is_algebraic, gap_HC_for_freudenthal_target,
  gap_higher_rank_good_metric, gap_chern_weil_form_proportionality,
  gap_freudenthal_placed, gap_cross_ring_phi_nonzero,
  gap_voganZuckermanAqLambda, gap_eisensteinVanishing,
  -- Hyp_* (7)
  gap_Hyp_BorelMAtLeast8, gap_Hyp_VZ_AqLambda, gap_Hyp_Eisenstein_Vanishing,
  gap_Hyp_HigherRank_GoodMetric, gap_Hyp_ChernWeilForm_Proportionality,
  gap_Hyp_FreudenthalClassPlacement, gap_Hyp_CrossRingPhiNonzero,
  -- Cat 2 (13)
  gap_bott_borel_weil, gap_borel_1974, gap_bbd_saito_gm,
  gap_goresky_pardon_2002_looijenga, gap_wolf_satake_borel_ji,
  gap_mumford_1977, gap_vogan_zuckerman, gap_knapp_vogan_1995,
  gap_franke_1998, gap_borel_hirzebruch_E6_BLOCKED, gap_V27_BE6_BLOCKED,
  gap_V56_BE7_BLOCKED, gap_polynomial_is_algebraic,
  -- Cat 3 workingAssumption + structuralEquation (8)
  gap_paper_hodge44, gap_paper_iia, gap_paper_iib, gap_paper_formHM,
  gap_paper_section16_2, gap_paper_GP_EVII, gap_paper_clause_iii,
  gap_paper_HC_equals_algebraicity,
  -- Derived gapClosedConditional (8)
  gap_cohomologyIso_CONDITIONAL, gap_freudenthal_H8_auto_CONDITIONAL,
  gap_formHM_CONDITIONAL, gap_section16_2_CONDITIONAL,
  gap_goreskyPardon_EVII_CONDITIONAL, gap_freudenthal_realized_CONDITIONAL,
  gap_freudenthal_extends_CONDITIONAL, gap_HC_Main
]

-- ============================================================================
-- §10: #eval verification (cross-table + invariant check)
-- ============================================================================

def countByStatus : List (StrictGapStatus × Nat) :=
  let s : List StrictGapStatus := [.gapOpen, .gapPartial, .gapBlocked,
                                    .gapDeadEnd, .gapClosed, .gapClosedConditional]
  s.map fun x => (x, allEntries.filter (·.status = x) |>.length)

def countByInputCategory : List (InputCategory × Nat) :=
  let c : List InputCategory := [.cat0Kernel, .cat1Mathlib, .cat2External, .cat3PaperNovel]
  c.map fun x => (x, allEntries.filter (·.inputCategory = x) |>.length)

def countCat3BySubType : List (Cat3SubType × Nat) :=
  let cat3 := allEntries.filter (·.inputCategory = .cat3PaperNovel)
  let t : List Cat3SubType := [.carrier, .hypothesisPredicate, .structuralEquation,
                                .workingAssumption, .conditionalHypothesis]
  t.map fun x => (x, cat3.filter (·.cat3SubType = x) |>.length)

def totalEntries : Nat := allEntries.length

def openHypNames : List String :=
  allEntries.filter (·.name.startsWith "Hyp_") |>.map (·.name)

def gapClosedConditionalBacklog : List String :=
  allEntries.filter (·.status = .gapClosedConditional) |>.map (·.name)

/-- §12.2 invariant: status = gapClosedConditional ↔ conditionalOn ≠ []. -/
def conditionalInvariantHolds : Bool :=
  allEntries.all fun e =>
    (e.status = .gapClosedConditional) = (¬ e.conditionalOn.isEmpty)

end HodgeReduction.Strict

#eval s!"Total: {HodgeReduction.Strict.totalEntries}"
#eval s!"countByStatus: {repr HodgeReduction.Strict.countByStatus}"
#eval s!"countByInputCategory: {repr HodgeReduction.Strict.countByInputCategory}"
#eval s!"countCat3BySubType: {repr HodgeReduction.Strict.countCat3BySubType}"
#eval s!"openHypNames: {repr HodgeReduction.Strict.openHypNames}"
#eval s!"gapClosedConditionalBacklog: {repr HodgeReduction.Strict.gapClosedConditionalBacklog}"
#eval s!"conditionalInvariantHolds: {repr HodgeReduction.Strict.conditionalInvariantHolds}"

-- ============================================================================
-- P27: kernel-purity verification via `#print axioms` (discipline §1.5)
-- ============================================================================
--
-- The discipline §1.5 designates `#print axioms` as the "primary verification
-- tool". This block surfaces the exact axiom dependency of the Main Theorem
-- in the build log, allowing audit to verify which atoms are load-bearing.

#print axioms HodgeReduction.Strict.HC_for_freudenthal_quartic_on_EVII_CONDITIONAL
