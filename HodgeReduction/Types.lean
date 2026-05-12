/-
# Opaque types for the Mumford--Tate reduction of the Hodge Conjecture.

Mathlib's current state lacks sheaf cohomology of `Ω^p` on smooth projective
varieties, the cycle class map `cl: CH^p(X)_ℚ → H^{2p}(X,ℚ)`, Mumford--Tate
groups, the Deligne torus, period maps, and most of the machinery in use
here. We therefore introduce opaque type abbreviations for the geometric
objects the paper quantifies over; axioms and theorems in the other files
refer to these abstractions.

All declarations in this file are either
 * a bundled structure carrying genuine data (e.g. a scheme plus smoothness
 plus projectivity plus connectedness plus dimension), or
 * an opaque axiomatic type + functions, deferred to Mathlib once the
 corresponding definitions land there.

No bare `Prop` fields; no `def:= True` tricks; no free-RHS existentials.

## Module docstring on opaque predicates.
Many predicates below are `axiom...:... → Prop` declarations whose
content is fixed by the paper but cannot be independently constrained
within Lean at the present level of abstraction (no Mathlib support for
Lie theory, Hodge theory, Mumford--Tate / Deligne-torus machinery). They
are flagged here as "opaque placeholders" awaiting Mathlib support. They
fall into two groups:
 * Predicates carrying a data-bound semantic content (e.g. `hasSimpleFactor`,
 `IsTorus`): constrained by further axioms tying them to paper content.
 * Predicates whose semantic content is only pinned by the paper theorem
 that asserts them (e.g. `InKnownE7Scope`, `c1IsZero`): they are labels,
 not independently-verifiable propositions within this file's scope.
Every `axiom` carries a `paper source:` line in its docstring citing the
theorem/hypothesis/line where the predicate is introduced.

## Inhabitation scaffolding disclosure (`AbstractScheme`, `SmoothProjectiveVariety`).
The carriers `AbstractScheme: Type → Type` and the bundled structure
`SmoothProjectiveVariety k` are intentionally opaque and carry no
declared inhabitant for the generic field parameter `k`. This is honest
scaffolding: no primitive witness is fabricated for a scheme whose
underlying carrier is axiomatised. Inhabitation at the concrete base
`k = ℂ` (the only case used by the Main Theorem and the Cartan-branch
theorems) is provided transitively through the AMRT inhabitance chain:
`canonicalE7ShimuraTor: E7ShimuraTor` (declared in `OpenHypotheses.lean`
as an honest witness for the paper's AMRT-Baily--Borel toroidal
compactification `S_Γ^tor`) yields `canonicalE7ShimuraTor.underlying:
SmoothProjectiveVariety ℂ` via the `E7ShimuraTor.underlying` accessor.
Consequently the universal quantifiers `∀ (X: SmoothProjectiveVariety ℂ),...`
appearing in `thm_cy3_e7_nonexistence`, `thm_Meyer`, `thm_G2F4`,
`thm_E8_vacuous`, `E6_V27_vacuity`, `cor_E7_shimura_closed`,
`hyp_HC_CM_Ab`, `hyp_CM_correspondences`, `hyp_AH_CM_E7`,
`hyp_BBT_rigid_reach`, `hyp_nonrigid_family_bridge`, and
`main_reduction` are non-vacuous relative to the paper's mathematical
world. The reduction-chain statements are meaningful conditional on
the Mathlib port delivering actual inhabitants for the `AbstractScheme`
primitive (at which point each `axiom` above becomes a `def` backed by
a Mathlib-level construction; the statements and proof skeleton are
stable under that replacement).
-/

import Mathlib.Algebra.Field.Defs
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Int.Defs

namespace HodgeReduction

/-! ## 1. Ambient scheme + smooth projective variety abstraction

Paper quantifies over "smooth projective variety $X$ over $\CC$" throughout.
We bundle the essential data: an underlying scheme, smoothness, projectivity,
connectedness, and explicit Krull dimension. Mathlib has
`AlgebraicGeometry.Scheme` but the conjunction of predicates (smooth +
projective + connected over a field) is not yet a ready-made structure.
-/

/-- Opaque carrier type for schemes over a field `k`. When Mathlib's
 `AlgebraicGeometry.Scheme` becomes usable in the required shape, this
 can be replaced by a definition. -/
axiom AbstractScheme: Type → Type

/-- Smoothness predicate on abstract schemes. -/
axiom AbstractScheme.IsSmooth {k: Type}: AbstractScheme k → Prop

/-- Projectivity predicate on abstract schemes. -/
axiom AbstractScheme.IsProjective {k: Type}: AbstractScheme k → Prop

/-- Connectedness predicate. -/
axiom AbstractScheme.IsConnected {k: Type}: AbstractScheme k → Prop

/-- A smooth projective variety over a field `k`: a scheme carrying
 smoothness, projectivity, connectedness, and a fixed Krull dimension. -/
structure SmoothProjectiveVariety (k: Type) [Field k] where
 scheme: AbstractScheme k
 smooth: scheme.IsSmooth
 proj: scheme.IsProjective
 connected: scheme.IsConnected
 dim: ℕ

/-! ## 2. Hodge numbers and Mumford--Tate groups

The paper's Main Theorem and every Cartan-type branch argument reference
Hodge numbers `h^{p,q}` and the Mumford--Tate group of a rational Hodge
structure. Neither is in Mathlib. We introduce them axiomatically. -/

/-- Hodge number `h^{p,q}(X) = dim_ℂ H^q(X, Ω^p_X)`.
 paper source: conj:HC Hodge decomposition defining `h^{p,q}`. -/
axiom HodgeNumber: SmoothProjectiveVariety ℂ → ℕ → ℕ → ℕ

/-- Opaque type of Mumford--Tate groups (ℚ-algebraic subgroups of `GL(V)`
 up to ℚ-algebraic isomorphism).
 paper source: Scope paragraph, Main Theorem. -/
axiom MumfordTateGroupType: Type

/-- The Mumford--Tate group `MT(H^k(X,ℚ))` (primitive part).
 paper source: Scope paragraph (whole MT group). -/
axiom MumfordTateGroup: SmoothProjectiveVariety ℂ → ℕ → MumfordTateGroupType

/-- The derived Mumford--Tate group `MT^{der}`.
 paper source: hyp:HC-CM-Ab surrounding remarks + scope clause on
 `MT(H^3)^der` in the E7-type Cartan branch. Used only where paper
 explicitly writes `MT(H^3)^der`. -/
axiom MumfordTateGroupDerived:
 SmoothProjectiveVariety ℂ → ℕ → MumfordTateGroupType

/-- Predicate: a Mumford--Tate group is a `ℚ`-torus. Used to encode the
 CM-condition (hyp:HC-CM-Ab: "CM abelian variety = abelian
 variety whose Mumford--Tate group is a torus").
 paper source: hyp:HC-CM-Ab; Deligne--Milne 1982, LNM 900. -/
axiom IsTorus: MumfordTateGroupType → Prop

/-! ### 2.1. Distinguished real forms appearing in the Cartan-type branches. -/

/-- The real form `E_{7(-25)}` (maximal compact `E_6 × U(1)`), whose minuscule
 irrep `V(ω_7) = V_{56}` generates a weight-3 Hodge structure of type
 `(1,27,27,1)`. The Cartan-type branch HC/Exc of the paper centres on
 this form.
 paper source: rem:E7-realforms-clarification. -/
axiom E7_neg25: MumfordTateGroupType

/-- The real form `E_8`, appearing in `thm:E8_vacuous`.
 paper source: thm:E8_vacuous. -/
axiom E8_realForm: MumfordTateGroupType

/-- The real form `G_2`.
 paper source: thm:G2F4. -/
axiom G2_realForm: MumfordTateGroupType

/-- The real form `F_4`.
 paper source: thm:G2F4. -/
axiom F4_realForm: MumfordTateGroupType

/-- The real form `E_{6(-14)}` acting through `V_{27}`.
 paper source: subsec:E6_absorption + rem:E6-V27-vacuity. -/
axiom E6_neg14: MumfordTateGroupType

/-- Predicate: the semisimple part of a Mumford--Tate group contains the
 given real form as a simple factor. Used by `thm:G2F4` / `thm:E8_vacuous`
 to express vacuity.
 paper source: thm:G2F4, thm:E8_vacuous, rem:E6-V27-vacuity
 scope discussion. -/
axiom hasSimpleFactor: MumfordTateGroupType → MumfordTateGroupType → Prop

/-- Predicate: a Mumford--Tate group is of complex-Cartan type `E_6` (any
 real form). The Scope paragraph clause (i) excludes "no
 `E_6`-type simple factor", covering all real forms (split `E_{6(6)}`,
 quasi-split `E_{6(2)}`, and the non-Hermitian real forms that admit
 no Shimura datum, see rem:E7-realforms-clarification for
 the analogous `E_7` vacuity), not only the Hermitian `E_{6(-14)}`.
 paper source: Scope paragraph (any `E_6`-type factor);
 rem:E6-V27-vacuity (whole Mumford--Tate group scope). -/
axiom IsE6Type: MumfordTateGroupType → Prop

/-- Predicate: a Mumford--Tate group is of complex-Cartan type `E_7` (any
 real form). The Scope paragraph clause (i) excludes "no
 `E_7`-type simple factor", covering all real forms (split `E_{7(7)}`,
 quaternionic `E_{7(-5)}`, Hermitian `E_{7(-25)}`). Non-Hermitian real
 forms admit no Shimura datum (rem:E7-realforms-clarification) but still could in principle occur as MT-group
 simple factors of Hodge structures; scope clause (i) excludes them
 uniformly via the broader `E_7`-type predicate.
 paper source: Scope paragraph; rem:E7-realforms-clarification. -/
axiom IsE7Type: MumfordTateGroupType → Prop

/-- Witness axiom: the Hermitian real form `E_{6(-14)}` has complex Cartan
 type `E_6`.
 paper source: rem:E6-V27-vacuity (treats `E_{6(-14)}` acting
 through `V_{27}` as the representative `E_6`-type case). -/
axiom E6_neg14_isE6Type: IsE6Type E6_neg14

/-- Witness axiom: the Hermitian real form `E_{7(-25)}` has complex Cartan
 type `E_7`.
 paper source: rem:E7-realforms-clarification (`E_{7(-25)}`
 is the Hermitian real form of the complex `E_7`). -/
axiom E7_neg25_isE7Type: IsE7Type E7_neg25

/-- Predicate: the Mumford--Tate group has no `E_6`- or `E_7`-type simple
 factor (any real form). Used by the classical-Cartan-type branch of
 the Main Theorem (scope clause (i)). The paper's scope phrase
 "no `E_6`- or `E_7`-type simple factor" quantifies over
 the complex-Cartan type, so the exclusion covers every real form,
 not only the Hermitian witnesses `E_{6(-14)}` and `E_{7(-25)}`.
 paper source: Scope paragraph clause (i); rem:E7-realforms-clarification (non-Hermitian real forms admit no Shimura
 datum, discussed for parity with the `E_6` case in). -/
def NoE6E7Factor (G: MumfordTateGroupType): Prop:=
 (¬ ∃ H: MumfordTateGroupType, hasSimpleFactor G H ∧ IsE6Type H) ∧
 (¬ ∃ H: MumfordTateGroupType, hasSimpleFactor G H ∧ IsE7Type H)

/-! ## 3. Cycle class map and Hodge classes

The Hodge Conjecture concerns surjectivity of the cycle class map
`cl^p_X: CH^p(X)_ℚ → Hdg^{2p}(X, ℚ)`. We introduce opaque types for
the source and target, and an opaque map. The Main Theorem concludes
`Surjective (cycleClassMap X p)`.
-/

/-- `CH^p(X)_ℚ`, the Chow group of codimension-`p` cycles with rational
 coefficients.
 paper source: conj:HC. -/
axiom ChowGroupRat: SmoothProjectiveVariety ℂ → ℕ → Type

/-- `Hdg^{2p}(X, ℚ) = H^{2p}(X, ℚ) ∩ H^{p,p}(X)`, the ℚ-Hodge classes in
 codimension `p`.
 paper source: conj:HC. -/
axiom HodgeClasses: SmoothProjectiveVariety ℂ → ℕ → Type

/-- The cycle class map `cl^p_X: CH^p(X)_ℚ → Hdg^{2p}(X, ℚ)`.
 paper source: conj:HC. -/
axiom cycleClassMap:
 (X: SmoothProjectiveVariety ℂ) → (p: ℕ) →
 ChowGroupRat X p → HodgeClasses X p

/-- Surjectivity predicate for the cycle class map, stated directly on the
 opaque types (avoiding a dependence on `Mathlib`'s `Function.Surjective`
 for opaque carriers). This is the conclusion of HC in codimension `p`.
 paper source: conj:HC. -/
def CycleClassMapSurjective (X: SmoothProjectiveVariety ℂ) (p: ℕ): Prop:=
 ∀ α: HodgeClasses X p, ∃ Z: ChowGroupRat X p, cycleClassMap X p Z = α

/-- The Hodge Conjecture for a single variety: surjectivity of the cycle
 class map in every codimension.
 paper source: conj:HC. -/
def HodgeConjecture (X: SmoothProjectiveVariety ℂ): Prop:=
 ∀ p: ℕ, CycleClassMapSurjective X p

/-! ## 4. CM abelian varieties

Hypothesis 1 (`hyp:HC-CM-Ab`) restricts HC to CM abelian varieties. We
record the "is a CM abelian variety" predicate opaquely. -/

/-- Predicate: `X` is an abelian variety (smooth projective group variety).
 paper source: hyp:HC-CM-Ab. -/
axiom IsAbelianVariety: SmoothProjectiveVariety ℂ → Prop

/-- Predicate: `X` is a CM abelian variety (abelian variety whose every
 Mumford--Tate group `MT(H^k)` is a `ℚ`-torus). The torus condition is
 the classical definition of CM.
 paper source: hyp:HC-CM-Ab (CM = "MT is a `ℚ`-torus");
 Deligne--Milne 1982, LNM 900, §4 (CM Hodge structures). -/
def IsCMAbelianVariety (X: SmoothProjectiveVariety ℂ): Prop:=
 IsAbelianVariety X ∧ ∀ k: ℕ, IsTorus (MumfordTateGroup X k)

/-! ## 5. Product varieties

Hypothesis 2 (`hyp:CM-correspondences`) quantifies over products `Y × Z`
in codimension 3. We axiomatize the product construction on varieties to
avoid a free-RHS existential. -/

/-- Product of two smooth projective varieties over `ℂ`. Opaque: Mathlib
 does not yet have smooth projective variety products in the required
 shape.
 paper source: hyp:CM-correspondences ("H^6(Y×Z, ℚ)"). -/
axiom product: SmoothProjectiveVariety ℂ → SmoothProjectiveVariety ℂ →
 SmoothProjectiveVariety ℂ

/-! ## 6. Calabi--Yau threefolds

Theorem `thm:cy3-e7-nonexistence` states: no CY₃ has
`MT(H^3)^der = E_{7(-25)}`. We bundle the CY₃ predicate. -/

/-- Predicate: `c_1(X) = 0`. Mathlib has no Chern class machinery for
 abstract schemes; left abstract.
 paper source: definition of CY_3 in hyp:CM-correspondences +
 thm:cy3-e7-nonexistence (uses `c_1(X) = 0`). -/
axiom c1IsZero: SmoothProjectiveVariety ℂ → Prop

/-- `X` is a Calabi--Yau threefold iff `dim X = 3`, `c_1(X) = 0`, and the
 two auxiliary Hodge numbers vanish.
 paper source: conventional definition invoked throughout §4
 (thm:cy3-e7-nonexistence) and hyp:CM-correspondences. -/
def IsCalabiYauThreefold (X: SmoothProjectiveVariety ℂ): Prop:=
 X.dim = 3 ∧ c1IsZero X ∧ HodgeNumber X 1 0 = 0 ∧ HodgeNumber X 2 0 = 0

/-! ## 7. Kuga--Satake / Shimura data

Hypothesis `hyp:KS-p3` references the spin embedding `Spin(p,3) ↪ GL(Cliff^+)`.
We expose opaque types for the quadratic-form setting and the Kuga--Satake
conclusion. -/

/-- Opaque carrier for non-degenerate rational quadratic forms; tagged with
 signature `(p, q)`.
 paper source: thm:Meyer; Scope paragraph (orthogonal-type). -/
axiom RationalQuadraticForm: ℕ → ℕ → Type

/-- `QQ`-isotropy predicate on rational quadratic forms.
 paper source: thm:Meyer. -/
axiom RationalQuadraticForm.IsIsotropicQ:
 {p q: ℕ} → RationalQuadraticForm p q → Prop

/-- Indefiniteness (both `p ≥ 1` and `q ≥ 1`).
 paper source: thm:Meyer hypothesis. -/
def RationalQuadraticForm.IsIndefinite {p q: ℕ}
 (_: RationalQuadraticForm p q): Prop:=
 p ≥ 1 ∧ q ≥ 1

/-! ## 8. Scope predicate of the Main Theorem

The paper's Main Theorem proves HC on the scope union (i)-(iv),
paper:

 (i) every variety whose MT group has no E_6 / E_7 simple factor
 (scope paragraph quantifies over the whole Mumford--Tate group,
 not just `MT(H^3)^der`);
 (ii) every variety whose E_6-type factor contributes only trivial Hodge
 classes (weight-parity vacuity);
 (iii) every currently-known smooth projective variety with E_7 MT factor
 (Shimura-type rigid, rigid finite cover / birational models,
 non-rigid families with generically finite period map);
 (iv) exotic rigid non-Shimura E_7-type varieties whose Kodaira-dimension
 reduction terminates at a CY_3 factor (killed by
 `thm:cy3-e7-nonexistence`).

The residual dim >= 5, c1 != 0 exotic non-CY_3-reducible sub-branches are
explicitly OPEN in the paper.

We encode scope membership as a disjunction of four opaque sub-class
predicates. A Lean proof would discharge each `InScope` constructor via the
matching Cartan-type argument. -/

/-- Currently-known E7-type scope predicate (clause (iii) of the Main
 Theorem scope). Left abstract because the paper does not commit to an
 intrinsic characterisation of "currently-known"; it is a scope label,
 not a geometric property.
 paper source: Scope paragraph clause (iii). -/
axiom InKnownE7Scope: SmoothProjectiveVariety ℂ → Prop

/-- Predicate: `X`'s Kodaira-dimension reduction chain
 (Beauville--Bogomolov, Iitaka, MRC, Fano) terminates at a CY_3
 factor. The paper's Main-Theorem scope clause (iv)
 quantifies over "varieties whose Kodaira-dimension reduction
 terminates at a CY_3 factor", which is strictly broader than "`X`
 itself is a CY_3". The CY_3 non-existence theorem
 (thm:cy3-e7-nonexistence) then closes the whole clause via
 the reduction chain, not only the CY_3 case.
 paper source: Scope paragraph clause (iv). -/
axiom ExistsCY3Reduction: SmoothProjectiveVariety ℂ → Prop

/-- The Main Theorem's scope: (i) ∨ (ii) ∨ (iii) ∨ (iv), as in paper. Clause (i) quantifies over every weight `k` because the
 paper writes "MT group has no E_6- or E_7-type simple factor", not
 "`MT(H^3)^der` has no such factor"; for clauses (ii)-(iv) the E_6/E_7
 factor is read off the derived MT on H^3 (where the paper states it).
 Clause (ii) narrows the paper's generic "E_6-type simple factor" to the
 Hermitian real form `E_{6(-14)}` (axiom `E6_neg14`) because the paper's
 `rem:E6-V27-vacuity` argument is stated against the `V_{27}`
 representation, which corresponds to `E_{6(-14)}`; this narrowing is
 sound (strictly fewer varieties covered, no over-claim) but should be
 widened to the broader `IsE6Type` reading if a weight-parity vacuity
 argument beyond `V_{27}` is formalised.
 Clause (iv) uses `ExistsCY3Reduction` (the paper's reduction-chain
 condition), not `IsCalabiYauThreefold X` directly.
 paper source: Scope paragraph. -/
def InScope (X: SmoothProjectiveVariety ℂ): Prop:=
 -- (i) Classical Cartan types (whole MT group has no E_6 / E_7 factor).
 (∀ k: ℕ, NoE6E7Factor (MumfordTateGroup X k)) ∨
 -- (ii) E_6-type factor on `MT(H^3)^der` (weight-parity vacuity,
 -- rem:E6-V27-vacuity).
 hasSimpleFactor (MumfordTateGroupDerived X 3) E6_neg14 ∨
 -- (iii) Currently-known E_7-type on `MT(H^3)^der` (Shimura, finite
 -- covers, birational models, non-rigid families).
 (hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ∧ InKnownE7Scope X) ∨
 -- (iv) Kodaira-dim reduction terminates at a CY_3 factor on an
 -- E_7-type variety (killed by thm:cy3-e7-nonexistence via the
 -- reduction chain; paper).
 (hasSimpleFactor (MumfordTateGroupDerived X 3) E7_neg25 ∧
 ExistsCY3Reduction X)

end HodgeReduction
