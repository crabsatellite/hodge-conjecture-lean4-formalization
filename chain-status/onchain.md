# HodgeReduction -- on-chain files

Files whose declarations are transitively reached from `config.endpoints` (and are not in the quarantine list).


* on-chain: **6**  *  cut: **7**  *  total reached: **13**

* closure constants: 7594  *  closure modules: 276


## On-chain files

| file | decls | on-chain decls (sample) |
|------|------:|--------------------------|
| `HodgeReduction/ClassicalResults.lean` | 7 | kostant_vacuity_F4, kostant_vacuity_G2, cy3_e7_nonexistence_paper_axiom (+2 more) |
| `HodgeReduction/HCGapL4/CY3VacuityDischarge.lean` | 4 | cy3_e7_vacuity_via_bridge, hc_real_cy3_reducible_via_vacuity |
| `HodgeReduction/HCGapL4/CY3VacuousClosureAttempt.lean` | 9 | e7_unique_under_exclusivity, hasSimpleFactor_E7_iff_isE7Type, hasSimpleFactor_E7_implies_isE7Type |
| `HodgeReduction/Infrastructure/HodgeStructure/Basic.lean` | 156 | PureHodgeStructure, HodgeConjectureForCycleMap, hodgeConjecture_transfer (+15 more) |
| `HodgeReduction/Infrastructure/HodgeStructure/VarietyCohomology.lean` | 43 | VarietyHCAt, addCommGroup, hodgeClassesAtDegree (+17 more) |
| `HodgeReduction/Types.lean` | 117 | IsCalabiYauThreefold, InScope, IsTorus (+47 more) |

## Cut files (on-chain + declares axiom)

| file | decls | axioms |
|------|------:|-------:|
| `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean` | 10 | 4 |
| `HodgeReduction/HCGapL4/CY3E7Bridge.lean` | 8 | 3 |
| `HodgeReduction/HCGapL4/CY3NonexistenceStageCuts.lean` | 28 | 3 |
| `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean` | 6 | 2 |
| `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean` | 14 | 6 |
| `HodgeReduction/MainTheorem.lean` | 40 | 1 |
| `HodgeReduction/OpenHypotheses.lean` | 494 | 207 |
