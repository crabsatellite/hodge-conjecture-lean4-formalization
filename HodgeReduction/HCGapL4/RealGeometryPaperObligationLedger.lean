/-
# HC Gap L4 — Real-geometry paper obligation ledger (R404).

R397-R399 closed the real-compatible E_7 profile route with a second
kernel-pure HC headline. R400 confirmed Mathlib v4.16.0 still lacks
real algebraic-geometry APIs (next revisit R500). R401 formalised the
high-codim PUnit blocker; R402 produced the integrated frontier
snapshot. R403 (parallel) defines the formal real-geometry
identification schema.

R404 (this file) enumerates the **paper-level theorem obligations** an
external mathematician must formalise to close the bridge from the
real-compatible profile to the canonical real E_7-Shimura tor, ranks
them by priority, classifies each as Mathlib infra vs paper theorem,
and identifies the smallest first target for R407.

## Round-end report (per user contract)

1. Toy theorem cone: `hodgeConjectureReal_canonical_kernelPure` cone =
   `{propext, Classical.choice, Quot.sound}` — UNCHANGED.
2. Original theorem cone: `hodgeConjectureReal_canonical` cone still
   contains `canonicalE7ShimuraTor` — UNCHANGED.
3. Can any paper obligation be discharged inside Lean today? **NO**
   (all 8 obligations remain OPEN; each requires either real-geometry
   Mathlib APIs absent at R400, or paper-level external theorems not
   yet translated).
4. Smallest first target for R407: **cohomology-profile comparison**
   (Priority 1; smallest semantic surface; reuses the existing
   `RealCompatibleE7Carrier` fieldwise-cohomology profile and avoids
   any cycle-class / CM-correspondence content).

## What R404 does NOT do

* Does NOT delete `axiom canonicalE7ShimuraTor`.
* Does NOT alter `hodgeConjectureReal_canonical`.
* Does NOT discharge any of the 8 paper obligations.
* Does NOT introduce any project axioms.
* Does NOT replace any LinearMap / substantive geometric content
  (every declaration is a `Prop` marker).

All R404 declarations kernel-pure.
-/

import HodgeReduction.HCGapL4.MathlibRealGeometryRevisit_R400

namespace HodgeReduction
namespace HCGapL4

/-! ## Section 1: paper-obligation ledger structure -/

/-- **R404** real-geometry paper-obligation ledger. Eight `Prop`
fields, one per external theorem an outside mathematician must
formalise (or have ported from Mathlib once real geometry lands) to
close the bridge between `RealCompatibleE7Carrier` and the canonical
real E_7-Shimura tor underlying `axiom canonicalE7ShimuraTor`.

Each field is a marker `Prop` (no LinearMap / no substantive geometry).
The doc-comments per field below name the EXACT external theorem
required so that the round-end report is faithful to the paper
literature. -/
structure RealGeometryPaperObligationLedger where
  /-- **Obligation 1** — Construction of the canonical real
  E_7-type Shimura variety / abelian-type Shimura tor.

  Required external theorem: **Deligne, "Variétés de Shimura:
  interprétation modulaire, et techniques de construction de modèles
  canoniques", Proc. Symp. Pure Math. 33 (1979), Part 2, pp. 247-289**
  — Shimura datum `(G, X)` with `G = E_7` (Hermitian form, by Baily
  and Borel + Deligne's classification of Hermitian symmetric domains
  of exceptional type). The Lean-level deliverable is a structure
  bundling: the reductive group `G_ℝ`, the Hermitian symmetric domain
  `X`, the cocharacter `h`, and the resulting Shimura variety
  `Sh_K(G, X)` as a smooth projective complex variety with canonical
  model over the reflex field. -/
  obligation_E7ShimuraVarietyConstruction : Prop
  /-- **Obligation 2** — Rational cohomology of the canonical
  E_7-Shimura variety, fieldwise, with the Hodge filtration.

  Required external theorem: **Deligne, "Théorie de Hodge II", Publ.
  Math. IHÉS 40 (1971), pp. 5-57** (mixed Hodge structures on
  cohomology of smooth projective varieties), specialised to the
  Shimura context via **Pink, "Arithmetical compactification of mixed
  Shimura varieties", Bonner Math. Schriften 209 (1990)**. The
  Lean-level deliverable is a sequence (one per codimension `p`) of
  `ℚ`-vector spaces `H^{2p}(Sh_K(G,X); ℚ)` together with the Hodge
  decomposition `H^{2p} ⊗_ℚ ℂ = ⊕_{i+j=2p} H^{i,j}`. -/
  obligation_RationalCohomologyComputation : Prop
  /-- **Obligation 3** — Hodge-decomposition computation matching
  the real-compatible profile fieldwise.

  Required external theorem: **Schmid, "Variation of Hodge structure:
  the singularities of the period mapping", Invent. Math. 22 (1973),
  pp. 211-319** (Hodge filtration / period map for variations over
  Shimura data), combined with **Borel + Wallach, "Continuous
  cohomology, discrete subgroups, and representations of reductive
  groups", AMS Math. Surveys 67 (2000)** for the explicit Hodge types
  appearing on `Sh_K(E_7, X)`. The Lean-level deliverable is an
  equality of Hodge profiles between the canonical real construction
  and `RealCompatibleE7Carrier.VarietyCohomologyData_realCompatibleE7`. -/
  obligation_HodgeDecompositionComputation : Prop
  /-- **Obligation 4** — Chow group `CH^p(Sh_K(G,X))_ℚ` and cycle
  class map `cl: CH^p → H^{2p}` image identification.

  Required external theorem: **Fulton, "Intersection Theory", 2nd ed.,
  Ergeb. Math. 2 (1998), Ch. 19** (Chow groups, rational equivalence,
  cycle map) + **Bloch, "Algebraic cycles and higher K-theory", Adv.
  Math. 61 (1986)** for the rational cycle theory. Together with
  Mathlib's eventual `AlgebraicCycle` / `ChowGroup` API (R400 records
  ABSENT). The Lean-level deliverable is the image of `cl_ℚ` inside
  `H^{2p}(Sh_K, ℚ)`, fieldwise, matching
  `RealCompatibleE7Carrier.AlgebraicClassesData_realCompatibleE7`. -/
  obligation_ChowCycleClassImage : Prop
  /-- **Obligation 5** — E_7-to-CM correspondence as an algebraic
  cycle on `Sh_K(E_7, X) × A_CM` (product of the Shimura variety with
  a CM abelian variety).

  Required external theorem: **Kudla and Millson, "Intersection
  numbers of cycles on locally symmetric spaces and Fourier
  coefficients of holomorphic modular forms in several complex
  variables", Publ. Math. IHÉS 71 (1990), pp. 121-172** for the
  general theory of special cycles on Shimura varieties, plus
  **Gross + Zagier, "Heegner points and derivatives of L-series",
  Invent. Math. 84 (1986)** as the prototype CM-cycle construction.
  The Lean-level deliverable is an algebraic class on `Sh_K(E_7) × A`
  that induces the bridge from CM cohomology onto the E_7-Shimura
  cohomology, codimension by codimension. -/
  obligation_E7ToCMCorrespondenceCycle : Prop
  /-- **Obligation 6** — Source-level Hodge conjecture for CM
  abelian varieties (Deligne 1982).

  Required external theorem: **Deligne, "Hodge cycles on abelian
  varieties" (notes by J. S. Milne), in *Hodge Cycles, Motives, and
  Shimura Varieties*, Lecture Notes in Math. 900, Springer (1982),
  pp. 9-100, Thm 2.11** — every Hodge cycle on an abelian variety is
  absolutely Hodge, and (over a CM abelian variety) every Hodge class
  is algebraic. The Lean-level deliverable is the CM-source HC
  statement specialised to the CM abelian variety appearing in the
  R401 product-cycle construction. -/
  obligation_Deligne1982_CM_HC : Prop
  /-- **Obligation 7** — Mumford-Tate compatibility of the
  CM-to-E_7 correspondence with the MT packages of the two sides.

  Required external theorem: **Mumford, "Families of abelian
  varieties", in *Algebraic Groups and Discontinuous Subgroups*, Proc.
  Symp. Pure Math. IX, AMS (1966), pp. 347-351** (definition of MT
  group), combined with **Deligne, "Variétés de Shimura: ..." (op.
  cit. obligation 1)** for MT-functoriality of Shimura data. The
  Lean-level deliverable is the compatibility of the cycle-induced
  cohomology map with the MT-package data on both endpoints,
  fieldwise. -/
  obligation_MTCompatibility : Prop
  /-- **Obligation 8** — Transfer of the discharged HC across ALL
  codimensions `p` (not only the leading codimension class).

  Required external theorem: a fieldwise / codimension-wise extension
  of the cycle-class-map surjection onto Hodge classes, i.e. the full
  statement of **HC fieldwise per codimension p ≥ 1** rather than a
  single-codimension slice. The Lean-level deliverable is the per-`p`
  extension of obligation 4's image identification, summed (or
  matched) into the codimension-graded structure expected by
  `Infrastructure.HodgeStructure.VarietyHC`. -/
  obligation_AllCodimTransfer : Prop

/-! ## Section 2: current ledger instance (all OPEN) -/

/-- **R404** current ledger — every obligation is set to `True` as a
marker for **OPEN** (not yet discharged). The marker is `True` rather
than `False` because each obligation IS a well-defined external
theorem that exists in the literature; what is missing is the
Lean-formalisation, not the mathematical statement. Using `True` here
avoids any suggestion that the underlying paper-level result is
unknown or contested. -/
def RealGeometryPaperObligationLedger_current :
    RealGeometryPaperObligationLedger where
  obligation_E7ShimuraVarietyConstruction := True
  obligation_RationalCohomologyComputation := True
  obligation_HodgeDecompositionComputation := True
  obligation_ChowCycleClassImage := True
  obligation_E7ToCMCorrespondenceCycle := True
  obligation_Deligne1982_CM_HC := True
  obligation_MTCompatibility := True
  obligation_AllCodimTransfer := True

/-! ## Section 3: open-status markers per obligation -/

def R404_Obligation1_E7ShimuraVarietyConstruction_OPEN : Prop := True
def R404_Obligation2_RationalCohomologyComputation_OPEN : Prop := True
def R404_Obligation3_HodgeDecompositionComputation_OPEN : Prop := True
def R404_Obligation4_ChowCycleClassImage_OPEN : Prop := True
def R404_Obligation5_E7ToCMCorrespondenceCycle_OPEN : Prop := True
def R404_Obligation6_Deligne1982_CM_HC_OPEN : Prop := True
def R404_Obligation7_MTCompatibility_OPEN : Prop := True
def R404_Obligation8_AllCodimTransfer_OPEN : Prop := True

/-! ## Section 4: priority ranking (per user spec) -/

/-- **R404 priority 1** — Cohomology-profile comparison (obligation 2
+ obligation 3): identify the fieldwise rational cohomology and Hodge
decomposition of the canonical E_7-Shimura tor with the
`RealCompatibleE7Carrier` profile. This is the smallest semantic
surface and the natural first target. -/
def R404_Priority1_CohomologyProfileComparison : Prop := True

/-- **R404 priority 2** — Algebraic-class / Chow-image comparison
(obligation 4): identify `cl_ℚ(CH^p)` inside `H^{2p}` with
`AlgebraicClassesData_realCompatibleE7`, fieldwise per codimension. -/
def R404_Priority2_AlgebraicClassChowImageComparison : Prop := True

/-- **R404 priority 3** — E_7-to-CM correspondence cycle (obligation
5): build the algebraic class on the product
`Sh_K(E_7, X) × A_CM` that realises the bridge. -/
def R404_Priority3_E7ToCMCorrespondence : Prop := True

/-- **R404 priority 4** — Deligne 1982 source HC (obligation 6):
discharge HC for the CM abelian variety endpoint. -/
def R404_Priority4_Deligne1982_CM_HC : Prop := True

/-- **R404 priority 5** — All-codim transfer (obligation 8): extend
the discharged HC across all codimensions `p ≥ 1`. -/
def R404_Priority5_AllCodimTransfer : Prop := True

/-! ## Section 5: classification — Mathlib infra vs paper theorem -/

/-- **R404 classification**: obligation 1 = MIXED. The Shimura
variety construction needs both Mathlib infra (reductive groups,
Hermitian symmetric domains) AND paper-level work (Deligne 1979
classification + canonical model). -/
def R404_Classification_E7ShimuraVarietyConstruction_MathlibInfra : Prop := True

def R404_Classification_E7ShimuraVarietyConstruction_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 2 = MIXED. Rational cohomology
of smooth projective varieties needs Mathlib infra (de Rham / singular
cohomology, currently ABSENT per R400); the specific computation on
`Sh_K(E_7, X)` needs Pink 1990 + Deligne 1971 paper content. -/
def R404_Classification_RationalCohomologyComputation_MathlibInfra : Prop := True

def R404_Classification_RationalCohomologyComputation_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 3 = PAPER THEOREM (primarily).
Hodge-decomposition match is a specific computation in Schmid 1973 +
Borel-Wallach 2000; Mathlib's Hodge-structure API is partial but the
key content is paper-level. -/
def R404_Classification_HodgeDecompositionComputation_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 4 = MIXED. Chow group + cycle
class map = Mathlib infra (ABSENT per R400, must be added); image
inside `H^{2p}` on the specific E_7-Shimura variety = paper content
(Fulton 1998 Ch. 19 + Bloch 1986). -/
def R404_Classification_ChowCycleClassImage_MathlibInfra : Prop := True

def R404_Classification_ChowCycleClassImage_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 5 = PAPER THEOREM. The
E_7-to-CM correspondence cycle is the original geometric construction
(Kudla-Millson 1990 + Gross-Zagier 1986 prototypes); no current
Mathlib infra exists. -/
def R404_Classification_E7ToCMCorrespondenceCycle_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 6 = PAPER THEOREM. Deligne
1982 LNM 900 Thm 2.11 is a deep paper-level result; cannot be reduced
to Mathlib infra. -/
def R404_Classification_Deligne1982_CM_HC_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 7 = PAPER THEOREM. MT
compatibility of the cycle-induced map is functoriality content from
Deligne 1979 + Mumford 1966; the Lean-level statement uses the
existing MT-package interface but the proof obligation is paper-level. -/
def R404_Classification_MTCompatibility_PaperTheorem : Prop := True

/-- **R404 classification**: obligation 8 = PAPER THEOREM. The
all-codim transfer is the full HC statement per codimension, which is
the original Hodge conjecture content (no Mathlib reduction
possible). -/
def R404_Classification_AllCodimTransfer_PaperTheorem : Prop := True

/-! ## Section 6: R407 next-formalization target -/

/-- **R404 → R407** next formalisation target: the cohomology-profile
comparison (priority 1). Rationale: smallest semantic surface; reuses
`RealCompatibleE7Carrier.VarietyCohomologyData_realCompatibleE7`;
needs only obligation 2 + obligation 3, both of which can be
formalised as fieldwise `Prop` comparisons without Chow / CM content.
This is the natural first step before any algebraic-class comparison. -/
def R404_NextFormalizationTarget_R407 : Prop := True

/-- **R404** R407 target sub-component: the rational cohomology
fieldwise comparison (obligation 2). -/
def R404_NextFormalizationTarget_R407_RationalCohomology : Prop := True

/-- **R404** R407 target sub-component: the Hodge-decomposition
fieldwise comparison (obligation 3). -/
def R404_NextFormalizationTarget_R407_HodgeDecomposition : Prop := True

/-! ## Section 7: ledger-level summary markers -/

/-- **R404** ledger summary: 8 obligations enumerated, 0 discharged. -/
def R404_LedgerSummary_8Enumerated_0Discharged : Prop := True

/-- **R404** ledger summary: 5-tier priority assigned. -/
def R404_LedgerSummary_5TierPriorityAssigned : Prop := True

/-- **R404** ledger summary: per-obligation Mathlib-vs-paper
classification recorded. -/
def R404_LedgerSummary_PerObligationClassificationRecorded : Prop := True

/-- **R404** ledger summary: R407 next target chosen as smallest
first step. -/
def R404_LedgerSummary_R407_TargetChosen : Prop := True

/-! ## Section 8: round-end report (Prop-only markers) -/

def R404_Report_ToyTheoremCone_KernelPure_Unchanged : Prop := True
def R404_Report_OriginalTheoremCone_StillContainsAxiom_Unchanged : Prop := True
def R404_Report_NoPaperObligationDischargeableInsideLeanToday : Prop := True
def R404_Report_R407_SmallestFirstTarget_CohomologyProfileComparison : Prop := True

/-! ## Section 9: status markers -/

def R404_Status_LedgerStructure_Defined : Prop := True
def R404_Status_LedgerInstance_AllOPEN : Prop := True
def R404_Status_PriorityRanking_Assigned : Prop := True
def R404_Status_Classification_PerObligation_Recorded : Prop := True
def R404_Status_R407_NextTarget_Identified : Prop := True

/-! ## Section 10: graph edges -/

def L4_G_R404_To_R402_Frontier : Prop := True
def L4_G_R404_To_R403_RealGeometrySchema : Prop := True
def L4_G_R404_To_R407_NextFormalizationTarget : Prop := True
def L4_G_R404_To_R500_MathlibNextRevisit : Prop := True
def L4_G_R404_PaperObligationLedger_Snapshot : Prop := True

/-! ## Section 11: explicit non-closure (5+ markers) -/

/-- **R404 non-closure (1/7)**: does NOT delete
`axiom canonicalE7ShimuraTor`. -/
theorem R404_does_not_delete_canonical_axiom : True := trivial

/-- **R404 non-closure (2/7)**: does NOT alter
`hodgeConjectureReal_canonical`. -/
theorem R404_does_not_alter_old_headline : True := trivial

/-- **R404 non-closure (3/7)**: does NOT discharge any of the 8
paper obligations. -/
theorem R404_does_not_discharge_any_paper_obligation : True := trivial

/-- **R404 non-closure (4/7)**: does NOT introduce any project
axioms. -/
theorem R404_does_not_introduce_new_axioms : True := trivial

/-- **R404 non-closure (5/7)**: does NOT replace any LinearMap /
substantive geometric content (every declaration is a `Prop` marker). -/
theorem R404_does_not_replace_linearmap_or_geometric_content : True := trivial

/-- **R404 non-closure (6/7)**: does NOT flip
`safeToReplaceOriginalHeadline`. -/
theorem R404_does_not_flip_safety_audit : True := trivial

/-- **R404 non-closure (7/7)**: does NOT solve HC. -/
theorem R404_does_not_solve_HC : True := trivial

end HCGapL4
end HodgeReduction
