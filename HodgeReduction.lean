/-
# HodgeReduction — top-level module.

Lean4 formalisation of the Mumford--Tate reduction of the Hodge Conjecture
("A Mumford--Tate Reduction of the Hodge Conjecture", Alex Chengyu Li, 2026).

The formalisation matches the state of the master proof at its current
writing. The Main Theorem is a *reduction*, not an unconditional proof: it
concludes HC on four enumerated scope sub-classes modulo nine labelled
paper hypotheses and the sub-gaps inventoried in the paper's appendix.
Several sub-branches (exotic rigid non-Shimura E7-type in dim >= 5 with
c1 != 0) are explicitly OPEN and carry no theorem statement.

Re-exports:
  * `HodgeReduction.Types`            — opaque types.
  * `HodgeReduction.ClassicalResults` — classical results (axiomatised
                                        pending Mathlib port).
  * `HodgeReduction.OpenHypotheses`   — nine labelled paper hypotheses.
  * `HodgeReduction.MainTheorem`      — the Main Theorem and unconditional
                                        theorems, each with `sorry`.
  * `HodgeReduction.Ledger`           — gap ledger (status + metadata for
                                        every OPEN / PARTIAL / BLOCKED /
                                        DEAD-END / CLOSED entry; cross-
                                        session attack-history record).
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses
import HodgeReduction.MainTheorem
import HodgeReduction.Ledger
