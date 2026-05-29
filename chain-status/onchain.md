# HodgeReduction -- on-chain files

Files whose declarations are transitively reached from `config.endpoints` (and are not in the quarantine list).


* on-chain: **3**  *  cut: **7**  *  total reached: **10**

* closure constants: 7555  *  closure modules: 273


## On-chain files

| file | decls | on-chain decls (sample) |
|------|------:|--------------------------|
| `HodgeReduction/Infrastructure/HodgeStructure/Basic.lean` | 156 | PureHodgeStructure, HodgeConjectureForCycleMap, hodgeConjecture_transfer (+15 more) |
| `HodgeReduction/Infrastructure/HodgeStructure/VarietyCohomology.lean` | 43 | VarietyHCAt, addCommGroup, hodgeClassesAtDegree (+17 more) |
| `HodgeReduction/Types.lean` | 117 | IsCalabiYauThreefold, InScope, IsTorus (+42 more) |

## Cut files (on-chain + declares axiom)

| file | decls | axioms |
|------|------:|-------:|
| `HodgeReduction/ClassicalResults.lean` | 7 | 1 |
| `HodgeReduction/HCGapL4/CMAbelianHCBridge.lean` | 7 | 3 |
| `HodgeReduction/HCGapL4/CY3VacuityDischarge.lean` | 5 | 1 |
| `HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean` | 4 | 1 |
| `HodgeReduction/HCGapL4/MTWitnessDecomposition.lean` | 6 | 2 |
| `HodgeReduction/MainTheorem.lean` | 32 | 1 |
| `HodgeReduction/OpenHypotheses.lean` | 462 | 204 |
