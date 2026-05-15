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
  * `HodgeReduction.OpenHypotheses`   — nine labelled paper hypotheses
                                        (exploratory reduction-stage ledger
                                        with broken-link Phase 0 audit trail).
  * `HodgeReduction.MainTheorem`      — the Main Theorem and unconditional
                                        theorems, each with `sorry`.
  * `HodgeReduction.Ledger`           — gap ledger (status + metadata for
                                        every OPEN / PARTIAL / BLOCKED /
                                        DEAD-END / CLOSED entry; cross-
                                        session attack-history record).
  * `HodgeReduction.Strict`           — Cat 1-3 strict-discipline restructure
                                        (P17+). Each chain migrates from
                                        opaque-axiom reduction-stage to
                                        Cat 1+2-only derivation-stage via
                                        explicit-content Cat 2 axioms +
                                        derived theorems + honest conditional
                                        structure for open targets.
-/

import HodgeReduction.Types
import HodgeReduction.ClassicalResults
import HodgeReduction.OpenHypotheses
import HodgeReduction.MainTheorem
import HodgeReduction.Ledger
import HodgeReduction.Strict
import HodgeReduction.CrossRingArithmetic
import HodgeReduction.Infrastructure.CartanMatrices
import HodgeReduction.Infrastructure.SchlafliGraph
import HodgeReduction.Infrastructure.Octonion
import HodgeReduction.Infrastructure.JordanJ3O
import HodgeReduction.Infrastructure.V56Freudenthal
import HodgeReduction.Infrastructure.CoxeterDegrees
import HodgeReduction.Infrastructure.OctonionBasis
import HodgeReduction.Infrastructure.JordanJ3OBasis
import HodgeReduction.Infrastructure.V56Basis
import HodgeReduction.Infrastructure.LinearMaps
import HodgeReduction.Infrastructure.V56HodgeDecomp
import HodgeReduction.Infrastructure.J3OInnerProduct
import HodgeReduction.Infrastructure.J3OJordan
import HodgeReduction.Infrastructure.V56HodgeRank
import HodgeReduction.Infrastructure.Cohomology.Basic
import HodgeReduction.Infrastructure.Cohomology.ChernClasses
import HodgeReduction.Infrastructure.Cohomology.KaehlerClass
import HodgeReduction.Infrastructure.Cohomology.FreudenthalClass
import HodgeReduction.Infrastructure.HodgeStructure.Basic
import HodgeReduction.Infrastructure.HodgeStructure.Polarised
import HodgeReduction.Infrastructure.HodgeStructure.V56Instance
import HodgeReduction.Infrastructure.HodgeStructure.MumfordTate
import HodgeReduction.Infrastructure.Coxeter.WE7
