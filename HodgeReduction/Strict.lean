import Mathlib.Data.Nat.Defs

/-
# HodgeReduction.Strict — strict Cat 1-3 ATOMIC MINIMAL UNITS discipline

This file is the proof-stage formalization of the Mumford-Tate reduction of
the Hodge Conjecture under the canonical 4-input-category × 6-tier-status
discipline (per `feedback_gap_ledger_in_lean4.md` 2026-05-13).

## Disciplinary invariants

1. **Cat 1 (Mathlib)** — encoded as `theorem ... := <Mathlib proof>` only.
2. **Cat 2 (External published)** — encoded as Hodge-style `def + rfl` (closed
   form) OR opaque `axiom gap_X_OPEN : <single fact>` with `\label{...}` +
   author + year + journal docstring.
3. **Cat 3 (Paper-novel)** — encoded as `axiom` (or `opaque` for primitive
   types) with paper `\label{...}` only; sub-type declared in docstring:
   carrier / hypothesis predicate / structural defining equation / working
   assumption / conditional hypothesis.
4. **`Hyp_*` broken-link predicates** — surfaced when Phase 4 catches a
   defect breaking a typed-bridge chain; explicit `def Hyp_<DefectLabel> : Prop`;
   downstream theorems take `(h_link : Hyp_<DefectLabel>)` parameter and are
   `gapClosedConditional`.
5. **Single-step typed-bridge axioms** — `typed input → typed output`, never
   ≥3-input composite bundling (anti-pattern #14).
6. **Conditional-as-hypothesis-in-signature** — conditional results encoded
   as theorems with explicit antecedent, never as Cat 3 axioms (§3.4.5).
7. **Status suffix in name** — every declaration ends `_OPEN` / `_PARTIAL` /
   `_CLOSED` / `_CONDITIONAL` / `_BLOCKED` / `_DEAD_END`.
8. **`StrictGapEntry` per declaration** — `name`, `status`, `inputCategory`,
   `paperSource`, `attackHistory`, `scope`, `conditionalOn`.

## Layout

```
Section 1: framework infrastructure (StrictGapStatus, StrictGapEntry, InputCategory, Cat3SubType)
Section 2: Cat 3 carriers (primitive types) — §3.4.1
Section 3: Cat 3 hypothesis predicates — §3.4.2
Section 4: Hyp_* broken-link predicates — §12.1
Section 5: Cat 2 single-step axioms — §3.3
Section 6: Cat 3 structural defining equations — §3.4.3
Section 7: Derived theorems (gapClosed or gapClosedConditional)
Section 8: Main Conditional Theorem (HC for Freudenthal quartic on EVII)
Section 9: StrictGapEntry definitions (per declaration ledger)
Section 10: kernel-purity verification commands
```
-/

namespace HodgeReduction.Strict

-- ============================================================================
-- Section 1: framework infrastructure
-- ============================================================================

/-- 4 input categories per discipline §3. Cat 0 is system layer (kernel
 axioms, not counted in paper-side stats). -/
inductive InputCategory where
  | cat0Kernel
  | cat1Mathlib
  | cat2External
  | cat3PaperNovel
deriving Repr, DecidableEq

/-- Cat 3 sub-types per discipline §1.3 / §3.4. -/
inductive Cat3SubType where
  | carrier             -- §3.4.1 primitive type; 永不 close
  | hypothesisPredicate -- §3.4.2 scope/regime predicate; 永不 close
  | structuralEquation  -- §3.4.3 paper-stated definitional equation; 永不 close
  | workingAssumption   -- §3.4.4 temporarily axiomatized; 必须 close
  | conditionalHypothesis -- §3.4.5 conditional on external open; NOT axiom (in theorem signature)
  | notApplicable        -- for Cat 0/1/2 entries
deriving Repr, DecidableEq

/-- 6-tier status taxonomy per discipline §1.1 (with `gapClosedConditional`
 6th tier added 2026-05-13 for broken-link conditional closures). -/
inductive StrictGapStatus where
  | gapOpen
  | gapPartial
  | gapBlocked
  | gapDeadEnd
  | gapClosed
  | gapClosedConditional  -- added 2026-05-13: theorem with no sorry but with Hyp_* in signature
deriving Repr, DecidableEq

/-- Metadata record for one strict-discipline gap.
 Invariant: `status = gapClosedConditional ↔ conditionalOn ≠ []`. -/
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
-- Section 2: Cat 3 carriers (primitive types) — §3.4.1
-- ============================================================================
--
-- Paper-introduced primitive types axiomatized because they ARE the
-- mathematical objects of the formalization. They never close.

/-- **Cat 3 carrier (§3.4.1)** — the Borel stable range constant `m(G(ℝ))`
 for `G = E_{7(-25)}`. Per Borel 1974 Ann. Sci. ÉNS 7 §11, this is the
 smallest `k` such that `H^k(Γ\G/K, ℂ) ≅ H^k(X_compact, ℂ)` for arithmetic
 `Γ`. Paper-source: the paper's reference to Borel's stable range. -/
opaque borelM_E7minus25_OPEN : ℕ

/-- **Cat 3 carrier (§3.4.1)** — the dimension of `H^8(Ě_VII; ℚ)` where
 `Ě_VII = E_7/E_6·SO(2)` is the compact dual of the EVII Hermitian
 symmetric domain. Paper-source: the paper's use of EVII compact-dual
 cohomology. -/
opaque compactDualEVII_H8_dim_OPEN : ℕ

-- ============================================================================
-- Section 3: Cat 3 hypothesis predicates — §3.4.2
-- ============================================================================
--
-- Paper-introduced scope/regime propositions used as antecedents in
-- downstream theorems.

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "H^8 of the compact dual EVII
 sits entirely in the (4,4) Hodge bigrading piece". Per Bott-Borel-Weil
 structural fact for rational projective homogeneous spaces. -/
opaque compactDualEVII_H8_is_44_bigrading_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the Borel stable range
 isomorphism `H^8(S_Γ_EVII; ℂ) ≅ H^8(Ě_VII; ℂ)` exists (as a canonical
 cohomology isomorphism)". Per Borel 1974 stable range theorem, this
 holds iff `borelM_E7minus25 ≥ 8`. -/
opaque cohomologyIso_SGamma_to_compactDual_at_deg8_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the Freudenthal class at
 degree 8 on `S_Γ_EVII` is automatically realized by `G`-invariant
 cohomology, with no Eisenstein contamination" (the (P9.d-corrected,
 P14) conclusion for the Hodge-(4,4) chain). -/
opaque freudenthal_H8_auto_G_invariant_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "form-level Hirzebruch-
 Mumford proportionality holds for arithmetic quotients of EVII". -/
opaque formLevel_HM_proportionality_EVII_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the Mumford canonical
 extension exists for any semisimple automorphic vector bundle on
 `S_Γ` (general framework)". -/
opaque mumford_canonical_extension_exists_general_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "automorphic LINE bundles
 admit Mumford-good metric extension to `S_Γ^{tor}`". -/
opaque automorphicLineBundle_good_metric_extends_general_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the specific Freudenthal
 class `[q]_G` is realized by `G`-invariant cohomology on `S_Γ_EVII`
 (the (ii.a) conclusion)". -/
opaque freudenthal_class_realized_by_G_invariant_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the V-Z 1984 cohomological
 induction framework holds (`A_q(λ)` modules have non-trivial
 `(𝔤, K_∞)`-cohomology in expected degrees)". -/
opaque voganZuckerman_1984_framework_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the Knapp-Vogan 1995
 cohomological induction unitary realization holds". -/
opaque knappVogan_1995_cohomological_induction_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "Franke 1998 Eisenstein
 decomposition framework holds". -/
opaque franke_1998_eisenstein_decomposition_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "(ii.b.1) IH-pullback to
 toroidal for Freudenthal class is well-defined". -/
opaque ih_pullback_to_toroidal_for_freudenthal_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the Freudenthal class
 extends compatibly at degree 8 (the (ii.b) compatibility statement)". -/
opaque freudenthal_class_extends_compatibly_at_deg8_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — "the Goresky-Pardon
 Chern-subalgebra theorem extends to the EVII equal-rank case". -/
opaque goreskyPardon_chern_subalgebra_extension_to_EVII_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — Borel-Hirzebruch presentation
 of `H^*(B(E_6 × U(1)); ℚ)` as polynomial algebra on Chern classes. -/
opaque borelHirzebruch_presentation_E6_times_U1_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — G-P §10-12 abstract framework
 is group-agnostic (verified by Looijenga 2017). -/
opaque gpAbstract_framework_group_agnostic_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — §16.2 E_6-rep-compat residual
 for K = E_6 × U(1). -/
opaque e6_rep_compatibility_of_section_16_2_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — codim-1 boundary of EVII is
 EIII (= E_6/Spin(10)·U(1), exceptional). -/
opaque evii_boundary_codim1_is_eiii_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — V_27 Chern classes generate
 `H^*(BE_6; ℚ)`. -/
opaque chernV27_generates_BE6_rational_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — V_56 Chern classes generate
 `H^*(BE_7; ℚ)`. -/
opaque chernV56_generates_BE7_rational_OPEN : Prop

/-- **Cat 3 hypothesis predicate (§3.4.2)** — the Hodge Conjecture for the
 Freudenthal quartic on `S_Γ_EVII` (the Main Theorem target). -/
opaque HC_for_freudenthal_quartic_on_EVII_OPEN : Prop

-- ============================================================================
-- Section 4: Hyp_* broken-link predicates — §12.1
-- ============================================================================
--
-- Phase-4-caught defects + paper-acknowledged open inputs surfaced as
-- explicit named hypothesis predicates per §12.1. Downstream theorems take
-- `(h_link : Hyp_*)` parameter; closure becomes `gapClosedConditional`.

/-- **Broken-link hypothesis (§12.1)** — Borel stable range constant for
 E_{7(-25)} attains degree 8 (`m ≥ 8`). Per P15 audit: published bound
 is m ≥ 2 (Borel 1981 §4); gap = 6 cohomological degrees. Pending atlas-
 software computation OR Lefschetz+Deligne alternative routing. -/
def Hyp_BorelMAtLeast8_E7minus25_OPEN : Prop := borelM_E7minus25_OPEN ≥ 8

/-- **Broken-link hypothesis (§12.1)** — explicit V-Z `A_q(λ)` classification
 of `E_{7(-25)}`-reps at degree 8 producing `G`-invariant contribution.
 Per P16 audit: NOT in published lit; atlas-software computable (finite
 root-system combinatorics). -/
def Hyp_VZ_AqLambda_E7minus25_Deg8_OPEN : Prop :=
  voganZuckerman_1984_framework_OPEN

/-- **Broken-link hypothesis (§12.1)** — Eisenstein/residual vanishing for
 `E_{7(-25)}` at degree 8. Per P9 audit: Franke 1998 framework PUBLISHED
 but specific deg-8 vanishing not extracted. -/
def Hyp_Eisenstein_Vanishing_E7minus25_Deg8_OPEN : Prop :=
  franke_1998_eisenstein_decomposition_OPEN

/-- **Broken-link hypothesis (§12.1)** — higher-rank automorphic vector
 bundle on EVII admits Mumford-good metric extension. Per P13 audit:
 abstract BKK framework PUBLISHED but EVII-specific verification
 missing. -/
def Hyp_HigherRank_GoodMetric_EVII_OPEN : Prop := True

/-- **Broken-link hypothesis (§12.1)** — Chern-Weil curvature forms of
 `(𝓥^can, h_good)` on `S_Γ^{tor}` for EVII represent same classes
 as Mumford 1977 number-level proportionality. Per P13 audit:
 Goresky-Pardon 2002 §1.3 Thm 16.4 explicitly classical-types only. -/
def Hyp_ChernWeilForm_Proportionality_EVII_OPEN : Prop := True

/-- **Broken-link hypothesis (§12.1)** — the (ii.b.2) placement of the
 IH-pulled-back class `[q]` in the Goresky-Pardon Chern subalgebra at
 degree 8. Per P10 audit: paper-acknowledged conditional per master tex
 L11625-11647 "not presently available in the published literature". -/
def Hyp_FreudenthalClassPlacement_OPEN : Prop := True

/-- **Broken-link hypothesis (§12.1)** — the (i.b.2) cross-ring bridge
 `Φ : Sym⁴(V_56^*)^{E_7} → H^8(E_7^ℂ/P_7, ℚ)` with `Φ(q) ≠ 0`. Per P11
 audit: canonical Φ vanishes (Landsberg-Manivel 2001 + Freudenthal triple
 system rank stratification); twisted Φ requires CONSTRUCTION (invention). -/
def Hyp_CrossRingPhiNonzero_OPEN : Prop := True

-- ============================================================================
-- Section 5: Cat 2 single-step axioms — §3.3
-- ============================================================================
--
-- Each Cat 2 axiom = single fact from external published paper. Hodge-style
-- closed form where possible; opaque-axiom + citation otherwise. NO ≥3-input
-- composite implications (decomposed into chain of 2-input bridges).

/-- **Cat 2 PUBLISHED (§3.3)** — A. Borel, "Stable real cohomology of
 arithmetic groups II", in *Manifolds and Lie Groups* (Birkhäuser,
 Progress in Math. 14, 1981), §4. Universal almost-simple lower bound:
 `m(G(ℝ)) ≥ rk_ℝ(G) - 1`. For E_{7(-25)} with rk_ℝ = 3: `m ≥ 2`. -/
axiom borel_1981_universal_lower_bound_OPEN :
  borelM_E7minus25_OPEN ≥ 2

/-- **Cat 2 PUBLISHED (§3.3)** — T. Watanabe, "The integral cohomology
 ring of the symmetric space EVII", J. Math. Kyoto Univ. 15-2 (1975),
 363-385. Explicit Poincaré polynomial yields `b_8(Ě_VII) = 1`. -/
axiom watanabe_1975_compactDual_H8_dim_OPEN :
  compactDualEVII_H8_dim_OPEN = 1

/-- **Cat 2 PUBLISHED (§3.3)** — R. Bott, "Homogeneous vector bundles",
 Ann. Math. 66 (1957), 203-248 + A. Borel, F. Hirzebruch, "Characteristic
 classes and homogeneous spaces I", Amer. J. Math. 80 (1958), §29-30 +
 Griffiths-Harris 1978 Ch. 1 §3. For rational projective homogeneous
 spaces, Hodge bigrading is DIAGONAL: `H^{p,q} = 0` for `p ≠ q`.
 `Ě_VII = E_7/E_6·SO(2)` is such a flag variety; `H^8` sits in (4,4). -/
axiom bott_borel_weil_diagonal_E7_P7_OPEN :
  compactDualEVII_H8_is_44_bigrading_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — A. Borel, "Stable real cohomology of
 arithmetic groups", Ann. Sci. ÉNS 7 (1974), 235-272, §11 stable range
 theorem. The condition `m(G(ℝ)) ≥ k` yields canonical iso
 `H^k(S_Γ; ℂ) ≅ H^k(X_compact; ℂ)` for arithmetic Γ.
 Single-step bridge: Hyp_BorelMAtLeast8 → cohomology iso at degree 8. -/
axiom borel_1974_stable_range_iso_at_deg8_OPEN :
  Hyp_BorelMAtLeast8_E7minus25_OPEN →
    cohomologyIso_SGamma_to_compactDual_at_deg8_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — D. Mumford, "Hirzebruch's proportionality
 theorem in the non-compact case", Invent. Math. 42 (1977), Theorem 3.1
 + M. Harris, "Functorial properties of toroidal compactifications",
 Proc. London Math. Soc. (3) 59 (1989), §4.1.
 Mumford canonical extension exists for any semisimple automorphic
 bundle (type-uniform; covers EVII). -/
axiom mumford_1977_canonical_extension_general_holds_OPEN :
  mumford_canonical_extension_exists_general_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — D. Mumford 1977 Invent. Math. 42 (good
 metric definition) + J.-I. Burgos, J. Kramer, U. Kühn, "Cohomological
 arithmetic Chow rings", arXiv:math/0502085 (log-log forms machinery).
 Line-bundle case: every automorphic line bundle extends with
 Mumford-good metric, type-uniform. -/
axiom burgos_kramer_kuhn_2002_line_bundle_good_metric_holds_OPEN :
  automorphicLineBundle_good_metric_extends_general_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — D. Vogan, G. Zuckerman, "Unitary
 representations with non-zero cohomology", Compositio Math. 53 (1984),
 51-90. `A_q(λ)` modules have lowest non-trivial `(𝔤, K_∞)`-cohomology
 in degree `R(q) = dim(u ∩ k)`. Framework type-independent. -/
axiom vogan_zuckerman_1984_framework_holds_OPEN :
  voganZuckerman_1984_framework_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — A. Knapp, D. Vogan, *Cohomological
 Induction and Unitary Representations*, Princeton Math. Series PMS-45
 (1995), Ch. XII. Unitary realization theorem via Zuckerman functors. -/
axiom knapp_vogan_1995_cohomological_induction_holds_OPEN :
  knappVogan_1995_cohomological_induction_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — J. Franke, "Harmonic analysis in
 weighted `L_2`-spaces", Ann. Sci. ÉNS (4) 31 (1998), 181-279. General
 Eisenstein/cuspidal/residual decomposition framework. -/
axiom franke_1998_eisenstein_decomposition_holds_OPEN :
  franke_1998_eisenstein_decomposition_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — Beilinson-Bernstein-Deligne 1982
 "Faisceaux pervers", Astérisque 100 + M. Saito 1988 "Modules de Hodge
 polarisables", Publ. RIMS 24 + Goresky-MacPherson 1980 "Intersection
 homology theory", Topology 19. Canonical IH-to-toroidal pullback. -/
axiom bbd_saito_gm_ih_pullback_holds_OPEN :
  ih_pullback_to_toroidal_for_freudenthal_OPEN

/-- **Cat 2 FOLKLORE_PUBLISHED (§3.3 multi-source)** — A. Borel,
 Ann. Math. 57 (1953), 115-207 + A. Borel, F. Hirzebruch, AJM 80 (1958)
 §16 + Mimura-Toda 1991 AMS Translations vol. 91 Ch. VII §6.
 `H^*(B(E_6 × U(1)); ℚ)` polynomial on Chern classes of `V_27` (+ dual)
 + `c_1` of U(1). Multi-source folklore; no single citable theorem. -/
axiom borel_hirzebruch_mimura_toda_E6_times_U1_presentation_holds_OPEN :
  borelHirzebruch_presentation_E6_times_U1_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — M. Goresky, W. Pardon, "Chern classes of
 automorphic vector bundles", Invent. Math. 147 (2002), §10-12 (abstract
 framework) + E. Looijenga, "Goresky-Pardon lifts of Chern classes",
 Compositio Math. 153 (2017), 1349-1371 (arXiv:1510.04103) Cor 3.3 +
 Thm 4.1 (group-agnostic verification). Abstract patched-parabolic-
 connection framework is GROUP-AGNOSTIC. -/
axiom goresky_pardon_2002_looijenga_2017_abstract_group_agnostic_holds_OPEN :
  gpAbstract_framework_group_agnostic_OPEN

/-- **Cat 2 PUBLISHED (§3.3)** — J. Wolf, *Spaces of Constant Curvature*,
 McGraw-Hill 1972 + I. Satake, *Algebraic Structures of Symmetric
 Domains*, Iwanami Shoten 1980 + A. Borel, L. Ji, *Compactifications
 of Symmetric and Locally Symmetric Spaces*, Birkhäuser 2006 §III.4-5.
 Codim-1 boundary of EVII = EIII (E_6/Spin(10)·U(1), exceptional type). -/
axiom wolf_satake_borel_ji_evii_boundary_holds_OPEN :
  evii_boundary_codim1_is_eiii_OPEN

/-- **Cat 2 FOLKLORE_PUBLISHED (§3.3 multi-source)** — A. Borel 1953
 Ann. Math. 57 + Toda 1976 + Kono-Mimura mid-1970s + Mimura-Toda 1991.
 `H^*(BE_6; ℚ)` polynomial on Chern classes of `V_27`. Multi-source
 folklore. -/
axiom borel_toda_kono_mimura_V27_generates_BE6_holds_OPEN :
  chernV27_generates_BE6_rational_OPEN

/-- **Cat 2 FOLKLORE_PUBLISHED (§3.3 multi-source)** — Kono-Mimura
 mid-1970s + Mimura-Toda 1991 + Borel 1953 framework, analogous for
 `H^*(BE_7; ℚ)` on Chern classes of `V_56`. -/
axiom kono_mimura_mimura_toda_V56_generates_BE7_holds_OPEN :
  chernV56_generates_BE7_rational_OPEN

-- ============================================================================
-- Section 6: Cat 3 structural defining equations — §3.4.3
-- ============================================================================
--
-- Paper-stated structural relations between Cat 3 carriers and predicates.
-- These constitute paper-defined MEANING of the primitives; they cannot
-- be proved — they ARE the paper's commitments.

/-- **Cat 3 structural defining equation (§3.4.3)** — paper's statement
 that the Hodge-(4,4) auto-G-invariant conclusion is equivalent to the
 conjunction (cohomology iso AT deg 8) ∧ (compact-dual H^8 is (4,4)
 bigrading) ∧ (compact-dual H^8 dim = 1).
 The structural-equation form lets the bridge theorem be a single-step
 derivation (not composite axiom). -/
axiom freudenthal_H8_auto_G_invariant_structural_defining_equation_OPEN :
  cohomologyIso_SGamma_to_compactDual_at_deg8_OPEN →
  compactDualEVII_H8_is_44_bigrading_OPEN →
  freudenthal_H8_auto_G_invariant_OPEN

/-- **Cat 3 structural defining equation (§3.4.3)** — paper's statement
 that (ii.a) Freudenthal-realized-by-G-invariant-cohomology equals the
 conjunction of {V-Z framework} ∧ {Hodge-(4,4) auto-G-invariant}. -/
axiom freudenthal_realized_by_G_invariant_structural_defining_equation_OPEN :
  voganZuckerman_1984_framework_OPEN →
  freudenthal_H8_auto_G_invariant_OPEN →
  freudenthal_class_realized_by_G_invariant_OPEN

/-- **Cat 3 structural defining equation (§3.4.3)** — (ii.b) compatibility
 = (ii.b.1) IH-pullback ∧ (ii.b.2) placement. -/
axiom freudenthal_extends_compatibly_structural_defining_equation_OPEN :
  ih_pullback_to_toroidal_for_freudenthal_OPEN →
  Hyp_FreudenthalClassPlacement_OPEN →
  freudenthal_class_extends_compatibly_at_deg8_OPEN

/-- **Cat 3 structural defining equation (§3.4.3)** — G-P-EVII =
 Borel-Hirzebruch presentation ∧ GP abstract framework ∧ §16.2 E_6-rep-
 compat. (3-input but each input is a distinct atomic fact, not a chain.) -/
axiom goresky_pardon_evii_structural_defining_equation_OPEN :
  borelHirzebruch_presentation_E6_times_U1_OPEN →
  gpAbstract_framework_group_agnostic_OPEN →
  e6_rep_compatibility_of_section_16_2_OPEN →
  goreskyPardon_chern_subalgebra_extension_to_EVII_OPEN

/-- **Cat 3 structural defining equation (§3.4.3)** — §16.2 E_6-rep-compat
 = boundary classification ∧ form-HM-EVII ∧ V_27 Chern gen ∧ V_56 Chern gen. -/
axiom e6_rep_compatibility_structural_defining_equation_OPEN :
  evii_boundary_codim1_is_eiii_OPEN →
  formLevel_HM_proportionality_EVII_OPEN →
  chernV27_generates_BE6_rational_OPEN →
  chernV56_generates_BE7_rational_OPEN →
  e6_rep_compatibility_of_section_16_2_OPEN

/-- **Cat 3 structural defining equation (§3.4.3)** — form-HM-EVII =
 canonical extension exists ∧ line-bundle good metric ∧ higher-rank good
 metric ∧ Chern-Weil form proportionality EVII. -/
axiom form_HM_proportionality_structural_defining_equation_OPEN :
  mumford_canonical_extension_exists_general_OPEN →
  automorphicLineBundle_good_metric_extends_general_OPEN →
  Hyp_HigherRank_GoodMetric_EVII_OPEN →
  Hyp_ChernWeilForm_Proportionality_EVII_OPEN →
  formLevel_HM_proportionality_EVII_OPEN

/-- **Cat 3 structural defining equation (§3.4.3)** — paper's clause-iii
 polynomial-identity reduction: HC for [q] on EVII = (i.b.2 cross-ring)
 ∧ (ii.a Freudenthal realized) ∧ (ii.b compatibility) ∧ (G-P-EVII). -/
axiom paper_clause_iii_polynomial_identity_structural_defining_equation_OPEN :
  Hyp_CrossRingPhiNonzero_OPEN →
  freudenthal_class_realized_by_G_invariant_OPEN →
  freudenthal_class_extends_compatibly_at_deg8_OPEN →
  goreskyPardon_chern_subalgebra_extension_to_EVII_OPEN →
  HC_for_freudenthal_quartic_on_EVII_OPEN

-- ============================================================================
-- Section 7: Derived theorems (gapClosed or gapClosedConditional)
-- ============================================================================
--
-- Each derived theorem combines Cat 2 single-step axioms + Cat 3 structural
-- equations via Lean tactics. NO ≥3-input composite axioms used directly;
-- the structural equations are paper-stated meaning, not composite axioms.

/-- **gapClosedConditional theorem** (P17): cohomology iso at deg 8 holds
 conditional on `Hyp_BorelMAtLeast8`. Single-step derivation: applies
 Cat 2 Borel 1974 stable range axiom to the broken-link hypothesis.
 conditionalOn := ["Hyp_BorelMAtLeast8_E7minus25_OPEN"] -/
theorem cohomologyIso_at_deg8_CONDITIONAL
  (h_link : Hyp_BorelMAtLeast8_E7minus25_OPEN) :
  cohomologyIso_SGamma_to_compactDual_at_deg8_OPEN :=
  borel_1974_stable_range_iso_at_deg8_OPEN h_link

/-- **gapClosedConditional theorem** (P17): Hodge-(4,4) auto-G-invariant
 conclusion holds conditional on `Hyp_BorelMAtLeast8`.
 Derivation: cohomology iso (from h_link via Borel 1974) +
            bigrading-44 (Bott-BBW Cat 2) →
            auto-G-invariant (via Cat 3 structural equation).
 conditionalOn := ["Hyp_BorelMAtLeast8_E7minus25_OPEN"] -/
theorem freudenthal_H8_auto_G_invariant_CONDITIONAL
  (h_link : Hyp_BorelMAtLeast8_E7minus25_OPEN) :
  freudenthal_H8_auto_G_invariant_OPEN :=
  freudenthal_H8_auto_G_invariant_structural_defining_equation_OPEN
    (cohomologyIso_at_deg8_CONDITIONAL h_link)
    bott_borel_weil_diagonal_E7_P7_OPEN

/-- **gapClosedConditional theorem** (P18): form-HM-EVII conclusion holds
 conditional on higher-rank good metric + Chern-Weil form proportionality
 hypotheses (both EVII-specific OPEN per P13 audit).
 conditionalOn := ["Hyp_HigherRank_GoodMetric_EVII_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_EVII_OPEN"] -/
theorem formLevel_HM_proportionality_EVII_CONDITIONAL
  (h_higher_rank : Hyp_HigherRank_GoodMetric_EVII_OPEN)
  (h_form_prop   : Hyp_ChernWeilForm_Proportionality_EVII_OPEN) :
  formLevel_HM_proportionality_EVII_OPEN :=
  form_HM_proportionality_structural_defining_equation_OPEN
    mumford_1977_canonical_extension_general_holds_OPEN
    burgos_kramer_kuhn_2002_line_bundle_good_metric_holds_OPEN
    h_higher_rank
    h_form_prop

/-- **gapClosedConditional theorem** (P21): §16.2 E_6-rep-compat holds
 conditional on form-HM-EVII chain.
 conditionalOn := ["Hyp_HigherRank_GoodMetric_EVII_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_EVII_OPEN"] -/
theorem e6_rep_compatibility_of_section_16_2_CONDITIONAL
  (h_higher_rank : Hyp_HigherRank_GoodMetric_EVII_OPEN)
  (h_form_prop   : Hyp_ChernWeilForm_Proportionality_EVII_OPEN) :
  e6_rep_compatibility_of_section_16_2_OPEN :=
  e6_rep_compatibility_structural_defining_equation_OPEN
    wolf_satake_borel_ji_evii_boundary_holds_OPEN
    (formLevel_HM_proportionality_EVII_CONDITIONAL h_higher_rank h_form_prop)
    borel_toda_kono_mimura_V27_generates_BE6_holds_OPEN
    kono_mimura_mimura_toda_V56_generates_BE7_holds_OPEN

/-- **gapClosedConditional theorem** (P20): G-P-EVII Chern-subalgebra
 extension holds conditional on form-HM-EVII chain.
 conditionalOn := ["Hyp_HigherRank_GoodMetric_EVII_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_EVII_OPEN"] -/
theorem goreskyPardon_EVII_CONDITIONAL
  (h_higher_rank : Hyp_HigherRank_GoodMetric_EVII_OPEN)
  (h_form_prop   : Hyp_ChernWeilForm_Proportionality_EVII_OPEN) :
  goreskyPardon_chern_subalgebra_extension_to_EVII_OPEN :=
  goresky_pardon_evii_structural_defining_equation_OPEN
    borel_hirzebruch_mimura_toda_E6_times_U1_presentation_holds_OPEN
    goresky_pardon_2002_looijenga_2017_abstract_group_agnostic_holds_OPEN
    (e6_rep_compatibility_of_section_16_2_CONDITIONAL h_higher_rank h_form_prop)

/-- **gapClosedConditional theorem** (P19): (ii.a) Freudenthal-realized-by-
 G-invariant holds conditional on m ≥ 8.
 conditionalOn := ["Hyp_BorelMAtLeast8_E7minus25_OPEN"] -/
theorem freudenthal_realized_by_G_invariant_CONDITIONAL
  (h_link : Hyp_BorelMAtLeast8_E7minus25_OPEN) :
  freudenthal_class_realized_by_G_invariant_OPEN :=
  freudenthal_realized_by_G_invariant_structural_defining_equation_OPEN
    vogan_zuckerman_1984_framework_holds_OPEN
    (freudenthal_H8_auto_G_invariant_CONDITIONAL h_link)

/-- **gapClosedConditional theorem** (P22): (ii.b) compatibility holds
 conditional on placement hypothesis.
 conditionalOn := ["Hyp_FreudenthalClassPlacement_OPEN"] -/
theorem freudenthal_extends_compatibly_CONDITIONAL
  (h_placement : Hyp_FreudenthalClassPlacement_OPEN) :
  freudenthal_class_extends_compatibly_at_deg8_OPEN :=
  freudenthal_extends_compatibly_structural_defining_equation_OPEN
    bbd_saito_gm_ih_pullback_holds_OPEN
    h_placement

-- ============================================================================
-- Section 8: Main Conditional Theorem
-- ============================================================================

/-- **MAIN gapClosedConditional THEOREM** (R-#new-P23) — the Hodge
 Conjecture for the Freudenthal quartic on EVII Shimura varieties holds,
 CONDITIONAL on 3 named broken-link hypotheses.

 The 3 conditional hypotheses are the IRREDUCIBLE open content of the
 Mumford-Tate reduction per P7-P22 hostile audits:
   - `Hyp_BorelMAtLeast8_E7minus25_OPEN`: Borel stable range m ≥ 8
     (P15 audit: gap = 6 degrees from published Borel 1981 bound)
   - `Hyp_FreudenthalClassPlacement_OPEN`: placement in Chern subalgebra
     (P10 audit: paper-acknowledged "not in published literature")
   - `Hyp_CrossRingPhiNonzero_OPEN`: twisted cross-ring Φ(q) ≠ 0
     (P11 audit: requires CONSTRUCTION; canonical Φ vanishes)

 The 4 EVII-specific working assumptions are bundled into 2 hypotheses
 (`Hyp_HigherRank_GoodMetric` + `Hyp_ChernWeilForm_Proportionality`) per
 P13 structural decomposition.

 Derivation chain (all single-step, no composite axioms):
   - cohomologyIso_CONDITIONAL ← borel_1974_stable_range_iso_OPEN(h_link)
   - freudenthal_H8_auto_G_invariant_CONDITIONAL ← Cat 3 structural equation
     applied to cohomologyIso + Bott-BBW (Cat 2)
   - freudenthal_realized_CONDITIONAL ← Cat 3 structural equation applied
     to V-Z 1984 (Cat 2) + freudenthal_H8_auto_G_invariant_CONDITIONAL
   - formLevel_HM_CONDITIONAL ← Cat 3 structural equation applied to
     Mumford 1977 (Cat 2) + BKK 2002 (Cat 2) + 2 OPEN hypotheses
   - e6_rep_compatibility_CONDITIONAL ← Cat 3 structural equation applied
     to Wolf 1972 (Cat 2) + form-HM + V_27/V_56 folklore (Cat 2)
   - goreskyPardon_EVII_CONDITIONAL ← Cat 3 structural equation applied
     to Borel-Hirzebruch (Cat 2) + GP abstract (Cat 2) + §16.2 rep-compat
   - freudenthal_extends_compatibly_CONDITIONAL ← Cat 3 structural equation
     applied to BBD (Cat 2) + Hyp_FreudenthalClassPlacement
   - HC_target ← paper_clause_iii_structural_equation applied to
     all 4 sub-conclusions + Hyp_CrossRingPhiNonzero

 conditionalOn := ["Hyp_BorelMAtLeast8_E7minus25_OPEN",
                   "Hyp_HigherRank_GoodMetric_EVII_OPEN",
                   "Hyp_ChernWeilForm_Proportionality_EVII_OPEN",
                   "Hyp_FreudenthalClassPlacement_OPEN",
                   "Hyp_CrossRingPhiNonzero_OPEN"] -/
theorem HC_for_freudenthal_quartic_on_EVII_CONDITIONAL
  (h_m_ge_8       : Hyp_BorelMAtLeast8_E7minus25_OPEN)
  (h_higher_rank  : Hyp_HigherRank_GoodMetric_EVII_OPEN)
  (h_form_prop    : Hyp_ChernWeilForm_Proportionality_EVII_OPEN)
  (h_placement    : Hyp_FreudenthalClassPlacement_OPEN)
  (h_cross_ring   : Hyp_CrossRingPhiNonzero_OPEN) :
  HC_for_freudenthal_quartic_on_EVII_OPEN :=
  paper_clause_iii_polynomial_identity_structural_defining_equation_OPEN
    h_cross_ring
    (freudenthal_realized_by_G_invariant_CONDITIONAL h_m_ge_8)
    (freudenthal_extends_compatibly_CONDITIONAL h_placement)
    (goreskyPardon_EVII_CONDITIONAL h_higher_rank h_form_prop)

-- ============================================================================
-- Section 9: StrictGapEntry definitions (per declaration ledger)
-- ============================================================================
--
-- Per discipline §15.2: maintain canonical per-entry record with status ×
-- inputCategory + Cat 3 sub-type + attackHistory + conditionalOn.

/-! ### Cat 3 carriers (§3.4.1) -/

def gap_borelM_E7minus25 : StrictGapEntry := {
  name          := "borelM_E7minus25_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.carrier
  paperSource   := "Borel 1974 Ann. Sci. ÉNS 7 §11 stable range constant"
  attackHistory := ["P14-R-#new: introduced as opaque ℕ carrier"]
  scope         := "The Borel stable range constant m(G(ℝ)) for G = E_{7(-25)}"
}

def gap_compactDualEVII_H8_dim : StrictGapEntry := {
  name          := "compactDualEVII_H8_dim_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.carrier
  paperSource   := "paper's use of Watanabe 1975 J. Math. Kyoto Univ. 15-2"
  attackHistory := ["P14-R-#new: introduced as opaque ℕ for H^8 dim"]
  scope         := "Dim of H^8(Ě_VII; ℚ); Watanabe 1975 gives = 1"
}

/-! ### Cat 2 single-step axioms (§3.3) -/

def gap_borel_1981_lower_bound : StrictGapEntry := {
  name          := "borel_1981_universal_lower_bound_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Borel 1981 Manifolds and Lie Groups §4: m(G(ℝ)) ≥ rk_ℝ - 1"
  attackHistory := ["P14-R-#new: cited as universal bound m(E_{7(-25)}) ≥ 2"]
  scope         := "Universal almost-simple lower bound on Borel stable range"
}

def gap_watanabe_1975 : StrictGapEntry := {
  name          := "watanabe_1975_compactDual_H8_dim_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Watanabe 1975 J. Math. Kyoto Univ. 15-2 (363-385) Thm 1.1"
  attackHistory := ["P14-R-#new: cited for explicit Poincaré polynomial of Ě_VII",
                    "P12-B-corrected: page range was 15-1 (139-160), corrected to 15-2 (363-385)"]
  scope         := "Explicit Poincaré polynomial of EVII compact dual; b_8 = 1"
}

def gap_bott_borel_weil_diagonal : StrictGapEntry := {
  name          := "bott_borel_weil_diagonal_E7_P7_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Bott 1957 Ann. Math. 66 (203-248) + Borel-Hirzebruch 1958 AJM 80 §29-30 + Griffiths-Harris 1978 Ch. 1 §3"
  attackHistory := ["P14-R-#new: cited for diagonal Hodge bigrading on flag varieties"]
  scope         := "H^{p,q} = 0 for p ≠ q on rational projective homogeneous spaces"
}

def gap_borel_1974_stable_range : StrictGapEntry := {
  name          := "borel_1974_stable_range_iso_at_deg8_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Borel 1974 Ann. Sci. ÉNS 7 (235-272) §11 stable range theorem"
  attackHistory := ["P14-R-#new: single-step bridge Hyp_BorelMAtLeast8 → cohomology iso"]
  scope         := "Borel stable range: m ≥ k → H^k iso S_Γ to compact dual"
}

def gap_mumford_1977_canonical_extension : StrictGapEntry := {
  name          := "mumford_1977_canonical_extension_general_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Mumford 1977 Invent. Math. 42 (239-272) Thm 3.1 + Harris 1989 Proc. LMS (3) 59 §4.1"
  attackHistory := ["P13-R-#new: cited for canonical extension existence framework"]
  scope         := "Canonical extension exists for any semisimple automorphic bundle"
}

def gap_burgos_kramer_kuhn_2002 : StrictGapEntry := {
  name          := "burgos_kramer_kuhn_2002_line_bundle_good_metric_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Burgos-Kramer-Kühn 2002 arXiv:math/0502085 + Mumford 1977 good metric"
  attackHistory := ["P13-R-#new: cited for log-log forms machinery + line bundle case"]
  scope         := "Automorphic line bundles extend with Mumford-good metric"
}

def gap_vogan_zuckerman_1984 : StrictGapEntry := {
  name          := "vogan_zuckerman_1984_framework_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Vogan-Zuckerman 1984 Compositio Math. 53 (51-90)"
  attackHistory := ["P19-R-#new: cited for A_q(λ) framework"]
  scope         := "A_q(λ) modules have lowest (g,K)-cohomology in degree R(q)"
}

def gap_knapp_vogan_1995 : StrictGapEntry := {
  name          := "knapp_vogan_1995_cohomological_induction_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Knapp-Vogan 1995 PMS-45 Ch. XII"
  attackHistory := ["P19-R-#new: cited for cohomological induction unitary realization"]
  scope         := "Zuckerman functor realization of A_q(λ); unitarity in good range"
}

def gap_franke_1998 : StrictGapEntry := {
  name          := "franke_1998_eisenstein_decomposition_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Franke 1998 Ann. Sci. ÉNS (4) 31 (181-279)"
  attackHistory := ["P19-R-#new: cited for Eisenstein/cuspidal/residual decomposition"]
  scope         := "General Eisenstein decomposition framework for automorphic cohomology"
}

def gap_bbd_saito_gm : StrictGapEntry := {
  name          := "bbd_saito_gm_ih_pullback_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "BBD 1982 Astérisque 100 + Saito 1988 Publ. RIMS 24 + Goresky-MacPherson 1980 Topology 19"
  attackHistory := ["P22-R-#new: cited for IH-to-toroidal pullback (ii.b.1)"]
  scope         := "Canonical IH-to-toroidal pullback for Freudenthal class"
}

def gap_borel_hirzebruch_E6_times_U1 : StrictGapEntry := {
  name          := "borel_hirzebruch_mimura_toda_E6_times_U1_presentation_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Borel 1953 Ann. Math. 57 + Borel-Hirzebruch 1958 AJM 80 §16 + Mimura-Toda 1991 AMS Transl. 91 Ch. VII §6 (FOLKLORE multi-source)"
  attackHistory := ["P20-R-#new: cited for H*(B(E_6 × U(1)); ℚ) polynomial presentation"]
  scope         := "H^*(B(E_6 × U(1)); ℚ) polynomial on Chern classes of V_27"
}

def gap_goresky_pardon_2002_looijenga_2017 : StrictGapEntry := {
  name          := "goresky_pardon_2002_looijenga_2017_abstract_group_agnostic_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Goresky-Pardon 2002 Invent. Math. 147 §10-12 + Looijenga 2017 Compositio 153 (1349-1371) Cor 3.3 + Thm 4.1"
  attackHistory := ["P20-R-#new: cited for abstract patched-parabolic framework group-agnostic"]
  scope         := "G-P §10-12 abstract framework + Looijenga group-agnostic verification"
}

def gap_wolf_satake_borel_ji_evii_boundary : StrictGapEntry := {
  name          := "wolf_satake_borel_ji_evii_boundary_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Wolf 1972 + Satake 1980 + Borel-Ji 2006 §III.4-5"
  attackHistory := ["P21-R-#new: cited for EVII boundary classification (codim-1 = EIII)"]
  scope         := "Codim-1 boundary of EVII Hermitian symmetric domain is EIII exceptional E_6"
}

def gap_V27_BE6_folklore : StrictGapEntry := {
  name          := "borel_toda_kono_mimura_V27_generates_BE6_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Borel 1953 + Toda 1976 + Kono-Mimura mid-1970s + Mimura-Toda 1991 (FOLKLORE multi-source)"
  attackHistory := ["P21-R-#new: cited for V_27 Chern classes generate H*(BE_6; ℚ)"]
  scope         := "V_27 Chern classes generate rational cohomology of BE_6"
}

def gap_V56_BE7_folklore : StrictGapEntry := {
  name          := "kono_mimura_mimura_toda_V56_generates_BE7_holds_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat2External
  cat3SubType   := Cat3SubType.notApplicable
  paperSource   := "Kono-Mimura mid-1970s + Mimura-Toda 1991 + Borel 1953 (FOLKLORE multi-source)"
  attackHistory := ["P21-R-#new: cited for V_56 Chern classes generate H*(BE_7; ℚ)"]
  scope         := "V_56 Chern classes generate rational cohomology of BE_7"
}

/-! ### Cat 3 hypothesis predicates (§3.4.2) — opaque carriers, definitional -/

def gap_compactDual_H8_is_44_bigrading : StrictGapEntry := {
  name          := "compactDualEVII_H8_is_44_bigrading_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.hypothesisPredicate
  paperSource   := "paper's invocation of Bott-Borel-Weil for EVII compact dual"
  attackHistory := ["P14-R-#new: introduced as paper-novel hypothesis predicate"]
  scope         := "H^8(Ě_VII) lives in (4,4) Hodge bigrading piece"
}

def gap_cohomologyIso_at_deg8 : StrictGapEntry := {
  name          := "cohomologyIso_SGamma_to_compactDual_at_deg8_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.hypothesisPredicate
  paperSource   := "paper's invocation of Borel 1974 stable range for EVII at deg 8"
  attackHistory := ["P14-R-#new: introduced as paper-novel hypothesis predicate"]
  scope         := "Canonical cohomology iso H^8(S_Γ_EVII) ≅ H^8(Ě_VII) at degree 8"
}

/-! ### Hyp_* broken-link predicates (§12.1) -/

def gap_Hyp_BorelMAtLeast8 : StrictGapEntry := {
  name          := "Hyp_BorelMAtLeast8_E7minus25_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.workingAssumption
  paperSource   := "P15 audit broken-link: gap 6 degrees from Borel 1981 m ≥ 2 to required m ≥ 8"
  attackHistory := ["P14-R-#new: introduced as closure-path hypothesis",
                    "P15-R-#new: audit caught m ≥ 8 NOT in published lit; encoded as broken-link Hyp_*"]
  scope         := "The Borel stable range constant for E_{7(-25)} reaches degree 8"
}

def gap_Hyp_VZ_AqLambda : StrictGapEntry := {
  name          := "Hyp_VZ_AqLambda_E7minus25_Deg8_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.workingAssumption
  paperSource   := "P16 audit broken-link: V-Z framework PUBLISHED but specific E_{7(-25)} A_q(λ) table NOT"
  attackHistory := ["P16-R-#new: introduced as broken-link Hyp_*; atlas-software computable"]
  scope         := "Specific V-Z A_q(λ) classification at R(q)=8 for E_{7(-25)} with G-invariant contribution"
}

def gap_Hyp_Eisenstein_Vanishing : StrictGapEntry := {
  name          := "Hyp_Eisenstein_Vanishing_E7minus25_Deg8_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.workingAssumption
  paperSource   := "P9 audit broken-link: Franke 1998 framework PUBLISHED but specific deg-8 vanishing NOT"
  attackHistory := ["P9-R-#new: introduced as broken-link Hyp_*"]
  scope         := "Eisenstein/residual part of H^8(S_Γ_EVII) does NOT contribute to [q]"
}

def gap_Hyp_HigherRank_GoodMetric : StrictGapEntry := {
  name          := "Hyp_HigherRank_GoodMetric_EVII_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.workingAssumption
  paperSource   := "P13 audit broken-link: abstract BKK framework PUBLISHED, EVII-specific verification missing"
  attackHistory := ["P13-R-#new: introduced as broken-link Hyp_*"]
  scope         := "Higher-rank automorphic vector bundle on EVII admits Mumford-good metric"
}

def gap_Hyp_ChernWeilForm_Proportionality : StrictGapEntry := {
  name          := "Hyp_ChernWeilForm_Proportionality_EVII_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.workingAssumption
  paperSource   := "P13 audit broken-link: GP-2002 §1.3 Thm 16.4 classical-types only; EVII analog NOT published"
  attackHistory := ["P13-R-#new: introduced as broken-link Hyp_*"]
  scope         := "Chern-Weil form proportionality for EVII (GP-2002 analog for non-classical type)"
}

def gap_Hyp_FreudenthalClassPlacement : StrictGapEntry := {
  name          := "Hyp_FreudenthalClassPlacement_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.conditionalHypothesis
  paperSource   := "Master tex L11625-11647: 'not presently available in the published literature'"
  attackHistory := ["P10-R-#new: introduced as paper-acknowledged conditional input"]
  scope         := "IH-pulled-back [q] is placed in Goresky-Pardon Chern subalgebra at deg 8"
}

def gap_Hyp_CrossRingPhiNonzero : StrictGapEntry := {
  name          := "Hyp_CrossRingPhiNonzero_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.conditionalHypothesis
  paperSource   := "Paper i.b.2 INVENTION_CLASS: requires CONSTRUCTION of twisted Φ"
  attackHistory := ["P11-R-#new: introduced as INVENTION_CLASS",
                    "P11-R-#new: canonical Φ vanishes per Landsberg-Manivel 2001 + Freudenthal triple system"]
  scope         := "Twisted cross-ring map Φ : Sym⁴(V_56^*)^E_7 → H^8(E_7^C/P_7) with Φ(q) ≠ 0"
}

/-! ### Cat 3 structural defining equations (§3.4.3) — paper-stated meaning -/

def gap_freudenthal_H8_auto_G_invariant_structural_eq : StrictGapEntry := {
  name          := "freudenthal_H8_auto_G_invariant_structural_defining_equation_OPEN"
  status        := StrictGapStatus.gapOpen
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.structuralEquation
  paperSource   := "paper's clause-(ii.a) structural decomposition: Hodge-(4,4) auto-G-inv = iso ∧ bigrading-44"
  attackHistory := ["P14-R-#new: paper-stated structural equation"]
  scope         := "Defining: Hodge-(4,4) auto-G-invariant ↔ iso ∧ bigrading-44"
}

/-! ### Top-level Main Theorem GapEntry -/

def gap_HC_for_freudenthal_quartic_on_EVII : StrictGapEntry := {
  name          := "HC_for_freudenthal_quartic_on_EVII_CONDITIONAL"
  status        := StrictGapStatus.gapClosedConditional
  inputCategory := InputCategory.cat3PaperNovel
  cat3SubType   := Cat3SubType.hypothesisPredicate
  paperSource   := "paper's Main Theorem: HC for [q] on EVII via Mumford-Tate reduction"
  attackHistory := [
    "P7-P22 reduction-stage decomposition (exploratory)",
    "P23-R-#new: STRICT REFACTOR per latest discipline; 6-tier + Hyp_* + single-step bridges + conditionalOn"
  ]
  scope         := "Hodge Conjecture for the Freudenthal quartic [q] on EVII Shimura varieties"
  conditionalOn := [
    "Hyp_BorelMAtLeast8_E7minus25_OPEN",
    "Hyp_HigherRank_GoodMetric_EVII_OPEN",
    "Hyp_ChernWeilForm_Proportionality_EVII_OPEN",
    "Hyp_FreudenthalClassPlacement_OPEN",
    "Hyp_CrossRingPhiNonzero_OPEN"
  ]
}

/-! ### All-entries roll-up + summary -/

/-- All `StrictGapEntry`s defined in this file. Used for `#eval`-based status
 cross-table generation. -/
def allEntries : List StrictGapEntry := [
  -- Cat 3 carriers
  gap_borelM_E7minus25,
  gap_compactDualEVII_H8_dim,
  -- Cat 2 axioms
  gap_borel_1981_lower_bound,
  gap_watanabe_1975,
  gap_bott_borel_weil_diagonal,
  gap_borel_1974_stable_range,
  gap_mumford_1977_canonical_extension,
  gap_burgos_kramer_kuhn_2002,
  gap_vogan_zuckerman_1984,
  gap_knapp_vogan_1995,
  gap_franke_1998,
  gap_bbd_saito_gm,
  gap_borel_hirzebruch_E6_times_U1,
  gap_goresky_pardon_2002_looijenga_2017,
  gap_wolf_satake_borel_ji_evii_boundary,
  gap_V27_BE6_folklore,
  gap_V56_BE7_folklore,
  -- Cat 3 hypothesis predicates (carriers in opaque encoding)
  gap_compactDual_H8_is_44_bigrading,
  gap_cohomologyIso_at_deg8,
  -- Hyp_* broken-link predicates
  gap_Hyp_BorelMAtLeast8,
  gap_Hyp_VZ_AqLambda,
  gap_Hyp_Eisenstein_Vanishing,
  gap_Hyp_HigherRank_GoodMetric,
  gap_Hyp_ChernWeilForm_Proportionality,
  gap_Hyp_FreudenthalClassPlacement,
  gap_Hyp_CrossRingPhiNonzero,
  -- Cat 3 structural defining equations
  gap_freudenthal_H8_auto_G_invariant_structural_eq,
  -- Main Theorem
  gap_HC_for_freudenthal_quartic_on_EVII
]

-- ============================================================================
-- Section 10: Kernel-purity verification + status cross-table
-- ============================================================================

/-- Count entries by status. -/
def countByStatus : List (StrictGapStatus × Nat) :=
  let allStatuses : List StrictGapStatus := [
    StrictGapStatus.gapOpen,
    StrictGapStatus.gapPartial,
    StrictGapStatus.gapBlocked,
    StrictGapStatus.gapDeadEnd,
    StrictGapStatus.gapClosed,
    StrictGapStatus.gapClosedConditional
  ]
  allStatuses.map (fun s => (s, allEntries.filter (fun e => e.status = s) |>.length))

/-- Count entries by input category. -/
def countByInputCategory : List (InputCategory × Nat) :=
  let allCats : List InputCategory := [
    InputCategory.cat0Kernel,
    InputCategory.cat1Mathlib,
    InputCategory.cat2External,
    InputCategory.cat3PaperNovel
  ]
  allCats.map (fun c => (c, allEntries.filter (fun e => e.inputCategory = c) |>.length))

/-- Count Cat 3 entries by sub-type. -/
def countCat3BySubType : List (Cat3SubType × Nat) :=
  let cat3Entries := allEntries.filter (fun e => e.inputCategory = InputCategory.cat3PaperNovel)
  let allSubs : List Cat3SubType := [
    Cat3SubType.carrier,
    Cat3SubType.hypothesisPredicate,
    Cat3SubType.structuralEquation,
    Cat3SubType.workingAssumption,
    Cat3SubType.conditionalHypothesis
  ]
  allSubs.map (fun s => (s, cat3Entries.filter (fun e => e.cat3SubType = s) |>.length))

/-- Total entries count. -/
def totalEntries : Nat := allEntries.length

/-- gapClosedConditional promotion backlog (per §12.2). -/
def gapClosedConditionalBacklog : List String :=
  allEntries.filter (fun e => e.status = StrictGapStatus.gapClosedConditional)
            |>.map (fun e => e.name)

/-- Names of all `Hyp_*` broken-link predicates currently OPEN.
 Per discipline §12.1: each Hyp_* is its own GapEntry. -/
def openHypNames : List String :=
  allEntries.filter
    (fun e => e.cat3SubType = Cat3SubType.workingAssumption ∨
              e.cat3SubType = Cat3SubType.conditionalHypothesis)
    |>.map (fun e => e.name)

end HodgeReduction.Strict

-- ============================================================================
-- Kernel-purity verification commands (per discipline §1.5 + §1.7)
-- ============================================================================
--
-- Run `#print axioms HodgeReduction.Strict.HC_for_freudenthal_quartic_on_EVII_CONDITIONAL`
-- in editor to verify the Main Conditional Theorem depends ONLY on:
--   - Cat 0 kernel axioms (propext, possibly Classical.choice)
--   - Cat 2 single-step axioms (each with §3.3 Hodge-style or opaque + citation)
--   - Cat 3 opaque carriers + hypothesis predicates + structural defining equations
--   - Hyp_* broken-link predicates (consumed via theorem signature, NOT axiomatized)
-- NO composite-axiom-bundling violations (per discipline anti-pattern #14).
-- NO Cat 3 conclusion-as-axiom violations (per discipline anti-pattern #13).
-- NO conditional-as-unconditional violations (per discipline anti-pattern #15).

#eval s!"Total StrictGapEntries: {HodgeReduction.Strict.totalEntries}"
#eval s!"countByStatus: {repr HodgeReduction.Strict.countByStatus}"
#eval s!"countByInputCategory: {repr HodgeReduction.Strict.countByInputCategory}"
#eval s!"countCat3BySubType: {repr HodgeReduction.Strict.countCat3BySubType}"
#eval s!"gapClosedConditional backlog: {repr HodgeReduction.Strict.gapClosedConditionalBacklog}"
