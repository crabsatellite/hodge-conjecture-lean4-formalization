/-
Copyright (c) 2026 Alex Chengyu Li. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import HodgeReduction
import Lean
import Lean.Util.Sorry

/-!
# Top-level project axiom inventory

This module is audit metadata for the master-paper trust-base prose.  It
imports the root `HodgeReduction` module, counts project-prefixed axiom
constants visible in that environment, and turns the count into an ordinary
Lean declaration.  If future imports add or remove project-level axiom
constants, the R629 equality theorem below fails until the paper snapshot is
updated.  The same file also records the R630 direct `sorryAx` count for
project declarations visible from the root import.
-/

namespace HodgeReduction.AxiomInventory

open Lean Elab Command

def isProjectAxiomConstantName (name : Name) : Bool :=
  name.toString.startsWith "HodgeReduction."

def countProjectAxiomConstantsInEnv (env : Environment) : Nat :=
  Id.run do
    let mut count := 0
    for entry in env.constants.toList do
      let name := entry.1
      let info := entry.2
      if isProjectAxiomConstantName name then
        match info with
        | ConstantInfo.axiomInfo _ => count := count + 1
        | _ => pure ()
    return count

def projectConstantInfoHasSorryAx (info : ConstantInfo) : Bool :=
  info.type.hasSorry ||
    match info.value? (allowOpaque := true) with
    | some value => value.hasSorry
    | none => false

def countProjectDeclarationsWithSorryAxInEnv (env : Environment) : Nat :=
  Id.run do
    let mut count := 0
    for entry in env.constants.toList do
      let name := entry.1
      let info := entry.2
      if isProjectAxiomConstantName name && projectConstantInfoHasSorryAx info then
        count := count + 1
    return count

elab "#declare_project_axiom_constant_count " id:ident : command => do
  let count := countProjectAxiomConstantsInEnv (← getEnv)
  let val := Syntax.mkNatLit count
  elabCommand (← `(def $id : Nat := $val))

elab "#declare_project_sorryax_declaration_count " id:ident : command => do
  let count := countProjectDeclarationsWithSorryAxInEnv (← getEnv)
  let val := Syntax.mkNatLit count
  elabCommand (← `(def $id : Nat := $val))

#declare_project_axiom_constant_count topLevelProjectAxiomConstantCount

#declare_project_sorryax_declaration_count projectDeclarationsWithSorryAxCount

def expectedTopLevelProjectAxiomConstantCount : Nat := 250

def topLevelProjectAxiomConstantCountMatchesTexStatus : Bool :=
  topLevelProjectAxiomConstantCount == expectedTopLevelProjectAxiomConstantCount

def noProjectDeclarationsWithSorryAx : Bool :=
  projectDeclarationsWithSorryAxCount == 0

def trustBaseStatus : String :=
  "axiom-backed-trust-base-not-kernel-only-mathematics"

structure ProjectAxiomTrustBaseSnapshot where
  importedRootModule : String
  projectAxiomConstantCount : Nat
  expectedProjectAxiomConstantCount : Nat
  countMatchesTexStatus : Bool
  trustBaseStatus : String
  deriving Repr, DecidableEq, Inhabited

def currentProjectAxiomTrustBaseSnapshot :
    ProjectAxiomTrustBaseSnapshot where
  importedRootModule := "HodgeReduction"
  projectAxiomConstantCount := topLevelProjectAxiomConstantCount
  expectedProjectAxiomConstantCount := expectedTopLevelProjectAxiomConstantCount
  countMatchesTexStatus := topLevelProjectAxiomConstantCountMatchesTexStatus
  trustBaseStatus := trustBaseStatus

structure ProjectSorryAxSnapshot where
  importedRootModule : String
  projectDeclarationsWithSorryAxCount : Nat
  noProjectDeclarationsWithSorryAx : Bool
  proofTermStatus : String
  deriving Repr, DecidableEq, Inhabited

def currentProjectSorryAxSnapshot : ProjectSorryAxSnapshot where
  importedRootModule := "HodgeReduction"
  projectDeclarationsWithSorryAxCount := projectDeclarationsWithSorryAxCount
  noProjectDeclarationsWithSorryAx := noProjectDeclarationsWithSorryAx
  proofTermStatus := "no-direct-sorryAx-in-project-declarations"

/-- R629 kernel-checked trust-base count for the master paper's Lean status
section. -/
theorem currentProjectAxiomTrustBaseSnapshot_eq_texStatus :
    currentProjectAxiomTrustBaseSnapshot =
      ({ importedRootModule := "HodgeReduction"
         projectAxiomConstantCount := 250
         expectedProjectAxiomConstantCount := 250
         countMatchesTexStatus := true
         trustBaseStatus :=
          "axiom-backed-trust-base-not-kernel-only-mathematics" } :
        ProjectAxiomTrustBaseSnapshot) := by
  decide

theorem topLevelProjectAxiomConstantCount_eq_texStatus :
    topLevelProjectAxiomConstantCount = 250 := by
  decide

/-- R630 kernel-checked direct `sorryAx` count for declarations visible from
the root project import. -/
theorem currentProjectSorryAxSnapshot_eq_texStatus :
    currentProjectSorryAxSnapshot =
      ({ importedRootModule := "HodgeReduction"
         projectDeclarationsWithSorryAxCount := 0
         noProjectDeclarationsWithSorryAx := true
         proofTermStatus := "no-direct-sorryAx-in-project-declarations" } :
        ProjectSorryAxSnapshot) := by
  decide

theorem projectDeclarationsWithSorryAxCount_eq_zero :
    projectDeclarationsWithSorryAxCount = 0 := by
  decide

end HodgeReduction.AxiomInventory
