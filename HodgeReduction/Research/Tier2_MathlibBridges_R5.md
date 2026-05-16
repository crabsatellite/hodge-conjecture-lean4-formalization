# Tier 2 Mathlib Bridges — R5-E reconnaissance

**Scope.** Read-only survey of `mathlib4` rev `a6276f4c` (lockfile `inputRev = v4.16.0`, 5705 `.lean` files) for prerequisites to PROVE — not axiomatise — the 5 Tier 2 classical theorems in our `HodgeReduction/Infrastructure/`. Method: grep + targeted file inspection of `AlgebraicGeometry/`, `Geometry/Manifold/`, `CategoryTheory/Sites/`, `Algebra/Homology/`, `RepresentationTheory/`, `Algebra/Lie/`, `Analysis/InnerProductSpace/`.

Headline: **Mathlib has essentially none of the geometric infrastructure** required for these 5 targets. The general-nonsense abelian/derived/sheaf scaffolding is in place, but every theorem-specific object — line bundles, Picard, Chern classes, differential forms on manifolds, Riemannian/Kähler metrics, harmonic forms, Chow groups, (g,K)-cohomology, arithmetic subgroups, symmetric spaces — is **absent**.

---

## §1 Per-target Mathlib readiness assessment

| # | Target | Readiness | Top-3 missing pieces | Minimal Mathlib PR estimate |
|---|--------|-----------|----------------------|-----------------------------|
| 1 | **Lefschetz (1,1)** | **2/10** | (a) line bundles / `Pic` of a scheme; (b) Chern class `c_1 : Pic → H²`; (c) Hodge decomposition (shared with T2) | ~10–15 kLOC over 6–18 months, plus T2 dependency |
| 2 | **Hodge decomposition (compact Kähler)** | **1/10** | (a) Riemannian metric typeclass on smooth manifolds; (b) differential forms on manifolds (Ω^k); (c) Hodge ⋆, Laplacian, harmonic forms, elliptic regularity | ~20–40 kLOC over 2–5 years (analysis-heavy) |
| 3 | **Cycle class map `cl : CH^p(X)_ℚ → H^{2p}(X;ℚ)`** | **2/10** | (a) Chow groups `CH^p`; (b) singular cohomology of schemes (Betti realisation); (c) cycle-class construction itself | ~15–25 kLOC, blocked on T2 for harmonic side or on étale cohomology |
| 4 | **Borel 1974 stable range** | **0.5/10** | (a) arithmetic subgroups Γ ⊂ G(ℚ); (b) `(g,K)`-cohomology; (c) Matsushima homomorphism + stable-range bounds | ~30–60 kLOC over many years; depends on full Lie/locally-symmetric stack |
| 5 | **Cartan 1929 compact dual iso** | **0.5/10** | (a) Hermitian symmetric pair `(g, K)`; (b) compact form `G_u`; (c) `(g,K)`-cohomology = same as T4 | ~25–50 kLOC; depends on T4 |

### Detailed findings (what IS / IS NOT in Mathlib)

**Present (general-nonsense scaffolding).**
- `AlgebraicGeometry/`: schemes, `StructureSheaf`, morphism stack (`Etale`, `Flat`, `Proper`, ...), `ProjectiveSpectrum`, `EllipticCurve/{Affine, Projective, Jacobian, Weierstrass}`. 
- `Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`: quasi-coherent sheaves as sheaves of modules (Riou 2024).
- `CategoryTheory/Sites/SheafCohomology/Basic.lean`: `Sheaf.H F n` defined as Ext from constant sheaf ℤ — the abstract sheaf-cohomology API exists but has no concrete computation for schemes.
- `Algebra/Homology/`: derived categories, Ext, homological complexes, total complex, all 5-lemma / snake / spectral-sequence scaffolding.
- `RepresentationTheory/GroupCohomology/{Basic, Hilbert90, LowDegree, Resolution}`: discrete-group cohomology only.
- `Geometry/Manifold/`: charted spaces, smooth structure, tangent bundles (`VectorBundle/{Basic, Hom, MDifferentiable, SmoothSection, Tangent}`), `WhitneyEmbedding`, `PartitionOfUnity`, `Complex.lean` (complex manifolds as charted spaces over ℂ), `MFDeriv`, `LieGroup`, `IntegralCurve`.
- `Analysis/Complex/UpperHalfPlane/{Basic, Manifold, ...}`: closest thing to a "locally symmetric space" — but only ℍ as a manifold, no `Γ \ ℍ` quotient and no action of `SL₂(ℤ)` as a locally-symmetric-space carrier.
- `LinearAlgebra/Matrix/{SpecialLinearGroup, GeneralLinearGroup, SymplecticGroup}`: matrix groups exist; arithmetic subgroups do not.
- `Algebra/Lie/`: full Lie-algebra theory (`CartanSubalgebra`, `Killing`, `Semisimple`, `RootSystem`, `Engel`) — purely algebraic, no smooth-manifold side, no `(g,K)`-cohomology.
- `Analysis/InnerProductSpace/Spectrum.lean`: finite-dim spectral theorem — short of the elliptic-operator spectral theorem needed for Hodge.
- `RingTheory/ClassGroup.lean`: ideal class group of a Dedekind domain (a 1-dim analogue of `Pic`, but no scheme-level `Pic`).

**Absent (every theorem-specific object).** No file in Mathlib matches: `Picard`, `LineBundle`, `Chern`, `Kahler`, `Kähler`, `Hodge`, `Chow`, `Dolbeault`, `dbar`, `derham`, `Riemannian` (as a typeclass on smooth manifolds), `harmonic` (form), `Laplacian` (Hodge), `connection` (Ehresmann/affine), `curvature`, `polarization` (Hodge/AV), `abelianvariety`, `arithmeticgroup`, `symmetricspace`, `LieCohomology`, `gK-cohomology`, `Matsushima`, `BorelHirzebruch`, `cycleclass`, `algebraiccycle`, `characteristicclass`. The Weierstrass file mentions `Picard` only in *comments* discussing the constraint "where R has trivial Picard group".

**The Riemannian gap is decisive.** Mathlib has `Geometry/Manifold/Complex.lean` (complex manifolds) but **no Riemannian metric typeclass** — meaning no `Δ`, no harmonic forms, no Hodge ⋆, no Kähler form. This single gap blocks Targets 2, 4, 5 entirely and prevents any concrete computation of `H^{p,q}`. There is a long-running community discussion (cf. Zulip `Geometry > Riemannian manifolds`); no merged file exists in `v4.16.0`.

---

## §2 Recommended Mathlib PR roadmap (highest readiness = Target 1)

**Why Target 1.** It is the most reduction-friendly: classical proof routes (exponential exact sequence + sheaf cohomology + Hodge decomp) all factor through generic homological scaffolding Mathlib already has. The hard analytic step (Hodge decomposition) can be **postponed** by taking the algebraic-Picard route for projective varieties (Pic = H¹(X, O_X*)).

**Proposed PR sequence** (5 PRs, ≈ 4–8 kLOC total; ordered by dependency).

### PR 1 — `Mathlib/AlgebraicGeometry/LineBundle.lean` (~600 LOC)

```lean
namespace AlgebraicGeometry
/-- A line bundle on a scheme `X` is an invertible sheaf of `𝒪_X`-modules:
    a locally free sheaf of rank 1. -/
structure LineBundle (X : Scheme) where
  sheaf : SheafOfModules (X.sheaf.toRingedSite)
  isInvertible : IsInvertible sheaf  -- locally iso to 𝒪_X
instance : CommGroup (LineBundle X / iso) where
  mul := tensorProduct
  inv := dualSheaf
end AlgebraicGeometry
```
Proof sketches: tensor product of invertible sheaves is invertible (locally, both are O_X); dual of invertible is invertible; associativity from category laws.

### PR 2 — `Mathlib/AlgebraicGeometry/PicardGroup.lean` (~400 LOC)
```lean
/-- The Picard group `Pic X` is isomorphism classes of line bundles under ⊗. -/
def Pic (X : Scheme) : Type _ := Quotient (LineBundle.isoSetoid X)
instance : CommGroup (Pic X) := /- inherited from LineBundle modulo iso -/
/-- Pic = H¹(X, 𝒪_X*) (algebraic form). -/
theorem Pic_iso_H1_units (X : Scheme) : Pic X ≃+ Sheaf.H (X.sheaf.units) 1 := ...
```
Proof sketch: line bundles → Čech 1-cocycles → cohomology class; standard isomorphism using existing `Sheaf.H` machinery + `CechNerve.lean`.

### PR 3 — `Mathlib/Topology/Sheaves/ExponentialSequence.lean` (~300 LOC)
```lean
/-- On a complex analytic space (or scheme over ℂ), 0 → 2πiℤ → 𝒪 → 𝒪* → 0 is exact. -/
theorem exponentialSequence_exact (X : ComplexAnalyticSpace) :
    ShortExact (Sheaf.const X (2 * π * I) ℤ) X.holomorphicSheaf X.holomorphicUnits := ...
```
**Blocker.** Mathlib has no `ComplexAnalyticSpace` typeclass; for the scheme case (`X` smooth projective over ℂ) one can work directly with the GAGA-compatible analytic sheaves once those exist. This PR is the most analytic-heavy.

### PR 4 — `Mathlib/AlgebraicGeometry/FirstChernClass.lean` (~250 LOC)
```lean
/-- The first Chern class is the connecting homomorphism of the exponential sequence:
    c₁ : Pic X = H¹(X, 𝒪*) → H²(X, ℤ). -/
def firstChernClass (X : ComplexAnalyticSpace) : Pic X →+ Sheaf.H (Sheaf.const X ℤ) 2 :=
  (LongExactSequence.δ exponentialSequence_exact 1).comp Pic_iso_H1_units.toAddMonoidHom
```

### PR 5 — `Mathlib/AlgebraicGeometry/NeronSeveri.lean` (~150 LOC)
```lean
def NeronSeveri (X : Scheme) : AddCommGroup := Pic X ⧸ AddSubgroup.kernel firstChernClass
```

### NOT in scope of the Mathlib PR

The Lefschetz (1,1) theorem itself ("every Hodge (1,1) class is in image of c₁") requires Hodge decomposition. That theorem stays in **our** project as `Lefschetz11Data.lefschetz_11` axiom (already present at `Cohomology/Lefschetz.lean:71`) until Target 2 lands in Mathlib. PR 1–5 alone replaces the **statement layer** of our typeclass with concrete-Mathlib instances; the algebraicity axiom remains a Cat-1 classical-theorem axiom (well-supported by PR-able partial chain).

---

## §3 Bridge proposal — instance per typeclass

For each of our HC `Infrastructure/Cohomology/` typeclasses, the minimal Mathlib delta that lets us replace the typeclass by a **concrete instance on a Mathlib scheme** (rather than an opaque axiom):

| HC typeclass | Mathlib needed for instance | Estimated Mathlib LOC | Verdict |
|--------------|-----------------------------|------------------------|---------|
| `PicardGroupData` (`Cohomology/PicardGroup.lean:53`) | PR 1 + PR 2 above | 1000 | **Tractable** — instance for smooth projective `X` over ℂ in 6–12 months |
| `Lefschetz11Data` (`Cohomology/Lefschetz.lean:61`) | PR 1–5 + Hodge decomp + harmonic-form theory | 1500 + 20k | **Years** — keep as Cat-1 axiom; only `H2` / `H11` carriers become concrete via PR 1–4 |
| `CycleRingData` (`Cohomology/CycleClassMap.lean:60`) | Chow groups (`CH^p`), needs `RingTheory/RationalEquivalence.lean` (new) ~2 kLOC + cycle-class map ~3 kLOC; cycle-class map itself depends on harmonic forms OR étale cohomology | 5k + 20k | **Years** for full cycle-class map; partial: `CH^p` ring structure is **tractable** (~3–6 months) |
| `ChernData` (`Cohomology/ChernClasses.lean:54`) | PR 4 (only c₁); higher Chern classes need either splitting principle (~1 kLOC) or Chern–Weil (needs connections — not in Mathlib) | 1000 + 2000 | **Tractable** for c₁; medium-hard for c₂...c_n via splitting principle |
| `HardLefschetzData` (`Cohomology/HardLefschetz.lean:73`) | Hodge decomp + Kähler identity `[L, Λ] = (n-k)·id` — fully analytic | 25k | **Years** |
| `DeRhamData` (`Cohomology/DeRham.lean:44`) | Differential forms on smooth manifolds (`Ω^k`) — not in Mathlib | 5k | **Medium-hard** (~12–18 months); pure differential geometry, no PDE |
| `CartanCompactDualIso` (`Shimura/CompactDual.lean:117`) | `(g,K)`-cohomology + symmetric spaces + Hermitian-symmetric structure | 15k | **Years** |
| `Matsushima*` (`Cohomology/Matsushima.lean`) | (g,K)-cohomology + arithmetic groups + Borel–Serre cpt | 25k | **Years** |

### Recommended R6+ posture

1. **Keep the typeclass architecture**. Even the maximally-optimistic Mathlib roadmap leaves Targets 2, 4, 5 multi-year. The typeclass layer is the right level of abstraction for "the classical input is well-defined and stated correctly even if we don't compile its proof".
2. **Concentrate any Mathlib contribution on PR 1 + PR 2** (line bundles + Pic). These are (a) low-risk (algebraic, no analysis), (b) high-value (unlock `PicardGroupData`, partial `ChernData`, half of Lefschetz (1,1)), and (c) likely to be welcomed by mathlib4 maintainers — there are active Zulip discussions and Riou's Quasicoherent.lean (2024) is the natural foundation to build on.
3. **Do not pursue Mathlib PRs for Targets 4–5** in this project. The (g,K)-cohomology stack alone is a multi-PhD-thesis project; pulling it into HC's critical path inverts the right priority.
4. **Watch list.** Monitor `mathlib4` for: any merge of `Geometry/Manifold/Riemannian.lean`; any merge in `AlgebraicGeometry/{Picard, LineBundle}`; any merge touching `Connections` or `Curvature`. Each unlocks downgrading 1+ axiom from Cat 3 to Cat 1.
5. **Honest framing for paper.** All 5 Tier 2 axioms remain Cat 1 (textbook classical theorems) regardless of Mathlib status. Mathlib's absence is a **formalisation-coverage gap**, not a **mathematical gap**. The R5 strategy of "carriers concrete + theorems axiomatic" is the only realistic path on a 12–24 month horizon; the Target-1 PR roadmap is a credible incremental win, not a path to KILL.

---

**Word count.** ~1480.

**Files inspected (read-only).** Mathlib v4.16.0 directories: `AlgebraicGeometry/`, `AlgebraicGeometry/{Morphisms, EllipticCurve, Sites, Modules, ProjectiveSpectrum}/`, `Algebra/Homology/`, `Algebra/Lie/{*, Semisimple/}`, `Algebra/Category/ModuleCat/Sheaf/`, `Analysis/Complex/UpperHalfPlane/`, `Analysis/InnerProductSpace/`, `CategoryTheory/{Abelian, Sites/SheafCohomology}/`, `Geometry/Manifold/{*, VectorBundle, Algebra, IsManifold}/`, `LinearAlgebra/{Matrix, RootSystem}/`, `RepresentationTheory/{*, GroupCohomology}/`, `RingTheory/ClassGroup.lean`. HC project: `Infrastructure/{Cohomology, HodgeStructure, Shimura, Automorphic}/`.
