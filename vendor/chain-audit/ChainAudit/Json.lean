/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import ChainAudit.Audit

/-!
# `ChainAudit.Json` -- emit the full report as a single JSON file

We hand-roll the encoder so that `ChainAudit/` has no dependency on
`Lean.Data.Json` and can be ported to projects that may use a different
toolchain version.  The output is consumed by `ChainAudit/Postprocess`
(Python).
-/

namespace ChainAudit.Json

open Lean ChainAudit

/-- Escape a `String` for JSON. -/
def jsonString (s : String) : String :=
  let escaped := s.foldl (init := "") fun acc c =>
    if c == '"' then acc ++ "\\\""
    else if c == '\\' then acc ++ "\\\\"
    else if c == '\n' then acc ++ "\\n"
    else if c == '\r' then acc ++ "\\r"
    else if c == '\t' then acc ++ "\\t"
    else if c.toNat < 0x20 then
      let hex := String.mk (Nat.toDigits 16 c.toNat)
      let padded := String.mk (List.replicate (4 - hex.length) '0') ++ hex
      acc ++ "\\u" ++ padded
    else acc ++ c.toString
  "\"" ++ escaped ++ "\""

def jsonArray (ss : List String) : String :=
  "[" ++ ",".intercalate ss ++ "]"

def jsonStringArray (ss : List String) : String :=
  jsonArray (ss.map jsonString)

def jsonField (key : String) (value : String) : String :=
  jsonString key ++ ":" ++ value

def jsonObject (fields : List String) : String :=
  "{" ++ ",".intercalate fields ++ "}"

def encodeFileEntry (f : FileEntry) : String :=
  jsonObject [
    jsonField "module" (jsonString f.module.toString),
    jsonField "path" (jsonString f.path),
    jsonField "class" (jsonString f.cls.toAscii),
    jsonField "decls" (toString f.decls),
    jsonField "axioms" (toString f.axioms),
    jsonField "closureDecls" (jsonStringArray (f.closureDecls.map (·.toString)))]

def encodeCut (c : Cut) : String :=
  jsonObject [
    jsonField "name" (jsonString c.name.toString),
    jsonField "module" (jsonString c.module.toString),
    jsonField "path" (jsonString c.path),
    jsonField "whitelisted" (if c.whitelisted then "true" else "false")]

def encodeUnderscore (u : UnderscoreEntry) : String :=
  jsonObject [
    jsonField "decl" (jsonString u.decl.toString),
    jsonField "module" (jsonString u.module.toString),
    jsonField "path" (jsonString u.path),
    jsonField "params" (jsonStringArray (u.params.map (·.toString)))]

def encodeAxiomSet (a : EndpointAxiom) : String :=
  jsonObject [
    jsonField "endpoint" (jsonString a.endpoint.toString),
    jsonField "axioms" (jsonStringArray (a.axioms.map (·.toString)))]

def encodeImportEdge (e : Name × List Name) : String :=
  jsonObject [
    jsonField "importer" (jsonString e.1.toString),
    jsonField "imports" (jsonStringArray (e.2.map (·.toString)))]

def encodeFinding (f : Finding) : String :=
  jsonObject [
    jsonField "severity" (jsonString f.severity.toAscii),
    jsonField "rule" (jsonString f.rule),
    jsonField "message" (jsonString f.message),
    jsonField "loc" (match f.loc with
                     | some l => jsonString l
                     | none => "null")]

def encodeResearchGap (g : ResearchGap) : String :=
  jsonObject [
    jsonField "id" (jsonString g.id),
    jsonField "title" (jsonString g.title),
    jsonField "status" (jsonString g.status),
    jsonField "summary" (jsonString g.summary),
    jsonField "files" (jsonStringArray g.files),
    jsonField "decls" (jsonStringArray g.decls)]

def encodeRouteKeywordRule (r : RouteKeywordRule) : String :=
  jsonObject [
    jsonField "labels" (jsonStringArray r.labels),
    jsonField "keywords" (jsonStringArray r.keywords)]

def encodeResearchChain (c : ResearchChain) : String :=
  jsonObject [
    jsonField "id" (jsonString c.id),
    jsonField "title" (jsonString c.title),
    jsonField "kind" (jsonString c.kind),
    jsonField "status" (jsonString c.status),
    jsonField "summary" (jsonString c.summary),
    jsonField "files" (jsonStringArray c.files),
    jsonField "entryDecls" (jsonStringArray c.entryDecls),
    jsonField "gapIds" (jsonStringArray c.gapIds),
    jsonField "dependsOn" (jsonStringArray c.dependsOn),
    jsonField "attackPlan" (jsonStringArray c.attackPlan),
    jsonField "successCriterion" (jsonString c.successCriterion)]

def encodeOptionalString (s : Option String) : String :=
  match s with
  | some x => jsonString x
  | none => "null"

def encodeConfig (cfg : ProjectConfig) : String :=
  jsonObject [
    jsonField "projectName" (jsonString cfg.projectName),
    jsonField "rootNamespace" (jsonString cfg.rootNamespace.toString),
    jsonField "endpoints" (jsonStringArray (cfg.endpoints.map (·.toString))),
    jsonField "openAxioms" (jsonStringArray (cfg.openAxioms.map (·.toString))),
    jsonField "quarantine" (jsonStringArray cfg.quarantine),
    jsonField "infraFiles" (jsonStringArray cfg.infraFiles),
    jsonField "researchGaps" (jsonArray (cfg.researchGaps.map encodeResearchGap)),
    jsonField "researchChains" (jsonArray (cfg.researchChains.map encodeResearchChain)),
    jsonField "primaryGapId" (encodeOptionalString cfg.primaryGapId),
    jsonField "replacementRouteId" (encodeOptionalString cfg.replacementRouteId),
    jsonField "gapPriority" (jsonStringArray cfg.gapPriority),
    jsonField "routeKeywordRules" (jsonArray (cfg.routeKeywordRules.map encodeRouteKeywordRule)),
    jsonField "outputDir" (jsonString cfg.outputDir.toString),
    jsonField "kernelAxioms" (jsonStringArray (cfg.kernelAxioms.map (·.toString))),
    jsonField "trustedAxioms" (jsonStringArray (cfg.trustedAxioms.map (·.toString)))]

/-- Encode the full report + findings as a single JSON object. -/
def encode (report : ClassificationReport) (findings : List Finding)
    (diskFiles : Array String) : String :=
  jsonObject [
    jsonField "config" (encodeConfig report.cfg),
    jsonField "summary" (jsonObject [
      jsonField "closureConstants" (toString report.closureConstants),
      jsonField "closureModules" (toString report.closureModules),
      jsonField "onChainCount" (toString report.onChainCount),
      jsonField "cutCount" (toString report.cutCount),
      jsonField "quarantineCount" (toString report.quarantineCount),
      jsonField "infraCount" (toString report.infraCount),
      jsonField "orphanCount" (toString report.orphanCount),
      jsonField "diskFileCount" (toString diskFiles.size)]),
    jsonField "files" (jsonArray (report.files.map encodeFileEntry)),
    jsonField "diskFiles" (jsonStringArray diskFiles.toList),
    jsonField "cuts" (jsonArray (report.cuts.map encodeCut)),
    jsonField "underscores" (jsonArray (report.underscores.map encodeUnderscore)),
    jsonField "axiomSets" (jsonArray (report.axiomSets.map encodeAxiomSet)),
    jsonField "importEdges" (jsonArray (report.importEdges.map encodeImportEdge)),
    jsonField "findings" (jsonArray (findings.map encodeFinding))]

end ChainAudit.Json
