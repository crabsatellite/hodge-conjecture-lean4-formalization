# ChainAudit

Project-agnostic Lean 4 main-chain audit infrastructure.

ChainAudit derives a file classification from declared endpoint theorems and
emits `chain-status/*.md` reports:

* `on-chain`: files whose declarations are transitively reached from an endpoint.
* `cut`: on-chain files that declare accepted open axioms or hypotheses.
* `quarantine`: explicitly abandoned or failed routes.
* `infra`: standalone audit/tooling files.
* `orphan`: loaded but unreachable files, or disk files that are not loaded by the chain.

It is designed so the Lean source is the truth source. A host project records
its endpoints, accepted open axioms, failed branches, active routes, and named
gaps in `ProjectConfig`; the Markdown reports are generated artifacts.

## Checks

Hard failures:

* `I1`: endpoint-reached axiom outside `openAxioms`, `kernelAxioms`, or `trustedAxioms`.
* `I3`: quarantine imported by an on-chain/cut file.
* `I4`: theorem directly assumes its own conclusion as a premise.
* `I5`: on-chain/cut `def : Prop` is a literal `True`/`False`/`Unit` placeholder.
* `I6`: on-chain/cut theorem has a literal `True`/`Unit`/`PUnit` conclusion.

Warnings:

* `W1`: imported orphan file.
* `W2`: compile-prune candidate for an unused on-chain import.
* `W3`: on-disk `.lean` file not loaded by the audit environment.
* `W4`: compile-prune candidate for an orphan-to-orphan import.
* `W5`: audit-visible `def : Prop`, including suspicious stronger-premise names.
* `W6`: off-chain theorem with a literal `True`/`Unit`/`PUnit` conclusion.
* `W7`: `_`-prefixed theorem/axiom binders. This is review debt rather than a hard
  failure because some projects use `_h` names as ordinary binder style.

## Quick Start

Suppose your project is `MyProject`, root namespace `MyProject`, with target
theorem `MyProject.Foo.mainTheorem`.

Step 1: add ChainAudit to the host `lakefile.lean`:

```lean
require chainAudit from "../../../tools/chain-audit"
```

For a TOML Lake project:

```toml
[[require]]
name = "chainAudit"
path = "../../../tools/chain-audit"
```

If ChainAudit is extracted to a standalone repository, use:

```lean
require chainAudit from git "https://github.com/your-org/chain-audit" @ "v1.0.0"
```

Step 2: create `MyProject/MainChain.lean`:

```lean
import ChainAudit
import MyProject

namespace MyProject.MainChain

def config : ChainAudit.ProjectConfig := {
  projectName := "MyProject"
  rootNamespace := `MyProject
  endpoints := [
    ``MyProject.Foo.mainTheorem
  ]
  openAxioms := []
  trustedAxioms := []
  quarantine := []
  researchChains := []
  researchGaps := []
}

end MyProject.MainChain
```

Step 3: create `MyProject/Scripts/StatusEntry.lean`:

```lean
import MyProject.MainChain

def main : IO UInt32 :=
  ChainAudit.Status.runAudit MyProject.MainChain.config
```

Step 4: create `MyProject/Scripts/CheckEntry.lean`:

```lean
import MyProject.MainChain

def main : IO UInt32 :=
  ChainAudit.Status.runCheck MyProject.MainChain.config
```

Step 5: register executables.

For `lakefile.lean`:

```lean
lean_exe "myproject-status" where
  root := `MyProject.Scripts.StatusEntry
  supportInterpreter := true

lean_exe "myproject-check" where
  root := `MyProject.Scripts.CheckEntry
  supportInterpreter := true
```

For `lakefile.toml`:

```toml
[[lean_exe]]
name = "myproject-status"
root = "MyProject.Scripts.StatusEntry"
supportInterpreter = true

[[lean_exe]]
name = "myproject-check"
root = "MyProject.Scripts.CheckEntry"
supportInterpreter = true
```

Step 6: run the audit.

```bash
lake build
lake env lean --run MyProject/Scripts/StatusEntry.lean
lake env lean --run MyProject/Scripts/CheckEntry.lean
python <chainAudit>/ChainAudit/Postprocess/post_process.py --raw chain-status/raw.json --out chain-status
```

On Windows and large Mathlib projects, prefer `lake env lean --run ...` over
`lake exe ...` to avoid native executable linker limits.
For the local path dependency shown above, `<chainAudit>` is
`../../../tools/chain-audit` when run from this Hamilton project root.

## Outputs

After `*-status` and `post_process.py`, `chain-status/` contains:

| file | purpose |
|------|---------|
| `raw.json` | machine-readable audit dump |
| `route-index.md` | decision-first route/gap/branch index |
| `research-map.md` | main/support/active/dead route graph |
| `graph.md` | Mermaid graph from kernel/cuts to endpoints |
| `onchain.md` | on-chain and cut file list |
| `offchain.md` | quarantine/infra/orphan/on-disk-unloaded split |
| `orphans.md` | files not wired into the audited chain |
| `orphan-debt.md` | orphan components and branch heads |
| `cuts.md` | every endpoint-reached axiom and whitelist status |
| `axioms.md` | per-endpoint axiom ledger |
| `trick-audit.md` | axiom, self-assumption, vacuous theorem/Prop-def audit |
| `underscore-audit.md` | `W7` underscore-binder review debt |
| `import-audit.md` | `W2`/`W4` import-prune candidates |
| `findings.md` | all FAIL/WARN findings grouped by rule |

Optional compile-verified orphan import cleanup:

```bash
python <chainAudit>/ChainAudit/Postprocess/prune_unused_orphan_imports.py \
  --raw chain-status/raw.json \
  --apply \
  --rules W2.unused-import,W4.unused-orphan-import
lake build
lake env lean --run MyProject/Scripts/StatusEntry.lean
python <chainAudit>/ChainAudit/Postprocess/post_process.py --raw chain-status/raw.json --out chain-status
```

The prune tool removes exact top-level import lines one importer at a time and
immediately builds the importer plus reverse dependents from `raw.json`. Any
failing edit is restored.

## Version Sharing

The shared package intentionally uses a version-specific Lake build directory:

```lean
buildDir := System.FilePath.mk (".lake/build-" ++ Lean.versionString)
```

This lets one source checkout serve host projects on different Lean versions
without reusing incompatible `.olean` files. The status runner also probes both
known Lake layouts:

* `.lake/build/lib/<Module>.olean`
* `.lake/build/lib/lean/<Module>.olean`

This is needed when one repository contains projects on both older and newer
Lean/Lake versions.

## CI Pattern

Recommended PR gate:

1. `lake build`
2. `lake env lean --run <Project>/Scripts/StatusEntry.lean`
3. `lake env lean --run <Project>/Scripts/CheckEntry.lean`
4. `python <chainAudit>/ChainAudit/Postprocess/post_process.py --raw chain-status/raw.json --out chain-status`
5. `git diff --exit-code chain-status/`

## Architecture

```text
ChainAudit.lean
ChainAudit/
  Basic.lean
  Reflection.lean
  Classification.lean
  Audit.lean
  Json.lean
  Status.lean
  Postprocess/
    post_process.py
    prune_unused_orphan_imports.py
```

No host-project-specific identifiers or route names should appear under
`ChainAudit/`. Project-specific route labels belong in `ProjectConfig`.

## Limits

* The audit environment only sees modules imported by the audit entry module.
  Disk-only orphan files are listed as `W3`, but their declarations are not
  inspected until they are imported or quarantined.
* Full semantic detection of "a stronger theorem was smuggled in as a new
  definition" is not decidable syntactically. ChainAudit reports all
  audit-visible `def : Prop` surfaces as `W5`; projects should promote local
  patterns to hard failures with explicit allowlists if needed.

## Extraction

To turn the shared folder into a standalone repository later:

```bash
git subtree split --prefix=tools/chain-audit -b chain-audit-extract
```

Then push that branch to a dedicated internal repository and replace local path
dependencies with a pinned Git dependency.
