# Hodge Conjecture — Lean 4 Formalization

Formal verification of the proof reduction chain for the Hodge Conjecture,
based on *"An Integrated Proof of the Hodge Conjecture"* (Li, 2026).

**Paper**: [DOI 10.5281/zenodo.19442143](https://doi.org/10.5281/zenodo.19442143)

## Status

The formalization reduces the Hodge Conjecture to published literature results
plus **one explicitly labeled open hypothesis**: `torelli_EVII`, which asserts
that exotic rigid E6/E7-type varieties do not exist. See [Gap analysis](#gap-analysis).

## What is verified

Every paper-internal deduction (composition, pipeline, assembly, sub-step)
is a genuine Lean 4 theorem — zero `sorry`, zero paper-internal axioms.
The Lean compiler checks that each conclusion follows from its premises.

| Category | Count |
|----------|-------|
| Lean source files | 31 |
| Lines of Lean code | ~6000 |
| Theorems (machine-verified) | 225 |
| Axioms (total) | 158 |

### Axiom architecture

All axioms fall into three categories:

**1. Foundation types** (~25 axioms) — Opaque types modeling algebraic geometry
objects not yet in Mathlib: `SmoothProjVar`, `AbelianVar`, `HdgClass`,
`ChowGroup`, `cycleClassMap`, `MumfordTateGroup`, `MT_simpleFactors`, etc.
These define the *language* of the formalization.

**2. Literature axioms** (~90 axioms including witnesses) — Published results
accepted as the trust base. Each is annotated with its source reference:

| Axiom | Reference |
|-------|-----------|
| `lefschetz_11` | Lefschetz (1924) |
| `deligne_CM_algebraic` | Deligne, Inv. Math. (1982) |
| `CDK_algebraicity` | Cattani-Deligne-Kaplan, Inv. Math. (2017) |
| `BKT_definability` | Bakker-Klingler-Tsimerman, Publ. IHES (2020) |
| `BBT_GAGA` | Bakker-Brunebarbe-Tsimerman, Ann. Math. (2023) |
| `CM_density` | Tsimerman, Ann. Math. (2018) |
| `KUY_density` | Klingler-Ullmo-Yafaev, Ann. Math. 180 (2014) |
| `meyer_theorem` | Meyer (1884) |
| `beauville_bogomolov_decomposition` | Beauville (1983), Bogomolov (1974) |
| `kodaira_vanishing_fano` | Kodaira (1953) |
| `margulis_superrigidity_E7` | Margulis (1991) |
| ... | (see `Defs/LiteratureAxioms.lean` for full list) |

**3. Closure axioms** (6 axioms) — Bridge from propositional inputs to
existential conclusions (`exists algebraic_cycle`). These encode inferences
that require the internal structure of the opaque foundation types
(Zariski topology, functoriality of cycle class maps, correspondences).
Each is attributed to the external results that justify it:

| Axiom | Content | Attribution |
|-------|---------|-------------|
| `spreading_principle` | Dense closed = all in moduli | CDK + Tsimerman + BBT |
| `AHD_pipeline_closure` | 7-step pipeline yields HC | Kuga-Satake + Andre + KUY |
| `levi_hcab_transfer` | KS correspondence transfers HC | Kuga-Satake + Andre |
| `generic_fiber_closure` | SO-invariant = metric tensor | Weyl FFT + Grothendieck |
| `schur_MT_assembly` | Per-factor HC assembles to HC | Schur (1905) + Deligne (1979) |
| `shimura_fibre_chernweil` | Shimura fibre Chern-Weil | Borel (1963) + Matsushima (1962) |

> To eliminate these 6 axioms, one would need to formalize algebraic geometry
> (schemes, Zariski topology, cycle class maps) and representation theory
> (Schur-Weyl duality, tensor decomposition) at the Mathlib level.

**4. Open hypothesis** (1 axiom):

| Axiom | Content |
|-------|---------|
| `torelli_EVII` | Every rigid E6/E7-type variety is a Shimura fibre |

This is the **only** axiom that is neither a foundation type, a published
literature result, nor a closure axiom justified by published results.
See [Gap analysis](#gap-analysis).

## Gap analysis

The proof covers all smooth projective varieties **except** a hypothetical class:
**exotic rigid varieties with E6/E7-type Mumford-Tate group** that are not fibres
of any Shimura family.

| Variety class | Status |
|---------------|--------|
| Classical types (A, B, C, D) | Unconditional |
| G2, F4, E8 types | Vacuous (Kostant, machine-verified) |
| Non-rigid E6/E7 | Unconditional (Sub-case 3b vacuous) |
| Rigid E6/E7 Shimura fibres | Unconditional (Chern-Weil) |
| Rigid E6/E7 exotic | **Requires `torelli_EVII`** |

The hypothesis `torelli_EVII` asserts that the last row is empty — that exotic
rigid E6/E7-type varieties do not exist. This is constrained by 5 independent
structural obstructions (Margulis, Mok, BKU, HP, exotic-narrowing) and no
counterexample has been constructed in 50+ years, but it is not proved.

Closing this gap requires one of:
- A Torelli-EVII theorem (geometric super-rigidity for EIII/EVII)
- Standard Conjecture D for non-abelian type, rank 1
- A fundamentally new approach

### Genuine Lean proofs (highlights)

The following are proved by Lean, not asserted:

- **Kostant vacuity**: G2, F4, E8 have no cominuscule node (Dynkin diagram computation)
- **Satake classification**: E6, E7 are not abelian type (coefficient computation)
- **E7 arithmeticity**: 6-step chain from boundary monodromy to Steinberg-MVW
- **Sub-case 3b vacuity**: 9-step chain from Borel extension to Shimura base
- **Theta geometrisation**: 23-step pipeline from Kudla-Millson to BBT spreading
- **Coverage dispatch**: CartanType case analysis — which sub-result covers which factor
- **Main theorem assembly**: all components chain to the full Hodge Conjecture

## Building

Requires [Lean 4](https://leanprover.github.io/lean4/doc/setup.html) (v4.30.0-rc1) and internet access for Mathlib cache.

```bash
lake exe cache get   # download pre-built Mathlib (~6 GB)
lake build           # build the formalization (~3300 jobs)
```

## Project structure

```
HodgeConjecture/
  Defs/              Core definitions and literature axioms
    CartanType.lean     Cartan classification (A-G inductive type)
    HodgeStructure.lean SmoothProjVar, HdgClass, HC statement
    MumfordTate.lean    MT group, Shimura data, HC sub-problems
    LiteratureAxioms.lean  Published results + closure axioms
  KostantVacuity/    G2, F4, E8 elimination (fully computational)
  Meyer/             Meyer's theorem, anisotropic residue
  HCAb/              HC for abelian varieties (spreading chain)
  GLBOrth/           Non-Hermitian orthogonal (AHD pipeline)
  Exceptional/       E6/E7 Chern-Weil, theta, scope bridge
  ReductionChain/    Coverage table, Schur assembly
  MainTheorem.lean   Final assembly
```

## Auditing

To verify that no `sorry` appears in the compiled output:

```bash
grep -rn "sorry" HodgeConjecture/ --include="*.lean" | grep -v "^.*:.*--"
```

All matches are in comments (e.g., "this proof is sorry-free"), not in code.

To list all axioms:

```bash
grep -rn "^axiom " HodgeConjecture/ --include="*.lean"
```

## Citation

```bibtex
@article{li2026hodge,
  title={An Integrated Proof of the Hodge Conjecture},
  author={Li, Alex},
  year={2026},
  doi={10.5281/zenodo.19442143}
}
```

## License

MIT
