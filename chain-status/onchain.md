# HodgeReduction -- on-chain files

Files whose declarations are transitively reached from `config.endpoints` (and are not in the quarantine list).


* on-chain: **3**  *  cut: **3**  *  total reached: **6**

* closure constants: 7540  *  closure modules: 269


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
| `HodgeReduction/MainTheorem.lean` | 32 | 5 |
| `HodgeReduction/OpenHypotheses.lean` | 462 | 204 |
