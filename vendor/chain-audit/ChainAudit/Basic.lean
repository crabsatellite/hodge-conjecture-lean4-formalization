/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Lean

/-!
# `ChainAudit.Basic` -- project-agnostic core types

The reusable, host-project-agnostic core of the chain-audit infrastructure.
Any Lean project that wants the auto-audit reports only needs to provide
a `ProjectConfig` and call `ChainAudit.Status.runAudit`.

This module contains:
* `FileClass` -- five-way classification of source files.
* `ProjectConfig` -- the user-supplied configuration record.
* `Severity` -- audit-finding severity (info / warn / fail).
* `Finding` -- a single audit finding (used by the invariant checker).
* `ClassificationReport` -- the structured output of the auto-derivation.

NO host-project-specific identifiers may appear in this directory.
-/

namespace ChainAudit

/-! ### File classification -/

/-- Classification of a source file in the host project.

Derived from the dependency graph; not declared.  See
`Classification.deriveFileClass` for the precise derivation rules. -/
inductive FileClass
  | /-- Transitively reached from an `endpoints` member, not quarantined. -/
    onChain
  | /-- On-chain AND declares an `axiom` or open `Prop`-content `def`. -/
    cut
  | /-- Listed in `ProjectConfig.quarantine`. -/
    quarantine
  | /-- Not on-chain; standalone tool with a `def main : IO _` or used
        by nothing else.  Auditing / build / utility files. -/
    infra
  | /-- Not on-chain, but explicitly listed in `researchGaps` or
        `researchChains`.  Registered research files are navigation context,
        not orphan debt. -/
    registered
  | /-- Not on-chain, not quarantined, not standalone.  Build warning. -/
    orphan
  deriving DecidableEq, Repr, Inhabited

/-- ASCII rendering of a `FileClass`. -/
def FileClass.toAscii : FileClass → String
  | .onChain    => "on-chain"
  | .cut        => "cut"
  | .quarantine => "quarantine"
  | .infra      => "infra"
  | .registered => "registered"
  | .orphan     => "orphan"

instance : ToString FileClass := ⟨FileClass.toAscii⟩

/-! ### Project configuration -/

/-- A named mathematical gap or residue surfaced by the host project.

This is intentionally lightweight and string-based: many useful gap
statements live in exploratory files that the main audit environment may
not load.  The registry is for report-level navigation, not kernel
checking. -/
structure ResearchGap where
  /-- Stable short identifier, e.g. `"G-step-c"`. -/
  id : String
  /-- Human-readable title. -/
  title : String
  /-- Project-defined status string, e.g. `"open"`, `"reduced"`,
  `"blocked"`, `"dead"`, `"closed"`. -/
  status : String
  /-- Short explanation of the current mathematical surface. -/
  summary : String
  /-- Source files most relevant to the gap. -/
  files : List String := []
  /-- Important declaration names, kept as strings so unloaded modules
  can still be documented. -/
  decls : List String := []
  deriving Inhabited

/-- Optional source-text keyword rule used only by the markdown
post-processor to attach route/gap labels to off-chain files.  The Lean
kernel audit never trusts these labels; they are navigation hints. -/
structure RouteKeywordRule where
  /-- Labels to add when any keyword matches, e.g.
  `"chain:route-a"` or `"gap:G-main"`. -/
  labels : List String := []
  /-- Case-insensitive substrings matched against path, imports, and
  source text. -/
  keywords : List String := []
  deriving Inhabited

/-- A human-maintained research chain or branch.

`ChainAudit` derives the main endpoint closure automatically.  Research
chains record the surrounding proof-engineering topology: active
branches, closed support chains, and dead/quarantined approaches. -/
structure ResearchChain where
  /-- Stable short identifier. -/
  id : String
  /-- Human-readable title. -/
  title : String
  /-- Project-defined kind, e.g. `"main"`, `"support"`, `"active"`,
  `"dead"`. -/
  kind : String
  /-- Project-defined status string. -/
  status : String
  /-- Short explanation of this chain's role. -/
  summary : String
  /-- Source files that make up the chain or branch. -/
  files : List String := []
  /-- Important declaration names, kept as strings for unloaded modules. -/
  entryDecls : List String := []
  /-- Gap ids consumed or attacked by this chain. -/
  gapIds : List String := []
  /-- Other research-chain ids this chain depends on or feeds into. -/
  dependsOn : List String := []
  /-- Optional generated-report attack plan bullets.  Keep these concrete:
  theorem names, provider fields, and proof-success checks. -/
  attackPlan : List String := []
  /-- Optional generated-report success criterion for this route. -/
  successCriterion : String := ""
  deriving Inhabited

/-- Host-project configuration record.

Every Lean project that wants the chain-audit reports provides one of
these and calls `ChainAudit.Status.runAudit`.  Example:

```lean
def MyProject.MainChain.config : ChainAudit.ProjectConfig := {
  projectName := "MyProject"
  rootNamespace := `MyProject
  endpoints := [
    ``MyProject.MainTheorem
  ]
  openAxioms := [
    ``MyProject.OpenHypothesis
  ]
  quarantine := [
    "MyProject/FailedRoute.lean"
  ]
}
``` -/
structure ProjectConfig where
  /-- Display name used in report headers (e.g., "MyProject"). -/
  projectName : String
  /-- Root namespace pattern to scan.  Files whose module name has this
  as a prefix are considered part of the host project; everything else
  (Mathlib, Std, etc.) is treated as the "upstream environment". -/
  rootNamespace : Lean.Name
  /-- Headline target theorem names (sinks of the chain DAG). -/
  endpoints : List Lean.Name
  /-- Axioms the project explicitly KEEPS open by design.  These are
  NOT flagged as drift by the invariant checker. -/
  openAxioms : List Lean.Name := []
  /-- Explicitly quarantined files.  Forward-slash paths relative to the
  Lake project root.  E.g. `"MyProject/Infrastructure/Foo.lean"`. -/
  quarantine : List String := []
  /-- Explicit project infrastructure files.  These are loaded and
  intentionally off-chain, but should not be reported as mathematical
  orphans. -/
  infraFiles : List String := []
  /-- Optional human-maintained registry of open/reduced/blocked/closed
  mathematical gaps.  Rendered by the post-processor. -/
  researchGaps : List ResearchGap := []
  /-- Optional human-maintained registry of main/support/exploration/dead
  research chains.  Rendered by the post-processor. -/
  researchChains : List ResearchChain := []
  /-- Optional primary gap id.  If omitted, the post-processor chooses the
  first open non-dead gap. -/
  primaryGapId : Option String := none
  /-- Optional active route id that should replace the primary gap. -/
  replacementRouteId : Option String := none
  /-- Optional ordered gap ids for attack-card priority.  Missing open gaps
  are appended by generated debt size. -/
  gapPriority : List String := []
  /-- Optional project-specific keyword labels for off-chain route triage.
  This is the escape hatch that keeps `ChainAudit` project-agnostic while
  still letting each host project label its own exploration branches. -/
  routeKeywordRules : List RouteKeywordRule := []
  /-- Output directory for `chain-status/*` reports.  Relative to CWD
  when the executable is invoked. -/
  outputDir : System.FilePath := "chain-status"
  /-- Optional: kernel axioms that are always permitted implicitly.
  Default = `propext` + `Classical.choice` + `Quot.sound`. -/
  kernelAxioms : List Lean.Name := [
    ``propext, ``Classical.choice, ``Quot.sound
  ]
  /-- Optional: extra axiom names always permitted implicitly (e.g.,
  `Lean.ofReduceBool`, `Lean.trustCompiler`, `Native.decide.ax_1_1`). -/
  trustedAxioms : List Lean.Name := []
  deriving Inhabited

/-! ### Audit findings -/

/-- Severity of an audit finding. -/
inductive Severity
  | info  -- informational, never affects exit code
  | warn  -- visible, never affects exit code
  | fail  -- always sets the checker exit code to 1
  deriving DecidableEq, Repr, Inhabited

def Severity.toAscii : Severity → String
  | .info => "INFO"
  | .warn => "WARN"
  | .fail => "FAIL"

instance : ToString Severity := ⟨Severity.toAscii⟩

/-- A single audit finding produced by the invariant checker. -/
structure Finding where
  severity : Severity
  /-- Short rule identifier (e.g., `"I1.new-axiom"`, `"W1.orphan"`). -/
  rule     : String
  /-- Human-readable description. -/
  message  : String
  /-- Optional source location (file:line). -/
  loc      : Option String := none
  deriving Inhabited

/-! ### Classification report -/

/-- Module-level closure information.  One entry per source module under
the project's `rootNamespace`. -/
structure FileEntry where
  /-- Fully-qualified module name (e.g., `MyProject.Infrastructure.Foo`). -/
  module : Lean.Name
  /-- Module name rendered as a forward-slash file path. -/
  path   : String
  /-- Five-way classification. -/
  cls    : FileClass
  /-- Number of non-internal constants defined in this file. -/
  decls  : Nat
  /-- Number of `axiom` declarations in this file. -/
  axioms : Nat
  /-- Names of declarations from this file that fall in the closure of
  the configured endpoints. -/
  closureDecls : List Lean.Name
  deriving Inhabited

/-- One axiom-cut entry. -/
structure Cut where
  name   : Lean.Name
  module : Lean.Name
  path   : String
  /-- Is this cut explicitly whitelisted (open-by-design)? -/
  whitelisted : Bool
  deriving Inhabited

/-- Underscore-prefixed-parameter audit entry. -/
structure UnderscoreEntry where
  decl   : Lean.Name
  module : Lean.Name
  path   : String
  params : List Lean.Name
  deriving Inhabited

/-- Per-endpoint axiom dependency. -/
structure EndpointAxiom where
  endpoint : Lean.Name
  /-- Sorted list of axioms transitively reached. -/
  axioms   : List Lean.Name
  deriving Inhabited

/-- Aggregate report from `ChainAudit.Classification.derive`. -/
structure ClassificationReport where
  cfg          : ProjectConfig
  files        : List FileEntry
  cuts         : List Cut
  underscores  : List UnderscoreEntry
  axiomSets    : List EndpointAxiom
  /-- Direct-import edges for every project file: (importer, [imported]). -/
  importEdges  : List (Lean.Name × List Lean.Name)
  /-- Closure size summaries. -/
  closureConstants : Nat
  closureModules   : Nat
  onChainCount     : Nat
  cutCount         : Nat
  quarantineCount  : Nat
  infraCount       : Nat
  orphanCount      : Nat
  deriving Inhabited

end ChainAudit
