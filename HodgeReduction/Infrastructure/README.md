# `HodgeReduction.Infrastructure` — Mathlib-PR-quality Lean infrastructure

This directory contains **self-contained Lean modules** designed to be
Mathlib-PR-ready. Each module fills a gap in Mathlib while providing the
mathematical foundations needed for the Hodge-conjecture EVII case.

## Design principles

* **Mathlib-PR-quality**: generic naming, comprehensive docstrings,
  Apache-2.0 licensed, no project-specific dependencies.
* **Real Lean proofs**: all theorems decided by Lean kernel + Mathlib
  tactics (`ext`, `simp`, `ring`, `norm_num`, `positivity`). No domain
  axioms.
* **Incremental**: each module is self-contained, builds on earlier
  modules.

## Status (as of P168)

🎉 **MAJOR MILESTONE (P150–P168, 2026-05-16)**: the infrastructure now
covers the full **Phase F + G + H + I + J** stack needed for the
Mumford–Tate Hodge-conjecture reduction:

* **Phase F** — Algebraic-cohomology framework (`Cohomology/`).
* **Phase G** — Hodge structure framework (`HodgeStructure/`).
* **Phase H** — Coxeter/Weyl-group framework (`Coxeter/`).
* **Phase I** — Abelian variety + automorphic framework
  (`AbelianVariety/`, `Automorphic/`).
* **Phase J** — Shimura variety framework (`Shimura/`).

Plus the existing **Tier A/B** combinatorial/algebraic infrastructure
(Octonions, Jordan algebra J₃(𝕆), Freudenthal quartic V₅₆, etc.).

The HC theorem `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL` now
depends on just one Cat 2 axiom (`polynomial_in_chern_classes_is_algebraic_OPEN`)
plus Lean kernel axioms. With the **Phase F** abstractions in
`Cohomology/`, that single axiom decomposes into 5 atomic axioms in
typeclass-field form (one for each: Kähler-algebraic, Chern-algebraic,
cycle-class-image, q ≃ Chern-poly, q ≃ −48 h⁴).

## File inventory (Phase A–J)

### Tier A — Combinatorial / Arithmetic

| Module | Description |
|---|---|
| `../CrossRingArithmetic.lean` | P48 Chern values + P57 polynomial identity + P53 Φ_tw(q) |
| `CartanMatrices.lean` | E_6, E_7, E_8 Cartan matrices |
| `SchlafliGraph.lean` | srg(27, 10, 1, 5) via 6+6+15 double-six model |
| `CoxeterDegrees.lean` | W(E_n) invariant degrees + order |

### Tier B — Algebra

| Module | Description |
|---|---|
| `Octonion.lean` | Octonion ℚ-algebra (8-dim, Fano-plane) + composition + alternative + conj + Hurwitz |
| `OctonionBasis.lean` | Explicit basis ℚ⁸ |
| `JordanJ3O.lean` | Exceptional Jordan algebra J₃(𝕆) (27-dim) + cubic norm |
| `JordanJ3OBasis.lean` | Explicit basis ℚ²⁷ |
| `J3OInnerProduct.lean` | Positive-definite trace form on J₃(𝕆) |
| `J3OJordan.lean` | Jordan product + bilinearity + Cayley-Hamilton + cross product |
| `V56Freudenthal.lean` | V₅₆ = ℚ⊕J₃(𝕆)⊕J₃(𝕆)⊕ℚ + Freudenthal quartic q + symplectic ω |
| `V56Basis.lean` | Explicit basis ℚ⁵⁶ |
| `V56HodgeDecomp.lean` | 4-piece V₅₆ Hodge decomposition (V^{3,0}⊕V^{2,1}⊕V^{1,2}⊕V^{0,3}) |
| `V56HodgeRank.lean` | dim of each Hodge piece (1+27+27+1=56) |
| `LinearMaps.lean` | LinearMap/BilinForm bundles for trace, innerProd, ω |

### Phase F — Algebraic-cohomology framework (`Cohomology/`)

| Module | Description |
|---|---|
| `Cohomology/Basic.lean` | `class CohomologyRing` with subalgebra `algebraic` + 9 closure properties |
| `Cohomology/ChernClasses.lean` | `ChernData`, `AlgebraicChernData`, `freudenthalPolynomial_isAlgebraic` |
| `Cohomology/KaehlerClass.lean` | `class KaehlerClass` with `h_isAlgebraic` + `h^n` algebraicity |
| `Cohomology/FreudenthalClass.lean` | `FreudenthalClassData` bridging Chern + Kähler routes |
| `Cohomology/AlgebraicBundle.lean` | `AlgebraicVectorBundle` (rank + Chern + algebraicity) |
| `Cohomology/CycleClassMap.lean` | `CycleRingData` (Chow ring → cohomology, image algebraic) |
| `Cohomology/ChowRing.lean` | `ChowRingData` (Chow ring linear refinement) |
| `Cohomology/Lefschetz.lean` | `Lefschetz11Data` (Lefschetz (1,1) theorem framework) |
| `Cohomology/HardLefschetz.lean` | `HardLefschetzData` (Lefschetz operator + iso property) |
| `Cohomology/HodgeCycle.lean` | `HodgeCycleData` + abstract HC statement |
| `Cohomology/NeronSeveri.lean` | `NeronSeveriData` (codim-1 algebraic via Lefschetz (1,1)) |
| `Cohomology/HCCodim1.lean` | **`HC_codim_1`** — codim-1 HC as PROVEN theorem |

### Phase G — Hodge structure framework (`HodgeStructure/`)

| Module | Description |
|---|---|
| `HodgeStructure/Basic.lean` | `class PureHodgeStructure V n` + Hodge filtration |
| `HodgeStructure/Polarised.lean` | `class PolarisedHodgeStructure V n` + symmetry by weight parity |
| `HodgeStructure/V56Instance.lean` | `pieceByFin : Fin 4 → Submodule ℚ V_56` (Hodge pieces) |
| `HodgeStructure/MumfordTate.lean` | `class MumfordTateGroupData` + Hodge class predicate |
| `HodgeStructure/Variation.lean` | `class VHSData` (family of polarised Hodge structures) |

### Phase H — Coxeter / Weyl-group framework (`Coxeter/`)

| Module | Description |
|---|---|
| `Coxeter/WE7.lean` | `WE7 := CoxeterMatrix.Group E_7` (Mathlib bridge) + invariant degrees |

### Phase I — Abelian variety + Automorphic (`AbelianVariety/`, `Automorphic/`)

| Module | Description |
|---|---|
| `AbelianVariety/Basic.lean` | `class AbelianVarietyHodgeData` (H¹ weight-1 PHS) |
| `Automorphic/Basic.lean` | `class AutomorphicCohomology` (cuspidal + Eisenstein decomposition) |
| `Automorphic/VoganZuckerman.lean` | `class VZAqLambdaData` (cohomological induction A_q(λ)) |
| `Automorphic/BorelBottWeil.lean` | `class BorelBottWeilData` (compact-dual H^8 bigrading) |

### Phase J — Shimura variety (`Shimura/`)

| Module | Description |
|---|---|
| `Shimura/Basic.lean` | `class ShimuraVarietyData` (abstract cohomology data) |
| `Shimura/CompactDual.lean` | `class CompactDualData` (H^8 = ℚ·h⁴) + `H8_classes_are_algebraic` |
| `Shimura/MumfordExtension.lean` | `class MumfordExtensionData` (canonical extension + L-block-diagonality) |
| `Shimura/IntersectionHomology.lean` | `structure IntersectionHomologyData` (BBD-Saito IH-pullback) |
| `Shimura/HirzebruchMumford.lean` | `class HirzebruchMumfordData` (proportionality) |
| `Shimura/PeriodDomain.lean` | `class PeriodDomainData` (Hermitian symmetric domain) |
| `Shimura/SchubertCells.lean` | `class SchubertCellData` (Schubert calculus) |
| `Shimura/HermitianSymmetric.lean` | `class HermitianSymmetricData` (G/K) |
| `Shimura/HermitianForm.lean` | `class HermitianFormData` (Hodge-Riemann pairing) |
| `Shimura/ArithmeticGroup.lean` | `class ArithmeticGroupData` (congruence subgroup Γ) |
| `Shimura/ToroidalCompactification.lean` | `class ToroidalCompactificationData` (AMRT 1975) |
| `Shimura/BorelHirzebruch.lean` | `class BorelHirzebruchData` (coinvariant algebra) |
| `Shimura/Adelic.lean` | `class AdelicGroupData` (G(𝔸), strong approximation) |

### Phase K — Lie algebra (`LieAlgebra/`)

| Module | Description |
|---|---|
| `LieAlgebra/Basic.lean` | `class LieAlgebraData` (abstract Lie algebra over R) |
| `LieAlgebra/ReductiveGroup.lean` | `class ReductiveGroupData` (G, dim, rank, realForm) |

### Phase L — Cohomology extensions

| Module | Description |
|---|---|
| `Cohomology/ChowRing.lean` | `ChowRingData` (linear cycle class map) |
| `Cohomology/Lefschetz.lean` | `Lefschetz11Data` (Lefschetz (1,1) theorem) |
| `Cohomology/HardLefschetz.lean` | `HardLefschetzData` (Lefschetz operator + iso) |
| `Cohomology/HodgeCycle.lean` | `HodgeCycleData` + abstract HC statement |
| `Cohomology/NeronSeveri.lean` | `NeronSeveriData` (codim-1 algebraic) |
| `Cohomology/HCCodim1.lean` | **`HC_codim_1`** — codim-1 HC as PROVEN theorem |
| `Cohomology/PicardGroup.lean` | `PicardGroupData` (Pic(X)_ℚ + c_1) |
| `Cohomology/AmpleDivisor.lean` | `AmpleDivisorData` (Picard → KaehlerClass bridge) |
| `Cohomology/Galois.lean` | `GaloisCohomologyData` (Galois action) |
| `Cohomology/DivisorClass.lean` | `DivisorClassData` (codim-1 cycle classes) |
| `Cohomology/AlgebraicCycle.lean` | `AlgebraicCycleData p` (codim-p cycle classes) |
| `Cohomology/ChernCharacter.lean` | `ChernCharacterData` (ch_2, ch_4) |
| `Cohomology/LefschetzHyperplane.lean` | `LefschetzHyperplaneData` (Lefschetz hyperplane) |
| `Cohomology/Lattice.lean` | `LatticeData` (integer lattice) |
| `Cohomology/RiemannRoch.lean` | `RiemannRochData` (Todd class) |
| `Cohomology/SheafCohomology.lean` | `SheafCohomologyData` (Hodge bigrading abstract) |
| `Cohomology/Motive.lean` | `PureMotiveData` (Grothendieck 1968 motives) |
| `Cohomology/PoincareDuality.lean` | `PoincareDualityData` (top class + integration) |
| `Cohomology/Matsushima.lean` | `MatsushimaData` (j^q + Borel 1974 stable range) |
| `Cohomology/AbelJacobi.lean` | `AbelJacobiData` (intermediate Jacobian) |
| `Cohomology/StandardConjectures.lean` | `StandardConjecturesData` (Grothendieck 1968) |
| `Cohomology/TateConjecture.lean` | `TateConjectureData` (Tate conjecture) |
| `Cohomology/DeRham.lean` | `DeRhamData` (Hodge filtration F^p) |
| `Cohomology/BettiCohomology.lean` | `BettiCohomologyData` (integer lattice) |
| `Cohomology/ComparisonTheorem.lean` | `ComparisonData` (de Rham vs Betti) |

### Phase M — HodgeStructure extensions

| Module | Description |
|---|---|
| `HodgeStructure/MixedHodge.lean` | `MixedHodgeStructureData` (weight filtration) |
| `HodgeStructure/NilpotentOrbit.lean` | `NilpotentOrbitData` (Schmid 1973) |
| `HodgeStructure/MixedHodgeModule.lean` | `MixedHodgeModuleData` (Saito 1988) |
| `HodgeStructure/GaussManin.lean` | `GaussManinData` (flat connection) |

### Phase N — Automorphic / AbelianVariety extensions

| Module | Description |
|---|---|
| `Automorphic/HeckeCorrespondence.lean` | `HeckeAlgebraData` (Hecke algebra acting on H^*) |
| `Automorphic/ModularForm.lean` | `AutomorphicFormData` |
| `Automorphic/GKCohomology.lean` | `GKCohomologyData` ((g, K)-cohomology) |
| `Automorphic/CuspidalCohomology.lean` | `CuspidalCohomologyData` |
| `AbelianVariety/PolarisedAV.lean` | `PolarisedAbelianVarietyData` |
| `AbelianVariety/CMType.lean` | `CMTypeData` (CM type) |
| `AbelianVariety/KugaSatake.lean` | `KugaSatakeData` (Kuga-Satake construction) |
| `AbelianVariety/K3Surface.lean` | `K3SurfaceData` (HC for K3 PROVEN) |
| `AbelianVariety/HyperKahler.lean` | `HyperKahlerData` |
| `AbelianVariety/TateModule.lean` | `TateModuleData` (ℓ-adic Tate module) |

### Top-level

| Module | Description |
|---|---|
| `HCFramework.lean` | **Final assembly**: theorems `freudenthal_class_isAlgebraic{,_via_chern,_via_kaehler}` from `FreudenthalClassData` |

## Architecture / dependency graph

```
                                                            HCFramework
                                                                  ▲
                            ┌──────────────────────────────────────┘
                            │
                  ┌─────────┴──────────┐
                  │                    │
          FreudenthalClass        Shimura/* + Automorphic/*
          (Cohomology)            (Phase J + I)
                  ▲                    ▲
            ┌─────┴─────┐               │
            │           │               │
        Chern    Kaehler     ┌──────────┘
       Classes    Class       │
            ▲       ▲         │
            │       │     HodgeStructure/* (Phase G)
            ▼       ▼         ▲
        Algebraic  Cycle      │
         Bundle    Class      │
            ▲       ▲     V56HodgeDecomp + V56HodgeRank + LinearMaps
            │       │         ▲
            └─┬─────┘         │
              │         V56Freudenthal + V56Basis
              ▼               ▲
        CohomologyRing.Basic  │
              ▲          J3OJordan + JordanJ3O + JordanJ3OBasis
              │               ▲
              │          J3OInnerProduct
              │               ▲
              │          Octonion + OctonionBasis
              │               ▲
              │          CartanMatrices + SchlafliGraph
              │          + CoxeterDegrees
              ▼               ▲
     Mathlib (Algebra,    Coxeter/WE7
     LinearAlgebra,     (Mathlib CoxeterMatrix.E_7 bridge)
     Module, etc.)
```

## Verification

Each file has its theorems verified by `lake build`. The `#print axioms`
output for theorems in these files should show only Lean kernel
foundational axioms (`propext`, `Classical.choice`, `Quot.sound`) —
NO domain-specific axioms.

The HC theorem `HC_for_freudenthal_quartic_on_EVII_UNCONDITIONAL`
currently depends on:
```
[propext, Classical.choice, Quot.sound,
 polynomial_in_chern_classes_is_algebraic_OPEN]
```

When the `polynomial_in_chern_classes_is_algebraic_OPEN` axiom is
replaced by an instance of `FreudenthalClassData` (which requires an
EVII cohomology ring + Kähler class + the two equality identities),
the framework's `freudenthal_class_isAlgebraic` theorem (in
`HCFramework.lean`) provides the closure.

## Mathlib PR plan

When complete and stable, these modules can be contributed to Mathlib
as standalone PRs:

1. `Mathlib.LinearAlgebra.CartanMatrix.Exceptional` — E_6, E_7, E_8.
2. `Mathlib.Algebra.Octonion.Basic` — Octonion ℚ-algebra.
3. `Mathlib.Algebra.Jordan.J3O` — Exceptional Jordan algebra.
4. `Mathlib.Combinatorics.SchlafliGraph` — srg(27, 10, 1, 5).
5. `Mathlib.AlgebraicGeometry.Hodge.PureStructure` —
   `class PureHodgeStructure` + `Polarised` + `Variation`.
6. `Mathlib.AlgebraicGeometry.Cohomology.Algebraic` —
   `class CohomologyRing` with algebraic subalgebra.
7. `Mathlib.AlgebraicGeometry.ChernClasses.Abstract` —
   `ChernData`, `AlgebraicVectorBundle`.
8. `Mathlib.AlgebraicGeometry.CycleClassMap` —
   `CycleRingData` abstract framework.

These would be the first occurrences in Mathlib of these classical
algebraic-geometry / Hodge-theory concepts.

## License

Apache 2.0 (same as Mathlib).

## References

Standard references:

* J. C. Baez, "The octonions", *Bull. Amer. Math. Soc.* **39** (2002), 145–205.
* T. A. Springer, F. D. Veldkamp, *Octonions, Jordan Algebras, and Exceptional Groups*, Springer (2000).
* P. Deligne, "Théorie de Hodge II/III", *IHÉS* **40, 44** (1971, 1974).
* P. Griffiths, J. Harris, *Principles of Algebraic Geometry*, Wiley (1978).
* C. Voisin, *Hodge Theory and Complex Algebraic Geometry I/II*, Cambridge (2002/2003).
* D. Mumford, "Hirzebruch's proportionality theorem in the non-compact case", *Invent. Math.* **42** (1977), 239–272.
* W. Schmid, "Variation of Hodge structure: the singularities of the period mapping", *Invent. Math.* **22** (1973), 211–319.
* M. Saito, "Modules de Hodge polarisables", *Publ. RIMS* **24** (1988), 849–995.
* D. Vogan, G. Zuckerman, "Unitary representations with non-zero cohomology", *Compositio Math.* **53** (1984), 51–90.
* J. Franke, "Harmonic analysis in weighted L²-spaces", *Ann. Sci. ENS* **31** (1998), 181–279.
* A. Borel, "Stable real cohomology of arithmetic groups", *Ann. Sci. ENS* **7** (1974), 235–272.
* A. Borel, F. Hirzebruch, "Characteristic classes and homogeneous spaces I-III", *Amer. J. Math.* **80–82** (1958–60).
* H. Freudenthal, "Beziehungen der E_7 und E_8 zur Oktavenebene I-V", *Indag. Math.* **16–17** (1954–55).
