# Mathlib Kernel-Only Hodge Conjecture — Strategic Roadmap

Last updated: 2026-05-17 (R20)

## North Star

A truly Mathlib-kernel-only Lean 4 proof of the Hodge Conjecture for
the Freudenthal quartic on the EVII Shimura variety. "Kernel-only"
means:

- Every theorem in the proof chain has `#print axioms` =
  `[propext, Classical.choice, Quot.sound]` (Mathlib's foundational
  kernel axioms only).
- ZERO project-local `axiom` declarations anywhere in the dependency
  tree.
- ZERO trick patterns (no bare-Prop typeclass fields, no `X = X`
  tautologies, no `True`-filled witnesses, no `opaque P : Prop +
  axiom : P` anti-pattern, no synthetic carriers passed off as real
  geometry).
- Substantive Submodule / LinearMap / AlgebraicGeometry.Scheme data
  for every typeclass instance.

## Current Status (R20, 2026-05-17)

Phase 1 (Strict abstract framework) — **COMPLETE**:
- `HodgeReduction.Strict.HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL`
  depends only on `[propext, Classical.choice, Quot.sound]`.
- `Strict.lean` has ZERO `axiom` declarations.
- Infrastructure tree has ZERO bare-Prop typeclass fields (R19
  elimination round).
- TrickAudit_R7 categories A=0 hard / B=0 soft (after R7-B + R19).

Phase 2 (Synthetic concrete instantiation) — **COMPLETE for the
abstract framework**:
- `HodgeReduction.Concrete.HC_for_Concrete_EVII` depends only on
  `[propext, Classical.choice, Quot.sound]`.
- Concrete carrier `A_EVII := Polynomial ℚ` with 8 substantive
  typeclass instances (CohomologyRing, KaehlerClass, Lefschetz11Data,
  HodgeCycleData, FreudenthalChernSubalgebraPlacementData, plus 3
  Pic-side instances on `EVII_Space`).
- The concrete `freudenthalClassData_EVII.q = -48 X^4` is proved
  algebraic via the substantive polynomial identity
  `-48 c_2^2 + 96 c_1 c_3 - 96 c_4 = -48` (P57 explicit form)
  discharged by `polynomial_identity_value` (kernel-decidable).

Phase 3 (Real geometric instance via Mathlib) — **NOT STARTED**
(requires Mathlib infrastructure that does not yet exist).

Phase 4 (Research-level verification of the geometric instance) —
**NOT STARTED** (depends on Phase 3).

## Why Phase 2 is not the end

`A_EVII = Polynomial ℚ` is NOT the rational cohomology ring of the
real EVII Shimura variety. It is a synthetic stand-in chosen so that:

- The grading matches (polynomial degree ≈ cohomological degree).
- Mathlib provides all the algebraic structure (CommRing, Algebra,
  Submodule.span, Algebra.adjoin).
- The Borel–Hirzebruch fact `h^4 ≠ 0` is realised by
  `Polynomial.X_ne_zero + pow_ne_zero` (integral domain
  non-degeneracy).

For a TRUE proof of HC on the actual EVII variety, the carrier `A`
must BE the rational cohomology ring `H^*(S_Γ^{tor}; ℚ)` of the real
toroidal compactification — which requires:

1. The variety `S_Γ^{tor}` as a Mathlib `Scheme` (or higher).
2. Sheaf cohomology computing `H^*(...; ℚ)` (Mathlib has Čech
   cohomology but lacks the integration with sheaves of `ℚ`-modules
   at the level we need).
3. The arithmetic group `Γ ⊂ E_{7(-25)}(ℚ)` acting on the symmetric
   space.
4. The real Lie group `E_{7(-25)}` and its maximal compact
   `K = E_6 × U(1)`.
5. The Borel–Hirzebruch identification `h = c_1(L)` for the canonical
   line bundle.
6. The Mumford 1977 canonical extension to the toroidal boundary.

Items 1–6 are all multi-month-to-multi-year Mathlib infrastructure.

## Decomposition into Mathlib-PR chunks

Each chunk is independently submittable. Estimates assume 1
contributor working full-time; parallelisable across contributors.
For each chunk we list (a) current local progress, (b) Mathlib
upstream gap, (c) estimated effort.

### Chunk M1: Foundational algebraic geometry

| Module | Local progress | Mathlib gap | Effort |
|---|---|---|---|
| `Mathlib.AlgebraicGeometry.LineBundle` | R6-A (335 LOC abstract framework via Setoid quotient + tensor + dual + iso) | No abstract LineBundle data class; Mathlib has `LineBundle` as `Module.IsLocallyFree.RankOne` but missing the higher-level API | 2–3 months |
| `Mathlib.AlgebraicGeometry.Picard` | R6-B (337 LOC `abbrev Pic := IsoClass + instance CommGroup`) | Mathlib has `Mathlib.AlgebraicGeometry.PicardGroup` (early-stage) but lacks `Pic⁰` separation and NS quotient | 2–3 months |
| `Mathlib.AlgebraicGeometry.ChowGroup` | R7-A (substantive after quarantine fix; abstract `ChowGroupData` typeclass + `intersect` bilinearity + fundamental class) | No Chow groups in Mathlib at all | 3–6 months |
| `Mathlib.AlgebraicGeometry.CycleClassMap` | R9-C (256 LOC `CycleClassImageData` with `algebraicHodge ≤ allHodge` substantive containment) | No cycle class map in Mathlib | 2–3 months |
| `Mathlib.AlgebraicGeometry.HodgeDecomposition` | R7-C (substantive after quarantine fix; bidegree pieces with Submodule data + Hodge symmetry) | No Hodge decomposition in Mathlib | 6–12 months |
| `Mathlib.AlgebraicGeometry.NeronSeveri` | R14-C (275 LOC `NeronSeveriData` with `Module.finrank ℚ NS = nsRank` + Lefschetz bound `nsRank ≤ b2`) | No NS group in Mathlib | 2–3 months |
| `Mathlib.AlgebraicGeometry.AmpleDivisor` | R13-C (264 LOC) | Mathlib has `Mathlib.AlgebraicGeometry.Morphisms.Ample` but lacks the cohomology-level ample-class framework | 2–3 months |

**M1 subtotal**: 19–33 months sequential (much less parallelised).

### Chunk M2: Sheaf cohomology + Hodge filtration

| Module | Local progress | Mathlib gap | Effort |
|---|---|---|---|
| Sheaf cohomology of `Ω^p` | (none — abstract carrier in R9-A SheafCohomology.lean 278 LOC) | Mathlib has `Mathlib.CategoryTheory.Sheaf.Cohomology` (very limited); lacks Dolbeault | 12–18 months |
| Hodge filtration `F^p` | R9-A DeRhamData (401 LOC) | No Hodge filtration in Mathlib | 6–9 months |
| Comparison theorem (Grothendieck–de Rham 1966) | R7-B.3 + R14-A (366 LOC ComparisonTheorem.lean with `GrothendieckDeRhamData` + `HodgeFiltrationCompatibility`) | No comparison theorem in Mathlib | 6–9 months |
| Hard Lefschetz | R15-C HardLefschetz (416 LOC `HardLefschetzIsoData` with `Function.Bijective` substantive) | No Hard Lefschetz in Mathlib | 12–18 months |
| Lefschetz hyperplane | R9-C LefschetzHyperplane (247 LOC with substantive `Function.Injective` middle restriction) | No Lefschetz hyperplane in Mathlib | 6–9 months |
| Polarised HS (Griffiths 1968 / Hodge-Riemann) | R8-D (363 LOC with substantive HR1 + HR2) | No polarised HS in Mathlib | 12–18 months |
| MHS (Deligne 1971/74) | R8-C MixedHodge (398 LOC) | No MHS in Mathlib | 18–24 months |

**M2 subtotal**: 72–105 months sequential.

### Chunk M3: Lie theory + symmetric spaces

| Module | Local progress | Mathlib gap | Effort |
|---|---|---|---|
| Reductive Lie groups | R11-B (259 LOC) | Mathlib has `Mathlib.Algebra.Lie.*` (general theory) but lacks reductive specialisation | 6–9 months |
| Root systems for exceptional types | R11-A LieAlgebra/Basic (389 LOC with bracket + Jacobi + Cartan subalgebra) | Mathlib has `Mathlib.LinearAlgebra.RootSystem` (WIP) but no E_6/E_7/E_8 explicit data | 9–12 months |
| Weyl group of E_7 | R14-D WE7 (315 LOC with concrete order/exponents via `decide`; substantive `WE7CoxeterPresentationData`) | Mathlib has Coxeter machinery but no E_7 explicit | 3–6 months |
| Cartan matrices E_6/E_7/E_8 | Local CartanMatrices.lean (147 LOC) | Mathlib has `Mathlib.LinearAlgebra.RootSystem.CartanMatrix` (WIP) | 3–6 months |
| Hermitian symmetric spaces | R13-B HermitianSymmetric (443 LOC with `inductive CartanType + isExceptional` + Kähler form substantive non-degeneracy) | No Hermitian symmetric in Mathlib | 12–18 months |

**M3 subtotal**: 33–51 months sequential.

### Chunk M4: Arithmetic groups + Shimura varieties

| Module | Local progress | Mathlib gap | Effort |
|---|---|---|---|
| Arithmetic groups (Borel–Serre) | R8-B ArithmeticGroup (348 LOC with Q-rank + `BorelSerreCompactificationData` + substantive `boundaryCodim_pos`) | No arithmetic groups in Mathlib | 12–18 months |
| Shimura datum (SV-axioms) | R14-B Shimura/Basic (340 LOC with substantive `ShimuraDatumData`: SV1 base point + SV2 involution + SV3 compact center) | No Shimura varieties in Mathlib | 18–24 months |
| Toroidal compactification (AMRT) | R15-A ToroidalCompactification (334 LOC with `FanData` + `CompactificationStrataData` substantive partition) | No AMRT in Mathlib | 12–18 months |
| Mumford canonical extension | R8 + R19 MumfordExtension (with substantive `hodge_subfilt` filtration + `L_block` Submodule data) | No Mumford extension in Mathlib | 12–18 months |
| Borel–Serre + Franke Eisenstein layer | R8-B + R8 + R19 FrankeEisensteinLayer (with substantive parabolic-codim shift) | No Eisenstein cohomology in Mathlib | 18–24 months |
| Automorphic forms / (g,K)-cohomology | R8-A GKCohomology (407 LOC with Borel-Wallach Ch.II axioms + Salamanca-Riba low-degree vanishing) | No (g,K)-cohomology in Mathlib | 18–24 months |
| Matsushima homomorphism / Borel 1974 | R8 + R15-D Matsushima (436 LOC with c(E_7)=8 substantive + Matsushima surjectivity) | No Matsushima in Mathlib | 9–12 months |

**M4 subtotal**: 99–138 months sequential.

### Chunk M5: V_56 representation + Freudenthal quartic specifics

| Module | Local progress | Mathlib gap | Effort |
|---|---|---|---|
| V_56 fundamental rep of E_7 | Local V56Basis.lean / V56Freudenthal.lean (135 + extensive LOC) | No exceptional reps in Mathlib | 6–9 months |
| Freudenthal triple system | Local J3OJordan.lean + J3OInnerProduct.lean | No Freudenthal/Jordan algebras in Mathlib | 6–12 months |
| Jordan algebra J_3(O) | Local JordanJ3OBasis.lean (150 LOC) | No Albert algebra in Mathlib | 9–12 months |
| Octonions | Local OctonionBasis.lean (112 LOC) | Mathlib has `Mathlib.Algebra.Quaternion` but no octonions | 3–6 months |
| Borel-Hirzebruch H*(Ě_VII) Poincaré polynomial | Local PoincarePolynomialEVII.lean | No Poincaré polynomials of homogeneous spaces in Mathlib | 6–9 months |
| Schläfli graph srg(27,10,1,5) | Local SchlafliGraph.lean (398 LOC with `card_eq_27` + regularity via `decide`) | Mathlib has SimpleGraph but no Schläfli explicit | 3–6 months |

**M5 subtotal**: 33–54 months.

### Grand total

- Sequential: ~256-381 months ≈ 21-32 years.
- Parallelisable to ~3-5 years with 5-8 contributors.
- This codebase already encodes the abstract framework (Phase 1+2 = 18000 LOC of substantive infrastructure across 66+ framework modules).

## Strategic priorities for the next 3 sessions

1. **Continue strict-Lean elimination of residual trick patterns**
   (no bare-Prop, no rfl-on-tautology, no opaque+axiom). Each round
   trims one micro-trick.
2. **Add Concrete/EVII.lean instances for the remaining R19-substantive
   typeclasses** (MumfordExtensionData, SchmidDeligneFiltrationExtension,
   TwistedPhiFiltData, Section16_2_E6_RepCompatData). This validates
   the (b)-tier on the synthetic carrier.
3. **Identify ONE Mathlib-ready chunk** from M1 above and prepare a
   `Mathlib4`-formatted PR. The most upstream-ready candidates:
   `LineBundle` (R6-A, already in good shape) or `AlgebraicCycle`
   (R9-B, formal interface is small).

## Strategic priorities for the next year

1. Land 3–5 Mathlib PRs from M1+M2 chunks.
2. Maintain `Concrete/EVII.lean` as the kernel-pure synthetic-carrier
   theorem of record while migrating typeclass dependencies onto
   Mathlib equivalents as upstream PRs land.
3. Build the Tier C "real geometric instance" prototype: a Lean type
   for a specific Hermitian symmetric domain (e.g., the unit ball in
   ℂ^n as the simplest case) with substantive Submodule data, as a
   pathfinder for the EVII instance.

## Strategic priorities for the multi-year horizon

1. Coordinate with Mathlib maintainers on the AlgebraicGeometry +
   Hodge theory + Lie theory roadmaps. (The Hodge theory effort
   intersects with several existing Mathlib WIP threads.)
2. Build the EVII Shimura variety as a Mathlib `Scheme` once
   prerequisites land.
3. Discharge each typeclass field on the real geometric instance with
   actual geometric proofs (the research-level work).

## Honest acknowledgements

- The current `A_EVII = Polynomial ℚ` instance proves a STATEMENT of
  HC on a synthetic carrier. It is kernel-pure but does NOT prove HC
  on the actual EVII Shimura variety.
- The remaining 30 named-citation entries in
  `gap_HC_Main.conditionalOn` are now ALL theorems (post-R3-R7-R17
  conversions); they document the published-citation chain.
- The 359 axioms in legacy `OpenHypotheses.lean` are
  exploratory-stage scaffolding and are NOT in the HC dependency
  chain. They can be deleted at the user's request, or maintained as
  historical record.

## Bibliography for Mathlib porting priorities

- Grothendieck, A. *On the de Rham cohomology of algebraic varieties*,
  Publ. IHES 29 (1966).
- Deligne, P. *Théorie de Hodge I-III*, Publ. IHES 40, 44 (1971-74).
- Schmid, W. *Variation of Hodge structure: the singularities of the
  period mapping*, Invent. Math. 22 (1973).
- Cattani, Kaplan, Schmid. *Degeneration of Hodge structures*, Ann.
  Math. 123 (1986).
- Mumford, D. *Hirzebruch's proportionality theorem in the non-compact
  case*, Invent. Math. 42 (1977).
- Borel, A. *Stable real cohomology of arithmetic groups*, Ann. Sci.
  ÉNS 7 (1974).
- Borel-Wallach. *Continuous Cohomology, Discrete Subgroups, and
  Representations of Reductive Groups*, Princeton 1980.
- Salamanca-Riba, S. *Duke Math. J.* 96 (1999) — low-degree vanishing
  for A_q(λ).
- Borel-Hirzebruch. *Characteristic classes and homogeneous spaces I-III*,
  Amer. J. Math. 80-82 (1958-60).
- Toda, H. *Manifolds-Tokyo 1973* (1975) — V_27 Chern generates BE_6.
- Kono-Mimura. *J. Pure Appl. Algebra 6* (1976) — V_56 Chern generates BE_7.
- Bourbaki. *Groupes et algèbres de Lie*, Chapitres IV-VIII (1968-75) —
  E_7 root data.
- Carter, R. *Simple Groups of Lie Type*, Wiley 1972 — parabolic
  dimensions for exceptional groups.
- Freudenthal, H. *Beziehungen der E_7 und E_8 zur Oktavenebene I* (1954)
  — V_56 + Freudenthal quartic.
