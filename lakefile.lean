import Lake
open Lake DSL

/-!
Lake project for the Hodge-conjecture Mumford--Tate reduction formalisation.

The top-level module `HodgeReduction` re-exports:
  * `HodgeReduction.Types`           — opaque types (scheme, variety, divisor,
                                        Mumford--Tate group, Hodge number, ...).
  * `HodgeReduction.ClassicalResults` — classical theorems axiomatised pending
                                        Mathlib port (each axiom carries an
                                        author/work/theorem citation).
  * `HodgeReduction.OpenHypotheses`  — the nine labelled paper hypotheses
                                        `hyp:HC-CM-Ab`, ..., `hyp:hecke-bbt`.
  * `HodgeReduction.MainTheorem`     — the conditional Main Theorem
                                        (Theorem `thm:main`) plus the
                                        unconditional theorems
                                        `thm:cy3-e7-nonexistence`,
                                        `thm:E8_vacuous`, `thm:G2F4`,
                                        `thm:Meyer`, `rem:E6-V27-vacuity`,
                                        and the conditional Chern--Weil /
                                        Sub-case 3b theorems.

All theorem bodies carry `sorry`; Lean-level proofs are future work.
-/

package «HodgeReduction» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.16.0"

@[default_target]
lean_lib «HodgeReduction» where
  roots := #[`HodgeReduction]
