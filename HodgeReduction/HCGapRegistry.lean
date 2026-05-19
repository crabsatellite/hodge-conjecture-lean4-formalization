/-
# HC Gap Registry (R201) — machine-readable gap declarations.

Every declaration in this file is a `Prop` / `Type` naming a single
load-bearing residual gap in the `hodgeConjectureReal_canonical` proof
cone. None of them are proved; none are axiomatised. They are pure
statements that future rounds may close.

**Invariant** (re-verify after every round):
```
#print axioms HodgeReduction.hodgeConjectureReal_canonical
  →  [propext, Classical.choice, HodgeReduction.canonicalE7ShimuraTor, Quot.sound]
```

The 4 entries here cover every Lean-level dependency the headline proof
unfolds from `canonicalE7ShimuraTor`. The concrete EVII chain
(`HC_for_Concrete_EVII`) is **explicitly excluded** from this registry
per the R201 mandate (toy `Polynomial ℚ` carrier ≠ real HC closure).

See [Research/HC_GapRegistry.md](Research/HC_GapRegistry.md) for the
full layer-classified discussion.
-/

import HodgeReduction.Types
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.VarietyCohomology
import HodgeReduction.OpenHypotheses

namespace HodgeReduction
namespace HCGapRegistry

open HodgeReduction.Infrastructure.HodgeStructure

/-! ## Layer 1 — object existence / true E₇ Shimura variety -/

/-- **L1-G1**: existence of a true `E₇₍₋₂₅₎`-type Shimura toroidal
compactification `S_Γ^tor`, as a `SmoothProjectiveVariety ℂ`. Currently
inhabited only by `canonicalE7ShimuraTor.underlying` via the
project-axiom `canonicalE7ShimuraTor : E7ShimuraTor`.

**Math source**: AMRT 1975 *Smooth Compactifications of Locally Symmetric
Varieties* + Baily–Borel 1966 *Compactification of arithmetic quotients
of bounded symmetric domains*; specifically for `D = E₇₍₋₂₅₎ / (E₆·U(1))`
with `Γ ⊂ E₇₍₋₂₅₎(ℚ)` neat.

**Required Mathlib infra**: arithmetic groups, Hermitian symmetric
domains, toroidal compactifications. -/
abbrev L1_G1_E7ShimuraTor_Inhabited : Prop :=
  Nonempty E7ShimuraTor

/-! ## Layer 2 — cohomology / Hodge structure infrastructure -/

/-- **L2-G1**: existence of a `VarietyCohomologyData` instance from a
non-toy underlying variety. Currently inhabited only via
`canonicalE7ShimuraTor.cohomologyOfUnderlying`. The R201 minimum attack
(`HCGapL2.TrivialPoint`) closes the dim-0 trivial case, providing a
template that an eventual E₇ construction must follow.

**Math source**: singular cohomology + Hodge theory of complex
projective varieties (Hodge 1941 *Theory and Applications of Harmonic
Integrals*; Voisin *Hodge Theory and Complex Algebraic Geometry I*
ch. 6–7).

**Required Mathlib infra**: singular cohomology `H^k(X, ℚ)`; pure Hodge
decompositions via Dolbeault `H^k = ⨁ H^{p,q}`. -/
abbrev L2_G1_VarietyCohomologyData_Constructed_NonToy : Prop :=
  ∀ (X : SmoothProjectiveVariety ℂ),
    ∃ (coh : VarietyCohomologyData), True
    -- Marker only. The substantive content is that `coh.H k` equals the
    -- actual rational cohomology of `X` at degree `k`, with `coh.hodgeStructure k`
    -- the actual pure Hodge structure of weight `k` on `H^k(X, ℚ)`. The
    -- `True` placeholder records the Prop has not been refined to that
    -- equality (which itself requires a `cohomology`-functor in Mathlib).

/-- **L2-G2**: for the canonical E₇ case specifically, the existence
of a `VarietyCohomologyData` whose `H k` is the actual `H^k(S_Γ^tor, ℚ)`,
with Hodge structure identified via Matsushima / Borel–Wallach with
V_56 representation theory.

**Math source**: paper §4–§5 (Matsushima isomorphism + Borel–Wallach
relative Lie-algebra cohomology); Vogan–Zuckerman 1984. -/
abbrev L2_G2_E7CanonicalCohomology_MatchesPaper : Prop :=
  ∀ (S : E7ShimuraTor),
    -- The cohomology bundle `S.cohomologyOfUnderlying` is the
    -- identification of `H^*(S_Γ^tor, ℚ)` with V_56-representation
    -- cohomology at weight 3. Marker only; full refinement requires
    -- Mathlib singular cohomology + Matsushima isomorphism.
    True

/-! ## Layer 3 — E₇ representation / Mumford-Tate / Freudenthal -/

/-- **L3-G1**: the V_56 minuscule representation of E_{7(-25)} carries
a polarisable pure ℚ-Hodge structure of weight 3 with Hodge numbers
`(1, 27, 27, 1)`. ALREADY KERNEL-PURE: see `V56Instance.lean` —
`instPureHodgeStructure_V56 : PureHodgeStructure V_56 3`. Retained here
as a marker so the registry covers all layers; closure is `trivial`. -/
abbrev L3_G1_V56_PureHodgeStructure_W3_HodgeDiamond : Prop :=
  -- The kernel-pure infrastructure exists at
  -- `Infrastructure.HodgeStructure.V56Instance.instPureHodgeStructure_V56`.
  True

/-- **L3-G2**: connection between `V_56` (an abstract E_7 representation)
and `H^3(S_Γ^tor, ℚ)` for the canonical Shimura variety. Currently this
identification lives implicitly inside `canonicalE7ShimuraTor.mtCorrespondencePackage`'s
existential — the witness CM abelian variety `A_Γ` is constructed from
V_56 in the paper but the construction is bundled as the axiom.

**Math source**: paper §6 (V_56-induced MT correspondence); Deligne–Milne
1982 LNM 900 §4 for CM Hodge structure infrastructure. -/
abbrev L3_G2_V56_To_E7_Variety_Cohomology_Identification : Prop :=
  ∀ (S : E7ShimuraTor),
    -- The H^3 piece of `S.cohomologyOfUnderlying` is identified with
    -- V_56 as a Hodge structure of weight 3. Marker only.
    True

/-! ## Layer 4 — algebraic correspondence / CM / Hodge class algebraicity -/

/-- **L4-G1**: existence of an `AlgebraicClassesData` instance from a
non-toy underlying variety + cohomology bundle. Currently inhabited
only via `canonicalE7ShimuraTor.algClassesOfUnderlying`.

**Math source**: Chow groups + cycle class map `cl : CH^p(X)_ℚ →
H^{2p}(X, ℚ)` (Lefschetz 1924 / Hodge 1950 for the algebraic ⊆ Hodge
half).

**Required Mathlib infra**: Chow groups, intersection theory, cycle
class map. -/
abbrev L4_G1_AlgebraicClassesData_Constructed_NonToy : Prop :=
  ∀ (X : SmoothProjectiveVariety ℂ) (coh : VarietyCohomologyData),
    ∃ (alg : AlgebraicClassesData coh), True

/-- **L4-G2**: HC for CM abelian varieties (Deligne 1982). This is
the substantive HC content the `mtCorrespondencePackage` existential
witnesses: a CM abelian variety `A` with `VarietyHC A_coh A_alg`.

**Math source**: P. Deligne, *Hodge Cycles on Abelian Varieties*
(1982), in *Hodge Cycles, Motives, and Shimura Varieties*, LNM 900,
§§2–4. -/
abbrev L4_G2_HC_For_CM_AbelianVariety : Prop :=
  ∀ (A : SmoothProjectiveVariety ℂ),
    IsCMAbelianVariety A →
    ∀ (A_coh : VarietyCohomologyData) (A_alg : AlgebraicClassesData A_coh),
      VarietyHC A_coh A_alg

/-- **L4-G3**: per-codimension Mumford-Tate correspondence package
from the canonical CM abelian variety `A_Γ` to `S_Γ^tor` at every `p`.
This is the second substantive part of `mtCorrespondencePackage`.

**Math source**: paper §6 (V_56 induces an MT correspondence Γ between
S_Γ^tor and A_Γ); R177 `MTCorrespondencePackageAt` records the per-p
data (HodgeStructureMorphism + cycle map + commuting square + Hodge
class surjectivity). -/
abbrev L4_G3_MT_Correspondence_E7_To_CMAbelian : Prop :=
  ∀ (S : E7ShimuraTor),
    ∃ (A : SmoothProjectiveVariety ℂ)
      (A_coh : VarietyCohomologyData)
      (A_alg : AlgebraicClassesData A_coh),
      IsCMAbelianVariety A ∧
      ∀ (p : ℕ),
        MTCorrespondencePackageAt A_coh S.cohomologyOfUnderlying
          A_alg S.algClassesOfUnderlying p

/-! ## Composite gap: the union of L4-G2 + L4-G3 equals the
`mtCorrespondencePackage` field used by the headline proof.
Closing both kernel-purely is equivalent to discharging the field
without the axiom. -/

/-- The full `mtCorrespondencePackage` field, restated as a registry
entry. The headline proof currently obtains a witness via
`canonicalE7ShimuraTor.mtCorrespondencePackage`. -/
abbrev L34_FullPackage_For_E7Canonical : Prop :=
  ∀ (S : E7ShimuraTor),
    ∃ (A : SmoothProjectiveVariety ℂ)
      (A_coh : VarietyCohomologyData)
      (A_alg : AlgebraicClassesData A_coh),
      IsCMAbelianVariety A ∧
      VarietyHC A_coh A_alg ∧
      ∀ (p : ℕ),
        MTCorrespondencePackageAt A_coh S.cohomologyOfUnderlying
          A_alg S.algClassesOfUnderlying p

/-! ## Exclusion clause

The concrete EVII chain (`HodgeReduction.Concrete.HC_for_Concrete_EVII`)
has 0 project-specific axioms in its cone but uses the toy carrier
`A_EVII := Polynomial ℚ`. Per the R201 mandate this is **NOT**
counted as real HC closure. The registry above is the only ledger
that does count. -/

end HCGapRegistry
end HodgeReduction
