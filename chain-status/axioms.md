# HodgeReduction -- per-endpoint axioms

Equivalent to running #print axioms <endpoint> for each endpoint.


## HodgeReduction.hodgeConjectureReal_canonical

- Classical.choice
- HodgeReduction.canonicalE7ShimuraTor
- Quot.sound
- propext

## HodgeReduction.main_reduction_real

- Classical.choice
- HodgeReduction.SmoothProjectiveVariety.algClasses
- HodgeReduction.SmoothProjectiveVariety.cohomology
- HodgeReduction.cy3_inherits_e7_factor_exact (R514 bridge, replaces hc_real_cy3_reducible)
- HodgeReduction.cy3_e7_nonexistence_paper_axiom
- HodgeReduction.hc_real_classical_cartan
- HodgeReduction.hc_real_e6_case
- HodgeReduction.hyp_HC_CM_Ab_real
- HodgeReduction.mt_correspondence_e7_witness_exists
- Quot.sound
- propext

Note: hc_real_cy3_reducible is now a DERIVED THEOREM (R514),
no longer an axiom. The dependency chain is:
  hc_real_cy3_reducible (theorem)
    <- hc_real_cy3_reducible_via_vacuity
       <- cy3_inherits_e7_factor_exact (bridge axiom)
       <- cy3_e7_nonexistence_paper_axiom (existing axiom)

## HodgeReduction.thm_Meyer

(no axioms)

## HodgeReduction.thm_G2F4

- Classical.choice
- Quot.sound
- propext

## HodgeReduction.thm_E8_vacuous

- Classical.choice
- Quot.sound
- propext

## HodgeReduction.thm_cy3_e7_nonexistence

- Classical.choice
- HodgeReduction.cy3_e7_nonexistence_paper_axiom
- Quot.sound
- propext

## HodgeReduction.thm_subcase3b_vacuous

(no axioms)