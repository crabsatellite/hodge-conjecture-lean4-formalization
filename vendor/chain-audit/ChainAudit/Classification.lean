/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit.Reflection

set_option linter.unusedVariables false

/-!
# `ChainAudit.Classification` -- derive the five-way file classification

Given an imported `Environment` and a `ProjectConfig`, compute the
`ClassificationReport`.  This module is project-agnostic.

Derivation rules (precedence: top to bottom):

1. `cls = quarantine`   if the file path is in `cfg.quarantine`.
2. `cls = onChain` (and `cls = cut` if it declares an axiom)
                        if any declaration in the file is in the closure
                        of `cfg.endpoints`.
3. `cls = infra`        if the file contains a `def main : IO _` (i.e.,
                        it is a `lake exe` entry point) or has zero
                        non-internal declarations consumed by anything
                        else in the project.
4. `cls = registered`   if the file is explicitly listed in
                        `cfg.researchGaps` or `cfg.researchChains`.
5. `cls = orphan`       otherwise.
-/

namespace ChainAudit.Classification

open Lean ChainAudit ChainAudit.Reflection

/-! ### Quarantine path normalization -/

/-- Convert a quarantine `String` path (e.g.
`"MyProject/Infrastructure/Foo.lean"`) to the corresponding module
`Name`.  Trailing `.lean` is stripped; remaining `/` become `.`. -/
def pathToModuleName (path : String) : Name :=
  let stem :=
    if path.endsWith ".lean" then
      String.mk (path.toList.take (path.toList.length - 5))
    else path
  stem.replace "/" "." |>.toName

/-- Quarantine module names from `cfg.quarantine`. -/
def quarantineModules (cfg : ProjectConfig) : NameSet :=
  cfg.quarantine.foldl (init := {}) fun s p => s.insert (pathToModuleName p)

/-- Explicit infrastructure module names from `cfg.infraFiles`. -/
def infraModules (cfg : ProjectConfig) : NameSet :=
  cfg.infraFiles.foldl (init := {}) fun s p => s.insert (pathToModuleName p)

/-- Explicit research route/gap module names from the host project config.

These files are allowed to be off the endpoint closure while the proof route is
still being explored.  They should remain visible in reports, but they are not
orphan debt. -/
def registeredResearchModules (cfg : ProjectConfig) : NameSet :=
  let fromChains :=
    cfg.researchChains.foldl (init := {}) fun s c =>
      c.files.foldl (init := s) fun s p => s.insert (pathToModuleName p)
  cfg.researchGaps.foldl (init := fromChains) fun s g =>
    g.files.foldl (init := s) fun s p => s.insert (pathToModuleName p)

/-! ### Closure computation -/

/-- The set of modules that contain at least one declaration in the
transitive closure of `cfg.endpoints`. -/
def closureModuleSet (env : Environment) (closure : NameSet) : NameSet := Id.run do
  let mut mods : NameSet := {}
  for n in closure do
    match ChainAudit.moduleFor? env n with
    | some m => mods := mods.insert m
    | none => continue
  return mods

/-! ### Infra detection -/

/-- True if the module declares a `main : IO _` (i.e., it's a script
entry point). -/
def declaresMain (env : Environment) (mod : Name) (allDecls : List Name) : Bool := Id.run do
  for d in allDecls do
    -- Look for a constant named `main` (possibly under the module's namespace).
    if d.getString! == "main" then
      return true
    -- Also handle `Foo.main` where Foo is the module name.
    if d == mod ++ `main then
      return true
  return false

/-- True if NO project module imports `mod` AND `mod` does not appear in
the closure.  Used to identify standalone infra files. -/
def isStandalone (mod : Name) (importEdges : List (Name × List Name)) : Bool :=
  importEdges.all (fun (_, imps) => !imps.contains mod)

/-! ### Closure-decl subset per module -/

/-- For each module, the subset of its declarations that fall in the
endpoint closure. -/
def closureDeclsPerModule (env : Environment) (closure : NameSet)
    (perModule : NameMap (List Name)) : NameMap (List Name) := Id.run do
  let mut m : NameMap (List Name) := {}
  for (mod, decls) in perModule.toList do
    let onChain := decls.filter (fun d => closure.contains d)
    if !onChain.isEmpty then
      m := m.insert mod onChain
  return m

/-! ### Main derivation -/

/-- Derive the full `ClassificationReport` from an imported environment
and a project config.  All five-way classifications are computed here. -/
def derive (env : Environment) (cfg : ProjectConfig) : ClassificationReport := Id.run do
  let closure := transitiveClosure env cfg.endpoints
  let qModSet := quarantineModules cfg
  let infraModSet := infraModules cfg
  let registeredModSet := registeredResearchModules cfg
  let closureMods := closureModuleSet env closure
  let perModule := constantsPerModule cfg env
  let closureMap := closureDeclsPerModule env closure perModule
  let importEdges := directImportEdges cfg env
  -- Aggregate per-file entries.
  let mut files : List FileEntry := []
  -- Union: project modules in env + explicitly quarantined modules on
  -- disk (the latter may not be loaded at all).
  let envMods := projectModules cfg env
  let envModSet : NameSet :=
    envMods.foldl (init := {}) fun s n => s.insert n
  let extraQuarantineMods : List Name :=
    cfg.quarantine.foldl (init := []) fun acc p =>
      let m := pathToModuleName p
      if envModSet.contains m then acc else m :: acc
  let allProjectMods : Array Name :=
    envMods ++ extraQuarantineMods.toArray
  for mod in allProjectMods do
    let decls := (perModule.find? mod).getD []
    let axCount := decls.foldl (init := 0) fun n d =>
      if isAxiom env d then n + 1 else n
    let cdecls := (closureMap.find? mod).getD []
    -- Determine classification.
    let cls : FileClass :=
      if qModSet.contains mod then .quarantine
      else if !cdecls.isEmpty then
        if axCount > 0 then .cut else .onChain
      else if infraModSet.contains mod then .infra
      else if declaresMain env mod decls then .infra
      else if registeredModSet.contains mod then .registered
      else if isStandalone mod importEdges then .infra
      else .orphan
    files := {
      module := mod
      path := moduleNameToPath mod
      cls := cls
      decls := decls.length
      axioms := axCount
      closureDecls := cdecls
    } :: files
  -- Derive cuts: every axiom in the closure (also flag whitelisted vs not).
  -- Whitelist = explicit open axioms + always-trusted kernel axioms +
  -- project-extra trusted axioms (e.g., `Lean.ofReduceBool`) + the
  -- auto-generated `_native.native_decide.ax_*` family (permitted by
  -- standard `native_decide` trust weight).
  let whitelist : List Name :=
    cfg.openAxioms ++ cfg.kernelAxioms ++ cfg.trustedAxioms
  let openSet : NameSet := whitelist.foldl (init := {}) fun s n => s.insert n
  let isWhitelisted (ax : Name) : Bool :=
    openSet.contains ax ||
    -- Heuristic: native_decide auto-axioms.
    (let s := ax.toString
     s.endsWith "ax_1_1" && (s.splitOn "_native.native_decide").length > 1)
  let closureAxs := closureAxioms env closure
  let cuts : List Cut := closureAxs.map fun ax =>
    let mod := (ChainAudit.moduleFor? env ax).getD Name.anonymous
    { name := ax
      module := mod
      path := moduleNameToPath mod
      whitelisted := isWhitelisted ax }
  -- Underscore audit.
  let mut underscores : List UnderscoreEntry := []
  for (mod, decls) in perModule.toList do
    for n in decls do
      match env.find? n with
      | none => continue
      | some ci =>
        match ci with
        | .thmInfo info =>
          let ups := collectUnderscoreParams info.type
          if !ups.isEmpty then
            underscores := {
              decl := n
              module := mod
              path := moduleNameToPath mod
              params := ups
            } :: underscores
        | .axiomInfo info =>
          let ups := collectUnderscoreParams info.type
          if !ups.isEmpty then
            underscores := {
              decl := n
              module := mod
              path := moduleNameToPath mod
              params := ups
            } :: underscores
        | _ => continue
  -- Per-endpoint axiom sets.
  let axiomSets : List EndpointAxiom :=
    (perEndpointAxioms env cfg.endpoints).map fun (ep, axs) =>
      { endpoint := ep, axioms := axs }
  -- Counts.
  let onChainCount := files.foldl (init := 0) fun n f =>
    if f.cls == .onChain then n + 1 else n
  let cutCount := files.foldl (init := 0) fun n f =>
    if f.cls == .cut then n + 1 else n
  let quarantineCount := files.foldl (init := 0) fun n f =>
    if f.cls == .quarantine then n + 1 else n
  let infraCount := files.foldl (init := 0) fun n f =>
    if f.cls == .infra then n + 1 else n
  let orphanCount := files.foldl (init := 0) fun n f =>
    if f.cls == .orphan then n + 1 else n
  return {
    cfg := cfg
    files := files
    cuts := cuts
    underscores := underscores
    axiomSets := axiomSets
    importEdges := importEdges
    closureConstants := closure.size
    closureModules := closureMods.size
    onChainCount := onChainCount
    cutCount := cutCount
    quarantineCount := quarantineCount
    infraCount := infraCount
    orphanCount := orphanCount
  }

end ChainAudit.Classification
