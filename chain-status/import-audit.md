# HodgeReduction -- import audit (W2)

On-chain import compile-prune candidates.  These are static signals:
the reflected declarations do not consume project declarations from
the imported module closure, but theorem proof/elaboration can still
require the import.  Only remove a candidate after compile verification.


**3** finding(s):

- HodgeReduction/HCGapL4/CY3E7Bridge.lean: compile-prune candidate: on-chain `HodgeReduction.HCGapL4.CY3E7Bridge` imports `HodgeReduction.Infrastructure.SimpleLieAlgebraClassification` but reflected declarations consume no project decl from that import closure
- HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean: compile-prune candidate: on-chain `HodgeReduction.HCGapL4.E6CaseClassicalBridge` imports `HodgeReduction.Infrastructure.DynkinMarks` but reflected declarations consume no project decl from that import closure
- HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean: compile-prune candidate: on-chain `HodgeReduction.HCGapL4.E6CaseClassicalBridge` imports `HodgeReduction.Infrastructure.SimpleLieAlgebraClassification` but reflected declarations consume no project decl from that import closure
