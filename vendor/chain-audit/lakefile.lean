import Lake
open Lake DSL

/-!
Build artifacts are isolated by Lean version because this package is used
as a path dependency by projects on different Lean releases. In particular,
Lean 4.30 writes libraries under `lib/lean`, while Lean 4.16 writes them
under `lib`; sharing one `.lake/build` directory can make the older
`lib/lean` directory shadow the core `Lean` module on Windows.
-/

def chainAuditBuildDir : System.FilePath :=
  System.FilePath.mk (".lake/build-" ++ Lean.versionString)

package chainAudit where
  version := v!"0.1.0"
  buildDir := chainAuditBuildDir
  leanOptions := #[
    { name := `pp.unicode.fun, value := true },
    { name := `autoImplicit, value := false }
  ]

@[default_target]
lean_lib ChainAudit where
  roots := #[`ChainAudit]
