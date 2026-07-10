import Lake
open Lake DSL

/-!
Lake project for the machine-audited Hodge paper ledger.

The default library exposes only the formal target, the generated paper
evidence snapshot, and the small audit chain.  Historical attack modules may
remain in the repository for archaeology, but they are not part of this root.
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
