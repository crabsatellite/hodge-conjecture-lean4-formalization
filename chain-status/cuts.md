# HodgeReduction -- cut ledger

Every xiom reached from an endpoint.  Whitelisted cuts are
open by design; non-whitelisted cuts are I1 hard-failures.

**R514 update**: hc_real_cy3_reducible converted from axiom to
derived theorem (via CY3+E7 vacuity discharge). Replaced by bridge
axiom cy3_inherits_e7_factor_exact (smaller scope, geometric-only).


| axiom | file | status |
|-------|------|--------|
| Classical.choice | Init/Prelude.lean | OPEN (whitelisted) |
| HodgeReduction.SmoothProjectiveVariety.algClasses | HodgeReduction/OpenHypotheses.lean | OPEN (whitelisted) |
| HodgeReduction.SmoothProjectiveVariety.cohomology | HodgeReduction/OpenHypotheses.lean | OPEN (whitelisted) |
| HodgeReduction.canonicalE7ShimuraTor | HodgeReduction/OpenHypotheses.lean | OPEN (whitelisted) |
| HodgeReduction.cy3_e7_nonexistence_paper_axiom | HodgeReduction/ClassicalResults.lean | OPEN (whitelisted) |
| HodgeReduction.cy3_inherits_e7_factor_exact | HodgeReduction/HCGapL4/CY3VacuityDischarge.lean | OPEN (whitelisted, R514 bridge) |
| HodgeReduction.hc_real_classical_cartan | HodgeReduction/MainTheorem.lean | OPEN (whitelisted) |
| HodgeReduction.hc_real_e6_case | HodgeReduction/MainTheorem.lean | OPEN (whitelisted) |
| HodgeReduction.hyp_HC_CM_Ab_real | HodgeReduction/MainTheorem.lean | OPEN (whitelisted) |
| HodgeReduction.mt_correspondence_e7_witness_exists | HodgeReduction/MainTheorem.lean | OPEN (whitelisted) |
| Quot.sound | Init/Core.lean | OPEN (whitelisted) |
| propext | Init/Core.lean | OPEN (whitelisted) |

## CLOSED (R514)

| former axiom | file | status |
|-------|------|--------|
| HodgeReduction.hc_real_cy3_reducible | HodgeReduction/MainTheorem.lean | CLOSED-R514 (derived via vacuity discharge) |