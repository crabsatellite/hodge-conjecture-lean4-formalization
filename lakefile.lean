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

All theorem bodies carry `sorry` only where the paper explicitly states an
open hypothesis; the headline `hodgeConjectureReal_canonical` is closed
modulo a single project-axiom `canonicalE7ShimuraTor : E7ShimuraTor` whose
fields are layer-classified in `HodgeReduction.HCGapRegistry`.
-/

package «HodgeReduction» where
  leanOptions := #[
    ⟨`pp.unicode.fun, true⟩,
    ⟨`autoImplicit, false⟩
  ]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.16.0"

/-
Shared chain-audit infrastructure.  The path dependency points at the
same `tools/chain-audit` package that `abc-conjecture/lean4-formalization`
uses; the package's own `lakefile.lean` writes products into a
version-specific `.lake/build-<Lean.versionString>/` directory, so both
consumers safely share one source checkout without colliding artifacts.
Do NOT add a `buildDir` override here: that is the chainAudit package's
concern; this project keeps the default `.lake/build/` for its own
HodgeReduction library so its build cache stays independent of ABC's.
-/
require chainAudit from "../../../tools/chain-audit"

@[default_target]
lean_lib «HodgeReduction» where
  roots := #[`HodgeReduction]

lean_exe «hodge-status» where
  root := `HodgeReduction.Scripts.StatusEntry
  supportInterpreter := true

lean_exe «hodge-check» where
  root := `HodgeReduction.Scripts.CheckEntry
  supportInterpreter := true
