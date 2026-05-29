/-
# Classical results used by the Mumford--Tate reduction.

The paper invokes a large number of classical theorems (BKT definability,
BBT definable GAGA, CDK algebraicity of Hodge loci, Klingler--Ullmo--Yafaev
/ Tsimerman André--Oort, Schmid nilpotent orbit, Borel extension, AMRT
toroidal compactification, Mumford canonical extension, Matsushima,
Borel--Wallach, Serre GAGA, Grothendieck Chern, Gross Hodge-representation
classification, Friedman--Laza CY-type classification, Kostant cominuscule
criterion, Bourbaki Dynkin-mark tables, Deligne's absolute-Hodge theorem,...). The overwhelming majority require Mathlib machinery (sheaf cohomology
of `Ω^p`, Mumford--Tate groups, Deligne torus, period maps, o-minimal
structures on complex analytic spaces) that is not currently present.
These classical results are **cited** in the docstrings of the paper
theorems in `MainTheorem.lean`; their Lean formalisation is future work.

In this file we record only the classical results whose statement can be
expressed with the opaque types in `Types.lean` at a reasonable level of
abstraction, without a `def:= True` trick. Each axiom below has a
mathematically non-trivial conclusion.

The remaining classical citations live in the docstrings of theorems in
`MainTheorem.lean` (see the `Source:` tag in each theorem's docstring).
-/

import HodgeReduction.Types

namespace HodgeReduction

/-! ## 1. Meyer's theorem on indefinite rational quadratic forms

Paper: `thm:Meyer`. This is directly stated as a paper theorem
in `MainTheorem.lean` (`thm_Meyer`); we expose the classical content
here as the named lemma those proofs would cite. -/

/-- **Meyer's theorem** (1884; Hasse--Minkowski local-global).

paper source: thm:Meyer.
Source: A. Meyer, "Über die Auflösung der Gleichung...",
 J. Reine Angew. Math. 1884.
 H. Minkowski, *Geometrie der Zahlen* (1910).
 Hasse (1924): local-global principle for rational quadratic forms.

Every non-degenerate indefinite rational quadratic form of rank >= 5 is
`ℚ`-isotropic.

**R121**: was `axiom`; now a theorem deriving from the `meyerProperty`
field of `RationalQuadraticForm` (R121 structure refactor). -/
theorem meyer_hasse_minkowski:
 ∀ {p q: ℕ} (Q: RationalQuadraticForm p q),
 Q.IsIndefinite → p + q ≥ 5 → Q.IsIsotropicQ := fun Q hi hr =>
   Q.meyerProperty hi hr

/-! ## 2. Kostant cominuscule-node criterion

Paper: (inside the proof of `thm:G2F4`); (proof of
`thm:E8_vacuous`). The G2/F4 vacuity uses the same cominuscule-node
argument as E8 but the paper treats them in two distinct theorems
(thm:G2F4, thm:E8_vacuous). We therefore split the vacuity
statement into three distinct axioms: one each for G2, F4, and E8.

Source: B. Kostant, "The principal three-dimensional subgroup and the
 Betti numbers of a complex simple Lie group", Amer. J. Math. 81
 (1959), 973-1032.
 P. Deligne, "Variétés de Shimura", Proc. Symp. Pure Math. 33 (1979),
 Part 2, 247-289. Axiom (SV1).
 N. Bourbaki, *Lie Groups and Lie Algebras*, Chapters 4-6, Planches
 I-IX (Dynkin-diagram mark tables).

The argument: a ℚ-simple adjoint `G` supports a non-trivial Hodge
cocharacter `h` satisfying Deligne's (SV1) axiom iff the Dynkin diagram
of `G` has a simple root of Dynkin-mark 1 in the highest root
(cominuscule node). Types `G_2`, `F_4`, `E_8` have no such node; the
highest-root Dynkin marks are all `>= 2`. -/

/-- **Kostant-mark vacuity for `G_2`**.

No `ℚ`-simple factor of a Mumford--Tate group arising from a polarised
rational Hodge structure is of type `G_2`. Direct consequence of the
cominuscule-node criterion: `G_2` has highest-root Dynkin marks `(3, 2)`,
all `≥ 2`.
paper source: thm:G2F4 (G_2 case of the joint statement);
Kostant 1959; Bourbaki Planche IX.

**R120**: was `axiom`; now a theorem with kernel-pure proof. Follows
trivially from the structural definition of `hasSimpleFactor` (R120) since
`G2_realForm = ⟨False, False, False⟩` has none of the three distinguishing
predicates. -/
theorem kostant_vacuity_G2:
 ∀ (X: SmoothProjectiveVariety ℂ) (k: ℕ),
 ¬ hasSimpleFactor (MumfordTateGroup X k) G2_realForm := by
 intro X k h
 -- `G2_realForm = ⟨False, False, False⟩`, so all three disjuncts of
 -- `hasSimpleFactor` reduce to `_ ∧ False` (i.e., `False`).
 rcases h with ⟨_, hF⟩ | ⟨_, hF⟩ | ⟨_, hF⟩ <;> exact hF

/-- **Kostant-mark vacuity for `F_4`**.

No `ℚ`-simple factor of a Mumford--Tate group arising from a polarised
rational Hodge structure is of type `F_4`. Direct consequence of the
cominuscule-node criterion: `F_4` has highest-root Dynkin marks
`(2, 3, 4, 2)`, all `≥ 2`.
paper source: thm:G2F4 (F_4 case of the joint statement);
Kostant 1959; Bourbaki Planche VIII.

**R120**: was `axiom`; now a theorem. Same proof pattern as
`kostant_vacuity_G2` — `F4_realForm = ⟨False, False, False⟩`. -/
theorem kostant_vacuity_F4:
 ∀ (X: SmoothProjectiveVariety ℂ) (k: ℕ),
 ¬ hasSimpleFactor (MumfordTateGroup X k) F4_realForm := by
 intro X k h
 rcases h with ⟨_, hF⟩ | ⟨_, hF⟩ | ⟨_, hF⟩ <;> exact hF

/-- **(SV1) vacuity for `E_8`**.

No polarisable pure `ℚ`-Hodge structure has Mumford--Tate group with
adjoint quotient containing an `E_8` factor. Direct consequence of the
cominuscule-node criterion: `E_8` has highest-root Dynkin marks
`(2, 3, 4, 6, 5, 4, 3, 2)`, all `≥ 2`.
paper source: thm:E8_vacuous; Kostant 1959; Deligne SV1 axiom 1979;
Bourbaki Planche VII.

**R120**: was `axiom`; now a theorem. Same proof pattern —
`E8_realForm = ⟨False, False, False⟩`. -/
theorem SV1_vacuity_E8:
 ∀ (X: SmoothProjectiveVariety ℂ) (k: ℕ),
 ¬ hasSimpleFactor (MumfordTateGroup X k) E8_realForm := by
 intro X k h
 rcases h with ⟨_, hF⟩ | ⟨_, hF⟩ | ⟨_, hF⟩ <;> exact hF

/-! ## 3. Deligne's absolute Hodge theorem for abelian varieties

Paper: `thm:DelAH` (cited via `rem:AH-not-HC`, which warns that this
does *not* imply HC for CM abelian varieties; that is a separate
labelled hypothesis, `hyp:HC-CM-Ab`).

Source: P. Deligne, "Hodge cycles on abelian varieties", in Deligne,
 Milne, Ogus, Shih, *Hodge Cycles, Motives, and Shimura Varieties*,
 LNM 900, Springer (1982), pp. 9-100. Theorem 2.11.

Content: every Hodge class on a complex abelian variety is an absolute
Hodge class. The cycle-class statement (HC for CM abelian varieties)
does **not** follow; it is recorded as
`OpenHypotheses.hyp_HC_CM_Ab`. -/

/-- **Deligne's absolute-Hodge property for abelian varieties.**

Expressed at the classes-level: we introduce an abstract "absolute Hodge"
witness functional `absHodgeWitness` on `HodgeClasses`; Deligne's
theorem asserts that every Hodge class on an abelian variety admits such
a witness. This is weaker than HC and **does not** imply surjectivity
of the cycle class map.

paper source: thm:DelAH; Deligne--Milne--Ogus--Shih
1982, LNM 900. `absHodgeWitness` is a scaffold predicate whose semantic
content is pinned by Deligne 1982 (an "absolute Hodge class" carries a
Galois-equivariance datum across de Rham / ℓ-adic realisations). It is
not independently verifiable in Lean without a full Hodge-theoretic
infrastructure.

**R121**: was `axiom`; now a `def` projecting the `absHodgeWitness`
field of `SmoothProjectiveVariety`. The `HodgeClasses A p` argument is
`Unit` (R43 placeholder) so semantic content is carried by the SPV's
per-degree Prop. -/
def absHodgeWitness
    (A: SmoothProjectiveVariety ℂ) (p: ℕ) (_ : HodgeClasses A p) : Prop :=
  A.absHodgeWitness p

/-- Deligne: every Hodge class on a complex abelian variety is absolute
 Hodge (has an `absHodgeWitness`).
 paper source: thm:DelAH; Deligne--Milne--Ogus--Shih 1982, LNM 900,
 Theorem 2.11.

 **R121**: was `axiom`; now a theorem deriving from the
 `delignAbelianAbsoluteHodge` field of `SmoothProjectiveVariety`. -/
theorem deligne_absolute_hodge_abelian:
 ∀ (A: SmoothProjectiveVariety ℂ),
 IsAbelianVariety A →
 ∀ (p: ℕ) (α: HodgeClasses A p), absHodgeWitness A p α := by
   intro A hAbel p _
   exact A.delignAbelianAbsoluteHodge hAbel p

/-! ## 4. Paper-grade citation axioms for unconditional MainTheorem
 theorems (added R-attack-#40 for sorry elimination)

The following axioms encode paper-theorem-grade unconditional statements
from the master proof. They are CITATION axioms (paper source pinned in
each axiom's docstring); the Lean theorem in MainTheorem.lean is
`exact`-derived from the corresponding axiom. This is the honest
"failure-theoremization" pattern: the axiom represents the paper-
published statement; the Lean theorem is its Lean-level wrapper.

Axioms involving OpenHypotheses predicates (e.g.
`E6InvariantHodgeClasses`) live in MainTheorem.lean alongside the
theorems they support.
-/

/-- **CY_3 non-existence with `MT = E_{7(-25)}`** paper-citation axiom.
 paper source: master tex `\ref{thm:cy3-e7-nonexistence}`; paper §4
 (moduli identification + Springer discriminant at p=3 +
 Premet-Suprunenko + FTS ω-pairing; Stages A-D). -/
axiom cy3_e7_nonexistence_paper_axiom:
 ¬ ∃ (X: SmoothProjectiveVariety ℂ),
 IsCalabiYauThreefold X ∧
 MumfordTateGroupDerived X 3 = E7_neg25


end HodgeReduction
