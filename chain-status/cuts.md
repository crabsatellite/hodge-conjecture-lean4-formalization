# HodgeReduction -- cut ledger

Every axiom reached from an endpoint. Whitelisted cuts are
open by design; non-whitelisted cuts are hard-failures.

## R515-R518 update: axiom decompositions

Three original axioms decomposed into smaller-scope axioms:
- R514: hc_real_cy3_reducible -> derived theorem (via vacuity discharge)
- R515: hyp_HC_CM_Ab_real -> deligne_1982_abs_hodge_cm + abs_hodge_implies_algebraic
- R516: hc_real_e6_case -> e6_factor_classical_transfer (bridge)
- R517: mt_correspondence -> e7_cm_witness_exists + e7_correspondence_package_exists
- R518: gap card for classical_cartan boundary

## Active cuts (whitelisted, open)

| axiom | file | status |
|-------|------|--------|
| Classical.choice | Init/Prelude.lean | OPEN (kernel) |
| Quot.sound | Init/Core.lean | OPEN (kernel) |
| propext | Init/Core.lean | OPEN (kernel) |
| HodgeReduction.SmoothProjectiveVariety.algClasses | OpenHypotheses.lean | OPEN (whitelisted) |
| HodgeReduction.SmoothProjectiveVariety.cohomology | OpenHypotheses.lean | OPEN (whitelisted) |
| HodgeReduction.canonicalE7ShimuraTor | OpenHypotheses.lean | OPEN (whitelisted) |
| HodgeReduction.cy3_e7_nonexistence_paper_axiom | ClassicalResults.lean | OPEN (whitelisted) |
| HodgeReduction.cy3_inherits_e7_factor_exact | CY3VacuityDischarge.lean | OPEN (R514 bridge) |
| HodgeReduction.hc_real_classical_cartan | MainTheorem.lean | OPEN (whitelisted) |
| HodgeReduction.deligne_1982_abs_hodge_cm | CMAbelianHCBridge.lean | OPEN (R515 decomposition, established math) |
| HodgeReduction.abs_hodge_implies_algebraic | CMAbelianHCBridge.lean | OPEN (R515 decomposition, conditional) |
| HodgeReduction.e6_factor_classical_transfer | E6CaseClassicalBridge.lean | OPEN (R516 bridge) |
| HodgeReduction.e7_cm_witness_exists | MTWitnessDecomposition.lean | OPEN (R517 decomposition, geometric) |
| HodgeReduction.e7_correspondence_package_exists | MTWitnessDecomposition.lean | OPEN (R517 decomposition, correspondence) |
| HodgeReduction.classical_mt_standard_hodge | ClassicalCartanGapCard.lean | OPEN (R518 gap boundary) |
| HodgeReduction.classical_mt_all_hodge_algebraic | ClassicalCartanGapCard.lean | OPEN (R518 gap boundary) |

## CLOSED

| former axiom | file | status |
|-------|------|--------|
| HodgeReduction.hc_real_cy3_reducible | MainTheorem.lean | CLOSED-R514 (derived via vacuity discharge) |
| HodgeReduction.hyp_HC_CM_Ab_real | MainTheorem.lean | CLOSED-R515 (derived via Deligne 1982 + AH extension) |
| HodgeReduction.hc_real_e6_case | MainTheorem.lean | CLOSED-R516 (derived via classical transfer bridge) |
| HodgeReduction.mt_correspondence_e7_witness_exists | MainTheorem.lean | CLOSED-R517 (derived via witness+package decomposition) |


## R521-R523 update: infrastructure strengthening

No changes to the cut ledger. Three rounds of kernel-pure infrastructure:
- R521: Closed 3 sorry in SimpleLieAlgebraClassification (classical_cartan_type_remains, classification_cross_check, exceptional_dim_check)
- R522: 18 new theorems in ClassicalCominusculeClassification (A_n/B_n/C_n/D_n Dynkin marks)
- R523: 22 new theorems in CY3SpringerDiscriminant (Springer discriminant arithmetic for CY3+E7 nonexistence)

All active cuts remain as listed above. No axioms closed or opened.
