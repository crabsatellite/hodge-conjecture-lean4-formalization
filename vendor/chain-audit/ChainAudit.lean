/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit.Basic
import ChainAudit.Reflection
import ChainAudit.Classification
import ChainAudit.Audit
import ChainAudit.Json
import ChainAudit.Status

/-!
# `ChainAudit` -- reusable Lean main-chain audit infrastructure

Project-agnostic audit tooling for any Lean 4 project that wants:

* `chain-status/` Markdown reports of which files are on-chain vs orphan
* an axiom ledger that diffs against a baseline
* hard-failure invariants for unwhitelisted axioms, quarantine leaks,
  self-assumption tricks, and vacuous theorem/Prop-definition placeholders
* warning ledgers for orphan files, suspicious `def : Prop` surfaces,
  underscore-prefixed theorem binders, and compile-verified import pruning

## Quick start for a new host project

1.  Add `ChainAudit` as a dependency (or copy the directory).
2.  Create `MyProject/MainChain.lean`:

    ```lean
    import ChainAudit
    import MyProject -- whatever transitively brings in the endpoints

    open Lean

    namespace MyProject.MainChain

    def config : ChainAudit.ProjectConfig := {
      projectName := "MyProject"
      rootNamespace := `MyProject
      endpoints := [
        ``MyProject.Foo.mainTheorem,
        ``MyProject.Bar.anotherTheorem
      ]
      openAxioms := [
        -- list axioms you accept as KNOWN open
      ]
      quarantine := [
        -- list explicitly abandoned files
      ]
    }

    end MyProject.MainChain
    ```

3.  Create `MyProject/Scripts/StatusEntry.lean`:

    ```lean
    import MyProject.MainChain
    def main : IO UInt32 := ChainAudit.Status.runAudit MyProject.MainChain.config
    ```

4.  Register the executable in `lakefile.lean`:

    ```lean
    lean_exe "myproject-status" where
      root := `MyProject.Scripts.StatusEntry
      supportInterpreter := true
    ```

5.  Run `lake env lean --run MyProject/Scripts/StatusEntry.lean`.  The Python post-processor
    (`ChainAudit/Postprocess/post_process.py`) renders the JSON into the
    full `chain-status/*.md` report set.

## See also

* `ChainAudit.Basic`           -- core types
* `ChainAudit.Reflection`      -- meta-level walkers
* `ChainAudit.Classification`  -- five-way file classification
* `ChainAudit.Audit`           -- invariant checks
* `ChainAudit.Json`            -- JSON encoder
* `ChainAudit.Status`          -- IO drivers
-/
