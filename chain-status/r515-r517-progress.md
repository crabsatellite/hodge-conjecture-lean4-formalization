# R515-R517 Progress Report

## Decompositions (3 axioms split into 6 smaller axioms)

### R515: hyp_HC_CM_Ab_real -> Deligne 1982 + conditional extension
- Retired: hyp_HC_CM_Ab_real (large: HC for all CM abelian)
- New: deligne_1982_abs_hodge_cm (established: Hodge => AH for CM)
- New: bs_hodge_implies_algebraic (conditional: AH => algebraic)
- Derived: hyp_HC_CM_Ab_real_via_delille_ah (composition)
- File: HodgeReduction/HCGapL4/CMAbelianHCBridge.lean

### R516: hc_real_e6_case -> bridge + classical Cartan
- Retired: hc_real_e6_case (E6 => HC-real)
- New: e6_factor_classical_transfer (E6+classical => HC, conditioned on classical HC)
- Derived: hc_real_e6_case_via_classical (uses classical Cartan)
- File: HodgeReduction/HCGapL4/E6CaseClassicalBridge.lean
- Key: weight-parity obstruction at weight 3 is kernel-pure

### R517: mt_correspondence_e7_witness_exists -> witness + package
- Retired: mt_correspondence_e7_witness_exists (bundled existence)
- New: e7_cm_witness_exists (geometric: CM abelian exists)
- New: e7_correspondence_package_exists (data: correspondence package)
- Derived: mt_correspondence_e7_witness_via_decomposition (composition)
- File: HodgeReduction/HCGapL4/MTWitnessDecomposition.lean

## Updated Cut Ledger

### Original 9 cuts -> 11 decomposed cuts (smaller scope each)

| # | Original cut | Decomposed? | New cuts |
|---|-------------|-------------|----------|
| 1 | hyp_HC_CM_Ab_real | R515 | deligne_1982_abs_hodge_cm + abs_hodge_implies_algebraic |
| 2 | hc_real_e6_case | R516 | e6_factor_classical_transfer (+ hc_real_classical_cartan) |
| 3 | mt_correspondence_e7_witness_exists | R517 | e7_cm_witness_exists + e7_correspondence_package_exists |
| 4 | hc_real_classical_cartan | no | (requires Lefschetz (1,1) + Hard Lefschetz) |
| 5 | canonicalE7ShimuraTor | no | (requires AMRT toroidal compactification) |
| 6 | SmoothProjectiveVariety.cohomology | no | (requires sheaf cohomology / Hodge theorem) |
| 7 | SmoothProjectiveVariety.algClasses | no | (requires cycle class map) |
| 8 | cy3_e7_nonexistence_paper_axiom | no | (paper Stages A-D + Springer discriminant) |
| 9 | cy3_inherits_e7_factor_exact | no | (geometric inheritance, R514 bridge) |
+ 3 kernel: propext, Classical.choice, Quot.sound

## Honest Assessment

The decompositions make the gap structure more transparent:
- R515 separates established math (Deligne 1982) from open conjecture (AH=>alg)
- R516 separates kernel-pure weight-parity from cohomological transfer
- R517 separates geometric construction from correspondence data

No actual mathematical gaps were closed. The remaining 11 project cuts + 3 kernel cuts
all require genuine mathematical infrastructure at or beyond Mathlib's current coverage.
The most productive next step would be attacking hc_real_classical_cartan if Mathlib
gains sheaf cohomology, or bs_hodge_implies_algebraic if we accept the conditional.
