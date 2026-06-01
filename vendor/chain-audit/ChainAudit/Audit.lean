/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit.Classification

set_option linter.unusedVariables false

/-!
# `ChainAudit.Audit` -- invariant checking (`lake exe *-check`)

Hard-failure invariants:

* `I1` -- no `axiom` in the closure of `cfg.endpoints` outside the
  whitelist (`cfg.openAxioms ++ cfg.kernelAxioms ++ cfg.trustedAxioms`).
* `I2` -- reserved.
* `I3` -- quarantine is unidirectional: a file in `cfg.quarantine` may
  not be imported by any `onChain` or `cut` file.
* `I4` -- no theorem in an `onChain` or `cut` file may take a premise
  whose type is syntactically identical to the theorem conclusion.
  This catches the direct `h : Goal |- Goal` assumption-as-goal trick.
* `I5` -- no vacuous `def : Prop := True/False` placeholder may appear
  in an `onChain` or `cut` file.
* `I6` -- no theorem whose final proposition is literally `True`,
  `Unit`, or `PUnit` may appear in an `onChain` or `cut` file.

Soft-warning invariants:

* `W1` -- orphan file (not on-chain, not quarantined, not standalone).
* `W2` -- compile-prune candidate in an on-chain file: a directly-imported
  module's project import-closure contributes no declaration to the importer's
  endpoint-reached declarations.  This is a conservative static signal, not a
  proof of removability; theorem proof/elaboration dependencies may still make
  the import required, so W2 edits must be compile-verified.
* `W3` -- on-disk-orphan: a `.lean` file exists in the source tree but is
  NOT loaded into the audit environment (never imported by the chain) AND
  is not in the quarantine registry.  These are the strongest quarantine
  candidates -- the file exists but isn't imported anywhere on the chain.
* `W4` -- unused import between orphan files: an orphan file imports another
  orphan file, but the importer consumes no declarations from that imported
  module's project import-closure.  These are concrete import-deletion
  candidates, still requiring compile verification before removal because an
  import may be a downstream re-export carrier.
* `W5` -- Prop-valued definitions and suspicious strengthened/hypothesis
  surfaces.  These are not automatically wrong, but they are the common way
  an exploration branch hides new mathematical content without declaring an
  axiom.
* `W7` -- `_`-prefixed parameters in theorem/axiom surfaces.  This catches
  the `_h_atom` deception pattern as review debt, while avoiding hard-failing
  projects that use `_h` names as ordinary binder style.
-/

namespace ChainAudit.Audit

open Lean ChainAudit ChainAudit.Reflection ChainAudit.Classification

/-! ### I1 -- forbidden axioms -/

/-- Built-in pattern: native-decide auto-generated axioms are
permitted (they are part of the standard `native_decide` trust
weight, and the user accepts them by using `native_decide`). -/
def isNativeDecideAxiom (n : Lean.Name) : Bool :=
  -- Pattern: `<...>._native.native_decide.ax_<...>`
  let s := n.toString
  s.endsWith "ax_1_1" && (s.splitOn "_native.native_decide").length > 1

def checkI1 (env : Environment) (report : ClassificationReport) : List Finding := Id.run do
  let cfg := report.cfg
  let whitelist : NameSet :=
    (cfg.openAxioms ++ cfg.kernelAxioms ++ cfg.trustedAxioms).foldl
      (init := {}) fun s n => s.insert n
  let mut findings : List Finding := []
  for cut in report.cuts do
    if whitelist.contains cut.name then continue
    if isNativeDecideAxiom cut.name then continue
    findings := {
      severity := .fail
      rule := "I1.forbidden-axiom"
      message := s!"axiom `{cut.name}` reached from an endpoint but not whitelisted in `openAxioms`"
      loc := some cut.path
    } :: findings
  return findings

/-! ### I2 -- underscore params in on-chain -/

def checkI2 (report : ClassificationReport) : List Finding := Id.run do
  -- Build a set of on-chain / cut modules.
  let chainMods : NameSet :=
    report.files.foldl (init := {}) fun s f =>
      if f.cls == .onChain || f.cls == .cut then s.insert f.module else s
  let mut findings : List Finding := []
  for u in report.underscores do
    if chainMods.contains u.module then
      let paramList := ",".intercalate (u.params.map (·.toString))
      findings := {
        severity := .warn
        rule := "W7.underscore-param"
        message := s!"on-chain theorem/axiom `{u.decl}` has underscore-prefixed parameters: [{paramList}]"
        loc := some u.path
      } :: findings
  return findings

/-! ### I3 -- quarantine imported by chain -/

def checkI3 (report : ClassificationReport) : List Finding := Id.run do
  -- Build a set of quarantine modules.
  let qMods : NameSet :=
    report.files.foldl (init := {}) fun s f =>
      if f.cls == .quarantine then s.insert f.module else s
  let chainMods : NameSet :=
    report.files.foldl (init := {}) fun s f =>
      if f.cls == .onChain || f.cls == .cut then s.insert f.module else s
  let mut findings : List Finding := []
  for (importer, imports) in report.importEdges do
    if !chainMods.contains importer then continue
    for imp in imports do
      if qMods.contains imp then
        findings := {
          severity := .fail
          rule := "I3.quarantine-imported"
          message := s!"chain module `{importer}` imports quarantine module `{imp}`"
          loc := some (moduleNameToPath importer)
        } :: findings
  return findings

/-! ### I4/I5/W5 -- proposition-surface trick checks -/

partial def forallDomainsAndBody (e : Expr) : List Expr × Expr :=
  match e with
  | .forallE _ dom body _ =>
    let (domains, finalBody) := forallDomainsAndBody body
    (dom :: domains, finalBody)
  | _ => ([], e)

def theoremHasAssumptionAsGoal (ci : ConstantInfo) : Bool :=
  match ci with
  | .thmInfo info =>
    let (domains, finalBody) := forallDomainsAndBody info.type
    let total := domains.length
    let rec go (i : Nat) : List Expr → Bool
      | [] => false
      | dom :: rest =>
        let shiftedDom := dom.consumeMData.liftLooseBVars 0 (total - i)
        (shiftedDom == finalBody.consumeMData) || go (i + 1) rest
    go 0 domains
  | _ => false

def isPropDef (env : Environment) (n : Name) : Bool :=
  isOpenPropDef env n

def isConstHead (e : Expr) (n : Name) : Bool :=
  match e.consumeMData.getAppFn with
  | .const c _ => c == n
  | _ => false

partial def exprContainsConst (e : Expr) (target : Name) : Bool :=
  let e := e.consumeMData
  isConstHead e target ||
    match e with
    | .forallE _ d b _ => exprContainsConst d target || exprContainsConst b target
    | .lam _ d b _ => exprContainsConst d target || exprContainsConst b target
    | .letE _ t v b _ =>
      exprContainsConst t target || exprContainsConst v target || exprContainsConst b target
    | .app f a => exprContainsConst f target || exprContainsConst a target
    | .mdata _ b => exprContainsConst b target
    | .proj _ _ b => exprContainsConst b target
    | _ => false

partial def stripValueBinders (e : Expr) : Expr :=
  match e.consumeMData with
  | .lam _ _ body _ => stripValueBinders body
  | other => other

def isVacuousPropDef (env : Environment) (n : Name) : Bool :=
  match env.find? n with
  | some (.defnInfo info) =>
    let body := stripValueBinders info.value
    isPropDef env n &&
      (isConstHead body ``True ||
       isConstHead body ``False ||
       isConstHead body ``PUnit ||
       isConstHead body ``Unit)
  | _ => false

def stringContainsSubstr (s needle : String) : Bool :=
  (s.splitOn needle).length > 1

def hasSuspiciousPropName (n : Name) : Bool :=
  let s := n.toString
  [
    "Hypothesis", "hypothesis",
    "Statement", "statement",
    "Strengthened", "strengthened",
    "Arbitrary", "arbitrary",
    "Refined", "refined",
    "as_input", "AsInput",
    "placeholder", "Placeholder",
    "NotEstablished", "not_established",
    "Refusal", "refusal",
    "Certificate", "certificate",
    "Gap", "gap",
    "Blocked", "blocked",
    "Pending", "pending",
    "KILL", "Kill", "kill",
    "vacuous", "Vacuous"
  ].any (fun token => stringContainsSubstr s token)

def isVacuousTheorem (ci : ConstantInfo) : Bool :=
  match ci with
  | .thmInfo info =>
    let (_, finalBody) := forallDomainsAndBody info.type
    let body := finalBody.consumeMData
    isConstHead body ``True ||
      isConstHead body ``PUnit ||
      isConstHead body ``Unit
  | _ => false

def isVacuousPremiseType (e : Expr) : Bool :=
  let e := e.consumeMData
  isConstHead e ``True ||
    isConstHead e ``False ||
    isConstHead e ``PUnit ||
    isConstHead e ``Unit

def hasVacuousPremise (ci : ConstantInfo) : Bool :=
  let type? :=
    match ci with
    | .thmInfo info => some info.type
    | .axiomInfo info => some info.type
    | _ => none
  match type? with
  | some type =>
    let (domains, _) := forallDomainsAndBody type
    domains.any isVacuousPremiseType
  | none => false

def checkI4I5W5 (env : Environment) (report : ClassificationReport) :
    List Finding := Id.run do
  let classMap : NameMap FileClass :=
    report.files.foldl (init := {}) fun m f => m.insert f.module f.cls
  let protectedModule (mod : Name) : Bool :=
    match classMap.find? mod with
    | some .onChain | some .cut => true
    | _ => false
  let auditedModule (mod : Name) : Bool :=
    match classMap.find? mod with
    | some .onChain | some .cut | some .orphan => true
    | _ => false
  let perModule := constantsPerModule report.cfg env
  let mut findings : List Finding := []
  for (mod, decls) in perModule.toList do
    if !isProjectModule report.cfg mod then continue
    let path := moduleNameToPath mod
    for n in decls do
      let some ci := env.find? n | continue
      if protectedModule mod && theoremHasAssumptionAsGoal ci then
        findings := {
          severity := .fail
          rule := "I4.assumption-as-goal"
          message := s!"on-chain theorem `{n}` has a premise syntactically identical to its conclusion"
          loc := some path
        } :: findings
      if protectedModule mod && isVacuousPropDef env n then
        findings := {
          severity := .fail
          rule := "I5.vacuous-prop-def"
          message := s!"on-chain Prop definition `{n}` is a vacuous True/False/Unit-style placeholder"
          loc := some path
        } :: findings
      if protectedModule mod && isVacuousTheorem ci then
        findings := {
          severity := .fail
          rule := "I6.vacuous-theorem"
          message := s!"on-chain theorem `{n}` has a literal True/Unit-style conclusion"
          loc := some path
        } :: findings
      if protectedModule mod && hasVacuousPremise ci then
        findings := {
          severity := .fail
          rule := "I7.vacuous-premise"
          message := s!"on-chain theorem/axiom `{n}` has a literal True/False/Unit-style premise"
          loc := some path
        } :: findings
      else if auditedModule mod && hasVacuousPremise ci then
        findings := {
          severity := .warn
          rule := "W8.vacuous-premise"
          message := s!"theorem/axiom `{n}` has a literal True/False/Unit-style premise; verify it is not a vacuous conditional wrapper"
          loc := some path
        } :: findings
      if auditedModule mod && isPropDef env n then
        findings := {
          severity := .warn
          rule := "W5.prop-def"
          message := s!"Prop-valued definition `{n}` is audit-visible; ensure it is definitional infrastructure, not a hidden axiom surface"
          loc := some path
        } :: findings
        if hasSuspiciousPropName n then
          findings := {
            severity := .warn
            rule := "W5.suspicious-prop-def"
            message := s!"Prop-valued definition `{n}` has a hypothesis/strengthening/vacuous-style name; verify it is not a stronger premise or placeholder"
            loc := some path
          } :: findings
      if auditedModule mod && isVacuousTheorem ci then
        findings := {
          severity := .warn
          rule := "W6.vacuous-theorem"
          message := s!"theorem `{n}` has a literal True/Unit-style conclusion; keep it out of proof chains"
          loc := some path
        } :: findings
  return findings.reverse

/-! ### W1 -- orphan files -/

def checkW1 (report : ClassificationReport) : List Finding := Id.run do
  let mut findings : List Finding := []
  for f in report.files do
    if f.cls == .orphan then
      findings := {
        severity := .warn
        rule := "W1.orphan"
        message := s!"file `{f.module}` is orphan (not on-chain, not quarantined, not standalone)"
        loc := some f.path
      } :: findings
  return findings

/-! ### Import-closure helpers for W2/W4 -/

def importsOf (edges : List (Name × List Name)) (mod : Name) : List Name :=
  match edges.find? (fun e => e.fst == mod) with
  | some (_, imports) => imports
  | none => []

partial def importClosureModules (edges : List (Name × List Name)) (root : Name) :
    List Name := Id.run do
  let mut seen : NameSet := {}
  let mut stack : List Name := [root]
  let mut result : List Name := []
  while !stack.isEmpty do
    match stack with
    | [] => break
    | mod :: rest =>
      stack := rest
      if seen.contains mod then continue
      seen := seen.insert mod
      result := mod :: result
      for imp in importsOf edges mod do
        if !seen.contains imp then
          stack := imp :: stack
  return result

def declarationsInModules (perModule : NameMap (List Name)) (modules : List Name) : List Name :=
  modules.foldl (init := []) fun acc mod =>
    (perModule.find? mod).getD [] ++ acc

/-! ### W2 -- compile-prune candidates in on-chain files -/

def checkW2 (env : Environment) (report : ClassificationReport) : List Finding := Id.run do
  let chainMods : NameSet :=
    report.files.foldl (init := {}) fun s f =>
      if f.cls == .onChain || f.cls == .cut then s.insert f.module else s
  let perModule := constantsPerModule report.cfg env
  -- Build closure-decls-per-module lookup.
  let mut closureMap : NameMap (List Name) := {}
  for f in report.files do
    closureMap := closureMap.insert f.module f.closureDecls
  -- For each on-chain file, compute the set of "modules used by my
  -- on-chain decls".  An imported module is W2-flagged only if NONE of
  -- the importer's on-chain decls reach any project decl from that
  -- module's import-closure.  This is only a compile-prune candidate:
  -- theorem bodies/proof elaboration can require imports that do not appear
  -- in this reflected constant closure.
  let mut findings : List Finding := []
  for (importer, imports) in report.importEdges do
    if !chainMods.contains importer then continue
    let myClosureDecls := (closureMap.find? importer).getD []
    -- Build the set of constants transitively used by THIS file's closure decls.
    let used : NameSet := transitiveClosure env myClosureDecls
    for imp in imports do
      let subtree := importClosureModules report.importEdges imp
      let subtreeDecls := declarationsInModules perModule subtree
      -- Skip if subtreeDecls is empty (imp may be external / declaration-free).
      if subtreeDecls.isEmpty then continue
      let consumed := subtreeDecls.any (used.contains ·)
      if !consumed then
        findings := {
          severity := .warn
          rule := "W2.unused-import"
          message := s!"compile-prune candidate: on-chain `{importer}` imports `{imp}` but reflected declarations consume no project decl from that import closure"
          loc := some (moduleNameToPath importer)
        } :: findings
  return findings

/-! ### W4 -- unused imports inside orphan/debt files -/

def checkW4 (env : Environment) (report : ClassificationReport) : List Finding := Id.run do
  if report.orphanCount > 200 then
    return [{
      severity := .warn
      rule := "W4.skipped-large-orphan-set"
      message := s!"skipped expensive unused-orphan-import scan because {report.orphanCount} loaded modules are classified orphan; use route labels and W3/W1 first, then narrow the audit entry"
      loc := none
    }]
  let classMap : NameMap FileClass :=
    report.files.foldl (init := {}) fun m f => m.insert f.module f.cls
  let perModule := constantsPerModule report.cfg env
  let mut findings : List Finding := []
  for (importer, imports) in report.importEdges do
    if classMap.find? importer != some .orphan then continue
    let importerDecls := (perModule.find? importer).getD []
    let used : NameSet := transitiveClosure env importerDecls
    for imp in imports do
      if classMap.find? imp != some .orphan then continue
      let subtree := importClosureModules report.importEdges imp
      let subtreeDecls := declarationsInModules perModule subtree
      let consumedByImporter := subtreeDecls.any (used.contains ·)
      if !consumedByImporter then
        findings := {
          severity := .warn
          rule := "W4.unused-orphan-import"
          message := s!"orphan `{importer}` imports orphan `{imp}` but its declarations consume no declarations from that import closure"
          loc := some (moduleNameToPath importer)
        } :: findings
  return findings.reverse

/-! ### W3 -- on-disk-orphan files (exist on disk, never imported) -/

/-- Emit a `W3.on-disk-orphan` warning for every `.lean` file present in
the source tree whose module is neither loaded into the audit env nor in
the quarantine registry.

`report.files` enumerates exactly the modules that ARE loaded (the audit
env walks `allImportedModuleNames`), so its module set is the
"loaded" set.  Quarantine modules are excluded (they are intentionally
off-chain).  Everything else on disk is an on-disk-orphan: the file
exists but is not imported anywhere on the chain. -/
def checkW3 (report : ClassificationReport) (diskFiles : Array String) :
    List Finding := Id.run do
  let cfg := report.cfg
  let loadedMods : NameSet :=
    report.files.foldl (init := {}) fun s f => s.insert f.module
  let qMods : NameSet :=
    report.files.foldl (init := {}) fun s f =>
      if f.cls == .quarantine then s.insert f.module else s
  let excludedMods := cfg.infraFiles.foldl (init := qMods) fun s p =>
    s.insert (pathToModuleName p)
  let orphanPaths := onDiskOrphans diskFiles loadedMods excludedMods
  let mut findings : List Finding := []
  for p in orphanPaths do
    findings := {
      severity := .warn
      rule := "W3.on-disk-orphan"
      message := s!"file `{p}` exists on disk but is not imported by the chain and is not quarantined"
      loc := some p
    } :: findings
  return findings.reverse

/-! ### Driver -/

/-- Run every invariant check that does not need the disk-file list.
Returns the merged finding list. -/
def runAll (env : Environment) (report : ClassificationReport) : List Finding :=
  checkI1 env report ++ checkI2 report ++ checkI3 report
    ++ checkI4I5W5 env report
    ++ checkW1 report ++ checkW2 env report ++ checkW4 env report

/-- Run every invariant check, including the disk-aware `W3` on-disk-orphan
check.  Use this when the disk-file inventory is available (the IO drivers
in `ChainAudit.Status` always have it). -/
def runAllWithDisk (env : Environment) (report : ClassificationReport)
    (diskFiles : Array String) : List Finding :=
  runAll env report ++ checkW3 report diskFiles

/-- Did any check produce a hard-failure finding? -/
def hasFailures (findings : List Finding) : Bool :=
  findings.any (fun f => f.severity == .fail)

end ChainAudit.Audit
