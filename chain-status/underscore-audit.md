# HodgeReduction -- underscore-param audit (W7)

Theorem / axiom surfaces with `_`-prefixed pi-binders.  These are
review warnings: they can hide the `_h_atom` deception pattern, but
some projects also use `_h` names as ordinary binder style.


* on-chain hits: **0** (WARN)
* off-chain hits: **3** (informational)


## On-chain hits (review debt)

(none)

## Off-chain hits (informational)

| file | decl | params |
|------|------|--------|
| `HodgeReduction/HCGapL4/CohomologyProfileComparisonConditional.lean` | `HodgeReduction.HCGapL4.cohomologyProfileComparison_targets_from_explicit_hypotheses` | `_M, _I` |
| `HodgeReduction/HCGapL4/GaussianCMActionAddCasesBasic.lean` | `HodgeReduction.HCGapL4.gaussianCMAction_inverse_branch_condition_preserved` | `_hx` |
| `HodgeReduction/HCGapL4/ShadowCanonicalHCTheorem.lean` | `HodgeReduction.HCGapL4.shadow_hodgeConjectureReal_canonical_codim1` | `_assumptions` |
