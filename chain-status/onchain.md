# HodgeReduction -- on-chain files

Files whose declarations are transitively reached from `config.endpoints` (and are not in the quarantine list).


* on-chain: **5**  *  cut: **7**  *  total reached: **12**

* closure constants: 7566  *  closure modules: 275


## On-chain files

| file | decls | on-chain decls (sample) |
|------|------:|--------------------------|
| `HodgeReduction/HCGapL4/CY3VacuityDischarge.lean` | 4 | cy3_e7_vacuity_via_bridge, hc_real_cy3_reducible_via_vacuity |
| `HodgeReduction/HCGapL4/CY3VacuousClosureAttempt.lean` | 9 | e7_unique_under_exclusivity, hasSimpleFactor_E7_iff_isE7Type, hasSimpleFactor_E7_implies_isE7Type |
| `HodgeReduction/Infrastructure/HodgeStructure/Basic.lean` | 156 | PureHodgeStructure, HodgeConjectureForCycleMap, hodgeConjecture_transfer (+15 more) |
| `HodgeReduction/Infrastructure/HodgeStructure/VarietyCohomology.lean` | 43 | VarietyHCAt, addCommGroup, hodgeClassesAtDegree (+17 more) |
| `HodgeReduction/Types.lean` | 117 | IsCalabiYauThreefold, InScope, IsTorus (+47 more) |

## Cut files (on-chain + declares axiom)

| file | decls | axioms |
|------|------:|-------:|
| `HodgeReduction/ClassicalResults.lean` | 7 | 1 |
| `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean` | 7 | 3 |
| `HodgeReduction/HCGapL4/CY3E7Bridge.lean` | 8 | 3 |
| `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean` | 4 | 1 |
| `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean` | 5 | 2 |
| `HodgeReduction/MainTheorem.lean` | 32 | 1 |
| `HodgeReduction/OpenHypotheses.lean` | 462 | 204 |
