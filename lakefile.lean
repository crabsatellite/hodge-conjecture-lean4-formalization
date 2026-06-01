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

The audit entrypoint is `HodgeReduction.MainChain` (single source of truth
for the generated `chain-status/*` reports).  The root aggregator
`HodgeReduction.lean` intentionally re-exports many historical attack files
and is NOT the audit entry; it is the bulk import surface.  This matches the
canonical Millennium-style infrastructure pattern shared with
`abc-conjecture/lean4-formalization` and other sibling projects, via the
shared `chainAudit` Lake package located at `tools/chain-audit`.

The final theorem target is recorded in `HodgeReduction.FullHodgeGoal` as
`FullHodgeConjectureReal`.  The current headline
`hodgeConjectureReal_canonical` is a conditional canonical `E_7` milestone,
not the full Hodge Conjecture.
-/

package «HodgeReduction» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.16.0"

/-
Shared chain-audit infrastructure.  The dependency is vendored inside this
repository so standalone CI checkouts do not rely on the local OpenExecution
monorepo layout.  The package's own `lakefile.lean` writes products into a
version-specific `.lake/build-<Lean.versionString>/` directory, so consumers
safely avoid colliding artifacts.
-/
require chainAudit from "vendor/chain-audit"

@[default_target]
lean_lib «HodgeReduction» where
  roots := #[`HodgeReduction]

lean_exe «hodge-status» where
  root := `HodgeReduction.Scripts.StatusEntry
  supportInterpreter := true

lean_exe «hodge-check» where
  root := `HodgeReduction.Scripts.CheckEntry
  supportInterpreter := true
