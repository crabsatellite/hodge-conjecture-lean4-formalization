# R515-R520 Progress Report

## Summary

6 rounds of axiom decomposition and kernel-pure infrastructure work:

| Round | What | Result |
|-------|------|--------|
| R515 | Decompose hyp_HC_CM_Ab_real | -> deligne_1982_abs_hodge_cm + abs_hodge_implies_algebraic |
| R516 | Reduce hc_real_e6_case | -> e6_factor_classical_transfer (bridge) |
| R517 | Decompose mt_correspondence | -> e7_cm_witness_exists + e7_correspondence_package_exists |
| R518 | Classical Cartan gap card | Explicit closure boundary |
| R519 | Decompose cy3_e7_nonexistence | -> springer_discriminant + v56_j3o + j3o_not_geometric |
| R520 | V56 cohomology rank constraints | 16 kernel-pure theorems |

## Original vs Current Cuts

Original: 9 project cuts + 3 kernel = 12 total
After R514-R520:
- 4 original cuts CLOSED as derived theorems (hc_real_cy3_reducible, hyp_HC_CM_Ab_real, hc_real_e6_case, mt_correspondence_e7_witness_exists)
- Replaced by smaller-scope cuts (total active: ~16 project cuts + 3 kernel = ~19)

Each new cut has strictly smaller mathematical scope than the original it replaces.

## Active Project Cuts (grouped by hardness)

### Tier 1: Conditional but well-understood
1. `abs_hodge_implies_algebraic` - AH=>algebraicity (conditional, equivalent to HC for AH classes)
2. `deligne_1982_abs_hodge_cm` - Deligne 1982 (established, Mathlib gap)

### Tier 2: Requires Mathlib-level infrastructure
3. `hc_real_classical_cartan` - Classical Cartan HC (needs Lefschetz (1,1) + Hard Lefschetz)
4. `SmoothProjectiveVariety.cohomology` - Hodge theorem (needs sheaf cohomology)
5. `SmoothProjectiveVariety.algClasses` - Cycle class map (needs intersection theory)
6. `canonicalE7ShimuraTor` - AMRT construction (needs Shimura varieties in Mathlib)
7. `e6_factor_classical_transfer` - E6-classical bridge (needs cohomological Kunneth)
8. `classical_mt_standard_hodge` - Standard Hodge structure (needs representation theory)
9. `classical_mt_all_hodge_algebraic` - Classical => algebraic (needs cycle class map)

### Tier 3: Paper-level mathematics
10. `e7_cm_witness_exists` - Kuga-Satake construction
11. `e7_correspondence_package_exists` - Kudla-Millson correspondence
12. `cy3_e7_nonexistence_paper_axiom` - CY3 nonexistence (original, still used)
13. `cy3_inherits_e7_factor_exact` - Geometric inheritance bridge
14. `springer_discriminant_lower_bound` - Springer discriminant theory
15. `v56_unique_j3o_identification` - Jordan algebra identification
16. `j3o_not_geometric_h3` - Geometric nonexistence of J3O as H^3

### Kernel (3, always present)
17. propext
18. Classical.choice
19. Quot.sound

## Honest Assessment

No actual mathematical gaps were closed. All 4 "closures" are derivations from
decomposed sub-axioms. The gap structure is now more transparent, with each
cut having a precise mathematical scope.

The project has reached the limits of what can be done without:
1. Mathlib sheaf cohomology (closes: cohomology, algClasses, classical Cartan)
2. Mathlib Shimura varieties (closes: canonicalE7ShimuraTor)
3. Mathlib absolute Hodge theory (closes: Deligne 1982)
4. Formalized Springer discriminant (closes: CY3 nonexistence stages)

Each of these is a multi-year Mathlib development effort.
