/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Lean
import ChainAudit.Basic

namespace ChainAudit

/-- Local helper: return the name of the module in which a declaration
was defined.  Equivalent to `Lean.Environment.getModuleFor?` (provided
by `importGraph`), but redefined here as a plain function so `ChainAudit`
has no extra dependency AND does not clash with the dot-notation
extension method defined by `importGraph`. -/
def moduleFor? (env : Lean.Environment) (declName : Lean.Name) : Option Lean.Name :=
  match env.getModuleIdxFor? declName with
  | none =>
    if env.constants.map₂.contains declName then
      env.header.mainModule
    else
      none
  | some idx => env.header.moduleNames[idx.toNat]!

end ChainAudit

/-!
# `ChainAudit.Reflection` -- meta-level walkers over `Lean.Environment`

This module is project-agnostic: it accepts a `ChainAudit.ProjectConfig`
and an imported environment, and exposes the primitive walkers used by
the classification pass.

* `transitiveClosure`     -- transitively walk `getUsedConstantsAsSet`.
* `isAxiom`               -- detect `axiomInfo`.
* `moduleNameToPath`      -- module name -> forward-slash relative path.
* `collectUnderscoreParams` -- scan a type expression for `_`-prefixed
                             pi-binders.
* `projectModules`        -- list of modules under the configured root.
* `directImportEdges`     -- direct imports per project module.
* `closureAxioms`         -- subset of a closure that are axioms.
-/

namespace ChainAudit.Reflection

open Lean

/-- Convert a module `Lean.Name` to a forward-slash relative `.lean`
path.  E.g. ``MyProject.Infrastructure.MainChain ⟼
`"MyProject/Infrastructure/MainChain.lean"``. -/
def moduleNameToPath (n : Name) : String :=
  let s := n.toString
  s.replace "." "/" ++ ".lean"

/-- Transitively walk the constants used by `roots`.  Returns the
`NameSet` of all constants reachable via `getUsedConstantsAsSet`.

We do NOT filter `isInternal` here: native-decide-generated axioms
have internal names and we MUST follow them to detect trust weight. -/
partial def transitiveClosure (env : Environment) (roots : List Name) : NameSet := Id.run do
  let mut used : NameSet := {}
  let mut stack : List Name := roots
  while !stack.isEmpty do
    match stack with
    | [] => break
    | n :: rest =>
      stack := rest
      if used.contains n then continue
      used := used.insert n
      match env.find? n with
      | some ci =>
        for u in ci.getUsedConstantsAsSet do
          if !used.contains u then
            stack := u :: stack
      | none => continue
  return used

/-- True if the constant is an `axiom` declaration. -/
def isAxiom (env : Environment) (n : Name) : Bool :=
  match env.find? n with
  | some (.axiomInfo _) => true
  | _ => false

/-- Recursively scan an expression for binders whose user-facing name
begins with `_`.  Used by the underscore-parameter audit. -/
partial def collectUnderscoreParams (e : Expr) : List Name := Id.run do
  let rec aux (e : Expr) (acc : List Name) : List Name :=
    match e with
    | .forallE n _ body _ =>
      let acc' := if n.toString.startsWith "_" then n :: acc else acc
      aux body acc'
    | .lam n _ body _ =>
      let acc' := if n.toString.startsWith "_" then n :: acc else acc
      aux body acc'
    | _ => acc
  return aux e []

/-- True if `mod` is under the configured `rootNamespace`. -/
def isProjectModule (cfg : ProjectConfig) (mod : Name) : Bool :=
  cfg.rootNamespace.isPrefixOf mod

/-- List of module names that belong to the host project. -/
def projectModules (cfg : ProjectConfig) (env : Environment) : Array Name :=
  env.header.moduleNames.filter (isProjectModule cfg)

/-- Direct-import edges for every project module: `(importer, imports)`.

The returned `imports` list is filtered to project modules only (i.e.,
Mathlib / Std / Init are removed) so the import-audit / orphan analysis
operates on the host project's internal graph. -/
def directImportEdges (cfg : ProjectConfig) (env : Environment) : List (Name × List Name) := Id.run do
  let mut result : List (Name × List Name) := []
  for modIdx in List.range env.header.moduleNames.size do
    let modName := env.header.moduleNames[modIdx]!
    if !isProjectModule cfg modName then continue
    let data := env.header.moduleData[modIdx]!
    let imports : List Name :=
      data.imports.toList.map (·.module) |>.filter (isProjectModule cfg)
    result := (modName, imports) :: result
  return result

/-- For each project file, collect the non-internal constants it
defines.  Returns `NameMap` keyed by module name. -/
def constantsPerModule (cfg : ProjectConfig) (env : Environment) : NameMap (List Name) := Id.run do
  let mut m : NameMap (List Name) := {}
  for modIdx in List.range env.header.moduleNames.size do
    let mod := env.header.moduleNames[modIdx]!
    if !isProjectModule cfg mod then continue
    let data := env.header.moduleData[modIdx]!
    let decls := data.constNames.toList.filter (fun n => !n.isInternal)
    m := m.insert mod decls
  return m

/-- Filter a constant set to the subset that are axioms.

We INCLUDE internal-name axioms (e.g.,
`Foo._native.native_decide.ax_1_1`) because those carry real trust
weight even though `Name.isInternal` returns true for them. -/
def closureAxioms (env : Environment) (closure : NameSet) : List Name :=
  closure.toList.foldl (init := []) fun acc n =>
    if isAxiom env n then n :: acc else acc

/-- Detect a "Prop-valued definition introducing new content" in a
project file.  Heuristic: `def F : Prop := body` where the body is not
already a kernel-trivial composition (e.g., not just `True`, `False`,
or a reference to an existing closure constant).

For Phase 1 we use the most basic rule: any `def F : ...` whose type is
syntactically `Prop` and which is NOT in the configured `openAxioms`
whitelist, and is in a file classified `onChain`, would be flagged as a
soft warning ("new propositional def in on-chain file").  Conservative
to avoid false positives.  Refinements TBD. -/
partial def returnsProp (e : Expr) : Bool :=
  match e.consumeMData with
  | .forallE _ _ body _ => returnsProp body
  | .sort .zero => true
  | _ => false

def isOpenPropDef (env : Environment) (n : Name) : Bool :=
  match env.find? n with
  | some (.defnInfo info) =>
    -- Check whether the definition returns `Prop`, allowing parameters:
    -- `def F (x : α) : Prop := ...`.
    returnsProp info.type
  | _ => false

/-- For each endpoint, compute the list of axioms transitively reached. -/
def perEndpointAxioms (env : Environment) (endpoints : List Name) :
    List (Name × List Name) := Id.run do
  let mut result : List (Name × List Name) := []
  for ep in endpoints do
    let closure := transitiveClosure env [ep]
    let axs := closureAxioms env closure
    result := (ep, axs.eraseDups.mergeSort (·.toString < ·.toString)) :: result
  return result.reverse

/-- Convert a forward-slash file path (relative to project root) to its
module `Name`.  E.g. `"MyProject/Infrastructure/Foo.lean"` ->
``MyProject.Infrastructure.Foo``.  Mirrors `Status.pathToModule` so the
on-disk-orphan walk and the disk scanner agree on normalization. -/
def diskPathToModule (path : String) : Name :=
  let stem :=
    if path.endsWith ".lean" then
      String.mk (path.toList.take (path.toList.length - 5))
    else path
  let normalized := stem.replace "\\" "/"
  normalized.replace "/" "." |>.toName

/-- On-disk-but-unloaded files: paths that exist in the source tree but
whose module is NOT present in the imported environment (i.e., not
transitively imported by the audit entry point).

These are the strongest quarantine candidates -- the file exists but is
not even imported anywhere on the chain.  We EXCLUDE paths whose module
is already in `quarantineMods` (those are accounted for as quarantine,
not as a fresh orphan finding).

`env.constants.map₂` only contains decls from imported modules, so a
module that was never imported has no entry; we test membership via
`moduleFor?` over the module's own name is not reliable, so instead we
test against the set of imported project module names supplied by the
caller (`loadedMods`).

We SKIP files under a `/Scripts/` directory segment: by Lake convention
those are standalone `lake env lean --run` entry points (test / audit
scripts), not chain files, and would otherwise dominate the report with
false positives. -/
def onDiskOrphans (diskFiles : Array String) (loadedMods : NameSet)
    (quarantineMods : NameSet) : List String := Id.run do
  let mut result : List String := []
  for p in diskFiles do
    -- Skip standalone script entry points (Lake convention).
    if (p.splitOn "/Scripts/").length > 1 then continue
    let m := diskPathToModule p
    if loadedMods.contains m then continue
    if quarantineMods.contains m then continue
    result := p :: result
  return result.reverse

end ChainAudit.Reflection
