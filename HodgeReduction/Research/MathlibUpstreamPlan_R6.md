# Mathlib Upstream Plan — R6-F

**Scope.** R5-E surveyed Mathlib v4.16.0 (Feb 2025). This R6-F update tracks 15 months of master (HEAD `53f8a93a` dated 2026-05-12) for our 5 planned PRs (LineBundle, Pic, ExpSeq, c₁, NS). Method: `git log` + tree diff in `.lake/packages/mathlib/`. Three concrete pieces of our roadmap have **already landed**.

---

## §1 Mathlib in-flight signals

**Major landings since R5-E (all on master, post-v4.16.0).**

| Landed | PR | Author | Impact on our roadmap |
|--------|-----|--------|----------------------|
| 2025-08-16 | `RingTheory/PicardGroup.lean` (#25337, 516 LOC) | Junyan Xu | **Subsumes our PR 2 at the ring level**: `CommRing.Pic R` defined as invertible `R`-modules mod iso; tensor monoid structure; refs Weibel + Stacks 0AFW. |
| 2026-01-11 | Pic ≃ ClassGroup for domains (#30736, +321 LOC) | Junyan Xu | Closes a TODO that would otherwise have appeared in our PR 2. |
| 2025-?? | `Geometry/Manifold/Riemannian/{Basic,PathELength}.lean` | Sébastien Gouëzel | **Closes the "Riemannian gap"** R5 called decisive. `IsRiemannianManifold` typeclass + emetric induced from metric. |
| 2025-?? | `VectorBundle/CovariantDerivative/{Basic,Torsion}.lean` + `Tensoriality.lean` + `LocalFrame.lean` + `Riemannian.lean` | Gouëzel / Rothgang | Connection / curvature on vector bundles now exist (R5 said "not in Mathlib"). |
| 2026-03-12 | `AlgebraicGeometry/Sites/ElladicCohomology.lean` (#36306) | Christian Merten | ℓ-adic cohomology on the pro-étale site — directly relevant if we ever pivot Target 3 to étale realisation. |
| 2025/2026 | `RepresentationTheory/Homological/Group{Cohomology,Homology}/` full restructure | Amelia Livingston | Functoriality, Shapiro, LongExactSequence, Hilbert90 — way past R5's snapshot. |
| 2025/2026 | `CategoryTheory/Sites/SheafCohomology/` + Mayer-Vietoris LES (#35070) + Čech (#35026) | Riou + others | Pushes the sheaf-cohomology backend forward; relevant for our PR 4. |
| 2025/2026 | `LinearAlgebra/ExteriorPower/Basis` + `ExteriorAlgebra/Basis` | various | Basis-level API now exists — relevant for higher Chern via splitting principle. |

**Junyan Xu's `Pic R`** uses the *ring* not the *scheme* as carrier. The Stacks tag is the same (0AFW) but the construction is via `Module.Invertible R M`, not via invertible sheaves on `Spec R`. Xu explicitly flags as TODO: *"Connect to invertible sheaves on `Spec R`. More generally, connect projective `R`-modules of constant finite rank to locally free sheaves on `Spec R`. Exhibit isomorphism with sheaf cohomology `H¹(Spec R, 𝓞ˣ)`."* That TODO **is exactly our PR 1+2+(part of)4 boundary**.

**Still absent on master**: `LineBundle (X : Scheme)`, `Pic (X : Scheme)`, `firstChernClass`, `NeronSeveri`, exponential sequence, Chow groups, Hodge decomposition, Kähler manifolds, arithmetic subgroups, `(g,K)`-cohomology, Matsushima, Borel-Hirzebruch, symmetric spaces, Hermitian symmetric pairs. Grep confirms zero matches for `Hodge`, `Chow`, `Chern`, `Kähler`, `Dolbeault`, `Lefschetz` (outside `Borel*` measure-theoretic and `BorelCaratheodory`), `Shimura`, `Automorphic`, `Matsushima`.

**Realistic timeline.** Xu's contribution rate suggests `Pic Scheme` is a 6-12 month target if anyone takes it on. Hodge decomposition has no advocate; the Riemannian-manifolds win means it is *possible* now (was *impossible* in R5), but harmonic-form / elliptic-regularity / Hodge ⋆ is still many kLOC and probably 3-5 years.

---

## §2 Per-PR strategy (revised post-#25337)

| PR | Target path | Status | Effort | Collaborator | Dependencies |
|----|-------------|--------|--------|--------------|--------------|
| **PR 1 — LineBundle** | `Mathlib/AlgebraicGeometry/Modules/Invertible.lean` (~500 LOC) | NEW (recommend rename: "invertible sheaf"; line bundle is the same thing) | Medium; build on `Modules/Sheaf.lean` + `Sheaf/Quasicoherent.lean` | Junyan Xu (owns `PicardGroup.lean`) + Joël Riou (owns `Quasicoherent.lean`) | None blocking — both deps merged |
| **PR 2 — Pic Scheme** | `Mathlib/AlgebraicGeometry/PicardGroup.lean` (~400 LOC) | Refocus: **Pic_Scheme**, not Pic_Ring. Should provide `Pic (Spec R) ≃ CommRing.Pic R` connecting Xu's work. | Medium-Low (much of the algebra is in Xu's file) | Junyan Xu (he owns the TODO list explicitly mentioning this) | PR 1 |
| **PR 3 — ExpSeq** | `Mathlib/AlgebraicGeometry/AnalyticGeometry/ExponentialSequence.lean` OR `Mathlib/Geometry/Manifold/Complex/ExponentialSequence.lean` (~400 LOC) | Still blocked by **`ComplexAnalyticSpace` typeclass** — not in Mathlib. Workaround: state for complex manifolds (which now exist) rather than analytic spaces. | High; needs `OnHolomorphic` sheaf as continuous sections | Riou (sheaf side) + Gouëzel (manifold side) | New: `HolomorphicSheaf` predicate; not in master |
| **PR 4 — c₁** | `Mathlib/AlgebraicGeometry/FirstChernClass.lean` (~300 LOC) | Conditional on PR 3 (analytic c₁) OR pure-algebraic alternative via `H¹(X, 𝓞_X*) → H²(X, ℤ)` requiring sheaf cohomology of `ℤ` constant sheaf on the étale site | Medium; algebraic route has cleaner Mathlib analogue (ℓ-adic c₁) | Christian Merten (ℓ-adic) + Xu (Pic side) | PR 1 + PR 2 + (PR 3 OR étale c₁) |
| **PR 5 — NS** | `Mathlib/AlgebraicGeometry/NeronSeveri.lean` (~200 LOC) | Trivial after PR 4 lands | Low | Any AG reviewer | PR 4 |

**Total revised effort.** ~1.8 kLOC (down from R5's 4-8 kLOC) since PicardGroup at the ring level is done. **6-15 months** if Xu and Riou are receptive; longer otherwise. PR 3 alone could stretch this.

**Reviewer assignment honesty.** Andrew Yang (68 commits/year to `AlgebraicGeometry/`) and Christian Merten (58, also wrote ℓ-adic) are dominant AG reviewers. Michael Rothgang (84/year to `Manifold/`) dominates manifolds. None of them has signalled active Hodge interest in commit history.

---

## §3 Internal vs upstream tradeoff

**Keep internal indefinitely.** Hodge decomposition machinery, `(g,K)`-cohomology, Shimura datum, arithmetic subgroups, harmonic forms, Kähler identities — every "Years" entry in R5-E's Tier-2 table. Even with the Riemannian-manifolds win, the gap to Hodge `⋆`/harmonic theory is 2-5+ years of analytic library work.

**Upstream PR 1 + PR 2 now (R6 priority).** PR 1+2 are (a) explicitly invited by Xu's TODO list, (b) algebraic-only (low risk of analysis-induced delay), (c) load-bearing for our `PicardGroupData` typeclass — a successful upstream lets us delete one typeclass entirely and depend on `CommRing.Pic R` ≃ `Pic_Scheme(Spec R)`. **Cost ~2-3 weeks; payoff: one Cat-3 axiom downgraded to Mathlib-derived.**

**Upstream PR 3-5 only after PR 1-2 land.** Don't queue them; reviewer fatigue is real and the exponential sequence requires a typeclass we'd need to negotiate (ComplexAnalyticSpace vs ComplexManifold).

**Bridge instances (lighter-weight than full upstream).** For each `Infrastructure/Cohomology/` typeclass, write a *concrete instance on a Mathlib scheme* that ties our typeclass to Xu's `Pic` or to existing sheaf-cohomology — these are pure local proofs that don't require any Mathlib PR but visibly demonstrate that our axiomatisation is consistent with the merged code. Recommended adds:

- `PicardGroupData (X : Scheme.{0}) := { pic := X.Pic, ... }` referencing a yet-to-define `Scheme.Pic`. Internal stub `def Scheme.Pic (X : Scheme) : CommGroup := ...` plus an `instance picardGroupData_of_affine (R) : PicardGroupData (Spec R)` factoring through Xu's `CommRing.Pic R`. **This is doable today inside our project** without any Mathlib PR.
- `RiemannianGap` instance reduction: now that `IsRiemannianManifold I M` exists on master, the **statement layer** of `HardLefschetzData` can be reformulated against `IsRiemannianManifold` rather than against opaque carriers. *Theorem proofs* still axiomatic (Hodge `⋆` not in Mathlib), but the *type signatures* become Mathlib-flavoured.
- `(g,K)-cohomology` stays fully internal; the absence is structural.

**Cross-internal-paper benefit.** When `IsRiemannianManifold` is available, our project gets it "for free" via Mathlib bump; reframing `HardLefschetzData` against it makes the Reviewer-2 narrative ("axioms are mainstream Mathlib-shaped facts") strictly stronger, even though no Hodge proof is closed.

---

## Honest framing for paper / Reviewer 2

R5's bottom line still holds: **all 5 Tier 2 axioms remain Cat 1 (textbook classical theorems) regardless of Mathlib status**. What changed materially since R5: (a) Pic at ring level is *done*, eliminating one full axiom-target after our bridge PR; (b) Riemannian manifolds *exist*, eliminating R5's "decisive gap" framing — but harmonic-form theory still missing means Targets 2/4/5 stay multi-year; (c) ℓ-adic cohomology *exists* on the pro-étale site — opens an alternative path to a Betti-style realisation that didn't exist in R5.

**Word count: 985.**
