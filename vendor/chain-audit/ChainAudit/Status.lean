/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit.Json

/-!
# `ChainAudit.Status` -- the host-project entry points

Two driver functions:

* `runAudit cfg`  -- emit `chain-status/raw.json` (semantic walk + findings).
                     Always succeeds; reporting only.
* `runCheck cfg`  -- run invariants, print findings, exit non-zero on any
                     hard-failure.

Both drivers IMPORT the module(s) referenced in `cfg.endpoints` so that
the kernel environment contains the endpoint declarations.

## Usage from a host project

```lean
-- file: MyProject/Scripts/StatusEntry.lean
import MyProject.MainChain

def main : IO UInt32 := ChainAudit.Status.runAudit MyProject.MainChain.config
```

```lean
-- lakefile.lean addition
lean_exe "myproject-status" where
  root := `MyProject.Scripts.StatusEntry
  supportInterpreter := true
```

Then: `lake env lean --run MyProject/Scripts/StatusEntry.lean`.
-/

namespace ChainAudit.Status

open Lean ChainAudit

/-! ### Disk scan for project `.lean` files -/

/-- Local list concatenation map, kept here to avoid depending on optional
`List.flatMap`/`List.bind` imports in host projects. -/
def concatMapList {α β : Type} : List α → (α → List β) → List β
  | [], _ => []
  | x :: xs, f => f x ++ concatMapList xs f

/-- Convert a forward-slash file path (relative to project root) to its
module `Name`.  E.g. `"MyProject/Infrastructure/Foo.lean"` ->
``MyProject.Infrastructure.Foo``. -/
def pathToModule (path : String) : Name :=
  let stem :=
    if path.endsWith ".lean" then
      String.mk (path.toList.take (path.toList.length - 5))
    else
      path
  let normalized :=
    -- Normalise OS separators to forward slashes.
    stem.replace "\\" "/"
  normalized.replace "/" "." |>.toName

/-- Convert a module `Name` to its conventional source path. -/
def moduleToPath (mod : Name) : String :=
  mod.toString.replace "." "/" ++ ".lean"

/-- Recursively walk `dir`, returning every `.lean` file path RELATIVE
to `root`, using forward slashes.

`root` should equal the initial value of `dir` (used to compute the
relative path).  We use `System.FilePath` operations so the result is
platform-portable. -/
partial def listLeanFiles (root : System.FilePath) (dir : System.FilePath) :
    IO (Array String) := do
  let mut result : Array String := #[]
  let entries ← try dir.readDir catch _ => pure #[]
  for e in entries do
    let p := e.path
    let isDir ← p.isDir
    if isDir then
      result := result ++ (← listLeanFiles root p)
    else if p.extension == some "lean" then
      -- Compute the path relative to `root`.
      let pStr := p.toString
      let rStr := root.toString
      let rel :=
        if pStr.startsWith rStr then
          let raw := pStr.drop rStr.length
          -- Strip leading separator if present.
          if raw.startsWith "/" || raw.startsWith "\\" then
            raw.drop 1
          else raw
        else pStr
      -- Normalise to forward slashes.
      result := result.push (rel.replace "\\" "/")
  return result

/-- For each project root (`cfg.rootNamespace`), discover its source
directory and list every `.lean` file on disk.  We assume the root
namespace's first component is the directory name (Lake convention).

E.g. `cfg.rootNamespace = `MyProject`  ->  scan `MyProject/`.
-/
def diskFiles (cfg : ProjectConfig) : IO (Array String) := do
  let topDir : System.FilePath :=
    System.FilePath.mk cfg.rootNamespace.getRoot.toString
  -- Also include the top-level `<root>.lean` aggregator if present.
  let aggregator := topDir.toString ++ ".lean"
  let mut result := #[]
  if ← System.FilePath.pathExists topDir then
    result := ← listLeanFiles "." topDir
  if ← System.FilePath.pathExists (System.FilePath.mk aggregator) then
    result := result.push aggregator
  return result.qsort (· < ·)

/-- Candidate `.olean` paths that Lake may produce for a host module.

Lean 4.16 uses `.lake/build/lib/<Module>.olean`; newer releases such as
Lean 4.30 use `.lake/build/lib/lean/<Module>.olean`. The audit drivers
probe both so the same ChainAudit package can be shared by projects on
different Lean versions. -/
def oleanPathCandidates (mod : Name) : List System.FilePath :=
  let rel := mod.toString.replace "." "/" ++ ".olean"
  [
    System.FilePath.mk (".lake/build/lib/" ++ rel),
    System.FilePath.mk (".lake/build/lib/lean/" ++ rel)
  ]

/-- True if a `.olean` artifact exists for `mod`. -/
def hasOlean (mod : Name) : IO Bool := do
  for p in oleanPathCandidates mod do
    if (← System.FilePath.pathExists p) then
      return true
  return false

/-- Lightweight substring check kept local to avoid extra dependencies. -/
def stringContainsSubstr (s needle : String) : Bool :=
  (s.splitOn needle).length > 1

/-- Dead/quarantined research routes are report taxonomy, not automatic
import targets. Loading them can pull stale or intentionally false branches
back into the live audit environment. -/
def isDeadishStatus (s : String) : Bool :=
  stringContainsSubstr s "dead" || stringContainsSubstr s "quarantined"

def shouldAutoImportResearchChain (c : ResearchChain) : Bool :=
  c.kind != "dead" && !isDeadishStatus c.status

def shouldAutoImportResearchGap (g : ResearchGap) : Bool :=
  !isDeadishStatus g.status

/-- Compute the imports needed so that every endpoint resolves.

Strategy: try multiple import candidates and add any with a `.olean`:

1.  Conventional `MainChain` modules:
    * `<root>.MainChain`
    * `<root>.Infrastructure.MainChain`
2.  For each endpoint name `A.B.C.foo`, walk parent prefixes
    `A.B.C`, `A.B`, `A` and add any with a built `.olean`.

This lets the audit reach endpoints whose enclosing module is NOT
transitively imported by the project's main-chain module.

We intentionally do NOT import the project root aggregator here.  In
research repos the root aggregator often re-exports historical or orphan
files; loading it would let stale off-chain imports break the audit of the
actual main chain. -/
def importsForEndpoints (cfg : ProjectConfig) : IO (Array Import) := do
  let mut acc : Array Import := #[]
  let mut seen : NameSet := {}
  let tryAdd (m : Name) (acc : Array Import) (seen : NameSet) :
      IO (Array Import × NameSet) := do
    if seen.contains m then return (acc, seen)
    let seen' := seen.insert m
    if (← hasOlean m) then return (acc.push {module := m}, seen')
    else return (acc, seen')
  -- (1) Conventional MainChain modules.
  let conventional : List Name := [
    cfg.rootNamespace ++ `MainChain,
    cfg.rootNamespace ++ `Infrastructure ++ `MainChain
  ]
  for m in conventional do
    let (a, s) ← tryAdd m acc seen
    acc := a; seen := s
  let skipAutomaticParentImport (m : Name) : Bool :=
    m == cfg.rootNamespace || cfg.infraFiles.contains (moduleToPath m)
  -- (2) Parent prefixes of every endpoint and registered research
  -- declaration.  Research declarations are human-maintained branch
  -- anchors; when their modules already have `.olean`s, loading them
  -- makes branch files visible to the same orphan / axiom / underscore
  -- audits as the main chain. Dead/quarantined route declarations are
  -- intentionally skipped: the generated reports still list them from the
  -- taxonomy, but they must not be re-imported into the live environment.
  let registeredDecls : List Name :=
    concatMapList (cfg.researchChains.filter shouldAutoImportResearchChain)
      (fun c => c.entryDecls.map String.toName) ++
    concatMapList (cfg.researchGaps.filter shouldAutoImportResearchGap)
      (fun g => g.decls.map String.toName)
  for ep in cfg.endpoints ++ registeredDecls do
    let mut p := ep.getPrefix
    while !p.isAnonymous && cfg.rootNamespace.isPrefixOf p do
      if !skipAutomaticParentImport p then
        let (a, s) ← tryAdd p acc seen
        acc := a; seen := s
      p := p.getPrefix
  -- (3) Registered research files.  This is best-effort: files without
  -- built `.olean`s remain visible in the disk inventory and report as
  -- on-disk-unloaded instead of breaking the audit. Dead/quarantined route
  -- files are skipped here for the same reason as declarations above.
  let registeredFiles : List String :=
    concatMapList (cfg.researchChains.filter shouldAutoImportResearchChain)
      (fun c => c.files) ++
    concatMapList (cfg.researchGaps.filter shouldAutoImportResearchGap)
      (fun g => g.files)
  for p in registeredFiles do
    let (a, s) ← tryAdd (pathToModule p) acc seen
    acc := a; seen := s
  return acc

/-- Emit the JSON report to `cfg.outputDir / "raw.json"`.  Returns 0
on success; non-zero only on IO failure. -/
def runAuditWithEnv (env : Environment) (cfg : ProjectConfig) : IO UInt32 := do
  let report := Classification.derive env cfg
  let disk ← diskFiles cfg
  let findings := Audit.runAllWithDisk env report disk
  let json := Json.encode report findings disk
  IO.FS.createDirAll cfg.outputDir
  let outPath := cfg.outputDir / "raw.json"
  IO.FS.writeFile outPath json
  IO.println s!"[{cfg.projectName}] wrote {outPath} ({json.length} bytes)"
  IO.println s!"  closure constants: {report.closureConstants}"
  IO.println s!"  closure modules:   {report.closureModules}"
  IO.println s!"  on-chain:    {report.onChainCount}"
  IO.println s!"  cut:         {report.cutCount}"
  IO.println s!"  quarantine:  {report.quarantineCount}"
  IO.println s!"  infra:       {report.infraCount}"
  IO.println s!"  orphan:      {report.orphanCount}"
  IO.println s!"  disk files:  {disk.size}"
  IO.println s!"  findings:    {findings.length} (fail={findings.filter (·.severity == .fail) |>.length})"
  return 0

/-- Build the import list.  We load conventional main-chain modules plus any
parent-module of every endpoint that has a `.olean` (so endpoints whose
enclosing module is not in the main-chain module still resolve).

Orphan files that aren't transitively imported by these WILL still
appear in the disk-file inventory (so the user sees them as
"on-disk-unloaded"), but their declarations won't be loaded and
therefore won't be inspected for declaration-level checks such as W5/W6/W7.

Rationale: trying to load every orphan `.lean` from disk fails when
orphan files have stale dependencies or import-graph drift; importing the
project root aggregator can have the same problem when that aggregator still
re-exports orphan files. -/
def fullImports (cfg : ProjectConfig) : IO (Array Import) :=
  importsForEndpoints cfg

unsafe def runAuditUnsafe (cfg : ProjectConfig) : IO UInt32 := do
  initSearchPath (← findSysroot)
  let imps ← fullImports cfg
  Lean.withImportModules imps (opts := {})
    (trustLevel := 1024) fun env =>
    runAuditWithEnv env cfg

@[implemented_by runAuditUnsafe]
def runAudit (cfg : ProjectConfig) : IO UInt32 := pure 0

/-- Run all invariant checks and exit non-zero on any hard failure.
Always also writes the JSON report so the user has a snapshot. -/
def runCheckWithEnv (env : Environment) (cfg : ProjectConfig) : IO UInt32 := do
  let report := Classification.derive env cfg
  let disk ← diskFiles cfg
  let findings := Audit.runAllWithDisk env report disk
  -- Always rewrite the JSON snapshot.
  let json := Json.encode report findings disk
  IO.FS.createDirAll cfg.outputDir
  IO.FS.writeFile (cfg.outputDir / "raw.json") json
  -- Print findings.
  IO.println s!"[{cfg.projectName}] invariant check"
  IO.println s!"  total findings: {findings.length}"
  let failures := findings.filter (·.severity == .fail)
  let warnings := findings.filter (·.severity == .warn)
  IO.println s!"  failures: {failures.length}"
  IO.println s!"  warnings: {warnings.length}"
  let printFinding (f : Finding) : IO Unit := do
    let header := s!"  [{f.severity}] {f.rule}"
    let suffix := match f.loc with
      | some l => s!"  ({l})"
      | none => ""
    IO.println (header ++ ": " ++ f.message ++ suffix)
  for f in failures do
    printFinding f
  let maxWarningsToPrint := 200
  let mut printedWarnings := 0
  for f in warnings do
    if printedWarnings < maxWarningsToPrint then
      printFinding f
      printedWarnings := printedWarnings + 1
  if warnings.length > printedWarnings then
    IO.println s!"  ... suppressed {warnings.length - printedWarnings} warning finding(s); see {cfg.outputDir / "raw.json"} for the full report."
  if !failures.isEmpty then
    IO.println s!"FAIL: {failures.length} hard-failure finding(s)."
    return 1
  IO.println "OK: no hard-failure findings."
  return 0

unsafe def runCheckUnsafe (cfg : ProjectConfig) : IO UInt32 := do
  initSearchPath (← findSysroot)
  let imps ← fullImports cfg
  Lean.withImportModules imps (opts := {})
    (trustLevel := 1024) fun env =>
    runCheckWithEnv env cfg

@[implemented_by runCheckUnsafe]
def runCheck (cfg : ProjectConfig) : IO UInt32 := pure 0

end ChainAudit.Status
